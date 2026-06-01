import requests

print("🔍 Searching GitHub issues for Whisper Base TFLite models...\n")

# Search issues in popular repos
repos = [
    "nyadla-sys/whisper.tflite",
    "vilassn/whisper_android",
    "ggerganov/whisper.cpp",
]

for repo in repos:
    print(f"\n📦 Checking issues in {repo}")
    url = f"https://api.github.com/repos/{repo}/issues?state=all&per_page=30"
    try:
        resp = requests.get(url)
        if resp.status_code == 200:
            issues = resp.json()
            for issue in issues:
                title = issue['title'].lower()
                body = (issue.get('body') or '').lower()
                
                # Look for mentions of base model or download links
                if ('base' in title or 'base' in body or 
                    'download' in title or 'tflite' in title):
                    print(f"\n  Issue #{issue['number']}: {issue['title']}")
                    print(f"    {issue['html_url']}")
                    
                    # Check if body contains download links
                    if body:
                        if 'http' in body and ('.tflite' in body or 'base' in body):
                            print("    💡 Contains potential download links!")
                            # Extract URLs
                            import re
                            urls = re.findall(r'http[s]?://(?:[a-zA-Z]|[0-9]|[$-_@.&+]|[!*\\(\\),]|(?:%[0-9a-fA-F][0-9a-fA-F]))+', body)
                            for u in urls[:3]:
                                if '.tflite' in u or 'model' in u or 'drive.google' in u:
                                    print(f"      🔗 {u}")
    except Exception as e:
        print(f"  ❌ Error: {e}")

print("\n\n🔍 Trying one more approach - checking model hosting services...")
print("Looking for Whisper Base models on TensorFlow Hub...")

try:
    # TFHub search
    import json
    url = "https://tfhub.dev/s?q=whisper%20base"
    print(f"\nTensorFlow Hub search: {url}")
    print("(Open this in browser to search manually)")
except:
    pass
