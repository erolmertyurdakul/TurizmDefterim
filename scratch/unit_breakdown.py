import re, os, json

# Path to lecture_notes.dart and courses
courses_dir = r"c:\Erol_Mobil_Gelistirme\TurizmAkademi\lib\core\data\courses"

# Let's inspect each notes file and count cards (Ders Notu) and definitions (Kart) per unit
for fname in sorted(os.listdir(courses_dir)):
    if not fname.endswith(".dart"): continue
    fpath = os.path.join(courses_dir, fname)
    with open(fpath, 'r', encoding='utf-8') as f:
        content = f.read()
    
    # Split content by unit1Notes, unit2Notes etc. or "learningUnit":
    units_raw = re.split(r'const\s+Map<String,\s*dynamic>\s+unit\d+Notes\s*=\s*\{', content)
    if len(units_raw) <= 1:
        units_raw = re.split(r'const\s+Map<String,\s*dynamic>\s+\w+Notes\s*=\s*\{', content)

    print(f"\n================ FILE: {fname} ================")
    # Let's find all unit maps
    # Match each "title": "..." block
    units = re.findall(r'"learningUnit":\s*"([^"]+)"', content)
    
    # Count tags and definitions per unit block
    blocks = re.split(r'"learningUnit":', content)[1:]
    for idx, b in enumerate(blocks):
        unit_title_m = re.search(r'"title":\s*"([^"]+)"', content[:content.find(b)])
        # Ders Notu count = number of "tag": in block
        note_count = len(re.findall(r'"tag":', b))
        # Kart count = number of "name": or "desc": in definitions inside block
        card_count = len(re.findall(r'"name":', b))
        print(f"  Unit {idx+1}: {note_count} Ders Notu | {card_count} Kart")

