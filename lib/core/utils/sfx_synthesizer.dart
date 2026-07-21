import 'dart:math';
import 'dart:typed_data';

class SfxSynthesizer {
  static Uint8List generateWav({
    required List<double> notes,
    required List<double> delays,
    double duration = 1.0,
    double volume = 0.5,
    bool isError = false,
    double attackTime = 0.05,
    double decayRate = 4.0,
  }) {
    final sampleRate = 44100;
    final numSamples = (sampleRate * duration).toInt();
    final samples = Float32List(numSamples);

    for (var i = 0; i < numSamples; i++) {
      final t = i / sampleRate;
      var sample = 0.0;

      for (var j = 0; j < notes.length; j++) {
        final note = notes[j];
        final delay = delays[j];

        if (t > delay) {
          final tt = t - delay;
          final attack = isError ? 0.01 : attackTime;
          var env = 0.0;
          if (tt < attack) {
            env = tt / attack;
          } else {
            env = exp(-(tt - attack) * (isError ? 8.0 : decayRate));
          }

          if (isError) {
            // Error buzz: mix sine wave with square wave/harmonics
            final val = sin(2 * pi * note * tt) + 0.5 * sin(2 * pi * note * 2.0 * tt);
            sample += val * env;
          } else {
            // Clean chime
            var val = sin(2 * pi * note * tt);
            val += 0.3 * sin(2 * pi * note * 2.0 * tt) * exp(-tt * 4.0);
            val += 0.1 * sin(2 * pi * note * 3.0 * tt) * exp(-tt * 8.0);
            sample += val * env;
          }
        }
      }

      // Normalize & Volume
      sample = (sample / (notes.isEmpty ? 1.0 : notes.length)) * volume;

      // --- Anti-pop fade out ---
      // Sesin sonunda (son 150ms) aniden kesilmeyi engelleyip yumuşakça sıfıra inmesini sağlar (pıt sesini çözer)
      final fadeOutSamples = (sampleRate * 0.15).toInt();
      if (i > numSamples - fadeOutSamples) {
        final fadeFactor = (numSamples - i) / fadeOutSamples;
        sample *= fadeFactor;
      }

      if (sample > 1.0) sample = 1.0;
      if (sample < -1.0) sample = -1.0;

      samples[i] = sample;
    }

    final subchunk2Size = numSamples * 2;
    final wavData = ByteData(44 + subchunk2Size);

    // RIFF
    wavData.setUint8(0, 0x52); // R
    wavData.setUint8(1, 0x49); // I
    wavData.setUint8(2, 0x46); // F
    wavData.setUint8(3, 0x46); // F
    wavData.setUint32(4, 36 + subchunk2Size, Endian.little);
    wavData.setUint8(8, 0x57); // W
    wavData.setUint8(9, 0x41); // A
    wavData.setUint8(10, 0x56); // V
    wavData.setUint8(11, 0x45); // E

    // Subchunk 1 (fmt)
    wavData.setUint8(12, 0x66); // f
    wavData.setUint8(13, 0x6D); // m
    wavData.setUint8(14, 0x74); // t
    wavData.setUint8(15, 0x20); //
    wavData.setUint32(16, 16, Endian.little);
    wavData.setUint16(20, 1, Endian.little); // PCM
    wavData.setUint16(22, 1, Endian.little); // Mono
    wavData.setUint32(24, sampleRate, Endian.little);
    wavData.setUint32(28, sampleRate * 2, Endian.little);
    wavData.setUint16(32, 2, Endian.little);
    wavData.setUint16(34, 16, Endian.little);

    // Subchunk 2 (data)
    wavData.setUint8(36, 0x64); // d
    wavData.setUint8(37, 0x61); // a
    wavData.setUint8(38, 0x74); // t
    wavData.setUint8(39, 0x61); // a
    wavData.setUint32(40, subchunk2Size, Endian.little);

    for (var i = 0; i < numSamples; i++) {
      final sampleInt = (samples[i] * 32767.0).toInt();
      wavData.setInt16(44 + i * 2, sampleInt, Endian.little);
    }

    return wavData.buffer.asUint8List();
  }

  // ── Uygulama Açılış Sesi (Splash) ──
  // C5→E5→G5→B5→C6 yükselen arpej — splash ekranında kullanılır
  static Uint8List getChime() {
    return generateWav(
      notes: [523.25, 659.25, 783.99, 987.77, 1046.50], // C5, E5, G5, B5, C6
      delays: [0.0, 0.05, 0.10, 0.15, 0.20],
      duration: 1.5,
      volume: 0.4,
    );
  }

  // ── Quiz Giriş Sesi ──
  // D4→F#4→A4 sıcak D major arpej — quizlere girerken çalan ses
  // Splash'ten belirgin şekilde farklı: daha düşük tonlarda, daha yumuşak
  static Uint8List getQuizIntro() {
    return generateWav(
      notes: [293.66, 349.23, 440.00, 523.25], // D4, F4, A4, C5
      delays: [0.0, 0.08, 0.16, 0.24],
      duration: 1.2,
      volume: 0.35,
      attackTime: 0.08,
      decayRate: 3.0,
    );
  }

  // ── Doğru Cevap Sesi (Premium, Sıcak, Tiz Olmayan) ──
  // G3→B3 yumuşak iki tonlu onay — kulağı yormaz, tiz değil
  // Düşük oktavda sıcak harmonikler, yavaş sönümleme
  static Uint8List getCorrectAnswer() {
    return generateWav(
      notes: [196.00, 246.94, 329.63], // G3, B3, E4 — sıcak minör-majör geçiş
      delays: [0.0, 0.06, 0.12],
      duration: 0.7,
      volume: 0.30,
      attackTime: 0.06,
      decayRate: 3.5,
    );
  }

  // ── Yanlış Cevap Sesi (Mevcut — Dokunma!) ──
  // Düşük buzzy error sesi — kullanıcı beğeniyor
  static Uint8List getError() {
    return generateWav(
      notes: [130.81, 196.00], // C3 + G3 low
      delays: [0.0, 0.0],
      duration: 0.4,
      volume: 0.5,
      isError: true,
    );
  }

  // Classic desk bell ring
  static Uint8List getBell() {
    return generateWav(
      notes: [880.0, 1760.0], // A5 + high harmonic
      delays: [0.0, 0.005],
      duration: 1.2,
      volume: 0.4,
    );
  }

  // Key click
  static Uint8List getClick() {
    return generateWav(
      notes: [2000.0],
      delays: [0.0],
      duration: 0.05,
      volume: 0.2,
    );
  }

  // Premium spin wheel tick — 3-layer design:
  //   500Hz  = warm body (the 'weight' of the peg)
  //   1400Hz = click presence (the satisfying 'tık')
  //   2800Hz = air/crispness (sparkle on top)
  // Staggered decays simulate a natural mechanical impact.
  static Uint8List getWheelTick() {
    final sampleRate = 44100;
    final activeSamples = (sampleRate * 0.035).toInt(); // 35ms aktif ses
    final totalSamples = (sampleRate * 0.09).toInt();   // 90ms toplam (Android kırpma koruması)
    final samples = Float32List(totalSamples);
    final fadeOutStart = (activeSamples * 0.75).toInt();

    for (var i = 0; i < activeSamples; i++) {
      final t = i / sampleRate;

      // Layer 1: Body — 500Hz, slow-ish decay (gives 'weight')
      final body = sin(2 * pi * 500.0 * t) * exp(-t * 90.0) * 0.35;

      // Layer 2: Click presence — 1400Hz, fast decay (the main 'tık')
      final click = sin(2 * pi * 1400.0 * t) * exp(-t * 160.0) * 0.50;

      // Layer 3: Air — 2800Hz, instant decay (adds crispness)
      final air = sin(2 * pi * 2800.0 * t) * exp(-t * 250.0) * 0.15;

      var sample = (body + click + air) * 0.30; // master volume
      if (i > fadeOutStart) {
        final fadeFactor = (activeSamples - i) / (activeSamples - fadeOutStart);
        sample *= fadeFactor;
      }
      if (sample > 1.0) sample = 1.0;
      if (sample < -1.0) sample = -1.0;
      samples[i] = sample;
    }

    // Encode as 16-bit mono WAV
    final subchunk2Size = totalSamples * 2;
    final wavData = ByteData(44 + subchunk2Size);
    // RIFF header
    wavData.setUint8(0, 0x52); wavData.setUint8(1, 0x49);
    wavData.setUint8(2, 0x46); wavData.setUint8(3, 0x46);
    wavData.setUint32(4, 36 + subchunk2Size, Endian.little);
    wavData.setUint8(8, 0x57); wavData.setUint8(9, 0x41);
    wavData.setUint8(10, 0x56); wavData.setUint8(11, 0x45);
    // fmt subchunk
    wavData.setUint8(12, 0x66); wavData.setUint8(13, 0x6D);
    wavData.setUint8(14, 0x74); wavData.setUint8(15, 0x20);
    wavData.setUint32(16, 16, Endian.little);
    wavData.setUint16(20, 1, Endian.little);
    wavData.setUint16(22, 1, Endian.little);
    wavData.setUint32(24, sampleRate, Endian.little);
    wavData.setUint32(28, sampleRate * 2, Endian.little);
    wavData.setUint16(32, 2, Endian.little);
    wavData.setUint16(34, 16, Endian.little);
    // data subchunk
    wavData.setUint8(36, 0x64); wavData.setUint8(37, 0x61);
    wavData.setUint8(38, 0x74); wavData.setUint8(39, 0x61);
    wavData.setUint32(40, subchunk2Size, Endian.little);
    for (var i = 0; i < totalSamples; i++) {
      wavData.setInt16(44 + i * 2, (samples[i] * 32767.0).toInt(), Endian.little);
    }
    return wavData.buffer.asUint8List();
  }

  // ── Tek Seferlik Çark Dönme Sesi (Tınnn) ──
  // Kullanıcının isteği üzerine: kasmayı önlemek için tek parça, uzun, 
  // yavaşça azalan büyülü bir çınlama sesi (3.2 saniye sürer)
  static Uint8List getWheelSpinResonance() {
    return generateWav(
      notes: [440.0, 554.37, 659.25, 880.0], // A major arpeggio
      delays: [0.0, 0.05, 0.10, 0.15],
      duration: 3.2,
      volume: 0.25,
      attackTime: 0.05,
      decayRate: 1.5, // 3 saniye boyunca yavaş yavaş azalacak sönümleme
    );
  }

  // Generate a single 3.5 second track containing all the ticks at specific times.
  // This eliminates stuttering caused by firing hundreds of play() events on Android.
  static Uint8List generateFullSpinSequence(List<double> tickDelays) {
    final sampleRate = 44100;
    final duration = 3.5;
    final totalSamples = (sampleRate * duration).toInt();
    final samples = Float32List(totalSamples);
    
    final activeSamples = (sampleRate * 0.035).toInt();
    final fadeOutStart = (activeSamples * 0.75).toInt();

    for (final delay in tickDelays) {
      final startSample = (delay * sampleRate).toInt();
      for (var i = 0; i < activeSamples; i++) {
        final idx = startSample + i;
        if (idx >= totalSamples) break;
        
        final t = i / sampleRate;
        final body = sin(2 * pi * 500.0 * t) * exp(-t * 90.0) * 0.35;
        final click = sin(2 * pi * 1400.0 * t) * exp(-t * 160.0) * 0.50;
        final air = sin(2 * pi * 2800.0 * t) * exp(-t * 250.0) * 0.15;
        
        var sample = (body + click + air) * 0.30;
        if (i > fadeOutStart) {
          final fadeFactor = (activeSamples - i) / (activeSamples - fadeOutStart);
          sample *= fadeFactor;
        }
        
        samples[idx] += sample;
      }
    }

    // Normalize if too loud
    for (var i = 0; i < totalSamples; i++) {
      if (samples[i] > 1.0) samples[i] = 1.0;
      if (samples[i] < -1.0) samples[i] = -1.0;
    }

    final subchunk2Size = totalSamples * 2;
    final wavData = ByteData(44 + subchunk2Size);
    
    wavData.setUint8(0, 0x52); wavData.setUint8(1, 0x49);
    wavData.setUint8(2, 0x46); wavData.setUint8(3, 0x46);
    wavData.setUint32(4, 36 + subchunk2Size, Endian.little);
    wavData.setUint8(8, 0x57); wavData.setUint8(9, 0x41);
    wavData.setUint8(10, 0x56); wavData.setUint8(11, 0x45);
    wavData.setUint8(12, 0x66); wavData.setUint8(13, 0x6D);
    wavData.setUint8(14, 0x74); wavData.setUint8(15, 0x20);
    wavData.setUint32(16, 16, Endian.little);
    wavData.setUint16(20, 1, Endian.little);
    wavData.setUint16(22, 1, Endian.little);
    wavData.setUint32(24, sampleRate, Endian.little);
    wavData.setUint32(28, sampleRate * 2, Endian.little);
    wavData.setUint16(32, 2, Endian.little);
    wavData.setUint16(34, 16, Endian.little);
    wavData.setUint8(36, 0x64); wavData.setUint8(37, 0x61);
    wavData.setUint8(38, 0x74); wavData.setUint8(39, 0x61);
    wavData.setUint32(40, subchunk2Size, Endian.little);
    
    for (var i = 0; i < totalSamples; i++) {
      wavData.setInt16(44 + i * 2, (samples[i] * 32767.0).toInt(), Endian.little);
    }
    return wavData.buffer.asUint8List();
  }

  // Spin wheel result reveal — warm rising chime when wheel stops
  static Uint8List getWheelResult() {
    return generateWav(
      notes: [440.0, 554.37, 659.25], // A4, C#5, E5 — bright A major
      delays: [0.0, 0.06, 0.12],
      duration: 0.8,
      volume: 0.35,
      attackTime: 0.04,
      decayRate: 3.0,
    );
  }
}
