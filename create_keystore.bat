@echo off
title Turizm Defterim - Keystore Olusturucu
cd /d "%~dp0"
python create_keystore.py
if %ERRORLEVEL% NEQ 0 (
    echo Python bulunamadi, varsayilan keytool deneniyor...
    keytool -genkeypair -v -keystore "%~dp0android\app\upload-keystore.jks" -storetype JKS -keyalg RSA -keysize 2048 -validity 10000 -alias upload -storepass TurizmDefterim2026! -keypass TurizmDefterim2026! -dname "CN=Erol Mert Yurdakul, OU=Turizm Defterim, O=Turizm Defterim, L=Ankara, ST=Ankara, C=TR"
    if %ERRORLEVEL% EQU 0 (
        echo.
        echo Keystore basariyla olusturuldu!
    ) else (
        echo.
        echo [HATA] keytool komutu calistirilamadi. Lutfen Android Studio veya Java JDK yolunun yuklu oldugunu kontrol edin.
    )
    pause
)
