import re
import sys

sys.stdout.reconfigure(encoding='utf-8')

dart_file = r'lib/core/data/courses/10_kat_hizmetleri_notes.dart'
pdf_file = r'scratch/pdf_texts/10. Sınıf Kat Hizmetleri Atölyesi.txt'

with open(dart_file, 'r', encoding='utf-8') as f:
    dart_text = f.read()

with open(pdf_file, 'r', encoding='utf-8') as f:
    pdf_text = f.read().lower()

defs = re.findall(r'"name": "([^"]+)"', dart_text)

print(f"Total definitions in 10th grade Kat Hizmetleri: {len(defs)}")
for d in defs:
    clean_d = d.lower()
    words = [w for w in re.split(r'\W+', clean_d) if len(w) > 3]
    found = [w for w in words if w in pdf_text]
    print(f"Def: '{d}' -> Matches in PDF: {found}")
