package com.macdmr.radio;

import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.util.Log;

/**
 * Bench tools for the developer, reachable only from adb: RadioService registers it at runtime with the DUMP
 * permission required of the sender, which the shell holds and apps cannot get.
 * <pre>
 * am broadcast -a com.macdmr.radio.DIAG --es cmd inject --es path /sdcard/Download/x.wav
 * am broadcast -a com.macdmr.radio.DIAG --es cmd isline --es line "SRC>APRS,TCPIP*::DEST     :hi{1"
 * am broadcast -a com.macdmr.radio.DIAG --es cmd heard --es call DEST        (as if DEST was heard on the radio)
 * am broadcast -a com.macdmr.radio.DIAG --es cmd benchIgate --ez on true       (gate to RF without APRS-IS and off 144.390)
 * am broadcast -a com.macdmr.radio.DIAG --es cmd pkt --es what object|bulletin|telemetry|weather|cwid|beacon|connect|disconnect
 * </pre>
 * {@code inject} plays a WAV file (16-bit PCM, any rate, mono or stereo) into the receive path in real time, as if
 * the radio heard it: decoders, the parrot and the DTMF remote see it, nothing is keyed by the injection itself.
 */
public final class DiagReceiver extends BroadcastReceiver {
    public static final String ACTION = "com.macdmr.radio.DIAG";
    @Override public void onReceive(Context c, Intent i) {
        RadioService s = RadioService.running;
        String cmd = i.getStringExtra("cmd");
        Log.i("DiagReceiver", "cmd " + cmd);
        if (s == null || cmd == null) return;
        switch (cmd) {
            case "inject": s.injectWav(new java.io.File(i.getStringExtra("path"))); break;
            case "isline": if (s.packet() != null) s.packet().diagServerLine(i.getStringExtra("line")); break;
            case "heard": if (s.packet() != null) s.packet().diagHeard(i.getStringExtra("call")); break;
            case "vfo": {                                                       // receive bench: the VFO on --ei hz (wide, low power; nothing is keyed)
                int hz = i.getIntExtra("hz", 0); if (hz < 136_000_000 || hz > 480_000_000) { Log.w("DiagReceiver", "vfo: bad hz " + hz); break; }
                s.diagVfo(hz); break;
            }
            case "vfooff": s.diagVfoOff(); break;
            case "leadtest": if (s.packet() != null) Log.i("DiagReceiver", "leadtest: " + s.packet().diagLeadTest(i.getIntExtra("kind", 0), i.getIntExtra("ms", 1600), i.getIntExtra("reps", 1), String.valueOf(i.getStringExtra("tag")))); break;   // one status packet, current channel
            case "sattest": {                                                   // a fake ISS pass from a minute from now for 30 s (or --el ms), --es key iss-rptr|iss-aprs|iss-sstv; nothing is keyed
                com.macdmr.radio.ham.Sgp4 e = s.satellites().elements().get(25544);
                if (e == null) { Log.w("DiagReceiver", "no ISS elements"); break; }
                long len = i.getLongExtra("len", 30_000);
                com.macdmr.radio.ham.SatTrack.Pass p = new com.macdmr.radio.ham.SatTrack.Pass(); p.aos = System.currentTimeMillis() + 60_000; p.los = p.aos + len; p.tca = p.aos; p.maxEl = 45;
                String key = i.getStringExtra("key"); if (key == null) key = "iss-rptr";
                Log.i("DiagReceiver", "sattest " + key + ": " + s.trackSat(com.macdmr.radio.ham.Satellites.byKey(s, key), e, p)); break;
            }
            case "iconpng": try {                                  // the launcher icon as the launcher draws it (adaptive, circle mask), for checking the artwork
                android.graphics.drawable.Drawable d = s.getPackageManager().getApplicationIcon(s.getPackageName());
                android.graphics.Bitmap bm = android.graphics.Bitmap.createBitmap(432, 432, android.graphics.Bitmap.Config.ARGB_8888);
                android.graphics.Canvas cv = new android.graphics.Canvas(bm); d.setBounds(0, 0, 432, 432); d.draw(cv);
                try (java.io.FileOutputStream o = new java.io.FileOutputStream(new java.io.File(s.getExternalFilesDir(null), "icon.png"))) { bm.compress(android.graphics.Bitmap.CompressFormat.PNG, 100, o); }
                Log.i("DiagReceiver", "icon saved");
            } catch (Throwable t) { Log.w("DiagReceiver", "iconpng: " + t); } break;
            case "callstart": Log.i("DiagReceiver", "talk call: " + com.macdmr.radio.car.RadioCallService.start(s)); break;   // places the call only: no transmission unless a wheel start is pending
            case "callend": com.macdmr.radio.car.RadioCallService.end(); break;
            case "benchIgate": if (s.packet() != null) s.packet().benchIgate = i.getBooleanExtra("on", false); break;
            case "pkt": if (s.packet() != null) Log.i("DiagReceiver", "pkt " + i.getStringExtra("what") + ": " + s.packet().diagSend(i.getStringExtra("what"))); break;
            default: Log.w("DiagReceiver", "unknown cmd " + cmd);
        }
    }
}
