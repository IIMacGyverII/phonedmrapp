package com.dmrmod.hooks;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertFalse;
import static org.junit.Assert.assertTrue;

import com.dmrmod.hooks.RepeaterModels.Repeater;
import com.dmrmod.hooks.RepeaterModels.Talkgroup;
import com.dmrmod.hooks.RepeaterPlanner.ChannelSpec;
import com.dmrmod.hooks.RepeaterPlanner.Plan;

import org.junit.Test;

import java.util.Arrays;
import java.util.HashSet;
import java.util.LinkedHashMap;
import java.util.LinkedHashSet;
import java.util.Map;
import java.util.Set;

/** Host unit tests for {@link RepeaterPlanner} — the one-listen-channel-per-slot model (ch16 §10). */
public class RepeaterPlannerTest {

    private static Repeater dualSlot() {
        Repeater r = new Repeater();
        r.callsign = "W9ABC";
        r.city = "Chicago";
        r.rxHz = 443_937_500L;
        r.txHz = 448_937_500L;
        r.cc = 1;
        r.dmr = true;
        // TS1: 3100 (primary), 31665, 9 ; TS2: 91 (primary), 93
        r.talkgroups.add(new Talkgroup(3100, 1, null, "static"));
        r.talkgroups.add(new Talkgroup(31665, 1, null, "static"));
        r.talkgroups.add(new Talkgroup(9, 1, null, "static"));
        r.talkgroups.add(new Talkgroup(91, 2, null, "static"));
        r.talkgroups.add(new Talkgroup(93, 2, null, "static"));
        return r;
    }

    private static Map<Integer, String> names() {
        Map<Integer, String> m = new LinkedHashMap<>();
        m.put(9, "Local"); m.put(91, "Worldwide"); m.put(93, "North America");
        m.put(3100, "USA Bridge"); m.put(31665, "Illinois");
        return m;
    }

    private static ChannelSpec byRoleSlot(Plan p, String role, int slotIndex) {
        for (ChannelSpec c : p.channels) if (role.equals(c.role) && c.slotIndex == slotIndex) return c;
        return null;
    }

    @Test public void noTalkTgsGivesOneListenChannelPerSlot() {
        Plan p = RepeaterPlanner.plan(dualSlot(), null, names());
        assertEquals(2, p.channels.size());             // one per slot, no talk channels
        ChannelSpec ts1 = byRoleSlot(p, "listen", 0);
        ChannelSpec ts2 = byRoleSlot(p, "listen", 1);
        assertEquals(3100, ts1.txContact);              // slot's primary = first in list
        assertEquals(91, ts2.txContact);
        // RX list holds the whole slot
        assertTrue(contains(ts1.groups, 3100) && contains(ts1.groups, 31665) && contains(ts1.groups, 9));
        assertTrue(contains(ts2.groups, 91) && contains(ts2.groups, 93));
        assertEquals(1, ts1.cc);
        assertEquals(443_937_500L, ts1.rxHz);
        assertEquals(448_937_500L, ts1.txHz);
        assertEquals("W9ABC S1", ts1.name);
        assertEquals("W9ABC S2", ts2.name);
    }

    @Test public void tickedTalkTgAddsOneChannelSharingTheRxList() {
        Set<Integer> talk = new LinkedHashSet<>(Arrays.asList(31665, 93));
        Plan p = RepeaterPlanner.plan(dualSlot(), talk, names());
        // 2 listen + 2 talk
        assertEquals(4, p.channels.size());
        ChannelSpec talk1 = null, talk2 = null;
        for (ChannelSpec c : p.channels) {
            if ("talk".equals(c.role) && c.txContact == 31665) talk1 = c;
            if ("talk".equals(c.role) && c.txContact == 93) talk2 = c;
        }
        assertTrue(talk1 != null && talk2 != null);
        // talk channel shares the slot's RX list
        assertTrue(contains(talk1.groups, 3100) && contains(talk1.groups, 9));
        assertEquals(0, talk1.slotIndex);
        assertEquals(1, talk2.slotIndex);
        assertEquals("W9ABC Illinois", talk1.name);     // named from the TG map
        assertEquals("W9ABC North America", talk2.name);
    }

    @Test public void tickingThePrimaryDoesNotDuplicate() {
        Set<Integer> talk = new LinkedHashSet<>(Arrays.asList(3100));  // already the listen txContact
        Plan p = RepeaterPlanner.plan(dualSlot(), talk, names());
        assertEquals(2, p.channels.size());             // no extra channel
    }

    @Test public void contactsNeededCoversEveryTg() {
        Plan p = RepeaterPlanner.plan(dualSlot(), null, names());
        assertEquals(new HashSet<>(Arrays.asList(9, 91, 93, 3100, 31665)), p.contactsNeeded.keySet());
        assertEquals("USA Bridge", p.contactsNeeded.get(3100));
    }

    @Test public void unknownSlotFoldsIntoTs1() {
        Repeater r = new Repeater();
        r.callsign = "N0X"; r.dmr = true; r.cc = 2; r.rxHz = 146_940_000L; r.txHz = 146_340_000L;
        r.talkgroups.add(new Talkgroup(2, 0, null, "static"));   // slot unknown
        Plan p = RepeaterPlanner.plan(r, null, null);
        assertEquals(1, p.channels.size());
        assertEquals(0, p.channels.get(0).slotIndex);            // TS1
        assertEquals(2, p.channels.get(0).txContact);
    }

    @Test public void over32TgsTruncatesAndWarns() {
        Repeater r = new Repeater();
        r.callsign = "BIG"; r.dmr = true; r.cc = 1; r.rxHz = 440_000_000L; r.txHz = 445_000_000L;
        for (int i = 1; i <= 40; i++) r.talkgroups.add(new Talkgroup(i, 1, null, "static"));
        Plan p = RepeaterPlanner.plan(r, null, null);
        ChannelSpec listen = p.channels.get(0);
        assertEquals(32, listen.groups.length);
        assertTrue(listen.groupsTruncated);
        assertFalse(p.warnings.isEmpty());
        assertTrue(contains(listen.groups, 32));
        assertFalse(contains(listen.groups, 33));   // 33rd TG dropped
    }

    @Test public void nameTrimmedTo32() {
        Repeater r = new Repeater();
        r.callsign = "VERYLONGCALLSIGN12345"; r.dmr = true; r.cc = 1;
        r.rxHz = 440_000_000L; r.txHz = 445_000_000L;
        r.talkgroups.add(new Talkgroup(999999, 2, null, "static"));
        Plan p = RepeaterPlanner.plan(r, new LinkedHashSet<>(Arrays.asList(999999)), null);
        for (ChannelSpec c : p.channels) assertTrue(c.name.length() <= RepeaterPlanner.MAX_NAME);
    }

    @Test public void nonDmrOrEmptyYieldsNoChannels() {
        Repeater fm = new Repeater(); fm.callsign = "FM"; fm.dmr = false;
        assertTrue(RepeaterPlanner.plan(fm, null, null).channels.isEmpty());
        Repeater empty = new Repeater(); empty.callsign = "E"; empty.dmr = true;
        assertTrue(RepeaterPlanner.plan(empty, null, null).channels.isEmpty());
    }

    private static boolean contains(int[] a, int v) {
        for (int x : a) if (x == v) return true;
        return false;
    }
}
