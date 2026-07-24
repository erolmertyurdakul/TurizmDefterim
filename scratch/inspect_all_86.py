import json

with open(r"c:\Erol_Mobil_Gelistirme\TurizmAkademi\scratch\mismatches_found.json", "r", encoding="utf-8") as f:
    items = json.load(f)

print(f"Total suspects to inspect: {len(items)}\n")

for idx, item in enumerate(items):
    print(f"=== SUSPECT #{idx+1} ===")
    print(f"File: {item['file']}")
    print(f"Name: {item['name']}")
    print(f"Desc: {item['desc']}")
    print(f"Example: {item['example']}")
    print(f"Reason: {item['reason']}")
    print("-" * 60)
