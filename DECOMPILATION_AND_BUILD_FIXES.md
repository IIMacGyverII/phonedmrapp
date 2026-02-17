# DMR App Decompilation and Build Fixes

## Overview
This document tracks the decompilation and build fix process for the Prize DMR (Digital Mobile Radio) Android app from https://github.com/IIMacGyverII/phonedmrapp.

## Date: February 17, 2026

## Issues Encountered and Resolved

### 1. Binary XML Resource Corruption ✅ FIXED
**Problem:** 195+ XML resource files were corrupted binary AXML format instead of text XML, causing build errors:
- `Invalid byte 1/2 of UTF-8 sequence`
- `Content not allowed in prolog`

**Root Cause:** Resources were copied directly from compiled APK without proper decompilation.

**Solution:**
- Used apktool to properly decompile the original APK from `originalapk/com.pri.prizeinterphone.apk`
- Command: `apktool d "originalapk\com.pri.prizeinterphone.apk" -o "decompiled_resources" -f`
- Successfully extracted 1,027 resource files across 104 subdirectories
- Copied all decompiled text XML resources from `decompiled_resources/res` to `app/src/main/res`

**Files Fixed:**
- All layout/*.xml files (including interphone_channel_activity.xml, text_view_with_line_height_from_layout.xml, etc.)
- All animator/*.xml files (fragment_fade_enter.xml, fragment_fade_exit.xml, m3_card_state_list_anim.xml)
- All xml/*.xml files (standalone_badge_offset.xml, etc.)
- All drawable/*.xml files (195+ vector drawables, selectors, animations)

### 2. Invalid Resource Filenames ✅ FIXED
**Problem:** 7 files had `$` characters in names, which are invalid for Android resources:
- `$avd_hide_password__0.xml` through `$avd_hide_password__2.xml`
- `$avd_show_password__0.xml` through `$avd_show_password__2.xml`
- `$ic_launcher_foreground__0.xml`

**Solution:** Deleted files with `$` prefix (duplicates existed without the `$`)

### 3. Duplicate Resource Conflicts ✅ FIXED
**Problem:** Resources existed in both `drawable/` and `drawable-anydpi/` directories, causing duplicate resource errors.

**Solution:**
- Removed `drawable-anydpi-v24/` directory entirely
- Removed duplicate `didouix_sbl_*.xml` files from `drawable/` (kept `drawable-anydpi/` versions)

### 4. AndroidManifest.xml Package Attribute ✅ FIXED
**Problem:** AGP 8.x deprecates `package` attribute in AndroidManifest.xml

**Solution:** Removed `package="com.pri.prizeinterphone"` from manifest (namespace is defined in build.gradle)

### 5. Build Configuration Updates ✅ COMPLETED
**Changes made to `build.gradle`:**
```gradle
aaptOptions {
    cruncherEnabled = false
    noCompress ''
}

android.buildFeatures.aidl = false
android.buildFeatures.renderScript = false
android.buildFeatures.shaders = false
```

**Changes made to `gradle.properties`:**
```properties
org.gradle.caching=false
android.unique.build.id=build
```

**AGP Version Changes:**
- Downgraded from AGP 8.5.2 to 8.3.2
- Downgraded Kotlin from 2.0.21 to 1.9.23

## Current Status: ⚠️ BLOCKED

### Remaining Issue: AAPT2 Path Bug on Windows
**Error:**
```
java.nio.file.InvalidPathException: Illegal char <:> at index 50:
com.pri.prizeinterphone.app-mergeDebugResources-42:/values/values.xml
```

**Analysis:**
- This is a Windows-specific AAPT2 internal path generation bug
- The error occurs during the resource merge phase
- AAPT2 creates an invalid internal path identifier with a colon at an illegal position
- **All XML encoding issues are resolved** - the files themselves are valid UTF-8 text XML
- This appears to be an AGP/AAPT2 toolchain issue, not a resource file issue

**Attempted Solutions:**
- ✅ Disabled Gradle caching
- ✅ Cleaned all build artifacts (including `.gradle` cache)
- ✅ Downgraded AGP version
- ✅ Modified AAPT options
- ❌ Issue persists across configurations

**Recommended Next Steps:**
1. **Try building on Linux/WSL2** - This path issue is Windows-specific
2. **Use Android Studio** instead of command-line Gradle
3. **Further downgrade AGP to 7.x** series
4. **Investigate AAPT2 Windows-specific configuration options**

## Project Structure

```
phonedmrapp/
├── app/
│   ├── src/main/
│   │   ├── res/           # All resources now TEXT XML (UTF-8, no BOM)
│   │   │   ├── layout/    # 195+ layout files (fixed)
│   │   │   ├── drawable*/ # Vector drawables, selectors (fixed)
│   │   │   ├── animator/  # Animation files (fixed)
│   │   │   ├── xml/       # XML resources (fixed)
│   │   │   └── values*/   # All valid text XML
│   │   ├── java/          # Decompiled Java source
│   │   └── AndroidManifest.xml (fixed - package attribute removed)
│   └── build.gradle (modified)
├── decompiled_resources/  # apktool output (1,027 files)
├── originalapk/           # Original APK source
│   └── com.pri.prizeinterphone.apk
├── old_decompiled/        # Previous decompilation attempts
├── build.gradle (modified - AGP 8.3.2, Kotlin 1.9.23)
└── gradle.properties (modified - caching disabled)
```

## Resource File Status

- **Total XML resources:** 1,027 files
- **Binary AXML files remaining:** 0 ✅
- **UTF-8 encoding errors:** 0 ✅
- **Invalid filenames:** 0 ✅
- **Duplicate resources:** 0 ✅
- **All resources:** Valid UTF-8 text XML without BOM

## Build Environment

- **OS:** Windows
- **Gradle Version:** 8.5 (wrapper)
- **AGP:** 8.3.2
- **Kotlin:** 1.9.23
- **JDK:** Java 17+
- **Build Tool:** Gradle command line (gradlew)

## Commands Used

### Decompilation
```powershell
apktool d "originalapk\com.pri.prizeinterphone.apk" -o "decompiled_resources" -f
```

### Resource Replacement
```powershell
Copy-Item -Path "decompiled_resources\res\*" -Destination "app\src\main\res\" -Recurse -Force
```

### Build Commands
```powershell
.\gradlew clean
.\gradlew assembleDebug --stacktrace --info
```

## Next Actions for Collaborators (Grok)

1. **Investigate AAPT2 Windows path bug:**
   - Research AGP versions with better Windows AAPT2 support
   - Consider AGP 7.x series or specific 8.x patches
   - Look into AAPT2 command-line workarounds

2. **Alternative build approaches:**
   - Test build on Linux/WSL2/Mac
   - Try Android Studio IDE build instead of CLI
   - Investigate custom AAPT2 binary options

3. **Code analysis:**
   - Review Java source code in `app/src/main/java/`
   - Identify any remaining resource references to fix
   - Check for any hardcoded paths or resource issues

4. **Resource validation:**
   - All XML resources are now valid - verified with hex dumps
   - No encoding issues remain
   - Focus should be on build toolchain, not resource files

## Files Modified

1. `build.gradle` - AGP/Kotlin versions, AAPT options
2. `app/build.gradle` - AAPT options, build features
3. `gradle.properties` - Caching disabled, build ID settings
4. `app/src/main/AndroidManifest.xml` - Package attribute removed
5. All XML resources in `app/src/main/res/` - Replaced binary with text

## Git Status
Ready to commit all resource fixes. Build issue is toolchain-related, not code-related.
