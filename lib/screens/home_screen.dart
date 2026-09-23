import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../config/colors_palette.dart';
import '../providers/game_provider.dart';
import '../providers/player_provider.dart';
import 'achievement_screen.dart';
import 'game_screen.dart';
import 'leaderboard_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final highScore = context.watch<PlayerProvider>().player.highScore;

    return Scaffold(
      backgroundColor: ColorsPalette.background,
      appBar: AppBar(
        title: const Text('Kids Premium Tap Quest'),
        backgroundColor: ColorsPalette.card,
        foregroundColor: ColorsPalette.text,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('En Yüksek Puan: $highScore', style: const TextStyle(fontSize: 18, color: ColorsPalette.text)),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                context.read<GameProvider>().startNewGame();
                Navigator.push(context, MaterialPageRoute(builder: (_) => const GameScreen()));
              },
              child: const Text('Oyuna Başla'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const LeaderboardScreen())),
              child: const Text('Leaderboard'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AchievementScreen())),
              child: const Text('Başarılar'),
            ),
          ],
        ),
      ),
    );
  }
}
