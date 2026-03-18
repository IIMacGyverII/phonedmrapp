# SSTV Reference Decoder Analysis
## Source: colaclanth/sstv (C:\Users\Joshua\Downloads\sstv-master)

**Date**: March 15, 2026  
**Purpose**: Analyze working Python SSTV decoder to improve our Android implementation

---

## 1. FM Demodulation Method

### Algorithm: FFT with Peak Interpolation

```python
def _peak_fft_freq(self, data):
    """Finds the peak frequency from a section of audio data"""
    
    # Apply Hann window to reduce spectral leakage
    windowed_data = data * hann(len(data))
    
    # Compute FFT (real FFT for real-valued input)
    fft = np.abs(np.fft.rfft(windowed_data))
    
    # Find bin with maximum magnitude
    x = np.argmax(fft)
    
    # Barycentric interpolation for sub-bin accuracy
    peak = barycentric_peak_interp(fft, x)
    
    # Convert to Hz
    return peak * sample_rate / len(windowed_data)

def barycentric_peak_interp(bins, x):
    """Interpolate between frequency bins to find x value of peak"""
    
    # Use neighbors for interpolation
    y1 = bins[x] if x <= 0 else bins[x-1]
    y3 = bins[x] if x + 1 >= len(bins) else bins[x+1]
    
    denom = y3 + bins[x] + y1
    if denom == 0:
        return 0  # erroneous
    
    return (y3 - y1) / denom + x
```

**Key Insights:**
- **Uses FFT, not phase-based or zero-crossing FM demod**
- **Hann window** prevents spectral leakage (important!)
- **Barycentric interpolation** gives sub-bin frequency accuracy
- **Window size varies by mode** (see WINDOW_FACTOR below)
- Simple formula: `freq = (1500 to 2300 Hz)` → `brightness = 0 to 255`

**Brightness Calculation:**
```python
def calc_lum(freq):
    """Converts SSTV pixel frequency range into 0-255 luminance byte"""
    lum = int(round((freq - 1500) / 3.1372549))
    return min(max(lum, 0), 255)
```
→ `3.1372549 = 800 / 255` (the 800 Hz range divided by 255 levels)

---

## 2. Scottie S2 Mode Specification

### Official Timing Values (from spec.py)

```python
class S2(S1):
    NAME = "Scottie 2"
    
    COLOR = COL_FMT.GBR  # ★ Green, Blue, Red order
    LINE_WIDTH = 320
    LINE_COUNT = 256
    
    # Timing in seconds
    SCAN_TIME = 0.088064      # 88.064ms per channel
    SYNC_PULSE = 0.009000     # 9ms sync pulse @ 1200 Hz
    SYNC_PORCH = 0.001500     # 1.5ms porch/separator @ 1500 Hz
    SEP_PULSE = 0.001500      # 1.5ms separator @ 1500 Hz
    
    CHAN_COUNT = 3
    CHAN_SYNC = 2  # ★ Sync comes before channel index 2 (Red)
    CHAN_TIME = SEP_PULSE + SCAN_TIME  # 89.564ms
    
    # Channel offsets from sync start (★ CRITICAL!)
    CHAN_OFFSETS = [
        SYNC_PULSE + SYNC_PORCH + CHAN_TIME,  # Green offset
        CHAN_OFFSETS[0] + CHAN_TIME,          # Blue offset
        SYNC_PULSE + SYNC_PORCH                # Red offset
    ]
    
    LINE_TIME = SYNC_PULSE + 3 * CHAN_TIME  # Total line = 277.692ms
    PIXEL_TIME = SCAN_TIME / LINE_WIDTH     # 275.2 µs per pixel
    WINDOW_FACTOR = 3.82  # ★ FFT window size multiplier
    
    HAS_START_SYNC = True  # First line starts with sync
```

### Scanline Structure (★ KEY INSIGHT!)

**Physical scanline order:**
```
SYNC (9ms @ 1200Hz) 
→ PORCH (1.5ms @ 1500Hz)
→ RED (88.064ms)      ← Channel index 2 comes FIRST after sync!
→ SEP (1.5ms @ 1500Hz)
→ GREEN (88.064ms)    ← Channel index 0
→ SEP (1.5ms @ 1500Hz)
→ BLUE (88.064ms)     ← Channel index 1
→ [next line's SYNC]
```

**At 8 kHz sample rate:**
- SYNC = 72 samples
- PORCH = 12 samples
- RED = 704.512 samples (round to 705)
- SEP = 12 samples
- GREEN = 705 samples
- SEP = 12 samples
- BLUE = 705 samples
- **Total per line**: 2237 samples (279.625ms)

### Channel Offset Calculation (★ CRITICAL!)

The `CHAN_OFFSETS` are relative to the **current line's sync pulse start**:

```python
# At 8 kHz:
SYNC_PULSE = 72 samples
SYNC_PORCH = 12 samples
CHAN_TIME = 12 + 705 = 717 samples  # SEP + SCAN

CHAN_OFFSETS[2] = 72 + 12 = 84 samples          # Red starts 84 samples after sync
CHAN_OFFSETS[0] = 84 + 717 = 801 samples        # Green starts 801 samples after sync
CHAN_OFFSETS[1] = 801 + 717 = 1518 samples      # Blue starts 1518 samples after sync
```

**Wait, this is confusing!** The offsets suggest Green/Blue come on the SAME line, but the values indicate they're after the previous line's sync...

Let me re-read the decoder logic...

### Decoder Logic Explanation (decode.py lines 230-260)

```python
for line in range(height):
    if self.mode.CHAN_SYNC > 0 and line == 0:
        # First line only: back up to account for Green/Blue being "before" first sync
        sync_offset = self.mode.CHAN_OFFSETS[self.mode.CHAN_SYNC]  # Red offset = 84 samples
        seq_start -= round((sync_offset + self.mode.SCAN_TIME) * self._sample_rate)
        # This moves back by: 84 + 705 = 789 samples
        
    for chan in range(channels):  # 0=Green, 1=Blue, 2=Red
        if chan == self.mode.CHAN_SYNC:  # chan == 2 (Red)
            if line > 0 or chan > 0:
                # Advance to next line
                seq_start += round(self.mode.LINE_TIME * self._sample_rate)
            # Align to sync pulse
            seq_start = self._align_sync(seq_start)
```

**Aha! So the decoding order is:**
1. **Line 0**: Green(from previous), Blue(from previous), **SYNC**, Red
2. **Line 1**: Green, Blue, **SYNC**, Red
3. **Line 2**: Green, Blue, **SYNC**, Red
...and so on.

The `CHAN_OFFSETS` are always relative to the sync that comes **before** Red channel.

So for line N:
- Green of line N is at: `syncPos(line N) + 801 samples` = syncPos + 84 + 717
- Blue of line N is at: `syncPos(line N) + 1518 samples` = syncPos + 84 + 717 + 717  
- Red of line N is at: `syncPos(line N) + 84 samples` (right after sync+porch of line N)

**But wait, Line 0 Green/Blue come BEFORE the first sync!** That's why they back up on line 0.

Actually, re-reading more carefully:

The transmission structure is:
```
[Initial sync] → Green₀ → Blue₀ → [Sync for line 1] → Red₀ → Green₁ → Blue₁ → [Sync for line 2] → Red₁ → ...
```

No! That's not right either. Let me check CHAN_SYNC meaning...

**CHAN_SYNC = 2** means "channel index 2 (Red) is synchronized with the sync pulse"

So the actual structure is:
```
[Sync] → Porch → Red₀ → Sep → Green₀ → Sep → Blue₀ → [Sync] → Porch → Red₁ → Sep → Green₁ → Sep → Blue₁ → ...
```

And the offsets work like this:
- **Red** (chan 2): offset = 84 samples (after sync+porch)
- **Green** (chan 0): offset = 801 samples (after Red + Sep)
- **Blue** (chan 1): offset = 1518 samples (after Green + Sep)

But the CHAN_OFFSETS list is indexed [0, 1, 2] = [Green, Blue, Red]:
```python
CHAN_OFFSETS[0] = 801   # Green offset
CHAN_OFFSETS[1] = 1518  # Blue offset
CHAN_OFFSETS[2] = 84    # Red offset
```

No wait, that doesn't match the code! Let me re-read S2 spec:

```python
CHAN_OFFSETS = [SYNC_PULSE + SYNC_PORCH + CHAN_TIME]  # [0] = 10.5ms + 89.564ms = 100.064ms
CHAN_OFFSETS.append(CHAN_OFFSETS[0] + CHAN_TIME)      # [1] = 100.064ms + 89.564ms = 189.628ms
CHAN_OFFSETS.append(SYNC_PULSE + SYNC_PORCH)          # [2] = 10.5ms
```

So:
- `CHAN_OFFSETS[0] = 100.064ms = 801 samples` (Green)
- `CHAN_OFFSETS[1] = 189.628ms = 1517 samples` (Blue)
- `CHAN_OFFSETS[2] = 10.5ms = 84 samples` (Red)

**NOW IT MAKES SENSE:**

Physical scanline structure (each line):
```
[SYNC @ 1200Hz: 9ms/72 samples]
→ [PORCH @ 1500Hz: 1.5ms/12 samples]
→ RED channel: 88.064ms/705 samples       ← CHAN_OFFSETS[2] = 84 samples from sync start
→ [SEP @ 1500Hz: 1.5ms/12 samples]
→ GREEN channel: 88.064ms/705 samples     ← CHAN_OFFSETS[0] = 801 samples from sync start
→ [SEP @ 1500Hz: 1.5ms/12 samples]
→ BLUE channel: 88.064ms/705 samples      ← CHAN_OFFSETS[1] = 1517 samples from sync start
```

But the transmission starts with an **initial sync**, so:
```
[Initial SYNC]
→ [PORCH]
→ RED of line 0
→ [SEP]
→ GREEN of line 0
→ [SEP]
→ BLUE of line 0
→ [SYNC for line 1]
→ [PORCH]
→ RED of line 1
→ ...
```

**Actually no!** The `HAS_START_SYNC = True` means there's a sync at the very beginning, and `CHAN_SYNC = 2` means Red comes after the sync.

Let me look at the loop order again. The decoder loops:
```python
for chan in range(channels):  # iterates 0, 1, 2  (Green, Blue, Red order in array)
    if chan == self.mode.CHAN_SYNC:  # when chan == 2 (Red)
        # sync alignment happens here
```

So they iterate in order [0, 1, 2] = [Green, Blue, Red], but when they hit Red (2), they do the sync.

Combined with the offsets, the decoding order per line is:
1. Decode Green at `syncPos + CHAN_OFFSETS[0]`
2. Decode Blue at `syncPos + CHAN_OFFSETS[1]`  
3. When reaching Red: find next sync, then decode Red at `syncPos + CHAN_OFFSETS[2]`

But for Line 0, they back up so Green/Blue are decoded from the data before the first sync.

**CONCLUSION:**
The transmission line structure is:
```
Line N: [SYNC] → [PORCH] → RED → [SEP] → GREEN → [SEP] → BLUE
```

Channel offsets from sync start:
- Red: 84 samples (10.5ms)
- Green: 801 samples (100.125ms) 
- Blue: 1517 samples (189.625ms)

---

## 3. FFT Window Size

### WINDOW_FACTOR Calculation

```python
PIXEL_TIME = SCAN_TIME / LINE_WIDTH = 88.064ms / 320 = 275.2 µs
WINDOW_FACTOR = 3.82  # For Scottie S2

centre_window_time = (PIXEL_TIME * WINDOW_FACTOR) / 2
window_size_seconds = centre_window_time * 2
window_size_samples = round(window_size_seconds * sample_rate)
```

**At 8 kHz:**
```
centre_window_time = (275.2µs * 3.82) / 2 = 525.632 µs
window_size = 2 * 525.632µs * 8000 = 8.41 samples
```

Wait, that's tiny! Let me recalculate:
```
PIXEL_TIME = 0.088064 / 320 = 0.0002752 seconds = 275.2 µs = 2.2 samples @ 8kHz
centre_window_time = (PIXEL_TIME * 3.82) / 2 = 0.0005257 seconds
window_size = 0.0005257 * 2 * 8000 = 8.41 samples
```

That can't be right! Let me check how they actually use it:

```python
centre_window_time = (self.mode.PIXEL_TIME * window_factor) / 2
pixel_window = round(centre_window_time * 2 * self._sample_rate)

# For each pixel:
px_pos = round(seq_start + (chan_offset + px * pixel_time - centre_window_time) * sample_rate)
px_end = px_pos + pixel_window
pixel_area = self._samples[px_pos:px_end]
```

So:
```
centre_window_time = (275.2µs * 3.82) / 2 = 525.6µs
pixel_window = 525.6µs * 2 * 8000 Hz = 8.41 samples → rounds to 8 samples

px_pos = (pixel_center - 525.6µs) * 8000 = pixel_center - 4.2 samples
px_end = px_pos + 8
```

**They use an 8-sample FFT window centered on each pixel!**

But FFT with only 8 samples seems very low resolution:
```
FFT bin spacing = 8000 Hz / 8 samples = 1000 Hz per bin
```

That's WAY too coarse for 1500-2300 Hz range (only 1 bin of resolution!).

**Wait, I need to check if they're using a longer sample rate.** Let me check their examples...

Actually, looking at their README and examples, they likely expect **11025 Hz or 48000 Hz** audio files, not 8 kHz! That would explain the window size:

At 11025 Hz:
```
PIXEL_TIME = 0.0002752 seconds = 3.03 samples
centre_window_time = (3.03 * 3.82) / 2 = 5.79 samples center offset
pixel_window = 5.79 * 2 = 11.6 → 12 samples window
FFT resolution = 11025 Hz / 12 samples = 919 Hz per bin
```

Still coarse! But with barycentric interpolation, they get sub-bin accuracy.

At 48000 Hz (common for audio files):
```
PIXEL_TIME = 0.0002752 seconds = 13.2 samples
centre_window_time = (13.2 * 3.82) / 2 = 25.2 samples
pixel_window = 50 samples
FFT resolution = 48000 Hz / 50 = 960 Hz per bin
```

**Conclusion:** The WINDOW_FACTOR is tuned for higher sample rates. At 8 kHz, we need to adapt.

### Recommended Window Size for 8 kHz

At 8 kHz with Scottie S2:
- PIXEL_TIME = 2.2 samples per pixel
- We want at least 50-100 Hz frequency resolution
- Required FFT bins: 8000 Hz / 100 Hz = 80 samples minimum

**But** we can't use 80 samples for a pixel that's only 2.2 samples wide!

**Solution:** Overlap windows heavily. Use a fixed window size (32-64 samples) centered on each pixel, accepting that adjacent pixels will have highly overlapping FFT windows.

Our current approach (32 samples) gives:
```
FFT resolution = 8000 / 32 = 250 Hz per bin
SSTV range = 1500-2300 Hz = spans ~3.2 bins
```

With barycentric interpolation, this should be adequate.

**Better approach:** 64 samples
```
FFT resolution = 8000 / 64 = 125 Hz per bin  
SSTV range spans ~6.4 bins
```

---

## 4. Sync Pulse Detection

### Method: Frequency-based search

```python
def _align_sync(self, align_start, start_of_sync=True):
    """Returns sample where the beginning of the sync pulse was found"""
    
    sync_window = round(self.mode.SYNC_PULSE * 1.4 * self._sample_rate)
    
    for current_sample in range(align_start, align_stop):
        section_end = current_sample + sync_window
        search_section = self._samples[current_sample:section_end]
        
        # Sync pulse is 1200 Hz, find when frequency rises above 1350 Hz (end of sync)
        if self._peak_fft_freq(search_section) > 1350:
            break
    
    end_sync = current_sample + (sync_window // 2)
    
    if start_of_sync:
        return end_sync - round(self.mode.SYNC_PULSE * self._sample_rate)
    else:
        return end_sync
```

**Key points:**
- Searches for **end of sync** (when freq rises above 1350 Hz)
- Uses 1.4x sync pulse duration as search window (9ms * 1.4 = 12.6ms @ 8kHz = 101 samples)
- Returns either start or end of sync depending on parameter

**They find sync by looking for frequency DROP below ~1350 Hz, then rising back above!**

---

## 5. Key Takeaways for Our Implementation

### ✅ What We're Doing Right:
1. **Zero-crossing FM demod with 2x correction** - works fine, they just use FFT
2. **32-sample window** - reasonable compromise for 8 kHz
3. **Per-line timing detection** - good adaptive approach
4. **Porch/separator timing** - we just added this (12 samples)

### ❌ What We Need to Fix:

1. **Window size may be too small**
   - Current: 32 samples (250 Hz FFT resolution)
   - Consider: 64 samples (125 Hz resolution) or adaptive window
   
2. **Channel offset calculation**
   - We need to verify our porch placement is exactly right
   - Reference uses: Sync → Porch → Red → Sep → Green → Sep → Blue
   - Our current code places porches correctly (as of latest build)

3. **Consider switching to FFT demodulation**
   - Hann window + FFT + barycentric interpolation
   - More noise-resistant than zero-crossing
   - Reference decoder proves it works well

4. **Sync detection improvement**
   - Current: Look for 1200 Hz continuously
   - Reference: Look for freq crossing 1350 Hz threshold
   - More robust to noise

### 🔬 Testing Recommendations:

1. **Try 64-sample FFT window** (vs current 32 zero-crossing)
2. **Implement Hann windowing** for zero-crossing or FFT
3. **Verify porch timing** with detailed logs showing sample positions
4. **Add frequency histogram** to see actual detected range
5. **Compare with reference decoder output** on same WAV file

---

## 6. FFT-Based Demodulator Implementation Guide

If we want to switch from zero-crossing to FFT (like reference):

```java
public class SSTVFFTDemod {
    // Hann window coefficients (precompute for efficiency)
    private float[] hannWindow;
    
    public SSTVFFTDemod(int windowSize) {
        hannWindow = new float[windowSize];
        for (int i = 0; i < windowSize; i++) {
            hannWindow[i] = (float)(0.5 * (1 - Math.cos(2 * Math.PI * i / (windowSize - 1))));
        }
    }
    
    public float extractPixelFrequency(short[] samples, int startPos, int windowSize) {
        // Apply Hann window
        float[] windowed = new float[windowSize];
        for (int i = 0; i < windowSize; i++) {
            windowed[i] = samples[startPos + i] * hannWindow[i];
        }
        
        // Compute real FFT (rfft)
        // Need to implement or use library (Apache Commons Math, JTransforms, etc.)
        float[] fftMagnitude = computeRFFT(windowed);
        
        // Find peak bin
        int peakBin = 0;
        float peakMag = 0;
        for (int i = 0; i < fftMagnitude.length; i++) {
            if (fftMagnitude[i] > peakMag) {
                peakMag = fftMagnitude[i];
                peakBin = i;
            }
        }
        
        // Barycentric interpolation for sub-bin accuracy
        float y1 = (peakBin <= 0) ? fftMagnitude[peakBin] : fftMagnitude[peakBin - 1];
        float y2 = fftMagnitude[peakBin];
        float y3 = (peakBin + 1 >= fftMagnitude.length) ? fftMagnitude[peakBin] : fftMagnitude[peakBin + 1];
        
        float denom = y3 + y2 + y1;
        if (denom == 0) return 0;
        
        float interpolatedBin = ((y3 - y1) / denom) + peakBin;
        
        // Convert to Hz
        float freq = interpolatedBin * sampleRate / windowSize;
        
        return freq;
    }
}
```

**Challenge:** Android doesn't have `scipy` or `numpy.fft` built-in. We'd need:
- JTransforms library (FFT for Java)
- Or implement simple radix-2 FFT ourselves
- OrbApache Commons Math (has FFT)

**Recommendation:** Stick with zero-crossing for now, but consider FFT if quality issues persist.

---

## 7. Exact Timing Values We Should Use

Based on reference decoder, our constants should be:

```java
// Scottie S2 at 8000 Hz sample rate
private static final int SAMPLE_RATE = 8000;

// Timing in seconds (from spec)
private static final float SCAN_TIME = 0.088064f;      // 88.064ms
private static final float SYNC_PULSE = 0.009000f;     // 9ms
private static final float SYNC_PORCH = 0.001500f;     // 1.5ms  
private static final float SEP_PULSE = 0.001500f;      // 1.5ms

// Convert to samples
private static final int SYNC_SAMPLES = 72;            // 9ms * 8000
private static final int PORCH_SAMPLES = 12;           // 1.5ms * 8000
private static final int SEP_SAMPLES = 12;             // 1.5ms * 8000
private static final int SCAN_SAMPLES = 705;           // 88.064ms * 8000 (rounded from 704.512)

// Channel offsets from sync start
private static final int RED_OFFSET = 84;              // SYNC + PORCH = 72 + 12
private static final int GREEN_OFFSET = 801;           // RED_OFFSET + SCAN + SEP = 84 + 705 + 12
private static final int BLUE_OFFSET = 1518;           // GREEN_OFFSET + SCAN + SEP = 801 + 705 + 12

// Scanline structure:
// [SYNC: 72] → [PORCH: 12] → [RED: 705] → [SEP: 12] → [GREEN: 705] → [SEP: 12] → [BLUE: 705]
// Total: 2237 samples per line (279.625ms)
```

---

## Summary

The reference decoder uses **FFT with Hann windowing and barycentric interpolation** for FM demodulation, which is more sophisticated than our zero-crossing approach but also requires FFT libraries. Their timing values confirm our Scottie S2 implementation, and the channel structure is:

**SYNC → PORCH → RED → SEP → GREEN → SEP → BLUE** (repeat for each line)

Our latest code with porch timing should be correct. If issues persist, next steps are:
1. Increase window to 64 samples
2. Add Hann windowing to zero-crossing
3. Consider implementing FFT demodulation
4. Improve sync detection robustness
