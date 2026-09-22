import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/player.dart';

class DatabaseService {
  static const _playerKey = 'player_data_v1';
  static const _scoresKey = 'leaderboard_v1';
  static const _xor = 73;

  String _encrypt(String input) {
    final bytes = utf8.encode(input).map((b) => b ^ _xor).toList();
    return base64Encode(bytes);
  }

  String _decrypt(String encrypted) {
    try {
      final bytes = base64Decode(encrypted).map((b) => b ^ _xor).toList();
      return utf8.decode(bytes);
    } catch (_) {
      return '{}';
    }
  }

  Future<void> savePlayer(Player player) async {
    final prefs = await SharedPreferences.getInstance();
    final raw = jsonEncode(player.toJson());
    await prefs.setString(_playerKey, _encrypt(raw));
  }

  Future<Player> loadPlayer() async {
    final prefs = await SharedPreferences.getInstance();
    final encrypted = prefs.getString(_playerKey);
    if (encrypted == null) return Player.empty;
    final raw = _decrypt(encrypted);
    return Player.fromJson(jsonDecode(raw) as Map<String, dynamic>);
  }

  Future<List<Map<String, dynamic>>> loadLeaderboard() async {
    final prefs = await SharedPreferences.getInstance();
    final encrypted = prefs.getString(_scoresKey);
    if (encrypted == null) return [];
    try {
      final raw = _decrypt(encrypted);
      final decoded = jsonDecode(raw);
      if (decoded is! List) return [];
      return decoded.map((e) => Map<String, dynamic>.from(e as Map)).toList();
    } catch (_) {
      return [];
    }
  }

  Future<void> saveLeaderboard(List<Map<String, dynamic>> entries) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_scoresKey, _encrypt(jsonEncode(entries)));
  }
}
