import 'dart:async';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../config/app_constants.dart';
import '../core/difficulty_engine.dart';
import '../core/gesture_analyzer.dart';
import '../core/particle_engine.dart';
import '../core/score_calculator.dart';
import '../models/game_state.dart';
import '../models/power_up.dart';
import '../services/analytics_service.dart';
import '../services/audio_service.dart';
import '../services/game_service.dart';

class GameProvider extends ChangeNotifier {
  final GameService _gameService = GameService();
  DifficultyEngine _difficultyEngine = DifficultyEngine();
  final GestureAnalyzer _gestureAnalyzer = GestureAnalyzer();
  final ScoreCalculator _scoreCalculator = ScoreCalculator();
  final ParticleEngine _particleEngine = ParticleEngine();
  final AnalyticsService _analytics = AnalyticsService();
  final AudioService _audio = AudioService();

  GameState _state = GameState.initial;
  GameRound _round = const GameRound(options: [], correctIndex: 0, targetLabel: '', eventMultiplier: 1, eventTag: '');
  DifficultySnapshot _difficulty = const DifficultySnapshot(gridSize: 4, timeLimitMs: 6000, difficultyScore: 0.4);
  List<ParticleSpec> _particles = const [];
  final List<int> _reactionHistory = [];
  int _matches = 0;
  int _misses = 0;
  int _activeShield = 0;
  int _freezeBonusMs = 0;
  bool _freezeUsedThisRound = false;
  bool _completionReported = false;
  int _particleBurstVersion = 0;
  int _remainingMs = 6000;
  Timer? _roundTimer;

  final List<PowerUp> _powerUps = const [
    PowerUp(type: PowerUpType.freeze, name: 'Freeze Mode', description: '1 tur süreyi artırır', cooldownMs: 0),
    PowerUp(type: PowerUpType.shield, name: 'Shield', description: '1 hatayı yok sayar', cooldownMs: 0),
  ];

  GameState get state => _state;
  GameRound get round => _round;
  DifficultySnapshot get difficulty => _difficulty;
  List<ParticleSpec> get particles => _particles;
  List<PowerUp> get powerUps => _powerUps;
  int get matches => _matches;
  int get misses => _misses;
  int get fastestTap => _reactionHistory.isEmpty ? 9999 : _reactionHistory.reduce(min);
  bool get completionReported => _completionReported;
  int get remainingMs => _remainingMs;

  void startNewGame() {
    _state = GameState.initial.copyWith(status: SessionStatus.running, lives: AppConstants.initialLives);
    _matches = 0;
    _misses = 0;
    _reactionHistory.clear();
    _activeShield = 0;
    _freezeBonusMs = 0;
    _freezeUsedThisRound = false;
    _completionReported = false;
    _difficultyEngine = DifficultyEngine();
    _difficulty = const DifficultySnapshot(gridSize: 4, timeLimitMs: 6000, difficultyScore: 0.4);
    _prepareRound();
  }

  void usePowerUp(PowerUpType type) {
    if (type == PowerUpType.shield) {
      _activeShield = 1;
      _analytics.track('power_up_shield');
    }
    if (type == PowerUpType.freeze) {
      if (_freezeUsedThisRound) return;
      _freezeUsedThisRound = true;
      _freezeBonusMs += 1200;
      _remainingMs += 1200;
      _analytics.track('power_up_freeze');
    }
    notifyListeners();
  }

  void handleTap({required int index, required TapSample tap, Offset origin = Offset.zero}) {
    if (_state.status != SessionStatus.running) return;

    if (_gestureAnalyzer.isLikelyAccidental(tap)) {
      _analytics.track('accidental_tap');
      return;
    }

    final isCorrect = index == _round.correctIndex;
    final reactionMs = _gestureAnalyzer.normalizedReactionMs(tap);
    _reactionHistory.add(reactionMs);

    final scoreResult = _scoreCalculator.evaluate(
      isCorrect: isCorrect,
      currentCombo: _state.combo,
      eventMultiplier: _round.eventMultiplier,
    );

    var lives = _state.lives;
    if (!isCorrect) {
      if (_activeShield > 0) {
        _activeShield = 0;
      } else {
        lives -= 1;
        _misses += 1;
      }
      _audio.playError();
    } else {
      _matches += 1;
      _audio.playSuccess();
      _particles = _particleEngine.createBurst(origin: origin, level: _state.level);
      _particleBurstVersion += 1;
      final currentBurst = _particleBurstVersion;
      final clearAfterMs = _particles.map((p) => p.lifeMs).reduce(max);
      Future<void>.delayed(Duration(milliseconds: clearAfterMs + 40), () {
        if (_particles.isEmpty || currentBurst != _particleBurstVersion) return;
        _particles = const [];
        notifyListeners();
      });
    }

    final nextScore = max(0, _state.score + scoreResult.points);
    final levelUp = _matches > 0 && _matches % 6 == 0;
    final nextLevel = levelUp ? _state.level + 1 : _state.level;

    if (levelUp) {
      _audio.playLevelUp();
    }

    _state = _state.copyWith(
      score: nextScore,
      combo: scoreResult.combo,
      multiplier: scoreResult.multiplier,
      lives: lives,
      level: nextLevel,
      eventTag: _round.eventTag,
    );

    final avgReaction = _reactionHistory.reduce((a, b) => a + b) ~/ _reactionHistory.length;
    _difficulty = _difficultyEngine.update(
      accuracy: _matches == 0 ? 0 : _matches / (_matches + _misses),
      averageReactionMs: avgReaction,
      level: _state.level,
    );

    if (lives <= 0 || _gameService.isFinished(_state.level)) {
      _completeSession();
      return;
    }

    _prepareRound();
  }

  void _prepareRound() {
    _roundTimer?.cancel();
    _round = _gameService.nextRound(level: _state.level, gridSize: _difficulty.gridSize);
    _state = _state.copyWith(eventTag: _round.eventTag);
    _remainingMs = _difficulty.timeLimitMs + _freezeBonusMs;
    _freezeBonusMs = 0;
    _freezeUsedThisRound = false;
    _roundTimer = Timer.periodic(const Duration(milliseconds: 100), (_) {
      if (_state.status != SessionStatus.running) return;
      _remainingMs -= 100;
      if (_remainingMs <= 0) {
        _remainingMs = 0;
        int nextLives = _state.lives;
        if (_activeShield > 0) {
          _activeShield = 0;
        } else {
          _misses += 1;
          nextLives -= 1;
        }
        _state = _state.copyWith(lives: nextLives, combo: 0, multiplier: 1);
        if (nextLives <= 0) {
          _completeSession();
          return;
        }
        if (_gameService.isFinished(_state.level)) {
          _completeSession();
          return;
        }
        _prepareRound();
        return;
      }
      notifyListeners();
    });
    notifyListeners();
  }

  void markCompletionReported() {
    _completionReported = true;
    notifyListeners();
  }

  void _completeSession() {
    _roundTimer?.cancel();
    _remainingMs = 0;
    _state = _state.copyWith(status: SessionStatus.completed);
    notifyListeners();
  }

  @override
  void dispose() {
    _roundTimer?.cancel();
    super.dispose();
  }
}
