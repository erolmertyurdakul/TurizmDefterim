import json
import re
import sys

sys.stdout.reconfigure(encoding='utf-8')

# Read 9th grade Dart file
with open('lib/core/data/courses/9_mesleki_gelisim_notes.dart', 'r', encoding='utf-8') as f:
    dart_content = f.read()

# Read 9th grade PDF text
with open('scratch/pdf_texts/9. Sınıf Mesleki Gelişim Atölyesi.txt', 'r', encoding='utf-8') as f:
    pdf_text = f.read()

print("Dart content size:", len(dart_content))
print("PDF text size:", len(pdf_text))

# Find all cards and definitions in 9_mesleki_gelisim_notes.dart
cards = re.findall(r'"title": "([^"]+)",\s*"microSummary": "([^"]+)"', dart_content)
for c in cards:
    print("Card Title:", c[0])
