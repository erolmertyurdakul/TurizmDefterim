@echo off
title Turizm Defterim - Release App Bundle ve APK Derleme
cd /d "%~dp0"
echo Setting ANDROID_NDK_HOME...
set "ANDROID_NDK_HOME=C:\Users\erolm\AppData\Local\Android\Sdk\ndk\28.2.13676358"
set "PATH=C:\Users\erolm\AppData\Local\Android\Sdk\ndk\28.2.13676358\toolchains\llvm\prebuilt\windows-x86_64\bin;%PATH%"

echo.
echo Starting Flutter Release App Bundle build...
echo.
call flutter build appbundle --release

echo.
echo Starting Flutter Release APK build...
echo.
call flutter build apk --release

echo.
if errorlevel 1 (
    echo [HATA] Derleme sirasinda bir hata olustu.
) else (
    echo ==========================================================
    echo  BASARILI! Paketler olusturuldu.
    echo  Dosyalar ana dizindeki "TurizmAkademi_Ciktilar" klasorune kopyalaniyor...
    echo ==========================================================
    mkdir "TurizmAkademi_Ciktilar" 2>nul
    copy /Y "build\app\outputs\bundle\release\app-release.aab" "TurizmAkademi_Ciktilar\TurizmAkademi.aab"
    copy /Y "build\app\outputs\flutter-apk\app-release.apk" "TurizmAkademi_Ciktilar\TurizmAkademi.apk"
    echo.
    echo Kopyalama tamamlandi! "TurizmAkademi_Ciktilar" klasorunu kontrol edin.
)
echo.
pause
