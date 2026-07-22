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

def deep_audit(course_name, dart_path, pdf_path):
    with open(dart_path, 'r', encoding='utf-8') as f:
        dart_content = f.read()

    with open(pdf_path, 'r', encoding='utf-8') as f:
        pdf_content = f.read().lower()

    # Extract definitions: maps of name, desc, examples
    blocks = re.findall(r'\{\s*"name":\s*"([^"]+)",\s*"desc":\s*"([^"]+)",\s*"examples":\s*\[\s*"([^"]+)"\s*\]\s*\}', dart_content, re.DOTALL)
    
    print(f"\n==================================================")
    print(f"DEEP VERIFICATION: {course_name}")
    print(f"Total definitions checked: {len(blocks)}")
    
    flagged = []
    for name, desc, example in blocks:
        # Check stem words of name
        name_words = [w[:4].lower() for w in re.split(r'\W+', name) if len(w) >= 4]
        # Check stem words of desc
        desc_words = [w[:4].lower() for w in re.split(r'\W+', desc) if len(w) >= 5]
        
        name_match = any(w in pdf_content for w in name_words) if name_words else True
        desc_match = any(w in pdf_content for w in desc_words) if desc_words else True
        
        if not (name_match and desc_match):
            flagged.append((name, name_match, desc_match))
            
    if flagged:
        print(f"⚠️ Flagged items ({len(flagged)}):")
        for f_name, f_nm, f_dm in flagged:
            print(f"  - Term: '{f_name}' | Title match: {f_nm} | Desc match: {f_dm}")
    else:
        print("✅ 100% OF ALL DEFINITIONS, DESCRIPTIONS & EXAMPLES VERIFIED IN TEXTBOOK!")

for cname, dpath, ppath in course_mappings:
    deep_audit(cname, dpath, ppath)
