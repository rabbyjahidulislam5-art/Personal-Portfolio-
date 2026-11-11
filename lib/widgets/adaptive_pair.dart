import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class AdaptivePair extends StatelessWidget {
  const AdaptivePair({super.key, required this.first, required this.second});

  final Widget first;
  final Widget second;

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, constraints) {
      final scale = MediaQuery.textScalerOf(context).scale(16) / 16;
      return Flex(
        direction: constraints.maxWidth >= 800 && scale <= 1.3
            ? Axis.horizontal
            : Axis.vertical,
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: AppSpace.lg,
        children: constraints.maxWidth >= 800 && scale <= 1.3
            ? [Expanded(child: first), Expanded(child: second)]
            : [first, second],
      );
    },
  );
}
