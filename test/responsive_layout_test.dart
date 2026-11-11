import 'dart:ui' show DisplayFeature, DisplayFeatureType, DisplayFeatureState;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:student_profile/data/student_profile.dart';
import 'package:student_profile/l10n/app_labels.dart';
import 'package:student_profile/screens/student_profile_screen.dart';
import 'package:student_profile/theme/app_theme.dart';
import 'package:student_profile/widgets/profile_hero.dart';

import 'support/profile_test_helpers.dart';

void main() {
  const sizes = [
    Size(320, 568),
    Size(390, 844),
    Size(568, 320),
    Size(844, 390),
    Size(768, 1024),
    Size(1024, 768),
    Size(1440, 900),
    Size(360, 720),
  ];

  for (final size in sizes) {
    for (final scale in [1.0, 2.0]) {
      for (final brightness in Brightness.values) {
        testWidgets('${size.width.toInt()}x${size.height.toInt()} '
            '${scale}x ${brightness.name} has no overflow', (tester) async {
          await pumpProfile(
            tester,
            size: size,
            textScale: scale,
            brightness: brightness,
          );
          await chooseMenu(
            tester,
            'privacy-menu',
            AppLabels.showPrivateDetails,
          );
          expect(find.text(StudentProfile.studentId), findsOneWidget);
          await openDetails(tester, 'personal-details');
          await openDetails(tester, 'contact-details');
          await tester.ensureVisible(find.text(AppLabels.openGithub));
          await tester.pumpAndSettle();
          expect(find.byType(SingleChildScrollView), findsOneWidget);
          expect(tester.takeException(), isNull);
        });
      }
    }
  }

  testWidgets('RTL and 200 percent text stay within a safe foldable pane', (
    tester,
  ) async {
    const size = Size(816, 800);
    const hinge = Rect.fromLTWH(400, 0, 16, 800);
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = size;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(
      MaterialApp(
        theme: AppStyle.theme(Brightness.light),
        builder: (context, child) => Directionality(
          textDirection: TextDirection.rtl,
          child: MediaQuery(
            data: MediaQuery.of(context).copyWith(
              textScaler: const TextScaler.linear(2),
              padding: const EdgeInsets.fromLTRB(12, 24, 12, 16),
              viewPadding: const EdgeInsets.fromLTRB(12, 24, 12, 16),
              disableAnimations: true,
              displayFeatures: const [
                DisplayFeature(
                  bounds: hinge,
                  type: DisplayFeatureType.hinge,
                  state: DisplayFeatureState.postureFlat,
                ),
              ],
            ),
            child: child!,
          ),
        ),
        home: StudentProfileScreen(
          themeMode: ThemeMode.light,
          onThemeChanged: (_) {},
          imagePicker: FakeImagePicker(),
          openUrl: (_) async => true,
        ),
      ),
    );
    await tester.pumpAndSettle();
    final heroBounds = tester.getRect(find.byType(ProfileHero));
    expect(heroBounds.left, greaterThanOrEqualTo(hinge.right));
    expect(heroBounds.right, lessThanOrEqualTo(size.width - 12));
    expect(heroBounds.top, greaterThanOrEqualTo(24));
    await chooseMenu(tester, 'privacy-menu', AppLabels.showPrivateDetails);
    await openDetails(tester, 'personal-details');
    await openDetails(tester, 'contact-details');
    await tester.ensureVisible(find.text(AppLabels.openGithub));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  });
}
