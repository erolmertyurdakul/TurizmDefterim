import 'package:flutter/material.dart';
import 'dart:ui';
import 'core/theme/app_theme.dart';
import 'core/presentation/widgets/global_podcast_player_overlay.dart';
import 'features/splash/presentation/screens/initial_splash_screen.dart';

final RouteObserver<ModalRoute<void>> routeObserver = RouteObserver<ModalRoute<void>>();

class AppScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
        PointerDeviceKind.trackpad,
      };
}

class TurizmEgitimApp extends StatelessWidget {
  const TurizmEgitimApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Turizm Defterim',
      debugShowCheckedModeBanner: false,
      navigatorObservers: [routeObserver],
      scrollBehavior: AppScrollBehavior(),

      // ── Okyanus Teması Entegrasyonu ──
      theme: AppTheme.lightTheme,
      themeMode: ThemeMode.light,

      // ── Giriş Animasyon Ekranı ──
      home: const InitialSplashScreen(),

      // ── Global Podcast Oynatıcı Katmanı ──
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(
            textScaler: TextScaler.noScaling,
          ),
          child: Stack(
            children: [
              if (child != null) child,
              const GlobalPodcastPlayerOverlay(),
            ],
          ),
        );
      },
    );
  }
}
