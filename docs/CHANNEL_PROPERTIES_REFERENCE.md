# Channel Properties Complete Reference

## Overview
This document provides a comprehensive reference for all channel properties in the InterPhoneChannelActivity, including valid values, data types, and whether they apply to analog, digital, or both channel types.

## Source Files
- **Layout**: `app/src/main/res/layout/interphone_channel_activity.xml`
- **Activity**: `app/src/main/java/com/pri/prizeinterphone/activity/InterPhoneChannelActivity.java`
- **Data Model**: `app/src/main/java/com/pri/prizeinterphone/serial/data/ChannelData.java`
- **Array Values**: `app/src/main/res/values/arrays.xml`
- **String Values**: `app/src/main/res/values/strings.xml`

---

## Channel Type Classification

### Field Visibility Logic

**hideDigitalMenu()** - Called when channel type is **ANALOG** (hides digital-only fields):
- Hides: ColorCode, Channel Mode, Slot, Contact Type, Call Name, Encryption, Encryption Key, Interrupt Transmission, Group List
- Shows: Band, Squelch, TX Type, RX Type, Relay Disconnection

**hideAnalogMenu()** - Called when channel type is **DIGITAL** (hides analog-only fields):
- Hides: Band, Squelch, TX Type, RX Type, TX Subcode, RX Subcode
- Shows: ColorCode, Channel Mode, Slot, Contact Type, Call Name, Encryption, Encryption Key, Interrupt Transmission, Group List, Relay Disconnection

---

## Property Details

### 🔹 COMMON PROPERTIES (Both Analog & Digital)

#### 1. **Channel Name**
- **Field**: `name` (String)
- **UI Element**: `mEditChannelName` (EditText)
- **Default**: Auto-generated (e.g., "Digital1", "Analog1")
- **Notes**: User-defined channel name

#### 2. **TX Frequency**
- **Field**: `txFreq` (int, in Hz)
- **UI Element**: `mEditFrequncySend` (EditText)
- **Default Digital**: 401025000 Hz (401.025 MHz)
- **Default Analog**: 409025000 Hz (409.025 MHz)
- **Range**: Varies by region and band (UHF/VHF)
- **Arrays**: `channel_tx_digital_default`, `channel_tx_Analog_*` (region-specific)
- **Notes**: Stored as integer in Hertz

#### 3. **RX Frequency**
- **Field**: `rxFreq` (int, in Hz)
- **UI Element**: `mEditFrequncyRecieve` (EditText)
- **Default Digital**: 401025000 Hz (401.025 MHz)
- **Default Analog**: 409025000 Hz (409.025 MHz)
- **Range**: Same as TX frequency
- **Notes**: Can be different from TX for repeater operation

#### 4. **Frequency Band** (UHF/VHF)
- **Field**: Not directly stored; determined by frequency range
- **UI Element**: `mTvChannelFrqBand` (TextView)
- **Values**:
  - `UHF`: 400-480 MHz
  - `VHF`: 136-174 MHz
- **Array**: `interphone_channel_frequency_values`
- **Default**: "UHF"
- **Notes**: Only visible if device supports both bands (`DmrManager.isSupportUVFrequencyBand()`)

#### 5. **Power**
- **Field**: `power` (int)
- **UI Element**: `mTvChannelPower` (TextView)
- **Values**:
  - `0` = Low Power
  - `1` = High Power
- **Array**: `interphone_channel_power_values`
- **Default**: `1` (High)
- **Interface Constants**: `ChannelPower.LOW = 0`, `ChannelPower.HIGE = 1` (typo in original code)

#### 6. **Relay Disconnection** ⚠️
- **Field**: `relay` (int)
- **UI Element**: `mTvChannelRelayDisconnet` (TextView)
- **Values**:
  - `2` = Disable (Normal repeater operation) ✅ **RECOMMENDED**
  - `1` = Enable (Disconnects from repeater - may prevent TX)
- **Array**: `interphone_channel_relay_disconnet`
- **Default**: `2` (Disable)
- **Notes**: 
  - Has help dialog explaining functionality
  - Same field used for both analog and digital
  - Disable = normal operation (confusing naming!)

---

### 🔵 DIGITAL-ONLY PROPERTIES

#### 7. **Channel Type**
- **Field**: `type` (int)
- **UI Element**: `mTvChannelType` (TextView)
- **Values**:
  - `0` = Digital (DMR)
  - `1` = Analog
- **Array**: `interphone_channel_type_values`
- **Default**: `0` (Digital)
- **Interface Constants**: `ChannelType.DIGITAL = 0`, `ChannelType.ANALOG = 1`
- **Notes**: Hidden when editing existing channel (cannot change type)

#### 8. **ColorCode (CC)**
- **Field**: `cc` (int)
- **UI Element**: `mTvChannelColor` (TextView)
- **Values**: `0-15` (16 possible values)
- **Array**: `interphone_channel_color_values`
- **Default**: `1`
- **Notes**: DMR color code for network identification

#### 9. **Channel Mode**
- **Field**: `channelMode` (int)
- **UI Element**: `mTvChannelInputMode` (TextView)
- **Values**:
  - `0` = Direct Mode
  - `4` = Double Slot Mode
- **Array**: `interphone_channel_input_mode_values`
- **Default**: `0` (Direct Mode)

#### 10. **Slot**
- **Field**: `inBoundSlot` and `outBoundSlot` (int)
- **UI Element**: `mTvChannelSlot` (TextView)
- **Values**:
  - Slot 1: `inBoundSlot=0, outBoundSlot=0`
  - Slot 2: `inBoundSlot=1, outBoundSlot=1`
- **Array**: `interphone_channel_slot_mode_values`
- **Default**: Slot 1 (`0`)
- **Notes**: DMR TDMA time slot selection

#### 11. **Contact Type**
- **Field**: `contactType` (int)
- **UI Element**: `mTvChannelContactType` (TextView)
- **Values**:
  - `0` = Person (Private Call)
  - `1` = Group (Group Call)
  - `2` = All (All Call/Broadcast)
- **Array**: `interphone_channel_contact_type_values`
- **Default**: `0` (Person)
- **Interface Constants**: `ChannelContactType.PERSON = 0`, `ChannelContactType.GROUP = 1`, `ChannelContactType.ALL = 2`
- **Notes**: Determines call type and whether Call Number field is shown

#### 12. **Call Number (TX Contact)**
- **Field**: `txContact` (int)
- **UI Element**: `mTvChannelCallNumber` (EditText)
- **Values**: 
  - Person: DMR ID (1-16777215)
  - Group: Group ID (1-16777215)
  - All: Hidden (not used)
- **Default**: `1`
- **Notes**: Label changes based on Contact Type:
  - Person → "Call Name"
  - Group → "Group Call Name"
  - All → Field hidden

#### 13. **Encryption**
- **Field**: `encryptSw` (int)
- **UI Element**: `mTvChannelEncryption` (TextView)
- **Values**:
  - `2` = Disabled
  - `1` = Enabled
- **Array**: `interphone_channel_encryption_values`
- **Default**: `2` (Disabled)
- **Notes**: Shows/hides Encryption Key field

#### 14. **Encryption Key**
- **Field**: `encryptKey` (String)
- **UI Element**: `mTvChannelEncryptionKey` (EditText)
- **Values**: Numeric string (encryption key)
- **Default**: "" (empty)
- **Visibility**: Only shown when Encryption is Enabled

#### 15. **Transmission Interruption**
- **Field**: `interrupt` (int)
- **UI Element**: `mTvChannelInterruptTransmission` (TextView)
- **Values**:
  - `1` = ON (Open)
  - `2` = OFF
  - `3` = Transport (Transmit)
- **Array**: `interphone_channel_interrupt_transmission_array`
- **Default**: `2` (OFF)
- **Interface Constants**: `ChannelInterrupt.OPEN = 1`, `ChannelInterrupt.OFF = 2`, `ChannelInterrupt.TRANSPORT = 3`
- **Notes**: Special behavior when set to Transport - disables busy lock (`pref_person_busy_no_send = false`)

#### 16. **Group List**
- **Field**: `groups` (int[32])
- **UI Element**: `groupGridview` (GridView with checkboxes)
- **Values**: Array of 32 integers (0 or 1 for each group)
- **Default**: All 0 except `groups[0] = 1`
- **Notes**: Bitmap of which groups this channel monitors

---

### 🟢 ANALOG-ONLY PROPERTIES

#### 17. **Bandwidth (Band)**
- **Field**: `band` (int)
- **UI Element**: `mTvChannelBand` (TextView)
- **Values**:
  - `0` = Narrow Band (12.5 kHz)
  - `1` = Wide Band (25 kHz)
- **Array**: `interphone_channel_band_values`
- **Default**: `0` (Narrow - from ChannelData constructor)
- **Notes**: Determines channel bandwidth

#### 18. **Squelch (SQ)**
- **Field**: `sq` (int)
- **UI Element**: `mTvChannelSq` (TextView)
- **Values**: `1-9`
- **Array**: `interphone_channel_sq_values` (note: doesn't include 0!)
- **Default**: `2`
- **Notes**: 
  - Lower = more sensitive (opens on weaker signals)
  - Higher = less sensitive (requires stronger signal)
  - Array only contains 1-9, but firmware also supports 0
  - ⚠️ **Hardware Limitation**: Firmware forces squelch to 2 regardless of setting
  - ✅ **Software Squelch**: DMRModHooks implements software squelch (see MainHook.java)

#### 19. **TX Type**
- **Field**: `txType` (int)
- **UI Element**: `mTvChannelTxtype` (TextView)
- **Values**:
  - `0` = Wave (No tone)
  - `1` = CTC (CTCSS)
  - `2` = PDCS (Forward DCS / Normal DCS)
  - `3` = NDCS (Backward DCS / Inverted DCS)
- **Array**: `interphone_channel_txtype_values`
- **Default**: `0` (Wave)
- **Notes**: Shows/hides TX Subcode field

#### 20. **TX Subcode**
- **Field**: `txSubCode` (int - index into array)
- **UI Element**: `mTvChannelTxSub` (TextView)
- **Values**: Depends on TX Type:
  - **Wave (0)**: No subcode (value = 0)
  - **CTC (1)**: Index into CTCSS array (50 tones, 62.5 Hz to 254.1 Hz)
  - **PDCS (2)**: Index into Forward DCS array (83 codes, 023N-754N)
  - **NDCS (3)**: Index into Backward DCS array (83 codes, 023l-754l)
- **Arrays**:
  - `interphone_channel_subcode_ctcsss_values` (50 tones)
  - `interphone_channel_subcode_fdcs_values` (83 codes, "N" suffix)
  - `interphone_channel_subcode_bdcs_values` (83 codes, "l" suffix)
- **Default**: `0`
- **Visibility**: Hidden when TX Type = Wave

#### 21. **RX Type**
- **Field**: `rxType` (int)
- **UI Element**: `mTvChannelRxtype` (TextView)
- **Values**: Same as TX Type
  - `0` = Wave (No tone)
  - `1` = CTC (CTCSS)
  - `2` = PDCS (Forward DCS)
  - `3` = NDCS (Backward DCS)
- **Array**: `interphone_channel_txtype_values` (same array as TX)
- **Default**: `0` (Wave)
- **Notes**: Shows/hides RX Subcode field

#### 22. **RX Subcode**
- **Field**: `rxSubCode` (int - index into array)
- **UI Element**: `mTvChannelRxSub` (TextView)
- **Values**: Same structure as TX Subcode
- **Arrays**: Same as TX Subcode
- **Default**: `0`
- **Visibility**: Hidden when RX Type = Wave

---

## CTCSS Tones (50 total)

```
62.5Hz,  67.0Hz,  69.3Hz,  71.9Hz,  74.4Hz,  77.0Hz,  79.7Hz,  82.5Hz,  85.4Hz,  88.5Hz
91.5Hz,  94.8Hz,  97.4Hz,  100.0Hz, 103.5Hz, 107.2Hz, 110.9Hz, 114.8Hz, 118.8Hz, 123.0Hz
127.3Hz, 131.8Hz, 136.5Hz, 141.3Hz, 146.2Hz, 151.4Hz, 156.7Hz, 159.8Hz, 162.2Hz, 165.5Hz
167.9Hz, 171.3Hz, 173.8Hz, 177.3Hz, 179.9Hz, 183.5Hz, 186.2Hz, 189.9Hz, 192.8Hz, 196.6Hz
199.5Hz, 203.5Hz, 206.5Hz, 210.7Hz, 218.1Hz, 225.7Hz, 229.1Hz, 233.6Hz, 241.8Hz, 250.3Hz, 254.1Hz
```

## DCS Codes (83 per type)

### Forward DCS (PDCS) - Normal polarity, "N" suffix
```
023N, 025N, 026N, 031N, 032N, 043N, 047N, 051N, 054N, 065N, 071N, 072N, 073N, 074N
114N, 115N, 116N, 125N, 131N, 132N, 134N, 143N, 152N, 155N, 156N, 162N, 165N, 172N, 174N
205N, 223N, 226N, 243N, 244N, 245N, 251N, 261N, 263N, 265N, 271N, 306N, 311N, 315N, 331N
343N, 346N, 351N, 364N, 365N, 371N, 411N, 412N, 413N, 423N, 431N, 432N, 445N, 464N, 465N
466N, 503N, 506N, 516N, 532N, 546N, 565N, 606N, 612N, 624N, 627N, 631N, 632N, 654N, 662N
664N, 703N, 712N, 723N, 731N, 732N, 734N, 743N, 754N
```

### Backward DCS (NDCS) - Inverted polarity, "l" suffix
```
023l, 025l, 026l, 031l, 032l, 043l, 047l, 051l, 054l, 065l, 071l, 072l, 073l, 074l
114l, 115l, 116l, 125l, 131l, 132l, 134l, 143l, 152l, 155l, 156l, 162l, 165l, 172l, 174l
205l, 223l, 226l, 243l, 244l, 245l, 251l, 261l, 263l, 265l, 271l, 306l, 311l, 315l, 331l
343l, 346l, 351l, 364l, 365l, 371l, 411l, 412l, 413l, 423l, 431l, 432l, 445l, 464l, 465l
466l, 503l, 506l, 506l, 516l, 532l, 546l, 565l, 606l, 612l, 624l, 627l, 631l, 632l, 654l
662l, 664l, 703l, 712l, 723l, 731l, 732l, 734l, 743l, 754l
```

---

## Frequency Ranges by Region

### Digital Channels

- **Default UHF**: 401-408 MHz (401025000-408025000 Hz)
- **Default VHF**: 137-144 MHz (137025000-144025000 Hz)

### Analog Channels (Region-Specific)

- **Australia**: 476.425-477.000 MHz (40 channels, 25 kHz spacing)
- **China**: 409.750-409.987 MHz (20 channels, 12.5 kHz spacing)
- **Taiwan**: 467.512-467.675 MHz (14 channels, 12.5 kHz spacing)
- **EU (PMR446)**: 446.006-446.093 MHz (8 channels, 12.5 kHz spacing)
- **Iran**: 433.825-433.987 MHz (14 channels, 12.5 kHz spacing)
- **Japan**: 422.050-422.300 MHz (20 channels, 12.5 kHz spacing)
- **Korea**: 448.750-449.262 MHz (25 channels, 12.5 kHz spacing)
- **Malaysia**: 477.525-477.987 MHz (27 channels, 12.5 kHz spacing)
- **Norway**: 444.600-444.975 MHz (6 channels, variable spacing)
- **Russia**: 433.075-433.800 MHz (8 channels, variable spacing)
- **South Africa**: 463.975-464.325 MHz (4 channels, 150 kHz spacing)
- **USA (FRS/GMRS)**: 462.550-467.712 MHz (22 channels, 12.5/25 kHz spacing)
- **Default UHF**: 409-416 MHz (8 channels, 1 MHz spacing)
- **Default VHF**: 145-152 MHz (8 channels, 1 MHz spacing)

---

## Firmware vs App Constraints

### App-Level Constraints
1. **Channel Type**: Cannot be changed after creation (UI hidden in edit mode)
2. **Squelch Array**: Only offers 1-9, not 0 (though 0 is valid in firmware)
3. **Subcode Visibility**: Automatically shown/hidden based on TX/RX Type
4. **Encryption Key**: Only shown when Encryption is enabled
5. **Call Number**: Hidden when Contact Type = All
6. **Group List**: Only shown for Digital channels

### Known Firmware Constraints
1. **Squelch 0**: May not work as expected (possibly means "off" or is invalid)
   - ⚠️ **CONFIRMED**: Hardware firmware ignores squelch setting and forces it to 2
   - ✅ **WORKAROUND**: DMRModHooks uses software squelch (see MainHook.java)
2. **Relay Disconnect**: Enable mode may prevent transmission (firmware limitation)
3. **Frequency Validation**: Firmware validates frequency ranges, but app doesn't prevent invalid input
4. **ColorCode**: Must be 0-15 (enforced by firmware)
5. **Encryption Key**: Format/length validated by firmware (not enforced in app UI)

---

## Data Model Constants (ChannelData.java)

```java
// Channel Type
public static final int DIGITAL = 0;
public static final int ANALOG = 1;

// Power
public static final int LOW = 0;
public static final int HIGE = 1;  // Typo in original code

// Contact Type
public static final int PERSON = 0;
public static final int GROUP = 1;
public static final int ALL = 2;

// Interrupt
public static final int OPEN = 1;
public static final int OFF = 2;
public static final int TRANSPORT = 3;
```

---

## Default Values (New Channel)

```java
type = 0;                    // Digital
number = 0;
txFreq = 401025000;          // 401.025 MHz
rxFreq = 401025000;          // 401.025 MHz
power = 1;                   // High
cc = 1;                      // ColorCode 1
inBoundSlot = 0;             // Slot 1
outBoundSlot = 0;            // Slot 1
channelMode = 0;             // Direct Mode
contactType = 0;             // Person
txContact = 1;               // ID 1
encryptSw = 2;               // Disabled
encryptKey = "";             // Empty
mic = 0;
relay = 2;                   // Disabled (normal operation)
interrupt = 2;               // OFF
band = 0;                    // Narrow
sq = 2;                      // Squelch 2
rxType = 0;                  // Wave (no tone)
rxSubCode = 0;
txType = 0;                  // Wave (no tone)
txSubCode = 0;
active = 0;
groups = [1,0,0,0...];       // Only group 0 active
```

---

## Quick Reference Table

| Property | Field Name | Analog | Digital | Common | Values | Default |
|----------|-----------|--------|---------|--------|--------|---------|
| Channel Name | `name` | ✅ | ✅ | ✅ | String | Auto-generated |
| Channel Type | `type` | N/A | N/A | ✅ | 0=Digital, 1=Analog | 0 |
| TX Frequency | `txFreq` | ✅ | ✅ | ✅ | 136-480 MHz (int Hz) | 401025000 |
| RX Frequency | `rxFreq` | ✅ | ✅ | ✅ | 136-480 MHz (int Hz) | 401025000 |
| Frequency Band | — | ✅ | ✅ | ✅ | UHF/VHF (display only) | UHF |
| Power | `power` | ✅ | ✅ | ✅ | 0=Low, 1=High | 1 |
| Bandwidth | `band` | ✅ | ❌ | — | 0=Narrow, 1=Wide | 0 |
| Squelch | `sq` | ✅ | ❌ | — | 1-9 (0 also valid) | 2 |
| ColorCode | `cc` | ❌ | ✅ | — | 0-15 | 1 |
| Channel Mode | `channelMode` | ❌ | ✅ | — | 0=Direct, 4=Double Slot | 0 |
| Slot | `inBoundSlot`<br>`outBoundSlot` | ❌ | ✅ | — | 0=Slot1, 1=Slot2 | 0 |
| Contact Type | `contactType` | ❌ | ✅ | — | 0=Person, 1=Group, 2=All | 0 |
| Call Number | `txContact` | ❌ | ✅ | — | 1-16777215 (DMR ID) | 1 |
| Encryption | `encryptSw` | ❌ | ✅ | — | 1=Enabled, 2=Disabled | 2 |
| Encryption Key | `encryptKey` | ❌ | ✅ | — | String (numeric) | "" |
| Relay Disconnect | `relay` | ✅ | ✅ | ✅ | 1=Enable, 2=Disable | 2 |
| Transmission Interrupt | `interrupt` | ❌ | ✅ | — | 1=ON, 2=OFF, 3=Transport | 2 |
| Group List | `groups` | ❌ | ✅ | — | int[32] bitmap | [1,0,0...] |
| TX Type | `txType` | ✅ | ❌ | — | 0=Wave, 1=CTC, 2=PDCS, 3=NDCS | 0 |
| TX Subcode | `txSubCode` | ✅ | ❌ | — | Index into CTCSS/DCS array | 0 |
| RX Type | `rxType` | ✅ | ❌ | — | 0=Wave, 1=CTC, 2=PDCS, 3=NDCS | 0 |
| RX Subcode | `rxSubCode` | ✅ | ❌ | — | Index into CTCSS/DCS array | 0 |

---

## Notes

### Terminology Clarifications
- **CTC** = CTCSS (Continuous Tone-Coded Squelch System)
- **PDCS** = Forward/Normal DCS (Digital Coded Squelch)
- **NDCS** = Backward/Inverted DCS
- **Wave** = No tone (carrier wave only)
- **Direct Mode** = Simplex (direct radio-to-radio)
- **Double Slot Mode** = TDMA (time-division multiple access)

### Important Behavior Notes
1. **Relay Disconnect**: Naming is confusing! "Disable" = normal operation, "Enable" = disconnect from repeater
2. **Squelch**: Array only includes 1-9, but 0 is valid in data model (likely means "fully open")
3. **Encryption Key**: Not validated in UI, but firmware may enforce format/length
4. **Group List**: Only group 0 is active by default
5. **Active Channel**: Has special sync behavior (immediate hardware update)

### Software Squelch Implementation (DMRModHooks)
Since hardware firmware forces squelch to level 2 regardless of settings:
- **Solution**: Software squelch in MainHook.java
- **Method**: Intercepts PCM audio before AudioTrack.write()
- **Algorithm**: RMS + RSSI hybrid with hysteresis and hang time
- **Features**:
  - Optimized RMS calculation (4× faster via subsampling)
  - 300ms hang time to prevent tail cutting
  - Preserves audio for APRS decoding/recording
- **Location**: PCMReceiveManager hook in MainHook.java
- **Status**: ✅ Working correctly, full control over squelch 0-9

---

## Related Documentation
- [RELAY_HELP_DIALOG_RELEASE.md](RELAY_HELP_DIALOG_RELEASE.md) - Relay disconnect feature details
- [aprs-squelch-investigation.md](#) - Squelch system investigation (in user memory)
- [ANDROID_APRS_RECEIVER_IMPLEMENTATION.md](ANDROID_APRS_RECEIVER_IMPLEMENTATION.md) - APRS implementation

---

**Last Updated**: March 26, 2026
