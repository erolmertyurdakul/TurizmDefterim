import '../domain/models/scenario_models.dart';

class ScenarioDatabase {
  static const List<Scenario> scenarios = [
    // =========================================================================
    //  1. BELLBOY SCENARIOS (ÖN BÜRO)
    // =========================================================================
    Scenario(
      id: 'bellboy_baggage_mixup',
      title: 'Acentede Bagaj Karışıklığı Krizi',
      department: 'Ön Büro',
      description: 'Grup girişleri sırasında iki farklı misafirin bagajları karıştı. Misafirlerden biri valizindeki özel eşyalarına acil ihtiyacı olduğunu belirtiyor. Bellboy olarak ne yapacaksın?',
      imageUrl: 'assets/images/bellboy.png',
      steps: {
        'step_1': ScenarioStep(
          id: 'step_1',
          title: 'Karışan Etiketler',
          story: 'Yoğun bir tur otobüsü girişi sırasında, yeni evli misafir çiftin valizi ile daimi kurumsal misafirimiz olan beyefendinin valizleri karıştı. Misafir çift odalarında kendileri için önemli eşyalarının olduğunu ve hemen almaları gerektiğini söylüyor. Misafir beyefendi ise çoktan önemli bir iş toplantısı için otelden ayrıldı ve valizi yanına aldı.',
          imageUrl: 'assets/images/bellboy.png',
          options: [
            ScenarioOption(
              text: 'Misafir beyefendiyi cepten ara, durumu anlat ve doğru valizlerin değişiminin yapılabilmesi için motorlu kurye gönderin',
              feedback: 'Erol Hoca Analizi: "Dürüstlük ve hızlı iletişim doğru yoldur. Beyefendi durumu anlayışla karşıladı ve kurye yola çıktı. Ancak kurye trafiğe takılmış, şimdi valiz gelene kadar telaşlı misafir çifti nasıl teskin edeceksiniz?"',
              nextStepId: 'step_2_good',
            ),
            ScenarioOption(
              text: 'Misafir çifte durumun sistemsel bir hata olduğunu söyleyip geçiştirin ve lobide bekletin',
              feedback: 'Erol Hoca Analizi: "Yalan söylemek otelcilik ahlakına sığmaz. Çift valiz gelmeyince gerçeği öğrendi ve resepsiyonu birbirine kattı. Durum artık bir güven krizine dönüştü."',
              nextStepId: 'step_2_bad',
            ),
          ],
        ),
        'step_2_good': ScenarioStep(
          id: 'step_2_good',
          title: 'Lobi Bekleyişi ve Sağlık Durumu',
          story: 'Kurye yola çıktı ancak akşam trafiği yüzünden valizin gelmesi en az 45 dakika sürecek. Bunu duyan misafir kendisini iyi hissetmediğini belirtti ve lobideki koltuğa uzandı.',
          imageUrl: 'assets/images/bellboy.png',
          options: [
            ScenarioOption(
              text: 'Otel revirindeki hekimi çağırıp misafirin sağlık durumunun kontrolünün yapılmasını sağlayın',
              feedback: 'Erol Hoca Analizi: "Güzel, misafirle ilgilendiniz ve revirdeki hekimi çağırarak misafirin sağlığına önem verdiniz. Yoğun bekleyişin ardından valizler geldi, süreci nasıl sonlandıracaksınız?"',
              nextStepId: 'step_3_excellent',
            ),
            ScenarioOption(
              text: 'Lobide soğuk bitki çayı ikram ederek misafirin kurye gelene kadar yatışmasını sağlayın',
              feedback: 'Erol Hoca Analizi: "Misafirin rahatsızlık durumunda bitki çayı ile geçiştirmek yerine otel hekimini çağırmak ve kontrol yapılmasını sağlamak hem ilgilendiğinizi gösterir hem de misafirin sağlık durumu için daha uygun bir prosedürdür. Yoğun bekleyişin ardından valizler geldi, süreci nasıl sonlandıracaksınız?"',
              nextStepId: 'step_3_neutral',
            ),
          ],
        ),
        'step_2_bad': ScenarioStep(
          id: 'step_2_bad',
          title: 'Çiftin Öfkesi Dinmiyor',
          story: 'Misafirler geçiştirildiklerini anlayıp genel müdüre şikayette bulunacaklarını belirtiyorlar. Bu esnada ayrılan misafir beyefendi valizde kendi eşyalarının olmadığını fark edip oteli aradı.',
          imageUrl: 'assets/images/bellboy.png',
          options: [
            ScenarioOption(
              text: 'Gerçeği itiraf et, özür dile ve hemen misafir beyefendiye valizleri alması için kurye gönder',
              feedback: 'Erol Hoca Analizi: "Geç gelen dürüstlük zararı azaltır ama prestij kaybını önlemez. Kurye ücretini ödedik ve misafirleri zar zor sakinleştirdik. Süreci nasıl sonlandıracaksınız?"',
              nextStepId: 'step_3_neutral',
            ),
            ScenarioOption(
              text: 'Suçu stajyer bellboya atıp kendinizi savunun, misafirlerin beklemesini söyleyin',
              feedback: 'Erol Hoca Analizi: "Korkunç bir davranış! Sorumluluktan kaçıp iş arkadaşını suçlamak profesyonel ahlaka sığmaz. Genel müdür devreye girdi."',
              nextStepId: 'step_3_critical',
            ),
          ],
        ),
        'step_3_excellent': ScenarioStep(
          id: 'step_3_excellent',
          title: 'Mutlu Son ve Sadakat Jesti',
          story: 'Kurye valizi getirdi, valiz teslim edildi. Hekimin kontrolü sayesinde misafir çift kendilerini çok daha iyi hissediyor ve otelin ilgisinden çok etkilendiler.',
          imageUrl: 'assets/images/bellboy.png',
          options: [
            ScenarioOption(
              text: 'Misafirlere otel adına ücretsiz alakart akşam yemeği ikram edilmesi için şefinizle görüşün',
              feedback: 'Erol Hoca Analizi: "İşte bu! Harika bir toparlama jestiyle krizi sadık bir misafir kazanma fırsatına çevirdin!"',
              nextStepId: null,
            ),
            ScenarioOption(
              text: 'Odaya yerleşmelerine yardımcı ol',
              feedback: 'Erol Hoca Analizi: "Güzel, standart bir hizmet sundun. Kriz çözüldü fakat ekstra bir sadakat jesti yapabilseydin çok daha unutulmaz olurdu."',
              nextStepId: null,
            ),
          ],
        ),
        'step_3_neutral': ScenarioStep(
          id: 'step_3_neutral',
          title: 'Gecikmeli Çözüm ve Telafi',
          story: 'Valizler nihayet otele ulaştı ve teslim edildi. Ancak misafirler yaşanan gecikmeden ve stresten dolayı oldukça gerginler. Durumu yumuşatmak gerekiyor.',
          imageUrl: 'assets/images/bellboy.png',
          options: [
            ScenarioOption(
              text: 'Şefinize danışarak misafirlerin odalarına ücretsiz meyve tabağı gönderilmesini sağlayın ve samimi bir özür mektubu bırakın',
              feedback: 'Erol Hoca Analizi: "Makul bir telafi. Meyve tabağı ve yazılı özür misafirlerin kırgınlığını büyük ölçüde giderdi. Fena değil."',
              nextStepId: null,
            ),
            ScenarioOption(
              text: 'Sadece kuru bir özür dileyip bagajlarını odalarına bırakın',
              feedback: 'Erol Hoca Analizi: "Yetersiz bir yaklaşım. Yaşanan onca stresten sonra sadece kuru bir özür misafiri memnun etmeye yetmedi, otelden buruk ayrılacaklar."',
              nextStepId: null,
            ),
          ],
        ),
        'step_3_critical': ScenarioStep(
          id: 'step_3_critical',
          title: 'Hukuki Sorun ve Cezai İşlem',
          story: 'Ayrılan misafir beyefendi ihmaliniz ve gecikme yüzünden iş toplantısını kaçırdı ve acentenizle olan kurumsal anlaşmasını askıya aldı. Misafir çift ise genel müdürün odasında durumu şikayet ediyor.',
          imageUrl: 'assets/images/bellboy.png',
          options: [
            ScenarioOption(
              text: 'Durumu genel müdüre dürüstçe raporladın ve aldığın idari cezayı kabul ettin. Genel müdür misafirlere 1 gece konaklama hediye etti ve misafirleri odaya yerleştirdin',
              feedback: 'Erol Hoca Analizi: "Zararın neresinden dönülse kardır. Dürüst raporlama işini kaybetmeni önledi ama ihmalkarlığın otel bütçesine ve itibarına ağır zarar verdi. Misafirler 1 gecelik konaklama hediyesine rağmen otele düşük puan verdi."',
              nextStepId: null,
            ),
            ScenarioOption(
              text: 'Genel müdürün önünde de savunma yapmaya çalış, suçlamaları kabul etme',
              feedback: 'Erol Hoca Analizi: "Büyük hüsran! Hem dürüst davranmadınız hem de otelin prestijli bir kurumsal misafirini kaybettirdiniz. İyi bir turizm personeli olmak için önünüzde daha uzun bir yol var."',
              nextStepId: null,
            ),
          ],
        ),
      },
    ),

    // =========================================================================
    //  2. REZERVASYON SORUMLUSU SCENARIOS (ÖN BÜRO)
    // =========================================================================
    Scenario(
      id: 'reservation_overbooking',
      title: 'Rezervasyon Çakışması Krizi',
      department: 'Ön Büro',
      description: 'Acenteden gelen büyük bir grup ile doğrudan rezervasyon yapan bir aile çakıştı. Overbooking söz konusu yani boş oda yok. Ne karar vereceksin?',
      imageUrl: 'assets/images/reservation.png',
      steps: {
        'step_1': ScenarioStep(
          id: 'step_1',
          title: 'Çifte Kayıt Hatası',
          story: 'Overbooking yapılmasından dolayı, otelin son odası hem bir İtalyan turist grubundan bir çifte hem de 3 çocuklu yerli bir aileye aynı anda satılmış. İki taraf da lobide giriş yapmak üzere bekliyor.',
          imageUrl: 'assets/images/reservation.png',
          options: [
            ScenarioOption(
              text: 'Şefinize danışarak aileyi aynı standartta yakın bir otele ücretsiz transfer edin, tüm ücretlerini karşılayın ve akşam yemeği jesti sunun',
              feedback: 'Erol Hoca Analizi: "Mantıklı kriz yönetimi. İtalyan grubunu bölmediniz ve aileyi ikna edip telafi sundunuz. Ancak ailenin yeni gittiği otelde de pürüz çıktı."',
              nextStepId: 'step_2_good',
            ),
            ScenarioOption(
              text: 'Gruptan 2 kişiyi başka otele göndermeye çalışıp grubu bölmeyi teklif edin',
              feedback: 'Erol Hoca Analizi: "Acente grubu bir arkadaş grubuydu ve asla bölünmek istemiyorlardı. Acente rehberi lobiye geldi ve sertçe sözleşmedeki garantili oda maddesini hatırlatarak itiraz ediyor."',
              nextStepId: 'step_2_bad',
            ),
          ],
        ),
        'step_2_good': ScenarioStep(
          id: 'step_2_good',
          title: 'Yeni Oteldeki Beklenmedik Sorun',
          story: 'Gönderdiğiniz 4 yıldızlı anlaşmalı otelde ek yatağın eksik olduğu anlaşıldı ve aile öfkeyle sizi arayarak "Bizi kandırdınız, burası bizim seçtiğimiz standartta değil!" diye şikayet ediyor.',
          imageUrl: 'assets/images/reservation.png',
          options: [
            ScenarioOption(
              text: 'Hemen gönderdiğiniz oteli arayıp durumun size iletildiğini belirtin ve misafirle acil olarak ilgilenmeleri gerektiğini söyleyin.',
              feedback: 'Erol Hoca Analizi: "Harika! Misafiri yarı yolda bırakmayıp takibini yaptınız. Aile bu ilgiden sonra sakinleşti. Şimdi son adımı atın."',
              nextStepId: 'step_3_excellent',
            ),
            ScenarioOption(
              text: 'Diğer otelin yönetimiyle görüşmeleri gerektiğini misafire söyleyin ve ilgilenmeyin',
              feedback: 'Erol Hoca Analizi: "Sorumluluktan kaçamazsınız! Misafiri siz gönderdiniz. Aile otel için Tripadvisor\'da kötü yorum yazacağını söylüyor."',
              nextStepId: 'step_3_neutral',
            ),
          ],
        ),
        'step_2_bad': ScenarioStep(
          id: 'step_2_bad',
          title: 'Acentenin Resmi İhtarı',
          story: 'Grup rehberi acente merkezine haber verdi. Acente yetkilisi oteli arayıp sözleşmeye göre garantili oda maddesinin olduğunu hatırlattı. Ayrıca eğer grup bölünürse tüm grubu çekeceğini ve sezonluk anlaşmayı iptal edeceklerini bildirdi.',
          imageUrl: 'assets/images/reservation.png',
          options: [
            ScenarioOption(
              text: 'Hemen hatayı kabul edip gruptan özür dileyin. Yerli ailenin yakındaki aynı standartlardaki bir otele masrafların otelce karşılanarak gönderilmesi için şefinize danışın',
              feedback: 'Erol Hoca Analizi: "Krizi geç de olsa toparladınız. Süreci nasıl sonlandıracaksınız?"',
              nextStepId: 'step_3_neutral',
            ),
            ScenarioOption(
              text: 'Rehbere gayriresmi yollarla ücretsiz oda teklif ederek onu ikna etmeye çalışın, grubu bölmekte ısrarcı olun',
              feedback: 'Erol Hoca Analizi: "Meslek ahlakı sıfır! Bu gayriresmi teklif skandala dönüştü ve acente otelle ilişkisini kesmek istiyor. Genel müdür seni odasına çağırıyor."',
              nextStepId: 'step_3_critical',
            ),
          ],
        ),
        'step_3_excellent': ScenarioStep(
          id: 'step_3_excellent',
          title: 'Krizi Fırsata Çevirmek',
          story: 'Gösterdiğin yoğun ilgi sayesinde ailenin memnuniyeti çok yüksek. Hatta bir sonraki tatillerini de doğrudan otelimizden yapacaklarını söylüyorlar.',
          imageUrl: 'assets/images/reservation.png',
          options: [
            ScenarioOption(
              text: 'Aileye sonraki konaklamaları için %20 indirim çeki verilmesini ve çocuklara otel logolu oyuncaklar hediye edilmesini şefinizle görüşün',
              feedback: 'Erol Hoca Analizi: "Overbooking krizini sadık bir misafir kazanarak kapattınız. İndirim çekleri ve promosyonlar konusunda şefinize danıştınız. Ancak ikramlar konusunda tedbirli olmanız gerektiğini unutmamalısınız."',
              nextStepId: null,
            ),
            ScenarioOption(
              text: 'Misafirlerin sorunu çözüldü, kendilerini arayıp iyi tatiller dilediniz',
              feedback: 'Erol Hoca Analizi: "Gösterdiğiniz performans sayesinde misafirler memnun kaldılar, ancak krizin tatsızlığını tamamen gidermek için şefinize danışarak misafirlere küçük bir indirim çeki veya jest sunmanız daha uygun olabilirdi."',
              nextStepId: null,
            ),
          ],
        ),
        'step_3_neutral': ScenarioStep(
          id: 'step_3_neutral',
          title: 'Zarar ve İtibar Toparlama',
          story: 'Kriz son dakikada çözüldü, ek yatak odaya koyuldu ve misafirler yerleştirildi. Ancak otelimizin misafir gözündeki güvenilirliği sarsıldı. Gelecek sezon için ne yapacaksın?',
          imageUrl: 'assets/images/reservation.png',
          options: [
            ScenarioOption(
              text: 'Aileye sonraki konaklamaları için %20 indirim çeki verilmesini ve çocuklara otel logolu oyuncaklar hediye edilmesini şefinizle görüşün',
              feedback: 'Erol Hoca Analizi: "Gösterdiğiniz performansla misafir memnuniyetini sağladınız. Ancak ilk önce size gelmiş bir misafirin diğer otelin eksikliklerinden dolayı yaşadığı sıkıntıyı kendi ekibinizle çözmeyip topu onlara atmak profesyonelliğe sığmaz. Neyse ki misafirler indirimden etkilenip yine de kötü yorum yazmadılar."',
              nextStepId: null,
            ),
            ScenarioOption(
              text: 'Misafirleri bir daha aramayın ve hatayı görmezden gelerek konuyu kapatın',
              feedback: 'Erol Hoca Analizi: "Olamaz! İlk önce size gelmiş bir misafirin diğer otelin eksikliklerinden dolayı yaşadığı sıkıntıyı kendi ekibinizle çözmeyip topu onlara atmak profesyonelliğe sığmaz. Unutmayın misafirlerin bir kere gelmesi değil, sürekli misafirler (repeat guests) olmaları bir otel için çok önemlidir."',
              nextStepId: null,
            ),
          ],
        ),
        'step_3_critical': ScenarioStep(
          id: 'step_3_critical',
          title: 'İş Akdi Feshi ve Ağır İtibar Kaybı',
          story: 'Genel müdür acentenin sezonluk sözleşmeyi iptal etmek istemesinin otele sezonun ortasında ciddi bir ciro kaybettirebileceğini söyledi. Rüşvet girişimi sebebiyle genel müdür işinizi sonlandırmayı düşünüyor.',
          imageUrl: 'assets/images/reservation.png',
          options: [
            ScenarioOption(
              text: 'Hatanızı dürüstçe kabul edin, savunmanızı yazın ve istifayı sunun',
              feedback: 'Erol Hoca Analizi: "Dürüstçe istifa ettiniz ve mesleki ahlakı çiğnemenin bedelini işinizle ödediniz. Dürüstlük ve çözüm odaklılık bir turizm personeli için vazgeçilmez iki değerdir."',
              nextStepId: null,
            ),
            ScenarioOption(
              text: 'Bunun mesleki açıdan uygun olduğunu savunun',
              feedback: 'Erol Hoca Analizi: "Hem suçlu hem güçlü! Hem oteli büyük zarara uğratmak üzeresiniz hem de meslek ahlakından bir habersiniz. İşten çıkarıldığınız gibi artık başka bir otelde de iş bulamayacaksınız."',
              nextStepId: null,
            ),
          ],
        ),
      },
    ),

    // =========================================================================
    //  3. RECEPTIONIST SCENARIOS (ÖN BÜRO)
    // =========================================================================
    Scenario(
      id: 'receptionist_safe_theft',
      title: 'Kayıp Kasa ve Hırsızlık İddiası',
      department: 'Ön Büro',
      description: 'Misafir odasındaki kasadan 2000 dolar çalındığını iddia ediyor ve kat görevlisini suçluyor. Ne yapmalısın?',
      imageUrl: 'assets/images/receptionist.png',
      steps: {
        'step_1': ScenarioStep(
          id: 'step_1',
          title: 'Hırsızlık İthamı',
          story: '404 numaralı odada kalan yabancı konuk, akşam odasına döndüğünde kasayı açtığını ve içindeki 2000 doların eksik olduğunu söyledi. Öğlen temizliğe giren kat görevlisi olan hanımefendiyi doğrudan hırsızlıkla suçluyor ve lobide bağırıyor.',
          imageUrl: 'assets/images/receptionist.png',
          options: [
            ScenarioOption(
              text: 'Misafiri hemen sakin bir ofise alın, sakinleştirin ve kasa log raporunu (okuma cihazıyla) çıkartıp inceleme başlatın',
              feedback: 'Erol Hoca Analizi: "Güzel ve soğukkanlı bir yönetim! Kasa okuma cihazı (CEU) kasaya hangi saatte girildiğini gösterir. Raporda kasanın misafirin kendi şifresiyle açıldığı görünüyor. Şimdi ne yapacaksınız?"',
              nextStepId: 'step_2_good',
            ),
            ScenarioOption(
              text: 'Kat görevlisi hanımefendiyi hemen lobiye çağırıp misafirin önünde sorgulayın, işten çıkarmakla tehdit edin',
              feedback: 'Erol Hoca Analizi: "Çok yanlış! Personeli delilsiz suçlamak meslek ahlakına aykırıdır ve mobbing\'e girer. Kat görevlisi hanımefendi ağlayarak sizi yönetime şikayet edeceğini söyledi. Kriz lobiye taştı."',
              nextStepId: 'step_2_bad',
            ),
          ],
        ),
        'step_2_good': ScenarioStep(
          id: 'step_2_good',
          title: 'Kendi Şifresiyle Açılan Kasa',
          story: 'Log raporuna göre kasa misafirin kendi şifresiyle saat 14:15\'te açılmış. Kat görevlisi hanımefendi ise odaya saat 11:00\'de girmişti. Misafir hala hata olduğunu savunuyor.',
          imageUrl: 'assets/images/receptionist.png',
          options: [
            ScenarioOption(
              text: 'Şefinize bilgi verdikten sonra log raporunu misafire kibarca gösterin, polise haber vererek resmi inceleme başlatmayı teklif edin',
              feedback: 'Erol Hoca Analizi: "Polis kelimesini duyan misafir gerildi. Cebini aradı ve parayı dün akşam ceket cebinde unuttuğunu hatırlayıp özür diledi! Son adımı planlayın."',
              nextStepId: 'step_3_excellent',
            ),
            ScenarioOption(
              text: 'Misafirle tartışmaya girmemek için şefinizle görüşerek paranın otel sigortasından ödenmesini teklif edin',
              feedback: 'Erol Hoca Analizi: "Yanlış! Log raporu haklılığımızı kanıtlamışken otel bütçesini haksız yere harcamak disiplinsizliktir."',
              nextStepId: 'step_3_neutral',
            ),
          ],
        ),
        'step_2_bad': ScenarioStep(
          id: 'step_2_bad',
          title: 'Yönetim Baskısı',
          story: 'Kat görevlisi hanımefendinin yöneticisi haksız bir suçlama olduğunu söyledi. Misafir ise parasını çantasının astarında unuttuğunu farkedip bunu söyleyip hiçbir şey olmamış gibi odasına çıktı.',
          imageUrl: 'assets/images/receptionist.png',
          options: [
            ScenarioOption(
              text: 'Kat görevlisi hanımefendiden tüm personel önünde özür dileyin',
              feedback: 'Erol Hoca Analizi: "Geç gelen adalet. Elinizde personelin suçlu olduğuna dair deliliniz olmadığı halde olayı açıklığa kavuşturmaya çalışmak yerine misafire yaranmaya çalışmanın bedeli ağır oldu. Şimdi süreci nasıl sonlandıracaksınız?"',
              nextStepId: 'step_3_neutral',
            ),
            ScenarioOption(
              text: 'Kat görevlisini bir yanlışlık olmuş deyip geçiştirin',
              feedback: 'Erol Hoca Analizi: "Çok kötü! Personeline değer vermeyen bir otel olarak adımız lekelendi ve kat personellerinin tamamı bundan huzursuz oldu."',
              nextStepId: 'step_3_critical',
            ),
          ],
        ),
        'step_3_excellent': ScenarioStep(
          id: 'step_3_excellent',
          title: 'Çalışan Onuru ve Otel Güvenliği',
          story: 'Misafir hatasını kabul etti ve kat görevlisi hanımefendiden lobide özür diledi. Kat görevlisi hanımefendi kendisine sahip çıktığın için sana minnettar.',
          imageUrl: 'assets/images/receptionist.png',
          options: [
            ScenarioOption(
              text: 'Şefinizle görüşerek kat görevlisi hanımefendinin yaşadığı olumsuz durumdan dolayı motivasyonunun kırılmasını önlemek için kendisine bir hediye verin ve misafirin "asılsız iddia" uyarısı ekleyin',
              feedback: 'Erol Hoca Analizi: "Gösterdiğiniz performans, bir yönetici vizyonunu yansıtmaktadır. Personeli haksız ithamlardan korudunuz ve otelin güvenilir imajını sağlam tuttunuz. Personel motivasyonunu düşünmeniz ve dosya uyarısı gibi idari adımlar için şefinizle görüşmeniz de oldukça uygundu."',
              nextStepId: null,
            ),
            ScenarioOption(
              text: 'Misafirin özrünü kabul edip odasına uğurlayın',
              feedback: 'Erol Hoca Analizi: "Gösterdiğiniz performans sayesinde kriz çözüldü ve personeliniz aklandı. Ancak haksız yere suçlanan kat görevlisini motive edecek bir takdir jesti için şefinize danışmanız daha uygun olabilirdi. Ayrıca asılsız iddiayı misafir dosyasına kaydetmeniz, ileriki dönemlerde oluşabilecek aynı misafir kaynaklı benzer sorunlarda yardımcı olabilir."',
              nextStepId: null,
            ),
          ],
        ),
        'step_3_neutral': ScenarioStep(
          id: 'step_3_neutral',
          title: 'Hatalı Yönetimin Bilançosu',
          story: 'Kayıp para krizi bitti fakat otel haklı olmasına rağmen finansal zarara uğradı. Kat hizmetleri personelleri kanıt olmasına rağmen kendilerini savunmadığınız için artık huzursuz çalışıyorlar.',
          imageUrl: 'assets/images/receptionist.png',
          options: [
            ScenarioOption(
              text: 'Şefinize danışarak tüm kat hizmetleri personeline teşekkür yemeği düzenleyin veya personele bir hediye sunun ve bu tarz durumların önüne geçmek adına bir eğitim düzenleyin',
              feedback: 'Erol Hoca Analizi: "Log raporu elimizdeyken bütçeden haksız ödeme teklif etmeniz hataydı. Şefinize danışarak teşekkür yemeği düzenlemeniz en azından personelin kırgınlığını biraz giderdi. Bu tür finansal kararlarda dikkatli olmanızı öneririm."',
              nextStepId: null,
            ),
            ScenarioOption(
              text: 'Konuyu kapatın, "Zamanla unutulur" diyerek işinize dönün',
              feedback: 'Erol Hoca Analizi: "Gösterdiğiniz performans yetersiz kaldı. Log raporuna rağmen haksız ödeme teklif ettiniz. Personeller otelin can damarıdır. Ama siz personelin yaşadığı moral bozukluğunu gidermek için hiçbir adım atmadınız."',
              nextStepId: null,
            ),
          ],
        ),
        'step_3_critical': ScenarioStep(
          id: 'step_3_critical',
          title: 'İdari Yaptırım ve Sicil Karalanması',
          story: 'Durumu duyan departman yöneticisi sizi odasına çağırdı. Meslek ahlakına aykırı davranıp bir özür bile dilemediğiniz için işinize son verilecek.',
          imageUrl: 'assets/images/receptionist.png',
          options: [
            ScenarioOption(
              text: 'Hatanızı dürüstçe kabul edin, savunmanızı yazın ve istifayı sunun',
              feedback: 'Erol Hoca Analizi: "Dürüstçe istifa ettiniz ve mesleki ahlakı çiğnemenin bedelini işinizle ödediniz. Dürüstlük, kibarlık ve çözüm odaklılık bir turizm personeli için vazgeçilmez üç değerdir."',
              nextStepId: null,
            ),
            ScenarioOption(
              text: 'Departman müdürünüze özür dilemek zorunda olmadığınızı söyleyin',
              feedback: 'Erol Hoca Analizi: "Hem suçlu hem de dikbaşlı bir tavır gösterdiniz. Kendi personelinizi suçlayıp istifaya zorlamak, hatanızı telafi etmeye çalışmamak ve üstüne dik başlılık yapmak hem otel itibarını zedeler hem de kariyerinizi. Bu seçimler sonucunda hem işinizden oldunuz hem de başka bir otelde çalışma imkanını tamamen kaybettiniz."',
              nextStepId: null,
            ),
          ],
        ),
      },
    ),
  ];
}
