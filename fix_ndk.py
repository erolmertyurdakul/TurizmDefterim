import os
import shutil

sdk_dir = r"C:\Users\erolm\AppData\Local\Android\Sdk"
ndk_dir = os.path.join(sdk_dir, "ndk")
disabled_dir = os.path.join(sdk_dir, "ndk_disabled")

os.makedirs(disabled_dir, exist_ok=True)

# 28.2 klasorunu ndk_disabled icine tasi
v28_path = os.path.join(ndk_dir, "28.2.13676358")
v28_bak = os.path.join(ndk_dir, "28.2.13676358.bak")

for p in [v28_path, v28_bak]:
    if os.path.exists(p):
        target = os.path.join(disabled_dir, os.path.basename(p))
        if os.path.exists(target):
            shutil.rmtree(target, ignore_errors=True)
        shutil.move(p, target)
        print(f"{p} -> {target} konumuna tasindi.")

print("NDK 28 tamamen pasife alindi.")
