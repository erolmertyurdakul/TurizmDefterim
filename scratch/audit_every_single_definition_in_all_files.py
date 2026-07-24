import os
import re
import json

courses_dir = r"c:\Erol_Mobil_Gelistirme\TurizmAkademi\lib\core\data\courses"
lecture_notes_path = r"c:\Erol_Mobil_Gelistirme\TurizmAkademi\lib\core\data\lecture_notes.dart"

files = [lecture_notes_path] + [os.path.join(courses_dir, f) for f in os.listdir(courses_dir) if f.endswith(".dart")]

all_def_list = []

for filepath in files:
    filename = os.path.basename(filepath)
    with open(filepath, "r", encoding="utf-8") as f:
        content = f.read()
    
    pattern = re.compile(r'\{\s*"name":\s*"([^"]+)",\s*"desc":\s*"([^"]+)",\s*"examples":\s*\[\s*"([^"]+)"\s*\]\s*\}', re.MULTILINE | re.DOTALL)
    
    for m in pattern.finditer(content):
        all_def_list.append({
            "file": filename,
            "filepath": filepath,
            "name": m.group(1),
            "desc": m.group(2),
            "example": m.group(3),
            "start": m.start(),
            "end": m.end()
        })

print(f"Total definitions to audit: {len(all_def_list)}")

# Let's check for any definitions where the example text mentions a different title/acronym than the note itself:
mismatched_examples_log = []

for item in all_def_list:
    name = item["name"]
    desc = item["desc"]
    ex = item["example"]
    file = item["file"]
    
    # Clean name
    clean_name = re.sub(r'\(.*?\)', '', name).strip().lower()
    
    # 1. Mini Süit Oda:
    if name == "Mini Süit Oda (Junior Suite Room)" and "mini süit" not in ex.lower():
        mismatched_examples_log.append({
            "file": file,
            "name": name,
            "desc": desc,
            "old_example": ex,
            "new_example": "Örnekle Pekiştirelim: Tek bir geniş odanın içerisinde, yatak bölümü ile koltuk takımının şık bir ahşap paravanla ayrıldığı mini süit (junior suite) odada genç bir çiftin kalmasıdır."
        })
        
    # 2. Köşe Süit Oda:
    if name == "Köşe Süit Oda (Corner Suite Room)" and "köşe süit" not in ex.lower():
        mismatched_examples_log.append({
            "file": file,
            "name": name,
            "desc": desc,
            "old_example": ex,
            "new_example": "Örnekle Pekiştirelim: Koridorun en ucunda, hem orman hem deniz manzarasını gören geniş iki cepheli köşe süit (corner suite) odada bir yazarın ilham bulmak için kalmasıdır."
        })

    # 3. Room Discrepancy (10_konuk_giris_cikis_notes.dart)
    if name == "Room Discrepancy (Oda Durum Uyuşmazlığı)" and "uyuşmazlığı" not in ex.lower():
        mismatched_examples_log.append({
            "file": file,
            "name": name,
            "desc": desc,
            "old_example": ex,
            "new_example": "Örnekle Pekiştirelim: Bilgisayarda 'VC' (Boş Temiz) görünen 204 nolu odanın, kat şefinin raporunda 'OC' (Dolu) olarak bildirilmesi sonucu oda durum uyuşmazlığının (discrepancy) tespit edilmesidir."
        })

    # 4. Billing Instruction (10_konuk_giris_cikis_notes.dart)
    if name == "Billing Instruction (Fatura Talimatı) Aktarımı" and "fatura talimatı" not in ex.lower():
        mismatched_examples_log.append({
            "file": file,
            "name": name,
            "desc": desc,
            "old_example": ex,
            "new_example": "Örnekle Pekiştirelim: Fatura talimatı (Billing Instruction) uyarınca X şirketiyle gelen misafirin oda bedelini şirketin City Ledger hesabına aktarıp, kişisel harcamalarını misafirin kendi kartından çekmektir."
        })

    # 5. Konuk Teyidi ve No-Show Tespiti (12_transfer_operasyonu_notes.dart)
    if name == "Konuk Teyidi ve No-Show Tespiti" and "no-show" not in ex.lower():
        mismatched_examples_log.append({
            "file": file,
            "name": name,
            "desc": desc,
            "old_example": ex,
            "new_example": "Örnekle Pekiştirelim: Havalimanı çıkışında yolcuyu göremeyen şoförün operasyon merkezini arayarak teyit alması, yolcuya ulaşılamayınca resmi No-Show (gelmedi) kaydı tutmasıdır."
        })

print(f"Total mismatched examples identified for update: {len(mismatched_examples_log)}")

with open(r"c:\Erol_Mobil_Gelistirme\TurizmAkademi\scratch\fixes_to_apply.json", "w", encoding="utf-8") as f:
    json.dump(mismatched_examples_log, f, ensure_ascii=False, indent=2)
