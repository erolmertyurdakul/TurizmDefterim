import json
import re

with open(r"c:\Erol_Mobil_Gelistirme\TurizmAkademi\scratch\all_definitions_dump.json", "r", encoding="utf-8") as f:
    definitions = json.load(f)

print(f"Loaded {len(definitions)} definitions.")

suspects = []

# 1. Duplicate example check
example_map = {}
for i, item in enumerate(definitions):
    ex = item["example"].strip()
    if ex in example_map:
        example_map[ex].append(i)
    else:
        example_map[ex] = [i]

duplicates = {k: v for k, v in example_map.items() if len(v) > 1}

print(f"Found {len(duplicates)} duplicated examples.")
for ex, indices in duplicates.items():
    print(f"\n--- DUPLICATE EXAMPLE ({len(indices)} times) ---")
    print(f"Text: {ex[:100]}...")
    for idx in indices:
        item = definitions[idx]
        print(f"  -> File: {item['file']} | Name: {item['name']}")

# 2. Semantic Mismatch Check
# Extract core concept keywords from Name and Desc, check if Example contains unrelated concept keywords from OTHER definitions
for i, item in enumerate(definitions):
    name = item["name"]
    desc = item["desc"]
    ex = item["example"]
    
    # Check key term presence or contradictions
    # Check parenthetical terms like (OB), (BB), (HB), (FB), (AI), (UAI), (Walk-in), (No-Show), (Discrepancy), (Late Check-Out), (Early Check-Out), etc.
    name_parens = re.findall(r'\(([^\)]+)\)', name)
    ex_parens = re.findall(r'\(([^\)]+)\)', ex)
    
    # Also check if name has a specific concept (e.g., "Kuru Temizleme") but example uses a completely different concept (e.g., "Yıkama" or "Ütüleme")
