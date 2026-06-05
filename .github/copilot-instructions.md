# DMRModHooks - Copilot Instructions

## Project Overview

**DMRModHooks** is an LSPosed/Xposed module for the PriInterPhone DMR radio Android app. It provides comprehensive runtime modifications without altering the original APK, preserving the platform signature required for hardware access.

**Current Version**: v3.3.7 (March 2026)
**Target App**: `com.pri.prizeinterphone` (PriInterPhone DMR Radio)
**Device**: Ulefone Armor 26 Ultra (Android 13)
**Framework**: LSPosed/Xposed (requires LSPosed v1.9.2+ Zygisk variant, Magisk v24+)
**Language**: Java (Android)

> **Read this first if you are starting a new session:** [`.docs/AI_LOGS_SUMMARY.md`](../.docs/AI_LOGS_SUMMARY.md) is a comprehensive accounting of everything that was shipped, attempted-and-failed, and deliberately removed across the full chat history. Consult it before re-investigating anything that looks like a known dead-end (especially APRS TX, LED control, DMR group-call RX, and >32-TG software filtering).

## 🤖 AI agents — device deploy (mandatory)

**Whenever you build and push/install a new `DMRModHooks` APK to the connected device** (`adb install`, `adb install -r`, or `install.ps1`), you **must reboot the device automatically** after a **successful** install — do not leave reboot as an optional user step.

```powershell
# Preferred: build + install + reboot (install.ps1 reboots on success)
cd DMRModHooks
.\install.ps1

# Manual equivalent (from DMRModHooks/):
.\gradlew assembleDebug
adb install -r -t app\build\outputs\apk\debug\app-debug.apk
adb reboot
```

**Also reboot** when installing a release APK from `releases\` for on-device validation:

```powershell
adb install -r releases\DMRModHooks-v3.4.0.apk
adb reboot
```

**Why:** LSPosed/Zygisk loads hook bytecode at boot. Without reboot, Java/Xposed changes often do not apply even though `adb install` succeeded.

**Rules:**
- Run `adb reboot` yourself — do not only tell the user to reboot.
- If multiple APKs are installed in one session (e.g. DMRModHooks + DMRTranscriptionService), finish installs then **one** `adb reboot`.
- If `adb reboot` fails (no device, unauthorized), report the failure; do not claim deploy is complete.
- `DMRTranscriptionService` alone may work without reboot; **DMRModHooks always requires reboot** after update.

Same rule is documented in [`.docs/AI_LOGS_SUMMARY.md`](../.docs/AI_LOGS_SUMMARY.md) §3.1 and [`.docs/PROJECT_AND_DOC_AUDIT_FOR_REVIEW.md`](../.docs/PROJECT_AND_DOC_AUDIT_FOR_REVIEW.md) (device workflow).

## ⚠️ Trust, but Verify — These Instructions Can Be Wrong

This file is hand-maintained and ~1500 lines long. It drifts. **Always verify against the code before relying on a specific claim** — especially:

- **Database column names** (§5a) — grep `getColumnIndex("channel_…")` and `values.put("channel_…")` in `DirectDatabaseExporter.java` / `DirectDatabaseImporter.java` for the OEM channel table. The two naming schemes (SQL `channel_xxx` vs Java field `xxx`) are easy to confuse.
- **`ChannelData` field names** — grep `XposedHelpers.getIntField(channelData, "…")` / `getObjectField(channelData, "…")` in `MainHook.java`. If a field doesn't appear in a real call site, assume it doesn't exist on the class.
- **OEM class paths** (`com.pri.prizeinterphone.*`) — verify in `decompiled/` or by searching `XposedHelpers.findClass(...)` calls. Subpackages like `serial.data` vs `data` matter.
- **Hook method signatures** — confirm against actual `findAndHookMethod(...)` invocations; parameter types must match exactly.
- **Serial command IDs / packet layouts** — check `cmd_handler.c`, `Packet`/`SerialPort` decompiled sources, and `MessageDispatcher` routing.
- **Schema diagrams, CSV column lists, hard-coded line numbers** — these decay fastest. Read the file before quoting it.

**Rule:** if the instructions and the code disagree, **the code is right and the instructions are stale — fix the instructions**. Don't paper over a contradiction by writing new code that matches the docs.

When you discover a doc error, patch this file in the same change. Note known-stale areas inline with `<!-- STALE: verify -->` if you can't fix them immediately.

## Hard Constraints — Do Not Re-Investigate

These were thoroughly tested and proven impossible on this hardware. Don't waste cycles retrying them — see [`.docs/AI_LOGS_SUMMARY.md`](../.docs/AI_LOGS_SUMMARY.md) §4 for evidence.

| Limitation | Reality |
|---|---|
| **APRS TX over analog FM** | Voice-optimized DSP destroys AFSK on the RF path (96 % → 27 % AFSK energy). 6 methods tested, 0 worked. `AFSKGenerator.java` is kept only as reference. Requires external TNC or different radio. |
| **Hardware LED control** | No GPIO/sysfs/serial command exists in the app or the 0x22–0x3C command range. Controlled solely by radio MCU firmware. |
| **DMR group-call RX** | Firmware ignores the RX group list — only receives calls to the radio's own DMR ID. Not fixable in software. (TX All-Call now works post-VFO-session fix.) |
| **>32 TG IDs per channel (hardware)** | `ChannelData.groups` is `int[32]`. Cannot expand. Software-side filtering for overflow TGs is blocked because the `DigitalAudioMessage` body layout doesn't expose the destination TG offset. |
| **Squelch levels 1, 3–9** | Firmware coerces every non-zero squelch value to `2`. Only `sq=0` (open) and `sq=2` (tight) are distinct hardware states. This is why we run software squelch on top of `sq=0`. |
| **On-device Whisper TFLite** | Researched, not shipped. The cloud Whisper API path is what works. |

## Core Architecture

### LSPosed/Xposed Hook Pattern
- **Entry Point**: `MainHook.java` implements `IXposedHookLoadPackage`
- **Hook Registration**: All hooks registered in `handleLoadPackage()` method
- **Reflection-Based**: Uses `XposedHelpers` to find and hook classes/methods at runtime
- **Non-Destructive**: Original app code runs alongside our modifications

### Key Architectural Principles
1. **Preserve Platform Signature**: Never modify the original APK - use runtime hooks only
2. **Fail-Safe Hooks**: All hooks wrapped in try-catch to prevent app crashes
3. **Thread Safety**: Use `volatile` for shared state, `Handler(Looper.getMainLooper())` for UI updates
4. **State Management**: Centralized static variables for cross-hook communication
5. **Database Access**: Direct SQLite access to app's databases for data persistence

## Project Structure

All Java classes live flat in a single package `com.dmrmod.hooks` (not in subpackages — `databases/`, `aprs/`, `sstv/`, `noaa/`, `views/` referenced in older docs do NOT exist).

### Top-Level Repository Layout

```
phonedmrapp/                             # Repo root
├── DMRModHooks/                         # ⭐ LSPosed module (this project)
├── app/                                 # Decompiled OEM source (com.pri.prizeinterphone)
├── decompiled/                          # APK decompile output (smali removed, Java kept)
├── original-decompiled/                 # Original unmodified APK decompile
├── original-extracted/                  # APK raw extracted assets
├── original_assets/                     # Assets from original APK
├── ghidra_decompiled/                   # Ghidra decompile output (also in radio_firmware/)
├── radio_firmware/                      # Firmware binaries + C source + Ghidra artifacts
│   ├── DMR003.UV4T.V022-ORIGINAL.bin    # Stock firmware
│   ├── DMR003.UV4T.V022-PATCH14.bin     # Patched firmware (last attempt)
│   ├── cmd_handler.c                    # Decompiled serial command handler
│   ├── firmware_decompiled.c            # Ghidra full decompile
│   ├── firmware_all_functions.c         # All functions extracted
│   ├── firmware_disasm_output.txt       # ARM disassembly
│   ├── ghidra_scripts/                  # Ghidra analysis scripts
│   └── ghidra_decompiled/               # Ghidra output mirror
├── OpenGD77Fork/                        # Fork of OpenGD77 CPS (compiled binary + source)
├── releases/                            # Release APKs and notes
├── docs/                                # All research/design markdown (~84 files)
├── scripts/                             # Python/PowerShell/shell analysis & test scripts (~107 files)
├── DMRTranscriptionService/             # Android transcription service (separate module)
├── README.md
├── build.gradle                         # Project-level (includes :app decompiled module)
└── settings.gradle
```

### DMRModHooks Module Structure

```
DMRModHooks/
├── app/
│   ├── src/main/java/com/dmrmod/hooks/
│   │   ├── MainHook.java                # Entry point — implements IXposedHookLoadPackage (~16,000 lines)
│   │   │
│   │   ├── # APRS RX (TX is reference-only, see Hard Constraints)
│   │   ├── AFSKDecoder.java             # Original Goertzel attempt (abandoned)
│   │   ├── AFSKDecoderIQ.java           # ⭐ Production IQ + FIR decoder (Dire Wolf style)
│   │   ├── AFSKDecoderPLL.java          # PLL clock recovery (TICKS_PER_PLL_CYCLE = 0x100000000L)
│   │   ├── AFSKGenerator.java           # Reference only — does NOT transmit successfully
│   │   ├── APRSPacketDecoder.java       # AX.25 framing, bit-unstuffing, CRC-16-CCITT, longest-gap algo
│   │   ├── APRSReceiver.java
│   │   ├── APRSDatabase.java            # APRS settings/SharedPreferences
│   │   ├── APRSReceivedDatabase.java    # Received-packet log
│   │   ├── LocationDatabase.java        # GPS positions per packet
│   │   ├── DireWolfDecoder.java
│   │   │
│   │   ├── # SSTV (RX only)
│   │   ├── SSTVMode.java                # VIS code database (Robot/Martin/Scottie/PD)
│   │   ├── SSTVVISDetector.java         # Goertzel VIS detection
│   │   ├── SSTVAutoDetector.java        # Sync-based fallback
│   │   ├── SSTVReceiver.java            # 3 MB circular buffer, state machine
│   │   ├── SSTVImageDecoder.java
│   │   ├── SSTVImageDecoderIQ.java      # ⭐ Production IQ decoder
│   │   ├── SSTVFMDemodRobot36.java
│   │   ├── SSTVFilter.java
│   │   ├── SSTVFFTDemodulator.java, SSTVGoertzelDemod.java,
│   │   ├── SSTVZeroCrossingDemod.java, SSTVPhaseDemod.java,  # alt demods, kept for experimentation
│   │   ├── SSTVVISResult.java
│   │   │
│   │   ├── # NOAA APT
│   │   ├── NOAAReceiver.java
│   │   ├── SatellitePassPredictor.java  # TLE-based pass prediction
│   │   ├── FrequencyModulation.java
│   │   │
│   │   ├── # Audio DSP helpers
│   │   ├── Complex.java, Phasor.java, Kaiser.java, ComplexConvolution.java, ToneConverter.java
│   │   │
│   │   ├── # Codeplug / database
│   │   ├── CSVExporter.java, CSVImporter.java       # legacy paths
│   │   ├── DirectDatabaseExporter.java              # ⭐ OpenGD77 37-col export
│   │   ├── DirectDatabaseImporter.java              # ⭐ OpenGD77 import (handles 36 & 37 col)
│   │   ├── PDFExporter.java
│   │   ├── BackupActivity.java                      # Backup management UI w/ trash icons
│   │   ├── ZoneDatabase.java                        # zones + channel_zone_assignments
│   │   ├── TGListDatabase.java                      # tg_lists + channel_tglist_assignments
│   │   │
│   │   ├── # UI
│   │   ├── CircuitBoardView.java        # Sci-fi sound-bar / PCB trace background
│   │   │
│   │   └── # Tooling
│   │       ├── DiagnosticDatabaseDump.java
│   │       ├── PatchReloadHelper.java
│   │       └── UARTBootloaderProbe.java
│   │
│   ├── src/main/res/                    # layouts, drawables (custom PTT sprites, channel numbers)
│   └── build.gradle                     # App build config — debug & release MUST share release.keystore
└── build.gradle                         # Project-level
```

## Critical State Variables

### Software Squelch State
```java
private static volatile boolean isSoftwareSquelchEnabled = false;
private static volatile int softwareSquelchThreshold = 2;  // 0-9
private static volatile boolean isSquelchOpen = false;
private static volatile boolean previousSquelchOpen = false;
private static volatile long lastSquelchOpenTime = 0;
private static final long SQUELCH_HANG_TIME_MS = 300;
private static final int HYSTERESIS_FACTOR = 140;  // ~3dB hysteresis
```

### Mode Flags (Mutually Exclusive)
```java
private static volatile boolean isAPRSMonitoringActive = false;
private static volatile boolean isSSTVMonitoringActive = false;
private static volatile boolean isNOAAMonitoringActive = false;
private static volatile boolean isVFOModeActive = false;
```

### Audio State
```java
private static volatile boolean isReceiving = false;
private static volatile int currentRssi = -999;  // dBm, -999 = no signal
private static CircuitBoardView circuitBoardView = null;  // Sound bar display
```

### APRS / Squelch UI State (added 3/13 session)
```java
private static volatile boolean isAprsSoftwareSquelchEnabled = false;  // APRS page toggle — independent from intercom
private static volatile int savedIntercomSquelchThreshold = 2;          // Saved before APRS mode overwrites it
private static android.widget.ToggleButton softwareSquelchToggleButton = null;  // Intercom page soft SQ button (static ref)
private static android.widget.ToggleButton aprsToggleButton = null;            // APRS page toggle button (static ref)
private static android.view.View softwareSquelchContainer = null;              // Slider container — show/hide on channel type change
```

### Caller / Recording / Zone / VFO State (selected highlights — see MainHook.java top for full list)
```java
// DMR caller identification (digital channels)
private static volatile int currentCallerDmrId = 0;
private static volatile String currentCallerName = null;

// Recording (WAV → transcription pipeline)
private static volatile boolean isCurrentlyRecording = false;
private static volatile String currentRecordingPath = null;
private static volatile long pcmDataSize = 0;

// Zone navigation
private static volatile long currentZoneId = -1;       // -1 = All Channels
private static volatile String currentZoneName = "All";
private static volatile List<Integer> currentZoneChannels = null;

// MON button (analog monitor)
private static volatile boolean isMonitoringMode = false;

// VFO mode parameters
private static volatile double vfoFrequencyMHz = 146.520;  // simplex default
private static volatile int vfoLocalId = -1;               // -1 = use channel default (see Pitfall 15)
private static volatile int vfoBandWidth = 0;              // 0 = 12.5 kHz, 1 = 25 kHz

// App ClassLoader cached at hookApplication time for async callbacks
private static ClassLoader appClassLoader = null;
```

### Mode-Specific Default Frequencies (hardcoded in MainHook.java)
| Mode | Default MHz | Notes |
|---|---|---|
| APRS | 144.390 | North-American 2 m APRS frequency |
| SSTV | 144.500 | 2 m SSTV calling; persisted in `dmrmod_sstv_global` |
| NOAA | 137.100 | NOAA-19; persisted in `dmrmod_noaa_global` |
| VFO  | 146.520 | 2 m simplex calling; in-memory only (`vfoFrequencyMHz`) |

## Key Hook Methods

### UI Modification Hooks
- `hookApplication()` - `Application.onCreate()` — grabs the app `ClassLoader` and runs early init
- `hookMainActivity()` - Main app initialization, status bar colors
- `hookTalkBackFragment()` - Intercom page (main screen with PTT)
- `hookLocalFragment()` - Device/Settings tab
- `hookChannelEditActivity()` - Channel editor (adds Zone + TG-List rows)
- `hookInformationActivity()` - Settings → Information / About page styling
- `hookMessageDisplay()` - DMR SMS list rendering (GPS coordinate hyperlinking lives here)
- `hookBottomNavBar()` - Bottom navigation theming (**Note:** bottom nav is a **custom XML `LinearLayout`** of 5 tab children — NOT a `BottomNavigationView`. OEM tab-switch handler is `tapOnClick(View)`.)
- `hookOtherFragmentBackgrounds()` - Channel/Contacts/Message/Device pages (**Note:** use `mLocalView` to find views inside fragment content — field `mFragmentView` does NOT exist.)
- `hookGenericActivityBackgrounds()` - Sub-activities (Settings, DeviceArea, etc.)

### Audio Processing Hooks
- `hookPCMReceiveManager()` - **CRITICAL** - Audio pipeline hook
  - Intercepts all PCM audio before speaker
  - Implements software squelch
  - Feeds APRS/SSTV/NOAA decoders
  - Handles recording and transcription
  - Updates sound bar animations
- `hookDigitalAudioHandler()` - DMR voice-packet RX path; extracts caller DMR ID from `DigitalAudioMessage` body bytes
- `hookSpeechRecognizer()` / `hookSystemRecognitionService()` - Android system speech-recognition integration (legacy / research; cloud Whisper is the shipped path)
  
### Hardware Control Hooks
- `hookDmrManager()` - Channel management, hardware commands. **Also where the VFO `localId` override lives** (see Pitfall 15)
- `hookModuleStatusHandler()` - Radio state (RX/TX/idle)
- `hookSignalMessageHandler()` - RSSI updates (cmd 0x32 responses) — source of `currentRssi` for software squelch
- `hookSerialCommunication()` - Low-level hardware comms (UART logging on `/dev/ttyS0`)
- `hookChannelNavigation()` - Channel up/down buttons with zone filtering

### Data Management Hooks
- `hookChannelListFilter()` - Filter channels by zone
- `hookChannelListUI()` - Add zone badge to channel list items
- `hookUpdateFirmwareActivity()` - Firmware-update activity instrumentation (currently disabled, kept for future)

### Critical Helper Methods (non-hook, called by hooks and UI)

| Method | Purpose |
|---|---|
| `saveChannelBackup(Object)` / `restoreChannelBackup(Context)` | APRS mode channel hijack → `/sdcard/aprs_channel_backup.dat` |
| `saveSSTVChannelBackup(Object)` / `restoreSSTVChannelBackup(Context)` | SSTV mode hijack → `/sdcard/sstv_channel_backup.dat` |
| `saveNOAAChannelBackup(Object)` / `restoreNOAAChannelBackup(Context)` | NOAA mode hijack → `/sdcard/noaa_channel_backup.dat` |
| `saveVFOChannelBackup(Object)` / `restoreVFOChannelBackup(Context)` | VFO mode hijack → `/sdcard/vfo_channel_backup.dat` |
| `startAPRSMonitoring(Activity)` / `stopAPRSMonitoring(Activity)` | APRS lifecycle (overwrites `softwareSquelchThreshold` — see Pitfall 10) |
| `startSSTVMonitoring(Activity)` / `stopSSTVMonitoring(Activity)` | SSTV lifecycle |
| `enableSoftwareSquelchOnCurrentChannel()` / `disableSoftwareSquelchOnCurrentChannel()` | Issues direct `AnalogMessage.send()` with `sq=0` / `sq=2` (bypasses state machine — see Pitfall 8) |
| `syncChannelInfoWithData(Object)` | Refresh UI after backup restore — NOT the right path for hardware writes |
| `getContactNameForDmrId(long, Context)` | Looks up `contact_database.contact_name WHERE contact_number = ?` |
| `applyBottomNavStyle(Activity, String tabName)` | Re-paints all 5 bottom-nav tabs after `tapOnClick` |
| `updateActivityIndicator(String)` | Appends to scrolling activity history + writes row to `dmrmod_history.db` |
| `updateCallerInfoAsync(ClassLoader)` | Background thread: looks up contact name for current caller |
| `updateAPRSLiveScreen(...)` / `updateSSTVLiveScreen(...)` / `updateNOAALiveScreen()` | 2-second dialog refresh tickers |

### Frequently-Hooked OEM Class Paths (`com.pri.prizeinterphone.*`)

| Subpackage | Class | Used for |
|---|---|---|
| `ui.activity` | `MainActivity` | Status bar / theme |
| `ui.fragment` | `TalkBackFragment` | Intercom page — the main hook surface |
| `ui.fragment` | `LocalFragment` | Device/Settings tab |
| `handler` | `ModuleStatusHandler` | Radio RX/TX/idle transitions |
| `handler` | `DigitalAudioHandler` | DMR voice-packet RX (caller ID extraction) |
| `handler` | `SignalMessageHandler` | RSSI updates |
| `manager` | `PCMReceiveManager` | **Audio pipeline** (`writeAudioTrack`) |
| `manager` | `DmrManager` | Channel programming + `sendDigitalMessage`/`sendAnalogMessage` |
| `serial.data` | `ChannelData` | Per-channel config struct (note: subpackage is `serial.data`, NOT plain `data` — see Pitfall 1) |
| `serial` | `SerialManager` | UART traffic |
| `serial.communication` | `Packet`, `SerialPort` | Raw byte framing |
| `message` | `AnalogMessage`, `DigitalMessage`, `SignalMessage`, `RelayMessage` | Per-command packet builders — instantiate + `.send()` for direct hardware writes |
| `protocol` | `MessageDispatcher` | Incoming-packet routing |

## Critical Patterns & Best Practices

### 1. Software Squelch Architecture

**Problem**: Hardware squelch is forced to `sq=2` by firmware; cannot be set to 0 (fully open).

**Solution**: Hybrid software squelch using RSSI + Audio RMS.

**Implementation Pattern**:
```java
// Hook sendAnalogMessage to force sq=0 BEFORE hardware send
XposedHelpers.findAndHookMethod(
    dmrManagerClass,
    "sendAnalogMessage",
    channelDataClass,
    new XC_MethodHook() {
        @Override
        protected void beforeHookedMethod(MethodHookParam param) {
            if (!isSoftwareSquelchEnabled) return;
            
            Object channelData = param.args[0];
            XposedHelpers.setIntField(channelData, "sq", 0);  // Force open
            
            // Schedule state reset after channel loads
            new Handler(Looper.getMainLooper()).postDelayed(() -> {
                // Reset squelch state machine
                isSquelchOpen = false;
                previousSquelchOpen = false;
                lastSquelchOpenTime = 0;
                currentRssi = -999;
                enableSoftwareSquelchOnCurrentChannel();
            }, 300);
        }
    }
);
```

**Key Points**:
- **Always** intercept at `sendAnalogMessage()`, not after state machine runs
- Reset squelch state on **every channel change** to prevent stale values
- Use delayed re-enable (300ms) to ensure channel is fully loaded
- Software squelch runs in `hookPCMReceiveManager.beforeHookedMethod()`

### 2. Audio Pipeline Hook Pattern

**Location**: `hookPCMReceiveManager()` → `writeAudioTrack(byte[], int)` → `beforeHookedMethod`

**Execution Order**:
1. Calculate audio amplitude (always, for VU meter)
2. Make copy of audio data for decoders (APRS/SSTV/NOAA/transcription)
3. Run software squelch logic
4. Mute audio buffer if squelch closed: `Arrays.fill(audioData, 0, length, (byte) 0)`
5. Update `circuitBoardView.audioAmplitude` (0 if squelched)
6. Feed decoders with **original** (pre-squelch) audio
7. Let original `writeAudioTrack` proceed

**Critical Rule**: Decoders MUST receive pre-squelch audio, speaker gets post-squelch audio.

### 3. Channel Change State Management

**Problem**: Channel changes reprogram hardware, overwriting software squelch settings.

**Solution**: Hook `sendAnalogMessage` (called during ALL channel programming).

**Pattern**:
```java
// Intercept analog message BEFORE it's sent to hardware
protected void beforeHookedMethod(MethodHookParam param) {
    Object channelData = param.args[0];
    
    // Read original, force to 0, log change
    int originalSq = XposedHelpers.getIntField(channelData, "sq");
    XposedHelpers.setIntField(channelData, "sq", 0);
    XposedBridge.log("Forcing sq=" + originalSq + " → sq=0");
    
    // Schedule state reset + re-enable after channel loads
    postDelayed(() -> {
        resetSquelchState();
        enableSoftwareSquelchOnCurrentChannel();
    }, 300);
}
```

**Why This Works**:
- Catches ALL paths: button nav, list tap, zone switch, startup
- Modifies ChannelData object BEFORE hardware read
- No race conditions with state machine timing
- Re-enable ensures hardware stays at sq=0

### 4. UI Thread Safety

**Rules**:
1. UI updates MUST run on main thread: `activity.runOnUiThread(() -> { })`
2. Delayed actions: `new Handler(Looper.getMainLooper()).postDelayed(() -> { }, delayMs)`
3. Never block UI thread (no network, heavy computation, file I/O)
4. Background work: `new Thread(() -> { }).start()`

**Example**:
```java
// ✅ CORRECT
activity.runOnUiThread(() -> {
    textView.setText("Updated");
    button.setEnabled(true);
});

// ❌ WRONG
textView.setText("Updated");  // May crash if called from background thread
```

### 5. Database Access Pattern

**Direct SQLite Access**:
```java
// Get writable database
android.database.sqlite.SQLiteDatabase db = 
    android.database.sqlite.SQLiteDatabase.openDatabase(
        "/data/data/com.pri.prizeinterphone/databases/channel_db.db",
        null,
        android.database.sqlite.SQLiteDatabase.OPEN_READWRITE
    );

// Use transactions for multi-row operations
db.beginTransaction();
try {
    // ... database operations ...
    db.setTransactionSuccessful();
} finally {
    db.endTransaction();
}
db.close();
```

**Key Points**:
- Always close database connections
- Use transactions for data integrity
- Handle exceptions gracefully
- Query via `rawQuery()` or `query()`, update via `execSQL()`

### 5a. Database Schema Reference

**App databases** — owned by `com.pri.prizeinterphone`, located at `/data/data/com.pri.prizeinterphone/databases/`, opened via `context.getDatabasePath("<filename>")`.

**Two distinct naming schemes** — be careful not to mix them up:

| Context | Prefix | Example | Used by |
|---|---|---|---|
| **SQLite column names** on the channel table | `channel_` | `channel_rxFreq`, `channel_sq` | `cursor.getColumnIndex(...)`, `ContentValues.put(...)` |
| **Java field names** on the in-memory `ChannelData` object | none | `rxFreq`, `sq` | `XposedHelpers.getIntField(channelData, ...)` |

So `cursor.getInt(cursor.getColumnIndex("channel_sq"))` and `XposedHelpers.getIntField(channelData, "sq")` reach the same value through different APIs.

#### `database_channel_area_default_uhf.db` — main channel store
Table name = `database_channel_area_default_uhf`. Columns confirmed by the actual import/export code (DirectDatabaseExporter/Importer, MainHook field accesses):

| Column | `ChannelData` field | Type | Notes |
|---|---|---|---|
| `_id` | — | INTEGER PK | Autoincrement. Used as the stable zone/TG-list key — **not** `channel_number` |
| `channel_number` | `number` | INTEGER | Display order number. Non-unique (multiple channels can share same number) |
| `channel_name` | `name` | TEXT | Display name |
| `channel_type` | `type` | TEXT/INT | `"0"` = Digital/DMR, `"1"` = Analog/FM. Stored as text in DB but read as int from `ChannelData.type` |
| `channel_rxFreq` | `rxFreq` | INTEGER | Hz (e.g. 462562500) |
| `channel_txFreq` | `txFreq` | INTEGER | Hz |
| `channel_band` | `band` | INTEGER | 0=UHF, 1=VHF (derived from frequency) |
| `channel_sq` | `sq` | INTEGER | Squelch 0–9 (firmware coerces 1,3–9 → 2; only 0 and 2 are distinct) |
| `channel_power` | `power` | INTEGER | 0=low (P1), 1=high (P9). OpenGD77 expects `P1`–`P9` strings |
| `channel_cc` | `cc` | INTEGER | Color code (DMR only, 0–15). **Field name is `cc`, NOT `colorCode`** (this bit VFO in v3.1.5) |
| `channel_inBoundSlot` | `inBoundSlot` | INTEGER | Timeslot **0-based** (0=TS1, 1=TS2). OpenGD77 is 1-based — convert on import/export |
| `channel_outBoundSlot` | `outBoundSlot` | INTEGER | Outbound timeslot, same 0-based convention |
| `channel_txContact` | `txContact` | INTEGER | **DMR ID (= `contact_number` from contact table), NOT contact row `_id`** — see Pitfall 12 |
| `channel_contactType` | `contactType` | INTEGER | 0=Private, 1=Group, 2=All-Call |
| `channel_rxType` | `rxType` | INTEGER | RX tone type: 0=None, 1=CTCSS, 2=FDCS, 3=BDCS. **Column is `channel_rxType`, NOT `channel_rxToneType`** |
| `channel_rxSubCode` | `rxSubCode` | INTEGER | Index into tone table for the chosen `rxType` |
| `channel_txType` | `txType` | INTEGER | TX tone type, same encoding as `rxType`. **Column is `channel_txType`, NOT `channel_txToneType`** |
| `channel_txSubCode` | `txSubCode` | INTEGER | Index into tone table for the chosen `txType` |
| `channel_encryptSw` | `encryptSw` | INTEGER | 0=off, 1=on. **Column is `channel_encryptSw`, NOT `channel_encryptSwitch`** |
| `channel_encryptKey` | `encryptKey` | TEXT | Hex key string |
| `channel_relay` | `relay` | INTEGER | 1=relay-disconnect ON, 2=normal. **Never 0** — firmware rejects 0; importer coerces 0→2. (OpenGD77 CPS uses 0=normal/1=disconnect internally — different convention!) |
| `channel_interrupt` | `interrupt` | INTEGER | Must be `2` for Digital, `0` for Analog — importer/exporter enforce this |
| `channel_active` | `active` | INTEGER | Only one channel may be active at a time (`_id=1` is the boot channel by convention) |
| `channel_mode` | `mode` | INTEGER | Per-channel mode flag (uses vary; importer defaults to `0`) |
| `channel_groups` | `groups` | TEXT | Comma-separated TG IDs, **exactly 32 slots** (e.g. `"1,0,0,...,0"`). Written by `TGListDatabase.getHardwareGroups()` at channel-save time so firmware reads the right TGs without runtime hooks (v3.3.6 architecture change) |

**Columns that do NOT exist on this table** (despite appearing in CSV exports or in older docs):
- `channel_aprs` — APRS enable flag lives in **our own** `dmrmod_aprs.db` → `channel_aprs` table (keyed by `channel_number`)
- `channel_latitude` / `channel_longitude` / `channel_useLocation` — GPS data lives in **our own** `dmrmod_locations.db` → `channel_locations` table
- `channel_rxOnly`, `channel_zoneSkip`, `channel_allSkip`, `channel_tot`, `channel_vox`, `channel_noBeep`, `channel_noEco` — CSV-only fields; the OpenGD77 exporter always emits `"No"` / `"Off"` / `"0"` for these because we have no DB source to read from
- `channel_localId` — `localId` is the device's own DMR ID and lives on `DmrManager`, not on `ChannelData`. See Pitfall 15.

#### `contact_database.db` — contacts
Table name = `contact_database`

| Column | Type | Notes |
|---|---|---|
| `_id` | INTEGER PK | Row ID — **NOT** what `channel_txContact` stores |
| `contact_name` | VARCHAR | Display name |
| `contact_type` | INTEGER | 0=Private, 1=Group, 2=AllCall |
| `contact_number` | VARCHAR | 24-bit DMR ID — **this is what `channel_txContact` stores** |
| `contact_active` | INTEGER | |
| `contact_icon` | VARCHAR | |

---

**Module's own databases** — stored in `com.dmrmod.hooks` data dir via `context.getDatabasePath()`:

| DB file | Table(s) | Key columns |
|---|---|---|
| `dmrmod_zones.db` | `zones` | `id` PK, `name` TEXT, `channel_list` TEXT (comma-sep channel `_id` values) |
| `dmrmod_tglists.db` | `tg_lists` | `id` PK, `name` TEXT UNIQUE, `tg_ids` TEXT (comma-sep DMR IDs), `description` TEXT |
| `dmrmod_tglists.db` | `channel_tglist_assignments` | `channel_id` PK (= channel `_id`), `tg_list_id` INT |
| `dmrmod_aprs.db` | `channel_aprs` | `channel_number` PK, `enabled` INT, `comment` TEXT, `symbol_table` TEXT, `symbol_code` TEXT |
| `dmrmod_aprs_received.db` | `received_stations` | `id` PK, `callsign`, `ssid`, `latitude`, `longitude`, `altitude`, `comment`, `symbol_table`, `symbol_code`, `timestamp`, `channel_number` |
| `dmrmod_locations.db` | `channel_locations` | `channel_number` PK, `latitude` REAL, `longitude` REAL, `elevation` REAL |
| `dmrmod_history.db` | `channel_history` | `id` PK, `channel_number`, `dmr_id` TEXT, `timestamp` TEXT, `activity_type`, `rssi_dbm`, `transcription`, `created_at` |

**Global APRS settings** are stored in SharedPreferences `dmrmod_aprs_global` (not SQLite):
`callsign`, `ssid`, `default_symbol_table`, `default_symbol_code`, `aprs_frequency`, `aprs_squelch`

**Other module SharedPreferences:**

| Prefs name | Keys | Default value | Purpose |
|---|---|---|---|
| `dmrmod_sstv_global` | `sstv_frequency` | `"144.500"` | SSTV monitoring frequency (MHz, string) |
| `dmrmod_noaa_global` | `noaa_frequency` | `"137.100"` | NOAA APT monitoring frequency (MHz, string) |
| `dmrmod_gps_prefs` | `gps_send_no_confirm` | `false` | Skip GPS-send confirmation dialog |

**Mode-hijack backup files** (serialised `HashMap<String,Object>` for crash recovery):

| File | Mode | Notes |
|---|---|---|
| `/sdcard/aprs_channel_backup.dat` | APRS | Loaded by `restoreChannelBackup()` on startup if mode flag was left stale |
| `/sdcard/sstv_channel_backup.dat` | SSTV | Loaded by `restoreSSTVChannelBackup()` |
| `/sdcard/noaa_channel_backup.dat` | NOAA | Loaded by `restoreNOAAChannelBackup()` |
| `/sdcard/vfo_channel_backup.dat` | VFO | Loaded by `restoreVFOChannelBackup()` |

**On-disk artifact folders** (under `/sdcard/Download/`):

| Folder | Contents |
|---|---|
| `DMR_Backups/YYYYMMDD_HHmmss/` | Codeplug CSV exports (Channels, Contacts, TG_Lists, Zones, DTMF) |
| `DMR/Recordings/[ChannelName]/` | PCM→WAV recordings |
| `DMR/Transcription/[ChannelName]/transcription_YYYYMMDD.txt` | Daily transcription logs |
| `DMR/APRS/` | Received APRS packet logs (TXT + GPX) |
| `DMR/SSTV/` | Received SSTV images |
| `DMR/NOAA/` | NOAA APT satellite images |
| `/sdcard/DMR/api_key.txt` | OpenAI Whisper API key (auto-created on first run) |

### 6. Color Scheme & Theming

**Current Theme**: Dark navy sci-fi aesthetic

**Color Constants**:
```java
private static final int BG_DARK_NAVY = 0xFF0A1520;      // Content background
private static final int BG_DARKER = 0xFF060D14;         // System bars, title bars
private static final int TEXT_NEON_GREEN = 0xFF00FF00;   // Accent text
private static final int TEXT_CYAN = 0xFF00FFFF;         // Secondary accent
```

**Application Pattern**:
```java
// Content backgrounds (fragments, activities)
rootView.setBackgroundColor(0xFF0A1520);

// System status bar + navigation bar
Window w = activity.getWindow();
w.setStatusBarColor(0xFF060D14);
w.setNavigationBarColor(0xFF060D14);

// Title bars (channel name bar at top)
titleBarView.setBackgroundColor(0xFF060D14);
```

**Sound Bar Animation**: Freezes at 0 when software squelch is closed:
```java
circuitBoardView.audioAmplitude = (useSquelch && !isSquelchOpen) ? 0 : amplitude;
```

### 7. Mode Exclusivity & Channel Backup

**Modes Are Mutually Exclusive**: APRS, SSTV, NOAA, VFO cannot run simultaneously.

**Pattern for Mode Activation**:
```java
// 1. Check no other mode is active
if (isAPRSMonitoringActive || isSSTVMonitoringActive || 
    isNOAAMonitoringActive || isVFOModeActive) {
    Toast.makeText(context, "Stop other mode first", Toast.LENGTH_SHORT).show();
    return;
}

// 2. Save current channel to SharedPreferences (MUST include localId — see Pitfall 15)
saveChannelBackup(currentChannel);

// 3. Hijack channel (change freq, name, etc)
channelData.setRxFreq(144500000);  // 144.500 MHz
channelData.setName("SSTV (original name)");
updateChannel(channelData);

// 4. Set mode flag
isSSTVMonitoringActive = true;

// 5. Enable software squelch if needed
enableSoftwareSquelchOnCurrentChannel();
```

**Pattern for Mode Deactivation**:
```java
// 1. Disable software squelch
disableSoftwareSquelchOnCurrentChannel();

// 2. Restore channel from SharedPreferences
restoreChannelBackup();

// 3. Clear mode flag
isSSTVMonitoringActive = false;

// 4. Refresh UI
syncChannelInfoWithData(restoredChannel);
```

**Crash Recovery**: On app startup, check for incomplete restoration and show recovery dialog.

### 8. Logging Best Practices

**Use XposedBridge.log() for debugging**:
```java
XposedBridge.log(TAG + ": ✓ Hook installed successfully");
XposedBridge.log(TAG + ": Processing audio: length=" + length + ", amplitude=" + amplitude);
XposedBridge.log(TAG + ": ✗ Error: " + e.getMessage());
```

**Log Levels** (by convention):
- `✓` - Success, hook installed
- `✗` - Error, exception caught
- `◆` - State change, important event
- No symbol - Regular debug info

**View Logs**: `adb logcat | grep DMRModHooks`

### 9. Button Creation Pattern

**Standard Button Template**:
```java
android.widget.Button button = new android.widget.Button(activity);
button.setText("🔧 Settings");
button.setTextSize(12);
button.setTextColor(0xFFFFFFFF);
button.setBackgroundColor(0xFF333333);
button.setPadding(10, 10, 10, 10);

LinearLayout.LayoutParams params = new LinearLayout.LayoutParams(
    LinearLayout.LayoutParams.MATCH_PARENT,
    LinearLayout.LayoutParams.WRAP_CONTENT
);
params.setMargins(0, 10, 0, 10);
button.setLayoutParams(params);

button.setOnClickListener(v -> {
    // Handle click
});

parentLayout.addView(button);
```

**Emoji Icons**: Use Unicode emojis for visual branding (📡 🎛️ 📺 🛰️ etc.)

### 10. Hook Method Template

**Standard Hook Structure**:
```java
private void hookExampleMethod(XC_LoadPackage.LoadPackageParam lpparam) {
    try {
        // 1. Find target class
        Class<?> targetClass = XposedHelpers.findClass(
            "com.pri.prizeinterphone.example.TargetClass",
            lpparam.classLoader
        );
        
        // 2. Hook method
        XposedHelpers.findAndHookMethod(
            targetClass,
            "targetMethod",
            String.class,          // Parameter types
            int.class,
            new XC_MethodHook() {
                @Override
                protected void beforeHookedMethod(MethodHookParam param) throws Throwable {
                    // Runs before original method
                    String arg1 = (String) param.args[0];
                    int arg2 = (int) param.args[1];
                    
                    // Optionally prevent original method:
                    // param.setResult(returnValue);
                }
                
                @Override
                protected void afterHookedMethod(MethodHookParam param) throws Throwable {
                    // Runs after original method
                    Object result = param.getResult();
                    
                    // Optionally modify result:
                    // param.setResult(modifiedResult);
                }
            }
        );
        
        XposedBridge.log(TAG + ": ✓ Hook installed: targetMethod");
        
    } catch (Throwable t) {
        XposedBridge.log(TAG + ": ✗ Failed to hook: " + t.getMessage());
        XposedBridge.log(t);
    }
}
```

## Common Pitfalls & Solutions

### ❌ Pitfall 1: Wrong Class Package Path
**Problem**: `com.pri.prizeinterphone.data.ChannelData` vs `com.pri.prizeinterphone.serial.data.ChannelData`

**Solution**: Always verify class paths in decompiled source at `/app/src/main/java/com/pri/prizeinterphone/`

### ❌ Pitfall 2: Squelch Gets Stuck After Channel Change
**Problem**: `isSquelchOpen` retains stale state from previous channel.

**Solution**: Reset ALL squelch state variables on channel change (see pattern above).

### ❌ Pitfall 3: Sound Bars Animate When Squelched
**Problem**: `circuitBoardView.audioAmplitude` set before squelch decision.

**Solution**: Set amplitude AFTER squelch decision, conditionally:
```java
circuitBoardView.audioAmplitude = (useSquelch && !isSquelchOpen) ? 0 : amplitude;
```

### ❌ Pitfall 4: UI Updates From Background Thread
**Problem**: `CalledFromWrongThreadException` crashes.

**Solution**: Wrap all UI updates in `activity.runOnUiThread(() -> { })`.

### ❌ Pitfall 5: Database Not Closed
**Problem**: Database locked, queries fail.

**Solution**: Always close in `finally` block:
```java
SQLiteDatabase db = null;
try {
    db = openDatabase(...);
    // operations
} finally {
    if (db != null) db.close();
}
```

### ❌ Pitfall 6: Race Condition with State Machine
**Problem**: Hardware squelch reverts to `sq=2` after our `sq=0` command.

**Solution**: Hook `sendAnalogMessage` (before hardware send), not `syncChannelInfoWithData` (after).

### ❌ Pitfall 7: Decoders Get Squelched Audio
**Problem**: APRS/SSTV fail to decode weak signals.

**Solution**: Copy audio BEFORE squelch mute, feed copy to decoders:
```java
byte[] originalAudio = Arrays.copyOf(audioData, length);
// ... apply squelch to audioData ...
aprsDecoder.feed(originalAudio);  // Use original, not squelched
```

### ❌ Pitfall 8: Database `updateChannel()` + `syncChannelInfo()` Doesn't Stick
**Problem**: Updating the channel DB and calling `syncChannelInfo()` to push changes (e.g. squelch slider) gets cached/raced by `CmdStateMachine.transitionToSetChannelStateState()`. The hardware reverts.

**Solution**: Construct an `AnalogMessage` (or `DigitalMessage`) directly, copy fields from `currentChannel`, set the field you're changing, and call `.send()` — same path the MON button uses. Bypasses the state machine entirely. The APRS squelch slider was migrated to this pattern on 2026-03-12 and started working immediately. Documented in user-memory `aprs-squelch-investigation.md`.

```java
Class<?> analogMessageClass = XposedHelpers.findClass(
    "com.pri.prizeinterphone.message.AnalogMessage", appClassLoader);
Object am = analogMessageClass.newInstance();
// copy all needed fields from currentChannel ...
XposedHelpers.callMethod(am, "setSq", (byte) 0);
XposedHelpers.callMethod(am, "send");   // hits hardware immediately
```

### ❌ Pitfall 9: Squelch Slider Levels 1, 3–9 Do Nothing
**Problem**: User sets `sq=4` on an analog channel; firmware silently coerces to `2`. Slider does nothing visible.

**Reality**: Only `sq=0` (open) and `sq=2` (tight) are honored by the firmware. Don't expose a hardware squelch slider — use the software-squelch pipeline (which forces hardware to `sq=0` and gates audio in `hookPCMReceiveManager`).

### ❌ Pitfall 10: Soft SQ / APRS Soft SQ state desync
**Problem**: Three separate variables — `isSoftwareSquelchEnabled` (audio pipeline), `isAprsSoftwareSquelchEnabled` (APRS page UI), `softwareSquelchThreshold` (shared) — can fall out of sync when switching between intercom and APRS modes (`startAPRSMonitoring()` overwrites `softwareSquelchThreshold`).

**Current workaround**: Auto-toggle Soft SQ OFF when leaving APRS (commit `6b7f0995`). Proper bidirectional sync is still **open**.

### ❌ Pitfall 11: OpenGD77 CSV Relay Field = 0
**Problem**: Channels exported from OpenGD77 CPS with `relay=0` fail to activate ("operation failed").

**Root Cause**: OpenGD77 uses 0 for "relay disconnect disabled", but Android firmware interprets 0 as APRS/direct mode (invalid).

**Solution**: 
- Use OpenGD77 fork with relay field fix (converts 0→2 on export)
- Android importer has defensive code: `if (relay == 0) relay = 2;`
- Valid relay values: 1=disconnect ON, 2=normal mode (disconnect OFF)

### ❌ Pitfall 12: `channel_txContact` Stores DMR ID, Not Database `_id`
**Problem**: Building the contact map keyed by `_id` (e.g. `contactMap.put(cursor.getLong("_id"), name)`) causes all contact exports to return "None" and all contact imports to default to contact 1.

**Root Cause**: `channel_txContact` stores `contactData.getNumber()` — the 24-bit DMR ID (`contact_number` column) — NOT the database row `_id`. Confirmed by tracing `InterPhoneContactsFragment.saveSelectedData()`.

**Solution**: Build the contact map keyed by `contact_number`, not `_id`. All four files (`DirectDatabaseExporter`, `DirectDatabaseImporter`, `CSVExporter`, `CSVImporter`) must use this key. Android CSV col 11 (`DMR ID`) now also exports the raw DMR ID as a fallback for cross-device imports.

**Import ordering**: Contacts CSV MUST be imported BEFORE channels CSV — name→DMR-ID lookup fails if the contacts table is empty. (Commit `32f8f372`.)

### ❌ Pitfall 13: Post-Channel-Change Squelch Race Condition
**Problem**: After a channel change, `enableSoftwareSquelchOnCurrentChannel()` is called via a 300 ms `postDelayed`. Occasionally the state machine wins and squelch is left initialized-but-not-active. Symptom: a short audio blip on channel load, then everything is blocked even though the threshold is set low enough to pass.

**Workaround**: Touch the squelch slider without moving it — this re-triggers `enableSoftwareSquelchOnCurrentChannel()` and restores correct state. Root cause unresolved as of v3.3.7.

### ❌ Pitfall 14: Zygisk — Static Variables Survive App Restart
**Problem**: In Zygisk, the module's static variables persist across force-close/restart cycles of the target app. A flag like `isSSTVMonitoringActive = true` left by a crash stays `true` on the next launch; the startup code tries to update a stale dialog reference and crashes.

**Solution**: The startup hook MUST explicitly reset ALL mode flags and dialog/receiver references:
```java
isAPRSMonitoringActive = false;
isSSTVMonitoringActive = false;
isNOAAMonitoringActive = false;
isVFOModeActive = false;
// + null all dialog/receiver static refs
```
**Crash recovery**: Also check for `"APRS ("` / `"SSTV ("` prefix in the current channel name at startup — if found, show the channel-restore dialog. **Any new monitoring mode must follow this same pattern.**

**Name nesting guard**: When a mode wraps the channel name (e.g. `"SSTV (" + originalName + ")"`), first check if the name already starts with `"SSTV ("` and ends with `")"` — if so, extract the inner name before re-wrapping. Crash/restart can leave the name already wrapped, producing `"SSTV (SSTV (UHF))"` double-nesting otherwise.

### ❌ Pitfall 15: `localId` Override for VFO Mode (NOT a backup/restore field)
**Reality**: `localId` is the device's own DMR ID. It is **NOT** a column on `ChannelData` / the channel database. It lives on the `DigitalMessage` packet and is populated from `DmrManager.getLocalId()` at packet build time. Trying `XposedHelpers.getObjectField(channelData, "localId")` will throw.

**Why it matters**: VFO mode wants to let the user temporarily transmit with a different DMR ID without permanently changing the device setting. You can't do that by editing the channel — you must override the `localId` field on each outgoing `DigitalMessage`.

**Correct pattern** (already implemented in `hookDmrManager` → `sendDigitalMessage` `beforeHookedMethod` at MainHook.java line ~10458):
```java
private static int vfoLocalId = -1;  // -1 = use channel default, else override

// inside hookDmrManager.sendDigitalMessage beforeHookedMethod:
if (isVFOModeActive && vfoLocalId > 0) {
    XposedHelpers.setObjectField(digitalMessage, "localId", vfoLocalId);
}
```
**Do NOT** add `localId` to any channel backup `HashMap` — the field doesn't exist on `ChannelData`. (The VFO backup file does include a `localId` key but only as an analog-channel safety default; it's not read back from the channel object.)

### ❌ Pitfall 16: PowerShell `Set-Content` Adds UTF-8 BOM to CSV — Wipes Channel List on Import

**Problem**: Editing a `Channels.csv` backup with PowerShell's `Set-Content` (even with `-Encoding UTF8`) writes a UTF-8 BOM (byte order mark: `EF BB BF`) at the start of the file. The Android CSV importer does not strip the BOM, so the header row is read as `﻿_id,Channel Number,...` — the leading `﻿` causes the header parse to fail, which causes `DirectDatabaseImporter` to silently wipe the channel table on import, leaving the channel list empty.

**Symptom**: Import completes without error toast but the channel list is blank immediately after.

**Confirmed incident (2026-06-01)**: NOAA WX6 `Use Location` field was changed from `No` → `Yes` using `Set-Content -Encoding UTF8`. Import wiped all channels. Restore required pulling the original pre-edit file from `C:\Users\Joshua\Downloads\20260601_132759\Channels.csv`.

**Correct pattern** — always use `[System.IO.File]::WriteAllLines` with an explicit no-BOM encoder:
```powershell
$f = "path\to\Channels.csv"
$lines = [System.IO.File]::ReadAllLines($f)
$lines[38] = $lines[38] -replace 'OldValue', 'NewValue'   # make your edit
$enc = New-Object System.Text.UTF8Encoding $false           # $false = no BOM
[System.IO.File]::WriteAllLines($f, $lines, $enc)
```

**Never use**:
```powershell
$lines | Set-Content $f -Encoding UTF8       # ❌ adds BOM
$lines | Out-File $f -Encoding UTF8          # ❌ adds BOM
```

## Build & Deployment

### Build Environment (one-time setup per shell)

Gradle requires `JAVA_HOME` and a populated `local.properties`. If you see "JAVA_HOME is not set" or "SDK location not found":

```powershell
# Java 21 from Android Studio's bundled JBR
$env:JAVA_HOME = "C:\Program Files\Android\Android Studio\jbr"
$env:PATH = "$env:JAVA_HOME\bin;$env:PATH"

# local.properties (one-time — file should already exist)
# Contents: sdk.dir=C\:\\Users\\Joshua\\AppData\\Local\\Android\\Sdk
```

If a clean build fails on missing styles (`AppTheme`, `AppTheme_Dialog`, `DeviceKilledDialog`), copy them from the decompiled tree:
```powershell
Copy-Item decompiled\res\values\styles.xml,colors.xml,dimens.xml,bools.xml `
          app\src\main\res\values\
```

### Build Commands
```powershell
# Build debug APK
cd DMRModHooks
.\gradlew assembleDebug

# Build release APK
.\gradlew assembleRelease
```

### Installation (Preserves LSPosed Module State)

**AI agents:** See [§ AI agents — device deploy (mandatory)](#-ai-agents--device-deploy-mandatory). **Always** `adb reboot` after successful install.

```powershell
# From DMRModHooks directory (recommended — installs then reboots)
.\install.ps1

# OR manually with -r flag (replace without uninstall) — MUST include reboot
.\gradlew assembleDebug
adb install -r -t app\build\outputs\apk\debug\app-debug.apk
adb reboot
```

**CRITICAL**: Always use `-r` flag to replace without uninstalling. Uninstalling disables the LSPosed module and user must manually re-enable.

**CRITICAL**: Always **`adb reboot`** after install so LSPosed loads the new hook code. Skipping reboot is a common cause of “fix didn’t work on device” false negatives.

### Signing Configuration

**CRITICAL REQUIREMENT**: Debug builds MUST use the same signing key as release builds!

**Why This Matters**:
- Prevents signature mismatch that disables LSPosed module on reinstall
- Without matching signatures, Android treats it as a different app
- User would have to manually re-enable the module in LSPosed after every build
- The `-r` flag only works when signatures match

**Configuration Location**: `DMRModHooks/app/build.gradle`

```gradle
signingConfigs {
    release {
        storeFile file('../release.keystore')
        storePassword 'android'
        keyAlias 'dmrmodhooks'
        keyPassword 'android'
    }
    debug {
        // ⚠️ CRITICAL: MUST use same keystore as release!
        // Changing this will cause signature mismatch on install,
        // forcing user to uninstall and re-enable module in LSPosed.
        storeFile file('../release.keystore')
        storePassword 'android'
        keyAlias 'dmrmodhooks'
        keyPassword 'android'
    }
}

buildTypes {
    release {
        signingConfig signingConfigs.release
    }
    debug {
        signingConfig signingConfigs.debug
    }
}
```

**Keystore Details**:
- Location: `DMRModHooks/release.keystore`
- Store Password: `android`
- Key Alias: `dmrmodhooks`
- Key Password: `android`

**If Signature Mismatch Occurs**:
1. One-time uninstall: `adb uninstall com.dmrmod.hooks`
2. Install with new signing: `adb install app\build\outputs\apk\debug\app-debug.apk`
3. User must re-enable module in LSPosed
4. Future installs will work with `-r` flag

### Git Workflow

**IMPORTANT**: Only commit and push changes when explicitly requested by the user. Do not automatically commit after making code changes.

```powershell
cd C:\Users\Joshua\Documents\android\phonedmrapp
git add -A
git commit -m "Descriptive commit message"
git push origin main
```

### GitHub Release Process

**IMPORTANT**: Only create releases when explicitly requested by the user. Do not automatically create releases after version updates or feature completion.

**When to Create a Release** (at user's request):
- Major new features (APRS, SSTV, NOAA, VFO modes)
- Critical bug fixes affecting user experience
- Breaking changes or API updates
- After significant testing and validation

**Release Workflow**:

#### 1. Update Version Number
Edit `DMRModHooks/app/build.gradle`:
```gradle
defaultConfig {
    versionCode 337         // Increment by 1
    versionName "3.3.7"    // Update to new version
}
```

#### 2. Build Release APK
```powershell
cd DMRModHooks
.\gradlew assembleRelease

# APK location: app\build\outputs\apk\release\app-release.apk
```

#### 3. Create Release Notes
Create file in `releases/` folder (e.g., `v3.3.7_RELEASE_NOTES.md`):
```markdown
# DMRModHooks v3.3.7 Release Notes

## Release Date
May 13, 2026

## What's New

### 🎯 Major Features
- Feature 1 description
- Feature 2 description

### 🐛 Bug Fixes
- Bug fix 1
- Bug fix 2

### 🔧 Technical Changes
- Technical change 1
- Technical change 2

## Installation
1. Download APK from release page
2. Install with: adb install -r DMRModHooks-v3.3.7.apk
3. Reboot device
4. Verify in LSPosed manager (module should remain enabled)

## Testing
- Tested on: Ulefone Armor 26 Ultra, Android 13
- LSPosed: v1.9.2+
- Target app: com.pri.prizeinterphone
```

#### 4. Commit Version Changes
```powershell
git add -A
git commit -m "Release v3.3.7

- Update version code to 337
- Update version name to 3.3.7
- Add release notes"
git push origin main
```

#### 5. Create GitHub Release
1. Go to: https://github.com/IIMacGyverII/phonedmrapp/releases/new
2. **Tag version**: `v3.3.7` (click "Create new tag")
3. **Release title**: `DMRModHooks v3.3.7 - [Brief Feature Description]`
4. **Description**: Copy from release notes file, format with Markdown
5. **Attach binaries**:
   - Upload `app-release.apk` (rename to `DMRModHooks-v3.3.7.apk`)
   - **Upload the latest `OpenGD77Fork/OpenGD77CPS-Mac_Build_YYYYMMDD_HHmmss.zip`** — EVERY release must include the fork binary as a downloadable asset. If the fork hasn't changed since the previous release, re-upload the same zip from `OpenGD77Fork/`. Do not publish an APK release without it.
6. Check "Set as the latest release"
7. Click "Publish release"

#### 6. Copy APK to releases/ Folder
```powershell
Copy-Item "DMRModHooks\app\build\outputs\apk\release\app-release.apk" `
    "releases\DMRModHooks-v3.3.7.apk"
git add releases/DMRModHooks-v3.3.7.apk
git commit -m "Add v3.3.7 APK to releases folder"
git push origin main
```

#### 7. Update README.md (if needed)
**IMPORTANT**: Only update and commit README changes when explicitly requested by the user.

- Add new features to feature list
- Update version numbers in installation instructions
- Update screenshots if UI changed
- Wait for user approval before committing changes

**Release Checklist**:
- ✅ Version numbers updated in build.gradle
- ✅ Release APK built successfully
- ✅ Release notes created and comprehensive
- ✅ All changes committed to main branch
- ✅ GitHub release created with tag
- ✅ APK uploaded and renamed properly
- ✅ **If testing on device:** `adb install -r releases\DMRModHooks-vX.X.X.apk` then **`adb reboot`** (mandatory for AI agents — see deploy section above)
- ✅ **OpenGD77 fork zip attached** (reuse latest from `OpenGD77Fork/` if unchanged — never omit it)
- ✅ Release published (not draft)
- ✅ APK copied to releases/ folder and committed
- ✅ README.md updated if needed

**Post-Release**:
- Monitor GitHub issues for bug reports
- Test download link in release page
- Verify LSPosed module works after upgrade
- Create hotfix release if critical bugs found

## Testing Checklist

### After Making Changes
1. ✅ Build succeeds without errors
2. ✅ Install with `-r` flag (no uninstall)
3. ✅ Reboot device (required for Xposed module changes)
4. ✅ Check Xposed logs: `adb logcat | grep DMRModHooks`
5. ✅ Verify hook installation logs (`✓ Hook installed`)
6. ✅ Test affected features (UI, audio, channel changes, modes)
7. ✅ Check for crashes or unexpected behavior

### Software Squelch Testing
1. Enable SOFT SQ button on intercom page
2. Adjust slider (0-9)
3. Verify status indicator shows green circle when open, gray when closed
4. Change channels - verify squelch continues working
5. Touch slider without changing - verify no issues
6. Disable SOFT SQ - verify hardware squelch restores

### Mode Testing (APRS/SSTV/NOAA/VFO)
1. Start mode from intercom page button
2. Verify channel backup saved
3. Verify frequency/name hijack applied
4. Stop mode
5. Verify channel restored correctly
6. Verify crash recovery dialog on simulated crash

## Related Files & Documentation

### Key Documentation Files
- `README.md` - User-facing feature documentation
- `APRS_COMPLETE_SYSTEM_SUMMARY.md` - APRS implementation details
- `SSTV_PHASE1_COMPLETE.md` - SSTV decoder architecture
- `SOFTWARE_SQUELCH_DESIGN.md` - Software squelch design document
- `VFO_IMPLEMENTATION_PLAN.md` - VFO mode implementation notes

### OpenGD77 Integration

**Cross-Platform Codeplug Management**: Full import/export compatibility with OpenGD77 CPS software.

**Android App Features**:
- Export/import all 5 CSV files: Channels, Contacts, TG_Lists, Zones, DTMF
- Files saved to `/sdcard/Download/DMR_Backups/YYYYMMDD_HHmmss/`
- Direct database import via `DirectDatabaseImporter.java`
- Defensive relay=0 conversion (see below)

**OpenGD77 CPS Fork**:
We maintain a fork of OpenGD77 CPS with critical bug fixes for Android compatibility.

**Fork Location**: `C:\Users\Joshua\Documents\android\OpenGD77CPS-Mac` (separate git repo)  
**Compiled binary**: stored in `phonedmrapp/OpenGD77Fork/` (NOT a submodule)

#### Key Source Files

| File | Purpose |
|------|---------|
| `DMR/ChannelsForm.cs` | Android CSV export (`ExportToAndroidCsvFile`) + **both active import paths** (see Three Import Paths below) |
| `DMR/ChannelsCsvImporter.cs` | **DEAD CODE** — correct 37-col importer, never called from any call site |
| `DMR/ChannelForm.cs` | `ChannelOne` struct, static CSV arrays (`CsvLatitudes`, `CsvLongitudes`, `CsvUseLocations`, `CsvEncryptKeys`), `DispData`/`SaveData` |
| `DMR/AboutForm.cs` | `FORK_VERSION` constant — bump on every build |

#### Three Import Paths — CRITICAL ARCHITECTURE

There are three import code paths. **Only Path B handles Android CSV.** This has caused multiple bugs where code edits in Path C had no effect in practice.

| Path | Method | Trigger | Android CSV? | Notes |
|---|---|---|---|---|
| **A** `import()` | `ChannelsForm.import()` (private) | Import buttons on the channel grid | ❌ Rejects with DataFormatError | Checks `csvRow.SequenceEqual(SZ_EXPORT_HEADER_TEXT)` — exact 35-col OpenGD77 header only |
| **B** `ImportFromCsvFile()` | `ChannelsForm.ImportFromCsvFile()` (public static) | MainForm menu batch import | ✅ YES — detects `_id` column | The ONLY working Android import path. As of fork v1.2.0 reads all 37 cols including lat/lon/UseLocation |
| **C** `ImportChannelsFromCsv()` | `ChannelsCsvImporter.ImportChannelsFromCsv()` | **Never called** | Would work | Dead code — correct logic, zero call sites |

**Static array key**: `ImportFromCsvFile()` uses `foundIndex = ChannelForm.data.GetMinIndex()` — a sequential 0-based slot, **not** `channelNumber - 1`. The `CsvLatitudes[foundIndex]` etc. arrays are keyed by this index, stored in `base.Tag`, and accessed in `DispData`/`SaveData` as `int index = num % 1024;`.

**Binary save/load does NOT preserve static arrays**: Lat/lon/useLocation/encryptKey are CSV-only. They are lost if the user saves as `.g77` binary — always import from CSV, not a previously saved binary.

**Comprehensive codebase documentation**: See `docs/CODEBASE_DEEP_DIVE.md` in the fork repo (`C:\Users\Joshua\Documents\android\OpenGD77CPS-Mac\docs\CODEBASE_DEEP_DIVE.md`). Read this before editing any import/export path — it documents the full architecture, all three import paths, static array conventions, known pitfalls, and round-trip column mapping.

#### Android CSV Format (37 columns, always exported WITH `_id`)

```
Col  0: _id              Col 10: TG List          Col 20: All Skip
Col  1: Channel Number   Col 11: DMR ID (empty*)  Col 21: TOT
Col  2: Channel Name     Col 12: TS1_TA_Tx         Col 22: VOX
Col  3: Channel Type     Col 13: TS2_TA_Tx ID      Col 23: No Beep
Col  4: Rx Frequency     Col 14: RX Tone           Col 24: No Eco
Col  5: Tx Frequency     Col 15: TX Tone           Col 25: APRS
Col  6: Bandwidth (kHz)  Col 16: Squelch           Col 26: Latitude
Col  7: Colour Code      Col 17: Power             Col 27: Longitude
Col  8: Timeslot         Col 18: Rx Only           Col 28: Use Location
Col  9: Contact          Col 19: Zone Skip         Col 29: Encrypt Switch
                                                   Col 30: Encrypt Key
                                                   Col 31: Relay
                                                   Col 32: Interrupt
                                                   Col 33: Active
                                                   Col 34: Outbound Slot
                                                   Col 35: Channel Mode
                                                   Col 36: Contact Type
```
*Col 11 (DMR ID): CPS always exports empty — Android importer falls back to contact name lookup.

**OpenGD77 format (no `_id`)**: 36 columns — same fields shifted left by 1 (cols 0-35). New fields start at col 28.

#### The Other 4 CSV Files (Contacts / TG_Lists / Zones / DTMF)

Channels.csv gets the spotlight because that's where round-trip bugs hide, but a full backup folder contains **5 CSVs**. All are written by `DirectDatabaseExporter` and read by `DirectDatabaseImporter` (the active path; `CSVImporter.java` is legacy).

| CSV file | Header | Source (export) | Destination (import) | Notes |
|---|---|---|---|---|
| `Contacts.csv` | `Contact Name,ID,ID Type,TS Override` | OEM `contact_database.db → contact_database` | same OEM table | `ID` is the 24-bit DMR ID (`contact_number`). `ID Type` = 0/1/2 (Private/Group/AllCall). |
| `TG_Lists.csv` | `TG List Name,Contact1,…,Contact32` | Module `dmrmod_tglists.db → tg_lists` | same module table | Lists longer than 32 IDs are split into `Name_part1`, `Name_part2`, … rows. |
| `Channels.csv` | 37 cols (see above) | OEM `database_channel_area_default_uhf` + module APRS/locations DBs | OEM channel table + module DBs | The big one. |
| `Zones.csv` | `Zone Name,Channel1,…,Channel80` | Module `dmrmod_zones.db → zones` | same module table | Channel cells store channel **names** (or `name⟨_id⟩` compound key when `USE_COMPOUND_KEY_ZONES = true`). Lookup map keyed by `_id`. |
| `DTMF.csv` | `Contact Name,Code` | OEM DTMF contact table | OEM DTMF contact table | Smallest of the 5. |

**Import order (enforced by `DirectDatabaseImporter.showImportDialog` at lines ~315-327):**
1. `Contacts.csv` — must be first (channel→contact resolution needs the contact table populated; see Pitfall 12)
2. `TG_Lists.csv` — depends on contacts (TG IDs are resolved by contact name when present)
3. `Channels.csv` — depends on contacts (`channel_txContact` lookup) and TG lists (`channel_groups` precomputation)
4. `Zones.csv` — depends on channels (must resolve channel names → `_id`)
5. DTMF is imported in the OEM path or skipped (depends on backup contents)

If you reorder these or import Channels alone, expect "operation failed" toasts and silent contact-id-defaulting-to-1 corruption.

#### Where each CSV lands in the database stack

```
Contacts.csv  ──► com.pri.prizeinterphone /databases/contact_database.db
TG_Lists.csv  ──► com.dmrmod.hooks       /databases/dmrmod_tglists.db
Channels.csv  ──► com.pri.prizeinterphone /databases/database_channel_area_default_uhf.db   (main row)
              ──► com.dmrmod.hooks       /databases/dmrmod_aprs.db                          (APRS enable flag, cols 25 of CSV)
              ──► com.dmrmod.hooks       /databases/dmrmod_locations.db                     (lat/lon/useLocation, cols 26-28)
Zones.csv     ──► com.dmrmod.hooks       /databases/dmrmod_zones.db
DTMF.csv      ──► com.pri.prizeinterphone /databases/(DTMF table — OEM-owned)
```

This is why "Channels CSV round-trip works" doesn't mean "everything round-trips" — the APRS/location/zone/tg-list bits live in our 4 module DBs and travel via separate CSVs. A partial backup that's missing any of the 5 will silently drop data on restore.

#### CPS Internal Model Conventions (ChannelOne class)

These are the values stored INSIDE the CPS model, which differ from CSV/Android values:

| Property | CPS Internal | Android CSV | Notes |
|----------|-------------|-------------|-------|
| `OutboundSlot` | 1-based (1=Slot1, 2=Slot2) | 0-based (0=Slot1, 1=Slot2) | UI: `SelectedIndex + 1` on save, `Max(0, value-1)` on display |
| `Relay` | 0=normal (unchecked), 1=relay disconnect (checked) | 0=invalid→2, 1=disconnect, 2=normal | CPS exports 0 or 1; Android converts 0→2 |
| `Contact` | 1-based index into `ContactForm.data` | Contact name string (col 9) | CPS looks up name; DMR ID always empty (col 11) |
| `AndroidContactType` | 0=PERSON, 1=GROUP, 2=ALL | same values | Direct match to Android `ChannelContactType` constants |
| `EncryptSwitch` | 0 (always — can't store keys in .g77 binary) | 0 | Round-trip loses encryption |

#### Import Field Index Mapping (ChannelsCsvImporter.cs)

The new-fields block uses `GetField(row, N, fieldOffset)` where:
- Android format: `fieldOffset = 1` (skip `_id` col)
- OpenGD77 format: `fieldOffset = 0`

Correct unified indices (28–35) — `GetField(row, N, fieldOffset)` resolves to the right column for both formats:

```
GetField(row, 28, fieldOffset) → Encrypt Switch (col 29 Android / col 28 OpenGD77)
GetField(row, 29, fieldOffset) → Encrypt Key
GetField(row, 30, fieldOffset) → Relay
GetField(row, 31, fieldOffset) → Interrupt
GetField(row, 32, fieldOffset) → Active
GetField(row, 33, fieldOffset) → Outbound Slot  ← then +1 to convert 0-based → 1-based
GetField(row, 34, fieldOffset) → Channel Mode
GetField(row, 35, fieldOffset) → Contact Type
```

**⚠️ If you ever see indices 29-36 here, it's the original off-by-one bug — fix to 28-35.**

#### Relay Round-Trip

The relay field went through several changes. Current correct behavior:

- CPS UI: checkbox → `Relay = 0` (unchecked, normal mode) or `1` (checked, relay disconnect)
- CPS exports: raw `0` or `1`
- Android `DirectDatabaseImporter`: converts `0 → 2` (defensive: 0 is invalid for firmware)
- Android `CSVImporter`: same `0 → 2` conversion
- Valid Android firmware values: `1` = relay disconnect ON, `2` = normal mode (disconnect OFF)

#### Outbound Slot Round-Trip (after fix)

```
Android DB (0-based) → export "0" or "1"
  → CPS import: +1 → model stores 1 or 2 (1-based)
  → CPS UI: Max(0, value-1) = 0 or 1 (SelectedIndex) → shows "Slot 1" or "Slot 2" ✓
  → CPS save: SelectedIndex+1 → model still 1 or 2 ✓
  → CPS export: Max(0, value-1) = "0" or "1" (0-based)
  → Android import: stores 0 or 1 in DB ✓
```

#### OpenGD77 Fork Build Instructions

**Location**: `C:\Users\Joshua\Documents\android\OpenGD77CPS-Mac`

**Building on Windows**:
```powershell
# Prerequisites: Visual Studio 2019+ with .NET Framework 4.8
cd C:\Users\Joshua\Documents\android\OpenGD77CPS-Mac
msbuild OpenGD77CPS.sln /p:Configuration=Release

# Output: bin/ReleaseOpenGD77/OpenGD77CPS.exe
```

**Latest Build**: `OpenGD77Fork/OpenGD77CPS-Mac_Build_20260601_142528.zip`

**Comprehensive codebase documentation**: See `docs/CODEBASE_DEEP_DIVE.md` in the fork repo (`C:\Users\Joshua\Documents\android\OpenGD77CPS-Mac\docs\CODEBASE_DEEP_DIVE.md`). Read this before editing any import/export path — it documents the full architecture, all three import paths, static array conventions, known pitfalls, and round-trip column mapping.

#### Fork Versioning (REQUIRED — keep in sync with every build)

Our fork is **NOT** the upstream OpenGD77 CPS — it has Android-database-specific patches (relay coercion, timeslot 0/1-based, contact-by-DMR-ID, 37-col CSV) that **will corrupt a real Radioddity GD-77 codeplug**. To make sure users can't confuse the two, the fork carries its own version string visible in the About dialog and window title.

**Single source of truth**: `DMR/AboutForm.cs` constants near the top of the class:
```csharp
public const string FORK_VERSION = "1.2.0";              // bump on EVERY build
public const string FORK_NAME    = "DMRModHooks / PriInterPhone fork";
```

**The About dialog also shows a red warning block** (`lblForkInfo`) stating:
- This is the IIMacGyverII fork patched for PriInterPhone hardware
- It must NOT be used to manage a stock GD-77
- Link back to https://github.com/IIMacGyverII/OpenGD77CPS-Mac

**Versioning rules:**
1. **Increment `FORK_VERSION` (PATCH minimum) on every build that gets attached to a DMRModHooks GitHub release**, even if only the rebuild date changed. Users need to be able to tell two zips apart.
2. **MAJOR** bump = breaking change to CSV round-trip behavior (e.g. new column order).
3. **MINOR** bump = new fix or new field handled.
4. **PATCH** bump = rebuild, cosmetic tweak, no behavior change.
5. After bumping, commit in the fork repo with message like `Fork v1.0.1 — rebuild for DMRModHooks v3.3.8`, tag it `fork-v1.0.1`, then `git push --tags`.
6. Update `OpenGD77Fork/RELEASE_NOTES_*.md` (rename or add a new dated file) to mention the new fork version and which DMRModHooks release it ships with.
7. If `FORK_VERSION` was NOT bumped between two DMRModHooks releases (fork was unchanged), you may re-attach the existing zip from `OpenGD77Fork/` to the new release — but the zip filename and the in-binary `FORK_VERSION` must match what the previous release shipped.

**Testing Workflow**:
1. Export codeplug from Android app (CSV files)
2. Import CSV into OpenGD77 CPS (File → Import CSV)
3. Edit channels in CPS
4. Export CSV from CPS (File → Export CSV → Android format)
5. Import CSV back to Android app
6. Verify channels activate without "operation failed" errors
7. Verify Slot 2 channels use correct timeslot after round-trip

#### Key Files
- `OpenGD77Fork/RELEASE_NOTES_20260329.md` - Bug fix documentation
- `DMRModHooks/app/src/main/java/com/dmrmod/hooks/DirectDatabaseImporter.java` - Android CSV importer
- `DMRModHooks/app/src/main/java/com/dmrmod/hooks/DirectDatabaseExporter.java` - Android CSV exporter

## Development Guidelines

### When Adding New Features
1. **Plan First**: Document in a markdown file before coding
2. **Hook Carefully**: Use `beforeHookedMethod` for interception, `afterHookedMethod` for observation
3. **State Management**: Add new state variables as `private static volatile`
4. **Thread Safety**: All UI updates via `runOnUiThread`, shared state must be thread-safe
5. **Logging**: Add comprehensive logs for debugging
6. **Error Handling**: Wrap everything in try-catch to prevent app crashes
7. **Testing**: Test on real hardware (DMR radio required)
8. **Feature Log**: Add entry to feature log (session memory or CHANGELOG_DRAFT.md) for README/release notes

### When Modifying Audio Pipeline
1. **Never Block**: Audio hook runs at 8kHz sample rate - keep processing under 2ms
2. **Pre-Allocate**: Use pre-allocated buffers to avoid GC pressure
3. **Background Thread**: Heavy processing (FFT, decode) must run in background
4. **Copy First**: Make audio copy before muting for decoders
5. **Test Latency**: Verify no audio buffering delays or dropouts

### When Changing Hardware Commands
1. **Understand State Machine**: `CmdStateMachine.java` controls hardware programming flow
2. **Hook Early**: Intercept before hardware send (`sendAnalogMessage`, `sendDigitalMessage`)
3. **Delayed Re-apply**: Schedule 300ms+ delayed commands for state machine race conditions
4. **Log Everything**: Hardware bugs are hard to diagnose - log all changes
5. **Test Channel Changes**: Verify works across all channel change paths

## Feature Tracking

### Maintaining a Feature Log

**Purpose**: Keep a running log of new features, bug fixes, and changes as they are implemented during development. This log serves as the foundation for README updates and release notes.

**Where to Track**: Use session memory or create a temporary tracking file during active development:
- Session-based: Store in `/memories/session/feature_log.md` during development
- File-based: Create `CHANGELOG_DRAFT.md` in project root for ongoing work

**What to Log**:
```markdown
## [Date] - Feature/Fix Name

### Type
- 🎯 New Feature
- 🐛 Bug Fix
- 🔧 Technical Change
- ⚡ Performance Improvement
- 📝 Documentation

### Description
Brief 1-2 sentence description of what was added/fixed

### User Impact
How this affects the user experience

### Technical Details
- Implementation approach
- Key files modified
- Hook methods added/changed
- Database schema changes

### Testing Notes
- What was tested
- Edge cases considered
- Known limitations
```Serial Protocol Reference (`/dev/ttyS0` to radio MCU)

| Cmd | Name | Notes |
|---|---|---|
| 0x22 | `SET_DIGITAL_INFO_CMD` | DigitalMessage — DMR channel programming |
| 0x23 | `SET_ANALOG_INFO_CMD` | AnalogMessage — analog channel programming. Intercept here in `beforeHookedMethod` to override `sq` before hardware send. |
| 0x2E | `SET_VOL_CMD` | VolumeMessage |
| 0x30 | `SET_SQUELCH_CMD` | SquelchMessage (rarely used directly — `sq` is per-channel) |
| 0x32 | `QUERY_SIGNAL_STRENGTH_CMD` | SignalMessage — returns `rssi` byte in dBm. Used by software squelch. |
| 0x33 | `SET_RELAY_CMD` | RelayMessage — single byte. `0` = relay-disconnect off (normal repeater behavior). `1` = relay-disconnect on. The "Relay disconnection" UI string maps directly to this. Error states: `RELAY_ACTIVITY_TIME_OUT = 0x6`, `RelayConnectionFailedState`. |

No LED-control command exists in the 0x22–0x3C range. LEDs are controlled solely by the radio MCU firmware.

**Additional confirmed commands** (exact hex not all pinned): `SET_ENHANCE_FUNCTION` (5 remote sub-functions — Radio Check `1` / Call Alert `2` / Remote Monitor `3` / Radio Kill `4` / Radio Revive `5`; no UI built yet), `SEND_SMS` / `RECEIVE_SMS`, `QUERY_DIGITAL_AUDIO_RECEIVE_INFO`, `SET_LISTEN`, `SET_ENCRYPT_FUNCTION`, `SET_POLITE_POLICY`, `INTERRUPT_TRANSMIT` (3 modes), TOT (`0x3B`), BER test (`0x3F`). Full table in `.docs/AI_LOGS_SUMMARY.md` §7.

## 

**Example Entry**:
```markdown
## 2026-05-13 - Zone Filtering for Channel Navigation

### Type
- 🎯 New Feature

### Description
Added zone-based filtering to channel up/down buttons, allowing navigation within current zone only.

### User Impact
Users can now navigate only through channels in their current zone, making channel switching faster and more organized.

### Technical Details
- Modified `hookChannelNavigation()` in MainHook.java
- Added zone boundary detection logic
- Wraps to first/last channel in zone instead of entire channel list

### Testing Notes
- Tested with 3 zones (VHF, UHF, DMR)
- Edge case: Empty zones handled with fallback
- Known limitation: Zone name display not yet implemented
```

**When to Update**:
1. **After implementing a feature**: Add entry immediately while details are fresh
2. **After fixing a bug**: Document the problem, solution, and impact
3. **During code reviews**: Update with any changes or improvements made
4. **Before committing**: Ensure log entry matches the code changes

**Using the Log**:
- **README updates**: Copy feature descriptions to appropriate sections
- **Release notes**: Organize by category (Features, Bug Fixes, Technical Changes)
- **Git commit messages**: Reference log entries for detailed commits
- **User documentation**: Expand log entries into usage instructions

**Cleanup**:
- Archive completed logs after release to `releases/vX.X.X_FEATURE_LOG.md`
- Clear session memory after README/release notes are updated
- Start fresh log for next development cycle

## Version History & Milestones

- **v3.3.7** (Mar 2026) - GPS messaging with coordinate hyperlinking
- **v3.3.6** (Mar 2026) - TG List direct DB write + group grid refresh
- **v3.3.5** (Mar 2026) - NOAA software squelch slider
- **v3.3.4** (Mar 2026) - NOAA APT satellite monitoring
- **v3.3.3** (Mar 2026) - SSTV settings & received images dialogs
- **v3.3.0** (Mar 2026) - SSTV live monitoring
- **v3.1.5** (Mar 2026) - VFO mode (variable frequency oscillator)
- **v3.1.4** (Mar 2026) - Software squelch state fix (channel change bug)
- **v3.1.0** (Mar 2026) - APRS live monitoring
- **v1.7.0** (Feb 2026) - Transcription and API features
- **v1.0.0** - Initial LSPosed module with OpenGD77 export/import

## Troubleshooting

### Module Not Loading
- Verify LSPosed manager shows module enabled for `com.pri.prizeinterphone`
- Check LSPosed logs: Settings → Logs
- Reboot device after changes
- Reinstall with `-r` flag to preserve module state

### Hooks Not Working
- Check class paths in decompiled source
- Verify method signatures match target app version
- Enable verbose Xposed logging
- Look for `ClassNotFoundException` or `NoSuchMethodError` in logs

### Audio Issues
- Check `hookPCMReceiveManager` logs
- Verify software squelch state variables
- Test with squelch disabled
- Check for audio buffering delays (should be < 100ms)

### UI Not Updating
- Verify `runOnUiThread` wrapper
- Check for null view references
- Use `postDelayed` for timing-sensitive updates
- Verify fragment lifecycle (don't update destroyed views)

## Contact & Support

- **Developer**: IIMacGyverII
- **Repository**: https://github.com/IIMacGyverII/phonedmrapp
- **License**: See LICENSE file

---

**Last Updated**: May 2026
**Document Version**: 1.0
