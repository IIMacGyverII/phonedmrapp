# Software Squelch Implementation Design

## Problem Statement
The radio hardware firmware forces squelch to `sq=2` for all values except `sq=0`. We cannot dynamically adjust squelch levels 1-9 at runtime using the hardware squelch.

## Solution: Software Squelch
Implement squelch in software by:
1. Setting hardware squelch to `sq=0` (fully open - always receive audio)
2. Intercepting audio PCM data before playback
3. Calculating audio amplitude/level
4. Muting audio below user-defined threshold
5. Allowing audio above threshold to play normally

This is exactly how Software-Defined Radios (SDRs) implement squelch.

---

## Architecture

### Components Already in Place ✅

#### 1. **Audio Interception Hook** (`MainHook.java:5306-5360`)
```java
PCMReceiveManager.writeAudioTrack(byte[] audioData, int length)
```
- **Location**: All audio passes through this method before playback
- **Hook Status**: Already hooked in `hookPCMReceiveManager()`
- **Data Format**: PCM 16-bit signed, 8000 Hz, Mono (channel config 0xc)
- **Hook Point**: `beforeHookedMethod()` - we can modify audio BEFORE it plays

#### 2. **RSSI Signal Strength** (Available via Hardware)
- **Class**: `SignalMessage.smali`
- **Command**: `QUERY_SIGNAL_STRENGTH_CMD` (0x32)
- **Field**: `rssi` (byte) - signal strength in dBm
- **Handler**: `SignalMessageHandler.smali`
- **Status**: Hardware supports RSSI queries (can be used for RSSI-based squelch)

#### 3. **Audio Playback Control**
- **Class**: `PCMReceiveManager`
- **Method**: `AudioTrack.write(byte[], int, int)` - writes audio to speaker
- **Volume**: `AnalogMessage.setVolume(byte)` - hardware volume control
- **Control**: We can replace audio data with silence before it reaches AudioTrack

---

## Implementation Plan

### Phase 1: Audio Level-Based Squelch (Simple & Fast) 🎯

#### Step 1: Calculate Audio Amplitude
In `PCMReceiveManager.writeAudioTrack()` hook:

```java
private static int calculateAudioAmplitude(byte[] pcmData, int length) {
    // PCM 16-bit format: 2 bytes per sample (Little Endian)
    // Calculate RMS (Root Mean Square) amplitude
    
    long sumSquares = 0;
    int sampleCount = length / 2;  // 2 bytes per 16-bit sample
    
    for (int i = 0; i < length - 1; i += 2) {
        // Combine 2 bytes into 16-bit signed sample (Little Endian)
        short sample = (short) ((pcmData[i] & 0xFF) | (pcmData[i + 1] << 8));
        sumSquares += (long) sample * sample;
    }
    
    if (sampleCount == 0) return 0;
    
    // RMS amplitude
    int rms = (int) Math.sqrt(sumSquares / sampleCount);
    return rms;
}
```

#### Step 2: Apply Squelch Threshold
```java
@Override
protected void beforeHookedMethod(MethodHookParam param) throws Throwable {
    byte[] audioData = (byte[]) param.args[0];
    int length = (int) param.args[1];
    
    // Calculate audio level
    int amplitude = calculateAudioAmplitude(audioData, length);
    
    // Get squelch threshold from settings (0-9 mapped to amplitude levels)
    int squelchThreshold = getSquelchThreshold();
    
    // If audio is below threshold, replace with silence
    if (amplitude < squelchThreshold) {
        // Mute: replace audio with zeros (silence)
        Arrays.fill(audioData, 0, length, (byte) 0);
        
        // Optional: Visual indicator
        updateSquelchStatus(false); // Squelch closed
    } else {
        // Allow audio to pass through
        updateSquelchStatus(true);  // Squelch open
    }
    
    // Audio continues to existing hooks (APRS, transcription, recording)
    // Existing code remains unchanged...
}
```

#### Step 3: Map User Squelch Levels (0-9) to Amplitude
```java
private static int getSquelchThreshold() {
    // User squelch setting (0-9)
    // 0 = most sensitive (lowest threshold, always open)
    // 9 = least sensitive (highest threshold, only strong signals)
    
    int userSquelch = aprsDatabase.getAprsSquelch(); // or from slider
    
    // Map 0-9 to amplitude thresholds (16-bit signed)
    // These values need tuning based on real-world testing
    int[] thresholds = {
        0,      // 0: Always open (no squelch)
        50,     // 1: Very sensitive
        100,    // 2: Default (similar to hardware sq=2)
        200,    // 3
        400,    // 4
        800,    // 5: Medium
        1600,   // 6
        3200,   // 7
        6400,   // 8
        12800   // 9: Only very strong signals
    };
    
    return thresholds[Math.min(userSquelch, 9)];
}
```

#### Step 4: Set Hardware Squelch to 0
When enabling software squelch:
```java
// In APRS monitoring setup or intercom page:
try {
    // Force hardware squelch to 0 (fully open)
    Object analogMessage = createAnalogMessage(currentChannel);
    XposedHelpers.callMethod(analogMessage, "setSq", (byte) 0);
    XposedHelpers.callMethod(analogMessage, "send");
    
    XposedBridge.log(TAG + ": Software squelch enabled - hardware sq set to 0");
} catch (Throwable t) {
    XposedBridge.log(TAG + ": Error setting hardware squelch: " + t);
}
```

---

### Phase 2: RSSI-Based Squelch (Advanced) 🚀

If audio-level squelch is insufficient, implement RSSI-based squelch:

#### Query RSSI from Radio
```java
private static void querySignalStrength() {
    try {
        Class<?> signalMsgClass = XposedHelpers.findClass(
            "com.pri.prizeinterphone.message.SignalMessage",
            classLoader
        );
        
        Object signalMsg = signalMsgClass.newInstance();
        XposedHelpers.setByteField(signalMsg, "fetch", (byte) 1); // Query
        XposedHelpers.callMethod(signalMsg, "send");
        
        // Response handled by SignalMessageHandler
    } catch (Throwable t) {
        XposedBridge.log(TAG + ": Error querying signal strength: " + t);
    }
}
```

#### Hook SignalMessageHandler to Capture RSSI
```java
// Hook SignalMessageHandler.handle(SignalMessage)
@Override
protected void afterHookedMethod(MethodHookParam param) throws Throwable {
    Object signalMsg = param.args[0];
    byte rssi = XposedHelpers.getByteField(signalMsg, "rssi");
    
    currentRssi = rssi; // Store for squelch decision
    XposedBridge.log(TAG + ": RSSI: " + rssi + " dBm");
}
```

#### RSSI-Based Squelch Logic
```java
// In writeAudioTrack hook:
if (currentRssi != -999) {
    // Use RSSI instead of audio amplitude
    int rssiThreshold = getRssiThreshold(userSquelch);
    
    if (currentRssi < rssiThreshold) {
        // Weak signal - mute
        Arrays.fill(audioData, 0, length, (byte) 0);
    }
}
```

**Advantages of RSSI:**
- More reliable than audio level (noise floor independent)
- Faster response (no need to analyze audio)
- Better for weak signals with noise

**Disadvantages:**
- Requires periodic RSSI queries (adds overhead)
- May not reflect actual audio content (carrier present but no modulation)

---

### Phase 3: Hybrid Squelch (Best of Both) 🎯🚀

Combine both methods for optimal performance:

```java
// Hybrid squelch decision
boolean shouldMute = false;

if (useRssi && currentRssi != -999) {
    // Primary: RSSI-based (if available)
    shouldMute = (currentRssi < rssiThreshold);
} else {
    // Fallback: Audio level-based
    int amplitude = calculateAudioAmplitude(audioData, length);
    shouldMute = (amplitude < amplitudeThreshold);
}

if (shouldMute) {
    Arrays.fill(audioData, 0, length, (byte) 0);
}
```

---

## User Interface Changes

### 1. Update Squelch Sliders
- **Remove warning** about squelch 0 not working
- **Add label**: "Software Squelch: [0-9]"
- **Add visual indicator**: Squelch open/closed status (LED)

### 2. APRS Monitoring Page
```java
// Add squelch status indicator
TextView squelchStatus = new TextView(activity);
squelchStatus.setText("⬤ Squelch: OPEN");  // Green dot when open
squelchStatus.setTextColor(0xFF00FF00);
// Updates in real-time as squelch opens/closes
```

### 3. Intercom Page
- Keep existing squelch slider
- Software squelch works automatically
- Show audio level meter (optional feature)

---

## Testing Strategy

### 1. **Verify Hardware Squelch Set to 0**
- Monitor logs for: `"Software squelch enabled - hardware sq set to 0"`
- Check audio is always received (noise present when no signal)

### 2. **Test Amplitude Calculation**
- Log RMS values during reception
- Tune threshold mapping based on actual values
- Distinguish noise floor from real signals

### 3. **Test Squelch Levels**
- Set squelch to 0: Should hear everything (noise + signals)
- Set squelch to 2: Should block noise, allow normal signals
- Set squelch to 9: Should only allow very strong signals

### 4. **Test APRS Decoding**
- Ensure software squelch doesn't break APRS decoding
- APRS buffer should receive audio BEFORE squelch muting
- Current code already does this (buffer happens before modification)

### 5. **Performance Testing**
- Measure CPU impact of amplitude calculation
- Should be negligible (simple math on ~1000 samples per chunk)
- No noticeable delay in audio output

---

## Code Locations

### Files to Modify
1. **`MainHook.java`**
   - Line ~5320: Modify `hookPCMReceiveManager()` - add squelch logic
   - Line ~250: Add squelch threshold calculation methods
   - Line ~3500: Update APRS page squelch slider UI
   - Line ~1250: Update intercom page squelch slider UI

2. **`APRSDatabase.java`** (if not using existing squelch field)
   - Add `setSoftwareSquelchEnabled(boolean)`
   - Add `getSoftwareSquelchThreshold()`

### New Methods to Add
```java
// Audio analysis
private static int calculateAudioAmplitude(byte[], int);
private static int getSquelchThreshold();
private static int getRssiThreshold(int);

// Squelch control
private static void enableSoftwareSquelch();
private static void disableSoftwareSquelch();
private static void updateSquelchStatus(boolean open);

// RSSI handling (Phase 2)
private static void querySignalStrength();
private static void hookSignalMessageHandler();
```

---

## Configuration Options

### SharedPreferences Keys
```java
"software_squelch_enabled"       // boolean (default: true)
"software_squelch_mode"          // "audio" | "rssi" | "hybrid"
"software_squelch_threshold"     // int 0-9 (default: 2)
"show_squelch_indicator"         // boolean (default: true)
"show_audio_level_meter"         // boolean (default: false)
```

---

## Benefits

### ✅ **Solves Hardware Limitation**
- Bypasses firmware squelch=2 bug
- Full control over squelch levels 0-9

### ✅ **Better Flexibility**
- Can implement advanced squelch algorithms
- Can add features like tail squelch, hysteresis, etc.

### ✅ **No Hardware Modification**
- Pure software solution
- Works with existing radio firmware

### ✅ **Maintains Compatibility**
- APRS decoding unaffected (happens before muting)
- Recording works (can optionally record pre-squelch audio)
- Transcription works (if enabled)

---

## Potential Issues & Solutions

### Issue 1: **Audio Choppiness**
- **Cause**: Squelch opening/closing too rapidly (flutter)
- **Solution**: Add hysteresis (different open/close thresholds)
   ```java
   int openThreshold = baseThreshold;
   int closeThreshold = baseThreshold - 50; // Lower to avoid flutter
   ```

### Issue 2: **Missing Weak Signals**
- **Cause**: Threshold too high
- **Solution**: Default to squelch=2, user can adjust
- **Alternative**: Use RSSI-based squelch (more reliable)

### Issue 3: **Not Blocking Noise**
- **Cause**: Noise floor higher than threshold
- **Solution**: Auto-calibrate noise floor on startup
   ```java
   // Measure noise floor for 1 second when no signal present
   int noiseFloor = measureNoiseFloor();
   // Set minimum threshold above noise floor
   ```

### Issue 4: **CPU Usage**
- **Cause**: Calculating RMS for every audio chunk
- **Solution**: RMS calculation is very efficient (~1000 samples × simple math)
- **Optimization**: Can sample every Nth sample if needed

---

## Timeline

### Sprint 1 (Immediate - 2 hours)
- [x] Research audio interception (DONE)
- [x] Research RSSI availability (DONE)
- [ ] Implement Phase 1: Audio level squelch
- [ ] Test threshold mapping (0-9)
- [ ] Update UI labels and indicators

### Sprint 2 (Optional - 3 hours)
- [ ] Implement Phase 2: RSSI-based squelch
- [ ] Hook SignalMessageHandler
- [ ] Periodic RSSI queries
- [ ] Compare audio vs RSSI effectiveness

### Sprint 3 (Polish - 1 hour)
- [ ] Add hysteresis to prevent flutter
- [ ] Add audio level meter visualization
- [ ] Add noise floor calibration
- [ ] Performance optimization

---

## Success Criteria

1. ✅ Hardware squelch set to 0 (verified in logs)
2. ✅ Audio below threshold is muted
3. ✅ Audio above threshold passes through
4. ✅ Squelch levels 0-9 all work correctly
5. ✅ APRS decoding unaffected
6. ✅ No audio delay or choppiness
7. ✅ CPU usage < 2% increase

---

## References

- **Hardware Analysis**: `SQUELCH_HARDWARE_LIMITATION.md`
- **User Memory**: `/memories/aprs-squelch-investigation.md`
- **Code Location**: `MainHook.java:5306-5360` (PCMReceiveManager hook)
- **Audio Format**: PCM 16-bit signed, 8000 Hz, Mono
- **RSSI Command**: `Const$Command.QUERY_SIGNAL_STRENGTH_CMD` (0x32)
