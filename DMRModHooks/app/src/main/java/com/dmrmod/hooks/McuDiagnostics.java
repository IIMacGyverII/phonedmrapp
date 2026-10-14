package com.dmrmod.hooks;

import android.app.Activity;
import android.app.AlertDialog;
import android.graphics.Typeface;
import android.widget.ScrollView;
import android.widget.TextView;
import android.widget.Toast;

import java.nio.ByteBuffer;
import java.nio.ByteOrder;
import java.util.Locale;

import de.robv.android.xposed.XposedBridge;
import de.robv.android.xposed.XposedHelpers;

/**
 * Two read-only diagnostics for the Device tab.
 *
 * 1. MCU channel readback — sends QUERY_DIGITAL_INFO (0x24), QUERY_ANALOG_INFO (0x25) and
 *    QUERY_MIX_CHECK_INFO (0x39). The MCU answers with the channel images it holds (163 / 19 /
 *    169 bytes; verified on-device 2026-10-14, docs/grok-deep-dive/11-firmware-fw0-results.md §15).
 *    Replies are captured by MainHook's MessageDispatcher.onReceive hook via {@link #onReply}.
 *    Layouts follow the OEM DigitalMessage / AnalogMessage / MixCheckMessage encodeBody()
 *    (docs/deep-dive/02-oem-messages-and-handlers.md §3.2, §3.1, §3.19).
 *
 * 2. RX audio layout probe (backlog gate G1) — for N consecutive writeAudioTrack chunks, tests
 *    whether consecutive 16-bit samples come in equal pairs. The OEM AudioTrack is
 *    8 kHz / CHANNEL_OUT_STEREO; the module has always treated the bytes as 16 kHz mono.
 *    Open-squelch noise on any analog channel is enough input.
 *
 * Nothing here writes to the radio.
 */
public final class McuDiagnostics {

    private static final String TAG = "DMRModHooks";

    private McuDiagnostics() { }

    // ------------------------------------------------------------------ readback

    private static volatile byte[] lastDigital;
    private static volatile byte[] lastAnalog;
    private static volatile byte[] lastMix;
    private static volatile long lastReplyMs;

    /** Called from the MessageDispatcher.onReceive hook for every inbound packet. */
    public static void onReply(Object packet) {
        try {
            byte cmd = (Byte) XposedHelpers.getObjectField(packet, "cmd");
            byte rw = (Byte) XposedHelpers.getObjectField(packet, "rw");
            if (rw != 0) return;
            byte[] body = (byte[]) XposedHelpers.getObjectField(packet, "body");
            if (body == null) return;
            switch (cmd & 0xFF) {
                case 0x24: lastDigital = body.clone(); lastReplyMs = System.currentTimeMillis(); break;
                case 0x25: lastAnalog = body.clone(); lastReplyMs = System.currentTimeMillis(); break;
                case 0x39: lastMix = body.clone(); lastReplyMs = System.currentTimeMillis(); break;
                default: break;
            }
        } catch (Throwable t) {
            // never let a diagnostic break the dispatcher
        }
    }

    /** Build an OEM Packet(cmd) with rw=1 sr=1 body={1} and hand it to SerialManager.send(). */
    public static void sendQuery(ClassLoader cl, int cmd) {
        try {
            Class<?> packetClass = XposedHelpers.findClass("com.pri.prizeinterphone.protocol.Packet", cl);
            Object packet = XposedHelpers.newInstance(packetClass, (byte) cmd);
            XposedHelpers.setByteField(packet, "rw", (byte) 1);
            XposedHelpers.setByteField(packet, "sr", (byte) 1);
            XposedHelpers.setObjectField(packet, "body", new byte[]{1});
            Class<?> sm = XposedHelpers.findClass("com.pri.prizeinterphone.serial.SerialManager", cl);
            Object serialManager = XposedHelpers.callStaticMethod(sm, "getInstance");
            XposedHelpers.callMethod(serialManager, "send", packet);
        } catch (Throwable t) {
            XposedBridge.log(TAG + ": McuDiagnostics.sendQuery(0x" + Integer.toHexString(cmd) + ") failed: " + t);
        }
    }

    /** Device-tab action: query all three images, wait, decode, show. */
    public static void readChannelImages(final Activity activity, final ClassLoader cl) {
        if (cl == null) {
            Toast.makeText(activity, "Class loader not ready", Toast.LENGTH_SHORT).show();
            return;
        }
        lastDigital = null; lastAnalog = null; lastMix = null;
        Toast.makeText(activity, "Querying MCU…", Toast.LENGTH_SHORT).show();
        new Thread(new Runnable() {
            @Override public void run() {
                try {
                    sendQuery(cl, 0x24); Thread.sleep(400);
                    sendQuery(cl, 0x25); Thread.sleep(400);
                    sendQuery(cl, 0x39);
                    long end = System.currentTimeMillis() + 2500;
                    while (System.currentTimeMillis() < end
                            && (lastDigital == null || lastAnalog == null || lastMix == null)) {
                        Thread.sleep(100);
                    }
                } catch (InterruptedException ignored) { }
                final String text = formatReadback();
                XposedBridge.log(TAG + ": MCU readback\n" + text);
                activity.runOnUiThread(new Runnable() {
                    @Override public void run() { showText(activity, "🧪 MCU channel images", text); }
                });
            }
        }, "mcu-readback").start();
    }

    static String formatReadback() {
        StringBuilder sb = new StringBuilder();
        sb.append("== Digital (0x24) ==\n");
        sb.append(lastDigital == null ? "no reply\n" : decodeDigital(lastDigital));
        sb.append("\n== Analog (0x25) ==\n");
        sb.append(lastAnalog == null ? "no reply\n" : decodeAnalog(lastAnalog, 0));
        sb.append("\n== Mix-check (0x39) ==\n");
        sb.append(lastMix == null ? "no reply\n" : decodeMix(lastMix));
        return sb.toString();
    }

    private static int u8(byte[] b, int i) { return i < b.length ? (b[i] & 0xFF) : -1; }

    private static int i32le(byte[] b, int i) {
        if (i + 4 > b.length) return -1;
        return ByteBuffer.wrap(b, i, 4).order(ByteOrder.LITTLE_ENDIAN).getInt();
    }

    private static String mhz(int hz) { return String.format(Locale.US, "%.6f MHz", hz / 1e6); }

    /** 163-byte DigitalMessage body. */
    static String decodeDigital(byte[] b) {
        StringBuilder sb = new StringBuilder();
        sb.append(String.format(Locale.US, "len %d%s\n", b.length, b.length == 163 ? "" : "  (expected 163)"));
        sb.append("rxFreq      ").append(mhz(i32le(b, 0))).append('\n');
        sb.append("txFreq      ").append(mhz(i32le(b, 4))).append('\n');
        sb.append("localId     ").append(i32le(b, 8)).append('\n');
        StringBuilder g = new StringBuilder();
        int n = 0;
        for (int k = 0; k < 32; k++) {
            int v = i32le(b, 12 + 4 * k);
            if (v != 0) { if (n++ > 0) g.append(", "); g.append(v); }
        }
        sb.append("groups[32]  ").append(n).append(" set").append(n > 0 ? ": " + g : "").append('\n');
        sb.append("txContact   ").append(i32le(b, 140)).append('\n');
        int ct = u8(b, 144);
        sb.append("contactType ").append(ct).append(ct == 0 ? " (PERSON)" : ct == 1 ? " (GROUP)" : ct == 2 ? " (ALL)" : "").append('\n');
        sb.append("power       ").append(u8(b, 145)).append('\n');
        sb.append("colorCode   ").append(u8(b, 146)).append('\n');
        sb.append("slots in/out ").append(u8(b, 147)).append('/').append(u8(b, 148)).append('\n');
        int mode = u8(b, 149);
        sb.append("channelMode ").append(mode).append(mode == 0 ? " (Direct)" : mode == 4 ? " (Double-slot)" : "").append('\n');
        int enc = u8(b, 150);
        sb.append("encryptSw   ").append(enc).append(enc == 1 ? " (on)" : enc == 2 ? " (off)" : "").append('\n');
        StringBuilder key = new StringBuilder();
        for (int k = 151; k < 159 && k < b.length; k++) key.append(String.format("%02X", b[k]));
        sb.append("encryptKey  ").append(key).append('\n');
        sb.append("pwrSave     ").append(u8(b, 159)).append('\n');
        sb.append("volume      ").append(u8(b, 160)).append('\n');
        sb.append("mic         ").append(u8(b, 161)).append('\n');
        int relay = u8(b, 162);
        sb.append("relay       ").append(relay).append(relay == 1 ? " (disconnect ON)" : relay == 2 ? " (normal)" : "").append('\n');
        return sb.toString();
    }

    /** 19-byte AnalogMessage body, starting at offset {@code o}. */
    static String decodeAnalog(byte[] b, int o) {
        StringBuilder sb = new StringBuilder();
        if (o == 0) sb.append(String.format(Locale.US, "len %d%s\n", b.length, b.length == 19 ? "" : "  (expected 19)"));
        sb.append("rxFreq      ").append(mhz(i32le(b, o))).append('\n');
        sb.append("txFreq      ").append(mhz(i32le(b, o + 4))).append('\n');
        int band = u8(b, o + 8);
        sb.append("band        ").append(band).append(band == 0 ? " (narrow 12.5k)" : band == 1 ? " (wide 25k)" : "").append('\n');
        sb.append("power       ").append(u8(b, o + 9)).append('\n');
        sb.append("sq          ").append(u8(b, o + 10)).append('\n');
        sb.append("rxTone      ").append(tone(u8(b, o + 11), u8(b, o + 12))).append('\n');
        sb.append("txTone      ").append(tone(u8(b, o + 13), u8(b, o + 14))).append('\n');
        sb.append("pwrSave     ").append(u8(b, o + 15)).append('\n');
        sb.append("volume      ").append(u8(b, o + 16)).append('\n');
        sb.append("monitor     ").append(u8(b, o + 17)).append('\n');
        sb.append("relay       ").append(u8(b, o + 18)).append('\n');
        return sb.toString();
    }

    private static String tone(int type, int sub) {
        try {
            return "type " + type + " sub " + sub + " = " + ToneConverter.formatForDisplay(type, sub);
        } catch (Throwable t) {
            return "type " + type + " sub " + sub;
        }
    }

    /** 169-byte MixCheckMessage body: a digital block then an analog tail (ch. 02 §3.19). */
    static String decodeMix(byte[] b) {
        boolean allZero = true;
        for (byte x : b) if (x != 0) { allZero = false; break; }
        StringBuilder sb = new StringBuilder();
        sb.append(String.format(Locale.US, "len %d%s\n", b.length, b.length == 169 ? "" : "  (expected 169)"));
        if (allZero) { sb.append("all zero (mix-check slot never written)\n"); return sb.toString(); }
        sb.append("digital block:\n").append(decodeDigital(b));
        sb.append("raw tail [163..]: ");
        for (int k = 163; k < b.length; k++) sb.append(String.format("%02X ", b[k]));
        sb.append('\n');
        return sb.toString();
    }

    // ------------------------------------------------------------------ audio layout probe

    private static volatile int probeChunksRemaining = 0;
    private static long pTotalPairs, pEqualPairs, pZeroEven, pZeroOdd, pSumAbsEven, pSumAbsOdd, pChunks, pBytes;
    private static double pCorrNum, pCorrDenE, pCorrDenO;
    private static int pMinLen = Integer.MAX_VALUE, pMaxLen = 0;

    public static boolean probeActive() { return probeChunksRemaining > 0; }

    /** Called from the writeAudioTrack hook with the raw chunk, before any squelch muting. */
    public static void probeChunk(byte[] data, int len) {
        if (probeChunksRemaining <= 0 || data == null) return;
        int n = Math.min(len, data.length) & ~3; // whole 4-byte sample pairs
        synchronized (McuDiagnostics.class) {
            pChunks++; pBytes += len;
            if (len < pMinLen) pMinLen = len;
            if (len > pMaxLen) pMaxLen = len;
            for (int i = 0; i + 3 < n; i += 4) {
                int e = (short) ((data[i] & 0xFF) | (data[i + 1] << 8));      // even sample (L if stereo)
                int o = (short) ((data[i + 2] & 0xFF) | (data[i + 3] << 8));  // odd sample  (R if stereo)
                pTotalPairs++;
                if (e == o) pEqualPairs++;
                if (e == 0) pZeroEven++;
                if (o == 0) pZeroOdd++;
                pSumAbsEven += Math.abs(e);
                pSumAbsOdd += Math.abs(o);
                pCorrNum += (double) e * o;
                pCorrDenE += (double) e * e;
                pCorrDenO += (double) o * o;
            }
            probeChunksRemaining--;
        }
    }

    public static void startAudioLayoutProbe(final Activity activity) {
        synchronized (McuDiagnostics.class) {
            pTotalPairs = pEqualPairs = pZeroEven = pZeroOdd = pSumAbsEven = pSumAbsOdd = pChunks = pBytes = 0;
            pCorrNum = pCorrDenE = pCorrDenO = 0;
            pMinLen = Integer.MAX_VALUE; pMaxLen = 0;
            probeChunksRemaining = 60; // ~4 s at 64 ms per chunk
        }
        Toast.makeText(activity, "Probing RX audio — open the squelch or receive something (15 s)…", Toast.LENGTH_LONG).show();
        new Thread(new Runnable() {
            @Override public void run() {
                long end = System.currentTimeMillis() + 15000;
                while (System.currentTimeMillis() < end && probeChunksRemaining > 0) {
                    try { Thread.sleep(200); } catch (InterruptedException ignored) { }
                }
                probeChunksRemaining = 0;
                final String text = formatProbe();
                XposedBridge.log(TAG + ": RX audio layout probe\n" + text);
                activity.runOnUiThread(new Runnable() {
                    @Override public void run() { showText(activity, "🔬 RX audio layout", text); }
                });
            }
        }, "audio-layout-probe").start();
    }

    static synchronized String formatProbe() {
        StringBuilder sb = new StringBuilder();
        if (pChunks == 0 || pTotalPairs == 0) {
            sb.append("No audio chunks arrived in 15 s.\nOpen the squelch (Soft SQ off, hardware sq 0) on an analog channel and retry.\n");
            return sb.toString();
        }
        double eq = 100.0 * pEqualPairs / pTotalPairs;
        double zE = 100.0 * pZeroEven / pTotalPairs;
        double zO = 100.0 * pZeroOdd / pTotalPairs;
        double corr = (pCorrDenE > 0 && pCorrDenO > 0) ? pCorrNum / Math.sqrt(pCorrDenE * pCorrDenO) : 0;
        sb.append(String.format(Locale.US, "chunks %d, bytes %d, chunk len %d..%d\n", pChunks, pBytes, pMinLen, pMaxLen));
        sb.append(String.format(Locale.US, "sample pairs (even,odd): %d\n", pTotalPairs));
        sb.append(String.format(Locale.US, "even == odd:   %.2f %%\n", eq));
        sb.append(String.format(Locale.US, "even == 0:     %.2f %%   odd == 0: %.2f %%\n", zE, zO));
        sb.append(String.format(Locale.US, "mean |even| %d   mean |odd| %d\n", pSumAbsEven / pTotalPairs, pSumAbsOdd / pTotalPairs));
        sb.append(String.format(Locale.US, "corr(even,odd) %.3f\n\n", corr));
        if (eq > 98.0) {
            sb.append("VERDICT: duplicated pairs → 8 kHz STEREO with L==R.\nReal content is 8 kHz mono; every decoder is working on 2× redundant samples.\n");
        } else if (zE > 95.0 || zO > 95.0) {
            sb.append("VERDICT: one channel silent → 8 kHz STEREO with audio on one side only.\n");
        } else if (corr > 0.9) {
            sb.append("VERDICT: highly correlated but not identical pairs → stereo from one source with processing, or 16 kHz mono of a band-limited signal. Inconclusive; compare against a tone.\n");
        } else {
            sb.append("VERDICT: independent consecutive samples → 16 kHz MONO as the module assumes (or true stereo).\n");
        }
        return sb.toString();
    }

    // ------------------------------------------------------------------ ui

    private static void showText(Activity activity, String title, String text) {
        try {
            TextView tv = new TextView(activity);
            tv.setText(text);
            tv.setTypeface(Typeface.MONOSPACE);
            tv.setTextSize(12);
            tv.setTextIsSelectable(true);
            tv.setPadding(30, 20, 30, 20);
            ScrollView sv = new ScrollView(activity);
            sv.addView(tv);
            new AlertDialog.Builder(activity)
                    .setTitle(title)
                    .setView(sv)
                    .setPositiveButton("Close", null)
                    .show();
        } catch (Throwable t) {
            XposedBridge.log(TAG + ": McuDiagnostics.showText failed: " + t);
        }
    }
}
