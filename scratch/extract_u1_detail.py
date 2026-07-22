import sys

sys.stdout.reconfigure(encoding='utf-8')

pdf_path = r'scratch/pdf_texts/9. Sınıf Mesleki Gelişim Atölyesi.txt'
with open(pdf_path, 'r', encoding='utf-8') as f:
    text = f.read()

# Let's search pages 15 to 50
# Pages are demarcated by === PAGE X ===
lines = text.split('\n')
p15_idx = 0
p50_idx = 0
for idx, line in enumerate(lines):
    if '=== PAGE 15 ===' in line:
        p15_idx = idx
    if '=== PAGE 50 ===' in line:
        p50_idx = idx

unit1_full = '\n'.join(lines[p15_idx:p50_idx])

# Save unit1_full to a file for easy reading
with open('scratch/unit1_9th_extracted.txt', 'w', encoding='utf-8') as f:
    f.write(unit1_full)

print("Extracted Unit 1 text! Total lines:", len(lines[p15_idx:p50_idx]))
