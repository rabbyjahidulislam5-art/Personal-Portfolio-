import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:student_profile/theme/app_theme.dart';

double contrast(Color foreground, Color background) {
  // Translucent text is judged as it appears once drawn on the surface.
  final a = Color.alphaBlend(foreground, background).computeLuminance();
  final b = background.computeLuminance();
  return ((a > b ? a : b) + 0.05) / ((a < b ? a : b) + 0.05);
}

void main() {
  for (final brightness in Brightness.values) {
    test('${brightness.name} text stays readable on every glass level', () {
      final theme = AppStyle.theme(brightness);
      final colors = theme.colorScheme;
      final text = [
        colors.onSurface,
        colors.onSurfaceVariant,
        colors.primary,
        theme.textTheme.bodyLarge!.color ?? colors.onSurface,
      ];
      void expectReadable(Color surface, String where) {
        for (final color in text) {
          expect(
            contrast(color, surface),
            greaterThanOrEqualTo(4.5),
            reason: '$color on $where ($surface)',
          );
        }
      }

      Color over(GlassLevel level, Color surface) =>
          Color.alphaBlend(AppStyle.glassLayers(colors, level).first, surface);

      // Each gradient end, plain and under each ambient wash at full strength.
      final backgrounds = [
        for (final end in AppStyle.background(brightness).colors) ...[
          end,
          for (final wash in AppStyle.ambient(colors))
            Color.alphaBlend(wash, end),
        ],
      ];
      for (final background in backgrounds) {
        for (final level in [
          GlassLevel.bar,
          GlassLevel.hero,
          GlassLevel.card,
          GlassLevel.accent,
        ]) {
          for (final layer in AppStyle.glassLayers(colors, level)) {
            final surface = Color.alphaBlend(layer, background);
            expectReadable(surface, level.name);
            if (level != GlassLevel.hero && level != GlassLevel.card) continue;
            // The same nesting the screen uses: accent chips sit on the hero
            // and on cards; tiles sit on cards only, with chips and icon
            // tiles inside them (project, stat and course tiles).
            expectReadable(
              over(GlassLevel.accent, surface),
              'accent on ${level.name}',
            );
            if (level == GlassLevel.hero) continue;
            final tile = over(GlassLevel.inset, surface);
            expectReadable(tile, 'inset on ${level.name}');
            expectReadable(
              over(GlassLevel.inset, tile),
              'inset on inset on ${level.name}',
            );
            expectReadable(
              over(GlassLevel.accent, tile),
              'accent on inset on ${level.name}',
            );
          }
        }
      }
    });
  }
}
