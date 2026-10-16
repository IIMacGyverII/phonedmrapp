package com.dmrmod.hooks;

import android.util.Base64;

import org.json.JSONArray;
import org.json.JSONObject;

import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.nio.ByteBuffer;
import java.nio.ByteOrder;

import de.robv.android.xposed.XposedBridge;

/**
 * In-process speech-to-text via the Google Cloud Speech-to-Text REST API.
 *
 * <p>Folds in what used to be the separate {@code DMRTranscriptionService} app (which DMRModHooks
 * reached over AIDL/IPC). The work is plain HTTP + JSON — no native code — so it runs in the host
 * process like the other network calls (RadioID, BrandMeister, the updater), and there is no longer
 * a second APK to install. okhttp is intentionally not used: the module keeps to {@link HttpURLConnection}.
 *
 * <p>Return contract matches the old service: the transcript on success, {@code ""} when no speech
 * was detected, or a {@code [bracketed error]} string. Callers run it off the UI thread.
 */
public final class TranscriptionClient {

    private static final String TAG = "DMRModHooks";
    private static final String ENDPOINT = "https://speech.googleapis.com/v1/speech:recognize?key=";

    private TranscriptionClient() { }

    public static boolean isPlaceholderKey(String k) {
        return k == null || k.isEmpty()
            || k.equals("YOUR_API_KEY_HERE") || k.equals("YOUR_GOOGLE_CLOUD_API_KEY_HERE");
    }

    /**
     * Transcribe 16-bit little-endian PCM. Returns the transcript, {@code ""} (no speech), or a
     * bracketed error. Never throws.
     */
    public static String transcribe(byte[] pcmBytes, int sampleRate, String apiKey) {
        if (isPlaceholderKey(apiKey)) {
            return "[API key not configured - Press TXT to configure]";
        }
        HttpURLConnection conn = null;
        try {
            byte[] wav = pcmToWav(pcmBytes, sampleRate);
            String base64Audio = Base64.encodeToString(wav, Base64.NO_WRAP);

            JSONObject config = new JSONObject();
            config.put("encoding", "LINEAR16");
            config.put("sampleRateHertz", sampleRate);
            config.put("languageCode", "en-US");
            config.put("enableAutomaticPunctuation", true);
            JSONObject audio = new JSONObject();
            audio.put("content", base64Audio);
            JSONObject req = new JSONObject();
            req.put("config", config);
            req.put("audio", audio);

            conn = (HttpURLConnection) new URL(ENDPOINT + apiKey).openConnection();
            conn.setRequestMethod("POST");
            conn.setConnectTimeout(30000);
            conn.setReadTimeout(30000);
            conn.setRequestProperty("Content-Type", "application/json; charset=utf-8");
            conn.setDoOutput(true);
            OutputStream os = conn.getOutputStream();
            os.write(req.toString().getBytes("UTF-8"));
            os.flush();
            os.close();

            int code = conn.getResponseCode();
            String body = readAll(code >= 200 && code < 300 ? conn.getInputStream() : conn.getErrorStream());
            if (code < 200 || code >= 300) {
                XposedBridge.log(TAG + ": transcription API HTTP " + code + ": " + body);
                return friendlyError(code, body);
            }

            JSONObject json = new JSONObject(body);
            if (!json.has("results")) return "";   // no speech detected
            JSONArray results = json.getJSONArray("results");
            if (results.length() > 0) {
                JSONArray alts = results.getJSONObject(0).getJSONArray("alternatives");
                if (alts.length() > 0) return alts.getJSONObject(0).getString("transcript");
            }
            return "";
        } catch (IOException e) {
            XposedBridge.log(TAG + ": transcription network error: " + e);
            return "[Network error: " + e.getMessage() + "]";
        } catch (Throwable t) {
            XposedBridge.log(TAG + ": transcription error: " + t);
            return "[Error: " + t.getMessage() + "]";
        } finally {
            if (conn != null) try { conn.disconnect(); } catch (Throwable ignore) { }
        }
    }

    /**
     * Turn a Google error response into a short, actionable message (the display only has room for a
     * line or two). Falls back to the raw code if the body can't be parsed.
     */
    private static String friendlyError(int code, String body) {
        String status = "", reason = "", message = "";
        try {
            JSONObject err = new JSONObject(body).optJSONObject("error");
            if (err != null) {
                status = err.optString("status", "");
                message = err.optString("message", "");
                JSONArray details = err.optJSONArray("details");
                if (details != null) {
                    for (int i = 0; i < details.length(); i++) {
                        String r = details.getJSONObject(i).optString("reason", "");
                        if (!r.isEmpty()) { reason = r; break; }
                    }
                }
            }
        } catch (Throwable ignore) { }

        if ("BILLING_DISABLED".equals(reason))
            return "[Transcription: enable billing on your Google Cloud project]";
        if ("SERVICE_DISABLED".equals(reason) || (message != null && message.contains("has not been used")))
            return "[Transcription: enable the Cloud Speech-to-Text API in Google Cloud]";
        if (reason.startsWith("API_KEY"))   // API_KEY_INVALID, API_KEY_SERVICE_BLOCKED, API_KEY_HTTP_REFERRER_BLOCKED...
            return "[Transcription: API key invalid or not allowed for Speech-to-Text]";
        if (code == 429 || "RESOURCE_EXHAUSTED".equals(status))
            return "[Transcription: Google quota exceeded - try later]";
        if (code == 400)
            return "[Transcription: bad request (" + (message.isEmpty() ? "400" : shorten(message)) + ")]";
        return "[Transcription API error " + code + (status.isEmpty() ? "" : " " + status) + "]";
    }

    private static String shorten(String s) {
        s = s.trim();
        return s.length() > 80 ? s.substring(0, 80) + "…" : s;
    }

    /** Wrap raw 16-bit mono PCM in a 44-byte WAV header (ported from the old service). */
    private static byte[] pcmToWav(byte[] pcm, int sampleRate) throws IOException {
        int channels = 1, bitsPerSample = 16;
        int byteRate = sampleRate * channels * bitsPerSample / 8;
        int blockAlign = channels * bitsPerSample / 8;
        int dataSize = pcm.length;
        ByteBuffer header = ByteBuffer.allocate(44);
        header.order(ByteOrder.LITTLE_ENDIAN);
        header.put("RIFF".getBytes());
        header.putInt(36 + dataSize);
        header.put("WAVE".getBytes());
        header.put("fmt ".getBytes());
        header.putInt(16);
        header.putShort((short) 1);
        header.putShort((short) channels);
        header.putInt(sampleRate);
        header.putInt(byteRate);
        header.putShort((short) blockAlign);
        header.putShort((short) bitsPerSample);
        header.put("data".getBytes());
        header.putInt(dataSize);
        ByteArrayOutputStream out = new ByteArrayOutputStream(44 + dataSize);
        out.write(header.array());
        out.write(pcm);
        return out.toByteArray();
    }

    private static String readAll(InputStream in) throws IOException {
        if (in == null) return "";
        ByteArrayOutputStream b = new ByteArrayOutputStream();
        byte[] buf = new byte[8192];
        int n;
        while ((n = in.read(buf)) != -1) b.write(buf, 0, n);
        in.close();
        return new String(b.toByteArray(), "UTF-8");
    }
}
