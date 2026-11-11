import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

enum EntranceDirection { left, right, top, bottom }

/// Reveals each child once per viewport entry with paint-only motion.
class ProfileEntrance extends StatefulWidget {
  const ProfileEntrance({
    super.key,
    required this.child,
    this.index = 0,
    this.direction = EntranceDirection.bottom,
  });

  final Widget child;

  /// Position among items that appear together; each starts a beat later.
  final int index;
  final EntranceDirection direction;

  @override
  State<ProfileEntrance> createState() => _ProfileEntranceState();
}

class _ProfileEntranceState extends State<ProfileEntrance> {
  static const _enter = 40.0;
  static const _leave = 80.0;

  ScrollableState? _scrollable;
  ScrollPosition? _position;
  bool _checkScheduled = false;
  bool _shown = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final scrollable = Scrollable.maybeOf(context);
    final position = scrollable?.position;
    _scrollable = scrollable;
    if (position != _position) {
      _position?.removeListener(_scheduleCheck);
      _position = position;
      _position?.addListener(_scheduleCheck);
    }
    _scheduleCheck();
  }

  @override
  void dispose() {
    _position?.removeListener(_scheduleCheck);
    super.dispose();
  }

  void _scheduleCheck() {
    if (_checkScheduled || MediaQuery.disableAnimationsOf(context)) return;
    _checkScheduled = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkScheduled = false;
      if (!mounted || MediaQuery.disableAnimationsOf(context)) return;
      final box = context.findRenderObject();
      if (box is! RenderBox || !box.hasSize) return;
      final top = box.localToGlobal(Offset.zero).dy;
      final bottom = top + box.size.height;
      final viewport = _scrollable?.context.findRenderObject();
      var viewTop = 0.0;
      var viewBottom = MediaQuery.sizeOf(context).height;
      if (viewport is RenderBox && viewport.hasSize) {
        viewTop = viewport.localToGlobal(Offset.zero).dy;
        viewBottom = viewTop + viewport.size.height;
      }
      final inside = top < viewBottom - _enter && bottom > viewTop + _enter;
      final gone = top > viewBottom + _leave || bottom < viewTop - _leave;
      if (inside && !_shown) setState(() => _shown = true);
      if (gone && _shown) setState(() => _shown = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (MediaQuery.disableAnimationsOf(context)) return widget.child;
    final delay = _shown
        ? AppStyle.stagger * widget.index.clamp(0, 5)
        : Duration.zero;
    final total = AppStyle.entrance + delay;
    final from = switch (widget.direction) {
      EntranceDirection.left => const Offset(-AppStyle.entranceSlide, 0),
      EntranceDirection.right => const Offset(AppStyle.entranceSlide, 0),
      EntranceDirection.top => const Offset(0, -AppStyle.entranceRise),
      EntranceDirection.bottom => const Offset(0, AppStyle.entranceRise),
    };
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: _shown ? 1 : 0),
      duration: total,
      curve: Interval(
        delay.inMilliseconds / total.inMilliseconds,
        1,
        curve: AppStyle.curve,
      ),
      child: widget.child,
      builder: (context, value, child) {
        // Paint-only motion: no layout shift, and semantics stay available.
        // Content waiting off screen is left untransformed, so scrolling to
        // it (section bar, keyboard focus, screen reader) lands exactly on it.
        final remaining = _shown ? 1 - value : 0.0;
        return Transform.translate(
          offset: from * remaining,
          child: Transform.scale(
            scale: 1 - AppStyle.entranceShrink * remaining,
            alignment: Alignment.topCenter,
            child: Opacity(
              opacity: value,
              alwaysIncludeSemantics: true,
              child: child,
            ),
          ),
        );
      },
    );
  }
}
