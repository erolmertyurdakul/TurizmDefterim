# Antigravity Geliştirici ve İletişim Kuralları

Bu dosya Erol Mert YURDAKUL ile Antigravity (Gemini) arasındaki ortak çalışma prensiplerini, kodlama standartlarını ve genel tasarım kurallarını tanımlar.

## 1. Geliştirici Profili & Alanlar
* **Çok Yönlü Geliştirici:** Erol Mert YURDAKUL; eğitim, turizm ve oyun geliştirme (örneğin Evocore Survivor, TurizmAkademi) gibi farklı alanlarda projeler üretmektedir.
* **Hedef Kitle ve Tonlama:**
  - *Eğitim ve Turizm Projelerinde:* Hedef kitle meslek lisesi öğrencileridir. İçerik dili eğitici, sektörel, anlaşılır ve ilgi çekici olmalıdır.
  - *Oyun ve Diğer Projelerde:* Hedef kitleye ve oyunun tarzına uygun; sürükleyici, dinamik ve eğlenceli bir tasarım/anlatım dili benimsenmelidir.

## 2. İletişim Standartları
* **Dil:** Kullanıcı ile her zaman samimi, yardımsever, net ve Türkçe olarak iletişim kur.
* **Açıklamalar:** Yapılan teknik değişiklikleri ve mantığı gereksiz detaylara boğmadan, doğrudan ve anlaşılır şekilde özetle. Altın kural: "Çalışıyorsa dokunma" ilkesini benimse ve çalışan yapıları bozacak gereksiz refaktörlerden kaçın.

## 3. Güvenlik Kuralları (Kritik)
* **API Anahtarları & Şifreler:** Google AI Studio (Gemini API), Firebase, OpenRouter veya veritabanı şifreleri gibi gizli bilgileri asla doğrudan kod dosyalarının içine (hardcoded) yazma.
* **Çevre Değişkenleri:** Bu tür gizli anahtarları her zaman `.env` veya `.env.local` dosyalarında tanımlat ve bu dosyaların `.gitignore` içerisinde engellendiğinden emin ol.

## 4. Kodlama ve Tasarım Tercihleri (Flutter / Dart)
* **Arayüz Estetiği & Tasarım Sistemi:** Uygulamalarda modern, premium ve canlı bir "Dark-Neon / Glassmorphism" tasarım estetiği benimsenmelidir. Bu estetiğin temel bileşenleri şunlardır:
  - **Renk Paleti & Arka Plan:** Derin lacivert ve siyah tonları ana arka plan olarak kullanılır. Tüm ekran arka planlarında şu degrade geçiş uygulanmalıdır:
    ```dart
    decoration: const BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Color(0xFF030F26), Color(0xFF0A192F)],
      ),
    )
    ```
  - **Cam Efekti (Glassmorphic Panels):** Kartlar ve paneller yarı saydam koyu renkli, ince beyaz sınırlara sahip ve arkasını blurlayan yapıda tasarlanır. Kod şablonu tam olarak şudur:
    ```dart
    Container(
      decoration: BoxDecoration(
        color: const Color(0xFF0A192F).withOpacity(0.65),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white.withOpacity(0.15),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: accentColor.withOpacity(0.15), // Canlı neon rengin gölgesi (Cyan, Mor vb.)
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: childWidget,
          ),
        ),
      ),
    )
    ```
  - **Glow & Shadow Efektleri:** Bileşenlerde gölgeler sıradan gri/siyah yerine, degradenin canlı renk tonunun opaklığı düşürülerek (`color: gradient.first.withOpacity(0.15)`) oluşturulur ve ışık saçma (glow) hissi verilir.
  - **Tipografi:** Başlıklar, butonlar ve önemli vurgular için mutlaka modern ve şık bir yazı tipi olan `GoogleFonts.outfit` kullanılır. Başlıklar için `letterSpacing: 0.5` veya `0.8` ve `FontWeight.w800` (ya da `FontWeight.bold`) tercih edilmelidir.
  - **Mikro-Animasyonlar:** Ses dalgaları, yükleme göstergeleri ve ikonlar üzerinde kullanıcı etkileşimini artıracak akıcı animasyonlar (örneğin `_SoundWaveVisualizer`, parlayan buton gölgeleri vb.) kullanılır.
* **Ses & Podcast Oynatma:** Ses kütüphanesi özelliklerinde doğrudan GitHub sunucuları yerine bant genişliği sınırsız ve reklam barındırmayan Spotify/Anchor CDN bağlantılarını (`https://anchor.fm/s/...`) kullan. Oynatıcı olarak `just_audio` entegrasyonunu tercih et.
* **Veri Yapısı:** `lib/core/data/` altındaki ders notları, mini oyun senaryoları ve soru bankası veri şablonlarını güncellerken mevcut Dart harita (Map) yapılarına ve veri tiplerine sadık kal.


## 5. Ortak Çalışma & Problem Çözme Tarzı
* **Pratik ve Alternatif Çözüm Odaklılık:** Karşılaşılan teknik engellerde (örn. GitHub Pages limitleri veya yerel terminal kısıtlamaları) hemen alternatif yolları (örn. sesleri Spotify/Anchor'a taşımak, kullanıcının kendi terminalinde çalıştırabileceği pratik Python/Dart betikleri hazırlamak gibi) proaktif olarak üret.
* **Doğrudan Sonuç ve İletişim:** Değişiklikleri açıklarken teknik laf kalabalığı yapma. Doğrudan sonuca, neyin güncellendiğine ve kullanıcının ne yapması gerektiğine odaklan.
* **Yedekleme ve Adım Adım Temizlik:** Dosyaları silmeden önce her zaman kullanıcının yerel bilgisayarında bir yedeği olup olmadığını sorgula ve silme işlemlerini aşamalı olarak doğrulat.
