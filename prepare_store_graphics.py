import os
from PIL import Image, ImageDraw, ImageFont

def prepare_graphics():
    out_dir = os.path.join(os.getcwd(), "TurizmAkademi_Ciktilar")
    os.makedirs(out_dir, exist_ok=True)
    
    logo_path = os.path.join(os.getcwd(), "assets", "images", "app_logo.png")
    
    # 1. App Icon (512x512)
    icon_out = os.path.join(out_dir, "play_store_icon_512x512.png")
    if os.path.exists(logo_path):
        with Image.open(logo_path) as img:
            img_512 = img.convert("RGBA").resize((512, 512), Image.Resampling.LANCZOS)
            img_512.save(icon_out, "PNG")
            print(f"512x512 İkon oluşturuldu: {icon_out}")
            
    # 2. Feature Graphic (1024x500)
    feat_out = os.path.join(out_dir, "play_store_feature_graphic_1024x500.png")
    feat_img = Image.new("RGBA", (1024, 500), (3, 15, 38, 255)) # Dark navy #030F26
    
    # Create simple gradient background
    draw = ImageDraw.Draw(feat_img)
    for y in range(500):
        r = int(3 + (10 - 3) * (y / 500))
        g = int(15 + (25 - 15) * (y / 500))
        b = int(38 + (47 - 38) * (y / 500))
        draw.line([(0, y), (1024, y)], fill=(r, g, b, 255))
        
    # Overlay logo centered left
    if os.path.exists(logo_path):
        with Image.open(logo_path) as img:
            logo_resized = img.convert("RGBA").resize((320, 320), Image.Resampling.LANCZOS)
            feat_img.paste(logo_resized, (100, 90), logo_resized)
            
    # Draw title and subtitle text
    try:
        font_large = ImageFont.truetype("arial.ttf", 52)
        font_sub = ImageFont.truetype("arial.ttf", 26)
    except:
        font_large = ImageFont.load_default()
        font_sub = ImageFont.load_default()
        
    draw.text((460, 180), "TURİZM DEFTERİM", fill=(0, 240, 255, 255), font=font_large)
    draw.text((460, 255), "Mesleki Eğitim & Dijital Ders Platformu", fill=(255, 255, 255, 220), font=font_sub)
    draw.text((460, 300), "MEB Müfredatına Tam Uyumlu", fill=(255, 215, 0, 230), font=font_sub)
    
    feat_img.save(feat_out, "PNG")
    print(f"1024x500 Özellik Grafiği oluşturuldu: {feat_out}")

if __name__ == "__main__":
    prepare_graphics()
