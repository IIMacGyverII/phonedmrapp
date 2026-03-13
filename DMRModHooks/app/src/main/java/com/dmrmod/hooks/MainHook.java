package com.dmrmod.hooks;

import android.app.Activity;
import android.app.AlertDialog;
import android.content.Context;
import android.content.DialogInterface;
import android.content.Intent;
import android.location.Address;
import android.location.Geocoder;
import android.os.Bundle;
import android.os.Environment;
import android.text.InputType;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Button;
import android.widget.CheckBox;
import android.widget.EditText;
import android.widget.FrameLayout;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.ScrollView;
import android.widget.TextView;
import android.widget.Toast;

import java.io.BufferedReader;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.ByteArrayInputStream;
import java.nio.ByteBuffer;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Locale;

import android.content.ComponentName;
import android.content.ServiceConnection;
import android.os.IBinder;
import android.content.Intent;
import com.macdmr.transcription.ITranscriptionService;

import org.json.JSONArray;
import org.json.JSONObject;

import de.robv.android.xposed.IXposedHookLoadPackage;
import de.robv.android.xposed.XC_MethodHook;
import de.robv.android.xposed.XC_MethodReplacement;
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
    private static final String VERSION = "3.1.2";
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
    private static volatile String lastRecordingPathForTranscription = null;  // Saved for async transcription
    private static volatile String currentRecordingTimestamp = null;  // Store timestamp for renaming
    private static volatile String currentRecordingFolder = null;     // Store folder for renaming
    private static volatile String currentChannelName = "Unknown";
    
    // Caller info saved for transcription (before clearing)
    private static volatile int savedCallerDmrIdForTranscription = 0;
    private static volatile String savedCallerNameForTranscription = null;
    private static volatile int savedChannelTypeForTranscription = 0;
    private static android.widget.ToggleButton recordingToggleButton = null;
    
    // PCM recording (direct audio capture from AudioTrack)
    private static volatile java.io.FileOutputStream pcmOutputStream = null;
    private static volatile long pcmDataSize = 0; // Track written bytes for WAV header
    
    // Signal strength (RSSI) state
    private static volatile int currentRssi = -999;  // dBm value, -999 = no signal
    private static TextView rssiDisplayTextView = null;
    
    // Software squelch state (Hybrid RSSI + Audio RMS based)
    private static volatile boolean isSoftwareSquelchEnabled = false;  // Disabled by default
    private static volatile int softwareSquelchThreshold = 2;  // User squelch level (0-9)
    private static volatile boolean isSquelchOpen = false;  // Current squelch state
    private static volatile boolean previousSquelchOpen = false;  // Track state changes
    private static TextView squelchStatusIndicator = null;  // UI indicator for squelch status
    private static TextView squelchValueTextView = null;  // UI display for squelch value
    private static TextView squelchStatusTextView = null;  // UI status dot indicator
    private static volatile long lastRssiQueryTime = 0;  // For periodic RSSI queries
    private static final long RSSI_QUERY_INTERVAL_MS = 500;  // Query RSSI every 500ms when receiving
    private static volatile long lastSquelchOpenTime = 0;  // For hang time (tail delay)
    private static final long SQUELCH_HANG_TIME_MS = 300;  // Hold squelch open 300ms after signal drops
    private static final int HYSTERESIS_FACTOR = 140;  // ~3dB hysteresis (openThresh / closeThresh = 1.4)
    
    // Audio RMS thresholds for squelch levels 0-9 (tuned for 8kHz 16-bit PCM)
    // Based on real-world values: noise floor ~100-400, weak signal ~800-2000, strong ~4000+
    private static final int[] AUDIO_SQUELCH_THRESHOLDS = {
        0,       // 0: Always open (no squelch)
        200,     // 1: Very sensitive (just above noise floor)
        500,     // 2: Default (matches typical hardware sq=2)
        900,     // 3: Moderate-low
        1500,    // 4: Moderate
        2500,    // 5: Medium
        4000,    // 6: Medium-high
        6500,    // 7: Strong signals only
        10000,   // 8: Very strong
        15000    // 9: Exceptionally strong only
    };
    
    // Speech-to-text transcription state (IPC Service)
    private static volatile boolean isTranscriptionEnabled = false;
    private static volatile String currentTranscription = "";
    private static List<Short> audioBuffer = Collections.synchronizedList(new ArrayList<>());
    private static final int MAX_BUFFER_SIZE = 480000; // 30 seconds at 16kHz (480000 samples)
    private static ITranscriptionService transcriptionService = null;
    private static ServiceConnection serviceConnection = null;
    private static boolean isServiceBound = false;
    private static LinearLayout transcriptionMessagesContainer = null;  // Container for messages
    private static android.widget.ScrollView transcriptionScrollView = null;  // Scrollable view
    private static LinearLayout transcriptionBox = null;  // Outer box
    
    // APRS receive state
    private static List<Short> aprsAudioBuffer = Collections.synchronizedList(new ArrayList<>());
    private static final int APRS_BUFFER_SIZE = 32000; // 2 seconds at 16kHz (DMR radio sample rate)
    private static Object mLocalViewObject = null; // Store for context access
    private static android.widget.ToggleButton transcriptionToggleButton = null;

    // Per-channel transcription message history
    private static final java.util.HashMap<Integer, java.util.ArrayList<String>> channelTranscriptionHistory = new java.util.HashMap<>();
    private static final int MAX_TRANSCRIPTION_HISTORY = 10;

    // Monitoring mode toggle (ALL mode workaround for group call reception + analog squelch open)
    private static android.widget.CompoundButton monitoringModeToggle = null;
    private static volatile boolean isMonitoringMode = false;
    private static int originalSquelchLevel = 2;  // Store original squelch for analog channels
    private static int originalTxContact = 1;      // Store original txContact for DMR channels
    
    // Software squelch toggle button
    private static android.widget.ToggleButton softwareSquelchToggleButton = null;
    
    // APRS monitoring toggle button
    private static android.widget.ToggleButton aprsMonitoringToggleButton = null;

    // Zone selection and filtering
    private static android.widget.Button zoneButton = null;
    private static android.widget.Button channelPageZoneButton = null;  // Zone button on channels page
    private static Object channelFragmentInstance = null;  // Store channel fragment for refreshing list
    private static volatile long currentZoneId = -1;  // -1 = All Channels (no filter)
    private static volatile String currentZoneName = "All";
    private static volatile java.util.List<Integer> currentZoneChannels = null;  // null = no filter
    private static ZoneDatabase zoneDatabase = null;
    private static java.util.Map<Long, Integer> lastUsedChannelPerZone = new java.util.concurrent.ConcurrentHashMap<>();  // Track last channel per zone
    private static Object talkBackFragmentInstance = null;  // Store fragment reference for channel switching
    private static volatile boolean isAutoSwitchingZone = false;  // Flag to bypass zone navigation during automatic zone switch

    // Current GPS location for distance calculations
    private static volatile android.location.Location currentGpsLocation = null;
    private static android.location.LocationManager locationManager = null;
    
    // APRS monitoring mode state
    private static volatile boolean isAPRSMonitoringActive = false;
    private static volatile Object previousChannelBeforeAPRS = null;  // Store channel to return to
    private static ClassLoader appClassLoader = null;  // Store class loader for APRS monitoring
    private static AlertDialog aprsMonitoringDialog = null;  // Store dialog for live updates
    private static android.os.Handler aprsUpdateHandler = null;  // Handler for periodic updates
    private static Runnable aprsUpdateRunnable = null;  // Runnable for updating dialog
    private static volatile boolean isAPRSSquelchOpen = false;  // Track squelch state across UI updates
    private static volatile int aprsStoredSquelch = 1;  // Store squelch level to restore
    
    /**
     * Check if a channel is an APRS channel (should be hidden from channel list)
     */
    private static boolean isAPRSChannel(Object channelData) {
        try {
            String name = (String) XposedHelpers.getObjectField(channelData, "name");
            if (name != null && name.toUpperCase().contains("APRS")) {
                return true;
            }
            
            // Also check if it's on APRS frequency (144.390 MHz = 144390000 Hz)
            int rxFreq = XposedHelpers.getIntField(channelData, "rxFreq");
            if (rxFreq == 144390000) {
                return true;
            }
        } catch (Throwable t) {
            // Ignore errors
        }
        return false;
    }

    @Override
    public void handleLoadPackage(XC_LoadPackage.LoadPackageParam lpparam) throws Throwable {
        // Only hook our target package
        if (!lpparam.packageName.equals(TARGET_PACKAGE)) {
            return;
        }
        
        XposedBridge.log(TAG + ": Module loaded for " + TARGET_PACKAGE);
        
        // Store class loader for later use (APRS monitoring, etc.)
        appClassLoader = lpparam.classLoader;
        
        // Reset APRS state (safety measure - actual reset happens in MainActivity.onCreate)
        // Note: handleLoadPackage runs once when LSPosed loads module, not on every app restart
        isAPRSMonitoringActive = false;
        if (aprsAudioBuffer != null) {
            aprsAudioBuffer.clear();
        }
        aprsMonitoringDialog = null;
        aprsUpdateHandler = null;
        aprsUpdateRunnable = null;
        XposedBridge.log(TAG + ": APRS state reset on module load (one-time)");
        
        // Hook the main activity's onCreate method
        hookMainActivity(lpparam);
        
        // Hook the TalkBack fragment to reposition UI elements
        hookTalkBackFragment(lpparam);
        
        // Hook the local fragment to add backup/restore button
        hookLocalFragment(lpparam);
        
        // Hook information activity to display module version
        hookInformationActivity(lpparam);
        
        // Hook UpdateFirmwareActivity to auto-cleanup after patch reload
        // DISABLED 2026-03-09: Firmware reload feature commented out for future work
        // See DMR_FIRMWARE_RELOAD_NOTES.md for details on Test 10 success
        // hookUpdateFirmwareActivity(lpparam);
        
        // Hook for DMR caller identification
        hookModuleStatusHandler(lpparam);
        hookDigitalAudioHandler(lpparam);
        
        // Hook for audio recording (capture PCM data from AudioTrack)
        hookPCMReceiveManager(lpparam);
        
        // Hook for signal strength (RSSI) display
        hookSignalMessageHandler(lpparam);
        
        // Hook for DMR channel configuration (debug RX group lists)
        hookDmrManager(lpparam);
        
        // Hook for zone-based channel navigation filtering
        hookChannelNavigation(lpparam);
        
        // Hook for zone filtering in channel list page
        hookChannelListFilter(lpparam);
        
        // Hook for adding zone button to channel list page
        hookChannelListUI(lpparam);
        
        // Hook for channel edit activity to add zone selector
        hookChannelEditActivity(lpparam);
        
        // Hook UART serial communication for protocol analysis
        hookSerialCommunication(lpparam);
        
        // Register debug packet broadcast receiver for command fuzzing
        registerDebugPacketReceiver(lpparam);
        
        // Test UART bootloader probe (for permanent flash capability)
        // DISABLED: Bootloader not accessible from app context (EACCES)
        // testBootloaderAccess();
        
        XposedBridge.log(TAG + ": All hooks installed successfully");
    }

    /**
     * Hook Android SpeechRecognizer to unlock Google voice services
     * 
     * This hook intercepts SpeechRecognizer.createSpeechRecognizer() calls
     * and forces them to succeed by bypassing service restrictions.
     * 
     * ISSUE: Google speech services exist on the device but return null when
     * third-party apps try to access them. This hook bypasses that restriction.
     */
    private void hookSpeechRecognizer(XC_LoadPackage.LoadPackageParam lpparam) {
        try {
            XposedBridge.log(TAG + ": Setting up SpeechRecognizer hook for " + lpparam.packageName);
            
            Class<?> speechRecognizerClass = XposedHelpers.findClass(
                "android.speech.SpeechRecognizer",
                lpparam.classLoader
            );
            
            // Hook createSpeechRecognizer(Context, ComponentName)
            XposedHelpers.findAndHookMethod(
                speechRecognizerClass,
                "createSpeechRecognizer",
                android.content.Context.class,
                android.content.ComponentName.class,
                new XC_MethodHook() {
                    @Override
                    protected void afterHookedMethod(MethodHookParam param) throws Throwable {
                        Object result = param.getResult();
                        android.content.Context context = (android.content.Context) param.args[0];
                        android.content.ComponentName component = (android.content.ComponentName) param.args[1];
                        
                        // If result is null (service blocked), try to create it directly
                        if (result == null && context != null) {
                            XposedBridge.log(TAG + ": SpeechRecognizer returned null for component: " + 
                                (component != null ? component.flattenToString() : "default"));
                            
                            // Try to force creation with the default service
                            try {
                                // Use reflection to access the internal constructor
                                java.lang.reflect.Constructor<?> constructor = speechRecognizerClass.getDeclaredConstructor(
                                    android.content.Context.class,
                                    android.content.ComponentName.class
                                );
                                constructor.setAccessible(true);
                                Object newRecognizer = constructor.newInstance(context, component);
                                
                                if (newRecognizer != null) {
                                    param.setResult(newRecognizer);
                                    XposedBridge.log(TAG + ": ✅ FORCED SpeechRecognizer creation via constructor!");
                                }
                            } catch (Exception e) {
                                XposedBridge.log(TAG + ": ❌ Failed to force create SpeechRecognizer: " + e.getMessage());
                            }
                        } else if (result != null) {
                            XposedBridge.log(TAG + ": ✅ SpeechRecognizer created successfully (no intervention needed)");
                        }
                    }
                }
            );
            
            // Also hook the single-parameter version createSpeechRecognizer(Context)
            XposedHelpers.findAndHookMethod(
                speechRecognizerClass,
                "createSpeechRecognizer",
                android.content.Context.class,
                new XC_MethodHook() {
                    @Override
                    protected void afterHookedMethod(MethodHookParam param) throws Throwable {
                        Object result = param.getResult();
                        android.content.Context context = (android.content.Context) param.args[0];
                        
                        if (result == null && context != null) {
                            XposedBridge.log(TAG + ": SpeechRecognizer returned null for default service");
                            
                            try {
                                java.lang.reflect.Constructor<?> constructor = speechRecognizerClass.getDeclaredConstructor(
                                    android.content.Context.class,
                                    android.content.ComponentName.class
                                );
                                constructor.setAccessible(true);
                                Object newRecognizer = constructor.newInstance(context, null);
                                
                                if (newRecognizer != null) {
                                    param.setResult(newRecognizer);
                                    XposedBridge.log(TAG + ": ✅ FORCED SpeechRecognizer creation (default service)!");
                                }
                            } catch (Exception e) {
                                XposedBridge.log(TAG + ": ❌ Failed to force create default SpeechRecognizer: " + e.getMessage());
                            }
                        }
                    }
                }
            );
            
            // Hook bindService to allow recognition service binding
            try {
                Class<?> contextImplClass = XposedHelpers.findClass(
                    "android.app.ContextImpl",
                    lpparam.classLoader
                );
                
                XposedHelpers.findAndHookMethod(
                    contextImplClass,
                    "bindService",
                    android.content.Intent.class,
                    android.content.ServiceConnection.class,
                    int.class,
                    new XC_MethodHook() {
                        @Override
                        protected void beforeHookedMethod(MethodHookParam param) throws Throwable {
                            android.content.Intent intent = (android.content.Intent) param.args[0];
                            if (intent != null) {
                                // Log all bindService calls to see what we're looking for
                                String action = intent.getAction();
                                android.content.ComponentName component = intent.getComponent();
                                
                                // Check for speech/recognition service patterns
                                boolean isSpeechRelated = false;
                                if (action != null && (action.contains("speech") || action.contains("Speech") || 
                                    action.contains("Recognition") || action.contains("recognition"))) {
                                    isSpeechRelated = true;
                                }
                                if (component != null && (component.flattenToString().contains("speech") || 
                                    component.flattenToString().contains("Speech") ||
                                    component.flattenToString().contains("Recognition") ||
                                    component.flattenToString().contains("GoogleRecognition"))) {
                                    isSpeechRelated = true;
                                }
                                
                                if (isSpeechRelated) {
                                    XposedBridge.log(TAG + ": 🔓 Intercepting speech-related bindService");
                                    XposedBridge.log(TAG + ":    Action: " + action);
                                    XposedBridge.log(TAG + ":    Component: " + (component != null ? component.flattenToString() : "null"));
                                }
                            }
                        }
                        
                        @Override
                        protected void afterHookedMethod(MethodHookParam param) throws Throwable {
                            android.content.Intent intent = (android.content.Intent) param.args[0];
                            if (intent != null) {
                                String action = intent.getAction();
                                android.content.ComponentName component = intent.getComponent();
                                
                                // Check for speech/recognition service patterns
                                boolean isSpeechRelated = false;
                                if (action != null && (action.contains("speech") || action.contains("Speech") || 
                                    action.contains("Recognition") || action.contains("recognition"))) {
                                    isSpeechRelated = true;
                                }
                                if (component != null && (component.flattenToString().contains("speech") || 
                                    component.flattenToString().contains("Speech") ||
                                    component.flattenToString().contains("Recognition") ||
                                    component.flattenToString().contains("GoogleRecognition"))) {
                                    isSpeechRelated = true;
                                }
                                
                                if (isSpeechRelated) {
                                    boolean result = (Boolean) param.getResult();
                                    if (!result) {
                                        XposedBridge.log(TAG + ": ⚠️ Speech service bind returned false, forcing true");
                                        param.setResult(true);
                                    } else {
                                        XposedBridge.log(TAG + ": ✅ Speech service bound successfully");
                                    }
                                }
                            }
                        }
                    }
                );
                
                XposedBridge.log(TAG + ": ✅ bindService hook installed");
            } catch (Throwable bindHookError) {
                XposedBridge.log(TAG + ": ⚠️ Could not hook bindService: " + bindHookError.getMessage());
            }
            
            XposedBridge.log(TAG + ": ✅ SpeechRecognizer hooks installed");
            
        } catch (Throwable t) {
            XposedBridge.log(TAG + ": ❌ Failed to hook SpeechRecognizer: " + t.getMessage());
        }
    }
    
    /**
     * Hook system server to bypass RecognitionService validation
     * 
     * The system rejects third-party apps from binding to speech services with:
     * "serviceComponent is not RecognitionService"
     * 
     * This hook bypasses that validation check.
     */
    private void hookSystemRecognitionService(XC_LoadPackage.LoadPackageParam lpparam) {
        try {
            XposedBridge.log(TAG + ": Setting up system RecognitionService validation bypass");
            
            // Try to hook SpeechRecognitionManagerServiceImpl
            try {
                Class<?> speechRecognitionManagerClass = XposedHelpers.findClass(
                    "com.android.server.speech.SpeechRecognitionManagerServiceImpl",
                    lpparam.classLoader
                );
                
                // Hook the method that binds to the recognition service
                XposedHelpers.findAndHookMethod(
                    speechRecognitionManagerClass,
                    "bindService",
                    android.content.Intent.class,
                    android.content.ServiceConnection.class,
                    new XC_MethodHook() {
                        @Override
                        protected void beforeHookedMethod(MethodHookParam param) throws Throwable {
                            android.content.Intent intent = (android.content.Intent) param.args[0];
                            if (intent != null) {
                                XposedBridge.log(TAG + ": 🔓 System-level speech service bind intercepted");
                                XposedBridge.log(TAG + ":    Intent: " + intent.toString());
                            }
                        }
                        
                        @Override
                        protected void afterHookedMethod(MethodHookParam param) throws Throwable {
                            boolean result = (Boolean) param.getResult();
                            if (!result) {
                                XposedBridge.log(TAG + ": ⚠️ System bind failed, forcing true");
                                param.setResult(true);
                            } else {
                                XposedBridge.log(TAG + ": ✅ System bind succeeded");
                            }
                        }
                    }
                );
                
                XposedBridge.log(TAG + ": ✅ System RecognitionService hook installed");
            } catch (Throwable hookError) {
                XposedBridge.log(TAG + ": ⚠️ Could not hook SpeechRecognitionManagerServiceImpl: " + hookError.getMessage());
            }
            
        } catch (Throwable t) {
            XposedBridge.log(TAG + ": ❌ Failed to hook system RecognitionService: " + t.getMessage());
        }
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
                        
                        // NOTE: Auto-refresh feature disabled - causes black screen issues
                        // User will need to manually restart app after firmware update
                        
                        // Create Audio and Transcription folder structure
                        try {
                            java.io.File downloadDir = android.os.Environment.getExternalStoragePublicDirectory(android.os.Environment.DIRECTORY_DOWNLOADS);
                            java.io.File dmrDir = new java.io.File(downloadDir, "DMR");
                            java.io.File audioDir = new java.io.File(dmrDir, "Audio");
                            java.io.File transcriptionDir = new java.io.File(dmrDir, "Transcription");
                            
                            if (!audioDir.exists()) {
                                if (audioDir.mkdirs()) {
                                    XposedBridge.log(TAG + ": Created Audio folder: " + audioDir.getAbsolutePath());
                                } else {
                                    XposedBridge.log(TAG + ": Failed to create Audio folder");
                                }
                            } else {
                                XposedBridge.log(TAG + ": Audio folder already exists");
                            }
                            
                            if (!transcriptionDir.exists()) {
                                if (transcriptionDir.mkdirs()) {
                                    XposedBridge.log(TAG + ": Created Transcription folder: " + transcriptionDir.getAbsolutePath());
                                } else {
                                    XposedBridge.log(TAG + ": Failed to create Transcription folder");
                                }
                            } else {
                                XposedBridge.log(TAG + ": Transcription folder already exists");
                            }
                            
                            // Create api_key.txt file with instructions if it doesn't exist
                            java.io.File apiKeyFile = new java.io.File(dmrDir, "api_key.txt");
                            if (!apiKeyFile.exists()) {
                                try {
                                    java.io.FileWriter writer = new java.io.FileWriter(apiKeyFile);
                                    writer.write("YOUR_GOOGLE_CLOUD_API_KEY_HERE\n");
                                    writer.write("\n");
                                    writer.write("# To enable transcription:\n");
                                    writer.write("# 1. Get a Google Cloud API key from: https://console.cloud.google.com\n");
                                    writer.write("# 2. Enable the 'Cloud Speech-to-Text API'\n");
                                    writer.write("# 3. Replace the first line with your API key (starts with AIza...)\n");
                                    writer.write("# 4. Press the TXT button in the app to start transcription\n");
                                    writer.write("#\n");
                                    writer.write("# Free tier: 60 minutes/month\n");
                                    writer.write("# After free tier: $0.006 per 15 seconds (~$1.44/hour)\n");
                                    writer.close();
                                    XposedBridge.log(TAG + ": Created api_key.txt with instructions: " + apiKeyFile.getAbsolutePath());
                                } catch (java.io.IOException e) {
                                    XposedBridge.log(TAG + ": Failed to create api_key.txt: " + e.getMessage());
                                }
                            } else {
                                XposedBridge.log(TAG + ": api_key.txt already exists");
                            }
                        } catch (Exception e) {
                            XposedBridge.log(TAG + ": Error creating DMR folders: " + e.getMessage());
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
                        
                        // **IMMEDIATE**: Reset APRS state on every app launch (static vars persist across restarts!)
                        XposedBridge.log(TAG + ": Resetting APRS state on app launch - was: " + isAPRSMonitoringActive);
                        isAPRSMonitoringActive = false;
                        if (aprsAudioBuffer != null) {
                            aprsAudioBuffer.clear();
                        }
                        // Also reset dialog references (they persist across app restarts too!)
                        aprsMonitoringDialog = null;
                        aprsUpdateHandler = null;
                        aprsUpdateRunnable = null;
                        
                        // Check for orphaned APRS channel and restore if needed (delayed to ensure DmrManager is ready)
                        final Activity activityForRestore = (Activity) param.thisObject;
                        new android.os.Handler().postDelayed(new Runnable() {
                            @Override
                            public void run() {
                                checkAndRestoreAPRSChannelOnStartup(activityForRestore);
                            }
                        }, 2000);  // 2 second delay
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
                            // Store fragment reference for zone channel switching
                            talkBackFragmentInstance = param.thisObject;
                            
                            // Capture the fragment's PrizePcmManager for APRS transmission
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
                                        // Completely disable dividers
                                        java.lang.reflect.Method setShowDividers = LinearLayout.class.getMethod("setShowDividers", int.class);
                                        setShowDividers.invoke(infoLayout, 0); // SHOW_DIVIDER_NONE
                                        
                                        // Remove divider drawable entirely
                                        java.lang.reflect.Method setDividerDrawable = LinearLayout.class.getMethod("setDividerDrawable", android.graphics.drawable.Drawable.class);
                                        setDividerDrawable.invoke(infoLayout, (android.graphics.drawable.Drawable) null);
                                        
                                        java.lang.reflect.Method setDividerPadding = LinearLayout.class.getMethod("setDividerPadding", int.class);
                                        setDividerPadding.invoke(infoLayout, 0);
                                        
                                        // Remove all padding and set minimum height to 0
                                        infoLayout.setPadding(0, 0, 0, 0);
                                        infoLayout.setMinimumHeight(0);
                                        
                                        // Remove all spacing from child views
                                        for (int i = 0; i < infoLayout.getChildCount(); i++) {
                                            View child = infoLayout.getChildAt(i);
                                            if (child instanceof TextView) {
                                                TextView tv = (TextView) child;
                                                // Remove line spacing
                                                tv.setLineSpacing(0, 1.0f);
                                                // Remove all padding
                                                tv.setPadding(0, 0, 0, 0);
                                                // Remove minimum height
                                                tv.setMinimumHeight(0);
                                                tv.setMinHeight(0);
                                                // Remove margins if any
                                                if (tv.getLayoutParams() instanceof ViewGroup.MarginLayoutParams) {
                                                    ViewGroup.MarginLayoutParams params = (ViewGroup.MarginLayoutParams) tv.getLayoutParams();
                                                    params.setMargins(0, 0, 0, 0);
                                                    tv.setLayoutParams(params);
                                                }
                                            }
                                        }
                                        
                                        XposedBridge.log(TAG + ": ✓ Successfully removed all channel info spacing (dividers cleared, min heights set to 0)");
                                    } catch (Exception e) {
                                        XposedBridge.log(TAG + ": Error setting dividers: " + e.getMessage());
                                    }
                                }
                                
                                // Make infoText take 60% width
                                LinearLayout.LayoutParams infoParams = new LinearLayout.LayoutParams(
                                    0,
                                    LinearLayout.LayoutParams.WRAP_CONTENT,
                                    0.6f
                                );
                                infoText.setLayoutParams(infoParams);
                                horizontalContainer.addView(infoText);
                                
                                // Create location TextView (40% width, right-aligned)
                                TextView locationText = new TextView(context);
                                locationText.setTag("DMR_LOCATION_TEXT");
                                LinearLayout.LayoutParams locationParams = new LinearLayout.LayoutParams(
                                    0,
                                    LinearLayout.LayoutParams.WRAP_CONTENT,
                                    0.4f
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
                                borderParams.topMargin = (int) (8 * context.getResources().getDisplayMetrics().density); // 8dp spacing
                                
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
                                
                                // Create transcription display box (bottom of borderbox)
                                LinearLayout transcriptionBoxLayout = new LinearLayout(context);
                                transcriptionBoxLayout.setOrientation(LinearLayout.VERTICAL);
                                transcriptionBoxLayout.setTag("DMR_TRANSCRIPTION_BOX_LAYOUT");
                                FrameLayout.LayoutParams transcriptionBoxParams = new FrameLayout.LayoutParams(
                                    FrameLayout.LayoutParams.MATCH_PARENT,
                                    FrameLayout.LayoutParams.WRAP_CONTENT
                                );
                                transcriptionBoxParams.gravity = android.view.Gravity.BOTTOM;
                                transcriptionBoxParams.leftMargin = (int) (8 * context.getResources().getDisplayMetrics().density);
                                transcriptionBoxParams.rightMargin = (int) (8 * context.getResources().getDisplayMetrics().density);
                                transcriptionBoxParams.bottomMargin = (int) (8 * context.getResources().getDisplayMetrics().density);
                                
                                // Create border for transcription box
                                android.graphics.drawable.GradientDrawable transcriptionBoxDrawable = new android.graphics.drawable.GradientDrawable();
                                transcriptionBoxDrawable.setShape(android.graphics.drawable.GradientDrawable.RECTANGLE);
                                transcriptionBoxDrawable.setStroke(
                                    (int) (2 * context.getResources().getDisplayMetrics().density),
                                    0xAA00BFFF  // Cyan border
                                );
                                transcriptionBoxDrawable.setCornerRadius(8 * context.getResources().getDisplayMetrics().density);
                                transcriptionBoxDrawable.setColor(0x1500BFFF);  // Subtle cyan background
                                
                                transcriptionBoxLayout.setBackground(transcriptionBoxDrawable);
                                transcriptionBoxLayout.setLayoutParams(transcriptionBoxParams);
                                int transcriptionPadding = (int) (8 * context.getResources().getDisplayMetrics().density);
                                transcriptionBoxLayout.setPadding(transcriptionPadding, transcriptionPadding, transcriptionPadding, transcriptionPadding);
                                
                                // Add header TextView
                                TextView transcriptionHeaderView = new TextView(context);
                                transcriptionHeaderView.setText("📝 Transcription");
                                transcriptionHeaderView.setTextColor(0xFF00BFFF);  // Cyan
                                transcriptionHeaderView.setTextSize(10);
                                transcriptionHeaderView.setTypeface(null, android.graphics.Typeface.BOLD);
                                LinearLayout.LayoutParams transcriptionHeaderParams = new LinearLayout.LayoutParams(
                                    LinearLayout.LayoutParams.WRAP_CONTENT,
                                    LinearLayout.LayoutParams.WRAP_CONTENT
                                );
                                transcriptionHeaderParams.bottomMargin = (int) (4 * context.getResources().getDisplayMetrics().density);
                                transcriptionHeaderView.setLayoutParams(transcriptionHeaderParams);
                                transcriptionBoxLayout.addView(transcriptionHeaderView);
                                
                                // Add ScrollView for transcription messages
                                android.widget.ScrollView transcriptionScroll = new android.widget.ScrollView(context);
                                transcriptionScroll.setTag("DMR_TRANSCRIPTION_SCROLL");
                                transcriptionScroll.setVerticalScrollBarEnabled(true);
                                transcriptionScroll.setFillViewport(false);
                                
                                // Start with WRAP_CONTENT to grow with messages, will be capped at max height
                                LinearLayout.LayoutParams scrollParams = new LinearLayout.LayoutParams(
                                    LinearLayout.LayoutParams.MATCH_PARENT,
                                    LinearLayout.LayoutParams.WRAP_CONTENT
                                );
                                transcriptionScroll.setLayoutParams(scrollParams);
                                
                                // Container for messages (vertical LinearLayout)
                                LinearLayout transcriptionMessagesLayout = new LinearLayout(context);
                                transcriptionMessagesLayout.setOrientation(LinearLayout.VERTICAL);
                                transcriptionMessagesLayout.setTag("DMR_TRANSCRIPTION_MESSAGES");
                                LinearLayout.LayoutParams messagesParams = new LinearLayout.LayoutParams(
                                    LinearLayout.LayoutParams.MATCH_PARENT,
                                    LinearLayout.LayoutParams.WRAP_CONTENT
                                );
                                transcriptionMessagesLayout.setLayoutParams(messagesParams);
                                
                                transcriptionScroll.addView(transcriptionMessagesLayout);
                                transcriptionBoxLayout.addView(transcriptionScroll);
                                
                                // Initially hidden
                                transcriptionBoxLayout.setVisibility(View.GONE);
                                
                                borderBox.addView(transcriptionBoxLayout);
                                
                                // Store references
                                transcriptionMessagesContainer = transcriptionMessagesLayout;
                                transcriptionScrollView = transcriptionScroll;
                                transcriptionBox = transcriptionBoxLayout;
                                
                                // Create horizontal container for RSSI box and Zone button
                                LinearLayout rssiZoneContainer = new LinearLayout(context);
                                rssiZoneContainer.setOrientation(LinearLayout.HORIZONTAL);
                                rssiZoneContainer.setTag("DMR_RSSI_ZONE_CONTAINER");
                                LinearLayout.LayoutParams rssiZoneContainerParams = new LinearLayout.LayoutParams(
                                    LinearLayout.LayoutParams.MATCH_PARENT,
                                    LinearLayout.LayoutParams.WRAP_CONTENT
                                );
                                rssiZoneContainerParams.leftMargin = margin10dp;
                                rssiZoneContainerParams.rightMargin = margin10dp;
                                rssiZoneContainerParams.topMargin = (int) (4 * context.getResources().getDisplayMetrics().density);
                                rssiZoneContainerParams.bottomMargin = 0;
                                rssiZoneContainer.setLayoutParams(rssiZoneContainerParams);
                                
                                // Create RSSI display box (left half)
                                LinearLayout rssiBox = new LinearLayout(context);
                                rssiBox.setOrientation(LinearLayout.HORIZONTAL);
                                rssiBox.setTag("DMR_RSSI_BOX");
                                LinearLayout.LayoutParams rssiBoxParams = new LinearLayout.LayoutParams(
                                    0,
                                    LinearLayout.LayoutParams.WRAP_CONTENT,
                                    0.5f
                                );
                                rssiBoxParams.rightMargin = (int) (4 * context.getResources().getDisplayMetrics().density);
                                
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
                                int rssiPadding = (int) (4 * context.getResources().getDisplayMetrics().density);
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
                                rssiBox.setVisibility(View.INVISIBLE);  // Hidden but reserves space
                                
                                // Store reference for updates
                                rssiDisplayTextView = rssiText;
                                
                                // Add RSSI box to container
                                rssiZoneContainer.addView(rssiBox);
                                
                                // Create ZONE selector button (right half)
                                android.widget.Button zoneButtonWidget = new android.widget.Button(context);
                                zoneButtonWidget.setTag("DMR_ZONE_SELECTOR");
                                zoneButtonWidget.setText("Zone: All");
                                
                                LinearLayout.LayoutParams zoneButtonParams = new LinearLayout.LayoutParams(
                                    0,
                                    LinearLayout.LayoutParams.WRAP_CONTENT,
                                    0.5f
                                );
                                zoneButtonParams.leftMargin = (int) (4 * context.getResources().getDisplayMetrics().density);
                                zoneButtonWidget.setLayoutParams(zoneButtonParams);
                                zoneButtonWidget.setTextSize(12);
                                zoneButtonWidget.setTypeface(null, android.graphics.Typeface.BOLD);
                                zoneButtonWidget.setTextColor(0xFFFFFFFF);  // White text
                                
                                // Create drawable for zone selector button
                                android.graphics.drawable.GradientDrawable zoneSelectorDrawable = new android.graphics.drawable.GradientDrawable();
                                zoneSelectorDrawable.setShape(android.graphics.drawable.GradientDrawable.RECTANGLE);
                                zoneSelectorDrawable.setColor(0xFF4169E1);  // Royal blue
                                zoneSelectorDrawable.setCornerRadius(8 * context.getResources().getDisplayMetrics().density);
                                zoneSelectorDrawable.setStroke(
                                    (int) (2 * context.getResources().getDisplayMetrics().density),
                                    0xFFFFFFFF  // White border
                                );
                                zoneButtonWidget.setBackground(zoneSelectorDrawable);
                                
                                // Store reference
                                zoneButton = zoneButtonWidget;
                                
                                // Initialize ZoneDatabase
                                zoneDatabase = ZoneDatabase.getInstance(context);
                                
                                // Set click listener
                                zoneButtonWidget.setOnClickListener(new View.OnClickListener() {
                                    @Override
                                    public void onClick(View v) {
                                        XposedBridge.log(TAG + ": Intercom zone button clicked!");
                                        try {
                                            // Get the activity
                                            android.app.Activity activity = (android.app.Activity) context;
                                            XposedBridge.log(TAG + ": Got activity: " + activity.getClass().getName());
                                            
                                            // Find and click the channel tab button at the bottom
                                            try {
                                                // Find the root view of the activity
                                                View activityRootView = activity.findViewById(android.R.id.content);
                                                XposedBridge.log(TAG + ": Got root view: " + (activityRootView != null));
                                                
                                                // Try to find the channel button by ID
                                                // Based on the layout: android:id="@id/channel"
                                                int channelButtonId = activity.getResources().getIdentifier("channel", "id", activity.getPackageName());
                                                XposedBridge.log(TAG + ": Channel button ID: " + channelButtonId);
                                                
                                                if (channelButtonId != 0) {
                                                    View channelButton = activity.findViewById(channelButtonId);
                                                    XposedBridge.log(TAG + ": Channel button found: " + (channelButton != null));
                                                    
                                                    if (channelButton != null) {
                                                        // Click the channel button to switch tabs
                                                        channelButton.performClick();
                                                        XposedBridge.log(TAG + ": Clicked channel button");
                                                        
                                                        // Post a delayed action to click the channel page zone button
                                                        new android.os.Handler(android.os.Looper.getMainLooper()).postDelayed(new Runnable() {
                                                            @Override
                                                            public void run() {
                                                                try {
                                                                    if (channelPageZoneButton != null) {
                                                                        XposedBridge.log(TAG + ": Clicking channel page zone button");
                                                                        channelPageZoneButton.performClick();
                                                                    } else {
                                                                        XposedBridge.log(TAG + ": Channel page zone button is null");
                                                                        Toast.makeText(context, "Channel page not ready", Toast.LENGTH_SHORT).show();
                                                                    }
                                                                } catch (Throwable t) {
                                                                    XposedBridge.log(TAG + ": Error clicking channel page zone button: " + t.getMessage());
                                                                }
                                                            }
                                                        }, 300); // 300ms delay to let page switch complete
                                                        
                                                        return; // Success, exit early
                                                    }
                                                }
                                                
                                                XposedBridge.log(TAG + ": Could not find channel button, falling back to dialog");
                                                // Fallback: just show the dialog on intercom page
                                                showZoneSelectionDialog(context);
                                            } catch (Throwable t) {
                                                XposedBridge.log(TAG + ": Could not switch tabs: " + t.getMessage());
                                                XposedBridge.log(t);
                                                // Fallback: just show the dialog on intercom page
                                                showZoneSelectionDialog(context);
                                            }
                                        } catch (Throwable t) {
                                            XposedBridge.log(TAG + ": Zone selector error: " + t.getMessage());
                                            XposedBridge.log(t);
                                            Toast.makeText(context, "Error showing zone selector", Toast.LENGTH_SHORT).show();
                                        }
                                    }
                                });
                                
                                // Add zone button to container
                                rssiZoneContainer.addView(zoneButtonWidget);
                                
                                // Insert container at index 2
                                rootLayout.addView(rssiZoneContainer, 2);
                                XposedBridge.log(TAG + ": ✓ Added RSSI/Zone container at index 2");
                                
                                // ========== SOFTWARE SQUELCH SLIDER ==========
                                // Calculate additional margin values
                                int margin8dp = (int) (8 * context.getResources().getDisplayMetrics().density);
                                int margin16dp = (int) (16 * context.getResources().getDisplayMetrics().density);
                                int negMargin16dp = (int) (-16 * context.getResources().getDisplayMetrics().density);
                                
                                // Get screen width for half-width layout
                                int screenWidth = context.getResources().getDisplayMetrics().widthPixels;
                                int halfScreenWidth = screenWidth / 2;
                                
                                // Create squelch control container (half width, aligned left)
                                LinearLayout squelchContainer = new LinearLayout(context);
                                squelchContainer.setTag("DMR_SQUELCH_CONTAINER");
                                squelchContainer.setOrientation(LinearLayout.HORIZONTAL);
                                LinearLayout.LayoutParams squelchContainerParams = new LinearLayout.LayoutParams(
                                    halfScreenWidth,  // Half screen width
                                    LinearLayout.LayoutParams.WRAP_CONTENT
                                );
                                squelchContainerParams.topMargin = (int)(-18 * context.getResources().getDisplayMetrics().density);  // Pull up closer to RSSI (reduced from -16dp to -18dp)
                                squelchContainerParams.bottomMargin = (int)(-6 * context.getResources().getDisplayMetrics().density);  // Pull up content below
                                squelchContainerParams.leftMargin = margin16dp;
                                squelchContainerParams.rightMargin = 0;  // No right margin
                                squelchContainer.setLayoutParams(squelchContainerParams);
                                // No background - transparent
                                squelchContainer.setPadding(0, 0, 0, 0);  // No padding
                                
                                // Squelch label "SQ:" - LEFT SIDE
                                TextView squelchLabel = new TextView(context);
                                squelchLabel.setText("SQ:");
                                squelchLabel.setTextColor(0xFFFFFFFF);
                                squelchLabel.setTextSize(14);
                                squelchLabel.setTypeface(null, android.graphics.Typeface.BOLD);
                                LinearLayout.LayoutParams labelParams = new LinearLayout.LayoutParams(
                                    LinearLayout.LayoutParams.WRAP_CONTENT,
                                    LinearLayout.LayoutParams.WRAP_CONTENT
                                );
                                labelParams.gravity = android.view.Gravity.CENTER_VERTICAL;
                                labelParams.rightMargin = (int) (2 * context.getResources().getDisplayMetrics().density);  // Reduced from 4dp to 2dp
                                squelchLabel.setLayoutParams(labelParams);
                                squelchContainer.addView(squelchLabel);
                                
                                // Squelch value label (shows current level) - RIGHT OF "SQ:"
                                TextView squelchValueLabel = new TextView(context);
                                squelchValueLabel.setTag("DMR_SQUELCH_VALUE");
                                squelchValueLabel.setText("5");
                                squelchValueLabel.setTextColor(0xFF00FF00); // Green
                                squelchValueLabel.setTextSize(18);
                                squelchValueLabel.setTypeface(null, android.graphics.Typeface.BOLD);
                                squelchValueLabel.setGravity(android.view.Gravity.CENTER);
                                LinearLayout.LayoutParams valueLabelParams = new LinearLayout.LayoutParams(
                                    LinearLayout.LayoutParams.WRAP_CONTENT,
                                    LinearLayout.LayoutParams.WRAP_CONTENT
                                );
                                valueLabelParams.gravity = android.view.Gravity.CENTER_VERTICAL;
                                squelchValueLabel.setLayoutParams(valueLabelParams);
                                squelchContainer.addView(squelchValueLabel);
                                
                                // Squelch slider
                                android.widget.SeekBar squelchSeekBar = new android.widget.SeekBar(context);
                                squelchSeekBar.setTag("DMR_SQUELCH_SEEKBAR");
                                LinearLayout.LayoutParams squelchSeekBarParams = new LinearLayout.LayoutParams(
                                    0,
                                    LinearLayout.LayoutParams.WRAP_CONTENT
                                );
                                squelchSeekBarParams.weight = 1.0f;
                                squelchSeekBarParams.topMargin = (int) (4 * context.getResources().getDisplayMetrics().density);
                                squelchSeekBarParams.leftMargin = margin10dp;
                                squelchSeekBarParams.rightMargin = margin10dp;
                                squelchSeekBar.setLayoutParams(squelchSeekBarParams);
                                squelchSeekBar.setMax(9); // 0-9 squelch levels
                                squelchSeekBar.setProgress(5); // Default to middle
                                
                                // Make slider white for visibility (both progress and background)
                                try {
                                    android.content.res.ColorStateList whiteColor = android.content.res.ColorStateList.valueOf(0xFFFFFFFF);
                                    squelchSeekBar.setProgressTintList(whiteColor);
                                    squelchSeekBar.setProgressBackgroundTintList(whiteColor);  // Make entire track white
                                    squelchSeekBar.setThumbTintList(whiteColor);
                                } catch (Exception e) {
                                    XposedBridge.log(TAG + ": Could not set slider color: " + e);
                                }
                                
                                squelchContainer.addView(squelchSeekBar);
                                
                                // Store references for later updates
                                final TextView finalSquelchValueLabel = squelchValueLabel;
                                squelchValueTextView = squelchValueLabel;
                                // Note: Status indicator removed for cleaner UI
                                
                                // Set up SeekBar listener
                                squelchSeekBar.setOnSeekBarChangeListener(new android.widget.SeekBar.OnSeekBarChangeListener() {
                                    @Override
                                    public void onProgressChanged(android.widget.SeekBar seekBar, int progress, boolean fromUser) {
                                        if (fromUser) {
                                            // Update value display
                                            finalSquelchValueLabel.setText(String.valueOf(progress));
                                            
                                            // Update software squelch threshold (0-9 maps to threshold array)
                                            softwareSquelchThreshold = progress;
                                            
                                            XposedBridge.log(TAG + ": Squelch slider moved to level " + progress + 
                                                " (RMS threshold: " + getAudioSquelchThreshold() + 
                                                ", RSSI threshold: " + getRssiThreshold(progress) + ")");
                                        }
                                    }
                                    
                                    @Override
                                    public void onStartTrackingTouch(android.widget.SeekBar seekBar) {
                                        // User started dragging
                                    }
                                    
                                    @Override
                                    public void onStopTrackingTouch(android.widget.SeekBar seekBar) {
                                        // User finished dragging - apply hardware squelch and save to preferences
                                        int progress = seekBar.getProgress();
                                        
                                        // If software squelch is enabled and level >= 1, open hardware squelch so software squelch can work
                                        // If squelch level == 0 or software squelch disabled, leave hardware squelch alone (use channel's setting)
                                        if (isSoftwareSquelchEnabled && progress >= 1) {
                                            enableSoftwareSquelchOnCurrentChannel();
                                            XposedBridge.log(TAG + ": Applied hardware squelch for software squelch level " + progress);
                                        }
                                        
                                        // Save to SharedPreferences for persistence
                                        try {
                                            APRSDatabase aprsDb = APRSDatabase.getInstance(context);
                                            if (aprsDb != null) {
                                                XposedHelpers.callMethod(aprsDb, "setAprsSquelch", progress);
                                                XposedBridge.log(TAG + ": Saved software squelch level " + progress + " to preferences");
                                            }
                                        } catch (Throwable t) {
                                            XposedBridge.log(TAG + ": Error saving squelch to preferences: " + t);
                                        }
                                    }
                                });
                                
                                // Load saved squelch value from preferences
                                try {
                                    APRSDatabase aprsDb = APRSDatabase.getInstance(context);
                                    if (aprsDb != null) {
                                        int savedSquelch = (Integer) XposedHelpers.callMethod(aprsDb, "getAprsSquelch");
                                        squelchSeekBar.setProgress(savedSquelch);
                                        softwareSquelchThreshold = savedSquelch;
                                        finalSquelchValueLabel.setText(String.valueOf(savedSquelch));
                                        XposedBridge.log(TAG + ": Loaded saved squelch level: " + savedSquelch);
                                        
                                        // If software squelch enabled and saved squelch >= 1, open hardware squelch for software squelch to work
                                        // If saved squelch == 0 or software squelch disabled, leave hardware squelch at channel's setting
                                        if (isSoftwareSquelchEnabled && savedSquelch >= 1) {
                                            rootLayout.postDelayed(new Runnable() {
                                                @Override
                                                public void run() {
                                                    enableSoftwareSquelchOnCurrentChannel();
                                                    XposedBridge.log(TAG + ": Opened hardware squelch for software squelch (level " + savedSquelch + ")");
                                                }
                                            }, 500);
                                        }
                                    }
                                } catch (Throwable t) {
                                    XposedBridge.log(TAG + ": Could not load saved squelch, using default (5): " + t);
                                }
                                
                                // Insert squelch container at index 3 (initially hidden if software squelch disabled)
                                squelchContainer.setVisibility(isSoftwareSquelchEnabled ? View.VISIBLE : View.GONE);
                                rootLayout.addView(squelchContainer, 3);
                                XposedBridge.log(TAG + ": ✓ Added squelch slider at index 3 (initially " + (isSoftwareSquelchEnabled ? "visible" : "hidden") + ")");
                                
                                // Insert borderbox at index 4 (pushed down by squelch slider)
                                rootLayout.addView(borderBox, 4);
                                XposedBridge.log(TAG + ": ✓ Added borderbox at index 4 (250dp)");
                                
                                // Create spacer
                                View spacer = new View(context);
                                spacer.setTag("DMR_SPACER");
                                LinearLayout.LayoutParams spacerParams = new LinearLayout.LayoutParams(
                                    LinearLayout.LayoutParams.MATCH_PARENT,
                                    0
                                );
                                spacerParams.weight = 1.0f;
                                spacer.setLayoutParams(spacerParams);
                                
                                rootLayout.addView(spacer, 5);
                                XposedBridge.log(TAG + ": ✓ Added spacer at index 5");
                                
                                // Create a container for PTT button and recording toggle
                                FrameLayout buttonContainer = new FrameLayout(context);
                                LinearLayout.LayoutParams containerParams = new LinearLayout.LayoutParams(
                                    LinearLayout.LayoutParams.MATCH_PARENT,
                                    LinearLayout.LayoutParams.WRAP_CONTENT
                                );
                                containerParams.bottomMargin = margin10dp;
                                buttonContainer.setLayoutParams(containerParams);
                                
                                rootLayout.addView(buttonContainer, 6);
                                XposedBridge.log(TAG + ": ✓ Added button container at index 6");
                                
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
                                
                                // Create transcription toggle button (left of PTT button)
                                android.widget.ToggleButton transcriptionToggle = new android.widget.ToggleButton(context);
                                transcriptionToggle.setTag("DMR_TRANSCRIPTION_TOGGLE");
                                transcriptionToggle.setTextOn("TXT");
                                transcriptionToggle.setTextOff("TXT");
                                transcriptionToggle.setChecked(false);
                                
                                FrameLayout.LayoutParams transcriptionToggleParams = new FrameLayout.LayoutParams(
                                    (int) (70 * context.getResources().getDisplayMetrics().density),  // 70dp width
                                    (int) (40 * context.getResources().getDisplayMetrics().density)   // 40dp height
                                );
                                transcriptionToggleParams.gravity = android.view.Gravity.START | android.view.Gravity.CENTER_VERTICAL;
                                transcriptionToggleParams.leftMargin = (int) (10 * context.getResources().getDisplayMetrics().density); // 10dp from left edge
                                transcriptionToggle.setLayoutParams(transcriptionToggleParams);
                                transcriptionToggle.setTextSize(14);
                                transcriptionToggle.setTypeface(null, android.graphics.Typeface.BOLD);
                                transcriptionToggle.setTextColor(0xFFFFFFFF);  // White text
                                
                                // Create state list drawable for purple background
                                android.graphics.drawable.StateListDrawable transcriptionStateDrawable = new android.graphics.drawable.StateListDrawable();
                                
                                // Checked state (transcription enabled) - Solid purple background
                                android.graphics.drawable.GradientDrawable transcriptionCheckedDrawable = new android.graphics.drawable.GradientDrawable();
                                transcriptionCheckedDrawable.setShape(android.graphics.drawable.GradientDrawable.RECTANGLE);
                                transcriptionCheckedDrawable.setColor(0xFF9370DB);  // Medium purple
                                transcriptionCheckedDrawable.setCornerRadius(20 * context.getResources().getDisplayMetrics().density);
                                transcriptionCheckedDrawable.setStroke(
                                    (int) (2 * context.getResources().getDisplayMetrics().density),
                                    0xFFFFFFFF  // White border
                                );
                                transcriptionStateDrawable.addState(new int[]{android.R.attr.state_checked}, transcriptionCheckedDrawable);
                                
                                // Unchecked state (transcription disabled) - Light purple background
                                android.graphics.drawable.GradientDrawable transcriptionUncheckedDrawable = new android.graphics.drawable.GradientDrawable();
                                transcriptionUncheckedDrawable.setShape(android.graphics.drawable.GradientDrawable.RECTANGLE);
                                transcriptionUncheckedDrawable.setColor(0x609370DB);  // Light purple (transparent version of ON color)
                                transcriptionUncheckedDrawable.setCornerRadius(20 * context.getResources().getDisplayMetrics().density);
                                transcriptionUncheckedDrawable.setStroke(
                                    (int) (2 * context.getResources().getDisplayMetrics().density),
                                    0x80FFFFFF  // Semi-transparent white border
                                );
                                transcriptionStateDrawable.addState(new int[]{}, transcriptionUncheckedDrawable);
                                
                                transcriptionToggle.setBackground(transcriptionStateDrawable);
                                
                                // Store reference
                                transcriptionToggleButton = transcriptionToggle;
                                
                                // Bind to transcription service (IPC)
                                bindToTranscriptionService(context);
                                
                                // Set click listener for transcription toggle
                                transcriptionToggle.setOnClickListener(new View.OnClickListener() {
                                    @Override
                                    public void onClick(View v) {
                                        if (transcriptionToggle.isChecked()) {
                                            // Check if API key is configured
                                            String apiKey = readApiKeyFromFile();
                                            if (apiKey == null || apiKey.isEmpty() || apiKey.equals("YOUR_GOOGLE_CLOUD_API_KEY_HERE")) {
                                                // API key not configured - show configuration dialog
                                                transcriptionToggle.setChecked(false); // Uncheck the button
                                                showApiKeyConfigDialog(context, transcriptionToggle);
                                                return;
                                            }
                                            
                                            // User wants to enable transcription
                                            if (!isServiceBound || transcriptionService == null) {
                                                // Service not bound yet
                                                isTranscriptionEnabled = true;
                                                Toast.makeText(context, "Connecting to transcription service...", Toast.LENGTH_SHORT).show();
                                                bindToTranscriptionService(context);
                                            } else {
                                                // Service already bound
                                                isTranscriptionEnabled = true;
                                                XposedBridge.log(TAG + ": Transcription enabled");
                                                Toast.makeText(context, "Transcription enabled", Toast.LENGTH_SHORT).show();
                                            }
                                        } else {
                                            // User disabled transcription
                                            isTranscriptionEnabled = false;
                                            XposedBridge.log(TAG + ": Transcription disabled");
                                            Toast.makeText(context, "Transcription disabled", Toast.LENGTH_SHORT).show();
                                            
                                            // Clear buffer and display
                                            audioBuffer.clear();
                                            currentTranscription = "";
                                            if (transcriptionMessagesContainer != null) {
                                                transcriptionMessagesContainer.post(() -> {
                                                    transcriptionMessagesContainer.removeAllViews();  // Clear all messages
                                                    if (transcriptionBox != null) {
                                                        transcriptionBox.setVisibility(View.GONE);
                                                    }
                                                });
                                            }
                                        }
                                    }
                                });
                                
                                // Set long-press listener to reconfigure API key
                                transcriptionToggle.setOnLongClickListener(new View.OnLongClickListener() {
                                    @Override
                                    public boolean onLongClick(View v) {
                                        // Long press always shows the dialog (even with valid key)
                                        showApiKeyConfigDialog(context, transcriptionToggle);
                                        return true; // Consume the event
                                    }
                                });
                                
                                buttonContainer.addView(transcriptionToggle);
                                XposedBridge.log(TAG + ": ✓ Added transcription toggle button");
                                
                                // Create software squelch toggle button (above TXT button, left side)
                                android.widget.ToggleButton softSqToggle = new android.widget.ToggleButton(context);
                                softSqToggle.setTag("DMR_SOFT_SQUELCH_TOGGLE");
                                softSqToggle.setTextOn("Soft SQ");
                                softSqToggle.setTextOff("Soft SQ");
                                softSqToggle.setChecked(isSoftwareSquelchEnabled);
                                
                                FrameLayout.LayoutParams softSqToggleParams = new FrameLayout.LayoutParams(
                                    (int) (90 * context.getResources().getDisplayMetrics().density),  // 90dp width for "Soft SQ"
                                    (int) (40 * context.getResources().getDisplayMetrics().density)   // 40dp height
                                );
                                softSqToggleParams.gravity = android.view.Gravity.START | android.view.Gravity.TOP;
                                softSqToggleParams.leftMargin = (int) (10 * context.getResources().getDisplayMetrics().density); // 10dp from left edge
                                softSqToggleParams.topMargin = (int) (10 * context.getResources().getDisplayMetrics().density); // 10dp from top
                                softSqToggle.setLayoutParams(softSqToggleParams);
                                softSqToggle.setTextSize(12);  // Slightly smaller for "Soft SQ"
                                softSqToggle.setTypeface(null, android.graphics.Typeface.BOLD);
                                softSqToggle.setTextColor(0xFFFFFFFF);  // White text
                                
                                // Create state list drawable for software squelch button
                                android.graphics.drawable.StateListDrawable softSqStateDrawable = new android.graphics.drawable.StateListDrawable();
                                
                                // Checked state (software squelch enabled) - Blue background
                                android.graphics.drawable.GradientDrawable softSqCheckedDrawable = new android.graphics.drawable.GradientDrawable();
                                softSqCheckedDrawable.setShape(android.graphics.drawable.GradientDrawable.RECTANGLE);
                                softSqCheckedDrawable.setColor(0xFF2196F3);  // Material blue
                                softSqCheckedDrawable.setCornerRadius(20 * context.getResources().getDisplayMetrics().density);
                                softSqCheckedDrawable.setStroke(
                                    (int) (2 * context.getResources().getDisplayMetrics().density),
                                    0xFFFFFFFF  // White border
                                );
                                softSqStateDrawable.addState(new int[]{android.R.attr.state_checked}, softSqCheckedDrawable);
                                
                                // Unchecked state (software squelch disabled) - Light blue background
                                android.graphics.drawable.GradientDrawable softSqUncheckedDrawable = new android.graphics.drawable.GradientDrawable();
                                softSqUncheckedDrawable.setShape(android.graphics.drawable.GradientDrawable.RECTANGLE);
                                softSqUncheckedDrawable.setColor(0x602196F3);  // Light blue (transparent version of ON color)
                                softSqUncheckedDrawable.setCornerRadius(20 * context.getResources().getDisplayMetrics().density);
                                softSqUncheckedDrawable.setStroke(
                                    (int) (2 * context.getResources().getDisplayMetrics().density),
                                    0x80FFFFFF  // Semi-transparent white border
                                );
                                softSqStateDrawable.addState(new int[]{}, softSqUncheckedDrawable);
                                
                                softSqToggle.setBackground(softSqStateDrawable);
                                
                                // Store reference
                                softwareSquelchToggleButton = softSqToggle;
                                
                                // Set click listener for software squelch toggle
                                softSqToggle.setOnClickListener(new View.OnClickListener() {
                                    @Override
                                    public void onClick(View v) {
                                        isSoftwareSquelchEnabled = softSqToggle.isChecked();
                                        
                                        // Find the squelch slider container
                                        View squelchContainer = rootLayout.findViewWithTag("DMR_SQUELCH_CONTAINER");
                                        
                                        if (isSoftwareSquelchEnabled) {
                                            // Enabling software squelch
                                            XposedBridge.log(TAG + ": Software squelch enabled");
                                            Toast.makeText(context, "Software squelch enabled", Toast.LENGTH_SHORT).show();
                                            
                                            // Show the slider
                                            if (squelchContainer != null && currentChannelType == 1) {
                                                squelchContainer.setVisibility(View.VISIBLE);
                                            }
                                            
                                            // Set hardware squelch to 0 immediately (if level >= 1)
                                            if (softwareSquelchThreshold >= 1) {
                                                enableSoftwareSquelchOnCurrentChannel();
                                            }
                                        } else {
                                            // Disabling software squelch
                                            XposedBridge.log(TAG + ": Software squelch disabled - reverting to hardware squelch 2");
                                            Toast.makeText(context, "Hardware squelch enabled", Toast.LENGTH_SHORT).show();
                                            
                                            // Hide the slider
                                            if (squelchContainer != null) {
                                                squelchContainer.setVisibility(View.GONE);
                                            }
                                            
                                            // Set hardware squelch to 2
                                            disableSoftwareSquelchOnCurrentChannel();
                                        }
                                    }
                                });
                                
                                buttonContainer.addView(softSqToggle);
                                XposedBridge.log(TAG + ": ✓ Added software squelch toggle button above TXT");
                                
                                // Create recording toggle button (right-aligned)
                                android.widget.ToggleButton recordToggle = new android.widget.ToggleButton(context);
                                recordToggle.setTag("DMR_RECORDING_TOGGLE");
                                recordToggle.setTextOn("REC");
                                recordToggle.setTextOff("REC");
                                recordToggle.setChecked(false);
                                
                                FrameLayout.LayoutParams toggleParams = new FrameLayout.LayoutParams(
                                    (int) (70 * context.getResources().getDisplayMetrics().density),  // 70dp width
                                    (int) (40 * context.getResources().getDisplayMetrics().density)   // 40dp height
                                );
                                toggleParams.gravity = android.view.Gravity.END | android.view.Gravity.TOP;
                                toggleParams.rightMargin = (int) (16 * context.getResources().getDisplayMetrics().density);
                                toggleParams.topMargin = (int) (10 * context.getResources().getDisplayMetrics().density); // 10dp from top
                                recordToggle.setLayoutParams(toggleParams);
                                recordToggle.setTextSize(14);
                                recordToggle.setTypeface(null, android.graphics.Typeface.BOLD);
                                recordToggle.setTextColor(0xFFFFFFFF);  // White text
                                
                                // Create state list drawable for background
                                android.graphics.drawable.StateListDrawable stateDrawable = new android.graphics.drawable.StateListDrawable();
                                
                                // Checked state (recording enabled) - Red background
                                android.graphics.drawable.GradientDrawable checkedDrawable = new android.graphics.drawable.GradientDrawable();
                                checkedDrawable.setShape(android.graphics.drawable.GradientDrawable.RECTANGLE);
                                checkedDrawable.setColor(0xFFFF0000);  // Solid red
                                checkedDrawable.setCornerRadius(20 * context.getResources().getDisplayMetrics().density);
                                checkedDrawable.setStroke(
                                    (int) (2 * context.getResources().getDisplayMetrics().density),
                                    0xFFFFFFFF  // White border
                                );
                                stateDrawable.addState(new int[]{android.R.attr.state_checked}, checkedDrawable);
                                
                                // Unchecked state (recording disabled) - Light red background
                                android.graphics.drawable.GradientDrawable uncheckedDrawable = new android.graphics.drawable.GradientDrawable();
                                uncheckedDrawable.setShape(android.graphics.drawable.GradientDrawable.RECTANGLE);
                                uncheckedDrawable.setColor(0x60FF0000);  // Light red (transparent version of ON color)
                                uncheckedDrawable.setCornerRadius(20 * context.getResources().getDisplayMetrics().density);
                                uncheckedDrawable.setStroke(
                                    (int) (2 * context.getResources().getDisplayMetrics().density),
                                    0x80FFFFFF  // Semi-transparent white border
                                );
                                stateDrawable.addState(new int[]{}, uncheckedDrawable);
                                
                                recordToggle.setBackground(stateDrawable);
                                
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
                                
                                // Create monitoring mode toggle button (below REC button, right side)
                                android.widget.ToggleButton monitorToggle = new android.widget.ToggleButton(context);
                                monitorToggle.setTag("DMR_MONITOR_TOGGLE");
                                monitorToggle.setTextOn("MON");
                                monitorToggle.setTextOff("MON");
                                monitorToggle.setChecked(false);
                                
                                FrameLayout.LayoutParams monitorToggleParams = new FrameLayout.LayoutParams(
                                    (int) (70 * context.getResources().getDisplayMetrics().density),  // 70dp width
                                    (int) (40 * context.getResources().getDisplayMetrics().density)   // 40dp height
                                );
                                monitorToggleParams.gravity = android.view.Gravity.END | android.view.Gravity.TOP;
                                monitorToggleParams.rightMargin = (int) (16 * context.getResources().getDisplayMetrics().density);
                                monitorToggleParams.topMargin = (int) (60 * context.getResources().getDisplayMetrics().density); // Below REC (10+40+10)
                                monitorToggle.setLayoutParams(monitorToggleParams);
                                monitorToggle.setTextSize(14);
                                monitorToggle.setTypeface(null, android.graphics.Typeface.BOLD);
                                monitorToggle.setTextColor(0xFFFFFFFF);  // White text
                                
                                // Create state list drawable for monitoring mode
                                android.graphics.drawable.StateListDrawable monitorStateDrawable = new android.graphics.drawable.StateListDrawable();
                                
                                // Checked state (monitoring ON - ALL mode) - Orange background
                                android.graphics.drawable.GradientDrawable monitorCheckedDrawable = new android.graphics.drawable.GradientDrawable();
                                monitorCheckedDrawable.setShape(android.graphics.drawable.GradientDrawable.RECTANGLE);
                                monitorCheckedDrawable.setColor(0xFFFF8C00);  // Dark orange
                                monitorCheckedDrawable.setCornerRadius(20 * context.getResources().getDisplayMetrics().density);
                                monitorCheckedDrawable.setStroke(
                                    (int) (2 * context.getResources().getDisplayMetrics().density),
                                    0xFFFFFFFF  // White border
                                );
                                monitorStateDrawable.addState(new int[]{android.R.attr.state_checked}, monitorCheckedDrawable);
                                
                                // Unchecked state (monitoring OFF - GROUP mode) - Light orange background
                                android.graphics.drawable.GradientDrawable monitorUncheckedDrawable = new android.graphics.drawable.GradientDrawable();
                                monitorUncheckedDrawable.setShape(android.graphics.drawable.GradientDrawable.RECTANGLE);
                                monitorUncheckedDrawable.setColor(0x60FF8C00);  // Light orange (transparent version of ON color)
                                monitorUncheckedDrawable.setCornerRadius(20 * context.getResources().getDisplayMetrics().density);
                                monitorUncheckedDrawable.setStroke(
                                    (int) (2 * context.getResources().getDisplayMetrics().density),
                                    0x80FFFFFF  // Semi-transparent white border
                                );
                                monitorStateDrawable.addState(new int[]{}, monitorUncheckedDrawable);
                                
                                monitorToggle.setBackground(monitorStateDrawable);
                                
                                // Store reference
                                monitoringModeToggle = monitorToggle;
                                
                                // Initialize toggle state from current channel
                                monitorToggle.post(new Runnable() {
                                    @Override
                                    public void run() {
                                        try {
                                            Class<?> dmrManagerClass = XposedHelpers.findClass(
                                                "com.pri.prizeinterphone.manager.DmrManager",
                                                context.getClassLoader()
                                            );
                                            
                                            Object dmrManager = XposedHelpers.callStaticMethod(dmrManagerClass, "getInstance");
                                            Object currentChannel = XposedHelpers.callMethod(dmrManager, "getCurrentChannel");
                                            
                                            if (currentChannel != null) {
                                                int channelType = XposedHelpers.getIntField(currentChannel, "type");  // 0=Digital, 1=Analog
                                                
                                                // Always start with MON OFF
                                                monitorToggle.setChecked(false);
                                                monitorToggle.setEnabled(true);
                                                isMonitoringMode = false;
                                                
                                                // DISABLED 2026-03-09: Hide MON button for DMR channels (debugging audio issues)
                                                // Only show for analog channels - DMR monitoring mode needs firmware fixes
                                                if (channelType == 0) { // Digital/DMR channel
                                                    monitorToggle.setVisibility(View.GONE);
                                                } else { // Analog channel
                                                    monitorToggle.setVisibility(View.VISIBLE);
                                                }
                                                
                                                if (channelType == 0) { // Digital/DMR channel
                                                    int contactType = XposedHelpers.getIntField(currentChannel, "contactType");
                                                    int txContact = XposedHelpers.getIntField(currentChannel, "txContact");
                                                    if (txContact != 16777215) {
                                                        originalTxContact = txContact;
                                                    }
                                                    XposedBridge.log(TAG + ": MonitoringMode initialized OFF (DMR) - contactType=" + contactType + ", stored txContact=" + originalTxContact);
                                                } else { // Analog channel
                                                    int squelchLevel = XposedHelpers.getIntField(currentChannel, "sq");
                                                    originalSquelchLevel = (squelchLevel == 0) ? 2 : squelchLevel; // Store original, default to 2
                                                    XposedBridge.log(TAG + ": MonitoringMode initialized OFF (Analog) - squelch=" + squelchLevel + ", original=" + originalSquelchLevel);
                                                }
                                            }
                                        } catch (Throwable t) {
                                            XposedBridge.log(TAG + ": MonitoringMode init error: " + t.getMessage());
                                        }
                                    }
                                });
                                
                                // Set click listener
                                monitorToggle.setOnClickListener(new View.OnClickListener() {
                                    @Override
                                    public void onClick(View v) {
                                        try {
                                            boolean newState = monitorToggle.isChecked();
                                            isMonitoringMode = newState;
                                            
                                            XposedBridge.log(TAG + ": MonitoringMode toggled: " + (newState ? "ON" : "OFF"));
                                            
                                            Class<?> dmrManagerClass = XposedHelpers.findClass(
                                                "com.pri.prizeinterphone.manager.DmrManager",
                                                context.getClassLoader()
                                            );
                                            
                                            Object dmrManager = XposedHelpers.callStaticMethod(dmrManagerClass, "getInstance");
                                            Object currentChannel = XposedHelpers.callMethod(dmrManager, "getCurrentChannel");
                                            
                                            if (currentChannel == null) {
                                                Toast.makeText(context, "No channel selected", Toast.LENGTH_SHORT).show();
                                                monitorToggle.setChecked(!newState);
                                                return;
                                            }
                                            
                                            // Get channel type directly from field (not method)
                                            int channelType = XposedHelpers.getIntField(currentChannel, "type");  // 0=Digital, 1=Analog
                                            
                                            XposedBridge.log(TAG + ": MonitoringMode channel type: " + channelType + " (0=Digital, 1=Analog)");
                                            
                                            if (channelType == 0) {
                                                // Digital/DMR channel - toggle contactType
                                                int newContactType = newState ? 2 : 1; // 2=ALL, 1=GROUP
                                                int newTxContact;
                                                
                                                if (newState) {
                                                    // MON ON - store original txContact and use 16777215 (ALL)
                                                    originalTxContact = XposedHelpers.getIntField(currentChannel, "txContact");
                                                    newTxContact = 16777215;
                                                    XposedBridge.log(TAG + ": DMR MON ON - stored txContact=" + originalTxContact + ", setting to 16777215 (ALL)");
                                                } else {
                                                    // MON OFF - restore original txContact
                                                    newTxContact = originalTxContact;
                                                    XposedBridge.log(TAG + ": DMR MON OFF - restoring txContact=" + originalTxContact);
                                                }
                                                
                                                XposedHelpers.setIntField(currentChannel, "contactType", newContactType);
                                                XposedHelpers.setIntField(currentChannel, "txContact", newTxContact);
                                                
                                                // Update database and sync hardware
                                                XposedHelpers.callMethod(dmrManager, "updateChannel", currentChannel);
                                                XposedHelpers.callMethod(dmrManager, "syncChannelInfoWithData", currentChannel);
                                                
                                                String msg = newState ? 
                                                    "Monitoring Mode ON (receiving all DMR traffic)" : 
                                                    "Monitoring Mode OFF (group mode)";
                                                Toast.makeText(context, msg, Toast.LENGTH_SHORT).show();
                                                
                                                XposedBridge.log(TAG + ": DMR MonitoringMode updated - contactType=" + newContactType + 
                                                    ", txContact=" + newTxContact);
                                                    
                                            } else {
                                                // Analog channel - toggle squelch
                                                int targetSq;
                                                if (newState) {
                                                    // MON ON - store original squelch and use 0 (fully open)
                                                    int currentSq = XposedHelpers.getIntField(currentChannel, "sq");
                                                    if (currentSq != 0) {
                                                        originalSquelchLevel = currentSq;
                                                    }
                                                    targetSq = 0;
                                                    XposedBridge.log(TAG + ": Analog MON ON - stored squelch=" + originalSquelchLevel + ", targeting sq=0");
                                                } else {
                                                    // MON OFF - restore original squelch
                                                    targetSq = originalSquelchLevel;
                                                    XposedBridge.log(TAG + ": Analog MON OFF - restoring squelch=" + originalSquelchLevel);
                                                }
                                                
                                                // Manually construct and send AnalogMessage to avoid database interference
                                                try {
                                                    Class<?> analogMessageClass = XposedHelpers.findClass(
                                                        "com.pri.prizeinterphone.message.AnalogMessage",
                                                        lpparam.classLoader
                                                    );
                                                    Object analogMessage = analogMessageClass.newInstance();
                                                    
                                                    // Copy all fields from ChannelData
                                                    XposedHelpers.callMethod(analogMessage, "setBand", (byte) XposedHelpers.getIntField(currentChannel, "band"));
                                                    XposedHelpers.callMethod(analogMessage, "setPower", (byte) XposedHelpers.getIntField(currentChannel, "power"));
                                                    XposedHelpers.callMethod(analogMessage, "setTxFreq", XposedHelpers.getIntField(currentChannel, "txFreq"));
                                                    XposedHelpers.callMethod(analogMessage, "setRxFreq", XposedHelpers.getIntField(currentChannel, "rxFreq"));
                                                    XposedHelpers.callMethod(analogMessage, "setSq", (byte) targetSq);  // Use our target squelch!
                                                    XposedHelpers.callMethod(analogMessage, "setRxType", (byte) XposedHelpers.getIntField(currentChannel, "rxType"));
                                                    XposedHelpers.callMethod(analogMessage, "setRxSubCode", (byte) XposedHelpers.getIntField(currentChannel, "rxSubCode"));
                                                    XposedHelpers.callMethod(analogMessage, "setTxType", (byte) XposedHelpers.getIntField(currentChannel, "txType"));
                                                    XposedHelpers.callMethod(analogMessage, "setTxSubCode", (byte) XposedHelpers.getIntField(currentChannel, "txSubCode"));
                                                    XposedHelpers.callMethod(analogMessage, "setRelay", (byte) XposedHelpers.getIntField(currentChannel, "relay"));
                                                    
                                                    // Send it!
                                                    XposedHelpers.callMethod(analogMessage, "send");
                                                    XposedBridge.log(TAG + ": ✅ Directly sent AnalogMessage with sq=" + targetSq);
                                                    
                                                } catch (Throwable sendError) {
                                                    XposedBridge.log(TAG + ": Error sending manual AnalogMessage: " + sendError.getMessage());
                                                    XposedBridge.log(sendError);
                                                }
                                                
                                                String msg = newState ? 
                                                    "Monitoring Mode ON (squelch fully open)" : 
                                                    "Monitoring Mode OFF (squelch: " + originalSquelchLevel + ")";
                                                Toast.makeText(context, msg, Toast.LENGTH_SHORT).show();
                                                
                                                XposedBridge.log(TAG + ": Analog MonitoringMode updated - squelch=" + 
                                                    (newState ? "0 (open)" : originalSquelchLevel));
                                            }
                                            
                                        } catch (Throwable t) {
                                            XposedBridge.log(TAG + ": MonitoringMode toggle error: " + t.getMessage());
                                            XposedBridge.log(t);
                                            Toast.makeText(context, "Error toggling monitoring mode", Toast.LENGTH_SHORT).show();
                                            monitorToggle.setChecked(!monitorToggle.isChecked());
                                        }
                                    }
                                });
                                
                                buttonContainer.addView(monitorToggle);
                                XposedBridge.log(TAG + ": ✓ Added monitoring mode toggle below REC button");
                                
                                // Create APRS monitoring mode toggle button (below MON button, right side)
                                android.widget.ToggleButton aprsButton = new android.widget.ToggleButton(context);
                                aprsButton.setTag("DMR_APRS_MONITOR_BUTTON");
                                aprsButton.setTextOn("APRS");
                                aprsButton.setTextOff("APRS");
                                aprsButton.setChecked(false);
                                
                                FrameLayout.LayoutParams aprsButtonParams = new FrameLayout.LayoutParams(
                                    (int) (70 * context.getResources().getDisplayMetrics().density),  // 70dp width
                                    (int) (40 * context.getResources().getDisplayMetrics().density)   // 40dp height
                                );
                                aprsButtonParams.gravity = android.view.Gravity.END | android.view.Gravity.TOP;
                                aprsButtonParams.rightMargin = (int) (16 * context.getResources().getDisplayMetrics().density);
                                aprsButtonParams.topMargin = (int) (110 * context.getResources().getDisplayMetrics().density); // Below MON (60+40+10)
                                aprsButton.setLayoutParams(aprsButtonParams);
                                aprsButton.setTextSize(12);
                                aprsButton.setTypeface(null, android.graphics.Typeface.BOLD);
                                aprsButton.setTextColor(0xFFFFFFFF);  // White text
                                
                                // Create state list drawable for APRS button
                                android.graphics.drawable.StateListDrawable aprsStateDrawable = new android.graphics.drawable.StateListDrawable();
                                
                                // Checked state (APRS monitoring active) - Green background
                                android.graphics.drawable.GradientDrawable aprsCheckedDrawable = new android.graphics.drawable.GradientDrawable();
                                aprsCheckedDrawable.setShape(android.graphics.drawable.GradientDrawable.RECTANGLE);
                                aprsCheckedDrawable.setColor(0xFF00AA00);  // Green
                                aprsCheckedDrawable.setCornerRadius(20 * context.getResources().getDisplayMetrics().density);
                                aprsCheckedDrawable.setStroke(
                                    (int) (2 * context.getResources().getDisplayMetrics().density),
                                    0xFFFFFFFF  // White border
                                );
                                aprsStateDrawable.addState(new int[]{android.R.attr.state_checked}, aprsCheckedDrawable);
                                
                                // Unchecked state (APRS monitoring inactive) - Light green background
                                android.graphics.drawable.GradientDrawable aprsUncheckedDrawable = new android.graphics.drawable.GradientDrawable();
                                aprsUncheckedDrawable.setShape(android.graphics.drawable.GradientDrawable.RECTANGLE);
                                aprsUncheckedDrawable.setColor(0x6000AA00);  // Light green (transparent version of ON color)
                                aprsUncheckedDrawable.setCornerRadius(20 * context.getResources().getDisplayMetrics().density);
                                aprsUncheckedDrawable.setStroke(
                                    (int) (2 * context.getResources().getDisplayMetrics().density),
                                    0x80FFFFFF  // Semi-transparent white border
                                );
                                aprsStateDrawable.addState(new int[]{}, aprsUncheckedDrawable);
                                
                                aprsButton.setBackground(aprsStateDrawable);
                                
                                // Store reference
                                aprsMonitoringToggleButton = aprsButton;
                                
                                // Set click listener
                                aprsButton.setOnClickListener(new View.OnClickListener() {
                                    @Override
                                    public void onClick(View v) {
                                        showAPRSMonitoringDialog((Activity) context);
                                    }
                                });
                                
                                buttonContainer.addView(aprsButton);
                                XposedBridge.log(TAG + ": ✓ Added APRS monitoring toggle button below MON button");
                                
                                // Zone button is now created in RSSI/Zone container above borderbox
                                
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
                                    
                                    // Show/hide squelch slider based on channel type (analog only) AND software squelch enabled
                                    View squelchContainer = rootLayout.findViewWithTag("DMR_SQUELCH_CONTAINER");
                                    if (squelchContainer != null) {
                                        boolean shouldShow = (channelType == 1 && isSoftwareSquelchEnabled);
                                        squelchContainer.setVisibility(shouldShow ? View.VISIBLE : View.GONE);
                                        XposedBridge.log(TAG + ": [INIT] Squelch slider " + (shouldShow ? "shown" : "hidden") + " (analog=" + (channelType == 1) + ", softSqEnabled=" + isSoftwareSquelchEnabled + ")");
                                    } else {
                                        XposedBridge.log(TAG + ": [INIT] Could not find squelch container to set initial visibility");
                                    }
                                    
                                    // Show/hide software squelch toggle based on channel type (analog only)
                                    View softSqToggle = rootLayout.findViewWithTag("DMR_SOFT_SQUELCH_TOGGLE");
                                    if (softSqToggle != null) {
                                        softSqToggle.setVisibility(channelType == 1 ? View.VISIBLE : View.GONE);
                                        XposedBridge.log(TAG + ": [INIT] Software squelch toggle " + (channelType == 1 ? "shown" : "hidden") + " for " + (channelType == 0 ? "digital" : "analog") + " channel");
                                    }
                                    
                                    // Restore transcription history for initial channel
                                    restoreChannelTranscriptionHistory(channelNumber);
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
                                    
                                    // Show/hide squelch slider based on channel type (analog only) AND software squelch enabled
                                    try {
                                        Object mLocalViewObj = XposedHelpers.getObjectField(param.thisObject, "mLocalView");
                                        if (mLocalViewObj instanceof ViewGroup) {
                                            ViewGroup rootLayout = (ViewGroup) mLocalViewObj;
                                            View squelchContainer = rootLayout.findViewWithTag("DMR_SQUELCH_CONTAINER");
                                            if (squelchContainer != null) {
                                                boolean shouldShow = (channelType == 1 && isSoftwareSquelchEnabled);
                                                squelchContainer.setVisibility(shouldShow ? View.VISIBLE : View.GONE);
                                                XposedBridge.log(TAG + ": Squelch slider " + (shouldShow ? "shown" : "hidden") + " (analog=" + (channelType == 1) + ", softSqEnabled=" + isSoftwareSquelchEnabled + ")");
                                            } else {
                                                XposedBridge.log(TAG + ": Could not find squelch container to update visibility");
                                            }
                                            
                                            // Show/hide software squelch toggle based on channel type (analog only)
                                            View softSqToggle = rootLayout.findViewWithTag("DMR_SOFT_SQUELCH_TOGGLE");
                                            if (softSqToggle != null) {
                                                softSqToggle.setVisibility(channelType == 1 ? View.VISIBLE : View.GONE);
                                                XposedBridge.log(TAG + ": Software squelch toggle " + (channelType == 1 ? "shown" : "hidden") + " for " + (channelType == 0 ? "digital" : "analog") + " channel");
                                            }
                                        }
                                    } catch (Exception e) {
                                        XposedBridge.log(TAG + ": Error updating squelch visibility: " + e.getMessage());
                                    }
                                    currentChannelName = (channelName != null && !channelName.isEmpty()) ? channelName : ("Channel_" + channelNumber);
                                    
                                    // TODO: Channel tracking disabled - causes ListView adapter conflicts
                                    /*
                                    // Track last used channel for current zone
                                    if (currentZoneId != -1) {
                                        lastUsedChannelPerZone.put(currentZoneId, channelNumber);
                                        XposedBridge.log(TAG + ": Stored channel " + channelNumber + 
                                            " as last used for zone " + currentZoneName);
                                    }
                                    */
                                    
                                    // Store mLocalView for APRS receive context
                                    try {
                                        Object mLocalViewObj = XposedHelpers.getObjectField(param.thisObject, "mLocalView");
                                        if (mLocalViewObj instanceof View) {
                                            mLocalViewObject = mLocalViewObj;
                                        }
                                    } catch (Exception e) {
                                        XposedBridge.log(TAG + ": Error getting mLocalView: " + e.getMessage());
                                    }
                                    
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
                                    
                                    // Reset MON button to OFF when switching channels
                                    if (monitoringModeToggle != null) {
                                        monitoringModeToggle.post(() -> {
                                            try {
                                                // Always turn MON OFF on channel change
                                                monitoringModeToggle.setChecked(false);
                                                monitoringModeToggle.setEnabled(true);
                                                monitoringModeToggle.setAlpha(1.0f);
                                                isMonitoringMode = false;
                                                
                                                // DISABLED 2026-03-09: Hide MON button for DMR channels (debugging audio issues)
                                                // Only show for analog channels - DMR monitoring mode needs firmware fixes
                                                if (channelType == 0) {
                                                    monitoringModeToggle.setVisibility(View.GONE);
                                                } else {
                                                    monitoringModeToggle.setVisibility(View.VISIBLE);
                                                }
                                                
                                                if (channelType == 0) {
                                                    // Digital channel - MON button controls contactType (1=GROUP, 2=ALL)
                                                    // Store original txContact for restoration
                                                    int txContact = XposedHelpers.getIntField(channelData, "txContact");
                                                    if (txContact != 16777215) {
                                                        originalTxContact = txContact;
                                                    }
                                                    XposedBridge.log(TAG + ": MON button reset to OFF for digital channel - stored txContact=" + originalTxContact);
                                                } else {
                                                    // Analog channel - MON button controls squelch
                                                    int squelchLevel = XposedHelpers.getIntField(channelData, "sq");
                                                    originalSquelchLevel = (squelchLevel == 0) ? 2 : squelchLevel;
                                                    XposedBridge.log(TAG + ": MON button reset to OFF for analog channel - squelch=" + originalSquelchLevel);
                                                }
                                            } catch (Throwable t) {
                                                XposedBridge.log(TAG + ": Error updating MON button on channel change: " + t.getMessage());
                                            }
                                        });
                                    }
                                    
                                    updateHistoryHeader();
                                    
                                    Object mLocalViewObj = XposedHelpers.getObjectField(param.thisObject, "mLocalView");
                                    if (mLocalViewObj instanceof ViewGroup) {
                                        ViewGroup rootLayout = (ViewGroup) mLocalViewObj;
                                        loadChannelHistory(channelNumber, rootLayout.getContext());
                                        // Restore transcription history for new channel
                                        restoreChannelTranscriptionHistory(channelNumber);
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
                    // Get current GPS location for distance calculation
                    android.location.Location currentLoc = getCurrentLocation(context);
                    
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
                                
                                // Build display text with city/state
                                if (city != null && state != null) {
                                    displayText = city + ", " + state;
                                } else if (city != null) {
                                    displayText = city;
                                } else {
                                    displayText = String.format(java.util.Locale.US, 
                                        "%.4f, %.4f", location.latitude, location.longitude);
                                }
                                
                                // Add distance if current location is available  
                                if (currentLoc != null) {
                                    double distanceMeters = calculateDistance(
                                       currentLoc.getLatitude(), currentLoc.getLongitude(),
                                        location.latitude, location.longitude);
                                    
                                    double bearing = calculateBearing(
                                        currentLoc.getLatitude(), currentLoc.getLongitude(),
                                        location.latitude, location.longitude);
                                    
                                    String arrow = getDirectionArrow(bearing);
                                    
                                    String distanceStr;
                                    if (distanceMeters < 1000) {
                                        // Less than 1km - show meters with arrow
                                        distanceStr = String.format(java.util.Locale.US, "%s %.0fm", arrow, distanceMeters);
                                    } else if (distanceMeters < 10000) {
                                        // 1-10km - show one decimal with arrow
                                        distanceStr = String.format(java.util.Locale.US, "%s %.1fkm", arrow, distanceMeters / 1000);
                                    } else {
                                        // Over 10km - show miles and km with arrow
                                        double distanceMiles = distanceMeters * 0.000621371;
                                        double distanceKm = distanceMeters / 1000;
                                        distanceStr = String.format(java.util.Locale.US, "%s %.1fmi (%.1fkm)", arrow, distanceMiles, distanceKm);
                                    }
                                    
                                    displayText += " (" + distanceStr + ")";
                                    XposedBridge.log(TAG + ": Distance to channel " + channelNumber + ": " + distanceStr);
                                }
                                
                                displayText += "\n📍";
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
                                    "%.4f, %.4f", location.latitude, location.longitude);
                                
                                // Add distance if available
                                if (currentLoc != null) {
                                    double distanceMeters = calculateDistance(
                                        currentLoc.getLatitude(), currentLoc.getLongitude(),
                                        location.latitude, location.longitude);
                                    String distanceStr = formatDistance(distanceMeters, 
                                        currentLoc.getLatitude(), currentLoc.getLongitude(),
                                        location.latitude, location.longitude);
                                    displayText += " (" + distanceStr + ")";
                                }
                                
                                displayText += "\n📍";
                                locationText.setText(displayText);
                                
                                // Fetch elevation in background
                                fetchAndDisplayElevation(location, locationText, displayText.replace("\n📍", ""));
                                XposedBridge.log(TAG + ": No geocoding results, showing coordinates for channel " + channelNumber);
                            }
                        } else {
                            // Geocoder not available, show coordinates
                            displayText = String.format(java.util.Locale.US, 
                                "%.4f, %.4f", location.latitude, location.longitude);
                            
                            // Add distance if available
                            if (currentLoc != null) {
                                double distanceMeters = calculateDistance(
                                    currentLoc.getLatitude(), currentLoc.getLongitude(),
                                    location.latitude, location.longitude);
                                String distanceStr = formatDistance(distanceMeters,
                                    currentLoc.getLatitude(), currentLoc.getLongitude(),
                                    location.latitude, location.longitude);
                                displayText += " (" + distanceStr + ")";
                            }
                            
                            displayText += "\n📍";
                            locationText.setText(displayText);
                            
                            // Fetch elevation in background
                            fetchAndDisplayElevation(location, locationText, displayText.replace("\n📍", ""));
                            XposedBridge.log(TAG + ": Geocoder not available, showing coordinates for channel " + channelNumber);
                        }
                    } catch (Exception e) {
                        // Geocoder failed, fallback to coordinates
                        displayText = String.format(java.util.Locale.US, 
                            "%.4f, %.4f", location.latitude, location.longitude);
                        
                        // Add distance if available
                        if (currentLoc != null) {
                            double distanceMeters = calculateDistance(
                                currentLoc.getLatitude(), currentLoc.getLongitude(),
                                location.latitude, location.longitude);
                            String distanceStr = formatDistance(distanceMeters,
                                currentLoc.getLatitude(), currentLoc.getLongitude(),
                                location.latitude, location.longitude);
                            displayText += " (" + distanceStr + ")";
                        }
                        
                        displayText += "\n📍";
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
     * Format distance for display
     */
    private String formatDistance(double distanceMeters) {
        if (distanceMeters < 1000) {
            // Less than 1km - show meters
            return String.format(java.util.Locale.US, "%.0fm", distanceMeters);
        } else if (distanceMeters < 10000) {
            // 1-10km - show one decimal
            return String.format(java.util.Locale.US, "%.1fkm", distanceMeters / 1000);
        } else {
            // Over 10km - show miles
            double distanceMiles = distanceMeters * 0.000621371;
            return String.format(java.util.Locale.US, "%.1fmi", distanceMiles);
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
     * Calculate distance between two coordinates using Haversine formula
     * @param lat1 First point latitude
     * @param lon1 First point longitude
     * @param lat2 Second point latitude
     * @param lon2 Second point longitude
     * @return Distance in meters
     */
    private double calculateDistance(double lat1, double lon1, double lat2, double lon2) {
        final double R = 6371000; // Earth's radius in meters
        
        double lat1Rad = Math.toRadians(lat1);
        double lat2Rad = Math.toRadians(lat2);
        double deltaLat = Math.toRadians(lat2 - lat1);
        double deltaLon = Math.toRadians(lon2 - lon1);
        
        double a = Math.sin(deltaLat / 2) * Math.sin(deltaLat / 2) +
                   Math.cos(lat1Rad) * Math.cos(lat2Rad) *
                   Math.sin(deltaLon / 2) * Math.sin(deltaLon / 2);
        
        double c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));
        
        return R * c;
    }
    
    /**
     * Calculate bearing from point 1 to point 2
     * @param lat1 First point latitude
     * @param lon1 First point longitude
     * @param lat2 Second point latitude
     * @param lon2 Second point longitude
     * @return Bearing in degrees (0-360)
     */
    private double calculateBearing(double lat1, double lon1, double lat2, double lon2) {
        double lat1Rad = Math.toRadians(lat1);
        double lat2Rad = Math.toRadians(lat2);
        double deltaLon = Math.toRadians(lon2 - lon1);
        
        double y = Math.sin(deltaLon) * Math.cos(lat2Rad);
        double x = Math.cos(lat1Rad) * Math.sin(lat2Rad) -
                   Math.sin(lat1Rad) * Math.cos(lat2Rad) * Math.cos(deltaLon);
        
        double bearing = Math.toDegrees(Math.atan2(y, x));
        return (bearing + 360) % 360; // Normalize to 0-360
    }
    
    /**
     * Convert bearing to directional arrow with letter
     * @param bearing Bearing in degrees (0-360)
     * @return Arrow with direction letter (↑N, ↗NE, →E, etc.)
     */
    private String getDirectionArrow(double bearing) {
        // 8-direction compass arrows with letters
        if (bearing >= 337.5 || bearing < 22.5) return "↑N";      // N
        if (bearing >= 22.5 && bearing < 67.5) return "↗NE";      // NE
        if (bearing >= 67.5 && bearing < 112.5) return "→E";      // E
        if (bearing >= 112.5 && bearing < 157.5) return "↘SE";    // SE
        if (bearing >= 157.5 && bearing < 202.5) return "↓S";     // S
        if (bearing >= 202.5 && bearing < 247.5) return "↙SW";    // SW
        if (bearing >= 247.5 && bearing < 292.5) return "←W";     // W
        if (bearing >= 292.5 && bearing < 337.5) return "↖NW";    // NW
        return "↑N"; // Default
    }
    
    /**
     * Format distance with directional arrow
     * @param distanceMeters Distance in meters
     * @param fromLat From latitude
     * @param fromLon From longitude
     * @param toLat To latitude
     * @param toLon To longitude
     * @return Formatted distance string with arrow
     */
    private String formatDistance(double distanceMeters, double fromLat, double fromLon, double toLat, double toLon) {
        double bearing = calculateBearing(fromLat, fromLon, toLat, toLon);
        String arrow = getDirectionArrow(bearing);
        
        if (distanceMeters < 1000) {
            // Less than 1km - show meters with arrow
            return String.format(java.util.Locale.US, "%s %.0fm", arrow, distanceMeters);
        } else if (distanceMeters < 10000) {
            // 1-10km - show one decimal with arrow
            return String.format(java.util.Locale.US, "%s %.1fkm", arrow, distanceMeters / 1000);
        } else {
            // Over 10km - show miles and km with arrow
            double distanceMiles = distanceMeters * 0.000621371;
            double distanceKm = distanceMeters / 1000;
            return String.format(java.util.Locale.US, "%s %.1fmi (%.1fkm)", arrow, distanceMiles, distanceKm);
        }
    }
    
    /**
     * Get current GPS location
     * @param context Application context
     * @return Current location or null if unavailable
     */
    private android.location.Location getCurrentLocation(Context context) {
        try {
            if (locationManager == null) {
                locationManager = (android.location.LocationManager) 
                    context.getSystemService(Context.LOCATION_SERVICE);
                XposedBridge.log(TAG + ": LocationManager initialized");
            }
            
            if (locationManager == null) {
                XposedBridge.log(TAG + ": LocationManager not available");
                return null;
            }
            
            // Try GPS first, then network
            android.location.Location location = null;
            
            try {
                if (locationManager.isProviderEnabled(android.location.LocationManager.GPS_PROVIDER)) {
                    location = locationManager.getLastKnownLocation(android.location.LocationManager.GPS_PROVIDER);
                    if (location != null) {
                        XposedBridge.log(TAG + ": Got GPS location: " + location.getLatitude() + ", " + location.getLongitude());
                    } else {
                        XposedBridge.log(TAG + ": GPS provider enabled but no cached location");
                    }
                } else {
                    XposedBridge.log(TAG + ": GPS provider not enabled");
                }
            } catch (SecurityException e) {
                XposedBridge.log(TAG + ": No permission for GPS location: " + e.getMessage());
            } catch (Exception e) {
                XposedBridge.log(TAG + ": Error getting GPS location: " + e.getMessage());
            }
            
            if (location == null) {
                try {
                    if (locationManager.isProviderEnabled(android.location.LocationManager.NETWORK_PROVIDER)) {
                        location = locationManager.getLastKnownLocation(android.location.LocationManager.NETWORK_PROVIDER);
                        if (location != null) {
                            XposedBridge.log(TAG + ": Got network location: " + location.getLatitude() + ", " + location.getLongitude());
                        } else {
                            XposedBridge.log(TAG + ": Network provider enabled but no cached location");
                        }
                    } else {
                        XposedBridge.log(TAG + ": Network provider not enabled");
                    }
                } catch (SecurityException e) {
                    XposedBridge.log(TAG + ": No permission for network location: " + e.getMessage());
                } catch (Exception e) {
                    XposedBridge.log(TAG + ": Error getting network location: " + e.getMessage());
                }
            }
            
            if (location != null) {
                currentGpsLocation = location;
                XposedBridge.log(TAG + ": Cached current location: " + location.getLatitude() + ", " + location.getLongitude());
            } else {
                XposedBridge.log(TAG + ": No location available from any provider");
            }
            
            return location;
        } catch (Exception e) {
            XposedBridge.log(TAG + ": Error getting current location: " + e.getMessage());
            XposedBridge.log(e);
            return null;
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
            
            XposedHelpers.findAndHookMethod(
                infoActivityClass,
                "initView",
                new XC_MethodHook() {
                    @Override
                    protected void afterHookedMethod(MethodHookParam param) throws Throwable {
                        try {
                            Context context = (Context) param.thisObject;
                            Activity activity = (Activity) param.thisObject;
                            
                            // Update software version TextView to include module version
                            Object tvSoftwareVersion = XposedHelpers.getObjectField(
                                param.thisObject,
                                "mTvSoftwareVersion"
                            );
                            
                            if (tvSoftwareVersion != null) {
                                String originalText = (String) XposedHelpers.callMethod(tvSoftwareVersion, "getText");
                                String newText = originalText + "\nDMRModHooks v" + VERSION;
                                XposedHelpers.callMethod(tvSoftwareVersion, "setText", newText);
                            }
                            
                            // Create MacGyver Mod Version section dynamically since it doesn't exist in layout
                            Object tvDmrFirmware = XposedHelpers.getObjectField(param.thisObject, "mTvDmrFirmwareVersion");
                            if (tvDmrFirmware != null && tvDmrFirmware instanceof TextView) {
                                TextView dmrFirmwareView = (TextView) tvDmrFirmware;
                                
                                // Get the main container
                                View dmrRow = (View) dmrFirmwareView.getParent().getParent();
                                android.view.ViewGroup mainContainer = (android.view.ViewGroup) dmrRow.getParent();
                                
                                // Create a new row for MacGyver Mod Version
                                android.widget.RelativeLayout macGyverRow = new android.widget.RelativeLayout(context);
                                android.widget.RelativeLayout.LayoutParams rowParams = new android.widget.RelativeLayout.LayoutParams(
                                    android.widget.RelativeLayout.LayoutParams.MATCH_PARENT,
                                    (int) (50 * context.getResources().getDisplayMetrics().density) // 50dp height
                                );
                                macGyverRow.setLayoutParams(rowParams);
                                macGyverRow.setPadding(
                                    (int) (16 * context.getResources().getDisplayMetrics().density),
                                    0,
                                    (int) (16 * context.getResources().getDisplayMetrics().density),
                                    0
                                );
                                
                                // Create vertical LinearLayout for label + value
                                android.widget.LinearLayout verticalLayout = new android.widget.LinearLayout(context);
                                verticalLayout.setOrientation(android.widget.LinearLayout.VERTICAL);
                                android.widget.RelativeLayout.LayoutParams verticalParams = new android.widget.RelativeLayout.LayoutParams(
                                    android.widget.RelativeLayout.LayoutParams.WRAP_CONTENT,
                                    android.widget.RelativeLayout.LayoutParams.WRAP_CONTENT
                                );
                                verticalParams.addRule(android.widget.RelativeLayout.CENTER_VERTICAL);
                                verticalLayout.setLayoutParams(verticalParams);
                                
                                // Create label TextView
                                TextView labelView = new TextView(context);
                                labelView.setText("MacGyver Mod Version");
                                labelView.setTextSize(14);
                                labelView.setTextColor(0xFF666666);
                                
                                // Create value TextView (clickable link)
                                TextView valueView = new TextView(context);
                                valueView.setText("IIMacGyverII mod v" + VERSION);
                                valueView.setTextSize(12);
                                valueView.setTextColor(0xFF1E90FF);  // Blue
                                valueView.setPaintFlags(valueView.getPaintFlags() | android.graphics.Paint.UNDERLINE_TEXT_FLAG);
                                valueView.setOnClickListener(new View.OnClickListener() {
                                    @Override
                                    public void onClick(View v) {
                                        try {
                                            Intent browserIntent = new Intent(
                                                Intent.ACTION_VIEW,
                                                android.net.Uri.parse("https://github.com/IIMacGyverII/phonedmrapp")
                                            );
                                            context.startActivity(browserIntent);
                                            Toast.makeText(context, "Opening GitHub...", Toast.LENGTH_SHORT).show();
                                        } catch (Throwable t) {
                                            Toast.makeText(context, "Error opening browser", Toast.LENGTH_SHORT).show();
                                        }
                                    }
                                });
                                
                                // Add label and value to vertical layout
                                verticalLayout.addView(labelView);
                                verticalLayout.addView(valueView);
                                
                                // Add vertical layout to row
                                macGyverRow.addView(verticalLayout);
                                
                                // Insert the new row after DMR Firmware row
                                int dmrRowIndex = mainContainer.indexOfChild(dmrRow);
                                mainContainer.addView(macGyverRow, dmrRowIndex + 1);
                                
                                // Inject reload button for firmware patch
                                try {
                                    // Create container for patch controls
                                    android.widget.LinearLayout patchContainer = new android.widget.LinearLayout(context);
                                    patchContainer.setOrientation(android.widget.LinearLayout.VERTICAL);
                                    android.widget.RelativeLayout.LayoutParams patchParams = new android.widget.RelativeLayout.LayoutParams(
                                        android.widget.RelativeLayout.LayoutParams.MATCH_PARENT,
                                        android.widget.RelativeLayout.LayoutParams.WRAP_CONTENT
                                    );
                                    patchParams.setMargins(0, (int)(20 * context.getResources().getDisplayMetrics().density), 0, 0);
                                    patchContainer.setLayoutParams(patchParams);
                                    patchContainer.setPadding(
                                        (int)(16 * context.getResources().getDisplayMetrics().density),
                                        (int)(16 * context.getResources().getDisplayMetrics().density),
                                        (int)(16 * context.getResources().getDisplayMetrics().density),
                                        (int)(16 * context.getResources().getDisplayMetrics().density)
                                    );
                                    patchContainer.setBackgroundColor(0xFFF5F5F5); // Light gray background
                                    
                                    // Inject patch reload controls
                                    // DISABLED 2026-03-09: Button commented out for future work
                                    // Test 10 proved repeated QueryInit (cmd=39 x3) prevents radio hang
                                    // PatchReloadHelper.injectReloadButton(patchContainer, context);
                                    
                                    // Add patch container to main layout
                                    mainContainer.addView(patchContainer, dmrRowIndex + 2);
                                    
                                    XposedBridge.log(TAG + ": Patch reload button added to Information screen");
                                } catch (Throwable t) {
                                    XposedBridge.log(TAG + ": Failed to add reload button: " + t.getMessage());
                                }
                            }
                            
                        } catch (Throwable t) {
                            XposedBridge.log(TAG + ": ERROR in Information activity hook: " + t.getMessage());
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
     * Hook UpdateFirmwareActivity to auto-cleanup after patch reload
     * 
     * DISABLED 2026-03-09: Feature commented out for future work
     * 
     * ACHIEVEMENT: Test 10 (March 6, 2026) successfully prevented radio hang!
     * - Solution: Send QueryInit command (cmd=39) 3 times with 200ms delays after YModem
     * - Result: Radio responds normally, no "no reply" errors
     * - Firmware patch (PATCH14) loads correctly (txContact=11904)
     * 
     * REMAINING ISSUES:
     * - Group calling still not working (may be unrelated to firmware reload)
     * - UART buffer flush failed (SerialManager class not found)
     * - sendSetChannelCmdToMdl crashes with NullPointerException
     * 
     * FUTURE WORK:
     * - Fix class name for UART flush
     * - Handle channel DB not ready on initial load
     * - Add automatic DMRDEBUG.bin deletion
     * - Test group calling with properly loaded PATCH14
     * 
     * See DMR_FIRMWARE_RELOAD_NOTES.md for complete history and implementation details.
     * 
     * YModemTXMsg steps:
     * - Step 2: Update starting
     * - Step 4: Initializing
     * - Step 8: Progress update (0-100%)
     * - Step 32: SUCCESS - firmware updated
     * - Step 64: FAILURE - update failed
     */
    /* DISABLED - Uncomment to re-enable firmware reload feature
    private void hookUpdateFirmwareActivity(XC_LoadPackage.LoadPackageParam lpparam) {
        try {
            Class<?> updateFirmwareActivityClass = XposedHelpers.findClass(
                "com.pri.prizeinterphone.activity.UpdateFirmwareActivity",
                lpparam.classLoader
            );
            
            Class<?> yModemTXMsgClass = XposedHelpers.findClass(
                "com.pri.prizeinterphone.ymodem.YModemTXMsg",
                lpparam.classLoader
            );
            
            XposedHelpers.findAndHookMethod(
                updateFirmwareActivityClass,
                "handleMsgFromSvc",
                yModemTXMsgClass,
                new XC_MethodHook() {
                    @Override
                    protected void afterHookedMethod(MethodHookParam param) throws Throwable {
                        try {
                            Object yModemTXMsg = param.args[0];
                            if (yModemTXMsg == null) return;
                            
                            int step = (int) XposedHelpers.callMethod(yModemTXMsg, "getStep");
                            
                            // Step 32 = SUCCESS, Step 64 = FAILURE
                            if (step == 32 || step == 64) {
                                String status = (step == 32) ? "SUCCESS" : "FAILURE";
                                XposedBridge.log(TAG + ": Firmware update completed with status: " + status);
                                
                                if (step == 32) {
                                    // Firmware uploaded successfully - TEST 10: Enhanced recovery with UART flush
                                    final Activity activity = (Activity) param.thisObject;
                                    final Context context = activity.getApplicationContext();
                                    
                                    activity.runOnUiThread(new Runnable() {
                                        @Override
                                        public void run() {
                                            new android.os.Handler().postDelayed(new Runnable() {
                                                @Override
                                                public void run() {
                                                    try {
                                                        XposedBridge.log(TAG + ": === TEST 10: Enhanced DMR Recovery Starting ===");
                                                        XposedBridge.log(TAG + ": Step 1: Attempting UART buffer flush...");
                                                        
                                                        // Step 1: Aggressively flush UART buffers
                                                        try {
                                                            Class<?> serialManagerClass = XposedHelpers.findClass(
                                                                "com.pri.prizeinterphone.manager.SerialManager",
                                                                context.getClassLoader()
                                                            );
                                                            Object serialManager = XposedHelpers.callStaticMethod(
                                                                serialManagerClass, "getInstance"
                                                            );
                                                            
                                                            // Try to get InputStream - may be mInputStream or similar field
                                                            Object inputStream = null;
                                                            try {
                                                                inputStream = XposedHelpers.getObjectField(serialManager, "mInputStream");
                                                            } catch (Throwable t1) {
                                                                try {
                                                                    inputStream = XposedHelpers.getObjectField(serialManager, "inputStream");
                                                                } catch (Throwable t2) {
                                                                    XposedBridge.log(TAG + ": Could not access InputStream field: " + t2.getMessage());
                                                                }
                                                            }
                                                            
                                                            if (inputStream != null) {
                                                                int available = (int) XposedHelpers.callMethod(inputStream, "available");
                                                                XposedBridge.log(TAG + ": Found " + available + " bytes in UART buffer");
                                                                
                                                                int flushedBytes = 0;
                                                                while ((int) XposedHelpers.callMethod(inputStream, "available") > 0) {
                                                                    XposedHelpers.callMethod(inputStream, "read");
                                                                    flushedBytes++;
                                                                    if (flushedBytes > 1000) break; // Safety limit
                                                                }
                                                                
                                                                XposedBridge.log(TAG + ": ✓ Flushed " + flushedBytes + " bytes from UART buffer");
                                                                Thread.sleep(100); // Small delay after flush
                                                            } else {
                                                                XposedBridge.log(TAG + ": ⚠ InputStream not accessible, skipping buffer flush");
                                                            }
                                                        } catch (Throwable t) {
                                                            XposedBridge.log(TAG + ": ⚠ UART flush error (non-fatal): " + t.getMessage());
                                                        }
                                                        
                                                        XposedBridge.log(TAG + ": Step 2: Sending repeated initialization queries...");
                                                        
                                                        // Step 2: Get DmrManager instance
                                                        Class<?> dmrManagerClass = XposedHelpers.findClass(
                                                            "com.pri.prizeinterphone.manager.DmrManager",
                                                            context.getClassLoader()
                                                        );
                                                        Object dmrManager = XposedHelpers.callStaticMethod(dmrManagerClass, "getInstance");
                                                        
                                                        // Step 3: Send multiple QueryInit commands to wake up module
                                                        for (int i = 1; i <= 3; i++) {
                                                            XposedHelpers.callMethod(dmrManager, "sendQueryInitializedCmdToMdl");
                                                            XposedBridge.log(TAG + ": ✓ Sent QueryInit attempt " + i + "/3");
                                                            Thread.sleep(200); // 200ms between attempts
                                                        }
                                                        
                                                        XposedBridge.log(TAG + ": Step 3: Waiting 500ms for module response...");
                                                        Thread.sleep(500);
                                                        
                                                        XposedBridge.log(TAG + ": Step 4: Resending channel configuration...");
                                                        
                                                        // Step 4: Resend current channel configuration
                                                        XposedHelpers.callMethod(dmrManager, "sendSetChannelCmdToMdl");
                                                        XposedBridge.log(TAG + ": ✓ Channel configuration resent");
                                                        
                                                        XposedBridge.log(TAG + ": === TEST 10: Recovery sequence complete ===");
                                                        XposedBridge.log(TAG + ": ✅ DMR module recovery attempted - firmware patch active");
                                                        XposedBridge.log(TAG + ": 🔍 Monitor for 'no reply' errors to verify success");
                                                        
                                                        // Close UpdateFirmwareActivity
                                                        activity.finish();
                                                        XposedBridge.log(TAG + ": UpdateFirmwareActivity closed");
                                                        
                                                    } catch (Throwable t) {
                                                        XposedBridge.log(TAG + ": ❌ TEST 10 recovery failed: " + t.getMessage());
                                                        t.printStackTrace();
                                                    }
                                                }
                                            }, 2000); // Wait 2 seconds after firmware upload completes
                                        }
                                    });
                                }
                            }
                            
                        } catch (Throwable t) {
                            XposedBridge.log(TAG + ": Error in UpdateFirmwareActivity hook: " + t.getMessage());
                        }
                    }
                }
            );
            
            XposedBridge.log(TAG + ": Successfully hooked UpdateFirmwareActivity");
            
        } catch (Throwable t) {
            XposedBridge.log(TAG + ": Error hooking UpdateFirmwareActivity: " + t.getMessage());
            XposedBridge.log(t);
        }
    }
    END DISABLED CODE - Firmware reload feature */
    
    
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
            
            // === APRS RECEIVED BUTTON ===
            Button aprsReceivedButton = new Button(context);
            aprsReceivedButton.setText("📡 APRS Received");
            aprsReceivedButton.setTextSize(16);
            aprsReceivedButton.setAllCaps(false);
            aprsReceivedButton.setPadding(20, 20, 20, 20);
            aprsReceivedButton.setLayoutParams(new ViewGroup.LayoutParams(templateParams));
            
            aprsReceivedButton.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View v) {
                    XposedBridge.log(TAG + ": APRS Received button clicked");
                    showReceivedStationsDialog(activity);
                }
            });
            
            // === APRS SETTINGS BUTTON ===
            Button aprsSettingsButton = new Button(context);
            aprsSettingsButton.setText("⚙️ APRS Settings");
            aprsSettingsButton.setTextSize(16);
            aprsSettingsButton.setAllCaps(false);
            aprsSettingsButton.setPadding(20, 20, 20, 20);
            aprsSettingsButton.setLayoutParams(new ViewGroup.LayoutParams(templateParams));
            
            aprsSettingsButton.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View v) {
                    XposedBridge.log(TAG + ": APRS Settings button clicked");
                    showAPRSSettingsDialog(activity);
                }
            });
            
            // === RECEIVED STATIONS BUTTON (REMOVED - merged into APRS button) ===
            Button receivedButton = null;
            /*
            Button receivedButton = new Button(context);
            receivedButton.setText("📍 Received Stations");
            receivedButton.setTextSize(16);
            receivedButton.setAllCaps(false);
            receivedButton.setPadding(20, 20, 20, 20);
            receivedButton.setLayoutParams(new ViewGroup.LayoutParams(templateParams));
            
            */
            
            // Add buttons at specified index
            if (index >= 0) {
                parentLayout.addView(exportButton, index);
                parentLayout.addView(importButton, index + 1);
                parentLayout.addView(aprsReceivedButton, index + 2);
                parentLayout.addView(aprsSettingsButton, index + 3);
                XposedBridge.log(TAG + ": ✓ Export button added at index " + index);
                XposedBridge.log(TAG + ": ✓ Import button added at index " + (index + 1));
                XposedBridge.log(TAG + ": ✓ APRS Received button added at index " + (index + 2));
                XposedBridge.log(TAG + ": ✓ APRS Settings button added at index " + (index + 3));
            } else {
                parentLayout.addView(exportButton);
                parentLayout.addView(importButton);
                parentLayout.addView(aprsReceivedButton);
                parentLayout.addView(aprsSettingsButton);
                XposedBridge.log(TAG + ": ✓ Export, Import, APRS Received, and APRS Settings buttons added at end of layout");
            }
            
        } catch (Exception e) {
            XposedBridge.log(TAG + ": Error adding buttons to layout: " + e.getMessage());
            e.printStackTrace();
        }
    }
    
    /**
     * Show received APRS stations dialog
     */
    private void showReceivedStationsDialog(final Activity activity) {
        try {
            APRSReceivedDatabase db = APRSReceivedDatabase.getInstance(activity);
            java.util.List<APRSReceivedDatabase.ReceivedStation> stations = db.getRecentStations();
            
            AlertDialog.Builder builder = new AlertDialog.Builder(activity);
            builder.setTitle("📍 Received APRS Stations (" + stations.size() + ")");
            
            ScrollView scrollView = new ScrollView(activity);
            LinearLayout mainLayout = new LinearLayout(activity);
            mainLayout.setOrientation(LinearLayout.VERTICAL);
            mainLayout.setPadding(40, 40, 40, 40);
            
            if (stations.isEmpty()) {
                TextView noStations = new TextView(activity);
                noStations.setText("No stations received yet.\n\nAPRS receive is passive - stations will appear here when APRS packets are decoded from incoming audio.\n\nAll received packets are automatically logged to:\n• Download/DMR/APRS/CALLSIGN-SSID.txt (text log)\n• Download/DMR/APRS/CALLSIGN-SSID.gpx (track file)\n\nOpen with file manager to view GPX tracks in OsmAnd/Maps.me.");
                noStations.setTextSize(16);
                noStations.setPadding(0, 20, 0, 20);
                mainLayout.addView(noStations);
            } else {
                // Export info at top
                TextView exportInfo = new TextView(activity);
                exportInfo.setText("📁 Each station auto-exported to Download/DMR/APRS/:\n" +
                                 "• CALLSIGN-SSID.txt (running log)\n" +
                                 "• CALLSIGN-SSID.gpx (track - open with file manager)\n" +
                                 "Tap coordinates below for quick map view.");
                exportInfo.setTextSize(13);
                exportInfo.setTextColor(0xFF66FF66);
                exportInfo.setPadding(0, 0, 0, 20);
                mainLayout.addView(exportInfo);
                
                for (final APRSReceivedDatabase.ReceivedStation station : stations) {
                    // Station container
                    LinearLayout stationLayout = new LinearLayout(activity);
                    stationLayout.setOrientation(LinearLayout.VERTICAL);
                    stationLayout.setPadding(10, 15, 10, 15);
                    stationLayout.setBackgroundColor(0xFF2A2A2A);
                    
                    LinearLayout.LayoutParams stationParams = new LinearLayout.LayoutParams(
                            LinearLayout.LayoutParams.MATCH_PARENT,
                            LinearLayout.LayoutParams.WRAP_CONTENT
                    );
                    stationParams.setMargins(0, 0, 0, 10);
                    stationLayout.setLayoutParams(stationParams);
                    
                    // Callsign and time
                    TextView callsignText = new TextView(activity);
                    callsignText.setText("📡 " + station.getFullCallsign());
                    callsignText.setTextSize(18);
                    callsignText.setTypeface(null, android.graphics.Typeface.BOLD);
                    callsignText.setTextColor(0xFF66FF66);
                    stationLayout.addView(callsignText);
                    
                    // Time ago
                    long ageMs = System.currentTimeMillis() - station.timestamp;
                    String timeAgo;
                    if (ageMs < 60000) {
                        timeAgo = (ageMs / 1000) + "s ago";
                    } else if (ageMs < 3600000) {
                        timeAgo = (ageMs / 60000) + "m ago";
                    } else {
                        timeAgo = (ageMs / 3600000) + "h ago";
                    }
                    
                    TextView timeText = new TextView(activity);
                    timeText.setText("🕐 " + timeAgo);
                    timeText.setTextSize(14);
                    timeText.setTextColor(0xFF999999);
                    timeText.setPadding(0, 5, 0, 0);
                    stationLayout.addView(timeText);
                    
                    // Clickable location link
                    TextView locationText = new TextView(activity);
                    locationText.setText("📍 " + station.getLocationString());
                    locationText.setTextSize(16);
                    locationText.setTextColor(0xFF6699FF);
                    locationText.setPadding(0, 10, 0, 0);
                    locationText.setClickable(true);
                    locationText.setOnClickListener(new View.OnClickListener() {
                        @Override
                        public void onClick(View v) {
                            try {
                                android.content.Intent intent = new android.content.Intent(
                                        android.content.Intent.ACTION_VIEW,
                                        android.net.Uri.parse(station.getMapUrl())
                                );
                                intent.addFlags(android.content.Intent.FLAG_ACTIVITY_NEW_TASK);
                                activity.startActivity(intent);
                                XposedBridge.log(TAG + ": Opening map for " + station.getFullCallsign());
                            } catch (Exception e) {
                                Toast.makeText(activity, "Error opening map", Toast.LENGTH_SHORT).show();
                                XposedBridge.log(TAG + ": Error opening map: " + e.getMessage());
                            }
                        }
                    });
                    stationLayout.addView(locationText);
                    
                    // Altitude if available
                    if (station.altitude > 0) {
                        TextView altText = new TextView(activity);
                        altText.setText("⛰ " + station.altitude + "m");
                        altText.setTextSize(14);
                        altText.setTextColor(0xFF999999);
                        altText.setPadding(0, 5, 0, 0);
                        stationLayout.addView(altText);
                    }
                    
                    // Comment if available
                    if (station.comment != null && !station.comment.isEmpty()) {
                        TextView commentText = new TextView(activity);
                        commentText.setText("💬 " + station.comment);
                        commentText.setTextSize(14);
                        commentText.setTextColor(0xFFCCCCCC);
                        commentText.setPadding(0, 5, 0, 0);
                        stationLayout.addView(commentText);
                    }
                    
                    mainLayout.addView(stationLayout);
                }
            }
            
            // Clear button
            builder.setNegativeButton("Clear All", new DialogInterface.OnClickListener() {
                @Override
                public void onClick(DialogInterface dialog, int which) {
                    APRSReceivedDatabase db = APRSReceivedDatabase.getInstance(activity);
                    db.clearAll();
                    Toast.makeText(activity, "Received stations cleared", Toast.LENGTH_SHORT).show();
                }
            });
            
            builder.setPositiveButton("Close", null);
            
            scrollView.addView(mainLayout);
            builder.setView(scrollView);
            builder.show();
            
        } catch (Exception e) {
            XposedBridge.log(TAG + ": Error showing received stations dialog: " + e.getMessage());
            e.printStackTrace();
            Toast.makeText(activity, "Error: " + e.getMessage(), Toast.LENGTH_LONG).show();
        }
    }
    
    /**
     * Show APRS Settings dialog
     */
    private void showAPRSSettingsDialog(final Activity activity) {
        try {
            APRSDatabase aprsDb = APRSDatabase.getInstance(activity);
            
            AlertDialog.Builder builder = new AlertDialog.Builder(activity);
            builder.setTitle("⚙️ APRS Settings");
            
            ScrollView scrollView = new ScrollView(activity);
            LinearLayout mainLayout = new LinearLayout(activity);
            mainLayout.setOrientation(LinearLayout.VERTICAL);
            mainLayout.setPadding(40, 40, 40, 40);
            
            // === Global Settings Section ===
            TextView globalTitle = new TextView(activity);
            globalTitle.setText("Global APRS Settings");
            globalTitle.setTextSize(18);
            globalTitle.setTypeface(null, android.graphics.Typeface.BOLD);
            globalTitle.setPadding(0, 10, 0, 10);
            mainLayout.addView(globalTitle);
            
            TextView explanationText = new TextView(activity);
            explanationText.setText("Your callsign and SSID are used for identification in logs and potential future export features. All received APRS packets are automatically saved to a database with timestamp and location.");
            explanationText.setTextSize(13);
            explanationText.setTextColor(0xFF999999);
            explanationText.setPadding(0, 0, 0, 20);
            mainLayout.addView(explanationText);
            
            // Callsign
            TextView callsignLabel = new TextView(activity);
            callsignLabel.setText("Your Callsign:");
            callsignLabel.setTextSize(14);
            callsignLabel.setPadding(0, 10, 0, 5);
            mainLayout.addView(callsignLabel);
            
            final EditText callsignEdit = new EditText(activity);
            callsignEdit.setText(aprsDb.getCallsign());
            callsignEdit.setHint("N0CALL");
            callsignEdit.setInputType(android.text.InputType.TYPE_CLASS_TEXT | android.text.InputType.TYPE_TEXT_FLAG_CAP_CHARACTERS);
            mainLayout.addView(callsignEdit);
            
            // SSID
            TextView ssidLabel = new TextView(activity);
            ssidLabel.setText("SSID (0-15):");
            ssidLabel.setTextSize(14);
            ssidLabel.setPadding(0, 10, 0, 5);
            mainLayout.addView(ssidLabel);
            
            final EditText ssidEdit = new EditText(activity);
            ssidEdit.setText(String.valueOf(aprsDb.getSSID()));
            ssidEdit.setHint("7");
            ssidEdit.setInputType(android.text.InputType.TYPE_CLASS_NUMBER);
            mainLayout.addView(ssidEdit);
            
            TextView ssidInfo = new TextView(activity);
            ssidInfo.setText("Common SSIDs: 7=Handheld, 9=Vehicle, 1=Digipeater, 5=Other");
            ssidInfo.setTextSize(11);
            ssidInfo.setTextColor(0xFF999999);
            ssidInfo.setPadding(0, 2, 0, 15);
            mainLayout.addView(ssidInfo);
            
            // APRS Frequency
            TextView frequencyLabel = new TextView(activity);
            frequencyLabel.setText("APRS Frequency (MHz):");
            frequencyLabel.setTextSize(14);
            frequencyLabel.setPadding(0, 10, 0, 5);
            mainLayout.addView(frequencyLabel);
            
            final EditText frequencyEdit = new EditText(activity);
            frequencyEdit.setText(aprsDb.getAprsFrequency());
            frequencyEdit.setHint("144.390");
            frequencyEdit.setInputType(android.text.InputType.TYPE_CLASS_NUMBER | android.text.InputType.TYPE_NUMBER_FLAG_DECIMAL);
            mainLayout.addView(frequencyEdit);
            
            TextView infoText = new TextView(activity);
            infoText.setText("\nThe APRS frequency is used by the APRS monitoring mode button on the intercom page.\n\n" +
                           "📡 RX-Only Mode: This system only receives APRS packets (no transmission).\n" +
                           "📝 Auto-Logging: All received packets are stored in database with callsign, location, timestamp.\n" +
                           "🗺️ View History: Use 'APRS Received' button to see recent stations.");
            infoText.setTextSize(12);
            infoText.setTextColor(0xFF999999);
            infoText.setPadding(0, 5, 0, 10);
            mainLayout.addView(infoText);
            
            // Save button
            builder.setPositiveButton("Save", new DialogInterface.OnClickListener() {
                @Override
                public void onClick(DialogInterface dialog, int which) {
                    try {
                        // Save global settings
                        String callsign = callsignEdit.getText().toString().trim().toUpperCase();
                        if (callsign.length() > 6) {
                            Toast.makeText(activity, "Callsign must be 6 chars or less", Toast.LENGTH_SHORT).show();
                            return;
                        }
                        
                        int ssid = Integer.parseInt(ssidEdit.getText().toString().trim());
                        if (ssid < 0 || ssid > 15) {
                            Toast.makeText(activity, "SSID must be 0-15", Toast.LENGTH_SHORT).show();
                            return;
                        }
                        
                        String frequency = frequencyEdit.getText().toString().trim();
                        if (frequency.isEmpty()) {
                            Toast.makeText(activity, "APRS frequency cannot be empty", Toast.LENGTH_SHORT).show();
                            return;
                        }
                        try {
                            double freq = Double.parseDouble(frequency);
                            if (freq < 1.0 || freq > 999.999) {
                                Toast.makeText(activity, "Frequency must be 1.0-999.999 MHz", Toast.LENGTH_SHORT).show();
                                return;
                            }
                        } catch (NumberFormatException e) {
                            Toast.makeText(activity, "Invalid frequency format", Toast.LENGTH_SHORT).show();
                            return;
                        }
                        
                        APRSDatabase aprsDb = APRSDatabase.getInstance(activity);
                        aprsDb.setCallsign(callsign);
                        aprsDb.setSSID(ssid);
                        aprsDb.setAprsFrequency(frequency);
                        
                        Toast.makeText(activity, "APRS settings saved!", Toast.LENGTH_SHORT).show();
                        
                    } catch (Exception e) {
                        Toast.makeText(activity, "Error: " + e.getMessage(), Toast.LENGTH_LONG).show();
                        XposedBridge.log(TAG + ": Error saving APRS settings: " + e.getMessage());
                    }
                }
            });
            
            builder.setNegativeButton("Cancel", null);
            
            scrollView.addView(mainLayout);
            builder.setView(scrollView);
            builder.show();
            
        } catch (Exception e) {
            XposedBridge.log(TAG + ": Error showing APRS settings dialog: " + e.getMessage());
            e.printStackTrace();
            Toast.makeText(activity, "Error: " + e.getMessage(), Toast.LENGTH_LONG).show();
        }
    }
    
    /**
     * Show APRS Monitoring Mode dialog
     */
    private void showAPRSMonitoringDialog(final Activity activity) {
        try {
            if (isAPRSMonitoringActive && aprsMonitoringDialog != null && aprsMonitoringDialog.isShowing()) {
                // Dialog already showing - just bring it to front
                XposedBridge.log(TAG + ": APRS monitoring dialog already visible");
                return;
            }
            
            if (isAPRSMonitoringActive) {
                // Show live monitoring screen
                showAPRSLiveMonitoringScreen(activity);
            } else {
                // Show start dialog
                showAPRSStartDialog(activity);
            }
            
        } catch (Exception e) {
            XposedBridge.log(TAG + ": Error showing APRS monitoring dialog: " + e.getMessage());
            XposedBridge.log(e);
            Toast.makeText(activity, "Error: " + e.getMessage(), Toast.LENGTH_LONG).show();
        }
    }
    
    /**
     * Show start monitoring dialog (before monitoring begins)
     */
    private void showAPRSStartDialog(final Activity activity) {
        AlertDialog.Builder builder = new AlertDialog.Builder(activity);
        builder.setTitle("📡 APRS Monitoring Mode");
        
        ScrollView scrollView = new ScrollView(activity);
        LinearLayout mainLayout = new LinearLayout(activity);
        mainLayout.setOrientation(LinearLayout.VERTICAL);
        mainLayout.setPadding(40, 40, 40, 40);
        
        // Status section
        TextView statusText = new TextView(activity);
        statusText.setText("⚫ MONITORING INACTIVE\n\nPress 'Start Monitoring' to begin receiving APRS packets.");
        statusText.setTextSize(14);
        statusText.setTextColor(0xFF999999);
        statusText.setPadding(0, 10, 0, 20);
        mainLayout.addView(statusText);
        
        // Stats section
        final APRSReceivedDatabase db = APRSReceivedDatabase.getInstance(activity);
        int totalStations = db.getStationCount();
        java.util.List<APRSReceivedDatabase.ReceivedStation> recentStations = db.getRecentStations();
        
        TextView statsLabel = new TextView(activity);
        statsLabel.setText("Statistics:");
        statsLabel.setTextSize(16);
        statsLabel.setTypeface(null, android.graphics.Typeface.BOLD);
        mainLayout.addView(statsLabel);
        
        TextView statsText = new TextView(activity);
        statsText.setText("• Total stations: " + totalStations + "\n" +
                         "• Recent (last hour): " + recentStations.size());
        statsText.setTextSize(14);
        statsText.setPadding(0, 10, 0, 20);
        mainLayout.addView(statsText);
        
        // Info section
        TextView infoText = new TextView(activity);
        infoText.setText("\nAll received packets are automatically logged to text and GPX files in Download/DMR/APRS/");
        infoText.setTextSize(12);
        infoText.setTextColor(0xFF999999);
        infoText.setPadding(0, 20, 0, 0);
        mainLayout.addView(infoText);
        
        scrollView.addView(mainLayout);
        builder.setView(scrollView);
        
        builder.setPositiveButton("Start Monitoring", new DialogInterface.OnClickListener() {
            @Override
            public void onClick(DialogInterface dialog, int which) {
                startAPRSMonitoring(activity);
                // Show live monitoring screen after starting
                showAPRSLiveMonitoringScreen(activity);
            }
        });
        
        builder.setNegativeButton("Close", new DialogInterface.OnClickListener() {
            @Override
            public void onClick(DialogInterface dialog, int which) {
                // User closed dialog without starting - uncheck APRS button
                if (aprsMonitoringToggleButton != null) {
                    aprsMonitoringToggleButton.setChecked(false);
                }
            }
        });
        
        // Also handle back button press
        builder.setOnCancelListener(new DialogInterface.OnCancelListener() {
            @Override
            public void onCancel(DialogInterface dialog) {
                // User canceled dialog - uncheck APRS button
                if (aprsMonitoringToggleButton != null) {
                    aprsMonitoringToggleButton.setChecked(false);
                }
            }
        });
        
        builder.show();
    }
    
    /**
     * Show live APRS monitoring screen with real-time updates
     */
    private void showAPRSLiveMonitoringScreen(final Activity activity) {
        if (aprsMonitoringDialog != null && aprsMonitoringDialog.isShowing()) {
            return;  // Already showing
        }
        
        final AlertDialog.Builder builder = new AlertDialog.Builder(activity);
        builder.setTitle("📡 APRS Live Monitoring");
        builder.setCancelable(false);  // Prevent dismissing by back button
        
        // Create scrollable layout
        final ScrollView scrollView = new ScrollView(activity);
        final LinearLayout mainLayout = new LinearLayout(activity);
        mainLayout.setOrientation(LinearLayout.VERTICAL);
        mainLayout.setPadding(40, 40, 40, 40);
        
        scrollView.addView(mainLayout);
        builder.setView(scrollView);
        
        // Stop monitoring button
        builder.setPositiveButton("Stop Monitoring", new DialogInterface.OnClickListener() {
            @Override
            public void onClick(DialogInterface dialog, int which) {
                stopAPRSMonitoring(activity);
                // Stop updates
                if (aprsUpdateHandler != null && aprsUpdateRunnable != null) {
                    aprsUpdateHandler.removeCallbacks(aprsUpdateRunnable);
                }
                aprsMonitoringDialog = null;
            }
        });
        
        aprsMonitoringDialog = builder.create();
        
        // Handle back button press or dialog dismissal
        aprsMonitoringDialog.setOnCancelListener(new DialogInterface.OnCancelListener() {
            @Override
            public void onCancel(DialogInterface dialog) {
                // User dismissed dialog - stop monitoring and uncheck button
                stopAPRSMonitoring(activity);
                if (aprsUpdateHandler != null && aprsUpdateRunnable != null) {
                    aprsUpdateHandler.removeCallbacks(aprsUpdateRunnable);
                }
                aprsMonitoringDialog = null;
            }
        });
        
        aprsMonitoringDialog.show();
        
        // Set up periodic updates
        aprsUpdateHandler = new android.os.Handler(android.os.Looper.getMainLooper());
        aprsUpdateRunnable = new Runnable() {
            @Override
            public void run() {
                if (isAPRSMonitoringActive && aprsMonitoringDialog != null && aprsMonitoringDialog.isShowing()) {
                    updateAPRSLiveScreen(activity, mainLayout);
                    aprsUpdateHandler.postDelayed(this, 2000);  // Update every 2 seconds
                }
            }
        };
        
        // Initial update and start periodic updates
        updateAPRSLiveScreen(activity, mainLayout);
        aprsUpdateHandler.postDelayed(aprsUpdateRunnable, 2000);
    }
    
    /**
     * Update the live APRS monitoring screen content
     */
    private void updateAPRSLiveScreen(final Activity activity, LinearLayout mainLayout) {
        try {
            final APRSReceivedDatabase db = APRSReceivedDatabase.getInstance(activity);
            final APRSDatabase aprsDb = APRSDatabase.getInstance(activity);
            
            // Clear existing content
            mainLayout.removeAllViews();
            
            // Status section
            TextView statusLabel = new TextView(activity);
            statusLabel.setText("Status:");
            statusLabel.setTextSize(16);
            statusLabel.setTypeface(null, android.graphics.Typeface.BOLD);
            mainLayout.addView(statusLabel);
            
            TextView statusText = new TextView(activity);
            String frequency = aprsDb.getAprsFrequency();
            statusText.setText("🟢 MONITORING ACTIVE\nFrequency: " + frequency + " MHz\nReceiving APRS packets...");
            statusText.setTextColor(0xFF00FF00);
            statusText.setTextSize(14);
            statusText.setPadding(0, 10, 0, 20);
            mainLayout.addView(statusText);
            
            // ========== SOFTWARE SQUELCH SLIDER ==========
            TextView squelchLabel = new TextView(activity);
            squelchLabel.setText("Software Squelch:");
            squelchLabel.setTextSize(16);
            squelchLabel.setTypeface(null, android.graphics.Typeface.BOLD);
            squelchLabel.setPadding(0, 10, 0, 10);
            mainLayout.addView(squelchLabel);
            
            // Create horizontal container for squelch controls
            LinearLayout squelchContainer = new LinearLayout(activity);
            squelchContainer.setOrientation(LinearLayout.HORIZONTAL);
            squelchContainer.setPadding(0, 0, 0, 20);
            LinearLayout.LayoutParams squelchContainerParams = new LinearLayout.LayoutParams(
                LinearLayout.LayoutParams.MATCH_PARENT,
                LinearLayout.LayoutParams.WRAP_CONTENT
            );
            squelchContainer.setLayoutParams(squelchContainerParams);
            
            // "SQ:" label
            TextView sqLabel = new TextView(activity);
            sqLabel.setText("SQ:");
            sqLabel.setTextColor(0xFFFFFFFF);
            sqLabel.setTextSize(14);
            sqLabel.setTypeface(null, android.graphics.Typeface.BOLD);
            LinearLayout.LayoutParams labelParams = new LinearLayout.LayoutParams(
                LinearLayout.LayoutParams.WRAP_CONTENT,
                LinearLayout.LayoutParams.WRAP_CONTENT
            );
            labelParams.gravity = android.view.Gravity.CENTER_VERTICAL;
            labelParams.rightMargin = (int) (6 * activity.getResources().getDisplayMetrics().density);  // Reduced from 8dp to 6dp
            sqLabel.setLayoutParams(labelParams);
            squelchContainer.addView(sqLabel);
            
            // Value display
            final TextView sqValueLabel = new TextView(activity);
            int savedSquelch = aprsDb.getAprsSquelch();
            sqValueLabel.setText(String.valueOf(savedSquelch));
            sqValueLabel.setTextColor(0xFF00FF00);  // Green
            sqValueLabel.setTextSize(18);
            sqValueLabel.setTypeface(null, android.graphics.Typeface.BOLD);
            sqValueLabel.setGravity(android.view.Gravity.CENTER);
            LinearLayout.LayoutParams valueLabelParams = new LinearLayout.LayoutParams(
                (int) (40 * activity.getResources().getDisplayMetrics().density),
                LinearLayout.LayoutParams.WRAP_CONTENT
            );
            valueLabelParams.gravity = android.view.Gravity.CENTER_VERTICAL;
            sqValueLabel.setLayoutParams(valueLabelParams);
            squelchContainer.addView(sqValueLabel);
            
            // Squelch slider (0-9)
            final android.widget.SeekBar squelchSeekBar = new android.widget.SeekBar(activity);
            LinearLayout.LayoutParams seekBarParams = new LinearLayout.LayoutParams(
                0,
                LinearLayout.LayoutParams.WRAP_CONTENT
            );
            seekBarParams.weight = 1.0f;
            seekBarParams.topMargin = (int) (4 * activity.getResources().getDisplayMetrics().density);
            seekBarParams.leftMargin = (int) (10 * activity.getResources().getDisplayMetrics().density);
            squelchSeekBar.setLayoutParams(seekBarParams);
            squelchSeekBar.setMax(9);
            squelchSeekBar.setProgress(savedSquelch);
            
            // Set slider color to black (both progress and background)
            try {
                android.content.res.ColorStateList blackColor = android.content.res.ColorStateList.valueOf(0xFF000000);
                squelchSeekBar.setProgressTintList(blackColor);
                squelchSeekBar.setProgressBackgroundTintList(blackColor);  // Make entire track black
                squelchSeekBar.setThumbTintList(blackColor);
            } catch (Exception e) {
                XposedBridge.log(TAG + ": Could not set APRS squelch slider color: " + e);
            }
            
            // Set up SeekBar listener
            squelchSeekBar.setOnSeekBarChangeListener(new android.widget.SeekBar.OnSeekBarChangeListener() {
                @Override
                public void onProgressChanged(android.widget.SeekBar seekBar, int progress, boolean fromUser) {
                    if (fromUser) {
                        // Update value display
                        sqValueLabel.setText(String.valueOf(progress));
                        
                        // Update software squelch threshold
                        softwareSquelchThreshold = progress;
                        
                        XposedBridge.log(TAG + ": APRS software squelch changed to level " + progress + 
                            " (RMS threshold: " + getAudioSquelchThreshold() + 
                            ", RSSI threshold: " + getRssiThreshold(progress) + " dBm)");
                        
                        Toast.makeText(activity, 
                            "Software Squelch: " + progress, 
                            Toast.LENGTH_SHORT
                        ).show();
                    }
                }
                
                @Override
                public void onStartTrackingTouch(android.widget.SeekBar seekBar) {
                    // User started dragging
                }
                
                @Override
                public void onStopTrackingTouch(android.widget.SeekBar seekBar) {
                    // Save to preferences when user finishes dragging
                    int progress = seekBar.getProgress();
                    try {
                        APRSDatabase aprsDb = APRSDatabase.getInstance(activity);
                        if (aprsDb != null) {
                            XposedHelpers.callMethod(aprsDb, "setAprsSquelch", progress);
                            XposedBridge.log(TAG + ": Saved APRS software squelch level " + progress + " to preferences");
                        }
                    } catch (Throwable t) {
                        XposedBridge.log(TAG + ": Error saving APRS squelch to preferences: " + t);
                    }
                }
            });
            
            squelchContainer.addView(squelchSeekBar);
            mainLayout.addView(squelchContainer);
            
            // Update softwareSquelchThreshold to match saved value
            softwareSquelchThreshold = savedSquelch;
            
            // Info text explaining software squelch
            TextView squelchInfo = new TextView(activity);
            squelchInfo.setText("📊 Hybrid RSSI + Audio RMS squelch\n0=most sensitive, 9=least sensitive");
            squelchInfo.setTextSize(11);
            squelchInfo.setTextColor(0xFF999999);
            squelchInfo.setPadding(0, 0, 0, 20);
            mainLayout.addView(squelchInfo);
            
            // Stats section
            int totalStations = db.getStationCount();
            java.util.List<APRSReceivedDatabase.ReceivedStation> recentStations = db.getRecentStations();
            
            TextView statsLabel = new TextView(activity);
            statsLabel.setText("Statistics:");
            statsLabel.setTextSize(16);
            statsLabel.setTypeface(null, android.graphics.Typeface.BOLD);
            mainLayout.addView(statsLabel);
            
            TextView statsText = new TextView(activity);
            long now = System.currentTimeMillis();
            int last5Min = 0;
            for (APRSReceivedDatabase.ReceivedStation station : recentStations) {
                if (now - station.timestamp < 300000) {  // 5 minutes
                    last5Min++;
                }
            }
            statsText.setText("• Total stations: " + totalStations + "\n" +
                             "• Last hour: " + recentStations.size() + "\n" +
                             "• Last 5 min: " + last5Min);
            statsText.setTextSize(14);
            statsText.setPadding(0, 10, 0, 20);
            mainLayout.addView(statsText);
            
            // Recent stations list (clickable)
            if (!recentStations.isEmpty()) {
                TextView recentLabel = new TextView(activity);
                recentLabel.setText("Recent Packets (tap to view on map):");
                recentLabel.setTextSize(16);
                recentLabel.setTypeface(null, android.graphics.Typeface.BOLD);
                mainLayout.addView(recentLabel);
                
                int displayCount = Math.min(10, recentStations.size());
                for (int i = 0; i < displayCount; i++) {
                    final APRSReceivedDatabase.ReceivedStation station = recentStations.get(i);
                    
                    TextView stationText = new TextView(activity);
                    long ageMs = System.currentTimeMillis() - station.timestamp;
                    String timeAgo;
                    if (ageMs < 60000) {
                        timeAgo = (ageMs / 1000) + "s ago";
                    } else if (ageMs < 3600000) {
                        timeAgo = (ageMs / 60000) + "m ago";
                    } else {
                        timeAgo = (ageMs / 3600000) + "h ago";
                    }
                    
                    stationText.setText("📡 " + station.getFullCallsign() + " - " + timeAgo + 
                                      "\n   " + String.format("%.6f, %.6f", station.latitude, station.longitude));
                    stationText.setTextSize(13);
                    stationText.setTextColor(0xFF66FFFF);
                    stationText.setPadding(0, 8, 0, 0);
                    stationText.setClickable(true);
                    stationText.setFocusable(true);
                    
                    // Make it look like a link
                    stationText.setPaintFlags(stationText.getPaintFlags() | android.graphics.Paint.UNDERLINE_TEXT_FLAG);
                    
                    // Click listener to open maps
                    stationText.setOnClickListener(new View.OnClickListener() {
                        @Override
                        public void onClick(View v) {
                            try {
                                // Open Google Maps with coordinates
                                String uri = "geo:" + station.latitude + "," + station.longitude + 
                                           "?q=" + station.latitude + "," + station.longitude + 
                                           "(" + station.getFullCallsign() + ")";
                                android.content.Intent intent = new android.content.Intent(android.content.Intent.ACTION_VIEW);
                                intent.setData(android.net.Uri.parse(uri));
                                activity.startActivity(intent);
                                XposedBridge.log(TAG + ": Opened maps for " + station.getFullCallsign());
                            } catch (Exception e) {
                                XposedBridge.log(TAG + ": Error opening maps: " + e.getMessage());
                                Toast.makeText(activity, "Error opening maps", Toast.LENGTH_SHORT).show();
                            }
                        }
                    });
                    
                    mainLayout.addView(stationText);
                }
            } else {
                TextView noDataText = new TextView(activity);
                noDataText.setText("\nWaiting for APRS packets...");
                noDataText.setTextSize(14);
                noDataText.setTextColor(0xFF999999);
                noDataText.setTypeface(null, android.graphics.Typeface.ITALIC);
                mainLayout.addView(noDataText);
            }
            
            // Info section
            TextView infoText = new TextView(activity);
            infoText.setText("\n💾 Auto-logging to: Download/DMR/APRS/");
            infoText.setTextSize(11);
            infoText.setTextColor(0xFF666666);
            infoText.setPadding(0, 20, 0, 0);
            mainLayout.addView(infoText);
            
        } catch (Exception e) {
            XposedBridge.log(TAG + ": Error updating APRS live screen: " + e.getMessage());
            XposedBridge.log(e);
        }
    }
    
    /**
     * Create APRS channel if it doesn't exist
     */
    private Object createAPRSChannelIfNeeded(Activity activity, Object dmrManager, java.util.List<Object> channels) throws Exception {
        // Check if APRS channel already exists
        for (Object channelData : channels) {
            if (isAPRSChannel(channelData)) {
                XposedBridge.log(TAG + ": APRS channel already exists");
                return channelData;
            }
        }
        
        // Find the highest channel number to assign the next one
        int highestChannelNumber = 0;
        for (Object channelData : channels) {
            int channelNumber = XposedHelpers.getIntField(channelData, "number");
            if (channelNumber > highestChannelNumber) {
                highestChannelNumber = channelNumber;
            }
        }
        
        int aprsChannelNumber = highestChannelNumber + 1;
        XposedBridge.log(TAG + ": Creating APRS channel with number " + aprsChannelNumber);
        
        // Get APRS frequency from settings
        APRSDatabase aprsDb = APRSDatabase.getInstance(activity);
        String frequencyStr = aprsDb.getAprsFrequency();
        double frequencyMHz = Double.parseDouble(frequencyStr);
        int frequencyHz = (int) (frequencyMHz * 1000000);
        
        // Create new ChannelData for APRS
        Class<?> channelDataClass = XposedHelpers.findClass(
            "com.pri.prizeinterphone.serial.data.ChannelData",
            appClassLoader
        );
        Object aprsChannel = channelDataClass.newInstance();
        
        // Set basic fields
        XposedHelpers.setIntField(aprsChannel, "type", 1);  // ANALOG
        XposedHelpers.setIntField(aprsChannel, "number", aprsChannelNumber);
        XposedHelpers.setObjectField(aprsChannel, "name", "APRS");
        XposedHelpers.setIntField(aprsChannel, "rxFreq", frequencyHz);
        XposedHelpers.setIntField(aprsChannel, "txFreq", frequencyHz);
        XposedHelpers.setIntField(aprsChannel, "sq", 1);  // Default squelch
        XposedHelpers.setIntField(aprsChannel, "band", 1);  // VHF
        XposedHelpers.setIntField(aprsChannel, "power", 1);  // High power
        XposedHelpers.setIntField(aprsChannel, "rxType", 0);  // No tone
        XposedHelpers.setIntField(aprsChannel, "rxSubCode", 0);
        XposedHelpers.setIntField(aprsChannel, "txType", 0);
        XposedHelpers.setIntField(aprsChannel, "txSubCode", 0);
        XposedHelpers.setIntField(aprsChannel, "relay", 0);
        XposedHelpers.setIntField(aprsChannel, "active", 1);  // Active
        
        // Add channel to database
        String dbName = "default";  // Use default channel area
        XposedHelpers.callMethod(dmrManager, "createChannel", dbName, aprsChannel);
        
        XposedBridge.log(TAG + ": Created APRS channel #" + aprsChannelNumber + " at " + frequencyMHz + " MHz");
        Toast.makeText(activity, "Created APRS channel at " + frequencyMHz + " MHz", Toast.LENGTH_SHORT).show();
        
        // Reload channels list
        XposedHelpers.callMethod(dmrManager, "updateChannelList");
        
        return aprsChannel;
    }
    
    /**
     * Start APRS monitoring mode
     */
    private void startAPRSMonitoring(final Activity activity) {
        try {
            XposedBridge.log(TAG + ": Starting APRS monitoring mode");
            
            // Get APRS frequency setting
            APRSDatabase aprsDb = APRSDatabase.getInstance(activity);
            String frequencyStr = aprsDb.getAprsFrequency();
            double frequencyMHz = Double.parseDouble(frequencyStr);
            int frequencyHz = (int) (frequencyMHz * 1000000);
            
            // Get DmrManager
            Class<?> dmrManagerClass = XposedHelpers.findClass(
                "com.pri.prizeinterphone.manager.DmrManager",
                appClassLoader
            );
            Object dmrManager = XposedHelpers.callStaticMethod(dmrManagerClass, "getInstance");
            
            // Get current channel
            Object currentChannel = XposedHelpers.callMethod(dmrManager, "getCurrentChannel");
            if (currentChannel == null) {
                throw new Exception("Cannot get current channel");
            }
            
            // Save current channel settings in memory
            saveChannelBackup(currentChannel);
            XposedBridge.log(TAG + ": Backed up current channel");
            
            // Hijack current channel with APRS settings
            XposedHelpers.setIntField(currentChannel, "type", 1);  // ANALOG
            String originalName = (String) XposedHelpers.getObjectField(currentChannel, "name");
            XposedHelpers.setObjectField(currentChannel, "name", "APRS (" + originalName + ")");
            XposedHelpers.setIntField(currentChannel, "rxFreq", frequencyHz);
            XposedHelpers.setIntField(currentChannel, "txFreq", frequencyHz);
            XposedHelpers.setIntField(currentChannel, "sq", 0);  // Hardware squelch 0 (fully open - same as MON button)
            XposedHelpers.setIntField(currentChannel, "band", 1);  // VHF
            XposedHelpers.setIntField(currentChannel, "power", 1);  // High power
            XposedHelpers.setIntField(currentChannel, "rxType", 0);  // No tone
            XposedHelpers.setIntField(currentChannel, "rxSubCode", 0);
            XposedHelpers.setIntField(currentChannel, "txType", 0);
            XposedHelpers.setIntField(currentChannel, "txSubCode", 0);
            
            // Enable software squelch for APRS monitoring
            isSoftwareSquelchEnabled = true;
            currentChannelType = 1;  // Update static variable to match analog channel
            softwareSquelchThreshold = aprsDb.getAprsSquelch();  // Load saved squelch level
            XposedBridge.log(TAG + ": Enabled software squelch for APRS with level " + softwareSquelchThreshold);
            
            // Update hardware with APRS settings
            XposedHelpers.callMethod(dmrManager, "updateChannel", currentChannel);
            XposedHelpers.callMethod(dmrManager, "syncChannelInfoWithData", currentChannel);
            
            isAPRSMonitoringActive = true;
            
            // Update APRS button to checked state
            if (aprsMonitoringToggleButton != null) {
                aprsMonitoringToggleButton.setChecked(true);
            }
            
            Toast.makeText(activity, "APRS Monitoring Active at " + frequencyMHz + " MHz\nSoftware Squelch: " + softwareSquelchThreshold, Toast.LENGTH_SHORT).show();
            XposedBridge.log(TAG + ": ✅ APRS monitoring active - current channel hijacked with software squelch");
            
        } catch (Exception e) {
            XposedBridge.log(TAG + ": Error starting APRS monitoring: " + e.getMessage());
            XposedBridge.log(e);
            Toast.makeText(activity, "Error: " + e.getMessage(), Toast.LENGTH_LONG).show();
        }
    }
    
    /**
     * Stop APRS monitoring mode
     */
    private void stopAPRSMonitoring(final Activity activity) {
        try {
            XposedBridge.log(TAG + ": Stopping APRS monitoring");
            
            // Restore channel from backup
            restoreChannelBackup(activity);
            
            isAPRSMonitoringActive = false;
            
            // Update APRS button to unchecked state
            if (aprsMonitoringToggleButton != null) {
                aprsMonitoringToggleButton.setChecked(false);
            }
            
            // Reset squelch state for next monitoring session
            isAPRSSquelchOpen = false;
            aprsStoredSquelch = 1;
            
            Toast.makeText(activity, "APRS Monitoring stopped", Toast.LENGTH_SHORT).show();
            XposedBridge.log(TAG + ": APRS monitoring mode deactivated");
            
        } catch (Exception e) {
            XposedBridge.log(TAG + ": Error stopping APRS monitoring: " + e.getMessage());
            XposedBridge.log(e);
        }
    }
    
    // Channel backup storage (in memory and file)
    private java.util.HashMap<String, Object> channelBackup = null;
    
    /**
     * Save channel settings to memory AND file
     */
    private void saveChannelBackup(Object channel) {
        try {
            channelBackup = new java.util.HashMap<>();
            channelBackup.put("number", XposedHelpers.getIntField(channel, "number"));
            channelBackup.put("type", XposedHelpers.getIntField(channel, "type"));
            channelBackup.put("name", XposedHelpers.getObjectField(channel, "name"));
            channelBackup.put("rxFreq", XposedHelpers.getIntField(channel, "rxFreq"));
            channelBackup.put("txFreq", XposedHelpers.getIntField(channel, "txFreq"));
            channelBackup.put("sq", XposedHelpers.getIntField(channel, "sq"));
            channelBackup.put("band", XposedHelpers.getIntField(channel, "band"));
            channelBackup.put("power", XposedHelpers.getIntField(channel, "power"));
            channelBackup.put("rxType", XposedHelpers.getIntField(channel, "rxType"));
            channelBackup.put("rxSubCode", XposedHelpers.getIntField(channel, "rxSubCode"));
            channelBackup.put("txType", XposedHelpers.getIntField(channel, "txType"));
            channelBackup.put("txSubCode", XposedHelpers.getIntField(channel, "txSubCode"));
            
            // Also save to file for crash recovery
            saveChannelBackupToFile(channelBackup);
            
            XposedBridge.log(TAG + ": Channel backup saved: " + channelBackup.get("name"));
            
        } catch (Exception e) {
            XposedBridge.log(TAG + ": Error saving channel backup: " + e.getMessage());
        }
    }
    
    /**
     * Save channel backup to file
     */
    private void saveChannelBackupToFile(java.util.HashMap<String, Object> backup) {
        try {
            java.io.File backupFile = new java.io.File("/sdcard/aprs_channel_backup.dat");
            java.io.ObjectOutputStream oos = new java.io.ObjectOutputStream(
                new java.io.FileOutputStream(backupFile));
            oos.writeObject(backup);
            oos.close();
            XposedBridge.log(TAG + ": Channel backup saved to file");
        } catch (Exception e) {
            XposedBridge.log(TAG + ": Error saving backup to file: " + e.getMessage());
        }
    }
    
    /**
     * Load channel backup from file
     */
    private java.util.HashMap<String, Object> loadChannelBackupFromFile() {
        try {
            java.io.File backupFile = new java.io.File("/sdcard/aprs_channel_backup.dat");
            if (!backupFile.exists()) {
                return null;
            }
            
            java.io.ObjectInputStream ois = new java.io.ObjectInputStream(
                new java.io.FileInputStream(backupFile));
            @SuppressWarnings("unchecked")
            java.util.HashMap<String, Object> backup = (java.util.HashMap<String, Object>) ois.readObject();
            ois.close();
            
            XposedBridge.log(TAG + ": Channel backup loaded from file");
            return backup;
        } catch (Exception e) {
            XposedBridge.log(TAG + ": Error loading backup from file: " + e.getMessage());
            return null;
        }
    }
    
    /**
     * Delete backup file
     */
    private void deleteChannelBackupFile() {
        try {
            java.io.File backupFile = new java.io.File("/sdcard/aprs_channel_backup.dat");
            if (backupFile.exists()) {
                backupFile.delete();
                XposedBridge.log(TAG + ": Channel backup file deleted");
            }
        } catch (Exception e) {
            XposedBridge.log(TAG + ": Error deleting backup file: " + e.getMessage());
        }
    }
    
    /**
     * Restore channel from backup
     */
    private void restoreChannelBackup(Context context) {
        try {
            if (channelBackup == null) {
                XposedBridge.log(TAG + ": No channel backup found");
                return;
            }
            
            // Get DmrManager
            Class<?> dmrManagerClass = XposedHelpers.findClass(
                "com.pri.prizeinterphone.manager.DmrManager",
                appClassLoader
            );
            Object dmrManager = XposedHelpers.callStaticMethod(dmrManagerClass, "getInstance");
            
            // Get current channel
            Object currentChannel = XposedHelpers.callMethod(dmrManager, "getCurrentChannel");
            if (currentChannel == null) {
                XposedBridge.log(TAG + ": Cannot get current channel for restore");
                return;
            }
            
            XposedBridge.log(TAG + ": Restoring channel from backup: " + channelBackup.get("name") + 
                " @ " + channelBackup.get("rxFreq") + " Hz");
            
            // Restore all fields INCLUDING number
            XposedHelpers.setIntField(currentChannel, "number", (Integer) channelBackup.get("number"));
            XposedHelpers.setIntField(currentChannel, "type", (Integer) channelBackup.get("type"));
            XposedHelpers.setObjectField(currentChannel, "name", channelBackup.get("name"));
            XposedHelpers.setIntField(currentChannel, "rxFreq", (Integer) channelBackup.get("rxFreq"));
            XposedHelpers.setIntField(currentChannel, "txFreq", (Integer) channelBackup.get("txFreq"));
            XposedHelpers.setIntField(currentChannel, "sq", (Integer) channelBackup.get("sq"));
            XposedHelpers.setIntField(currentChannel, "band", (Integer) channelBackup.get("band"));
            XposedHelpers.setIntField(currentChannel, "power", (Integer) channelBackup.get("power"));
            XposedHelpers.setIntField(currentChannel, "rxType", (Integer) channelBackup.get("rxType"));
            XposedHelpers.setIntField(currentChannel, "rxSubCode", (Integer) channelBackup.get("rxSubCode"));
            XposedHelpers.setIntField(currentChannel, "txType", (Integer) channelBackup.get("txType"));
            XposedHelpers.setIntField(currentChannel, "txSubCode", (Integer) channelBackup.get("txSubCode"));
            
            // Update hardware
            XposedHelpers.callMethod(dmrManager, "updateChannel", currentChannel);
            XposedHelpers.callMethod(dmrManager, "syncChannelInfoWithData", currentChannel);
            
            XposedBridge.log(TAG + ": Channel restored: " + channelBackup.get("name"));
            channelBackup = null;  // Clear backup
            
            // Delete backup file after successful restore
            deleteChannelBackupFile();
            
        } catch (Exception e) {
            XposedBridge.log(TAG + ": Error restoring channel: " + e.getMessage());
        }
    }
    
    /**
     * Check on startup if stuck on APRS channel and restore if backup exists
     */
    private void checkAndRestoreAPRSChannelOnStartup(final Context context) {
        boolean shouldDeleteBackup = false;
        try {
            XposedBridge.log(TAG + ": Checking for orphaned APRS channel...");
            
            // Note: APRS state already reset immediately in MainActivity.onCreate (before this delayed call)
            
            // Check if backup file exists
            java.io.File backupFile = new java.io.File("/sdcard/aprs_channel_backup.dat");
            if (!backupFile.exists()) {
                XposedBridge.log(TAG + ": No APRS backup file found - normal startup");
                return;
            }
            
            XposedBridge.log(TAG + ": Backup file found - checking if channel needs restore");
            shouldDeleteBackup = true;  // Always delete backup file after this point
            
            // Get DmrManager
            Class<?> dmrManagerClass = XposedHelpers.findClass(
                "com.pri.prizeinterphone.manager.DmrManager",
                appClassLoader
            );
            Object dmrManager = XposedHelpers.callStaticMethod(dmrManagerClass, "getInstance");
            
            if (dmrManager == null) {
                XposedBridge.log(TAG + ": ⚠️ DmrManager not ready yet - will delete backup and skip restore");
                return;
            }
            
            // Get current channel
            Object currentChannel = XposedHelpers.callMethod(dmrManager, "getCurrentChannel");
            if (currentChannel == null) {
                XposedBridge.log(TAG + ": ⚠️ Cannot get current channel - will delete backup and skip restore");
                return;
            }
            
            // Check if current channel looks like APRS (name starts with "APRS (" or frequency is 144.39 MHz)
            String channelName = (String) XposedHelpers.getObjectField(currentChannel, "name");
            int rxFreq = XposedHelpers.getIntField(currentChannel, "rxFreq");
            
            XposedBridge.log(TAG + ": Current channel: " + channelName + " @ " + rxFreq + " Hz");
            
            if (channelName.startsWith("APRS (") || rxFreq == 144390000) {
                XposedBridge.log(TAG + ": ⚠️ Detected orphaned APRS channel - restoring backup...");
                
                // Load backup from file
                channelBackup = loadChannelBackupFromFile();
                if (channelBackup != null) {
                    XposedBridge.log(TAG + ": Backup loaded, restoring to: " + channelBackup.get("name") + 
                        " @ " + channelBackup.get("rxFreq") + " Hz");
                    
                    // Log BEFORE state
                    XposedBridge.log(TAG + ": BEFORE restore - currentChannel:");
                    XposedBridge.log(TAG + ":   name: " + XposedHelpers.getObjectField(currentChannel, "name"));
                    XposedBridge.log(TAG + ":   rxFreq: " + XposedHelpers.getIntField(currentChannel, "rxFreq"));
                    XposedBridge.log(TAG + ":   txFreq: " + XposedHelpers.getIntField(currentChannel, "txFreq"));
                    XposedBridge.log(TAG + ":   type: " + XposedHelpers.getIntField(currentChannel, "type"));
                    XposedBridge.log(TAG + ":   number: " + XposedHelpers.getIntField(currentChannel, "number"));
                    
                    // Restore all fields INCLUDING number
                    XposedHelpers.setIntField(currentChannel, "number", (Integer) channelBackup.get("number"));
                    XposedHelpers.setIntField(currentChannel, "type", (Integer) channelBackup.get("type"));
                    XposedHelpers.setObjectField(currentChannel, "name", channelBackup.get("name"));
                    XposedHelpers.setIntField(currentChannel, "rxFreq", (Integer) channelBackup.get("rxFreq"));
                    XposedHelpers.setIntField(currentChannel, "txFreq", (Integer) channelBackup.get("txFreq"));
                    XposedHelpers.setIntField(currentChannel, "sq", (Integer) channelBackup.get("sq"));
                    XposedHelpers.setIntField(currentChannel, "band", (Integer) channelBackup.get("band"));
                    XposedHelpers.setIntField(currentChannel, "power", (Integer) channelBackup.get("power"));
                    XposedHelpers.setIntField(currentChannel, "rxType", (Integer) channelBackup.get("rxType"));
                    XposedHelpers.setIntField(currentChannel, "rxSubCode", (Integer) channelBackup.get("rxSubCode"));
                    XposedHelpers.setIntField(currentChannel, "txType", (Integer) channelBackup.get("txType"));
                    XposedHelpers.setIntField(currentChannel, "txSubCode", (Integer) channelBackup.get("txSubCode"));
                    
                    // Log AFTER field set
                    XposedBridge.log(TAG + ": AFTER setting fields - currentChannel:");
                    XposedBridge.log(TAG + ":   name: " + XposedHelpers.getObjectField(currentChannel, "name"));
                    XposedBridge.log(TAG + ":   rxFreq: " + XposedHelpers.getIntField(currentChannel, "rxFreq"));
                    XposedBridge.log(TAG + ":   txFreq: " + XposedHelpers.getIntField(currentChannel, "txFreq"));
                    XposedBridge.log(TAG + ":   type: " + XposedHelpers.getIntField(currentChannel, "type"));
                    XposedBridge.log(TAG + ":   number: " + XposedHelpers.getIntField(currentChannel, "number"));
                    
                    // Update hardware
                    XposedHelpers.callMethod(dmrManager, "updateChannel", currentChannel);
                    XposedHelpers.callMethod(dmrManager, "syncChannelInfoWithData", currentChannel);
                    
                    XposedBridge.log(TAG + ": ✅ Channel restored on startup: " + channelBackup.get("name"));
                    
                    // Show helpful message to user
                    if (context != null) {
                        new android.os.Handler(android.os.Looper.getMainLooper()).post(new Runnable() {
                            @Override
                            public void run() {
                                new AlertDialog.Builder(context)
                                    .setTitle("⚠️ APRS Channel Restored")
                                    .setMessage("APRS monitoring was interrupted while the app was closed.\n\n" +
                                               "Your channel has been restored automatically.\n\n" +
                                               "To prevent startup errors:\n" +
                                               "• Always stop APRS monitoring before closing the app\n\n" +
                                               "Please restart the app now.")
                                    .setPositiveButton("OK", null)
                                    .setCancelable(false)
                                    .show();
                            }
                        });
                    }
                    
                    channelBackup = null;
                } else {
                    XposedBridge.log(TAG + ": ⚠️ Could not load backup file, but will delete it");
                }
            } else {
                XposedBridge.log(TAG + ": Current channel looks normal - backup file will be deleted");
            }
            
        } catch (Exception e) {
            XposedBridge.log(TAG + ": ❌ Error checking/restoring APRS channel: " + e.getMessage());
            XposedBridge.log(e);
        } finally {
            // ALWAYS delete backup file after startup check
            if (shouldDeleteBackup) {
                try {
                    deleteChannelBackupFile();
                    XposedBridge.log(TAG + ": Backup file cleanup completed");
                } catch (Exception e) {
                    XposedBridge.log(TAG + ": Error deleting backup file: " + e.getMessage());
                }
            }
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
                                    
                                    // Query RSSI from radio
                                    queryRssi(lpparam.classLoader);
                                    
                                    if (currentChannelType == 0) {
                                        // Digital channel - query DMR caller info
                                        XposedBridge.log(TAG + ": Digital channel - querying caller info");
                                        queryCallerInfo(lpparam.classLoader);
                                        // Activity indicator will be updated in DigitalAudioMessageHandler with DMR ID
                                    } else {
                                        // Analog channel - show receiving message with tone (only if squelch is open)
                                        XposedBridge.log(TAG + ": Analog channel - checking squelch state");
                                        
                                        if (isSoftwareSquelchEnabled && !isSquelchOpen) {
                                            // Squelch is closed - show signal detected but muted
                                            String displayText = "📡 Signal (squelch)";
                                            if (currentRxToneType > 0) {
                                                String toneDisplay = ToneConverter.formatForDisplay(currentRxToneType, currentRxToneSubCode);
                                                displayText += "\n" + toneDisplay;
                                            }
                                            updateCallerDisplay(displayText);
                                            XposedBridge.log(TAG + ": Signal detected but squelch closed");
                                        } else {
                                            // Squelch is open or disabled - show receiving
                                            String displayText = "📻 Receiving...";
                                            if (currentRxToneType > 0) {  // 0 = None, 1 = CTCSS, 2 = FDCS, 3 = BDCS
                                                String toneDisplay = ToneConverter.formatForDisplay(currentRxToneType, currentRxToneSubCode);
                                                displayText += "\n" + toneDisplay;
                                            }
                                            updateCallerDisplay(displayText);
                                            XposedBridge.log(TAG + ": Displayed analog receiving message: " + displayText);
                                        }
                                    }
                                    break;
                                case 2:  // RECEIVE_STOP (used for both digital AND analog)
                                case 11: // MIX_CHECK_DIGITAL_RECEIVE_STOP
                                    XposedBridge.log(TAG + ": RECEIVE_STOP detected (type: " + currentChannelType + ")");
                                    isReceiving = false;
                                    previousSquelchOpen = false;  // Reset squelch state tracking
                                    
                                    // Process APRS buffer on receive stop ONLY if not in APRS monitoring mode
                                    // (During APRS monitoring, timer-based processing handles everything)
                                    if (!isAPRSMonitoringActive && aprsAudioBuffer.size() > 0) {
                                        XposedBridge.log(TAG + ": Processing APRS buffer on RECEIVE_STOP (" + aprsAudioBuffer.size() + " samples)");
                                        processAPRSBuffer();
                                    }
                                    
                                    // Stop recording if currently recording
                                    if (isCurrentlyRecording) {
                                        stopRecording();
                                    }
                                    
                                    // Save caller info for transcription before clearing
                                    savedCallerDmrIdForTranscription = currentCallerDmrId;
                                    savedCallerNameForTranscription = currentCallerName;
                                    savedChannelTypeForTranscription = currentChannelType;
                                    
                                    // Process transcription if enabled (after transmission ends)
                                    if (isTranscriptionEnabled && appContext != null) {
                                        processTranscription(appContext);
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
                                    
                                    // Check squelch state before showing "Receiving..." (analog channels only)
                                    if (currentChannelType == 1 && isSoftwareSquelchEnabled && !isSquelchOpen) {
                                        // Squelch is closed - show signal detected but muted
                                        updateCallerDisplay("📡 Signal (squelch)\n" + toneDisplay);
                                        XposedBridge.log(TAG + ": Signal detected but squelch closed: " + toneDisplay);
                                    } else {
                                        // Squelch is open or disabled - show receiving
                                        updateCallerDisplay("📻 Receiving...\n" + toneDisplay);
                                        XposedBridge.log(TAG + ": Displayed analog receiving message with tone: " + toneDisplay);
                                    }
                                    break;
                                    
                                case 13: // MIX_CHECK_ANALOG_RECEIVE_STOP
                                    XposedBridge.log(TAG + ": ANALOG_RECEIVE_STOP detected (type: " + currentChannelType + ")");
                                    isReceiving = false;
                                    previousSquelchOpen = false;  // Reset squelch state tracking
                                    
                                    // Process APRS buffer on receive stop (packets are often shorter than 2 seconds)
                                    if (aprsAudioBuffer.size() > 0) {
                                        XposedBridge.log(TAG + ": Processing APRS buffer on ANALOG_RECEIVE_STOP (" + aprsAudioBuffer.size() + " samples)");
                                        processAPRSBuffer();
                                    }
                                    
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
                    protected void beforeHookedMethod(MethodHookParam param) throws Throwable {
                        try {
                            Object message = param.args[0];
                            
                            // Get the packet to extract and MODIFY body data
                            Object packet = XposedHelpers.getObjectField(message, "packet");
                            byte[] body = (byte[]) XposedHelpers.getObjectField(packet, "body");
                            
                            if (body != null && body.length >= 9) {
                                // ===== V2.0.0 FIX: Override hardware's incorrect callType =====
                                // Hardware bug: Always reports callType=0 (PRIVATE) for all calls
                                // Solution: Override byte 0 based on current contactType setting
                                
                                try {
                                    // Get DmrManager instance to read current contactType
                                    Class<?> dmrManagerClass = XposedHelpers.findClass(
                                        "com.pri.prizeinterphone.manager.DmrManager",
                                        lpparam.classLoader
                                    );
                                    Object dmrManager = XposedHelpers.callStaticMethod(dmrManagerClass, "getInstance");
                                    Object currentChannel = XposedHelpers.callMethod(dmrManager, "getCurrentChannel");
                                    
                                    if (currentChannel != null) {
                                        int contactType = (Integer) XposedHelpers.callMethod(currentChannel, "getContactType");
                                        byte originalCallType = body[0];
                                        
                                        // FIXED 2026-03-09: Only override when MON button is explicitly ON
                                        // Previously overrode callType even in normal mode, breaking audio
                                        // Now: Only force callType=2 when contactType=2 (MON ON/ALL mode)
                                        // Otherwise: Let hardware's original callType pass through unmodified
                                        if (contactType == 2) {
                                            // MON button ON - accept all calls
                                            body[0] = 2;
                                            XposedBridge.log(TAG + ": CALL TYPE OVERRIDE - MON ON (contactType=2) | Changed callType " + originalCallType + " to 2 (ALL)");
                                        } else {
                                            // Normal mode - don't interfere with hardware's callType
                                            XposedBridge.log(TAG + ": CALL TYPE PASSTHROUGH - contactType=" + contactType + " | Keeping hardware callType=" + originalCallType);
                                        }
                                    }
                                } catch (Exception e) {
                                    XposedBridge.log(TAG + ": Failed to override call type: " + e.getMessage());
                                }
                            }
                        } catch (Exception e) {
                            XposedBridge.log(TAG + ": Error in DigitalAudioMessageHandler beforeHook: " + e.getMessage());
                        }
                    }
                    
                    @Override
                    protected void afterHookedMethod(MethodHookParam param) throws Throwable {
                        try {
                            Object message = param.args[0];
                            
                            // Get the packet to extract body data (now modified)
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
     * Query RSSI (signal strength) from radio
     */
    private void queryRssi(ClassLoader classLoader) {
        try {
            Class<?> signalMessageClass = XposedHelpers.findClass(
                "com.pri.prizeinterphone.message.SignalMessage",
                classLoader
            );
            
            // Create SignalMessage with fetch=1 to request signal strength
            Object signalMessage = XposedHelpers.newInstance(signalMessageClass);
            XposedHelpers.setByteField(signalMessage, "fetch", (byte) 1);
            XposedHelpers.callMethod(signalMessage, "send");
            
            XposedBridge.log(TAG + ": Sent QUERY_SIGNAL_STRENGTH_CMD");
            
        } catch (Exception e) {
            XposedBridge.log(TAG + ": Error sending RSSI query: " + e.getMessage());
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
                saveChannelHistoryEntry(currentChannelNumber, dmrIdStr, timestamp, activityType, currentRssi, appContext);
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
                        "rssi_dbm INTEGER, " +
                        "transcription TEXT, " +
                        "created_at INTEGER)");
                    
                    // Add rssi_dbm column if it doesn't exist (for existing databases)
                    try {
                        db.execSQL("ALTER TABLE channel_history ADD COLUMN rssi_dbm INTEGER");
                    } catch (Exception e) {
                        // Column already exists, ignore
                    }
                    
                    // Add transcription column if it doesn't exist (for existing databases)
                    try {
                        db.execSQL("ALTER TABLE channel_history ADD COLUMN transcription TEXT");
                    } catch (Exception e) {
                        // Column already exists, ignore
                    }
                    
                    // Load last 3 entries for this channel
                    cursor = db.rawQuery(
                        "SELECT dmr_id, timestamp, activity_type, rssi_dbm FROM channel_history " +
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
                        Integer rssiDbm = cursor.isNull(3) ? null : cursor.getInt(3);
                        
                        // Format entry based on whether it has a DMR ID or not (Analog channels use "N/A")
                        String entry;
                        String rssiStr = (rssiDbm != null && rssiDbm != -999) ? " " + rssiDbm + " dBm" : "";
                        
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
                            entry = displayName + " " + timestamp + " " + activityType + rssiStr;
                        } else {
                            entry = timestamp + " " + activityType + rssiStr;  // Analog format (no ID)
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
    private void saveChannelHistoryEntry(final int channelNumber, final String dmrId, final String timestamp, final String activityType, final int rssiDbm, final android.content.Context context) {
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
                        "rssi_dbm INTEGER, " +
                        "transcription TEXT, " +
                        "created_at INTEGER)");
                    
                    // Add rssi_dbm column if it doesn't exist (for existing databases)
                    try {
                        db.execSQL("ALTER TABLE channel_history ADD COLUMN rssi_dbm INTEGER");
                    } catch (Exception e) {
                        // Column already exists, ignore
                    }
                    
                    // Add transcription column if it doesn't exist (for existing databases)
                    try {
                        db.execSQL("ALTER TABLE channel_history ADD COLUMN transcription TEXT");
                    } catch (Exception e) {
                        // Column already exists, ignore
                    }
                    
                    // Insert new entry
                    android.content.ContentValues values = new android.content.ContentValues();
                    values.put("channel_number", channelNumber);
                    values.put("dmr_id", dmrId);
                    values.put("timestamp", timestamp);
                    values.put("activity_type", activityType);
                    values.put("rssi_dbm", rssiDbm);
                    values.put("created_at", System.currentTimeMillis());
                    
                    db.insert("channel_history", null, values);
                    
                    // Keep only last 100 entries per channel to prevent unlimited growth
                    db.execSQL("DELETE FROM channel_history WHERE channel_number = ? AND id NOT IN (" +
                        "SELECT id FROM channel_history WHERE channel_number = ? ORDER BY created_at DESC LIMIT 100)",
                        new Object[]{channelNumber, channelNumber});
                    
                    String rssiStr = (rssiDbm != -999) ? " " + rssiDbm + " dBm" : "";
                    XposedBridge.log(TAG + ": Saved history entry for channel " + channelNumber + ": " + dmrId + " " + timestamp + " " + activityType + rssiStr);
                    
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
            
            // Create channel-specific folder in Audio
            java.io.File downloadDir = android.os.Environment.getExternalStoragePublicDirectory(android.os.Environment.DIRECTORY_DOWNLOADS);
            java.io.File recordingsDir = new java.io.File(downloadDir, "DMR/Audio/" + channelFolderName);
            
            if (!recordingsDir.exists()) {
                recordingsDir.mkdirs();
                XposedBridge.log(TAG + ": Created channel audio folder: " + recordingsDir.getAbsolutePath());
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
            
            // Save recording path for transcription callback before clearing
            lastRecordingPathForTranscription = currentRecordingPath;
            
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
            XposedBridge.log(TAG + ": Attempting to hook PCMReceiveManager...");
            
            Class<?> pcmManagerClass = XposedHelpers.findClass(
                "com.pri.prizeinterphone.manager.PCMReceiveManager",
                lpparam.classLoader
            );
            
            XposedBridge.log(TAG + ": Found PCMReceiveManager class");
            
            // Hook the writeAudioTrack method which receives all PCM audio data
            XposedHelpers.findAndHookMethod(
                pcmManagerClass,
                "writeAudioTrack",
                byte[].class,  // PCM data
                int.class,      // data length
                new XC_MethodHook() {
                    @Override
                    protected void beforeHookedMethod(MethodHookParam param) throws Throwable {
                        byte[] audioData = (byte[]) param.args[0];
                        int length = (int) param.args[1];
                        
                        // Make a copy BEFORE any squelch muting for APRS/transcription/recording
                        // This ensures those features get clean audio regardless of squelch state
                        byte[] originalAudio = null;
                        if (isAPRSMonitoringActive || isTranscriptionEnabled || 
                            (isRecordingEnabled && isCurrentlyRecording)) {
                            originalAudio = java.util.Arrays.copyOf(audioData, length);
                        }
                        
                        // === SOFTWARE SQUELCH (Hybrid RSSI + Audio RMS) ===
                        // Note: Squelch level 0 = disabled (pass all audio), 1-9 = enabled with increasing sensitivity
                        if (isSoftwareSquelchEnabled && (currentChannelType == 1 || isAPRSMonitoringActive) && softwareSquelchThreshold > 0) {  // Skip software squelch if level 0
                            // Calculate audio amplitude (optimized RMS with peak detection)
                            int amplitude = calculateAudioAmplitude(audioData, length);
                            
                            // Get thresholds with hysteresis
                            int audioThreshold = getAudioSquelchThreshold();
                            int audioOpenThresh = audioThreshold;
                            int audioCloseThresh = (audioThreshold * 100) / HYSTERESIS_FACTOR;  // Lower threshold to close
                            
                            // RSSI-based gating (if available)
                            boolean rssiPass = true;
                            if (currentRssi != -999) {
                                int rssiThreshold = getRssiThreshold(softwareSquelchThreshold);
                                rssiPass = (currentRssi >= rssiThreshold);
                                
                                // Periodic RSSI query (every 500ms)
                                long now = System.currentTimeMillis();
                                if (now - lastRssiQueryTime > RSSI_QUERY_INTERVAL_MS) {
                                    querySignalStrength();
                                }
                            }
                            
                            // Hybrid decision: RSSI gates coarsely, audio RMS fine-tunes
                            boolean shouldOpen = rssiPass && (amplitude >= audioOpenThresh);
                            boolean shouldClose = !rssiPass || (amplitude < audioCloseThresh);
                            
                            // Apply hysteresis
                            if (isSquelchOpen) {
                                if (shouldClose) {
                                    isSquelchOpen = false;
                                }
                            } else {
                                if (shouldOpen) {
                                    isSquelchOpen = true;
                                }
                            }
                            
                            // Apply hang time (hold squelch open for 300ms after signal drops)
                            if (isSquelchOpen) {
                                lastSquelchOpenTime = System.currentTimeMillis();
                            } else if (System.currentTimeMillis() - lastSquelchOpenTime < SQUELCH_HANG_TIME_MS) {
                                isSquelchOpen = true;  // Force open during hang period
                            }
                            
                            // Mute audio if squelch is closed
                            if (!isSquelchOpen) {
                                java.util.Arrays.fill(audioData, 0, length, (byte) 0);
                            }
                            
                            // Update caller display if squelch state changed during reception
                            if (isReceiving && currentChannelType == 1 && isSquelchOpen != previousSquelchOpen) {
                                previousSquelchOpen = isSquelchOpen;
                                
                                // Update display based on new squelch state
                                String toneDisplay = ToneConverter.formatForDisplay(currentRxToneType, currentRxToneSubCode);
                                if (isSquelchOpen) {
                                    // Squelch just opened - show "Receiving..."
                                    String displayText = "📻 Receiving...";
                                    if (currentRxToneType > 0) {
                                        displayText += "\n" + toneDisplay;
                                    }
                                    updateCallerDisplay(displayText);
                                    XposedBridge.log(TAG + ": Squelch OPENED - now showing Receiving");
                                } else {
                                    // Squelch just closed - show "Signal (squelch)"
                                    String displayText = "📡 Signal (squelch)";
                                    if (currentRxToneType > 0) {
                                        displayText += "\n" + toneDisplay;
                                    }
                                    updateCallerDisplay(displayText);
                                    XposedBridge.log(TAG + ": Squelch CLOSED - now showing Signal (squelch)");
                                }
                            }
                            
                            // Update UI indicator (throttled)
                            if (System.currentTimeMillis() % 200 < 50) {  // Update ~5 times per second
                                updateSquelchStatus(isSquelchOpen);
                            }
                            
                            // Debug logging (throttled to avoid spam)
                            if (System.currentTimeMillis() % 1000 < 50) {  // Log once per second
                                XposedBridge.log(TAG + ": Squelch - RMS=" + amplitude + 
                                    ", Thresh=" + audioThreshold + ", RSSI=" + currentRssi + 
                                    ", Open=" + isSquelchOpen);
                            }
                        }
                        
                        // === END SOFTWARE SQUELCH ===
                        
                        // Use originalAudio for features that need clean audio
                        byte[] processingAudio = (originalAudio != null) ? originalAudio : audioData;
                        
                        // Buffer audio for APRS decoding (only if monitoring is active)
                        if (isAPRSMonitoringActive) {
                            bufferAudioForAPRS(processingAudio, length);
                        }
                        
                        // Buffer audio for transcription if enabled
                        if (isTranscriptionEnabled) {
                            bufferAudioForTranscription(processingAudio);
                        }
                        
                        // Only capture if recording is enabled and currently recording
                        if (isRecordingEnabled && isCurrentlyRecording && pcmOutputStream != null) {
                            try {
                                // Write PCM data to file (original unmuted audio)
                                pcmOutputStream.write(processingAudio, 0, length);
                                pcmDataSize += length;
                                
                            } catch (Exception e) {
                                XposedBridge.log(TAG + ": Error writing PCM data: " + e.getMessage());
                            }
                        }
                    }
                }
            );
            
            XposedBridge.log(TAG + ": ✓ Successfully hooked PCMReceiveManager.writeAudioTrack");
            
        } catch (Throwable t) {
            XposedBridge.log(TAG + ": ✗ Failed to hook PCMReceiveManager: " + t.getMessage());
            t.printStackTrace();
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
                        ((View) rssiDisplayTextView.getParent()).setVisibility(View.INVISIBLE);
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
                    ((View) rssiDisplayTextView.getParent()).setVisibility(View.INVISIBLE);
                }
            });
            
            // Reset RSSI value
            currentRssi = -999;
            
        } catch (Exception e) {
            XposedBridge.log(TAG + ": Error hiding RSSI display: " + e.getMessage());
        }
    }
    
    /**
     * Calculate audio amplitude using optimized RMS with peak detection
     * Optimized version: subsamples every 4th sample for speed, uses hybrid RMS+peak
     * 
     * @param pcmData PCM audio data (16-bit signed, little endian)
     * @param length Length of data in bytes
     * @return Amplitude value (hybrid of RMS and peak)
     */
    private static int calculateAudioAmplitude(byte[] pcmData, int length) {
        if (length < 2 || length % 2 != 0) return 0;

        long sumSquares = 0;
        int maxAbs = 0;
        int sampleCount = 0;

        // Process every 4th sample (4× faster, still accurate for squelch)
        // For 8kHz audio, this still gives 2000 samples/sec which is plenty
        for (int i = 0; i < length - 1; i += 4) {
            // Combine 2 bytes into 16-bit signed sample (Little Endian)
            short sample = (short) ((pcmData[i] & 0xFF) | (pcmData[i + 1] << 8));
            int abs = Math.abs(sample);
            if (abs > maxAbs) maxAbs = abs;
            sumSquares += (long) sample * sample;
            sampleCount++;
        }

        if (sampleCount == 0) return 0;

        // RMS (root mean square) - most reliable for squelch
        double rms = Math.sqrt((double) sumSquares / sampleCount);
        
        // Hybrid: use higher of RMS or scaled peak (helps with bursty signals)
        int hybrid = (int) Math.max(rms, maxAbs * 0.7);

        return hybrid;
    }
    
    /**
     * Get audio RMS threshold for software squelch based on user squelch level (0-9)
     * 
     * @return Audio amplitude threshold
     */
    private static int getAudioSquelchThreshold() {
        int level = Math.max(0, Math.min(softwareSquelchThreshold, 9));  // Clamp to 0-9
        return AUDIO_SQUELCH_THRESHOLDS[level];
    }
    
    /**
     * Get RSSI threshold for software squelch based on user squelch level (0-9)
     * Maps squelch levels to dBm thresholds
     * 
     * @param squelchLevel User squelch setting (0-9)
     * @return RSSI threshold in dBm (negative values)
     */
    private static int getRssiThreshold(int squelchLevel) {
        // Map squelch levels 0-9 to RSSI thresholds (dBm)
        // 0 = most sensitive (always open, no squelch)
        // 9 = least sensitive (only very strong signals)
        //
        // Typical RSSI range: -120 dBm (very weak) to -50 dBm (very strong)
        // Good signal: -70 to -90 dBm
        // Marginal: -90 to -105 dBm
        // Poor: -105 to -120 dBm
        
        int[] thresholds = {
            -120,  // 0: Always open (accept all signals, even very weak)
            -110,  // 1: Very sensitive (accept weak signals)
            -100,  // 2: Default sensitive (was hardware default)
            -95,   // 3: Moderate-low
            -90,   // 4: Moderate (good balance)
            -85,   // 5: Moderate-high
            -80,   // 6: Strong signals only
            -75,   // 7: Very strong signals
            -70,   // 8: Excellent signals only
            -65    // 9: Only exceptionally strong signals
        };
        
        int level = Math.max(0, Math.min(squelchLevel, 9));  // Clamp to 0-9
        return thresholds[level];
    }
    
    /**
     * Query signal strength from the radio
     * Sends a SignalMessage to request RSSI update
     */
    private static void querySignalStrength() {
        if (appClassLoader == null) {
            return;
        }
        
        try {
            Class<?> signalMsgClass = XposedHelpers.findClass(
                "com.pri.prizeinterphone.message.SignalMessage",
                appClassLoader
            );
            
            // Create new SignalMessage with fetch=1 (query signal strength)
            Object signalMsg = signalMsgClass.newInstance();
            XposedHelpers.setByteField(signalMsg, "fetch", (byte) 1);
            
            // Send the message to radio
            XposedHelpers.callMethod(signalMsg, "send");
            
            lastRssiQueryTime = System.currentTimeMillis();
            
        } catch (Throwable t) {
            XposedBridge.log(TAG + ": Error querying signal strength: " + t.getMessage());
        }
    }
    
    /**
     * Update squelch status indicator in UI
     * 
     * @param open True if squelch is open (signal passing), false if closed (muted)
     */
    private static void updateSquelchStatus(final boolean open) {
        if (squelchStatusIndicator == null) {
            return;
        }
        
        isSquelchOpen = open;
        
        try {
            squelchStatusIndicator.post(new Runnable() {
                @Override
                public void run() {
                    if (open) {
                        squelchStatusIndicator.setText("⬤ OPEN");
                        squelchStatusIndicator.setTextColor(0xFF00FF00);  // Green
                    } else {
                        squelchStatusIndicator.setText("⬤ CLOSED");
                        squelchStatusIndicator.setTextColor(0xFFFF0000);  // Red
                    }
                    squelchStatusIndicator.setVisibility(View.VISIBLE);
                }
            });
        } catch (Exception e) {
            XposedBridge.log(TAG + ": Error updating squelch status: " + e.getMessage());
        }
    }
    
    /**
     * Enable software squelch by setting hardware squelch to 0 (fully open)
     * Must be called on current channel after enabling software squelch
     */
    private static void enableSoftwareSquelchOnCurrentChannel() {
        if (appClassLoader == null) {
            XposedBridge.log(TAG + ": Cannot enable software squelch - appClassLoader is null");
            return;
        }
        
        try {
            // Get DmrManager and current channel
            Class<?> dmrManagerClass = XposedHelpers.findClass(
                "com.pri.prizeinterphone.manager.DmrManager",
                appClassLoader
            );
            Object dmrManager = XposedHelpers.callStaticMethod(dmrManagerClass, "getInstance");
            Object currentChannel = XposedHelpers.callMethod(dmrManager, "getCurrentChannel");
            
            if (currentChannel == null) {
                XposedBridge.log(TAG + ": Cannot set squelch - no current channel");
                return;
            }
            
            // Only set hardware squelch to 0 for analog channels
            int channelType = XposedHelpers.getIntField(currentChannel, "type");
            if (channelType != 1) {  // Not analog
                XposedBridge.log(TAG + ": Software squelch only applies to analog channels");
                return;
            }
            
            // Create AnalogMessage with squelch = 0
            Class<?> analogMessageClass = XposedHelpers.findClass(
                "com.pri.prizeinterphone.message.AnalogMessage",
                appClassLoader
            );
            Object analogMessage = analogMessageClass.newInstance();
            
            // Copy all channel fields
            XposedHelpers.callMethod(analogMessage, "setBand", 
                (byte) XposedHelpers.getIntField(currentChannel, "band"));
            XposedHelpers.callMethod(analogMessage, "setPower", 
                (byte) XposedHelpers.getIntField(currentChannel, "power"));
            XposedHelpers.callMethod(analogMessage, "setTxFreq", 
                XposedHelpers.getIntField(currentChannel, "txFreq"));
            XposedHelpers.callMethod(analogMessage, "setRxFreq", 
                XposedHelpers.getIntField(currentChannel, "rxFreq"));
            XposedHelpers.callMethod(analogMessage, "setSq", (byte) 0);  // Hardware squelch = 0 (same as MON button)
            XposedHelpers.callMethod(analogMessage, "setRxType", 
                (byte) XposedHelpers.getIntField(currentChannel, "rxType"));
            XposedHelpers.callMethod(analogMessage, "setRxSubCode", 
                (byte) XposedHelpers.getIntField(currentChannel, "rxSubCode"));
            XposedHelpers.callMethod(analogMessage, "setTxType", 
                (byte) XposedHelpers.getIntField(currentChannel, "txType"));
            XposedHelpers.callMethod(analogMessage, "setTxSubCode", 
                (byte) XposedHelpers.getIntField(currentChannel, "txSubCode"));
            XposedHelpers.callMethod(analogMessage, "setRelay", 
                (byte) XposedHelpers.getIntField(currentChannel, "relay"));
            
            // Send to hardware
            XposedHelpers.callMethod(analogMessage, "send");
            
            XposedBridge.log(TAG + ": ✓ Software squelch enabled - hardware sq set to 0 (same as MON button)");
            
        } catch (Throwable t) {
            XposedBridge.log(TAG + ": ✗ Error enabling software squelch: " + t.getMessage());
            t.printStackTrace();
        }
    }
    
    /**
     * Disable software squelch and restore hardware squelch to saved level
     */
    private static void disableSoftwareSquelchOnCurrentChannel() {
        if (appClassLoader == null) {
            return;
        }
        
        try {
            // Get DmrManager and current channel
            Class<?> dmrManagerClass = XposedHelpers.findClass(
                "com.pri.prizeinterphone.manager.DmrManager",
                appClassLoader
            );
            Object dmrManager = XposedHelpers.callStaticMethod(dmrManagerClass, "getInstance");
            Object currentChannel = XposedHelpers.callMethod(dmrManager, "getCurrentChannel");
            
            if (currentChannel == null) {
                return;
            }
            
            // Only for analog channels
            int channelType = XposedHelpers.getIntField(currentChannel, "type");
            if (channelType != 1) {
                return;
            }
            
            // Create AnalogMessage with software squelch threshold (not hardware sq=2)
            Class<?> analogMessageClass = XposedHelpers.findClass(
                "com.pri.prizeinterphone.message.AnalogMessage",
                appClassLoader
            );
            Object analogMessage = analogMessageClass.newInstance();
            
            // Copy all channel fields but use software squelch threshold instead of hardware
            XposedHelpers.callMethod(analogMessage, "setBand", 
                (byte) XposedHelpers.getIntField(currentChannel, "band"));
            XposedHelpers.callMethod(analogMessage, "setPower", 
                (byte) XposedHelpers.getIntField(currentChannel, "power"));
            XposedHelpers.callMethod(analogMessage, "setTxFreq", 
                XposedHelpers.getIntField(currentChannel, "txFreq"));
            XposedHelpers.callMethod(analogMessage, "setRxFreq", 
                XposedHelpers.getIntField(currentChannel, "rxFreq"));
            XposedHelpers.callMethod(analogMessage, "setSq", 
                (byte) 2);  // Set to hardware squelch 2
            XposedHelpers.callMethod(analogMessage, "setRxType", 
                (byte) XposedHelpers.getIntField(currentChannel, "rxType"));
            XposedHelpers.callMethod(analogMessage, "setRxSubCode", 
                (byte) XposedHelpers.getIntField(currentChannel, "rxSubCode"));
            XposedHelpers.callMethod(analogMessage, "setTxType", 
                (byte) XposedHelpers.getIntField(currentChannel, "txType"));
            XposedHelpers.callMethod(analogMessage, "setTxSubCode", 
                (byte) XposedHelpers.getIntField(currentChannel, "txSubCode"));
            XposedHelpers.callMethod(analogMessage, "setRelay", 
                (byte) XposedHelpers.getIntField(currentChannel, "relay"));
            
            // Send to hardware
            XposedHelpers.callMethod(analogMessage, "send");
            
            XposedBridge.log(TAG + ": ✓ Software squelch disabled - hardware sq set to 2");
            
        } catch (Throwable t) {
            XposedBridge.log(TAG + ": ✗ Error disabling software squelch: " + t.getMessage());
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
                            // Get the Packet parameter (first argument to decode())
                            Object packet = param.args[0];
                            
                            if (packet != null) {
                                // Get body byte array directly from Packet
                                byte[] body = (byte[]) XposedHelpers.getObjectField(packet, "body");
                                
                                if (body != null && body.length > 0) {
                                    // First byte of body is the RSSI value
                                    byte rssi = body[0];
                                    // Convert to unsigned byte value (0-255) then to negative dBm
                                    int rssiUnsigned = rssi & 0xFF;
                                    // RSSI values from radio: higher value = stronger signal
                                    // Convert to negative dBm: typical range -120 to -50 dBm
                                    currentRssi = rssiUnsigned > 0 ? -(120 - (rssiUnsigned / 2)) : -999;
                                    XposedBridge.log(TAG + ": Captured RSSI from packet body: raw=" + rssiUnsigned + ", dBm=" + currentRssi);
                                    
                                    // Update display immediately when RSSI is captured
                                    if (rssiUnsigned > 0) {
                                        updateRssiDisplay();
                                    }
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
    
    /**
     * Hook DmrManager to debug RX group list configuration
     * This helps troubleshoot why group calls aren't being received
     */
    private void hookDmrManager(XC_LoadPackage.LoadPackageParam lpparam) {
        try {
            Class<?> dmrManagerClass = XposedHelpers.findClass(
                "com.pri.prizeinterphone.manager.DmrManager",
                lpparam.classLoader
            );
            
            Class<?> channelDataClass = XposedHelpers.findClass(
                "com.pri.prizeinterphone.serial.data.ChannelData",
                lpparam.classLoader
            );
            
            // Hook sendAnalogMessage to modify monitor field BEFORE encoding
            XposedHelpers.findAndHookMethod(
                dmrManagerClass,
                "sendAnalogMessage",
                channelDataClass,
                new XC_MethodHook() {
                    @Override
                    protected void afterHookedMethod(MethodHookParam param) throws Throwable {
                        try {
                            // The AnalogMessage was just created from ChannelData
                            // We need to modify it BEFORE send() is called
                            // Get the AnalogMessage that's about to be sent
                            Object channelData = param.args[0];
                            int sq = XposedHelpers.getIntField(channelData, "sq");
                            
                            XposedBridge.log(TAG + ": === sendAnalogMessage INTERCEPTED ===");
                            XposedBridge.log(TAG + ": ChannelData sq=" + sq);
                            
                            // The method creates an AnalogMessage and calls send()
                            // We can't easily intercept it here since it's local
                            // Will use the BaseMessage.send() hook instead, but earlier in the chain
                            
                        } catch (Exception e) {
                            XposedBridge.log(TAG + ": Error in sendAnalogMessage hook: " + e.getMessage());
                        }
                    }
                }
            );
            
            XposedBridge.log(TAG + ": Successfully hooked DmrManager.sendAnalogMessage");
            
            // Hook sendDigitalMessage to see what's being sent to hardware
            XposedHelpers.findAndHookMethod(
                dmrManagerClass,
                "sendDigitalMessage",
                channelDataClass,
                new XC_MethodHook() {
                    @Override
                    protected void beforeHookedMethod(MethodHookParam param) throws Throwable {
                        try {
                            Object channelData = param.args[0];
                            
                            // Get channel info
                            int channelId = (Integer) XposedHelpers.callMethod(channelData, "getId");
                            int contactType = (Integer) XposedHelpers.getObjectField(channelData, "contactType");
                            int txContact = (Integer) XposedHelpers.callMethod(channelData, "getTxContact");
                            
                            XposedBridge.log(TAG + ": === sendDigitalMessage DEBUG ===");
                            XposedBridge.log(TAG + ": BEFORE: contactType=" + contactType + ", txContact=" + txContact + ", isMonitoringMode=" + isMonitoringMode);
                            
                            // Force monitoring mode settings if enabled
                            if (isMonitoringMode) {
                                XposedBridge.log(TAG + ": FORCING ALL mode - setting contactType=2, txContact=16777215");
                                XposedHelpers.setObjectField(channelData, "contactType", 2);
                                XposedHelpers.callMethod(channelData, "setTxContact", 16777215);
                                
                                contactType = 2;
                                txContact = 16777215;
                            }
                            
                            XposedBridge.log(TAG + ": AFTER: contactType=" + contactType + ", txContact=" + txContact);
                            
                            int[] groups = (int[]) XposedHelpers.getObjectField(channelData, "groups");
                            if (contactType == 1 && groups != null) {
                                XposedBridge.log(TAG + ": ✓ Will send groupList to hardware (GROUP mode)");
                            } else if (contactType == 2) {
                                XposedBridge.log(TAG + ": ✓ ALL mode - hardware will receive ALL DMR traffic on this CC/TS");
                            }
                            
                        } catch (Exception e) {
                            XposedBridge.log(TAG + ": Error in sendDigitalMessage hook: " + e.getMessage());
                            e.printStackTrace();
                        }
                    }
                }
            );
            
            XposedBridge.log(TAG + ": Successfully hooked DmrManager.sendDigitalMessage");
            
            // Hook DigitalMessage.encodeBody() - this is where contactType is READ and serialized
            try {
                Class<?> digitalMessageClass = XposedHelpers.findClass(
                    "com.pri.prizeinterphone.message.DigitalMessage",
                    lpparam.classLoader
                );
                
                XposedHelpers.findAndHookMethod(
                    digitalMessageClass,
                    "encodeBody",
                    new XC_MethodHook() {
                        @Override
                        protected void beforeHookedMethod(MethodHookParam param) throws Throwable {
                            try {
                                Object digitalMessage = param.thisObject;
                                
                                // Get current values
                                byte contactType = (Byte) XposedHelpers.getObjectField(digitalMessage, "contactType");
                                int txContact = (Integer) XposedHelpers.getObjectField(digitalMessage, "txContact");
                                int rxFreq = (Integer) XposedHelpers.getObjectField(digitalMessage, "rxFreq");
                                int txFreq = (Integer) XposedHelpers.getObjectField(digitalMessage, "txFreq");
                                
                                XposedBridge.log(TAG + ": === encodeBody() BEFORE ===");
                                XposedBridge.log(TAG + ": rxFreq: " + rxFreq + ", txFreq: " + txFreq);
                                XposedBridge.log(TAG + ": contactType: " + contactType + ", txContact: " + txContact);
                                
                                // FINAL FORCING - right before serialization!
                                if (isMonitoringMode) {
                                    XposedBridge.log(TAG + ": 🔥🔥🔥 ULTIMATE FORCE in encodeBody()!");
                                    XposedHelpers.setObjectField(digitalMessage, "contactType", (byte) 2);
                                    XposedHelpers.setObjectField(digitalMessage, "txContact", 16777215);
                                    XposedBridge.log(TAG + ": ✅✅✅ Set contactType=2, txContact=16777215 RIGHT BEFORE SERIALIZATION");
                                }
                                
                            } catch (Exception e) {
                                XposedBridge.log(TAG + ": Error in encodeBody() beforeHook: " + e.getMessage());
                }
                        }
                        
                        @Override
                        protected void afterHookedMethod(MethodHookParam param) throws Throwable {
                            try {
                                // Get the encoded byte array result
                                byte[] encodedBytes = (byte[]) param.getResult();
                                if (encodedBytes != null && encodedBytes.length >= 145) {
                                    // Layout: rxFreq(4) + txFreq(4) + localId(4) + groupList(128) + txContact(4) + contactType(1)
                                    // txContact is at offset 140-143 (4 bytes, big endian)
                                    int txContactInBytes = ((encodedBytes[140] & 0xFF) << 24) |
                                                          ((encodedBytes[141] & 0xFF) << 16) |
                                                          ((encodedBytes[142] & 0xFF) << 8) |
                                                          (encodedBytes[143] & 0xFF);
                                    // contactType is at offset 144 (1 byte)
                                    byte contactTypeInBytes = encodedBytes[144];
                                    
                                    XposedBridge.log(TAG + ": === encodeBody() AFTER - ACTUAL BYTES ===");
                                    XposedBridge.log(TAG + ": txContact in packet bytes: " + txContactInBytes);
                                    XposedBridge.log(TAG + ": contactType in packet bytes: " + contactTypeInBytes);
                                    
                                    if (isMonitoringMode && contactTypeInBytes != 2) {
                                        XposedBridge.log(TAG + ": ❌❌❌ WARNING: Monitoring ON but contactType=" + contactTypeInBytes + " in bytes!");
                                    }
                                    if (isMonitoringMode && contactTypeInBytes == 2) {
                                        XposedBridge.log(TAG + ": ✅✅✅ SUCCESS: contactType=2 AND txContact=" + txContactInBytes + " confirmed in packet bytes!");
                                    }
                                }
                            } catch (Exception e) {
                                XposedBridge.log(TAG + ": Error in encodeBody() afterHook: " + e.getMessage());
                            }
                        }
                    }
                );
                
                XposedBridge.log(TAG + ": Successfully hooked DigitalMessage.encodeBody()");
                
            } catch (Throwable t) {
                XposedBridge.log(TAG + ": Failed to hook DigitalMessage.encodeBody(): " + t.getMessage());
            }
            
            // Hook AnalogMessage.encodeBody() - modify fields RIGHT BEFORE serialization
            try {
                Class<?> analogMessageClass = XposedHelpers.findClass(
                    "com.pri.prizeinterphone.message.AnalogMessage",
                    lpparam.classLoader
                );
                
                XposedHelpers.findAndHookMethod(
                    analogMessageClass,
                    "encodeBody",
                    new XC_MethodHook() {
                        @Override
                        protected void beforeHookedMethod(MethodHookParam param) throws Throwable {
                            try {
                                Object analogMessage = param.thisObject;
                                
                                // Get current values
                                byte sq = (Byte) XposedHelpers.getObjectField(analogMessage, "sq");
                                byte monitor = (Byte) XposedHelpers.getObjectField(analogMessage, "monitor");
                                
                                XposedBridge.log(TAG + ": === AnalogMessage.encodeBody() BEFORE ===");
                                XposedBridge.log(TAG + ": BEFORE - sq=" + sq + ", monitor=" + monitor);
                                
                                // Just log, don't modify monitor - sq=0 should be sufficient
                                XposedBridge.log(TAG + ": AnalogMessage.encodeBody() - sq=" + sq + ", monitor=" + monitor + " (letting hardware handle monitor)");
                                
                            } catch (Exception e) {
                                XposedBridge.log(TAG + ": Error in AnalogMessage.encodeBody() beforeHook: " + e.getMessage());
                            }
                        }
                    }
                );
                
                XposedBridge.log(TAG + ": Successfully hooked AnalogMessage.encodeBody()");
                
            } catch (Throwable t) {
                XposedBridge.log(TAG + ": Failed to hook AnalogMessage.encodeBody(): " + t.getMessage());
            }
            
            // Also hook BaseMessage.send() to see the actual packet being sent
            try {
                Class<?> baseMessageClass = XposedHelpers.findClass(
                    "com.pri.prizeinterphone.message.BaseMessage",
                    lpparam.classLoader
                );
                Class<?> digitalMessageClass = XposedHelpers.findClass(
                    "com.pri.prizeinterphone.message.DigitalMessage",
                    lpparam.classLoader
                );
                Class<?> analogMessageClass = XposedHelpers.findClass(
                    "com.pri.prizeinterphone.message.AnalogMessage",
                    lpparam.classLoader
                );
                
                XposedHelpers.findAndHookMethod(
                    baseMessageClass,
                    "send",
                    new XC_MethodHook() {
                        @Override
                        protected void beforeHookedMethod(MethodHookParam param) throws Throwable {
                            try {
                                Object baseMessage = param.thisObject;
                                
                                // Handle AnalogMessage - set monitor field when squelch is open
                                if (analogMessageClass.isInstance(baseMessage)) {
                                    Object analogMessage = baseMessage;
                                    
                                    byte sq = (Byte) XposedHelpers.getObjectField(analogMessage, "sq");
                                    byte monitor = (Byte) XposedHelpers.getObjectField(analogMessage, "monitor");
                                    
                                    XposedBridge.log(TAG + ": === AnalogMessage.send() ===");
                                    XposedBridge.log(TAG + ": BEFORE - sq=" + sq + ", monitor=" + monitor);
                                    
                                    // Log but don't modify - let sq=0 handle continuous monitoring
                                    XposedBridge.log(TAG + ": AnalogMessage.send() - sq=" + sq + ", monitor=" + monitor + " (not modifying monitor field)");
                                    
                                    XposedBridge.log(TAG + ": AFTER - sq=" + sq + ", monitor=" + monitor);
                                    return; // Skip DigitalMessage handling
                                }
                                
                                // Check if this is a DigitalMessage (not analog or other message types)
                                if (!digitalMessageClass.isInstance(baseMessage)) {
                                    return;
                                }
                                
                                Object digitalMessage = baseMessage;
                                
                                // Get all the fields from DigitalMessage
                                int localId = (Integer) XposedHelpers.getObjectField(digitalMessage, "localId");
                                byte contactType = (Byte) XposedHelpers.getObjectField(digitalMessage, "contactType");
                                int txContact = (Integer) XposedHelpers.getObjectField(digitalMessage, "txContact");
                                int[] groupList = (int[]) XposedHelpers.getObjectField(digitalMessage, "groupList");
                                
                                XposedBridge.log(TAG + ": === BaseMessage.send() BEFORE (DigitalMessage) ===");
                                XposedBridge.log(TAG + ": localId (DMR ID): " + localId);
                                XposedBridge.log(TAG + ": contactType: " + contactType);
                                XposedBridge.log(TAG + ": txContact: " + txContact);
                                
                                // CRITICAL FIX: Force ALL mode at the last possible point
                                if (isMonitoringMode) {
                                    XposedBridge.log(TAG + ": ⚡⚡⚡ FORCING ALL mode in BaseMessage.send() - FINAL POINT!");
                                    XposedHelpers.setObjectField(digitalMessage, "contactType", (byte) 2);
                                    XposedHelpers.setObjectField(digitalMessage, "txContact", 16777215);
                                    contactType = 2;
                                    txContact = 16777215;
                                    XposedBridge.log(TAG + ": ✓✓✓ FORCED: contactType=2, txContact=16777215");
                                }
                                
                                XposedBridge.log(TAG + ": === BaseMessage.send() AFTER (DigitalMessage) ===");
                                XposedBridge.log(TAG + ": contactType: " + contactType);
                                XposedBridge.log(TAG + ": txContact: " + txContact);
                                
                                if (groupList != null) {
                                    StringBuilder groupsStr = new StringBuilder("[");
                                    for (int i = 0; i < Math.min(groupList.length, 8); i++) {
                                        if (i > 0) groupsStr.append(", ");
                                        groupsStr.append(groupList[i]);
                                    }
                                    if (groupList.length > 8) groupsStr.append(", ...");
                                    groupsStr.append("]");
                                    XposedBridge.log(TAG + ": groupList in DigitalMessage: " + groupsStr.toString());
                                    
                                    // Check if groupList is actually being sent (not all zeros except maybe first)
                                    boolean hasValidGroups = false;
                                    for (int i = 0; i < Math.min(groupList.length, 4); i++) {
                                        if (groupList[i] > 1) {  // Ignore 0 and 1 (defaults)
                                            hasValidGroups = true;
                                            break;
                                        }
                                    }
                                    
                                    if (hasValidGroups) {
                                        XposedBridge.log(TAG + ": ✓ groupList contains valid TG IDs - SHOULD receive group calls!");
                                    } else {
                                        XposedBridge.log(TAG + ": ⚠️ groupList is default/empty - will NOT receive group calls!");
                                    }
                                } else {
                                    XposedBridge.log(TAG + ": ✗ groupList is NULL in DigitalMessage!");
                                }
                                
                                XposedBridge.log(TAG + ": Sending packet to DMR hardware...");
                                
                            } catch (Exception e) {
                                XposedBridge.log(TAG + ": Error in BaseMessage.send() hook: " + e.getMessage());
                            }
                        }
                    }
                );
                
                XposedBridge.log(TAG + ": Successfully hooked BaseMessage.send()");
                
            } catch (Throwable t) {
                XposedBridge.log(TAG + ": Failed to hook BaseMessage.send(): " + t.getMessage());
            }
            
            // Note: restartApp() calls System.exit() which kills the app
            // We can't reliably prevent it without causing crashes
            // The firmware is already loaded in RAM, so this is acceptable
            
        } catch (Throwable t) {
            XposedBridge.log(TAG + ": Failed to hook DmrManager: " + t.getMessage());
        }
    }
    
    /**
     * Bind to DMRTranscriptionService via IPC
     */
    private static void bindToTranscriptionService(final Context context) {
        if (isServiceBound && transcriptionService != null) {
            XposedBridge.log(TAG + ": Transcription service already bound");
            return;
        }
        
        try {
            XposedBridge.log(TAG + ": Binding to DMRTranscriptionService...");
            
            // Create service connection
            serviceConnection = new ServiceConnection() {
                @Override
                public void onServiceConnected(ComponentName name, IBinder service) {
                    XposedBridge.log(TAG + ": ✅ Connected to transcription service");
                    transcriptionService = ITranscriptionService.Stub.asInterface(service);
                    isServiceBound = true;
                    
                    // Check if service is ready
                    new Thread(new Runnable() {
                        @Override
                        public void run() {
                            try {
                                boolean ready = transcriptionService.isReady();
                                final String msg = ready ? "✅ Transcription ready!" : "Loading model...";
                                XposedBridge.log(TAG + ": Service ready: " + ready);
                                
                                new android.os.Handler(android.os.Looper.getMainLooper()).post(new Runnable() {
                                    @Override
                                    public void run() {
                                        Toast.makeText(context, msg, Toast.LENGTH_SHORT).show();
                                    }
                                });
                            } catch (Exception e) {
                                XposedBridge.log(TAG + ": Error checking service ready: " + e.getMessage());
                            }
                        }
                    }).start();
                }
                
                @Override
                public void onServiceDisconnected(ComponentName name) {
                    XposedBridge.log(TAG + ": ⚠️ Disconnected from transcription service");
                    transcriptionService = null;
                    isServiceBound = false;
                }
            };
            
            // Intent to bind to the service
            Intent serviceIntent = new Intent();
            serviceIntent.setComponent(new ComponentName(
                "com.macdmr.transcription",
                "com.macdmr.transcription.TranscriptionService"
            ));
            
            // Bind to service
            boolean bound = context.bindService(
                serviceIntent,
                serviceConnection,
                Context.BIND_AUTO_CREATE
            );
            
            if (bound) {
                XposedBridge.log(TAG + ": Service binding initiated");
            } else {
                XposedBridge.log(TAG + ": ❌ Failed to bind service - is DMRTranscriptionService installed?");
                new android.os.Handler(android.os.Looper.getMainLooper()).post(new Runnable() {
                    @Override
                    public void run() {
                        Toast.makeText(context, "❌ Install DMRTranscriptionService first!", Toast.LENGTH_LONG).show();
                    }
                });
            }
            
        } catch (Exception e) {
            XposedBridge.log(TAG + ": ❌ Error binding to transcription service: " + e.getMessage());
            e.printStackTrace();
        }
    }
    
    /**
     * Buffer audio data for transcription
     * Called from PCMReceiveManager hook during audio reception
     */
    private static void bufferAudioForTranscription(byte[] audioData) {
        if (!isTranscriptionEnabled) {
            return;
        }
        
        try {
            // Check buffer size limit (30 seconds at 16kHz = 480000 samples)
            if (audioBuffer.size() >= MAX_BUFFER_SIZE) {
                XposedBridge.log(TAG + ": Audio buffer full, not buffering more");
                return;
            }
            
            // Convert bytes to shorts (16-bit PCM Little Endian)
            for (int i = 0; i < audioData.length - 1; i += 2) {
                short sample = (short) ((audioData[i + 1] << 8) | (audioData[i] & 0xFF));
                audioBuffer.add(sample);
            }
            
            // Log progress every 5 seconds
            if (audioBuffer.size() % 80000 == 0) {
                XposedBridge.log(TAG + ": Buffered " + audioBuffer.size() + " audio samples for transcription");
            }
            
        } catch (Exception e) {
            XposedBridge.log(TAG + ": Error buffering audio: " + e.getMessage());
        }
    }
    
    /**
     * Buffer audio data for APRS decoding
     * Called from PCMReceiveManager hook during audio reception
     */
    private static void bufferAudioForAPRS(byte[] audioData, int length) {
        try {
            XposedBridge.log(TAG + ": bufferAudioForAPRS called - " + length + " bytes");
            
            // Always buffer audio, even if no UI context (for autonomous operation)
            // Context is only needed later for displaying results
            
            XposedBridge.log(TAG + ": Buffering APRS audio, current buffer size: " + aprsAudioBuffer.size());
            
            // Convert bytes to shorts (16-bit PCM Little Endian)
            for (int i = 0; i < length - 1; i += 2) {
                short sample = (short) ((audioData[i + 1] << 8) | (audioData[i] & 0xFF));
                aprsAudioBuffer.add(sample);
            }
            
            // Process when buffer reaches 2 seconds (32000 samples at 16kHz)
            if (aprsAudioBuffer.size() >= APRS_BUFFER_SIZE) {
                processAPRSBuffer();
            }
            
        } catch (Exception e) {
            XposedBridge.log(TAG + ": Error buffering APRS audio: " + e.getMessage());
        }
    }
    
    /**
     * Process buffered audio for APRS decoding
     */
    private static void processAPRSBuffer() {
        if (aprsAudioBuffer.isEmpty()) {
            return;
        }
        
        // Allow processing even without UI context (for autonomous operation)
        // Context is only needed for displaying results in UI
        
        try {
            XposedBridge.log(TAG + ": Processing APRS buffer (" + aprsAudioBuffer.size() + " samples)");
            
            // Convert List<Short> to short array
            short[] audioSamples = new short[aprsAudioBuffer.size()];
            for (int i = 0; i < audioSamples.length; i++) {
                audioSamples[i] = aprsAudioBuffer.get(i);
            }
            
            // ★ RESAMPLE 16kHz → 48kHz (DMR radio audio is 16kHz, APRS decoder expects 48kHz)
            short[] resampled = resample16to48(audioSamples);
            XposedBridge.log(TAG + ": Resampled audio from " + audioSamples.length + " to " + resampled.length + " samples");
            
            // Get current channel (use currentChannelNumber if available)
            int channelNumber = currentChannelNumber > 0 ? currentChannelNumber : 0;
            
            // Process audio in background thread
            final short[] samples = resampled;
            final int channel = channelNumber;
            new Thread(new Runnable() {
                @Override
                public void run() {
                    try {
                        // Try to get context if available, otherwise just decode and log
                        Context context = null;
                        if (mLocalViewObject instanceof View) {
                            context = ((View) mLocalViewObject).getContext();
                        }
                        
                        if (context != null) {
                            APRSReceiver receiver = APRSReceiver.getInstance(context);
                            XposedBridge.log(TAG + ": Calling APRSReceiver.processAudio()");
                            receiver.processAudio(samples, channel);
                        } else {
                            // No context - just decode and log results
                            XposedBridge.log(TAG + ": No context available - decoding without UI display");
                            AFSKDecoder.decode(samples);  // This will log results
                        }
                    } catch (Exception e) {
                        XposedBridge.log(TAG + ": Error processing APRS audio: " + e.getMessage());
                        e.printStackTrace();
                    }
                }
            }).start();
            
            // Keep last 0.5 seconds for overlap (8000 samples at 16kHz)
            int keepSamples = 8000;
            if (aprsAudioBuffer.size() > keepSamples) {
                List<Short> newBuffer = new ArrayList<>(aprsAudioBuffer.subList(
                        aprsAudioBuffer.size() - keepSamples, aprsAudioBuffer.size()));
                aprsAudioBuffer.clear();
                aprsAudioBuffer.addAll(newBuffer);
            }
            
        } catch (Exception e) {
            XposedBridge.log(TAG + ": Error processing APRS buffer: " + e.getMessage());
            e.printStackTrace();
        }
    }
    
    /**
     * Resample audio from 16 kHz to 48 kHz using linear interpolation
     * DMR radio sends 16 kHz audio, but APRS decoder expects 48 kHz
     */
    private static short[] resample16to48(short[] input) {
        // 48kHz / 16kHz = 3x samples
        int outputLength = input.length * 3;
        short[] output = new short[outputLength];
        
        for (int i = 0; i < input.length - 1; i++) {
            // Original sample at position i*3
            output[i * 3] = input[i];
            
            // Interpolate 2 samples between input[i] and input[i+1]
            int sample1 = input[i];
            int sample2 = input[i + 1];
            
            output[i * 3 + 1] = (short) ((2 * sample1 + sample2) / 3);
            output[i * 3 + 2] = (short) ((sample1 + 2 * sample2) / 3);
        }
        
        // Last sample
        output[outputLength - 3] = input[input.length - 1];
        output[outputLength - 2] = input[input.length - 1];
        output[outputLength - 1] = input[input.length - 1];
        
        return output;
    }
    
    /**
     * Process transcription using TensorFlow Lite
     * Called when transmission ends (RECEIVE_STOP)
     */
    /**
     * Process audio transcription using IPC to DMRTranscriptionService
     */
    private static void processTranscription(Context context) {
        if (!isTranscriptionEnabled || audioBuffer.isEmpty()) {
            return;
        }
        
        XposedBridge.log(TAG + ": Processing transcription for " + audioBuffer.size() + " audio samples");
        
        if (!isServiceBound || transcriptionService == null) {
            XposedBridge.log(TAG + ": Transcription service not bound yet");
            currentTranscription = "[Service not ready - please wait...]";
            updateTranscriptionDisplay(currentTranscription);
            audioBuffer.clear();
            
            // Try to bind
            bindToTranscriptionService(context);
            return;
        }
        
        // Process in background thread to avoid blocking
        new Thread(new Runnable() {
            @Override
            public void run() {
                try {
                    // Convert List<Short> to byte array (16-bit PCM Little Endian)
                    // Cache size to prevent race condition (audioBuffer grows during iteration)
                    int bufferSize = audioBuffer.size();
                    byte[] pcmBytes = new byte[bufferSize * 2];
                    for (int i = 0; i < bufferSize; i++) {
                        short sample = audioBuffer.get(i);
                        pcmBytes[i * 2] = (byte) (sample & 0xFF);          // Low byte
                        pcmBytes[i * 2 + 1] = (byte) ((sample >> 8) & 0xFF); // High byte
                    }
                    
                    XposedBridge.log(TAG + ": Sending " + pcmBytes.length + " bytes to transcription service");
                    
                    // Call service via IPC
                    String result = transcriptionService.transcribe(pcmBytes, 16000);
                    
                    if (result != null && !result.trim().isEmpty()) {
                        currentTranscription = result;
                        XposedBridge.log(TAG + ": ✅ Transcription: " + result);
                    } else {
                        currentTranscription = "[No speech detected]";
                        XposedBridge.log(TAG + ": No speech detected in audio");
                    }
                    
                    // Format display message with DMR ID or contact name (digital only)
                    // Use saved caller info since currentCallerDmrId is cleared after RECEIVE_STOP
                    String displayMessage = currentTranscription;
                    XposedBridge.log(TAG + ": Formatting transcription display - channelType=" + savedChannelTypeForTranscription + ", callerDmrId=" + savedCallerDmrIdForTranscription + ", callerName=" + savedCallerNameForTranscription);
                    
                    if (savedChannelTypeForTranscription == 0) {  // Digital/DMR only
                        if (savedCallerNameForTranscription != null && !savedCallerNameForTranscription.isEmpty()) {
                            displayMessage = savedCallerNameForTranscription + ": " + currentTranscription;
                            XposedBridge.log(TAG + ": Display with contact name: " + displayMessage);
                        } else if (savedCallerDmrIdForTranscription > 0) {
                            displayMessage = "ID " + savedCallerDmrIdForTranscription + ": " + currentTranscription;
                            XposedBridge.log(TAG + ": Display with DMR ID: " + displayMessage);
                        } else {
                            XposedBridge.log(TAG + ": No caller info available for display");
                        }
                    } else {
                        XposedBridge.log(TAG + ": Analog channel - no caller info displayed");
                    }
                    
                    updateTranscriptionDisplay(displayMessage);
                    
                    // Save to text file (always save, independent of recording)
                    saveTranscriptionToFile(currentTranscription, null);
                    
                } catch (Exception e) {
                    XposedBridge.log(TAG + ": ❌ Error processing transcription: " + e.getMessage());
                    e.printStackTrace();
                    
                    currentTranscription = "[IPC error: " + e.getMessage() + "]";
                    updateTranscriptionDisplay(currentTranscription);
                } finally {
                    // Clear buffer for next transmission
                    audioBuffer.clear();
                }
            }
        }).start();
    }
    
    /**
     * Read API key from Download/DMR/api_key.txt
     */
    private static String readApiKeyFromFile() {
        try {
            java.io.File downloadDir = Environment.getExternalStoragePublicDirectory(Environment.DIRECTORY_DOWNLOADS);
            java.io.File dmrDir = new java.io.File(downloadDir, "DMR");
            java.io.File apiKeyFile = new java.io.File(dmrDir, "api_key.txt");
            
            if (apiKeyFile.exists()) {
                BufferedReader reader = new BufferedReader(new FileReader(apiKeyFile));
                String key = reader.readLine();
                reader.close();
                
                if (key != null) {
                    return key.trim();
                }
            }
        } catch (Exception e) {
            XposedBridge.log(TAG + ": Error reading API key: " + e.getMessage());
        }
        return null;
    }
    
    /**
     * Write API key to Download/DMR/api_key.txt
     */
    private static boolean writeApiKeyToFile(String apiKey) {
        try {
            java.io.File downloadDir = Environment.getExternalStoragePublicDirectory(Environment.DIRECTORY_DOWNLOADS);
            java.io.File dmrDir = new java.io.File(downloadDir, "DMR");
            dmrDir.mkdirs();
            java.io.File apiKeyFile = new java.io.File(dmrDir, "api_key.txt");
            
            FileWriter writer = new FileWriter(apiKeyFile);
            writer.write(apiKey.trim() + "\n");
            writer.write("\n");
            writer.write("# Google Cloud Speech-to-Text API Key\n");
            writer.write("# Get your API key from: https://console.cloud.google.com\n");
            writer.write("# Enable 'Cloud Speech-to-Text API'\n");
            writer.write("# Free tier: 60 minutes/month\n");
            writer.close();
            
            XposedBridge.log(TAG + ": API key saved to " + apiKeyFile.getAbsolutePath());
            return true;
        } catch (Exception e) {
            XposedBridge.log(TAG + ": Error writing API key: " + e.getMessage());
            return false;
        }
    }
    
    /**
     * Show API key configuration dialog
     */
    private static void showApiKeyConfigDialog(final Context context, final android.widget.ToggleButton toggleButton) {
        if (!(context instanceof Activity)) {
            return;
        }
        
        final Activity activity = (Activity) context;
        activity.runOnUiThread(new Runnable() {
            @Override
            public void run() {
                AlertDialog.Builder builder = new AlertDialog.Builder(context);
                builder.setTitle("Google Cloud API Key Required");
                
                // Build message with clickable link
                String htmlMessage = "Transcription requires a Google Cloud Speech-to-Text API key.<br><br>" +
                        "<b>How to get your API key:</b><br>" +
                        "1. Visit: <a href='https://console.cloud.google.com'>console.cloud.google.com</a><br>" +
                        "2. Create/select a project<br>" +
                        "3. Enable 'Cloud Speech-to-Text API'<br>" +
                        "4. Go to Credentials → Create API Key<br>" +
                        "5. Copy the key (starts with AIza...)<br><br>" +
                        "<b>API Key Storage:</b><br>" +
                        "Saved to: <font color='#0000FF'>Download/DMR/api_key.txt</font><br>" +
                        "You can edit this file directly with any text editor.<br>" +
                        "<i>Tip: Long-press TXT button to reconfigure anytime.</i><br><br>" +
                        "<b>Cost:</b> First 60 min/month FREE, then $0.006 per 15 sec<br><br>" +
                        "Enter your API key below:";
                
                // Create TextView with clickable links
                TextView messageView = new TextView(context);
                messageView.setText(android.text.Html.fromHtml(htmlMessage, android.text.Html.FROM_HTML_MODE_LEGACY));
                messageView.setMovementMethod(android.text.method.LinkMovementMethod.getInstance());
                messageView.setTextSize(12); // Smaller font size
                messageView.setPadding(
                    (int) (20 * context.getResources().getDisplayMetrics().density),
                    (int) (10 * context.getResources().getDisplayMetrics().density),
                    (int) (20 * context.getResources().getDisplayMetrics().density),
                    (int) (10 * context.getResources().getDisplayMetrics().density)
                );
                
                // Create input field
                final EditText input = new EditText(context);
                input.setInputType(InputType.TYPE_CLASS_TEXT);
                input.setHint("AIza...");
                input.setPadding(
                    (int) (20 * context.getResources().getDisplayMetrics().density),
                    (int) (10 * context.getResources().getDisplayMetrics().density),
                    (int) (20 * context.getResources().getDisplayMetrics().density),
                    (int) (10 * context.getResources().getDisplayMetrics().density)
                );
                
                // Check if file exists and pre-fill
                String existingKey = readApiKeyFromFile();
                if (existingKey != null && !existingKey.isEmpty() && !existingKey.equals("YOUR_GOOGLE_CLOUD_API_KEY_HERE")) {
                    input.setText(existingKey);
                }
                
                // Create container for message and input
                LinearLayout container = new LinearLayout(context);
                container.setOrientation(LinearLayout.VERTICAL);
                container.addView(messageView);
                container.addView(input);
                
                builder.setView(container);
                
                builder.setPositiveButton("Save & Enable", new DialogInterface.OnClickListener() {
                    @Override
                    public void onClick(DialogInterface dialog, int which) {
                        String apiKey = input.getText().toString().trim();
                        if (apiKey.isEmpty()) {
                            Toast.makeText(context, "API key cannot be empty", Toast.LENGTH_SHORT).show();
                            return;
                        }
                        
                        if (!apiKey.startsWith("AIza")) {
                            Toast.makeText(context, "Warning: API key should start with AIza", Toast.LENGTH_LONG).show();
                        }
                        
                        // Save to file
                        if (writeApiKeyToFile(apiKey)) {
                            Toast.makeText(context, "API key saved! Enable TXT to start.", Toast.LENGTH_SHORT).show();
                            
                            // Don't auto-enable, let user toggle it
                            // This way long-press doesn't unexpectedly change state
                        } else {
                            Toast.makeText(context, "Failed to save API key", Toast.LENGTH_SHORT).show();
                        }
                    }
                });
                
                builder.setNegativeButton("Cancel", new DialogInterface.OnClickListener() {
                    @Override
                    public void onClick(DialogInterface dialog, int which) {
                        dialog.cancel();
                    }
                });
                
                builder.setNeutralButton("Edit File Manually", new DialogInterface.OnClickListener() {
                    @Override
                    public void onClick(DialogInterface dialog, int which) {
                        java.io.File downloadDir = Environment.getExternalStoragePublicDirectory(Environment.DIRECTORY_DOWNLOADS);
                        java.io.File apiKeyFile = new java.io.File(downloadDir, "DMR/api_key.txt");
                        Toast.makeText(context, "Edit: " + apiKeyFile.getAbsolutePath(), Toast.LENGTH_LONG).show();
                        dialog.cancel();
                    }
                });
                
                builder.show();
            }
        });
    }
    
    /**
     * Update the transcription display with text (adds new message to list)
     */
    private static void updateTranscriptionDisplay(final String text) {
        if (transcriptionMessagesContainer == null || transcriptionBox == null || transcriptionScrollView == null) {
            return;
        }

        try {
            // Create timestamp
            SimpleDateFormat timeFormat = new SimpleDateFormat("HH:mm:ss", Locale.US);
            String timestamp = timeFormat.format(new Date());
            final String messageWithTimestamp = "[" + timestamp + "] " + text;
            
            // Save message to current channel's history
            if (currentChannelNumber >= 0 && text != null && !text.isEmpty()) {
                java.util.ArrayList<String> history = channelTranscriptionHistory.get(currentChannelNumber);
                if (history == null) {
                    history = new java.util.ArrayList<>();
                    channelTranscriptionHistory.put(currentChannelNumber, history);
                }
                history.add(messageWithTimestamp);
                // Keep only last MAX_TRANSCRIPTION_HISTORY messages
                while (history.size() > MAX_TRANSCRIPTION_HISTORY) {
                    history.remove(0);
                }
            }

            transcriptionMessagesContainer.post(new Runnable() {
                @Override
                public void run() {
                    // Create new message TextView
                    TextView messageView = new TextView(transcriptionMessagesContainer.getContext());
                    messageView.setTextColor(0xFFFFFFFF);  // White text
                    messageView.setTextSize(11);
                    messageView.setText(messageWithTimestamp);
                    messageView.setPadding(0, 2, 0, 2);  // Small vertical padding
                    LinearLayout.LayoutParams messageParams = new LinearLayout.LayoutParams(
                        LinearLayout.LayoutParams.MATCH_PARENT,
                        LinearLayout.LayoutParams.WRAP_CONTENT
                    );
                    messageParams.bottomMargin = (int) (4 * transcriptionMessagesContainer.getContext().getResources().getDisplayMetrics().density);
                    messageView.setLayoutParams(messageParams);
                    
                    // Add message to container
                    transcriptionMessagesContainer.addView(messageView);

                    // Show the box
                    transcriptionBox.setVisibility(View.VISIBLE);

                    // Ensure ScrollView caps at max height and scrolls to bottom
                    transcriptionScrollView.post(new Runnable() {
                        @Override
                        public void run() {
                            int maxHeightPx = (int) (100 * transcriptionScrollView.getContext().getResources().getDisplayMetrics().density);
                            LinearLayout.LayoutParams params = (LinearLayout.LayoutParams) transcriptionScrollView.getLayoutParams();
                            if (transcriptionScrollView.getHeight() > maxHeightPx) {
                                params.height = maxHeightPx;
                                transcriptionScrollView.setLayoutParams(params);
                            }
                            transcriptionScrollView.fullScroll(View.FOCUS_DOWN);
                        }
                    });
                }
            });
        } catch (Exception e) {
            XposedBridge.log(TAG + ": Error updating transcription display: " + e.getMessage());
        }
    }
    
    /**
     * Restore transcription history for a specific channel
     */
    private static void restoreChannelTranscriptionHistory(final int channelNumber) {
        if (transcriptionMessagesContainer == null || transcriptionBox == null || transcriptionScrollView == null) {
            return;
        }

        transcriptionMessagesContainer.post(new Runnable() {
            @Override
            public void run() {
                // Clear existing messages
                transcriptionMessagesContainer.removeAllViews();

                // Get history for this channel
                java.util.ArrayList<String> history = channelTranscriptionHistory.get(channelNumber);
                if (history != null && !history.isEmpty()) {
                    // Rebuild messages from history
                    for (String msg : history) {
                        TextView messageView = new TextView(transcriptionMessagesContainer.getContext());
                        messageView.setTextColor(0xFFFFFFFF);
                        messageView.setTextSize(11);
                        messageView.setText(msg);
                        messageView.setPadding(0, 2, 0, 2);
                        LinearLayout.LayoutParams messageParams = new LinearLayout.LayoutParams(
                            LinearLayout.LayoutParams.MATCH_PARENT,
                            LinearLayout.LayoutParams.WRAP_CONTENT
                        );
                        messageParams.bottomMargin = (int) (4 * transcriptionMessagesContainer.getContext().getResources().getDisplayMetrics().density);
                        messageView.setLayoutParams(messageParams);
                        transcriptionMessagesContainer.addView(messageView);
                    }
                    transcriptionBox.setVisibility(View.VISIBLE);
                    
                    // Scroll to bottom and cap height
                    transcriptionScrollView.post(new Runnable() {
                        @Override
                        public void run() {
                            int maxHeightPx = (int) (100 * transcriptionScrollView.getContext().getResources().getDisplayMetrics().density);
                            LinearLayout.LayoutParams params = (LinearLayout.LayoutParams) transcriptionScrollView.getLayoutParams();
                            if (transcriptionScrollView.getHeight() > maxHeightPx) {
                                params.height = maxHeightPx;
                                transcriptionScrollView.setLayoutParams(params);
                            }
                            transcriptionScrollView.fullScroll(View.FOCUS_DOWN);
                        }
                    });
                } else {
                    // No history for this channel, hide the box
                    transcriptionBox.setVisibility(View.GONE);
                }
            }
        });
    }
    
    /**
     * Save transcription to running log file in Transcription folder
     * Appends to daily transcription log with timestamp and channel info
     * Each channel gets its own folder
     */
    private static void saveTranscriptionToFile(final String transcription, final String recordingPath) {
        if (transcription == null || transcription.trim().isEmpty()) {
            return;
        }
        
        new Thread(new Runnable() {
            @Override
            public void run() {
                try {
                    // Clean channel name for folder (remove special characters)
                    String channelFolderName = currentChannelName;
                    if (channelFolderName != null && !channelFolderName.isEmpty()) {
                        channelFolderName = channelFolderName.replaceAll("[^a-zA-Z0-9\\s-]", "").trim();
                    }
                    if (channelFolderName == null || channelFolderName.isEmpty()) {
                        channelFolderName = "Channel_" + currentChannelNumber;
                    }
                    
                    // Get Downloads/DMR/Transcription/[ChannelName] folder
                    java.io.File downloadDir = android.os.Environment.getExternalStoragePublicDirectory(android.os.Environment.DIRECTORY_DOWNLOADS);
                    java.io.File transcriptionDir = new java.io.File(downloadDir, "DMR/Transcription/" + channelFolderName);
                    
                    if (!transcriptionDir.exists()) {
                        transcriptionDir.mkdirs();
                        XposedBridge.log(TAG + ": Created channel transcription folder: " + transcriptionDir.getAbsolutePath());
                    }
                    
                    // Create daily transcription file (e.g., transcription_20260227.txt)
                    java.text.SimpleDateFormat dateFormat = new java.text.SimpleDateFormat("yyyyMMdd", java.util.Locale.US);
                    java.text.SimpleDateFormat timeFormat = new java.text.SimpleDateFormat("HH:mm:ss", java.util.Locale.US);
                    String date = dateFormat.format(new java.util.Date());
                    String time = timeFormat.format(new java.util.Date());
                    
                    String filename = "transcription_" + date + ".txt";
                    File txtFile = new File(transcriptionDir, filename);
                    
                    // Append to file (running log)
                    java.io.FileWriter writer = new java.io.FileWriter(txtFile, true); // true = append mode
                    
                    // Write entry with timestamp and transcription
                    writer.write("[" + time + "] ");
                    
                    // Add DMR ID or contact name (digital only)
                    // Use saved caller info since currentCallerDmrId is cleared after RECEIVE_STOP
                    XposedBridge.log(TAG + ": Saving transcription - channelType=" + savedChannelTypeForTranscription + ", callerDmrId=" + savedCallerDmrIdForTranscription + ", callerName=" + savedCallerNameForTranscription);
                    
                    if (savedChannelTypeForTranscription == 0) {  // Digital/DMR only
                        if (savedCallerNameForTranscription != null && !savedCallerNameForTranscription.isEmpty()) {
                            writer.write(savedCallerNameForTranscription + ": ");
                            XposedBridge.log(TAG + ": Writing with contact name: " + savedCallerNameForTranscription);
                        } else if (savedCallerDmrIdForTranscription > 0) {
                            writer.write("ID " + savedCallerDmrIdForTranscription + ": ");
                            XposedBridge.log(TAG + ": Writing with DMR ID: " + savedCallerDmrIdForTranscription);
                        } else {
                            XposedBridge.log(TAG + ": No caller info for file");
                        }
                    } else {
                        XposedBridge.log(TAG + ": Analog - no caller info written");
                    }
                    
                    writer.write(transcription);
                    writer.write("\n");
                    writer.close();
                    
                    XposedBridge.log(TAG + ": ✅ Saved transcription to: " + txtFile.getAbsolutePath());
                    
                } catch (Exception e) {
                    XposedBridge.log(TAG + ": ❌ Error saving transcription to file: " + e.getMessage());
                    e.printStackTrace();
                }
            }
        }).start();
    }
    
    /**
     * Hook UART serial communication to log all TX/RX traffic with /dev/ttyS0
     * This captures the packet-level protocol between Android app and DMR hardware module
     * Priority #1 from DMR_FIX_ROADMAP.md - foundation for firmware analysis
     */
    private void hookSerialCommunication(XC_LoadPackage.LoadPackageParam lpparam) {
        try {
            XposedBridge.log(TAG + ": 🔌 Hooking UART serial communication (SerialManager packets)...");
            
            // Create log directory
            final File uartLogDir = new File(Environment.getExternalStorageDirectory(), "DMR/uart_logs");
            if (!uartLogDir.exists()) {
                uartLogDir.mkdirs();
            }
            
            // Create timestamped log file
            final SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd_HHmmss", Locale.US);
            final String timestamp = sdf.format(new Date());
            final File binaryLogFile = new File(uartLogDir, "uart_" + timestamp + ".bin");
            final File textLogFile = new File(uartLogDir, "uart_" + timestamp + ".txt");
            
            XposedBridge.log(TAG + ": 📝 UART logs will be saved to: " + uartLogDir.getAbsolutePath());
            
            // Hook SerialManager.send() to capture TX packets
            Class<?> serialManagerClass = XposedHelpers.findClass(
                "com.pri.prizeinterphone.serial.SerialManager",
                lpparam.classLoader
            );
            
            Class<?> packetClass = XposedHelpers.findClass(
                "com.pri.prizeinterphone.protocol.Packet",
                lpparam.classLoader
            );
            
            XposedHelpers.findAndHookMethod(serialManagerClass, "send", packetClass,
                new XC_MethodHook() {
                    @Override
                    protected void beforeHookedMethod(MethodHookParam param) throws Throwable {
                        Object packet = param.args[0];
                        logPacketData("TX", packet, binaryLogFile, textLogFile);
                    }
                }
            );
            
            // Hook MessageDispatcher.onReceive() to capture RX packets
            Class<?> messageDispatcherClass = XposedHelpers.findClass(
                "com.pri.prizeinterphone.serial.MessageDispatcher",
                lpparam.classLoader
            );
            
            Class<?> serialPortClass = XposedHelpers.findClass(
                "com.pri.prizeinterphone.serial.port.SerialPort",
                lpparam.classLoader
            );
            
            XposedHelpers.findAndHookMethod(messageDispatcherClass, "onReceive", 
                packetClass, serialPortClass,
                new XC_MethodHook() {
                    @Override
                    protected void beforeHookedMethod(MethodHookParam param) throws Throwable {
                        Object packet = param.args[0];
                        logPacketData("RX", packet, binaryLogFile, textLogFile);
                    }
                }
            );
            
            XposedBridge.log(TAG + ": ✅ UART serial hooks installed successfully!");
            
        } catch (Throwable t) {
            XposedBridge.log(TAG + ": ❌ Failed to hook Serial communication: " + t.getMessage());
            t.printStackTrace();
        }
    }
    
    /**
     * Log UART packet data to both binary and human-readable text files
     * Performs real-time packet parsing and interpretation
     */
    private void logPacketData(final String direction, final Object packet, final File binaryLog, final File textLog) {
        new Thread(new Runnable() {
            @Override
            public void run() {
                try {
                    // Extract packet fields using reflection
                    byte head = (Byte) XposedHelpers.getObjectField(packet, "head");
                    byte cmd = (Byte) XposedHelpers.getObjectField(packet, "cmd");
                    byte rw = (Byte) XposedHelpers.getObjectField(packet, "rw");
                    byte sr = (Byte) XposedHelpers.getObjectField(packet, "sr");
                    short ckSum = (Short) XposedHelpers.getObjectField(packet, "ckSum");
                    short len = (Short) XposedHelpers.getObjectField(packet, "len");
                    byte[] body = (byte[]) XposedHelpers.getObjectField(packet, "body");
                    byte tail = (Byte) XposedHelpers.getObjectField(packet, "tail");
                    
                    long timestamp = System.currentTimeMillis();
                    
                    // Append to binary log
                    FileOutputStream binaryOut = new FileOutputStream(binaryLog, true);
                    
                    // Write direction marker (1 byte: 0x01=TX, 0x02=RX)
                    binaryOut.write(direction.equals("TX") ? 0x01 : 0x02);
                    
                    // Write timestamp (8 bytes)
                    ByteBuffer tsBuffer = ByteBuffer.allocate(8);
                    tsBuffer.putLong(timestamp);
                    binaryOut.write(tsBuffer.array());
                    
                    // Write packet structure
                    binaryOut.write(head);
                    binaryOut.write(cmd);
                    binaryOut.write(rw);
                    binaryOut.write(sr);
                    binaryOut.write((ckSum >> 8) & 0xFF);
                    binaryOut.write(ckSum & 0xFF);
                    binaryOut.write((len >> 8) & 0xFF);
                    binaryOut.write(len & 0xFF);
                    if (body != null && body.length > 0) {
                        binaryOut.write(body);
                    }
                    binaryOut.write(tail);
                    binaryOut.close();
                    
                    // Append to text log with packet interpretation
                    FileWriter textWriter = new FileWriter(textLog, true);
                    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss.SSS", Locale.US);
                    
                    textWriter.write("\n========================================\n");
                    textWriter.write(direction + " @ " + sdf.format(new Date(timestamp)) + "\n");
                    textWriter.write("----------------------------------------\n");
                    textWriter.write("Packet Structure:\n");
                    textWriter.write("  Head: 0x" + String.format("%02X", head) + " (" + head + ")\n");
                    textWriter.write("  CMD: 0x" + String.format("%02X", cmd) + " (" + cmd + ") " + getCmdName(cmd) + "\n");
                    textWriter.write("  RW: " + rw + "\n");
                    textWriter.write("  SR: " + sr + "\n");
                    textWriter.write("  Checksum: 0x" + String.format("%04X", ckSum) + "\n");
                    textWriter.write("  Length: " + len + " bytes\n");
                    textWriter.write("  Tail: 0x" + String.format("%02X", tail) + " (" + tail + ")\n");
                    
                    // Body hex dump
                    if (body != null && body.length > 0) {
                        textWriter.write("----------------------------------------\n");
                        textWriter.write("Body (" + body.length + " bytes):\n");
                        textWriter.write("Hex: ");
                        for (int i = 0; i < body.length; i++) {
                            textWriter.write(String.format("%02X ", body[i]));
                            if ((i + 1) % 16 == 0 && i < body.length - 1) {
                                textWriter.write("\n     ");
                            }
                        }
                        textWriter.write("\n");
                        
                        // Try to parse as DigitalMessage (cmd=22, SET_DIGITAL_INFO_CMD)
                        if (cmd == 22 && body.length >= 163) {
                            textWriter.write("----------------------------------------\n");
                            textWriter.write("Parsed as DigitalMessage (SET_DIGITAL_INFO_CMD):\n");
                            
                            // Parse fields using big-endian byte order
                            int rxFreq = ((body[0] & 0xFF) << 24) | ((body[1] & 0xFF) << 16) | 
                                        ((body[2] & 0xFF) << 8) | (body[3] & 0xFF);
                            int txFreq = ((body[4] & 0xFF) << 24) | ((body[5] & 0xFF) << 16) | 
                                        ((body[6] & 0xFF) << 8) | (body[7] & 0xFF);
                            int localId = ((body[8] & 0xFF) << 24) | ((body[9] & 0xFF) << 16) | 
                                         ((body[10] & 0xFF) << 8) | (body[11] & 0xFF);
                            
                            // Group list (32 groups, 4 bytes each)
                            int[] groups = new int[32];
                            for (int i = 0; i < 32; i++) {
                                int offset = 12 + (i * 4);
                                groups[i] = ((body[offset] & 0xFF) << 24) | ((body[offset+1] & 0xFF) << 16) | 
                                           ((body[offset+2] & 0xFF) << 8) | (body[offset+3] & 0xFF);
                            }
                            
                            int txContact = ((body[140] & 0xFF) << 24) | ((body[141] & 0xFF) << 16) | 
                                           ((body[142] & 0xFF) << 8) | (body[143] & 0xFF);
                            byte contactType = body[144];
                            byte power = body[145];
                            byte colorCode = body[146];
                            byte slot = body[147];
                            
                            textWriter.write("  RX Freq: " + rxFreq + " Hz (" + (rxFreq / 1000000.0) + " MHz)\n");
                            textWriter.write("  TX Freq: " + txFreq + " Hz (" + (txFreq / 1000000.0) + " MHz)\n");
                            textWriter.write("  Local ID: " + localId + "\n");
                            textWriter.write("  TX Contact: " + txContact + "\n");
                            textWriter.write("  Contact Type: " + contactType + " (" + 
                                            (contactType == 0 ? "PERSON" : 
                                             contactType == 1 ? "GROUP" : 
                                             contactType == 2 ? "ALL" : "UNKNOWN") + ")\n");
                            textWriter.write("  Power: " + power + "\n");
                            textWriter.write("  Color Code: " + colorCode + "\n");
                            textWriter.write("  Slot: " + slot + "\n");
                            textWriter.write("  Groups: [");
                            int nonZeroGroups = 0;
                            for (int g : groups) {
                                if (g != 0) {
                                    if (nonZeroGroups > 0) textWriter.write(", ");
                                    textWriter.write(String.valueOf(g));
                                    nonZeroGroups++;
                                }
                            }
                            textWriter.write("] (" + nonZeroGroups + " active)\n");
                            
                            // Highlight contactType=2 (ALL mode) packets
                            if (contactType == 2) {
                                textWriter.write("\n🔥🔥🔥 MONITORING MODE (ALL) PACKET! 🔥🔥🔥\n");
                            }
                        }
                    }
                    
                    textWriter.write("========================================\n");
                    textWriter.close();
                    
                    // Also log to Xposed for real-time monitoring
                    XposedBridge.log(TAG + ": UART " + direction + " cmd=" + cmd + " (" + getCmdName(cmd) + ") len=" + len);
                    
                } catch (Exception e) {
                    XposedBridge.log(TAG + ": ❌ Error logging UART packet: " + e.getMessage());
                }
            }
        }).start();
    }
    
    /**
     * Get human-readable command name
     */
    private String getCmdName(byte cmd) {
        switch (cmd) {
            case 1: return "RECEIVE_START";
            case 2: return "RECEIVE_STOP";
            case 10: return "MIX_CHECK_DIGITAL_RECEIVE_START";
            case 22: return "SET_DIGITAL_INFO_CMD";
            case 35: return "INTERRUPT_TRANSMIT_CMD";
            case 63: return "TEST_BIT_ERROR_RATE";
            default: return "UNKNOWN";
        }
    }
    
    /**
     * Test for STM32 bootloader on radio UART
     * 
     * This is called once during app initialization to determine if permanent
     * firmware flashing is possible via UART bootloader commands.
     * 
     * If successful (ACK + Write/Erase support), permanent patch is possible.
     * If not, we fall back to the one-tap reload button.
     */
    private void testBootloaderAccess() {
        // Run in background to avoid blocking app initialization
        new Thread(() -> {
            try {
                // Wait 5 seconds for app to stabilize
                Thread.sleep(5000);
                
                XposedBridge.log(TAG + ": ========================================");
                XposedBridge.log(TAG + ": Starting UART bootloader probe...");
                XposedBridge.log(TAG + ": ========================================");
                
                UARTBootloaderProbe.ProbeResult result = UARTBootloaderProbe.probeBootloader();
                
                XposedBridge.log(TAG + ": ========================================");
                XposedBridge.log(TAG + ": PROBE RESULT: " + result.toString());
                XposedBridge.log(TAG + ": ========================================");
                
                if (result.canFlashPermanently()) {
                    XposedBridge.log(TAG + ": 🎉🎉🎉 BOOTLOADER ACCESSIBLE! 🎉🎉🎉");
                    XposedBridge.log(TAG + ": ⭐ Permanent flash via UART IS POSSIBLE!");
                    XposedBridge.log(TAG + ": 📝 Write Memory (0x31) available");
                    XposedBridge.log(TAG + ": 📝 Erase (0x43) available");
                    XposedBridge.log(TAG + ": ⚠️  Next step: Implement flash write operations");
                    XposedBridge.log(TAG + ": ⚠️  See INTEGRATION_GUIDE.md Phase 1B");
                    
                    // Optional: Try reading patch location
                    try {
                        Thread.sleep(1000);
                        XposedBridge.log(TAG + ": Testing Read Memory at patch location...");
                        UARTBootloaderProbe.PatchStatus status = UARTBootloaderProbe.readPatchLocation();
                        XposedBridge.log(TAG + ": Patch status: " + status.toString());
                    } catch (Exception e) {
                        XposedBridge.log(TAG + ": Read test failed: " + e.getMessage());
                    }
                    
                } else {
                    XposedBridge.log(TAG + ": ❌ Bootloader not accessible");
                    XposedBridge.log(TAG + ": → Cannot flash permanently via UART");
                    XposedBridge.log(TAG + ": → Fallback: Implement one-tap reload button");
                    XposedBridge.log(TAG + ": → See INTEGRATION_GUIDE.md Phase 2");
                }
                
                XposedBridge.log(TAG + ": ========================================");
                
            } catch (Exception e) {
                XposedBridge.log(TAG + ": Bootloader probe exception: " + e.getMessage());
                e.printStackTrace();
            }
        }).start();
    }
    
    /**
     * Register broadcast receiver for debug packet sending (command fuzzing)
     * 
     * Usage: adb shell am broadcast -a com.dmrmod.SEND_DEBUG_PACKET --ei CMD 0x4D --ei RW 1 --ei SR 1
     */
    private void registerDebugPacketReceiver(XC_LoadPackage.LoadPackageParam lpparam) {
        try {
            Class<?> applicationClass = XposedHelpers.findClass(
                "android.app.Application",
                lpparam.classLoader
            );
            
            XposedHelpers.findAndHookMethod(
                applicationClass,
                "onCreate",
                new XC_MethodHook() {
                    @Override
                    protected void afterHookedMethod(MethodHookParam param) throws Throwable {
                        final android.content.Context context = (android.content.Context) param.thisObject;
                        
                        // Register broadcast receiver for debug commands
                        android.content.BroadcastReceiver debugReceiver = new android.content.BroadcastReceiver() {
                            @Override
                            public void onReceive(android.content.Context context, android.content.Intent intent) {
                                handleDebugPacket(intent, lpparam.classLoader);
                            }
                        };
                        
                        android.content.IntentFilter filter = new android.content.IntentFilter("com.dmrmod.SEND_DEBUG_PACKET");
                        context.registerReceiver(debugReceiver, filter, android.content.Context.RECEIVER_EXPORTED);
                        
                        XposedBridge.log(TAG + ": ✓ Debug packet receiver registered (EXPORTED for ADB)");
                    }
                }
            );
            
        } catch (Throwable t) {
            XposedBridge.log(TAG + ": ❌ Failed to register debug packet receiver: " + t.getMessage());
        }
    }
    
    /**
     * Handle debug packet broadcast - send custom UART packets for fuzzing
     */
    private void handleDebugPacket(android.content.Intent intent, ClassLoader classLoader) {
        try {
            // Extract packet parameters from intent
            int cmd = intent.getIntExtra("CMD", -1);
            int rw = intent.getIntExtra("RW", 1);  // Default: read/query
            int sr = intent.getIntExtra("SR", 1);  // Default: set
            String bodyHex = intent.getStringExtra("BODY"); // Optional hex body
            
            if (cmd < 0 || cmd > 255) {
                XposedBridge.log(TAG + ": Invalid CMD value: " + cmd);
                return;
            }
            
            XposedBridge.log(TAG + ": 🔍 FUZZING: Sending debug packet CMD=0x" + String.format("%02X", cmd) + 
                " RW=" + rw + " SR=" + sr);
            
            // Create Packet object
            Class<?> packetClass = XposedHelpers.findClass(
                "com.pri.prizeinterphone.protocol.Packet",
                classLoader
            );
            
            // Constructor: Packet(byte cmd)
            Object packet = XposedHelpers.newInstance(packetClass, (byte) cmd);
            
            // Set RW and SR flags
            XposedHelpers.setByteField(packet, "rw", (byte) rw);
            XposedHelpers.setByteField(packet, "sr", (byte) sr);
            
            // Set body if provided
            if (bodyHex != null && !bodyHex.isEmpty()) {
                byte[] body = hexStringToByteArray(bodyHex);
                XposedHelpers.setObjectField(packet, "body", body);
                XposedBridge.log(TAG + ": Body: " + bodyHex + " (" + body.length + " bytes)");
            } else {
                // Default body for query commands
                XposedHelpers.setObjectField(packet, "body", new byte[]{1});
            }
            
            // Send via SerialManager
            Class<?> serialManagerClass = XposedHelpers.findClass(
                "com.pri.prizeinterphone.serial.SerialManager",
                classLoader
            );
            Object serialManager = XposedHelpers.callStaticMethod(serialManagerClass, "getInstance");
            XposedHelpers.callMethod(serialManager, "send", packet);
            
            XposedBridge.log(TAG + ": ✓ Debug packet sent successfully");
            
        } catch (Throwable t) {
            XposedBridge.log(TAG + ": ❌ Failed to send debug packet: " + t.getMessage());
            XposedBridge.log(t);
        }
    }
    
    /**
     * Convert hex string to byte array
     */
    private byte[] hexStringToByteArray(String s) {
        s = s.replaceAll("\\s+", ""); // Remove whitespace
        int len = s.length();
        byte[] data = new byte[len / 2];
        for (int i = 0; i < len; i += 2) {
            data[i / 2] = (byte) ((Character.digit(s.charAt(i), 16) << 4)
                                 + Character.digit(s.charAt(i+1), 16));
        }
        return data;
    }
    
    /**
     * Show zone selection dialog
     */
    private static void showZoneSelectionDialog(final Context context) {
        try {
            if (zoneDatabase == null) {
                zoneDatabase = ZoneDatabase.getInstance(context);
            }
            
            // Get all zones
            final java.util.List<ZoneDatabase.Zone> zones = zoneDatabase.getAllZones();
            
            // Build zone list for dialog (add "All Channels" option at top)
            final java.util.List<String> zoneNames = new java.util.ArrayList<>();
            final java.util.List<Long> zoneIds = new java.util.ArrayList<>();
            
            zoneNames.add("All Channels");
            zoneIds.add(-1L);
            
            for (ZoneDatabase.Zone zone : zones) {
                zoneNames.add(zone.name + " (" + zone.getChannelCount() + ")");
                zoneIds.add(zone.id);
            }
            
            // Show dialog
            android.app.AlertDialog.Builder builder = new android.app.AlertDialog.Builder(context);
            builder.setTitle("Select Zone");
            
            // Convert to array for dialog
            final String[] items = zoneNames.toArray(new String[0]);
            
            builder.setItems(items, new android.content.DialogInterface.OnClickListener() {
                @Override
                public void onClick(android.content.DialogInterface dialog, int which) {
                    try {
                        long selectedZoneId = zoneIds.get(which);
                        String selectedZoneName;
                        java.util.List<Integer> zoneChannelList;
                        
                        if (selectedZoneId == -1) {
                            // All Channels mode
                            currentZoneId = -1;
                            currentZoneName = "All";
                            currentZoneChannels = null;
                            selectedZoneName = "All Channels";
                            XposedBridge.log(TAG + ": Zone filter disabled - showing all channels");
                        } else {
                            // Specific zone selected
                            ZoneDatabase.Zone selectedZone = zoneDatabase.getZone(selectedZoneId);
                            if (selectedZone != null) {
                                currentZoneId = selectedZoneId;
                                currentZoneName = selectedZone.name;
                                currentZoneChannels = selectedZone.getChannelList();
                                selectedZoneName = selectedZone.name;
                                XposedBridge.log(TAG + ": Zone selected: " + selectedZoneName + 
                                    " (" + currentZoneChannels.size() + " channels)");
                            } else {
                                Toast.makeText(context, "Zone not found", Toast.LENGTH_SHORT).show();
                                return;
                            }
                        }
                        
                        // Update button text
                        if (zoneButton != null) {
                            zoneButton.setText("Zone: " + currentZoneName);
                        }
                        
                        // Update channel page zone button if it exists
                        if (channelPageZoneButton != null) {
                            channelPageZoneButton.setText("Zone: " + currentZoneName);
                        }
                        
                        // Check if we need to switch channels (current channel not in new zone)
                        if (talkBackFragmentInstance != null && selectedZoneId != -1 && currentZoneChannels != null) {
                            try {
                                // Get current channel number
                                Object currentChannelData = XposedHelpers.getObjectField(talkBackFragmentInstance, "mCurrentChannelData");
                                if (currentChannelData != null) {
                                    int currentChannelNumber = XposedHelpers.getIntField(currentChannelData, "number");
                                    
                                    // Check if current channel is in the new zone
                                    if (!currentZoneChannels.contains(currentChannelNumber)) {
                                        // Current channel NOT in new zone - must switch to first channel in zone
                                        XposedBridge.log(TAG + ": Current channel " + currentChannelNumber + 
                                            " not in zone " + selectedZoneName + ", switching to first channel");
                                        
                                        final String finalZoneName = selectedZoneName;
                                        
                                        // Use Handler to delay channel switch until after dialog closes
                                        new android.os.Handler(android.os.Looper.getMainLooper()).postDelayed(new Runnable() {
                                            @Override
                                            public void run() {
                                                try {
                                                    // Get channels list
                                                    java.util.List<Object> channels = (java.util.List<Object>) 
                                                        XposedHelpers.getObjectField(talkBackFragmentInstance, "channels");
                                                    
                                                    if (channels == null || channels.isEmpty()) {
                                                        XposedBridge.log(TAG + ": No channels available");
                                                        return;
                                                    }
                                                    
                                                    // Find first channel in the zone
                                                    int targetIndex = -1;
                                                    int targetChannelNumber = -1;
                                                    for (int i = 0; i < channels.size(); i++) {
                                                        Object channelData = channels.get(i);
                                                        int channelNumber = XposedHelpers.getIntField(channelData, "number");
                                                        if (currentZoneChannels.contains(channelNumber)) {
                                                            targetIndex = i;
                                                            targetChannelNumber = channelNumber;
                                                            break;
                                                        }
                                                    }
                                                    
                                                    if (targetIndex >= 0) {
                                                        // Get the target channel data
                                                        Object targetChannelData = channels.get(targetIndex);
                                                        
                                                        final int finalTargetChannelNumber = targetChannelNumber;  // Make final for inner class
                                                        
                                                        // Get DmrManager
                                                        Object dmrManager = XposedHelpers.callStaticMethod(
                                                            XposedHelpers.findClass("com.pri.prizeinterphone.manager.DmrManager", 
                                                                context.getClassLoader()),
                                                            "getInstance"
                                                        );
                                                        
                                                        // Directly set the fragment's channel index and data
                                                        XposedHelpers.setIntField(talkBackFragmentInstance, "mCurrentChannelIndex", targetIndex);
                                                        XposedHelpers.setObjectField(talkBackFragmentInstance, "mCurrentChannelData", targetChannelData);
                                                        
                                                        // Update the DmrManager with the new channel
                                                        XposedHelpers.callMethod(dmrManager, "updateChannel", targetChannelData);
                                                        
                                                        // Sync to hardware (this sends commands to the radio)
                                                        XposedHelpers.callMethod(dmrManager, "syncChannelInfoWithData", targetChannelData);
                                                        
                                                        XposedBridge.log(TAG + ": Switched to channel " + targetChannelNumber + 
                                                            " (index " + targetIndex + ") for zone " + finalZoneName);
                                                        
                                                        Toast.makeText(context, "Zone: " + finalZoneName + " → Ch." + targetChannelNumber, 
                                                            Toast.LENGTH_SHORT).show();
                                                    } else {
                                                        XposedBridge.log(TAG + ": No valid channel found in zone " + finalZoneName);
                                                        Toast.makeText(context, "Zone: " + finalZoneName, Toast.LENGTH_SHORT).show();
                                                    }
                                                } catch (Throwable t) {
                                                    XposedBridge.log(TAG + ": Error switching channel: " + t.getMessage());
                                                    XposedBridge.log(t);
                                                    Toast.makeText(context, "Zone: " + finalZoneName, Toast.LENGTH_SHORT).show();
                                                }
                                            }
                                        }, 300); // 300ms delay to let dialog close
                                        
                                    } else {
                                        // Current channel IS in new zone, keep it
                                        XposedBridge.log(TAG + ": Current channel " + currentChannelNumber + 
                                            " is in zone " + selectedZoneName + ", keeping it");
                                        Toast.makeText(context, "Zone: " + selectedZoneName, Toast.LENGTH_SHORT).show();
                                    }
                                } else {
                                    Toast.makeText(context, "Zone: " + selectedZoneName, Toast.LENGTH_SHORT).show();
                                }
                            } catch (Throwable t) {
                                XposedBridge.log(TAG + ": Error checking current channel: " + t.getMessage());
                                Toast.makeText(context, "Zone: " + selectedZoneName, Toast.LENGTH_SHORT).show();
                            }
                        } else {
                            Toast.makeText(context, "Zone: " + selectedZoneName, Toast.LENGTH_SHORT).show();
                        }
                        
                    } catch (Throwable t) {
                        XposedBridge.log(TAG + ": Error selecting zone: " + t.getMessage());
                        XposedBridge.log(t);
                        Toast.makeText(context, "Error selecting zone", Toast.LENGTH_SHORT).show();
                    }
                }
            });
            
            builder.setNegativeButton("Cancel", null);
            builder.show();
            
        } catch (Throwable t) {
            XposedBridge.log(TAG + ": Error showing zone dialog: " + t.getMessage());
            XposedBridge.log(t);
            Toast.makeText(context, "Error showing zones", Toast.LENGTH_SHORT).show();
        }
    }
    
    /**
     * Hook channel navigation to filter by zone
     */
    private void hookChannelNavigation(XC_LoadPackage.LoadPackageParam lpparam) {
        try {
            Class<?> talkBackFragmentClass = XposedHelpers.findClass(
                "com.pri.prizeinterphone.fragment.InterPhoneTalkBackFragment",
                lpparam.classLoader
            );
            
            // Hook updateChannelId method (takes boolean parameter: true=up, false=down)
            XposedHelpers.findAndHookMethod(
                talkBackFragmentClass,
                "updateChannelId",
                boolean.class,
                new XC_MethodHook() {
                    @Override
                    protected void beforeHookedMethod(MethodHookParam param) throws Throwable {
                        // If we're auto-switching zones, bypass zone navigation and let original method run
                        if (isAutoSwitchingZone) {
                            return;
                        }
                        
                        // If no zone is selected, let original method run
                        if (currentZoneChannels == null || currentZoneChannels.isEmpty()) {
                            return;
                        }
                        
                        boolean isUp = (Boolean) param.args[0];
                        Object fragment = param.thisObject;
                        
                        try {
                            // Get the channels list from fragment
                            @SuppressWarnings("unchecked")
                            java.util.List<Object> channels = (java.util.List<Object>) XposedHelpers.getObjectField(
                                fragment, "channels");
                            
                            if (channels == null || channels.size() <= 1) {
                                return;
                            }
                            
                            // Get current channel index from fragment
                            int mCurrentChannelIndex = XposedHelpers.getIntField(fragment, "mCurrentChannelIndex");
                            int maxChannelId = XposedHelpers.getIntField(fragment, "mMaxChannelId");
                            
                            // Get current channel number
                            Object currentChannelData = channels.get(mCurrentChannelIndex);
                            int currentChannelNumber = XposedHelpers.getIntField(currentChannelData, "number");
                            
                            XposedBridge.log(TAG + ": Zone navigation - current channel: " + currentChannelNumber + 
                                " (index " + mCurrentChannelIndex + "), direction: " + (isUp ? "UP" : "DOWN"));
                            
                            // Find next valid channel in zone
                            int nextIndex = mCurrentChannelIndex;
                            int attempts = 0;
                            while (attempts < maxChannelId) {
                                // Move in the requested direction
                                if (isUp) {
                                    nextIndex++;
                                    if (nextIndex >= maxChannelId) {
                                        nextIndex = 0; // Wrap around
                                    }
                                } else {
                                    nextIndex--;
                                    if (nextIndex < 0) {
                                        nextIndex = maxChannelId - 1; // Wrap around
                                    }
                                }
                                
                                // Check if this channel is in the zone
                                Object channelData = channels.get(nextIndex);
                                int channelNumber = XposedHelpers.getIntField(channelData, "number");
                                
                                if (currentZoneChannels.contains(channelNumber)) {
                                    // Found a valid channel in the zone!
                                    XposedBridge.log(TAG + ": Zone navigation - found channel " + channelNumber + 
                                        " in zone at index " + nextIndex);
                                    
                                    // Pre-set the index so the original method will land on our target
                                    // Original method does: if(isUp) index++; else index--;
                                    // So we set it to (target - 1) for UP, or (target + 1) for DOWN
                                    int presetIndex = isUp ? (nextIndex - 1) : (nextIndex + 1);
                                    
                                    // Handle wraparound
                                    if (presetIndex < 0) {
                                        presetIndex = maxChannelId - 1;
                                    } else if (presetIndex >= maxChannelId) {
                                        presetIndex = 0;
                                    }
                                    
                                    XposedHelpers.setIntField(fragment, "mCurrentChannelIndex", presetIndex);
                                    
                                    // Let the original method run - it will increment/decrement to nextIndex
                                    // and handle all the UI and radio updates
                                    return;
                                }
                                
                                attempts++;
                            }
                            
                            // If we got here, we didn't find any valid channels
                            XposedBridge.log(TAG + ": Zone navigation - no valid channels found in zone!");
                            Toast.makeText((android.content.Context) XposedHelpers.callMethod(fragment, "getContext"),
                                "No channels in zone", Toast.LENGTH_SHORT).show();
                            param.setResult(null); // Cancel original method
                            
                        } catch (Throwable t) {
                            XposedBridge.log(TAG + ": Error in zone navigation: " + t.getMessage());
                            XposedBridge.log(t);
                            // Let original method run on error
                        }
                    }
                }
            );
            
            XposedBridge.log(TAG + ": ✓ Channel navigation hook installed");
            
        } catch (Throwable t) {
            XposedBridge.log(TAG + ": Failed to hook channel navigation: " + t.getMessage());
            XposedBridge.log(t);
        }
    }
    
    /**
     * Hook to filter channel list in InterPhoneChannelFragment based on selected zone
     */
    private void hookChannelListFilter(XC_LoadPackage.LoadPackageParam lpparam) {
        try {
            Class<?> channelFragmentClass = XposedHelpers.findClass(
                "com.pri.prizeinterphone.fragment.InterPhoneChannelFragment",
                lpparam.classLoader
            );
            
            // Find the inner adapter class
            Class<?>[] declaredClasses = channelFragmentClass.getDeclaredClasses();
            Class<?> adapterClass = null;
            for (Class<?> cls : declaredClasses) {
                if (cls.getSimpleName().contains("DeviceAreaListAdapter")) {
                    adapterClass = cls;
                    break;
                }
            }
            
            if (adapterClass == null) {
                XposedBridge.log(TAG + ": Could not find DeviceAreaListAdapter class");
                return;
            }
            
            // Hook getCount() to return filtered count
            XposedHelpers.findAndHookMethod(
                adapterClass,
                "getCount",
                new XC_MethodReplacement() {
                    @Override
                    protected Object replaceHookedMethod(MethodHookParam param) throws Throwable {
                        try {
                            // Get the outer fragment instance
                            Object outerFragment = XposedHelpers.getObjectField(param.thisObject, "this$0");
                            java.util.List<Object> channels = (java.util.List<Object>) 
                                XposedHelpers.getObjectField(outerFragment, "channels");
                            
                            if (channels == null) {
                                return 0;
                            }
                            
                            // If no zone selected, count all non-APRS channels
                            if (currentZoneChannels == null || currentZoneChannels.isEmpty()) {
                                int count = 0;
                                for (Object channelData : channels) {
                                    if (!isAPRSChannel(channelData)) {
                                        count++;
                                    }
                                }
                                return count;
                            }
                            
                            // Count channels in current zone (excluding APRS)
                            int count = 0;
                            for (Object channelData : channels) {
                                if (isAPRSChannel(channelData)) {
                                    continue;  // Skip APRS channels
                                }
                                int channelNumber = XposedHelpers.getIntField(channelData, "number");
                                if (currentZoneChannels.contains(channelNumber)) {
                                    count++;
                                }
                            }
                            return count;
                            
                        } catch (Throwable t) {
                            XposedBridge.log(TAG + ": Error in getCount: " + t.getMessage());
                            // Fallback to original behavior
                            Object outerFragment = XposedHelpers.getObjectField(param.thisObject, "this$0");
                            java.util.List<Object> channels = (java.util.List<Object>) 
                                XposedHelpers.getObjectField(outerFragment, "channels");
                            return channels != null ? channels.size() : 0;
                        }
                    }
                }
            );
            
            // Hook getView() to map filtered position to actual channel index
            XposedHelpers.findAndHookMethod(
                adapterClass,
                "getView",
                int.class,
                android.view.View.class,
                android.view.ViewGroup.class,
                new XC_MethodHook() {
                    @Override
                    protected void beforeHookedMethod(MethodHookParam param) throws Throwable {
                        try {
                            int position = (Integer) param.args[0];
                            
                            // Get the outer fragment instance
                            Object outerFragment = XposedHelpers.getObjectField(param.thisObject, "this$0");
                            java.util.List<Object> channels = (java.util.List<Object>) 
                                XposedHelpers.getObjectField(outerFragment, "channels");
                            
                            if (channels == null) {
                                return;
                            }
                            
                            // Map filtered position to actual channel index (excluding APRS)
                            int actualIndex = 0;
                            int filteredIndex = 0;
                            
                            if (currentZoneChannels == null || currentZoneChannels.isEmpty()) {
                                // No zone selected - filter only APRS channels
                                for (int i = 0; i < channels.size(); i++) {
                                    Object channelData = channels.get(i);
                                    if (isAPRSChannel(channelData)) {
                                        continue;  // Skip APRS channels
                                    }
                                    if (filteredIndex == position) {
                                        actualIndex = i;
                                        break;
                                    }
                                    filteredIndex++;
                                }
                            } else {
                                // Zone selected - filter by zone AND exclude APRS
                                for (int i = 0; i < channels.size(); i++) {
                                    Object channelData = channels.get(i);
                                    if (isAPRSChannel(channelData)) {
                                        continue;  // Skip APRS channels
                                    }
                                    int channelNumber = XposedHelpers.getIntField(channelData, "number");
                                    
                                    if (currentZoneChannels.contains(channelNumber)) {
                                        if (filteredIndex == position) {
                                            actualIndex = i;
                                            break;
                                        }
                                        filteredIndex++;
                                    }
                                }
                            }
                            
                            // Replace the position argument with the actual index
                            param.args[0] = actualIndex;
                            
                        } catch (Throwable t) {
                            XposedBridge.log(TAG + ": Error mapping position in getView: " + t.getMessage());
                        }
                    }
                }
            );
            
            // Hook onItemClick to map filtered position to actual index for activation
            XposedHelpers.findAndHookMethod(
                channelFragmentClass,
                "onItemClick",
                android.widget.AdapterView.class,
                android.view.View.class,
                int.class,
                long.class,
                new XC_MethodHook() {
                    @Override
                    protected void beforeHookedMethod(MethodHookParam param) {
                        try {
                            int position = (Integer) param.args[2];
                            Object fragment = param.thisObject;
                            
                            // Get channels list
                            java.util.List<Object> channels = (java.util.List<Object>) 
                                XposedHelpers.getObjectField(fragment, "channels");
                            
                            if (channels == null) {
                                return;
                            }
                            
                            // Map filtered position to actual channel index (excluding APRS)
                            int actualIndex = 0;
                            int filteredIndex = 0;
                            
                            if (currentZoneChannels == null || currentZoneChannels.isEmpty()) {
                                // No zone selected - filter only APRS channels
                                for (int i = 0; i < channels.size(); i++) {
                                    Object channelData = channels.get(i);
                                    if (isAPRSChannel(channelData)) {
                                        continue;  // Skip APRS channels
                                    }
                                    if (filteredIndex == position) {
                                        actualIndex = i;
                                        break;
                                    }
                                    filteredIndex++;
                                }
                            } else {
                                // Zone selected - filter by zone AND exclude APRS
                                for (int i = 0; i < channels.size(); i++) {
                                    Object channelData = channels.get(i);
                                    if (isAPRSChannel(channelData)) {
                                        continue;  // Skip APRS channels
                                    }
                                    int channelNumber = XposedHelpers.getIntField(channelData, "number");
                                    
                                    if (currentZoneChannels.contains(channelNumber)) {
                                        if (filteredIndex == position) {
                                            actualIndex = i;
                                            break;
                                        }
                                        filteredIndex++;
                                    }
                                }
                            }
                            
                            // Replace position with actual index
                            param.args[2] = actualIndex;
                            
                            XposedBridge.log(TAG + ": Mapped click position " + position + 
                                " to actual index " + actualIndex);
                            
                        } catch (Throwable t) {
                            XposedBridge.log(TAG + ": Error mapping click position: " + t.getMessage());
                        }
                    }
                }
            );
            
            XposedBridge.log(TAG + ": ✓ Channel list filter and click hooks installed");
            
        } catch (Throwable t) {
            XposedBridge.log(TAG + ": Failed to hook channel list filter: " + t.getMessage());
            XposedBridge.log(t);
        }
    }
    
    /**
     * Hook to add zone button to InterPhoneChannelFragment
     */
    private void hookChannelListUI(XC_LoadPackage.LoadPackageParam lpparam) {
        try {
            Class<?> channelFragmentClass = XposedHelpers.findClass(
                "com.pri.prizeinterphone.fragment.InterPhoneChannelFragment",
                lpparam.classLoader
            );
            
            // Hook initData to add zone button after view is initialized
            XposedHelpers.findAndHookMethod(
                channelFragmentClass,
                "initData",
                new XC_MethodHook() {
                    @Override
                    protected void afterHookedMethod(MethodHookParam param) throws Throwable {
                        try {
                            Object fragment = param.thisObject;
                            
                            // Store fragment reference for refreshing after zone changes
                            channelFragmentInstance = fragment;
                            
                            android.content.Context context = (android.content.Context) 
                                XposedHelpers.callMethod(fragment, "getContext");
                            
                            if (context == null) {
                                XposedBridge.log(TAG + ": Context is null in channel fragment");
                                return;
                            }
                            
                            // Get the mLocalView field which is the fragment's root view
                            android.view.View rootView = (android.view.View) 
                                XposedHelpers.getObjectField(fragment, "mLocalView");
                            
                            if (rootView == null) {
                                XposedBridge.log(TAG + ": mLocalView is null in channel fragment");
                                return;
                            }
                            
                            XposedBridge.log(TAG + ": Adding zone button to channel fragment, root view: " + 
                                rootView.getClass().getName());
                            
                            // Check if button already exists
                            android.view.View existingButton = rootView.findViewWithTag("DMR_CHANNEL_ZONE_BTN");
                            if (existingButton != null) {
                                XposedBridge.log(TAG + ": Zone button already exists, updating text");
                                if (existingButton instanceof android.widget.Button) {
                                    ((android.widget.Button) existingButton).setText("Zone: " + currentZoneName);
                                    channelPageZoneButton = (android.widget.Button) existingButton;  // Store reference
                                }
                                return;
                            }
                            
                            // Create zone button
                            android.widget.Button channelZoneButton = new android.widget.Button(context);
                            channelZoneButton.setTag("DMR_CHANNEL_ZONE_BTN");
                            channelZoneButton.setText("Zone: " + currentZoneName);
                            channelZoneButton.setTextSize(android.util.TypedValue.COMPLEX_UNIT_SP, 12);
                            channelZoneButton.setTextColor(0xFFFFFFFF);
                            channelZoneButton.setPadding(
                                (int) (10 * context.getResources().getDisplayMetrics().density),
                                (int) (5 * context.getResources().getDisplayMetrics().density),
                                (int) (10 * context.getResources().getDisplayMetrics().density),
                                (int) (5 * context.getResources().getDisplayMetrics().density)
                            );
                            
                            // Store reference for sync with main zone button
                            channelPageZoneButton = channelZoneButton;
                            
                            // Button styling
                            android.graphics.drawable.GradientDrawable buttonDrawable = 
                                new android.graphics.drawable.GradientDrawable();
                            buttonDrawable.setColor(0xFF4169E1); // Royal blue
                            buttonDrawable.setCornerRadius(20 * context.getResources().getDisplayMetrics().density);
                            channelZoneButton.setBackground(buttonDrawable);
                            
                            // Button click listener
                            channelZoneButton.setOnClickListener(new android.view.View.OnClickListener() {
                                @Override
                                public void onClick(android.view.View v) {
                                    showZoneSelectionDialog(context, channelZoneButton, fragment);
                                }
                            });
                            
                            // Button layout params - position at top right
                            android.widget.FrameLayout.LayoutParams buttonParams = 
                                new android.widget.FrameLayout.LayoutParams(
                                    (int) (100 * context.getResources().getDisplayMetrics().density),
                                    android.widget.FrameLayout.LayoutParams.WRAP_CONTENT
                                );
                            buttonParams.gravity = android.view.Gravity.TOP | android.view.Gravity.END;
                            buttonParams.topMargin = (int) (8 * context.getResources().getDisplayMetrics().density);
                            buttonParams.rightMargin = (int) (8 * context.getResources().getDisplayMetrics().density);
                            
                            // Try to add to root view if it's a FrameLayout or ViewGroup
                            if (rootView instanceof android.widget.FrameLayout) {
                                ((android.widget.FrameLayout) rootView).addView(channelZoneButton, buttonParams);
                                XposedBridge.log(TAG + ": ✓ Zone button added to FrameLayout");
                            } else if (rootView instanceof android.view.ViewGroup) {
                                // Wrap in FrameLayout and add to parent
                                android.view.ViewParent parent = rootView.getParent();
                                if (parent instanceof android.view.ViewGroup) {
                                    android.widget.FrameLayout overlay = new android.widget.FrameLayout(context);
                                    overlay.setLayoutParams(new android.view.ViewGroup.LayoutParams(
                                        android.view.ViewGroup.LayoutParams.MATCH_PARENT,
                                        android.view.ViewGroup.LayoutParams.MATCH_PARENT
                                    ));
                                    overlay.addView(channelZoneButton, buttonParams);
                                    ((android.view.ViewGroup) parent).addView(overlay);
                                    XposedBridge.log(TAG + ": ✓ Zone button added via overlay to parent ViewGroup");
                                } else {
                                    XposedBridge.log(TAG + ": Could not add zone button - no suitable parent");
                                }
                            } else {
                                XposedBridge.log(TAG + ": Could not add zone button - root view is not a ViewGroup");
                            }
                            
                        } catch (Throwable t) {
                            XposedBridge.log(TAG + ": Error adding zone button to channel list: " + t.getMessage());
                            XposedBridge.log(t);
                        }
                    }
                }
            );
            
            XposedBridge.log(TAG + ": ✓ Channel list UI hook installed");
            
        } catch (Throwable t) {
            XposedBridge.log(TAG + ": Failed to hook channel list UI: " + t.getMessage());
            XposedBridge.log(t);
        }
    }
    
    /**
     * Show zone selection dialog and refresh channel list after selection
     */
    private static void showZoneSelectionDialog(final android.content.Context context, 
                                               final android.widget.Button button,
                                               final Object channelFragment) {
        try {
            ZoneDatabase zoneDb = ZoneDatabase.getInstance(context);
            java.util.List<ZoneDatabase.Zone> zones = zoneDb.getAllZones();
            
            // Build zone list
            java.util.List<String> zoneNames = new java.util.ArrayList<>();
            java.util.List<Long> zoneIds = new java.util.ArrayList<>();
            
            zoneNames.add("All Channels");
            zoneIds.add(-1L);
            
            for (ZoneDatabase.Zone zone : zones) {
                zoneNames.add(zone.name + " (" + zone.getChannelCount() + ")");
                zoneIds.add(zone.id);
            }
            
            // Show dialog
            android.app.AlertDialog.Builder builder = new android.app.AlertDialog.Builder(context);
            builder.setTitle("Select Zone");
            builder.setItems(zoneNames.toArray(new String[0]), 
                new android.content.DialogInterface.OnClickListener() {
                    @Override
                    public void onClick(android.content.DialogInterface dialog, int which) {
                        long selectedZoneId = zoneIds.get(which);
                        
                        if (selectedZoneId == -1) {
                            // All Channels mode
                            currentZoneId = -1;
                            currentZoneName = "All";
                            currentZoneChannels = null;
                        } else {
                            // Specific zone
                            ZoneDatabase.Zone selectedZone = zoneDb.getZone(selectedZoneId);
                            if (selectedZone != null) {
                                currentZoneId = selectedZoneId;
                                currentZoneName = selectedZone.name;
                                currentZoneChannels = selectedZone.getChannelList();
                            }
                        }
                        
                        // Update button text
                        button.setText("Zone: " + currentZoneName);
                        
                        // Update the main zone button if it exists
                        if (zoneButton != null) {
                            zoneButton.setText("Zone: " + currentZoneName);
                        }
                        
                        // Refresh the channel list
                        try {
                            XposedHelpers.callMethod(channelFragment, "initData");
                        } catch (Throwable t) {
                            XposedBridge.log(TAG + ": Error refreshing channel list: " + t.getMessage());
                        }
                        
                        dialog.dismiss();
                    }
                }
            );
            builder.show();
            
        } catch (Throwable t) {
            XposedBridge.log(TAG + ": Error showing zone selection dialog: " + t.getMessage());
            XposedBridge.log(t);
        }
    }
    
    /**
     * Helper method to recursively find a RadioGroup in the view hierarchy
     */
    private android.widget.RadioGroup findRadioGroupInView(View view) {
        if (view instanceof android.widget.RadioGroup) {
            return (android.widget.RadioGroup) view;
        }
        
        if (view instanceof ViewGroup) {
            ViewGroup group = (ViewGroup) view;
            for (int i = 0; i < group.getChildCount(); i++) {
                android.widget.RadioGroup result = findRadioGroupInView(group.getChildAt(i));
                if (result != null) {
                    return result;
                }
            }
        }
        
        return null;
    }
    
    // Helper method to log view hierarchy for debugging
    private void logViewHierarchy(View view, String prefix) {
        XposedBridge.log(TAG + ": " + prefix + " " + view.getClass().getSimpleName() + 
            " id=" + view.getId() + " " + (view instanceof ViewGroup ? "(" + ((ViewGroup)view).getChildCount() + " children)" : ""));
        
        if (view instanceof ViewGroup) {
            ViewGroup group = (ViewGroup) view;
            for (int i = 0; i < group.getChildCount() && i < 10; i++) {
                logViewHierarchy(group.getChildAt(i), prefix + "  ");
            }
        }
    }
    
    /**
     * Show zone selection dialog for channel edit with edit icons and create option
     */
    private static void showChannelEditZoneDialog(final android.content.Context context, 
                                                   final android.app.Activity activity,
                                                   final android.widget.TextView valueText,
                                                   final long[] selectedZoneId) {
        try {
            final ZoneDatabase db = ZoneDatabase.getInstance(context);
            final List<ZoneDatabase.Zone> zones = db.getAllZones();
            
            // Create custom ListView
            final android.widget.ListView listView = new android.widget.ListView(context);
            listView.setDivider(null);
            
            // Build item list: None + zones + Create New
            final List<String> displayItems = new ArrayList<>();
            final List<Long> itemIds = new ArrayList<>();
            final List<Boolean> isCreateNew = new ArrayList<>();
            
            // Add "None" option
            displayItems.add("None");
            itemIds.add(-1L);
            isCreateNew.add(false);
            
            // Add all zones
            for (ZoneDatabase.Zone zone : zones) {
                displayItems.add(zone.name);
                itemIds.add(zone.id);
                isCreateNew.add(false);
            }
            
            // Add "Create New Zone..." option
            displayItems.add("Create New Zone...");
            itemIds.add(-999L);  // Special ID for create new
            isCreateNew.add(true);
            
            // Dialog holder for access in adapter
            final AlertDialog[] dialogHolder = new AlertDialog[1];
            
            // Create custom adapter
            android.widget.BaseAdapter adapter = new android.widget.BaseAdapter() {
                @Override
                public int getCount() {
                    return displayItems.size();
                }
                
                @Override
                public Object getItem(int position) {
                    return displayItems.get(position);
                }
                
                @Override
                public long getItemId(int position) {
                    return position;
                }
                
                @Override
                public android.view.View getView(final int position, android.view.View convertView, android.view.ViewGroup parent) {
                    LinearLayout row = new LinearLayout(context);
                    row.setOrientation(LinearLayout.HORIZONTAL);
                    row.setPadding(40, 30, 40, 30);
                    row.setGravity(android.view.Gravity.CENTER_VERTICAL);
                    
                    // Zone name text
                    TextView nameText = new TextView(context);
                    nameText.setText(displayItems.get(position));
                    nameText.setTextSize(android.util.TypedValue.COMPLEX_UNIT_SP, 16);
                    nameText.setTextColor(0xFF000000);
                    if (isCreateNew.get(position)) {
                        nameText.setTextColor(0xFF4169E1);  // Blue for "Create New"
                        nameText.setTypeface(null, android.graphics.Typeface.BOLD);
                    }
                    
                    LinearLayout.LayoutParams nameParams = new LinearLayout.LayoutParams(
                        0,
                        LinearLayout.LayoutParams.WRAP_CONTENT,
                        1.0f
                    );
                    nameText.setLayoutParams(nameParams);
                    row.addView(nameText);
                    
                    // Add edit icon for zones (not for "None" or "Create New")
                    if (position > 0 && !isCreateNew.get(position)) {
                        TextView editIcon = new TextView(context);
                        editIcon.setText("✏");  // Pencil emoji
                        editIcon.setTextSize(android.util.TypedValue.COMPLEX_UNIT_SP, 20);
                        editIcon.setTextColor(0xFF666666);
                        editIcon.setPadding(20, 0, 20, 0);
                        editIcon.setClickable(true);
                        editIcon.setFocusable(true);
                        
                        // Make edit icon clickable
                        editIcon.setOnClickListener(new View.OnClickListener() {
                            @Override
                            public void onClick(View v) {
                                // Close the zone selection dialog
                                if (dialogHolder[0] != null) {
                                    dialogHolder[0].dismiss();
                                }
                                // Show edit zone name dialog
                                showEditZoneNameDialog(context, activity, itemIds.get(position), 
                                    displayItems.get(position), valueText, selectedZoneId);
                            }
                        });
                        
                        row.addView(editIcon);
                    }
                    
                    return row;
                }
            };
            
            listView.setAdapter(adapter);
            
            // Create dialog
            final AlertDialog.Builder builder = new AlertDialog.Builder(context);
            builder.setTitle("Select Zone");
            builder.setView(listView);
            builder.setNegativeButton("Cancel", null);
            dialogHolder[0] = builder.create();
            final AlertDialog dialog = dialogHolder[0];
            
            // Handle item clicks
            listView.setOnItemClickListener(new android.widget.AdapterView.OnItemClickListener() {
                @Override
                public void onItemClick(android.widget.AdapterView<?> parent, View view, int position, long id) {
                    // Check if edit icon was clicked
                    if (view instanceof LinearLayout) {
                        LinearLayout row = (LinearLayout) view;
                        if (row.getChildCount() > 1) {
                            View editIcon = row.getChildAt(1);
                            // Check if touch was on edit icon area (right 20% of row)
                            // For simplicity, we'll handle edit in a separate way - just select the zone for now
                        }
                    }
                    
                    if (isCreateNew.get(position)) {
                        // Show create new zone dialog
                        dialog.dismiss();
                        showCreateZoneDialog(context, activity, valueText, selectedZoneId);
                    } else {
                        // Select the zone
                        long oldZoneId = selectedZoneId[0];
                        selectedZoneId[0] = itemIds.get(position);
                        valueText.setText(displayItems.get(position));
                        XposedBridge.log(TAG + ": Zone selection changed from " + oldZoneId + " to " + selectedZoneId[0]);
                        
                        // Store in activity instance
                        XposedHelpers.setAdditionalInstanceField(activity, "dmrmod_selectedZoneId", selectedZoneId[0]);
                        dialog.dismiss();
                    }
                }
            });
            
            // Handle long clicks for editing zone names
            listView.setOnItemLongClickListener(new android.widget.AdapterView.OnItemLongClickListener() {
                @Override
                public boolean onItemLongClick(android.widget.AdapterView<?> parent, View view, int position, long id) {
                    // Allow editing for zones (not "None" or "Create New")
                    if (position > 0 && !isCreateNew.get(position)) {
                        dialogHolder[0].dismiss();
                        showEditZoneNameDialog(context, activity, itemIds.get(position), displayItems.get(position), valueText, selectedZoneId);
                        return true;
                    }
                    return false;
                }
            });
            
            dialog.show();
            
        } catch (Throwable t) {
            XposedBridge.log(TAG + ": Error showing zone selection dialog: " + t.getMessage());
            XposedBridge.log(t);
            Toast.makeText(context, "Error loading zones", Toast.LENGTH_SHORT).show();
        }
    }
    
    /**
     * Show dialog to create a new zone
     */
    private static void showCreateZoneDialog(final android.content.Context context,
                                             final android.app.Activity activity,
                                             final android.widget.TextView valueText,
                                             final long[] selectedZoneId) {
        try {
            final android.widget.EditText input = new android.widget.EditText(context);
            input.setHint("Zone name");
            input.setSingleLine(true);
            
            AlertDialog.Builder builder = new AlertDialog.Builder(context);
            builder.setTitle("Create New Zone");
            builder.setView(input);
            builder.setPositiveButton("Create", new DialogInterface.OnClickListener() {
                @Override
                public void onClick(DialogInterface dialog, int which) {
                    String zoneName = input.getText().toString().trim();
                    if (zoneName.isEmpty()) {
                        Toast.makeText(context, "Zone name cannot be empty", Toast.LENGTH_SHORT).show();
                        return;
                    }
                    
                    try {
                        ZoneDatabase db = ZoneDatabase.getInstance(context);
                        // Create new zone with empty channel list
                        ZoneDatabase.Zone newZone = new ZoneDatabase.Zone(-1, zoneName, new ArrayList<Integer>());
                        long newZoneId = db.saveZone(newZone);
                        
                        // Select the newly created zone
                        selectedZoneId[0] = newZoneId;
                        valueText.setText(zoneName);
                        XposedHelpers.setAdditionalInstanceField(activity, "dmrmod_selectedZoneId", newZoneId);
                        
                        Toast.makeText(context, "Zone created: " + zoneName, Toast.LENGTH_SHORT).show();
                        XposedBridge.log(TAG + ": Created new zone: " + zoneName + " with ID " + newZoneId);
                    } catch (Throwable t) {
                        XposedBridge.log(TAG + ": Error creating zone: " + t.getMessage());
                        Toast.makeText(context, "Error creating zone", Toast.LENGTH_SHORT).show();
                    }
                }
            });
            builder.setNegativeButton("Cancel", null);
            builder.show();
        } catch (Throwable t) {
            XposedBridge.log(TAG + ": Error showing create zone dialog: " + t.getMessage());
        }
    }
    
    /**
     * Show dialog to edit zone name
     */
    private static void showEditZoneNameDialog(final android.content.Context context,
                                               final android.app.Activity activity,
                                               final long zoneId,
                                               final String currentName,
                                               final android.widget.TextView valueText,
                                               final long[] selectedZoneId) {
        try {
            final android.widget.EditText input = new android.widget.EditText(context);
            input.setText(currentName);
            input.setSelection(currentName.length());  // Put cursor at end
            input.setSingleLine(true);
            
            AlertDialog.Builder builder = new AlertDialog.Builder(context);
            builder.setTitle("Edit Zone Name");
            builder.setView(input);
            builder.setPositiveButton("Save", new DialogInterface.OnClickListener() {
                @Override
                public void onClick(DialogInterface dialog, int which) {
                    String newName = input.getText().toString().trim();
                    if (newName.isEmpty()) {
                        Toast.makeText(context, "Zone name cannot be empty", Toast.LENGTH_SHORT).show();
                        return;
                    }
                    
                    try {
                        ZoneDatabase db = ZoneDatabase.getInstance(context);
                        ZoneDatabase.Zone zone = db.getZone(zoneId);
                        if (zone != null) {
                            // Update zone name
                            ZoneDatabase.Zone updatedZone = new ZoneDatabase.Zone(zone.id, newName, zone.getChannelList());
                            db.saveZone(updatedZone);
                            
                            // Update display if this is the selected zone
                            if (selectedZoneId[0] == zoneId) {
                                valueText.setText(newName);
                            }
                            
                            Toast.makeText(context, "Zone renamed to: " + newName, Toast.LENGTH_SHORT).show();
                            XposedBridge.log(TAG + ": Renamed zone " + zoneId + " from '" + currentName + "' to '" + newName + "'");
                        }
                    } catch (Throwable t) {
                        XposedBridge.log(TAG + ": Error renaming zone: " + t.getMessage());
                        Toast.makeText(context, "Error renaming zone", Toast.LENGTH_SHORT).show();
                    }
                }
            });
            builder.setNegativeButton("Cancel", null);
            builder.show();
        } catch (Throwable t) {
            XposedBridge.log(TAG + ": Error showing edit zone name dialog: " + t.getMessage());
        }
    }
    
    /**
     * Hook InterPhoneChannelActivity to add zone selector
     */
    private void hookChannelEditActivity(XC_LoadPackage.LoadPackageParam lpparam) {
        try {
            final Class<?> channelActivityClass = XposedHelpers.findClass(
                "com.pri.prizeinterphone.activity.InterPhoneChannelActivity",
                lpparam.classLoader
            );
            
            final Class<?> channelDataClass = XposedHelpers.findClass(
                "com.pri.prizeinterphone.serial.data.ChannelData",
                lpparam.classLoader
            );
            
            XposedBridge.log(TAG + ": Hooking InterPhoneChannelActivity.onCreate()");
            
            // Hook onCreate to add zone selector UI
            XposedHelpers.findAndHookMethod(
                channelActivityClass,
                "onCreate",
                Bundle.class,
                new XC_MethodHook() {
                    @Override
                    protected void afterHookedMethod(MethodHookParam param) throws Throwable {
                        try {
                            final Activity activity = (Activity) param.thisObject;
                            final Context context = activity;
                            
                            XposedBridge.log(TAG + ": InterPhoneChannelActivity onCreate - adding zone selector");
                            
                            // Find the ScrollView containing all channel settings
                            final int scrollViewId = context.getResources().getIdentifier("all_options", "id", context.getPackageName());
                            final android.widget.ScrollView scrollView = (android.widget.ScrollView) activity.findViewById(scrollViewId);
                            
                            if (scrollView == null) {
                                XposedBridge.log(TAG + ": Could not find ScrollView");
                                return;
                            }
                            
                            // Get the LinearLayout inside the ScrollView
                            ViewGroup container = (ViewGroup) scrollView.getChildAt(0);
                            if (container == null) {
                                XposedBridge.log(TAG + ": Could not find container LinearLayout");
                                return;
                            }
                            
                            // Get the channelData from the activity
                            final Object channelData = XposedHelpers.getObjectField(param.thisObject, "channelData");
                            
                            // Get current channel number
                            int channelNumber = -1;
                            if (channelData != null) {
                                channelNumber = XposedHelpers.getIntField(channelData, "number");
                            }
                            
                            // Get current zone for this channel
                            ZoneDatabase db = ZoneDatabase.getInstance(context);
                            final long currentZoneId = db.getZoneIdForChannel(channelNumber);
                            final String currentZoneName = (currentZoneId > 0) ? db.getZoneName(currentZoneId) : "None";
                            // Don't close singleton database
                            
                            XposedBridge.log(TAG + ": Channel " + channelNumber + " is in zone: " + currentZoneName + " (ID: " + currentZoneId + ")");
                            
                            // Create zone selector row (matching the style of other settings)
                            LinearLayout zoneRow = new LinearLayout(context);
                            zoneRow.setOrientation(LinearLayout.HORIZONTAL);
                            zoneRow.setClickable(true);
                            zoneRow.setFocusable(true);
                            
                            // Set background (same as other rows)
                            int bgResId = context.getResources().getIdentifier("interphone_channel_content_background_seletor", "drawable", context.getPackageName());
                            zoneRow.setBackgroundResource(bgResId);
                            
                            // Set layout params
                            LinearLayout.LayoutParams rowParams = new LinearLayout.LayoutParams(
                                LinearLayout.LayoutParams.MATCH_PARENT,
                                context.getResources().getDimensionPixelSize(
                                    context.getResources().getIdentifier("interphone_channel_content_height", "dimen", context.getPackageName())
                                )
                            );
                            int marginLeft = context.getResources().getDimensionPixelSize(
                                context.getResources().getIdentifier("interphone_channel_content_margin_left", "dimen", context.getPackageName())
                            );
                            int marginRight = context.getResources().getDimensionPixelSize(
                                context.getResources().getIdentifier("interphone_channel_content_margin_right", "dimen", context.getPackageName())
                            );
                            rowParams.setMargins(marginLeft, 10, marginRight, 0);
                            zoneRow.setLayoutParams(rowParams);
                            
                            // Create title TextView
                            TextView titleText = new TextView(context);
                            titleText.setText("Zone");
                            titleText.setTextColor(context.getResources().getColor(
                                context.getResources().getIdentifier("pri_text_color", "color", context.getPackageName())
                            ));
                            titleText.setTextSize(android.util.TypedValue.COMPLEX_UNIT_PX,
                                context.getResources().getDimensionPixelSize(
                                    context.getResources().getIdentifier("interphone_channel_content_title_size", "dimen", context.getPackageName())
                                )
                            );
                            titleText.setGravity(android.view.Gravity.CENTER_VERTICAL);
                            
                            LinearLayout.LayoutParams titleParams = new LinearLayout.LayoutParams(
                                context.getResources().getDimensionPixelSize(
                                    context.getResources().getIdentifier("interphone_channel_content_title_width", "dimen", context.getPackageName())
                                ),
                                LinearLayout.LayoutParams.WRAP_CONTENT
                            );
                            titleParams.leftMargin = context.getResources().getDimensionPixelSize(
                                context.getResources().getIdentifier("interphone_channel_content_title_margin_left", "dimen", context.getPackageName())
                            );
                            titleText.setLayoutParams(titleParams);
                            
                            // Create separator View
                            View separator = new View(context);
                            int separatorResId = context.getResources().getIdentifier("interphone_channel_more_split", "drawable", context.getPackageName());
                            separator.setBackgroundResource(separatorResId);
                            separator.setLayoutParams(new LinearLayout.LayoutParams(7, 13));
                            ((LinearLayout.LayoutParams) separator.getLayoutParams()).leftMargin = context.getResources().getDimensionPixelSize(
                                context.getResources().getIdentifier("interphone_channel_content_split_margin_left", "dimen", context.getPackageName())
                            );
                            ((LinearLayout.LayoutParams) separator.getLayoutParams()).gravity = android.view.Gravity.CENTER_VERTICAL;
                            
                            // Create value TextView
                            final TextView valueText = new TextView(context);
                            valueText.setText(currentZoneName);
                            valueText.setTextColor(context.getResources().getColor(
                                context.getResources().getIdentifier("pri_text_color", "color", context.getPackageName())
                            ));
                            valueText.setTextSize(android.util.TypedValue.COMPLEX_UNIT_PX,
                                context.getResources().getDimensionPixelSize(
                                    context.getResources().getIdentifier("interphone_channel_content_sub_size", "dimen", context.getPackageName())
                                )
                            );
                            valueText.setGravity(android.view.Gravity.CENTER_VERTICAL);
                            
                            LinearLayout.LayoutParams valueParams = new LinearLayout.LayoutParams(
                                LinearLayout.LayoutParams.MATCH_PARENT,
                                LinearLayout.LayoutParams.MATCH_PARENT
                            );
                            valueParams.leftMargin = context.getResources().getDimensionPixelSize(
                                context.getResources().getIdentifier("interphone_channel_content_split_margin_left", "dimen", context.getPackageName())
                            );
                            valueParams.rightMargin = context.getResources().getDimensionPixelSize(
                                context.getResources().getIdentifier("interphone_channel_content_title_margin_left", "dimen", context.getPackageName())
                            );
                            valueText.setLayoutParams(valueParams);
                            
                            // Assemble the row
                            zoneRow.addView(titleText);
                            zoneRow.addView(separator);
                            zoneRow.addView(valueText);
                            
                            // Store selected zone ID
                            final long[] selectedZoneId = {currentZoneId};
                            
                            // Set click listener to show zone selection dialog
                            zoneRow.setOnClickListener(new View.OnClickListener() {
                                @Override
                                public void onClick(View v) {
                                    showChannelEditZoneDialog(context, activity, valueText, selectedZoneId);
                                }
                            });
                            
                            // Store the initial zone ID in the activity instance
                            XposedHelpers.setAdditionalInstanceField(activity, "dmrmod_selectedZoneId", currentZoneId);
                            
                            // Add the zone row after the channel type row (index 2)
                            container.addView(zoneRow, 3);
                            
                            XposedBridge.log(TAG + ": Zone selector added to channel edit page");
                            
                        } catch (Throwable t) {
                            XposedBridge.log(TAG + ": Error in channel edit hook: " + t.getMessage());
                            XposedBridge.log(t);
                        }
                    }
                }
            );
            
            // Hook saveChannelData ONCE (globally, not per instance)
            XposedHelpers.findAndHookMethod(
                channelActivityClass,
                "saveChannelData",
                new XC_MethodHook() {
                    @Override
                    protected void afterHookedMethod(MethodHookParam saveParam) throws Throwable {
                        try {
                            Activity activity = (Activity) saveParam.thisObject;
                            Context context = activity;
                            
                            // Get the selected zone ID from the activity instance
                            Long selectedZoneId = (Long) XposedHelpers.getAdditionalInstanceField(activity, "dmrmod_selectedZoneId");
                            if (selectedZoneId == null) {
                                XposedBridge.log(TAG + ": No selectedZoneId found in activity instance, skipping zone save");
                                return;
                            }
                            
                            XposedBridge.log(TAG + ": saveChannelData called, selectedZoneId = " + selectedZoneId);
                            
                            Object channelData = XposedHelpers.getObjectField(saveParam.thisObject, "channelData");
                            if (channelData != null) {
                                int channelNumber = XposedHelpers.getIntField(channelData, "number");
                                XposedBridge.log(TAG + ": Saving zone assignment for channel " + channelNumber);
                                
                                ZoneDatabase db = ZoneDatabase.getInstance(context);
                                
                                // Log current zone before change
                                long currentZone = db.getZoneIdForChannel(channelNumber);
                                XposedBridge.log(TAG + ": Channel " + channelNumber + " currently in zone " + currentZone);
                                
                                // Remove channel from old zone
                                db.removeChannelFromAllZones(channelNumber);
                                XposedBridge.log(TAG + ": Removed channel " + channelNumber + " from all zones");
                                
                                // Add to new zone if one was selected
                                if (selectedZoneId > 0) {
                                    boolean success = db.addChannelToZone(selectedZoneId, channelNumber);
                                    XposedBridge.log(TAG + ": Channel " + channelNumber + " saved to zone ID " + selectedZoneId + ", success=" + success);
                                    
                                    // Verify it was saved
                                    long verifyZone = db.getZoneIdForChannel(channelNumber);
                                    XposedBridge.log(TAG + ": Verification: channel " + channelNumber + " is now in zone " + verifyZone);
                                } else {
                                    XposedBridge.log(TAG + ": Channel " + channelNumber + " removed from all zones (selectedZoneId=" + selectedZoneId + ")");
                                }
                                
                                // Refresh the channel list to reflect the zone change
                                if (channelFragmentInstance != null) {
                                    activity.runOnUiThread(new Runnable() {
                                        @Override
                                        public void run() {
                                            try {
                                                // Reload the current zone's channel list from database if a zone is active
                                                if (currentZoneId > 0) {
                                                    ZoneDatabase.Zone currentZone = db.getZone(currentZoneId);
                                                    if (currentZone != null) {
                                                        currentZoneChannels = currentZone.getChannelList();
                                                        XposedBridge.log(TAG + ": Reloaded zone " + currentZoneId + " channels: " + currentZoneChannels.size());
                                                    }
                                                }
                                                // Now refresh the channel list UI
                                                XposedHelpers.callMethod(channelFragmentInstance, "initData");
                                                XposedBridge.log(TAG + ": Channel list refreshed after zone change");
                                            } catch (Throwable t) {
                                                XposedBridge.log(TAG + ": Error refreshing channel list: " + t.getMessage());
                                            }
                                        }
                                    });
                                } else {
                                    XposedBridge.log(TAG + ": channelFragmentInstance is null, cannot refresh");
                                }
                                
                                // Don't close singleton database
                            } else {
                                XposedBridge.log(TAG + ": channelData is null in saveChannelData");
                            }
                        } catch (Throwable t) {
                            XposedBridge.log(TAG + ": Error saving zone assignment: " + t.getMessage());
                            XposedBridge.log(t);
                        }
                    }
                }
            );
            
            XposedBridge.log(TAG + ": Successfully hooked InterPhoneChannelActivity");
            
        } catch (Throwable t) {
            XposedBridge.log(TAG + ": Error hooking channel edit activity: " + t.getMessage());
            XposedBridge.log(t);
        }
    }
}

