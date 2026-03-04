import requests
import json

print("🔍 Searching for Whisper TFLite models on GitHub...\n")

# Search GitHub
url = 'https://api.github.com/search/repositories?q=whisper+tflite&sort=stars&order=desc&per_page=15'
try:
    resp = requests.get(url)
    repos = resp.json()['items']
    
    print("📦 Top Whisper + TFLite repositories:\n")
    for i, r in enumerate(repos):
        print(f'{i+1}. {r["full_name"]} - ⭐{r["stargazers_count"]} stars')
        print(f'   {r["html_url"]}')
        if r["description"]:
            print(f'   {r["description"][:100]}')
        print()
        
    # Check specific promising repos for releases
    print("\n🔎 Checking for releases with .tflite files...\n")
    
    promising_repos = [
        "usefulsensors/openai-whisper",
        "karpathy/whisper.cpp",
        "ggerganov/whisper.cpp",
    ]
    
    for repo in promising_repos:
        try:
            releases_url = f'https://api.github.com/repos/{repo}/releases'
            rel_resp = requests.get(releases_url)
            if rel_resp.status_code == 200:
                releases = rel_resp.json()
                if releases:
                    print(f"✅ {repo} has {len(releases)} releases")
                    for release in releases[:2]:
                        assets = release.get('assets', [])
                        tflite_assets = [a for a in assets if '.tflite' in a['name'].lower() or 'base' in a['name'].lower()]
                        if tflite_assets:
                            print(f"   📦 Release: {release['tag_name']}")
                            for asset in tflite_assets:
                                size_mb = asset['size'] / (1024*1024)
                                print(f"      💾 {asset['name']} ({size_mb:.1f} MB)")
                                print(f"         {asset['browser_download_url']}")
        except:
            pass
            
except Exception as e:
    print(f"❌ Error: {e}")

print("\n🔍 Searching HuggingFace for TFLite models...")
try:
    # Search HF for tflite whisper models
    from huggingface_hub import HfApi
    api = HfApi()
    models = api.list_models(filter="whisper", limit=20)
    
    print("📦 Whisper models on HuggingFace:\n")
    for model in models:
        if 'tflite' in model.modelId.lower() or 'base' in model.modelId.lower():
            print(f"   {model.modelId}")
            print(f"   https://huggingface.co/{model.modelId}")
            print()
except Exception as e:
    print(f"❌ HuggingFace search error: {e}")
