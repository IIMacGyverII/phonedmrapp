package com.dmrmod.hooks;

import android.graphics.Bitmap;
import android.graphics.Color;
import de.robv.android.xposed.XposedBridge;

/**
 * SSTV Image Decoder
 * Currently supports Robot 36 mode
 */
public class SSTVImageDecoder {
    private static final String TAG = "DMRModHooks-SSTV-Decoder";
    
    // Robot 36 parameters
    private static final int ROBOT36_WIDTH = 320;
    private static final int ROBOT36_HEIGHT = 240;
    private static final int SAMPLE_RATE = 8000;
    
    // Robot 36 timing (in samples @ 8kHz)
    private static final int SYNC_SAMPLES = 40;       // 5ms (9ms for first line = 72 samples)
    private static final int Y_SAMPLES = 704;         // 88ms luminance
    private static final int UV_SAMPLES = 352;        // 44ms each for U and V
    
    // Scottie S2 parameters
    private static final int SCOTTIE_WIDTH = 320;
    private static final int SCOTTIE_HEIGHT = 256;
    private static final int SCOTTIE_SYNC_SAMPLES = 72;     // 9ms
    private static final int SCOTTIE_PORCH_SAMPLES = 12;    // 1.5ms separator @ 1500Hz
    private static final int SCOTTIE_CHANNEL_SAMPLES = 1168; // 146ms per RGB channel
    private static final int SCOTTIE_LINE_SAMPLES = SCOTTIE_SYNC_SAMPLES + (SCOTTIE_CHANNEL_SAMPLES * 3); // 9ms + 3*146ms = 447ms total
    
    // Robot 36 scanline structure:
    // Even lines (0, 2, 4...): Sync + Y1 + Y2
    // Odd lines (1, 3, 5...): Sync + Y1 + U1 + V1 + Y2 + U2 + V2
    
    private SSTVFMDemodRobot36 demodulator;
    private SSTVMode.Mode mode;
    private int actualDurationMs;  // Actual measured transmission duration
    
    public SSTVImageDecoder(SSTVMode.Mode mode, int sampleRate, int actualDurationMs) {
        this.mode = mode;
        this.demodulator = new SSTVFMDemodRobot36(sampleRate);
        this.actualDurationMs = actualDurationMs;
    }
    
    /**
     * Decode SSTV audio to image bitmap
     * 
     * @param samples Raw audio samples (including VIS code at beginning)
     * @param startOffset Sample offset where image data begins (after VIS code)
     * @return Decoded image bitmap
     */
    public Bitmap decode(short[] samples, int startOffset) {
        if (mode.visCode == SSTVMode.MODE_ROBOT_36) {
            return decodeRobot36(samples, startOffset);
        } else if (mode.visCode == SSTVMode.MODE_SCOTTIE_S2 || mode.visCode == SSTVMode.MODE_SCOTTIE_S1) {
            return decodeScottie(samples, startOffset);
        }
        
        // Other modes not yet implemented
        XposedBridge.log(TAG + ": Mode " + mode.name + " decoding not implemented yet");
        return null;
    }
    
    /**
     * Decode Robot 36 format
     * Format: YUV, 320x240, ~36 seconds
     * Scanline structure alternates between even/odd lines
     */
    private Bitmap decodeRobot36(short[] samples, int startOffset) {
        XposedBridge.log(TAG + ": Starting Robot 36 decode (" + samples.length + " samples, offset=" + startOffset + ")");
        
        // Create bitmap
        Bitmap bitmap = Bitmap.createBitmap(ROBOT36_WIDTH, ROBOT36_HEIGHT, Bitmap.Config.ARGB_8888);
        
        // Skip VIS code and demodulate only image data
        int imageLength = samples.length - startOffset;
        short[] imageSamples = new short[imageLength];
        System.arraycopy(samples, startOffset, imageSamples, 0, imageLength);
        
        // Demodulate audio to brightness values using robot36's proven algorithm
        int[] brightness = new int[imageLength];
        demodulator.demodulate(imageSamples, brightness, imageLength);
        XposedBridge.log(TAG + ": Demodulated to " + brightness.length + " brightness values");
        
        // Storage for YUV values (we'll build them up over two scanlines)
        byte[][] yBuffer = new byte[2][ROBOT36_WIDTH];  // Two scanlines
        byte[] uBuffer = new byte[ROBOT36_WIDTH];
        byte[] vBuffer = new byte[ROBOT36_WIDTH];
        
        int pos = 0;
        int currentLine = 0;
        
        // Process scanlines
        while (currentLine < ROBOT36_HEIGHT && pos < brightness.length) {
            // Detect sync pulse in brightness array
            int syncPos = findSyncPulseInBrightness(brightness, pos);
            if (syncPos < 0) {
                XposedBridge.log(TAG + ": No sync found at line " + currentLine + ", stopping");
                break;
            }
            
            pos = syncPos + SYNC_SAMPLES;  // Move past sync pulse
            
            boolean isEvenLine = (currentLine % 2 == 0);
            
            if (isEvenLine) {
                // Even line: Y1 + Y2 (two scanlines of luminance)
                if (pos + (Y_SAMPLES * 2 / 8) > brightness.length) break;
                
                // Extract Y1
                for (int x = 0; x < ROBOT36_WIDTH && pos < brightness.length; x++) {
                    yBuffer[0][x] = (byte)brightness[pos++];
                }
                
                // Extract Y2
                for (int x = 0; x < ROBOT36_WIDTH && pos < brightness.length; x++) {
                    yBuffer[1][x] = (byte)brightness[pos++];
                }
                
                // Write both scanlines (reusing U/V from previous odd line)
                for (int x = 0; x < ROBOT36_WIDTH; x++) {
                    int rgb1 = yuvToRgb(yBuffer[0][x] & 0xFF, uBuffer[x] & 0xFF, vBuffer[x] & 0xFF);
                    int rgb2 = yuvToRgb(yBuffer[1][x] & 0xFF, uBuffer[x] & 0xFF, vBuffer[x] & 0xFF);
                    
                    if (currentLine < ROBOT36_HEIGHT) {
                        bitmap.setPixel(x, currentLine, rgb1);
                    }
                    if (currentLine + 1 < ROBOT36_HEIGHT) {
                        bitmap.setPixel(x, currentLine + 1, rgb2);
                    }
                }
                
                currentLine += 2;
                
            } else {
                // Odd line: Y1 + U1 + V1 + Y2 + U2 + V2
                if (pos + ((Y_SAMPLES + UV_SAMPLES + UV_SAMPLES) * 2 / 8) > brightness.length) break;
                
                // Extract Y1
                for (int x = 0; x < ROBOT36_WIDTH && pos < brightness.length; x++) {
                    yBuffer[0][x] = (byte)brightness[pos++];
                }
                
                // Extract U1
                for (int x = 0; x < ROBOT36_WIDTH && pos < brightness.length; x += 2) {
                    byte u = (byte)brightness[pos++];
                    uBuffer[x] = u;
                    if (x + 1 < ROBOT36_WIDTH) uBuffer[x + 1] = u;  // Duplicate for 2x subsampling
                }
                
                // Extract V1
                for (int x = 0; x < ROBOT36_WIDTH && pos < brightness.length; x += 2) {
                    byte v = (byte)brightness[pos++];
                    vBuffer[x] = v;
                    if (x + 1 < ROBOT36_WIDTH) vBuffer[x + 1] = v;
                }
                
                // Extract Y2
                for (int x = 0; x < ROBOT36_WIDTH && pos < brightness.length; x++) {
                    yBuffer[1][x] = (byte)brightness[pos++];
                }
                
                // Extract U2 (overwrite U1)
                for (int x = 0; x < ROBOT36_WIDTH && pos < brightness.length; x += 2) {
                    byte u = (byte)brightness[pos++];
                    uBuffer[x] = u;
                    if (x + 1 < ROBOT36_WIDTH) uBuffer[x + 1] = u;
                }
                
                // Extract V2 (overwrite V1)
                for (int x = 0; x < ROBOT36_WIDTH && pos < brightness.length; x += 2) {
                    byte v = (byte)brightness[pos++];
                    vBuffer[x] = v;
                    if (x + 1 < ROBOT36_WIDTH) vBuffer[x + 1] = v;
                }
                
                // Write both scanlines
                for (int x = 0; x < ROBOT36_WIDTH; x++) {
                    int rgb1 = yuvToRgb(yBuffer[0][x] & 0xFF, uBuffer[x] & 0xFF, vBuffer[x] & 0xFF);
                    int rgb2 = yuvToRgb(yBuffer[1][x] & 0xFF, uBuffer[x] & 0xFF, vBuffer[x] & 0xFF);
                    
                    if (currentLine < ROBOT36_HEIGHT) {
                        bitmap.setPixel(x, currentLine, rgb1);
                    }
                    if (currentLine + 1 < ROBOT36_HEIGHT) {
                        bitmap.setPixel(x, currentLine + 1, rgb2);
                    }
                }
                
                currentLine += 2;
            }
            
            // Log progress every 20 lines
            if (currentLine % 20 == 0) {
                XposedBridge.log(TAG + ": Decoded " + currentLine + "/" + ROBOT36_HEIGHT + " lines");
            }
        }
        
        XposedBridge.log(TAG + ": Robot 36 decode complete (" + currentLine + " lines)");
        return bitmap;
    }
    
    /**
     * Decode Scottie S1/S2 format
     * Format: RGB, 320x256, 71 seconds (S2) or 110 seconds (S1)
     * Scanline structure: Sync (9ms) + Green (146ms) + Blue (146ms) + Red (146ms)
     * 
     * Uses PHASE-BASED FM DEMODULATION for continuous frequency tracking.
     * This is the proper approach for SSTV (vs. Goertzel which only works for VIS/FSK).
     */
    private Bitmap decodeScottie(short[] samples, int startOffset) {
        XposedBridge.log(TAG + ": Starting Scottie decode (" + samples.length + " samples, offset=" + startOffset + ")");
        
        // Create bitmap
        Bitmap bitmap = Bitmap.createBitmap(SCOTTIE_WIDTH, SCOTTIE_HEIGHT, Bitmap.Config.ARGB_8888);
        
        // Create FFT-based FM demodulator (more robust than zero-crossing at 8 kHz)
        // Uses Hann windowing + barycentric interpolation like reference decoder
        SSTVFFTDemodulator demod = new SSTVFFTDemodulator(SAMPLE_RATE);
        
        // Window size - 64 samples for good FFT resolution
        // 64 samples @ 8kHz = 8ms window
        // FFT resolution: 8000/64 = 125 Hz per bin
        // SSTV range (1500-2300 Hz) spans ~6.4 bins
        // With barycentric interpolation, this gives excellent sub-bin accuracy
        int windowSize = 64;
        
        XposedBridge.log(TAG + ": Using FFT demod with " + windowSize + " sample window (8ms) + Hann windowing");
        
        // Add diagnostic: Track min/max detected frequencies across first 50 pixels
        double minFreqDetected = 9999;
        double maxFreqDetected = 0;
        int diagnosticPixels = 0;
        
        // Baseline timing scale used only for initial search window
        // Fine-tuned to 1.193x to fix very slight diagonal down left-to-right
        float baseTimingScale = 1.193f;
        int baseChannelSamples = (int)(SCOTTIE_CHANNEL_SAMPLES * baseTimingScale);
        int baseSyncSamples = (int)(SCOTTIE_SYNC_SAMPLES * baseTimingScale);
        int baseLineSamples = baseSyncSamples + (baseChannelSamples * 3);
        
        XposedBridge.log(TAG + ": Base timing scale: " + baseTimingScale + "x (for search windows only)");
        XposedBridge.log(TAG + ": Per-line timing detection ENABLED - will measure actual sync-to-sync distance");
        
        // Storage for RGB channels
        int[] rChannel = new int[SCOTTIE_WIDTH];
        int[] gChannel = new int[SCOTTIE_WIDTH];
        int[] bChannel = new int[SCOTTIE_WIDTH];
        
        int pos = startOffset;
        int currentLine = 0;
        int prevSyncPos = -1;  // Track previous sync position for timing measurement
        
        // Process each scanline
        while (currentLine < SCOTTIE_HEIGHT && pos + baseLineSamples < samples.length) {
            // Find sync pulse (9ms at 1200Hz) using phase demod
            int syncPos = demod.findSyncPulse(samples, pos, baseSyncSamples * 3, windowSize);
            if (syncPos < 0) {
                XposedBridge.log(TAG + ": No sync at line " + currentLine + ", stopping");
                break;
            }
            
            // Measure per-line timing from actual sync-to-sync distance
            int lineChannelSamples;
            int lineSyncSamples = baseSyncSamples;  // Sync duration is fixed
            
            if (prevSyncPos >= 0) {
                // Calculate actual samples in this line
                int actualLineSamples = syncPos - prevSyncPos;
                // Remove sync duration and 3 porch periods to get RGB channel samples
                lineChannelSamples = (actualLineSamples - baseSyncSamples - (SCOTTIE_PORCH_SAMPLES * 3)) / 3;
                
                // Debug every 50 lines to show timing adaptation throughout transmission
                if (currentLine % 50 == 0 || currentLine < 3 || currentLine >= SCOTTIE_HEIGHT - 3) {
                    float lineTimingScale = (float)actualLineSamples / (float)(SCOTTIE_SYNC_SAMPLES + SCOTTIE_CHANNEL_SAMPLES * 3);
                    XposedBridge.log(TAG + ": Line " + currentLine + " measured timing: " + 
                                   String.format("%.3f", lineTimingScale) + "x (" + 
                                   actualLineSamples + " samples, " + lineChannelSamples + " per channel)");
                }
            } else {
                // First line: use baseline timing
                lineChannelSamples = baseChannelSamples;
                XposedBridge.log(TAG + ": Line 0 using baseline timing (no previous sync to measure from)");
                
                // Run diagnostic on first line to verify frequency scaling
                demod.logFirstLineFrequencies(samples, pos, windowSize * 20);
            }
            
            prevSyncPos = syncPos;  // Remember this sync for next line
            pos = syncPos + lineSyncSamples;  // Move past sync
            
            // Scottie S2 has 1.5ms separator/porch after sync and between channels
            // Skip first porch (after sync, before Green)
            pos += SCOTTIE_PORCH_SAMPLES;
            
            // Reset per-line frequency stats for adaptive brightness
            demod.resetLineStats();
            
            // Extract Green channel using per-line timing
            for (int x = 0; x < SCOTTIE_WIDTH; x++) {
                int samplePos = (int)(pos + (x * lineChannelSamples) / (float)SCOTTIE_WIDTH);
                gChannel[x] = demod.extractPixelBrightness(samples, samplePos, windowSize);
                
                // Diagnostic: Log first few pixels of first line
                if (currentLine == 0 && x < 5) {
                    XposedBridge.log(TAG + ": Line 0 Green pixel " + x + " = " + gChannel[x] + 
                                   " (pos=" + samplePos + ")");
                }
            }
            pos += lineChannelSamples;
            pos += SCOTTIE_PORCH_SAMPLES;  // Porch before Blue
            
            // Extract Blue channel
            for (int x = 0; x < SCOTTIE_WIDTH; x++) {
                int samplePos = (int)(pos + (x * lineChannelSamples) / (float)SCOTTIE_WIDTH);
                bChannel[x] = demod.extractPixelBrightness(samples, samplePos, windowSize);
            }
            pos += lineChannelSamples;
            pos += SCOTTIE_PORCH_SAMPLES;  // Porch before Red
            
            // Extract Red channel
            for (int x = 0; x < SCOTTIE_WIDTH; x++) {
                int samplePos = (int)(pos + (x * lineChannelSamples) / (float)SCOTTIE_WIDTH);
                rChannel[x] = demod.extractPixelBrightness(samples, samplePos, windowSize);
            }
            pos += lineChannelSamples;
            
            // FFT is much more noise-resistant than zero-crossing
            // Apply only light 3-pixel median filtering (may not even be needed)
            int[] rFiltered = applyMedianFilter(rChannel, SCOTTIE_WIDTH);
            int[] gFiltered = applyMedianFilter(gChannel, SCOTTIE_WIDTH);
            int[] bFiltered = applyMedianFilter(bChannel, SCOTTIE_WIDTH);
            
            // Write scanline to bitmap
            for (int x = 0; x < SCOTTIE_WIDTH; x++) {
                int color = Color.rgb(rFiltered[x], gFiltered[x], bFiltered[x]);
                bitmap.setPixel(x, currentLine, color);
            }
            
            // Debug: Log brightness stats for first 3 lines and last 3 lines
            if (currentLine < 3 || currentLine >= SCOTTIE_HEIGHT - 3) {
                int minR = 255, maxR = 0, minG = 255, maxG = 0, minB = 255, maxB = 0;
                for (int x = 0; x < SCOTTIE_WIDTH; x++) {
                    if (rFiltered[x] < minR) minR = rFiltered[x];
                    if (rFiltered[x] > maxR) maxR = rFiltered[x];
                    if (gFiltered[x] < minG) minG = gFiltered[x];
                    if (gFiltered[x] > maxG) maxG = gFiltered[x];
                    if (bFiltered[x] < minB) minB = bFiltered[x];
                    if (bFiltered[x] > maxB) maxB = bFiltered[x];
                }
                XposedBridge.log(TAG + ": Line " + currentLine + " brightness (filtered): R(" + minR + "-" + maxR + 
                               ") G(" + minG + "-" + maxG + ") B(" + minB + "-" + maxB + ")");
            }
            
            currentLine++;
            
            // Log progress every 20 lines
            if (currentLine % 20 == 0) {
                XposedBridge.log(TAG + ": Decoded " + currentLine + "/" + SCOTTIE_HEIGHT + " lines");
            }
        }
        
        XposedBridge.log(TAG + ": Scottie decode complete (" + currentLine + " lines)");
        
        // Log detected frequency range for diagnostics
        XposedBridge.log(TAG + ": Final frequency range: " + 
                       String.format("%.1f-%.1f Hz", demod.getMinFreq(), demod.getMaxFreq()));
        XposedBridge.log(TAG + ": Expected range: 1500-2300 Hz");
        XposedBridge.log(TAG + ": If range is wrong (e.g., 0-100 Hz), check phase diff scaling");
        
        return bitmap;
    }
    
    /**
     * Extract pixel brightness using FFT
     * @param samples Full audio sample array
     * @param centerPos Center position of pixel (in samples)
     * @param windowSize FFT window size
     * @return Brightness value (0-255)
     */
    private int extractPixelBrightness(short[] samples, int centerPos, int windowSize) {
        // Extract window centered on pixel
        int startPos = centerPos - windowSize / 2;
        if (startPos < 0) startPos = 0;
        if (startPos + windowSize > samples.length) {
            startPos = samples.length - windowSize;
        }
        if (startPos < 0) return 0;  // Not enough samples
        
        // Convert to float and apply Hann window
        float[] window = new float[windowSize];
        for (int i = 0; i < windowSize; i++) {
            float sample = samples[startPos + i] / 32768.0f;
            // Hann window
            double w = 0.5 * (1.0 - Math.cos(2.0 * Math.PI * i / (windowSize - 1)));
            window[i] = sample * (float)w;
        }
        
        // Find peak frequency in SSTV range (1000-2800 Hz)
        float peakFreq = findPeakFrequencyInWindow(window, SAMPLE_RATE);
        
        // Convert to brightness (1500 Hz = 0, 2300 Hz = 255)
        float brightness = (peakFreq - 1500.0f) * 255.0f / 800.0f;
        if (brightness < 0) brightness = 0;
        if (brightness > 255) brightness = 255;
        
        return Math.round(brightness);
    }
    
    /**
     * Find peak frequency in FFT window
     * @param window Windowed audio samples
     * @param sampleRate Sample rate
     * @return Peak frequency in Hz
     */
    private float findPeakFrequencyInWindow(float[] window, int sampleRate) {
        int N = window.length;
        
        // Only check SSTV range (1000-2800 Hz)
        int minBin = (int)((1000.0 * N) / sampleRate);
        int maxBin = (int)((2800.0 * N) / sampleRate);
        if (maxBin >= N/2) maxBin = N/2 - 1;
        
        float maxMagnitude = 0;
        int maxBin_idx = minBin;
        
        // Simple DFT for frequency bins in range
        for (int k = minBin; k <= maxBin; k++) {
            float real = 0;
            float imag = 0;
            double omega = 2.0 * Math.PI * k / N;
            
            for (int n = 0; n < N; n++) {
                real += window[n] * Math.cos(omega * n);
                imag -= window[n] * Math.sin(omega * n);
            }
            
            float magnitude = (float)Math.sqrt(real * real + imag * imag);
            if (magnitude > maxMagnitude) {
                maxMagnitude = magnitude;
                maxBin_idx = k;
            }
        }
        
        // Convert bin to frequency        
        return (maxBin_idx * sampleRate) / (float)N;
    }
    
    /**
     * Find next sync pulse in raw audio samples
     * Looks for ~1200 Hz tone for duration of syncSamples
     * 
     * @param samples Audio samples
     * @param start Start search position
     * @param searchLength How far to search
     * @param windowSize FFT window size
     * @return Position of sync pulse, or -1 if not found
     */
    private int findSyncPulse(short[] samples, int start, int searchLength, int windowSize) {
        int maxSearch = Math.min(samples.length - windowSize, start + searchLength);
        
        // Search for 1200 Hz tone (sync)        
        for (int i = start; i < maxSearch; i += windowSize / 2) {  // Hop by half-windows
            float freq = extractPixelBrightness(samples, i, windowSize);
            
            // Check if this is close to sync frequency (1200 Hz → brightness ~0-50)
            if (freq < 70) {  // Low brightness = low frequency ≈ sync
                // Verify it stays low for ~9ms
                int syncLength = (int)(0.009 * SAMPLE_RATE);  // 72 samples
                boolean isSync = true;
                for (int j = 0; j < syncLength && (i + j) < samples.length; j += windowSize / 4) {
                    float checkFreq = extractPixelBrightness(samples, i + j, windowSize);
                    if (checkFreq > 70) {
                        isSync = false;
                        break;
                    }
                }
                
                if (isSync) {
                    return i;
                }
            }
        }
        
        return -1;
    }
    
    /**
     * Find next sync pulse in demodulated brightness array
     * Looks for low brightness values (1200 Hz = black)
     * 
     * @param brightness Demodulated brightness array (1ms per sample)
     * @param start Start search position (in brightness indices)
     * @return Position of sync pulse, or -1 if not found
     */
    private int findSyncPulseInBrightness(int[] brightness, int start) {
        // Search for ~9ms of low  brightness (sync pulse at 1200Hz)
        int maxSearch = Math.min(brightness.length - 9, start + 550);  // Search up to 550ms ahead
        
        for (int i = start; i < maxSearch; i++) {
            // Check for at least 5ms of low brightness (< 50)
            int darkCount = 0;
            for (int j = 0; j < 9 && (i + j) < brightness.length; j++) {
                if (brightness[i + j] < 50) {
                    darkCount++;
                }
            }
            
            // Need at least 5 out of 9 samples to be dark
            if (darkCount >= 5) {
                return i;
            }
        }
        return -1;
    }
    

    /* DEPRECATED - unused function that relied on removed findSyncPulse() method
    /**
     * Auto-calibrate Scottie timing from first few sync pulses
     * Measures actual scanline duration vs expected duration
     * 
     * @param samples Audio samples
     * @return Timing scale factor (1.0 = perfect, >1.0 = slower transmission)
     *
    private float calibrateScottieTiming(short[] samples) {
        // Find first 5 sync pulses (more samples for better accuracy)
        int[] syncPositions = new int[5];
        int found = 0;
        int searchPos = 0;
        
        for (int i = 0; i < 5 && searchPos < samples.length; i++) {
            int syncPos = findSyncPulse(samples, searchPos);
            if (syncPos >= 0) {
                syncPositions[found++] = syncPos;
                // Skip ahead almost full scanline to find next one
                searchPos = syncPos + (int)(SCOTTIE_LINE_SAMPLES * 0.9);
            } else {
                break;
            }
        }
        
        if (found < 3) {
            XposedBridge.log(TAG + ": Timing calibration failed (only " + found + " sync pulses), using 1.21x");
            return 1.21f;  // Use previous measured value as fallback
        }
        
        // Measure scanline durations and filter out outliers (skipped syncs)
        float[] scales = new float[found - 1];
        for (int i = 1; i < found; i++) {
            int measuredSamples = syncPositions[i] - syncPositions[i-1];
            float scale = measuredSamples / (float)SCOTTIE_LINE_SAMPLES;
            scales[i-1] = scale;
            XposedBridge.log(TAG + ": Sync " + (i-1) + " to " + i + ": " + measuredSamples + 
                           " samples (expected " + SCOTTIE_LINE_SAMPLES + ", scale: " + scale + "x)");
        }
        
        // Use median instead of average to filter outliers
        java.util.Arrays.sort(scales, 0, found - 1);
        float medianScale = scales[(found - 1) / 2];
        
        // Clamp to reasonable range (0.8x to 1.5x)
        medianScale = Math.max(0.8f, Math.min(1.5f, medianScale));
        
        XposedBridge.log(TAG + ": Median timing scale: " + medianScale + "x (clamped)");
        return medianScale;
    }
    */
    
    /**
     * Apply moving average filter to heavily smooth noisy zero-crossing data
     * This is critical at 8 kHz where zero-crossing is very noise-sensitive
     * 
     * @param channel Input channel data (0-255)
     * @param width Width of scanline
     * @param windowSize Number of pixels to average (e.g., 5)
     * @return Smoothed channel data
     */
    private int[] applyMovingAverage(int[] channel, int width, int windowSize) {
        int[] smoothed = new int[width];
        int halfWindow = windowSize / 2;
        
        for (int x = 0; x < width; x++) {
            int sum = 0;
            int count = 0;
            
            // Average over window
            for (int i = -halfWindow; i <= halfWindow; i++) {
                int idx = x + i;
                if (idx >= 0 && idx < width) {
                    sum += channel[idx];
                    count++;
                }
            }
            
            smoothed[x] = sum / count;
        }
        
        return smoothed;
    }
    
    /**
     * Apply 3-pixel median filter to reduce noise in scanline
     * Preserves edges better than averaging
     * 
     * @param channel Input channel data (0-255)
     * @param width Width of scanline
     * @return Filtered channel data
     */
    private int[] applyMedianFilter(int[] channel, int width) {
        int[] filtered = new int[width];
        
        for (int x = 0; x < width; x++) {
            // Get 3-pixel window (handle edges)
            int prev = (x > 0) ? channel[x - 1] : channel[x];
            int curr = channel[x];
            int next = (x < width - 1) ? channel[x + 1] : channel[x];
            
            // Find median of 3 values (simple bubble sort)
            int a = prev, b = curr, c = next;
            if (a > b) { int t = a; a = b; b = t; }
            if (b > c) { int t = b; b = c; c = t; }
            if (a > b) { int t = a; a = b; b = t; }
            
            filtered[x] = b;  // Middle value is median
        }
        
        return filtered;
    }
    
    /**
     * Convert YUV to RGB color
     * Uses ITU-R BT.601 conversion matrix
     * 
     * @param y Luminance (0-255)
     * @param u Chroma U (0-255)
     * @param v Chroma V (0-255)
     * @return ARGB color value
     */
    private int yuvToRgb(int y, int u, int v) {
        // Normalize to -128 to +127 range
        u -= 128;
        v -= 128;
        
        // ITU-R BT.601 conversion
        int r = (int) (y + 1.402 * v);
        int g = (int) (y - 0.344136 * u - 0.714136 * v);
        int b = (int) (y + 1.772 * u);
        
        // Clamp to 0-255
        r = Math.max(0, Math.min(255, r));
        g = Math.max(0, Math.min(255, g));
        b = Math.max(0, Math.min(255, b));
        
        return Color.rgb(r, g, b);
    }
}
