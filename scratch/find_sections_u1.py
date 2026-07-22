import sys

sys.stdout.reconfigure(encoding='utf-8')

with open('scratch/unit1_9th_extracted.txt', 'r', encoding='utf-8') as f:
    text = f.read()

# Search for key subheadings like 1.1, 1.2, 1.3
lines = text.split('\n')
for i, line in enumerate(lines):
    if any(k in line for k in ['1.1', '1.2', '1.3', 'Etik', 'Ahilik', 'Problem', 'Ahi', 'Fütüvvet', 'Kavram', 'İlke']):
        print(f"L{i}: {line.strip()}")
