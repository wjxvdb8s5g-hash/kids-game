import 'package:flutter_test/flutter_test.dart';
import 'package:kids_game/core/difficulty_engine.dart';
import 'package:kids_game/core/score_calculator.dart';

void main() {
  test('score calculator increases multiplier with combo', () {
    final calc = ScoreCalculator();

    final first = calc.evaluate(isCorrect: true, currentCombo: 0, eventMultiplier: 1);
    final next = calc.evaluate(isCorrect: true, currentCombo: 5, eventMultiplier: 1);

    expect(first.multiplier, 1);
    expect(next.multiplier, greaterThan(first.multiplier));
  });

  test('difficulty engine adapts grid and time', () {
    final engine = DifficultyEngine();

    final easy = engine.update(accuracy: 0.5, averageReactionMs: 900, level: 1);
    final hard = engine.update(accuracy: 0.95, averageReactionMs: 250, level: 8);

    expect(hard.gridSize, greaterThanOrEqualTo(easy.gridSize));
    expect(hard.timeLimitMs, lessThanOrEqualTo(easy.timeLimitMs));
  });
}
