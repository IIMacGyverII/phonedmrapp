"""8 kHz mono test audio for the phone's transmitter: POCSAG pages (NRZ) or random-bit calibration.  mk8k.py pages|prbs <out> <amp>"""
import sys, wave, numpy as np
sys.path.insert(0, '..'); import pocsag as pc
kind, out, amp = sys.argv[1], sys.argv[2], float(sys.argv[3])
fs = 8000; spb = fs / 1200
if kind == 'pages':
    bits = []
    for ric, msg in ((1234567, 'SIGNALDECK TX TEST ONE'), (200001, 'Second page from the phone'), (777777, 'Third page 0123456789')):
        bits += pc.transmission(ric, 3, msg)
else:
    rng = np.random.default_rng(777); bits = [1, 0] * 288 + list(rng.integers(0, 2, 24000))
x = np.concatenate([np.full(int(round((i + 1) * spb)) - int(round(i * spb)), -1.0 if b else 1.0) for i, b in enumerate(bits)])
x = np.concatenate([np.zeros(fs // 4), x, np.zeros(fs // 4)])
open(out + '.bits', 'w').write(''.join(map(str, bits)))
w = wave.open(out, 'wb'); w.setnchannels(1); w.setsampwidth(2); w.setframerate(fs); w.writeframes((x * amp).astype('<i2').tobytes()); w.close()
print(out, round(len(x) / fs, 1), 's')
