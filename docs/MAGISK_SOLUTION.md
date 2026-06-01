# DMR Hardware Access via Magisk Module

## Problem Overview

The MacDMRUlephone app was successfully built and installed, but failed to initialize the DMR radio module. The app would hang on a "Module Initializing..." dialog that never dismissed.

## Root Cause Analysis

### Hardware Requirements

The device has an integrated DMR (Digital Mobile Radio) module connected to the serial port:
- **Serial Port**: `/dev/ttyS1`
- **Permissions**: `crw-rw---- system:radio` (owner: system, group: radio)
- **Access Requirements**: App must run with system UID (1000) or be member of radio group

### Permission Mismatch Discovered

```bash
# Original system app
$ adb shell dumpsys package com.pri.prizeinterphone | grep userId
userId=1000
sharedUserId=android.uid.system

# Modded app (initial version)
$ adb shell dumpsys package com.pri.prizeinterphone.modded | grep userId
userId=10198  # Regular user app - NO hardware access
```

**Critical Finding**: The modded app runs as a regular user app (UID 10198) while the original runs as a system app (UID 1000). This prevents access to `/dev/ttyS1`, blocking DMR initialization.

### Failed Solutions Attempted

1. **File Permission Changes**
   ```bash
   adb shell su -c 'chmod 666 /dev/ttyS1'
   ```
   ❌ Failed: App needs system UID, not just file permissions

2. **Direct System App Installation**
   ```bash
   adb root
   adb remount
   adb push MacDMRUlephone.apk /system/priv-app/
   ```
   ❌ Failed: Production ROM with locked bootloader
   - Error: "adbd cannot run as root in production builds"
   - Error: "Read-only file system"

3. **Platform Signing**
   - Requirement: Apps with `android:sharedUserId="android.uid.system"` must be signed with platform certificate
   - ❌ Not viable: Platform signing key is manufacturer proprietary, never distributed

## The Solution: Magisk Module

### Why Magisk?

Magisk provides **systemless root** - it modifies the runtime environment without touching the `/system` partition. This allows:
- ✅ Overlaying custom files over system paths
- ✅ No permanent system modifications
- ✅ Survives OTA updates (may need module reinstall)
- ✅ Toggleable in Magisk Manager
- ✅ No platform signing key required

### How It Works

Magisk's module system uses **mount magic** to overlay files:

1. **Module Structure**:
   ```
   MacDMRUlephone/
   ├── module.prop          # Module metadata
   ├── install.sh           # Installation script
   └── system/priv-app/PriInterPhone/
       └── PriInterPhone.apk  # Custom APK (replaces original)
   ```

2. **Installation Process**:
   - User installs module via Magisk Manager
   - Magisk copies files to `/data/adb/modules/macdmrulephone/`
   - On boot, Magisk creates temporary filesystem overlays
   - `/system/priv-app/PriInterPhone/PriInterPhone.apk` → Custom APK
   
3. **Runtime Behavior**:
   - Android sees original package: `com.pri.prizeinterphone`
   - Package Manager assigns system UID: 1000
   - App inherits system privileges from original platform signature
   - Custom APK loads with full hardware access
   - DMR module on `/dev/ttyS1` becomes accessible

### Package ID Reversion

**Critical Change**: Reverted package ID to match original

```gradle
// Before (initial modded version)
applicationId "com.pri.prizeinterphone.modded"
versionCode 34
versionName "2.0-modded"

// After (for Magisk module)
applicationId "com.pri.prizeinterphone"  // MUST match original
versionCode 35
versionName "2.0-MacDMR"
```

**Why**: The package ID must match the original system app's ID for the overlay to work. Android uses the package ID to look up the app in the system, and Magisk intercepts that lookup to redirect to the custom APK.

## Module Creation Process

### 1. Build APK with Original Package ID

```bash
# Modified app/build.gradle
applicationId "com.pri.prizeinterphone"

# Clean build
./gradlew clean assembleDebug

# Result: app-debug.apk (7.99 MB)
```

### 2. Create Module Structure

```powershell
# Create directories
New-Item -ItemType Directory -Force MacDMRUlephone/system/priv-app/PriInterPhone

# Copy APK
Copy-Item app/build/outputs/apk/debug/app-debug.apk MacDMRUlephone/system/priv-app/PriInterPhone/PriInterPhone.apk
```

### 3. Create module.prop

```ini
id=macdmrulephone
name=MacDMRUlephone System App
version=1.0
versionCode=1
author=Joshua MacDMR
description=Replaces PriInterPhone system app with custom branding. Keeps full DMR functionality with system privileges.
```

### 4. Create install.sh

```bash
#!/system/bin/sh
ui_print "========================================"
ui_print "  MacDMRUlephone System App Installer  "
ui_print "========================================"
ui_print "Replacing PriInterPhone with custom version..."
ui_print "Custom icon: MacDMR logo"
ui_print "App name: MacDMRUlephone"
ui_print "Version: 2.0-MacDMR"
ui_print "DMR hardware access: ENABLED"
ui_print "========================================"
ui_print "Installation complete. Reboot to activate."
```

### 5. Package Module

```powershell
Compress-Archive -Path MacDMRUlephone\* -DestinationPath MacDMRUlephone-Magisk.zip -Force

# Result: 6.65 MB ZIP file
```

### 6. Transfer to Device

```bash
adb push MacDMRUlephone-Magisk.zip /sdcard/Download/
# File ready at: /sdcard/Download/MacDMRUlephone-Magisk.zip
```

## Installation Instructions

### On Device

1. **Open Magisk Manager** (already installed - com.topjohnwu.magisk)
2. **Tap "Modules" tab** (bottom navigation)
3. **Tap "Install from storage"** (+ button or FAB)
4. **Navigate to Downloads**
5. **Select MacDMRUlephone-Magisk.zip** (6.65 MB)
6. **Wait for installation** (Magisk shows real-time log)
7. **Tap "Reboot"** (module activates after reboot)

### Verification After Reboot

```bash
# Check package manager
adb shell pm path com.pri.prizeinterphone
# Should show: /system/priv-app/PriInterPhone/PriInterPhone.apk
# (Magisk makes it load custom APK transparently)

# Check user ID
adb shell dumpsys package com.pri.prizeinterphone | grep userId
# Should show: userId=1000 (system privileges)

# Launch app
adb shell am start -n com.pri.prizeinterphone/com.pri.prizeinterphone.InterPhoneHomeActivity

# Expected behavior:
# ✅ Custom MacDMRUlephone icon visible
# ✅ "MacDMRUlephone" in title bar
# ✅ "Module Initializing..." dialog dismisses quickly
# ✅ Main UI with 5 tabs accessible
# ✅ DMR module responds to commands

# Monitor DMR initialization
adb logcat -s "DmrManager:*" "CmdStateMachine:*" "SerialPort:*"
# Should see: Serial port opened, DMR module initialized, ready
```

## Technical Details

### File Sync Issue Encountered

During development, discovered that Java source files were not synced between WSL and Windows:
- **WSL**: 280 Java files (complete DMR implementation)
- **Windows**: Only 13 stub files

**Cause**: JADX decompilation ran in WSL, files never copied to Windows mount

**Solution**:
```powershell
robocopy \\wsl.localhost\Ubuntu\home\joshua\phonedmrapp\app\src\main\java `
         C:\Users\Joshua\Documents\phonedmrapp\app\src\main\java /E /IS

# Result: 280 files synced (2.36 MB)
# Includes: DmrManager, SerialPort, CmdStateMachine, PCMReceiveManager, all protocols
```

### Critical Classes Now Available

- **DmrManager.java**: Core DMR radio control
- **SerialPort.java**: UART communication with `/dev/ttyS1`
- **CmdStateMachine.java**: DMR command state machine
- **PCMReceiveManager.java**: Audio codec for DMR
- **InterPhoneHomeActivity.java**: Main UI (567 lines)
- All fragments, handlers, managers, protocols

### DMR Serial Communication

The app uses custom JNI native library for serial port access:
```java
// In SerialPort.java
public SerialPort(File device, int baudrate, int flags) {
    this.mFd = open(device.getAbsolutePath(), baudrate, flags);
    // Requires file descriptor access to /dev/ttyS1
    // Only possible with system UID or radio group
}
```

**Hardware Module**: `/dev/ttyS1`
- **Baud Rate**: Typically 115200 (configured in DmrManager)
- **Protocol**: Custom binary protocol for DMR commands
- **Audio**: PCM streaming for voice transmission

## Advantages of This Solution

✅ **No System Partition Modification**: All changes are systemless
✅ **No Platform Key Required**: Leverages original app's signature
✅ **Reversible**: Disable module in Magisk Manager anytime
✅ **OTA Safe**: Survives OTA updates (module may need reinstall)
✅ **Full Hardware Access**: System UID grants access to `/dev/ttyS1`
✅ **Custom Branding Preserved**: Icon and name from modded APK
✅ **Toggle-able**: Enable/disable without uninstalling

## Disadvantages/Limitations

⚠️ **Requires Magisk**: Device must have Magisk installed
⚠️ **Debug Signature**: APK is debug-signed (not production)
⚠️ **Device Specific**: Only works on devices with DMR hardware module
⚠️ **OTA Updates**: Major updates may require module reinstallation
⚠️ **Boot Dependency**: Module loads at boot, slight delay possible

## Troubleshooting

### Module Not Activating

**Check Magisk Log**:
```bash
adb shell cat /cache/magisk.log
# Or in Magisk Manager: Menu → Magisk Log
```

**Verify Module Enabled**:
- Open Magisk Manager → Modules tab
- Ensure "MacDMRUlephone System App" shows toggle as ON

### App Still Shows Initialization Hang

**Check UID**:
```bash
adb shell dumpsys package com.pri.prizeinterphone | grep userId
# Must show: userId=1000
```

**Check Serial Port Access**:
```bash
adb shell "su -c 'ls -l /dev/ttyS1'"
# Should show: crw-rw---- system radio

adb shell "su -c 'lsof /dev/ttyS1'"
# Should show app process accessing the device
```

**Check Logcat for Errors**:
```bash
adb logcat | grep -iE "serial|dmr|ttyS1|permission denied"
```

### Bootloop After Installation

**Safe Mode**:
1. Reboot device
2. At boot logo, hold Volume Down
3. Magisk modules disabled in safe mode

**Remove Module via ADB**:
```bash
adb shell
su
rm -rf /data/adb/modules/macdmrulephone
reboot
```

### Reverting to Original

1. Open Magisk Manager
2. Tap "Modules"
3. Find "MacDMRUlephone System App"
4. Tap trash icon
5. Reboot

Original system app restored immediately.

## Future Enhancements

### Convert to Release Build

For production use, build with release signing:

```gradle
// app/build.gradle
android {
    signingConfigs {
        release {
            storeFile file("../keystore.jks")
            storePassword "your_password"
            keyAlias "macdmr"
            keyPassword "your_password"
        }
    }
    buildTypes {
        release {
            signingConfig signingConfigs.release
            minifyEnabled false
        }
    }
}
```

### Add Module Update Support

Add `update.json` for Magisk Manager updates:
```json
{
  "version": "1.0",
  "versionCode": 1,
  "zipUrl": "https://github.com/IIMacGyverII/phonedmrapp/releases/download/v1.0/MacDMRUlephone-Magisk.zip",
  "changelog": "https://github.com/IIMacGyverII/phonedmrapp/releases"
}
```

### Additional Features

- Custom boot animation with MacDMR logo
- Additional UI customizations
- Performance optimizations
- Battery usage optimization
- Localization support

## References

- **Magisk Documentation**: https://topjohnwu.github.io/Magisk/
- **Magisk Module Template**: https://github.com/topjohnwu/magisk-module-template
- **Device Info**: 5006AF1020002922 (production build, system locked)
- **GitHub Repository**: https://github.com/IIMacGyverII/phonedmrapp

---

**Last Updated**: February 17, 2026  
**Status**: Module created, transferred to device, ready for installation  
**Next Action**: User installs via Magisk Manager and reboots
