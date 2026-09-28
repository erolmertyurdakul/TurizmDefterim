/// 9. Sınıf Otelcilik ve Seyahat Hizmetleri Dersi Ders Notları Veri Tabanı
/// MEB Maarif Modeli ve '9. Sınıf Otelcilik ve Seyahat Hizmetleri' Resmi Ders Kitabı Esas Alınmıştır.

// 1. Öğrenme Birimi Notları
const Map<String, dynamic> otelcilikUnit1 = {
  "title": "Kişisel Hijyen Kuralları",
  "learningUnit": "1. Öğrenme Birimi",
  "podcastUrl": "https://anchor.fm/s/114a64400/podcast/play/126260350/https%3A%2F%2Fd3ctxlq1ktw2nl.cloudfront.net%2Fstaging%2F2026-8-24%2Fc63c7566-6844-50bd-df57-9ef70190ba06.m4a",
  "cards": [
    {
      "id": 1,
      "tag": "HİJYEN VE ÖNEMİ",
      "title": "KİŞİSEL HİJYEN KAVRAMI VE TURİZMDEKİ ÖNEMİ",
      "microSummary": "Kişisel hijyen, turizm personelinin sağlığını korurken konuklara güven veren en temel mesleki sorumluluktur.",
      "definitions": [
        {
          "name": "Kişisel Hijyen",
          "desc": "Bireyin kendi sağlığını korumak, sürdürmek ve mikroorganizmaların başkalarına bulaşmasını engellemek amacıyla uyguladığı tüm öz bakım ve temizlik uygulamalarıdır.",
          "examples": [
            "Örnekle Pekiştirelim: Beş yıldızlı bir otelde resepsiyonist olarak çalışan personelin işe başlamadan önce kişisel bakımını eksiksiz tamamlaması, konukların otele adım attıkları ilk anda güven duymalarını sağlar."
          ]
        },
        {
          "name": "Turizmde Hijyenin Prestij Etkisi",
          "desc": "Konaklama ve seyahat işletmelerinde temizlik ve hijyen standartlarının yüksek olması, işletmenin marka değerini, konuk memnuniyetini ve tavsiye edilme oranını doğrudan artırır.",
          "examples": [
            "Örnekle Pekiştirelim: Misafirlerin çevrim içi değerlendirme platformlarında otel hakkında yazdıkları olumlu yorumlarda personelin titizliği ve kişisel bakımının övülmesi, işletmenin doluluk oranını olumlu etkiler."
          ]
        }
      ],
      "caseStudy": "Sektörden Vaka: Bir butik otelde resepsiyon görevlisinin dağınık saçları ve özensiz görünümü sebebiyle bir konuk odasını görmeden rezervasyonunu iptal etmek istemiştir. Durumu fark eden ön büro müdürü, hemen devreye girerek kurumsal hijyen standartlarını hatırlatmış ve personelin kişisel bakım eğitimlerini yenilemiştir.",
      "tip": "Kişisel hijyen sadece bir temizlik kuralı değil; işletmenizin kalitesini ve misafire duyduğunuz saygıyı yansıtan bir meslek etiğidir."
    },
    {
      "id": 2,
      "tag": "VÜCUT VE EL BAKIMI",
      "title": "VÜCUT TEMİZLİĞİ VE EL YIKAMA STANDARTLARI",
      "microSummary": "Düzenli duş almak ve elleri tekniğine uygun yıkamak, mikropların yayılmasını önlemenin en etkili yoludur.",
      "definitions": [
        {
          "name": "Vücut Temizliği",
          "desc": "Ter kokusunu önlemek, deri sağlığını korumak ve gün boyu zinde kalabilmek için her gün veya gün aşırı ılık su ve sabunla banyo yapılmasıdır.",
          "examples": [
            "Örnekle Pekiştirelim: Yoğun yaz sezonunda kat hizmetleri departmanında görev yapan bir personelin her vardiya öncesinde duş alarak nötr kokulu bir deodorant kullanması gün boyu ferah çalışmasını sağlar."
          ]
        },
        {
          "name": "Standart El Yıkama Tekniği",
          "desc": "Ellerin bol su ve sabunla, parmak araları, tırnak uçları ve bilekler dahil olmak üzere en az 20 saniye boyunca ovalanarak yıkanması ve tek kullanımlık havluyla kurulanmasıdır.",
          "examples": [
            "Örnekle Pekiştirelim: Ön büro personelinin nakit para, pasaport veya bagaj fişi teslim aldıktan sonra ellerini hijyen kurallarına uygun şekilde yıkaması ya da dezenfekte etmesi çapraz bulaşmayı önler."
          ]
        },
        {
          "name": "El ve Tırnak Bakımı",
          "desc": "Tırnakların kısa, temiz ve kirden arındırılmış olması; ellerde çatlak ve yara oluşumunun nemlendiricilerle önlenmesidir.",
          "examples": [
            "Örnekle Pekiştirelim: Kat şefinin tırnaklarını et hizasında düzgünce kesmesi, hem temizlik eldiveni kullanırken eldivenin yırtılmasını engeller hem de estetik bir görünüm sağlar."
          ]
        }
      ],
      "caseStudy": "Sektörden Vaka: Bir tatil köyünde yapılan iç denetimde, parmak aralarını yeterince sabunlamadan ellerini aceleyle yıkayan personelin el hijyen testlerinde yüksek bakteri yükü tespit edilmiştir. Hijyen sorumlusu, tüm personele 20 saniyelik doğru el yıkama basamaklarını gösteren bilgilendirici panolar asmıştır.",
      "tip": "Ellerinizi yıkarken 20 saniye kuralını unutmayın; tırnak dipleri ve başparmak çevreleri mikropların en çok gizlendiği noktalardır."
    },
    {
      "id": 3,
      "tag": "AĞIZ VE SAÇ BAKIMI",
      "title": "AĞIZ, DİŞ, SAÇ VE CİLT BAKIMI STANDARTLARI",
      "microSummary": "Ağız kokusunu önlemek ve düzgün saç-sakal bakımı, yüz yüze iletişimde profesyonelliğin temelidir.",
      "definitions": [
        {
          "name": "Ağız ve Diş Hijyeni",
          "desc": "Günde en az iki kez dişlerin fırçalanması, dil temizliği yapılması ve nefes ferahlığını sağlamak için gargara veya nane içerikli spreylerden faydalanılmasıdır.",
          "examples": [
            "Örnekle Pekiştirelim: Konuklarla yakın mesafeden check-in işlemi yapan resepsiyonistin sabah vardiyası öncesinde dişlerini fırçalayıp ağız spreyi kullanması iletişimin konforunu artırır."
          ]
        },
        {
          "name": "Saç ve Sakal Standartları",
          "desc": "Saçların temiz, taranmış ve dökülmeyecek şekilde toplanması; erkek personelin günlük sakal tıraşı olması veya işletme standartlarına uygun düzeltilmiş sakala sahip olmasıdır.",
          "examples": [
            "Örnekle Pekiştirelim: Uzun saçlı bir kat görevlisinin saçlarını arkadan şık bir fileyle toplaması, oda temizliği sırasında dökülmelerin önüne geçer."
          ]
        },
        {
          "name": "Cilt Bakımı ve Parfüm Kullanımı",
          "desc": "Cildin temiz ve sağlıklı tutulması; misafirleri rahatsız edecek ağır ve baskın parfümler yerine hafif ve ferahlatıcı kokuların tercih edilmesidir.",
          "examples": [
            "Örnekle Pekiştirelim: Servis personelinin ağır baharatlı parfümler yerine hafif çiçeksi veya narenciye tonlarında kokular seçmesi konukların rahatsız olmasını engeller."
          ]
        }
      ],
      "caseStudy": "Sektörden Vaka: Bir misafir, check-in sırasında personelin yoğun sigara ve ağız kokusundan rahatsız olarak lobiyi terk etmiştir. Bu geri bildirim üzerine otel yönetimi, sigara içme molalarının ardından diş fırçalama veya ağız gargarası kullanımını zorunlu kılan bir iç yönetmelik yayımlamıştır.",
      "tip": "Turizmde aşırı koku da kokusuzluk kadar risklidir; her zaman hafif, tazeleyici ve rahatsız etmeyen kokuları seçin."
    },
    {
      "id": 4,
      "tag": "SAĞLIKLI YAŞAM",
      "title": "BESLENME VE SAĞLIKLI YAŞAM KURALLARI",
      "microSummary": "Dengeli beslenme, yeterli su tüketimi ve uyku düzeni, vardiyalı çalışma koşullarında enerjiyi yüksek tutar.",
      "definitions": [
        {
          "name": "Dengeli Beslenme",
          "desc": "Günün temposuna uygun olarak protein, karbonhidrat, vitamin ve minerallerin dengeli tüketilmesi, ağır ve sindirimi güç yağlı yiyeceklerden kaçınılmasıdır.",
          "examples": [
            "Örnekle Pekiştirelim: Sabah vardiyasında çalışan personelin kahvaltıda aşırı yağlı hamur işleri yerine yumurta, peynir, yeşillik ve tam buğday ekmeği tüketmesi gün içi konsantrasyonunu korur."
          ]
        },
        {
          "name": "Yeterli Sıvı Alımı",
          "desc": "Vücudun su dengesini korumak, yorgunluğu önlemek ve toksinlerin atılmasını sağlamak için günde en az 2-2,5 litre su tüketmektir.",
          "examples": [
            "Örnekle Pekiştirelim: Sıcak yaz aylarında havuz ve sahil bölgesinde çalışan etkinlik personelinin düzenli aralıklarla su içerek vücut ısısını dengede tutması."
          ]
        },
        {
          "name": "Uyku ve Dinlenme Düzeni",
          "desc": "Vardiya değişimlerinde vücudun biyolojik saatini koruyarak günde ortalama 7-8 saat kaliteli uyku uyumaktır.",
          "examples": [
            "Örnekle Pekiştirelim: Gece vardiyasında çalışan gece denetçisinin gündüz saatlerinde sessiz ve karanlık bir odada dinlenerek uyku ihtiyacını karşılaması."
          ]
        }
      ],
      "caseStudy": "Sektörden Vaka: Yetersiz uyku ve düzensiz beslenme yüzünden vardiya esnasında dikkati dağılan bir resepsiyonist, konuğun oda kartına yanlış oda numarası kodlamış ve başka bir konuğun odasının kapısının açılmasına neden olmuştur. Yapılan incelemede personelin uykusuzluktan kaynaklı hata yaptığı anlaşılmıştır.",
      "tip": "Vardiyalı çalışmanın en büyük ilacı kaliteli uykudur; uyumadan önce parlak ekranlardan uzak durarak dinlenmenizi destekleyin."
    },
    {
      "id": 5,
      "tag": "İŞ KIYAFETİ",
      "title": "İŞ KIYAFETLERİNİN ÖZELLİKLERİ, BAKIMI VE TEMİZLİĞİ",
      "microSummary": "Üniforma, otelin kurumsal imajını yansıtan ve personelin güvenle çalışmasını sağlayan bir meslek zırhıdır.",
      "definitions": [
        {
          "name": "İş Kıyafeti (Üniforma)",
          "desc": "Çalışanların departmanlarına göre belirlenmiş, kumaşı nefes alabilen, leke tutmayan, rahat hareket imkanı veren ve kurumsal renkleri taşıyan özel kıyafetlerdir.",
          "examples": [
            "Örnekle Pekiştirelim: Resepsiyon personelinin takım elbise ve kurumsal kravat/fular takması, kat görevlilerinin ise esnek ve terletmeyen özel kumaşlı önlük takımları giymesi."
          ]
        },
        {
          "name": "Üniforma Bakımı ve Ütüleme",
          "desc": "Üniformanın lekesiz, söküksüz, düğmeleri tam ve kusursuz ütülü olarak giyilmesi kuralıdır.",
          "examples": [
            "Örnekle Pekiştirelim: Personelin her nöbet öncesinde üniformasını otelin terzihane ve çamaşırhanesinde ütületip düğmelerini kontrol etmesi."
          ]
        },
        {
          "name": "İsimlik (Yaka Kartı) ve Aksesuar Kuralı",
          "desc": "İsimliğin sol göğüs hizasına düzgünce takılması; sallantılı ve abartılı takılar yerine sadece sade bir saat ve evlilik yüzüğü kullanılmasıdır.",
          "examples": [
            "Örnekle Pekiştirelim: Misafirin personele adıyla hitap edebilmesi için yaka kartının temiz ve kolay okunabilir şekilde göğse iğnelenmesi."
          ]
        }
      ],
      "caseStudy": "Sektörden Vaka: Bir kongre otelinde önemli bir delegasyonun karşılanması sırasında personelin gömleğindeki kahve lekesi organizatörün dikkatini çekmiş ve resmi şikayette bulunmuştur. Bu olaydan sonra kat şeflerine vardiya başında kılık-kıyafet kontrolü zorunluluğu getirilmiştir.",
      "tip": "İsimliğiniz sizin işletmedeki imzanızdır; her zaman göğsünüzün sol tarafında, temiz ve dik durmalıdır."
    },
    {
      "id": 6,
      "tag": "VÜCUT MEKANİKLERİ",
      "title": "VÜCUT MEKANİKLERİ VE ERGONOMİK HAREKET ETME",
      "microSummary": "Dizleri bükerek ağırlık kaldırmak ve doğru duruş sergilemek, meslek hastalıklarından korunmanın anahtarıdır.",
      "definitions": [
        {
          "name": "Ergonomi ve Vücut Mekaniği",
          "desc": "İş ortamındaki fiziksel hareketlerin insan anatomisine ve omurga sağlığına en uygun şekilde planlanması bilimidir.",
          "examples": [
            "Örnekle Pekiştirelim: Ağır bir bavulu veya temizlik arabasını taşırken beli bükmek yerine bacak kaslarını kullanarak dengeli güç uygulamak."
          ]
        },
        {
          "name": "Ağırlık Kaldırma Tekniği",
          "desc": "Yükün yakınına yaklaşarak ayakları omuz genişliğinde açmak, dizleri büküp çömelmek, sırtı dik tutarak yükü vücuda yakın kaldırmaktır.",
          "examples": [
            "Örnekle Pekiştirelim: Kat görevlisinin ağır nevresim bohçasını belini eğerek değil, dizlerini büküp bacaklarından güç alarak kaldırması bel fıtığı riskini ortadan kaldırır."
          ]
        },
        {
          "name": "Doğru Ayakta Durma ve Oturma Postürü",
          "desc": "Ağırlığı iki ayağa eşit dağıtarak omuzları dik tutmak; otururken sırt desteğini kullanıp ayakları yere düz basmaktır.",
          "examples": [
            "Örnekle Pekiştirelim: Ön büroda 8 saat boyunca ayakta kalan resepsiyonistin tek ayağına yüklenmek yerine ağırlığı dengeli paylaştırması ve destekleyici ortopedik tabanlık kullanması."
          ]
        }
      ],
      "caseStudy": "Sektörden Vaka: Bir kat görevlisi, ağır çamaşır sepetini aniden belden dönerek kaldırmaya çalıştığı için bel spazmı geçirmiş ve iki hafta iş göremez raporu almıştır. İş sağlığı ve güvenliği uzmanı, personele 'dönüş hareketlerini belden değil ayak uçlarıyla yapma' kuralını uygulamalı olarak anlatmıştır.",
      "tip": "Yük kaldırırken beliniz değil dizleriniz bükülsün; omurganız sizin en değerli çalışma sermayenizdir."
    }
  ]
};

// 2. Öğrenme Birimi Notları
const Map<String, dynamic> otelcilikUnit2 = {
  "title": "İletişim Teknikleri",
  "learningUnit": "2. Öğrenme Birimi",
  "podcastUrl": "https://anchor.fm/s/114a64400/podcast/play/126260639/https%3A%2F%2Fd3ctxlq1ktw2nl.cloudfront.net%2Fstaging%2F2026-8-24%2F1670a566-4b2a-5ea9-44d8-c69bc36a0116.m4a",
  "cards": [
    {
      "id": 1,
      "tag": "İLETİŞİM SÜRECİ",
      "title": "İLETİŞİM KAVRAMI, SÜRECİ VE TEMEL TEKNİKLER",
      "microSummary": "İletişim; kaynak ile alıcı arasında bilgi, duygu ve düşüncelerin ortak bir anlayışla paylaşılmasıdır.",
      "definitions": [
        {
          "name": "İletişim Sürecinin Öğeleri",
          "desc": "Kaynak (gönderici), mesaj (ileti), kanal (iletişim aracı), alıcı (hedef) ve dönüt (geribildirim) öğelerinden oluşan dinamik etkileşim sürecidir.",
          "examples": [
            "Örnekle Pekiştirelim: Resepsiyonistin (kaynak) konuğa (alıcı) kahvaltı saatlerini (mesaj) sözlü olarak (kanal) aktarması ve konuğun 'Anladım, teşekkür ederim' diyerek onaylaması (dönüt)."
          ]
        },
        {
          "name": "Etkin Dinleme",
          "desc": "Karşıdaki kişiyi sözünü kesmeden, göz teması kurarak, anladığını baş hareketleriyle teyit ederek ve dikkatle dinleme becerisidir.",
          "examples": [
            "Örnekle Pekiştirelim: Odayla ilgili bir talepte bulunan misafiri başka bir işle meşgul olmadan dinleyip 'Notumu aldım, hemen ilgileniyorum' demek."
          ]
        },
        {
          "name": "Empati Kurma",
          "desc": "Kendini misafirin yerine koyarak onun duygularını, ihtiyaçlarını ve beklentilerini içtenlikle anlama yeteneğidir.",
          "examples": [
            "Örnekle Pekiştirelim: Uzun bir uçak yolculuğundan yorgun dönen bir konuğa işlemlerini hızlandırıp bir bardak su ikram ederek anlayış göstermek."
          ]
        }
      ],
      "caseStudy": "Sektörden Vaka: Konuğunun oda kliması arızası şikayetini dinlerken gözünü bilgisayar ekranından ayırmayan resepsiyonist, misafirin öfkelenmesine yol açmıştır. Misafir 'Beni dinlemiyorsunuz bile!' diyerek tepki göstermiştir. Müdahale eden müdür, konukla göz hizasında sakin bir iletişim kurarak sorunu çözmüştür.",
      "tip": "Dinlemek sadece duymak değildir; karşınızdakine değer verdiğinizi bakışlarınızla ve ilginizle hissettirmektir."
    },
    {
      "id": 2,
      "tag": "İLETİŞİM HATALARI",
      "title": "İLETİŞİMDE DİKKAT EDİLECEK HUSUSLAR VE SIK YAPILAN HATALAR",
      "microSummary": "Nezaket sözcükleri kapıları açarken; emir kipi ve lakayt tavırlar iletişimi anında koparır.",
      "definitions": [
        {
          "name": "Sihirli Nezaket Sözcükleri",
          "desc": "'Lütfen', 'Rica ederim', 'Memnuniyetle', 'Hoş geldiniz', 'İyi günler' gibi cümleleri zarafetle tamamlayan profesyonel kalıplardır.",
          "examples": [
            "Örnekle Pekiştirelim: Konuğa 'Burayı imzala' demek yerine 'Lütfen şu alanı imzalayabilir misiniz?' demek aradaki saygıyı korur."
          ]
        },
        {
          "name": "İletişim Engelleri ve Hatalar",
          "desc": "Emir kipiyle konuşmak, misafirin sözünü kesmek, argo veya lakayt ifadeler kullanmak ve konuğa önyargıyla yaklaşmaktır.",
          "examples": [
            "Örnekle Pekiştirelim: Personelin kendi aralarında misafirin duyabileceği şekilde mesai bitimi veya iş yoğunluğu hakkında şikayet etmesi büyük bir iletişim hatasıdır."
          ]
        },
        {
          "name": "Açık ve Anlaşılır Dil Kullanımı",
          "desc": "Mesleki jargon veya karmaşık yabancı terimler yerine misafirin kolayca anlayacağı net ve sade cümleler kurmaktır.",
          "examples": [
            "Örnekle Pekiştirelim: Konuğa 'Odanız no-show olmuş' demek yerine 'Rezervasyonunuz teyit edilmediği için maalesef iptale düşmüş' şeklinde izah etmek."
          ]
        }
      ],
      "caseStudy": "Sektörden Vaka: Yeni başlayan bir acente satış personeli, tura katılmak isteyen yaşlı bir çifte sürekli 'voucher', 'pnr', 'allotment' gibi sektörel terimlerle bilgi vermeye çalışmış, çift hiçbir şey anlamadığı için başka bir acenteye gitmiştir. Yapılan eğitimde terimlerin misafire sadeleştirilerek anlatılması kuralı vurgulanmıştır.",
      "tip": "Mesleki bilginizi terimlerle hava atmak için değil, misafirin işini kolaylaştırmak için kullanın."
    },
    {
      "id": 3,
      "tag": "BEDEN DİLİ",
      "title": "SÖZSÜZ İLETİŞİM VE BEDEN DİLİ STANDARTLARI",
      "microSummary": "Beden dili sözlerden önce konuşur; doğru bir duruş ve sıcak bir tebessüm güven inşa eder.",
      "definitions": [
        {
          "name": "Beden Dili (Sözsüz İletişim)",
          "desc": "Yüz ifadeleri (mimikler), el-kol hareketleri (jestler), duruş pozisyonu ve göz temasıyla mesaj iletme sanatıdır.",
          "examples": [
            "Örnekle Pekiştirelim: Misafir resepsiyona yaklaştığında dik bir duruş alıp tebessüm ederek hafifçe baş selamı vermek sözsüz bir 'Hoş geldiniz' mesajıdır."
          ]
        },
        {
          "name": "Göz Teması ve Gülümseme",
          "desc": "Karşıdaki kişiyi rahatsız etmeden, samimi ve güven veren bir bakışla göz teması kurmak ve bunu sıcak bir tebessümle desteklemektir.",
          "examples": [
            "Örnekle Pekiştirelim: Sorun yaşayan bir misafirle konuşurken gözleri kaçırmadan dinlemek samimiyeti ve çözüm isteğini gösterir."
          ]
        },
        {
          "name": "Kişisel Alan ve Mesafe Kuralı",
          "desc": "İletişim sırasında misafirin mahrem alanına girmeden, yaklaşık 1-1,5 metrelik sosyal mesafeyi koruyarak konuşmaktır.",
          "examples": [
            "Örnekle Pekiştirelim: Odayı tanıtan bellboyun misafirin çok dibinde durmadan, eşyaları rahatça inceleyebileceği saygılı bir mesafede durması."
          ]
        }
      ],
      "caseStudy": "Sektörden Vaka: Bir transfer görevlisi karşılama esnasında kollarını göğsünde kavuşturmuş ve duvara yaslanarak misafirleri beklemiştir. Misafirler kendilerinin isteksizce karşılandığını hissederek acenteye şikayette bulunmuştur. Kolların kavuşturulması 'iletişime kapalıyım' mesajı verdiği için personel uyarılmıştır.",
      "tip": "Kollarınızı göğsünüzde kavuşturmayın, ellerinizi ceplerinize sokmayın; açık beden dili her zaman misafire güven verir."
    },
    {
      "id": 4,
      "tag": "GÖRGÜ KURALLARI",
      "title": "TOPLUMDA VE İŞ HAYATINDA NEZAKET VE GÖRGÜ KURALLARI",
      "microSummary": "Protokol ve görgü kuralları; selamlaşma, tanışma ve tokalaşmada profesyonel duruşu belirler.",
      "definitions": [
        {
          "name": "Selamlaşma ve Tanışma Hiyerarşisi",
          "desc": "Sosyal yaşamda ve iş dünyasında küçüğün büyüğe, erkeğin kadına, astın üste takdim edilmesi ve selam vermesidir.",
          "examples": [
            "Örnekle Pekiştirelim: Genel müdür odaya girdiğinde toplantıdaki astların ayağa kalkarak saygıyla selam vermesi."
          ]
        },
        {
          "name": "El Sıkma (Tokalaşma) Kuralları",
          "desc": "Tokalaşmada ilk hareketin üstten veya kadından gelmesi beklenir; el ne çok gevşek ne de kemik kıracak kadar sert sıkılmalıdır.",
          "examples": [
            "Örnekle Pekiştirelim: VIP konuk elini uzattığında personelin göz teması kurarak kendinden emin, dengeli bir şekilde elini sıkması."
          ]
        },
        {
          "name": "Hitap Kuralları",
          "desc": "Konuklara 'Beyefendi', 'Hanımefendi' veya soyadlarıyla ('Sayın Yılmaz') hitap edilmesi, asla 'Sen', 'Abi', 'Abla' denilmemesidir.",
          "examples": [
            "Örnekle Pekiştirelim: Genç bir misafire bile samimiyet sınırını aşmadan 'Hoş geldiniz Mehmet Bey' şeklinde hitap edilmesi."
          ]
        }
      ],
      "caseStudy": "Sektörden Vaka: Bir resepsiyonist düzenli gelen yerli bir misafire 'Hoş geldin abi, ne haber?' diye hitap etmiş, misafir tebessüm etse de yanındaki yabancı iş ortaklarının önünde küçük düştüğünü belirterek müdüre rahatsızlığını iletmiştir. Profesyonel mesafe hiçbir zaman kaybedilmemelidir.",
      "tip": "Samimiyet saygıyı yok etmemelidir; misafirle ne kadar yakın olursanız olun resmi ve kibar hitabı koruyun."
    },
    {
      "id": 5,
      "tag": "TELEFONDA İLETİŞİM",
      "title": "TELEFONDA İLETİŞİM VE DİKSİYON STANDARTLARI",
      "microSummary": "Telefonda ses tonu sizin yüzünüzdür; gülümseyerek konuşmak sesinize yansır.",
      "definitions": [
        {
          "name": "Telefon Açma Kuralı (3 Çalma Standardı)",
          "desc": "Otel telefonlarının en geç 3. çalışta açılması, önce kurum adı, sonra departman ve personel adıyla kurumsal karşılama yapılmasıdır.",
          "examples": [
            "Örnekle Pekiştirelim: 'İyi günler, Turizm Oteli Resepsiyon, ben Ahmet, size nasıl yardımcı olabilirim?' kalıbıyla telefonu yanıtlamak."
          ]
        },
        {
          "name": "Telefonda Not Alma ve Teyit Etme",
          "desc": "Arayanın adını, oda numarasını veya iletişim bilgisini ve talebini eksiksiz not alarak görüşme bitmeden tekrar ederek teyit etmektir.",
          "examples": [
            "Örnekle Pekiştirelim: 'Mert Bey, yarın sabah saat 07:00 için uyandırma servisi talebinizi 402 nolu odanız için kaydettim, doğru mudur?' diyerek teyit almak."
          ]
        },
        {
          "name": "Telefonu Kapatma Zarafeti",
          "desc": "Görüşmeyi arayan kişinin sonlandırmasını beklemek, ahizeyi sertçe çarpmadan nazikçe yerine koymaktır.",
          "examples": [
            "Örnekle Pekiştirelim: Misafir 'İyi günler' dedikten sonra 'Biz teşekkür eder, iyi günler dileriz' diyerek misafirin kapatmasını beklemek."
          ]
        }
      ],
      "caseStudy": "Sektörden Vaka: Bir misafir oda servisini 6 kez aramış ancak telefon açılmamıştır. Sonunda açıldığında ise personel nefes nefese 'Evet, ne vardı?' demiştir. Misafir bu durumu genel müdüre iletmiş, departmanda telefon karşılama eğitimi baştan sona yenilenmiştir.",
      "tip": "Telefonla konuşurken gülümserseniz, karşı taraf ses tonunuzdaki sıcaklığı hemen hisseder."
    },
    {
      "id": 6,
      "tag": "DİJİTAL İLETİŞİM (NETİKET)",
      "title": "DİJİTAL İLETİŞİM VE İNTERNET NEZAKETİ (NETİKET)",
      "microSummary": "Dijital ortamda yazılan her kelime kalıcıdır; büyük harfle yazmak bağırmak anlamına gelir.",
      "definitions": [
        {
          "name": "Netiket (Netiquette)",
          "desc": "İnternet, e-posta ve sosyal medya yazışmalarında uyulması gereken görgü, nezaket ve saygı kuralları bütünüdür.",
          "examples": [
            "Örnekle Pekiştirelim: Misafire gönderilen rezervasyon onay e-postasının saygılı bir hitapla başlayıp kurumsal imza ve iletişim bilgileriyle bitirilmesi."
          ]
        },
        {
          "name": "Büyük Harf Kullanımı Kuralı",
          "desc": "Dijital mesajlaşmalarda cümlenin tamamını BÜYÜK HARFLERLE yazmanın sanal dünyada 'bağırmak ve azarlamak' anlamına gelmesi kuralıdır.",
          "examples": [
            "Örnekle Pekiştirelim: Rezervasyon teyit mesajında 'REZERVASYONUNUZ İPTAL EDİLMİŞTİR' yazmak yerine 'Rezervasyonunuz talebiniz üzerine iptal edilmiştir' şeklinde yazmak."
          ]
        },
        {
          "name": "Hızlı ve Net Yanıt Standardı",
          "desc": "Misafirlerden gelen e-posta ve mesaj taleplerine en geç 24 saat (mümkünse ilk 1 saat) içerisinde profesyonelce cevap verilmesidir.",
          "examples": [
            "Örnekle Pekiştirelim: Web sitesinden transfer talebi ileten bir misafire 15 dakika içinde detaylı transfer aracı ve saat bilgisiyle dönüş yapmak."
          ]
        }
      ],
      "caseStudy": "Sektörden Vaka: Bir satış personeli, fiyat indirimi talep eden acenteye tamamı büyük harflerle 'BU TARİHTE İNDİRİM MÜMKÜN DEĞİLDİR' şeklinde tek satırlık e-posta atmıştır. Acente yetkilisi kaba üslup nedeniyle rezervasyonları başka bir otele kaydırmıştır.",
      "tip": "E-postanızı göndermeden önce mutlaka bir kez baştan sona okuyun; yazılı söz uçmaz, kurumu bağlar."
    }
  ]
};

// 3. Öğrenme Birimi Notları
const Map<String, dynamic> otelcilikUnit3 = {
  "title": "Temel Konaklama Hizmetleri",
  "learningUnit": "3. Öğrenme Birimi",
  "podcastUrl": "https://anchor.fm/s/114a64400/podcast/play/126260875/https%3A%2F%2Fd3ctxlq1ktw2nl.cloudfront.net%2Fstaging%2F2026-8-24%2F4b5a78d0-ffcc-1d21-8bb0-e8264068af3b.m4a",
  "cards": [
    {
      "id": 1,
      "tag": "ORGANİZASYON YAPISI",
      "title": "KONAKLAMA İŞLETMELERİNDE ORGANİZASYON YAPISI VE DEPARTMANLAR",
      "microSummary": "Bir otel, misafire kusursuz bir deneyim sunmak için senkronize çalışan departmanlardan oluşur.",
      "definitions": [
        {
          "name": "Konaklama İşletmesi Organizasyonu",
          "desc": "Genel Müdürlük liderliğinde Ön Büro, Kat Hizmetleri, Yiyecek-İçecek, Etkinlik, Muhasebe, İnsan Kaynakları, Teknik Servis ve Güvenlik birimlerinin hiyerarşik iş birliğidir.",
          "examples": [
            "Örnekle Pekiştirelim: 500 odalı bir resort otelde genel müdür yardımcısına bağlı çalışan departman müdürlerinin haftalık koordinasyon toplantısında doluluk oranlarını değerlendirmesi."
          ]
        },
        {
          "name": "Operasyonel (Hizmet) Departmanları",
          "desc": "Misafirle doğrudan temas halinde olan ve temel konaklama hizmetini üreten birimlerdir (Ön Büro, Kat Hizmetleri, Yiyecek-İçecek, Etkinlik).",
          "examples": [
            "Örnekle Pekiştirelim: Misafirin karşılanmasından (Ön Büro), odasının hazırlanmasına (Kat Hizmetleri) kadar tüm aşamaların operasyonel birimlerce yürütülmesi."
          ]
        },
        {
          "name": "Destek Departmanları",
          "desc": "Operasyonun aksamadan yürümesi için lojistik, idari, teknik ve finansal altyapıyı sağlayan birimlerdir (Teknik Servis, Muhasebe, İK, Güvenlik).",
          "examples": [
            "Örnekle Pekiştirelim: Teknik servisin kazan dairesini ve jeneratörleri 7/24 çalışır vaziyette tutarak otelin enerji sürekliliğini sağlaması."
          ]
        }
      ],
      "caseStudy": "Sektörden Vaka: Bir şehir otelinde klima sistemi arızalandığında teknik servis ile kat hizmetleri arasındaki iletişim kopukluğu nedeniyle oda misafire arızalı olarak teslim edilmiştir. Misafirin haklı şikayeti üzerine iki departman arasına anlık arıza takip yazılımı entegre edilmiştir.",
      "tip": "Hiçbir departman diğerinden üstün değildir; bir otel bir saat mekanizması gibidir, tek bir çark durursa tüm sistem aksar."
    },
    {
      "id": 2,
      "tag": "ÖN BÜRO",
      "title": "ÖN BÜRO DEPARTMANI VE ALT BİRİMLERİ",
      "microSummary": "Ön büro, otelin 'beyni ve aynası'dır; konuğun ilk ve son temas noktasıdır.",
      "definitions": [
        {
          "name": "Ön Büro (Front Office)",
          "desc": "Konukların rezervasyon, karşılama, kayıt, oda satışı, bilgi verme, faturalandırma ve uğurlama işlemlerinin yapıldığı merkezi departmandır.",
          "examples": [
            "Örnekle Pekiştirelim: Misafirin otele girişinde güler yüzle karşılanıp kimlik bilgilerinin alınıp oda anahtar kartının takdim edildiği resepsiyon bankosu."
          ]
        },
        {
          "name": "Ön Büro Alt Birimleri",
          "desc": "Rezervasyon (oda ayırtma), Resepsiyon (kayıt ve anahtar), Concierge / Danışma (bagaj ve yönlendirme), Ön Büro Kasa (hesap ve tahsilat), Gece Denetimi (gün sonu kontrolleri) birimleridir.",
          "examples": [
            "Örnekle Pekiştirelim: Misafirin şehri gezmek için danışmadan (Concierge) şehir haritası ve müze kartı hakkında bilgi alması."
          ]
        },
        {
          "name": "Ön Büro Personelinin Nitelikleri",
          "desc": "Düzgün diksiyon, yabancı dil bilgisi, kriz çözme becerisi, güler yüz ve otomasyon sistemlerine (PMS) hakimiyettir.",
          "examples": [
            "Örnekle Pekiştirelim: Yabancı bir konuk geldiğinde resepsiyonistin akıcı bir İngilizce ile otel imkanlarını tanıtması."
          ]
        }
      ],
      "caseStudy": "Sektörden Vaka: Bir kongre döneminde aynı anda gelen 40 kişilik heyetin check-in işlemleri sırasında resepsiyon ekibi önceden hazırladıkları anahtar kart zarflarını dağıtarak yığılmayı önlemiş ve heyetin 5 dakika içinde odalarına geçmesini sağlamıştır.",
      "tip": "İlk izlenim 30 saniyede oluşur; ön bürodaki tebessümünüz misafirin tüm tatil algısını belirler."
    },
    {
      "id": 3,
      "tag": "ÖN BÜRO FORMLARI VE ODALAR",
      "title": "ÖN BÜRO FORMLARI VE ODA TİPLERİ",
      "microSummary": "Rezervasyon formundan konaklama belgesine kadar her evrak resmi birer hukuki kayıttır.",
      "definitions": [
        {
          "name": "Ön Büro Temel Formları",
          "desc": "Rezervasyon Formu (talep detayları), Konaklama Belgesi / Regcard (misafir kimlik ve imza belgesi), VIP Bildirim Formu (özel misafir ikramları), Döviz Alım Bordrosu.",
          "examples": [
            "Örnekle Pekiştirelim: Misafirin check-in esnasında Konaklama Belgesi'ni (Regcard) imzalayarak KVKK ve otel kurallarını kabul etmesi."
          ]
        },
        {
          "name": "Fiziki Özelliklerine Göre Oda Tipleri",
          "desc": "Single (Tek kişilik), Double (Çift kişilik tek büyük yatak), Twin (İki ayrı tek kişilik yatak), Triple (Üç kişilik), Suite (Oturma odası + yatak odası), Family Room (Aile odası), King Suite (Kral dairesi).",
          "examples": [
            "Örnekle Pekiştirelim: İki iş arkadaşının rezervasyon yaptırırken özellikle iki ayrı yatağın bulunduğu 'Twin Room' talep etmesi."
          ]
        },
        {
          "name": "Engelli Odası (Handicapped Room)",
          "desc": "Tekerlekli sandalye geçişine uygun geniş kapılı, banyosunda tutunma barları ve acil çağrı butonu bulunan özel donanımlı odalardır.",
          "examples": [
            "Örnekle Pekiştirelim: Bedensel engelli konuğa lobi katında bulunan ve eşiksiz duşakabini olan özel odanın tahsis edilmesi."
          ]
        }
      ],
      "caseStudy": "Sektörden Vaka: Çift kişilik yatak (Double) isteyen bir balayı çiftine yanlışlıkla iki ayrı yataklı (Twin) oda verilmesi büyük bir memnuniyetsizlik yaratmıştır. Ön büro müdürü hemen çifti deniz manzaralı süit odaya yükselterek (upgrade) meyve sepeti ikramıyla durumu telafi etmiştir.",
      "tip": "Oda tahsisi yaparken konuğun özel notlarını (kat tercihi, yatak tipi) sisteme mutlaka doğru işleyin."
    },
    {
      "id": 4,
      "tag": "KAT HİZMETLERİ",
      "title": "KAT HİZMETLERİ DEPARTMANI VE BİRİMLERİ",
      "microSummary": "Kat hizmetleri, otelin hijyen ve konfor omurgasıdır; temiz bir oda satılabilir odadır.",
      "definitions": [
        {
          "name": "Kat Hizmetleri (Housekeeping)",
          "desc": "Konuk odalarının, kat koridorlarının, lobi ve genel alanların temizlik, düzen, hijyen ve bakımından sorumlu olan departmandır.",
          "examples": [
            "Örnekle Pekiştirelim: Kat görevlisinin sabah saatlerinde oda kapısını çalarak temizlik ve havlu değişimini tamamlaması."
          ]
        },
        {
          "name": "Kat Hizmetleri Hiyerarşisi",
          "desc": "Executive Housekeeper (Kat Hizmetleri Müdürü), Assistant Housekeeper (Müdür Yardımcısı), Floor Supervisor (Kat Şefi), Maid / Houseman (Kat Görevlisi) ve Çamaşırhane Şefi.",
          "examples": [
            "Örnekle Pekiştirelim: Kat şefinin kat görevlisinin temizlediği odaları tek tek kontrol ederek 'Ready/Clean' onayını sisteme girmesi."
          ]
        },
        {
          "name": "Oda Durum Kodları (Room Status)",
          "desc": "Clean (Temiz), Dirty (Kirli), Occupied (Dolu), Vacant (Boş), OOO (Out of Order - Arızalı), DND (Do Not Disturb - Rahatsız Etmeyiniz).",
          "examples": [
            "Örnekle Pekiştirelim: Misafirin kapısına astığı kırmızı 'DND' kartını gören kat görevlisinin odaya girmeyip durumu şefine rapor etmesi."
          ]
        }
      ],
      "caseStudy": "Sektörden Vaka: Bir kat görevlisi, DND (Rahatsız Etmeyiniz) kartı asılı olan bir odaya temizlik amacıyla kartla girmiş ve içerideki misafir büyük tepki göstermiştir. Bu olaydan sonra DND asılı odaların prosedürü gereği sadece santral aracılığıyla kontrol edilmesi kuralı pekiştirilmiştir.",
      "tip": "DND kartı asılı odanın kapısı asla çalınmaz ve girilmez; durum mutlaka kat şefine bildirilmelidir."
    },
    {
      "id": 5,
      "tag": "KAT HİZMETLERİ FORMLARI",
      "title": "KAT HİZMETLERİNDE KULLANILAN FORMLAR VE STANDARTLAR",
      "microSummary": "Kayıp eşya formundan arıza bildirimine kadar her kayıt konuğun güvenini ve tesisin düzenini korur.",
      "definitions": [
        {
          "name": "Kayıp ve Bulunmuş Eşya Formu (Lost and Found)",
          "desc": "Konuğun odada veya genel alanda unuttuğu eşyaların tarihi, bulunduğu yer, eşyanın niteliği ve bulan personelin adıyla kaydedildiği yasal formdur.",
          "examples": [
            "Örnekle Pekiştirelim: Çıkış yapan konuğun yastık altında unuttuğu kol saatini bulan kat görevlisinin saati hemen Lost & Found ofisine teslim ederek formu doldurması."
          ]
        },
        {
          "name": "Arıza Bildirim Formu (Maintenance Form)",
          "desc": "Odada veya genel alanlarda tespit edilen teknik arızaların (musluk damlatması, klima soğutmama, ampul patlaması) teknik servise iletildiği belgedir.",
          "examples": [
            "Örnekle Pekiştirelim: 304 nolu odadaki duş başlığının kırık olduğunu gören personelin teknik servise arıza formu açması."
          ]
        },
        {
          "name": "Minibar Kontrol Formu",
          "desc": "Odada tüketilen içecek ve atıştırmalıkların günlük tespit edilip resepsiyon kasasına fatura edilmek üzere işlendiği formdur.",
          "examples": [
            "Örnekle Pekiştirelim: Günlük kontrollerde iki su ve bir meyve suyu tüketildiğinin tespit edilip sisteme işlenmesi."
          ]
        }
      ],
      "caseStudy": "Sektörden Vaka: Bir misafir otelden ayrıldıktan üç gün sonra değerli bir altın yüzüğünü odada unuttuğunu bildirmiştir. Kayıp ve Bulunmuş Eşya deposuna bakıldığında kat görevlisinin yüzüğü aynı gün kayıt altına alarak kasaya teslim ettiği görülmüş ve misafire kargolanarak takdir mektubu alınmıştır.",
      "tip": "Odada bulduğunuz en küçük bir bozuk para veya tokayı dahi kayıp eşya birimine teslim edin; dürüstlük mesleğin onurudur."
    },
    {
      "id": 6,
      "tag": "ETKİNLİK HİZMETLERİ",
      "title": "ETKİNLİK VE ANİMASYON HİZMETLERİ DEPARTMANI",
      "microSummary": "Etkinlik hizmetleri, konukların tatillerini eğlenceli ve unutulmaz anılara dönüştüren enerjidir.",
      "definitions": [
        {
          "name": "Etkinlik ve Rekreasyon Hizmetleri",
          "desc": "Konukların boş zamanlarını eğlenceli, sportif ve kültürel aktivitelerle değerlendirmelerini sağlayan animasyon ve organizasyon birimidir.",
          "examples": [
            "Örnekle Pekiştirelim: Gündüz havuz başında sabah jimnastiği, dart ve su jimnastiği; akşam ise amfitiyatroda dans gösterileri düzenlenmesi."
          ]
        },
        {
          "name": "Etkinlik Personeli ve Görevleri",
          "desc": "Animasyon Müdürü, Çocuk Kulübü (Mini Club) Animatörü, Spor Animatörü, Sahne ve Ses Teknisyenleri.",
          "examples": [
            "Örnekle Pekiştirelim: Mini Club görevlisinin çocuklara yüz boyama ve tişört baskı atölyesi yaptırarak ailelerin rahat tatil yapmasını sağlaması."
          ]
        },
        {
          "name": "Etkinlik Donanım ve Formları",
          "desc": "Aktivite Katılım Formu (turnuva kayıtları), Malzeme Zimmet Formu, Ses-Işık Ekipmanları ve İSG Güvenlik Taahhütleri.",
          "examples": [
            "Örnekle Pekiştirelim: Su sporları aktivitesine katılacak misafire can yeleği giydirilip katılım ve güvenlik formunun imzalatılması."
          ]
        }
      ],
      "caseStudy": "Sektörden Vaka: Bir animatörün plaj voleybolu sırasında misafirleri aşırı zorlayarak yaralanmaya yol açması üzerine, spor aktivitelerinde güvenlik kurallarını ve ilk yardım prosedürlerini içeren yeni bir risk analizi hazırlanmıştır.",
      "tip": "Etkinlik düzenlerken eğlence kadar misafir güvenliği ve sağlığı her zaman birinci önceliktir."
    },
    {
      "id": 7,
      "tag": "İŞ BİRLİĞİ",
      "title": "DEPARTMANLAR ARASI İŞ BİRLİĞİ VE BİLGİ AKIŞI",
      "microSummary": "Ön büro, kat hizmetleri ve teknik servis arasındaki anlık bilgi paylaşımı krizleri önler.",
      "definitions": [
        {
          "name": "Ön Büro - Kat Hizmetleri Koordinasyonu",
          "desc": "Giriş yapacak misafirlerin odalarının önceden temizlenmesi, çıkış yapan odaların anında 'Dirty' olarak kat görevlisine bildirilmesi sürecidir.",
          "examples": [
            "Örnekle Pekiştirelim: Erken giriş (early check-in) yapacak VIP bir misafir için ön büronun kat şefine öncelikli temizlik talebi iletmesi."
          ]
        },
        {
          "name": "Kat Hizmetleri - Teknik Servis Koordinasyonu",
          "desc": "Odadaki teknik arızaların kat görevlilerince anında sisteme girilerek misafir odaya dönmeden teknik servisçe onarılmasıdır.",
          "examples": [
            "Örnekle Pekiştirelim: Tıkanan lavabonun kat görevlisi tarafından bildirilip 15 dakika içinde tesisatçı tarafından açılması."
          ]
        },
        {
          "name": "Ön Büro - Yiyecek İçecek Koordinasyonu",
          "desc": "Günlük konaklayan kişi sayısı, kahvaltı dahil/hariç oranları ve VIP konukların özel diyet taleplerinin mutfağa bildirilmesidir.",
          "examples": [
            "Örnekle Pekiştirelim: Çölyak hastası bir misafirin glütensiz kahvaltı talebinin ön büro tarafından restorana önceden yazılı bildirilmesi."
          ]
        }
      ],
      "caseStudy": "Sektörden Vaka: Ön büronun odayı 'Clean' zannedip misafire anahtar vermesi, ancak odaya giren misafirin temizlenmemiş yatakla karşılaşması büyük bir skandala yol açmıştır. İncelemede kat görevlisinin temizliği bitirmediği halde sisteme onay girdiği saptanmış ve çapraz kontrol kuralı getirilmiştir.",
      "tip": "Gözünüzle görmediğiniz ve kat şefinden onay almadığınız hiçbir odayı sisteme 'hazır' olarak işaretlemeyin."
    },
    {
      "id": 8,
      "tag": "İŞ PLANI",
      "title": "KONAKLAMA İŞLETMELERİNDE İŞ PLANI VE VARDİYA DÜZENİ",
      "microSummary": "İş planı, günlük işlerin kim tarafından ne zaman yapılacağını belirleyen yol haritasıdır.",
      "definitions": [
        {
          "name": "İş Planı (Work Plan)",
          "desc": "Günlük, haftalık ve aylık görevlerin zaman çizelgesine bağlanması, personel kaynaklarının ve ekipmanların verimli yönetilmesidir.",
          "examples": [
            "Örnekle Pekiştirelim: Kat şefinin sabah vardiyasında her görevliye temizleyeceği 14 odalık kat listesini dağıtması."
          ]
        },
        {
          "name": "Vardiya Sistemi (Shift System)",
          "desc": "Otellerin 24 saat kesintisiz hizmet vermesi nedeniyle uygulanan 3'lü vardiya düzenidir (Sabah: 08:00-16:00, Akşam: 16:00-24:00, Gece: 24:00-08:00).",
          "examples": [
            "Örnekle Pekiştirelim: Akşam vardiyasına gelen resepsiyonistin sabah vardiyasından kalan kasa ve önemli notları devralması."
          ]
        },
        {
          "name": "Vardiya Devir Teslimi (Handover)",
          "desc": "Nöbeti biten personelin devam eden işleri, bekleyen misafir taleplerini ve özel durumları nöbeti devralan personele aktarmasıdır.",
          "examples": [
            "Örnekle Pekiştirelim: '502 nolu odanın havalimanı taksisi saat 23:30'da gelecek' notunun gece personeline sözlü ve yazılı devredilmesi."
          ]
        }
      ],
      "caseStudy": "Sektörden Vaka: Bir vardiya devir tesliminde uçağı kaçırmaması gereken bir konuğun sabah 05:00 uyandırma talebi devir defterine yazılmamış ve misafir uçağını kaçırmıştır. Otel yönetimi misafirin bilet masrafını karşılamak zorunda kalmış ve log-book zorunluluğu getirilmiştir.",
      "tip": "Söz uçar, yazı kalır; vardiya devirlerinde aklınıza gelen her detayı log-book defterine yazarak devredin."
    }
  ]
};

// 4. Öğrenme Birimi Notları
const Map<String, dynamic> otelcilikUnit4 = {
  "title": "Seyahat Acenteliği Hizmetleri",
  "learningUnit": "4. Öğrenme Birimi",
  "podcastUrl": "https://anchor.fm/s/114a64400/podcast/play/126260932/https%3A%2F%2Fd3ctxlq1ktw2nl.cloudfront.net%2Fstaging%2F2026-8-24%2F674980dd-268d-4314-e5f7-6891288a341d.m4a",
  "cards": [
    {
      "id": 1,
      "tag": "ACENTE ORGANİZASYONU",
      "title": "SEYAHAT ACENTELERİ VE ORGANİZASYON YAPISI",
      "microSummary": "Seyahat acenteleri, turizm ürünlerini tüketicilere ulaştıran profesyonel köprülerdir.",
      "definitions": [
        {
          "name": "Seyahat Acentesi",
          "desc": "Kâr amacıyla turistlere ulaşım, konaklama, gezi, spor ve eğlence imkanları sağlayan, onlara turizmle ilgili bilgiler veren ticari kuruluşlardır.",
          "examples": [
            "Örnekle Pekiştirelim: Bir ailenin tatil planı için Kadıköy'deki yetkili bir seyahat acentesine gidip uçak bileti, otel konaklaması ve havalimanı transferini tek bir paket olarak satın alması."
          ]
        },
        {
          "name": "Acente İçi Bölümler",
          "desc": "Bilet Satış (Ticketing), Tur Operasyonu (Incoming/Outgoing), Muhasebe, Pazarlama ve Enformasyon (Danışma) birimleridir.",
          "examples": [
            "Örnekle Pekiştirelim: Biletleme departmanı görevlisinin GDS sisteminden (Amadeus/Sabre) anlık olarak iç ve dış hat uçak biletlerini kesmesi."
          ]
        },
        {
          "name": "Acente Personeli Nitelikleri",
          "desc": "Coğrafya bilgisi, yabancı dil yeterliliği, rezervasyon ve biletleme programlarına hakimiyet ve yüksek iletişim becerisidir.",
          "examples": [
            "Örnekle Pekiştirelim: Acente yetkilisinin Kapadokya turuna çıkacak konuklara mevsim şartlarına uygun giyim önerilerinde bulunması."
          ]
        }
      ],
      "caseStudy": "Sektörden Vaka: Bir acente personeli uçak bileti keserken konuğun adındaki bir harfi yanlış yazmış ve misafir havalimanında uçağa alınmamıştır. Bu durum üzerine acente tüm biletleme işlemlerinde kimlik fotokopisi veya pasaport teyidini zorunlu kural haline getirmiştir.",
      "tip": "Bilet ve rezervasyon yaparken isim, soyisim ve tarihleri mutlaka harf harf kodlayarak misafirle teyit edin."
    },
    {
      "id": 2,
      "tag": "ACENTE GRUPLARI",
      "title": "SEYAHAT ACENTELERİNİN SINIFLANDIRILMASI VE TUR OPERATÖRLÜĞÜ",
      "microSummary": "1618 sayılı Kanun'a göre acenteler yetki ve faaliyet alanlarına göre A, B ve C grubu olarak ayrılır.",
      "definitions": [
        {
          "name": "A Grubu Seyahat Acenteleri",
          "desc": "1618 Sayılı Kanun'da tanımlanan tüm seyahat acenteliği hizmetlerini (yurt içi ve yurt dışı tur düzenleme, bilet kesme, transfer vb.) eksiksiz yerine getirebilen en yetkili gruptur.",
          "examples": [
            "Örnekle Pekiştirelim: Türkiye'den İtalya'ya kültür turu düzenleyip kendi adına bilet ve vize hizmeti sunan A grubu lisanslı büyük turizm acentesi."
          ]
        },
        {
          "name": "B ve C Grubu Seyahat Acenteleri",
          "desc": "B Grubu: Uluslararası ve ulusal kara, deniz, hava ulaştırma araçlarının biletlerini satan ve A grubu turlarını pazarlayan acentelerdir. C Grubu: Yalnızca Türk vatandaşları için yurt içi turlar düzenleyen acentelerdir.",
          "examples": [
            "Örnekle Pekiştirelim: C grubu bir acentenin yalnızca Karadeniz yayla turları veya Kapadokya gezileri organize edebilmesi."
          ]
        },
        {
          "name": "Tur Operatörü ile Acente Farkı",
          "desc": "Tur operatörü turizm ürünlerini toptan alıp paket tur haline getiren 'üretici/toptancı' iken; seyahat acentesi bu turları nihai tüketiciye satan 'perakendeci'dir.",
          "examples": [
            "Örnekle Pekiştirelim: Bir tur operatörünün Antalya'da 200 otel odası ve charter uçak kapatıp paket tur oluşturması; yerel acentenin ise bu paketi misafire satması."
          ]
        }
      ],
      "caseStudy": "Sektörden Vaka: C grubu bir acente yetkisini aşarak yurt dışına Balkan turu düzenlemeye kalkışmış ve TÜRSAB denetiminde tespit edilerek ağır para cezası almış ve faaliyeti durdurulmuştur. Yasal yetki sınırları dışına asla çıkılmamalıdır.",
      "tip": "Acentenizin yasal grup yetkisini iyi bilin; yetki aşımı hem lisans iptaline hem de hukuki sorumluluğa yol açar."
    },
    {
      "id": 3,
      "tag": "HUKUKİ ÇERÇEVE",
      "title": "TÜRSAB VE SEYAHAT ACENTELİĞİNİN HUKUKİ ÇERÇEVESİ",
      "microSummary": "TÜRSAB üyeliği ve Bakanlık işletme belgesi olmadan seyahat acenteliği faaliyeti yapılamaz; korsan turizm suçtur.",
      "definitions": [
        {
          "name": "TÜRSAB (Türkiye Seyahat Acentaları Birliği)",
          "desc": "1618 Sayılı Seyahat Acentaları ve Seyahat Acentaları Birliği Kanunu uyarınca kurulmuş, acentelerin mesleki birliğini ve disiplinini sağlayan kamu kurumu niteliğinde meslek kuruluşudur.",
          "examples": [
            "Örnekle Pekiştirelim: Yeni açılan bir seyahat acentesinin faaliyet gösterebilmek için Kültür ve Turizm Bakanlığı'ndan belge alıp TÜRSAB siciline kaydolması."
          ]
        },
        {
          "name": "Voucher (Hizmet Çeki)",
          "desc": "Acentenin misafire verdiği, otelde konaklama, transfer veya rehberlik hizmeti alma hakkı tanıyan ve bedelinin ödendiğini gösteren kıymetli resmi belgedir.",
          "examples": [
            "Örnekle Pekiştirelim: Misafirin otele giriş yaparken resepsiyona acentesinden aldığı basılı veya dijital voucher belgesini ibraz etmesi."
          ]
        },
        {
          "name": "Allotment (Kontenjan Sözleşmesi)",
          "desc": "Acentenin belirli bir dönem için konaklama işletmesinden belirli sayıda odayı önceden ayırtması ve opsiyon tarihine kadar satış hakkını elinde tutmasıdır.",
          "examples": [
            "Örnekle Pekiştirelim: Acentenin Bodrum'daki bir otelden Temmuz ayı boyunca her gün 20 odayı kontenjan sözleşmesiyle garantiye alması."
          ]
        }
      ],
      "caseStudy": "Sektörden Vaka: Sosyal medyada 'Kaçkar Gezisi' adı altında TÜRSAB belgesi olmadan korsan tur düzenleyen bir grubun otobüsü jandarma ve TÜRSAB denetmenleri tarafından durdurulmuş, araç bağlanmış ve organizatöre adli para cezası kesilmiştir.",
      "tip": "Turizmde güven belgedir; konuklarınıza hizmet sunarken TÜRSAB plakasını ve seyahat sözleşmesini mutlaka hazır bulundurun."
    },
    {
      "id": 4,
      "tag": "İŞ BİRLİKLERİ",
      "title": "SEYAHAT ACENTELERİNİN İŞ BİRLİĞİ YAPTIĞI KURUMLAR",
      "microSummary": "Acenteler; oteller, havayolları, rehberler ve resmi kurumlarla güçlü bir iş birliği ağı içinde çalışır.",
      "definitions": [
        {
          "name": "Hizmet Satın Alınan İşletmeler",
          "desc": "Konaklama tesisleri (oteller/tatil köyleri), ulaştırma işletmeleri (havayolu, demiryolu, otobüs firmaları), restoranlar ve profesyonel turist rehberleri.",
          "examples": [
            "Örnekle Pekiştirelim: Acentenin GAP turu için TUREB kokartlı profesyonel bir turist rehberi ile resmi sözleşme imzalaması."
          ]
        },
        {
          "name": "İlişkili Resmi ve Mesleki Kuruluşlar",
          "desc": "Kültür ve Turizm Bakanlığı, mülki idareler (Valilik/Kaymakamlık), Emniyet Genel Müdürlüğü, TUREB ve Havalimanı İşleticileri (DHMİ/İGA/TAV).",
          "examples": [
            "Örnekle Pekiştirelim: Yabancı turist kafilesinin güvenli transferi için havalimanı emniyetine yolcu listesi ve transfer aracının bildirilmesi."
          ]
        },
        {
          "name": "Paket Tur Sözleşmesi",
          "desc": "Ulaştırma, konaklama ve diğer turistik hizmetlerin en az ikisini kapsayan, 24 saatten uzun süren veya gecelemeyi içeren tüketici koruma kanunu kapsamındaki resmi sözleşmedir.",
          "examples": [
            "Örnekle Pekiştirelim: Tura katılan her misafire turun başlangıç-bitiş saatlerini, dahil olan ve olmayan hizmetleri belirten sözleşmenin imzalatılması."
          ]
        }
      ],
      "caseStudy": "Sektörden Vaka: Bir acente paket tur kapsamında vaat ettiği 5 yıldızlı otel yerine konukları 3 yıldızlı bir otele yerleştirmiştir. Misafirler Tüketici Hakem Heyetine başvurarak sözleşmeye aykırılık gerekçesiyle tur bedelinin tamamını tazminatıyla geri almıştır.",
      "tip": "Sözleşmede ne vaat ettiyseniz sahada onu sunun; dürüst ticaret uzun vadeli başarının temelidir."
    },
    {
      "id": 5,
      "tag": "PASAPORT VE VİZE",
      "title": "SEYAHAT FORMALİTELERİ: PASAPORT VE VİZE İŞLEMLERİ",
      "microSummary": "Pasaport uluslararası kimlik kartınızdır; vize ise bir ülkeye giriş izin belgesidir.",
      "definitions": [
        {
          "name": "Pasaport Türleri",
          "desc": "1. Umuma Mahsus (Bordo - her vatandaşa verilir), 2. Hususi Damgalı (Yeşil - kıdemli memurlar), 3. Hizmet Damgalı (Gri - devlet göreviyle gidenler), 4. Diplomatik (Siyah - üst düzey bürokrat ve elçiler).",
          "examples": [
            "Örnekle Pekiştirelim: Yurt dışı fuarına katılacak meslek lisesi öğretmenlerine görev süresince geçerli gri (hizmet damgalı) pasaport tahsis edilmesi."
          ]
        },
        {
          "name": "Vize (Visa)",
          "desc": "Bir ülkenin yetkili makamları (Konsolosluk/Büyükelçilik) tarafından yabancı bir ülke vatandaşına kendi sınırlarına giriş hakkı tanıyan resmi onaydır.",
          "examples": [
            "Örnekle Pekiştirelim: Fransa turuna katılacak bordo pasaportlu Türk vatandaşlarının Schengen vizesi için konsolosluğa parmak izi vermesi."
          ]
        },
        {
          "name": "Pasaport Geçerlilik Süresi Kuralı",
          "desc": "Pek çok ülkenin seyahat bitiş tarihinden itibaren en az 6 ay geçerli pasaport süresi talep etmesi kuralıdır.",
          "examples": [
            "Örnekle Pekiştirelim: Pasaportunun süresinin dolmasına 2 ay kalan bir misafirin acente personeli tarafından uyarılıp pasaportunu yenilemeye yönlendirilmesi."
          ]
        }
      ],
      "caseStudy": "Sektörden Vaka: Pasaportunda son 6 aylık geçerlilik süresi kalmayan bir misafir, acente personeli tarafından uyarılmadığı için havalimanında sınır polisi tarafından uçağa bindirilmemiştir. Acente personeli kusurlu bulunarak misafirin mağduriyeti tazmin edilmiştir.",
      "tip": "Misafirlerinizin yurt dışı biletini kesmeden önce pasaport geçerlilik sürelerini ve hedef ülkenin vize rejimini mutlaka kontrol edin."
    },
    {
      "id": 6,
      "tag": "SEYAHAT SİGORTASI",
      "title": "ZORUNLU SEYAHAT SİGORTASI VE KAPSAMI",
      "microSummary": "Zorunlu seyahat sigortası, paket turun vaat edildiği gibi tamamlanmasının ve kaza risklerinin teminatıdır.",
      "definitions": [
        {
          "name": "Zorunlu Seyahat Sigortası",
          "desc": "1618 Sayılı Kanun gereğince paket tur düzenleyen seyahat acentelerinin, taahhüt ettikleri hizmetlerin ifa edilmemesi, acentenin iflası veya ayıplı hizmet durumlarına karşı yaptırmak zorunda olduğu poliçedir.",
          "examples": [
            "Örnekle Pekiştirelim: Acentenin iflas etmesi durumunda tura katılan konukların yurt dışından geri dönüş masraflarının sigorta fonundan karşılanması."
          ]
        },
        {
          "name": "Seyahat Sağlık Sigortası",
          "desc": "Yurt dışı seyahatlerde aniden gelişen kaza, ani rahatsızlık, acil tıbbi tedavi, ilaç ve hastane masraflarını karşılayan (genellikle minimum 30.000 Euro teminatlı) poliçedir.",
          "examples": [
            "Örnekle Pekiştirelim: İtalya turunda ayağı burkulan bir misafirin ambulans ve hastane tedavi masraflarının seyahat sağlık sigortasınca ödenmesi."
          ]
        },
        {
          "name": "Bagaj Kaybı ve İptal Teminatı",
          "desc": "Uçuş sırasında havayolu tarafından kaybedilen bavul masraflarının veya zorunlu sağlık sebebiyle turun iptal edilmesi halinde para iadesinin yapılmasıdır.",
          "examples": [
            "Örnekle Pekiştirelim: Tura gitmeden bir gün önce ameliyat olmak zorunda kalan konuğun tur ücretini sigorta şirketinden eksiksiz alması."
          ]
        }
      ],
      "caseStudy": "Sektörden Vaka: Bir tur otobüsü yurt dışında arıza yapmış ve acente iflas bayrağı çekmiştir. Tura katılan 45 öğrenci, seyahat sigortası devreye girdiği için otellerine yerleştirilmiş ve uçak biletleri sigorta şirketi tarafından alınarak Türkiye'ye güvenle dönmüştür.",
      "tip": "Paket tur satışı yaparken seyahat sigortası poliçesini sözleşmeyle birlikte misafire teslim etmeyi asla unutmayın."
    }
  ]
};

// 5. Öğrenme Birimi Notları
const Map<String, dynamic> otelcilikUnit5 = {
  "title": "Konuk İlişkileri",
  "learningUnit": "5. Öğrenme Birimi",
  "podcastUrl": "https://anchor.fm/s/114a64400/podcast/play/126261009/https%3A%2F%2Fd3ctxlq1ktw2nl.cloudfront.net%2Fstaging%2F2026-8-24%2Fe3a42eb4-f9e6-9453-d5aa-97636dede42d.m4a",
  "cards": [
    {
      "id": 1,
      "tag": "KONUK PROFİLLERİ",
      "title": "SEYAHAT AMACINA VE PROFİLE GÖRE KONUK TİPLERİ",
      "microSummary": "Her misafirin tatilden beklentisi farklıdır; doğru hizmet kişiye özel yaklaşımla başlar.",
      "definitions": [
        {
          "name": "Tatil ve Dinlenme Amaçlı Konuklar (Leisure)",
          "desc": "Deniz, kum, güneş, dinlenme ve eğlence amacıyla seyahat eden, zaman kısıtı daha az olan, konfor ve güler yüz bekleyen konuk profilidir.",
          "examples": [
            "Örnekle Pekiştirelim: Yaz tatilinde ailesiyle resort otele gelen ve geç kahvaltı ile havuz aktivitelerini tercih eden misafirler."
          ]
        },
        {
          "name": "İş ve Kongre Konukları (Business / MICE)",
          "desc": "Toplantı, kongre, iş görüşmesi amacıyla gelen; hızlı internete, sessiz çalışma alanlarına, ütü hizmetine ve zamanında servise büyük önem veren konuklardır.",
          "examples": [
            "Örnekle Pekiştirelim: Sabah erken saatte toplantıya yetişecek iş insanının hızlı check-out ve erken kahvaltı talep etmesi."
          ]
        },
        {
          "name": "Kültür ve Sağlık Amaçlı Konuklar",
          "desc": "Tarihi ve doğal ören yerlerini keşfetmek veya kaplıca/termal/tedavi olanaklarından yararlanmak amacıyla seyahat eden konuklardır.",
          "examples": [
            "Örnekle Pekiştirelim: Pamukkale'deki termal otele şifalı sular için gelen ileri yaştaki konukların fizyoterapi ve sessizlik beklentisi."
          ]
        }
      ],
      "caseStudy": "Sektörden Vaka: Bir iş insanı, odasında kesintisiz internet olmadığı için online yönetim kurulu toplantısına katılamamış ve otelden hemen ayrılmıştır. Ön büro, iş konuklarına tahsis edilen odalarda kablolu yüksek hızlı internet ve çalışma masası standardı getirmiştir.",
      "tip": "Misafirin seyahat amacını check-in esnasında analiz edin; iş konuğuna hız, tatil konuğuna huzur sunun."
    },
    {
      "id": 2,
      "tag": "ÖZEL İLGİ KONUKLARI",
      "title": "ÖZEL İLGİ GEREKTİREN KONUK GRUPLARI VE VIP HİZMETLERİ",
      "microSummary": "Engelli, yaşlı, çocuklu ve VIP konuklar özel empati ve özenli hizmet standartları gerektirir.",
      "definitions": [
        {
          "name": "Engelli Konuklar (Erişilebilir Turizm)",
          "desc": "Fiziksel, görme veya işitme engeli bulunan konukların tesis içinde kimseden yardım almadan güvenle hareket edebilmeleri için sunulan rampa, asansör, kabartmalı tabela ve özel oda hizmetleridir.",
          "examples": [
            "Örnekle Pekiştirelim: Görme engelli misafire asansörde Braille alfabesi kabartmalı tuşların ve sesli kat anonslarının rehberlik etmesi."
          ]
        },
        {
          "name": "Üçüncü Yaş (Kıdemli) Konuklar",
          "desc": "65 yaş üstü misafirlerin sakinlik, sağlıklı beslenme, kolay erişim, saygılı ve sabırlı iletişim beklentilerinin karşılanmasıdır.",
          "examples": [
            "Örnekle Pekiştirelim: Yaşlı bir misafire merdiven çıkmaması için lobi katına yakın düzayak bir odanın tahsis edilmesi."
          ]
        },
        {
          "name": "VIP Konuk Hizmetleri",
          "desc": "Önemli diplomatlar, sanatçılar, üst düzey yöneticiler için uygulanan özel karşılama, odada taze çiçek, meyve sepeti ikramı ve concierge refakati standartlarıdır.",
          "examples": [
            "Örnekle Pekiştirelim: VIP Bildirim Formu (VIP Slip) düzenlenerek misafirin odaya girmeden önce sevdiği içecek ve meyvelerin hazırlanması."
          ]
        }
      ],
      "caseStudy": "Sektörden Vaka: Tekerlekli sandalyeli bir misafirin ana restorandaki rampanın dikliği yüzünden tek başına geçemediği görülmüştür. Genel müdürlük ertesi gün tüm rampa eğimlerini uluslararası erişilebilirlik standartlarına uygun şekilde tadil ettirmiştir.",
      "tip": "Engelli misafirlerimize acıyarak değil, eşit ve bağımsız bireyler olarak saygıyla yaklaşın."
    },
    {
      "id": 3,
      "tag": "DAVRANIŞ TİPLERİ",
      "title": "KARAKTER VE DAVRANIŞ BİÇİMLERİNE GÖRE KONUKLARA YAKLAŞIM",
      "microSummary": "Öfkeli konuğu sakinleştirmek, kararsız konuğa güven vermek profesyonelliğin sanatıdır.",
      "definitions": [
        {
          "name": "Öfkeli ve Şikayetçi Konuklar",
          "desc": "Hizmet aksamasından dolayı sinirlenmiş, ses tonu yükselmiş misafirlerdir; sakin, göz teması kuran, söz kesmeyen ve özür dileyen bir tavırla yaklaşılmalıdır.",
          "examples": [
            "Örnekle Pekiştirelim: Oda anahtarı bozulduğu için resepsiyonda bağıran konuğa 'Haklısınız efendim, sizi çok iyi anlıyorum, hemen yeni bir kart tanımlayıp size eşlik edeyim' diyerek ortamı yatıştırmak."
          ]
        },
        {
          "name": "Kararsız ve Çekingen Konuklar",
          "desc": "Seçim yapmakta zorlanan, soru sormaktan çekinen konuklardır; onlara seçenekleri ikiye indirerek sabırla ve yönlendirici bilgiyle yardımcı olunmalıdır.",
          "examples": [
            "Örnekle Pekiştirelim: Hangi tura katılacağına karar veremeyen misafire 'Doğa mı yoksa tarih mi ilginizi çeker?' diyerek iki net alternatif sunmak."
          ]
        },
        {
          "name": "Aceleci ve Sabırsız Konuklar",
          "desc": "Vakti kısıtlı olan, her işlemin derhal bitmesini isteyen konuklardır; gereksiz ayrıntıya girmeden pratik ve hızlı hizmet verilmelidir.",
          "examples": [
            "Örnekle Pekiştirelim: Taksisi bekleyen iş insanının fatura işlemlerini 1 dakika içinde hazır edip teslim etmek."
          ]
        }
      ],
      "caseStudy": "Sektörden Vaka: Bir resepsiyonist, kendisine bağıran öfkeli misafire aynı tonda sesini yükselterek karşılık vermiştir. Durum lobideki diğer tüm misafirlerin gözü önünde büyük bir kavgaya dönüşmüştür. Sakin kalarak ortamı sakin bir odaya taşımak profesyonel kuraldır.",
      "tip": "Ateşe körükle gidilmez; öfkeli misafirin karşısında sakinliğinizi korumak sizin en büyük gücünüzdür."
    },
    {
      "id": 4,
      "tag": "ŞİKAYET ÇÖZÜMÜ",
      "title": "KONUK MEMNUNİYETİ VE ŞİKAYET ÇÖZME TEKNİKLERİ (LAST KURALI)",
      "microSummary": "Her şikayet, işletmeyi mükemmelleştirmek için sunulmuş ücretsiz bir gelişim hediyesidir.",
      "definitions": [
        {
          "name": "LAST Şikayet Çözme Tekniği",
          "desc": "Uluslararası otelcilik standardı olan 4 adımlı problem çözme formülüdür: L (Listen - Dinle), A (Apologize - Özür Dile), S (Solve - Çözüm Üret), T (Thank - Teşekkür Et).",
          "examples": [
            "Örnekle Pekiştirelim: Çorbası soğuk gelen misafiri dikkatle dinlemek, aksaklık için özür dilemek, anında sıcak çorba getirmek ve durumu bildirdiği için teşekkür etmek."
          ]
        },
        {
          "name": "Şikayet Yönetiminde Empati",
          "desc": "Misafiri haklı haksız tartışmasına sokmadan, hissettiği hayal kırıklığını paylaştığını söz ve mimiklerle belli etmektir.",
          "examples": [
            "Örnekle Pekiştirelim: 'Yaşadığınız bu gecikmenin tatilinizi aksattığının farkındayım, hemen telafi edeceğiz' demek."
          ]
        },
        {
          "name": "Takip ve Geri Bildirim Formları",
          "desc": "Çözülen problemin ardından misafiri arayıp memnuniyetini teyit etmek ve anket/şikayet takip formuna işleyerek kaydetmektir.",
          "examples": [
            "Örnekle Pekiştirelim: Kliması onarılan misafirin odasını 30 dakika sonra arayıp 'Mehmet Bey, odanızın sıcaklığı şu an istediğiniz seviyede mi?' diye sormak."
          ]
        }
      ],
      "caseStudy": "Sektörden Vaka: Odasında sıcak su akmayan bir konuğa LAST kuralını uygulayan nöbetçi müdür, anında konuğu başka odaya geçirmiş ve akşam yemeğinde özel bir tatlı ikram etmiştir. Konuk otelden ayrılırken şikayet etmek yerine teşekkür mektubu bırakmıştır.",
      "tip": "Şikayeti çözerken savunmaya geçmeyin; 'Ben yapmadım, kat hizmetlerinin hatası' demek otelin itibarını zedeler."
    },
    {
      "id": 5,
      "tag": "GÜVENLİK VE TEDBİRLER",
      "title": "KONAKLAMA TESİSİNDE GÜVENLİK TEDBİRLERİ VE SİSTEMLERİ",
      "microSummary": "Güvenlik, konforun ve huzurun ön şartıdır; güvenlik zaafiyeti telafi edilemez.",
      "definitions": [
        {
          "name": "Elektronik Güvenlik Sistemleri",
          "desc": "CCTV kapalı devre güvenlik kameraları, manyetik kapı kilitleri, duman ve ısı dedektörleri, yangın sprinkler sistemi ve acil aydınlatmalar bütünüdür.",
          "examples": [
            "Örnekle Pekiştirelim: Otel koridorlarının 7/24 güvenlik merkezinden kameralarla izlenerek şüpheli durumların anında tespit edilmesi."
          ]
        },
        {
          "name": "Kasa (Safe Box) Güvenliği",
          "desc": "Konuk odalarında bulunan şifreli elektronik kasalar ve ön büroda bulunan zimmetli emanet kasalarıdır.",
          "examples": [
            "Örnekle Pekiştirelim: Misafirin pasaport ve nakit parasını odadaki elektronik kasaya koyarak kendi belirlediği şifreyle kilitlemesi."
          ]
        },
        {
          "name": "Acil Çıkış ve Tahliye Planları",
          "desc": "Her oda kapısının arkasında bulunan, acil durumlarda en yakın yangın merdivenini ve toplanma alanını gösteren aydınlatmalı kaçış krokileridir.",
          "examples": [
            "Örnekle Pekiştirelim: Misafirin kapı arkasındaki krokiye bakarak yangın anında hangi merdiveni kullanacağını öğrenmesi."
          ]
        }
      ],
      "caseStudy": "Sektörden Vaka: Bir otelde yangın merdiveni çıkış kapısının personel tarafından kilitlenip önüne malzeme yığıldığı yangın tatbikatında ortaya çıkmıştır. Güvenlik müdürü tüm acil çıkışların 7/24 açık ve engelsiz tutulması talimatını vermiştir.",
      "tip": "Yangın çıkış kapılarının önüne asla ve asla tek bir koli veya çöp kutusu dahi koymayın."
    },
    {
      "id": 6,
      "tag": "OLAĞAN DIŞI DURUMLAR",
      "title": "OLAĞAN DIŞI OLAYLAR VE KRİZ PROSEDÜRLERİ",
      "microSummary": "Kriz anında panik öldürür, eğitim ve soğukkanlı prosedür hayat kurtarır.",
      "definitions": [
        {
          "name": "Yangın ve Deprem Prosedürü",
          "desc": "Alarmla birlikte asansörlerin kullanılmaması, tahliye planına uyulması, acil anons yapılması ve toplanma alanında yoklama alınması sürecidir.",
          "examples": [
            "Örnekle Pekiştirelim: Deprem sarsıntısı bittikten sonra personelin misafirleri panik yaptırmadan yangın merdivenlerinden güvenli toplanma alanına tahliye etmesi."
          ]
        },
        {
          "name": "Hırsızlık ve Kayıp Eşya Olayları",
          "desc": "Konuğun eşyasının kaybolması durumunda odaya başkalarının girişinin engellenmesi, elektronik kilit okuma (lock audit) raporunun alınması ve polise haber verilmesidir.",
          "examples": [
            "Örnekle Pekiştirelim: Bilgisayarının çalındığını iddia eden konuğun kapı kilit raporundan odaya son 24 saatte kimin girdiğinin dakika dakika incelenmesi."
          ]
        },
        {
          "name": "Sağlık Acil Durumları ve Vefat",
          "desc": "Konuğun ani rahatsızlanmasında derhal 112 Acil Servis'in aranması; vefat durumunda savcılık ve kolluk kuvvetlerine bilgi verilerek odanın mühürlenmesidir.",
          "examples": [
            "Örnekle Pekiştirelim: Havuz kenarında fenalaşan misafire ilk yardım sertifikalı otel personelinin müdahale ederken diğer personelin 112 ambulansını çağırması."
          ]
        }
      ],
      "caseStudy": "Sektörden Vaka: Bir otel odasında rahatsızlanan yabancı bir konuk için resepsiyonist hemen 112'yi aramış ve otel doktorunu yönlendirmiştir. Erken müdahale sayesinde misafir kalp krizinden kurtarılmış, konsolosluk otel yönetimine resmi teşekkür belgesi göndermiştir.",
      "tip": "Acil durumlarda '112 Tek Acil Çağrı Numarası'nı hemen arayın ve açık adres ile hastanın durumunu net ifade edin."
    }
  ]
};

// 6. Öğrenme Birimi Notları
const Map<String, dynamic> otelcilikUnit6 = {
  "title": "Astlarla İlgili Çalışmalar",
  "learningUnit": "6. Öğrenme Birimi",
  "podcastUrl": "https://anchor.fm/s/114a64400/podcast/play/126261056/https%3A%2F%2Fd3ctxlq1ktw2nl.cloudfront.net%2Fstaging%2F2026-8-24%2F2fdbe816-6e0c-cd3b-92d9-a0cdae7f0499.m4a",
  "cards": [
    {
      "id": 1,
      "tag": "YÖNETSEL SORUMLULUKLAR",
      "title": "YÖNETSEL SORUMLULUKLAR VE AST-ÜST İLİŞKİLERİ",
      "microSummary": "İyi bir yönetici emreden değil; astlarına yol gösteren, eğiten ve ilham veren liderdir.",
      "definitions": [
        {
          "name": "Yönetsel Liderlik ve Rehberlik",
          "desc": "Departman yöneticisinin astlarına görev verirken hedefleri net açıklaması, iş standartlarını öğretmesi ve karşılaşılan engellerde rehberlik etmesidir.",
          "examples": [
            "Örnekle Pekiştirelim: Kat şefinin yeni işe başlayan stajyer öğrenciye nevresim yapma tekniğini sabırla göstererek ilk odada eşlik etmesi."
          ]
        },
        {
          "name": "Adil Görev Dağılımı",
          "desc": "İş yükünün personelin yetenek, deneyim ve fiziksel kapasitesine uygun olarak dengeli ve adaletli bir şekilde paylaştırılmasıdır.",
          "examples": [
            "Örnekle Pekiştirelim: Kat görevlilerine temizlenecek oda listesi dağıtılırken birine çok kirli çıkış odaları, diğerine ise sadece hafif temizlik odaları verilmemesi; dengeli dağıtım yapılması."
          ]
        },
        {
          "name": "Açık Kapı Politikası",
          "desc": "Yöneticinin kapısının astlarının görüş, öneri ve kişisel sorunlarına her zaman açık olması ve güven ortamı yaratmasıdır.",
          "examples": [
            "Örnekle Pekiştirelim: Ön büro müdürünün personelin vardiya değişim taleplerini veya özel mazeretlerini haftalık toplantıda anlayışla dinlemesi."
          ]
        }
      ],
      "caseStudy": "Sektörden Vaka: Sürekli bağırarak emirler yağdıran bir yiyecek-içecek şefi yüzünden departmandaki deneyimli garsonların tamamı iki ay içinde istifa etmiştir. Otel genel müdürü şefe liderlik ve iletişim eğitimi aldırmış ve departman içi memnuniyet anketleri başlatmıştır.",
      "tip": "Başarıyı ekibinize mal edin, aksaklıklarda sorumluluğu üstlenin; liderlik örnek olmakla başlar."
    },
    {
      "id": 2,
      "tag": "TOPLANTILAR VE BRİFİNG",
      "title": "YÖNETSEL TOPLANTILAR VE VARDİYA BRİFİNGLERİ",
      "microSummary": "15 dakikalık sabah brifingi, tüm günün operasyonel başarısını garanti eder.",
      "definitions": [
        {
          "name": "Vardiya Brifingi (Shift Briefing)",
          "desc": "Her vardiya başlangıcında yapılan, 10-15 dakika süren, günün doluluk oranını, VIP misafirleri, özel talepleri ve günün hedeflerini içeren ayaküstü toplantıdır.",
          "examples": [
            "Örnekle Pekiştirelim: Resepsiyon şefinin sabah 07:50'de ekibi toplayıp 'Bugün 120 çıkış, 140 girişimiz var, 4 VIP konuğumuz saat 14:00'te gelecek' diyerek görevleri aktarması."
          ]
        },
        {
          "name": "Departman Koordinasyon Toplantısı",
          "desc": "Haftada veya ayda bir yapılan, bütçe, malzeme eksikleri, misafir şikayetleri ve eğitim ihtiyaçlarının masaya yatırıldığı resmi toplantılardır.",
          "examples": [
            "Örnekle Pekiştirelim: Kat hizmetleri müdürünün ay sonu toplantısında kimyasal tüketim raporlarını ve personel devir hızını değerlendirmesi."
          ]
        },
        {
          "name": "Toplantı Tutanağı ve Takip",
          "desc": "Toplantıda alınan kararların, sorumlu kişilerin ve termin tarihlerinin yazıya geçirilerek katılımcılara imzalatılmasıdır.",
          "examples": [
            "Örnekle Pekiştirelim: 'Kırık valiz arabasının tamiri için teknik servise 2 gün süre verildi' maddesinin tutanağa geçirilmesi."
          ]
        }
      ],
      "caseStudy": "Sektörden Vaka: Sabah brifingi yapılmayan bir otelde, günün VIP misafirinin alerji notu servis personeline iletilmemiş ve misafire fıstıklı tatlı ikram edilmiştir. Alerjik reaksiyon geçiren misafir hastaneye kaldırılmıştır. Olayın ardından brifinglerin aksatılması yasaklanmıştır.",
      "tip": "Brifingi sıkıcı bir nutuk haline getirmeyin; ekibe moral aşılayan, hedefleri netleştiren enerjik bir buluşma yapın."
    },
    {
      "id": 3,
      "tag": "RAPORLAMA VE DOSYALAMA",
      "title": "RAPORLAMA, DOSYALAMA VE LOG-BOOK DÜZENİ",
      "microSummary": "Kaydedilmeyen hiçbir bilgi kurumsal hafızaya dahil olamaz; log-book departmanın kara kutusudur.",
      "definitions": [
        {
          "name": "Log-Book (Vardiya Olay Defteri)",
          "desc": "Nöbet süresince meydana gelen olağan dışı olayların, misafir taleplerinin, arızaların ve bir sonraki vardiyaya devredilen işlerin yazıldığı resmi defterdir.",
          "examples": [
            "Örnekle Pekiştirelim: 'Saat 22:15'te 308 nolu odanın banyo lambası değiştirildi, misafire teyit edildi' kaydının log-book'a düşülmesi."
          ]
        },
        {
          "name": "Günlük Faaliyet ve Doluluk Raporu",
          "desc": "Otelin günlük doluluk oranını (Occupancy Rate), ortalama oda fiyatını (ADR) ve oda gelirlerini gösteren yönetsel tablodur.",
          "examples": [
            "Örnekle Pekiştirelim: Gece denetçisinin sabah 06:00'da genel müdüre sunulmak üzere 'Gece Raporu (Night Report)' çıktısını hazırlaması."
          ]
        },
        {
          "name": "Dosyalama ve Arşivleme Standartları",
          "desc": "Rezervasyon konfirmasyonları, faturalar, kaza tutanakları ve personel evraklarının yasal saklama sürelerine göre fiziki ve dijital arşivlenmesidir.",
          "examples": [
            "Örnekle Pekiştirelim: Konaklama belgelerinin (Regcard) yasal denetimler için tarih ve oda sırasına göre klasörlenip kilitli dolapta saklanması."
          ]
        }
      ],
      "caseStudy": "Sektörden Vaka: Bir misafir iki ay önce kaldığı oteldeki konaklama faturasına itiraz etmiştir. Ön büro arşivi düzenli tutulduğu için misafirin imzaladığı konaklama belgesi ve harcama slipleri 2 dakika içinde arşivden çıkarılarak itiraz çözülmüştür.",
      "tip": "Log-book'a yazılan notlar açık, net ve tarafsız olmalıdır; kişisel yorum veya dedikodu deftere asla yazılmaz."
    },
    {
      "id": 4,
      "tag": "MOTİVASYON",
      "title": "PERSONELİN MORAL VE MOTİVASYONUNU ARTIRMA YOLLARI",
      "microSummary": "Mutlu çalışan, mutlu misafir demektir; takdir edilen emek katlanarak değer üretir.",
      "definitions": [
        {
          "name": "İş Motivasyonu ve Takdir",
          "desc": "Personelin işine istek ve heyecanla bağlanmasını sağlayan içsel ve dışsal teşvikler ile başarılarının yöneticilerce takdir edilmesidir.",
          "examples": [
            "Örnekle Pekiştirelim: Üstün misafir memnuniyeti sağlayan bir kat görevlisine genel müdürlük tarafından teşekkür belgesi ve küçük bir prim verilmesi."
          ]
        },
        {
          "name": "Ayın Personeli (Employee of the Month)",
          "desc": "Gösterdiği performans, iş disiplini ve takım çalışmasıyla öne çıkan personelin ödüllendirilip fotoğrafının lobi arkasındaki panoya asılması uygulamasıdır.",
          "examples": [
            "Örnekle Pekiştirelim: Personel kafeteryasında düzenlenen törenle 'Ayın Personeli' seçilen resepsiyoniste hediye çeki takdim edilmesi."
          ]
        },
        {
          "name": "Çalışma Ortamı Standartları ve Sosyal İmkanlar",
          "desc": "Personel lojmanı, dinlenme odaları, temiz yemekhane, servis imkanları ve kurum içi etkinliklerle aidiyet duygusunun pekiştirilmesidir.",
          "examples": [
            "Örnekle Pekiştirelim: Sezon başında tüm personelin katılımıyla düzenlenen motivasyon yemeği ve piknik organizasyonu."
          ]
        }
      ],
      "caseStudy": "Sektörden Vaka: Personel yemekhanesinin bakımsız ve yemeklerin kalitesiz olduğu bir otelde çalışanların yüzü gülmemiş ve misafirlere karşı ilgisizlik başlamıştır. Yönetim yemekhane menüsünü ve dinlenme odasını yeniledikten sonra misafir memnuniyet puanları anında yükselmiştir.",
      "tip": "Teşekkür etmek bedavadır ama değeri paha biçilemez; ekibinizin küçük bir başarısını bile herkesin önünde övün."
    },
    {
      "id": 5,
      "tag": "VARDİYA VE DENETİM",
      "title": "VARDİYA İŞLEMLERİ, DEVAM TAKİBİ VE PERFORMANS DEĞERLENDİRME",
      "microSummary": "Adil bir vardiya çizelgesi ve objektif performans değerlendirmesi çalışma barışını korur.",
      "definitions": [
        {
          "name": "Haftalık Vardiya Çizelgesi (Roster)",
          "desc": "4857 Sayılı İş Kanunu hükümlerine, haftalık 45 saatlik çalışma süresine ve yasal haftalık dinlenme hakkına (off-day) uygun düzenlenen nöbet tablosudur.",
          "examples": [
            "Örnekle Pekiştirelim: Departman müdürünün her perşembe günü gelecek haftanın vardiya çizelgesini panoya asarak personelin plan yapmasına olanak tanıması."
          ]
        },
        {
          "name": "Personel Devam Kontrol Sistemi (PDKS)",
          "desc": "Personelin işe geliş-gidiş saatlerini, fazla mesailerini parmak izi, yüz tanıma veya kartlı turnike sistemleriyle kaydeden dijital takip altyapısıdır.",
          "examples": [
            "Örnekle Pekiştirelim: Personelin vardiyaya girerken ve çıkarken personel giriş kapısındaki turnikeden kartını okutması."
          ]
        },
        {
          "name": "Personel Performans Değerlendirme Raporu",
          "desc": "Çalışanın iş bilgisi, misafir odaklılığı, takım çalışması, hijyen kurallarına uyumu ve kılık-kıyafet disiplininin belirli periyotlarla puanlanarak değerlendirilmesidir.",
          "examples": [
            "Örnekle Pekiştirelim: 6 aylık deneme süresi sonunda kat şefinin kat görevlisi için 'İş kalitesi yüksek, dakik ve güvenilir' notuyla olumlu değerlendirme formu doldurması."
          ]
        }
      ],
      "caseStudy": "Sektörden Vaka: Bir şef, sevmediği personele sürekli gece vardiyası yazıp hafta tatillerini hafta içine denk getirmiştir. Mağdur personel İnsan Kaynaklarına başvurmuş ve inceleme sonucunda adaletsiz vardiya yazdığı tespit edilen şef disiplin kuruluna sevk edilmiştir.",
      "tip": "Vardiya yazarken adalet terazisini şaşırmayın; personelin sosyal hayatına saygı duymak kuruma sadakati artırır."
    }
  ]
};

// Toplu Otelcilik ve Seyahat Hizmetleri Ders Notları Listesi
const List<Map<String, dynamic>> otelcilikNotes = [
  otelcilikUnit1,
  otelcilikUnit2,
  otelcilikUnit3,
  otelcilikUnit4,
  otelcilikUnit5,
  otelcilikUnit6,
];
