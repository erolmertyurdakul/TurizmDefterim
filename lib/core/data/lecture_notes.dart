/// 10. Sınıf Ön Büroda Rezervasyon Dersi Ders Notları Veri Tabanı
import 'courses/12_alternatif_turizm_notes.dart';
import 'courses/12_kuru_temizleme_notes.dart';
import 'courses/12_camasirhane_notes.dart';
import 'courses/12_dunya_cografyasi_notes.dart';
import 'courses/12_dunya_kulturleri_notes.dart';
import 'courses/12_kongre_etkinlik_notes.dart';
import 'courses/12_gastronomi_turizmi_notes.dart';
import 'courses/12_tur_operasyonu_notes.dart';
import 'courses/12_transfer_operasyonu_notes.dart';
import 'courses/12_sosyal_medya_notes.dart';
import 'courses/11_konaklama_isletmeciligi_notes.dart';
import 'courses/11_surdurulebilir_turizm_notes.dart';
import 'courses/11_kat_hizmetleri_notes.dart';
import 'courses/11_on_buro_hizmetleri_notes.dart';
import 'courses/10_konuk_giris_cikis_notes.dart';
import 'courses/10_kat_hizmetleri_notes.dart';
import 'courses/9_mesleki_gelisim_notes.dart';
import 'courses/9_genel_turizm_notes.dart';
import 'courses/9_otelcilik_notes.dart';



// 1. Öğrenme Birimi Notları
const Map<String, dynamic> unit1Notes = {
  "title": "Rezervasyon Alma",
  "learningUnit": "1. Öğrenme Birimi",
  "podcastUrl": "https://anchor.fm/s/114a64400/podcast/play/122579401/https%3A%2F%2Fd3ctxlq1ktw2nl.cloudfront.net%2Fstaging%2F2026-6-8%2Fbaf9a997-e8f7-baee-9816-0fb70ef81bd3.mp3",
  "cards": [
    {
      "id": 1,
      "tag": "ODA TİPLERİ",
      "title": "FİZİKİ YAPILARINA VE ÖZELLİKLERİNE GÖRE ODA TİPLERİ",
      "microSummary": "Otellerde odalar sadece dört duvardan ibaret değildir; konuk profilinin bütçesine, konfor arayışına ve aile yapısına göre özel olarak tasarlanır.",
      "definitions": [
        {
          "name": "Süit Oda (Suite Room)",
          "desc": "Bir salon veya oturma odasına bağlanan bir veya daha fazla yatak odasına sahip, geniş ve lüks odalardır. VIP konuklar tercih eder, ücreti yüksektir.",
          "examples": [
            "Örnekle Pekiştirelim: VIP bir konuk, geniş bir oturma odası ve buna iç kapıyla bağlanan büyük bir yatak odası bulunan 702 nolu süit odada konaklamıştır. Oturma salonu ile yatak odasının kapıyla tamamen ayrılmış olması süit odanın ayırt edici özelliğidir."
          ]
        },
        {
          "name": "Mini Süit Oda (Junior Suite Room)",
          "desc": "Oturma bölümü ile yatak bölümünün bir paravan ile ayrıldığı odalardır. Standart odalardan daha geniştir.",
          "examples": [
            "Örnekle Pekiştirelim: Genç bir çift, yatak bölümü ile oturma alanının şık bir ahşap paravanla bölündüğü geniş bir odada konaklamıştır. Ayrı bir salonu olmayan, tek mekanda paravanla ayrılan bu düzen mini süit odanın temel özelliğidir."
          ]
        },
        {
          "name": "Köşe Süit Oda (Corner Suite Room)",
          "desc": "Koridor sonunda bulunan, iki ya da üç cepheli, salon ve yatak odasından oluşan geniş odalardır.",
          "examples": [
            "Örnekle Pekiştirelim: Bir yazar, koridorun en ucunda yer alan, hem orman hem deniz manzarasını gören iki cepheli köşe süit odada kalmıştır. Binanın köşe konumunda iki farklı cepheye ve manzaraya sahip olması bu oda tipinin özelliğidir."
          ]
        },
        {
          "name": "Kral Dairesi (Presidential Suite Room)",
          "desc": "Salon, bir veya birkaç yatak odası, banyo, yemek odası, mutfak ve servis/içecek üniteleri bulunan, ekstra lüks döşenmiş tam bir dairedir.",
          "examples": [
            "Örnekle Pekiştirelim: Örnekle Pekiştirelim: Ülke liderinin ziyareti öncesi, içinde özel toplantı masası, içecek ünitesi, mini mutfağı ve jakuzisi olan en üst kattaki kral dairesi rezerve edilmiştir."
          ]
        },
        {
          "name": "Bitişik Oda (Adjoining Room)",
          "desc": "Aynı koridorda yan yana yer alan, birbirine komşu ama içeriden kapısı olmayan odalardır. Aynı gruptaki konuklar için tercih edilir.",
          "examples": [
            "Örnekle Pekiştirelim: Aynı şirkette çalışan iki mühendis, koridorda yan yana bulunan 204 ve 205 nolu odalarda kalmıştır. Bu odalar yan yanadır ancak aralarında içeriden geçiş kapısı yoktur; bitişik oda tam olarak bu kapısız yan yana yapıyı ifade eder."
          ]
        },
        {
          "name": "Bağlantılı Oda (Connecting Room)",
          "desc": "Yan yana iki ya da daha fazla odanın içeriden bir kapı ile birbirine bağlandığı, koridora çıkmadan geçiş sağlayan odalardır. Genellikle çocuklu aileler tercih eder.",
          "examples": [
            "Örnekle Pekiştirelim: Anne ve baba 101 nolu odada, çocukları ise yanlarındaki 102 nolu odada kalmıştır. Aile koridora hiç çıkmadan odaların arasındaki iç kapıdan birbirlerinin odasına geçebilmektedir; bağlantılı odanın farkı bu iç kapıdır."
          ]
        },
        {
          "name": "Ağırlama Odası (Hospitality Suite Room)",
          "desc": "Toplantı, düğün ve davet salonlarıyla bağlantısı olan, bu etkinliklere gelen konukların dinlenmesi amacıyla kullanılan odalardır.",
          "examples": [
            "Örnekle Pekiştirelim: Oteldeki düğün sırasında yorulan gelinin dinlenmesi ve makyaj tazelemesi için balo salonunun yanındaki oda tahsis edilmiştir. Etkinlik sahiplerinin kısa süreli kullanımı için ayrılan bu alan ağırlama odasının işlevidir."
          ]
        },
        {
          "name": "Stüdyo Oda (Studio Room)",
          "desc": "Kullanılmadığı zamanlarda yatağın katlanarak kanepeye dönüştüğü, oturma odası olarak da kullanılabilen odalardır.",
          "examples": [
            "Örnekle Pekiştirelim: Tek bir öğrenci, gündüz oturma odası gibi duran, gece ise koltuğun altından yatak çekilerek yatak odasına dönüştürülen stüdyo odada kalmıştır. Gündüz oturma yeri, gece yatak haline gelen bu çift işlevli yapı stüdyo odanın özelliğidir."
          ]
        },
        {
          "name": "Top Executive Room",
          "desc": "Genellikle üst katlarda yer alan, iş insanlarının veya yöneticilerin konakladığı, iş yemeği ve toplantı hizmeti de sunan lüks odalardır.",
          "examples": [
            "Örnekle Pekiştirelim: Uluslararası bir şirket yöneticisi, otelin üst katlarında yer alan, içinde özel çalışma masası ve yüksek hızlı interneti bulunan executive odada konaklamıştır. İş insanlarına özel çalışma alanı ve ayrıcalıklı hizmet sunulması bu oda tipinin özelliğidir."
          ]
        },
        {
          "name": "Birbirine Yakın Odalar (Adjacent Room)",
          "desc": "Düğün davetlileri veya futbol takımı gibi grupların konakladığı; aynı katta veya koridorda bulunan odalardır.",
          "examples": [
            "Örnekle Pekiştirelim: 15 kişilik tur grubunun akşamları kolayca buluşabilmesi için 3. katta birbirine yakın 5 oda bu gruba tahsis edilmiştir. Aynı katta veya koridorda yakın mesafedeki odaların verilmesi bu düzenin özelliğidir."
          ]
        },
        {
          "name": "Mutfak Bölmeli Oda (Efficiency Room)",
          "desc": "Yemek pişirme imkanına sahip, küçük bir daire şeklindeki odalardır. Apart otel odaları genellikle bu şekildedir.",
          "examples": [
            "Örnekle Pekiştirelim: Bebeği olan bir aile, mamaları kolayca hazırlayabilmek için içinde mini ocak, mikrodalga fırın ve buzdolabı bulunan apart otel odasını seçmiştir. Oda içerisinde mini mutfak donanımının yer alması mutfak bölmeli odanın özelliğidir."
          ]
        },
        {
          "name": "Özel Gereksinimli Birey Odası (Handicapped Room)",
          "desc": "Giriş katında bulunan, basamaksız, tekerlekli sandalyeye uygun genişlikte, banyo ve lavaboları özel tasarlanmış odalardır.",
          "examples": [
            "Örnekle Pekiştirelim: Tekerlekli sandalye kullanan bir misafir, banyosunda tutunma demirleri bulunan, eşiksiz ve geniş kapılı odasında rahatça konaklamıştır. Özel gereksinimli misafirlerin erişimine uygun özel mimari düzenlemeler bu odanın temel özelliğidir."
          ]
        },
        {
          "name": "Cabana (Kabena)",
          "desc": "Ana binadan ayrı, plaj ya da havuz kenarında bulunan sahil kulübesi tarzı odalardır.",
          "examples": [
            "Örnekle Pekiştirelim: Plajın hemen sıfır noktasında, önünde kendine özel şezlongları ve havuzu olan lüks egzotik sahil kulübesinde tatil yapan balayı çiftidir."
          ]
        }
      ],
      "extraDetails": [
        {
          "title": "Yatak Tipleri ve Ölçüleri",
          "content": "Queen Size (180x200 cm geniş yatak), King Size (200x210 cm en büyük yatak), Standart/Regular (Normal yatak), Single (Tek kişilik 1 yatak), Double (1 adet iki kişilik yatağı olan oda), French Bed (1 adet iki kişilik 150x200 cm büyük yataklı oda), Twin Bed (2 adet tek kişilik ayrı yatak), Triple (Üç kişilik oda), Quad (Dört kişilik oda)."
        }
      ],
      "caseStudy": "İki çocuklu bir aile, çocuklarının gözünün önünde olmasını ama ayrı odada kalmasını istiyorsa, rezervasyon görevlisi onlara Adjoining değil, kesinlikle \"Connecting Room\" satmalıdır. Yanlış oda satışı şikayet doğurur.",
      "tip": "Connecting = \"C\"apı var (İçeriden kapılı). Adjoining = \"A\"ramızda duvar var (Sadece komşu)."
    },
    {
      "id": 2,
      "tag": "PANSİYON DURUMLARI",
      "title": "PANSİYON DURUMLARI VE ÖZEL ÜCRETSİZ STATÜLER",
      "microSummary": "Pansiyon durumu, misafirin ödediği oda ücretine hangi yeme-içme hizmetlerinin dâhil olduğunu gösteren uluslararası standarttır.",
      "definitions": [
        {
          "name": "Sadece Yatak (Only Bed - OB)",
          "desc": "Ücrete sadece oda dahildir. Tüm yeme-içme hizmetleri ekstra ücrete tabidir.",
          "examples": [
            "Örnekle Pekiştirelim: Geceyi geçirmek için otele gelen bir misafir, yeme-içme istemediği için en ucuz Only Bed tarifesinden yararlanmıştır. Konaklama ücretine hiçbir yeme-içme hizmetinin dahil olmaması bu pansiyon türünün özelliğidir."
          ]
        },
        {
          "name": "Oda Kahvaltı (Bed and Breakfast - BB)",
          "desc": "Bir gecelik konaklama ile sabah kahvaltısının ücrete dahil olduğu sistemdir.",
          "examples": [
            "Örnekle Pekiştirelim: Gündüz şehri gezecek olan turist, sabah otelde kahvaltısını yapıp çıkmış, akşam yemeğini dışarıda yemeyi seçmiştir. Konaklama ücretine sadece sabah kahvaltısının dahil olması bu pansiyon türünün özelliğidir."
          ]
        },
        {
          "name": "Yarım Pansiyon (Half Board - HB)",
          "desc": "Konaklama ücretine kahvaltı ve bir ana öğün yemek (öğle veya akşam) ücretinin dahil olduğu pansiyon şeklidir.",
          "examples": [
            "Örnekle Pekiştirelim: Kapadokya'da gündüz tura çıkan turistler, sabah kahvaltısını ve akşam yemeğini otelde yemiş, öğle yemeğini ise turda ödemiştir. Konaklamaya kahvaltı ile akşam yemeğinin dahil olması yarım pansiyonun özelliğidir."
          ]
        },
        {
          "name": "Tam Pansiyon (Full Board - FB)",
          "desc": "Konaklama ücretine kahvaltı, öğle yemeği ve akşam yemeğinin dahil olduğu pansiyon şeklidir.",
          "examples": [
            "Örnekle Pekiştirelim: Otelden hiç çıkmak istemeyen yaşlı bir çift, sabah, öğle ve akşam yemeklerini otel büfesinde yemiş, gün içi ekstra içecekleri kendisi ödemiştir. 3 ana öğünün fiyata dahil olması tam pansiyonun özelliğidir."
          ]
        },
        {
          "name": "Her Şey Dahil (All Inclusive - AI)",
          "desc": "Kahvaltı, ana yemekler, tüm yiyecekler ve yerli içeceklerin ücretsiz sunulduğu pansiyon şeklidir.",
          "examples": [
            "Örnekle Pekiştirelim: Tatil yapan bir aile, gün boyu dondurma, atıştırmalık ve yerli içecekleri ekstra ücret ödemeden tüketmiştir. Ana öğünlerin yanı sıra gün içi ikramların da fiyata dahil olması bu sistemin özelliğidir."
          ]
        },
        {
          "name": "Ultra Her Şey Dahil (Ultra All Inclusive - UAI)",
          "desc": "AI sistemine ek olarak tüm yabancı içecekler, mini bar ve saat sınırlaması olmaksızın 7/24 yiyecek-içecek hizmetinin dahil olduğu lüks pansiyondur.",
          "examples": [
            "Örnekle Pekiştirelim: Gece acıkan bir misafir, oda servisinden ücretsiz hamburger istemiş ve minibarındaki ithal içecekleri ücret ödemeden tüketmiştir. 24 saat kesintisiz hizmet ve ithal ürünlerin dahil olması ultra her şey dahil sisteminin özelliğidir."
          ]
        }
      ],
      "extraDetails": [
        {
          "title": "Özel Ücretsiz Durumlar",
          "content": "• Free (Ücretsiz): Seyahat acentesi rehberleri veya temsilcileri için sözleşme gereği ücret alınmayan statüdür.\n• Complimentary (Kamplimentri): Sadık, sık gelen veya VIP konuklar için otelin jest olarak yaptığı ücretsiz ikram/konaklamadır.\n• House Use (Haus Yuuz): Otel personelinin (Örn: Genel Müdür) görev gereği ücret ödemeden kaldığı odaları ifade eder."
        },
        {
          "title": "Özel Konuk Sınıfları",
          "content": "VIP (Devlet büyükleri, sanatçılar, balayı çiftleri), Özel Gereksinimli (Handicapped Guests), Sık Gelen (Repeat Guests), CIP (Commercially Important Person - Tur operatörleri, ticari önemi olan şirket yöneticileri), Hasta Konuklar."
        }
      ],
      "caseStudy": "Gece 03:00'te taze sıkılmış portakal suyu ve yabancı marka içecek isteyen misafir All Inclusive ise ekstra ücret öder, Ultra All Inclusive ise 7/24 hiçbir ücret ödemez.",
      "tip": "Half Board = Half (Yarım) yani tek öğün. Full Board = Full (Tam) yani tüm ana öğünler açık."
    },
    {
      "id": 3,
      "tag": "REZERVASYON TÜRLERİ",
      "title": "REZERVASYON TÜRLERİ VE ZAMAN GÜVENCELERİ",
      "microSummary": "Rezervasyon alan görevli, misafirin odayı kaçta teslim alacağını ve ödeme güvencesini doğru kaydetmelidir; aksi takdirde otel gelir kaybı yaşar.",
      "definitions": [
        {
          "name": "Münferit Rezervasyon",
          "desc": "Bireysel olarak seyahat eden ve talepte bulunan 11 kişiye kadar olan konuk rezervasyonlarıdır.",
          "examples": [
            "Örnekle Pekiştirelim: Ahmet Bey'in, eşi ve çocuğu için otel web sitesinden doğrudan 1 odalık bireysel rezervasyon kaydı açtırmıştır."
          ]
        },
        {
          "name": "Grup Rezervasyon",
          "desc": "Birlikte hareket eden 11 kişi ve üzeri topluluklardır (Seyahat acentesi grupları, şirket grupları, bağımsız gruplar).",
          "examples": [
            "Örnekle Pekiştirelim: Bir seyahat acentesi, 40 kişilik İtalyan turist kafilesi için otelde topluca 20 adet standart oda ayırtmıştır."
          ]
        },
        {
          "name": "Geliş Saati ve Ödeme Garantisi Olmayan Rezervasyon",
          "desc": "Kapora alınmamıştır. Uluslararası kurallara göre oda, sayfiye otellerinde saat 16.00'ya, şehir otellerinde saat 18.00'e kadar bekletilir. Misafir gelmezse iptal edilir ve başkasına satılır. Misafir hak talep edemez.",
          "examples": [
            "Örnekle Pekiştirelim: Kapora ödemeyen Can Bey’in odası saat 18:00'i geçtiği halde gelmediği için iptal edilerek lobide bekleyen walk-in misafire satılmıştır."
          ]
        },
        {
          "name": "Geliş Saati Kesin Olan Rezervasyon",
          "desc": "Kapora yoktur ama formda varış saati yazılıdır. İşletme o saate kadar odayı tutmak zorundadır, saat geçince odayı satma hakkı doğar.",
          "examples": [
            "Örnekle Pekiştirelim: Kapora vermeyen ama 'Akşam saat 21:00'de kesin otelde olacağım' diyen iş adamının odası saat 21:00'e kadar sistemde tutulmuştur."
          ]
        },
        {
          "name": "Garantisi Olan (Kesin) Rezervasyon",
          "desc": "Kaporası ödenmiş veya kredi kartı güvencesi alınmış odalardır. Misafir sabaha karşı gelse veya gecikse bile oda KESİNLİKLE başkasına satılamaz.",
          "examples": [
            "Örnekle Pekiştirelim: Kredi kartından ilk gece ücreti bloke edilen misafirin uçağı rötar yapıp sabah 04:00'te gelse bile odası hazır beklemiştir."
          ]
        },
        {
          "name": "Grup Memorandumu",
          "desc": "Oteldeki diğer bölümlere (Mutfak, Kat Hizmetleri vb.) gelecek grupların detaylarını (kişi sayısı, özel istekler vb.) bildirmek için Rezervasyon Bölümü tarafından yazılan resmi iç formdur.",
          "examples": [
            "Örnekle Pekiştirelim: Otele gelecek 50 kişilik kongre grubunun detaylarını (giriş saati, gala yemeği saati) mutfak şefine ve kat hizmetlerine bildiren resmi iç formdur."
          ]
        }
      ],
      "caseStudy": "Garantisiz rezervasyon yapan bir misafir uçağı rötar yaptığı için şehir oteline saat 19:30'da gelirse odasını bulamayabilir. Çünkü kapora yoksa saat 18:00'de oda sisteme geri salınır. Görevli bu kuralı misafire telefonda bildirmelidir.\n\nSektörden Vaka: 50 kişilik bir futbol takımı otele geleceğinde, mutfak ve kat hizmetlerine \"Grup Memorandumu\" gönderilmezse yemekler ve odalar yetişmez, otelde büyük kriz çıkar.",
      "tip": "Kapora yoksa \"Saat 18:00\" kuralı (Otel güvende), kapora varsa \"7/24 Oda Garanti\" (Misafir güvende).\n\nNot Bilgi Köşesi: Memorandum = Mutfak ve Kat Hizmetlerine Mesaj (Departmanlar arası iç mektup)."
    },
    {
      "id": 5,
      "tag": "SATIŞ KANALLARI",
      "title": "REZERVASYON KAYNAKLARI VE KANALLARI (DOĞRUDAN VE DOLAYLI KANALLAR)",
      "microSummary": "Oteller odalarını sadece resepsiyondan satmazlar; dijital dünyada birçok farklı kaynaktan rezervasyon akışı sağlanır.",
      "definitions": [
        {
          "name": "Doğrudan Rezervasyon Kaynakları",
          "desc": "Konuğun otele telefon, e-posta, web sitesi veya yüz yüze görüşme aracılığıyla doğrudan ulaşıp rezervasyon yaptırmasıdır. Acente komisyonu ödenmediği için otel için en yüksek karlı kanaldır.",
          "examples": [
            "Örnekle Pekiştirelim: Ahmet Bey, otelin kendi resmi web sitesine girerek kredi kartıyla doğrudan 3 gecelik oda satın almış ve otel bu satıştan hiç komisyon ödememiştir."
          ]
        },
        {
          "name": "Dolaylı Rezervasyon Kanalları",
          "desc": "Seyahat acenteleri, tur operatörleri, OTA (Online Travel Agency - Çevrim içi Seyahat Acenteleri) ve GDS (Global Distribution System - Küresel Dağıtım Sistemleri) gibi aracı kanallardır.",
          "examples": [
            "Örnekle Pekiştirelim: Yabancı bir turist, uluslararası bir online rezervasyon portalı üzerinden otelimizden oda ayırtmış ve otel bu portal firmasına %15 komisyon ödemiştir."
          ]
        },
        {
          "name": "GDS (Global Dağıtım Sistemleri)",
          "desc": "Havayolları, oteller ve seyahat acentelerini dünya çapında birbirine bağlayan, seyahat profesyonellerinin kullandığı küresel rezervasyon ağlarıdır.",
          "examples": [
            "Örnekle Pekiştirelim: Tokyo'daki bir seyahat acentesi, iş insanı konuğu için Amadeus sistemi üzerinden otelimizden uçak biletiyle birlikte oda rezervasyonu yapmıştır."
          ]
        }
      ],
      "caseStudy": "Sektörden Vaka: İstanbul'da bir iş oteli, odalarının %90'ını sadece online acenteler üzerinden satıyordu ve her ay yüksek oranda komisyon ödüyordu. Yeni rezervasyon şefi, otelin kendi web sitesine özel 'En Uygun Fiyat Garantisi ve Ücretsiz SPA Kullanımı' kampanyası başlattı. 6 ay içinde doğrudan rezervasyon oranı %10'dan %45'e yükseldi ve otel binlerce liralık komisyon masrafından kurtulmuş oldu.",
      "tip": "Doğrudan rezervasyon yapmak için arayan bir konuğa, online acentelerden daha avantajlı bir teklif veya oda yükseltme gibi küçük bir jest sunarak doğrudan satışı teşvik edin."
    }
  ]
};

// 2. Öğrenme Birimi Notları
const Map<String, dynamic> unit2Notes = {
  "title": "Rezervasyon Kayıt Etme",
  "learningUnit": "2. Öğrenme Birimi",
  "podcastUrl": "https://anchor.fm/s/114a64400/podcast/play/122579426/https%3A%2F%2Fd3ctxlq1ktw2nl.cloudfront.net%2Fstaging%2F2026-6-8%2F273cb1a9-c8df-102e-5682-f46789c74f5e.mp3",
  "cards": [
    {
      "id": 1,
      "tag": "REZERVASYON KABULÜ",
      "title": "REZERVASYON KABULÜ VE OTOMASYONUN GÜCÜ",
      "microSummary": "Otelde onaylanan her rezervasyon, misafirle otel arasında karşılıklı sorumluluk yükleyen yasal bir sözleşmedir. Bu sözleşmeyi hatasız yönetmenin anahtarı ise Ön Büro Otomasyonudur.",
      "definitions": [
        {
          "name": "Yazılı Bildirim Zorunluluğu",
          "desc": "Rezervasyon departmanı, talebin kabul edildiğini ücretleri belirterek yazılı bir belgeyle (E-posta, faks) karşı tarafa bildirmelidir.",
          "examples": [
            "Örnekle Pekiştirelim: Merve Hanım telefonda oda ayırttıktan sonra, Rezervasyon Şefi tüm fiyat detaylarını içeren resmi bir teyit e-postasını Merve Hanım'a gönderdi."
          ]
        },
        {
          "name": "Rezervasyon Konfirmasyonu (Teyit)",
          "desc": "Rezervasyonun onaylanarak hizmetlerin sunulacağının garanti edilmesidir. Mümkünse anında iletilmelidir.",
          "examples": [
            "Örnekle Pekiştirelim: Can Bey’in seyahat acentesinden gelen rezervasyon talebi incelendi ve otel tarafından \"Rezervasyonunuz sistemimizde onaylanmıştır\" belgesi gönderildi."
          ]
        },
        {
          "name": "Kabul Kontrol Listesi",
          "desc": "Rezervasyon alırken mutlaka \"Blacklist\" (Kara Liste) kontrolü yapılmalı, VIP ve sürekli gelen misafirlere (Repeat Guest) öncelik verilmeli ve misafire asla \"Oda Numarası\" söylenmemelidir!",
          "examples": [
            "Örnekle Pekiştirelim (Blacklist): Otelde daha önce taşkınlık çıkaran Hakan Bey tekrar oda istemiştir; ancak görevli sistemi kontrol edip Hakan Bey'in kara listede olduğunu görünce talebi kibarca reddetmiştir.",
            "Örnekle Pekiştirelim (Repeat Guest): Oteli her yıl ziyaret eden Aylin Hanım aradığında, rezervasyon görevlisi ona öncelik tanıyarak en sevdiği deniz manzaralı odayı ayırmıştır.",
            "Örnekle Pekiştirelim (Oda No Saklama): Görevli, Selim Bey’in odasını sisteme 302 numara olarak kaydetmiş ancak giriş günü bir teknik arıza çıkma ihtimaline karşı bu numarayı Selim Bey’e telefonda söylememiştir."
          ]
        },
        {
          "name": "Otomasyonun Faydaları",
          "desc": "Bilgiye kolay ulaşım, anlık doluluk ve istatistik raporları, hızlı karar alma ve zamandan tasarruf.",
          "examples": [
            "Örnekle Pekiştirelim: Resepsiyonist, yüzlerce klasörü aramak yerine otomasyon programında tek tuşa basarak otelde o gece kaç boş oda olduğunu saniyeler içinde görmüştür."
          ]
        }
      ],
      "caseStudy": "Giriş günü odalarda su tesisatı patlaması gibi krizler yaşanabileceği için misafire erken oda numarası verilmez.",
      "tip": "Otomasyon = Otoban (Zaman kazandırır, personeli yormaz, oteli hedefe hızlıca uçurur)."
    },
    {
      "id": 2,
      "tag": "DEĞİŞİKLİK VE İPTAL",
      "title": "DEĞİŞİKLİK, İPTAL VE BEKLEME LİSTESİ",
      "microSummary": "Otelcilikte satılmayan her oda, telafisi imkansız bir gelir kaybıdır. Bu kaybı önlemek için oteller \"Yedek Kulübesi\" ve \"Zaman Sınırları\" kullanır.",
      "definitions": [
        {
          "name": "Opsiyon Tarihi / Süresi (Deadline)",
          "desc": "Ödeme garantisi bulunmayan rezervasyonlar için tanınan son bekletme süresidir. Giriş günü Şehir otellerinde saat 18:00'e, Sayfiye otellerinde ise saat 16:00'ya kadardır.",
          "examples": [
            "Örnekle Pekiştirelim: Kapora ödemeyen Burak Bey’in rezervasyon kartına \"Giriş günü saat 18:00'e kadar gelecektir\" şeklinde son teslim zamanı (deadline) işlenmiştir."
          ]
        },
        {
          "name": "Opsiyonlu Rezervasyon",
          "desc": "Otelin odayı misafir için belirli bir gün ve saate kadar bekletmeyi kabul ettiği geçici rezervasyon türüdür.",
          "examples": [
            "Örnekle Pekiştirelim: Deniz Bey kesin geliş günü vermediği için rezervasyonu \"opsiyonlu\" yapılmış, saat 18:00'i geçtiği halde gelmeyince odası iptal edilip başkasına satılmıştır."
          ]
        },
        {
          "name": "Bekleyen Rezervasyonlar (Waitlist / Bekleme Listesi)",
          "desc": "Otel doluyken gelen taleplerin, garantisiz odaların iptal olma ihtimaline karşı kaydedildiği yedek listedir.",
          "examples": [
            "Örnekle Pekiştirelim: Otel tamamen doluyken arayan Elif Hanım'ın talebi reddedilmemiş, iptal olacak ilk oda için ismi \"bekleme listesine\" alınmıştır."
          ]
        },
        {
          "name": "İptal ve Değişiklik Kartı",
          "desc": "Bir kayıt güncellenirken; Rezervasyon No, İptal/Değişiklik Sebebi ve Tarihi işlenmeli, şirket iptalleri yasal süreç için kesinlikle yazılı olmalıdır.",
          "examples": [
            "Örnekle Pekiştirelim: Bir acente 10 odalık rezervasyonunu iptal ettiğinde, otel ileride doğabilecek yasal anlaşmazlıkları önlemek için acenteden iptal yazısını e-posta ile talep etmiştir."
          ]
        }
      ],
      "caseStudy": "Boşalan odalara hemen bekleme listesindeki (Waitlist) sonraki turistin atanması otelin oda gelirini kurtarır.",
      "tip": "Waitlist = Yedek Kulübesi (Asıl oyuncu çıkarsa, bekleme listesindeki yedek oyuncu hemen oyuna girer)."
    },
    {
      "id": 3,
      "tag": "GARANTI YÖNTEMLERİ",
      "title": "REZERVASYON GARANTİ YÖNTEMLERİ VE FİNANSAL TERİMLER",
      "microSummary": "Otelen odasını güvenceye almasının en sağlam yolu parayı veya yasal taahhüdü baştan almaktır. Gelmeyen misafir bile otele kazanç sağlayabilir.",
      "definitions": [
        {
          "name": "No-Show (Gerçekleşmeyen Rezervasyon)",
          "desc": "Ödeme garantili rezervasyonu olduğu halde otele gelmeyen ve iptal de etmeyen misafir durumudur.",
          "examples": [
            "Örnekle Pekiştirelim: Kaporasını ödediği halde o gece otele giriş yapmayan Murat Bey için otel personeli \"No-Show\" faturası keserek ilk gecenin oda ücretini tahsil etmiştir."
          ]
        },
        {
          "name": "Kredi Kartı & E-mail Order",
          "desc": "Uzaktan kredi kartıyla güvenli ödeme alma formudur.",
          "examples": [
            "Örnekle Pekiştirelim: Yurtdışındaki Thomas Bey, otel ücretini uzaktan ödemek için kendisine maille gönderilen \"E-mail Order\" formunu doldurup imzalamıştır."
          ]
        },
        {
          "name": "Depozito (Ön Ödeme / Kapora)",
          "desc": "Hizmet verilmeden önce bedelin bir kısmının tahsil edilmesidir ve karşılığında Tahsilat Makbuzu kesilir.",
          "examples": [
            "Örnekle Pekiştirelim: Zeynep Hanım, balayı odasını kesinleştirmek için otelin banka hesabına bir gecelik oda bedelini kapora olarak yatırmış ve makbuzunu almıştır."
          ]
        },
        {
          "name": "City Ledger (Siti Lecır)",
          "desc": "Otel ile acente/şirket arasındaki kredili hesaptır. Acentenin misafir harcamalarının sadece \"bir kısmını\" ödemesi anlamına gelir.",
          "examples": [
            "Örnekle Pekiştirelim: X Acentesi ile gelen grubun sadece oda ücretleri acentenin kredili hesabına (City Ledger) kaydedilmiş, ekstra akşam yemeklerini misafirler kendileri ödemiştir."
          ]
        },
        {
          "name": "Full City Ledger",
          "desc": "Sadece oda ve kahvaltıyı karşılayan standart kredili hesabın aksine; Full City Ledger sisteminde minibar ve ekstra harcamalar dahil tüm fatura kuruma kesilir, misafir çıkışta ödeme yapmaz.",
          "examples": [
            "Örnekle Pekiştirelim: Büyük bir holdingin yönetim kurulu başkanı otelde konaklamış; yeme-içme dahil tüm faturası holdingin tam kredili hesabına (Full City Ledger) aktarılmıştır."
          ]
        }
      ],
      "caseStudy": "Otelle sözleşmesi olmayan tanınmayan acentelerden kesinlikle depozito (kapora) talep edilmelidir.",
      "tip": "No-Show = \"N\"erde bu misafir? (Gelmeyene kesilen fatura)."
    },
    {
      "id": 4,
      "tag": "OTOMASYON VE CETVELLER",
      "title": "KLASİKTEN MODERNE REZERVASYON CETVELLERİ",
      "microSummary": "Duvar panolarından bulut teknolojisine uzanan rezervasyon izleme serüveni, otel yöneticilerinin dünyayı her yerden kontrol etmesini sağlıyor.",
      "definitions": [
        {
          "name": "Duvar Rezervasyon Cetvelleri",
          "desc": "Manuel sistemde duvara asılan eski ve hantal çizelgelerdir. Günümüzde tamamen terk edilmiştir.",
          "examples": [
            "Örnekle Pekiştirelim: 1980'lerde çalışan emektar resepsiyonist Ahmet Bey, hangi odanın boş olduğunu görmek için her sabah duvardaki dev ahşap panoya renkli kartlar asardı."
          ]
        },
        {
          "name": "Dijital Rezervasyon Cetveli (Blokaj Tablosu)",
          "desc": "Oda numarası, oda tipi ve tarih bazında müsaitlik durumunu gösteren otomatik dijital tablodur.",
          "examples": [
            "Örnekle Pekiştirelim: Ön büro personeli bilgisayar ekranındaki renkli blokaj tablosuna bakarak, hangi odanın hangi tarihlerde hangi misafire ayrıldığını tek bakışta görmüştür."
          ]
        },
        {
          "name": "Web Tabanlı / Bulut Otomasyon Programları",
          "desc": "İnternet olan her yerden anlık durum raporlarına, tahmin (forecast) raporlarına ve \"Call Center\" notlarına ulaşmayı sağlayan modern sistemdir.",
          "examples": [
            "Örnekle Pekiştirelim: Otel sahibi Cemal Bey, evinde dinlenirken tabletinden bulut otomasyon sistemine bağlanmış ve çağrı merkezine bırakılan misafir notlarını canlı olarak incelemiştir."
          ]
        }
      ],
      "caseStudy": "Bulut teknolojisi sayesinde yöneticiler nerede olurlarsa olsunlar otel operasyonunu anlık yönetebilirler.",
      "tip": "Duvar Cetveli = Taş Devri. Web Otomasyon = Bulut Teknolojisi (7/24 canlı kontrol)."
    },
    {
      "id": 5,
      "tag": "KAPASİTE KONTROLÜ",
      "title": "SATIŞ KISITLAMALARI VE REZERVASYON ENGELLERİ (STOP-SALE, CLOSED-OUT)",
      "microSummary": "Yoğun dönemlerde geliri maksimize etmek için otel yönetimi satışları sınırlandırabilir veya durdurabilir.",
      "definitions": [
        {
          "name": "Stop-Sale (Satış Durdurma)",
          "desc": "Otelin belirli bir tarih aralığında tamamen dolması veya teknik/operasyonel bir durum nedeniyle yeni rezervasyon kabulünü kapatması işlemidir. Acentelere ve online kanallara satış durdurma yazısı gönderilir.",
          "examples": [
            "Örnekle Pekiştirelim: Bayram tatilinde tüm odaları dolan otelin rezervasyon şefi online satış kanallarına 'Stop-Sale' (Satış Kapatma) komutu göndererek yeni girişleri engellemiştir."
          ]
        },
        {
          "name": "Closed-Out (Kapanış)",
          "desc": "Belirli bir pazar segmentine (örneğin sadece yerli pazara veya belirli bir acenteye) satışların durdurulması, diğer kanalların açık tutulması anlamına gelir.",
          "examples": [
            "Örnekle Pekiştirelim: Otelde yabancı turist yoğunluğunu dengede tutmak için, iç pazara yönelik satışlar 'Closed-Out' yapılarak sadece dış pazar acentelerine açık bırakılmıştır."
          ]
        },
        {
          "name": "Minimum Stay (Asgari Konaklama Sınırı)",
          "desc": "Yılbaşı, bayram veya festival gibi yoğun dönemlerde, otelde kalış süresini uzatmak için konuklara uygulanan 'en az konaklama günü' şartıdır.",
          "examples": [
            "Örnekle Pekiştirelim: otel, Kurban Bayramı dönemi için 'Minimum Stay' (en az 4 gece) kuralı koyarak 2 gecelik rezervasyon yapmak isteyen konukları reddetmiştir."
          ]
        }
      ],
      "caseStudy": "Sektörden Vaka: Muğla'da bir otel, bayram dönemi için 'Minimum Stay' (en az 4 gece) kuralı koydu. Bazı misafirler 2 gecelik rezervasyon talep etti ancak kabul edilmedi. Bayram geldiğinde tüm odalar 4 gece boyunca dolu kaldı. Eğer 2 gecelik rezervasyonlar kabul edilseydi, bayramın diğer günlerinde odalar boş kalacaktı ve otel ciddi bir gelir kaybı yaşayacaktı.",
      "tip": "Stop-Sale kararı alındığı an sisteme ve tüm acente kanallarına anında işlenmelidir. Gecikme yaşanırsa overbooking veya shorta düşme krizleri kaçınılmaz olur."
    }
  ]
};

// 3. Öğrenme Birimi Notları
const Map<String, dynamic> unit3Notes = {
  "title": "Rezervasyon Durum Analizi",
  "learningUnit": "3. Öğrenme Birimi",
  "podcastUrl": "https://anchor.fm/s/114a64400/podcast/play/122579453/https%3A%2F%2Fd3ctxlq1ktw2nl.cloudfront.net%2Fstaging%2F2026-6-8%2F4684652d-6f01-180a-e7ab-ffb772f81eaf.mp3",
  "cards": [
    {
      "id": 1,
      "tag": "SATIŞ DİNAMİKLERİ",
      "title": "ODA SATIŞ DİNAMİKLERİ VE HESAPLAMALAR",
      "microSummary": "Otelcilikte satılmayan oda depolanamaz. Bu yüzden her gün \"Satılabilir Oda Sayısı\" hatasız hesaplanmalıdır.",
      "definitions": [
        {
          "name": "Satılabilir Oda",
          "desc": "İşletmenin o güne ait ne kadar yeni rezervasyon alabileceğini gösteren oda sayısını ifade eder.",
          "examples": [
            "Örnekle Pekiştirelim: Rezervasyon şefi o güne ait tüm çıkış ve girişleri hesaplayarak satış ekibine 'Bugün en fazla 15 oda satabilirsiniz' talimatını vermiştir."
          ]
        },
        {
          "name": "Formül",
          "desc": "(Önceki günden kalan boş oda + O gün çıkış yapacak oda) - (O gün giriş yapacak oda + Arızalı/Personel odası).",
          "examples": [
            "Örnekle Pekiştirelim: 100 odalı otelde 60 oda dolu, 5 oda arızalı ve 15 adet kesin rezervasyon varsa; Satılabilir Oda = 100 - (60 + 15 + 5) = 20 odadır. Görevli Ayşe, o gün en fazla 20 oda daha satabileceğini bu hesaba göre bilir."
          ]
        }
      ],
      "caseStudy": "Bugün satılmayan odanın gelirini yarın o odayı iki kişiye satarak kurtaramayız. Hedef her gün %100 doluluktur.",
      "tip": "Otelde Oda = Taze Ekmek (Bugün satılmazsa bayatlar, yarın satılamaz)."
    },
    {
      "id": 2,
      "tag": "RİSK YÖNETİMİ",
      "title": "RİSK YÖNETİMİ (OVERBOOKING VE SHORTA DÜŞMEK)",
      "microSummary": "Otel yönetimi, iptal ihtimaline karşı bilinçli olarak kapasitesinin üstünde rezervasyon alır.",
      "definitions": [
        {
          "name": "Overbooking (Fazla Rezervasyon)",
          "desc": "Oda sayısından fazla satış yapma riskidir. Uluslararası kabul gören oran %5 - %13 arasıdır.",
          "examples": [
            "Örnekle Pekiştirelim: Müdür, yılbaşında misafirlerin %10'unun gelmeyeceğini öngörüp 100 odalı otele 110 rezervasyon onaylamıştır."
          ]
        },
        {
          "name": "Shorta Düşmek (Şorta Düşmek)",
          "desc": "Fazla alınan rezervasyonların hepsinin gelmesi sonucu oda kalmaması ve kriz çıkması anlamına gelir.",
          "examples": [
            "Örnekle Pekiştirelim: Overbooking yapılan otele tüm misafirler gelince Hans Bey odasız kalmıştır. Otel, Hans Bey'i yandaki otele transfer edip ücretini kendi ödemek zorunda kalmıştır."
          ]
        }
      ],
      "caseStudy": "Shorta düşen otel, misafiri kapıdan çeviremez. En az aynı kalitede başka bir otelde ücretsiz konaklatmak ve masraflarını karşılamak zorundadır.",
      "tip": "Overbooking = Akıllı Risk. Shorta Düşmek = Evdeki Hesabın Çarşıya Uymaması."
    },
    {
      "id": 3,
      "tag": "KONTROL MEKANİZMASI",
      "title": "KRİTİK GÜNLER VE KONTROL MEKANİZMALARI",
      "microSummary": "Özel dönemlerde satışlar kısıtlanarak en yüksek gelir hedeflenir.",
      "definitions": [
        {
          "name": "No-Show",
          "desc": "Ödeme garantili misafir gelmediğinde açılan hesap ve kesilen faturadır. Genelde ilk gece ücreti tahsil edilir.",
          "examples": [
            "Örnekle Pekiştirelim: Murat Bey otele gelmemiştir. Otel, \"No-Show\" faturası keserek Murat Bey'in kaporasından ilk gece ücretini almıştır."
          ]
        },
        {
          "name": "Closed Out (Kapanış)",
          "desc": "Festival veya bayram gibi günlerde rezervasyonun önceden durdurulması anlamına gelir.",
          "examples": [
            "Örnekle Pekiştirelim: Antalya'daki büyük spor festivalinde otel \"Closed Out\" olmuş, sadece eski sadık misafirlere yer açılmıştır."
          ]
        },
        {
          "name": "On Request / FOM",
          "desc": "Odalar kritik seviyeye düştüğünde satışın müdür onayına bağlanmasıdır. İndirim yapılmaz, en yüksek \"Rack Rate\" uygulanır.",
          "examples": [
            "Örnekle Pekiştirelim: Son 3 oda kaldığında görevli Murat, müdüründen onay almadan satış yapamaz."
          ]
        }
      ],
      "tip": "Stop Sales = Doluluk Freni. On Request = Müdürün Kilidi."
    },
    {
      "id": 4,
      "tag": "FORECAST",
      "title": "OPERASYONEL HAREKETLER VE TAHMİNLEME (FORECAST)",
      "microSummary": "Geçmiş verilerle geleceği tahmin etme (Forecast) raporları hazırlanır.",
      "definitions": [
        {
          "name": "Walk-In",
          "desc": "Kapıdan doğrudan giriş yapan, rezervasyonsuz konuktur. En yüksek fiyattan konaklar.",
          "examples": [
            "Örnekle Pekiştirelim: Yolda arabası bozulan bir gezgin rezervasyonu olmadığı halde gece yarısı otel resepsiyonuna gelip kapı fiyatından (Rack Rate) oda kiralamıştır."
          ]
        },
        {
          "name": "Extension (Uzatma) / Early C-Out (Erken Ayrılma)",
          "desc": "Çıkış tarihini erteleme veya erkenden ayrılma durumudur.",
          "examples": [
            "Örnekle Pekiştirelim: Erken ayrılan Linda Hanım için otel prosedürü gereği kalmadığı gecelerin de ücreti tahsil edilmiştir."
          ]
        },
        {
          "name": "Forecast Çeşitleri",
          "desc": "• Three Days (3 Günlük): En güncel tahmindir.\n• Seven Days (Haftalık): Personel çalışma çizelgesini belirler.\n• Monthly (Aylık): Bayram, fuar ve hava durumu gibi dış etkenleri de içeren rapordur.",
          "examples": [
            "Örnekle Pekiştirelim: Rezervasyon müdürü haftalık forecast raporuna bakarak, önümüzdeki cumartesi yoğunluk olacağını görüp ek garson ve resepsiyonist vardiyası yazmıştır."
          ]
        }
      ],
      "caseStudy": "Eğer festival dönemini aylık forecast'e eklemezsek; mutfak eksik malzeme alır, otel operasyonu çöker.",
      "tip": "Forecast = Otelciliğin Hava Durumu Tahmini."
    }
  ]
};

// 4. Öğrenme Birimi Notları
const Map<String, dynamic> unit4Notes = {
  "title": "Diğer Hizmetler için Rezervasyon Yapma",
  "learningUnit": "4. Öğrenme Birimi",
  "podcastUrl": "https://anchor.fm/s/114a64400/podcast/play/122579477/https%3A%2F%2Fd3ctxlq1ktw2nl.cloudfront.net%2Fstaging%2F2026-6-8%2F99a9aa1f-3201-fb30-59ed-a7e37f04719c.mp3",
  "cards": [
    {
      "id": 1,
      "tag": "SPA",
      "title": "SPA VE SAĞLIK TURİZMİ",
      "microSummary": "Sağlık turizmi, insanların şifa bulmak veya dinlenmek amacıyla seyahat etmesi anlamına gelir.",
      "definitions": [
        {
          "name": "SPA (Selus Per Aqua)",
          "desc": "Latince \"Sudan gelen sağlık\" anlamına gelir. Giriş işlemleri; karşılama, info verme, rezervasyon formu ve konsültasyon formunun doldurulmasıyla yapılır.",
          "examples": [
            "Örnekle Pekiştirelim: Astım hastası Linda Hanım'ın durumunu \"Spa Konsültasyon Formu\" sayesinde erkenden fark eden resepsiyonist, onu nefes darlığı yaratabilecek aşırı sıcak buhar odası yerine daha hafif bir terapiye yönlendirmiştir."
          ]
        }
      ],
      "caseStudy": "Sağlık formu (Konsültasyon) alınmadan misafiri işleme almak hayati tehlikelere yol açabilir.",
      "tip": "SPA = Sudan Gelen Sağlık. İlk kural Konsültasyon Formudur."
    },
    {
      "id": 2,
      "tag": "GOLF",
      "title": "GOLF TURİZMİ",
      "microSummary": "Üçüncü yaş turizminde en yüksek gelir bırakan alternatif türdür.",
      "definitions": [
        {
          "name": "Golf Sahasına Giriş",
          "desc": "Antalya-Belek bu işin başkentidir. Golf sahasına giriş yapacak konuklar kesinlikle bir eğitime tabi tutulur, eğitmen onay vermeden sahaya çıkamazlar.",
          "examples": [
            "Örnekle Pekiştirelim: İş insanı Robert Bey golf oynamak istemiş; ancak kurallar gereği sahaya çıkmadan önce golf eğitmeninden kısa bir teknik ve güvenlik eğitimi alarak hocanın onayıyla giriş yapabilmiştir."
          ]
        }
      ],
      "caseStudy": "Güvenlik eğitimi verilmeden golf oynatmak kazalara davetiye çıkarır.",
      "tip": "Antalya Belek = Golf Başkenti. Eğitimsiz sahaya çıkılmaz."
    },
    {
      "id": 3,
      "tag": "KONGRE",
      "title": "KONGRE TURİZMİ",
      "microSummary": "Şirket, delege ve elçilerin buluştuğu yüksek gelirli sektördür.",
      "definitions": [
        {
          "name": "Resmi Kongre Sözleşmesi",
          "desc": "Türkiye'deki miladı 1996 İstanbul HABİTAT II konferansı ve Lütfü Kırdar Kongre Sarayı'dır. Süreç; detaylı talep notu alma, yazılı teklif (e-posta/faks) ve tüm maddeleri (salon düzeni, yaka kartları vb.) içeren Resmi Kongre Sözleşmesi imzasıyla resmileşir.",
          "examples": [
            "Örnekle Pekiştirelim: 500 doktorun katılacağı kongre için rezervasyon şefi, salon düzeninden doktorların yaka kartlarına kadar her detayını netleştirdiği 15 sayfalık bir \"Resmi Kongre Sözleşmesi\" hazırlayarak süreci resmileştirmiştir."
          ]
        }
      ],
      "caseStudy": "Kongre rezervasyonlarında sözlü anlaşmalar geçerli değildir, mutlaka tüm detayları barındıran yazılı sözleşme olmalıdır.",
      "tip": "Kongre = Yüksek Gelir + Detaylı Sözleşme."
    },
    {
      "id": 4,
      "tag": "REKREASYON & TUR",
      "title": "REKREASYON, AKTİVİTE VE TRANSFER REZERVASYONLARI",
      "microSummary": "Ön büro sadece oda satmaz; konuğun tatili boyunca ihtiyaç duyacağı yerel turlar ve transferleri de organize eder.",
      "definitions": [
        {
          "name": "Rekreasyonel Aktivite Rezervasyonları",
          "desc": "Konukların otel içinde veya çevresinde katılabilecekleri eğlenceli ve dinlendirici aktivitelerin (balon turları, tekne turları, rehberli ören yeri gezileri vb.) ön büro veya concierge aracılığıyla ayırtılması anlamına gelir.",
          "examples": [
            "Örnekle Pekiştirelim: Kapadokya'daki otelde konaklayan yabancı bir ailenin talebi üzerine resepsiyonist sabah balon uçuşu ve öğleden sonra at binme turunu yetkili yerel acenteden ayırtmıştır."
          ]
        },
        {
          "name": "Transfer Rezervasyonları",
          "desc": "Konukların havalimanından otele veya otelden havalimanına güvenli bir şekilde ulaşımlarını sağlamak için yapılan özel araç veya servis rezervasyonlarıdır.",
          "examples": [
            "Örnekle Pekiştirelim: Misafirin uçuş kodunu (Flight Code) sisteme kaydedip, havalimanında karşılanması için otel şoförüne 'Özel transfer aracıyla saat 15:30'da misafiri karşılayın' emrin verilmiştir."
          ]
        }
      ],
      "caseStudy": "Sektörden Vaka: Kapadokya'da konaklayan bir grup turist, balon turuna katılmak istediğini son gün bildirdi. Resepsiyonist, yoğun dönem olmasına rağmen yetkili yerel acentelerle hızlıca iletişime geçerek gruba özel bir balon sepeti ve transfer aracı organize etti. Konuklar bu harika hizmetten o kadar memnun kaldılar ki otelden çıkışta personele teşekkür edip sonraki sene için tekrar rezervasyon yaptırdılar.",
      "tip": "Transfer rezervasyonu yaparken uçuş kodunu (Flight Code) ve konuğun tahmini iniş saatini mutlaka iki kez kontrol edin. Uçak rötar yapsa bile şoförün konuğu beklemesini koordine edin."
    }
  ]
};

// Toplu Veri Seti
const List<Map<String, dynamic>> allLectureNotes = [
  unit1Notes,
  unit2Notes,
  unit3Notes,
  unit4Notes,
];


// Derslere göre notlar
const Map<String, List<Map<String, dynamic>>> allCoursesNotes = {
  'Ön Büroda Rezervasyon': allLectureNotes,
  'Alternatif Turizm': alternatifTurizmNotes,
  'Kuru Temizleme İşlemleri': kuruTemizlemeNotes,
  'Çamaşırhane İşlemleri': camasirhaneNotes,
  'Dünya Seyahat ve Turizm Coğrafyası': dunyaCografyasiNotes,
  'Dünya Kültürleri': dunyaKulturleriNotes,
  'Kongre ve Etkinlik Turizmi': kongreEtkinlikNotes,
  'Gastronomi Turizmi': gastronomiTurizmiNotes,
  'Tur Operasyonu': turOperasyonuNotes,
  'Transfer Operasyonu': transferOperasyonuNotes,
  'Sosyal Medya': sosyalMedyaNotes,
  'Konaklama İşletmeciliği': konaklamaIsletmeciligiNotes,
  'Sürdürülebilir Turizm': surdurulebilirTurizmNotes,
  'Kat Hizmetleri Atölyesi': katHizmetleriAtolyesiNotes,
  'Ön Büro Hizmetleri Atölyesi': onBuroHizmetleriNotes,
  '11-Ön Büro Hizmetleri Atölyesi': onBuroHizmetleriNotes,
  '10-Kat Hizmetleri Atölyesi': katHizmetleri10Notes,
  '11-Kat Hizmetleri Atölyesi': katHizmetleriAtolyesiNotes,
  'Konuk Giriş Çıkış İşlemleri': konukGirisCikisNotes,
  'Mesleki Gelişim Atölyesi': meslekiGelisimNotes,
  '9-Mesleki Gelişim Atölyesi': meslekiGelisimNotes,
  'Genel Turizm': genelTurizmNotes,
  '9-Genel Turizm': genelTurizmNotes,
  'Otelcilik ve Seyahat Hizmetleri': otelcilikNotes,
  '9-Otelcilik ve Seyahat Hizmetleri': otelcilikNotes,
};
