package com.dmrmod.hooks;

import android.util.Log;

/**
 * JNI Wrapper for Dire Wolf AFSK decoder
 * Uses native Dire Wolf C code for high-quality APRS decoding
 */
public class DireWolfDecoder {
    private static final String TAG = "DireWolfDecoder";
    
    static {
        try {
            System.loadLibrary("direwolf_decoder");
            Log.i(TAG, "Dire Wolf native library loaded successfully");
        } catch (UnsatisfiedLinkError e) {
            Log.e(TAG, "Failed to load Dire Wolf native library: " + e.getMessage());
        }
    }
    
    /**
     * Decode AFSK audio using Dire Wolf's proven algorithm
     * 
     * @param audioSamples 16-bit PCM audio samples (48kHz mono)
     * @param sampleRate Sample rate (48000)
     * @return Array of decoded packet hex strings
     */
    public static native String[] nativeDecodeAudio(short[] audioSamples, int sampleRate);
    
    /**
     * Decode audio and return parsed APRS packets
     */
    public static byte[][] decodeAudio(short[] audioSamples) {
        try {
            String[] hexPackets = nativeDecodeAudio(audioSamples, 48000);
            
            if (hexPackets == null || hexPackets.length == 0) {
                return new byte[0][];
            }
            
            // Convert hex strings to byte arrays
            byte[][] packets = new byte[hexPackets.length][];
            for (int i = 0; i < hexPackets.length; i++) {
                packets[i] = hexStringToBytes(hexPackets[i]);
            }
            
            return packets;
        } catch (Exception e) {
            Log.e(TAG, "Error decoding audio: " + e.getMessage());
            return new byte[0][];
        }
    }
    
    /**
     * Convert hex string to byte array
     */
    private static byte[] hexStringToBytes(String hex) {
        int len = hex.length();
        byte[] data = new byte[len / 2];
        for (int i = 0; i < len; i += 2) {
            data[i / 2] = (byte) ((Character.digit(hex.charAt(i), 16) << 4)
                                + Character.digit(hex.charAt(i+1), 16));
        }
        return data;
    }
}
