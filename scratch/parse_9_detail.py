import re
import sys

sys.stdout.reconfigure(encoding='utf-8')

with open('lib/core/data/courses/9_mesleki_gelisim_notes.dart', 'r', encoding='utf-8') as f:
    text = f.read()

# Parse map blocks
unit_blocks = re.findall(r'const Map<String, dynamic> (\w+) = \{(.*?)\n\};', text, re.DOTALL)

for map_name, map_content in unit_blocks:
    unit_title = re.search(r'"title": "([^"]+)"', map_content)
    unit_name = re.search(r'"learningUnit": "([^"]+)"', map_content)
    print(f"\n==========================================")
    print(f"MAP: {map_name} | {unit_name.group(1) if unit_name else ''} | {unit_title.group(1) if unit_title else ''}")
    print(f"==========================================")
    
    card_matches = re.findall(r'\{\s*"id": (\d+),\s*"tag": "([^"]+)",\s*"title": "([^"]+)",\s*"microSummary": "([^"]+)",\s*"definitions": \[(.*?)\],', map_content, re.DOTALL)
    for cid, ctag, ctitle, cmicro, cdefs_str in card_matches:
        print(f"\n  CARD {cid} [{ctag}]: {ctitle}")
        print(f"  MicroSummary: {cmicro}")
        
        defs = re.findall(r'\{\s*"name": "([^"]+)",\s*"desc": "([^"]+)",\s*"examples": \[(.*?)\]\s*\}', cdefs_str, re.DOTALL)
        for dname, ddesc, dexamples in defs:
            print(f"    - DEF: {dname}")
            print(f"      DESC: {ddesc}")
            print(f"      EX: {dexamples.strip()}")
