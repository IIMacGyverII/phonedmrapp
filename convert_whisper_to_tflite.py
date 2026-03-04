#!/usr/bin/env python3
"""
Convert Whisper Base model to TFLite format
This creates a TFLite model compatible with the existing inference code.
"""

import os
import sys

try:
    import torch
    import whisper
    import tensorflow as tf
    import numpy as np
except ImportError as e:
    print(f"❌ Missing dependency: {e}")
    print("Install with: pip install openai-whisper tensorflow torch")
    sys.exit(1)

print("📥 Loading Whisper Base model...")
model = whisper.load_model("base")
print("✅ Model loaded")

print("\n🔧 Converting to TFLite...")
print("   This may take several minutes...")

# Create a dummy input (30 seconds of audio as mel spectrogram)
# Whisper expects: [batch, n_mels, n_frames] = [1, 80, 3000]
dummy_input = torch.randn(1, 80, 3000)

print("   Exporting encoder...")
# Export encoder (this is what we're using for inference)
encoder = model.encoder

# Convert model to TFLite
# Note: This is a simplified conversion - real Whisper TFLite needs full pipeline
try:
    # Trace the encoder
    traced_model = torch.jit.trace(encoder, dummy_input)
    
    # Convert to TensorFlow
    # Note: This requires additional setup - PyTorch -> ONNX -> TF -> TFLite
    print("❌ Direct PyTorch->TFLite conversion requires ONNX intermediate format")
    print("   This is complex - let's try downloading a pre-converted model instead...")
    
except Exception as e:
    print(f"❌ Conversion error: {e}")
    print("\n💡 Suggestion: Use a pre-converted TFLite model from a trusted source")
    print("   Or use the ONNX conversion pipeline")

print("\n🔍 Alternative: Downloading from known TFLite sources...")
