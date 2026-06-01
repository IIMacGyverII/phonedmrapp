# DMRModHooks v3.0.1 - Release Package

**Build Date**: March 4, 2026 08:12  
**File Size**: 40.8 MB  
**Status**: ✅ Build Successful & Installed  
**Major Feature**: Analog MON Button with Squelch Control

## Quick Installation

### Option 1: Direct Install via ADB (Fastest - USED)

```powershell
# Install debug APK (already signed)
$adb = "$env:LOCALAPPDATA\Android\Sdk\platform-tools\adb.exe"
& $adb install -r DMRModHooks\app\build\outputs\apk\debug\app-debug.apk
```

✅ **Already installed on device 5006AF1020002922**

### Option 2: Manual Install (Copy to phone)

```powershell
# Copy to Downloads folder
adb push DMRModHooks\app\build\outputs\apk\release\app-release-unsigned.apk /sdcard/Download/DMRModHooks-v3.0.1.apk
```

Then on phone:
1. Open Files app → Downloads
2. Tap `DMRModHooks-v3.0.1.apk`
3. Tap **Install** (allow unknown sources if prompted)
4. Tap **Done**

### Option 3: Transfer via File Manager

1. Copy `DMRModHooks\app\build\outputs\apk\release\app-release-unsigned.apk` to phone via USB
2. Install from phone's file manager

## Post-Installation

### Activate in LSPosed

1. Open **LSPosed** app
2. Go to **Modules** tab
3. Find **DMRModHooks**
4. Enable the toggle (should turn green)
5. Check **com.pri.prizeinterphone** in scope
6. Tap **com.pri.prizeinterphone** → **Force stop**
7. Reboot device (recommended) or restart app

### Verify Installation

1. Open DMR radio app
2. Check for toast: "✓ DMR Mod Hooks Active! v3.0.1"
3. Switch to LOCAL tab (TalkBack screen)
4. Look for **MON** button (right side, below REC button)
5. Switch to an **analog channel**
6. Verify MON button is **enabled** (not grayed out)

## Test v3.0.1 Feature

### Testing Analog Squelch Control

**Preparation**:
1. Switch to an analog channel (FM simplex or repeater)
2. Note current squelch level (check channel settings)

**Test MON ON**:
1. Press **MON** button (should turn orange)
2. Toast should show: "Monitoring Mode ON (squelch fully open)"
3. Check logcat: `adb logcat | grep "DMRModHooks"`
4. Look for: `Analog MON ON - stored squelch=X, set to 0`
5. You should now hear more activity (weaker signals coming through)

**Test MON OFF**:
1. Press **MON** button again (should turn gray)
2. Toast should show: "Monitoring Mode OFF (squelch: X)"
3. Check logcat for: `Analog MON OFF - restored squelch=X`
4. Weaker signals should be filtered out again

**Test Channel Switch**:
1. With MON ON, switch to another analog channel
2. MON button should reflect that channel's squelch state
3. Switch back - previous MON state should be restored

**Test DMR Channels**:
1. Switch to a DMR/digital channel
2. MON button should still work (contactType toggle)
3. Verify existing DMR functionality unchanged

## Monitoring Logs

```powershell
# Full logs
adb logcat | grep -i "dmrmod"

# Just MON button activity
adb logcat | grep -i "monitoringmode"

# Analog squelch changes
adb logcat | grep -i "analog mon"
```

## Expected Log Output

### Initialization (Analog Channel)
```
DMRModHooks: MonitoringMode initialized (Analog) - squelch=2, original=2
```

### MON Toggle (Analog)
```
DMRModHooks: MonitoringMode toggled: ON
DMRModHooks: Analog MON ON - stored squelch=2, set to 0
DMRModHooks: Analog MonitoringMode updated - squelch=0 (open)
```

### Channel Switch (Analog)
```
DMRModHooks: Channel changed from 1 to 2 (Analog), RX Tone: 100.0 Hz
DMRModHooks: Updated MON button for analog channel - squelch=3, original=3
```

### MON Toggle (DMR)
```
DMRModHooks: MonitoringMode toggled: ON
DMRModHooks: DMR MonitoringMode updated - contactType=2, txContact=16777215
```

## Rollback (If Needed)

If v3.0.1 causes issues:

```powershell
# Install previous version
adb install -r DMRModHooks-v1.4.9.apk

# Or disable module in LSPosed
# Then force stop app
```

## What's Changed in v3.0.1

### Code Changes
- **MainHook.java** (~150 lines modified):
  - Added `originalSquelchLevel` variable for squelch state tracking
  - Updated MON button initialization for analog channels
  - Extended MON button click handler with analog squelch logic
  - Added channel switch handler for MON state restoration

### Behavior Changes
- MON button now works on analog channels (previously disabled)
- Squelch set to 0 (fully open) when MON is ON for analog channels
- Original squelch level preserved and restored per channel
- Per-channel MON state persistence

### UI Changes
- No visual changes - same MON button appearance
- Same orange (ON) / gray (OFF) color scheme
- Updated toast messages for analog channels

## Files Included

```
DMRModHooks/
├── app/build/outputs/apk/release/
│   └── app-release-unsigned.apk           (40.8 MB) ← Install this
├── ANALOG_MON_FEATURE.md                  (Documentation)
├── README.md                              (Updated with v3.0.1 info)
└── app/src/main/java/com/dmrmod/hooks/
    └── MainHook.java                      (Modified source)
```

## Support

- **Issues**: Check logcat for errors
- **Questions**: See [ANALOG_MON_FEATURE.md](ANALOG_MON_FEATURE.md)
- **Rollback**: Keep v1.4.9 APK as backup

## Next Steps After Successful Test

1. ✅ Test both analog and DMR MON functionality
2. ✅ Monitor logs for errors
3. ✅ Use in field (simplex, repeater, DMR)
4. 📝 Document any issues or improvements
5. 🚀 Tag release as v3.0.1 when stable

---

**Build Info**:
- Gradle: 8.1.0
- Compile SDK: 34
- Target SDK: 34
- Min SDK: 29
- Build Time: 12s
- Tasks: 37 executed, 1 up-to-date
- Version: **v3.0.1** (displayed in toast)

**Status**: ✅ Ready for deployment & testing  
**Installation**: ✅ Completed successfully on device 5006AF1020002922  
**Toast Verification**: ✅ Shows "✓ DMR Mod Hooks Active! v3.0.1"
