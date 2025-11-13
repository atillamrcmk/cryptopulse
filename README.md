# 🚀 CryptoPulse

<div align="center">

![CryptoPulse Logo](lib/assets/Ekran%20görüntüsü%202025-11-13%20211821.png)

**Modern, profesyonel ve kullanıcı dostu kripto para ve döviz kuru takip uygulaması**

[![Flutter](https://img.shields.io/badge/Flutter-3.8.1+-02569B?logo=flutter)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.8.1+-0175C2?logo=dart)](https://dart.dev)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)
[![Platform](https://img.shields.io/badge/Platform-Android%20%7C%20iOS-lightgrey)](https://flutter.dev)

</div>

---

## 📱 Ekran Görüntüleri

<div align="center">

### Ana Ekranlar

| Market | Döviz Kurları | Portföy |
|:------:|:-------------:|:-------:|
| ![Market Screen](lib/assets/Ekran%20görüntüsü%202025-11-13%20211821.png) | ![Fiat Screen](lib/assets/Ekran%20görüntüsü%202025-11-13%20211921.png) | ![Portfolio Screen](lib/assets/Ekran%20görüntüsü%202025-11-13%20212256.png) |

### Detay Ekranları

| Coin Detay | Favoriler | Alarmlar |
|:----------:|:---------:|:--------:|
| ![Coin Detail](lib/assets/Ekran%20görüntüsü%202025-11-13%20212310.png) | ![Favorites](lib/assets/Ekran%20görüntüsü%202025-11-13%20212322.png) | ![Alarms](lib/assets/Ekran%20görüntüsü%202025-11-13%20212338.png) |

### Grafik ve Ayarlar

| Fiyat Grafiği | Ayarlar | Portföy Ekleme |
|:-------------:|:-------:|:--------------:|
| ![Chart](lib/assets/Ekran%20görüntüsü%202025-11-13%20212350.png) | ![Settings](lib/assets/Ekran%20görüntüsü%202025-11-13%20212403.png) | ![Add Portfolio](lib/assets/Ekran%20görüntüsü%202025-11-13%20212413.png) |

</div>

---

## ✨ Özellikler

### 🪙 Kripto Para Takibi
- ✅ **Popüler Coin Listesi**: BTC, ETH, SOL, AVAX ve daha fazlası
- ✅ **Anlık Fiyatlar**: USD, TRY, EUR para birimlerinde
- ✅ **24 Saatlik Değişim**: Yükseliş/düşüş yüzdeleri
- ✅ **Detaylı Metrikler**: Market cap, volume, rank bilgileri
- ✅ **İnteraktif Grafikler**: 24 saat, 7 gün, 30 gün, 90 gün, 1 yıl
- ✅ **Arama ve Filtreleme**: Coin ismi veya sembol ile arama
- ✅ **Coin Detay Sayfaları**: Her coin için kapsamlı bilgi

### 💱 Döviz Kurları
- ✅ **Gerçek Zamanlı Kurlar**: USD, EUR, GBP, TRY ve daha fazlası
- ✅ **Base Currency Seçimi**: İstediğiniz para birimini seçin
- ✅ **Otomatik Güncelleme**: Anlık kur bilgileri
- ✅ **Kolay Karşılaştırma**: Tüm para birimlerini bir arada görün

### 💼 Portföy Yönetimi
- ✅ **Kişisel Portföy**: Sahip olduğunuz coin'leri takip edin
- ✅ **Toplam Değer**: Portföyünüzün toplam değerini görün
- ✅ **24 Saatlik Değişim**: Portföy performansını takip edin
- ✅ **Coin Bazlı Takip**: Her coin için ayrı değer hesaplama
- ✅ **Kolay Ekleme/Silme**: Portföyünüzü kolayca yönetin

### ⭐ Favoriler ve Alarmlar
- ✅ **Favori Coin Listesi**: Sevdiğiniz coin'leri kaydedin
- ✅ **Fiyat Alarmları**: Hedef fiyata ulaşıldığında bildirim
- ✅ **Yukarı/Aşağı Kırılma**: İki yönlü alarm desteği
- ✅ **Kolay Yönetim**: Alarmları açıp kapatabilme

### 🎨 Kullanıcı Deneyimi
- ✅ **Modern UI/UX**: Temiz ve kullanıcı dostu arayüz
- ✅ **Koyu/Açık Tema**: Sistem, koyu veya açık tema seçimi
- ✅ **Çoklu Dil**: Türkçe ve İngilizce dil desteği
- ✅ **Pull-to-Refresh**: Verileri yenilemek için aşağı çekin
- ✅ **Hata Yönetimi**: Kullanıcı dostu hata mesajları
- ✅ **Loading States**: Yükleme durumları için animasyonlar
- ✅ **Cache Mekanizması**: Hızlı ve verimli veri yönetimi

---

## 🏗️ Mimari

### Clean Architecture

Proje **Clean Architecture** prensiplerine uygun olarak geliştirilmiştir:

```
lib/
├── core/                    # Çekirdek yapı
│   ├── config/              # Tema, renkler, sabitler
│   ├── network/             # Dio client, interceptors
│   ├── providers/           # Repository provider'ları
│   ├── utils/               # Yardımcı fonksiyonlar
│   └── widgets/             # Ortak widget'lar
│
├── features/                # Özellik bazlı modüller
│   ├── crypto/              # Kripto para özellikleri
│   │   ├── data/            # Data katmanı
│   │   │   ├── datasources/ # API çağrıları
│   │   │   ├── models/      # DTO'lar
│   │   │   └── repositories/# Repository implementasyonları
│   │   ├── domain/          # Domain katmanı
│   │   │   ├── entities/    # İş mantığı entity'leri
│   │   │   └── repositories/# Repository interface'leri
│   │   └── presentation/    # Presentation katmanı
│   │       ├── pages/       # Ekranlar
│   │       ├── providers/   # Riverpod provider'ları
│   │       └── widgets/     # UI widget'ları
│   │
│   ├── fiat/                # Döviz kurları
│   ├── portfolio/           # Portföy yönetimi
│   ├── settings/            # Ayarlar
│   ├── splash/              # Splash ekranı
│   └── home/                # Ana ekran (navigation)
│
└── main.dart                # Uygulama giriş noktası
```

### Katmanlar

1. **Domain Layer**: İş mantığı, entity'ler, repository interface'leri
2. **Data Layer**: API çağrıları, model mapping, repository implementasyonları
3. **Presentation Layer**: UI, state management, kullanıcı etkileşimleri

---

## 🛠️ Teknoloji Stack

### State Management
- **[Riverpod](https://riverpod.dev)** - Modern state management
- **FutureProvider** - Async data yönetimi
- **StateProvider** - Basit state yönetimi
- **Family Provider** - Parametreli provider'lar

### Network
- **[Dio](https://pub.dev/packages/dio)** - HTTP client
- **[Pretty Dio Logger](https://pub.dev/packages/pretty_dio_logger)** - API loglama
- **Interceptors** - Global hata yönetimi

### Local Storage
- **[Hive](https://pub.dev/packages/hive)** - Hızlı NoSQL database
- **[Shared Preferences](https://pub.dev/packages/shared_preferences)** - Basit key-value storage

### UI & Charts
- **[fl_chart](https://pub.dev/packages/fl_chart)** - İnteraktif grafikler
- **[Cached Network Image](https://pub.dev/packages/cached_network_image)** - Resim önbellekleme
- **[Shimmer](https://pub.dev/packages/shimmer)** - Loading animasyonları

### Utilities
- **[intl](https://pub.dev/packages/intl)** - Formatlama ve localization
- **[Equatable](https://pub.dev/packages/equatable)** - Value equality
- **[Freezed](https://pub.dev/packages/freezed)** - Immutable classes
- **[JSON Serializable](https://pub.dev/packages/json_serializable)** - JSON serialization

---

## 📡 API Entegrasyonları

### CoinGecko API
- **Endpoint**: `https://api.coingecko.com/api/v3`
- **Kullanım**: Kripto para fiyatları, grafik verileri, coin detayları
- **Rate Limit**: Ücretsiz plan ~10-50 istek/dakika
- **Endpoints**:
  - `/coins/markets` - Popüler coin listesi
  - `/coins/list` - Tüm coin listesi
  - `/simple/price` - Fiyat bilgileri
  - `/coins/{id}` - Coin detayları
  - `/coins/{id}/market_chart` - Grafik verileri

### Exchange Rate API
- **Endpoint**: `https://open.er-api.com/v6`
- **Kullanım**: Döviz kurları
- **Rate Limit**: Ücretsiz plan sınırlı
- **Endpoints**:
  - `/latest/{baseCurrency}` - Güncel kurlar

---

## 🚀 Kurulum

### Gereksinimler

- Flutter SDK 3.8.1 veya üzeri
- Dart 3.8.1 veya üzeri
- Android Studio / VS Code
- Android SDK (Android için)
- Xcode (iOS için)

### Adımlar

1. **Projeyi klonlayın**
   ```bash
   git clone https://github.com/kullaniciadi/cryptopulse.git
   cd cryptopulse
   ```

2. **Bağımlılıkları yükleyin**
   ```bash
   flutter pub get
   ```

3. **Code generation çalıştırın**
   ```bash
   flutter pub run build_runner build --delete-conflicting-outputs
   ```
   
   Bu komut şunları oluşturur:
   - Hive adapter'ları
   - JSON serialization kodları
   - Freezed sınıfları

4. **Uygulamayı çalıştırın**
   ```bash
   flutter run
   ```

### Platform Özel Kurulum

#### Android
```bash
cd android
./gradlew build
```

#### iOS
```bash
cd ios
pod install
```

---

## 📖 Kullanım

### İlk Çalıştırma

1. Uygulamayı açın
2. Splash ekranından sonra ana ekrana yönlendirileceksiniz
3. Market sekmesinde popüler coin'leri görebilirsiniz

### Market Ekranı

- **Arama**: Üstteki arama çubuğuna coin ismi veya sembol yazın
- **Coin Seçimi**: Bir coin'e tıklayarak detay sayfasına gidin
- **Yenileme**: Aşağı çekerek verileri yenileyin

### Coin Detay Ekranı

- **Fiyat Bilgileri**: Anlık fiyat ve 24 saatlik değişim
- **Grafik**: Farklı zaman aralıklarında fiyat grafiği
- **Metrikler**: Market cap, volume, rank bilgileri
- **Favorilere Ekle**: Kalp ikonuna tıklayın
- **Alarm Kur**: Bildirim ikonuna tıklayarak fiyat alarmı kurun

### Portföy Yönetimi

- **Coin Ekleme**: Sağ üstteki + butonuna tıklayın
- **Coin Seçimi**: Arama yaparak coin seçin
- **Miktar Girme**: Sahip olduğunuz miktarı girin
- **Silme**: Coin kartındaki çöp kutusu ikonuna tıklayın

### Döviz Kurları

- **Base Currency**: Sağ üstteki menüden para birimi seçin
- **Yenileme**: Aşağı çekerek kurları güncelleyin

### Ayarlar

- **Tema**: Koyu, Açık veya Sistem teması seçin
- **Dil**: Türkçe veya İngilizce seçin
- **Para Birimi**: Varsayılan para birimini ayarlayın

---

## 🎯 Özellik Detayları

### Grafik Özellikleri

- **Zaman Aralıkları**: 24 saat, 7 gün, 30 gün, 90 gün, 1 yıl
- **Para Birimleri**: TRY, USD, EUR
- **İnteraktif**: Grafik üzerine dokunarak fiyat bilgisi görün
- **Renk Kodlaması**: Yeşil (yükseliş), Kırmızı (düşüş)
- **Cache**: Grafik verileri otomatik cache'lenir

### Favoriler

- **Ekleme**: Coin detay sayfasından favorilere ekleyin
- **Liste**: Sağ alttaki kalp butonundan favorileri görün
- **Silme**: Favoriler ekranından çıkarabilirsiniz

### Alarmlar

- **Kurulum**: Coin detay sayfasından alarm kurun
- **Hedef Fiyat**: İstediğiniz fiyatı girin
- **Yön**: Yukarı veya aşağı kırılma seçin
- **Yönetim**: Alarmlar ekranından açıp kapatabilirsiniz

---

## 🐛 Bilinen Sorunlar ve Çözümler

### API Rate Limit

**Sorun**: CoinGecko API ücretsiz planı sınırlı istek yapabilir.

**Çözüm**:
- Grafik verileri otomatik cache'lenir
- Rate limit durumunda 1-2 dakika bekleyin
- Farklı coin'ler deneyin (her coin için ayrı cache)
- Grafik widget'ını gizleyebilirsiniz

### İnternet Bağlantısı

**Sorun**: İnternet bağlantısı yoksa veri alınamaz.

**Çözüm**:
- İnternet bağlantınızı kontrol edin
- Cache'lenmiş veriler gösterilir (varsa)
- Bağlantı kurulduğunda otomatik yenilenir

---

## 🤝 Katkıda Bulunma

Katkılarınızı bekliyoruz! Lütfen şu adımları izleyin:

1. Fork edin
2. Feature branch oluşturun (`git checkout -b feature/amazing-feature`)
3. Değişikliklerinizi commit edin (`git commit -m 'Add amazing feature'`)
4. Branch'inizi push edin (`git push origin feature/amazing-feature`)
5. Pull Request oluşturun

### Kod Standartları

- Dart style guide'a uyun
- Linter kurallarına uyun
- Yorum satırları ekleyin
- Test yazın (mümkünse)

---

## 📝 Lisans

Bu proje eğitim amaçlı geliştirilmiştir. MIT lisansı altında lisanslanmıştır.

---

## 👨‍💻 Geliştirici

**CryptoPulse Development Team**

- Flutter ile geliştirilmiştir
- Clean Architecture prensipleri kullanılmıştır
- Modern UI/UX tasarımı

---

## 🙏 Teşekkürler

- [CoinGecko](https://www.coingecko.com/) - Kripto para verileri için
- [Exchange Rate API](https://www.exchangerate-api.com/) - Döviz kurları için
- [Flutter Community](https://flutter.dev/community) - Harika paketler için

---

## 📞 İletişim

Sorularınız veya önerileriniz için issue açabilirsiniz.

---

<div align="center">

**⭐ Bu projeyi beğendiyseniz yıldız vermeyi unutmayın! ⭐**

Made with ❤️ using Flutter

</div>
