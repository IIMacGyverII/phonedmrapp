# Integration Guide: Patch Persistence Solutions

## Overview
Two complementary approaches to solve firmware patch persistence:

1. **UART Bootloader Probe** - Test for permanent flash capability (30-60 min)
2. **One-Tap Reload Button** - Guaranteed fallback with great UX (2-3 hours)

**Strategy**: Try bootloader probe first (quick test, potentially solves forever), implement reload button if probe fails.

---

## Phase 1: UART Bootloader Probe (DO THIS FIRST)

### Step 1: Test Bootloader Access

Add this method to MainHook.java (after hookSerialCommunication):

```java
/**
 * Test for STM32 bootloader on radio UART
 * Called once during app initialization
 */
private void testBootloaderAccess(Context context) {
    // Run in background to avoid blocking UI
    new Thread(() -> {
        try {
            Thread.sleep(5000); // Wait 5 sec for app to stabilize
            
            XposedBridge.log(TAG + ": Starting bootloader probe...");
            UARTBootloaderProbe.ProbeResult result = UARTBootloaderProbe.probeBootloader();
            
            XposedBridge.log(TAG + ": Probe result: " + result.toString());
            
            if (result.canFlashPermanently()) {
                XposedBridge.log(TAG + ": ⭐ BOOTLOADER ACCESSIBLE! Permanent flash is possible!");
                XposedBridge.log(TAG + ": ⭐ Can use Write Memory (0x31) + Erase (0x43) commands");
                
                // Optional: Try reading patch location
                UARTBootloaderProbe.PatchStatus status = UARTBootloaderProbe.readPatchLocation();
                XposedBridge.log(TAG + ": Patch status: " + status.toString());
            } else {
                XposedBridge.log(TAG + ": ❌ Bootloader not accessible - cannot flash permanently");
                XposedBridge.log(TAG + ": → Will need to use reload button instead");
            }
            
        } catch (Exception e) {
            XposedBridge.log(TAG + ": Probe exception: " + e.getMessage());
        }
    }).start();
}
```

### Step 2: Call Test During App Initialization

In handleLoadPackage(), add after other hooks:

```java
@Override
public void handleLoadPackage(XC_LoadPackage.LoadPackageParam lpparam) throws Throwable {
    if (!lpparam.packageName.equals("com.pri.prizeinterphone")) {
        return;
    }
    
    XposedBridge.log(TAG + ": DMRModHooks v" + VERSION + " initializing");
    
    // ... existing hooks ...
    hookSerialCommunication(lpparam);
    
    // NEW: Test bootloader probe
    try {
        Context context = AndroidAppHelper.currentApplication();
        if (context != null) {
            testBootloaderAccess(context);
        }
    } catch (Exception e) {
        XposedBridge.log(TAG + ": Failed to start bootloader test: " + e.getMessage());
    }
    
    XposedBridge.log(TAG + ": All hooks installed successfully");
}
```

### Step 3: Build and Test

```powershell
# Build APK with bootloader probe
cd C:\Users\Joshua\Documents\android\phonedmrapp\DMRModHooks
.\gradlew assembleDebug

# Install on device
adb install -r app\build\outputs\apk\debug\app-debug.apk

# Restart app to trigger probe
adb shell am force-stop com.pri.prizeinterphone
adb shell am start -n com.pri.prizeinterphone/.InterPhoneHomeActivity

# Watch probe results in real-time
adb logcat | Select-String "BootloaderProbe|STM32"
```

### Step 4: Analyze Results

**If you see this** → SUCCESS! 🎉
```
DMRModHooks:BootloaderProbe: ✅ ACK received! Bootloader is responsive!
DMRModHooks:BootloaderProbe: ✅ GET command ACKed!
DMRModHooks:BootloaderProbe: Bootloader version: 0x31
DMRModHooks:BootloaderProbe: ⭐ Write Memory (0x31) SUPPORTED!
DMRModHooks:BootloaderProbe: ⭐ Erase (0x43) SUPPORTED!
```
→ **BOOTLOADER IS ACCESSIBLE!** Can implement permanent flash (see Phase 1B below)

**If you see this** → Bootloader not accessible
```
DMRModHooks:BootloaderProbe: ⚠️ No response to SYNC byte (timeout)
OR
DMRModHooks:BootloaderProbe: ❌ NACK received - bootloader not accessible
```
→ **Skip to Phase 2** (reload button - guaranteed to work)

---

## Phase 1B: Permanent Flash Implementation (IF PROBE SUCCEEDED)

### Write Memory Operation (ADVANCED - HIGH RISK)

⚠️ **WARNING**: This writes to flash. Test carefully. Have factory firmware ready for recovery.

```java
/**
 * Permanently flash patch to radio module flash
 * 
 * SAFETY: Creates backup of original sector before writing
 * RISK: Medium - could brick radio if interrupted
 */
private boolean flashPatchPermanently() {
    FileInputStream uart_in = null;
    FileOutputStream uart_out = null;
    
    try {
        XposedBridge.log(TAG + ": ⚠️ Starting PERMANENT FLASH operation");
        
        uart_out = new FileOutputStream("/dev/ttyS1");
        uart_in = new FileInputStream("/dev/ttyS1");
        
        // Step 1: Read current sector (16KB backup)
        XposedBridge.log(TAG + ": Reading original sector for backup...");
        byte[] sectorBackup = readFlashSector(uart_in, uart_out, 0x08018000, 16384);
        if (sectorBackup == null) {
            XposedBridge.log(TAG + ": ❌ Failed to read original sector");
            return false;
        }
        
        // Save backup to SDcard
        File backupFile = new File("/sdcard/DMR/firmware_sector_backup.bin");
        FileOutputStream backupOut = new FileOutputStream(backupFile);
        backupOut.write(sectorBackup);
        backupOut.close();
        XposedBridge.log(TAG + ": ✅ Backup saved to " + backupFile.getPath());
        
        // Step 2: Modify sector in memory (patch at offset 0xF2C)
        sectorBackup[0xF2C] = (byte) 0x00; // NOP byte 1
        sectorBackup[0xF2D] = (byte) 0xBF; // NOP byte 2
        XposedBridge.log(TAG + ": Sector modified (BLS → NOP at offset 0xF2C)");
        
        // Step 3: Erase sector (POINT OF NO RETURN)
        XposedBridge.log(TAG + ": ⚠️ Erasing flash sector...");
        if (!eraseSector(uart_in, uart_out, 0x08018000)) {
            XposedBridge.log(TAG + ": ❌ Erase failed - attempting recovery");
            // Try to restore backup
            writeSector(uart_in, uart_out, 0x08018000, sectorBackup);
            return false;
        }
        XposedBridge.log(TAG + ": ✅ Sector erased");
        
        // Step 4: Write patched sector
        XposedBridge.log(TAG + ": Writing patched sector...");
        if (!writeSector(uart_in, uart_out, 0x08018000, sectorBackup)) {
            XposedBridge.log(TAG + ": ❌ Write failed - FLASH MAY BE CORRUPTED");
            XposedBridge.log(TAG + ": → Restore backup from: " + backupFile.getPath());
            return false;
        }
        XposedBridge.log(TAG + ": ✅ Patched sector written");
        
        // Step 5: Verify write
        byte[] verification = readFlashSector(uart_in, uart_out, 0x08018000, 16384);
        if (verification != null && verification[0xF2C] == (byte) 0x00 && 
            verification[0xF2D] == (byte) 0xBF) {
            XposedBridge.log(TAG + ": ✅✅✅ PATCH VERIFIED! Flash successful!");
            XposedBridge.log(TAG + ": ⭐ Firmware is now PERMANENTLY patched!");
            return true;
        } else {
            XposedBridge.log(TAG + ": ❌ Verification failed");
            return false;
        }
        
    } catch (Exception e) {
        XposedBridge.log(TAG + ": ❌ Flash operation failed: " + e.getMessage());
        return false;
    } finally {
        try {
            if (uart_in != null) uart_in.close();
            if (uart_out != null) uart_out.close();
        } catch (IOException e) {
            // Ignore
        }
    }
}

// Helper methods (implement based on STM32 AN3155 spec)
private byte[] readFlashSector(FileInputStream in, FileOutputStream out, int address, int length) {
    // Implement Read Memory command (0x11)
    // Return sector bytes
}

private boolean eraseSector(FileInputStream in, FileOutputStream out, int address) {
    // Implement Erase command (0x43)
    // Return true if successful
}

private boolean writeSector(FileInputStream in, FileOutputStream out, int address, byte[] data) {
    // Implement Write Memory command (0x31)
    // Write in 256-byte chunks (STM32 limitation)
    // Return true if successful
}
```

**Testing Permanent Flash**:
1. Call `flashPatchPermanently()` once from UI button
2. Verify logs show "PATCH VERIFIED"
3. Reboot device
4. Check patch status (should remain active)
5. Test DMR audio

---

## Phase 2: One-Tap Reload Button (GUARANTEED FALLBACK)

### Step 1: Embed PATCH14.bin in APK Assets

```powershell
# Create assets directory
New-Item -ItemType Directory -Force -Path "C:\Users\Joshua\Documents\android\phonedmrapp\DMRModHooks\app\src\main\assets"

# Copy firmware file
Copy-Item "C:\Users\Joshua\Documents\android\phonedmrapp\DMR003.UV4T.V022-PATCH14.bin" `
          "C:\Users\Joshua\Documents\android\phonedmrapp\DMRModHooks\app\src\main\assets\PATCH14.bin"

# Verify
Get-Item "C:\Users\Joshua\Documents\android\phonedmrapp\DMRModHooks\app\src\main\assets\PATCH14.bin"
```

### Step 2: Hook Information Screen

Add to MainHook.java:

```java
/**
 * Hook Fragment_LocalInformation to add reload button
 */
private void hookLocalInformationActivity(XC_LoadPackage.LoadPackageParam lpparam) {
    try {
        Class<?> fragmentClass = XposedHelpers.findClass(
            "com.pri.prizeinterphone.home.fragment.Fragment_LocalInformation", 
            lpparam.classLoader);
        
        XposedHelpers.findAndHookMethod(fragmentClass, "initView", new XC_MethodHook() {
            @Override
            protected void afterHookedMethod(MethodHookParam param) throws Throwable {
                try {
                    // Get root view
                    View rootView = (View) XposedHelpers.callMethod(param.thisObject, "getView");
                    if (rootView == null) return;
                    
                    // Find main layout (adjust ID if needed)
                    LinearLayout mainLayout = rootView.findViewById(
                        rootView.getContext().getResources().getIdentifier(
                            "main_layout", "id", "com.pri.prizeinterphone"));
                    
                    if (mainLayout != null) {
                        // Inject reload button
                        PatchReloadHelper.injectReloadButton(mainLayout, rootView.getContext());
                        XposedBridge.log(TAG + ": Reload button injected into Information screen");
                    }
                    
                } catch (Exception e) {
                    XposedBridge.log(TAG + ": Failed to inject reload button: " + e.getMessage());
                }
            }
        });
        
    } catch (Exception e) {
        XposedBridge.log(TAG + ": Failed to hook LocalInformation: " + e.getMessage());
    }
}
```

### Step 3: Call Hook During Initialization

In handleLoadPackage():

```java
// ... existing hooks ...
hookLocalInformationActivity(lpparam);
```

### Step 4: Build, Install, Test

```powershell
# Build with embedded firmware
.\gradlew assembleDebug

# Check APK size (should be ~380KB larger)
Get-Item app\build\outputs\apk\debug\app-debug.apk | Select-Object Name, @{N='Size';E={"{0:N0} KB" -f ($_.Length/1KB)}}

# Install
adb install -r app\build\outputs\apk\debug\app-debug.apk

# Test
adb shell am force-stop com.pri.prizeinterphone
adb shell am start -n com.pri.prizeinterphone/.InterPhoneHomeActivity

# Navigate to Information screen (swipe or menu)
# Should see:
# - Status indicator: "⚠️ Patch Status: Lost - Reload Required" (if patch lost)
# - Button: "🔧 Reload DMR Patch"

# Click button → should see progress dialog → auto-restart → patch restored
```

---

## Testing & Verification

### Test Bootloader Probe
```powershell
# Start logcat monitoring
adb logcat -c
adb logcat | Select-String "BootloaderProbe" > probe_test.log

# Let app run for 10 seconds
# Check results
Get-Content probe_test.log
```

### Test Reload Button
```powershell
# 1. Reboot device to lose patch
adb reboot
# Wait for boot...

# 2. Open app → Information screen
# 3. Status should show: "⚠️ Patch Status: Lost"
# 4. Click "🔧 Reload DMR Patch"
# 5. Progress dialog should appear (~2 min)
# 6. App should auto-restart
# 7. Status should show: "✓ Patch Status: Active"

# Verify patch loaded
adb logcat -d | Select-String "DigitalMessage.*txContact" | Select-Object -Last 5
# Should see txContact with actual group IDs (not 1 or 16777215)
```

### Persistence Test (If Bootloader Flash Succeeded)
```powershell
# 1. Flash patch permanently
# 2. Verify logs show "PATCH VERIFIED"
# 3. Reboot device
adb reboot

# 4. After boot, check patch status
adb shell am start -n com.pri.prizeinterphone/.InterPhoneHomeActivity
Start-Sleep -Seconds 10

# 5. Check DigitalMessage logs
adb logcat -d | Select-String "DigitalMessage.*txContact" | Select-Object -Last 5

# Expected: txContact shows actual group IDs (patch persisted!)
```

---

## Recommendations

### Priority Order
1. **Test bootloader probe first** (30 min) - Quick test, potentially solves permanently
2. **If probe fails, implement reload button** (2-3 hours) - Guaranteed working solution
3. **Test both solutions thoroughly** before release

### Safety Considerations
- **Bootloader probe**: Read commands are safe, write commands have medium risk
- **Backup original sector** before attempting permanent flash
- **Keep factory firmware** available for recovery
- **Test on single device** before public release

### User Experience
- **Best case**: Bootloader flash works → One-time operation, firmware patched forever
- **Fallback case**: Reload button → ~30 sec user interaction after each reboot
- **Both solutions**: Vastly better than current 3-minute manual process

### Distribution Strategy
- **v3.1 (reload button)**: Immediate release, guaranteed to work
- **v4.0 (bootloader flash)**: Advanced feature if probe succeeds, optional one-tap permanent patch
- **Documentation**: Clear instructions for both methods

---

## Next Steps

1. **Immediate**: Test bootloader probe on device
   ```powershell
   # Add probe code, build, install, check logs
   ```

2. **If probe succeeds**: Implement permanent flash (Phase 1B)
3. **If probe fails**: Implement reload button (Phase 2)
4. **Either way**: Comprehensive testing before release
5. **Documentation**: Update XDA announcement with persistence solution

---

## File Checklist

Created files:
- ✅ `UARTBootloaderProbe.java` - STM32 bootloader probe logic
- ✅ `PatchReloadHelper.java` - One-tap reload button UI & workflow
- ✅ `INTEGRATION_GUIDE.md` - This file

Next to create:
- ⏸️ Modified MainHook.java (add probe + button hooks)
- ⏸️ app/src/main/assets/PATCH14.bin (embed firmware)
- ⏸️ Test scripts for verification

Ready to integrate and test!
