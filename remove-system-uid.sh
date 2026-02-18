#!/bin/bash
cd ~/phonedmrapp

echo "Removing system shared user ID from manifest..."

# Remove the sharedUserId attribute
sed -i 's/ android:sharedUserId="android.uid.system"//' app/src/main/AndroidManifest.xml

echo "Done! Checking manifest:"
head -4 app/src/main/AndroidManifest.xml

echo ""
echo "Rebuilding APK..."
./gradlew assembleDebug | tail -3

echo ""
echo "Copying APK..."
cp app/build/outputs/apk/debug/app-debug.apk /mnt/c/Users/Joshua/Documents/phonedmrapp/InterPhone-Modded.apk

echo ""
echo "Ready to install!"
