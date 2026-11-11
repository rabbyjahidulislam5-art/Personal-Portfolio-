import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

/// Finite entrance; its state stays in place across theme and profile updates.
class ProfileEntrance extends StatelessWidget {
  const ProfileEntrance({
    super.key,
    required this.child,
    this.intervalStart = 0,
  });

  final Widget child;
  final double intervalStart;

  @override
  Widget build(BuildContext context) {
    if (MediaQuery.disableAnimationsOf(context)) return child;
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: AppStyle.entrance,
      curve: Interval(intervalStart, 1, curve: AppStyle.curve),
      child: child,
      builder: (context, value, child) => Transform.translate(
        offset: Offset(0, AppSpace.sm * (1 - value)),
        child: Opacity(opacity: value, child: child),
      ),
    );
  }
}
