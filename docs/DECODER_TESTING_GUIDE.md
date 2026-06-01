# APRS Decoder Testing Procedure

## Current Status

Your DMR app has:
- ✅ **AFSKGenerator.java** - Updated with all 5 fixes
- ✅ **AFSKDecoder.java** - Appears correct (NRZI, bit unstuffing, FLAG detection)
- ❓ **Need to verify** - Does decoder work with fixed generator?

## Decoder Logic Check ✓

Your decoder has:
- ✓ NRZI decoding: `transition=0, no transition=1` (correct)
- ✓ Starts at MARK state (matches generator)
- ✓ Bit unstuffing (removes 0 after five 1s)
- ✓ FLAG detection (0x7E = 01111110)
- ✓ LSB-first byte conversion

## Test Plan

### Test 1: Can Your App Decode Known-Good APRS?

Use our proven test file:

```powershell
# Generate a known-good APRS packet
cd C:\Users\Joshua\Documents\android\phonedmrapp
python aprs_generator_fixed.py
```

This creates `aprs_fixed_test.wav` which we KNOW is valid (our parser decodes it).

**Now:**
1. Copy `aprs_fixed_test.wav` to your phone (Downloads folder)
2. In your app, try to:
   - Load/play this WAV file
   - Have AFSKDecoder process it
   - Check if it decodes correctly

**Expected Result:**
```
Destination: APZDMR-0
Source: WB2OSZ-15
Info: ,The quick brown fox...
```

### Test 2: Can Your App Decode Its Own Generated Packets?

**In-App Loopback Test:**

1. **Generate** beacon in app:
   ```java
   byte[] packet = APRSPacketEncoder.encodePositionPacket(...);
   short[] audio = AFSKGenerator.generateAFSKWithNRZI(packet);
   ```

2. **Immediately decode** the same audio:
   ```java
   List<byte[]> decoded = AFSKDecoder.decode(audio);
   ```

3. **Compare:**
   - Does `decoded` contain the original packet?
   - Does FCS verify?
   - Do all fields match?

### Test 3: Check Saved WAV Files

Your decoder saves audio to WAV files (line 46: `saveAudioToWAV(audioSamples)`).

**Check your phone:**
- Look for saved WAV files (probably in app's private storage)
- Copy one to PC
- Test with our tools:

```powershell
cd C:\Users\Joshua\Documents\android\phonedmrapp
python parse_full_packet.py received_from_app.wav
```

## Potential Issues to Check

### Issue 1: Sample Rate Mismatch?

Your decoder expects: **48000 Hz** (line 24)
Your generator uses: **48000 Hz** ✓

Both match! But verify audio is actually 48kHz.

### Issue 2: Timing/Sync

The Goertzel filter in your decoder processes samples in chunks. If timing is slightly off, it might miss the sync.

**Check logs:**
```bash
# Check Android logs for decoder output
adb logcat | grep "DMRModHooks-APRS-Decoder"
```

Look for:
- "Demodulated X bits"
- "Found X raw packet bit arrays"
- "Total flags found: X"

### Issue 3: FLAG Detection

Your decoder looks for FLAGS in the bit stream. 

**Question:** When you say "it used to decode", what changed?
- Did you only update AFSKGenerator.java?
- Did anything change in how packets are structured?
- Does the app log show FLAGS being found?

## Quick Diagnostic

**Run this on your phone's app:**

1. Generate a beacon
2. Check logs immediately:
   ```bash
   adb logcat -s "DMRModHooks-APRS-Decoder:*"
   ```

**Look for:**
- "Demodulated X bits" - should be ~600+ for a typical packet
- "First bits: ..." - should start with FLAGs (01111110)
- "After NRZI: ..." - should also show FLAG patterns
- "Total flags found: X" - should be at least 2 (start + end)
- "Found X raw packet bit arrays" - should be 1+

## If Decoder Fails

**Possible fixes:**

1. **Adjust Goertzel window size** (currently uses SAMPLES_PER_BIT = 40)
2. **Adjust power detection threshold** (currently just `markPower > spacePower`)
3. **Check initial NRZI state** (currently `previousState = true`)

## What Information Do You Have?

To help debug, tell me:
1. **Does the app LOG anything** when trying to decode?
2. **What method triggers decoding** in your app? (button press? automatic?)
3. **Can you see the saved WAV files?** (to test with our tools)
4. **What was working before?** (what changed between working and now?)

Let me know what you find and I can help fix any decoder issues!
