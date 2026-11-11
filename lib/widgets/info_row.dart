import 'package:flutter/material.dart';

import '../l10n/app_labels.dart';
import '../theme/app_theme.dart';

/// A label with its value underneath. A value that can be copied or opened
/// shares one row with its copy button, so text and icon are centred on the
/// same line.
class InfoRow extends StatelessWidget {
  const InfoRow({
    super.key,
    required this.label,
    required this.value,
    this.onCopy,
    this.onAction,
    this.actionLabel,
  });

  final String label;
  final String value;
  final VoidCallback? onCopy;

  /// Tapping the value itself (for example an email address) runs this.
  final VoidCallback? onAction;
  final String? actionLabel;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final labelText = Text(
      label,
      style: theme.textTheme.labelLarge?.copyWith(
        color: colors.onSurfaceVariant,
      ),
    );
    final link = onAction != null;
    final valueText = Text(
      value,
      style: theme.textTheme.bodyLarge?.copyWith(
        color: link ? colors.primary : colors.onSurface,
        // Underlined as well as coloured, so a link is not shown by colour
        // alone.
        decoration: link ? TextDecoration.underline : null,
        decorationColor: colors.primary.withValues(alpha: 0.5),
      ),
    );

    if (!link && onCopy == null) {
      return MergeSemantics(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: AppSpace.sm),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              labelText,
              const SizedBox(height: AppSpace.xs),
              valueText,
            ],
          ),
        ),
      );
    }

    final Widget valueLine;
    if (link) {
      // A single long word such as an email cannot wrap cleanly, so it
      // shrinks slightly to stay on one line instead of breaking mid-word.
      valueLine = Tooltip(
        message: actionLabel,
        child: InkWell(
          onTap: onAction,
          borderRadius: BorderRadius.circular(AppStyle.chipRadius),
          child: ConstrainedBox(
            constraints: const BoxConstraints(minHeight: 48),
            child: Align(
              alignment: AlignmentDirectional.centerStart,
              child: FittedBox(
                fit: BoxFit.scaleDown,
                alignment: AlignmentDirectional.centerStart,
                child: valueText,
              ),
            ),
          ),
        ),
      );
    } else {
      // Ordinary text, such as an address, wraps onto as many lines as it
      // needs; the copy button stays centred beside it.
      valueLine = Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpace.xs),
        child: valueText,
      );
    }
    return Padding(
      padding: const EdgeInsets.only(top: AppSpace.sm),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          labelText,
          Row(
            children: [
              Expanded(child: valueLine),
              if (onCopy != null)
                IconButton(
                  onPressed: onCopy,
                  tooltip: AppLabels.copy(label),
                  icon: const Icon(
                    Icons.content_copy_outlined,
                    size: AppStyle.icon,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
