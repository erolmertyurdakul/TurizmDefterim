import wave
import math
import struct
import os

sample_rate = 44100
duration = 4.0

# frequencies for a Cmaj9 chord (premium, soft, pedagogical)
# C4, E4, G4, B4, D5
notes = [261.63, 329.63, 392.00, 493.88, 587.33] 
delays = [0.0, 0.08, 0.16, 0.24, 0.32] # Arpeggio

audio = []
for i in range(int(sample_rate * duration)):
    t = i / sample_rate
    sample = 0
    
    for note, delay in zip(notes, delays):
        if t > delay:
            tt = t - delay
            # Envelope: fast attack, exponential decay
            attack = 0.05
            if tt < attack:
                env = (tt / attack)
            else:
                env = math.exp(-(tt - attack) * 2.0)
                
            # Sine wave with harmonics for a bell/vibraphone tone
            freq = note
            val = math.sin(2 * math.pi * freq * tt)
            val += 0.4 * math.sin(2 * math.pi * freq * 2.0 * tt) * math.exp(-tt * 4.0)
            val += 0.2 * math.sin(2 * math.pi * freq * 3.0 * tt) * math.exp(-tt * 6.0)
            val += 0.1 * math.sin(2 * math.pi * freq * 4.0 * tt) * math.exp(-tt * 8.0)
            
            # Tremolo/Vibrato effect for a premium feel
            lfo = 1.0 + 0.1 * math.sin(2 * math.pi * 5.0 * tt)
            
            sample += val * env * lfo

    # Normalize
    sample = sample / (len(notes) * 1.5)
    
    # Soft clipping to avoid hard digital distortion
    if sample > 1.0: sample = 1.0
    if sample < -1.0: sample = -1.0
    
    # 16-bit PCM
    val_int = int(sample * 32767.0)
    audio.append(struct.pack('<h', val_int))

os.makedirs('assets/sounds', exist_ok=True)
with wave.open('assets/sounds/splash_sound.wav', 'w') as f:
    f.setnchannels(1)
    f.setsampwidth(2)
    f.setframerate(sample_rate)
    f.writeframes(b''.join(audio))

print("splash_sound.wav generated successfully!")
