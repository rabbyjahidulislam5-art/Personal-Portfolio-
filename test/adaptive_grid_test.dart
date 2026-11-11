import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:student_profile/widgets/adaptive_grid.dart';

void main() {
  testWidgets('grid tiles tilt gently while touched and return to rest', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Center(
            child: SizedBox(
              width: 360,
              child: AdaptiveGrid(
                minTileWidth: 140,
                children: const [
                  SizedBox(key: ValueKey('tile'), height: 120),
                  SizedBox(height: 120),
                ],
              ),
            ),
          ),
        ),
      ),
    );

    AnimatedContainer tileMotion() =>
        tester.widget<AnimatedContainer>(find.byType(AnimatedContainer).first);

    final tile = tester.getRect(find.byKey(const ValueKey('tile')));
    final gesture = await tester.startGesture(tile.center);
    await gesture.moveTo(tile.bottomRight - const Offset(2, 2));
    await tester.pump(const Duration(milliseconds: 150));
    expect(tileMotion().transform!.entry(1, 2), isNot(0));
    expect(tileMotion().transform!.entry(2, 1), isNot(0));

    await gesture.up();
    await tester.pumpAndSettle();
    expect(tileMotion().transform!.entry(1, 2), 0);
    expect(tileMotion().transform!.entry(2, 1), 0);
    expect(tester.takeException(), isNull);
  });
}
