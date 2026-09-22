import 'package:flutter/material.dart';

import '../core/gesture_analyzer.dart';
import 'color_button.dart';

class GameBoard extends StatelessWidget {
  const GameBoard({super.key, required this.colors, required this.onTap});

  final List<Color> colors;
  final void Function(int index, TapSample tap, Offset origin) onTap;

  @override
  Widget build(BuildContext context) {
    final count = colors.length;
    final crossAxisCount = (count <= 9) ? 3 : 4;

    return GridView.builder(
      itemCount: colors.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemBuilder: (_, index) => ColorButton(color: colors[index], onPressed: (tap, origin) => onTap(index, tap, origin)),
    );
  }
}
