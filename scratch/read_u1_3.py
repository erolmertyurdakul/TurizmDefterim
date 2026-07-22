import sys

sys.stdout.reconfigure(encoding='utf-8')

with open('scratch/unit1_9th_extracted.txt', 'r', encoding='utf-8') as f:
    text = f.read()

lines = text.split('\n')
start = False
for i, line in enumerate(lines):
    if '1.3 Meslek Etiğine Uygun Problem Çözme' in line:
        start = True
    if '1.4' in line and start:
        break
    if start:
        print(f"L{i}: {line.strip()}")
