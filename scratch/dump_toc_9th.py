import fitz

pdf_path = r"pdfs/9. Sınıf Mesleki Gelişim Atölyesi.pdf"
doc = fitz.open(pdf_path)

for i in range(15):
    print(f"--- PAGE {i+1} ---")
    print(doc[i].get_text()[:1000])
