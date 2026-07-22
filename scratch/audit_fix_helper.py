import os
import re
import sys

sys.stdout.reconfigure(encoding='utf-8')

desktop_file = r'C:\Users\erolm\Desktop\eklenenler ve çıkarılanlar bugün.txt'

def log_entry(course, unit, action, removed_item, added_item, reason):
    with open(desktop_file, 'a', encoding='utf-8') as f:
        f.write(f"\n==================================================\n")
        f.write(f"DERS: {course}\n")
        f.write(f"ÖĞRENME BİRİMİ: {unit}\n")
        f.write(f"İŞLEM: {action}\n")
        f.write(f"ÇIKARILAN BİLGİ/TERİM: {removed_item}\n")
        f.write(f"EKLENEN MÜFREDAT BİLGİSİ: {added_item}\n")
        f.write(f"GEREKÇE: {reason}\n")
        f.write(f"==================================================\n")

print("Audit helper ready.")
