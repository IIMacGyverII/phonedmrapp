/**
 * Simplified IQ Demodulator for standalone testing
 */
class IQDemodulator {
    private static final double SYNC_PULSE_FREQ = 1200.0;
    private static final double BLACK_FREQ = 1500.0;
    private static final double WHITE_FREQ = 2300.0;
    
    private final int sampleRate;
    private final double centerFrequency;
    private final double signalBandwidth;
    private final double scanLineBandwidth;
    
    private final int syncPulse5msMaxSamples;
    private final int syncPulse9msMaxSamples;
    private final int syncPulseFilterDelay;
    
    private final Phasor basebandOscillator;
    private final ComplexConvolution basebandFilter;
    private final FrequencyModulation fmDemod;
    private final SimpleMovingAverage syncPulseFilter;
    private final Delay syncPulseValueDelay;
    private final SchmittTrigger syncTrigger;
    
    private final float syncPulseFrequencyValue;
    private final float syncPulseFrequencyTolerance;
    
    private Complex baseband = new Complex();
    private int syncPulseCounter = 0;
    private int sampleCounter = 0;  // For debugging
    
    public enum SyncPulseWidth { FIVE_MS, NINE_MS, TWENTY_MS }
    public SyncPulseWidth syncPulseWidth;
    public int syncPulseOffset;
    public float frequencyOffset;
    public int lastSyncCounter;  // For debugging
    
    public IQDemodulator(int sampleRate) {
        this.sampleRate = sampleRate;
        this.scanLineBandwidth = WHITE_FREQ - BLACK_FREQ;
        
        double lowestFrequency = 1000;
        double highestFrequency = 2800;
        this.signalBandwidth = highestFrequency - lowestFrequency;
        this.centerFrequency = (lowestFrequency + highestFrequency) / 2;
        
        // Timing thresholds
        syncPulse5msMaxSamples = (int)Math.round(0.007 * sampleRate);  // 7ms
        syncPulse9msMaxSamples = (int)Math.round(0.0145 * sampleRate);  // 14.5ms
        
        // Filters
        int syncFilterSamples = (int)Math.round(0.0025 * sampleRate) | 1;
        syncPulseFilterDelay = (syncFilterSamples - 1) / 2;
        syncPulseFilter = new SimpleMovingAverage(syncFilterSamples);
        syncPulseValueDelay = new Delay(syncFilterSamples);
        
        int basebandFilterSamples = (int)Math.round(0.002 * sampleRate) | 1;
        double cutoffFreq = 900;
        basebandFilter = new ComplexConvolution(basebandFilterSamples, cutoffFreq, sampleRate);
        
        basebandOscillator = new Phasor(-centerFrequency, sampleRate);
        fmDemod = new FrequencyModulation(signalBandwidth, sampleRate);  // Use full signal bandwidth
        
        // Sync detection
        syncPulseFrequencyValue = (float)normalizeFrequency(SYNC_PULSE_FREQ);
        syncPulseFrequencyTolerance = (float)(100 * 2 / signalBandwidth);  // Â±100 Hz tolerance
        
        // Schmitt trigger thresholds: sync is at -0.778, so trigger below -0.7 and above -0.5
        double syncLowFrequency = 1250;  // Slightly above sync (trigger when dropping below)
        double syncHighFrequency = 1400;  // Between sync and black (trigger when rising above)
        syncTrigger = new SchmittTrigger(
            (float)normalizeFrequency(syncLowFrequency),
            (float)normalizeFrequency(syncHighFrequency)
        );
        
        System.out.printf("   IQ Demod: center=%.0f Hz, signal BW=%.0f Hz, scan BW=%.0f Hz\n",
            centerFrequency, signalBandwidth, scanLineBandwidth);
        System.out.printf("   Sync: value=%.3f (%.0f Hz), tolerance=Â±%.3f\n",
            syncPulseFrequencyValue, SYNC_PULSE_FREQ, syncPulseFrequencyTolerance);
        System.out.printf("   Schmitt: low=%.3f (%.0f Hz), high=%.3f (%.0f Hz)\n",
            normalizeFrequency(syncLowFrequency), syncLowFrequency,
            normalizeFrequency(syncHighFrequency), syncHighFrequency);
    }
    
    private double normalizeFrequency(double frequency) {
        return (frequency - centerFrequency) * 2 / signalBandwidth;
    }
    
    public boolean process(short[] audioBuffer, float[] demodBuffer) {
        boolean syncPulseDetected = false;
        
        // Debug: Sample some values
        boolean firstChunk = (sampleCounter < 100);
        int debugInterval = 100;
        
        for (int i = 0; i < audioBuffer.length; i++) {
            float sample = audioBuffer[i] / 32768.0f;
            
            // IQ demodulation
            baseband.set(sample);
            baseband = basebandFilter.push(baseband.mul(basebandOscillator.rotate()));
            float frequencyValue = fmDemod.demod(baseband);
            
            // Sync detection
            float syncPulseValue = syncPulseFilter.avg(frequencyValue);
            float syncPulseDelayedValue = syncPulseValueDelay.push(syncPulseValue);
            
            demodBuffer[i] = frequencyValue;
            
            // Debug output
            if (firstChunk && sampleCounter % debugInterval == 0) {
                System.out.printf("      Sample %d: freq=%.3f, sync=%.3f, trigger=%s, counter=%d\n",
                    sampleCounter, frequencyValue, syncPulseValue, syncTrigger.state, syncPulseCounter);
            }
            sampleCounter++;
            
            if (!syncTrigger.latch(syncPulseValue)) {
                syncPulseCounter++;
            } else if (syncPulseCounter >= 20 && syncPulseCounter <= 200 &&
                       Math.abs(syncPulseDelayedValue - syncPulseFrequencyValue) <= syncPulseFrequencyTolerance) {
                // Valid sync
                if (syncPulseCounter < syncPulse5msMaxSamples) {
                    syncPulseWidth = SyncPulseWidth.FIVE_MS;
                } else if (syncPulseCounter < syncPulse9msMaxSamples) {
                    syncPulseWidth = SyncPulseWidth.NINE_MS;
                } else {
                    syncPulseWidth = SyncPulseWidth.TWENTY_MS;
                }
                syncPulseOffset = i - syncPulseFilterDelay;
                frequencyOffset = syncPulseDelayedValue - syncPulseFrequencyValue;
                lastSyncCounter = syncPulseCounter;
                syncPulseDetected = true;
                syncPulseCounter = 0;
            } else {
                syncPulseCounter = 0;
            }
        }
        
        return syncPulseDetected;
    }
}

// Helper classes (simplified versions)
class Complex {
    float real, imag;
    void set(float r) { real = r; imag = 0; }
    Complex mul(Complex other) {
        return new Complex(real * other.real - imag * other.imag,
                          real * other.imag + imag * other.real);
    }
    float arg() { return (float)Math.atan2(imag, real); }
    Complex() { real = 0; imag = 0; }
    Complex(float r, float i) { real = r; imag = i; }
}

class Phasor {
    private Complex rotation;
    private Complex position = new Complex(1, 0);
    Phasor(double frequency, int sampleRate) {
        double angle = 2 * Math.PI * frequency / sampleRate;
        rotation = new Complex((float)Math.cos(angle), (float)Math.sin(angle));
    }
    Complex rotate() {
        Complex result = new Complex(position.real, position.imag);
        position = position.mul(rotation);
        // Normalize periodically
        float mag = (float)Math.sqrt(position.real * position.real + position.imag * position.imag);
        if (Math.abs(mag - 1.0) > 0.01) {
            position.real /= mag;
            position.imag /= mag;
        }
        return result;
    }
}

class ComplexConvolution {
    private float[] taps;
    private Complex[] buffer;
    private int pos = 0;
    
    ComplexConvolution(int length, double cutoffFreq, int sampleRate) {
        taps = new float[length];
        buffer = new Complex[length];
        for (int i = 0; i < length; i++) buffer[i] = new Complex();
        
        // Kaiser window + sinc filter
        for (int i = 0; i < length; i++) {
            double window = kaiser(i, length);
            double normalized = 2.0 * cutoffFreq / sampleRate;
            int center = (length - 1) / 2;
            double x = Math.PI * normalized * (i - center);
            taps[i] = (float)(window * (x == 0 ? normalized : Math.sin(x) / (Math.PI * (i - center))));
        }
    }
    
    private double kaiser(int i, int length) {
        double alpha = 2.0;
        double x = 2.0 * i / (length - 1) - 1.0;
        return i0(alpha * Math.sqrt(1 - x * x)) / i0(alpha);
    }
    
    private double i0(double x) {
        double sum = 1, term = 1;
        for (int n = 1; n < 20; n++) {
            term *= (x / (2.0 * n)) * (x / (2.0 * n));
            sum += term;
        }
        return sum;
    }
    
    Complex push(Complex sample) {
        buffer[pos] = new Complex(sample.real, sample.imag);
        pos = (pos + 1) % buffer.length;
        
        Complex result = new Complex();
        for (int i = 0; i < buffer.length; i++) {
            int idx = (pos + i) % buffer.length;
            result.real += buffer[idx].real * taps[i];
            result.imag += buffer[idx].imag * taps[i];
        }
        return result;
    }
}

class FrequencyModulation {
    private Complex prev = new Complex(1, 0);
    private double signalBandwidth;  // Use full signal bandwidth, not just scanline
    private int sampleRate;
    
    FrequencyModulation(double signalBandwidth, int sampleRate) {
        this.signalBandwidth = signalBandwidth;
        this.sampleRate = sampleRate;
    }
    
    float demod(Complex sample) {
        // Phase difference
        Complex conjugate = new Complex(prev.real, -prev.imag);
        Complex product = sample.mul(conjugate);
        float phase = product.arg();
        prev = new Complex(sample.real, sample.imag);
        
        // Convert phase diff (radians/sample) to normalized frequency [-1, +1]
        // phase * sampleRate / (2*PI) = Hz deviation from center
        // Normalize by half bandwidth to get [-1, +1] range
        float frequency = phase * sampleRate / ((float)Math.PI * (float)signalBandwidth);
        return Math.max(-1, Math.min(1, frequency));
    }
}

class SimpleMovingAverage {
    private float[] buffer;
    private int pos = 0;
    private float sum = 0;
    
    SimpleMovingAverage(int length) {
        buffer = new float[length];
    }
    
    float avg(float sample) {
        sum -= buffer[pos];
        buffer[pos] = sample;
        sum += sample;
        pos = (pos + 1) % buffer.length;
        return sum / buffer.length;
    }
}

class Delay {
    private float[] buffer;
    private int pos = 0;
    
    Delay(int length) {
        buffer = new float[length];
    }
    
    float push(float sample) {
        float result = buffer[pos];
        buffer[pos] = sample;
        pos = (pos + 1) % buffer.length;
        return result;
    }
}

class SchmittTrigger {
    private float low, high;
    boolean state = true;  // Made public for debugging
    
    SchmittTrigger(float low, float high) {
        this.low = low;
        this.high = high;
    }
    
    boolean latch(float value) {
        if (value < low) state = false;
        else if (value > high) state = true;
        return state;
    }
}