import fitz
import sys

sys.stdout.reconfigure(encoding='utf-8')

doc = fitz.open(r"pdfs/10. Sınıf Kat Hizmetleri Atölyesi.pdf")

# Inspect text from pages 15-30 using PyMuPDF
for page_num in range(15, 30):
    page_text = doc[page_num].get_text()
    if "Kat Arabası" in page_text or "kat arabası" in page_text.lower() or "banyo" in page_text.lower():
        print(f"=== PAGE {page_num+1} ===")
        print(page_text[:800])
