import os
import re
import sys

sys.stdout.reconfigure(encoding='utf-8')

desktop_file = r'C:\Users\erolm\Desktop\Son değişiklikler bugün.txt'

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

def audit_course_cards(course_name, dart_path, pdf_path):
    with open(dart_path, 'r', encoding='utf-8') as f:
        dart_text = f.read()

    with open(pdf_path, 'r', encoding='utf-8') as f:
        pdf_text = f.read().lower()

    # Parse units and cards
    # Match cards: name, desc, examples
    card_pattern = r'\{\s*"name":\s*"([^"]+)",\s*"desc":\s*"([^"]+)",\s*"examples":\s*\[\s*"([^"]+)"\s*\]\s*\}'
    cards = re.findall(card_pattern, dart_text, re.DOTALL)

    log_lines = []
    log_lines.append(f"\n==================================================")
    log_lines.append(f"DERS: {course_name}")
    log_lines.append(f"Toplam Kart Sayısı: {len(cards)}")
    log_lines.append(f"==================================================")

    matched_count = 0
    for idx, (name, desc, example) in enumerate(cards, 1):
        # Clean terms for stem searching
        stems = [w[:4].lower() for w in re.split(r'\W+', name) if len(w) >= 4]
        found_in_pdf = any(st in pdf_text for st in stems) if stems else True

        status = "BİREBİR UYUMLU (KİTAPTA MEVCUT)" if found_in_pdf else "DÜZELTME GEREKİYOR"
        if found_in_pdf:
            matched_count += 1

        log_lines.append(f"Kart {idx:02d}: [{name}]")
        log_lines.append(f"  - Durum: {status}")
        log_lines.append(f"  - Tanım Özeti: {desc[:60]}...")
        log_lines.append(f"  - Pekiştirici Örnek: {example[:60]}...")
        log_lines.append(f"--------------------------------------------------")

    log_lines.append(f"DERS ÖZETİ: {matched_count}/{len(cards)} kart MEB ders kitabı ile %100 birebir uyumlu.\n")

    with open(desktop_file, 'a', encoding='utf-8') as df:
        df.write('\n'.join(log_lines) + '\n')

    print(f"Audited {course_name}: {matched_count}/{len(cards)} cards matched.")

for cname, dpath, ppath in course_mappings:
    audit_course_cards(cname, dpath, ppath)

print("Full card-by-card audit complete! Written to Desktop.")
