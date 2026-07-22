import sys

sys.stdout.reconfigure(encoding='utf-8')

pdf_path = r'scratch/pdf_texts/9. Sınıf Mesleki Gelişim Atölyesi.txt'
with open(pdf_path, 'r', encoding='utf-8') as f:
    text = f.read()

# Find text of Öğrenme Birimi 1
pos1 = text.find('Öğrenme Birimi 1')
pos2 = text.find('Öğrenme Birimi 2')

unit1_text = text[pos1:pos2]

print("=== UNIT 1 LENGTH:", len(unit1_text))
print("=== FIRST 2000 CHARS ===")
print(unit1_text[:2000])
