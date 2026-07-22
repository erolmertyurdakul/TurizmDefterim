import re
import sys

sys.stdout.reconfigure(encoding='utf-8')

desktop_file = r'C:\Users\erolm\Desktop\eklenenler ve çıkarılanlar bugün.txt'

fixes_12 = [
    {
        "course": "12. Sınıf Alternatif Turizm",
        "file": "lib/core/data/courses/12_alternatif_turizm_notes.dart",
        "old": "Klimatoterapi",
        "new": "Klimatizm ve İklim Kürleri",
        "reason": "MEB Alternatif Turizm kitabında sağlık turizmi iklim kürleri ve klimatizm başlığı altında işlenir."
    },
    {
        "course": "12. Sınıf Dünya Seyahat ve Turizm Coğrafyası",
        "file": "lib/core/data/courses/12_dunya_cografyasi_notes.dart",
        "old": "Han ve Kervansaray",
        "new": "Kervansaraylar ve Tarihi İpek Yolu Yapıları",
        "reason": "MEB Turizm Coğrafyası kitabında tarihi konaklama yapıları İpek Yolu ve kervansaraylar başlığıyla geçer."
    },
    {
        "course": "12. Sınıf Dünya Kültürleri",
        "file": "lib/core/data/courses/12_dunya_kulturleri_notes.dart",
        "old": "Yerelleşme (Glocalization)",
        "new": "Küreselleşme ve Yerel Kültürler",
        "reason": "MEB Dünya Kültürleri kitabında küreselleşme ve yerel kültürlerin korunması kavramı esastır."
    },
    {
        "course": "12. Sınıf Dünya Kültürleri",
        "file": "lib/core/data/courses/12_dunya_kulturleri_notes.dart",
        "old": "Sürdürülebilirlik Odaklı Gezginler",
        "new": "Kültür Turistleri ve Gezgin Tipleri",
        "reason": "MEB Dünya Kültürleri kitabında gezgin tipleri ve kültür turistleri sınıflandırılmıştır."
    },
    {
        "course": "12. Sınıf Dünya Kültürleri",
        "file": "lib/core/data/courses/12_dunya_kulturleri_notes.dart",
        "old": "Helal Konsepti",
        "new": "İnanç ve Kültür Turizmi Standartları",
        "reason": "MEB Dünya Kültürleri kitabında inanç turizmi ve kültürel konsept standartları anlatılır."
    },
    {
        "course": "12. Sınıf Sosyal Medya",
        "file": "lib/core/data/courses/12_sosyal_medya_notes.dart",
        "old": "E-Pazaryeri (Marketplace)",
        "new": "Dijital Pazarlama Platformları",
        "reason": "MEB Sosyal Medya kitabında dijital pazarlama platformları kavramı öğretilir."
    },
    {
        "course": "12. Sınıf Sosyal Medya",
        "file": "lib/core/data/courses/12_sosyal_medya_notes.dart",
        "old": "Hedefleme (Targeting)",
        "new": "Sosyal Medya Hedef Kitle Analizi",
        "reason": "MEB Sosyal Medya kitabında hedef kitle analizi terimi geçer."
    },
    {
        "course": "12. Sınıf Sosyal Medya",
        "file": "lib/core/data/courses/12_sosyal_medya_notes.dart",
        "old": "Google Analytics",
        "new": "Dijital Performans ve Etkileşim Ölçümü",
        "reason": "MEB Sosyal Medya kitabında dijital performans ve etkileşim analizi başlığı esastır."
    },
    {
        "course": "12. Sınıf Transfer Operasyonu",
        "file": "lib/core/data/courses/12_transfer_operasyonu_notes.dart",
        "old": "Rota Optimizasyonu",
        "new": "Transfer Rota Planlaması",
        "reason": "MEB Transfer Operasyonu kitabında rota planlaması başlığı kullanılır."
    },
    {
        "course": "12. Sınıf Transfer Operasyonu",
        "file": "lib/core/data/courses/12_transfer_operasyonu_notes.dart",
        "old": "KVKK ve Gizlilik Esası",
        "new": "Yolcu Bilgileri Gizliliği ve Güvenliği",
        "reason": "MEB Transfer Operasyonu kitabında yolcu bilgilerinin korunması ilkesi esastır."
    },
    {
        "course": "12. Sınıf Transfer Operasyonu",
        "file": "lib/core/data/courses/12_transfer_operasyonu_notes.dart",
        "old": "Yeşil Hat (Green Channel)",
        "new": "Gümrük ve Alan Geçiş Prosedürleri",
        "reason": "MEB Transfer Operasyonu kitabında gümrük ve alan geçiş süreçleri öğretilir."
    },
    {
        "course": "12. Sınıf Tur Operasyonu",
        "file": "lib/core/data/courses/12_tur_operasyonu_notes.dart",
        "old": "Mihmandar",
        "new": "Tur Lideri ve Enformatör",
        "reason": "MEB Tur Operasyonu kitabında tur görevlileri Tur Lideri ve Enformatör olarak tanımlanır."
    },
    {
        "course": "12. Sınıf Tur Operasyonu",
        "file": "lib/core/data/courses/12_tur_operasyonu_notes.dart",
        "old": "Paging (İsim Levhası)",
        "new": "Karşılama ve Paging İşlemleri",
        "reason": "MEB Tur Operasyonu kitabında karşılama işlemleri terimi geçer."
    },
    {
        "course": "12. Sınıf Tur Operasyonu",
        "file": "lib/core/data/courses/12_tur_operasyonu_notes.dart",
        "old": "Fizibilite (Ön Keşif / İnfo)",
        "new": "İnfo Tur (Ön İnceleme Gezisi)",
        "reason": "MEB Tur Operasyonu kitabında tur hazırlık gezileri İnfo Tur olarak adlandırılır."
    }
]

with open(desktop_file, 'a', encoding='utf-8') as df:
    df.write(f"\n==================================================\n")
    df.write(f"DERSLER: 12. Sınıf Ders Notları Düzeltmeleri\n")
    df.write(f"==================================================\n")

for fix in fixes_12:
    with open(fix['file'], 'r', encoding='utf-8') as f:
        content = f.read()
    
    new_content = content.replace(f'"name": "{fix["old"]}"', f'"name": "{fix["new"]}"')
    if new_content != content:
        with open(fix['file'], 'w', encoding='utf-8') as f:
            f.write(new_content)
        print(f"12th Grade [{fix['course']}]: {fix['old']} -> {fix['new']}")
        with open(desktop_file, 'a', encoding='utf-8') as df:
            df.write(f"DERS: {fix['course']}\n")
            df.write(f"  - ÇIKARILAN: {fix['old']}\n")
            df.write(f"  + EKLENEN: {fix['new']}\n")
            df.write(f"  > GEREKÇE: {fix['reason']}\n")
            df.write(f"--------------------------------------------------\n")

print("12th Grade fixes finished.")
