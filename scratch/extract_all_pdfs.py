import fitz
import os
import sys

# Ensure UTF-8 output
sys.stdout.reconfigure(encoding='utf-8')

pdf_dir = "pdfs"
out_dir = "scratch/pdf_texts"
os.makedirs(out_dir, exist_ok=True)

files = os.listdir(pdf_dir)
for f in files:
    if f.endswith('.pdf'):
        pdf_path = os.path.join(pdf_dir, f)
        txt_path = os.path.join(out_dir, f.replace('.pdf', '.txt'))
        print(f"Extracting: {f}...")
        doc = fitz.open(pdf_path)
        full_text = []
        for i, page in enumerate(doc):
            t = page.get_text()
            full_text.append(f"=== PAGE {i+1} ===\n" + t)
        
        with open(txt_path, 'w', encoding='utf-8') as out_f:
            out_f.write('\n'.join(full_text))

print("Extraction complete!")
