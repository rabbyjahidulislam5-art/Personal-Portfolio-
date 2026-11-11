import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image_picker/image_picker.dart';
import 'package:student_profile/app.dart';
import 'package:student_profile/data/student_profile.dart';
import 'package:student_profile/l10n/app_labels.dart';

class FakeImagePicker extends ImagePicker {
  XFile? selection;
  Object? failure;
  LostDataResponse lostData = LostDataResponse.empty();
  int calls = 0;
  ImageSource? lastSource;

  @override
  Future<XFile?> pickImage({
    required ImageSource source,
    double? maxWidth,
    double? maxHeight,
    int? imageQuality,
    CameraDevice preferredCameraDevice = CameraDevice.rear,
    bool requestFullMetadata = true,
  }) async {
    calls++;
    lastSource = source;
    if (failure case final failure?) throw failure;
    return selection;
  }

  @override
  Future<LostDataResponse> retrieveLostData() async => lostData;
}

XFile avatarFixture() => XFile.fromData(
  base64Decode(
    'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwCAAAAC0lEQVR42mNk'
    '+A8AAQUBAScY42YAAAAASUVORK5CYII=',
  ),
  name: 'avatar.png',
  mimeType: 'image/png',
);

Future<void> pumpProfile(
  WidgetTester tester, {
  FakeImagePicker? picker,
  Future<bool> Function(Uri)? openUrl,
  Size size = const Size(390, 844),
  double textScale = 1,
  Brightness brightness = Brightness.light,
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
      imagePicker: picker ?? FakeImagePicker(),
      openUrl: openUrl ?? (_) async => true,
    ),
  );
  await tester.pumpAndSettle();
}

Future<void> chooseMenu(WidgetTester tester, String key, String option) async {
  await tester.tap(find.byKey(ValueKey(key)));
  await tester.pumpAndSettle();
  final menuOption = find
      .ancestor(
        of: find.text(option).last,
        matching: find.byWidgetPredicate(
          (widget) => widget is PopupMenuItem<Object?>,
        ),
      )
      .first;
  await tester.ensureVisible(menuOption);
  await tester.pumpAndSettle();
  await tester.tap(menuOption.hitTestable());
  await tester.pumpAndSettle();
  expect(find.text(option), findsNothing, reason: 'The menu must dismiss.');
  if (key == 'privacy-menu') {
    expect(
      find.text(StudentProfile.studentId),
      option == AppLabels.showPrivateDetails ? findsOneWidget : findsNothing,
    );
  } else if (key == 'appearance-menu') {
    final expectedMode = {
      AppLabels.system: ThemeMode.system,
      AppLabels.light: ThemeMode.light,
      AppLabels.dark: ThemeMode.dark,
    }[option];
    expect(
      tester.widget<MaterialApp>(find.byType(MaterialApp)).themeMode,
      expectedMode,
    );
  }
}

Future<void> openDetails(WidgetTester tester, String key) async {
  final tile = find.byKey(ValueKey(key));
  final title = find.descendant(
    of: tile,
    matching: find.text(
      key == 'personal-details'
          ? AppLabels.personalInformation
          : AppLabels.contactInformation,
    ),
  );
  await tester.ensureVisible(title);
  await tester.pumpAndSettle();
  await tester.tap(title);
  await tester.pumpAndSettle();
}

Future<void> scrollToTop(WidgetTester tester) async {
  final scrollable = tester.state<ScrollableState>(
    find
        .descendant(
          of: find.byType(SingleChildScrollView),
          matching: find.byType(Scrollable),
        )
        .first,
  );
  scrollable.position.jumpTo(0);
  await tester.pumpAndSettle();
}

ImageProvider? avatarPhoto(WidgetTester tester) => tester
    .widget<CircleAvatar>(find.byType(CircleAvatar).first)
    .backgroundImage;

Future<void> choosePhoto(WidgetTester tester) async {
  await scrollToTop(tester);
  await tester.runAsync(() async {
    await tester.tap(find.byKey(const ValueKey('change-photo')));
  });
  await waitForPhotoIdle(tester);
  await tester.pumpAndSettle();
}

Future<void> waitForPhotoIdle(WidgetTester tester) async {
  // Engine decoding needs real time; finish when the control becomes available.
  final deadline = DateTime.now().add(const Duration(seconds: 3));
  await tester.pump();
  while (tester
          .widget<TextButton>(find.byKey(const ValueKey('change-photo')))
          .onPressed ==
      null) {
    if (DateTime.now().isAfter(deadline)) {
      fail('Photo selection did not finish within three seconds.');
    }
    await tester.runAsync(
      () => Future<void>.delayed(const Duration(milliseconds: 10)),
    );
    await tester.pump();
  }
}
