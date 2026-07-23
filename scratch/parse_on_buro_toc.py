import fitz
import os

pdf_path = r"c:\Erol_Mobil_Gelistirme\TurizmAkademi\pdfs\11. Sınıf Ön Büro Hizmetleri Atölyesi.pdf"
doc = fitz.open(pdf_path)

print("=== TABLE OF CONTENTS (PAGES 9-14) ===")
for p in range(8, 14):
    print(f"\n--- PAGE {p+1} ---")
    print(doc[p].get_text())
