import os
from PIL import Image

def resize_image(input_path, output_path, size):
    try:
        with Image.open(input_path) as img:
            img_resized = img.resize(size, Image.Resampling.LANCZOS)
            img_resized.save(output_path, "PNG")
            print(f"Başarılı: {output_path} ({size[0]}x{size[1]}) oluşturuldu.")
    except Exception as e:
        print(f"Hata ({output_path}): {e}")

def main():
    logo_path = os.path.join("assets", "images", "app_logo.png")
    web_icons_dir = os.path.join("web", "icons")
    
    if not os.path.exists(logo_path):
        print(f"Logo bulunamadı: {logo_path}")
        return
        
    os.makedirs(web_icons_dir, exist_ok=True)
    
    # 192x192
    resize_image(logo_path, os.path.join(web_icons_dir, "Icon-192.png"), (192, 192))
    resize_image(logo_path, os.path.join(web_icons_dir, "Icon-maskable-192.png"), (192, 192))
    
    # 512x512
    resize_image(logo_path, os.path.join(web_icons_dir, "Icon-512.png"), (512, 512))
    resize_image(logo_path, os.path.join(web_icons_dir, "Icon-maskable-512.png"), (512, 512))

if __name__ == "__main__":
    main()
