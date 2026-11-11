import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import 'glass_card.dart';

class SectionCard extends StatelessWidget {
  const SectionCard({
    super.key,
    required this.title,
    required this.child,
    this.icon,
  });

  final String title;
  final Widget child;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GlassCard(
      blurSigma: AppStyle.surfaceBlur,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Semantics(
            header: true,
            child: Row(
              children: [
                if (icon != null) ...[
                  GlassIcon(icon!),
                  const SizedBox(width: AppSpace.md),
                ],
                Flexible(child: Text(title, style: theme.textTheme.titleLarge)),
              ],
            ),
          ),
          const SizedBox(height: AppSpace.lg),
          // Section paragraphs read at body-large size with relaxed leading.
          DefaultTextStyle.merge(
            style: theme.textTheme.bodyLarge,
            child: child,
          ),
        ],
      ),
    );
  }
}
