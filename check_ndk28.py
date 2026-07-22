import os

sdk_dir = r"C:\Users\erolm\AppData\Local\Android\Sdk"
disabled_v28 = os.path.join(sdk_dir, "ndk_disabled", "28.2.13676358")
disabled_v28_bak = os.path.join(sdk_dir, "ndk_disabled", "28.2.13676358.bak")
target_v28 = os.path.join(sdk_dir, "ndk", "28.2.13676358")

# v28'i geri ndk/28.2.13676358 konumuna tasit
source = None
if os.path.exists(disabled_v28):
    source = disabled_v28
elif os.path.exists(disabled_v28_bak):
    source = disabled_v28_bak

if source:
    if os.path.exists(target_v28):
        import shutil
        shutil.rmtree(target_v28)
    os.rename(source, target_v28)
    print("NDK 28 geri tasindi:", target_v28)

# llvm-strip.exe var mi kontrol et
strip_exe = os.path.join(target_v28, "toolchains", "llvm", "prebuilt", "windows-x86_64", "bin", "llvm-strip.exe")
print("llvm-strip.exe var mi:", os.path.exists(strip_exe), strip_exe)
