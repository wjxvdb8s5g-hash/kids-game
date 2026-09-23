import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../config/colors_palette.dart';
import '../providers/player_provider.dart';

class LeaderboardScreen extends StatelessWidget {
  const LeaderboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final board = context.watch<PlayerProvider>().leaderboard;

    return Scaffold(
      backgroundColor: ColorsPalette.background,
      appBar: AppBar(
        title: const Text('Leaderboard'),
        backgroundColor: ColorsPalette.card,
        foregroundColor: ColorsPalette.text,
      ),
      body: ListView.builder(
        itemCount: board.length,
        itemBuilder: (_, index) {
          final entry = board[index];
          return Semantics(
            label: 'Sıra ${index + 1}, oyuncu ${entry['name']}, skor ${entry['score']}',
            child: ListTile(
              leading: Text('#${index + 1}', style: const TextStyle(color: ColorsPalette.accent)),
              title: Text('${entry['name']}', style: const TextStyle(color: ColorsPalette.text)),
              trailing: Text('${entry['score']}', style: const TextStyle(color: ColorsPalette.text)),
            ),
          );
        },
      ),
    );
  }
}
