import os

pdf_path = None
pdfs_dir = r"c:\Erol_Mobil_Gelistirme\TurizmAkademi\pdfs"
for f in os.listdir(pdfs_dir):
    if "Ön Büro" in f or "on_buro" in f.lower() or "11. S" in f and "n B" in f:
        pdf_path = os.path.join(pdfs_dir, f)
        break

if not pdf_path:
    for f in os.listdir(pdfs_dir):
        if "11" in f and "B" in f:
            pdf_path = os.path.join(pdfs_dir, f)
            break

print("Found PDF:", pdf_path)

try:
    import fitz # PyMuPDF
    doc = fitz.open(pdf_path)
    print("Total Pages:", len(doc))
    
    # Print table of contents or first 15 pages text
    toc = doc.get_toc()
    print("TOC:", toc[:30])
    
    print("\n--- FIRST 5 PAGES SAMPLE ---")
    for i in range(min(10, len(doc))):
        text = doc[i].get_text()
        if "İÇİNDEKİLER" in text.upper() or "ÖĞRENME BİRİMİ" in text.upper() or i < 5:
            print(f"--- PAGE {i+1} ---")
            print(text[:1000])

except Exception as e:
    print("PyMuPDF error:", e)
    try:
        from pypdf import PdfReader
        reader = PdfReader(pdf_path)
        print("pypdf Total Pages:", len(reader.pages))
        for i in range(min(10, len(reader.pages))):
            print(f"--- PAGE {i+1} ---")
            print(reader.pages[i].extract_text()[:1000])
    except Exception as e2:
        print("pypdf error:", e2)
