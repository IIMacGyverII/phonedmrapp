// ============================================================================
// MONITORING MODE TOGGLE - Add this code to DMRModHooks/app/src/main/java/com/dmrmod/hooks/MainHook.java
// ============================================================================
//
// INSTALLATION:
// 1. Add the field declaration to MainHook class (top section with other static fields)
// 2. Add the hookMonitoringMode() method (place before closing brace of MainHook class)
// 3. Call hookMonitoringMode(lpparam); in handleLoadPackage() after other hook calls
// 4. Build and install: ./gradlew assembleDebug; adb install -r app/build/outputs/apk/debug/app-debug.apk
//
// USAGE:
// Toggle appears in bottom-right of TalkBack screen (main home screen)
// - OFF (default): GROUP mode - hardware filters to configured talkgroups
// - ON: ALL mode - hardware receives all DMR traffic on timeslot/color code
//
// ============================================================================

// ============================================================================
// STEP 1: Add this field declaration at top of MainHook class (around line 100)
// ============================================================================

    // Monitoring mode toggle button (for ALL mode workaround)
    private static android.widget.CompoundButton monitoringModeToggle = null;
    private static volatile boolean isMonitoringMode = false;

// ============================================================================
// STEP 2: Add this method to MainHook class (place near end, before closing brace)
// ============================================================================

    /**
     * Hook InterPhoneTalkBackFragment to add Monitoring Mode toggle
     * 
     * MONITORING MODE: Toggles between GROUP (contactType=1) and ALL (contactType=2) modes.
     * 
     * CONTEXT:
     * The Ulefone Armor 26 Ultra DMR module ignores RX group lists when contactType=GROUP,
     * only receiving private calls. This toggle switches to ALL mode as a workaround,
     * which should make the hardware receive all DMR traffic on the configured timeslot
     * and color code (unfiltered).
     * 
     * DATABASE UPDATES:
     * - contactType: 1 (GROUP) ↔ 2 (ALL)
     * - txContact: When ALL, set to 0xFFFFFF (16777215) per app convention
     * - Changes persist across app restarts
     * 
     * HARDWARE COMMUNICATION:
     * Calls DmrManager.syncChannelInfoWithData() to immediately send updated DigitalMessage
     * to the DMR module, triggering hardware reconfiguration.
     * 
     * UI LOCATION:
     * Bottom-right corner of TalkBack fragment (main home screen), positioned below
     * any existing status indicators or recording toggle.
     * 
     * @param lpparam LSPosed package parameter for reflection and hooking
     */
    private void hookMonitoringModeToggle(XC_LoadPackage.LoadPackageParam lpparam) {
        try {
            Class<?> talkBackFragmentClass = XposedHelpers.findClass(
                "com.pri.prizeinterphone.fragment.InterPhoneTalkBackFragment",
                lpparam.classLoader
            );
            
            XposedHelpers.findAndHookMethod(
                talkBackFragmentClass,
                "onViewCreated",
                View.class,
                Bundle.class,
                new XC_MethodHook() {
                    @Override
                    protected void afterHookedMethod(MethodHookParam param) throws Throwable {
                        try {
                            View fragmentView = (View) param.args[0];
                            final Context context = fragmentView.getContext();
                            
                            // Find the root ViewGroup of the fragment
                            ViewGroup rootView = null;
                            if (fragmentView instanceof ViewGroup) {
                                rootView = (ViewGroup) fragmentView;
                            } else if (fragmentView.getParent() instanceof ViewGroup) {
                                rootView = (ViewGroup) fragmentView.getParent();
                            }
                            
                            if (rootView == null) {
                                XposedBridge.log(TAG + ": MonitoringMode: Could not find root ViewGroup");
                                return;
                            }
                            
                            // Check if toggle already exists (prevent duplicates on orientation change)
                            if (monitoringModeToggle != null && monitoringModeToggle.getParent() != null) {
                                ((ViewGroup) monitoringModeToggle.getParent()).removeView(monitoringModeToggle);
                            }
                            
                            // Create ToggleButton for Monitoring Mode
                            final android.widget.ToggleButton toggleButton = new android.widget.ToggleButton(context);
                            toggleButton.setTextOn("MONITOR: ON");
                            toggleButton.setTextOff("MONITOR: OFF");
                            toggleButton.setTextSize(10);
                            toggleButton.setPadding(8, 4, 8, 4);
                            
                            // Position in bottom-right corner
                            FrameLayout.LayoutParams layoutParams = new FrameLayout.LayoutParams(
                                FrameLayout.LayoutParams.WRAP_CONTENT,
                                FrameLayout.LayoutParams.WRAP_CONTENT
                            );
                            layoutParams.gravity = android.view.Gravity.BOTTOM | android.view.Gravity.END;
                            layoutParams.rightMargin = 16;
                            layoutParams.bottomMargin = 100; // Above bottom nav bar
                            toggleButton.setLayoutParams(layoutParams);
                            
                            // Get DmrManager and current channel to initialize toggle state
                            toggleButton.post(new Runnable() {
                                @Override
                                public void run() {
                                    try {
                                        Class<?> dmrManagerClass = XposedHelpers.findClass(
                                            "com.pri.prizeinterphone.manager.DmrManager",
                                            context.getClassLoader()
                                        );
                                        
                                        Object dmrManager = XposedHelpers.callStaticMethod(
                                            dmrManagerClass,
                                            "getInstance"
                                        );
                                        
                                        Object currentChannel = XposedHelpers.callMethod(
                                            dmrManager,
                                            "getCurrentChannel"
                                        );
                                        
                                        if (currentChannel != null) {
                                            int channelType = (int) XposedHelpers.callMethod(currentChannel, "getType");
                                            
                                            // Only enable toggle for digital/DMR channels (type=0)
                                            if (channelType == 0) {
                                                int contactType = (int) XposedHelpers.callMethod(currentChannel, "getContactType");
                                                boolean isMonitoring = (contactType == 2); // ALL mode
                                                toggleButton.setChecked(isMonitoring);
                                                toggleButton.setEnabled(true);
                                                isMonitoringMode = isMonitoring;
                                                
                                                XposedBridge.log(TAG + ": MonitoringMode initialized - Channel type=" + channelType + 
                                                    ", contactType=" + contactType + ", monitoring=" + isMonitoring);
                                            } else {
                                                // Analog channel - disable monitoring toggle
                                                toggleButton.setEnabled(false);
                                                toggleButton.setAlpha(0.5f);
                                                XposedBridge.log(TAG + ": MonitoringMode disabled - Channel is analog (type=" + channelType + ")");
                                            }
                                        }
                                    } catch (Throwable t) {
                                        XposedBridge.log(TAG + ": MonitoringMode: Error initializing toggle state: " + t.getMessage());
                                        XposedBridge.log(t);
                                    }
                                }
                            });
                            
                            // Toggle click handler
                            toggleButton.setOnClickListener(new View.OnClickListener() {
                                @Override
                                public void onClick(View v) {
                                    try {
                                        boolean newState = toggleButton.isChecked();
                                        isMonitoringMode = newState;
                                        
                                        XposedBridge.log(TAG + ": MonitoringMode toggle clicked - new state: " + 
                                            (newState ? "ON (ALL mode)" : "OFF (GROUP mode)"));
                                        
                                        // Get DmrManager instance
                                        Class<?> dmrManagerClass = XposedHelpers.findClass(
                                            "com.pri.prizeinterphone.manager.DmrManager",
                                            context.getClassLoader()
                                        );
                                        
                                        Object dmrManager = XposedHelpers.callStaticMethod(
                                            dmrManagerClass,
                                            "getInstance"
                                        );
                                        
                                        // Get current channel
                                        Object currentChannel = XposedHelpers.callMethod(
                                            dmrManager,
                                            "getCurrentChannel"
                                        );
                                        
                                        if (currentChannel == null) {
                                            Toast.makeText(context, "No channel selected", Toast.LENGTH_SHORT).show();
                                            XposedBridge.log(TAG + ": MonitoringMode: No current channel");
                                            toggleButton.setChecked(!newState); // Revert toggle
                                            return;
                                        }
                                        
                                        // Check if channel is digital (DMR)
                                        int channelType = (int) XposedHelpers.callMethod(currentChannel, "getType");
                                        if (channelType != 0) {
                                            Toast.makeText(context, "Monitoring mode only for DMR channels", Toast.LENGTH_SHORT).show();
                                            XposedBridge.log(TAG + ": MonitoringMode: Channel is not DMR (type=" + channelType + ")");
                                            toggleButton.setChecked(!newState); // Revert toggle
                                            return;
                                        }
                                        
                                        // Get current contactType before change
                                        int oldContactType = (int) XposedHelpers.callMethod(currentChannel, "getContactType");
                                        int oldTxContact = (int) XposedHelpers.callMethod(currentChannel, "getTxContact");
                                        
                                        // Update channel configuration
                                        int newContactType = newState ? 2 : 1; // 2=ALL, 1=GROUP
                                        int newTxContact = newState ? 16777215 : oldTxContact; // 0xFFFFFF for ALL mode
                                        
                                        XposedHelpers.callMethod(currentChannel, "setContactType", newContactType);
                                        XposedHelpers.callMethod(currentChannel, "setTxContact", newTxContact);
                                        
                                        XposedBridge.log(TAG + ": MonitoringMode: Updated channel - contactType: " + 
                                            oldContactType + " → " + newContactType + ", txContact: " + 
                                            oldTxContact + " → " + newTxContact);
                                        
                                        // Update database
                                        XposedHelpers.callMethod(dmrManager, "updateChannel", currentChannel);
                                        XposedBridge.log(TAG + ": MonitoringMode: Database updated");
                                        
                                        // Trigger hardware update (resend DigitalMessage)
                                        // This calls sendDigitalMessage() which will include the new contactType
                                        XposedHelpers.callMethod(dmrManager, "syncChannelInfoWithData", currentChannel);
                                        XposedBridge.log(TAG + ": MonitoringMode: Hardware update triggered (syncChannelInfoWithData)");
                                        
                                        // User feedback
                                        String toastMessage = newState ? 
                                            "Monitoring Mode: ON (receiving all DMR traffic)" :
                                            "Monitoring Mode: OFF (filtered to group list)";
                                        Toast.makeText(context, toastMessage, Toast.LENGTH_LONG).show();
                                        
                                        XposedBridge.log(TAG + ": MonitoringMode: Successfully toggled to " + 
                                            (newState ? "ALL" : "GROUP") + " mode");
                                        
                                    } catch (Throwable t) {
                                        XposedBridge.log(TAG + ": MonitoringMode: Error in toggle handler: " + t.getMessage());
                                        XposedBridge.log(t);
                                        Toast.makeText(context, "Error toggling monitoring mode", Toast.LENGTH_SHORT).show();
                                        // Revert toggle on error
                                        toggleButton.setChecked(!toggleButton.isChecked());
                                    }
                                }
                            });
                            
                            // Add toggle to layout
                            if (rootView instanceof FrameLayout) {
                                ((FrameLayout) rootView).addView(toggleButton);
                            } else {
                                // Wrap in FrameLayout if root is not FrameLayout
                                FrameLayout wrapper = new FrameLayout(context);
                                wrapper.setLayoutParams(new ViewGroup.LayoutParams(
                                    ViewGroup.LayoutParams.MATCH_PARENT,
                                    ViewGroup.LayoutParams.MATCH_PARENT
                                ));
                                wrapper.addView(toggleButton);
                                rootView.addView(wrapper);
                            }
                            
                            monitoringModeToggle = toggleButton;
                            XposedBridge.log(TAG + ": MonitoringMode toggle added to TalkBack fragment");
                            
                        } catch (Throwable t) {
                            XposedBridge.log(TAG + ": MonitoringMode: Error adding toggle: " + t.getMessage());
                            XposedBridge.log(t);
                        }
                    }
                }
            );
            
            XposedBridge.log(TAG + ": Successfully hooked InterPhoneTalkBackFragment for Monitoring Mode");
            
        } catch (Throwable t) {
            XposedBridge.log(TAG + ": Error hooking Monitoring Mode: " + t.getMessage());
            XposedBridge.log(t);
        }
    }

// ============================================================================
// STEP 3: Add this call to handleLoadPackage() method (around line 150)
// ============================================================================

        // Add this line after other hook calls (e.g., after hookDmrManager(lpparam);)
        hookMonitoringModeToggle(lpparam);

// ============================================================================
// STEP 4: Update VERSION constant at top of MainHook class
// ============================================================================

    private static final String VERSION = "1.7.0"; // Updated from 1.6.0

// ============================================================================
// END OF MONITORING MODE CODE
// ============================================================================
