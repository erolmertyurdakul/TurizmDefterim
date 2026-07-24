import os
import re
import json
import fitz  # PyMuPDF

desktop_path = r"C:\Users\erolm\Desktop"
supheli_txt_path = os.path.join(desktop_path, "şüpheli cümleler.txt")
degisen_txt_path = os.path.join(desktop_path, "değiştirdiğim şüpheliler.txt")

pdfs_dir = r"c:\Erol_Mobil_Gelistirme\TurizmAkademi\pdfs"
data_dir = r"c:\Erol_Mobil_Gelistirme\TurizmAkademi\lib\core\data"
courses_dir = os.path.join(data_dir, "courses")

print("=== STARTING MASTER AUDIT SYSTEM ===")
print(f"PDFs dir: {pdfs_dir}")
print(f"Data dir: {data_dir}")
print(f"Desktop path: {desktop_path}")
