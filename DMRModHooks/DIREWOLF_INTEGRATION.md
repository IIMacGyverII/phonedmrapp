# Dire Wolf Integration Plan

## Current Status

Created basic NDK structure:
- ✅ `app/src/main/cpp/` directory
- ✅ `CMakeLists.txt` build configuration
- ✅ `DireWolfDecoder.java` JNI wrapper class
- ✅ `direwolf_jni.cpp` native interface
- ✅ Updated `build.gradle` with NDK support

## Challenge

Dire Wolf's full codebase is complex and designed for:
- Streaming audio with callbacks
- Multi-threading
- Platform-specific audio I/O 
- Global state management

## Options

### Option A: Full Dire Wolf Integration (Complex)
**Time:** Several hours
**Steps:**
1. Port Dire Wolf's demodulator state machine
2. Handle all dependencies (20+ C files)
3. Adapt callback architecture
4. Test cross-platform compilation
5. Debug JNI bridging

**Pros:** Industry standard, proven
**Cons:** Complex, large binary size, may have portability issues

### Option B: Extract Core Algorithm (Recommended)
**Time:** 1-2 hours
**Steps:**
1. Copy Dire Wolf's Goertzel filter implementation
2. Copy NRZI decoding logic
3. Copy bit synchronization/PLL
4. Adapt to single-function interface
5. Keep simple, no global state

**Pros:** Simpler, smaller, easier to debug
**Cons:** Need to understand and port algorithm

### Option C: Fix Existing AFSKDecoder.java (Fastest)
**Time:** 30 minutes - 1 hour
**Steps:**
1. Compare with Dire Wolf's parameters
2. Fix Goertzel coefficients
3. Adjust PLL/bit timing
4. Test with known-good audio

**Pros:** No NDK complexity, smallest change
**Cons:** Still debugging existing code

## My Recommendation

Try **Option C first** (quickest), fallback to **Option B** if needed.

Since Dire Wolf decodes the same files your decoder fails on, the difference is likely small - probably:
- Goertzel filter parameters
- PLL time constants  
- Bit timing tolerances

Let me add detailed logging to see where AFSKDecoder.java diverges from Dire Wolf's results.

