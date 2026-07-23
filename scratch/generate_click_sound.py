import wave, math, struct

output_path = r"c:\Erol_Mobil_Gelistirme\TurizmAkademi\assets\sounds\button_click.wav"

sample_rate = 44100
duration_sec = 0.065 # 65 milliseconds
num_samples = int(sample_rate * duration_sec)

# We want a soft, warm, pleasant UI tap/pop (gentle sine wave with warm pitch drop and fast exponential decay)
samples = []
for i in range(num_samples):
    t = i / sample_rate
    # Frequency drops smoothly from 580Hz to 280Hz
    freq = 580.0 * math.exp(-t * 22.0) + 280.0
    phase = 2.0 * math.pi * (580.0 * (1.0 - math.exp(-t * 22.0)) / 22.0 + 280.0 * t)
    
    # Smooth envelope: fast 1.5ms attack, exponential decay
    attack_samples = int(sample_rate * 0.0015)
    if i < attack_samples:
        envelope = i / attack_samples
    else:
        decay_t = (i - attack_samples) / sample_rate
        envelope = math.exp(-decay_t * 55.0)
    
    # Soft max volume (around 0.25 of max 16-bit range) to keep it gentle and pleasant
    val = math.sin(phase) * envelope * 0.22
    
    # Add a tiny warm sub-harmonic for tactile richness
    sub_val = math.sin(phase * 0.5) * envelope * 0.08
    
    final_sample = int((val + sub_val) * 32767.0)
    final_sample = max(-32768, min(32767, final_sample))
    samples.append(final_sample)

# Write to 16-bit mono WAV file
with open(output_path, 'wb') as wav_file:
    # 44100Hz, 1 channel, 2 bytes per sample
    nchannels = 1
    sampwidth = 2
    framerate = sample_rate
    nframes = num_samples
    comptype = "NONE"
    compname = "not compressed"
    
    # Manual WAV header writing via wave module
    with wave.open(output_path, 'w') as w:
        w.setparams((nchannels, sampwidth, framerate, nframes, comptype, compname))
        for sample in samples:
            w.writeframes(struct.pack('<h', sample))

print(f"Gentle UI Click sound generated successfully at: {output_path}")
