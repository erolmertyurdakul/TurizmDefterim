import re
import sys

sys.stdout.reconfigure(encoding='utf-8')

desktop_file = r'C:\Users\erolm\Desktop\eklenenler ve çıkarılanlar bugün.txt'

# 1. Fix 10. Sınıf Konuk Giriş Çıkış İşlemleri
kgc_file = r'lib/core/data/courses/10_konuk_giris_cikis_notes.dart'
with open(kgc_file, 'r', encoding='utf-8') as f:
    kgc_text = f.read()

pattern_kgc = r'\{\s*"name": "Pre-Authorization \(Ön Provizyon\)",.*?\n\s*\}'
new_kgc = '''{
          "name": "Ön Provizyon İşlemleri",
          "desc": "Konuğun kredi kartından konaklama ve olası ekstra harcamalarını güvence altına almak amacıyla kart bakiye veya limitinin geçici olarak bloke edilmesi işlemidir.",
          "examples": [
            "Örnekle Pekiştirelim: Resepsiyon görevlisinin konuğun giriş kaydını yaparken kredi kartından 2.000 TL tutarında ön provizyon alarak oda harcamalarını güvenceye almasıdır."
          ]
        }'''

kgc_text_new, count_kgc = re.subn(pattern_kgc, new_kgc, kgc_text, flags=re.DOTALL)
if count_kgc > 0:
    with open(kgc_file, 'w', encoding='utf-8') as f:
        f.write(kgc_text_new)
    print("10th Grade Konuk Giriş Çıkış: Pre-Authorization updated to Ön Provizyon İşlemleri")
    with open(desktop_file, 'a', encoding='utf-8') as df:
        df.write(f"\n==================================================\n")
        df.write(f"DERS: 10. Sınıf Konuk Giriş Çıkış İşlemleri\n")
        df.write(f"==================================================\n")
        df.write(f"[ÖĞRENME BİRİMİ: Konuk Ödemeleri ve Çıkış İşlemleri]\n")
        df.write(f"  - ÇIKARILAN: Pre-Authorization (Ön Provizyon)\n")
        df.write(f"  + EKLENEN: Ön Provizyon İşlemleri\n")
        df.write(f"  > GEREKÇE: MEB 10. Sınıf Konuk Giriş Çıkış İşlemleri ders kitabında resmi terim 'Ön Provizyon İşlemleri' olarak geçmektedir.\n")

# 2. Fix 10. Sınıf Kat Hizmetleri Atölyesi
kat_file = r'lib/core/data/courses/10_kat_hizmetleri_notes.dart'
with open(kat_file, 'r', encoding='utf-8') as f:
    kat_text = f.read()

replacements_kat = [
    ("Kat Arabası Düzeni", "Kat Arabalarının Hazırlanması ve Düzenlenmesi", "MEB Kat Hizmetleri kitabında başlık Kat Arabalarının Hazırlanması olarak geçer."),
    ("Renk Kodlu Bez Standardı", "Renk Kodlu Temizlik Bezleri Kullanımı", "MEB standartlarında bez kullanım başlığı güncellendi."),
    ("Kapı Çalma Protokolü", "Odaya Giriş Kuralları ve Kapı Çalma", "MEB standartlarına göre odaya giriş kuralları terimi esas alındı."),
    ("DND (Rahatsız Etmeyin) Durumu", "DND (Do Not Disturb) Rahatsız Etmeyin Kartı", "MEB kitabındaki tam kart ismi kullanıldı."),
    ("İlk Göz Kontrolü ve Hasar Tespiti", "Oda İlk Giriş Kontrolü ve Hasar Tespiti", "MEB kitabındaki oda ilk kontrolü ifadesine uyarlandı."),
    ("Yukarıdan Aşağıya Kuralı", "Yukarıdan Aşağıya Oda Temizleme Sırası", "MEB kitabındaki temizlik tekniği başlığına uyarlandı."),
    ("Çöplerin ve Kirli Tekstillerin Toplanması", "Çöp ve Kirli Çamaşırların Toplanması", "MEB terminolojisi esas alındı."),
    ("Elektrikli Süpürge Çekimi ve Paspaslama", "Zemin Süpürme ve Paspaslama İşlemleri", "MEB terminolojisine uyarlandı."),
    ("Misafir Eşyalarına Saygı", "Misafir Eşyalarının Korunması ve Düzeni", "Pedagojik ve resmi MEB tanımına uyarlandı."),
    ("Buklet Malzemelerinin Yenilenmesi", "Buklet ve Oda Malzemelerinin Tamamlanması", "MEB malzemeler başlığı uyarlandı."),
    ("Hijyenik Söküm Teknikleri", "Kirli Yatak Çarşaflarının Sökümü ve Hijyen", "MEB çarşaf söküm prosedürüne uyarlandı."),
    ("Alt Çarşafın Serilmesi", "Alt Çarşaf Serim Yöntemi", "MEB yatak yapma standartlarına uyarlandı."),
    ("Zarf Köşesi (Hospital Corner) Yapımı", "Zarf Köşe Yöntemi ile Çarşaf Serimi", "MEB kitabındaki resmi yöntem adı esas alındı."),
    ("Klozet Temizliği ve Dezenfeksiyonu", "Klozet Temizliği ve Hijyeni", "MEB kitabındaki başlığa uyarlandı."),
    ("Buklet Malzemelerinin Yerleşimi", "Banyo Buklet Malzemeleri Düzeni", "MEB banyo düzenleme başlığına uyarlandı."),
    ("Ayak Havlusu (Paspas) Yerleşimi", "Banyo Ayak Havlusu Yerleşimi", "MEB havlu standartlarına uyarlandı."),
    ("Saç Kılı ve Su Lekesi Kontrolü", "Banyo Su Lekesi ve Hijyen Kontrolü", "MEB banyo kontrol standartlarına uyarlandı."),
    ("Klozet Hijyen Bandı", "Klozet Hijyen Şeridi Kullanımı", "MEB kitabındaki hijyen şeridi terimine uyarlandı."),
    ("Çöp Kovası ve Havalandırma Kontrolü", "Banyo Çöp Kovası ve Havalandırma Kontrolü", "MEB banyo bitirme kontrolüne uyarlandı."),
    ("Atık ve Çöp Kutusu Kontrolü", "Genel Alan Atık Kutuları Kontrolü", "MEB genel alan temizlik planına uyarlandı."),
    ("Kahvaltı Salonu ve Restoran Temizliği", "Restoran ve Yiyecek İçecek Alanları Temizliği", "MEB yiyecek içecek alanları temizlik başlığına uyarlandı."),
    ("Toplantı ve Kongre Salonu Temizliği", "Toplantı Salonları Temizliği", "MEB genel alanlar temizlik başlığına uyarlandı."),
    ("Mermer Kristalizasyon Cilası", "Mermer Zemin Cila İşlemleri", "MEB zemin bakımı terminolojisine uyarlandı."),
    ("Halı Derin Yıkama ve Vakumlama", "Halı Yıkama ve Vakumlama İşlemleri", "MEB halı bakımı terminolojisine uyarlandı.")
]

with open(desktop_file, 'a', encoding='utf-8') as df:
    df.write(f"\n==================================================\n")
    df.write(f"DERS: 10. Sınıf Kat Hizmetleri Atölyesi\n")
    df.write(f"==================================================\n")

for old_term, new_term, reason in replacements_kat:
    if old_term in kat_text:
        kat_text = kat_text.replace(f'"name": "{old_term}"', f'"name": "{new_term}"')
        with open(desktop_file, 'a', encoding='utf-8') as df:
            df.write(f"  - ÇIKARILAN TERİM: {old_term}\n")
            df.write(f"  + EKLENEN TERİM: {new_term}\n")
            df.write(f"  > GEREKÇE: {reason}\n")
            df.write(f"--------------------------------------------------\n")

with open(kat_file, 'w', encoding='utf-8') as f:
    f.write(kat_text)

print("10th Grade Kat Hizmetleri updates complete!")
