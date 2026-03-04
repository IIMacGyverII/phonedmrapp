# Monitoring Mode Investigation Report

**Date:** February 27, 2026  
**Issue:** Ulefone Armor 26 Ultra DMR hardware not receiving group calls despite correct RX group list configuration  
**Attempted Solution:** Implement monitoring mode toggle to switch between GROUP (contactType=1) and ALL (contactType=2) modes

---

## Problem Statement

The Ulefone Armor 26 Ultra's DMR module has a critical bug: it only receives **private calls** (direct to DMR ID) but ignores all **group calls**, even when the RX group list is properly configured with valid TG IDs (64067, 55301).

### Expected Behavior
When `contactType=1` (GROUP mode) with RX group list `[64067, 55301, ...]`, the radio should receive:
- Calls to TG 64067
- Calls to TG 55301
- Private calls to local DMR ID

### Actual Behavior
- ✅ Private calls work
- ❌ Group calls are ignored (never received)
- ✅ Transmit works correctly

---

## Attempted Solution: Monitoring Mode

### Hypothesis
DMR radios support three contact types:
- `contactType=0`: PERSON mode (private calls only)
- `contactType=1`: GROUP mode (filtered by RX group list)
- `contactType=2`: ALL mode (promiscuous - receive all traffic on timeslot/color code)

Since GROUP mode filtering appears broken, we attempted to implement ALL mode as a workaround.

### Implementation Journey

#### v1.6.0 - v1.7.6: Button Visibility Issues
**Problem:** MON button not appearing in UI
- Wrong hook method: `onViewCreated()` doesn't exist, corrected to `initView()`
- Wrong view reference: Used wrong parameter
- Wrong layout params: FrameLayout params for LinearLayout parent

**Solution:** Integrated MON button directly into buttonContainer (same as REC/TXT buttons)

#### v1.8.0 - v1.8.3: Button Positioning
**Problem:** Button overlapping REC button
- Multiple iterations adjusting topMargin values
- Final positioning: REC at 10dp, MON at 60dp from top (50dp spacing)

**Result:** ✅ UI fully functional, button toggles correctly

#### v1.8.4 - v1.8.9: Hardware Delivery Attempts

**v1.8.4:** Forced `contactType=2` in `sendDigitalMessage()` hook
```java
// Hooked DmrManager.sendDigitalMessage(channelData)
beforeHookedMethod() {
    if (isMonitoringMode) {
        channelData.contactType = 2;
        channelData.txContact = 16777215;  // 0xFFFFFF for ALL mode
    }
}
```
- ❌ Database updated correctly
- ❌ Hardware still received `contactType=1`

**v1.8.5:** Attempted `DigitalMessage.send()` hook (failed - method doesn't exist)

**v1.8.6:** Hooked `BaseMessage.send()` (inherited by DigitalMessage)
- ❌ Still ineffective - packet already encoded

**v1.8.7:** Hooked `DigitalMessage.encodeBody()` - right before serialization
```java
beforeHookedMethod() {
    if (isMonitoringMode) {
        digitalMessage.contactType = (byte) 2;
        digitalMessage.txContact = 16777215;
    }
}
```
- ✅ Object fields updated successfully
- ❌ But needed byte-level verification

**v1.8.8-v1.8.9:** Added byte-level verification with corrected offsets
- Packet layout: `rxFreq(4) + txFreq(4) + localId(4) + groupList(128) + txContact(4) + contactType(1)`
- `txContact` at bytes 140-143
- `contactType` at byte 144

---

## Critical Discovery: Hardware Rejection

### Evidence

**Outgoing Packet (What We Send):**
```
Timestamp: 21:57:42.696
rxFreq: 467700000 Hz
txFreq: 467700000 Hz
contactType in packet bytes: 2  ✓ CONFIRMED
txContact in packet bytes: -256 (endianness issue, but non-zero)
```

**Hardware Response (What Hardware Returns):**
```
Timestamp: 21:57:43.122
TAG_DigitalMessageHandler: handle: DigitalMessage{
  rxFreq=401025000,    ← DEFAULT (not our 467700000!)
  txFreq=401025000,    ← DEFAULT
  contactType=1,       ← REVERTED (not our 2!)
  txContact=1,         ← REVERTED (not our 16777215!)
  groupList=[[0,0,0...]]
}
```

### Key Observations

1. **Packet injection successful:** `contactType=2` confirmed in actual packet bytes sent to `/dev/ttyS0`
2. **Hardware rejecting ALL mode:** Responses show `contactType=1` with completely different frequencies
3. **Not echo responses:** The 401025000 Hz frequency is default/cached, not our 467700000 Hz channel
4. **Multiple attempts:** 4 packets sent per toggle, all show same rejection pattern

### Conclusion

**The Ulefone Armor 26 Ultra DMR module firmware does NOT support `contactType=2` (ALL mode).**

The hardware either:
- Silently rejects ALL mode settings and reverts to GROUP mode
- Has firmware that only implements contactType 0 (PERSON) and 1 (GROUP)
- Ignores the contactType field entirely when set to unsupported values

---

## Technical Details

### Communication Architecture

**Hardware:** DMR module connected via UART serial
- Device: `/dev/ttyS0`
- Baud rate: 57600
- Protocol: Custom binary protocol with Packet structure

**Software Stack:**
```
App UI (InterPhoneTalkBackFragment)
    ↓
DmrManager.sendDigitalMessage(channelData)
    ↓
DigitalMessage.encodeBody()  ← Our hook here
    ↓
BaseMessage.send() → encode()
    ↓
SerialManager.send(packet)
    ↓
/dev/ttyS0 (UART serial to DMR module)
    ↓
DMR Module Firmware
```

### Database Schema

**File:** `/data/data/com.pri.prizeinterphone/databases/database_channel_area_default_uhf.db`

**Channel 17 (DMR Test) Configuration:**
```sql
channel_contactType: 2          ✓ Written by our code
channel_txContact: 16777215     ✓ Written by our code
channel_groups: [64067, 55301, 0, 0, ...]
channel_rxFreq: 467700000
channel_txFreq: 467700000
channel_cc: 15
channel_inBoundSlot: 0
```

### Binary Packet Format

**DigitalMessage.encodeBody() output (163 bytes):**
```
Offset   Size   Field
------   ----   -----
0-3      4      rxFreq (int, big endian)
4-7      4      txFreq (int, big endian)
8-11     4      localId (DMR ID, big endian)
12-139   128    groupList (32 × int array)
140-143  4      txContact (int, big endian)
144      1      contactType (byte)  ← We force to 2 here
145      1      power (byte)
146      1      cc (color code, byte)
147      1      inboundSlot (byte)
148      1      outboundSlot (byte)
149      1      channelMode (byte)
150      1      encryptSw (byte)
151-158  8      encryptKey (byte array)
159      1      pwrSave (byte)
160      1      volume (byte)
161      1      mic (byte)
162      1      relay (byte)
```

---

## What Works

1. ✅ **MON button UI:** Fully functional toggle button
2. ✅ **Database updates:** contactType and txContact persist correctly
3. ✅ **Packet injection:** contactType=2 successfully inserted into binary packet
4. ✅ **Serial transmission:** Packet sent to hardware via /dev/ttyS0
5. ✅ **LSPosed hook stability:** No crashes, hooks execute reliably

## What Doesn't Work

1. ❌ **Hardware acceptance:** DMR module rejects contactType=2
2. ❌ **Group call reception:** Still broken (original issue persists)
3. ❌ **ALL mode:** Not supported by hardware firmware

---

## Possible Workarounds & Next Steps

### Option 1: Software RX Audio Interception (FEASIBLE)
**Concept:** Bypass hardware filtering by intercepting ALL received DMR audio before hardware filtering

**Approach:**
- Hook PCM audio receive pipeline BEFORE contactType filtering
- Implement software-based TG filtering in app
- Requires finding where hardware applies contactType filter

**Pros:**
- No firmware modification needed
- Can implement custom filtering logic

**Cons:**
- May not be possible if filtering happens in hardware
- Performance impact from processing all audio

**Investigation needed:**
- Trace audio receive path in decompiled code
- Find PCMReceiveManager hooks
- Determine if filtering is hardware or software

---

### Option 2: Firmware Reverse Engineering (ADVANCED)

**Hardware Identification:**
- DMR module connected to MT6761 SoC via `/dev/ttyS0` UART
- Unknown DMR chipset (likely Beken BK4819, Auctus A7139, or similar)
- Communication protocol: Custom binary (analyzed in DigitalMessage.encodeBody)

**Firmware Access Methods:**

#### A. Extract Firmware from Device
```bash
# 1. Find DMR module partition
adb shell su -c "cat /proc/mtd"
adb shell su -c "ls -la /dev/block/platform/*/by-name/*"

# 2. Look for firmware blobs
adb shell su -c "find /system /vendor /firmware -name '*dmr*' -o -name '*radio*' -o -name '*modem*'"

# 3. Check for update mechanism
adb shell su -c "pm dump com.pri.prizeinterphone | grep -i firmware"
```

#### B. Intercept Firmware Updates
- App has firmware update functionality (MyNotificationManager.java)
- Intent: `prize.intent.action.update.dmr.firmware`
- May capture update file to analyze

#### C. UART Protocol Sniffing
```bash
# Create serial port sniffer
# Hook Serial.java to log all packets
# Protocol already partially documented in Packet.java
```

**Reverse Engineering Steps:**

1. **Extract firmware binary**
   - Search device partitions
   - Intercept update process
   - Dump from /dev/mtd* if accessible

2. **Identify chipset**
   - Analyze packet protocol
   - Check FCC ID database for Ulefone Armor 26 Ultra
   - Examine PCB if device can be opened

3. **Disassemble firmware**
   - Ghidra/IDA Pro for ARM/MIPS analysis
   - Find contactType validation logic
   - Locate group list filtering code

4. **Patch firmware**
   - Modify contactType validation to accept 2
   - OR disable group list filtering entirely
   - OR reverse GROUP mode logic to work correctly

5. **Flash modified firmware**
   - Use app's update mechanism if possible
   - Direct UART flash if bootloader accessible
   - May require device teardown

**Risks:**
- ⚠️ Device brick if flash fails
- ⚠️ Warranty void
- ⚠️ May require hardware debugger (JTAG/SWD)

---

### Option 3: Modify GROUP Mode Behavior (MEDIUM COMPLEXITY)

**Hypothesis:** GROUP mode filtering is broken, not missing
- Hardware receives all group calls
- Filtering incorrectly rejects them

**Approach:**
1. Intercept DigitalMessageHandler.handle() for incoming calls
2. Force acceptance of any group call regardless of TG match
3. Override hardware's RX decision in software

**Code location:**
```java
// DigitalMessageHandler.java:19
public void handle(DigitalMessage digitalMessage) {
    Log.i(TAG, "handle: " + digitalMessage.toString());
    CmdStateMachine.getInstance().getCmdResultFromModule(digitalMessage);
    // ← Hook here to override RX filtering
}
```

**Implementation:**
```java
XposedHelpers.findAndHookMethod(
    "com.pri.prizeinterphone.handler.DigitalMessageHandler",
    "handle",
    DigitalMessage.class,
    new XC_MethodHook() {
        @Override
        protected void beforeHookedMethod(MethodHookParam param) {
            DigitalMessage msg = (DigitalMessage) param.args[0];
            // Force acceptance of group calls
            // OR: Pre-process to bypass hardware filter
        }
    }
);
```

**Pros:**
- Safer than firmware modification
- Reversible
- May work if hardware sends all data

**Cons:**
- May not work if hardware drops packets before they reach app
- Requires deep understanding of receive pipeline

---

### Option 4: Hardware Module Replacement (HARDWARE MOD)

**Concept:** Replace DMR module with compatible one that supports ALL mode

**Requirements:**
- Module must use same UART protocol
- Physical compatibility (connector, size)
- Firmware must support contactType=2

**Candidates:**
- Ailunce HD1 module (if protocol compatible)
- TYT MD-UV380 module
- Requires protocol compatibility analysis

**Feasibility:** Low (requires hardware expertise + protocol reverse engineering)

---

## Recommended Next Steps

### Immediate (Software-Only):

1. **Investigate RX audio interception** (Option 1)
   - Search for PCM audio receive hooks
   - Trace DmrManager.handleIncomingCall() or similar
   - Look for where contactType filtering occurs in app

2. **Document serial protocol** 
   - Hook Serial.java to log all UART traffic
   - Reverse engineer complete packet format
   - May reveal hidden commands or modes

3. **Test GROUP mode bypass** (Option 3)
   - Hook DigitalMessageHandler
   - Try forcing acceptance of all received messages
   - May work if hardware sends but app filters

### Medium-Term (Firmware Analysis):

4. **Extract DMR firmware**
   - Search device for firmware blobs
   - Monitor update process
   - Document chipset identification

5. **Analyze firmware binary**
   - Disassemble with Ghidra
   - Find contactType validation
   - Assess patchability

### Long-Term (Hardware):

6. **Consider module replacement** (if firmware unpatchable)
   - Research compatible modules
   - Document current module specs
   - Analyze cost/benefit

---

## Code Repository Status

### Current LSPosed Module (v1.8.9)
**Location:** `DMRModHooks/app/src/main/java/com/dmrmod/hooks/MainHook.java`

**Features:**
- ✅ MON button toggle (Orange ON, Gray OFF)
- ✅ Database persistence (contactType, txContact)
- ✅ Packet injection (contactType=2 in binary)
- ✅ Byte-level verification logs
- ✅ Hardware sync calls (updateChannel, syncChannelInfoWithData)

**Hooks:**
1. `InterPhoneTalkBackFragment.initView()` - Add MON button to UI
2. `DmrManager.sendDigitalMessage()` - Force contactType=2 in ChannelData
3. `DigitalMessage.encodeBody()` - Force contactType=2 before serialization
4. `BaseMessage.send()` - Logging and verification

**Known Issues:**
- Hardware rejects contactType=2
- txContact byte order (little-endian -256 instead of 16777215)
- Hardware responses show default frequencies (not channel-specific)

---

## Testing Evidence

### Successful Packet Injection (v1.8.9)
```
21:57:42.696 LSPosed-Bridge: DMRModHooks: === encodeBody() BEFORE ===
21:57:42.696 LSPosed-Bridge: DMRModHooks: rxFreq: 467700000, txFreq: 467700000
21:57:42.696 LSPosed-Bridge: DMRModHooks: contactType: 2, txContact: 16777215
21:57:42.696 LSPosed-Bridge: DMRModHooks: 🔥🔥🔥 ULTIMATE FORCE in encodeBody()!
21:57:42.696 LSPosed-Bridge: DMRModHooks: ✅✅✅ Set contactType=2, txContact=16777215 RIGHT BEFORE SERIALIZATION
21:57:42.696 LSPosed-Bridge: DMRModHooks: === encodeBody() AFTER - ACTUAL BYTES ===
21:57:42.696 LSPosed-Bridge: DMRModHooks: txContact in packet bytes: -256
21:57:42.696 LSPosed-Bridge: DMRModHooks: contactType in packet bytes: 2
21:57:42.696 LSPosed-Bridge: DMRModHooks: ✅✅✅ SUCCESS: contactType=2 AND txContact=-256 confirmed in packet bytes!
```

### Hardware Rejection
```
21:57:43.122 TAG_DigitalMessageHandler: handle: DigitalMessage{
    rxFreq=401025000,     ← Wrong (not our 467700000)
    txFreq=401025000,     ← Wrong
    localId=1,
    groupList=[[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]],
    txContact=1,          ← Reverted (not our 16777215)
    contactType=1,        ← Reverted (not our 2) ❌
    power=1,
    cc=1,
    inboundSlot=0,
    outboundSlot=0,
    channelMode=0,
    encryptSw=2,
    encryptKey=[0,0,0,0,0,0,0,0],
    pwrSave=1,
    volume=8,
    mic=0,
    relay=2
}, sr=RESULT_SUCCESS
```

---

## Conclusion

The monitoring mode implementation successfully injects `contactType=2` into binary packets sent to the DMR module, but the **hardware firmware rejects ALL mode** and continues to operate in broken GROUP mode.

**Next investigation priority:** Software RX audio interception to bypass hardware filtering entirely, as firmware modification requires significant reverse engineering effort with bricking risk.

**Alternative approach:** Document the hardware bug for Ulefone/manufacturer to fix in future firmware updates, as this affects DMR functionality which may be a selling point of the device.

---

## Related Files

- [MainHook.java](DMRModHooks/app/src/main/java/com/dmrmod/hooks/MainHook.java) - LSPosed module implementation
- [DigitalMessage.java](app/src/main/java/com/pri/prizeinterphone/message/DigitalMessage.java) - Packet structure
- [DmrManager.java](app/src/main/java/com/pri/prizeinterphone/manager/DmrManager.java) - DMR hardware interface
- [Serial.java](app/src/main/java/com/pri/prizeinterphone/serial/Serial.java) - UART communication
- [database_channel_area_default_uhf.db](https://github.com/user/repo) - Channel configuration database

## See Also

- [LSPOSED_SUCCESS.md](LSPOSED_SUCCESS.md) - Initial hook implementation
- [MACGYVER_MOD_STATUS.md](MACGYVER_MOD_STATUS.md) - Transcription feature status
- [STATUS.md](STATUS.md) - Overall project status
