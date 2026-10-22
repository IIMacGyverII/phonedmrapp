package com.macdmr.radio;

import android.database.sqlite.SQLiteDatabase;
import android.os.Environment;

import com.macdmr.radio.dsp.ToneConverter;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;
import java.io.Writer;
import java.nio.charset.StandardCharsets;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Date;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;

/**
 * Backups in the folder layout the DMRModHooks module and the OpenGD77 CPS fork already understand:
 * {@code Download/DMR/DMR_Backups/<timestamp>/} with Contacts.csv, TG_Lists.csv, Channels.csv (the 37-column
 * Android layout plus SoftSQ columns), Zones.csv and DTMF.csv. Import reads the same files (also plain
 * 36-column OpenGD77 exports) and replaces channels, contacts and zones.
 */
public final class Backup {
    public static final String CHANNELS_HEADER = "_id,Channel Number,Channel Name,Channel Type,Rx Frequency,Tx Frequency,Bandwidth (kHz),"
            + "Colour Code,Timeslot,Contact,TG List,DMR ID,TS1_TA_Tx,TS2_TA_Tx ID,RX Tone,TX Tone,"
            + "Squelch,Power,Rx Only,Zone Skip,All Skip,TOT,VOX,No Beep,No Eco,APRS,Latitude,Longitude,Use Location,"
            + "Encrypt Switch,Encrypt Key,Relay,Interrupt,Active,Outbound Slot,Channel Mode,Contact Type,SoftSQ,SoftSQLevel";
    private static final String CONTACTS_HEADER = "Contact Name,ID,ID Type,TS Override";

    private Backup() { }

    public static File backupRoot() { return new File(Environment.getExternalStoragePublicDirectory(Environment.DIRECTORY_DOWNLOADS), "DMR/DMR_Backups"); }

    /** Folders newest first. */
    public static List<File> backups() {
        List<File> out = new ArrayList<>();
        File[] fs = backupRoot().listFiles();
        if (fs != null) for (File f : fs) if (f.isDirectory() && new File(f, "Channels.csv").exists()) out.add(f);
        out.sort((a, b) -> b.getName().compareTo(a.getName()));
        return out;
    }

    private static String q(String s) {
        if (s == null) return "";
        return s.contains(",") || s.contains("\"") || s.contains("\n") ? "\"" + s.replace("\"", "\"\"") + "\"" : s;
    }

    // ---- export --------------------------------------------------------------------------------------

    public static File export(ChannelStore store) throws Exception { return export(store, null); }
    public static File export(ChannelStore store, java.util.Map<String, String> dtmf) throws Exception {
        File dir = new File(backupRoot(), new SimpleDateFormat("yyyyMMdd_HHmmss", Locale.US).format(new Date()));
        if (!dir.mkdirs() && !dir.isDirectory()) throw new Exception("cannot create " + dir);
        List<ChannelStore.Channel> channels = store.all();
        List<ChannelStore.Contact> contacts = store.contacts();
        Map<Integer, String> contactName = new HashMap<>();
        for (ChannelStore.Contact c : contacts) if (!contactName.containsKey(c.number)) contactName.put(c.number, c.name);

        try (Writer w = writer(new File(dir, "Contacts.csv"))) {
            w.write(CONTACTS_HEADER + "\r\n");
            java.util.HashSet<String> seen = new java.util.HashSet<>();
            for (ChannelStore.Contact c : contacts) {
                String row = q(c.name) + "," + c.number + "," + (c.type == 0 ? "Private" : c.type == 1 ? "Group" : "All Call") + ",-";
                if (seen.add(row)) w.write(row + "\r\n");
            }
        }
        // TG lists: one per distinct RX group set, named after the first channel that uses it
        LinkedHashMap<String, int[]> lists = new LinkedHashMap<>();
        for (ChannelStore.TgList t : store.tgLists()) if (t.tgs.length > 0 && !lists.containsKey(t.name)) lists.put(t.name, t.tgs);   // saved named lists go to the file too
        Map<Long, String> listOf = new HashMap<>();
        for (ChannelStore.Channel ch : channels) {
            if (!ch.isDigital() || ch.groups.length == 0) continue;
            String key = Arrays.toString(ch.groups); String name = null;
            for (Map.Entry<String, int[]> e : lists.entrySet()) if (Arrays.toString(e.getValue()).equals(key)) { name = e.getKey(); break; }
            if (name == null) { name = ch.name + " TGs"; int k = 2; while (lists.containsKey(name)) name = ch.name + " TGs " + k++; lists.put(name, ch.groups); }
            listOf.put(ch.id, name);
        }
        try (Writer w = writer(new File(dir, "TG_Lists.csv"))) {
            StringBuilder h = new StringBuilder("TG List Name"); for (int i = 1; i <= 32; i++) h.append(",Contact").append(i);
            w.write(h + "\r\n");
            for (Map.Entry<String, int[]> e : lists.entrySet()) {
                StringBuilder r = new StringBuilder(q(e.getKey()));
                for (int i = 0; i < 32; i++) { r.append(','); if (i < e.getValue().length) r.append(e.getValue()[i]); }
                w.write(r + "\r\n");
            }
        }
        try (Writer w = writer(new File(dir, "Channels.csv"))) {
            w.write(CHANNELS_HEADER + "\r\n");
            for (ChannelStore.Channel ch : channels) {
                StringBuilder r = new StringBuilder();
                boolean dig = ch.isDigital();
                r.append(ch.id).append(',').append(ch.number).append(',').append(q(ch.name)).append(',').append(dig ? "Digital" : "Analogue").append(',');
                r.append(String.format(Locale.US, "\t%.5f", ch.rxFreq / 1e6)).append(',').append(String.format(Locale.US, "\t%.5f", ch.txFreq / 1e6)).append(',');
                r.append(dig ? "" : (ch.band == 0 ? "12.5" : "25")).append(',');
                if (dig) {
                    r.append(ch.cc).append(',').append(ch.inSlot + 1).append(',');
                    String cn = contactName.get(ch.txContact); r.append(q(cn != null ? cn : (ch.txContact > 0 ? "TG " + ch.txContact : "None"))).append(',');
                    String ln = listOf.get(ch.id); r.append(q(ln != null ? ln : "None")).append(',');
                    r.append(ch.txContact > 0 ? String.valueOf(ch.txContact) : "None").append(",Off,Off,,,Disabled,");
                } else {
                    r.append(",,,,,,,").append(ToneConverter.toCSVFormat(ch.rxType, ch.rxSubCode)).append(',').append(ToneConverter.toCSVFormat(ch.txType, ch.txSubCode)).append(',');
                    r.append(ch.sq == 0 ? "Disabled" : String.valueOf(ch.sq * 10 - 5)).append(',');
                }
                r.append(ch.power == 0 ? "P1" : "P9").append(",No,No,No,0,Off,No,No,None,");
                if (ch.lat != 0 || ch.lon != 0) r.append(String.format(Locale.US, "%.6f,%.6f,No", ch.lat, ch.lon)); else r.append("0.128,0.008,No");
                r.append(',').append(dig && ch.encryptSw == 1 ? 1 : 0).append(',').append(dig ? q(ch.encryptKey) : "");
                r.append(',').append(ch.relay == 0 || ch.relay == 1 || ch.relay == 2 ? ch.relay : 2).append(',').append(dig ? (ch.interrupt == 1 ? 1 : 2) : 0).append(',').append(ch.active ? 1 : 0);
                r.append(',').append(ch.outSlot).append(',').append(ch.mode == 4 ? 3 : ch.mode).append(',').append(ch.contactType);
                r.append(',').append(ch.softSq ? "On" : "Off").append(',').append(ch.softSqLevel >= 1 ? ch.softSqLevel : 5);
                w.write(r + "\r\n");
            }
        }
        try (Writer w = writer(new File(dir, "Zones.csv"))) {
            StringBuilder h = new StringBuilder("Zone Name"); for (int i = 1; i <= 80; i++) h.append(",Channel").append(i);
            w.write(h + "\r\n");
            Map<Integer, String> byNumber = new HashMap<>(); for (ChannelStore.Channel ch : channels) byNumber.put(ch.number, ch.name);
            for (ChannelStore.Zone z : store.zones()) {
                StringBuilder r = new StringBuilder(q(z.name)); int n = 0;
                for (int num : z.numbers) { String nm = byNumber.get(num); if (nm == null || n >= 80) continue; r.append(',').append(q(nm)); n++; }
                for (; n < 80; n++) r.append(',');
                w.write(r + "\r\n");
            }
        }
        try (Writer w = writer(new File(dir, EXTRAS))) {             // SignalDeck's own: channel notes and nets (other tools ignore the file)
            w.write(EXTRAS_HEADER + "\r\n");
            for (ChannelStore.Channel ch : channels) if (ch.notes != null && !ch.notes.isEmpty()) w.write(ch.number + "," + q(ch.name) + ",notes,,,,," + q(line(ch.notes)) + "\r\n");
            for (com.macdmr.radio.ham.NetFinder.Manual m : store.nets())
                w.write(m.channel + "," + q(nameOf(channels, m.channel)) + ",net," + q(line(m.name)) + "," + m.days + "," + String.format(Locale.US, "%02d:%02d", m.minute / 60, m.minute % 60) + "," + m.durationMin + "," + q(line(m.notes)) + "\r\n");
        }
        try (Writer w = writer(new File(dir, "DTMF.csv"))) { w.write("Contact Name,Code\r\n"); if (dtmf != null) for (Map.Entry<String, String> e : dtmf.entrySet()) w.write(q(e.getKey()) + "," + q(e.getValue()) + "\r\n"); }
        return dir;
    }

    /** SignalDeck's extra file in a backup folder: channel notes and the nets held on channels, by channel number. */
    public static final String EXTRAS = "SignalDeck_Extras.csv";
    static final String EXTRAS_HEADER = "Channel Number,Channel Name,Kind,Name,Days,Start,Minutes,Notes";
    /** One CSV line per value: newlines become \\n (the reader is line based). */
    private static String line(String s) { return s == null ? "" : s.replace("\\", "\\\\").replace("\r", "").replace("\n", "\\n"); }
    private static String unline(String s) {
        StringBuilder b = new StringBuilder();
        for (int i = 0; i < s.length(); i++) { char ch = s.charAt(i); if (ch == '\\' && i + 1 < s.length()) { char n = s.charAt(++i); b.append(n == 'n' ? '\n' : n); } else b.append(ch); }
        return b.toString();
    }
    private static String nameOf(List<ChannelStore.Channel> l, int number) { for (ChannelStore.Channel c : l) if (c.number == number) return c.name; return ""; }

    private static Writer writer(File f) throws Exception { return new OutputStreamWriter(new FileOutputStream(f), StandardCharsets.UTF_8); }

    // ---- import --------------------------------------------------------------------------------------

    private static List<List<String>> read(File f) throws Exception {
        List<List<String>> rows = new ArrayList<>();
        if (!f.exists()) return rows;
        try (BufferedReader r = new BufferedReader(new InputStreamReader(new FileInputStream(f), StandardCharsets.UTF_8))) {
            String line; boolean first = true;
            while ((line = r.readLine()) != null) {
                if (first && line.startsWith("﻿")) line = line.substring(1);
                first = false;
                if (line.trim().isEmpty()) continue;
                rows.add(RadioIdStore.split(line));
            }
        }
        return rows;
    }

    private static String col(List<String> r, int i) { return i >= 0 && i < r.size() ? r.get(i).trim() : ""; }
    private static int num(String s, int dflt) { try { return Integer.parseInt(s.trim()); } catch (Exception e) { return dflt; } }

    /**
     * Self-test: export everything, restore it into a scratch database and compare every channel field, contact, zone
     * and talkgroup list with the live data. Nothing live is changed; the test backup folder is deleted afterwards.
     */
    public static String selfTest(android.content.Context ctx, ChannelStore live, java.util.Map<String, String> dtmf) {
        StringBuilder r = new StringBuilder(); File dir = null; ChannelStore scratch = null;
        try {
            dir = export(live, dtmf);
            ctx.deleteDatabase("backup_selftest.db");
            scratch = new ChannelStore(ctx, "backup_selftest.db"); scratch.getWritableDatabase();
            restore(scratch, dir);
            List<ChannelStore.Channel> a = live.all(), b = scratch.all();
            r.append(a.size()).append(" channels exported, ").append(b.size()).append(" restored\n");
            int bad = 0;
            for (ChannelStore.Channel x : a) {
                ChannelStore.Channel y = null; for (ChannelStore.Channel z : b) if (z.number == x.number) y = z;
                if (y == null) { r.append("  Ch ").append(x.number).append(" missing\n"); bad++; continue; }
                List<String> d = new ArrayList<>();
                cmp(d, "name", x.name, y.name); cmp(d, "type", x.type, y.type); cmp(d, "rx", x.rxFreq, y.rxFreq); cmp(d, "tx", x.txFreq, y.txFreq);
                cmp(d, "power", x.power, y.power); cmp(d, "relay", x.relay, y.relay); cmp(d, "lat", Math.round(x.lat * 1e5), Math.round(y.lat * 1e5)); cmp(d, "lon", Math.round(x.lon * 1e5), Math.round(y.lon * 1e5));
                cmp(d, "softSq", x.softSq, y.softSq); cmp(d, "softSqLevel", x.softSqLevel, y.softSqLevel);
                if (x.isDigital()) {
                    cmp(d, "cc", x.cc, y.cc); cmp(d, "inSlot", x.inSlot, y.inSlot); cmp(d, "outSlot", x.outSlot, y.outSlot); cmp(d, "mode", x.mode, y.mode);
                    cmp(d, "contactType", x.contactType, y.contactType); cmp(d, "txContact", x.txContact, y.txContact); cmp(d, "groups", Arrays.toString(x.groups), Arrays.toString(y.groups));
                    cmp(d, "encrypt", x.encryptSw == 1, y.encryptSw == 1); if (x.encryptSw == 1) cmp(d, "key", x.encryptKey, y.encryptKey); cmp(d, "interrupt", x.interrupt == 1, y.interrupt == 1);
                } else {
                    cmp(d, "band", x.band, y.band); cmp(d, "sq", x.sq, y.sq);
                    cmp(d, "rxTone", x.rxType + "/" + (x.rxType == 0 ? 0 : x.rxSubCode), y.rxType + "/" + (y.rxType == 0 ? 0 : y.rxSubCode));
                    cmp(d, "txTone", x.txType + "/" + (x.txType == 0 ? 0 : x.txSubCode), y.txType + "/" + (y.txType == 0 ? 0 : y.txSubCode));
                }
                if (!d.isEmpty()) { bad++; r.append("  Ch ").append(x.number).append(" ").append(x.name).append(": ").append(String.join(", ", d)).append('\n'); }
            }
            int ca = live.contacts().size(), cb = scratch.contacts().size(), za = live.zones().size(), zb = scratch.zones().size();
            r.append(ca == cb ? "contacts match (" + ca + ")" : "contacts " + ca + " \u2192 " + cb).append('\n');
            int zbad = 0;
            for (ChannelStore.Zone z : live.zones()) { boolean ok = false; for (ChannelStore.Zone w : scratch.zones()) if (w.name.equals(z.name) && Arrays.equals(w.numbers, z.numbers)) ok = true; if (!ok) { zbad++; r.append("  zone ").append(z.name).append(" differs\n"); } }
            r.append(za == zb && zbad == 0 ? "zones match (" + za + ")" : "zones " + za + " \u2192 " + zb).append('\n');
            int tbad = 0;
            for (ChannelStore.TgList t : live.tgLists()) { if (t.tgs.length == 0) continue; boolean ok = false; for (ChannelStore.TgList u : scratch.tgLists()) if (u.name.equals(t.name) && Arrays.equals(u.tgs, t.tgs)) ok = true; if (!ok) { tbad++; r.append("  TG list ").append(t.name).append(" missing\n"); } }
            r.append(tbad == 0 ? "talkgroup lists kept" : tbad + " talkgroup lists not kept").append('\n');
            int notesBad = 0, netsBad = 0;
            for (ChannelStore.Channel x : a) { ChannelStore.Channel y = scratch.byNumber(x.number); if (y != null && !x.notes.equals(y.notes)) { notesBad++; r.append("  Ch ").append(x.number).append(" notes not kept\n"); } }
            List<com.macdmr.radio.ham.NetFinder.Manual> na = live.nets(), nb = scratch.nets();
            for (com.macdmr.radio.ham.NetFinder.Manual m : na) {
                boolean ok = false;
                for (com.macdmr.radio.ham.NetFinder.Manual k : nb) if (k.channel == m.channel && k.name.equals(m.name) && k.days == m.days && k.minute == m.minute && k.durationMin == m.durationMin && k.notes.equals(m.notes)) ok = true;
                if (!ok) { netsBad++; r.append("  net ").append(m.name).append(" not kept\n"); }
            }
            if (na.size() != nb.size()) netsBad++;
            r.append(notesBad == 0 && netsBad == 0 ? "notes and nets kept (" + na.size() + " nets)" : notesBad + " notes and " + netsBad + " nets not kept").append('\n');
            r.insert(0, bad == 0 && zbad == 0 && tbad == 0 && notesBad == 0 && netsBad == 0 && ca == cb ? "ROUND TRIP OK\n" : "ROUND TRIP: " + bad + " channels differ\n");
        } catch (Throwable t) { r.append("self-test failed: ").append(t); }
        finally {
            try { if (scratch != null) scratch.close(); ctx.deleteDatabase("backup_selftest.db"); } catch (Throwable ignored) { }
            if (dir != null) { File[] fs = dir.listFiles(); if (fs != null) for (File f : fs) f.delete(); dir.delete(); }
        }
        return r.toString();
    }
    private static void cmp(List<String> d, String what, Object a, Object b) { if (a == null ? b != null : !a.equals(b)) d.add(what + " " + a + "\u2192" + b); }

    /** Replace channels, contacts and zones from a backup folder. Returns a summary. */
    /** Copy the five CSVs of a SAF folder into the cache so {@link #restore} can read them. */
    public static File copyTree(android.content.Context ctx, android.net.Uri tree) throws Exception {
        File dir = new File(ctx.getCacheDir(), "restore_" + System.currentTimeMillis()); dir.mkdirs();
        android.net.Uri children = android.provider.DocumentsContract.buildChildDocumentsUriUsingTree(tree, android.provider.DocumentsContract.getTreeDocumentId(tree));
        int n = 0;
        try (android.database.Cursor c = ctx.getContentResolver().query(children, new String[] { android.provider.DocumentsContract.Document.COLUMN_DOCUMENT_ID, android.provider.DocumentsContract.Document.COLUMN_DISPLAY_NAME }, null, null, null)) {
            while (c != null && c.moveToNext()) {
                String name = c.getString(1);
                if (!name.endsWith(".csv")) continue;
                android.net.Uri doc = android.provider.DocumentsContract.buildDocumentUriUsingTree(tree, c.getString(0));
                try (java.io.InputStream in = ctx.getContentResolver().openInputStream(doc); FileOutputStream out = new FileOutputStream(new File(dir, name))) {
                    byte[] b = new byte[65536]; int k; while ((k = in.read(b)) > 0) out.write(b, 0, k);
                }
                n++;
            }
        }
        if (!new File(dir, "Channels.csv").exists()) throw new Exception("that folder has no Channels.csv");
        return dir;
    }

    /** DTMF.csv rows (name → code), if the backup has any. */
    public static java.util.LinkedHashMap<String, String> readDtmf(File dir) {
        java.util.LinkedHashMap<String, String> out = new java.util.LinkedHashMap<>();
        try { List<List<String>> rows = read(new File(dir, "DTMF.csv")); for (int i = 1; i < rows.size(); i++) if (rows.get(i).size() >= 2 && !col(rows.get(i), 1).isEmpty()) out.put(col(rows.get(i), 0), col(rows.get(i), 1)); } catch (Throwable ignored) { }
        return out;
    }

    public static String restore(ChannelStore store, File dir) throws Exception {
        List<List<String>> contacts = read(new File(dir, "Contacts.csv")), tgl = read(new File(dir, "TG_Lists.csv")), chans = read(new File(dir, "Channels.csv")), zones = read(new File(dir, "Zones.csv"));
        if (chans.size() < 2) throw new Exception("Channels.csv is empty");
        List<String> head = chans.get(0);
        int off = head.get(0).trim().equalsIgnoreCase("_id") ? 1 : 0;        // Android layout has _id first; OpenGD77 does not
        int softSqCol = -1, softSqLevelCol = -1;
        for (int i = 0; i < head.size(); i++) { String h = head.get(i).trim(); if (h.equalsIgnoreCase("SoftSQ")) softSqCol = i; if (h.equalsIgnoreCase("SoftSQLevel")) softSqLevelCol = i; }
        Map<String, Integer> contactByName = new HashMap<>();
        List<ChannelStore.Contact> cts = new ArrayList<>();
        for (int i = 1; i < contacts.size(); i++) {
            List<String> r = contacts.get(i); if (r.size() < 3) continue;
            ChannelStore.Contact c = new ChannelStore.Contact(); c.name = col(r, 0); c.number = num(col(r, 1), 0);
            String t = col(r, 2).toLowerCase(Locale.US); c.type = t.startsWith("priv") ? 0 : t.startsWith("group") ? 1 : 2;
            if (c.number <= 0 && c.type != 2) continue;
            cts.add(c); contactByName.put(c.name.toLowerCase(Locale.US), c.number);
        }
        Map<String, int[]> listByName = new HashMap<>();
        for (int i = 1; i < tgl.size(); i++) {
            List<String> r = tgl.get(i); if (r.isEmpty()) continue;
            List<Integer> ids = new ArrayList<>();
            for (int k = 1; k < r.size(); k++) { String s = col(r, k); if (s.isEmpty()) continue; Integer byName = contactByName.get(s.toLowerCase(Locale.US)); int v = byName != null ? byName : num(s, 0); if (v > 0) ids.add(v); }
            int[] a = new int[ids.size()]; for (int k = 0; k < a.length; k++) a[k] = ids.get(k);
            listByName.put(col(r, 0).toLowerCase(Locale.US), a);
        }
        List<ChannelStore.Channel> out = new ArrayList<>();
        List<String> outOfBand = new ArrayList<>();
        for (int i = 1; i < chans.size(); i++) {
            List<String> r = chans.get(i); if (r.size() < off + 17) continue;
            ChannelStore.Channel ch = new ChannelStore.Channel();
            ch.number = num(col(r, off), out.size() + 1); ch.name = col(r, off + 1);
            ch.type = col(r, off + 2).toLowerCase(Locale.US).startsWith("dig") ? 0 : 1;
            try { ch.rxFreq = (int) Math.round(Double.parseDouble(col(r, off + 3)) * 1e6); ch.txFreq = (int) Math.round(Double.parseDouble(col(r, off + 4)) * 1e6); } catch (Exception e) { continue; }
            String bw = col(r, off + 5); ch.band = bw.startsWith("12") ? 0 : 1; if (ch.rxFreq < 300_000_000) ch.band = 1;
            if (ch.isDigital()) {
                ch.cc = num(col(r, off + 6), 1); ch.inSlot = ch.outSlot = Math.max(0, num(col(r, off + 7), 1) - 1);
                String idStr = col(r, off + 10), cname = col(r, off + 8);
                ch.txContact = !idStr.isEmpty() && !idStr.equalsIgnoreCase("None") ? num(idStr, 0) : 0;
                if (ch.txContact <= 0) { Integer byName = contactByName.get(cname.toLowerCase(Locale.US)); if (byName != null) ch.txContact = byName; else if (cname.toUpperCase(Locale.US).startsWith("TG ")) ch.txContact = num(cname.substring(3), 0); }
                int[] g = listByName.get(col(r, off + 9).toLowerCase(Locale.US));
                ch.groups = g != null ? g.clone() : new int[0];
                ch.sq = 0;
            } else {
                try { ch.rxType = ToneConverter.parseType(col(r, off + 13)); ch.rxSubCode = ToneConverter.parseSubCode(col(r, off + 13)); } catch (Exception ignored) { }
                try { ch.txType = ToneConverter.parseType(col(r, off + 14)); ch.txSubCode = ToneConverter.parseSubCode(col(r, off + 14)); } catch (Exception ignored) { }
                String sq = col(r, off + 15).replace("%", "");
                ch.sq = sq.equalsIgnoreCase("Normal") ? 5 : sq.isEmpty() || sq.equalsIgnoreCase("Disabled") || sq.equalsIgnoreCase("None") ? 0 : Math.max(0, Math.min(9, (num(sq, 0) + 5) / 10));
            }
            String p = col(r, off + 16).toUpperCase(Locale.US);
            ch.power = p.equals("P1") || p.equals("P2") || p.equals("P3") || p.equals("P4") || p.equals("LOW") ? 0 : 1;
            try { double la = Double.parseDouble(col(r, off + 25)), lo = Double.parseDouble(col(r, off + 26)); if (!(Math.abs(la - 0.128) < 1e-6 && Math.abs(lo - 0.008) < 1e-6) && (la != 0 || lo != 0)) { ch.lat = la; ch.lon = lo; } } catch (Exception ignored) { }
            if (r.size() > off + 35) {                                            // the extended Android columns
                ch.encryptSw = ch.isDigital() && num(col(r, off + 28), 0) == 1 ? 1 : 2; ch.encryptKey = col(r, off + 29);
                int relay = num(col(r, off + 30), 2); ch.relay = relay == 1 || relay == 2 ? relay : 2;
                ch.interrupt = ch.isDigital() && num(col(r, off + 31), 2) == 1 ? 1 : 2;   // radio enum 1 on / 2 off (analog: unused, stock default 2)
                ch.active = num(col(r, off + 32), 0) == 1; ch.outSlot = num(col(r, off + 33), ch.outSlot);
                int mode = num(col(r, off + 34), 0); ch.mode = mode == 3 || mode == 4 ? 4 : 0;            // CSV/CPS 3 = double slot = radio 4
                ch.contactType = num(col(r, off + 35), ch.isDigital() ? 1 : 0);
            } else { ch.encryptSw = 2; ch.relay = 2; ch.interrupt = 2; ch.contactType = ch.isDigital() ? 1 : 0; }
            if (ch.isDigital() && ch.contactType == 1 && ch.txContact > 0 && ch.groups.length < 32) {   // a group call's own talkgroup must be in the RX list (radio passes only listed TGs)
                boolean has = false; for (int x : ch.groups) if (x == ch.txContact) has = true;
                if (!has) { ch.groups = Arrays.copyOf(ch.groups, ch.groups.length + 1); ch.groups[ch.groups.length - 1] = ch.txContact; }
            }
            if (softSqCol >= 0) ch.softSq = col(r, softSqCol).equalsIgnoreCase("On");
            if (softSqLevelCol >= 0) ch.softSqLevel = Math.max(1, Math.min(9, num(col(r, softSqLevelCol), 5)));
            if (!ChannelStore.inBand(ch.rxFreq) || !ChannelStore.inBand(ch.txFreq)) { outOfBand.add(ch.name + " " + ch.freqText(ch.rxFreq)); continue; }   // the radio refuses these (e.g. a 220 MHz channel from another radio's codeplug)
            out.add(ch);
        }
        if (out.isEmpty()) throw new Exception("no channels could be read");
        out.sort((a, b) -> Integer.compare(a.number, b.number));
        for (int i = 0; i < out.size(); i++) out.get(i).number = i + 1;
        Map<String, Integer> numberByName = new HashMap<>(); for (ChannelStore.Channel ch : out) if (!numberByName.containsKey(ch.name.toLowerCase(Locale.US))) numberByName.put(ch.name.toLowerCase(Locale.US), ch.number);
        List<ChannelStore.Zone> zs = new ArrayList<>();
        for (int i = 1; i < zones.size(); i++) {
            List<String> r = zones.get(i); if (r.isEmpty() || col(r, 0).isEmpty()) continue;
            ChannelStore.Zone z = new ChannelStore.Zone(); z.name = col(r, 0);
            List<Integer> nums = new ArrayList<>();
            for (int k = 1; k < r.size(); k++) { String s = col(r, k); if (s.isEmpty()) continue; Integer n = numberByName.get(s.toLowerCase(Locale.US)); if (n == null && s.contains("|")) n = numberByName.get(s.substring(s.lastIndexOf('|') + 1).toLowerCase(Locale.US)); if (n != null) nums.add(n); }
            z.numbers = new int[nums.size()]; for (int k = 0; k < z.numbers.length; k++) z.numbers[k] = nums.get(k);
            zs.add(z);
        }
        int keep = store.activeNumber();
        List<List<String>> extras = read(new File(dir, EXTRAS));
        int extraNotes = 0, extraNets = 0;
        SQLiteDatabase db = store.getWritableDatabase();
        db.beginTransaction();
        try {
            db.delete("channels", null, null); db.delete("contacts", null, null); db.delete("zones", null, null);
            for (ChannelStore.Channel ch : out) { ch.id = 0; ch.active = ch.number == keep; store.insert(ch); }
            for (ChannelStore.Contact c : cts) store.insertContact(c);
            for (ChannelStore.Zone z : zs) { z.id = 0; store.saveZone(z); }
            db.delete("nets", null, null);                                       // they belonged to the channels just replaced
            for (int i = 1; i < extras.size(); i++) {
                List<String> r = extras.get(i); ChannelStore.Channel ch = store.byNumber(num(col(r, 0), 0)); if (ch == null) continue;
                if ("notes".equalsIgnoreCase(col(r, 2))) { ch.notes = unline(col(r, 7)); store.update(ch); extraNotes++; }
                else if ("net".equalsIgnoreCase(col(r, 2))) {
                    com.macdmr.radio.ham.NetFinder.Manual m = new com.macdmr.radio.ham.NetFinder.Manual();
                    m.channelId = ch.id; m.channel = ch.number; m.name = unline(col(r, 3)); m.days = num(col(r, 4), 0) & com.macdmr.radio.ham.NetFinder.ALL_DAYS;
                    String[] hm = col(r, 5).split(":"); m.minute = hm.length == 2 ? Math.max(0, Math.min(1439, num(hm[0], 0) * 60 + num(hm[1], 0))) : 0;
                    m.durationMin = Math.max(5, Math.min(600, num(col(r, 6), 60))); m.notes = unline(col(r, 7));
                    if (m.days != 0 && !m.name.isEmpty()) { store.saveNet(m); extraNets++; }
                }
            }
            if (!listByName.isEmpty()) {
                db.delete("tglists", null, null);
                for (int i = 1; i < tgl.size(); i++) {
                    String name = col(tgl.get(i), 0); int[] tgs = listByName.get(name.toLowerCase(Locale.US));
                    if (name.isEmpty() || tgs == null || tgs.length == 0) continue;
                    ChannelStore.TgList t = new ChannelStore.TgList(); t.name = name; t.tgs = tgs; store.saveTgList(t);
                }
            }
            db.setTransactionSuccessful();
        } finally { db.endTransaction(); }
        return out.size() + " channels, " + cts.size() + " contacts, " + zs.size() + " zones" + (extras.size() > 1 ? ", " + extraNotes + " channel notes, " + extraNets + " nets" : "") + " restored from " + dir.getName()
                + (outOfBand.isEmpty() ? "" : "\n" + outOfBand.size() + " skipped: outside what this radio can tune (136–174 and 400–480 MHz): " + String.join(", ", outOfBand.subList(0, Math.min(5, outOfBand.size()))) + (outOfBand.size() > 5 ? " …" : ""));
    }
}
