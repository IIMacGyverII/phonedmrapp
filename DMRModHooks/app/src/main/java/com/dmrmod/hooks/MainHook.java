package com.dmrmod.hooks;

import android.app.Activity;
import android.os.Bundle;
import android.widget.Toast;

import de.robv.android.xposed.IXposedHookLoadPackage;
import de.robv.android.xposed.XC_MethodHook;
import de.robv.android.xposed.XposedBridge;
import de.robv.android.xposed.XposedHelpers;
import de.robv.android.xposed.callbacks.XC_LoadPackage;

/**
 * DMR Mod Hooks - Main Hook Class
 * 
 * This module provides comprehensive modifications to the PriInterPhone DMR app.
 * 
 * Phase 2 (Testing): Simple hook verification
 * - Hook InterPhoneHomeActivity.onCreate()
 * - Display toast message to confirm hooks are working
 * - Log to Xposed logs
 * 
 * Future phases will add real modifications based on user requirements.
 */
public class MainHook implements IXposedHookLoadPackage {
    
    private static final String TAG = "DMRModHooks";
    private static final String TARGET_PACKAGE = "com.pri.prizeinterphone";
    
    @Override
    public void handleLoadPackage(XC_LoadPackage.LoadPackageParam lpparam) throws Throwable {
        // Only hook our target package
        if (!lpparam.packageName.equals(TARGET_PACKAGE)) {
            return;
        }
        
        XposedBridge.log(TAG + ": Module loaded for " + TARGET_PACKAGE);
        
        // Hook the main activity's onCreate method
        hookMainActivity(lpparam);
        
        // Hook the information screen to add MacGyver version
        hookInformationActivity(lpparam);
        
        XposedBridge.log(TAG + ": All hooks installed successfully");
    }
    
    /**
     * Hook InterPhoneHomeActivity.onCreate() as a verification test
     */
    private void hookMainActivity(XC_LoadPackage.LoadPackageParam lpparam) {
        try {
            Class<?> activityClass = XposedHelpers.findClass(
                "com.pri.prizeinterphone.InterPhoneHomeActivity",
                lpparam.classLoader
            );
            
            XposedHelpers.findAndHookMethod(
                activityClass,
                "onCreate",
                Bundle.class,
                new XC_MethodHook() {
                    @Override
                    protected void beforeHookedMethod(MethodHookParam param) throws Throwable {
                        XposedBridge.log(TAG + ": InterPhoneHomeActivity.onCreate() called - HOOK VERIFIED!");
                        
                        // Get the activity instance
                        final Activity activity = (Activity) param.thisObject;
                        
                        // Show a toast message to confirm the hook is working
                        activity.runOnUiThread(new Runnable() {
                            @Override
                            public void run() {
                                Toast.makeText(
                                    activity,
                                    "✓ DMR Mod Hooks Active!",
                                    Toast.LENGTH_SHORT
                                ).show();
                            }
                        });
                    }
                    
                    @Override
                    protected void afterHookedMethod(MethodHookParam param) throws Throwable {
                        XposedBridge.log(TAG + ": InterPhoneHomeActivity created successfully with hooks active");
                    }
                }
            );
            
            XposedBridge.log(TAG + ": Successfully hooked InterPhoneHomeActivity.onCreate()");
            
        } catch (Throwable t) {
            XposedBridge.log(TAG + ": Error hooking InterPhoneHomeActivity: " + t.getMessage());
            XposedBridge.log(t);
        }
    }
    
    /**
     * Hook FragmentLocalInformationActivity to display MacGyver version
     */
    private void hookInformationActivity(XC_LoadPackage.LoadPackageParam lpparam) {
        try {
            Class<?> infoActivityClass = XposedHelpers.findClass(
                "com.pri.prizeinterphone.activity.FragmentLocalInformationActivity",
                lpparam.classLoader
            );
            
            // Hook onCreate to log when the screen is opened
            XposedHelpers.findAndHookMethod(
                infoActivityClass,
                "onCreate",
                Bundle.class,
                new XC_MethodHook() {
                    @Override
                    protected void afterHookedMethod(MethodHookParam param) throws Throwable {
                        XposedBridge.log(TAG + ": Information screen opened!");
                        
                        // List all fields to see what actually exists
                        XposedBridge.log(TAG + ": === LISTING ALL FIELDS IN ACTIVITY ===");
                        java.lang.reflect.Field[] fields = param.thisObject.getClass().getDeclaredFields();
                        for (java.lang.reflect.Field field : fields) {
                            XposedBridge.log(TAG + ": Field found: " + field.getName() + " (" + field.getType().getSimpleName() + ")");
                        }
                        XposedBridge.log(TAG + ": === END FIELD LIST ===");
                    }
                }
            );
            
            XposedHelpers.findAndHookMethod(
                infoActivityClass,
                "initView",
                new XC_MethodHook() {
                    @Override
                    protected void afterHookedMethod(MethodHookParam param) throws Throwable {
                        XposedBridge.log(TAG + ": initView() called, attempting to set MacGyver version...");
                        
                        try {
                            // Try to hook the software version TextView instead
                            Object tvSoftwareVersion = XposedHelpers.getObjectField(
                                param.thisObject,
                                "mTvSoftwareVersion"
                            );
                            
                            if (tvSoftwareVersion != null) {
                                // Get current text
                                String originalText = (String) XposedHelpers.callMethod(tvSoftwareVersion, "getText");
                                
                                // Append MacGyver version
                                String newText = originalText + "\nMacGyver v1.0.0-ALPHA";
                                
                                XposedHelpers.callMethod(
                                    tvSoftwareVersion,
                                    "setText",
                                    newText
                                );
                                
                                XposedBridge.log(TAG + ": ✓ MacGyver version appended to software version!");
                            } else {
                                XposedBridge.log(TAG + ": ERROR - mTvSoftwareVersion is null!");
                            }
                            
                        } catch (Throwable t) {
                            XposedBridge.log(TAG + ": ERROR in initView hook: " + t.getMessage());
                            XposedBridge.log(t);
                        }
                    }
                }
            );
            
            XposedBridge.log(TAG + ": Successfully hooked FragmentLocalInformationActivity");
            
        } catch (Throwable t) {
            XposedBridge.log(TAG + ": Error hooking FragmentLocalInformationActivity: " + t.getMessage());
            XposedBridge.log(t);
        }
    }
}
