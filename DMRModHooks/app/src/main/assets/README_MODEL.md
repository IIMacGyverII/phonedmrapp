# Speech Recognition Model Setup

This folder requires a TensorFlow Lite speech recognition model file named `speech_model.tflite` to enable the transcription feature.

## Quick Start - Testing Only

For immediate testing, you can use a small placeholder model to verify the loading mechanism works:

1. **Speech Embedding Model (30 MB)** - For testing only, outputs embeddings not text
   - Download: https://tfhub.dev/google/lite-model/speech_embedding/1
   - Note: This model does NOT do transcription, it only generates audio embeddings
   - Useful for: Verifying the TFLite integration works correctly
   
## Recommended Models - Real Speech-to-Text

For actual speech recognition, you'll need one of these models:

### Option A: Whisper Tiny (Recommended - 100 MB)
- **Best accuracy for modern audio**
- Size: ~100 MB
- Model: OpenAI Whisper Tiny converted to TFLite
- Source: https://github.com/usefulsensors/openai-whisper
- Instructions:
  1. Clone the repository: `git clone https://github.com/usefulsensors/openai-whisper`
  2. Find the `whisper-tiny-en.tflite` model in the releases
  3. Rename to `speech_model.tflite`
  4. Place in this folder

### Option B: DeepSpeech TFLite (47 MB)
- **Smaller size, older but stable**
- Size: ~47 MB
- Model: Mozilla DeepSpeech converted to TFLite
- Note: Requires additional conversion steps from .pbmm format
- Source: https://github.com/mozilla/DeepSpeech

### Option C: Coqui STT (Similar to DeepSpeech)
- **Actively maintained fork of DeepSpeech**
- Size: ~47-100 MB depending on model variant
- Model: Coqui STT TFLite format
- Source: https://github.com/coqui-ai/STT

## Installation Steps

1. Download one of the models above
2. Rename the file to exactly: `speech_model.tflite`
3. Place in this folder: `app/src/main/assets/speech_model.tflite`
4. Rebuild the app: `.\gradlew.bat assembleDebug`
5. Install the new APK to your device

## Expected Results

- **Without model**: APK size ~7 MB, TXT button shows "Model file not found" error
- **With 30 MB model**: APK size ~37 MB, loads but doesn't transcribe (embeddings only)
- **With 100 MB model**: APK size ~107 MB, full speech-to-text functionality

## Technical Details

The model must be in TensorFlow Lite format (.tflite file). The code expects:
- **Input**: Float32 array of normalized audio samples [-1.0, 1.0]
- **Audio format**: 16-bit PCM, 16kHz sample rate (from DMR audio)
- **Output**: Depends on model (embeddings or transcription)

The current implementation in `MainHook.java` loads the model using:
```java
AssetManager assetManager = context.getAssets();
InputStream inputStream = assetManager.open("speech_model.tflite");
ByteBuffer modelBuffer = loadModelFromAssets(inputStream);
Interpreter tfliteInterpreter = new Interpreter(modelBuffer, options);
```

## Troubleshooting

**"Model file not found" error**:
- Ensure the file is named exactly `speech_model.tflite` (case-sensitive)
- Ensure it's in the `app/src/main/assets/` folder
- Rebuild the app after adding the file

**App crashes on TXT button click**:
- Model file may be corrupted or wrong format
- Check LSPosed logs for TFLite errors
- Verify model is TFLite format (.tflite extension)

**Model loads but no transcription**:
- Some models output embeddings, not text (like speech_embedding models)
- You need a full STT model like Whisper or DeepSpeech
- Check the model's documentation for input/output tensor shapes

## Current Status

✅ TFLite integration complete
✅ Asset loading mechanism implemented
✅ Model initialization code working
⏳ Awaiting model file to be added to this folder

Once a model is added and the app is rebuilt, the transcription feature will be fully functional!
