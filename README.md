🚀 CryptoPulse
<div align="center">

Modern, profesyonel ve kullanıcı dostu bir kripto para & döviz kuru takip uygulaması








</div>
📱 Ekran Görüntüleri

CryptoPulse, hem kullanıcı deneyimi hem de performans açısından özenle tasarlanmış bir uygulamadır.
Aşağıda uygulamanın ana ekranlarına ve modüllerine ait güncel görüntüler yer alır.

🏠 Ana Ekranlar
<p align="center"> <img src="lib/assets/Ekran%20görüntüsü%202025-11-13%20211821.png" width="30%" /> <img src="lib/assets/Ekran%20görüntüsü%202025-11-13%20211921.png" width="30%" /> <img src="lib/assets/Ekran%20görüntüsü%202025-11-13%20212256.png" width="30%" /> </p>

Bu bölümde görülen ekranlar:

Kripto Market: Popüler coin’ler, fiyatlar, 24h değişim oranları.

Döviz Kurları: USD, EUR, GBP, TRY gibi para birimlerinin anlık verileri.

Portföy: Kullanıcının toplam varlık değerini gösteren portföy ekranı.

📊 Detay, Favoriler ve Alarm Ekranları
<p align="center"> <img src="lib/assets/Ekran%20görüntüsü%202025-11-13%20212310.png" width="30%" /> <img src="lib/assets/Ekran%20görüntüsü%202025-11-13%20212322.png" width="30%" /> <img src="lib/assets/Ekran%20görüntüsü%202025-11-13%20212338.png" width="30%" /> </p>

İçerik:

Coin Detay Ekranı: Coin bilgileri, grafiği ve temel metrikleri.

Favoriler: Kullanıcının işaretlediği coin'lerin listesi.

Alarmlar: Fiyat yukarı/aşağı kırılınca tetiklenen bildirim ayarları.

📈 Grafikler ve Ayarlar
<p align="center"> <img src="lib/assets/Ekran%20görüntüsü%202025-11-13%20212350.png" width="30%" /> <img src="lib/assets/Ekran%20görüntüsü%202025-11-13%20212403.png" width="30%" /> <img src="lib/assets/Ekran%20görüntüsü%202025-11-13%20212413.png" width="30%" /> </p>

Bu bölümde:

Fiyat Grafikleri: 24 saat, 7 gün, 30 gün, 90 gün ve 1 yıl görünümü.

Ayarlar: Tema, dil ve varsayılan para birimi seçenekleri.

Portföy Ekleme: Kullanıcı portföyüne yeni coin ekleme ekranı.

✨ Özellikler
🪙 Kripto Para Takibi

Popüler coin listesi (BTC, ETH, SOL, AVAX…)

Anlık fiyatlar (USD, TRY, EUR)

24 saatlik değişim yüzdeleri

Market cap, volume, rank bilgileri

İnteraktif grafikler

Arama & filtreleme

💱 Döviz Kurları

USD, EUR, GBP, TRY ve daha fazlası

Base currency seçimi

Otomatik güncelleme

Kolay karşılaştırma

💼 Portföy Yönetimi

Portföyde coin ekleme/silme

Toplam değer görünümü

24 saatlik portföy performansı

Coin bazlı detaylı hesaplama

⭐ Favoriler & Alarmlar

Coin favorileme

Yukarı/Aşağı kırılma alarmı

Listeden aç/kapa yönetimi

Kalıcı Hive saklama

🎨 Kullanıcı Deneyimi

Modern UI/UX

Koyu/Açık tema

Çoklu dil

Pull-to-refresh

Hata yönetimi

Loading animasyonları

Cache mekanizması

🏗️ Mimari Yapı

Proje tamamen Clean Architecture prensibine göre hazırlanmıştır.

lib/
├── core/
│   ├── config/         # Tema, renkler, sabitler
│   ├── network/        # Dio client & interceptors
│   ├── providers/      # Repository provider'ları
│   ├── utils/          # Yardımcı fonksiyonlar
│   └── widgets/        # Ortak widgetlar
│
├── features/
│   ├── crypto/         # Kripto modülü
│   ├── fiat/           # Döviz modülü
│   ├── portfolio/      # Portföy
│   ├── settings/       # Ayarlar
│   ├── splash/         # Splash
│   └── home/           # Navigation
│
└── main.dart


Katmanlar:

Domain: İş mantığı, usecase, entity

Data: API, model, repository implementasyonu

Presentation: UI, state, widgetlar

🛠️ Teknolojiler

State Management: Riverpod

Network: Dio + Interceptors

Local Storage: Hive + SharedPreferences

Charts: fl_chart

Resim Cache: CachedNetworkImage

Animation: Shimmer

Intl, Freezed, JsonSerializable

Clean Architecture + Feature Based Structure

📡 API Entegrasyonları
🔹 CoinGecko API

Endpoint: https://api.coingecko.com/api/v3

/coins/markets

/simple/price

/coins/{id}

/coins/{id}/market_chart

🔹 Exchange Rate API

Endpoint: https://open.er-api.com/v6/latest/USD

🚀 Kurulum
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs
flutter run

🤝 Katkı

Pull Request ve Issue açabilirsiniz.

📞 İletişim

Sorular ve öneriler için iletişim kanallarından yazabilirsiniz.

<div align="center">

⭐ Projeyi beğendiysen yıldız vermeyi unutma! ⭐

</div>
