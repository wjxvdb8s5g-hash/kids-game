import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/achievement_provider.dart';
import 'providers/game_provider.dart';
import 'providers/player_provider.dart';
import 'screens/home_screen.dart';
import 'screens/splash_screen.dart';

void main() {
  runApp(const KidsGameApp());
}

class KidsGameApp extends StatelessWidget {
  const KidsGameApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => PlayerProvider()..load()),
        ChangeNotifierProxyProvider<PlayerProvider, AchievementProvider>(
          create: (_) => AchievementProvider(),
          update: (_, playerProvider, achievementProvider) {
            final provider = achievementProvider ?? AchievementProvider();
            provider.evaluate(playerProvider.player);
            return provider;
          },
        ),
        ChangeNotifierProvider(create: (_) => GameProvider()..startNewGame()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Kids Game',
        theme: ThemeData(
          useMaterial3: true,
          colorSchemeSeed: Colors.purple,
        ),
        home: const SplashScreen(),
        routes: {'/home': (_) => const HomeScreen()},
      ),
    );
  }
}
