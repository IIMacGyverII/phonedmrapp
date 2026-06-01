# TODO: Dynamic Model Downloading Feature

## Priority: HIGH
**Requested:** February 27, 2026
**Status:** Not Started

## Problem
Currently, the TFLite model is bundled in the APK (39.7 MB for Whisper Tiny).
- **Whisper Base** would add ~140 MB → total APK ~180 MB
- **Whisper Small** would add ~460 MB → total APK ~500 MB
- This makes the APK very large and difficult to distribute

## Solution: Implement Dynamic Model Download

### Architecture
```
First Launch/Settings:
1. User selects model quality (Fast/Balanced/Accurate)
2. App downloads model from CDN/GitHub/Hugging Face
3. Model stored in app's cache/files directory
4. Future launches use cached model
```

### Implementation Steps

#### 1. Model Storage Location
- Path: `/data/data/com.macdmr.transcription/files/models/`
- Structure:
  ```
  models/
    ├── whisper-tiny.tflite (39 MB) - Fast, lower accuracy
    ├── whisper-base.tflite (140 MB) - Balanced (RECOMMENDED)
    ├── whisper-small.tflite (460 MB) - Accurate, slower
    └── vocab.json (0.8 MB) - Shared vocabulary
  ```

#### 2. Download Manager
Create `ModelDownloadManager.java`:
```java
public class ModelDownloadManager {
    private static final String MODEL_BASE_URL = "https://github.com/YOUR_REPO/releases/download/models/";
    
    public enum ModelVariant {
        TINY("whisper-tiny.tflite", 41_000_000),
        BASE("whisper-base.tflite", 147_000_000),
        SMALL("whisper-small.tflite", 483_000_000);
        
        final String filename;
        final long sizeBytes;
    }
    
    public void downloadModel(ModelVariant variant, ProgressListener listener) {
        // Download with progress callbacks
        // Verify checksum
        // Move to models directory
    }
    
    public boolean isModelDownloaded(ModelVariant variant) {
        // Check if model exists and is valid
    }
}
```

#### 3. Settings UI
Add to DMRTranscriptionService settings:
- **Model Quality** dropdown:
  - Fast (Tiny - 39 MB) - Current speed, lower accuracy
  - Balanced (Base - 140 MB) ⭐ RECOMMENDED
  - Accurate (Small - 460 MB) - Best quality, slower
- **Download** button with progress bar
- **Storage used**: Show current model size
- **Delete model** button to free space

#### 4. WhisperTranscriber Changes
Update constructor to load from files directory instead of assets:
```java
private MappedByteBuffer loadModelFile(Context context, String modelFilename) {
    File modelFile = new File(context.getFilesDir(), "models/" + modelFilename);
    if (!modelFile.exists()) {
        // Fall back to bundled Tiny model in assets
        return loadFromAssets(context, "speech_model.tflite");
    }
    // Load from downloaded file
    return loadFromFile(modelFile);
}
```

#### 5 Startup Flow
```
App Launch
  → Check if model exists in filesystem
  → If NOT downloaded:
      → Show "Download Model" dialog
      → Recommend Whisper Base (balanced)
      → Download on user confirmation
  → If downloaded:
      → Load model and continue
```

#### 6. Hosting Models
Options for hosting TFLite models:
1. **GitHub Releases** (FREE, 2 GB per file limit)
   - Upload whisper-tiny.tflite, whisper-base.tflite, whisper-small.tflite
   - Download via: `https://github.com/USER/REPO/releases/download/v1.0/whisper-base.tflite`
   
2. **HuggingFace** (FREE, unlimited)
   - Upload to your HuggingFace repository
   - Download via API: `https://huggingface.co/YOUR_USER/YOUR_REPO/resolve/main/whisper-base.tflite`
   
3. **Google Cloud Storage** (PAID, but fast CDN)
   - Best for production
   - Supports CDN caching worldwide

## Benefits
- ✅ Small initial APK size (~10 MB)
- ✅ Users choose speed vs accuracy trade-off
- ✅ Easy to add new models (Medium, Large, multilingual)
- ✅ Update models without releasing new APK
- ✅ Users can delete models to free space

## Testing Plan
1. Test download with slow network (show progress)
2. Test resume after interruption
3. Test checksum verification
4. Test fallback to bundled Tiny if download fails
5. Test switching between models

## Model Conversion Notes
To get proper TFLite models:
- **Option A**: Use pre-converted models from trusted sources
- **Option B**: Convert using ONNX pipeline:
  ```
  PyTorch Whisper → ONNX → TensorFlow → TFLite
  ```
- **Option C**: Use Whisper TFLite from repositories like:
  - https://github.com/usefulsensors/openai-whisper (if available)
  - Kaggle Whisper TFLite datasets
  - Community conversions

Current Whisper Tiny source: Unknown (bundled in assets)
Need to find/create Whisper Base TFLite (~140 MB expected)

## Reminder
**USER REQUEST:** Implement dynamic model download so models aren't bundled in APK.
**Priority:** Should implement this BEFORE adding larger models.
**Benefit:** Users can try different models without increasing APK size significantly.

---
**Created:** February 27, 2026  
**Remind me when:** Working on transcription improvements or model upgrades
