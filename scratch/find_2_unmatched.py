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

term_pattern = r"Term\(\s*word:\s*['\"]([^'\"]+)['\"],\s*definition:\s*['\"]([^'\"]+)['\"],\s*example:\s*['\"]([^'\"]+)['\"],\s*category:\s*['\"]([^'\"]+)['\"],?\s*\)"
term_matches = re.findall(term_pattern, text, re.DOTALL)

for word, definition, example, category in term_matches:
    word_stems = [w[:4].lower() for w in re.split(r'\W+', word) if len(w) >= 3]
    found = any(st in pdf_corpus for st in word_stems) if word_stems else True
    if not found:
        print(f"UNMATCHED TERM: '{word}' | Category: '{category}' | Def: '{definition}'")
