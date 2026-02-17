# PrizeInterphone DMR App - Reverse Engineering Project

🚧 **Status**: Project setup complete, BLOCKED on Windows AAPT2 build issue

## What is this?

This is a reverse-engineered Android app for a Digital Mobile Radio (DMR) system that was originally baked into an Android ROM. The app communicates with a hardware DMR radio module via serial port to provide push-to-talk (PTT) radio functionality.

## Original APK

- **File**: `originalapk/com.pri.prizeinterphone.apk`
- **Package**: `com.pri.prizeinterphone`  
- **Type**: System app (runs as android.uid.system)
- **Features**: DMR radio control, PTT, contacts, messaging, firmware updates

## Project Structure

```
phonedmrapp/
├── originalapk/                    # Original APK from ROM
│   └── com.pri.prizeinterphone.apk
├── decompiled/                     # Apktool output (smali code + resources)
│   ├── AndroidManifest.xml
│   ├── res/                        # All app resources
│   ├── assets/                     # App assets
│   ├── smali_classes4/             # App source code (in smali bytecode)
│   │   └── com/pri/prizeinterphone/
│   └── ...
├── app/                            # Standard Android Gradle project
│   ├── src/main/
│   │   ├── java/com/pri/prizeinterphone/  # Stub Java classes (to be filled in)
│   │   ├── res/                    # Resources from decompiled APK
│   │   ├── assets/                 # Assets from decompiled APK
│   │   └── AndroidManifest.xml
│   └── build.gradle
├── build.gradle                    # Root build config
├── settings.gradle                 # Gradle project settings
├── NOTES_FOR_GROK.md              # Detailed progress notes
└── README.md                       # This file
```

## Current Status

### ✅ Completed

1. **Repo Reset**: Force-wiped GitHub repo and started fresh
2. **Decompilation**: Successfully decompiled APK with apktool 2.12.1
3. **Project Setup**: Created standard Android Gradle project structure
   - AGP 7.4.2 (downgraded from 8.1.4 to try to fix Windows issue)
   - Gradle 8.2
   - AndroidX dependencies configured
4. **Resource Cleanup**:
   - Fixed invalid resource file names (removed "$" prefix from 7 files)
   - Removed duplicate library resources (AppCompat, Material Design)
   - Removed public.xml
5. **Stub Classes**: Created minimal Java implementations for:
   - `PrizeInterPhoneApp` (Application)
   - `InterPhoneHomeActivity` (Main activity)
   - `InterPhoneService` (DMR service)

### 🚧 Blocked

**Build fails on Windows** with:
```
java.nio.file.InvalidPathException: Illegal char <:> at index 50: 
com.pri.prizeinterphone.app-mergeDebugResources-32:/values/values.xml
```

This is a **known Windows AAPT2 bug** in Android Gradle Plugin.

### 🎯 Next Steps

**OPTION 1: Build on Linux/WSL2** (RECOMMENDED)
```bash
# Install WSL2 on Windows
wsl --install

# Inside WSL Ubuntu:
cd /mnt/c/Users/Joshua/Documents/phonedmrapp
./gradlew assembleDebug
```

**OPTION 2: Use Docker**
```bash
docker run --rm -v "C:\Users\Joshua\Documents\phonedmrapp:/work" -w /work mingc/android-build-box ./gradlew assembleDebug
```

**OPTION 3: Use GitHub Actions**
Create `.github/workflows/build.yml` to build in the cloud

**OPTION 4: Use Android Studio**
Open project in Android Studio and build from there (may work around the issue)

## How to Build (Once AAPT2 Issue Resolved)

```bash
# Install dependencies (first time only)
./gradlew --refresh-dependencies

# Build debug APK
./gradlew assembleDebug

# Output will be at:
# app/build/outputs/apk/debug/app-debug.apk
```

## How to Install & Debug

```bash
# Install to phone (USB debugging enabled)
adb install app/build/outputs/apk/debug/app-debug.apk

# Launch app
adb shell am start -n com.pri.prizeinterphone/.InterPhoneHomeActivity

# View logs
adb logcat | grep prizeinterphone
```

## App Architecture (from Smali Analysis)

### Key Components

- **Main Activity**: `InterPhoneHomeActivity`
  - ViewPager with 5 tabs: Talkback, Channel, Contacts, Message, Local
- **Background Service**: `InterPhoneService`
  - Persistent service for DMR radio control
  - Serial port communication
  - Audio routing
- **Firmware Updates**: `UpdateFirmwareActivity`
  - YMODEM protocol for flashing DMR module firmware

### Major Features

1. **Serial Communication**: Direct UART/serial port to DMR radio module
2. **DMR Protocol Stack**: Full implementation (encoding/decoding)
3. **Audio Pipeline**: Recording → Encoding → Transmission, Reception → Decoding → Playback
4. **Contact Management**: Store and manage DMR contacts (ID, name, etc.)
5. **Channel Management**: Frequency, timeslot, color code configuration
6. **Text Messaging**: DMR short message service
7. **PTT Control**: Push-to-talk button handling
8. **System Integration**: Runs with system privileges

### Package Structure

```
com.pri.prizeinterphone/
├── activity/          # All activities (14+ activities)
├── fragment/          # UI fragments for tabs
├── audio/             # Audio recording/playback
├── codec/             # DMR codec (AMBE/AMBE+)
├── config/            # Configuration management
├── data/              # Data models
├── manager/           # Managers (contacts, channels, audio, etc.)
├── message/           # DMR messaging
├── protocol/          # DMR protocol implementation
├── serial/            # Serial port communication
├── talkbak/           # PTT control
├── ymodem/            # Firmware update protocol
└── ...
```

## Known Issues

1. **Windows AAPT2 Bug**: Cannot build on Windows (see Blocked section above)
2. **Missing Java Sources**: Only smali bytecode available
   - Need to convert smali → Java (JADX failed to download)
   - Current stub classes are minimal placeholders
3. **System Privileges**: App needs system UID to access serial port
   - Will need to be installed as system app or run on rooted device
4. **Hardware Dependency**: Requires DMR radio module connected to phone

## What's Next?

1. **Get build working** (see Next Steps above)
2. **Convert smali to Java**: Use JADX GUI or online converters to decompile smali classes
3. **Implement core functionality**:
   - Serial port communication
   - DMR protocol handler
   - Audio pipeline
   - UI interactions
4. **Test on phone**: Install and debug on actual hardware
5. **Document hardware requirements**: Serial port paths, DMR module specs

## Resources

- **Detailed Notes**: See [NOTES_FOR_GROK.md](NOTES_FOR_GROK.md)
- **Build Logs**: `build_log.txt` (generated during build)
- **Original APK**: `originalapk/com.pri.prizeinterphone.apk`
- **Decompiled Code**: `decompiled/smali_classes4/com/pri/prizeinterphone/`

## Tools Used

- **apktool 2.12.1**: APK decompilation (resources + smali)
- **Android Gradle Plugin 7.4.2**: Build system
- **Gradle 8.2**: Build automation
- **Git**: Version control

## Contact / Questions

This is a reverse engineering project. The original app is a proprietary system app from a custom Android ROM.

---

**Last Updated**: 2026-02-17  
**Status**: Ready for build on Linux/WSL2
