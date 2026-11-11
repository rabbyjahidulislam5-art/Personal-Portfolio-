import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:student_profile/theme/app_theme.dart';

double contrast(Color foreground, Color background) {
  final a = foreground.computeLuminance();
  final b = background.computeLuminance();
  return ((a > b ? a : b) + 0.05) / ((a < b ? a : b) + 0.05);
}

void main() {
  for (final brightness in Brightness.values) {
    test(
      '${brightness.name} text has readable contrast on profile surfaces',
      () {
        final colors = AppStyle.theme(brightness).colorScheme;
        final pairs = [
          (colors.onSurface, colors.surface),
          (colors.onSurfaceVariant, colors.surface),
          (colors.onSurface, colors.surfaceContainerLowest),
          (colors.onSurfaceVariant, colors.surfaceContainerLowest),
          (colors.onSurface, colors.surfaceContainerLow),
          (colors.onSurfaceVariant, colors.surfaceContainerLow),
          (colors.onPrimaryContainer, colors.primaryContainer),
          (colors.primary, colors.surface),
        ];
        for (final (foreground, background) in pairs) {
          expect(contrast(foreground, background), greaterThanOrEqualTo(4.5));
        }
        // Check glass compositing at both background and surface gradient ends.
        for (final background in AppStyle.background(brightness).colors) {
          for (final layer in AppStyle.heroGradient(colors).colors) {
            final surface = Color.alphaBlend(layer, background);
            for (final text in [
              colors.onSurface,
              colors.onSurfaceVariant,
              colors.primary,
            ]) {
              expect(contrast(text, surface), greaterThanOrEqualTo(4.5));
            }
          }
        }
      },
    );
  }
}
