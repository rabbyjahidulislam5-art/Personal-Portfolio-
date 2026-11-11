import 'dart:ui';

import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

/// The one translucent surface used by every bar, card, tile and chip.
class GlassCard extends StatelessWidget {
  const GlassCard({
    super.key,
    required this.child,
    this.level = GlassLevel.card,
    this.padding = const EdgeInsets.all(AppSpace.card),
    this.radius,
    this.blurSigma = 0,
  });

  final Widget child;
  final GlassLevel level;
  final EdgeInsetsGeometry padding;
  final double? radius;

  /// Blur only where content scrolls underneath (the pinned bars). Cards sit
  /// on an already soft background, where blur costs a layer and shows nothing.
  final double blurSigma;

  @override
  Widget build(BuildContext context) {
    final decoration = AppStyle.glass(
      Theme.of(context).colorScheme,
      level,
      radius: radius,
    );
    final content = Padding(padding: padding, child: child);
    if (blurSigma <= 0) {
      return DecoratedBox(decoration: decoration, child: content);
    }
    // The shadow is drawn outside the clip; fill and edge are drawn over the
    // blurred backdrop inside it.
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: decoration.borderRadius,
        boxShadow: decoration.boxShadow,
      ),
      child: ClipRRect(
        borderRadius: decoration.borderRadius!,
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: blurSigma, sigmaY: blurSigma),
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: decoration.color,
              gradient: decoration.gradient,
              borderRadius: decoration.borderRadius,
              border: decoration.border,
            ),
            child: content,
          ),
        ),
      ),
    );
  }
}

/// Decorative icon on a primary-tinted glass tile.
class GlassIcon extends StatelessWidget {
  const GlassIcon(this.icon, {super.key});

  final IconData icon;

  @override
  Widget build(BuildContext context) => ExcludeSemantics(
    child: GlassCard(
      level: GlassLevel.accent,
      radius: AppStyle.chipRadius,
      padding: const EdgeInsets.all(AppSpace.sm),
      child: Icon(
        icon,
        size: AppStyle.icon,
        color: Theme.of(context).colorScheme.primary,
      ),
    ),
  );
}

/// Display-only label chip. It has no tap behaviour by design.
class GlassChip extends StatelessWidget {
  const GlassChip(
    this.label, {
    super.key,
    this.accent = false,
    this.dense = false,
  });

  final String label;

  /// Primary-tinted label for a status or category.
  final bool accent;

  /// Smaller neutral chip, for long lists such as a project's technologies.
  final bool dense;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    return GlassCard(
      level: accent ? GlassLevel.accent : GlassLevel.inset,
      radius: AppStyle.chipRadius,
      padding: EdgeInsets.symmetric(
        horizontal: AppSpace.md,
        vertical: accent || dense ? AppSpace.xs : AppSpace.sm,
      ),
      child: Text(
        label,
        style: accent
            ? theme.textTheme.labelMedium?.copyWith(
                color: colors.primary,
                fontWeight: FontWeight.w600,
              )
            : (dense ? theme.textTheme.labelMedium : theme.textTheme.bodyMedium)
                  ?.copyWith(color: colors.onSurface),
      ),
    );
  }
}
