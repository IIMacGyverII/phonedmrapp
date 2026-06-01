# APK Signature Issue - Critical Finding

**Date:** February 17, 2026  
**Status:** 🔴 BLOCKING - Module installation not working

## Problem Summary

The Magisk module does NOT install because of **APK signature mismatch**.

## What Happened

1. ✅ Successfully added MacGyver Mod Version 0.1 feature to source code
2. ✅ Successfully built new APK (7.63 MB, versionCode 35, versionName "2.0-MacDMR")
3. ✅ Created Magisk module ZIP with new APK
4. ❌ Module "installs" in Magisk but doesn't actually replace the system APK
5. ❌ Device still shows V1.0 after reboot

## Root Cause

**APK Signature Mismatch:**
- Original system APK: `MD5 F9B95B920B567D897C273418487A36C0` (7.76 MB)
- Our rebuilt APK: `MD5 C096A839F5C0550A74B114366D87ABEC` (7.63 MB)

**Error when trying to install:**
```
INSTALL_FAILED_UPDATE_INCOMPATIBLE: Existing package com.pri.prizeinterphone 
signatures do not match newer version; ignoring!
```

**Why this happens:**
- We built the APK from source using Gradle with default debug signing
- The original system APK was signed with different keys (possibly platform/system keys)
- Magisk refuses to overlay system apps when signatures don't match (security feature)

## Files Comparison

| File | Size | MD5 Hash | Version | Status |
|------|------|----------|---------|--------|
| original-system.apk | 7.76 MB | F9B95B92... | V1.0 (versionCode 33) | ✅ Working signature |
| MacDMRUlephone-v0.1.apk | 7.63 MB | C096A839... | 2.0-MacDMR (versionCode 35) | ❌ Wrong signature |

## Solutions

### Option 1: Use Original APK (Quick Fix)
**Status:** Can do immediately  
**Pros:** Works right away  
**Cons:** No MacGyver Mod Version, no customizations

```powershell
# Update module with original APK
Copy-Item original-system.apk magisk_module\MacDMRUlephone\system\priv-app\PriInterPhone\PriInterPhone.apk
```

### Option 2: Modify Original APK with apktool (Recommended)
**Status:** Requires apktool installation  
**Pros:** Preserves signature, allows all modifications  
**Cons:** Needs setup

**Steps:**
1. Install apktool in WSL (requires sudo)
2. Decompile original-system.apk
3. Apply our modifications (MacGyver Mod Version, strings, layout, Java code)
4. Recompile with apktool (preserves original signature)
5. Create Magisk module with recompiled APK

**Commands:**
```bash
# In WSL
sudo apt-get install apktool

# Decompile original
apktool d -f original-system.apk -o original-decompiled

# Make modifications to decompiled files...

# Recompile (preserves signature)
apktool b original-decompiled -o MacDMRUlephone-signed.apk
```

### Option 3: Sign with Platform Keys
**Status:** Not feasible without system keys  
**Requires:** Android platform signing keys for the device  
**Note:** We don't have these keys

## Current Project State

**Modified Files (ready to apply):**
- ✅ `app/build.gradle` - versionCode 35, versionName "2.0-MacDMR"
- ✅ `app/src/main/res/layout/fragment_local_information_activity.xml` - MacGyver Mod section
- ✅ `app/src/main/res/values/strings.xml` - "MacGyver Mod Version" string
- ✅ `app/src/main/res/values/ids.xml` - Resource IDs for MacGyver fields
- ✅ `app/src/main/java/.../ FragmentLocalInformationActivity.java` - Display logic for "0.1"
- ✅ `app/src/main/AndroidManifest.xml` - Cleaned (removed package attribute)

**Build System:**
- ✅ Gradle builds successfully in WSL
- ✅ All modifications compile without errors
- ✅ Generated APK is functional (just wrong signature)

## Next Steps

1. **Install apktool** (needs sudo password in WSL)
2. **Decompile original-system.apk** to preserve signature
3. **Apply modifications** to decompiled smali code:
   - Add MacGyver Mod Version TextView to layout
   - Add string resources
   - Modify smali code (equivalent of our Java changes)
4. **Recompile** with apktool (auto-signs with original signature)
5. **Test** new APK in Magisk module
6. **Verify** version shows as 2.0-MacDMR with MacGyver Mod field

## Technical Details

**Original System APK Info:**
- Path: `/system/priv-app/PriInterPhone/PriInterPhone.apk`
- Package: `com.pri.prizeinterphone`
- SharedUserID: `android.uid.system`
- Current Version: V1.0 (versionCode 33)
- Size: 7.76 MB (8,136,003 bytes)

**Our Built APK Info:**
- Source: Gradle build from decompiled Java sources
- Package: `com.pri.prizeinterphone`
- SharedUserID: `android.uid.system`
- Target Version: 2.0-MacDMR (versionCode 35)
- Size: 7.63 MB (7,998,879 bytes)
- Contains: All our modifications including MacGyver Mod Version field

**Size Difference Explanation:**
The 130 KB difference is likely due to:
- Different resource compression
- Different dex optimization
- Gradle build optimizations
- Missing/added resources during decompilation/recompilation

## Files Available

- ✅ `original-system.apk` - Working system APK with correct signature
- ✅ `MacDMRUlephone-v0.1.apk` - Our modified APK with wrong signature
- ✅ `magisk_module/MacDMRUlephone-v0.1.zip` - Non-working module (wrong signature)
- ⏳ Need: APK with our modifications AND original signature

## References

**Working Magisk Module Structure:**
```
MacDMRUlephone/
├── module.prop
├── install.sh
└── system/
    └── priv-app/
        └── PriInterPhone/
            └── PriInterPhone.apk  ← Must have matching signature!
```

**module.prop:**
```
id=macdmrulephone
name=MacDMRUlephone System App
version=1.0
versionCode=1
author=Joshua MacDMR
description=Replaces PriInterPhone system app with custom branding.
```

---

**Last Updated:** February 17, 2026 21:15  
**Next Action:** Install apktool and follow Option 2
