import os
import urllib.request

def download_file(url, dest_path):
    print(f"Downloading {url} to {dest_path}...")
    try:
        # User-Agent header to prevent 403 Forbidden from some CDNs
        req = urllib.request.Request(
            url, 
            headers={'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64)'}
        )
        with urllib.request.urlopen(req) as response, open(dest_path, 'wb') as out_file:
            out_file.write(response.read())
        print("Success!")
    except Exception as e:
        print(f"Error downloading {url}: {e}")

def main():
    fonts_dir = os.path.join("assets", "google_fonts")
    if not os.path.exists(fonts_dir):
        os.makedirs(fonts_dir)
        print(f"Created directory: {fonts_dir}")
        
    outfit_weights = ["Regular", "Medium", "SemiBold", "Bold", "ExtraBold"]
    inter_weights = ["Regular", "Medium", "SemiBold", "Bold", "ExtraBold"]
    
    # Download Outfit fonts from official GitHub repo
    for weight in outfit_weights:
        url = f"https://raw.githubusercontent.com/Outfitio/Outfit-Fonts/master/fonts/ttf/Outfit-{weight}.ttf"
        dest = os.path.join(fonts_dir, f"Outfit-{weight}.ttf")
        download_file(url, dest)
        
    # Download Inter fonts from google/fonts GitHub repo
    for weight in inter_weights:
        url = f"https://raw.githubusercontent.com/google/fonts/main/ofl/inter/static/Inter-{weight}.ttf"
        dest = os.path.join(fonts_dir, f"Inter-{weight}.ttf")
        download_file(url, dest)

if __name__ == "__main__":
    main()
