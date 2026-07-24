import json

with open(r"c:\Erol_Mobil_Gelistirme\TurizmAkademi\scratch\mismatches_report.json", "r", encoding="utf-8") as f:
    data = json.load(f)

print(f"Total suspects: {len(data)}\n")

for idx, item in enumerate(data):
    print(f"[{idx+1}] File: {item['file']}")
    print(f"    Name:  {item['name']}")
    print(f"    Desc:  {item['desc']}")
    print(f"    Ex:    {item['example']}")
    print(f"    Other: {item['mismatched_with']}")
    print("-" * 60)
