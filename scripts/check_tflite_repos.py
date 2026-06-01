from huggingface_hub import list_repo_files, hf_hub_download
import requests

print("🔍 Checking promising repositories for model files...\n")

# Check nyadla-sys/whisper.tflite releases (274 stars)
print("1️⃣ Checking nyadla-sys/whisper.tflite (274 stars) - Optimized TFLite Port")
try:
    url = "https://api.github.com/repos/nyadla-sys/whisper.tflite/releases"
    resp = requests.get(url)
    if resp.status_code == 200:
        releases = resp.json()
        print(f"   Found {len(releases)} releases\n")
        
        for release in releases[:5]:
            print(f"   📦 {release['tag_name']}: {release['name']}")
            assets = release.get('assets', [])
            for asset in assets:
                size_mb = asset['size'] / (1024*1024)
                print(f"      💾 {asset['name']} ({size_mb:.1f} MB)")
                if 'base' in asset['name'].lower():
                    print(f"         ⭐ WHISPER BASE FOUND!")
                print(f"         {asset['browser_download_url']}")
            print()
except Exception as e:
    print(f"   ❌ Error: {e}")

print("\n2️⃣ Checking vilassn/whisper_android (621 stars) - Android TFLite")
try:
    url = "https://api.github.com/repos/vilassn/whisper_android/releases"
    resp = requests.get(url)
    if resp.status_code == 200:
        releases = resp.json()
        print(f"   Found {len(releases)} releases\n")
        
        for release in releases[:5]:
            print(f"   📦 {release['tag_name']}: {release['name']}")
            assets = release.get('assets', [])
            for asset in assets:
                size_mb = asset['size'] / (1024*1024)
                print(f"      💾 {asset['name']} ({size_mb:.1f} MB)")
                if 'base' in asset['name'].lower():
                    print(f"         ⭐ WHISPER BASE FOUND!")
                print(f"         {asset['browser_download_url']}")
            print()
except Exception as e:
    print(f"   ❌ Error: {e}")

print("\n3️⃣ Checking GitHub raw files in nyadla-sys/whisper.tflite")
try:
    url = "https://api.github.com/repos/nyadla-sys/whisper.tflite/contents"
    resp = requests.get(url)
    if resp.status_code == 200:
        files = resp.json()
        print(f"   Root directory files:")
        for f in files:
            if f['type'] == 'file':
                size_mb = f['size'] / (1024*1024)
                print(f"      {f['name']} ({size_mb:.2f} MB)")
                if '.tflite' in f['name']:
                    print(f"         ⭐ TFLite model found!")
                    print(f"         {f['download_url']}")
except Exception as e:
    print(f"   ❌ Error: {e}")

print("\n4️⃣ Checking models directory")
try:
    url = "https://api.github.com/repos/nyadla-sys/whisper.tflite/contents/models"
    resp = requests.get(url)
    if resp.status_code == 200:
        files = resp.json()
        print(f"   Models directory:")
        for f in files:
            if f['type'] == 'file':
                size_mb = f['size'] / (1024*1024)
                print(f"      {f['name']} ({size_mb:.2f} MB)")
                if 'base' in f['name'].lower() and '.tflite' in f['name']:
                    print(f"         ⭐⭐⭐ WHISPER BASE TFLITE FOUND!")
                    print(f"         {f['download_url']}")
except Exception as e:
    print(f"   ❌ Error: {e}")
