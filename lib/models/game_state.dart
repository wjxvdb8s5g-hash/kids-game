enum SessionStatus { idle, running, paused, completed }

class GameState {
  const GameState({
    required this.level,
    required this.score,
    required this.combo,
    required this.multiplier,
    required this.lives,
    required this.status,
    required this.eventTag,
  });

  final int level;
  final int score;
  final int combo;
  final int multiplier;
  final int lives;
  final SessionStatus status;
  final String eventTag;

  GameState copyWith({
    int? level,
    int? score,
    int? combo,
    int? multiplier,
    int? lives,
    SessionStatus? status,
    String? eventTag,
  }) {
    return GameState(
      level: level ?? this.level,
      score: score ?? this.score,
      combo: combo ?? this.combo,
      multiplier: multiplier ?? this.multiplier,
      lives: lives ?? this.lives,
      status: status ?? this.status,
      eventTag: eventTag ?? this.eventTag,
    );
  }

  static const initial = GameState(
    level: 1,
    score: 0,
    combo: 0,
    multiplier: 1,
    lives: 3,
    status: SessionStatus.idle,
    eventTag: '',
  );
}
