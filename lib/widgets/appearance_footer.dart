import 'package:flutter/material.dart';

import '../l10n/app_labels.dart';
import '../theme/app_theme.dart';
import 'glass_card.dart';

/// Page footer: the one place the theme is chosen. The lit segment is the
/// theme on screen now, including when it still follows the system.
class AppearanceFooter extends StatelessWidget {
  const AppearanceFooter({super.key, required this.onChanged});

  final ValueChanged<ThemeMode> onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    // At large text sizes the segments show icons only; tooltips name them.
    final showLabels = MediaQuery.textScalerOf(context).scale(16) / 16 <= 1.3;
    return GlassCard(
      level: GlassLevel.inset,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpace.lg,
        vertical: AppSpace.sm,
      ),
      child: Wrap(
        alignment: WrapAlignment.spaceBetween,
        crossAxisAlignment: WrapCrossAlignment.center,
        spacing: AppSpace.lg,
        runSpacing: AppSpace.sm,
        children: [
          Text(
            AppLabels.appearance,
            style: theme.textTheme.labelLarge?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          SegmentedButton<Brightness>(
            key: const ValueKey('theme-selector'),
            showSelectedIcon: false,
            segments: [
              ButtonSegment(
                value: Brightness.light,
                icon: const Icon(Icons.light_mode_outlined),
                label: showLabels ? const Text(AppLabels.light) : null,
                tooltip: AppLabels.lightMode,
              ),
              ButtonSegment(
                value: Brightness.dark,
                icon: const Icon(Icons.dark_mode_outlined),
                label: showLabels ? const Text(AppLabels.dark) : null,
                tooltip: AppLabels.darkMode,
              ),
            ],
            selected: {theme.brightness},
            onSelectionChanged: (selection) => onChanged(
              selection.first == Brightness.dark
                  ? ThemeMode.dark
                  : ThemeMode.light,
            ),
          ),
        ],
      ),
    );
  }
}
