package com.dmrmod.hooks;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Button;
import android.widget.FrameLayout;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.TextView;
import android.widget.Toast;

import de.robv.android.xposed.IXposedHookLoadPackage;
import de.robv.android.xposed.XC_MethodHook;
import de.robv.android.xposed.XposedBridge;
import de.robv.android.xposed.XposedHelpers;
import de.robv.android.xposed.callbacks.XC_LoadPackage;

/**
 * DMR Mod Hooks - Main Hook Class
 * 
 * This LSPosed module provides comprehensive modifications to the PriInterPhone DMR app.
 * 
 * ARCHITECTURE:
 * - Uses LSPosed/Xposed framework to hook into the running app at runtime
 * - Preserves the original app's platform signature (required for system-level hardware access)
 * - Injects UI elements and functionality without modifying the original APK
 * 
 * FEATURES:
 * Phase 1: Hook verification and MacGyver branding ✓
 * - Startup toast showing module is active
 * - MacGyver version display on Local → Information screen
 * 
 * Phase 2: OpenGD77 CSV Export/Import ✓
 * - Export/Import buttons in LOCAL tab of home screen
 * - Exports all 5 OpenGD77 CSV files (Channels, Contacts, TG_Lists, Zones, DTMF)
 * - Import from backup selection dialog (supports any folder name in DMR_Backups/)
 * - Full compatibility with OpenGD77 CPS ecosystem for cross-platform codeplug management
 * - Files saved to Download/DMR_Backups/ for easy user access
 * 
 * TECHNICAL NOTES:
 * - Runs in the target app's process with full database access
 * - Uses reflection to call app methods for UI refresh after import
 * - All database operations use transactions for data integrity
 */
public class MainHook implements IXposedHookLoadPackage {
    
    private static final String TAG = "DMRModHooks";
    private static final String VERSION = "1.3.3";
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
        
        // Hook the TalkBack fragment to reposition UI elements
        hookTalkBackFragment(lpparam);
        
        // Hook the local fragment to add backup/restore button
        hookLocalFragment(lpparam);
        
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
                                String toastMessage = "✓ DMR Mod Hooks Active! v" + VERSION;
                                XposedBridge.log(TAG + ": Showing toast: " + toastMessage);
                                Toast.makeText(
                                    activity,
                                    toastMessage,
                                    Toast.LENGTH_LONG
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
     * Hook InterPhoneTalkBackFragment to add borderbox and reposition PTT button
     */
    private void hookTalkBackFragment(XC_LoadPackage.LoadPackageParam lpparam) {
        try {
            Class<?> fragmentClass = XposedHelpers.findClass(
                "com.pri.prizeinterphone.fragment.InterPhoneTalkBackFragment",
                lpparam.classLoader
            );
            
            XposedHelpers.findAndHookMethod(
                fragmentClass,
                "initView",
                View.class,
                new XC_MethodHook() {
                    @Override
                    protected void afterHookedMethod(MethodHookParam param) throws Throwable {
                        XposedBridge.log(TAG + ": InterPhoneTalkBackFragment.initView() called");
                        
                        try {
                            // Get mLocalView
                            Object mLocalViewObj = XposedHelpers.getObjectField(param.thisObject, "mLocalView");
                            if (!(mLocalViewObj instanceof ViewGroup)) {
                                XposedBridge.log(TAG + ": mLocalView is not a ViewGroup");
                                return;
                            }
                            
                            ViewGroup rootLayout = (ViewGroup) mLocalViewObj;
                            Context context = rootLayout.getContext();
                            int margin5dp = (int) (5 * context.getResources().getDisplayMetrics().density);
                            int margin10dp = (int) (10 * context.getResources().getDisplayMetrics().density);
                            
                            int childCount = rootLayout.getChildCount();
                            XposedBridge.log(TAG + ": Root layout child count: " + childCount);
                            
                            // Move channel controls (child 0) to top
                            if (childCount > 0) {
                                View channelControls = rootLayout.getChildAt(0);
                                ViewGroup.LayoutParams params = channelControls.getLayoutParams();
                                if (params instanceof LinearLayout.LayoutParams) {
                                    LinearLayout.LayoutParams layoutParams = (LinearLayout.LayoutParams) params;
                                    layoutParams.topMargin = margin5dp;
                                    channelControls.setLayoutParams(layoutParams);
                                    XposedBridge.log(TAG + ": ✓ Moved channel controls up");
                                }
                            }
                            
                            // Reduce spacing and move info text (child 1) to top
                            if (childCount > 1) {
                                View infoText = rootLayout.getChildAt(1);
                                if (infoText instanceof LinearLayout) {
                                    LinearLayout infoLayout = (LinearLayout) infoText;
                                    
                                    try {
                                        java.lang.reflect.Method setShowDividers = LinearLayout.class.getMethod("setShowDividers", int.class);
                                        setShowDividers.invoke(infoLayout, 2);
                                        
                                        java.lang.reflect.Method setDividerPadding = LinearLayout.class.getMethod("setDividerPadding", int.class);
                                        setDividerPadding.invoke(infoLayout, margin5dp);
                                        
                                        XposedBridge.log(TAG + ": ✓ Successfully reduced text spacing to 5dp");
                                    } catch (Exception e) {
                                        XposedBridge.log(TAG + ": Error setting dividers: " + e.getMessage());
                                    }
                                    
                                    ViewGroup.LayoutParams params = infoText.getLayoutParams();
                                    if (params instanceof LinearLayout.LayoutParams) {
                                        LinearLayout.LayoutParams layoutParams = (LinearLayout.LayoutParams) params;
                                        layoutParams.topMargin = margin5dp;
                                        infoText.setLayoutParams(layoutParams);
                                        XposedBridge.log(TAG + ": ✓ Moved info text up");
                                    }
                                }
                            }
                            
                            // Add borderbox and move PTT to bottom
                            if (childCount > 2) {
                                // Check if already modified
                                boolean alreadyModified = false;
                                for (int i = 0; i < rootLayout.getChildCount(); i++) {
                                    View child = rootLayout.getChildAt(i);
                                    Object tag = child.getTag();
                                    if (tag != null && "DMR_SPACER".equals(tag.toString())) {
                                        alreadyModified = true;
                                        XposedBridge.log(TAG + ": Layout already modified, skipping");
                                        break;
                                    }
                                }
                                
                                if (alreadyModified) {
                                    return;
                                }
                                
                                View pttButton = rootLayout.getChildAt(2);
                                XposedBridge.log(TAG + ": PTT button found: " + pttButton.getClass().getSimpleName());
                                
                                // Create borderbox (250dp empty FrameLayout)
                                android.widget.FrameLayout borderBox = new android.widget.FrameLayout(context);
                                borderBox.setTag("DMR_BORDERBOX");
                                int height250dp = (int) (250 * context.getResources().getDisplayMetrics().density);
                                LinearLayout.LayoutParams borderParams = new LinearLayout.LayoutParams(
                                    LinearLayout.LayoutParams.MATCH_PARENT,
                                    height250dp
                                );
                                borderParams.leftMargin = margin10dp;
                                borderParams.rightMargin = margin10dp;
                                borderParams.topMargin = margin10dp;
                                
                                // Create gradient drawable
                                android.graphics.drawable.GradientDrawable gradientDrawable = new android.graphics.drawable.GradientDrawable();
                                gradientDrawable.setShape(android.graphics.drawable.GradientDrawable.RECTANGLE);
                                gradientDrawable.setStroke(
                                    (int) (2 * context.getResources().getDisplayMetrics().density),
                                    0xAAFFFFFF
                                );
                                gradientDrawable.setCornerRadius(12 * context.getResources().getDisplayMetrics().density);
                                gradientDrawable.setColors(new int[]{0x15FFFFFF, 0x08FFFFFF});
                                gradientDrawable.setGradientType(android.graphics.drawable.GradientDrawable.LINEAR_GRADIENT);
                                gradientDrawable.setOrientation(android.graphics.drawable.GradientDrawable.Orientation.TOP_BOTTOM);
                                
                                borderBox.setBackground(gradientDrawable);
                                borderBox.setLayoutParams(borderParams);
                                borderBox.setClickable(false);
                                borderBox.setFocusable(false);
                                
                                // Add location display TextView to borderbox
                                TextView locationText = new TextView(context);
                                locationText.setTag("DMR_LOCATION_TEXT");  // Tag for later updates
                                FrameLayout.LayoutParams textParams = new FrameLayout.LayoutParams(
                                    FrameLayout.LayoutParams.WRAP_CONTENT,
                                    FrameLayout.LayoutParams.WRAP_CONTENT
                                );
                                textParams.gravity = android.view.Gravity.TOP | android.view.Gravity.END;
                                textParams.topMargin = (int) (8 * context.getResources().getDisplayMetrics().density);
                                textParams.rightMargin = (int) (8 * context.getResources().getDisplayMetrics().density);
                                locationText.setLayoutParams(textParams);
                                locationText.setTextColor(0xFFFFFFFF);  // White text
                                locationText.setTextSize(12);
                                locationText.setText("📍");  // Default icon
                                
                                borderBox.addView(locationText);
                                
                                // Update location for current channel
                                updateLocationDisplay(param.thisObject, locationText, context);
                                
                                // Insert borderbox at index 2
                                rootLayout.addView(borderBox, 2);
                                XposedBridge.log(TAG + ": ✓ Added borderbox at index 2 (250dp)");
                                
                                // Create spacer
                                View spacer = new View(context);
                                spacer.setTag("DMR_SPACER");
                                LinearLayout.LayoutParams spacerParams = new LinearLayout.LayoutParams(
                                    LinearLayout.LayoutParams.MATCH_PARENT,
                                    0
                                );
                                spacerParams.weight = 1.0f;
                                spacer.setLayoutParams(spacerParams);
                                
                                rootLayout.addView(spacer, 3);
                                XposedBridge.log(TAG + ": ✓ Added spacer at index 3");
                                
                                // PTT button now at index 4
                                ViewGroup.LayoutParams params = pttButton.getLayoutParams();
                                if (params instanceof LinearLayout.LayoutParams) {
                                    LinearLayout.LayoutParams layoutParams = (LinearLayout.LayoutParams) params;
                                    layoutParams.gravity = android.view.Gravity.CENTER_HORIZONTAL;
                                    layoutParams.bottomMargin = margin10dp;
                                    layoutParams.weight = 0;
                                    layoutParams.height = LinearLayout.LayoutParams.WRAP_CONTENT;
                                    layoutParams.width = LinearLayout.LayoutParams.WRAP_CONTENT;
                                    pttButton.setLayoutParams(layoutParams);
                                    pttButton.setVisibility(View.VISIBLE);
                                    pttButton.bringToFront();
                                    XposedBridge.log(TAG + ": ✓ PTT button at index 4, visibility=" + pttButton.getVisibility());
                                }
                                
                                XposedBridge.log(TAG + ": Final child count: " + rootLayout.getChildCount());
                            }
                            
                        } catch (Exception e) {
                            XposedBridge.log(TAG + ": Error modifying TalkBack layout: " + e.getMessage());
                            XposedBridge.log(TAG + ": " + android.util.Log.getStackTraceString(e));
                        }
                    }
                }
            );
            
            // Hook updateUI to refresh location display when channel changes
            XposedHelpers.findAndHookMethod(
                fragmentClass,
                "updateUI",
                new XC_MethodHook() {
                    @Override
                    protected void afterHookedMethod(MethodHookParam param) throws Throwable {
                        try {
                            // Find the location TextView and update it
                            Object mLocalViewObj = XposedHelpers.getObjectField(param.thisObject, "mLocalView");
                            if (mLocalViewObj instanceof ViewGroup) {
                                ViewGroup rootLayout = (ViewGroup) mLocalViewObj;
                                TextView locationText = findLocationTextView(rootLayout);
                                if (locationText != null) {
                                    updateLocationDisplay(param.thisObject, locationText, rootLayout.getContext());
                                }
                            }
                        } catch (Exception e) {
                            XposedBridge.log(TAG + ": Error updating location in updateUI: " + e.getMessage());
                        }
                    }
                }
            );
            
            XposedBridge.log(TAG + ": Successfully hooked InterPhoneTalkBackFragment");
            
        } catch (Throwable t) {
            XposedBridge.log(TAG + ": Error hooking InterPhoneTalkBackFragment: " + t.getMessage());
            XposedBridge.log(t);
        }
    }
    
    /**
     * Helper method to find the location TextView in the view hierarchy
     */
    private TextView findLocationTextView(ViewGroup rootLayout) {
        for (int i = 0; i < rootLayout.getChildCount(); i++) {
            View child = rootLayout.getChildAt(i);
            if (child instanceof ViewGroup) {
                ViewGroup group = (ViewGroup) child;
                for (int j = 0; j < group.getChildCount(); j++) {
                    View subChild = group.getChildAt(j);
                    Object tag = subChild.getTag();
                    if (tag != null && "DMR_LOCATION_TEXT".equals(tag.toString())) {
                        return (TextView) subChild;
                    }
                }
            }
        }
        return null;
    }
    
    /**
     * Helper method to update location display for current channel
     */
    private void updateLocationDisplay(Object fragment, TextView locationText, Context context) {
        try {
            Object mCurrentChannelIndex = XposedHelpers.getObjectField(fragment, "mCurrentChannelIndex");
            if (mCurrentChannelIndex != null) {
                int channelNumber = (Integer) mCurrentChannelIndex + 1;
                
                LocationDatabase locationDb = LocationDatabase.getInstance(context);
                LocationDatabase.Location location = locationDb.getLocation(channelNumber);
                
                if (location != null) {
                    String displayText = String.format(java.util.Locale.US, 
                        "%.4f, %.4f\n📍", location.latitude, location.longitude);
                    locationText.setText(displayText);
                    XposedBridge.log(TAG + ": Updated location for channel " + channelNumber + ": " + location.latitude + ", " + location.longitude);
                } else {
                    locationText.setText("📍");
                    XposedBridge.log(TAG + ": No location for channel " + channelNumber);
                }
            }
        } catch (Exception e) {
            XposedBridge.log(TAG + ": Error updating location display: " + e.getMessage());
        }
    }
    
    /**
     * Hook FragmentLocalInformationActivity to display module version
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
                        XposedBridge.log(TAG + ": initView() called, attempting to set module version...");
                        
                        try {
                            // Try to hook the software version TextView instead
                            Object tvSoftwareVersion = XposedHelpers.getObjectField(
                                param.thisObject,
                                "mTvSoftwareVersion"
                            );
                            
                            if (tvSoftwareVersion != null) {
                                // Get current text
                                String originalText = (String) XposedHelpers.callMethod(tvSoftwareVersion, "getText");
                                
                                // Append module version
                                String newText = originalText + "\nDMRModHooks v" + VERSION;
                                
                                XposedHelpers.callMethod(
                                    tvSoftwareVersion,
                                    "setText",
                                    newText
                                );
                                
                                XposedBridge.log(TAG + ": ✓ Module version appended to software version!");
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
    
    /**
     * Hook InterPhoneLocalFragment to add backup/restore button to main menu
     */
    private void hookLocalFragment(XC_LoadPackage.LoadPackageParam lpparam) {
        try {
            Class<?> localFragmentClass = XposedHelpers.findClass(
                "com.pri.prizeinterphone.fragment.InterPhoneLocalFragment",
                lpparam.classLoader
            );
            
            XposedHelpers.findAndHookMethod(
                localFragmentClass,
                "initView",
                View.class,
                new XC_MethodHook() {
                    @Override
                    protected void afterHookedMethod(MethodHookParam param) throws Throwable {
                        XposedBridge.log(TAG + ": InterPhoneLocalFragment.initView() called");
                        
                        try {
                            // Get the fragment instance
                            Object fragment = param.thisObject;
                            
                            // Get the view parameter passed to initView
                            View view = (View) param.args[0];
                            
                            // Add backup button to the view
                            addBackupButtonToFragment(fragment, view);
                            
                        } catch (Exception e) {
                            XposedBridge.log(TAG + ": Error adding backup button: " + e.getMessage());
                            e.printStackTrace();
                        }
                    }
                }
            );
            
            XposedBridge.log(TAG + ": Successfully hooked InterPhoneLocalFragment");
            
        } catch (Throwable t) {
            XposedBridge.log(TAG + ": Error hooking InterPhoneLocalFragment: " + t.getMessage());
            XposedBridge.log(t);
        }
    }
    
    /**
     * Add backup/restore button to local fragment menu
     */
    private void addBackupButtonToFragment(Object fragment, View fragmentView) {
        try {
            // Get the context from fragment
            android.content.Context context = (android.content.Context) XposedHelpers.callMethod(fragment, "getContext");
            if (context == null) {
                XposedBridge.log(TAG + ": Fragment context is null");
                return;
            }
            
            //Try multiple possible IDs for the exit button
            int exitAppId = 0;
            String[] possibleIds = {"local_exit_app", "local_exit", "exit_app", "fragment_local_exit_app"};
            for (String idName : possibleIds) {
                exitAppId = context.getResources().getIdentifier(idName, "id", TARGET_PACKAGE);
                if (exitAppId != 0) {
                    XposedBridge.log(TAG + ": Found exit button with ID: " + idName);
                    break;
                }
            }
            
            if (exitAppId == 0) {
                XposedBridge.log(TAG + ": Could not find exit app resource ID, will add button at end");
                // Just find any LinearLayout or ViewGroup to add the button to
                ViewGroup parentLayout = findViewGroupInHierarchy(fragmentView);
                if (parentLayout != null) {
                    addButtonToLayout(parentLayout, fragment, -1); // -1 = add at end
                } else {
                    XposedBridge.log(TAG + ": Could not find suitable parent layout");
                }
                return;
            }
            
            // Find the exit app view
            View exitAppView = fragmentView.findViewById(exitAppId);
            if (exitAppView == null) {
                XposedBridge.log(TAG + ": Could not find exit app view even though ID exists");
                return;
            }
            
            // Get parent layout
            ViewGroup parentLayout = (ViewGroup) exitAppView.getParent();
            if (parentLayout == null) {
                XposedBridge.log(TAG + ": Could not find parent layout");
                return;
            }
            
            // Find index of exit app view
            int exitIndex = parentLayout.indexOfChild(exitAppView);
            
            addButtonToLayout(parentLayout, fragment, exitIndex);
            
        } catch (Exception e) {
            XposedBridge.log(TAG + ": Error in addBackupButtonToFragment: " + e.getMessage());
            e.printStackTrace();
        }
    }
    
    /**
     * Helper: Find a ViewGroup in the hierarchy
     */
    private ViewGroup findViewGroupInHierarchy(View view) {
        if (view instanceof ViewGroup) {
            ViewGroup group = (ViewGroup) view;
            // Look for a vertical LinearLayout with multiple children
            if (group instanceof LinearLayout && group.getChildCount() > 3) {
                return group;
            }
            // Recurse into children
            for (int i = 0; i < group.getChildCount(); i++) {
                ViewGroup found = findViewGroupInHierarchy(group.getChildAt(i));
                if (found != null) {
                    return found;
                }
            }
        }
        return null;
    }
    
    /**
     * Helper: Add the EXPORT and IMPORT buttons to a layout
     */
    private void addButtonToLayout(ViewGroup parentLayout, Object fragment, int index) {
        try {
            android.content.Context context = (android.content.Context) XposedHelpers.callMethod(fragment, "getContext");
            final android.app.Activity activity = (android.app.Activity) XposedHelpers.callMethod(fragment, "getActivity");
            
            // Get layout params template
            ViewGroup.LayoutParams templateParams;
            if (parentLayout.getChildCount() > 0 && parentLayout.getChildAt(0).getLayoutParams() != null) {
                templateParams = parentLayout.getChildAt(0).getLayoutParams();
            } else {
                templateParams = new ViewGroup.LayoutParams(
                    ViewGroup.LayoutParams.MATCH_PARENT,
                    ViewGroup.LayoutParams.WRAP_CONTENT
                );
            }
            
            // === EXPORT BUTTON ===
            Button exportButton = new Button(context);
            exportButton.setText("📤 EXPORT (OpenGD77)");
            exportButton.setTextSize(16);
            exportButton.setAllCaps(false);
            exportButton.setPadding(20, 20, 20, 20);
            exportButton.setLayoutParams(new ViewGroup.LayoutParams(templateParams));
            
            exportButton.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View v) {
                    XposedBridge.log(TAG + ": Export button clicked");
                   
                    // Run export in background thread to avoid blocking UI
                    // The database operations can take a few seconds for large channel lists
                    new Thread(new Runnable() {
                        @Override
                        public void run() {
                            // DirectDatabaseExporter runs in the app's process with full DB access
                            final boolean success = DirectDatabaseExporter.exportFromAppContext(activity);
                            
                            activity.runOnUiThread(new Runnable() {
                                @Override
                                public void run() {
                                    if (success) {
                                        Toast.makeText(activity, 
                                            "✓ Export successful! v" + VERSION + "\nCheck Download/DMR_Backups/", 
                                            Toast.LENGTH_LONG).show();
                                    } else {
                                        Toast.makeText(activity, 
                                            "❌ Export failed - check logs", 
                                            Toast.LENGTH_LONG).show();
                                    }
                                }
                            });
                        }
                    }).start();
                }
            });
            
            // === IMPORT BUTTON ===
            Button importButton = new Button(context);
            importButton.setText("📥 IMPORT (OpenGD77)");
            importButton.setTextSize(16);
            importButton.setAllCaps(false);
            importButton.setPadding(20, 20, 20, 20);
            importButton.setLayoutParams(new ViewGroup.LayoutParams(templateParams));
            
            importButton.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View v) {
                    XposedBridge.log(TAG + ": Import button clicked");
                    DirectDatabaseImporter.showImportDialog(activity);
                }
            });
            
            // Add buttons at specified index
            if (index >= 0) {
                parentLayout.addView(exportButton, index);
                parentLayout.addView(importButton, index + 1);
                XposedBridge.log(TAG + ": ✓ Export button added at index " + index);
                XposedBridge.log(TAG + ": ✓ Import button added at index " + (index + 1));
            } else {
                parentLayout.addView(exportButton);
                parentLayout.addView(importButton);
                XposedBridge.log(TAG + ": ✓ Export and Import buttons added at end of layout");
            }
            
        } catch (Exception e) {
            XposedBridge.log(TAG + ": Error adding buttons to layout: " + e.getMessage());
            e.printStackTrace();
        }
    }
    
    /**
     * LEGACY: Add backup/restore button to settings screen (not used)
     */
    private void addBackupButton(Activity activity) {
        try {
            // Find the root view
            View rootView = activity.findViewById(android.R.id.content);
            if (rootView == null) {
                XposedBridge.log(TAG + ": Root view not found");
                return;
            }
            
            // Find the parent layout that contains buttons
            ViewGroup parentLayout = findButtonParentLayout(rootView);
            if (parentLayout == null) {
                XposedBridge.log(TAG + ": Could not find button parent layout");
                return;
            }
            
            // Find the exit button to determine position
            int exitButtonIndex = findExitButtonIndex(parentLayout);
            
            // Create backup button
            Button backupButton = new Button(activity);
            backupButton.setText("📦 Backup/Restore (OpenGD77)");
            backupButton.setTextSize(16);
            backupButton.setAllCaps(false);
            
            // Copy layout params from existing button
            if (parentLayout.getChildCount() > 0) {
                View firstButton = parentLayout.getChildAt(0);
                ViewGroup.LayoutParams params = firstButton.getLayoutParams();
                if (params != null) {
                    ViewGroup.LayoutParams newParams = new ViewGroup.LayoutParams(params);
                    backupButton.setLayoutParams(newParams);
                }
            }
            
            // Set click listener
            backupButton.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View v) {
                    // Export directly from app context - we're running IN the target app!
                    XposedBridge.log(TAG + ": Backup button clicked - exporting from app context");
                    
                    new Thread(new Runnable() {
                        @Override
                        public void run() {
                            final boolean success = DirectDatabaseExporter.exportFromAppContext(activity);
                            
                            activity.runOnUiThread(new Runnable() {
                                @Override
                                public void run() {
                                    if (success) {
                                        Toast.makeText(activity, 
                                            "✓ Export successful! Check Download/DMR_Backups/", 
                                            Toast.LENGTH_LONG).show();
                                    } else {
                                        Toast.makeText(activity, 
                                            "❌ Export failed - check logs", 
                                            Toast.LENGTH_LONG).show();
                                    }
                                }
                            });
                        }
                    }).start();
                }
            });
            
            // Add button above exit button (or at end if exit not found)
            if (exitButtonIndex >= 0) {
                parentLayout.addView(backupButton, exitButtonIndex);
                XposedBridge.log(TAG + ": ✓ Backup button added at index " + exitButtonIndex + " (above exit button)");
            } else {
                parentLayout.addView(backupButton);
                XposedBridge.log(TAG + ": ✓ Backup button added at end of layout");
            }
            
            Toast.makeText(activity, "✓ Backup button added!", Toast.LENGTH_SHORT).show();
            
        } catch (Exception e) {
            XposedBridge.log(TAG + ": Error in addBackupButton: " + e.getMessage());
            e.printStackTrace();
        }
    }
    
    /**
     * Find the parent layout that contains buttons
     */
    private ViewGroup findButtonParentLayout(View view) {
        if (view instanceof Button) {
            ViewGroup parent = (ViewGroup) view.getParent();
            if (parent instanceof LinearLayout) {
                return parent;
            }
        }
        
        if (view instanceof ViewGroup) {
            ViewGroup group = (ViewGroup) view;
            for (int i = 0; i < group.getChildCount(); i++) {
                ViewGroup result = findButtonParentLayout(group.getChildAt(i));
                if (result != null) {
                    return result;
                }
            }
        }
        
        return null;
    }
    
    /**
     * Find the index of the exit button
     */
    private int findExitButtonIndex(ViewGroup parentLayout) {
        for (int i = 0; i < parentLayout.getChildCount(); i++) {
            View child = parentLayout.getChildAt(i);
            if (child instanceof Button) {
                Button button = (Button) child;
                String text = button.getText().toString().toLowerCase();
                if (text.contains("exit") || text.contains("退出") || text.contains("关闭")) {
                    XposedBridge.log(TAG + ": Found exit button at index " + i + ": " + button.getText());
                    return i;
                }
            }
        }
        return -1;
    }
    
    /**
     * Open the BackupActivity
     */
    private void openBackupActivity(Activity activity) {
        try {
            // Create context for the module package
            android.content.Context moduleContext = activity.createPackageContext(
                "com.dmrmod.hooks",
                android.content.Context.CONTEXT_INCLUDE_CODE | android.content.Context.CONTEXT_IGNORE_SECURITY
            );
            
            // Create intent using module context
            Intent intent = new Intent();
            intent.setClassName("com.dmrmod.hooks", "com.dmrmod.hooks.BackupActivity");
            intent.putExtra("target_package", TARGET_PACKAGE);
            intent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
            
            // Start activity using module context
            moduleContext.startActivity(intent);
            
            XposedBridge.log(TAG + ": Launched BackupActivity via module context");
        } catch (Exception e) {
            XposedBridge.log(TAG + ": Error launching BackupActivity: " + e.getMessage());
            e.printStackTrace();
            Toast.makeText(activity, "Error opening backup: " + e.getMessage(), Toast.LENGTH_LONG).show();
        }
    }
}
