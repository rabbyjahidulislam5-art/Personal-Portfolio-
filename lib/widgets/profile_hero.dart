import 'package:flutter/material.dart';

import '../data/student_profile.dart';
import '../l10n/app_labels.dart';
import '../theme/app_theme.dart';
import 'glass_card.dart';

class ProfileHero extends StatelessWidget {
  const ProfileHero({
    super.key,
    required this.photo,
    required this.pickingPhoto,
    required this.revealPrivate,
    required this.onChangePhoto,
    this.onRemovePhoto,
  });

  final ImageProvider? photo;
  final bool pickingPhoto;
  final bool revealPrivate;
  final VoidCallback onChangePhoto;
  final VoidCallback? onRemovePhoto;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final reducedMotion = MediaQuery.disableAnimationsOf(context);

    return GlassCard(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final textScale = MediaQuery.textScalerOf(context).scale(16) / 16;
          final horizontal = constraints.maxWidth >= 720 && textScale <= 1.3;
          final alignment = horizontal
              ? CrossAxisAlignment.start
              : CrossAxisAlignment.center;
          final textAlign = horizontal ? TextAlign.start : TextAlign.center;
          final avatar = Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(AppSpace.xs),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: colors.primary.withValues(alpha: 0.18),
                  ),
                  gradient: LinearGradient(
                    begin: AlignmentDirectional.topStart,
                    end: AlignmentDirectional.bottomEnd,
                    colors: [colors.surface, colors.primaryContainer],
                  ),
                ),
                child: Semantics(
                  image: true,
                  label: photo == null
                      ? AppLabels.profileInitials
                      : AppLabels.profilePhoto,
                  child: ExcludeSemantics(
                    child: AnimatedSwitcher(
                      duration: reducedMotion ? Duration.zero : AppStyle.motion,
                      switchInCurve: AppStyle.curve,
                      switchOutCurve: AppStyle.curve,
                      child: CircleAvatar(
                        key: ValueKey(photo),
                        radius: 44,
                        backgroundColor: colors.primary,
                        foregroundColor: colors.onPrimary,
                        backgroundImage: photo,
                        child: photo == null
                            ? Text(
                                StudentProfile.initials,
                                style: theme.textTheme.headlineMedium?.copyWith(
                                  color: colors.onPrimary,
                                  fontWeight: FontWeight.w600,
                                ),
                              )
                            : null,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: AppSpace.xs),
              TextButton(
                key: const ValueKey('change-photo'),
                onPressed: pickingPhoto ? null : onChangePhoto,
                style: TextButton.styleFrom(
                  minimumSize: const Size(48, 48),
                  padding: const EdgeInsets.symmetric(horizontal: AppSpace.sm),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      pickingPhoto
                          ? Icons.hourglass_top_rounded
                          : Icons.add_a_photo_outlined,
                      size: 18,
                    ),
                    const SizedBox(width: AppSpace.sm),
                    Flexible(
                      child: Text(
                        pickingPhoto
                            ? AppLabels.choosingPhoto
                            : AppLabels.changePhoto,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
              if (photo != null && onRemovePhoto != null)
                TextButton(
                  key: const ValueKey('remove-photo'),
                  onPressed: pickingPhoto ? null : onRemovePhoto,
                  style: TextButton.styleFrom(
                    foregroundColor: colors.onSurfaceVariant,
                    minimumSize: const Size(48, 48),
                  ),
                  child: const Text(
                    AppLabels.removePhoto,
                    textAlign: TextAlign.center,
                  ),
                ),
            ],
          );
          final identity = Column(
            crossAxisAlignment: alignment,
            children: [
              Semantics(
                header: true,
                child: Text(
                  StudentProfile.name,
                  textAlign: textAlign,
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.7,
                  ),
                ),
              ),
              const SizedBox(height: AppSpace.sm),
              Text(
                StudentProfile.university,
                textAlign: textAlign,
                style: theme.textTheme.titleMedium?.copyWith(
                  color: colors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: AppSpace.lg),
              Container(
                width: AppSpace.xxl,
                height: 3,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(AppStyle.chipRadius),
                  gradient: LinearGradient(
                    colors: [colors.primary, colors.tertiary],
                  ),
                ),
              ),
              const SizedBox(height: AppSpace.lg),
              Text(
                StudentProfile.department,
                textAlign: textAlign,
                style: theme.textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: AppSpace.xs),
              Text(
                StudentProfile.degree,
                textAlign: textAlign,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colors.onSurfaceVariant,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: AppSpace.lg),
              DecoratedBox(
                decoration: BoxDecoration(
                  color: colors.surface.withValues(alpha: 0.7),
                  borderRadius: BorderRadius.circular(AppStyle.chipRadius),
                  border: Border.all(color: AppStyle.border(colors)),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpace.md,
                    vertical: AppSpace.sm,
                  ),
                  child: Wrap(
                    alignment: horizontal
                        ? WrapAlignment.start
                        : WrapAlignment.center,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    spacing: AppSpace.sm,
                    runSpacing: AppSpace.xs,
                    children: [
                      ExcludeSemantics(
                        child: Icon(
                          revealPrivate
                              ? Icons.badge_outlined
                              : Icons.lock_outline_rounded,
                          size: 16,
                          color: colors.onSurfaceVariant,
                        ),
                      ),
                      Text(
                        AppLabels.studentId,
                        style: theme.textTheme.labelLarge?.copyWith(
                          color: colors.onSurfaceVariant,
                        ),
                      ),
                      Text(
                        revealPrivate
                            ? StudentProfile.studentId
                            : AppLabels.hidden,
                        key: const ValueKey('student-id-value'),
                        textAlign: textAlign,
                        style: theme.textTheme.labelLarge?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );

          if (horizontal) {
            return Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(width: 160, child: avatar),
                const SizedBox(width: AppSpace.xxl),
                Expanded(child: identity),
              ],
            );
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              avatar,
              const SizedBox(height: AppSpace.sm),
              identity,
            ],
          );
        },
      ),
    );
  }
}
