import 'dart:ui';

import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class GlassCard extends StatelessWidget {
  const GlassCard({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppStyle.heroRadius),
        boxShadow: [
          BoxShadow(
            color: colors.shadow.withValues(alpha: 0.045),
            blurRadius: AppSpace.xl,
            offset: const Offset(0, AppSpace.sm),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppStyle.heroRadius),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: AppStyle.heroGradient(colors),
              borderRadius: BorderRadius.circular(AppStyle.heroRadius),
              border: Border.all(color: AppStyle.border(colors)),
            ),
            child: Padding(
              padding: const EdgeInsets.all(AppSpace.xl),
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}
