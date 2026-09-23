import 'dart:math';

import 'package:flutter/material.dart';

import '../config/app_constants.dart';
import '../core/color_generator.dart';

class GameRound {
  const GameRound({
    required this.options,
    required this.correctIndex,
    required this.targetLabel,
    required this.eventMultiplier,
    required this.eventTag,
  });

  final List<Color> options;
  final int correctIndex;
  final String targetLabel;
  final double eventMultiplier;
  final String eventTag;
}

class GameService {
  final _colorGenerator = const ColorGenerator();
  final Random _random = Random();

  GameRound nextRound({required int level, required int gridSize}) {
    final options = _colorGenerator.generatePalette(level: level, size: gridSize);
    final correctIndex = _random.nextInt(options.length);

    final hasEvent = _random.nextDouble() > 0.8;
    final eventTag = hasEvent ? (_random.nextBool() ? 'Double Points' : 'Slow Motion') : '';
    final eventMultiplier = eventTag == 'Double Points' ? 2.0 : 1.0;

    return GameRound(
      options: options,
      correctIndex: correctIndex,
      targetLabel: 'Aynısını bul',
      eventMultiplier: eventMultiplier,
      eventTag: eventTag,
    );
  }

  bool isFinished(int level) => level > AppConstants.maxLevel;
}
