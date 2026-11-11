import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import 'glass_card.dart';

class SkillGroup extends StatelessWidget {
  const SkillGroup({super.key, this.title, required this.skills});

  final String? title;
  final List<String> skills;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title != null) ...[
          Semantics(
            header: true,
            child: Text(
              title!,
              style: theme.textTheme.titleSmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          const SizedBox(height: AppSpace.md),
        ],
        Wrap(
          spacing: AppSpace.sm,
          runSpacing: AppSpace.sm,
          children: [for (final skill in skills) GlassChip(skill)],
        ),
      ],
    );
  }
}
