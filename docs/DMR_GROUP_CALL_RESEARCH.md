# DMR Group Call vs Private Call Research

**Date**: February 27, 2026  
**Issue**: DMR app only receives audio during private calls to specific radio ID, not receiving group calls even when channel is set to group mode.

---

## 🔍 Problem Summary

You reported: *"I can only get this DMR app to receive when I do a private call directly to the id of the radio even if I have it set to group mode. On my other high end radio it will play the audio for any radio in that group."*

---

## 📚 DMR Protocol Background

### DMR Call Types

**Private Call:**
- Point-to-point communication between two specific DMR IDs
- Format: Caller DMR ID → Target DMR ID
- **Only the intended recipient should receive audio**
- Example: Radio 64067 calls Radio 64123 directly

**Group Call (Talkgroup):**
- Communication to a talkgroup ID
- Format: Caller DMR ID → Talkgroup ID (e.g., TG 12)
- **ALL radios monitoring that talkgroup should receive audio**
- Example: Radio 64123 transmits on TG 12, all radios monitoring TG 12 should hear it

---

## 🔧 How the Code Handles Contacts

### Data Structures

**ContactData.java:**
```java
public interface ContactType {
    public static final int PERSON = 0;  // Private call
    public static final int GROUP = 1;   // Group call
}
```

**ChannelData.java:**
```java
public interface ChannelContactType {
    public static final int PERSON = 0;   // Private call
    public static final int GROUP = 1;    // Group call
    public static final int ALL = 2;      // All call (broadcast)
}

public int contactType;     // 0=PERSON, 1=GROUP, 2=ALL
public int txContact;       // DMR ID or Talkgroup ID to transmit to
public int[] groups;        // Array of 32 group IDs for RX group list
```

### Channel Database Storage

**Database field:** `channel_groups` (varchar/string)
- Stored as comma-separated string: `"1,12,0,0,0..."`  (32 values)
- Default initialization: `groups[0] = 1` (Contact ID 1)

**UtilChannelData.java conversion:**
```java
// Database → int array
public int[] coverGroupInt(String str) {
    int[] iArr = new int[32];
    Arrays.fill(iArr, 0);
    iArr[0] = 1;  // Default to contact ID 1
    if (str != null && !str.equals("")) {
        String[] split = str.split(",");
        for (int i = 0; i < split.length; i++) {
            iArr[i] = Integer.parseInt(split[i]);
        }
    }
    return iArr;
}
```

### Hardware Configuration

**DmrManager.sendDigitalMessage()** - Critical logic:
```java
private void sendDigitalMessage(ChannelData channelData) {
    DigitalMessage digitalMessage = new DigitalMessage();
    digitalMessage.localId = getLocalId();
    digitalMessage.rxFreq = channelData.getRxFreq();
    digitalMessage.txFreq = channelData.getTxFreq();
    digitalMessage.power = (byte) channelData.getPower();
    digitalMessage.contactType = (byte) channelData.getContactType();
    digitalMessage.txContact = channelData.getTxContact();
    digitalMessage.cc = (byte) channelData.getCc();
    digitalMessage.inboundSlot = (byte) channelData.getInBoundSlot();
    digitalMessage.outboundSlot = (byte) channelData.getOutBoundSlot();
    digitalMessage.channelMode = (byte) channelData.getChannelMode();
    digitalMessage.encryptSw = (byte) channelData.getEncryptSw();
    digitalMessage.encryptKey = !channelData.getEncryptKey().equals("") ? 
        channelData.getEncryptKey().getBytes() : getByteDefault();
    
    // ⚠️ CRITICAL: Only sends groupList when contactType is GROUP (1)
    if (channelData.contactType == 1) {
        digitalMessage.groupList = channelData.groups;
    }
    
    digitalMessage.mic = (byte) PersonSharePrefData.getIntData(
        PrizeInterPhoneApp.getContext(), 
        PersonSharePrefData.PREF_PERSON_MiC_GAN_VALUE, 0);
    digitalMessage.relay = (byte) channelData.getRelay();
    digitalMessage.send();
}
```

**DigitalMessage encoding** - Sends to hardware:
```java
@Override
protected byte[] encodeBody() {
    ByteBuf allocate = ByteBuf.allocate(163);
    allocate.putInt(this.rxFreq);
    allocate.putInt(this.txFreq);
    allocate.putInt(this.localId);          // Your radio's DMR ID
    
    // RX Group List (128 bytes = 32 int values)
    ByteBuf allocate2 = ByteBuf.allocate(128);
    for (int i : this.groupList) {
        allocate2.putInt(i);
    }
    allocate.put(allocate2.getArray());
    
    allocate.putInt(this.txContact);        // TX target (DMR ID or TG)
    allocate.put(this.contactType);         // 0=PERSON, 1=GROUP, 2=ALL
    allocate.put(this.power);
    allocate.put(this.cc);
    allocate.put(this.inboundSlot);
    allocate.put(this.outboundSlot);
    allocate.put(this.channelMode);
    allocate.put(this.encryptSw);
    allocate.put(this.encryptKey);
    allocate.put(this.pwrSave);
    allocate.put(this.volume);
    allocate.put(this.mic);
    allocate.put(this.relay);
    return allocate.getArray();
}
```

---

## 🔴 Root Cause Analysis

### How it SHOULD Work

**For Group Call Reception:**
1. Channel configured with `contactType = 1` (GROUP)
2. Channel's `groups` array contains talkgroup IDs to monitor (e.g., `[12, 0, 0, ...]`)
3. App sends DigitalMessage to hardware with `groupList = [12, 0, 0, ...]`
4. Hardware monitors for incoming calls to any ID in the group list
5. When someone transmits on TG 12, hardware receives and plays audio
6. PCMReceiveManager receives PCM audio from hardware via PrizeTinyService
7. Audio plays through AudioTrack

**For Private Call Reception:**
1. Channel configured with `contactType = 0` (PERSON)
2. Channel's `txContact` set to specific DMR ID
3. App sends DigitalMessage to hardware WITHOUT groupList
4. Hardware ONLY monitors for incoming calls to your specific radio ID (localId)
5. Only receives audio when someone directly calls your ID

### Likely Problem Scenarios

#### Scenario 1: ⚠️ **contactType Set to PERSON Instead of GROUP**
**Symptoms:** Matches your issue exactly
- If channel has `contactType = 0` (PERSON), the `groupList` is NOT sent to hardware
- Hardware operates in private call mode
- You only receive calls directly to your radio's DMR ID
- Group calls are ignored even if `txContact` is set to a talkgroup ID

**Check:** Verify in your channel database:
```sql
SELECT channel_name, channel_contactType, channel_txContact, channel_groups 
FROM database_* 
WHERE channel_type = 0;  -- Digital channels
```

**Fix:** Set channel's `contactType = 1` (GROUP) for group call reception

#### Scenario 2: ⚠️ **groups Array Not Populated**
**Symptoms:** contactType is correct, but still no group reception
- Channel has `contactType = 1` (GROUP)
- But `groups` array is empty or only contains default `[1, 0, 0, ...]`
- Hardware receives groupList but wrong talkgroup IDs

**Check:** Verify channel's `channel_groups` database field:
```sql
SELECT channel_name, channel_groups 
FROM database_* 
WHERE channel_contactType = 1;
```

**Expected for TG 12:** `"12,0,0,0,0,..."`  
**Problem:** `"1,0,0,0,0,..."` or `""` or `NULL`

**Fix:** Update channel's groups array to include the talkgroup ID(s)

#### Scenario 3: ⚠️ **Confusion Between TX Contact and RX Group List**
**Symptoms:** Setting only `txContact`, not understanding RX group list
- You set `txContact = 12` (transmit to TG 12)
- But `groups` array is `[1, 0, 0, ...]` (receive only contact ID 1)
- **You CAN transmit to TG 12, but WON'T receive from it**

**DMR Concept:**
- **TX Contact** (`txContact`): Which talkgroup YOU transmit to
- **RX Group List** (`groups` array): Which talkgroups YOU monitor/receive from
- These can be different! (e.g., transmit to TG 12 but also monitor TG 9, TG 12, TG 15)

**Fix:** Ensure `groups` array includes the talkgroups you want to monitor

#### Scenario 4: ⚠️ **High-End Radio Has Proper RX Group List**
**Your observation:** "on my other high end radio it will play the audio for any radio in that group"

**Explanation:**
- Professional DMR radios (Motorola, Hytera, etc.) properly implement RX Group Lists
- When you set a channel to group mode, they automatically add that talkgroup to the RX list
- This app may require **manual configuration** of the `groups` array

---

## 🔬 Comparison: OpenGD77 vs PriInterPhone

### Your Current Configuration (from OpenGD77 backup):

**Contacts.csv:**
```csv
Contact Name,ID,ID Type,TS Override
group test 1,1,Private,-
test 1,12,Group,-
```

**Channels.csv (Digital channels):**
```csv
Channel 2:
- Name: Rockford-K1LEO
- Type: Digital
- Contact: test 1 (TG 12, Group type)
- TG List: None
- Timeslot: 1
```

**TG_Lists.csv:**
```csv
(Empty - no talkgroup lists defined)
```

### 🚨 **Problem Identified:**

1. **Contact "test 1"** is defined as Group with ID 12 ✅ Correct
2. **Channel 2** uses contact "test 1" ✅ Correct
3. **TG List is "None"** ❌ **THIS IS THE PROBLEM!**

**In OpenGD77/high-end radios:**
- When a channel's TG List is set, it defines which talkgroups to monitor
- "None" typically means "use the contact's talkgroup only" as a default
- The radio firmware automatically creates an RX group list with that talkgroup

**In PriInterPhone app:**
- The `channel_groups` database field stores the RX group list
- If it's `"1,0,0,..."` (default), it only monitors contact ID 1
- The app does NOT automatically populate `groups` based on `txContact`
- **You must manually set the `groups` array to include TG 12**

---

## ✅ Solutions & Recommendations

### Solution 1: Fix Channel contactType (Most Likely)

**If channels are configured as PERSON instead of GROUP:**

1. **Open app's channel configuration**
2. **For digital channels that should receive group calls:**
   - Set Contact Type = GROUP (1)
   - Ensure TX Contact is set to the talkgroup ID (e.g., 12)
3. **Save and reload channel**

**Via database (if you have root access):**
```sql
-- Fix channel 2 to be group mode
UPDATE database_* 
SET channel_contactType = 1 
WHERE channel_name = 'Rockford-K1LEO';
```

### Solution 2: Populate RX Group List

**The `channel_groups` field must contain the talkgroups you want to monitor.**

**Manual approach (via app):**
1. Edit digital channel
2. Look for "RX Group List" or "Groups" setting
3. Add talkgroup IDs you want to monitor (e.g., 12)

**Database approach (direct edit):**
```sql
-- Add TG 12 to channel 2's RX group list
UPDATE database_* 
SET channel_groups = '12,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0'
WHERE channel_name = 'Rockford-K1LEO';
```

### Solution 3: Create LSPosed Hook to Auto-Populate Groups

**If the app doesn't provide UI to configure RX group lists, you could add a hook:**

```java
// In MainHook.java, hook InterPhoneContactsFragment.saveSelectedData()
XposedHelpers.findAndHookMethod(
    "com.pri.prizeinterphone.fragment.InterPhoneContactsFragment",
    lpparam.classLoader,
    "saveSelectedData",
    new XC_MethodHook() {
        @Override
        protected void afterHookedMethod(MethodHookParam param) throws Throwable {
            try {
                // Get current channel
                Object dmrManager = XposedHelpers.callStaticMethod(
                    XposedHelpers.findClass("com.pri.prizeinterphone.manager.DmrManager", 
                        lpparam.classLoader),
                    "getInstance"
                );
                Object currentChannel = XposedHelpers.callMethod(dmrManager, "getCurrentChannel");
                
                if (currentChannel != null) {
                    int contactType = XposedHelpers.getIntField(currentChannel, "contactType");
                    int txContact = XposedHelpers.getIntField(currentChannel, "txContact");
                    int[] groups = (int[]) XposedHelpers.getObjectField(currentChannel, "groups");
                    
                    // If channel is GROUP mode, auto-add txContact to groups[0]
                    if (contactType == 1) {  // GROUP
                        if (groups == null || groups[0] != txContact) {
                            groups = new int[32];
                            Arrays.fill(groups, 0);
                            groups[0] = txContact;  // Add TX contact to RX group list
                            XposedHelpers.setObjectField(currentChannel, "groups", groups);
                            
                            // Update in database
                            XposedHelpers.callMethod(dmrManager, "updateChannel", currentChannel);
                            
                            XposedBridge.log("DMRModHooks: Auto-added TG " + txContact + 
                                " to RX group list");
                        }
                    }
                }
            } catch (Throwable t) {
                XposedBridge.log("DMRModHooks: Error in saveSelectedData hook: " + 
                    t.getMessage());
            }
        }
    }
);
```

### Solution 4: Check Other Radio's Configuration

**To verify this is the issue:**

1. **Export your high-end radio's configuration** (if possible)
2. **Check the RX Group List for the working channel**
3. **Compare to PriInterPhone app's `channel_groups` field**
4. **Match the configuration**

---

## 📊 Diagnostic Steps

### Step 1: Check Current Channel Configuration

```bash
# Use ADB to access database
adb shell
su
cd /data/data/com.pri.prizeinterphone/databases
sqlite3 channel_database.db

# Query digital channels
.mode column
.headers on
SELECT 
    channel_name,
    channel_type,
    channel_contactType,
    channel_txContact,
    channel_groups,
    channel_active
FROM database_*
WHERE channel_type = 0  -- Digital channels
LIMIT 10;
```

**Look for:**
- `channel_contactType`: Should be `1` (GROUP) for group call channels
- `channel_txContact`: Should match the talkgroup ID (e.g., 12)
- `channel_groups`: Should contain the talkgroup ID(s), not just "1,0,0,..."

### Step 2: Test with Known Working Configuration

**Create a test channel with confirmed settings:**

```sql
INSERT INTO database_* (
    channel_name,
    channel_type,
    channel_contactType,
    channel_txContact,
    channel_groups,
    channel_rxFreq,
    channel_txFreq,
    channel_cc,
    channel_power,
    channel_inBoundSlot,
    channel_outBoundSlot,
    channel_active
) VALUES (
    'TEST_GROUP',
    0,                    -- Digital
    1,                    -- GROUP contact type
    12,                   -- TX to TG 12
    '12,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0',  -- RX TG 12
    443700000,            -- RX Freq (adjust to your repeater)
    448700000,            -- TX Freq
    1,                    -- Color code
    1,                    -- High power
    1,                    -- Inbound slot (TS1)
    1,                    -- Outbound slot (TS1)
    0                     -- Not active yet
);
```

**Then activate the channel and test reception.**

### Step 3: Monitor Logcat During RX

```bash
adb logcat | grep -E "DMRModHooks|DigitalMessage|PCMReceiveManager|onRecv"
```

**When someone transmits on the talkgroup, look for:**
- `DigitalMessage` being sent to hardware with proper `groupList`
- `PCMReceiveManager.onRecv` receiving audio data
- Any filtering or rejection messages

---

## 🎯 Expected Behavior Summary

| Scenario | contactType | txContact | groups Array | RX Behavior |
|----------|------------|-----------|--------------|-------------|
| **Private Call Only** | 0 (PERSON) | Your ID (64067) | Ignored | Only receives calls TO 64067 |
| **Group Call (Single TG)** | 1 (GROUP) | TG ID (12) | [12, 0, ...] | Receives all calls TO TG 12 |
| **Group Call (Multi TG)** | 1 (GROUP) | TG ID (12) | [12, 9, 15, 0, ...] | Receives calls TO TG 12, 9, or 15 |
| **All Call** | 2 (ALL) | 16777215 | Not used | Receives all calls (broadcast) |

---

## 🔍 Additional Research Notes

### Hardware Filtering Location

**The RX filtering happens in the DMR radio hardware/firmware:**
- App sends `DigitalMessage` to PrizeTinyService (system API)
- PrizeTinyService communicates with DMR hardware via serial port
- Hardware processes incoming RF signals
- **Hardware checks incoming call's Destination ID against:**
  - Your radio's DMR ID (localId) for private calls
  - RX Group List (groupList array) for group calls
- If match found → decodes audio → sends PCM to app
- If no match → ignores transmission

**PCMReceiveManager has NO filtering logic** - it plays whatever hardware sends:
```java
public void onRecv(byte[] bArr, int i) {
    // Just forwards to audio track - no filtering
    PCMReceiveManager.this.mReadThreadHandler.sendMessage(...);
}
```

### Difference from Professional Radios

**Commercial DMR radios (Motorola, Hytera, etc.):**
- Have dedicated UI for RX Group List configuration
- Automatically populate RX group list when you assign a group contact
- May have "promiscuous mode" to receive all talkgroups

**PriInterPhone app:**
- Appears to be incomplete implementation
- May not have UI for RX group list configuration
- Requires manual database editing OR code modification
- May default to only monitoring contact ID 1

---

## ✅ Recommended Next Steps

1. **Check your active digital channel's database entry**
   - Confirm `channel_contactType` value
   - Verify `channel_groups` contains the talkgroup ID(s)

2. **If contactType is 0 (PERSON), change to 1 (GROUP)**
   - Via app UI (if available)
   - Or via direct database edit

3. **If groups array is wrong, update it**
   - Set `channel_groups = '12,0,0,...'` for TG 12
   - Add multiple TGs if needed: `'12,9,15,0,...'`

4. **Reload channel configuration**
   - Switch to another channel
   - Switch back to test channel
   - This triggers `sendDigitalMessage()` with new settings

5. **Test reception**
   - Have another radio transmit on the talkgroup
   - Monitor logcat for debugging output
   - Verify audio plays through speaker

6. **If still not working:**
   - Capture logcat during channel change
   - Verify the DigitalMessage sent to hardware
   - Check if hardware supports RX group lists
   - May need firmware update or hardware doesn't support feature

---

## 📝 Files to Review

- [ChannelData.java](app/src/main/java/com/pri/prizeinterphone/serial/data/ChannelData.java) - Channel data structure
- [ContactData.java](app/src/main/java/com/pri/prizeinterphone/serial/data/ContactData.java) - Contact data structure  
- [DmrManager.java](app/src/main/java/com/pri/prizeinterphone/manager/DmrManager.java) - Channel config and message sending
- [DigitalMessage.java](app/src/main/java/com/pri/prizeinterphone/message/DigitalMessage.java) - Hardware message format
- [UtilChannelData.java](app/src/main/java/com/pri/prizeinterphone/serial/data/UtilChannelData.java) - Database operations
- [PCMReceiveManager.java](app/src/main/java/com/pri/prizeinterphone/manager/PCMReceiveManager.java) - Audio reception

---

## 🤝 Community Resources

- **DMR-MARC**: Global DMR network information
- **RadioID.net**: DMR ID database and programming guides
- **BrandMeister**: Popular DMR network with configuration docs
- **OpenGD77**: Open source DMR firmware (your other radio?)

---

**Research compiled by GitHub Copilot**  
**Date**: February 27, 2026
