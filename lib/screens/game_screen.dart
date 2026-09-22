import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../config/colors_palette.dart';
import '../models/game_state.dart';
import '../models/power_up.dart';
import '../providers/game_provider.dart';
import '../providers/player_provider.dart';
import '../widgets/combo_meter.dart';
import '../widgets/game_board.dart';
import '../widgets/particle_widget.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  bool _savingResult = false;

  Future<void> _saveResultIfNeeded(GameProvider game) async {
    if (_savingResult || game.completionReported || game.state.status != SessionStatus.completed) {
      return;
    }
    _savingResult = true;
    try {
      await context.read<PlayerProvider>().registerResult(
            score: game.state.score,
            matches: game.matches,
            misses: game.misses,
            fastestTap: game.fastestTap,
          );
      game.markCompletionReported();
    } finally {
      _savingResult = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<GameProvider>(
      builder: (context, game, _) {
        if (game.state.status == SessionStatus.completed && !game.completionReported) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (!mounted) return;
            _saveResultIfNeeded(game);
          });
        }

        return Scaffold(
          backgroundColor: ColorsPalette.background,
          appBar: AppBar(
            title: Text('Level ${game.state.level}'),
            backgroundColor: ColorsPalette.card,
            foregroundColor: ColorsPalette.text,
          ),
          body: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Puan: ${game.state.score}', style: const TextStyle(color: ColorsPalette.text, fontSize: 18)),
                    Text('Can: ${game.state.lives}', style: const TextStyle(color: ColorsPalette.text, fontSize: 18)),
                    Text('Süre: ${(game.remainingMs / 1000).toStringAsFixed(1)}', style: const TextStyle(color: ColorsPalette.text, fontSize: 18)),
                    Text('x${game.state.multiplier}', style: const TextStyle(color: ColorsPalette.accent, fontSize: 18)),
                  ],
                ),
                const SizedBox(height: 12),
                ComboMeter(combo: game.state.combo),
                const SizedBox(height: 10),
                if (game.state.eventTag.isNotEmpty)
                  Text('Mini Event: ${game.state.eventTag}', style: const TextStyle(color: ColorsPalette.accent)),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  children: game.powerUps
                      .map(
                        (powerUp) => OutlinedButton(
                          onPressed: () => game.usePowerUp(powerUp.type),
                          child: Text(powerUp.type == PowerUpType.freeze ? 'Freeze' : 'Shield'),
                        ),
                      )
                      .toList(),
                ),
                const SizedBox(height: 14),
                Expanded(
                  child: game.state.status == SessionStatus.completed
                      ? Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Text('Oyun Bitti', style: TextStyle(color: ColorsPalette.text, fontSize: 24)),
                              const SizedBox(height: 8),
                              ElevatedButton(
                                onPressed: () {
                                  game.startNewGame();
                                },
                                child: const Text('Tekrar Oyna'),
                              ),
                            ],
                          ),
                        )
                      : Stack(
                          children: [
                            GameBoard(
                              colors: game.round.options,
                              onTap: (index, tap, origin) => game.handleTap(
                                index: index,
                                tap: tap,
                                origin: origin,
                              ),
                            ),
                            ParticleWidget(particles: game.particles),
                          ],
                        ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
