import os
import re
import sys

sys.stdout.reconfigure(encoding='utf-8')

desktop_file = r'C:\Users\erolm\Desktop\eklenenler ve çıkarılanlar bugün.txt'

def log_change(course_name, unit_name, card_title, change_type, text_content):
    with open(desktop_file, 'a', encoding='utf-8') as f:
        f.write(f"\n[{course_name}] -> [{unit_name}] -> [{card_title}]\n")
        f.write(f"  ISLEM: {change_type}\n")
        f.write(f"  ICERIK: {text_content}\n")
        f.write("-" * 60 + "\n")

print("Logger initialized.")
