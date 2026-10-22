/*
 * SignalDeck - Copyright (C) 2026 IIMacGyverII
 * SPDX-License-Identifier: GPL-3.0-or-later
 * Free software under the GNU General Public License v3 or later, with the additional terms in COPYRIGHT
 * (keep this notice and the author credit, mark modified versions, no rights to the SignalDeck name or icon).
 */
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
        } catch (IOException e) {
            if (!RootSetup.haveRoot()) return "ERR " + e.getMessage();
            return RootSetup.run("cat " + node).trim();          // node with a label the app may not open (Xplore 1: plain sysfs)
        }
    }

    public boolean isOn() { return read().equals(onToken); }

    public void set(boolean on) throws IOException { write(node, on ? "1" : "0"); }

    /** Write a value to a sysfs line, through root when the app may not open it. */
    public static void write(String node, String value) throws IOException {
        try (FileOutputStream f = new FileOutputStream(node)) { f.write(value.getBytes()); }
        catch (IOException e) {
            if (!RootSetup.haveRoot()) throw e;
            String r = RootSetup.run("echo " + value + " > " + node + " && echo ok");
            if (!r.endsWith("ok")) throw new IOException(node + ": " + e.getMessage() + " / root: " + r);
        }
    }

    public String node() { return node; }
}
