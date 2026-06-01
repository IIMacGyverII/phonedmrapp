# Real Radio APRS Testing Guide

## Option 1: Record Real Radio Audio (Recommended!)

### Setup Steps

1. **Install PyAudio** (for Python audio recording):
   ```powershell
   pip install pyaudio
   ```
   
   If that fails (common on Windows), try:
   ```powershell
   pip install pipwin
   pipwin install pyaudio
   ```
   
   Or download wheel from: https://www.lfd.uci.edu/~gohlke/pythonlibs/#pyaudio

2. **Connect Your Radio**:
   - Option A: Radio headphone jack → PC microphone/line-in
   - Option B: USB sound card adapter
   - Option C: Use PC internal microphone (near radio speaker)

3. **Record APRS Transmission**:
   ```powershell
   python record_real_aprs.py
   ```
   
   This will:
   - List audio input devices
   - Record 10 seconds of audio
   - Test with Dire Wolf
   - Test with our custom parser
   - Save as `real_aprs_recording.wav`

4. **Transmit from your other radio** while recording:
   - Set radio to APRS beacon mode
   - Or manually key PTT and send beacon
   - Script will capture the audio

### Alternative: Manual Recording

If PyAudio won't install:

1. **Use Windows Sound Recorder**:
   - Win+R → `mspaint` → Sound Recorder (or use Audacity)
   - Set input to your radio connection
   - Record while transmitting APRS beacon
   - Save as WAV (44100 Hz, 16-bit, mono)

2. **Test the recording**:
   ```powershell
   python parse_full_packet.py your_recording.wav
   C:\path\to\atest.exe -B 1200 your_recording.wav
   ```

## Option 2: Download multimon-ng

### For Windows

**Pre-built binary may not be available.** Options:

1. **Use WSL (Windows Subsystem for Linux)**:
   ```bash
   sudo apt-get install multimon-ng
   multimon-ng -a AFSK1200 -t wav your_file.wav
   ```

2. **Compile from source** (requires MinGW/MSYS2):
   ```bash
   git clone https://github.com/EliasOenal/multimon-ng.git
   cd multimon-ng
   mkdir build && cd build
   cmake ..
   make
   ```

3. **Use Docker**:
   ```powershell
   docker run --rm -v ${PWD}:/data alpine/multimon-ng -a AFSK1200 -t wav /data/aprs_fixed_test.wav
   ```

## What We'll Learn

### From Real Radio Test:

✓ **Validates our decoder** - Can it read real APRS?
✓ **Compares waveforms** - How does real radio audio differ from ours?
✓ **Tests Dire Wolf** - Does it decode the real radio?
✓ **Identifies issues** - What characteristics does real APRS have that ours doesn't?

### Comparison Analysis:

Once you have `real_aprs_recording.wav`:

```powershell
# Compare first FLAG between real and our generated
python compare_first_flag.py  # Modify to use real recording

# Extract tone patterns
python extract_nrzi_bits.py    # Modify to compare with real

# Parse packet structure
python parse_full_packet.py real_aprs_recording.wav
python parse_full_packet.py aprs_fixed_test.wav

# Check waveform parameters
python compare_wav_files.py    # Modify to compare real vs ours
```

## Quick Start (Recommended)

**Easiest approach:**

1. Connect radio to PC audio input
2. Use Windows Sound Recorder (Win Key + type "Sound Recorder")
3. Press Record
4. Transmit APRS beacon from your radio
5. Stop recording, save as `real_aprs.wav`
6. Test:
   ```powershell
   C:\path\to\direwolf\atest.exe -B 1200 real_aprs.wav
   python parse_full_packet.py real_aprs.wav
   ```

This will immediately show:
- ✓ If Dire Wolf decodes real radio APRS
- ✓ If our parser decodes real radio APRS  
- ✓ What real APRS audio looks like vs our generated audio

**This is the ultimate validation!** 🎯
