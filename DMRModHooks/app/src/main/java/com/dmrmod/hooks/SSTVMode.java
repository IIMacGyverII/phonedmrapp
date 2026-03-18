package com.dmrmod.hooks;

/**
 * SSTV Mode Definitions
 * 
 * Defines all supported SSTV modes with their technical parameters.
 * VIS codes identify which mode is being transmitted.
 */
public class SSTVMode {
    
    // Mode identifiers
    public static final int MODE_ROBOT_36 = 0x08;    // VIS code 8
    public static final int MODE_ROBOT_72 = 0x0C;    // VIS code 12
    public static final int MODE_MARTIN_M1 = 0x2C;   // VIS code 44
    public static final int MODE_MARTIN_M2 = 0x28;   // VIS code 40
    public static final int MODE_SCOTTIE_S1 = 0x3C;  // VIS code 60
    public static final int MODE_SCOTTIE_S2 = 0x38;  // VIS code 56
    public static final int MODE_SCOTTIE_DX = 0x4C;  // VIS code 76
    public static final int MODE_PD_120 = 0x5F;      // VIS code 95
    public static final int MODE_PD_180 = 0x60;      // VIS code 96
    public static final int MODE_ROBOT_8_BW  = 0x02; // VIS code 2
    public static final int MODE_ROBOT_12_BW = 0x03; // VIS code 3
    public static final int MODE_ROBOT_24_C  = 0x04; // VIS code 4 — Robot 24 Color (Y+Ry+By, FIVE_MS)
    
    // Unknown mode
    public static final int MODE_UNKNOWN = -1;
    
    // Sync pulse family constants
    public static final int SYNC_FAMILY_FIVE_MS   = 5;   // Martin M1/M2 (4.862ms sync)
    public static final int SYNC_FAMILY_NINE_MS   = 9;   // Robot, Scottie
    public static final int SYNC_FAMILY_TWENTY_MS = 20;  // PD modes

    /**
     * SSTV Mode class containing all technical parameters
     */
    public static class Mode {
        public final int visCode;
        public final String name;
        public final int width;
        public final int height;
        public final boolean isRGB;  // true = RGB, false = YUV
        public final int durationMs;  // Total transmission time
        public final float lineDurationMs;  // Color channel scan time (ms)
        public final float fullLineDurationMs; // Total sync-to-sync line duration (ms)
        public final int colorChannels;  // 1 = mono, 3 = RGB/YUV
        public final int syncFamily;  // SYNC_FAMILY_* constant

        public Mode(int visCode, String name, int width, int height, boolean isRGB,
                   int durationMs, float lineDurationMs, float fullLineDurationMs,
                   int colorChannels, int syncFamily) {
            this.visCode = visCode;
            this.name = name;
            this.width = width;
            this.height = height;
            this.isRGB = isRGB;
            this.durationMs = durationMs;
            this.lineDurationMs = lineDurationMs;
            this.fullLineDurationMs = fullLineDurationMs;
            this.colorChannels = colorChannels;
            this.syncFamily = syncFamily;
        }

        /** Expected samples per scan line at given sample rate */
        public int fullLineSamples(int sampleRate) {
            return (int) Math.round(fullLineDurationMs * sampleRate / 1000.0);
        }
    }

    // Mode database
    // fullLineDurationMs = sync + separators/porches + 3 * channel
    // Scottie: 9ms sync + 3*1.5ms sep + 3*channelMs
    // Martin:  4.862ms sync + 0.572ms porch + 3*channelMs + 2*0.572ms sep
    // Robot:   full line duration (sync+porch+Y+UV) — already expressed as lineDurationMs
    // PD:      20ms sync + 2.08ms porch + 3*channelMs
    private static final Mode[] MODES = {
        // Robot modes (YUV) — fullLine = sync(9) + porch(3) + Y(88) + sep(3) + Cb(44) + sep(3) + Cr(44) ≈ 150ms
        new Mode(MODE_ROBOT_36, "Robot 36",  320, 240, false, 36000,  88.0f,  150.0f,  3, SYNC_FAMILY_NINE_MS),
        new Mode(MODE_ROBOT_72, "Robot 72",  320, 240, false, 72000, 138.0f,  300.0f,  3, SYNC_FAMILY_NINE_MS),

        // Martin modes (RGB) — fullLine = 4.862 + 0.572 + 3*ch + 2*0.572
        new Mode(MODE_MARTIN_M1, "Martin M1", 320, 256, true, 114000, 146.432f, 446.446f, 3, SYNC_FAMILY_FIVE_MS),
        new Mode(MODE_MARTIN_M2, "Martin M2", 320, 256, true,  58000,  73.216f, 226.798f, 3, SYNC_FAMILY_FIVE_MS),

        // Scottie modes (RGB) — fullLine = 9 + 3*1.5 + 3*ch
        new Mode(MODE_SCOTTIE_S1, "Scottie S1", 320, 256, true, 110000, 138.240f, 428.220f,  3, SYNC_FAMILY_NINE_MS),
        new Mode(MODE_SCOTTIE_S2, "Scottie S2", 320, 256, true,  71000,  88.064f, 277.692f,  3, SYNC_FAMILY_NINE_MS),
        new Mode(MODE_SCOTTIE_DX, "Scottie DX", 320, 256, true, 316000, 345.600f, 1050.300f, 3, SYNC_FAMILY_NINE_MS),

        // PD modes (RGB) — fullLine = 20 + 2.08 + 3*ch (approximate)
        new Mode(MODE_PD_120, "PD 120", 640, 496, true, 126000, 121.9f, 369.78f, 3, SYNC_FAMILY_TWENTY_MS),
        new Mode(MODE_PD_180, "PD 180", 640, 496, true, 188000, 183.04f, 573.2f,  3, SYNC_FAMILY_TWENTY_MS),

        // Robot BW / Color modes (FIVE_MS sync)
        new Mode(MODE_ROBOT_8_BW,  "Robot 8 BW",     160, 120, false,   8000,   56.0f,   66.0f, 1, SYNC_FAMILY_FIVE_MS),
        new Mode(MODE_ROBOT_12_BW, "Robot 12 BW",    160, 120, false,  12000,   90.0f,  100.0f, 1, SYNC_FAMILY_FIVE_MS),
        new Mode(MODE_ROBOT_24_C,  "Robot 24 Color", 320, 240, false,  24000,   88.0f,  198.0f, 3, SYNC_FAMILY_FIVE_MS),
    };
    
    /**
     * Get mode by VIS code
     */
    public static Mode getModeByVIS(int visCode) {
        for (Mode mode : MODES) {
            if (mode.visCode == visCode) {
                return mode;
            }
        }
        return null;
    }
    
    /**
     * Get mode name by VIS code
     */
    public static String getModeName(int visCode) {
        Mode mode = getModeByVIS(visCode);
        return mode != null ? mode.name : "Unknown";
    }
    
    /**
     * Check if VIS code is supported
     */
    public static boolean isSupported(int visCode) {
        return getModeByVIS(visCode) != null;
    }
    
    /**
     * Get all supported modes
     */
    public static Mode[] getAllModes() {
        return MODES;
    }
    
    /**
     * Check if mode is Robot (YUV/BW)
     */
    public static boolean isRobotMode(int visCode) {
        return visCode == MODE_ROBOT_36 || visCode == MODE_ROBOT_72 || visCode == MODE_ROBOT_24_C;
    }

    /**
     * Check if mode is Robot Black & White
     */
    public static boolean isRobotBWMode(int visCode) {
        return visCode == MODE_ROBOT_8_BW || visCode == MODE_ROBOT_12_BW;
    }

    /**
     * Check if mode is Martin (RGB)
     */
    public static boolean isMartinMode(int visCode) {
        return visCode == MODE_MARTIN_M1 || visCode == MODE_MARTIN_M2;
    }

    /**
     * Check if mode uses Scottie structure (SYNC + SEP + G + SEP + B + SEP + R)
     */
    public static boolean isScottieMode(int visCode) {
        return visCode == MODE_SCOTTIE_S1 || visCode == MODE_SCOTTIE_S2 || visCode == MODE_SCOTTIE_DX;
    }

    /**
     * Get all modes belonging to a sync family
     */
    public static Mode[] getModesByFamily(int syncFamily) {
        int count = 0;
        for (Mode m : MODES) if (m.syncFamily == syncFamily) count++;
        Mode[] result = new Mode[count];
        int i = 0;
        for (Mode m : MODES) if (m.syncFamily == syncFamily) result[i++] = m;
        return result;
    }
}
