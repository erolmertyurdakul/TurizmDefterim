import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/models/course_model.dart';
import '../data/models/learning_unit_model.dart';
final coursesProvider = Provider.family<List<Course>, String>((ref, grade) {
  if (grade == '9') {
    return [
      const Course(
        title: 'Mesleki Gelişim Atölyesi',
        icon: Icons.work_history_rounded,
        learningUnits: [
          LearningUnit(title: 'Meslek Etiği ve Ahilik', lessonCount: 6, quizCount: 2),
          LearningUnit(title: 'İş Sağlığı ve Güvenliği', lessonCount: 8, quizCount: 3),
          LearningUnit(title: 'Teknolojik Gelişmeler ve Endüstriyel Dönüşüm', lessonCount: 5, quizCount: 2),
          LearningUnit(title: 'Çevre Koruma', lessonCount: 7, quizCount: 3),
          LearningUnit(title: 'Girişimci Fikirler, İş Kurma ve Yürütme', lessonCount: 8, quizCount: 3),
          LearningUnit(title: 'Fikri ve Sınai Mülkiyet Hakları', lessonCount: 6, quizCount: 2),
        ],
      ),
    ];
  } else if (grade == '10') {
    return [
      const Course(
        title: 'Ön Büroda Rezervasyon',
        icon: Icons.desk_rounded,
        learningUnits: [
          LearningUnit(title: 'Rezervasyon Alma', lessonCount: 6, quizCount: 2),
          LearningUnit(title: 'Rezervasyon Kayıt Etme', lessonCount: 8, quizCount: 3),
          LearningUnit(title: 'Rezervasyon Durum Analizi', lessonCount: 5, quizCount: 2),
          LearningUnit(title: 'Diğer Hizmetler için Rezervasyon Yapma', lessonCount: 7, quizCount: 3),
        ],
      ),
      const Course(
        title: 'Konuk Giriş Çıkış İşlemleri',
        icon: Icons.vpn_key_rounded,
        learningUnits: [
          LearningUnit(title: 'Oda Satış Teknikleri', lessonCount: 6, quizCount: 2),
          LearningUnit(title: 'Konuk Giriş Hazırlığı', lessonCount: 8, quizCount: 3),
          LearningUnit(title: 'Konuk Giriş (Check In) İşlemleri', lessonCount: 5, quizCount: 2),
          LearningUnit(title: 'Konuk Çıkış (Check Out) İşlemleri', lessonCount: 7, quizCount: 3),
        ],
      ),
      const Course(
        title: 'Kat Hizmetleri Atölyesi',
        icon: Icons.cleaning_services_rounded,
        learningUnits: [
          LearningUnit(title: 'Kat Ofisi İşlemleri', lessonCount: 6, quizCount: 2),
          LearningUnit(title: 'Oda Temizlik İşlemleri', lessonCount: 8, quizCount: 3),
          LearningUnit(title: 'Yatak Hazırlama İşlemleri', lessonCount: 5, quizCount: 2),
          LearningUnit(title: 'Banyo Temizlik İşlemleri', lessonCount: 7, quizCount: 3),
          LearningUnit(title: 'Genel Alan Temizliği', lessonCount: 6, quizCount: 2),
        ],
      ),
    ];
  } else if (grade == '11') {
    return [
      const Course(
        title: 'Konaklama İşletmeciliği',
        icon: Icons.business_rounded,
        learningUnits: [
          LearningUnit(title: 'Konaklama Endüstrisi', lessonCount: 6, quizCount: 2),
          LearningUnit(title: 'Konaklama İşletmelerinin Departmanları', lessonCount: 8, quizCount: 3),
          LearningUnit(title: 'Konaklama İşletmelerinde İnsan Kaynakları Yönetimi', lessonCount: 5, quizCount: 2),
          LearningUnit(title: 'Konaklama İşletmelerinde Pazarlama', lessonCount: 7, quizCount: 3),
          LearningUnit(title: 'Konaklama İşletmelerinde Yeni Teknolojiler ve Çalışma Hayatı', lessonCount: 6, quizCount: 2),
        ],
      ),
      const Course(
        title: 'Sürdürülebilir Turizm',
        icon: Icons.eco_rounded,
        learningUnits: [
          LearningUnit(title: 'Sürdürülebilir Turizm Kavramı', lessonCount: 6, quizCount: 2),
          LearningUnit(title: 'Sürdürülebilir Turizm Pazarı', lessonCount: 8, quizCount: 3),
          LearningUnit(title: 'Sürdürülebilir Turizm Süreci', lessonCount: 5, quizCount: 2),
        ],
      ),
      const Course(
        title: 'Ön Büro Hizmetleri Atölyesi',
        icon: Icons.desk_rounded,
        learningUnits: [
          LearningUnit(title: 'Sabah ve Akşam Vardiyası İşlemleri', lessonCount: 6, quizCount: 2),
          LearningUnit(title: 'Gece İşlemlerini Yapma', lessonCount: 6, quizCount: 2),
          LearningUnit(title: 'Ön Büroda Tutulan Defterler', lessonCount: 6, quizCount: 2),
          LearningUnit(title: 'Mesleki Matematik Aritmetiği', lessonCount: 6, quizCount: 2),
          LearningUnit(title: 'Mesleki Matematik Hesaplamaları', lessonCount: 6, quizCount: 2),
          LearningUnit(title: 'Tesis İstatistiklerini Çıkarma', lessonCount: 6, quizCount: 2),
          LearningUnit(title: 'Ticari Belgeler', lessonCount: 6, quizCount: 2),
          LearningUnit(title: 'Muhasebe Süreci', lessonCount: 6, quizCount: 2),
          LearningUnit(title: 'Aktif Hesaplar', lessonCount: 6, quizCount: 2),
          LearningUnit(title: 'Pasif Hesaplar', lessonCount: 6, quizCount: 2),
          LearningUnit(title: 'Gelir Tablosu Hesapları', lessonCount: 6, quizCount: 2),
        ],
      ),
      const Course(
        title: 'Kat Hizmetleri Atölyesi',
        icon: Icons.dry_cleaning_rounded,
        learningUnits: [
          LearningUnit(title: 'Tefrişat Temizliği', lessonCount: 6, quizCount: 2),
          LearningUnit(title: 'Çeşitli Yüzeylerin Bakımı ve Yüzeyleri Cilalama İşlemleri', lessonCount: 8, quizCount: 3),
          LearningUnit(title: 'Malzeme Takibini Yapma', lessonCount: 5, quizCount: 2),
          LearningUnit(title: 'Dekorasyon Hizmetlerini Yürütme', lessonCount: 7, quizCount: 3),
          LearningUnit(title: 'Çamaşırhane İşlemleri', lessonCount: 6, quizCount: 2),
          LearningUnit(title: 'Kuru Temizleme İşlemleri', lessonCount: 7, quizCount: 3),
        ],
      ),
    ];
  } else if (grade == '12') {
    return [
      const Course(
        title: 'Alternatif Turizm',
        icon: Icons.explore_rounded,
        learningUnits: [
          LearningUnit(title: 'Alternatif Turizme Giriş', lessonCount: 5, quizCount: 2),
          LearningUnit(title: 'Alternatif Turizm Çeşitleri', lessonCount: 5, quizCount: 2),
        ],
      ),
      const Course(
        title: 'Kuru Temizleme İşlemleri',
        icon: Icons.dry_cleaning_rounded,
        learningUnits: [
          LearningUnit(title: 'İş Organizasyonu', lessonCount: 5, quizCount: 2),
          LearningUnit(title: 'Kuru Temizleme Öncesi Hazırlık İşlemleri', lessonCount: 5, quizCount: 2),
          LearningUnit(title: 'Kuru Temizleme İşlemleri', lessonCount: 5, quizCount: 2),
          LearningUnit(title: 'Günlük/Periyodik Kontrol ve Bakımların Takibi', lessonCount: 5, quizCount: 2),
          LearningUnit(title: 'Kuru Temizleme Gerektirmeyen Tekstil Ürünleri İçin Yıkama İşlemi', lessonCount: 5, quizCount: 2),
        ],
      ),
      const Course(
        title: 'Çamaşırhane İşlemleri',
        icon: Icons.local_laundry_service_rounded,
        learningUnits: [
          LearningUnit(title: 'İş Organizasyonu', lessonCount: 2, quizCount: 2),
          LearningUnit(title: 'Yıkama İşlemi', lessonCount: 3, quizCount: 2),
          LearningUnit(title: 'Ütüleme İşlemi', lessonCount: 2, quizCount: 2),
          LearningUnit(title: 'Depolama İşlemi', lessonCount: 2, quizCount: 2),
        ],
      ),
      const Course(
        title: 'Dünya Seyahat ve Turizm Coğrafyası',
        icon: Icons.map_rounded,
        learningUnits: [
          LearningUnit(title: 'Coğrafya ve Turizm', lessonCount: 3, quizCount: 2),
          LearningUnit(title: 'Su Kaynaklarına Dayalı Turizm Merkezleri', lessonCount: 3, quizCount: 2),
          LearningUnit(title: 'Manzara ve Doğal Yaşam Kaynaklarına Dayalı Turizm Merkezleri', lessonCount: 3, quizCount: 2),
          LearningUnit(title: 'Tarihi Kaynaklara Dayalı Turizm Merkezleri', lessonCount: 3, quizCount: 2),
          LearningUnit(title: 'Şehir ve Kruvaziyer Turizmi Merkezleri', lessonCount: 3, quizCount: 2),
          LearningUnit(title: 'Kültür ve İnanç Turizmi Merkezleri', lessonCount: 3, quizCount: 2),
          LearningUnit(title: 'Sağlık ve Spor Turizmi Merkezleri', lessonCount: 3, quizCount: 2),
        ],
      ),
      const Course(
        title: 'Dünya Kültürleri',
        icon: Icons.public_rounded,
        learningUnits: [
          LearningUnit(title: 'Dünya Kültürlerine Giriş', lessonCount: 8, quizCount: 3),
          LearningUnit(title: 'Dünya Kültür Çeşitleri', lessonCount: 12, quizCount: 4),
        ],
      ),
      const Course(
        title: 'Kongre ve Etkinlik Turizmi',
        icon: Icons.corporate_fare_rounded,
        learningUnits: [
          LearningUnit(title: 'Kongre ve Etkinlik Yönetimine Giriş', lessonCount: 5, quizCount: 2),
          LearningUnit(title: 'Konaklama İşletmelerinde Toplantı ve Etkinlik Hizmetleri', lessonCount: 5, quizCount: 2),
        ],
      ),
      const Course(
        title: 'Gastronomi Turizmi',
        icon: Icons.restaurant_menu_rounded,
        learningUnits: [
          LearningUnit(title: 'Gastronomi Turizmine Giriş', lessonCount: 5, quizCount: 2),
          LearningUnit(title: 'Türkiye\'de ve Dünyada Gastronomi Turizmi', lessonCount: 5, quizCount: 2),
        ],
      ),
      const Course(
        title: 'Tur Operasyonu',
        icon: Icons.flight_takeoff_rounded,
        learningUnits: [
          LearningUnit(title: 'Turizm ve Rehberlik', lessonCount: 3, quizCount: 2),
          LearningUnit(title: 'Rehberlik Hizmetleri', lessonCount: 3, quizCount: 2),
          LearningUnit(title: 'Paket Tur Hazırlama', lessonCount: 3, quizCount: 2),
          LearningUnit(title: 'Tur Operasyonu için Hazırlık Yapma', lessonCount: 3, quizCount: 2),
          LearningUnit(title: 'Tur Operasyonu Yapma', lessonCount: 3, quizCount: 2),
          LearningUnit(title: 'Acente Operasyonlarını Gerçekleştirme', lessonCount: 3, quizCount: 2),
        ],
      ),
       const Course(
        title: 'Transfer Operasyonu',
        icon: Icons.directions_bus_rounded,
        learningUnits: [
          LearningUnit(title: 'İş Organizasyonu', lessonCount: 7, quizCount: 2),
          LearningUnit(title: 'Misafiri Karşılama', lessonCount: 8, quizCount: 2),
          LearningUnit(title: 'Misafirin Ulaşımını Sağlama', lessonCount: 8, quizCount: 2),
          LearningUnit(title: 'Transferi Sonlandırma', lessonCount: 6, quizCount: 2),
        ],
      ),
      const Course(
        title: 'Sosyal Medya',
        icon: Icons.share_rounded,
        learningUnits: [
          LearningUnit(title: 'E-Ticaret', lessonCount: 4, quizCount: 2),
          LearningUnit(title: 'Sosyal Medya', lessonCount: 4, quizCount: 2),
          LearningUnit(title: 'Veri Analizi ve Grafikler', lessonCount: 4, quizCount: 2),
        ],
      ),
    ];
  }
  return [];
});
