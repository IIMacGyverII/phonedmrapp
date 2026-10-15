package com.dmrmod.hooks;

import android.content.Context;

import org.json.JSONArray;
import org.json.JSONObject;

import java.io.File;
import java.io.FileOutputStream;
import java.util.ArrayList;
import java.util.List;

import de.robv.android.xposed.XposedBridge;

/**
 * Tracks what each Nearby-Repeaters install created, so undo removes exactly that and nothing else
 * (chapter 16 §4.1 {@code installed}, §9.3). A small JSON file in the OEM app's private files dir.
 *
 * <p>Each run records the area it wrote to, the channel {@code _id}s, which TG lists / zone /
 * contacts the run <i>created</i> (vs reused — those are not deleted on undo), and the location
 * {@code _id}s. Newest run first; capped so the file stays tiny.
 */
public final class RepeaterInstallStore {

    private static final String TAG = "DMRModHooks";
    private static final String FILE = "dmrmod_repeater_installs.json";
    private static final int MAX_RUNS = 25;

    public static final class Run {
        public long runId;
        public String areaKey;
        public String repeaterKey;
        public String callsign;
        public long installedAt;
        public final List<Integer> channelIds = new ArrayList<>();
        public final List<Long> tgListIdsCreated = new ArrayList<>();
        public final List<Integer> contactIdsCreated = new ArrayList<>();
        public final List<Integer> contactNumbersCreated = new ArrayList<>();
        public long zoneId;
        public boolean zoneCreated;

        JSONObject toJson() throws Exception {
            JSONObject o = new JSONObject();
            o.put("runId", runId);
            o.put("areaKey", areaKey);
            o.put("repeaterKey", repeaterKey);
            o.put("callsign", callsign);
            o.put("installedAt", installedAt);
            o.put("channelIds", new JSONArray(channelIds));
            o.put("tgListIdsCreated", new JSONArray(tgListIdsCreated));
            o.put("contactIdsCreated", new JSONArray(contactIdsCreated));
            o.put("contactNumbersCreated", new JSONArray(contactNumbersCreated));
            o.put("zoneId", zoneId);
            o.put("zoneCreated", zoneCreated);
            return o;
        }

        static Run fromJson(JSONObject o) {
            Run r = new Run();
            r.runId = o.optLong("runId");
            r.areaKey = o.optString("areaKey", null);
            r.repeaterKey = o.optString("repeaterKey", null);
            r.callsign = o.optString("callsign", null);
            r.installedAt = o.optLong("installedAt");
            r.zoneId = o.optLong("zoneId");
            r.zoneCreated = o.optBoolean("zoneCreated");
            putInts(r.channelIds, o.optJSONArray("channelIds"));
            putLongs(r.tgListIdsCreated, o.optJSONArray("tgListIdsCreated"));
            putInts(r.contactIdsCreated, o.optJSONArray("contactIdsCreated"));
            putInts(r.contactNumbersCreated, o.optJSONArray("contactNumbersCreated"));
            return r;
        }

        private static void putInts(List<Integer> dst, JSONArray a) {
            if (a == null) return;
            for (int i = 0; i < a.length(); i++) dst.add(a.optInt(i));
        }
        private static void putLongs(List<Long> dst, JSONArray a) {
            if (a == null) return;
            for (int i = 0; i < a.length(); i++) dst.add(a.optLong(i));
        }
    }

    private RepeaterInstallStore() { }

    public static synchronized List<Run> load(Context ctx) {
        List<Run> runs = new ArrayList<>();
        try {
            File f = new File(ctx.getFilesDir(), FILE);
            if (!f.exists()) return runs;
            byte[] buf = new byte[(int) f.length()];
            java.io.FileInputStream in = new java.io.FileInputStream(f);
            try { int off = 0, n; while (off < buf.length && (n = in.read(buf, off, buf.length - off)) > 0) off += n; }
            finally { in.close(); }
            JSONArray arr = new JSONArray(new String(buf, "UTF-8"));
            for (int i = 0; i < arr.length(); i++) {
                JSONObject o = arr.optJSONObject(i);
                if (o != null) runs.add(Run.fromJson(o));
            }
        } catch (Throwable t) {
            XposedBridge.log(TAG + ": RepeaterInstallStore.load failed: " + t);
        }
        return runs;
    }

    public static synchronized void save(Context ctx, Run run) {
        try {
            List<Run> runs = load(ctx);
            runs.add(0, run);                       // newest first
            while (runs.size() > MAX_RUNS) runs.remove(runs.size() - 1);
            writeAll(ctx, runs);
        } catch (Throwable t) {
            XposedBridge.log(TAG + ": RepeaterInstallStore.save failed: " + t);
        }
    }

    public static synchronized void remove(Context ctx, long runId) {
        try {
            List<Run> runs = load(ctx);
            for (int i = runs.size() - 1; i >= 0; i--) {
                if (runs.get(i).runId == runId) runs.remove(i);
            }
            writeAll(ctx, runs);
        } catch (Throwable t) {
            XposedBridge.log(TAG + ": RepeaterInstallStore.remove failed: " + t);
        }
    }

    public static Run latest(Context ctx) {
        List<Run> runs = load(ctx);
        return runs.isEmpty() ? null : runs.get(0);
    }

    private static void writeAll(Context ctx, List<Run> runs) throws Exception {
        JSONArray arr = new JSONArray();
        for (Run r : runs) arr.put(r.toJson());
        File f = new File(ctx.getFilesDir(), FILE);
        FileOutputStream out = new FileOutputStream(f);
        try { out.write(arr.toString().getBytes("UTF-8")); } finally { out.close(); }
    }
}
