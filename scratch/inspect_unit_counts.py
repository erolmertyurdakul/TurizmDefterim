import os, re, json

# Let's inspect all notes maps in lib/core/data/
notes_dir = r"c:\Erol_Mobil_Gelistirme\TurizmAkademi\lib\core\data\courses"

for filename in os.listdir(notes_dir):
    if filename.endswith(".dart"):
        filepath = os.path.join(notes_dir, filename)
        with open(filepath, 'r', encoding='utf-8') as f:
            content = f.read()
        
        # Find unit titles or maps
        # In dart files, each unit is a Map with "title", "learningUnit", "cards"
        unit_matches = re.findall(r'"learningUnit":\s*"([^"]+)"', content)
        unit_titles = re.findall(r'"title":\s*"([^"]+)"', content)
        card_tags = re.findall(r'"tag":\s*"([^"]+)"', content)
        definitions = re.findall(r'"name":\s*"([^"]+)"', content)
        
        print(f"=== {filename} ===")
        print(f"Units found: {len(unit_matches)} ({unit_matches})")
        print(f"Card tags count: {len(card_tags)}")
        print(f"Definitions/Subcards count: {len(definitions)}")
