import os
import sys

sys.stdout.reconfigure(encoding='utf-8')

search_roots = [
    r'C:\Users\erolm',
    r'C:\Erol_Mobil_Gelistirme',
    r'C:\Users\erolm\Desktop',
    r'C:\Users\erolm\Documents',
    r'C:\Users\erolm\Downloads',
    r'C:\Users\erolm\OneDrive'
]

keywords = ['defter', 'turizm', 'akademi', 'ders', 'not', 'kitap', 'meslek']

matches = set()

for root_path in search_roots:
    if os.path.exists(root_path):
        for dirpath, dirnames, filenames in os.walk(root_path):
            # Check directory names
            for d in dirnames:
                d_lower = d.lower()
                if any(k in d_lower for k in keywords):
                    full_p = os.path.join(dirpath, d)
                    matches.add(full_p)
            # Limit depth for performance
            depth = dirpath.count(os.sep) - root_path.count(os.sep)
            if depth > 4:
                dirnames.clear()

print(f"Total matching directories found: {len(matches)}")
for m in sorted(list(matches))[:40]:
    print(f" 📂 {m}")
