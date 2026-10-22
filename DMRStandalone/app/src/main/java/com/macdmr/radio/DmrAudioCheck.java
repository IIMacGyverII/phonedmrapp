package com.macdmr.radio;

import android.content.Context;
import android.media.AudioDeviceInfo;
import android.media.AudioManager;
import android.os.Build;

import java.io.File;
import java.util.ArrayList;
import java.util.List;
import java.util.Locale;

/**
 * "No audio on DMR": one minute on the current channel with the evidence that tells the causes apart, and a verdict.
 *
 * On the Ulefone the receive audio comes from the vendor framework class android.os.PrizeTinyService (binder service
 * "tinyservice", daemon tinyserver); a custom ROM that replaced the system partition may lack the class even when the
 * vendor daemon still runs, and then there is no receive audio at all. Otherwise the radio itself may never report the
 * call (colour code or slot wrong, or the talkgroup missing from the channel's RX list: the MCU drops those before they
 * reach the app), the audio may arrive silent, or the phone may play it somewhere it is not heard.
 *
 * Nothing private goes in: caller IDs keep only their first three digits (the region), the app log drops the frames that
 * carry IDs or texts, and logcat lines are masked like the rest of the device report.
 */
public final class DmrAudioCheck {
    private DmrAudioCheck() { }

    /** What the minute showed, for {@link #verdict}. */
    public static final class Facts {
        public boolean classMissing, binderPresent, daemonRunning, digitalChannel, receivedAnything;
        public String audioError;                       // null if receive audio started
        public int receptions, callerReports, callsOutsideList;
        public long pcmDuringCalls, pcmTotal;
        public double rms = -1;                         // of what arrived during calls (-1 = not measured)
        public boolean muted, mediaMode, rxAudioOn = true;
        public int musicVolume = -1, musicMax = -1;
        public String output = "";                      // where media plays (speaker, Bluetooth …)
    }

    /** The most likely cause first, as plain sentences. Pure: host-tested. */
    public static List<String> verdict(Facts f) {
        List<String> v = new ArrayList<>();
        if (f.classMissing) {
            v.add("This ROM does not have Ulefone's PrizeTinyService framework class, which carries the radio's receive audio on this phone. "
                    + "SignalDeck (and the stock app) can't get any receive audio on it, analog included."
                    + (f.binderPresent ? " The vendor audio service itself is still running (binder \"tinyservice\"), so the audio exists below Android: support for this ROM means talking to that service directly — please send this report." : f.daemonRunning ? " The vendor audio daemon is running." : " The vendor audio service is not running either."));
            return v;
        }
        if (f.audioError != null) { v.add("Receive audio did not start: " + f.audioError + ". Please send this report."); return v; }
        if (!f.digitalChannel) v.add("Note: the current channel is analog; for a DMR problem run this on the DMR channel where calls are expected.");
        if (f.receptions == 0) {
            v.add("The radio never reported a reception in this minute. Either nobody transmitted, or the calls don't match this channel: "
                    + "colour code, timeslot, or a talkgroup that is not in the channel's RX group list (the radio drops calls to talkgroups outside the list before they reach the app). "
                    + "Ask someone to key up on the talkgroup and run the check again, and check the channel's RX list.");
            return v;
        }
        if (f.callsOutsideList > 0) v.add(f.callsOutsideList + " call(s) were to a target that is not in this channel's RX list or call number (they got through as private or all calls).");
        if (f.pcmDuringCalls == 0) {
            v.add("The radio received " + f.receptions + " call(s), but no audio arrived from the vendor audio service while they were on. "
                    + "The audio path below Android (the tinyservice/tinyserver daemon) is not delivering on this ROM. Please send this report.");
            return v;
        }
        if (f.rms >= 0 && f.rms < 30) {
            v.add(String.format(Locale.US, "Audio arrived during the calls but it is silent (level %.0f). The radio passed the calls on without voice: "
                    + "often a colour-code or slot mismatch on the radio side, or an encrypted call. Please send this report.", f.rms));
            return v;
        }
        if (f.muted || !f.rxAudioOn) { v.add("Audio arrived, but SignalDeck's receive audio is muted or off (the media or car mode, or the speaker switched off)."); return v; }
        if (f.musicVolume == 0) { v.add("Audio arrived, but the phone's media volume is 0. Turn it up."); return v; }
        v.add(String.format(Locale.US, "Audio arrived during the calls (level %s) and was played%s. If nothing is heard, check where the phone plays media%s and the media volume.",
                f.rms < 0 ? "not measured" : String.format(Locale.US, "%.0f", f.rms), f.output.isEmpty() ? "" : " to " + f.output, f.output.contains("Bluetooth") ? " (a Bluetooth device is connected)" : ""));
        return v;
    }

    /** Caller IDs in a public report: 3101234 → 310xxxx. */
    static String maskId(int id) { String s = String.valueOf(id); return s.length() <= 3 ? s : s.substring(0, 3) + "xxxx".substring(0, Math.min(4, s.length() - 3)); }

    /** Runs for {@code seconds} on the current channel; returns the report section (verdict at the top). */
    public static String run(Context c, RadioService svc, int seconds, FirstRunCheck.Progress p) throws InterruptedException {
        Facts f = new Facts();
        StringBuilder r = new StringBuilder();
        boolean root = RootSetup.haveRoot();
        p.step("Checking the phone's system and audio service…");

        StringBuilder sys = new StringBuilder("system:\n");
        sys.append("  model ").append(Build.MANUFACTURER).append(' ').append(Build.MODEL).append(" · Android ").append(Build.VERSION.RELEASE).append(" (SDK ").append(Build.VERSION.SDK_INT).append(")\n");
        sys.append("  build ").append(DeviceReport.getprop("ro.build.display.id")).append(" · ").append(Build.FINGERPRINT).append('\n');
        sys.append("  system image ").append(DeviceReport.getprop("ro.product.system.name")).append(" / ").append(DeviceReport.getprop("ro.system.build.fingerprint")).append('\n');
        sys.append("  vendor image ").append(DeviceReport.getprop("ro.vendor.build.fingerprint")).append('\n');
        sys.append("  security patch ").append(Build.VERSION.SECURITY_PATCH).append(" · build type ").append(Build.TYPE).append('/').append(Build.TAGS).append('\n');
        try { Class.forName("android.os.PrizeTinyService"); sys.append("  framework class android.os.PrizeTinyService: present\n"); }
        catch (Throwable t) { f.classMissing = true; sys.append("  framework class android.os.PrizeTinyService: MISSING (").append(t.getClass().getSimpleName()).append(")\n"); }
        if (root) {
            String services = RootSetup.run("service list 2>/dev/null | grep -i -E 'tiny|prize' ; true");
            f.binderPresent = services.toLowerCase(Locale.US).contains("tiny");
            sys.append("  binder services: ").append(services.trim().isEmpty() ? "(none matching tiny/prize)" : services.trim().replace("\n", "\n    ")).append('\n');
            String procs = RootSetup.run("ps -A -o PID,USER,NAME 2>/dev/null | grep -i tiny ; true");
            f.daemonRunning = procs.toLowerCase(Locale.US).contains("tiny");
            sys.append("  processes: ").append(procs.trim().isEmpty() ? "(no tiny* process)" : procs.trim().replace("\n", "\n    ")).append('\n');
            sys.append("  SELinux ").append(RootSetup.run("getenforce").trim()).append(" · su ").append(RootSetup.run("su -v 2>/dev/null; true").trim()).append('\n');
            sys.append("  vendor framework jars: ").append(RootSetup.run("ls /system/framework /system_ext/framework /product/framework 2>/dev/null | grep -i -E 'prize|tiny|mediatek-framework' | tr '\\n' ' '; true").trim()).append('\n');
        } else sys.append("  (no root: the binder service and process checks were skipped)\n");

        f.audioError = svc.audioError();
        StringBuilder au = new StringBuilder("SignalDeck:\n");
        au.append("  link ").append(svc.link()).append(" · profile ").append(svc.profile().name).append(svc.profile().verified ? "" : " (untested)").append('\n');
        au.append("  receive audio: backend ").append(svc.audioBackendName()).append(", start ").append(svc.audioStartResult() == null ? "(not started)" : svc.audioStartResult())
                .append(f.audioError == null ? "" : ", ERROR " + f.audioError).append('\n');
        f.muted = svc.isMuted(); f.mediaMode = svc.inMediaMode(); f.rxAudioOn = svc.rxAudioOn();
        au.append("  receive audio on ").append(f.rxAudioOn).append(", muted ").append(f.muted).append(", media mode ").append(f.mediaMode).append('\n');
        try {
            AudioManager am = (AudioManager) c.getSystemService(Context.AUDIO_SERVICE);
            f.musicVolume = am.getStreamVolume(AudioManager.STREAM_MUSIC); f.musicMax = am.getStreamMaxVolume(AudioManager.STREAM_MUSIC);
            StringBuilder outs = new StringBuilder();
            for (AudioDeviceInfo d : am.getDevices(AudioManager.GET_DEVICES_OUTPUTS)) {
                int t = d.getType(); String n = t == AudioDeviceInfo.TYPE_BUILTIN_SPEAKER ? "speaker" : t == AudioDeviceInfo.TYPE_WIRED_HEADPHONES || t == AudioDeviceInfo.TYPE_WIRED_HEADSET ? "wired headset"
                        : t == AudioDeviceInfo.TYPE_BLUETOOTH_A2DP || t == AudioDeviceInfo.TYPE_BLUETOOTH_SCO ? "Bluetooth" : t == AudioDeviceInfo.TYPE_USB_DEVICE || t == AudioDeviceInfo.TYPE_USB_HEADSET ? "USB audio" : null;
                if (n != null && outs.indexOf(n) < 0) { if (outs.length() > 0) outs.append(", "); outs.append(n); }
            }
            f.output = outs.toString();
            au.append("  media volume ").append(f.musicVolume).append('/').append(f.musicMax).append(" · outputs ").append(f.output.isEmpty() ? "?" : f.output).append(am.isBluetoothA2dpOn() ? " · Bluetooth media on" : "").append('\n');
        } catch (Throwable t) { au.append("  audio manager: ").append(t).append('\n'); }

        ChannelStore.Channel ch = svc.current();
        StringBuilder chs = new StringBuilder("channel:\n");
        java.util.Set<Integer> rxList = new java.util.HashSet<>();
        if (ch == null) chs.append("  (none selected)\n");
        else {
            f.digitalChannel = ch.isDigital();
            chs.append(String.format(Locale.US, "  %s · %s MHz rx / %s tx · %s\n", ch.name, ch.freqText(ch.rxFreq), ch.freqText(ch.txFreq), ch.isDigital() ? "DMR" : "analog FM"));
            if (ch.isDigital()) {
                StringBuilder g = new StringBuilder(); for (int x : ch.groups) { rxList.add(x); if (g.length() > 0) g.append(','); g.append(x); }
                if (ch.txContact > 0) rxList.add(ch.txContact);
                chs.append(String.format(Locale.US, "  colour code %d · timeslot in %d / out %d · call %s %d · RX group list [%s] · encryption %s\n",
                        ch.cc, ch.inSlot + 1, ch.outSlot + 1, ch.contactType == 0 ? "private" : ch.contactType == 1 ? "group" : "all", ch.txContact, g, ch.encryptSw == 1 ? "on" : "off"));
            }
        }

        // ---- the minute ----
        File clipFile = new File(c.getCacheDir(), "dmr_check.wav");
        ClipRecorder clip = null;
        try { clip = new ClipRecorder(clipFile, seconds * 1000); svc.recordClip(clip, true); } catch (Throwable ignored) { }   // only while something is received: just for the level, deleted after
        long t0 = System.currentTimeMillis(), pcm0 = svc.rxAudioBytes();
        StringBuilder rs = new StringBuilder(); int heard = 0;
        while (System.currentTimeMillis() - t0 < seconds * 1000L) {
            svc.pollRssi(); Thread.sleep(1000);
            int s = (int) ((System.currentTimeMillis() - t0) / 1000); if (svc.rxActive()) heard++;
            rs.append(svc.lastRssi()).append(svc.rxActive() ? "*" : "").append(' ');
            p.step(String.format(Locale.US, "Listening on %s: %d of %d s · receiving %d s.\nAsk someone to talk on the talkgroup now.", ch == null ? "the channel" : ch.name, Math.min(s, seconds), seconds, heard));
        }
        f.pcmTotal = svc.rxAudioBytes() - pcm0;
        String clipStats = "";
        if (clip != null) { svc.recordClip(null, false); clip.finish(); clipStats = clip.stats(); f.rms = clip.rms(); }
        clipFile.delete();                                                    // never kept: other people's voices

        StringBuilder ev = new StringBuilder("events (time, reception start/stop, caller reports; audio bytes so far):\n");
        long startPcm = -1;
        for (RadioService.DmrEvent e : svc.dmrEventsSince(t0)) {
            String t = String.format(Locale.US, "  +%5.1f s ", (e.ts - t0) / 1000.0);
            if ("start".equals(e.kind)) { f.receptions++; startPcm = e.pcmBytes; ev.append(t).append("reception start").append('\n'); }
            else if ("stop".equals(e.kind)) { if (startPcm >= 0) f.pcmDuringCalls += Math.max(0, e.pcmBytes - startPcm); startPcm = -1; ev.append(t).append("reception stop · ").append(e.pcmBytes - pcm0).append(" audio bytes so far\n"); }
            else {
                f.callerReports++;
                boolean inList = e.type != 1 || rxList.contains(e.target);
                if (!inList) f.callsOutsideList++;
                ev.append(t).append(e.type == 1 ? "group call to TG " + e.target : e.type == 2 ? "all call" : "private call").append(" from ").append(maskId(e.caller))
                        .append(e.type == 1 && !inList ? " (TG not in the RX list)" : "").append('\n');
            }
        }
        if (startPcm >= 0) f.pcmDuringCalls += Math.max(0, svc.rxAudioBytes() - startPcm);   // still receiving at the end
        f.receivedAnything = f.receptions > 0;
        if (f.receptions == 0 && f.callerReports == 0) ev.append("  (none)\n");

        StringBuilder out = new StringBuilder();
        out.append("verdict:\n"); for (String line : verdict(f)) out.append("  ").append(line).append('\n');
        out.append('\n').append(sys).append('\n').append(au).append('\n').append(chs).append('\n');
        out.append(String.format(Locale.US, "minute: receiving %d of %d s · %d reception(s) · %d caller report(s) · audio %d bytes in total, %d during receptions%s\n",
                heard, seconds, f.receptions, f.callerReports, f.pcmTotal, f.pcmDuringCalls, clipStats.isEmpty() ? "" : " · level of what arrived while receiving: " + clipStats));
        out.append("signal each second (* = receiving): ").append(rs.toString().trim()).append('\n');
        out.append(ev).append('\n');
        List<String> logLines = new ArrayList<>(); for (String l : svc.recentLog()) if (!l.contains("cmd=0x32")) logLines.add(l);
        out.append("SignalDeck log (redacted, signal polls left out):\n").append(DeviceReport.redactAppLog(logLines.subList(Math.max(0, logLines.size() - 120), logLines.size()))).append('\n');
        if (root) out.append("system log during the check (root, masked):\n").append(DeviceReport.redact(RootSetup.run(String.format(Locale.US,
                "logcat -d -T %d.000 2>/dev/null | grep -i -E 'tiny|prize|interphone|AudioTrack|AudioFlinger.*(8000|underrun)|avc.*(tiny|macdmr)' | grep -v -i 'APRS-Decoder' | tail -80", t0 / 1000)))).append('\n');
        return out.toString();
    }
}
