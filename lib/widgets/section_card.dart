import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

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
    final colors = theme.colorScheme;
    return DecoratedBox(
      decoration: AppStyle.cardDecoration(colors),
      child: Padding(
        padding: const EdgeInsets.all(AppSpace.card),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Semantics(
              header: true,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (icon != null) ...[
                    Padding(
                      padding: const EdgeInsetsDirectional.only(
                        top: AppSpace.xs,
                        end: AppSpace.md,
                      ),
                      child: Icon(icon, size: 20, color: colors.primary),
                    ),
                  ],
                  Flexible(
                    child: Text(title, style: theme.textTheme.titleLarge),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpace.lg),
            child,
          ],
        ),
      ),
    );
  }
}
