# DMRModHooks Release Notes

## v3.1.0 - APRS Live Monitoring (March 12, 2026)

### 📡 APRS Real-Time Reception with Live Dashboard

**MAJOR FEATURE**: Complete APRS packet reception system with live updating dashboard and interactive map links!

### ✨ What's New

**APRS Live Monitoring**:
- ✅ **Green APRS button** on intercom page (below MON button)
- ✅ **Live monitoring dashboard** that stays open during reception
- ✅ **Auto-updates every 2 seconds** with new packets
- ✅ **Real-time statistics**: Total stations, last hour, last 5 minutes
- ✅ **Recent packets display**: Up to 10 most recent with timestamps
- ✅ **Clickable station links**: Tap any station to open Google Maps at GPS location
- ✅ **Automatic channel creation**: Creates hidden APRS channel on first use
- ✅ **Smart channel management**: Saves and restores previous channel

**APRS Data Logging**:
- ✅ **Per-callsign text logs**: Append mode, `CALLSIGN-SSID.txt` format
- ✅ **Per-callsign GPX tracks**: Full movement history for each station
- ✅ **Full database history**: Keeps all transmissions for track visualization
- ✅ **Auto-export on reception**: Files created automatically in `Download/DMR/APRS/`

**APRS Settings**:
- ✅ **Configuration dialog**: Set callsign, SSID, and frequency
- ✅ **Default frequency**: 144.390 MHz (standard APRS frequency)
- ✅ **RX-only operation**: No transmit capability (receive-only system)
- ✅ **Access points**: APRS Received page or Settings menu

**Technical Implementation**:
- ✅ **Bell 202 AFSK decoder**: 1200 baud, AX.25 protocol
- ✅ **Pure Java PLL implementation**: No native code required
- ✅ **Hidden channel system**: APRS channels filtered from UI
- ✅ **Database schema**: Auto-increment ID for full history tracking
- ✅ **Live UI updates**: Handler-based periodic refresh every 2 seconds
- ✅ **Map integration**: Uses geo: URI to open Google Maps with coordinates

### 🎯 Usage Instructions

1. **Start Monitoring**:
   - Intercom page → Tap green APRS button (below MON)
   - Configure settings if needed (optional for RX-only)
   - Tap "Start Monitoring"

2. **Live Dashboard**:
   - Displays status, statistics, and recent packets
   - Updates automatically every 2 seconds
   - Tap any station entry to view on map

3. **Stop Monitoring**:
   - Tap "Stop Monitoring" button
   - Returns to previous channel automatically

4. **View Logs**:
   - Files: `Download/DMR/APRS/CALLSIGN-SSID.txt`
   - Tracks: `Download/DMR/APRS/CALLSIGN-SSID.gpx`
   - Open GPX files in OsmAnd or Maps.me

### 📊 Features Summary

| Feature | Description |
|---------|-------------|
| Live Dashboard | Persistent screen with real-time updates |
| Clickable Links | Tap stations to open in Google Maps |
| Auto Channel | Creates hidden APRS channel automatically |
| Text Logs | Per-callsign append-mode logs |
| GPX Tracks | Per-callsign movement history |
| Full History | Database keeps all transmissions |
| Smart Restore | Returns to previous channel on stop |

### 🔧 Technical Details

- **Protocol**: AX.25 (Amateur X.25) with Bell 202 AFSK
- **Frequency**: Configurable (default 144.390 MHz)
- **Modulation**: 1200 baud AFSK (1200 Hz mark, 2200 Hz space)
- **Decoder**: Pure Java PLL-based demodulator
- **Database**: SQLite with auto-increment primary key
- **UI Updates**: Handler-based with 2-second interval
- **Map Intent**: Uses `geo:` URI scheme for universal map app support

## v0.9.26 - FINAL RELEASE ✅ (February 2026)

### 🎉 FULLY WORKING - Complete OpenGD77 CSV Export/Import

**PROJECT COMPLETE**: This is the final working version with full OpenGD77 CSV export/import functionality. Both Digital and Analog channels import correctly and activate successfully.

### ✅ What Works

**Export Features**:
- ✅ All 5 CSV files export correctly (Channels, Contacts, TG_Lists, Zones, DTMF)
- ✅ 28 channel parameters including frequencies, power, squelch, CTCSS/DCS
- ✅ Correct DMR/Analog type detection from database
- ✅ Frequency conversion (Hz to MHz)
- ✅ All special characters preserved in channel names

**Import Features**:
- ✅ All 16 channels import correctly from OpenGD77 CSV
- ✅ Automatic band detection (VHF/UHF based on frequency)
- ✅ **Digital/Analog field differentiation** (critical fix in v0.9.26!)
- ✅ Stock Contact ID 1 preservation (prevents crashes)
- ✅ All 15 required database fields populated
- ✅ Automatic channel list refresh after import
- ✅ **Both Digital AND Analog channels activate successfully!**

**UI Features**:
- ✅ Backup/Restore button on LOCAL tab
- ✅ BackupActivity with export/import options
- ✅ MacGyver version display on Device Info screen

### 🔧 Critical Fix: Analog/Digital Field Differentiation

**The Problem**: v0.9.25 fixed Digital channels, but Analog channels still showed "operation failure" on activation.

**The Discovery**: Through diagnostic export comparison, discovered that Digital and Analog channels require DIFFERENT field values:

| Field | Digital (type=0) | Analog (type=1) |
|-------|------------------|-----------------|
| `channel_encryptSw` | 1 | 0 |
| `channel_encryptKey` | "" (empty) | NULL (not set) |
| `channel_interrupt` | 2 | 0 |
| `channel_active` | 1 | 0 |
| `channel_relay` | 1 | 1 (SAME) |

**The Solution**: Implemented conditional field setting based on channel type (isDMR flag).

**Result**: Both Digital and Analog channels now import and activate perfectly!

### 📦 Installation

**Requirements**:
- Ulefone Armor 26 Ultra (or compatible device)
- Android 13 (tested) or similar
- Magisk v24+ with root access
- Zygisk enabled in Magisk
- LSPosed Framework v1.9.2+ (Zygisk variant)

**Quick Install**:
1. Install LSPosed framework via Magisk (see main README)
2. Download `DMRModHooks-v0.9.26.apk`
3. Install: `adb install -r DMRModHooks-v0.9.26.apk`
4. Enable module in LSPosed Manager
5. Set scope to: `com.pri.prizeinterphone`
6. Reboot device
7. Open PriInterPhone app → LOCAL tab
8. Verify "Backup/Restore" button appears

**Full Instructions**: See [README.md](../DMRModHooks/README.md#installation-from-scratch)

### 📖 Usage

**Export Channels to OpenGD77 CSV**:
1. Tap "Backup/Restore" button on LOCAL tab
2. Select "Export to OpenGD77 CSV"
3. Files saved to `/sdcard/DMR_Backups/YYYYMMDD_HHMMSS/`
4. Transfer to PC, edit in OpenGD77 CPS or text editor

**Import Channels from OpenGD77 CSV**:
1. Edit `Channels.csv` as needed
2. Place file in `/sdcard/DMR_Backups/IMPORT/`
3. Tap "Backup/Restore" → "Import from OpenGD77 CSV"
4. Channel list auto-refreshes
5. All channels activate correctly (both Digital and Analog)

### 📝 Technical Implementation

**Database Schema**:
- Channel types: `0` = Digital (DMR), `1` = Analog (FM)
- Frequencies stored in Hz (CSV uses MHz)
- Band field: `0` = UHF (400-512 MHz), `1` = VHF (136-174 MHz)
- 15 required fields must be set or activation fails

**Hook Points**:
- `InterPhoneLocalFragment.initView()` - Adds Backup/Restore button
- `FragmentLocalInformationActivity.initView()` - MacGyver version display
- Direct database access to channel and contact DBs
- DmrManager reflection for auto-refresh

**Files Modified**:
- `MainHook.java` - VERSION = "0.9.26"
- `DirectDatabaseImporter.java` - Conditional field logic for Digital/Analog
- `DirectDatabaseExporter.java` - Complete 5-file export
- `BackupActivity.java` - UI for backup/restore operations

### 🐛 Known Issues

None! Everything works as expected.

### 🔄 Upgrade from v0.3

If upgrading from v0.3:
1. Install new version: `adb install -r DMRModHooks-v0.9.26.apk`
2. Reboot device
3. Look for "Backup/Restore" button on LOCAL tab (no more toast message)

### 📊 Development Stats

- **Total builds**: 74 versions
- **Development time**: ~2 weeks
- **Database fields discovered**: 15 required fields
- **CSV files supported**: 5 (Channels, Contacts, TG_Lists, Zones, DTMF)
- **Success rate**: 100% - both Digital and Analog channels work!

---

## v0.3 - First Working Release (February 18, 2026)

### 🎉 First Public Release

This is the first working version of DMRModHooks after extensive development and troubleshooting. The module successfully modifies the Ulefone PriInterPhone DMR app at runtime using LSPosed hooks.

### ✅ What Works

**Verified Features**:
- ✅ Startup verification toast message
- ✅ MacGyver version display on Device Information screen
- ✅ Runtime field discovery and introspection
- ✅ Method hooking on system app with platform certificate
- ✅ Stable operation with no crashes

### 📦 Installation

**Requirements**:
- Ulefone Armor 26 Ultra (or compatible device)
- Android 13 (tested) or similar
- Magisk v24+ with root access
- Zygisk enabled in Magisk
- LSPosed Framework v1.9.2+ (Zygisk variant)

**Quick Install**:
1. Install LSPosed framework via Magisk (see main README)
2. Download `DMRModHooks-v0.3.apk`
3. Install: `adb install DMRModHooks-v0.3.apk`
4. Enable module in LSPosed Manager
5. Set scope to: `com.pri.prizeinterphone`
6. Reboot device
7. Open PriInterPhone app - you should see toast message

**Full Instructions**: See [README.md](../DMRModHooks/README.md#installation-from-scratch)

### 🔧 Modifications Included

**UI Changes**:
- Device Information screen now displays "MacGyver Mod Version: MacGyver v1.0.0-ALPHA"
- Startup toast confirms hooks are active

**Hook Points**:
- `InterPhoneHomeActivity.onCreate()` - Startup verification
- `FragmentLocalInformationActivity.onCreate()` - Info screen load detection
- `FragmentLocalInformationActivity.initView()` - Version display modification

### 📝 Technical Notes

**Development Timeline**:
- This release came after 1.5 days of failed attempts with APK modification
- Multiple approaches tried: APKTool, JADX decompilation, Magisk systemization
- All failed due to platform certificate requirement for PrizeTinyService API
- LSPosed runtime hooks proved to be the only viable solution

**Why LSPosed Works**:
- Hooks the original properly-signed system app
- Runs in app's process with system UID (1000)
- Full access to Ulefone's custom PrizeTinyService API
- No APK modification or re-signing required

**Platform Certificate Issue**:
The PriInterPhone app requires Ulefone's platform signing certificate to access custom framework APIs. Any modified APK re-signed with a different key will fail with `NoSuchMethodError` when accessing `PrizeTinyService`. LSPosed bypasses this by hooking the original unmodified app.

### 🐛 Known Issues

None reported yet. This is a basic functionality release.

### 🚀 Future Plans

**Planned Features**:
- DMR protocol modifications
- Frequency/channel customization
- PTT behavior changes
- UI redesigns and new features
- Call logging and recording
- Network integration
- Custom encryption

### 📖 Documentation

- **Main README**: [DMRModHooks/README.md](../DMRModHooks/README.md)
- **Development History**: See README for full timeline of failed approaches
- **Installation Guide**: Comprehensive step-by-step in README
- **Troubleshooting**: Common issues and solutions documented

### 🙏 Credits

- **LSPosed Team**: For the amazing framework
- **Xposed Framework**: For the hooking API
- **Magisk**: For making it all possible

### 📥 Download

**File**: `DMRModHooks-v0.3.apk` (9.5 KB)  
**SHA-256**: (calculate if needed for verification)  
**Package**: `com.dmrmod.hooks`  
**Min SDK**: 26 (Android 8.0)  
**Target SDK**: 34 (Android 14)

### ⚠️ Disclaimer

This module modifies a system application at runtime. Use at your own risk. The developers are not responsible for any damage to your device. Always maintain backups and know how to recover from bootloops.

### 📄 License

This project is open source. See repository for license details.

---

**Support**: Open an issue on GitHub if you encounter problems  
**Source Code**: https://github.com/IIMacGyverII/phonedmrapp  
**Module Path**: `DMRModHooks/`
