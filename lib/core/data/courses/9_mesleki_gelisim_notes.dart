/// 9. Sınıf Mesleki Gelişim Atölyesi Dersi Ders Notları Veri Tabanı
/// MEB Türkiye Yüzyılı Maarif Modeli "9. Sınıf Mesleki Gelişim Atölyesi (YENİ)" Ders Kitabı ile %100 Birebir Uyumludur.
/// 10 Öğrenme Birimi, zenginleştirilmiş pedagojik anlatımlar, sektörel vaka analizleri ve sınav ipuçları.

// ==========================================
// 1. ÖĞRENME BİRİMİ: İLETİŞİMİN GÜCÜ
// ==========================================
const Map<String, dynamic> meslekiGelisimUnit1 = {
  "title": "İletişimin Gücü",
  "learningUnit": "1. Öğrenme Birimi",
  "podcastUrl": "https://anchor.fm/s/114a64400/podcast/play/126380181/https%3A%2F%2Fd3ctxlq1ktw2nl.cloudfront.net%2Fstaging%2F2026-8-27%2F65faa08c-b8e1-edcf-a899-a6b2c709f674.m4a",
  "cards": [
    {
      "id": 1,
      "tag": "İLETİŞİM SÜRECİ",
      "title": "İLETİŞİM KAVRAMI VE SÜRECİN TEMEL ÖĞELERİ",
      "microSummary": "İletişim; duygu, düşünce ve bilgilerin kaynak tarafından kodlanarak uygun kanalla alıcıya iletilmesi ve dönüt alınması sürecidir.",
      "definitions": [
        {
          "name": "İletişimin Tanımı ve Amacı",
          "desc": "İki veya daha fazla kişi arasında anlamların ortak kılınması, bilgi, duygu ve düşüncelerin sözlü, sözsüz ya da yazılı sembollerle aktarılması ve paylaşılması sürecidir.",
          "examples": [
            "Örnekle Pekiştirelim: Ön büro şefinin sabah vardiyasında resepsiyonistlere günün VIP misafir listesini ve özel isteklerini aktarması işlevsel bir kurumsal iletişimdir."
          ]
        },
        {
          "name": "İletişim Sürecinin Öğeleri",
          "desc": "Kaynak (gönderici), mesaj (ileti), kodlama, kanal (iletişim aracı), kod açma, alıcı (hedef), dönüt (geri bildirim) ve gürültüden oluşan dinamik bir döngüdür.",
          "examples": [
            "Örnekle Pekiştirelim: Kat şefinin telsizle (kanal) görevliye '304 nolu odayı temizleyin' demesi (mesaj), görevlinin '304 temizlendi, hazırdır' yanıtını vermesi (dönüt) sürecin tamamlandığını gösterir."
          ]
        },
        {
          "name": "Dönüt (Geri Bildirim) ve Gürültü",
          "desc": "Dönüt, iletinin alıcı tarafından doğru anlaşılıp anlaşılmadığını belirleyen tepkidir. Gürültü ise mesajın iletimini bozan, anlam kaybına veya yanlış anlaşılmaya yol açan her türlü fiziksel, psikolojik ya da anlamsal engeldir.",
          "examples": [
            "Örnekle Pekiştirelim: Lobi alanındaki aşırı müzik ve inşaat sesi yüzünden resepsiyonistin misafirin soyadını yanlış duyması fiziksel gürültü örneğidir."
          ]
        }
      ],
      "caseStudy": {
        "title": "Sektörden Vaka: Dönüt Eksikliğinin Yol Açtığı Hizmet Aksaklığı",
        "story": "Restoran şefi, çırağına mutfaktan glutensiz ekmek getirmesini söyledi ancak çırağın onayını (dönüt) beklemeden diğer masaya yöneldi. Çırak siparişi tam duymayarak normal tam buğday ekmeği getirdi ve çölyak hastası misafire servis edilmek üzereyken durum son anda fark edildi.",
        "solution": "İşletme tüm servis ekibine 'Kapalı Döngü İletişim' kuralını zorunlu kıldı; verilen her talimat alıcı tarafından aynen tekrar edilip onaylandıktan sonra eyleme geçilmesi kuralı benimsendi."
      },
      "tip": "İletişim sürecinin en kritik halkası 'dönüt'tür. Dönüt alınmayan bir süreç iletişim değil, yalnızca tek yönlü bir iletim (enformasyon) olarak kalır."
    },
    {
      "id": 2,
      "tag": "SÖZLÜ VE SÖZSÜZ İLETİŞİM",
      "title": "BEDEN DİLİ, JESTLER, MİMİKLER VE SES TONU",
      "microSummary": "İletişimin %90'ından fazlası sözsüz unsurlardan (beden dili, ses tonu, göz teması) oluşur; profesyonel duruş hizmet kalitesinin aynasıdır.",
      "definitions": [
        {
          "name": "Sözlü İletişim ve Diksiyon",
          "desc": "Kelimeler, dil bilgisi kuralları, ses tonlaması, vurgu ve konuşma hızıyla gerçekleştirilen doğrudan iletişim türüdür. Açık, net ve nazik bir üslup esastır.",
          "examples": [
            "Örnekle Pekiştirelim: Karşılama görevlisinin misafiri tebessüm ederek net ve tane tane bir diksiyonla 'Hoş geldiniz efendim, size nasıl yardımcı olabilirim?' diyerek selamlaması."
          ]
        },
        {
          "name": "Sözsüz İletişim ve Beden Dili",
          "desc": "Yüz ifadeleri (mimikler), el-kol hareketleri (jestler), duruş (postür), göz teması ve kişisel alanın (mesafe) kullanılmasıyla aktarılan mesajlardır.",
          "examples": [
            "Örnekle Pekiştirelim: Resepsiyon görevlisinin kollarını göğsünde kavuşturup arkaya yaslanması 'savunmacı ve ilgisiz' bir mesaj verirken; dik durup göz teması kurması 'güven ve ilgi' mesajı verir."
          ]
        },
        {
          "name": "Kişisel Alan (Mekânsal Mesafe)",
          "desc": "Bireylerin kendilerini güvende hissettikleri mahrem (0-45 cm), kişisel (45-120 cm), sosyal (1.2-3.6 m) ve kamusal alan sınırlarıdır. Profesyonel ilişkilerde sosyal mesafe korunmalıdır.",
          "examples": [
            "Örnekle Pekiştirelim: Garsonun misafire sipariş alırken çok fazla yaklaşmayıp 1 metrelik saygılı kişisel mesafeyi koruması misafirin konforunu güvenceye alır."
          ]
        }
      ],
      "caseStudy": {
        "title": "Sektörden Vaka: Beden Dilinin Sözleri Yalanlaması",
        "story": "Misafir ilişkileri sorumlusu, şikayetini anlatan bir misafire sözlü olarak 'Sizi anlıyorum' derken gözlerini devirdi, saatine baktı ve bilgisayar ekranıyla ilgilendi. Misafir 'Beni dinlemiyorsunuz!' diyerek daha çok öfkelendi.",
        "solution": "Sorumlu personel göz temasını sürdürerek, başıyla onaylayıcı jestler yaparak ve not defterine misafirin ifadelerini not ederek bedenen de 'dinliyorum' mesajı vermeyi alışkanlık haline getirdi."
      },
      "tip": "Sözler ile beden dili çeliştiğinde insanlar daima beden diline inanır. Samimi bir tebessüm ve dik bir duruş, en etkili kurumsal kartvizittir."
    },
    {
      "id": 3,
      "tag": "İLETİŞİM ENGELLERİ",
      "title": "İLETİŞİM ENGELLERİ VE AKTİF DİNLEME",
      "microSummary": "İletişim engellerini aşmanın en güçlü aracı; önyargısız empati kurmak, sen dili yerine ben dili kullanmak ve aktif dinlemektir.",
      "definitions": [
        {
          "name": "İletişim Engelleri Türleri",
          "desc": "Fiziksel engeller (gürültü, mesafe), psikolojik engeller (önyargı, öfke, stres), anlamsal/semantik engeller (mesleki jargon, yabancı dil) ve algısal farklılıklardır.",
          "examples": [
            "Örnekle Pekiştirelim: Aşçının stajyere aşırı teknik Fransızca mutfak terimleriyle talimat verip stajyerin ne yapılacağını anlayamaması anlamsal (semantik) bir iletişim engelidir."
          ]
        },
        {
          "name": "Aktif (Etkin) Dinleme",
          "desc": "Konuşmacının yalnızca sözlerini değil, duygusunu ve satır aralarını da anlamaya odaklanarak, sözünü kesmeden, geri bildirim vererek ve özetleyerek dinleme becerisidir.",
          "examples": [
            "Örnekle Pekiştirelim: 'Anladığım kadarıyla odanızdaki klimanın soğutma yapmamasından dolayı dinlenemediniz, doğru mu anladım efendim?' diyerek teyit almak."
          ]
        },
        {
          "name": "Sen Dili ve Ben Dili Ayrımı",
          "desc": "Sen dili suçlayıcı, yargılayıcı ve savunmaya iten bir dildir ('Yine geç kaldın!'). Ben dili ise davranışı, ortaya çıkan duyguyu ve etkiyi ifade eden yapıcı dildir ('Toplantıya geç kaldığında sürecimiz aksıyor ve endişeleniyorum').",
          "examples": [
            "Örnekle Pekiştirelim: 'Formu yine yanlış doldurmuşsun!' (Sen dili) yerine 'Formda bazı alanlar boş bırakıldığında sisteme giriş yapamıyorum' (Ben dili) demek iş birliğini artırır."
          ]
        }
      ],
      "caseStudy": {
        "title": "Sektörden Vaka: Sen Dili Krizi ve Ben Diliyle Çözüm",
        "story": "Restoranda şef garson, siparişi geciken stajyere misafirlerin önünde 'Sen zaten hiçbir işi vaktinde beceremezsin!' diye bağırdı. Stajyer ağlayarak salonu terk etti ve operasyon kilitlendi.",
        "solution": "Şef garson personelle baş başa kalarak 'Siparişler geciktiğinde misafirlere mahcup oluyorum ve mutfakla servis arasında baskı hissediyorum, süreci nasıl hızlandırabiliriz?' diyerek ben dilini kullandı ve ortak çözüm planı geliştirdi."
      },
      "tip": "Sen dili öfke ve savunma üretir; ben dili ise empati ve sorumluluk bilinci kazandırır. Profesyonel iletişimde daima ben dili tercih edilmelidir."
    },
    {
      "id": 4,
      "tag": "İLETİŞİM TARZLARI",
      "title": "PAYDAŞ ODAKLI VE ATILGAN (GÜVENLİ) İLETİŞİM",
      "microSummary": "İletişim tarzları pasif, saldırgan ve atılgan olarak üçe ayrılır; hem kendi haklarını koruyan hem başkalarına saygı duyan tarz atılgan iletişimdir.",
      "definitions": [
        {
          "name": "Pasif (Çekingen) İletişim Tarzı",
          "desc": "Kendi duygu, düşünce ve haklarını ifade etmekten çekinen, sürekli başkalarının isteklerine boyun eğen ve çatışmadan kaçınan iletişim tarzıdır.",
          "examples": [
            "Örnekle Pekiştirelim: Fazla mesai listesinde haksızlık yapıldığını gördüğü halde sessiz kalıp içine atan çalışanın tutumu pasif iletişimdir."
          ]
        },
        {
          "name": "Saldırgan (Agresif) İletişim Tarzı",
          "desc": "Kendi haklarını ve fikirlerini başkalarının haklarını çiğneyerek, sesini yükselterek, tehditkar ve baskıcı bir üslupla dayatma biçimidir.",
          "examples": [
            "Örnekle Pekiştirelim: Fikrini kabul ettirmek için masaya vuran ve meslektaşlarını küçümseyen bir ekip liderinin davranışı saldırgan iletişimdir."
          ]
        },
        {
          "name": "Atılgan (Güvenli/Asertif) İletişim Tarzı",
          "desc": "Kendi haklarını, duygularını ve sınırlarını başkalarının haklarını zedelemeden, kendinden emin, dürüst ve sakin bir dille savunabilme becerisidir.",
          "examples": [
            "Örnekle Pekiştirelim: 'Şu an planlanmış acil bir görevim var, bu talebinizi öğleden sonra saat 15:00'te memnuniyetle inceleyebilirim' diyerek sınır koymak."
          ]
        }
      ],
      "caseStudy": {
        "title": "Sektörden Vaka: Saygılı ve Atılgan Bir 'Hayır' Diyebilme Becerisi",
        "story": "Misafir, otel yönetmeliğine aykırı olarak havuz kapanış saatinden sonra havuza girmek için güvenlik görevlisine ısrar etti ve baskı kurdu. Güvenlik personeli ne bağırdı ne de kuralı deldi.",
        "solution": "Görevli sakin ve kararlı bir ses tonuyla 'Sizi anlıyorum ancak havuzun klorlama ve kimyasal temizlik süreci başladı; sağlığınızı riske atamayız. Yarın sabah 07:00'de havuzumuz hizmetinizde olacaktır' diyerek profesyonel sınırını korudu."
      },
      "tip": "Atılganlık kabalık veya saldırganlık değildir. Atılganlık; 'Ben değerliyim, sen de değerlisin' ilkesine dayanan olgun bir duruştur."
    },
    {
      "id": 5,
      "tag": "ÇATIŞMA VE STRES",
      "title": "ÇATIŞMA YÖNETİMİ VE KAZAN-KAZAN STRATEJİSİ",
      "microSummary": "İş yaşamında çatışmalar kaçınılmazdır; önemli olan çatışmayı yıkıcı bir kavgaya değil, kazan-kazan stratejisiyle yapıcı bir çözüme dönüştürmektir.",
      "definitions": [
        {
          "name": "Çatışma Yönetimi Stratejileri",
          "desc": "Çatışma anında sergilenen beş temel yaklaşım: Kaçınma (yok sayma), Uyma/Ödün verme (kendinden vazgeçme), Rekabet/Dayatma (kendi dediğini yaptırma), Uzlaşma (orta yol bulma) ve İş Birliği (kazan-kazan).",
          "examples": [
            "Örnekle Pekiştirelim: Kat hizmetleri ile ön büro arasındaki oda teslim saati uyuşmazlığında iki departmanın ortak bir dijital takip çizelgesi oluşturarak sorunu çözmesi iş birliğidir."
          ]
        },
        {
          "name": "Kazan-Kazan (Win-Win) Stratejisi",
          "desc": "Her iki tarafın da ihtiyaçlarının, kaygılarının ve beklentilerinin karşılandığı, hiçbir tarafın mağlup hissetmediği sürdürülebilir problem çözme modelidir.",
          "examples": [
            "Örnekle Pekiştirelim: Rezervasyonu sistem hatasıyla çakışan misafire ek ücret almadan daha üst segment süit oda sunulması; misafirin mutlu olması, otelin de itibarını korumasıdır."
          ]
        },
        {
          "name": "SMART Hedefler ile İletişim Planı",
          "desc": "Belirli (Spesifik), Ölçülebilir, Ulaşılabilir, Gerçekçi ve Zamana Bağlı (SMART) hedefler koyarak iletişim ve iş süreçlerini netleştirmektir.",
          "examples": [
            "Örnekle Pekiştirelim: 'Misafir memnuniyetini artıracağız' yerine 'Ön büro giriş bekleme süresini 1 ay içinde 3 dakikanın altına indireceğiz' hedefi SMART bir hedeftir."
          ]
        }
      ],
      "caseStudy": {
        "title": "Sektörden Vaka: İki Departman Arasındaki Vardiya Çatışması",
        "story": "Mutfak ekibi servis personelinin sipariş fişlerini geç girdiğini, servis ekibi ise mutfağın yemekleri soğuk çıkardığını söyleyerek karşılıklı suçlamalarda bulunuyordu.",
        "solution": "İşletme yöneticisi tarafları ortak masaya topladı. Her iki tarafın da haklı noktaları tespit edilip 'Sipariş Zaman Takip Ekranı' kuruldu; böylece iki ekip de birbirine destek veren bir ortaklığa kavuştu."
      },
      "tip": "Kazan-Kaybet yaklaşımı uzun vadede iki tarafa da kaybettirir. Sürdürülebilir mesleki başarı yalnızca Kazan-Kazan anlayışıyla mümkündür."
    }
  ]
};

// ==========================================
// 2. ÖĞRENME BİRİMİ: MESLEK ETİĞİ VE AHİLİK KÜLTÜRÜ
// ==========================================
const Map<String, dynamic> meslekiGelisimUnit2 = {
  "title": "Meslek Etiği ve Ahilik Kültürü",
  "learningUnit": "2. Öğrenme Birimi",
  "podcastUrl": "https://anchor.fm/s/114a64400/podcast/play/126380278/https%3A%2F%2Fd3ctxlq1ktw2nl.cloudfront.net%2Fstaging%2F2026-8-27%2F905dde8c-27fc-36b3-4001-a367070909c5.m4a",
  "cards": [
    {
      "id": 1,
      "tag": "MESLEK ETİĞİ",
      "title": "İŞ YAŞAMINDA KURALLAR VE MESLEK AHLAKI",
      "microSummary": "Meslek etiği; meslek mensuplarının görevlerini icra ederken uymakla yükümlü oldukları ahlaki ilkeler, doğruluk ve dürüstlük standartları bütünüdür.",
      "definitions": [
        {
          "name": "Ahlak ve Etik Ayrımı",
          "desc": "Ahlak, toplumların kültürel, dini ve geleneksel normlarına dayalı genel doğru-yanlış kurallarıdır. Etik ise ahlak felsefesini temel alan, evrensel, akılcı ve mesleki ilkelere odaklanan kurallar bütünüdür.",
          "examples": [
            "Örnekle Pekiştirelim: Bir toplumda büyüklere saygı ahlaki bir norm iken; bir doktorun veya otel yöneticisinin misafir mahremiyetini koruması mesleki etik kuralıdır."
          ]
        },
        {
          "name": "Temel Meslek Etiği İlkeleri",
          "desc": "Doğruluk, dürüstlük, tarafsızlık, adalet, güvenilirlik, gizlilik (sır saklama), liyakat (işi ehline verme) ve mesleki bağlılık ilkeleridir.",
          "examples": [
            "Örnekle Pekiştirelim: Kat görevlisinin odada unutulan pırlanta kolyeyi amirine eksiksiz teslim etmesi güvenilirlik ve dürüstlük ilkesidir."
          ]
        },
        {
          "name": "Etik Dışı Davranışlar ve Maliyeti",
          "desc": "Rüşvet, zimmet, görevi kötüye kullanma, ayrımcılık, haksız kazanç ve intihal gibi eylemler hem yasal suç teşkil eder hem de kurumsal itibarı yok eder.",
          "examples": [
            "Örnekle Pekiştirelim: Satın alma müdürünün, kalitesiz ürün veren tedarikçiden komisyon alarak otele bayat gıda alması ağır bir etik ihlaldir."
          ]
        }
      ],
      "caseStudy": {
        "title": "Sektörden Vaka: Misafir Verilerinin Gizliliği İlkesi",
        "story": "Bir magazin muhabiri, otelde konaklayan ünlü bir sporcunun yanındaki kişilerle fotoğraflarını çekebilmek için resepsiyoniste 10.000 TL nakit teklif etti.",
        "solution": "Resepsiyonist 'Misafirlerimizin mahremiyeti ve güvenliği parayla satılamaz' diyerek teklifi derhal reddetti ve durumu otel güvenliğine bildirerek misafirin huzurunu korudu."
      },
      "tip": "Güven kazanmak yıllar alır; ancak etik dışı tek bir hareket o güveni birkaç saniye içinde yerle bir edebilir."
    },
    {
      "id": 2,
      "tag": "AHİLİK TEŞKİLATI",
      "title": "AHİLİK TEŞKİLATI VE FÜTÜVVET GELENEĞİ",
      "microSummary": "Ahilik; 13. yüzyılda Anadolu'da Ahi Evran tarafından kurulan, ticaret ve zanaatı yüksek ahlaki değerlerle birleştiren köklü esnaf teşkilatıdır.",
      "definitions": [
        {
          "name": "Ahilik ve Fütüvvet Anlayışı",
          "desc": "Arapça 'kardeşim' (ahi) ya da Türkçe 'eli açık/cömert' (akı) kökünden gelen Ahilik, temelini cömertlik, yiğitlik ve fedakarlık anlamına gelen 'fütüvvet' felsefesinden alır.",
          "examples": [
            "Örnekle Pekiştirelim: Ahi esnafının kazancının bir kısmını yoksullara, yolculara ve ihtiyaç sahibi öğrencilere karşılıksız paylaştırması fütüvvet ruhudur."
          ]
        },
        {
          "name": "Ahi Evran-ı Veli ve Teşkilatlanma",
          "desc": "Kırşehir merkezli olarak esnaf birliklerini örgütleyen, dericilik (debbağlık) piri olan Ahi Evran, mesleki standardizasyon ve ahlaki denetim sistemini kurmuştur.",
          "examples": [
            "Örnekle Pekiştirelim: Ahi Evran'ın 'Hak ile sabır dileyip bize gelen bizdendir; akıl ve ahlak ile çalışıp bizi geçen bizdendir' sözü ahiliğin vizyonunu yansıtır."
          ]
        },
        {
          "name": "Bacıyân-ı Rûm (Anadolu Kadınlar Birliği)",
          "desc": "Ahi Evran'ın eşi Fatma Bacı önderliğinde kurulan, dünyadaki ilk organize kadın esnaf teşkilatıdır. Dokumacılık, el sanatları ve toplumsal dayanışmada öncüdür.",
          "examples": [
            "Örnekle Pekiştirelim: Kadınların üretime katılarak hem ekonomik özgürlük kazanması hem de çadır ve kilim dokuyarak yurt savunmasına katkı vermesi."
          ]
        }
      ],
      "caseStudy": {
        "title": "Sektörden Vaka: Komşusu Siftah Yapmayan Ahi Esnafı",
        "story": "Osmanlı çarşısında sabah ilk alışverişini yapan bir esnafa gelen ikinci misafir bir ürün daha almak istediğinde esnaf: 'Efendim, ben sabah siftahımı yaptım, komşum henüz siftah etmedi. Lütfen o ürünü komşumdan alınız' dedi.",
        "solution": "Bu dayanışma ruhu, aşırı rekabet ve yıkıcı hırs yerine kardeşlik ve toplumsal refah dengesini kurarak yüzyıllar süren bir ticari istikrar sağladı."
      },
      "tip": "Ahilik sadece bir meslek örgütü değil; ahlak, sanat, konukseverlik ve vatan sevgisini harmanlayan bir hayat felsefesidir."
    },
    {
      "id": 3,
      "tag": "USTA-ÇIRAK HİYERARŞİSİ",
      "title": "AHİLİKTE EĞİTİM, ŞED KUŞANMA VE KADEMELER",
      "microSummary": "Ahilikte mesleki eğitim; yamak, çırak, kalfa ve usta aşamalarından geçer ve ehliyet kazananlar törenle 'şed' kuşanarak dükkan açma hakkı kazanır.",
      "definitions": [
        {
          "name": "Yamaklık, Çıraklık ve Kalfalık",
          "desc": "Mesleğe ilk adımda 2 yıl ücretsiz ahlak ve disiplin eğitimi (yamaklık), ardından çıraklık sözleşmesi ve 3 yıllık yoğun pratik eğitimle kalfalığa geçiş basamağıdır.",
          "examples": [
            "Örnekle Pekiştirelim: Otel mutfağında staja başlayan bir öğrencinin önce bıçak tutmayı, hijyen kurallarını ve mutfak hiyerarşisini öğrenmesi modern çıraklıktır."
          ]
        },
        {
          "name": "Şed Kuşatma Töreni (İcazet/Gedik)",
          "desc": "Ustalık mertebesine erişen kalfanın, ahi pirleri ve esnaf önünde mesleki ve ahlaki yemin ederek beline kuşak (şed) bağlanması ve dükkan açma (gedik) yetkisi almasıdır.",
          "examples": [
            "Örnekle Pekiştirelim: Meslek lisesinden mezun olan ustanın 'Ustalık Belgesi' ve 'İş Yeri Açma Belgesi' alarak kendi işletmesini kurma yetkisine kavuşması."
          ]
        },
        {
          "name": "Ahilik Nasihati ve Altı İlke",
          "desc": "Üçü açık (Alnı açık, eli açık, sofrası açık), üçü kapalı (Gözü kapalı-harama bakmaz, beli kapalı-nefsine hakim, dili kapalı-yalan söylemez) temel hayat düsturudur.",
          "examples": [
            "Örnekle Pekiştirelim: Turizm işletmecisinin sofrasını ve kapısını her gelen misafire güler yüzle açık tutması ahilik nasihatinin doğrudan yansımasıdır."
          ]
        }
      ],
      "caseStudy": {
        "title": "Sektörden Vaka: Ustalık Sınavında Ahlak Kriteri",
        "story": "Ayakkabı üretiminde olağanüstü yetenekli bir kalfa şed kuşanmak istedi. Ancak ahi heyeti kalfanın çarşıda borcunu geciktirdiğini ve kaba davrandığını tespit etti.",
        "solution": "Ahi Meclisi; 'Sanatın kusursuz olsa da ahlakın kemale ermedikçe bu belde dükkan açamazsın' diyerek kalfaya 1 yıl daha nefis terbiyesi ve nezaket eğitimi verdi."
      },
      "tip": "Ahilik eğitiminde 'Ehliyet ve Liyakat' ahlaktan ayrı düşünülemez. Sanatı mükemmel olsa dahi meslek ahlakı taşımayan kişiye ustalık icazeti verilmez."
    },
    {
      "id": 4,
      "tag": "TİCARET AHLAKI",
      "title": "PABUCUNU DAMA ATMAK VE KALİTE GÜVENCESİ",
      "microSummary": "Ahilikte hatalı veya fahiş fiyatlı üretim yapan esnafın pabucu dükkanının damına atılır; bu ceza esnafın ticari hayatını ve itibarını sonlandırırdı.",
      "definitions": [
        {
          "name": "Pabucunu Dama Atmak Deyiminin Kökeni",
          "desc": "Standart dışı, hileli veya çürük mal üreten ayakkabıcının mamulünün bilirkişi (Yiğitbaşı) tarafından incelenip dükkanın çatısına fırlatılmasıyla uygulanan ibret cezasıdır.",
          "examples": [
            "Örnekle Pekiştirelim: Kalitesiz taban kullanan kunduracının ayakkabısının dama atılması, o esnafın çarşıda bir daha kimseye mal satamaması sonucunu doğururdu."
          ]
        },
        {
          "name": "Narh Sistemi (Fiyat İstikrarı)",
          "desc": "Tüketiciyi korumak, fırsatçılığı ve karaborsayı önlemek amacıyla devlet ve esnaf odası iş birliğiyle temel ürünlere belirlenen tavan ve taban fiyat uygulamasıdır.",
          "examples": [
            "Örnekle Pekiştirelim: Kriz veya bayram dönemlerinde otellerin ya da acentelerin fahiş fiyat artışı yapmasını önleyen taban-tavan fiyat sınırlamaları."
          ]
        },
        {
          "name": "Orta Sandığı ve Esnaf Sandığı",
          "desc": "Ahi esnaflarının aidatlarıyla kurulan, iflas eden, hastalanan veya afet yaşayan esnafa faizsiz kredi veren, dullara ve yetimlere yardım eden ilk yardımlaşma sandığıdır.",
          "examples": [
            "Örnekle Pekiştirelim: Yangın geçiren bir restoran işletmecisine meslektaşlarının ortak fonundan sıfır faizle sermaye verilerek iş yerinin ayağa kaldırılması."
          ]
        }
      ],
      "caseStudy": {
        "title": "Sektörden Vaka: Dijital Çağda Pabucun Dama Atılması",
        "story": "Bodrum'da bir otel, internet sitesinde deniz manzaralı gösterdiği odaları bodrum kattaki penceresiz odalar olarak misafire sundu ve itirazları dikkate almadı.",
        "solution": "Misafirler otelin bu hilesini fotoğraflayıp puanlama platformlarında ve sosyal medyada paylaştı. Otelin puanı 1.2'ye düştü, rezervasyonlar iptal edildi ve turizm müdürlüğü ağır ceza uyguladı."
      },
      "tip": "Ahilik kalite kontrolünün en büyük gücü tüketicinin hakkını korumasıydı. Günümüzün online yorum ve puanlama platformları modern 'dam' vazifesi görmektedir."
    },
    {
      "id": 5,
      "tag": "GÜNÜMÜZDE AHİLİK",
      "title": "MODERN İŞ DÜNYASINDA AHİLİK VE SOSYAL SORUMLULUK",
      "microSummary": "Ahilik kültürü; modern kurumsal sosyal sorumluluk, toplam kalite yönetimi ve sürdürülebilir iş etiğinin tarihsel temelini teşkil eder.",
      "definitions": [
        {
          "name": "Sosyal Sorumluluk ve Etik Liderlik",
          "desc": "İşletmelerin sadece kâr odaklı değil; çalışanlarına, doğaya, topluma ve gelecek nesillere karşı ahlaki sorumluluk bilinciyle hareket etmesidir.",
          "examples": [
            "Örnekle Pekiştirelim: Bir otelin mutfak atıklarını sokak hayvanları barınağına bağışlaması ve yerel kadın kooperatiflerinin organik ürünlerini satın alması."
          ]
        },
        {
          "name": "Güven Sermayesi (Sosyal Sermaye)",
          "desc": "Bir işletmenin bilançosundaki maddi varlıklarından çok daha değerli olan; misafirlerin, çalışanların ve kamuoyunun duyduğu itimat ve dürüstlük algısıdır.",
          "examples": [
            "Örnekle Pekiştirelim: 'Bu markadan aldığım hizmet asla eksik çıkmaz' dedirten yüksek misafir güveni şirketin en büyük pazar gücüdür."
          ]
        },
        {
          "name": "Mesleki Öz Denetim Kültürü",
          "desc": "Dışarıdan bir müfettiş veya polis baskısı olmadan, çalışanın kendi vicdanı ve meslek ahlakı gereği işini en yüksek kalitede yapmasıdır.",
          "examples": [
            "Örnekle Pekiştirelim: Kimse görmediği halde bulaşık makinesinin sıcaklık derecesini tam tutan ve hijyen standartlarından taviz vermeyen mutfak personeli."
          ]
        }
      ],
      "caseStudy": {
        "title": "Sektörden Vaka: Ahilik Mirasını Yaşatan Sosyal Girişim",
        "story": "Antalya'da bir butik otel işletmecisi, kazancının %5'ini her ay 'Esnaf ve Burs Fonu'na ayırarak turizm meslek lisesi öğrencilerine burs vermeye başladı.",
        "solution": "Öğrenciler mezun olduklarında bu otelde vefayla çalıştı; otel personel sirkülasyonunu sıfırlayarak bölgenin en istikrarlı ve prestijli işletmesi haline geldi."
      },
      "tip": "Kalite; kimse bakmadığında da doğru olanı yapmaktır. Ahilik kültürü 'öz denetim' ve 'helal kazanç' bilincini kalıcı kılar."
    }
  ]
};

// ==========================================
// 3. ÖĞRENME BİRİMİ: İŞ SAĞLIĞI VE GÜVENLİĞİ
// ==========================================
const Map<String, dynamic> meslekiGelisimUnit3 = {
  "title": "İş Sağlığı ve Güvenliği",
  "learningUnit": "3. Öğrenme Birimi",
  "podcastUrl": "https://anchor.fm/s/114a64400/podcast/play/126372158/https%3A%2F%2Fd3ctxlq1ktw2nl.cloudfront.net%2Fstaging%2F2026-8-27%2F7480200a-d938-67e8-7fae-8e9d1c4806da.mp3",
  "cards": [
    {
      "id": 1,
      "tag": "İSG MEVZUATI",
      "title": "6331 SAYILI İSG KANUNU VE TEHLİKE SINIFLARI",
      "microSummary": "İş Sağlığı ve Güvenliği; çalışma ortamındaki tehlikeleri belirleyerek iş kazalarını ve meslek hastalıklarını önceden engellemeyi amaçlar.",
      "definitions": [
        {
          "name": "6331 Sayılı İSG Kanunu Kapsamı",
          "desc": "Kamu ve özel sektör ayrımı gözetmeksizin, çırak ve stajyerler de dahil olmak üzere tüm çalışanların iş sağlığı ve güvenliğini güvence altına alan temel mevzuattır.",
          "examples": [
            "Örnekle Pekiştirelim: Otelde staj yapan 9. sınıf öğrencisinin de tıpkı kadrolu personel gibi İSG eğitimi alması ve koruyucu ekipmanla donatılması yasal zorunluluktur."
          ]
        },
        {
          "name": "Tehlike Sınıfları (NACE Kodları)",
          "desc": "İş yerlerinin faaliyet alanına göre; Az Tehlikeli (bürolar, oteller, okullar), Tehlikeli (restoranlar, imalathaneler) ve Çok Tehlikeli (inşaat, maden, kimya sanayii) olarak sınıflandırılmasıdır.",
          "examples": [
            "Örnekle Pekiştirelim: Bir seyahat acentesi ofisi 'Az Tehlikeli' sınıftayken; dev sanayi tipi çamaşırhaneler ve kimyasal kullanılan kuru temizleme işletmeleri 'Tehlikeli' sınıftadır."
          ]
        },
        {
          "name": "Tehlike, Risk ve Ramak Kala Olay Ayrımı",
          "desc": "Tehlike: Zarar verme potansiyeli olan durum (ıslak zemin). Risk: Tehlikenin gerçekleşme ihtimali ve şiddeti (kayıp bacağını kırma riski). Ramak Kala: Zarar vermeden kıl payı atlatılan olaydır.",
          "examples": [
            "Örnekle Pekiştirelim: Kat koridorunda ayağı kayan ancak duvara tutunarak düşmekten son anda kurtulan personelin yaşadığı durum 'Ramak Kala Olay'dır ve derhal raporlanmalıdır."
          ]
        }
      ],
      "caseStudy": {
        "title": "Sektörden Vaka: Raporlanmayan Ramak Kala Olayının Kazaya Dönüşmesi",
        "story": "Restoran mutfağında bulaşıkhane zeminindeki yağ birikintisinde bir garson kıl payı dengesini sağladı ancak durumu amirine bildirmedi (Ramak Kala). Yarım saat sonra sıcak çorba tepsisi taşıyan başka bir aşçı aynı yerde kayarak düştü ve 2. derece yanık oluştu.",
        "solution": "İşletme tüm birimlere 'Sarı Kaygan Zemin Levhası' ve 'Ramak Kala Bildirim Kutusu' yerleştirdi; ramak kala bildiren personeli ödüllendirerek kaza önleme kültürünü oturttu."
      },
      "tip": "Tehlike kaynağıdır, risk ise tehlikenin doğuracağı sonuçtur. Unutmayın: 'Her büyük kazanın altında raporlanmamış yüzlerce ramak kala olay yatar.'"
    },
    {
      "id": 2,
      "tag": "GÜVENLİK İŞARETLERİ",
      "title": "İŞ GÜVENLİĞİ İŞARETLERİ VE KİŞİSEL KORUYUCU DONANIMLAR (KKD)",
      "microSummary": "Güvenlik işaretleri renk kodlarıyla acil mesajları iletir; KKD'ler ise çalışanı tehlikelerden koruyan son savunma hattıdır.",
      "definitions": [
        {
          "name": "Güvenlik Renk Kodları ve Anlamları",
          "desc": "Kırmızı: Yasaklama ve Yangın (Daire kırmızı çizgi / Kare yangın ekipmanı). Sarı: Uyarı ve Dikkat (Üçgen). Mavi: Zorunluluk ve Emredici (Daire). Yeşil: Acil Kaçış ve İlk Yardım (Kare/Dikdörtgen).",
          "examples": [
            "Örnekle Pekiştirelim: Mutfakta 'Gözlük Tak' işaretinin mavi daire içinde olması zorunluluk; yangın söndürücünün kırmızı kare içinde olması yangın işaretidir."
          ]
        },
        {
          "name": "Kişisel Koruyucu Donanımlar (KKD)",
          "desc": "Çalışanı iş yerindeki risklere karşı korumak üzere giyilen, takılan veya tutulan baret, çelik burunlu ayakkabı, kulaklık, eldiven, maske ve emniyet kemeri gibi ekipmanlardır.",
          "examples": [
            "Örnekle Pekiştirelim: Kat görevlisinin banyo temizliğinde çamaşır suyu ve asidik kimyasallarla temas etmemesi için nitril eldiven ve koruyucu gözlük takması."
          ]
        },
        {
          "name": "KKD Kullanım Standartları ve CE İşareti",
          "desc": "KKD'ler işverence ücretsiz verilmeli, çalışanın bedenine uygun olmalı ve Avrupa standartlarına uygunluğunu gösteren 'CE' damgasını taşımalıdır.",
          "examples": [
            "Örnekle Pekiştirelim: Çamaşırhane görevlisinin buhar presinde çalışırken ısıya dayanıklı CE sertifikalı eldiven kullanması iş güvenliği kuralıdır."
          ]
        }
      ],
      "caseStudy": {
        "title": "Sektörden Vaka: Basit Bir Koruyucu Gözlüğün Kurtardığı Göz",
        "story": "Kazan dairesinde kireç çözücü kimyasal bidonunu açan teknik servis stajyeri, amirinin ısrarıyla taktığı şeffaf koruyucu gözlüğü çıkarmak istedi ancak amiri uyardı. Kapağı açtığı anda basınçlı asit yüzüne sıçradı.",
        "solution": "Kimyasal doğrudan gözlük camına geldi ve stajyerin gözü tamamen kurtuldu. Yüzü derhal acil göz duşunda yıkandı. Koruyucu gözlüğün hayati önemi tüm personelle paylaşıldı."
      },
      "tip": "KKD riskleri yok etmez; sadece çalışanı kazanın yıkıcı etkisinden korur. Öncelik daima tehlikeyi kaynağında yok etmektir."
    },
    {
      "id": 3,
      "tag": "MESLEK HASTALIKLARI",
      "title": "MESLEK HASTALIKLARI VE ERGONOMİK ÇALIŞMA",
      "microSummary": "Meslek hastalığı; yapılan işin niteliğinden kaynaklanan tekrarlı faktörlerle ortaya çıkan bedensel veya ruhsal rahatsızlıklardır.",
      "definitions": [
        {
          "name": "Meslek Hastalığı Tanımı ve Nedenleri",
          "desc": "Fiziksel (gürültü, titreşim, aşırı sıcak/soğuk), kimyasal (toz, gaz, çözücü), biyolojik (virüs, bakteri) ve psikososyal (stres, mobbing) faktörlerle zaman içinde gelişen hastalıklardır.",
          "examples": [
            "Örnekle Pekiştirelim: Çamaşırhane personelinin sürekli aşırı gürültülü makineler altında kulaklıksız çalışarak zamanla kalıcı işitme kaybına uğraması."
          ]
        },
        {
          "name": "Ergonomi ve Kas-İskelet Sistemi Hastalıkları",
          "desc": "İşin insana, insanın işe uyumunu inceleyen bilim dalıdır. Yanlış ağırlık kaldırma, sürekli ayakta durma ve tekrarlayıcı hareketler bel fıtığı ve karpal tünel sendromuna yol açar.",
          "examples": [
            "Örnekle Pekiştirelim: Kat görevlisinin ağır yatağı belini bükerek değil, dizlerini kırıp bacak kaslarından güç alarak kaldırması ergonomik çalışma kuralıdır."
          ]
        },
        {
          "name": "Mobbing (Psikolojik Taciz)",
          "desc": "İş yerinde bir veya birkaç kişi tarafından bir çalışana sistematik, sürekli ve kasıtlı olarak uygulanan düşmanca tutum, dışlama ve psikolojik yıpratmadır.",
          "examples": [
            "Örnekle Pekiştirelim: Bir resepsiyonistin amiri tarafından sürekli sebepsiz yere azarlanması, işlerinin elinden alınması ve yalnızlaştırılması mobbing örneğidir."
          ]
        }
      ],
      "caseStudy": {
        "title": "Sektörden Vaka: Ergonomik Eğitimle Bel Fıtığı Vakalarının Azaltılması",
        "story": "500 odalı bir resort otelde kat görevlilerinin %30'u sezon ortasında bel fıtığı ve kas zedelenmesi şikayetiyle rapor alarak operasyonu aksattı.",
        "solution": "Otel yönetimi bir fizyoterapist eşliğinde 'Ergonomik Yatak Yapımı ve Yük Kaldırma' atölyesi düzenledi, kat arabalarını hafifletilmiş tekerleklerle yeniledi. Sonraki sezon bel sakatlanmaları %80 azaldı."
      },
      "tip": "Yük kaldırırken belinizi değil, dizlerinizi bükün! Vücudunuza yakın tutmadığınız her 1 kilogramlık yük, omurganıza 10 kilogramlık baskı uygular."
    },
    {
      "id": 4,
      "tag": "RİSK DEĞERLENDİRMESİ",
      "title": "RİSK DEĞERLENDİRMESİ VE KONTROL HİYERARŞİSİ",
      "microSummary": "Risk kontrol hiyerarşisi; tehlikeyi kaynağında yok etmeyi (eliminasyon) en başa, kişisel koruyucu donanımı ise en son çare olarak koyar.",
      "definitions": [
        {
          "name": "Risk Değerlendirmesi Adımları",
          "desc": "1. Tehlikelerin belirlenmesi, 2. Risklerin analizi ve derecelendirilmesi (Olasılık x Şiddet), 3. Kontrol önlemlerinin kararlaştırılması, 4. Önlemlerin uygulanması, 5. Düzenli izleme ve yenileme.",
          "examples": [
            "Örnekle Pekiştirelim: Otel mutfağındaki gaz kaçağı tehlikesinin olasılık ve şiddetini hesaplayıp otomatik gaz kesici dedektörler yerleştirmek."
          ]
        },
        {
          "name": "Risk Kontrol Hiyerarşisi (5 Basamak)",
          "desc": "1. Bertaraf Etme (Yok etme), 2. İkame Etme (Tehlikeliyi daha az tehlikeliyle değiştirme), 3. Mühendislik Kontrolleri (İzolasyon/koruyucu kapak), 4. İdari Kontroller (Eğitim/vardiya), 5. KKD Kullanımı.",
          "examples": [
            "Örnekle Pekiştirelim: Zehirli bir kireç çözücü kimyasal yerine biyolojik organik çözücü kullanmak 'İkame Etme (Substitution)' yöntemidir."
          ]
        },
        {
          "name": "Güvensiz Davranış ve Güvensiz Durum",
          "desc": "Güvensiz Durum: Fiziksel çevrenin kusurlu olması (korkuluksuz merdiven, açık elektrik kablosu). Güvensiz Davranış: Çalışanın hatalı davranışı (baret takmamak, makine çalışırken elini sokmak).",
          "examples": [
            "Örnekle Pekiştirelim: Islak zemine tabela koymamak güvensiz durum, o zeminde koşmak ise güvensiz davranıştır."
          ]
        }
      ],
      "caseStudy": {
        "title": "Sektörden Vaka: Mühendislik Kontrolüyle Kesiklerin Önlenmesi",
        "story": "Otel mutfağında ekmek dilimleme makinesinde çalışan çırakların elleri sık sık bıçağa temas edip derin kesik kazaları yaşanıyordu.",
        "solution": "Yönetim makineye çift el kumandalı şeffaf koruyucu kapak taktırdı (Mühendislik kontrolü). İki el de butonda olmadan bıçak dönmediği için el yaralanması sıfıra indi."
      },
      "tip": "Risk önleme hiyerarşisinde en etkili yöntem 'Yok Etme (Eliminasyon)', en az etkili yöntem ise 'KKD'dir. Sorunu kaynağında çözmek esastır."
    },
    {
      "id": 5,
      "tag": "ACİL DURUM YÖNETİMİ",
      "title": "ACİL DURUM PLANI, KRİZ YÖNETİMİ VE İLK YARDIM",
      "microSummary": "Yangın, deprem, sel ve gaz sızıntısı gibi acil durumlarda can kaybını önlemenin tek yolu; önceden hazırlanmış acil eylem planı ve tatbikatlardır.",
      "definitions": [
        {
          "name": "Acil Durum Ekipleri",
          "desc": "İş yerlerinde yasal zorunluluk olarak kurulan dört ana ekip: Söndürme Ekibi, Kurtarma Ekibi, Koruma Ekibi ve İlk Yardım Ekibi.",
          "examples": [
            "Örnekle Pekiştirelim: Yangın çıktığında söndürme ekibi alevlere müdahale ederken, kurtarma ekibi mahsur kalanları güvenli alana tahliye eder."
          ]
        },
        {
          "name": "Acil Çıkış ve Tahliye Prosedürü",
          "desc": "Acil çıkış kapıları daima dışarıya doğru açılmalı, kilitli tutulmamalı, yeşil aydınlatmalı yön levhalarıyla belirtilmeli ve toplanma alanına açılmalıdır.",
          "examples": [
            "Örnekle Pekiştirelim: Otel yangın merdivenine valiz veya çarşaf arabası bırakılması hayati bir İSG ihlalidir; tahliye yolu daima boş olmalıdır."
          ]
        },
        {
          "name": "İlk Yardımın Temel İlkeleri (KBK)",
          "desc": "Koruma (güvenliği sağla), Bildirme (112 Acil Çağrı Merkezini ara), Kurtarma (bilinçli ve soğukkanlı müdahalede bulun). Hayat kurtarma zinciridir.",
          "examples": [
            "Örnekle Pekiştirelim: Solunum yoluna yemek kaçan ve nefes alamayan misafire eğitimli ilk yardımcının derhal 'Heimlich Manevrası' uygulaması."
          ]
        }
      ],
      "caseStudy": {
        "title": "Sektörden Vaka: Düzenli Tatbikatın Kurtardığı 300 Hayat",
        "story": "Ege kıyısındaki bir tatil köyünde gece yarısı mutfakta büyük bir gaz patlaması ve yangın çıktı. Lobi ve odalarda sirenler çaldı.",
        "solution": "Her 6 ayda bir yapılan yangın tatbikatları sayesinde kat görevlileri paniğe kapılmadan tüm misafirleri 4 dakika içinde asansörleri kullandırmadan toplanma alanına tahliye etti. Sıfır can kaybıyla kriz yönetildi."
      },
      "tip": "Acil durumlarda asla asansör kullanılmaz! Duman yükseldiği için yangında en güvenli hareket zemine yakın emekleyerek tahliye olmaktır."
    }
  ]
};

// ==========================================
// 4. ÖĞRENME BİRİMİ: ÇEVRE KORUMA
// ==========================================
const Map<String, dynamic> meslekiGelisimUnit4 = {
  "title": "Çevre Koruma",
  "learningUnit": "4. Öğrenme Birimi",
  "podcastUrl": "https://anchor.fm/s/114a64400/podcast/play/126372192/https%3A%2F%2Fd3ctxlq1ktw2nl.cloudfront.net%2Fstaging%2F2026-8-27%2F9287398c-984b-81f1-a539-b83ec5d93b47.mp3",
  "cards": [
    {
      "id": 1,
      "tag": "ATIK YÖNETİMİ",
      "title": "ATIK TÜRLERİ VE ATIK YÖNETİM HİYERARŞİSİ",
      "microSummary": "Atık; kullanım ömrünü tamamlamış maddelerdir; atık yönetiminin ilk hedefi atığı henüz oluşmadan kaynağında önlemektir.",
      "definitions": [
        {
          "name": "Atık Türleri ve Sınıflandırma",
          "desc": "Evsel atıklar, endüstriyel atıklar, ambalaj atıkları (plastik, cam, kağıt, metal), organik (biyolojik) atıklar, tehlikeli atıklar ve elektronik atıklar (AEEE) olarak sınıflandırılır.",
          "examples": [
            "Örnekle Pekiştirelim: Otel mutfağında kızartma sonrası kalan bitkisel yağlar doğrudan lavaboya dökülmeyip 'Tehlikeli Bitkisel Atık Yağ' bidonlarında toplanır."
          ]
        },
        {
          "name": "Atık Yönetim Hiyerarşisi (5 Basamak)",
          "desc": "1. Önleme (Atık çıkarmama), 2. Azaltma (Minimum atık), 3. Yeniden Kullanım, 4. Geri Dönüşüm ve Geri Kazanım, 5. Bertaraf (En son çare olarak düzenli depolama).",
          "examples": [
            "Örnekle Pekiştirelim: Otel odalarında tek kullanımlık küçük plastik şampuan şişeleri yerine doldurulabilir büyük dispenser şişeler kullanmak 'Atık Azaltma' adımıdır."
          ]
        },
        {
          "name": "Geri Dönüşüm ve Geri Kazanım",
          "desc": "Geri dönüşüm atıkların fiziksel veya kimyasal işlemlerle tekrar hammaddeye dönüştürülmesidir. Geri kazanım ise atıktan biyogaz veya elektrik enerjisi üretilmesini kapsar.",
          "examples": [
            "Örnekle Pekiştirelim: Toplanan cam şişelerin eritilip yeniden meşrubat şişesi yapılması geri dönüşüm; organik atıklardan biyogaz üretilmesi geri kazanımdır."
          ]
        }
      ],
      "caseStudy": {
        "title": "Sektörden Vaka: 1 Litre Atık Yağın 1 Milyon Litre Suyu Kurtarması",
        "story": "Bir restoran personeli kolayına geldiği için atık kızartma yağını lavaboya dökmek üzereyken stajyer öğrenci onu durdurdu.",
        "solution": "Öğrenci 1 litre atık yağın 1 milyon litre temiz içme suyunu zehirlediğini anlattı. İşletme lisanslı geri dönüşüm firmasıyla anlaştı; her ay toplanan 200 litre yağ biyodizele dönüştürüldü ve işletmeye ek gelir sağlandı."
      },
      "tip": "Atık yönetiminde en değerli adım atığı geri dönüştürmek değil; atığın hiç oluşmamasını sağlamaktır (Önleme İlkesi)."
    },
    {
      "id": 2,
      "tag": "EKOLOJİK AYAK İZİ",
      "title": "EKOLOJİK, KARBON VE SU AYAK İZİ",
      "microSummary": "Ekolojik ayak izi; tüketilen doğal kaynakların üretimi ve oluşan atıkların bertarafı için gereken biyolojik üretken kara ve su alanıdır.",
      "definitions": [
        {
          "name": "Karbon Ayak İzi",
          "desc": "Bireylerin, kurumların veya ürünlerin doğrudan ya da dolaylı olarak atmosfere saldığı karbondioksit (CO2) ve sera gazı miktarının karbondioksit eşdeğeri cinsinden ölçüsüdür.",
          "examples": [
            "Örnekle Pekiştirelim: Uçakla seyahat eden bir turistin kişi başı oluşturduğu sera gazı salınımı, trenle seyahat eden bir yolcunun karbon ayak izinden 5 kat fazladır."
          ]
        },
        {
          "name": "Su Ayak İzi (Yeşil, Mavi, Gri Su)",
          "desc": "Tüketilen bir mal veya hizmetin üretilmesi için harcanan doğrudan ve dolaylı tatlı su miktarıdır. Mavi su: Yüzey/yeraltı suyu; Yeşil su: Yağmur suyu; Gri su: Kirlenen suyu temizlemek için gereken sudur.",
          "examples": [
            "Örnekle Pekiştirelim: 1 fincan kahve için çekirdeğin yetiştirilmesinden fincana gelene kadar tam 140 litre su tüketilir."
          ]
        },
        {
          "name": "Dünya Limit Aşım Günü (Earth Overshoot Day)",
          "desc": "Gezegenin bir yılda üretebildiği doğal kaynağın insanlık tarafından tüketildiği tarihtir. Her yıl daha erken bir tarihe çekilerek ekolojik borçlanmayı gösterir.",
          "examples": [
            "Örnekle Pekiştirelim: Yılın 7. ayında dünya kaynaklarını tüketip kalan 5 ayı gelecek nesillerin hakkından tüketiyor olmak ekolojik limit aşımıdır."
          ]
        }
      ],
      "caseStudy": {
        "title": "Sektörden Vaka: Otelde Çarşaf Değişimiyle Tonlarca Su Tasarrufu",
        "story": "5 yıldızlı bir otel, misafirlerin her gün havlu ve çarşaf değiştirmesini zorunlu tutarak günde 15 ton su ve yüzlerce kilo deterjan harcıyordu.",
        "solution": "'Doğayı Birlikte Koruyalım' kartı hazırlandı: 'Havlu asılıysa tekrar kullanacağım, yerdeyse değiştiriniz.' Misafirlerin %70'i bu çağrıya katıldı; otel ayda 300 ton su tasarrufu sağladı."
      },
      "tip": "Karbon ayak izini azaltmanın en kolay yolu; yerel üreticileri desteklemek, enerji verimli cihazlar kullanmak ve gereksiz ambalajdan kaçınmaktır."
    },
    {
      "id": 3,
      "tag": "KÜRESEL İKLİM",
      "title": "KÜRESEL İKLİM DEĞİŞİKLİĞİ VE YEŞİL MUTABAKAT",
      "microSummary": "Fosil yakıtlar ve kontrolsüz sanayileşme sera gazlarını artırarak küresel ısınmaya yol açmakta; dünya Yeşil Mutabakat ile karbon nötr hedefine koşmaktadır.",
      "definitions": [
        {
          "name": "Sera Etkisi ve Küresel Isınma",
          "desc": "Atmosferdeki karbondioksit ve metan gazlarının güneşten gelen ısıyı tutarak yeryüzünün ortalama sıcaklığını yapay olarak yükseltmesi sürecidir.",
          "examples": [
            "Örnekle Pekiştirelim: Kış turizmi merkezlerindeki kar yağışlarının azalması ve kayak sezonunun 3 aydan 1 aya düşmesi küresel ısınmanın doğrudan etkisidir."
          ]
        },
        {
          "name": "Paris İklim Anlaşması",
          "desc": "Küresel sıcaklık artışını sanayi öncesi döneme göre 1.5°C ile sınırlandırmayı hedefleyen, Türkiye'nin de taraf olduğu tarihi küresel iklim sözleşmesidir.",
          "examples": [
            "Örnekle Pekiştirelim: İşletmelerin baca gazı emisyonlarını sıfıra indirme ve yenilenebilir enerjiye geçiş taahhütleri."
          ]
        },
        {
          "name": "Avrupa Yeşil Mutabakatı (Green Deal)",
          "desc": "2050 yılına kadar Avrupa kıtasını karbon nötr yapmayı amaçlayan, sınırda karbon vergisi düzenlemeleriyle ticareti yeşil üretime zorlayan uluslararası eylem planıdır.",
          "examples": [
            "Örnekle Pekiştirelim: İhracat yapan Türk tekstil ve otel tedarik firmalarının 'Yeşil Üretim Belgesi' olmadan Avrupa'ya mal satamaması."
          ]
        }
      ],
      "caseStudy": {
        "title": "Sektörden Vaka: Kuraklık Tehlikesine Karşı Yağmur Suyu Hasadı",
        "story": "Ege'de aşırı kuraklık çeken bir turizm beldesinde otelin su faturaları üçe katlandı ve yerel su kaynakları tükenme noktasına geldi.",
        "solution": "Otel çatılarına yağmur suyu toplama kanalları ve yeraltı sarnıçları kurdu. Yağmur suyu arıtılarak bahçe sulamasında ve tuvalet rezervuarlarında kullanıldı; şebeke suyu tüketimi %40 azaldı."
      },
      "tip": "Yeşil Mutabakat sadece bir çevre projesi değil, geleceğin küresel ticaret kurallarını belirleyen ekonomik bir dönüşümdür."
    },
    {
      "id": 4,
      "tag": "EKO-ETİKETLER",
      "title": "YENİLENEBİLİR ENERJİ VE YEŞİL SERTİFİKASYONLAR",
      "microSummary": "Güneş, rüzgar ve jeotermal gibi yenilenebilir kaynaklar temiz enerji sağlarken; Mavi Bayrak ve Yeşil Yıldız gibi eko-etiketler çevre dostu işletmeleri tesciller.",
      "definitions": [
        {
          "name": "Yenilenebilir Enerji Kaynakları",
          "desc": "Doğada sürekli var olan ve tükenmeyen; güneş, rüzgar, jeotermal, biyokütle ve hidroelektrik gibi karbon salınımı yapmayan enerji kaynaklarıdır.",
          "examples": [
            "Örnekle Pekiştirelim: Bir otelin çatısını Güneş Enerji Santrali (GES) panelleriyle kaplayarak tüm elektrik ihtiyacını kendi güneşinden üretmesi."
          ]
        },
        {
          "name": "Eko-Etiketler (Mavi Bayrak, Yeşil Yıldız)",
          "desc": "Mavi Bayrak: Temiz deniz, plaj ve çevre yönetimi tescili. Yeşil Yıldız (Çevreye Duyarlı Tesis): Kültür ve Turizm Bakanlığı'nın su, enerji ve atık tasarrufu yapan otellere verdiği plakettir.",
          "examples": [
            "Örnekle Pekiştirelim: Avrupalı çevreci bir turistin tatil rezervasyonu yaparken Yeşil Yıldız ve Mavi Bayrak sertifikası olan otelleri öncelikle seçmesi."
          ]
        },
        {
          "name": "ISO 14001 Çevre Yönetim Sistemi",
          "desc": "Kuruluşların faaliyetlerinin çevreye olan olumsuz etkilerini en aza indirmek ve yasal çevre mevzuatlarına tam uyumu belgelemek için kurulan uluslararası standarttır.",
          "examples": [
            "Örnekle Pekiştirelim: Otelde kimyasal kullanımından atık ayrıştırmaya kadar tüm adımların bağımsız çevre denetçilerince tescillenmesi."
          ]
        }
      ],
      "caseStudy": {
        "title": "Sektörden Vaka: Güneş Enerjisiyle Sıfır Elektrik Faturası",
        "story": "Antalya'da 150 odalı bir otel yaz aylarında çalışan klimalar nedeniyle aylık 250.000 TL elektrik faturası ödüyordu.",
        "solution": "Otel otopark çatısına ve ana binaya fotovoltaik güneş panelleri kurdu. Gündüz üretilen fazla elektrik şebekeye satıldı; otel elektrik maliyetini sıfırlarken yılda 120 ton karbon salınımını önledi."
      },
      "tip": "Eko-etiketler günümüz bilinçli misafirlerinin satın alma kararında en önemli etkendir. Yeşil olmak bir masraf değil, en karlı pazarlama yatırımıdır."
    },
    {
      "id": 5,
      "tag": "DÖNGÜSEL EKONOMİ",
      "title": "DÖNGÜSEL EKONOMİ, SIFIR ATIK VE 3R İLKESİ",
      "microSummary": "Doğrusal 'al-yap-at' modeli yerine 'azalt-yeniden kullan-dönüştür' (3R) felsefesine dayanan döngüsel ekonomi, hiçbir kaynağın çöp olmasına izin vermez.",
      "definitions": [
        {
          "name": "Doğrusal Ekonomiden Döngüsel Ekonomiye Geçiş",
          "desc": "Doğrusal ekonomi kaynakları tüketip çöpe atar. Döngüsel ekonomi ise hammaddenin kullanım süresini uzatır, tamir eder, yeniden kullanır ve atığı başka bir sektörün hammaddesi yapar.",
          "examples": [
            "Örnekle Pekiştirelim: Eskiyen otel nevresimlerinin çöpe atılmayıp terzihanede personel temizlik bezi ve mutfak önlüğü olarak yeniden dikilmesi."
          ]
        },
        {
          "name": "Sıfır Atık Projesi ve 3R İlkesi",
          "desc": "3R: Reduce (Azalt), Reuse (Yeniden Kullan), Recycle (Geri Dönüştür). Sıfır atık, israfın önlenmesini ve atığın kaynağında renkli kumbaralarda ayrıştırılmasını hedefler.",
          "examples": [
            "Örnekle Pekiştirelim: Mavi kumbaraya kağıt, sarı kumbaraya plastik, yeşil kumbaraya cam, gri kumbaraya metal atılması sıfır atık ayrıştırma standardıdır."
          ]
        },
        {
          "name": "Kompost Üretimi (Organik Atık Geri Kazanımı)",
          "desc": "Yemek hazırlık atıklarının, meyve-sebze kabuklarının ve park-bahçe budama artıklarının oksijenli ortamda çürütülerek doğal organik gübreye dönüştürülmesidir.",
          "examples": [
            "Örnekle Pekiştirelim: Restoran mutfağındaki sebze atıklarının kompost makinesine atılarak otelin botanik bahçesi için gübre üretilmesi."
          ]
        }
      ],
      "caseStudy": {
        "title": "Sektörden Vaka: Otel Bahçesini Besleyen Kompost Mucizesi",
        "story": "Günde 500 kilo mutfak sebze-meyve artığı çıkan bir tesis bu atıkları şehir çöpüne gönderiyor ve kötü kokuya sebep oluyordu.",
        "solution": "İşletme bahçeye endüstriyel kompost ünitesi kurdu. Tüm organik atıklar gübreye dönüştürüldü; otelin peyzaj çiçekleri bu gübreyle yetiştirildi ve kimyasal gübre alımı tamamen sonlandırıldı."
      },
      "tip": "Doğada 'çöp' diye bir kavram yoktur; bir canlının atığı diğerinin besinidir. Döngüsel ekonomi bu doğa kuralını iş dünyasına uyarlar."
    }
  ]
};

// ==========================================
// 5. ÖĞRENME BİRİMİ: GİRİŞİMCİLİK: FİKİRLER, İŞ KURMA VE YÜRÜTME
// ==========================================
const Map<String, dynamic> meslekiGelisimUnit5 = {
  "title": "Girişimcilik: Fikirler, İş Kurma ve Yürütme",
  "learningUnit": "5. Öğrenme Birimi",
  "podcastUrl": "https://anchor.fm/s/114a64400/podcast/play/126372215/https%3A%2F%2Fd3ctxlq1ktw2nl.cloudfront.net%2Fstaging%2F2026-8-27%2Fd0b33971-8a8b-8bea-aac2-c11f79b5678c.mp3",
  "cards": [
    {
      "id": 1,
      "tag": "GİRİŞİMCİLİK KAVRAMI",
      "title": "GİRİŞİMCİLİK KAVRAMI VE GİRİŞİMCİ PROFİLİ",
      "microSummary": "Girişimci; piyasadaki fırsatları sezen, risk alarak üretim faktörlerini bir araya getiren ve katma değer üreten yenilikçi liderdir.",
      "definitions": [
        {
          "name": "Girişimci ve Girişimcilik Tanımı",
          "desc": "İhtiyaçları ve fırsatları görerek kâr veya toplumsal fayda amacıyla emek, sermaye, doğal kaynak ve teknolojiyi bir araya getiren, risk üstlenen kişidir.",
          "examples": [
            "Örnekle Pekiştirelim: Kapadokya'da ATV turlarındaki toz ve gürültü sorununu görüp sessiz ve çevre dostu elektrikli atv turu acentesi kuran bir turizm mezunu girişimcidir."
          ]
        },
        {
          "name": "Girişimcinin Temel Nitelikleri",
          "desc": "Fırsat odaklılık, risk toleransı, öz güven, yaratıcılık, yılmazlık (resilience), liderlik, belirsizlikle başa çıkma ve problem çözme becerisidir.",
          "examples": [
            "Örnekle Pekiştirelim: İlk açtığı kafeterya başarısız olduğu halde pes etmeyip hatalarından ders alarak ikinci denemesinde başarılı bir butik pastane zinciri kurmak."
          ]
        },
        {
          "name": "Girişimcilik Türleri",
          "desc": "Ticari girişimcilik (kâr odaklı), Sosyal girişimcilik (toplumsal/çevresel sorun odaklı), İç girişimcilik (mevcut şirket içinde yenilik) ve Dijital girişimcilik.",
          "examples": [
            "Örnekle Pekiştirelim: Bir otelde çalışan resepsiyonistin yönetime 'Otel İçi Akıllı Bagaj Takip Yazılımı' projesi sunarak departmanını dijitalleştirmesi İç Girişimciliktir."
          ]
        }
      ],
      "caseStudy": {
        "title": "Sektörden Vaka: Otel Odası Fazlasından Doğan Küresel Dev",
        "story": "San Francisco'da tasarım konferansı için şehre gelen katılımcıların otel bulamadığını gören iki genç, oturma odalarındaki hava yatağını ve sabah kahvaltısını kiraya verdi.",
        "solution": "Bu basit ihtiyaçtan hareketle Airbnb platformunu kurdular. Hiç otel binası inşa etmeden dünyanın en büyük konaklama ağı haline geldiler; girişimcilik fırsatı doğru okumaktır."
      },
      "tip": "Girişimci mevcut parası olan değil; başkalarının göremediği ihtiyacı ve fırsatı görüp hayata geçirme cesareti gösteren kişidir."
    },
    {
      "id": 2,
      "tag": "İŞ FİKRİ VE İNOVASYON",
      "title": "BAŞARILI İŞ FİKİRLERİ VE FIRSAT ANALİZİ",
      "microSummary": "Her fikir bir iş fikri değildir; başarılı bir iş fikri gerçek bir problemi çözen, değer yaratan ve pazarda karşılığı olandır.",
      "definitions": [
        {
          "name": "İş Fikrinin Kaynakları",
          "desc": "Kişisel hobiler ve uzmanlık, pazar boşlukları ve misafir/tüketici talepleri, yeni teknolojiler, yasal değişiklikler ve demografik değişimlerdir.",
          "examples": [
            "Örnekle Pekiştirelim: Evcil hayvan sahiplerinin otele kabul edilmediği şikayetlerinden yola çıkarak 'Pet-Friendly (Evcil Hayvan Dostu) Butik Otel' konsepti geliştirmek."
          ]
        },
        {
          "name": "İnovasyon (Yenilikçilik) Türleri",
          "desc": "Ürün inovasyonu (yeni ürün), Hizmet inovasyonu (yeni hizmet deneyimi), Süreç inovasyonu (üretim tekniği) ve Pazarlama inovasyonu.",
          "examples": [
            "Örnekle Pekiştirelim: Otelde anahtarsız, misafirin kendi cep telefonundaki mobil uygulama üzerinden kapıyı açması (Mobil Anahtar) bir hizmet ve teknoloji inovasyonudur."
          ]
        },
        {
          "name": "Katma Değer ve Ölçeklenebilirlik",
          "desc": "Katma değer ürünün maliyeti ile tüketiciye sunduğu fayda farkıdır. Ölçeklenebilirlik ise iş modelinin maliyetleri doğrusal artmadan katlanarak büyüme potansiyelidir.",
          "examples": [
            "Örnekle Pekiştirelim: Bir mobil turizm rehberi uygulamasının 100 kullanıcıya da 1 milyon kullanıcıya da aynı sunucu altyapısıyla hizmet verebilmesi ölçeklenebilirliktir."
          ]
        }
      ],
      "caseStudy": {
        "title": "Sektörden Vaka: Glamping (Lüks Kamp) İş Fikrinin Başarısı",
        "story": "Doğada kamp yapmak isteyen ancak çadır kurma zahmeti ve hijyen eksikliğinden çekinen yüksek gelirli tatilcilerin arayışını bir turizmci fark etti.",
        "solution": "Doğanın kalbinde lüks yatak, klima, özel banyo ve jakuzisi olan şeffaf kubbe çadırlar (Glamping) kurdu. Kamp ile 5 yıldızlı otel konforunu birleştirerek doluluk rekorları kırdı."
      },
      "tip": "Harika bir iş fikri aramayın; insanların günlük hayatında yaşadığı 'büyük bir sıkıntıyı (pain point)' bulun ve onu en zarif şekilde çözün."
    },
    {
      "id": 3,
      "tag": "DESIGN THINKING",
      "title": "TASARIM ODAKLI DÜŞÜNME (DESIGN THINKING)",
      "microSummary": "Tasarım odaklı düşünme; insanı merkeze alan, empatiyle başlayıp prototip ve testle olgunlaşan 5 adımlı yaratıcı problem çözme metodolojisidir.",
      "definitions": [
        {
          "name": "Design Thinking 5 Aşaması",
          "desc": "1. Empati Kur (Kullanıcıyı anla), 2. Tanımla (Problemi netleştir), 3. Fikir Üret (Beyin fırtınası yap), 4. Prototip Yap (Somutlaştır), 5. Test Et (Kullanıcıdan geri bildirim al).",
          "examples": [
            "Örnekle Pekiştirelim: Otel lobisinde tekerlekli sandalyeli misafirlerin check-in bankosunun yüksekliği yüzünden yaşadığı zorluğu empatiyle gözlemleyip alçak engelsiz masa tasarlamak."
          ]
        },
        {
          "name": "Empati ve Persona Oluşturma",
          "desc": "Kullanıcının yerine geçerek ne hissettiğini, ne gördüğünü ve neye ihtiyaç duyduğunu anlamaktır. Persona, hedef kitleyi temsil eden hayali kullanıcı profilidir.",
          "examples": [
            "Örnekle Pekiştirelim: '65 yaşında, yürümekte zorlanan, sakinlik arayan Emekli Öğretmen Ayşe Hanım' personası için otel içi ulaşım çözümleri geliştirmek."
          ]
        },
        {
          "name": "Prototipleme ve Hızlı Yanılma (Fail Fast)",
          "desc": "Büyük bütçeler harcamadan önce fikrin karton, çizim veya dijital taslakla somut küçük modelini üretip hataları erkenden ve ucuza görmektir.",
          "examples": [
            "Örnekle Pekiştirelim: Yeni menü konseptini tüm restoranlara uygulamadan önce 1 hafta boyunca tek bir şubede pilot olarak deneyip misafir tepkilerini ölçmek."
          ]
        }
      ],
      "caseStudy": {
        "title": "Sektörden Vaka: Çocuklu Aileler İçin Otel Tasarımı",
        "story": "Bir otel tasarım ekibi çocuklu ailelerin tatilde dinlenemediğini, sürekli çocukların peşinde stres yaşadığını empati aşamasında keşfetti.",
        "solution": "Restoran masalarının yanına cam bölmeli güvenli mini oyun alanları, odalara ise bebek telsizi ve biberon ısıtıcısı eklediler. Ebeveyn memnuniyeti %98'e ulaştı."
      },
      "tip": "Masanızda oturarak misafiri ve kullanıcıyı anlayamazsınız. Sahaya çıkın, kullanıcıyı gözlemleyin ve 'Benim fikrim' değil 'Kullanıcının ihtiyacı' odaklı düşünün."
    },
    {
      "id": 4,
      "tag": "İŞ MODELİ KANVASI",
      "title": "İŞ MODELİ KANVASI (BMC) VE YALIN GİRİŞİM",
      "microSummary": "İş Modeli Kanvası bir girişimin nasıl değer yarattığını, ulaştırdığını ve gelir elde ettiğini 9 temel kutuda tek sayfada özetleyen stratejik araçtır.",
      "definitions": [
        {
          "name": "İş Modeli Kanvasının 9 Yapı Taşı",
          "desc": "1. Hedef Kitle ve Misafir Segmentleri, 2. Değer Önerisi, 3. Dağıtım ve İletişim Kanalları, 4. Misafir ve Kullanıcı İlişkileri, 5. Gelir Akışları, 6. Temel Kaynaklar, 7. Temel Faaliyetler, 8. Temel Ortaklar, 9. Maliyet Yapısı.",
          "examples": [
            "Örnekle Pekiştirelim: Butik bir eko-otelin Değer Önerisi: 'Doğal köy kahvaltısı eşliğinde stresten arındırıcı sessiz orman tatili'dir."
          ]
        },
        {
          "name": "Yalın Girişim (Lean Startup) ve MVP",
          "desc": "Minimum Uygulanabilir Ürün (MVP): Fikrin çalışırlığını test eden en temel, en az özellikle donatılmış ilk versiyonudur. 'İnşa Et - Ölç - Öğren' döngüsüne dayanır.",
          "examples": [
            "Örnekle Pekiştirelim: Büyük bir turizm rezervasyon portalı kodlamadan önce Instagram'da tek bir tur duyurusu paylaşıp kaç kişinin satın almak istediğini test etmek MVP'dir."
          ]
        },
        {
          "name": "Değer Önerisi (Value Proposition)",
          "desc": "Misafirin veya tüketicinin rakipler yerine neden sizi tercih etmesi gerektiğini açıklayan, benzersiz fayda ve çözüm vaadidir.",
          "examples": [
            "Örnekle Pekiştirelim: 'Havalimanından otele 15 dakikada garantili VIP transfer; gecikirse ücret iadesi' benzersiz bir değer önerisidir."
          ]
        }
      ],
      "caseStudy": {
        "title": "Sektörden Vaka: 50 Sayfalık İş Planı Yerine Tek Sayfalık Kanvas",
        "story": "Genç iki girişimci tur rehberliği platformu için 100 sayfalık iş planı yazarak 6 ay kaybetti. Ancak piyasaya çıktıklarında turistlerin rehber değil yerel deneyim aradığını anladılar.",
        "solution": "İş Modeli Kanvasına geçtiler; kanvas üzerinde değer önerisini 'Yerel halkla birlikte yemek pişirme ve köy turu' olarak 1 saatte revize edip hızla başarıya ulaştılar."
      },
      "tip": "Hiçbir iş planı misafir ve kullanıcıyla ilk temastan sağ çıkamaz! Kanvasınızı duvara asın, post-it'lerle sürekli güncelleyin ve test ederek öğrenin."
    },
    {
      "id": 5,
      "tag": "İŞLETME KURMA",
      "title": "FİZİBİLİTE ETÜDÜ, ŞİRKET KURMA VE KOSGEB DESTEKLERİ",
      "microSummary": "İşletme kurmadan önce fizibilite etüdüyle pazar, teknik ve finansal uygulanabilirlik incelenir; doğru şirket türü ve devlet teşvikleri seçilir.",
      "definitions": [
        {
          "name": "Fizibilite Etüdü (Uygulanabilirlik Araştırması)",
          "desc": "Pazar araştırması (talep var mı?), Teknik analiz (nasıl üretilecek?), Finansal analiz (kârlı mı?) ve Hukuki analizden oluşan kapsamlı yatırım analizidir.",
          "examples": [
            "Örnekle Pekiştirelim: Bölgedeki otel doluluklarını, rakip fiyatlarını ve inşaat maliyetlerini hesaplayarak otel yatırımının 5 yılda kendini amorti edeceğini kanıtlamak."
          ]
        },
        {
          "name": "Şirket Türleri (Şahıs, Limited, Anonim)",
          "desc": "Şahıs Şirketi: Hızlı ve ucuz kurulur, borçlardan tüm mal varlığıyla sorumludur. Limited Şirket (Ltd. Şti.): 1 veya daha fazla ortakla kurulur, sorumluluk sermaye payıyla sınırlıdır.",
          "examples": [
            "Örnekle Pekiştirelim: Küçük bir turizm rehberlik ofisi için şahıs şirketi yeterli iken; otel yatırımı veya tur operatörlüğü için Limited veya Anonim Şirket tercih edilir."
          ]
        },
        {
          "name": "KOSGEB ve Girişimcilik Teşvikleri",
          "desc": "Küçük ve Orta Ölçekli İşletmeleri Geliştirme İdaresi Başkanlığı (KOSGEB), yeni girişimcilere hibe (geri ödemesiz) ve faizsiz kredi destekleri sunar.",
          "examples": [
            "Örnekle Pekiştirelim: KOSGEB İleri Girişimci Destek Programı'na başvurarak kurduğu turizm yazılımı girişimi için 300.000 TL makine ve kuruluş hibesi almak."
          ]
        }
      ],
      "caseStudy": {
        "title": "Sektörden Vaka: Fizibilite Yapılmadan Açılan Kafenin İflası",
        "story": "Bir girişimci çok beğendiği bir caddede yüksek kirayla lüks bir kafe açtı. Ancak o caddeden geçen yayaların çoğunun aceleyle işe yetişen ve oturmaya vakti olmayan memurlar olduğunu fizibilite yapmadığı için göremedi.",
        "solution": "İşletme 6 ayda iflas etti. Girişimci sonraki yatırımında yaya trafiği ve tüketici profilini 1 ay boyunca bizzat sayarak (Pazar araştırması) doğru lokasyonda kârlı bir 'Al-Götür (Take-Away)' noktası kurdu."
      },
      "tip": "Fizibilite etüdü yapılmamış yatırım, rotasız denize açılan gemiye benzer; ilk fırtınada batması kaçınılmazdır."
    }
  ]
};

// ==========================================
// 6. ÖĞRENME BİRİMİ: FİKRÎ VE SINAİ MÜLKİYET HAKLARI
// ==========================================
const Map<String, dynamic> meslekiGelisimUnit6 = {
  "title": "Fikrî ve Sınai Mülkiyet Hakları",
  "learningUnit": "6. Öğrenme Birimi",
  "podcastUrl": "https://anchor.fm/s/114a64400/podcast/play/126372318/https%3A%2F%2Fd3ctxlq1ktw2nl.cloudfront.net%2Fstaging%2F2026-8-27%2F9c43dde5-04ea-efb3-1a30-759b68ab6313.mp3",
  "cards": [
    {
      "id": 1,
      "tag": "FİKRÎ MÜLKİYET TEMELLERİ",
      "title": "FİKRÎ VE SINAİ MÜLKİYET AYRIMI VE TÜRKPATENT",
      "microSummary": "Fikrî mülkiyet; insan aklının, yaratıcılığının ve emeğinin ortaya koyduğu özgün eserlerin ve buluşların yasal koruma kalkanıdır.",
      "definitions": [
        {
          "name": "Fikrî Mülkiyet Kavramı ve İki Ana Dalı",
          "desc": "1. Fikir ve Sanat Eserleri (Telif Hakları): Edebi, sanatsal, müzikal eserler ve yazılımlar. 2. Sınai Mülkiyet: Sanayi ve ticaretteki buluşlar, markalar, tasarımlar ve patentler.",
          "examples": [
            "Örnekle Pekiştirelim: Bir otelin web sitesi için yazılan özgün tanıtım kitabı ve çekilen fotoğraflar Telif Hakkı; otelin adı ve logosu ise Sınai Mülkiyet (Marka) kapsamındadır."
          ]
        },
        {
          "name": "TÜRKPATENT (Türk Patent ve Marka Kurumu)",
          "desc": "Sanayi ve Teknoloji Bakanlığı'na bağlı olarak Türkiye'de patent, faydalı model, marka, tasarım ve coğrafi işaret tescillerini yürüten resmi kurumdur.",
          "examples": [
            "Örnekle Pekiştirelim: Yeni açılan turizm acentesinin özgün logosunu ve ticari unvanını korumak için TÜRKPATENT elektronik başvuru sisteminden tescil başvurusu yapılması."
          ]
        },
        {
          "name": "Telif Hakları Genel Müdürlüğü",
          "desc": "Kültür ve Turizm Bakanlığı bünyesinde; 5846 sayılı Fikir ve Sanat Eserleri Kanunu kapsamında kitap, müzik, sinema ve yazılımların hak sahipliğini kayıt ve tescil eden kurumdur.",
          "examples": [
            "Örnekle Pekiştirelim: Bir turizm yazarının yazdığı rehberlik kitabının bandrol ve telif kaydını Kültür ve Turizm Bakanlığı'ndan alması."
          ]
        }
      ],
      "caseStudy": {
        "title": "Sektörden Vaka: Tescilsiz Markanın Başkası Tarafından Kapılması",
        "story": "Antalya'da 10 yıldır 'Toros Butik Otel' ismiyle büyük başarı yakalayan ancak marka tescili yaptırmayan bir işletmecinin tabelasını gören fırsatçı bir rakip, TÜRKPATENT'e giderek bu ismi kendi adına tescil ettirdi.",
        "solution": "Gerçek işletmeci mahkemelerde yıllarca yüksek masrafla hak iddiasında bulunmak zorunda kaldı. Marka tescili ilk başvuranın hakkı ilkesiyle (ilk gelen alır) korunduğundan tescil geciktirilmemelidir."
      },
      "tip": "Fikirler değil; yalnızca somutlaşmış eserler ve tescillenmiş buluşlar korunur. Aklınızdaki fikri korumak istiyorsanız onu somutlaştırıp tescil ettirmelisiniz."
    },
    {
      "id": 2,
      "tag": "TELİF HAKLARI",
      "title": "TELİF HAKLARI, KORSANLA MÜCADELE VE İNTİHAL",
      "microSummary": "Telif hakkı (©); eserin meydana getirilmesiyle kendiliğinden doğar; izinsiz kopyalama korsan, başkasının eserini kendisininmiş gibi göstermek intihaldir.",
      "definitions": [
        {
          "name": "Telif Hakkı (Copyright - ©)",
          "desc": "Eser sahibinin mali (işleme, çoğaltma, yayma, temsil, umuma iletim) ve manevi (adın belirtilmesi, eserde değişiklik yapılmasını men etme) yasal haklarıdır. Koruma süresi eser sahibinin ömrü + 70 yıldır.",
          "examples": [
            "Örnekle Pekiştirelim: Bir otelde çalınan müzikler veya lobi televizyonlarında yayınlanan yayınlar için meslek birliklerine (MESAM, MSG vb.) telif bedeli ödenmesi zorunludur."
          ]
        },
        {
          "name": "İntihal (Aşırma / Plagiarism)",
          "desc": "Bir başkasına ait fikirleri, metinleri, görselleri veya araştırmaları kaynak göstermeksizin alıp sanki kendi özgün çalışmasıymış gibi sunma ahlak ve hukuk dışı fiildir.",
          "examples": [
            "Örnekle Pekiştirelim: Başka bir acentenin hazırladığı özel tur programı metnini kopyalayıp kendi sitesine yapıştırmak doğrudan intihaldir."
          ]
        },
        {
          "name": "Korsan Üretim ve Bandrol",
          "desc": "Hak sahibinin izni olmadan çoğaltılan ve satılan sahte ürünlerdir. Bandrol, eserin yasal olarak çoğaltıldığını gösteren güvenlik hologramıdır.",
          "examples": [
            "Örnekle Pekiştirelim: Otel bilgisayarlarında lisanssız kırılmış işletim sistemi veya muhasebe yazılımı kullanmak korsan suçudur ve ağır para cezası vardır."
          ]
        }
      ],
      "caseStudy": {
        "title": "Sektörden Vaka: Web Sitesindeki Telifli Fotoğraf Cezası",
        "story": "Bir seyahat acentesi web sitesine koymak için Google'dan Kapadokya balon fotoğrafı indirdi ve izinsiz kullandı. Fotoğrafın sahibi profesyonel fotoğrafçı durumu tespit etti.",
        "solution": "Fotoğrafçı Fikri ve Sınai Haklar Mahkemesi'ne başvurarak 50.000 TL tazminat kazandı. Acente hem parayı ödedi hem de lisanslı stok fotoğraf platformlarına üye olmak zorunda kaldı."
      },
      "tip": "İnternette bulduğunuz her görsel serbestçe kullanılamaz! Ticari işlerinizde telifsiz (Creative Commons) veya lisansı satın alınmış görseller kullanmalısınız."
    },
    {
      "id": 3,
      "tag": "PATENT VE FAYDALI MODEL",
      "title": "PATENT VE FAYDALI MODEL KORUMASI",
      "microSummary": "Patent; sanayiye uygulanabilir, dünya çapında yeni ve buluş basamağı içeren teknik buluşlara verilen 20 yıllık tekel koruma hakkıdır.",
      "definitions": [
        {
          "name": "Patent ve Üç Temel Kriteri",
          "desc": "1. Yenilik (Dünyada daha önce olmaması), 2. Buluş Basamağı (Uzmanınca kolayca çıkarılamayacak teknik aşama), 3. Sanayiye Uygulanabilirlik (Üretilebilir olması). Koruma süresi 20 yıldır.",
          "examples": [
            "Örnekle Pekiştirelim: Kat arabalarındaki kirlileri otomatik ayıran ve RFID çipiyle okuyan yeni bir mekanik-elektronik sistem geliştiren mucidin patent alması."
          ]
        },
        {
          "name": "Faydalı Model Belgesi",
          "desc": "Küçük ve orta ölçekli yeniliklere verilen belgedir. 'Buluş basamağı' aranmaz; dünyada yeni olması ve sanayiye uygulanması yeterlidir. Koruma süresi 10 yıldır.",
          "examples": [
            "Örnekle Pekiştirelim: Mevcut valiz tekerleklerine merdiven tırmanmayı sağlayan üçlü döner tekerlek mekanizması eklenmesi faydalı modeldir."
          ]
        },
        {
          "name": "Patent Korumasının Sona Ermesi ve Kamu Malı",
          "desc": "20 yıllık patent süresi dolduğunda buluş kamu malı haline gelir; herkes o buluşu serbestçe ve ücretsiz üretebilir.",
          "examples": [
            "Örnekle Pekiştirelim: İlaç patentlerinin 20 yıl sonra bitmesiyle yerli firmaların eşdeğer (jenerik) ilaç üretebilmesi."
          ]
        }
      ],
      "caseStudy": {
        "title": "Sektörden Vaka: Otel Yazılımının Patent ve Lisans Başarısı",
        "story": "Genç bir mühendis, otellerde oda sıcaklığını misafirin vücut ısısına göre otomatik ayarlayan yapay zekalı bir algoritma geliştirip patentini aldı.",
        "solution": "Büyük bir otel otomasyon şirketi bu patenti satın almak istedi. Genç girişimci patenti satmak yerine otellere yıllık kullanım lisansı (License) vererek düzenli telif geliri elde etti."
      },
      "tip": "Faydalı modelde kimyasal formüller ve usuller korunamaz; sadece somut ürün ve mekanik geliştirmeler korunur. Patent 20 yıl, faydalı model 10 yıl korur."
    },
    {
      "id": 4,
      "tag": "MARKA VE COĞRAFİ İŞARET",
      "title": "MARKA, ENDÜSTRİYEL TASARIM VE COĞRAFİ İŞARETLER",
      "microSummary": "Marka işletmenin kimliğidir, tasarım ürünün estetiğidir; coğrafi işaret ise belirli bir yöreye ait eşsiz lezzet ve el sanatlarının coğrafi güvencesidir.",
      "definitions": [
        {
          "name": "Marka ve Tescil Süresi (®)",
          "desc": "Bir işletmenin mal veya hizmetlerini diğer işletmelerden ayırt etmeye yarayan sözcükler, logolar, şekiller, renkler ve seslerdir. Tescil süresi 10 yıldır ve 10'ar yıllık periyotlarla sonsuza kadar yenilenebilir.",
          "examples": [
            "Örnekle Pekiştirelim: Otel logosunun yanındaki ® işareti 'Registered (Tescilli Marka)' olduğunu ve taklit edilemeyeceğini gösterir."
          ]
        },
        {
          "name": "Endüstriyel Tasarım Tescili",
          "desc": "Bir ürünün çizgisi, şekli, rengi, dokusu veya malzemesi gibi insan duyularıyla algılanabilen estetik dış görünümünün korunmasıdır. 5'er yıllık dönemlerle en fazla 25 yıl korunur.",
          "examples": [
            "Örnekle Pekiştirelim: Bir turizm otelinin özel olarak tasarlattığı dalga formundaki ikonik şezlong modelinin tasarım tesciliyle korunması."
          ]
        },
        {
          "name": "Coğrafi İşaretler (Menşe Adı ve Mahreç İşareti)",
          "desc": "Belirgin bir niteliği, ünü veya diğer özellikleri itibarıyla kökenin bulunduğu yöre, alan, bölge veya ülke ile özdeşleşmiş ürünleri gösteren işarettir.",
          "examples": [
            "Örnekle Pekiştirelim: 'Gaziantep Baklavası' ve 'Malatya Kayısısı' menşe adı; 'Maraş Dondurması' ve 'Antakya Künefesi' mahreç işaretli coğrafi tescilli ürünlerdir."
          ]
        }
      ],
      "caseStudy": {
        "title": "Sektörden Vaka: Coğrafi İşaret Sayesinde Turizm Gelirinin Katlanması",
        "story": "Afyonkarahisar'da yerel sucuk ve lokum üreticileri merdiven altı sahte ürünlerin piyasayı işgal etmesiyle itibar kaybı yaşıyordu.",
        "solution": "Ticaret Odası 'Afyon Sucuğu' ve 'Afyon Lokumu' için coğrafi işaret tescili aldı. Karekodlu sertifikalı ürünler gastronomik turizmin gözdesi oldu ve satış fiyatı %150 arttı."
      },
      "tip": "Coğrafi işaret tek bir şirketin malı olamaz! O yörede belirlenen standartlarda üretim yapan tüm yerel üreticilerin ortak mirasıdır."
    },
    {
      "id": 5,
      "tag": "BAŞVURU SÜRECİ",
      "title": "MÜLKİYET HAKLARI BAŞVURUSU VE YASAL HAK ARAMA",
      "microSummary": "TÜRKPATENT başvurusunda rüçhan hakkı zaman önceliği sağlar; hak ihlallerinde Fikri ve Sınai Haklar Hukuk Mahkemeleri devreye girer.",
      "definitions": [
        {
          "name": "TÜRKPATENT Başvuru Süreci",
          "desc": "Elektronik başvuru, şekli inceleme, araştırma ve inceleme raporu, Resmi Bülten'de 2 ay ilanda kalma (itiraz süresi) ve tescil belgesinin düzenlenmesi adımlarıdır.",
          "examples": [
            "Örnekle Pekiştirelim: Tescil başvurusu yapılan yeni acente logosunun Resmi Marka Bülteni'nde yayınlanarak 2 ay boyunca itiraza açık tutulması."
          ]
        },
        {
          "name": "Rüçhan Hakkı (Öncelik Hakkı)",
          "desc": "Bir ülkede yapılan ilk resmi patent veya marka başvurusunun, 12 ay (patente) veya 6 ay (marka) içinde diğer ülkelerde yapılacak başvurular için tarih önceliği sağlamasıdır.",
          "examples": [
            "Örnekle Pekiştirelim: Türkiye'de 1 Ocak'ta marka başvurusu yapan otelin, 6 ay içinde Avrupa'da başvurduğunda 1 Ocak tarihli önceliğini koruması."
          ]
        },
        {
          "name": "Hukuki Yaptırımlar ve İhtarname",
          "desc": "Hak sahibinin izinsiz kullanımda noter kanalıyla 'Marka ihlalini durdur' ihtarnamesi çekmesi, mahkemeden ürünlerin toplatılması ve maddi-manevi tazminat talep etmesidir.",
          "examples": [
            "Örnekle Pekiştirelim: Sahte forma veya tabela kullanan işletmenin mallarına polisle el konulması ve tabelanın söktürülmesi."
          ]
        }
      ],
      "caseStudy": {
        "title": "Sektörden Vaka: Noter İhtarnamesiyle Çözülen Tabela Krizi",
        "story": "Marmaris'te tescilli bir acentenin tabelasındaki logonun aynısını komşu beldede açılan yeni bir acente tabelasına astı.",
        "solution": "Tescilli acente avukatı aracılığıyla noterden resmi ihtarname çekti. Karşı taraf mahkeme tazminatından korkarak tabelayı 3 gün içinde değiştirdi ve kriz çözüldü."
      },
      "tip": "Bir ihlalle karşılaştığınızda ilk resmi adım noterden 'İhtarname' çekmektir. İhtarname çoğu zaman mahkemeye gitmeden sorunu en hızlı çözen araçtır."
    }
  ]
};

// ==========================================
// 7. ÖĞRENME BİRİMİ: TEKNOLOJİK GELİŞMELER VE ENDÜSTRİYEL DÖNÜŞÜM
// ==========================================
const Map<String, dynamic> meslekiGelisimUnit7 = {
  "title": "Teknolojik Gelişmeler ve Endüstriyel Dönüşüm",
  "learningUnit": "7. Öğrenme Birimi",
  "podcastUrl": "https://anchor.fm/s/114a64400/podcast/play/126372378/https%3A%2F%2Fd3ctxlq1ktw2nl.cloudfront.net%2Fstaging%2F2026-8-27%2F2742fad6-06b4-f898-0f78-1565c7f5430f.mp3",
  "cards": [
    {
      "id": 1,
      "tag": "SANAYİ DEVRİMLERİ",
      "title": "SANAYİ DEVRİMLERİNİN EVRİMİ (1.0'DAN 4.0'A)",
      "microSummary": "Buhar gücüyle başlayan sanayi devrimleri; elektrik, bilgisayar ve nihayet siber-fiziksel sistemler (Endüstri 4.0) ile üretim ve hizmeti kökten dönüştürmüştür.",
      "definitions": [
        {
          "name": "Endüstri 1.0 ve 2.0 Dönemleri",
          "desc": "Endüstri 1.0 (18. yy sonu): Buhar gücü ve mekanik dokuma tezgahları. Endüstri 2.0 (20. yy başı): Elektrik enerjisi, seri üretim bantları ve iş bölümü.",
          "examples": [
            "Örnekle Pekiştirelim: Buharlı trenlerin icadıyla ilk kitle turizminin başlaması 1.0; Henry Ford'un seri otomobil üretimi 2.0 devrimidir."
          ]
        },
        {
          "name": "Endüstri 3.0 (Dijital Devrim)",
          "desc": "20. yüzyılın ikinci yarısında bilgisayarların, internetin, mikroelektroniklerin ve programlanabilir mantıksal denetleyicilerin (PLC) üretime girmesidir.",
          "examples": [
            "Örnekle Pekiştirelim: Otellerin daktilo ve defterle rezervasyon tutmaktan bilgisayarlı otel otomasyon sistemlerine geçmesi."
          ]
        },
        {
          "name": "Endüstri 4.0 (Akıllı Fabrikalar ve Siber Sistemler)",
          "desc": "Fiziksel makinelerin siber ağlarla bağlandığı, Nesnelerin İnterneti (IoT), Büyük Veri, Bulut Bilişim ve yapay zekanın otonom kararlar aldığı çağdır.",
          "examples": [
            "Örnekle Pekiştirelim: Bir akıllı otelde odadaki sensörlerin misafirin çıktığını anlayıp klimayı kapatması ve kat görevlisinin tabletine 'Oda boşaldı, temizliğe hazır' bildirimi göndermesi."
          ]
        }
      ],
      "caseStudy": {
        "title": "Sektörden Vaka: Otel Odalarında Uçtan Uca Endüstri 4.0 Entegrasyonu",
        "story": "Geleneksel bir resort otelde klima, aydınlatma ve su ısıtıcıları sürekli açık unutulduğu için yıllık enerji kaybı milyonlarca lirayı buluyordu.",
        "solution": "IoT tabanlı merkezi otomasyona geçildi. Giriş-çıkış kartı, hareket sensörleri ve akıllı termostatlar birbirine bağlandı; otel enerji tüketimini %35 düşürürken misafir konforunu artırdı."
      },
      "tip": "Endüstri 4.0'ın kalbi 'Bağlanabilirlik (Connectivity)' ve 'Veri'dir. Cihazlar birbiriyle konuşur ve insan müdahalesine gerek kalmadan karar alır."
    },
    {
      "id": 2,
      "tag": "TOPLUM 5.0",
      "title": "ENDÜSTRİ 5.0 VE TOPLUM 5.0 VİZYONU",
      "microSummary": "Endüstri 5.0; teknolojiyi insanın yerine değil, insan refahı, sürdürülebilirlik ve insan-robot iş birliği (Cobot) merkezine koyan yeni insani üretim modelidir.",
      "definitions": [
        {
          "name": "Endüstri 5.0 ve İnsan Odaklılık",
          "desc": "Endüstri 4.0'ın salt verimlilik ve otomasyon odaklı soğuk yapısını aşarak; insanın yaratıcılığını, zanaatını ve empatisini yapay zekayla birleştiren modeldir.",
          "examples": [
            "Örnekle Pekiştirelim: Ağır temizlik ve çamaşır taşıma işlerini robotların yapması; personelin ise misafirle birebir ilgilenip kişiye özel ağırlama sunması."
          ]
        },
        {
          "name": "Toplum 5.0 (Süper Akıllı Toplum)",
          "desc": "Japonya'da ortaya atılan; avcı toplum, tarım toplumu, sanayi toplumu ve bilgi toplumundan sonra gelen, dijitalleşmeyi sosyal eşitsizlikleri çözmek için kullanan insan merkezli toplumdur.",
          "examples": [
            "Örnekle Pekiştirelim: Engelli bireylerin dışarı çıkmadan sanal gerçeklik ve telepresence robotlarla müzeleri gezebilmesi ve eğitim alabilmesi."
          ]
        },
        {
          "name": "İş Birlikçi Robotlar (Cobot)",
          "desc": "Kafesler arkasında değil; insan çalışanla yan yana, güvenli sensörlerle donatılmış, insanı destekleyen yeni nesil akıllı robotlardır.",
          "examples": [
            "Örnekle Pekiştirelim: Otel mutfağında aşçının yanında durup tepsileri fırına süren ve aşçının el hareketine uyum sağlayan robotik kol."
          ]
        }
      ],
      "caseStudy": {
        "title": "Sektörden Vaka: Robot Barmen ile İnsani Sıcaklığın Birleşimi",
        "story": "Lüks bir kruvaziyer gemisinde robot barmen kokteylleri 10 saniyede hatasız karıştırıyordu ancak yolcular bir süre sonra sohbet edemedikleri için sıkıldı.",
        "solution": "Gemi yönetimi robot barmeni içecek hazırlama asistanı yaptı; kokteylleri robot hazırlarken uzman insan barmen yolcularla sohbet edip hikayeler anlattı. Memnuniyet zirveye çıktı."
      },
      "tip": "Endüstri 5.0 robotların insanı işsiz bırakması değil; rutin işleri robotlara devredip insanın 'akıl, estetik ve empati' gerektiren işlere odaklanmasıdır."
    },
    {
      "id": 3,
      "tag": "ÇALIŞMA MODELLERİ",
      "title": "YENİ NESİL ESNEK ÇALIŞMA VE DİJİTAL GÖÇEBELİK",
      "microSummary": "Bulut sistemler ve dijital iletişim; mekândan bağımsız uzaktan çalışma, hibrit model ve dijital göçebelik (digital nomad) trendini doğurmuştur.",
      "definitions": [
        {
          "name": "Uzaktan (Remote) ve Hibrit Çalışma",
          "desc": "Uzaktan çalışma işin tamamen ofis dışından yürütülmesidir. Hibrit çalışma ise haftanın belirli günleri ofiste, belirli günleri evde veya herhangi bir mekanda çalışmayı ifade eder.",
          "examples": [
            "Örnekle Pekiştirelim: Bir seyahat acentesi satış danışmanının haftanın 2 günü ofiste, 3 günü evinden bilgisayarla rezervasyon alması."
          ]
        },
        {
          "name": "Dijital Göçebelik (Digital Nomad)",
          "desc": "Sadece bir dizüstü bilgisayar ve internet bağlantısıyla dünyanın herhangi bir yerinden çalışan ve sürekli seyahat eden yeni nesil çalışan profilidir.",
          "examples": [
            "Örnekle Pekiştirelim: Bir yazılımcının kışın Fethiye'deki bir otelde konaklayarak Londra'daki şirketine uzaktan yazılım geliştirmesi."
          ]
        },
        {
          "name": "Serbest Çalışma (Freelance) ve Gig Ekonomisi",
          "desc": "Tek bir şirkete bağlı olmadan, proje veya görev bazlı geçici sözleşmelerle çalışanların oluşturduğu esnek serbest çalışanlar ekonomisidir.",
          "examples": [
            "Örnekle Pekiştirelim: Bir turizm rehberinin veya grafik tasarımcının farklı şirketlere dışarıdan proje bazlı fatura keserek çalışması."
          ]
        }
      ],
      "caseStudy": {
        "title": "Sektörden Vaka: Otellerin Dijital Göçebelere Özel Dönüşümü",
        "story": "Kışın doluluğu %20'ye düşen Muğla'daki bir sahil oteli kapanma tehlikesiyle karşı karşıya kaldı.",
        "solution": "Otel yüksek hızlı fiber internet, sessiz çalışma kabinleri ve sınırsız kahve istasyonları kurarak 'Digital Nomad Çalışma ve Konaklama Paketi' başlattı. Kışın 100'den fazla uzaktan çalışan yazılımcı otele yerleşti; tesis 12 ay doldu."
      },
      "tip": "Geleceğin çalışma hayatında nerede oturduğunuz değil; internet üzerinden hangi katma değeri ürettiğiniz ve zamanı nasıl yönettiğiniz belirleyicidir."
    },
    {
      "id": 4,
      "tag": "YIKICI TEKNOLOJİLER",
      "title": "YAPAY ZEKÂ, NESNELERİN İNTERNETİ VE BÜYÜK VERİ",
      "microSummary": "Yapay zekâ karar alma süreçlerini otomatikleştirir, IoT nesneleri birbirine bağlar, Büyük Veri ise misafir tercihlerini önceden tahmin eder.",
      "definitions": [
        {
          "name": "Yapay Zekâ (AI) ve Makine Öğrenmesi",
          "desc": "Bilgisayar sistemlerinin insan zekasına benzer şekilde öğrenme, akıl yürütme, problem çözme ve karar verme yetenekleriyle donatılmasıdır.",
          "examples": [
            "Örnekle Pekiştirelim: Otel rezervasyon sistemindeki yapay zeka chatbot'unun misafirlerin sorularını 50 dilde 7/24 anında yanıtlayıp oda satması."
          ]
        },
        {
          "name": "Nesnelerin İnterneti (IoT)",
          "desc": "Fiziksel cihazların, araçların ve binaların sensörler ve yazılımlarla internete bağlanarak birbirleriyle veri alışverişi yapabilmesidir.",
          "examples": [
            "Örnekle Pekiştirelim: Otel minibarlarındaki akıllı ağırlık sensörlerinin tüketilen içeceği resepsiyon faturasına anında otomatik işlemesi."
          ]
        },
        {
          "name": "Büyük Veri (Big Data) ve Analitiği",
          "desc": "Geleneksel yöntemlerle işlenemeyecek büyüklükteki, çeşitli ve hızlı akan verilerin analiz edilerek stratejik kararlar üretilmesidir (Hacim, Hız, Çeşitlilik).",
          "examples": [
            "Örnekle Pekiştirelim: Geçmiş 10 yılın uçuş ve otel arama verilerini analiz eden bir algoritmanın bayram dönemi için en karlı bilet fiyatını belirlemesi."
          ]
        }
      ],
      "caseStudy": {
        "title": "Sektörden Vaka: Büyük Veriyle Kişiye Özel Karşılama",
        "story": "Bir otel zinciri, misafirin daha önce diğer şubelerde tercih ettiği yastık tipini ve kahve tercihini merkezi büyük veri sistemine kaydetti.",
        "solution": "Misafir 2 yıl sonra bambaşka bir ülkedeki otele adım attığında odasında en sevdiği kaz tüyü yastık ve şekersiz filtre kahve hazır bekliyordu. Misafir bu kişiselleştirilmiş sadakatten büyülenerek otele bağlandı."
      },
      "tip": "Büyük Veri ham petroldür; onu işleyip anlamlı bilgiye (insight) dönüştürmedikçe hiçbir değeri yoktur."
    },
    {
      "id": 5,
      "tag": "DİJİTAL GELECEK",
      "title": "BLOKZİNCİR, SANAL GERÇEKLİK VE DİJİTAL İKİZLER",
      "microSummary": "Blokzincir güvenli işlem sağlar, VR/AR deneyimi zenginleştirir, Dijital İkiz ise fiziksel tesislerin dijital kopyasıyla simülasyon imkanı sunar.",
      "definitions": [
        {
          "name": "Blokzincir (Blockchain) ve Akıllı Sözleşmeler",
          "desc": "Verilerin merkezi olmayan, şifreli ve değiştirilemez bloklar halinde saklandığı dağıtık kayıt teknolojisidir. Aracısız güvenli transfer sağlar.",
          "examples": [
            "Örnekle Pekiştirelim: Turistlerin uçak bileti ve otel rezervasyonlarını aracı komisyoncular olmadan doğrudan akıllı sözleşmeyle güvenle alması."
          ]
        },
        {
          "name": "Sanal (VR) ve Artırılmış Gerçeklik (AR)",
          "desc": "VR: Kullanıcıyı tamamen bilgisayar yapımı yapay bir dünyaya sokar. AR: Gerçek dünyanın üzerine dijital bilgi, 3D nesne ve animasyon giydirir.",
          "examples": [
            "Örnekle Pekiştirelim: Efes Antik Kenti'ni gezen bir turistin AR gözlüğü taktığında harabelerin 2000 yıl önceki mermer sütunlu halini canlı olarak görmesi."
          ]
        },
        {
          "name": "Dijital İkiz (Digital Twin)",
          "desc": "Fiziksel bir tesisin, makinenin veya sürecin sensörlerden beslenen birebir dinamik sanal kopyasıdır. Arızaları önceden tahmin eder.",
          "examples": [
            "Örnekle Pekiştirelim: Havalimanının dijital ikizinde bagaj taşıma simülasyonu yaparak yoğun saatlerde bagaj sıkışmasını önceden çözmek."
          ]
        }
      ],
      "caseStudy": {
        "title": "Sektörden Vaka: VR ile Önceden Gezilen Otel Odası Satışları",
        "story": "Büyük bir tur operatörü fuarda ziyaretçi ve misafirlere broşür dağıtmak yerine VR gözlükler taktırarak Maldivler'deki su üstü villalarını sanal olarak gezdirdi.",
        "solution": "Misafirler odanın balkonundan denize bakma deneyimini birebir yaşayınca satış kapatma oranı %400 arttı; teknoloji satışı deneyime dönüştürdü."
      },
      "tip": "Geleceğin turizm ve hizmet sektöründe rekabet; fiziksel ürün satanlar ile zenginleştirilmiş dijital deneyim sunanlar arasında yaşanacaktır."
    }
  ]
};

// ==========================================
// 8. ÖĞRENME BİRİMİ: İNOVASYONLA ÖĞRENME ALIŞKANLIKLARINI DÖNÜŞTÜRME
// ==========================================
const Map<String, dynamic> meslekiGelisimUnit8 = {
  "title": "İnovasyonla Öğrenme Alışkanlıklarını Dönüştürme",
  "learningUnit": "8. Öğrenme Birimi",
  "podcastUrl": "https://anchor.fm/s/114a64400/podcast/play/126372518/https%3A%2F%2Fd3ctxlq1ktw2nl.cloudfront.net%2Fstaging%2F2026-8-27%2F8ae7f156-ba37-3062-245d-b15aaa60fcf2.mp3",
  "cards": [
    {
      "id": 1,
      "tag": "ÖĞRENME YAKLAŞIMLARI",
      "title": "GELENEKSEL VE YENİLİKÇİ ÖĞRENME YAKLAŞIMLARI",
      "microSummary": "Öğrenme artık öğretmenden pasif bilgi aktarımı değil; öğrencinin yaparak, yaşayarak ve deneyimleyerek kendi bilgisini inşa ettiği aktif bir süreçtir.",
      "definitions": [
        {
          "name": "Geleneksel Öğrenme Modeli",
          "desc": "Öğretmen merkezli, ezbere dayalı, sınıf duvarlarıyla sınırlı, pasif dinleme ve standart sınav odaklı klasik öğrenme yaklaşımıdır.",
          "examples": [
            "Örnekle Pekiştirelim: Öğretmenin tahtada anlattığı otel kurallarını öğrencinin deftere yazıp ezberlemesi geleneksel yaklaşımdır."
          ]
        },
        {
          "name": "Yenilikçi (Çağdaş) Öğrenme Modeli",
          "desc": "Öğrenci merkezli, beceri ve deneyim odaklı, problem çözme ve araştırmayı merkeze alan, esnek ve dijital destekli öğrenme yaklaşımıdır.",
          "examples": [
            "Örnekle Pekiştirelim: Öğrencilerin otel simülasyon atölyesinde bizzat resepsiyon yazılımını kullanarak kriz senaryosu çözmesi yenilikçi yaklaşımdır."
          ]
        },
        {
          "name": "Yaşam Boyu Öğrenme (Lifelong Learning)",
          "desc": "Öğrenmenin okul dönemiyle bitmeyip; bireyin kişisel, toplumsal ve mesleki gelişimi için hayat boyu sürekli bilgi ve beceri edinme sürecidir.",
          "examples": [
            "Örnekle Pekiştirelim: 45 yaşındaki bir aşçıbaşının gastronomi trendlerini takip etmek için moleküler mutfak online sertifika programına katılması."
          ]
        }
      ],
      "caseStudy": {
        "title": "Sektörden Vaka: Ezberden Simülasyonla Öğrenmeye Geçiş",
        "story": "Bir turizm lisesinde yangın prosedürlerini kitaptan ezberleyen öğrenciler, gerçek bir duman kokusunda paniğe kapılarak doğru söndürücüyü seçemedi.",
        "solution": "Okul VR yangın simülasyonu getirdi. Öğrenciler sanal alevlere onlarca kez bizzat müdahale ederek refleks kazandı; acil durum eylem yetkinliği %100'e ulaştı."
      },
      "tip": "Bana söylersen unuturum, gösterirsen hatırlarım, beni dahil edersen öğrenirim. Yenilikçi öğrenmenin temeli 'bizzat dahil olmaktır'."
    },
    {
      "id": 2,
      "tag": "21. YÜZYIL BECERİLERİ",
      "title": "21. YÜZYIL YETKİNLİKLERİ VE 4C KURALI",
      "microSummary": "Günümüz iş dünyası ezberlenmiş bilgiler yerine 4C becerilerini arar: Eleştirel düşünme, yaratıcılık, iletişim ve iş birliği.",
      "definitions": [
        {
          "name": "4C Becerileri",
          "desc": "Critical Thinking (Eleştirel Düşünme/Sorgulama), Creativity (Yaratıcılık), Communication (İletişim) ve Collaboration (İş Birliği/Takım Çalışması).",
          "examples": [
            "Örnekle Pekiştirelim: Bir misafir şikayetinde kalıplaşmış bahaneler sunmak yerine sorunun kök nedenini sorgulayıp (Critical Thinking) ekiple birlikte yeni bir servis çözümü geliştirmek (Collaboration)."
          ]
        },
        {
          "name": "Eleştirel Düşünme ve Problem Çözme",
          "desc": "Bilgiyi körü körüne kabul etmeyip doğruluğunu kanıtlarla sorgulama, önyargılardan arınma ve karmaşık sorunlara akılcı çözümler üretme yetisidir.",
          "examples": [
            "Örnekle Pekiştirelim: 'Bu iş hep böyle yapılırdı' sözüne takılmayıp 'Daha hızlı ve hatasız nasıl yapabiliriz?' sorusunu sormak."
          ]
        },
        {
          "name": "Dijital ve Medya Okuryazarlığı",
          "desc": "Dijital araçları etkin kullanabilme, internetteki bilgi kirliliğini ayırt edebilme ve dijital etik kurallara uygun içerik üretebilme becerisidir.",
          "examples": [
            "Örnekle Pekiştirelim: Sosyal medyadaki sahte bir turizm haberinin doğruluğunu resmi kaynaklardan teyit etmeden paylaşmamak."
          ]
        }
      ],
      "caseStudy": {
        "title": "Sektörden Vaka: Takım Çalışmasıyla Kurtarılan Ziyafet",
        "story": "500 kişilik bir gala yemeğinde elektrikler kesildi ve ana yemek fırınları durdu. Salon ekibi tek başına çaresiz kaldı.",
        "solution": "Mutfak, servis ve teknik ekip 4C iş birliğiyle (Collaboration) anında soğuk meze ve canlı müzik eşliğinde şamdanlı bir 'Mum Işığında Akdeniz Gecesi' konsepti üretti. Misafirler bunu planlı bir sürpriz sandı ve alkışladı."
      },
      "tip": "Teknoloji rutin işleri robotlara yaptırabilir; ancak yaratıcılık, empati ve takım çalışması (4C) daima insana özgü kalacaktır."
    },
    {
      "id": 3,
      "tag": "YETKİNLİK DÖNÜŞÜMÜ",
      "title": "YETKİNLİK DÖNÜŞÜMÜ: RESKILLING VE UPSKILLING",
      "microSummary": "İş dünyasının hızla değişen ihtiyaçlarına uyum sağlamak için mevcut becerileri geliştirmek upskilling, tamamen yeni mesleki beceriler kazanmak reskilling'dir.",
      "definitions": [
        {
          "name": "Upskilling (Mevcut Becerileri Yükseltme)",
          "desc": "Çalışanın mevcut yaptığı işte daha yetkin, uzman ve dijital araçlarla donanımlı hale gelmesi için becerilerini güncellemesidir.",
          "examples": [
            "Örnekle Pekiştirelim: Bir muhasebecinin geleneksel Excel yerine yapay zeka destekli veri analitiği ve Power BI yazılımını öğrenmesi."
          ]
        },
        {
          "name": "Reskilling (Yeni Beceri Edinme / Yeniden Becerilendirme)",
          "desc": "Teknoloji nedeniyle kaybolan veya dönüşen bir meslekten çıkıp tamamen farklı ve talep gören yeni bir alana geçmek için yeni beceriler kazanmaktır.",
          "examples": [
            "Örnekle Pekiştirelim: Otomasyon nedeniyle işi azalan bir biletleme memurunun siber güvenlik veya dijital turizm pazarlaması eğitimi alarak kariyer değiştirmesi."
          ]
        },
        {
          "name": "Bilişsel Esneklik ve Öğrenmeyi Öğrenme",
          "desc": "Yeni durumlara hızla adapte olabilme, eskiyen yanlış bilgileri zihinden silme (unlearn) ve yeni bilgileri hızla özümseme (relearn) becerisidir.",
          "examples": [
            "Örnekle Pekiştirelim: Yeni çıkan bir yazılıma karşı 'Ben bunu öğrenemem' demek yerine merakla kurcalayıp 3 günde uzmanlaşmak."
          ]
        }
      ],
      "caseStudy": {
        "title": "Sektörden Vaka: Reskilling İle Kariyerini Kurtaran Seyahat Acentesi Ekibi",
        "story": "Online rezervasyon portalları yüzünden ofiste uçak bileti kesen 10 personelin işi gereksiz hale geldi.",
        "solution": "Acente personeli işten çıkarmak yerine onlara 3 aylık 'Kişiselleştirilmiş Lüks Deneyim Danışmanlığı' eğitimi verdi (Reskilling). Ekip zengin misafirlere özel helikopter ve gurme turlar satmaya başlayarak ciroyu katladı."
      },
      "tip": "21. yüzyılın cahilleri okuma yazma bilmeyenler değil; öğrenemeyen, öğrendiği yanlışı terk edemeyen (unlearn) ve yeniden öğrenemeyen (relearn) kişilerdir."
    },
    {
      "id": 4,
      "tag": "MODERN ÖĞRENME MODELLERİ",
      "title": "HARMANLANMIŞ ÖĞRENME VE TERS YÜZ SINIF (FLIPPED CLASSROOM)",
      "microSummary": "Ters yüz sınıf modelinde teorik konu evde videodan izlenir; okulda ise sadece tartışma, uygulama ve proje yapılır.",
      "definitions": [
        {
          "name": "Harmanlanmış Öğrenme (Blended Learning)",
          "desc": "Geleneksel yüz yüze sınıf ortamı ile dijital/çevrim içi öğrenme araçlarının pedagojik olarak harmanlandığı hibrit öğrenme modelidir.",
          "examples": [
            "Örnekle Pekiştirelim: Haftanın 3 günü okul atölyesinde uygulama yaparken, 2 günü mobil uygulama üzerinden ders videoları ve testleri çözmek."
          ]
        },
        {
          "name": "Ters Yüz Edilmiş Sınıf (Flipped Classroom)",
          "desc": "Geleneksel ders-ödev ilişkisini tersine çeviren modeldir. Öğrenci konunun teorik videosunu evde izler; sınıfa geldiğinde ödev yapmak yerine atölyede uygulama yapar.",
          "examples": [
            "Örnekle Pekiştirelim: Kokteyl tariflerini evde videodan izleyip öğrenen öğrencinin, sınıfa geldiğinde zaman kaybetmeden doğrudan bar tezgahında kokteyli hazırlaması."
          ]
        },
        {
          "name": "Mikro Öğrenme (Microlearning)",
          "desc": "Bilgilerin 2 ila 5 dakikalık kısa, hap, odaklanmış video veya kartlar halinde parça parça sunulduğu modern öğrenme yöntemidir.",
          "examples": [
            "Örnekle Pekiştirelim: Servis kurallarını 40 dakikalık uzun ders yerine 3 dakikalık 'Kadeh Nasıl Tutulur?' kısa videolarıyla öğrenmek."
          ]
        }
      ],
      "caseStudy": {
        "title": "Sektörden Vaka: Flipped Classroom ile Resepsiyon Eğitimi",
        "story": "Bir otel yeni stajyerlere resepsiyon programını sınıfta 2 hafta teorik anlattı ancak stajyerler sisteme geçince her şeyi unuttuklarını söyledi.",
        "solution": "Ters yüz sınıfa geçildi. Stajyerler 3'er dakikalık ekran kayıtlarını evde izledi; sınıfta ise yalnızca zorlu misafir senaryoları simüle edildi. Öğrenme süresi yarı yarıya kısaldı."
      },
      "tip": "Sınıf dinleme yeri değil; uygulama, tartışma ve soru sorma yeridir. Teoriyi dijitalden alın, atölyede pratiğe dökün!"
    },
    {
      "id": 5,
      "tag": "KİŞİSEL ÖĞRENME ROTASI",
      "title": "KİŞİSEL ÖĞRENME AĞI (PLN) VE DİJİTAL ÖĞRENME EKOSİSTEMLERİ",
      "microSummary": "Her bireyin öğrenme hızı ve ilgi alanı farklıdır; açık kaynaklar ve MOOC platformlarıyla birey kendi kişisel öğrenme rotasını çizebilir.",
      "definitions": [
        {
          "name": "Kişisel Öğrenme Rotası",
          "desc": "Bireyin kendi kariyer hedeflerine, güçlü yönlerine ve eksiklerine göre hangi eğitimleri, hangi sırayla ve hangi araçlarla alacağını planlamasıdır.",
          "examples": [
            "Örnekle Pekiştirelim: 'Ön büro müdürü olmak istiyorum' diyen bir öğrencinin sırasıyla İleri Düzey İngilizce, Çatışma Yönetimi ve Gelir Yönetimi (Revenue) kurslarını planlaması."
          ]
        },
        {
          "name": "Kitlesel Açık Çevrim İçi Kurslar (MOOC)",
          "desc": "Dünyanın en prestijli üniversitelerinin ve kurumlarının herkese açık, ücretsiz veya düşük ücretli online eğitim platformlarıdır (Coursera, edX vb.).",
          "examples": [
            "Örnekle Pekiştirelim: Meslek lisesi öğrencisinin evinden Lozan Otelcilik Okulu'nun ücretsiz çevrim içi konuk/misafir ilişkileri sertifika programını tamamlaması."
          ]
        },
        {
          "name": "Kişisel Öğrenme Ağı (PLN - Personal Learning Network)",
          "desc": "Bireyin bilgi alışverişinde bulunduğu uzmanlar, meslektaşlar, bloglar, podcast'ler ve topluluklardan oluşan profesyonel dijital bilgi ağıdır.",
          "examples": [
            "Örnekle Pekiştirelim: LinkedIn üzerinden otel genel müdürlerini takip etmek, turizm podcast'leri dinlemek ve sektörel forumlara katılmak."
          ]
        }
      ],
      "caseStudy": {
        "title": "Sektörden Vaka: Kendi Rotasını Çizen Stajyerin Yükselişi",
        "story": "Bir meslek lisesi öğrencisi sadece okul dersleriyle yetinmeyip ücretsiz online platformlardan 'Dijital Turizm Pazarlaması' ve 'Veri Analizi' sertifikaları aldı.",
        "solution": "Staj yaptığı otelin sosyal medya analizindeki büyük bir açığı çözerek doluluğu artırdı; mezun olur olmaz otelin en genç Dijital Pazarlama Sorumlusu olarak işe alındı."
      },
      "tip": "Diplomanız işe giriş biletinizdir; ancak sizi orada tutacak ve yükseltecek olan kendi kendinize kurduğunuz yaşam boyu öğrenme alışkanlığınızdır."
    }
  ]
};

// ==========================================
// 9. ÖĞRENME BİRİMİ: YEŞİL DÖNÜŞÜM, DİJİTAL DÖNÜŞÜM VE İKİZ DÖNÜŞÜM
// ==========================================
const Map<String, dynamic> meslekiGelisimUnit9 = {
  "title": "Yeşil Dönüşüm, Dijital Dönüşüm ve İkiz Dönüşüm",
  "learningUnit": "9. Öğrenme Birimi",
  "podcastUrl": "https://anchor.fm/s/114a64400/podcast/play/126372556/https%3A%2F%2Fd3ctxlq1ktw2nl.cloudfront.net%2Fstaging%2F2026-8-27%2F678cbfcc-727b-188d-1aab-aa92ace76ec3.mp3",
  "cards": [
    {
      "id": 1,
      "tag": "İKİZ DÖNÜŞÜM KAVRAMI",
      "title": "YEŞİL, DİJİTAL VE İKİZ DÖNÜŞÜM (TWIN TRANSITION)",
      "microSummary": "İkiz dönüşüm; dijitalleşmenin sağladığı teknolojik güç ile yeşil dönüşümün sürdürülebilirlik hedeflerinin eş zamanlı olarak entegre edilmesidir.",
      "definitions": [
        {
          "name": "İkiz Dönüşüm (Twin Transition) Nedir?",
          "desc": "Yeşil dönüşüm (çevre, iklim, sıfır karbon) ile dijital dönüşümün (yapay zeka, IoT, büyük veri) birbirinden ayrı değil, birbirini besleyen iki kanat olarak yürütülmesidir.",
          "examples": [
            "Örnekle Pekiştirelim: Bir otelin enerji tasarrufu yapabilmek için (Yeşil) odalara yapay zekalı IoT sensörler yerleştirmesi (Dijital) kusursuz bir İkiz Dönüşümdür."
          ]
        },
        {
          "name": "Yeşil Dönüşümün Boyutları",
          "desc": "Fosil yakıtlardan çıkış, kaynak verimliliği, biyoçeşitliliğin korunması, döngüsel üretim ve 2050 net sıfır karbon vizyonudur.",
          "examples": [
            "Örnekle Pekiştirelim: İşletmenin tüm araç filosunu elektrikli araçlarla değiştirmesi ve otel arazisinde güneş şarj istasyonları kurması."
          ]
        },
        {
          "name": "Dijital Dönüşümün Yeşil Amaca Hizmeti",
          "desc": "Dijital teknolojilerin çevreyi kirletmek yerine; enerji tüketimini optimize eden, atığı dijital haritalayan ve kaynak israfını önleyen bir kaldıraç olmasıdır.",
          "examples": [
            "Örnekle Pekiştirelim: Kağıt fatura ve broşür kullanımını tamamen kaldırıp misafir işlemlerini mobil karekod ve bulut sistemle yönetmek."
          ]
        }
      ],
      "caseStudy": {
        "title": "Sektörden Vaka: Açık Büfe İsrafını Önleyen Yapay Zeka Kamerası",
        "story": "Her şey dahil bir resort otelde açık büfeden her gün yüzlerce kilo kaliteli yemek çöpe gidiyor, hem maliyet hem çevre felaketi yaşanıyordu.",
        "solution": "Mutfak çöp kovalarının üzerine yapay zekalı görüntü işleme kameraları konuldu (İkiz dönüşüm). Kamera atılan yiyecekleri tanıdı; hangi yemeğin fazla çıktığı analiz edildi. Menü porsiyonları optimize edildi, gıda israfı %60 azaldı ve otel yılda 400.000 TL tasarruf etti."
      },
      "tip": "Dijitalleşme tek başına amaç değil araçtır; bu aracın nihai hedefi gezegenimizi daha yaşanabilir ve sürdürülebilir kılmaktır (İkiz Dönüşüm)."
    },
    {
      "id": 2,
      "tag": "YEŞİL VE DİJİTAL İSTİHDAM",
      "title": "İKİZ DÖNÜŞÜMÜN İŞ GÜCÜ PİYASASI VE MESLEKLERE ETKİSİ",
      "microSummary": "İkiz dönüşüm yeni beceri setlerini zorunlu kılar; hem dijital araçları kullanan hem çevre bilinci yüksek 'Yeşil Yakalı' profesyoneller geleceğin lideridir.",
      "definitions": [
        {
          "name": "Yeşil Yakalı Meslekler",
          "desc": "Çevrenin korunmasına, enerji verimliliğine, karbon ayak izinin azaltılmasına ve döngüsel ekonomiye doğrudan katkı sağlayan yeni nesil uzmanlıklardır.",
          "examples": [
            "Örnekle Pekiştirelim: Sürdürülebilirlik Yöneticisi, Enerji Verimliliği Uzmanı, Karbon Denetçisi ve Yeşil Satın Alma Sorumlusu."
          ]
        },
        {
          "name": "Adil Geçiş (Just Transition) İlkesi",
          "desc": "Yeşil ve dijital dönüşüm sürecinde eski sektörlerde çalışan işçilerin mağdur edilmeden, yeni beceriler kazandırılarak istihdama dahil edilmesidir.",
          "examples": [
            "Örnekle Pekiştirelim: Kömür santralinde çalışan teknisyenlerin rüzgar türbini ve güneş paneli bakım teknisyenliğine eğitilerek transfer edilmesi."
          ]
        },
        {
          "name": "Karma (Hibrit) Beceri Seti",
          "desc": "Geleceğin çalışanından beklenen; bir yandan yazılım, veri ve yapay zekayı anlama, diğer yandan ekolojik ilkeleri ve etik değerleri uygulama kabiliyetidir.",
          "examples": [
            "Örnekle Pekiştirelim: Bir aşçının sadece lezzetli yemek pişirmesi değil; yerel coğrafi işaretli ürünleri seçmesi, karbon ayak izi düşük menü tasarlaması ve mutfak yazılımını kullanabilmesi."
          ]
        }
      ],
      "caseStudy": {
        "title": "Sektörden Vaka: Otelin İlk 'Sürdürülebilirlik Şefi' Ataması",
        "story": "Büyük bir otel grubu, uluslararası tur operatörlerinin 'Sürdürülebilirlik kriterlerini sağlamayan otellerle çalışmayacağız' ültimatomuyla karşılaştı.",
        "solution": "Otel bünyesinde 'İkiz Dönüşüm Ofisi' kurdu. Genç bir turizmciyi çevre ve veri analitiği eğitimiyle donatarak Sürdürülebilirlik Şefi yaptı. Tesis GSTC (Küresel Sürdürülebilir Turizm Konseyi) sertifikası alarak uluslararası pazarını korudu."
      },
      "tip": "Gelecekte iki tür çalışan olacak: Teknolojiyi sürdürülebilirlik için kullananlar ve oyundan çıkanlar. Yeşil ve dijital becerileri birleştiren vazgeçilmez olur."
    },
    {
      "id": 3,
      "tag": "KAYNAK VERİMLİLİĞİ",
      "title": "İŞ SÜREÇLERİNDE DİJİTAL KAYNAK VERİMLİLİĞİ",
      "microSummary": "İş süreçlerinde dijitalleşme; kağıtsız ofis, sensörlü kaynak kontrolü ve bulut tabanlı izleme ile maliyetleri düşürürken doğayı korur.",
      "definitions": [
        {
          "name": "Akıllı Binalar ve Tesis Yönetimi",
          "desc": "Aydınlatma, ısıtma, havalandırma ve su sistemlerinin bina yönetim sistemi (BMS) yazılımlarıyla otomatik optimize edildiği yapılardır.",
          "examples": [
            "Örnekle Pekiştirelim: Otel koridorlarında kimse yokken ışıkların %20 loş moda geçmesi, hareket algılandığında %100 yanması."
          ]
        },
        {
          "name": "Kağıtsız Ofis (Paperless Office)",
          "desc": "Tüm formların, onayların, faturaların ve yazışmaların dijital imza ve tabletler üzerinden yürütülerek kağıt israfının sıfırlanmasıdır.",
          "examples": [
            "Örnekle Pekiştirelim: Ön büroda misafire kağıt kayıt kartı doldurtmak yerine tablet üzerinden dijital imza alınıp e-posta ile onay gönderilmesi."
          ]
        },
        {
          "name": "Dijital Su ve Enerji İzleme Sayaçları",
          "desc": "Ana boru hatlarına yerleştirilen IoT sensörleriyle borulardaki en küçük sızıntıyı veya olağandışı basınç düşüşünü anında tespit eden sistemlerdir.",
          "examples": [
            "Örnekle Pekiştirelim: Toprak altındaki gizli su borusu patlağını sistemin anında fark edip suyu otomatik kesmesi ve tonlarca su kaybını önlemesi."
          ]
        }
      ],
      "caseStudy": {
        "title": "Sektörden Vaka: Dijital Sayaç Sayesinde Önlenen Büyük Felaket",
        "story": "500 odalı bir tatil köyünde gece yarısı ana kazan dairesi su borusunda çatlak oluştu.",
        "solution": "Akıllı debimetre debideki ani yükselişi algılayıp teknik müdürün telefonuna alarm gönderdi ve vanayı kapattı. 2 dakikada müdahale edildi; odaların sular altında kalması ve 500.000 TL'lik hasar önlendi."
      },
      "tip": "Ölçemediğiniz şeyi yönetemezsiniz! Dijital sensörler kaynak tüketimini anlık görünür kılar ve israfı anında yakalar."
    },
    {
      "id": 4,
      "tag": "DÖNGÜSEL İŞ MODELLERİ",
      "title": "SÜRDÜRÜLEBİLİR VE İNOVASYON ODAKLI İŞ MODELLERİ",
      "microSummary": "Ürün satmak yerine hizmet sunma (Product-as-a-Service), eko-tasarım ve döngüsel tedarik zinciri yeni nesil yeşil ticaretin omurgasıdır.",
      "definitions": [
        {
          "name": "Ürün-Hizmet Sistemi (Hizmet Olarak Ürün)",
          "desc": "Kullanıcıya veya işletmeye cihazın mülkiyetini satmak yerine cihazın sağladığı faydayı (hizmeti) kiralama modelidir. Üretici cihazın bakımından ve geri dönüşümünden sorumlu kalır.",
          "examples": [
            "Örnekle Pekiştirelim: Otelin klima satın almak yerine aydınlatma ve soğutma şirketinden 'saatlik serinlik hizmeti' satın alması; bakım ve tamirin üreticiye ait olması."
          ]
        },
        {
          "name": "Eko-Tasarım (Ecodesign)",
          "desc": "Bir ürünün tasarım aşamasından başlayarak hammadde seçimi, üretimi, kullanımı ve kullanım ömrü sonunda kolayca sökülüp geri dönüştürülmesini planlamaktır.",
          "examples": [
            "Örnekle Pekiştirelim: Otel odası mobilyalarının yapıştırıcı kimyasallar yerine kolayca sökülebilen geçmeli ahşap parçalarla tasarlanması."
          ]
        },
        {
          "name": "Döngüsel Tedarik Zinciri",
          "desc": "Tedarikçilerin de çevre standartlarına uymasını zorunlu kılan, ambalajsız veya iadeli kasalarla mal sevkiyatı yapan yeşil satın alma ağıdır.",
          "examples": [
            "Örnekle Pekiştirelim: Otel mutfağının sebzeleri plastik poşetlerde değil, yıkanıp tekrar kullanılan ahşap kasalarla teslim alması."
          ]
        }
      ],
      "caseStudy": {
        "title": "Sektörden Vaka: Halı Satın Almak Yerine 'Metrekare Zemin Hizmeti' Kiralamak",
        "story": "Küresel bir otel zinciri her 3 yılda bir eskiyen halıları çöpe atıp yüzbinlerce dolar yeni halı masrafı yapıyordu.",
        "solution": "Döngüsel halı üreticisiyle anlaştılar: Halılar satın alınmadı, kiralandı. Eskiyen yıpranmış karo halılar üretici tarafından sökülüp fabrikada tekrar ipliğe dönüştürüldü ve yerine yenisi takıldı. Sıfır atık, %40 maliyet avantajı sağlandı."
      },
      "tip": "Geleceğin işletmeleri misafir ve kullanıcılara 'sahip olma yükü' değil; 'sorunsuz ve çevre dostu deneyim' sunanlardır."
    },
    {
      "id": 5,
      "tag": "ESG VE RAPORLAMA",
      "title": "ESG (ÇEVRESEL, SOSYAL, YÖNETİŞİM) VE KARBON HESAPLAMA",
      "microSummary": "Şirketlerin başarısı artık sadece kârla değil; Çevresel (E), Sosyal (S) ve Yönetişimsel (G) performanslarını gösteren şeffaf sürdürülebilirlik raporlarıyla ölçülmektedir.",
      "definitions": [
        {
          "name": "ESG Kriterleri (Çevresel, Sosyal, Yönetişim)",
          "desc": "Çevresel (karbon, atık, su), Sosyal (çalışan hakları, İSG, eşitlik, toplumla ilişkiler) ve Yönetişim (etik, şeffaflık, yolsuzlukla mücadele) başlıklarında kurumsal karnedir.",
          "examples": [
            "Örnekle Pekiştirelim: Bankaların ve yatırım fonlarının kredi verirken otelin sadece cirosuna değil, ESG sürdürülebilirlik puanına bakarak düşük faiz vermesi."
          ]
        },
        {
          "name": "Kurumsal Sürdürülebilirlik Raporlaması",
          "desc": "İşletmenin bir yıl boyunca tükettiği enerjiyi, saldığı karbonu, yaptığı sosyal projeleri ve çalışan memnuniyetini uluslararası standartlarda (GRI) kamuoyuna açıklamasıdır.",
          "examples": [
            "Örnekle Pekiştirelim: Otelin her yıl 'Sürdürülebilirlik Raporu' yayınlayarak karbon ayak izini %12 azalttığını ve çalışanlarının %50'sinin kadın olduğunu belgelemesi."
          ]
        },
        {
          "name": "Yeşil Aklama (Greenwashing) Uyarısı",
          "desc": "Bir işletmenin gerçekte çevreye zarar verirken, reklam ve pazarlamayla kendisini çevre dostu gibi göstermeye çalışması sahtekarlığıdır.",
          "examples": [
            "Örnekle Pekiştirelim: Doğaya zehirli atık döken bir fabrikanın bahçesine üç fidan dikip 'Doğa Dostu Fabrika' diye reklam yapması yeşil aklamadır."
          ]
        }
      ],
      "caseStudy": {
        "title": "Sektörden Vaka: Yeşil Aklama Tuzağına Düşen Otelin Prestij Kaybı",
        "story": "Bir otel broşürlerinde 'Sıfır Atık Şampiyonu' olduğunu iddia etti ancak çöpleri ayrıştırmadan belediye çöp kamyonuna dökerken bir misafir tarafından videoya çekildi.",
        "solution": "Video sosyal medyada milyonlarca izlendi, boykot çağrıları yapıldı. Otel sahte reklam cezası aldı. Gerçek sürdürülebilirlik şov yapmak değil, tüm süreçlerde samimi ve şeffaf olmaktır."
      },
      "tip": "Sürdürülebilirlik bir reklam kampanyası değildir; işletmenin DNA'sına işlenmiş samimi bir yaşam ve üretim biçimidir."
    }
  ]
};

// ==========================================
// 10. ÖĞRENME BİRİMİ: FİNANSAL OKURYAZARLIK
// ==========================================
const Map<String, dynamic> meslekiGelisimUnit10 = {
  "title": "Finansal Okuryazarlık",
  "learningUnit": "10. Öğrenme Birimi",
  "podcastUrl": "https://anchor.fm/s/114a64400/podcast/play/126372584/https%3A%2F%2Fd3ctxlq1ktw2nl.cloudfront.net%2Fstaging%2F2026-8-27%2Ffd1facef-9f0a-66f1-1091-cbc839a6bee4.mp3",
  "cards": [
    {
      "id": 1,
      "tag": "KİŞİSEL FİNANS",
      "title": "KİŞİSEL FİNANS YÖNETİMİ VE BÜTÇE PLANLAMASI",
      "microSummary": "Finansal okuryazarlık; parayı bilinçli yönetme, bütçe yapma, gelir-gider dengesini kurma ve geleceğe güvenle bakabilme becerisidir.",
      "definitions": [
        {
          "name": "Finansal Okuryazarlık Tanımı",
          "desc": "Bireylerin bütçe yapma, tasarruf, borçlanma ve yatırım gibi finansal kavramları anlayarak rasyonel ve doğru parasal kararlar alabilme yeteneğidir.",
          "examples": [
            "Örnekle Pekiştirelim: Maaşını alır almaz plansız harcamak yerine önce kira, fatura ve tasarruf payını ayırıp kalanla yaşamını planlayan genç çalışan."
          ]
        },
        {
          "name": "Bütçe ve Gelir-Gider Dengesi",
          "desc": "Belirli bir dönemdeki (aylık/yıllık) beklenen gelirler ile yapılacak giderlerin önceden planlanmasıdır. Gelir > Gider = Bütçe Fazlası; Gider > Gelir = Bütçe Açığı (Borçlanma).",
          "examples": [
            "Örnekle Pekiştirelim: Aylık 30.000 TL geliri olan bir çalışanın giderlerini 24.000 TL ile sınırlayarak her ay 6.000 TL bütçe fazlası üretmesi."
          ]
        },
        {
          "name": "50/30/20 Bütçe Kuralı",
          "desc": "Aylık net gelirin; %50'sinin Zorunlu İhtiyaçlara (kira, fatura, market), %30'unun İsteklere (eğlence, tatil, hobi), %20'sinin ise Tasarruf ve Yatırıma ayrılması kuralıdır.",
          "examples": [
            "Örnekle Pekiştirelim: 20.000 TL kazanan stajyerin 10.000 TL'yi temel yaşama, 6.000 TL'yi sosyal hayata, 4.000 TL'yi birikim hesabına ayırması."
          ]
        }
      ],
      "caseStudy": {
        "title": "Sektörden Vaka: Kredi Kartı Asgari Ödeme Sarmalından Kurtuluş",
        "story": "Genç bir otel personeli isteklerini ihtiyaç sanarak maaşının iki katı harcama yaptı ve 3 ay üst üste kredi kartının sadece asgari tutarını ödedi; faizler katlanarak borç krizi doğdu.",
        "solution": "Bütçe günlüğü tutmaya başladı. Lüks dışarıda yemek yemeyi kısıp kart borcunu yapılandırdı ve 50/30/20 kuralına sadık kalarak 6 ayda borçsuz hayata ve birikime geçti."
      },
      "tip": "Ne kadar kazandığınız değil; elinizde ne kadar para tutabildiğiniz ve o parayı nasıl değerlendirdiğiniz zenginliğinizi belirler."
    },
    {
      "id": 2,
      "tag": "TASARRUF VE BİRİKİM",
      "title": "İSTEK VE İHTİYAÇ AYRIMI VE ACİL DURUM FONU",
      "microSummary": "İhtiyaçlar hayati zorunluluklardır, istekler ise ertelenebilir arzulardır; acil durum fonu beklenmedik krizlerde borçlanmayı önleyen finansal can simididir.",
      "definitions": [
        {
          "name": "İhtiyaç ile İstek Ayrımı",
          "desc": "İhtiyaç: Karşılanmadığında yaşamı ve sağlığı doğrudan tehlikeye atan unsurlardır (barınma, temel beslenme, sağlık, ulaşım). İstek: Olmasa da yaşanabilen konfor ve lüks harcamalardır.",
          "examples": [
            "Örnekle Pekiştirelim: İş yerine gitmek için kışlık dayanıklı ayakkabı almak İhtiyaç; dolapta ayakkabı varken modası için 5. çift spor ayakkabıyı almak İstektir."
          ]
        },
        {
          "name": "Acil Durum Fonu (Acil Güvence Akçesi)",
          "desc": "İşsiz kalma, kaza, hastalık veya ani araba tamiri gibi beklenmedik kriz durumları için en az 3 ila 6 aylık zorunlu gideri karşılayacak nakit birikimdir.",
          "examples": [
            "Örnekle Pekiştirelim: Aylık zorunlu gideri 15.000 TL olan birinin bankada vadesiz/likit hesapta dokunulmaz 60.000 TL acil durum fonu tutması."
          ]
        },
        {
          "name": "Bileşik Getirinin Gücü",
          "desc": "Kazanılan faiz ve kâr payının da ana paraya eklenerek yeniden getiri üretmesi; paranın zaman içinde katlanarak büyümesini sağlayan finansal mucizedir.",
          "examples": [
            "Örnekle Pekiştirelim: 18 yaşında her ay düzenli 1.000 TL hisse senedi veya fon alan gencin 35 yaşına geldiğinde devasa bir servete ulaşması."
          ]
        }
      ],
      "caseStudy": {
        "title": "Sektörden Vaka: Sezon Sonu İşsizliğinde Hayat Kurtaran Acil Fon",
        "story": "Mevsimlik çalışan bir barmen yazın kazandığı yüksek bahşişleri hemen harcadı ve kışın otel kapanınca kirasını ödeyemez hale geldi.",
        "solution": "Bir sonraki sezon kazandığı bahşişlerin %30'unu kış ayları için 'Kış Güvence Fonu'na yatırdı. Kışın otel kapalıyken borçlanmadan yabancı dil kursuna gidip kendini geliştirdi."
      },
      "tip": "Bir şey satın almadan önce '3 Gün Kuralı'nı uygulayın: Çok beğendiğiniz bir istek harcamasını 3 gün bekletin; 3 gün sonra hala aynı heyecanı duymuyorsanız almayın!"
    },
    {
      "id": 3,
      "tag": "FİNANSAL FİZİBİLİTE",
      "title": "İŞ FİKRİNİN FİNANSAL FİZİBİLİTESİ VE BAŞABAŞ NOKTASI",
      "microSummary": "Finansal fizibilite iş fikrinin kârlı olup olmadığını hesaplar; başabaş noktası (kara geçiş) toplam gelirin toplam maliyete eşitlendiği sıfır kâr/zarar noktasıdır.",
      "definitions": [
        {
          "name": "Finansal Fizibilite ve Başlangıç Sermayesi",
          "desc": "İşletmenin açılabilmesi ve ilk gelirler gelene kadar ayakta kalabilmesi için gereken toplam yatırım tutarı (makine, kira depozitosu, tadilat, ilk hammadde, işletme sermayesi) analizidir.",
          "examples": [
            "Örnekle Pekiştirelim: Butik bir pastane açmak için fırın, tezgah ve 6 aylık kira dahil toplam 500.000 TL başlangıç sermayesi gerektiğini hesaplamak."
          ]
        },
        {
          "name": "Sabit Maliyetler ve Değişken Maliyetler",
          "desc": "Sabit Maliyet: Üretim artsa da azalsa da değişmeyen giderler (Dükkan kirası, sigorta, sabit maaşlar). Değişken Maliyet: Üretim miktarıyla birlikte artan giderler (Un, şeker, elektrik, paketleme).",
          "examples": [
            "Örnekle Pekiştirelim: Kafenin aylık 20.000 TL kirası sabit maliyet; satılan her fincan kahve için harcanan 10 TL'lik kahve çekirdeği değişken maliyettir."
          ]
        },
        {
          "name": "Başabaş Noktası (Break-Even Point - BEP)",
          "desc": "İşletmenin ne kâr ne de zarar ettiği, başa baş geldiği satış hacmidir. Formülü: Sabit Maliyetler / (Birim Satış Fiyatı - Birim Değişken Maliyet).",
          "examples": [
            "Örnekle Pekiştirelim: Sabit gideri 30.000 TL, fincan başı kâr marjı 30 TL olan bir kafenin ayda tam 1.000 fincan kahve sattığında başabaş noktasına ulaşması (1001. fincanda kâra geçer)."
          ]
        }
      ],
      "caseStudy": {
        "title": "Sektörden Vaka: Başabaş Noktasını Bilmeden Açılan Restoran",
        "story": "Bir şef aşçı günde 20 tabak satarak kâra geçeceğini sandı ancak yüksek dükkan kirasını ve personel maaşlarını (Sabit maliyet) hesaba katmadı.",
        "solution": "Bir muhasebeciyle başabaş analizi yaptı: Kâra geçmek için günde en az 65 tabak satması gerektiğini gördü. Menüyü öğle saatlerinde paket servise açarak satışı 80 tabağa çıkardı ve iflastan kurtuldu."
      },
      "tip": "Başabaş noktanızı bilmek hayatta kalma haritanızdır! Başabaş noktasına kaçıncı günde ulaştığınızı bilmeden işletme yönetemezsiniz."
    },
    {
      "id": 4,
      "tag": "NAKİT AKIŞI YÖNETİMİ",
      "title": "NAKİT AKIŞI YÖNETİMİ VE GELİR-GİDER TABLOSU",
      "microSummary": "Kâr kağıt üzerindedir, nakit ise gerçektir; nakit akışı yönetimi işletmenin kasasına giren ve çıkan paranın zamanlamasını kontrol etme sanatıdır.",
      "definitions": [
        {
          "name": "Nakit Akışı (Cash Flow) vs Kâr Ayrımı",
          "desc": "Bir işletme kağıt üzerinde çok kârlı görünebilir ancak vadeli sattığı parayı zamanında tahsil edemezse vadesi gelen borcunu ödeyemeyerek iflas edebilir (Nakit tıkanması).",
          "examples": [
            "Örnekle Pekiştirelim: Acenteye 100.000 TL'lik tur satıp faturayı kesen otelin parayı 90 gün sonra alacak olması; ancak ertesi gün personelin maaşını nakit ödemek zorunda kalması."
          ]
        },
        {
          "name": "Gelir Tablosu ve Bilanço Temelleri",
          "desc": "Gelir Tablosu: Belli bir dönemdeki gelirler, giderler ve net kâr/zararı gösterir. Bilanço: Belli bir andaki varlıkları (aktif) ve bu varlıkların kaynağını (borçlar + öz kaynak) gösterir.",
          "examples": [
            "Örnekle Pekiştirelim: Gelir tablosu filmin tamamı (yıllık kâr), bilanço ise belirli bir günün anlık fotoğrafıdır."
          ]
        },
        {
          "name": "İşletme Sermayesi (Dönen Varlıklar)",
          "desc": "İşletmenin günlük operasyonlarını (maaş, elektrik, hammadde alımı) aksamadan sürdürebilmesi için kasada ve bankada hazır bulundurması gereken likit sermayedir.",
          "examples": [
            "Örnekle Pekiştirelim: Sezon açılışında otelin odaları satılana kadar ilk 1 ay mutfak alışverişini yapabilmesi için kasada bulundurduğu 200.000 TL nakit fon."
          ]
        }
      ],
      "caseStudy": {
        "title": "Sektörden Vaka: Kârlı Olduğu Halde Batan Seyahat Acentesi",
        "story": "Bir acente 1 milyon TL'lik şirket gezisi organize etti ve 200.000 TL net kâr hesapladı. Ancak kurumsal şirket ödemeyi 4 ay erteledi; acente ise uçak biletlerini peşin ödemek zorundaydı.",
        "solution": "Kasada nakit kalmadı, havayolu şirketine teminatı yandı ve acente battı. Sebep kârsızlık değil; nakit akışı zamanlamasının yönetilememesiydi."
      },
      "tip": "'Ciro kibirdir, kâr akıldır, ama nakit kraldır (Cash is King)!' İşletmeler kârsızlıktan değil, nakitsizlikten batar."
    },
    {
      "id": 5,
      "tag": "FİNANSAL RİSK YÖNETİMİ",
      "title": "FİNANSAL RİSKLER VE RİSKTEN KORUNMA STRATEJİLERİ",
      "microSummary": "İşletmeler enflasyon, kur dalgalanması, faiz artışı ve tahsilat risklerine karşı sepet mantığı, sigorta ve vadeli sözleşmelerle korunur.",
      "definitions": [
        {
          "name": "Temel Finansal Risk Türleri",
          "desc": "Likidite Riski (nakit bulamama), Kredi/Tahsilat Riski (alacağın tahsil edilememesi), Piyasa/Kur Riski (döviz kurlarındaki dalgalanma) ve Enflasyon Riski.",
          "examples": [
            "Örnekle Pekiştirelim: Dolar üzerinden borçlanıp Türk Lirası ile oda satan bir otelin dolar kurunun aniden yükselmesiyle borcunun katlanması kur riskidir."
          ]
        },
        {
          "name": "Riskten Korunma (Hedging) ve Sözleşmeler",
          "desc": "Gelecekteki fiyat veya kur dalgalanmalarının yaratacağı zararlardan korunmak amacıyla önceden sabit fiyatlı anlaşmalar veya vadeli işlemler yapmaktır.",
          "examples": [
            "Örnekle Pekiştirelim: Tur operatörünün sezon başında otelle gecelik 50 Euro sabit kurla sözleşme yaparak kur artışı riskini sabitlemesi."
          ]
        },
        {
          "name": "Portföy Çeşitlendirmesi (Yumurta Kuralı)",
          "desc": "'Tüm yumurtaları aynı sepete koyma!' ilkesi. Gelir kaynaklarını ve yatırımları farklı pazarlara, farklı misafir segmentlerine ve farklı finansal araçlara yaymaktır.",
          "examples": [
            "Örnekle Pekiştirelim: Bir otelin yalnızca tek bir yabancı ülkenin turistlerine bağımlı kalmayıp; iç pazar, kongre turizmi ve farklı coğrafyalardan turist çekerek riskini dağıtması."
          ]
        }
      ],
      "caseStudy": {
        "title": "Sektörden Vaka: Tek Pazara Bağımlılığın Yol Açtığı Büyük Kriz",
        "story": "Antalya'da bir resort otel tüm kapasitesini tek bir ülkenin tur operatörüne bağladı. O ülkede yaşanan siyasi kriz nedeniyle uçuşlar durduruldu ve otel temmuz ayında bomboş kaldı.",
        "solution": "Otel sonraki sezon 'Çeşitlendirilmiş Pazar' stratejisine geçti: %30 Avrupa, %30 Orta Doğu, %20 Yerli Pazar, %20 BDT ülkeleri dengesini kurdu ve tek bir krizde batmaktan korundu."
      },
      "tip": "Riskten kaçamazsınız ama riski yönetebilirsiniz. Finansal başarının sırrı tek bir kapıya bel bağlamamak ve daima bir B planı bulundurmaktır."
    }
  ]
};


// ==========================================
// GERİYE DÖNÜK UYUMLULUK ALIAS'LARI
// ==========================================
const Map<String, dynamic> meslekEtigiVeAhilik = meslekiGelisimUnit2;
const Map<String, dynamic> isSagligiVeGuvenligi = meslekiGelisimUnit3;
const Map<String, dynamic> cevreKoruma = meslekiGelisimUnit4;
const Map<String, dynamic> girisimciFikirler = meslekiGelisimUnit5;
const Map<String, dynamic> fikriVeSinaiMulkiyet = meslekiGelisimUnit6;
const Map<String, dynamic> teknolojikGelismeler = meslekiGelisimUnit7;

// ==========================================
// 10 ÖĞRENME BİRİMİNİN TAMAMI (LİSTE)
// ==========================================
const List<Map<String, dynamic>> meslekiGelisimNotes = [
  meslekiGelisimUnit1,
  meslekiGelisimUnit2,
  meslekiGelisimUnit3,
  meslekiGelisimUnit4,
  meslekiGelisimUnit5,
  meslekiGelisimUnit6,
  meslekiGelisimUnit7,
  meslekiGelisimUnit8,
  meslekiGelisimUnit9,
  meslekiGelisimUnit10,
];
