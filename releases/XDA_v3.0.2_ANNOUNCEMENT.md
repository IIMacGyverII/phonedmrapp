# [MOD][LSPosed] DMRModHooks v3.0.2 - Analog MON Button + Complete Feature Suite

**Xposed/LSPosed module for the Ulefone PriInterPhone DMR radio app**

---

## 📡 What is this?

DMRModHooks is an LSPosed module that enhances the Ulefone Armor 26 Ultra's built-in PriInterPhone DMR radio app with professional-grade features typically found in dedicated radio equipment. No app modifications needed - all changes happen at runtime via Xposed hooks.

**Target Device**: Ulefone Armor 26 Ultra (Android 13)  
**Target App**: com.pri.prizeinterphone (PriInterPhone)  
**Framework**: LSPosed v1.9.2+ (Zygisk variant)

---

## 🎉 What's New in v3.0.2 (March 4, 2026)

### Major Addition: Analog MON Button ⭐

The star of this release - a **fully functional monitoring button** for analog channels that works like a scanner:

**Features**:
- 🔊 **MON ON**: Opens squelch completely (sq=0) - hear ALL audio continuously
- 🔇 **MON OFF**: Restores normal squelch filtering
- 🎨 **Visual Feedback**: Orange button = monitoring, Gray = normal
- 🔄 **Smart Reset**: Automatically disables when switching channels
- 📱 **Toast Notifications**: Confirms state changes

**Technical Implementation**:
- Direct hardware messaging via manual `AnalogMessage` construction
- Bypasses database sync to prevent hardware timing conflicts
- Preserves all 11 channel parameters during squelch modification
- Proper UART protocol handling for firmware compatibility

**Current Status**:
- ✅ **Analog channels**: Fully working and production-ready
- ⏸️ **Digital channels**: Button hidden (DMR "All" mode under investigation)
- 📝 TODO comments in code for future DMR re-enablement

### MacGyver Mod Branding 🏷️

Added project attribution directly in the app:

- New "MacGyver Mod Version" section in Device → Information page
- Shows "IIMacGyverII mod v3.0.2" with clickable GitHub link
- Dynamic view injection (survives ProGuard/R8 optimization)
- Also displays "DMRModHooks v3.0.2" in Software Version field

### Why v3.0.2 and Not v2.x? 🤔

**Short answer**: Getting useful features out NOW while complex DMR work continues.

**Long answer**: 
- **v1.x** (v1.0-v1.7.0): Stable feature releases ✅
- **v2.x** (Planned): DMR enhancements (group calling fixes, protocol debugging) ⏳
- **v3.x** (Current): Analog features + branding ✅

DMR group calling in "All" mode has complex hardware-level timing issues requiring extensive UART protocol analysis. Rather than delay a fully working analog monitoring feature for weeks/months, I released v3.0.2 now. DMR improvements will come in v2.x when ready, then MON button will be re-enabled for digital channels in a future v3.1+ update.

---

## 📦 Complete Feature Set

All features from v1.0-v1.7.0 are included, **plus** new v3.0.2 additions:

### Voice & Audio
- ✅ **Voice Transcription** - Real-time speech-to-text via OpenAI Whisper API
- ✅ **Audio Recording** - RX-only WAV recording with per-channel folders
- ✅ **Per-Channel History** - Last 3 transmissions with timestamps

### Channel Intelligence
- ✅ **Location Display** - City/state + elevation (Open-Elevation API)
- ✅ **RSSI Meter** - Signal strength in dBm with history persistence
- ✅ **DMR Caller ID** - Real-time contact name/DMR ID display
- ✅ **Activity History** - Last 3 events per channel (Voice TX/RX, SMS, etc.)

### Data Management
- ✅ **OpenGD77 CSV Export/Import** - Full backup/restore (5 files)
- ✅ **28 Channel Parameters** - Complete channel data preservation
- ✅ **CTCSS/DCS Support** - Analog tone preservation
- ✅ **Contact Integration** - Automatic name lookup from database
- ✅ **Location Storage** - Lat/long columns in CSV format

### UI Enhancements
- ✅ **Borderbox Overlay** - Semi-transparent gradient panel
- ✅ **PTT Repositioning** - Ergonomic bottom placement
- ✅ **Compact Layout** - Optimized spacing (5dp margins)
- ✅ **Professional Buttons** - Pill-shaped REC, toggle TXT/MON buttons

### NEW in v3.0.2
- ⭐ **Analog MON Button** - Continuous monitoring with open squelch
- ⭐ **MacGyver Mod Branding** - Project attribution in Information page
- ⭐ **GitHub Link** - Direct repository access from app
- ⭐ **Enhanced Version Display** - Module version visible in multiple places

---

## 🚀 Button Layout

```
Main Screen (TalkBack Fragment):
┌────────────────────────────────────┐
│  📞 Caller Info        Location 📍 │
│  Signal: -82 dBm      History Box  │
│                                     │
│         [Channel Info]              │
│                                     │
│          [PTT Button]               │
│   [TXT]    [MON]    [REC]          │
│  (Green)  (Orange)   (Red)          │
└────────────────────────────────────┘

Buttons:
• TXT  - Transcription toggle (requires API key)
• MON  - Monitoring mode (analog only, v3.0.2)
• REC  - Recording toggle (both analog & DMR)
```

---

## 📥 Download & Installation

### Requirements
- ✅ **Rooted** Ulefone Armor 26 Ultra (unlocked bootloader)
- ✅ **Magisk** v24+ with Zygisk enabled
- ✅ **LSPosed** Framework v1.9.2+ (Zygisk variant)
- ✅ **PriInterPhone** app (stock system app)

### Installation Steps

**1. Install Module**
Download from GitHub: [DMRModHooks-v3.0.2.apk](https://github.com/IIMacGyverII/phonedmrapp/releases/tag/v3.0.2)

```bash
adb install -r DMRModHooks-v3.0.2.apk
```

**2. Enable in LSPosed**
- Open LSPosed Manager
- Go to **Modules** tab
- Enable "DMR Mod Hooks"
- Tap module → **Enable module**
- Verify target: `com.pri.prizeinterphone`
- **Reboot device**

**3. Verify Installation**
- Open PriInterPhone app
- Look for toast: "✓ DMR Mod Hooks Active! v3.0.2"
- Go to LOCAL tab → Should see "Backup/Restore" button
- TalkBack screen → Should see TXT/MON/REC buttons
- Device → Information → Should see "MacGyver Mod Version"

### Optional: Transcription Setup
If you want voice-to-text transcription:

1. Get OpenAI API key: https://platform.openai.com/api-keys
2. Create file: `/storage/emulated/0/DMR/api_key.txt`
3. Paste your API key (one line, no quotes)
4. Restart app
5. Toggle TXT button (green = enabled)

Cost: ~$0.006 per minute of audio

---

## 📚 Usage Guide

### Analog Monitoring (MON Button)
**Perfect for**:
- Scanner-style operation on busy frequencies
- Repeater traffic monitoring
- Simplex channel monitoring
- Emergency channel surveillance

**How to use**:
1. Switch to analog FM channel
2. Tap MON button (turns orange)
3. All audio plays continuously (squelch open)
4. Tap again to disable (turns gray, normal squelch)
5. Auto-resets when switching channels

### Audio Recording
**Location**: `/storage/emulated/0/DMR/Recordings/[ChannelName]/`

1. Toggle REC button (red = enabled)
2. Recording auto-starts on RECEIVE_START
3. Files named: `YYYYMMDD_HHmmss_ContactName.wav`
4. Format: 16kHz, 16-bit, mono WAV (universal compatibility)
5. Empty files (<10KB) auto-deleted

### Location Display
Shows city/state + elevation in top-right corner.

**Adding locations**:
1. Export channels (Backup/Restore → Export)
2. Edit `Channels.csv` - add `Latitude` and `Longitude` columns
3. Example: `44.9203`, `-93.2654`
4. Import CSV back
5. Location appears automatically

### RSSI Signal Meter
- Yellow box shows: `Signal: -85 dBm`
- **Interpretation**:
  - `-50 to -70 dBm`: Excellent ████████
  - `-70 to -85 dBm`: Good ██████░░
  - `-85 to -95 dBm`: Marginal ████░░░░
  - `-95 to -110 dBm`: Poor ██░░░░░░

### CSV Backup/Restore
**Full OpenGD77 CPS workflow**:

1. Export from phone (LOCAL → Backup/Restore → Export)
2. Transfer to PC via USB
3. Edit in OpenGD77 CPS software
4. Export back to CSV
5. Transfer to phone
6. Import on phone

**Files**: Channels, Contacts, TG_Lists, Zones, DTMF, PDF summary, ZIP archive

---

## 🛠️ Technical Details

### Hooks Implemented

| Hook | Purpose |
|------|---------|
| `InterPhoneHomeActivity.onCreate()` | Version toast notification |
| `InterPhoneTalkBackFragment.initView()` | UI modifications, borderbox, buttons |
| `InterPhoneTalkBackFragment.updateUI()` | Location display updates |
| `InterPhoneLocalFragment.initView()` | Backup/Restore button injection |
| `FragmentLocalInformationActivity.initView()` | MacGyver branding injection |
| `ModuleStatusMessageHandler.decode()` | RECEIVE_START/STOP events |
| `DigitalAudioMessageHandler.decode()` | DMR ID extraction |
| `PCMReceiveManager.writeAudioTrack()` | Audio capture for recording |
| `SignalMessageHandler.decode()` | RSSI value extraction |
| `DmrManager.sendAnalogMessage()` | Analog message interception |
| `AnalogMessage.encodeBody()` | Squelch modification for MON |
| `BaseMessage.send()` | Message logging |

### Database Schema

**Location Database** (`dmrmod_locations.db`):
```sql
CREATE TABLE channel_locations (
    channel_number INTEGER PRIMARY KEY,
    latitude REAL,
    longitude REAL
);
```

**History Database** (`dmrmod_history.db`):
```sql
CREATE TABLE IF NOT EXISTS history (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    timestamp TEXT NOT NULL,
    activity TEXT NOT NULL,
    dmr_id TEXT,
    rssi_dbm INTEGER
);
```

### Direct Hardware Messaging (MON Button)

Key technical achievement - bypassing database to prevent hardware timing issues:

```java
// Manually construct AnalogMessage with modified squelch
Class<?> analogMessageClass = XposedHelpers.findClass(
    "com.pri.prizeinterphone.message.AnalogMessage",
    lpparam.classLoader
);
Object analogMessage = analogMessageClass.newInstance();

// Copy all 11 channel parameters
XposedHelpers.callMethod(analogMessage, "setBand", (byte) band);
XposedHelpers.callMethod(analogMessage, "setPower", (byte) power);
// ... 9 more fields ...
XposedHelpers.callMethod(analogMessage, "setSq", (byte) targetSq);  // Modified!

// Send directly to hardware
XposedHelpers.callMethod(analogMessage, "send");
```

This approach:
- ✅ Prevents database sync from resetting squelch
- ✅ Preserves all channel data
- ✅ Handles hardware timing correctly
- ✅ Eliminates intermittent static issues

---

## 📁 File Structure

```
/storage/emulated/0/DMR/
├── api_key.txt                           # OpenAI API key
├── DMR_Backups/
│   └── YYYYMMDD_HHMMSS/
│       ├── Channels.csv                  # 28 parameters per channel
│       ├── Contacts.csv
│       ├── TG_Lists.csv
│       ├── Zones.csv
│       ├── DTMF.csv
│       ├── Backup_Summary.pdf
│       └── DMR_Backup_YYYYMMDD_HHMMSS.zip
├── Recordings/
│   ├── ChannelName1/
│   │   └── 20260304_093015_ContactName.wav
│   └── ChannelName2/
│       └── 20260304_101234_64067.wav
└── uart_logs/                            # Debug logs (technical)

/data/user/0/com.pri.prizeinterphone/databases/
├── dmrmod_locations.db                   # Channel locations
├── dmrmod_history.db                     # Activity history
├── database_channel_area_default_uhf.db  # App's channel DB
└── contact_database.db                   # App's contact DB
```

---

## ⚠️ Known Limitations

### DMR Group Calling ("All" Mode)
**Issue**: Reception problems when monitoring all talk groups simultaneously

**Status**: 
- Under active investigation
- Complex hardware-level UART protocol timing issue
- Will be addressed in future v2.x release
- MON button disabled for DMR channels until fixed

**Workaround**: Use specific talk group IDs instead of "All" mode

### Transcription
- Requires internet connection (OpenAI Whisper API)
- Costs ~$0.006 per minute (paid service)
- English language optimized
- Accuracy depends on audio quality

### Recording
- RX only (transmit not recorded - hardware limitation)
- Requires storage space (WAV files are uncompressed)
- Empty recordings (<10KB) automatically deleted

---

## 🐛 Troubleshooting

### Module not loading?
```bash
# Check module installed
adb shell pm list packages | grep dmrmod

# Check LSPosed logs
adb logcat | grep LSPosed

# Verify Zygisk enabled in Magisk
# Reboot after enabling module
```

### MON button not visible?
- ✅ Only appears on analog channels
- ✅ Hidden on digital (by design in v3.0.2)
- ✅ Switch to FM analog channel

### Transcription not working?
```bash
# Verify API key file exists
adb shell cat /storage/emulated/0/DMR/api_key.txt

# Check module logs
adb logcat | grep DMRModHooks

# Verify REC button enabled (required for transcription)
```

### Recordings empty?
- Enable REC button before/during reception
- Files <10KB auto-deleted (too short)
- Check folder: `/storage/emulated/0/DMR/Recordings/`

---

## 🔜 Roadmap

### v2.x Series (In Development)
- 🔬 DMR group calling improvements
- 🐛 Fix "All" mode reception issues
- ⭐ Re-enable MON button for DMR channels
- 📡 Enhanced DMR protocol handling

### v3.1+ (Future)
- MON button for DMR (when v2.x complete)
- Additional analog features
- Performance optimizations
- UI customization options

---

## 📊 Version History

| Version | Date | Highlights |
|---------|------|-----------|
| **v3.0.2** | Mar 4, 2026 | Analog MON + branding |
| v1.7.0 | Feb 2026 | API key config |
| v1.6.0 | Feb 2026 | Transcription history |
| v1.4.9 | Feb 2026 | RSSI persistence |
| v1.4.8 | Feb 2026 | Signal strength |
| v1.4.7 | Feb 2026 | Audio recording |
| v1.4.0 | Feb 2026 | DMR history |
| v1.3.7 | Feb 2026 | Caller ID |
| v1.3.5 | Feb 2026 | Elevation display |
| v1.3.4 | Feb 2026 | Location geocoding |
| v1.0 | Feb 2026 | CSV export/import |

---

## 🔗 Links

**Download**: [GitHub Releases](https://github.com/IIMacGyverII/phonedmrapp/releases/tag/v3.0.2)  
**Source Code**: [GitHub Repository](https://github.com/IIMacGyverII/phonedmrapp)  
**Documentation**: [Full README](https://github.com/IIMacGyverII/phonedmrapp/blob/main/DMRModHooks/README.md)  
**Technical Details**: [MON Button Implementation](https://github.com/IIMacGyverII/phonedmrapp/blob/main/DMRModHooks/ANALOG_MON_FEATURE.md)

**External Tools**:
- OpenGD77 CPS: https://www.opengd77.com/downloads/
- LSPosed Framework: https://github.com/LSPosed/LSPosed
- OpenAI API Keys: https://platform.openai.com/api-keys

---

## 📜 License & Disclaimer

**License**: GNU General Public License v3.0 (GPL-3.0)

**Disclaimer**: This is an unofficial modification of the Ulefone PriInterPhone app. It is provided as-is with no warranty. Use at your own risk. This project is not affiliated with or endorsed by Ulefone.

**Requirements**:
- Root access required (unlocked bootloader)
- LSPosed Framework required
- Understanding of Xposed/LSPosed modules recommended
- Backup your data before use

---

## 🙏 Credits

- **Development**: IIMacGyverII
- **Target App**: Ulefone PriInterPhone
- **Framework**: LSPosed Team
- **CSV Format**: OpenGD77 Project
- **Community**: XDA-Developers

---

## 💬 Support & Contributions

**Bug Reports**: [GitHub Issues](https://github.com/IIMacGyverII/phonedmrapp/issues)  
**Discussions**: [GitHub Discussions](https://github.com/IIMacGyverII/phonedmrapp/discussions)  
**Pull Requests**: Always welcome!

**XDA Thread**: [Post your experiences, questions, and feedback here!]

---

## 📸 Screenshots

*(Add screenshots here showing:)*
- Main screen with MON/TXT/REC buttons
- Information page with MacGyver Mod branding
- RSSI display and activity history
- Location display with elevation
- CSV export dialog
- Recording folder structure

---

**Happy Monitoring!** 📻

*If you find this module useful, consider leaving feedback or contributing to the project. Star the repository on GitHub to show your support!*

---

**Download Now**: [DMRModHooks-v3.0.2.apk](https://github.com/IIMacGyverII/phonedmrapp/releases/download/v3.0.2/DMRModHooks-v3.0.2.apk) (41.8 MB)
