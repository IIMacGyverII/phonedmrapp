package com.dmrmod.hooks;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertFalse;
import static org.junit.Assert.assertNotNull;
import static org.junit.Assert.assertNull;
import static org.junit.Assert.assertTrue;

import com.dmrmod.hooks.RepeaterModels.Repeater;
import com.dmrmod.hooks.RepeaterModels.Talkgroup;

import org.junit.Test;

import java.io.ByteArrayOutputStream;
import java.io.InputStream;
import java.util.ArrayList;
import java.util.List;

/** Host tests for the hearham + RadioID parsers and the catalog merge (Phase 2 P2.1–P2.3). */
public class SourcesAndMergeTest {

    private static String res(String name) throws Exception {
        try (InputStream in = SourcesAndMergeTest.class.getResourceAsStream("/repeaters/" + name)) {
            assertNotNull(name + " missing", in);
            ByteArrayOutputStream out = new ByteArrayOutputStream();
            byte[] buf = new byte[4096]; int n;
            while ((n = in.read(buf)) != -1) out.write(buf, 0, n);
            return new String(out.toByteArray(), "UTF-8");
        }
    }

    private static Repeater byCall(List<Repeater> l, String c) {
        for (Repeater r : l) if (c.equals(r.callsign)) return r;
        return null;
    }

    // ---------------- hearham

    @Test public void hearhamFmRxTxTones() throws Exception {
        List<Repeater> l = HearhamSource.parse(res("hearham_sample.json"), 0L);
        Repeater fm = byCall(l, "KA0KMJ");
        assertNotNull(fm);
        assertTrue(fm.fm);
        assertFalse(fm.dmr);
        assertEquals(146940000L, fm.rxHz);
        assertEquals(146340000L, fm.txHz);      // frequency + offset(-600000)
        assertEquals("123.0", fm.toneUp);
        assertEquals("123.0", fm.toneDown);
        assertTrue(fm.hasCoords);
        assertEquals(RepeaterModels.SRC_HEARHAM, fm.sources);
    }

    @Test public void hearhamDmrGetsCcNotTones() throws Exception {
        Repeater dmr = byCall(HearhamSource.parse(res("hearham_sample.json"), 0L), "W9ABC");
        assertNotNull(dmr);
        assertTrue(dmr.dmr);
        assertFalse(dmr.fm);
        assertEquals(1, dmr.cc);               // "CC1"
        assertNull(dmr.toneUp);
    }

    @Test public void hearhamNotOperationalFlagged() throws Exception {
        Repeater stale = byCall(HearhamSource.parse(res("hearham_sample.json"), 0L), "KSTALE");
        assertNotNull(stale.status);
    }

    @Test public void hearhamCcParse() {
        assertEquals(4, HearhamSource.parseCc("CC4"));
        assertEquals(1, HearhamSource.parseCc("cc1"));
        assertEquals(7, HearhamSource.parseCc("7"));
        assertEquals(-1, HearhamSource.parseCc(null));
        assertEquals(-1, HearhamSource.parseCc("n/a"));
    }

    // ---------------- RadioID

    @Test public void radioIdParsesFreqOffsetTgsNetwork() throws Exception {
        List<Repeater> l = RadioIdRepeaterSource.parse(res("radioid_rptrs_sample.json"), 0L);
        assertEquals(2, l.size());
        Repeater w9 = byCall(l, "W9ABC");
        assertEquals(443937500L, w9.rxHz);
        assertEquals(448937500L, w9.txHz);     // +5.000 MHz
        assertEquals(1, w9.cc);
        assertEquals("BM", w9.network);        // normalised from "BrandMeister"
        assertTrue(w9.dmr);
        assertFalse(w9.hasCoords);             // no coords, no locator
        // talkgroups: 3100 TS1 (named), 31665 TS1
        assertEquals(2, w9.talkgroups.size());
        Talkgroup first = w9.talkgroups.get(0);
        assertEquals(3100, first.id);
        assertEquals(1, first.slot);
        assertEquals("USA Bridge", first.name);
    }

    @Test public void radioIdNetworkNormalisationAndLocator() throws Exception {
        Repeater n9 = byCall(RadioIdRepeaterSource.parse(res("radioid_rptrs_sample.json"), 0L), "N9DMR");
        assertEquals("DMR+", n9.network);      // from "DMR-plus"
        // bare-int talkgroups default to the ts_linked slot (TS2)
        assertEquals(2, n9.talkgroups.size());
        assertEquals(2, n9.talkgroups.get(0).slot);
        // "Rockford EN52xx" -> EN52XX is a valid Maidenhead locator (Rockford is grid EN52),
        // so RadioID rows without lat/lon still get an approximate position.
        assertTrue(n9.hasCoords);
        assertTrue(n9.approx);
    }

    @Test public void radioIdOffsetParsing() {
        assertEquals(5000000L, RadioIdRepeaterSource.parseOffsetHz("+5.000"));
        assertEquals(-600000L, RadioIdRepeaterSource.parseOffsetHz("-0.600"));
        assertEquals(0L, RadioIdRepeaterSource.parseOffsetHz(""));
        assertEquals(443937500L, RadioIdRepeaterSource.parseMhz("443.93750"));
    }

    // ---------------- merge

    @Test public void mergeDedupesByKeyAndUnionsTalkgroups() throws Exception {
        List<Repeater> bm = BrandMeisterSource.parseDeviceList(res("bm_device_sample.json"), 0L).repeaters;
        // give the BM W9ABC a TS1 talkgroup so we can see the union
        Repeater bmW9 = byCall(bm, "W9ABC");
        assertNotNull(bmW9);
        bmW9.talkgroups.add(new Talkgroup(9, 1, "Local", "static"));
        List<Repeater> rid = RadioIdRepeaterSource.parse(res("radioid_rptrs_sample.json"), 0L);
        List<Repeater> hh = HearhamSource.parse(res("hearham_sample.json"), 0L);

        List<Repeater> merged = RepeaterCatalog.merge(bm, rid, hh);
        Repeater w9 = byCall(merged, "W9ABC");
        assertNotNull(w9);
        // one merged W9ABC carrying all three sources
        int both = RepeaterModels.SRC_BRANDMEISTER | RepeaterModels.SRC_RADIOID | RepeaterModels.SRC_HEARHAM;
        assertEquals(both, w9.sources & both);
        // BM coords win (BM had them)
        assertTrue(w9.hasCoords);
        assertEquals(41.8781, w9.lat, 1e-3);
        // talkgroups union: BM's 9 + RadioID's 3100, 31665
        java.util.Set<Integer> tgIds = new java.util.HashSet<>();
        for (Talkgroup t : w9.talkgroups) tgIds.add(t.id);
        assertTrue(tgIds.contains(9) && tgIds.contains(3100) && tgIds.contains(31665));
    }

    @Test public void mergeKeepsDistinctRepeatersSeparate() throws Exception {
        List<Repeater> rid = RadioIdRepeaterSource.parse(res("radioid_rptrs_sample.json"), 0L);
        List<Repeater> hh = HearhamSource.parse(res("hearham_sample.json"), 0L);
        List<Repeater> merged = RepeaterCatalog.merge(rid, hh);
        // W9ABC(DMR), N9DMR(DMR), KA0KMJ(FM), KSTALE(FM), and the hearham W9ABC DMR merges with RadioID W9ABC
        assertNotNull(byCall(merged, "KA0KMJ"));
        assertNotNull(byCall(merged, "N9DMR"));
        assertNotNull(byCall(merged, "KSTALE"));
    }

    @Test public void mergeNullSafe() {
        assertTrue(RepeaterCatalog.merge((List<Repeater>) null).isEmpty());
        assertTrue(RepeaterCatalog.merge(new ArrayList<Repeater>()).isEmpty());
    }
}
