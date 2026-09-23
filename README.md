# kids-game

7+ yaş çocuklar için seviye sistemli, eğlenceli ve rekabetçi Flutter oyunu.

## Android APK Linki

Workflow ilk kez çalıştıktan sonra APK'yı buradan indirebilirsin:

- **Direct link (latest):** https://github.com/wjxvdb8s5g-hash/kids-game/releases/latest/download/kids-game.apk

> Not: Linkin aktif olması için repoda **Actions > Build Android APK** workflow'unun en az 1 kez başarılı çalışmış olması gerekir.

## Telefonda Kurulum (Android)

1. Linke telefondan girip `kids-game.apk` indir.
2. Gerekirse: **Ayarlar > Güvenlik > Bilinmeyen uygulama yükleme** izni ver.
3. İndirilen APK'ya dokunup yükle.

## Geliştirici için

Repo root'ta Android klasörü yoksa CI içinde otomatik üretilir:

- `flutter create . --platforms=android`

Bu sayede bilgisayar olmadan sadece APK linki paylaşımıyla kurulum yapılabilir.
