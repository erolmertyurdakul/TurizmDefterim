import json
import re

with open(r"c:\Erol_Mobil_Gelistirme\TurizmAkademi\scratch\all_definitions_dump.json", "r", encoding="utf-8") as f:
    definitions = json.load(f)

# Group definitions by file
by_file = {}
for item in definitions:
    fname = item["file"]
    if fname not in by_file:
        by_file[fname] = []
    by_file[fname].append(item)

mismatches = []

def normalize_tr(text):
    text = text.lower()
    mapping = str.maketrans("çğıöşüiİI", "cgiosuiii")
    return text.translate(mapping)

for fname, items in by_file.items():
    for i, item in enumerate(items):
        name = item["name"]
        desc = item["desc"]
        ex = item["example"]
        
        # Check if the example is more relevant to ANOTHER item in the same file
        name_norm = normalize_tr(name)
        desc_norm = normalize_tr(desc)
        ex_norm = normalize_tr(ex)
        
        # Extract main nouns/keywords from name (words with len >= 4)
        ignore_words = {'oda', 'odasi', 'veya', 'gibi', 'gore', 'tipi', 'sistem', 'sistemi', 'yontemi', 'raporu', 'kart', 'karti', 'form', 'formu', 'belge', 'belgesi', 'islemi', 'islem', 'yapi', 'yapisi'}
        words = [w for w in re.split(r'[\s/,.\-()]+', name_norm) if len(w) >= 4 and w not in ignore_words]
        
        # Check matching score of example with CURRENT definition
        current_score = sum(1 for w in words if w in ex_norm or w in desc_norm)
        
        # Check matching score of example with OTHER definitions in the same file
        best_other_idx = -1
        best_other_score = -1
        
        for j, other in enumerate(items):
            if j == i:
                continue
            other_name_norm = normalize_tr(other["name"])
            other_words = [w for w in re.split(r'[\s/,.\-()]+', other_name_norm) if len(w) >= 4 and w not in ignore_words]
            if not other_words:
                continue
            
            # Check how many words of OTHER definition appear in THIS example
            score = sum(1 for w in other_words if w in ex_norm)
            # If the example explicitly contains the title of OTHER definition (or acronym)
            other_title_clean = re.sub(r'\(.*?\)', '', other["name"]).strip().lower()
            other_title_norm = normalize_tr(other_title_clean)
            
            if len(other_title_norm) > 5 and other_title_norm in ex_norm and normalize_tr(re.sub(r'\(.*?\)', '', name).strip()) not in ex_norm:
                # Suspect swap or mismatch!
                mismatches.append({
                    "file": fname,
                    "index": i,
                    "name": name,
                    "desc": desc,
                    "example": ex,
                    "matched_other_name": other["name"],
                    "reason": f"Example contains the title of OTHER definition: '{other['name']}'"
                })

print(f"Detected {len(mismatches)} potential title/concept mismatches.")

with open(r"c:\Erol_Mobil_Gelistirme\TurizmAkademi\scratch\mismatches_found.json", "w", encoding="utf-8") as f:
    json.dump(mismatches, f, ensure_ascii=False, indent=2)
