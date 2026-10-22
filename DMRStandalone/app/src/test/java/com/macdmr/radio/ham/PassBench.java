/*
 * SignalDeck - Copyright (C) 2026 IIMacGyverII
 * SPDX-License-Identifier: GPL-3.0-or-later
 * Free software under the GNU General Public License v3 or later, with the additional terms in COPYRIGHT
 * (keep this notice and the author credit, mark modified versions, no rights to the SignalDeck name or icon).
 */
package com.macdmr.radio.ham;

import org.junit.Test;

/**
 * Bench: passes for the TLE file named by SAT_TLE from SAT_FROM (ms) over 24 h at Minneapolis, written to SAT_TLE.out
 * as "aos los maxEl t rangeRate az el" (t = a minute after the rise), for comparison with Skyfield.
 */
public class PassBench {
    @Test public void passes() throws Exception {
        String f = System.getenv("SAT_TLE"); if (f == null) return;
        String[] l = new String(java.nio.file.Files.readAllBytes(java.nio.file.Paths.get(f))).trim().split("\\r?\\n");
        Sgp4 s = new Sgp4(l[0], l[1], l[2]);
        StringBuilder sb = new StringBuilder();
        for (SatTrack.Pass p : SatTrack.passes(s, Long.parseLong(System.getenv("SAT_FROM")), 24, 44.98, -93.27, 260, 0)) {
            long t = p.aos + 60_000; SatTrack.Look k = SatTrack.look(s, t, 44.98, -93.27, 260);
            sb.append(String.format(java.util.Locale.US, "%d %d %.2f %d %.4f %.3f %.3f%n", p.aos, p.los, p.maxEl, t, k.rangeRateKmS, k.az, k.el));
        }
        java.nio.file.Files.write(java.nio.file.Paths.get(f + ".out"), sb.toString().getBytes());
    }
}
