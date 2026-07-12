import shutil
import os

source = r"C:\Users\erolm\.gemini\antigravity-ide\brain\a2dad817-11db-44d6-814a-5585138cf415\media__1783792849501.png"
dest_dir = r"c:\Users\erolm\Desktop\TurizmAkademi\assets\images"
dest = os.path.join(dest_dir, "hotel_profile.png")

try:
    os.makedirs(dest_dir, exist_ok=True)
    shutil.copy2(source, dest)
    print("KOPYALAMA BASARILI!")
except Exception as e:
    print(f"HATA: {e}")
