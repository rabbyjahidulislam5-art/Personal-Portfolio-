import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:student_profile/data/student_profile.dart';
import 'package:student_profile/l10n/app_labels.dart';
import 'package:student_profile/widgets/academic_overview.dart';
import 'package:student_profile/widgets/appearance_footer.dart';
import 'package:student_profile/widgets/github_link_card.dart';
import 'package:student_profile/widgets/info_row.dart';
import 'package:student_profile/widgets/profile_entrance.dart';
import 'package:student_profile/widgets/profile_hero.dart';
import 'package:student_profile/widgets/project_card.dart';

import 'support/profile_test_helpers.dart';

/// The value shown under [label] in a label/value row.
Finder valueOf(String label, String value) => find.descendant(
  of: find.ancestor(of: find.text(label), matching: find.byType(InfoRow)),
  matching: find.text(value),
);

Finder tileOf(ProfileProject project) => find.ancestor(
  of: find.text(project.title),
  matching: find.byType(ProjectCard),
);

void main() {
  testWidgets('profile includes the supplied academics, projects and skills', (
    tester,
  ) async {
    await pumpProfile(tester);

    expect(find.text(StudentProfile.name), findsOneWidget);
    expect(find.text(StudentProfile.university), findsOneWidget);
    expect(find.text(StudentProfile.degree), findsOneWidget);
    // The hero names the subject once, inside the degree, and carries the
    // university email.
    Finder inHero(Finder matching) =>
        find.descendant(of: find.byType(ProfileHero), matching: matching);
    expect(
      inHero(find.textContaining('Computer Science and Engineering')),
      findsOneWidget,
    );
    expect(inHero(find.text('2023-2-60-053@std.ewubd.edu')), findsOneWidget);
    expect(
      valueOf(
        AppLabels.universityAddress,
        'A/2, Jahurul Islam Avenue, Jahurul Islam City, Aftabnagar, '
        'Dhaka-1212, Bangladesh',
      ),
      findsOneWidget,
    );
    for (final value in [
      '11th Semester',
      'Final Year',
      '3.52 / 4.00',
      '104 / 140',
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
    // Phones get the section bar; it only scrolls within this one screen.
    expect(find.byType(NavigationBar), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('education details include SSC and HSC without altering EWU', (
    tester,
  ) async {
    await pumpProfile(tester);

    expect(find.text(StudentProfile.university), findsOneWidget);
    for (final record in StudentProfile.educationHistory) {
      expect(find.text(record.qualification), findsOneWidget);
      expect(find.text(record.institution), findsOneWidget);
      expect(find.text(record.group), findsWidgets);
      expect(find.text(record.academicBatch), findsOneWidget);
      if (record.board != null) {
        expect(find.text(record.board!), findsOneWidget);
      }
    }
    expect(tester.takeException(), isNull);
  });

  testWidgets('academic details label the credits and the grading scale', (
    tester,
  ) async {
    final semantics = tester.ensureSemantics();
    try {
      await pumpProfile(tester);
      // The achieved CGPA is always read together with its scale.
      expect(find.bySemanticsLabel(RegExp('3.52 out of 4.00')), findsOneWidget);
      expect(find.bySemanticsLabel(RegExp('104 out of 140')), findsOneWidget);
      expect(
        tester
            .widget<LinearProgressIndicator>(
              find.byType(LinearProgressIndicator),
            )
            .value,
        104 / 140,
      );
      // 4.00 on its own appears once, and only as the labelled scale.
      expect(find.text('4.00'), findsOneWidget);
      expect(valueOf(AppLabels.cgpaScale, '4.00'), findsOneWidget);
      expect(valueOf(AppLabels.totalCredits, '140'), findsOneWidget);
      expect(valueOf(AppLabels.major, 'Software Engineering'), findsOneWidget);
      expect(find.text('Major: Software Engineering'), findsOneWidget);
      expect(valueOf(AppLabels.batch, 'Summer 2023'), findsOneWidget);
      expect(tester.takeException(), isNull);
    } finally {
      semantics.dispose();
    }
  });

  testWidgets('relevant coursework lists the ten curriculum courses', (
    tester,
  ) async {
    await pumpProfile(tester);
    expect(find.text('Relevant Coursework'), findsOneWidget);
    // Completion of individual courses is not recorded, so it is not claimed.
    expect(find.textContaining('Completed Courses'), findsNothing);
    expect(StudentProfile.coursework, hasLength(10));
    Finder inCard(String text) => find.descendant(
      of: find.byType(CourseworkCard),
      matching: find.text(text),
    );
    for (final (code, title) in StudentProfile.coursework) {
      expect(inCard(code), findsOneWidget);
      expect(inCard(title), findsOneWidget);
    }
    expect(inCard('CSE430'), findsOneWidget);
    expect(inCard('Software Testing and Quality Assurance'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('projects show their stack and only the links they have', (
    tester,
  ) async {
    final opened = <String>[];
    await pumpProfile(
      tester,
      openUrl: (uri) async {
        opened.add('$uri');
        return true;
      },
    );
    final [caregiver, wallet, capstone] = StudentProfile.projects;
    expect(caregiver.title, 'Caregiver & Care Provider Web Application');
    expect(wallet.title, 'EWU Campus Wallet');
    expect(capstone.title, 'RDIS-HybridNet');

    for (final project in StudentProfile.projects) {
      final tile = tileOf(project);
      Finder inTile(Finder matching) =>
          find.descendant(of: tile, matching: matching);
      for (final technology in project.technologies) {
        expect(inTile(find.text(technology)), findsOneWidget);
      }
      expect(
        inTile(find.text(AppLabels.repository)),
        project.repoUrl == null ? findsNothing : findsOneWidget,
      );
      expect(
        inTile(find.text(AppLabels.watchDemo)),
        project.demoUrl == null ? findsNothing : findsOneWidget,
      );
      for (final button in [AppLabels.repository, AppLabels.watchDemo]) {
        final link = inTile(find.text(button));
        if (link.evaluate().isEmpty) continue;
        await tester.ensureVisible(link);
        await tester.pumpAndSettle();
        await tester.tap(link);
        await tester.pumpAndSettle();
      }
    }
    expect(opened, [
      'https://github.com/rabbyjahidulislam5-art/Caregiver.git',
      'https://github.com/rabbyjahidulislam5-art/EWU-Campus-Wallet.git',
      'https://youtu.be/CLjAjvE5RWI?si=fdL6OlsjYey84F7B',
    ]);

    // The database shown is the one the repositories use.
    expect(caregiver.technologies, contains('PostgreSQL'));
    expect(wallet.technologies, containsAll(['PostgreSQL', 'SSLCOMMERZ']));
    expect(caregiver.technologies, isNot(contains('Socket.IO')));
    expect(find.text('MySQL'), findsNothing);
    expect(
      find.descendant(
        of: tileOf(wallet),
        matching: find.textContaining(
          'East West University Central Payment System',
        ),
      ),
      findsOneWidget,
    );
    // The capstone is ongoing work with nothing to link to or measure.
    expect(capstone.category, 'Ongoing Capstone');
    expect(capstone.technologies, isEmpty);
    expect(capstone.repoUrl, isNull);
    expect(capstone.demoUrl, isNull);
    expect(tester.takeException(), isNull);
  });

  testWidgets('only supplied personal and contact details are shown', (
    tester,
  ) async {
    final semantics = tester.ensureSemantics();
    try {
      await pumpProfile(tester);
      await scrollThrough(tester);

      expect(find.byKey(const ValueKey('privacy-menu')), findsNothing);
      expect(find.byIcon(Icons.visibility_outlined), findsNothing);
      expect(find.byIcon(Icons.visibility_off_outlined), findsNothing);
      for (final label in [
        'private details',
        'Hidden',
        'Student ID',
        'Date of birth',
        'Blood group',
        'Street',
      ]) {
        expect(find.textContaining(label), findsNothing, reason: label);
        expect(
          find.bySemanticsLabel(RegExp(label)),
          findsNothing,
          reason: label,
        );
      }

      // The only emails and phone number are the ones the owner supplied.
      final texts = tester
          .widgetList<Text>(find.byType(Text))
          .map((text) => text.data ?? text.textSpan?.toPlainText() ?? '')
          .toList();
      expect(texts.where((text) => text.contains('@')).toSet(), {
        StudentProfile.email,
        StudentProfile.universityEmail,
      });
      final other = texts.where((text) => !text.contains('@'));
      for (final shape in [
        RegExp(r'\d{4}-\d-\d{2}-\d{3}'),
        RegExp(r'\b\d{1,2} \w+ (19|20)0\d\b'),
      ]) {
        expect(other.where(shape.hasMatch), isEmpty, reason: shape.pattern);
      }
      expect(other.where(RegExp(r'\d{10,}').hasMatch), [StudentProfile.phone]);
      expect(find.text(StudentProfile.city), findsOneWidget);
      expect(find.text(StudentProfile.country), findsOneWidget);
      expect(find.text(StudentProfile.phone), findsOneWidget);
      expect(find.text(StudentProfile.presentAddress), findsOneWidget);
      expect(find.text(StudentProfile.permanentAddress), findsOneWidget);
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

  testWidgets('links, contact and footer controls stay labeled and reachable', (
    tester,
  ) async {
    final semantics = tester.ensureSemantics();
    try {
      await pumpProfile(tester);
      for (final stop in [
        find.text(AppLabels.watchDemo),
        find.text(StudentProfile.email),
        find.byType(GitHubLinkCard),
        find.byType(AppearanceFooter),
      ]) {
        await tester.ensureVisible(stop);
        await tester.pumpAndSettle();
        await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
        await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));
      }
      // Each link button says which project it belongs to.
      expect(
        find.bySemanticsLabel('Open EWU Campus Wallet on GitHub'),
        findsOneWidget,
      );
      expect(
        find.bySemanticsLabel('Watch the EWU Campus Wallet demo video'),
        findsOneWidget,
      );
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
