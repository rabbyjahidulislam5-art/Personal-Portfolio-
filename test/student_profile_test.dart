import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:student_profile/data/student_profile.dart';
import 'package:student_profile/l10n/app_labels.dart';
import 'package:student_profile/widgets/profile_entrance.dart';

import 'support/profile_test_helpers.dart';

void main() {
  testWidgets('profile includes the supplied academics, projects and skills', (
    tester,
  ) async {
    await pumpProfile(tester);

    expect(find.text(StudentProfile.name), findsOneWidget);
    expect(find.text(StudentProfile.university), findsOneWidget);
    expect(find.text(StudentProfile.department), findsOneWidget);
    expect(find.text(StudentProfile.degree), findsOneWidget);
    for (final value in [
      '11th Semester',
      'Final Year',
      '3.52',
      '104',
      '2027',
    ]) {
      expect(find.text(value), findsOneWidget);
    }
    expect(find.text(StudentProfile.about), findsOneWidget);
    expect(find.text(StudentProfile.careerGoal), findsOneWidget);
    for (final project in StudentProfile.projects) {
      expect(find.text(project.title), findsOneWidget);
      expect(find.text(project.type), findsOneWidget);
      expect(find.text(project.description), findsOneWidget);
    }
    for (final group in StudentProfile.skillGroups.entries) {
      expect(find.text(group.key), findsOneWidget);
      for (final skill in group.value) {
        expect(find.text(skill), findsWidgets);
      }
    }
    for (final skill in StudentProfile.softSkills) {
      expect(find.text(skill), findsOneWidget);
    }
    for (final interest in [
      ...StudentProfile.technicalInterests,
      ...StudentProfile.hobbies,
    ]) {
      expect(find.text(interest), findsOneWidget);
    }
    expect(find.byType(Drawer), findsNothing);
    expect(find.byType(NavigationRail), findsNothing);
    expect(find.byType(NavigationBar), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('privacy hides every sensitive value including semantics', (
    tester,
  ) async {
    final semantics = tester.ensureSemantics();
    try {
      await pumpProfile(tester);
      await openDetails(tester, 'personal-details');
      await openDetails(tester, 'contact-details');

      final sensitive = [
        StudentProfile.studentId,
        StudentProfile.birthDate,
        StudentProfile.bloodGroup,
        StudentProfile.personalEmail,
        StudentProfile.universityEmail,
        StudentProfile.phone,
        StudentProfile.address,
      ];

      void expectPrivate() {
        for (final value in sensitive) {
          expect(find.textContaining(value), findsNothing);
          expect(
            find.byWidgetPredicate(
              (widget) =>
                  widget is Semantics &&
                  (widget.properties.label?.contains(value) ?? false),
            ),
            findsNothing,
          );
          expect(
            find.byWidgetPredicate(
              (widget) =>
                  widget is Tooltip && widget.message?.contains(value) == true,
            ),
            findsNothing,
          );
          expect(
            find.bySemanticsLabel(RegExp(RegExp.escape(value))),
            findsNothing,
          );
        }
      }

      expectPrivate();
      expect(find.text(StudentProfile.city), findsOneWidget);
      expect(find.text(StudentProfile.country), findsOneWidget);
      await chooseMenu(tester, 'privacy-menu', AppLabels.showPrivateDetails);
      for (final value in sensitive) {
        expect(find.text(value), findsOneWidget);
      }
      await chooseMenu(tester, 'privacy-menu', AppLabels.hidePrivateDetails);
      expectPrivate();
      expect(tester.takeException(), isNull);
    } finally {
      semantics.dispose();
    }
  });

  testWidgets('main actions have labeled Android-sized touch targets', (
    tester,
  ) async {
    final semantics = tester.ensureSemantics();
    try {
      await pumpProfile(tester);
      await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
      await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));
    } finally {
      semantics.dispose();
    }
  });

  testWidgets('details and GitHub actions remain labeled and reachable', (
    tester,
  ) async {
    final semantics = tester.ensureSemantics();
    try {
      await pumpProfile(tester);
      for (final label in [
        AppLabels.personalInformation,
        AppLabels.contactInformation,
        AppLabels.openGithub,
      ]) {
        await tester.ensureVisible(find.text(label));
        await tester.pumpAndSettle();
        await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
        await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));
      }
      expect(tester.takeException(), isNull);
    } finally {
      semantics.dispose();
    }
  });

  testWidgets('reduced motion shows entrance content on the first frame', (
    tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: MediaQuery(
          data: MediaQueryData(disableAnimations: true),
          child: ProfileEntrance(child: Text('Profile content')),
        ),
      ),
    );
    expect(find.text('Profile content'), findsOneWidget);
    expect(
      find.descendant(
        of: find.byType(ProfileEntrance),
        matching: find.byType(TweenAnimationBuilder<double>),
      ),
      findsNothing,
    );
    expect(tester.takeException(), isNull);
  });
}
