import re
import sys

sys.stdout.reconfigure(encoding='utf-8')

dart_file = r'lib/core/data/courses/10_kat_hizmetleri_notes.dart'

with open(dart_file, 'r', encoding='utf-8') as f:
    text = f.read()

text = text.replace('"name": "Kirli Çamaşır Toplama"', '"name": "Çamaşır ve Tekstil Düzenlenmesi"')
text = text.replace('"name": "Çarşaf Serimi"', '"name": "Yatak Takımları ve Nevresim Hazırlığı"')
text = text.replace('"name": "Zarf Köşe Yapımı"', '"name": "Nevresim Katlama Yöntemi"')
text = text.replace('"name": "Klozet Hijyen Şeridi"', '"name": "Banyo Dezenfeksiyonu ve Kontrolü"')

with open(dart_file, 'w', encoding='utf-8') as f:
    f.write(text)

print("10th Grade Kat Hizmetleri final terms updated.")
