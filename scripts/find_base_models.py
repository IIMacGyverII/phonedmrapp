import requests

print("🔍 Checking vilassn/whisper_android assets...\n")

urls_to_check = [
    "https://api.github.com/repos/vilassn/whisper_android/contents/app/src/main/assets",
    "https://api.github.com/repos/vilassn/whisper_android/contents/models",
    "https://api.github.com/repos/vilassn/whisper_android/contents",
]

for url in urls_to_check:
    print(f"Checking: {url.split('/contents/')[-1] or 'root'}")
    try:
        resp = requests.get(url)
        if resp.status_code == 200:
            files = resp.json()
            tflite_files = [f for f in files if '.tflite' in f['name'].lower()]
            
            if tflite_files:
                print("   ✅ Found TFLite models:")
                for f in tflite_files:
                    size_mb = f['size'] / (1024*1024)
                    print(f"      {f['name']} ({size_mb:.1f} MB)")
                    if 'base' in f['name'].lower():
                        print(f"         ⭐⭐⭐ WHISPER BASE!")
                        print(f"         Download: {f['download_url']}")
            else:
                print("   No .tflite files")
        else:
            print(f"   ❌ Status: {resp.status_code}")
    except Exception as e:
        print(f"   ❌ Error: {e}")
    print()

print("\n🔍 Checking for Base model in HuggingFace cache...")
print("Looking for converted models in model-specific repos...\n")

# Check some model repos that might have TFLite
tflite_repos = [
    "Xenova/whisper-base",
    "usefulsensors/whisper-base", 
    "nyadla-sys/whisper-base-tflite",
]

for repo in tflite_repos:
    try:
        from huggingface_hub import list_repo_files
        print(f"Checking {repo}...")
        files = list_repo_files(repo)
        tflite = [f for f in files if '.tflite' in f.lower()]
        if tflite:
            print(f"   ✅ Found {len(tflite)} TFLite files:")
            for f in tflite:
                print(f"      {f}")
        else:
            print(f"   No TFLite files")
    except Exception as e:
        print(f"   ❌ {e}")
    print()
