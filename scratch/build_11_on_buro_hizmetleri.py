import json

def make_card(id_num, tag, title, micro_summary, definitions, case_study, tips):
    return {
        "id": id_num,
        "tag": tag,
        "title": title,
        "microSummary": micro_summary,
        "definitions": definitions,
        "caseStudy": case_study,
        "tips": tips
    }

units = [
    {
        "title": "Sabah ve Akşam Vardiyası İşlemleri",
        "learningUnit": "1. Öğrenme Birimi",
        "podcastUrl": None,
        "cards": [
            make_card(
                1,
                "GÜNLÜK ÇIKIŞ İŞLEMLERİ",
                "CHECK-OUT VE ERKEN AYRILMA KONTROLLERİ",
                "Sabah vardiyasında resepsiyon memuru, günü ayrılacak konukların listesini inceleyerek başlar; fatura mutabakatı ve anahtar teslimi yapıp odayı boş duruma getirir.",
                [
                    {
                        "name": "Çıkış (Check-Out) Listesi Kontrolü",
                        "desc": "O gün otelden ayrılacak misafirlerin oda numaraları, hesap dökümleri (folyoları) ve ödeme yöntemlerinin (nakit, kredi kartı, acente) kontrol edildiği resmi listedir.",
                        "examples": [
                            "Örnekle Pekiştirelim: Sabah saat 08:30'da resepsiyona gelen görevli, otel otomasyon sisteminden o gün çıkış yapacak 24 odanın listesini alır; saat 12:00'ye kadar tüm hesapların sıfırlandığını ve oda anahtarlarının teslim alındığını kontrol eder."
                        ]
                    },
                    {
                        "name": "Erken Ayrılma (Early Check-Out) İşlemleri",
                        "desc": "Konuğun rezervasyon süresinden önce otelden ayrılma talebidir. İptal ve ceza şartları kontrol edilerek oda hesabı kapatılır ve oda durumu kat hizmetlerine bildirilir.",
                        "examples": [
                            "Örnekle Pekiştirelim: 5 gece konaklama planlayan bir misafir, acil işi çıktığı için 3. günün sabahı ayrılmak istediğinde; resepsiyonist 2 gecelik kalan ücretin iade şartını acente sözleşmesinden kontrol eder ve durumu hemen Kat Hizmetleri amirine iletir."
                        ]
                    }
                ],
                {
                    "title": "Örnek Olay: Eksik Ekstra Harcama İle Çıkış Yapan Konuk",
                    "story": "Otelden ayrılan bir misafir resepsiyonda oda ücretini ödeyip anahtarı verir. Ancak ayrıldıktan 10 dakika sonra minibardan 2 adet meyve suyu tükettiği Kat Hizmetleri raporuyla anlaşılır.",
                    "solution": "Ön büro memuru, konuk henüz otel bahçesinden ayrılmadan nazikçe iletişime geçer veya kredi kartı açık provizyon yetkisi varsa ek harcamayı folyoya yansıtarak tahsilatı gerçekleştirir ve adisyon belgesini ekler."
                },
                ["İpucu: Sabah vardiyasında çıkış listesi kontrol edilirken ilk iş olarak uyandırma servisi alan odaların saatleri kontrol edilmelidir."]
            ),
            make_card(
                2,
                "HOUSEKEEPING MUTABAKATI",
                "DOLU / BOŞ ODA KONTROLÜ VE MUTABAKAT SAĞLAMA",
                "Resepsiyonun sistemindeki oda durumları ile Kat Hizmetlerinin (Housekeeping) fiziki denetim raporu karşılaştırılarak oda kaçakları veya hataları engellenir.",
                [
                    {
                        "name": "Kat Hizmetleri (Housekeeping) Raporu",
                        "desc": "Kat görevlilerinin sabah katları gezerek odaların fiziki durumunu (Dolu-Clean, Dolu-Dirty, Boş-Clean, Arızalı-OOO) tek tek işaretlediği rapordur.",
                        "examples": [
                            "Örnekle Pekiştirelim: Kat görevlisi 204 numaralı odaya girdiğinde yatağın bozuk ancak valizin olmadığını görürse rapora 'Dolu/Boş Uyuşmazlığı' (Discrepancy) notu düşer."
                        ]
                    },
                    {
                        "name": "Oda Durum Mutabakatı (Housekeeping Discrepancy)",
                        "desc": "Resepsiyon bilgisayarındaki oda durumu ile Kat Hizmetleri raporundaki fiziki durum uyuşmadığında resepsiyonist ve kat amirinin odayı birlikte kontrol etmesidir.",
                        "examples": [
                            "Örnekle Pekiştirelim: Sistemde 305 nolu oda 'Boş' görünürken Kat Hizmetleri raporunda 'Dolu' yazıyorsa; resepsiyonist gece kayıtsız konuk girip girmediğini veya anahtar karıştırılıp karıştırılmadığını inceleyerek sistem durumunu günceller."
                        ]
                    }
                ],
                {
                    "title": "Örnek Olay: Sistemde Boş Ama Odada Eşya Var",
                    "story": "Saat 11:00'de Kat Hizmetleri raporu gelir. 108 nolu oda resepsiyon sisteminde 'Çıkış Yapmış/Boş' görünmektedir ancak oda görevlisi odada kişisel eşyalar bulur.",
                    "solution": "Resepsiyonist hemen misafiri telefonla arar. Misafirin çıkış saatini karıştırdığı ve saat 14:00'te geleceği anlaşılınca oda durumu sistemde 'Geç Çıkış (Late Check-out)' olarak düzeltilir ve ek ücret onaylatılır."
                },
                ["İpucu: Kat Hizmetleri raporu ile resepsiyon mutabakatı sağlanmadan yeni giriş yapacak misafirlere asla oda anahtarı verilmemelidir."]
            ),
            make_card(
                3,
                "GÜNLÜK GİRİŞ VE FORECAST",
                "GİRİŞ KONTROLÜ VE GELECEK DOLULUK TAHMİNİ (FORECAST)",
                "Akşam vardiyasında yeni gelecek konukların rezervasyonları, konaklama fiyatları ve otelin gelecek günlerdeki doluluk tahmin raporları (Forecast) incelenir.",
                [
                    {
                        "name": "Günlük Giriş (Check-In) Listesi Kontrolü",
                        "desc": "O gün otele giriş yapacak misafirlerin isimleri, VIP statüleri, özel istekleri (deniz manzarası, sigara içilmeyen oda) ve oda fiyatlarının önceden kontrol edilmesidir.",
                        "examples": [
                            "Örnekle Pekiştirelim: Resepsiyonist saat 15:00'te sisteme girer; o gün gelecek 40 misafirin oda blokajlarını (oda atamalarını) tamamlar ve evlilik yıldönümü olan 502 nolu odaya meyve sepeti ikramı ekletir."
                        ]
                    },
                    {
                        "name": "Forecast (Doluluk Tahmin) Raporu",
                        "desc": "Otelin önümüzdeki günlük, haftalık ve aylık dönemlerde kaç oda satacağını, beklenen doluluk oranını ve tahmini gelirini gösteren stratejik rapordur.",
                        "examples": [
                            "Örnekle Pekiştirelim: Ön Büro Müdürü gelecek haftaki fuar organizasyonu nedeniyle Forecast raporunda doluluğun %95 olacağını görür ve resepsiyona oda fiyatlarını standart tarifeden %30 yukarı çekme talimatı verir."
                        ]
                    }
                ],
                {
                    "title": "Örnek Olay: Yüksek Sezonda Çifte Rezervasyon (Overbooking)",
                    "story": "Akşam saat 20:00'de otele gelen rezervasyonlu misafire, oteldeki tüm odalar dolu olduğu için oda verilemez.",
                    "solution": "Ön büro memuru Forecast ve giriş listesini inceler. Yaşanan çifte rezervasyon nedeniyle misafir derhal aynı standartta yakın bir kardeş otele transfer edilir; taksi ücreti ve ilk gece konaklaması otel tarafından karşılanır."
                },
                ["İpucu: Geç saatte gelecek (Late Arrival) misafirlerin rezervasyonlarına 'Garanti Edilmiş Rezervasyon' notu düşülerek odaları gece yarısına kadar muhafaza edilmelidir."]
            ),
            make_card(
                4,
                "VARDİYA DEVİR TESLİMİ",
                "VARDİYA DEVİR TESLİMİ VE KASA KONTROLÜ",
                "Vardiya değişiminde resepsiyonist, Seyir Defterini okuyarak nakit kasayı, oda anahtarlarını ve takipli işleri bir sonraki vardiya arkadaşına eksiksiz devreder.",
                [
                    {
                        "name": "Seyir Defteri (Logbook) Devri",
                        "desc": "Vardiyalar arası bilgi akışını sağlayan, arızaları, özel konuk isteklerini ve unutulan eşyaları içeren dahili iletişim defteridir.\n\nVARDİYA ÇALIŞMA SAATLERİ TABLOSU:\n• Sabah Vardiyası: 08.00 - 16.00 (Çıkışlar ve Genel Operasyon)\n• Akşam Vardiyası: 16.00 - 24.00 (Girişler ve Restoran Takibi)\n• Gece Vardiyası: 24.00 - 08.00 (Night Audit ve Gün Sonu)",
                        "examples": [
                            "Örnekle Pekiştirelim: Sabah vardiyasındaki görevli Seyir Defterine '408 nolu odanın TV kumandası arızalı, teknik servis akşam 17:00'de yeni kumanda getirecek' notunu yazar."
                        ]
                    },
                    {
                        "name": "Resepsiyon Kasası Devri (Cash Float)",
                        "desc": "Vardiya sonundaki nakit avansın, gün içinde yapılan nakit ve pos tahsilatlarının sayılarak kuruşu kuruşuna sonraki vardiyaya teslim edilmesidir.",
                        "examples": [
                            "Örnekle Pekiştirelim: Sabah görevlisi kasadaki 5.000 TL bozuk para avansını ve gün boyu toplanan 12.400 TL nakit tahsilatı sayarak akşam vardiyası görevlisine imza karşılığı teslim eder."
                        ]
                    }
                ],
                {
                    "title": "Örnek Olay: Vardiya Devrinde Kasa Açığı Çıkması",
                    "story": "Akşam vardiyası teslim alınırken kasada bulunması gereken tutardan 200 TL eksik olduğu fark edilir.",
                    "solution": "Görevi devreden ve devralan memurlar gün içindeki nakit adisyonları, para üstü işlemlerini ve sistem kayıtlarını tek tek inceler. Bir konuğun nakit ödemesinin sisteme 'Kredi Kartı' olarak yanlış girildiği anlaşılır ve kayıt düzeltilerek kasa denkliği sağlanır."
                },
                ["İpucu: Vardiya devir tesliminde Seyir Defteri okunmadan ve kasa fiziki olarak sayılmadan devir imzası atılmamalıdır."]
            )
        ]
    },
    {
        "title": "Gece İşlemlerini Yapma",
        "learningUnit": "2. Öğrenme Birimi",
        "podcastUrl": None,
        "cards": [
            make_card(
                1,
                "GÜN SONU ÖNCESİ KONTROLLER",
                "NIGHT AUDIT ÖNCESİ GİRİŞ / ÇIKIŞ VE NO-SHOW KONTROLLERİ",
                "Gece vardiyası resepsiyonisti (Night Auditor), gün sonu işlemini (Night Audit) çalıştırmadan önce gelmeyen rezervasyonları (No-Show) ve açık hesapları denetler.",
                [
                    {
                        "name": "No-Show (Gelmeyen Konuk) İşlemi",
                        "desc": "Garanti edilmiş rezervasyonu olduğu halde otele giriş yapmayan ve iptal bildiriminde bulunmayan misafirlerin odalarının No-Show statüsüne alınarak 1 gecelik ceza ücretinin fatura edilmesidir.",
                        "examples": [
                            "Örnekle Pekiştirelim: Saat gece 01:30'a kadar gelmeyen garanti rezervasyonlu misafir için gece resepsiyonisti sistemi No-Show konumuna getirir ve kredi kartından 1 gecelik oda ücretini tahsil eder."
                        ]
                    },
                    {
                        "name": "Gündüz Giriş / Çıkış Kontrolü",
                        "desc": "Gündüz gerçekleşen ancak otomasyon sisteminde henüz 'Check-in' veya 'Check-out' yapılmamış unutulmuş işlemlerin gece denetlenip kapatılmasıdır.",
                        "examples": [
                            "Örnekle Pekiştirelim: Resepsiyonist sistemde 102 nolu odanın hâlâ giriş yapmadı göründüğünü fark eder. Kart kayıt defterini inceleyerek konuğun saat 18:00'de giriş yaptığını ancak memurun sisteme basmayı unuttuğunu tespit eder ve girişi onaylar."
                        ]
                    }
                ],
                {
                    "title": "Örnek Olay: Sisteme Basılmayan Oda Fiyatı",
                    "story": "Gece denetçisi saat 02:00'de sistem raporu alırken 304 nolu odanın oda fiyatının '0 TL' olarak tanımlandığını görür.",
                    "solution": "Gece denetçisi rezervasyon formunu ve acente konfirmasyon mektubunu inceler. Anlaşmalı oda fiyatının 1.500 TL olduğunu tespit ederek sisteme fiyatı işler ve gün sonu işlemine hatasız devam eder."
                },
                ["İpucu: Gün sonu işlemi (Night Audit) başlatılmadan önce sistemde hiçbir odanın 'Beklenen Giriş' (Expected Arrival) statüsünde kalmadığından emin olunmalıdır."]
            ),
            make_card(
                2,
                "GÜN SONU İŞLEMLERİ",
                "POS, YAZAR KASA VE OTOMASYON GÜN SONU (NIGHT AUDIT)",
                "Gece saat 02:00-04:00 arasında otelin tüm restoran POS makineleri, yazar kasalar ve otomasyon sistemi gün sonu kapatılarak oda ücretleri otomatik olarak hesaplara basılır.",
                [
                    {
                        "name": "Oda Ücretlerinin Otomatik Basılması (Room Posting)",
                        "desc": "Gün sonu işlemi çalıştırıldığında, otelde konaklayan tüm dolu odaların günlük konaklama ücretinin ve vergilerinin (KDV + %2 Konaklama Vergisi) sistem tarafından misafir folyolarına otomatik işlenmesidir.",
                        "examples": [
                            "Örnekle Pekiştirelim: Night Audit butonu tıklandığında oteldeki 120 dolu odanın tamamına o günkü oda ve vergi tutarları aynı saniyede borç kaydı olarak aktarılır."
                        ]
                    },
                    {
                        "name": "POS ve Yazar Kasa Z Raporu Gün Sonu",
                        "desc": "Otel restoranı, bar ve spa merkezlerindeki POS cihazları ile yazar kasaların günlük mali kapanış raporunun (Z Raporu) alınması ve gün sonu cirosunun ön büro sistemiyle eşitlenmesidir.",
                        "examples": [
                            "Örnekle Pekiştirelim: Ana restoran POS cihazından alınan Z raporundaki 45.000 TL'lik toplam ciro ile ön büro sistemindeki restoran harcamaları karşılaştırılır ve mali kapanış yapılır."
                        ]
                    }
                ],
                {
                    "title": "Örnek Olay: Gece Yarısı POS Cihazı İletişim Hatası",
                    "story": "Restoran POS cihazı gün sonu alınırken internet kopması nedeniyle 'Z Raporu Başarısız' hatası verir.",
                    "solution": "Gece resepsiyonisti POS cihazını manuel Z raporu moduna alır, fiziki slip toplamlarını sistem kayıtlarıyla manuel karşılaştırır ve teknik arızayı Seyir Defterine kaydederek ertesi sabah mali muhasebeye bilgi verir."
                },
                ["İpucu: Otel otomasyon gün sonu işlemi çalışırken sistem veritabanı yedeklemesi yapıldığı için bilgisayarlar üzerinden başka işlem yapılmamalıdır."]
            )
        ]
    },
    {
        "title": "Ön Büroda Tutulan Defterler",
        "learningUnit": "3. Öğrenme Birimi",
        "podcastUrl": None,
        "cards": [
            make_card(
                1,
                "YASAL DEFTERLER",
                "POLİS DEFTERİ (KBS) VE YASAL ŞİKÂYET DEFTERLERİ",
                "Resepsiyonda tutulması kanunen zorunlu olan Polis Defteri (1774 Sayılı Kanun) ve Konuk Şikâyet Defteri, resmi denetimlerde ilk incelenen belgelerdir.",
                [
                    {
                        "name": "Polis Defteri (Konaklama Kayıt Defteri)",
                        "desc": "1774 Sayılı Kimlik Bildirme Kanunu uyarınca, otele giriş yapan yerli ve yabancı tüm konukların T.C. Kimlik / Pasaport bilgilerinin, giriş-çıkış tarihlerinin kaydedildiği resmi defter veya elektronik KBS sistemidir.\n\nÖN BÜRO DEFTERLERİ KARŞILAŞTIRMA TABLOSU:\n• Polis Defteri (KBS): ZORUNLU (1774 Sayılı Kanun)\n• Şikâyet Defteri: ZORUNLU (Kültür ve Turizm Bakanlığı)\n• Seyir Defteri: İSTEĞE BAĞLI (İç İletişim ve Vardiya Devri)\n• Şeref Defteri: İSTEĞE BAĞLI (VIP ve Protokol Anıları)\n• Anahtar Kayıt Defteri: İSTEĞE BAĞLI (Güvenlik ve Master Anahtar)",
                        "examples": [
                            "Örnekle Pekiştirelim: Otele giriş yapan her misafirin kimlik bilgileri resepsiyonda Kimlik Bildirim Sistemi (KBS) üzerinden anlık olarak Emniyet / Jandarma Genel Komutanlığı veri tabanına iletilir."
                        ]
                    },
                    {
                        "name": "Konuk Şikâyet ve Memnuniyet Defteri",
                        "desc": "Kültür ve Turizm Bakanlığı denetim standartları gereği resepsiyonda konukların incelemesine açık bulundurulan, yazılı geri bildirimlerin toplandığı resmi belgedir.",
                        "examples": [
                            "Örnekle Pekiştirelim: Odasındaki klimanın gürültüsünden rahatsız olan misafir, resepsiyon bankosundaki şikâyet defterine tarih ve oda numarası belirterek durumun düzeltilmesi talebini yazar."
                        ]
                    }
                ],
                {
                    "title": "Örnek Olay: Emniyet Denetiminde Eksik Kimlik Kaydı",
                    "story": "Polis ekipleri geceyarı otel denetimi yapar. Sistemde 201 nolu odada 2 kişi konaklıyor görünürken Polis Defteri (KBS) sistemine sadece 1 kişinin kaydının girildiği tespit edilir.",
                    "solution": "Otel yönetimi 1774 Sayılı Kanun gereği idari para cezasıyla karşılaşır. Ön büro müdürü, resepsiyon personeline ikinci konuk kimliği alınmadan oda anahtarı verilmemesi konusunda zorunlu eğitim başlatır."
                },
                ["İpucu: 1774 Sayılı Kimlik Bildirme Kanununa göre otele giriş yapan 0 yaş dahil tüm bireylerin kimlik bilgileri KBS sistemine girilmek zorundadır."]
            ),
            make_card(
                2,
                "İSTEĞE BAĞLI DEFTERLER",
                "SEYİR, ŞEREF VE ANAHTAR KAYIT DEFTERLERİ",
                "Yasal zorunluluğu olmayan ancak otel operasyonunun pürüzsüz işlemesi ve kurumsal hafıza için tutulan iç takip defterleridir.",
                [
                    {
                        "name": "Seyir Defteri (Shift Logbook)",
                        "desc": "Vardiyalar arası bilgi akışını sağlayan, arızaları, özel konuk isteklerini ve unutulan eşyaları içeren dahili iletişim defteridir.",
                        "examples": [
                            "Örnekle Pekiştirelim: '302 nolu odanın taksi talebi sabah 07:30 için ayarlandı' notunun Seyir Defterine yazılmasıdır."
                        ]
                    },
                    {
                        "name": "Anahtar Kayıt Defteri (Key Control Log)",
                        "desc": "Paspartu (Master) anahtarların ve depo/ofis anahtarlarını teslim alan personelin imza karşılığı kaydolduğu güvenlik defteridir.",
                        "examples": [
                            "Örnekle Pekiştirelim: Kat hizmetleri şefinin sabah kat master anahtarını alırken saat ve tarih belirterek Anahtar Kayıt Defterini imzalamasıdır."
                        ]
                    }
                ],
                {
                    "title": "Örnek Olay: Önemli Devlet Büyüğünün Oteli Ziyareti",
                    "story": "Otelde konaklayan bir büyükelçi ayrılırken otel hizmetlerinden çok memnun kaldığını belirtir.",
                    "solution": "Ön büro müdürü kendisinden otelin Şeref Defterine (VIP Guestbook) duygu ve düşüncelerini yazıp imzalamasını rica eder. Bu belge otelin kurumsal arşivinde gururla saklanır."
                },
                ["İpucu: Kat master anahtarı asla imzasız şekilde personele verilmemeli ve mesai bitiminde Anahtar Kayıt Defteri kontrol edilerek teslim alınmalıdır."]
            )
        ]
    },
    {
        "title": "Mesleki Matematik Aritmetiği",
        "learningUnit": "4. Öğrenme Birimi",
        "podcastUrl": None,
        "cards": [
            make_card(
                1,
                "KOLAY HESAPLAMA TEKNİKLERİ",
                "PRATİK HESAPLAMA VE İŞLEM SAĞLAMALARI",
                "Resepsiyonda hızlı ve hatasız döviz, adisyon ve oda fiyatı hesabı yapabilmek için pratik çarpma/bölme ve sağlam alma teknikleri kullanılır.",
                [
                    {
                        "name": "Pratik Çarpma ve Bölme Yolları",
                        "desc": "Zihinden hızlı hesaplama yapmak için sayıları 10, 100, 1000 katlarına tamamlayarak veya 5, 25, 50 gibi sayılara pratik bölme kurallarıyla işlem yapmaktır.",
                        "examples": [
                            "Örnekle Pekiştirelim: 140 TL tutarındaki kahvaltı ücretini 5 ile çarpmak yerine; 140'ı 10 ile çarpıp (1400) ikiye bölerek (700 TL) zihinden saniyeler içinde hesaplamaktır."
                        ]
                    },
                    {
                        "name": "İşlemlerin Sağlamasını Yapma",
                        "desc": "Konuk folyosu veya fatura toplamlarında yapılan toplama ve çarpma işlemlerinin doğru olup olmadığını ters işlem veya 9'lar kuralı ile kontrol etmektir.",
                        "examples": [
                            "Örnekle Pekiştirelim: 4 oda × 1.250 TL = 5.000 TL tutarındaki oda hesabının sağlamasını yapmak için 5.000 TL'yi 4'e bölerek 1.250 TL oda fiyatına ulaşıldığını doğrulamaktır."
                        ]
                    }
                ],
                {
                    "title": "Örnek Olay: Resepsiyon Bankosunda Hızlı Hesaplama",
                    "story": "Sistem arızası nedeniyle bilgisayarlar kapanır. Bankoda bekleyen 8 kişilik grup nakit ödeme yaparak hemen ayrılmak ister.",
                    "solution": "Resepsiyonist pratik matematik yöntemleriyle kişi başı 450 TL olan tutarı (8 × 450 = 8 × 900 / 2 = 3.600 TL) zihinden hesaplar, manuel makbuz keserek konukları bekletmeden uğurlar."
                },
                ["İpucu: Bir sayıyı 25 ile çarpmak için sayının sonuna iki sıfır ekleyip çıkan sonucu 4'e bölmek en hızlı pratik yoldur."]
            ),
            make_card(
                2,
                "YÜZDE VE BİNDE HESAPLARI",
                "YÜZDE (%) VE BİNDE (‰) HESAPLAMALARI",
                "Otelcilikte KDV, Konaklama Vergisi (%2), Acente Komisyonları ve Servis Ücreti (Service Charge) hesaplamalarında yüzde yöntemleri kullanılır.",
                [
                    {
                        "name": "Yüzde (%) Hesaplama Yöntemi",
                        "desc": "Bir anaparanın veya tutarın belirlenen yüzde oranında artırılması (KDV ekleme) veya azaltılması (İskonto yapma) işlemidir.",
                        "examples": [
                            "Örnekle Pekiştirelim: 2.000 TL tutarındaki konaklama bedeline %2 Konaklama Vergisi eklemek için: 2.000 × (2 / 100) = 40 TL vergi hesaplanır. Toplam tutar 2.040 TL olur."
                        ]
                    },
                    {
                        "name": "Oran ve Orantı Kuralları",
                        "desc": "İki büyüklük arasındaki sabit ilişkiyi kullanarak bilinmeyen fiyat, grup indirimi veya kontenjan payını doğru oranla bulmaktır.",
                        "examples": [
                            "Örnekle Pekiştirelim: 10 odalık grup rezervasyonuna %15 indirim yapılıyorsa; 25 odalık grup talebi geldiğinde uygulanacak doğru orantılı indirim miktarını hesaplamaktır."
                        ]
                    }
                ],
                {
                    "title": "Örnek Olay: KDV Dahil Tutardan KDV Hariç Tutarı Bulma",
                    "story": "Faturada KDV Dahil 1.200 TL yazmaktadır. Muhasebe KDV hariç matrahı istemektedir. (KDV Oranı %10 varsayımıyla).",
                    "solution": "Resepsiyonist tutarı (1 + KDV Oranına) böler: 1.200 / 1,10 = 1.090,91 TL KDV Hariç Matrah. KDV Tutarı = 109,09 TL olarak hatasız ayrıştırılır."
                },
                ["İpucu: KDV dahil tutardan matrahı bulmak için tutar (1 + Oran)'a bölünür; doğrudan %10 düşürmek hatalı sonuç verir!"]
            )
        ]
    },
    {
        "title": "Mesleki Matematik Hesaplamaları",
        "learningUnit": "5. Öğrenme Birimi",
        "podcastUrl": None,
        "cards": [
            make_card(
                1,
                "MALİYET VE SATIŞ FİYATI",
                "MALIYET, KAR MARJI VE ODA SATIŞ FİYATI HESAPLAMA",
                "Bir odanın sabit ve değişken maliyetleri hesaplanarak üzerine hedeflenen kâr marjı eklenir ve oda satış fiyatı (Rack Rate) belirlenir.",
                [
                    {
                        "name": "Oda Maliyet Hesaplaması",
                        "desc": "Bir odanın bir gecelik satışı için yapılan doğrudan giderler (çamaşır yıkama, şampuan/sabun bukleti, temizlik işçiliği) ile genel giderlerin (elektrik, amortisman) toplanmasıdır.",
                        "examples": [
                            "Örnekle Pekiştirelim: Bir odanın buklet ve çamaşır gideri 120 TL, oda başı elektrik/su 80 TL, personel gideri 200 TL ise toplam birim maliyet 400 TL'dir."
                        ]
                    },
                    {
                        "name": "Satış Fiyatı (Rack Rate) Oluşturma",
                        "desc": "Hesaplanan birim maliyetin üzerine işletmenin hedeflediği kâr marjı ve yasal vergiler eklenerek kapı satış fiyatının belirlenmesidir.",
                        "examples": [
                            "Örnekle Pekiştirelim: 400 TL maliyeti olan bir odaya %150 kâr marjı (600 TL) eklendiğinde KDV hariç oda satış fiyatı 1.000 TL olarak kapı fiyatı (Rack Rate) ilan edilir."
                        ]
                    }
                ],
                {
                    "title": "Örnek Olay: Düşük Sezonda Maliyet Altı Oda Satış Riski",
                    "story": "Kış sezonunda bir acente otelden oda başı 250 TL fiyat talep eder. Ancak otelin birim oda değişken maliyeti 300 TL'dir.",
                    "solution": "Ön büro müdürü maliyet hesaplamasını göstererek talebi reddeder. Çünkü birim değişken maliyetin (300 TL) altındaki satış otel işletmesine doğrudan zarar yazdırır."
                },
                ["İpucu: Oda satış fiyatı belirlenirken rakip otellerin fiyatları (Benchmarking) ve sezonluk talep dalgalanmaları mutlaka dikkate alınmalıdır."]
            ),
            make_card(
                2,
                "FAİZ VE İSKONTO",
                "FAİZ, BALİĞ VE İSKONTO (KONTENJAN İNDİRİMİ) HESAPLARI",
                "Geciken acente ödemelerinde uygulanan basit faiz ile erken ödeme yapan acentelere uygulanan iskonto (Tenzilat) hesaplamaları yapılır.",
                [
                    {
                        "name": "Basit Faiz Hesaplaması (F = A × n × t / 100)",
                        "desc": "Geciken alacaklar için anapara (A), faiz oranı (n) ve geçen gün/ay süresi (t) üzerinden hesaplanan gecikme tutarıdır.",
                        "examples": [
                            "Örnekle Pekiştirelim: Ödemesini 60 gün geciktiren acentenin 50.000 TL'lik borcuna yıllık %12 gecikme faizi uygulanır: (50.000 × 12 × 60) / 36.000 = 1.000 TL faiz tutarı."
                        ]
                    },
                    {
                        "name": "İskonto (Acente İndirimi)",
                        "desc": "Erken ödeme yapan veya yüksek miktarda oda kapatan acentelere brüt satış fiyatı üzerinden verilen yüzdesel fiyat indirimidir.",
                        "examples": [
                            "Örnekle Pekiştirelim: 1.000 TL olan oda fiyatına erken rezervasyon yapan acenteye %20 iskonto uygulanırsa net oda fiyatı 800 TL olur."
                        ]
                    }
                ],
                {
                    "title": "Örnek Olay: Erken Ödeme İskontosu Uygulaması",
                    "story": "Acente 100.000 TL'lik rezervasyon tutarını sözleşme tarihinden 3 ay önce peşin ödemeyi teklif ederek %10 iskonto talep eder.",
                    "solution": "Ön büro muhasebesi nakit akış ihtiyacını inceler. %10 iskonto (10.000 TL) düşülerek 90.000 TL peşin tahsil edilir ve nakit ihtiyacı karşılanır."
                },
                ["İpucu: İskonto hesaplamalarında indirim her zaman brüt satış tutarı üzerinden düşülür, net tutara iskonto eklenmez."]
            )
        ]
    },
    {
        "title": "Tesis İstatistiklerini Çıkarma",
        "learningUnit": "6. Öğrenme Birimi",
        "podcastUrl": None,
        "cards": [
            make_card(
                1,
                "DOLULUK ORANLARI",
                "ODA (ODO) VE YATAK (YDO) DOLULUK ORANI HESAPLAMALARI",
                "Otelin performansını ölçen en temel göstergeler: Oda Doluluk Oranı (ODO), Yatak/Kişi Doluluk Oranı (YDO) ve Ortalama Oda Fiyatıdır (ADR).",
                [
                    {
                        "name": "Oda Doluluk Oranı (ODO / Occupancy Rate)",
                        "desc": "Satılan oda sayısının, o gün satışa hazır toplam oda sayısına bölünerek 100 ile çarpılmasıyla bulunan yüzdesel doluluktur.\n\nİSTATİSTİK FORMÜLLERİ TABLOSU:\n• Oda Doluluk Oranı (ODO): (Satılan Oda / Satışa Hazır Oda) × 100\n• Yatak Doluluk Oranı (YDO): (Satılan Yatak / Satışa Hazır Yatak) × 100\n• Ortalama Oda Fiyatı (ADR): Toplam Oda Geliri / Satılan Oda Sayısı\n• Oda Başına Düşen Gelir (RevPAR): Toplam Oda Geliri / Satışa Hazır Oda Sayısı",
                        "examples": [
                            "Örnekle Pekiştirelim: 200 odalı bir otelde o gün 150 oda satılmışsa: (150 / 200) × 100 = %75 Oda Doluluk Oranı (ODO) elde edilir."
                        ]
                    },
                    {
                        "name": "Yatak (Kişi) Doluluk Oranı (YDO)",
                        "desc": "Otelde konaklayan toplam konuk sayısının, tesisin satışa hazır toplam yatak kapasitesine bölünmesiyle hesaplanır.",
                        "examples": [
                            "Örnekle Pekiştirelim: 400 yatak kapasiteli otelde o gece 300 kişi konaklıyorsa: (300 / 400) × 100 = %75 Yatak Doluluk Oranı (YDO) bulunur."
                        ]
                    }
                ],
                {
                    "title": "Örnek Olay: Arızalı Odaların Doluluğa Etkisi",
                    "story": "200 odalı otelde 10 oda su tesisatı arızası nedeniyle Out of Order (OOO/Satışa Kapalı) durumundadır. O gün 150 oda satılmıştır.",
                    "solution": "Satışa hazır oda sayısı (200 - 10 = 190) olarak alınır. Gerçek ODO = (150 / 190) × 100 = %78,95 olarak doğru hesaplanır. Arızalı oda kapasiteden düşülür."
                },
                ["İpucu: Doluluk oranı hesaplanırken tadilatta veya arızada (OOO) olan odalar satışa hazır oda sayısından çıkarılmalıdır."]
            ),
            make_card(
                2,
                "GELİR İSTATİSTİKLERİ",
                "ADR (ORTALAMA ODA FİYATI) VE REVPAR HESAPLAMALARI",
                "Otelin finansal başarısını gösteren iki ana ölçek: Satılan oda başına ortalama gelir (ADR) ve Toplam oda kapasitesine düşen ortalama gelir (RevPAR).",
                [
                    {
                        "name": "Ortalama Günlük Oda Fiyatı (ADR - Average Daily Rate)",
                        "desc": "Elde edilen toplam oda gelirinin, satılan oda sayısına bölünmesiyle bulunan ortalama satış fiyatıdır.",
                        "examples": [
                            "Örnekle Pekiştirelim: Bir günde 100 oda satarak 150.000 TL oda geliri elde eden otelin ADR değeri: 150.000 / 100 = 1.500 TL'dir."
                        ]
                    },
                    {
                        "name": "Mevcut Oda Başına Gelir (RevPAR - Revenue Per Available Room)",
                        "desc": "Toplam oda gelirinin satılan değil, oteldeki SATIŞA HAZIR TÜM ODALARA bölünmesiyle bulunur (RevPAR = ODO × ADR).",
                        "examples": [
                            "Örnekle Pekiştirelim: 200 odalı otelde 150.000 TL oda geliri elde edildiyse RevPAR = 150.000 / 200 = 750 TL'dir."
                        ]
                    }
                ],
                {
                    "title": "Örnek Olay: Yüksek Doluluk Ama Düşük Gelir Yanılsaması",
                    "story": "A oteli %90 dolulukla oda başı 500 TL'ye satar (RevPAR = 450 TL). B oteli %60 dolulukla oda başı 1.000 TL'ye satar (RevPAR = 600 TL).",
                    "solution": "Ön Büro Müdürü B otelinin daha başarılı olduğunu analiz eder. Çünkü RevPAR değeri yüksek olan B oteli hem daha az yıpranma maliyetiyle daha fazla gelir elde etmiştir."
                },
                ["İpucu: Otel başarısı sadece Doluluk Oranına (ODO) bakılarak değerlendirilemez; mutlaka ADR ve RevPAR değerleri birlikte analiz edilmelidir."]
            )
        ]
    },
    {
        "title": "Ticari Belgeler",
        "learningUnit": "7. Öğrenme Birimi",
        "podcastUrl": None,
        "cards": [
            make_card(
                1,
                "FATURA VE İRSALİYE",
                "E-FATURA, E-ARŞİV VE SEVK İRSALİYESİ DÜZENLEME",
                "213 Sayılı Vergi Usul Kanununa (VUK) göre otelde verilen konaklama ve restoran hizmetleri için e-Fatura/e-Arşiv düzenlenir, mal sevkiyatında irsaliye kullanılır.",
                [
                    {
                        "name": "e-Fatura / e-Arşiv Fatura",
                        "desc": "Satılan mal veya hizmet karşılığında Gelir İdaresi Başkanlığı (GİB) standartlarına uygun olarak dijital ortamda düzenlenen ve konuğa iletilen resmi faturadır.\n\nTİCARİ BELGELER VUK ZORUNLULUK TABLOSU:\n• e-Fatura / e-Arşiv Fatura: Zorunlu Fatura Belgesi (Saklama 5 Yıl VUK)\n• Sevk İrsaliyesi: Mal Sevkiyatında Araçta Bulundurma Zorunlu\n• Gider Pusulası: Faturasız Alımlarda ve İadelerde Kesilen Belge\n• Günlük Müşteri Listesi: Resepsiyonda Günlük Asılması Zorunlu Cetvel",
                        "examples": [
                            "Örnekle Pekiştirelim: Otelden ayrılan misafirin folyosundaki 3 gecelik oda ve restoran harcaması için sisteme T.C. Kimlik numarası girilerek anında e-Arşiv Fatura oluşturulur ve e-posta ile gönderilir."
                        ]
                    },
                    {
                        "name": "Sevk İrsaliyesi",
                        "desc": "Satılan veya depolara taşınan malların bir yerden başka bir yere nakli sırasında araçta bulundurulması zorunlu olan resmi taşıma belgesidir.",
                        "examples": [
                            "Örnekle Pekiştirelim: Otelin merkez deposundan sahildeki şubeye 50 koli içecek taşınırken şoförün yanında bulundurduğu ve teslim alanın imzaladığı belgedir."
                        ]
                    }
                ],
                {
                    "title": "Örnek Olay: Fatura Düzenleme Süresinin Geçirilmesi",
                    "story": "Çıkış yapan konuk fatura istemediğini söyler. Resepsiyonist faturayı düzenlemeden işlemi kapatır.",
                    "solution": "Vergi Usul Kanununa göre hizmetin tamamlandığı tarihten itibaren en geç 7 gün içinde fatura düzenlenmesi zorunludur. Gece denetçisi durumu fark ederek konuk adına e-Arşiv fatura keser ve usulsüzlük cezasını engeller."
                },
                ["İpucu: VUK gereği fatura düzenleme süresi hizmetin bitiminden itibaren 7 gündür; bu süre aşılırsa fatura hiç düzenlenmemiş sayılır."]
            ),
            make_card(
                2,
                "TÜRK TİCARET KANUNU BELGELERİ",
                "KAMBİYO SENETLERİ: BONO, ÇEK VE POLİÇE İŞLEMLERİ",
                "6102 Sayılı Türk Ticaret Kanununda (TTK) düzenlenen Bono (Senet), Çek ve Poliçe; otelcilikte acente ve tedarikçi ödemelerinde kullanılan kıymetli evraklardır.",
                [
                    {
                        "name": "Bono (Emre Yazılı Senet)",
                        "desc": "Borçlunun (keşideci), alacaklıya (lehtar) belirli bir vadede belirli bir parayı kayıtsız şartsız ödeyeceğini taahhüt ettiği kıymetli evraktır.",
                        "examples": [
                            "Örnekle Pekiştirelim: Otelin yatak yenileme alımı için tedarikçi firmaya 90 gün vadeli 200.000 TL'lik senet (bono) imzalayarak vermesidir."
                        ]
                    },
                    {
                        "name": "Çek (Ödeme Aracı)",
                        "desc": "Bir bankaya hitaben yazılan ve görüldüğünde ödenmesi gereken nakit yerine geçen bir ödeme aracıdır.",
                        "examples": [
                            "Örnekle Pekiştirelim: Acentenin otel rezervasyon ödemesi için otel adına 150.000 TL tutarında banka çeki vermesidir."
                        ]
                    }
                ],
                {
                    "title": "Örnek Olay: Karşılıksız Çek İle Karşılaşma",
                    "story": "Acenteden alınan 80.000 TL'lik çek vadesinde bankaya ibraz edildiğinde hesapta karşılığı bulunmaz.",
                    "solution": "Otel muhasebesi bankadan 'Karşılıksızdır' kaşesi bastırarak çek protestosu çeker ve Türk Ticaret Kanunu hükümleri uyarınca icra takibi ve yasal işlem başlatır."
                },
                ["İpucu: Çek bir ödeme aracıdır ve görüldüğünde ödenir; bono ise bir borç senetidir ve vadesi beklenir."]
            )
        ]
    },
    {
        "title": "Muhasebe Süreci",
        "learningUnit": "8. Öğrenme Birimi",
        "podcastUrl": None,
        "cards": [
            make_card(
                1,
                "MUHASEBE VE HESAP PLANI",
                "TEKDÜZEN HESAP PLANINI ANLAMA VE HESAP YAPISI",
                "Muhasebe; işletmenin mali işlemlerini kaydeder, sınıflandırır ve raporlar. Türkiye'de tüm işletmeler Tekdüzen Hesap Planı (THP) kullanmak zorundadır.",
                [
                    {
                        "name": "Tekdüzen Hesap Planı (THP)",
                        "desc": "Maliye Bakanlığı tarafından belirlenen, hesapların kodlarla (100 Kasa, 102 Bankalar, 300 Banka Kredileri vb.) standart hale getirildiği hesap sistemidir.\n\nHESAP GRUPLARI SINIFLANDIRMA TABLOSU:\n• 1. Dönen Varlıklar: 1 Yıl İçinde Nakde Dönecek (Kasa, Banka, Alıcılar)\n• 2. Duran Varlıklar: 1 Yıldan Uzun Ömürlü Varlıklar (Binalar, Taşıtlar)\n• 3. Kısa Vadeli Yabancı Kaynaklar: 1 Yıl İçinde Ödenecek Borçlar (Banka Kredisi, Satıcılar)\n• 4. Uzun Vadeli Yabancı Kaynaklar: 1 Yıldan Uzun Vadeli Borçlar\n• 5. Öz Kaynaklar: İşletme Sermayesi ve Geçmiş Kâr/Zararlar",
                        "examples": [
                            "Örnekle Pekiştirelim: Otel kasasına giren nakit para 100 Kasa hesabına, banka hesabına gelen acente havalesi 102 Bankalar hesabına kaydedilir."
                        ]
                    },
                    {
                        "name": "Çift Taraflı Kayıt Usulü (Borç / Alacak)",
                        "desc": "Her mali işlemin en az bir hesabın Borç (sol) tarafına, bir başka hesabın Alacak (sağ) tarafına eşit tutarlarla yazılması kuralıdır.",
                        "examples": [
                            "Örnekle Pekiştirelim: Bankadan 10.000 TL nakit çekildiğinde: 100 Kasa Hesabı (Borçlu) 10.000 TL, 102 Bankalar Hesabı (Alacaklı) 10.000 TL olarak kaydedilir."
                        ]
                    }
                ],
                {
                    "title": "Örnek Olay: Yevmiye Kaydında Borç-Alacak Eşitsizliği",
                    "story": "Stajyer muhasebeci yevmiye kaydında borç tarafına 5.000 TL, alacak tarafına 4.500 TL yazar.",
                    "solution": "Çift taraflı kayıt ilkesi gereği yevmiye maddesinde borç ve alacak toplamı her zaman EŞİT olmak zorundadır. Hata tespit edilerek 500 TL'lik eksik kayıt düzeltilir."
                },
                ["İpucu: Varlık (Aktif) hesaplarındaki artışlar BORÇ tarafına, Kaynak (Pasif) hesaplarındaki artışlar ALACAK tarafına yazılır."]
            ),
            make_card(
                2,
                "YEVMİYE VE DEFTER-İ KEBİR",
                "YEVMİYE DEFTERİ, BÜYÜK DEFTER VE MİZAN",
                "İşlemler kronolojik olarak Yevmiye Defterine, ardından hesap bazında Büyük Deftere (Defter-i Kebir) aktarılır ve Mizan ile kontrol edilir.",
                [
                    {
                        "name": "Yevmiye Defteri (Günlük Defter)",
                        "desc": "Mali işlemlerin belgelerine dayanarak tarih sırasıyla madde maddeler halinde yazıldığı resmi yasal defterdir.",
                        "examples": [
                            "Örnekle Pekiştirelim: 12/03/2026 tarihinde 2.000 TL'lik temizlik malzemesi peşin alındığında 1. madde olarak Yevmiye Defterine işlenmesidir."
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
                {
                    "title": "Örnek Olay: Dönem Sonu Kesin Mizan Denetimi",
                    "story": "Yıl sonunda Bilanço düzenlenmeden önce kesin mizan çıkartılır ve borç-alacak kalanları incelenir.",
                    "solution": "Geçici mizandaki uyumsuzluklar dönem sonu envanter kaydıyla kapatılır; borç ve alacak toplamları eşitleştikten sonra Kesin Mizan onaylanarak resmi Bilanço çıkarılır."
                },
                ["İpucu: Yevmiye defterine yapılan her bir kaydın mutlaka fatura, fiş veya makbuz gibi resmi bir dayanak belgesi olmalıdır."]
            )
        ]
    },
    {
        "title": "Aktif Hesaplar",
        "learningUnit": "9. Öğrenme Birimi",
        "podcastUrl": None,
        "cards": [
            make_card(
                1,
                "DÖNEN VARLIKLAR",
                "HAZIR DEĞERLER (100 KASA, 102 BANKALAR) VE STOKLAR",
                "Bilançonun Aktif (Sol) tarafında yer alan Dönen Varlıklar; 1 yıl içinde nakde dönüşebilecek nakit, banka, alacak ve stok hesaplarını kapsar.",
                [
                    {
                        "name": "100 Kasa Hesabı",
                        "desc": "İşletmenin elinde bulunan ulusal ve yabancı nakit paraların takibinin yapıldığı aktif hesaptır. Nakit girişinde borçlanır, nakit çıkışında alacaklanır.",
                        "examples": [
                            "Örnekle Pekiştirelim: Resepsiyondan 5.000 TL nakit oda tahsilatı yapıldığında 100 Kasa Hesabı 5.000 TL borçlandırılır (kasada para arttı)."
                        ]
                    },
                    {
                        "name": "120 Alıcılar Hesabı (Acenteler)",
                        "desc": "Kredili (veresiye) oda satışı yapılan acente ve şirketlerden olan kısa vadeli senetsiz ticari alacakların takip edildiği hesaptır.",
                        "examples": [
                            "Örnekle Pekiştirelim: X Acentesine 30 gün vadeli 40.000 TL'lik konaklama faturası kesildiğinde 120 Alıcılar Hesabı borçlandırılır."
                        ]
                    }
                ],
                {
                    "title": "Örnek Olay: Kasa Hesabının Alacak Bakiye Vermesi İmkânsızlığı",
                    "story": "Dönem içi mizanda 100 Kasa Hesabının eksi (-) alacak bakiyesi verdiği görülür.",
                    "solution": "Muhasebe ilkesi gereği fiziki kasede var olan paradan daha fazla para çıkamaz (Kasa hesabı alacak bakiye veremez). Yapılan hatanın bir nakit tahsilatın kayda girilmemesinden kaynaklandığı bulunarak borç kaydı tamamlanır."
                },
                ["İpucu: 100 Kasa Hesabı ya BORÇ bakiyesi verir ya da SIFIR olur; asla ALACAK bakiyesi veremez!"]
            ),
            make_card(
                2,
                "DURAN VARLIKLAR",
                "MADDİ DURAN VARLIKLAR (252 BİNALAR, 255 DEMİRBAŞLAR)",
                "İşletmenin 1 yıldan uzun süre kullanmayı planladığı binalar, taşıtlar, mobilyalar ve amortisman hesapları Duran Varlıklarda izlenir.",
                [
                    {
                        "name": "255 Demirbaşlar Hesabı",
                        "desc": "İşletme faaliyetlerinde kullanılan, bir yıldan uzun ömürlü büro makineleri, televizyonlar, resepsiyon bankoları ve mobilyaların kaydedildiği hesaptır.",
                        "examples": [
                            "Örnekle Pekiştirelim: Otel resepsiyonuna alınan 40.000 TL değerindeki yeni bilgisayar ve kart yazıcı 255 Demirbaşlar Hesabının borcuna kaydedilir."
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
                {
                    "title": "Örnek Olay: Hurdaya Çıkarılan Resepsiyon Bilgisayarı",
                    "story": "Ekonomik ömrünü tamamlayan 10.000 TL'lik eski bilgisayar demirbaş kaydından çıkarılacaktır.",
                    "solution": "Birikmiş amortismanı (10.000 TL) borçlandırılarak 257 hesabı kapatılır, 255 Demirbaşlar hesabı alacaklandırılarak muhasebe kaydı sıfırlanır."
                },
                ["İpucu: Yanında (-) işareti olan Aktif hesaplar (257 gibi) bilançoda borç değil alacak bakiyesi vererek ana varlık değerini netleştirir."]
            )
        ]
    },
    {
        "title": "Pasif Hesaplar",
        "learningUnit": "10. Öğrenme Birimi",
        "podcastUrl": None,
        "cards": [
            make_card(
                1,
                "KISA VADELİ YABANCI KAYNAKLAR",
                "300 BANKA KREDİLERİ, 340 ALINAN AVANSLAR VE VERGİ BORÇLARI",
                "Bilançonun Pasif (Sağ) tarafında yer alan Kısa Vadeli Yabancı Kaynaklar; 1 yıl içinde ödenmesi gereken borçlar, vadeli avanslar ve vergilerdir.",
                [
                    {
                        "name": "340 Alınan Sipariş Avansları Hesabı (Acente Kaporası)",
                        "desc": "Gelecekte yapılacak konaklama hizmeti için acente veya konuklardan peşin alınan kapora ve ödemelerin izlendiği borç hesabıdır.",
                        "examples": [
                            "Örnekle Pekiştirelim: Yaz sezonu rezervasyonu için bir acente otel hesabına 50.000 TL kapora yatırdığında 340 Alınan Sipariş Avansları Hesabı alacaklandırılır."
                        ]
                    },
                    {
                        "name": "360 Ödenecek Vergi ve Fonlar Hesabı",
                        "desc": "İşletmenin devlete ödemekle yükümlü olduğu KDV, Konaklama Vergisi (%2) ve Personel Gelir Vergisi stopajlarının toplandığı hesaptır.",
                        "examples": [
                            "Örnekle Pekiştirelim: Ay sonunda hesaplanan 18.000 TL'lik Konaklama Vergisi borcu 360 Ödenecek Vergi ve Fonlar Hesabının alacağına işlenir."
                        ]
                    }
                ],
                {
                    "title": "Örnek Olay: Konaklama Gerçekleştiğinde Avans Hesabının Kapatılması",
                    "story": "Yazın otele gelen acente grubu konaklamasını tamamlar ve 50.000 TL'lik fatura kesilir.",
                    "solution": "Daha önce alacaklandırılan 340 Alınan Sipariş Avansları Hesabı 50.000 TL BORÇLANDIRILARAK kapatılır, 600 Yurt İçi Satışlar Hesabı ALACAKLANDIRILARAK gelir kaydedilir."
                },
                ["İpucu: Pasif kaynak hesaplarında meydana gelen artışlar daima ALACAK tarafına kaydedilir."]
            ),
            make_card(
                2,
                "ÖZ KAYNAKLAR",
                "500 SERMAYE VE DÖNEM NET KÂRI / ZARARI",
                "İşletme sahiplerinin otele koyduğu ana sermaye (500) ve geçmiş faaliyetlerden elde edilen Net Kâr (590) veya Net Zarar (591) Öz Kaynaklarda gösterilir.",
                [
                    {
                        "name": "500 Sermaye Hesabı",
                        "desc": "Otel kurucularının veya ortaklarının işletmeye tahsis ettikleri toplam varlık değerini gösteren temel öz kaynak hesabıdır.",
                        "examples": [
                            "Örnekle Pekiştirelim: Otel ortaklarının işletme banka hesabına yatırdığı 2.000.000 TL nakit sermaye 500 Sermaye Hesabının alacağına kaydedilir."
                        ]
                    },
                    {
                        "name": "590 Dönem Net Kârı / 591 Dönem Net Zararı (-)",
                        "desc": "Faaliyet yılı sonunda Gelir Tablosunun kapatılmasıyla elde edilen net kâr (590) veya net zararın (591) bilançoya aktarıldığı hesaptır.",
                        "examples": [
                            "Örnekle Pekiştirelim: Yıl sonunda otelin tüm gelir ve giderleri düşüldükten sonra kalan 350.000 TL net kâr 590 Dönem Net Kârı hesabında gösterilir."
                        ]
                    }
                ],
                {
                    "title": "Örnek Olay: Sermaye Artırımı Kararı",
                    "story": "Otel yönetimi yeni havuz yapımı için sermayeyi 1.000.000 TL artırma kararı alır.",
                    "solution": "Ortakların yatırdığı tutar 102 Bankalar hesabına borç kaydedilirken, 500 Sermaye Hesabı 1.000.000 TL alacaklandırılarak Öz Kaynak yapısı güçlendirilir."
                },
                ["İpucu: Bilançoda Temel Denklem: AKTİF (Varlıklar) = PASİF (Yabancı Kaynaklar + Öz Kaynaklar) her zaman korunmalıdır."]
            )
        ]
    },
    {
        "title": "Gelir Tablosu Hesapları",
        "learningUnit": "11. Öğrenme Birimi",
        "podcastUrl": None,
        "cards": [
            make_card(
                1,
                "GELİR HESAPLARI",
                "600 YURT İÇİ SATIŞLAR VE SATIŞ GELİRLERİ",
                "Otelin oda satışı, restoran, spa ve düğün organizasyonlarından elde ettiği tüm ana brüt satış gelirleri 600 Yurt İçi Satışlar hesabında toplanır.",
                [
                    {
                        "name": "600 Yurt İçi Satışlar Hesabı",
                        "desc": "İşletmenin ana faaliyet konusu olan konaklama ve yan hizmet satışlarından elde edilen tutarların ALACAK tarafına yazıldığı gelir hesabıdır.\n\nGELİR VE GİDER HESAP KANUNU TABLOSU:\n• Gelir Hesapları (600): Artışlar ALACAK kaydedilir.\n• Gider Hesapları (621, 632): Artışlar BORÇ kaydedilir.\n• Kapanış (690): Gelirler BORÇLANIP kapatılır, Giderler ALACAKLANIP kapatılır.",
                        "examples": [
                            "Örnekle Pekiştirelim: Gün sonunda kesilen 80.000 TL'lik oda ve 30.000 TL'lik restoran faturaları 600 Yurt İçi Satışlar Hesabının alacağına işlenir."
                        ]
                    },
                    {
                        "name": "610 Satıştan İadeler (-) Hesabı",
                        "desc": "Satılan oda veya hizmetin ayıplı olması/iptal edilmesi nedeniyle konuğa iade edilen tutarların borçlandırıldığı gelir azaltıcı hesaptır.",
                        "examples": [
                            "Örnekle Pekiştirelim: Sıcak suyu akmadığı için ayrılan misafire iade edilen 1.500 TL oda ücreti 610 Satıştan İadeler hesabının borcuna yazılır."
                        ]
                    }
                ],
                {
                    "title": "Örnek Olay: Net Satış Hasılatının Bulunması",
                    "story": "Otelin 600 Yurt İçi Satışları 500.000 TL, 610 Satıştan İadeleri 10.000 TL, 611 Satış İskontoları 20.000 TL'dir.",
                    "solution": "Brüt Satışlar (500.000) - İndirimler (10.000 + 20.000) = 470.000 TL Net Satış Hasılatı doğru şekilde hesaplanır."
                },
                ["İpucu: Gelir hesapları (600 gibi) ilk açılışta ve gelir arttıkça daima ALACAK kaydı alır."]
            ),
            make_card(
                2,
                "GİDER HESAPLARI VE DÖNEM SONU",
                "621 STMM, 632 GENEL YÖNETİM VE 690 DÖNEM KÂR/ZARARI DEVİR KAYDI",
                "Maliyetler (621) ve Yönetim Giderleri (632) BORÇ kaydedilir. Dönem sonunda tüm gelir ve giderler 690 hesabında toplanarak net sonuç bilançoya devredilir.",
                [
                    {
                        "name": "632 Genel Yönetim Giderleri Hesabı",
                        "desc": "Otel yönetimi, personel maaşları, elektrik, su, internet ve büro giderlerinin kaydedildiği borç taraflı gider hesabıdır.",
                        "examples": [
                            "Örnekle Pekiştirelim: Ön büro ve resepsiyon personelinin aylık 60.000 TL'lik maaş ödemesi 632 Genel Yönetim Giderleri Hesabının borcuna işlenir."
                        ]
                    },
                    {
                        "name": "690 Dönem Kârı veya Zararı Hesabı (Kapanış Devir Kaydı)",
                        "desc": "Yıl sonunda tüm 6 ile başlayan Gelir hesaplarının borçlandırılarak, tüm Gider hesaplarının alacaklandırılarak aktarıldığı ana özet hesaptır.",
                        "examples": [
                            "Örnekle Pekiştirelim: Yıl sonunda 600 Gelir hesabı (600.000 TL) borçlandırılıp 690'a devredilir; 632 Gider hesabı (400.000 TL) alacaklandırılıp 690'a devredilir. Aradaki 200.000 TL Kâr 590 Bilanço hesabına aktarılır."
                        ]
                    }
                ],
                {
                    "title": "Örnek Olay: Yıl Sonu Gelir Tablosu Kapanış Kaydı",
                    "story": "31 Aralık gecesi saat 24:00'te tüm gelir ve gider hesapları sıfırlanarak yeni yıla temiz başlanacaktır.",
                    "solution": "Tüm 6XX Gelir ve Gider hesapları 690 Kâr/Zarar hesabına devredilerek kapatılır. Gelir Tablosu hesapları yeni yılın başında 0 bakiye ile tertemiz başlar."
                },
                ["İpucu: Gider hesapları (632, 621 vb.) daima BORÇ kaydı alır; dönem sonunda 690 hesabına devredilerek kapatılır."]
            )
        ]
    }
]

# Generate valid Dart code
dart_code = f"""/// 11. Sınıf Ön Büro Hizmetleri Atölyesi Dersi Ders Notları Veri Tabanı
/// MEB Müfredatı ve Yasal Kaynaklar (1774 Sayılı Kimlik Bildirme Kanunu, VUK 213, TTK 6102, Tekdüzen Hesap Planı) ile Doğrulanmıştır.

"""

for i, u in enumerate(units, 1):
    dart_code += f"const Map<String, dynamic> onBuroHizmetleriUnit{i} = {json.dumps(u, ensure_ascii=False, indent=2)};\n\n"

dart_code += "// Tüm 11. Sınıf Ön Büro Hizmetleri Atölyesi Notlar Listesi\n"
dart_code += "const List<Map<String, dynamic>> onBuroHizmetleriNotes = [\n"
for i in range(1, len(units) + 1):
    dart_code += f"  onBuroHizmetleriUnit{i},\n"
dart_code += "];\n"

# Replace JSON 'null' with Dart 'null' and JSON booleans if needed
dart_code = dart_code.replace(": null", ": null")

with open(r"c:\Erol_Mobil_Gelistirme\TurizmAkademi\lib\core\data\courses\11_on_buro_hizmetleri_notes.dart", "w", encoding="utf-8") as f:
    f.write(dart_code)

print("Generated clean Dart file via JSON serializer.")
