package com.macdmr.radio;

import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;

/** Module power / PTT lines exposed by the kernel driver as sysfs attribute files. */
public final class SysfsGpio {
    private final String node;      // e.g. /sys/devices/platform/dmr009/pwd
    private final String onToken;   // what a read looks like when on, e.g. "pwd :1" (Armor) or "1" (Xplore, assumed)

    public SysfsGpio(String node, String onToken) { this.node = node; this.onToken = onToken; }

    public String read() {
        try (FileInputStream f = new FileInputStream(node)) {
            byte[] b = new byte[64]; int n = f.read(b);
            return n > 0 ? new String(b, 0, n).trim() : "";
        } catch (IOException e) { return "ERR " + e.getMessage(); }
    }

    public boolean isOn() { return read().equals(onToken); }

    public void set(boolean on) throws IOException {
        try (FileOutputStream f = new FileOutputStream(node)) { f.write((on ? "1" : "0").getBytes()); }
    }

    public String node() { return node; }
}
