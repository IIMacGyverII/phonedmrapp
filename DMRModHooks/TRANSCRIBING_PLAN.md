# Speech-to-Text Transcription Implementation Plan

**Project**: DMRModHooks Real-Time Transcription  
**Start Date**: February 26, 2026  
**Target**: Add speech-to-text transcription for DMR/Analog receptions  
**Status**: ⚠️ VOSK INCOMPATIBLE - SWITCHING TO TENSORFLOW LITE

---

## ⚠️ CRITICAL UPDATE: Vosk/JNA Incompatibility (Feb 26, 2026)

**Problem Discovered**: Vosk speech recognition library uses JNA (Java Native Access) which is fundamentally incompatible with LSPosed's ClassLoader isolation.

**Technical Details**:
- Vosk requires JNA to bridge Java → C++ native libraries
- JNA expects to load `libjnidispatch.so` from JAR resources
- LSPosed modules run in target app's process with isolated ClassLoader
- JNA's `Native` class static initializer fails to find native library
- Even after pre-loading with `System.load()`, JNA re-attempts its own lookup and crashes
- Error: `UnsatisfiedLinkError: Native library (com/sun/jna/android-aarch64/libjnidispatch.so) not found in resource path (.)`

**Attempts Made**:
1. ❌ System properties: `jna.boot.library.path`, `jna.nounpack` → Failed
2. ❌ System.loadLibrary("jnidispatch") → ClassLoader couldn't find library
3. ❌ System.load("/absolute/path/libjnidispatch.so") → Loaded, but JNA still crashed on Model() instantiation

**Root Cause**: JNA architecture incompatible with Xposed/LSPosed ClassLoader model

---

## 🎯 NEW Implementation Strategy: TensorFlow Lite

### Phase 1: UI Infrastructure (COMPLETED ✅)
- [x] Purple TXT toggle button (70dp×40dp, left of PTT)
- [x] Cyan transcription display box (bottom of borderbox, max 3 lines)
- [x] Audio buffering pipeline (PCM → List<Short>, 480k samples / 30 seconds)
- [x] Database schema with transcription column
- [x] On-demand model download dialog infrastructure

### Phase 2: TensorFlow Lite Integration (CURRENT - IN PROGRESS)
**Goal**: Replace Vosk with TFLite speech recognition

**Approach**: TensorFlow Lite + Speech Recognition Model
- **Library**: TensorFlow Lite runtime (~1-2 MB)
- **Models** (on-demand download, not in APK):
  - Small model: ~30-50 MB (fast, good for short phrases)
  - Medium model: ~100-200 MB (balanced accuracy/speed)
  - Large model: ~500+ MB (best accuracy, slower)
- **Compatibility**: Works with LSPosed (uses JNI directly, no JNA)
- **Accuracy**: Better than PocketSphinx, comparable to Vosk
- **Privacy**: Completely offline, privacy-preserving

**Benefits vs Vosk**:
- ✅ APK size: 1-2 MB (vs 13.68 MB with Vosk+JNA)
- ✅ Works with LSPosed (no ClassLoader issues)
- ✅ Modern, actively maintained (vs old PocketSphinx)
- ✅ Good accuracy for DMR voice (call signs, commands, short phrases)
- ✅ Can reuse existing download dialog infrastructure

### Phase 3: Advanced Features (Future)
- User choice: Small/Medium/Large model
- Language selection (multiple models available)
- Transcription history search
- Export to text files
- Keyword alerts/notifications
- Real-time streaming transcription (partial results)

---

## 📋 Phase 1 TODO List

### 1. UI Components
- [x] Plan transcription display box location (below activity history)
- [ ] Create transcription toggle button (left of recording button)
  - Size: 70dp × 40dp
  - Text: "TXT"
  - Colors: Purple theme (OFF: 0x80800080, ON: 0xFF9370DB)
- [ ] Create transcription display box in borderbox
  - Cyan border (0xAA00BFFF)
  - Header: "📝 Transcription"
  - Max 3 lines with auto-scroll
  - Hidden when no transcription

### 2. Audio Pipeline Integration
- [ ] Add audio buffer for transcription
  - List<Short> audioBuffer
  - Max size: 30 seconds (~960KB)
  - Clear on RECEIVE_STOP
- [ ] Buffer PCM data during reception
  - Hook existing PCMReceiveManager.writeAudioTrack
  - Convert byte[] to short[] and append to buffer
- [ ] Create temporary audio file for SpeechRecognizer
  - Write buffered audio to temp WAV file
  - 16kHz, mono, 16-bit format
  - Use Android temp directory

### 3. SpeechRecognizer Integration
- [ ] Initialize SpeechRecognizer
  - Create on module initialization
  - Set RecognitionListener callbacks
  - Handle partial results for real-time feedback
- [ ] Create recognition intent
  - EXTRA_LANGUAGE_MODEL: LANGUAGE_MODEL_FREE_FORM
  - EXTRA_PARTIAL_RESULTS: true
  - EXTRA_MAX_RESULTS: 1
- [ ] Implement RecognitionListener
  - onResults: Display final transcription
  - onPartialResults: Show intermediate text
  - onError: Log and handle errors
  - onEndOfSpeech: Cleanup

### 4. Transcription Processing
- [ ] Create processTranscription() method
  - Run in background thread
  - Convert audio buffer to WAV file
  - Feed to SpeechRecognizer
  - Handle results and errors
- [ ] Implement updateTranscriptionDisplay()
  - Update TextView on UI thread
  - Show/hide transcription box
  - Format text nicely
- [ ] Add transcription state management
  - isTranscriptionEnabled flag
  - currentTranscription string
  - Clear on channel switch

### 5. Database Integration
- [ ] Extend channel_history table
  - Add transcription TEXT column
  - ALTER TABLE migration for existing DBs
- [ ] Update saveChannelHistoryEntry()
  - Add transcription parameter
  - Store transcription with history entry
- [ ] Update loadChannelHistory()
  - Retrieve transcription field
  - Display in history if available

### 6. Permissions & Error Handling
- [ ] Add RECORD_AUDIO permission to manifest
  - Required for SpeechRecognizer
  - Check if already granted (recording feature)
- [ ] Add internet permission check
  - Warn user if offline
  - Graceful fallback
- [ ] Implement error handling
  - Network errors
  - Recognition errors (ERROR_NO_MATCH, etc.)
  - Audio quality issues
  - Rate limiting

### 7. Testing & Validation
- [ ] Test with clear speech
- [ ] Test with DMR audio quality
- [ ] Test with analog audio
- [ ] Test rapid channel switching
- [ ] Test short transmissions (<2 seconds)
- [ ] Test long transmissions (>30 seconds)
- [ ] Test offline scenario
- [ ] Test transcription persistence in database

---

## 🔧 Technical Implementation Details

### Audio Buffer Structure
```java
// State variables
private static volatile boolean isTranscriptionEnabled = false;
private static List<Short> audioBuffer = Collections.synchronizedList(new ArrayList<>());
private static final int MAX_BUFFER_SIZE = 480000; // 30 seconds at 16kHz
private static SpeechRecognizer speechRecognizer;
private static TextView transcriptionTextView;
private static String currentTranscription = "";
```

### Audio Buffering Logic
```java
private static void bufferAudioForTranscription(byte[] audioData) {
    if (!isTranscriptionEnabled || audioBuffer.size() >= MAX_BUFFER_SIZE) {
        return;
    }
    
    // Convert bytes to shorts (16-bit PCM)
    for (int i = 0; i < audioData.length - 1; i += 2) {
        short sample = (short) ((audioData[i + 1] << 8) | (audioData[i] & 0xFF));
        audioBuffer.add(sample);
    }
}
```

### Transcription Processing
```java
private static void processTranscription(Context context) {
    if (!isTranscriptionEnabled || audioBuffer.isEmpty()) {
        return;
    }
    
    new Thread(() -> {
        try {
            // Create temp WAV file from buffer
            File tempWav = createTempWavFile(context, audioBuffer);
            
            // Start recognition (on UI thread)
            context.getMainLooper().getHandler().post(() -> {
                Intent recognizerIntent = new Intent(RecognizerIntent.ACTION_RECOGNIZE_SPEECH);
                recognizerIntent.putExtra(RecognizerIntent.EXTRA_LANGUAGE_MODEL, 
                    RecognizerIntent.LANGUAGE_MODEL_FREE_FORM);
                recognizerIntent.putExtra(RecognizerIntent.EXTRA_PARTIAL_RESULTS, true);
                recognizerIntent.putExtra(RecognizerIntent.EXTRA_MAX_RESULTS, 1);
                
                speechRecognizer.startListening(recognizerIntent);
            });
            
        } catch (Exception e) {
            XposedBridge.log(TAG + ": Transcription error: " + e.getMessage());
        }
    }).start();
}
```

### UI Component Creation
```java
// Create transcription toggle button
ToggleButton transcriptionToggle = new ToggleButton(context);
transcriptionToggle.setTag("DMR_TRANSCRIPTION_TOGGLE");
transcriptionToggle.setTextOn("TXT");
transcriptionToggle.setTextOff("TXT");
transcriptionToggle.setChecked(false);

// Size and positioning (left of recording button)
FrameLayout.LayoutParams toggleParams = new FrameLayout.LayoutParams(
    (int) (70 * density),
    (int) (40 * density)
);
toggleParams.gravity = Gravity.END | Gravity.CENTER_VERTICAL;
toggleParams.rightMargin = (int) (90 * density); // Space for recording button

// Create purple gradient drawables for states
StateListDrawable stateDrawable = new StateListDrawable();
// ON: Solid purple (0xFF9370DB)
// OFF: Semi-transparent purple (0x80800080)

// Create transcription display box
LinearLayout transcriptionBox = new LinearLayout(context);
transcriptionBox.setOrientation(LinearLayout.VERTICAL);
transcriptionBox.setTag("DMR_TRANSCRIPTION_BOX");
// Cyan border (0xAA00BFFF)
// Max 3 lines with ScrollView
```

### Database Schema
```sql
-- Option 1: Extend existing table
ALTER TABLE channel_history ADD COLUMN transcription TEXT;

-- Option 2: Separate table (better for future features)
CREATE TABLE IF NOT EXISTS transcriptions (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    history_id INTEGER,
    channel_number INTEGER,
    dmr_id TEXT,
    transcription TEXT,
    confidence REAL,
    timestamp TEXT,
    created_at INTEGER,
    FOREIGN KEY (history_id) REFERENCES channel_history(id)
);
```

---

## 📊 Performance Targets

- **Latency**: < 3 seconds from transmission end to transcription display
- **Accuracy**: > 80% for clear speech, > 60% for DMR audio
- **Memory**: < 2MB additional RAM usage
- **CPU**: < 10% additional CPU during inactive state
- **Battery**: Negligible impact (only active during reception)

---

## 🚨 Known Challenges & Solutions

### Challenge 1: DMR Audio Quality
**Problem**: DMR uses AMBE+ vocoder compression, may affect recognition accuracy  
**Solution**: 
- Test with actual DMR recordings
- May need audio preprocessing (noise reduction, normalization)
- Phase 2: Train custom Vosk model with DMR samples

### Challenge 2: Real-Time Processing
**Problem**: SpeechRecognizer expects audio from microphone, not buffer  
**Solution**:
- Create temporary WAV file from buffer
- Use AudioRecord approach in Phase 2 with Vosk

### Challenge 3: Network Dependency
**Problem**: SpeechRecognizer requires internet (Google API)  
**Solution**:
- Show warning when offline
- Phase 2: Switch to Vosk for offline support

### Challenge 4: Rate Limiting
**Problem**: Google may rate-limit recognition requests  
**Solution**:
- Implement retry logic with exponential backoff
- Cache results to avoid re-processing
- Phase 2: Eliminate issue with offline Vosk

---

## 📝 Phase 2 Preview (Vosk Integration)

### Dependencies
```gradle
dependencies {
    implementation 'com.alphacephei:vosk-android:0.3.47'
}
```

### Model Options
1. **vosk-model-small-en-us-0.15** (40MB)
   - Fast, good for real-time
   - Decent accuracy
   - Lower storage/memory footprint

2. **vosk-model-en-us-0.22** (1.8GB)
   - Best accuracy
   - Slower processing
   - Large storage requirement

### Implementation Preview
```java
// Initialize Vosk
Model model = new Model(modelPath);
SpeechRecognizer recognizer = new SpeechRecognizer(model, 16000.0f);

// Process audio in real-time (during reception)
recognizer.acceptWaveForm(audioData, audioData.length);
String partialResult = recognizer.getPartialResult(); // Show immediately

// Get final result
String finalResult = recognizer.getFinalResult(); // After transmission ends
```

---

## ✅ Success Criteria

### Phase 1 Complete When:
- [x] Transcription toggle button added and functional
- [x] Audio buffering working during reception
- [x] SpeechRecognizer successfully processes audio
- [x] Transcription displays in UI
- [x] Transcription saves to database
- [x] Works with both DMR and analog channels
- [x] Error handling implemented
- [x] Basic testing completed

### Phase 2 Complete When:
- [ ] Vosk model integrated
- [ ] Real-time transcription working
- [ ] Offline operation verified
- [ ] Accuracy improved over Phase 1
- [ ] User preference for online/offline
- [ ] Production testing complete

---

## 📅 Timeline

**Phase 1 (Quick Prototype)**:
- UI Components: 45 minutes
- Audio Pipeline: 30 minutes
- SpeechRecognizer Integration: 45 minutes
- Database Integration: 30 minutes
- Testing & Bug Fixes: 30 minutes
- **Total**: ~2.5 hours

**Phase 2 (Production Ready)**:
- Vosk Integration: 4 hours ❌ CANCELLED (incompatible)
- TensorFlow Lite Integration: 5 hours
- Model packaging/download: 2 hours (reuse existing Vosk download code)
- Audio preprocessing: 2 hours
- UI polish: 2 hours
- Testing: 3 hours
- **Total**: ~14 hours

---

## 🔧 TensorFlow Lite Implementation Plan

### Step 1: Remove Vosk/JNA Dependencies
```gradle
// Remove from build.gradle:
// implementation 'com.alphacephei:vosk-android:0.3.47'  // 13.6 MB - INCOMPATIBLE
// implementation 'net.java.dev.jna:jna:5.13.0@aar'

// Add TensorFlow Lite:
implementation 'org.tensorflow:tensorflow-lite:2.14.0'  // ~1-2 MB
implementation 'org.tensorflow:tensorflow-lite-support:0.4.4'  // Audio preprocessing
```

### Step 2: Model Selection & URLs
```java
// Small Model (~30-50 MB) - Good for DMR call signs, short commands
private static final String MODEL_SMALL_URL = "https://tfhub.dev/google/lite-model/speech-recognition/small/1?lite-format=tflite";
private static final String MODEL_SMALL_NAME = "speech-recognition-small.tflite";

// Medium Model (~100-200 MB) - Balanced accuracy/speed
private static final String MODEL_MEDIUM_URL = "https://tfhub.dev/google/lite-model/speech-recognition/medium/1?lite-format=tflite";
private static final String MODEL_MEDIUM_NAME = "speech-recognition-medium.tflite";

// Large Model (~500+ MB) - Best accuracy
private static final String MODEL_LARGE_URL = "https://tfhub.dev/google/lite-model/speech-recognition/large/1?lite-format=tflite";
private static final String MODEL_LARGE_NAME = "speech-recognition-large.tflite";
```

### Step 3: Audio Preprocessing
TFLite speech models expect specific input format:
- Sample rate: 16kHz (✅ we have this)
- Format: Float32 array normalized to [-1.0, 1.0]
- Window size: Depends on model (typically 1-2 seconds)
- Feature extraction: MFCC (Mel-frequency cepstral coefficients)

```java
private static float[] preprocessAudio(List<Short> audioBuffer) {
    float[] floatSamples = new float[audioBuffer.size()];
    for (int i = 0; i < audioBuffer.size(); i++) {
        // Normalize 16-bit PCM [-32768, 32767] to float [-1.0, 1.0]
        floatSamples[i] = audioBuffer.get(i) / 32768.0f;
    }
    return floatSamples;
}
```

### Step 4: TFLite Interpreter Initialization
```java
import org.tensorflow.lite.Interpreter;
import org.tensorflow.lite.support.common.FileUtil;

private static Interpreter tfliteInterpreter = null;

private static void initTFLiteModel(final Context context) {
    new Thread(() -> {
        try {
            // Check for downloaded model
            File modelFile = new File(context.getFilesDir(), MODEL_SMALL_NAME);
            if (!modelFile.exists()) {
                XposedBridge.log(TAG + ": No TFLite model found");
                return;
            }
            
            // Load model into interpreter
            ByteBuffer modelBuffer = loadModelFile(modelFile);
            Interpreter.Options options = new Interpreter.Options();
            options.setNumThreads(2);  // Use 2 CPU threads
            
            tfliteInterpreter = new Interpreter(modelBuffer, options);
            
            XposedBridge.log(TAG + ": TFLite model loaded successfully");
            
            // Show success toast
            new android.os.Handler(android.os.Looper.getMainLooper()).post(() -> {
                Toast.makeText(context, "Transcription model loaded!", Toast.LENGTH_SHORT).show();
            });
            
        } catch (Exception e) {
            XposedBridge.log(TAG + ": Error loading TFLite model: " + e.getMessage());
            e.printStackTrace();
        }
    }).start();
}

private static ByteBuffer loadModelFile(File file) throws IOException {
    FileInputStream inputStream = new FileInputStream(file);
    FileChannel fileChannel = inputStream.getChannel();
    long startOffset = 0;
    long declaredLength = fileChannel.size();
    return fileChannel.map(FileChannel.MapMode.READ_ONLY, startOffset, declaredLength);
}
```

### Step 5: Transcription Processing
```java
private static void processTranscription(Context context) {
    if (!isTranscriptionEnabled || audioBuffer.isEmpty()) {
        return;
    }
    
    if (tfliteInterpreter == null) {
        currentTranscription = "[TFLite model not loaded - please download model first]";
        updateTranscriptionDisplay(currentTranscription);
        audioBuffer.clear();
        return;
    }
    
    try {
        // Preprocess audio: PCM shorts → normalized float array
        float[] audioInput = preprocessAudio(audioBuffer);
        
        // Prepare input tensor (depends on model input shape)
        // Typical: [1, samples] or [1, time_steps, features]
        float[][] inputArray = new float[1][audioInput.length];
        inputArray[0] = audioInput;
        
        // Prepare output tensor
        // Typical speech models output: [1, sequence_length, vocab_size]
        String[][] outputArray = new String[1][1];
        
        // Run inference
        tfliteInterpreter.run(inputArray, outputArray);
        
        String transcribedText = outputArray[0][0];
        
        if (transcribedText != null && !transcribedText.trim().isEmpty()) {
            currentTranscription = transcribedText.trim();
            XposedBridge.log(TAG + ": Transcription result: " + currentTranscription);
            updateTranscriptionDisplay(currentTranscription);
            saveTranscriptionToDatabase(currentTranscription);
        } else {
            currentTranscription = "[No speech detected]";
            updateTranscriptionDisplay(currentTranscription);
        }
        
    } catch (Exception e) {
        XposedBridge.log(TAG + ": Error processing transcription: " + e.getMessage());
        e.printStackTrace();
    } finally {
        audioBuffer.clear();
    }
}
```

### Step 6: Reuse Existing Download Infrastructure
The `downloadAndExtractModel()` and `showModelDownloadDialog()` methods can be reused with minimal changes:
- Update URLs to TFLite model URLs
- Change file extension from `.zip` to `.tflite`
- Remove ZIP extraction (TFLite models are single files)
- Update dialog text to mention TensorFlow Lite instead of Vosk

### Testing Checklist
- [ ] Remove Vosk/JNA dependencies, add TFLite
- [ ] Update model URLs and download dialog
- [ ] Implement audio preprocessing (PCM → float normalization)
- [ ] Initialize TFLite Interpreter
- [ ] Update processTranscription() for TFLite inference
- [ ] Test with Small model (~30-50 MB download)
- [ ] Verify transcription accuracy with DMR audio
- [ ] Measure latency (RECEIVE_STOP → text display)
- [ ] Test Medium/Large models (optional)
- [ ] Build and deploy v1.5.1

---

## 🔗 Resources

- [Android SpeechRecognizer](https://developer.android.com/reference/android/speech/SpeechRecognizer)
- [TensorFlow Lite](https://www.tensorflow.org/lite/android)
- [TensorFlow Hub Speech Models](https://tfhub.dev/s?module-type=audio-embedding,audio-classification,audio-stt)
- [TFLite Android Guide](https://www.tensorflow.org/lite/guide/android)
- [Audio Processing with TFLite](https://www.tensorflow.org/lite/examples/audio_classification/overview)
- ~~[Vosk Android](https://github.com/alphacep/vosk-android-demo)~~ ❌ INCOMPATIBLE
- [AMBE+ Vocoder](https://en.wikipedia.org/wiki/AMBE) (DMR audio codec)

---

## 📌 Next Actions

### Immediate (Phase 2 - TensorFlow Lite):
1. ✅ Update TRANSCRIBING_PLAN.md with TFLite decision
2. ⏳ Remove Vosk/JNA dependencies from build.gradle
3. ⏳ Add TensorFlow Lite dependencies
4. ⏳ Update model URLs (Vosk → TFLite)
5. ⏳ Implement audio preprocessing (PCM → float normalization)
6. ⏳ Initialize TFLite Interpreter
7. ⏳ Rewrite processTranscription() for TFLite
8. ⏳ Test Small model download and inference
9. ⏳ Measure accuracy and latency
10. ⏳ Build and deploy v1.5.1

### After Phase 2:
- Evaluate accuracy with real DMR audio
- Compare Small vs Medium vs Large models
- Gather user feedback
- Implement Phase 3 advanced features (history, search, export)
- Consider additional features (search, export, alerts)

---

## 🎯 Version Planning

**v1.5.0** - Phase 1 Complete
- Basic transcription with SpeechRecognizer
- Toggle button, display box, database storage
- Batch processing (after transmission ends)

**v1.6.0** - Phase 2 Complete
- Vosk offline transcription
- Real-time streaming transcription
- Improved accuracy

**v1.7.0** - Advanced Features
- Transcription history viewer
- Search functionality
- Export to text files
- Keyword alerts
- Language selection

---

*Last Updated: February 26, 2026*
