import json
import re

with open(r"c:\Erol_Mobil_Gelistirme\TurizmAkademi\scratch\all_definitions_dump.json", "r", encoding="utf-8") as f:
    definitions = json.load(f)

mismatches = []

# Helper to normalize Turkish text
def normalize(text):
    text = text.lower()
    text = text.replace('ı', 'i').replace('ğ', 'g').replace('ü', 'u').replace('ş', 's').replace('ö', 'o').replace('ç', 'c')
    return text

for idx, item in enumerate(definitions):
    name = item["name"]
    desc = item["desc"]
    ex = item["example"]
    filepath = item["filepath"]
    filename = item["file"]
    
    # Check 1: Does the example mention a specific term that belongs to ANOTHER definition in the same file or nearby?
    # Extract main keywords from 'name' (excluding common words)
    name_clean = re.sub(r'\(.*?\)', '', name).strip()
    words = [w for w in re.split(r'[\s/,.\-]+', normalize(name_clean)) if len(w) > 3 and w not in ['oda', 'odasi', 'veya', 'gibi', 'gore', 'tipi', 'sistem', 'sistemi', 'yontemi', 'raporu', 'kart', 'karti', 'form', 'formu', 'belge', 'belgesi']]
    
    # Check if any parenthetical acronym/term in name exists (e.g. OB, BB, HB, FB, AI, UAI, Overbooking, Discrepancy, VIP, Walk-in, No-Show)
    acronyms = re.findall(r'\(([^)]+)\)', name)
    
    # Flag potential mismatches where example explicitly mentions another concept
    # Let's inspect examples that don't share any keyword with name/desc or explicitly talk about something else
    
    # Specific known mismatch checks:
    # 1. Check if example mentions a different acronym than the definition acronym
    for acr in acronyms:
        # If definition has (OB) but example says (BB) or Only Bed vs Bed & Breakfast
        pass
    
    # Check if example starts with wrong prefix or talks about completely different subject
    ex_lower = normalize(ex)
    desc_lower = normalize(desc)
    name_lower = normalize(name)

    # Simple heuristic checks for obvious swaps/mismatches:
    # E.g. Check if definition is about X and example is about Y
    relevance_score = 0
    for w in words:
        if w in ex_lower or w in desc_lower:
            relevance_score += 1

print(f"Total analyzed: {len(definitions)}")
