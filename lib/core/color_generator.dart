import 'dart:math';

import 'package:flutter/material.dart';

class ColorGenerator {
  const ColorGenerator();

  List<Color> generatePalette({required int level, required int size}) {
    final seed = level * 97 + size * 29;
    final random = Random(seed);
    return List.generate(size, (index) {
      final phase = (level + index + 1) / (size + 1);
      final hue = ((phase * 320) + random.nextDouble() * 20) % 360;
      final saturation = 0.62 + (sin(level + index) + 1) * 0.14;
      final value = 0.78 + (cos(level * 0.5 + index) + 1) * 0.08;
      return HSVColor.fromAHSV(1, hue, saturation.clamp(0.5, 0.9), value.clamp(0.65, 0.98)).toColor();
    });
  }
}
