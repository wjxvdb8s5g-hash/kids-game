# kids-game

7+ yaş çocuklar için seviye sistemli, eğlenceli ve rekabetçi Flutter oyunu.

## Özellikler

- Seviye 1-10 akışı
- Dinamik renk üretimi
- Adaptif zorluk motoru
- Combo & multiplier puanlama
- Mini event (Double Points / Slow Motion)
- Achievement ekranı (ilk 10 başarı)
- Power-up: Freeze ve Shield
- Şifrelenmiş lokal veri saklama (obfuscation tabanlı)
- Lokal leaderboard

## Klasör Yapısı

`lib/` altında problem tanımındaki yapı korunmuştur:

- `config/`, `core/`, `models/`, `services/`, `providers/`, `screens/`, `widgets/`, `utils/`

## Çalıştırma

> Bu ortamda Flutter SDK olmadığı için burada çalıştırma/test komutları yürütülemedi. Aşağıdaki adımlar iPhone tarafında deneme içindir.

1. Flutter kur: <https://docs.flutter.dev/get-started/install/macos/mobile-ios>
2. Repo’yu çek:
   ```bash
   git clone https://github.com/wjxvdb8s5g-hash/kids-game.git
   cd kids-game
   flutter pub get
   ```
3. iOS Simulator aç:
   ```bash
   open -a Simulator
   flutter devices
   flutter run -d ios
   ```
4. Xcode ile:
   - `ios/Runner.xcworkspace` aç
   - Signing Team seç
   - Build & Run

## Test

```bash
flutter test
```
