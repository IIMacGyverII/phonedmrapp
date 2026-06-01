import requests

print("🎯 Checking vilassn/whisper_android models directory...\n")

# Check main models directory
url = "https://api.github.com/repos/vilassn/whisper_android/contents/models_and_scripts"
resp = requests.get(url)
if resp.status_code == 200:
    items = resp.json()
    print("models_and_scripts contents:")
    for item in items:
        print(f"  {item['name']} ({item['type']})")
    print()

# Check generated_model subdirectory
url2 = "https://api.github.com/repos/vilassn/whisper_android/contents/models_and_scripts/generated_model"
resp2 = requests.get(url2)
if resp2.status_code == 200:
    files = resp2.json()
    print("generated_model directory:")
    for f in files:
        size_mb = f['size'] / (1024*1024)
        is_base = 'base' in f['name'].lower()
        is_tflite = '.tflite' in f['name'].lower()
        marker = " ⭐⭐⭐ BASE TFLITE!" if (is_base and is_tflite) else ""
        print(f"  {f['name']} - {size_mb:.1f} MB{marker}")
        if is_base and is_tflite:
            print(f"    Download: {f['download_url']}")
    print()
    
    # Find all Base models
    base_models = [f for f in files if 'base' in f['name'].lower() and '.tflite' in f['name'].lower()]
    if base_models:
        print(f"\n✅ SUCCESS! Found {len(base_models)} Whisper Base TFLite model(s)!\n")
        for model in base_models:
            size_mb = model['size'] / (1024*1024)
            print(f"📦 {model['name']}")
            print(f"   Size: {size_mb:.1f} MB")
            print(f"   Direct download: {model['download_url']}")
            print()
    else:
        print("\n❌ No Base TFLite models found")
else:
    print(f"❌ Error accessing generated_model: {resp2.status_code}")

# Also check if there's a download script or instructions
url3 = "https://api.github.com/repos/vilassn/whisper_android/contents/models_and_scripts"
resp3 = requests.get(url3)
if resp3.status_code == 200:
    files = resp3.json()
    scripts = [f for f in files if '.py' in f['name'] or '.md' in f['name']]
    if scripts:
        print("\n📜 Model generation scripts found:")
        for script in scripts:
            print(f"  {script['name']}")
