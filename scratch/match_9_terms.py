import re
import sys

sys.stdout.reconfigure(encoding='utf-8')

with open('lib/core/data/courses/9_mesleki_gelisim_notes.dart', 'r', encoding='utf-8') as f:
    dart_text = f.read()

with open('scratch/pdf_texts/9. Sınıf Mesleki Gelişim Atölyesi.txt', 'r', encoding='utf-8') as f:
    pdf_text = f.read().lower()

# Extract all term names from Dart
def_names = re.findall(r'"name": "([^"]+)"', dart_text)
print(f"Total definitions in 9th grade notes: {len(def_names)}")

missing = []
found = []
for name in def_names:
    clean_n = name.lower()
    # Check key words of the term in PDF text
    words = [w for w in re.split(r'\W+', clean_n) if len(w) > 3]
    match_count = sum(1 for w in words if w in pdf_text)
    if match_count > 0 or not words:
        found.append(name)
    else:
        missing.append(name)

print("\n--- MATCHED TERMS ---")
for f in found:
    print("  [OK]", f)

print("\n--- TERMS NOT FOUND IN PDF ---")
for m in missing:
    print("  [NOT IN PDF]", m)
