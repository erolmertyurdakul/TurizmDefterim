import pypdf
import os

def check_pdf(filename):
    print(f"=== {filename} ===")
    path = os.path.join("pdfs", filename)
    if not os.path.exists(path):
        print("Does not exist!")
        return
    
    try:
        reader = pypdf.PdfReader(path)
        print(f"Total pages: {len(reader.pages)}")
        
        # Look for outline/TOC
        outline = reader.outline
        if outline:
            print("Outline found:")
            def print_outline(elem, depth=0):
                if isinstance(elem, list):
                    for sub in elem:
                        print_outline(sub, depth + 1)
                else:
                    print("  " * depth + f"- {elem.title}")
            print_outline(outline[:30]) # limit to first 30 elements
        else:
            print("No outline found. Checking first 5 pages for TOC keywords...")
            for i in range(min(5, len(reader.pages))):
                text = reader.pages[i].extract_text()
                if "İÇİNDEKİLER" in text.upper() or "ÖĞRENME BİRİMİ" in text.upper():
                    print(f"--- Page {i+1} ---")
                    print(text[:1500])
                    
    except Exception as e:
        print(f"Error checking PDF: {e}")

check_pdf("12.Sınıf Transfer Operasyonu.pdf")
check_pdf("12. Sınıf Sosyal Medya.pdf")
