# InterPhone Modded - Installation Success Report

**Date**: February 17, 2026  
**Status**: ✅ **SUCCESSFULLY INSTALLED AND RUNNING**

---

## Summary

The DMR (Digital Mobile Radio) system app has been successfully decompiled, modified, built, and installed on a physical Android device as a separate modded application running alongside the original system app.

## Installation Details

- **Package Name**: `com.pri.prizeinterphone.modded`
- **App Display Name**: InterPhone Modded
- **Version**: 2.0-modded (versionCode 34)
- **APK Size**: 8,063,207 bytes (~8.06 MB)
- **Installation Type**: User app (debug signature)
- **Device**: 5006AF1020002922
- **First Install Time**: 2026-02-17 18:18:31
- **Current Status**: RUNNING (PID 27117, ~60 FPS UI rendering)

## Dual Installation Confirmed

Both applications are running simultaneously:

| App | Package | Type | PID | Status |
|-----|---------|------|-----|--------|
| Original | `com.pri.prizeinterphone` | System app | 25527 | Running |
| Modded | `com.pri.prizeinterphone.modded` | User app | 27117 | Running |

## Key Modifications Made

### 1. Package Rebranding
- Changed applicationId from `com.pri.prizeinterphone` to `com.pri.prizeinterphone.modded`
- Allows installation alongside original system app
- Prevents signature conflicts

### 2. Manifest Conflicts Resolved (5 iterations)

**Conflict #1: AndroidX Startup Provider**
- Error: Provider authority conflict
- Fix: Updated `com.pri.prizeinterphone.androidx-startup` → `com.pri.prizeinterphone.modded.androidx-startup`

**Conflict #2: Dynamic Receiver Permission**  
- Error: `INSTALL_Failed_DUPLICATE_PERMISSION`
- Fix: Renamed permission to `com.pri.prizeinterphone.modded.DYNAMIC_RECEIVER_NOT_EXPORTED_PERMISSION`

**Conflict #3: FileProvider Authority**
- Error: Provider name conflict
- Fix: Updated authority in manifest AND Java code (`UtilPicture.java`)
  - Manifest: `android:authorities="com.pri.prizeinterphone.modded.files"`
  - Java: `public static final String FILE_PATH = "com.pri.prizeinterphone.modded.files";`

**Conflict #4: SharedUserId Incompatibility**
- Error: `INSTALL_FAILED_SHARED_USER_INCOMPATIBLE: android.uid.system`
- Fix: Removed `android:sharedUserId="android.uid.system"` from manifest
- Impact: App now runs as regular user app (no system privileges)

### 3. System API Compatibility Fixes

#### Background Service Restriction
**File**: `PrizeInterPhoneApp.java`  
**Issue**: Cannot start background services from Application.onCreate() in user apps
```java
// Disabled - requires foreground service for non-system apps
// startInterPhoneService();
```

#### WindowManager API Access
**File**: `InterPhoneHomeActivity.java` line 148  
**Issue**: `WindowManagerGlobal.getWindowManagerService()` - system-only API
```java
// setDefaultDisplay(this); // Disabled - requires system WindowManager API
```

#### NVRAM Access
**File**: `Util.java` lines 32-62  
**Issue**: `NvramUtils.readUserNvramInfo()` - vendor-specific system API
```java
public static String getDMRUpdateStatusFromNvram() {
    // Disabled - NvramUtils requires system framework access
    // Always return idle status for non-system apps
    Log.d(TAG, "getDMRUpdateStatusFromNvram (stub - returning idle)");
    return "1";
}
```

#### PCM Audio Manager
**File**: `InterPhoneHomeActivity.java` lines 153-168  
**Issue**: `ITinyRecvCallback$Stub` - vendor-specific system API
```java
try {
    // System-dependent initialization wrapped in try-catch
    DmrManager.getInstance().registerUpdateListener(this);
    // ... more initialization ...
    PCMReceiveManager.getInstance().startPcmRead();
} catch (Throwable e) {
    // System API errors - this app requires system privileges
    Log.e("InterPhoneHomeActivity", "System API not available", e);
    Toast.makeText(this, "This modded app has limited functionality due to missing system APIs", 
                   Toast.LENGTH_LONG).show();
}
```

## Build Environment

- **Build System**: Gradle 8.2 with Android Gradle Plugin 7.4.2
- **Java**: OpenJDK 17.0.18
- **Android SDK**: 
  - compileSdk: 34
  - minSdk: 24
  - targetSdk: 34
  - buildToolsVersion: 33.0.1
- **Platform**: WSL2 Ubuntu 22.04 on Windows
- **Decompiler**: JADX 1.4.7 (217 Java source files extracted)

## Known Limitations

### Features That Won't Work
1. **Photo Loading** - 5 JADX methods still stubbed (decompilation errors)
2. **NVRAM Access** - Firmware status read/write disabled
3. **Background Service** - InterPhoneService not started automatically
4. **Display Density Override** - WindowManager system API unavailable
5. **PCM Audio Reception** - May have limited functionality without system privileges

### Expected Functionality
The app should display UI and allow navigation, but DMR radio features requiring system-level access will be limited or non-functional.

## Files Modified

### Build Configuration
- `app/build.gradle` - Changed applicationId and version
- `app/src/main/res/values/strings.xml` - Changed app name

### Manifest
- `app/src/main/AndroidManifest.xml`
  - Removed sharedUserId
  - Updated all provider authorities
  - Updated permission names

### Java Source
- `app/src/main/java/com/pri/prizeinterphone/PrizeInterPhoneApp.java` - Disabled background service
- `app/src/main/java/com/pri/prizeinterphone/InterPhoneHomeActivity.java` - Added try-catch for system APIs
- `app/src/main/java/com/pri/prizeinterphone/Util/Util.java` - Stubbed NVRAM methods
- `app/src/main/java/com/pri/prizeinterphone/Util/UtilPicture.java` - Updated FileProvider authority

## Helper Scripts Created

1. **rebrand-app.sh** - Automated package renaming
2. **remove-system-uid.sh** - Removed system privileges from manifest
3. **debug-monitor.cmd** - Windows CMD logcat monitor
4. **install-debug.ps1** - PowerShell installation script
5. **fix_nvram.py** - Python script to stub NVRAM methods
6. **wrap_trycatch.py** - Python script to add error handling

## Realtime Debugging

App is currently running and can be monitored with:

```powershell
$env:ADB = "$env:LOCALAPPDATA\Android\Sdk\platform-tools\adb.exe"
& $env:ADB logcat -v time | Select-String -Pattern "prizeinterphone.modded"
```

## Next Steps

1. ✅ ~~Install APK on device~~
2. ✅ ~~Verify app launches without crashing~~
3. ⏳ **Test DMR functionality** (limited due to system API restrictions)
4. ⏳ **Grant runtime permissions** (contacts, camera, audio, storage)
5. ⏳ **Monitor logs for runtime errors**
6. ⏳ **Document which features work vs. which don't**
7. ⏳ **Test alongside original system app**
8. ⏳ **Git commit final working state**

## Screenshots

- **Running App**: `interphone_modded_running.png` (captured 2026-02-17 18:28)
- **App rendering at ~60 FPS** (confirmed via SurfaceFlinger logs)

## Conclusion

**Mission Accomplished!** 🎉

The DMR system app has been successfully:
- Decompiled from APK (JADX - 217 Java files)
- Configured as Android Gradle project
- Fixed for compilation (15+ errors resolved)
- Rebranded as separate installable app
- Modified to work without system privileges (where possible)
- Built as debug APK (8.06 MB)
- Installed on physical device (5006AF1020002922)
- **LAUNCHED AND RUNNING** with visible UI

The modded app coexists with the original system app, allowing side-by-side comparison and testing. While some system-level features are unavailable, the core app structure is functional and ready for further development and testing.

---

**Last Updated**: February 17, 2026 18:29:00  
**Device**: Connected and ready for realtime debugging  
**App Status**: RUNNING (PID 27117)
