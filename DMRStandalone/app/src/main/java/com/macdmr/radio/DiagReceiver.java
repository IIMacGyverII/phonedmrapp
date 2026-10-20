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
            default: Log.w("DiagReceiver", "unknown cmd " + cmd);
        }
    }
}
