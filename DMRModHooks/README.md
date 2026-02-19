# DMRModHooks - LSPosed Module for PriInterPhone

**LSPosed module for modifying the Ulefone PriInterPhone DMR app at runtime**

## Status: ✅ Working

**Current Version**: v0.3  
**Target App**: com.pri.prizeinterphone (Ulefone PriInterPhone)  
**Device**: Ulefone Armor 26 Ultra (Android 13)  
**Requires**: 
- LSPosed Framework v1.9.2+ (Zygisk variant)
- Magisk v24+ with Zygisk enabled
- Rooted device with unlocked bootloader

## Quick Links

- [Installation Guide](#installation-from-scratch)
- [Development History](#development-history)
- [Releases](../../releases) - Download pre-built modules
- [Technical Details](#technical-details)

## Features Implemented

### Phase 1: Framework Setup ✅
- LSPosed v1.9.2 installed and verified
- Module architecture established

### Phase 2: Basic Hooks ✅
- Startup verification (toast message)
- Confirms hooks are active

### Phase 3: UI Modifications ✅
- **MacGyver Branding**: Displays custom version on Device Information screen
- Hooks `FragmentLocalInformationActivity.initView()`
- Sets version text: "MacGyver v1.0.0-ALPHA"
- **User Verified**: Working on device

## Technical Details

### Hooks Implemented
1. **InterPhoneHomeActivity.onCreate()**
   - Purpose: Startup verification
   - Action: Displays toast "✓ DMR Mod Hooks Active!"
   
2. **FragmentLocalInformationActivity.onCreate()**
   - Purpose: Log when info screen is opened
   - Action: Logs to Xposed

3. **FragmentLocalInformationActivity.initView()**
   - Purpose: Display MacGyver version
   - Action: Discovers TextView fields, sets custom version text
   - Method: Runtime field introspection

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

3. **You should see**: Toast message "✓ DMR Mod Hooks Active!"

4. Navigate to Device Information screen (Settings → Device Info)

5. **You should see**: "MacGyver Mod Version: MacGyver v1.0.0-ALPHA"

### Troubleshooting

**No toast message on app startup:**
- Check LSPosed Manager → Modules → verify DMR Mod Hooks is checked
- Check LSPosed Manager → Logs for errors
- Verify module scope includes `com.pri.prizeinterphone`
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
   - Open PriInterPhone app
   - Should see startup toast
   - Navigate to Device Info screen
   - Should see MacGyver version

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
│       │   └── MainHook.java      # Hook implementation
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

### v0.3 (Feb 18, 2026)
- ✅ MacGyver version display working
- Added field discovery for runtime introspection
- Enhanced logging for debugging

### v0.2 (Feb 18, 2026)
- Added FragmentLocalInformationActivity hooks
- Field discovery implementation
- Improved error handling

### v0.1 (Feb 18, 2026)
- Initial test module
- Startup toast verification
- Basic hook framework

## Next Steps

Complex modifications planned:
- DMR protocol changes
- Frequency/channel modifications
- Custom UI features
- Advanced functionality additions

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
- **Day 2 (Feb 18 night)**: First UI modification (MacGyver version) - **SUCCESS!**

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
