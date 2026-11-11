import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:student_profile/data/student_profile.dart';
import 'package:student_profile/l10n/app_labels.dart';
import 'package:student_profile/widgets/appearance_footer.dart';
import 'package:student_profile/widgets/github_link_card.dart';
import 'package:student_profile/widgets/project_card.dart';
import 'package:student_profile/widgets/section_card.dart';

import 'support/profile_test_helpers.dart';

void main() {
  int selectedSection(WidgetTester tester) =>
      tester.widget<NavigationBar>(find.byType(NavigationBar)).selectedIndex;

  testWidgets('section bar jumps to a section and follows manual scrolling', (
    tester,
  ) async {
    await pumpProfile(tester);
    expect(selectedSection(tester), 0);

    await tester.tap(
      find.descendant(
        of: find.byType(NavigationBar),
        matching: find.text(AppLabels.navProjects),
      ),
    );
    await tester.pumpAndSettle();
    expect(selectedSection(tester), 3);
    final projects = find.ancestor(
      of: find.text(AppLabels.projects),
      matching: find.byType(SectionCard),
    );
    final viewportTop = tester.getTopLeft(find.byType(SingleChildScrollView));
    expect(
      tester.getTopLeft(projects).dy - viewportTop.dy,
      inInclusiveRange(0, 32),
    );

    profileScroll(tester).jumpTo(profileScroll(tester).maxScrollExtent);
    await tester.pumpAndSettle();
    expect(selectedSection(tester), 4);
    await scrollToTop(tester);
    expect(selectedSection(tester), 0);
    expect(tester.takeException(), isNull);
  });

  testWidgets('a section animates in from the background each time it is '
      'scrolled to', (tester) async {
    await pumpProfile(tester);
    final card = find.byType(GitHubLinkCard);
    Finder wrapper<T extends Widget>() =>
        find.ancestor(of: card, matching: find.byType(T)).first;
    double opacity() => tester.widget<Opacity>(wrapper<Opacity>()).opacity;
    double scale() =>
        tester.widget<Transform>(wrapper<Transform>()).transform.storage[0];

    // Waiting off screen: invisible, but not moved or resized, so scrolling
    // to it lands exactly on it.
    expect(opacity(), 0);
    expect(scale(), 1);

    Future<void> scrollTo() async {
      await tester.ensureVisible(card);
      await tester.pump();
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 120));
      // Part-way in: fading, and still slightly smaller than full size.
      expect(opacity(), inExclusiveRange(0, 1));
      expect(scale(), inExclusiveRange(0.94, 1));
      await tester.pumpAndSettle();
      expect(opacity(), 1);
      expect(scale(), 1);
    }

    await scrollTo();
    // Once it has left the screen completely it resets, and plays again on
    // the way back.
    await scrollToTop(tester);
    expect(opacity(), 0);
    await scrollTo();
    expect(tester.takeException(), isNull);
  });

  testWidgets('the items inside a section arrive one after another', (
    tester,
  ) async {
    await pumpProfile(tester, size: phoneLandscape);
    final tiles = find.byType(ProjectCard);
    double opacity(int index) => tester
        .widget<Opacity>(
          find
              .ancestor(of: tiles.at(index), matching: find.byType(Opacity))
              .first,
        )
        .opacity;
    await tester.ensureVisible(tiles.first);
    await tester.pump();
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 90));
    // Side by side, the second project starts a beat after the first.
    expect(opacity(0), greaterThan(opacity(1)));
    await tester.pumpAndSettle();
    expect(opacity(0), 1);
    expect(opacity(1), 1);
    expect(tester.takeException(), isNull);
  });

  testWidgets('header shows the student name once the hero scrolls away', (
    tester,
  ) async {
    await pumpProfile(tester);
    final nameInBar = find.descendant(
      of: find.byType(AppBar),
      matching: find.text(StudentProfile.name),
    );
    expect(nameInBar, findsNothing);
    await tester.ensureVisible(find.byType(GitHubLinkCard));
    await tester.pumpAndSettle();
    expect(nameInBar, findsOneWidget);
    await scrollToTop(tester);
    expect(nameInBar, findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('the email can be copied and opened, on one line with its '
      'copy button', (tester) async {
    final copied = <String>[];
    final opened = <Uri>[];
    tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
      SystemChannels.platform,
      (call) async {
        if (call.method == 'Clipboard.setData') {
          copied.add((call.arguments as Map)['text'] as String);
        }
        return null;
      },
    );
    addTearDown(
      () => tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
        SystemChannels.platform,
        null,
      ),
    );
    // The narrowest phone is where the address used to break in two.
    await pumpProfile(
      tester,
      size: const Size(320, 568),
      openUrl: (uri) async {
        opened.add(uri);
        return true;
      },
    );
    final email = find.text(StudentProfile.email);
    final copy = find.byTooltip(AppLabels.copy(AppLabels.email));
    await tester.ensureVisible(email);
    await tester.pumpAndSettle();

    // One line of text (it shrinks to fit rather than breaking mid-word),
    // centred on the same line as the copy icon.
    final line = tester.getRect(email);
    final style = tester.widget<Text>(email).style!;
    expect(line.height, lessThanOrEqualTo(style.fontSize! * style.height!));
    expect(
      tester.getCenter(email).dy,
      moreOrLessEquals(tester.getCenter(copy).dy, epsilon: 1),
    );
    expect(tester.getRect(copy).left, greaterThanOrEqualTo(line.right));

    await tester.tap(copy);
    await tester.pumpAndSettle();
    expect(copied, [StudentProfile.email]);
    expect(find.text(AppLabels.copied(AppLabels.email)), findsOneWidget);
    expect(
      find.descendant(
        of: find.byType(SnackBar),
        matching: find.textContaining('@'),
      ),
      findsNothing,
    );

    await tester.tap(find.byTooltip(AppLabels.sendEmail).first);
    await tester.pumpAndSettle();
    expect(opened, [Uri(scheme: 'mailto', path: StudentProfile.email)]);
    expect(tester.takeException(), isNull);
  });

  testWidgets('the phone number opens a telephone link', (tester) async {
    final opened = <Uri>[];
    await pumpProfile(
      tester,
      openUrl: (uri) async {
        opened.add(uri);
        return true;
      },
    );
    final call = find.byTooltip(AppLabels.callPhone);
    await tester.ensureVisible(call);
    await tester.pumpAndSettle();
    await tester.tap(call);
    await tester.pumpAndSettle();
    expect(opened, [Uri(scheme: 'tel', path: StudentProfile.phone)]);
    expect(tester.takeException(), isNull);
  });

  testWidgets('footer theme choice is restored and saved; bad values ignored', (
    tester,
  ) async {
    SharedPreferences.setMockInitialValues({'themeMode': 'dark'});
    final saved = await SharedPreferences.getInstance();
    await pumpProfile(tester, preferences: saved);
    expect(themeMode(tester), ThemeMode.dark);
    // The footer is the only theme control, and it shows what is active.
    expect(find.byType(AppearanceFooter), findsOneWidget);
    expect(find.byKey(const ValueKey('appearance-menu')), findsNothing);
    SegmentedButton<Brightness> selector() => tester.widget(
      find.byKey(const ValueKey('theme-selector'), skipOffstage: false),
    );
    expect(selector().selected, {Brightness.dark});
    await chooseTheme(tester, ThemeMode.light);
    expect(selector().selected, {Brightness.light});
    expect(saved.getString('themeMode'), 'light');

    SharedPreferences.setMockInitialValues({'themeMode': 'neon'});
    final corrupt = await SharedPreferences.getInstance();
    await tester.pumpWidget(const SizedBox());
    await pumpProfile(tester, preferences: corrupt);
    expect(themeMode(tester), ThemeMode.system);
    expect(tester.takeException(), isNull);
  });
}
