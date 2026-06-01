# Monitoring Mode - Quick Start Guide

## TL;DR - What This Does

Adds a **"MONITOR"** toggle button to the PriInterPhone app that switches your current DMR channel between:
- **OFF**: GROUP mode (contactType=1) - Hardware filters to configured talkgroups (broken on Ulefone)  
- **ON**: ALL mode (contactType=2) - Hardware receives all DMR traffic on timeslot/color code (workaround)

**Goal**: Fix the issue where Ulefone Armor 26 Ultra only receives private calls, not group calls.

---

## Installation (5 Minutes)

### Option 1: Quick Test (Manual Database Edit)
Test if ALL mode works on your hardware:

```powershell
# 1. Pull database
adb pull /data/data/com.pri.prizeinterphone/databases/database_channel_area_default_uhf.db

# 2. Set channel 17 to ALL mode
python -c "import sqlite3; conn = sqlite3.connect('database_channel_area_default_uhf.db'); cursor = conn.cursor(); cursor.execute('UPDATE database_channel_area_default_uhf SET channel_contactType = 2, channel_txContact = 16777215 WHERE channel_number = 17'); conn.commit(); conn.close()"

# 3. Push back and restart
adb push database_channel_area_default_uhf.db /data/data/com.pri.prizeinterphone/databases/
adb shell "am force-stop com.pri.prizeinterphone"

# 4. Test - transmit on TG 64067/55301, check if you receive
```

**If you receive group calls:** ✅ Proceed with full implementation  
**If still no audio:** ⚠️ Hardware ignores ALL mode too (see alternatives below)

---

### Option 2: Full Implementation (LSPosed Hook)

1. **Open** `DMRModHooks/app/src/main/java/com/dmrmod/hooks/MainHook.java`

2. **Add field** (around line 100):
```java
// Monitoring mode toggle button
private static android.widget.CompoundButton monitoringModeToggle = null;
private static volatile boolean isMonitoringMode = false;
```

3. **Add method** (copy entire `hookMonitoringModeToggle()` from `MONITORING_MODE_CODE.java`)

4. **Call method** in `handleLoadPackage()` (around line 150):
```java
hookMonitoringModeToggle(lpparam);
```

5. **Update version** (line 82):
```java
private static final String VERSION = "1.7.0";
```

6. **Build & Install:**
```powershell
cd DMRModHooks
./gradlew assembleDebug
adb install -r app/build/outputs/apk/debug/app-debug.apk
adb shell "am force-stop com.pri.prizeinterphone"
```

7. **Verify:**
   - Open PriInterPhone
   - Look for "MONITOR: OFF" button in bottom-right of TalkBack screen
   - Toggle it and check Toast message

---

## Usage

### Daily Operation
1. Open PriInterPhone app
2. Select DMR channel (e.g., channel 17)
3. Tap **"MONITOR: OFF"** button in bottom-right
4. Button changes to **"MONITOR: ON"**
5. Toast confirms: "Monitoring Mode: ON (receiving all DMR traffic)"
6. Test group call reception

### Toggle States
- **OFF** (default): GROUP mode - filtered to RX group list (broken hardware)
- **ON**: ALL mode - unfiltered, receives all traffic on timeslot/CC

### Per-Channel Behavior
- **DMR channels**: Toggle enabled and functional
- **Analog channels**: Toggle disabled (grayed out)
- **State persists**: Database saved, survives app restart

---

## Verification Checklist

After installation:

- [ ] Toggle button visible in bottom-right of home screen
- [ ] Clicking toggle shows Toast message
- [ ] Database updates (check with `adb pull` + Python query)
- [ ] Hardware message sent (check `adb logcat` for `sendDigitalMessage DEBUG`)
- [ ] Group calls received when toggle ON (if hardware supports)

---

## What If ALL Mode Still Doesn't Work?

If toggling works but you still don't receive group calls, your hardware module likely ignores `contactType` entirely. **Alternatives:**

### Software Filtering (Recommended)
Implement audio filtering in `PCMReceiveManager`:
- Receives all audio from hardware (ALL mode always on)
- Filters unwanted TGs in software before playback
- Flexible whitelist/blacklist rules

See **MONITORING_MODE_TESTING.md** section "Alternative Solutions" for code.

### Packet Interception (Advanced)
Hook `DigitalMessage.encodeBody()` to modify packet before sending:
- Forces `contactType=2` at byte level
- Risk: Packet corruption if wrong offset

### Firmware Patching (Expert Only)
Reverse engineer DMR module firmware:
- ⚠️ **HIGH RISK** of bricking device
- Requires JTAG, ARM knowledge, recovery method

### Hardware Replacement
Known working models:
- TYT MD-398 (confirmed RX groups work)
- Motorola DP4800 (commercial)
- Research XDA forums before buying

---

## Code Architecture

```
User taps toggle
    ↓
onClick handler (LSPosed hook)
    ↓
Get current channel (DmrManager.getCurrentChannel)
    ↓
Check channel type (0=Digital, 1=Analog)
    ↓
Toggle contactType (1 ↔ 2)
    ↓
Update TX contact (1 → 16777215 if ALL mode)
    ↓
Update database (DmrManager.updateChannel)
    ↓
Trigger hardware resend (DmrManager.syncChannelInfoWithData)
    ↓
    ├─→ sendDigitalMessage()
    │       ↓
    │   Build DigitalMessage packet
    │       ↓
    │   encodeBody() (163 bytes)
    │       ↓
    │   send() to hardware module
    │
    └─→ Toast feedback to user
```

---

## Troubleshooting Quick Reference

| Issue | Solution |
|-------|----------|
| Toggle doesn't appear | Check LSPosed enabled, scope set, logs for errors |
| Toggle doesn't click | Check `adb logcat` for "toggle clicked" message |
| Database not updating | Check write permissions, verify SQL update |
| Hardware not responding | Check `sendDigitalMessage DEBUG` logs |
| Still no group calls | Hardware ignores ALL mode - use alternatives |
| App crashes on toggle | Check XposedBridge logs, verify reflection calls |

---

## Files Reference

- **MONITORING_MODE_IMPLEMENTATION.md** - Full technical documentation
- **MONITORING_MODE_CODE.java** - Complete Java code to add
- **MONITORING_MODE_TESTING.md** - Comprehensive testing procedures
- **DMR_GROUP_CALL_ISSUE.md** - Original investigation report

---

## Support & Contribution

**Questions?** Check logs first:
```powershell
adb logcat | Select-String "MonitoringMode|DMRModHooks"
```

**Found bugs?** Submit with:
- Device model
- Android version
- App version
- Full logcat output
- Database state dump

**Want to contribute?**
- Test on other devices
- Implement software filtering
- Improve UI/UX
- Document hardware compatibility

---

## Grok's Opinion (xAI)

> This is a pragmatic workaround. Don't overcomplicate with packet interception if database toggles and UI buttons suffice. The real fix is firmware-level, which is outside your control. **Key insight**: ALL mode (contactType=2) is designed for "monitor everything" scenarios - if the hardware respects it, you've solved the problem. If not, software filtering is your next best bet without bricking risk.

> **Testing strategy**: Manual database edit first (0 code), then full hook if successful. If ALL mode fails, accept hardware limitation and pivot to software filtering. Save firmware patching as absolute last resort - not worth the brick risk for a workaround.

---

**Current Status**: Code ready, testing needed. Report results back to confirm hardware behavior.

**Version**: 1.7.0  
**Date**: 2026-02-27  
**License**: MIT
