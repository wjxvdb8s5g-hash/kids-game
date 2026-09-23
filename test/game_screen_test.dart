import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kids_game/core/gesture_analyzer.dart';
import 'package:kids_game/providers/game_provider.dart';
import 'package:kids_game/providers/player_provider.dart';
import 'package:kids_game/screens/game_screen.dart';
import 'package:provider/provider.dart';

class _FakePlayerProvider extends PlayerProvider {
  int saveCalls = 0;

  @override
  Future<void> registerResult({
    required int score,
    required int matches,
    required int misses,
    required int fastestTap,
  }) async {
    saveCalls += 1;
  }
}

void main() {
  testWidgets('game screen saves completion result only once across rebuilds', (tester) async {
    final game = GameProvider()..startNewGame();
    final player = _FakePlayerProvider();

    for (var i = 0; i < 3; i++) {
      final wrongIndex = game.round.correctIndex == 0 ? 1 : 0;
      game.handleTap(
        index: wrongIndex,
        tap: const TapSample(pressure: 0.8, holdMs: 180, travelDistance: 1),
      );
    }
    expect(game.state.lives, 0);

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider<GameProvider>.value(value: game),
          ChangeNotifierProvider<PlayerProvider>.value(value: player),
        ],
        child: const MaterialApp(home: GameScreen()),
      ),
    );

    await tester.pump();
    expect(player.saveCalls, 1);

    await tester.pump();
    expect(player.saveCalls, 1);
  });

  testWidgets('game screen power-up buttons trigger provider behavior', (tester) async {
    final game = GameProvider()..startNewGame();
    final player = _FakePlayerProvider();
    final before = game.remainingMs;

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider<GameProvider>.value(value: game),
          ChangeNotifierProvider<PlayerProvider>.value(value: player),
        ],
        child: const MaterialApp(home: GameScreen()),
      ),
    );

    await tester.tap(find.text('Freeze'));
    await tester.pump();

    expect(game.remainingMs, greaterThan(before));
  });
}
