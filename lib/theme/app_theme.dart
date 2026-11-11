import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

abstract final class AppSpace {
  static const xs = 4.0;
  static const sm = 8.0;
  static const md = 12.0;
  static const lg = 16.0;
  static const card = 20.0;
  static const xl = 24.0;
  static const xxl = 32.0;
}

/// Layout thresholds in logical pixels. Every decision uses the space that is
/// actually available, never the orientation flag.
abstract final class AppBreak {
  /// Below this width: phone gutters and the bottom section bar.
  static const compact = 600.0;

  /// Below this height (a phone on its side): compact header and hero.
  static const short = 480.0;
  static const navLabels = 360.0;

  /// The section bar never grows wider than this; on wide screens it floats
  /// in the centre.
  static const navWidth = 520.0;

  /// Inner widths at which content moves side by side.
  static const stats = 432.0;
  static const heroRow = 440.0;

  /// Smallest comfortable tile widths; grids fit as many columns as they can.
  static const pairTile = 292.0;
  static const projectTile = 300.0;
  static const courseTile = 220.0;
  static const detailTile = 190.0;
}

/// Surface hierarchy, from pinned bars down to chips.
enum GlassLevel { bar, hero, card, accent, inset }

abstract final class AppStyle {
  static const cardRadius = 20.0;
  static const heroRadius = 28.0;
  static const chipRadius = 12.0;
  static const metricRadius = 16.0;
  static const navRadius = 28.0;
  static const iconSm = 18.0;
  static const icon = 22.0;
  static const barBlur = 18.0;
  static const surfaceBlur = 12.0;
  static const motion = Duration(milliseconds: 180);
  static const press = Duration(milliseconds: 120);
  static const entrance = Duration(milliseconds: 480);
  static const stagger = Duration(milliseconds: 60);
  static const entranceRise = 24.0;
  static const entranceSlide = 28.0;
  static const entranceShrink = 0.05;
  static const pressScale = 0.98;
  static const curve = Curves.easeOutCubic;
  static const maxContentWidth = 1040.0;

  /// Profile photo radius: prominent upright, compact when the screen is short.
  static double avatarRadius(Size screen) =>
      math.min(screen.width * 0.15, screen.height * 0.11).clamp(36.0, 56.0);

  static bool _dark(ColorScheme colors) => colors.brightness == Brightness.dark;

  /// Fill layers of a glass level, lightest first. The contrast test composites
  /// these over the background, so every alpha here is checked for readability.
  static List<Color> glassLayers(ColorScheme colors, GlassLevel level) {
    final dark = _dark(colors);
    // Dark glass lightens the black behind it into neutral greys, like a
    // phone's own dark mode; light glass is frosted white.
    final frost = dark ? colors.onSurface : colors.surfaceContainerLowest;
    switch (level) {
      case GlassLevel.bar:
        // Tinted with the page colour so the bars blend into the page.
        return [
          background(colors.brightness).colors.first.withValues(alpha: 0.72),
        ];
      case GlassLevel.hero:
        final base = frost.withValues(alpha: dark ? 0.12 : 0.74);
        return [
          base,
          Color.alphaBlend(colors.primary.withValues(alpha: 0.06), base),
        ];
      case GlassLevel.card:
        return [
          frost.withValues(alpha: dark ? 0.15 : 0.70),
          frost.withValues(alpha: dark ? 0.12 : 0.62),
        ];
      case GlassLevel.accent:
        return [colors.primary.withValues(alpha: dark ? 0.08 : 0.09)];
      case GlassLevel.inset:
        return [
          (dark ? colors.onSurface : colors.primary).withValues(
            alpha: dark ? 0.06 : 0.05,
          ),
        ];
    }
  }

  /// Thin light-catching edge that replaces heavy card outlines.
  static Color glassEdge(ColorScheme colors) => _dark(colors)
      ? colors.onSurface.withValues(alpha: 0.10)
      : colors.surfaceContainerLowest.withValues(alpha: 0.9);

  static double glassRadius(GlassLevel level) => switch (level) {
    GlassLevel.bar => 0,
    GlassLevel.hero => heroRadius,
    GlassLevel.inset => metricRadius,
    GlassLevel.card || GlassLevel.accent => cardRadius,
  };

  static BoxDecoration glass(
    ColorScheme colors,
    GlassLevel level, {
    double? radius,
  }) {
    final layers = glassLayers(colors, level);
    final corner = radius ?? glassRadius(level);
    // A bar docked edge to edge has no outline; a floating one does.
    final floating = level != GlassLevel.bar || corner > 0;
    final raised =
        level == GlassLevel.hero ||
        level == GlassLevel.card ||
        (level == GlassLevel.bar && floating);
    final strong = level == GlassLevel.hero || level == GlassLevel.bar;
    return BoxDecoration(
      color: layers.length == 1 ? layers.first : null,
      gradient: layers.length == 1
          ? null
          : LinearGradient(
              begin: AlignmentDirectional.topStart,
              end: AlignmentDirectional.bottomEnd,
              colors: layers,
            ),
      borderRadius: BorderRadius.circular(corner),
      border: floating ? Border.all(color: glassEdge(colors)) : null,
      // Shadows are invisible on the dark background, so skip their cost there.
      boxShadow: raised && !_dark(colors)
          ? [
              BoxShadow(
                color: colors.shadow.withValues(alpha: strong ? 0.07 : 0.04),
                blurRadius: strong ? 28 : 16,
                offset: Offset(0, strong ? 8 : 4),
              ),
            ]
          : raised
          ? [
              BoxShadow(
                color: colors.primary.withValues(alpha: 0.035),
                blurRadius: strong ? 24 : 14,
                offset: Offset(0, strong ? 7 : 3),
              ),
            ]
          : null,
    );
  }

  /// Restrained cool washes give glass a backdrop without competing with text.
  static List<Color> ambient(ColorScheme colors) => _dark(colors)
      ? [
          const Color(0xFF244B7A).withValues(alpha: 0.05),
          const Color(0xFF30405A).withValues(alpha: 0.04),
        ]
      : [
          colors.primary.withValues(alpha: 0.07),
          colors.secondaryContainer.withValues(alpha: 0.12),
        ];

  /// Hairline that separates a pinned glass bar from the content beneath it.
  static BorderSide barEdge(ColorScheme colors) =>
      BorderSide(color: colors.outlineVariant.withValues(alpha: 0.4));

  static ThemeData theme(Brightness brightness) {
    final dark = brightness == Brightness.dark;
    final scheme = ColorScheme.fromSeed(
      seedColor: const Color(0xFF245AC7),
      brightness: brightness,
      // Dark mode is neutral black, grey and white, like a phone's own dark
      // mode. The blue accent belongs to light mode only.
      dynamicSchemeVariant: dark
          ? DynamicSchemeVariant.monochrome
          : DynamicSchemeVariant.fidelity,
    );
    final base = ThemeData(useMaterial3: true, colorScheme: scheme);
    // Long paragraphs are softened in dark mode; headings stay full strength.
    final paragraph = dark ? scheme.onSurface.withValues(alpha: 0.87) : null;
    return base.copyWith(
      scaffoldBackgroundColor: scheme.surface,
      textTheme: base.textTheme.copyWith(
        headlineMedium: base.textTheme.headlineMedium?.copyWith(
          fontSize: 28,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.4,
          height: 1.2,
        ),
        headlineSmall: base.textTheme.headlineSmall?.copyWith(
          fontWeight: FontWeight.w700,
          letterSpacing: -0.2,
          height: 1.2,
          fontFeatures: const [FontFeature.tabularFigures()],
        ),
        titleLarge: base.textTheme.titleLarge?.copyWith(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          height: 1.35,
        ),
        titleMedium: base.textTheme.titleMedium?.copyWith(
          fontSize: 17,
          fontWeight: FontWeight.w600,
          height: 1.4,
        ),
        titleSmall: base.textTheme.titleSmall?.copyWith(
          fontSize: 15,
          fontWeight: FontWeight.w600,
          height: 1.4,
        ),
        labelLarge: base.textTheme.labelLarge?.copyWith(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          height: 1.4,
        ),
        labelMedium: base.textTheme.labelMedium?.copyWith(
          fontSize: 13,
          fontWeight: FontWeight.w500,
          height: 1.35,
        ),
        bodyLarge: base.textTheme.bodyLarge?.copyWith(
          fontSize: 16,
          height: 1.55,
          color: paragraph,
        ),
        bodyMedium: base.textTheme.bodyMedium?.copyWith(
          fontSize: 15,
          height: 1.5,
          color: paragraph,
        ),
        bodySmall: base.textTheme.bodySmall?.copyWith(
          fontSize: 14,
          height: 1.45,
          color: paragraph,
        ),
      ),
      appBarTheme: AppBarTheme(
        // The bar is a glass surface; its fill comes from GlassLevel.bar.
        backgroundColor: Colors.transparent,
        foregroundColor: scheme.onSurface,
        surfaceTintColor: Colors.transparent,
        scrolledUnderElevation: 0,
        elevation: 0,
        shape: Border(bottom: barEdge(scheme)),
        centerTitle: false,
        // A transparent bar cannot infer this, so status icons are set here.
        systemOverlayStyle:
            (dark ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark)
                .copyWith(statusBarColor: Colors.transparent),
        titleTextStyle: base.textTheme.titleLarge?.copyWith(
          color: scheme.onSurface,
          fontSize: 18,
          fontWeight: FontWeight.w700,
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        height: 64,
        indicatorColor: glassLayers(scheme, GlassLevel.accent).first,
      ),
      iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(minimumSize: const Size(48, 48)),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(minimumSize: const Size(48, 48)),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppStyle.chipRadius),
        ),
      ),
      dividerTheme: DividerThemeData(
        color: scheme.outlineVariant.withValues(alpha: 0.5),
      ),
    );
  }

  /// Top-to-bottom, so the page is the same shade from edge to edge.
  static LinearGradient background(Brightness brightness) => LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: brightness == Brightness.dark
        ? const [Color(0xFF0A1220), Color(0xFF101A2A)]
        : const [Color(0xFFF6F8FD), Color(0xFFECF1F9)],
  );
}
