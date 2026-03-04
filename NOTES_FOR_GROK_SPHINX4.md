# Notes for Grok - Sphinx4 Implementation Status

**Date**: February 26, 2026  
**Module Version**: v1.5.1 (Sphinx4 code implemented, dependency unavailable)

---

## Current Situation

### Problem We're Solving
Implementing offline speech-to-text transcription in LSPosed module for DMR radio communications. Need to transcribe incoming audio (16kHz, 16-bit PCM mono) and display in UI.

### Critical Blocker: Native Library ClassLoader Barrier
**All ML frameworks with native code fail in LSPosed module context:**

❌ **Vosk (JNA)**: `UnsatisfiedLinkError: libjnidispatch.so`  
❌ **TensorFlow Lite (JNI)**: `UnsatisfiedLinkError: libtensorflowlite_jni.so`

**Root Cause**: LspModuleClassLoader isolation prevents native library (.so file) access during static initialization. Android's `System.loadLibrary()` fails because LSPosed modules run in a separate ClassLoader context.

---

## Grok's Recommended Solution: Sphinx4 (Pure Java)

### Why Sphinx4?
- ✅ **100% Pure Java** - No .so files, no JNI, no native code
- ✅ **Loads perfectly in LspModuleClassLoader** - No `UnsatisfiedLinkError` risk
- ✅ **Perfect for DMR/radio** - Optimized for command recognition with custom grammar
- ✅ **Lightweight** - Smaller footprint than Whisper/Vosk

### Implementation Status: CODE COMPLETE ✅

**All code changes successfully implemented:**

#### 1. Imports (Lines 24-31)
```java
import edu.cmu.sphinx.api.Configuration;
import edu.cmu.sphinx.api.StreamSpeechRecognizer;
import edu.cmu.sphinx.api.SpeechResult;
import javax.sound.sampled.AudioFormat;
import javax.sound.sampled.AudioInputStream;
```

#### 2. State Variables (Lines 115-123)
```java
private static StreamSpeechRecognizer sphinx4Recognizer = null;
private static Configuration sphinx4Config = null;
```

#### 3. Initialization Method (Lines 2828-2883)
```java
private static void initSphinx4(final Context context) {
    sphinx4Config = new Configuration();
    
    // Set paths to bundled models (will be in assets/)
    sphinx4Config.setAcousticModelPath("resource:/edu/cmu/sphinx/models/en-us/en-us");
    sphinx4Config.setDictionaryPath("resource:/edu/cmu/sphinx/models/en-us/cmudict-en-us.dict");
    sphinx4Config.setLanguageModelPath("resource:/edu/cmu/sphinx/models/en-us/en-us.lm.bin");
    
    // Match DMR audio format
    sphinx4Config.setSampleRate(16000);
    
    // Create recognizer
    sphinx4Recognizer = new StreamSpeechRecognizer(sphinx4Config);
    
    XposedBridge.log(TAG + ": ✅ Sphinx4 initialized (Pure Java - No native libs!)");
    showToast(context, "✅ Transcription ready! (Sphinx4)");
}
```

#### 4. Transcription Processing (Lines 2980-3068)
```java
private static void processTranscription(Context context) {
    if (sphinx4Recognizer == null) {
        XposedBridge.log(TAG + ": ❌ Sphinx4 not initialized");
        return;
    }
    
    // Convert List<Short> audioBuffer to byte array (16-bit PCM Little Endian)
    byte[] pcmBytes = new byte[audioBuffer.size() * 2];
    for (int i = 0; i < audioBuffer.size(); i++) {
        short sample = audioBuffer.get(i);
        pcmBytes[i * 2] = (byte) (sample & 0xFF);          // Low byte
        pcmBytes[i * 2 + 1] = (byte) ((sample >> 8) & 0xFF); // High byte
    }
    
    // Create AudioInputStream (16kHz, 16-bit, mono, signed, little-endian)
    ByteArrayInputStream bais = new ByteArrayInputStream(pcmBytes);
    AudioFormat audioFormat = new AudioFormat(
        16000f,  // Sample rate (Hz)
        16,      // Bits per sample
        1,       // Channels (mono)
        true,    // Signed
        false    // Little endian
    );
    AudioInputStream ais = new AudioInputStream(bais, audioFormat, audioBuffer.size());
    
    // Run Sphinx4 recognition
    sphinx4Recognizer.startRecognition(ais);
    StringBuilder transcription = new StringBuilder();
    SpeechResult result;
    
    while ((result = sphinx4Recognizer.getResult()) != null) {
        String hypothesis = result.getHypothesis();
        if (hypothesis != null && !hypothesis.trim().isEmpty()) {
            transcription.append(hypothesis).append(" ");
        }
    }
    
    sphinx4Recognizer.stopRecognition();
    
    currentTranscription = transcription.toString().trim();
    XposedBridge.log(TAG + ": Transcription result: " + currentTranscription);
    
    // Update UI
    updateTranscriptionDisplay(currentTranscription);
}
```

#### 5. UI Integration
- TXT button click handler calls `initSphinx4()` (Lines 706-742)
- Transcription displays in cyan TextView below buttons
- Saves to database with `updateTranscription()` method

#### 6. Cleanup
- ✅ Removed all TFLite code (Interpreter, ByteBuffer, loadModelFromAssets, etc.)
- ✅ Removed Vosk references
- ✅ Code is clean and ready for Sphinx4

---

## Current Blocker: Sphinx4 Dependency Unavailable

### Build Configuration Attempted

**build.gradle (Lines 41-48)**:
```gradle
dependencies {
    compileOnly 'de.robv.android.xposed:api:82'
    
    // Attempted versions:
    implementation 'edu.cmu.sphinx:sphinx4-core:5prealpha-SNAPSHOT'
    implementation 'edu.cmu.sphinx:sphinx4-data:5prealpha-SNAPSHOT'
    
    // Also tried:
    implementation 'edu.cmu.sphinx:sphinx4-core:1.0-SNAPSHOT'
    implementation 'edu.cmu.sphinx:sphinx4-data:1.0-SNAPSHOT'
}
```

**settings.gradle**:
```gradle
repositories {
    google()
    mavenCentral()
    maven { url 'https://jitpack.io/' }
    maven { url 'https://api.xposed.info/' }
    maven { url 'https://oss.sonatype.org/content/repositories/snapshots/' }
}
```

### Build Failures

#### Attempt 1: Maven with 5prealpha-SNAPSHOT
```
FAILURE: Build failed with an exception.

* What went wrong:
Could not determine the dependencies of task ':app:compileDebugJavaWithJavac'.
> Could not resolve all task dependencies for configuration ':app:debugCompileClasspath'.
   > Could not find edu.cmu.sphinx:sphinx4-core:5prealpha-SNAPSHOT.
     Searched in the following locations:
       - https://dl.google.com/android/maven2/...
       - https://repo.maven.apache.org/maven2/...
       - https://jitpack.io/...
       - https://oss.sonatype.org/content/repositories/snapshots/...
     Required by:
         project :app
```

#### Attempt 2: Maven with 1.0-SNAPSHOT
Same error - artifact not found in any repository.

#### Attempt 3: Manual JAR Download from Maven Central
```powershell
Invoke-WebRequest -Uri "https://repo1.maven.org/maven2/edu/cmu/sphinx/sphinx4-core/5prealpha/sphinx4-core-5prealpha.jar" -OutFile "sphinx4-core.jar"

Result: The remote server returned an error: (404) Not Found.
```

#### Attempt 4: Download from SourceForge
```powershell
Invoke-WebRequest -Uri "https://sourceforge.net/projects/cmusphinx/files/sphinx4/1.0%20beta6/sphinx4-1.0beta6-bin.zip" -OutFile "sphinx4.zip"

Downloaded but extraction failed:
Exception: End of Central Directory record could not be found.
ZIP file corrupted or incomplete.
```

#### Attempt 5: GitHub Releases
- Checked: https://github.com/cmusphinx/sphinx4/releases
- Result: No pre-built JAR files available
- Only source code releases

---

## User's Suggestion: Build Sphinx4 from Source

**⭐ GREAT IDEA!** Since Sphinx4 source code is available on GitHub, we can:

1. **Clone the repository**:
   ```bash
   git clone https://github.com/cmusphinx/sphinx4.git
   ```

2. **Build JARs ourselves** using Maven or Gradle:
   ```bash
   cd sphinx4
   mvn clean package
   # or
   ./gradlew build
   ```

3. **Copy resulting JARs to `app/libs/`**:
   - `sphinx4-core-<version>.jar`
   - `sphinx4-data-<version>.jar`

4. **Update build.gradle to use local JARs**:
   ```gradle
   dependencies {
       implementation fileTree(dir: 'libs', include: ['*.jar'])
       compileOnly 'de.robv.android.xposed:api:82'
   }
   ```

### Questions for Grok:

1. **Is the Sphinx4 GitHub repo buildable?** (Last updated 2016, might have dependency issues)
2. **What build tool does it use?** Maven? Gradle? Ant?
3. **Are there any build instructions** in the repo README?
4. **Will the built JARs work on Android?** (Desktop Java vs Android compatibility)
5. **Do we need bundled language models?** Where do those come from?

---

## Alternative Solutions (If Sphinx4 Build Fails)

### Option 2: Google Cloud Speech-to-Text API
- ✅ No native libraries (pure HTTP/REST)
- ✅ Very accurate (Google's production STT)
- ✅ Free tier: 60 minutes/month
- ✅ ~10 lines of code to implement
- ❌ Requires internet connection
- ❌ Requires API key setup

### Option 3: IPC Service App
- ✅ Separate app uses TFLite normally (no LSPosed restrictions)
- ✅ DMRModHooks sends PCM via Binder/AIDL
- ✅ Best offline accuracy (Whisper Tiny model ready)
- ✅ No ClassLoader issues
- ❌ More complex (2 apps needed)
- ❌ User must install both apps

---

## Technical Context

### Audio Pipeline (Working ✅)
- **Format**: 16kHz, 16-bit PCM, mono, little-endian
- **Buffer**: `List<Short>` capturing last 30 seconds
- **Source**: DMR radio RX audio (hooked in `MainActivity.sendAudioData`)
- **UI**: TXT button triggers recognition, cyan TextView displays result

### Module Environment
- **Platform**: Android 13, LSPosed framework
- **Device**: Ulefone Armor 26 Ultra
- **Build**: Gradle 8.1.0, AGP 8.1.0, Java 8, compileSdk 34
- **Target App**: MacDMR (com.evawueng.macdmr)

### Files Ready
- ✅ Code: `DMRModHooks/app/src/main/java/com/macdmr/hooks/MainHook.java`
- ✅ UI: TXT button, cyan transcription display
- ✅ Database: `transcription TEXT` column in transmissions table
- ✅ Audio: PCM buffering working, data available for processing
- ⏳ Model: Need Sphinx4 JARs + language model files

---

## Build from Source Attempt Result ❌

### What We Tried:

1. ✅ **Cloned repository**: https://github.com/cmusphinx/sphinx4
2. ✅ **Identified build system**: Gradle
3. ✅ **Fixed deprecated plugins**: Removed maven plugin, updated syntax
4. ✅ **Fixed Java version**: Updated from Java 7 to Java 8
5. ❌ **Build failed**: Desktop Java dependencies incompatible with Android

### Build Output Analysis:

```
> Task :sphinx4-core:compileJava FAILED
C:\...\sphinx4-core\src\main\java\edu\cmu\sphinx\fst\sequitur\SequiturImport.java:24: 
error: package javax.xml.bind does not exist
import javax.xml.bind.JAXBContext;
```

**Critical Compilation Errors**:
- Missing `javax.xml.bind.*` (JAXB - Java XML Binding)
- Missing desktop Java classes not available on Android

---

## ❌ CRITICAL DISCOVERY: Sphinx4 is NOT Android-Compatible

### Desktop Java APIs Used by Sphinx4:

**🚫 Problem 1: javax.sound.sampled (Desktop Audio)**
```java
import javax.sound.sampled.AudioFormat;
import javax.sound.sampled.AudioInputStream;
```
- ❌ **Does NOT exist on Android**
- ✅ Android uses: `AudioRecord`, `AudioTrack`, `AudioFormat` (android.media.*)

**🚫 Problem 2: javax.xml.bind (JAXB)**
```java
import javax.xml.bind.JAXBContext;
import javax.xml.bind.Unmarshaller;
```
- ❌ **Not available on Android**
- ❌ Removed from JDK 11+ (requires separate dependency)
- ❌ Android doesn't include JAXB

**🚫 Problem 3: Our Code Won't Work Either**

The code we wrote in MainHook.java also uses desktop APIs:
```java
// Lines 27-28 in our MainHook.java
import javax.sound.sampled.AudioFormat;
import javax.sound.sampled.AudioInputStream;

// Lines 2998-3004 - This will fail on Android!
AudioFormat audioFormat = new AudioFormat(16000f, 16, 1, true, false);
AudioInputStream ais = new AudioInputStream(bais, audioFormat, audioBuffer.size());
```

### Why This Happens:
- **Sphinx4 was designed for desktop Java applications**
- Never intended for Android/mobile use
- Uses Java SE (Standard Edition) APIs
- Android uses Java-like language but different core libraries

### Android vs Desktop Java Audio:

| Desktop Java (Sphinx4) | Android |
|------------------------|---------|
| `javax.sound.sampled.AudioFormat` | `android.media.AudioFormat` |
| `javax.sound.sampled.AudioInputStream` | `byte[]` or `ByteBuffer` |
| `javax.sound.sampled.AudioRecord` | `android.media.AudioRecord` |

---

## Why Grok's Recommendation Was Incorrect

**Grok said**: "Sphinx4 is 100% pure Java → loads perfectly in LspModuleClassLoader"

**Reality**: 
- ✅ Correct: Sphinx4 has no native `.so` files
- ❌ Wrong: "Pure Java" doesn't mean "Android-compatible"
- ❌ Wrong: Desktop Java APIs (javax.sound.sampled) don't exist on Android
- ❌ Wrong: Would need massive refactoring to work on Android

---

## Next Steps

**⚠️ Sphinx4 Approach is BLOCKED - Cannot work on Android without major rewrites**

### MUST Choose Alternative Solution:

### Option 2: Google Cloud Speech-to-Text API ⭐ RECOMMENDED
- ✅ No native libraries (pure HTTP/REST)
- ✅ Uses standard Java/Android networking (HttpURLConnection)
- ✅ Very accurate (Google's production STT)
- ✅ Free tier: 60 minutes/month
- ✅ ~10 lines of code to implement
- ✅ Can implement immediately
- ❌ Requires internet connection
- ❌ Requires API key setup (5 minutes)

**Implementation**:
```java
// Pure Android-compatible code
byte[] pcmBytes = convertPCMToBytes(audioBuffer);
String base64Audio = Base64.encodeToString(pcmBytes, Base64.DEFAULT);

JSONObject request = new JSONObject()
    .put("audio", new JSONObject().put("content", base64Audio))
    .put("config", new JSONObject()
        .put("encoding", "LINEAR16")
        .put("sampleRateHertz", 16000)
        .put("languageCode", "en-US"));

HttpURLConnection conn = (HttpURLConnection) new URL(
    "https://speech.googleapis.com/v1/speech:recognize?key=" + API_KEY
).openConnection();
// Send request, parse JSON response
```

### Option 3: IPC Service App (Best Offline)
- ✅ Separate app uses TFLite/Vosk normally (no LSPosed restrictions)
- ✅ DMRModHooks sends PCM via Binder/AIDL
- ✅ Best offline accuracy
- ✅ Android-native APIs only
- ❌ More complex (2 apps needed)
- ❌ User must install both apps
- ⏱️ Takes 2-3 hours to implement

---

## Option 4: Port Existing Open-Source STT to Pure Java 🔄

### Overview
Take an existing STT project (Vosk, TensorFlow Lite, DeepSpeech) and port the inference code to pure Java, keeping their pre-trained models. This would bypass the native library issue while leveraging existing models.

### Candidate Projects Analysis

#### A. Vosk (Failed in v1.5.0 due to JNA native libs)

**What Vosk Does**:
- Wrapper around Kaldi (C++ speech recognition toolkit)
- Pre-trained models available (50MB-1.5GB)
- Excellent accuracy
- Failed: `UnsatisfiedLinkError: libjnidispatch.so` + `libvosk.so`

**What Would Be Required to Port**:
```
Vosk Java API (thin wrapper)
    ↓ JNA calls
libvosk.so (C++ library ~5MB)
    ↓ Uses
Kaldi (massive C++ toolkit)
    - Neural network inference
    - Feature extraction (MFCC, etc.)
    - WFST decoder (Weighted Finite State Transducers)
    - Matrix operations (BLAS, LAPACK)
    - HMM-based acoustic models
```

**Porting Complexity**:
- **Lines of Code**: Kaldi is ~500,000+ lines of C++
- **Dependencies**: Requires OpenBLAS, ATLAS (linear algebra)
- **Algorithms**: WFST decoders (complex graph algorithms)
- **Time Estimate**: 6-12 months of full-time work
- **Feasibility**: ❌ **Completely impractical** - too massive

**Model Compatibility**:
- ✅ Models are in Kaldi format (text-based, parseable)
- ⚠️ But need Kaldi inference engine to use them
- ❌ Can't use models without porting inference engine

---

#### B. TensorFlow Lite (Failed in v1.5.1 due to JNI native libs)

**What TFLite Does**:
- Lightweight ML inference engine for mobile
- Supports Whisper, DeepSpeech, custom models
- Pre-trained models available (40MB-500MB)
- Failed: `UnsatisfiedLinkError: libtensorflowlite_jni.so`

**What Would Be Required to Port**:
```
TFLite Java API (thin wrapper)
    ↓ JNI calls
libtensorflowlite_jni.so (C++ library ~2MB)
    ↓ Implements
TensorFlow Lite Interpreter
    - Neural network graph execution
    - 100+ operators (Conv2D, LSTM, Attention, etc.)
    - Quantization support (INT8, FP16)
    - SIMD optimizations (ARM NEON, SSE)
    - Memory pool management
```

**Porting Complexity**:
- **Lines of Code**: ~100,000+ lines of optimized C++
- **Operators**: Need to implement 100+ neural network operations
- **Optimizations**: Pure Java would be 10-50x slower than C++
- **Time Estimate**: 4-8 months of full-time work
- **Feasibility**: ❌ **Impractical** - too complex, performance would suffer

**Model Compatibility**:
- ✅ TFLite models are in FlatBuffers format (well-documented)
- ✅ Could potentially write minimal interpreter for specific models
- ⚠️ But need to implement all operators the model uses

**Interesting Alternative**: Pure Java NN Inference Libraries
- **DL4J (DeepLearning4J)**: Full Java ML framework
  - ✅ Pure Java (no native code requirement)
  - ✅ Runs on Android
  - ❌ Large library (~50MB+)
  - ⚠️ Would need to convert TFLite models → DL4J format
  
- **DeepJavaLibrary (DJL)**: Amazon's Java ML library
  - ✅ Pure Java option available
  - ❌ Still has native backends for performance
  - ⚠️ Model conversion needed

---

#### C. PocketSphinx (CMU Sphinx for Mobile) ❌ INVESTIGATED

**What PocketSphinx Is**:
- Android version of CMU Sphinx
- Designed for mobile devices
- Pre-trained models available (10-50MB)
- ✅ **Has official Android port!**

**Investigation Results** (February 26, 2026):
- ❌ **Uses Android NDK** (Native Development Kit)
- ❌ **Requires C libraries**: sphinxbase + pocketsphinx
- ❌ **Uses SWIG** to generate JNI bindings (Java → C)
- ❌ **Builds native .so libraries**:
  - libpocketsphinx_jni.so
  - libsphinxbase.so
  - libpocketsphinx.so

**Architecture**:
```
PocketSphinx-Android Java API
    ↓ JNI (via SWIG-generated wrappers)
Native C Libraries (.so files)
    - libpocketsphinx.so (speech recognition engine)
    - libsphinxbase.so (feature extraction, utilities)
    - Uses System.loadLibrary() on startup
```

**CMakeLists.txt compiles C code**:
- fe/ (feature extraction - FFT, MFCC)
- feat/ (feature processing - CMN, AGC)
- lm/ (language models - FSG, JSGF, N-gram)
- util/ (utilities, BLAS, memory management)

**Why It Fails in LSPosed**:
- ❌ System.loadLibrary() called during initialization
- ❌ LspModuleClassLoader cannot load native .so files
- ❌ Same `UnsatisfiedLinkError` as Vosk and TFLite
- ❌ **PocketSphinx = Vosk = TFLite = Native JNI = LSPosed incompatible**

**Conclusion**: 
- ✅ Would work in normal Android app
- ❌ **Will NOT work in LSPosed module**
- Same native library barrier as all other attempts

**Repository**: https://github.com/cmusphinx/pocketsphinx-android  
**Build System**: Gradle + CMake + SWIG  
**Status**: Active, well-maintained  
**LSPosed Compatible**: ❌ NO

---

#### D. Mozilla DeepSpeech

**What DeepSpeech Is**:
- Open-source STT by Mozilla (now archived)
- Pre-trained models available (40-180MB)
- TensorFlow-based
- Failed in our TFLite attempt (native libs)

**Model Format**:
- Uses **.tflite** or **.pb** (TensorFlow formats)
- Same problem as TFLite - need inference engine

**Porting Approach**:
- Could write minimal inference engine just for DeepSpeech model architecture
- DeepSpeech uses: RNN + CTC decoder
- Simpler than general TFLite (only need ~10 operators)

**Feasibility**:
- **Lines of Code**: ~3,000-5,000 lines for minimal RNN inference
- **Time Estimate**: 2-3 weeks
- **Accuracy**: Should match original (same model weights)
- **Feasibility**: ⚠️ **Possible but significant effort**

---

### Minimal Inference Engine Approach 🎯

**Best Compromise**: Write minimal pure Java inference engine for ONE specific model

#### Strategy:
1. Choose a model architecture (e.g., DeepSpeech RNN)
2. Implement ONLY the operators that model uses
3. Load pre-trained weights from disk
4. Don't try to be general-purpose (not a full TFLite replacement)

#### Required Components:

```java
// 1. Model loader (read weights from file)
class ModelLoader {
    public Model loadDeepSpeechModel(String path) {
        // Parse .tflite or custom format
        // Extract layer definitions + weights
        // ~300 lines
    }
}

// 2. Basic tensor operations
class Tensor {
    float[] data;
    int[] shape;
    
    public Tensor matmul(Tensor other) { /* ~50 lines */ }
    public Tensor add(Tensor other) { /* ~20 lines */ }
    public void relu() { /* ~10 lines */ }
    public void softmax() { /* ~30 lines */ }
}

// 3. RNN/LSTM layer
class LSTMLayer {
    Tensor W_input, W_hidden, W_forget, W_output;
    Tensor bias_input, bias_hidden, bias_forget, bias_output;
    
    public Tensor forward(Tensor input, Tensor h_prev, Tensor c_prev) {
        // Standard LSTM equations
        // ~100 lines
    }
}

// 4. CTC decoder (Connectionist Temporal Classification)
class CTCDecoder {
    public String decode(float[][] probabilities) {
        // Beam search or greedy decoding
        // Collapse repeated characters, remove blanks
        // ~200 lines
    }
}

// 5. Main inference engine
class DeepSpeechInference {
    LSTMLayer[] layers;
    Model model;
    
    public String transcribe(float[][] mfccFeatures) {
        // 1. Forward pass through RNN layers
        Tensor x = new Tensor(mfccFeatures);
        for (LSTMLayer layer : layers) {
            x = layer.forward(x, h_prev, c_prev);
        }
        
        // 2. Output layer (phoneme/character probabilities)
        Tensor logits = outputLayer.forward(x);
        
        // 3. CTC decode
        return ctcDecoder.decode(logits.data);
    }
}
```

**Implementation Estimate**:
- **Model loader**: ~300 lines (parse format, extract weights)
- **Tensor operations**: ~200 lines (matmul, add, activation functions)
- **LSTM layer**: ~150 lines (LSTM forward pass)
- **CTC decoder**: ~200 lines (beam search)
- **Feature extraction**: ~500 lines (MFCC, if not already done)
- **Integration**: ~150 lines

**Total**: ~1,500 lines of pure Java

**Time Estimate**: 1-2 weeks

**Benefits**:
- ✅ Pure Java (no native code)
- ✅ Uses existing pre-trained models (DeepSpeech, Whisper Tiny)
- ✅ Good accuracy (same model, same weights)
- ✅ Smaller scope than full TFLite port
- ✅ Will work in LSPosed module

**Drawbacks**:
- ⚠️ Only works for RNN-based models (not Transformers)
- ⚠️ Performance slower than native C++ (but still usable)
- ⚠️ Model size still 40-180MB
- ⚠️ Need to understand model format to extract weights

---

### Comparison: All Options

| Approach | Dev Time | Code Lines | Feasibility | Uses Existing Models |
|----------|----------|------------|-------------|---------------------|
| **Port Vosk** | 6-12 months | 500,000+ | ❌ Impossible | ✅ Yes |
| **Port TFLite (full)** | 4-8 months | 100,000+ | ❌ Impractical | ✅ Yes |
| **Minimal RNN Inference** | 1-2 weeks | ~1,500 | ⚠️ Challenging | ✅ Yes |
| **Try PocketSphinx** | 2 hours | 0 (just test) | ❓ Unknown | ✅ Yes |
| **Custom STT (scratch)** | 2-3 weeks | ~2,400 | ⚠️ Challenging | ❌ Need training |
| **Google Cloud API** | 1 hour | ~50 | ✅ Easy | N/A (cloud) |
| **IPC Service App** | 4-6 hours | ~500 | ✅ Easy | ✅ Yes |

---

## Recommended Path Forward (Updated After PocketSphinx Investigation)

### ❌ Option 1: PocketSphinx-Android - INVESTIGATED & RULED OUT
**Time**: 1-2 hours investigation ✅ **COMPLETE**
- ❌ Uses JNI and native C libraries (.so files)
- ❌ Will fail in LSPosed with `UnsatisfiedLinkError`
- ❌ Same barrier as Vosk, TFLite, and all other native ML frameworks
- **Conclusion**: Not viable, same problem as all other attempts

---

### 🎯 NEW Option 1: IPC Service App ⭐ **BEST RECOMMENDATION**
**Time**: 4-6 hours implementation  
**Pros**:
- ✅ Uses Vosk/TFLite in separate app (no LSPosed restrictions)
- ✅ Pre-trained models work as-is
- ✅ Excellent accuracy, fully offline
- ✅ Battle-tested frameworks, no porting needed
- ✅ Proven architecture (service apps work outside LSPosed)

**Cons**:
- ⚠️ User must install 2 apps
- ⚠️ IPC overhead (Binder/AIDL)

---

### 🎯 Option 2: Minimal RNN Inference Engine (INTERESTING BUT RISKY)
**Time**: 1-2 weeks implementation
- Pure Java, works in LSPosed
- Uses existing pre-trained models
- ~1,500 lines of code
- Performance slower than native C++

---

### 🎯 Option 3: Google Cloud API (FASTEST FOR TESTING)
**Time**: 1 hour
- Trivial implementation
- Requires internet
- Good for prototyping

---

### 🎯 Option 4: Command Recognition (SPECIALIZED)
**Time**: 3-5 days
- Pure Java template matching
- ~50 DMR commands only
- Limited to pre-defined phrases

---

## Option 5: Build Our Own Speech-to-Text Engine 🔧

### Overview
Write a custom, lightweight STT engine from scratch using Android-compatible Java/pure math. No native libraries, no external ML frameworks.

### What It Would Take

#### 1. Audio Preprocessing (Easy - Already Have!)
**Status**: ✅ Already implemented
- We have: 16kHz, 16-bit PCM mono audio in `List<Short>` buffer
- Already capturing real-time DMR audio
- No additional work needed

#### 2. Feature Extraction (Moderate Complexity)
**Task**: Convert raw audio PCM to ML-friendly features (MFCC, spectrograms, mel-filterbanks)

**Required Components**:
```java
// A. Pre-emphasis filter (reduce high-frequency noise)
public static short[] preEmphasis(short[] signal, float alpha) {
    short[] emphasized = new short[signal.length];
    emphasized[0] = signal[0];
    for (int i = 1; i < signal.length; i++) {
        emphasized[i] = (short)(signal[i] - alpha * signal[i-1]);
    }
    return emphasized;
}

// B. Windowing (Hamming/Hann window)
public static float[] hammingWindow(int N) {
    float[] window = new float[N];
    for (int n = 0; n < N; n++) {
        window[n] = (float)(0.54 - 0.46 * Math.cos(2 * Math.PI * n / (N - 1)));
    }
    return window;
}

// C. FFT (Fast Fourier Transform)
// Pure Java implementation - ~200 lines
// Converts time-domain audio → frequency-domain spectrum
// Libraries: None needed, implement Cooley-Tukey algorithm

// D. Mel-Filterbank (audio → perceptually-scaled features)
public static float[][] melFilterbank(int numFilters, int fftSize, int sampleRate) {
    // Create 40 triangular filters on mel scale
    // Maps Hz → mel: mel = 2595 * log10(1 + hz/700)
    // ~100 lines of pure math
}

// E. MFCC (Mel-Frequency Cepstral Coefficients)
public static float[][] extractMFCC(short[] audio, int frameSize, int hopSize) {
    // 1. Pre-emphasis
    // 2. Framing + windowing (25ms frames, 10ms hop)
    // 3. FFT per frame
    // 4. Mel filterbank
    // 5. Log + DCT (Discrete Cosine Transform)
    // Result: 13-40 coefficients per frame
    // ~300 lines total
}
```

**Complexity**: 
- Pure math (no ML yet)
- ~500-800 lines of Java code
- No external dependencies
- Time to implement: 2-4 days
- Android-compatible (just Math.* functions)

#### 3. Acoustic Model (HARD - The ML Part)
**Task**: Map audio features → phonemes/characters

**The Big Problem**: This requires a trained neural network

**Pure Java Options**:

##### Option A: Tiny Neural Network (Manual Implementation)
```java
// Implement basic feedforward neural network from scratch
class SimpleNN {
    private float[][] weights1;  // Input → Hidden layer
    private float[][] weights2;  // Hidden → Output layer
    
    // Forward pass
    public float[] predict(float[] mfccFrame) {
        // 1. Input (13 MFCCs) → Hidden (128 neurons)
        float[] hidden = matrixMultiply(mfccFrame, weights1);
        relu(hidden);  // Activation function
        
        // 2. Hidden → Output (phoneme probabilities)
        float[] output = matrixMultiply(hidden, weights2);
        softmax(output);
        
        return output;  // Phoneme probabilities
    }
}
```

**Requirements**:
- ✅ Pure Java (no native code)
- ✅ Android-compatible
- ❌ Need pre-trained weights (multi-GB files)
- ❌ Very poor accuracy without proper training
- ❌ Training requires: GPU cluster, 100+ hours compute, massive dataset
- Complexity: ~1000 lines for inference only

##### Option B: Hidden Markov Models (Old-School STT)
```java
// Pre-neural-network approach (used by early Sphinx)
class HMM_STT {
    // Pronunciation dictionary
    Map<String, String[]> lexicon;  // "hello" → ["HH", "EH", "L", "OW"]
    
    // Acoustic model (Gaussian Mixture Models per phoneme)
    Map<String, GMM> phoneModels;
    
    // Language model (bigram/trigram probabilities)
    Map<String, Map<String, Float>> languageModel;
    
    // Viterbi decoder (find best word sequence)
    public String decode(float[][] mfccFrames) {
        // Dynamic programming to find most likely path
        // ~500 lines of code
    }
}
```

**Requirements**:
- ✅ Pure Java/math (no neural networks)
- ✅ Android-compatible
- ❌ Still needs pre-trained GMM parameters (100+ MB)
- ❌ Worse accuracy than modern neural approaches
- ❌ Complex decoder logic
- Complexity: ~2000-3000 lines

#### 4. Language Model / Decoder (Moderate-Hard)
**Task**: Convert phoneme probabilities → actual words

**Required Components**:
```java
// A. Pronunciation Dictionary (Lexicon)
class Lexicon {
    Map<String, String[]> pronunciations = new HashMap<>();
    // "RADIO" → ["R", "EY", "D", "IY", "OW"]
    // "CHANNEL" → ["CH", "AE", "N", "AH", "L"]
    // Need ~10,000 words for basic DMR vocabulary
}

// B. Beam Search Decoder
class BeamSearchDecoder {
    public String decode(float[][] phonemeProbabilities, Lexicon lexicon) {
        // Keep top-K hypotheses at each time step
        // Prune low-probability paths
        // ~300 lines of code
    }
}

// C. Language Model (Optional but helpful)
class LanguageModel {
    // Bigram probabilities: P("channel" | "on")
    // Helps disambiguate "won" vs "one", etc.
    // Can train from DMR conversation corpus
}
```

**Complexity**: ~500-1000 lines

#### 5. Post-Processing (Easy)
```java
// Capitalization, punctuation, number formatting
public String postProcess(String rawText) {
    // "channel one two three" → "Channel 123"
    // ~100 lines of regex/string manipulation
}
```

---

### Full Implementation Estimate

#### Code Breakdown:
1. **Audio preprocessing**: ✅ Already done (0 lines)
2. **Feature extraction** (MFCC): ~500-800 lines
3. **Acoustic model** (Simple NN): ~1000 lines
4. **Decoder** (Beam search): ~500 lines
5. **Post-processing**: ~100 lines

**Total**: ~2,000-2,400 lines of pure Java code

#### Time Estimate:
- **Feature extraction**: 3-5 days (MFCC, FFT, mel-filterbank)
- **Neural network inference**: 2-3 days (basic feedforward)
- **Decoder**: 2-4 days (beam search, lexicon handling)
- **Integration & testing**: 2-3 days
- **Training/obtaining model weights**: ⚠️ **UNKNOWN - Massive blocker**

**Realistic Total**: 2-3 weeks of development time

#### The Killer Problem: Pre-Trained Weights

**Options for Getting Trained Model**:
1. **Train from scratch**: 
   - ❌ Requires: GPU cluster ($1000s), speech dataset (100+ GB), ML expertise
   - ❌ Time: Weeks to months
   - ❌ Way beyond scope

2. **Use existing weights**:
   - ✅ DeepSpeech models (Mozilla - open source)
   - ✅ Wav2Vec2 / Whisper weights (Facebook/OpenAI)
   - ❌ Problem: These are for TensorFlow/PyTorch, not pure Java
   - ❌ Would need to convert weights to Java-readable format
   - ⚠️ Models are 50MB-500MB+ (feasible to bundle)

3. **Simplified approach**:
   - Train tiny model on just DMR commands ("channel 1", "PTT", "roger")
   - Dataset: 50-100 audio samples per command
   - ✅ Could train on laptop CPU in hours
   - ❌ Would only recognize ~50 pre-defined commands
   - Limited usefulness for freeform speech

---

### Feasibility Assessment

#### ✅ Technically Possible:
- Pure Java STT is theoretically feasible
- No native code needed
- Would run in LSPosed module
- All components can be implemented in Java

#### ❌ Practical Blockers:
1. **Training data**: Need large labeled speech corpus
2. **Compute resources**: Training requires significant GPU time
3. **ML expertise**: Acoustic models are complex to train properly
4. **Model size**: Pre-trained weights are 50MB-500MB+
5. **Accuracy**: Custom implementation unlikely to match production systems
6. **Development time**: 2-3 weeks minimum, likely longer

#### 💡 Verdict:
**Not recommended unless**:
- You have ML/DSP expertise
- You have access to pre-trained weights in portable format
- You're willing to accept 2-3 weeks development time
- You're okay with limited vocabulary (command recognition only)

---

### Comparison: Custom STT vs Alternatives

| Approach | Development Time | Accuracy | Offline | Complexity |
|----------|-----------------|----------|---------|------------|
| **Custom STT (Pure Java)** | 2-3 weeks | Poor-Fair | ✅ Yes | Very High |
| **Google Cloud API** | 1 hour | Excellent | ❌ No | Very Low |
| **IPC Service App** | 4-6 hours | Excellent | ✅ Yes | Low |
| **Command Recognition** | 3-5 days | Good* | ✅ Yes | Medium |

*Good accuracy but limited to ~50 pre-defined commands

---

### Recommended Path Forward

**🎯 Best Option**: IPC Service App (Option 3)
- Uses TFLite/Vosk in separate app (no LSPosed restrictions)
- Excellent accuracy with pre-trained models
- Fully offline
- 4-6 hours implementation time
- Battle-tested ML frameworks

**🎯 Quick Option**: Google Cloud API (Option 2)
- 1 hour implementation
- Excellent accuracy
- Works immediately (requires internet)

**❌ Not Recommended**: Custom pure Java STT
- Too much development time
- Training data problem unsolved
- Likely poor accuracy
- Reinventing the wheel

---

## Revised Questions for Grok

1. ~~**Were you aware Sphinx4 uses desktop Java APIs?**~~ ✅ ANSWERED: Yes, javax.sound.sampled not on Android
2. ~~**Is there an Android port of CMU Sphinx?**~~ ✅ ANSWERED: PocketSphinx-Android exists but uses JNI (won't work)
3. **Do you agree IPC Service App is the best path forward for offline STT?**
4. **For IPC Service, should we use Vosk or TFLite + Whisper?**
5. **Any concerns about Binder/AIDL for passing 30 seconds of PCM audio (~940KB)?**
6. **Would shared memory (ashmem) be better than Binder for large audio buffers?**
7. **Should we implement quick Google Cloud API first for testing, then add IPC service for offline?**

---

## Final Summary (Updated February 26, 2026)

### What We Learned

**❌ All Native STT Frameworks Fail in LSPosed**:
| Framework | Issue | Root Cause |
|-----------|-------|------------|
| Vosk | `UnsatisfiedLinkError: libjnidispatch.so` | JNA native libs |
| TensorFlow Lite | `UnsatisfiedLinkError: libtensorflowlite_jni.so` | JNI native libs |
| Sphinx4 | Desktop Java APIs (javax.sound.sampled) | Not Android-compatible |
| PocketSphinx-Android | JNI + native C libraries | Same as Vosk/TFLite |

**Root Problem**: LspModuleClassLoader isolation prevents native library loading during static initialization.

**✅ Viable Solutions**:
1. **IPC Service App** (BEST) - Use STT in separate app, communicate via Binder/AIDL
2. **Minimal RNN Inference** (INTERESTING) - Write custom pure Java inference (~1,500 lines, 1-2 weeks)
3. **Google Cloud API** (FAST) - Cloud-based, requires internet
4. **Command Recognition** (LIMITED) - Template matching for ~50 DMR commands

### Investigation Log

| Date | Action | Result |
|------|--------|--------|
| Feb 26, 2026 | Attempted Sphinx4 Maven dependencies | ❌ Not in repositories |
| Feb 26, 2026 | Built Sphinx4 from source | ❌ Desktop Java APIs incompatible |
| Feb 26, 2026 | Investigated PocketSphinx-Android | ❌ Uses JNI, same problem |

### Recommendation

**Implement IPC Service App** ⭐  
- 4-6 hours development time  
- Uses proven ML frameworks (Vosk/TFLite)  
- Excellent accuracy, fully offline  
- No experimental porting required  

**Next Steps**:
1. Create DMRTranscriptionService project
2. Implement background service with TFLite + Whisper Tiny
3. Define AIDL interface (audio bytes → text string)
4. Update DMRModHooks to bind and call service
5. Test with real DMR audio

---

## Summary

❌ **Sphinx4 is NOT Android-compatible** (Desktop Java APIs)  
❌ **Cannot run on Android** without massive refactoring  
❌ **Our MainHook.java code also won't work** (uses javax.sound.sampled)  
💡 **Custom pure Java STT is technically possible but impractical** (2-3 weeks, training data problem)  
⚠️ **Must pivot to Option 2 or Option 3**  

**RECOMMENDATION**: IPC Service App (Option 3) - Best balance of offline, accuracy, and development time

---

## Build Attempt Details

**Repository**: https://github.com/cmusphinx/sphinx4  
**Last Updated**: 2016 (archived)  
**Build Tool**: Gradle  
**Clone Status**: ✅ Success (173.84 MB)  
**Build Status**: ❌ Failed (JAXB dependencies missing)  
**Android Compatibility**: ❌ Incompatible (Desktop Java APIs)
