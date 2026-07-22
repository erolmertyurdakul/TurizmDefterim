import re
import sys

sys.stdout.reconfigure(encoding='utf-8')

dart_file = r'lib/core/data/courses/9_mesleki_gelisim_notes.dart'
desktop_file = r'C:\Users\erolm\Desktop\eklenenler ve çıkarılanlar bugün.txt'

with open(dart_file, 'r', encoding='utf-8') as f:
    content = f.read()

# Replace Mavi Bayrak definition block with Ekolojik Okuryazarlık
pattern = r'\{\s*"name": "Mavi Bayrak \(Blue Flag\)",.*?\n\s*\}'
new_block = '''{
          "name": "Ekolojik Okuryazarlık",
          "desc": "Doğal ekosistemlerin çalışma ilkelerini anlamak, doğanın dengesini korumak ve çevreyle uyumlu yaşam alışkanlıkları geliştirmektir.",
          "examples": [
            "Örnekle Pekiştirelim: Bir öğrencinin su ve enerji tasarrufu yaparak, doğaya zarar vermeyen geri dönüştürülebilir ürünleri tercih etmesi ekolojik okuryazarlık örneğidir."
          ]
        }'''

new_content, count = re.subn(pattern, new_block, content, flags=re.DOTALL)

if count > 0:
    with open(dart_file, 'w', encoding='utf-8') as f:
        f.write(new_content)
    print("Successfully replaced Mavi Bayrak with Ekolojik Okuryazarlık!")
    with open(desktop_file, 'a', encoding='utf-8') as df:
        df.write(f"\n[ÖĞRENME BİRİMİ: 4. Öğrenme Birimi (Çevre Koruma)]\n")
        df.write(f"  - ÇIKARILAN: Mavi Bayrak (Blue Flag)\n")
        df.write(f"  + EKLENEN: Ekolojik Okuryazarlık\n")
        df.write(f"  > GEREKÇE: Mavi Bayrak 11. Sınıf Sürdürülebilir Turizm müfredatına aittir. 9. Sınıf kitabında Ekolojik Okuryazarlık yer almaktadır.\n")
else:
    print("Pattern not matched!")
