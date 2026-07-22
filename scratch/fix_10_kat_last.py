import sys

sys.stdout.reconfigure(encoding='utf-8')

dart_file = r'lib/core/data/courses/10_kat_hizmetleri_notes.dart'

with open(dart_file, 'r', encoding='utf-8') as f:
    text = f.read()

text = text.replace('"name": "Çamaşır ve Tekstil Düzenlenmesi"', '"name": "Tekstil ve Çamaşır Yönetimi"')

with open(dart_file, 'w', encoding='utf-8') as f:
    f.write(text)

print("10th Grade final single term updated.")
