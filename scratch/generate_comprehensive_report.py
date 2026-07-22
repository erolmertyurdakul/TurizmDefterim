import os, re, json

courses_dir = r"c:\Erol_Mobil_Gelistirme\TurizmAkademi\lib\core\data"
courses_subdir = os.path.join(courses_dir, "courses")
main_notes_file = os.path.join(courses_dir, "lecture_notes.dart")

course_files = [
    ("9-Mesleki Gelişim Atölyesi", os.path.join(courses_subdir, "9_mesleki_gelisim_notes.dart")),
    ("10-Kat Hizmetleri Atölyesi", os.path.join(courses_subdir, "10_kat_hizmetleri_notes.dart")),
    ("10-Konuk Giriş Çıkış İşlemleri", os.path.join(courses_subdir, "10_konuk_giris_cikis_notes.dart")),
    ("10-Ön Büroda Rezervasyon", main_notes_file),
    ("11-Konaklama İşletmeciliği", os.path.join(courses_subdir, "11_konaklama_isletmeciligi_notes.dart")),
    ("11-Sürdürülebilir Turizm", os.path.join(courses_subdir, "11_surdurulebilir_turizm_notes.dart")),
    ("11-Kat Hizmetleri Atölyesi", os.path.join(courses_subdir, "11_kat_hizmetleri_notes.dart")),
    ("12-Alternatif Turizm", os.path.join(courses_subdir, "12_alternatif_turizm_notes.dart")),
    ("12-Kuru Temizleme İşlemleri", os.path.join(courses_subdir, "12_kuru_temizleme_notes.dart")),
    ("12-Çamaşırhane İşlemleri", os.path.join(courses_subdir, "12_camasirhane_notes.dart")),
    ("12-Dünya Seyahat ve Turizm Coğrafyası", os.path.join(courses_subdir, "12_dunya_cografyasi_notes.dart")),
    ("12-Dünya Kültürleri", os.path.join(courses_subdir, "12_dunya_kulturleri_notes.dart")),
    ("12-Kongre ve Etkinlik Turizmi", os.path.join(courses_subdir, "12_kongre_etkinlik_notes.dart")),
    ("12-Gastronomi Turizmi", os.path.join(courses_subdir, "12_gastronomi_turizmi_notes.dart")),
    ("12-Tur Operasyonu", os.path.join(courses_subdir, "12_tur_operasyonu_notes.dart")),
    ("12-Transfer Operasyonu", os.path.join(courses_subdir, "12_transfer_operasyonu_notes.dart")),
    ("12-Sosyal Medya", os.path.join(courses_subdir, "12_sosyal_medya_notes.dart")),
]

report_lines = []
report_lines.append("========================================================================")
report_lines.append("TURİZM DEFTERİM - TÜM ÖĞRENME BİRİMLERİ KART VE DERS NOTU SAYILARI")
report_lines.append("========================================================================")
report_lines.append("Kriterler:")
report_lines.append("- KART SAYISI: Öğrenme birimindeki ana açılır kart başlığı sayısı.")
report_lines.append("- DERS NOTU SAYISI: Her kartın içindeki Mikro Özet + Tanım/Terim Notları + ")
report_lines.append("  Özel Ek Detay Notları + Sektörden Vaka Notu + Bilgi Köşesi/İpucu Notu toplamı.\n")

total_courses = 0
total_units = 0
total_cards = 0
total_notes = 0

for course_label, filepath in course_files:
    if not os.path.exists(filepath):
        continue
    
    with open(filepath, 'r', encoding='utf-8') as f:
        content = f.read()

    # Split content by learningUnit blocks
    units_split = re.split(r'("learningUnit":\s*"[^"]+")', content)
    if len(units_split) < 2:
        continue
    
    total_courses += 1
    report_lines.append(f"📚 {course_label.upper()}")
    report_lines.append("-" * 65)

    unit_idx = 0
    for i in range(1, len(units_split), 2):
        unit_idx += 1
        unit_header = units_split[i]
        unit_body = units_split[i+1] if i+1 < len(units_split) else ""
        
        # Get Unit Title
        title_match = re.search(r'"title":\s*"([^"]+)"', unit_body)
        unit_title = title_match.group(1) if title_match else f"{unit_idx}. Öğrenme Birimi"
        
        # Count cards
        cards_matches = re.findall(r'\{\s*"id":\s*\d+', unit_body)
        card_count = len(cards_matches)
        
        # Count notes comprehensively:
        # 1. microSummary count
        micro_count = len(re.findall(r'"microSummary":', unit_body))
        # 2. definitions count (each "name": in definitions)
        defs_count = len(re.findall(r'"name":', unit_body))
        # 3. extraDetails count (each "title": inside extraDetails)
        extra_count = len(re.findall(r'"extraDetails":', unit_body))
        # 4. caseStudy count
        case_count = len(re.findall(r'"caseStudy":', unit_body))
        # 5. tip / info count
        tip_count = len(re.findall(r'"tip":', unit_body))
        
        total_unit_notes = micro_count + defs_count + extra_count + case_count + tip_count
        
        total_units += 1
        total_cards += card_count
        total_notes += total_unit_notes
        
        report_lines.append(f"  • {unit_idx}. Öğrenme Birimi ({unit_title})")
        report_lines.append(f"    -> Kart Sayısı: {card_count} Kart | Ders Notu Sayısı: {total_unit_notes} Not")
        report_lines.append(f"       [Detay: {defs_count} Tanım + {micro_count} Mikro Özet + {case_count} Vaka + {tip_count} Bilgi/İpucu + {extra_count} Ek Detay]")

    report_lines.append("")

report_lines.append("GENEL TOPLAM SEMA:")
report_lines.append(f"  - Toplam Ders Sayısı: {total_courses}")
report_lines.append(f"  - Toplam Öğrenme Birimi Sayısı: {total_units}")
report_lines.append(f"  - Toplam Kart Sayısı (Ana Başlıklar): {total_cards} Kart")
report_lines.append(f"  - Toplam Ders Notu Sayısı (Tüm İçerik Maddeleri): {total_notes} Not")
report_lines.append("========================================================================")

report_text = "\n".join(report_lines)

# Save to Desktop
desktop_path = r"C:\Users\erolm\Desktop\Kartlar_ve_Ders_Notlari_Sayilari.txt"
with open(desktop_path, 'w', encoding='utf-8') as f:
    f.write(report_text)

print(f"Report successfully saved to Desktop: {desktop_path}")
