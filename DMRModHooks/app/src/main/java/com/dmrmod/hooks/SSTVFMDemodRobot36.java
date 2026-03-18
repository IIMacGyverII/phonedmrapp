/*
SSTV FM Demodulator using robot36's proven algorithm
Ported and adapted from robot36 by Ahmet Inan <xdsopl@gmail.com>

This replaces our broken FM demodulator implementations.
Uses proper complex baseband mixing, Kaiser-windowed FIR low-pass filtering,
and robot36's tested frequency-to-brightness conversion.
*/
package com.dmrmod.hooks;

import android.util.Log;

public class SSTVFMDemodRobot36 {
    private static final String TAG = "DMRModHooks-SSTV-FMDemod";

    // SSTV frequency ranges
    private static final double LOWEST_FREQ = 1000;      // Below sync pulse
    private static final double HIGHEST_FREQ = 2800;     // Above white
    private static final double SYNC_FREQ = 1200;        // Sync pulse
    private static final double BLACK_FREQ = 1500;       // Black level
    private static final double WHITE_FREQ = 2300;       // White level

    // Derived parameters
    private final double centerFrequency;
    private final double scanLineBandwidth;
    private final int sampleRate;

    // Processing components
    private final Phasor baseBandOscillator;
    private final ComplexConvolution baseBandLowPass;
    private final FrequencyModulation frequencyModulation;
    private Complex baseBand;  // Working complex buffer (reassigned during processing)

    // Debug stats
    private float minNormalizedFreq = Float.MAX_VALUE;
    private float maxNormalizedFreq = Float.MIN_VALUE;
    private float minBrightness = Float.MAX_VALUE;
    private float maxBrightness = Float.MIN_VALUE;

    public SSTVFMDemodRobot36(int sampleRate) {
        this.sampleRate = sampleRate;
        this.centerFrequency = (LOWEST_FREQ + HIGHEST_FREQ) / 2;  // 1900 Hz
        this.scanLineBandwidth = WHITE_FREQ - BLACK_FREQ;          // 800 Hz

        Log.d(TAG, "Robot36 FM demod initialized:");
        Log.d(TAG, "  Sample rate: " + sampleRate + " Hz");
        Log.d(TAG, "  Center frequency: " + centerFrequency + " Hz");
        Log.d(TAG, "  Scan line bandwidth: " + scanLineBandwidth + " Hz");

        // Create baseband oscillator (mix signal down to 0 Hz center)
        baseBandOscillator = new Phasor(-centerFrequency, sampleRate);

        // Create low-pass filter
        double cutoffFrequency = (HIGHEST_FREQ - LOWEST_FREQ) / 2;  // 900 Hz
        double baseBandLowPassSeconds = 0.002;  // 2ms filter
        int baseBandLowPassSamples = (int) Math.round(baseBandLowPassSeconds * sampleRate) | 1;  // Force odd
        
        Log.d(TAG, "  Low-pass filter: cutoff=" + cutoffFrequency + " Hz, taps=" + baseBandLowPassSamples);

        baseBandLowPass = new ComplexConvolution(baseBandLowPassSamples);
        
        // Design Kaiser-windowed sinc low-pass filter
        Kaiser kaiser = new Kaiser();
        for (int i = 0; i < baseBandLowPass.length; ++i) {
            baseBandLowPass.taps[i] = (float) (
                kaiser.window(2.0, i, baseBandLowPass.length) * 
                SSTVFilter.lowPass(cutoffFrequency, sampleRate, i, baseBandLowPass.length)
            );
        }

        // Create FM demodulator
        frequencyModulation = new FrequencyModulation(scanLineBandwidth, sampleRate);

        // Allocate working complex buffer
        baseBand = new Complex();

        Log.d(TAG, "Robot36 FM demod ready");
    }

    /**
     * Demodulate PCM audio to brightness values
     * @param pcmData Input PCM samples (16-bit signed)
     * @param output Output brightness array (0-255)
     * @param length Number of samples to process
     */
    public void demodulate(short[] pcmData, int[] output, int length) {
        minNormalizedFreq = Float.MAX_VALUE;
        maxNormalizedFreq = Float.MIN_VALUE;
        minBrightness = Float.MAX_VALUE;
        maxBrightness = Float.MIN_VALUE;

        for (int i = 0; i < length; i++) {
            // Convert PCM to float (-1.0 to +1.0)
            float sample = pcmData[i] / 32768.0f;

            // Mix to baseband (multiply by e^(-j*2*pi*centerFreq*t))
            baseBand.set(sample);
            baseBand = baseBandLowPass.push(baseBand.mul(baseBandOscillator.rotate()));

            // FM demodulation (phase change → frequency)
            float frequencyValue = frequencyModulation.demod(baseBand);

            // Track normalized frequency range
            if (frequencyValue < minNormalizedFreq) minNormalizedFreq = frequencyValue;
            if (frequencyValue > maxNormalizedFreq) maxNormalizedFreq = frequencyValue;

            // Convert normalized frequency to level (0.0 to 1.0)
            // Robot36's formula: level = 0.5 * (freq - offset + 1.0)
            // For now, assume no frequency offset (perfect tuning)
            float level = 0.5f * (frequencyValue + 1.0f);

            // Clamp to 0.0-1.0 range
            level = Math.max(0.0f, Math.min(1.0f, level));

            // Convert to brightness (0-255)
            int brightness = Math.round(255 * level);

            // Track brightness range
            if (brightness < minBrightness) minBrightness = brightness;
            if (brightness > maxBrightness) maxBrightness = brightness;

            output[i] = brightness;
        }

        Log.d(TAG, "Demodulation complete:");
        Log.d(TAG, "  Normalized freq range: " + minNormalizedFreq + " to " + maxNormalizedFreq);
        Log.d(TAG, "  Brightness range: " + (int)minBrightness + " to " + (int)maxBrightness);
    }

    /**
     * Normalize frequency from Hz to scanline bandwidth
     * Matches robot36's normalizeFrequency() function
     */
    private double normalizeFrequency(double frequency) {
        return (frequency - centerFrequency) * 2 / scanLineBandwidth;
    }

    public void reset() {
        // Reset state for new decode
        minNormalizedFreq = Float.MAX_VALUE;
        maxNormalizedFreq = Float.MIN_VALUE;
        minBrightness = Float.MAX_VALUE;
        maxBrightness = Float.MIN_VALUE;
        Log.d(TAG, "FM demod reset");
    }
}
