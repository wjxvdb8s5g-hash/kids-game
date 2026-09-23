import 'package:flutter/foundation.dart';

import '../models/achievement.dart';
import '../models/player.dart';

class AchievementProvider extends ChangeNotifier {
  List<Achievement> _achievements = const [
    Achievement(id: 'first_hit', title: 'İlk İsabet', description: 'İlk doğru dokunuşunu yap', target: 1),
    Achievement(id: 'sharp_eye', title: 'Keskin Göz', description: 'Doğruluk oranını %70 üstüne çıkar', target: 70),
    Achievement(id: 'combo_5', title: 'Combo Ustası', description: '5 komboya ulaş', target: 5),
    Achievement(id: 'score_500', title: '500 Puan', description: '500 puanı geç', target: 500),
    Achievement(id: 'speedster', title: 'Hız Şampiyonu', description: '350ms altı tepki süresi', target: 350),
    Achievement(id: 'level_5', title: 'Seviye Kaşifi', description: '5. seviyeye ulaş', target: 5),
    Achievement(id: 'clean_round', title: 'Hatasız Tur', description: '10 doğru, 0 yanlış', target: 10),
    Achievement(id: 'event_hunter', title: 'Etkinlik Avcısı', description: '3 mini event tamamla', target: 3),
    Achievement(id: 'streak_20', title: 'Seri 20', description: '20 isabet serisi', target: 20),
    Achievement(id: 'legend_seed', title: 'Mini Efsane', description: 'İlk premium rozeti aç', target: 1),
  ];

  List<Achievement> get achievements => _achievements;

  void evaluate(Player player) {
    _achievements = _achievements.map((achievement) {
      final unlocked = switch (achievement.id) {
        'first_hit' => player.totalMatches >= 1,
        'sharp_eye' => (player.accuracy * 100) >= 70,
        'combo_5' => player.totalMatches >= 5,
        'score_500' => player.highScore >= 500,
        'speedster' => player.fastestTapMs <= 350,
        'level_5' => player.highScore >= 250,
        'clean_round' => player.totalMatches >= 10 && player.totalMisses == 0,
        'event_hunter' => player.totalMatches >= 15,
        'streak_20' => player.totalMatches >= 20,
        'legend_seed' => player.highScore >= 750,
        _ => false,
      };
      return achievement.copyWith(unlocked: unlocked);
    }).toList();
    notifyListeners();
  }
}
