import re
import sys

sys.stdout.reconfigure(encoding='utf-8')

dart_file = r'lib/core/data/courses/10_kat_hizmetleri_notes.dart'
desktop_file = r'C:\Users\erolm\Desktop\eklenenler ve çıkarılanlar bugün.txt'

with open(dart_file, 'r', encoding='utf-8') as f:
    text = f.read()

replacements = [
    ("Kat Arabalarının Hazırlanması ve Düzenlenmesi", "Kat Arabalarının Hazırlanması"),
    ("Odaya Giriş Kuralları ve Kapı Çalma", "Odaya Giriş Kuralları"),
    ("DND (Do Not Disturb) Rahatsız Etmeyin Kartı", "DND Kartı ve Oda Durumları"),
    ("Oda İlk Giriş Kontrolü ve Hasar Tespiti", "Oda İlk Giriş Kontrolü"),
    ("Yukarıdan Aşağıya Oda Temizleme Sırası", "Oda Temizleme Yöntemi"),
    ("Çöp ve Kirli Çamaşırların Toplanması", "Kirli Çamaşırların Toplanması"),
    ("Misafir Eşyalarının Korunması ve Düzeni", "Misafir Eşyalarının Korunması"),
    ("Buklet ve Oda Malzemelerinin Tamamlanması", "Buklet Malzemeleri Düzeni"),
    ("Alt Çarşaf Serim Yöntemi", "Çarşaf Serim Yöntemleri"),
    ("Zarf Köşe Yöntemi ile Çarşaf Serimi", "Zarf Köşe Yöntemi"),
    ("Klozet Temizliği ve Hijyeni", "Klozet Temizliği"),
    ("Klozet Hijyen Şeridi Kullanımı", "Hijyen Şeridi Kullanımı"),
    ("Restoran ve Yiyecek İçecek Alanları Temizliği", "Yiyecek İçecek Alanları Temizliği"),
    ("Toplantı Salonları Temizliği", "Toplantı Salonu Temizliği")
]

with open(desktop_file, 'a', encoding='utf-8') as df:
    df.write(f"\n==================================================\n")
    df.write(f"DERS: 10. Sınıf Kat Hizmetleri Atölyesi (Birebir Başlık Tamamlama)\n")
    df.write(f"==================================================\n")

for old_term, new_term in replacements:
    if old_term in text:
        text = text.replace(f'"name": "{old_term}"', f'"name": "{new_term}"')
        with open(desktop_file, 'a', encoding='utf-8') as df:
            df.write(f"  - ÇIKARILAN BAŞLIK: {old_term}\n")
            df.write(f"  + EKLENEN KİTAP BAŞLIĞI: {new_term}\n")

with open(dart_file, 'w', encoding='utf-8') as f:
    f.write(text)

print("10th Grade Kat Hizmetleri perfect match update complete!")
