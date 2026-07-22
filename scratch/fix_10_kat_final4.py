import re
import sys

sys.stdout.reconfigure(encoding='utf-8')

dart_file = r'lib/core/data/courses/10_kat_hizmetleri_notes.dart'

with open(dart_file, 'r', encoding='utf-8') as f:
    text = f.read()

text = text.replace('"name": "Kirli Çamaşırların Toplanması"', '"name": "Kirli Çamaşır Toplama"')
text = text.replace('"name": "Çarşaf Serim Yöntemleri"', '"name": "Çarşaf Serimi"')
text = text.replace('"name": "Zarf Köşe Yöntemi"', '"name": "Zarf Köşe Yapımı"')
text = text.replace('"name": "Hijyen Şeridi Kullanımı"', '"name": "Klozet Hijyen Şeridi"')

with open(dart_file, 'w', encoding='utf-8') as f:
    f.write(text)

print("10th Grade final 4 terms updated.")
