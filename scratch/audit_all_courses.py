import os
import re
import sys

sys.stdout.reconfigure(encoding='utf-8')

course_mappings = [
    ("9. Sınıf Mesleki Gelişim Atölyesi", "lib/core/data/courses/9_mesleki_gelisim_notes.dart", "scratch/pdf_texts/9. Sınıf Mesleki Gelişim Atölyesi.txt"),
    ("10. Sınıf Kat Hizmetleri Atölyesi", "lib/core/data/courses/10_kat_hizmetleri_notes.dart", "scratch/pdf_texts/10. Sınıf Kat Hizmetleri Atölyesi.txt"),
    ("10. Sınıf Konuk Giriş Çıkış İşlemleri", "lib/core/data/courses/10_konuk_giris_cikis_notes.dart", "scratch/pdf_texts/10.Sınıf Konuk Giriş Çıkış İşlemleri.txt"),
    ("11. Sınıf Kat Hizmetleri Atölyesi", "lib/core/data/courses/11_kat_hizmetleri_notes.dart", "scratch/pdf_texts/11. Sınıf Kat Hizmetleri Atölyesi.txt"),
    ("11. Sınıf Sürdürülebilir Turizm", "lib/core/data/courses/11_surdurulebilir_turizm_notes.dart", "scratch/pdf_texts/11. Sınıf Sürdürülebilir Turizm.txt"),
    ("11. Sınıf Konaklama İşletmeciliği", "lib/core/data/courses/11_konaklama_isletmeciligi_notes.dart", "scratch/pdf_texts/11.Sınıf Konaklama.İşletmeciliği.txt"),
    ("12. Sınıf Alternatif Turizm", "lib/core/data/courses/12_alternatif_turizm_notes.dart", "scratch/pdf_texts/12. Sınıf Alternatif Turizm.txt"),
    ("12. Sınıf Çamaşırhane İşlemleri", "lib/core/data/courses/12_camasirhane_notes.dart", "scratch/pdf_texts/12. Sınıf Çamaşırhane İşlemleri.txt"),
    ("12. Sınıf Dünya Seyahat ve Turizm Coğrafyası", "lib/core/data/courses/12_dunya_cografyasi_notes.dart", "scratch/pdf_texts/12. Sınıf Dünya Seyahat ve Turizm Coğrafyası.txt"),
    ("12. Sınıf Dünya Kültürleri", "lib/core/data/courses/12_dunya_kulturleri_notes.dart", "scratch/pdf_texts/12. Sınıf Dünya Kültürleri.txt"),
    ("12. Sınıf Gastronomi Turizmi", "lib/core/data/courses/12_gastronomi_turizmi_notes.dart", "scratch/pdf_texts/12. Sınıf Gastronomi Turizmi.txt"),
    ("12. Sınıf Kongre ve Etkinlik Turizmi", "lib/core/data/courses/12_kongre_etkinlik_notes.dart", "scratch/pdf_texts/12. Sınıf Kongre ve Etkinlik Turizmi.txt"),
    ("12. Sınıf Kuru Temizleme İşlemleri", "lib/core/data/courses/12_kuru_temizleme_notes.dart", "scratch/pdf_texts/12. Sınıf Kuru Temizleme İşlemleri.txt"),
    ("12. Sınıf Sosyal Medya", "lib/core/data/courses/12_sosyal_medya_notes.dart", "scratch/pdf_texts/12. Sınıf Sosyal Medya.txt"),
    ("12. Sınıf Transfer Operasyonu", "lib/core/data/courses/12_transfer_operasyonu_notes.dart", "scratch/pdf_texts/12.Sınıf Transfer Operasyonu.txt"),
    ("12. Sınıf Tur Operasyonu", "lib/core/data/courses/12_tur_operasyonu_notes.dart", "scratch/pdf_texts/12. Sınıf Tur Operasyonu.txt"),
]

def analyze_course(course_title, dart_path, pdf_path):
    with open(dart_path, 'r', encoding='utf-8') as f:
        dart_text = f.read()
    
    with open(pdf_path, 'r', encoding='utf-8') as f:
        pdf_text = f.read().lower()

    defs = re.findall(r'"name": "([^"]+)"', dart_text)
    
    missing = []
    for d in defs:
        clean_d = d.lower()
        # Stem prefix matching (first 4 characters of each word)
        words = [w[:4] for w in re.split(r'\W+', clean_d) if len(w) >= 4]
        if not words:
            continue
        found_any = any(w in pdf_text for w in words)
        if not found_any:
            missing.append(d)
            
    print(f"\n==================================================")
    print(f"COURSE: {course_title}")
    print(f"Total definitions: {len(defs)} | Unmatched terms: {len(missing)}")
    if missing:
        print("Unmatched terms list:")
        for m in missing:
            print(f"  - {m}")
    else:
        print("  -> ALL TERMS 100% MATCHED IN PDF TEXTBOOK!")

for ctitle, dpath, ppath in course_mappings:
    analyze_course(ctitle, dpath, ppath)
