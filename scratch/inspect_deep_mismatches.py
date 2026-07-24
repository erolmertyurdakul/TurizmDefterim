import json

with open(r"c:\Erol_Mobil_Gelistirme\TurizmAkademi\scratch\deep_mismatches.json", "r", encoding="utf-8") as f:
    items = json.load(f)

print(f"Total deep mismatches: {len(items)}\n")

for i, item in enumerate(items):
    print(f"[{i+1}] FILE: {item['file']}")
    print(f"    NAME:  {item['note_name']}")
    print(f"    DESC:  {item['note_desc']}")
    print(f"    EX:    {item['current_example']}")
    print(f"    CONFLICT WITH: {item['conflicting_other_note']}")
    print("-" * 60)
