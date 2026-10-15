package com.dmrmod.hooks;

import com.dmrmod.hooks.RepeaterModels.Repeater;
import com.dmrmod.hooks.RepeaterModels.Talkgroup;

import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.LinkedHashSet;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.Set;

/**
 * Pure planner: a {@link Repeater} (plus the TGs the user wants to transmit on) becomes a list of
 * {@link ChannelSpec}s, under the model proven on-air 2026-10-15 (chapter 16 §10):
 *
 * <ul>
 *   <li><b>One listen channel per active timeslot.</b> Its RX group list holds all that slot's
 *       talkgroups (the firmware's receive filter), up to 32; its {@code txContact} is the slot's
 *       primary TG so it can also transmit on the main one.</li>
 *   <li><b>Opt-in talk channels.</b> Each TG the user ticks adds one channel with the <i>same</i>
 *       RX list but {@code txContact} set to that TG, so PTT goes there.</li>
 * </ul>
 *
 * No Android imports — {@code RepeaterPlannerTest} runs it on the host. It builds a plan only; the
 * device-side applier (RepeaterProgrammer, Phase 1) turns each spec into a {@code ChannelData} via
 * the OEM {@code createChannel} path. Nothing here writes anything.
 */
public final class RepeaterPlanner {

    /** Hardware ceiling on the RX group list (one int[32] per channel). */
    public static final int MAX_GROUPS = 32;
    /** OEM channel-name column width (verified: {@code interphone_channel_name_edit maxLength=32}). */
    public static final int MAX_NAME = 32;

    private RepeaterPlanner() { }

    /** A channel the planner wants created. type is always 0 (DMR) here. */
    public static final class ChannelSpec {
        public String name;
        public int type = 0;                 // 0 = DMR, 1 = analog FM
        public long rxHz;
        public long txHz;
        public int cc;
        public int slotIndex;                // 0 = TS1, 1 = TS2 (ChannelData inBound/outBound)
        public int contactType = 1;          // GROUP (DMR); 0 for FM
        public int txContact;                // the TG PTT transmits to (DMR)
        public int[] groups;                 // RX group list (<=32), the receive filter (DMR)
        public String role;                  // "listen", "talk" (DMR) or "fm"
        public boolean groupsTruncated;      // slot had >32 TGs
        // FM-only
        public int bandwidth = 1;            // 1 wide / 0 narrow
        public String toneUp;                // TX tone string ("67.0", "D023N"), or null
        public String toneDown;              // RX tone string, or null

        public boolean isFm() { return type == 1; }

        @Override public String toString() {
            if (type == 1) return "fm " + name + " rx=" + rxHz + " tx=" + txHz
                 + " txTone=" + toneUp + " rxTone=" + toneDown + " bw=" + bandwidth;
            return role + " " + name + " txTG=" + txContact + " slot" + (slotIndex + 1)
                 + " rxGroups=" + java.util.Arrays.toString(groups);
        }
    }

    /** The full plan for one repeater: channels to create + contacts needed. */
    public static final class Plan {
        public final List<ChannelSpec> channels = new ArrayList<>();
        /** TG id → display name, for every TG that needs a contact (all TGs across the slots). */
        public final Map<Integer, String> contactsNeeded = new LinkedHashMap<>();
        public final List<String> warnings = new ArrayList<>();
        public String zoneName;              // suggested zone for this repeater
    }

    /**
     * Build the plan. {@code talkTgIds} are the TGs the user ticked to transmit on (may be empty).
     * {@code names} maps TG id → name (from the BrandMeister {@code /talkgroup} map); may be null.
     */
    public static Plan plan(Repeater rep, Set<Integer> talkTgIds, Map<Integer, String> names) {
        Plan plan = new Plan();
        if (rep == null) { plan.warnings.add("no repeater"); return plan; }
        plan.zoneName = trim("»" + nz(rep.callsign) + " " + nz(rep.city), MAX_NAME);

        // FM: exactly one analog channel.
        if (rep.fm && !rep.dmr) {
            ChannelSpec fm = new ChannelSpec();
            fm.type = 1;
            fm.contactType = 0;
            fm.rxHz = rep.rxHz;
            fm.txHz = rep.txHz;
            fm.bandwidth = rep.bandwidth;
            fm.toneUp = rep.toneUp;
            fm.toneDown = rep.toneDown;
            fm.role = "fm";
            fm.name = trim(nz(rep.callsign) + " " + nz(rep.city), MAX_NAME);
            if (fm.name.isEmpty()) fm.name = nz(rep.callsign);
            plan.channels.add(fm);
            return plan;
        }

        if (!rep.dmr) {
            plan.warnings.add("not a DMR or FM repeater");
            return plan;
        }
        if (rep.talkgroups.isEmpty()) {
            plan.warnings.add("no talkgroups known for this repeater");
            return plan;
        }
        Set<Integer> talk = talkTgIds != null ? talkTgIds : new LinkedHashSet<Integer>();
        Map<Integer, String> nm = names != null ? names : new LinkedHashMap<Integer, String>();

        // Group the repeater's TGs by slot, preserving order. Unknown slot (0) is treated as TS1.
        Map<Integer, List<Integer>> bySlot = new LinkedHashMap<>();
        for (Talkgroup tg : rep.talkgroups) {
            if (tg.id <= 0) continue;
            int slot = (tg.slot == 2) ? 2 : 1;   // 0/unknown -> TS1
            List<Integer> list = bySlot.get(slot);
            if (list == null) { list = new ArrayList<>(); bySlot.put(slot, list); }
            if (!list.contains(tg.id)) list.add(tg.id);
            if (!plan.contactsNeeded.containsKey(tg.id)) {
                plan.contactsNeeded.put(tg.id, tgName(tg.id, tg.name, nm));
            }
        }

        for (Map.Entry<Integer, List<Integer>> e : bySlot.entrySet()) {
            int slot = e.getKey();
            List<Integer> tgs = e.getValue();
            int[] groups = toGroups(tgs);
            boolean truncated = tgs.size() > MAX_GROUPS;
            if (truncated) {
                plan.warnings.add("slot " + slot + " has " + tgs.size()
                    + " talkgroups; only the first " + MAX_GROUPS + " are programmed");
            }
            int primary = tgs.get(0);

            // listen channel for the slot
            ChannelSpec listen = base(rep, slot, groups, truncated);
            listen.txContact = primary;
            listen.role = "listen";
            listen.name = trim(nz(rep.callsign) + " S" + slot, MAX_NAME);
            plan.channels.add(listen);

            // talk channels for selected TGs on this slot
            for (Integer tg : tgs) {
                if (!talk.contains(tg)) continue;
                if (tg == primary) continue;   // already the listen channel's txContact
                ChannelSpec t = base(rep, slot, groups, truncated);
                t.txContact = tg;
                t.role = "talk";
                String label = nm.get(tg);
                t.name = trim(nz(rep.callsign) + " " + (label != null ? label : String.valueOf(tg)), MAX_NAME);
                plan.channels.add(t);
            }
        }
        return plan;
    }

    private static ChannelSpec base(Repeater rep, int slot, int[] groups, boolean truncated) {
        ChannelSpec s = new ChannelSpec();
        s.rxHz = rep.rxHz;
        s.txHz = rep.txHz;
        s.cc = rep.cc >= 0 ? rep.cc : 1;
        s.slotIndex = slot - 1;         // TS1->0, TS2->1
        s.groups = groups;
        s.groupsTruncated = truncated;
        return s;
    }

    private static int[] toGroups(List<Integer> tgs) {
        int n = Math.min(tgs.size(), MAX_GROUPS);
        int[] g = new int[MAX_GROUPS];
        for (int i = 0; i < n; i++) g[i] = tgs.get(i);
        return g;
    }

    private static String tgName(int id, String onTg, Map<Integer, String> nm) {
        if (onTg != null && !onTg.isEmpty()) return onTg;
        String n = nm.get(id);
        return n != null ? n : ("TG " + id);
    }

    static String trim(String s, int max) {
        if (s == null) return "";
        s = s.trim();
        return s.length() <= max ? s : s.substring(0, max).trim();
    }

    private static String nz(String s) { return s == null ? "" : s.trim(); }
}
