import os
import fitz
import json

pdfs_dir = r"c:\Erol_Mobil_Gelistirme\TurizmAkademi\pdfs"
index_path = r"c:\Erol_Mobil_Gelistirme\TurizmAkademi\scratch\pdf_text_index.json"

pdf_files = [f for f in os.listdir(pdfs_dir) if f.endswith(".pdf")]

pdf_data = {}

print(f"Found {len(pdf_files)} PDF files to index...")

for pdf_name in pdf_files:
    pdf_path = os.path.join(pdfs_dir, pdf_name)
    print(f"Indexing: {pdf_name}...")
    try:
        doc = fitz.open(pdf_path)
        pages_text = []
        for pno in range(len(doc)):
            page = doc[pno]
            pages_text.append({
                "page": pno + 1,
                "text": page.get_text()
            })
        pdf_data[pdf_name] = {
            "page_count": len(doc),
            "pages": pages_text
        }
        doc.close()
    except Exception as e:
        print(f"Error indexing {pdf_name}: {e}")

print(f"Successfully indexed {len(pdf_data)} PDF files.")

with open(index_path, "w", encoding="utf-8") as f:
    json.dump(pdf_data, f, ensure_ascii=False, indent=2)

print(f"Saved PDF index to {index_path}")
