# DMRModHooks - Copilot Instructions

## Project Overview

**DMRModHooks** is an LSPosed/Xposed module for the PriInterPhone DMR radio Android app. It provides comprehensive runtime modifications without altering the original APK, preserving the platform signature required for hardware access.

**Current Version**: v3.3.7 (March 2026)
**Target App**: `com.pri.prizeinterphone` (PriInterPhone DMR Radio)
**Framework**: LSPosed/Xposed
**Language**: Java (Android)

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

```
DMRModHooks/
├── app/
│   ├── src/main/java/com/dmrmod/
│   │   ├── hooks/
│   │   │   └── MainHook.java           # Main hook class (16,000+ lines)
│   │   ├── databases/
│   │   │   └── APRSDatabase.java       # APRS data persistence
│   │   ├── aprs/                       # APRS decoding/encoding
│   │   ├── sstv/                       # SSTV decoding
│   │   ├── noaa/                       # NOAA APT satellite decoding
│   │   └── views/
│   │       └── CircuitBoardView.java   # Custom sound bar UI
│   ├── src/main/res/                   # Resources (layouts, drawables)
│   └── build.gradle                    # App-level build config
└── build.gradle                        # Project-level build config
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

## Key Hook Methods

### UI Modification Hooks
- `hookMainActivity()` - Main app initialization, status bar colors
- `hookTalkBackFragment()` - Intercom page (main screen with PTT)
- `hookLocalFragment()` - Device/Settings tab
- `hookChannelEditActivity()` - Channel editor
- `hookBottomNavBar()` - Bottom navigation theming
- `hookOtherFragmentBackgrounds()` - Channel/Contacts/Message/Device pages
- `hookGenericActivityBackgrounds()` - Sub-activities (Settings, DeviceArea, etc.)

### Audio Processing Hooks
- `hookPCMReceiveManager()` - **CRITICAL** - Audio pipeline hook
  - Intercepts all PCM audio before speaker
  - Implements software squelch
  - Feeds APRS/SSTV/NOAA decoders
  - Handles recording and transcription
  - Updates sound bar animations
  
### Hardware Control Hooks
- `hookDmrManager()` - Channel management, hardware commands
- `hookModuleStatusHandler()` - Radio state (RX/TX/idle)
- `hookSerialCommunication()` - Low-level hardware comms
- `hookChannelNavigation()` - Channel up/down buttons with zone filtering

### Data Management Hooks
- `hookChannelListFilter()` - Filter channels by zone
- `hookChannelListUI()` - Add zone badge to channel list items

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

// 2. Save current channel to SharedPreferences
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

## Build & Deployment

### Build Commands
```powershell
# Build debug APK
cd DMRModHooks
.\gradlew assembleDebug

# Build release APK
.\gradlew assembleRelease
```

### Installation (Preserves LSPosed Module State)
```powershell
# From DMRModHooks directory
.\install.ps1

# OR manually with -r flag (replace without uninstall)
.\gradlew assembleDebug
adb install -r -t app\build\outputs\apk\debug\app-debug.apk
adb reboot
```

**CRITICAL**: Always use `-r` flag to replace without uninstalling. Uninstalling disables the LSPosed module and user must manually re-enable.

### Signing Configuration
- Both debug and release builds use `release.keystore` (same signature)
- Required to prevent LSPosed module from being disabled on reinstall
- Keystore location: `DMRModHooks/release.keystore`
- Password: `android`, Alias: `dmrmodhooks`

### Git Workflow
```powershell
cd C:\Users\Joshua\Documents\android\phonedmrapp
git add -A
git commit -m "Descriptive commit message"
git push origin main
```

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
- OpenGD77 CSV export/import for cross-platform codeplug management
- Files saved to `/sdcard/Download/DMR_Backups/YYYYMMDD_HHmmss/`
- 5 CSV files: Channels, Contacts, TG_Lists, Zones, DTMF

## Development Guidelines

### When Adding New Features
1. **Plan First**: Document in a markdown file before coding
2. **Hook Carefully**: Use `beforeHookedMethod` for interception, `afterHookedMethod` for observation
3. **State Management**: Add new state variables as `private static volatile`
4. **Thread Safety**: All UI updates via `runOnUiThread`, shared state must be thread-safe
5. **Logging**: Add comprehensive logs for debugging
6. **Error Handling**: Wrap everything in try-catch to prevent app crashes
7. **Testing**: Test on real hardware (DMR radio required)

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
