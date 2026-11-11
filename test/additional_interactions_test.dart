import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:student_profile/data/student_profile.dart';
import 'package:student_profile/l10n/app_labels.dart';
import 'package:student_profile/widgets/github_link_card.dart';

import 'support/profile_test_helpers.dart';

void main() {
  testWidgets('photo Retry opens the picker again and updates the avatar', (
    tester,
  ) async {
    final picker = FakeImagePicker()
      ..failure = PlatformException(code: 'photo_access_denied');
    await pumpProfile(tester, picker: picker);
    await choosePhoto(tester);
    expect(picker.calls, 1);
    expect(avatarPhoto(tester), isNull);
    expect(find.text(AppLabels.photoFailure), findsOneWidget);

    picker
      ..failure = null
      ..selection = avatarFixture();
    await tester.runAsync(() async {
      await tester.tap(find.text(AppLabels.retry));
    });
    await waitForPhotoIdle(tester);
    await tester.pumpAndSettle();
    expect(picker.calls, 2);
    expect(avatarPhoto(tester), isNotNull);
    expect(find.text(AppLabels.photoFailure), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('GitHub supports keyboard activation and blocks duplicate launches', (
    tester,
  ) async {
    final pending = Completer<bool>();
    var calls = 0;
    Uri? opened;
    await pumpProfile(
      tester,
      openUrl: (uri) {
        calls++;
        opened = uri;
        return pending.future;
      },
    );
    final label = find.text(AppLabels.openGithub);
    await tester.ensureVisible(label);
    await tester.pumpAndSettle();
    final focus = Focus.of(tester.element(label));
    focus.requestFocus();
    await tester.pump();
    expect(focus.hasFocus, isTrue);
    await tester.sendKeyEvent(LogicalKeyboardKey.enter);
    await tester.pump();

    expect(calls, 1);
    expect(opened, Uri.parse(StudentProfile.githubUrl));
    expect(find.text(AppLabels.openingGithub), findsOneWidget);
    final busySemantics = tester.widget<Semantics>(
      find.byWidgetPredicate(
        (widget) => widget is Semantics &&
            widget.properties.label == AppLabels.openingGithub,
      ),
    );
    expect(busySemantics.properties.enabled, isFalse);
    expect(busySemantics.properties.onTap, isNull);
    await tester.tap(find.byType(GitHubLinkCard));
    await tester.pump();
    expect(calls, 1);

    pending.complete(false);
    await tester.pumpAndSettle();
    expect(find.text(AppLabels.githubFailure), findsOneWidget);
    expect(find.text(AppLabels.openGithub), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
