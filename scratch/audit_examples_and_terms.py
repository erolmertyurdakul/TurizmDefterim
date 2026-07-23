import os, re, json

courses_dir = r"c:\Erol_Mobil_Gelistirme\TurizmAkademi\lib\core\data"
courses_subdir = os.path.join(courses_dir, "courses")
main_notes_file = os.path.join(courses_dir, "lecture_notes.dart")
terminology_file = os.path.join(courses_dir, "terminology_data.dart")

# 1. Audit Terminology Data
total_terms = 0
terms_with_example = 0

if os.path.exists(terminology_file):
    with open(terminology_file, 'r', encoding='utf-8') as f:
        term_content = f.read()
    
    term_blocks = re.findall(r'Term\s*\((.*?)\),', term_content, re.DOTALL)
    total_terms = len(term_blocks)
    for b in term_blocks:
        m = re.search(r"example:\s*['\"]([^'\"]*)['\"]", b)
        if m and m.group(1).strip():
            terms_with_example += 1

# 2. Audit Course Lecture Notes
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
report_lines.append("TURİZM DEFTERİM - TÜM İÇERİK MİMARİSİ VE KAPSAMLI METRİK RAPORU")
report_lines.append("========================================================================")
report_lines.append("TANIMLAR:")
report_lines.append("1. AÇILIR KART SAYISI (KART): Öğrenme birimlerindeki ana tıklanıp açılan kart başlıkları.")
report_lines.append("2. DERS NOTU SAYISI (NOT): Kartların içindeki Mikro Özet + Tanımlar + Vakalar + İpuçları toplamı.")
report_lines.append("3. ÖRNEKLE PEKİŞTİRELİM SAYISI: Ders notları ve terimlerdeki somut vaka/uygulama örnekleri.\n")

total_courses = 0
total_units = 0
total_cards = 0
total_notes = 0
total_note_examples = 0

for course_label, filepath in course_files:
    if not os.path.exists(filepath):
        continue
    
    with open(filepath, 'r', encoding='utf-8') as f:
        content = f.read()

    units_split = re.split(r'("learningUnit":\s*"[^"]+")', content)
    if len(units_split) < 2:
        continue
    
    total_courses += 1
    report_lines.append(f"DERS: {course_label.upper()}")
    report_lines.append("-" * 65)

    unit_idx = 0
    for i in range(1, len(units_split), 2):
        unit_idx += 1
        unit_header = units_split[i]
        unit_body = units_split[i+1] if i+1 < len(units_split) else ""
        
        title_match = re.search(r'"title":\s*"([^"]+)"', unit_body)
        unit_title = title_match.group(1) if title_match else f"{unit_idx}. Öğrenme Birimi"
        
        card_count = len(re.findall(r'\{\s*"id":\s*\d+', unit_body))
        
        micro_count = len(re.findall(r'"microSummary":', unit_body))
        defs_count = len(re.findall(r'"name":', unit_body))
        extra_count = len(re.findall(r'"extraDetails":', unit_body))
        case_count = len(re.findall(r'"caseStudy":', unit_body))
        tip_count = len(re.findall(r'"tip":', unit_body))
        
        total_unit_notes = micro_count + defs_count + extra_count + case_count + tip_count
        example_count = len(re.findall(r'Örnekle Pekiştirelim', unit_body))
        
        total_units += 1
        total_cards += card_count
        total_notes += total_unit_notes
        total_note_examples += example_count
        
        report_lines.append(f"  - {unit_idx}. Öğrenme Birimi ({unit_title})")
        report_lines.append(f"    -> Açılır Kart Sayısı: {card_count} Kart")
        report_lines.append(f"    -> Detaylı Ders Notu Sayısı: {total_unit_notes} Not")
        report_lines.append(f"    -> Örnekle Pekiştirelim Cümlesi Sayısı: {example_count} Adet")

    report_lines.append("")

report_lines.append("========================================================================")
report_lines.append("1. DERS NOTLARI TOPLAM METRİKLERİ:")
report_lines.append("========================================================================")
report_lines.append(f"  - Toplam Ders Sayısı: {total_courses} Ders")
report_lines.append(f"  - Toplam Öğrenme Birimi Sayısı: {total_units} Ünite")
report_lines.append(f"  - Toplam Açılır Kart Sayısı (Ana Başlıklar): {total_cards} Kart")
report_lines.append(f"  - Toplam Detaylı Ders Notu Sayısı (Tüm İçerik Maddeleri): {total_notes} Not")
report_lines.append(f"  - Toplam Örnekle Pekiştirelim Cümlesi Sayısı (Ders Notlarında): {total_note_examples} Adet Örnek")
report_lines.append("========================================================================\n")

report_lines.append("========================================================================")
report_lines.append("2. TERİMLER SÖZLÜĞÜ (TERMINOLOGY DATA) METRİKLERİ:")
report_lines.append("========================================================================")
report_lines.append(f"  - Terimler Sözlüğündeki Toplam Terim Sayısı: {total_terms} Terim")
report_lines.append(f"  - Terimler Sözlüğünde 'Örnekle Pekiştirelim' (Örnek Cümle) İçeren Terim Sayısı: {terms_with_example} Terim")
report_lines.append(f"  - Terimlerde Örnekle Pekiştirelim Oranı: %{round((terms_with_example/total_terms)*100, 1) if total_terms > 0 else 0}")
report_lines.append("========================================================================\n")

report_lines.append("========================================================================")
report_lines.append("3. TÜM UYGULAMA BÜTÜNÜ GENEL METRİK ÖZETİ:")
report_lines.append("========================================================================")
report_lines.append(f"  - Toplam Açılır Kart Sayısı (Derslerdeki Ana Başlıklar): {total_cards} Kart")
report_lines.append(f"  - Toplam Detaylı Ders Notu Sayısı (Tüm Not Maddeleri): {total_notes} Not")
report_lines.append(f"  - Ders Notlarındaki 'Örnekle Pekiştirelim' Sayısı: {total_note_examples} Adet")
report_lines.append(f"  - Terimler Sözlüğündeki 'Örnekle Pekiştirelim' Sayısı: {terms_with_example} Adet")
report_lines.append(f"  - UYGULAMA GENELİNDE TOPLAM 'ÖRNEKLE PEKİŞTİRELİM' CÜMLE SAYISI: {total_note_examples + terms_with_example} ADET")
report_lines.append("========================================================================")

report_text = "\n".join(report_lines)

# Save to Desktop
desktop_path = r"C:\Users\erolm\Desktop\Kartlar_ve_Ders_Notlari_Sayilari.txt"
with open(desktop_path, 'w', encoding='utf-8') as f:
    f.write(report_text)

print("AUDIT SCRIPT COMPLETED & DESKTOP FILE UPDATED WITH CLEAR SEPARATION!")
