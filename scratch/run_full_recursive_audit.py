import os
import re
import json

desktop_dir = r"C:\Users\erolm\Desktop"
supheli_file = os.path.join(desktop_dir, "şüpheli cümleler.txt")
degisen_file = os.path.join(desktop_dir, "değiştirdiğim şüpheliler.txt")
pdf_index_path = r"c:\Erol_Mobil_Gelistirme\TurizmAkademi\scratch\pdf_text_index.json"

data_dir = r"c:\Erol_Mobil_Gelistirme\TurizmAkademi\lib\core\data"
courses_dir = os.path.join(data_dir, "courses")

def load_pdf_index():
    if os.path.exists(pdf_index_path):
        with open(pdf_index_path, "r", encoding="utf-8") as f:
            return json.load(f)
    return {}

pdf_data = load_pdf_index()

def search_pdf_text(query, max_results=3):
    results = []
    query_norm = query.lower()
    for pdf_name, pinfo in pdf_data.items():
        for page_obj in pinfo.get("pages", []):
            text = page_obj.get("text", "")
            if query_norm in text.lower():
                results.append((pdf_name, page_obj.get("page"), text[:300].replace('\n', ' ')))
                if len(results) >= max_results:
                    return results
    return results

print(f"Loaded PDF Index with {len(pdf_data)} books.")
