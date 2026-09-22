import 'package:flutter_test/flutter_test.dart';
import 'package:kids_game/core/gesture_analyzer.dart';
import 'package:kids_game/models/power_up.dart';
import 'package:kids_game/providers/game_provider.dart';
import 'package:kids_game/services/database_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('shield power-up prevents one life loss', () {
    final provider = GameProvider()..startNewGame();
    final initialLives = provider.state.lives;

    provider.usePowerUp(PowerUpType.shield);

    final wrongIndex = provider.round.correctIndex == 0 ? 1 : 0;
    provider.handleTap(
      index: wrongIndex,
      tap: const TapSample(pressure: 0.8, holdMs: 180, travelDistance: 1),
    );

    expect(provider.state.lives, initialLives);
  });

  test('completion report flag changes after marking', () {
    final provider = GameProvider()..startNewGame();
    expect(provider.completionReported, isFalse);

    provider.markCompletionReported();

    expect(provider.completionReported, isTrue);
  });

  test('freeze power-up extends active round timer', () {
    final provider = GameProvider()..startNewGame();
    final before = provider.remainingMs;

    provider.usePowerUp(PowerUpType.freeze);

    expect(provider.remainingMs, greaterThan(before));
  });

  test('database leaderboard load returns empty on invalid payload', () async {
    SharedPreferences.setMockInitialValues({'leaderboard_v1': 'not-valid-base64'});
    final database = DatabaseService();

    final entries = await database.loadLeaderboard();

    expect(entries, isEmpty);
  });
}
