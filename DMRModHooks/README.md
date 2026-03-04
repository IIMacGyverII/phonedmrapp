# DMRModHooks - LSPosed Module for PriInterPhone

**LSPosed module for modifying the Ulefone PriInterPhone DMR app at runtime**

## Status: ✅ FULLY WORKING - Complete OpenGD77 CSV Export/Import

**Current Version**: v3.0.2 (March 4, 2026) - **Analog MON Button + MacGyver Mod Branding**  
**Stable Release**: v1.7.0 (February 2026) - Transcription & API key features  
**Target App**: com.pri.prizeinterphone (Ulefone PriInterPhone)  
**Device**: Ulefone Armor 26 Ultra (Android 13)  
**Backup Location**: `Download/DMR/DMR_Backups/`  
**Recordings Location**: `Download/DMR/Recordings/[ChannelName]/`  
**Requires**: 
- LSPosed Framework v1.9.2+ (Zygisk variant)
- Magisk v24+ with Zygisk enabled
- Rooted device with unlocked bootloader

## 🚀 Why v3.0.2? Skipping v2.x Release

**TL;DR**: Jumped from v1.7.0 → v3.0.2 to get the working analog MON button released while DMR group calling bugs are being investigated.

### Version Strategy Explained

**v1.x Series** (v1.0 - v1.7.0): Stable feature releases
- ✅ OpenGD77 CSV export/import
- ✅ Location tracking (city/state, elevation)
- ✅ RSSI signal strength display
- ✅ DMR activity history
- ✅ Per-channel transcription
- ✅ API key configuration

**v2.x Series** (Planned): DMR enhancements
- ⏳ **IN DEVELOPMENT**: DMR group calling improvements
- ⏳ **BLOCKED**: Fixing "All" mode reception issues
- ⏳ DMR monitoring mode (when group calling fixed)
- 🔬 Requires extensive hardware-level debugging

**v3.x Series** (Current): Analog features + branding
- ✅ **v3.0.2 RELEASED**: Analog MON button (fully working)
- ✅ MacGyver Mod branding in Information page
- ✅ Stable and production-ready

### Why Skip v2?

DMR group calling debugging is **complex and time-consuming**:
- Requires deep UART protocol analysis
- Hardware message timing issues
- Interaction with firmware quirks
- Could take weeks to fully resolve

Rather than delay a working feature, I decided to:
1. ✅ Release v3.0.2 with **fully working analog MON button** NOW
2. ⏳ Continue DMR group calling investigation separately
3. 🔜 Release v2.x when DMR issues are resolved
4. 📋 Re-enable DMR monitoring in future v3.1+ update

**Bottom line**: You get useful features faster, and I can focus on complex DMR debugging without holding up releases!

## Quick Links

- [Installation Guide](#installation-from-scratch)
- [Development History](#development-history)
- [Releases](../../releases) - Download pre-built modules
- [Technical Details](#technical-details)

## 🎉 What's New in v3.0.2 (vs v1.7.0 Stable)

### 🆕 Major Features Added

#### 1. Analog MON (Monitor) Button ⭐ **NEW!**

A fully functional monitoring button for analog channels - like a scanner mode:

**How It Works**:
- 📻 **MON ON**: Squelch fully open (sq=0) - hear ALL audio continuously
- 🔇 **MON OFF**: Normal squelch filtering based on channel settings
- 🎨 Visual feedback: Orange button = monitoring, Gray = normal
- 🔄 Auto-resets to OFF when switching channels
- 📱 Toast notifications confirm state changes

**Technical Implementation**:
- ✅ Direct hardware messaging (bypasses database sync)
- ✅ Manual AnalogMessage construction with modified squelch
- ✅ Preserves all 11 channel parameters
- ✅ Handles hardware timing correctly

**Current Status**:
- ✅ **Analog channels**: Fully working and stable
- ⏸️ **Digital channels**: Button hidden (DMR "All" mode needs fixing)
- 📝 TODO comments in code for future DMR re-enablement

**Use Cases**:
- Monitor busy simplex frequencies
- Listen to repeater traffic continuously  
- Emergency channel monitoring
- Amateur radio scanning operations

#### 2. MacGyver Mod Branding 🏷️ **NEW!**

Project identity and attribution in the app:

**What You'll See** (Device → Information page):
- 🆕 New "MacGyver Mod Version" row
- 🔗 "IIMacGyverII mod v3.0.2" (blue, underlined, clickable)
- 🌐 Tapping opens GitHub repository
- 📍 Appears below DMR Firmware Version
- 📱 Software Version also shows "DMRModHooks v3.0.2"

**Technical Details**:
- Dynamically injected at runtime (field doesn't exist in stock APK)
- Creates RelativeLayout with TextViews programmatically
- Inserts into existing layout hierarchy
- Survives ProGuard/R8 optimization

### 📋 Complete Feature List Since v1.7.0

All features from v1.0 through v1.7.0 are included, plus:

**v3.0.2 Additions**:
- ✅ Analog MON button with continuous monitoring
- ✅ MacGyver Mod branding in Information page
- ✅ GitHub repository link (clickable)
- ✅ Enhanced version display

**Previously Stable** (v1.0 - v1.7.0):
- ✅ OpenGD77 CSV export/import (all 5 files)
- ✅ Digital & analog channel import/export
- ✅ Location tracking (reverse geocoding)
- ✅ City/state display with channel info
- ✅ Elevation display via Open-Elevation API
- ✅ RSSI signal strength indicator
- ✅ DMR activity history with timestamps
- ✅ Contact integration (caller ID display)
- ✅ Per-channel transcription history
- ✅ User-friendly API key configuration
- ✅ Audio recording per channel
- ✅ Backup/restore from Download folder

### 🔧 Bug Fixes & Improvements

- 🐛 Fixed MON button initialization (always starts OFF)
- 🐛 Fixed database sync interfering with squelch changes
- 🐛 Fixed hardware message timing issues
- 🐛 Removed monitor field modifications (hardware rejection)
- 📝 Added comprehensive logging for debugging
- 🧹 Cleaned up excessive debug output for production

### ⏳ Known Limitations

**DMR Groups "All" Mode**:
- ⚠️ Reception issues when monitoring all talk groups
- 🔬 Under investigation (complex hardware protocol issue)
- 📅 Will be addressed in future v2.x release
- 💡 MON button will be re-enabled for DMR once fixed

**Workaround**: Use specific talk group IDs instead of "All" for now.

See [ANALOG_MON_FEATURE.md](ANALOG_MON_FEATURE.md) for complete technical details.

## Features Implemented

### ✅ Complete OpenGD77 CSV Backup/Restore System

**Export Features**:
- ✅ Export all 5 OpenGD77-compatible CSV files (Channels, Contacts, TG_Lists, Zones, DTMF)
- ✅ Export all 28 channel parameters
- ✅ Correct Digital/Analog channel type detection (numeric schema: 0=Digital, 1=Analog)
- ✅ Proper frequency conversion (MHz to Hz in database)
- ✅ Direct database access without shell commands

**Import Features**:
- ✅ Import all 16 channels from OpenGD77 CSV
- ✅ Automatic VHF/UHF band detection and allocation
- ✅ Digital vs Analog field differentiation
- ✅ Stock contacts preservation (prevents crashes)
- ✅ All 15 required database fields populated correctly
- ✅ Auto-refresh channel list after import
- ✅ Both Digital AND Analog channels activate successfully

**UI Enhancements**:
- ✅ Export/Import buttons directly in LOCAL tab
- ✅ Timestamped backup selection dialog for imports
- ✅ Toast notifications with version info and backup location

**File Location**:
- ✅ Backups saved to `Download/DMR/DMR_Backups/` for easy access
- ✅ No special permissions required (standard Download folder)
- ✅ Easy to transfer files via USB, file manager, or cloud sync
- ✅ Files visible in Files app and all file managers

## Upcoming Version 2 Features 🚀

**In Development - v1.3.x Series (February 2026)**

### Location Tracking & Display System

**LocationDatabase (Separate Storage)**:
- ✅ Dedicated SQLite database (`dmrmod_locations.db`) for channel locations
- ✅ Independent from app's main database to prevent conflicts
- ✅ Stores latitude/longitude per channel number
- ✅ Full CRUD operations (save, retrieve, delete, clear)

**Location Import/Export**:
- ✅ Extended CSV format with latitude/longitude columns
- ✅ Preserves location data through backup/restore cycles
- ✅ Compatible with OpenGD77 CSV format (additional columns)
- ✅ Defensive parsing skips default/invalid coordinates

**UI Enhancements (v1.3.x)**:
- ✅ **Borderbox Overlay**: 250dp semi-transparent gradient panel
- ✅ **PTT Button Repositioning**: Moved to bottom with spacer for better ergonomics
- ✅ **Channel Controls**: Repositioned with optimized spacing (5dp margins)
- ✅ **Info Text Spacing**: Reduced from 10dp to 5dp for compact layout

**Dynamic Location Display (v1.3.3+)**:
- ✅ Real-time location updates when switching channels
- ✅ Automatic refresh via `updateUI()` hook
- ✅ Shows 📍 icon for channels without location data
- ✅ Top-right corner display (white text, 12sp)

**Reverse Geocoding (v1.3.4)**:
- ✅ Human-readable location names instead of raw coordinates
- ✅ Display format: "City, State\n📍" (e.g., "Minneapolis, Minnesota")
- ✅ Fallback chain: City & State → City Only → Coordinates → Icon
- ✅ Comprehensive error handling for geocoding failures
- ✅ Uses Android Geocoder API with US locale

**Elevation Display (v1.3.5)**:
- ✅ Integrated Open-Elevation API (free, no API key required)
- ✅ Displays elevation in feet(meters) format: "859ft (262m)"
- ✅ Asynchronous loading: location name appears first, elevation updates after
- ✅ Worldwide coverage using SRTM dataset
- ✅ Background thread prevents UI blocking
- ✅ Graceful fallback if elevation unavailable
- ✅ Display format: "Minneapolis, Minnesota\n859ft (262m) 📍"
- ✅ Works with coordinates too: "44.9203, -93.2654\n859ft (262m) 📍"

**DMR Caller Identification & Activity History (v1.3.7-1.4.0)**:
- ✅ Real-time caller DMR ID detection during incoming transmissions
- ✅ Automatic contact name lookup from app's contact database
- ✅ Display in borderbox top-left corner with green text
- ✅ Format: "📞 Contact Name\nDMR ID: 64067" or "📞 DMR ID: 64067"
- ✅ Hooks ModuleStatusMessageHandler for RECEIVE_START/STOP events
- ✅ Decodes DMR ID from DigitalAudioMessage packets (offset 1, 2-byte LE)
- ✅ Asynchronous contact lookup prevents UI blocking
- ✅ Display automatically clears when transmission ends
- ✅ Works with multiple callers, tested and verified

**Activity History System (v1.3.8-1.4.0)**:
- ✅ Channel-specific activity tracking (top-right history box)
- ✅ Persistent history stored in SQLite database (`dmrmod_history.db`)
- ✅ Shows last 3 activities per channel (FIFO, newest first)
- ✅ Tracks: Voice TX/RX, SMS, Channel Busy, Low Battery, etc.
- ✅ Format: "[Contact/DMR ID] HH:mm:ss Activity" for digital channels
- ✅ Format: "HH:mm:ss Activity" for analog channels
- ✅ Contact names displayed in history (looks up from contact database)
- ✅ History persists across channel switches and app restarts
- ✅ Separate databases for each channel number
- ✅ Blue-bordered box with dynamic "DMR History" or "Analog History" header

**Analog/Digital Mode Separation (v1.3.9-1.4.0)**:
- ✅ Complete isolation between analog and digital channels
- ✅ Analog channels display: "📻 Receiving..." with optional RX tone
- ✅ Conditional tone display (CTCSS/DCS shown only if configured)
- ✅ DMR state automatically clears when switching to analog
- ✅ Three-layer protection prevents stale DMR IDs on analog channels
- ✅ Analog activities tracked without DMR IDs ("N/A" in database)
- ✅ Channel type detection via ChannelData.type (0=Digital, 1=Analog)

**Recording System (v1.4.7)**:
- ✅ Real-time audio recording of received transmissions (RX only)
- ✅ Recording toggle button right of PTT (⚪ = off, 🔴 = on)
- ✅ Channel-specific folders: `Download/DMR/Recordings/[ChannelName]/`
- ✅ Auto-start recording on RECEIVE_START, auto-stop on RECEIVE_STOP
- ✅ Immediate recording start if enabling toggle during active transmission
- ✅ PCM audio capture directly from AudioTrack pipeline (16kHz, 16-bit, mono)
- ✅ WAV format with proper headers (universally compatible)
- ✅ Filenames include timestamp and DMR ID/contact name
- ✅ Format: `yyyyMMdd_HHmmss_ContactName.wav` or `yyyyMMdd_HHmmss_DMRID.wav`
- ✅ Empty recording deletion (files <10KB automatically removed)
- ✅ Works for both DMR and Analog channels

**Signal Strength Display (v1.4.8-1.4.9)**:
- ✅ Real-time RSSI (Received Signal Strength Indicator) display
- ✅ Yellow-bordered box above main caller display
- ✅ Shows "Signal: X dBm" during reception, reserved space when idle
- ✅ RSSI values captured via SignalMessageHandler hook (reads Packet.body[0] directly)
- ✅ Conversion formula: dBm = -(120 - (raw_value / 2))
- ✅ Integrated into activity history with database persistence
- ✅ **RSSI Persistence (v1.4.9)**: Added `rssi_dbm INTEGER` column to database
- ✅ History format: "Name HH:mm:ss Activity X dBm" persists across channel changes
- ✅ Database migration: ALTER TABLE automatically adds column to existing databases
- ✅ RSSI box uses INVISIBLE (not GONE) to reserve space and prevent layout shifts
- ✅ Works for both DMR and analog channels
- ✅ Visual feedback: Bold 16sp yellow text on semi-transparent background

**UI Polish (v1.4.9)**:
- ✅ Channel info spacing completely removed (0dp dividers, margins, padding, line spacing)
- ✅ Divider drawable cleared to eliminate all visual gaps
- ✅ Minimum heights set to 0 for compact display
- ✅ Borderbox spacing optimized (8dp top margin for proper clearance)
- ✅ RSSI box margins reduced (4dp top, 0dp bottom, 4dp padding) for tight layout
- ✅ Recording button redesigned: Professional pill-shaped "REC" button
- ✅ Record button states: Red (enabled) / Gray (disabled) with white borders
- ✅ Record button size: 70dp × 40dp with bold white text

**Technical Architecture**:
- Singleton pattern for LocationDatabase access
- Helper methods for view hierarchy traversal
- Tag-based view identification (`DMR_LOCATION_TEXT`, `DMR_SPACER`, `DMR_BORDERBOX`, `DMR_RSSI_BOX`)
- Non-blocking UI updates with graceful fallbacks
- Direct PCM audio capture bypasses Android MediaRecorder limitations

**Stability Notes**:
- v1.2.9: Stable baseline without borderbox
- v1.3.1: Borderbox restored after device reboot (cached state cleared)
- v1.3.3: Dynamic updates fully functional
- v1.3.4: Geocoding integrated with fallback safety
- v1.3.5: Elevation display via Open-Elevation API, async loading, no API key required

**Upcoming Enhancements**:
- Location editing UI for manual coordinate entry
- GPS acquisition button for current position
- Map view integration for location selection
- Location-based features (nearby repeaters, range calculations)

## Technical Details

### Database Schema Discovery

**Channel Database**: `/data/user/0/com.pri.prizeinterphone/databases/database_channel_area_default_uhf.db`
**Contact Database**: `/data/user/0/com.pri.prizeinterphone/databases/contact_database.db`
**Location Database** *(v1.3.x+)*: `/data/user/0/com.pri.prizeinterphone/databases/dmrmod_locations.db`

**Critical Schema Findings**:
- Channel types: `0` = Digital (DMR), `1` = Analog (FM)
- Frequencies stored in Hz (multiply CSV MHz values by 1,000,000)
- Band field: `0` = UHF (400-512 MHz), `1` = VHF (136-174 MHz)
- Stock contact ID `1` must be preserved to prevent crashes

**LocationDatabase Schema** *(v1.3.x+)*:
- **Database**: `dmrmod_locations.db` (separate from app databases)
- **Table**: `channel_locations`
- **Columns**:
  - `channel_number` INTEGER PRIMARY KEY
  - `latitude` REAL
  - `longitude` REAL
- **Purpose**: Store location data independently to avoid conflicts with app's database structure
- **Access**: Singleton pattern via `LocationDatabase.getInstance(context)`
- **Methods**: `saveLocation()`, `getLocation()`, `deleteLocation()`, `clearAllLocations()`

### Required Database Fields (15 Total)

**Common Fields (same for Digital and Analog)**:
- `channel_power`, `channel_outBoundSlot`, `channel_mode`, `channel_contactType`
- `channel_relay = 1` (required for both types)
- `channel_sq`, `channel_rxType`, `channel_rxSubCode`, `channel_txType`, `channel_txSubCode`
- `channel_groups` (comma-separated zone assignments)

**Type-Specific Fields**:

| Field | Digital (type=0) | Analog (type=1) |
|-------|------------------|-----------------|
| `channel_encryptSw` | 1 | 0 |
| `channel_encryptKey` | "" (empty) | NULL |
| `channel_interrupt` | 2 | 0 |
| `channel_active` | 1 | 0 |

### Hooks Implemented

1. **InterPhoneHomeActivity.onCreate()**
   - Purpose: Display module version notification
   - Action: Shows toast message on app launch
   - Info: "✓ DMR Mod Hooks Active! v1.3.4"

2. **InterPhoneTalkBackFragment.initView(View)** *(v1.3.1+)*
   - Purpose: UI modifications and borderbox creation
   - Actions:
     - Repositions channel controls with 5dp top margin
     - Reduces info text spacing to 5dp
     - Creates 250dp borderbox with gradient drawable
     - Adds location TextView tagged "DMR_LOCATION_TEXT"
     - Inserts spacer view with weight=1.0
     - Repositions PTT button to bottom with proper margins
   - Touch handling: setClickable(false) and setFocusable(false) on borderbox

3. **InterPhoneTalkBackFragment.updateUI()** *(v1.3.3+)*
   - Purpose: Dynamic location display updates on channel change
   - Actions:
     - Finds location TextView via helper method
     - Queries LocationDatabase for current channel
     - Updates display with city/state name or coordinates (v1.3.4+)
     - Shows 📍 icon if no location data exists
   - Triggers: Automatically called when user switches channels

4. **InterPhoneLocalFragment.initView()**
   - Purpose: Add "Backup/Restore" button to LOCAL tab
   - Action: Injects button into fragment layout
   - Opens: BackupActivity

5. **DirectDatabaseExporter (Direct Access)**
   - Bypasses shell commands
   - Reads channel/contact databases directly
   - Exports 5 OpenGD77 CSV files to `Download/DMR/DMR_Backups/`
   - Includes latitude/longitude columns (v1.3.x+)

6. **DirectDatabaseImporter (Direct Access)**
   - Parses OpenGD77 CSV format
   - Populates all 15 required fields
   - Differentiates Digital vs Analog field values
   - Imports latitude/longitude data to LocationDatabase (v1.3.x+)
   - Triggers auto-refresh via DmrManager reflection

7. **ModuleStatusMessageHandler.onMessage()** *(v1.3.7+)*
   - Purpose: Detect RECEIVE_START and RECEIVE_STOP events
   - Actions:
     - Captures currentChannelType (0=Digital, 1=Analog)
     - Triggers queryCallerInfo() for digital channels
     - Clears caller display on RECEIVE_STOP
     - Updates activity history with timestamps
   - Events: Case 1/10 (RX START), Case 2/11 (RX STOP)

8. **DigitalAudioMessageHandler.onMessage()** *(v1.3.7+)*
   - Purpose: Extract DMR caller ID from digital audio packets
   - Actions:
     - Decodes DMR ID from byte offset 1 (2-byte little-endian)
     - Looks up contact name from contact_database.db
     - Updates caller display with contact name or DMR ID
     - Saves activity history entry with DMR ID
   - Format: "📞 Contact Name\nDMR ID: 64067"

9. **PCMReceiveManager.writeAudioTrack()** *(v1.4.7+)*
   - Purpose: Capture raw PCM audio data from RX audio pipeline
   - Actions:
     - Intercepts byte[] audio data before playback
     - Writes to FileOutputStream when recording enabled
     - Tracks byte count for WAV header generation
     - Sample rate: 16kHz, 16-bit, mono
   - Usage: Bypasses Android MediaRecorder for direct audio capture

10. **SignalMessageHandler.decode()** *(v1.4.8+)*
    - Purpose: Capture RSSI (Received Signal Strength Indicator) values
    - Actions:
      - Extracts rssi field (byte) from SignalMessage objects
      - Updates currentRssi variable for display
      - Triggers RSSI display update during reception
    - Protocol: Command 0x32 (QUERY_SIGNAL_STRENGTH_CMD)
    - Units: dBm (negative values, e.g., -85 dBm)

### Helper Methods (v1.3.3+)

- **findLocationTextView(ViewGroup)**: Recursively searches view hierarchy for TextView tagged "DMR_LOCATION_TEXT"
- **updateLocationDisplay(fragment, TextView, Context)**: 
  - Retrieves current channel number
  - Queries LocationDatabase for coordinates
  - Performs reverse geocoding to get city/state names (v1.3.4+)
  - Updates TextView with formatted location display
  - Handles all error cases with graceful fallbacks

### Why LSPosed?
The PriInterPhone app requires Ulefone's platform certificate to access custom `PrizeTinyService` APIs. Traditional APK modification approaches fail because:
- Re-signing breaks platform signature verification
- System app placement alone doesn't grant platform UID
- Ulefone's custom framework requires specific signature

LSPosed hooks the **original properly-signed app** at runtime, allowing modifications while preserving signature and permissions.

## Installation

```bash
cd DMRModHooks
.\gradlew.bat assembleDebug
```

Output: `app/build/outputs/apk/debug/app-debug.apk`

## Installation from Scratch

### Prerequisites
- Ulefone Armor 26 Ultra (or compatible device)
- Unlocked bootloader
- Magisk installed and working
- ADB access enabled on device
- Basic understanding of Android modding

### Step 1: Install Magisk (if not already installed)
1. Unlock your device's bootloader (manufacturer-specific)
2. Download Magisk APK from official GitHub: https://github.com/topjohnwu/Magisk
3. Install and grant root access
4. Verify Magisk is working: `adb shell su -c "id"`

### Step 2: Enable Zygisk
1. Open Magisk Manager app
2. Navigate to Settings
3. Enable "Zygisk" option
4. Reboot device
5. Verify Zygisk is running: `adb shell "ps -A | grep zygisk"`

### Step 3: Install LSPosed Framework
1. Download LSPosed v1.9.2+ (Zygisk variant):
   - GitHub: https://github.com/LSPosed/LSPosed/releases
   - Get: `LSPosed-v1.9.2-7024-zygisk-release.zip` (or latest)
   
2. Push to device:
   ```bash
   adb push LSPosed-v1.9.2-7024-zygisk-release.zip /sdcard/Download/
   ```

3. Install via Magisk:
   ```bash
   adb shell su -c "magisk --install-module /sdcard/Download/LSPosed-v1.9.2-7024-zygisk-release.zip"
   ```

4. Reboot device:
   ```bash
   adb reboot
   ```

5. Wait for boot (may take 60+ seconds on first LSPosed boot)

6. Install LSPosed Manager app (will appear automatically after reboot)
   - Package: `org.lsposed.manager`
   - Icon should appear in app drawer

7. Verify LSPosed is active:
   ```bash
   adb shell "ps -A | grep lsposed"
   # Should show lsposed daemon running
   ```

### Step 4: Install DMRModHooks Module

#### Option A: Download Pre-built Release
1. Go to [Releases](../../releases)
2. Download latest `DMRModHooks-vX.X.apk`
3. Install:
   ```bash
   adb install DMRModHooks-v0.3.apk
   ```

#### Option B: Build from Source
1. Clone this repository:
   ```bash
   git clone https://github.com/IIMacGyverII/phonedmrapp.git
   cd phonedmrapp/DMRModHooks
   ```

2. Build the module:
   ```bash
   # Windows:
   .\gradlew.bat assembleDebug
   
   # Linux/Mac:
   ./gradlew assembleDebug
   ```

3. Install:
   ```bash
   adb install app/build/outputs/apk/debug/app-debug.apk
   ```

### Step 5: Enable Module in LSPosed Manager
1. Open LSPosed Manager app on device
2. Navigate to "Modules" tab
3. Find "DMR Mod Hooks" in the list
4. **Enable the checkbox** next to it
5. Tap on "DMR Mod Hooks" to open module settings
6. Verify "Application scope" shows: `com.pri.prizeinterphone`
7. If not, go to "Application list" and select "PriInterPhone"

### Step 6: Reboot and Test
1. Reboot device:
   ```bash
   adb reboot
   ```

2. After boot, open PriInterPhone app

3. **Navigate to LOCAL tab** - You should see: "Backup/Restore" button

4. **Test Export**: Tap 📤 EXPORT (OpenGD77) button in LOCAL tab
   - Check `Download/DMR/DMR_Backups/` for timestamped folder
   - Should see folder like: `20260223_140530/` containing CSV files

5. **Verify version**: Toast notification shows "✓ DMR Mod Hooks Active! v1.3.5"

### Troubleshooting

**No "Backup/Restore" button in LOCAL tab:**
- Check LSPosed Manager → Modules → verify DMR Mod Hooks is checked
- Check LSPosed Manager → Logs for errors
- Verify module scope includes `com.pri.prizeinterphone`
- Monitor logs: `adb logcat | grep DMRModHooks`
- Try reboot again

**LSPosed Manager not appearing:**
- Check Magisk modules list shows LSPosed enabled
- Reboot again (first boot can take time)
- Check logs: `adb logcat | grep -i lsposed`

**Module not showing in LSPosed Manager:**
- Reinstall module: `adb install -r DMRModHooks-vX.X.apk`
- Check it's installed: `adb shell pm list packages | grep dmrmod`
- Check LSPosed Manager → Modules tab for new modules

**Hooks not working:**
- Monitor logs: `adb logcat | grep DMRModHooks`
- Check for errors in LSPosed Manager → Logs
- Verify PriInterPhone app is the original system app, not a modified version
- Reboot and try again

## Building

```bash
cd DMRModHooks
.\gradlew.bat assembleDebug
```

Output: `app/build/outputs/apk/debug/app-debug.apk`

## Installation

1. **Install LSPosed** (if not already installed):
   - Download LSPosed v1.9.2+ (Zygisk variant)
   - Install via Magisk
   - Enable Zygisk in Magisk settings
   - Reboot

2. **Install Module**:
   ```bash
   adb install -r app/build/outputs/apk/debug/app-debug.apk
   ```

3. **Enable in LSPosed Manager**:
   - Open LSPosed Manager
   - Go to Modules tab
   - Enable "DMR Mod Hooks"
   - Verify scope: com.pri.prizeinterphone
   - Reboot device

4. **Test**:
   - Open PriInterPhone app → LOCAL tab
   - Should see "Backup/Restore" button
   - Test export: Tap Backup/Restore → Export to OpenGD77 CSV

## Development

### Project Structure
```
DMRModHooks/
├── app/
│   ├── build.gradle           # Android app config
│   └── src/main/
│       ├── AndroidManifest.xml    # LSPosed metadata
│       ├── assets/
│       │   └── xposed_init        # com.dmrmod.hooks.MainHook
│       ├── java/com/dmrmod/hooks/
│       │   ├── MainHook.java               # Main hook implementation
│       │   ├── LocationDatabase.java       # Location storage (v1.3.x+)
│       │   ├── DirectDatabaseExporter.java # CSV export with location data
│       │   └── DirectDatabaseImporter.java # CSV import with location data
│       └── res/values/
│           └── strings.xml        # Module name, scope
├── build.gradle               # Project config
├── settings.gradle            # Repositories (JitPack, Xposed API)
└── gradle.properties
```

### Adding New Hooks

1. Edit `MainHook.java`
2. Add hook method in `handleLoadPackage()`
3. Use `XposedHelpers.findAndHookMethod()` or `findClass()` + hook
4. Build and install with `-r` flag
5. Reboot device to activate

### Debugging

Monitor Xposed logs:
```bash
adb logcat | Select-String "DMRModHooks"
```

Or use LSPosed Manager → Logs

## Changelog

### v1.3.7 (Feb 26, 2026) ✅ **CURRENT**
- **Added DMR caller identification with real-time contact display**
- Displays incoming caller information in borderbox (top-left corner, green text)
- Hooked ModuleStatusMessageHandler to detect RECEIVE_START/STOP events
- Hooked DigitalAudioMessageHandler to decode caller DMR ID from radio module packets
- DMR ID extraction: offset 1, 2-byte little-endian from Digital Audio packet body
- Automatic contact name lookup from contact_database table
- Display format: "📞 Contact Name\nDMR ID: 12345" when contact found
- Falls back to "📞 DMR ID: 12345" when DMR ID not in contacts
- Display automatically clears when transmission ends (RECEIVE_STOP)
- Comprehensive packet analysis logging for debugging and verification
- Tested with multiple DMR IDs - working correctly with contact resolution

### v1.3.6 (Feb 26, 2026)
- **Fixed duplicate contacts in CSV export**
- Added HashSet deduplication in exportContactsDirect() to prevent duplicate entries
- Tracks unique contact rows to ensure each contact exported only once
- Export logs now show unique contact count and duplicates skipped
- Fixes issue where contacts were exported multiple times (e.g., 2 unique contacts repeated 48 times = 96 total)
- CSV export now produces minimal, clean files for OpenGD77 CPS
- File size reduction example: 2.15KB (96 duplicate contacts) → 82 bytes (2 unique contacts)
- Critical fix for data quality when importing to OpenGD77 CPS

### v1.3.5 (Feb 26, 2026)
- **Added elevation display using Open-Elevation API**
- Integrated free elevation service (no API key or account required)
- Display format: feet(meters) - "859ft (262m)"
- Asynchronous loading: city/state appears immediately, elevation updates after
- Elevation data from https://api.open-elevation.com (worldwide SRTM coverage)
- Added INTERNET and ACCESS_NETWORK_STATE permissions
- Background thread implementation prevents UI blocking
- Comprehensive error handling with graceful fallbacks
- Works with both geocoded names and raw coordinates
- CSV format remains at 28 columns for OpenGD77 compatibility

### v1.3.4 (Feb 26, 2026)
- **Added reverse geocoding for city/state display**
- Implemented Android Geocoder API to show human-readable location names
- Display format: "City, State" instead of raw coordinates (e.g., "Minneapolis, Minnesota")
- Comprehensive fallback chain: City & State → City Only → Coordinates → Icon
- Error handling for geocoding unavailable or failed lookups
- No external network dependencies (uses Android's built-in geocoding)
- Tested with Minnesota test data showing proper city/state names

### v1.3.3 (Feb 26, 2026)
- **Dynamic location display with channel updates**
- Added hook to `updateUI()` method for automatic location refresh
- Helper method `findLocationTextView()` searches view hierarchy for tagged TextView
- Helper method `updateLocationDisplay()` queries LocationDatabase and updates display
- Location now updates automatically when switching channels
- Shows 📍 icon for channels without location data
- Fully tested with channels 1-10 (Minnesota coordinates) updating correctly

### v1.3.2 (Feb 26, 2026)
- **Added location display to borderbox**
- TextView with "DMR_LOCATION_TEXT" tag in top-right corner
- Shows coordinates format: "44.9203, -90.6806\n📍"
- Queries LocationDatabase for current channel
- Initial implementation (static display, fixed in v1.3.3)

### v1.3.1 (Feb 26, 2026)
- **Stable baseline with borderbox and PTT repositioning**
- Added 250dp FrameLayout borderbox with gradient drawable
- Border: 2dp semi-transparent white stroke, 12dp corner radius
- Gradient background: 0x15FFFFFF (top) to 0x08FFFFFF (bottom)
- Spacer view with weight=1.0 to push PTT button to bottom
- PTT button repositioned with 10dp margins and proper gravity
- setClickable(false) and setFocusable(false) on borderbox to pass touch events
- Discovered: System reboot cleared cached state that was causing freezes in v1.2.8
- All UI features stable and functional

### v1.2.9 (Feb 25, 2026)
- **Established stable baseline without borderbox**
- Removed borderbox due to system freeze issues
- Channel controls repositioning with 5dp top margin
- Info text spacing reduced to 5dp with repositioning
- LocationDatabase architecture implemented
- Import/export with latitude/longitude preservation working
- Clean baseline for incremental feature addition

### v1.1 (Feb 24, 2026)
- **Import now supports any folder name**
- Removed timestamp-only restriction for backup folders
- Import dialog now lists ALL folders in DMR/DMR_Backups/ containing Channels.csv
- Folders with timestamp format still display as formatted dates for convenience
- Allows custom folder names like "MyBackup", "Test", "Working_Config", etc.
- Smart sorting: timestamp folders sorted newest first, others alphabetically

### v1.0 (Feb 24, 2026)
- **First stable release**
- Complete OpenGD77 CSV export/import functionality
- Power level conversion: Low → P1, High → P9
- Squelch percentage conversion for analog channels
- Full support for Digital and Analog channels
- PDF backup summaries with detailed channel information
- Automatic zip archive creation
- Removed development branding

### v0.9.41 (Feb 24, 2026)
- **Changed high power export to P9 instead of +W-**
- Export: Low power (0) → P1, High power (1) → P9
- Import: Still accepts full P1-P9, +W-, -W+ range with proper mapping
  - P1-P4 → Low power (0)
  - P5-P9, +W-, -W+ → High power (1)

### v0.9.40 (Feb 24, 2026)
- **Added OpenGD77 power level format conversion**
- Export: Converts app's power levels to OpenGD77 P1-P9 and +W- format
  - Low power (0) → P1 (lowest OpenGD77 power level)
  - High power (1) → +W- (maximum OpenGD77 power level)
- Import: Converts OpenGD77 power levels to app format with proper range mapping
  - P1-P4 → Low power (0)
  - P5-P9, +W-, -W+ → High power (1)
- Handles legacy Low/Master/High format for backwards compatibility
- Fixes power level import from OpenGD77-edited CSV files
- Logged conversion for debugging ("Converted power P1 to level 0")

### v0.9.39 (Feb 24, 2026)
- **Added squelch percentage conversion for OpenGD77 compatibility**
- Export: Converts app's 0-9 squelch values to OpenGD77 percentages (0=Disabled, 1=5%, 2=15%, 3=25%...9=85%)
- Import: Converts OpenGD77 percentages to app's 0-9 range with proper rounding
- Mapping: 0-10%→1, 11-20%→2, 21-30%→3, etc. up to 81-95%→9
- Handles "Disabled" keyword and % symbol in CSV files
- Fixes OpenGD77 round-trip editing - squelch values now preserved correctly
- Logged conversion for debugging ("Converted squelch 15% to level 2")

### v0.9.38 (Feb 24, 2026)
- **Updated OpenGD77 download links to working URLs**
- Primary link: https://www.opengd77.com/downloads/PC_CPS/Latest/OpenGD77CPSInstaller_R2025.03.23.01.exe
- Alternative link: GitHub-hosted backup in repository
- PDF now shows both download options for redundancy
- Fixed LibreDMR releases link issue (repository was empty)
- Users can download from official site or GitHub backup

### v0.9.37 (Feb 24, 2026)
- **Added OpenGD77 CPS installer to repository for easy access**
- Included OpenGD77CPSInstaller_R2025.03.23.01.exe (Windows version)
- Updated PDF download link to point directly to installer in GitHub repository
- No more broken links - installer hosted alongside the module for convenience
- PDF now shows: https://github.com/IIMacGyverII/phonedmrapp/raw/main/OpenGD77CPSInstaller_R2025.03.23.01.exe
- Alternative link to LibreDMR releases mentioned for latest versions and other platforms
- Makes it easier for users to get started without searching for the software

### v0.9.36 (Feb 23, 2026)
- **Added automatic zip archive creation for easy backup transfer**
- Each backup now includes a DMR_Backup_[timestamp].zip file containing all CSV files and PDF
- Zip file created automatically alongside individual files in the backup folder
- Makes it easy to transfer entire backup via USB, email, or cloud storage
- Updated PDF instructions to mention zip file as recommended transfer method
- Zip includes: Channels.csv, Contacts.csv, TG_Lists.csv, Zones.csv, DTMF.csv, Backup_Summary.pdf
- Individual files still available for users who prefer direct access
- Note: OpenGD77 CSV import functionality still needs testing in OpenGD77 CPS software

### v0.9.35 (Feb 23, 2026)
- **Fixed PDF channel display bug - all 16 channels now render correctly**
- Fixed database column name: `channel_cc` (not `channel_colorCode`)
- PDF now displays all channels with complete details: frequencies, tones, contacts, color codes, timeslots, squelch, power
- Verified export/import workflow generates complete documentation

### v0.9.34 (Feb 23, 2026)
- Fixed contact database column name in PDF export: `_id` (not `contact_id`)
- Improved error handling in PDF generation
- Still showed only 1 channel due to additional column name issue

### v0.9.33 (Feb 23, 2026)
- Added missing ToneConverter import to PDFExporter
- Fixed PDF page lifecycle crash from v0.9.32
- Still showed only 1 channel due to database column name mismatches

### v0.9.32 (Feb 23, 2026)
- **Enhanced PDF with comprehensive channel details**
- Added 8-column channel table: #, Name, Type, RX→TX Freq, Contact/Tones, CC/TS, SQ, P
- Digital channels show contact names, color codes, and timeslots
- Analog channels show CTCSS/DCS tones (e.g., 114.8/156.7 Hz)
- All channel parameters now visible in PDF for easy review
- Fixed page lifecycle management in PDF generation
- Initial version showed only 1 channel due to database column errors

### v0.9.31 (Feb 23, 2026)
- **Implemented comprehensive PDF backup summary**
- Each backup now includes a detailed PDF report (Backup_Summary.pdf)
- PDF contains complete channel listing with frequencies, types, and power settings
- PDF contains contact database summary with DMR IDs and types
- Includes OpenGD77 CPS download link: https://github.com/LibreDMR/OpenGD77/releases
- Step-by-step instructions for importing/exporting with OpenGD77 CPS
- Round-trip workflow documentation (Phone → PC → OpenGD77 → Phone)
- Important notes about backup safety and CTCSS/DCS support
- Automatically generated on every export - no manual steps required
- Professional multi-page PDF with proper formatting and navigation
- Makes it easy to review channel programming without opening CSV files

### v0.9.30 (Feb 23, 2026)
- **Implemented contact name lookup for Digital channels**
- Export: Reads actual contact names from contact database instead of hardcoding "None"
- Import: Resolves contact names to database IDs for proper channel-contact linking
- Digital channels now show correct contact names in CSV exports (e.g., "test 1" instead of "None")
- Analog channels correctly show empty contact field (not applicable)
- Full round-trip support: Export → Edit contacts in OpenGD77 CPS → Import → Contacts preserved
- Added buildContactMap() and getContactName() helper methods
- Better OpenGD77 compatibility for DMR channel programming

### v0.9.29 (Feb 23, 2026)
- **Implemented CTCSS and DCS tone support for analog channels**
- Export: Reads `channel_rxType/rxSubCode` and `channel_txType/txSubCode` from database
- Import: Parses RX Tone and TX Tone from CSV columns 13-14
- Tone format translation:
  - CTCSS: Database "67.0Hz" ↔ CSV "67.0" (51 standard tones)
  - DCS Forward: Database "023N" ↔ CSV "D023N" (83 codes, Normal polarity)
  - DCS Backward: Database "023l" ↔ CSV "D023I" (83 codes, Inverted polarity)
- Full round-trip support: Export → Edit CTCSS/DCS in OpenGD77 CPS → Import → Tones preserved
- Created ToneConverter.java utility class for bidirectional translation
- Previously hardcoded as "None", now exports/imports actual tone settings

### v0.9.28 (Feb 23, 2026)
- **Implemented proper Squelch field support**
- Export: Reads actual `channel_sq` value from database (0-9)
- Import: Parses squelch from CSV column 15 and writes to database
- Previously hardcoded as blank/"Disabled", now preserves actual radio settings
- Improved Power field parsing - reads from CSV and writes correct values
- Better OpenGD77 CSV compatibility for round-trip editing
- Note: TOT (Timeout Timer) remains hardcoded as database doesn't store it

### v0.9.27 (Feb 23, 2026)
- **New folder-based backup structure**
- Each backup creates a timestamped folder (e.g., `20260223_140530/`)
- CSV files inside folders have simple names (Channels.csv, Contacts.csv, etc.)
- Easier to manage - each backup is self-contained
- Import dialog lists available backup folders
- Better organization for multiple backups

### v0.9.26 (Feb 23, 2026)
- **COMPLETE OpenGD77 CSV Import/Export Functionality**
- Changed backup location to `Download/DMR/DMR_Backups/` for easy user access
- Fixed Analog/Digital field differentiation (critical fix!)
- Digital channels: encryptSw=1, interrupt=2, active=1
- Analog channels: encryptSw=0, interrupt=0, active=0
- Both channel types import and activate successfully
- All channels working with proper field values
- Comprehensive code documentation added
- Toast notifications show correct backup path

### v0.9.25 (Feb 2026)
- Implemented 15 required database fields from diagnostic export
- Fixed Digital channel activation
- Analog channels still needed type-specific values

### v0.9.24 (Feb 2026)
- Added comprehensive diagnostic field export
- Discovered 15 missing required fields through edit+save comparison

### v0.9.23 (Feb 2026)
- Fixed Contact ID 1 preservation (prevents crashes)
- Improved contact database handling

### v0.9.20-v0.9.22 (Feb 2026)
- Discovered numeric channel type schema (0=Digital, 1=Analog)
- Fixed channel type detection from CSV

### v0.9.17-v0.9.19 (Feb 2026)
- Implemented DMR/Analog type handling
- Added conditional Contact ID assignment

### v0.9.14-v0.9.16 (Feb 2026)
- Fixed channel activation crashes (NullPointerException)
- Discovered Contact field requirement

### v0.9.12-v0.9.13 (Feb 2026)
- Added auto-refresh feature via DmrManager reflection
- Channel list updates automatically after import

### v0.9.0-v0.9.11 (Feb 2026)
- Full OpenGD77 CSV import implementation
- Band field discovery and frequency-based detection
- All 16 channels importing correctly

### v0.8.7 (Feb 2026)
- Export functionality complete - all 5 CSV files working
- Channels.csv (28 parameters), Contacts.csv, TG_Lists.csv, Zones.csv, DTMF.csv

### v0.3 (Feb 18, 2026)
- Module version display working
- Field discovery for runtime introspection

### v0.2 (Feb 18, 2026)
- FragmentLocalInformationActivity hooks

### v0.1 (Feb 18, 2026)
- Initial test module
- Startup toast verification

## Project Status

**✅ COMPLETE**: Full OpenGD77 CSV export/import functionality working
- All 5 CSV files export correctly
- All 16 channels import correctly
- Both Digital and Analog channels activate successfully
- Auto-refresh working
- Stock contacts preserved

## References

- LSPosed Framework: https://github.com/LSPosed/LSPosed
- Xposed API Docs: https://api.xposed.info/
- Original App: Ulefone PriInterPhone (system app)

---

## Development History

This project went through extensive trial and error before arriving at the LSPosed solution. This section documents the journey for educational purposes and to help others avoid the same pitfalls.

### The Challenge

The Ulefone PriInterPhone DMR app (`com.pri.prizeinterphone`) is a **platform-signed system app** that uses Ulefone's custom Android framework APIs, specifically `PrizeTinyService`. This presents unique challenges:

1. **Platform Certificate Requirement**: The app requires Ulefone's platform signing certificate to access system APIs
2. **Custom Framework API**: `PrizeTinyService` is not part of standard Android - it's Ulefone-specific
3. **System UID Requirement**: Only apps with `android.uid.system` can access PrizeTinyService
4. **Signature Verification**: The app is signed with the platform key and verified at runtime

### Failed Approaches (February 17-18, 2026)

#### Attempt 1: APKTool Decompile & Rebuild
**Goal**: Decompile APK, modify resources, rebuild and reinstall

**Process**:
- Used APKTool 2.9.3 to decompile original APK
- Modified XML layouts and resources
- Rebuilt with APKTool
- Re-signed with test key

**Result**: ❌ **BOOTLOOP**
- APKTool rebuild introduced incompatibilities
- Re-signing with test key broke system app signature verification
- Device stuck in boot loop (recovered by removing Magisk modules)

**Lesson**: APKTool rebuilds can corrupt system apps, and re-signing breaks platform certificate chain

---

#### Attempt 2: JADX Decompile + Gradle Rebuild
**Goal**: Decompile to Java source, fix compilation errors, rebuild as standalone APK

**Process**:
- Used JADX v1.5.0 to decompile 3,007 Java files
- Fixed 56 compilation errors:
  - Created stub classes for Android internal APIs
  - Fixed decompilation artifacts
  - Added missing resources
- Successfully built `MacGyverMod-JADX-Fixed.apk` (7.6 MB)
- Changed package name to `com.pri.prizeinterphone.modded`

**Result**: ❌ **NoSuchMethodError: PrizeTinyService**
```
java.lang.NoSuchMethodError: No virtual method openRecvPcm()V 
in class Landroid/os/PrizeTinyService
```
- App installed and launched
- Crashed when trying to access DMR radio functions
- `PrizeTinyService` not accessible to apps without platform certificate

**Lesson**: Successfully rebuilding the APK doesn't grant access to platform-signed APIs

---

#### Attempt 3: Magisk Module Systemization (TeMeFI)
**Goal**: Replace system app via Magisk overlay

**Attempts Made**:
- `MacGyverTest-Module.zip` - Wrong path (`/system/priv-app/InterPhone/`)
- `MacGyverTest-FIXED.zip` - Correct path (`/system/priv-app/PriInterPhone/`)
- `MacGyverMod-Safe.zip` - module.prop typo (id: `macgyver_dmr_saffe`)
- `MacGyverMod-UNIX.zip` - Windows path separators in update-binary
- `MacGyverMod-FINAL.zip` - All fixes applied

**Process**:
1. Created Magisk module structure
2. Placed modified APK in `/system/priv-app/PriInterPhone/PriInterPhone.apk`
3. Installed via Magisk Manager
4. Rebooted

**Result**: ❌ **App runs but UID mismatch**
- Module installed successfully
- App appeared in `/system/priv-app/` correctly
- App launched but had UID 10199 (user app) instead of 1000 (system)
- Could not access PrizeTinyService (requires system UID)
- Same `NoSuchMethodError` crash on radio access

**Diagnosis**:
```bash
adb shell "ps -A | grep prizeinterphone"
# u0_a199   28341  1369  ... com.pri.prizeinterphone.modded
```
- UID `u0_a199` = user app (10199)
- Should be `system` = system app (1000)

**Why It Failed**: 
- Physical location in `/system/` doesn't grant system UID
- System UID is granted based on **signature matching platform certificate**
- Modified APK was re-signed with test key, not platform key
- Package manager assigned user UID, not system UID

**Lesson**: Systemization requires BOTH location AND platform signature

---

#### Attempt 4: App Systemizer Tool
**Goal**: Use third-party tool to properly systemize app

**Tools Tested**:
- App Systemizer v14.0.0 (XDA version)
- App Systemizer v14.0.0 (UNIX fork)

**Result**: ❌ **Same UID issue**
- Tool successfully moved app to `/system/priv-app/`
- Fixed permissions correctly
- But can't fix signature/UID issue
- Still assigned user UID instead of system UID

**Lesson**: No tool can grant platform UID without platform certificate

---

#### Attempt 5: Signature Spoofing Research
**Goal**: Investigate ways to bypass signature verification

**Approaches Considered**:
1. **microG signature spoofing**: Only works for GMS apps, not system framework
2. **Lucky Patcher**: Can't patch framework-level signature checks
3. **Platform certificate extraction**: Not possible - private key secured by manufacturer

**Result**: ❌ **No viable solution**
- Platform certificate private key is proprietary to Ulefone
- No way to sign APKs with platform certificate without manufacturer cooperation
- Signature spoofing doesn't work for framework-level APIs

**Lesson**: Platform certificate is the gatekeeper and can't be bypassed

---

### The Solution: LSPosed Runtime Hooks ✅

**Why It Works**:

LSPosed hooks the **ORIGINAL properly-signed system app** at runtime:
- ✅ Original app has platform certificate
- ✅ Original app has system UID (1000)  
- ✅ Original app can access PrizeTinyService
- ✅ LSPosed hooks run in the app's process with full permissions
- ✅ No APK modification or re-signing needed
- ✅ Signature verification passes (original APK untouched)

**How It Works**:

1. Original `PriInterPhone.apk` remains untouched in `/system/priv-app/`
2. LSPosed framework (Magisk module) starts with Zygisk
3. When PriInterPhone app launches, LSPosed intercepts class loading
4. Our module hooks methods via Xposed API
5. Hooks run in app's process context with system UID
6. Full access to PrizeTinyService and all platform APIs
7. Can modify behavior, UI, and functionality at runtime

**Timeline**:
- **Day 1 (Feb 17)**: Failed attempts with APKTool, JADX, systemization
- **Day 2 (Feb 18 morning)**: Discovered platform certificate requirement
- **Day 2 (Feb 18 afternoon)**: Installed LSPosed v1.9.2
- **Day 2 (Feb 18 evening)**: First successful hook (toast message)
- **Day 2 (Feb 18 night)**: First UI modification (module version display) - **SUCCESS!**

### Key Insights

1. **System Apps ≠ System UID**: Location in `/system/` doesn't grant privileges
2. **Platform Certificate is King**: Only manufacturer's signing key grants system UID
3. **Custom Framework APIs**: Ulefone's `PrizeTinyService` requires platform signature
4. **Runtime Hooks Win**: Modifying the running process > modifying the APK
5. **LSPosed is Powerful**: Can do comprehensive rewrites, not just small tweaks

### What We Learned

**About Android Security**:
- Signature verification happens at multiple levels (install, runtime, API access)
- SELinux policies check UID for system resource access
- Custom OEM frameworks add extra security layers
- Package manager assigns UID based on signature, not location

**About Development**:
- Start with least invasive approach (runtime hooks)
- Understanding the *why* of failures leads to better solutions
- Document everything - failed attempts teach as much as successes
- Root cause analysis is critical (UID mismatch was the real issue)

**About LSPosed**:
- More powerful than expected - can rewrite entire apps
- Field introspection for runtime discovery is essential
- Logging is critical for debugging hooks
- Proper scoping ensures hooks only run on target app

### For Future Developers

If you're trying to modify a system app:

1. **Check UID first**: `ps -A | grep <package>` - if not `system` or `radio`, you need platform certificate
2. **Identify custom APIs**: `logcat` errors about missing classes/methods indicate OEM frameworks
3. **Try LSPosed first**: Don't spend days on APK modification if signature is required
4. **Use field discovery**: Don't trust decompiled source - verify at runtime
5. **Log extensively**: Xposed logs are your friend for debugging

**Bottom Line**: We spent 1.5 days fighting signature verification before realizing runtime hooks were the answer. This documentation exists so you don't make the same mistakes!

---

## License

This project is licensed under the **GNU General Public License v3.0** - see the [LICENSE](LICENSE) file for details.

> **Disclaimer**: This tool hooks into the PriInterPhone app at runtime using LSPosed/Xposed. It does NOT modify or redistribute any proprietary code from Ulefone. Users must legally own the PriInterPhone app. For personal, educational, and interoperability purposes only.
