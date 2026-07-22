# Test script to measure character length of text drafts
import os

draft_1 = """Turizm Defterim – Turizm Eğitimi, MEB Ders Notları ve Mesleki Gelişim Platformu

Turizm Defterim; turizm meslek lisesi öğrencileri, YKS/TYT/AYT adayları, öğretmenler, akademisyenler ve sektör profesyonelleri için geliştirilmiş Türkiye’nin en kapsamlı, %100 ücretsiz, reklamsız ve dijital turizm eğitimi platformudur.

Milli Eğitim Bakanlığı (MEB) Turizm ve Konaklama Hizmetleri müfredatına %100 uyumlu olarak hazırlanan bu interaktif ders defteri; teorik ders notlarını, sesli podcast anlatımlarını, resepsiyon vaka simülasyonlarını ve soru bankalarını tek bir mobil uygulamada bir araya getirir.

🌟 ÖNE ÇIKAN EĞİTİM MODÜLLERİ VE ÖZELLİKLER

📚 MEB Müfredatına Uyumlu Ders Notları
9, 10, 11 ve 12. sınıf turizm alanı ders konularını kapsayan güncel ders notları:
- Ön Büro & Konuk Giriş-Çıkış İşlemleri (Rezervasyon, check-in, check-out)
- Kat Hizmetleri (Housekeeping, oda temizliği, hijyen standartları)
- Konaklama İşletmeciliği & Otel Yönetimi
- Seyahat Acentacılığı, Tur ve Transfer Operasyonları
- Gastronomi Turizmi, Mutfak ve Yiyecek-İçecek Hizmetleri
- Sürdürülebilir Turizm, Dünya Coğrafyası ve Kültür Mirası
- Kongre, Fuar ve Etkinlik Yönetimi (MICE)
- Çamaşırhane ve Kuru Temizleme Operasyonları

🎙️ Sesli Ders Notları ve Turizm Podcast'leri
Ders notlarını dilediğiniz her yerde sesli dinleyin! Spotify / Anchor altyapılı yüksek kaliteli ses kayıtları ile sınavlara ve staj süreçlerine otobüste, evde ya da işte pratik bir şekilde hazırlanın.

🏨 İnteraktif Resepsiyon Simülasyonu ve Vaka Analizleri
Gerçek otel senaryolarına dayalı simülasyon oyunu ile kriz yönetimi, VIP konuk ağırlama, şikayet karşılama ve oda satışı becerilerinizi oyunlaştırılmış senaryolarla geliştirin.

📝 Soru Bankası, Deneme Sınavları ve Rozet Sistemi
- Seviyelere ayrılmış testler ile bilginizi ölçün.
- Yanlışlarınızı anında görün ve detaylı çözümlerle öğrenin.
- Testleri tamamladıkça XP puanları toplayın, seviye atlayın ve başarı rozetleri (Master Bellboy, Resepsiyon Şefi, Genel Müdür vb.) kazanın.

🔤 Turizm Terminolojisi ve Mesleki İngilizce
Sektörde kullanılan uluslararası otelcilik terimleri, acente terminolojisi ve mesleki İngilizce kelime kartları ile dil becerilerinizi güçlendirin. Çarkıfelek ve kelime bulmaca oyunları ile öğrenmeyi eğlenceli hale getirin.

🎓 KİMLER İÇİN UYGUNDUR?
- Turizm Meslek Lisesi Öğrencileri: Sınavlara, derslere ve staj dönemine eksiksiz hazırlık.
- Turizm ve Konaklama Öğretmenleri: Derste kullanılabilecek nitelikli dijital kaynak.
- Üniversite & MYO Öğrencileri: Turizm Rehberliği, Gastronomi ve Otel Yöneticiliği bölümlerine destek.
- Sektör Çalışanları ve Stajyerler: Resepsiyonist, Kat Görevlisi, Bellboy ve Acente çalışanları için mesleki rehber.

🔒 GÜVENLİ, REKLAMSIZ VE %100 ÜCRETSİZ
- Reklam Yok: Odaklanmanızı bozan hiç bir ticari reklam barındırmaz.
- Üye Olma Şartı Yok: Kayıt olmadan, kişisel veri paylaşmadan anında kullanmaya başlayın.
- İnternetsiz Kullanım: Ders notlarına ve sorulara çevrimdışı erişin.
- Gizlilik Odaklı: İlerlemeniz sadece kendi cihazınızın hafızasında tutulur.

Turizm Defterim ile mesleki eğitiminizi bir adım öne taşıyın, sektörün aranan profesyoneli olun!"""

print(f"Draft 1 Character Length: {len(draft_1)}")
"""

with open("test_draft.py", "w", encoding="utf-8") as f:
    f.write(draft_1)
