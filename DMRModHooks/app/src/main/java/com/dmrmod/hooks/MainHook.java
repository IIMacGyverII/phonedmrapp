package com.dmrmod.hooks;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.location.Address;
import android.location.Geocoder;
import android.os.Bundle;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Button;
import android.widget.FrameLayout;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.TextView;
import android.widget.Toast;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.List;

import org.json.JSONArray;
import org.json.JSONObject;

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
    private static final String VERSION = "1.4.8";
    private static final String TARGET_PACKAGE = "com.pri.prizeinterphone";
    
    // Caller identification state
    private static volatile int currentCallerDmrId = 0;
    private static volatile String currentCallerName = null;
    private static volatile boolean isReceiving = false;
    private static TextView callerDisplayTextView = null;
    
    // DMR activity history (last 3 activities with timestamps per channel)
    private static TextView dmrActivityIndicator = null;
    private static TextView activityHeaderTextView = null;
    private static final java.util.LinkedList<String> activityHistory = new java.util.LinkedList<>();
    private static final int MAX_ACTIVITY_HISTORY = 3;
    private static volatile int currentChannelNumber = -1;
    private static volatile int currentChannelType = 0; // 0=Digital/DMR, 1=Analog/FM
    private static volatile int currentRxToneType = 0; // 0=None, 1=CTCSS, 2=FDCS, 3=BDCS
    private static volatile int currentRxToneSubCode = 0; // Index into tone array
    private static android.content.Context appContext = null;
    
    // Audio recording state
    private static volatile boolean isRecordingEnabled = false;
    private static volatile boolean isCurrentlyRecording = false;
    private static volatile String currentRecordingPath = null;
    private static volatile String currentRecordingTimestamp = null;  // Store timestamp for renaming
    private static volatile String currentRecordingFolder = null;     // Store folder for renaming
    private static volatile String currentChannelName = "Unknown";
    private static android.widget.ToggleButton recordingToggleButton = null;
    
    // PCM recording (direct audio capture from AudioTrack)
    private static volatile java.io.FileOutputStream pcmOutputStream = null;
    private static volatile long pcmDataSize = 0; // Track written bytes for WAV header
    
    // Signal strength (RSSI) state
    private static volatile int currentRssi = -999;  // dBm value, -999 = no signal
    private static TextView rssiDisplayTextView = null;
    
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
        
        // Hook for DMR caller identification
        hookModuleStatusHandler(lpparam);
        hookDigitalAudioHandler(lpparam);
        
        // Hook for audio recording (capture PCM data from AudioTrack)
        hookPCMReceiveManager(lpparam);
        
        // Hook for signal strength (RSSI) display
        hookSignalMessageHandler(lpparam);
        
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
                        
                        // Create Recordings folder structure
                        try {
                            java.io.File downloadDir = android.os.Environment.getExternalStoragePublicDirectory(android.os.Environment.DIRECTORY_DOWNLOADS);
                            java.io.File dmrDir = new java.io.File(downloadDir, "DMR");
                            java.io.File recordingsDir = new java.io.File(dmrDir, "Recordings");
                            
                            if (!recordingsDir.exists()) {
                                if (recordingsDir.mkdirs()) {
                                    XposedBridge.log(TAG + ": Created Recordings folder: " + recordingsDir.getAbsolutePath());
                                } else {
                                    XposedBridge.log(TAG + ": Failed to create Recordings folder");
                                }
                            } else {
                                XposedBridge.log(TAG + ": Recordings folder already exists");
                            }
                        } catch (Exception e) {
                            XposedBridge.log(TAG + ": Error creating Recordings folder: " + e.getMessage());
                        }
                        
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
                            
                            // Store context for later use in database operations
                            appContext = context.getApplicationContext();
                            
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
                            
                            // Create horizontal container for info text and location
                            if (childCount > 1) {
                                View infoText = rootLayout.getChildAt(1);
                                
                                // Create horizontal container
                                LinearLayout horizontalContainer = new LinearLayout(context);
                                horizontalContainer.setOrientation(LinearLayout.HORIZONTAL);
                                LinearLayout.LayoutParams containerParams = new LinearLayout.LayoutParams(
                                    LinearLayout.LayoutParams.MATCH_PARENT,
                                    LinearLayout.LayoutParams.WRAP_CONTENT
                                );
                                containerParams.topMargin = margin5dp;
                                horizontalContainer.setLayoutParams(containerParams);
                                
                                // Remove infoText from parent and add to container
                                rootLayout.removeView(infoText);
                                
                                if (infoText instanceof LinearLayout) {
                                    LinearLayout infoLayout = (LinearLayout) infoText;
                                    
                                    try {
                                        java.lang.reflect.Method setShowDividers = LinearLayout.class.getMethod("setShowDividers", int.class);
                                        setShowDividers.invoke(infoLayout, 2);
                                        
                                        java.lang.reflect.Method setDividerPadding = LinearLayout.class.getMethod("setDividerPadding", int.class);
                                        int margin1dp = (int) (1 * context.getResources().getDisplayMetrics().density);
                                        setDividerPadding.invoke(infoLayout, margin1dp);
                                        
                                        XposedBridge.log(TAG + ": ✓ Successfully reduced text spacing to 1dp");
                                    } catch (Exception e) {
                                        XposedBridge.log(TAG + ": Error setting dividers: " + e.getMessage());
                                    }
                                }
                                
                                // Make infoText take 70% width
                                LinearLayout.LayoutParams infoParams = new LinearLayout.LayoutParams(
                                    0,
                                    LinearLayout.LayoutParams.WRAP_CONTENT,
                                    0.7f
                                );
                                infoText.setLayoutParams(infoParams);
                                horizontalContainer.addView(infoText);
                                
                                // Create location TextView (30% width, right-aligned)
                                TextView locationText = new TextView(context);
                                locationText.setTag("DMR_LOCATION_TEXT");
                                LinearLayout.LayoutParams locationParams = new LinearLayout.LayoutParams(
                                    0,
                                    LinearLayout.LayoutParams.WRAP_CONTENT,
                                    0.3f
                                );
                                locationParams.rightMargin = margin10dp;
                                locationText.setLayoutParams(locationParams);
                                locationText.setTextColor(0xFFFFFFFF);  // White text
                                locationText.setTextSize(12);
                                locationText.setGravity(android.view.Gravity.END | android.view.Gravity.CENTER_VERTICAL);  // Right align text
                                locationText.setText("📍");  // Default icon
                                
                                horizontalContainer.addView(locationText);
                                
                                // Add container back to rootLayout at position 1
                                rootLayout.addView(horizontalContainer, 1);
                                
                                // Update location for current channel
                                updateLocationDisplay(param.thisObject, locationText, context);
                                
                                XposedBridge.log(TAG + ": ✓ Created horizontal layout with info (70%) and location (30%)");
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
                                
                                // Add caller display TextView to borderbox (top-left)
                                TextView callerText = new TextView(context);
                                callerText.setTag("DMR_CALLER_TEXT");
                                FrameLayout.LayoutParams callerParams = new FrameLayout.LayoutParams(
                                    FrameLayout.LayoutParams.WRAP_CONTENT,
                                    FrameLayout.LayoutParams.WRAP_CONTENT
                                );
                                callerParams.gravity = android.view.Gravity.TOP | android.view.Gravity.START;
                                callerParams.topMargin = (int) (8 * context.getResources().getDisplayMetrics().density);
                                callerParams.leftMargin = (int) (8 * context.getResources().getDisplayMetrics().density);
                                callerText.setLayoutParams(callerParams);
                                callerText.setTextColor(0xFF00FF00);  // Green text for incoming
                                callerText.setTextSize(14);
                                callerText.setText("");  // Empty by default
                                callerText.setVisibility(View.GONE);  // Hidden initially
                                
                                borderBox.addView(callerText);
                                
                                // Store reference for updates
                                callerDisplayTextView = callerText;
                                
                                // Create a small bordered box for activity history (top-right corner)
                                LinearLayout activityBox = new LinearLayout(context);
                                activityBox.setOrientation(LinearLayout.VERTICAL);
                                activityBox.setTag("DMR_ACTIVITY_BOX");
                                FrameLayout.LayoutParams activityBoxParams = new FrameLayout.LayoutParams(
                                    FrameLayout.LayoutParams.WRAP_CONTENT,
                                    FrameLayout.LayoutParams.WRAP_CONTENT
                                );
                                activityBoxParams.gravity = android.view.Gravity.TOP | android.view.Gravity.END;
                                activityBoxParams.topMargin = (int) (8 * context.getResources().getDisplayMetrics().density);
                                activityBoxParams.rightMargin = (int) (8 * context.getResources().getDisplayMetrics().density);
                                
                                // Create border for activity box
                                android.graphics.drawable.GradientDrawable activityBoxDrawable = new android.graphics.drawable.GradientDrawable();
                                activityBoxDrawable.setShape(android.graphics.drawable.GradientDrawable.RECTANGLE);
                                activityBoxDrawable.setStroke(
                                    (int) (1 * context.getResources().getDisplayMetrics().density),
                                    0x8800BFFF  // Semi-transparent blue border
                                );
                                activityBoxDrawable.setCornerRadius(8 * context.getResources().getDisplayMetrics().density);
                                activityBoxDrawable.setColor(0x10000000);  // Very subtle dark background
                                
                                activityBox.setBackground(activityBoxDrawable);
                                activityBox.setLayoutParams(activityBoxParams);
                                int padding = (int) (6 * context.getResources().getDisplayMetrics().density);
                                activityBox.setPadding(padding, padding, padding, padding);
                                
                                // Add header TextView
                                TextView activityHeader = new TextView(context);
                                activityHeader.setTag("ACTIVITY_HISTORY_HEADER");
                                activityHeader.setText("DMR History");  // Default, will be updated based on channel type
                                activityHeader.setTextColor(0xFF00BFFF);  // Deep sky blue
                                activityHeader.setTextSize(9);
                                activityHeader.setTypeface(null, android.graphics.Typeface.BOLD);
                                LinearLayout.LayoutParams headerParams = new LinearLayout.LayoutParams(
                                    LinearLayout.LayoutParams.WRAP_CONTENT,
                                    LinearLayout.LayoutParams.WRAP_CONTENT
                                );
                                headerParams.bottomMargin = (int) (4 * context.getResources().getDisplayMetrics().density);
                                activityHeader.setLayoutParams(headerParams);
                                activityBox.addView(activityHeader);
                                
                                // Store reference for dynamic updates
                                activityHeaderTextView = activityHeader;
                                
                                // Add DMR activity indicator inside the activity box
                                TextView activityIndicator = new TextView(context);
                                activityIndicator.setTag("DMR_ACTIVITY_INDICATOR");
                                LinearLayout.LayoutParams activityParams = new LinearLayout.LayoutParams(
                                    LinearLayout.LayoutParams.WRAP_CONTENT,
                                    LinearLayout.LayoutParams.WRAP_CONTENT
                                );
                                activityIndicator.setLayoutParams(activityParams);
                                activityIndicator.setTextColor(0xFF00BFFF);  // Deep sky blue for data
                                activityIndicator.setTextSize(10);  // Slightly smaller text
                                activityIndicator.setText("");  // Empty by default
                                activityIndicator.setVisibility(View.GONE);  // Hidden initially
                                
                                activityBox.addView(activityIndicator);
                                borderBox.addView(activityBox);
                                
                                // Store reference for updates
                                dmrActivityIndicator = activityIndicator;
                                
                                // Create RSSI display box (above the main border box)
                                LinearLayout rssiBox = new LinearLayout(context);
                                rssiBox.setOrientation(LinearLayout.HORIZONTAL);
                                rssiBox.setTag("DMR_RSSI_BOX");
                                LinearLayout.LayoutParams rssiBoxParams = new LinearLayout.LayoutParams(
                                    LinearLayout.LayoutParams.MATCH_PARENT,
                                    LinearLayout.LayoutParams.WRAP_CONTENT
                                );
                                rssiBoxParams.leftMargin = margin10dp;
                                rssiBoxParams.rightMargin = margin10dp;
                                rssiBoxParams.topMargin = margin10dp;
                                rssiBoxParams.bottomMargin = (int) (4 * context.getResources().getDisplayMetrics().density);
                                
                                // Create border for RSSI box
                                android.graphics.drawable.GradientDrawable rssiBoxDrawable = new android.graphics.drawable.GradientDrawable();
                                rssiBoxDrawable.setShape(android.graphics.drawable.GradientDrawable.RECTANGLE);
                                rssiBoxDrawable.setStroke(
                                    (int) (2 * context.getResources().getDisplayMetrics().density),
                                    0xAAFFFF00  // Yellow border
                                );
                                rssiBoxDrawable.setCornerRadius(8 * context.getResources().getDisplayMetrics().density);
                                rssiBoxDrawable.setColor(0x15FFFF00);  // Subtle yellow background
                                
                                rssiBox.setBackground(rssiBoxDrawable);
                                rssiBox.setLayoutParams(rssiBoxParams);
                                int rssiPadding = (int) (8 * context.getResources().getDisplayMetrics().density);
                                rssiBox.setPadding(rssiPadding, rssiPadding, rssiPadding, rssiPadding);
                                rssiBox.setGravity(android.view.Gravity.CENTER);
                                
                                // Add RSSI value TextView
                                TextView rssiText = new TextView(context);
                                rssiText.setTag("DMR_RSSI_TEXT");
                                rssiText.setTextColor(0xFFFFFF00);  // Yellow text
                                rssiText.setTextSize(16);
                                rssiText.setTypeface(null, android.graphics.Typeface.BOLD);
                                rssiText.setText("");  // Empty by default
                                rssiText.setGravity(android.view.Gravity.CENTER);
                                
                                rssiBox.addView(rssiText);
                                rssiBox.setVisibility(View.GONE);  // Hidden initially
                                
                                // Store reference for updates
                                rssiDisplayTextView = rssiText;
                                
                                // Insert RSSI box at index 2
                                rootLayout.addView(rssiBox, 2);
                                XposedBridge.log(TAG + ": ✓ Added RSSI box at index 2");
                                
                                // Insert borderbox at index 3 (pushed down by RSSI box)
                                rootLayout.addView(borderBox, 3);
                                XposedBridge.log(TAG + ": ✓ Added borderbox at index 3 (250dp)");
                                
                                // Create spacer
                                View spacer = new View(context);
                                spacer.setTag("DMR_SPACER");
                                LinearLayout.LayoutParams spacerParams = new LinearLayout.LayoutParams(
                                    LinearLayout.LayoutParams.MATCH_PARENT,
                                    0
                                );
                                spacerParams.weight = 1.0f;
                                spacer.setLayoutParams(spacerParams);
                                
                                rootLayout.addView(spacer, 4);
                                XposedBridge.log(TAG + ": ✓ Added spacer at index 4");
                                
                                // Create a container for PTT button and recording toggle
                                FrameLayout buttonContainer = new FrameLayout(context);
                                LinearLayout.LayoutParams containerParams = new LinearLayout.LayoutParams(
                                    LinearLayout.LayoutParams.MATCH_PARENT,
                                    LinearLayout.LayoutParams.WRAP_CONTENT
                                );
                                containerParams.bottomMargin = margin10dp;
                                buttonContainer.setLayoutParams(containerParams);
                                
                                rootLayout.addView(buttonContainer, 5);
                                XposedBridge.log(TAG + ": ✓ Added button container at index 5");
                                
                                // PTT button now at index 4 (inside container, centered)
                                rootLayout.removeView(pttButton);
                                FrameLayout.LayoutParams pttParams = new FrameLayout.LayoutParams(
                                    FrameLayout.LayoutParams.WRAP_CONTENT,
                                    FrameLayout.LayoutParams.WRAP_CONTENT
                                );
                                pttParams.gravity = android.view.Gravity.CENTER;
                                pttButton.setLayoutParams(pttParams);
                                buttonContainer.addView(pttButton);
                                pttButton.setVisibility(View.VISIBLE);
                                pttButton.bringToFront();
                                XposedBridge.log(TAG + ": ✓ PTT button centered in container");
                                
                                // Create recording toggle button (right-aligned)
                                android.widget.ToggleButton recordToggle = new android.widget.ToggleButton(context);
                                recordToggle.setTag("DMR_RECORDING_TOGGLE");
                                recordToggle.setTextOn("🔴");  // Red circle when recording enabled
                                recordToggle.setTextOff("⚪");  // White circle when recording disabled
                                recordToggle.setChecked(false);
                                
                                FrameLayout.LayoutParams toggleParams = new FrameLayout.LayoutParams(
                                    (int) (60 * context.getResources().getDisplayMetrics().density),  // 60dp width
                                    (int) (60 * context.getResources().getDisplayMetrics().density)   // 60dp height
                                );
                                toggleParams.gravity = android.view.Gravity.END | android.view.Gravity.CENTER_VERTICAL;
                                toggleParams.rightMargin = (int) (16 * context.getResources().getDisplayMetrics().density);
                                recordToggle.setLayoutParams(toggleParams);
                                recordToggle.setTextSize(24);
                                
                                // Store reference
                                recordingToggleButton = recordToggle;
                                
                                // Set click listener for toggle
                                recordToggle.setOnClickListener(new View.OnClickListener() {
                                    @Override
                                    public void onClick(View v) {
                                        isRecordingEnabled = recordToggle.isChecked();
                                        String status = isRecordingEnabled ? "enabled" : "disabled";
                                        XposedBridge.log(TAG + ": Recording " + status);
                                        Toast.makeText(context, 
                                            "Recording " + status, 
                                            Toast.LENGTH_SHORT
                                        ).show();
                                        
                                        // Stop any current recording if disabling
                                        if (!isRecordingEnabled && isCurrentlyRecording) {
                                            stopRecording();
                                        }
                                        
                                        // Start recording immediately if enabling and already receiving
                                        if (isRecordingEnabled && isReceiving && !isCurrentlyRecording) {
                                            XposedBridge.log(TAG + ": Channel already receiving, starting recording immediately");
                                            startRecording();
                                        }
                                    }
                                });
                                
                                buttonContainer.addView(recordToggle);
                                XposedBridge.log(TAG + ": ✓ Added recording toggle on right side");
                                
                                XposedBridge.log(TAG + ": Final child count: " + rootLayout.getChildCount());
                            }
                            
                            // Get and set initial channel number and type, then load its history
                            try {
                                Object channelData = XposedHelpers.getObjectField(param.thisObject, "mCurrentChannelData");
                                if (channelData != null) {
                                    int channelNumber = XposedHelpers.getIntField(channelData, "number");
                                    int channelType = XposedHelpers.getIntField(channelData, "type");  // 0=Digital, 1=Analog
                                    int rxType = XposedHelpers.getIntField(channelData, "rxType");  // 0=None, 1=CTCSS, 2=FDCS, 3=BDCS
                                    int rxSubCode = XposedHelpers.getIntField(channelData, "rxSubCode");  // Tone index
                                    
                                    currentChannelNumber = channelNumber;
                                    currentChannelType = channelType;
                                    currentRxToneType = rxType;
                                    currentRxToneSubCode = rxSubCode;
                                    
                                    String toneInfo = ToneConverter.formatForDisplay(rxType, rxSubCode);
                                    XposedBridge.log(TAG + ": Initial channel: #" + channelNumber + " (" + (channelType == 0 ? "Digital" : "Analog") + "), RX Tone: " + toneInfo);
                                    updateHistoryHeader();
                                    loadChannelHistory(channelNumber, context);
                                }
                            } catch (Exception e2) {
                                XposedBridge.log(TAG + ": Error getting initial channel: " + e2.getMessage());
                            }
                            
                        } catch (Exception e) {
                            XposedBridge.log(TAG + ": Error modifying TalkBack layout: " + e.getMessage());
                            XposedBridge.log(TAG + ": " + android.util.Log.getStackTraceString(e));
                        }
                    }
                }
            );
            
            // Hook updateUI to refresh location display and load channel history when channel changes
            XposedHelpers.findAndHookMethod(
                fragmentClass,
                "updateUI",
                new XC_MethodHook() {
                    @Override
                    protected void afterHookedMethod(MethodHookParam param) throws Throwable {
                        try {
                            // Get current channel number and type
                            Object channelData = XposedHelpers.getObjectField(param.thisObject, "mCurrentChannelData");
                            if (channelData != null) {
                                int channelNumber = XposedHelpers.getIntField(channelData, "number");
                                int channelType = XposedHelpers.getIntField(channelData, "type");  // 0=Digital, 1=Analog
                                int rxType = XposedHelpers.getIntField(channelData, "rxType");  // 0=None, 1=CTCSS, 2=FDCS, 3=BDCS
                                int rxSubCode = XposedHelpers.getIntField(channelData, "rxSubCode");  // Tone index
                                String channelName = (String) XposedHelpers.getObjectField(channelData, "name");  // Channel name for recordings
                                
                                // If channel changed, load history for new channel
                                if (channelNumber != currentChannelNumber) {
                                    String toneInfo = ToneConverter.formatForDisplay(rxType, rxSubCode);
                                    XposedBridge.log(TAG + ": Channel changed from " + currentChannelNumber + " to " + channelNumber + " (" + (channelType == 0 ? "Digital" : "Analog") + "), RX Tone: " + toneInfo);
                                    currentChannelNumber = channelNumber;
                                    currentChannelType = channelType;
                                    currentRxToneType = rxType;
                                    currentRxToneSubCode = rxSubCode;
                                    currentChannelName = (channelName != null && !channelName.isEmpty()) ? channelName : ("Channel_" + channelNumber);
                                    
                                    // Clear DMR caller display when switching to analog channel
                                    if (channelType == 1) {  // Analog channel
                                        currentCallerDmrId = 0;
                                        currentCallerName = null;
                                        isReceiving = false;
                                        if (callerDisplayTextView != null) {
                                            callerDisplayTextView.post(() -> {
                                                callerDisplayTextView.setText("");
                                                callerDisplayTextView.setVisibility(View.GONE);
                                            });
                                        }
                                        XposedBridge.log(TAG + ": Cleared DMR caller display on switch to analog channel");
                                    }
                                    
                                    updateHistoryHeader();
                                    
                                    Object mLocalViewObj = XposedHelpers.getObjectField(param.thisObject, "mLocalView");
                                    if (mLocalViewObj instanceof ViewGroup) {
                                        ViewGroup rootLayout = (ViewGroup) mLocalViewObj;
                                        loadChannelHistory(channelNumber, rootLayout.getContext());
                                    }
                                }
                            }
                            
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
                    // Try to get location name using Geocoder
                    String displayText;
                    try {
                        Geocoder geocoder = new Geocoder(context, java.util.Locale.US);
                        if (geocoder.isPresent()) {
                            List<Address> addresses = geocoder.getFromLocation(location.latitude, location.longitude, 1);
                            if (addresses != null && !addresses.isEmpty()) {
                                Address address = addresses.get(0);
                                String city = address.getLocality();
                                String state = address.getAdminArea();
                                
                                // Display location name immediately
                                if (city != null && state != null) {
                                    displayText = city + ", " + state + "\n📍";
                                } else if (city != null) {
                                    displayText = city + "\n📍";
                                } else {
                                    displayText = String.format(java.util.Locale.US, 
                                        "%.4f, %.4f\n📍", location.latitude, location.longitude);
                                }
                                locationText.setText(displayText);
                                
                                // Fetch elevation in background thread
                                final String baseText = displayText.replace("\n📍", "");
                                final TextView textView = locationText;
                                new Thread(() -> {
                                    try {
                                        double elevation = getElevation(location.latitude, location.longitude);
                                        if (elevation > 0) {
                                            int elevationFt = (int) (elevation * 3.28084);
                                            final String elevationStr = String.format(java.util.Locale.US, 
                                                "%dft (%.0fm)", elevationFt, elevation);
                                            // Update UI on main thread
                                            textView.post(() -> {
                                                textView.setText(baseText + "\n" + elevationStr + " 📍");
                                            });
                                        }
                                    } catch (Exception e) {
                                        XposedBridge.log(TAG + ": Could not get elevation: " + e.getMessage());
                                    }
                                }).start();
                                
                                XposedBridge.log(TAG + ": Geocoded location for channel " + channelNumber + ": " + baseText);
                            } else {
                                // Geocoder returned no results, show coordinates
                                displayText = String.format(java.util.Locale.US, 
                                    "%.4f, %.4f\n📍", location.latitude, location.longitude);
                                locationText.setText(displayText);
                                
                                // Fetch elevation in background
                                fetchAndDisplayElevation(location, locationText, displayText.replace("\n📍", ""));
                                XposedBridge.log(TAG + ": No geocoding results, showing coordinates for channel " + channelNumber);
                            }
                        } else {
                            // Geocoder not available, show coordinates
                            displayText = String.format(java.util.Locale.US, 
                                "%.4f, %.4f\n📍", location.latitude, location.longitude);
                            locationText.setText(displayText);
                            
                            // Fetch elevation in background
                            fetchAndDisplayElevation(location, locationText, displayText.replace("\n📍", ""));
                            XposedBridge.log(TAG + ": Geocoder not available, showing coordinates for channel " + channelNumber);
                        }
                    } catch (Exception e) {
                        // Geocoder failed, fallback to coordinates
                        displayText = String.format(java.util.Locale.US, 
                            "%.4f, %.4f\n📍", location.latitude, location.longitude);
                        locationText.setText(displayText);
                        
                        // Fetch elevation in background
                        fetchAndDisplayElevation(location, locationText, displayText.replace("\n📍", ""));
                        XposedBridge.log(TAG + ": Geocoder error: " + e.getMessage() + ", showing coordinates");
                    }
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
     * Helper to fetch elevation in background and update TextView
     */
    private void fetchAndDisplayElevation(LocationDatabase.Location location, TextView locationText, String baseText) {
        new Thread(() -> {
            try {
                double elevation = getElevation(location.latitude, location.longitude);
                if (elevation > 0) {
                    int elevationFt = (int) (elevation * 3.28084);
                    final String elevationStr = String.format(java.util.Locale.US, 
                        "%dft (%.0fm)", elevationFt, elevation);
                    locationText.post(() -> {
                        locationText.setText(baseText + "\n" + elevationStr + " 📍");
                    });
                }
            } catch (Exception e) {
                XposedBridge.log(TAG + ": Could not get elevation: " + e.getMessage());
            }
        }).start();
    }
    
    /**
     * Get elevation from Open-Elevation API
     * @param latitude Latitude in decimal degrees
     * @param longitude Longitude in decimal degrees
     * @return Elevation in meters, or 0 if unavailable
     */
    private double getElevation(double latitude, double longitude) {
        HttpURLConnection connection = null;
        try {
            // Open-Elevation API endpoint (free, no API key required)
            String urlString = String.format(java.util.Locale.US, 
                "https://api.open-elevation.com/api/v1/lookup?locations=%.6f,%.6f",
                latitude, longitude);
            
            URL url = new URL(urlString);
            connection = (HttpURLConnection) url.openConnection();
            connection.setRequestMethod("GET");
            connection.setConnectTimeout(5000); // 5 second timeout
            connection.setReadTimeout(5000);
            
            int responseCode = connection.getResponseCode();
            if (responseCode == HttpURLConnection.HTTP_OK) {
                BufferedReader reader = new BufferedReader(
                    new InputStreamReader(connection.getInputStream()));
                StringBuilder response = new StringBuilder();
                String line;
                while ((line = reader.readLine()) != null) {
                    response.append(line);
                }
                reader.close();
                
                // Parse JSON response
                JSONObject json = new JSONObject(response.toString());
                JSONArray results = json.getJSONArray("results");
                if (results.length() > 0) {
                    JSONObject result = results.getJSONObject(0);
                    double elevation = result.getDouble("elevation");
                    XposedBridge.log(TAG + ": Got elevation: " + elevation + "m");
                    return elevation;
                }
            } else {
                XposedBridge.log(TAG + ": Elevation API returned code: " + responseCode);
            }
        } catch (Exception e) {
            XposedBridge.log(TAG + ": Elevation API error: " + e.getMessage());
        } finally {
            if (connection != null) {
                connection.disconnect();
            }
        }
        return 0;
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
     * Hook ModuleStatusMessageHandler to detect incoming DMR transmissions
     */
    private void hookModuleStatusHandler(XC_LoadPackage.LoadPackageParam lpparam) {
        try {
            Class<?> handlerClass = XposedHelpers.findClass(
                "com.pri.prizeinterphone.handler.ModuleStatusMessageHandler",
                lpparam.classLoader
            );
            
            XposedHelpers.findAndHookMethod(
                handlerClass,
                "handle",
                XposedHelpers.findClass("com.pri.prizeinterphone.message.ModuleStatusMessage", lpparam.classLoader),
                new XC_MethodHook() {
                    @Override
                    protected void afterHookedMethod(MethodHookParam param) throws Throwable {
                        try {
                            Object message = param.args[0];
                            byte status = (Byte) XposedHelpers.callMethod(message, "getStatus");
                            
                            // Detect ALL DMR activity types
                            String activityType = "";
                            boolean showActivity = false;
                            
                            switch (status) {
                                case 1:  // RECEIVE_START (used for both digital AND analog)
                                case 10: // MIX_CHECK_DIGITAL_RECEIVE_START
                                    XposedBridge.log(TAG + ": RECEIVE_START detected (type: " + currentChannelType + ")");
                                    isReceiving = true;
                                    
                                    // Start recording if enabled
                                    if (isRecordingEnabled) {
                                        startRecording();
                                    }
                                    
                                    // Update RSSI display
                                    updateRssiDisplay();
                                    
                                    if (currentChannelType == 0) {
                                        // Digital channel - query DMR caller info
                                        XposedBridge.log(TAG + ": Digital channel - querying caller info");
                                        queryCallerInfo(lpparam.classLoader);
                                        // Activity indicator will be updated in DigitalAudioMessageHandler with DMR ID
                                    } else {
                                        // Analog channel - show receiving message with tone
                                        XposedBridge.log(TAG + ": Analog channel - showing receiving message");
                                        
                                        // Only show tone info if a tone is configured (not None)
                                        String displayText = "📻 Receiving...";
                                        if (currentRxToneType > 0) {  // 0 = None, 1 = CTCSS, 2 = FDCS, 3 = BDCS
                                            String toneDisplay = ToneConverter.formatForDisplay(currentRxToneType, currentRxToneSubCode);
                                            displayText += "\n" + toneDisplay;
                                        }
                                        updateCallerDisplay(displayText);
                                        // Update activity indicator for analog
                                        updateActivityIndicator("📻 Analog RX");
                                    }
                                    break;
                                    
                                case 2:  // RECEIVE_STOP (used for both digital AND analog)
                                case 11: // MIX_CHECK_DIGITAL_RECEIVE_STOP
                                    XposedBridge.log(TAG + ": RECEIVE_STOP detected (type: " + currentChannelType + ")");
                                    isReceiving = false;
                                    
                                    // Stop recording if currently recording
                                    if (isCurrentlyRecording) {
                                        stopRecording();
                                    }
                                    
                                    // Hide RSSI display
                                    hideRssiDisplay();
                                    
                                    clearCallerDisplay();
                                    // Don't clear activity history - let it persist
                                    break;
                                    
                                case 3:  // SEND_START
                                    XposedBridge.log(TAG + ": SEND_START detected");
                                    activityType = "📻 Voice TX";
                                    showActivity = true;
                                    break;
                                    
                                case 4:  // SEND_STOP
                                    XposedBridge.log(TAG + ": SEND_STOP detected");
                                    // Don't clear activity history - let it persist
                                    break;
                                    
                                case 5:  // SMS_RECEIVED
                                    XposedBridge.log(TAG + ": SMS_RECEIVED detected");
                                    activityType = "💬 SMS RX";
                                    showActivity = true;
                                    break;
                                    
                                case 7:  // CHANNEL_BUSY
                                    XposedBridge.log(TAG + ": CHANNEL_BUSY detected");
                                    activityType = "⚡ Channel Busy";
                                    showActivity = true;
                                    break;
                                    
                                case 8:  // SMS_SENT_SUCCESS
                                    XposedBridge.log(TAG + ": SMS_SENT_SUCCESS detected");
                                    activityType = "💬 SMS TX ✓";
                                    showActivity = true;
                                    break;
                                    
                                case 9:  // SMS_SENT_FAIL
                                    XposedBridge.log(TAG + ": SMS_SENT_FAIL detected");
                                    activityType = "💬 SMS TX ✗";
                                    showActivity = true;
                                    break;
                                    
                                case 12: // MIX_CHECK_ANALOG_RECEIVE_START
                                    XposedBridge.log(TAG + ": ANALOG_RECEIVE_START detected (type: " + currentChannelType + ")");
                                    activityType = "📻 Analog RX";
                                    showActivity = true;
                                    
                                    // Always clear DMR state and display receiving message for analog
                                    currentCallerDmrId = 0;
                                    currentCallerName = null;
                                    isReceiving = true;
                                    
                                    String toneDisplay = ToneConverter.formatForDisplay(currentRxToneType, currentRxToneSubCode);
                                    updateCallerDisplay("📻 Receiving...\n" + toneDisplay);
                                    XposedBridge.log(TAG + ": Displayed analog receiving message with tone: " + toneDisplay);
                                    break;
                                    
                                case 13: // MIX_CHECK_ANALOG_RECEIVE_STOP
                                    XposedBridge.log(TAG + ": ANALOG_RECEIVE_STOP detected (type: " + currentChannelType + ")");
                                    isReceiving = false;
                                    clearCallerDisplay();  // Clear the tone display
                                    // Don't clear activity history - let it persist
                                    break;
                            }
                            
                            if (showActivity) {
                                updateActivityIndicator(activityType);
                            }
                        } catch (Exception e) {
                            XposedBridge.log(TAG + ": Error in ModuleStatusMessageHandler hook: " + e.getMessage());
                        }
                    }
                }
            );
            
            XposedBridge.log(TAG + ": Successfully hooked ModuleStatusMessageHandler");
            
        } catch (Throwable t) {
            XposedBridge.log(TAG + ": Error hooking ModuleStatusMessageHandler: " + t.getMessage());
            XposedBridge.log(t);
        }
    }
    
    /**
     * Hook DigitalAudioMessageHandler to decode caller DMR ID
     */
    private void hookDigitalAudioHandler(XC_LoadPackage.LoadPackageParam lpparam) {
        try {
            Class<?> handlerClass = XposedHelpers.findClass(
                "com.pri.prizeinterphone.handler.DigitalAudioMessageHandler",
                lpparam.classLoader
            );
            
            XposedHelpers.findAndHookMethod(
                handlerClass,
                "handle",
                XposedHelpers.findClass("com.pri.prizeinterphone.message.DigitalAudioMessage", lpparam.classLoader),
                new XC_MethodHook() {
                    @Override
                    protected void afterHookedMethod(MethodHookParam param) throws Throwable {
                        try {
                            Object message = param.args[0];
                            
                            // Get the packet to extract body data
                            Object packet = XposedHelpers.getObjectField(message, "packet");
                            byte[] body = (byte[]) XposedHelpers.getObjectField(packet, "body");
                            
                            if (body != null && body.length > 0) {
                                XposedBridge.log(TAG + ": ===== DigitalAudioMessage Packet Analysis =====");
                                XposedBridge.log(TAG + ": Body length: " + body.length + " bytes");
                                XposedBridge.log(TAG + ": Body bytes (hex): " + bytesToHex(body));
                                
                                // Try multiple interpretations to find the DMR ID
                                if (body.length >= 4) {
                                    // Try little-endian 4-byte int at offset 0
                                    int le0 = ((body[3] & 0xFF) << 24) | ((body[2] & 0xFF) << 16) | 
                                             ((body[1] & 0xFF) << 8) | (body[0] & 0xFF);
                                    XposedBridge.log(TAG + ": Offset 0 Little-Endian 4-byte: " + le0);
                                    
                                    // Try big-endian 4-byte int at offset 0
                                    int be0 = ((body[0] & 0xFF) << 24) | ((body[1] & 0xFF) << 16) | 
                                             ((body[2] & 0xFF) << 8) | (body[3] & 0xFF);
                                    XposedBridge.log(TAG + ": Offset 0 Big-Endian 4-byte: " + be0);
                                    
                                    // Try little-endian 3-byte (DMR IDs are 24-bit)
                                    int le3_0 = ((body[2] & 0xFF) << 16) | ((body[1] & 0xFF) << 8) | (body[0] & 0xFF);
                                    XposedBridge.log(TAG + ": Offset 0 Little-Endian 3-byte: " + le3_0);
                                    
                                    // Try big-endian 3-byte
                                    int be3_0 = ((body[0] & 0xFF) << 16) | ((body[1] & 0xFF) << 8) | (body[2] & 0xFF);
                                    XposedBridge.log(TAG + ": Offset 0 Big-Endian 3-byte: " + be3_0);
                                }
                                
                                if (body.length >= 6) {
                                    // Try offset 2 (skip first 2 bytes)
                                    int le2 = ((body[5] & 0xFF) << 24) | ((body[4] & 0xFF) << 16) | 
                                             ((body[3] & 0xFF) << 8) | (body[2] & 0xFF);
                                    XposedBridge.log(TAG + ": Offset 2 Little-Endian 4-byte: " + le2);
                                    
                                    int be2 = ((body[2] & 0xFF) << 24) | ((body[3] & 0xFF) << 16) | 
                                             ((body[4] & 0xFF) << 8) | (body[5] & 0xFF);
                                    XposedBridge.log(TAG + ": Offset 2 Big-Endian 4-byte: " + be2);
                                }
                                
                                // Try 2-byte (16-bit) interpretations
                                if (body.length >= 2) {
                                    int le16_0 = ((body[1] & 0xFF) << 8) | (body[0] & 0xFF);
                                    XposedBridge.log(TAG + ": Offset 0 Little-Endian 2-byte (16-bit): " + le16_0);
                                    
                                    int be16_0 = ((body[0] & 0xFF) << 8) | (body[1] & 0xFF);
                                    XposedBridge.log(TAG + ": Offset 0 Big-Endian 2-byte (16-bit): " + be16_0);
                                }
                                
                                XposedBridge.log(TAG + ": Expected DMR ID: 64067 (0xFA23)");
                                XposedBridge.log(TAG + ": =============================================");
                                
                                // DMR ID is at offset 1, 2-byte little-endian: bytes[2] << 8 | bytes[1]
                                if (body.length >= 3) {
                                    int dmrId = ((body[2] & 0xFF) << 8) | (body[1] & 0xFF);
                                    
                                    XposedBridge.log(TAG + ": Decoded DMR ID (offset 1, 2-byte LE): " + dmrId + ", channel type: " + currentChannelType);
                                    
                                    // Only process DMR IDs on digital channels
                                    if (dmrId > 0 && dmrId < 16777215 && currentChannelType == 0) {  // Valid DMR ID range and digital channel
                                        currentCallerDmrId = dmrId;
                                        updateCallerInfoAsync(lpparam.classLoader);
                                        // Activity indicator will be updated after contact lookup completes
                                    } else if (currentChannelType != 0) {
                                        XposedBridge.log(TAG + ": Ignoring DMR ID - not on digital channel");
                                    }
                                }
                            }
                        } catch (Exception e) {
                            XposedBridge.log(TAG + ": Error in DigitalAudioMessageHandler hook: " + e.getMessage());
                        }
                    }
                }
            );
            
            XposedBridge.log(TAG + ": Successfully hooked DigitalAudioMessageHandler");
            
        } catch (Throwable t) {
            XposedBridge.log(TAG + ": Error hooking DigitalAudioMessageHandler: " + t.getMessage());
            XposedBridge.log(t);
        }
    }
    
    /**
     * Query for caller information by sending QUERY_DIGITAL_AUDIO_RECEIVE_INFO command
     */
    private void queryCallerInfo(ClassLoader classLoader) {
        try {
            Class<?> messageClass = XposedHelpers.findClass(
                "com.pri.prizeinterphone.message.DigitalAudioMessage",
                classLoader
            );
            
            Object digitalAudioMessage = XposedHelpers.newInstance(messageClass);
            XposedHelpers.callMethod(digitalAudioMessage, "send");
            
            XposedBridge.log(TAG + ": Sent QUERY_DIGITAL_AUDIO_RECEIVE_INFO");
            
        } catch (Exception e) {
            XposedBridge.log(TAG + ": Error sending caller info query: " + e.getMessage());
        }
    }
    
    /**
     * Update caller info asynchronously (lookup contact name from database)
     */
    private void updateCallerInfoAsync(final ClassLoader classLoader) {
        new Thread(new Runnable() {
            @Override
            public void run() {
                try {
                    // Get app context
                    Class<?> appClass = XposedHelpers.findClass(
                        "com.pri.prizeinterphone.PrizeInterPhoneApp",
                        classLoader
                    );
                    Context context = (Context) XposedHelpers.callStaticMethod(appClass, "getContext");
                    
                    if (context != null && currentCallerDmrId > 0) {
                        // Look up contact name
                        String contactName = lookupContactName(context, currentCallerDmrId);
                        currentCallerName = contactName;
                        
                        // Update UI on main thread - but only if still on digital channel
                        if (callerDisplayTextView != null) {
                            callerDisplayTextView.post(new Runnable() {
                                @Override
                                public void run() {
                                    // Double-check we're still on a digital channel before updating
                                    // This prevents race condition where channel switched to analog
                                    if (currentChannelType == 0) {
                                        updateCallerDisplay();
                                        // Now update activity indicator with contact name available
                                        updateActivityIndicator("📻 Voice RX");
                                    } else {
                                        XposedBridge.log(TAG + ": Skipping DMR caller display - not on digital channel");
                                    }
                                }
                            });
                        }
                    }
                } catch (Exception e) {
                    XposedBridge.log(TAG + ": Error updating caller info: " + e.getMessage());
                }
            }
        }).start();
    }
    
    /**
     * Lookup contact name from DMR ID in contacts database
     */
    private String lookupContactName(Context context, int dmrId) {
        android.database.Cursor cursor = null;
        android.database.sqlite.SQLiteDatabase db = null;
        try {
            // Contacts are stored in contact_database.db
            db = context.openOrCreateDatabase("contact_database.db", Context.MODE_PRIVATE, null);
            
            // Ensure table exists (create if needed)
            db.execSQL("CREATE TABLE IF NOT EXISTS contact_database(_id integer primary key autoincrement, contact_name varchar, contact_type integer, contact_number varchar, contact_active integer, contact_icon varchar)");
            
            cursor = db.rawQuery(
                "SELECT contact_name FROM contact_database WHERE contact_number = ?",
                new String[]{String.valueOf(dmrId)}
            );
            
            if (cursor != null && cursor.moveToFirst()) {
                String name = cursor.getString(0);
                XposedBridge.log(TAG + ": Found contact: " + name + " for DMR ID: " + dmrId);
                db.close();
                return name;
            }
            
            XposedBridge.log(TAG + ": No contact found for DMR ID: " + dmrId + " in contact_database");
            if (db != null) db.close();
            return null;
            
        } catch (Exception e) {
            XposedBridge.log(TAG + ": Error looking up contact: " + e.getMessage());
            if (db != null) {
                try { db.close(); } catch (Exception ex) {}
            }
            return null;
        } finally {
            if (cursor != null) {
                try { cursor.close(); } catch (Exception e) {}
            }
        }
    }
    
    /**
     * Update the caller display TextView
     */
    /**
     * Update the caller display with custom text (for analog tone info)
     */
    private void updateCallerDisplay(final String displayText) {
        if (callerDisplayTextView == null) {
            return;
        }
        
        try {
            callerDisplayTextView.post(new Runnable() {
                @Override
                public void run() {
                    callerDisplayTextView.setText(displayText);
                    callerDisplayTextView.setVisibility(View.VISIBLE);
                }
            });
            
            XposedBridge.log(TAG + ": Updated caller display: " + displayText);
        } catch (Exception e) {
            XposedBridge.log(TAG + ": Error updating caller display: " + e.getMessage());
        }
    }
    
    /**
     * Update the caller display with DMR caller information
     */
    private void updateCallerDisplay() {
        // Only show DMR caller info on digital channels
        if (callerDisplayTextView == null || !isReceiving || currentChannelType != 0) {
            return;
        }
        
        try {
            if (currentCallerDmrId > 0) {
                String displayText;
                if (currentCallerName != null && !currentCallerName.isEmpty()) {
                    displayText = "📞 " + currentCallerName + "\nDMR ID: " + currentCallerDmrId;
                } else {
                    displayText = "📞 DMR ID: " + currentCallerDmrId;
                }
                
                callerDisplayTextView.setText(displayText);
                callerDisplayTextView.setVisibility(View.VISIBLE);
                
                XposedBridge.log(TAG + ": Updated caller display: " + displayText);
            }
        } catch (Exception e) {
            XposedBridge.log(TAG + ": Error updating caller display: " + e.getMessage());
        }
    }
    
    /**
     * Clear the caller display
     */
    private void clearCallerDisplay() {
        currentCallerDmrId = 0;
        currentCallerName = null;
        
        if (callerDisplayTextView != null) {
            try {
                callerDisplayTextView.post(new Runnable() {
                    @Override
                    public void run() {
                        callerDisplayTextView.setText("");
                        callerDisplayTextView.setVisibility(View.GONE);
                    }
                });
                
                XposedBridge.log(TAG + ": Cleared caller display");
            } catch (Exception e) {
                XposedBridge.log(TAG + ": Error clearing caller display: " + e.getMessage());
            }
        }
    }
    
    /**
     * Update the activity indicator with scrolling history (supports both DMR and Analog)
     */
    private void updateActivityIndicator(final String activityType) {
        if (dmrActivityIndicator == null || currentChannelNumber < 0) {
            return;
        }
        
        try {
            // Format timestamp (HH:mm:ss)
            java.text.SimpleDateFormat timeFormat = new java.text.SimpleDateFormat("HH:mm:ss");
            String timestamp = timeFormat.format(new java.util.Date());
            
            // Create activity entry - format depends on channel type
            String entry;
            String dmrIdStr;
            
            if (currentChannelType == 0) {
                // Digital/DMR channel - include DMR ID or contact name
                dmrIdStr = (currentCallerDmrId > 0) ? String.valueOf(currentCallerDmrId) : "-----";
                
                // Use contact name if available, otherwise use DMR ID
                String displayName;
                if (currentCallerName != null && !currentCallerName.isEmpty()) {
                    displayName = currentCallerName;
                } else {
                    displayName = dmrIdStr;
                }
                
                // Add RSSI if available
                String rssiStr = (currentRssi != -999) ? " " + currentRssi + " dBm" : "";
                entry = displayName + " " + timestamp + " " + activityType + rssiStr;
            } else {
                // Analog/FM channel - no caller ID (analog doesn't have individual IDs)
                dmrIdStr = "N/A";  // Store as N/A for database consistency
                // Add RSSI if available
                String rssiStr = (currentRssi != -999) ? " " + currentRssi + " dBm" : "";
                entry = timestamp + " " + activityType + rssiStr;
            }
            
            // Save to database if we have context
            if (appContext != null) {
                saveChannelHistoryEntry(currentChannelNumber, dmrIdStr, timestamp, activityType, appContext);
            }
            
            // Add to history (most recent first)
            activityHistory.addFirst(entry);
            
            // Trim to max 3 entries
            while (activityHistory.size() > MAX_ACTIVITY_HISTORY) {
                activityHistory.removeLast();
            }
            
            // Build display string from all entries
            StringBuilder displayText = new StringBuilder();
            for (String historyEntry : activityHistory) {
                if (displayText.length() > 0) {
                    displayText.append("\n");
                }
                displayText.append(historyEntry);
            }
            
            final String finalDisplay = displayText.toString();
            
            dmrActivityIndicator.post(new Runnable() {
                @Override
                public void run() {
                    dmrActivityIndicator.setText(finalDisplay);
                    dmrActivityIndicator.setVisibility(View.VISIBLE);
                }
            });
            
            XposedBridge.log(TAG + ": Updated activity history: " + entry);
        } catch (Exception e) {
            XposedBridge.log(TAG + ": Error updating activity indicator: " + e.getMessage());
        }
    }
    
    /**
     * Clear the DMR activity indicator and history
     */
    private void clearActivityIndicator() {
        if (dmrActivityIndicator == null) {
            return;
        }
        
        try {
            // Clear history
            activityHistory.clear();
            
            dmrActivityIndicator.post(new Runnable() {
                @Override
                public void run() {
                    dmrActivityIndicator.setText("");
                    dmrActivityIndicator.setVisibility(View.GONE);
                }
            });
            
            XposedBridge.log(TAG + ": Cleared activity indicator and history");
        } catch (Exception e) {
            XposedBridge.log(TAG + ": Error clearing activity indicator: " + e.getMessage());
        }
    }
    
    /**
     * Update the history box header based on channel type
     */
    private void updateHistoryHeader() {
        if (activityHeaderTextView == null) {
            return;
        }
        
        try {
            final String headerText = (currentChannelType == 0) ? "DMR History" : "Analog History";
            
            activityHeaderTextView.post(new Runnable() {
                @Override
                public void run() {
                    activityHeaderTextView.setText(headerText);
                }
            });
            
            XposedBridge.log(TAG + ": Updated history header to: " + headerText);
        } catch (Exception e) {
            XposedBridge.log(TAG + ": Error updating history header: " + e.getMessage());
        }
    }
    
    /**
     * Load activity history for a specific channel (supports both DMR and Analog)
     */
    private void loadChannelHistory(final int channelNumber, final android.content.Context context) {
        new Thread(new Runnable() {
            @Override
            public void run() {
                android.database.sqlite.SQLiteDatabase db = null;
                android.database.Cursor cursor = null;
                try {
                    // Open or create the history database
                    java.io.File dbFile = new java.io.File(context.getApplicationInfo().dataDir + "/databases/dmrmod_history.db");
                    dbFile.getParentFile().mkdirs();
                    
                    db = android.database.sqlite.SQLiteDatabase.openOrCreateDatabase(dbFile, null);
                    
                    // Create history table if it doesn't exist
                    db.execSQL("CREATE TABLE IF NOT EXISTS channel_history (" +
                        "id INTEGER PRIMARY KEY AUTOINCREMENT, " +
                        "channel_number INTEGER, " +
                        "dmr_id TEXT, " +
                        "timestamp TEXT, " +
                        "activity_type TEXT, " +
                        "created_at INTEGER)");
                    
                    // Load last 3 entries for this channel
                    cursor = db.rawQuery(
                        "SELECT dmr_id, timestamp, activity_type FROM channel_history " +
                        "WHERE channel_number = ? " +
                        "ORDER BY created_at DESC LIMIT ?",
                        new String[]{String.valueOf(channelNumber), String.valueOf(MAX_ACTIVITY_HISTORY)}
                    );
                    
                    // Clear current history
                    activityHistory.clear();
                    
                    // Load entries (they come newest first, so we add them in order)
                    while (cursor.moveToNext()) {
                        String dmrId = cursor.getString(0);
                        String timestamp = cursor.getString(1);
                        String activityType = cursor.getString(2);
                        
                        // Format entry based on whether it has a DMR ID or not (Analog channels use "N/A")
                        String entry;
                        if (dmrId != null && !dmrId.equals("N/A")) {
                            // DMR format - try to look up contact name
                            String displayName = dmrId;
                            try {
                                int id = Integer.parseInt(dmrId);
                                String contactName = lookupContactName(context, id);
                                if (contactName != null && !contactName.isEmpty()) {
                                    displayName = contactName;
                                }
                            } catch (NumberFormatException e) {
                                // Keep using dmrId as is
                            }
                            entry = displayName + " " + timestamp + " " + activityType;
                        } else {
                            entry = timestamp + " " + activityType;  // Analog format (no ID)
                        }
                        
                        activityHistory.addLast(entry);  // Add to end since results are DESC
                    }
                    
                    // Update display
                    if (dmrActivityIndicator != null) {
                        StringBuilder displayText = new StringBuilder();
                        // Reverse order for display (most recent first)
                        for (int i = activityHistory.size() - 1; i >= 0; i--) {
                            if (displayText.length() > 0) {
                                displayText.append("\n");
                            }
                            displayText.append(activityHistory.get(i));
                        }
                        
                        final String finalDisplay = displayText.toString();
                        dmrActivityIndicator.post(new Runnable() {
                            @Override
                            public void run() {
                                if (finalDisplay.length() > 0) {
                                    dmrActivityIndicator.setText(finalDisplay);
                                    dmrActivityIndicator.setVisibility(View.VISIBLE);
                                } else {
                                    dmrActivityIndicator.setText("");
                                    dmrActivityIndicator.setVisibility(View.GONE);
                                }
                            }
                        });
                    }
                    
                    // Fix order in activityHistory (should be newest first)
                    java.util.LinkedList<String> temp = new java.util.LinkedList<>(activityHistory);
                    activityHistory.clear();
                    for (int i = temp.size() - 1; i >= 0; i--) {
                        activityHistory.add(temp.get(i));
                    }
                    
                    XposedBridge.log(TAG + ": Loaded " + activityHistory.size() + " history entries for channel " + channelNumber);
                    
                } catch (Exception e) {
                    XposedBridge.log(TAG + ": Error loading channel history: " + e.getMessage());
                } finally {
                    if (cursor != null) {
                        try { cursor.close(); } catch (Exception e) {}
                    }
                    if (db != null) {
                        try { db.close(); } catch (Exception e) {}
                    }
                }
            }
        }).start();
    }
    
    /**
     * Save a DMR activity entry to the channel history database
     */
    private void saveChannelHistoryEntry(final int channelNumber, final String dmrId, final String timestamp, final String activityType, final android.content.Context context) {
        new Thread(new Runnable() {
            @Override
            public void run() {
                android.database.sqlite.SQLiteDatabase db = null;
                try {
                    // Open or create the history database
                    java.io.File dbFile = new java.io.File(context.getApplicationInfo().dataDir + "/databases/dmrmod_history.db");
                    dbFile.getParentFile().mkdirs();
                    
                    db = android.database.sqlite.SQLiteDatabase.openOrCreateDatabase(dbFile, null);
                    
                    // Create history table if it doesn't exist
                    db.execSQL("CREATE TABLE IF NOT EXISTS channel_history (" +
                        "id INTEGER PRIMARY KEY AUTOINCREMENT, " +
                        "channel_number INTEGER, " +
                        "dmr_id TEXT, " +
                        "timestamp TEXT, " +
                        "activity_type TEXT, " +
                        "created_at INTEGER)");
                    
                    // Insert new entry
                    android.content.ContentValues values = new android.content.ContentValues();
                    values.put("channel_number", channelNumber);
                    values.put("dmr_id", dmrId);
                    values.put("timestamp", timestamp);
                    values.put("activity_type", activityType);
                    values.put("created_at", System.currentTimeMillis());
                    
                    db.insert("channel_history", null, values);
                    
                    // Keep only last 100 entries per channel to prevent unlimited growth
                    db.execSQL("DELETE FROM channel_history WHERE channel_number = ? AND id NOT IN (" +
                        "SELECT id FROM channel_history WHERE channel_number = ? ORDER BY created_at DESC LIMIT 100)",
                        new Object[]{channelNumber, channelNumber});
                    
                    XposedBridge.log(TAG + ": Saved history entry for channel " + channelNumber + ": " + dmrId + " " + timestamp + " " + activityType);
                    
                } catch (Exception e) {
                    XposedBridge.log(TAG + ": Error saving channel history: " + e.getMessage());
                } finally {
                    if (db != null) {
                        try { db.close(); } catch (Exception e) {}
                    }
                }
            }
        }).start();
    }
    
    /**
     * Convert byte array to hex string for debugging
     */
    private static String bytesToHex(byte[] bytes) {
        StringBuilder sb = new StringBuilder();
        for (byte b : bytes) {
            sb.append(String.format("%02X ", b));
        }
        return sb.toString().trim();
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
    
    /**
     * Start audio recording
     */
    private static void startRecording() {
        if (!isRecordingEnabled || isCurrentlyRecording) {
            return;
        }
        
        try {
            // Clean channel name for folder (remove special characters)
            String channelFolderName = currentChannelName.replaceAll("[^a-zA-Z0-9\\s-]", "").trim();
            if (channelFolderName.isEmpty()) {
                channelFolderName = "Channel_" + currentChannelNumber;
            }
            
            // Create channel-specific folder in Recordings
            java.io.File downloadDir = android.os.Environment.getExternalStoragePublicDirectory(android.os.Environment.DIRECTORY_DOWNLOADS);
            java.io.File recordingsDir = new java.io.File(downloadDir, "DMR/Recordings/" + channelFolderName);
            
            if (!recordingsDir.exists()) {
                recordingsDir.mkdirs();
                XposedBridge.log(TAG + ": Created channel recording folder: " + recordingsDir.getAbsolutePath());
            }
            
            // Generate filename with date and time
            java.text.SimpleDateFormat dateFormat = new java.text.SimpleDateFormat("yyyyMMdd_HHmmss", java.util.Locale.US);
            String timestamp = dateFormat.format(new java.util.Date());
            
            // Store timestamp and folder for potential renaming later
            currentRecordingTimestamp = timestamp;
            currentRecordingFolder = recordingsDir.getAbsolutePath();
            
            // Start with just timestamp, will rename after if we get DMR info
            // Use .pcm extension temporarily, will convert to .wav when stopping
            String filename = timestamp + ".pcm";
            currentRecordingPath = new java.io.File(recordingsDir, filename).getAbsolutePath();
            
            // Create FileOutputStream for capturing PCM data from AudioTrack
            pcmOutputStream = new java.io.FileOutputStream(currentRecordingPath);
            pcmDataSize = 0; // Reset data size counter
            
            isCurrentlyRecording = true;
            XposedBridge.log(TAG + ": ✓ Started PCM recording: " + currentRecordingPath);
            
        } catch (Exception e) {
            XposedBridge.log(TAG + ": Error starting recording: " + e.getMessage());
            e.printStackTrace();
            isCurrentlyRecording = false;
            if (pcmOutputStream != null) {
                try {
                    pcmOutputStream.close();
                } catch (Exception ignored) {}
                pcmOutputStream = null;
            }
        }
    }
    
    /**
     * Stop audio recording and convert PCM to WAV
     */
    private static void stopRecording() {
        if (!isCurrentlyRecording || pcmOutputStream == null) {
            return;
        }
        
        try {
            // Close PCM stream
            pcmOutputStream.close();
            XposedBridge.log(TAG + ": ✓ Stopped PCM recording, size: " + pcmDataSize + " bytes");
            
            // Convert PCM to WAV (add headers)
            java.io.File pcmFile = new java.io.File(currentRecordingPath);
            if (pcmFile.exists() && pcmDataSize > 0) {
                // Create WAV filename
                String wavPath = currentRecordingPath.replace(".pcm", ".wav");
                java.io.File wavFile = new java.io.File(wavPath);
                
                // Write WAV file with headers
                // Using 16kHz based on observed data rate: 2048 bytes/64ms = 16000 samples/sec
                convertPCMtoWAV(pcmFile, wavFile, 16000, 1, 16);  // 16kHz, mono, 16-bit
                
                // Delete temporary PCM file
                pcmFile.delete();
                
                // Update path to WAV file
                currentRecordingPath = wavPath;
                
                XposedBridge.log(TAG + ": ✓ Converted to WAV: " + wavPath);
                
                // Rename file to include DMR ID/contact name if available (digital channel only)
                java.io.File recordedFile = new java.io.File(currentRecordingPath);
                if (recordedFile.exists() && currentChannelType == 0 && currentRecordingTimestamp != null && currentRecordingFolder != null) {
                    String identifierPart = "";
                    if (currentCallerName != null && !currentCallerName.isEmpty()) {
                        identifierPart = "_" + currentCallerName.replaceAll("[^a-zA-Z0-9-]", "");
                    } else if (currentCallerDmrId > 0) {
                        identifierPart = "_" + currentCallerDmrId;
                    }
                    
                    if (!identifierPart.isEmpty()) {
                        String newFilename = currentRecordingTimestamp + identifierPart + ".wav";
                        java.io.File newFile = new java.io.File(currentRecordingFolder, newFilename);
                        if (recordedFile.renameTo(newFile)) {
                            XposedBridge.log(TAG + ": ✓ Renamed recording to: " + newFile.getAbsolutePath());
                            currentRecordingPath = newFile.getAbsolutePath();
                            recordedFile = newFile;
                        } else {
                            XposedBridge.log(TAG + ": Failed to rename recording file");
                        }
                    }
                }
                
                // Check file size - delete if too small (likely no audio)
                if (recordedFile.exists() && recordedFile.length() < 10000) {  // Less than 10KB
                    recordedFile.delete();
                    XposedBridge.log(TAG + ": Deleted empty recording file");
                }
            }
            
        } catch (Exception e) {
            XposedBridge.log(TAG + ": Error stopping recording: " + e.getMessage());
            e.printStackTrace();
        } finally {
            pcmOutputStream = null;
            pcmDataSize = 0;
            isCurrentlyRecording = false;
            currentRecordingPath = null;
            currentRecordingTimestamp = null;
            currentRecordingFolder = null;
        }
    }
    
    /**
     * Convert raw PCM file to MP3 format using MediaCodec
     * @param pcmFile Input PCM file
     * @param mp3File Output MP3 file
     * @param sampleRate Sample rate (16000 Hz for DMR)
     * @param channels Number of channels (1 = mono)
     * @param bitsPerSample Bits per sample (16 for PCM_16BIT)
     */
    private static void convertPCMtoMP3(java.io.File pcmFile, java.io.File mp3File, int sampleRate, int channels, int bitsPerSample) throws Exception {
        java.io.FileInputStream pcmIn = new java.io.FileInputStream(pcmFile);
        java.io.FileOutputStream mp3Out = new java.io.FileOutputStream(mp3File);
        
        // Configure MediaCodec for MP3 encoding
        android.media.MediaFormat format = android.media.MediaFormat.createAudioFormat(
            android.media.MediaFormat.MIMETYPE_AUDIO_MPEG,  // MP3
            sampleRate,
            channels
        );
        format.setInteger(android.media.MediaFormat.KEY_BIT_RATE, 64000);  // 64 kbps
        format.setInteger(android.media.MediaFormat.KEY_PCM_ENCODING, android.media.AudioFormat.ENCODING_PCM_16BIT);
        
        android.media.MediaCodec codec = android.media.MediaCodec.createEncoderByType(android.media.MediaFormat.MIMETYPE_AUDIO_MPEG);
        codec.configure(format, null, null, android.media.MediaCodec.CONFIGURE_FLAG_ENCODE);
        codec.start();
        
        android.media.MediaCodec.BufferInfo bufferInfo = new android.media.MediaCodec.BufferInfo();
        byte[] pcmBuffer = new byte[4096];
        boolean inputDone = false;
        boolean outputDone = false;
        
        while (!outputDone) {
            // Feed input
            if (!inputDone) {
                int inputBufferId = codec.dequeueInputBuffer(10000);
                if (inputBufferId >= 0) {
                    java.nio.ByteBuffer inputBuffer = codec.getInputBuffer(inputBufferId);
                    inputBuffer.clear();
                    int read = pcmIn.read(pcmBuffer);
                    if (read > 0) {
                        inputBuffer.put(pcmBuffer, 0, read);
                        codec.queueInputBuffer(inputBufferId, 0, read, 0, 0);
                    } else {
                        codec.queueInputBuffer(inputBufferId, 0, 0, 0, android.media.MediaCodec.BUFFER_FLAG_END_OF_STREAM);
                        inputDone = true;
                    }
                }
            }
            
            // Get output
            int outputBufferId = codec.dequeueOutputBuffer(bufferInfo, 10000);
            if (outputBufferId >= 0) {
                java.nio.ByteBuffer outputBuffer = codec.getOutputBuffer(outputBufferId);
                if (bufferInfo.size > 0) {
                    byte[] outData = new byte[bufferInfo.size];
                    outputBuffer.get(outData);
                    mp3Out.write(outData);
                }
                codec.releaseOutputBuffer(outputBufferId, false);
                
                if ((bufferInfo.flags & android.media.MediaCodec.BUFFER_FLAG_END_OF_STREAM) != 0) {
                    outputDone = true;
                }
            }
        }
        
        codec.stop();
        codec.release();
        pcmIn.close();
        mp3Out.close();
    }
    
    /**
     * Convert raw PCM file to WAV format with headers
     * @param pcmFile Input PCM file
     * @param wavFile Output WAV file
     * @param sampleRate Sample rate (16000 Hz for DMR)
     * @param channels Number of channels (1 = mono)
     * @param bitsPerSample Bits per sample (16 for PCM_16BIT)
     */
    private static void convertPCMtoWAV(java.io.File pcmFile, java.io.File wavFile, int sampleRate, int channels, int bitsPerSample) throws Exception {
        java.io.FileInputStream pcmIn = new java.io.FileInputStream(pcmFile);
        java.io.FileOutputStream wavOut = new java.io.FileOutputStream(wavFile);
        
        long pcmLength = pcmFile.length();
        long dataSize = pcmLength;
        long fileSize = pcmLength + 36;  // PCM data + 36 bytes of header
        
        int byteRate = sampleRate * channels * bitsPerSample / 8;
        int blockAlign = channels * bitsPerSample / 8;
        
        // Write WAV header
        wavOut.write("RIFF".getBytes());
        wavOut.write(intToByteArray((int) fileSize), 0, 4);
        wavOut.write("WAVE".getBytes());
        wavOut.write("fmt ".getBytes());
        wavOut.write(intToByteArray(16), 0, 4);  // fmt chunk size
        wavOut.write(shortToByteArray((short) 1), 0, 2);  // Audio format (1 = PCM)
        wavOut.write(shortToByteArray((short) channels), 0, 2);  // Number of channels
        wavOut.write(intToByteArray(sampleRate), 0, 4);  // Sample rate
        wavOut.write(intToByteArray(byteRate), 0, 4);  // Byte rate
        wavOut.write(shortToByteArray((short) blockAlign), 0, 2);  // Block align
        wavOut.write(shortToByteArray((short) bitsPerSample), 0, 2);  // Bits per sample
        wavOut.write("data".getBytes());
        wavOut.write(intToByteArray((int) dataSize), 0, 4);  // Data chunk size
        
        // Copy PCM data
        byte[] buffer = new byte[4096];
        int read;
        while ((read = pcmIn.read(buffer)) != -1) {
            wavOut.write(buffer, 0, read);
        }
        
        pcmIn.close();
        wavOut.close();
    }
    
    /**
     * Convert int to little-endian byte array
     */
    private static byte[] intToByteArray(int value) {
        return new byte[] {
            (byte) (value & 0xff),
            (byte) ((value >> 8) & 0xff),
            (byte) ((value >> 16) & 0xff),
            (byte) ((value >> 24) & 0xff)
        };
    }
    
    /**
     * Convert short to little-endian byte array
     */
    private static byte[] shortToByteArray(short value) {
        return new byte[] {
            (byte) (value & 0xff),
            (byte) ((value >> 8) & 0xff)
        };
    }
    
    /**
     * Hook PCMReceiveManager to capture audio data directly from AudioTrack
     * This captures the PCM audio being played, allowing us to save it to WAV files
     */
    private void hookPCMReceiveManager(XC_LoadPackage.LoadPackageParam lpparam) {
        try {
            Class<?> pcmManagerClass = XposedHelpers.findClass(
                "com.pri.prizeinterphone.manager.PCMReceiveManager",
                lpparam.classLoader
            );
            
            // Hook the writeAudioTrack method which receives all PCM audio data
            XposedHelpers.findAndHookMethod(
                pcmManagerClass,
                "writeAudioTrack",
                byte[].class,  // PCM data
                int.class,      // data length
                new XC_MethodHook() {
                    @Override
                    protected void beforeHookedMethod(MethodHookParam param) throws Throwable {
                        // Only capture if recording is enabled and currently recording
                        if (isRecordingEnabled && isCurrentlyRecording && pcmOutputStream != null) {
                            try {
                                byte[] audioData = (byte[]) param.args[0];
                                int length = (int) param.args[1];
                                
                                // Write PCM data to file
                                pcmOutputStream.write(audioData, 0, length);
                                pcmDataSize += length;
                                
                            } catch (Exception e) {
                                XposedBridge.log(TAG + ": Error writing PCM data: " + e.getMessage());
                            }
                        }
                    }
                }
            );
            
            XposedBridge.log(TAG + ": Successfully hooked PCMReceiveManager.writeAudioTrack");
            
        } catch (Throwable t) {
            XposedBridge.log(TAG + ": Failed to hook PCMReceiveManager: " + t.getMessage());
        }
    }
    
    /**
     * Update the RSSI display with current signal strength
     */
    private static void updateRssiDisplay() {
        if (rssiDisplayTextView == null) {
            return;
        }
        
        try {
            rssiDisplayTextView.post(new Runnable() {
                @Override
                public void run() {
                    if (currentRssi != -999) {
                        rssiDisplayTextView.setText("Signal: " + currentRssi + " dBm");
                        ((View) rssiDisplayTextView.getParent()).setVisibility(View.VISIBLE);
                    } else {
                        ((View) rssiDisplayTextView.getParent()).setVisibility(View.GONE);
                    }
                }
            });
        } catch (Exception e) {
            XposedBridge.log(TAG + ": Error updating RSSI display: " + e.getMessage());
        }
    }
    
    /**
     * Hide the RSSI display
     */
    private static void hideRssiDisplay() {
        if (rssiDisplayTextView == null) {
            return;
        }
        
        try {
            rssiDisplayTextView.post(new Runnable() {
                @Override
                public void run() {
                    ((View) rssiDisplayTextView.getParent()).setVisibility(View.GONE);
                }
            });
            
            // Reset RSSI value
            currentRssi = -999;
            
        } catch (Exception e) {
            XposedBridge.log(TAG + ": Error hiding RSSI display: " + e.getMessage());
        }
    }
    
    /**
     * Hook SignalMessageHandler to capture RSSI values
     */
    private void hookSignalMessageHandler(XC_LoadPackage.LoadPackageParam lpparam) {
        try {
            Class<?> signalMessageHandlerClass = XposedHelpers.findClass(
                "com.pri.prizeinterphone.handler.SignalMessageHandler",
                lpparam.classLoader
            );
            
            // Hook the decode() method which processes incoming SignalMessage
            XposedHelpers.findAndHookMethod(
                signalMessageHandlerClass,
                "decode",
                XposedHelpers.findClass("com.pri.prizeinterphone.protocol.Packet", lpparam.classLoader),
                new XC_MethodHook() {
                    @Override
                    protected void afterHookedMethod(MethodHookParam param) throws Throwable {
                        try {
                            // The decode() method returns a SignalMessage object
                            Object signalMessage = param.getResult();
                            
                            if (signalMessage != null) {
                                // Get the rssi field value (byte)
                                Object rssiObj = XposedHelpers.getObjectField(signalMessage, "rssi");
                                
                                if (rssiObj != null) {
                                    byte rssi = (Byte) rssiObj;
                                    currentRssi = (int) rssi;
                                    XposedBridge.log(TAG + ": Captured RSSI: " + currentRssi + " dBm");
                                }
                            }
                        } catch (Exception e) {
                            XposedBridge.log(TAG + ": Error extracting RSSI: " + e.getMessage());
                        }
                    }
                }
            );
            
            XposedBridge.log(TAG + ": Successfully hooked SignalMessageHandler.decode");
            
        } catch (Throwable t) {
            XposedBridge.log(TAG + ": Failed to hook SignalMessageHandler: " + t.getMessage());
        }
    }
}
