class Player {
  const Player({
    required this.name,
    required this.highScore,
    required this.totalMatches,
    required this.totalMisses,
    required this.fastestTapMs,
    required this.unlockedAchievements,
    required this.badges,
  });

  final String name;
  final int highScore;
  final int totalMatches;
  final int totalMisses;
  final int fastestTapMs;
  final List<String> unlockedAchievements;
  final List<String> badges;

  double get accuracy {
    final attempts = totalMatches + totalMisses;
    if (attempts == 0) return 0;
    return totalMatches / attempts;
  }

  Player copyWith({
    String? name,
    int? highScore,
    int? totalMatches,
    int? totalMisses,
    int? fastestTapMs,
    List<String>? unlockedAchievements,
    List<String>? badges,
  }) {
    return Player(
      name: name ?? this.name,
      highScore: highScore ?? this.highScore,
      totalMatches: totalMatches ?? this.totalMatches,
      totalMisses: totalMisses ?? this.totalMisses,
      fastestTapMs: fastestTapMs ?? this.fastestTapMs,
      unlockedAchievements: unlockedAchievements ?? this.unlockedAchievements,
      badges: badges ?? this.badges,
    );
  }

  Map<String, dynamic> toJson() => {
    'name': name,
    'highScore': highScore,
    'totalMatches': totalMatches,
    'totalMisses': totalMisses,
    'fastestTapMs': fastestTapMs,
    'unlockedAchievements': unlockedAchievements,
    'badges': badges,
  };

  factory Player.fromJson(Map<String, dynamic> json) => Player(
    name: json['name'] as String? ?? 'Player',
    highScore: json['highScore'] as int? ?? 0,
    totalMatches: json['totalMatches'] as int? ?? 0,
    totalMisses: json['totalMisses'] as int? ?? 0,
    fastestTapMs: json['fastestTapMs'] as int? ?? 9999,
    unlockedAchievements:
        (json['unlockedAchievements'] as List<dynamic>? ?? const [])
            .map((e) => '$e')
            .toList(),
    badges:
        (json['badges'] as List<dynamic>? ?? const []).map((e) => '$e').toList(),
  );

  static const empty = Player(
    name: 'Player',
    highScore: 0,
    totalMatches: 0,
    totalMisses: 0,
    fastestTapMs: 9999,
    unlockedAchievements: [],
    badges: [],
  );
}
