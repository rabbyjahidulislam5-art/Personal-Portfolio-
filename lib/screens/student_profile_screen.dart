import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:url_launcher/url_launcher.dart';

import '../data/student_profile.dart';
import '../l10n/app_labels.dart';
import '../theme/app_theme.dart';
import '../widgets/academic_overview.dart';
import '../widgets/adaptive_pair.dart';
import '../widgets/github_link_card.dart';
import '../widgets/info_row.dart';
import '../widgets/profile_details.dart';
import '../widgets/profile_hero.dart';
import '../widgets/profile_entrance.dart';
import '../widgets/project_card.dart';
import '../widgets/section_card.dart';
import '../widgets/skill_group.dart';

class StudentProfileScreen extends StatefulWidget {
  const StudentProfileScreen({
    super.key,
    required this.themeMode,
    required this.onThemeChanged,
    this.imagePicker,
    this.openUrl,
  });

  final ThemeMode themeMode;
  final ValueChanged<ThemeMode> onThemeChanged;
  final ImagePicker? imagePicker;
  final Future<bool> Function(Uri)? openUrl;

  @override
  State<StudentProfileScreen> createState() => _StudentProfileScreenState();
}

class _StudentProfileScreenState extends State<StudentProfileScreen> {
  late final ImagePicker _picker = widget.imagePicker ?? ImagePicker();
  Uint8List? _photo;
  bool _pickingPhoto = false;
  bool _revealPrivate = false;
  bool _personalExpanded = false;
  bool _contactExpanded = false;
  bool _openingGithub = false;

  @override
  void initState() {
    super.initState();
    if (!kIsWeb && defaultTargetPlatform == TargetPlatform.android) {
      _pickingPhoto = true;
      WidgetsBinding.instance.addPostFrameCallback((_) => _recoverPhoto());
    }
  }

  void _feedback(String message, VoidCallback retry) {
    if (!mounted) return;
    ScaffoldMessenger.of(context)
      ..removeCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          action: SnackBarAction(label: AppLabels.retry, onPressed: retry),
        ),
      );
  }

  Future<void> _recoverPhoto() async {
    if (!mounted) return;
    try {
      final lost = await _picker.retrieveLostData();
      if (lost.exception != null) throw lost.exception!;
      if (lost.files?.isNotEmpty ?? false) await _readPhoto(lost.files!.first);
    } catch (_) {
      _feedback(AppLabels.photoFailure, _pickPhoto);
    } finally {
      if (mounted) setState(() => _pickingPhoto = false);
    }
  }

  Future<void> _pickPhoto() async {
    if (_pickingPhoto) return;
    setState(() => _pickingPhoto = true);
    try {
      final file = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
        requestFullMetadata: false,
      );
      if (file != null && mounted) await _readPhoto(file);
    } catch (_) {
      _feedback(AppLabels.photoFailure, _pickPhoto);
    } finally {
      if (mounted) setState(() => _pickingPhoto = false);
    }
  }

  Future<void> _readPhoto(XFile file) async {
    // Bound both encoded input and decoded avatar memory before replacing it.
    if (await file.length() > 20 * 1024 * 1024) {
      throw const FormatException('Photo is too large');
    }
    final buffer = await ui.ImmutableBuffer.fromUint8List(
      await file.readAsBytes(),
    );
    ui.ImageDescriptor? descriptor;
    ui.Codec? codec;
    ui.Image? image;
    try {
      descriptor = await ui.ImageDescriptor.encoded(buffer);
      final longest = descriptor.width > descriptor.height
          ? descriptor.width
          : descriptor.height;
      final ratio = longest > 512 ? 512 / longest : 1.0;
      codec = await descriptor.instantiateCodec(
        targetWidth: (descriptor.width * ratio).round().clamp(1, 512),
        targetHeight: (descriptor.height * ratio).round().clamp(1, 512),
      );
      image = (await codec.getNextFrame()).image;
      final png = await image.toByteData(format: ui.ImageByteFormat.png);
      if (png == null) throw const FormatException('Invalid image');
      if (mounted) setState(() => _photo = png.buffer.asUint8List());
    } finally {
      image?.dispose();
      codec?.dispose();
      descriptor?.dispose();
      buffer.dispose();
    }
  }

  Future<void> _openGithub() async {
    if (_openingGithub) return;
    setState(() => _openingGithub = true);
    try {
      final uri = Uri.parse(StudentProfile.githubUrl);
      final opened = widget.openUrl != null
          ? await widget.openUrl!(uri)
          : await launchUrl(uri, mode: LaunchMode.externalApplication);
      if (!opened) _feedback(AppLabels.githubFailure, _openGithub);
    } catch (_) {
      _feedback(AppLabels.githubFailure, _openGithub);
    } finally {
      if (mounted) setState(() => _openingGithub = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scale = MediaQuery.textScalerOf(context).scale(18) / 18;
    final animation = MediaQuery.disableAnimationsOf(context)
        ? AnimationStyle.noAnimation
        : const AnimationStyle(duration: AppStyle.motion);

    return DisplayFeatureSubScreen(
      anchorPoint: Directionality.of(context) == TextDirection.ltr
          ? Offset.zero
          : const Offset(double.maxFinite, 0),
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: true,
          toolbarHeight: 56 + ((scale - 1).clamp(0, 2) * 40),
          title: const Text(AppLabels.appTitle),
          actions: [
            PopupMenuButton<ThemeMode>(
              key: const ValueKey('appearance-menu'),
              tooltip: AppLabels.appearance,
              icon: const Icon(Icons.palette_outlined),
              popUpAnimationStyle: animation,
              initialValue: widget.themeMode,
              onSelected: widget.onThemeChanged,
              itemBuilder: (_) => [
                for (final mode in ThemeMode.values)
                  CheckedPopupMenuItem(
                    value: mode,
                    checked: widget.themeMode == mode,
                    child: Text(switch (mode) {
                      ThemeMode.system => AppLabels.system,
                      ThemeMode.light => AppLabels.light,
                      ThemeMode.dark => AppLabels.dark,
                    }),
                  ),
              ],
            ),
            PopupMenuButton<bool>(
              key: const ValueKey('privacy-menu'),
              tooltip: AppLabels.privacy,
              icon: Icon(
                _revealPrivate
                    ? Icons.visibility_outlined
                    : Icons.visibility_off_outlined,
              ),
              popUpAnimationStyle: animation,
              onSelected: (value) => setState(() => _revealPrivate = value),
              itemBuilder: (_) => [
                CheckedPopupMenuItem(
                  value: false,
                  checked: !_revealPrivate,
                  child: const Text(AppLabels.hidePrivateDetails),
                ),
                CheckedPopupMenuItem(
                  value: true,
                  checked: _revealPrivate,
                  child: const Text(AppLabels.showPrivateDetails),
                ),
                const PopupMenuDivider(),
                const PopupMenuItem<bool>(
                  enabled: false,
                  child: Text(AppLabels.privacyExplanation),
                ),
              ],
            ),
            const SizedBox(width: AppSpace.sm),
          ],
        ),
        body: DecoratedBox(
          decoration: BoxDecoration(
            gradient: AppStyle.background(theme.brightness),
          ),
          child: SafeArea(
            top: false,
            child: LayoutBuilder(
              builder: (context, constraints) => SingleChildScrollView(
                key: const PageStorageKey('profile-scroll'),
                padding: EdgeInsets.all(
                  constraints.maxWidth < 600 ? AppSpace.lg : AppSpace.xxl,
                ),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(
                      maxWidth: AppStyle.maxContentWidth,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      spacing: AppSpace.lg,
                      children: [
                        ProfileEntrance(
                          child: ProfileHero(
                            photo: _photo == null ? null : MemoryImage(_photo!),
                            pickingPhoto: _pickingPhoto,
                            revealPrivate: _revealPrivate,
                            onChangePhoto: _pickPhoto,
                            onRemovePhoto: () {
                              if (!_pickingPhoto) setState(() => _photo = null);
                            },
                          ),
                        ),
                        const ProfileEntrance(
                          intervalStart: 0.12,
                          child: AcademicOverview(),
                        ),
                        const AdaptivePair(
                          first: SectionCard(
                            title: AppLabels.aboutMe,
                            icon: Icons.person_outline_rounded,
                            child: Text(StudentProfile.about),
                          ),
                          second: SectionCard(
                            title: AppLabels.educationDetails,
                            icon: Icons.school_outlined,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                InfoRow(
                                  label: AppLabels.batch,
                                  value: StudentProfile.batch,
                                ),
                                InfoRow(
                                  label: AppLabels.admissionDate,
                                  value: StudentProfile.admissionDate,
                                ),
                              ],
                            ),
                          ),
                        ),
                        SectionCard(
                          title: AppLabels.technicalSkills,
                          icon: Icons.code_rounded,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            spacing: AppSpace.xl,
                            children: [
                              for (final group
                                  in StudentProfile.skillGroups.entries)
                                SkillGroup(
                                  title: group.key,
                                  skills: group.value,
                                ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(
                            AppSpace.xs,
                            AppSpace.sm,
                            0,
                            0,
                          ),
                          child: Semantics(
                            header: true,
                            child: Text(
                              AppLabels.projects,
                              style: theme.textTheme.titleLarge,
                            ),
                          ),
                        ),
                        ProjectCard(
                          project: StudentProfile.projects[0],
                          icon: Icons.diversity_1_outlined,
                        ),
                        ProjectCard(
                          project: StudentProfile.projects[1],
                          icon: Icons.account_balance_outlined,
                        ),
                        const AdaptivePair(
                          first: SectionCard(
                            title: AppLabels.softSkills,
                            icon: Icons.people_outline_rounded,
                            child: SkillGroup(
                              skills: StudentProfile.softSkills,
                            ),
                          ),
                          second: SectionCard(
                            title: AppLabels.careerGoal,
                            icon: Icons.north_east_rounded,
                            child: Text(StudentProfile.careerGoal),
                          ),
                        ),
                        const SectionCard(
                          title: AppLabels.interestsAndHobbies,
                          icon: Icons.explore_outlined,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            spacing: AppSpace.xl,
                            children: [
                              SkillGroup(
                                title: AppLabels.technicalInterests,
                                skills: StudentProfile.technicalInterests,
                              ),
                              SkillGroup(
                                title: AppLabels.hobbies,
                                skills: StudentProfile.hobbies,
                              ),
                            ],
                          ),
                        ),
                        ProfileDetails(
                          revealPrivate: _revealPrivate,
                          personalExpanded: _personalExpanded,
                          contactExpanded: _contactExpanded,
                          onPersonalExpansionChanged: (value) =>
                              setState(() => _personalExpanded = value),
                          onContactExpansionChanged: (value) =>
                              setState(() => _contactExpanded = value),
                        ),
                        GitHubLinkCard(
                          onOpen: _openGithub,
                          opening: _openingGithub,
                        ),
                        const SizedBox(height: AppSpace.sm),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
