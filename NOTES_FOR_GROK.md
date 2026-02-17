# NOTES FOR GROK - DMR App Reverse Engineering Progress

**Project**: PrizeInterphone DMR (Digital Mobile Radio) App  
**Original APK**: com.pri.prizeinterphone.apk  
**Package**: com.pri.prizeinterphone  
**Date Started**: February 17, 2026  

---

## Current Status

✅ **COMPLETED**:
1. Force wiped GitHub repo and started fresh with clean state
2. Decompiled APK with apktool 2.12.1
3. Created standard Android Gradle project structure (AGP 7.4.2, Gradle 8.2)
4. Moved resources, assets, and manifest to proper locations
5. Created stub Java classes for main components:
   - PrizeInterPhoneApp.java (Application class)
   - InterPhoneHomeActivity.java (Main launcher activity with ViewPager)
   - InterPhoneService.java (DMR interphone service)
6. Fixed resource file naming issues (removed "$" prefix from 7 drawable files)
7. Removed duplicate library resources (AppCompat layouts)
8. Removed public.xml to avoid conflicts
9. **Installed WSL2 Ubuntu environment**
10. **Installed Java 17 (OpenJDK 17.0.18) in WSL**
11. **Installed Android SDK in WSL** (~/android-sdk)
   - build-tools 33.0.1
   - platforms android-34
   - platform-tools
12. **Copied project to Linux filesystem** (~/phonedmrapp)
13. **Added androidx.preference:preference:1.2.1** dependency
14. **Cleaned 41 duplicate AndroidX attributes** from attrs.xml
15. Restored colors.xml, styles.xml, dimens.xml from decompiled source

🚧 **IN PROGRESS**:
- Resolving resource merge conflicts between decompiled APK resources and AndroidX dependencies
- Current blocker: ~17 additional duplicate attributes still causing build failures

❌ **CRITICAL ISSUE**:
- **Decompiled resource XMLs contain 1000+ attribute definitions** that duplicate AndroidX library attributes
- Surgical removal of duplicates is not sustainable (removed 41, but 17+ more remain)
- attrs.xml alone has 1,435 lines even after cleanup
- Each build reveals new conflicts as different resources are processed
- **Root cause**: apktool extracts ALL resources including framework/library resources that should come from dependencies

---

## Decompile Summary

### APK Structure (from apktool):
```
decompiled/
├── AndroidManifest.xml
├── assets/
├── res/              (Resources: layouts, drawables, values)
├── smali/            (Android framework classes)
├── smali_classes2/   (AndroidX library classes)
├── smali_classes3/   (AndroidX library classes)
├── smali_classes4/   (App code: com.pri.prizeinterphone.*)
└── unknown/          (Binary data, phone number metadata)
```

### Key App Components (from manifest):
- **Main Activity**: `InterPhoneHomeActivity` (LAUNCHER)
  - Layout: activity_interphone_home.xml (ViewPager with 5 tabs)
  - Tabs: Talkback, Channel, Contacts, Message, Local
- **Application**: `PrizeInterPhoneApp`
- **Service**: `InterPhoneService` (persistent, priority 1000)
- **Update Activity**: `UpdateFirmwareActivity` (DMR firmware updates)
- **System App**: Uses `android:sharedUserId="android.uid.system"`
- **FileProvider**: For file sharing (com.pri.prizeinterphone.files)

### Permissions & Features:
- Custom permission: `DYNAMIC_RECEIVER_NOT_EXPORTED_PERMISSION`
- Protected broadcast: `com.action.broadcast.TALK_RECEIVING_UPDATE`
- Uses non-SDK APIs (`android:usesNonSdkApi="true"`)
- Legacy external storage support

---

## Fixes Applied

### File Renames:
1. **Removed "$" prefix** from drawable XML files (invalid Android resource name):
   - `$avd_hide_password__0.xml` → `avd_hide_password__0.xml`
   - `$avd_hide_password__1.xml` → `avd_hide_password__1.xml`
   - `$avd_hide_password__2.xml` → `avd_hide_password__2.xml`
   - `$avd_show_password__0.xml` → `avd_show_password__0.xml`
   - `$avd_show_password__1.xml` → `avd_show_password__1.xml`
   - `$avd_show_password__2.xml` → `avd_show_password__2.xml`
   - `$ic_launcher_foreground__0.xml` → `ic_launcher_foreground__0.xml`

### Resource Cleanup:
2. **Removed duplicate library resources** (already provided by dependencies):
   - Deleted 28+ `abc_*.xml` layouts (AppCompat)
   - Deleted `design_*.xml` layouts (Material Design)
   - Deleted `mtrl_*.xml`, `notification_*.xml`, `support_*.xml`
   - Deleted `public.xml` (5207 lines, can cause conflicts)

### Gradle Configuration:
3. **Created build files**:
   - `settings.gradle`: Project setup with Google/Maven repos
   - `build.gradle`: Root with AGP 8.1.4 plugin
   - `app/build.gradle`: 
     - compileSdk 34, minSdk 24, targetSdk 34
     - AndroidX dependencies (appcompat, material, core, lifecycle, emoji2)
     - Namespace: com.pri.prizeinterphone
   - `gradle.properties`: AndroidX enabled, 2GB JVM heap
   - Gradle wrapper 8.2

### Manifest Fixes:
4. **AndroidManifest.xml warnings** (not yet fixed):
   - Remove `package="com.pri.prizeinterphone"` attribute (deprecated in AGP 8+)
   - Remove `android:extractNativeLibs` attribute  

---

## Build Logs & Errors

### Build Attempt #1:
```
ERROR: $avd_hide_password__0.xml: '$' is not a valid file-based resource name character
```
**Fix**: Renamed files to remove "$" prefix ✅

### Build Attempt #2:
```
ERROR: Execution failed for task ':app:mergeDebugResources'.
> Resource compilation failed (Failed to compile values resource file 
  C:\Users\Joshua\Documents\phonedmrapp\app\build\intermediates\incremental\
  debug\mergeDebugResources\merged.dir\values\values.xml. 
  
  Cause: java.nio.file.InvalidPathException: Illegal char <:> at index 50: 
  com.pri.prizeinterphone.app-mergeDebugResources-31:/values/values.xml). 
```
**Status**: UNRESOLVED ❌  
**Cause**: Windows AAPT2 issue with path handling (colon in resource identifier)  
**Attempted Fixes**:
- Removed public.xml
- Cleaned build (`./gradlew clean`)
- Removed duplicate library resources
- Added AAPT options to build.gradle

**Recommended Next Steps**:
1. Install WSL2 and build from Linux environment (bypasses Windows AAPT2 bugs)
2. OR: Check/fix encoding issues in values XML files (strings.xml, etc.)
3. OR: Downgrade to AGP 7.x which uses different AAPT2 version
4. OR: Manually inspect merged values.xml in build directory for problematic entries

---

## Runtime Debug Logs

*No runtime logs yet - build must succeed first*

---

## Smali Code Structure

### Main Package: `com.pri.prizeinterphone` (smali_classes4)  

**Core Classes**:
- `PrizeInterPhoneApp.smali` - Application initialization
- `InterPhoneHomeActivity.smali` - Main UI with ViewPager
- `InterPhoneService.smali` - Background DMR service
- `AppObserver.smali` - App lifecycle observer

**Subdirectories**:
- `activity/` - All app activities (UpdateFirmware, MessageContent, Contacts, Channel, Settings, etc.)
- `fragment/` - UI fragments for tabs
- `audio/` - Audio recording/playback management
- `codec/` - DMR audio codec (likely AMBE/AMBE+)
- `config/` - Configuration management
- `constant/` - App constants
- `data/` - Data models (contacts, messages, channels)
- `handler/` - Event handlers
- `manager/` - Various managers (likely: ContactManager, ChannelManager, AudioManager)
- `message/` - DMR messaging
- `notification/` - Notification handling
- `protocol/` - DMR protocol implementation
- `record/` - Call recording
- `serial/` - Serial port communication (to DMR radio module)
- `serialport/` - Low-level serial I/O
- `shellexec/` - Shell command execution (system app privileges)
- `state/` - State machine
- `talkbak/` - Push-to-talk (PTT) control
- `Util/` - Utility classes
- `widget/` - Custom UI widgets
- `ymodem/` - YMODEM protocol (firmware updates)

**Key Features Identified**:
1. **Serial Communication**: Direct UART/serial port to DMR radio module
2. **DMR Protocol**: Full DMR protocol stack implementation
3. **Audio Pipeline**: Recording, encoding, decoding, playback
4. **Contact/Channel Management**: Database-backed contacts and channel lists
5. **Messaging**: DMR text messaging
6. **Firmware Updates**: YMODEM-based firmware flashing for radio module
7. **PTT Control**: Push-to-talk button handling
8. **System Integration**: Runs as system app with elevated privileges

---

## Next Steps

### IMMEDIATE (to fix build):
1. **Option A**: Install WSL2 and build from Ubuntu
   ```bash
   wsl --install
   # Then inside WSL:
   cd /mnt/c/Users/Joshua/Documents/phonedmrapp
   ./gradlew assembleDebug
   ```

2. **Option B**: Manually fix values XML files
   - Check for encoding issues (non-UTF-8, BOM)
   - Look for special characters in strings.xml
   - Check for malformed XML in values/ directories

3. **Option C**: Use online smali2java converter for key classes
   - Convert main classes from smali to Java
   - Gradually replace stub implementations

### AFTER BUILD SUCCEEDS:
4. Install APK to phone via ADB
   ```
   adb install app/build/outputs/apk/debug/app-debug.apk
   ```

5. Debug runtime on phone
   ```
   adb shell am start -n com.pri.prizeinterphone/.InterPhoneHomeActivity
   adb logcat | grep prizeinterphone
   ```

6. Fix crashes iteratively:
   - Missing permissions
   - Serial port access (requires root or system privileges)
   - Audio routing
   - Service lifecycle
   - DMR protocol initialization

7. Gradually convert smali to Java for all classes (use JADX GUI or online tool)

8. Test on actual DMR-capable phone with radio module

---

## WSL2 Build Environment Setup (COMPLETED)

### Environment Details:
- **OS**: WSL2 Ubuntu on Windows
- **Java**: OpenJDK 17.0.18
- **Android SDK**: ~/android-sdk (native Linux filesystem)
  - build-tools: 33.0.1
  - platforms: android-34
  - platform-tools: latest
- **Gradle**: 8.2 (wrapper)
- **Project Location**: ~/phonedmrapp (Linux filesystem, not /mnt/c)

### Why Linux Filesystem:
- Building on /mnt/c (Windows mount) causes "Operation not permitted" errors
- WSL has permission restrictions on Windows-mounted filesystems
- Native Linux filesystem (~/phonedmrapp) avoids these issues

### Build Attempts Summary:
1. **Windows build**: FAILED - AAPT2 path bug with colon characters
2. **WSL /mnt/c build**: FAILED - File permission errors on assets
3. **WSL ~/phonedmrapp build**: FAILED - Duplicate resource attributes (41 conflicts)
4. **After attrs.xml cleanup**: FAILED - 17 additional duplicate attributes found

## Recommended Next Step: JADX Java Decompilation

### Why JADX Instead of Resource Cleanup:
1. **Problem**: Decompiled APK resources contain 1000+ attribute definitions that conflict with AndroidX
2. **Current approach**: Manually removing duplicates one-by-one is not sustainable
3. **Better approach**: Use JADX to decompile APK to Java sources
   - Get actual Java code instead of stubs
   - Use only AndroidX standard resources
   - Create minimal custom resources only for app-specific items (e.g., progress bar attributes)
   - Avoid resource merge conflicts entirely

### JADX Workflow:
```bash
# Download JADX
wget https://github.com/skylot/jadx/releases/download/v1.4.7/jadx-1.4.7.zip
unzip jadx-1.4.7.zip -d jadx

# Decompile APK to Java
./jadx/bin/jadx -d decompiled-java originalapk/com.pri.prizeinterphone.apk

# Copy Java sources to project
cp -r decompiled-java/sources/com app/src/main/java/

# Keep only app-specific resources, delete framework/library resources
rm app/src/main/res/values/attrs.xml  # Delete, use AndroidX attributes
rm app/src/main/res/values/styles.xml # Recreate with only app themes
rm app/src/main/res/values/colors.xml # Recreate with only app colors
# Keep: strings.xml, arrays.xml, plurals.xml, layouts, drawables
```

## Questions for Next Session

1. Does the phone have a physical DMR radio module, or is it software-based?
2. What are the serial port device paths on the target phone?
3. Which Java classes are most critical to get working first (priority order)?
4. Is root access available on the target device (needed for serial port access)?

---

## Tools Used

- **apktool 2.12.1**: Decompilation (resources + smali)
- **JADX**: Attempted but download failed
- **Android Gradle Plugin 8.1.4**: Build system
- **Gradle 8.2**: Build automation
- **Git**: Version control (GitHub: IIMacGyverII/phonedmrapp)

---

## Commit History (Fresh Repo)

1. `8f34862` - "Fresh start: Reset repo with original APK only" (2026-02-17)
   - Wiped all previous history
   - Started with only originalapk/com.pri.prizeinterphone.apk

---

**Last Updated**: 2026-02-17  
**Current Blocker**: Decompiled resource XMLs conflict with AndroidX dependencies (1000+ duplicate attributes)  
**Recommended Solution**: Use JADX to decompile to Java sources, avoid resource conflicts entirely  
**Next Action**: Download JADX, decompile APK to Java, replace stubs with real code, rebuild with minimal custom resources
