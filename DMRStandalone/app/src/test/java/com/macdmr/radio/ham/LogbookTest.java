package com.macdmr.radio.ham;

import static org.junit.Assert.*;

import org.junit.Test;

import java.util.Arrays;
import java.util.Calendar;
import java.util.TimeZone;

public class LogbookTest {
    @Test public void callsigns() {
        for (String c : new String[] { "W1AW", "K0MSP", "KD0XYZ", "VE3ABC", "2E0XYZ", "N0CALL", "G4A" }) assertTrue(c, Logbook.looksLikeCall(c));
        for (String c : new String[] { "APZDMR", "WIDE1", "TEST", "12345", "K0", "ABCDEFGH", "0ABC" }) assertFalse(c, Logbook.looksLikeCall(c));
        assertEquals("W1AW", Logbook.baseCall("w1aw-9"));
        assertEquals("K0MSP", Logbook.baseCall("K0MSP/R"));
        assertNull(Logbook.baseCall("WIDE2-1"));
    }

    @Test public void adifExport() {
        Logbook.Entry q = new Logbook.Entry();
        Calendar c = Calendar.getInstance(TimeZone.getTimeZone("UTC")); c.clear(); c.set(2026, Calendar.OCTOBER, 20, 14, 5, 9);
        q.ts = c.getTimeInMillis(); q.call = "W1AW"; q.freqHz = 146_520_000; q.mode = "FM"; q.rstSent = "59"; q.rstRcvd = "57"; q.name = "Hiram"; q.qso = true;
        Logbook.Entry h = new Logbook.Entry(); h.ts = q.ts; h.call = "K0ABC"; h.freqHz = 441_000_000; h.mode = "DMR"; h.source = "TG 99";
        String a = Logbook.adif(Arrays.asList(q, h), "1.0");
        assertTrue(a.contains("<ADIF_VER:5>3.1.4 "));
        assertTrue(a.contains("<EOH>"));
        assertTrue(a.contains("<CALL:4>W1AW <QSO_DATE:8>20261020 <TIME_ON:6>140509 <FREQ:10>146.520000 <BAND:2>2m <MODE:2>FM <RST_SENT:2>59 <RST_RCVD:2>57 <NAME:5>Hiram <EOR>"));
        assertTrue(a.contains("<CALL:5>K0ABC") && a.contains("<BAND:4>70cm <MODE:12>DIGITALVOICE <SUBMODE:3>DMR <COMMENT:5>TG 99 <SWL:1>Y <EOR>"));
        assertNull(Logbook.band(467_625_000));
    }
}
