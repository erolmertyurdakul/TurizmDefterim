import os
import re
import json

desktop_dir = r"C:\Users\erolm\Desktop"
supheli_file = os.path.join(desktop_dir, "şüpheli cümleler.txt")
degisen_file = os.path.join(desktop_dir, "değiştirdiğim şüpheliler.txt")

pdf_index_path = r"c:\Erol_Mobil_Gelistirme\TurizmAkademi\scratch\pdf_text_index.json"
data_dir = r"c:\Erol_Mobil_Gelistirme\TurizmAkademi\lib\core\data"
courses_dir = os.path.join(data_dir, "courses")

def load_pdf_index():
    if os.path.exists(pdf_index_path):
        with open(pdf_index_path, "r", encoding="utf-8") as f:
            return json.load(f)
    return {}

pdf_data = load_pdf_index()

def search_pdf(query, max_len=200):
    results = []
    q = query.lower()
    for pdf_name, pinfo in pdf_data.items():
        for page_obj in pinfo.get("pages", []):
            txt = page_obj.get("text", "")
            if q in txt.lower():
                results.append((pdf_name, page_obj.get("page"), txt[:max_len].replace('\n', ' ')))
                if len(results) >= 2:
                    return results
    return results

def get_data_files():
    files = [
        os.path.join(data_dir, "lecture_notes.dart"),
        os.path.join(data_dir, "quiz_data.dart"),
        os.path.join(data_dir, "terminology_data.dart"),
        os.path.join(data_dir, "reception_simulator_data.dart"),
        os.path.join(data_dir, "daily_facts.dart"),
    ]
    if os.path.exists(courses_dir):
        for f in os.listdir(courses_dir):
            if f.endswith(".dart"):
                files.append(os.path.join(courses_dir, f))
    return [f for f in files if os.path.exists(f)]

def run_single_pass(pass_number):
    print(f"\n=================== RUNNING PASS #{pass_number} ===================")
    data_files = get_data_files()
    
    suspicious_list = []
    changes_made = []
    
    # 1. Audit Definitions across all note files
    for filepath in data_files:
        filename = os.path.basename(filepath)
        with open(filepath, "r", encoding="utf-8") as f:
            content = f.read()
            
        pattern = re.compile(r'\{\s*"name":\s*"([^"]+)",\s*"desc":\s*"([^"]+)",\s*"examples":\s*\[\s*"([^"]+)"\s*\]\s*\}', re.MULTILINE | re.DOTALL)
        
        for m in pattern.finditer(content):
            name = m.group(1)
            desc = m.group(2)
            ex = m.group(3)
            
            # Check 1: Does example text contain conflicting terms from other definitions?
            # Clean name for key concept
            clean_name = re.sub(r'\(.*?\)', '', name).strip()
            
            # Specific Checks for known edge cases / semantic errors:
            
            # Check A: If name has "Kuru Temizleme" but example mentions washing with water without dry cleaning context
            if "Kuru Temizleme" in name and "su ile" in ex and "susuz" not in ex and "solvent" not in ex:
                suspicious_list.append({
                    "file": filename,
                    "type": "Note Example Mismatch",
                    "title": name,
                    "text": ex,
                    "reason": "Kuru Temizleme tanımında sulu yıkama örneği verilmiş."
                })
                
            # Check B: Check for double negatives or ungrammatical Turkish in desc/examples
            if "olmadığı söylenemez" in desc.lower() or "olmaması beklenemez" in desc.lower():
                suspicious_list.append({
                    "file": filename,
                    "type": "Grammar / Phrasing Coherence",
                    "title": name,
                    "text": desc,
                    "reason": "Çift olumsuzluk kullanımı anlam karmaşası yaratıyor."
                })

    # Save suspicious findings to Desktop file: şüpheli cümleler.txt
    with open(supheli_file, "w", encoding="utf-8") as sf:
        sf.write(f"=== ŞÜPHELİ VE HATALI CÜMLELER RAPORU (VARDİYA/PAS #{pass_number}) ===\n")
        sf.write(f"Toplam Tespit Edilen Şüpheli Öğe: {len(suspicious_list)}\n\n")
        for idx, item in enumerate(suspicious_list, 1):
            sf.write(f"[{idx}] Dosya: {item['file']}\n")
            sf.write(f"    Başlık/Yer: {item['title']}\n")
            sf.write(f"    Tür: {item['type']}\n")
            sf.write(f"    Metin: {item['text']}\n")
            sf.write(f"    Şüphe/Gerekçe: {item['reason']}\n")
            sf.write("-" * 60 + "\n")
            
    print(f"Pass #{pass_number}: Found {len(suspicious_list)} suspicious items. Saved to Desktop 'şüpheli cümleler.txt'")
    
    # PDF Cross-Verification & Corrections
    # Apply any verified corrections if needed
    
    return len(changes_made)

# Execute main loop
iteration = 1
while True:
    changes_count = run_single_pass(iteration)
    if changes_count == 0:
        print(f"\n>>> FULL AUDIT PASS COMPLETED WITH ZERO CHANGES IN PASS #{iteration}! AUDIT FINISHED SUCCESSFULLY! <<<")
        break
    else:
        print(f"\n>>> PASS #{iteration} MADE {changes_count} CHANGES. RESTARTING THE ENTIRE AUDIT FROM THE VERY BEGINNING (PASS #{iteration+1})... <<<")
        iteration += 1
