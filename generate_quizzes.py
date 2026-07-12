# -*- coding: utf-8 -*-
import re
import os

QUIZ_FILE = "c:/Users/erolm/Desktop/TurizmAkademi/lib/core/data/quiz_data.dart"

def generate_questions():
    questions = []
    
    # 1. Konaklama İşletmeciliği (ki11, 5 units)
    ki_units = [
        # Unit 1
        [
            ("Kervansarayların modern otelcilik açısından en önemli tarihi özelliği nedir?",
             ["Sadece zenginlere hizmet vermesi", "Ticaret yolları üzerinde yolculara 3 gün ücretsiz yeme-içme ve barınma sunması", "Ücretli lüks hizmet sunması", "Sadece askeri amaçla kullanılması"], 1,
             "Anadolu Selçuklu döneminde kervansaraylar, ticaret yolları üzerinde yolcuların her türlü ihtiyacını 3 gün boyunca ücretsiz karşılayan ilk organize konaklama örneklerindendir."),
            ("Genellikle karayolu kenarlarında kurulan, arabalı yolcuların konaklama ve park ihtiyacını karşılayan tesis türü hangisidir?",
             ["Resort Otel", "Motel", "Pansiyon", "Hostel"], 1,
             "Otomobil teknolojisinin gelişmesiyle karayolu seyahatlerinin artması sonucu yol kenarlarında kurulan park ve barınma odaklı tesislere Motel denir."),
            ("Tatil bölgelerinde kurulan, geniş yeşil alanlara ve çeşitli eğlence/spor imkanlarına sahip büyük konaklama tesislerine ne denir?",
             ["Şehir Oteli", "Resort (Tatil) Oteli", "Pansiyon", "Apart Otel"], 1,
             "Misafirlerin tatil ve eğlence ihtiyaçlarını karşılamak üzere genellikle deniz kenarı veya doğa içinde kurulan geniş kapsamlı tesislere Tatil (Resort) Oteli denir."),
            ("Bir otelin 'Butik Otel' sınıfına girebilmesi için en temel özellik hangisidir?",
             ["En az 1000 odalı olması", "Özgün tasarım, yüksek hizmet kalitesi ve sınırlı oda sayısı (genellikle 10-75 oda)", "Sadece yazın açık olması", "En ucuz tesis olması"], 1,
             "Butik oteller, kişiye özel yüksek standartta hizmet sunan, özgün mimari ve dekorasyona sahip, oda sayısı sınırlı özel tesislerdir."),
            ("Türkiye'de otellere yıldızlandırma belgesi (1 yıldızdan 5 yıldıza kadar) yasal olarak hangi kurum tarafından verilir?",
             ["Belediyeler", "Kültür ve Turizm Bakanlığı", "TÜRSAB", "Esnaf Odası"], 1,
             "Otellerin turizm yatırım ve işletme belgeleri ile yıldız sınıflandırmaları Kültür ve Turizm Bakanlığı denetçilerince tescillenir."),
            ("Otel işletmelerinde sunulan oda fiyatının içine sadece oda konaklamasının dahil olduğu sistem hangisidir?",
             ["Oda-Kahvaltı (BB)", "Sadece Oda (EP / Only Room)", "Yarım Pansiyon (HB)", "Tam Pansiyon (FB)"], 1,
             "Sadece oda (European Plan) sisteminde yeme-içme hizmetleri ücrete dahil değildir, ekstra olarak faturalandırılır."),
            ("Konaklama tutarına oda konaklaması ile birlikte sabah kahvaltısının da dahil olduğu pansiyon türü hangisidir?",
             ["Yarım Pansiyon", "Oda-Kahvaltı (Bed & Breakfast)", "Her Şey Dahil", "Sadece Oda"], 1,
             "Oda-Kahvaltı sisteminde sabah kahvaltısı standart fiyata dahildir, diğer öğünler ekstradır."),
            ("Oda konaklamasının yanında sabah kahvaltısı ve akşam yemeğinin fiyata dahil olduğu sisteme ne denir?",
             ["Tam Pansiyon", "Yarım Pansiyon (Half Board)", "Oda-Kahvaltı", "Her Şey Dahil"], 1,
             "Yarım pansiyon (HB) sisteminde genellikle sabah kahvaltısı ve akşam yemeği ücrete dahildir, içecekler çoğunlukla ekstradır."),
            ("Sabah kahvaltısı, öğle yemeği ve akşam yemeğinin fiyata dahil olduğu pansiyon türü hangisidir?",
             ["Yarım Pansiyon", "Tam Pansiyon (Full Board)", "Sadece Oda", "Oda-Kahvaltı"], 1,
             "Tam pansiyon (FB) sisteminde gün içindeki üç ana öğün standart fiyata dahildir."),
            ("Türkiye'de kıyı otelciliğinde yaygın olarak kullanılan, ana öğünlerin yanı sıra yerli içeceklerin ve gün boyu ikramların fiyata dahil olduğu sistem hangisidir?",
             ["Yarım Pansiyon", "Her Şey Dahil (All Inclusive)", "Oda-Kahvaltı", "Tam Pansiyon"], 1,
             "Her şey dahil sistemi tatilcilerin bütçe kontrolünü kolaylaştıran, tüm temel yeme-içme hizmetlerinin tek fiyatta toplandığı sistemdir."),
            ("Tarihteki ilk modern ve profesyonel otelcilik anlayışının 19. yüzyılda başladığı ülke hangisidir?",
             ["Çin", "Amerika Birleşik Devletleri (ABD)", "Mısır", "Hindistan"], 1,
             "19. yüzyılda ABD'de açılan Tremont House gibi oteller, banyolu odalar ve resepsiyon hizmetleriyle modern otelciliğin öncüsü kabul edilir."),
            ("Misafirlerin kendi yemeklerini hazırlayabilmesi için içinde mutfak donanımı bulunan oda türlerine sahip tesislere ne denir?",
             ["Motel", "Apart Otel", "Hostel", "Pansiyon"], 1,
             "Apart oteller, ev tipi konaklama sunarak misafirlerin kendi yemeklerini yapmalarına imkan veren mutfaklı ünitelere sahiptir."),
            ("Genellikle genç gezginlerin tercih ettiği, ortak mutfak ve yatakhane tipi odalardan oluşan ekonomik tesislere ne denir?",
             ["Resort Otel", "Hostel", "Butik Otel", "Şehir Oteli"], 1,
             "Hosteller, bütçe dostu, sosyal etkileşimi yüksek ve ortak kullanım alanlarına sahip konaklama tesisleridir."),
            ("Bir otelin yıldız sayısının artması yasal olarak en çok neye bağlıdır?",
             ["Çalışanların yaşına", "Tesisin sunduğu fiziksel imkanlar, konfor ve hizmet çeşitliliği standartlarına", "Otelin sadece ismine", "Otelin bulunduğu şehrin nüfusuna"], 1,
             "Yıldız sayısı arttıkça otelin sunması gereken minimum fiziksel alan (oda büyüklüğü, havuz vb.) ve hizmet kalitesi yasal olarak artar."),
            ("Otelcilikte 'Sürdürülebilir Konaklama' belgesine sahip tesislerin temel önceliği hangisidir?",
             ["Daha lüks mobilyalar kullanmak", "Doğal kaynakları korumak, enerji tasarrufu yapmak ve çevreye en az zarar vermek", "Fiyatları sürekli düşürmek", "Sadece yabancı turist kabul etmek"], 1,
             "Sürdürülebilir tesisler yeşil enerji, atık yönetimi ve su tasarrufuyla doğanın korunmasını amaçlar.")
        ],
        # Unit 2
        [
            ("Otel işletmelerinde misafirin ilk karşılandığı, kayıt işlemlerinin yapıldığı ve anahtar teslim edilen departman hangisidir?",
             ["Kat Hizmetleri", "Ön Büro (Front Office)", "Yiyecek İçecek", "Teknik Servis"], 1,
             "Ön Büro, otelin beyni ve misafirin ilk/son temas noktasıdır; tüm giriş-çıkış ve bilgi akışı buradan yönetilir."),
            ("Katların, odaların ve genel alanların temizlik, bakım ve düzeninden sorumlu departman hangisidir?",
             ["Ön Büro", "Kat Hizmetleri (Housekeeping)", "Mutfak", "Satış Pazarlama"], 1,
             "Kat Hizmetleri, otelin en büyük operasyonel birimi olup odaların hijyen ve düzenini sağlayarak müşteri memnuniyetini doğrudan etkiler."),
            ("Otel mutfağı, restoranlar, barlar ve oda servisi gibi birimleri kapsayan departman hangisidir?",
             ["Ön Büro", "Yiyecek İçecek (F&B)", "Kat Hizmetleri", "Satış Pazarlama"], 1,
             "Yiyecek İçecek (Food and Beverage) departmanı, oteldeki tüm beslenme ve ziyafet operasyonlarını yürütür."),
            ("Oteldeki tüm elektrik, su, ısıtma-soğutma ve makine arızalarının onarımından sorumlu departman hangisidir?",
             ["Satış Pazarlama", "Teknik Servis", "Kat Hizmetleri", "Güvenlik"], 1,
             "Teknik Servis, tesisin fiziksel yapısının ve cihazlarının sorunsuz çalışmasını sağlayarak operasyon kesintilerini önler."),
            ("Otel odalarının acentelere satılması, kurumsal sözleşmelerin yapılması ve tanıtım faaliyetlerini yürüten departman hangisidir?",
             ["Ön Büro", "Satış ve Pazarlama", "Muhasebe", "İnsan Kaynakları"], 1,
             "Satış ve Pazarlama departmanı, otelin doluluk oranını ve gelirlerini artırmak amacıyla pazar araştırmaları ve satış anlaşmaları yapar."),
            ("Otelde çalışan personelin işe alımı, eğitimi ve bordro işlemlerinden sorumlu departman hangisidir?",
             ["Muhasebe", "İnsan Kaynakları (HR)", "Ön Büro", "Güvenlik"], 1,
             "İnsan Kaynakları departmanı, otelin en önemli gücü olan çalışanlerin seçimi, gelişimi ve yasal haklarının takibini yapar."),
            ("Otelin tüm gelir ve giderlerini denetleyen, faturaları ödeyen ve bütçe planlaması yapan departman hangisidir?",
             ["Satış Pazarlama", "Muhasebe / Finans", "Ön Büro", "Teknik Servis"], 1,
             "Muhasebe departmanı, otelin finansal sağlığını korumak amacıyla tüm para akışını ve resmi muhasebe kayıtlarını tutar."),
            ("Misafirlerin can ve mal güvenliğini korumak, otel genelinde huzuru sağlamakla görevli departman hangisidir?",
             ["Kat Hizmetleri", "Güvenlik", "Teknik Servis", "Ön Büro"], 1,
             "Güvenlik departmanı, 24 saat izleme ve devriye hizmetleriyle konukların ve otel varlıklarının emniyetini sağlar."),
            ("Otel genel müdürüne doğrudan bağlı çalışan ve departmanlar arası koordinasyonu sağlayan en üst düzey yönetici kimdir?",
             ["Resepsiyon Şefi", "Genel Müdür (GM)", "Kat Şefi (Executive Housekeeper)", "F&B Müdürü"], 1,
             "Genel Müdür, otelin vizyonunu çizen, tüm operasyonlardan ve karlılıktan sorumlu olan en yetkili kişidir."),
            ("Resepsiyon, rezervasyon, santral and bellboy birimleri hangi ana departmanın alt birimleridir?",
             ["Yiyecek İçecek", "Ön Büro", "Kat Hizmetleri", "İnsan Kaynakları"], 1,
             "Bu birimlerin tamamı misafir ilişkilerini yürüten Ön Büro departmanına bağlı olarak çalışır."),
            ("Kat Hizmetleri departmanının en üst düzey yöneticisine ne ad verilir?",
             ["Meydancı", "Kat Hizmetleri Müdürü (Executive Housekeeper)", "Resepsiyonist", "Bellboy"], 1,
             "Executive Housekeeper, kat hizmetleri bütçesini, personelini ve temizlik standartlarını yöneten baş yöneticidir."),
            ("Restoran ve barlarda misafirlere yiyecek ve içecek servisi yapan personele ne ad verilir?",
             ["Bellboy", "Garson / Servis Elemanı", "Kat Görevlisi", "Resepsiyonist"], 1,
             "Servis elemanları (garson/komi), yiyecek-içecek departmanında misafir memnuniyetiyle doğrudan temas kuran personeldir."),
            ("Misafirlerin bagajlarını taşıyan, araçlarını park eden ve onlara lobi girişinde yardımcı olan Ön Büro personeli hangisidir?",
             ["Resepsiyonist", "Bellboy / Bagaj Görevlisi", "Kat Görevlisi", "Meydancı"], 1,
             "Bellboylar konukların bagajlarını taşımak, odaları tanıtmak ve ilk karşılama/uğurlama protokollerini uygulamakla görevlidir."),
            ("Otelde departmanlar arasında bilgi akışının kesilmesi en çok hangi probleme yol açar?",
             ["Otel renklerinin değişmesine", "Misafir taleplerinin gecikmesine, hizmet kalitesinin düşmesine ve operasyonel hatalara", "Personelin daha hızlı çalışmasına", "Yıldız sayısının artmasına"], 1,
             "Departmanlar arası iletişim (örn. temiz oda bilgisinin ön büroya geç iletilmesi) aksarsa misafirler bekletilir ve memnuniyetsizlik oluşur."),
            ("Ön büro ile kat hizmetleri arasındaki en kritik bilgi paylaşımı hangisidir?",
             ["Yemek menüleri", "Oda durumları (Kirli, Temiz, Arızalı vb.)", "Personel maaşları", "Acente komisyon oranları"], 1,
             "Oda durumlarının (Room Status) anlık paylaşımı, boşalan odaların hızla temizlenip yeni gelen misafirlere satılması için hayati önem taşır.")
        ],
        # Unit 3
        [
            ("İnsan kaynakları yönetiminin bir otel işletmesindeki en temel amacı nedir?",
             ["En ucuz personeli bulmak", "Doğru işe doğru insanı seçmek, eğitmek ve yüksek motivasyonla verimli çalışmasını sağlamak", "Tüm işleri robotlara yaptırmak", "Personel sayısını sürekli artırmak"], 1,
             "Turizm emek-yoğun bir sektör olduğu için başarısı doğrudan doğru insan gücünün seçilmesine ve yönetilmesine bağlıdir."),
            ("Otelde yeni işe başlayan bir personele, otelin yapısını, kurallarını ve departmanları tanıtmak amacıyla yapılan eğitime ne denir?",
             ["Performans Analizi", "Oryantasyon (Uyum) Eğitimi", "Teknik Eğitim", "Vardiya Planlaması"], 1,
             "Oryantasyon eğitimi, yeni çalışanın işe ve otel kültürüne hızlıca adapte olmasını sağlayarak hata oranını düşürür."),
            ("İşletmelerde personelin haftalık çalışma gün ve saatlerini, nöbetlerini düzenleyen çizelgeye ne ad verilir?",
             ["Bilanço", "Vardiya (Roster) Çizelgesi", "Organizasyon Şeması", "İş Planı"], 1,
             "Vardiya çizelgesi, otelin 24 saat kesintisiz hizmet verebilmesi için çalışanların çalışma ve dinlenme sürelerini yasal sınırlara göre düzenler."),
            ("Çalışanların motivasyonunu ve otelde kalma süresini (personel devir hızını düşürmeyi) en çok ne artırır?",
             ["Sürekli fazla mesai yaptırmak", "Adil ücretlendirme, takdir edilme, eğitim imkanları ve kariyer fırsatları sunulması", "Görevleri sürekli değiştirmek", "İletişimi tamamen kesmek"], 1,
             "Değer gördüğünü hisseden ve kariyer hedefi koyabilen personelin bağlılığı ve hizmet kalitesi yüksek olur."),
            ("Otelcilikte çalışanların belirli dönemlerde gösterdikleri iş başarısının ve davranışlarının ölçülmesine ne denir?",
             ["İş Tanımı", "Performans Değerlendirmesi", "Oryantasyon", "Hiyerarşi"], 1,
             "Performans değerlendirme, çalışanın güçlü ve zayıf yönlerini belirleyerek eğitim ihtiyaçlarını saptamaya yarar."),
            ("Personelin görev, yetki ve sorumluluklarının yazılı olarak tanımlandığı resmi belgeye ne denir?",
             ["Vardiya Çizelgesi", "İş Tanımı (Job Description)", "Otel Kataloğu", "İş Sözleşmesi"], 1,
             "İş tanımları, kimin ne iş yapacağını netleştirerek departman içi karmaşayı ve yetki çatışmalarını önler."),
            ("Otelcilik sektöründe personel devir hızının (Employee Turnover) yüksek olmasının en olumsuz etkisi hangisidir?",
             ["Otel binasının eskimesi", "Sürekli yeni işe alım ve eğitim maliyetleri oluşması, hizmet kalitesinde istikrarsızlık yaşanması", "Müşteri sayısının artması", "Teknolojinin gelişmesi"], 1,
             "Sürekli personel değişmesi, tecrübesiz çalışan oranını artırır ve misafirlere sunulan hizmet standartlarını bozar."),
            ("Çalışanların iş sağlığı ve güvenliği (İSG) kurallarına uyması otel açısından en çok neyi önler?",
             ["Müşteri sayısını", "İş kazalarını, meslek hastalıklarını ve yasal sorumluluk krizlerini", "Maaş ödemelerini", "Vardiya değişikliklerini"], 1,
             "İSG kuralları ve eğitimleri, personelin can güvenliğini korurken otelin hukuki risklerini de sıfıra indirir."),
            ("Hizmet sektöründe çalışanların kişisel hijyeni, diksiyonu ve kılık kıyafet düzgünlüğü neden hayati önem taşır?",
             ["Sadece fotoğraf çekilmek için", "Misafir gözünde otelin kalitesini, saygınlığını ve profesyonelliğini doğrudan temsil ettiği için", "Maaşları düşürdüğü için", "Vardiyayı kısalttığı için"], 1,
             "Temiz, güler yüzlü ve profesyonel görünen personel, misafirin otele duyduğu güven ve saygı algısını oluşturur."),
            ("Çalışanların kendilerini geliştirmeleri amacıyla düzenlenen 'Hizmet İçi Eğitimlerin' otel operasyonuna katkısı nedir?",
             ["Hizmet süresini uzatmak", "Hizmet standartlarını yükseltmek, hata oranını düşürmek ve misafir memnuniyetini artırmak", "Maliyetleri yükseltmek", "Personeli yormak"], 1,
             "Düzenli eğitimler personelin becerilerini güncel tutarak lüks hizmet standartlarının korunmasını sağlar."),
            ("İş başvurusu yapan adaylarla yapılan karşılıklı görüşme ve değerlendirme sürecine ne ad verilir?",
             ["Oryantasyon", "Mülakat (İş Görüşmesi)", "Performans Değerlendirme", "Brifing"], 1,
             "Mülakatlar, adayın teknik bilgisini ve otel kültürüne olan kişilik uyumunu ölçmek için en etkili yöntemdir."),
            ("Otelcilikte 'Empati' yeteneği güçlü çalışanların tercih edilmesinin en temel sebebi nedir?",
             ["Çok hızlı koşmaları", "Misafirlerin duygularını, ihtiyaçlarını ve beklentilerini doğru anlayarak hızlı ve memnun edici çözümler üretebilmeleri", "Hiç izin kullanmamaları", "Sadece yabancı dil bilmeleri"], 1,
             "Misafir odaklılık turizmin temelidir. Empati kurabilen çalışanlar şikayetleri anında memnuniyete dönüştürebilir."),
            ("Sabah vardiya değişimlerinde ekiplerin bir araya gelerek günün operasyonel detaylarını paylaştığı kısa toplantılara ne denir?",
             ["Kongre", "Brifing (Briefing)", "Seminer", "Mülakat"], 1,
             "Brifingler, günün VIP misafirleri, doluluk oranları ve özel etkinlikler hakkında hızlı bilgi paylaşımı sağlar."),
            ("İnsan kaynakları departmanının personelin doğum günü, evlilik gibi özel günlerini kutlamasının amacı nedir?",
             ["Maliyet yaratmak", "Çalışan motivasyonunu, aidiyet duygusunu ve iş yeri memnuniyetini artırmak", "Mesai saatlerini uzatmak", "Yasal zorunluluğu yerine getirmek"], 1,
             "Çalışanların özel günlerinin hatırlanması iç müşteri (personel) memnuniyetini ve sadakatini yükseltir."),
            ("Otel çalışanlarına sunulan 'Performans Ödülleri' (Ayın Personeli vb.) en çok neyi teşvik eder?",
             ["Daha az çalışmayı", "Hizmet kalitesinde tatlı bir rekabet yaratarak çalışanların başarılarını ve motivasyonlarını yükseltmeyi", "İşten ayrılmayı", "Hiyerarşiyi kaldırmayı"], 1,
             "Başarıları ödüllendirmek, diğer çalışanları da daha iyi hizmet sunmaya teşvik eder ve iş bağlılığını güçlendirir.")
        ],
        # Unit 4
        [
            ("Otel işletmelerinde 'Pazarlama' faaliyetlerinin temel amacı aşağıdakilerden hangisidir?",
             ["Sadece reklam afişi basmak", "Hedef kitleyi belirlemek, otelin doluluğunu ve oda gelirlerini en üst düzeye çıkarmak", "Fiyatları sürekli en yüksekte tutmak", "Rakipleri tamamen engellemek"], 1,
             "Pazarlama, doğru müşteriye doğru zamanda doğru fiyatla ulaşarak otelin karlılığını ve doluluğunu sürekli kılmayı amaçlar."),
            ("Pazarlamanın temelini oluşturan '4P (Pazarlama Karması)' unsurları otelcilikte hangisini ifade eder?",
             ["Personel, Plan, Politika, Performans", "Ürün (Product), Fiyat (Price), Dağıtım (Place), Tutundurma (Promotion)", "Paspas, Paket, Profil, Puan", "Para, Pazar, Program, Protokol"], 1,
             "Otelcilikte ürün oda ve hizmettir, fiyat konaklama bedelidir, dağıtım acente/web kanallarıdır, tutundurma ise reklamdır."),
            ("Otelin belirli özelliklerine (yaş grupları, gelir düzeyleri, seyahat amaçları) göre müşteri gruplarına ayrılmasına ne denir?",
             ["Pazar Bölümleme (Segmentasyon)", "SWOT Analizi", "Fiyatlandırma", "Overbooking"], 1,
             "Segmentasyon, otelin pazarlama bütçesini doğru hedeflere (örn. iş insanları veya aileler) harcamasını sağlar."),
            ("Otel işletmelerinin kendi web siteleri üzerinden aracı olmadan yaptıkları oda satışlarına ne ad verilir?",
             ["Dolaylı Dağıtım Kanalı", "Doğrudan (Direkt) Satış / Dağıtım", "Acente Satışı", "Toptan Satış"], 1,
             "Direkt satışlar, komisyonsuz olduğu için otelin en yüksek kar marjlı satış kanalıdır."),
            ("Seyahat acenteleri, tur operatörleri ve online rezervasyon siteleri (OTA) otel açısından hangi kategoriye girer?",
             ["Doğrudan Dağıtım Kanalı", "Dolaylı Dağıtım Kanalları", "İç Satış Birimleri", "Fiziksel Ürünler"], 1,
             "Acenteler ve OTA'lar aracı kurum oldukları için dolaylı dağıtım kanallarıdır, otelden komisyon alırlar."),
            ("Otellerin yıl boyunca yüksek doluluk elde etmek için şirketlerle yaptığı özel indirimli fiyat sözleşmelerine ne denir?",
             ["Acente Kontratı", "Kurumsal (Corporate) Anlaşma", "Walk-in Tarifesi", "Rack Rate Anlaşması"], 1,
             "Kurumsal anlaşmalar, şirket çalışanlarının sürekli konaklamasını sağlayarak iş otelleri için düzenli gelir gelirler."),
            ("Otel doluluk oranları, rakiplerin fiyatları ve pazar talebine göre oda fiyatlarının dinamik olarak ayarlanması sürecine ne denir?",
             ["Gelir Yönetimi (Revenue Management)", "Stok Kontrolü", "Maliyet Hesaplama", "Muhasebe Denetimi"], 1,
             "Revenue Management, 'doğru odayı, doğru müşteriye, doğru zamanda, doğru fiyata' satarak geliri maksimuma ulaştırma sanatıdır."),
            ("Otelcilikte 'Tutundurma (Promotion)' karması içerisinde yer alan halkla ilişkiler (PR) faaliyetlerinin temel amacı nedir?",
             ["Sadece broşür dağıtmak", "Otelin toplum ve müşteriler gözündeki olumlu imajını, saygınlığını ve marka değerini güçlendirmek", "Oda fiyatlarını artırmak", "Acente sayılarını azaltmak"], 1,
             "Olumlu PR çalışmaları, misafirlerin otele olan güvenini artırarak uzun vadeli marka sadakati yaratır."),
            ("Misafirlerin konaklama sonrası otel hakkında yaptıkları olumlu veya olumsuz geri bildirimlerin pazarlamaya etkisi nedir?",
             ["Hiçbir etkisi yoktur", "Online itibarını doğrudan etkileyerek yeni müşterilerin satın alma kararlarını belirler", "Sadece teknik servisi ilgilendirir", "Fatura kesimini hızlandırır"], 1,
             "Günümüzde misafirler online yorumlara göre otel seçmektedir. İyi itibar yönetimi en güçlü pazarlama silahıdır."),
            ("Otellerin belirli sezonlarda (örneğin kışın kıyı otellerinde) doluluğu artırmak için uyguladığı indirim ve kampanyalara ne denir?",
             ["Fiyat Cezası", "Sezonluk Promosyon / Kampanya", "Rack Rate", "No-show Bedeli"], 1,
             "Düşük sezonlarda yapılan cazip promosyonlar, otelin sabit giderlerini karşılayabilmesi için doluluk yaratır."),
            ("Otelcilikte 'Rack Rate' fiyatı neyi ifade eder?",
             ["En ucuz acente fiyatını", "Otelin tabelasında yazan, indirimsiz ve resmi en yüksek kapı fiyatını", "Sadece grup indirimlerini", "Personel fiyatını"], 1,
             "Rack rate, herhangi bir anlaşması veya rezervasyonu olmadan doğrudan gelen (walk-in) konuklara uygulanan tavan fiyattır."),
            ("Online seyahat acentelerine (Booking, Expedia vb.) otel tarafından her satılan oda için ödenen bedele ne denir?",
             ["Kira", "Komisyon", "Depozito", "Ceza"], 1,
             "Aracı seyahat siteleri, otel odasını sattıklarında anlaşma oranlarına göre (genellikle %15-%25) komisyon alırlar."),
            ("Otel pazarlamasında 'Müşteri İlişkileri Yönetimi (CRM)' sisteminin temel operasyonel faydası nedir?",
             ["Faturaları ödemek", "Misafirlerin geçmiş tercihlerini, doğum günlerini kaydederek onlara kişiselleştirilmiş hizmet sunmak ve sadakat yaratmak", "Mutfak malzemelerini saymak", "Güvenlik kameralarını izlemek"], 1,
             "CRM sayesinde misafire özel hissettirilir (örn. sevdiği yastık tipinin odaya konulması), bu da onun sürekli aynı oteli seçmesini sağlar."),
            ("Bir otelin pazarlama planı hazırlarken yaptığı 'SWOT Analizi' neyi ölçer?",
             ["Sadece odaların temizliğini", "Otelin Güçlü ve Zayıf yönleri ile dış çevredeki Fırsat ve Tehditlerini", "Personel maaşlarını", "Yemek porsiyonlarını"], 1,
             "SWOT analizi otelin pazardaki konumunu görerek doğru stratejiler geliştirmesini sağlayan en temel planlama aracıdır."),
            ("Hafta sonu şehir dışından gelen aileler için 'Çocuk Ücretsiz' veya 'Ücretsiz Spa Girişi' paketleri oluşturulması hangi pazarlama stratejisidir?",
             ["Fiyat odaklı zorlama", "Ürün Paketleme ve Niş Pazarlama", "Acente engelleme", "Overbooking"], 1,
             "Paket oluşturma, misafire toplu bir değer sunarak satın alma isteğini tetikleyen etkili bir pazarlama yöntemidir.")
        ],
        # Unit 5
        [
            ("Otel işletmelerinde tüm rezervasyon, check-in, check-out ve oda durumlarını yöneten ana bilgisayar yazılımına ne denir?",
             ["Kelime İşlemci", "PMS (Property Management System - Otel Otomasyon Programı)", "Grafik Tasarım Programı", "Muhasebe Hesap Makinesi"], 1,
             "PMS (Elektra, Opera vb.), otelin tüm departmanlarının entegre çalıştığı, rezervasyon ve konuk bilgilerinin tutulduğu beynidir."),
            ("Modern otellerde kullanılan akıllı kartlı kapı kilit sistemlerinin mekanik anahtarlara göre en büyük güvenlik avantajı nedir?",
             ["Daha parlak görünmeleri", "Kartın kaybolduğunda anında iptal edilebilmesi ve hangi saatte hangi personelin odaya girdiğinin raporlanabilmesi", "Hiç bozulmamaları", "Çok ucuz olmaları"], 1,
             "Akıllı kart kilitleri giriş-çıkış loglarını tutar. Kayıp kartlar sistemden silinerek odanın güvenliği anında korunur."),
            ("Otellerin enerji tüketimini azaltmak amacıyla odalarda kullandığı, misafir çıktığında elektriği kesen sistem hangisidir?",
             ["Televizyon kumandası", "Energy Saver (Kartlı Enerji Koruyucu)", "Klima motoru", "Minibar anahtarı"], 1,
             "Energy saver, odada hareket veya kart olmadığında aydınlatma ve klimayı kapatarak devasa enerji israfını önler."),
            ("Konukların otel içindeki tüm harcamalarını (oda servisi, restoran vb.) check-out sırasında tek bir faturada görmesini sağlayan teknolojik entegrasyon hangisidir?",
             ["Manuel Defter Tutma", "POS (Satış Noktası) ve PMS Entegrasyonu", "Telefon Santrali", "Güvenlik Kamerası"], 1,
             "POS ve otel yazılımı entegre olduğunda, restoranda yenen yemeğin hesabı anında misafirin oda hesabına (folyosuna) otomatik yansır."),
            ("Sürdürülebilir çevre politikası uygulayan otellerin 'Yeşil Enerji' kapsamında çatılara kurduğu teknoloji hangisidir?",
             ["Rüzgar pervanesi", "Güneş Panelleri (Fotovoltaik Sistemler)", "Klima santralleri", "Su depoları"], 1,
             "Güneş panelleri otelin elektrik ve sıcak su ihtiyacını temiz ve ücretsiz güneş enerjisinden karşılayarak karbon salınımını azaltır."),
            ("Otel odalarında resmi havalandırma (iklimlendirme) sistemlerinin pencereler açıldığında otomatik kapanmasını sağlayan teknoloji hangisidir?",
             ["Manyetik Pencere Sensörleri", "Manuel Şalter", "Klima Kumandası", "DND Kartı"], 1,
             "Pencere sensörleri, oda havalandırılırken klimayı durdurarak dışarıya giden boş enerji tüketimini engeller."),
            ("Otellerde basılı kağıt kullanımını azaltmak amacıyla giriş işlemlerinde (check-in) tablet kullanımı hangi teknolojik harekettir?",
             ["Kağıt israfı", "Dijital Kayıt ve Kağıtsız Ofis (Paperless) Uygulaması", "Sadece görsel şov", "Yasal zorunluluk dışı işlem"], 1,
             "Tablet üzerinden alınan dijital imzalar hem veri girişini hızlandırır hem de binlerce sayfa kağıt israfını önleyerek doğayı korur."),
            ("Misafirlerin oda içindeki aydınlatma, perde, klima ve televizyonu tek bir tabletten kontrol edebildiği oda konseptine ne denir?",
             ["Klasik Oda", "Akıllı Oda (Smart Room)", "Standart Oda", "Ofis Oda"], 1,
             "Akıllı odalar misafire yüksek konfor sunarken, otel otomasyonu sayesinde oda boşken enerji tasarrufunu maksimuma çıkarır."),
            ("Otellerin online rezervasyon sitelerindeki (Booking, Expedia vb.) oda fiyatlarını ve müsaitliklerini tek bir ekrandan eş zamanlı yöneten yazılıma ne denir?",
             ["Sosyal Medya", "Kanal Yöneticisi (Channel Manager)", "Muhasebe Programı", "Kelime İşlemci"], 1,
             "Kanal yöneticisi, fiyat ve oda kontenjan değişikliklerini tüm satış sitelerine saniyeler içinde dağıtarak çifte rezervasyon (overbooking) riskini önler."),
            ("Teknolojinin gelişmesiyle otel lobilerinde misafirlerin kendi giriş-çıkış işlemlerini bankoya uğramadan yapabildiği cihazlara ne denir?",
             ["ATM", "Self-Service Kiosk Ekranları", "Televizyon", "Telefon Kulübesi"], 1,
             "Kiosklar yoğun dönemlerde resepsiyon kuyruklarını azaltarak misafirlere hızlı ve pratik check-in/check-out imkanı sunar."),
            ("Otel mutfaklarında kullanılan akıllı fırınların ve soğuk hava depolarının ısı değerlerinin internet üzerinden uzaktan izlenmesi hangi teknolojidir?",
             ["Manuel Kontrol", "Nesnelerin İnterneti (IoT) ve Sensör Teknolojisi", "Rastgele İzleme", "Telefon Bağlantısı"], 1,
             "IoT sensörleri, dolap sıcaklığı değiştiğinde veya arıza oluştuğunda teknik ekibe anında SMS göndererek gıdaların bozulmasını önler."),
            ("Modern otellerde misafirlerin oda servisi taleplerini veya temizlik isteklerini iletebildiği mobil otel uygulamalarının faydası nedir?",
             ["İletişimi zorlaştırmak", "Hizmet hızını artırmak, talepleri doğrudan ilgili departmana aktarmak ve insan hatasını sıfırlamak", "Maliyetleri artırmak", "Santral yükünü artırmak"], 1,
             "Mobil uygulamalar üzerinden gelen talepler doğrudan ilgili kat görevlisinin veya garsonun ekranına düşer, servis süresi kısalır."),
            ("Otel veri güvenliğinde (misafir kredi kartı ve kimlik bilgileri) siber saldırılara karşı alınması gereken en temel önlem hangisidir?",
             ["Bilgisayarları kapatmak", "Veri şifreleme (SSL/PCI-DSS standartları) ve güçlü güvenlik duvarları (Firewall) kullanımı", "Şifreleri kağıda yazmak", "Yazılım kullanmamak"], 1,
             "Misafir veri güvenliği yasalarla korunmaktadır. Uluslararası standartlarda şifreleme sistemleri kullanmak zorunludur."),
            ("Otel işletmelerinde 'Yeşil BT (Green IT)' kavramı neyi savunur?",
             ["Bilgisayarların yeşile boyanmasını", "Düşük enerji tüketen donanımların seçilmesi, sunucu sanallaştırma ve elektronik atıkların geri dönüştürülmesini", "Yazıcıların kaldırılmasını", "Sadece gündüz çalışılmasını"], 1,
             "Green IT, otelin teknoloji altyapısının çevreye olan karbon ayak izini ve enerji tüketimini en aza indirmeyi hedefler."),
            ("Otel lobisinde kullanılan akıllı yönlendirme ekranlarının (Digital Signage) basılı yönlendirme tabelalarına göre avantajı nedir?",
             ["Çok ağır olmaları", "İçeriklerin (toplantı salonu isimleri, hava durumu vb.) anlık olarak uzaktan güncellenebilmesi ve kağıt israfını önlemesi", "Fiyatının ucuz olması", "Sadece geceleri çalışması"], 1,
             "Dijital tabelalar sayesinde her etkinlik için yeni kağıt afiş basılması önlenir, operasyonel hız ve çevre koruma sağlanır.")
        ]
    ]
    
    # Generate Alternatif Turizm (at12, 2 units)
    at_units = [
        # Unit 1
        [
            ("Sürdürülebilir turizmin kitle turizmine karşı ortaya çıkardığı, çevreye duyarlı ve küçük ölçekli turizm hareketlerinin genel adı nedir?",
             ["Lüks Turizm", "Alternatif Turizm", "Kitle Turizmi", "Kıyı Turizmi"], 1,
             "Geleneksel deniz-kum-güneş (kitle) turizminin yarattığı tahribata tepki olarak doğan doğa ve kültür odaklı türlere Alternatif Turizm denir."),
            ("Aşağıdakilerden hangisi kitle turizminin destinasyonlarda yarattığı en büyük olumsuz etkilerden biridir?",
             ["Yerel ekonomiyi tamamen yok etmesi", "Aşırı betonlaşma, çevre kirliliği ve yerel kültürün yozlaşması", "Turist sayısının azalması", "Ulaşımın yavaşlaması"], 1,
             "Kontrolsüz kitle turizmi aşırı kaynak tüketimine, doğa tahribatına ve kültürel kimliğin kaybolmasına yol açar."),
            ("Alternatif turizmin gelişiminde 'Taşıma Kapasitesi' kavramının hayati önem taşımasının temel sebebi nedir?",
             ["Daha büyük oteller yapmak", "Bölgenin ekolojik ve sosyal yapısının zarar görmeden kaldırabileceği maksimum turist sınırını korumak", "Bilet fiyatlarını artırmak", "Acente komisyonlarını düşürmer"], 1,
             "Taşıma kapasitesinin aşılması destinasyonun doğal cazibesini yok eder; bu yüzden alternatif turizm sınırlandırmaları savunur."),
            ("Aşağıdakilerden hangisi sürdürülebilir alternatif turizmin temel ilkelerinden biridir?",
             ["Kısa vadede yüksek kar elde etmek", "Yerel halkın kararlara katılımını sağlamak ve geliri tabana yaymak", "Tüm doğal alanları imara açmak", "Sadece yabancı zincirleri desteklemek"], 1,
             "Yerel halkın sürece dahil edilmesi ve gelir elde etmesi turizmin sosyal ve ekonomik açıdan sürdürülebilir olmasını sağlar."),
            ("Alternatif turizm kapsamında, doğal alanları koruyan ve yerel halkın refahını gözeten doğa seyahatlerine ne ad verilir?",
             ["Ekoturizm", "Kongre Turizmi", "Kruvaziyer Turizmi", "Macera Turizmi"], 0,
             "Ekoturizm, çevre bilincini artıran, küçük gruplarla yapılan ve yerel ekosisteme saygılı olan en yaygın alternatif turizm türüdür."),
            ("Destinasyonların turizm baskısı altında yok olmasını önlemek amacıyla uygulanan 'Ziyaretçi Yönetimi' neyi kapsar?",
             ["Fiyatları tamamen serbest bırakmayı", "Ziyaretçi sayılarını sınırlandırma, rotalama ve hassas koruma bölgeleri (zonlama) ilan etmeyi", "Daha fazla yol inşa etmeyi", "Turistleri tamamen yasaklamayı"], 1,
             "Ziyaretçi yönetimi, hassas ekosistemlerin aşırı turist yükü altında ezilmesini önleyen planlama teknikleridir."),
            ("Alternatif turizm pazarlamasında çevre dostu işletmeleri tescilleyen eko-etiketlerin (Mavi Bayrak, Yeşil Anahtar vb.) rolü nedir?",
             ["Maliyetleri artırmak", "Çevre bilinci yüksek bilinçli turistlerin (yeşil tüketiciler) güvenini kazanmak ve tercih edilmeyi sağlamak", "Rakipleri cezalandırmak", "Sadece vergi muafiyeti almak"], 1,
             "Eko-etiketler, tesisin çevre taahhütlerinin bağımsız kuruluşlarca onaylandığını göstererek prestij ve müşteri çeker."),
            ("Alternatif turizmin kırsal bölgelerde uygulanmasının yerel topluma en büyük ekonomik faydası nedir?",
             ["Tarımı tamamen bitirmesi", "Kırsal istihdam yaratarak köyden kente göçü önlemesi ve yerel ürünlerin değer kazanması", "Gökdelen sayısını artırması", "Herkesin otellerde çalışmasını sağlaması"], 1,
             "Kırsal turizm, tarım dışı ek gelir yaratarak köylünün kendi topraklarında refah içinde yaşamasını destekler."),
            ("Doğal ve kültürel varlıkların gelecek nesillerin de yararlanabileceği şekilde korunması sürdürülebilirliğin hangi boyutudur?",
             ["Ekonomik boyut", "Ekolojik (Çevresel) boyut", "Sosyo-Kültürel boyut", "Teknolojik boyut"], 1,
             "Ekolojik sürdürülebilirlik, gezegenin biyolojik çeşitliliğinin ve doğal kaynaklarının korunmasını hedefler."),
            ("Turizm kazancının yerel esnafa adil dağılması ve yerel kalkınmayı desteklemesi sürdürülebilirliğin hangi ilkesidir?",
             ["Çevresel Koruma", "Ekonomik Sürdürülebilirlik", "Kültürel Miras", "Teknolojik Dönüşüm"], 1,
             "Ekonomik sürdürülebilirlik, turizm kaynaklı refahın adilce yayılmasını ve uzun vadeli ekonomik canlılığı amaçlar."),
            ("Aşırı turizm (Overtourism) baskısını hafifletmek için alternatif turizm planlamasında kullanılan 'Coğrafi Yayılma' stratejisi nedir?",
             ["Turistleri tek bir plaja yığmak", "Turist akınını ana destinasyon dışındaki alternatif kırsal ve tarihi çekim merkezlerine yönlendirmek", "Otelleri kapatmak", "Fiyatları sürekli yükseltmek"], 1,
             "Turistleri geniş bir coğrafyaya dağıtmak, merkezlerdeki yoğunluk krizini çözerken çevre bölgelerin de kalkınmasını sağlar."),
            ("Alternatif turizm tüketicisi olan 'Yeşil Turistler' seyahat acentelerinden öncelikle ne talep ederler?",
             ["En ucuz plastik ürünleri sunmasını", "Çevreye en az karbon salınımı yapan transferleri, yerel rehberleri ve doğa dostu konaklamaları içeren turları", "Lüks devasa beton otelleri", "Hızlı ve tahrip edici av turlarını"], 1,
             "Bilinçli seyahat severler, karbon ayak izlerini en aza indirecek eko-duyarlı paketleri tercih ederler."),
            ("Bir bölgenin turizme açılmadan önce doğal ve tarihi envanterinin çıkarılması neden zorunludur?",
             ["Reklam bütçesini hesaplamak için", "Korunması gereken hassas değerleri saptamak ve planlamayı bu sınırlara göre yapmak için", "Oda numaralarını belirlemek için", "Sadece yasal formalite olduğu için"], 1,
             "Doğal kaynak envanteri, neyin nerede korunacağını belirleyen sürdürülebilir planlamanın temel haritasıdır."),
            ("Yerel mimariye aykırı, betonarme dev yapıların ekoturizm bölgelerine inşa edilmesi hangi ilkeye tamamen aykırıdır?",
             ["Lüks standartlarına", "Çevresel ve estetik sürdürülebilirliğe, ekolojik bütünlüğe", "Ekonomik karlılığa", "Teknolojik gelişmeye"], 1,
             "Eko-mimari, tesislerin doğayla bütünleşmesini ve yöresel dokuya (taş, ahşap) sadık kalınmasını yasal olarak şart koşar."),
            ("Alternatif turizm süreci sonucunda destinasyonların elde edeceği en büyük kazanç hangisidir?",
             ["Kaynakların hızla tükenmesi", "Uzun ömürlü, korunan, saygın ve marka değeri yüksek bir destinasyon kimliği", "Turist sayısının aniden sıfırlanması", "Sadece kışın açık kalan oteller"], 1,
             "Sürdürülebilir koruma, destinasyonun ömrünü uzatır ve nesiller boyu yüksek prestijli turizm yapılmasını garanti eder.")
        ],
        # Unit 2
        [
            ("Dağlık ve ormanlık bölgelerdeki temiz hava ve doğal yaşamdan yararlanmak amacıyla yapılan alternatif turizm türü hangisidir?",
             ["Sağlık Turizmi", "Yayla Turizmi", "Kongre Turizmi", "Kruvaziyer Turizmi"], 1,
             "Yayla turizmi, özellikle yaz aylarında serinlemek, doğayla baş başa kalmak ve yerel kültürü yaşamak için yapılan doğa odaklı turizmdir."),
            ("Yerel mutfak kültürünün, geleneksel yemeklerin ve gastronomi rotalarının ön plana çıktığı seyahat türüne ne denir?",
             ["Ekoturizm", "Gastronomi Turizmi", "Macera Turizmi", "Yat Turizmi"], 1,
             "Yemek kültürünü tanımak, yerel lezzetleri tatmak ve yemek atölyelerine katılmak amacıyla yapılan turlara Gastronomi Turizmi denir."),
            ("Şirketlerin, akademisyenlerin ve uluslararası kuruluşların toplantı, seminer ve kongre amacıyla seyahat etmesini kapsayan turizm türü hangisidir?",
             ["Gençlik Turizmi", "Kongre (MICE) Turizmi", "Yayla Turizmi", "İnanç Turizmi"], 1,
             "Kongre turizmi, sezon dışı aylarda yüksek gelir getiren ve altyapı gelişimini tetikleyen en önemli alternatif turizm türlerindendir."),
            ("Tarihi kutsal mekanları, mabetleri ziyaret etmek ve inanç ritüellerini gerçekleştirmek amacıyla yapılan turizm hangisidir?",
             ["Kültür Turizmi", "İnanç Turizmi", "Ekoturizm", "Sağlık Turizmi"], 1,
             "Farklı din ve inançlara ait kutsal destinasyonların (örn. Meryem Ana Evi, Şanlıurfa Göbeklitepe) ziyaret edilmesine İnanç Turizmi denir."),
            ("Deniz altı florasını ve batıkları gözlemlemek amacıyla profesyonel ekipmanlarla yapılan alternatif turizm faaliyeti hangisidir?",
             ["Yat Turizmi", "Dalış (Scuba Diving) Turizmi", "Kış Turizmi", "Yayla Turizmi"], 1,
             "Su altı dünyasını keşfetmek ve batıkları incelemek amacıyla yapılan turizm dalış turizmidir, yüksek güvenlik kurallarına tabidir."),
            ("Kar ve kış sporlarına (kayak, snowboard) dayalı, dağlık tesislerde kış aylarında gerçekleştirilen turizm türü hangisidir?",
             ["Yayla Turizmi", "Kış Turizmi", "Doğa Yürüyüşü", "Ekoturizm"], 1,
             "Kayak pistleri ve kış otelleri çevresinde gelişen, mevsimlik dalgalanmayı azaltan turizm dalı Kış Turizmidir."),
            ("Mağaraların doğal sarkıt, dikit oluşumlarını ve mikroklimasını gözlemlemek amacıyla yapılan turizm türü hangisidir?",
             ["Yayla Turizmi", "Mağara Turizmi", "Dağcılık", "Ekoturizm"], 1,
             "Mağara turizmi, jeolojik oluşumlara meraklı niş bir turist grubuna hitap eden macera ve doğa odaklı turizmdir."),
            ("Uluslararası standartlarda golf sahalarına sahip destinasyonlarda gerçekleştirilen, kişi başı harcaması en yüksek spor turizmi türü hangisidir?",
             ["Futbol Turizmi", "Golf Turizmi", "Yat Turizmi", "Ekoturizm"], 1,
             "Golf turizmi, üst gelir grubundaki elit turistleri çekerek destinasyonun gelir marjını devasa ölçüde yükseltir."),
            ("Termal suların, çamur banyolarının ve kaplıcaların şifa verici özelliklerinden yararlanmak amacıyla yapılan turizm türü hangisidir?",
             ["Macera Turizmi", "Termal (Kaplıca) Turizmi", "Kongre Turizmi", "Yayla Turizmi"], 1,
             "Mineralli sıcak su kaynakları çevresinde kurulan termal tesislerde sağlık ve zindelik (wellness) amaçlı konaklamalara Termal Turizm denir."),
            ("Kuşların göç yollarını, üreme alanlarını doğal ortamlarında gözlemlemek amacıyla yapılan ekoturizm faaliyeti hangisidir?",
             ["Av Turizmi", "Kuş Gözlemciliği (Ornitoloji) Turizmi", "Mağara Turizmi", "Botanik Turizmi"], 1,
             "Ornitoloji turizmi, doğaya sıfır zarar veren, yüksek eğitimli ve bilinçli doğaseverlerin katıldığı niş bir ekoturizm dalıdır."),
            ("Bölgedeki endemik bitki türlerini ve yabani çiçekleri doğal ortamında incelemek amacıyla yapılan botanik turizminin temel kuralı nedir?",
             ["Bitkileri koparıp eve götürmek", "Bitkilere zarar vermeden sadece gözlemlemek ve fotoğraflamak", "Bitki alanlarını imara açmak", "Bitki satışı yapmak"], 1,
             "Botanik turizminde biyoçeşitliliğin korunması esastır; hiçbir endemik tür koparılamaz veya zarar verilemez."),
            ("Yat sahiplerinin koyları gezmesi, marinalarda konaklaması ve deniz odaklı lüks harcamalar yapmasını kapsayan turizm hangisidir?",
             ["Kruvaziyer Turizmi", "Yat Turizmi", "Kıyı Turizmi", "Alternatif Turizm"], 1,
             "Yat turizmi lüks marinalar ve çekek yerleri altyapısı gerektiren, döviz girdisi en yüksek deniz turizmi segmentidir."),
            ("Tarihi antik kentleri, müzeleri ve arkeolojik kazı alanlarını ziyaret ederek geçmiş uygarlıkları tanıma amaçlı seyahat türü hangisidir?",
             ["İnanç Turizmi", "Kültür Turizmi", "Macera Turizmi", "Ekoturizm"], 1,
             "Kültür turizmi, insanlığın ortak mirasını, sanatını ve tarihini keşfetmeyi amaçlayan en köklü alternatif turizm türidir."),
            ("Macera arayan, adrenalin seviyesi yüksek doğa sporları (rafting, yamaç paraşütü vb.) içeren turizm türü hangisidir?",
             ["Kongre Turizmi", "Macera Turizmi", "Kış Turizmi", "İnanç Turizmi"], 1,
             "Macera turizmi, coğrafi engelleri ve doğal zorlukları aşarak sınırlarını test etmek isteyen dinamik turist grubuna hitap eder."),
            ("Üçüncü yaş ve medikal amaçlı gelen hastaların tedavisini ve rehabilitasyonunu kapsayan turizm dalı hangisidir?",
             ["Sağlık (Medikal) Turizmi", "Gençlik Turizmi", "Spor Turizmi", "Kültür Turizmi"], 0,
             "Sağlık turizmi, hastaneler ve kaplıcalar aracılığıyla uluslararası düzeyde şifa arayan hastalara sunulan profesyonel seyahat hizmetidir.")
        ]
    ]

    for uidx, ulist in enumerate(ki_units):
        for qidx, qdata in enumerate(ulist):
            qid = f"ki11_{uidx+1}_{qidx+1}"
            qtext, opts, cidx, expl = qdata
            questions.append((qid, "konaklama_isletmeciligi", uidx, qtext, opts, cidx, expl))

    for uidx, ulist in enumerate(at_units):
        for qidx, qdata in enumerate(ulist):
            qid = f"at12_{uidx+1}_{qidx+1}"
            qtext, opts, cidx, expl = qdata
            questions.append((qid, "alternatif_turizm", uidx, qtext, opts, cidx, expl))

    remaining_courses = {
        "kuru_temizleme_islemleri": {
            "prefix": "kt12",
            "units": [
                "İş Organizasyonu",
                "Kuru Temizleme Öncesi Hazırlık İşlemleri",
                "Kuru Temizleme İşlemleri",
                "Günlük/Periyodik Kontrol ve Bakımların Takibi",
                "Kuru Temizleme Gerektirmeyen Tekstil Ürünleri İçin Yıkama İşlemi"
            ],
            "topics": [
                ["İş sağlığı ve güvenliği", "Kişisel koruyucu donanım", " Solvent güvenliği", "Makine yerleşimi", "Havalandırma standartları"],
                ["Leke teşhisi", "Lif tespiti", "Ön leke çıkarma", "Aparatura hazırlık", "Ceplerin kontrolü"],
                ["Solvent kullanımı", "Perkloretilen", "Distilasyon işlemi", "Kurutma çevrimi", "Koku giderme prosedürü"],
                ["Filtre bakımı", "Solvent seviyesi kontrolü", "Çamur boşaltma", "Conta sızdırmazlığı", "Periyodik temizlik"],
                ["Hassas yıkama", "Dozajlama kuralları", "Sıkma devri", "Kurutma sıcaklığı", "Ütüleme pres ayarı"]
            ]
        },
        "camasirhane_islemleri": {
            "prefix": "ci12",
            "units": [
                "İş Organizasyonu",
                "Yıkama İşlemi",
                "Ütüleme İşlemi",
                "Depolama İşlemi"
            ],
            "topics": [
                ["Ergonomi ve düzen", "Kimyasal depolama", "Koruyucu donanım", "İş akışı planlama", "Yangın güvenliği"],
                ["Leke çıkarma kimyasalları", "Dozaj pompları", "Su sertliği", "Sıcaklık ayarları", "Sıkma aşamaları"],
                ["Silindir ütü", "Pres ütü", "Buhar jeneratörü", "Katlama standartları", "Askılama sistemleri"],
                ["Nemsiz depolama", "Raf düzeni", "Envanter takibi", "Paketleme poşeti", "Dağıtım arabaları"]
            ]
        },
        "dunya_seyahat_ve_turizm_cografyasi": {
            "prefix": "dc12",
            "units": [
                "Coğrafya ve Turizm",
                "Su Kaynaklarına Dayalı Turizm Merkezleri",
                "Manzara ve Doğal Yaşam Kaynaklarına Dayalı Turizm Merkezleri",
                "Tarihi Kaynaklara Dayalı Turizm Merkezleri",
                "Şehir ve Kruvaziyer Turizmi Merkezleri",
                "Kültür ve İnanç Turizmi Merkezleri",
                "Sağlık ve Spor Turizmi Merkezleri"
            ],
            "topics": [
                ["Turizm coğrafyasının tanımı", "İklimin turizme etkisi", "Ulaşım ağları", "Zaman dilimleri", "Doğal sınırlar"],
                ["Deniz turizmi", "Göller ve nehirler", "Şelaleler", "Fiyortlar", "Kanyonlar ve su yolları"],
                ["Milli parklar", "Yaban hayatı koruma", "Safari rotaları", "Dağcılık merkezleri", "Mağara sistemleri"],
                ["Antik kentler", "Kalıntılar", "Müzeler", "Dünya miras listesi", "Tarihi köprüler ve kaleler"],
                ["Metropol turizmi", "Kruvaziyer limanları", "Gemi rotaları", "Kıyı şehirleri", "Liman hizmetleri"],
                ["Dini mabetler", "Hac rotaları", "İnanç merkezleri", "Geleneksel festivaller", "Sanat müzeleri"],
                ["Kaplıcalar", "Termal tesisler", "Kayak merkezleri", "Golf sahaları", "Doğa yürüyüşü (Trekking) rotaları"]
            ]
        },
        "dunya_kulturleri": {
            "prefix": "dk12",
            "units": [
                "Dünya Kültürlerine Giriş",
                "Dünya Kültür Çeşitleri"
            ],
            "topics": [
                ["Kültür tanımı ve unsurları", "Kültürel etkileşim", "Gelenek ve görenekler", "Maddi ve manevi kültür", "Dil ve sanat coğrafyası"],
                ["Asya kültürleri", "Avrupa kültürleri", "Afrika kültürleri", "Amerikan kültürleri", "Ortadoğu gelenekleri"]
            ]
        },
        "kongre_ve_etkinlik_turizmi": {
            "prefix": "ke12",
            "units": [
                "Kongre ve Etkinlik Yönetimine Giriş",
                "Konaklama İşletmelerinde Toplantı ve Etkinlik Hizmetleri"
            ],
            "topics": [
                ["Kongre tanımı ve MICE", "Etkinlik planlama aşamaları", "Sözleşme yönetimi", "Bütçe hazırlığı", "Teknolojik altyapı"],
                ["Salon düzenleri", "Kahve molaları (Coffee break)", "Ziyafet (Banquet) yönetimi", "Protokol kuralları", "Geri bildirim ve değerlendirme"]
            ]
        },
        "gastronomi_turizmi": {
            "prefix": "gt12",
            "units": [
                "Gastronomi Turizmine Giriş",
                "Türkiye'de ve Dünyada Gastronomi Turizmi"
            ],
            "topics": [
                ["Gastronomi tanımı", "Yemek ve kimlik ilişkisi", "Coğrafi işaretli ürünler", "Gastronomi rotaları", "Mutfak müzeleri"],
                ["Türk mutfağı zenginliği", "Akdeniz mutfağı", "Uzakdoğu lezzetleri", "Sokak lezzetleri turizmi", "Michelin yıldızı standartları"]
            ]
        },
        "tur_operasyonu": {
            "prefix": "to12",
            "units": [
                "Turizm Kuralları ve Rehberlik",
                "Rehberlik Hizmetleri",
                "Paket Tur Hazırlama",
                "Tur Operasyonu için Hazırlık Yapma",
                "Tur Operasyonu Yapma",
                "Acente Operasyonlarını Gerçekleştirme"
            ],
            "topics": [
                ["Acentecilik yasası", "TÜRSAB kuralları", "Seyahat sigortası", "Vize prosedürleri", "Rehberlik kanunu"],
                ["Tur yönetimi", "Anlatım teknikleri", "Kriz yönetimi (ilk yardım)", "Protokol bilgisi", "Grup psikolojisi"],
                ["Maliyet hesaplama", "Ulaşım rezervasyonu", "Otel kontratları", "Tur rotası (itinerary) çizme", "Katalog hazırlığı"],
                ["Oda listesi (rooming list)", "Rehber brifingi", "Voucher hazırlama", "Evrak kontrolü", "Araç hazırlığı"],
                ["Tur kalkışı", "Zaman yönetimi", "Yolcu memnuniyeti takibi", "Restoran koordinasyonu", "Uğurlama prosedürü"],
                ["Acente muhasebesi", "İptal ve iade süreçleri", "Müşteri ilişkileri yönetimi", "Pazarlama kanalları", "Forecast analizleri"]
            ]
        },
        "transfer_operasyonu": {
            "prefix": "tr12",
            "units": [
                "İş Organizasyonu",
                "Müşteriyi (Misafiri) Karşılama",
                "Müşterinin (Misafirin) Ulaşımını Sağlama"
            ],
            "topics": [
                ["Sürücü güvenliği ve SRC", "Araç bakım ve temizlik", "İletişim protokolleri", "Rotalama planları", "İSG kuralları"],
                ["Havalimanı karşılama standı", "İsim tabelası protokolü", "Bagaj teslim ve etiketleme", "İlk izlenim standartları", "Gecikme takibi"],
                ["Güvenli sürüş kuralları", "Misafir konforu (iklimlendirme)", "Rota dışı durumlarda kriz yönetimi", "Otele varış ve bellboy teslimi", "Uğurlama standartları"]
            ]
        },
        "sosyal_medya": {
            "prefix": "sm12",
            "units": [
                "E-Ticaret",
                "Sosyal Medya",
                "Veri Analizi ve Grafikler"
            ],
            "topics": [
                ["E-ticaret modelleri (B2C, B2B)", "Ödeme altyapıları (3D Secure)", "Online rezervasyon motoru", "Sanal pos güvenliği", "Kişisel veri koruma (KVKK)"],
                ["Instagram ve Facebook otel pazarlaması", "Influencer iş birlikleri", "Görsel içerik kalitesi", "Müşteri mesajları yönetimi", "Online itibar yönetimi"],
                ["Google Analytics takibi", "Dönüşüm oranları (Conversion)", "Tıklama reklamları (PPC)", "Grafik okuma", "Bütçe optimizasyon raporları"]
            ]
        }
    }
    
    for course_id, cdata in remaining_courses.items():
        prefix = cdata["prefix"]
        units = cdata["units"]
        topics = cdata["topics"]
        
        for uidx, unit in enumerate(units):
            utopics = topics[uidx]
            for qnum in range(1, 16):
                qid = f"{prefix}_{uidx+1}_{qnum}"
                topic = utopics[(qnum - 1) % len(utopics)]
                
                if qnum == 1:
                    qtext = f"{unit} sürecinde {topic} konusunun en temel amacı aşağıdakilerden hangisidir?"
                    opts = [
                        f"Maliyetleri plansız şekilde azaltmak",
                        f"Operasyonel hata payını en aza indirmek ve standartlara uygun, güvenli bir çalışma ortamı sağlamak",
                        f"Tüm işleri manuel takibe almak",
                        f"Sadece reklam yapmak"
                    ]
                    cidx = 1
                    expl = f"{unit} biriminde {topic}, operasyonel kalitenin ve güvenliğin korunması için en temel standarttır."
                elif qnum == 2:
                    qtext = f"Aşağıdakilerden hangisi {unit} kapsamında {topic} uygulamalarında dikkat edilmesi gereken hayati bir unsurdur?"
                    opts = [
                        f"Rastgele ve kontrolsüz işlemler yapmak",
                        f"Yasal standartlara, hijyen kurallarına ve güvenlik prosedürlerine tam riayet edilmesi",
                        f"Sadece en pahalı markaları seçmek",
                        f"İşlemleri sürekli ertelemek"
                    ]
                    cidx = 1
                    expl = f"{topic} uygulamaları doğrudan yasal güvenlik ve kalite standartlarına tabidir."
                elif qnum == 3:
                    qtext = f"Otelcilik ve turizm işletmelerinde {topic} ile ilgili yapılacak hatalar en çok hangi olumsuz sonuca yol açar?"
                    opts = [
                        f"Hizmet kalitesinin düşmesine, müşteri memnuniyetsizliğine ve yasal cezalara",
                        f"Personelin daha yavaş çalışmasına",
                        f"Oda fiyatlarının kendiliğinden artmasına",
                        f"Hiçbir olumsuz etkisi yoktur"
                    ]
                    cidx = 0
                    expl = f"{topic} alanındaki eksiklikler doğrudan kaliteyi düşürür ve kurumsal itibara zarar verir."
                elif qnum == 4:
                    qtext = f"Aşağıdakilerden hangisi {unit} sürecinde {topic} için kullanılan profesyonel bir yöntemdir?"
                    opts = [
                        f"Kulaktan dolma bilgilerle tahminde bulunmak",
                        f"Uluslararası standartlarda kabul görmüş kontrol listeleri ve resmi formların kullanılması",
                        f"Tüm işi stajyerlere bırakmak",
                        f"Sadece seyahat bittikten sonra kontrol yapmak"
                    ]
                    cidx = 1
                    expl = f"Profesyonel turizm işletmeciliğinde {topic} her zaman yazılı kontrol formları ve resmi standartlar üzerinden yürütülür."
                elif qnum == 5:
                    qtext = f"İşletmelerde {unit} kapsamında {topic} uygulamalarının operasyonel verimliliğe ve hizmet kalitesine en önemli katkısı nedir?"
                    opts = [
                        f"Maliyetlerin kontrolsüz şekilde artmasına neden olmak",
                        f"Hizmet standartlarını yükselterek müşteri memnuniyeti sağlamak ve kaynakların etkin kullanılmasını kolaylaştırmak",
                        f"Sadece reklam bütçesini tüketmek",
                        f"Çalışanların mesleki sorumluluklarını sınırlandırmak"
                    ]
                    cidx = 1
                    expl = f"{topic} uygulamalarının standartlara uygun yürütülmesi, işletmenin hizmet kalitesini artırırken verimli bir çalışma düzeni sağlar."
                elif qnum == 6:
                    qtext = f"Aşağıdaki mesleki yaklaşımlardan hangisi {unit} içindeki {topic} sürecinde dürüstlük ve ahlak ilkelerine en uygundur?"
                    opts = [
                        f"Fiyatları veya kaliteyi misafirden gizlemek",
                        f"Misafire dürüst bilgi sunarak, hakkaniyetli fiyatlandırma ve şeffaf hizmet kalitesi sağlamak",
                        f"Sadece lüks konuklara iyi davranmak",
                        f"Rakipleri asılsız iddialarla karalamak"
                    ]
                    cidx = 1
                    expl = f"Turizm meslek ahlakının en temel kuralı, dürüstlük, misafirperverlik ve şeffaf hizmet kalitesidir."
                elif qnum == 7:
                    qtext = f"{unit} operasyonunda {topic} sürecini yöneten şefin en önemli idari sorumluluğu hangisidir?"
                    opts = [
                        f"Tüm işleri tek başına yapmak",
                        f"Ekibin görev dağılımını adil yapmak, iş güvenliği kurallarını denetlemek ve hizmet kalitesini sürekli kılmak",
                        f"Çalışanlar arasında ayrım yapmak",
                        f"Hata yapan personeli doğrudan cezalandırmak"
                    ]
                    cidx = 1
                    expl = f"Yöneticiler, hem iş gücünün adil yönetiminden hem de operasyonun standartlara uygun ve güvenli yürümesinden sorumludur."
                elif qnum == 8:
                    qtext = f"Misafirlerin {unit} kapsamında yer alan {topic} hizmetinden duydukları memnuniyeti Tripadvisor gibi online platformlarda paylaşmasının pazarlamaya etkisi nedir?"
                    opts = [
                        f"Hiçbir etkisi yoktur",
                        f"Otelin online itibarını yükselterek yeni konukların tercih etme kararını doğrudan olumlu etkiler",
                        f"Sadece maliyetleri yükseltir",
                        f"Çalışanların dinlenmesini sağlar"
                    ]
                    cidx = 1
                    expl = f"Müşteri yorumları günümüzde en etkili ve güvenilir ücretsiz pazarlama (itibar yönetimi) aracıdır."
                elif qnum == 9:
                    qtext = f"Aşağıdakilerden hangisi {unit} departmanında {topic} verimliliğini artırmanın en sürdürülebilir yoludur?"
                    opts = [
                        f"Personeli sürekli mesaiye bırakmak",
                        f"Düzenli hizmet içi eğitimler düzenlemek ve çalışan motivasyonunu yüksek tutmak",
                        f"En ucuz malzemeleri tercih etmek",
                        f"Teknolojiyi tamamen reddetmek"
                    ]
                    cidx = 1
                    expl = f"Nitelikli iş gücü eğitimi ve yüksek motivasyon, turizmde sürdürülebilir hizmet kalitesinin anahtarıdır."
                elif qnum == 10:
                    qtext = f"{unit} sırasında {topic} ile ilgili bir kriz anında yapılması gereken en doğru ilk müdahale hangisidir?"
                    opts = [
                        f"Panik yapıp olayı gizlemeye çalışmak",
                        f"Önceden belirlenmiş acil durum eylem planına göre sakinlikle hareket edip yetkililere ve ilgili departmanlara anında bilgi vermek",
                        f"İşi tamamen yarıda bırakıp kaçmak",
                        f"Sorumluluğu stajyerlerin üzerine atmak"
                    ]
                    cidx = 1
                    expl = f"Kriz yönetiminde sakinlik, önceden hazırlanmış acil durum planlarına sadık kalınması ve hızlı iletişim hayati önem taşır."
                elif qnum == 11:
                    qtext = f"Aşağıdakilerden hangisi {unit} standartlarında {topic} için kullanılan çevre dostu (ekolojik) bir yaklaşımdır?"
                    opts = [
                        f"Enerji ve su tüketimini en aza indiren teknolojiler ile geri dönüştürülebilir malzemelerin tercih edilmesi",
                        f"Tüm atıkları çöpe dökmek",
                        f"Plastik malzemelerin kullanımını artırmak",
                        f"Sadece ithal kimyasallar kullanmak"
                    ]
                    cidx = 0
                    expl = f"Çevre dostu turizm yaklaşımı, kaynak israfını önleyerek karbon ayak izini düşürmeyi hedefler."
                elif qnum == 12:
                    qtext = f"Operasyonel açıdan, {unit} içinde {topic} takibinin günlük olarak yapılması otel yönetimine ne sağlar?"
                    opts = [
                        f"İşlerin aksamasını, arıza maliyetlerini ve misafir şikayetlerini önceden engelleme imkanı",
                        f"Maaşların düşürülmesini",
                        f"Otelin yıldız sayısının anında yükselmesini",
                        f"Personel sayısının azaltılmasını"
                    ]
                    cidx = 0
                    expl = f"Günlük periyodik denetimler, olası büyük arızaları ve konuk şikayetlerini kaynağında engelleyen koruyucu bir kalkandır."
                elif qnum == 13:
                    qtext = f"{unit} sürecinde {topic} ile ilgili yasal mevzuatlara, standartlara ve güvenlik kurallarına uyulmaması en çok hangi riski doğurur?"
                    opts = [
                        f"Büyük maddi kayıplar, iş kazaları, hukuki yaptırımlar ve marka itibarının ciddi şekilde zarar görmesi",
                        f"Personelin daha hızlı tecrübe kazanmasını sağlamak",
                        f"Müşteri taleplerinin kendiliğinden artması",
                        f"Sadece reklam faaliyetlerinin yavaşlaması"
                    ]
                    cidx = 0
                    expl = f"{topic} alanındaki yasal kurallara ve güvenlik standartlarına riayet edilmemesi, ciddi iş kazalarına ve prestij kaybına yol açar."
                elif qnum == 14:
                    qtext = f"Girişimcilik ve iş planlaması açısından, {unit} kapsamında {topic} için bütçe hazırlanırken hangisi en büyük riski oluşturur?"
                    opts = [
                        f"Pazar analizini eksik yapmak ve beklenmeyen gider kalemlerini bütçeye eklememek",
                        f"Bütçeyi bilgisayarda hazırlamak",
                        f"En kaliteli ekipmanları satın almak",
                        f"Ekibi önceden kurmak"
                    ]
                    cidx = 0
                    expl = f"Finansal planlamada pazarın gerçekçi analizi ve yedek akçe (acil durum bütçesi) ayrılması hayati öneme sahiptir."
                elif qnum == 15:
                    qtext = f"Otelcilikte {unit} sürecinde {topic} ile ilgili misafir şikayeti alındığında, resepsiyonistin sergilemesi gereken en profesyonel karşılama hangisidir?"
                    opts = [
                        f"Savunmaya geçip hatayı kabul etmemek",
                        f"Misafiri sakinlikle ve etkin bir şekilde dinleyip, özür dileyerek hatayı telafi edecek hızlı ve profesyonel çözümü anında sunmak",
                        f"Misafire diğer otellere gitmesini tavsiye etmek",
                        f"Şikayeti tamamen duymazdan gelmek"
                    ]
                    cidx = 1
                    expl = f"Müşteri şikayetleri dinlenip hızla telafi edildiğinde, misafirin otele olan bağlılığı ve güveni daha da artmaktadır."
                
                questions.append((qid, course_id, uidx, qtext, opts, cidx, expl))
                
    return questions

def run():
    print("Generating questions...")
    predefined_list = generate_questions()
    print(f"Total questions generated: {len(predefined_list)}")
    
    with open(QUIZ_FILE, "r", encoding="utf-8") as f:
        content = f.read()
        
    # Programmatically truncate the file at the end of the handcrafted questions (kg10_4_15)
    target_marker = "id: 'kg10_4_15'"
    idx = content.find(target_marker)
    if idx == -1:
        # Fallback in case of ID naming variations
        target_marker = "id: 'kgc10_4_15'"
        idx = content.find(target_marker)
        
    if idx == -1:
        print("Error: Could not find the handcrafted base questions in quiz_data.dart")
        return
        
    closing_idx = content.find("),", idx)
    if closing_idx == -1:
        print("Error: Could not find closing of kg10_4_15 block")
        return
        
    handcrafted_base = content[:closing_idx + 2] + "\n\n"
    
    new_questions_dart = []
    for q in predefined_list:
        qid, cid, uidx, qtext, opts, cidx, expl = q
        qtext_esc = qtext.replace("'", "\\'")
        opts_esc = [o.replace("'", "\\'") for o in opts]
        expl_esc = expl.replace("'", "\\'")
        
        dart_obj = f"  QuizQuestion(id: '{qid}', courseId: '{cid}', unitIndex: {uidx},\n" \
                   f"    questionText: '{qtext_esc}',\n" \
                   f"    options: ['{opts_esc[0]}', '{opts_esc[1]}', '{opts_esc[2]}', '{opts_esc[3]}'],\n" \
                   f"    correctOptionIndex: {cidx},\n" \
                   f"    explanation: '{expl_esc}',\n" \
                   f"  ),"
        new_questions_dart.append(dart_obj)
        
    all_new_questions_str = "\n" + "\n".join(new_questions_dart) + "\n"
    updated_content = handcrafted_base + all_new_questions_str + "];\n"
    
    with open(QUIZ_FILE, "w", encoding="utf-8") as f:
        f.write(updated_content)
        
    print("Successfully integrated all 615 questions!")

if __name__ == "__main__":
    run()
