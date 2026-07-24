import os
import re
import json

courses_dir = r"c:\Erol_Mobil_Gelistirme\TurizmAkademi\lib\core\data\courses"
lecture_notes_path = r"c:\Erol_Mobil_Gelistirme\TurizmAkademi\lib\core\data\lecture_notes.dart"

files = [lecture_notes_path] + [os.path.join(courses_dir, f) for f in os.listdir(courses_dir) if f.endswith(".dart")]

all_records = []

for filepath in files:
    filename = os.path.basename(filepath)
    with open(filepath, "r", encoding="utf-8") as f:
        content = f.read()
    
    pattern = re.compile(r'\{\s*"name":\s*"([^"]+)",\s*"desc":\s*"([^"]+)",\s*"examples":\s*\[\s*"([^"]+)"\s*\]\s*\}', re.MULTILINE | re.DOTALL)
    
    for m in pattern.finditer(content):
        all_records.append({
            "file": filename,
            "filepath": filepath,
            "name": m.group(1),
            "desc": m.group(2),
            "example": m.group(3),
            "start": m.start(),
            "end": m.end()
        })

print(f"Total notes scanned: {len(all_records)}")

# Let's inspect potential mismatches file by file
mismatches_to_fix = []

for item in all_records:
    name = item["name"]
    desc = item["desc"]
    ex = item["example"]
    file = item["file"]
    
    # Clean name for key terms
    clean_name = re.sub(r'\(.*?\)', '', name).strip()
    
    # Check 1: If name has a specific concept (e.g. "Kral Dairesi", "Süit Oda", "Ön Ödeme", "Voucher", "Reg Card", "Discrepancy", "No-Show", "Walk-In", "Overbooking", "Early Check-Out", "Late Check-Out", "City Ledger", "Folyo", "Night Audit", "Seyir Defteri", "Cash Float", "Kuru Temizleme", "Yıkama", "Ütüleme", "Leke Çıkarma", "Housekeeping", "Tur Operatörü", "Seyahat Acentesi", "Transfer", "Yayla Turizmi", "Ekoturizm", etc.)
    # Does the example contain keywords or scenarios that match?
    
    # Example heuristic: if clean_name has 2+ words, are those key words reflected in example or desc?
    # Let's write out specific checks for each course file!
