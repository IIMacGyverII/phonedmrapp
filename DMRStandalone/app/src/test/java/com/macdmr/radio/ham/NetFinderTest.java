/*
 * SignalDeck - Copyright (C) 2026 IIMacGyverII
 * SPDX-License-Identifier: GPL-3.0-or-later
 * Free software under the GNU General Public License v3 or later, with the additional terms in COPYRIGHT
 * (keep this notice and the author credit, mark modified versions, no rights to the SignalDeck name or icon).
 */
package com.macdmr.radio.ham;

import static org.junit.Assert.*;

import org.junit.Test;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Calendar;
import java.util.List;
import java.util.Locale;
import java.util.TimeZone;

public class NetFinderTest {
    private static final TimeZone TZ = TimeZone.getTimeZone("America/Chicago");

    private static String net(String name, String alt, String freq, String mode, String band, String date, String closed) {
        return "<Net><NetName>" + name + "</NetName>" + (alt == null ? "" : "<AltNetName>" + alt + "</AltNetName>") + "<Frequency>" + freq + "</Frequency>"
                + "<Logger>N0CALL - v3</Logger><NetControl>N0CALL</NetControl><Date>" + date + "</Date><Mode>" + mode + "</Mode><Band>" + band + "</Band>"
                + "<SubscriberCount>7</SubscriberCount>" + (closed == null ? "" : "<ClosedAt>" + closed + "</ClosedAt><NetID>42</NetID>") + "<FutureField>x</FutureField></Net>";
    }
    private static String list(String... nets) {
        return "<?xml version=\"1.0\"?><NetLoggerXML><Header><TimeZone>UTC</TimeZone></Header><ServerList><ResponseCode>200 OK</ResponseCode>"
                + "<Server><ServerName>NETLOGGER</ServerName>" + String.join("", nets) + "</Server><Server><ServerName>NetLogger3</ServerName></Server></ServerList></NetLoggerXML>";
    }

    @Test public void parsesActiveNets() {
        List<NetFinder.Net> l = NetFinder.parseNets(list(
                net("Club Net", "Club Net &amp; Swap", "146.730", "FM", "2m", "2026-10-22 00:30:00", null),
                net("80m Net", null, "3.916 MHz", "SSB", "80m", "2026-10-22 00:10:00", null),
                net("TG Net", null, "3148", "DMR", "VHF/UHF", "2026-10-22 00:20:00", null),
                net("Odd", null, "Quadnet", "FM", "70cm", "2026-10-22 00:20:00", null)));
        assertEquals(4, l.size());
        NetFinder.Net a = l.get(0);
        assertEquals("NETLOGGER", a.server); assertEquals("Club Net & Swap", a.name); assertEquals("Club Net", a.apiName);
        assertEquals(146_730_000L, a.freqHz); assertEquals(7, a.followers); assertEquals("N0CALL", a.netControl);
        assertTrue(a.opened > 0);
        assertEquals(0, l.get(1).freqHz);                                    // HF: not this radio
        assertEquals(3148, l.get(2).talkgroup); assertEquals(0, l.get(2).freqHz);
        assertEquals(0, l.get(3).freqHz); assertEquals(0, l.get(3).talkgroup);
    }

    @Test public void frequenciesAsTyped() {
        assertEquals(146_730_000L, NetFinder.parseFreqHz("146.73"));
        assertEquals(145_190_000L, NetFinder.parseFreqHz("145.190.000"));
        assertEquals(444_000_000L, NetFinder.parseFreqHz("444.0000"));
        assertEquals(443_587_500L, NetFinder.parseFreqHz("443.5875"));
        assertEquals(147_105_000L, NetFinder.parseFreqHz("147.105+ PL 100.0"));
        assertEquals(0, NetFinder.parseFreqHz("28.400"));
        assertEquals(98006, NetFinder.parseTalkgroup("D 98006 Y11689"));
        assertEquals(3141, NetFinder.parseTalkgroup("DMR 3141"));
    }

    @Test public void checkinsKeepOnlyWhatIsShown() {
        String x = "<NetLoggerXML><CheckinList><ServerName>NETLOGGER</ServerName><Pointer>2</Pointer>"
                + "<Checkin><SerialNo>1</SerialNo><Callsign>N0CALL</Callsign><State>TX</State><FirstName>JOHN</FirstName><PreferredName>JD</PreferredName><Street>1 Main St</Street><Status> </Status></Checkin>"
                + "<Checkin><SerialNo>2</SerialNo><Callsign>N1CALL</Callsign><State>OK</State><FirstName>ANN</FirstName><PreferredName/></Checkin>"
                + "</CheckinList></NetLoggerXML>";
        List<NetFinder.Checkin> c = NetFinder.parseCheckins(x);
        assertEquals(2, c.size()); assertEquals("JD", c.get(0).name); assertEquals("ANN", c.get(1).name); assertEquals("TX", c.get(0).state);
        assertEquals(2, NetFinder.pointer(x));
    }

    private static NetFinder.Place place(String label, long rx, long tx, int channel, double km, Integer... tgs) {
        NetFinder.Place p = new NetFinder.Place(); p.label = label; p.rxHz = rx; p.txHz = tx; p.channel = channel; p.km = km; p.talkgroups.addAll(Arrays.asList(tgs)); return p;
    }

    @Test public void matchesYourChannelBeforeARepeater() {
        NetFinder.Net n = new NetFinder.Net(); n.freqHz = 146_730_000L;
        List<NetFinder.Place> ps = new ArrayList<>(Arrays.asList(
                place("far repeater", 146_730_000L, 146_130_000L, 0, 40),
                place("near repeater", 146_731_000L, 146_131_000L, 0, 8),
                place("my channel", 146_730_000L, 146_130_000L, 12, -1)));
        assertEquals("my channel", NetFinder.match(n, ps).label);
        ps.remove(2);
        assertEquals("near repeater", NetFinder.match(n, ps).label);
        n.freqHz = 146_760_000L; assertNull(NetFinder.match(n, ps));
        NetFinder.Net tg = new NetFinder.Net(); tg.talkgroup = 3148;
        assertEquals("dmr", NetFinder.match(tg, Arrays.asList(place("dmr", 443_000_000L, 448_000_000L, 3, -1, 3148, 9))).label);
    }

    private static long local(String s) throws Exception { SimpleDateFormat f = new SimpleDateFormat("yyyy-MM-dd HH:mm", Locale.US); f.setTimeZone(TZ); return f.parse(s).getTime(); }
    private static String utc(long t) { SimpleDateFormat f = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss", Locale.US); f.setTimeZone(TimeZone.getTimeZone("UTC")); return f.format(new java.util.Date(t)); }

    @Test public void weeklyScheduleFromThePastWeek() throws Exception {
        long tue = local("2026-10-20 19:30");                                  // a Tuesday
        List<NetFinder.Net> past = NetFinder.parseNets(list(
                net("Club Net", null, "146.730", "FM", "2m", utc(tue), utc(tue + 45 * 60_000L)),
                net("Morning", null, "147.330", "FM", "2m", utc(local("2026-10-15 07:00")), null),
                net("Morning", null, "147.330", "FM", "2m", utc(local("2026-10-16 07:05")), null),
                net("Morning", null, "147.330", "FM", "2m", utc(local("2026-10-17 06:58")), null),
                net("Morning", null, "147.330", "FM", "2m", utc(local("2026-10-18 07:00")), null)));
        List<NetFinder.Slot> s = NetFinder.scheduleFromPast(past, TZ);
        assertEquals(2, s.size());
        NetFinder.Slot club = s.get(0).name.equals("Club Net") ? s.get(0) : s.get(1), morning = club == s.get(0) ? s.get(1) : s.get(0);
        assertEquals(Calendar.TUESDAY, club.dow); assertEquals(19 * 60 + 30, club.minute); assertEquals(45, club.durationMin);
        assertEquals("Tuesdays 7:30 PM", NetFinder.when(club));
        assertEquals(0, morning.dow); assertEquals("Daily 7:00 AM", NetFinder.when(morning));
        long now = local("2026-10-27 19:00");                                 // the next Tuesday, before it starts
        assertEquals(local("2026-10-27 19:30"), NetFinder.next(club, now, TZ));
        assertEquals(local("2026-10-27 19:30"), NetFinder.next(club, local("2026-10-27 19:50"), TZ));    // still running
        assertEquals(local("2026-11-03 19:30"), NetFinder.next(club, local("2026-10-27 20:30"), TZ));
    }

    /** A net: one reception every ~90 s for 40 minutes on channel 7, from 5 DMR IDs, starting at {@code start}. */
    private static void addNet(List<NetFinder.Rx> rows, long start, int channel, boolean dmr) {
        for (int i = 0; i < 27; i++) rows.add(new NetFinder.Rx(start + i * 90_000L, channel, dmr ? "dmr" : "rx", "📻 Received 20 s", dmr ? 3100001 + i % 5 : 0));
    }

    @Test public void findsANetInTheHistoryAndItsName() throws Exception {
        List<NetFinder.Rx> rows = new ArrayList<>();
        long t = local("2026-10-20 19:30");
        addNet(rows, t, 7, true);
        rows.add(new NetFinder.Rx(t + 60_000L, 7, "txt", "📝 good evening this is the tuesday night tech net checking in", 0));
        for (int i = 0; i < 5; i++) rows.add(new NetFinder.Rx(t + i * 60_000L, 3, "rx", "📻 Received 5 s", 0));      // a short chat on another channel
        List<NetFinder.Session> s = NetFinder.sessions(rows);
        assertEquals(2, s.size());
        NetFinder.Session net = s.get(0).channel == 7 ? s.get(0) : s.get(1), chat = net == s.get(0) ? s.get(1) : s.get(0);
        assertTrue(NetFinder.netLike(net)); assertFalse(NetFinder.netLike(chat));
        assertEquals(5, net.stations); assertEquals(39, net.minutes()); assertEquals("Tuesday Night Tech Net", net.name);
        NetFinder.Session live = NetFinder.live(rows, t + 40 * 60_000L);
        assertNotNull(live); assertEquals(7, live.channel);
        assertNull(NetFinder.live(rows, t + 60 * 60_000L));                   // over
    }

    @Test public void twoTalkersAreNotANet() throws Exception {
        List<NetFinder.Rx> rows = new ArrayList<>();
        for (int i = 0; i < 30; i++) rows.add(new NetFinder.Rx(local("2026-10-20 19:30") + i * 90_000L, 7, "dmr", "", i % 2 == 0 ? 1 : 2));
        assertFalse(NetFinder.netLike(NetFinder.sessions(rows).get(0)));
    }

    @Test public void learnsWeeklyAndDailyNets() throws Exception {
        List<NetFinder.Rx> rows = new ArrayList<>();
        addNet(rows, local("2026-10-06 19:30"), 7, false);                   // Tuesdays, analog: no caller IDs
        addNet(rows, local("2026-10-13 19:40"), 7, false);
        addNet(rows, local("2026-10-20 19:25"), 7, false);
        addNet(rows, local("2026-10-15 07:00"), 4, true);                     // mornings on channel 4
        addNet(rows, local("2026-10-16 07:10"), 4, true);
        addNet(rows, local("2026-10-17 06:55"), 4, true);
        addNet(rows, local("2026-10-14 12:00"), 9, true);                     // once: not a schedule
        List<NetFinder.Slot> l = NetFinder.learned(NetFinder.sessions(rows), TZ);
        assertEquals(2, l.size());
        NetFinder.Slot daily = l.get(0).dow == 0 ? l.get(0) : l.get(1), weekly = daily == l.get(0) ? l.get(1) : l.get(0);
        assertEquals(4, daily.channel); assertEquals(3, daily.seen); assertEquals(5, daily.stations);
        assertEquals(7, weekly.channel); assertEquals(Calendar.TUESDAY, weekly.dow); assertEquals(19 * 60 + 30, weekly.minute); assertEquals(3, weekly.seen);
    }

    private static NetFinder.Net named(String name, String nc) { NetFinder.Net n = new NetFinder.Net(); n.name = name; n.netControl = nc; n.freqHz = 146_880_000L; return n; }

    @Test public void tellsWhetherANetIsNear() {
        assertEquals("TX", NetFinder.stateIn("North Texas ARS Net"));
        assertEquals("WV", NetFinder.stateIn("West Virginia Phone Net"));
        assertEquals("VA", NetFinder.stateIn("Virginia ARES"));
        assertEquals("NM", NetFinder.stateIn("Albuquerque NM Net"));
        assertNull(NetFinder.stateIn("Licking County ARES Net"));
        assertNull(NetFinder.stateIn("Tech Net IN the evening"));          // IN is a word, not Indiana
        assertEquals(5, NetFinder.callDistrict("N5XYZ")); assertEquals(8, NetFinder.callDistrict("KD8ABC")); assertEquals(4, NetFinder.callDistrict("AE4Q"));
        assertEquals(-1, NetFinder.callDistrict("KL7AA")); assertEquals(-1, NetFinder.callDistrict("VE3XYZ"));
        int tx = NetFinder.districtOf("TX");
        assertEquals(1, NetFinder.locality(named("North Texas ARS Net", "W8ZZZ"), "TX", tx));     // the name wins
        assertEquals(-1, NetFinder.locality(named("SKYWARN Virginia Net", "N5AAA"), "TX", tx));
        assertEquals(-1, NetFinder.locality(named("Licking County ARES Net", "KD8ABC"), "TX", tx)); // net control in district 8
        assertEquals(0, NetFinder.locality(named("County ARES Net", "KF5ABC"), "TX", tx));         // same district: several states, can't tell
        assertEquals(-1, NetFinder.locality(named("County ARES Net", "VE3XYZ"), "TX", tx));       // another country
        NetFinder.Net lg = named("Mesa County ARES Net", " "); lg.logger = "N0CALL-JOE - CO - v3.1.7W";
        assertEquals("CO", NetFinder.loggerState(lg.logger)); assertEquals("N0CALL", NetFinder.loggerCall(lg.logger));
        assertEquals(-1, NetFinder.locality(lg, "MN", NetFinder.districtOf("MN")));                 // the logger's state, though the district matches
        lg.logger = "N0CALL-JOE - MN - v3"; assertEquals(1, NetFinder.locality(lg, "MN", NetFinder.districtOf("MN")));
        lg.logger = "KD8ABC - v2.4"; assertEquals(-1, NetFinder.locality(lg, "MN", NetFinder.districtOf("MN")));        // no state: the logger's call district
        assertEquals(-1, NetFinder.locality(named("Ohio Net", "N5AAA"), null, tx));                // no state, a district from the repeaters
        NetFinder.Net tg = new NetFinder.Net(); tg.talkgroup = 3148; tg.name = "Ohio Net";
        assertEquals(1, NetFinder.locality(tg, "TX", tx));                                          // a talkgroup is everywhere
    }

    @Test public void netsYouAddToAChannel() {
        NetFinder.Manual m = new NetFinder.Manual(); m.id = 7; m.name = "Tech | Net\nsecond"; m.notes = "100% fun"; m.channel = 12; m.minute = 19 * 60 + 30; m.durationMin = 45;
        m.days = (1 << Calendar.MONDAY) | (1 << Calendar.WEDNESDAY);
        NetFinder.Manual daily = new NetFinder.Manual(); daily.id = 8; daily.name = "Morning"; daily.channel = 4; daily.minute = 7 * 60; daily.days = NetFinder.ALL_DAYS;
        List<NetFinder.Manual> back = NetFinder.decode(NetFinder.encode(Arrays.asList(m, daily)));
        assertEquals(2, back.size());
        assertEquals("Tech | Net\nsecond", back.get(0).name); assertEquals("100% fun", back.get(0).notes); assertEquals(m.days, back.get(0).days); assertEquals(45, back.get(0).durationMin);
        assertEquals("Mon, Wed 7:30 PM", NetFinder.when(back.get(0))); assertEquals("Daily 7:00 AM", NetFinder.when(back.get(1)));
        List<NetFinder.Slot> s = NetFinder.manualSlots(back);
        assertEquals(3, s.size());                                            // Monday, Wednesday, daily
        assertEquals(1, s.get(0).near); assertEquals(7, s.get(0).manualId); assertEquals(Calendar.MONDAY, s.get(0).dow);
        assertEquals(0, s.get(2).dow);
        NetFinder.Slot heard = new NetFinder.Slot(); heard.channel = 12; heard.dow = Calendar.WEDNESDAY; heard.minute = 19 * 60 + 50;
        assertTrue(NetFinder.sameNet(s.get(1), heard));
        heard.channel = 13; assertFalse(NetFinder.sameNet(s.get(1), heard));
        assertTrue(NetFinder.decode("garbage\n1|2").isEmpty());
    }
}
