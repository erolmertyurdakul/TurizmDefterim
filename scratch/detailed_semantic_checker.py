import os
import re
import json

courses_dir = r"c:\Erol_Mobil_Gelistirme\TurizmAkademi\lib\core\data\courses"
lecture_notes_path = r"c:\Erol_Mobil_Gelistirme\TurizmAkademi\lib\core\data\lecture_notes.dart"

files = [lecture_notes_path] + [os.path.join(courses_dir, f) for f in os.listdir(courses_dir) if f.endswith(".dart")]

all_items = []

for filepath in files:
    filename = os.path.basename(filepath)
    with open(filepath, "r", encoding="utf-8") as f:
        content = f.read()
    
    pattern = re.compile(r'\{\s*"name":\s*"([^"]+)",\s*"desc":\s*"([^"]+)",\s*"examples":\s*\[\s*"([^"]+)"\s*\]\s*\}', re.MULTILINE | re.DOTALL)
    for m in pattern.finditer(content):
        all_items.append({
            "file": filename,
            "filepath": filepath,
            "name": m.group(1),
            "desc": m.group(2),
            "example": m.group(3),
            "start": m.start(),
            "end": m.end()
        })

print(f"Total notes to audit: {len(all_items)}")

# We will write a python function to flag potential mismatches
issues = []

for item in all_items:
    file = item["file"]
    name = item["name"]
    desc = item["desc"]
    ex = item["example"]
    
    # 1. Check parenthetical terms
    # Example: Name is "Sadece Oda (Only Bed - OB)", but example says "Bed & Breakfast" or "BB"
    parens = re.findall(r'\(([^\)]+)\)', name)
    for p in parens:
        # Check specific acronym mismatches
        if p.upper() in ["OB", "BB", "HB", "FB", "AI", "UAI"]:
            # Check if example uses a conflicting board type
            if p.upper() == "OB" and ("kahvalti" in ex.lower() or "bb" in ex.lower()):
                issues.append((item, f"Board type mismatch: Name is {p} but example mentions breakfast/BB"))
            elif p.upper() == "BB" and ("aksam yemegi" in ex.lower() or "ogle yemegi" in ex.lower()):
                issues.append((item, f"Board type mismatch: Name is {p} but example mentions dinner/lunch"))
            elif p.upper() == "HB" and ("ogle yemegi" in ex.lower() or "her sey dahil" in ex.lower()):
                issues.append((item, f"Board type mismatch: Name is {p} but example mentions lunch/all-inclusive"))

    # 2. Check room types mismatches
    if "Süit" in name and "Kral Dairesi" in ex and "Süit" not in ex:
        issues.append((item, "Room type mismatch: Name is Suite but example only talks about King Suite/Presidential Suite without specifying Suite"))
    if "Köşe Oda" in name and "corner" not in ex.lower() and "kose" not in ex.lower():
        issues.append((item, "Room type: Name is Corner Room but example does not mention corner room characteristics"))

    # 3. Check reservation status mismatches
    if "Kesin Rezervasyon" in name and ("opsiyon" in ex.lower() or "iptal" in ex.lower()):
        issues.append((item, "Reservation type mismatch: Name is Guaranteed/Confirmed but example talks about optional/cancellation"))

    # 4. Check housekeeping/front office terms
    if "Discrepancy" in name and "uyusmazlik" not in ex.lower() and "discrepancy" not in ex.lower():
        issues.append((item, "Term mismatch: Name is Discrepancy but example doesn't mention discrepancy"))

print(f"Detected {len(issues)} specific term/concept issues.")
for item, reason in issues:
    print(f"\n[{item['file']}] Name: {item['name']}")
    print(f"  Reason: {reason}")
    print(f"  Desc: {item['desc']}")
    print(f"  Ex:   {item['example']}")
