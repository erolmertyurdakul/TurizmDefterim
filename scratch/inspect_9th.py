import fitz
import os

pdf_path = r"pdfs/9. Sınıf Mesleki Gelişim Atölyesi.pdf"
doc = fitz.open(pdf_path)

print(f"Total pages: {len(doc)}")

toc = doc.get_toc()
print("TOC:", toc)

for page_num in range(len(doc)):
    text = doc[page_num].get_text()
    if "ÖĞRENME BİRİMİ" in text.upper():
        lines = [line.strip() for line in text.split("\n") if "ÖĞRENME BİRİMİ" in line.upper()]
        print(f"Page {page_num+1}: {lines}")
