from huggingface_hub import list_repo_files

print("Checking HuggingFace for Whisper Base formats...")
files = list_repo_files('openai/whisper-base')

print("\n📁 Available files in openai/whisper-base:")
for f in sorted(files):
    print(f"   {f}")

# Check for convertible formats
onnx_files = [f for f in files if 'onnx' in f.lower() or 'tflite' in f.lower()]
if onnx_files:
    print("\n✅ Convertible formats found:")
    for f in onnx_files:
        print(f"   {f}")
else:
    print("\n❌ No ONNX or TFLite format found")
    print("   Only PyTorch format available - requires conversion")
