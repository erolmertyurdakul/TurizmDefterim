import fitz
import json

pdf_path = r"c:\Erol_Mobil_Gelistirme\TurizmAkademi\pdfs\11. Sınıf Ön Büro Hizmetleri Atölyesi.pdf"
doc = fitz.open(pdf_path)

print(f"Opened PDF: {pdf_path}, Total Pages: {len(doc)}")

# Search for Learning Unit headings across pages 10 to 20
units_info = []

for i in range(len(doc)):
    text = doc[i].get_text()
    lines = text.splitlines()
    for line in lines:
        if "ÖĞRENME BİRİMİ" in line.upper() or "VARDİYASI" in line.upper() or "DEFTERLER" in line.upper() or "MATEMATİK" in line.upper() or "HESAPLAR" in line.upper():
            if len(line.strip()) > 3 and len(line.strip()) < 80:
                # Store sample page reference
                pass

print("Searching TOC and unit details...")
toc_text = ""
for i in range(8, 15):
    toc_text += f"\n--- Page {i+1} ---\n" + doc[i].get_text()

with open(r"c:\Erol_Mobil_Gelistirme\TurizmAkademi\scratch\toc_raw.txt", "w", encoding="utf-8") as f:
    f.write(toc_text)

print("TOC raw written to scratch/toc_raw.txt")
