import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/presentation/widgets/glowing_border_card.dart';
import '../../../../core/providers/shell_tab_provider.dart';
import '../../../../core/data/lecture_notes.dart';
import '../../../../core/data/quiz_data.dart';
import '../../../../core/utils/sfx_synthesizer.dart';
import '../../../courses/providers/course_provider.dart';
import '../../../courses/presentation/screens/course_list_screen.dart';
import '../../../courses/presentation/screens/course_detail_screen.dart';
import '../../../courses/presentation/screens/lecture_notes_screen_new.dart';
import '../../../profile/providers/profile_provider.dart';

enum CardPosition { top, bottom, center }

/// Rehber adım veri modeli
class _TourStep {
  final String title;
  final String description;
  final String buttonText;
  final IconData icon;
  final int tabIndex;
  final GlobalKey? targetKey;
  final List<Color> gradient;
  final Color accentColor;
  final CardPosition cardPosition;
  final bool showOverlay;
  final String? developerName;

  const _TourStep({
    required this.title,
    required this.description,
    required this.buttonText,
    required this.icon,
    required this.tabIndex,
    this.targetKey,
    required this.gradient,
    required this.accentColor,
    required this.cardPosition,
    this.showOverlay = true,
    this.developerName,
  });
}

class OnboardingTourScreen extends ConsumerStatefulWidget {
  final GlobalKey gradeGridKey;
  final GlobalKey modulesKey;
  final VoidCallback onDismiss;

  const OnboardingTourScreen({
    super.key,
    required this.gradeGridKey,
    required this.modulesKey,
    required this.onDismiss,
  });

  static OverlayEntry? _entry;

  /// Rehberi global OverlayEntry olarak ekranda en üstte başlatır.
  static void show(BuildContext context, GlobalKey gradeGridKey, GlobalKey modulesKey) {
    if (_entry != null) {
      try {
        _entry?.remove();
      } catch (_) {}
      _entry = null;
    }

    final overlay = Overlay.maybeOf(context);
    if (overlay == null) return;
    
    _entry = OverlayEntry(
      builder: (context) => OnboardingTourScreen(
        gradeGridKey: gradeGridKey,
        modulesKey: modulesKey,
        onDismiss: () {
          try {
            _entry?.remove();
          } catch (_) {}
          _entry = null;
        },
      ),
    );
    
    overlay.insert(_entry!);
  }

  @override
  ConsumerState<OnboardingTourScreen> createState() => _OnboardingTourScreenState();
}

class _OnboardingTourScreenState extends ConsumerState<OnboardingTourScreen> with TickerProviderStateMixin {
  late final AnimationController _pulseController;
  int _currentStep = 0;
  bool _initialized = false;
  Rect _spotlightRect = Rect.zero;
  bool _isTracking = false;

  void _startTracking() {
    if (_isTracking) return;
    _isTracking = true;
    _trackPosition();
  }

  void _stopTracking() {
    _isTracking = false;
  }

  void _trackPosition() {
    if (!mounted || !_isTracking) return;
    _updateSpotlightPositionOnly();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _trackPosition();
    });
  }

  void _updateSpotlightPositionOnly() {
    if (!mounted || _steps.isEmpty) return;

    final step = _steps[_currentStep];
    GlobalKey? activeKey = step.targetKey;

    // Eğer bu adımda aydınlatılacak bir hedef yoksa (kart sadece yazı içeriyorsa) spot ışığını sıfırla
    if (activeKey == null && !(step.tabIndex > 0 && step.buttonText.isEmpty)) {
      setState(() {
        _spotlightRect = Rect.zero;
      });
      return;
    }

    if (_currentStep == 1) {
      final profileState = ref.read(profileProvider);
      final gradeNum = profileState.grade?.replaceAll(RegExp(r'[^0-9]'), '') ?? '10';
      final int gradeIdx = gradeNum == '9' ? 0 : gradeNum == '11' ? 2 : gradeNum == '12' ? 3 : 1;
      activeKey = ShellKeys.gradeCardKeys[gradeIdx];
    }
    if (_currentStep == 13) {
      activeKey = ShellKeys.navKeys[1];
    }
    if (_currentStep == 3) {
      final RenderBox? quizBox = ShellKeys.generalQuizKey.currentContext?.findRenderObject() as RenderBox?;
      final RenderBox? unitBox = ShellKeys.unitCardKey.currentContext?.findRenderObject() as RenderBox?;
      
      if (quizBox != null && unitBox != null) {
        final quizOffset = quizBox.localToGlobal(Offset.zero);
        final quizSize = quizBox.size;
        final unitOffset = unitBox.localToGlobal(Offset.zero);
        final unitSize = unitBox.size;
        
        final double top = quizOffset.dy;
        final double left = quizOffset.dx < unitOffset.dx ? quizOffset.dx : unitOffset.dx;
        final double bottom = unitOffset.dy + unitSize.height;
        final double right = (quizOffset.dx + quizSize.width) > (unitOffset.dx + unitSize.width)
            ? (quizOffset.dx + quizSize.width)
            : (unitOffset.dx + unitSize.width);
            
        final newRect = Rect.fromLTRB(left - 8, top - 8, right + 8, bottom + 8);
        if (_spotlightRect != newRect) {
          setState(() {
            _spotlightRect = newRect;
          });
        }
        return;
      }
    }

    if (_currentStep == 9) {
      final RenderBox? caseBox = ShellKeys.caseStudyKey.currentContext?.findRenderObject() as RenderBox?;
      final RenderBox? tipBox = ShellKeys.tipKey.currentContext?.findRenderObject() as RenderBox?;
      
      if (caseBox != null && tipBox != null) {
        final caseOffset = caseBox.localToGlobal(Offset.zero);
        final caseSize = caseBox.size;
        final tipOffset = tipBox.localToGlobal(Offset.zero);
        final tipSize = tipBox.size;
        
        final double top = caseOffset.dy;
        final double left = caseOffset.dx < tipOffset.dx ? caseOffset.dx : tipOffset.dx;
        final double bottom = tipOffset.dy + tipSize.height;
        final double right = (caseOffset.dx + caseSize.width) > (tipOffset.dx + tipSize.width)
            ? (caseOffset.dx + caseSize.width)
            : (tipOffset.dx + tipSize.width);
            
        final newRect = Rect.fromLTRB(left - 8, top - 8, right + 8, bottom + 8);
        if (_spotlightRect != newRect) {
          setState(() {
            _spotlightRect = newRect;
          });
        }
        return;
      }
    }

    if (activeKey != null && activeKey.currentContext != null) {
      final RenderBox? renderBox = activeKey.currentContext!.findRenderObject() as RenderBox?;
      if (renderBox != null) {
        Rect calculateRect(RenderBox box) {
          final size = box.size;
          final offset = box.localToGlobal(Offset.zero);
          if (activeKey == ShellKeys.podcastKey) {
            return Rect.fromLTWH(
              offset.dx + 2,
              offset.dy - 2,
              size.width - 4,
              size.height + 4,
            );
          }
          if (activeKey == ShellKeys.unitQuizFabKey) {
            return Rect.fromLTWH(
              offset.dx,
              offset.dy,
              size.width,
              size.height,
            );
          }
          if (activeKey == ShellKeys.navKeys[1]) {
            return Rect.fromLTWH(
              offset.dx - 2,
              offset.dy - 2,
              size.width + 4,
              size.height + 4,
            );
          }
          return Rect.fromLTWH(
            offset.dx - 8,
            offset.dy - 8,
            size.width + 16,
            size.height + 16,
          );
        }
        final newRect = calculateRect(renderBox);
        if (_spotlightRect != newRect) {
          setState(() {
            _spotlightRect = newRect;
          });
        }
      }
    } else if (step.tabIndex > 0 && step.targetKey == null && step.buttonText.isEmpty) {
      final key = ShellKeys.navKeys[step.tabIndex];
      if (key.currentContext != null) {
        final RenderBox? renderBox = key.currentContext!.findRenderObject() as RenderBox?;
        if (renderBox != null) {
          final size = renderBox.size;
          final offset = renderBox.localToGlobal(Offset.zero);
          final newRect = Rect.fromLTWH(
            offset.dx - 4,
            offset.dy - 4,
            size.width + 8,
            size.height + 8,
          );
          if (_spotlightRect != newRect) {
            setState(() {
              _spotlightRect = newRect;
            });
          }
        }
      }
    }
  }

  Route _premiumRoute(Widget page) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final slideTween = Tween<Offset>(
          begin: const Offset(0.0, 0.08),
          end: Offset.zero,
        ).animate(CurvedAnimation(parent: animation, curve: Curves.easeOutCubic));

        return FadeTransition(
          opacity: animation,
          child: SlideTransition(
            position: slideTween,
            child: child,
          ),
        );
      },
      transitionDuration: const Duration(milliseconds: 100),
      reverseTransitionDuration: const Duration(milliseconds: 300),
    );
  }

  // Adımların listesi
  late final List<_TourStep> _steps = [
    _TourStep(
      title: 'Turizm Defterim\'e Hoş Geldiniz!',
      description: 'Turizm eğitimi yolculuğunuzdaki yardımcınız olacak bu interaktif uygulamayı keşfetmeye hazır mısınız? Uygulamayı tanımanız için size kısaca rehberlik edeceğim.',
      buttonText: 'Hadi Başlayalım!',
      icon: Icons.auto_awesome_rounded,
      tabIndex: 0,
      gradient: AppColors.oceanGradient,
      accentColor: Colors.cyanAccent,
      cardPosition: CardPosition.center,
    ),
    _TourStep(
      title: 'Sınıf Bazlı Eğitim Planı 📚',
      description: 'Seçtiğiniz sınıfa dokunarak ders müfredatınızla uyumlu içerikleri inceleyelim.',
      buttonText: '',
      icon: Icons.school_rounded,
      tabIndex: 0,
      targetKey: widget.gradeGridKey,
      gradient: AppColors.grade9Gradient,
      accentColor: Colors.cyanAccent,
      cardPosition: CardPosition.bottom,
    ),
    _TourStep(
      title: 'Meslek Dersleri Listesi',
      description: 'Sınıfınıza ait meslek dersleri burada listelenir. İçerisindeki öğrenme birimlerini görmek için ders kartına dokunun.',
      buttonText: '',
      icon: Icons.list_alt_rounded,
      tabIndex: 0,
      targetKey: ShellKeys.courseCardKey,
      gradient: AppColors.sunsetGradient,
      accentColor: const Color(0xFFE8AA42),
      cardPosition: CardPosition.bottom,
    ),
    _TourStep(
      title: 'Öğrenme Birimleri ve Testler',
      description: 'Ders kitabıyla uyumlu olarak hazırlanan zengin öğrenme birimi içeriklerini keşfedebilirsiniz. Ayrıca öğrendiklerinizi pekiştirmeniz için oluşturulmuş testlerle bilginizi sınayabilirsiniz.',
      buttonText: 'Devam Et',
      icon: Icons.menu_book_rounded,
      tabIndex: 0,
      targetKey: ShellKeys.generalQuizKey,
      gradient: AppColors.grade11Gradient,
      accentColor: const Color(0xFF4F46E5),
      cardPosition: CardPosition.bottom,
    ),
    _TourStep(
      title: 'Öğrenme Birimine Giriş Yap',
      description: 'Şimdi 1. öğrenme birimine tıklayarak burada yer alan içerikleri keşfedelim.',
      buttonText: '',
      icon: Icons.login_rounded,
      tabIndex: 0,
      targetKey: ShellKeys.unitCardKey,
      gradient: AppColors.grade11Gradient,
      accentColor: const Color(0xFF4F46E5),
      cardPosition: CardPosition.bottom,
    ),
    _TourStep(
      title: 'Ders İçerikleri Paneli',
      description: 'Öğrenme biriminin içerisine girdiğinizde sizleri ders notları, podcastler ve bilgi köşesi gibi zengin içerikler karşılar. Hadi bu alanları birlikte tanıyalım.',
      buttonText: 'Devam Et',
      icon: Icons.dashboard_customize_rounded,
      tabIndex: 0,
      gradient: AppColors.oceanGradient,
      accentColor: Colors.cyanAccent,
      cardPosition: CardPosition.center,
    ),
    _TourStep(
      title: 'Ders Podcastleri 🎧',
      description: 'Her öğrenme biriminin içerisinde, iki uzman yapay zekanın karşılıklı sohbeti şeklinde oluşturulmuş podcastler yer alır. Podcastlerle öğrenme süreçlerinizi daha keyifli hale getirebilirsiniz.\n\nNot: Uygulama arkaplandayken de podcastlerin dinlenebilmesi ve istediğinizde hız butonuna tıklayarak çalma hızının değiştirilebilmesi mümkündür.',
      buttonText: 'Devam Et',
      icon: Icons.podcasts_rounded,
      tabIndex: 0,
      targetKey: ShellKeys.podcastKey,
      gradient: AppColors.oceanGradient,
      accentColor: Colors.cyanAccent,
      cardPosition: CardPosition.center,
    ),
    _TourStep(
      title: 'Ders Notları 📚',
      description: 'Şimdi ders notlarından birine tıklayalım.',
      buttonText: '',
      icon: Icons.bookmark_rounded,
      tabIndex: 0,
      targetKey: ShellKeys.firstConceptKey,
      gradient: AppColors.coralGradient,
      accentColor: const Color(0xFFFF6B6B),
      cardPosition: CardPosition.top,
    ),
    _TourStep(
      title: 'Ders Notları',
      description: 'Ders notlarını örneklerle pekiştirebilirsiniz.',
      buttonText: 'Devam Et',
      icon: Icons.bookmark_rounded,
      tabIndex: 0,
      targetKey: ShellKeys.firstConceptKey,
      gradient: AppColors.coralGradient,
      accentColor: const Color(0xFFFF6B6B),
      cardPosition: CardPosition.bottom,
    ),
    _TourStep(
      title: 'Sektörden Vaka ve Bilgi Köşesi',
      description: 'Sektörden Vaka ve Bilgi Köşesi notlarıyla gerçek hayattan bilgiler edinebilir ve ipuçlarını yakalayabilirsiniz.',
      buttonText: 'Devam Et',
      icon: Icons.tips_and_updates_rounded,
      tabIndex: 0,
      targetKey: ShellKeys.caseStudyKey,
      gradient: AppColors.sunsetGradient,
      accentColor: const Color(0xFFE8AA42),
      cardPosition: CardPosition.top,
    ),
    _TourStep(
      title: 'Öğrenme Birimi Testleri',
      description: 'Öğrenme birimlerinin içerisindeki test sorularıyla bilginizi daha küçük parçalarla sınayabilirsiniz. Teste erişmek istediğinizde buradaki butona tıklamanız yeterli olacaktır.',
      buttonText: 'Ana Menüye Dön',
      icon: Icons.assignment_rounded,
      tabIndex: 0,
      targetKey: ShellKeys.unitQuizFabKey,
      gradient: AppColors.grade11Gradient,
      accentColor: const Color(0xFF4F46E5),
      cardPosition: CardPosition.bottom,
    ),
    _TourStep(
      title: 'Gelişim Atölyesi',
      description: 'Şimdi Gelişim Atölyesi içeriklerini inceleyelim.',
      buttonText: 'Devam Et',
      icon: Icons.insights_rounded,
      tabIndex: 0,
      gradient: AppColors.oceanGradient,
      accentColor: Colors.cyanAccent,
      cardPosition: CardPosition.bottom,
    ),
    _TourStep(
      title: 'Gelişim Atölyesi',
      description: "Her biri örnekle pekiştirilmiş yaklaşık bin kelimelik Turizm Terimler Sözlüğü'ne ve diğer içeriklere buradan erişebilirsiniz.",
      buttonText: 'Devam Et',
      icon: Icons.insights_rounded,
      tabIndex: 0,
      targetKey: widget.modulesKey,
      gradient: AppColors.oceanGradient,
      accentColor: Colors.cyanAccent,
      cardPosition: CardPosition.top,
    ),
    _TourStep(
      title: 'Uygulamalar Sekmesi 🎮',
      description: 'Şimdi Uygulamalar sekmesine dokunarak derslerinizle ilgili uygulamalara göz atalım.',
      buttonText: '',
      icon: Icons.sports_esports_rounded,
      tabIndex: 0,
      targetKey: ShellKeys.navKeys[1],
      gradient: AppColors.grade12Gradient,
      accentColor: const Color(0xFF8B5CF6),
      cardPosition: CardPosition.bottom,
    ),
    _TourStep(
      title: 'Derslerle İlgili Uygulamalar',
      description: "Derslerle ilgili oluşturulan uygulamaları deneyimleyebilir ve öğrenmenizi daha eğlenceli hale getirebilirsiniz.",
      buttonText: 'Devam Et',
      icon: Icons.sports_esports_rounded,
      tabIndex: 1,
      gradient: AppColors.grade12Gradient,
      accentColor: const Color(0xFF8B5CF6),
      cardPosition: CardPosition.bottom,
      showOverlay: false,
    ),
    _TourStep(
      title: 'Başarı Rozetleri 🏆',
      description: 'İçerikleri keşfedip deneyimledikçe puanlar kazanıp seviye seviye ayrılmış rozetleri elde edebilirsiniz.',
      buttonText: 'Devam Et',
      icon: Icons.emoji_events_rounded,
      tabIndex: 2,
      gradient: AppColors.coralGradient,
      accentColor: const Color(0xFFFF6B6B),
      cardPosition: CardPosition.bottom,
      showOverlay: false,
    ),
    _TourStep(
      title: 'Kişisel Profil & Gelişim 👤',
      description: 'Uygulamadaki ders içeriklerini inceleyerek kazandığınız toplam puanı ve rozetleri profil sekmesinden görebilirsiniz.',
      buttonText: 'Sonraki',
      icon: Icons.person_rounded,
      tabIndex: 3,
      gradient: AppColors.oceanGradient,
      accentColor: Colors.cyanAccent,
      cardPosition: CardPosition.bottom,
      showOverlay: false,
    ),
    _TourStep(
      title: 'Tebrikler, Rehberi Tamamladınız!',
      description: 'Turizm sektöründe ve derslerinizde daha başarılı olmanızı desteklemek için yoğun bir emekle hazırladığım bu ücretsiz uygulamayı sizlere sunmaktan çok memnunum.\n\nBaşarılar dilerim, sevgiyle kalın.',
      buttonText: 'Rehberi Tamamla',
      icon: Icons.emoji_events_rounded,
      tabIndex: 3,
      targetKey: ShellKeys.devNoteKey,
      gradient: AppColors.grade9Gradient,
      accentColor: Colors.cyanAccent,
      cardPosition: CardPosition.top,
      showOverlay: false,
      developerName: 'Erol Mert YURDAKUL',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();

    // Tur başladığında aktif durumunu true yap ve ilk konumu hesapla
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(isOnboardingActiveProvider.notifier).state = true;
      if (mounted) {
        _updateSpotlightPosition();
        setState(() => _initialized = true);
      }
    });
  }

  @override
  void dispose() {
    _stopTracking();
    _pulseController.dispose();
    super.dispose();
  }

  /// Aktif adıma göre odak alanının konumunu ve boyutunu hesaplar.
  void _updateSpotlightPosition() {
    _startTracking();
    
    // Stop tracking after 1.5 seconds to cover scroll and layout settling
    Future.delayed(const Duration(milliseconds: 1500), () {
      _stopTracking();
    });

    final step = _steps[_currentStep];
    GlobalKey? activeKey = step.targetKey;

    // Sınıf seçimi adımında (1), kullanıcının kendi seçtiği sınıf kartını hedefle!
    if (_currentStep == 1) {
      final profileState = ref.read(profileProvider);
      final gradeNum = profileState.grade?.replaceAll(RegExp(r'[^0-9]'), '') ?? '10';
      final int gradeIdx = gradeNum == '9' ? 0 : gradeNum == '11' ? 2 : gradeNum == '12' ? 3 : 1;
      activeKey = ShellKeys.gradeCardKeys[gradeIdx];
    }
    
    if (_currentStep == 13) {
      activeKey = ShellKeys.navKeys[1];
    }
    
    // Öğrenme birimleri ve quizler adımında (Adım 3), hem genel ders sınavını hem de 1. ünite kartını beraber odakla!
    if (_currentStep == 3) {
      final RenderBox? quizBox = ShellKeys.generalQuizKey.currentContext?.findRenderObject() as RenderBox?;
      final RenderBox? unitBox = ShellKeys.unitCardKey.currentContext?.findRenderObject() as RenderBox?;
      
      if (quizBox != null && unitBox != null) {
        final quizOffset = quizBox.localToGlobal(Offset.zero);
        final quizSize = quizBox.size;
        
        final unitOffset = unitBox.localToGlobal(Offset.zero);
        final unitSize = unitBox.size;
        
        final double top = quizOffset.dy;
        final double left = quizOffset.dx < unitOffset.dx ? quizOffset.dx : unitOffset.dx;
        final double bottom = unitOffset.dy + unitSize.height;
        final double right = (quizOffset.dx + quizSize.width) > (unitOffset.dx + unitSize.width)
            ? (quizOffset.dx + quizSize.width)
            : (unitOffset.dx + unitSize.width);
            
        setState(() {
          _spotlightRect = Rect.fromLTRB(
            left - 8,
            top - 8,
            right + 8,
            bottom + 8,
          );
        });
        
        // Genel sınava kadar sayfayı en yukarı kaydır (Premium Yavaş Kaydırma)
        Scrollable.ensureVisible(
          ShellKeys.generalQuizKey.currentContext!,
          duration: const Duration(milliseconds: 800),
          curve: Curves.easeInOutCubic,
          alignment: 0.08,
        );
        
        Future.delayed(const Duration(milliseconds: 850), () {
          if (!mounted) return;
          final RenderBox? qBox = ShellKeys.generalQuizKey.currentContext?.findRenderObject() as RenderBox?;
          final RenderBox? uBox = ShellKeys.unitCardKey.currentContext?.findRenderObject() as RenderBox?;
          if (qBox != null && uBox != null) {
            final qOffset = qBox.localToGlobal(Offset.zero);
            final qSize = qBox.size;
            final uOffset = uBox.localToGlobal(Offset.zero);
            final uSize = uBox.size;
            
            final double t = qOffset.dy;
            final double l = qOffset.dx < uOffset.dx ? qOffset.dx : uOffset.dx;
            final double b = uOffset.dy + uSize.height;
            final double r = (qOffset.dx + qSize.width) > (uOffset.dx + uSize.width)
                ? (qOffset.dx + qSize.width)
                : (uOffset.dx + uSize.width);
                
            setState(() {
              _spotlightRect = Rect.fromLTRB(
                l - 8,
                t - 8,
                r + 8,
                b + 8,
              );
            });
          }
        });
        return;
      }
    }

    // Sektörden vaka ve bilgi köşesi adımında (Adım 9), ikisini de beraber odakla!
    if (_currentStep == 9) {
      final RenderBox? caseBox = ShellKeys.caseStudyKey.currentContext?.findRenderObject() as RenderBox?;
      final RenderBox? tipBox = ShellKeys.tipKey.currentContext?.findRenderObject() as RenderBox?;
      
      if (caseBox != null && tipBox != null) {
        final caseOffset = caseBox.localToGlobal(Offset.zero);
        final caseSize = caseBox.size;
        
        final tipOffset = tipBox.localToGlobal(Offset.zero);
        final tipSize = tipBox.size;
        
        final double top = caseOffset.dy;
        final double left = caseOffset.dx < tipOffset.dx ? caseOffset.dx : tipOffset.dx;
        final double bottom = tipOffset.dy + tipSize.height;
        final double right = (caseOffset.dx + caseSize.width) > (tipOffset.dx + tipSize.width)
            ? (caseOffset.dx + caseSize.width)
            : (tipOffset.dx + tipSize.width);
            
        setState(() {
          _spotlightRect = Rect.fromLTRB(
            left - 8,
            top - 8,
            right + 8,
            bottom + 8,
          );
        });
        
        // Sektör vakasına kadar sayfayı kaydır (Premium Yavaş Kaydırma)
        Scrollable.ensureVisible(
          ShellKeys.caseStudyKey.currentContext!,
          duration: const Duration(milliseconds: 800),
          curve: Curves.easeInOutCubic,
          alignment: 0.22,
        );
        
        Future.delayed(const Duration(milliseconds: 850), () {
          if (!mounted) return;
          final RenderBox? cBox = ShellKeys.caseStudyKey.currentContext?.findRenderObject() as RenderBox?;
          final RenderBox? tBox = ShellKeys.tipKey.currentContext?.findRenderObject() as RenderBox?;
          if (cBox != null && tBox != null) {
            final cOffset = cBox.localToGlobal(Offset.zero);
            final cSize = cBox.size;
            final tOffset = tBox.localToGlobal(Offset.zero);
            final tSize = tBox.size;
            
            final double tp = cOffset.dy;
            final double lf = cOffset.dx < tOffset.dx ? cOffset.dx : tOffset.dx;
            final double bt = tOffset.dy + tSize.height;
            final double rg = (cOffset.dx + cSize.width) > (tOffset.dx + tSize.width)
                ? (cOffset.dx + cSize.width)
                : (tOffset.dx + tSize.width);
                
            setState(() {
              _spotlightRect = Rect.fromLTRB(
                lf - 8,
                tp - 8,
                rg + 8,
                bt + 8,
              );
            });
          }
        });
        return;
      }
    }

    if (activeKey != null) {
      final context = activeKey.currentContext;
      if (context != null) {
        // Helper function to build custom Rect for spotlight
        Rect calculateRect(RenderBox box) {
          final size = box.size;
          final offset = box.localToGlobal(Offset.zero);
          if (activeKey == ShellKeys.podcastKey) {
            // Tight-fit for podcast player!
            return Rect.fromLTWH(
              offset.dx + 2,
              offset.dy - 2,
              size.width - 4,
              size.height + 4,
            );
          }
          if (activeKey == ShellKeys.unitQuizFabKey) {
            // Exact-fit for FAB!
            return Rect.fromLTWH(
              offset.dx,
              offset.dy,
              size.width,
              size.height,
            );
          }
          if (activeKey == ShellKeys.navKeys[1]) {
            // Tight-fit for navigation bar item (Applications button)
            return Rect.fromLTWH(
              offset.dx - 2,
              offset.dy - 2,
              size.width + 4,
              size.height + 4,
            );
          }
          return Rect.fromLTWH(
            offset.dx - 8,
            offset.dy - 8,
            size.width + 16,
            size.height + 16,
          );
        }

        try {
          // 1. ANINDA HESAPLA (Gecikmesiz anında gösterim!)
          final RenderBox? immediateBox = context.findRenderObject() as RenderBox?;
          if (immediateBox != null) {
            setState(() {
              _spotlightRect = calculateRect(immediateBox);
            });
          }

          // 2. Sayfayı kaydır (Premium Yavaş Kaydırma)
          final scrollDuration = _currentStep == 12 
              ? const Duration(milliseconds: 1600) 
              : const Duration(milliseconds: 800);
              
          final scrollAlignment = _currentStep == 17 ? 0.72 : _currentStep == 12 ? 0.35 : 0.08;
          final scrollCurve = _currentStep == 12 ? Curves.easeInOutQuart : Curves.easeInOutCubic;

          final targetContext = _currentStep == 17 && ShellKeys.devNoteKey.currentContext != null
              ? ShellKeys.devNoteKey.currentContext!
              : context;
              
          Scrollable.ensureVisible(
            targetContext,
            duration: scrollDuration,
            curve: scrollCurve,
            alignment: scrollAlignment,
          );
          
          // 3. Kaydırma bittikten sonra tam konumu güncelle
          Future.delayed(Duration(milliseconds: scrollDuration.inMilliseconds + 50), () {
            if (!mounted) return;
            try {
              final activeCtx = activeKey?.currentContext;
              if (activeCtx != null) {
                final RenderBox? renderBox = activeCtx.findRenderObject() as RenderBox?;
                if (renderBox != null) {
                  setState(() {
                    _spotlightRect = calculateRect(renderBox);
                  });
                }
              }
            } catch (_) {}
          });
        } catch (_) {}
        return;
      }
    }

    if (step.tabIndex > 0 && step.targetKey == null && step.buttonText.isEmpty) {
      final key = ShellKeys.navKeys[step.tabIndex];
      final keyCtx = key.currentContext;
      if (keyCtx != null) {
        try {
          final RenderBox? renderBox = keyCtx.findRenderObject() as RenderBox?;
          if (renderBox != null) {
            final size = renderBox.size;
            final offset = renderBox.localToGlobal(Offset.zero);
            setState(() {
              _spotlightRect = Rect.fromLTWH(
                offset.dx - 4,
                offset.dy - 4,
                size.width + 8,
                size.height + 8,
              );
            });
            return;
          }
        } catch (_) {}
      }
    }

    // Widget henüz mount edilmemişse mevcut konumu koru (sol üst köşeden kaymayı önle)
  }

  /// Bir sonraki adıma geçiş yapar. Sekmeyi ve sayfayı otomatik değiştirir.
  void _nextStep() {
    SfxSynthesizer.playSoftClick();
    if (_currentStep < _steps.length - 1) {
      // ── Özel Geçiş Eylemleri ──
      
      // Adım 1 -> Adım 2: PUSH COURSE LIST SCREEN
      if (_currentStep == 1) {
        final profileState = ref.read(profileProvider);
        final gradeNum = profileState.grade?.replaceAll(RegExp(r'[^0-9]'), '') ?? '10';
        final List<Color> gradient = gradeNum == '9' 
            ? AppColors.grade9Gradient 
            : gradeNum == '11' 
                ? AppColors.grade11Gradient 
                : gradeNum == '12' 
                    ? AppColors.grade12Gradient 
                    : AppColors.grade10Gradient;

        Navigator.push(
          context,
          _premiumRoute(
            CourseListScreen(
              grade: gradeNum,
              gradient: gradient,
            ),
          ),
        );
      }
      
      // Adım 2 -> Adım 3: PUSH COURSE DETAIL SCREEN
      else if (_currentStep == 2) {
        final profileState = ref.read(profileProvider);
        final gradeNum = profileState.grade?.replaceAll(RegExp(r'[^0-9]'), '') ?? '10';
        final List<Color> gradient = gradeNum == '9' 
            ? AppColors.grade9Gradient 
            : gradeNum == '11' 
                ? AppColors.grade11Gradient 
                : gradeNum == '12' 
                    ? AppColors.grade12Gradient 
                    : AppColors.grade10Gradient;
        
        final courses = ref.read(coursesProvider(gradeNum));
        final courseTitle = courses.isNotEmpty ? courses.first.title : "Konuk Giriş Çıkış İşlemleri";

        Navigator.push(
          context,
          _premiumRoute(
            CourseDetailScreen(
              grade: gradeNum,
              courseTitle: courseTitle,
              gradient: gradient,
            ),
          ),
        );
      }
      
      // Adım 4 -> Adım 5: PUSH LECTURE NOTES SCREEN
      else if (_currentStep == 4) {
        final profileState = ref.read(profileProvider);
        final gradeNum = profileState.grade?.replaceAll(RegExp(r'[^0-9]'), '') ?? '10';
        final List<Color> gradient = gradeNum == '9' 
            ? AppColors.grade9Gradient 
            : gradeNum == '11' 
                ? AppColors.grade11Gradient 
                : gradeNum == '12' 
                    ? AppColors.grade12Gradient 
                    : AppColors.grade10Gradient;
        
        final courses = ref.read(coursesProvider(gradeNum));
        final courseTitle = courses.isNotEmpty ? courses.first.title : "Konuk Giriş Çıkış İşlemleri";
        
        final notes = allCoursesNotes['$gradeNum-$courseTitle'] ?? allCoursesNotes[courseTitle];
        if (notes != null && notes.isNotEmpty) {
          Navigator.push(
            context,
            _premiumRoute(
              LectureNotesScreen(
                data: notes[0],
                gradient: gradient,
                courseId: _getCourseId(courseTitle, gradeNum),
              ),
            ),
          );
        }
      }
      
      // Adım 7 -> Adım 8: EXPAND TANIMLAR/KAVRAMLAR ACCORDION
      else if (_currentStep == 7) {
        try {
          ShellKeys.firstConceptController.expand();
        } catch (_) {}
      }
      
      // Adım 10 -> Adım 11: POP ALL COURSE SCREENS AND RETURNING TO SHELL
      else if (_currentStep == 10) {
        Navigator.of(context).popUntil((route) => route.isFirst);
        Future.delayed(const Duration(milliseconds: 360), () {
          if (widget.gradeGridKey.currentContext != null) {
            final scrollable = Scrollable.of(widget.gradeGridKey.currentContext!);
            if (scrollable != null) {
              scrollable.position.animateTo(
                0.0,
                duration: const Duration(milliseconds: 800),
                curve: Curves.easeInOutCubic,
              );
            } else {
              Scrollable.ensureVisible(
                widget.gradeGridKey.currentContext!,
                duration: const Duration(milliseconds: 800),
                curve: Curves.easeInOutCubic,
              );
            }
          }
        });
      }

      // Hide spotlight immediately at the beginning of route transition
      _stopTracking();
      setState(() {
        _spotlightRect = Rect.zero;
      });

      setState(() {
        _currentStep++;
      });
      
      ref.read(shellTabProvider.notifier).state = _steps[_currentStep].tabIndex;
      
      // Wait for navigation route transition to finish completely before drawing new spotlight
      Future.delayed(const Duration(milliseconds: 350), () {
        if (mounted) {
          _updateSpotlightPosition();
        }
      });
    } else {
      _finishTour();
    }
  }

  /// Rehberi tamamlar, SharedPreferences'e kaydeder ve kapatır.
  void _finishTour() async {
    SfxSynthesizer.playSoftClick();
    // Overlay'i anında kapat — kullanıcı beklemez
    widget.onDismiss();

    // Onboarding aktif durumunu kapat
    ref.read(isOnboardingActiveProvider.notifier).state = false;
    
    // Kullanıcıyı başlangıç sekmesine geri döndür
    ref.read(shellTabProvider.notifier).state = 0;
    
    // Sınıflar sayfasını en yukarı kaydırarak temiz bırak (Premium Yavaş Kaydırma)
    Future.delayed(const Duration(milliseconds: 100), () {
      if (widget.gradeGridKey.currentContext != null) {
        final scrollable = Scrollable.of(widget.gradeGridKey.currentContext!);
        if (scrollable != null) {
          scrollable.position.animateTo(
            0.0,
            duration: const Duration(milliseconds: 800),
            curve: Curves.easeInOutCubic,
          );
        } else {
          Scrollable.ensureVisible(
            widget.gradeGridKey.currentContext!,
            duration: const Duration(milliseconds: 800),
            curve: Curves.easeInOutCubic,
          );
        }
      }
    });

    // Disk yazısını UI'ı bloklamadan arka planda yap
    SharedPreferences.getInstance().then((prefs) {
      prefs.setBool('has_seen_onboarding_guide', true);
    }).catchError((_) {});
  }

  String _getCourseId(String title, String grade) {
    if (title == 'Kat Hizmetleri Atölyesi') {
      return '${grade}_kat_hizmetleri_atolyesi';
    }
    switch (title) {
      case 'Ön Büroda Rezervasyon': return 'on_buro_rezervasyon';
      case 'Konuk Giriş Çıkış İşlemleri': return 'konuk_giris_cikis_islemleri';
      case 'Konaklama İşletmeciliği': return 'konaklama_isletmeciligi';
      case 'Sürdürülebilir Turizm': return 'surdurulebilir_turizm';
      case 'Alternatif Turizm': return 'alternatif_turizm';
      case 'Kuru Temizleme İşlemleri': return 'kuru_temizleme_islemleri';
      case 'Çamaşırhane İşlemleri': return 'camasirhane_islemleri';
      case 'Dünya Seyahat ve Turizm Coğrafyası': return 'dunya_seyahat_ve_turizm_cografyasi';
      case 'Dünya Kültürleri': return 'dunya_kulturleri';
      case 'Kongre ve Etkinlik Turizmi': return 'kongre_ve_etkinlik_turizmi';
      case 'Gastronomi Turizmi': return 'gastronomi_turizmi';
      case 'Tur Operasyonu': return 'tur_operasyonu';
      case 'Transfer Operasyonu': return 'transfer_operasyonu';
      case 'Sosyal Medya': return 'sosyal_medya';
      case 'Mesleki Gelişim Atölyesi': return 'mesleki_gelisim_atolyesi';
      default:
        return title.toLowerCase()
          .replaceAll(' ', '_')
          .replaceAll('ö', 'o')
          .replaceAll('ü', 'u')
          .replaceAll('ı', 'i')
          .replaceAll('ş', 's')
          .replaceAll('ç', 'c')
          .replaceAll('ğ', 'g');
    }
  }

  String _getInteractiveButtonText() {
    switch (_currentStep) {
      case 1:
        return 'Sınıfa Dokun.';
      case 2:
        return 'Derse Dokun.';
      case 4:
        return 'Butona Dokun.';
      case 7:
        return 'Ders Notuna Dokun.';
      case 13:
        return 'Butona Dokun.';
      default:
        return 'Karta Dokun.';
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_initialized) return const SizedBox.shrink();

    final size = MediaQuery.of(context).size;
    final step = _steps[_currentStep];

    double? top;
    double? bottom;

    switch (step.cardPosition) {
      case CardPosition.center:
        top = (size.height / 2 - 95).clamp(
          MediaQuery.of(context).padding.top + 12,
          size.height - 190,
        );
        bottom = null;
        break;
      case CardPosition.top:
        double calculatedTop = MediaQuery.of(context).padding.top + 20;
        if (_currentStep == 17) {
          final RenderBox? profileBox = ShellKeys.profileCardKey.currentContext?.findRenderObject() as RenderBox?;
          if (profileBox != null) {
            final profileOffset = profileBox.localToGlobal(Offset.zero);
            final profileSize = profileBox.size;
            calculatedTop = profileOffset.dy + profileSize.height + 12;
          } else {
            calculatedTop = MediaQuery.of(context).padding.top + 300;
          }
        } else if ((_currentStep == 9 || _currentStep == 12) && _spotlightRect != Rect.zero) {
          final double safeAreaTop = MediaQuery.of(context).padding.top;
          final double targetTop = _spotlightRect.top;
          calculatedTop = ((safeAreaTop + targetTop) / 2 - 75).clamp(safeAreaTop + 12, targetTop - 145);
        }
        top = calculatedTop;
        bottom = null;
        break;
      case CardPosition.bottom:
        if ((_currentStep == 8) && _spotlightRect != Rect.zero) {
          final double screenHeight = MediaQuery.of(context).size.height;
          final double safeAreaBottom = MediaQuery.of(context).padding.bottom;
          final double finalTop = (_spotlightRect.bottom + 20).clamp(
            12.0,
            screenHeight - 180 - safeAreaBottom,
          );
          top = finalTop;
          bottom = null;
        } else if ((_currentStep == 2 || _currentStep == 3 || _currentStep == 4) && _spotlightRect != Rect.zero) {
          final double screenHeight = MediaQuery.of(context).size.height;
          final double safeAreaBottom = MediaQuery.of(context).padding.bottom;
          // Place guide card below the pointer which starts at bottom + 12 and has height 78
          final double finalTop = (_spotlightRect.bottom + 102).clamp(
            12.0,
            screenHeight - 180 - safeAreaBottom,
          );
          top = finalTop;
          bottom = null;
        } else {
          double calculatedBottom = MediaQuery.of(context).padding.bottom + 125;
          if (_currentStep == 10) {
            calculatedBottom = MediaQuery.of(context).padding.bottom + 210;
          } else if (_currentStep == 13) {
            calculatedBottom = MediaQuery.of(context).padding.bottom + 240;
          } else if (_currentStep == 14 || _currentStep == 15 || _currentStep == 16) {
            calculatedBottom = MediaQuery.of(context).padding.bottom + 112;
          }
          top = null;
          bottom = calculatedBottom;
        }
        break;
    }

    final Widget cardPositioned = AnimatedPositioned(
      duration: Duration(milliseconds: _currentStep == 12 ? 218 : 273),
      curve: Curves.easeOutCubic,
      top: top,
      bottom: bottom,
      left: 20,
      right: 20,
      child: _buildStepCard(step),
    );

    return PopScope(
      canPop: false,
      child: Material(
        color: Colors.transparent,
        child: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTapDown: (details) {
            final tapPos = details.globalPosition;
            if (_spotlightRect != Rect.zero && _spotlightRect.contains(tapPos)) {
              // Sadece buton yazısı boş olan (interaktif) adımlarda dokunulduğunda ilerle!
              if (_steps[_currentStep].buttonText.isEmpty) {
                if (_currentStep == 7) {
                  try {
                    ShellKeys.firstConceptController.expand();
                  } catch (_) {}
                }
                _nextStep();
              }
            }
          },
          child: Stack(
            children: [
              // ── Spot Işığı Katmanı ──
              AnimatedBuilder(
                animation: _pulseController,
                builder: (context, child) {
                  // Tüm hedeflerde tutarlı ve şık bir görünüm için köşeleri yuvarlatılmış dikdörtgen (RRect) kullanılır
                  const bool isCircle = false;

                  return AnimatedSpotlight(
                    targetRect: _spotlightRect,
                    pulseValue: _pulseController.value,
                    glowColor: step.accentColor,
                    size: size,
                    showOverlay: step.showOverlay,
                    isCircle: isCircle,
                    hideCutout: _currentStep == 17,
                  );
                },
              ),

              // ── Bouncing Pointer ──
              _buildPointer(_spotlightRect, size),

              // ── Rehber Kartı ──
              cardPositioned,
            ],
          ),
        ),
      ),
    );
  }

  /// Rehber kart içeriğini oluşturur.
  Widget _buildStepCard(_TourStep step) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 327),
      transitionBuilder: (Widget child, Animation<double> animation) {
        return FadeTransition(
          opacity: animation,
          child: ScaleTransition(
            scale: Tween<double>(begin: 0.95, end: 1.0).animate(
              CurvedAnimation(parent: animation, curve: Curves.easeOutCubic),
            ),
            child: child,
          ),
        );
      },
      child: GlowingBorderCard(
        key: ValueKey<int>(_currentStep),
        borderRadius: 24,
        glowColors: [
          step.accentColor,
          step.accentColor.withOpacity(0.5),
          Colors.cyanAccent,
          step.accentColor,
        ],
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    const Color(0xFF0F172A).withOpacity(0.85),
                    const Color(0xFF1E293B).withOpacity(0.85),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: Colors.white.withOpacity(0.12),
                  width: 1.0,
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        step.icon,
                        color: step.accentColor,
                        size: 20,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text: step.title,
                                style: GoogleFonts.outfit(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w900,
                                  color: Colors.white,
                                  letterSpacing: 0.3,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Açıklama Yazısı
                  () {
                    final description = step.description;
                    if (description.contains('\n\n')) {
                      final parts = description.split('\n\n');
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            parts[0],
                            textAlign: TextAlign.justify,
                            style: GoogleFonts.inter(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              color: Colors.white.withOpacity(0.85),
                              height: 1.5,
                              letterSpacing: 0.2,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            parts[1],
                            textAlign: TextAlign.justify,
                            style: GoogleFonts.inter(
                              fontSize: parts[1].startsWith('Not:') ? 12.5 : 13,
                              fontWeight: FontWeight.w500,
                              fontStyle: parts[1].startsWith('Not:') ? FontStyle.italic : FontStyle.normal,
                              color: parts[1].startsWith('Not:') 
                                  ? Colors.white.withOpacity(0.75)
                                  : Colors.white.withOpacity(0.85),
                              height: 1.5,
                              letterSpacing: 0.2,
                            ),
                          ),
                        ],
                      );
                    }
                    return Text(
                      description,
                      textAlign: TextAlign.justify,
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: Colors.white.withOpacity(0.85),
                        height: 1.5,
                        letterSpacing: 0.2,
                      ),
                    );
                  }(),
                  if (step.developerName != null) ...[
                    const SizedBox(height: 10),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        step.developerName!,
                        style: GoogleFonts.outfit(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          fontStyle: FontStyle.italic,
                          color: step.accentColor,
                        ),
                      ),
                    ),
                  ],
                  const SizedBox(height: 18),

                  // Alt Satır: İlerleme Noktaları ve Buton
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // İlerleme Noktaları
                      Row(
                        children: List.generate(
                          _steps.length,
                          (index) => AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            margin: const EdgeInsets.only(right: 3),
                            width: _currentStep == index ? 12 : 4,
                            height: 4,
                            decoration: BoxDecoration(
                              color: _currentStep == index 
                                  ? step.accentColor 
                                  : Colors.white24,
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                        ),
                      ),

                      // İleri Butonu veya Dokun İpucu
                      step.buttonText.isNotEmpty
                          ? _InteractiveTourButton(
                              onTap: _nextStep,
                              text: step.buttonText,
                              gradient: step.gradient,
                              accentColor: step.accentColor,
                              isLastStep: _currentStep == _steps.length - 1,
                            )
                          : Container(
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                              decoration: BoxDecoration(
                                color: step.accentColor.withOpacity(0.15),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: step.accentColor.withOpacity(0.3), width: 1.0),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.touch_app_rounded, color: step.accentColor, size: 15),
                                  const SizedBox(width: 6),
                                  Text(
                                    _getInteractiveButtonText(),
                                    style: GoogleFonts.outfit(
                                      color: step.accentColor,
                                      fontWeight: FontWeight.w800,
                                      fontSize: 12.5,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPointer(Rect rect, Size screenSize) {
    if (rect == Rect.zero || _currentStep == 17) return const SizedBox.shrink();
    
    final step = _steps[_currentStep];
    final bool shouldPointUp;
    if (_currentStep == 7 || _currentStep == 2 || _currentStep == 3 || _currentStep == 4) {
      shouldPointUp = true;
    } else if (step.cardPosition == CardPosition.bottom) {
      shouldPointUp = false;
    } else if (step.cardPosition == CardPosition.top) {
      shouldPointUp = true;
    } else {
      shouldPointUp = rect.center.dy < screenSize.height / 2;
    }
    
    final double pointerWidth = 46;
    final double pointerHeight = 78;
    
    final double left = rect.center.dx - (pointerWidth / 2);
    double finalTop = shouldPointUp 
        ? rect.bottom + 12 
        : rect.top - pointerHeight - 12;
    bool finalIsPointingUp = shouldPointUp;
    
    final double safeAreaTop = MediaQuery.of(context).padding.top;
    final double safeAreaBottom = screenSize.height - MediaQuery.of(context).padding.bottom;
    
    // Güvenlik sınırları kontrolü: Ekranın tepesinden taşarsa altına yerleştir ve yukarıyı göster
    if (!shouldPointUp && finalTop < safeAreaTop) {
      finalTop = rect.bottom + 12;
      finalIsPointingUp = true;
    }
    // Güvenlik sınırları kontrolü: Ekranın altından taşarsa üstüne yerleştir ve aşağıyı göster
    if (shouldPointUp && finalTop + pointerHeight > safeAreaBottom) {
      finalTop = rect.top - pointerHeight - 12;
      finalIsPointingUp = false;
    }
    
    // Hala görünür sınırlar içindeyse çizdir
    if (left < 0 || left > screenSize.width || finalTop < 0 || finalTop > screenSize.height) {
      return const SizedBox.shrink();
    }
    
    return Positioned(
      left: left,
      top: finalTop,
      child: _BouncingPointer(
        isPointingUp: finalIsPointingUp,
        glowColor: step.accentColor,
      ),
    );
  }
}

class _BouncingPointer extends StatefulWidget {
  final bool isPointingUp;
  final Color glowColor;

  const _BouncingPointer({
    required this.isPointingUp,
    required this.glowColor,
  });

  @override
  State<_BouncingPointer> createState() => _BouncingPointerState();
}

class _BouncingPointerState extends State<_BouncingPointer>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);

    _animation = Tween<double>(begin: 0.0, end: 14.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOutQuad),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        final double transformY = widget.isPointingUp 
            ? _animation.value 
            : -_animation.value;
            
        return Transform.translate(
          offset: Offset(0, transformY),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (!widget.isPointingUp) ...[
                Icon(
                  Icons.keyboard_double_arrow_down_rounded,
                  color: widget.glowColor,
                  size: 28,
                ),
                const SizedBox(height: 4),
              ],
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: widget.glowColor.withOpacity(0.25),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: widget.glowColor.withOpacity(0.4),
                      blurRadius: 10,
                      spreadRadius: 2,
                    ),
                  ],
                  border: Border.all(color: widget.glowColor, width: 2.0),
                ),
                child: RotatedBox(
                  quarterTurns: widget.isPointingUp ? 0 : 2,
                  child: const Icon(
                    Icons.touch_app_rounded,
                    color: Colors.white,
                    size: 22,
                  ),
                ),
              ),
              if (widget.isPointingUp) ...[
                const SizedBox(height: 4),
                Icon(
                  Icons.keyboard_double_arrow_up_rounded,
                  color: widget.glowColor,
                  size: 28,
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}

class AnimatedSpotlight extends ImplicitlyAnimatedWidget {
  final Rect targetRect;
  final double pulseValue;
  final Color glowColor;
  final Size size;
  final bool showOverlay;
  final bool isCircle;
  final bool hideCutout;

  const AnimatedSpotlight({
    super.key,
    required this.targetRect,
    required this.pulseValue,
    required this.glowColor,
    required this.size,
    required this.showOverlay,
    required this.isCircle,
    this.hideCutout = false,
    super.duration = const Duration(milliseconds: 218),
    super.curve = Curves.easeOutCubic,
  });

  @override
  ImplicitlyAnimatedWidgetState<AnimatedSpotlight> createState() =>
      _AnimatedSpotlightState();
}

class _AnimatedSpotlightState
    extends ImplicitlyAnimatedWidgetState<AnimatedSpotlight> {
  RectTween? _rectTween;

  @override
  void forEachTween(TweenVisitor<dynamic> visitor) {
    _rectTween = visitor(
      _rectTween,
      widget.targetRect,
      (dynamic value) => RectTween(begin: value as Rect?),
    ) as RectTween?;
  }

  @override
  Widget build(BuildContext context) {
    final Rect? animatedRect = _rectTween?.evaluate(animation);
    return CustomPaint(
      size: widget.size,
      painter: _SpotlightPainter(
        targetRect: animatedRect ?? Rect.zero,
        pulseValue: widget.pulseValue,
        glowColor: widget.glowColor,
        showOverlay: widget.showOverlay,
        isCircle: widget.isCircle,
        hideCutout: widget.hideCutout,
      ),
    );
  }
}

/// Spot Işığı CustomPainter
class _SpotlightPainter extends CustomPainter {
  final Rect? targetRect;
  final double pulseValue;
  final Color glowColor;
  final bool showOverlay;
  final bool isCircle;
  final bool hideCutout;

  _SpotlightPainter({
    required this.targetRect,
    required this.pulseValue,
    required this.glowColor,
    required this.showOverlay,
    required this.isCircle,
    this.hideCutout = false,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = showOverlay ? Colors.black.withOpacity(0.78) : Colors.transparent;

    canvas.saveLayer(Offset.zero & size, Paint());
    canvas.drawRect(Offset.zero & size, paint);

    if (targetRect != null && targetRect != Rect.zero && !hideCutout) {
      final cutPaint = Paint()..blendMode = BlendMode.clear;
      if (isCircle) {
        canvas.drawOval(targetRect!, cutPaint);
      } else {
        final RRect cutoutRRect = RRect.fromRectAndRadius(
          targetRect!,
          const Radius.circular(16),
        );
        canvas.drawRRect(cutoutRRect, cutPaint);
      }
      
      canvas.restore(); // Katmanı birleştir

      // Neon halka yayılım animasyonu (Aura Glow)
      final glowPaint = Paint()
        ..color = glowColor.withOpacity(0.65 * (1.0 - pulseValue))
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3.5
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6.0);

      final borderPaint = Paint()
        ..color = glowColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.8;

      if (isCircle) {
        final Rect pulsedRect = targetRect!.inflate(pulseValue * 6.0);
        canvas.drawOval(pulsedRect, glowPaint);
        canvas.drawOval(targetRect!, borderPaint);
      } else {
        final pulseRadius = 16.0 + pulseValue * 6.0;
        final RRect cutoutRRect = RRect.fromRectAndRadius(
          targetRect!,
          const Radius.circular(16),
        );
        final RRect pulsedRRect = RRect.fromRectAndRadius(
          targetRect!.inflate(pulseValue * 6.0),
          Radius.circular(pulseRadius),
        );
        canvas.drawRRect(pulsedRRect, glowPaint);
        canvas.drawRRect(cutoutRRect, borderPaint);
      }
    } else {
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant _SpotlightPainter oldDelegate) {
    return oldDelegate.targetRect != targetRect ||
        oldDelegate.pulseValue != pulseValue ||
        oldDelegate.glowColor != glowColor ||
        oldDelegate.showOverlay != showOverlay ||
        oldDelegate.isCircle != isCircle ||
        oldDelegate.hideCutout != hideCutout;
  }
}

/// Tıklama ve hover hissi veren özel premium buton
class _InteractiveTourButton extends StatefulWidget {
  final VoidCallback onTap;
  final String text;
  final List<Color> gradient;
  final Color accentColor;
  final bool isLastStep;

  const _InteractiveTourButton({
    Key? key,
    required this.onTap,
    required this.text,
    required this.gradient,
    required this.accentColor,
    required this.isLastStep,
  }) : super(key: key);

  @override
  State<_InteractiveTourButton> createState() => _InteractiveTourButtonState();
}

class _InteractiveTourButtonState extends State<_InteractiveTourButton> {
  bool _isPressed = false;
  bool _isHovered = false;

  void _onTapDown(TapDownDetails details) {
    setState(() {
      _isPressed = true;
    });
  }

  void _onTapUp(TapUpDetails details) {
    setState(() {
      _isPressed = false;
    });
    // Apple klavye tuşu tıklama tepki süresi (80ms) sonrası eylemi tetikle
    Future.delayed(const Duration(milliseconds: 80), () {
      if (mounted) {
        widget.onTap();
      }
    });
  }

  void _onTapCancel() {
    setState(() {
      _isPressed = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTapDown: _onTapDown,
        onTapUp: _onTapUp,
        onTapCancel: _onTapCancel,
        child: AnimatedScale(
          scale: _isPressed ? 0.96 : 1.0, // Apple standardı: Sadece %4 mikro-basış payı
          duration: _isPressed 
              ? const Duration(milliseconds: 60)   // Basılırken ultra hızlı tepki (60ms)
              : const Duration(milliseconds: 150),  // Bırakılırken pürüzsüz ve tok geri büyüme (150ms)
          curve: _isPressed 
              ? Curves.easeOutQuad 
              : Curves.easeOutCubic, // Kararlı ve profesyonel sönümlenme
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 218),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: widget.gradient,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                  color: widget.accentColor.withOpacity(_isHovered ? 0.45 : 0.28),
                  blurRadius: _isHovered ? 10 : 6,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  widget.text,
                  style: GoogleFonts.outfit(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(width: 6),
                Icon(
                  widget.isLastStep ? Icons.done_all_rounded : Icons.arrow_forward_rounded,
                  color: Colors.white,
                  size: 14,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
