import 'package:flutter/material.dart';

import '../l10n/app_labels.dart';
import '../theme/app_theme.dart';
import 'glass_card.dart';

class GitHubLinkCard extends StatefulWidget {
  const GitHubLinkCard({super.key, required this.onOpen, this.opening = false});

  final VoidCallback onOpen;
  final bool opening;

  @override
  State<GitHubLinkCard> createState() => _GitHubLinkCardState();
}

class _GitHubLinkCardState extends State<GitHubLinkCard> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final opening = widget.opening;
    final actionLabel = opening
        ? AppLabels.openingGithub
        : AppLabels.openGithub;
    return Semantics(
      container: true,
      link: true,
      label: actionLabel,
      enabled: !opening,
      liveRegion: opening,
      onTap: opening ? null : widget.onOpen,
      child: ExcludeSemantics(
        child: AnimatedScale(
          scale: _pressed ? AppStyle.pressScale : 1,
          duration: MediaQuery.disableAnimationsOf(context)
              ? Duration.zero
              : AppStyle.press,
          curve: AppStyle.curve,
          child: GlassCard(
            level: GlassLevel.accent,
            padding: EdgeInsets.zero,
            child: Material(
              type: MaterialType.transparency,
              borderRadius: BorderRadius.circular(AppStyle.cardRadius),
              clipBehavior: Clip.antiAlias,
              child: InkWell(
                onTap: opening ? null : widget.onOpen,
                onHighlightChanged: (value) => setState(() => _pressed = value),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(minHeight: 48),
                  child: Padding(
                    padding: const EdgeInsets.all(AppSpace.card),
                    child: Row(
                      children: [
                        Icon(
                          Icons.code_outlined,
                          size: AppStyle.icon,
                          color: colors.primary,
                        ),
                        const SizedBox(width: AppSpace.lg),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                AppLabels.github,
                                style: theme.textTheme.titleMedium,
                              ),
                              const SizedBox(height: AppSpace.xs),
                              Text(
                                actionLabel,
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: colors.onSurfaceVariant,
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
                          size: AppStyle.iconSm,
                          color: colors.primary,
                        ),
                      ],
                    ),
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
