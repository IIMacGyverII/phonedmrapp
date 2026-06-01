# IPC Service App Implementation Plan

**Decision**: Implement Option 1 - IPC Service App with TFLite + Whisper Tiny  
**Based on**: Grok's recommendation (February 26, 2026)  
**Estimated Time**: 4-8 hours  
**Status**: Ready to implement ✅

---

## Grok's Key Recommendations

### Confirmed Decisions:
✅ **IPC Service App is the best approach**  
✅ **TFLite + Whisper Tiny.en** (better than Vosk for noisy DMR audio)  
✅ **Binder/AIDL is fine** for 960KB audio buffers  
✅ **Bound Service** preferred (starts/stops with binding)  
✅ **Two apps acceptable** for power users (ham radio enthusiasts)  
✅ **Reuse existing whisper-tiny-en.tflite** (39.73 MB, already converted)

### Technical Guidance:
- Use Foreground Service with persistent notification
- Add `android:foregroundServiceType="microphone|dataSync"` in manifest
- Convert `List<Short>` → `byte[]` (little-endian 16-bit PCM)
- Send via `in byte[] pcmData` in AIDL
- Service loads TFLite Interpreter once in `onCreate()`
- Module binds on first TXT enable, prompts install if not found

---

## Architecture

```
┌─────────────────────────────────────┐
│  MacDMR App (com.evawueng.macdmr)   │
│                                     │
│  ┌───────────────────────────────┐ │
│  │ DMRModHooks LSPosed Module    │ │
│  │ - Captures DMR audio (PCM)    │ │
│  │ - Shows TXT button            │ │
│  │ - Binds to service via Binder │ │
│  └───────────────────────────────┘ │
└──────────────┬──────────────────────┘
               │ Binder/AIDL
               │ (send byte[] pcmData)
               ↓
┌──────────────────────────────────────┐
│ DMRTranscriptionService (new app)    │
│ com.macdmr.transcription.service     │
│                                      │
│ - Bound Service                      │
│ - TFLite Interpreter                 │
│ - Whisper Tiny.en model (39.73 MB)  │
│ - Receives audio, returns text       │
└──────────────────────────────────────┘
```

---

## Project Structure

### New Project: DMRTranscriptionService

```
DMRTranscriptionService/
├── app/
│   ├── src/
│   │   ├── main/
│   │   │   ├── aidl/
│   │   │   │   └── com/macdmr/transcription/
│   │   │   │       └── ITranscriptionService.aidl
│   │   │   ├── assets/
│   │   │   │   └── whisper-tiny-en.tflite (39.73 MB)
│   │   │   ├── java/com/macdmr/transcription/
│   │   │   │   ├── TranscriptionService.java
│   │   │   │   └── WhisperTranscriber.java
│   │   │   ├── AndroidManifest.xml
│   │   │   └── res/
│   │   │       └── values/strings.xml
├── build.gradle
└── settings.gradle
```

---

## Implementation Steps

### Step 1: Create Service App Project (30 min)

**Create new Android Studio project**:
- Name: `DMRTranscriptionService`
- Package: `com.macdmr.transcription`
- Minimum SDK: 24 (Android 7.0)
- Target SDK: 34 (Android 14)
- Empty Activity (or no activity, just service)

**build.gradle dependencies**:
```gradle
dependencies {
    implementation 'androidx.appcompat:appcompat:1.6.1'
    implementation 'org.tensorflow:tensorflow-lite:2.14.0'
    implementation 'org.tensorflow:tensorflow-lite-support:0.4.4'
}
```

---

### Step 2: Define AIDL Interface (15 min)

**File**: `app/src/main/aidl/com/macdmr/transcription/ITranscriptionService.aidl`

```java
package com.macdmr.transcription;

interface ITranscriptionService {
    /**
     * Transcribe PCM audio to text
     * @param pcmBytes 16-bit little-endian PCM audio data
     * @param sampleRate Audio sample rate (16000 for DMR)
     * @return Transcribed text string
     */
    String transcribe(in byte[] pcmBytes, int sampleRate);
    
    /**
     * Check if service is ready (model loaded)
     * @return true if ready to transcribe
     */
    boolean isReady();
}
```

**Build project** to generate `ITranscriptionService.Stub` and `ITranscriptionService.java`

---

### Step 3: Copy Whisper Model (5 min)

**Source**: `DMRModHooks/app/src/main/assets/whisper-tiny-en.tflite`  
**Destination**: `DMRTranscriptionService/app/src/main/assets/whisper-tiny-en.tflite`

```powershell
Copy-Item "C:\Users\Joshua\Documents\android\phonedmrapp\DMRModHooks\app\src\main\assets\whisper-tiny-en.tflite" `
          "C:\Users\Joshua\Documents\android\phonedmrapp\DMRTranscriptionService\app\src\main\assets\whisper-tiny-en.tflite"
```

---

### Step 4: Implement Whisper Transcriber (1.5 hours)

**File**: `app/src/main/java/com/macdmr/transcription/WhisperTranscriber.java`

```java
package com.macdmr.transcription;

import android.content.Context;
import android.content.res.AssetFileDescriptor;
import android.util.Log;
import org.tensorflow.lite.Interpreter;
import java.io.FileInputStream;
import java.nio.ByteBuffer;
import java.nio.ByteOrder;
import java.nio.MappedByteBuffer;
import java.nio.channels.FileChannel;

public class WhisperTranscriber {
    private static final String TAG = "WhisperTranscriber";
    private static final String MODEL_NAME = "whisper-tiny-en.tflite";
    
    private Interpreter interpreter;
    private boolean isReady = false;

    public WhisperTranscriber(Context context) {
        try {
            // Load model from assets
            MappedByteBuffer modelBuffer = loadModelFile(context);
            
            // Create interpreter with options
            Interpreter.Options options = new Interpreter.Options();
            options.setNumThreads(4); // Use 4 CPU threads
            interpreter = new Interpreter(modelBuffer, options);
            
            isReady = true;
            Log.i(TAG, "✅ Whisper Tiny model loaded successfully");
        } catch (Exception e) {
            Log.e(TAG, "❌ Failed to load model", e);
            isReady = false;
        }
    }

    private MappedByteBuffer loadModelFile(Context context) throws Exception {
        AssetFileDescriptor fileDescriptor = context.getAssets().openFd(MODEL_NAME);
        FileInputStream inputStream = new FileInputStream(fileDescriptor.getFileDescriptor());
        FileChannel fileChannel = inputStream.getChannel();
        long startOffset = fileDescriptor.getStartOffset();
        long declaredLength = fileDescriptor.getDeclaredLength();
        return fileChannel.map(FileChannel.MapMode.READ_ONLY, startOffset, declaredLength);
    }

    public String transcribe(byte[] pcmBytes, int sampleRate) {
        if (!isReady || interpreter == null) {
            Log.e(TAG, "Interpreter not ready");
            return "[Model not loaded]";
        }

        try {
            // Convert PCM bytes to float array (normalize to [-1, 1])
            float[] audioSamples = pcmBytesToFloatArray(pcmBytes);
            
            // Create input tensor (batch_size=1, sequence_length)
            ByteBuffer inputBuffer = ByteBuffer.allocateDirect(audioSamples.length * 4);
            inputBuffer.order(ByteOrder.nativeOrder());
            for (float sample : audioSamples) {
                inputBuffer.putFloat(sample);
            }
            inputBuffer.rewind();

            // Prepare output tensors (Whisper has multiple outputs)
            // Output shape depends on model - typically [1, max_tokens]
            // For Whisper Tiny: check model signature, usually character/token IDs
            ByteBuffer outputBuffer = ByteBuffer.allocateDirect(1000 * 4); // Adjust based on model
            outputBuffer.order(ByteOrder.nativeOrder());

            // Run inference
            interpreter.run(inputBuffer, outputBuffer);

            // Decode output (this is simplified - real Whisper needs token decoding)
            outputBuffer.rewind();
            String result = decodeOutput(outputBuffer);
            
            Log.i(TAG, "Transcription: " + result);
            return result;
            
        } catch (Exception e) {
            Log.e(TAG, "Transcription failed", e);
            return "[Transcription error: " + e.getMessage() + "]";
        }
    }

    private float[] pcmBytesToFloatArray(byte[] pcmBytes) {
        // Convert 16-bit little-endian PCM to float [-1, 1]
        int numSamples = pcmBytes.length / 2;
        float[] samples = new float[numSamples];
        
        for (int i = 0; i < numSamples; i++) {
            // Little-endian: low byte first
            int low = pcmBytes[i * 2] & 0xFF;
            int high = pcmBytes[i * 2 + 1];
            short sample = (short)((high << 8) | low);
            
            // Normalize to [-1, 1]
            samples[i] = sample / 32768.0f;
        }
        
        return samples;
    }

    private String decodeOutput(ByteBuffer outputBuffer) {
        // TODO: Implement proper Whisper token decoding
        // This is a placeholder - Whisper outputs token IDs that need
        // to be mapped to text using the model's vocabulary
        
        // For now, return a debug string
        return "[Whisper output - needs token decoder implementation]";
    }

    public boolean isReady() {
        return isReady;
    }

    public void close() {
        if (interpreter != null) {
            interpreter.close();
            interpreter = null;
        }
        isReady = false;
    }
}
```

**NOTE**: The `decodeOutput()` method needs proper Whisper token decoding. This may require:
- Whisper vocabulary file (JSON)
- Token-to-text mapping
- Beam search decoding
- This is the complex part - may need additional research

---

### Step 5: Implement Bound Service (1 hour)

**File**: `app/src/main/java/com/macdmr/transcription/TranscriptionService.java`

```java
package com.macdmr.transcription;

import android.app.Notification;
import android.app.NotificationChannel;
import android.app.NotificationManager;
import android.app.PendingIntent;
import android.app.Service;
import android.content.Intent;
import android.os.Build;
import android.os.IBinder;
import android.util.Log;
import androidx.core.app.NotificationCompat;

public class TranscriptionService extends Service {
    private static final String TAG = "TranscriptionService";
    private static final int NOTIFICATION_ID = 1001;
    private static final String CHANNEL_ID = "dmr_transcription_channel";
    
    private WhisperTranscriber transcriber;

    @Override
    public void onCreate() {
        super.onCreate();
        Log.i(TAG, "Service created");
        
        // Load Whisper model
        transcriber = new WhisperTranscriber(this);
        
        // Start as foreground service
        startForeground(NOTIFICATION_ID, createNotification());
    }

    @Override
    public IBinder onBind(Intent intent) {
        Log.i(TAG, "Service bound");
        return binder;
    }

    private final ITranscriptionService.Stub binder = new ITranscriptionService.Stub() {
        @Override
        public String transcribe(byte[] pcmBytes, int sampleRate) {
            Log.i(TAG, "Received " + pcmBytes.length + " bytes, " + sampleRate + " Hz");
            
            if (!transcriber.isReady()) {
                return "[Service not ready]";
            }
            
            return transcriber.transcribe(pcmBytes, sampleRate);
        }

        @Override
        public boolean isReady() {
            return transcriber != null && transcriber.isReady();
        }
    };

    private Notification createNotification() {
        // Create notification channel (Android 8+)
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            NotificationChannel channel = new NotificationChannel(
                CHANNEL_ID,
                "DMR Transcription Service",
                NotificationManager.IMPORTANCE_LOW
            );
            NotificationManager manager = getSystemService(NotificationManager.class);
            manager.createNotificationChannel(channel);
        }

        // Build notification
        return new NotificationCompat.Builder(this, CHANNEL_ID)
                .setContentTitle("DMR Transcription Active")
                .setContentText("Ready to transcribe DMR audio")
                .setSmallIcon(android.R.drawable.ic_btn_speak_now)
                .setPriority(NotificationCompat.PRIORITY_LOW)
                .build();
    }

    @Override
    public void onDestroy() {
        super.onDestroy();
        if (transcriber != null) {
            transcriber.close();
        }
        Log.i(TAG, "Service destroyed");
    }
}
```

---

### Step 6: Update Manifest (15 min)

**File**: `app/src/main/AndroidManifest.xml`

```xml
<?xml version="1.0" encoding="utf-8"?>
<manifest xmlns:android="http://schemas.android.com/apk/res/android"
    package="com.macdmr.transcription">

    <uses-permission android:name="android.permission.FOREGROUND_SERVICE" />
    <uses-permission android:name="android.permission.FOREGROUND_SERVICE_MICROPHONE" />
    <uses-permission android:name="android.permission.FOREGROUND_SERVICE_DATA_SYNC" />
    <uses-permission android:name="android.permission.POST_NOTIFICATIONS" />

    <application
        android:allowBackup="true"
        android:icon="@mipmap/ic_launcher"
        android:label="DMR Transcription Service"
        android:supportsRtl="true"
        android:theme="@style/Theme.AppCompat.Light.DarkActionBar">

        <service
            android:name=".TranscriptionService"
            android:enabled="true"
            android:exported="true"
            android:foregroundServiceType="microphone|dataSync">
            <intent-filter>
                <action android:name="com.macdmr.transcription.SERVICE" />
            </intent-filter>
        </service>

    </application>

</manifest>
```

---

### Step 7: Update DMRModHooks Module (2 hours)

**File**: `DMRModHooks/app/src/main/java/com/macdmr/hooks/MainHook.java`

#### A. Add AIDL Interface to Module

Copy the same AIDL file to module:
```
DMRModHooks/app/src/main/aidl/com/macdmr/transcription/ITranscriptionService.aidl
```

#### B. Add Service Binding Code

```java
// Add to imports
import android.content.ComponentName;
import android.content.ServiceConnection;
import android.content.Intent;
import android.os.IBinder;
import com.macdmr.transcription.ITranscriptionService;

// Add to state variables (around line 123)
private static ITranscriptionService transcriptionService = null;
private static boolean isServiceBound = false;

// Add service connection
private static ServiceConnection serviceConnection = new ServiceConnection() {
    @Override
    public void onServiceConnected(ComponentName name, IBinder service) {
        transcriptionService = ITranscriptionService.Stub.asInterface(service);
        XposedBridge.log(TAG + ": ✅ Transcription service connected");
    }

    @Override
    public void onServiceDisconnected(ComponentName name) {
        transcriptionService = null;
        XposedBridge.log(TAG + ": ⚠️ Transcription service disconnected");
    }
};

// Add bind method
private static void bindTranscriptionService(final Context context) {
    if (isServiceBound) {
        XposedBridge.log(TAG + ": Service already bound");
        return;
    }

    try {
        Intent intent = new Intent("com.macdmr.transcription.SERVICE");
        intent.setPackage("com.macdmr.transcription");
        
        boolean bound = context.bindService(
            intent,
            serviceConnection,
            Context.BIND_AUTO_CREATE
        );
        
        if (bound) {
            isServiceBound = true;
            XposedBridge.log(TAG + ": Binding to transcription service...");
        } else {
            XposedBridge.log(TAG + ": ❌ Failed to bind - service not installed?");
            showToast(context, "Install DMR Transcription Service");
        }
    } catch (Exception e) {
        XposedBridge.log(TAG + ": ❌ Bind error: " + e.getMessage());
    }
}
```

#### C. Update TXT Button Handler

Replace Sphinx4 initialization with service binding:

```java
// Around line 706 - TXT button click handler
if (transcriptionService == null) {
    // First time - bind to service
    bindTranscriptionService(context);
    showToast(context, "Connecting to transcription service...");
} else {
    // Service ready - process transcription
    processTranscription(context);
}
```

#### D. Rewrite processTranscription()

```java
private static void processTranscription(Context context) {
    if (transcriptionService == null) {
        showToast(context, "Transcription service not connected");
        return;
    }

    if (audioBuffer.isEmpty()) {
        showToast(context, "No audio buffered");
        return;
    }

    new Thread(() -> {
        try {
            // Convert List<Short> to byte[] (little-endian 16-bit PCM)
            byte[] pcmBytes = new byte[audioBuffer.size() * 2];
            for (int i = 0; i < audioBuffer.size(); i++) {
                short sample = audioBuffer.get(i);
                pcmBytes[i * 2] = (byte) (sample & 0xFF);          // Low byte
                pcmBytes[i * 2 + 1] = (byte) ((sample >> 8) & 0xFF); // High byte
            }

            XposedBridge.log(TAG + ": Sending " + pcmBytes.length + " bytes to service...");

            // Call service via Binder
            String transcription = transcriptionService.transcribe(pcmBytes, 16000);

            // Update UI on main thread
            Handler mainHandler = new Handler(Looper.getMainLooper());
            mainHandler.post(() -> {
                currentTranscription = transcription;
                updateTranscriptionDisplay(transcription);
                XposedBridge.log(TAG + ": Transcription: " + transcription);
            });

        } catch (Exception e) {
            XposedBridge.log(TAG + ": ❌ Transcription error: " + e.getMessage());
            Handler mainHandler = new Handler(Looper.getMainLooper());
            mainHandler.post(() -> {
                showToast(context, "Transcription failed");
            });
        }
    }).start();
}
```

#### E. Remove Sphinx4 Code

Delete or comment out:
- Sphinx4 imports (lines 27-31)
- `sphinx4Recognizer` and `sphinx4Config` variables
- `initSphinx4()` method
- Old `processTranscription()` with AudioInputStream

---

## Testing Plan

### Test 1: Service App Standalone (30 min)
1. Build service app APK
2. Install on device
3. Check logcat for model loading
4. Verify foreground notification appears

### Test 2: Service Binding (30 min)
1. Rebuild DMRModHooks module
2. Install module
3. Open MacDMR app
4. Click TXT button
5. Check logcat for "Service connected" message

### Test 3: End-to-End Transcription (30 min)
1. Receive DMR transmission
2. Click TXT button
3. Verify audio sent to service
4. Check transcription result displayed

---

## Known Issues / TODOs

### Critical: Whisper Token Decoding
**Problem**: Whisper output is token IDs, not text  
**Solution Needed**: Implement token-to-text decoder
- May need Whisper vocabulary JSON
- Beam search decoding
- Could use existing Python implementation as reference
- Alternative: Use different TFLite model with simpler output

### Nice-to-Have:
- Add service status indicator in module UI
- Auto-install service APK from GitHub releases
- Progress indicator during transcription
- Cancel/timeout for long processing

---

## File Checklist

### Service App Files to Create:
- [ ] `ITranscriptionService.aidl`
- [ ] `WhisperTranscriber.java`
- [ ] `TranscriptionService.java`
- [ ] `AndroidManifest.xml`
- [ ] Copy `whisper-tiny-en.tflite` to assets

### Module Files to Update:
- [ ] Add AIDL interface
- [ ] Add service binding code
- [ ] Update TXT button handler
- [ ] Rewrite `processTranscription()`
- [ ] Remove Sphinx4 code

---

## Estimated Timeline

| Task | Time | Status |
|------|------|--------|
| Create service project | 30 min | ⏳ |
| Define AIDL | 15 min | ⏳ |
| Copy model asset | 5 min | ⏳ |
| Implement WhisperTranscriber | 1.5 hours | ⏳ |
| Implement BoundService | 1 hour | ⏳ |
| Update manifest | 15 min | ⏳ |
| Update module code | 2 hours | ⏳ |
| Testing & debugging | 1.5 hours | ⏳ |
| **TOTAL** | **6.5 hours** | |

---

## Ready to Start?

**Next action**: Create DMRTranscriptionService project in Android Studio

Type "start" to begin implementation!
