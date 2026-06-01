# SSTV Implementation Research

## Executive Summary
This document analyzes requirements for implementing SSTV (Slow Scan Television) decoding capability, using the existing APRS monitoring implementation as an architectural reference.

**Status**: Research Phase  
**Complexity**: Moderate (audio processing similar to APRS, but image decoding more complex)  
**Estimated Effort**: 2-3 weeks for basic implementation

---

## 1. SSTV Technical Background

### What is SSTV?
**Slow Scan Television (SSTV)** is an analog picture transmission method used by amateur radio operators to send and receive images over radio frequencies.

### Key Characteristics:
- **Analog transmission** (unlike digital packet radio)
- **Frequency modulation** of audio tones (1500 Hz center, ±400 Hz deviation)
- **Typical bandwidth**: 2.2 kHz (fits in standard voice channel)
- **Transmission time**: 8 seconds to 4 minutes per image
- **Common frequency**: 144.500 MHz (VHF), 14.230 MHz (HF)
- **Image resolution**: 320×256 (Martin M1) down to 160×128 (Robot)

### SSTV Modes (Most Common):
**⭐ = Recommended for Phase 1 (fast testing)**

| Mode | Resolution | Color | Duration | Line Time | Priority |
|------|-----------|-------|----------|-----------|----------|
| **Martin M1** | 320×256 | RGB | 114 sec | 146 ms | Medium (common but slow) |
| **Martin M2** | 320×256 | RGB | 58 sec | 73 ms | Medium |
| **Scottie S1** | 320×256 | RGB | 110 sec | 138 ms | Medium |
| **Scottie S2** | 320×256 | RGB | 71 sec | 88 ms | Medium |
| **Robot 36** ⭐ | 320×240 | YUV | 36 sec | 150 ms | **HIGH** (fastest test cycles) |
| **Robot 72** | 320×240 | YUV | 72 sec | 300 ms | Medium |
| **PD 120** | 640×496 | RGB | 126 sec | 121 ms | Low (defer to V2) |
| **PD 180** | 640×496 | RGB | 188 sec | 183 ms | Low (defer to V2) |

### VIS (Vertical Interval Signaling) Code:
- **Purpose**: Identifies the SSTV mode being transmitted
- **Timing**: Transmitted at start of image (after leader tone)
- **Structure**: 
  - Leader tone: 1900 Hz for 300ms
  - Break: 1200 Hz for 10ms
  - VIS start bit: 1900 Hz for 30ms
  - 7 data bits (LSB first): 1100 Hz = 0, 1300 Hz = 1
  - Parity bit
  - Stop bit: 1200 Hz for 30ms

**Common VIS Codes:**
- Martin M1: 0x2C (44)
- Martin M2: 0x28 (40)
- Scottie S1: 0x3C (60)
- Robot 36: 0x08 (8)

---

## 2. Comparison: APRS vs SSTV

### APRS Implementation (Current System)

#### Audio Capture:
```
PCMReceiveManager.writeAudioTrack() hook
    ↓
8kHz 16-bit PCM audio (byte array)
    ↓
Buffer 1-2 seconds of audio
    ↓
AFSKDecoder.decode() → AX.25 packets
    ↓
APRSPacketDecoder → parsed location/text data
    ↓
Store in database + display
```

#### Key Components:
1. **Audio capture**: PCM hook (8kHz, already working)
2. **Decoder**: `AFSKDecoder.java` - Bell 202 AFSK (1200 baud)
3. **Protocol parser**: `APRSPacketDecoder.java` - AX.25 frames
4. **Data model**: `APRSPacketDecoder.APRSPacket` class
5. **Storage**: `APRSReceivedDatabase` (SQLite)
6. **UI**: Live monitoring dialog with scrolling text list

### SSTV Implementation (Proposed)

#### Audio Processing Flow:
```
PCMReceiveManager.writeAudioTrack() hook
    ↓
8kHz 16-bit PCM audio (byte array)
    ↓
Continuous buffering during transmission
    ↓
SSTVDecoder.detectVIS() → identify mode
    ↓
SSTVDecoder.decodeImage() → RGB pixel data
    ↓
Convert to Android Bitmap
    ↓
Save as JPEG/PNG + display in gallery
```

#### Key Components Needed:
1. **Audio capture**: ✅ REUSE existing PCM hook (8kHz is sufficient)
2. **VIS detector**: NEW - detect leader tone + decode VIS code
3. **SSTV decoder**: NEW - FM demodulation + line sync + RGB extraction
4. **Image builder**: NEW - convert scanlines to Bitmap
5. **Storage**: NEW - save images to Download/DMR/SSTV/
6. **UI**: NEW - image viewer dialog with progress bar

---

## 3. Key Differences from APRS

| Aspect | APRS | SSTV |
|--------|------|------|
| **Signal type** | Digital FSK (Bell 202) | Analog FM |
| **Bandwidth** | 1200 Hz (1200/2200 Hz tones) | 2200 Hz (1100-1900 Hz range) |
| **Duration** | 0.5-2 seconds (short packets) | 8-180 seconds (full image) |
| **Decoding** | Digital (bit extraction) | Analog (FM demodulation) |
| **Output** | Text/coordinates | RGB image (320×256 pixels) |
| **Buffering** | Short (1-2 sec) | Long (up to 3 minutes) |
| **Sync signal** | Flag byte (0x7E) | Sync pulse (1200 Hz, 5ms) |
| **Error correction** | CRC-16 in AX.25 | None (visible as noise) |
| **Sample rate** | 8kHz sufficient | 8kHz sufficient (Nyquist for 2.2kHz) |

---

## 4. Technical Requirements

### 4.1 Audio Processing
✅ **Reuse existing infrastructure**:
- Same PCM hook (`hookPCMReceiveManager`)
- Same 8kHz 16-bit PCM format
- Similar buffering approach (but longer duration)

⚠️ **New requirements**:
- **No squelch during reception** (SSTV requires continuous audio)
- **Longer buffer** (up to 3 minutes = 1.44 MB at 8kHz)
- **Real-time processing** (show image as it's received)

### 4.2 VIS Code Detection
**Algorithm**:
1. Monitor for 1900 Hz leader tone (300ms minimum)
2. Detect break tone (1200 Hz, 10ms)
3. Decode 8 bits using Goertzel algorithm:
   - Sample 30ms windows
   - Detect 1100 Hz (bit=0) vs 1300 Hz (bit=1)
4. Verify parity bit
5. Return VIS code (identifies SSTV mode)

**Implementation**: Goertzel filter or FFT

### 4.3 FM Demodulation
**SSTV uses frequency modulation**:
- Sync pulse: 1200 Hz (marks start of line)
- Black level: 1500 Hz
- White level: 2300 Hz
- Color info: Linear mapping from 1500-2300 Hz → 0-255

**Algorithm Options**:
1. **Quadrature demodulation** (phase difference)
2. **Zero-crossing detection** (simple but noisy)
3. **Goertzel filter bank** (measure frequency at each sample)

**Recommended**: Quadrature demodulation (most common in SSTV software)

### 4.4 Line Synchronization
Each scanline starts with **sync pulse** (1200 Hz, 5ms). Must detect and align.

**Algorithm**:
1. Detect 1200 Hz tone for 5ms
2. Mark as start of scanline
3. Decode pixel values for line duration (varies by mode)
4. Repeat for all lines (256 lines for Martin M1)

### 4.5 Image Construction
**Process**:
1. Initialize Bitmap (320×256 pixels for Martin M1)
2. For each scanline:
   - RGB modes (Martin, Scottie): Decode R, then G, then B separately
   - YUV modes (Robot): Decode Y (luminance), U, V (chrominance), convert to RGB
3. Write pixels to Bitmap row by row
4. Display progressive image (update every 10 lines for visual feedback)

---

## 5. Available Libraries and Resources

### 5.1 Android SSTV Decoder Libraries

#### Option 1: **Port existing open-source decoder**
**Best candidates**:

1. **QSSTV** (C++)
   - URL: http://users.telenet.be/on4qz/qsstv/index.html
   - License: GPL v3
   - Platform: Linux/Qt
   - Features: All major SSTV modes, VIS detection, image correction
   - **Pros**: Battle-tested, comprehensive
   - **Cons**: C++/Qt code, requires significant porting effort

2. **Robot36** (Android app, open source)
   - URL: https://github.com/xdsopl/robot36
   - License: GPL v3
   - Platform: Native Android (Java + JNI)
   - Features: Robot 36/72 decoder only
   - **Pros**: Already Android-native, working code
   - **Cons**: Limited to Robot modes only

3. **PySSTV** (Python)
   - URL: https://github.com/dnet/pysstv
   - License: MIT
   - Platform: Python
   - Features: Encoder only (not decoder)
   - **Pros**: Clean Python code, easy to understand
   - **Cons**: No decoder (only encoder)

4. **slowrx** (C)
   - URL: https://github.com/windytan/slowrx
   - License: MIT
   - Platform: Linux/C
   - Features: Martin, Scottie, Robot modes
   - **Pros**: Clean C code, MIT license (permissive)
   - **Cons**: Requires porting to Java/Android

**RECOMMENDATION**: Port **slowrx** or **Robot36**
- slowrx: Cleanest code, MIT license
- Robot36: Already on Android, can extract decoder logic

#### Option 2: **Pure Java implementation from scratch**
**Pros**: 
- No JNI complexity
- Full control over performance
- Can optimize for Xposed hook environment

**Cons**:
- 2-3 weeks development time
- Need to implement FM demodulation from scratch
- Requires DSP expertise

**RECOMMENDATION**: Start with library port, then optimize if needed

### 5.2 DSP Libraries for Java/Android

1. **JTransforms** (FFT library)
   - URL: https://github.com/wendykierp/JTransforms
   - License: MPL/LGPL
   - Features: Fast FFT, DCT implementations
   - Use case: VIS detection, frequency analysis

2. **TarsosDSP** (Audio processing)
   - URL: https://github.com/JorenSix/TarsosDSP
   - License: GPL v3
   - Features: Pitch detection, Goertzel, FFT
   - Use case: FM demodulation, tone detection

---

## 6. Implementation Architecture

### 6.1 Reusable Components from APRS

```java
// REUSE: Audio capture (no changes needed)
hookPCMReceiveManager() {
    // Same hook point
    bufferAudioForSSTV(audioData, length);  // NEW buffer method
}

// REUSE: Monitoring state management
private static volatile boolean isSSTVMonitoringActive = false;
private static AlertDialog sstvMonitoringDialog = null;

// REUSE: UI pattern (similar to showAPRSLiveMonitoringScreen)
private void showSSTVLiveMonitoringScreen(Activity activity) {
    // Similar dialog structure
    // But display ImageView instead of TextView
}

// REUSE: Frequency tuning (same channel hijack approach)
private void startSSTVMonitoring(Activity activity) {
    // Same as startAPRSMonitoring()
    // Tune to 144.500 MHz (SSTV calling frequency)
    // Set analog mode, squelch=OFF (critical!)
}
```

### 6.2 New Components for SSTV

```java
// NEW: SSTV Decoder
public class SSTVDecoder {
    public static class SSTVImage {
        public int mode;             // VIS code
        public String modeName;      // "Martin M1", etc.
        public Bitmap image;         // Decoded image
        public long timestamp;
        public boolean isComplete;   // Fully received?
    }
    
    // Detect VIS code from audio
    public static int detectVIS(short[] audioSamples);
    
    // Decode image from audio (progressive)
    public static SSTVImage decodeImage(short[] audioSamples, int mode);
}

// NEW: FM Demodulator
class FMDemodulator {
    // Convert FM audio to pixel brightness values
    public static float[] demodulate(short[] audioSamples);
}

// NEW: Line Synchronizer
class LineSynchronizer {
    // Detect sync pulses and align scanlines
    public static int[] findSyncPositions(float[] demodulated, int mode);
}

// NEW: Image Builder
class SSTVImageBuilder {
    private Bitmap bitmap;
    private int currentLine;
    
    public void addScanline(int lineNumber, float[] pixelValues);
    public Bitmap getBitmap();
}

// NEW: SSTV Receiver (analogous to APRSReceiver)
public class SSTVReceiver {
    private static SSTVReceiver instance;
    private SSTVImageBuilder currentImage;
    private int detectedMode = -1;
    
    // Called by PCM hook during SSTV monitoring
    public void processAudio(short[] audioSamples) {
        if (detectedMode == -1) {
            // Still waiting for VIS code
            detectedMode = SSTVDecoder.detectVIS(audioSamples);
            if (detectedMode != -1) {
                // Start new image
                currentImage = new SSTVImageBuilder(detectedMode);
            }
        } else {
            // Decode image data
            currentImage.addAudio(audioSamples);
            // Update UI progressively
            updateSSTVDisplay();
        }
    }
}

// NEW: SSTV Database (store received images)
public class SSTVReceivedDatabase {
    public void storeImage(Bitmap image, int mode, long timestamp);
    public List<SSTVImage> getRecentImages();
}
```

### 6.3 File Structure (parallel to APRS)

```
app/src/main/java/com/dmrmod/hooks/
├── MainHook.java                    # Add SSTV hooks
├── SSTVDecoder.java                 # NEW - Main decoder
├── SSTVReceiver.java                # NEW - Audio processor
├── SSTVImageBuilder.java            # NEW - Bitmap constructor
├── FMDemodulator.java               # NEW - FM demodulation
├── LineSynchronizer.java            # NEW - Sync detection
├── SSTVReceivedDatabase.java        # NEW - Image storage
└── SSTVMode.java                    # NEW - Mode definitions
```

---

## 7. Implementation Phases

### Phase 1: Basic VIS Detection (Week 1)
**Goal**: Detect SSTV signals and identify mode

**Tasks**:
1. ✅ Create SSTV button in packet radio menu (already done)
2. Implement `SSTVReceiver.java` skeleton
3. Add SSTV audio buffering to PCM hook
4. Implement Goertzel filter for tone detection
5. Implement VIS code decoder
6. Test with recorded SSTV audio files

**Deliverable**: App can detect "Martin M1 signal detected!" in logs

### Phase 2: FM Demodulation (Week 2)
**Goal**: Convert FM audio to pixel data

**Tasks**:
1. Implement quadrature FM demodulator
2. Implement sync pulse detection
3. Test demodulation on known SSTV files
4. Validate pixel values match expected range

**Deliverable**: Raw pixel values logged correctly

### Phase 3: Image Reconstruction (Week 2-3)
**Goal**: Display received images

**Tasks**:
1. Implement `SSTVImageBuilder` (Martin M1 only)
2. Create live monitoring UI with ImageView
3. Show progressive image updates
4. Save completed images to storage
5. Test end-to-end with real signals

**Deliverable**: Working Martin M1 decoder with live display

### Phase 4: Additional Modes (Week 3+)
**Goal**: Support multiple SSTV modes

**Tasks**:
1. Add Scottie S1/S2 support
2. Add Robot 36 support
3. Implement mode auto-detection
4. Add slant correction (optional)
5. Add image gallery view

**Deliverable**: Multi-mode SSTV receiver

---

## 8. UI/UX Design

### Start Dialog (before monitoring)
```
┌─────────────────────────────────────┐
│ 📺 SSTV Monitoring Mode            │
├─────────────────────────────────────┤
│                                     │
│ ⚫ MONITORING INACTIVE              │
│                                     │
│ Press 'Start Monitoring' to begin   │
│ receiving SSTV images.              │
│                                     │
│ ─────────────────────────────────  │
│                                     │
│ Statistics:                         │
│ • Total images: 5                   │
│ • Recent (last hour): 2             │
│                                     │
│ Supported modes:                    │
│ • Martin M1/M2                      │
│ • Scottie S1/S2                     │
│ • Robot 36/72                       │
│                                     │
│ ℹ Images saved to:                  │
│   Download/DMR/SSTV/                │
│                                     │
│ [View Gallery] [Start Monitoring]   │
│                                     │
└─────────────────────────────────────┘
```

### Live Monitoring Screen
```
┌─────────────────────────────────────┐
│ 📺 SSTV Live Monitoring            │
├─────────────────────────────────────┤
│                                     │
│ Status: 🟢 RECEIVING                │
│ Frequency: 144.500 MHz              │
│ Mode: Martin M1                     │
│ Progress: ▓▓▓▓▓▓▓░░░ 75%           │
│                                     │
│ ┌─────────────────────────────────┐ │
│ │                                 │ │
│ │   [Progressive image display]   │ │
│ │     320x256 ImageView           │ │
│ │                                 │ │
│ └─────────────────────────────────┘ │
│                                     │
│ Received: Line 192/256              │
│ Time: 01:25 / 01:54                 │
│                                     │
│ [Save Image] [Stop Monitoring]      │
│                                     │
└─────────────────────────────────────┘
```

---

## 9. Testing Strategy

### Test Audio Sources

1. **Recorded SSTV files** (WAV format)
   - Source: https://www.qsl.net/kd6cji/sstv.html
   - Download sample Martin M1, Scottie S1, Robot 36 files
   - Play through PC, record on radio, test decoder

2. **SSTV generator apps**
   - Android: "Robot36 SSTV" (can generate test signals)
   - PC: MMSSTV (Windows), QSSTV (Linux)

3. **Online SSTV activity**
   - Monitor 144.500 MHz (VHF SSTV calling frequency)
   - Monitor 14.230 MHz (HF SSTV frequency)
   - Join SSTV nets for testing

### Success Criteria
- ✅ Detects VIS code correctly (95%+ accuracy)
- ✅ Decodes Martin M1 images (clean test files)
- ✅ Handles noisy signals gracefully (degrades, doesn't crash)
- ✅ Progressive display updates smoothly
- ✅ Images saved correctly to storage
- ✅ UI remains responsive during decoding

---

## 10. Android-Specific Challenges ⚠️

### Challenge 1: Thread Safety in Xposed Hook
**Problem**: PCM hook runs in audio callback thread. Blocking operations cause audio glitches.

**Solution**:
```java
// PCM hook (audio thread) - must be FAST
private void bufferAudioForSSTV(byte[] audioData, int length) {
    if (!isSSTVMonitoringActive) return;
    
    // Copy to circular buffer (lock-free or synchronized)
    synchronized (sstvAudioBuffer) {
        sstvAudioBuffer.write(audioData, 0, length);
    }
    
    // Signal decoder thread (non-blocking)
    if (!sstvDecoderThread.isAlive()) {
        sstvDecoderThread.start();
    }
}

// Separate decoder thread (background) - can be slow
private class SSTVDecoderThread extends Thread {
    @Override
    public void run() {
        while (isSSTVMonitoringActive) {
            // Read from circular buffer
            byte[] chunk = sstvAudioBuffer.read(8000); // 1 sec chunks
            
            // Process in background (FFT, demod, image building)
            processAudioChunk(chunk);
            
            // Update UI on main thread
            handler.post(() -> updateImageView());
        }
    }
}
```

**Critical**: Never block audio thread! Use HandlerThread or AsyncTask for decoding.

### Challenge 2: Battery Drain
**Problem**: 180-second image decoding = continuous CPU + wakelock.

**Solution**:
- Use `PowerManager.PARTIAL_WAKE_LOCK` (screen can sleep)
- Release wakelock when image complete or 5 min timeout
- Add battery warning in UI: "SSTV uses more power than APRS (long decodes)"
- Consider sampling rate reduction: 8kHz → 6kHz (still Nyquist-compliant for 2.3kHz)

### Challenge 3: Background Service Restrictions (Android 8+)
**Problem**: Oreo limits background services. App killed if backgrounded during decode.

**Solution**:
- Use Foreground Service with notification: "📺 Receiving SSTV Image (45%)..."
- Set `startForeground()` when SSTV monitoring starts
- Update notification progress bar as scanlines decode

### Challenge 4: Memory Pressure
**Problem**: 180 sec @ 8kHz 16-bit = 2.88 MB audio + Bitmap buffers.

**Solution**:
- Circular buffer (fixed 3 MB, overwrite old data)
- Process in 1-second chunks, discard after decode
- Use `Bitmap.Config.RGB_565` (2 bytes/pixel vs 4 for ARGB_8888)
- Total memory budget: ~5 MB (acceptable)

### Challenge 5: Concurrent Mode Conflicts
**Problem**: User enables APRS + SSTV simultaneously.

**Solution**:
```java
private void startSSTVMonitoring(Activity activity) {
    // Disable conflicting modes
    if (isAPRSMonitoringActive) {
        stopAPRSMonitoring(activity);
        Toast.makeText(activity, "APRS stopped (SSTV active)", Toast.LENGTH_SHORT).show();
    }
    // Same for other packet modes
}
```

---

## 11. Known Challenges and Solutions

### Challenge 1: Noise & Pre-filtering
**Problem**: Radio PCM includes DMR noise floor, adjacent channel interference.

**Solution**:
- **Bandpass filter** (1000-2500 Hz) before demodulation:
```java
// Use TarsosDSP BandPass filter
HighPass hp = new HighPass(1000, 8000); // 1kHz cutoff, 8kHz sample rate
LowPass lp = new LowPass(2500, 8000);   // 2.5kHz cutoff
float[] filtered = lp.filter(hp.filter(audioSamples));
```
- **Noise gate**: Drop audio below -40 dB threshold
- **AGC (Automatic Gain Control)**: Normalize signal to 0 dB before demod

### Challenge 2: Slant Correction (Upgraded Priority)
**Problem**: Clock drift causes diagonal slant in image.

**Solution** (now in Phase 1, not deferred!):
- **Basic auto-correction via sync detection**:
```java
// Re-lock to sync pulse every 10 lines (not just once at start)
private void decodeScanline(int lineNum) {
    if (lineNum % 10 == 0) {
        // Search ±50 samples for 1200 Hz sync pulse
        int syncOffset = findNextSync(audioBuffer, expectedPosition);
        expectedPosition = syncOffset + lineDuration;
    }
    // Decode pixels from expectedPosition
}
```
- Counts zero-crossings to track drift
- Post-process: Shear transform if slant > 5° (defer to V2)

### Challenge 3: Error Handling & Partial Decodes
**Problem**: Weak signals produce garbled images. No FEC in SSTV.

**Solution**:
- **Show partial image** with overlay: "⚠️ Signal Lost (Line 87/256)"
- **Auto-retry**: Detect VIS code again after 5 sec silence
- **Quality indicator**: Show RSSI + estimated SNR during decode
- **Manual mode override**: If VIS fails, user selects mode (dropdown)
- **Save garbled images**: User decides to keep or discard

```java
// UI with quality feedback
TextView qualityText = new TextView(activity);
qualityText.setText("RSSI: -95 dBm | SNR: 12 dB | Quality: Fair");
qualityText.setTextColor(rssi > -90 ? 0xFF00FF00 : 0xFFFF9900); // Green/Orange
```

### Challenge 4: Ham License & Legal Compliance
**Problem**: SSTV requires amateur radio license (FCC Part 97).

**Solution**:
- **First-run popup**: "⚠️ SSTV requires amateur radio certification. Receive-only is legal for monitoring."
- **Transmit warning** (if added later): "TX requires valid callsign. Enter in Settings."
- **Callsign database integration**: Extract sender callsign from audio metadata (if transmitted)
- **Power limits**: Ulefone = 1-5W (legal for Technician class on VHF)

---

## 12. Resource Requirements

### Development Time (Revised Estimate)
- **Phase 1 (VIS detection)**: 1 week (40 hours)
- **Phase 2 (FM demodulation + basic slant fix)**: 1.5 weeks (60 hours)
- **Phase 3 (Robot 36 decoder)**: 1 week (40 hours)
- **Phase 4 (Martin M1 decoder)**: 1 week (40 hours)
- **Phase 5 (Error handling, UI polish)**: 1.5 weeks (60 hours)

**Total Realistic**: 4-6 weeks for production-ready Robot 36 + Martin M1

**Note**: Original 3-4 week estimate was optimistic. Factor in Android debugging (thread issues, memory leaks) and real-world radio noise testing.

### External Dependencies
- **Optional**: JTransforms library (FFT)
- **Optional**: TarsosDSP (if pure Java approach)
- **Required**: None (can build from scratch)

### Storage Requirements
- **Per image**: 320×256 JPEG ≈ 50-100 KB
- **100 images**: ~5-10 MB
- **Solution**: Add cleanup policy (delete images older than 30 days)

---

## 13. Comparison with Existing Android Apps

### Robot36 (open source)
- **Features**: Robot 36/72 decoder only
- **Approach**: Native JNI decoder + Java UI
- **Performance**: Real-time on mid-range phones
- **Code quality**: Good, can learn from it

### SSTV Slow Scan TV (proprietary)
- **Features**: All major modes, encoder/decoder
- **Approach**: Unknown (likely native)
- **Performance**: Excellent
- **Cost**: Free with ads / $3.99 pro

### Our Implementation Goals
- **Advantage**: Integrated into radio app (no external audio cables)
- **Advantage**: Direct frequency control (no manual tuning)
- **Advantage**: Automatic monitoring (no user interaction needed)
- **Challenge**: Must work in Xposed hook environment

---

## 14. Risks and Mitigation

| Risk | Impact | Probability | Mitigation |
|------|--------|-------------|------------|
| **DSP complexity too high** | High | Medium | Port existing library instead of from-scratch |
| **Performance issues (slow decoding)** | Medium | Low | Optimize critical loops, use native if needed |
| **Audio quality too poor** | High | Medium | Test with real radio first, may need filtering |
| **Sync issues (slant)** | Low | High | Accept for V1, fix in V2 |
| **Memory usage too high** | Medium | Low | Use circular buffer, process chunks |

---

## 15. Recommended Next Steps (REVISED)

### Immediate Actions (This Week)
1. ✅ **Research complete** (this document)
2. **Clone Robot36 Android app** (https://github.com/xdsopl/robot36) - study decoder logic
3. **Download test audio files**:
   - Robot 36 sample (36 sec - fastest test cycles)
   - Martin M1 sample (114 sec)
   - From: https://www.qsl.net/kd6cji/sstv.html
4. **Set up test harness**:
   - Simple Java app: Play WAV file → VIS detector → log mode
   - Validate Goertzel implementation offline

### Short-term (Week 1-2) - Phase 1: VIS Detection
1. Implement `SSTVVISDetector.java`:
   - Leader tone detection (1900 Hz, 300ms)
   - Break tone (1200 Hz, 10ms)
   - 8-bit decode using Goertzel (1100 Hz = 0, 1300 Hz = 1)
2. **Test with Robot36 samples** (VIS code 0x08)
3. Integrate into PCM hook (async buffering)
4. Enable SSTV button in packet radio menu
5. Add foreground service notification

**Deliverable**: "Robot 36 signal detected!" in logs + notification

### Medium-term (Week 2-4) - Phase 2: Robot 36 Decoder
1. Port FM demodulator from slowrx (use NDK for speed):
   - Quadrature demodulation (I/Q mixing)
   - Alternate: Use JTransforms FFT (pure Java, slower)
2. Implement sync pulse detection (1200 Hz, 5ms)
3. Implement Robot 36 scanline decoder:
   - YUV color space (simpler than RGB)
   - 320×240 resolution
   - 36 sec total (150ms per line)
4. Add bandpass pre-filter (1000-2500 Hz) using TarsosDSP
5. Implement basic slant correction (re-lock every 10 lines)

**Deliverable**: Working Robot 36 decoder (first mode!)

### Medium-term (Week 4-5) - Phase 3: Martin M1 & UI Polish
1. Implement Martin M1 decoder:
   - RGB color space (R, G, B separate passes)
   - 320×256 resolution
   - 114 sec total
2. Add live preview UI:
   - ImageView updated scanline-by-scanline
   - Progress bar: "Receiving: Line 87/256 (45%)"
   - RSSI/SNR quality indicator
3. Implement image gallery:
   - Save to /Download/DMR/SSTV/ as PNG
   - Metadata: Timestamp, mode, frequency
   - Share button (export to gallery/email)
4. Add manual mode override (if VIS fails)
5. Handle partial images (save with warning overlay)

**Deliverable**: Production-ready SSTV receiver (Robot 36 + Martin M1)

### Long-term (Week 6+) - Phase 4: Additional Features
1. Add Scottie S1/S2 modes
2. Implement advanced slant correction (shear transform)
3. Add noise reduction (adaptive filtering)
4. **Consider transmit** (modulate image → AudioTrack tones)
5. Add callsign metadata extraction
6. Optimize battery (downsample to 6kHz if possible)
7. Add ISS SSTV event notifications (integrate with ariss.org schedule)

**Deliverable**: Full-featured SSTV suite

---

## 16. Conclusion

**SSTV implementation is feasible** using the existing APRS monitoring architecture as a foundation. Key advantages:

✅ **Reuse audio capture** (PCM hook already works at 8kHz)  
✅ **Similar monitoring flow** (start/stop, live display, database storage)  
✅ **Open source libraries available** (Robot36 Android app, slowrx C code)  
✅ **Well-documented protocol** (SSTV specs, sample audio files)  
✅ **Differentiation factor** (few radios have built-in SSTV - adds value!)

**Key differences from APRS**:
- Longer audio buffering (30-180 sec vs 1-2 sec)
- Analog FM demodulation vs digital FSK
- Image output vs text/coordinates
- No error correction (noise = visible artifacts, not packet loss)
- Must handle thread safety (decoder runs in background)

**Recommended approach (REVISED)**:
1. ✅ Start with VIS detection proof-of-concept (Goertzel algorithm)
2. ✅ **Port Robot 36 decoder first** (36 sec = faster test cycles than Martin's 114 sec)
3. Use NDK for FM demod (native C from slowrx) OR JTransforms (pure Java)
4. Implement basic slant correction in V1 (re-lock to sync every 10 lines)
5. Add Martin M1 after Robot 36 is stable
6. Expand to Scottie/PD modes incrementally in V2
7. Consider transmit feature in V3 (modulate image to audio tones)

**Estimated timeline (REALISTIC)**: 
- **4-6 weeks** for production-ready Robot 36 + Martin M1 decoder
- Factor in Android-specific debugging (threads, memory, battery)
- Real-world radio testing (noise, slant, weak signals)

**Critical success factors**:
1. **Thread safety**: Never block audio callback (use HandlerThread)
2. **Battery management**: Use foreground service, release wakelocks
3. **Error handling**: Show partial images, auto-retry on signal loss
4. **User feedback**: Live preview, progress bar, quality indicators
5. **Testing**: Start with WAV files, then real on-air (144.500 MHz)

**This is an excellent fit for your mod** - SSTV adds "visual packet radio" excitement, complements APRS (position + photos), and is popular during ISS SSTV events. Ham radio community will love this feature!

---

## 17. References

### SSTV Protocol Documentation
- SSTV Handbook: http://www.barberdsp.com/files/Dayton%20Paper.pdf
- SSTV Modes: https://www.chongyangma.com/tutorials/sstv_encoder/SSTV_mode.html
- VIS Codes: http://www.barberdsp.com/downloads/Dayton%20Paper.pdf

### Open Source SSTV Projects
- slowrx: https://github.com/windytan/slowrx (MIT license, C)
- Robot36: https://github.com/xdsopl/robot36 (GPL v3, Android)
- QSSTV: http://users.telenet.be/on4qz/qsstv/ (GPL v3, Qt)

### DSP Resources
- JTransforms (FFT): https://github.com/wendykierp/JTransforms
- TarsosDSP: https://github.com/JorenSix/TarsosDSP
- Goertzel Algorithm: https://en.wikipedia.org/wiki/Goertzel_algorithm

### SSTV Test Files
- Sample audio: https://www.qsl.net/kd6cji/sstv.html
- ISS SSTV schedule: https://www.ariss.org/sstv.html

---

## 18. Expert Feedback Integration

### Key Improvements from Review (March 15, 2026)

**Strengths Validated**:
- ✅ APRS pipeline reuse (8kHz PCM, buffering, UI patterns)
- ✅ DSP feasibility (Goertzel/FFT lightweight for Android)
- ✅ Testing emphasis (sample audio + real on-air)
- ✅ Risk assessment realistic

**Weaknesses Addressed**:
1. **Android-specific challenges**: Added thread safety section (audio callback must be non-blocking), battery drain mitigation (foreground service, wakelocks), memory pressure (circular buffer, RGB_565 Bitmaps)
2. **Mode prioritization**: Changed to **Robot 36 first** (36 sec vs Martin M1's 114 sec = faster test cycles)
3. **Error handling**: Added auto-retry, partial image display, manual mode override, quality indicators (RSSI/SNR)
4. **Slant correction**: Upgraded from V2 deferrment to **basic implementation in Phase 1** (re-lock to sync every 10 lines)
5. **Legal compliance**: Added ham license reminder UI, callsign integration
6. **Timeline**: Revised to **4-6 weeks** (was 3-4) - more realistic for production quality

**New Recommendations Integrated**:
- ✅ Start with Robot 36 (YUV, faster), then Martin M1 (RGB, common)
- ✅ Port slowrx (C, MIT) via NDK for native speed
- ✅ Use Robot36 Android app (xdsopl/robot36) as reference
- ✅ Add bandpass pre-filter (1000-2500 Hz) using TarsosDSP
- ✅ Implement live "building" preview (scanline-by-scanline updates)
- ✅ Add gallery with metadata, sharing features for social ham appeal
- ✅ Handle partial images (save with overlay warning)
- ✅ WAV playback button for in-app testing before radio integration

**Expert Opinion Adopted**:
"SSTV is an excellent fit - adds 'visual packet' excitement, complements APRS position tracking with photo sharing, and differentiates from stock DMR. ISS SSTV events drive popularity. Budget 4-6 weeks for robust V1 (not 3-4). Start small (Robot 36 POC), iterate fast."

---

**Document Version**: 2.0 (Revised)  
**Date**: March 15, 2026  
**Authors**: GitHub Copilot + Expert Review Feedback  
**Status**: Research Complete + Expert-Validated - Ready for Implementation  
**Next Action**: Clone Robot36 repo, download test audio, implement VIS detector POC
