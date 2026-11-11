import 'package:flutter/material.dart';

import '../data/student_profile.dart';
import '../l10n/app_labels.dart';
import '../theme/app_theme.dart';
import 'info_row.dart';

class ProfileDetails extends StatelessWidget {
  const ProfileDetails({
    super.key,
    required this.revealPrivate,
    required this.personalExpanded,
    required this.contactExpanded,
    required this.onPersonalExpansionChanged,
    required this.onContactExpansionChanged,
  });

  final bool revealPrivate;
  final bool personalExpanded;
  final bool contactExpanded;
  final ValueChanged<bool> onPersonalExpansionChanged;
  final ValueChanged<bool> onContactExpansionChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _DetailsSection(
          id: 'personal-details',
          title: AppLabels.personalInformation,
          expanded: personalExpanded,
          revealPrivate: revealPrivate,
          onExpansionChanged: onPersonalExpansionChanged,
          children: [
            InfoRow(
              label: AppLabels.birthDate,
              value: StudentProfile.birthDate,
              hidden: !revealPrivate,
            ),
            const InfoRow(
              label: AppLabels.gender,
              value: StudentProfile.gender,
            ),
            const InfoRow(
              label: AppLabels.nationality,
              value: StudentProfile.nationality,
            ),
            InfoRow(
              label: AppLabels.bloodGroup,
              value: StudentProfile.bloodGroup,
              hidden: !revealPrivate,
            ),
          ],
        ),
        const SizedBox(height: AppSpace.lg),
        _DetailsSection(
          id: 'contact-details',
          title: AppLabels.contactInformation,
          expanded: contactExpanded,
          revealPrivate: revealPrivate,
          onExpansionChanged: onContactExpansionChanged,
          children: [
            InfoRow(
              label: AppLabels.personalEmail,
              value: StudentProfile.personalEmail,
              hidden: !revealPrivate,
            ),
            InfoRow(
              label: AppLabels.universityEmail,
              value: StudentProfile.universityEmail,
              hidden: !revealPrivate,
            ),
            InfoRow(
              label: AppLabels.phone,
              value: StudentProfile.phone,
              hidden: !revealPrivate,
            ),
            const InfoRow(label: AppLabels.city, value: StudentProfile.city),
            const InfoRow(
              label: AppLabels.country,
              value: StudentProfile.country,
            ),
            InfoRow(
              label: AppLabels.address,
              value: StudentProfile.address,
              hidden: !revealPrivate,
            ),
          ],
        ),
      ],
    );
  }
}

class _DetailsSection extends StatelessWidget {
  const _DetailsSection({
    required this.id,
    required this.title,
    required this.expanded,
    required this.revealPrivate,
    required this.onExpansionChanged,
    required this.children,
  });

  final String id;
  final String title;
  final bool expanded;
  final bool revealPrivate;
  final ValueChanged<bool> onExpansionChanged;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final shape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(AppStyle.cardRadius),
      side: BorderSide(color: AppStyle.border(colors)),
    );
    return ExpansionTile(
      key: ValueKey(id),
      initiallyExpanded: expanded,
      onExpansionChanged: onExpansionChanged,
      expansionAnimationStyle: MediaQuery.disableAnimationsOf(context)
          ? AnimationStyle.noAnimation
          : const AnimationStyle(
              duration: AppStyle.motion,
              curve: AppStyle.curve,
            ),
      backgroundColor: colors.surface,
      collapsedBackgroundColor: colors.surface,
      shape: shape,
      collapsedShape: shape,
      clipBehavior: Clip.antiAlias,
      iconColor: colors.primary,
      collapsedIconColor: colors.onSurfaceVariant,
      tilePadding: const EdgeInsets.symmetric(
        horizontal: AppSpace.card,
        vertical: AppSpace.sm,
      ),
      childrenPadding: const EdgeInsetsDirectional.fromSTEB(
        AppSpace.card,
        0,
        AppSpace.card,
        AppSpace.lg,
      ),
      expandedCrossAxisAlignment: CrossAxisAlignment.stretch,
      title: Semantics(
        header: true,
        child: Text(title, style: theme.textTheme.titleMedium),
      ),
      subtitle: Padding(
        padding: const EdgeInsets.only(top: AppSpace.xs),
        child: Text(
          revealPrivate
              ? AppLabels.privateDetailsVisible
              : AppLabels.privateDetailsHidden,
          style: theme.textTheme.bodySmall,
        ),
      ),
      children: children,
    );
  }
}
