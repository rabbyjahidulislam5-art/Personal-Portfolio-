import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class SkillGroup extends StatelessWidget {
  const SkillGroup({super.key, this.title, required this.skills});

  final String? title;
  final List<String> skills;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title != null) ...[
          Semantics(
            header: true,
            child: Text(title!, style: theme.textTheme.titleSmall),
          ),
          const SizedBox(height: AppSpace.md),
        ],
        Wrap(
          spacing: AppSpace.sm,
          runSpacing: AppSpace.sm,
          children: [
            for (final skill in skills)
              DecoratedBox(
                decoration: BoxDecoration(
                  color: colors.surfaceContainerLow,
                  borderRadius: BorderRadius.circular(AppStyle.chipRadius),
                  border: Border.all(color: AppStyle.border(colors)),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpace.md,
                    vertical: AppSpace.sm,
                  ),
                  child: Text(
                    skill,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: colors.onSurface,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }
}
