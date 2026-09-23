import '../config/game_config.dart';

class DifficultySnapshot {
  const DifficultySnapshot({
    required this.gridSize,
    required this.timeLimitMs,
    required this.difficultyScore,
  });

  final int gridSize;
  final int timeLimitMs;
  final double difficultyScore;
}

class DifficultyEngine {
  double _difficulty = 0.45;

  DifficultySnapshot update({
    required double accuracy,
    required int averageReactionMs,
    required int level,
  }) {
    final reactionSignal = (1200 - averageReactionMs).clamp(0, 1000) / 1000;
    final accuracySignal = (accuracy - GameConfig.adaptiveTargetAccuracy) * 0.9;
    final levelPressure = level / 100;
    _difficulty = (_difficulty + accuracySignal + reactionSignal * 0.08 + levelPressure).clamp(0.2, 0.95);

    final gridSize = GameConfig.baseGridSize + (_difficulty * 4).floor();
    final timeLimitMs = (6200 - _difficulty * 3200).toInt().clamp(1800, 6200);

    return DifficultySnapshot(
      gridSize: gridSize,
      timeLimitMs: timeLimitMs,
      difficultyScore: _difficulty,
    );
  }
}
