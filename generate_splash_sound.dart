import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

void main() {
  final sampleRate = 44100;
  final duration = 4.0;
  final numSamples = (sampleRate * duration).toInt();

  // Frequencies for a Cmaj9 chord
  final notes = [261.63, 329.63, 392.00, 493.88, 587.33];
  final delays = [0.0, 0.08, 0.16, 0.24, 0.32];

  final samples = Float32List(numSamples);

  for (var i = 0; i < numSamples; i++) {
    final t = i / sampleRate;
    var sample = 0.0;

    for (var j = 0; j < notes.length; j++) {
      final note = notes[j];
      final delay = delays[j];

      if (t > delay) {
        final tt = t - delay;
        // Envelope: fast attack, exponential decay
        final attack = 0.05;
        var env = 0.0;
        if (tt < attack) {
          env = tt / attack;
        } else {
          env = exp(-(tt - attack) * 2.0);
        }

        // Sine wave with harmonics for a bell/vibraphone tone
        final freq = note;
        var val = sin(2 * pi * freq * tt);
        val += 0.4 * sin(2 * pi * freq * 2.0 * tt) * exp(-tt * 4.0);
        val += 0.2 * sin(2 * pi * freq * 3.0 * tt) * exp(-tt * 6.0);
        val += 0.1 * sin(2 * pi * freq * 4.0 * tt) * exp(-tt * 8.0);

        // Tremolo/Vibrato effect
        final lfo = 1.0 + 0.1 * sin(2 * pi * 5.0 * tt);

        sample += val * env * lfo;
      }
    }

    // Normalize
    sample = sample / (notes.length * 1.5);

    // Soft clipping
    if (sample > 1.0) sample = 1.0;
    if (sample < -1.0) sample = -1.0;

    samples[i] = sample;
  }

  // Create WAV bytes
  final subchunk2Size = numSamples * 2; // 16-bit samples
  final wavData = ByteData(44 + subchunk2Size);

  // RIFF Header
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
  wavData.setUint32(16, 16, Endian.little); // Subchunk1Size
  wavData.setUint16(20, 1, Endian.little); // AudioFormat (1 = PCM)
  wavData.setUint16(22, 1, Endian.little); // NumChannels (1 = Mono)
  wavData.setUint32(24, sampleRate, Endian.little); // SampleRate
  wavData.setUint32(28, sampleRate * 2, Endian.little); // ByteRate (SampleRate * NumChannels * BitsPerSample/8)
  wavData.setUint16(32, 2, Endian.little); // BlockAlign (NumChannels * BitsPerSample/8)
  wavData.setUint16(34, 16, Endian.little); // BitsPerSample

  // Subchunk 2 (data)
  wavData.setUint8(36, 0x64); // d
  wavData.setUint8(37, 0x61); // a
  wavData.setUint8(38, 0x74); // t
  wavData.setUint8(39, 0x61); // a
  wavData.setUint32(40, subchunk2Size, Endian.little);

  // Write samples
  for (var i = 0; i < numSamples; i++) {
    final sampleInt = (samples[i] * 32767.0).toInt();
    wavData.setInt16(44 + i * 2, sampleInt, Endian.little);
  }

  // Ensure directory exists
  final soundsDir = Directory('assets/sounds');
  if (!soundsDir.existsSync()) {
    soundsDir.createSync(recursive: true);
  }

  final wavFile = File('assets/sounds/splash_sound.wav');
  wavFile.writeAsBytesSync(wavData.buffer.asUint8List());

  print('splash_sound.wav generated successfully via Dart!');
}
