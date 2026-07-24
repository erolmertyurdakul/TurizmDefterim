import os
import re
import json
import time

desktop_path = r"C:\Users\erolm\Desktop"
supheli_txt = os.path.join(desktop_path, "şüpheli cümleler.txt")
degisen_txt = os.path.join(desktop_path, "değiştirdiğim şüpheliler.txt")

pdf_index_path = r"c:\Erol_Mobil_Gelistirme\TurizmAkademi\scratch\pdf_text_index.json"
data_dir = r"c:\Erol_Mobil_Gelistirme\TurizmAkademi\lib\core\data"
courses_dir = os.path.join(data_dir, "courses")

def get_all_target_files():
    files = [
        os.path.join(data_dir, "lecture_notes.dart"),
        os.path.join(data_dir, "quiz_data.dart"),
        os.path.join(data_dir, "terminology_data.dart"),
        os.path.join(data_dir, "reception_simulator_data.dart"),
        os.path.join(data_dir, "daily_facts.dart"),
    ]
    if os.path.exists(courses_dir):
        for f in os.listdir(courses_dir):
            if f.endswith(".dart"):
                files.append(os.path.join(courses_dir, f))
    return [f for f in files if os.path.exists(f)]

print(f"Target files count: {len(get_all_target_files())}")
