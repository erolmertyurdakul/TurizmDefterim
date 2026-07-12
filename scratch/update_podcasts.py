import os
import re
import xml.etree.ElementTree as ET

# Path to the saved XML RSS feed
rss_path = r"C:\Users\erolm\.gemini\antigravity-ide\brain\3dd087a9-d8a4-4375-9e6f-49a561118816\browser\scratchpad_d7ojhen7.md"
data_dir = r"c:\Users\erolm\Desktop\TurizmAkademi\lib\core\data"

# Course prefix mappings based on the RSS title patterns
PREFIX_MAP = {
    "Tur Operasyonu": "Yeni12Turoperasyonu",
    "Transfer Operasyonu": "Yeni12Transfer",
    "Sosyal Medya": "Yeni12SosyalMedya",
    "Kuru Temizleme İşlemleri": "yeni12Kuru",
    "Kongre ve Etkinlik Turizmi": "Yeni12Kongre",
    "Gastronomi Turizmi": "Yeni12Gastronomi",
    "Dünya Kültürleri": "Yeni12Dünyakültür",
    "Dünya Seyahat ve Turizm Coğrafyası": "Yeni12Dünyasey",
    "Çamaşırhane İşlemleri": "Yeni12Çamaşır",
    "Alternatif Turizm": "yeni12Alternatif",
    "Sürdürülebilir Turizm": "yeni11sürdürülebilir",
    "Konaklama İşletmeciliği": "yeni11konaklama",
    "Kat Hizmetleri Atölyesi": {
        10: "yeni10kat",
        11: "yeni11kat"
    },
    "Kat Hizmetleri": "yeni11kat", # Fallback or alternate name
    "Ön Büroda Rezervasyon": "yeni10rez",
    "Konuk Giriş Çıkış İşlemleri": "yeni10konuk",
    "Mesleki Gelişim Atölyesi": "yeni9meslekigel",
    "Mesleki Gelişim": "yeni9meslekigel"
}

def clean_xml_file(path):
    with open(path, 'r', encoding='utf-8') as f:
        content = f.read()
    # Strip <?xml ...?> declaration which can cause parsing errors on string input
    content = re.sub(r'<\?xml.*?\?>', '', content)
    # Ensure it's valid XML by stripping anything before <rss
    match = re.search(r'(<rss.*?>.*)', content, re.DOTALL)
    if match:
        return match.group(1)
    return content

def main():
    print("Reading RSS feed...")
    try:
        xml_content = clean_xml_file(rss_path)
        root = ET.fromstring(xml_content)
    except Exception as e:
        print(f"Error reading/parsing RSS file: {e}")
        return

    items = root.findall('.//item')
    print(f"Parsed {len(items)} episodes from RSS feed.")

    # Build mapping from old filename to new Spotify CDN URL
    url_mapping = {}

    for idx, item in enumerate(items):
        title = item.find('title').text.strip()
        enclosure = item.find('enclosure')
        if enclosure is None:
            continue
        new_url = enclosure.get('url')
        
        # Regex to parse RSS title format:
        # e.g., "Tur Operasyonu 12. Sınıf - 6. Öğrenme Birimi - Erol Mert YURDAKUL"
        # e.g., "Kat Hizmetleri Atölyesi 11. Sınıf - 4. Öğrenme Birimi - Erol Mert YURDAKUL"
        match = re.match(r'^(.*?)\s+(\d+)\.\s+Sınıf\s+-\s+(\d+)\.\s+Öğrenme\s+Birimi', title)
        if not match:
            # Try alternate match if name has no grade or format is slightly different
            match = re.match(r'^(.*?)\s+-\s+(\d+)\.\s+Öğrenme\s+Birimi', title)
            if not match:
                print(f"Warning: Could not parse title format: '{title}'")
                continue
            course_name = match.group(1).strip()
            grade = 12 # Default grade fallback
            unit_num = int(match.group(2))
        else:
            course_name = match.group(1).strip()
            grade = int(match.group(2))
            unit_num = int(match.group(3))

        prefix = PREFIX_MAP.get(course_name)
        if isinstance(prefix, dict):
            prefix = prefix.get(grade, "")
        
        if not prefix:
            # Let's try matching part of the course name
            for k, v in PREFIX_MAP.items():
                if k in course_name or course_name in k:
                    if isinstance(v, dict):
                        prefix = v.get(grade, "")
                    else:
                        prefix = v
                    break
        
        if prefix:
            old_filename = f"{prefix}{unit_num}.mp3"
            url_mapping[old_filename.lower()] = new_url
            print(f"Mapped: '{title}'\n  -> Old filename: {old_filename}\n  -> New URL: {new_url[:90]}...")
        else:
            print(f"Warning: No prefix found for course '{course_name}' (Grade {grade}) in title '{title}'")

    print(f"\nCreated mapping for {len(url_mapping)} filenames.")

    # Scan and replace in Dart files
    replaced_count = 0
    file_count = 0
    
    for root_dir, dirs, files in os.walk(data_dir):
        for file in files:
            if file.endswith('.dart'):
                file_path = os.path.join(root_dir, file)
                with open(file_path, 'r', encoding='utf-8') as f:
                    file_content = f.read()

                modified = False
                
                # Find all podcastUrl occurrences in this file
                # Format: "podcastUrl": "https://erolmertyurdakul.github.io/turizmokulum-podcasts/yeni10rez1.mp3"
                urls = re.findall(r'"podcastUrl":\s*"https://erolmertyurdakul\.github\.io/turizmokulum-podcasts/([^"]+)"', file_content)
                for old_file in urls:
                    old_file_lower = old_file.lower()
                    if old_file_lower in url_mapping:
                        new_spotify_url = url_mapping[old_file_lower]
                        old_url_full = f"https://erolmertyurdakul.github.io/turizmokulum-podcasts/{old_file}"
                        file_content = file_content.replace(old_url_full, new_spotify_url)
                        replaced_count += 1
                        modified = True
                        print(f"Replacing in {file}: {old_file} -> Spotify URL")
                    else:
                        print(f"Warning: No Spotify URL mapping found for '{old_file}' in file {file}")

                if modified:
                    with open(file_path, 'w', encoding='utf-8') as f:
                        f.write(file_content)
                    file_count += 1

    print(f"\nSuccessfully replaced {replaced_count} podcast links in {file_count} Dart files!")

if __name__ == "__main__":
    main()
