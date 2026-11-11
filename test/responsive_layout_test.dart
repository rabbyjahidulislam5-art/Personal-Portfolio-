import 'dart:ui' show DisplayFeature, DisplayFeatureType, DisplayFeatureState;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:student_profile/data/student_profile.dart';
import 'package:student_profile/l10n/app_labels.dart';
import 'package:student_profile/screens/student_profile_screen.dart';
import 'package:student_profile/theme/app_theme.dart';
import 'package:student_profile/widgets/glass_card.dart';
import 'package:student_profile/widgets/profile_hero.dart';
import 'package:student_profile/widgets/project_card.dart';
import 'package:student_profile/widgets/section_card.dart';
import 'package:student_profile/widgets/section_nav_bar.dart';

import 'support/profile_test_helpers.dart';

Finder card(String title) =>
    find.ancestor(of: find.text(title), matching: find.byType(SectionCard));

int selectedSection(WidgetTester tester) =>
    tester.widget<NavigationBar>(find.byType(NavigationBar)).selectedIndex;

void main() {
  const sizes = [
    Size(320, 568),
    phonePortrait,
    Size(390, 844),
    Size(568, 320),
    phoneLandscape,
    Size(844, 390),
    Size(768, 1024),
    Size(1024, 768),
    Size(1440, 900),
    Size(360, 720),
  ];

  // An overflowing row, column or grid reports an exception, so walking the
  // whole page at each size proves nothing is clipped or pushed off its card.
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
          await scrollThrough(tester);
          expect(find.byType(SingleChildScrollView), findsOneWidget);
          expect(tester.takeException(), isNull);
        });
      }
    }
  }

  testWidgets('upright, the hero stacks a large photo above the name', (
    tester,
  ) async {
    await pumpProfile(tester, size: phonePortrait);
    final photo = tester.getRect(find.byType(CircleAvatar));
    final name = tester.getRect(find.text(StudentProfile.name));
    expect(photo.bottom, lessThanOrEqualTo(name.top));
    expect(photo.center.dx, moreOrLessEquals(name.center.dx, epsilon: 1));
    expect(photo.width, 108);
    expect(tester.takeException(), isNull);
  });

  testWidgets('on its side, the hero puts a smaller photo beside the name', (
    tester,
  ) async {
    await pumpProfile(tester, size: phoneLandscape);
    final photo = tester.getRect(find.byType(CircleAvatar));
    final name = tester.getRect(find.text(StudentProfile.name));
    expect(photo.right, lessThan(name.left));
    expect(name.top, lessThan(photo.bottom));
    expect(photo.width, lessThan(90));
    expect(photo.width, moreOrLessEquals(photo.height, epsilon: 0.01));
    // The hero leaves room on the short screen for what follows.
    final hero = tester.getSize(find.byType(ProfileHero));
    expect(hero.height, lessThan(phoneLandscape.height * 0.65));
    expect(tester.getSize(find.byType(AppBar)).height, 48);
    expect(tester.takeException(), isNull);
  });

  testWidgets('cards and project tiles pair up when the width allows', (
    tester,
  ) async {
    await pumpProfile(tester, size: phonePortrait);
    Rect soft() => tester.getRect(card(AppLabels.softSkills));
    Rect career() => tester.getRect(card(AppLabels.careerGoal));
    Rect tile(int index) => tester.getRect(find.byType(ProjectCard).at(index));

    expect(career().top, greaterThan(soft().bottom));
    expect(tile(1).top, greaterThan(tile(0).bottom));

    await resize(tester, phoneLandscape);
    await scrollThrough(tester);
    expect(career().top, soft().top);
    expect(career().left, greaterThan(soft().right));
    expect(career().height, soft().height);
    expect(career().width, moreOrLessEquals(soft().width, epsilon: 0.01));
    // Two projects share a row at one height; the third fills its own row.
    expect(tile(1).top, tile(0).top);
    expect(tile(1).height, tile(0).height);
    expect(tile(2).top, greaterThan(tile(0).bottom));
    expect(tile(2).width, greaterThan(tile(0).width * 2));
    // Every tile stays inside the Projects card.
    final projects = tester.getRect(card(AppLabels.projects));
    for (var index = 0; index < StudentProfile.projects.length; index++) {
      expect(projects.contains(tile(index).topLeft), isTrue);
      expect(projects.contains(tile(index).bottomRight), isTrue);
    }
    expect(tester.takeException(), isNull);
  });

  testWidgets('the section bar stays at the bottom in every orientation', (
    tester,
  ) async {
    for (final size in const [phonePortrait, phoneLandscape, Size(1024, 768)]) {
      await pumpProfile(tester, size: size);
      // Navigation is never moved into the header.
      expect(
        find.descendant(
          of: find.byType(AppBar),
          matching: find.byType(IconButton),
        ),
        findsNothing,
      );
      final bar = tester.getRect(find.byType(NavigationBar));
      expect(bar.bottom, lessThanOrEqualTo(size.height));
      expect(bar.top, greaterThan(size.height * 0.75));
      expect(bar.center.dx, moreOrLessEquals(size.width / 2, epsilon: 0.5));
      expect(selectedSection(tester), 0);

      // Each destination is named even where its label is hidden.
      await tester.tap(find.byTooltip(AppLabels.navProjects));
      await tester.pumpAndSettle();
      expect(selectedSection(tester), 3);
      final viewport = tester.getRect(find.byType(SingleChildScrollView));
      final projects = tester.getRect(card(AppLabels.projects));
      expect(projects.top - viewport.top, inInclusiveRange(0, 32));
      expect(tester.takeException(), isNull);
      await tester.pumpWidget(const SizedBox());
    }
  });

  testWidgets('the highlight of the first and last section stays inside the '
      'rounded bar', (tester) async {
    for (final size in const [Size(320, 568), phonePortrait, phoneLandscape]) {
      await pumpProfile(tester, size: size);
      // The glass pill that holds the navigation, and the row of destinations
      // inside it.
      final pill = tester.getRect(
        find.ancestor(
          of: find.byType(NavigationBar),
          matching: find.byType(GlassCard),
        ),
      );
      final destinations = tester.getRect(find.byType(NavigationBar));
      // The larger landscape inset keeps the bigger highlights off the ends.
      final inset = size.width > size.height ? AppSpace.lg : AppSpace.md;
      expect(destinations.left - pill.left, inset);
      expect(pill.right - destinations.right, inset);
      expect(pill.center.dx, moreOrLessEquals(size.width / 2, epsilon: 0.5));
      for (final section in [AppLabels.navProfile, AppLabels.navContact]) {
        await tester.tap(find.byTooltip(section));
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
      }
      await tester.pumpWidget(const SizedBox());
    }
  });

  testWidgets('side margins stay equal when a camera cutout insets one side', (
    tester,
  ) async {
    // A phone on its side: the cutout takes 30px on the left only.
    tester.view.padding = const FakeViewPadding(left: 30);
    tester.view.viewPadding = const FakeViewPadding(left: 30);
    addTearDown(tester.view.resetPadding);
    addTearDown(tester.view.resetViewPadding);
    await pumpProfile(tester, size: phoneLandscape);
    const width = 780.0;

    final hero = tester.getRect(find.byType(ProfileHero));
    expect(hero.left, moreOrLessEquals(width - hero.right, epsilon: 0.01));
    expect(hero.left, greaterThanOrEqualTo(30));
    // The header title starts on the same line as the cards.
    expect(tester.getTopLeft(find.text(AppLabels.appTitle)).dx, hero.left);
    final bar = tester.getRect(find.byType(NavigationBar));
    expect(bar.center.dx, moreOrLessEquals(width / 2, epsilon: 0.5));

    await scrollThrough(tester);
    for (final title in [AppLabels.softSkills, AppLabels.careerGoal]) {
      expect(tester.getRect(card(title)).left, greaterThanOrEqualTo(hero.left));
    }
    final left = tester.getRect(card(AppLabels.softSkills));
    final right = tester.getRect(card(AppLabels.careerGoal));
    expect(left.left, moreOrLessEquals(width - right.right, epsilon: 0.01));
    expect(tester.takeException(), isNull);
  });

  testWidgets('rotating keeps the reader in the same section', (tester) async {
    await pumpProfile(tester, size: phonePortrait);
    await tester.tap(find.byTooltip(AppLabels.navProjects));
    await tester.pumpAndSettle();
    // Read a little way into the section before turning the phone.
    profileScroll(tester).jumpTo(profileScroll(tester).pixels + 300);
    await tester.pumpAndSettle();

    await resize(tester, phoneLandscape);
    expect(selectedSection(tester), 3);
    final viewport = tester.getRect(find.byType(SingleChildScrollView));
    final projects = tester.getRect(card(AppLabels.projects));
    expect(projects.top, lessThan(viewport.bottom));
    expect(projects.bottom, greaterThan(viewport.top));

    await resize(tester, phonePortrait);
    expect(selectedSection(tester), 3);
    expect(tester.takeException(), isNull);
  });

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
          onThemeChanged: (_) {},
          openUrl: (_) async => true,
        ),
      ),
    );
    await tester.pumpAndSettle();
    final heroBounds = tester.getRect(find.byType(ProfileHero));
    expect(heroBounds.left, greaterThanOrEqualTo(hinge.right));
    expect(heroBounds.right, lessThanOrEqualTo(size.width - 12));
    expect(heroBounds.top, greaterThanOrEqualTo(24));
    await scrollThrough(tester);
    expect(find.byType(SectionNavBar), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
