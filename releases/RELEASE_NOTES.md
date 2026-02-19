# DMRModHooks Release Notes

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
