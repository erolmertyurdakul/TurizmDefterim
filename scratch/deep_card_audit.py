import os
import re
import json

courses_dir = r"c:\Erol_Mobil_Gelistirme\TurizmAkademi\lib\core\data\courses"
lecture_notes_path = r"c:\Erol_Mobil_Gelistirme\TurizmAkademi\lib\core\data\lecture_notes.dart"

files = [lecture_notes_path] + [os.path.join(courses_dir, f) for f in os.listdir(courses_dir) if f.endswith(".dart")]

all_notes = []

for filepath in files:
    filename = os.path.basename(filepath)
    with open(filepath, "r", encoding="utf-8") as f:
        content = f.read()
    
    pattern = re.compile(r'\{\s*"name":\s*"([^"]+)",\s*"desc":\s*"([^"]+)",\s*"examples":\s*\[\s*"([^"]+)"\s*\]\s*\}', re.MULTILINE | re.DOTALL)
    
    for m in pattern.finditer(content):
        all_notes.append({
            "file": filename,
            "filepath": filepath,
            "name": m.group(1),
            "desc": m.group(2),
            "example": m.group(3),
            "start": m.start(),
            "end": m.end(),
            "raw": m.group(0)
        })

print(f"Total notes loaded: {len(all_notes)}")

# Let's write a targeted auditor function to check each note for semantic alignment
audited_issues = []

def normalize_tr(s):
    s = s.lower()
    return s.translate(str.maketrans("çğıöşüiİI", "cgiosuiii"))

for idx, note in enumerate(all_notes):
    file = note["file"]
    name = note["name"]
    desc = note["desc"]
    ex = note["example"]
    
    # Extract core subject from name
    # e.g., "Kuru Temizleme (Dry Cleaning)" -> "kuru temizleme"
    name_clean = re.sub(r'\(.*?\)', '', name).strip()
    name_norm = normalize_tr(name_clean)
    ex_norm = normalize_tr(ex)
    desc_norm = normalize_tr(desc)
    
    # Core concepts check
    # Check if the example is generic or talks about another concept
    # Let's check for specific mismatched cases
    
    # 1. Kuru temizleme vs Yıkama vs Ütüleme
    if "kuru temizleme" in name_norm and "kuru temizleme" not in ex_norm and "solvent" not in ex_norm and "susuz" not in ex_norm:
        audited_issues.append((note, "Example for 'Kuru Temizleme' does not mention dry cleaning / solvent / waterless process."))
    
    # 2. Kat Hizmetleri vs Ön Büro vs Resepsiyon
    if "kat hizmetleri" in name_norm and "housekeeping" not in ex_norm and "kat" not in ex_norm and "temizlik" not in ex_norm and "oda" not in ex_norm:
        audited_issues.append((note, "Kat Hizmetleri note example missing HK context."))
        
    # 3. Room types
    if "suit" in name_norm and "suite" not in ex_norm and "suit" not in ex_norm:
        audited_issues.append((note, "Suite room note example does not mention suite room."))
        
    if "kose" in name_norm and "corner" not in ex_norm and "kose" not in ex_norm:
        audited_issues.append((note, "Corner room note example does not mention corner room."))

    if "baglantili" in name_norm and "connecting" not in ex_norm and "baglantili" not in ex_norm and "kapi" not in ex_norm:
        audited_issues.append((note, "Connecting room note example does not mention connecting room or internal door."))

    if "bitisik" in name_norm and "adjoining" not in ex_norm and "bitisik" not in ex_norm and "yan yana" not in ex_norm:
        audited_issues.append((note, "Adjoining room note example does not mention adjoining room."))

    if "engelli" in name_norm and "disabled" not in ex_norm and "engelli" not in ex_norm and "tekerlekli" not in ex_norm:
        audited_issues.append((note, "Disabled room note example does not mention accessibility features."))

    # 4. Board types
    if "sadece oda" in name_norm and "ob" in name_norm:
        if "kahvalti" in ex_norm or "aksham" in ex_norm:
            audited_issues.append((note, "Only Bed (OB) example mentions meal services."))
            
    if "oda kahvalti" in name_norm and "bb" in name_norm:
        if "aksam" in ex_norm or "ogle" in ex_norm:
            audited_issues.append((note, "Bed & Breakfast (BB) example mentions lunch or dinner."))

    if "yarim pansiyon" in name_norm and "hb" in name_norm:
        if "ogle" in ex_norm or "her sey dahil" in ex_norm:
            audited_issues.append((note, "Half Board (HB) example mentions lunch or all-inclusive."))

    # 5. Front Office Check-in / Check-out / Discrepancy / Overbooking / No-Show
    if "no-show" in name_norm and "no-show" not in ex_norm and "gelmey" not in ex_norm:
        audited_issues.append((note, "No-Show note example does not mention no-show or non-arrival."))
        
    if "overbooking" in name_norm and "overbooking" not in ex_norm and "cifte" not in ex_norm and "fazla" not in ex_norm:
        audited_issues.append((note, "Overbooking note example does not mention overbooking or double booking."))

print(f"Deep audit flagged {len(audited_issues)} potential mismatches.")
for note, msg in audited_issues:
    print(f"[{note['file']}] {note['name']} -> {msg}")
