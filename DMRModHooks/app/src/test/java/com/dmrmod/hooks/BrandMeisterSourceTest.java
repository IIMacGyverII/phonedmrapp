package com.dmrmod.hooks;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertFalse;
import static org.junit.Assert.assertNotNull;
import static org.junit.Assert.assertTrue;

import com.dmrmod.hooks.RepeaterModels.Repeater;

import org.junit.Test;

import com.dmrmod.hooks.RepeaterModels.Talkgroup;

import java.io.ByteArrayOutputStream;
import java.io.InputStream;
import java.util.List;
import java.util.Map;

/** Host unit tests for {@link BrandMeisterSource#parseDeviceList} against a checked-in fixture. */
public class BrandMeisterSourceTest {

    private static String fixture() throws Exception {
        try (InputStream in = BrandMeisterSourceTest.class.getResourceAsStream(
                "/repeaters/bm_device_sample.json")) {
            assertNotNull("fixture missing", in);
            ByteArrayOutputStream out = new ByteArrayOutputStream();
            byte[] buf = new byte[4096];
            int n;
            while ((n = in.read(buf)) != -1) out.write(buf, 0, n);
            return new String(out.toByteArray(), "UTF-8");
        }
    }

    private static Repeater byCall(BrandMeisterSource.ParseResult r, String call) {
        for (Repeater rep : r.repeaters) if (call.equals(rep.callsign)) return rep;
        return null;
    }

    @Test public void parsesAndDropsSimplexAndNoCallsign() throws Exception {
        BrandMeisterSource.ParseResult r = BrandMeisterSource.parseDeviceList(fixture(), 123L);
        assertEquals(5, r.total);
        // GB7BB, W9ABC, EA1LOC survive; SIMPLEX1 (tx==rx) and the blank callsign are dropped.
        assertEquals(3, r.repeaters.size());
        assertEquals(1, r.skippedSimplex);
        assertEquals(1, r.skippedNoCallsign);
    }

    @Test public void repeaterPointOfViewFreqSwap() throws Exception {
        // BM tx (repeater output) is the user's RX; BM rx (repeater input) is the user's TX.
        Repeater gb = byCall(BrandMeisterSource.parseDeviceList(fixture(), 0L), "GB7BB");
        assertNotNull(gb);
        assertEquals(439712500L, gb.rxHz);  // from tx 439.7125
        assertEquals(430712500L, gb.txHz);  // from rx 430.7125
        assertEquals(1, gb.cc);
        assertTrue(gb.dmr);
        assertFalse(gb.fm);
        assertTrue(gb.hasCoords);
        assertFalse(gb.approx);
        assertEquals(57.66, gb.lat, 1e-6);
        assertEquals(RepeaterModels.SRC_BRANDMEISTER, gb.sources);
        assertEquals(0L, gb.fetchedAt);  // parse called with fetchedAtMillis = 0
    }

    @Test public void fetchedAtPassthrough() throws Exception {
        Repeater gb = byCall(BrandMeisterSource.parseDeviceList(fixture(), 987654321L), "GB7BB");
        assertEquals(987654321L, gb.fetchedAt);
    }

    @Test public void stringNumbersParsed() throws Exception {
        // W9ABC has tx/rx/colorcode as JSON strings.
        Repeater w9 = byCall(BrandMeisterSource.parseDeviceList(fixture(), 0L), "W9ABC");
        assertNotNull(w9);
        assertEquals(443937500L, w9.rxHz);
        assertEquals(448937500L, w9.txHz);
        assertEquals(1, w9.cc);
    }

    @Test public void locatorFallbackWhenNoCoords() throws Exception {
        // EA1LOC has lat/lng 0 but "IN80DO" in the city string → approximate coords.
        Repeater ea = byCall(BrandMeisterSource.parseDeviceList(fixture(), 0L), "EA1LOC");
        assertNotNull(ea);
        assertTrue(ea.hasCoords);
        assertTrue(ea.approx);
        double[] ll = GeoUtil.maidenheadToLatLon("IN80DO");
        assertEquals(ll[0], ea.lat, 1e-6);
        assertEquals(ll[1], ea.lon, 1e-6);
    }

    @Test public void keyIsStable() throws Exception {
        Repeater gb = byCall(BrandMeisterSource.parseDeviceList(fixture(), 0L), "GB7BB");
        assertEquals(RepeaterModels.makeKey("GB7BB", 439712500L), gb.key);
    }

    private static String res(String name) throws Exception {
        try (InputStream in = BrandMeisterSourceTest.class.getResourceAsStream("/repeaters/" + name)) {
            assertNotNull(name + " missing", in);
            ByteArrayOutputStream out = new ByteArrayOutputStream();
            byte[] buf = new byte[4096]; int n;
            while ((n = in.read(buf)) != -1) out.write(buf, 0, n);
            return new String(out.toByteArray(), "UTF-8");
        }
    }

    @Test public void parsesDeviceTalkgroups() throws Exception {
        List<Talkgroup> tgs = BrandMeisterSource.parseDeviceTalkgroups(res("bm_device_talkgroup.json"));
        // 7 rows; the "0" talkgroup is dropped -> 6
        assertEquals(6, tgs.size());
        // slot "9" (invalid) becomes 0 (unknown)
        boolean found3160unknown = false, found3100ts1 = false, found91ts2 = false;
        for (Talkgroup t : tgs) {
            if (t.id == 3160) { found3160unknown = t.slot == 0; }
            if (t.id == 3100) { found3100ts1 = t.slot == 1; }
            if (t.id == 91)   { found91ts2 = t.slot == 2; }
        }
        assertTrue(found3160unknown);
        assertTrue(found3100ts1);
        assertTrue(found91ts2);
    }

    @Test public void parsesTalkgroupNames() throws Exception {
        Map<Integer, String> m = BrandMeisterSource.parseTalkgroupNames(res("bm_talkgroup_names.json"));
        assertEquals("USA Bridge", m.get(3100));
        assertEquals("Worldwide", m.get(91));
        assertEquals(6, m.size());
    }

    @Test public void talkgroupParsersAreGarbageSafe() {
        assertTrue(BrandMeisterSource.parseDeviceTalkgroups(null).isEmpty());
        assertTrue(BrandMeisterSource.parseDeviceTalkgroups("nope").isEmpty());
        assertTrue(BrandMeisterSource.parseTalkgroupNames(null).isEmpty());
        assertTrue(BrandMeisterSource.parseTalkgroupNames("[]").isEmpty());
    }

    @Test public void emptyAndGarbageAreSafe() {
        assertEquals(0, BrandMeisterSource.parseDeviceList(null, 0L).repeaters.size());
        assertEquals(0, BrandMeisterSource.parseDeviceList("", 0L).repeaters.size());
        assertEquals(0, BrandMeisterSource.parseDeviceList("not json", 0L).repeaters.size());
        assertEquals(0, BrandMeisterSource.parseDeviceList("{}", 0L).repeaters.size());
    }
}
