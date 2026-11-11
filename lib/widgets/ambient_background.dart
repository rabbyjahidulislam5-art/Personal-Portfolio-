import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

/// Fixed backdrop: the page gradient plus two faint colour washes. It never
/// animates; depth comes from translucent cards scrolling across it.
class AmbientBackground extends StatelessWidget {
  const AmbientBackground({super.key});

  // Centred at the top so the header and hero sit on an even glow, plus one
  // low in the trailing corner.
  static const _centers = [
    AlignmentDirectional(0, -1),
    AlignmentDirectional(1, 1),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final washes = AppStyle.ambient(theme.colorScheme);
    return ExcludeSemantics(
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: AppStyle.background(theme.brightness),
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            for (final (index, wash) in washes.indexed)
              DecoratedBox(
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    center: _centers[index],
                    radius: 1.1,
                    colors: [wash, wash.withValues(alpha: 0)],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
