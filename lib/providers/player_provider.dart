import 'package:flutter/foundation.dart';

import '../models/player.dart';
import '../services/database_service.dart';

class PlayerProvider extends ChangeNotifier {
  final DatabaseService _databaseService = DatabaseService();

  Player _player = Player.empty;
  List<Map<String, dynamic>> _leaderboard = [];

  Player get player => _player;
  List<Map<String, dynamic>> get leaderboard => _leaderboard;

  Future<void> load() async {
    _player = await _databaseService.loadPlayer();
    _leaderboard = await _databaseService.loadLeaderboard();
    notifyListeners();
  }

  Future<void> registerResult({
    required int score,
    required int matches,
    required int misses,
    required int fastestTap,
  }) async {
    _player = _player.copyWith(
      highScore: score > _player.highScore ? score : _player.highScore,
      totalMatches: _player.totalMatches + matches,
      totalMisses: _player.totalMisses + misses,
      fastestTapMs: fastestTap >= 9999
          ? _player.fastestTapMs
          : (fastestTap < _player.fastestTapMs ? fastestTap : _player.fastestTapMs),
    );

    final nextBoard = [..._leaderboard];
    nextBoard.add({'name': _player.name, 'score': score, 'date': DateTime.now().toIso8601String()});
    nextBoard.sort((a, b) => (b['score'] as int).compareTo(a['score'] as int));
    _leaderboard = nextBoard.take(20).toList();

    await _databaseService.savePlayer(_player);
    await _databaseService.saveLeaderboard(_leaderboard);
    notifyListeners();
  }

  Future<void> saveAchievements(List<String> achievements, List<String> badges) async {
    _player = _player.copyWith(unlockedAchievements: achievements, badges: badges);
    await _databaseService.savePlayer(_player);
    notifyListeners();
  }
}
