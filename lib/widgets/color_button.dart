import 'package:flutter/material.dart';
import 'dart:ui';

import '../core/gesture_analyzer.dart';

class ColorButton extends StatelessWidget {
  const ColorButton({super.key, required this.color, required this.onPressed});

  final Color color;
  final ValueChanged<TapSample> onPressed;

  @override
  Widget build(BuildContext context) {
    DateTime? downAt;
    return Material(
      color: color,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTapDown: (details) => downAt = DateTime.now(),
        onTapUp: (details) {
          final holdMs = DateTime.now().difference(downAt ?? DateTime.now()).inMilliseconds;
          onPressed(
            TapSample(
              pressure: details.kind == PointerDeviceKind.touch ? 0.7 : 0.5,
              holdMs: holdMs.clamp(10, 1200),
              travelDistance: 0,
            ),
          );
        },
      ),
    );
  }
}
