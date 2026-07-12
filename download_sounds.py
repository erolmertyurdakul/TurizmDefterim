import urllib.request
import os

sounds_dir = r"c:\Users\erolm\Desktop\TurizmAkademi\assets\sounds"

urls = {
    "bell.mp3": "https://s3.amazonaws.com/freecodecamp/simonSound1.mp3",
    "success.mp3": "https://s3.amazonaws.com/freecodecamp/simonSound2.mp3",
    "error.mp3": "https://s3.amazonaws.com/freecodecamp/simonSound3.mp3",
    "left.mp3": "https://s3.amazonaws.com/freecodecamp/simonSound4.mp3",
    "levelup.mp3": "https://actions.google.com/sounds/v1/alarms/digital_watch_alarm_long.ogg", # ogg fallback
    "gameover.mp3": "https://actions.google.com/sounds/v1/alarms/alarm_clock.ogg" # ogg fallback
}

# Let's try downloading MP3 versions of mixkit sounds which are universally supported
mixkit_urls = {
    "bell.mp3": "https://assets.mixkit.co/active_storage/sfx/911/911-84.wav",
    "success.mp3": "https://assets.mixkit.co/active_storage/sfx/1435/1435-84.wav",
    "error.mp3": "https://assets.mixkit.co/active_storage/sfx/2565/2565-84.wav",
    "left.mp3": "https://assets.mixkit.co/active_storage/sfx/950/950-84.wav",
    "levelup.mp3": "https://assets.mixkit.co/active_storage/sfx/2019/2019-84.wav",
    "gameover.mp3": "https://assets.mixkit.co/active_storage/sfx/2018/2018-84.wav"
}

headers = {'User-Agent': 'Mozilla/5.0'}

for name, url in mixkit_urls.items():
    dest_path = os.path.join(sounds_dir, name)
    print(f"Downloading {url} -> {dest_path}")
    try:
        req = urllib.request.Request(url, headers=headers)
        with urllib.request.urlopen(req) as response:
            with open(dest_path, 'wb') as out_file:
                out_file.write(response.read())
        print("Downloaded mixkit wav successfully")
    except Exception as e:
        print(f"Failed to download mixkit wav: {e}")
        # Try fallback
        fallback_url = urls[name]
        print(f"Trying fallback {fallback_url}...")
        try:
            req = urllib.request.Request(fallback_url, headers=headers)
            with urllib.request.urlopen(req) as response:
                with open(dest_path, 'wb') as out_file:
                    out_file.write(response.read())
            print("Downloaded fallback successfully")
        except Exception as fe:
            print(f"Failed fallback: {fe}")
