# DMRModHooks - LSPosed Module for PriInterPhone

**LSPosed module for modifying the Ulefone PriInterPhone DMR app at runtime**

## Status: ✅ Working

**Current Version**: v0.3  
**Target App**: com.pri.prizeinterphone (Ulefone PriInterPhone)  
**Requires**: LSPosed Framework v1.9.2+ (Zygisk)

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
