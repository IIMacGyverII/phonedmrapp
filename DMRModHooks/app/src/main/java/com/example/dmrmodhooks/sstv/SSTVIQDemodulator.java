package com.example.dmrmodhooks.sstv;

import android.util.Log;

/**
 * IQ (quadrature) baseband FM demodulator for SSTV
 * This is the CORE demodulator - replaces FFT-based approach
 * 
 * How it works:
 * 1. Multiply audio by complex oscillator at center frequency (1900 Hz)
 *    - Shifts SSTV spectrum (1500-2300 Hz) to baseband (-400 to +400 Hz)
 * 2. Apply complex low-pass filter (removes high frequencies)
 * 3. Extract phase from complex baseband signal
 * 4. Take phase difference between samples (FM demodulation)
 * 5. Output normalized frequency: -1.0 (black) to +1.0 (white)
 *
 * Based on robot36-2 implementation by Ahmet Inan
 */
public class SSTVIQDemodulator {
    private static final String TAG = "DMRModHooks-SSTV-IQDemod";

    // SSTV frequency standards
    public static final double SYNC_PULSE_FREQ = 1200.0;
    public static final double BLACK_FREQ = 1500.0;
    public static final double WHITE_FREQ = 2300.0;

    private final SSTVComplexConvolution basebandFilter;
    private final SSTVFrequencyModulation fmDemod;
    private final SSTVSchmittTrigger syncTrigger;
    private final SSTVPhasor basebandOscillator;
    private final SSTVSimpleMovingAverage syncPulseFilter;
    private final SSTVDelay syncPulseValueDelay;

    private final double scanLineBandwidth;
    private final double centerFrequency;
    private final double signalBandwidth;  // Full bandwidth for normalization
    private final float syncPulseFrequencyValue;
    private final float syncPulseFrequencyTolerance;
    private final int syncPulse5msMinSamples;
    private final int syncPulse5msMaxSamples;
    private final int syncPulse9msMaxSamples;
    private final int syncPulse20msMaxSamples;
    private final int syncPulseFilterDelay;
    private final int sampleRate;

    private int syncPulseCounter;
    private SSTVComplex baseband;

    // Output values when sync pulse detected
    public enum SyncPulseWidth {
        FIVE_MS,     // Martin, Wraase modes
        NINE_MS,     // Robot, Scottie modes
        TWENTY_MS    // PaulDon modes
    }

    public SyncPulseWidth syncPulseWidth;
    public int syncPulseOffset;
    public float frequencyOffset;

    public SSTVIQDemodulator(int sampleRate) {
        this.sampleRate = sampleRate;
        this.scanLineBandwidth = WHITE_FREQ - BLACK_FREQ;  // 800 Hz (image signal bandwidth)
        
        // Baseband filter design
        double lowestFrequency = 1000;   // Below black level (includes sync at 1200 Hz)
        double highestFrequency = 2800;  // Above white level
        this.signalBandwidth = highestFrequency - lowestFrequency;  // 1800 Hz (full signal bandwidth)
        this.fmDemod = new SSTVFrequencyModulation(signalBandwidth, sampleRate);  // Use full signal bandwidth

        // Sync pulse timing thresholds
        double syncPulse5msSeconds = 0.005;
        double syncPulse9msSeconds = 0.009;
        double syncPulse20msSeconds = 0.020;
        double syncPulse5msMinSeconds = syncPulse5msSeconds / 2;
        double syncPulse5msMaxSeconds = (syncPulse5msSeconds + syncPulse9msSeconds) / 2;
        double syncPulse9msMaxSeconds = (syncPulse9msSeconds + syncPulse20msSeconds) / 2;
        double syncPulse20msMaxSeconds = syncPulse20msSeconds + syncPulse5msSeconds;

        syncPulse5msMinSamples = (int) Math.round(syncPulse5msMinSeconds * sampleRate);
        syncPulse5msMaxSamples = (int) Math.round(syncPulse5msMaxSeconds * sampleRate);
        syncPulse9msMaxSamples = (int) Math.round(syncPulse9msMaxSeconds * sampleRate);
        syncPulse20msMaxSamples = (int) Math.round(syncPulse20msMaxSeconds * sampleRate);

        // Sync pulse smoothing filter (2.5ms window)
        double syncPulseFilterSeconds = syncPulse5msSeconds / 2;
        int syncPulseFilterSamples = (int) Math.round(syncPulseFilterSeconds * sampleRate) | 1;  // Make odd
        syncPulseFilterDelay = (syncPulseFilterSamples - 1) / 2;
        syncPulseFilter = new SSTVSimpleMovingAverage(syncPulseFilterSamples);
        syncPulseValueDelay = new SSTVDelay(syncPulseFilterSamples);

        // Create baseband filter
        double cutoffFrequency = (highestFrequency - lowestFrequency) / 2;  // 900 Hz
        double basebandFilterSeconds = 0.002;  // 2ms impulse response
        int basebandFilterSamples = (int) Math.round(basebandFilterSeconds * sampleRate) | 1;  // Make odd

        basebandFilter = new SSTVComplexConvolution(basebandFilterSamples);
        SSTVKaiser kaiser = new SSTVKaiser();
        for (int i = 0; i < basebandFilter.length; ++i) {
            double window = kaiser.window(2.0, i, basebandFilter.length);
            double lowpass = SSTVFilter.lowPass(cutoffFrequency, sampleRate, i, basebandFilter.length);
            basebandFilter.taps[i] = (float) (window * lowpass);
        }

        // Complex oscillator at center frequency (negative = conjugate)
        centerFrequency = (lowestFrequency + highestFrequency) / 2;  // 1900 Hz
        basebandOscillator = new SSTVPhasor(-centerFrequency, sampleRate);

        // Sync pulse detection thresholds
        syncPulseFrequencyValue = (float) normalizeFrequency(SYNC_PULSE_FREQ);
        syncPulseFrequencyTolerance = (float) (100 * 2 / signalBandwidth);  // ±100 Hz tolerance

        // Schmitt trigger: sync at 1200 Hz (-0.778), trigger at 1250/1400 Hz (-0.722/-0.556)
        double syncLowFrequency = 1250;   // Trigger when dropping below this
        double syncHighFrequency = 1400;  // Trigger when rising above this
        double syncLowValue = normalizeFrequency(syncLowFrequency);
        double syncHighValue = normalizeFrequency(syncHighFrequency);
        syncTrigger = new SSTVSchmittTrigger((float) syncLowValue, (float) syncHighValue);

        baseband = new SSTVComplex();
        syncPulseCounter = 0;

        Log.d(TAG, String.format("IQ Demodulator initialized: sampleRate=%d Hz, centerFreq=%.1f Hz",
                sampleRate, centerFrequency));
        Log.d(TAG, String.format("Signal bandwidth=%.1f Hz, scanLine bandwidth=%.1f Hz",
                signalBandwidth, scanLineBandwidth));
        Log.d(TAG, String.format("Baseband filter: %d taps, cutoff=%.1f Hz", basebandFilterSamples, cutoffFrequency));
        Log.d(TAG, String.format("Sync detection: pulse=%.3f (%.0f Hz), tolerance=±%.3f (±50 Hz)",
                syncPulseFrequencyValue, SYNC_PULSE_FREQ, syncPulseFrequencyTolerance));
    }

    /**
     * Convert absolute frequency to normalized frequency [-1, +1]
     * Uses full signal bandwidth (1000-2800 Hz) to include sync pulses
     */
    private double normalizeFrequency(double frequency) {
        return (frequency - centerFrequency) * 2 / signalBandwidth;
    }

    /**
     * Process audio buffer and detect sync pulses
     * 
     * @param audioBuffer Input audio samples
     * @param demodBuffer Output buffer for demodulated frequencies (normalized -1 to +1)
     * @return true if sync pulse detected (check syncPulseWidth, syncPulseOffset, frequencyOffset)
     */
    public boolean process(short[] audioBuffer, float[] demodBuffer) {
        boolean syncPulseDetected = false;

        for (int i = 0; i < audioBuffer.length; i++) {
            // Convert to float [-1, +1]
            float sample = audioBuffer[i] / 32768.0f;

            // Mix down to baseband (multiply by complex oscillator)
            baseband.set(sample);
            baseband = basebandFilter.push(baseband.mul(basebandOscillator.rotate()));

            // FM demodulation (phase difference)
            float frequencyValue = fmDemod.demod(baseband);

            // Smooth for sync pulse detection
            float syncPulseValue = syncPulseFilter.avg(frequencyValue);
            float syncPulseDelayedValue = syncPulseValueDelay.push(syncPulseValue);

            // Store demodulated frequency
            demodBuffer[i] = frequencyValue;

            // Sync pulse detection using Schmitt trigger
            if (!syncTrigger.latch(syncPulseValue)) {
                // In sync pulse (below threshold)
                ++syncPulseCounter;
            } else if (syncPulseCounter < syncPulse5msMinSamples ||
                       syncPulseCounter > syncPulse20msMaxSamples ||
                       Math.abs(syncPulseDelayedValue - syncPulseFrequencyValue) > syncPulseFrequencyTolerance) {
                // Invalid pulse (too short, too long, or wrong frequency)
                syncPulseCounter = 0;
            } else {
                // Valid sync pulse detected!
                if (syncPulseCounter < syncPulse5msMaxSamples) {
                    syncPulseWidth = SyncPulseWidth.FIVE_MS;
                } else if (syncPulseCounter < syncPulse9msMaxSamples) {
                    syncPulseWidth = SyncPulseWidth.NINE_MS;
                } else {
                    syncPulseWidth = SyncPulseWidth.TWENTY_MS;
                }
                syncPulseOffset = i - syncPulseFilterDelay;
                frequencyOffset = syncPulseDelayedValue - syncPulseFrequencyValue;
                syncPulseDetected = true;

                Log.d(TAG, String.format("Sync detected: width=%s, counter=%d (5ms<56, 9ms<116), offset=%d, freqOffset=%.4f",
                        syncPulseWidth, syncPulseCounter, syncPulseOffset, frequencyOffset));
                
                syncPulseCounter = 0;
            }
        }

        return syncPulseDetected;
    }

    /**
     * Convert normalized frequency to brightness level [0, 255]
     * @param normalizedFreq Normalized frequency from -1.0 (black) to +1.0 (white)
     * @param offset Frequency offset correction
     * @return Brightness level 0-255
     */
    public static int frequencyToBrightness(float normalizedFreq, float offset) {
        // Apply offset correction and convert from [-1, +1] to [0, 1]
        float level = 0.5f * (normalizedFreq - offset + 1.0f);

        // Clamp to [0, 1] and scale to [0, 255]
        if (level < 0) level = 0;
        if (level > 1) level = 1;
        return Math.round(level * 255);
    }
}
