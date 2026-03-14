# VFO (Variable Frequency Oscillator) Feature Implementation Plan

## Overview
Add a VFO mode to the PriInterPhone app that allows temporary frequency changes without saving channels. Similar to APRS monitoring mode, it will temporarily hijack the current channel, allow the user to tune to any frequency, and restore the original channel when exiting.

## Architecture Pattern (Based on APRS Implementation)

### 1. Button Placement
**Location**: Interface page (InterPhoneTalkBackFragment) - Below TXT button, left side

**Current Button Layout**:
```
┌────────────────────────────────────────────────┐
│                 Channel Info                   │
│              (Horizontal Container)            │
│         [RSSI / Zone Container]                │
│              [Squelch Slider]                  │
│               [Border Box]                     │
│                 [Spacer]                       │
│                                                │
│  [Soft SQ]                       [REC]        │
│  (top-left)                      (top-right)  │
│                                                │
│  [TXT]        [PTT]              [MON]        │
│  (left)       (center)           (right)      │
│                                                │
│  **[VFO]**                       [APRS]       │
│  (bottom-left)                   (bottom-right)│
└────────────────────────────────────────────────┘
```

**VFO Button Specs**:
- Size: 70dp width × 40dp height
- Position: `Gravity.START | Gravity.BOTTOM`
- Margins: 10dp left, 10dp bottom (above TXT button position)
- Colors: 
  - ON: Solid orange (#FF9800)
  - OFF: Light orange (60% transparent #60FF9800)
- Text: "VFO"
- Font: Bold, 12sp

### 2. State Management Variables

Add to MainHook.java (after APRS state variables):

```java
// VFO mode state
private static volatile boolean isVFOModeActive = false;
private static AlertDialog vfoDialog = null;
private static android.widget.ToggleButton vfoModeToggleButton = null;

// VFO settings (temporary, not persisted)
private static int vfoChannelMode = 1;  // 0=Digital/DMR, 1=Analog (default analog)
private static double vfoFrequencyMHz = 146.520;  // Default simplex frequency
private static int vfoPowerLevel = 1;  // 0=Low, 1=High

// Analog-specific settings
private static int vfoRxToneType = 0;  // 0=None, 1=CTCSS, 2=FDCS, 3=BDCS
private static int vfoRxToneCode = 0;
private static int vfoTxToneType = 0;
private static int vfoTxToneCode = 0;
private static int vfoBandWidth = 0;   // 0=12.5kHz, 1=25kHz

// Digital/DMR-specific settings
private static int vfoContactType = 1;  // 0=Private, 1=Group, 2=All
private static int vfoTxContact = 9;    // TalkGroup ID (default: Worldwide 9)
private static int vfoColorCode = 1;    // 0-15 (default: 1)
private static int vfoSlot = 1;         // 0=Slot1, 1=Slot2

// Software squelch (like APRS - enabled by default in VFO)
private static volatile boolean isVfoSoftwareSquelchEnabled = true;
private static volatile int vfoSoftwareSquelchThreshold = 3;  // 0-9 (3 = moderate)
private static int savedVfoSquelchThreshold = 3;  // Saved for restore

// VFO backup system (same pattern as APRS)
private static java.util.HashMap<String, Object> vfoChannelBackup = null;
```

### 3. Button Creation Code

**Location**: MainHook.java, hookTalkBackFragment(), after APRS button creation (~line 2020)

```java
// Create VFO toggle button (below TXT button, left side)
android.widget.ToggleButton vfoButton = new android.widget.ToggleButton(context);
vfoButton.setTag("DMR_VFO_TOGGLE");
vfoButton.setTextOn("VFO");
vfoButton.setTextOff("VFO");
vfoButton.setChecked(false);

FrameLayout.LayoutParams vfoButtonParams = new FrameLayout.LayoutParams(
    (int) (70 * context.getResources().getDisplayMetrics().density),  // 70dp width
    (int) (40 * context.getResources().getDisplayMetrics().density)   // 40dp height
);
vfoButtonParams.gravity = android.view.Gravity.START | android.view.Gravity.BOTTOM;
vfoButtonParams.leftMargin = (int) (10 * context.getResources().getDisplayMetrics().density);
vfoButtonParams.bottomMargin = (int) (10 * context.getResources().getDisplayMetrics().density);
vfoButton.setLayoutParams(vfoButtonParams);
vfoButton.setTextSize(12);
vfoButton.setTypeface(null, android.graphics.Typeface.BOLD);
vfoButton.setTextColor(0xFFFFFFFF);  // White text

// Create state list drawable for VFO button
android.graphics.drawable.StateListDrawable vfoStateDrawable = new android.graphics.drawable.StateListDrawable();

// Checked state (VFO active) - Orange background
android.graphics.drawable.GradientDrawable vfoCheckedDrawable = new android.graphics.drawable.GradientDrawable();
vfoCheckedDrawable.setShape(android.graphics.drawable.GradientDrawable.RECTANGLE);
vfoCheckedDrawable.setColor(0xFFFF9800);  // Orange
vfoCheckedDrawable.setCornerRadius(20 * context.getResources().getDisplayMetrics().density);
vfoCheckedDrawable.setStroke(
    (int) (2 * context.getResources().getDisplayMetrics().density),
    0xFFFFFFFF  // White border
);
vfoStateDrawable.addState(new int[]{android.R.attr.state_checked}, vfoCheckedDrawable);

// Unchecked state (VFO inactive) - Light orange background
android.graphics.drawable.GradientDrawable vfoUncheckedDrawable = new android.graphics.drawable.GradientDrawable();
vfoUncheckedDrawable.setShape(android.graphics.drawable.GradientDrawable.RECTANGLE);
vfoUncheckedDrawable.setColor(0x60FF9800);  // Light orange
vfoUncheckedDrawable.setCornerRadius(20 * context.getResources().getDisplayMetrics().density);
vfoUncheckedDrawable.setStroke(
    (int) (2 * context.getResources().getDisplayMetrics().density),
    0x80FFFFFF  // Semi-transparent white border
);
vfoStateDrawable.addState(new int[]{}, vfoUncheckedDrawable);

vfoButton.setBackground(vfoStateDrawable);

// Store reference
vfoModeToggleButton = vfoButton;

// Set click listener
vfoButton.setOnClickListener(new View.OnClickListener() {
    @Override
    public void onClick(View v) {
        if (vfoButton.isChecked()) {
            // Entering VFO mode
            showVFODialog((Activity) context);
        } else {
            // Exiting VFO mode
            stopVFOMode((Activity) context);
        }
    }
});

buttonContainer.addView(vfoButton);
XposedBridge.log(TAG + ": ✓ Added VFO toggle button below TXT button");
```

### 4. VFO Dialog UI

**Method**: `showVFODialog(Activity activity)`

**Layout Structure**:
```
┌──────────────────────────────────────────────┐
│              📻 VFO Mode                     │
├──────────────────────────────────────────────┤
│  Mode:  🔘 Analog (FM)  ⚪ Digital (DMR)     │
│                                              │
│  Frequency (MHz):                            │
│  [   146.520   ] [▲] [▼]                    │
│                                              │
│  Offset (MHz):  [+/-] [  0.600  ]           │
│                                              │
│  Power:  ⚪ Low  🔘 High                     │
│                                              │
│  ──────── ANALOG SETTINGS ────────           │
│  (Visible only when Analog selected)         │
│                                              │
│  Bandwidth:  🔘 12.5kHz  ⚪ 25kHz            │
│                                              │
│  Software Squelch (0-9): [────●────] 3      │
│  ⚠️ Using software squelch (hardware open)   │
│                                              │
│  RX Tone:                                    │
│    Type: [None ▼]  Code: [     ]            │
│                                              │
│  TX Tone:                                    │
│    Type: [None ▼]  Code: [     ]            │
│                                              │
│  ──────── DIGITAL SETTINGS ────────          │
│  (Visible only when Digital selected)        │
│                                              │
│  Contact Type:  🔘 Group  ⚪ Private  ⚪ All │
│                                              │
│  TalkGroup ID:  [    9    ] (Worldwide)     │
│                                              │
│  CoMode Selection** (NEW):
   - RadioGroup: Analog (FM) / Digital (DMR)
   - Dynamic UI: Shows/hides relevant settings based on mode
   - Analog: Tones, bandwidth, software squelch
   - Digital: TalkGroup, color code, timeslot

2. **Frequency Control**:
   - EditText with numeric keyboard
   - Up/Down buttons for tuning (±0.025 MHz steps)
   - Long press for faster steps (±1 MHz)
   - Range validation (136-174 MHz VHF, 400-480 MHz UHF)

3. **Offset Control**:
   - Toggle +/- direction
   - EditText for offset amount (typically 0.600 for 2m, 5.0 for 70cm)
   - Quick presets: None, +0.600, -0.600, +5.0, -5.0

4. **Power Selection**:
   - RadioGroup: Low (0) / High (1)

5. **Analog-Specific Controls**:
   a. **Bandwidth Selection**:
      - RadioGroup: 12.5kHz (0) / 25kHz (1)
   
   b. **Software Squelch Control** (NEW - like APRS):
      - SeekBar (0-9 range)
      - Real-time value display
      - **Always uses software squelch** (hardware set to 0)
      - Warning message: "⚠️ Using software squelch (hardware open)"
      - Live audio gating (same as APRS implementation)
      - Threshold 0 = most sensitive, 9 = least sensitive
   
   c. **Tone Controls** (RX and TX separate):
      - Spinner: None / CTCSS / FDCS / BDCS
      - EditText/Spinner for tone code (context-aware based on type)
      - CTCSS: 67.0-254.1 Hz (string values)
      - DCS: 000-777 (octal codes)

6. **Digital/DMR-Specific Controls** (NEW):
   a. **Contact Type**:
      - RadioGroup: Private (0) / Group (1) / All (2)
      - Default: Group (most common for simplex/repeaters)
   
   b. **TalkGroup ID**:
      - EditText with numeric keyboard
      - Default: 9 (Worldwide)
      - Common presets: 9 (WW), 3100 (USA), 91 (Worldwide English)
   
   c. **Color Code**:
      - EditText/Spinner (0-15 range)
      - Default: 1 (most common)
      - Validates against radio's supported range
   
   d. **Timeslot Selection**:
      - RadioGroup: Slot 1 (0) / Slot 2 (1)
      - Default: Slot 2 (common for simplex)
      - Info tooltip: "Most repeaters use TS1=primary, TS2=secondary"

7. **Quick Presets**:
   - Common simplex frequencies: 146.520, 446.0, 446.1, 446.2, etc.
   - Popular repeaters (user-configurable)
   - Quick band switching (2m, 70cm, business band)
   - **Mode-aware**: Different presets shown for analog vs digital

8. **Status Display**:
   - Live TX/RX frequency display
   - Mode indicator: "VFO ACTIVE (Analog FM)" or "VFO ACTIVE (Digital DMR)"
   - Software squelch level (analog mode)
   - TalkGroup/Color Code (digital mode)
   - Green "VFO ACTIVE" indicator
   - Real-time value display
   - Direct AnalogMessage.send() on change (like APRS squelch)

6. **Tone Controls** (RX and TX separate):
   - Spinner: None / CTCSS / FDCS / BDCS
   - EditText/Spinner for tone code (context-aware based on type)
   - CTCSS: 67.0-254.1 Hz (string values)
   - DCS: 000-777 (octal codes)

7. **Quick Presets**:
   - Common simplex frequencies: 146.520, 446.0, 446.1, 446.2, etc.
   - Pop// DMR-specific fields
        vfoChannelBackup.put("contactType", XposedHelpers.getIntField(channel, "contactType"));
        vfoChannelBackup.put("txContact", XposedHelpers.getIntField(channel, "txContact"));
        vfoChannelBackup.put("colorCode", XposedHelpers.getIntField(channel, "colorCode"));
        vfoChannelBackup.put("inBoundSlot", XposedHelpers.getIntField(channel, "inBoundSlot"));
        vfoChannelBackup.put("outBoundSlot", XposedHelpers.getIntField(channel, "outBoundSlot"));
        
        // Save current squelch state (software vs hardware)
        vfoChannelBackup.put("wasSoftwareSquelchEnabled", isSoftwareSquelchEnabled);
        vfoChannelBackup.put("savedSquelchThreshold", softwareSquelchThreshold);
        
        XposedBridge.log(TAG + ": VFO channel backup saved: " + vfoChannelBackup.get("name") + 
            " (type=" + vfoChannelBackup.get("type") + ")"
   - Quick band switching (2m, 70cm, business band)

8. **Status Display**:
   - Live TX/RX frequency display
   - Green "VFO ACTIVE" indicator
   - Signal strength meter (if available)

### 5. Channel Backup/Restore System

**Pattern**: Identical to APRS implementation

#### A. Backup on VFO Entry

**Method**: `saveVFOChannelBackup(Object channel)`

```java
private void saveVFOChannelBackup(Object channel) {
    try {
        vfoChannelBackup = new java.util.HashMap<>();
        vfoChannelBackup.put("number", XposedHelpers.getIntField(channel, "number"));
        vfoChannelBackup.put("type", XposedHelpers.getIntField(channel, "type"));
        vfoChannelBackup.put("name", XposedHelpers.getObjectField(channel, "name"));
        vfoChannelBackup.put("rxFreq", XposedHelpers.getIntField(channel, "rxFreq"));
        vfoChannelBackup.put("txFreq", XposedHelpers.getIntField(channel, "txFreq"));
        vfoChannelBackup.put("sq", XposedHelpers.getIntField(channel, "sq"));
        vfoChannelBackup.put("band", XposedHelpers.getIntField(channel, "band"));
        vfoChannelBackup.put("power", XposedHelpers.getIntField(channel, "power"));
        vfoChannelBackup.put("rxType", XposedHelpers.getIntField(channel, "rxType"));
        vfoChannelBackup.put("rxSubCode", XposedHelpers.getIntField(channel, "rxSubCode"));
        vfoChannelBackup.put("txType", XposedHelpers.getIntField(channel, "txType"));
        vfoChannelBackup.put("txSubCode", XposedHelpers.getIntField(channel, "txSubCode"));
        
        XposedBridge.log(TAG + ": VFO channel backup saved: " + vfoChannelBackup.get("name"));
        
        // Also save to file (crash recovery)
        saveVFOChannelBackupToFile(vfoChannelBackup);
    } catch (Exception e) {
        XposedBridge.log(TAG + ": Error saving VFO channel backup: " + e.getMessage());
    }
}
```

#### B. File-Based Backup (Crash Recovery)

**File**: `/sdcard/vfo_channel_backup.dat`

**Methods**:
- `saveVFOChannelBackupToFile(HashMap backup)` - Serialize to file
- `loadVFOChannelBackupFromFile()` - Deserialize from file
- `deleteVFOChannelBackupFile()` - Cleanup after restore

**Format**: Java serialization (same as APRS)

#### C. Restore on VFO Exit

**Method**: `restoreVFOChannelBackup(Context context)`

```java
private void restoreVFOChannelBackup(Context context) {
    try {
        if (vfoChannelBackup == null) {
            XposedBridge.log(TAG + ": No VFO channel backup found");
            return;
        }
        
        Class<?> dmrManagerClass = XposedHelpers.findClass(
            "com.pri.prizeinterphone.manager.DmrManager",
            appClassLoader
        );
        Object dmrManager = XposedHelpers.callStaticMethod(dmrManagerClass, "getInstance");
        Object currentChannel = XposedHelpers.callMethod(dmrManager, "getCurrentChannel");
        
        if (currentChannel == null) {
            XposedBridge.log(TAG + ": Cannot get current channel for VFO restore");
            return;
        }
        
        XposedBridge.log(TAG + ": Restoring channel from VFO backup: " + vfoChannelBackup.get("name"));
        
        // Restore all fields (including channel number)
        XposedHelpers.setIntField(currentChannel, "number", (Integer) vfoChannelBackup.get("number"));
        XposedHelpers.setIntField(currentChannel, "type", (Integer) vfoChannelBackup.get("type"));
        XposedHelpers.setObjectField(currentChannel, "name", vfoChannelBackup.get("name"));
        XposedHelpers.setIntField(currentChannel, "rxFreq", (Integer) vfoChannelBackup.get("rxFreq"));
        XposedHelpers.setIntField(currentChannel, "txFreq", (Integer) vfoChannelBackup.get("txFreq"));
        XposedHelpers.setIntField(currentChannel, "sq", (Integer) vfoChannelBackup.get("sq"));
        XposedHelpers.setIntField(currentChannel, "band", (Integer) vfoChannelBackup.get("band"));
        XposedHelpers.setIntField(currentChannel, "power", (Integer) vfoChannelBackup.get("power"));
        XposedHelpers.setIntField(currentChannel, "rxType", (Integer) vfoChannelBackup.get("rxType"));
        XposedHelpers.setIntField(currentChannel, "rxSubCode", (Integer) vfoChannelBackup.get("rxSubCode"));
        XposedHelpers.setIntField(currentChannel, "txType", (Integer) vfoChannelBackup.get("txType"));
        XposedHelpers.setIntField(currentChannel, "txSubCode", (Integer) vfoChannelBackup.get("txSubCode"));
        exists
2. Save channel backup (memory + file) including software squelch state
3. Hijack current channel with VFO settings:
   - Change name to "VFO (original name)"
   - Set type based on `vfoChannelMode` (0=Digital, 1=Analog)
   - Apply VFO frequency, power, settings
4. **Enable VFO software squelch** (if analog mode)
5. Update hardware via appropriate message (AnalogMessage or DigitalMessage)
6. Set `isVFOModeActive = true`
7. Show VFO dialog

```java
private void startVFOMode(final Activity activity) {
    try {
        XposedBridge.log(TAG + ": Starting VFO mode (type=" + (vfoChannelMode == 0 ? "Digital" : "Analog") + ")");
        
        Class<?> dmrManagerClass = XposedHelpers.findClass(
            "com.pri.prizeinterphone.manager.DmrManager",
            appClassLoader
        );
        Object dmrManager = XposedHelpers.callStaticMethod(dmrManagerClass, "getInstance");
        Object currentChannel = XposedHelpers.callMethod(dmrManager, "getCurrentChannel");
        
        if (currentChannel == null) {
            throw new Exception("Cannot get current channel");
        }
        
        // Save backup (includes current squelch state)
        saveVFOChannelBackup(currentChannel);
        
        // Hijack channel with VFO settings
        XposedHelpers.setIntField(currentChannel, "type", vfoChannelMode);
        String originalName = (String) XposedHelpers.getObjectField(currentChannel, "name");
        String modeLabel = (vfoChannelMode == 0) ? "DMR" : "FM";
        XposedHelpers.setObjectField(currentChannel, "name", "VFO-" + modeLabel + " (" + originalName + ")");
        
        int vfoRxFreqHz = (int) (vfoFrequencyMHz * 1000000);
        int vfoTxFreqHz = vfoRxFreqHz;  // Simplex by default (offset handled separately)
        
        XposedHelpers.setIntField(currentChannel, "rxFreq", vfoRxFreqHz);
        XposedHelpers.setIntField(currentChannel, "txFreq", vfoTxFreqHz);
        XposedHelpers.setIntField(currentChannel, "band", determineBand(vfoFrequencyMHz));
        XposedHelpers.setIntField(currentChannel, "power", vfoPowerLevel);
        
        if (vfoChannelMode == 1) {
            // Analog mode - set hardware squelch to 0, use software squelch
            XposedHelpers.setIntField(currentChannel, "sq", 0);  // Hardware fully open
            XposedHelpers.setIntField(currentChannel, "rxType", vfoRxToneType);
            XposedHelpers.setIntField(currentChannel, "rxSubCode", vfoRxToneCode);
            XposedHelpers.setIntField(currentChannel, "txType", vfoTxToneType);
            XposedHelpers.setIntField(currentChannel, "txSubCode", vfoTxToneCode);
        } else {
            // Digital mode - DMR settings
            XposedHelpers.setIntField(currentChannel, "contactType", vfoContactType);
            XposedHelpers.setIntField(currentChannel, "txContact", vfoTxContact);
            XposedHelpers.setIntField(currentChannel, "colorCode", vfoColorCode);
            XposedHelpers.setIntField(currentChannel, "inBoundSlot", vfoSlot);
            XposedHelpers.setIntField(currentChannel, "outBoundSlot", vfoSlot);
        }
        
        // Direct hardware update
        sendVFOChannelToHardware(currentChannel, vfoChannelMode);
        
        isVFOModeActive = true;
        currentChannelType = vfoChannelMode;
        
        // Enable VFO software squelch (analog only)
        if (vfoChannelMode == 1) {
            isVfoSoftwareSquelchEnabled = true;
            XposedBridge.log(TAG + ": VFO software squelch enabled (threshold=" + vfoSoftwareSquelchThreshold + ")");
        } else {
            isVfoSoftwareSquelchEnabled = false;
        }
        
        String modeStr = (vfoChannelMode == 0) ? "Digital DMR" : "Analog FM";
        Toast.makeText(activity, "VFO Mode Active (" + modeStr + "): " + vfoFrequencyMHz + " MHz", Toast.LENGTH_SHORT).show();
        XposedBridge.log(TAG + ": VFO mode started at " + vfoFrequencyMHz + " MHz (" + modeStr + ")
```java
private void startVFOMode(final Activity activity) {
    try {
        XposedBridge.log(TAG + ": Starting VFO mode");
        
        Class<?> dmrManagerClass = XposedHelpers.findClass(
            "com.pri.prizeinterphone.manager.DmrManager",
            appClassLoader
        );
        Object dmrManager = XposedHelpers.callStaticMethod(dmrManagerClass, "getInstance");
        Object currentChannel = XposedHelpers.callMethod(dmrManager, "getCurrentChannel");
        
        if (currentChannel == null) {
            throw new Exception("Cannot get current channel");
        }
        
        // Save backup
        saveVFOChannelBackup(currentChannel);
        
        // Hijack channel with VFO settings
        XposedHelpers.setIntField(currentChannel, "type", 1);  // ANALOG
        String originalName = (String) XposedHelpers.getObjectField(currentChannel, "name");
        XposedHelpers.setObjectField(currentChannel, "name", "VFO (" + originalName + ")");
        
        int vfoRxFreqHz = (int) (vfoFrequencyMHz * 1000000);
        int vfoTxFreqHz = vfoRxFreqHz;  // Simplex by default (offset handled separately)
        
        XposedHelpers.setIntField(currentChannel, "rxFreq", vfoRxFreqHz);
        XposedHelpers.setIntField(currentChannel, "txFreq", vfoTxFreqHz);
        XposedHelpers.setIntField(currentChannel, "sq", vfoSquelch);
        XposedHelpers.setIntField(currentChannel, "band", determineBand(vfoFrequencyMHz));
        XposedHelpers.setIntField(currentChannel, "power", vfoPowerLevel);
        XposedHelpers.setIntField(currentChannel, "rxType", vfoRxToneType);
        XposedHelpers.setIntField(currentChannel, "rxSubCode", vfoRxToneCode);
        XposedHelpers.setIntField(currentChannel, "txType", vfoTxToneType);
        XposedHelpers.setIntField(currentChannel, "txSubCode", vfoTxToneCode);
        
        // Direct hardware update
        sendVFOChannelToHardware(currentChannel);
        
        isVFOModeActive = true;
        currentChannelType = 1;  // Update to analog
        
        Toast.makeText(activity, "VFO Mode Active: " + vfoFrequencyMHz + " MHz", Toast.LENGTH_SHORT).show();
        XposedBridge.log(TAG + ": VFO mode started at " + vfoFrequencyMHz + " MHz");
        
    } catch (Exception e) {
        XposedBridge.log(TAG + ": Error starting VFO mode: " + e.getMessage());
        Toast.makeText(activity, "VFO Error: " + e.getMessage(), Toast.LENGTH_LONG).show();
        if (vfoModeToggleButton != null) {
            vfoModeToggleButton.setChecked(false);
        }
    }
}
```

#### B. Update VFO Settings (`applyVFOChanges()`)

**Trigger**: User clicks "Apply Changes" button in VFO dialog

**Steps**:
1. Read all settings from UI controls
2. Validate frequency range and tone codes
3. Update current channel fields
4. Send direct AnalogMessage to hardware
5. Update status display

```java
private void applyVFOChanges(Activity activity) {
    try {
        Class<?> dmrManagerClass = XposedHelpers.findClass(
            "com.pri.prizeinterphone.manager.DmrManager",
            appClassLoader
        );
        Object dmrManager = XposedHelpers.callStaticMethod(dmrManagerClass, "getInstance");
        Object currentChannel = XposedHelpers.callMethod(dmrManager, "getCurrentChannel");
        
        if (currentChannel == null) {
            throw new Exception("Cannot get current channel");
        }
        
        // Update channel with new VFO settings
        int rxFreqHz = (int) (vfoFrequencyMHz * 1000000);
        int txFreqHz = rxFreqHz;  // TODO: Apply offset
        
        XposedHelpers.setIntField(currentChannel, "rxFreq", rxFreqHz);
        XposedHelpers.setIntField(currentChannel, "txFreq", txFreqHz);
        XposedHelpers.setIntField(currentChannel, "sq", vfoSquelch);
        XposedHelpers.setIntField(currentChannel, "power", vfoPowerLevel);
        XposedHelpers.setIntField(currentChannel, "rxType", vfoRxToneType);
        XposedHelpers.setIntField(currentChannel, "rxSubCode", vfoRxToneCode);
        XposedHelpers.setIntField(currentChannel, "txType", vfoTxToneType);
        XposedHelpers.setIntField(currentChannel, "txSubCode", vfoTxToneCode);
        
        // Direct hardware update
        sendVFOChannelToHardware(currentChannel);
        
        Toast.makeText(activity, "VFO updated: " + vfoFrequencyMHz + " MHz", Toast.LENGTH_SHORT).show();
        XposedBridge.log(TAG + ": VFO settings applied");
        
    } catch (Exception e) {
        XposedBridge.log(TAG + ": Error applying VFO changes: " + e.getMessage());
        Toast.makeText(activity, "Error updating VFO", Toast.LENGTH_SHORT).show();
    }
}
```

#### C. Exit VFO Mode (`stopVFOMode()`)

**Steps**:
1. Restore channel from backup
2. Clear VFO state flags, int channelType)`

**Pattern**: Use direct message send (bypasses state machine)
- Analog: `AnalogMessage.send()` with hardware squelch=0
- Digital: `syncChannelInfoWithData()` for DMR settings

```java
private void sendVFOChannelToHardware(Object channel, int channelType) {
    try {
        if (channelType == 1) {
            // ANALOG MODE - Use AnalogMessage with hardware squelch=0
            Class<?> analogMessageClass = XposedHelpers.findClass(
                "com.pri.prizeinterphone.message.AnalogMessage",
                appClassLoader
            );
            Object analogMessage = analogMessageClass.newInstance();
            
            // Copy all channel fields
            XposedHelpers.callMethod(analogMessage, "setBand", 
                (byte) XposedHelpers.getIntField(channel, "band"));
            XposedHelpers.callMethod(analogMessage, "setPower", 
                (byte) XposedHelpers.getIntField(channel, "power"));
            XposedHelpers.callMethod(analogMessage, "setTxFreq", 
                XposedHelpers.getIntField(channel, "txFreq"));
            XposedHelpers.callMethod(analogMessage, "setRxFreq", 
                XposedHelpers.getIntField(channel, "rxFreq"));
            XposedHelpers.callMethod(analogMessage, "setSq", (byte) 0);  // ALWAYS 0 for software squelch
            XposedHelpers.callMethod(analogMessage, "setRxType", 
                (byte) XposedHelpers.getIntField(channel, "rxType"));
            XposedHelpers.callMethod(analogMessage, "setRxSubCode", 
                (byte) XposedHelpers.getIntField(channel, "rxSubCode"));
            XposedHelpers.callMethod(analogMessage, "setTxType", 
                (byte) XposedHelpers.getIntField(channel, "txType"));
            XposedHelpers.callMethod(analogMessage, "setTxSubCode", 
                (byte) XposedHelpers.getIntField(channel, "txSubCode"));
            
            // Send to hardware
            XposedHelpers.callMethod(analogMessage, "send");
            XposedBridge.log(TAG + ": VFO analog settings sent to hardware (hardware sq=0, software sq=" + 
                vfoSoftwareSquelchThreshold + ")");
            
        } else {
            // DIGITAL/DMR MODE - Use state machine for DMR
       Software Squelch Integration

**Architecture**: VFO uses **dedicated software squelch** (separate from intercom squelch)

#### A. Audio Processing Hook

**Location**: `hookPCMReceiveManager()` - Add VFO squelch check

```java
// In PCM write hook (after APRS squelch check):
if (isVFOModeActive && isVfoSoftwareSquelchEnabled && currentChannelType == 1) {
    // VFO analog mode with software squelch
    boolean shouldMute = !isAboveSquelchThreshold(rmsLevel, currentRssi, vfoSoftwareSquelchThreshold);
    
    if (shouldMute) {
        java.util.Arrays.fill(audioData, offset, offset + length, (short) 0);
        XposedBridge.log(TAG + ": VFO soft squelch muted (RMS=" + rmsLevel + 
            ", RSSI=" + currentRssi + ", threshold=" + vfoSoftwareSquelchThreshold + ")");
    }
}
```

#### B. Threshold Calculation

**Pattern**: Same as APRS software squelch (RMS + RSSI hybrid)

```java
private boolean isAboveSquelchThreshold(double rmsLevel, int rssi, int threshold) {
    // Threshold 0 = most sensitive (no muting)
    // Threshold 9 = least sensitive (mute everything)
    
    if (threshold == 0) {
        return true;  // Always pass (no squelch)
    }
    
    // Map threshold (0-9) to RMS level (0.0-1.0) with exponential scaling
    double rmsThreshold = Math.pow((threshold / 9.0), 2) * 0.5;  // 0.0 to 0.5
    
    // RSSI threshold: -120 dBm to -80 dBm (scaled by threshold)
    int rssiThreshold = -120 + (threshold * 4);  // -120, -116, -112, ... -84
    
    // Hybrid: Audio RMS OR RSSI above threshold
    return (rmsLevel > rmsThreshold) || (rssi > rssiThreshold);
}
```

#### C. VFO Squelch Controls in Dialog

**SeekBar in VFO Dialog**:
```java
// Software squelch slider (analog mode only)
SeekBar squelchSeekBar = new SeekBar(activity);
squelchSeekBar.setMax(9);
squelchSeekBar.setProgress(vfoSoftwareSquelchThreshold);

TextView squelchLabel = new TextView(activity);
squelchLabel.setText("Software Squelch: " + vfoSoftwareSquelchThreshold);

squelchSeekBar.setOnSeekBarChangeListener(new SeekBar.OnSeekBarChangeListener() {
    @Override
    public void onProgressChanged(SeekBar seekBar, int progress, boolean fromUser) {
        if (fromUser) {
            vfoSoftwareSquelchThreshold = progress;
            squelchLabel.setText("Software Squelch: " + progress);
            XposedBridge.log(TAG + ": VFO squelch threshold updated to " + progress);
        }
    }
    // ... onStartTrackingTouch, onStopTrackingTouch
});
```

### 9. Conflict Resolution

**Issue**: VFO and other modes (APRS, MON, Soft SQ) should not run simultaneously

**Solution**: Mutual exclusion checks

#### A. On VFO Entry:
```java
// In startVFOMode():
if (isAPRSMonitoringActive) {
    Toast.makeText(activity, "Cannot use VFO while APRS is active", Toast.LENGTH_SHORT).show();
    vfoModeToggleButton.setChecked(false);
    return;
}

// Disable intercom squelch (VFO has its own)
if (softwareSquelchToggleButton != null && softwareSquelchToggleButton.isChecked()) {
    softwareSquelchToggleButton.setChecked(false);
    isSoftwareSquelchEnabled = false;
    XposedBridge.log(TAG + ": Disabled intercom software squelch for VFO mode");
}

// Disable MON button
if (monitoringModeToggle != null && monitoringModeToggle.isChecked()) {
    monitoringModeToggle.setChecked(false);
    isMonitoringMode = false;
}

// Disable REC button (optional - could allow recording in VFO)
if (recordingToggleButton != null && recordingToggleButton.isChecked()) {
    recordingToggleButton.setChecked(false);
    isRecordingEnabledgMessage = analogMessageClass.newInstance();
        
        // Copy all channel fields
        XposedHelpers.callMethod(analogMessage, "setBand", 
            (byte) XposedHelpers.getIntField(channel, "band"));
        XposedHelpers.callMethod(analogMessage, "setPower", 
            (byte) XposedHelpers.getIntField(channel, "power"));
        XposedHelpers.callMethod(analogMessage, "setTxFreq", 
            XposedHelpers.getIntField(channel, "txFreq"));
        XposedHelpers.callMethod(analogMessage, "setRxFreq", 
            XposedHelpers.getIntField(channel, "rxFreq"));
        XposedHelpers.callMethod(analogMessage, "setSq", 
            (byte) XposedHelpers.getIntField(channel, "sq"));
        XposedHelpers.callMethod(analogMessage, "setRxType", 
            (byte) XposedHelpers.getIntField(channel, "rxType"));
        XposedHelpers.callMethod(analogMessage, "setRxSubCode", 
            (byte) XposedHelpers.getIntField(channel, "rxSubCode"));
        XposedHelpers.callMethod(analogMessage, "setTxType", 
            (byte) XposedHelpers.getIntField(channel, "txType"));
        XposedHelpers.callMethod(analogMessage, "setTxSubCode", 
            (byte) XposedHelpers.getIntField(channel, "txSubCode"));
        
        // Send to hardware
        XposedHelpers.callMethod(analogMessage, "send");
        XposedBridge.log(TAG + ": VFO settings sent to hardware via direct AnalogMessage");
        
    } catch (Exception e) {
        XposedBridge.log(TAG + ": Error sending VFO to hardware: " + e.getMessage());
    }
}
```

### 8. Conflict Resolution

**Issue**: VFO and other modes (APRS, MON, Soft SQ) should not run simultaneously

**Solution**: Mutual exclusion checks

#### A. On VFO Entry:
```java
// In startVFOMode():
if (isAPRSMonitoringActive) {
    Toast.makeText(activity, "Cannot use VFO while APRS is active", Toast.LENGTH_SHORT).show();
    vfoModeToggleButton.setChecked(false);
    return;
}

// Disable other modes
if (softwareSquelchToggleButton != null && softwareSquelchToggleButton.isChecked()) {
    softwareSquelchToggleButton.setChecked(false);
    isSoftwareSquelchEnabled = false;
}Add VFO state variables (including mode, squelch, DMR fields)
- [ ] Implement VFO dialog with frequency control
- [ ] Add mode toggle (Analog/Digital RadioGroup)
- [ ] Add channel backup/restore system (with DMR fields)
- [ ] Implement startVFOMode() and stopVFOMode()
- [ ] Add crash recovery on startup
- [ ] Implement mutual exclusion with APRS/MON
- [ ] Test basic frequency tuning (analog mode)
- [ ] Test channel restoration
- [ ] Test digital mode switching

#### Phase 2: Software Squelch (Critical)
- [ ] Add VFO software squelch state variables
- [ ] Integrate VFO squelch into PCM audio hook
- [ ] Add squelch SeekBar to VFO dialog (analog mode)
- [ ] Implement isAboveSquelchThreshold() for VFO
- [ ] Test squelch at various thresholds (0-9)
- [ ] Verify hardware squelch=0 when VFO analog active
- [ ] Add squelch status display in VFO dialog
- [ ] Test squelch state persistence across dialog reopens

#### Phase 3: Advanced Controls (Important)
- [ ] Add power level selection (both modes)
- [ ] Add RX/TX tone controls (analog mode)
- [ ] Add offset control (+/-) (both modes)
- [ ] Add bandwidth selection (12.5/25 kHz) (analog mode)
- [ ] Implement applyVFOChanges() for both modes
- [ ] Add frequency step buttons (±0.025 MHz)
- [ ] Add band switching (VHF/UHF)

#### Phase 4: DMR-Specific Controls (Important)
- [ ] Add Contact Type RadioGroup (Private/Group/All)
- [ ] Add TalkGroup ID EditText with validation
- [ ] Add Color Code control (0-15)
- [ ] Add Timeslot selection (Slot 1/2)
- [ ] Implement sendVFOChannelToHardware() for DMR
- [ ] Test DMR transmit/receive in VFO
- [ ] Add DMR status display in dialog
// Similar checks for MON and Soft SQ buttons
```

### 9. Utility Functions

#### A. Band Detection
```java
private int determineBand(double frequencyMHz) {
    // 0=UHF1 (400-480 MHz)
    // 1=VHF (136-174 MHz)
    // 2=UHF2/Business (somewhere in 400-520 range)
    
    if (frequencyMHz >= 136 && frequencyMHz <= 174) {
        return 1;  // VHF
    } else if (frequencyMHz >= 400 && frequencyMHz <= 520) {
        return 0;  // UHF
    } else {
        XposedBridge.log(TAG + ": Warning - frequency " + frequencyMHz + " MHz outside normal amateur bands");
        return 1;  // Default to VHF
    }
}
```analog → exit → verify restore
   - Start from digital channel → VFO analog → exit → verify restore
   - Start from analog channel → VFO digital → exit → verify restore
   - Start from digital channel → VFO digital → exit → verify restore

2. **Mode Switching**:
   - Enter VFO in analog mode → switch to digital → apply → verify DMR works
   - Enter VFO in digital mode → switch to analog → apply → verify FM works
   - Verify UI elements show/hide correctly when mode changes
   - Verify software squelch only active in analog mode

3. **Frequency Changes**:
   - Tune within VHF band (144-148 MHz) - analog
   - Tune within VHF band (144-148 MHz) - digital
   - Tune within UHF band (420-450 MHz) - analog
   - Tune within UHF band (420-450 MHz) - digital
   - Apply changes and verify hardware updates

4. **Software Squelch Testing** (Critical):
   - Set VFO squelch to 0 → verify all audio passes
   - Set VFO squelch to 9 → verify only strong signals pass
   - Set VFO squelch to 3 → verify moderate filtering
   - Monitor weak signal → adjust squelch → verify real-time gating
   - Verify hardware squelch stays at 0 during VFO analog
   - Verify squelch state persists when dialog reopens
   - Exit VFO → verify intercom squelch restored

5. **Crash Recovery**:
   - Enter VFO analog → force close app → restart → verify auto-restore
   - Enter VFO digital → force close app → restart → verify auto-restore
   - Verify squelch state restored correctly

6. **Conflict Resolution**:
   - Try VFO while APRS active → verify blocked
   - Try APRS while VFO active → verify blocked
   - Try MON while VFO active → verify toggle disabled
   - Try intercom Soft SQ while VFO active → verify disabled

7. **Analog Mode Testing**:
   - Adjust software squelch → verify audio gating
   - Set RX tone (CTCSS) → verify selective calling
   - Set TX tone (CTCSS) → verify repeater access
   - Set DCS tone → verify digital tone squelch
   - Test simplex (no offset)
   - Test repeater (+0.600 MHz offset)

8. **Digital Mode Testing**:
   - Set TalkGroup 9 (WW) → verify transmit/receive
   - Set TalkGroup 3100 (USA) → verify transmit/receive
   - Change Color Code → verify network access
   - Switch Slot 1/2 → verify timeslot operation
   - Test Private Call (Contact Type=0)
   - Test Group Call (Contact Type=1)
   - Test All Call (Contact Type=2)
    
    if (!isValidFrequency(txFreqMHz)) {
        XposedBridge.log(TAG + ": Warning - TX frequency " + txFreqMHz + " MHz is invalid!");
    }
    
    return (int) (txFreqMHz * 1000000);
}
```

### 10. Persistence (Optional Enhancement)

**Feature**: Save VFO presets to database

**Tables**:
```sql
CREATE TABLE vfo_presets (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL,
    frequency_mhz REAL NOT NULL,
    power INTEGER DEFAULT 1,
    squelch INTEGER DEFAULT 2,
    rx_tone_type INTEGER DEFAULT 0,
    rx_tone_code INTEGER DEFAULT 0,
    tx_tone_type INTEGER DEFAULT 0,
    tx_tone_code INTEGER DEFAULT 0,
    offset_mhz REAL DEFAULT 0.0,
    offset_direction TEXT DEFAULT 'none',
    nosupports both analog (FM/NFM) and digital (DMR) modes
- **Uses software squelch** in analog mode (hardware set to 0)
- Cannot run simultaneously with APRS mode or intercom Soft SQ
- Channel is automatically restored on exit
- Backup file: `/sdcard/vfo_channel_backup.dat`
- Software squelch threshold: 0 (most sensitive) to 9 (least sensitive)
- Digital mode includes TalkGroup, Color Code, and Timeslot controls
**Methods**:
- `saveVFOPreset(String name)` - Save current settings
- `loadVFOPreset(int id)` - Load preset into VFO
- `deleteVFOPreset(int id)` - Remove preset
- `listVFOPresets()` - Show preset picker dialog

### 11. UI Components Reference

**EditText IDs** (for dialog controls):
- `vfo_frequency_input` - Main frequency field
- `vfo_offset_input` - Offset amount
- `vfo_rx_tone_code` - RX tone code
- `vfo_tx_tone_code` - TX tone code

**Button IDs**:
- `vfo_freq_up` - Increase frequency
- `vfo_freq_down` - Decrease frequency
- `vfo_apply` - Apply changes
- `vfo_exit` - Exit VFO mode

**SeekBar IDs**:
- `vfo_squelch_seekbar` - Squelch control

**TextView IDs**:
- `vfo_status` - Status indicator
- `vfo_tx_freq` - TX frequency display
- `vfo_rx_freq` - RX frequency display
- `vfo_squelch_value` - Squelch value label

### 12. Implementation Checklist

#### Phase 1: Basic VFO (Essential) - ✅ COMPLETED
- [x] Add VFO button to interface page
- [x] Implement VFO dialog with frequency control (Basic version - full dialog in Phase 2)
- [x] Add channel backup/restore system
- [x] Implement startVFOMode() and stopVFOMode()
- [x] Add crash recovery on startup
- [x] Implement mutual exclusion with APRS/MON
- [x] Added software squelch support (VFO squelch integration to PCM hook)
- [ ] Test basic frequency tuning (pending build & deployment)
- [ ] Test channel restoration (pending build & deployment)

**Implementation Date**: 2026-03-13
**Status**: Code complete, ready for testing

#### Phase 2: Advanced Controls (Important)
- [ ] Add squelch control with live updates
- [ ] Add power level selection
- [ ] Add RX/TX tone controls
- [ ] Add offset control (+/-)
- [ ] Add bandwidth selection (12.5/25 kHz)
- [ ] Implement applyVFOChanges()
- [ ] Add frequency step buttons (±0.025 MHz)
- [ ] Add band switching (VHF/UHF)

#### Phase 3: Presets (Nice to Have)
- [ ] Create VFO presets database
- [ ] Add preset save dialog
- [ ] Add preset load dialog
- [ ] Add quick preset buttons in VFO dialog
- [ ] Add preset edit/delete functionality
- [ ] Add import/export presets

#### Phase 4: Enhancements (Optional)
- [ ] Add memory scanning (scan saved presets)
- [ ] Add frequency history (last 10 used)
- [ ] Add CTCSS/DCS encoder/decoder status
- [ ] Add TX confirmation dialog (safety feature)
- [ ] Add VFO A/B dual watch
- [ ] Add signal strength meter in VFO dialog

### 13. Testing Scenarios

1. **Basic VFO Entry/Exit**:
   - Start from analog channel → VFO → exit → verify restore
   - Start from digital channel → VFO → exit → verify restore

2. **Frequency Changes**:
   - Tune within VHF band (144-148 MHz)
   - Tune within UHF band (420-450 MHz)
   - Apply changes and verify hardware updates

3. **Crash Recovery**:
   - Enter VFO → force close app → restart → verify auto-restore

4. **Conflict Resolution**:
   - Try VFO while APRS active → verify blocked
   - Try APRS while VFO active → verify blocked
   - Try MON while VFO active → verify toggle disabled

5. **Squelch/Tone Testing**:
   - Adjust squelch in VFO → verify audio gating
   - Set RX tone → verify selective calling
   - Set TX tone → verify repeater access

### 14. Code Location Summary

**File**: `DMRModHooks/app/src/main/java/com/dmrmod/hooks/MainHook.java`

**Sections**:
- **State Variables**: Lines ~95-250 (add VFO vars after APRS)
- **Button Creation**: Lines ~2020-2100 (after APRS button)
- **VFO Methods**: Lines ~4700-5500 (new section)
- **Crash Recovery**: Lines ~680-690 (parallel to APRS check)
- **Conflict Checks**: Scattered in existing mode toggle handlers

**New Methods** (estimated ~800 lines):
1. `showVFODialog()` - 150 lines
2. `startVFOMode()` - 80 lines
3. `stopVFOMode()` - 40 lines
4. `applyVFOChanges()` - 60 lines
5. `saveVFOChannelBackup()` - 40 lines
6. `restoreVFOChannelBackup()` - 50 lines
7. `saveVFOChannelBackupToFile()` - 30 lines
8. `loadVFOChannelBackupFromFile()` - 30 lines
9. `deleteVFOChannelBackupFile()` - 10 lines
10. `checkAndRestoreVFOChannelOnStartup()` - 100 lines
11. `sendVFOChannelToHardware()` - 40 lines
12. `determineBand()` - 15 lines
13. `isValidFrequency()` - 10 lines
14. `calculateTxFrequencyWithOffset()` - 15 lines
15. Dialog UI helper methods - 130 lines

**Total New Code**: ~800-1000 lines

### 15. Documentation Updates

**Files to Update**:
- `README.md` - Add VFO feature section
- `CHANGELOG.md` - Add v3.2.0 VFO release notes
- `USER_GUIDE.md` - Add VFO usage instructions
- `XDA_ANNOUNCEMENT.md` - Add VFO to feature list

**Example README Section**:
```markdown
## 📻 VFO Mode (v3.2.0)

### Temporary Frequency Tuning Without Saving Channels

**Usage**:
1. Tap VFO button (below TXT on intercom page)
2. Adjust frequency, power, squelch, and tones
3. Tap "Apply Changes" to update
4. Tap "Exit VFO Mode" to restore original channel

**Features**:
- Quick frequency tuning (±0.025 MHz steps)
- Repeater offset support (+/- up to ±10 MHz)
- CTCSS/DCS tone encoding (RX/TX separate)
- Power control (Low/High)
- Squelch adjustment (0-9)
- Crash recovery (auto-restore on app crash)
- Quick presets for common frequencies

**Notes**:
- VFO is analog-only (FM/NFM)
- Cannot run simultaneously with APRS mode
- Channel is automatically restored on exit
- Backup file: `/sdcard/vfo_channel_backup.dat`
```

---

## Summary

The VFO feature follows the same proven architecture as APRS monitoring:
1. **Button** on interface page (below TXT)
2. **Dialog** with comprehensive controls
3. **Channel hijacking** (temporary modification)
4. **Backup/restore** system (memory + file)
5. **Crash recovery** on app restart
6. **Mutual exclusion** with other modes
7. **Direct hardware control** via AnalogMessage.send()

**Estimated Implementation Time**: 8-12 hours for Phase 1+2
**Complexity**: Medium (follows existing patterns)
**Risk**: Low (well-tested architecture)

**Priority**: High - VFO is a fundamental feature for amateur radio operators
