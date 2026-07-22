import sys

sys.stdout.reconfigure(encoding='utf-8')

with open(r'scratch/pdf_texts/10. Sınıf Kat Hizmetleri Atölyesi.txt', 'r', encoding='utf-8') as f:
    text = f.read()

pos = text.find("İÇİNDEKİLER")
if pos != -1:
    print(text[pos:pos+3000])
else:
    print("İÇİNDEKİLER not found, printing first 2000 chars:")
    print(text[:2000])
