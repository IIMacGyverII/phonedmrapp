# Android APRS Receiver Implementation Guide

## Architecture Overview

```
Radio Transmission → Audio Cable/BT → Phone Mic/Line-In → AudioRecord → AFSK Decoder → APRS Parser → Display
```

## Part 1: Audio Recording Setup

### AndroidManifest.xml Permissions

```xml
<!-- Add to your AndroidManifest.xml -->
<uses-permission android:name="android.permission.RECORD_AUDIO" />
<uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE" />
<uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE" />
```

### Request Permissions at Runtime

```java
// In your Activity
private static final int AUDIO_PERMISSION_CODE = 101;

private void requestAudioPermission() {
    if (ContextCompat.checkSelfPermission(this, Manifest.permission.RECORD_AUDIO)
            != PackageManager.PERMISSION_GRANTED) {
        ActivityCompat.requestPermissions(this,
                new String[]{Manifest.permission.RECORD_AUDIO},
                AUDIO_PERMISSION_CODE);
    }
}

@Override
public void onRequestPermissionsResult(int requestCode, String[] permissions, int[] grantResults) {
    super.onRequestPermissionsResult(requestCode, permissions, grantResults);
    if (requestCode == AUDIO_PERMISSION_CODE) {
        if (grantResults.length > 0 && grantResults[0] == PackageManager.PERMISSION_GRANTED) {
            // Permission granted - can start recording
        } else {
            Toast.makeText(this, "Audio permission required", Toast.LENGTH_SHORT).show();
        }
    }
}
```

## Part 2: Audio Recorder Class

```java
package com.yourpackage.aprs;

import android.media.AudioFormat;
import android.media.AudioRecord;
import android.media.MediaRecorder;
import android.util.Log;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.nio.ByteBuffer;
import java.nio.ByteOrder;
import java.util.ArrayList;
import java.util.List;

public class AprsAudioRecorder {
    private static final String TAG = "AprsAudioRecorder";
    
    // Audio parameters - match APRS/Bell 202 requirements
    private static final int SAMPLE_RATE = 44100;  // or 48000
    private static final int CHANNEL_CONFIG = AudioFormat.CHANNEL_IN_MONO;
    private static final int AUDIO_FORMAT = AudioFormat.ENCODING_PCM_16BIT;
    
    private AudioRecord audioRecord;
    private int bufferSize;
    private boolean isRecording = false;
    private Thread recordingThread;
    
    // Store recorded audio for decoding
    private List<Short> recordedSamples;
    
    public AprsAudioRecorder() {
        // Calculate minimum buffer size
        bufferSize = AudioRecord.getMinBufferSize(
                SAMPLE_RATE,
                CHANNEL_CONFIG,
                AUDIO_FORMAT
        );
        
        // Make buffer larger for better performance (2x minimum)
        bufferSize = bufferSize * 2;
        
        recordedSamples = new ArrayList<>();
    }
    
    /**
     * Start recording audio from microphone
     */
    public boolean startRecording() {
        if (isRecording) {
            Log.w(TAG, "Already recording");
            return false;
        }
        
        try {
            audioRecord = new AudioRecord(
                    MediaRecorder.AudioSource.MIC,
                    SAMPLE_RATE,
                    CHANNEL_CONFIG,
                    AUDIO_FORMAT,
                    bufferSize
            );
            
            if (audioRecord.getState() != AudioRecord.STATE_INITIALIZED) {
                Log.e(TAG, "AudioRecord initialization failed");
                return false;
            }
            
            recordedSamples.clear();
            isRecording = true;
            
            audioRecord.startRecording();
            
            recordingThread = new Thread(this::recordingLoop);
            recordingThread.start();
            
            Log.i(TAG, "Recording started");
            return true;
            
        } catch (SecurityException e) {
            Log.e(TAG, "Audio permission not granted", e);
            return false;
        } catch (Exception e) {
            Log.e(TAG, "Failed to start recording", e);
            return false;
        }
    }
    
    /**
     * Stop recording audio
     */
    public void stopRecording() {
        if (!isRecording) {
            return;
        }
        
        isRecording = false;
        
        if (audioRecord != null) {
            try {
                audioRecord.stop();
                audioRecord.release();
            } catch (Exception e) {
                Log.e(TAG, "Error stopping recording", e);
            }
            audioRecord = null;
        }
        
        if (recordingThread != null) {
            try {
                recordingThread.join();
            } catch (InterruptedException e) {
                Thread.currentThread().interrupt();
            }
            recordingThread = null;
        }
        
        Log.i(TAG, "Recording stopped. Samples: " + recordedSamples.size());
    }
    
    /**
     * Recording loop - runs in separate thread
     */
    private void recordingLoop() {
        short[] buffer = new short[bufferSize / 2];  // 16-bit samples
        
        while (isRecording) {
            int samplesRead = audioRecord.read(buffer, 0, buffer.length);
            
            if (samplesRead > 0) {
                // Store samples for later decoding
                synchronized (recordedSamples) {
                    for (int i = 0; i < samplesRead; i++) {
                        recordedSamples.add(buffer[i]);
                    }
                }
                
                // Optional: Real-time decoding
                // processAudioChunk(buffer, samplesRead);
                
            } else if (samplesRead < 0) {
                Log.e(TAG, "Read error: " + samplesRead);
                break;
            }
        }
    }
    
    /**
     * Get recorded audio samples
     */
    public short[] getRecordedSamples() {
        synchronized (recordedSamples) {
            short[] samples = new short[recordedSamples.size()];
            for (int i = 0; i < recordedSamples.size(); i++) {
                samples[i] = recordedSamples.get(i);
            }
            return samples;
        }
    }
    
    /**
     * Save recorded audio to WAV file
     */
    public boolean saveToWav(File outputFile) {
        short[] samples = getRecordedSamples();
        
        try (FileOutputStream fos = new FileOutputStream(outputFile)) {
            // Write WAV header
            writeWavHeader(fos, samples.length);
            
            // Write audio data
            ByteBuffer buffer = ByteBuffer.allocate(samples.length * 2);
            buffer.order(ByteOrder.LITTLE_ENDIAN);
            for (short sample : samples) {
                buffer.putShort(sample);
            }
            fos.write(buffer.array());
            
            Log.i(TAG, "Saved WAV file: " + outputFile.getAbsolutePath());
            return true;
            
        } catch (IOException e) {
            Log.e(TAG, "Failed to save WAV", e);
            return false;
        }
    }
    
    /**
     * Write WAV file header
     */
    private void writeWavHeader(FileOutputStream fos, int numSamples) throws IOException {
        int dataSize = numSamples * 2;  // 16-bit samples
        int fileSize = 36 + dataSize;
        
        ByteBuffer header = ByteBuffer.allocate(44);
        header.order(ByteOrder.LITTLE_ENDIAN);
        
        // RIFF chunk
        header.put("RIFF".getBytes());
        header.putInt(fileSize);
        header.put("WAVE".getBytes());
        
        // fmt chunk
        header.put("fmt ".getBytes());
        header.putInt(16);  // Chunk size
        header.putShort((short) 1);  // Audio format (PCM)
        header.putShort((short) 1);  // Number of channels (mono)
        header.putInt(SAMPLE_RATE);
        header.putInt(SAMPLE_RATE * 2);  // Byte rate
        header.putShort((short) 2);  // Block align
        header.putShort((short) 16);  // Bits per sample
        
        // data chunk
        header.put("data".getBytes());
        header.putInt(dataSize);
        
        fos.write(header.array());
    }
    
    public int getSampleRate() {
        return SAMPLE_RATE;
    }
    
    public boolean isRecording() {
        return isRecording;
    }
}
```

## Part 3: AFSK Decoder Class

```java
package com.yourpackage.aprs;

import android.util.Log;

public class AfskDecoder {
    private static final String TAG = "AfskDecoder";
    
    // Bell 202 AFSK parameters
    private static final int MARK_FREQ = 1200;   // Logical 1
    private static final int SPACE_FREQ = 2200;  // Logical 0
    private static final int BAUD_RATE = 1200;
    
    private int sampleRate;
    
    public AfskDecoder(int sampleRate) {
        this.sampleRate = sampleRate;
    }
    
    /**
     * Decode AFSK audio to NRZI bits
     */
    public byte[] decodeToBytes(short[] samples) {
        // Step 1: Extract tones (MARK/SPACE detection)
        boolean[] tones = extractTones(samples);
        
        // Step 2: NRZI decode (transition=0, no transition=1)
        boolean[] bits = nrziDecode(tones);
        
        // Step 3: Find FLAGS and extract packet data
        byte[] packetData = extractPacket(bits);
        
        return packetData;
    }
    
    /**
     * Extract MARK/SPACE tones using zero-crossing detection
     */
    private boolean[] extractTones(short[] samples) {
        double samplesPerBit = (double) sampleRate / BAUD_RATE;
        int numBits = (int) (samples.length / samplesPerBit);
        boolean[] tones = new boolean[numBits];
        
        for (int bitIdx = 0; bitIdx < numBits; bitIdx++) {
            int start = (int) (bitIdx * samplesPerBit);
            int end = (int) ((bitIdx + 1) * samplesPerBit);
            
            if (end > samples.length) {
                end = samples.length;
            }
            
            // Count zero crossings in this bit period
            int zeroCrossings = countZeroCrossings(samples, start, end);
            
            // MARK (1200 Hz) ≈ 33 crossings per bit @ 44100 Hz
            // SPACE (2200 Hz) ≈ 61 crossings per bit @ 44100 Hz
            // Threshold: ~47 crossings
            double expectedMark = 2.0 * MARK_FREQ / BAUD_RATE;
            double expectedSpace = 2.0 * SPACE_FREQ / BAUD_RATE;
            double threshold = (expectedMark + expectedSpace) / 2.0;
            
            tones[bitIdx] = (zeroCrossings < threshold);  // true = MARK, false = SPACE
        }
        
        return tones;
    }
    
    /**
     * Count zero crossings in audio segment
     */
    private int countZeroCrossings(short[] samples, int start, int end) {
        int count = 0;
        for (int i = start; i < end - 1; i++) {
            if ((samples[i] <= 0 && samples[i + 1] > 0) ||
                (samples[i] > 0 && samples[i + 1] <= 0)) {
                count++;
            }
        }
        return count;
    }
    
    /**
     * NRZI decode: transition = 0, no transition = 1
     */
    private boolean[] nrziDecode(boolean[] tones) {
        boolean[] bits = new boolean[tones.length];
        
        for (int i = 0; i < tones.length - 1; i++) {
            // Compare current tone with next tone
            if (tones[i] != tones[i + 1]) {
                bits[i] = false;  // Transition = 0
            } else {
                bits[i] = true;   // No transition = 1
            }
        }
        
        return bits;
    }
    
    /**
     * Extract packet data between FLAGS (0x7E)
     */
    private byte[] extractPacket(boolean[] bits) {
        // Convert bits to bytes
        List<Byte> bytes = new ArrayList<>();
        
        for (int i = 0; i < bits.length - 7; i += 8) {
            int byteVal = 0;
            for (int bitIdx = 0; bitIdx < 8 && (i + bitIdx) < bits.length; bitIdx++) {
                if (bits[i + bitIdx]) {
                    byteVal |= (1 << bitIdx);  // LSB first
                }
            }
            bytes.add((byte) byteVal);
        }
        
        // Find FLAGS (0x7E)
        int startFlag = -1;
        int endFlag = -1;
        
        for (int i = 0; i < bytes.size() - 1; i++) {
            if ((bytes.get(i) & 0xFF) == 0x7E) {
                if (startFlag == -1) {
                    startFlag = i;
                } else {
                    endFlag = i;
                    break;  // Found closing FLAG
                }
            }
        }
        
        if (startFlag >= 0 && endFlag > startFlag) {
            // Extract data between FLAGS
            byte[] packet = new byte[endFlag - startFlag - 1];
            for (int i = 0; i < packet.length; i++) {
                packet[i] = bytes.get(startFlag + 1 + i);
            }
            
            // Bit unstuffing needed here (remove 0 after five 1s)
            return unstuffBits(packet);
        }
        
        return null;
    }
    
    /**
     * Remove bit stuffing (0 after five consecutive 1s)
     */
    private byte[] unstuffBits(byte[] stuffedData) {
        // Convert to bits
        List<Boolean> stuffedBits = new ArrayList<>();
        for (byte b : stuffedData) {
            for (int i = 0; i < 8; i++) {
                stuffedBits.add(((b >> i) & 1) == 1);
            }
        }
        
        // Unstuff
        List<Boolean> unstuffedBits = new ArrayList<>();
        int consecutiveOnes = 0;
        
        for (int i = 0; i < stuffedBits.size(); i++) {
            boolean bit = stuffedBits.get(i);
            unstuffedBits.add(bit);
            
            if (bit) {
                consecutiveOnes++;
                if (consecutiveOnes == 5) {
                    i++;  // Skip next bit (stuffed 0)
                    consecutiveOnes = 0;
                }
            } else {
                consecutiveOnes = 0;
            }
        }
        
        // Convert back to bytes
        int numBytes = unstuffedBits.size() / 8;
        byte[] result = new byte[numBytes];
        
        for (int i = 0; i < numBytes; i++) {
            int byteVal = 0;
            for (int bitIdx = 0; bitIdx < 8; bitIdx++) {
                if (unstuffedBits.get(i * 8 + bitIdx)) {
                    byteVal |= (1 << bitIdx);
                }
            }
            result[i] = (byte) byteVal;
        }
        
        return result;
    }
}
```

## Part 4: APRS Parser Class

```java
package com.yourpackage.aprs;

public class AprsParser {
    
    public static class AprsPacket {
        public String destination;
        public int destSsid;
        public String source;
        public int sourceSsid;
        public int control;
        public int pid;
        public String info;
        public int fcs;
        public boolean fcsValid;
        
        @Override
        public String toString() {
            return String.format("%s-%d>%s-%d: %s (FCS: %s)",
                    source, sourceSsid, destination, destSsid, info,
                    fcsValid ? "✓" : "✗");
        }
    }
    
    /**
     * Parse AX.25 packet data
     */
    public static AprsPacket parse(byte[] data) {
        if (data == null || data.length < 16) {
            return null;
        }
        
        AprsPacket packet = new AprsPacket();
        
        try {
            // Destination address (bytes 0-6)
            packet.destination = decodeCallsign(data, 0);
            packet.destSsid = (data[6] >> 1) & 0x0F;
            
            // Source address (bytes 7-13)
            packet.source = decodeCallsign(data, 7);
            packet.sourceSsid = (data[13] >> 1) & 0x0F;
            
            // Control field (byte 14)
            packet.control = data[14] & 0xFF;
            
            // PID field (byte 15)
            packet.pid = data[15] & 0xFF;
            
            // Info field (rest except last 2 bytes which are FCS)
            int infoLength = data.length - 18;  // Subtract addresses, control, PID, FCS
            if (infoLength > 0) {
                byte[] infoBytes = new byte[infoLength];
                System.arraycopy(data, 16, infoBytes, 0, infoLength);
                packet.info = new String(infoBytes);
            } else {
                packet.info = "";
            }
            
            // FCS (last 2 bytes)
            int fcsLow = data[data.length - 2] & 0xFF;
            int fcsHigh = data[data.length - 1] & 0xFF;
            packet.fcs = fcsLow | (fcsHigh << 8);
            
            // Verify FCS
            byte[] dataForFcs = new byte[data.length - 2];
            System.arraycopy(data, 0, dataForFcs, 0, data.length - 2);
            int calculatedFcs = calculateFcs(dataForFcs);
            packet.fcsValid = (calculatedFcs == packet.fcs);
            
        } catch (Exception e) {
            return null;
        }
        
        return packet;
    }
    
    /**
     * Decode AX.25 callsign from 6 bytes
     */
    private static String decodeCallsign(byte[] data, int offset) {
        StringBuilder call = new StringBuilder();
        for (int i = 0; i < 6; i++) {
            char c = (char) ((data[offset + i] & 0xFF) >> 1);
            if (c != ' ') {
                call.append(c);
            }
        }
        return call.toString().trim();
    }
    
    /**
     * Calculate FCS (CRC-16-CCITT with AX.25 parameters)
     */
    private static int calculateFcs(byte[] data) {
        int fcs = 0xFFFF;
        
        for (byte b : data) {
            fcs ^= (b & 0xFF);
            for (int i = 0; i < 8; i++) {
                if ((fcs & 0x0001) != 0) {
                    fcs = (fcs >> 1) ^ 0x8408;
                } else {
                    fcs >>= 1;
                }
            }
        }
        
        return fcs ^ 0xFFFF;
    }
}
```

## Part 5: UI Activity Example

```java
public class AprsReceiverActivity extends AppCompatActivity {
    
    private AprsAudioRecorder recorder;
    private Button btnRecord;
    private TextView txtStatus;
    private TextView txtDecoded;
    
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_aprs_receiver);
        
        btnRecord = findViewById(R.id.btnRecord);
        txtStatus = findViewById(R.id.txtStatus);
        txtDecoded = findViewById(R.id.txtDecoded);
        
        recorder = new AprsAudioRecorder();
        
        btnRecord.setOnClickListener(v -> {
            if (recorder.isRecording()) {
                stopRecordingAndDecode();
            } else {
                startRecording();
            }
        });
        
        // Request permissions
        requestAudioPermission();
    }
    
    private void startRecording() {
        if (recorder.startRecording()) {
            btnRecord.setText("Stop Recording");
            txtStatus.setText("Recording APRS audio...");
            txtDecoded.setText("");
        } else {
            Toast.makeText(this, "Failed to start recording", Toast.LENGTH_SHORT).show();
        }
    }
    
    private void stopRecordingAndDecode() {
        recorder.stopRecording();
        btnRecord.setText("Start Recording");
        txtStatus.setText("Decoding...");
        
        // Decode in background thread
        new Thread(() -> {
            short[] samples = recorder.getRecordedSamples();
            
            AfskDecoder decoder = new AfskDecoder(recorder.getSampleRate());
            byte[] packetData = decoder.decodeToBytes(samples);
            
            if (packetData != null) {
                AprsParser.AprsPacket packet = AprsParser.parse(packetData);
                
                runOnUiThread(() -> {
                    if (packet != null) {
                        txtStatus.setText("Decoded successfully!");
                        txtDecoded.setText(packet.toString());
                    } else {
                        txtStatus.setText("Failed to parse packet");
                    }
                });
            } else {
                runOnUiThread(() -> {
                    txtStatus.setText("No packet found");
                });
            }
            
            // Optional: Save WAV file for analysis
            File wavFile = new File(getExternalFilesDir(null), "received_aprs.wav");
            recorder.saveToWav(wavFile);
            
        }).start();
    }
}
```

## Part 6: Testing Steps

### Hardware Setup

**Option 1: Audio Cable**
```
Radio headphone jack → 3.5mm cable → Phone microphone jack
(May need TRRS adapter)
```

**Option 2: Bluetooth**
```
Radio Bluetooth → Phone Bluetooth audio input
```

**Option 3: Direct Decode** (Advanced)
```
Radio speaker → Phone microphone (air gap)
Set radio volume appropriately
```

### Testing Procedure

1. **Build and install app** with receiver code
2. **Connect radio** to phone audio input
3. **Start recording** in app
4. **Transmit APRS beacon** from other radio
5. **Stop recording** in app
6. **View decoded packet** on screen

### Expected Results

✅ **App displays**: `EXAM-9>APZDMR: !3734.50N/12334.50W-Hello (FCS: ✓)`  
✅ **WAV file saved**: `/storage/emulated/0/Android/data/yourapp/files/received_aprs.wav`  
✅ **Can test saved WAV** with Python decoder or Dire Wolf

## Part 7: Validation

Compare three decoders:
1. **Android app decoder** (your implementation)
2. **Python parse_full_packet.py** (our verified decoder)
3. **Dire Wolf atest** (reference decoder)

If all three decode the same packet from your radio → **Transmission is valid!**

## Next Steps

1. Implement audio recorder in your Android app
2. Add AFSK decoder
3. Add APRS parser
4. Test receiving from real radio
5. Then test transmitting from app → receiving on other radio
6. **Complete two-way validation!** 🎯

This proves your APRS implementation works in real-world conditions! 📡✨
