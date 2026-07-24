import os
import re
import json

courses_dir = r"c:\Erol_Mobil_Gelistirme\TurizmAkademi\lib\core\data\courses"
lecture_notes_path = r"c:\Erol_Mobil_Gelistirme\TurizmAkademi\lib\core\data\lecture_notes.dart"

files = [lecture_notes_path] + [os.path.join(courses_dir, f) for f in os.listdir(courses_dir) if f.endswith(".dart")]

results = []

def clean_text(text):
    return text.replace('\\"', '"').replace('\\n', '\n')

for filepath in files:
    filename = os.path.basename(filepath)
    with open(filepath, "r", encoding="utf-8") as f:
        content = f.read()
    
    # Split content by definitions
    # Match: "name": "...", "desc": "...", "examples": [ "..." ]
    pattern = re.compile(r'"name":\s*"([^"]+)",\s*"desc":\s*"([^"]+)",\s*"examples":\s*\[\s*"([^"]+)"\s*\]', re.MULTILINE | re.DOTALL)
    matches = pattern.finditer(content)
    
    for m in matches:
        def_name = m.group(1)
        def_desc = m.group(2)
        def_example = m.group(3)
        start_pos = m.start()
        end_pos = m.end()
        
        results.append({
            "file": filename,
            "filepath": filepath,
            "name": def_name,
            "desc": def_desc,
            "example": def_example,
            "start": start_pos,
            "end": end_pos
        })

print(f"Parsed {len(results)} total note definitions.")

# Now let's print all 854 pairs to a file in a clean markdown format so we can inspect them by file or run automated consistency checks.
with open(r"c:\Erol_Mobil_Gelistirme\TurizmAkademi\scratch\full_audit_report.txt", "w", encoding="utf-8") as out:
    for i, r in enumerate(results):
        out.write(f"--- [{i+1}] {r['file']} ---\n")
        out.write(f"NAME: {r['name']}\n")
        out.write(f"DESC: {r['desc']}\n")
        out.write(f"EXAMPLE: {r['example']}\n\n")

print("Full audit report written to scratch/full_audit_report.txt")
