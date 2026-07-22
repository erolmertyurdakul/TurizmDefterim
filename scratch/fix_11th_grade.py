import re
import sys

sys.stdout.reconfigure(encoding='utf-8')

desktop_file = r'C:\Users\erolm\Desktop\eklenenler ve çıkarılanlar bugün.txt'

# 1. 11. Sınıf Kat Hizmetleri Atölyesi
f1 = r'lib/core/data/courses/11_kat_hizmetleri_notes.dart'
with open(f1, 'r', encoding='utf-8') as f:
    t1 = f.read()

t1_new = t1.replace('"name": "Işıklandırma ve Ambiyans"', '"name": "Aydınlatma ve Ambiyans Düzeni"')
if t1_new != t1:
    with open(f1, 'w', encoding='utf-8') as f:
        f.write(t1_new)
    print("11th Grade Kat Hizmetleri: Işıklandırma ve Ambiyans updated!")
    with open(desktop_file, 'a', encoding='utf-8') as df:
        df.write(f"\n==================================================\n")
        df.write(f"DERS: 11. Sınıf Kat Hizmetleri Atölyesi\n")
        df.write(f"==================================================\n")
        df.write(f"  - ÇIKARILAN: Işıklandırma ve Ambiyans\n")
        df.write(f"  + EKLENEN: Aydınlatma ve Ambiyans Düzeni\n")
        df.write(f"  > GEREKÇE: MEB 11. Sınıf Kat Hizmetleri ders kitabında resmi terim Aydınlatma ve Ambiyans Düzeni olarak geçmektedir.\n")

# 2. 11. Sınıf Sürdürülebilir Turizm
f2 = r'lib/core/data/courses/11_surdurulebilir_turizm_notes.dart'
with open(f2, 'r', encoding='utf-8') as f:
    t2 = f.read()

t2_new = t2.replace('"name": "Travelife ve Rainforest Alliance"', '"name": "Uluslararası Eko-Etiketler ve GSTC Sertifikaları"')
if t2_new != t2:
    with open(f2, 'w', encoding='utf-8') as f:
        f.write(t2_new)
    print("11th Grade Sürdürülebilir Turizm: Travelife updated!")
    with open(desktop_file, 'a', encoding='utf-8') as df:
        df.write(f"\n==================================================\n")
        df.write(f"DERS: 11. Sınıf Sürdürülebilir Turizm\n")
        df.write(f"==================================================\n")
        df.write(f"  - ÇIKARILAN: Travelife ve Rainforest Alliance\n")
        df.write(f"  + EKLENEN: Uluslararası Eko-Etiketler ve GSTC Sertifikaları\n")
        df.write(f"  > GEREKÇE: MEB 11. Sınıf Sürdürülebilir Turizm kitabında sürdürülebilirlik sertifikaları GSTC ve Green Globe standartlarıyla öğretilmektedir.\n")

# 3. 11. Sınıf Konaklama İşletmeciliği
f3 = r'lib/core/data/courses/11_konaklama_isletmeciligi_notes.dart'
with open(f3, 'r', encoding='utf-8') as f:
    t3 = f.read()

t3_new = t3.replace('"name": "Mevsimsellik (Seasonality)"', '"name": "Sezonallik (Mevsimsel Dalgalanmalar)"')
if t3_new != t3:
    with open(f3, 'w', encoding='utf-8') as f:
        f.write(t3_new)
    print("11th Grade Konaklama İşletmeciliği: Mevsimsellik updated!")
    with open(desktop_file, 'a', encoding='utf-8') as df:
        df.write(f"\n==================================================\n")
        df.write(f"DERS: 11. Sınıf Konaklama İşletmeciliği\n")
        df.write(f"==================================================\n")
        df.write(f"  - ÇIKARILAN: Mevsimsellik (Seasonality)\n")
        df.write(f"  + EKLENEN: Sezonallik (Mevsimsel Dalgalanmalar)\n")
        df.write(f"  > GEREKÇE: MEB 11. Sınıf Konaklama İşletmeciliği kitabında kavram Sezonallik olarak geçmektedir.\n")

print("11th Grade fixes finished.")
