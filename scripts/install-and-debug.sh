#!/bin/bash
# DMR App Installation and Debug Script

ADB="/mnt/c/Users/Joshua/AppData/Local/Android/Sdk/platform-tools/adb.exe"
APK="/mnt/c/Users/Joshua/Documents/phonedmrapp/app-debug.apk"
PACKAGE="com.pri.prizeinterphone"

echo "=== DMR App Installer & Debugger ==="
echo ""

echo "Checking for connected devices..."
DEVICES=$($ADB devices | grep -v "List of devices" | grep device | wc -l)

if [ $DEVICES -eq 0 ]; then
    echo "❌ No devices found!"
    echo ""
    echo "Troubleshooting steps:"
    echo "1. Connect your phone via USB"
    echo "2. Enable USB Debugging:"
    echo "   - Go to Settings > About Phone"
    echo "   - Tap 'Build Number' 7 times to enable Developer Options"
    echo "   - Go to Settings > Developer Options"
    echo "   - Enable 'USB Debugging'"
    echo "3. Check your phone for authorization prompt and tap 'Allow'"
    echo "4. Run: $ADB devices"
    exit 1
fi

echo "✅ Device connected!"
echo ""

echo "Installing APK..."
$ADB install -r "$APK"

if [ $? -eq 0 ]; then
    echo "✅ APK installed successfully!"
    echo ""
    echo "Launching app..."
    $ADB shell am start -n $PACKAGE/.activity.InterPhoneHomeActivity
    echo ""
    echo "Starting realtime debug log..."
    echo "Press Ctrl+C to stop"
    echo "=========================================="
    $ADB logcat -c
    $ADB logcat | grep -E "prize|interphone|AndroidRuntime|FATAL|DEBUG"
else
    echo "❌ Installation failed!"
    exit 1
fi
