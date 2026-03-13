package com.dmrmod.hooks;

import android.content.Context;

import java.util.List;

import de.robv.android.xposed.XposedBridge;

/**
 * APRS Receiver - Captures and decodes incoming APRS packets
 */
public class APRSReceiver {
    private static final String TAG = "DMRModHooks-APRS-Receiver";
    
    private static APRSReceiver instance;
    private Context context;
    
    private APRSReceiver(Context context) {
        this.context = context.getApplicationContext();
    }
    
    public static synchronized APRSReceiver getInstance(Context context) {
        if (instance == null) {
            instance = new APRSReceiver(context);
        }
        return instance;
    }
    
    /**
     * Process incoming audio samples (called by hook)
     */
    public void processAudio(short[] audioSamples, int channelNumber) {
        try {
            if (audioSamples == null || audioSamples.length < 4800) {
                return; // Need at least 0.1 second of audio (100ms minimum)
            }
            
            XposedBridge.log(TAG + ": Processing " + audioSamples.length + " audio samples");
            
            // Decode AFSK to packets
            List<byte[]> packets = AFSKDecoder.decode(audioSamples);
            
            if (packets.isEmpty()) {
                return;
            }
            
            XposedBridge.log(TAG + ": Found " + packets.size() + " packets");
            
            // Parse each packet
            APRSReceivedDatabase db = APRSReceivedDatabase.getInstance(context);
            
            for (byte[] packet : packets) {
                APRSPacketDecoder.APRSPacket aprsPacket = APRSPacketDecoder.decode(packet);
                
                if (aprsPacket.isValid) {
                    XposedBridge.log(TAG + ": ✓ Received APRS: " + aprsPacket.toString());
                    
                    // Store in database
                    db.storeStation(aprsPacket, channelNumber);
                    
                    // Show notification (optional)
                    showNotification(aprsPacket);
                }
            }
            
        } catch (Exception e) {
            XposedBridge.log(TAG + ": Error processing audio: " + e.getMessage());
            e.printStackTrace();
        }
    }
    
    /**
     * Show notification for received station
     */
    private void showNotification(APRSPacketDecoder.APRSPacket packet) {
        // TODO: Show a toast or notification
        // For now, just log it
        XposedBridge.log(TAG + ": 📡 " + packet.sourceCallsign + "-" + packet.sourceSSID + 
                " @ " + String.format("%.6f, %.6f", packet.latitude, packet.longitude));
    }
}
