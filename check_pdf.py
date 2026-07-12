import sys
import os

output_file = 'check_pdf.txt'

def log(msg):
    print(msg)
    with open(output_file, 'a', encoding='utf-8') as f:
        f.write(msg + '\n')

if os.path.exists(output_file):
    os.remove(output_file)

log("Starting PDF Check Script...")

pdf_path = os.path.abspath("pdfs/12. Sınıf Dünya Kültürleri.pdf")
log(f"PDF Path: {pdf_path}")
log(f"PDF Exists: {os.path.exists(pdf_path)}")
if os.path.exists(pdf_path):
    log(f"PDF Size: {os.path.getsize(pdf_path)} bytes")

# Try to find which PDF library is installed
pdf_lib = None
for lib_name in ['pypdf', 'pdfplumber', 'fitz', 'PyPDF2']:
    try:
        __import__(lib_name)
        log(f"Library {lib_name} is INSTALLED")
        if pdf_lib is None:
            pdf_lib = lib_name
    except ImportError:
        log(f"Library {lib_name} is NOT installed")

if not pdf_lib:
    log("No PDF library is installed!")
    sys.exit(1)

log(f"Using {pdf_lib} to inspect the PDF...")

try:
    if pdf_lib == 'pypdf':
        import pypdf
        reader = pypdf.PdfReader(pdf_path)
        log(f"Total Pages: {len(reader.pages)}")
        # Print first page text
        text = reader.pages[0].extract_text()
        log(f"Page 1 Text (first 500 chars):\n{text[:500]}")
        # Try to find Table of Contents or outline
        outline = reader.outline
        if outline:
            log("Outline/TOC found:")
            def print_outline(elem, depth=0):
                if isinstance(elem, list):
                    for sub in elem:
                        print_outline(sub, depth + 1)
                else:
                    log("  " * depth + f"- {elem.title}")
            print_outline(outline)
        else:
            log("No outline/TOC found in PDF.")
            
    elif pdf_lib == 'pdfplumber':
        import pdfplumber
        with pdfplumber.open(pdf_path) as pdf:
            log(f"Total Pages: {len(pdf.pages)}")
            text = pdf.pages[0].extract_text()
            log(f"Page 1 Text (first 500 chars):\n{text[:500]}")
            
    elif pdf_lib == 'fitz':
        import fitz
        doc = fitz.open(pdf_path)
        log(f"Total Pages: {len(doc)}")
        text = doc[0].get_text()
        log(f"Page 1 Text (first 500 chars):\n{text[:500]}")
        toc = doc.get_toc()
        if toc:
            log("Table of Contents:")
            for item in toc[:50]: # limit to 50
                log(f"{'  ' * item[0]}- {item[1]} (Page {item[2]})")
        else:
            log("No TOC found.")
            
    elif pdf_lib == 'PyPDF2':
        import PyPDF2
        reader = PyPDF2.PdfReader(pdf_path)
        log(f"Total Pages: {len(reader.pages)}")
        text = reader.pages[0].extract_text()
        log(f"Page 1 Text (first 500 chars):\n{text[:500]}")

except Exception as e:
    log(f"Error reading PDF: {e}")

log("Done.")
