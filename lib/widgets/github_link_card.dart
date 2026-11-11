import 'package:flutter/material.dart';

import '../l10n/app_labels.dart';
import '../theme/app_theme.dart';

class GitHubLinkCard extends StatelessWidget {
  const GitHubLinkCard({super.key, required this.onOpen, this.opening = false});

  final VoidCallback onOpen;
  final bool opening;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final actionLabel = opening
        ? AppLabels.openingGithub
        : AppLabels.openGithub;
    return Semantics(
      container: true,
      link: true,
      label: actionLabel,
      enabled: !opening,
      liveRegion: opening,
      onTap: opening ? null : onOpen,
      child: ExcludeSemantics(
        child: Material(
          color: colors.primaryContainer,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppStyle.cardRadius),
          ),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: opening ? null : onOpen,
            focusColor: colors.onPrimaryContainer.withValues(alpha: .12),
            hoverColor: colors.onPrimaryContainer.withValues(alpha: .06),
            child: ConstrainedBox(
              constraints: const BoxConstraints(minHeight: 48),
              child: Padding(
                padding: const EdgeInsets.all(AppSpace.card),
                child: Row(
                  children: [
                    Icon(Icons.code_outlined, color: colors.onPrimaryContainer),
                    const SizedBox(width: AppSpace.lg),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            AppLabels.github,
                            style: theme.textTheme.titleMedium?.copyWith(
                              color: colors.onPrimaryContainer,
                            ),
                          ),
                          const SizedBox(height: AppSpace.xs),
                          Text(
                            actionLabel,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: colors.onPrimaryContainer,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: AppSpace.md),
                    Icon(
                      opening
                          ? Icons.hourglass_top_outlined
                          : Icons.open_in_new_outlined,
                      color: colors.onPrimaryContainer,
                      size: 20,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
