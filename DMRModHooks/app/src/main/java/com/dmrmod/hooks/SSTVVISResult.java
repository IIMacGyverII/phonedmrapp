package com.dmrmod.hooks;

/**
 * Result from VIS detection containing the VIS code and sample offset
 */
public class SSTVVISResult {
    public final int visCode;
    public final int imageStartSample;  // Sample position where image data begins
    
    public SSTVVISResult(int visCode, int imageStartSample) {
        this.visCode = visCode;
        this.imageStartSample = imageStartSample;
    }
    
    public static SSTVVISResult notDetected() {
        return new SSTVVISResult(SSTVMode.MODE_UNKNOWN, 0);
    }
}
