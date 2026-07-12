import pypdf
import os

pdf_path = r"C:\Users\erolm\.gemini\antigravity-ide\brain\59022f4e-587c-454e-9528-b5d5821bac0c\.tempmediaStorage\media_59022f4e-587c-454e-9528-b5d5821bac0c_1782345368503.pdf"
output_path = r"c:\Users\erolm\Desktop\TurizmAkademi\extracted_text.txt"

print(f"Reading PDF: {pdf_path}")
print(f"Exists: {os.path.exists(pdf_path)}")

try:
    reader = pypdf.PdfReader(pdf_path)
    print(f"Total Pages: {len(reader.pages)}")
    
    with open(output_path, "w", encoding="utf-8") as f:
        for idx, page in enumerate(reader.pages):
            text = page.extract_text()
            f.write(f"--- PAGE {idx + 1} ---\n")
            f.write(text)
            f.write("\n")
    print("Success! Extracted text written to extracted_text.txt")
except Exception as e:
    print(f"Error: {e}")
