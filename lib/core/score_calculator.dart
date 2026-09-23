import '../config/game_config.dart';

class ScoreResult {
  const ScoreResult({required this.points, required this.multiplier, required this.combo});

  final int points;
  final int multiplier;
  final int combo;
}

class ScoreCalculator {
  ScoreResult evaluate({
    required bool isCorrect,
    required int currentCombo,
    required double eventMultiplier,
  }) {
    if (!isCorrect) {
      return const ScoreResult(points: -4, multiplier: 1, combo: 0);
    }

    final combo = currentCombo + 1;
    final multiplier = (1 + (combo / 3).floor()).clamp(1, GameConfig.maxComboMultiplier);
    final points = (GameConfig.basePoints * multiplier * eventMultiplier).round();
    return ScoreResult(points: points, multiplier: multiplier, combo: combo);
  }
}
