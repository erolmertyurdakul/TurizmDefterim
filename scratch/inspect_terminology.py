import re
import sys

sys.stdout.reconfigure(encoding='utf-8')

fpath = 'lib/core/data/terminology_data.dart'
with open(fpath, 'r', encoding='utf-8') as f:
    text = f.read()

# Extract term definitions (term, category/meaning)
# Terms in terminology_data.dart: TermModel(...) or Map objects
terms = re.findall(r'"term":\s*"([^"]+)"', text)
if not terms:
    terms = re.findall(r'term:\s*[\'"]([^\'"]+)[\'"]', text)

print(f"Total terms found in terminology_data.dart: {len(terms)}")
for t in terms[:15]:
    print(" -", t)
