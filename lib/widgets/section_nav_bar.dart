import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../l10n/app_labels.dart';
import '../theme/app_theme.dart';
import 'glass_card.dart';

/// Floating glass bar that jumps between sections of the single profile
/// screen. It sits at the bottom in every orientation and screen size.
class SectionNavBar extends StatelessWidget {
  const SectionNavBar({
    super.key,
    required this.selected,
    required this.onSelected,
  });

  final ValueListenable<int> selected;
  final ValueChanged<int> onSelected;

  static const _sections = [
    (AppLabels.navProfile, Icons.person_outlined, Icons.person),
    (AppLabels.navAcademic, Icons.insights_outlined, Icons.insights),
    (AppLabels.navSkills, Icons.terminal_outlined, Icons.terminal),
    (AppLabels.navProjects, Icons.folder_outlined, Icons.folder),
    (AppLabels.navContact, Icons.contact_page_outlined, Icons.contact_page),
  ];
  static int get count => _sections.length;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screen = MediaQuery.sizeOf(context);
    final scale = MediaQuery.textScalerOf(context).scale(16) / 16;
    final landscape = screen.width > screen.height;
    final short = screen.height < AppBreak.short;
    final narrow = screen.width < AppBreak.navLabels || scale > 1.3;
    final page = AppStyle.background(theme.brightness).colors.last;
    return Semantics(
      container: true,
      label: AppLabels.sectionNavigation,
      // Behind the bar the page fades into the background colour, so no slice
      // of a card shows around or under it.
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: const [0, 0.6],
            colors: [page.withValues(alpha: 0), page],
          ),
        ),
        child: SafeArea(
          top: false,
          minimum: const EdgeInsets.all(AppSpace.sm),
          child: Center(
            heightFactor: 1,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: AppBreak.navWidth),
              child: GlassCard(
                level: GlassLevel.bar,
                radius: AppStyle.navRadius,
                // Keeps the first and last highlight clear of the rounded
                // ends of the bar.
                padding: EdgeInsets.symmetric(
                  horizontal: landscape ? AppSpace.lg : AppSpace.md,
                ),
                blurSigma: AppStyle.barBlur,
                // Only the bar rebuilds when the current section changes.
                child: ValueListenableBuilder<int>(
                  valueListenable: selected,
                  builder: (context, index, _) => NavigationBar(
                    height: landscape
                        ? 68
                        : short
                        ? 56
                        : 64,
                    selectedIndex: index,
                    onDestinationSelected: onSelected,
                    animationDuration: MediaQuery.disableAnimationsOf(context)
                        ? Duration.zero
                        : AppStyle.motion,
                    labelBehavior: short
                        ? NavigationDestinationLabelBehavior.alwaysHide
                        : narrow
                        ? NavigationDestinationLabelBehavior.onlyShowSelected
                        : NavigationDestinationLabelBehavior.alwaysShow,
                    destinations: [
                      for (final (label, icon, active) in _sections)
                        NavigationDestination(
                          icon: Icon(
                            icon,
                            size: landscape ? 26 : AppStyle.icon,
                          ),
                          selectedIcon: Icon(
                            active,
                            size: landscape ? 26 : AppStyle.icon,
                          ),
                          label: label,
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
