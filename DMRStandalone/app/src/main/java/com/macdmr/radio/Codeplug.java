package com.macdmr.radio;

import java.io.ByteArrayOutputStream;
import java.nio.charset.StandardCharsets;
import java.util.ArrayList;
import java.util.Base64;
import java.util.List;
import java.util.Locale;
import java.util.zip.DataFormatException;
import java.util.zip.Deflater;
import java.util.zip.Inflater;

/**
 * A shareable codeplug: a name and a few channels, written three ways (pure Java, host-tested).
 *
 * The share text: a readable list anyone can program by hand, plus the import code {@code SDCP1:…:END} (the channels,
 * deflated and base64url'd) that SignalDeck finds anywhere in a message, a post, a pasted text or a file, even when an
 * app has wrapped the long line. A CHIRP CSV of the analog channels for other radios, and CHIRP CSVs are read back too.
 *
 * Never shared: encryption keys (an encrypted channel arrives with encryption off) and anything but the channels.
 */
public final class Codeplug {
    public String name = "Channels";
    public final List<ChannelStore.Channel> channels = new ArrayList<>();
    /** What could not be read, for the import preview. */
    public final List<String> skipped = new ArrayList<>();
    /** Where it came from ("SignalDeck", "CHIRP"). */
    public String format = "SignalDeck";
    /** The nets held on each channel (the net's channel fields are filled in on import). */
    public final java.util.IdentityHashMap<ChannelStore.Channel, List<com.macdmr.radio.ham.NetFinder.Manual>> nets = new java.util.IdentityHashMap<>();
    public List<com.macdmr.radio.ham.NetFinder.Manual> netsOf(ChannelStore.Channel c) { List<com.macdmr.radio.ham.NetFinder.Manual> l = nets.get(c); return l == null ? new ArrayList<>() : l; }
    public boolean hasNotesOrNets() { for (ChannelStore.Channel c : channels) if (!c.notes.isEmpty() || !netsOf(c).isEmpty()) return true; return false; }

    static final String START = "SDCP1:", END = ":END";

    // ---- the channel lines inside the code ----

    private static String esc(String s) { return s == null ? "" : s.replace("%", "%25").replace("|", "%7C").replace("\n", "%0A").replace("\r", ""); }
    private static String esc2(String s) { return esc(s).replace(",", "%2C").replace(";", "%3B"); }
    private static String unesc2(String s) { return unesc(s.replace("%2C", ",").replace("%3B", ";")); }
    private static String unesc(String s) { return s.replace("%0A", "\n").replace("%7C", "|").replace("%25", "%"); }

    /** Version line, then one line per channel. Field order is fixed; later versions only append fields. */
    static String lines(Codeplug p, boolean withLocations) { return lines(p, withLocations, false, false); }
    /** Fields 27 and 28 (since 2026-10-22): the channel's notes, and its nets as name,days,minute,minutes,notes;… */
    static String lines(Codeplug p, boolean withLocations, boolean withNotes, boolean withNets) {
        StringBuilder b = new StringBuilder("v1|").append(esc(p.name)).append('\n');
        for (ChannelStore.Channel c : p.channels) {
            StringBuilder g = new StringBuilder(); for (int x : c.groups) { if (g.length() > 0) g.append(';'); g.append(x); }
            b.append("c|").append(esc(c.name)).append('|').append(c.type).append('|').append(c.rxFreq).append('|').append(c.txFreq).append('|')
             .append(c.power).append('|').append(c.band).append('|').append(c.sq).append('|').append(c.rxType).append('|').append(c.rxSubCode).append('|')
             .append(c.txType).append('|').append(c.txSubCode).append('|').append(c.relay).append('|').append(c.mode).append('|').append(c.cc).append('|')
             .append(c.inSlot).append('|').append(c.outSlot).append('|').append(c.contactType).append('|').append(c.txContact).append('|').append(g).append('|')
             .append(c.interrupt).append('|').append(c.softSq ? 1 : 0).append('|').append(c.softSqLevel).append('|');
            if (withLocations && (c.lat != 0 || c.lon != 0)) b.append(String.format(Locale.US, "%.5f|%.5f|%s", c.lat, c.lon, esc(c.location)));
            else b.append("||");
            b.append('|').append(withNotes ? esc(c.notes) : "").append('|');
            if (withNets) { boolean first = true; for (com.macdmr.radio.ham.NetFinder.Manual m : p.netsOf(c)) {
                if (!first) b.append(';'); first = false;
                b.append(esc2(m.name)).append(',').append(m.days).append(',').append(m.minute).append(',').append(m.durationMin).append(',').append(esc2(m.notes));
            } }
            b.append('\n');
        }
        return b.toString();
    }

    static Codeplug parseLines(String s) {
        Codeplug p = new Codeplug();
        for (String line : s.split("\n")) {
            String[] f = line.split("\\|", -1);
            if (f.length >= 2 && f[0].equals("v1")) { p.name = unesc(f[1]); continue; }
            if (f.length < 26 || !f[0].equals("c")) continue;
            try {
                ChannelStore.Channel c = new ChannelStore.Channel();
                c.name = unesc(f[1]); c.type = i(f[2]); c.rxFreq = i(f[3]); c.txFreq = i(f[4]); c.power = i(f[5]); c.band = i(f[6]); c.sq = i(f[7]);
                c.rxType = i(f[8]); c.rxSubCode = i(f[9]); c.txType = i(f[10]); c.txSubCode = i(f[11]); c.relay = i(f[12]); c.mode = i(f[13]); c.cc = i(f[14]);
                c.inSlot = i(f[15]); c.outSlot = i(f[16]); c.contactType = i(f[17]); c.txContact = i(f[18]);
                List<Integer> gs = new ArrayList<>(); for (String x : f[19].split(";")) if (!x.trim().isEmpty()) gs.add(i(x.trim()));
                c.groups = new int[gs.size()]; for (int k = 0; k < c.groups.length; k++) c.groups[k] = gs.get(k);
                c.interrupt = i(f[20]); c.softSq = "1".equals(f[21]); c.softSqLevel = i(f[22]);
                if (!f[23].isEmpty() && !f[24].isEmpty()) { c.lat = Double.parseDouble(f[23]); c.lon = Double.parseDouble(f[24]); }
                c.location = unesc(f[25]);
                if (f.length > 26) c.notes = unesc(f[26]);
                if (f.length > 27 && !f[27].isEmpty()) {
                    List<com.macdmr.radio.ham.NetFinder.Manual> ns = new ArrayList<>();
                    for (String e : f[27].split(";")) {
                        String[] x = e.split(",", -1); if (x.length < 5) continue;
                        com.macdmr.radio.ham.NetFinder.Manual m = new com.macdmr.radio.ham.NetFinder.Manual();
                        m.name = unesc2(x[0]); m.days = i(x[1]) & com.macdmr.radio.ham.NetFinder.ALL_DAYS; m.minute = Math.max(0, Math.min(1439, i(x[2]))); m.durationMin = Math.max(5, Math.min(600, i(x[3]))); m.notes = unesc2(x[4]);
                        if (m.days != 0 && !m.name.isEmpty()) ns.add(m);
                    }
                    if (!ns.isEmpty()) p.nets.put(c, ns);
                }
                c.encryptSw = 2; c.encryptKey = "";
                if (!ChannelStore.inBand(c.rxFreq) || (c.txFreq != 0 && !ChannelStore.inBand(c.txFreq) && !ChannelStore.receiveOnly(c.txFreq))) { p.skipped.add(c.name + ": outside 136–174 / 400–480 MHz"); continue; }
                p.channels.add(c);
            } catch (RuntimeException e) { p.skipped.add("A channel line could not be read"); }
        }
        return p;
    }
    private static int i(String s) { return Integer.parseInt(s.trim()); }

    // ---- the import code ----

    /** {@code SDCP1:<base64url of the deflated lines>:END}. */
    public static String code(Codeplug p, boolean withLocations) { return code(p, withLocations, false, false); }
    public static String code(Codeplug p, boolean withLocations, boolean withNotes, boolean withNets) {
        byte[] in = lines(p, withLocations, withNotes, withNets).getBytes(StandardCharsets.UTF_8);
        Deflater d = new Deflater(Deflater.BEST_COMPRESSION); d.setInput(in); d.finish();
        ByteArrayOutputStream o = new ByteArrayOutputStream(); byte[] buf = new byte[4096];
        while (!d.finished()) o.write(buf, 0, d.deflate(buf));
        d.end();
        return START + Base64.getUrlEncoder().withoutPadding().encodeToString(o.toByteArray()) + END;
    }

    /** Finds a code anywhere in a text (line breaks or spaces an app put inside it are ignored); null if none. */
    public static Codeplug fromCode(String text) {
        if (text == null) return null;
        int a = text.indexOf(START); if (a < 0) return null;
        int z = text.indexOf(END, a + START.length()); if (z < 0) return null;
        String b64 = text.substring(a + START.length(), z).replaceAll("[^A-Za-z0-9_-]", "");
        try {
            byte[] raw = Base64.getUrlDecoder().decode(b64);
            Inflater inf = new Inflater(); inf.setInput(raw);
            ByteArrayOutputStream o = new ByteArrayOutputStream(); byte[] buf = new byte[4096];
            while (!inf.finished()) { int n = inf.inflate(buf); if (n == 0 && (inf.needsInput() || inf.needsDictionary())) break; o.write(buf, 0, n); if (o.size() > 2_000_000) break; }
            inf.end();
            String lines = o.toString("UTF-8");
            return lines.startsWith("v1|") ? parseLines(lines) : null;       // not ours, or cut short
        } catch (IllegalArgumentException | DataFormatException | java.io.UnsupportedEncodingException e) { return null; }
    }

    // ---- the readable text ----

    public static String tone(int type, int code) {
        if (type == 1) { double hz = com.macdmr.radio.dsp.ToneTable.ctcssHz(code); return hz > 0 ? String.format(Locale.US, "%.1f", hz) : ""; }
        if (type == 2 || type == 3) { String l = com.macdmr.radio.dsp.ToneTable.toneLabel(type, code); return l.equals("—") ? "" : l; }
        return "";
    }

    /** "1. Club Rptr 146.940 −0.600 tone 100.0" and so on, with the import code at the end. */
    public static String shareText(Codeplug p, boolean withLocations) { return shareText(p, withLocations, false, false); }
    public static String shareText(Codeplug p, boolean withLocations, boolean withNotes, boolean withNets) {
        StringBuilder b = new StringBuilder();
        b.append(p.name).append(" · ").append(p.channels.size()).append(p.channels.size() == 1 ? " channel" : " channels").append("\n\n");
        int n = 1;
        for (ChannelStore.Channel c : p.channels) {
            b.append(n++).append(". ").append(c.name).append("  ").append(String.format(Locale.US, "%.4f", c.rxFreq / 1e6)).append(" MHz");
            long off = (long) c.txFreq - c.rxFreq;
            if (ChannelStore.receiveOnly(c.txFreq) || c.txFreq == 0) b.append(", receive only");
            else if (off != 0) b.append(String.format(Locale.US, ", %s%.4f MHz offset (TX %.4f)", off > 0 ? "+" : "−", Math.abs(off) / 1e6, c.txFreq / 1e6));
            if (c.isDigital()) {
                b.append(", DMR CC").append(c.cc).append(" TS").append(c.inSlot + 1);
                if (c.txContact > 0) b.append(c.contactType == 0 ? ", private call " : ", TG ").append(c.txContact);
            } else {
                String tt = tone(c.txType, c.txSubCode), rt = tone(c.rxType, c.rxSubCode);
                b.append(", FM").append(c.band == 0 ? " narrow" : "");
                if (!tt.isEmpty()) b.append(", tone ").append(tt);
                if (!rt.isEmpty() && !rt.equals(tt)) b.append(", RX tone ").append(rt);
            }
            if (withLocations && (c.lat != 0 || c.lon != 0)) b.append(String.format(Locale.US, " (%.4f, %.4f)", c.lat, c.lon));
            b.append('\n');
            if (withNotes && !c.notes.isEmpty()) b.append("   Notes: ").append(c.notes.replace("\n", "\n   ")).append('\n');
            if (withNets) for (com.macdmr.radio.ham.NetFinder.Manual m : p.netsOf(c))
                b.append("   Net: ").append(m.name).append(", ").append(com.macdmr.radio.ham.NetFinder.when(m)).append(", ").append(m.durationMin).append(" min").append(m.notes.isEmpty() ? "" : " (" + m.notes + ")").append('\n');
        }
        b.append("\nTo import into SignalDeck: share this to SignalDeck, or copy all of it and use Channels → Share → Import.\n");
        b.append(code(p, withLocations, withNotes, withNets)).append('\n');
        return b.toString();
    }

    // ---- CHIRP CSV (analog channels, for other radios) ----

    static final String CHIRP_HEADER = "Location,Name,Frequency,Duplex,Offset,Tone,rToneFreq,cToneFreq,DtcsCode,DtcsPolarity,RxDtcsCode,CrossMode,Mode,TStep,Skip,Power,Comment,URCALL,RPT1CALL,RPT2CALL,DVCODE";

    public static String chirpCsv(Codeplug p) {
        StringBuilder b = new StringBuilder(CHIRP_HEADER).append("\r\n");
        int loc = 1;
        for (ChannelStore.Channel c : p.channels) {
            if (c.isDigital()) continue;
            long off = (long) c.txFreq - c.rxFreq;
            boolean rxOnly = c.txFreq == 0 || ChannelStore.receiveOnly(c.txFreq);
            String duplex = rxOnly ? "off" : off == 0 ? "" : Math.abs(off) > 20_000_000 ? "split" : off > 0 ? "+" : "-";
            String offset = rxOnly || off == 0 ? "0.000000" : duplex.equals("split") ? mhz(c.txFreq) : mhz(Math.abs(off));
            String tone = "", rTone = "88.5", cTone = "88.5", dtcs = "023", rxDtcs = "023", cross = "Tone->Tone";
            boolean tC = c.txType == 1, rC = c.rxType == 1, tD = (c.txType == 2 || c.txType == 3) && dcsOk(c.txSubCode), rD = (c.rxType == 2 || c.rxType == 3) && dcsOk(c.rxSubCode);
            String pol = (c.txType == 3 ? "R" : "N") + (c.rxType == 3 ? "R" : "N");
            if (tC && !rC && !rD) { tone = "Tone"; rTone = tone(c.txType, c.txSubCode); }
            else if (tC && rC && c.txSubCode == c.rxSubCode) { tone = "TSQL"; rTone = cTone = tone(c.txType, c.txSubCode); }
            else if (tD && rD && c.txSubCode == c.rxSubCode) { tone = "DTCS"; dtcs = rxDtcs = com.macdmr.radio.dsp.ToneTable.dcsCode(c.txSubCode); }
            else if (tC || rC || tD || rD) {
                tone = "Cross";
                if (tC) rTone = tone(c.txType, c.txSubCode); if (rC) cTone = tone(c.rxType, c.rxSubCode);
                if (tD) dtcs = com.macdmr.radio.dsp.ToneTable.dcsCode(c.txSubCode); if (rD) rxDtcs = com.macdmr.radio.dsp.ToneTable.dcsCode(c.rxSubCode);
                cross = (tC ? "Tone" : tD ? "DTCS" : "") + "->" + (rC ? "Tone" : rD ? "DTCS" : "");
            }
            b.append(loc++).append(',').append(csv(c.name)).append(',').append(mhz(c.rxFreq)).append(',').append(duplex).append(',').append(offset).append(',')
             .append(tone).append(',').append(rTone).append(',').append(cTone).append(',').append(dtcs).append(',').append(pol).append(',').append(rxDtcs).append(',').append(cross).append(',')
             .append(c.band == 0 ? "NFM" : "FM").append(",5.00,,").append(c.power == 0 ? "1.0W" : "5.0W").append(',').append(csv(c.location)).append(",,,,\r\n");
        }
        return b.toString();
    }
    private static boolean dcsOk(int idx) { return com.macdmr.radio.dsp.ToneTable.dcsCode(idx) != null; }
    private static String mhz(long hz) { return String.format(Locale.US, "%.6f", hz / 1e6); }
    private static String csv(String s) { if (s == null) return ""; return s.contains(",") || s.contains("\"") ? "\"" + s.replace("\"", "\"\"") + "\"" : s; }

    /** A CHIRP CSV (any column order, by header name), or null if the text is not one. */
    public static Codeplug fromChirp(String text, String name) {
        if (text == null) return null;
        String[] rows = text.replace("\r", "").split("\n");
        int h = -1; for (int k = 0; k < rows.length && k < 5; k++) if (rows[k].startsWith("Location,") && rows[k].contains("Frequency")) { h = k; break; }
        if (h < 0) return null;
        List<String> head = splitCsv(rows[h]);
        Codeplug p = new Codeplug(); p.name = name == null || name.isEmpty() ? "CHIRP import" : name; p.format = "CHIRP";
        for (int k = h + 1; k < rows.length; k++) {
            if (rows[k].trim().isEmpty()) continue;
            List<String> f = splitCsv(rows[k]);
            java.util.function.Function<String, String> g = col -> { int ix = head.indexOf(col); return ix >= 0 && ix < f.size() ? f.get(ix).trim() : ""; };
            try {
                ChannelStore.Channel c = new ChannelStore.Channel();
                c.type = 1; c.name = g.apply("Name"); if (c.name.isEmpty()) c.name = "CH " + g.apply("Location");
                c.rxFreq = (int) Math.round(Double.parseDouble(g.apply("Frequency")) * 1e6);
                String duplex = g.apply("Duplex"); double offMhz = g.apply("Offset").isEmpty() ? 0 : Double.parseDouble(g.apply("Offset"));
                long tx = duplex.equals("+") ? c.rxFreq + Math.round(offMhz * 1e6) : duplex.equals("-") ? c.rxFreq - Math.round(offMhz * 1e6) : duplex.equals("split") ? Math.round(offMhz * 1e6) : duplex.equals("off") ? 0 : c.rxFreq;
                c.txFreq = (int) tx;
                c.band = g.apply("Mode").equalsIgnoreCase("NFM") ? 0 : 1;
                String pw = g.apply("Power"); c.power = pw.isEmpty() || pw.matches("(?i)^(high|[3-9].*|[1-9][0-9].*)") ? 1 : 0;
                String tone = g.apply("Tone"), cross = g.apply("CrossMode"), pol = g.apply("DtcsPolarity");
                boolean tR = pol.length() > 0 && pol.charAt(0) == 'R', rR = pol.length() > 1 && pol.charAt(1) == 'R';
                int rT = ctcssIndex(g.apply("rToneFreq")), cT = ctcssIndex(g.apply("cToneFreq")), dt = dcs(g.apply("DtcsCode")), rdt = dcs(g.apply("RxDtcsCode").isEmpty() ? g.apply("DtcsCode") : g.apply("RxDtcsCode"));
                if (tone.equals("Tone")) { c.txType = 1; c.txSubCode = rT; }
                else if (tone.equals("TSQL")) { c.txType = c.rxType = 1; c.txSubCode = c.rxSubCode = cT >= 0 ? cT : rT; }
                else if (tone.equals("DTCS")) { c.txType = tR ? 3 : 2; c.rxType = rR ? 3 : 2; c.txSubCode = dt; c.rxSubCode = rdt >= 0 ? rdt : dt; }
                else if (tone.equals("Cross")) {
                    String[] ab = (cross.isEmpty() ? "Tone->Tone" : cross).split("->", -1);
                    String a = ab[0], z = ab.length > 1 ? ab[1] : "";
                    if (a.equals("Tone")) { c.txType = 1; c.txSubCode = rT; } else if (a.equals("DTCS")) { c.txType = tR ? 3 : 2; c.txSubCode = dt; }
                    if (z.equals("Tone")) { c.rxType = 1; c.rxSubCode = cT; } else if (z.equals("DTCS")) { c.rxType = rR ? 3 : 2; c.rxSubCode = rdt; }
                }
                if (c.txType == 1 && c.txSubCode < 0 || c.rxType == 1 && c.rxSubCode < 0) { c.txType = c.txType == 1 && c.txSubCode < 0 ? 0 : c.txType; c.rxType = c.rxType == 1 && c.rxSubCode < 0 ? 0 : c.rxType; }
                if (c.txType >= 2 && c.txSubCode < 0) c.txType = 0; if (c.rxType >= 2 && c.rxSubCode < 0) c.rxType = 0;
                c.location = g.apply("Comment");
                c.sq = 2; c.relay = 2; c.encryptSw = 2;
                if (!ChannelStore.inBand(c.rxFreq)) { p.skipped.add(c.name + " (" + g.apply("Frequency") + " MHz): outside 136–174 / 400–480 MHz"); continue; }
                if (c.txFreq != 0 && !ChannelStore.inBand(c.txFreq)) { p.skipped.add(c.name + ": transmit frequency outside the radio's bands"); continue; }
                if (g.apply("Mode").matches("(?i)AM|DV|USB|LSB|CW|DMR|DN")) { p.skipped.add(c.name + ": " + g.apply("Mode") + " is not FM"); continue; }
                p.channels.add(c);
            } catch (RuntimeException e) { p.skipped.add("Row " + (k - h) + " could not be read"); }
        }
        return p;
    }
    static int ctcssIndex(String hz) {
        if (hz == null || hz.isEmpty()) return -1;
        try { double v = Double.parseDouble(hz); double[] t = com.macdmr.radio.dsp.ToneTable.CTCSS; for (int k = 0; k < t.length; k++) if (Math.abs(t[k] - v) < 0.05) return k; } catch (NumberFormatException ignored) { }
        return -1;
    }
    static int dcs(String code) { return com.macdmr.radio.dsp.ToneTable.dcsIndex(code); }

    static List<String> splitCsv(String line) {
        List<String> out = new ArrayList<>(); StringBuilder cur = new StringBuilder(); boolean q = false;
        for (int k = 0; k < line.length(); k++) {
            char ch = line.charAt(k);
            if (q) { if (ch == '"') { if (k + 1 < line.length() && line.charAt(k + 1) == '"') { cur.append('"'); k++; } else q = false; } else cur.append(ch); }
            else if (ch == '"') q = true; else if (ch == ',') { out.add(cur.toString()); cur.setLength(0); } else cur.append(ch);
        }
        out.add(cur.toString());
        return out;
    }

    /** Whatever arrived: a SignalDeck code anywhere in it, or a CHIRP CSV. Null if neither. */
    public static Codeplug read(String text, String fileName) {
        Codeplug p = fromCode(text);
        if (p != null) return p;
        String base = fileName == null ? null : fileName.replaceFirst("\\.[A-Za-z0-9]+$", "");
        return fromChirp(text, base);
    }

    /** True when an imported channel is already among {@code existing} (same type, frequencies and name). */
    public static boolean duplicate(ChannelStore.Channel c, List<ChannelStore.Channel> existing) {
        for (ChannelStore.Channel e : existing)
            if (e.type == c.type && e.rxFreq == c.rxFreq && e.txFreq == c.txFreq && e.name.trim().equalsIgnoreCase(c.name.trim())
                    && (!c.isDigital() || (e.cc == c.cc && e.inSlot == c.inSlot && e.txContact == c.txContact))) return true;
        return false;
    }
}
