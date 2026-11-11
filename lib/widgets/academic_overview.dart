import 'package:flutter/material.dart';

import '../data/student_profile.dart';
import '../l10n/app_labels.dart';
import '../theme/app_theme.dart';
import 'adaptive_grid.dart';
import 'glass_card.dart';
import 'profile_entrance.dart';
import 'section_card.dart';

class AcademicOverview extends StatelessWidget {
  const AcademicOverview({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SectionCard(
      title: AppLabels.academicOverview,
      icon: Icons.insights_outlined,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: AppSpace.md,
            runSpacing: AppSpace.sm,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Text(StudentProfile.semester, style: theme.textTheme.titleMedium),
              const GlassChip(StudentProfile.academicYear, accent: true),
            ],
          ),
          const SizedBox(height: AppSpace.lg),
          LayoutBuilder(
            builder: (context, constraints) {
              final scale = MediaQuery.textScalerOf(context).scale(16) / 16;
              final beside = constraints.maxWidth >= AppBreak.stats * scale;
              final stats = [
                // The scale is always written next to the result, so 4.00 can
                // never be read as the achieved CGPA.
                _StatisticTile(
                  key: const ValueKey('academic-stat-0'),
                  value: StudentProfile.cgpa,
                  outOf: StudentProfile.cgpaScale,
                  label: AppLabels.cgpa,
                  icon: Icons.auto_graph_outlined,
                  compact: !beside,
                ),
                _StatisticTile(
                  key: const ValueKey('academic-stat-1'),
                  value: '${StudentProfile.completedCredits}',
                  outOf: '${StudentProfile.totalCredits}',
                  progress:
                      StudentProfile.completedCredits /
                      StudentProfile.totalCredits,
                  label: AppLabels.completedCredits,
                  icon: Icons.menu_book_outlined,
                  compact: !beside,
                ),
                _StatisticTile(
                  key: const ValueKey('academic-stat-2'),
                  value: StudentProfile.graduationYear,
                  label: AppLabels.expectedGraduation,
                  icon: Icons.event_outlined,
                  compact: !beside,
                ),
              ];

              // Each tile arrives a beat after the one before it.
              final tiles = [
                for (final (index, tile) in stats.indexed)
                  ProfileEntrance(index: index, child: tile),
              ];
              if (!beside) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  spacing: AppSpace.sm,
                  children: tiles,
                );
              }
              return IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  spacing: AppSpace.sm,
                  children: [for (final tile in tiles) Expanded(child: tile)],
                ),
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
    this.outOf,
    this.progress,
    this.compact = false,
  });

  final String value;
  final String label;
  final IconData icon;

  /// The maximum the value is measured against, shown as "value / outOf".
  final String? outOf;
  final double? progress;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final valueText = Text.rich(
      TextSpan(
        text: value,
        children: [
          if (outOf != null)
            TextSpan(
              text: ' / $outOf',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colors.onSurfaceVariant,
                fontFeatures: const [FontFeature.tabularFigures()],
              ),
            ),
        ],
      ),
      style: theme.textTheme.headlineSmall,
      semanticsLabel: outOf == null ? null : '$value ${AppLabels.outOf} $outOf',
    );
    final text = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        valueText,
        const SizedBox(height: AppSpace.xs),
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            color: colors.onSurfaceVariant,
            height: 1.4,
          ),
        ),
      ],
    );
    final metricIcon = GlassIcon(icon);
    // The numbers already say this, so the bar is decoration for a reader.
    final bar = progress == null
        ? null
        : ExcludeSemantics(
            child: Padding(
              padding: const EdgeInsets.only(top: AppSpace.md),
              child: LinearProgressIndicator(
                value: progress,
                minHeight: 6,
                borderRadius: BorderRadius.circular(3),
                backgroundColor: colors.onSurface.withValues(alpha: 0.08),
              ),
            ),
          );

    return MergeSemantics(
      child: GlassCard(
        level: GlassLevel.inset,
        padding: const EdgeInsets.all(AppSpace.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // The value always sits above its label; a narrow tile only moves
            // the icon to the side, so nothing can run out of the tile.
            if (compact)
              Row(
                children: [
                  metricIcon,
                  const SizedBox(width: AppSpace.md),
                  Expanded(child: text),
                ],
              )
            else ...[
              metricIcon,
              const SizedBox(height: AppSpace.md),
              text,
            ],
            ?bar,
          ],
        ),
      ),
    );
  }
}

/// Courses as compact tiles: code first, so the titles line up in a column.
class CourseworkCard extends StatelessWidget {
  const CourseworkCard({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    return SectionCard(
      title: AppLabels.relevantCoursework,
      icon: Icons.auto_stories_outlined,
      child: AdaptiveGrid(
        minTileWidth: AppBreak.courseTile,
        maxColumns: 3,
        spacing: AppSpace.sm,
        children: [
          for (final (index, (code, title))
              in StudentProfile.coursework.indexed)
            ProfileEntrance(
              index: index % 3,
              child: MergeSemantics(
                child: GlassCard(
                  level: GlassLevel.inset,
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpace.md,
                    vertical: AppSpace.md,
                  ),
                  child: Row(
                    children: [
                      Text(
                        code,
                        style: theme.textTheme.labelLarge?.copyWith(
                          color: colors.primary,
                          fontWeight: FontWeight.w700,
                          fontFeatures: const [FontFeature.tabularFigures()],
                        ),
                      ),
                      const SizedBox(width: AppSpace.md),
                      Expanded(
                        child: Text(
                          title,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: colors.onSurface,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
