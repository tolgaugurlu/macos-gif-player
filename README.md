

<div align="center">
  <h1>🎬 GIFPlayer</h1>
  <h3>Modern, Hızlı ve Kullanıcı Dostu GIF Oynatıcı</h3>
</div>

## 📖 Proje Hakkında

GIFPlayer, macOS için özel olarak tasarlanmış, modern ve kullanıcı dostu bir GIF oynatıcıdır. macOS ekosisteminde kaliteli ve özelleştirilebilir bir GIF oynatıcı eksikliğini gidermek amacıyla geliştirilmiştir.

### Neden GIFPlayer?

- 🎯 **Eksikliği Giderme**: macOS'ta yerleşik GIF oynatıcı bulunmaması ve mevcut çözümlerin yetersizliği
- 🚀 **Performans**: Native Swift ve Core Animation kullanarak optimize edilmiş performans
- 🎨 **Modern Tasarım**: macOS tasarım prensiplerine uygun, minimalist ve şık arayüz
- ⚡️ **Silicon Mac Uyumluluğu**: M1/M2/M3 işlemciler için özel optimizasyonlar

## ✨ Özellikler

### 🎬 Temel Özellikler
- **Yüksek Performanslı GIF Oynatma**
  - Core Animation tabanlı render motoru
  - Optimize edilmiş bellek kullanımı
  - Düşük CPU tüketimi

- **Gelişmiş Kontroller**
  - Oynat/Durdur
  - İleri/Geri sarma
  - Kare kare oynatma
  - Hız kontrolü (0.1x - 2.0x)
  - Döngü modu

- **Profesyonel Efektler**
  - Siyah-Beyaz
  - Sepya
  - Bulanık
  - Parlak
  - Negatif
  - Canlı

### 🎯 Kullanıcı Deneyimi
- **Sürükle-Bırak Desteği**
  - Dosya sürükleme sırasında görsel geri bildirim
  - Akıllı format kontrolü
  - Çoklu dosya desteği

- **Klavye Kısayolları**
  - Space: Oynat/Durdur
  - ←/→: Kare kontrolü
  - ↑/↓: Hız kontrolü
  - L: Döngü modu
  - ⌘O: Dosya açma
  - ⌘,: Tercihler
  - ⌘W: Pencereyi kapat

- **Detaylı Bilgi Gösterimi**
  - Kare sayısı ve pozisyonu
  - GIF boyutu ve çözünürlüğü
  - Dosya bilgileri
  - Performans metrikleri

## 🔧 Teknik Gereksinimler

- macOS 10.15 (Catalina) veya üzeri
- 64-bit Intel veya Apple Silicon işlemci
- Minimum 4GB RAM
- 50MB disk alanı

## 📦 Kurulum

### Hazır Uygulama
1. [Releases](https://github.com/tolgaugurlu/macos-gif-player/releases) sayfasından son sürümü indirin
2. DMG dosyasını açın
3. GIFPlayer.app'i Applications klasörüne sürükleyin

### Kaynak Koddan Derleme
1. Gereksinimler:
   - Xcode 12.0+
   - Swift 5.0+
   - Git

2. Repo'yu klonlayın:
```bash
git clone https://github.com/tolgaugurlu/macos-gif-player.git
cd macos-gif-player
```

3. Bağımlılıkları yükleyin:
```bash
xcodegen generate
```

4. Xcode projesini açın:
```bash
open GIFPlayer.xcodeproj
```

5. Projeyi derleyin (⌘B) ve çalıştırın (⌘R)

## 🎯 Kullanım Kılavuzu

### İlk Kullanım
1. Uygulamayı başlatın
2. GIF dosyası seçmek için:
   - "Aç" düğmesine tıklayın (⌘O)
   - veya bir GIF dosyasını pencereye sürükleyin

### Kontrol Paneli
- **Oynatma Kontrolleri**
  - Oynat/Durdur butonu veya Space tuşu
  - İleri/Geri sarma için ok tuşları
  - Hız kontrolü için kaydırıcı veya ↑/↓ tuşları

- **Efekt Menüsü**
  - Sağ üst köşedeki efekt menüsünden seçim yapın
  - Efektler gerçek zamanlı uygulanır
  - Birden fazla efekt kombinlenebilir

- **Bilgi Paneli**
  - Alt kısımdaki bilgi panelinde GIF detayları
  - Kare sayısı ve pozisyon bilgisi
  - Performans metrikleri

## 🤝 Katkıda Bulunma

Projeye katkıda bulunmak için:

1. Fork edin
2. Feature branch oluşturun (`git checkout -b feature/AmazingFeature`)
3. Değişikliklerinizi commit edin (`git commit -m 'feat: Harika özellik eklendi'`)
4. Branch'inizi push edin (`git push origin feature/AmazingFeature`)
5. Pull Request açın

### Commit Mesajları
Conventional Commits standardını kullanıyoruz:
- `feat:` Yeni özellik
- `fix:` Hata düzeltmesi
- `docs:` Dokümantasyon değişiklikleri
- `style:` Kod formatı değişiklikleri
- `refactor:` Kod yeniden yapılandırması
- `perf:` Performans iyileştirmeleri
- `test:` Test ekleme veya düzenleme
- `chore:` Genel bakım

## 📝 Lisans

Bu proje MIT lisansı altında lisanslanmıştır. Detaylar için [LICENSE](LICENSE) dosyasına bakın.

## 👨‍💻 Geliştirici

**Tolga Uğurlu**
- GitHub: [@tolgaugurlu](https://github.com/tolgaugurlu)
- LinkedIn: [Tolga Uğurlu](https://linkedin.com/in/tolgaugurlu)
- Twitter: [@tolgaaugurlu](https://twitter.com/tolgaaugurlu)

## 🙏 Teşekkürler

- Apple Developer Documentation
- Swift Community
- Core Animation Team
- Tüm katkıda bulunanlara

---

<div align="center">
  <p>Made with ❤️ in TURKEY</p>
  <p>Copyright © 2025 Tolga Uğurlu. All rights reserved.</p>
</div> 