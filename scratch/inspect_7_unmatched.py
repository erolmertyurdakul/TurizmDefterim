import os
import re
import sys

sys.stdout.reconfigure(encoding='utf-8')

dart_file = r'lib/core/data/terminology_data.dart'
pdf_dir = "scratch/pdf_texts"

pdf_corpus = ""
for fname in os.listdir(pdf_dir):
    if fname.endswith('.txt'):
        with open(os.path.join(pdf_dir, fname), 'r', encoding='utf-8') as pf:
            pdf_corpus += "\n" + pf.read().lower()

with open(dart_file, 'r', encoding='utf-8') as f:
    text = f.read()

term_blocks = re.findall(r'Term\s*\((.*?)\),?\s*(?=Term\s*\(|\];|\Z)', text, re.DOTALL)

for idx, block in enumerate(term_blocks, 1):
    w_match = re.search(r"word:\s*['\"]([^'\"]+)['\"]", block)
    d_match = re.search(r"definition:\s*['\"]([^'\"]+)['\"]", block)
    c_match = re.search(r"category:\s*['\"]([^'\"]+)['\"]", block)
    
    word = w_match.group(1) if w_match else ""
    definition = d_match.group(1) if d_match else ""
    category = c_match.group(1) if c_match else ""
    
    stems = [w[:4].lower() for w in re.split(r'\W+', word) if len(w) >= 3]
    found = any(st in pdf_corpus for st in stems) if stems else True
    if not found:
        print(f"[{idx:03d}] UNMATCHED: '{word}' | Category: '{category}' | Def: '{definition[:60]}...'")
