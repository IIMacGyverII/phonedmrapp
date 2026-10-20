package com.macdmr.radio.ham;

import static org.junit.Assert.*;

import org.junit.Test;

import java.util.Arrays;

public class NetReportTest {
    @Test public void reportListsCheckInsWithFlags() {
        NetStore.Net n = new NetStore.Net(); n.name = "Weekly net"; n.channel = "K0ABC Repeater"; n.freqHz = 146_940_000; n.start = 1_000_000; n.end = n.start + 42 * 60_000L;
        NetStore.CheckIn a = new NetStore.CheckIn(); a.ts = n.start + 60_000; a.call = "W1AW"; a.name = "Hiram"; a.traffic = true;
        NetStore.CheckIn b = new NetStore.CheckIn(); b.ts = n.start + 20 * 60_000L; b.call = "K0XYZ"; b.late = true; b.out = true; b.notes = "mobile";
        String r = NetStore.report(n, Arrays.asList(a, b), "N0NC");
        assertTrue(r.startsWith("Weekly net"));
        assertTrue(r.contains("(146.9400 MHz)"));
        assertTrue(r.contains(", 42 min"));
        assertTrue(r.contains("Net control: N0NC"));
        assertTrue(r.contains("Check-ins: 2, 1 with traffic"));
        assertTrue(r.contains(" 1. W1AW") && r.contains("Hiram  [traffic]"));
        assertTrue(r.contains(" 2. K0XYZ") && r.contains("[late, checked out]  mobile"));
    }
}
