import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:student_profile/data/student_profile.dart';
import 'package:student_profile/widgets/profile_hero.dart';

import 'support/profile_test_helpers.dart';

void main() {
  testWidgets('the bundled profile photo stays fixed through layout changes', (
    tester,
  ) async {
    await pumpProfile(tester, size: phonePortrait);

    Image portrait() => tester.widget(
      find.descendant(
        of: find.byType(ProfileHero),
        matching: find.byType(Image),
      ),
    );

    expect(portrait().image, isA<AssetImage>());
    expect(
      (portrait().image as AssetImage).assetName,
      StudentProfile.profileImage,
    );
    for (final tooltip in ['Change photo', 'Remove photo']) {
      expect(find.byTooltip(tooltip), findsNothing);
    }
    expect(find.byIcon(Icons.add_a_photo_outlined), findsNothing);
    expect(find.byIcon(Icons.camera_alt_outlined), findsNothing);

    await resize(tester, phoneLandscape);
    expect(
      (portrait().image as AssetImage).assetName,
      StudentProfile.profileImage,
    );
    await chooseTheme(tester, ThemeMode.dark);
    expect(
      (portrait().image as AssetImage).assetName,
      StudentProfile.profileImage,
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('the theme follows the system until one is chosen', (
    tester,
  ) async {
    Brightness shown() =>
        Theme.of(tester.element(find.byType(Scaffold))).brightness;

    await pumpProfile(tester);
    expect(themeMode(tester), ThemeMode.system);
    tester.platformDispatcher.platformBrightnessTestValue = Brightness.dark;
    await tester.pumpAndSettle();
    expect(shown(), Brightness.dark);
    expect(themeMode(tester), ThemeMode.system);
    tester.platformDispatcher.platformBrightnessTestValue = Brightness.light;
    await tester.pumpAndSettle();
    expect(shown(), Brightness.light);

    await chooseTheme(tester, ThemeMode.dark);
    expect(shown(), Brightness.dark);
    tester.platformDispatcher.platformBrightnessTestValue = Brightness.light;
    await tester.pumpAndSettle();
    expect(shown(), Brightness.dark);
    expect(tester.takeException(), isNull);
  });
}
