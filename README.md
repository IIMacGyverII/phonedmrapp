# PriInterPhone DMR Radio - LSPosed Mod with OpenGD77 Integration + Real-time Transcription

**Status**: ✅ **FULLY FUNCTIONAL** - Export/Import + Real-time Speech-to-Text working!

> **📦 Current Stable Release: v1.6** - Recommended for all users  
> **🔬 Development Version: v3.0.1** - Experimental firmware fuzzing (for advanced users building from source)

## Demo

<video src="https://github.com/user-attachments/assets/d6305a49-c8ed-47dc-a9d8-7e731aa02811" controls title="DMRModHooks v1.1 Demo" width="800"></video>

## What is this?

LSPosed module for the Ulefone PriInterPhone DMR radio app that adds:
- **📤 OpenGD77 CSV Export** - Export all channels/contacts to OpenGD77-compatible CSV files
- **📥 OpenGD77 CSV Import** - Import OpenGD77 codeplugs directly into the app
- **🔄 Cross-platform programming** - Edit channels in OpenGD77 CPS, import to phone
- **🗂️ Easy access** - Backups saved to Download folder (easy file transfer)
- **⚡ Direct database access** - No shell commands, fast and reliable
- **🔒 No APK modification** - Works via runtime hooks (preserves platform signature)
- **🎙️ Real-time Transcription** - Live speech-to-text transcription powered by Google Cloud API
- **📝 Automatic Logging** - Daily transcription logs organized by channel with timestamps

## Current Status ✅

**Stable Release: v1.6** (Recommended)  
**Export**: ✅ Working - All 5 OpenGD77 CSV files + PDF summary  
**Import**: ✅ Working - Full Digital & Analog support  
**Transcription**: ✅ Working - Real-time speech-to-text with Google Cloud API  
**Audio Recording**: ✅ Working - Automatic WAV recording organized by channel  
**Per-Channel History**: ✅ Working - Transcription messages persist per channel  
**Timestamps**: ✅ Working - All messages include HH:mm:ss timestamps  
**User Validation**: ✅ Export/Import/Transcription tested and confirmed  
**Latest Build**: February 27, 2026

> **Note**: v3.0.1 is an experimental development branch for advanced users interested in firmware reverse engineering and command fuzzing. For normal use, stick with v1.6.

## Radio Firmware

The DMR radio module uses ARM Cortex-M firmware that handles all radio protocol operations. The original factory firmware is preserved in this repository for reference and patching experiments.

**Firmware Location**: `radio_firmware/`

- **DMR003.UV4T.V022-ORIGINAL.bin** - Factory firmware (378,620 bytes)
  - MD5: `4426035392262CA54583C230C9E268E0`
  - Base address: `0x08000000` (STM32/GD32 flash memory)
  - Architecture: ARM Cortex-M Thumb mode (mixed 16/32-bit instructions)
  - RTOS: uC/OS-III (Micrium)

**Testing Modified Firmware Safely**:

The app checks for custom firmware in `/sdcard/DMR/DMRDEBUG.bin` on startup. If found, it transfers this firmware to the radio module via YModem protocol (~2 minutes). This allows safe testing of modified firmware without permanent flashing.

```powershell
# Deploy custom firmware for testing
adb push modified_firmware.bin /sdcard/DMR/DMRDEBUG.bin

# Restart app to trigger firmware update
adb shell am force-stop com.macgyver.dmr

# Remove test firmware to restore original
adb shell rm /sdcard/DMR/DMRDEBUG.bin
```

**Current Firmware Reverse Engineering Status**: See [NOTES_FOR_GROK.md](NOTES_FOR_GROK.md) for ongoing work to fix the Monitor Mode (RECEIVE_ALL) group ID extraction bug.

### Quick Facts

- **Module**: com.dmrmod.hooks (LSPosed Xposed module)
- **Target App**: com.pri.prizeinterphone (Ulefone system app)
- **Transcription Service**: com.macdmr.transcription (Standalone AIDL service)
- **Device**: Ulefone Armor 26 Ultra (Android 13)
- **LSPosed**: v1.9.2 (Zygisk)
- **Current Version**: v1.6
- **Storage Location**: `Download/DMR/` (Audio, Transcription, DMR_Backups folders)

## Features

### ✅ Phase 1: Initial Hook Setup
- Startup toast: "✓ DMR Mod Hooks Active! v1.1"
- Custom version display on Device Information screen
- Confirms module is active and working
- Version tracking for future updates

### ✅ Phase 2: OpenGD77 CSV Export (v0.7.0 - v0.8.7)
- **Export all channels** to OpenGD77-compatible CSV format
- **5 CSV files generated**: Channels, Contacts, TG_Lists, Zones, DTMF
- Direct database access from hooked app context
- Perfect format matching (TAB-prefixed frequencies, CRLF line endings)
- **User validated**: Exported data successfully imports to OpenGD77 CPS
- **Round-trip tested**: Edit in app → Export → Import to OpenGD77 → Success!

### ✅ Phase 3: OpenGD77 CSV Import (v0.9.0 - v1.1)
- **Import channels** from OpenGD77 CSV files
- Direct database write with atomic transactions
- Handles mixed VHF/UHF channel lists
- **All channels import correctly** including both Digital (DMR) and Analog (FM)
- Correct field values for Digital vs Analog channel activation
- Backup selection dialog (supports any folder name in DMR/DMR_Backups/)
- Auto-refresh after import - no app restart needed
- Import confirmation with success/failure reporting
- Files stored in user-friendly Download folder

### ✅ Phase 4: Real-time Speech-to-Text Transcription (v1.2 - v1.6)
- **Live transcription** of all DMR audio transmissions
- **Google Cloud Speech-to-Text API** integration for accurate recognition
- **Automatic audio recording** - All transmissions saved as WAV files
- **Per-channel message history** - Each channel maintains its own scrollable message list
- **Channel switching memory** - Return to any channel and see previous messages (up to 10 messages per channel)
- **Timestamped messages** - Every transcription includes [HH:mm:ss] timestamp
- **Channel-organized storage**:
  - Audio recordings: `Download/DMR/Audio/[ChannelName]/`
  - Transcriptions: `Download/DMR/Transcription/[ChannelName]/`
- **Daily transcription logs** - Running log files with timestamps and DMR IDs
- **Format**: `[14:30:22] ID: 123456 - Transcribed text here`
- **Scrollable UI** - Message list grows dynamically with height cap at 100dp
- **Network resilience** - Connectivity checking and comprehensive error handling
- **Secure API key** - Stored in gitignored local.properties file
- **Cost**: First 60 minutes/month FREE, then $0.006 per 15 seconds
- **Status**: ✅ Successfully transcribing real DMR audio in production

## Why LSPosed?

The PriInterPhone app requires Ulefone's platform certificate to access:
- System UID (1000) for hardware permissions
- Custom `PrizeTinyService` framework APIs
- DMR radio module on `/dev/ttyS1`

**Traditional APK modification fails** because:
- ❌ Re-signing breaks platform signature verification
- ❌ System app placement alone doesn't grant platform UID
- ❌ Cannot obtain Ulefone's proprietary platform certificate

**LSPosed hooks the original properly-signed app** at runtime:
- ✅ Preserves platform signature and system UID
- ✅ Full access to all system APIs
- ✅ Can modify behavior without touching APK
- ✅ Reversible and update-safe

See [DMRModHooks/README.md](DMRModHooks/README.md) for complete LSPosed implementation details.

## Installation Instructions

### Requirements
- Ulefone Armor 26 Ultra (or compatible device with PriInterPhone)
  - **Root guide**: [XDA Forum - Armor 26 Ultra Root & Development](https://xdaforums.com/t/ulefone-armor-26-ultra-walkie-talkie-info-guides-development.4677740/)
  - **Note**: Check the XDA thread for the latest root procedure specific to your ROM version
  - **Tested on**: Build number `Armor 26 Ultra_AF1_v15`
- Unlocked bootloader
- Magisk v24+ with Zygisk enabled
- LSPosed v1.9.2+ (Zygisk variant)
- [ADB tools](https://developer.android.com/tools/releases/platform-tools) (for installation and verification)

### Step 1: Install LSPosed Framework

1. **Install Magisk** (if not already installed)
   - Download from: https://github.com/topjohnwu/Magisk
   - Enable Zygisk in Magisk settings
   - Reboot device

2. **Install LSPosed Module**
   - Download: https://github.com/LSPosed/LSPosed/releases
   - Get: `LSPosed-v1.9.2-zygisk-release.zip`
   - Install via Magisk → Modules → Install from storage
   - Reboot device
   - LSPosed Manager app will appear automatically

### Step 2: Install DMRModHooks Module & Transcription Service

#### Option A: Download Pre-built Release (✅ Recommended for All Users)

**Use v1.6 stable release for production use. Only use newer versions if you want to experiment with development features.**

1. **Download Latest Stable Release**:
   - Go to [Releases](https://github.com/IIMacGyverII/phonedmrapp/releases/latest)
   - Download `DMRModHooks-v1.6.apk` (**recommended stable version**)
   - Download `DMRTranscriptionService-v1.0.apk`

2. **Install Both APKs**:
   ```powershell
   adb install -r DMRModHooks-v1.6.apk
   adb install -r DMRTranscriptionService-v1.0.apk
   ```

#### Option B: Build from Source (For Developers & Experimenters)

**Building from source gives you access to experimental features and development branches. The main branch contains v1.6 stable. Development work (v3.0.1+) includes firmware reverse engineering and command fuzzing capabilities.**

1. **Build Both APKs**:
   ```powershell
   # Build DMRModHooks
   cd DMRModHooks
   .\gradlew.bat assembleDebug
   
   # Build TranscriptionService
   cd ..\DMRTranscriptionService
   .\gradlew.bat assembleDebug
   ```

2. **Install Both Modules**:
   ```powershell
   adb install -r DMRModHooks\app\build\outputs\apk\debug\app-debug.apk
   adb install -r DMRTranscriptionService\app\build\outputs\apk\debug\app-debug.apk
   ```

#### Enable in LSPosed Manager

3. **Activate Module**:
   - Open LSPosed Manager app on device
   - Go to "Modules" tab
   - Enable "DMR Mod Hooks" checkbox
   - Tap "DMR Mod Hooks" → Application scope
   - Verify `com.pri.prizeinterphone` is selected
   - **Important**: Do NOT add `com.macdmr.transcription` to LSPosed scope (it works standalone)
   - Reboot device

### Step 3: Configure Google Cloud API (for Transcription)

1. **Get API Key**:
   - Visit https://console.cloud.google.com
   - Create a project (or use existing)
   - Enable "Cloud Speech-to-Text API" (free to enable)
   - Go to "APIs & Services" → "Credentials"
   - Click "Create Credentials" → "API Key"
   - Copy the key (starts with `AIza...`)

2. **Configure Transcription Service**:
   - Copy `DMRTranscriptionService/local.properties.template` to `local.properties`
   - Edit `local.properties` and replace `YOUR_API_KEY_HERE` with your actual API key
   - Rebuild and reinstall TranscriptionService APK
   - **Note**: The API key is gitignored for security

3. **Pricing**:
   - First 60 minutes/month: **FREE**
   - After free tier: $0.006 per 15 seconds (~$0.002 per 5-second transmission)
   - Very affordable for typical DMR usage

### Step 4: Test Installation

1. **Verify Module is Active**:
   - Open PriInterPhone app
   - You should see toast: "✓ DMR Mod Hooks Active! v1.6"

2. **Test Export**:
   - Go to LOCAL tab
   - Tap 📤 **EXPORT (OpenGD77)** button  
   - Check `Download/DMR/DMR_Backups/` for CSV files (use any file manager)
   - Should see: Channels, Contacts, TG_Lists, Zones, DTMF CSVs with timestamps

3. **Test Import** (optional):
   - Tap 📥 **IMPORT (OpenGD77)** button
   - Select a backup timestamp from list
   - Confirm import
   - Wait for success message
   - Channels will auto-refresh and appear in app

4. **Test Transcription**:
   - Go to Settings → Enable **TXT** (text display)
   - Send or receive a DMR transmission with speech
   - Transcription appears in real-time below the channel info
   - Check `Download/DMR/Audio/[ChannelName]/` for WAV recordings
   - Check `Download/DMR/Transcription/[ChannelName]/transcription_YYYYMMDD.txt` for logs

## Usage

### Exporting Channels to OpenGD77

1. Open PriInterPhone app
2. Go to **LOCAL** tab
3. Tap **📤 EXPORT (OpenGD77)** button
4. Export completes (toast shows: "✓ Export successful! v1.1\nCheck Download/DMR/DMR_Backups/")
5. Files created in `Download/DMR/DMR_Backups/20260223_140530/` folder containing:
   - Channels.csv, Contacts.csv, TG_Lists.csv, Zones.csv, DTMF.csv
6. Transfer CSVs to PC via USB, file manager, or `adb pull /sdcard/Download/DMR/ .`
7. Open OpenGD77 CPS
8. Import → Select the folder containing all 5 CSV files
9. Program your OpenGD77 radio!

### Importing Channels from OpenGD77

1. Export channel programming from OpenGD77 CPS (all 5 CSV files)
2. Transfer CSVs to Android device `Download/DMR/DMR_Backups/`
   - Create a folder with any name (e.g., `MyBackup`, `Test`, or timestamp like `20260223_140530`)
   - Place the CSV files inside (OpenGD77 exports them as: `Channels.csv`, `Contacts.csv`, `TG_Lists.csv`, `Zones.csv`, `DTMF.csv`)
   - Via USB cable (MTP mode) or `adb push`
4. Open PriInterPhone app
5. Go to **LOCAL** tab
6. Tap **📥 IMPORT (OpenGD77)** button
7. Select backup folder from dialog (timestamp folders display as formatted dates)
8. Wait for import success notification
9. Channels auto-refresh - ready to use!

### Using Real-time Transcription

1. **Enable Transcription**:
   - Open PriInterPhone app
   - Go to Settings
   - Enable **TXT** (text display)
   - Transcription service automatically starts

2. **During Transmissions**:
   - Real-time transcription appears below channel info
   - Audio automatically recorded to `Download/DMR/Audio/[ChannelName]/`
   - Transcription appended to `Download/DMR/Transcription/[ChannelName]/transcription_YYYYMMDD.txt`

3. **File Organization**:
   ```
   Download/DMR/
     Audio/
       Channel_1/
         20260227_143022_CallSign_Name.wav
         20260227_143155_CallSign_Name.wav
       Repeater_2/
         20260227_150330_CallSign_Name.wav
     Transcription/
       Channel_1/
         transcription_20260227.txt
         transcription_20260228.txt
       Repeater_2/
         transcription_20260227.txt
   ```

4. **Transcription Log Format**:
   ```
   [14:30:22] ID: 123456 - This is the first transmission
   [14:31:55] ID: 789012 - Second transmission from different user
   [14:35:10] ID: 123456 - Another message
   ```

5. **Disable Transcription**:
   - Go to Settings → Disable **TXT**
   - Transcription service stops
   - Audio recordings will continue if recording is enabled separately

## Project Structure

```
phonedmrapp/
├── originalapk/
│   └── com.pri.prizeinterphone.apk    # Original system APK (8.1 MB)
├── app/                                # Android Gradle project
│   ├── src/main/
│   │   ├── java/                       # 280 Java source files (JADX decompiled)
│   │   │   └── com/pri/prizeinterphone/
│   │   │       ├── InterPhoneHomeActivity.java  (Main UI - 567 lines)
│   │   │       ├── manager/
│   │   │       │   ├── DmrManager.java          (DMR control)
│   │   │       │   ├── SerialPort.java          (UART /dev/ttyS1)
│   │   │       │   └── CmdStateMachine.java     (Protocol)
│   │   │       └── ... (all DMR implementation)
│   │   ├── res/
│   │   │   ├── drawable-*/interphone_app_icon.png  (Custom icon, 5 densities)
│   │   │   └── values/strings.xml                   (MacDMRUlephone name)
│   │   └── AndroidManifest.xml
│   └── build.gradle                    # Package: com.pri.prizeinterphone
├── DMRModHooks/                        # LSPosed Xposed Module
│   ├── app/src/main/java/com/dmrmod/hooks/
│   │   ├── MainHook.java              # Main hook implementation (3300+ lines)
│   │   ├── DirectDatabaseExporter.java # OpenGD77 CSV export
│   │   ├── CSVExporter.java           # CSV file generation
│   │   └── DirectDatabaseImporter.java # OpenGD77 CSV import
│   ├── build.gradle
│   └── README.md                       # Module documentation
├── DMRTranscriptionService/            # Speech-to-Text Service
│   ├── app/src/main/
│   │   ├── java/com/macdmr/transcription/
│   │   │   └── TranscriptionService.java  # Google Cloud API integration
│   │   ├── aidl/com/macdmr/transcription/
│   │   │   └── ITranscriptionService.aidl # Service interface
│   │   └── AndroidManifest.xml
│   ├── local.properties               # API key (gitignored)
│   ├── local.properties.template      # Template for setup
│   └── build.gradle
├── magisk_module/
│   └── MacDMRUlephone/
│       ├── module.prop                 # Module metadata
│       ├── install.sh                  # Installation script
│       └── system/priv-app/PriInterPhone/
│           └── PriInterPhone.apk       # Custom APK (7.99 MB)
├── MacDMRUlephone-Magisk.zip          # Packaged module (6.65 MB)
├── icon.jpg                            # Custom icon source (784x1168)
├── MAGISK_SOLUTION.md                  # Magisk implementation guide
├── STATUS.md                           # Complete development timeline
├── QUICK_REFERENCE.md                  # ADB commands & debugging
└── README.md                           # This file
```

## Development Timeline

### ✅ Phase 1: Decompilation & Build
- Decompiled original APK with JADX → 280 Java source files (complete DMR stack)
- Created Android Gradle project (WSL2, Java 17, Gradle 8.2, AGP 7.4.2)
- Fixed 15+ compilation errors
- Created 10 stub classes for missing ROM APIs
- Resolved 58+ AndroidX resource attribute duplicates
- Built working APK

### ✅ Phase 2: Custom Branding
- Custom app name: MacDMRUlephone
- Custom icon from icon.jpg (all 5 Android densities)
- Package initially rebranded to `.modded` for side-by-side testing
- Resolved 5 manifest conflicts
- Fixed 4 system API compatibility issues

### ✅ Phase 3: GitHub Repository
- Created repository: https://github.com/IIMacGyverII/phonedmrapp
- Removed large files (gradle-8.2-bin.zip, jadx.zip - 197 MB)
- Pushed commit 5456fcac (16,278 files)
- Comprehensive documentation created

### ✅ Phase 4: DMR Hardware Investigation
- **Problem Discovered**: App stuck on "Module Initializing..." dialog
- **Root Cause**: Permission mismatch
  - Original app: userId=1000 (system)
  - Modded app: userId=10198 (user) - NO hardware access
- **Hardware Identified**: DMR module on `/dev/ttyS1` (system:radio permissions)
- **File Sync Issue**: Only 13 Java files in Windows vs 280 in WSL
- **Solution**: Robocopy synced all 280 files (2.36 MB)
- **Rebuild**: APK now contains complete DMR implementation

### ✅ Phase 5: System Access Solution
- **Attempted**: Direct system installation → Failed (production ROM locked)
- **Attempted**: Platform signing → Not viable (no manufacturer key)
- **Solution Found**: Magisk systemless overlay
- **Implementation**: Created Magisk module
  - Reverted package to `com.pri.prizeinterphone`
  - Built APK with custom branding
  - Packaged as Magisk module (6.65 MB)
  - Transferred to device: `/sdcard/Download/MacDMRUlephone-Magisk.zip`

### ⏳ Phase 6: Deployment (Pending User Action)
- Module ready for installation via Magisk Manager
- Awaiting user to install and reboot
- Will enable full DMR hardware access with custom branding

### ✅ Phase 7: Real-time Speech-to-Text Transcription (v1.2 - v1.5)
- **Problem**: Need speech-to-text for DMR transmissions
- **Attempted**: ONNX Whisper Base model → Failed (decoder token 0 issue, 155 MB removed)
- **Attempted**: Android SpeechRecognizer API → Failed (device blocks third-party access, error 10)
- **Attempted**: LSPosed hooks to bypass restrictions → Failed (system blocks at validation layer below hooks)
- **Solution Found**: Google Cloud Speech-to-Text API (bypasses all device restrictions)
- **Implementation**:
  - Created standalone TranscriptionService APK with AIDL interface
  - Integrated OkHttp for HTTP requests with 30-second timeouts
  - PCM to WAV conversion with proper 44-byte header
  - Base64 encoding for Google Cloud API
  - JSON request/response handling with error recovery
  - Network connectivity checking
  - Secured API key in gitignored local.properties
- **File Organization**:
  - Audio recordings organized by channel: `Download/DMR/Audio/[ChannelName]/`
  - Daily transcription logs by channel: `Download/DMR/Transcription/[ChannelName]/transcription_YYYYMMDD.txt`
  - Running log format: `[HH:MM:SS] ID: DMRID - Transcription text`
- **Status**: ✅ Successfully transcribing real DMR audio in production

## Technical Details

### Build Environment
- **Platform**: WSL2 Ubuntu 22.04 + Windows 11
- **Java**: OpenJDK 17.0.18
- **Android SDK**: compileSdk 34, minSdk 24, targetSdk 34
- **Gradle**: 8.2, AGP 7.4.2/8.1.0
- **Tools**: JADX 1.4.7, ImageMagick, ADB
- **Device**: 5006AF1020002922 (production ROM, Magisk installed)

### Transcription Architecture
- **Service**: Standalone AIDL service (com.macdmr.transcription)
- **API**: Google Cloud Speech-to-Text v1
- **HTTP Client**: OkHttp 4.12.0 with 30-second timeouts
- **Audio Format**: PCM 16-bit mono → WAV with proper header → Base64
- **Network**: Connectivity checking with ACCESS_NETWORK_STATE permission
- **Security**: API key in gitignored local.properties, injected via BuildConfig
- **Error Handling**: Comprehensive logging, network error recovery, API error detection
- **Storage**: Channel-organized folders for audio and transcription logs

### System API Fixes Implemented
1. **Background Service Restriction**: Disabled auto-start from Application.onCreate()
2. **WindowManager API**: Stubbed setDefaultDisplay() (system-only API)
3. **NVRAM Access**: Created stub for vendor-specific NvramUtils
4. **PCM Audio Manager**: Wrapped vendor-specific callbacks in try-catch

### DMR Implementation
- **Serial Port**: `/dev/ttyS1` (115200 baud, binary protocol)
- **Core Classes**: DmrManager, SerialPort, CmdStateMachine, PCMReceiveManager
- **Protocol Stack**: Complete implementation (280 Java files, ~45,000 lines)
- **Audio Pipeline**: Recording, codec, playback
- **Features**: Talkback, channels, contacts, messaging, settings

## Documentation

- **[MAGISK_SOLUTION.md](MAGISK_SOLUTION.md)**: Complete Magisk module guide with troubleshooting
- **[STATUS.md](STATUS.md)**: Full development timeline and technical achievements
- **[SUCCESS_REPORT.md](SUCCESS_REPORT.md)**: Initial build success documentation
- **[QUICK_REFERENCE.md](QUICK_REFERENCE.md)**: ADB commands and debugging tips
- **[JADX_DECOMPILATION_ERRORS.md](JADX_DECOMPILATION_ERRORS.md)**: Known JADX limitations

## GitHub Repository

**Repository**: https://github.com/IIMacGyverII/phonedmrapp  
**Latest Commit**: 5456fcac  
**Total Files**: 16,278 files committed  
**Status**: All source code available online

## Next Steps

1. **User Action Required**: Install Magisk module on device and reboot
2. **Testing**: Verify DMR hardware initialization and radio functionality
3. **Documentation**: Update with test results and user guide

## Future Plans

### Enhanced Transcription Features
- **Multi-language support**: Configure language per-channel
- **Custom vocabulary**: Add DMR-specific terms and callsigns
- **Offline transcription**: Explore local models for privacy/cost reduction
- **Voice commands**: Control radio functions via speech recognition

### Expanded DMR Functionality
- **Real-time Contact Display**: Enhanced live DMR contact receive display
- **Enhanced UI Integration**: Improved display of current DMR contact name, ID, and call status
- **Call logging**: Track incoming/outgoing DMR calls with detailed timestamps and durations
- **Statistics dashboard**: Visualize usage patterns and contact activity

### Tier 2 Support
- **Attempt Tier 2 Implementation**: Investigate and implement advanced DMR Tier 2 features
- **Enhanced talkgroup support**: Multi-talkgroup scanning and monitoring
- **IP connectivity**: Explore DMR network connectivity options

### Global DMR Database Integration
- **RadioID.net Integration**: Add ability to download and sync global DMR contact database
- **Automatic Updates**: Periodic contact database refresh from radioid.net
- **Smart Contact Resolution**: Automatically resolve DMR IDs to callsigns and names
- **Offline Database**: Local caching for fast lookups without internet connection

### The Sky's the Limit
With LSPosed runtime hooks and full access to the platform-signed app, **anything is possible**:
- Custom UI themes and branding
- Advanced automation and scripting
- Integration with external services and APIs
- Community-driven feature development
- Enhanced radio control and monitoring

**Last Updated**: February 28, 2026  
**Stable Version**: v1.6 (Recommended for all users)  
**Development Version**: v3.0.1 (Experimental firmware fuzzing - optional)  
**Status**: LSPosed module fully operational - OpenGD77 export/import + Real-time transcription working perfectly!  
**GitHub**: https://github.com/IIMacGyverII/phonedmrapp

For detailed technical information, see [MAGISK_SOLUTION.md](MAGISK_SOLUTION.md) and [STATUS.md](STATUS.md).

## License

This project is licensed under the **GNU General Public License v3.0** - see the [LICENSE](LICENSE) file for details.

> **Disclaimer**: This tool hooks into the PriInterPhone app at runtime using LSPosed/Xposed. It does NOT modify or redistribute any proprietary code from Ulefone. Users must legally own the PriInterPhone app. For personal, educational, and interoperability purposes only.

