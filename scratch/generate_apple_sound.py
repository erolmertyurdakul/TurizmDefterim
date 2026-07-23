import math
import wave
import struct

def generate_apple_click(filename):
    sample_rate = 44100
    duration_sec = 0.035 # 35ms Taptic Engine impulse
    num_samples = int(sample_rate * duration_sec)
    
    samples = []
    for i in range(num_samples):
        t = i / sample_rate
        
        # 1. Deep Sub-body (Tok taptic hissi): 150Hz -> 65Hz
        phase_body = 2.0 * math.pi * (150.0 * (1.0 - math.exp(-t * 130.0)) / 130.0 + 65.0 * t)
        body = math.sin(phase_body) * math.exp(-t * 140.0) * 0.75
        
        # 2. Soft Glass Pop (Yumuşak Apple tık): 480Hz -> 200Hz
        phase_pop = 2.0 * math.pi * (480.0 * (1.0 - math.exp(-t * 200.0)) / 200.0 + 200.0 * t)
        pop = math.sin(phase_pop) * math.exp(-t * 240.0) * 0.30
        
        # Reduced volume by 15% (0.60 * 0.85 = 0.51)
        val = (body + pop) * 0.51
        
        # Envelope (0.5ms attack, 5ms fadeout)
        attack_samples = int(sample_rate * 0.0005)
        envelope = 1.0
        if i < attack_samples:
            envelope = i / attack_samples
        
        fade_out_samples = int(sample_rate * 0.005)
        if i > num_samples - fade_out_samples:
            envelope *= (num_samples - i) / fade_out_samples
            
        val *= envelope
        val = max(-1.0, min(1.0, val))
        sample_int = int(val * 32767.0)
        samples.append(sample_int)
        
    with wave.open(filename, 'w') as wav_file:
        wav_file.setnchannels(1) # Mono
        wav_file.setsampwidth(2) # 16-bit
        wav_file.setframerate(sample_rate)
        for s in samples:
            wav_file.writeframes(struct.pack('<h', s))

if __name__ == '__main__':
    import os
    os.makedirs('assets/sounds', exist_ok=True)
    generate_apple_click('assets/sounds/apple_soft_click.wav')
    print("Generated assets/sounds/apple_soft_click.wav (-15% volume) successfully!")
