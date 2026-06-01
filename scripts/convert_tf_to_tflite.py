import tensorflow as tf
import numpy as np
import os
from pathlib import Path

# Source and destination
h5_model_path = r"C:\Users\Joshua\.cache\huggingface\hub\models--openai--whisper-base\snapshots\e37978b90ca9030d5170a5c07aadb050351a65bb\tf_model.h5"
output_path = r"DMRTranscriptionService\app\src\main\assets\speech_model_base.tflite"

print("🔧 Converting Whisper Base TensorFlow → TFLite...")
print(f"   Source: {h5_model_path}")
print(f"   Output: {output_path}")

try:
    # Load the H5 model
    print("\n📥 Loading TensorFlow model...")
    model = tf.keras.models.load_model(h5_model_path, compile=False)
    print(f"✅ Model loaded: {type(model)}")
    
    # Print model info
    print("\n📊 Model structure:")
    print(f"   Inputs: {[inp.shape for inp in model.inputs]}")
    print(f"   Outputs: {[out.shape for out in model.outputs]}")
    
    # Create representative dataset for quantization (optional)
    def representative_dataset():
        for _ in range(100):
            # Generate random mel spectrogram: [batch, time, mels] or [batch, mels, time]
            # Whisper typically uses [1, 80, 3000]
            data = np.random.randn(1, 80, 3000).astype(np.float32)
            yield [data]
    
    # Convert to TFLite
    print("\n🔄 Converting to TFLite...")
    converter = tf.lite.TFLiteConverter.from_keras_model(model)
    
    # Optimization settings
    converter.optimizations = [tf.lite.Optimize.DEFAULT]
    # converter.representative_dataset = representative_dataset  # Uncomment for quantization
    converter.target_spec.supported_ops = [
        tf.lite.OpsSet.TFLITE_BUILTINS,  # Enable TensorFlow Lite ops
        tf.lite.OpsSet.SELECT_TF_OPS     # Enable TensorFlow ops (might be needed for complex ops)
    ]
    
    # Convert
    tflite_model = converter.convert()
    
    # Save
    print("\n💾 Saving TFLite model...")
    os.makedirs(os.path.dirname(output_path), exist_ok=True)
    with open(output_path, 'wb') as f:
        f.write(tflite_model)
    
    size_mb = len(tflite_model) / (1024 * 1024)
    print(f"✅ SUCCESS!")
    print(f"   Output: {output_path}")
    print(f"   Size: {size_mb:.1f} MB")
    
    # Test the model
    print("\n🧪 Testing TFLite model...")
    interpreter = tf.lite.Interpreter(model_path=output_path)
    interpreter.allocate_tensors()
    
    input_details = interpreter.get_input_details()
    output_details = interpreter.get_output_details()
    
    print("   Input shape:", input_details[0]['shape'])
    print("   Output shape:", output_details[0]['shape'])
    print("✅ Model is valid!")

except Exception as e:
    print(f"\n❌ Conversion failed: {e}")
    print("\n💡 This might be because:")
    print("   1. Whisper model is encoder-decoder (complex architecture)")
    print("   2. Our current TFLite model might be a custom export")
    print("   3. Full Whisper needs special conversion pipeline")
    print("\n📋 Recommendation: Implement dynamic download feature first")
    print("   Then we can source properly converted TFLite models")
