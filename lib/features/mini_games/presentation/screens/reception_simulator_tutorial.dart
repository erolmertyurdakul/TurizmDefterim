import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Resepsiyon Simülatörü - İnteraktif Eğitim Rehberi
/// Ön büro personeli yetiştirmek için tasarlanmış 5 sayfalık tutorial.
class ReceptionSimulatorTutorial extends StatefulWidget {
  final VoidCallback onComplete;
  const ReceptionSimulatorTutorial({super.key, required this.onComplete});

  @override
  State<ReceptionSimulatorTutorial> createState() =>
      _ReceptionSimulatorTutorialState();
}

class _ReceptionSimulatorTutorialState
    extends State<ReceptionSimulatorTutorial> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  static const _pages = [
    _TutorialPage(
      icon: Icons.notifications_active_outlined,
      title: 'Ön Büro Simülatörüne\nHoş Geldiniz!',
      description:
          'Bir otel resepsiyon görevlisi olarak göreviniz, misafirleri doğru odaya yerleştirmek ve ihtiyaçlarını karşılamaktır.\n\n'
          'Stajyerlikten Genel Müdürlüğe uzanan 8 seviyeli bir kariyer yolculuğu sizi bekliyor!',
      gradient: [Color(0xFF0E918C), Color(0xFF17B5B0)],
    ),
    _TutorialPage(
      icon: Icons.people_outline_rounded,
      title: 'Misafiri Tanıyın',
      description:
          'Her misafir farklı bir profilde gelir:\n\n'
          '👤 Bireysel Misafir — Standart ihtiyaçlar\n'
          '💼 İş İnsanı — Konforlu oda, sabırsız\n'
          '👥 Aile — Geniş oda ihtiyacı\n'
          '🌟 VIP — En lüks hizmet, yüksek puan\n'
          '♿ Özel Gereksinimli — Erişilebilir oda şart\n\n'
          'Diyaloğu dikkatlice okuyun, ipuçları orada!',
      gradient: [Color(0xFF205295), Color(0xFF2C74B3)],
    ),
    _TutorialPage(
      icon: Icons.bed_outlined,
      title: 'Doğru Odayı Seçin',
      description:
          'Otelde 9 farklı oda tipi bulunur:\n\n'
          '🏠 Standart Room\n'
          '📐 Corner Room\n'
          '👔 Executive Room\n'
          '👨‍👩‍👧‍👦 Family Room\n'
          '♿ Handicapped Room\n'
          '🚪 Connecting Room\n'
          '🧱 Adjoining Room\n'
          '🏨 Suite Room\n'
          '👑 Presidential Suite\n\n'
          'Seviye ilerledikçe yeni oda tipleri açılır.',
      gradient: [Color(0xFF8B5CF6), Color(0xFFA78BFA)],
    ),
    _TutorialPage(
      icon: Icons.restaurant_outlined,
      title: 'Pansiyon Durumunu\nBelirleyin',
      description:
          'Misafirin yemek talebine göre uygun pansiyon tipini seçin:\n\n'
          '🚫 Room Only (RO)\n'
          '☕ Bed & Breakfast (BB)\n'
          '🍽️ Half Board (HB)\n'
          '🍴 Full Board (FB)\n'
          '🌟 All Inclusive (AI)\n'
          '👑 Ultra All Inclusive (UAI)\n\n'
          'Bu kısaltmaları öğrenmek mesleki kariyerinizde size kolaylık sağlayacaktır.',
      gradient: [Color(0xFFE07A3A), Color(0xFFE8AA42)],
    ),
    _TutorialPage(
      icon: Icons.workspace_premium_outlined,
      title: 'İtibarınızı Koruyun',
      description:
          'Her doğru check-in puanınızı ve otelinizin itibarını artırır.\n\n'
          '✅ Doğru Eşleşme → +100 puan\n'
          '⚠️ Kısmi Eşleşme → +30 puan\n'
          '❌ Yanlış Eşleşme → -50 puan ve itibar kaybı\n'
          '😡 Misafir Bekler → -20 itibar\n\n'
          '🔥 Kombo Yapın → Üst üste doğru cevaplar verdikçe artan puan çarpanı\n\n'
          'İtibar sıfıra düşerse otel kapanır!',
      gradient: [Color(0xFFFF6B6B), Color(0xFFFF8E8E)],
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A1628),
      body: SafeArea(
        child: Column(
          children: [
            // Üst bar — Atla butonu
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.close_rounded, color: Colors.white54),
                    onPressed: widget.onComplete,
                  ),
                  Text(
                    '${_currentPage + 1} / ${_pages.length}',
                    style: GoogleFonts.inter(
                      color: Colors.white54,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  TextButton(
                    onPressed: widget.onComplete,
                    child: Text(
                      'Atla',
                      style: GoogleFonts.inter(
                        color: Colors.white54,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Sayfalar
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: _pages.length,
                onPageChanged: (i) => setState(() => _currentPage = i),
                itemBuilder: (context, index) {
                  final page = _pages[index];
                  return _buildPage(page);
                },
              ),
            ),

            // Alt kısım — Dot indikatörler + Buton
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
              child: Column(
                children: [
                  // Dot indikatörler
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(_pages.length, (i) {
                      final isActive = i == _currentPage;
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        width: isActive ? 24 : 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: isActive
                              ? _pages[_currentPage].gradient[0]
                              : Colors.white24,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: 24),

                  // İleri / Başla butonu
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: () {
                        if (_currentPage < _pages.length - 1) {
                          _pageController.nextPage(
                            duration: const Duration(milliseconds: 400),
                            curve: Curves.easeInOut,
                          );
                        } else {
                          widget.onComplete();
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _pages[_currentPage].gradient[0],
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 8,
                        shadowColor: _pages[_currentPage].gradient[0]
                            .withValues(alpha: 0.5),
                      ),
                      child: Text(
                        _currentPage < _pages.length - 1
                            ? 'Devam Et'
                            : '🎮 Haydi Başlayalım!',
                        style: GoogleFonts.outfit(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPage(_TutorialPage page) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 28),
      child: Column(
        children: [
          const SizedBox(height: 20),
          // İkon container
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: page.gradient,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                  color: page.gradient[0].withValues(alpha: 0.4),
                  blurRadius: 24,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            alignment: Alignment.center,
            child: Icon(page.icon, size: 44, color: Colors.white),
          ),
          const SizedBox(height: 28),

          // Başlık
          Text(
            page.title,
            textAlign: TextAlign.center,
            style: GoogleFonts.outfit(
              fontSize: 26,
              fontWeight: FontWeight.w900,
              color: Colors.white,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 20),

          // Açıklama
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.06),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.08),
              ),
            ),
            child: Text(
              page.description,
              style: GoogleFonts.inter(
                fontSize: 14,
                color: Colors.white.withValues(alpha: 0.85),
                height: 1.6,
              ),
            ),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }
}

class _TutorialPage {
  final IconData icon;
  final String title;
  final String description;
  final List<Color> gradient;

  const _TutorialPage({
    required this.icon,
    required this.title,
    required this.description,
    required this.gradient,
  });
}
