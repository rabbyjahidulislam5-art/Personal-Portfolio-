import 'package:flutter/material.dart';

import '../data/student_profile.dart';
import '../l10n/app_labels.dart';
import '../theme/app_theme.dart';
import 'section_card.dart';

class AcademicOverview extends StatelessWidget {
  const AcademicOverview({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return SectionCard(
      title: AppLabels.academicOverview,
      icon: Icons.school_outlined,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: AppSpace.md,
            runSpacing: AppSpace.sm,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Text(
                StudentProfile.semester,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              DecoratedBox(
                decoration: BoxDecoration(
                  color: colors.primaryContainer,
                  borderRadius: BorderRadius.circular(AppStyle.chipRadius),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpace.md,
                    vertical: AppSpace.xs,
                  ),
                  child: Text(
                    StudentProfile.academicYear,
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: colors.onPrimaryContainer,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpace.lg),
          LayoutBuilder(
            builder: (context, constraints) {
              final scale = MediaQuery.textScalerOf(context).scale(16) / 16;
              final horizontal = constraints.maxWidth >= 336 * scale;
              const stats = [
                (StudentProfile.cgpa, AppLabels.cgpa, Icons.auto_graph_rounded),
                (
                  StudentProfile.completedCredits,
                  AppLabels.completedCredits,
                  Icons.menu_book_outlined,
                ),
                (
                  StudentProfile.graduationYear,
                  AppLabels.expectedGraduation,
                  Icons.event_outlined,
                ),
              ];

              if (horizontal) {
                return IntrinsicHeight(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      for (var index = 0; index < stats.length; index++) ...[
                        if (index != 0) const SizedBox(width: AppSpace.sm),
                        Expanded(
                          child: _StatisticTile(
                            key: ValueKey('academic-stat-$index'),
                            value: stats[index].$1,
                            label: stats[index].$2,
                            icon: stats[index].$3,
                          ),
                        ),
                      ],
                    ],
                  ),
                );
              }

              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  for (var index = 0; index < stats.length; index++) ...[
                    if (index != 0) const SizedBox(height: AppSpace.sm),
                    _StatisticTile(
                      key: ValueKey('academic-stat-$index'),
                      value: stats[index].$1,
                      label: stats[index].$2,
                      icon: stats[index].$3,
                      compact: true,
                    ),
                  ],
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

class _StatisticTile extends StatelessWidget {
  const _StatisticTile({
    super.key,
    required this.value,
    required this.label,
    required this.icon,
    this.compact = false,
  });

  final String value;
  final String label;
  final IconData icon;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final largeText = MediaQuery.textScalerOf(context).scale(16) > 22;
    final valueText = Text(
      value,
      style: theme.textTheme.headlineSmall?.copyWith(
        fontWeight: FontWeight.w800,
        letterSpacing: -0.5,
      ),
    );
    final labelText = Text(
      label,
      style: theme.textTheme.bodySmall?.copyWith(
        color: colors.onSurfaceVariant,
        height: 1.4,
      ),
    );
    final metricIcon = ExcludeSemantics(
      child: Icon(icon, size: 20, color: colors.primary),
    );

    return MergeSemantics(
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: colors.surfaceContainerLow,
          borderRadius: BorderRadius.circular(AppStyle.metricRadius),
          border: Border.all(color: AppStyle.border(colors)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(AppSpace.md),
          child: compact
              ? Row(
                  children: [
                    metricIcon,
                    const SizedBox(width: AppSpace.md),
                    if (largeText)
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            valueText,
                            const SizedBox(height: AppSpace.xs),
                            labelText,
                          ],
                        ),
                      )
                    else ...[
                      Expanded(child: labelText),
                      const SizedBox(width: AppSpace.md),
                      valueText,
                    ],
                  ],
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    metricIcon,
                    const SizedBox(height: AppSpace.md),
                    valueText,
                    const SizedBox(height: AppSpace.xs),
                    labelText,
                  ],
                ),
        ),
      ),
    );
  }
}
