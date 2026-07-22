import os
import re
import sys
import subprocess

# FFmpeg yollarını Windows PATH'ine dinamik olarak ekleme
def setup_ffmpeg_path():
    # Winget varsayılan link klasörünü ekle
    winget_links = r"C:\Users\erolm\AppData\Local\Microsoft\WinGet\Links"
    if os.path.exists(winget_links) and winget_links not in os.environ["PATH"]:
        os.environ["PATH"] += os.pathsep + winget_links
        
    # Gyan FFmpeg paket klasörünü tarayıp ekle
    packages_dir = r"C:\Users\erolm\AppData\Local\Microsoft\WinGet\Packages"
    if os.path.exists(packages_dir):
        for root, dirs, files in os.walk(packages_dir):
            if "ffmpeg.exe" in files:
                if root not in os.environ["PATH"]:
                    os.environ["PATH"] += os.pathsep + root
                break

setup_ffmpeg_path()

# Gerekli kütüphaneleri kontrol et ve yükle
def install_requirements():
    try:
        import whisper
    except ImportError:
        print("[INFO] 'openai-whisper' kütüphanesi yüklü değil. Kuruluyor...")
        subprocess.check_call([sys.executable, "-m", "pip", "install", "openai-whisper"])
    
    try:
        from pydub import AudioSegment
    except ImportError:
        print("[INFO] 'pydub' kütüphanesi yüklü değil. Kuruluyor...")
        subprocess.check_call([sys.executable, "-m", "pip", "install", "pydub"])

install_requirements()

import whisper
from tqdm import tqdm

# Klasör Yolları
BASE_DIR = r"C:\Users\erolm\Desktop\Podcastler (dönüştürülmüş)"
OUTPUT_DIR = os.path.join(BASE_DIR, "Podcastlerin Metin Halleri")

if not os.path.exists(OUTPUT_DIR):
    os.makedirs(OUTPUT_DIR)

# MP3 isminden yasal dosya adını türeten fonksiyon
def get_output_filename(mp3_name):
    name = mp3_name.lower().replace('.mp3', '')
    
    # Sınıf belirleme
    if '12' in name:
        sinif = '12'
    elif '11' in name:
        sinif = '11'
    elif '10' in name:
        sinif = '10'
    elif '9' in name:
        sinif = '9'
    else:
        sinif = 'BilinmeyenSınıf'
        
    # Ders belirleme
    ders = 'BilinmeyenDers'
    if 'alternatif' in name:
        ders = 'AlternatifTurizm'
    elif 'kuru' in name:
        ders = 'KuruTemizleme'
    elif 'çamaşır' in name or 'camasir' in name:
        ders = 'Camasirhane'
    elif 'dünyakültür' in name or 'dunyalkultur' in name or 'dunyacografyasi' in name or 'dünyakül' in name:
        ders = 'DunyaKulturleri'
    elif 'dünyasey' in name or 'dunyasey' in name or 'cografya' in name or 'dünyase' in name:
        ders = 'DunyaCografyasi'
    elif 'gastronomi' in name:
        ders = 'GastronomiTurizmi'
    elif 'kongre' in name:
        ders = 'KongreEtkinlik'
    elif 'sosyalmedya' in name or 'sosyal-medya' in name:
        ders = 'SosyalMedya'
    elif 'transfer' in name:
        ders = 'TransferOperasyonu'
    elif 'turoperasyonu' in name or 'tur-operasyonu' in name:
        ders = 'TurOperasyonu'
    elif 'kat' in name:
        ders = 'KatHizmetleri'
    elif 'konuk' in name:
        ders = 'KonukGirisCikis'
    elif 'rez' in name:
        ders = 'OnBurodaRezervasyon'
    elif 'meslekigel' in name:
        ders = 'MeslekiGelisim'
    elif 'konaklama' in name:
        ders = 'KonaklamaIsletmeciligi'
    elif 'sürdürülebilir' in name or 'surdurulebilir' in name:
        ders = 'SurdurulebilirTurizm'
        
    # Öğrenme Birimi Numarası tespiti
    nums = re.findall(r'\d+', name)
    num = '1'
    if len(nums) > 1:
        # Örneğin '12' sınıf sayısı dışında bir sayı varsa onu al
        for n in nums:
            if n != '12' and n != '11' and n != '10' and n != '9':
                num = n
                break
    elif len(nums) == 1:
        if nums[0] not in ['12', '11', '10', '9']:
            num = nums[0]
            
    return f"{sinif}-{ders}-{num}-Podcast.txt"

def main():
    print("=" * 60)
    print(" 9, 10 VE 11. SINIF PODCAST TRANSKRİPASYON & DENETİM BAŞLATILIYOR ")
    print("=" * 60)
    
    # 1. Adım: MP3 dosyalarını listele
    all_files = os.listdir(BASE_DIR)
    mp3_files = [f for f in all_files if f.lower().endswith('.mp3')]
    
    # 9, 10 ve 11. Sınıf filtreleme
    target_files = []
    for f in mp3_files:
        name_lower = f.lower()
        if '9' in name_lower or '10' in name_lower or '11' in name_lower:
            target_files.append(f)
            
    print(f"[INFO] Toplam 9, 10 ve 11. Sınıf Podcast Dosyası Sayısı: {len(target_files)}")
    
    if len(target_files) == 0:
        print("[WARNING] Klasörde '9', '10' veya '11' ibaresi içeren MP3 dosyası bulunamadı!")
        return
        
    # 2. Adım: Whisper Modelini Yükle (Türkçe için 'base' modeli)
    print("[INFO] Whisper 'base' modeli yükleniyor...")
    model = whisper.load_model("base")
    print("[INFO] Model başarıyla yüklendi.")
    
    # 3. Adım: Dosyaları Sırayla Deşifre Et ve Kaydet
    for idx, mp3_file in enumerate(target_files, 1):
        input_path = os.path.join(BASE_DIR, mp3_file)
        out_name = get_output_filename(mp3_file)
        output_path = os.path.join(OUTPUT_DIR, out_name)
        
        print(f"\n[{idx}/{len(target_files)}] İşleniyor: {mp3_file}")
        print(f"-> Çıktı Dosyası: {out_name}")
        
        # Kaldığı yerden devam etme (Checkpoint) kontrolü
        if os.path.exists(output_path):
            print(f"[SKIP] {out_name} zaten deşifre edilmiş. Atlanıyor.")
            # Mevcut metin üzerinde denetim yap
            try:
                with open(output_path, "r", encoding="utf-8") as f:
                    text_content = f.read()
                    check_text_for_issues(text_content, out_name)
            except Exception as e:
                print(f"[ERROR] Mevcut dosya taranırken hata: {e}")
            continue
        
        # Deşifre Et
        try:
            result = model.transcribe(input_path, language="tr")
            text = result["text"].strip()
            
            # Kaydet
            with open(output_path, "w", encoding="utf-8") as out_f:
                out_f.write(text)
                
            print(f"[SUCCESS] Transkript başarıyla kaydedildi.")
            
            # Basit Etik Tarama (Konsol Bilgilendirmesi)
            check_text_for_issues(text, out_name)
            
        except Exception as e:
            print(f"[ERROR] Dosya işlenirken hata oluştu {mp3_file}: {e}")

# Basit Kelime Denetimi
def check_text_for_issues(text, filename):
    forbidden_words = ["alkol", "şarap", "bira", "sigara", "tütün", "uyuşturucu", "argo", "kaba", "rakı", "viski", "likör"]
    found = []
    text_lower = text.lower()
    
    for word in forbidden_words:
        if word in text_lower:
            found.append(word)
            
    if found:
        print(f"[ALERT] {filename} içinde uygunsuz olabilecek kelimeler saptandı: {found}")
    else:
        print(f"[OK] {filename} etik kelime taramasından başarıyla geçti.")

if __name__ == "__main__":
    main()
