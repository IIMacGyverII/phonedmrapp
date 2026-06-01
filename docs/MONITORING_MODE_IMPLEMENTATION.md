# DMR Monitoring Mode Implementation Guide

## Overview
This feature adds a "Monitoring Mode" toggle to the PriInterPhone app that switches the current channel between:
- **GROUP mode** (contactType=1): Filtered - only receives configured talkgroups
- **ALL mode** (contactType=2): Unfiltered - receives all DMR traffic on timeslot/color code

This works around the hardware limitation where the DMR module ignores RX group lists.

## Implementation Details

### Architecture
- **Method**: LSPosed hook (no APK rebuild required)
- **Location**: Added to DMRModHooks MainHook.java
- **UI**: ToggleButton in bottom-right of TalkBack fragment
- **Persistence**: Updates database immediately, survives app restart

### Code Flow
```
User toggles button
    ↓
Toggle Handler (LSPosed hook)
    ↓
Get current channel from DmrManager
    ↓
Toggle contactType (1 ↔ 2)
    ↓
Update database (UtilChannelData.updateChannel)
    ↓
Trigger hardware resend (DmrManager.syncChannelInfoWithData)
    ↓
Hardware receives new DigitalMessage with updated contactType
    ↓
Toast feedback to user
```

### Database Changes
**Table**: `database_channel_area_default_uhf`
**Field**: `channel_contactType`
- **Value 1** (GROUP): Hardware filters to groupList (broken on Ulefone)
- **Value 2** (ALL): Hardware should accept all traffic (workaround)

**Note**: TX contact set to 0xFFFFFF (16777215) when in ALL mode per app convention.

### Testing Checklist
- [ ] Toggle appears in TalkBack fragment bottom-right
- [ ] Toggle changes contactType in database (verify with adb + Python)
- [ ] Toast shows "Monitoring Mode: ON/OFF"
- [ ] Channel switch preserves state (toggle reflects database)
- [ ] Group calls received when toggle ON (if hardware supports ALL mode)
- [ ] Private calls still work in both modes
- [ ] Toggle disabled on analog channels (DMR-only feature)

### Known Limitations
1. **Hardware may still ignore ALL mode** - If hardware has same bug for contactType=2, this won't help
2. **TX contact changes** - When ALL mode enabled, TX contact becomes 16777215 (broadcast)
3. **Analog channels** - Toggle hidden/disabled when channel is analog (type=1)
4. **No RX group list editing** - This doesn't expose the 32-field UI, just toggles behavior

### Alternative Approaches (if ALL mode fails)
1. **Custom packet interception** - Hook DigitalMessage.encodeBody() to modify packet
2. **Firmware patch** - Reverse engineer DMR module firmware (high risk)
3. **Hardware replacement** - Use known-working DMR phone model
4. **Software-based group filtering** - Filter audio in PCMReceiveManager (CPU intensive)

## Installation

1. Copy the new `hookMonitoringMode()` function into MainHook.java
2. Call `hookMonitoringMode(lpparam);` in `handleLoadPackage()` after other hooks
3. Build DMRModHooks: `./gradlew assembleDebug` (in DMRModHooks folder)
4. Install: `adb install -r app/build/outputs/apk/debug/app-debug.apk`
5. Restart app: `adb shell "am force-stop com.pri.prizeinterphone"`
6. Test: Check for toggle button in TalkBack screen

## Debugging

### Check if hook installed:
```bash
adb logcat -d | Select-String "Successfully hooked.*MonitoringMode"
```

### Monitor toggle events:
```bash
adb logcat | Select-String "MonitoringMode"
```

### Verify database update:
```bash
adb pull /data/data/com.pri.prizeinterphone/databases/database_channel_area_default_uhf.db
python -c "import sqlite3; conn = sqlite3.connect('database_channel_area_default_uhf.db'); 
cursor = conn.cursor(); 
cursor.execute('SELECT channel_number, channel_name, channel_contactType, channel_txContact FROM database_channel_area_default_uhf WHERE channel_number = 17'); 
print(cursor.fetchone()); conn.close()"
```

### Check hardware message sent:
```bash
adb logcat | Select-String "sendDigitalMessage DEBUG"
```
Should show contactType changing between 1 and 2.

## Code Comments

The implementation uses several key patterns:

1. **Activity context preservation**: Saves Activity reference in afterHookedMethod
2. **Reflection for method calls**: Uses XposedHelpers.callMethod to invoke DmrManager methods
3. **Database updates**: Calls existing app methods (no SQL injection risks)
4. **UI thread safety**: All UI operations in runOnUiThread()
5. **Null safety**: Extensive null checks before operations
6. **Error handling**: Try-catch with XposedBridge.log for debugging

## Future Enhancements

1. **Auto-monitoring on channel switch** - Remember per-channel state
2. **Visual indicator** - Change text color/icon when monitoring active
3. **RX group list editor** - Expose 32-field GridView in hook
4. **TG whitelist/blacklist** - Software filtering of received TGs
5. **Recording auto-start** - Begin recording when monitoring detects traffic
6. **Integration with transcription** - Auto-transcribe monitored calls

## Support

For issues or questions:
- Check LSPosed logs: Settings → LSPosed → Logs
- Verify module enabled: Settings → LSPosed → Modules → DMRModHooks (checked)
- Verify scope: Settings → LSPosed → Modules → DMRModHooks → PriInterPhone (checked)
- GitHub: (add your repo URL)
- XDA Forum: (add forum thread URL)

---

**Version**: 1.7.0 (adds Monitoring Mode)
**Author**: MacGyver DMR Mod Team
**Date**: 2026-02-27
**License**: MIT (or your choice)
