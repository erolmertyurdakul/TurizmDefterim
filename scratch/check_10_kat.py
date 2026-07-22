import re
import sys

sys.stdout.reconfigure(encoding='utf-8')

pdf_text_path = r'scratch/pdf_texts/10. Sınıf Kat Hizmetleri Atölyesi.txt'
with open(pdf_text_path, 'r', encoding='utf-8') as f:
    text = f.read()

print("10th Grade Kat Hizmetleri PDF Length:", len(text))

# Find lines with ÖĞRENME BİRİMİ or section headers
lines = text.split('\n')
for i, line in enumerate(lines[:300]):
    if any(k in line for k in ['ÖĞRENME BİRİMİ', '1.', '2.', '3.', '4.', '5.', 'Temizlik', 'Oda', 'Kat', 'Tekstil']):
        print(f"L{i}: {line.strip()}")
