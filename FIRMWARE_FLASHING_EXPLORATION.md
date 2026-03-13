# Firmware Flashing Exploration - Permanent Patch Solution

**Date**: March 5, 2026  
**Device**: Ulefone Armor 26 Ultra  
**Radio Module**: HR_C6000 (ARM Cortex-M, uC/OS-III RTOS)  
**Firmware**: DMR003.UV4T.V022.bin (378,620 bytes)

---

## Current Situation Summary

### ✅ What We've Accomplished

**Bug Discovery**:
- Found firmware bug at address **0x08018F2C** (file offset 0x18F2C)
- Bug: BLS instruction branches when `contactType ≤ 2`, skipping group ID extraction
- Impact: DMR group calls report groupId=0xFFFFFF instead of actual ID (e.g., 11904)
- Result: Android app filters calls as invalid → no audio playback

**Patch Created**:
- **Patch 14**: Change 2 bytes at 0x18F2C
- Original: `0x0E 0xD9` (BLS - branch if lower/same)
- Patched: `0x00 0xBF` (NOP - no operation)
- Effect: Execution falls through to extraction code at 0x08018F2E
- Confidence: 95% (automated analysis scored 12/11, Ghidra verified)

**Deployment Success**:
- Created automated ARM Thumb disassembler (200+ lines PowerShell)
- Generated patched firmware binary (378,620 bytes, verified)
- Successfully loaded via YModem protocol (~2 minutes, 5+ successful transfers)
- Path: `/sdcard/DMR/DMRDEBUG.bin` → App auto-updates on startup

### ❌ The Problem: Patch Persistence

**Current Limitation**: Patch is stored in **radio module RAM only**

**Lost when**:
- Device reboots (full power cycle)
- Radio module resets independently
- Multiple app crashes/force-stops
- Clearing app data
- Extended periods of inactivity

**Evidence**:
```
// Patch loaded (working):
DigitalMessage{...txContact=11904...}  // Actual group ID

// Patch lost (bug returns):
DigitalMessage{...txContact=1...}      // Firmware bug signature
```

**Testing Cycles**:
1. Load 1 (17:04:35): Success → App crash → Radio reset → Patch lost
2. Load 2 (17:20:45): Success → App crash → Radio reset → Patch lost
3. Load 3 (17:35:20): Success → Force-stop → Radio reset → Patch lost
4. Load 4 (17:46:03): Success → Reboot → Radio reset → Patch lost
5. Load 5 (18:14:18): Success → App restart → Radio reset → Patch lost

**Pattern**: Every YModem transfer succeeds, but patch doesn't persist across radio resets.

---

## Technical Details for Firmware Flashing

### Device Architecture

**Main CPU**: MediaTek MT6989 (Android 13)
**Radio Module**: HR_C6000 DMR transceiver
- ARM Cortex-M4 microcontroller (likely STM32 or similar)
- Base address: 0x08000000 (typical STM32 flash start)
- RTOS: uC/OS-III
- Architecture: ARM Thumb (16-bit instructions, little-endian)

**Communication**:
- Main CPU ↔ Radio: UART serial protocol
- YModem protocol for firmware updates (128-byte blocks)
- Radio responds to CMD messages (0x2B for DMR status)

**Memory Map** (typical STM32):
```
0x08000000 - 0x080xxxxx: Flash memory (firmware storage)
0x20000000 - 0x200xxxxx: SRAM (runtime patch location)
```

**Current Update Process**:
1. Android app detects `/sdcard/DMR/DMRDEBUG.bin`
2. `UpdateFirmwareActivity` launches
3. YModem transfers 378,620 bytes over UART (~2 minutes)
4. Radio module loads firmware into **RAM** (0x20000000+)
5. Firmware executes from RAM, not flash
6. On reset, RAM cleared → firmware reloads from flash (original)

### Flash Memory Characteristics

**Flash Type** (likely):
- Internal STM32 flash (not external SPI flash)
- Size: 512KB - 1MB typical for Cortex-M4
- Write protection: Likely enabled for security
- Write granularity: 128 bytes to 2KB sectors
- Erase granularity: 16KB - 128KB sectors

**Our Patch**:
- Size: 2 bytes (0x0E 0xD9 → 0x00 0xBF)
- Location: 0x08018F2C (within 100KB of start)
- Sector: Would require erasing entire 16KB+ sector
- Risk: Must preserve surrounding firmware code

---

## Question 1: Can We Flash Directly via YModem?

**Current Behavior**: YModem loads to RAM, not flash

**Questions for Grok**:

1. **Is there a YModem command to write to flash instead of RAM?**
   - Does the HR_C6000 bootloader support flash write commands?
   - Can we send special UART commands before/after YModem transfer?
   - Are there documented flash write protocols for this radio module?

2. **Can we modify the DMRDEBUG.bin format to trigger flash write?**
   - Does the firmware file have headers indicating flash vs RAM load?
   - Are there bootloader magic bytes or flags we can set?
   - Can we embed flash commands in the firmware binary?

3. **Is there a "permanent update" mode in the Android app?**
   - Does `UpdateFirmwareActivity` have hidden parameters?
   - Are there developer/service modes for flash writes?
   - Can we hook deeper into the update process?

**Why This Would Be Ideal**:
- ✅ No hardware modifications needed
- ✅ Uses existing YModem infrastructure
- ✅ Reversible (can flash original back)
- ✅ Software-only solution

**Risks**:
- ⚠️ Bootloader might reject flash writes (security)
- ⚠️ Could brick radio if interruption occurs
- ⚠️ May require signing/checksums we can't generate

---

## Question 2: Can We Access Flash via UART Commands?

**Theory**: Radio module might accept direct flash commands

**Questions for Grok**:

1. **What UART commands does the HR_C6000 support?**
   - We know CMD 0x2B (status), CMD 0x39 (unknown)
   - Are there CMD 0xXX for flash operations?
   - Is there protocol documentation for this module?

2. **Can we use STM32 bootloader commands?**
   - If it's STM32-based, does it support standard bootloader protocol?
   - Commands like: 0x31 (Write Memory), 0x43 (Erase), 0x11 (Read Memory)
   - Can we enter bootloader mode via UART (BOOT0 pin low)?

3. **Can we script flash operations from Android?**
   - Send raw UART commands from our Xposed module
   - Sequence: Enter bootloader → Read flash → Modify → Write → Exit
   - Would need direct `/dev/tty*` access

**Implementation Path**:
```java
// In Xposed module
SerialPort radioPort = openRadioUART();

// Enter bootloader mode
radioPort.send(BOOTLOADER_ENTER_COMMAND);

// Read flash sector at 0x08018F2C
byte[] sector = radioPort.readMemory(0x08018000, 16384);

// Patch bytes
sector[0xF2C] = 0x00;  // BLS → NOP byte 1
sector[0xF2D] = 0xBF;  // BLS → NOP byte 2

// Erase sector
radioPort.eraseSector(0x08018000);

// Write modified sector
radioPort.writeMemory(0x08018000, sector);

// Exit bootloader
radioPort.send(BOOTLOADER_EXIT_COMMAND);
```

**Risks**:
- ⚠️ Unknown bootloader commands (might not be STM32)
- ⚠️ Erasing flash is destructive (can't undo easily)
- ⚠️ Timing critical (interruption = brick)

---

## Question 3: Hardware Debugging Methods

**If software methods fail, what hardware options exist?**

### Option A: JTAG/SWD Interface

**Questions for Grok**:

1. **How to locate JTAG/SWD pins on the radio module?**
   - Standard STM32 pinout: SWDIO, SWCLK, GND, VCC
   - Likely on PCB test points or unpopulated header
   - Can we use multimeter to probe for signals?

2. **What hardware debugger to use?**
   - ST-Link V2 (~$10 clone, $50 genuine)
   - J-Link EDU ($60)
   - Black Magic Probe (~$70)
   - Which is most compatible with unknown modules?

3. **Physical access requirements?**
   - Do we need to disassemble the phone?
   - Where is the radio module located (shielded?)
   - Can we access without voiding warranty?

**Workflow**:
1. Disassemble Ulefone Armor 26 Ultra
2. Locate HR_C6000 radio module
3. Identify SWD pins (SWDIO, SWCLK on PCB)
4. Solder wires to test points
5. Connect ST-Link debugger
6. Use OpenOCD or STM32CubeProgrammer
7. Read flash → Modify → Write back

**Advantages**:
- ✅ Direct flash access (100% control)
- ✅ Can dump entire firmware for analysis
- ✅ No bootloader restrictions
- ✅ Professional tools with safeguards

**Disadvantages**:
- ❌ Requires phone disassembly
- ❌ Soldering skills needed
- ❌ Risk of physical damage
- ❌ Voids warranty
- ❌ Time-consuming (~2-4 hours)

### Option B: External SPI Flash Programmer

**Questions for Grok**:

1. **Does the radio module use external SPI flash?**
   - Some radios store firmware on separate flash chip
   - If so, chip can be programmed directly
   - Easier than in-circuit debugging

2. **How to identify the flash chip?**
   - Visual inspection of PCB
   - Common chips: W25Q32, MX25L, AT25DF
   - Look for 8-pin SOIC packages near CPU

3. **Programming method?**
   - CH341A USB programmer (~$5)
   - Clip-on SOIC8 adapter
   - No soldering required

**Workflow**:
1. Locate SPI flash chip on radio module
2. Attach clip-on programmer
3. Read flash to file
4. Modify bytes at offset 0x18F2C
5. Write back to chip
6. Test

**Advantages**:
- ✅ No microcontroller interaction
- ✅ Simple, cheap tools
- ✅ Less risky than JTAG
- ✅ Can backup original firmware easily

**Disadvantages**:
- ❌ Only works if external flash exists
- ❌ Still requires disassembly
- ❌ Flash chip might be under shield
- ❌ Uncertain if this architecture uses external flash

---

## Question 4: Alternative Software Solutions

**Can we work around the persistence issue without flashing?**

### Option A: Auto-Reload on Boot

**Implementation**:
```java
// In Xposed module - hook app startup
@Override
public void onApplicationCreate() {
    // Check if patch is missing
    if (firmwarePatchLost()) {
        // Copy PATCH14.bin from assets
        copyFromAssets("PATCH14.bin", "/sdcard/DMR/DMRDEBUG.bin");
        
        // Trigger firmware update
        Intent updateIntent = new Intent(context, UpdateFirmwareActivity.class);
        startActivity(updateIntent);
        
        // Show notification
        Toast.makeText(context, "Loading firmware patch, 2 min wait...", LENGTH_LONG).show();
    }
}
```

**Questions for Grok**:
1. Can we detect patch loss reliably? (Check for txContact=1 in logs?)
2. Best way to embed PATCH14.bin in APK assets?
3. Can we monitor YModem completion without blocking UI?
4. How to handle black screen after update automatically?

**Pros**:
- ✅ Fully automatic, user doesn't notice
- ✅ No hardware modifications
- ✅ Survives reboots (reloads on each boot)

**Cons**:
- ❌ 2-minute delay every app start
- ❌ User experience degradation
- ❌ Battery drain (frequent YModem transfers)

### Option B: One-Tap Reload Button

**Implementation**:
```java
// Add button to Settings or Information page
Button reloadPatchButton = new Button(context);
reloadPatchButton.setText("🔧 Reload Firmware Patch");
reloadPatchButton.setOnClickListener(v -> {
    new AsyncTask<Void, Integer, Boolean>() {
        @Override
        protected void onPreExecute() {
            progressDialog.show("Reloading firmware patch...");
        }
        
        @Override
        protected Boolean doInBackground(Void... params) {
            // Copy firmware
            publishProgress(20);
            copyFirmware();
            
            // Trigger update
            publishProgress(40);
            triggerUpdate();
            
            // Monitor completion
            publishProgress(60);
            waitForYModem();
            
            // Cleanup
            publishProgress(80);
            removeDebugFile();
            
            // Restart app
            publishProgress(100);
            restartApp();
            
            return true;
        }
        
        @Override
        protected void onPostExecute(Boolean success) {
            progressDialog.dismiss();
            Toast.makeText(context, "✓ Firmware patch reloaded!", LENGTH_LONG).show();
        }
    }.execute();
});
```

**Questions for Grok**:
1. Best UI location for button? (Settings tab, Information page, TalkBack screen?)
2. Can we automate the black screen recovery?
3. Should we add "Patch Status" indicator showing if loaded?
4. Background service to monitor patch and alert user?

**Pros**:
- ✅ User-controlled (no automatic delays)
- ✅ Simple workflow (~30 seconds total)
- ✅ Only reloads when needed (after reboot)
- ✅ Good UX with progress dialog

**Cons**:
- ❌ User must remember to reload after reboot
- ❌ Still temporary solution
- ❌ Doesn't solve root cause

---

## Question 5: Reverse Engineering the Update Protocol

**Can we understand HOW the current YModem update works to hijack it?**

**Questions for Grok**:

1. **Where in the firmware does the bootloader check for flash vs RAM load?**
   - Can we find the decision logic in the decompiled code?
   - Are there address ranges or flags that control destination?
   - What triggers flash write vs RAM execution?

2. **Can we trojan horse our patch into a "full firmware update"?**
   - Create modified 378,620-byte firmware with our patch
   - Load entire firmware file via YModem
   - Does this overwrite flash or still load to RAM?

3. **What does the original firmware update tool do differently?**
   - Ulefone must have factory programming method
   - Is there PC software for radio firmware updates?
   - Can we extract and analyze that tool?

4. **Can we analyze the UpdateFirmwareActivity source?**
   - Decompile PriInterPhone app
   - Find YModem implementation
   - Look for flash-related commands
   - Hook deeper into the protocol

**Investigation Path**:
```bash
# Decompile app
jadx PriInterPhone.apk

# Find firmware update code
grep -r "YModem" classes/
grep -r "UpdateFirmware" classes/
grep -r "DMRDEBUG" classes/

# Analyze UART protocol
adb shell "cat /dev/ttyS0" > uart_capture.bin

# Hook YModem at lower level
# Instead of hooking Java, hook native serial library
```

---

## Risk Assessment

### Low Risk (Try First)
1. ✅ **One-tap reload button** - Software only, fully reversible
2. ✅ **UART command exploration** - Read-only probing, non-destructive
3. ✅ **Decompile and analyze** - No device modifications

### Medium Risk (Needs Caution)
1. ⚠️ **Modified YModem protocol** - Could confuse bootloader, but recoverable
2. ⚠️ **UART flash commands** - Wrong command might corrupt, but likely protected
3. ⚠️ **SPI flash reading** - Using clip, minimal risk if read-only first

### High Risk (Professional Level)
1. ❌ **JTAG/SWD flashing** - Direct flash write, bricking possible
2. ❌ **SPI flash writing** - Permanent changes, hard to reverse
3. ❌ **Bootloader modifications** - Could permanently lock device

---

## Specific Questions for Grok

### Priority 1: Software Methods
1. **Is there a YModem or UART command to write to flash instead of RAM?**
2. **Can we modify the DMRDEBUG.bin file format to trigger permanent flash?**
3. **What STM32 bootloader commands work on Cortex-M via UART?**
4. **How do we detect if the patch is currently loaded? (Automated check)**

### Priority 2: Hardware Investigation
5. **What's the safest way to locate SWD pins on unknown PCB?**
6. **Is the HR_C6000 likely to have external SPI flash?**
7. **Can we identify the exact CPU model without disassembly?**
8. **What multimeter tests can identify JTAG/SWD signals?**

### Priority 3: Alternative Solutions
9. **Best architecture for auto-reload feature? (Auto vs manual button)**
10. **Can we embed firmware patch in APK and extract programmatically?**
11. **How to reliably detect firmware patch loss? (Health check method)**
12. **Can we create background service monitoring patch status?**

### Priority 4: Advanced RE
13. **Where in the bootloader is the flash vs RAM decision made?**
14. **Can we extract and analyze Ulefone's factory programmer tool?**
15. **What security mechanisms protect flash writes? (CRC, signing, checksums)**
16. **Is there vendor documentation for HR_C6000 programming?**

---

## Success Criteria

**Minimum Viable Solution**:
- [ ] Patch persists across device reboots
- [ ] User doesn't need to manually reload every time
- [ ] Solution is safe (low brick risk)
- [ ] Reversible (can restore original firmware)

**Ideal Solution**:
- [ ] Permanent flash modification
- [ ] One-time procedure (flash once, works forever)
- [ ] No hardware modifications required
- [ ] Can be distributed to other users

**Acceptable Fallback**:
- [ ] One-tap reload button in app UI
- [ ] Clear instructions for users
- [ ] Progress indicator during reload
- [ ] Automatic detection of patch loss

---

## Files for Reference

**Created During Investigation**:
- `detailed_location_analysis.ps1` - ARM Thumb disassembler (200+ lines)
- `create_patch14_simple.ps1` - Patch generator (100+ lines)
- `DMR003.UV4T.V022-PATCH14.bin` - Patched firmware (378,620 bytes)
- `PATCH14_BREAKTHROUGH.md` - Complete technical documentation (500+ lines)
- `GROK_FIRMWARE_HELP_REQUEST.md` - Previous consultation document

**Available for Analysis**:
- Original firmware: `DMR003.UV4T.V022.bin` (MD5: 4426035392262CA54583C230C9E268E0)
- Android app: `com.pri.prizeinterphone.apk` (can decompile)
- UART logs: Can capture live during YModem transfer
- Xposed hooks: Full access to Java layer

---

## Next Steps

**Immediate (Today)**:
1. Research STM32 bootloader UART commands
2. Test UART command probing (read-only, safe)
3. Decompile UpdateFirmwareActivity to understand YModem protocol
4. Look for flash-related commands or parameters

**Short-term (This Week)**:
5. Implement one-tap reload button (safest solution)
6. Create patch status indicator in app
7. Document reload workflow for users
8. Test auto-detection of patch loss

**Long-term (If Needed)**:
9. Acquire ST-Link debugger ($50)
10. Plan phone disassembly (watch teardown videos)
11. Locate SWD pins on radio module
12. Attempt JTAG flash programming

---

## Request for Grok

**Please analyze this situation and provide**:

1. **Most promising software method** to achieve permanent flash
2. **Specific UART commands** to test (if STM32-based)
3. **Hardware debugging guidance** if software methods fail
4. **Risk assessment** for each approach
5. **Alternative architectures** we haven't considered
6. **Documentation links** for HR_C6000 or similar modules
7. **Tool recommendations** (software and hardware)
8. **Step-by-step procedure** for your recommended approach

**Constraints**:
- Prefer software-only methods (no disassembly if possible)
- Solution should be distributable to other users
- Must be reversible (can restore original if needed)
- Acceptable risk level: Medium or lower

**Current Status**:
- ✅ Patch works perfectly (95% confidence in fix)
- ✅ Can load to RAM reliably (5+ successful transfers)
- ❌ Doesn't persist across reboots (RAM-only)
- ❌ Need permanent solution or good workaround

Thank you for your expertise! This is the final piece to complete the DMR audio fix.

---

**Prepared by**: IIMacGyverII  
**Date**: March 5, 2026  
**Project**: DMRModHooks v3.0.2 → v2.0.0 (DMR fixes)
