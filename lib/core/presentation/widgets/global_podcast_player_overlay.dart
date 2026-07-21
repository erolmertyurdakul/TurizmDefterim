import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:just_audio/just_audio.dart';
import '../../services/podcast_service.dart';
import 'podcast_speed_control.dart';

class GlobalPodcastPlayerOverlay extends StatefulWidget {
  const GlobalPodcastPlayerOverlay({super.key});

  @override
  State<GlobalPodcastPlayerOverlay> createState() => _GlobalPodcastPlayerOverlayState();
}

class _GlobalPodcastPlayerOverlayState extends State<GlobalPodcastPlayerOverlay> {
  double _opacity = 0.55;
  Timer? _opacityTimer;
  final GlobalKey _speedControlKey = GlobalKey();
  final GlobalKey _playerBoxKey = GlobalKey(); // Oynatıcı kutusunun key'i (hizalama referansı)

  @override
  void dispose() {
    _opacityTimer?.cancel();
    super.dispose();
  }

  void _triggerPremiumFeedback() {
    _opacityTimer?.cancel();
    setState(() {
      _opacity = 0.95;
    });
    _opacityTimer = Timer(const Duration(seconds: 4), () {
      if (mounted) {
        setState(() {
          _opacity = 0.55;
        });
      }
    });
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return "$minutes:$seconds";
  }

  @override
  Widget build(BuildContext context) {
    final podcastService = PodcastService();

    return ListenableBuilder(
      listenable: podcastService,
      builder: (context, _) {
        final currentUrl = podcastService.currentUrl;
        final player = podcastService.player;
        
        // Hide if notes screen is currently active (it has its own main audio controller)
        if (podcastService.isNotesScreenActive) {
          return const SizedBox.shrink();
        }

        // Hide if main navigation shell screens are currently active (they have the bottom audio controller)
        if (podcastService.isMainShellVisible) {
          return const SizedBox.shrink();
        }

        // Only show if there is an active podcast loaded and not idle
        if (currentUrl == null || player.processingState == ProcessingState.idle) {
          return const SizedBox.shrink();
        }

        return StreamBuilder<PlayerState>(
          stream: player.playerStateStream,
          builder: (context, snapshot) {
            final playerState = snapshot.data;
            final playing = playerState?.playing ?? false;
            final isLoading = podcastService.isBuffering;

            // Slider'ın ve Hız Paneli Overlay'inin sorunsuz çalışması için yerel bir Overlay sarmalayıcısı ekliyoruz.
            // Bu sayede 'No Overlay widget found' hatası engellenir ve speed control kendi overlay'ini tam oynatıcının üzerine açar.
            return Overlay(
              initialEntries: [
                OverlayEntry(
                  builder: (context) => Stack(
                    clipBehavior: Clip.none,
                    children: [
                      // Ana Oynatıcı Katmanı
                      Positioned(
                        bottom: MediaQuery.of(context).padding.bottom + 10,
                        left: 16,
                        right: 16,
                        child: Material(
                          color: Colors.transparent,
                          child: GestureDetector(
                            onTap: _triggerPremiumFeedback,
                            child: AnimatedOpacity(
                              duration: const Duration(milliseconds: 300),
                              opacity: _opacity,
                              child: Container(
                                key: _playerBoxKey, // Oynatıcı kutusu referansı
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: const Color(0xFF0A192F).withOpacity(0.75),
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: Colors.cyanAccent.withOpacity(0.25),
                                    width: 1.5,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.cyanAccent.withOpacity(0.12),
                                      blurRadius: 20,
                                      offset: const Offset(0, 8),
                                    ),
                                  ],
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child: BackdropFilter(
                                    filter: ImageFilter.blur(sigmaX: kIsWeb ? 0 : 16, sigmaY: kIsWeb ? 0 : 16),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                                          child: Row(
                                            children: [
                                              // Left: Pulse animated headphone indicator or Loading Spinner
                                              isLoading
                                                  ? const SizedBox(
                                                      width: 32,
                                                      height: 32,
                                                      child: CircularProgressIndicator(
                                                        strokeWidth: 2.0,
                                                        valueColor: AlwaysStoppedAnimation<Color>(Colors.cyanAccent),
                                                      ),
                                                    )
                                                  : Container(
                                                      width: 36,
                                                      height: 36,
                                                      decoration: BoxDecoration(
                                                        color: Colors.cyanAccent.withOpacity(0.15),
                                                        shape: BoxShape.circle,
                                                        border: Border.all(
                                                          color: Colors.cyanAccent.withOpacity(0.3),
                                                          width: 1,
                                                        ),
                                                      ),
                                                      child: const Icon(
                                                        Icons.headset_rounded,
                                                        color: Colors.cyanAccent,
                                                        size: 18,
                                                      ),
                                                    ),
                                              const SizedBox(width: 12),
                                              
                                              // Middle: Podcast Information
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      podcastService.currentTitle ?? "Podcast Dinleniyor",
                                                      maxLines: 1,
                                                      overflow: TextOverflow.ellipsis,
                                                      style: GoogleFonts.outfit(
                                                        fontSize: 14,
                                                        fontWeight: FontWeight.w800,
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                    const SizedBox(height: 2),
                                                    Text(
                                                      podcastService.currentAlbum ?? "Turizm Defterim",
                                                      maxLines: 1,
                                                      overflow: TextOverflow.ellipsis,
                                                      style: GoogleFonts.inter(
                                                        fontSize: 11,
                                                        fontWeight: FontWeight.w500,
                                                        color: Colors.white60,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              const SizedBox(width: 8),

                                              // Speed Control (targetAlignKey olarak doğrudan oynatıcı kutusu verilerek mükemmel ortalama sağlandı)
                                              PodcastSpeedControl(
                                                key: _speedControlKey,
                                                accentColor: Colors.cyanAccent,
                                                opensUpward: true,
                                                targetAlignKey: _playerBoxKey,
                                              ),
                                              const SizedBox(width: 8),

                                              // Right Action 1: Play / Pause Control
                                              IconButton(
                                                iconSize: 28,
                                                padding: EdgeInsets.zero,
                                                constraints: const BoxConstraints(),
                                                icon: Icon(
                                                  playing ? Icons.pause_circle_filled_rounded : Icons.play_circle_fill_rounded,
                                                  color: Colors.cyanAccent,
                                                ),
                                                onPressed: () {
                                                  _triggerPremiumFeedback();
                                                  if (playing) {
                                                    podcastService.pause();
                                                  } else {
                                                    podcastService.resume();
                                                  }
                                                },
                                              ),
                                              const SizedBox(width: 8),

                                              // Right Action 2: Close / Dismiss Control
                                              IconButton(
                                                iconSize: 20,
                                                padding: EdgeInsets.zero,
                                                constraints: const BoxConstraints(),
                                                icon: const Icon(
                                                  Icons.close_rounded,
                                                  color: Colors.white54,
                                                ),
                                                onPressed: () {
                                                  _triggerPremiumFeedback();
                                                  podcastService.stop();
                                                },
                                              ),
                                            ],
                                          ),
                                        ),
                                        
                                         // Bottom: Tiny, aesthetic Seek Progress Line
                                         StreamBuilder<Duration>(
                                           stream: player.positionStream,
                                           builder: (context, posSnapshot) {
                                             final position = posSnapshot.data ?? Duration.zero;
                                             final duration = player.duration ?? Duration.zero;
                                             final totalMs = duration.inMilliseconds;
                                             final currentMs = position.inMilliseconds;
                                             final progress = totalMs > 0 ? (currentMs / totalMs).clamp(0.0, 1.0) : 0.0;

                                             return ClipRRect(
                                               borderRadius: const BorderRadius.only(
                                                 bottomLeft: Radius.circular(20),
                                                 bottomRight: Radius.circular(20),
                                               ),
                                               child: LinearProgressIndicator(
                                                 value: progress,
                                                 backgroundColor: Colors.white.withOpacity(0.08),
                                                 valueColor: const AlwaysStoppedAnimation<Color>(Colors.cyanAccent),
                                                 minHeight: 3.0,
                                               ),
                                             );
                                           },
                                         ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
