import re
import sys

sys.stdout.reconfigure(encoding='utf-8')

dart_file = r'lib/core/data/courses/9_mesleki_gelisim_notes.dart'
desktop_file = r'C:\Users\erolm\Desktop\eklenenler ve çıkarılanlar bugün.txt'

with open(dart_file, 'r', encoding='utf-8') as f:
    content = f.read()

pattern = r'\{\s*"name": "Sürdürülebilirlik",.*?\n\s*\}'
new_block = '''{
          "name": "Sürdürülebilir Gelişme ve Ekolojik Denge",
          "desc": "Gelecek nesillerin ihtiyaçlarını tehlikeye atmadan, doğayı koruyarak kalkınma ve üretim süreçlerini yürütme anlayışıdır.",
          "examples": [
            "Örnekle Pekiştirelim: İşletmelerin doğal kaynakları tükenmeden kullanması ve çevre dostu üretim teknolojilerini benimsemesidir."
          ]
        }'''

new_content, count = re.subn(pattern, new_block, content, flags=re.DOTALL)

if count > 0:
    with open(dart_file, 'w', encoding='utf-8') as f:
        f.write(new_content)
    print("9th Grade: Sürdürülebilirlik replaced with Sürdürülebilir Gelişme ve Ekolojik Denge")
    with open(desktop_file, 'a', encoding='utf-8') as df:
        df.write(f"\n[ÖĞRENME BİRİMİ: 4. Öğrenme Birimi (Çevre Koruma)]\n")
        df.write(f"  - ÇIKARILAN: Sürdürülebilirlik (Genel terim)\n")
        df.write(f"  + EKLENEN: Sürdürülebilir Gelişme ve Ekolojik Denge\n")
        df.write(f"  > GEREKÇE: MEB 9. Sınıf müfredatında kavram 'Sürdürülebilir Gelişme ve Ekolojik Denge' başlığıyla tanımlanmaktadır.\n")
else:
    print("Pattern for Sürdürülebilirlik not matched")
