import os
import re
import json

courses_dir = r"c:\Erol_Mobil_Gelistirme\TurizmAkademi\lib\core\data\courses"
lecture_notes_path = r"c:\Erol_Mobil_Gelistirme\TurizmAkademi\lib\core\data\lecture_notes.dart"

files_to_check = [
    lecture_notes_path,
] + [os.path.join(courses_dir, f) for f in os.listdir(courses_dir) if f.endswith(".dart")]

all_definitions = []

for filepath in files_to_check:
    filename = os.path.basename(filepath)
    with open(filepath, "r", encoding="utf-8") as f:
        content = f.read()
    
    # We can search for definitions blocks: "name": "...", "desc": "...", "examples": [...]
    # Let's extract using regex patterns
    pattern = re.compile(r'\{\s*"name":\s*"([^"]+)",\s*"desc":\s*"([^"]+)",\s*"examples":\s*\[\s*"([^"]+)"\s*\]\s*\}', re.MULTILINE | re.DOTALL)
    
    matches = pattern.findall(content)
    for m in matches:
        def_name = m[0]
        def_desc = m[1]
        def_example = m[2]
        all_definitions.append({
            "file": filename,
            "filepath": filepath,
            "name": def_name,
            "desc": def_desc,
            "example": def_example
        })

print(f"Total definitions found across all files: {len(all_definitions)}")

# Output summary to a text file for inspection
with open(r"c:\Erol_Mobil_Gelistirme\TurizmAkademi\scratch\all_definitions_dump.json", "w", encoding="utf-8") as f:
    json.dump(all_definitions, f, ensure_ascii=False, indent=2)
