import re
import sys

sys.stdout.reconfigure(encoding='utf-8')

with open(r'lib/core/data/courses/9_mesleki_gelisim_notes.dart', 'r', encoding='utf-8') as f:
    content = f.read()

# Find map names and titles
maps = re.findall(r'const Map<String, dynamic> (\w+) = \{', content)
titles = re.findall(r'"title": "([^"]+)"', content)
units = re.findall(r'"learningUnit": "([^"]+)"', content)

print("Maps found:", maps)
print("Titles found:", titles)
print("Units found:", units)
