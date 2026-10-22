/*
 * SignalDeck - Copyright (C) 2026 IIMacGyverII
 * SPDX-License-Identifier: GPL-3.0-or-later
 * Free software under the GNU General Public License v3 or later, with the additional terms in COPYRIGHT
 * (keep this notice and the author credit, mark modified versions, no rights to the SignalDeck name or icon).
 */
package com.macdmr.radio.ham;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Collections;
import java.util.HashMap;
import java.util.HashSet;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.Set;
import java.util.TimeZone;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

/**
 * Finding nets: the pure part (no Android), host-tested.
 *
 * Two sources. NetLogger's public XML service lists the nets in session on its servers and the last week's nets
 * (name, frequency as typed by net control, mode, band, net control, open/close time, followers); a net is "yours"
 * when its frequency (or DMR talkgroup) matches one of your channels or a repeater in your Nearby repeaters range,
 * since NetLogger has no locations. And the radio's own history: a long run of receptions from several stations on
 * one channel is a net or a group hanging out, and the same weekday and time on several weeks is a schedule.
 */
public final class NetFinder {
    private NetFinder() { }

    // ---- NetLogger ----

    /** One net from GetActiveNets / GetPastNets. Times in UTC milliseconds (0 = unknown). */
    public static final class Net {
        public String server = "", name = "", apiName = "", freqText = "", mode = "", band = "", netControl = "", logger = "";
        public long opened, closed, netId; public int followers;
        public long freqHz; public int talkgroup;           // parsed: a radio frequency in this radio's range, or a DMR talkgroup
    }

    private static final Pattern SERVER = Pattern.compile("<Server>(.*?)</Server>", Pattern.DOTALL);
    private static final Pattern NET = Pattern.compile("<Net>(.*?)</Net>", Pattern.DOTALL);
    private static final Pattern CHECKIN = Pattern.compile("<Checkin>(.*?)</Checkin>", Pattern.DOTALL);

    static String tag(String xml, String t) {
        Matcher m = Pattern.compile("<\\s*" + t + "\\s*>(.*?)</" + t + ">", Pattern.DOTALL).matcher(xml);
        return m.find() ? unescape(m.group(1).trim()) : "";
    }
    static String unescape(String s) { return s.replace("&lt;", "<").replace("&gt;", ">").replace("&quot;", "\"").replace("&apos;", "'").replace("&#039;", "'").replace("&amp;", "&"); }

    private static long utc(String s) {
        if (s == null || s.isEmpty()) return 0;
        try { SimpleDateFormat f = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss", Locale.US); f.setTimeZone(TimeZone.getTimeZone("UTC")); return f.parse(s).getTime(); }
        catch (ParseException e) { return 0; }
    }

    /** The nets in a ServerList response (fields NetLogger may add later are ignored). */
    public static List<Net> parseNets(String xml) {
        List<Net> out = new ArrayList<>();
        if (xml == null) return out;
        Matcher sm = SERVER.matcher(xml);
        while (sm.find()) {
            String server = tag(sm.group(1), "ServerName");
            Matcher nm = NET.matcher(sm.group(1));
            while (nm.find()) {
                String b = nm.group(1); Net n = new Net();
                n.server = server;
                n.apiName = tag(b, "NetName"); String alt = tag(b, "AltNetName"); n.name = !alt.isEmpty() ? alt : n.apiName;      // GetCheckins wants the original name
                n.freqText = tag(b, "Frequency"); n.mode = tag(b, "Mode"); n.band = tag(b, "Band"); n.netControl = tag(b, "NetControl"); n.logger = tag(b, "Logger");
                n.opened = utc(tag(b, "Date")); n.closed = utc(tag(b, "ClosedAt"));
                try { n.followers = Integer.parseInt(tag(b, "SubscriberCount")); } catch (NumberFormatException ignored) { }
                try { n.netId = Long.parseLong(tag(b, "NetID")); } catch (NumberFormatException ignored) { }
                n.freqHz = parseFreqHz(n.freqText);
                if (n.freqHz == 0 && dmrish(n)) n.talkgroup = parseTalkgroup(n.freqText);
                out.add(n);
            }
        }
        return out;
    }

    private static boolean dmrish(Net n) { String s = (n.mode + " " + n.band + " " + n.freqText).toUpperCase(Locale.US); return s.contains("DMR") || s.contains("TG"); }
    private static final Pattern FREQ = Pattern.compile("(\\d{2,4})\\.(\\d+)(?:\\.(\\d+))?");

    /** "146.730", "146.73", "145.190.000", "444.0000", "147.105+ PL 100" → Hz, only inside 136–174 / 400–480 MHz; otherwise 0. */
    public static long parseFreqHz(String s) {
        if (s == null) return 0;
        Matcher m = FREQ.matcher(s);
        while (m.find()) {
            String frac = m.group(2) + (m.group(3) == null ? "" : m.group(3));
            if (frac.length() > 6) frac = frac.substring(0, 6);
            while (frac.length() < 6) frac += "0";
            long hz = Long.parseLong(m.group(1)) * 1_000_000L + Long.parseLong(frac);
            if (inRange(hz)) return hz;
        }
        return 0;
    }
    public static boolean inRange(long hz) { return (hz >= 136_000_000L && hz <= 174_000_000L) || (hz >= 400_000_000L && hz <= 480_000_000L); }

    /** "3148", "DMR 3141", "TG 31665", "D 98006 Y11689" → the first whole number (talkgroups are 1–7 digits). */
    public static int parseTalkgroup(String s) {
        if (s == null) return 0;
        Matcher m = Pattern.compile("(?<![\\d.])(\\d{1,7})(?![\\d.])").matcher(s);
        if (!m.find()) return 0;
        try { int v = Integer.parseInt(m.group(1)); return v > 0 ? v : 0; } catch (NumberFormatException e) { return 0; }
    }

    /** A check-in: only what is shown. NetLogger also returns street addresses; they are never read. */
    public static final class Checkin { public int serial; public String call = "", name = "", state = "", status = ""; }
    public static List<Checkin> parseCheckins(String xml) {
        List<Checkin> out = new ArrayList<>();
        if (xml == null) return out;
        Matcher m = CHECKIN.matcher(xml);
        while (m.find()) {
            String b = m.group(1); Checkin c = new Checkin();
            try { c.serial = Integer.parseInt(tag(b, "SerialNo")); } catch (NumberFormatException ignored) { }
            c.call = tag(b, "Callsign"); String pn = tag(b, "PreferredName"); c.name = !pn.isEmpty() ? pn : tag(b, "FirstName");
            c.state = tag(b, "State"); c.status = tag(b, "Status");
            if (!c.call.isEmpty()) out.add(c);
        }
        return out;
    }
    /** The station working now (GetCheckins' Pointer = its SerialNo), 0 if none. */
    public static int pointer(String xml) { try { return Integer.parseInt(tag(xml == null ? "" : xml, "Pointer")); } catch (NumberFormatException e) { return 0; } }

    // ---- where a net is: your channels and nearby repeaters ----

    /** A channel or a nearby repeater a net can be matched to. */
    public static final class Place {
        public String label = ""; public long rxHz, txHz; public Set<Integer> talkgroups = new HashSet<>();
        public int channel;          // your channel number, 0 for a repeater that is not one of your channels
        public double km = -1;       // distance to a repeater, -1 = unknown
        public Object data;          // the channel or the repeater
    }
    static final long TOLERANCE_HZ = 2_500;

    /** Your channel first (the frequency it receives on, then its transmit frequency), then the nearest repeater. */
    public static Place match(Net n, List<Place> places) {
        Place best = null; int bestRank = 9;
        for (Place p : places) {
            int rank = 9;
            if (n.freqHz > 0) {
                if (Math.abs(p.rxHz - n.freqHz) <= TOLERANCE_HZ) rank = p.channel > 0 ? 0 : 2;
                else if (p.txHz != p.rxHz && Math.abs(p.txHz - n.freqHz) <= TOLERANCE_HZ) rank = p.channel > 0 ? 1 : 3;
            } else if (n.talkgroup > 0 && p.talkgroups.contains(n.talkgroup)) rank = p.channel > 0 ? 0 : 4;
            if (rank < bestRank || (rank == bestRank && best != null && p.km >= 0 && (best.km < 0 || p.km < best.km))) { best = p; bestRank = rank; }
        }
        return bestRank < 9 ? best : null;
    }

    /** "146.730 MHz", "TG 3148", or what net control typed. */
    public static String where(Net n) {
        if (n.freqHz > 0) return String.format(Locale.US, "%.3f MHz", n.freqHz / 1e6);
        if (n.talkgroup > 0) return "TG " + n.talkgroup;
        return n.freqText.isEmpty() ? n.band : n.freqText;
    }

    // ---- where on the map: NetLogger has no locations, a frequency is shared by many towns ----

    private static final String[][] STATES = {
        {"West Virginia","WV"},{"North Carolina","NC"},{"South Carolina","SC"},{"North Dakota","ND"},{"South Dakota","SD"},{"New Hampshire","NH"},{"New Jersey","NJ"},{"New Mexico","NM"},{"New York","NY"},{"Rhode Island","RI"},
        {"Alabama","AL"},{"Alaska","AK"},{"Arizona","AZ"},{"Arkansas","AR"},{"California","CA"},{"Colorado","CO"},{"Connecticut","CT"},{"Delaware","DE"},{"Florida","FL"},{"Georgia","GA"},{"Hawaii","HI"},{"Idaho","ID"},{"Illinois","IL"},{"Indiana","IN"},{"Iowa","IA"},{"Kansas","KS"},{"Kentucky","KY"},{"Louisiana","LA"},{"Maine","ME"},{"Maryland","MD"},{"Massachusetts","MA"},{"Michigan","MI"},{"Minnesota","MN"},{"Mississippi","MS"},{"Missouri","MO"},{"Montana","MT"},{"Nebraska","NE"},{"Nevada","NV"},{"Ohio","OH"},{"Oklahoma","OK"},{"Oregon","OR"},{"Pennsylvania","PA"},{"Tennessee","TN"},{"Texas","TX"},{"Utah","UT"},{"Vermont","VT"},{"Virginia","VA"},{"Washington","WA"},{"Wisconsin","WI"},{"Wyoming","WY"}};
    /** US call districts (the digit in a US callsign; where a station was first licensed, still a good regional hint). */
    private static final String[] DISTRICTS = { "CO IA KS MN MO NE ND SD", "CT ME MA NH RI VT", "NJ NY", "DE DC MD PA", "AL FL GA KY NC SC TN VA", "AR LA MS NM OK TX", "CA", "AZ ID MT NV OR UT WA WY", "MI OH WV", "IL IN WI" };
    private static final Set<String> AMBIGUOUS = new HashSet<>(java.util.Arrays.asList("IN", "ME", "OR", "HI", "OK", "OH", "AL", "LA", "MA", "CO", "DE", "PA", "ID", "MD"));

    /** A full state name ("North Texas ARES" → TX) or an unambiguous capitalised code ("NTX"/"TX ARES" → TX) in a net's name. */
    public static String stateIn(String text) {
        if (text == null) return null;
        String low = " " + text.toLowerCase(Locale.US).replaceAll("[^a-z]+", " ") + " ";
        for (String[] st : STATES) {
            String nm = " " + st[0].toLowerCase(Locale.US) + " ";
            if (st[1].equals("VA") && low.contains(" west virginia ")) continue;
            if (st[1].equals("WA") && low.contains(" washington dc ")) continue;
            if (low.contains(nm)) return st[1];
        }
        Matcher m = Pattern.compile("(?<![A-Za-z])([A-Z]{2})(?![A-Za-z])").matcher(text);
        while (m.find()) { String code = m.group(1); if (AMBIGUOUS.contains(code)) continue; for (String[] st : STATES) if (st[1].equals(code)) return code; }
        return null;
    }
    public static String stateCode(String name) { if (name == null) return null; for (String[] st : STATES) if (st[0].equalsIgnoreCase(name.trim()) || st[1].equalsIgnoreCase(name.trim())) return st[1]; return null; }
    public static int districtOf(String state) { if (state == null) return -1; for (int i = 0; i < DISTRICTS.length; i++) for (String x : DISTRICTS[i].split(" ")) if (x.equals(state)) return i; return -1; }
    /** The district digit of a US callsign (K5ABC, WA5XYZ, AE5Q, N5XX/R), or -1. Alaska/Hawaii prefixes and other countries: -1. */
    public static int callDistrict(String call) {
        if (call == null) return -1;
        Matcher m = Pattern.compile("^(?:[KNW][A-Z]?|A[A-K])(\\d)[A-Z]{1,3}\\b").matcher(call.trim().toUpperCase(Locale.US));
        if (!m.find()) return -1;
        String c = call.trim().toUpperCase(Locale.US);
        if (c.matches("^(?:[KNW]L|A[LH]|[KNW]H|[KNW]P)\\d.*")) return -1;
        return m.group(1).charAt(0) - '0';
    }
    /**
     * Is a net matched by frequency likely near you? 1 yes, 0 can't tell, -1 probably elsewhere. A DMR talkgroup is the
     * same everywhere (1). Otherwise the state in the net's name, then the state the logging station gives in NetLogger
     * ("N0CALL-JOE - CO - v3.1"); failing both, the call district of net control (or the logger) against yours
     * ({@code myDistrict}, from your state or the nearby repeaters' callsigns). A district spans several states, so
     * the same district only means "can't tell", a different one (or a foreign callsign) "probably elsewhere".
     */
    public static int locality(Net n, String myState, int myDistrict) {
        if (n.freqHz == 0 && n.talkgroup > 0) return 1;
        for (String st : new String[] { stateIn(n.name), loggerState(n.logger) }) {
            if (st == null) continue;
            if (myState != null) return st.equals(myState) ? 1 : -1;
            if (myDistrict >= 0) return districtOf(st) == myDistrict ? 0 : -1;
        }
        String call = !n.netControl.trim().isEmpty() ? n.netControl.trim() : loggerCall(n.logger);
        if (call.isEmpty() || (myState == null && myDistrict < 0)) return 0;
        int d = callDistrict(call);
        if (d >= 0) return myDistrict >= 0 && d != myDistrict ? -1 : 0;
        return usCall(call) ? 0 : -1;                              // Alaska/Hawaii: can't tell; another country: elsewhere
    }
    /** "N0CALL-JOE - CO - v3.1.7W" → CO (only a real state code). */
    public static String loggerState(String logger) {
        if (logger == null) return null;
        Matcher m = Pattern.compile("\\s-\\s([A-Z]{2})\\s-\\s").matcher(logger);
        if (!m.find()) return null;
        for (String[] st : STATES) if (st[1].equals(m.group(1))) return st[1];
        return null;
    }
    /** "N0CALL-JOE - CO - v3" → N0CALL. */
    public static String loggerCall(String logger) {
        if (logger == null) return "";
        Matcher m = Pattern.compile("^\\s*([A-Za-z0-9]{3,8})").matcher(logger);
        return m.find() ? m.group(1).toUpperCase(Locale.US) : "";
    }
    static boolean usCall(String call) { return call.toUpperCase(Locale.US).matches("^(?:[KNW][A-Z]?|A[A-L])\\d[A-Z]{1,3}.*"); }

    // ---- schedules ----

    /** A net that comes back: weekly on {@link #dow} (Calendar.SUNDAY…SATURDAY), or daily when dow is 0. Minutes are local. */
    public static final class Slot {
        public String name = "", source = "", netControl = "", logger = ""; public int near; public int dow, minute, durationMin = 60, seen, stations;
        public long freqHz, manualId; public int talkgroup, channel; public Place place; public String notes = "";
        public String key() { return source + "|" + name.toLowerCase(Locale.US) + "|" + dow + "|" + minute + "|" + channel + "|" + freqHz + "|" + talkgroup; }
    }

    private static int median(List<Integer> v) { List<Integer> s = new ArrayList<>(v); Collections.sort(s); return s.isEmpty() ? 0 : s.get(s.size() / 2); }
    private static String norm(String s) { return s.toLowerCase(Locale.US).replaceAll("[^a-z0-9]+", " ").trim(); }

    /** Weekly (or daily) times from the last week's NetLogger nets: same name and frequency, grouped by weekday. */
    public static List<Slot> scheduleFromPast(List<Net> past, TimeZone tz) {
        Map<String, List<Net>> groups = new LinkedHashMap<>();
        for (Net n : past) {
            if (n.opened == 0 || (n.freqHz == 0 && n.talkgroup == 0)) continue;
            String k = norm(n.name) + "|" + (n.freqHz > 0 ? n.freqHz / 5000 : -n.talkgroup);
            List<Net> g = groups.get(k); if (g == null) { g = new ArrayList<>(); groups.put(k, g); } g.add(n);
        }
        List<Slot> out = new ArrayList<>();
        Calendar cal = Calendar.getInstance(tz, Locale.US);
        for (List<Net> g : groups.values()) {
            Map<Integer, List<Integer>> byDow = new HashMap<>(); List<Integer> all = new ArrayList<>(), dur = new ArrayList<>();
            for (Net n : g) {
                cal.setTimeInMillis(n.opened); int dow = cal.get(Calendar.DAY_OF_WEEK), min = cal.get(Calendar.HOUR_OF_DAY) * 60 + cal.get(Calendar.MINUTE);
                List<Integer> l = byDow.get(dow); if (l == null) { l = new ArrayList<>(); byDow.put(dow, l); } l.add(min); all.add(min);
                if (n.closed > n.opened) dur.add((int) Math.min(240, (n.closed - n.opened) / 60000));
            }
            Net first = g.get(0);
            if (byDow.size() >= 4) out.add(slot(first, 0, median(all), dur, g.size()));
            else for (Map.Entry<Integer, List<Integer>> e : byDow.entrySet()) out.add(slot(first, e.getKey(), median(e.getValue()), dur, e.getValue().size()));
        }
        return out;
    }
    private static Slot slot(Net n, int dow, int minute, List<Integer> dur, int seen) {
        Slot s = new Slot(); s.name = n.name; s.netControl = n.netControl; s.logger = n.logger; s.source = "NetLogger"; s.dow = dow; s.minute = minute; s.seen = seen;
        s.freqHz = n.freqHz; s.talkgroup = n.talkgroup; s.durationMin = dur.isEmpty() ? 60 : Math.max(10, median(dur));
        return s;
    }

    // ---- nets you added to a channel ----

    /** A net the owner added: on {@link #channel}, on the weekdays in {@link #days} (bit 1 << Calendar.SUNDAY…SATURDAY). */
    public static final class Manual {
        public long id, channelId; public String name = "", notes = ""; public int channel, days, minute, durationMin = 60;   // channel: its number now; channelId: the row it belongs to
        public boolean on(int dow) { return (days & (1 << dow)) != 0; }
    }
    public static final int ALL_DAYS = 0xFE;   // bits 1..7

    /** One slot per weekday (daily when every day is ticked), marked as yours and near. */
    public static List<Slot> manualSlots(List<Manual> l) {
        List<Slot> out = new ArrayList<>();
        for (Manual m : l) {
            if (m.days == 0) continue;
            List<Integer> dows = new ArrayList<>();
            if ((m.days & ALL_DAYS) == ALL_DAYS) dows.add(0); else for (int d = Calendar.SUNDAY; d <= Calendar.SATURDAY; d++) if (m.on(d)) dows.add(d);
            for (int d : dows) {
                Slot s = new Slot(); s.name = m.name; s.channel = m.channel; s.dow = d; s.minute = m.minute; s.durationMin = Math.max(5, m.durationMin);
                s.source = "added by you"; s.near = 1; s.manualId = m.id; s.notes = m.notes;
                out.add(s);
            }
        }
        return out;
    }
    /** Does {@code o} describe the same net as {@code s} (same channel, a shared day, start within 45 minutes)? */
    public static boolean sameNet(Slot s, Slot o) {
        return s.channel > 0 && s.channel == o.channel && (s.dow == o.dow || s.dow == 0 || o.dow == 0) && Math.abs(s.minute - o.minute) <= SAME_TIME_MIN;
    }

    private static String esc(String s) { return s == null ? "" : s.replace("%", "%25").replace("|", "%7C").replace("\n", "%0A"); }
    private static String unesc(String s) { return s.replace("%0A", "\n").replace("%7C", "|").replace("%25", "%"); }
    /** One line per net: id|channel|days|minute|duration|name|notes. */
    public static String encode(List<Manual> l) {
        StringBuilder b = new StringBuilder();
        for (Manual m : l) b.append(m.id).append('|').append(m.channel).append('|').append(m.days).append('|').append(m.minute).append('|').append(m.durationMin).append('|').append(esc(m.name)).append('|').append(esc(m.notes)).append('\n');
        return b.toString();
    }
    public static List<Manual> decode(String s) {
        List<Manual> out = new ArrayList<>();
        if (s == null) return out;
        for (String line : s.split("\n")) {
            String[] f = line.split("\\|", -1);
            if (f.length < 7) continue;
            try {
                Manual m = new Manual(); m.id = Long.parseLong(f[0]); m.channel = Integer.parseInt(f[1]); m.days = Integer.parseInt(f[2]); m.minute = Integer.parseInt(f[3]); m.durationMin = Integer.parseInt(f[4]);
                m.name = unesc(f[5]); m.notes = unesc(f[6]); out.add(m);
            } catch (NumberFormatException ignored) { }
        }
        return out;
    }
    private static final String[] SHORT = { "", "Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat" };
    /** "Mon, Wed, Fri 7:30 PM" / "Daily 8:00 AM". */
    public static String when(Manual m) {
        int h = m.minute / 60, mi = m.minute % 60; String t = String.format(Locale.US, " %d:%02d %s", h % 12 == 0 ? 12 : h % 12, mi, h < 12 ? "AM" : "PM");
        if ((m.days & ALL_DAYS) == ALL_DAYS) return "Daily" + t;
        StringBuilder b = new StringBuilder();
        for (int d = Calendar.SUNDAY; d <= Calendar.SATURDAY; d++) if (m.on(d)) { if (b.length() > 0) b.append(", "); b.append(SHORT[d]); }
        return (b.length() == 0 ? "No day" : b.toString()) + t;
    }

    // ---- learned from what the radio heard ----

    /** A history line: kind rx (analog reception), dmr (voice from an ID), txt (a caption). */
    public static final class Rx {
        public long ts; public int channel, dmrId; public String kind = "", text = "";
        public Rx(long ts, int channel, String kind, String text, int dmrId) { this.ts = ts; this.channel = channel; this.kind = kind == null ? "" : kind; this.text = text == null ? "" : text; this.dmrId = dmrId; }
    }
    /** A stretch of activity on one channel. */
    public static final class Session { public int channel, receptions, stations; public long start, end; public String name = ""; public int minutes() { return (int) ((end - start) / 60000); } }

    static final long GAP_MS = 6 * 60_000L;
    static final int NET_MINUTES = 20, NET_RECEPTIONS = 12, NET_STATIONS = 3;
    static final int LIVE_MINUTES = 15, LIVE_RECEPTIONS = 10;

    /** Activity broken into sessions per channel (a gap of more than 6 minutes ends one), oldest first. */
    public static List<Session> sessions(List<Rx> rows) {
        Map<Integer, List<Rx>> by = new HashMap<>();
        for (Rx r : rows) { List<Rx> l = by.get(r.channel); if (l == null) { l = new ArrayList<>(); by.put(r.channel, l); } l.add(r); }
        List<Session> out = new ArrayList<>();
        for (List<Rx> l : by.values()) {
            l.sort((a, b) -> Long.compare(a.ts, b.ts));
            Session cur = null; Set<Integer> ids = new HashSet<>(); List<String> caps = new ArrayList<>();
            for (Rx r : l) {
                boolean voice = "rx".equals(r.kind) || "dmr".equals(r.kind);
                if (cur != null && voice && r.ts - cur.end > GAP_MS) { close(cur, ids, caps, out); cur = null; }
                if (!voice) { if (cur != null && "txt".equals(r.kind) && r.ts - cur.end <= GAP_MS) caps.add(r.text); continue; }
                if (cur == null) { cur = new Session(); cur.channel = r.channel; cur.start = r.ts; ids.clear(); caps.clear(); }
                cur.end = r.ts; cur.receptions++;
                if ("dmr".equals(r.kind) && r.dmrId > 0) ids.add(r.dmrId);
            }
            if (cur != null) close(cur, ids, caps, out);
        }
        out.sort((a, b) -> Long.compare(a.start, b.start));
        return out;
    }
    private static void close(Session s, Set<Integer> ids, List<String> caps, List<Session> out) { s.stations = ids.size(); s.name = netName(caps); out.add(s); }

    /** Long enough, busy enough, and (when the callers are known, on DMR) several stations: a net or a group hanging out. */
    public static boolean netLike(Session s) { return s.minutes() >= NET_MINUTES && s.receptions >= NET_RECEPTIONS && (s.stations == 0 || s.stations >= NET_STATIONS); }

    private static final Pattern NAMED = Pattern.compile("(?:this is|welcome to|welcome to the|calling)\\s+(?:the\\s+)?((?:[a-z0-9']+\\s+){0,5}?net)\\b");
    /** "this is the tuesday night tech net" in the captions → "Tuesday Night Tech Net". */
    public static String netName(List<String> captions) {
        for (String c : captions) {
            Matcher m = NAMED.matcher(c.toLowerCase(Locale.US));
            if (m.find()) {
                StringBuilder b = new StringBuilder();
                for (String w : m.group(1).trim().split("\\s+")) { if (w.isEmpty()) continue; if (b.length() > 0) b.append(' '); b.append(Character.toUpperCase(w.charAt(0))).append(w.substring(1)); }
                if (b.length() > 4) return b.toString();
            }
        }
        return "";
    }

    /** A net-like session going on now: the last reception within 6 minutes, at least 15 minutes and 10 receptions so far. */
    public static Session live(List<Rx> rows, long now) {
        Session best = null;
        for (Session s : sessions(rows)) {
            if (now - s.end > GAP_MS || s.end > now + 60_000) continue;
            if (s.minutes() < LIVE_MINUTES || s.receptions < LIVE_RECEPTIONS || (s.stations > 0 && s.stations < NET_STATIONS)) continue;
            if (best == null || s.receptions > best.receptions) best = s;
        }
        return best;
    }

    static final int SAME_TIME_MIN = 45;

    /** Recurring net-like sessions: the same channel and time of day on 3+ different days (daily), or on the same weekday in 2+ weeks. */
    public static List<Slot> learned(List<Session> all, TimeZone tz) {
        List<Session> nets = new ArrayList<>(); for (Session s : all) if (netLike(s)) nets.add(s);
        Calendar cal = Calendar.getInstance(tz, Locale.US);
        int n = nets.size(); int[] dow = new int[n], min = new int[n]; long[] day = new long[n];
        for (int i = 0; i < n; i++) {
            cal.setTimeInMillis(nets.get(i).start); dow[i] = cal.get(Calendar.DAY_OF_WEEK); min[i] = cal.get(Calendar.HOUR_OF_DAY) * 60 + cal.get(Calendar.MINUTE);
            day[i] = cal.get(Calendar.YEAR) * 400L + cal.get(Calendar.DAY_OF_YEAR);
        }
        boolean[] used = new boolean[n];
        List<Slot> out = new ArrayList<>();
        for (int pass = 0; pass < 2; pass++) {          // 0 daily, 1 weekly
            for (int i = 0; i < n; i++) {
                if (used[i]) continue;
                List<Integer> g = new ArrayList<>(); Set<Long> days = new HashSet<>();
                for (int j = 0; j < n; j++) {
                    if (used[j] || nets.get(j).channel != nets.get(i).channel || Math.abs(min[j] - min[i]) > SAME_TIME_MIN) continue;
                    if (pass == 1 && dow[j] != dow[i]) continue;
                    if (days.add(day[j])) g.add(j);
                }
                if (g.size() < (pass == 0 ? 3 : 2)) continue;
                if (pass == 0) { Set<Integer> dows = new HashSet<>(); for (int j : g) dows.add(dow[j]); if (dows.size() < 3) continue; }
                Slot s = new Slot(); s.source = "Heard"; s.channel = nets.get(i).channel; s.dow = pass == 0 ? 0 : dow[i]; s.seen = g.size();
                List<Integer> mins = new ArrayList<>(), durs = new ArrayList<>(); int st = 0;
                for (int j : g) {
                    used[j] = true; mins.add(min[j]); durs.add(nets.get(j).minutes()); st = Math.max(st, nets.get(j).stations);
                    if (s.name.isEmpty()) s.name = nets.get(j).name;
                }
                s.minute = median(mins); s.durationMin = Math.max(NET_MINUTES, median(durs)); s.stations = st;
                out.add(s);
            }
        }
        return out;
    }

    /** The next start of a slot, or the current one while it is still running. */
    public static long next(Slot s, long now, TimeZone tz) {
        Calendar cal = Calendar.getInstance(tz, Locale.US);
        cal.setTimeInMillis(now); cal.set(Calendar.SECOND, 0); cal.set(Calendar.MILLISECOND, 0);
        cal.set(Calendar.HOUR_OF_DAY, s.minute / 60); cal.set(Calendar.MINUTE, s.minute % 60);
        cal.add(Calendar.DAY_OF_YEAR, -1);
        for (int i = 0; i < 9; i++) {
            if ((s.dow == 0 || cal.get(Calendar.DAY_OF_WEEK) == s.dow) && cal.getTimeInMillis() + s.durationMin * 60_000L > now) return cal.getTimeInMillis();
            cal.add(Calendar.DAY_OF_YEAR, 1);
        }
        return Long.MAX_VALUE;
    }

    private static final String[] DAYS = { "", "Sundays", "Mondays", "Tuesdays", "Wednesdays", "Thursdays", "Fridays", "Saturdays" };
    /** "Tuesdays 7:30 PM" / "Daily 8:00 AM". */
    public static String when(Slot s) {
        int h = s.minute / 60, m = s.minute % 60;
        return (s.dow == 0 ? "Daily" : DAYS[s.dow]) + String.format(Locale.US, " %d:%02d %s", h % 12 == 0 ? 12 : h % 12, m, h < 12 ? "AM" : "PM");
    }
}
