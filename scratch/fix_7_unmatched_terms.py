import re
import sys

sys.stdout.reconfigure(encoding='utf-8')

dart_file = r'lib/core/data/terminology_data.dart'

with open(dart_file, 'r', encoding='utf-8') as f:
    text = f.read()

replacements = [
    ("word: 'Kapora'", "word: 'Ön Ödeme (Kapora / Depozito)'"),
    ("word: 'BRC'", "word: 'BRC (Gıda Güvenliği Standardı)'"),
    ("word: 'İflas'", "word: 'İşletme İflası ve Tasfiye'"),
    ("word: 'İhracat'", "word: 'Hizmet İhracatı ve Turizm Geliri'"),
    ("word: 'KOSGEB'", "word: 'KOSGEB Girişimcilik Destekleri'"),
    ("word: 'TGA'", "word: 'TGA (Türkiye Turizm Tanıtım ve Geliştirme Ajansı)'"),
    ("word: 'İkebana'", "word: 'İkebana (Japon Çiçek Düzenleme Sanatı)'")
]

for old_str, new_str in replacements:
    text = text.replace(old_str, new_str)

with open(dart_file, 'w', encoding='utf-8') as f:
    f.write(text)

print("Updated 7 remaining terms in terminology_data.dart to official MEB textbook nomenclature!")
