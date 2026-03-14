# PriInterPhone DMR Radio - LSPosed Mod with OpenGD77 Integration + Advanced Features

**Status**: ✅ **FULLY FUNCTIONAL** - Export/Import + GPS Navigation + Zone Management + Transcription + APRS!

> **📦 Current Stable Release: v3.1.4** (March 13, 2026) - Software Squelch State Fix  
> **🎨 Previous Release: v3.1.3** (March 13, 2026) - Software Squelch UI Enhancements  
> **🔧 Stable Release: v3.1.2** (March 13, 2026) - APRS Channel Recovery + Squelch Control  
> **📡 Major Feature: v3.1.0** (March 12, 2026) - APRS Live Monitoring  
> **🌐 GPS Enhancement: v3.0.9** (March 9, 2026) - GPS Distance Enhancements  
> **🎯 Zone Management: v3.0.8** (March 9, 2026) - Zone Management  
> **📍 Feature Release: v3.0.5** (March 9, 2026) - Channel Zones  
> **🎙️ Stable Base: v1.7.0** (February 2026) - Transcription & API Features

## Demo

<video src="https://github.com/user-attachments/assets/d6305a49-c8ed-47dc-a9d8-7e731aa02811" controls title="DMRModHooks v1.1 Demo" width="800"></video>

## 🐛 What's New in v3.1.4 (March 13, 2026)

### Critical Software Squelch State Fix

**Fixed bug where software squelch remained active after stopping APRS monitoring**

#### **Bug Fixed**
- **🔧 Squelch State Clearing**: Software squelch flags now properly cleared when exiting APRS mode
  - Previously: `isSoftwareSquelchEnabled` and `isAprsSoftwareSquelchEnabled` stayed `true` after stopping APRS
  - Result: Audio remained blocked even though UI showed Soft SQ as OFF
  - Impact: Users couldn't hear audio on intercom after using APRS with Soft SQ enabled
- **✅ Proper State Reset**: Both flags explicitly set to `false` in `stopAPRSMonitoring()`
  - Ensures audio processing allows playback when returning to intercom
  - UI state now matches internal flag state
  - No more "ghost squelch" blocking audio

#### **User Impact**
- **Before**: Enable Soft SQ in APRS → Stop APRS → Return to intercom with no audio
- **After**: Squelch properly disabled when exiting APRS, audio works immediately
- **Reliability**: State flags and UI now stay synchronized across mode transitions

---

## 🎨 What's New in v3.1.3 (March 13, 2026)

### Software Squelch UI Enhancements & APRS Toggle

**Complete UI overhaul for software squelch control + APRS monitoring improvements**

#### **Intercom Page Enhancements**
- **✨ Soft SQ Toggle Button**: Control software squelch on/off
  - Light blue when OFF (hardware squelch mode)
  - Blue when ON (software squelch enabled)
  - Shows/hides slider based on toggle state
  - OFF: Hardware squelch set to 2 (default)
  - ON: Hardware squelch set to 0, software takes over
- **⚡ Performance Optimization**: Slider no longer spams hardware during drag
  - Hardware squelch only applied on release (onStopTrackingTouch)
  - Toast notification only on release (no more spam)
  - Smooth dragging without lag or repeated writes
- **🎨 Button Visual Improvements**: All toggle buttons use light-colored OFF states
  - TXT button: Light purple → Purple
  - Soft SQ button: Light blue → Blue
  - REC button: Light red → Red
  - MON button: Light orange → Orange
  - APRS button: Light green → Green
- **🔘 APRS Button Enhancement**: Converted to ToggleButton with state management
  - Auto-toggles with monitoring state
  - Unchecks when closing monitoring dialog
  - Proper state sync across app lifecycle
- **📏 UI Spacing Refinements**:
  - Slider track now colored full width (white on intercom, black on APRS)
  - Reduced spacing between SQ: label and value display
  - Tighter spacing above squelch controls
  - Vertical spacing added between SQ: label and slider (4dp)

#### **APRS Monitoring Page Enhancements**
- **✨ Soft SQ Toggle**: Independent software squelch control for APRS
  - Works identically to intercom page toggle
  - Light blue when OFF, blue when ON
  - Shows/hides slider and info text
  - OFF: Uses hardware squelch (level 2)
  - ON: Enables hybrid RSSI + Audio RMS squelch
- **🔧 Independent Control**: APRS and intercom squelch settings are separate
  - Each page has its own toggle state
  - Each can use software or hardware squelch independently
  - Squelch levels saved separately in preferences

#### **Technical Details**
- Software squelch disabled by default on both pages (user opt-in)
- Toggle states: `isSoftwareSquelchEnabled` (intercom), `isAprsSoftwareSquelchEnabled` (APRS)
- Hardware squelch control via direct `AnalogMessage.send()` calls
- UI updates optimized to reduce redundant hardware writes
- Full-width slider track using `setProgressBackgroundTintList()`

---

## � What's New in v3.1.2 (March 13, 2026)

### APRS Channel Recovery & Squelch Control Improvements

**Automatic crash recovery with user guidance + hardware-aware squelch control**

#### **Crash Recovery System**
- **Automatic channel restoration** when app closes during APRS monitoring
- **AlertDialog notification** explains what happened and how to prevent future issues
- **Complete field restoration** including frequency, squelch, and all metadata
- **Comprehensive logging** for debugging crash recovery scenarios

**How It Works:**
1. Module detects orphaned APRS channel on app startup
2. Automatically restores original channel settings from backup file
3. Shows informative dialog with prevention guidance
4. Prompts to restart the app for clean state

**Backup System:**
- File: `/sdcard/aprs_channel_backup.dat`
- Saves: number, type, name, frequencies, squelch, band, power, rx/tx settings
- Auto-deletes after successful restore

#### **Squelch Control - Hardware Limitation Documentation**

**⚠️ IMPORTANT: Ulefone Armor 26 Ultra Hardware Limitation**

The radio hardware has a unique quirk that affects squelch control:
- **Only sq=0 (open) and sq=2 work reliably**
- **sq=1, sq=3-9 are forced to sq=2 by the hardware**
- This is a **hardware/firmware limitation**, not a software bug

**Impact on Design:**
- No squelch slider needed - hardware only supports two states
- **Open Squelch button** toggles between sq=0 (fully open) and sq=2 (tight)
- Button shows **green** when squelch is open (sq=0)
- Button shows **gray** when squelch is closed (sq=2)
- Button state persists across UI refreshes (monitoring page updates every 2 seconds)

**Why This Matters:**
- Previous attempts at granular squelch control (0-9 slider) were fighting hardware
- New design works **with** the hardware limitation instead of against it
- Provides predictable, reliable squelch behavior

**Technical Details:**
- Direct hardware control via `AnalogMessage.send()`
- Persistent static state variables survive UI refreshes
- Works identically to MON button pattern
- No database updates needed (direct UART communication)

---

## �🐛 What's New in v3.1.1 (March 12, 2026)

### Critical APRS Bug Fixes

**Reliability improvements for APRS monitoring after crashes and fresh storage**

- **Fixed: Fresh Storage Issue**
  - APRS monitoring now works correctly after clearing app storage
  - Uses in-memory channel hijacking instead of database queries
  - No more ClassNotFoundException errors
- **Fixed: Crash Recovery**
  - Channel automatically restored after force-close during monitoring
  - File-based backup at `/sdcard/aprs_channel_backup.dat`
  - Detects orphaned APRS channels and restores original within 2 seconds
- **Fixed: Static Variable Persistence**
  - State properly resets on every app launch
  - Fixed Xposed module lifecycle issue (static vars persist across app restarts)
  - Resets `isAPRSMonitoringActive`, dialog references, and audio buffer
- **Fixed: APRS Button After Crash**
  - APRS button works correctly after crash recovery
  - Monitoring dialog displays properly after app restart
  - No more phantom audio buffering
- **Fixed: Dialog State Issues**
  - Dialog references now reset on app launch
  - Live monitoring screen appears correctly on restart

---

## 📡 APRS Live Monitoring (v3.1.0)

### Real-time APRS packet reception with live dashboard and clickable map links

- **APRS Button** on intercom page (green button below MON)
- **Live Monitoring Dashboard**:
  - Persistent screen that stays open during monitoring
  - Auto-updates every 2 seconds with new packets
  - Real-time statistics (total stations, last hour, last 5 minutes)
  - Shows up to 10 most recent packets
- **Clickable Station Links**:
  - Tap any station to open Google Maps at GPS location
  - Shows callsign, time received, and coordinates
  - Underlined cyan text indicates clickable links
- **Automatic Channel Creation**:
  - Creates hidden APRS channel automatically on first use
  - Uses frequency from APRS Settings (default: 144.390 MHz)
  - Channel hidden from UI but accessible for monitoring
- **Auto-Logging**:
  - Per-callsign text logs (append mode): `Download/DMR/APRS/CALLSIGN-SSID.txt`
  - Per-callsign GPX tracks (full movement history): `Download/DMR/APRS/CALLSIGN-SSID.gpx`
  - Full packet history in database for track visualization
- **APRS Settings Dialog**:
  - Configure callsign, SSID, and frequency
  - Access via APRS Received page or Settings
- **Channel Management**:
  - Saves previous channel and returns on stop
  - Works from both analog and digital channels
  - No manual channel creation needed

**Usage**: 
1. Intercom page → Tap APRS button (green, below MON)
2. Configure settings if needed (callsign optional for RX-only)
3. Tap "Start Monitoring" → Live dashboard appears
4. Tap any received station → Opens in Google Maps
5. Tap "Stop Monitoring" → Returns to previous channel

**Technical Details**:
- Pure RX-only operation (no transmit capability)
- Uses device's analog FM receiver tuned to APRS frequency
- Bell 202 AFSK 1200 baud decoding (AX.25 protocol)
- APRS channels automatically filtered from channel list
- Database stores full transmission history per station

## 🎉 What's New in v3.0.9 (March 9, 2026)

### 🧭 GPS Distance Display Enhancements

**Directional arrows, compass bearings, and dual distance units for better situational awareness**

- **8-direction compass arrows**: ↑N, ↗NE, →E, ↘SE, ↓S, ↙SW, ←W, ↖NW
- Shows direction from your location to the channel
- Real-time bearing calculation using GPS coordinates
- **Dual distance display**: 
  - < 1km: Meters only (e.g., `↑N 250m`)
  - 1-10km: Kilometers (e.g., `→E 5.2km`)
  - > 10km: Miles + kilometers (e.g., `↘SE 96.7mi (155.6km)`)
- Improved UI layout: Widened location area from 30% to 40% width to prevent text wrapping
- No internet required (uses device location only)

**Display Examples**:
```
Echo, Minnesota (↘SE 96.7mi (155.6km))
320m (1050ft) 📍

Chicago Rptr (↗NE 5.2km)
180m (590ft) 📍

Local Simplex (↑N 250m)
210m (689ft) 📍
```

## 🎉 What's New in v3.0.8 (March 9, 2026)

### 🎛️ Zone Management & Channel Edit Zone Selector

**Create, edit, and assign zones directly from the app!**

- **Zone row in channel edit screen** - Assign channels to zones while editing
- **Create new zones** - Tap "Create New Zone..." at bottom of zone list
- **Edit zone names** - Pencil icon (✏) next to each zone or long-press to rename
- **Automatic list refresh** - Channel list updates instantly after zone changes
- **Technical improvements**:
  - Fixed critical hook stacking bug (zone assignments now persistent)
  - Proper instance field management
  - Singleton database pattern
  - OpenGD77 Zones.csv import/export fully supported

**Usage**: Channel page → Edit channel → Tap Zone row → Select/Create/Rename zones

## 🎉 What's New in v3.0.5 (March 9, 2026)

### 📂 Channel Zones

**Organize channels into zones (like folders)**

- **ZONE button** on main screen (below MON button)
- Import/export zones via OpenGD77 Zones.csv format
- Zone-based channel navigation (arrows filter by active zone)
- Up to 80 channels per zone (OpenGD77 limit)
- Zones stored in local database (persistent)

## 🎉 What's New in v3.0.4 (March 9, 2026)

### 📍 GPS Distance Calculation

- Real-time distance from your location to channel coordinates
- Smart distance formatting (meters/kilometers/miles based on range)
- Uses device GPS/network location
- No internet required

## 🎉 What's New in v3.0.3 (March 9, 2026)

### 🐛 Critical Bug Fix

- **DMR Audio Fixed**: Resolved silent receive audio and garbled transmit audio
- Call type override logic now only active during MON mode

## 🎉 What's New in v3.0.2 (March 9, 2026)

### 🆕 Major Features

1. **Analog MON (Monitor) Button** ⭐
   - Squelch fully open (sq=0) for continuous monitoring
   - Visual feedback: Orange = monitoring, Gray = normal
   - Perfect for scanning and emergency monitoring

## Complete Feature List (v1.0 - v3.0.9)

### Core Features
- ✅ **OpenGD77 CSV export/import** - All 5 files (Channels, Contacts, TG_Lists, Zones, DTMF)
- ✅ **Zone management** - Create, edit, assign zones to channels
- ✅ **GPS navigation** - Distance, direction, bearing to channels
- ✅ **Location tracking** - Reverse geocoding, city/state display, elevation
- ✅ **RSSI signal strength** indicator
- ✅ **DMR activity history** with timestamps
- ✅ **Contact integration** - Caller ID display
- ✅ **Analog MON button** - Open squelch for continuous monitoring

### Transcription Features (v1.2 - v1.7.0)
- ✅ **Real-time speech-to-text** using OpenAI Whisper API
- ✅ **Automatic audio recording** organized by channel
- ✅ **Per-channel transcription history** (last 3-10 messages)
- ✅ **Daily transcription logs** with timestamps and DMR IDs
- ✅ **User-friendly API key configuration**

## What is this?

LSPosed module for the Ulefone PriInterPhone DMR radio app that adds:
- **🧭 GPS Navigation** - Directional arrows, compass bearings, distance to channels
- **📂 Zone Management** - Create, edit, assign channels to zones (folder organization)
- **📤 OpenGD77 CSV Export** - Export all channels/contacts to OpenGD77-compatible CSV files
- **📥 OpenGD77 CSV Import** - Import OpenGD77 codeplugs directly into the app
- **🔄 Cross-platform programming** - Edit channels in OpenGD77 CPS, import to phone
- **🗂️ Easy access** - Backups saved to Download folder (easy file transfer)
- **⚡ Direct database access** - No shell commands, fast and reliable
- **🔒 No APK modification** - Works via runtime hooks (preserves platform signature)
- **🎙️ Real-time Transcription** - Live speech-to-text powered by OpenAI Whisper API
- **📝 Automatic Logging** - Daily transcription logs organized by channel with timestamps

## Current Status ✅

**Current Release: v3.0.9** (March 9, 2026)  
**GPS Navigation**: ✅ Working - Directional arrows, compass bearings, distance (m/km/mi)  
**Zone Management**: ✅ Working - Create, edit, assign zones to channels  
**Export**: ✅ Working - All 5 OpenGD77 CSV files + PDF summary + Zones.csv  
**Import**: ✅ Working - Full Digital & Analog support + Zones import  
**Transcription**: ✅ Working - Real-time speech-to-text with OpenAI Whisper API  
**Audio Recording**: ✅ Working - Automatic WAV recording organized by channel  
**Per-Channel History**: ✅ Working - Transcription messages persist per channel  
**Timestamps**: ✅ Working - All messages include HH:mm:ss timestamps  
**Analog MON Button**: ✅ Working - Open squelch for continuous monitoring  
**User Validation**: ✅ All features tested and confirmed working  
**Latest Build**: March 9, 2026

## Radio Firmware

The DMR radio module uses ARM Cortex-M firmware that handles all radio protocol operations. The original factory firmware is preserved in this repository for reference and patching experiments.

**Firmware Location**: `radio_firmware/`

- **DMR003.UV4T.V022-ORIGINAL.bin** - Factory firmware (378,620 bytes)
  - MD5: `4426035392262CA54583C230C9E268E0`
  - Base address: `0x08000000` (STM32/GD32 flash memory)
  - Architecture: ARM Cortex-M Thumb mode (mixed 16/32-bit instructions)
  - RTOS: uC/OS-III (Micrium)

**Testing Modified Firmware Safely**:

The app checks for custom firmware in `/sdcard/DMR/DMRDEBUG.bin` on startup. If found, it transfers this firmware to the radio module via YModem protocol (~2 minutes). This allows safe testing of modified firmware without permanent flashing.

```powershell
# Deploy custom firmware for testing
adb push modified_firmware.bin /sdcard/DMR/DMRDEBUG.bin

# Restart app to trigger firmware update
adb shell am force-stop com.pri.prizeinterphone

# Remove test firmware to restore original
adb shell rm /sdcard/DMR/DMRDEBUG.bin
```

**Current Firmware Reverse Engineering Status**: See [NOTES_FOR_GROK.md](NOTES_FOR_GROK.md) for ongoing work to fix the Monitor Mode (RECEIVE_ALL) group ID extraction bug.

### Quick Facts

- **Module**: com.dmrmod.hooks (LSPosed Xposed module)
- **Target App**: com.pri.prizeinterphone (Ulefone system app)
- **Transcription Service**: com.macdmr.transcription (Standalone AIDL service)
- **Device**: Ulefone Armor 26 Ultra (Android 13)
- **LSPosed**: v1.9.2 (Zygisk)
- **Current Version**: v3.0.9 (March 9, 2026)
- **Storage Location**: `Download/DMR/` (Audio, Transcription, DMR_Backups folders)

## Features

### ✅ Phase 1: Initial Hook Setup
- Startup toast: "✓ DMR Mod Hooks Active! v3.0.9"
- Custom version display on Device Information screen
- Confirms module is active and working

### ✅ Phase 2: OpenGD77 CSV Export (v0.7.0 - v0.8.7)
- **Export all channels** to OpenGD77-compatible CSV format
- **5 CSV files generated**: Channels, Contacts, TG_Lists, Zones, DTMF
- Direct database access from hooked app context
- Perfect format matching (TAB-prefixed frequencies, CRLF line endings)
- **User validated**: Exported data successfully imports to OpenGD77 CPS
- **Round-trip tested**: Edit in app → Export → Import to OpenGD77 → Success!

### ✅ Phase 3: OpenGD77 CSV Import (v0.9.0 - v1.1)
- **Import channels** from OpenGD77 CSV files
- Direct database write with atomic transactions
- Handles mixed VHF/UHF channel lists
- **All channels import correctly** including both Digital (DMR) and Analog (FM)
- Correct field values for Digital vs Analog channel activation
- Backup selection dialog (supports any folder name in DMR/DMR_Backups/)
- Auto-refresh after import - no app restart needed
- Import confirmation with success/failure reporting
- Files stored in user-friendly Download folder

### ✅ Phase 4: Real-time Speech-to-Text Transcription (v1.2 - v1.7.0)
- **Live transcription** of all DMR audio transmissions
- **OpenAI Whisper API** integration for accurate recognition
- **Automatic audio recording** - All transmissions saved as WAV files
- **Per-channel message history** - Each channel maintains its own scrollable message list
- **Channel switching memory** - Return to any channel and see previous messages (up to 10 messages per channel)
- **Timestamped messages** - Every transcription includes [HH:mm:ss] timestamp
- **Channel-organized storage**:
  - Audio recordings: `Download/DMR/Audio/[ChannelName]/`
  - Transcriptions: `Download/DMR/Transcription/[ChannelName]/`
- **Daily transcription logs** - Running log files with timestamps and DMR IDs
- **Format**: `[14:30:22] ID: 123456 - Transcribed text here`
- **Scrollable UI** - Message list grows dynamically with height cap at 100dp
- **Network resilience** - Connectivity checking and comprehensive error handling
- **Secure API key** - Stored in `/sdcard/DMR/api_key.txt` (auto-created on first run)
- **Cost**: First $5/month FREE credit, then affordable per-second pricing
- **Status**: ✅ Successfully transcribing real DMR audio in production

### ✅ Phase 5: GPS Navigation & Location Tracking (v3.0.4 - v3.0.9)
- **Directional compass arrows** - 8-direction arrows (↑N, ↗NE, →E, ↘SE, ↓S, ↙SW, ←W, ↖NW)
- **Real-time bearing calculation** - Shows direction from your location to channel
- **Smart distance display**:
  - < 1km: Meters (e.g., `↑N 250m`)
  - 1-10km: Kilometers (e.g., `→E 5.2km`)
  - > 10km: Miles + kilometers (e.g., `↘SE 96.7mi (155.6km)`)
- **Reverse geocoding** - City, state display for channel coordinates
- **Elevation display** - Meters and feet via Open-Elevation API
- **Device location integration** - Uses GPS or network location
- **No internet required** for distance/bearing calculations

### ✅ Phase 6: Zone Management (v3.0.5 - v3.0.8)
- **Zone button** on main screen - Tap to select active zone
- **Zone-based navigation** - Arrow buttons filter by selected zone
- **Channel edit zone selector** - Assign channels to zones directly in edit screen
- **Create new zones** - Custom zone names via dialog
- **Edit zone names** - Pencil icon (✏) or long-press to rename
- **Automatic list refresh** - Changes apply immediately
- **OpenGD77 Zones.csv** - Full import/export support
- **Up to 80 channels per zone** - OpenGD77 limit
- **Persistent storage** - Zones saved in local SQLite database
- **Technical improvements**:
  - Fixed critical hook stacking bug
  - Proper instance field management
  - Singleton database pattern

### ✅ Phase 7: Analog MON Button (v3.0.2)
- **Continuous monitoring** - Squelch fully open (sq=0) on analog channels
- **Visual feedback** - Orange when monitoring, gray when normal
- **Auto-reset** - Returns to normal when switching channels
- **Toast notifications** - Confirms state changes
- **Perfect for scanning** - Monitor busy frequencies, emergency channels

## Why LSPosed?

The PriInterPhone app requires Ulefone's platform certificate to access:
- System UID (1000) for hardware permissions
- Custom `PrizeTinyService` framework APIs
- DMR radio module on `/dev/ttyS1`

**Traditional APK modification fails** because:
- ❌ Re-signing breaks platform signature verification
- ❌ System app placement alone doesn't grant platform UID
- ❌ Cannot obtain Ulefone's proprietary platform certificate

**LSPosed hooks the original properly-signed app** at runtime:
- ✅ Preserves platform signature and system UID
- ✅ Full access to all system APIs
- ✅ Can modify behavior without touching APK
- ✅ Reversible and update-safe

See [DMRModHooks/README.md](DMRModHooks/README.md) for complete LSPosed implementation details.

## Installation Instructions

### Requirements
- Ulefone Armor 26 Ultra (or compatible device with PriInterPhone)
  - **Root guide**: [XDA Forum - Armor 26 Ultra Root & Development](https://xdaforums.com/t/ulefone-armor-26-ultra-walkie-talkie-info-guides-development.4677740/)
  - **Note**: Check the XDA thread for the latest root procedure specific to your ROM version
  - **Tested on**: Build number `Armor 26 Ultra_AF1_v15`
- Unlocked bootloader
- Magisk v24+ with Zygisk enabled
- LSPosed v1.9.2+ (Zygisk variant)
- [ADB tools](https://developer.android.com/tools/releases/platform-tools) (for installation and verification)

### Step 1: Install LSPosed Framework

1. **Install Magisk** (if not already installed)
   - Download from: https://github.com/topjohnwu/Magisk
   - Enable Zygisk in Magisk settings
   - Reboot device

2. **Install LSPosed Module**
   - Download: https://github.com/LSPosed/LSPosed/releases
   - Get: `LSPosed-v1.9.2-zygisk-release.zip`
   - Install via Magisk → Modules → Install from storage
   - Reboot device
   - LSPosed Manager app will appear automatically

### Step 2: Install DMRModHooks Module & Transcription Service

#### Option A: Download Pre-built Release (✅ Recommended for All Users)

**Use v3.0.9 latest release for all current features including GPS navigation, zone management, and transcription.**

1. **Download Latest Release**:
   - Go to [Releases](https://github.com/IIMacGyverII/phonedmrapp/releases/latest)
   - Download `DMRModHooks-v3.0.9.apk` (**latest version**)
   - Download `DMRTranscriptionService-v1.0.apk` (if using transcription)

2. **Install Both APKs**:
   ```powershell
   adb install -r DMRModHooks-v3.0.9.apk
   adb install -r DMRTranscriptionService-v1.0.apk  # Optional, for transcription only
   ```

#### Option B: Build from Source (For Developers & Experimenters)

**Building from source gives you access to the latest development code and experimental features.**

1. **Build Both APKs**:
   ```powershell
   # Build DMRModHooks
   cd DMRModHooks
   .\gradlew.bat assembleDebug
   
   # Build TranscriptionService
   cd ..\DMRTranscriptionService
   .\gradlew.bat assembleDebug
   ```

2. **Install Both Modules**:
   ```powershell
   adb install -r DMRModHooks\app\build\outputs\apk\debug\app-debug.apk
   adb install -r DMRTranscriptionService\app\build\outputs\apk\debug\app-debug.apk
   ```

#### Enable in LSPosed Manager

3. **Activate Module**:
   - Open LSPosed Manager app on device
   - Go to "Modules" tab
   - Enable "DMR Mod Hooks" checkbox
   - Tap "DMR Mod Hooks" → Application scope
   - Verify `com.pri.prizeinterphone` is selected
   - **Important**: Do NOT add `com.macdmr.transcription` to LSPosed scope (it works standalone)
   - Reboot device

### Step 3: Configure OpenAI API (for Transcription - Optional)

**Note**: Transcription is optional. GPS navigation, zone management, and all other features work without it.

1. **Get API Key**:
   - Visit https://platform.openai.com/api-keys
   - Create account or sign in
   - Click "Create new secret key"
   - Copy the key (starts with `sk-...`)

2. **Configure API Key**:
   - Create file: `/sdcard/DMR/api_key.txt`
   - Paste your API key on first line (one line, no quotes)
   - The app auto-creates this folder on first run if missing
   - **Note**: File is device-local, never synced to GitHub

3. **Pricing**:
   - Whisper API: $0.006 per minute
   - First $5 of usage FREE with new accounts
   - Very affordable for typical DMR usage (~$0.002 per 5-second transmission)

### Step 4: Test Installation

1. **Verify Module is Active**:
   - Open PriInterPhone app
   - You should see toast: "✓ DMR Mod Hooks Active! v3.0.9"

2. **Test GPS Navigation** (if channels have coordinates):
   - Enable device location (GPS or Network)
   - Switch to a channel with GPS coordinates
   - Should see: City, State, distance with directional arrow (e.g., `↘SE 96.7mi (155.6km)`)
   - Direction arrow updates based on your location

3. **Test Zone Management**:
   - Tap ZONE button on main screen
   - Select "All Channels" or a specific zone
   - Edit a channel → Tap Zone row → Create/select zone
   - Verify zone assignment saves and list refreshes

4. **Test Export**:
   - Go to LOCAL tab
   - Tap 📤 **EXPORT (OpenGD77)** button  
   - Check `Download/DMR/DMR_Backups/` for CSV files (use any file manager)
   - Should see: Channels, Contacts, TG_Lists, Zones, DTMF CSVs with timestamps

5. **Test Import** (optional):
   - Tap 📥 **IMPORT (OpenGD77)** button
   - Select a backup timestamp from list
   - Confirm import
   - Wait for success message
   - Channels will auto-refresh and appear in app

6. **Test Transcription** (if configured):
   - Tap TXT button to enable (turns green)
   - Send or receive a DMR transmission with speech
   - Transcription appears in real-time below the channel info
   - Check `Download/DMR/Audio/[ChannelName]/` for WAV recordings
   - Check `Download/DMR/Transcription/[ChannelName]/transcription_YYYYMMDD.txt` for logs

7. **Test Analog MON Button** (analog channels only):
   - Switch to an analog channel
   - Tap MON button (turns orange)
   - Squelch opens completely - hear all audio continuously
   - Tap again to disable (turns gray)

## Usage

### Using GPS Navigation

1. **Enable Location**:
   - Ensure device location is enabled (GPS or Network)
   - Grant location permissions to PriInterPhone app
   - Channels must have GPS coordinates stored

2. **View Distance & Direction**:
   - Switch to any channel with coordinates
   - Location text shows:
     - Short distances: `↑N 250m`
     - Medium distances: `→E 5.2km`
     - Long distances: `↘SE 96.7mi (155.6km)`
   - Direction arrow points from your location to the channel
   - Updates automatically when switching channels

3. **Location Information**:
   - City, State display via reverse geocoding
   - Elevation in meters and feet
   - Pin icon 📍 indicates GPS data available

### Using Zone Management

1. **Select Active Zone**:
   - Tap **ZONE** button on main screen
   - Select from list (shows channel count per zone)
   - Arrow buttons now filter by selected zone only
   - Button shows current zone: "Zone: Local Pack"

2. **Create New Zone**:
   - Edit any channel (or from zone selector)
   - Tap Zone row in edit screen
   - Scroll to bottom → "Create New Zone..."
   - Enter zone name → Newly created zone auto-selected

3. **Assign Channels to Zones**:
   - Edit channel → Tap Zone row
   - Select zone from list
   - "None" removes from all zones
   - Changes save immediately

4. **Rename Zones**:
   - In zone selector, tap pencil icon (✏) next to zone name
   - Or long-press zone name
   - Edit name in dialog
   - Zone channels preserved

5. **Import/Export Zones**:
   - Zones automatically included in OpenGD77 export/import
   - Zones.csv file contains zone definitions
   - Compatible with OpenGD77 CPS

### Using Analog MON Button

1. **Enable Monitoring** (analog channels only):
   - Switch to analog channel
   - Tap **MON** button (turns orange)
   - Squelch opens completely - hear ALL audio continuously
   - Perfect for scanning busy frequencies

2. **Disable Monitoring**:
   - Tap **MON** button again (turns gray)
   - Returns to normal squelch based on channel settings

3. **Auto-Reset**:
   - MON automatically resets to OFF when switching channels
   - Prevents accidentally leaving squelch open

### Exporting Channels to OpenGD77

1. Open PriInterPhone app
2. Go to **LOCAL** tab
3. Tap **📤 EXPORT (OpenGD77)** button
4. Export completes (toast shows: "✓ Export successful! v1.1\nCheck Download/DMR/DMR_Backups/")
5. Files created in `Download/DMR/DMR_Backups/20260223_140530/` folder containing:
   - Channels.csv, Contacts.csv, TG_Lists.csv, Zones.csv, DTMF.csv
6. Transfer CSVs to PC via USB, file manager, or `adb pull /sdcard/Download/DMR/ .`
7. Open OpenGD77 CPS
8. Import → Select the folder containing all 5 CSV files
9. Program your OpenGD77 radio!

### Importing Channels from OpenGD77

1. Export channel programming from OpenGD77 CPS (all 5 CSV files)
2. Transfer CSVs to Android device `Download/DMR/DMR_Backups/`
   - Create a folder with any name (e.g., `MyBackup`, `Test`, or timestamp like `20260223_140530`)
   - Place the CSV files inside (OpenGD77 exports them as: `Channels.csv`, `Contacts.csv`, `TG_Lists.csv`, `Zones.csv`, `DTMF.csv`)
   - Via USB cable (MTP mode) or `adb push`
4. Open PriInterPhone app
5. Go to **LOCAL** tab
6. Tap **📥 IMPORT (OpenGD77)** button
7. Select backup folder from dialog (timestamp folders display as formatted dates)
8. Wait for import success notification
9. Channels auto-refresh - ready to use!

### Using Real-time Transcription

1. **Enable Transcription**:
   - Tap **TXT** button on main screen (turns green when enabled)
   - Transcription service automatically starts
   - Ensure `/sdcard/DMR/api_key.txt` contains your OpenAI API key

2. **During Transmissions**:
   - Real-time transcription appears below channel info in borderbox
   - Audio automatically recorded to `Download/DMR/Audio/[ChannelName]/`
   - Transcription appended to `Download/DMR/Transcription/[ChannelName]/transcription_YYYYMMDD.txt`
   - Last 3-10 messages persist per channel (scroll through history)

3. **File Organization**:
   ```
   Download/DMR/
     Audio/
       Channel_1/
         20260309_143022_CallSign_Name.wav
         20260309_143155_CallSign_Name.wav
       Repeater_2/
         20260309_150330_CallSign_Name.wav
     Transcription/
       Channel_1/
         transcription_20260309.txt
         transcription_20260310.txt
       Repeater_2/
         transcription_20260309.txt
   ```

4. **Transcription Log Format**:
   ```
   [14:30:22] ID: 123456 - This is the first transmission
   [14:31:55] ID: 789012 - Second transmission from different user
   [14:35:10] ID: 123456 - Another message
   ```

5. **Disable Transcription**:
   - Tap TXT button again (turns gray)
   - Transcription service stops
   - Audio recordings will continue if recording is enabled separately

## Project Structure

```
phonedmrapp/
├── originalapk/
│   └── com.pri.prizeinterphone.apk    # Original system APK (8.1 MB)
├── app/                                # Android Gradle project
│   ├── src/main/
│   │   ├── java/                       # 280 Java source files (JADX decompiled)
│   │   │   └── com/pri/prizeinterphone/
│   │   │       ├── InterPhoneHomeActivity.java  (Main UI - 567 lines)
│   │   │       ├── manager/
│   │   │       │   ├── DmrManager.java          (DMR control)
│   │   │       │   ├── SerialPort.java          (UART /dev/ttyS1)
│   │   │       │   └── CmdStateMachine.java     (Protocol)
│   │   │       └── ... (all DMR implementation)
│   │   ├── res/
│   │   │   ├── drawable-*/interphone_app_icon.png  (Custom icon, 5 densities)
│   │   │   └── values/strings.xml                   (MacDMRUlephone name)
│   │   └── AndroidManifest.xml
│   └── build.gradle                    # Package: com.pri.prizeinterphone
├── DMRModHooks/                        # LSPosed Xposed Module
│   ├── app/src/main/java/com/dmrmod/hooks/
│   │   ├── MainHook.java              # Main hook implementation (3300+ lines)
│   │   ├── DirectDatabaseExporter.java # OpenGD77 CSV export
│   │   ├── CSVExporter.java           # CSV file generation
│   │   └── DirectDatabaseImporter.java # OpenGD77 CSV import
│   ├── build.gradle
│   └── README.md                       # Module documentation
├── DMRTranscriptionService/            # Speech-to-Text Service
│   ├── app/src/main/
│   │   ├── java/com/macdmr/transcription/
│   │   │   └── TranscriptionService.java  # Google Cloud API integration
│   │   ├── aidl/com/macdmr/transcription/
│   │   │   └── ITranscriptionService.aidl # Service interface
│   │   └── AndroidManifest.xml
│   ├── local.properties               # API key (gitignored)
│   ├── local.properties.template      # Template for setup
│   └── build.gradle
├── magisk_module/
│   └── MacDMRUlephone/
│       ├── module.prop                 # Module metadata
│       ├── install.sh                  # Installation script
│       └── system/priv-app/PriInterPhone/
│           └── PriInterPhone.apk       # Custom APK (7.99 MB)
├── MacDMRUlephone-Magisk.zip          # Packaged module (6.65 MB)
├── icon.jpg                            # Custom icon source (784x1168)
├── MAGISK_SOLUTION.md                  # Magisk implementation guide
├── STATUS.md                           # Complete development timeline
├── QUICK_REFERENCE.md                  # ADB commands & debugging
└── README.md                           # This file
```

## Development Timeline

### ✅ Phase 1: Decompilation & Build
- Decompiled original APK with JADX → 280 Java source files (complete DMR stack)
- Created Android Gradle project (WSL2, Java 17, Gradle 8.2, AGP 7.4.2)
- Fixed 15+ compilation errors
- Created 10 stub classes for missing ROM APIs
- Resolved 58+ AndroidX resource attribute duplicates
- Built working APK

### ✅ Phase 2: Custom Branding
- Custom app name: MacDMRUlephone
- Custom icon from icon.jpg (all 5 Android densities)
- Package initially rebranded to `.modded` for side-by-side testing
- Resolved 5 manifest conflicts
- Fixed 4 system API compatibility issues

### ✅ Phase 3: GitHub Repository
- Created repository: https://github.com/IIMacGyverII/phonedmrapp
- Removed large files (gradle-8.2-bin.zip, jadx.zip - 197 MB)
- Pushed commit 5456fcac (16,278 files)
- Comprehensive documentation created

### ✅ Phase 4: DMR Hardware Investigation
- **Problem Discovered**: App stuck on "Module Initializing..." dialog
- **Root Cause**: Permission mismatch
  - Original app: userId=1000 (system)
  - Modded app: userId=10198 (user) - NO hardware access
- **Hardware Identified**: DMR module on `/dev/ttyS1` (system:radio permissions)
- **File Sync Issue**: Only 13 Java files in Windows vs 280 in WSL
- **Solution**: Robocopy synced all 280 files (2.36 MB)
- **Rebuild**: APK now contains complete DMR implementation

### ✅ Phase 5: System Access Solution
- **Attempted**: Direct system installation → Failed (production ROM locked)
- **Attempted**: Platform signing → Not viable (no manufacturer key)
- **Solution Found**: Magisk systemless overlay
- **Implementation**: Created Magisk module
  - Reverted package to `com.pri.prizeinterphone`
  - Built APK with custom branding
  - Packaged as Magisk module (6.65 MB)
  - Transferred to device: `/sdcard/Download/MacDMRUlephone-Magisk.zip`

### ⏳ Phase 6: Deployment (Pending User Action)
- Module ready for installation via Magisk Manager
- Awaiting user to install and reboot
- Will enable full DMR hardware access with custom branding

### ✅ Phase 7: Real-time Speech-to-Text Transcription (v1.2 - v1.5)
- **Problem**: Need speech-to-text for DMR transmissions
- **Attempted**: ONNX Whisper Base model → Failed (decoder token 0 issue, 155 MB removed)
- **Attempted**: Android SpeechRecognizer API → Failed (device blocks third-party access, error 10)
- **Attempted**: LSPosed hooks to bypass restrictions → Failed (system blocks at validation layer below hooks)
- **Solution Found**: Google Cloud Speech-to-Text API (bypasses all device restrictions)
- **Implementation**:
  - Created standalone TranscriptionService APK with AIDL interface
  - Integrated OkHttp for HTTP requests with 30-second timeouts
  - PCM to WAV conversion with proper 44-byte header
  - Base64 encoding for Google Cloud API
  - JSON request/response handling with error recovery
  - Network connectivity checking
  - Secured API key in gitignored local.properties
- **File Organization**:
  - Audio recordings organized by channel: `Download/DMR/Audio/[ChannelName]/`
  - Daily transcription logs by channel: `Download/DMR/Transcription/[ChannelName]/transcription_YYYYMMDD.txt`
  - Running log format: `[HH:MM:SS] ID: DMRID - Transcription text`
- **Status**: ✅ Successfully transcribing real DMR audio in production

## Technical Details

### Build Environment
- **Platform**: WSL2 Ubuntu 22.04 + Windows 11
- **Java**: OpenJDK 17.0.18
- **Android SDK**: compileSdk 34, minSdk 24, targetSdk 34
- **Gradle**: 8.2, AGP 7.4.2/8.1.0
- **Tools**: JADX 1.4.7, ImageMagick, ADB
- **Device**: 5006AF1020002922 (production ROM, Magisk installed)

### Transcription Architecture
- **Service**: Standalone AIDL service (com.macdmr.transcription)
- **API**: Google Cloud Speech-to-Text v1
- **HTTP Client**: OkHttp 4.12.0 with 30-second timeouts
- **Audio Format**: PCM 16-bit mono → WAV with proper header → Base64
- **Network**: Connectivity checking with ACCESS_NETWORK_STATE permission
- **Security**: API key in gitignored local.properties, injected via BuildConfig
- **Error Handling**: Comprehensive logging, network error recovery, API error detection
- **Storage**: Channel-organized folders for audio and transcription logs

### System API Fixes Implemented
1. **Background Service Restriction**: Disabled auto-start from Application.onCreate()
2. **WindowManager API**: Stubbed setDefaultDisplay() (system-only API)
3. **NVRAM Access**: Created stub for vendor-specific NvramUtils
4. **PCM Audio Manager**: Wrapped vendor-specific callbacks in try-catch

### DMR Implementation
- **Serial Port**: `/dev/ttyS1` (115200 baud, binary protocol)
- **Core Classes**: DmrManager, SerialPort, CmdStateMachine, PCMReceiveManager
- **Protocol Stack**: Complete implementation (280 Java files, ~45,000 lines)
- **Audio Pipeline**: Recording, codec, playback
- **Features**: Talkback, channels, contacts, messaging, settings

## Documentation

- **[MAGISK_SOLUTION.md](MAGISK_SOLUTION.md)**: Complete Magisk module guide with troubleshooting
- **[STATUS.md](STATUS.md)**: Full development timeline and technical achievements
- **[SUCCESS_REPORT.md](SUCCESS_REPORT.md)**: Initial build success documentation
- **[QUICK_REFERENCE.md](QUICK_REFERENCE.md)**: ADB commands and debugging tips
- **[JADX_DECOMPILATION_ERRORS.md](JADX_DECOMPILATION_ERRORS.md)**: Known JADX limitations

## GitHub Repository

**Repository**: https://github.com/IIMacGyverII/phonedmrapp  
**Latest Commit**: 5456fcac  
**Total Files**: 16,278 files committed  
**Status**: All source code available online

## Next Steps

1. **User Action Required**: Install Magisk module on device and reboot
2. **Testing**: Verify DMR hardware initialization and radio functionality
3. **Documentation**: Update with test results and user guide

## Future Plans

### Enhanced Transcription Features
- **Multi-language support**: Configure language per-channel
- **Custom vocabulary**: Add DMR-specific terms and callsigns
- **Offline transcription**: Explore local models for privacy/cost reduction
- **Voice commands**: Control radio functions via speech recognition

### Expanded DMR Functionality
- **Real-time Contact Display**: Enhanced live DMR contact receive display
- **Enhanced UI Integration**: Improved display of current DMR contact name, ID, and call status
- **Call logging**: Track incoming/outgoing DMR calls with detailed timestamps and durations
- **Statistics dashboard**: Visualize usage patterns and contact activity

### Tier 2 Support
- **Attempt Tier 2 Implementation**: Investigate and implement advanced DMR Tier 2 features
- **Enhanced talkgroup support**: Multi-talkgroup scanning and monitoring
- **IP connectivity**: Explore DMR network connectivity options

### Global DMR Database Integration
- **RadioID.net Integration**: Add ability to download and sync global DMR contact database
- **Automatic Updates**: Periodic contact database refresh from radioid.net
- **Smart Contact Resolution**: Automatically resolve DMR IDs to callsigns and names
- **Offline Database**: Local caching for fast lookups without internet connection

### The Sky's the Limit
With LSPosed runtime hooks and full access to the platform-signed app, **anything is possible**:
- Custom UI themes and branding
- Advanced automation and scripting
- Integration with external services and APIs
- Community-driven feature development
- Enhanced radio control and monitoring

**Last Updated**: March 9, 2026  
**Current Version**: v3.0.9 - GPS Distance Enhancements  
**Major Release**: v3.0.8 - Zone Management  
**Feature Release**: v3.0.5 - Channel Zones  
**Base Release**: v1.7.0 - Transcription & API Features  
**Status**: LSPosed module fully operational - All features working perfectly!  
**GitHub**: https://github.com/IIMacGyverII/phonedmrapp

### Version History Overview

**v3.0.x Series** (Current): Advanced Features
- ✅ GPS navigation with directional arrows and bearing
- ✅ Zone management (create, edit, assign)
- ✅ Analog MON button for continuous monitoring

**v1.x Series** (Stable Base): Core Features
- ✅ OpenGD77 CSV export/import
- ✅ Real-time speech-to-text transcription
- ✅ Location tracking and RSSI display
- ✅ Audio recording and logging

**v2.x Series** (Planned): DMR Enhancements
- ⏳ DMR group calling improvements
- ⏳ DMR monitoring mode
- 🔬 Requires extensive hardware-level debugging

For detailed technical information, see [DMRModHooks/README.md](DMRModHooks/README.md), [MAGISK_SOLUTION.md](MAGISK_SOLUTION.md), and [STATUS.md](STATUS.md).

## License

This project is licensed under the **GNU General Public License v3.0** - see the [LICENSE](LICENSE) file for details.

> **Disclaimer**: This tool hooks into the PriInterPhone app at runtime using LSPosed/Xposed. It does NOT modify or redistribute any proprietary code from Ulefone. Users must legally own the PriInterPhone app. For personal, educational, and interoperability purposes only.

