# Quick Reference - InterPhone Modded Debugging

## App Information
- **Package**: `com.pri.prizeinterphone.modded`
- **Display Name**: InterPhone Modded
- **Version**: 2.0-modded (versionCode 34)
- **Current PID**: 27117
- **Device**: 5006AF1020002922

---

## Common ADB Commands

### Launch App
```powershell
$env:ADB = "$env:LOCALAPPDATA\Android\Sdk\platform-tools\adb.exe"
& $env:ADB shell am start -n com.pri.prizeinterphone.modded/com.pri.prizeinterphone.InterPhoneHomeActivity
```

### Check if App is Running
```powershell
& $env:ADB shell "ps -A | grep prizeinterphone.modded"
```

### Monitor Logs (Realtime)
```powershell
# All modded app logs
& $env:ADB logcat -v time | Select-String -Pattern "prizeinterphone.modded"

# Errors and crashes only
& $env:ADB logcat -v time *:E

# Specific tags
& $env:ADB logcat -v time -s InterPhoneHomeActivity:D DmrManager:D
```

### Stop App
```powershell
& $env:ADB shell am force-stop com.pri.prizeinterphone.modded
```

### Clear App Data
```powershell
& $env:ADB shell pm clear com.pri.prizeinterphone.modded
```

### Uninstall
```powershell
& $env:ADB uninstall com.pri.prizeinterphone.modded
```

### Reinstall
```powershell
& $env:ADB install -r "C:\Users\Joshua\Documents\phonedmrapp\InterPhone-Modded.apk"
```

---

## Grant Runtime Permissions

```powershell
$env:ADB = "$env:LOCALAPPDATA\Android\Sdk\platform-tools\adb.exe"

# Grant all permissions at once
& $env:ADB shell pm grant com.pri.prizeinterphone.modded android.permission.READ_CONTACTS
& $env:ADB shell pm grant com.pri.prizeinterphone.modded android.permission.WRITE_CONTACTS
& $env:ADB shell pm grant com.pri.prizeinterphone.modded android.permission.RECORD_AUDIO
& $env:ADB shell pm grant com.pri.prizeinterphone.modded android.permission.CAMERA
& $env:ADB shell pm grant com.pri.prizeinterphone.modded android.permission.READ_EXTERNAL_STORAGE
& $env:ADB shell pm grant com.pri.prizeinterphone.modded android.permission.WRITE_EXTERNAL_STORAGE
& $env:ADB shell pm grant com.pri.prizeinterphone.modded android.permission.ACCESS_FINE_LOCATION
& $env:ADB shell pm grant com.pri.prizeinterphone.modded android.permission.ACCESS_COARSE_LOCATION
```

---

## Debugging Tips

### Get Current Activity
```powershell
& $env:ADB shell dumpsys window | Select-String -Pattern "mCurrentFocus"
```

### Capture Screenshot
```powershell
& $env:ADB shell screencap -p /sdcard/screenshot.png
& $env:ADB pull /sdcard/screenshot.png .
```

### View App Info
```powershell
& $env:ADB shell dumpsys package com.pri.prizeinterphone.modded | Select-String -Pattern "versionName|versionCode|userId|firstInstallTime"
```

### Check for Crashes (Last 100 Lines)
```powershell
& $env:ADB logcat -d -t 100 | Select-String -Pattern "FATAL|AndroidRuntime.*E"
```

### Monitor Specific Component
``` powershell
# DMR Manager
& $env:ADB logcat -v time -s DmrManager:*

# Serial Port
& $env:ADB logcat -v time -s SerialPort:*

# Audio
& $env:ADB logcat -v time -s AudioTrack:* AudioFlinger:*
```

---

## Build and Deploy Workflow  

### Make Code Changes in WSL
```bash
cd ~/phonedmrapp
nano app/src/main/java/com/pri/prizeinterphone/YourFile.java
```

### Rebuild APK
```bash
cd ~/phonedmrapp
./gradlew clean assembleDebug
cp app/build/outputs/apk/debug/app-debug.apk /mnt/c/Users/Joshua/Documents/phonedmrapp/InterPhone-Modded.apk
```

### Reinstall from PowerShell
```powershell
$env:ADB = "$env:LOCALAPPDATA\Android\Sdk\platform-tools\adb.exe"
& $env:ADB install -r "C:\Users\Joshua\Documents\phonedmrapp\InterPhone-Modded.apk"
& $env:ADB shell am start -n com.pri.prizeinterphone.modded/com.pri.prizeinterphone.InterPhoneHomeActivity
```

---

## Comparison Testing (Original vs Modded)

### Launch Original System App
```powershell
& $env:ADB shell am start -n com.pri.prizeinterphone/com.pri.prizeinterphone.InterPhoneHomeActivity
```

### Check Both Processes
```powershell
& $env:ADB shell "ps -A | grep prizeinterphone"
```

Expected output:
```
system       25527   758 ... com.pri.prizeinterphone          # Original (system)
u0_a191      27117   758 ... com.pri.prizeinterphone.modded   # Modded (user)
```

---

## Known Issues & Workarounds

### Issue: App shows "limited functionality" toast  
**Cause**: System APIs not available to user apps  
**Workaround**: Expected behavior - some features won't work

### Issue: Photo loading fails
**Cause**: 5 JADX methods still stubbed  
**Fix**: Manual implementation required (see JADX_DECOMPILATION_ERRORS.md)

### Issue: Serial port errors
**Cause**: Requires system privileges  
**Test**: Try on device with unlocked bootloader or rooted device

### Issue: App crashes on startup
**Debug**: 
```powershell
& $env:ADB logcat -d | Select-String -Pattern "FATAL|AndroidRuntime.*E" | Select-Object -Last 30
```
Check for NoSuchMethodError (system API) or other exceptions

---

## Useful Logcat Filters

### All errors from modded app
```powershell
& $env:ADB logcat -v time *:E | Select-String -Pattern "27117|modded"
```

### DMR-related activity
```powershell
& $env:ADB logcat -v time | Select-String -Pattern "dmr|channel|codec" -CaseSensitive:$false
```

### Activity lifecycle
```powershell
& $env:ADB logcat -v time | Select-String -Pattern "onCreate|onResume|onPause|onDestroy"
```

---

## Files & Locations

### Windows (Development)
- Project root: `C:\Users\Joshua\Documents\phonedmrapp\`
- Final APK: `C:\Users\Joshua\Documents\phonedmrapp\InterPhone-Modded.apk`
- Screenshots: `C:\Users\Joshua\Documents\phonedmrapp\*.png`

### WSL (Build)
- Project root: `/home/joshua/phonedmrapp/`
- Build output: `/home/joshua/phonedmrapp/app/build/outputs/apk/debug/app-debug.apk`
- Gradle wrapper: `/home/joshua/phonedmrapp/gradlew`

### Device
- APK install location: `/data/app/~~...~/com.pri.prizeinterphone.modded-.../base.apk`
- App data: `/data/data/com.pri.prizeinterphone.modded/`
- Logs: Access via `adb logcat`

---

## Emergency Commands

### Device Unresponsive
```powershell
& $env:ADB kill-server
& $env:ADB start-server
& $env:ADB devices
```

### App Boot Loop
```powershell
# Uninstall modded app
& $env:ADB uninstall com.pri.prizeinterphone.modded

# If needed, disable original app (requires root)
& $env:ADB shell pm disable-user com.pri.prizeinterphone
```

### Clear All Logs
```powershell
& $env:ADB logcat -c
```

---

**Last Updated**: February 17, 2026  
**App Status**: RUNNING ✅  
**Ready for debugging and testing**
