import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../config/colors_palette.dart';
import '../providers/achievement_provider.dart';

class AchievementScreen extends StatelessWidget {
  const AchievementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final achievements = context.watch<AchievementProvider>().achievements;

    return Scaffold(
      backgroundColor: ColorsPalette.background,
      appBar: AppBar(
        title: const Text('Achievements'),
        backgroundColor: ColorsPalette.card,
        foregroundColor: ColorsPalette.text,
      ),
      body: ListView(
        children: achievements
            .map(
              (a) => Card(
                color: ColorsPalette.card,
                child: ListTile(
                  title: Text(a.title, style: const TextStyle(color: ColorsPalette.text)),
                  subtitle: Text(a.description, style: const TextStyle(color: Colors.white70)),
                  trailing: Icon(a.unlocked ? Icons.emoji_events : Icons.lock, color: a.unlocked ? Colors.amber : Colors.grey),
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}
