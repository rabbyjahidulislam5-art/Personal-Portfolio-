import 'package:flutter/material.dart';

import '../data/student_profile.dart';
import '../l10n/app_labels.dart';
import '../theme/app_theme.dart';
import 'glass_card.dart';

/// One project as a tile inside the Projects card. The tile itself is not
/// tappable; only the link buttons a project really has are shown.
class ProjectCard extends StatelessWidget {
  const ProjectCard({
    super.key,
    required this.project,
    required this.icon,
    required this.onOpen,
  });

  final ProfileProject project;
  final IconData icon;
  final ValueChanged<String> onOpen;

  // Tighter side padding lets both buttons share one row on a 360px phone.
  static const _linkStyle = ButtonStyle(
    padding: WidgetStatePropertyAll(
      EdgeInsets.symmetric(horizontal: AppSpace.md),
    ),
  );

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final muted = theme.textTheme.labelLarge?.copyWith(
      color: colors.onSurfaceVariant,
    );
    final repoUrl = project.repoUrl;
    final demoUrl = project.demoUrl;
    return GlassCard(
      level: GlassLevel.inset,
      padding: const EdgeInsets.all(AppSpace.lg),
      // In a two-column row the shorter tile is stretched; spaceBetween then
      // keeps its buttons on the bottom edge, level with its neighbour's.
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  GlassIcon(icon),
                  const SizedBox(width: AppSpace.md),
                  Flexible(child: GlassChip(project.category, accent: true)),
                ],
              ),
              const SizedBox(height: AppSpace.md),
              Semantics(
                header: true,
                child: Text(project.title, style: theme.textTheme.titleMedium),
              ),
              const SizedBox(height: AppSpace.xs),
              Text(project.type, style: muted),
              if (project.alsoKnownAs case final name?)
                Text(
                  '${AppLabels.alsoKnownAs} $name',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colors.onSurfaceVariant,
                  ),
                ),
              const SizedBox(height: AppSpace.md),
              Text(project.description, style: theme.textTheme.bodyMedium),
              if (project.technologies.isNotEmpty) ...[
                const SizedBox(height: AppSpace.md),
                Wrap(
                  spacing: AppSpace.sm,
                  runSpacing: AppSpace.sm,
                  children: [
                    for (final technology in project.technologies)
                      GlassChip(technology, dense: true),
                  ],
                ),
              ],
            ],
          ),
          if (repoUrl != null || demoUrl != null)
            Padding(
              padding: const EdgeInsets.only(top: AppSpace.md),
              child: Wrap(
                spacing: AppSpace.sm,
                runSpacing: AppSpace.xs,
                children: [
                  if (repoUrl != null)
                    OutlinedButton.icon(
                      style: _linkStyle,
                      onPressed: () => onOpen(repoUrl),
                      icon: const Icon(Icons.code_outlined),
                      label: Text(
                        AppLabels.repository,
                        semanticsLabel: AppLabels.openRepository(project.title),
                      ),
                    ),
                  if (demoUrl != null)
                    FilledButton.tonalIcon(
                      style: _linkStyle,
                      onPressed: () => onOpen(demoUrl),
                      icon: const Icon(Icons.play_circle_outlined),
                      label: Text(
                        AppLabels.watchDemo,
                        semanticsLabel: AppLabels.watchDemoOf(project.title),
                      ),
                    ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
