/*
 * SignalDeck - Copyright (C) 2026 IIMacGyverII
 * SPDX-License-Identifier: GPL-3.0-or-later
 * Free software under the GNU General Public License v3 or later, with the additional terms in COPYRIGHT
 * (keep this notice and the author credit, mark modified versions, no rights to the SignalDeck name or icon).
 */
package com.macdmr.radio.repeaters;

import com.macdmr.radio.repeaters.RepeaterModels.Repeater;
import com.macdmr.radio.repeaters.RepeaterModels.Talkgroup;

import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

/**
 * Merge of the repeater sources into one deduplicated list (chapter 16 §3, P2.3).
 *
 * <p>Key = normalised callsign + RX frequency bucket ({@link RepeaterModels#makeKey}). Records with
 * the same key are folded into one. Field precedence for DMR is BrandMeister &gt; RadioID &gt;
 * hearham; coordinates come from the first source that has them; talkgroups are the union across
 * sources; the {@code sources} bitmask ORs. Pass the source lists in precedence order.
 *
 * <p>Pure and unit-tested; no Android, no network.
 */
public final class RepeaterCatalog {

    private RepeaterCatalog() { }

    /** Fold source lists (highest precedence first) into one deduped list, insertion order kept. */
    @SafeVarargs
    public static List<Repeater> merge(List<Repeater>... sourcesInPriorityOrder) {
        Map<String, Repeater> byKey = new LinkedHashMap<>();
        for (List<Repeater> list : sourcesInPriorityOrder) {
            if (list == null) continue;
            for (Repeater r : list) {
                if (r == null || r.key == null) continue;
                Repeater existing = byKey.get(r.key);
                if (existing == null) {
                    byKey.put(r.key, copy(r));
                } else {
                    foldInto(existing, r);
                }
            }
        }
        return new ArrayList<>(byKey.values());
    }

    /** Merge {@code lower} (lower precedence) into {@code base} without overwriting known fields. */
    private static void foldInto(Repeater base, Repeater lower) {
        base.sources |= lower.sources;
        base.fm = base.fm || lower.fm;
        base.dmr = base.dmr || lower.dmr;
        if (base.cc < 0 && lower.cc >= 0) base.cc = lower.cc;
        if (base.dmrId == 0 && lower.dmrId != 0) base.dmrId = lower.dmrId;
        if (isEmpty(base.network) && !isEmpty(lower.network)) base.network = lower.network;
        if (isEmpty(base.city) && !isEmpty(lower.city)) base.city = lower.city;
        if (isEmpty(base.region) && !isEmpty(lower.region)) base.region = lower.region;
        if (isEmpty(base.country) && !isEmpty(lower.country)) base.country = lower.country;
        if (isEmpty(base.status) && !isEmpty(lower.status)) base.status = lower.status;
        if (isEmpty(base.toneUp) && !isEmpty(lower.toneUp)) base.toneUp = lower.toneUp;
        if (isEmpty(base.toneDown) && !isEmpty(lower.toneDown)) base.toneDown = lower.toneDown;
        if (!base.hasCoords && lower.hasCoords) {
            base.lat = lower.lat; base.lon = lower.lon; base.hasCoords = true; base.approx = lower.approx;
        }
        // union talkgroups by (id, slot)
        for (Talkgroup tg : lower.talkgroups) {
            boolean present = false;
            for (Talkgroup e : base.talkgroups) {
                if (e.id == tg.id && e.slot == tg.slot) {
                    if (isEmpty(e.name) && !isEmpty(tg.name)) e.name = tg.name;
                    present = true;
                    break;
                }
            }
            if (!present) base.talkgroups.add(new Talkgroup(tg.id, tg.slot, tg.name, tg.kind));
        }
    }

    private static Repeater copy(Repeater r) {
        Repeater c = new Repeater();
        c.key = r.key; c.callsign = r.callsign; c.rxHz = r.rxHz; c.txHz = r.txHz;
        c.lat = r.lat; c.lon = r.lon; c.hasCoords = r.hasCoords; c.approx = r.approx;
        c.fm = r.fm; c.dmr = r.dmr; c.cc = r.cc; c.dmrId = r.dmrId; c.network = r.network;
        c.status = r.status; c.lastSeen = r.lastSeen; c.city = r.city; c.region = r.region; c.country = r.country;
        c.toneUp = r.toneUp; c.toneDown = r.toneDown; c.bandwidth = r.bandwidth;
        c.sources = r.sources; c.fetchedAt = r.fetchedAt;
        for (Talkgroup tg : r.talkgroups) c.talkgroups.add(new Talkgroup(tg.id, tg.slot, tg.name, tg.kind));
        return c;
    }

    private static boolean isEmpty(String s) { return s == null || s.trim().isEmpty(); }
}
