package com.mediatek.common.prizeoption;

/**
 * Stub class for Prize ROM NVRAM utilities
 */
public class NvramUtils {
    public static String readUserNvramInfo(int index, int length) {
        // Return empty  string since we can't access real NVRAM
        return "";
    }
    
    public static boolean writeUserNvramInfo(int index, int length, String data) {
        // Stub - return false since we can't write to NVRAM
        return false;
    }
}
