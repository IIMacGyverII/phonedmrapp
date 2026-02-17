# Continuation Notes for Future AI Sessions

**Project**: PrizeInterphone DMR App Reverse Engineering  
**Last Session**: 2026-02-17  
**Status**: WSL2 environment ready, blocked on resource conflicts, switching to JADX approach

---

## Critical Context for Next Session

### What We've Accomplished
1. ✅ Force-wiped GitHub repo and started fresh
2. ✅ Decompiled APK with apktool 2.12.1 → `decompiled/` directory
3. ✅ Created Android Gradle project structure (AGP 7.4.2, Gradle 8.2)
4. ✅ Installed WSL2 Ubuntu + Java 17 + Android SDK (~android-sdk)
5. ✅ Fixed resource naming issues (removed $ prefix from 7 files)
6. ✅ Removed duplicate library layouts and public.xml
7. ✅ Cleaned 41 duplicate attributes from attrs.xml
8. ✅ Added androidx.preference:preference:1.2.1 dependency

### Current Blocker
**Problem**: Build fails with duplicate resource attribute errors. The decompiled APK's resource XMLs (especially attrs.xml, styles.xml) contain 1000+ attribute definitions that duplicate AndroidX library attributes. Manual cleanup removed 41 duplicates, but 17+ more remain, and each build reveals new conflicts.

**Root Cause**: apktool extracts ALL resources including framework/library resources that should come from dependencies, not the app itself.

### Why We're Switching Approaches
- Current approach: Manually removing duplicate attributes one-by-one from attrs.xml
- Problem: Not sustainable (attrs.xml has 1,435 lines even after cleanup)
- Better approach: Use JADX to decompile to Java sources, avoid resource conflicts

---

## RECOMMENDED NEXT STEP: JADX Java Decompilation

### Why JADX?
- Gets actual Java source code (not smali bytecode or stubs)
- Provides cleaner resources without framework/library duplicates
- Lets AndroidX dependencies provide standard attributes/styles
- Only keep app-specific custom resources

### JADX Workflow (Execute This)

```bash
# In WSL Ubuntu terminal, navigate to project
cd ~/phonedmrapp

# Download JADX (latest stable version)
wget https://github.com/skylot/jadx/releases/download/v1.4.7/jadx-1.4.7.zip
unzip jadx-1.4.7.zip -d jadx

# Decompile APK to Java sources
./jadx/bin/jadx -d decompiled-java /mnt/c/Users/Joshua/Documents/phonedmrapp/originalapk/com.pri.prizeinterphone.apk

# IMPORTANT: Review the output structure first
ls -la decompiled-java/sources/

# Copy Java sources to project (replacing stubs)
rm -rf app/src/main/java/com/pri/prizeinterphone
cp -r decompiled-java/sources/com/pri/prizeinterphone app/src/main/java/com/

# Clean up conflicting resources
# Keep: strings.xml, arrays.xml, plurals.xml, layouts, drawables, assets
# Delete: attrs.xml, styles.xml, colors.xml, dimens.xml (or create minimal versions)
cd app/src/main/res/values
mv strings.xml strings.xml.bak
mv arrays.xml arrays.xml.bak
mv plurals.xml plurals.xml.bak
rm *.xml
mv strings.xml.bak strings.xml
mv arrays.xml.bak arrays.xml
mv plurals.xml.bak plurals.xml

# Create minimal colors.xml with only app-specific colors
cat > colors.xml << 'EOF'
<?xml version="1.0" encoding="utf-8"?>
<resources>
    <color name="colorPrimary">#3F51B5</color>
    <color name="colorPrimaryDark">#303F9F</color>
    <color name="colorAccent">#FF4081</color>
</resources>
EOF

# Create minimal styles.xml with only app themes
cat > styles.xml << 'EOF'
<?xml version="1.0" encoding="utf-8"?>
<resources>
    <style name="AppTheme" parent="Theme.AppCompat.Light.DarkActionBar">
        <item name="colorPrimary">@color/colorPrimary</item>
        <item name="colorPrimaryDark">@color/colorPrimaryDark</item>
        <item name="colorAccent">@color/colorAccent</item>
    </style>
    
    <style name="AppTheme_Dialog" parent="Theme.AppCompat.Light.Dialog"/>
    
    <style name="DeviceKilledDialog" parent="Theme.AppCompat.Light.Dialog.Alert"/>
</resources>
EOF

# If app needs custom progress bar attributes, create minimal attrs.xml
# Only include NON-AndroidX attributes (like progress_current, progress_max, etc.)
# Check decompiled-java/resources.arsc/res/values/attrs.xml for app-specific ones

# Clean and rebuild
cd ~/phonedmrapp
rm -rf .gradle build app/build
./gradlew assembleDebug
```

### Expected Outcome
- Build should succeed with real Java code
- No resource merge conflicts (using AndroidX standard resources)
- APK created at: `app/build/outputs/apk/debug/app-debug.apk`

### If Build Still Fails
1. Check for missing custom resources referenced in layouts
2. Look for app-specific attributes used in XML files
3. Create minimal versions of those custom attributes only
4. Check JADX output for any decompilation errors/warnings

---

## Project File Locations

### On Windows
- Project root: `C:\Users\Joshua\Documents\phonedmrapp`
- Original APK: `originalapk/com.pri.prizeinterphone.apk`
- Apktool output: `decompiled/` (smali + resources)

### On WSL Ubuntu
- Project copy: `~/phonedmrapp` (Linux filesystem - use this for builds!)
- Android SDK: `~/android-sdk`
- Java: `/usr/lib/jvm/java-17-openjdk-amd64`

### Important Paths
- **Build from**: `~/phonedmrapp` (not `/mnt/c/...`)
- **Reason**: WSL has permission issues on Windows mounts

---

## Build Environment

### WSL2 Setup
```bash
# Already installed and configured:
- Ubuntu on WSL2
- OpenJDK 17.0.18
- Android SDK at ~/android-sdk
  - build-tools 33.0.1
  - platforms android-34
  - platform-tools

# Java version
java -version  # openjdk version "17.0.18"

# Gradle wrapper
cd ~/phonedmrapp
./gradlew --version  # Gradle 8.2
```

### Dependencies (app/build.gradle)
```gradle
dependencies {
    implementation 'androidx.appcompat:appcompat:1.6.1'
    implementation 'com.google.android.material:material:1.11.0'
    implementation 'androidx.constraintlayout:constraintlayout:2.1.4'
    implementation 'androidx.core:core:1.12.0'
    implementation 'androidx.lifecycle:lifecycle-runtime:2.7.0'
    implementation 'androidx.emoji2:emoji2:1.4.0'
    implementation 'androidx.startup:startup-runtime:1.1.1'
    implementation 'androidx.preference:preference:1.2.1'
    implementation 'androidx.legacy:legacy-support-v4:1.0.0'
}
```

---

## App Architecture (from Manifest & Smali Analysis)

### Main Components
- **Application**: `PrizeInterPhoneApp` - Main app initialization
- **Main Activity**: `InterPhoneHomeActivity` - Launcher with ViewPager (5 tabs)
- **Service**: `InterPhoneService` - Persistent DMR service (priority 1000)
- **Update Activity**: `UpdateFirmwareActivity` - YMODEM firmware updates

### Key Packages (in smali_classes4/com/pri/prizeinterphone/)
- `activity/` - UI activities
- `audio/` - Audio recording/playback
- `codec/` - DMR codec (AMBE/AMBE+)
- `config/` - Configuration management
- `manager/` - Managers (contacts, channels, audio, DMR)
- `message/` - DMR messaging
- `protocol/` - DMR protocol implementation
- `serial/` - Serial port communication (critical!)
- `talkbak/` - PTT control
- `ymodem/` - Firmware update protocol

### Critical Features
- **System UID**: App uses `android:sharedUserId="android.uid.system"`
- **Serial Port**: Communicates with DMR hardware via /dev/tty*
- **Permissions**: Needs system privileges for serial port access
- **Non-SDK APIs**: Uses `android:usesNonSdkApi="true"`

---

## After Successful Build

### Next Steps:
1. **Install APK**:
   ```bash
   adb devices  # Ensure phone is connected
   adb install ~/phonedmrapp/app/build/outputs/apk/debug/app-debug.apk
   ```

2. **Launch App**:
   ```bash
   adb shell am start -n com.pri.prizeinterphone/.InterPhoneHomeActivity
   ```

3. **Monitor Logs**:
   ```bash
   adb logcat | grep -i "prize\|interphone\|dmr"
   ```

4. **Debug Issues**:
   - Check for missing permissions (likely need system installation)
   - Verify serial port access (may need root)
   - Check DMR hardware module connection
   - Debug audio pipeline initialization
   - Fix service lifecycle issues

5. **Iterative Development**:
   - Fix runtime crashes one by one
   - Test PTT functionality
   - Test contact/channel management
   - Test DMR messaging
   - Test firmware updates

---

## Important Reminders

### DO:
- ✅ Build from `~/phonedmrapp` (Linux filesystem)
- ✅ Use JADX for Java decompilation (not smali conversion)
- ✅ Keep only app-specific resources, let AndroidX provide standard ones
- ✅ Test on actual DMR-capable phone with radio module
- ✅ Commit frequently to GitHub

### DON'T:
- ❌ Build from `/mnt/c/...` (Windows mount - permission errors)
- ❌ Try to manually clean all duplicate attributes (not scalable)
- ❌ Use apktool resources as-is (too many framework conflicts)
- ❌ Expect app to work on regular phones (needs DMR hardware)

---

## Git Repository

- **URL**: https://github.com/IIMacGyverII/phonedmrapp
- **Last Commit**: (Need to commit after JADX work)
- **Branch**: main

### Before Next Commit:
```bash
cd /mnt/c/Users/Joshua/Documents/phonedmrapp
git add .
git commit -m "WIP: Switch to JADX decompilation approach - Java sources ready"
git push origin main
```

---

## Questions to Ask User

1. Does the target phone have a physical DMR radio module hardware?
2. What is the exact phone model that had this ROM?
3. Are you able to provide root access on the target device?
4. What serial port device paths does the DMR module use?
5. Do you have documentation on the DMR protocol or hardware specs?

---

## Tools & Resources

- **apktool 2.12.1**: Already used for initial decompilation
- **JADX 1.4.7**: Download and use for Java decompilation (see workflow above)
- **Android Studio**: Optional, for code editing/debugging
- **ADB**: For installing and debugging on phone
- **Serial Port Tool**: May need for testing serial communication

---

**CRITICAL**: Start with the JADX workflow above. This is the key to unblocking the build.

**Expected Time**: 15-30 minutes for JADX decompilation + resource cleanup + rebuild

**Success Criteria**: `./gradlew assembleDebug` completes successfully and produces `app-debug.apk`

---

**Last Updated**: 2026-02-17  
**Next Agent**: Execute JADX workflow, rebuild, test on phone
