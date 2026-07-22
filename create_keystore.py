import os
import sys
import subprocess
import shutil

print("==========================================================")
print("     TURİZM DEFTERİM - KEYSTORE ÜRETİM ARACI")
print("==========================================================")

# Keystore hedef yolu
script_dir = os.path.dirname(os.path.abspath(__file__))
target_keystore = os.path.join(script_dir, "android", "app", "upload-keystore.jks")

# Olasi keytool konumlarini ara
possible_paths = [
    shutil.which("keytool"),
    r"C:\Program Files\Android\Android Studio\jbr\bin\keytool.exe",
    r"C:\Program Files\Android\Android Studio\jre\bin\keytool.exe",
    r"C:\Program Files\Java\jdk-17\bin\keytool.exe",
    r"C:\Program Files\Java\jdk1.8.0_\bin\keytool.exe",
]

# JAVA_HOME icini de kontrol et
java_home = os.environ.get("JAVA_HOME")
if java_home:
    possible_paths.insert(0, os.path.join(java_home, "bin", "keytool.exe"))

# Android Studio jbr/jre diger versiyonlari
android_studio_dir = r"C:\Program Files\Android\Android Studio"
if os.path.exists(android_studio_dir):
    for root, dirs, files in os.walk(android_studio_dir):
        if "keytool.exe" in files:
            possible_paths.insert(0, os.path.join(root, "keytool.exe"))

keytool_path = None
for path in possible_paths:
    if path and os.path.exists(path):
        keytool_path = path
        break

if not keytool_path:
    print("\n[HATA] keytool.exe sistemi üzerinde bulunamadi!")
    print("Lütfen Android Studio veya Java JDK'nın yüklü olduğundan emin olun.")
    input("\nKapatmak için Enter'a basın...")
    sys.exit(1)

print(f"\n[BİLGİ] Kullanılacak Keytool Konumu:\n  -> {keytool_path}")
print(f"\n[BİLGİ] Keystore Hedef Konumu:\n  -> {target_keystore}")

cmd = [
    keytool_path,
    "-genkeypair",
    "-v",
    "-keystore", target_keystore,
    "-storetype", "JKS",
    "-keyalg", "RSA",
    "-keysize", "2048",
    "-validity", "10000",
    "-alias", "upload",
    "-storepass", "TurizmDefterim2026!",
    "-keypass", "TurizmDefterim2026!",
    "-dname", "CN=Erol Mert Yurdakul, OU=Turizm Defterim, O=Turizm Defterim, L=Ankara, ST=Ankara, C=TR"
]

try:
    result = subprocess.run(cmd, capture_output=True, text=True, check=True)
    print("\n==========================================================")
    print("  ✅ BAŞARILI! Keystore sertifikanız başarıyla oluşturuldu:")
    print(f"  {target_keystore}")
    print("==========================================================")
except subprocess.CalledProcessError as e:
    print("\n[HATA] Keystore oluşturulurken bir hata meydana geldi:")
    print(e.stderr or e.stdout)

input("\nKapatmak için Enter'a basın...")
