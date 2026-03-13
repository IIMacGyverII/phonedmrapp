# Squelch Hardware Limitation Investigation

## Problem Summary
The radio hardware **firmware forces squelch to sq=2** for all values except sq=0. We cannot dynamically change squelch levels 1-9 at runtime.

## Evidence

### Test Results
- ✅ **sq=0 works** - Fully opens squelch (monitoring mode)
- ❌ **sq=1-9 don't work** - Hardware always responds with sq=2

### Log Evidence
```
ChannelData sq=9                    ← Database had sq=9
sendAnalogMessage INTERCEPTED
AnalogMessageHandler: handle: sq=2  ← Hardware FORCED it back to sq=2
```

Even when channel database has sq=9 and we activate that channel, hardware firmware overrides it to sq=2.

### What We Tried
1. **Direct AnalogMessage.send()** - Hardware ignored, returned sq=2
2. **State machine syncChannelInfoWithData()** - Hardware ignored, returned sq=2  
3. **Database save + state machine** - Hardware ignored, returned sq=2
4. **Setting channel in DB to sq=9 then activating** - Hardware forced to sq=2

## Current Working Solution
- **MON button** uses direct `AnalogMessage.send()` with sq=0 → Works perfectly
- Squelch sliders removed - only sq=0 (open) and sq=2 (normal) are possible

## TODO: Further Investigation

### 1. Search for Alternative Squelch Control Methods
- [ ] Search for `setSq` methods in decompiled code
- [ ] Look for UART commands related to squelch control
- [ ] Check if there's a special command for squelch adjustment
- [ ] Search for "squelch" in all UART/serial communication code

### 2. Investigate Firmware Commands
- [ ] Look for cmd values related to squelch in `Const.java` or similar
- [ ] Check if there's a separate squelch command (not part of AnalogMessage)
- [ ] Investigate if squelch needs to be set before channel activation
- [ ] Check if squelch is tied to volume or other settings

### 3. Check State Machine States
- [ ] Investigate if there's a separate squelch state in CmdStateMachine
- [ ] Look for methods that set squelch independently of channel data
- [ ] Check if squelch can be adjusted after channel is active

### 4. Database/Persistence Investigation  
- [ ] Check if squelch needs to be saved differently in database
- [ ] Look for channel update methods that properly persist squelch
- [ ] Investigate if there's a special flag/field for squelch control

### 5. Reverse Engineer Channel Edit Activity
- [ ] Analyze `InterPhoneChannelActivity.saveChannelData()` more deeply
- [ ] Check what happens when user changes squelch in channel editor
- [ ] See if channel editor has special logic for squelch that we're missing

## Code Locations to Search

### AnalogMessage Class
```
com.pri.prizeinterphone.message.AnalogMessage
- setSq(byte sq)
- send()
- encodeBody()
```

### DmrManager
```
com.pri.prizeinterphone.manager.DmrManager
- syncChannelInfoWithData(ChannelData)
- updateChannel(String areaId, ChannelData)
```

### State Machine
```
com.pri.prizeinterphone.state.CmdStateMachine
- SetChannelState
- sendAnalogMessage()
```

### UART/Serial Layer
```
com.pri.prizeinterphone.serial.*
- Look for squelch-specific commands
- Check UART TX/RX for squelch packets
```

## Original Squelch Slider Code (Removed)

### Intercom Page Squelch Slider
Location: `MainHook.java` lines ~1250-1330

```java
// Create squelch slider
LinearLayout squelchLayout = new LinearLayout(context);
squelchLayout.setOrientation(LinearLayout.HORIZONTAL);
squelchLayout.setPadding(0, 10, 0, 5);

TextView squelchLabel = new TextView(context);
squelchLabel.setText("Squelch: ");
squelchLabel.setTextColor(0xFFFFFFFF);
squelchLabel.setTextSize(16);
squelchLayout.addView(squelchLabel);

final TextView squelchValueText = new TextView(context);
squelchValueText.setTextColor(0xFFFFFFFF);
squelchValueText.setTextSize(16);
squelchValueText.setMinWidth(30);
squelchLayout.addView(squelchValueText);

final TextView squelchStatusIndicator = new TextView(context);
squelchStatusIndicator.setTextSize(16);
squelchStatusIndicator.setPadding(10, 0, 0, 0);
squelchStatusIndicator.setVisibility(View.INVISIBLE);
squelchLayout.addView(squelchStatusIndicator);

mainLayout.addView(squelchLayout);

SeekBar squelchSeekBar = new SeekBar(context);
squelchSeekBar.setMax(9);
squelchSeekBar.setProgress(currentSquelchLevel);
squelchValueText.setText(String.valueOf(currentSquelchLevel));

squelchSeekBar.setOnSeekBarChangeListener(new SeekBar.OnSeekBarChangeListener() {
    private Object dmrManagerInstance = null;
    
    @Override
    public void onProgressChanged(SeekBar seekBar, int progress, boolean fromUser) {
        if (fromUser) {
            squelchValueText.setText(String.valueOf(progress));
            squelchStatusIndicator.setText("⟳");
            squelchStatusIndicator.setTextColor(0xFFFFAA00);
            squelchStatusIndicator.setVisibility(View.VISIBLE);
            
            // Apply squelch change using direct send (like MON button)
            try {
                Class<?> dmrManagerClass = XposedHelpers.findClass(
                    "com.pri.prizeinterphone.manager.DmrManager",
                    context.getClassLoader()
                );
                dmrManagerInstance = XposedHelpers.callStaticMethod(dmrManagerClass, "getInstance");
                Object currentChannel = XposedHelpers.callMethod(dmrManagerInstance, "getCurrentChannel");
                
                if (currentChannel != null) {
                    // Manually construct and send AnalogMessage (EXACTLY like MON button)
                    Class<?> analogMessageClass = XposedHelpers.findClass(
                        "com.pri.prizeinterphone.message.AnalogMessage",
                        context.getClassLoader()
                    );
                    Object analogMessage = analogMessageClass.newInstance();
                    
                    // Copy all channel fields from current channel
                    XposedHelpers.callMethod(analogMessage, "setBand", (byte) XposedHelpers.getIntField(currentChannel, "band"));
                    XposedHelpers.callMethod(analogMessage, "setPower", (byte) XposedHelpers.getIntField(currentChannel, "power"));
                    XposedHelpers.callMethod(analogMessage, "setTxFreq", XposedHelpers.getIntField(currentChannel, "txFreq"));
                    XposedHelpers.callMethod(analogMessage, "setRxFreq", XposedHelpers.getIntField(currentChannel, "rxFreq"));
                    XposedHelpers.callMethod(analogMessage, "setSq", (byte) progress);  // Set target squelch
                    XposedHelpers.callMethod(analogMessage, "setRxType", (byte) XposedHelpers.getIntField(currentChannel, "rxType"));
                    XposedHelpers.callMethod(analogMessage, "setRxSubCode", (byte) XposedHelpers.getIntField(currentChannel, "rxSubCode"));
                    XposedHelpers.callMethod(analogMessage, "setTxType", (byte) XposedHelpers.getIntField(currentChannel, "txType"));
                    XposedHelpers.callMethod(analogMessage, "setTxSubCode", (byte) XposedHelpers.getIntField(currentChannel, "txSubCode"));
                    XposedHelpers.callMethod(analogMessage, "setRelay", (byte) XposedHelpers.getIntField(currentChannel, "relay"));
                    
                    // Send directly to hardware (NO updateChannel, NO state machine)
                    XposedHelpers.callMethod(analogMessage, "send");
                    
                    // Update channel object field (for APRS backup consistency)
                    XposedHelpers.setIntField(currentChannel, "sq", progress);
                    
                    XposedBridge.log(TAG + ": ✅ Intercom squelch slider updated to " + progress + " (direct send only)");
                    
                } else {
                    // No current channel
                    squelchStatusIndicator.setText("✗");
                    squelchStatusIndicator.setTextColor(0xFFFF0000);  // Red
                    XposedBridge.log(TAG + ": ✗ No current channel for squelch update");
                }
            } catch (Throwable t) {
                XposedBridge.log(TAG + ": Error updating intercom squelch: " + t.getMessage());
                XposedBridge.log(t);
                
                // Show error indicator
                squelchStatusIndicator.setText("✗");
                squelchStatusIndicator.setTextColor(0xFFFF0000);  // Red
            }
        }
    }
    
    @Override
    public void onStartTrackingTouch(android.widget.SeekBar seekBar) {}
    
    @Override
    public void onStopTrackingTouch(android.widget.SeekBar seekBar) {
        // Show success indicator if no exception was thrown during send
        if (squelchStatusIndicator.getText().equals("⟳")) {
            squelchStatusIndicator.setText("✓");
            squelchStatusIndicator.setTextColor(0xFF00FF00);  // Green
            XposedBridge.log(TAG + ": ✓ Squelch send completed: " + seekBar.getProgress());
            
            // Hide indicator after 2 seconds
            new android.os.Handler(android.os.Looper.getMainLooper()).postDelayed(new Runnable() {
                @Override
                public void run() {
                    squelchStatusIndicator.setVisibility(View.INVISIBLE);
                }
            }, 2000);
        }
    }
});
mainLayout.addView(squelchSeekBar);
```

### APRS Monitoring Page Squelch Slider
Location: `MainHook.java` lines ~3665-3750

```java
// Squelch control
TextView squelchLabel = new TextView(activity);
squelchLabel.setText("Squelch Level:");
squelchLabel.setTextSize(16);
squelchLabel.setTypeface(null, android.graphics.Typeface.BOLD);
mainLayout.addView(squelchLabel);

LinearLayout squelchLayout = new LinearLayout(activity);
squelchLayout.setOrientation(LinearLayout.HORIZONTAL);
squelchLayout.setPadding(0, 5, 0, 10);

final TextView squelchValueText = new TextView(activity);
squelchValueText.setText(String.valueOf(db.getAprsSquelch()));
squelchValueText.setTextSize(18);
squelchValueText.setTextColor(0xFF00FF00);
squelchValueText.setMinWidth(50);
squelchLayout.addView(squelchValueText);

TextView squelchInfo2 = new TextView(activity);
squelchInfo2.setText(" (0=most sensitive, 9=least)");
squelchInfo2.setTextSize(12);
squelchInfo2.setTextColor(0xFF999999);
squelchLayout.addView(squelchInfo2);

mainLayout.addView(squelchLayout);

final android.widget.SeekBar squelchSeekBar = new android.widget.SeekBar(activity);
squelchSeekBar.setMax(9);
squelchSeekBar.setProgress(db.getAprsSquelch());
squelchSeekBar.setOnSeekBarChangeListener(new android.widget.SeekBar.OnSeekBarChangeListener() {
    private Object dmrManagerInstance = null;
    
    @Override
    public void onProgressChanged(android.widget.SeekBar seekBar, int progress, boolean fromUser) {
        if (fromUser) {
            squelchValueText.setText(String.valueOf(progress));
            db.setAprsSquelch(progress);
            
            // Get current channel and send directly (EXACTLY like MON button)
            try {
                Class<?> dmrManagerClass = XposedHelpers.findClass(
                    "com.pri.prizeinterphone.manager.DmrManager",
                    appClassLoader
                );
                dmrManagerInstance = XposedHelpers.callStaticMethod(dmrManagerClass, "getInstance");
                Object currentChannel = XposedHelpers.callMethod(dmrManagerInstance, "getCurrentChannel");
                
                if (currentChannel != null) {
                    // Manually construct and send AnalogMessage (EXACTLY like MON button)
                    try {
                        Class<?> analogMessageClass = XposedHelpers.findClass(
                            "com.pri.prizeinterphone.message.AnalogMessage",
                            appClassLoader
                        );
                        Object analogMessage = analogMessageClass.newInstance();
                        
                        // Copy all fields from current channel
                        XposedHelpers.callMethod(analogMessage, "setBand", (byte) XposedHelpers.getIntField(currentChannel, "band"));
                        XposedHelpers.callMethod(analogMessage, "setPower", (byte) XposedHelpers.getIntField(currentChannel, "power"));
                        XposedHelpers.callMethod(analogMessage, "setTxFreq", XposedHelpers.getIntField(currentChannel, "txFreq"));
                        XposedHelpers.callMethod(analogMessage, "setRxFreq", XposedHelpers.getIntField(currentChannel, "rxFreq"));
                        XposedHelpers.callMethod(analogMessage, "setSq", (byte) progress);  // Set target squelch
                        XposedHelpers.callMethod(analogMessage, "setRxType", (byte) XposedHelpers.getIntField(currentChannel, "rxType"));
                        XposedHelpers.callMethod(analogMessage, "setRxSubCode", (byte) XposedHelpers.getIntField(currentChannel, "rxSubCode"));
                        XposedHelpers.callMethod(analogMessage, "setTxType", (byte) XposedHelpers.getIntField(currentChannel, "txType"));
                        XposedHelpers.callMethod(analogMessage, "setTxSubCode", (byte) XposedHelpers.getIntField(currentChannel, "txSubCode"));
                        XposedHelpers.callMethod(analogMessage, "setRelay", (byte) XposedHelpers.getIntField(currentChannel, "relay"));
                        
                        // Send directly to hardware (NO updateChannel, NO state machine)
                        XposedHelpers.callMethod(analogMessage, "send");
                        
                        // Update channel object field (for consistency)
                        XposedHelpers.setIntField(currentChannel, "sq", progress);
                        
                        XposedBridge.log(TAG + ": ✅ APRS squelch updated to " + progress + " (direct send only)");
                        
                    } catch (Throwable sendError) {
                        XposedBridge.log(TAG + ": Error updating APRS squelch: " + sendError.getMessage());
                        XposedBridge.log(sendError);
                    }
                }
            } catch (Exception e) {
                XposedBridge.log(TAG + ": Error updating APRS squelch: " + e.getMessage());
            }
        }
    }
    @Override
    public void onStartTrackingTouch(android.widget.SeekBar seekBar) {}
    @Override
    public void onStopTrackingTouch(android.widget.SeekBar seekBar) {
        XposedBridge.log(TAG + ": ✓ APRS squelch send completed: " + seekBar.getProgress());
    }
});
squelchLayout.addView(squelchSeekBar);
mainLayout.addView(squelchLayout);

TextView squelchInfo = new TextView(activity);
squelchInfo.setText("Adjust squelch while monitoring (0=most sensitive, 9=least)");
squelchInfo.setTextSize(11);
squelchInfo.setTextColor(0xFF999999);
squelchInfo.setPadding(0, 2, 0, 20);
mainLayout.addView(squelchInfo);
```

## Hardware Limitation Confirmed
The radio firmware **only accepts sq=0 or sq=2**. All other values are rejected and forced to sq=2. This is likely a hardware design decision for stability/safety.
