import shutil
import os

src_dir = r"C:\Users\erolm\.gemini\antigravity-ide\brain\ec6a3250-8d6f-449a-9f79-2b68d47f48ec"
dest_dir = r"c:\Users\erolm\Desktop\TurizmAkademi\assets\images"

mapping = {
    "bellboy_illustration_1781920595910.png": "bellboy.png",
    "receptionist_illustration_1781920611452.png": "receptionist.png",
    "reservation_illustration_1781924720686.png": "reservation.png",
    "meydanci_illustration_1781920641239.png": "meydanci.png",
    "maid_illustration_1781920655830.png": "maid.png",
    "laundry_illustration_1781924739014.png": "laundry.png"
}

for src_name, dest_name in mapping.items():
    src_path = os.path.join(src_dir, src_name)
    dest_path = os.path.join(dest_dir, dest_name)
    print(f"Copying {src_path} -> {dest_path}")
    try:
        shutil.copy2(src_path, dest_path)
        print("Success")
    except Exception as e:
        print(f"Failed: {e}")
