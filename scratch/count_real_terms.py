import sys

sys.stdout.reconfigure(encoding='utf-8')

fpath = r'lib/core/data/terminology_data.dart'
with open(fpath, 'r', encoding='utf-8') as f:
    text = f.read()

count_term = text.count("Term(")
print(f"Exact count of 'Term(' occurrences in terminology_data.dart: {count_term}")
