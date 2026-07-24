import os
import re
import json

courses_dir = r"c:\Erol_Mobil_Gelistirme\TurizmAkademi\lib\core\data\courses"
lecture_notes_path = r"c:\Erol_Mobil_Gelistirme\TurizmAkademi\lib\core\data\lecture_notes.dart"

files = [lecture_notes_path] + [os.path.join(courses_dir, f) for f in os.listdir(courses_dir) if f.endswith(".dart")]

report_list = []

for filepath in files:
    filename = os.path.basename(filepath)
    with open(filepath, "r", encoding="utf-8") as f:
        content = f.read()
    
    # Extract definitions
    pattern = re.compile(r'\{\s*"name":\s*"([^"]+)",\s*"desc":\s*"([^"]+)",\s*"examples":\s*\[\s*"([^"]+)"\s*\]\s*\}', re.MULTILINE | re.DOTALL)
    
    defs_in_file = []
    for m in pattern.finditer(content):
        defs_in_file.append({
            "name": m.group(1),
            "desc": m.group(2),
            "example": m.group(3),
            "full_match": m.group(0)
        })
    
    # Check consistency in this file
    for i, d in enumerate(defs_in_file):
        name = d["name"]
        desc = d["desc"]
        ex = d["example"]
        
        # Look for potential mismatch indicators:
        # Check if the title of ANY other definition in the file is mentioned in THIS example, while THIS definition's main title is NOT mentioned.
        for j, other_d in enumerate(defs_in_file):
            if i == j:
                continue
            
            other_name = other_d["name"]
            # Extract main title of other_name
            other_clean = re.sub(r'\(.*?\)', '', other_name).strip()
            self_clean = re.sub(r'\(.*?\)', '', name).strip()
            
            if len(other_clean) > 5 and other_clean.lower() in ex.lower() and self_clean.lower() not in ex.lower():
                report_list.append({
                    "file": filename,
                    "def_index": i,
                    "name": name,
                    "desc": desc,
                    "example": ex,
                    "mismatched_with": other_name,
                    "other_example": other_d["example"]
                })

print(f"Total potential mismatches identified across all files: {len(report_list)}")

with open(r"c:\Erol_Mobil_Gelistirme\TurizmAkademi\scratch\mismatches_report.json", "w", encoding="utf-8") as out_f:
    json.dump(report_list, out_f, ensure_ascii=False, indent=2)
