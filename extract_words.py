import os
import re

def get_desktop_path():
    # Returns the absolute path to the user's Desktop
    return os.path.join(os.path.expanduser("~"), "Desktop")

def clean_and_extract_words(file_path):
    words = []
    # Read the file with utf-8 encoding
    with open(file_path, 'r', encoding='utf-8', errors='ignore') as f:
        content = f.read()
    
    # Use regex to find all Turkish/English word characters, numbers, and basic abbreviations
    # This captures both code tokens and string content
    raw_words = re.findall(r'[a-zA-Z0-9İıŞşÇçĞğÜüÖö\-]+', content)
    return raw_words

def main():
    lib_dir = r'c:\Users\erolm\Desktop\TurizmAkademi\lib'
    all_words = []
    
    # Traverse through all subdirectories in lib/
    for root, dirs, files in os.walk(lib_dir):
        for file in files:
            if file.endswith('.dart'):
                file_path = os.path.join(root, file)
                file_words = clean_and_extract_words(file_path)
                all_words.extend(file_words)
                
    # Define output path on Desktop
    desktop = get_desktop_path()
    output_file = os.path.join(desktop, "turizmdefterimnotlari.txt")
    
    # Write all words separated by a space
    with open(output_file, 'w', encoding='utf-8') as f:
        f.write(" ".join(all_words))
        
    print(f"Başarılı! Toplam {len(all_words)} kelime '{output_file}' dosyasına kaydedildi.")

if __name__ == '__main__':
    main()
