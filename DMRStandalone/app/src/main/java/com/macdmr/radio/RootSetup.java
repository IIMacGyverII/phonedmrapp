package com.macdmr.radio;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.OutputStream;

/**
 * One-time (per boot) privileged setup through Magisk su. Everything here is reversible and is exactly
 * what a Magisk module's sepolicy.rule would do at boot:
 *  - SELinux rules so this ordinary app may open the UART and the module's sysfs lines
 *  - tty line settings (raw, baud) in case the stock app never set them
 *  - disable / re-enable the stock walkie-talkie app, which otherwise keeps the UART and re-programs the MCU
 */
public final class RootSetup {
    public static String run(String cmd) {
        StringBuilder sb = new StringBuilder();
        try {
            Process p = new ProcessBuilder("su", "-c", cmd).redirectErrorStream(true).start();
            BufferedReader r = new BufferedReader(new InputStreamReader(p.getInputStream()));
            String line; while ((line = r.readLine()) != null) sb.append(line).append('\n');
            int rc = p.waitFor();
            if (rc != 0) sb.append("(rc=").append(rc).append(")");
        } catch (Exception e) { sb.append("su failed: ").append(e.getMessage()); }
        return sb.toString().trim();
    }

    public static boolean haveRoot() { return run("id").contains("uid=0"); }

    /** Apply the profile's policy lines to the live policy (lost at reboot; call on every start). */
    public static String applySepolicy(File filesDir, DeviceProfile p) throws IOException {
        File f = new File(filesDir, "sepolicy.rule");
        try (OutputStream o = new FileOutputStream(f)) {
            for (String l : p.sepolicy) o.write((l + "\n").getBytes());
        }
        run("chmod 644 " + f.getAbsolutePath());
        return run("magiskpolicy --live --apply " + f.getAbsolutePath());
    }

    public static String ensureTty(DeviceProfile p) {
        String s = run("stty -F " + p.controlPort + " " + p.baud + " raw -echo -echoe -echok -echoctl -echoke");
        if (p.pcmPort != null) s += "\n" + run("stty -F " + p.pcmPort + " " + p.pcmBaud + " raw -echo");
        return s;
    }

    public static String stockApp(DeviceProfile p, boolean enable) {
        return run(enable ? "pm enable " + p.stockApp : "pm disable-user --user 0 " + p.stockApp);
    }

    public static boolean stockAppEnabled(DeviceProfile p) {
        String s = run("pm list packages -e " + p.stockApp);
        return s.contains(p.stockApp);
    }
}
