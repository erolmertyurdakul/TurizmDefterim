import re
import sys

sys.stdout.reconfigure(encoding='utf-8')

with open('lib/core/data/courses/9_mesleki_gelisim_notes.dart', 'r', encoding='utf-8') as f:
    text = f.read()

# Match units: 'title': "...", 'cards': [...]
unit_titles = re.findall(r'"title":\s*"([^"]+)"', text)
print("9th Grade Unit Titles found:", len(unit_titles))
for ut in unit_titles[:5]:
    print(" -", ut)
