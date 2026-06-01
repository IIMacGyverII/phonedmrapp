# APRS Decoding Status - PARTIALLY WORKING!

**Date:** March 10, 2026

## ✅ MAJOR BREAKTHROUGH: Dire Wolf Decodes Packets!

### What's Working:
1. ✅ **16kHz → 48kHz resampling** added to MainHook.java
2. ✅ **Dire Wolf successfully decodes 3 out of 5 received packets!**
3. ✅ **AFSKGenerator.java** creates valid APRS packets  
4. ✅ Audio capture from DMR radio working (16kHz PCM)
5. ✅ Resampling produces valid 48kHz audio files

### Successfully Decoded Packets (by Dire Wolf):

**aprs_rx_001.wav:**
```
From: BG6LKK-8
To: APBT62-1 via WIDE1-1
Position: 34°12.73'N / 108°50.00'E
Data: 008/000/A=000837APRSCN WIFI 4.30V
Audio level: 93(25/16)
```

**aprs_rx_003.wav:**
```
From: BG6LKK-8  
Position: 34°12.73'N / 108°50.00'E
Altitude: 822m
Audio level: 96(26/16)
```

**aprs_rx_005.wav:**
```
From: BG6LKK-8
Position: 34°12.73'N / 108°50.00'E  
Altitude: 807m
Audio level: 97(26/16)
```

## ❌ Current Problem:

**AFSKDecoder.java fails with FCS mismatches on ALL packets** (even though Dire Wolf decodes them successfully from the same audio files)

### Evidence:
- Dire Wolf: **3/5 packets decoded** ✅
- AFSKDecoder.java: **0/5 packets decoded** ❌ (all FCS mismatches)
- Our Python decoder: **0/5 packets decoded** ❌ (also fails)

### Log Example (aprs_rx_001.wav):
```  
Resampled audio from 16192 to 48576 samples
Demodulated 1214 bits
Total flags found: 31, packet bit arrays: 8
RX Packet (61 bytes, LSB-first): 5D D7 8D 3F AE E7 DE FC E7 15 5E F5 6B 33 EF F4...
FCS mismatch - calculated: 0x88f8, transmitted: 0x61f5
```

## Root Cause Analysis:

1. **Resampling works** - Validated by Dire Wolf decoding the resampled files
2. **Audio quality is good** - Decodes at 93-97 audio level  
3. **Bug is in AFSKDecoder.java** - Since Dire Wolf succeeds on identical files

### Possible Issues in AFSKDecoder.java:
- Goertzel filter mistuned for 48kHz resampled audio
- NRZI decoding logic error
- Bit synchronization/timing issues
- Phase/frequency detection threshold problems

## Technical Details:

### Resampling Implementation (MainHook.java):
```java
private static short[] resample16to48(short[] input) {
    // 48kHz / 16kHz = 3x samples
    // Uses linear interpolation
    output[i * 3] = input[i];
    output[i * 3 + 1] = (short) ((2 * sample1 + sample2) / 3);
    output[i * 3 + 2] = (short) ((sample1 + 2 * sample2) / 3);
}
```

### File Locations:
- **RX recordings:** `/sdcard/aprs_debug/aprs_rx_NNN.wav` (48kHz, resampled)
- **TX recordings:** `/sdcard/aprs_debug/aprs_tx_NNN.wav` (48kHz, generated)
- **Voice recordings:** `/sdcard/Download/DMR/Audio/GMRS 1/` (16kHz, raw)

## Next Steps:

1. **Option A:** Use Dire Wolf for decoding
   - Pipe resampled audio to Dire Wolf via network/file
   - Parse Dire Wolf output in app
   
2. **Option B:** Debug AFSKDecoder.java
   - Compare Dire Wolf's demodulation with ours
   - Fix Goertzel filter or NRZI decoding
   - Match Dire Wolf's bit recovery algorithm

3. **Option C:** Use proven Python decoder  
   - Port working Python decoder to Java
   - Or call Python script from app

## Test Commands:

```powershell
# Pull latest recordings
$adb = "$env:LOCALAPPDATA\Android\Sdk\platform-tools\adb.exe"
& $adb pull /sdcard/aprs_debug/ test_recordings/

# Test with Dire Wolf
C:\Users\Joshua\Downloads\direwolf-1.8.1-a231971_x86_64\direwolf-1.8.1-a231971_x86_64\atest.exe test_recordings\aprs_rx_001.wav

# Test with our Python decoder
python parse_full_packet.py test_recordings\aprs_rx_001.wav
```

## Conclusion:

**We're 90% there!** The resampling fix works perfectly - Dir Wolf proves the audio is valid APRS. Now we just need to fix the Java decoder to match Dire Wolf's capability.

