import wave, math, struct

output_path = r"c:\Erol_Mobil_Gelistirme\TurizmAkademi\assets\sounds\apple_click.wav"

sample_rate = 44100
duration_sec = 0.045 # 45ms Apple Taptic Engine style impulse
num_samples = int(sample_rate * duration_sec)

samples = []
for i in range(num_samples):
    t = i / sample_rate
    
    # 1. Warm Body (Taptic Engine low pulse) - 420Hz down to 160Hz
    freq_body = 420.0 * math.exp(-t * 35.0) + 160.0
    phase_body = 2.0 * math.pi * (420.0 * (1.0 - math.exp(-t * 35.0)) / 35.0 + 160.0 * t)
    body = math.sin(phase_body) * math.exp(-t * 70.0) * 0.40
    
    # 2. Crisp Presence (Apple Glass Pop) - 1250Hz down to 600Hz
    freq_pop = 1250.0 * math.exp(-t * 60.0) + 600.0
    phase_pop = 2.0 * math.pi * (1250.0 * (1.0 - math.exp(-t * 60.0)) / 60.0 + 600.0 * t)
    pop = math.sin(phase_pop) * math.exp(-t * 140.0) * 0.25
    
    # 3. Soft Air Sparkle - 2400Hz ultra-fast decay
    air = math.sin(2.0 * math.pi * 2400.0 * t) * math.exp(-t * 220.0) * 0.08
    
    # Combined signal
    val = (body + pop + air) * 0.22 # Silky volume
    
    # Envelope: 1.2ms smooth attack, gentle tail anti-pop fade
    attack_samples = int(sample_rate * 0.0012)
    if i < attack_samples:
        envelope = i / attack_samples
    else:
        envelope = 1.0
        
    fade_out_samples = int(sample_rate * 0.010)
    if i > num_samples - fade_out_samples:
        envelope *= (num_samples - i) / fade_out_samples
        
    final_sample = int(val * envelope * 32767.0)
    final_sample = max(-32768, min(32767, final_sample))
    samples.append(final_sample)

# Write to WAV
with wave.open(output_path, 'w') as w:
    w.setparams((1, 2, sample_rate, num_samples, "NONE", "not compressed"))
    for sample in samples:
        w.writeframes(struct.pack('<h', sample))

print(f"Apple-style soft Taptic UI Click generated at: {output_path}")
