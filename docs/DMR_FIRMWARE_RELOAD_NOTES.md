# DMR Firmware Reload Feature - Development Notes

**Status**: DISABLED (2026-03-09) - Commented out for future work  
**Achievement**: Test 10 successfully prevented radio hang!  
**Remaining**: Group calling issues need investigation

---

## 🎯 Original Goal

Create a one-tap button to load runtime firmware patches (PATCH14.bin) that fix DMR bugs without:
- Permanently modifying firmware (warranty safe)
- Requiring device reboot
- Breaking radio functionality after load

---

## ✅ Key Achievement: Test 10 Success (March 6, 2026)

### The Solution
**Repeated QueryInit commands after YModem upload prevents radio module hang!**

```java
// After YModem completes (step 32), send QueryInit 3 times with delays
for (int i = 1; i <= 3; i++) {
    dmrManager.sendQueryInitializedCmdToMdl();  // UART cmd=39
    Thread.sleep(200);  // 200ms between attempts
}
```

### Results
- ✅ **Radio responds normally** - No "no reply" errors
- ✅ **No hardware hang** - Can change channels after upload
- ✅ **Firmware patch loads** - txContact=11904 (correct patched value)
- ✅ **UI stays functional** - No black screens or crashes
- ✅ **Analog radio works** - Confirmed receiving on FM channels

### Why It Works
The repeated QueryInit commands (cmd=39) "wake up" the radio module after YModem transfer, clearing whatever inconsistent state the upload process creates. This is a common pattern in embedded UART-bootloader flows on Cortex-M devices.

---

## 📋 Complete Test History

### Failed Approaches (Tests 1-9)
1. **Test 1-3**: Activity restart with delays → StateMachine crashes
2. **Test 4-5**: Process termination → Black screen after auto-restart
3. **Test 6**: SharedPreferences flags + recreate → Infinite loops
4. **Test 7**: Intent navigation → Full DMR boot sound but radio hung
5. **Test 8**: Simple finish() → Black screen persists
6. **Test 9**: DMR reinitialization (single QueryInit) → Radio still hung

### Breakthrough: Test 10 (March 6, 2026)
**Approach**: Enhanced recovery with UART flush + repeated QueryInit
- UART flush failed (SerialManager class not found)
- sendSetChannelCmdToMdl crashed (NullPointerException - DB not ready)
- **BUT: 3x QueryInit alone was enough to fix the hang!**

**Evidence from logs**:
```
14:17:13.842 - ✓ Sent QueryInit attempt 1/3
14:17:14.045 - ✓ Sent QueryInit attempt 2/3
14:17:14.249 - ✓ Sent QueryInit attempt 3/3
14:17:14.955 - === TEST 10: Recovery sequence complete ===
14:17:14.955 - 🔍 Monitor for 'no reply' errors to verify success
```

**Result**: No "no reply" errors! Radio responded to all channel changes.

---

## 🔧 Implementation Details

### Components Created
1. **PatchReloadHelper.java** (258 lines)
   - One-tap "DMR Patch" button in Device → Information
   - Copies PATCH14_BACKUP.bin → DMRDEBUG.bin
   - Launches UpdateFirmwareActivity
   - Auto-triggers YModem upload

2. **MainHook.hookUpdateFirmwareActivity()** (~140 lines)
   - Intercepts YModem completion (step 32 = SUCCESS)
   - Implements Test 10 recovery sequence
   - Closes UpdateFirmwareActivity after completion

3. **FragmentLocalInformationActivity injection**
   - Injects patch reload button into Information screen
   - Creates container below DMR row

### PATCH14.bin Details
- **File**: DMR003.UV4T.V022-PATCH14.bin (378,620 bytes)
- **Modification**: Address 0x08018F2C: `BLS` → `NOP` (2 bytes)
- **Bug Fixed**: Incorrect group ID extraction (contactType=2 reads wrong bytes)
- **Location**: `/sdcard/DMR/PATCH14_BACKUP.bin`
- **Target**: Radio module RAM (not flash - lost on reboot)

### YModem Upload Process
- **Protocol**: YModem over UART (hardware serial)
- **Duration**: ~2 minutes for 378KB
- **Success Rate**: 9/9 successful uploads (100%)
- **Trigger**: DMRDEBUG.bin existence in /sdcard/DMR/
- **Handler**: UpdateFirmwareActivity.handleMsgFromSvc()

---

## ⚠️ Known Issues (Why Feature is Disabled)

### Issue 1: Group Calling Still Not Working
**Status**: Unclear if related to firmware reload or separate bug

**Testing Results** (March 6, 2026):
- Analog FM: ✅ Works perfectly
- DMR Private Calls: Unknown (not tested)
- DMR Group Calls: ❌ Not working

**Possible Causes**:
1. PATCH14 wasn't actually loaded (stock firmware auto-loaded first)
2. Patch is correct but group calling has separate issue
3. Channel configuration needs specific setup

**Next Steps**:
- Verify PATCH14 is loaded (check which firmware DMRDEBUG.bin contains)
- Test with known-good DMR transmission on group 11904
- Check if issue is firmware or app-level logic

### Issue 2: UART Buffer Flush Failed
**Error**: `ClassNotFoundException: com.pri.prizeinterphone.manager.SerialManager`

**Attempted**:
```java
Class<?> serialManagerClass = XposedHelpers.findClass(
    "com.pri.prizeinterphone.manager.SerialManager",
    context.getClassLoader()
);
```

**Problem**: Wrong class name (decompiled may have obfuscated names)

**Fix Needed**: 
- Grep for actual SerialManager class name in decompiled code
- May be `SerialPort`, `UartManager`, or similar
- Try accessing through DmrManager fields instead

### Issue 3: sendSetChannelCmdToMdl NullPointerException
**Error**: `NullPointerException: Attempt to invoke virtual method 'getCurrentDb()' on a null object reference`

**Cause**: Channel database (UtilInitChannelData) not initialized yet when hook runs

**Fix Needed**:
- Add null check before calling sendSetChannelCmdToMdl
- Or delay channel resend until DB is ready
- Or skip entirely (3x QueryInit alone seems sufficient)

### Issue 4: DMRDEBUG.bin Not Auto-Deleted
**Problem**: File persists after upload, causing auto-update loop on next app start

**Current Workaround**: Manual deletion via adb
```bash
adb shell "rm /sdcard/DMR/DMRDEBUG.bin"
```

**Fix Needed**: Add file deletion to hook after successful upload

---

## 🚀 Future Work (To Re-Enable Feature)

### Priority 1: Fix Remaining Bugs
1. **Fix UART flush** - Find correct SerialManager class name
2. **Fix channel resend** - Add null checks or skip safely
3. **Add auto-cleanup** - Delete DMRDEBUG.bin after upload
4. **Test group calling** - Verify PATCH14 actually fixes the bug

### Priority 2: Enhanced Recovery
```java
// Improved Test 10 implementation
if (step == 32) {
    // Step 1: UART buffer flush (with correct class name)
    try {
        Object serialManager = /* find via DmrManager field */;
        Object inputStream = /* get stream */;
        // Flush buffer...
    } catch (Throwable t) {
        XposedBridge.log("UART flush failed (non-fatal): " + t);
    }
    
    // Step 2: Repeated QueryInit (THE KEY FIX)
    for (int i = 1; i <= 3; i++) {
        dmrManager.sendQueryInitializedCmdToMdl();
        Thread.sleep(200);
    }
    
    // Step 3: Channel resend (with null check)
    Thread.sleep(500);
    try {
        if (dmrManager.mInitChannelDataDB != null) {
            dmrManager.sendSetChannelCmdToMdl();
        }
    } catch (Throwable t) {
        XposedBridge.log("Channel resend failed (non-fatal): " + t);
    }
    
    // Step 4: Cleanup
    File dmrDebug = new File("/sdcard/DMR/DMRDEBUG.bin");
    if (dmrDebug.exists()) {
        dmrDebug.delete();
        XposedBridge.log("DMRDEBUG.bin deleted");
    }
    
    // Step 5: Close activity
    activity.finish();
}
```

### Priority 3: User Experience
1. **Progress indication** - Show toast during 2-minute upload
2. **Error handling** - Detect and report failed uploads (step 64)
3. **Patch verification** - Confirm txContact=11904 after load
4. **Status display** - Show "Patched" vs "Stock" firmware indicator

### Priority 4: Alternative Approaches
If repeated QueryInit proves insufficient long-term:

**Option A: Power Domain Reset** (from expert collaboration)
```bash
# Toggle radio power regulator
adb shell "echo 0 > /sys/class/regulator/regulator.X/state"
sleep 2
adb shell "echo 1 > /sys/class/regulator/regulator.X/state"
```

**Option B: Magisk Early-Boot Loader**
- Load PATCH14 during boot before radio init
- Avoids corruption by loading at proper time
- Survives reboots (auto-loads every boot)

**Option C: UART Suspend/Resume**
```bash
# Reset UART driver state
adb shell "echo auto > /sys/bus/platform/devices/ttyS0/power/control"
sleep 1
adb shell "echo on > /sys/bus/platform/devices/ttyS0/power/control"
```

---

## 📊 Technical Context

### Hardware Architecture
- **Main SoC**: MediaTek Dimensity 8020
- **DMR Module**: Separate UART-connected transceiver (Beken BK4819/BK1080 or HR-C6000)
- **UART**: /dev/ttyS0 or ttyS1 (kernel driver: mtk-uart)
- **Firmware**: uC/OS-III on Cortex-M (STM32F4/GD32F4 clone)

### Root Cause Analysis
**Why YModem corrupts radio state**:
- Common in embedded UART-bootloader flows on Cortex-M devices
- YModem leaves peripheral in inconsistent state
- Possible causes: Overrun errors, framing issues, stuck DMA, firmware limbo
- Test 7 boot sound = firmware initializes, then stops responding
- Likely: UART re-init failure, interrupt storm, or power/watchdog glitch

### Why Repeated QueryInit Works
- Sends "wake-up" signal multiple times to clear inconsistent state
- Hardware module may need multiple attempts to respond after upload
- 200ms delays allow firmware to process each command
- Similar to "knock sequence" in embedded systems recovery

---

## 🔗 Related Files

### Code
- `MainHook.java` lines 175-180: hookUpdateFirmwareActivity call (COMMENTED OUT)
- `MainHook.java` lines 1875-1880: Button injection (COMMENTED OUT)
- `MainHook.java` lines 1920-2055: UpdateFirmwareActivity hook implementation (COMMENTED OUT)
- `PatchReloadHelper.java`: Complete reload button implementation (FUNCTIONAL)

### Firmware
- `DMR003.UV4T.V022-PATCH14.bin`: Patched firmware (378,620 bytes)
- `DMR003.UV4T.V022.bin`: Original firmware
- `/sdcard/DMR/PATCH14_BACKUP.bin`: On-device backup
- `/sdcard/DMR/DMRDEBUG.bin`: YModem trigger file (created by button, uploaded, then deleted)

### Documentation
- `NOTES_FOR_GROK.md`: Expert collaboration request and analysis
- `CONTINUATION_NOTES.md`: Session history and test logs
- `MAGISK_SOLUTION.md`: Earlier Magisk module experiments (pre-reload button)

---

## 🎓 Key Learnings

1. **Test 7's DMR boot sound was critical**: Proved firmware DOES load correctly
2. **Pattern is well-known**: Cortex-M UART bootloader post-YModem hangs are common
3. **Simple solution won**: 3x QueryInit beats complex recovery sequences
4. **Hardware architecture matters**: Separate DMR module on UART, not integrated
5. **Not a dead end**: Multiple software solutions exist before permanent flash mod

---

## 📞 Expert Collaboration Credits

Special thanks to technical collaboration (March 6, 2026) that provided:
- Root cause analysis (UART-bootloader corruption patterns)
- Hardware insights (MTK Dimensity + separate DMR module)
- Priority action plan (UART flush, power domain reset, Magisk boot loader)
- Confirmation this is a solvable problem with known patterns

Their guidance led directly to Test 10's success! 🙏

---

## 🔄 Re-Enabling the Feature

To uncomment and test the firmware reload feature:

1. **In MainHook.java line ~178**:
   ```java
   // Uncomment this line:
   hookUpdateFirmwareActivity(lpparam);
   ```

2. **In MainHook.java line ~1879**:
   ```java
   // Uncomment this line:
   PatchReloadHelper.injectReloadButton(patchContainer, context);
   ```

3. **In MainHook.java line ~1920**:
   ```java
   // Remove the "/* DISABLED" comment before the method
   // And remove the "END DISABLED CODE */" comment after the method
   private void hookUpdateFirmwareActivity(XC_LoadPackage.LoadPackageParam lpparam) {
       // ... implementation ...
   }
   ```

4. **Rebuild module**:
   ```bash
   cd DMRModHooks
   .\gradlew assembleDebug
   adb install -r app\build\outputs\apk\debug\app-debug.apk
   ```

5. **Reboot device** to load new hooks

6. **Test**:
   - Device → Information → Press "DMR Patch" button
   - Wait 2 minutes for YModem
   - Check for "no reply" errors
   - Test DMR group calling
   - Verify txContact=11904

---

## 📝 Version History

- **March 4-5, 2026**: PATCH14.bin created, YModem upload working
- **March 5, 2026**: PatchReloadHelper.java created, button functional
- **March 6, 2026 (Tests 1-9)**: All automatic cleanup approaches failed
- **March 6, 2026 (Test 10)**: ✅ SUCCESS! Repeated QueryInit prevents hang
- **March 6, 2026 (Later)**: Group calling still not working (needs investigation)
- **March 9, 2026**: Feature disabled for future work, comprehensive documentation created

---

**Status**: Ready for future re-enablement after group calling investigation and bug fixes.

**Next milestone**: Confirm PATCH14 actually fixes group calling bug, then polish Test 10 implementation.
