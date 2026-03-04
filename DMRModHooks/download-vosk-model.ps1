# Vosk Model Downloader for DMRModHooks
# Downloads and extracts the Vosk speech recognition model to the device

$MODEL_URL = "https://alphacephei.com/vosk/models/vosk-model-small-en-us-0.15.zip"
$MODEL_NAME = "vosk-model-small-en-us-0.15"
$MODEL_ZIP = "$env:TEMP\$MODEL_NAME.zip"
$EXTRACT_DIR = "$env:TEMP\vosk-model"
$ADB = "$env:LOCALAPPDATA\Android\Sdk\platform-tools\adb.exe"

Write-Host "=== Vosk Model Downloader for DMRModHooks ===" -ForegroundColor Cyan
Write-Host ""

# Check if ADB exists
if (-not (Test-Path $ADB)) {
    Write-Host "ERROR: ADB not found at $ADB" -ForegroundColor Red
    Write-Host "Please install Android SDK Platform Tools" -ForegroundColor Yellow
    exit 1
}

# Check for connected devices
Write-Host "Checking for connected devices..." -ForegroundColor Yellow
$devices = & $ADB devices
if ($devices -match "device$") {
    Write-Host "✓ Device connected" -ForegroundColor Green
} else {
    Write-Host "ERROR: No Android device connected" -ForegroundColor Red
    Write-Host "Please connect your device via USB and enable USB debugging" -ForegroundColor Yellow
    exit 1
}

# Download model if not already downloaded
if (Test-Path $MODEL_ZIP) {
    Write-Host "✓ Model already downloaded: $MODEL_ZIP" -ForegroundColor Green
} else {
    Write-Host "Downloading Vosk model (~40MB)..." -ForegroundColor Yellow
    Write-Host "URL: $MODEL_URL" -ForegroundColor Gray
    
    try {
        Invoke-WebRequest -Uri $MODEL_URL -OutFile $MODEL_ZIP -UseBasicParsing
        Write-Host "✓ Download complete" -ForegroundColor Green
    } catch {
        Write-Host "ERROR: Failed to download model" -ForegroundColor Red
        Write-Host $_.Exception.Message -ForegroundColor Red
        exit 1
    }
}

# Extract model
Write-Host "Extracting model..." -ForegroundColor Yellow
if (Test-Path $EXTRACT_DIR) {
    Remove-Item -Path $EXTRACT_DIR -Recurse -Force
}
New-Item -ItemType Directory -Path $EXTRACT_DIR -Force | Out-Null

try {
    Expand-Archive -Path $MODEL_ZIP -DestinationPath $EXTRACT_DIR -Force
    Write-Host "✓ Extraction complete" -ForegroundColor Green
} catch {
    Write-Host "ERROR: Failed to extract model" -ForegroundColor Red
    Write-Host $_.Exception.Message -ForegroundColor Red
    exit 1
}

# Get the app's data directory
Write-Host "Finding app data directory..." -ForegroundColor Yellow
$APP_PACKAGE = "com.pri.prizeinterphone"
$appDataDir = & $ADB shell "run-as $APP_PACKAGE pwd" 2>$null

if ($LASTEXITCODE -ne 0 -or [string]::IsNullOrWhiteSpace($appDataDir)) {
    Write-Host "ERROR: Cannot access app data directory" -ForegroundColor Red
    Write-Host "Make sure the DMR app is installed and debuggable" -ForegroundColor Yellow
    exit 1
}

$appDataDir = $appDataDir.Trim()
Write-Host "✓ App data directory: $appDataDir" -ForegroundColor Green

# Push model to device
Write-Host "Pushing model to device (this may take a minute)..." -ForegroundColor Yellow
$modelPath = Join-Path $EXTRACT_DIR $MODEL_NAME

# First push to /sdcard/tmp
& $ADB shell "mkdir -p /sdcard/tmp" 2>$null
& $ADB push $modelPath /sdcard/tmp/$MODEL_NAME

# Then copy to app's files directory
Write-Host "Installing model to app directory..." -ForegroundColor Yellow
& $ADB shell "run-as $APP_PACKAGE mkdir -p $appDataDir/files"
& $ADB shell "run-as $APP_PACKAGE cp -r /sdcard/tmp/$MODEL_NAME $appDataDir/files/"
& $ADB shell "rm -rf /sdcard/tmp/$MODEL_NAME"

Write-Host "✓ Model installed successfully!" -ForegroundColor Green
Write-Host ""
Write-Host "You can now:" -ForegroundColor Cyan
Write-Host "1. Restart the DMR app" -ForegroundColor White
Write-Host "2. Enable transcription (purple TXT button)" -ForegroundColor White
Write-Host "3. Receive a transmission to test transcription" -ForegroundColor White
Write-Host ""
Write-Host "Note: You may need to reboot the device or restart the LSPosed module for changes to take effect." -ForegroundColor Yellow
