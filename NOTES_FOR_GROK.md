# NOTES FOR GROK - DMR Firmware Patching Challenge

**URGENT**: Hardware-level blocker discovered after successful firmware patch. Seeking collaboration ideas.

## Current Crisis: Firmware Reload Catch-22

**Date**: March 6, 2026  
**Previous Problem**: DMR group ID extraction bug (SOLVED ✅ - PATCH14.bin works)  
**New Problem**: YModem upload corrupts radio hardware, only device reboot fixes it (which loses RAM-only patch)  
**Time Invested**: 9 failed recovery attempts (100% failure rate)  
**Status**: Feature works perfectly except radio becomes unusable after load

---

## 🎯 The Goal

Load a runtime firmware patch into the DMR radio module to fix bugs without:
1. Permanently modifying firmware (warranty concerns)
2. Requiring complex hardware modifications
3. Breaking radio functionality after load

---

## ✅ What We've Successfully Achieved

### Working Firmware Patch (PATCH14.bin)
- **File**: 378,620 bytes
- **Modification**: Address 0x08018F2C: `BLS` → `NOP` (2 bytes)
- **Bug Fixed**: Incorrect group ID extraction (contactType=2 reads wrong bytes)
- **Verification**: Patch works perfectly when loaded
- **Evidence**: `txContact` changes from 1 (buggy) to 11904 (correct) after patch

### Working YModem Upload
- **Method**: Copy PATCH14.bin → `/sdcard/DMR/DMRDEBUG.bin`
- **Transfer**: Launch UpdateFirmwareActivity → YModem protocol uploads to radio
- **Duration**: ~2 minutes (378KB at hardware serial speeds)
- **Success Rate**: 9/9 successful uploads (100%)
- **Target**: Radio module RAM (not flash storage)

### Working One-Tap Button
- **Location**: Device → Information page → "DMR Patch" button
- **Automation**: Copies file, launches activity, triggers upload
- **User Experience**: One tap, wait 2 minutes, done

---

## ❌ The Critical Problem

**After YModem upload completes, the radio hardware enters a corrupted state:**

### Symptoms
```
Logcat evidence from Test 9 (13:39:40):
03-06 13:39:41.614 E CmdStateMachine: set channel no reply, send again
03-06 13:39:42.619 E CmdStateMachine: SetChannelState processMessage..... MSG_SET_CHANNEL_ERROR
```

- Radio module stops responding to UART commands
- Cannot change channels (infinite "no reply" retries)
- Cannot receive transmissions
- Cannot transmit
- UI stays functional (no crashes or black screens after Test 9 improvements)
- App responds normally, but radio hardware is completely hung

### Root Cause Theory
YModem firmware upload process corrupts internal radio hardware state that software cannot recover from. The corruption is at a hardware/firmware level below what UART commands can reset.

---

## 🔒 The Catch-22

This creates an impossible situation:

1. **Load firmware patch** → YModem succeeds, patch in RAM ✅
2. **Radio hardware hangs** → Cannot use radio ❌
3. **Reboot device to fix radio** → Clears RAM, loses patch ❌
4. **Back to buggy firmware** → Feature is useless ❌

**The only thing that fixes the radio hang is a device reboot, which loses the RAM-only patch.**

---

## 🔬 What We've Tried (9 Attempts)

### Test 1-3: App Restart Approaches
**Method**: Restart activity or app after upload
- Activity.recreate() with delays (500ms, 3000ms)
- Process.killProcess() for clean restart

**Results**:
- ❌ StateMachine crashes (Tests 1-3)
- ❌ Black screen on auto-restart (Tests 4-5)
- ❌ Infinite loops (Test 6)

### Test 4-8: Automatic Cleanup + Navigation
**Methods**:
- Process termination + automatic app restart
- SharedPreferences flags + activity.recreate()
- Intent navigation to home activity
- Simple activity.finish() with natural backstack

**Results**:
- ❌ Black screen after app restart (fragments don't initialize)
- ⚠️ Test 7: Full DMR boot sound played (firmware loaded!) but radio hung anyway
- ❌ UI corruption persists until device reboot

### Test 9: DMR Hardware Reinitialization
**Method**: After YModem, call DMR manager reinitialization methods
```java
// Executed after YModem SUCCESS
DmrManager.getInstance().sendQueryInitializedCmdToMdl();  // Query module status
DmrManager.getInstance().sendSetChannelCmdToMdl();        // Resend channel config
```

**UART Evidence**:
```
13:36:24.751 - UART TX cmd=39 (QueryInit)
13:36:25.256 - UART TX cmd=34 (SetChannel)
13:36:25.244 - ✓ DMR module reinitialized - firmware patch active
```

**Results**:
- ✅ Firmware patch loaded correctly (`txContact=11904`)
- ✅ No crashes or black screens (major progress!)
- ✅ UI fully functional
- ❌ Radio hardware STILL hung (cannot change channels)
- ❌ "set channel no reply" errors when user tries to switch channels

**Conclusion**: Software reinitialization is not sufficient to recover hardware state.

---

## 🤔 Questions for Collaboration

### 1. Hardware Reset Commands
**Question**: Are there UART commands that can perform a "soft reset" of the radio hardware without a full device reboot?

**What we know**:
- Command 39: Query initialization status (we tried this)
- Command 34: Set channel (we tried this)
- Command 35: Interrupt transmit

**What we need**:
- Hardware reset command
- UART protocol "restart" sequence
- Firmware reboot command (that preserves RAM?)

**Where to look**:
- UpdateFirmwareActivity.java - YModem implementation
- SerialManager.java - UART protocol layer
- Radio module hardware documentation (if available)

### 2. Alternative Firmware Loading Methods
**Question**: Is there a way to load firmware that doesn't corrupt the hardware state?

**Ideas to explore**:
- Load firmware BEFORE radio initializes (at boot time?)
- Different YModem transfer parameters
- Alternate UART protocols the hardware supports
- Memory-mapped I/O instead of YModem

### 3. Persistent RAM Solutions
**Question**: Can we keep the patch in RAM across a radio hardware reset?

**Ideas**:
- Does the radio module have separate power domains?
- Can we trigger just the radio to reset without clearing its RAM?
- Are there kernel-level tricks to preserve specific memory regions?

### 4. Permanent Patching
**Question**: Should we just patch the actual firmware flash instead?

**Trade-offs**:
- ✅ Would work perfectly (patch survives reboots)
- ✅ No reload button needed
- ❌ Warranty concerns
- ❌ Risk of bricking device
- ❌ OTA updates would revert patch
- ❌ More complex to implement

**Is there a safe way to patch flash storage?**

### 5. Timing/Sequencing Issues
**Question**: Is the hardware hang due to improper timing after YModem?

**Things we haven't tried**:
- Much longer delays (30+ seconds) before reinit
- Specific command sequences to "wake up" radio
- Sending dummy commands to clear UART buffers
- Toggling radio power via kernel interfaces

### 6. Hardware Documentation
**Question**: Where can we find technical documentation for this radio module?

**What we need**:
- Full UART command protocol specification
- Hardware reset procedures
- Firmware upload best practices
- Radio module chipset datasheet

**Known info**:
- Device: Ulefone Armor 26 Ultra
- App: PriInterPhone (com.pri.prizeinterphone)
- Radio: DMR/Analog dual-mode (unknown chipset)
- Communication: UART serial @ /dev/ttyS1 or similar

### 7. Magisk Module Approach
**Question**: Could a Magisk module help at boot time?

**Ideas**:
- Load patched firmware during early boot (before app starts)
- Intercept kernel-level radio initialization
- Modify device tree to change firmware loading
- Boot script that loads PATCH14.bin

### 8. Kernel Module / Driver Hooks
**Question**: Can we go deeper than LSPosed?

**Possibilities**:
- Kernel module that hooks UART driver
- Intercept firmware loading at kernel level
- Modify radio driver to load our patch
- SELinux policy changes to enable different approaches

### 9. Power Management
**Question**: Can we use power management to reset just the radio hardware?

**Ideas to explore**:
- `/sys/class/` power control interfaces
- Kernel PM (power management) subsystem
- Radio-specific power domains in device tree
- PMIC (power management IC) controls

### 10. JTAG/SWD Debugging
**Question**: Can we use hardware debugging to understand the hang?

**Possibilities**:
- JTAG connection to radio module (if accessible)
- Memory dumps before/after YModem
- Register state analysis
- Real-time debugging during firmware load

---

## 📊 Technical Environment

### Device Specifications
- **Model**: Ulefone Armor 26 Ultra
- **Android**: 13
- **Root**: Magisk v24+ with Zygisk
- **Framework**: LSPosed v1.9.2+ (Zygisk variant)
- **Radio**: DMR + Analog FM dual-mode

### Code Access
- **Target App**: PriInterPhone (system app, can decompile)
- **Hooks**: LSPosed/Xposed (runtime Java method hooking)
- **Root Access**: Full (can modify system, kernel, etc.)
- **Source Code**: Decompiled Java available (no native/firmware source)

### Constraints
- Cannot require hardware modifications
- Should avoid warranty-voiding permanent changes (if possible)
- Must work without manufacturer cooperation
- User should not need technical expertise to use feature

---

## 💡 What Would Success Look Like?

**Ideal outcome**: User presses "DMR Patch" button, waits 2 minutes, radio works perfectly with patched firmware until next device reboot.

**Acceptable outcome**: User presses button, follows simple procedure (maybe reboot with special timing?), radio works with patch.

**Minimum viable**: We understand WHY it doesn't work and document the limitation clearly.

---

## 🗂️ Relevant Files

### Firmware
- `DMR003.UV4T.V022-PATCH14.bin` (patched, 378,620 bytes)
- `DMR003.UV4T.V022.bin` (original)
- Device location: `/sdcard/DMR/PATCH14_BACKUP.bin`

### Code
- `DMRModHooks\app\src\main\java\com\dmrmod\hooks\MainHook.java` (LSPosed hooks)
- `DMRModHooks\app\src\main\java\com\dmrmod\hooks\PatchReloadHelper.java` (reload button)
- Decompiled app: Ghidra project with full analysis

### Documentation
- Test logs: 9 complete test cycles documented
- Build config: `DMRModHooks\app\build.gradle`
- Project notes: Various NOTES_*.md files

---

## 🤝 How You Can Help

1. **Ideas**: Any suggestions for hardware reset commands or alternative approaches?
2. **Similar Projects**: Have you seen this problem solved elsewhere (ham radio, IoT, embedded)?
3. **Documentation**: Know where to find technical docs for DMR radio modules?
4. **Alternative Approaches**: Are we thinking about this wrong? Different angle?
5. **Kernel/Driver Knowledge**: Should we be working at a lower level?
6. **Risk Assessment**: Is permanent flash patching worth considering?
7. **Power Management**: Can we reset radio hardware via sysfs or kernel interfaces?
8. **Community Contacts**: Know anyone with Ulefone/radio module expertise?

---

## 📝 Key Observations

- Patch verification works perfectly: `txContact` shows correct value (11904) after upload
- Test 7 proved firmware DOES load correctly (full DMR boot sound played)
- Radio hardware corruption happens DURING or immediately AFTER YModem transfer
- Software-level reinitialization (Test 9) is insufficient to recover hardware
- Physical device reboot is currently the ONLY thing that recovers radio hardware
- We're stuck in a catch-22: reboot fixes radio but loses RAM-only patch

**Test 7 is particularly interesting**: The full DMR boot sound (which only plays after successful firmware init) proves the firmware IS loading and initializing correctly. But then the hardware immediately becomes unresponsive to further commands.

This suggests the problem might be:
- YModem leaves UART/serial in bad state
- Firmware boots but enters wrong mode/state
- Hardware watchdog or protection triggered
- Power management issue (radio enters low power mode?)

---

## 🔍 Areas Needing Investigation

1. **YModem Protocol Details**
   - Does normal firmware update process have post-upload reset sequence?
   - Are there YModem parameters we're missing?
   - Does official app do something after YModem we're not seeing?

2. **UART State Management**
   - Does UART buffer need flushing after YModem?
   - Is there a UART reset command?
   - Better timing between commands?

3. **Radio Module Chipset**
   - What actual chipset is used? (Can we identify from firmware strings?)
   - Manufacturer documentation?
   - Known issues with firmware upload?

4. **Kernel/Driver Level**
   - What kernel driver handles the radio UART?
   - Can we see kernel logs during YModem?
   - Are there driver IOCTLs we can use?

5. **Power Management**
   - Does radio have separate power rail we can toggle?
   - Runtime PM in kernel for this device?
   - Can we force power cycle without full reboot?

---

## 💭 Wild Ideas Worth Considering

1. **Intercept at Boot**: Magisk module that loads patched firmware during early boot before radio init
2. **Dual Firmware**: Keep both versions in memory, hot-swap between them
3. **Kernel Patch**: Modify kernel to load our firmware instead of stock
4. **Watchdog Reset**: Trigger hardware watchdog to reset radio without full reboot
5. **Suspend/Resume**: Use power management to suspend radio, reload firmware, resume
6. **JTAG Injection**: If JTAG accessible, inject patch directly into running firmware
7. **Flash Overlay**: Use overlayfs-style approach at flash level (if possible)
8. **Bootloader Modification**: Have bootloader load patched firmware

---

## ❓ Specific Technical Questions

1. **Can we identify the radio chipset?**
   - Strings in firmware binary
   - Physical inspection of board
   - Driver names in kernel

2. **What happens in normal firmware update?**
   - Does official update process have different YModem parameters?
   - Post-upload commands we're missing?
   - Different UART configuration?

3. **Is there a "soft reset" command?**
   - UART command to reset radio without power cycle
   - Some test/debug command we haven't found?

4. **Can we preserve RAM through power cycle?**
   - Kernel memory preservation tricks
   - Hibernate-style RAM retention

5. **What's the real hardware architecture?**
   - Separate radio SoC or integrated?
   - Separate power domain?
   - Bus topology (UART only or also SPI/I2C)?

---

**Bottom Line**: We can load the patch successfully and it works, but the upload process corrupts radio hardware in a way that only a full device reboot can fix—which loses our RAM-only patch. We need either:

1. **Hardware reset without device reboot** (preferred)
2. **Load firmware without corrupting hardware** (ideal)
3. **Make patch survive reboot** (permanent flash patching)

Any insights, ideas, or collaboration offers welcome! 🙏

---

## 🎯 EXPERT COLLABORATION RESPONSE (March 6, 2026)

**From**: Technical collaboration feedback  
**Status**: Actionable strategies identified - ready to implement

### Root Cause Analysis (Confirmed)
The hang pattern is **common in embedded UART-bootloader flows on Cortex-M devices**:
- YModem process leaves peripheral in inconsistent state
- Common causes: Overrun errors, framing issues, stuck DMA, firmware limbo state
- Test 7 boot sound = firmware partially initializes, then stops responding
- Likely: UART re-init failure, interrupt storm, or power/watchdog glitch

### Hardware Insights (Researched)
**Main SoC**: MediaTek Dimensity 8020 (confirmed from reviews)  
**DMR Module**: Separate UART-connected transceiver
- Dual-band VHF/UHF (137-172 MHz / 400-470 MHz)
- 4-5W output power
- Likely chipset: Beken BK4819/BK1080 or HR-C6000 variant
- Firmware: uC/OS-III on Cortex-M (STM32F4/GD32F4 clone)
- **UART**: /dev/ttyS0 or ttyS1 (kernel driver: mtk-uart)

---

## 🚀 PRIORITY ACTION PLAN

### Phase 1: Refined Post-YModem Recovery (TEST IMMEDIATELY)

#### Action 1A: Aggressive UART Buffer Flushing
**Priority**: HIGHEST - Simple to implement, low risk

**Implementation**:
```java
// In UpdateFirmwareActivity hook after YModem success (step 32)
new android.os.Handler().postDelayed(new Runnable() {
    @Override
    public void run() {
        try {
            // Get SerialManager instance
            Class<?> serialManagerClass = XposedHelpers.findClass(
                "com.pri.prizeinterphone.manager.SerialManager",
                context.getClassLoader()
            );
            Object serialManager = XposedHelpers.callStaticMethod(
                serialManagerClass, "getInstance"
            );
            
            // Get InputStream if accessible (may need reflection)
            Object inputStream = XposedHelpers.getObjectField(serialManager, "mInputStream");
            
            if (inputStream != null) {
                // Flush/drain any pending garbage data
                int available = (int) XposedHelpers.callMethod(inputStream, "available");
                XposedBridge.log(TAG + ": Flushing " + available + " bytes from UART buffer");
                
                while ((int) XposedHelpers.callMethod(inputStream, "available") > 0) {
                    XposedHelpers.callMethod(inputStream, "read");
                }
                
                Thread.sleep(100); // Small delay after flush
                XposedBridge.log(TAG + ": UART buffer flushed");
            }
            
            // NOW do the reinitialization we tried in Test 9
            Class<?> dmrManagerClass = XposedHelpers.findClass(
                "com.pri.prizeinterphone.manager.DmrManager",
                context.getClassLoader()
            );
            Object dmrManager = XposedHelpers.callStaticMethod(dmrManagerClass, "getInstance");
            
            // Send no-op/query commands multiple times
            for (int i = 0; i < 3; i++) {
                XposedHelpers.callMethod(dmrManager, "sendQueryInitializedCmdToMdl");
                Thread.sleep(200); // 200ms between attempts
            }
            
            Thread.sleep(500);
            
            // Resend channel config
            XposedHelpers.callMethod(dmrManager, "sendSetChannelCmdToMdl");
            XposedBridge.log(TAG + ": UART flushed + repeated init queries complete");
            
        } catch (Throwable t) {
            XposedBridge.log(TAG + ": UART flush/reinit failed: " + t.getMessage());
        }
    }
}, 2000); // 2 second delay after YModem
```

**Test**: Build, install, reboot, try firmware reload. Monitor for "no reply" errors.

---

#### Action 1B: Power-Cycle Radio Domain Only
**Priority**: HIGH - No device reboot, preserves Android state

**Investigation Steps**:
```bash
# Find radio power regulators
adb shell "cat /sys/class/regulator/*/name | grep -i 'radio\|dmr\|rf'"
adb shell "dmesg | grep -i 'regulator.*radio'"
adb shell "ls /sys/class/regulator/"

# Look for likely candidates (regulator.X where X is number)
adb shell "cat /sys/class/regulator/regulator.*/name"
```

**If regulator found** (e.g., regulator.5 = "vdd-radio"):
```bash
# Toggle power (after YModem success)
adb shell "echo 0 > /sys/class/regulator/regulator.5/state"
sleep 2
adb shell "echo 1 > /sys/class/regulator/regulator.5/state"
sleep 1
# App should re-init radio automatically
```

**Integration**: Add to MainHook if regulator identified:
```java
// After YModem, before reinit
Runtime.getRuntime().exec("su -c 'echo 0 > /sys/class/regulator/regulator.5/state'");
Thread.sleep(2000);
Runtime.getRuntime().exec("su -c 'echo 1 > /sys/class/regulator/regulator.5/state'");
Thread.sleep(1000);
// Then continue with DMR reinit
```

---

#### Action 1C: Suspend/Resume UART Driver
**Priority**: MEDIUM - May reset UART state

**Test Manually**:
```bash
# Find UART device node
adb shell "ls -la /dev/ttyS*"
adb shell "ls /sys/bus/platform/devices/ | grep tty"

# Try runtime PM control (after YModem)
adb shell "echo auto > /sys/bus/platform/devices/[uart-device]/power/control"
sleep 1
adb shell "echo on > /sys/bus/platform/devices/[uart-device]/power/control"
```

**If successful**, integrate into hook similar to regulator approach.

---

#### Action 1D: Send Module Reset Command
**Priority**: MEDIUM - Requires finding the command

**Investigation**:
1. Search decompiled app for reset/reboot commands:
   ```bash
   grep -r "reset\|reboot\|restart" decompiled/ --include="*.java"
   ```

2. Look for command values 0x00, 0xFF, or test commands:
   ```bash
   grep -r "cmd.*0x00\|cmd.*0xFF" decompiled/ --include="*.java"
   ```

3. Check UpdateFirmwareActivity for post-YModem commands we're missing

**If found**: Send reset command after YModem, wait, then reinit.

---

### Phase 2: Magisk Early-Boot Loader (MEDIUM PRIORITY)

**Goal**: Load patch at boot BEFORE normal radio init (avoiding corruption)

**Implementation**:
1. Create Magisk module structure:
```bash
magisk-dmr-loader/
├── module.prop
├── service.sh
└── system.prop (optional)
```

2. **module.prop**:
```ini
id=dmr_patch_loader
name=DMR Patch Auto-Loader
version=v1.0
versionCode=1
author=IIMacGyverII
description=Automatically loads DMR firmware patch on boot
```

3. **service.sh** (runs after boot):
```bash
#!/system/bin/sh
MODDIR=${0%/*}

# Wait for system to settle
sleep 30

# Copy patch to expected location
cp /sdcard/DMR/PATCH14_BACKUP.bin /sdcard/DMR/DMRDEBUG.bin

# Wait for app to start
sleep 10

# Trigger firmware update activity
am start -n com.pri.prizeinterphone/.activity.UpdateFirmwareActivity

# Logs
echo "$(date): DMR patch loader triggered" >> /sdcard/DMR/boot_loader.log
```

4. Flash via Magisk Manager, test on next reboot

**Advantage**: Loads patch every boot automatically, no manual intervention. If timing avoids corruption, problem solved.

---

### Phase 3: Kernel-Level Debugging (LOW PRIORITY - If above fails)

#### Investigate UART Errors During YModem
```bash
# Clear kernel log
adb shell dmesg -c

# Start YModem upload (via app)
# ...wait for completion...

# Check kernel logs for UART errors
adb logcat -b kernel | grep -i "uart\|tty\|overrun\|frame"
adb shell dmesg | grep -i "uart\|serial\|error"
```

Look for:
- Buffer overruns
- Framing errors
- Timeout messages
- DMA issues

#### Find UART Driver Source
MediaTek kernel sources may be available:
- Search GitHub for "mt6983 uart" or "mtk uart driver"
- Look for IOCTLs or reset procedures in driver code

---

### Phase 4: Permanent Flash Patching (LAST RESORT)

**Only if all recovery attempts fail**

**Tools Needed**:
- MTKClient (if MediaTek Dimensity supports it)
- Full device dump (bootloader, vendor, etc.)
- Scatter file for partition layout

**Risk**: High (potential brick), but recoverable with full dump backup

**NOT recommended yet** - exhaust software recovery first.

---

## 📋 TEST CHECKLIST

### Immediate Tests (This Session)
- [ ] **Test 10**: UART buffer flush + repeated QueryInit (Action 1A)
- [ ] Find radio power regulator in sysfs (Action 1B investigation)
- [ ] Find UART device in sysfs for PM control (Action 1C investigation)
- [ ] Search app for reset commands (Action 1D investigation)

### Next Session Tests
- [ ] **Test 11**: Power-cycle regulator if found
- [ ] **Test 12**: UART suspend/resume if device found
- [ ] **Test 13**: Send reset command if found
- [ ] **Test 14**: Magisk boot loader module

### Long-Term
- [ ] Kernel-level UART debugging if recovery fails
- [ ] Consider permanent flash patching if RAM approach impossible

---

## 🎓 Key Learnings

1. **Test 7 boot sound is critical data**: Proves firmware loads and partially initializes
2. **Pattern is well-known**: Cortex-M UART bootloader post-YModem hangs are common
3. **Hardware architecture clarified**: Separate DMR module on UART, MTK Dimensity main SoC
4. **Recovery paths exist**: UART flush, power domain reset, boot-time loading all viable
5. **Not a dead end**: Multiple software solutions before considering permanent flash mod

---

## 📞 Contact & Collaboration

**Project**: [phonedmrapp on GitHub](https://github.com/IIMacGyverII/phonedmrapp)  
**Developer**: IIMacGyverII  
**Community**: XDA-Developers, r/ReverseEngineering

**Special Thanks**: Technical collaboration from embedded systems experts

**Next Steps**: Implementing Action 1A (UART flush + repeated queries) - Test 10 incoming! 🚀
