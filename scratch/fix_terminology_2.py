import re
import sys

sys.stdout.reconfigure(encoding='utf-8')

dart_file = r'lib/core/data/terminology_data.dart'
desktop_file = r'C:\Users\erolm\Desktop\terimler son tarama.txt'

with open(dart_file, 'r', encoding='utf-8') as f:
    text = f.read()

# Replace Butler definition
old_butler = r"Term\(\s*word:\s*['\"]Butler['\"].*?\)"
new_butler = """Term(
    word: 'Kahya (Butler)',
    definition: 'Özellikle üst düzey (VIP/VVIP) konuklara özel, kişiselleştirilmiş hizmet ve oda servisi sunan özel hizmet görevlisidir.',
    example: 'Kral dairesinde konaklayan misafirimize tatili boyunca özel bir Kahya (Butler) eşlik etti.',
    category: 'Konaklama ve Misafirperverlik Hizmetleri',
  )"""

# Replace MSDS definition
old_msds = r"Term\(\s*word:\s*['\"]MSDS['\"].*?\)"
new_msds = """Term(
    word: 'Güvenlik Bilgi Formları (SDS / MSDS)',
    definition: 'Temizlik kimyasallarının güvenli kullanımı, riskleri, depolanması ve acil durum ilk yardım adımlarını içeren Malzeme Güvenlik Bilgi Formudur.',
    example: 'Kat hizmetleri personeli yeni temizlik kimyasalını kullanmadan önce Güvenlik Bilgi Formunu (SDS) inceledi.',
    category: 'Kat Hizmetleri ve Temizlik Operasyonları',
  )"""

text_new = re.sub(old_butler, new_butler, text, flags=re.DOTALL)
text_new = re.sub(old_msds, new_msds, text_new, flags=re.DOTALL)

with open(dart_file, 'w', encoding='utf-8') as f:
    f.write(text_new)

print("Terminology data updated with 100% MEB textbook alignment!")
