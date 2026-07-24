import os
import re
import json

courses_dir = r"c:\Erol_Mobil_Gelistirme\TurizmAkademi\lib\core\data\courses"
lecture_notes_path = r"c:\Erol_Mobil_Gelistirme\TurizmAkademi\lib\core\data\lecture_notes.dart"

files = [lecture_notes_path] + [os.path.join(courses_dir, f) for f in os.listdir(courses_dir) if f.endswith(".dart")]

all_mismatches = []

def normalize_str(s):
    s = s.lower()
    return s.translate(str.maketrans("çğıöşüiİI", "cgiosuiii"))

for filepath in files:
    filename = os.path.basename(filepath)
    with open(filepath, "r", encoding="utf-8") as f:
        content = f.read()
    
    pattern = re.compile(r'\{\s*"name":\s*"([^"]+)",\s*"desc":\s*"([^"]+)",\s*"examples":\s*\[\s*"([^"]+)"\s*\]\s*\}', re.MULTILINE | re.DOTALL)
    
    matches = list(pattern.finditer(content))
    
    for i, m in enumerate(matches):
        name = m.group(1)
        desc = m.group(2)
        ex = m.group(3)
        
        # Check if example belongs to another definition in the same file
        # Compare example content against all other definition names in the same file
        for j, m_other in enumerate(matches):
            if i == j:
                continue
            other_name = m_other.group(1)
            other_desc = m_other.group(2)
            other_ex = m_other.group(3)
            
            # Clean names
            other_clean = re.sub(r'\(.*?\)', '', other_name).strip()
            self_clean = re.sub(r'\(.*?\)', '', name).strip()
            
            # If the example explicitly contains the exact title of OTHER definition (and NOT self title)
            if len(other_clean) > 5 and normalize_str(other_clean) in normalize_str(ex) and normalize_str(self_clean) not in normalize_str(ex):
                # Exclude false positives like "Resepsiyon" or generic words
                if other_clean.lower() not in ['resepsiyon', 'kat hizmetleri', 'otel', 'misafir', 'konuk', 'oda']:
                    all_mismatches.append({
                        "file": filename,
                        "filepath": filepath,
                        "note_name": name,
                        "note_desc": desc,
                        "current_example": ex,
                        "conflicting_other_note": other_name,
                        "start": m.start(),
                        "end": m.end()
                    })

print(f"Total specific mismatches found: {len(all_mismatches)}")

with open(r"c:\Erol_Mobil_Gelistirme\TurizmAkademi\scratch\deep_mismatches.json", "w", encoding="utf-8") as f:
    json.dump(all_mismatches, f, ensure_ascii=False, indent=2)
