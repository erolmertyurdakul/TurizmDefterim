/// 11. Sınıf Ön Büro Hizmetleri Atölyesi Dersi Ders Notları Veri Tabanı
/// MEB Müfredatı ve Yasal Kaynaklar (1774 Sayılı Kimlik Bildirme Kanunu, VUK 213, TTK 6102, Tekdüzen Hesap Planı) ile Doğrulanmıştır.

const Map<String, dynamic> onBuroHizmetleriUnit1 = {
  "title": "Sabah ve Akşam Vardiyası İşlemleri",
  "learningUnit": "1. Öğrenme Birimi",
  "podcastUrl": null,
  "cards": [
    {
      "id": 1,
      "tag": "SABAH VARDİYASI & CHECK-OUT",
      "title": "GÜNLÜK ÇIKIŞ (CHECK-OUT) VE ERKEN AYRILMA YÖNETİMİ",
      "microSummary": "Sabah vardiyası resepsiyonisti güne çıkış yapacak konukların takibiyle başlar; hesapları sıfırlar, anahtarları teslim alır ve boşalan odaları Kat Hizmetlerine haber verir.",
      "definitions": [
        {
          "name": "Çıkış (Check-Out) Listesi Kontrolü",
          "desc": "Sabah 08:00 vardiyasında otomasyon sisteminden çekilen, o gün ayrılacak konukların oda numaralarını, ödeme tiplerini ve harcama folyolarını gösteren takip belgesidir.",
          "examples": [
            "Örnekle Pekiştirelim: Resepsiyonist sabah saat 08:30'da sistemden çıkış listesini alır. Bugün ayrılacak 15 odanın hesaplarını inceler, saat 12:00'ye kadar tüm ödemelerin nakit veya pos ile kapatıldığını doğrulayarak oda kartlarını teslim alır."
          ]
        },
        {
          "name": "Erken Ayrılma (Early Check-Out) Yönetimi",
          "desc": "Misafirin planlanan tarihten daha önce otelden ayrılmak istemesi durumudur. Acente sözleşmesi ve ceza koşulları incelenerek hesap kapatılır, oda Kat Hizmetlerine bildirilir.",
          "examples": [
            "Örnekle Pekiştirelim: 4 gece kalacak olan bir misafir 2. günün sabahı acil işi çıktığı için ayrılmak istediğinde; resepsiyonist acente sözleşmesini kontrol eder, kullanılmayan gecelerin iade prosedürünü uygular ve odayı boş temiz duruma geçirtir."
          ]
        }
      ],
      "caseStudy": "Örnek Olay: Folyoda Unutulan Minibar Harcaması\n\nOlay: Misafir oda hesabını ödeyip anahtarı verir ve otelden ayrılır. 5 dakika sonra Kat Hizmetleri görevlisi odada 2 adet minibar meşrubatının tüketildiğini bildirir.\n\nÇözüm: Resepsiyon personeli konuk henüz otelden ayrılmamışsa nezaketle durumu anlatıp tahsilatı yapar; ayrılmışsa kart provizyonundan çekim yapıp adisyon fişini faturaya ekler.",
      "tip": "İpucu: Sabah vardiyasında çıkış listesi incelenirken ilk olarak uyandırma servisi istenen odaların saatleri kontrol edilmelidir."
    },
    {
      "id": 2,
      "tag": "HOUSEKEEPING MUTABAKATI",
      "title": "DOLU / BOŞ ODA DENETİMİ VE MUTABAKAT SAĞLAMA",
      "microSummary": "Resepsiyon sistemindeki oda durumları ile Kat Hizmetlerinin (Housekeeping) katlarda fiziki olarak yaptığı denetim raporu karşılaştırılarak uyuşmazlıklar çözülür.",
      "definitions": [
        {
          "name": "Kat Hizmetleri (Housekeeping) Raporu",
          "desc": "Kat görevlilerinin her sabah odaları dolaşarak fiziki durumu (Dolu-Temiz, Dolu-Kirli, Boş-Temiz, Arızalı) kaydettiği günlük kontrol listesidir.",
          "examples": [
            "Örnekle Pekiştirelim: Kat görevlisi 304 nolu odaya girdiğinde yatağın bozuk olduğunu ama odada valiz bulunmadığını fark edince rapora 'Dolu/Boş Uyuşmazlığı' (Discrepancy) notunu yazar."
          ]
        },
        {
          "name": "Oda Durum Mutabakatı (Housekeeping Discrepancy)",
          "desc": "Resepsiyon bilgisayarındaki oda durumu ile kat raporundaki fiziki oda durumu uyuşmadığında yapılan fiziki ve sistemsel doğrulama işlemidir.",
          "examples": [
            "Örnekle Pekiştirelim: Sistemde 201 nolu oda 'Boş' görünürken kat raporunda 'Dolu' görünüyorsa; resepsiyonist gece kayıtsız konuk girip girmediğini veya yanlış odaya anahtar verilip verilmediğini araştırır."
          ]
        }
      ],
      "caseStudy": "Örnek Olay: Sistemde Boş Görünen Odada Konuk Eşyası\n\nOlay: Saat 11:30'da Kat Hizmetleri raporu gelir. 105 nolu oda resepsiyon sisteminde 'Çıkış Yapmış/Boş' görünmektedir ancak odada eşyalar vardır.\n\nÇözüm: Resepsiyonist misafiri telefonla arar. Misafirin çıkış saatini karıştırdığı anlaşılınca oda durumu sistemde 'Geç Çıkış (Late Check-out)' olarak düzeltilir ve ek ücret onaylatılır.",
      "tip": "İpucu: Kat Hizmetleri raporu ile resepsiyon mutabakatı tamamlanmadan yeni gelen konuğa asla oda anahtarı verilmemelidir."
    },
    {
      "id": 3,
      "tag": "AKŞAM VARDİYASI & FORECAST",
      "title": "GÜNLÜK GİRİŞLER VE DOLULUK TAHMİNİ (FORECAST)",
      "microSummary": "Akşam vardiyası yeni gelen konukların giriş (Check-in) işlemleriyle ilgilenir; otelin gelecek dönem doluluk tahminlerini (Forecast) analiz eder.",
      "definitions": [
        {
          "name": "Günlük Giriş (Check-In) Listesi Kontrolü",
          "desc": "O gün otele giriş yapacak konukların isimleri, VIP durumları, oda tercihleri ve özel isteklerinin (deniz manzarası, yüksek kat vb.) önceden hazırlanmasıdır.",
          "examples": [
            "Örnekle Pekiştirelim: Resepsiyonist saat 14:30'da sisteme girer; bugün gelecek 30 misafirin oda atamalarını (blokaj) yapar ve balayı çiftinin odasına özel ikram hazırlatır."
          ]
        },
        {
          "name": "Forecast (Doluluk Tahmini) Raporu",
          "desc": "Otelin gelecek günlük, haftalık ve aylık süreçte kaç oda satacağını ve ne kadar gelir elde edeceğini öngören stratejik tahmin raporudur.",
          "examples": [
            "Örnekle Pekiştirelim: Ön Büro Müdürü gelecek aydaki kongre sebebiyle Forecast raporunda doluluğun %98 olacağını görür ve resepsiyona oda satış fiyatlarını yükseltme talimatı verir."
          ]
        }
      ],
      "caseStudy": "Örnek Olay: Yüksek Sezonda Çifte Rezervasyon (Overbooking)\n\nOlay: Saat 21:00'de rezervasyonlu konuk gelir ancak oteldeki tüm odalar tamamen doludur.\n\nÇözüm: Ön büro memuru Forecast raporunu inceler. Overbooking nedeniyle konuk derhal aynı kalitedeki yakındaki anlaşmalı otele taksiyle transfer edilir ve ilk gece konaklaması otel tarafından karşılanır.",
      "tip": "İpucu: Geç geleceğini bildiren konukların rezervasyonlarına 'Garanti Edilmiş Rezervasyon' notu eklenerek odaları muhafaza edilmelidir."
    },
    {
      "id": 4,
      "tag": "VARDİYA DEVİR TESLİMİ",
      "title": "VARDİYA DEVİR TESLİMİ VE KASA KONTROLÜ",
      "microSummary": "Vardiya değişiminde resepsiyonist Seyir Defterini okuyarak kasayı, anahtarları ve tamamlanmayan takip işlerini sonraki arkadaşına imzayla teslim eder.",
      "definitions": [
        {
          "name": "Seyir Defteri (Logbook) Devri",
          "desc": "Vardiya sırasında gerçekleşen önemli olayların, takipli konuk isteklerinin ve arızaların yazıldığı dahili takip defteridir.\n\n📊 VARDİYA SAATLERİ VE GÖREV DÜZENİ TABLOSU:\n• Sabah Vardiyası (08.00 - 16.00): Çıkışlar, Fatura Kapatma ve Kat Mutabakatı\n• Akşam Vardiyası (16.00 - 24.00): Girişler, Restoran Harcamaları ve Oda Blokajları\n• Gece Vardiyası (24.00 - 08.00): Night Audit, POS Kapanışları ve Gün Sonu Raporları",
          "examples": [
            "Örnekle Pekiştirelim: Sabah vardiyası memuru Seyir Defterine '501 nolu odanın kliması soğutmuyor, teknik servis saat 17:30'da kontrol edecek' notunu düşer."
          ]
        },
        {
          "name": "Resepsiyon Kasası Devri (Cash Float)",
          "desc": "Vardiya sonundaki nakit avansın, gün içinde toplanan nakit ve POS adisyonlarının sayılarak tamı tamına sonraki vardiyaya devredilmesidir.",
          "examples": [
            "Örnekle Pekiştirelim: Sabah görevlisi kasadaki 4.000 TL bozuk para avansını ve gün boyu toplanan 9.500 TL nakit parayı sayarak akşam görevlisine teslim eder."
          ]
        }
      ],
      "caseStudy": "Örnek Olay: Kasa Devrinde 150 TL Açık Çıkması\n\nOlay: Vardiya devri sırasında kasada bulunması gereken tutardan 150 TL eksik olduğu görülür.\n\nÇözüm: Devreden ve devralan memurlar gün içindeki nakit adisyonları ve POS fişlerini inceler. Bir konuğun nakit ödemesinin yanlışlıkla 'Kredi Kartı' girildiği tespit edilerek kayıt düzeltilir.",
      "tip": "İpucu: Vardiya devir tesliminde kasa fiziki olarak sayılmadan ve Seyir Defteri okunmadan kesinlikle devir imzası atılmamalıdır."
    }
  ]
};

const Map<String, dynamic> onBuroHizmetleriUnit2 = {
  "title": "Gece İşlemlerini Yapma",
  "learningUnit": "2. Öğrenme Birimi",
  "podcastUrl": null,
  "cards": [
    {
      "id": 1,
      "tag": "NIGHT AUDIT ÖNCESİ",
      "title": "GÜN SONU ÖNCESİ GİRİŞ/ÇIKIŞ VE NO-SHOW KONTROLÜ",
      "microSummary": "Gece resepsiyonisti (Night Auditor), gün sonu çalışmasını (Night Audit) başlatmadan önce sisteme girilmeyen işlemleri ve No-Show odaları denetler.",
      "definitions": [
        {
          "name": "No-Show (Gelmeyen Konuk) İşlemi",
          "desc": "Garanti edilmiş rezervasyonu bulunduğu halde otele gelmeyen ve iptal bildirmeyen konukların odasının No-Show konumuna alınıp 1 gecelik cezanın fatura edilmesidir.",
          "examples": [
            "Örnekle Pekiştirelim: Gece saat 02:00'ye kadar gelmeyen garanti rezervasyonlu misafir için gece denetçisi odasını No-Show yapar ve 1 gecelik ücreti kredi kartından tahsil eder."
          ]
        },
        {
          "name": "Gündüz Giriş / Çıkış Denetimi",
          "desc": "Gündüz gerçekleştiği halde sisteme 'Check-in' veya 'Check-out' olarak basılması unutulmuş işlemlerin gece tespit edilip kapatılmasıdır.",
          "examples": [
            "Örnekle Pekiştirelim: Gece denetçisi 104 nolu odanın sistemde hâlâ giriş yapmadı göründüğünü fark eder; kayıt kartını inceleyip konuğun saat 19:00'da geldiğini teyit ederek girişi onaylar."
          ]
        }
      ],
      "caseStudy": "Örnek Olay: Oda Fiyatının Sıfır (0 TL) Unutulması\n\nOlay: Gece denetçisi rapor alırken 205 nolu odanın konaklama fiyatının sisteme '0 TL' girildiğini görür.\n\nÇözüm: Gece denetçisi acente konfirmasyon belgesini inceler, anlaşmalı fiyatın 1.800 TL olduğunu belirleyerek sisteme işler ve gün sonu kapatmasını hatasız gerçekleştirir.",
      "tip": "İpucu: Night Audit başlatılmadan önce sistemde 'Beklenen Giriş' (Expected Arrival) statüsünde hiç oda bırakılmamalıdır."
    },
    {
      "id": 2,
      "tag": "GÜN SONU KAPANISI",
      "title": "POS, YAZAR KASA VE OTOMASYON GÜN SONU (NIGHT AUDIT)",
      "microSummary": "Gece saat 02:00-04:00 arasında tüm restoran POS makineleri, yazar kasalar ve otel otomasyonu kapatılarak oda ücretleri folyolara otomatik basılır.",
      "definitions": [
        {
          "name": "Oda Ücretlerinin Otomatik Basılması (Room Posting)",
          "desc": "Night Audit çalıştırıldığında, oteldeki tüm dolu odaların konaklama bedeli ve vergilerinin (KDV + %2 Konaklama Vergisi) sistem tarafından folyolara otomatik borç yazılmasıdır.",
          "examples": [
            "Örnekle Pekiştirelim: Night Audit butonuna basıldığında otelde konaklayan 85 odanın günlük ücret ve vergileri tek bir tıkla aynı saniyede hesaplarına aktarılır."
          ]
        },
        {
          "name": "POS ve Yazar Kasa Z Raporu Kapanışı",
          "desc": "Restoran ve barlardaki POS cihazlarından mali kapanış raporu (Z Raporu) alınarak restoran gelirlerinin ön büro sistemiyle eşitlenmesidir.",
          "examples": [
            "Örnekle Pekiştirelim: Havuz bar POS cihazından alınan Z raporundaki 28.000 TL'lik toplam ciro ile ön büro sistemindeki harcamalar karşılaştırılarak mali kapanış yapılır."
          ]
        }
      ],
      "caseStudy": "Örnek Olay: Gece Yarısı POS Cihazı İletişim Hatası\n\nOlay: Restoran POS cihazı gün sonu alınırken internet bağlantısı kopar ve Z Raporu hatası verir.\n\nÇözüm: Gece resepsiyonisti cihazı manuel Z raporu moduna alır, fiziki slip toplamlarını sistemle manuel eşleştirir ve arızayı Seyir Defterine yazarak muhasebeye iletir.",
      "tip": "İpucu: Otel otomasyon gün sonu çalışırken veritabanı yedeklemesi yapıldığı için bilgisayardan başka işlem yapılmamalıdır."
    }
  ]
};

const Map<String, dynamic> onBuroHizmetleriUnit3 = {
  "title": "Ön Büroda Tutulan Defterler",
  "learningUnit": "3. Öğrenme Birimi",
  "podcastUrl": null,
  "cards": [
    {
      "id": 1,
      "tag": "YASAL DEFTERLER",
      "title": "POLİS DEFTERİ (KBS 1774 KANUNU) VE ŞİKÂYET DEFTERLERİ",
      "microSummary": "Resepsiyonda bulunması kanunen zorunlu olan Polis Defteri (1774 Sayılı Kanun) ve Konuk Şikâyet Defteri, resmi denetimlerde ilk incelenen belgelerdir.",
      "definitions": [
        {
          "name": "Polis Defteri (Konaklama Kayıt Defteri - KBS)",
          "desc": "1774 Sayılı Kimlik Bildirme Kanunu uyarınca otele giriş yapan tüm konukların T.C. Kimlik / Pasaport bilgilerinin Emniyet/Jandarma KBS sistemine anlık bildirildiği yasal kayıttır.\n\n📊 ÖN BÜRO DEFTERLERİ ZORUNLULUK TABLOSU:\n• Polis Defteri (KBS): KANUNEN ZORUNLU (1774 Sayılı Kanun)\n• Şikâyet Defteri: KANUNEN ZORUNLU (Kültür ve Turizm Bakanlığı)\n• Seyir Defteri: İSTEĞE BAĞLI (Vardiya Devri ve İç İletişim)\n• Şeref Defteri: İSTEĞE BAĞLI (VIP ve Protokol Notları)\n• Anahtar Kayıt Defteri: İSTEĞE BAĞLI (Güvenlik ve Master Anahtar)",
          "examples": [
            "Örnekle Pekiştirelim: Otele giriş yapan her konuğun kimlik bilgileri resepsiyonda Kimlik Bildirim Sistemi (KBS) üzerinden anlık olarak Emniyet / Jandarma veri tabanına iletilir."
          ]
        },
        {
          "name": "Konuk Şikâyet ve Memnuniyet Defteri",
          "desc": "Kültür ve Turizm Bakanlığı denetim standartları gereğince resepsiyon bankosunda konukların kullanımına açık bulundurulan resmi bildirim defteridir.",
          "examples": [
            "Örnekle Pekiştirelim: Odasındaki klimanın gürültüsünden rahatsız olan misafir, resepsiyondaki şikâyet defterine tarih ve oda numarası yazarak durumun düzeltilmesini talep eder."
          ]
        }
      ],
      "caseStudy": "Örnek Olay: Emniyet Denetiminde Eksik Kimlik Bildirimi\n\nOlay: Gece polis denetiminde 302 nolu odada 2 kişi kalırken KBS sisteminde sadece 1 kişinin kayıtlı olduğu anlaşılır.\n\nÇözüm: Otel yönetimi 1774 Sayılı Kanun gereğince idari para cezası alır. Ön büro müdürü, resepsiyonda kimlik alınmadan oda kartı teslim edilmesini kesinlikle yasaklar.",
      "tip": "İpucu: 1774 Sayılı Kimlik Bildirme Kanununa göre otele giriş yapan 0 yaş dahil tüm bireylerin kimlik bilgileri KBS sistemine girilmek zorundadır."
    },
    {
      "id": 2,
      "tag": "İSTEĞE BAĞLI DEFTERLER",
      "title": "SEYİR, ŞEREF VE ANAHTAR KAYIT DEFTERLERİ",
      "microSummary": "Yasal zorunluluğu olmayıp otel operasyonunun pürüzsüz işlemesi ve kurumsal hafıza için tutulan iç takip defterleridir.",
      "definitions": [
        {
          "name": "Seyir Defteri (Shift Logbook)",
          "desc": "Vardiyalar arasında bilgi akışını sağlayan, arızaları, özel istekleri ve takipli işleri içeren dahili iletişim defteridir.",
          "examples": [
            "Örnekle Pekiştirelim: '405 nolu odanın havaalanı transfer taksisi sabah 06:30 için ayarlandı' notunun Seyir Defterine yazılmasıdır."
          ]
        },
        {
          "name": "Anahtar Kayıt Defteri (Key Control Log)",
          "desc": "Paspartu (Master) anahtarları ve depo anahtarlarını teslim alan personelin imza karşılığı kaydolduğu güvenlik defteridir.",
          "examples": [
            "Örnekle Pekiştirelim: Kat hizmetleri şefinin sabah kat master anahtarını alırken saat belirterek Anahtar Kayıt Defterini imzalamasıdır."
          ]
        }
      ],
      "caseStudy": "Örnek Olay: Önemli Yabancı Büyükelçinin Ziyareti\n\nOlay: Otelde konaklayan bir büyükelçi ayrılırken otel hizmetlerinden çok memnun kaldığını söyler.\n\nÇözüm: Ön büro müdürü kendisinden otelin Şeref Defterine (VIP Guestbook) duygu ve düşüncelerini yazıp imzalamasını rica eder; bu belge otel arşivinde saklanır.",
      "tip": "İpucu: Kat master anahtarı asla imzasız şekilde personele teslim edilmemeli ve mesai sonunda Anahtar Kayıt Defteri kontrol edilerek geri alınmalıdır."
    }
  ]
};

const Map<String, dynamic> onBuroHizmetleriUnit4 = {
  "title": "Mesleki Matematik Aritmetiği",
  "learningUnit": "4. Öğrenme Birimi",
  "podcastUrl": null,
  "cards": [
    {
      "id": 1,
      "tag": "PRATİK ARİTMETİK",
      "title": "KOLAY HESAPLAMA YÖNTEMLERİ VE İŞLEM SAĞLAMALARI",
      "microSummary": "Resepsiyonda hızlı ve hatasız döviz, adisyon ve oda fiyatı hesabı yapabilmek için zihinden pratik çarpma/bölme ve sağlam alma teknikleri kullanılır.",
      "definitions": [
        {
          "name": "Pratik Çarpma ve Bölme Yolları",
          "desc": "Zihinden hızlı hesaplama yapmak için sayıları 10, 100, 1000 katlarına tamamlayarak veya 5, 25, 50 sayılarına pratik bölme kurallarıyla işlem yapmaktır.",
          "examples": [
            "Örnekle Pekiştirelim: 160 TL tutarındaki kahvaltı ücretini 5 ile çarpmak yerine; 160'ı 10 ile çarpıp (1600) ikiye bölerek (800 TL) zihinden saniyeler içinde hesaplamaktır."
          ]
        },
        {
          "name": "İşlemlerin Sağlamasını Yapma",
          "desc": "Fatura ve folyo toplamlarında yapılan hesaplamaların doğru olup olmadığını ters işlem yöntemiyle kontrol etmektir.",
          "examples": [
            "Örnekle Pekiştirelim: 5 oda × 1.400 TL = 7.000 TL tutarındaki oda hesabının sağlamasını yapmak için 7.000 TL'yi 5'e bölerek 1.400 TL oda fiyatına ulaşıldığını doğrulamaktır."
          ]
        }
      ],
      "caseStudy": "Örnek Olay: Sistem Arızasında Zihinden Hesaplama\n\nOlay: Elektrik kesintisi nedeniyle bilgisayarlar kapanır. Bankoda bekleyen 6 kişilik grup nakit ödeme yapıp ayrılmak ister.\n\nÇözüm: Resepsiyonist pratik matematik yöntemiyle kişi başı 350 TL olan tutarı (6 × 350 = 6 × 700 / 2 = 2.100 TL) zihinden hesaplar ve manuel makbuz keserek konukları uğurlar.",
      "tip": "İpucu: Bir sayıyı 25 ile çarpmak için sayının sonuna iki sıfır ekleyip çıkan sonucu 4'e bölmek en hızlı pratik yoldur."
    },
    {
      "id": 2,
      "tag": "YÜZDE VE BİNDE HESAPLARI",
      "title": "YÜZDE (%) VE BİNDE (‰) HESAPLAMALARI",
      "microSummary": "Otelcilikte KDV, Konaklama Vergisi (%2), Acente Komisyonları ve Servis Ücreti hesaplamalarında yüzde yöntemleri kullanılır.",
      "definitions": [
        {
          "name": "Yüzde (%) Hesaplama Yöntemi",
          "desc": "Bir anaparanın belirlenen yüzde oranında artırılması (KDV ekleme) veya azaltılması (İskonto düşme) işlemidir.",
          "examples": [
            "Örnekle Pekiştirelim: 3.000 TL tutarındaki konaklama bedeline %2 Konaklama Vergisi eklemek için: 3.000 × (2 / 100) = 60 TL vergi hesaplanır. Toplam tutar 3.060 TL olur."
          ]
        },
        {
          "name": "KDV Dahil Tutardan Matrah Bulma",
          "desc": "Faturadaki KDV dahil toplam tutardan, vergisiz ham tutarı (matrah) ayrıştırma işlemidir.",
          "examples": [
            "Örnekle Pekiştirelim: KDV Dahil (%10) 1.100 TL olan faturanın matrahını bulmak için tutar (1 + 0,10 = 1,10)'a bölünür: 1.100 / 1,10 = 1.000 TL KDV Hariç Matrah bulunur."
          ]
        }
      ],
      "caseStudy": "Örnek Olay: KDV Hesabında Yapılan Yaygın Hata\n\nOlay: Yeni işe başlayan resepsiyonist KDV dahil 1.100 TL'lik tutardan %10 (110 TL) düşerek matrahı 990 TL hesaplar.\n\nÇözüm: Ön büro muhasebecisi uyarır: KDV dahil tutardan matrah bulunurken doğrudan yüzde düşülmez; tutar 1,10'a bölünür (1.100 / 1,10 = 1.000 TL). Hatalı hesap düzeltilir.",
      "tip": "İpucu: KDV dahil tutardan matrah bulunurken tutar (1 + KDV Oranı)'na bölünmelidir."
    }
  ]
};

const Map<String, dynamic> onBuroHizmetleriUnit5 = {
  "title": "Mesleki Matematik Hesaplamaları",
  "learningUnit": "5. Öğrenme Birimi",
  "podcastUrl": null,
  "cards": [
    {
      "id": 1,
      "tag": "MALİYET VE SATIŞ FİYATI",
      "title": "BİRİM ODA MALİYETİ VE SATIŞ FİYATI (RACK RATE) HESABI",
      "microSummary": "Bir odanın sabit ve değişken maliyetleri hesaplanarak üzerine kâr marjı eklenir ve kapı satış fiyatı (Rack Rate) belirlenir.",
      "definitions": [
        {
          "name": "Birim Oda Maliyeti Hesaplaması",
          "desc": "Bir odanın bir gecelik konaklaması için yapılan doğrudan giderler (çamaşır, şampuan bukleti, temizlik) ile genel giderlerin (elektrik, amortisman) toplanmasıdır.",
          "examples": [
            "Örnekle Pekiştirelim: Bir odanın buklet/çamaşır gideri 150 TL, oda başı elektrik/su 100 TL, personel gideri 250 TL ise toplam birim maliyet 500 TL'dir."
          ]
        },
        {
          "name": "Satış Fiyatı (Rack Rate) Oluşturma",
          "desc": "Hesaplanan birim maliyetin üzerine hedeflenen kâr marjı ve yasal vergiler eklenerek ilan edilen kapı satış fiyatıdır.",
          "examples": [
            "Örnekle Pekiştirelim: 500 TL maliyeti olan odaya %100 kâr marjı (500 TL) eklendiğinde KDV hariç kapı satış fiyatı (Rack Rate) 1.000 TL olarak ilan edilir."
          ]
        }
      ],
      "caseStudy": "Örnek Olay: Düşük Sezonda Zararına Oda Satış Riski\n\nOlay: Kışın bir acente otelden oda başı 300 TL fiyat talep eder. Ancak otelin birim değişken oda maliyeti 350 TL'dir.\n\nÇözüm: Ön büro müdürü talebi reddeder. Çünkü birim değişken maliyetin (350 TL) altındaki satış otel işletmesine doğrudan zarar yazdırır.",
      "tip": "İpucu: Oda satış fiyatı belirlenirken rakip otellerin fiyatları (Benchmarking) ve sezonluk talep dalgalanmaları mutlaka dikkate alınmalıdır."
    },
    {
      "id": 2,
      "tag": "FAİZ VE İSKONTO",
      "title": "FAİZ VE ACENTE İSKONTO (TENZİLAT) HESAPLARI",
      "microSummary": "Geciken acente alacaklarına uygulanan basit faiz ile erken ödeme yapan acentelere uygulanan iskonto (indirim) hesaplanır.",
      "definitions": [
        {
          "name": "Basit Faiz Hesaplaması (F = A × n × t / 100)",
          "desc": "Geciken alacaklar için anapara (A), faiz oranı (n) ve geçen süre (t) üzerinden hesaplanan gecikme faizi tutarıdır.",
          "examples": [
            "Örnekle Pekiştirelim: Ödemesini 60 gün geciktiren acentenin 60.000 TL'lik borcuna yıllık %12 gecikme faizi uygulanır: (60.000 × 12 × 60) / 36.000 = 1.200 TL faiz tutarı."
          ]
        },
        {
          "name": "İskonto (Acente İndirimi)",
          "desc": "Erken ödeme yapan veya yüksek miktarda oda kapatan acentelere brüt satış fiyatı üzerinden verilen yüzdesel indirimdir.",
          "examples": [
            "Örnekle Pekiştirelim: 1.200 TL olan oda fiyatına erken rezervasyon yapan acenteye %20 iskonto uygulanırsa net oda fiyatı 960 TL olur."
          ]
        }
      ],
      "caseStudy": "Örnek Olay: Erken Ödeme İskontosu Teklifi\n\nOlay: Acente 150.000 TL'lik rezervasyon tutarını 4 ay önce peşin ödemeyi teklif ederek %10 iskonto ister.\n\nÇözüm: Ön büro muhasebesi nakit ihtiyacını inceler. %10 iskonto (15.000 TL) düşülerek 135.000 TL peşin tahsil edilir ve nakit akışı sağlanır.",
      "tip": "İpucu: İskonto hesaplamalarında indirim her zaman brüt satış tutarı üzerinden düşülür, net tutara iskonto eklenmez."
    }
  ]
};

const Map<String, dynamic> onBuroHizmetleriUnit6 = {
  "title": "Tesis İstatistiklerini Çıkarma",
  "learningUnit": "6. Öğrenme Birimi",
  "podcastUrl": null,
  "cards": [
    {
      "id": 1,
      "tag": "DOLULUK İSTATİSTİKLERİ",
      "title": "ODA (ODO) VE YATAK (YDO) DOLULUK ORANI HESAPLARI",
      "microSummary": "Otelin performansını gösteren ana istatistikler: Oda Doluluk Oranı (ODO), Yatak/Kişi Doluluk Oranı (YDO) ve Ortalama Oda Fiyatıdır (ADR).",
      "definitions": [
        {
          "name": "Oda Doluluk Oranı (ODO / Occupancy Rate)",
          "desc": "Satılan oda sayısının, o gün satışa hazır toplam oda sayısına bölünerek 100 ile çarpılmasıyla bulunan doluluk yüzdesidir.\n\n📊 İSTATİSTİK FORMÜLLERİ TABLOSU:\n• Oda Doluluk Oranı (ODO): (Satılan Oda / Satışa Hazır Oda) × 100\n• Yatak Doluluk Oranı (YDO): (Satılan Yatak / Satışa Hazır Yatak) × 100\n• Ortalama Oda Fiyatı (ADR): Toplam Oda Geliri / Satılan Oda Sayısı\n• Oda Başına Düşen Gelir (RevPAR): Toplam Oda Geliri / Satışa Hazır Oda Sayısı",
          "examples": [
            "Örnekle Pekiştirelim: 200 odalı bir otelde o gün 160 oda satılmışsa: (160 / 200) × 100 = %80 Oda Doluluk Oranı (ODO) elde edilir."
          ]
        },
        {
          "name": "Yatak (Kişi) Doluluk Oranı (YDO)",
          "desc": "Otelde konaklayan toplam konuk sayısının, tesisin satışa hazır toplam yatak kapasitesine bölünmesiyle hesaplanır.",
          "examples": [
            "Örnekle Pekiştirelim: 500 yatak kapasiteli otelde o gece 400 kişi konaklıyorsa: (400 / 500) × 100 = %80 Yatak Doluluk Oranı (YDO) bulunur."
          ]
        }
      ],
      "caseStudy": "Örnek Olay: Arızalı Odaların Doluluk Hesabına Etkisi\n\nOlay: 150 odalı otelde 10 oda tadilatta (Out of Order - OOO) olup satışa kapalıdır. O gün 112 oda satılmıştır.\n\nÇözüm: Satışa hazır oda sayısı (150 - 10 = 140) alınır. Gerçek ODO = (112 / 140) × 100 = %80 olarak doğru hesaplanır. Arızalı odalar kapasiteden düşülür.",
      "tip": "İpucu: Doluluk oranı hesaplanırken arızalı veya tadilatta (OOO) olan odalar satışa hazır oda sayısından çıkarılmalıdır."
    },
    {
      "id": 2,
      "tag": "GELİR İSTATİSTİKLERİ",
      "title": "ADR (ORTALAMA ODA FİYATI) VE REVPAR PERFORMANS ANALİZİ",
      "microSummary": "Otelin finansal verimliliğini ölçen iki ölçek: Satılan oda başına ortalama gelir (ADR) ve Toplam oda kapasitesine düşen ortalama gelir (RevPAR).",
      "definitions": [
        {
          "name": "Ortalama Günlük Oda Fiyatı (ADR - Average Daily Rate)",
          "desc": "Elde edilen toplam oda gelirinin, satılan oda sayısına bölünmesiyle bulunan ortalama satış fiyatıdır.",
          "examples": [
            "Örnekle Pekiştirelim: Bir günde 100 oda satarak 200.000 TL oda geliri elde eden otelin ADR değeri: 200.000 / 100 = 2.000 TL'dir."
          ]
        },
        {
          "name": "Mevcut Oda Başına Gelir (RevPAR - Revenue Per Available Room)",
          "desc": "Toplam oda gelirinin satılan değil, oteldeki SATIŞA HAZIR TÜM ODALARA bölünmesiyle bulunur (RevPAR = ODO × ADR).",
          "examples": [
            "Örnekle Pekiştirelim: 200 odalı otelde 200.000 TL oda geliri elde edildiyse RevPAR = 200.000 / 200 = 1.000 TL'dir."
          ]
        }
      ],
      "caseStudy": "Örnek Olay: Yüksek Doluluk Düşük Gelir Yanılsaması\n\nOlay: A oteli %90 dolulukla oda başı 600 TL'ye satar (RevPAR = 540 TL). B oteli %60 dolulukla oda başı 1.200 TL'ye satar (RevPAR = 720 TL).\n\nÇözüm: Ön Büro Müdürü B otelinin daha başarılı olduğunu görür. Çünkü RevPAR değeri yüksek olan B oteli daha az yıpranma maliyetiyle daha fazla gelir elde etmiştir.",
      "tip": "İpucu: Otel başarısı sadece Doluluk Oranına (ODO) bakarak değerlendirilemez; mutlaka ADR ve RevPAR değerleri birlikte analiz edilmelidir."
    }
  ]
};

const Map<String, dynamic> onBuroHizmetleriUnit7 = {
  "title": "Ticari Belgeler",
  "learningUnit": "7. Öğrenme Birimi",
  "podcastUrl": null,
  "cards": [
    {
      "id": 1,
      "tag": "FATURA VE İRSALİYE",
      "title": "E-FATURA, E-ARŞİV VE SEVK İRSALİYESİ DÜZENLEME",
      "microSummary": "213 Sayılı Vergi Usul Kanununa (VUK) göre otelde verilen konaklama ve restoran hizmetleri için e-Fatura/e-Arşiv düzenlenir, mal naklinde irsaliye kullanılır.",
      "definitions": [
        {
          "name": "e-Fatura / e-Arşiv Fatura",
          "desc": "Satılan hizmet karşılığında Gelir İdaresi Başkanlığı (GİB) standartlarında dijital ortamda düzenlenen resmi faturadır.\n\n📊 TİCARİ BELGELER VUK ZORUNLULUK TABLOSU:\n• e-Fatura / e-Arşiv Fatura: Hizmet Sonrası En Geç 7 Gün İçinde Düzenlenir (Saklama 5 Yıl VUK)\n• Sevk İrsaliyesi: Mal Sevkiyatında Araçta Bulundurma Zorunlu Belge\n• Gider Pusulası: Faturasız Alımlarda ve İadelerde Kesilen Belge\n• Günlük Müşteri Listesi: Resepsiyonda Günlük Asılması Zorunlu Cetvel",
          "examples": [
            "Örnekle Pekiştirelim: Otelden ayrılan misafirin folyosundaki konaklama ve restoran harcaması için sisteme T.C. Kimlik numarası girilerek e-Arşiv Fatura oluşturulur ve e-posta ile iletilir."
          ]
        },
        {
          "name": "Sevk İrsaliyesi",
          "desc": "Satılan veya depolara taşınan malların araçla nakli sırasında araçta bulundurulması zorunlu olan resmi taşıma belgesidir.",
          "examples": [
            "Örnekle Pekiştirelim: Otelin ana deposundan sahil barına 40 koli içecek taşınırken şoförün yanında bulundurduğu ve teslim alanın imzaladığı belgedir."
          ]
        }
      ],
      "caseStudy": "Örnek Olay: Fatura Düzenleme Süresinin Geçirilmesi\n\nOlay: Ayrılan konuk fatura istemediğini söyler. Resepsiyonist faturayı kesmeden işlemi kapatır.\n\nÇözüm: VUK Madde 231/5 uyarınca hizmet bitiminden itibaren en geç 7 gün içinde fatura düzenlenmesi zorunludur. Gece denetçisi durumu fark edip konuk adına e-Arşiv fatura keser ve cezayı engeller.",
      "tip": "İpucu: VUK gereğince fatura düzenleme süresi hizmet tamamlandıktan sonra azami 7 gündür; 7 günü geçen faturalar hiç düzenlenmemiş sayılır."
    },
    {
      "id": 2,
      "tag": "TÜRK TİCARET KANUNU BELGELERİ",
      "title": "KAMBİYO SENETLERİ: BONO, ÇEK VE POLİÇE İŞLEMLERİ",
      "microSummary": "6102 Sayılı Türk Ticaret Kanununda (TTK) düzenlenen Bono (Senet), Çek ve Poliçe; otelcilikte acente ve tedarikçi ödemelerinde kullanılan kıymetli evraklardır.",
      "definitions": [
        {
          "name": "Bono (Emre Yazılı Senet - TTK Madde 776)",
          "desc": "Borçlunun (keşideci), alacaklıya (lehtar) belirli bir vadede belirli bir parayı kayıtsız şartsız ödeyeceğini taahhüt ettiği kambiyo senedidir.",
          "examples": [
            "Örnekle Pekiştirelim: Otelin mobilya yenileme alımı için tedarikçi firmaya 90 gün vadeli 150.000 TL'lik senet (bono) imzalayarak vermesidir."
          ]
        },
        {
          "name": "Çek (Ödeme Aracı)",
          "desc": "Banka üzerine yazılan ve görüldüğünde ödenmesi gereken nakit para yerine geçen bir ödeme aracıdır.",
          "examples": [
            "Örnekle Pekiştirelim: Acentenin otel rezervasyon ödemesi için otel adına 100.000 TL tutarında banka çeki teslim etmesidir."
          ]
        }
      ],
      "caseStudy": "Örnek Olay: Karşılıksız Çek İle Karşılaşma\n\nOlay: Acenteden alınan 70.000 TL'lik çek vadesinde bankaya ibraz edildiğinde hesapta karşılığı bulunmaz.\n\nÇözüm: Otel muhasebesi bankadan 'Karşılıksızdır' kaşesi bastırarak çek protestosu çeker ve Türk Ticaret Kanunu hükümleri uyarınca icra takibi ve yasal işlem başlatır.",
      "tip": "İpucu: Çek bir ödeme aracıdır ve görüldüğünde ödenir; bono ise bir borç senedidir ve vadesi beklenir."
    }
  ]
};

const Map<String, dynamic> onBuroHizmetleriUnit8 = {
  "title": "Muhasebe Süreci",
  "learningUnit": "8. Öğrenme Birimi",
  "podcastUrl": null,
  "cards": [
    {
      "id": 1,
      "tag": "MUHASEBE VE HESAP PLANI",
      "title": "TEKDÜZEN HESAP PLANINI ANLAMA VE HESAP YAPISI",
      "microSummary": "Muhasebe; işletmenin mali işlemlerini kaydeder, sınıflandırır ve raporlar. Türkiye'de tüm işletmeler Tekdüzen Hesap Planı (THP) kullanmak zorundadır.",
      "definitions": [
        {
          "name": "Tekdüzen Hesap Planı (THP)",
          "desc": "Maliye Bakanlığı tarafından belirlenen, hesapların kodlarla (100 Kasa, 102 Bankalar, 300 Banka Kredileri vb.) standart hale getirildiği hesap sistemidir.\n\n📊 HESAP GRUPLARI SINIFLANDIRMA TABLOSU:\n• 1. Dönen Varlıklar: 1 Yıl İçinde Nakde Dönecek Varlıklar (Kasa, Banka, Alıcılar)\n• 2. Duran Varlıklar: 1 Yıldan Uzun Ömürlü Varlıklar (Binalar, Taşıtlar, Demirbaşlar)\n• 3. Kısa Vadeli Yabancı Kaynaklar: 1 Yıl İçinde Ödenecek Borçlar (Banka Kredisi, Satıcılar)\n• 4. Uzun Vadeli Yabancı Kaynaklar: 1 Yıldan Uzun Vadeli Borçlar\n• 5. Öz Kaynaklar: İşletme Sermayesi ve Geçmiş Kâr/Zararlar",
          "examples": [
            "Örnekle Pekiştirelim: Otel kasasına giren nakit para 100 Kasa hesabına, banka hesabına gelen acente havalesi 102 Bankalar hesabına kaydedilir."
          ]
        },
        {
          "name": "Çift Taraflı Kayıt Usulü (Borç / Alacak)",
          "desc": "Her mali işlemin en az bir hesabın Borç (sol) tarafına, bir başka hesabın Alacak (sağ) tarafına eşit tutarlarla yazılması kuralıdır.",
          "examples": [
            "Örnekle Pekiştirelim: Bankadan 15.000 TL nakit çekildiğinde: 100 Kasa Hesabı (Borçlu) 15.000 TL, 102 Bankalar Hesabı (Alacaklı) 15.000 TL olarak kaydedilir."
          ]
        }
      ],
      "caseStudy": "Örnek Olay: Yevmiye Kaydında Borç-Alacak Eşitsizliği\n\nOlay: Stajyer muhasebeci yevmiye kaydında borç tarafına 6.000 TL, alacak tarafına 5.500 TL yazar.\n\nÇözüm: Çift taraflı kayıt ilkesi gereğince yevmiye maddesinde borç ve alacak toplamı daima EŞİT olmalıdır. Hata tespit edilerek 500 TL'lik eksik kayıt düzeltilir.",
      "tip": "İpucu: Varlık (Aktif) hesaplarındaki artışlar BORÇ tarafına, Kaynak (Pasif) hesaplarındaki artışlar ALACAK tarafına yazılır."
    },
    {
      "id": 2,
      "tag": "YEVMİYE VE DEFTER-İ KEBİR",
      "title": "YEVMİYE DEFTERİ, BÜYÜK DEFTER VE MİZAN",
      "microSummary": "İşlemler kronolojik olarak Yevmiye Defterine, ardından hesap bazında Büyük Deftere (Defter-i Kebir) aktarılır ve Mizan ile kontrol edilir.",
      "definitions": [
        {
          "name": "Yevmiye Defteri (Günlük Defter)",
          "desc": "Mali işlemlerin belgelerine dayanarak tarih sırasıyla madde maddeler halinde yazıldığı resmi yasal defterdir.",
          "examples": [
            "Örnekle Pekiştirelim: 15/04/2026 tarihinde 3.000 TL'lik temizlik malzemesi peşin alındığında 1. madde olarak Yevmiye Defterine işlenmesidir."
          ]
        },
        {
          "name": "Mizan (Geçici ve Kesin Mizan)",
          "desc": "Yevmiye defterindeki borç ve alacak kayıtlarının Büyük Defter hesaplarına doğru aktarılıp aktarılmadığını gösteren kontrol tablosudur.",
          "examples": [
            "Örnekle Pekiştirelim: Ay sonunda düzenlenen geçici mizanda toplam borç sütunu ile toplam alacak sütununun kuruşu kuruşuna eşit olduğu doğrulanır."
          ]
        }
      ],
      "caseStudy": "Örnek Olay: Dönem Sonu Kesin Mizan Denetimi\n\nOlay: Yıl sonunda Bilanço düzenlenmeden önce kesin mizan çıkartılır ve borç-alacak kalanları incelenir.\n\nÇözüm: Geçici mizandaki uyumsuzluklar dönem sonu envanter kaydıyla kapatılır; borç ve alacak toplamları eşitleştikten sonra Kesin Mizan onaylanarak Bilanço çıkarılır.",
      "tip": "İpucu: Yevmiye defterine yapılan her bir kaydın mutlaka fatura, fiş veya makbuz gibi resmi bir dayanak belgesi olmalıdır."
    }
  ]
};

const Map<String, dynamic> onBuroHizmetleriUnit9 = {
  "title": "Aktif Hesaplar",
  "learningUnit": "9. Öğrenme Birimi",
  "podcastUrl": null,
  "cards": [
    {
      "id": 1,
      "tag": "DÖNEN VARLIKLAR",
      "title": "HAZIR DEĞERLER (100 KASA, 102 BANKALAR) VE STOKLAR",
      "microSummary": "Bilançonun Aktif (Sol) tarafında yer alan Dönen Varlıklar; 1 yıl içinde nakde dönüşebilecek nakit, banka, alacak ve stok hesaplarını kapsar.",
      "definitions": [
        {
          "name": "100 Kasa Hesabı",
          "desc": "İşletmenin elinde bulunan nakit paraların takibinin yapıldığı aktif hesaptır. Nakit girişinde borçlanır, nakit çıkışında alacaklanır.",
          "examples": [
            "Örnekle Pekiştirelim: Resepsiyondan 4.000 TL nakit oda tahsilatı yapıldığında 100 Kasa Hesabı 4.000 TL borçlandırılır (kasada para arttı)."
          ]
        },
        {
          "name": "120 Alıcılar Hesabı (Acenteler)",
          "desc": "Kredili (veresiye) oda satışı yapılan acente ve şirketlerden olan kısa vadeli senetsiz ticari alacakların takip edildiği hesaptır.",
          "examples": [
            "Örnekle Pekiştirelim: X Acentesine 30 gün vadeli 50.000 TL'lik konaklama faturası kesildiğinde 120 Alıcılar Hesabı borçlandırılır."
          ]
        }
      ],
      "caseStudy": "Örnek Olay: Kasa Hesabının Alacak Bakiye Vermesi İmkânsızlığı\n\nOlay: Dönem içi mizanda 100 Kasa Hesabının eksi (-) alacak bakiyesi verdiği görülür.\n\nÇözüm: Muhasebe ilkesi gereği kasede var olan paradan daha fazla para çıkamaz (Kasa hesabı alacak bakiye veremez). Yapılan hatanın bir nakit tahsilatın kayda girilmemesinden kaynaklandığı bulunarak borç kaydı tamamlanır.",
      "tip": "İpucu: 100 Kasa Hesabı ya BORÇ bakiyesi verir ya da SIFIR olur; asla ALACAK bakiyesi veremez!"
    },
    {
      "id": 2,
      "tag": "DURAN VARLIKLAR",
      "title": "MADDİ DURAN VARLIKLAR (252 BİNALAR, 255 DEMİRBAŞLAR)",
      "microSummary": "İşletmenin 1 yıldan uzun süre kullanmayı planladığı binalar, taşıtlar, mobilyalar ve amortisman hesapları Duran Varlıklarda izlenir.",
      "definitions": [
        {
          "name": "255 Demirbaşlar Hesabı",
          "desc": "İşletme faaliyetlerinde kullanılan, bir yıldan uzun ömürlü büro makineleri, televizyonlar, resepsiyon bankoları ve mobilyaların kaydedildiği hesaptır.",
          "examples": [
            "Örnekle Pekiştirelim: Otel resepsiyonuna alınan 30.000 TL değerindeki yeni bilgisayar ve kart yazıcı 255 Demirbaşlar Hesabının borcuna kaydedilir."
          ]
        },
        {
          "name": "257 Birikmiş Amortismanlar (-) Hesabı",
          "desc": "Duran varlıkların aşınma ve yıpranma paylarının (amortisman) biriktirildiği ve bilançoda varlık değerini düşüren pasif karakterli düzenleyici hesaptır.",
          "examples": [
            "Örnekle Pekiştirelim: 100.000 TL'lik otel aracının yıllık %20 amortisman payı olan 20.000 TL 257 Birikmiş Amortismanlar hesabının alacağına yazılır."
          ]
        }
      ],
      "caseStudy": "Örnek Olay: Hurdaya Çıkarılan Resepsiyon Bilgisayarı\n\nOlay: Ekonomik ömrünü tamamlayan 10.000 TL'lik eski bilgisayar demirbaş kaydından çıkarılacaktır.\n\nÇözüm: Birikmiş amortismanı (10.000 TL) borçlandırılarak 257 hesabı kapatılır, 255 Demirbaşlar hesabı alacaklandırılarak muhasebe kaydı sıfırlanır.",
      "tip": "İpucu: Yanında (-) işareti olan Aktif hesaplar (257 gibi) bilançoda borç değil alacak bakiyesi vererek ana varlık değerini netleştirir."
    }
  ]
};

const Map<String, dynamic> onBuroHizmetleriUnit10 = {
  "title": "Pasif Hesaplar",
  "learningUnit": "10. Öğrenme Birimi",
  "podcastUrl": null,
  "cards": [
    {
      "id": 1,
      "tag": "KISA VADELİ KAYNAKLAR",
      "title": "300 BANKA KREDİLERİ, 340 ALINAN AVANSLAR VE VERGİ BORÇLARI",
      "microSummary": "Bilançonun Pasif (Sağ) tarafında yer alan Kısa Vadeli Yabancı Kaynaklar; 1 yıl içinde ödenmesi gereken borçlar, vadeli avanslar ve vergilerdir.",
      "definitions": [
        {
          "name": "340 Alınan Sipariş Avansları Hesabı (Acente Kaporası)",
          "desc": "Gelecekte yapılacak konaklama hizmeti için acente veya konuklardan peşin alınan kapora ve ödemelerin izlendiği borç hesabıdır.",
          "examples": [
            "Örnekle Pekiştirelim: Yaz sezonu rezervasyonu için bir acente otel hesabına 60.000 TL kapora yatırdığında 340 Alınan Sipariş Avansları Hesabı alacaklandırılır."
          ]
        },
        {
          "name": "360 Ödenecek Vergi ve Fonlar Hesabı",
          "desc": "İşletmenin devlete ödemekle yükümlü olduğu KDV, Konaklama Vergisi (%2) ve Personel Gelir Vergisi stopajlarının toplandığı hesaptır.",
          "examples": [
            "Örnekle Pekiştirelim: Ay sonunda hesaplanan 22.000 TL'lik Konaklama Vergisi borcu 360 Ödenecek Vergi ve Fonlar Hesabının alacağına işlenir."
          ]
        }
      ],
      "caseStudy": "Örnek Olay: Konaklama Gerçekleştiğinde Avans Hesabının Kapatılması\n\nOlay: Yazın otele gelen acente grubu konaklamasını tamamlar ve 60.000 TL'lik fatura kesilir.\n\nÇözüm: Daha önce alacaklandırılan 340 Alınan Sipariş Avansları Hesabı 60.000 TL BORÇLANDIRILARAK kapatılır, 600 Yurt İçi Satışlar Hesabı ALACAKLANDIRILARAK gelir kaydedilir.",
      "tip": "İpucu: Pasif kaynak hesaplarında meydana gelen artışlar daima ALACAK tarafına kaydedilir."
    },
    {
      "id": 2,
      "tag": "ÖZ KAYNAKLAR",
      "title": "500 SERMAYE VE DÖNEM NET KÂRI / ZARARI",
      "microSummary": "İşletme sahiplerinin otele koyduğu ana sermaye (500) ve geçmiş faaliyetlerden elde edilen Net Kâr (590) veya Net Zarar (591) Öz Kaynaklarda gösterilir.",
      "definitions": [
        {
          "name": "500 Sermaye Hesabı",
          "desc": "Otel kurucularının veya ortaklarının işletmeye tahsis ettikleri toplam varlık değerini gösteren temel öz kaynak hesabıdır.",
          "examples": [
            "Örnekle Pekiştirelim: Otel ortaklarının işletme banka hesabına yatırdığı 3.000.000 TL nakit sermaye 500 Sermaye Hesabının alacağına kaydedilir."
          ]
        },
        {
          "name": "590 Dönem Net Kârı / 591 Dönem Net Zararı (-)",
          "desc": "Faaliyet yılı sonunda Gelir Tablosunun kapatılmasıyla elde edilen net kâr (590) veya net zararın (591) bilançoya aktarıldığı hesaptır.",
          "examples": [
            "Örnekle Pekiştirelim: Yıl sonunda otelin tüm gelir ve giderleri düşüldükten sonra kalan 400.000 TL net kâr 590 Dönem Net Kârı hesabında gösterilir."
          ]
        }
      ],
      "caseStudy": "Örnek Olay: Sermaye Artırımı Kararı\n\nOlay: Otel yönetimi yeni restoran yapımı için sermayeyi 1.500.000 TL artırma kararı alır.\n\nÇözüm: Ortakların yatırdığı tutar 102 Bankalar hesabına borç kaydedilerken, 500 Sermaye Hesabı 1.500.000 TL alacaklandırılarak Öz Kaynak yapısı güçlendirilir.",
      "tip": "İpucu: Bilançoda Temel Denklem: AKTİF (Varlıklar) = PASİF (Yabancı Kaynaklar + Öz Kaynaklar) her zaman korunmalıdır."
    }
  ]
};

const Map<String, dynamic> onBuroHizmetleriUnit11 = {
  "title": "Gelir Tablosu Hesapları",
  "learningUnit": "11. Öğrenme Birimi",
  "podcastUrl": null,
  "cards": [
    {
      "id": 1,
      "tag": "GELİR HESAPLARI",
      "title": "600 YURT İÇİ SATIŞLAR VE SATIŞ GELİRLERİ",
      "microSummary": "Otelin oda satışı, restoran, spa ve organizasyonlardan elde ettiği tüm ana brüt satış gelirleri 600 Yurt İçi Satışlar hesabında toplanır.",
      "definitions": [
        {
          "name": "600 Yurt İçi Satışlar Hesabı",
          "desc": "İşletmenin ana faaliyet konusu olan konaklama ve yan hizmet satışlarından elde edilen tutarların ALACAK tarafına yazıldığı gelir hesabıdır.\n\n📊 GELİR VE GİDER HESAP KANUNU TABLOSU:\n• Gelir Hesapları (600): Artışlar ALACAK kaydedilir.\n• Gider Hesapları (621, 632): Artışlar BORÇ kaydedilir.\n• Kapanış (690): Gelirler BORÇLANIP kapatılır, Giderler ALACAKLANIP kapatılır.",
          "examples": [
            "Örnekle Pekiştirelim: Gün sonunda kesilen 90.000 TL'lik oda ve 40.000 TL'lik restoran faturaları 600 Yurt İçi Satışlar Hesabının alacağına işlenir."
          ]
        },
        {
          "name": "610 Satıştan İadeler (-) Hesabı",
          "desc": "Satılan oda veya hizmetin ayıplı olması/iptal edilmesi nedeniyle konuğa iade edilen tutarların borçlandırıldığı gelir azaltıcı hesaptır.",
          "examples": [
            "Örnekle Pekiştirelim: Sıcak suyu akmadığı için ayrılan misafire iade edilen 2.000 TL oda ücreti 610 Satıştan İadeler hesabının borcuna yazılır."
          ]
        }
      ],
      "caseStudy": "Örnek Olay: Net Satış Hasılatının Bulunması\n\nOlay: Otelin 600 Yurt İçi Satışları 600.000 TL, 610 Satıştan İadeleri 15.000 TL, 611 Satış İskontoları 25.000 TL'dir.\n\nÇözüm: Brüt Satışlar (600.000) - İndirimler (15.000 + 25.000) = 560.000 TL Net Satış Hasılatı doğru şekilde hesaplanır.",
      "tip": "İpucu: Gelir hesapları (600 gibi) ilk açılışta ve gelir arttıkça daima ALACAK kaydı alır."
    },
    {
      "id": 2,
      "tag": "GİDER HESAPLARI VE DÖNEM SONU",
      "title": "621 STMM, 632 GENEL YÖNETİM VE 690 DÖNEM KÂR/ZARARI DEVİR KAYDI",
      "microSummary": "Maliyetler (621) ve Yönetim Giderleri (632) BORÇ kaydedilir. Dönem sonunda tüm gelir ve giderler 690 hesabında toplanarak net sonuç bilançoya devredilir.",
      "definitions": [
        {
          "name": "632 Genel Yönetim Giderleri Hesabı",
          "desc": "Otel yönetimi, personel maaşları, elektrik, su, internet ve büro giderlerinin kaydedildiği borç taraflı gider hesabıdır.",
          "examples": [
            "Örnekle Pekiştirelim: Ön büro ve resepsiyon personelinin aylık 70.000 TL'lik maaş ödemesi 632 Genel Yönetim Giderleri Hesabının borcuna işlenir."
          ]
        },
        {
          "name": "690 Dönem Kârı veya Zararı Hesabı (Kapanış Devir Kaydı)",
          "desc": "Yıl sonunda tüm 6 ile başlayan Gelir hesaplarının borçlandırılarak, tüm Gider hesaplarının alacaklandırılarak aktarıldığı ana özet hesaptır.",
          "examples": [
            "Örnekle Pekiştirelim: Yıl sonunda 600 Gelir hesabı (800.000 TL) borçlandırılıp 690'a devredilir; 632 Gider hesabı (500.000 TL) alacaklandırılıp 690'a devredilir. Aradaki 300.000 TL Kâr 590 Bilanço hesabına aktarılır."
          ]
        }
      ],
      "caseStudy": "Örnek Olay: Yıl Sonu Gelir Tablosu Kapanış Kaydı\n\nOlay: 31 Aralık gecesi saat 24:00'te tüm gelir ve gider hesapları sıfırlanarak yeni yıla temiz başlanacaktır.\n\nÇözüm: Tüm 6XX Gelir ve Gider hesapları 690 Kâr/Zarar hesabına devredilerek kapatılır. Gelir Tablosu hesapları yeni yılın başında 0 bakiye ile tertemiz başlar.",
      "tip": "İpucu: Gider hesapları (632, 621 vb.) daima BORÇ kaydı alır; dönem sonunda 690 hesabına devredilerek kapatılır."
    }
  ]
};

// Tüm 11. Sınıf Ön Büro Hizmetleri Atölyesi Notlar Listesi
const List<Map<String, dynamic>> onBuroHizmetleriNotes = [
  onBuroHizmetleriUnit1,
  onBuroHizmetleriUnit2,
  onBuroHizmetleriUnit3,
  onBuroHizmetleriUnit4,
  onBuroHizmetleriUnit5,
  onBuroHizmetleriUnit6,
  onBuroHizmetleriUnit7,
  onBuroHizmetleriUnit8,
  onBuroHizmetleriUnit9,
  onBuroHizmetleriUnit10,
  onBuroHizmetleriUnit11,
];
