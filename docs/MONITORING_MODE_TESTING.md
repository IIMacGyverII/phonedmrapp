# Monitoring Mode Testing & Troubleshooting Guide

## Quick Test (Database Method - No Code Required)

Before implementing the full LSPosed hook, you can manually test if ALL mode (contactType=2) works:

### Manual Testing Steps

1. **Pull database:**
```powershell
adb pull /data/data/com.pri.prizeinterphone/databases/database_channel_area_default_uhf.db
```

2. **Update channel 17 to ALL mode:**
```powershell
python -c "import sqlite3; conn = sqlite3.connect('database_channel_area_default_uhf.db'); cursor = conn.cursor(); cursor.execute('UPDATE database_channel_area_default_uhf SET channel_contactType = 2, channel_txContact = 16777215 WHERE channel_number = 17'); conn.commit(); print('Updated channel 17 to ALL mode (contactType=2)'); conn.close()"
```

3. **Push database back:**
```powershell
adb push database_channel_area_default_uhf.db /data/data/com.pri.prizeinterphone/databases/
```

4. **Restart app:**
```powershell
adb shell "am force-stop com.pri.prizeinterphone"
```

5. **Test group call reception:**
   - Switch to channel 17
   - Have someone transmit on TG 64067 or 55301
   - Check if you receive audio

6. **Check hardware message logs:**
```powershell
adb logcat -d | Select-String "sendDigitalMessage DEBUG"
```
Should show: `contactType: 2 (0=PERSON, 1=GROUP, 2=ALL)`

### Expected Results

**If ALL mode works:**
- ✅ You receive group call audio
- ✅ Logs show `contactType: 2`
- → Implement full toggle feature

**If ALL mode still fails:**
- ❌ No audio on group calls
- ⚠️ Hardware likely ignores contactType entirely
- → Consider alternative approaches (see below)

---

## Full Implementation Testing

After adding the LSPosed hook code:

### Build & Install
```powershell
cd DMRModHooks
./gradlew assembleDebug
adb install -r app/build/outputs/apk/debug/app-debug.apk
adb shell "am force-stop com.pri.prizeinterphone"
adb logcat -c
```

### Verify Hook Installation
```powershell
adb logcat | Select-String "MonitoringMode"
```

Expected log:
```
DMRModHooks: Successfully hooked InterPhoneTalkBackFragment for Monitoring Mode
DMRModHooks: MonitoringMode toggle added to TalkBack fragment
```

### Test Toggle Functionality

1. **Visual Check:**
   - Open PriInterPhone app
   - Go to TalkBack screen (home screen)
   - Look for "MONITOR: OFF" button in bottom-right corner
   - Should be above bottom navigation bar

2. **State Initialization:**
```powershell
adb logcat -d | Select-String "MonitoringMode initialized"
```
Expected: `MonitoringMode initialized - Channel type=0, contactType=1, monitoring=false`

3. **Toggle ON:**
   - Tap "MONITOR: OFF" button
   - Should change to "MONITOR: ON"
   - Toast: "Monitoring Mode: ON (receiving all DMR traffic)"

4. **Verify Database Update:**
```powershell
adb pull /data/data/com.pri.prizeinterphone/databases/database_channel_area_default_uhf.db
python -c "import sqlite3; conn = sqlite3.connect('database_channel_area_default_uhf.db'); cursor = conn.cursor(); cursor.execute('SELECT channel_number, channel_name, channel_contactType, channel_txContact FROM database_channel_area_default_uhf WHERE channel_number = 17'); print(cursor.fetchone()); conn.close()"
```
Expected: `(17, 'DMR Test', 2, 16777215)`

5. **Verify Hardware Message:**
```powershell
adb logcat -d | Select-String "sendDigitalMessage DEBUG.*DMR Test"
```
Expected: `contactType: 2 (0=PERSON, 1=GROUP, 2=ALL)`

6. **Test Group Call Reception:**
   - Transmit on TG 64067 or 55301
   - Check if audio is received
   - Check logs for incoming traffic

7. **Toggle OFF:**
   - Tap "MONITOR: ON" button
   - Should change to "MONITOR: OFF"
   - Toast: "Monitoring Mode: OFF (filtered to group list)"
   - Verify database shows `contactType = 1` again

8. **Persistence Test:**
   - Toggle to ON
   - Force-stop app: `adb shell "am force-stop com.pri.prizeinterphone"`
   - Reopen app, go to channel 17
   - Toggle should still show "MONITOR: ON"

---

## Troubleshooting

### Toggle Doesn't Appear

**Check hook installation:**
```powershell
adb logcat -d | Select-String "Successfully hooked InterPhoneTalkBackFragment"
```

**Check for errors:**
```powershell
adb logcat -d | Select-String "MonitoringMode.*Error"
```

**Common causes:**
- LSPosed module not enabled: Settings → LSPosed → Modules → DMRModHooks
- Scope not set: Settings → LSPosed → Modules → DMRModHooks → Enable for com.pri.prizeinterphone
- Build error: Check compilation logs
- Layout conflict: Check if TalkBack fragment layout changed

### Toggle Doesn't Change State

**Check click handler:**
```powershell
adb logcat | Select-String "MonitoringMode toggle clicked"
```

**Check for reflection errors:**
```powershell
adb logcat | Select-String "MonitoringMode.*Error in toggle handler"
```

**Manual verification:**
```powershell
# Check if database actually updated
adb pull /data/data/com.pri.prizeinterphone/databases/database_channel_area_default_uhf.db
python -c "import sqlite3; conn = sqlite3.connect('database_channel_area_default_uhf.db'); cursor = conn.cursor(); cursor.execute('SELECT channel_contactType, channel_txContact FROM database_channel_area_default_uhf WHERE channel_number = 17'); print(cursor.fetchone()); conn.close()"
```

### Toggle Works But No Audio

**This means ALL mode still doesn't work on the hardware.**

Hardware debugging:
```powershell
# Monitor for any hardware acknowledgment
adb logcat | Select-String "DigitalMessage|sendDigitalMessage|Hardware|Module"
```

**CRITICAL**: If toggling works (database updates, hardware message sent) but still no group call audio, the hardware module likely has the same bug for ALL mode as it does for GROUP mode.

---

## Alternative Solutions (If ALL Mode Fails)

### 1. Packet Interception (Advanced)

Hook `DigitalMessage.encodeBody()` to modify the packet before sending:

```java
private void hookDigitalMessageEncoding(XC_LoadPackage.LoadPackageParam lpparam) {
    try {
        Class<?> digitalMessageClass = XposedHelpers.findClass(
            "com.pri.prizeinterphone.message.DigitalMessage",
            lpparam.classLoader
        );
        
        XposedHelpers.findAndHookMethod(
            digitalMessageClass,
            "encodeBody",
            new XC_MethodHook() {
                @Override
                protected void afterHookedMethod(MethodHookParam param) throws Throwable {
                    // Get the encoded byte array
                    byte[] packet = (byte[]) param.getResult();
                    
                    // Byte 144 = contactType
                    // Force to 2 (ALL mode) if monitoring enabled
                    if (isMonitoringMode && packet.length >= 145) {
                        packet[144] = 2; // Force ALL mode
                        param.setResult(packet);
                        XposedBridge.log(TAG + ": Forced contactType=2 in packet");
                    }
                }
            }
        );
    } catch (Throwable t) {
        XposedBridge.log(TAG + ": Error hooking encodeBody: " + t.getMessage());
    }
}
```

**Risk**: Packet corruption if offset wrong, may brick hardware temporarily.

### 2. Software-Based Group Filtering

Instead of hardware filtering, implement software filtering in PCMReceiveManager:

```java
// In hookPCMReceiveManager afterHookedMethod:
if (currentCallerDmrId != 0) {
    // Check if caller's TG is in our group list
    int[] groups = getCurrentChannelGroups(); // Implement helper
    boolean inGroup = false;
    for (int tg : groups) {
        if (tg == currentCallerDmrId) {
            inGroup = true;
            break;
        }
    }
    
    if (!inGroup && !isMonitoringMode) {
        // Mute audio by zeroing buffer
        java.util.Arrays.fill(shorts, (short) 0);
        XposedBridge.log(TAG + ": Filtered out TG " + currentCallerDmrId);
    }
}
```

**Advantages:**
- No hardware dependency
- Flexible filtering rules
- Can implement whitelist/blacklist

**Disadvantages:**
- CPU overhead
- All audio still received (battery drain)
- May miss start of transmission (buffering delay)

### 3. Firmware Reverse Engineering (Expert Only)

If you have JTAGaccess or firmware dumps:
1. Reverse engineer DMR module firmware
2. Find RX group list handling code
3. Patch to respect groupList field
4. Flash modified firmware

**⚠️ WARNING**: High risk of bricking device. Requires:
- Firmware dump/access
- ARM assembly knowledge
- JTAG debugger
- Recovery method (unbrick)

### 4. Hardware Replacement

**Known working models** (community reports):
- TYT MD-398 (confirmed working RX groups)
- Motorola DP4800 (commercial, expensive)
- Anytone D878UV (ham radio, may need mods)

**Research before buying:**
- Check XDA forums for PriInterPhone compatibility
- Verify DMR chipset model
- Confirm RX group list support

---

## Success Criteria

### Minimum Viable Testing
- [ ] Toggle appears and is clickable
- [ ] Database updates on toggle
- [ ] Hardware message sent with updated contactType
- [ ] No crashes or errors

### Full Feature Testing
- [ ] Toggle state persists across app restart
- [ ] Toggle disabled on analog channels
- [ ] Group calls received when monitoring ON
- [ ] Private calls work in both modes
- [ ] TX functionality unaffected

### Production Ready
- [ ] Tested on multiple channels
- [ ] Tested with different talkgroups
- [ ] Battery impact assessed
- [ ] Documentation complete
- [ ] User feedback collected

---

## Next Steps

### If ALL Mode Works:
1. ✅ Implement toggle (already done)
2. Add per-channel monitoring state memory
3. Add visual indicator (color change, icon)
4. Integrate with transcription service
5. Share on XDA/GitHub

### If ALL Mode Fails:
1. ⚠️ Document hardware limitation
2. Implement software filtering (option 2 above)
3. Research firmware patching (if confident)
4. Contact Ulefone support with logs
5. Consider hardware replacement

### Community Contribution:
- Share findings on XDA forums
- Create GitHub repo with code
- Write detailed hardware compatibility wiki
- Help others with same issue

---

## Logs to Collect for Support

If requesting help, provide these logs:

```powershell
# Full hook installation log
adb logcat -d | Select-String "DMRModHooks" > dmr_hooks_full.log

# Database state
adb pull /data/data/com.pri.prizeinterphone/databases/database_channel_area_default_uhf.db
python -c "import sqlite3; conn = sqlite3.connect('database_channel_area_default_uhf.db'); cursor = conn.cursor(); cursor.execute('SELECT * FROM database_channel_area_default_uhf WHERE channel_number = 17'); print(cursor.fetchone()); conn.close()" > channel17_config.txt

# Hardware message logs
adb logcat -d | Select-String "sendDigitalMessage DEBUG" > hardware_messages.log

# Device info
adb shell "getprop ro.product.model" > device_info.txt
adb shell "getprop ro.build.version.release" >> device_info.txt
adb shell "pm list packages | grep prizeinterphone" >> device_info.txt
```

---

**Good luck! If you need any clarification or run into issues, let me know the specific error logs.**
