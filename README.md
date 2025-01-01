# macOS GIF Player

Modern ve kullanıcı dostu bir GIF oynatıcı uygulaması.

## Geliştirici
Tolga Uğurlu

## Özellikler

### Temel Özellikler
- 🎬 Animasyonlu GIF oynatma
- 🎨 Modern ve minimalist arayüz
- 🎮 Gelişmiş kontrol seçenekleri:
  - Oynat/Durdur
  - İleri/Geri sarma
  - Hız kontrolü (0.1x - 2.0x)
  - Kare kare oynatma
- 🎯 Özelleştirilebilir efektler:
  - Siyah-Beyaz
  - Sepya
  - Bulanık
  - Parlak
  - Negatif
  - Canlı
- 🔄 Döngü modu
- ⚡️ Yüksek performanslı oynatma

### Yeni Eklenen Özellikler
- 📱 Sürükle-Bırak Desteği
  - GIF dosyalarını doğrudan uygulama penceresine sürükleyip bırakabilme
  - Sürükleme sırasında görsel geri bildirim
  - Sadece GIF formatı desteği

- ⌨️ Klavye Kısayolları
  - Space: Oynat/Durdur
  - Sağ/Sol Ok: Kare kontrolü
  - Yukarı/Aşağı Ok: Hız kontrolü
  - L: Döngü modu
  - ⌘O: Dosya açma
  - Kısayol yardım penceresi (Klavye ikonuna tıklayarak açılır)

- 🔢 Kare Sayacı
  - Mevcut kare/toplam kare göstergesi
  - Yarı saydam modern tasarım

### Hata Yönetimi
- Geçersiz dosya formatı kontrolü
- Kullanıcı dostu hata mesajları
- Güvenli dosya işleme

## Gereksinimler
- macOS 10.15 (Catalina) veya üzeri
- Xcode 12.0+
- Swift 5.0+

## Kurulum
1. Projeyi klonlayın:
```bash
git clone https://github.com/tolgaugurlu/macos-gif-player.git
```
2. Xcode ile projeyi açın
3. Build & Run yapın

## Kullanım
1. Uygulamayı başlatın
2. GIF dosyası seçmek için:
   - "Aç" düğmesine tıklayın (veya ⌘O)
   - veya bir GIF dosyasını pencereye sürükleyin
3. Kontrol panelini kullanarak GIF'i yönetin:
   - Oynat/Durdur (Space)
   - Hız ayarı (↑/↓)
   - Efektler
   - Kare kontrolü (←/→)
4. Klavye kısayolları için sağ alt köşedeki klavye ikonuna tıklayın

## Git Kullanımı
Proje GitFlow yaklaşımını kullanmaktadır:
- `main`: Kararlı sürümler
- `develop`: Geliştirme dalı
- `feature/*`: Yeni özellikler
- `fix/*`: Hata düzeltmeleri

Commit mesajları şu formatta olmalıdır:
- `özellik: [özellik açıklaması]`
- `düzeltme: [hata açıklaması]`
- `belge: [döküman açıklaması]`

## Katkıda Bulunma
1. Projeyi fork edin
2. Feature branch oluşturun (`git checkout -b feature/amazing-feature`)
3. Değişikliklerinizi commit edin (`git commit -m 'özellik: Harika özellik eklendi'`)
4. Branch'inizi push edin (`git push origin feature/amazing-feature`)
5. Pull Request oluşturun

## Lisans
Bu proje MIT lisansı altında lisanslanmıştır. Detaylar için [LICENSE](LICENSE) dosyasına bakın. 