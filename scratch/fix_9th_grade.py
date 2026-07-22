import re
import sys

sys.stdout.reconfigure(encoding='utf-8')

desktop_file = r'C:\Users\erolm\Desktop\eklenenler ve çıkarılanlar bugün.txt'
dart_file = r'lib/core/data/courses/9_mesleki_gelisim_notes.dart'

with open(dart_file, 'r', encoding='utf-8') as f:
    content = f.read()

changes = [
    {
        "unit": "1. Öğrenme Birimi (Meslek Etiği ve Ahilik)",
        "removed": "Fütüvvetname",
        "added": "Ahilik Nasihati",
        "reason": "MEB 9. Sınıf Mesleki Gelişim Atölyesi kitabında 1.2 başlığı altında Ahilik Nasihati vurgulanmaktadır.",
        "old_str": '''        {
          "name": "Fütüvvetname",
          "desc": "Ahilerin uyması gereken ahlaki kuralları, görgü kurallarını ve teşkilat disiplinini yazılı olarak belirleyen kılavuz kitaplardır. Esnafın ticari ve sosyal yaşam anayasasıdır.",
          "examples": [
            "Örnekle Pekiştirelim: Fütüvvetnamede yer alan 'Yalan söylememek, cömert olmak, misafirperver olmak ve kimsenin kusurunu aramamak' kuralları, esnafın günlük ticari ahlakını şekillendirirdi."
          ]
        }''',
        "new_str": '''        {
          "name": "Ahilik Nasihati",
          "desc": "Ahi Evran ve ahi büyükleri tarafından belirlenen; dürüstlük, cömertlik, alçakgönüllülük ve misafirperverliği esnafın hayat felsefesi kılan tarihi ahlak ilkeleridir.",
          "examples": [
            "Örnekle Pekiştirelim: Ahilik Nasihatinde yer alan 'Harama bakma, haram yeme, haram içme; doğru, dürüst ve sabırlı ol' ilkeleri, esnafın ticari ahlakını oluşturan en temel rehberdir."
          ]
        }'''
    },
    {
        "unit": "4. Öğrenme Birimi (Çevre Koruma)",
        "removed": "Mavi Bayrak (Blue Flag)",
        "added": "Ekolojik Okuryazarlık",
        "reason": "Mavi Bayrak 11. Sınıf Sürdürülebilir Turizm dersi kapsamındadır. 9. Sınıf kitabında Ekolojik Okuryazarlık kavramı yer almaktadır.",
        "old_str": '''        {
          "name": "Mavi Bayrak (Blue Flag)",
          "desc": "Plaj, marina ve yatlarda su kalitesi, çevre yönetimi, çevre eğitimi ve güvenlik kriterlerinin eksiksiz sağlandığını gösteren uluslararası çevre ödülüdür.",
          "examples": [
            "Örnekle Pekiştirelim: Antalya'daki bir otel plajının deniz suyu temizliği ve cankurtaran imkanları sayesinde Mavi Bayrak ödülü alarak turistlerin güvenini kazanmasıdır."
          ]
        }''',
        "new_str": '''        {
          "name": "Ekolojik Okuryazarlık",
          "desc": "Doğal ekosistemlerin çalışma ilkelerini anlamak, doğanın dengesini korumak ve çevreyle uyumlu yaşam alışkanlıkları geliştirmektir.",
          "examples": [
            "Örnekle Pekiştirelim: Bir öğrencinin su ve enerji tasarrufu yaparak, doğaya zarar vermeyen geri dönüştürülebilir ürünleri tercih etmesi ekolojik okuryazarlık örneğidir."
          ]
        }'''
    },
    {
        "unit": "5. Öğrenme Birimi (Girişimci Fikirler)",
        "removed": "Fizibilite (Yapılabilirlik) Etüdü",
        "added": "Yenilikçi İş Fikri",
        "reason": "MEB 9. Sınıf kitabında 5.1 başlığında İş Fikri Geliştirme vurgulanmaktadır. Fizibilite detayları üst sınıflara aittir.",
        "old_str": '''        {
          "name": "Fizibilite (Yapılabilirlik) Etüdü",
          "desc": "Yatırım kararı vermeden önce, kurmak istenen işin teknik, ekonomik ve yasal olarak ne kadar kârlı ve uygulanabilir olduğunu araştıran rapordur.",
          "examples": [
            "Örnekle Pekiştirelim: Bodrum'da bir restoran açmadan önce, bölgedeki turist yoğunluğunu, rakiplerin fiyatlarını ve dükkan kiralarını analiz ederek restoranın kârlı olup olmayacağını hesaplamaktır."
          ]
        }''',
        "new_str": '''        {
          "name": "Yenilikçi İş Fikri",
          "desc": "Pazardaki bir ihtiyacı fark edip bu ihtiyaca yönelik özgün, faydalı ve değer yaratan yeni bir ticari çözüm sunmaktır.",
          "examples": [
            "Örnekle Pekiştirelim: Turistlerin bavullarını güvenle bırakabilecekleri mobil bir bagaj taşıma hizmeti fikri geliştirmek yenilikçi bir iş fikridir."
          ]
        }'''
    },
    {
        "unit": "6. Öğrenme Birimi (Fikri ve Sınai Mülkiyet Hakları)",
        "removed": "Lisanslama ve Devir",
        "added": "Fikri Hak İhlalleri ve Korunma",
        "reason": "MEB 9. Sınıf kitabında tescil sonrası hak ihlallerine karşı yasal korunma yolları anlatılmaktadır.",
        "old_str": '''        {
          "name": "Lisanslama ve Devir",
          "desc": "Eser veya sınai hak sahibinin, belirli bir ücret karşılığında kullanım hakkını bir başkasına yasal sözleşmeyle (lisans) vermesi veya hakkı tamamen satması (devir) işlemidir.",
          "examples": [
            "Örnekle Pekiştirelim: Ünlü bir otel zincirinin, isim hakkını (franchise) yerel bir yatırımcıya yıllık belirli bir ücret karşılığında lisans sözleşmesiyle devredip otel açtırmasıdır."
          ]
        }''',
        "new_str": '''        {
          "name": "Fikri Hak İhlalleri ve Korunma",
          "desc": "İzinsiz kullanım, taklit veya kopyalama durumunda hak sahibinin kanuni yollardan haklarını savunması ve eserini korumasıdır.",
          "examples": [
            "Örnekle Pekiştirelim: Özgün bir yazılım veya ders notunun izinsiz kopyalanması durumunda yasal mercilere başvurarak içeriğin kaldırılmasını talep etmektir."
          ]
        }'''
    }
]

# Apply changes to Dart file and log to Desktop
with open(desktop_file, 'a', encoding='utf-8') as df:
    df.write("\n==================================================\n")
    df.write("DERS: 9. Sınıf Mesleki Gelişim Atölyesi\n")
    df.write("==================================================\n")

for c in changes:
    if c['old_str'] in content:
        content = content.replace(c['old_str'], c['new_str'])
        with open(desktop_file, 'a', encoding='utf-8') as df:
            df.write(f"\n[ÖĞRENME BİRİMİ: {c['unit']}]\n")
            df.write(f"  - ÇIKARILAN: {c['removed']}\n")
            df.write(f"  + EKLENEN: {c['added']}\n")
            df.write(f"  > GEREKÇE: {c['reason']}\n")
    else:
        print(f"Warning: Old string for {c['removed']} not found exactly in file.")

with open(dart_file, 'w', encoding='utf-8') as f:
    f.write(content)

print("9th Grade updates complete!")
