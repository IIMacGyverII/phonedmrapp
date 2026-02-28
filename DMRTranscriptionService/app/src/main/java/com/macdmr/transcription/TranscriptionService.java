package com.macdmr.transcription;

import android.app.Notification;
import android.app.NotificationChannel;
import android.app.NotificationManager;
import android.app.Service;
import android.content.Context;
import android.content.Intent;
import android.net.ConnectivityManager;
import android.net.NetworkInfo;
import android.os.Build;
import android.os.Environment;
import android.os.IBinder;
import android.util.Base64;
import android.util.Log;
import androidx.core.app.NotificationCompat;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.nio.ByteBuffer;
import java.nio.ByteOrder;
import java.util.concurrent.TimeUnit;

import okhttp3.MediaType;
import okhttp3.OkHttpClient;
import okhttp3.Request;
import okhttp3.RequestBody;
import okhttp3.Response;

/**
 * DMR Transcription Service using Google Cloud Speech-to-Text API
 * 
 * Cost: 60 minutes/month FREE, then $0.006 per 15 seconds (~$1.44/hour)
 */
public class TranscriptionService extends Service {
    private static final String TAG = "TranscriptionService";
    private static final int NOTIFICATION_ID = 1001;
    private static final String CHANNEL_ID = "dmr_transcription_channel";
    
    // API key will be loaded from file on first use
    private String apiKey = null;
    
    private boolean isForeground = false;

    @Override
    public void onCreate() {
        super.onCreate();
        Log.i(TAG, "🚀 Service created");
        
        loadApiKey();
        
        if (apiKey == null || apiKey.isEmpty() || apiKey.equals("YOUR_API_KEY_HERE")) {
            Log.w(TAG, "⚠️ API key not configured - transcription will fail");
        } else {
            Log.i(TAG, "✅ Google Cloud Speech-to-Text ready (API key configured from " + (apiKey.startsWith("AIza") ? "file" : "BuildConfig") + ")");
        }
    }
    
    /**
     * Load API key from Download/DMR/api_key.txt, fallback to BuildConfig
     */
    private void loadApiKey() {
        try {
            File dmrFolder = new File(Environment.getExternalStoragePublicDirectory(Environment.DIRECTORY_DOWNLOADS), "DMR");
            File apiKeyFile = new File(dmrFolder, "api_key.txt");
            
            if (apiKeyFile.exists()) {
                BufferedReader reader = new BufferedReader(new FileReader(apiKeyFile));
                String key = reader.readLine();
                reader.close();
                
                if (key != null && !key.trim().isEmpty()) {
                    apiKey = key.trim();
                    Log.i(TAG, "✅ API key loaded from file: " + apiKeyFile.getAbsolutePath());
                    return;
                }
            } else {
                Log.i(TAG, "ℹ️ API key file not found: " + apiKeyFile.getAbsolutePath());
            }
        } catch (Exception e) {
            Log.e(TAG, "⚠️ Error reading API key file: " + e.getMessage());
        }
        
        // Fallback to BuildConfig
        apiKey = BuildConfig.GOOGLE_CLOUD_API_KEY;
        Log.i(TAG, "ℹ️ Using API key from BuildConfig");
    }

    @Override
    public IBinder onBind(Intent intent) {
        Log.i(TAG, "📞 Service bound by client");
        
        // Start as foreground service when first bound
        if (!isForeground) {
            startForeground(NOTIFICATION_ID, createNotification());
            isForeground = true;
            Log.i(TAG, "🎯 Started as foreground service");
        }
        
        return binder;
    }

    @Override
    public boolean onUnbind(Intent intent) {
        Log.i(TAG, "📴 Service unbound by client");
        return super.onUnbind(intent);
    }

    @Override
    public int onStartCommand(Intent intent, int flags, int startId) {
        return START_STICKY;
    }

    private final ITranscriptionService.Stub binder = new ITranscriptionService.Stub() {
        @Override
        public String transcribe(byte[] pcmBytes, int sampleRate) {
            Log.i(TAG, "📥 Received transcription request: " + pcmBytes.length + " bytes @ " + sampleRate + " Hz");
            
            if (apiKey == null || apiKey.isEmpty() || apiKey.equals("YOUR_API_KEY_HERE")) {
                return "[API key not configured - Press TXT to configure]";
            }
            
            // Check network connectivity
            if (!isNetworkAvailable()) {
                Log.e(TAG, "❌ No network connection available");
                return "[No network connection]";
            }
            
            try {
                // 1. Convert PCM to WAV format
                byte[] wavBytes = convertPcmToWav(pcmBytes, sampleRate);
                Log.d(TAG, "✅ Converted to WAV: " + wavBytes.length + " bytes");
                
                // 2. Encode to base64
                String base64Audio = Base64.encodeToString(wavBytes, Base64.NO_WRAP);
                Log.d(TAG, "✅ Encoded to base64: " + base64Audio.length() + " chars");
                
                // 3. Build JSON request
                JSONObject config = new JSONObject();
                config.put("encoding", "LINEAR16");
                config.put("sampleRateHertz", sampleRate);
                config.put("languageCode", "en-US");
                config.put("enableAutomaticPunctuation", true);
                
                JSONObject audio = new JSONObject();
                audio.put("content", base64Audio);
                
                JSONObject requestJson = new JSONObject();
                requestJson.put("config", config);
                requestJson.put("audio", audio);
                
                Log.d(TAG, "✅ Built JSON request");
                
                // 4. Make HTTP POST request with proper timeouts
                OkHttpClient client = new OkHttpClient.Builder()
                    .connectTimeout(30, TimeUnit.SECONDS)
                    .readTimeout(30, TimeUnit.SECONDS)
                    .writeTimeout(30, TimeUnit.SECONDS)
                    .build();
                    
                RequestBody body = RequestBody.create(
                    requestJson.toString(),
                    MediaType.parse("application/json; charset=utf-8")
                );
                
                String apiUrl = "https://speech.googleapis.com/v1/speech:recognize?key=" + apiKey;
                Log.d(TAG, "🌐 Calling API: " + apiUrl.substring(0, apiUrl.indexOf("?key=")));
                
                Request request = new Request.Builder()
                    .url(apiUrl)
                    .post(body)
                    .build();
                
                Response response = client.newCall(request).execute();
                String responseBody = response.body().string();
                
                if (!response.isSuccessful()) {
                    Log.e(TAG, "❌ API error " + response.code() + ": " + responseBody);
                    return "[API error: " + response.code() + "]";
                }
                
                Log.d(TAG, "✅ Received API response: " + responseBody.length() + " bytes");
                
                // 5. Parse JSON response
                JSONObject jsonResponse = new JSONObject(responseBody);
                
                if (!jsonResponse.has("results")) {
                    Log.w(TAG, "⚠️ No speech detected in audio");
                    return "";
                }
                
                JSONArray results = jsonResponse.getJSONArray("results");
                if (results.length() > 0) {
                    JSONObject firstResult = results.getJSONObject(0);
                    JSONArray alternatives = firstResult.getJSONArray("alternatives");
                    if (alternatives.length() > 0) {
                        String transcript = alternatives.getJSONObject(0).getString("transcript");
                        Log.i(TAG, "📤 Transcription: " + transcript);
                        return transcript;
                    }
                }
                
                Log.w(TAG, "⚠️ Empty results from API");
                return "";
                
            } catch (JSONException e) {
                Log.e(TAG, "❌ JSON error: " + e.toString(), e);
                return "[JSON error: " + e.getMessage() + "]";
            } catch (IOException e) {
                Log.e(TAG, "❌ Network error: " + e.toString(), e);
                return "[Network error: " + e.getMessage() + "]";
            } catch (Exception e) {
                Log.e(TAG, "❌ Transcription exception: " + e.toString(), e);
                return "[Error: " + e.getMessage() + "]";
            }
        }

        @Override
        public boolean isReady() {
            boolean ready = apiKey != null && !apiKey.isEmpty() && !apiKey.equals("YOUR_API_KEY_HERE");
            Log.d(TAG, "isReady() = " + ready + " (key: " + (apiKey != null ? (apiKey.length() + " chars") : "null") + ")");
            return ready;
        }
    };

    /**
     * Check if network connection is available
     */
    private boolean isNetworkAvailable() {
        ConnectivityManager connectivityManager = 
            (ConnectivityManager) getSystemService(Context.CONNECTIVITY_SERVICE);
        if (connectivityManager != null) {
            NetworkInfo activeNetworkInfo = connectivityManager.getActiveNetworkInfo();
            boolean available = activeNetworkInfo != null && activeNetworkInfo.isConnected();
            Log.d(TAG, "Network available: " + available);
            return available;
        }
        Log.w(TAG, "ConnectivityManager is null");
        return false;
    }

    private Notification createNotification() {
        // Create notification channel (Android 8+)
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            NotificationChannel channel = new NotificationChannel(
                CHANNEL_ID,
                "DMR Transcription Service",
                NotificationManager.IMPORTANCE_LOW
            );
            channel.setDescription("Processes DMR audio transcription via Google Cloud");
            NotificationManager manager = getSystemService(NotificationManager.class);
            if (manager != null) {
                manager.createNotificationChannel(channel);
            }
        }

        // Build notification
        NotificationCompat.Builder builder = new NotificationCompat.Builder(this, CHANNEL_ID)
                .setContentTitle("DMR Transcription Active")
                .setContentText("Google Cloud Speech-to-Text Ready")
                .setSmallIcon(android.R.drawable.ic_btn_speak_now)
                .setPriority(NotificationCompat.PRIORITY_LOW)
                .setOngoing(true);

        return builder.build();
    }

    /**
     * Convert raw PCM audio to WAV format with proper header
     * @param pcmData Raw PCM audio bytes (16-bit little-endian)
     * @param sampleRate Sample rate in Hz
     * @return WAV file bytes
     */
    private byte[] convertPcmToWav(byte[] pcmData, int sampleRate) throws IOException {
        ByteArrayOutputStream out = new ByteArrayOutputStream();
        
        int channels = 1; // Mono
        int bitsPerSample = 16; // 16-bit PCM
        int byteRate = sampleRate * channels * bitsPerSample / 8;
        int blockAlign = channels * bitsPerSample / 8;
        int dataSize = pcmData.length;
        int chunkSize = 36 + dataSize;
        
        // WAV header (44 bytes)
        ByteBuffer header = ByteBuffer.allocate(44);
        header.order(ByteOrder.LITTLE_ENDIAN);
        
        // RIFF chunk
        header.put("RIFF".getBytes()); // ChunkID
        header.putInt(chunkSize); // ChunkSize
        header.put("WAVE".getBytes()); // Format
        
        // fmt sub-chunk
        header.put("fmt ".getBytes()); // Subchunk1ID
        header.putInt(16); // Subchunk1Size (16 for PCM)
        header.putShort((short) 1); // AudioFormat (1 = PCM)
        header.putShort((short) channels); // NumChannels
        header.putInt(sampleRate); // SampleRate
        header.putInt(byteRate); // ByteRate
        header.putShort((short) blockAlign); // BlockAlign
        header.putShort((short) bitsPerSample); // BitsPerSample
        
        // data sub-chunk
        header.put("data".getBytes()); // Subchunk2ID
        header.putInt(dataSize); // Subchunk2Size
        
        // Write header and PCM data
        out.write(header.array());
        out.write(pcmData);
        
        return out.toByteArray();
    }

    @Override
    public void onDestroy() {
        super.onDestroy();
        Log.i(TAG, "🛑 Service destroyed");
    }
}
