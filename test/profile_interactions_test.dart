import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image_picker/image_picker.dart';
import 'package:student_profile/data/student_profile.dart';
import 'package:student_profile/l10n/app_labels.dart';

import 'support/profile_test_helpers.dart';

void main() {
  testWidgets('photo, privacy and disclosure survive theme and size changes', (
    tester,
  ) async {
    final picker = FakeImagePicker()..selection = avatarFixture();
    await pumpProfile(tester, picker: picker);
    expect(avatarPhoto(tester), isNull);
    await choosePhoto(tester);
    expect(picker.lastSource, ImageSource.gallery);
    final selected = avatarPhoto(tester);
    expect(selected, isNotNull);

    await chooseMenu(tester, 'privacy-menu', AppLabels.showPrivateDetails);
    await openDetails(tester, 'contact-details');
    expect(find.text(StudentProfile.personalEmail), findsOneWidget);
    await chooseMenu(tester, 'appearance-menu', AppLabels.dark);
    expect(
      tester.widget<MaterialApp>(find.byType(MaterialApp)).themeMode,
      ThemeMode.dark,
    );
    expect(avatarPhoto(tester), selected);
    expect(find.text(StudentProfile.personalEmail), findsOneWidget);
    expect(find.text(StudentProfile.studentId), findsOneWidget);

    tester.view.physicalSize = const Size(844, 390);
    await tester.pumpAndSettle();
    expect(avatarPhoto(tester), selected);
    expect(find.text(StudentProfile.personalEmail), findsOneWidget);
    await chooseMenu(tester, 'appearance-menu', AppLabels.light);
    expect(
      tester.widget<MaterialApp>(find.byType(MaterialApp)).themeMode,
      ThemeMode.light,
    );
    await chooseMenu(tester, 'appearance-menu', AppLabels.system);
    expect(
      tester.widget<MaterialApp>(find.byType(MaterialApp)).themeMode,
      ThemeMode.system,
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('cancel and picker/decode errors retain the current photo', (
    tester,
  ) async {
    final picker = FakeImagePicker()..selection = avatarFixture();
    await pumpProfile(tester, picker: picker);
    await choosePhoto(tester);
    final selected = avatarPhoto(tester);
    expect(selected, isNotNull);

    picker.selection = null;
    await choosePhoto(tester);
    expect(avatarPhoto(tester), selected);
    expect(find.byType(SnackBar), findsNothing);

    picker.failure = PlatformException(code: 'photo_access_denied');
    await choosePhoto(tester);
    expect(avatarPhoto(tester), selected);
    expect(find.text(AppLabels.retry), findsOneWidget);

    picker.failure = null;
    picker.selection = XFile.fromData(
      Uint8List.fromList([1, 2, 3, 4]),
      name: 'invalid.png',
    );
    await choosePhoto(tester);
    expect(avatarPhoto(tester), selected);
    expect(find.text(AppLabels.retry), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('GitHub sends only the supplied URL and reports launch failure', (
    tester,
  ) async {
    Uri? opened;
    await pumpProfile(
      tester,
      openUrl: (uri) async {
        opened = uri;
        return false;
      },
    );
    final link = find.text(AppLabels.openGithub);
    await tester.ensureVisible(link);
    await tester.pumpAndSettle();
    await tester.tap(link);
    await tester.pumpAndSettle();
    expect(opened, Uri.parse(StudentProfile.githubUrl));
    expect(find.byType(SnackBar), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('removing a selected photo restores the initials', (
    tester,
  ) async {
    final picker = FakeImagePicker()..selection = avatarFixture();
    await pumpProfile(tester, picker: picker);
    expect(find.byKey(const ValueKey('remove-photo')), findsNothing);
    await choosePhoto(tester);
    expect(avatarPhoto(tester), isNotNull);
    final remove = find.byKey(const ValueKey('remove-photo'));
    expect(find.text(AppLabels.removePhoto), findsOneWidget);
    await tester.tap(remove);
    await tester.pumpAndSettle();
    expect(avatarPhoto(tester), isNull);
    expect(find.text(StudentProfile.initials), findsOneWidget);
    expect(remove, findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('system brightness changes retain local privacy and disclosure', (
    tester,
  ) async {
    await pumpProfile(tester);
    await chooseMenu(tester, 'privacy-menu', AppLabels.showPrivateDetails);
    await openDetails(tester, 'contact-details');
    expect(find.text(StudentProfile.personalEmail), findsOneWidget);
    tester.platformDispatcher.platformBrightnessTestValue = Brightness.dark;
    await tester.pumpAndSettle();
    expect(
      Theme.of(tester.element(find.byType(Scaffold))).brightness,
      Brightness.dark,
    );
    expect(
      tester.widget<MaterialApp>(find.byType(MaterialApp)).themeMode,
      ThemeMode.system,
    );
    expect(find.text(StudentProfile.personalEmail), findsOneWidget);
    expect(find.text(StudentProfile.studentId), findsOneWidget);
    tester.platformDispatcher.platformBrightnessTestValue = Brightness.light;
    await tester.pumpAndSettle();
    expect(
      Theme.of(tester.element(find.byType(Scaffold))).brightness,
      Brightness.light,
    );
    expect(find.text(StudentProfile.personalEmail), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Android startup recovers a photo returned after activity loss', (
    tester,
  ) async {
    final picker = FakeImagePicker()
      ..lostData = LostDataResponse(files: [avatarFixture()]);
    await pumpProfile(tester, picker: picker);
    await waitForPhotoIdle(tester);
    await tester.pumpAndSettle();
    expect(avatarPhoto(tester), isNotNull);
    expect(picker.calls, 0);
    expect(tester.takeException(), isNull);
  });

  testWidgets(
    'failed startup photo recovery offers a retry with initials intact',
    (tester) async {
      final picker = FakeImagePicker()
        ..lostData = LostDataResponse(
          exception: PlatformException(code: 'photo_access_denied'),
        );
      await pumpProfile(tester, picker: picker);
      expect(avatarPhoto(tester), isNull);
      expect(find.text(StudentProfile.initials), findsOneWidget);
      expect(find.text(AppLabels.retry), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );
}
