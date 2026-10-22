/*
 * SignalDeck - Copyright (C) 2026 IIMacGyverII
 * SPDX-License-Identifier: GPL-3.0-or-later
 * Free software under the GNU General Public License v3 or later, with the additional terms in COPYRIGHT
 * (keep this notice and the author credit, mark modified versions, no rights to the SignalDeck name or icon).
 */
package com.macdmr.radio;

import com.macdmr.radio.dsp.ToneConverter;

import java.util.ArrayList;
import java.util.List;
import java.util.Locale;

/**
 * Standard channel lists offered when adding a zone (FRS, GMRS, NOAA weather, MURS, marine, ham simplex, DMR simplex,
 * PMR446). Installing one adds its channels (reusing any channel the user already has on the same frequencies and
 * tones) and a zone holding them, named after the list.
 */
public final class ChannelPresets {
    private ChannelPresets() { }

    public static final class Ch {
        public final String name; public final int rx, tx; public final boolean digital, high, wide, repeater;
        public final double txTone;   // a fixed CTCSS tone sent on transmit (Hz, 0 = none), e.g. a satellite's access tone
        Ch(String name, double rxMhz, double txMhz, boolean digital, boolean high, boolean wide, boolean repeater) { this(name, rxMhz, txMhz, digital, high, wide, repeater, 0); }
        Ch(String name, double rxMhz, double txMhz, boolean digital, boolean high, boolean wide, boolean repeater, double txTone) {
            this.name = name; rx = hz(rxMhz); tx = hz(txMhz); this.digital = digital; this.high = high; this.wide = wide; this.repeater = repeater; this.txTone = txTone;
        }
    }

    public static final class Preset {
        public final String zone, region, about, licence; public final List<Ch> channels = new ArrayList<>();
        Preset(String zone, String region, String about, String licence) { this.zone = zone; this.region = region; this.about = about; this.licence = licence; }
        public boolean hasRepeaters() { for (Ch c : channels) if (c.repeater) return true; return false; }
        public boolean receiveOnly() { for (Ch c : channels) if (!ChannelStore.receiveOnly(c.tx)) return false; return true; }
        Preset fm(String name, double mhz, boolean high, boolean wide) { channels.add(new Ch(name, mhz, mhz, false, high, wide, false)); return this; }
        Preset split(String name, double rxMhz, double txMhz, boolean high, boolean wide, double txTone) { channels.add(new Ch(name, rxMhz, txMhz, false, high, wide, false, txTone)); return this; }
    }

    /** The DMR simplex talkgroup (BrandMeister and most networks): every DMR simplex channel calls and listens on it. */
    public static final int DMR_SIMPLEX_TG = 99;

    private static int hz(double mhz) { return (int) Math.round(mhz * 1e6); }

    public static List<Preset> all() {
        List<Preset> out = new ArrayList<>();

        Preset frs = new Preset("FRS", "US", "Family Radio Service: the 22 channels of bubble-pack walkie-talkies. Narrow band, low power.", "No licence needed");
        for (int n = 1; n <= 22; n++) frs.fm(String.format(Locale.US, "FRS %d", n), frsMhz(n), false, false);
        out.add(frs);

        Preset gmrs = new Preset("GMRS", "US", "General Mobile Radio Service: the same 22 channels as FRS (they talk to FRS radios) plus the 8 repeater channels 15R to 22R, which listen on 462 MHz and transmit 5 MHz higher. Channels 8 to 14 are narrow band at low power.", "FCC GMRS licence needed (no exam; it covers your family)");
        for (int n = 1; n <= 22; n++) { boolean interstitial467 = n >= 8 && n <= 14; gmrs.fm(String.format(Locale.US, "GMRS %d", n), frsMhz(n), !interstitial467, !interstitial467); }
        for (int n = 15; n <= 22; n++) gmrs.channels.add(new Ch(String.format(Locale.US, "GMRS %dR", n), frsMhz(n), frsMhz(n) + 5, false, true, true, true));
        out.add(gmrs);

        Preset wx = new Preset("NOAA Weather", "US / Canada", "The seven NOAA Weather Radio (and Environment Canada) broadcast channels. Receive-only; the strongest one is your local station. With SAME alerts on (PKT) the radio decodes the warnings.", "Receive-only");
        double[] wxMhz = { 162.550, 162.400, 162.475, 162.425, 162.450, 162.500, 162.525 };
        for (int i = 0; i < wxMhz.length; i++) wx.fm("NOAA WX" + (i + 1), wxMhz[i], false, true);
        out.add(wx);

        Preset murs = new Preset("MURS", "US", "Multi-Use Radio Service: five licence-free VHF channels, less crowded than FRS and reaching further outdoors. Low power (the limit is 2 W).", "No licence needed");
        murs.fm("MURS 1", 151.820, false, true).fm("MURS 2", 151.880, false, true).fm("MURS 3", 151.940, false, true).fm("MURS 4 Blue", 154.570, false, true).fm("MURS 5 Green", 154.600, false, true);
        out.add(murs);

        Preset marine = new Preset("Marine VHF", "US / international", "Marine VHF channels to listen to boats, harbours and the Coast Guard: 16 is distress and calling, 9 boater calling, 13 bridge to bridge, 22A the US Coast Guard. Receive-only: this radio is not a marine radio.", "Receive-only");
        marine.fm("Marine 16", 156.800, false, true).fm("Marine 9", 156.450, false, true).fm("Marine 13", 156.650, false, true).fm("Marine 22A", 157.100, false, true)
              .fm("Marine 6", 156.300, false, true).fm("Marine 68", 156.425, false, true).fm("Marine 69", 156.475, false, true).fm("Marine 71", 156.575, false, true)
              .fm("Marine 72", 156.625, false, true).fm("Marine 78A", 156.925, false, true);
        out.add(marine);

        Preset ham = new Preset("Ham simplex", "US", "Amateur FM simplex: the 2 m and 70 cm national calling channels, common simplex channels and APRS (144.390, where the radio decodes position reports).", "Amateur licence needed");
        ham.fm("2m Call", 146.520, true, true);
        for (double f : new double[] { 146.550, 146.580, 147.420, 147.450, 147.480, 147.510, 147.540, 147.570 }) ham.fm(String.format(Locale.US, "2m %.3f", f), f, true, true);
        ham.fm("APRS", 144.390, true, true);
        ham.fm("70cm Call", 446.000, true, true);
        for (double f : new double[] { 445.950, 446.050, 446.100, 446.150 }) ham.fm(String.format(Locale.US, "70cm %.3f", f), f, true, true);
        out.add(ham);

        Preset dmr = new Preset("DMR simplex", "Worldwide", "Amateur DMR simplex: the channels most DMR radios carry, all colour code 1, time slot 1, talkgroup 99.", "Amateur licence needed");
        for (double f : new double[] { 441.000, 446.500, 446.075, 433.450, 145.790, 145.510 }) dmr.channels.add(new Ch(String.format(Locale.US, "DMR S %.3f", f), f, f, true, true, true, false));
        out.add(dmr);

        Preset biz = new Preset("Business", "US", "Business itinerant channels: the \"dot\" and \"star\" frequencies that rental and store business radios come set to, used at events, shops, farms and job sites. Listening is free. On VHF this radio only works wide band, which these channels no longer allow for transmitting: talk on the UHF ones.", "FCC business (Part 90) licence needed");
        biz.fm("Red Dot", 151.625, true, true).fm("Purple Dot", 151.955, true, true).fm("Biz 151.700", 151.700, true, true).fm("Biz 151.760", 151.760, true, true)
           .fm("Brown Dot", 464.500, true, false).fm("Yellow Dot", 464.550, true, false).fm("Biz 469.500", 469.500, true, false).fm("Biz 469.550", 469.550, true, false)
           .fm("Silver Star", 467.850, true, false).fm("Gold Star", 467.875, true, false).fm("Red Star", 467.900, true, false).fm("Blue Star", 467.925, true, false);
        out.add(biz);

        Preset rail = new Preset("Railroad", "US / Canada", "The 96 AAR railroad channels (02 to 97, 159.810 to 161.565 MHz; 02 to 04 are used in Canada): dispatchers, trains, yards and the trackside defect detectors that read out axle counts. Receive-only. Scan the zone to find your local railroad's channels, then star them.", "Receive-only");
        rail.fm("AAR 02", 159.810, false, true).fm("AAR 03", 159.930, false, true).fm("AAR 04", 160.050, false, true);
        for (int n = 5; n <= 97; n++) rail.fm(String.format(Locale.US, "AAR %02d", n), 160.185 + (n - 5) * 0.015, false, true);
        out.add(rail);

        Preset sat = new Preset("ISS and satellites", "Worldwide", "The International Space Station and the SO-50 FM satellite, each heard for about ten minutes per pass (an app such as Heavens-Above gives the times). ISS Voice: crew contacts on 145.800 (the crew listens on 144.490 in the Americas). ISS APRS: the station's packet digipeater, on 437.825 since 2026 (it has used 145.825 before). ISS SSTV: picture events on 437.550 (receive only). On 70 cm the signal shifts up to 10 kHz with Doppler, so the APRS and SSTV channels come as + (rising), plain (overhead) and - (setting); PKT \u2192 ISS APRS and ISS SSTV follow the shift automatically and are the better way. ISS Rptr and SO-50 listen on 2 m and send on 70 cm, opened with a 67 Hz tone; use the + channel as the pass begins, the plain one overhead and the - one as it ends. ARISS changes the station's modes often: check ariss.org. Talking through a satellite with a handheld is hard: listen first. Cross-band (2 m transmit, 70 cm receive) is untested on this radio.", "Amateur licence needed to transmit");
        sat.split("ISS Voice", 145.800, 144.490, true, true, 0)
           .split("ISS APRS +", 437.835, 437.815, true, true, 0).fm("ISS APRS", 437.825, true, true).split("ISS APRS -", 437.815, 437.835, true, true, 0)
           .split("ISS SSTV +", 437.560, 437.560, true, true, 0).split("ISS SSTV", 437.550, 437.550, true, true, 0).split("ISS SSTV -", 437.540, 437.540, true, true, 0)
           .split("ISS Rptr +", 437.810, 145.990, true, true, 67.0).split("ISS Rptr", 437.800, 145.990, true, true, 67.0).split("ISS Rptr -", 437.790, 145.990, true, true, 67.0)
           .split("SO-50 +", 436.805, 145.850, true, true, 67.0).split("SO-50", 436.795, 145.850, true, true, 67.0).split("SO-50 -", 436.785, 145.850, true, true, 67.0);
        out.add(sat);

        Preset cb = new Preset("UHF CB", "Australia / NZ", "The 80-channel UHF CB band (476.425 to 477.4125 MHz, narrow band, 5 W). The R channels use the repeaters: they listen on 1 to 8 and 41 to 48 and transmit 750 kHz higher (on 31 to 38 and 71 to 78, which are left out as simplex channels). Channel 5 is the emergency channel (not in New Zealand), 40 the highway channel, 18 caravans and convoys, 10 four-wheel-drive clubs, 11 calling. 22 and 23 (data only) and 61 to 63 (reserved) are left out.", "No licence needed in Australia and NZ; not for use in the US");
        for (int n = 1; n <= 80; n++) {
            boolean output = n <= 8 || (n >= 41 && n <= 48), input = (n >= 31 && n <= 38) || (n >= 71 && n <= 78);
            if (n == 22 || n == 23 || (n >= 61 && n <= 63) || input) continue;
            double f = n <= 40 ? 476.425 + (n - 1) * 0.025 : 476.4375 + (n - 41) * 0.025;
            String tag = n == 5 ? " Emerg" : n == 40 ? " Road" : n == 18 ? " Caravan" : n == 10 ? " 4WD" : n == 11 ? " Call" : "";
            if (output) cb.channels.add(new Ch(String.format(Locale.US, "CB %dR%s", n, tag), f, f + 0.750, false, true, false, true));
            else cb.fm(String.format(Locale.US, "CB %d%s", n, tag), f, true, false);
        }
        out.add(cb);

        Preset pmr = new Preset("PMR446", "Europe / UK", "PMR446, the licence-free walkie-talkie channels of Europe and the UK: 16 narrow-band channels. Low power (the limit is 0.5 W).", "No licence needed in Europe; not for use in the US");
        for (int n = 1; n <= 16; n++) pmr.fm(String.format(Locale.US, "PMR %d", n), 446.00625 + (n - 1) * 0.0125, false, false);
        out.add(pmr);
        return out;
    }

    /** FRS/GMRS channel n (1..22) in MHz. */
    private static double frsMhz(int n) {
        if (n <= 7) return 462.5625 + (n - 1) * 0.025;
        if (n <= 14) return 467.5625 + (n - 8) * 0.025;
        return 462.5500 + (n - 15) * 0.025;
    }

    /** The radio's CTCSS sub-code for a tone in Hz, or -1. */
    public static int ctcssIndex(double hzTone) {
        for (int i = 0; i < ToneConverter.ctcssCount(); i++) if (Math.abs(ToneConverter.ctcssHz(i) - hzTone) < 0.05) return i;
        return -1;
    }

    public static final class Result { public long zoneId; public int added, reused; public String summary; }

    /**
     * Add the list's channels and its zone. {@code repeaterTone}: CTCSS sub-code for the repeater channels (sent and
     * received), or -1 for none. A channel already present (same frequencies, mode and tones) is reused, not duplicated.
     */
    public static Result install(ChannelStore store, Preset p, int repeaterTone) {
        Result r = new Result();
        ChannelStore.Zone zone = null; for (ChannelStore.Zone z : store.zones()) if (z.name.equals(p.zone)) zone = z;
        if (zone == null) { zone = new ChannelStore.Zone(); zone.name = p.zone; zone.numbers = new int[0]; }
        List<Integer> nums = new ArrayList<>(); for (int n : zone.numbers) nums.add(n);
        if (p.channels.stream().anyMatch(c -> c.digital)) ensureSimplexContact(store);
        for (Ch c : p.channels) {
            ChannelStore.Channel ch = build(c, repeaterTone);
            ChannelStore.Channel have = find(store, ch);
            if (have != null) { r.reused++; if (!nums.contains(have.number)) nums.add(have.number); continue; }
            store.insert(ch); r.added++; nums.add(ch.number);
        }
        zone.numbers = new int[nums.size()]; for (int i = 0; i < nums.size(); i++) zone.numbers[i] = nums.get(i);
        r.zoneId = store.saveZone(zone);
        r.summary = r.added + " channel" + (r.added == 1 ? "" : "s") + " added" + (r.reused > 0 ? ", " + r.reused + " you already had" : "") + " · zone " + p.zone;
        return r;
    }

    static ChannelStore.Channel build(Ch c, int repeaterTone) {
        ChannelStore.Channel ch = new ChannelStore.Channel();
        ch.name = c.name; ch.rxFreq = c.rx; ch.txFreq = c.tx; ch.power = c.high ? 1 : 0; ch.relay = 2; ch.sq = 2; ch.encryptSw = 2;
        ch.band = c.rx < 300_000_000 || c.wide ? 1 : 0;   // VHF must be wide on this radio
        if (c.digital) {
            ch.type = 0; ch.cc = 1; ch.inSlot = ch.outSlot = 0; ch.mode = 0; ch.contactType = 1; ch.txContact = DMR_SIMPLEX_TG; ch.groups = new int[] { DMR_SIMPLEX_TG }; ch.interrupt = 2;
        } else {
            ch.type = 1; ch.contactType = 0; ch.interrupt = 0;
            if (c.repeater && repeaterTone >= 0) { ch.rxType = ch.txType = 1; ch.rxSubCode = ch.txSubCode = repeaterTone; }
            int t = c.txTone > 0 ? ctcssIndex(c.txTone) : -1;
            if (t >= 0) { ch.txType = 1; ch.txSubCode = t; }
        }
        return ch;
    }

    private static ChannelStore.Channel find(ChannelStore store, ChannelStore.Channel w) {
        for (ChannelStore.Channel h : store.all()) {
            if (h.type != w.type || h.rxFreq != w.rxFreq || h.txFreq != w.txFreq) continue;
            if (w.isDigital()) { if (h.cc == w.cc && h.inSlot == w.inSlot && h.txContact == w.txContact) return h; }
            else if (h.rxType == w.rxType && h.txType == w.txType && (w.rxType == 0 || h.rxSubCode == w.rxSubCode) && (w.txType == 0 || h.txSubCode == w.txSubCode)) return h;
        }
        return null;
    }

    private static void ensureSimplexContact(ChannelStore store) {
        for (ChannelStore.Contact c : store.contacts()) if (c.number == DMR_SIMPLEX_TG && c.type == 1) return;
        ChannelStore.Contact c = new ChannelStore.Contact(); c.name = "Simplex"; c.number = DMR_SIMPLEX_TG; c.type = 1; store.insertContact(c);
    }

    /** One line per channel for the preview: name, frequency (and repeater input), power. */
    public static String preview(Preset p) {
        StringBuilder sb = new StringBuilder();
        for (Ch c : p.channels) {
            sb.append(String.format(Locale.US, "%-13s %9.4f", c.name, c.rx / 1e6));
            if (c.tx != c.rx) sb.append(String.format(Locale.US, " TX %.4f", c.tx / 1e6));
            if (c.txTone > 0) sb.append(String.format(Locale.US, " %.1f", c.txTone));
            sb.append(ChannelStore.receiveOnly(c.tx) ? "  RX only" : c.digital ? "  DMR" : c.high ? "" : "  low").append('\n');
        }
        return sb.toString().trim();
    }
}
