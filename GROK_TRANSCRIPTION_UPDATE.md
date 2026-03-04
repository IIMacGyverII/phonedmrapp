# Transcription Feature - Status Update for Grok

**Date**: February 26, 2026  
**Module**: DMRModHooks v1.5.1  
**Goal**: Add offline speech-to-text transcription for DMR radio audio

---

## Current Problem Summary

We're trying to add transcription to an LSPosed hook module that captures DMR radio audio. We have PCM audio data ready (16kHz, 16-bit, mono) but **every ML framework we try fails due to native library loading issues in LSPosed**.

---

## What We've Tried (All Failed ❌)

### Attempt 1: Vosk (v1.5.0)
**Result**: ❌ FAILED  
**Error**: `UnsatisfiedLinkError: libjnidispatch.so` + `libvosk.so`  
**Root Cause**: JNA native libraries cannot load in LspModuleClassLoader

### Attempt 2: TensorFlow Lite + Whisper Tiny (v1.5.1)
**Result**: ❌ FAILED  
**Error**: `UnsatisfiedLinkError: libtensorflowlite_jni.so`  
**Root Cause**: JNI native libraries cannot load in LspModuleClassLoader

### Attempt 3: Sphinx4 (Following Your Advice)
**Your Recommendation**: "Option 1: Sphinx4 (Pure Java) - 100% pure Java, no .so files, perfect for DMR/radio with custom grammar"

**Our Actions**:
1. ✅ Rewrote all code for Sphinx4 (imports, methods, logic)
2. ❌ Build failed: Maven artifacts not in repositories
3. ❌ Attempted manual JAR downloads (404 errors, corrupted ZIPs)
4. ✅ Cloned Sphinx4 source from GitHub
5. ❌ Build failed: Uses desktop Java APIs (javax.sound.sampled, javax.xml.bind)

**Critical Discovery**: 
- Sphinx4 uses `javax.sound.sampled.AudioInputStream` and `AudioFormat`
- These APIs **don't exist on Android**
- Android uses `android.media.AudioRecord` instead
- Even if we built JARs, they wouldn't run on Android

**Result**: ❌ FAILED - Desktop Java only, NOT Android-compatible

### Attempt 4: PocketSphinx-Android (Investigation)
**What It Is**: Official Android port of CMU Sphinx

**Our Investigation**:
1. ✅ Cloned repository from GitHub
2. ✅ Examined build configuration (Gradle + CMake + SWIG)
3. ❌ Uses Android NDK to build native C libraries
4. ❌ Requires: libpocketsphinx.so, libsphinxbase.so, libpocketsphinx_jni.so
5. ❌ Uses SWIG to generate JNI bindings (Java → C)

**Result**: ❌ FAILED - Same native library problem as Vosk/TFLite

---

## Root Cause: LSPosed ClassLoader Barrier

**The Fundamental Problem**:
- LSPosed modules run in `LspModuleClassLoader` (isolated from app's ClassLoader)
- Native libraries (.so files) use `System.loadLibrary()` during static initialization
- This fails in LSPosed context → `UnsatisfiedLinkError`
- **ALL ML frameworks with native code fail** (Vosk, TFLite, PocketSphinx, etc.)

**Confirmed Incompatible**:
| Framework | Native Code | LSPosed Compatible |
|-----------|-------------|-------------------|
| Vosk | ✓ (JNA) | ❌ |
| TensorFlow Lite | ✓ (JNI) | ❌ |
| Sphinx4 | ❌ (Desktop Java APIs) | ❌ |
| PocketSphinx-Android | ✓ (JNI) | ❌ |

---

## Current Code State

**File**: `DMRModHooks/app/src/main/java/com/macdmr/hooks/MainHook.java`

**Status**: Contains Sphinx4 code that won't work on Android

**Problematic Code** (Lines 27-28):
```java
import javax.sound.sampled.AudioFormat;
import javax.sound.sampled.AudioInputStream;
// ❌ These classes don't exist on Android
```

**Lines 2998-3004**:
```java
AudioFormat audioFormat = new AudioFormat(16000f, 16, 1, true, false);
AudioInputStream ais = new AudioInputStream(bais, audioFormat, audioBuffer.size());
// ❌ Will crash: ClassNotFoundException
```

**What Works**:
- ✅ Audio capture: PCM data in `List<Short>` buffer (30 seconds max, 16kHz)
- ✅ UI: TXT button triggers transcription, cyan TextView displays result
- ✅ Database: `transcription TEXT` column ready
- ✅ Feature extraction: Could implement MFCC in pure Java if needed

**What Doesn't Work**:
- ❌ Any ML inference framework (all require native code)

---

## Viable Solutions (Need Your Guidance)

### Option 1: IPC Service App ⭐ (Our Recommendation)

**Architecture**:
```
DMRModHooks (LSPosed module)
    ↓ Binder/AIDL
DMRTranscriptionService (Separate app)
    - Uses TFLite/Vosk normally (no LSPosed restrictions)
    - Loads Whisper Tiny or Vosk model
    - Receives audio bytes via IPC
    - Returns transcription text
```

**Why This Will Work**:
- ✅ Service app runs outside LSPosed (native libs work normally)
- ✅ Uses proven ML frameworks (TFLite/Vosk) with full models
- ✅ Excellent accuracy, fully offline
- ✅ Standard Android IPC (Binder/AIDL)
- ✅ 4-6 hours to implement

**Implementation Plan**:
1. Create new Android app: "DMRTranscriptionService"
2. Implement background service with TFLite + Whisper Tiny model (39.73 MB, already have file)
3. Define AIDL interface:
   ```java
   interface ITranscriptionService {
       String transcribeAudio(in byte[] pcmData, int sampleRate);
   }
   ```
4. Service loads model on startup, processes audio on demand
5. Update DMRModHooks to bind to service and call via Binder
6. Test with real DMR audio

**Questions for You**:
1. **Is this the right approach?** Any better alternatives?
2. **TFLite vs Vosk for service app?** Which is more accurate/reliable?
3. **Audio buffer size concern**: 30 seconds of PCM = ~960KB. Is Binder okay for this, or should we use shared memory (ashmem)?
4. **User experience**: Installing 2 apps is acceptable?

---

### Option 2: Minimal RNN Inference Engine (Pure Java)

**Concept**: Write minimal pure Java neural network inference for ONE specific model (DeepSpeech/Whisper)

**What We'd Build**:
- Model loader (parse .tflite format, extract weights) ~300 lines
- Tensor operations (matmul, add, activation functions) ~200 lines
- LSTM layer implementation ~150 lines
- CTC decoder (beam search) ~200 lines
- MFCC feature extraction ~500 lines
- **Total**: ~1,500 lines of pure Java

**Pros**:
- ✅ Pure Java (works in LSPosed)
- ✅ Uses existing pre-trained models (DeepSpeech/Whisper Tiny)
- ✅ All-in-one solution (no separate app)
- ✅ Same model accuracy (if inference implemented correctly)

**Cons**:
- ⚠️ 1-2 weeks development time
- ⚠️ Only works for RNN-based models (not Transformers)
- ⚠️ Performance 10-50x slower than native C++
- ⚠️ Need to parse model format (FlatBuffers for TFLite)
- ⚠️ Risk of bugs in custom inference code

**Questions for You**:
1. **Is this worth the effort?** Or is IPC service cleaner?
2. **Model format**: Can we extract weights from .tflite files easily?
3. **Performance**: Is 10-50x slower acceptable for real-time-ish transcription?
4. **Whisper Tiny architecture**: Is it simple enough to port (RNN/LSTM based)?

---

### Option 3: Google Cloud Speech-to-Text API (Quick Test)

**Pros**:
- ✅ 1 hour implementation (~50 lines of code)
- ✅ Excellent accuracy
- ✅ Works immediately
- ✅ Free tier: 60 minutes/month

**Cons**:
- ❌ Requires internet connection
- ❌ Not truly offline
- ❌ Privacy concerns (audio sent to Google)

**Questions for You**:
1. **Should we implement this first** to test UI/workflow before building offline solution?
2. **Good for prototyping** while we build IPC service?

---

### Option 4: Command Recognition (Limited Vocabulary)

**Concept**: Pure Java pattern matching for ~50 pre-defined DMR commands

**Examples**:
```
"Channel 1", "Channel 2", ..., "Channel 16"
"PTT", "Push to talk"
"Roger", "Copy that", "Affirmative"
"Repeat", "Say again"
"Emergency", "Mayday"
```

**Approach**: MFCC + DTW (Dynamic Time Warping) or simple NN classifier

**Pros**:
- ✅ Pure Java, lightweight
- ✅ Perfect for DMR (limited vocabulary)
- ✅ 3-5 days to implement
- ✅ Good accuracy for predefined phrases

**Cons**:
- ⚠️ Only recognizes pre-defined commands
- ⚠️ Won't transcribe freeform speech
- ⚠️ Limited usefulness

**Questions for You**:
1. **Is this sufficient for DMR use case?** Maybe users only need command recognition?
2. **Hybrid approach**: Command recognition first, then add full STT later?

---

## Technical Details

### Audio Pipeline (Working ✅)
```java
// MainHook.java - Lines 1995-2020
private static void processAudioData(short[] audioData, int frameSize) {
    for (int i = 0; i < frameSize; i++) {
        audioBuffer.add(audioData[i]);
        
        // Keep only last 30 seconds (480,000 samples at 16kHz)
        if (audioBuffer.size() > MAX_AUDIO_BUFFER_SIZE) {
            audioBuffer.remove(0);
        }
    }
}

// Buffer: List<Short> with 16kHz, 16-bit PCM mono
// 30 seconds = 480,000 samples = 960,000 bytes
```

### UI Components (Working ✅)
- TXT button in DMR UI (Lines 706-742)
- Cyan TextView for transcription display (Lines 451-488)
- Shows "Transcribing..." during processing
- Updates with final text result

### Database (Working ✅)
- `transmissions` table has `transcription TEXT` column
- `updateTranscription(long txId, String text)` method ready (Lines 3092-3106)

---

## Questions for Grok

### Priority Questions:

1. **Best Approach**: Do you agree IPC Service App is the best path forward? Or would you recommend minimal RNN inference engine?

2. **IPC Technical Details**:
   - Should we use Binder/AIDL for ~960KB audio buffers, or shared memory (ashmem)?
   - TFLite or Vosk in the service app? Which is more accurate/reliable?
   - Any concerns about service lifecycle (background restrictions on Android 13)?

3. **Whisper Model**:
   - We have `whisper-tiny-en.tflite` (39.73 MB) ready
   - Is this a good choice for DMR radio transcription?
   - Better alternatives? (Vosk models, DeepSpeech?)

4. **Your Original Advice**:
   - You recommended Sphinx4 as "100% pure Java, no .so files"
   - Were you aware it uses desktop Java APIs (javax.sound.sampled)?
   - Did you mean CMU Sphinx in general, or specifically Sphinx4?

5. **Minimal Inference Engine**:
   - If we go this route, is Whisper Tiny portable to pure Java?
   - Or is it Transformer-based (too complex)?
   - Should we target DeepSpeech instead (simpler RNN architecture)?

6. **Command Recognition**:
   - Would this be sufficient for DMR use case?
   - Users might only need ~50 commands recognized, not full freeform speech?

7. **Hybrid Approach**:
   - Implement Google Cloud API first for testing (1 hour)
   - Then add IPC Service for offline use (4-6 hours)
   - Good development strategy?

---

## What We Need from You

### Immediate Decision:
1. **Which option should we implement?**
   - Option 1: IPC Service App (our recommendation)
   - Option 2: Minimal RNN inference engine
   - Option 3: Google Cloud API (quick test)
   - Option 4: Command recognition only

### Technical Guidance:
2. **If IPC Service**: TFLite vs Vosk? Binder vs shared memory?
3. **If minimal inference**: Which model architecture? DeepSpeech or Whisper?
4. **Model selection**: Best pre-trained model for DMR radio speech?

### Architecture Review:
5. **Any concerns** with our analysis or approach?
6. **Better alternatives** we haven't considered?
7. **LSPosed workarounds** we might have missed?

---

## Summary

**What Works**:
- ✅ Audio capture (16kHz PCM, 30s buffer)
- ✅ UI (TXT button, transcription display)
- ✅ Database (ready for transcription storage)

**What Blocks Us**:
- ❌ All native STT frameworks fail in LSPosed (ClassLoader isolation)
- ❌ Sphinx4 uses desktop Java APIs (not Android-compatible)
- ❌ PocketSphinx-Android uses JNI (same problem as Vosk/TFLite)

**Viable Path Forward**:
- ✅ **IPC Service App** (separate app, uses STT normally, communicates via Binder)
- ⚠️ Minimal RNN inference (pure Java, 1-2 weeks work)
- ⚠️ Google Cloud API (quick test, requires internet)
- ⚠️ Command recognition (limited to pre-defined phrases)

**Our Recommendation**: **IPC Service App** - proven approach, excellent accuracy, 4-6 hours implementation

---

**Ready for your guidance on next steps!**
