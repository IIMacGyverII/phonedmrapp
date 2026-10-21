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
            sum.append(t.substring(0, t.indexOf('\n') > 0 ? t.indexOf('\n') : t.length())).append('\n');
        } else if (trial) sum.append("trial take-over skipped: ").append(!dp.supported ? "no profile for this phone yet" : "SignalDeck already owns the radio").append('\n');

        DeviceReport.append("SignalDeck log (personal details removed)", DeviceReport.redactAppLog(svc.recentLog()));
        DeviceReport.append("Summary", sum.toString());
        p.step("Zipping");
        return DeviceReport.zipNewest(c, true);
    }

    /** Take the radio for a few seconds (receive only), record what happened, give it back. */
    private static String trialTakeOver(Context c, RadioService svc, Progress p) throws InterruptedException {
        StringBuilder r = new StringBuilder();
        p.step("Trial: taking over the radio (receive only)");
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
        r.append(String.format(Locale.US, "(trial ran %d s)\n", (System.currentTimeMillis() - t0) / 1000));
        return r.toString();
    }
}
