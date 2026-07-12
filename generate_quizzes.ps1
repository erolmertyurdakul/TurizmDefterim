# Pure PowerShell script to generate all remaining 540 questions and integrate them into quiz_data.dart
$ErrorActionPreference = "Stop"

$QUIZ_FILE = "c:\Users\erolm\Desktop\TurizmAkademi\lib\core\data\quiz_data.dart"

function Get-AlternatifTurizmQuestions {
    $q = @()
    
    # ÜNİTE 1: ALTERNATİF TURİZME GİRİŞ (15 Soru)
    $q += [PSCustomObject]@{
        id = "at12_1_1"
        courseId = "alternatif_turizm"
        unitIndex = 0
        questionText = "Sürdürülebilir turizmin kitle turizmine karşı ortaya çıkardığı, çevreye duyarlı ve küçük ölçekli turizm hareketlerinin genel adı nedir?"
        options = @("Lüks Turizm", "Alternatif Turizm", "Kitle Turizmi", "Kıyı Turizmi")
        correctOptionIndex = 1
        explanation = "Geleneksel deniz-kum-güneş (kitle) turizminin yarattığı tahribata tepki olarak doğan doğa ve kültür odaklı türlere Alternatif Turizm denir."
    }
    $q += [PSCustomObject]@{
        id = "at12_1_2"
        courseId = "alternatif_turizm"
        unitIndex = 0
        questionText = "Aşağıdakilerden hangisi kitle turizminin destinasyonlarda yarattığı en büyük olumsuz etkilerden biridir?"
        options = @("Yerel ekonomiyi tamamen yok etmesi", "Aşırı betonlaşma, çevre kirliliği ve yerel kültürün yozlaşması", "Turist sayısının azalması", "Ulaşımın yavaşlaması")
        correctOptionIndex = 1
        explanation = "Kontrolsüz kitle turizmi aşırı kaynak tüketimine, doğa tahribatına ve kültürel kimliğin kaybolmasına yol açar."
    }
    $q += [PSCustomObject]@{
        id = "at12_1_3"
        courseId = "alternatif_turizm"
        unitIndex = 0
        questionText = "Alternatif turizmin gelişiminde 'Taşıma Kapasitesi' kavramının hayati önem taşımasının temel sebebi nedir?"
        options = @("Daha büyük oteller yapmak", "Bölgenin ekolojik ve sosyal yapısının zarar görmeden kaldırabileceği maksimum turist sınırını korumak", "Bilet fiyatlarını artırmak", "Acente komisyonlarını düşürmek")
        correctOptionIndex = 1
        explanation = "Taşıma kapasitesinin aşılması destinasyonun doğal cazibesini yok eder; bu yüzden alternatif turizm sınırlandırmaları savunur."
    }
    $q += [PSCustomObject]@{
        id = "at12_1_4"
        courseId = "alternatif_turizm"
        unitIndex = 0
        questionText = "Aşağıdakilerden hangisi sürdürülebilir alternatif turizmin temel ilkelerinden biridir?"
        options = @("Kısa vadede yüksek kar elde etmek", "Yerel halkın kararlara katılımını sağlamak ve geliri tabana yaymak", "Tüm doğal alanları imara açmak", "Sadece yabancı zincirleri desteklemek")
        correctOptionIndex = 1
        explanation = "Yerel halkın sürece dahil edilmesi ve gelir elde etmesi turizmin sosyal ve ekonomik açıdan sürdürülebilir olmasını sağlar."
    }
    $q += [PSCustomObject]@{
        id = "at12_1_5"
        courseId = "alternatif_turizm"
        unitIndex = 0
        questionText = "Alternatif turizm kapsamında, doğal alanları koruyan ve yerel halkın refahını gözeten doğa seyahatlerine ne ad verilir?"
        options = @("Ekoturizm", "Kongre Turizmi", "Kruvaziyer Turizmi", "Macera Turizmi")
        correctOptionIndex = 0
        explanation = "Ekoturizm, çevre bilincini artıran, küçük gruplarla yapılan ve yerel ekosisteme saygılı olan en yaygın alternatif turizm türüdür."
    }
    $q += [PSCustomObject]@{
        id = "at12_1_6"
        courseId = "alternatif_turizm"
        unitIndex = 0
        questionText = "Destinasyonların turizm baskısı altında yok olmasını önlemek amacıyla uygulanan 'Ziyaretçi Yönetimi' neyi kapsar?"
        options = @("Fiyatları tamamen serbest bırakmayı", "Ziyaretçi sayılarını sınırlandırma, rotalama ve hassas koruma bölgeleri (zonlama) ilan etmeyi", "Daha fazla yol inşa etmeyi", "Turistleri tamamen yasaklamayı")
        correctOptionIndex = 1
        explanation = "Ziyaretçi yönetimi, hassas ekosistemlerin aşırı turist yükü altında ezilmesini önleyen planlama teknikleridir."
    }
    $q += [PSCustomObject]@{
        id = "at12_1_7"
        courseId = "alternatif_turizm"
        unitIndex = 0
        questionText = "Alternatif turizm pazarlamasında çevre dostu işletmeleri tescilleyen eko-etiketlerin (Mavi Bayrak, Yeşil Anahtar vb.) rolü nedir?"
        options = @("Maliyetleri artırmak", "Çevre bilinci yüksek bilinçli turistlerin (yeşil tüketiciler) güvenini kazanmak ve tercih edilmeyi sağlamak", "Rakipleri cezalandırmak", "Sadece vergi muafiyeti almak")
        correctOptionIndex = 1
        explanation = "Eko-etiketler, tesisin çevre taahhütlerinin bağımsız kuruluşlarca onaylandığını göstererek prestij ve müşteri çeker."
    }
    $q += [PSCustomObject]@{
        id = "at12_1_8"
        courseId = "alternatif_turizm"
        unitIndex = 0
        questionText = "Alternatif turizmin kırsal bölgelerde uygulanmasının yerel topluma en büyük ekonomik faydası nedir?"
        options = @("Tarımı tamamen bitirmesi", "Kırsal istihdam yaratarak köyden kente göçü önlemesi ve yerel ürünlerin değer kazanması", "Gökdelen sayısını artırması", "Herkesin otellerde çalışmasını sağlaması")
        correctOptionIndex = 1
        explanation = "Kırsal turizm, tarım dışı ek gelir yaratarak köylünün kendi topraklarında refah içinde yaşamasını destekler."
    }
    $q += [PSCustomObject]@{
        id = "at12_1_9"
        courseId = "alternatif_turizm"
        unitIndex = 0
        questionText = "Doğal ve kültürel varlıkların gelecek nesillerin de yararlanabileceği şekilde korunması sürdürülebilirliğin hangi boyutudur?"
        options = @("Ekonomik boyut", "Ekolojik (Çevresel) boyut", "Sosyo-Kültürel boyut", "Teknolojik boyut")
        correctOptionIndex = 1
        explanation = "Ekolojik sürdürülebilirlik, gezegenin biyolojik çeşitliliğinin ve doğal kaynaklarının korunmasını hedefler."
    }
    $q += [PSCustomObject]@{
        id = "at12_1_10"
        courseId = "alternatif_turizm"
        unitIndex = 0
        questionText = "Turizm kazancının yerel esnafa adil dağılması ve yerel kalkınmayı desteklemesi sürdürülebilirliğin hangi ilkesidir?"
        options = @("Çevresel Koruma", "Ekonomik Sürdürülebilirlik", "Kültürel Miras", "Teknolojik Dönüşüm")
        correctOptionIndex = 1
        explanation = "Ekonomik sürdürülebilirlik, turizm kaynaklı refahın adilce yayılmasını ve uzun vadeli ekonomik canlılığı amaçlar."
    }
    $q += [PSCustomObject]@{
        id = "at12_1_11"
        courseId = "alternatif_turizm"
        unitIndex = 0
        questionText = "Aşırı turizm (Overtourism) baskısını hafifletmek için alternatif turizm planlamasında kullanılan 'Coğrafi Yayılma' stratejisi nedir?"
        options = @("Turistleri tek bir plaja yığmak", "Turist akınını ana destinasyon dışındaki alternatif kırsal ve tarihi çekim merkezlerine yönlendirmek", "Otelleri kapatmak", "Fiyatları sürekli yükseltmek")
        correctOptionIndex = 1
        explanation = "Turistleri geniş bir coğrafyaya dağıtmak, merkezlerdeki yoğunluk krizini çözerken çevre bölgelerin de kalkınmasını sağlar."
    }
    $q += [PSCustomObject]@{
        id = "at12_1_12"
        courseId = "alternatif_turizm"
        unitIndex = 0
        questionText = "Alternatif turizm tüketicisi olan 'Yeşil Turistler' seyahat acentelerinden öncelikle ne talep ederler?"
        options = @("En ucuz plastik ürünleri sunmasını", "Çevreye en az karbon salınımı yapan transferleri, yerel rehberleri ve doğa dostu konaklamaları içeren turları", "Lüks devasa beton otelleri", "Hızlı ve tahrip edici av turlarını")
        correctOptionIndex = 1
        explanation = "Bilinçli seyahat severler, karbon ayak izlerini en aza indirecek eko-duyarlı paketleri tercih ederler."
    }
    $q += [PSCustomObject]@{
        id = "at12_1_13"
        courseId = "alternatif_turizm"
        unitIndex = 0
        questionText = "Bir bölgenin turizme açılmadan önce doğal ve tarihi envanterinin çıkarılması neden zorunludur?"
        options = @("Reklam bütçesini hesaplamak için", "Korunması gereken hassas değerleri saptamak ve planlamayı bu sınırlara göre yapmak için", "Oda numaralarını belirlemek için", "Sadece yasal formalite olduğu için")
        correctOptionIndex = 1
        explanation = "Doğal kaynak envanteri, neyin nerede korunacağını belirleyen sürdürülebilir planlamanın temel haritasıdır."
    }
    $q += [PSCustomObject]@{
        id = "at12_1_14"
        courseId = "alternatif_turizm"
        unitIndex = 0
        questionText = "Yerel mimariye aykırı, betonarme dev yapıların ekoturizm bölgelerine inşa edilmesi hangi ilkeye tamamen aykırıdır?"
        options = @("Lüks standartlarına", "Çevresel ve estetik sürdürülebilirliğe, ekolojik bütünlüğe", "Ekonomik karlılığa", "Teknolojik gelişmeye")
        correctOptionIndex = 1
        explanation = "Eko-mimari, tesislerin doğayla bütünleşmesini ve yöresel dokuya (taş, ahşap) sadık kalınmasını yasal olarak şart koşar."
    }
    $q += [PSCustomObject]@{
        id = "at12_1_15"
        courseId = "alternatif_turizm"
        unitIndex = 0
        questionText = "Alternatif turizm süreci sonucunda destinasyonların elde edeceği en büyük kazanç hangisidir?"
        options = @("Kaynakların hızla tükenmesi", "Uzun ömürlü, korunan, saygın ve marka değeri yüksek bir destinasyon kimliği", "Turist sayısının aniden sıfırlanması", "Sadece kışın açık kalan oteller")
        correctOptionIndex = 1
        explanation = "Sürdürülebilir koruma, destinasyonun ömrünü uzatır ve nesiller boyu yüksek prestijli turizm yapılmasını garanti eder."
    }

    # ÜNİTE 2: ALTERNATİF TURİZM ÇEŞİTLERİ (15 Soru)
    $q += [PSCustomObject]@{
        id = "at12_2_1"
        courseId = "alternatif_turizm"
        unitIndex = 1
        questionText = "Dağlık ve ormanlık bölgelerdeki temiz hava ve doğal yaşamdan yararlanmak amacıyla yapılan alternatif turizm türü hangisidir?"
        options = @("Sağlık Turizmi", "Yayla Turizmi", "Kongre Turizmi", "Kruvaziyer Turizmi")
        correctOptionIndex = 1
        explanation = "Yayla turizmi, özellikle yaz aylarında serinlemek, doğayla baş başa kalmak ve yerel kültürü yaşamak için yapılan doğa odaklı turizmdir."
    }
    $q += [PSCustomObject]@{
        id = "at12_2_2"
        courseId = "alternatif_turizm"
        unitIndex = 1
        questionText = "Yerel mutfak kültürünün, geleneksel yemeklerin ve gastronomi rotalarının ön plana çıktığı seyahat türüne ne denir?"
        options = @("Ekoturizm", "Gastronomi Turizmi", "Macera Turizmi", "Yat Turizmi")
        correctOptionIndex = 1
        explanation = "Yemek kültürünü tanımak, yerel lezzetleri tatmak ve yemek atölyelerine katılmak amacıyla yapılan turlara Gastronomi Turizmi denir."
    }
    $q += [PSCustomObject]@{
        id = "at12_2_3"
        courseId = "alternatif_turizm"
        unitIndex = 1
        questionText = "Şirketlerin, akademisyenlerin ve uluslararası kuruluşların toplantı, seminer ve kongre amacıyla seyahat etmesini kapsayan turizm türü hangisidir?"
        options = @("Gençlik Turizmi", "Kongre (MICE) Turizmi", "Yayla Turizmi", "İnanç Turizmi")
        correctOptionIndex = 1
        explanation = "Kongre turizmi, sezon dışı aylarda yüksek gelir getiren ve altyapı gelişimini tetikleyen en önemli alternatif turizm türlerindendir."
    }
    $q += [PSCustomObject]@{
        id = "at12_2_4"
        courseId = "alternatif_turizm"
        unitIndex = 1
        questionText = "Tarihi kutsal mekanları, mabetleri ziyaret etmek ve inanç ritüellerini gerçekleştirmek amacıyla yapılan turizm hangisidir?"
        options = @("Kültür Turizmi", "İnanç Turizmi", "Ekoturizm", "Sağlık Turizmi")
        correctOptionIndex = 1
        explanation = "Farklı din ve inançlara ait kutsal destinasyonların (örn. Meryem Ana Evi, Şanlıurfa Göbeklitepe) ziyaret edilmesine İnanç Turizmi denir."
    }
    $q += [PSCustomObject]@{
        id = "at12_2_5"
        courseId = "alternatif_turizm"
        unitIndex = 1
        questionText = "Deniz altı florasını ve batıkları gözlemlemek amacıyla profesyonel ekipmanlarla yapılan alternatif turizm faaliyeti hangisidir?"
        options = @("Yat Turizmi", "Dalış (Scuba Diving) Turizmi", "Kış Turizmi", "Yayla Turizmi")
        correctOptionIndex = 1
        explanation = "Su altı dünyasını keşfetmek ve batıkları incelemek amacıyla yapılan turizm dalış turizmidir, yüksek güvenlik kurallarına tabidir."
    }
    $q += [PSCustomObject]@{
        id = "at12_2_6"
        courseId = "alternatif_turizm"
        unitIndex = 1
        questionText = "Kar ve kış sporlarına (kayak, snowboard) dayalı, dağlık tesislerde kış aylarında gerçekleştirilen turizm türü hangisidir?"
        options = @("Yayla Turizmi", "Kış Turizmi", "Doğa Yürüyüşü", "Ekoturizm")
        correctOptionIndex = 1
        explanation = "Kayak pistleri ve kış otelleri çevresinde gelişen, mevsimlik dalgalanmayı azaltan turizm dalı Kış Turizmidir."
    }
    $q += [PSCustomObject]@{
        id = "at12_2_7"
        courseId = "alternatif_turizm"
        unitIndex = 1
        questionText = "Mağaraların doğal sarkıt, dikit oluşumlarını ve mikroklimasını gözlemlemek amacıyla yapılan turizm türü hangisidir?"
        options = @("Yayla Turizmi", "Mağara Turizmi", "Dağcılık", "Ekoturizm")
        correctOptionIndex = 1
        explanation = "Mağara turizmi, jeolojik oluşumlara meraklı niş bir turist grubuna hitap eden macera ve doğa odaklı turizmdir."
    }
    $q += [PSCustomObject]@{
        id = "at12_2_8"
        courseId = "alternatif_turizm"
        unitIndex = 1
        questionText = "Uluslararası standartlarda golf sahalarına sahip destinasyonlarda gerçekleştirilen, kişi başı harcaması en yüksek spor turizmi türü hangisidir?"
        options = @("Futbol Turizmi", "Golf Turizmi", "Yat Turizmi", "Ekoturizm")
        correctOptionIndex = 1
        explanation = "Golf turizmi, üst gelir grubundaki elit turistleri çekerek destinasyonun gelir marjını devasa ölçüde yükseltir."
    }
    $q += [PSCustomObject]@{
        id = "at12_2_9"
        courseId = "alternatif_turizm"
        unitIndex = 1
        questionText = "Termal suların, çamur banyolarının ve kaplıcaların şifa verici özelliklerinden yararlanmak amacıyla yapılan turizm türü hangisidir?"
        options = @("Macera Turizmi", "Termal (Kaplıca) Turizmi", "Kongre Turizmi", "Yayla Turizmi")
        correctOptionIndex = 1
        explanation = "Mineralli sıcak su kaynakları çevresinde kurulan termal tesislerde sağlık ve zindelik (wellness) amaçlı konaklamalara Termal Turizm denir."
    }
    $q += [PSCustomObject]@{
        id = "at12_2_10"
        courseId = "alternatif_turizm"
        unitIndex = 1
        questionText = "Kuşların göç yollarını, üreme alanlarını doğal ortamlarında gözlemlemek amacıyla yapılan ekoturizm faaliyeti hangisidir?"
        options = @("Av Turizmi", "Kuş Gözlemciliği (Ornitoloji) Turizmi", "Mağara Turizmi", "Botanik Turizmi")
        correctOptionIndex = 1
        explanation = "Ornitoloji turizmi, doğaya sıfır zarar veren, yüksek eğitimli ve bilinçli doğaseverlerin katıldığı niş bir ekoturizm dalıdır."
    }
    $q += [PSCustomObject]@{
        id = "at12_2_11"
        courseId = "alternatif_turizm"
        unitIndex = 1
        questionText = "Bölgedeki endemik bitki türlerini ve yabani çiçekleri doğal ortamında incelemek amacıyla yapılan botanik turizminin temel kuralı nedir?"
        options = @("Bitkileri koparıp eve götürmek", "Bitkilere zarar vermeden sadece gözlemlemek ve fotoğraflamak", "Bitki alanlarını imara açmak", "Bitki satışı yapmak")
        correctOptionIndex = 1
        explanation = "Botanik turizminde biyoçeşitliliğin korunması esastır; hiçbir endemik tür koparılamaz veya zarar verilemez."
    }
    $q += [PSCustomObject]@{
        id = "at12_2_12"
        courseId = "alternatif_turizm"
        unitIndex = 1
        questionText = "Yat sahiplerinin koyları gezmesi, marinalarda konaklaması ve deniz odaklı lüks harcamalar yapmasını kapsayan turizm hangisidir?"
        options = @("Kruvaziyer Turizmi", "Yat Turizmi", "Kıyı Turizmi", "Alternatif Turizm")
        correctOptionIndex = 1
        explanation = "Yat turizmi lüks marinalar ve çekek yerleri altyapısı gerektiren, döviz girdisi en yüksek deniz turizmi segmentidir."
    }
    $q += [PSCustomObject]@{
        id = "at12_2_13"
        courseId = "alternatif_turizm"
        unitIndex = 1
        questionText = "Tarihi antik kentleri, müzeleri ve arkeolojik kazı alanlarını ziyaret ederek geçmiş uygarlıkları tanıma amaçlı seyahat türü hangisidir?"
        options = @("İnanç Turizmi", "Kültür Turizmi", "Macera Turizmi", "Ekoturizm")
        correctOptionIndex = 1
        explanation = "Kültür turizmi, insanlığın ortak mirasını, sanatını ve tarihini keşfetmeyi amaçlayan en köklü alternatif turizm türidir."
    }
    $q += [PSCustomObject]@{
        id = "at12_2_14"
        courseId = "alternatif_turizm"
        unitIndex = 1
        questionText = "Macera arayan, adrenalin seviyesi yüksek doğa sporları (rafting, yamaç paraşütü vb.) içeren turizm türü hangisidir?"
        options = @("Kongre Turizmi", "Macera Turizmi", "Kış Turizmi", "İnanç Turizmi")
        correctOptionIndex = 1
        explanation = "Macera turizmi, coğrafi engelleri ve doğal zorlukları aşarak sınırlarını test etmek isteyen dinamik turist grubuna hitap eder."
    }
    $q += [PSCustomObject]@{
        id = "at12_2_15"
        courseId = "alternatif_turizm"
        unitIndex = 1
        questionText = "Üçüncü yaş ve medikal amaçlı gelen hastaların tedavisini ve rehabilitasyonunu kapsayan turizm dalı hangisidir?"
        options = @("Sağlık (Medikal) Turizmi", "Gençlik Turizmi", "Spor Turizmi", "Kültür Turizmi")
        correctOptionIndex = 0
        explanation = "Sağlık turizmi, hastaneler ve kaplıcalar aracılığıyla uluslararası düzeyde şifa arayan hastalara sunulan profesyonel seyahat hizmetidir."
    }

    return $q
}

$remaining_courses = [ordered]@{
    "kuru_temizleme_islemleri" = @{
        prefix = "kt12"
        units = @(
            "İş Organizasyonu",
            "Kuru Temizleme Öncesi Hazırlık İşlemleri",
            "Kuru Temizleme İşlemleri",
            "Günlük/Periyodik Kontrol ve Bakımların Takibi",
            "Kuru Temizleme Gerektirmeyen Tekstil Ürünleri İçin Yıkama İşlemi"
        )
        topics = @(
            @("İş sağlığı ve güvenliği", "Kişisel koruyucu donanım", "Solvent güvenliği", "Makine yerleşimi", "Havalandırma standartları"),
            @("Leke teşhisi", "Lif tespiti", "Ön leke çıkarma", "Aparatura hazırlık", "Ceplerin kontrolü"),
            @("Solvent kullanımı", "Perkloretilen", "Distilasyon işlemi", "Kurutma çevrimi", "Koku giderme prosedürü"),
            @("Filtre bakımı", "Solvent seviyesi kontrolü", "Çamur boşaltma", "Conta sızdırmazlığı", "Periyodik temizlik"),
            @("Hassas yıkama", "Dozajlama kuralları", "Sıkma devri", "Kurutma sıcaklığı", "Ütüleme pres ayarı")
        )
    }
    "camasirhane_islemleri" = @{
        prefix = "ci12"
        units = @(
            "İş Organizasyonu",
            "Yıkama İşlemi",
            "Ütüleme İşlemi",
            "Depolama İşlemi"
        )
        topics = @(
            @("Ergonomi ve düzen", "Kimyasal depolama", "Koruyucu donanım", "İş akışı planlama", "Yangın güvenliği"),
            @("Leke çıkarma kimyasalları", "Dozaj pompaları", "Su sertliği", "Sıcaklık ayarları", "Sıkma aşamaları"),
            @("Silindir ütü", "Pres ütü", "Buhar jeneratörü", "Katlama standartları", "Askılama sistemleri"),
            @("Nemsiz depolama", "Raf düzeni", "Envanter takibi", "Paketleme poşeti", "Dağıtım arabaları")
        )
    }
    "dunya_seyahat_ve_turizm_cografyasi" = @{
        prefix = "dc12"
        units = @(
            "Coğrafya ve Turizm",
            "Su Kaynaklarına Dayalı Turizm Merkezleri",
            "Manzara ve Doğal Yaşam Kaynaklarına Dayalı Turizm Merkezleri",
            "Tarihi Kaynaklara Dayalı Turizm Merkezleri",
            "Şehir ve Kruvaziyer Turizmi Merkezleri",
            "Kültür ve İnanç Turizmi Merkezleri",
            "Sağlık ve Spor Turizmi Merkezleri"
        )
        topics = @(
            @("Turizm coğrafyasının tanımı", "İklimin turizme etkisi", "Ulaşım ağları", "Zaman dilimleri", "Doğal sınırlar"),
            @("Deniz turizmi", "Göller ve nehirler", "Şelaleler", "Fiyortlar", "Kanyonlar ve su yolları"),
            @("Milli parklar", "Yaban hayatı koruma", "Safari rotaları", "Dağcılık merkezleri", "Mağara sistemleri"),
            @("Antik kentler", "Kalıntılar", "Müzeler", "Dünya miras listesi", "Tarihi köprüler ve kaleler"),
            @("Metropol turizmi", "Kruvaziyer limanları", "Gemi rotaları", "Kıyı şehirleri", "Liman hizmetleri"),
            @("Dini mabetler", "Hac rotaları", "İnanç merkezleri", "Geleneksel festivaller", "Sanat müzeleri"),
            @("Kaplıcalar", "Termal tesisler", "Kayak merkezleri", "Golf sahaları", "Doğa yürüyüşü (Trekking) rotaları")
        )
    }
    "dunya_kulturleri" = @{
        prefix = "dk12"
        units = @(
            "Dünya Kültürlerine Giriş",
            "Dünya Kültür Çeşitleri"
        )
        topics = @(
            @("Kültür tanımı ve unsurları", "Kültürel etkileşim", "Gelenek ve görenekler", "Maddi ve manevi kültür", "Dil ve sanat coğrafyası"),
            @("Asya kültürleri", "Avrupa kültürleri", "Afrika kültürleri", "Amerikan kültürleri", "Ortadoğu gelenekleri")
        )
    }
    "kongre_ve_etkinlik_turizmi" = @{
        prefix = "ke12"
        units = @(
            "Kongre ve Etkinlik Yönetimine Giriş",
            "Konaklama İşletmelerinde Toplantı ve Etkinlik Hizmetleri"
        )
        topics = @(
            @("Kongre tanımı ve MICE", "Etkinlik planlama aşamaları", "Sözleşme yönetimi", "Bütçe hazırlığı", "Teknolojik altyapı"),
            @("Salon düzenleri", "Kahve molaları (Coffee break)", "Ziyafet (Banquet) yönetimi", "Protokol kuralları", "Geri bildirim ve değerlendirme")
        )
    }
    "gastronomi_turizmi" = @{
        prefix = "gt12"
        units = @(
            "Gastronomi Turizmine Giriş",
            "Türkiye'de ve Dünyada Gastronomi Turizmi"
        )
        topics = @(
            @("Gastronomi tanımı", "Yemek ve kimlik ilişkisi", "Coğrafi işaretli ürünler", "Gastronomi rotaları", "Mutfak müzeleri"),
            @("Türk mutfağı zenginliği", "Akdeniz mutfağı", "Uzakdoğu lezzetleri", "Sokak lezzetleri turizmi", "Michelin yıldızı standartları")
        )
    }
    "tur_operasyonu" = @{
        prefix = "to12"
        units = @(
            "Turizm Kuralları ve Rehberlik",
            "Rehberlik Hizmetleri",
            "Paket Tur Hazırlama",
            "Tur Operasyonu için Hazırlık Yapma",
            "Tur Operasyonu Yapma",
            "Acente Operasyonlarını Gerçekleştirme"
        )
        topics = @(
            @("Acentecilik yasası", "TÜRSAB kuralları", "Seyahat sigortası", "Vize prosedürleri", "Rehberlik kanunu"),
            @("Tur yönetimi", "Anlatım teknikleri", "Kriz yönetimi (ilk yardım)", "Protokol bilgisi", "Grup psikolojisi"),
            @("Maliyet hesaplama", "Ulaşım rezervasyonu", "Otel kontratları", "Tur rotası (itinerary) çizme", "Katalog hazırlığı"),
            @("Oda listesi (rooming list)", "Rehber brifingi", "Voucher hazırlama", "Evrak kontrolü", "Araç hazırlığı"),
            @("Tur kalkışı", "Zaman yönetimi", "Yolcu memnuniyeti takibi", "Restoran koordinasyonu", "Uğurlama prosedürü"),
            @("Acente muhasebesi", "İptal ve iade süreçleri", "Müşteri ilişkileri yönetimi", "Pazarlama kanalları", "Forecast analizleri")
        )
    }
    "transfer_operasyonu" = @{
        prefix = "tr12"
        units = @(
            "İş Organizasyonu",
            "Müşteriyi (Misafiri) Karşılama",
            "Müşterinin (Misafirin) Ulaşımını Sağlama"
        )
        topics = @(
            @("Sürücü güvenliği ve SRC", "Araç bakım ve temizlik", "İletişim protokolleri", "Rotalama planları", "İSG kuralları"),
            @("Havalimanı karşılama standı", "İsim tabelası protokolü", "Bagaj teslim ve etiketleme", "İlk izlenim standartları", "Gecikme takibi"),
            @("Güvenli sürüş kuralları", "Misafir konforu (iklimlendirme)", "Rota dışı durumlarda kriz yönetimi", "Otele varış ve bellboy teslimi", "Uğurlama standartları")
        )
    }
    "sosyal_medya" = @{
        prefix = "sm12"
        units = @(
            "E-Ticaret",
            "Sosyal Medya",
            "Veri Analizi ve Grafikler"
        )
        topics = @(
            @("E-ticaret modelleri (B2C, B2B)", "Ödeme altyapıları (3D Secure)", "Online rezervasyon motoru", "Sanal pos güvenliği", "Kişisel veri koruma (KVKK)"),
            @("Instagram ve Facebook otel pazarlaması", "Influencer iş birlikleri", "Görsel içerik kalitesi", "Müşteri mesajları yönetimi", "Online itibar yönetimi"),
            @("Google Analytics takibi", "Dönüşüm oranları (Conversion)", "Tıklama reklamları (PPC)", "Grafik okuma", "Bütçe optimizasyon raporları")
        )
    }
}

Write-Output "Generating questions..."
$questions = @()

# Load custom Alternatif Turizm questions
$at_qs = Get-AlternatifTurizmQuestions
$questions += $at_qs
Write-Output "Loaded $($at_qs.Count) Alternatif Turizm questions."

# Generate remaining templated questions
foreach ($course_id in $remaining_courses.Keys) {
    $cdata = $remaining_courses[$course_id]
    $prefix = $cdata.prefix
    $units = $cdata.units
    $topics = $cdata.topics
    
    $course_q_count = 0
    
    for ($uidx = 0; $uidx -lt $units.Count; $uidx++) {
        $unit = $units[$uidx]
        $utopics = $topics[$uidx]
        
        for ($qnum = 1; $qnum -le 15; $qnum++) {
            $qid = "${prefix}_$($uidx+1)_$qnum"
            $topic = $utopics[($qnum - 1) % $utopics.Count]
            
            $qtext = ""
            $opts = @()
            $cidx = 0
            $expl = ""
            
            if ($qnum -eq 1) {
                $qtext = "$unit sürecinde $topic konusunun en temel amacı aşağıdakilerden hangisidir?"
                $opts = @(
                    "Maliyetleri plansız şekilde azaltmak",
                    "Operasyonel hata payını en aza indirmek ve standartlara uygun, güvenli bir çalışma ortamı sağlamak",
                    "Tüm işleri manuel takibe almak",
                    "Sadece reklam yapmak"
                )
                $cidx = 1
                $expl = "$unit biriminde $topic, operasyonel kalitenin ve güvenliğin korunması için en temel standarttır."
            }
            elseif ($qnum -eq 2) {
                $qtext = "Aşağıdakilerden hangisi $unit kapsamında $topic uygulamalarında dikkat edilmesi gereken hayati bir unsurdur?"
                $opts = @(
                    "Rastgele ve kontrolsüz işlemler yapmak",
                    "Yasal standartlara, hijyen kurallarına ve güvenlik prosedürlerine tam riayet edilmesi",
                    "Sadece en pahalı markaları seçmek",
                    "İşlemleri sürekli ertelemek"
                )
                $cidx = 1
                $expl = "$topic uygulamaları doğrudan yasal güvenlik ve kalite standartlarına tabidir."
            }
            elseif ($qnum -eq 3) {
                $qtext = "Otelcilik ve turizm eğitiminde $topic ile ilgili yapılacak hatalar en çok hangi olumsuz sonuca yol açar?"
                $opts = @(
                    "Hizmet kalitesinin düşmesine, müşteri memnuniyetsizliğine ve yasal cezalara",
                    "Personelin daha yavaş çalışmasına",
                    "Oda fiyatlarının kendiliğinden artmasına",
                    "Hiçbir olumsuz etkisi yoktur"
                )
                $cidx = 0
                $expl = "$topic alanındaki eksiklikler doğrudan kaliteyi düşürür ve kurumsal itibara zarar verir."
            }
            elseif ($qnum -eq 4) {
                $qtext = "Aşağıdakilerden hangisi $unit sürecinde $topic için kullanılan profesyonel bir yöntemdir?"
                $opts = @(
                    "Kulaktan dolma bilgilerle tahminde bulunmak",
                    "Uluslararası standartlarda kabul görmüş kontrol listeleri ve resmi formların kullanılması",
                    "Tüm işi stajyerlere bırakmak",
                    "Sadece seyahat bittikten sonra kontrol yapmak"
                )
                $cidx = 1
                $expl = "Profesyonel turizm işletmeciliğinde $topic her zaman yazılı kontrol formları ve resmi standartlar üzerinden yürütülür."
            }
            elseif ($qnum -eq 5) {
                $qtext = "T.C. MEB müfredatına göre, $unit dersinde $topic konusunun işlenmesindeki temel pedagojik amaç nedir?"
                $opts = @(
                    "Öğrencilerin mesleki etik bilincini, pratik becerilerini ve iş güvenliği hassasiyetlerini geliştirmek",
                    "Sadece teorik sınav geçmelerini sağlamak",
                    "Sektörden uzak durmalarını sağlamak",
                    "Ezber yeteneğini artırmak"
                )
                $cidx = 0
                $expl = "MEB müfredatı, meslek liselerinde $topic gibi pratik konularla öğrencilerin sektöre hazır hale gelmesini hedefler."
            }
            elseif ($qnum -eq 6) {
                $qtext = "Aşağıdaki mesleki yaklaşımlardan hangisi $unit içindeki $topic sürecinde dürüstlük ve ahlak ilkelerine en uygundur?"
                $opts = @(
                    "Fiyatları veya kaliteyi misafirden gizlemek",
                    "Misafire dürüst bilgi sunarak, hakkaniyetli fiyatlandırma ve şeffaf hizmet kalitesi sağlamak",
                    "Sadece lüks konuklara iyi davranmak",
                    "Rakipleri asılsız iddialarla karalamak"
                )
                $cidx = 1
                $expl = "Turizm meslek ahlakının en temel kuralı, dürüstlük, misafirperverlik ve şeffaf hizmet kalitesidir."
            }
            elseif ($qnum -eq 7) {
                $qtext = "$unit operasyonunda $topic sürecini yöneten şefin en önemli idari sorumluluğu hangisidir?"
                $opts = @(
                    "Tüm işleri tek başına yapmak",
                    "Ekibin görev dağılımını adil yapmak, iş güvenliği kurallarını denetlemek ve hizmet kalitesini sürekli kılmak",
                    "Çalışanlar arasında ayrım yapmak",
                    "Hata yapan personeli doğrudan cezalandırmak"
                )
                $cidx = 1
                $expl = "Yöneticiler, hem iş gücünün adil yönetiminden hem de operasyonun standartlara uygun ve güvenli yürümesinden sorumludur."
            }
            elseif ($qnum -eq 8) {
                $qtext = "Misafirlerin $unit kapsamında yer alan $topic hizmetinden duydukları memnuniyeti Tripadvisor gibi online platformlarda paylaşmasının pazarlamaya etkisi nedir?"
                $opts = @(
                    "Hiçbir etkisi yoktur",
                    "Otelin online itibarını yükselterek yeni konukların tercih etme kararını doğrudan olumlu etkiler",
                    "Sadece maliyetleri yükseltir",
                    "Çalışanların dinlenmesini sağlar"
                )
                $cidx = 1
                $expl = "Müşteri yorumları günümüzde en etkili ve güvenilir ücretsiz pazarlama (itibar yönetimi) aracıdır."
            }
            elseif ($qnum -eq 9) {
                $qtext = "Aşağıdakilerden hangisi $unit departmanında $topic verimliliğini artırmanın en sürdürülebilir yoludur?"
                $opts = @(
                    "Personeli sürekli mesaiye bırakmak",
                    "Düzenli hizmet içi eğitimler düzenlemek ve çalışan motivasyonunu yüksek tutmak",
                    "En ucuz malzemeleri tercih etmek",
                    "Teknolojiyi tamamen reddetmek"
                )
                $cidx = 1
                $expl = "Nitelikli iş gücü eğitimi ve yüksek motivasyon, turizmde sürdürülebilir hizmet kalitesinin anahtarıdır."
            }
            elseif ($qnum -eq 10) {
                $qtext = "$unit sırasında $topic ile ilgili bir kriz anında yapılması gereken en doğru ilk müdahale hangisidir?"
                $opts = @(
                    "Panik yapıp olayı gizlemeye çalışmak",
                    "Önceden belirlenmiş acil durum eylem planına göre sakinlikle hareket edip yetkililere ve ilgili departmanlara anında bilgi vermek",
                    "İşi tamamen yarıda bırakıp kaçmak",
                    "Sorumluluğu stajyerlerin üzerine atmak"
                )
                $cidx = 1
                $expl = "Kriz yönetiminde sakinlik, önceden hazırlanmış acil durum planlarına sadık kalınması ve hızlı iletişim hayati önem taşır."
            }
            elseif ($qnum -eq 11) {
                $qtext = "Aşağıdakilerden hangisi $unit standartlarında $topic için kullanılan çevre dostu (ekolojik) bir yaklaşımdır?"
                $opts = @(
                    "Enerji ve su tüketimini en aza indiren teknolojiler ile geri dönüştürülebilir malzemelerin tercih edilmesi",
                    "Tüm atıkları çöpe dökmek",
                    "Plastik malzemelerin kullanımını artırmak",
                    "Sadece ithal kimyasallar kullanmak"
                )
                $cidx = 0
                $expl = "Çevre dostu turizm yaklaşımı, kaynak israfını önleyerek karbon ayak izini düşürmeyi hedefler."
            }
            elseif ($qnum -eq 12) {
                $qtext = "Operasyonel açıdan, $unit içinde $topic takibinin günlük olarak yapılması otel yönetimine ne sağlar?"
                $opts = @(
                    "İşlerin aksamasını, arıza maliyetlerini ve misafir şikayetlerini önceden engelleme imkanı",
                    "Maaşların düşürülmesini",
                    "Otelin yıldız sayısının anında yükselmesini",
                    "Personel sayısının azaltılmasını"
                )
                $cidx = 0
                $expl = "Günlük periyodik denetimler, olası büyük arızaları ve konuk şikayetlerini kaynağında engelleyen koruyucu bir kalkandır."
            }
            elseif ($qnum -eq 13) {
                $qtext = "T.C. MEB müfredatında yer alan $unit konusundaki $topic ile ilgili sınav sorusu hazırlarken hangi kurala KESİNLİKLE uyulmalıdır?"
                $opts = @(
                    "Zararlı veya alkol/uyuşturucu gibi bağımlılık yapıcı maddeler içermeyen, milli ve ahlaki değerlere saygılı örnekler kullanılması",
                    "Sadece ezbere dayalı kelimeler seçilmesi",
                    "Soruların çok uzun tutulması",
                    "Fiyatların çok yüksek gösterilmesi"
                )
                $cidx = 0
                $expl = "Eğitim soruları öğrencilere iyi örnek olmalı; alkol, uyuşturucu veya bağımlılık yapıcı zararlı maddelere asla yer verilmemelidir."
            }
            elseif ($qnum -eq 14) {
                $qtext = "Girişimcilik ve iş planlaması açısından, $unit kapsamında $topic için bütçe hazırlanırken hangisi en büyük riski oluşturur?"
                $opts = @(
                    "Pazar analizini eksik yapmak ve beklenmeyen gider kalemlerini bütçeye eklememek",
                    "Bütçeyi bilgisayarda hazırlamak",
                    "En kaliteli ekipmanları satın almak",
                    "Ekibi önceden kurmak"
                )
                $cidx = 0
                $expl = "Finansal planlamada pazarın gerçekçi analizi ve yedek akçe (acil durum bütçesi) ayrılması hayati öneme sahiptir."
            }
            elseif ($qnum -eq 15) {
                $qtext = "Otelcilikte $unit sürecinde $topic ile ilgili misafir şikayeti alındığında, resepsiyonistin sergilemesi gereken en profesyonel karşılama hangisidir?"
                $opts = @(
                    "Savunmaya geçip hatayı kabul etmemek",
                    "Misafiri sakinlikle ve etkin bir şekilde dinleyip, özür dileyerek hatayı telafi edecek hızlı ve profesyonel çözümü anında sunmak",
                    "Misafire diğer otellere gitmesini tavsiye etmek",
                    "Şikayeti tamamen duymazdan gelmek"
                )
                $cidx = 1
                $expl = "Müşteri şikayetleri dinlenip hızla telafi edildiğinde, misafirin otele olan bağlılığı ve güveni daha da artmaktadır."
            }
            
            $questions += [PSCustomObject]@{
                id = $qid
                courseId = $course_id
                unitIndex = $uidx
                questionText = $qtext
                options = $opts
                correctOptionIndex = $cidx
                explanation = $expl
            }
            
            $course_q_count++
        }
    }
    Write-Output "Generated $course_q_count questions for $course_id."
}

Write-Output "Total questions generated: $($questions.Count)"

# Read original quiz_data.dart
if (-not (Test-Path $QUIZ_FILE)) {
    Write-Error "Could not find $QUIZ_FILE"
}

# Read file using UTF-8 encoding
$content = [System.IO.File]::ReadAllText($QUIZ_FILE, [System.Text.Encoding]::UTF8)

# Find the closing ]; of the list
$last_bracket_idx = $content.LastIndexOf("];")
if ($last_bracket_idx -eq -1) {
    Write-Error "Could not find the closing ]; in quiz_data.dart"
}

# Generate Dart strings
$dart_objects = @()
foreach ($q in $questions) {
    # Escape quotes
    $qtext_esc = $q.questionText.Replace("'", "\'")
    $opt0 = $q.options[0].Replace("'", "\'")
    $opt1 = $q.options[1].Replace("Replace", "\'").Replace("'", "\'")
    $opt2 = $q.options[2].Replace("'", "\'")
    $opt3 = $q.options[3].Replace("'", "\'")
    $expl_esc = $q.explanation.Replace("'", "\'")
    
    $dart_obj = @"
  QuizQuestion(id: '$($q.id)', courseId: '$($q.courseId)', unitIndex: $($q.unitIndex),
    questionText: '$qtext_esc',
    options: ['$opt0', '$opt1', '$opt2', '$opt3'],
    correctOptionIndex: $($q.correctOptionIndex),
    explanation: '$expl_esc',
  ),
"@
    $dart_objects += $dart_obj
}

$new_questions_str = "`n" + ($dart_objects -join "`n") + "`n"

# Split content and inject new questions
$updated_content = $content.Substring(0, $last_bracket_idx) + $new_questions_str + $content.Substring($last_bracket_idx)

# Write back to file with UTF-8 without BOM encoding to match standard
[System.IO.File]::WriteAllText($QUIZ_FILE, $updated_content, [System.Text.Encoding]::UTF8)

Write-Output "Successfully integrated all $($questions.Count) questions into quiz_data.dart!"
