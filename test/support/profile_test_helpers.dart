import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:student_profile/app.dart';
import 'package:student_profile/widgets/appearance_footer.dart';
import 'package:student_profile/widgets/github_link_card.dart';
import 'package:student_profile/widgets/project_card.dart';

/// Reference phone portrait and landscape logical dimensions.
const phonePortrait = Size(360, 780);
const phoneLandscape = Size(780, 360);

Future<void> pumpProfile(
  WidgetTester tester, {
  Future<bool> Function(Uri)? openUrl,
  Size size = const Size(390, 844),
  double textScale = 1,
  Brightness brightness = Brightness.light,
  SharedPreferences? preferences,
}) async {
  tester.view.devicePixelRatio = 1;
  tester.view.physicalSize = size;
  tester.platformDispatcher.textScaleFactorTestValue = textScale;
  tester.platformDispatcher.platformBrightnessTestValue = brightness;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
  addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
  addTearDown(tester.platformDispatcher.clearPlatformBrightnessTestValue);
  await tester.pumpWidget(
    StudentProfileApp(
      openUrl: openUrl ?? (_) async => true,
      preferences: preferences,
    ),
  );
  await tester.pumpAndSettle();
}

/// Rotates or resizes the screen the app is already running on.
Future<void> resize(WidgetTester tester, Size size) async {
  tester.view.physicalSize = size;
  await tester.pumpAndSettle();
}

ThemeMode themeMode(WidgetTester tester) =>
    tester.widget<MaterialApp>(find.byType(MaterialApp)).themeMode!;

/// Picks Light or Dark in the footer, the only place the theme is chosen.
Future<void> chooseTheme(WidgetTester tester, ThemeMode mode) async {
  final segment = find.descendant(
    of: find.byType(AppearanceFooter),
    matching: find.byIcon(
      mode == ThemeMode.dark
          ? Icons.dark_mode_outlined
          : Icons.light_mode_outlined,
    ),
  );
  await tester.ensureVisible(segment);
  await tester.pumpAndSettle();
  await tester.tap(segment);
  await tester.pumpAndSettle();
  expect(themeMode(tester), mode);
}

/// Brings every section on screen in turn, so each one is laid out, revealed
/// and painted at the current size.
Future<void> scrollThrough(WidgetTester tester) async {
  for (final stop in [
    find.byType(ProjectCard).first,
    find.byType(ProjectCard).last,
    find.byType(GitHubLinkCard),
    find.byType(AppearanceFooter),
  ]) {
    await tester.ensureVisible(stop);
    await tester.pumpAndSettle();
  }
}

ScrollPosition profileScroll(WidgetTester tester) => tester
    .state<ScrollableState>(
      find
          .descendant(
            of: find.byType(SingleChildScrollView),
            matching: find.byType(Scrollable),
          )
          .first,
    )
    .position;

Future<void> scrollToTop(WidgetTester tester) async {
  profileScroll(tester).jumpTo(0);
  await tester.pumpAndSettle();
}
