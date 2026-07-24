import json
import os

index_path = r"c:\Erol_Mobil_Gelistirme\TurizmAkademi\scratch\pdf_text_index.json"
if os.path.exists(index_path):
    with open(index_path, "r", encoding="utf-8") as f:
        data = json.load(f)
    print(f"Indexed {len(data)} PDFs.")
    for k, v in data.items():
        print(f"  - {k}: {v['page_count']} pages")
else:
    print("Index file not found yet.")
