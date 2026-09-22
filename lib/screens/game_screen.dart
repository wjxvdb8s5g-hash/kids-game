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

class GameScreen extends StatelessWidget {
  const GameScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<GameProvider>(
      builder: (context, game, _) {
        if (game.state.status == SessionStatus.completed && !game.completionReported) {
          context.read<PlayerProvider>().registerResult(
            score: game.state.score,
            matches: game.matches,
            misses: game.misses,
            fastestTap: game.fastestTap,
          );
          game.markCompletionReported();
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
                  child: Stack(
                    children: [
                      GameBoard(
                        colors: game.round.options,
                        onTap: (index, tap) => game.handleTap(
                          index: index,
                          tap: tap,
                        ),
                      ),
                      ParticleWidget(particles: game.particles),
                    ],
                  ),
                ),
                if (game.state.status == SessionStatus.completed)
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
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
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
