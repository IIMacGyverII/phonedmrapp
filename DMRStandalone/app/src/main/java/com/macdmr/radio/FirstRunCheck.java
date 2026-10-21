package com.macdmr.radio;

import android.content.Context;

import java.io.File;
import java.util.Locale;

/**
 * Everything a first run on a new or untested phone should find out, in one go, so the owner presses one button and
 * sends one zip: the device report, the PTT key capture, the radio probe (repeated with the module's power switched on
 * when it got no answer and the profile knows the power line), optionally a short trial take-over (receive only:
 * module answer, RSSI, a few seconds of the raw audio stream, then the radio is handed back to the stock app) and
 * SignalDeck's own log with personal details removed.
 */
public final class FirstRunCheck {
    public interface Progress { void step(String s); }
    private FirstRunCheck() { }

    /** Runs on a worker thread; returns the zip to share. */
    public static File run(Context c, RadioService svc, boolean trial, Progress p) throws Exception {
        DeviceProfile dp = svc.profile();
        StringBuilder sum = new StringBuilder();
        if (dp.supported && !dp.stockApp.isEmpty() && !svc.isReady() && RootSetup.haveRoot()
                && !RootSetup.run("pidof " + dp.stockApp).replaceAll("[^0-9]", "").isEmpty()) {
            p.step("Closing " + dp.stockApp + " so the ports are free");
            RootSetup.run("am force-stop " + dp.stockApp);
            Thread.sleep(1500);
            sum.append("closed the stock app (").append(dp.stockApp).append(") for the checks\n");
        }

        DeviceReport.generate(c, s -> p.step("Report: " + s));

        p.step("Press and release the side PTT key a few times now (10 s)");
        DeviceReport.append("PTT key capture", DeviceReport.captureKeys(c, 10));

        String watchPkg = !dp.stockApp.isEmpty() ? dp.stockApp : DeviceReport.lastCandidates.isEmpty() ? null : DeviceReport.lastCandidates.get(0);
        if (watchPkg != null && !svc.isReady() && RootSetup.haveRoot()) {
            String w = watchStockApp(watchPkg, p);
            DeviceReport.append("The stock app at work (" + watchPkg + ", 15 s, receive only)", w);
            sum.append("watched ").append(watchPkg).append(" start up for 15 s\n");
        } else sum.append("stock app not watched: ").append(watchPkg == null ? "no stock walkie-talkie app found" : svc.isReady() ? "SignalDeck owns the radio" : "no root").append('\n');

        if (svc.isReady()) {
            sum.append("radio probe skipped: SignalDeck owns the radio (Hand back first to probe the ports)\n");
        } else {
            String r = RadioProbe.run(c, s -> p.step("Probe: " + s), false);
            DeviceReport.append("Radio probe", r);
            boolean answered = r.contains("answered");
            if (!answered && dp.supported && dp.powerNode != null) {             // the stock app switches the module off when it closes
                String r2 = RadioProbe.run(c, s -> p.step("Probe with power on: " + s), true);
                DeviceReport.append("Radio probe (module power switched on first)", r2);
                answered = r2.contains("answered");
            }
            sum.append("radio module answered the version query: ").append(answered ? "yes" : "no").append('\n');
        }

        if (trial && dp.supported && !svc.isReady()) {
            String t = trialTakeOver(c, svc, p);
            DeviceReport.append("Trial take-over", t);
            sum.append("trial: ").append(t.replace("\n", "\n  ").trim()).append('\n');
        } else if (trial) sum.append("trial take-over skipped: ").append(!dp.supported ? "no profile for this phone yet" : "SignalDeck already owns the radio").append('\n');

        DeviceReport.append("SignalDeck log (personal details removed)", DeviceReport.redactAppLog(svc.recentLog()));
        DeviceReport.append("Summary", sum.toString());
        p.step("Zipping");
        return DeviceReport.zipNewest(c, true);
    }

    private static final String KMSG = "dmesg 2>/dev/null | grep -i -E 'intercom|dmr|interphone|walkie|ptt|pwd|pdt|ttyS|ttyMT' | tail -40";

    /**
     * Start the stock walkie-talkie app the way its icon does, let it power up and listen for 15 s, and record what it does:
     * its own log lines (QuickChat logs every step: "setPttReceive", "initPcmSerialPort", its PCM packets), which serial
     * ports it opens and the line settings it gives them, and the radio driver's kernel messages. Then close it. Nobody
     * presses PTT meanwhile (the progress text says so): this only listens.
     */
    static String watchStockApp(String pkg, Progress p) throws InterruptedException {
        StringBuilder r = new StringBuilder();
        String comp = RootSetup.run("cmd package resolve-activity --brief -a android.intent.action.MAIN -c android.intent.category.LAUNCHER " + pkg + " | tail -1").trim();
        if (!comp.contains("/")) return "no launcher activity found for " + pkg + " (" + comp + ")\n";
        String kBefore = RootSetup.run(KMSG);
        RootSetup.run("logcat -c");
        p.step("The stock walkie-talkie app is open for 15 s — please do not press PTT");
        r.append("start ").append(comp).append(": ").append(RootSetup.run("am start -n " + comp + " 2>&1 | tail -1")).append('\n');
        Thread.sleep(8000);
        String pid = RootSetup.run("pidof " + pkg).trim().split("\\s+")[0];
        if (pid.matches("\\d+")) {
            String fds = RootSetup.run("ls -l /proc/" + pid + "/fd 2>/dev/null | grep -o '/dev/[A-Za-z0-9_]*' | sort -u");
            r.append("devices it holds open: ").append(fds.replace('\n', ' ')).append('\n');
            for (String dev : fds.split("\\s+")) if (dev.matches("/dev/tty\\w+"))
                r.append("  ").append(dev).append(": ").append(RootSetup.run("stty -F " + dev + " -a 2>&1 | head -2").replace('\n', ' ')).append('\n');
        } else r.append("not running after 8 s (pid: ").append(pid).append(")\n");
        Thread.sleep(7000);
        String log = pid.matches("\\d+") ? RootSetup.run("logcat -d --pid=" + pid + " 2>/dev/null | tail -600") : RootSetup.run("logcat -d 2>/dev/null | tail -400");
        int hexLines = 0; StringBuilder kept = new StringBuilder();
        for (String l : log.split("\n")) {
            if (l.contains("ClassLoader referenced unknown path")) continue;   // framework noise
            if (l.matches(".*[0-9A-Fa-f ,]{120,}.*")) { hexLines++; if (hexLines <= 3) kept.append(l, 0, Math.min(l.length(), 260)).append(" …\n"); continue; }   // data dumps: a sample is enough
            kept.append(l.length() > 260 ? l.substring(0, 260) + " …" : l).append('\n');
        }
        r.append("\nits log (").append(hexLines).append(" data-dump lines shortened to 3 samples; personal details removed):\n").append(DeviceReport.redact(kept.toString()));
        String kAfter = RootSetup.run(KMSG);
        r.append("\nradio driver kernel messages that appeared meanwhile:\n").append(newLines(kBefore, kAfter));
        r.append("\nclosed: ").append(RootSetup.run("am force-stop " + pkg + " && echo ok")).append('\n');
        Thread.sleep(1500);
        return r.toString();
    }

    /** Lines of {@code after} that were not in {@code before}. */
    private static String newLines(String before, String after) {
        java.util.HashSet<String> seen = new java.util.HashSet<>(java.util.Arrays.asList(before.split("\n")));
        StringBuilder out = new StringBuilder();
        for (String l : after.split("\n")) if (!l.trim().isEmpty() && !seen.contains(l)) out.append("  ").append(l).append('\n');
        return out.length() == 0 ? "  (none)\n" : out.toString();
    }

    /** Take the radio for a few seconds (receive only), record what happened, give it back. */
    private static String trialTakeOver(Context c, RadioService svc, Progress p) throws InterruptedException {
        StringBuilder r = new StringBuilder();
        p.step("Trial: taking over the radio (receive only)");
        String kBefore = RootSetup.run(KMSG);
        long t0 = System.currentTimeMillis();
        svc.bringUp();
        String link = svc.link();
        while (System.currentTimeMillis() - t0 < 45000) {
            Thread.sleep(500);
            link = svc.link();
            if ("ready".equals(link) || link.startsWith("error") || "no root".equals(link) || "unsupported".equals(link)) break;
            p.step("Trial: " + link);
        }
        long took = System.currentTimeMillis() - t0;
        r.append("result: ").append("ready".equals(link) ? "radio came up in " + took / 1000 + " s" : "did not come up (" + link + " after " + took / 1000 + " s)").append('\n');
        if ("ready".equals(link)) {
            if (!svc.profile().verified) {                              // untested phone: give the audio path something to carry
                p.step("Trial: listening on 446.00625 MHz with the squelch open");
                svc.listenTest(446_006_250, "Listen test 446.00625");
                Thread.sleep(4000);                                     // the module settles after a retune
                r.append("tuned 446.00625 MHz analog, squelch open (receive only)\n");
            }
            p.step("Trial: reading signal strength and audio");
            File dir = DeviceReport.newestDir();
            File raw = dir != null ? new File(dir, "rx_audio_raw.bin") : null;
            String cap = raw != null ? svc.captureRxAudio(raw, 5000) : "no report folder";
            StringBuilder rs = new StringBuilder();
            for (int i = 0; i < 5; i++) { svc.pollRssi(); Thread.sleep(1200); rs.append(svc.lastRssi()).append(' '); }
            Thread.sleep(1000);
            r.append("RSSI readings (dBm, -999 = no answer): ").append(rs.toString().trim()).append('\n');
            r.append("receive audio: ").append(cap).append('\n');
            r.append("received audio bytes so far: ").append(svc.rxAudioBytes()).append('\n');
        }
        p.step("Trial: handing the radio back");
        svc.shutDown(true);
        Thread.sleep(3000);
        r.append("handed back; stock app enabled: ").append(RootSetup.stockAppEnabled(svc.profile())).append('\n');
        r.append("radio driver kernel messages during the trial:\n").append(newLines(kBefore, RootSetup.run(KMSG)));
        r.append(String.format(Locale.US, "(trial ran %d s)\n", (System.currentTimeMillis() - t0) / 1000));
        return r.toString();
    }
}
