import 'package:flutter/material.dart';

import '../data/student_profile.dart';
import '../l10n/app_labels.dart';
import '../theme/app_theme.dart';
import 'glass_card.dart';

class ProfileHero extends StatelessWidget {
  const ProfileHero({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final screen = MediaQuery.sizeOf(context);
    // A phone on its side: tighter padding, smaller photo and name.
    final short = screen.height < AppBreak.short;
    final motion = MediaQuery.disableAnimationsOf(context)
        ? Duration.zero
        : AppStyle.motion;

    return GlassCard(
      level: GlassLevel.hero,
      padding: EdgeInsets.all(short ? AppSpace.lg : AppSpace.xl),
      blurSigma: AppStyle.surfaceBlur,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final textScale = MediaQuery.textScalerOf(context).scale(16) / 16;
          // Photo beside the text whenever the card is wide enough for it.
          final beside = constraints.maxWidth >= AppBreak.heroRow * textScale;
          final textAlign = beside ? TextAlign.start : TextAlign.center;
          final identity = Column(
            crossAxisAlignment: beside
                ? CrossAxisAlignment.start
                : CrossAxisAlignment.center,
            children: [
              Semantics(
                header: true,
                child: AnimatedDefaultTextStyle(
                  duration: motion,
                  textAlign: textAlign,
                  style: (short
                      ? theme.textTheme.headlineSmall
                      : theme.textTheme.headlineMedium)!,
                  child: const Text(StudentProfile.name),
                ),
              ),
              const SizedBox(height: AppSpace.xs),
              Text(
                StudentProfile.university,
                textAlign: textAlign,
                style: theme.textTheme.titleMedium?.copyWith(
                  color: colors.primary,
                ),
              ),
              SizedBox(height: short ? AppSpace.sm : AppSpace.md),
              // The degree names the subject once; no separate department line.
              Text(
                StudentProfile.degree,
                textAlign: textAlign,
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: colors.onSurface,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: AppSpace.sm),
              // Shown here for reference; the Contact card has the copy and
              // send actions. It shrinks rather than breaking mid-address.
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ExcludeSemantics(
                      child: Icon(
                        Icons.mail_outlined,
                        size: AppStyle.iconSm,
                        color: colors.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(width: AppSpace.sm),
                    Text(
                      StudentProfile.universityEmail,
                      semanticsLabel:
                          '${AppLabels.universityEmail} '
                          '${StudentProfile.universityEmail}',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: colors.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpace.md),
              const GlassChip(
                '${AppLabels.majorShort}: ${StudentProfile.major}',
                accent: true,
              ),
            ],
          );
          // One Flex for both arrangements, so the photo keeps its place in
          // the tree and resizes smoothly when the phone is rotated.
          return Flex(
            direction: beside ? Axis.horizontal : Axis.vertical,
            spacing: beside ? AppSpace.xl : AppSpace.sm,
            children: [
              _Photo(radius: AppStyle.avatarRadius(screen), motion: motion),
              if (beside) Expanded(child: identity) else identity,
            ],
          );
        },
      ),
    );
  }
}

/// The fixed local portrait stays at its full aspect ratio inside the frame.
class _Photo extends StatelessWidget {
  const _Photo({required this.radius, required this.motion});

  final double radius;
  final Duration motion;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final dark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.all(AppSpace.sm),
      child: DecoratedBox(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: AppStyle.glassEdge(colors)),
          gradient: LinearGradient(
            begin: AlignmentDirectional.topStart,
            end: AlignmentDirectional.bottomEnd,
            colors: [
              colors.primary.withValues(alpha: 0.12),
              colors.primary.withValues(alpha: 0.45),
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(AppSpace.xs),
          child: Semantics(
            image: true,
            label: AppLabels.profilePhoto,
            child: ExcludeSemantics(
              child: CircleAvatar(
                radius: radius,
                backgroundColor: dark
                    ? colors.surfaceContainerHighest
                    : colors.primary,
                child: AnimatedSwitcher(
                  duration: motion,
                  switchInCurve: AppStyle.curve,
                  child: ClipOval(
                    key: const ValueKey(StudentProfile.profileImage),
                    child: Transform.scale(
                      scale: 1.08,
                      child: Image.asset(
                        StudentProfile.profileImage,
                        width: radius * 2,
                        height: radius * 2,
                        fit: BoxFit.cover,
                        filterQuality: FilterQuality.high,
                      ),
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
