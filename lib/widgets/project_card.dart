import 'package:flutter/material.dart';

import '../data/student_profile.dart';
import '../theme/app_theme.dart';

class ProjectCard extends StatelessWidget {
  const ProjectCard({super.key, required this.project, required this.icon});

  final ProfileProject project;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    return DecoratedBox(
      decoration: AppStyle.cardDecoration(colors, elevated: true),
      child: Padding(
        padding: const EdgeInsets.all(AppSpace.card),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                DecoratedBox(
                  decoration: BoxDecoration(
                    color: colors.primaryContainer,
                    borderRadius: BorderRadius.circular(AppStyle.metricRadius),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(AppSpace.md),
                    child: Icon(icon, color: colors.onPrimaryContainer),
                  ),
                ),
                const SizedBox(width: AppSpace.md),
                Flexible(
                  child: Text(
                    project.category,
                    style: theme.textTheme.labelLarge?.copyWith(
                      color: colors.primary,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpace.lg),
            Semantics(
              header: true,
              child: Text(project.title, style: theme.textTheme.titleLarge),
            ),
            const SizedBox(height: AppSpace.sm),
            Text(
              project.type,
              style: theme.textTheme.labelLarge?.copyWith(
                color: colors.onSurfaceVariant,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: AppSpace.lg),
              child: Divider(height: 1, color: AppStyle.border(colors)),
            ),
            Text(project.description, style: theme.textTheme.bodyLarge),
          ],
        ),
      ),
    );
  }
}
