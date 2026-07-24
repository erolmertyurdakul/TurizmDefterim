import os
import re
import json

courses_dir = r"c:\Erol_Mobil_Gelistirme\TurizmAkademi\lib\core\data\courses"
lecture_notes_path = r"c:\Erol_Mobil_Gelistirme\TurizmAkademi\lib\core\data\lecture_notes.dart"

files = [lecture_notes_path] + [os.path.join(courses_dir, f) for f in os.listdir(courses_dir) if f.endswith(".dart")]

audited_data = []

for filepath in files:
    filename = os.path.basename(filepath)
    with open(filepath, "r", encoding="utf-8") as f:
        content = f.read()
    
    # We want to extract cards and their definitions
    # Match card block or definitions
    pattern = re.compile(r'\{\s*"name":\s*"([^"]+)",\s*"desc":\s*"([^"]+)",\s*"examples":\s*\[\s*"([^"]+)"\s*\]\s*\}', re.MULTILINE | re.DOTALL)
    
    matches = list(pattern.finditer(content))
    for i, m in enumerate(matches):
        name = m.group(1)
        desc = m.group(2)
        ex = m.group(3)
        
        audited_data.append({
            "index": len(audited_data),
            "file": filename,
            "filepath": filepath,
            "name": name,
            "desc": desc,
            "example": ex,
            "start": m.start(),
            "end": m.end()
        })

print(f"Total notes loaded for exhaustive audit: {len(audited_data)}")

# Let's perform programmatic checks for swap detection:
# If Definition A has Example B and Definition B has Example A
swaps_found = []
for i in range(len(audited_data) - 1):
    a = audited_data[i]
    b = audited_data[i+1]
    if a["file"] == b["file"]:
        # Check if a's name appears in b's example AND b's name appears in a's example
        a_name_clean = re.sub(r'\(.*?\)', '', a["name"]).strip().lower()
        b_name_clean = re.sub(r'\(.*?\)', '', b["name"]).strip().lower()
        
        if len(a_name_clean) > 4 and len(b_name_clean) > 4:
            if a_name_clean in b["example"].lower() and b_name_clean in a["example"].lower():
                swaps_found.append((a, b))

print(f"SWAPS DETECTED: {len(swaps_found)}")
for a, b in swaps_found:
    print(f"\n[SWAP DETECTED in {a['file']}]")
    print(f"  Note A: {a['name']}")
    print(f"  Ex A:   {a['example']}")
    print(f"  Note B: {b['name']}")
    print(f"  Ex B:   {b['example']}")
