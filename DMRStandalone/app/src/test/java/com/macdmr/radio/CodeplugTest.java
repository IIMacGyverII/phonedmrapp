package com.macdmr.radio;

import static org.junit.Assert.*;

import com.macdmr.radio.dsp.ToneTable;

import org.junit.Test;

import java.util.Arrays;
import java.util.List;

public class CodeplugTest {
    private static ChannelStore.Channel analog(String name, int rx, int tx, int txType, int txSub, int rxType, int rxSub) {
        ChannelStore.Channel c = new ChannelStore.Channel(); c.type = 1; c.name = name; c.rxFreq = rx; c.txFreq = tx; c.power = 1; c.band = 1;
        c.txType = txType; c.txSubCode = txSub; c.rxType = rxType; c.rxSubCode = rxSub; return c;
    }
    private static int ctcss(double hz) { for (int i = 0; i < ToneTable.CTCSS.length; i++) if (Math.abs(ToneTable.CTCSS[i] - hz) < 0.05) return i; return -1; }

    private static Codeplug sample() {
        Codeplug p = new Codeplug(); p.name = "Club | plug";
        ChannelStore.Channel rpt = analog("Club Rptr, main", 146_940_000, 146_340_000, 1, ctcss(100.0), 0, 0);
        rpt.lat = 30.12345; rpt.lon = -97.54321; rpt.location = "Water tower";
        ChannelStore.Channel tsql = analog("TSQL", 444_100_000, 449_100_000, 1, ctcss(123.0), 1, ctcss(123.0));
        ChannelStore.Channel dcs = analog("DCS inv", 462_550_000, 467_550_000, 3, ToneTable.dcsIndex("023"), 3, ToneTable.dcsIndex("023"));
        ChannelStore.Channel wx = analog("NOAA", 162_550_000, 0, 0, 0, 0, 0); wx.band = 0;
        ChannelStore.Channel dmr = new ChannelStore.Channel(); dmr.type = 0; dmr.name = "BM TX"; dmr.rxFreq = 442_000_000; dmr.txFreq = 447_000_000; dmr.cc = 1; dmr.inSlot = 1; dmr.outSlot = 1;
        dmr.contactType = 1; dmr.txContact = 3148; dmr.groups = new int[] { 3148, 91 }; dmr.encryptSw = 1; dmr.encryptKey = "SECRET";
        p.channels.addAll(Arrays.asList(rpt, tsql, dcs, wx, dmr));
        return p;
    }

    @Test public void dcsIsAnIndexIntoTheOemTable() {
        assertEquals(83, ToneTable.DCS_COUNT);
        assertEquals("023", ToneTable.dcsCode(0)); assertEquals("754", ToneTable.dcsCode(82));
        assertEquals(0, ToneTable.dcsIndex("D023N")); assertEquals(82, ToneTable.dcsIndex("754")); assertEquals(-1, ToneTable.dcsIndex("024"));
        assertEquals("D025N", ToneTable.toneLabel(2, 1)); assertEquals("D025I", ToneTable.toneLabel(3, 1));
    }

    @Test public void codeRoundTripsAndNeverCarriesTheKey() {
        Codeplug p = sample();
        String text = Codeplug.shareText(p, true);
        assertFalse(text.contains("SECRET"));
        String wrapped = text.replaceAll("(SDCP1:.{30})", "$1\n ");                // an app wrapped the long line
        Codeplug b = Codeplug.read("Look at this:\n" + wrapped + "\n73!", null);
        assertNotNull(b);
        assertEquals("Club | plug", b.name); assertEquals(5, b.channels.size());
        ChannelStore.Channel r = b.channels.get(0);
        assertEquals("Club Rptr, main", r.name); assertEquals(146_340_000, r.txFreq); assertEquals(ctcss(100.0), r.txSubCode); assertEquals(30.12345, r.lat, 1e-6); assertEquals("Water tower", r.location);
        ChannelStore.Channel d = b.channels.get(4);
        assertEquals(3148, d.txContact); assertArrayEquals(new int[] { 3148, 91 }, d.groups); assertEquals(1, d.inSlot);
        assertEquals(2, d.encryptSw); assertEquals("", d.encryptKey);
        assertEquals(3, b.channels.get(2).txType);
        Codeplug noLoc = Codeplug.fromCode(Codeplug.code(p, false));
        assertEquals(0, noLoc.channels.get(0).lat, 0);
        assertNull(Codeplug.read("SDCP1:@@@@:END", null));
        assertNull(Codeplug.read("nothing here", null));
    }

    @Test public void readableTextSaysWhatToProgram() {
        String t = Codeplug.shareText(sample(), true);
        assertTrue(t, t.contains("146.9400 MHz, −0.6000 MHz offset (TX 146.3400), FM, tone 100.0"));
        assertTrue(t, t.contains("NOAA  162.5500 MHz, receive only"));
        assertTrue(t, t.contains("DMR CC1 TS2, TG 3148"));
        assertTrue(t, t.contains("tone D023I"));
    }

    @Test public void chirpRoundTrip() {
        String csv = Codeplug.chirpCsv(sample());
        String[] rows = csv.split("\r\n");
        assertEquals(Codeplug.CHIRP_HEADER, rows[0]);
        assertEquals(5, rows.length);                                          // header + 4 analog channels (DMR left out)
        assertTrue(rows[1], rows[1].startsWith("1,\"Club Rptr, main\",146.940000,-,0.600000,Tone,100.0,"));
        assertTrue(rows[2], rows[2].contains(",TSQL,123.0,123.0,"));
        assertTrue(rows[3], rows[3].contains(",DTCS,") && rows[3].contains(",023,RR,023,"));
        assertTrue(rows[4], rows[4].contains(",off,0.000000,") && rows[4].contains(",NFM,"));
        Codeplug back = Codeplug.read(csv, "club.csv");
        assertEquals("CHIRP", back.format); assertEquals("club", back.name); assertEquals(4, back.channels.size());
        ChannelStore.Channel r = back.channels.get(0);
        assertEquals(146_340_000, r.txFreq); assertEquals(1, r.txType); assertEquals(ctcss(100.0), r.txSubCode); assertEquals(0, r.rxType);
        assertEquals(1, back.channels.get(1).rxType); assertEquals(ctcss(123.0), back.channels.get(1).rxSubCode);
        assertEquals(3, back.channels.get(2).txType); assertEquals(0, back.channels.get(2).txSubCode);
        assertEquals(0, back.channels.get(3).txFreq); assertEquals(0, back.channels.get(3).band);
    }

    @Test public void chirpFromOtherRadiosSkipsWhatThisRadioCannotDo() {
        String csv = Codeplug.CHIRP_HEADER + "\n"
                + "0,HF,14.230000,,0.000000,,88.5,88.5,023,NN,023,Tone->Tone,USB,5.00,,,,,,,\n"
                + "1,220,223.500000,-,1.600000,Tone,100.0,88.5,023,NN,023,Tone->Tone,FM,5.00,,,,,,,\n"
                + "2,Split,145.500000,split,433.500000,Cross,88.5,100.0,023,NN,023,Tone->Tone,FM,5.00,,Low,,,,,\n"
                + "3,AM,124.000000,,0.000000,,88.5,88.5,023,NN,023,Tone->Tone,AM,5.00,,,,,,,\n";
        Codeplug p = Codeplug.read(csv, null);
        assertEquals(1, p.channels.size()); assertEquals(3, p.skipped.size());
        ChannelStore.Channel s = p.channels.get(0);
        assertEquals(433_500_000, s.txFreq); assertEquals(0, s.power); assertEquals(1, s.txType); assertEquals(1, s.rxType); assertEquals(ctcss(100.0), s.rxSubCode);
    }

    @Test public void findsDuplicates() {
        List<ChannelStore.Channel> mine = sample().channels;
        assertTrue(Codeplug.duplicate(analog("club rptr, MAIN", 146_940_000, 146_340_000, 0, 0, 0, 0), mine));
        assertFalse(Codeplug.duplicate(analog("Other", 146_940_000, 146_340_000, 0, 0, 0, 0), mine));
    }
}
