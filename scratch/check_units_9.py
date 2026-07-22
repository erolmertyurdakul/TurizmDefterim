import re
import sys

sys.stdout.reconfigure(encoding='utf-8')

pdf_text_path = r'scratch/pdf_texts/9. Sınıf Mesleki Gelişim Atölyesi.txt'
with open(pdf_text_path, 'r', encoding='utf-8') as f:
    text = f.read()

# Let's search for Learning Units / Öğrenme Birimi in the text file
matches = re.findall(r'(ÖĞRENME BİRİMİ.*)', text, re.IGNORECASE)
for m in matches[:30]:
    print(m)
