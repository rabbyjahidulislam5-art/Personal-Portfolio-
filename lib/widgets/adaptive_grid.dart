import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

/// Lays [children] out in as many equal columns as fit [minTileWidth], from
/// the width that is actually available. Tiles in a row share one height.
class AdaptiveGrid extends StatelessWidget {
  const AdaptiveGrid({
    super.key,
    required this.children,
    required this.minTileWidth,
    this.maxColumns = 2,
    this.spacing = AppSpace.lg,
    this.runSpacing,
    this.fillLastRow = false,
  });

  final List<Widget> children;
  final double minTileWidth;
  final int maxColumns;

  /// Gap between columns, and between rows unless [runSpacing] is given.
  final double spacing;
  final double? runSpacing;

  /// When the last row is short, its tiles widen to fill it instead of
  /// leaving a gap.
  final bool fillLastRow;

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, constraints) {
      // Larger text needs wider tiles, so columns drop as text scales up.
      final scale = MediaQuery.textScalerOf(context).scale(16) / 16;
      final columns =
          ((constraints.maxWidth + spacing) / (minTileWidth * scale + spacing))
              .floor()
              .clamp(1, maxColumns);
      if (columns == 1) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: runSpacing ?? spacing,
          children: [
            for (final child in children) _GridTileMotion(child: child),
          ],
        );
      }
      return Column(
        spacing: runSpacing ?? spacing,
        children: [
          for (var start = 0; start < children.length; start += columns)
            IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                spacing: spacing,
                children: [
                  for (var i = start; i < start + columns; i++)
                    if (i < children.length)
                      Expanded(child: _GridTileMotion(child: children[i]))
                    else if (!fillLastRow)
                      const Spacer(),
                ],
              ),
            ),
        ],
      );
    },
  );
}

class _GridTileMotion extends StatefulWidget {
  const _GridTileMotion({required this.child});

  final Widget child;

  @override
  State<_GridTileMotion> createState() => _GridTileMotionState();
}

class _GridTileMotionState extends State<_GridTileMotion> {
  static const _maxTilt = 0.035;

  double _tiltX = 0;
  double _tiltY = 0;
  bool _pressed = false;

  void _updateTilt(PointerEvent event) {
    if (MediaQuery.disableAnimationsOf(context)) return;
    final box = context.findRenderObject();
    if (box is! RenderBox || !box.hasSize) return;
    final position = event.localPosition;
    final x = (position.dx / box.size.width * 2 - 1).clamp(-1.0, 1.0);
    final y = (position.dy / box.size.height * 2 - 1).clamp(-1.0, 1.0);
    setState(() {
      _pressed = true;
      _tiltX = -y * _maxTilt;
      _tiltY = x * _maxTilt;
    });
  }

  void _resetTilt(PointerEvent _) {
    if (!_pressed) return;
    setState(() {
      _pressed = false;
      _tiltX = 0;
      _tiltY = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    final transform = Matrix4.identity()
      ..setEntry(3, 2, 0.0015)
      ..rotateX(_tiltX)
      ..rotateY(_tiltY)
      ..scaleByDouble(
        _pressed ? 0.997 : 1,
        _pressed ? 0.997 : 1,
        _pressed ? 0.997 : 1,
        1,
      );
    return Listener(
      behavior: HitTestBehavior.translucent,
      onPointerDown: _updateTilt,
      onPointerMove: (event) {
        if (_pressed) _updateTilt(event);
      },
      onPointerUp: _resetTilt,
      onPointerCancel: _resetTilt,
      child: AnimatedContainer(
        duration: MediaQuery.disableAnimationsOf(context)
            ? Duration.zero
            : AppStyle.press,
        curve: AppStyle.curve,
        transform: transform,
        transformAlignment: Alignment.center,
        child: widget.child,
      ),
    );
  }
}
