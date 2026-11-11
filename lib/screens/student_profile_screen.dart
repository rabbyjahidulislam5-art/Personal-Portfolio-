import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

import '../data/student_profile.dart';
import '../l10n/app_labels.dart';
import '../theme/app_theme.dart';
import '../widgets/academic_overview.dart';
import '../widgets/adaptive_grid.dart';
import '../widgets/ambient_background.dart';
import '../widgets/appearance_footer.dart';
import '../widgets/github_link_card.dart';
import '../widgets/glass_card.dart';
import '../widgets/info_row.dart';
import '../widgets/profile_entrance.dart';
import '../widgets/profile_hero.dart';
import '../widgets/project_card.dart';
import '../widgets/section_card.dart';
import '../widgets/section_nav_bar.dart';
import '../widgets/skill_group.dart';

class StudentProfileScreen extends StatefulWidget {
  const StudentProfileScreen({
    super.key,
    required this.onThemeChanged,
    this.openUrl,
  });

  final ValueChanged<ThemeMode> onThemeChanged;
  final Future<bool> Function(Uri)? openUrl;

  @override
  State<StudentProfileScreen> createState() => _StudentProfileScreenState();
}

class _StudentProfileScreenState extends State<StudentProfileScreen> {
  static final _githubUri = Uri.parse(StudentProfile.githubUrl);
  static const _projectIcons = [
    Icons.diversity_1_outlined,
    Icons.account_balance_wallet_outlined,
    Icons.add_road_outlined,
  ];
  // Order matches the section navigation.
  static const _profile = 0, _academic = 1, _skills = 2, _projects = 3;
  static const _contact = 4;

  final _scroll = ScrollController();
  final _titleCollapsed = ValueNotifier(false);
  final _section = ValueNotifier(_profile);
  final _sectionKeys = List.generate(SectionNavBar.count, (_) => GlobalKey());
  int _jump = 0;
  bool _jumping = false;
  // How far through the current section the reader is, from 0 to 1.
  double _progress = 0;
  double? _width;
  Uri? _opening;

  @override
  void initState() {
    super.initState();
    _scroll.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scroll.dispose();
    _titleCollapsed.dispose();
    _section.dispose();
    super.dispose();
  }

  double? _sectionOffset(int section) {
    final box = _sectionKeys[section].currentContext?.findRenderObject();
    if (box == null) return null;
    return RenderAbstractViewport.of(box).getOffsetToReveal(box, 0).offset;
  }

  // Runs per scroll tick: a handful of short render-tree lookups, and only the
  // title and the navigation listen to the results, so the screen itself
  // never rebuilds while scrolling.
  void _onScroll() {
    final offset = _scroll.offset;
    final hero = _sectionKeys[_profile].currentContext?.findRenderObject();
    _titleCollapsed.value =
        hero is RenderBox && offset > hero.size.height * 0.6;
    // A tapped destination stays selected until the next manual scroll.
    if (_jumping) return;
    final starts = [
      for (var section = _profile; section <= _contact; section++)
        _sectionOffset(section),
    ];
    var current = _profile;
    for (var section = _academic; section <= _contact; section++) {
      final start = starts[section];
      if (start != null && start <= offset + AppSpace.xxl) current = section;
    }
    final max = _scroll.position.maxScrollExtent;
    // The last section may be too short to ever reach the top.
    if (offset > 0 && max - offset < 1) current = _contact;
    _section.value = current;
    final start = starts[current] ?? 0;
    final end = (current < _contact ? starts[current + 1] : null) ?? max;
    _progress = end > start
        ? ((offset - start) / (end - start)).clamp(0.0, 1.0)
        : 0;
  }

  // Content reflows when the width changes (rotation, split screen), so the
  // old pixel offset would land somewhere else. Return to the same point in
  // the same section instead.
  void _keepPlace(double width) {
    final changed = _width != null && _width != width;
    _width = width;
    if (!changed || !_scroll.hasClients || _scroll.offset <= 0) return;
    final section = _section.value;
    final progress = _progress;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || !_scroll.hasClients) return;
      final start = _sectionOffset(section);
      if (start == null) return;
      final max = _scroll.position.maxScrollExtent;
      final end =
          (section < _contact ? _sectionOffset(section + 1) : null) ?? max;
      _scroll.jumpTo((start + (end - start) * progress).clamp(0.0, max));
    });
  }

  Future<void> _goToSection(int section) async {
    final start = _sectionOffset(section);
    if (start == null) return;
    final target = section == _profile
        ? 0.0
        : (start - AppSpace.lg).clamp(0.0, _scroll.position.maxScrollExtent);
    final jump = ++_jump;
    _jumping = true;
    _section.value = section;
    if (MediaQuery.disableAnimationsOf(context)) {
      _scroll.jumpTo(target);
    } else {
      await _scroll.animateTo(
        target,
        duration: AppStyle.entrance,
        curve: AppStyle.curve,
      );
    }
    if (jump == _jump) _jumping = false;
  }

  void _feedback(String message, [VoidCallback? retry]) {
    if (!mounted) return;
    ScaffoldMessenger.of(context)
      ..removeCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          action: retry == null
              ? null
              : SnackBarAction(label: AppLabels.retry, onPressed: retry),
        ),
      );
  }

  Future<void> _open(Uri uri, String failure) async {
    if (_opening != null) return;
    setState(() => _opening = uri);
    void failed() => _feedback(failure, () => _open(uri, failure));
    try {
      final opened = widget.openUrl != null
          ? await widget.openUrl!(uri)
          : await launchUrl(uri, mode: LaunchMode.externalApplication);
      if (!opened) failed();
    } catch (_) {
      failed();
    } finally {
      if (mounted) setState(() => _opening = null);
    }
  }

  Future<void> _copy(String label, String value) async {
    try {
      await Clipboard.setData(ClipboardData(text: value));
      // The message names the field only, never the copied value.
      _feedback(AppLabels.copied(label));
    } catch (_) {
      _feedback(AppLabels.copyFailure, () => _copy(label, value));
    }
  }

  /// [index] staggers the sections that are on screen at launch.
  Widget _reveal(
    Widget child, {
    int index = 0,
    int? section,
    EntranceDirection direction = EntranceDirection.bottom,
  }) => ProfileEntrance(
    key: section == null ? null : _sectionKeys[section],
    index: index,
    direction: direction,
    child: child,
  );

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final scale = MediaQuery.textScalerOf(context).scale(18) / 18;
    final reducedMotion = MediaQuery.disableAnimationsOf(context);

    return Stack(
      fit: StackFit.expand,
      children: [
        const AmbientBackground(),
        DisplayFeatureSubScreen(
          anchorPoint: Directionality.of(context) == TextDirection.ltr
              ? Offset.zero
              : const Offset(double.maxFinite, 0),
          // Layout follows the space this screen really has, so a phone on
          // its side, a split screen and a tablet each get what fits.
          child: LayoutBuilder(
            builder: (context, screen) {
              final short = screen.maxHeight < AppBreak.short;
              final narrow = screen.maxWidth < AppBreak.compact;
              final gutter = narrow ? AppSpace.lg : AppSpace.xxl;
              _keepPlace(screen.maxWidth);
              // A camera cutout insets one side of a phone held sideways.
              // Using the larger inset on both sides keeps the header, every
              // card and the bottom bar centred, with equal margins.
              final media = MediaQuery.of(context);
              EdgeInsets even(EdgeInsets insets) {
                final side = math.max(insets.left, insets.right);
                return insets.copyWith(left: side, right: side);
              }

              final page = Scaffold(
                backgroundColor: Colors.transparent,
                appBar: AppBar(
                  automaticallyImplyLeading: true,
                  // The title starts on the same line as the cards' edge.
                  titleSpacing: gutter,
                  toolbarHeight:
                      (short ? 48 : 56) + ((scale - 1).clamp(0, 2) * 40),
                  flexibleSpace: const GlassCard(
                    level: GlassLevel.bar,
                    padding: EdgeInsets.zero,
                    blurSigma: AppStyle.barBlur,
                    child: SizedBox.expand(),
                  ),
                  // Shows the page name at the top and the student's name
                  // once the hero has scrolled away. Only this rebuilds.
                  title: ValueListenableBuilder<bool>(
                    valueListenable: _titleCollapsed,
                    builder: (context, collapsed, _) => AnimatedSwitcher(
                      duration: reducedMotion ? Duration.zero : AppStyle.motion,
                      layoutBuilder: (current, previous) => Stack(
                        alignment: AlignmentDirectional.centerStart,
                        children: [...previous, ?current],
                      ),
                      child: collapsed
                          ? Column(
                              key: const ValueKey('title-name'),
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  AppLabels.appTitle,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: theme.textTheme.labelSmall?.copyWith(
                                    color: colors.onSurfaceVariant,
                                  ),
                                ),
                                const Text(
                                  StudentProfile.name,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            )
                          : const Text(
                              AppLabels.appTitle,
                              key: ValueKey('title-page'),
                            ),
                    ),
                  ),
                ),
                // The section bar stays at the bottom in every orientation.
                bottomNavigationBar: ProfileEntrance(
                  direction: EntranceDirection.bottom,
                  child: SectionNavBar(
                    selected: _section,
                    onSelected: _goToSection,
                  ),
                ),
                body: SafeArea(
                  top: false,
                  child: SingleChildScrollView(
                    key: const PageStorageKey('profile-scroll'),
                    controller: _scroll,
                    // Content stays painted beneath the glass bars so their
                    // blur has something to show, while the viewport itself
                    // ends at the bars: taps and scroll-into-view never land
                    // under them.
                    clipBehavior: Clip.none,
                    padding: EdgeInsets.symmetric(
                      horizontal: gutter,
                      vertical: short ? AppSpace.lg : gutter,
                    ),
                    child: Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(
                          maxWidth: AppStyle.maxContentWidth,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          spacing: AppSpace.lg,
                          children: _sections(theme),
                        ),
                      ),
                    ),
                  ),
                ),
              );
              return MediaQuery(
                data: media.copyWith(
                  padding: even(media.padding),
                  viewPadding: even(media.viewPadding),
                ),
                child: page,
              );
            },
          ),
        ),
      ],
    );
  }

  List<Widget> _sections(ThemeData theme) => [
    _reveal(
      section: _profile,
      direction: EntranceDirection.top,
      const ProfileHero(),
    ),
    _reveal(
      index: 1,
      section: _academic,
      direction: EntranceDirection.left,
      const AcademicOverview(),
    ),
    _reveal(
      direction: EntranceDirection.right,
      const SectionCard(
        title: AppLabels.aboutMe,
        icon: Icons.person_outlined,
        child: Text(StudentProfile.about),
      ),
    ),
    _reveal(
      direction: EntranceDirection.left,
      SectionCard(
        title: AppLabels.educationDetails,
        icon: Icons.school_outlined,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: AppSpace.lg,
          children: [
            AdaptiveGrid(
              minTileWidth: AppBreak.detailTile,
              maxColumns: 3,
              runSpacing: 0,
              children: [
                InfoRow(label: AppLabels.major, value: StudentProfile.major),
                InfoRow(label: AppLabels.batch, value: StudentProfile.batch),
                InfoRow(
                  label: AppLabels.admissionDate,
                  value: StudentProfile.admissionDate,
                ),
                InfoRow(
                  label: AppLabels.totalCredits,
                  value: '${StudentProfile.totalCredits}',
                ),
                InfoRow(
                  label: AppLabels.cgpaScale,
                  value: StudentProfile.cgpaScale,
                ),
              ],
            ),
            AdaptiveGrid(
              minTileWidth: AppBreak.pairTile,
              maxColumns: 2,
              children: [
                for (final (index, record)
                    in StudentProfile.educationHistory.indexed)
                  ProfileEntrance(
                    index: index,
                    direction: index.isEven
                        ? EntranceDirection.left
                        : EntranceDirection.right,
                    child: _EducationRecordCard(record: record),
                  ),
              ],
            ),
          ],
        ),
      ),
    ),
    _reveal(direction: EntranceDirection.right, const CourseworkCard()),
    _reveal(
      section: _skills,
      direction: EntranceDirection.left,
      SectionCard(
        title: AppLabels.technicalSkills,
        icon: Icons.code_outlined,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: AppSpace.xl,
          children: [
            for (final (index, group)
                in StudentProfile.skillGroups.entries.indexed)
              ProfileEntrance(
                index: index,
                direction: index.isEven
                    ? EntranceDirection.left
                    : EntranceDirection.right,
                child: SkillGroup(title: group.key, skills: group.value),
              ),
          ],
        ),
      ),
    ),
    _reveal(
      section: _projects,
      direction: EntranceDirection.right,
      SectionCard(
        title: AppLabels.projects,
        icon: Icons.folder_outlined,
        child: AdaptiveGrid(
          minTileWidth: AppBreak.projectTile,
          spacing: AppSpace.md,
          fillLastRow: true,
          children: [
            for (final (index, project) in StudentProfile.projects.indexed)
              // Each project arrives on its own; side by side, the second
              // follows a beat after the first.
              ProfileEntrance(
                index: index % 2,
                direction: index.isEven
                    ? EntranceDirection.left
                    : EntranceDirection.right,
                child: ProjectCard(
                  project: project,
                  icon: _projectIcons[index % _projectIcons.length],
                  onOpen: (url) => _open(Uri.parse(url), AppLabels.openFailure),
                ),
              ),
          ],
        ),
      ),
    ),
    _reveal(
      direction: EntranceDirection.bottom,
      const AdaptiveGrid(
        minTileWidth: AppBreak.pairTile,
        children: [
          SectionCard(
            title: AppLabels.softSkills,
            icon: Icons.groups_outlined,
            child: SkillGroup(skills: StudentProfile.softSkills),
          ),
          SectionCard(
            title: AppLabels.careerGoal,
            icon: Icons.flag_outlined,
            child: Text(StudentProfile.careerGoal),
          ),
        ],
      ),
    ),
    _reveal(
      direction: EntranceDirection.right,
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
    ),
    _reveal(
      section: _contact,
      direction: EntranceDirection.left,
      AdaptiveGrid(
        minTileWidth: AppBreak.pairTile,
        children: [
          const SectionCard(
            title: AppLabels.personalInformation,
            icon: Icons.badge_outlined,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                InfoRow(label: AppLabels.gender, value: StudentProfile.gender),
                InfoRow(
                  label: AppLabels.nationality,
                  value: StudentProfile.nationality,
                ),
                InfoRow(label: AppLabels.city, value: StudentProfile.city),
                InfoRow(
                  label: AppLabels.country,
                  value: StudentProfile.country,
                ),
              ],
            ),
          ),
          SectionCard(
            title: AppLabels.contactInformation,
            icon: Icons.contact_mail_outlined,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _phoneRow(AppLabels.phone, StudentProfile.phone),
                _emailRow(AppLabels.email, StudentProfile.email),
                _emailRow(
                  AppLabels.universityEmail,
                  StudentProfile.universityEmail,
                ),
                InfoRow(
                  label: AppLabels.universityAddress,
                  value: StudentProfile.universityAddress,
                  onCopy: () => _copy(
                    AppLabels.universityAddress,
                    StudentProfile.universityAddress,
                  ),
                ),
                const Divider(height: AppSpace.lg),
                InfoRow(
                  label: AppLabels.presentAddress,
                  value: StudentProfile.presentAddress,
                  onCopy: () => _copy(
                    AppLabels.presentAddress,
                    StudentProfile.presentAddress,
                  ),
                ),
                const Divider(height: AppSpace.lg),
                InfoRow(
                  label: AppLabels.permanentAddress,
                  value: StudentProfile.permanentAddress,
                  onCopy: () => _copy(
                    AppLabels.permanentAddress,
                    StudentProfile.permanentAddress,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
    _reveal(
      direction: EntranceDirection.left,
      GitHubLinkCard(
        onOpen: () => _open(_githubUri, AppLabels.githubFailure),
        opening: _opening == _githubUri,
      ),
    ),
    _reveal(
      direction: EntranceDirection.bottom,
      AppearanceFooter(onChanged: widget.onThemeChanged),
    ),
  ];

  InfoRow _phoneRow(String label, String phone) => InfoRow(
    label: label,
    value: phone,
    onCopy: () => _copy(label, phone),
    onAction: () =>
        _open(Uri(scheme: 'tel', path: phone), AppLabels.openFailure),
    actionLabel: AppLabels.callPhone,
  );

  /// An address that opens the mail app when tapped and can be copied.
  InfoRow _emailRow(String label, String address) => InfoRow(
    label: label,
    value: address,
    onCopy: () => _copy(label, address),
    onAction: () =>
        _open(Uri(scheme: 'mailto', path: address), AppLabels.openFailure),
    actionLabel: AppLabels.sendEmail,
  );
}

class _EducationRecordCard extends StatelessWidget {
  const _EducationRecordCard({required this.record});

  final EducationRecord record;

  @override
  Widget build(BuildContext context) => GlassCard(
    level: GlassLevel.inset,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GlassChip(record.qualification, accent: true),
        const SizedBox(height: AppSpace.md),
        Semantics(
          header: true,
          child: Text(
            record.institution,
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
        const SizedBox(height: AppSpace.sm),
        InfoRow(label: AppLabels.group, value: record.group),
        if (record.board != null)
          InfoRow(label: AppLabels.board, value: record.board!),
        InfoRow(label: AppLabels.academicBatch, value: record.academicBatch),
      ],
    ),
  );
}
