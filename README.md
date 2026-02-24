# PriInterPhone DMR Radio - LSPosed Mod with OpenGD77 Integration

**Status**: ✅ **FULLY FUNCTIONAL** - Export/Import working!

## What is this?

LSPosed module for the Ulefone PriInterPhone DMR radio app that adds:
- **📤 OpenGD77 CSV Export** - Export all channels/contacts to OpenGD77-compatible CSV files
- **📥 OpenGD77 CSV Import** - Import OpenGD77 codeplugs directly into the app
- **🔄 Cross-platform programming** - Edit channels in OpenGD77 CPS, import to phone
- **🗂️ Easy access** - Backups saved to Download folder (easy file transfer)
- **⚡ Direct database access** - No shell commands, fast and reliable
- **🔒 No APK modification** - Works via runtime hooks (preserves platform signature)

## Current Status ✅

**Module Version**: v1.1  
**Export**: ✅ Working - All 5 OpenGD77 CSV files + PDF summary  
**Import**: ✅ Working - Full Digital & Analog support  
**User Validation**: ✅ Export/Import tested and confirmed  
**Latest Build**: February 24, 2026

### Quick Facts

- **Module**: com.dmrmod.hooks (LSPosed Xposed module)
- **Target App**: com.pri.prizeinterphone (Ulefone system app)
- **Device**: Ulefone Armor 26 Ultra (Android 13)
- **LSPosed**: v1.9.2 (Zygisk)
- **Current Version**: v1.1
- **Backup Location**: `Download/DMR_Backups/` (standard Android Downloads folder)

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
- Backup selection dialog (supports any folder name in DMR_Backups/)
- Auto-refresh after import - no app restart needed
- Import confirmation with success/failure reporting
- Files stored in user-friendly Download folder

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
- Unlocked bootloader
- Magisk v24+ with Zygisk enabled
- LSPosed v1.9.2+ (Zygisk variant)
- ADB tools (for installation and verification)

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

### Step 2: Install DMRModHooks Module

1. **Build or Download**:
   ```powershell
   cd DMRModHooks
   .\gradlew.bat assembleDebug
   ```
   Or download from [releases](releases/)

2. **Install Module**:
   ```powershell
   adb install -r app\build\outputs\apk\debug\app-debug.apk
   ```

3. **Enable in LSPosed Manager**:
   - Open LSPosed Manager app on device
   - Go to "Modules" tab
   - Enable "DMR Mod Hooks" checkbox
   - Tap "DMR Mod Hooks" → Application scope
   - Verify `com.pri.prizeinterphone` is selected
   - Reboot device

### Step 3: Test Installation

1. **Check MacGyver Branding**:
   - Open PriInterPhone app
   - You should see toast: "✓ DMR Mod Hooks Active!"
   - Go to Settings → Device Information
   - Look for MacGyver version text

2. **Test Export**:
   - Go to LOCAL tab
   - Tap � **EXPORT (OpenGD77)** button  
   - Check `Download/DMR_Backups/` for CSV files (use any file manager)
   - Should see: Channels, Contacts, TG_Lists, Zones, DTMF CSVs with timestamps

3. **Test Import** (optional):
   - Tap 📥 **IMPORT (OpenGD77)** button
   - Select a backup timestamp from list
   - Confirm import
   - Wait for success message
   - Channels will auto-refresh and appear in app

## Usage

### Exporting Channels to OpenGD77

1. Open PriInterPhone app
2. Go to **LOCAL** tab
3. Tap **📤 EXPORT (OpenGD77)** button
4. Export completes (toast shows: "✓ Export successful! v1.1\nCheck Download/DMR_Backups/")
5. Files created in `Download/DMR_Backups/20260223_140530/` folder containing:
   - Channels.csv, Contacts.csv, TG_Lists.csv, Zones.csv, DTMF.csv
6. Transfer CSVs to PC via USB, file manager, or `adb pull /sdcard/Download/DMR_Backups/ .`
7. Open OpenGD77 CPS
8. Import → Select all 5 CSV files
9. Program your OpenGD77 radio!

### Importing Channels from OpenGD77

1. Export channel programming from OpenGD77 CPS (all 5 CSV files)
2. Transfer CSVs to Android device `Download/DMR_Backups/`
   - Create a folder with any name (e.g., `MyBackup`, `Test`, or timestamp like `20260223_140530`)
   - Place all 5 CSV files inside with simple names: `Channels.csv`, `Contacts.csv`, etc.
   - Via USB cable (MTP mode) or `adb push`
4. Open PriInterPhone app
5. Go to **LOCAL** tab
6. Tap **📥 IMPORT (OpenGD77)** button
7. Select backup folder from dialog (timestamp folders display as formatted dates)
8. Wait for import success notification
9. Channels auto-refresh - ready to use!

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

## Technical Details

### Build Environment
- **Platform**: WSL2 Ubuntu 22.04 + Windows 11
- **Java**: OpenJDK 17.0.18
- **Android SDK**: compileSdk 34, minSdk 24, targetSdk 34
- **Gradle**: 8.2, AGP 7.4.2
- **Tools**: JADX 1.4.7, ImageMagick, ADB
- **Device**: 5006AF1020002922 (production ROM, Magisk installed)

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

### Expanded DMR Functionality
- **Real-time Contact Display**: Add live DMR contact receive display showing incoming caller information
- **Enhanced UI Integration**: Display current DMR contact name, ID, and call status in real-time
- **Call logging**: Track incoming/outgoing DMR calls with timestamps

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

**Last Updated**: February 24, 2026  
**Status**: LSPosed module fully operational - OpenGD77 export/import working perfectly!  
**GitHub**: https://github.com/IIMacGyverII/phonedmrapp

For detailed technical information, see [MAGISK_SOLUTION.md](MAGISK_SOLUTION.md) and [STATUS.md](STATUS.md).

