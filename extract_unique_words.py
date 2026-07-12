import os
import re

def get_desktop_path():
    return os.path.join(os.path.expanduser("~"), "Desktop")

def get_words_from_file(file_path):
    with open(file_path, 'r', encoding='utf-8', errors='ignore') as f:
        content = f.read()
    
    # Extract only Turkish and English alphabetical words (removing punctuation, numbers, and symbols)
    words = re.findall(r'[a-zA-ZİıŞşÇçĞğÜüÖö\-]+', content)
    return [w.lower() for w in words]

def main():
    lib_dir = r'c:\Users\erolm\Desktop\TurizmAkademi\lib'
    unique_words = set()
    
    for root, dirs, files in os.walk(lib_dir):
        for file in files:
            if file.endswith('.dart'):
                file_path = os.path.join(root, file)
                words = get_words_from_file(file_path)
                unique_words.update(words)
                
    # Sort alphabetically
    sorted_words = sorted(list(unique_words))
    
    desktop = get_desktop_path()
    output_file = os.path.join(desktop, "benzersiz_turizm_kelimeleri.txt")
    
    with open(output_file, 'w', encoding='utf-8') as f:
        f.write("\n".join(sorted_words))
        
    print(f"Başarılı! Toplam {len(sorted_words)} benzersiz kelime '{output_file}' dosyasına yazıldı.")

if __name__ == '__main__':
    main()
