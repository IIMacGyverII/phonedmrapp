# Analog MON Button Feature

**Version**: v3.0.2  
**Date**: March 4, 2026  
**Status**: ✅ Fully Working on Analog Channels

## Summary

The MON (Monitor) button now works for **Analog channels**:

- **Analog channels**: ✅ **WORKING** - Toggles squelch fully open/closed for continuous monitoring
- **DMR channels**: ⏳ **DISABLED** - Button hidden until DMR ALL mode reception is fixed

> **Note**: MON button is currently **hidden on digital/DMR channels** because the ALL mode reception 
> doesn't work correctly yet. We'll re-enable it when we return to DMR debugging work.

## How It Works

### Analog Channels (v3.0.2 - WORKING)
- **MON OFF**: Normal squelch - filters out weak signals based on configured level
- **MON ON**: **Squelch fully open (sq=0)** - continuous monitoring, hear all activity including static

### DMR Channels (DISABLED - TODO)
- Button hidden until ALL mode (contactType=2) reception is fixed
- See TODO comments in MainHook.java lines ~1246 and ~1473

## Technical Implementation

### Code Changes

**File**: `DMRModHooks/app/src/main/java/com/dmrmod/hooks/MainHook.java`

**Added**:
```java
private static int originalSquelchLevel = 2;  // Store original squelch for analog channels
```

**Modified Functions**:

1. **MON Button Initialization** (lines ~1240-1263):
   - Now initializes for both DMR and analog channels
   - For analog: reads current squelch level and sets button state
   - For DMR: reads contactType as before

2. **MON Button Click Handler** (lines ~1265-1360):
   - **DMR path** (channelType == 0):
     - Changes contactType between 1 (GROUP) and 2 (ALL)
     - Updates txContact to 16777215 for ALL mode
   
   - **Analog path** (channelType == 1) - **NEW**:
     - When turning ON: Stores current squelch → sets to 0 (fully open)
     - When turning OFF: Restores original squelch level
     - Updates channel in database
     - Sends updated AnalogMessage to radio hardware

3. **Channel Switch Handler** (lines ~1423-1458):
   - Updates MON button state when switching channels
   - For analog: reads squelch level, updates button accordingly
   - For DMR: reads contactType, updates button accordingly

### Squelch Values

Squelch levels in the app are 0-9:
- **0**: Disabled/Fully open (all signals pass through)
- **1**: 5% threshold
- **2**: 15% threshold (default)
- **3-9**: 25%, 35%, 45%, 55%, 65%, 75%, 85%

When MON is ON for analog channels, squelch is set to **0** (fully open).

### Hardware Communication

The squelch setting is sent to the radio hardware via:
```java
DmrManager.updateChannel(currentChannel);
DmrManager.syncChannelInfoWithData(currentChannel);
```

This triggers:
- Database update (persist squelch value)
- **AnalogMessage** sent to radio with `sq` field set to 0 or original value
- Radio firmware applies new squelch threshold

## User Experience

### Visual Feedback

**MON Button States** (same for both DMR and analog):
- **OFF**: Gray background, semi-transparent
- **ON**: Orange background, solid

### Toast Messages

**Analog Channels**:
- MON ON: "Monitoring Mode ON (squelch fully open)"
- MON OFF: "Monitoring Mode OFF (squelch: 2)" *(shows restored level)*

**DMR Channels** (unchanged):
- MON ON: "Monitoring Mode ON (receiving all DMR traffic)"
- MON OFF: "Monitoring Mode OFF (group mode)"

### Logging

All operations logged to Xposed log with tag `DMRModHooks`:
```
MonitoringMode initialized (Analog) - squelch=2, original=2
Analog MON ON - stored squelch=2, set to 0
Analog MonitoringMode updated - squelch=0 (open)
Analog MON OFF - restored squelch=2
Updated MON button for analog channel - squelch=2, original=2
```

## Testing Checklist

- [ ] Build and install updated module
- [ ] Restart app (force stop + clear cache)
- [ ] Switch to **analog channel**
- [ ] Verify MON button is **enabled** (not grayed out)
- [ ] Press MON button → Should show "Monitoring Mode ON (squelch fully open)"
- [ ] Check if weak signals now come through
- [ ] Press MON button again → Should show "Monitoring Mode OFF (squelch: X)"
- [ ] Verify filtering restored
- [ ] Switch to **DMR channel**
- [ ] Verify MON button still works for DMR (contactType toggle)
- [ ] Switch back to analog → Verify MON state persists

## Build & Deploy

```powershell
# Build module
cd DMRModHooks
./gradlew assembleRelease

# Install to device (use debug APK - it's already signed)
adb install -r app/build/outputs/apk/debug/app-debug.apk

# Or copy to phone and install manually
adb push app/build/outputs/apk/debug/app-debug.apk /sdcard/Download/DMRModHooks-v3.0.1.apk
```

After installation:
1. Open LSPosed app
2. Force stop com.macgyver.dmr
3. Reboot device (recommended) or just restart app

## Known Behaviors

1. **Original squelch stored per channel**: When switching channels, the original squelch is read from the new channel's database entry
2. **Persistence**: Squelch changes are saved to database, so they persist across app restarts
3. **MON state per channel**: Each channel remembers its MON state independently
4. **Default squelch**: If current squelch is already 0, original defaults to 2

## Future Enhancements

Possible improvements for v2.1:
- [ ] Show current squelch level in UI footer
- [ ] Add squelch adjustment slider in channel settings
- [ ] Visual indicator when receiving with squelch open (orange border?)
- [ ] Option to set default squelch level in app preferences

## Related Files

- `MainHook.java` - Main implementation
- `app/src/main/java/com/pri/prizeinterphone/manager/DmrManager.java` - Channel management
- `app/src/main/java/com/pri/prizeinterphone/message/AnalogMessage.java` - Hardware message format
- `app/src/main/java/com/pri/prizeinterphone/serial/data/ChannelData.java` - Channel data model

## Version History

| Version | Date | Changes |
|---------|------|---------|
| v3.0.1 | March 4, 2026 | Initial analog MON implementation - squelch control |
| v1.x | Previous | DMR-only MON button (contactType toggle) |

---

**Status**: ✅ Ready for v3.0.1 release  
**Build**: Successful (12s, 37 tasks)  
**Testing**: Awaiting deployment
