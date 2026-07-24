import os
import re
import json

courses_dir = r"c:\Erol_Mobil_Gelistirme\TurizmAkademi\lib\core\data\courses"
lecture_notes_path = r"c:\Erol_Mobil_Gelistirme\TurizmAkademi\lib\core\data\lecture_notes.dart"

files = [lecture_notes_path] + [os.path.join(courses_dir, f) for f in os.listdir(courses_dir) if f.endswith(".dart")]

all_definitions_by_file = {}

for filepath in files:
    filename = os.path.basename(filepath)
    with open(filepath, "r", encoding="utf-8") as f:
        content = f.read()
    
    pattern = re.compile(r'\{\s*"name":\s*"([^"]+)",\s*"desc":\s*"([^"]+)",\s*"examples":\s*\[\s*"([^"]+)"\s*\]\s*\}', re.MULTILINE | re.DOTALL)
    
    file_notes = []
    for m in pattern.finditer(content):
        file_notes.append({
            "name": m.group(1),
            "desc": m.group(2),
            "example": m.group(3),
            "raw": m.group(0),
            "start": m.start(),
            "end": m.end()
        })
    all_definitions_by_file[filename] = file_notes

print("Definitions count by file:")
for fname, notes in all_definitions_by_file.items():
    print(f"  - {fname}: {len(notes)} notes")
