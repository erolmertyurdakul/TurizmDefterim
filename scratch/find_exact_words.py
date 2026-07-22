import sys

sys.stdout.reconfigure(encoding='utf-8')

with open(r'scratch/pdf_texts/10. Sınıf Kat Hizmetleri Atölyesi.txt', 'r', encoding='utf-8') as f:
    text = f.read()

for word in ["kirli", "çarşaf", "zarf", "klozet", "şerit", "hijyen"]:
    pos = text.lower().find(word)
    if pos != -1:
        print(f"Word '{word}' found around: {text[pos-50:pos+100]}")
    else:
        print(f"Word '{word}' NOT found in 10th grade Kat Hizmetleri text!")
