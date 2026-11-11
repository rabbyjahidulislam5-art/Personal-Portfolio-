import 'package:flutter/material.dart';

abstract final class AppSpace {
  static const xs = 4.0;
  static const sm = 8.0;
  static const md = 12.0;
  static const lg = 16.0;
  static const card = 20.0;
  static const xl = 24.0;
  static const xxl = 32.0;
}

abstract final class AppStyle {
  static const cardRadius = 20.0;
  static const heroRadius = 24.0;
  static const chipRadius = 12.0;
  static const metricRadius = 16.0;
  static const motion = Duration(milliseconds: 180);
  static const entrance = Duration(milliseconds: 320);
  static const curve = Curves.easeOutCubic;
  static const maxContentWidth = 1040.0;

  static Color border(ColorScheme colors) =>
      colors.outlineVariant.withValues(alpha: 0.55);

  static LinearGradient heroGradient(ColorScheme colors) => LinearGradient(
    begin: AlignmentDirectional.topStart,
    end: AlignmentDirectional.bottomEnd,
    colors: [
      colors.surface.withValues(alpha: 0.96),
      Color.alphaBlend(
        colors.primaryContainer.withValues(alpha: 0.16),
        colors.surface.withValues(alpha: 0.92),
      ),
    ],
  );

  static BoxDecoration cardDecoration(
    ColorScheme colors, {
    bool elevated = false,
  }) => BoxDecoration(
    color: elevated ? colors.surfaceContainerLowest : colors.surface,
    borderRadius: BorderRadius.circular(cardRadius),
    border: Border.all(color: border(colors)),
    boxShadow: elevated
        ? [
            BoxShadow(
              color: colors.shadow.withValues(alpha: 0.035),
              blurRadius: 20,
              offset: const Offset(0, 6),
            ),
          ]
        : null,
  );

  static ThemeData theme(Brightness brightness) {
    final scheme = ColorScheme.fromSeed(
      seedColor: const Color(0xFF245AC7),
      brightness: brightness,
      dynamicSchemeVariant: DynamicSchemeVariant.fidelity,
    );
    final base = ThemeData(useMaterial3: true, colorScheme: scheme);
    return base.copyWith(
      scaffoldBackgroundColor: scheme.surface,
      textTheme: base.textTheme.copyWith(
        headlineMedium: base.textTheme.headlineMedium?.copyWith(
          fontSize: 30,
          fontWeight: FontWeight.w700,
          height: 1.2,
        ),
        titleLarge: base.textTheme.titleLarge?.copyWith(
          fontSize: 19,
          fontWeight: FontWeight.w600,
          height: 1.35,
        ),
        titleMedium: base.textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.w600,
          height: 1.4,
        ),
        bodyLarge: base.textTheme.bodyLarge?.copyWith(height: 1.6),
        bodyMedium: base.textTheme.bodyMedium?.copyWith(height: 1.5),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: scheme.surface,
        foregroundColor: scheme.onSurface,
        surfaceTintColor: Colors.transparent,
        scrolledUnderElevation: 1,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: base.textTheme.titleLarge?.copyWith(
          color: scheme.onSurface,
          fontSize: 18,
          fontWeight: FontWeight.w700,
        ),
      ),
      iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(minimumSize: const Size(48, 48)),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(minimumSize: const Size(48, 48)),
      ),
      popupMenuTheme: PopupMenuThemeData(
        color: scheme.surfaceContainer,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppStyle.cardRadius),
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppStyle.chipRadius),
        ),
      ),
      dividerTheme: DividerThemeData(color: scheme.outlineVariant),
    );
  }

  static LinearGradient background(Brightness brightness) => LinearGradient(
    begin: AlignmentDirectional.topStart,
    end: AlignmentDirectional.bottomEnd,
    colors: brightness == Brightness.dark
        ? const [Color(0xFF0C1424), Color(0xFF15243A)]
        : const [Color(0xFFF5F8FF), Color(0xFFEAF1FB)],
  );
}
