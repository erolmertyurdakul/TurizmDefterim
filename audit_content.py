import os
import re

def get_desktop_path():
    return os.path.join(os.path.expanduser("~"), "Desktop")

# Clean word function
def clean_word(word):
    return word.lower().strip()

def scan_files():
    data_dir = r'c:\Users\erolm\Desktop\TurizmAkademi\lib\core\data'
    unique_words = set()
    
    for root, dirs, files in os.walk(data_dir):
        for file in files:
            if file.endswith('.dart') and file != 'scan_data.py':
                file_path = os.path.join(root, file)
                with open(file_path, 'r', encoding='utf-8', errors='ignore') as f:
                    content = f.read()
                # Extract words containing only letters and hyphens
                words = re.findall(r'[a-zA-ZİıŞşÇçĞğÜüÖö\-]+', content)
                for w in words:
                    unique_words.add(clean_word(w))
    return sorted(list(unique_words))

def audit_words(words):
    risk_report = []
    
    # 1. Swear Words / Slang / Vulgarity
    profanity_roots = [
        'amk', 'amq', 'aq', 'mk', 'sg', 'oc', 'pic', 'piç', 'pust', 'puşt', 'ibne', 
        'yavsak', 'yavşak', 'orospu', 'kahpe', 'siktir', 'siker', 'sikik', 'amcik', 'amcık', 
        'yarak', 'yaram', 'yarrak', 'fuck', 'bitch', 'shit', 'asshole', 'cunt', 'dick', 
        'pussy', 'slut', 'whore', 'bastard', 'dumbass', 'pezevenk', 'gavat', 'fahişe', 'fahise',
        'lan', 'ulan', 'bok', 'sidik', 'kaka', 'gerizekali', 'gerizekalı', 'salak', 'manyak',
        'embesil', 'hıyar', 'hiyar', 'enayi', 'keriz', 'göt', 'got'
    ]
    
    # 2. Alcohol / Tobacco / Drugs
    substance_roots = [
        'alkol', 'bira', 'sarap', 'şarap', 'raki', 'rakı', 'viski', 'votka', 'likor', 'likör', 
        'sampanya', 'şampanya', 'icki', 'içki', 'sarhos', 'sarhoş', 'pub', 'meyhane', 'barmen', 
        'barmaid', 'kokteyl', 'sigara', 'tutun', 'tütün', 'puro', 'pipo', 'nargile', 'izmarit',
        'uyusturucu', 'uyuşturucu', 'esrar', 'kokain', 'eroin', 'hap'
    ]
    
    # 3. Nudity / Sexual
    sexual_roots = [
        'ciplak', 'çıplak', 'seks', 'cinsel', 'fuhus', 'fuhuş', 'müstehcen', 'müstehcenlik', 
        'porno', 'göğüs', 'gogus', 'kalça', 'kalca', 'dudak', 'meme'
    ]
    
    # 4. Violence / Gambling
    violence_gambling = [
        'kumar', 'bahis', 'silah', 'bıçak', 'bicak', 'tabanca', 'tüfek', 'tufek', 'bomba',
        'katil', 'cinayet', 'olum', 'ölüm', 'yarala', 'kavga', 'saldırı', 'saldiri'
    ]
    
    # 5. Ethnic/National Sensitivity
    sensitive_nations = [
        'gavur', 'ermeni', 'yahud', 'suriye', 'kürt', 'kurt', 'arap', 'yunan'
    ]

    # False Positive Filters (words that contain the roots but are perfectly fine)
    safe_words = {
        # 'got' / 'göt' / 'oc' / 'gotur' / 'ogret' / 'dogru'
        'goturmek', 'götürmek', 'götür', 'götürün', 'götürür', 'görüş', 'gorus', 'görev', 'gorev',
        'doğru', 'dogru', 'oğul', 'ogul', 'koç', 'koc', 'hoca', 'hocam', 'lokum',
        # 'mal' triggers
        'malzeme', 'malzemeler', 'malzemeleri', 'malzemelerin', 'malzemenin', 'malzemesi', 
        'maliyet', 'maliyeti', 'maliyetleri', 'maliyetlerin', 'maliyetinin', 'maliyetiyle',
        'imalat', 'imalatı', 'imalatında', 'imalathane', 'imalatçı', 'teslimat', 'teslimatı',
        'malatya', 'makine', 'makinesi', 'makineleri', 'makinelerin', 'duman', 'dumanı', 'dumanın',
        # 'bar' triggers
        'itibar', 'itibarı', 'itibarın', 'itibarıyken', 'itibarını', 'itibariyle', 'itibariyle',
        'barbar', 'bardak', 'bardağı', 'bardağın', 'bardaklar', 'baret', 'bareti', 'baretler',
        'bariyer', 'bariyerler', 'barındırmak', 'barındırır', 'barındıran', 'barındırdığı',
        'başarı', 'basari', 'başarılar', 'başarılı', 'başarılar', 'beraber', 'beraberinde',
        'ihbar', 'ihbarı', 'ihbarı', 'kibar', 'kibarca', 'minibar', 'minibarı', 'minibarın',
        'muhabir', 'rehber', 'rehberi', 'rehberlik', 'rehberin', 'rehberler', 'rehberliği',
        'ruhsat', 'ruhsatı', 'abartılı', 'abartı', 'bardan', 'barları', 'barların', 'barlarda', 
        'barda', 'barlar', 'barmenler',
        # 'kurt' triggers
        'kurtarmak', 'kurtarma', 'kurtarılması', 'kurtarır', 'kurtarıcı', 'kurtulmak', 'kurtulur',
        # 'meme' triggers
        'memnun', 'memnuniyet', 'memnuniyeti', 'memnuniyetini', 'memnuniyetsiz', 'memur', 'memuru',
        # 'arap' triggers
        'arapça', 'araplar', 'arapların',
        # 'yunan' triggers
        'yunanistan', 'yunanistan-ı', 'yunanistan\'da', 'yunanistan\'ın',
        # 'hap' triggers
        'sahip', 'sahipliği', 'sahiptir', 'sahipleri', 'sahipolduğu', 'sahipolma', 'kapak', 'kapat',
        'kapatılması', 'kapatmak', 'kapatılır', 'kapatarak', 'ahşap', 'ahsap', 'kitap', 'kitapçık',
        # 'tutun' / 'tütün' triggers
        'tutunma', 'tutunmak', 'tutunarak', 'tutunması', 'tutunma'
    }

    for w in words:
        if w in safe_words:
            continue
            
        # Match checks
        matched = False
        
        # Check profanity
        for r in profanity_roots:
            if r in w:
                risk_report.append((w, 'Profanity/Slang', r))
                matched = True
                break
        if matched: continue
        
        # Check substances
        for r in substance_roots:
            if r in w:
                risk_report.append((w, 'Substance (Alcohol/Tobacco/Drug)', r))
                matched = True
                break
        if matched: continue
        
        # Check sexual
        for r in sexual_roots:
            if r in w:
                risk_report.append((w, 'Nudity/Sexual', r))
                matched = True
                break
        if matched: continue
        
        # Check violence/gambling
        for r in violence_gambling:
            if r in w:
                risk_report.append((w, 'Violence/Gambling', r))
                matched = True
                break
        if matched: continue
        
        # Check sensitive nations
        for r in sensitive_nations:
            if r in w:
                risk_report.append((w, 'Sensitive Nation/Religion', r))
                matched = True
                break

    return risk_report

def main():
    words = scan_files()
    report = audit_words(words)
    
    desktop = get_desktop_path()
    output_file = os.path.join(desktop, "potansiyel_riskli_kelimeler.txt")
    
    with open(output_file, 'w', encoding='utf-8') as f:
        f.write(f"KELİME DENETİM RAPORU\n")
        f.write(f"Bulunan Potansiyel Riskli Kelime Sayısı: {len(report)} / Toplam Benzersiz Kelime: {len(words)}\n")
        f.write("="*60 + "\n\n")
        
        for w, cat, root in report:
            f.write(f"Kelime: {w:<25} | Kategori: {cat:<32} | Eşleşen Kök: {root}\n")
            
    print(f"Denetim tamamlandı! Potansiyel risk taşıyan {len(report)} kelime '{output_file}' dosyasına yazıldı.")

if __name__ == '__main__':
    main()
