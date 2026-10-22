/*
 * SignalDeck - Copyright (C) 2026 IIMacGyverII
 * SPDX-License-Identifier: GPL-3.0-or-later
 * Free software under the GNU General Public License v3 or later, with the additional terms in COPYRIGHT
 * (keep this notice and the author credit, mark modified versions, no rights to the SignalDeck name or icon).
 */
package com.macdmr.radio.ham;

import static org.junit.Assert.*;

import org.junit.Test;

import java.util.ArrayList;
import java.util.Calendar;
import java.util.List;

public class ActivityStatsTest {
    private static long at(int hour) { Calendar c = Calendar.getInstance(); c.set(2026, Calendar.OCTOBER, 20, hour, 15, 0); return c.getTimeInMillis(); }

    @Test public void countsPerChannelAndHour() {
        List<Object[]> rows = new ArrayList<>();
        rows.add(new Object[] { at(7), 54, "rx", "📻 Received 12 s" });
        rows.add(new Object[] { at(7), 54, "rx", "📻 Received 30 s" });
        rows.add(new Object[] { at(18), 2, "rx", "📻 Received 4 s" });
        rows.add(new Object[] { at(18), 54, "dmr", "📻 Voice RX TG 9 from K0ABC" });
        rows.add(new Object[] { at(9), 2, "pkt", "📡 not a reception" });
        ActivityStats s = ActivityStats.of(rows);
        assertEquals(4, s.receptions); assertEquals(46, s.seconds);
        assertEquals(54, s.channels.get(0).number); assertEquals(3, s.channels.get(0).receptions); assertEquals(42, s.channels.get(0).seconds);
        assertEquals(2, s.byHour[7]); assertEquals(2, s.byHour[18]); assertEquals(0, s.byHour[9]);
        assertEquals(7, s.peakHour());
        assertEquals(0, ActivityStats.seconds("📻 Voice TX"));
    }
}
