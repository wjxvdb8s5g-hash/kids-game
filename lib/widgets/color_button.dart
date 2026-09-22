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
    Offset? lastPosition;
    double traveledDistance = 0;
    double pressure = 0.5;
    return Material(
      color: color,
      borderRadius: BorderRadius.circular(16),
      child: Semantics(
        button: true,
        label: 'Renk kutusu',
        child: Listener(
          onPointerDown: (event) {
            pressure = event.pressure;
            downAt = DateTime.now();
            lastPosition = event.localPosition;
            traveledDistance = 0;
          },
          onPointerMove: (event) {
            final previous = lastPosition;
            if (previous != null) {
              traveledDistance += (event.localPosition - previous).distance;
            }
            lastPosition = event.localPosition;
            pressure = event.pressure;
          },
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            onTapUp: (details) {
              final holdMs = DateTime.now().difference(downAt ?? DateTime.now()).inMilliseconds;
              final previous = lastPosition;
              if (previous != null) {
                traveledDistance += (details.localPosition - previous).distance;
              }
              onPressed(
                TapSample(
                  pressure: details.kind == PointerDeviceKind.touch ? pressure : 0.5,
                  holdMs: holdMs.clamp(10, 1200),
                  travelDistance: traveledDistance,
                ),
              );
              downAt = null;
              lastPosition = null;
              traveledDistance = 0;
            },
          ),
        ),
      ),
    );
  }
}
