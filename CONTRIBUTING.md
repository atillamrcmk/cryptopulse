# Katkıda Bulunma Rehberi

CryptoPulse projesine katkıda bulunmak istediğiniz için teşekkürler! Bu rehber, projeye nasıl katkıda bulunabileceğinizi açıklar.

## 🚀 Başlangıç

1. Projeyi fork edin
2. Repository'yi klonlayın:
   ```bash
   git clone https://github.com/kullaniciadi/cryptopulse.git
   cd cryptopulse
   ```
3. Bağımlılıkları yükleyin:
   ```bash
   flutter pub get
   flutter pub run build_runner build --delete-conflicting-outputs
   ```

## 📝 Kod Standartları

### Dart Style Guide
- [Effective Dart](https://dart.dev/guides/language/effective-dart) kurallarına uyun
- Linter kurallarına uyun (`analysis_options.yaml`)
- 2 space indentation kullanın
- 80 karakter satır uzunluğu (mümkünse)

### Naming Conventions
- **Classes**: PascalCase (`CryptoCoin`, `PriceChartData`)
- **Variables**: camelCase (`selectedDays`, `coinId`)
- **Constants**: lowerCamelCase (`appConstants`, `defaultTheme`)
- **Files**: snake_case (`crypto_coin.dart`, `price_chart_data.dart`)

### Code Organization
- Her feature kendi klasöründe
- Clean Architecture prensiplerine uyun
- Her dosyada tek bir sorumluluk
- Yorum satırları ekleyin (özellikle karmaşık mantık için)

## 🔀 Pull Request Süreci

1. **Branch oluşturun**:
   ```bash
   git checkout -b feature/amazing-feature
   ```

2. **Değişikliklerinizi yapın**:
   - Kod yazın
   - Test edin
   - Linter hatalarını düzeltin

3. **Commit edin**:
   ```bash
   git add .
   git commit -m "feat: Add amazing feature"
   ```

4. **Push edin**:
   ```bash
   git push origin feature/amazing-feature
   ```

5. **Pull Request oluşturun**:
   - GitHub'da PR açın
   - Açıklayıcı başlık ve açıklama yazın
   - Ekran görüntüleri ekleyin (UI değişiklikleri için)

### Commit Mesajları

[Conventional Commits](https://www.conventionalcommits.org/) formatını kullanın:

- `feat:` Yeni özellik
- `fix:` Hata düzeltmesi
- `docs:` Dokümantasyon
- `style:` Kod formatı (işlevsellik değişikliği yok)
- `refactor:` Kod refactoring
- `test:` Test ekleme/düzeltme
- `chore:` Build süreçleri, yardımcı araçlar

Örnek:
```
feat: Add price chart widget
fix: Resolve API rate limit issue
docs: Update README with screenshots
```

## 🧪 Test

- Mümkünse unit test yazın
- Widget testleri ekleyin
- Integration testleri (büyük özellikler için)

## 📋 Checklist

PR göndermeden önce:

- [ ] Kod linter kurallarına uyuyor
- [ ] Testler geçiyor (varsa)
- [ ] Dokümantasyon güncellendi
- [ ] Commit mesajları açıklayıcı
- [ ] Ekran görüntüleri eklendi (UI değişiklikleri için)
- [ ] Breaking changes belirtildi (varsa)

## 🐛 Bug Report

Bug bulduysanız:

1. Issue açın
2. Açıklayıcı başlık yazın
3. Adımları detaylıca açıklayın
4. Beklenen ve gerçek davranışı belirtin
5. Ekran görüntüleri ekleyin
6. Cihaz/OS bilgisi ekleyin

## 💡 Feature Request

Yeni özellik önerisi:

1. Issue açın
2. Özelliği detaylıca açıklayın
3. Kullanım senaryolarını belirtin
4. Alternatif çözümleri düşünün

## ❓ Sorular

Sorularınız için:
- Issue açabilirsiniz
- Discussions bölümünü kullanabilirsiniz

Teşekkürler! 🎉

