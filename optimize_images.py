import os
from PIL import Image

def optimize_image(file_path):
    try:
        size_before = os.path.getsize(file_path) / (1024 * 1024) # MB
        is_logo = "app_logo.png" in file_path.lower()
        
        with Image.open(file_path) as img:
            original_format = img.format
            width, height = img.size
            
            # Kaliteyi korumak için görselleri maksimum 1024 piksele sınırlıyoruz
            max_dimension = 1024
            if width > max_dimension or height > max_dimension:
                img.thumbnail((max_dimension, max_dimension), Image.Resampling.LANCZOS)
                
            # Dosya uzantısına göre kaydetme formatını kesin olarak belirle
            if file_path.lower().endswith('.png'):
                save_format = 'PNG'
                # Şeffaflığı koruyarak 8-bit paletli PNG formatına dönüştür (boyutu devasa düşürür)
                img_final = img.convert('P', palette=Image.Palette.ADAPTIVE, colors=256)
            elif file_path.lower().endswith(('.jpg', '.jpeg')):
                save_format = 'JPEG'
                img_final = img.convert('RGB')
            else:
                save_format = original_format or 'PNG'
                img_final = img
                
            # Resmi optimize ederek üzerine yaz, metadata bilgilerini at
            img_final.save(file_path, format=save_format, optimize=True)
            
        size_after = os.path.getsize(file_path) / (1024 * 1024) # MB
        print(f"Süper Optimize: {os.path.basename(file_path)} | Önce: {size_before:.2f} MB -> Sonra: {size_after:.2f} MB")
    except Exception as e:
        print(f"Hata ({file_path}): {e}")

def main():
    images_dir = os.path.join("assets", "images")
    if not os.path.exists(images_dir):
        print(f"Görsel dizini bulunamadı: {images_dir}")
        return
        
    print("Görseller optimize ediliyor, bu işlem biraz zaman alabilir...")
    
    # Klasördeki tüm resimleri tara
    for filename in os.listdir(images_dir):
        if filename.lower().endswith(('.png', '.jpg', '.jpeg')):
            file_path = os.path.join(images_dir, filename)
            optimize_image(file_path)
            
    print("\nTüm optimizasyon işlemleri tamamlandı!")

if __name__ == "__main__":
    main()
