package com.dmrmod.hooks;

import org.json.JSONArray;
import org.json.JSONObject;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.InputStream;
import java.io.InvalidClassException;
import java.io.ObjectInputStream;
import java.io.ObjectStreamClass;
import java.io.OutputStreamWriter;
import java.nio.charset.StandardCharsets;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Iterator;
import java.util.Map;
import java.util.Set;

import de.robv.android.xposed.XposedBridge;

/**
 * Backlog S3 (2026-10-14): the APRS / SSTV / NOAA / VFO modes park a copy of the hijacked
 * channel so a crash mid-mode can be repaired at the next start. Those copies used to be
 * Java-serialized HashMaps at {@code /sdcard/<mode>_channel_backup.dat}: world-readable
 * (channel name, frequencies, tones) and read back through {@code ObjectInputStream}.
 *
 * They are now flat JSON files in the OEM app's private {@code files/} directory. A legacy
 * {@code .dat} is migrated once through a class-whitelisting ObjectInputStream and deleted.
 *
 * Values are what the mode code stores: Integer / Long / String / Boolean, plus int[] for safety.
 */
public final class ModeBackupStore {
    private static final String TAG = "DMRModHooks";
    private static volatile File filesDir = null;

    private ModeBackupStore() { }

    /** Called from the Application.onCreate hook. Falls back to the OEM's known data path. */
    public static void init(File appFilesDir) {
        if (appFilesDir != null) {
            filesDir = appFilesDir;
        }
    }

    private static File dir() {
        File d = filesDir;
        if (d == null) {
            d = new File("/data/data/com.pri.prizeinterphone/files");
        }
        if (!d.exists()) {
            d.mkdirs();
        }
        return d;
    }

    static File jsonFile(String mode) {
        return new File(dir(), "dmrmod_" + mode + "_channel_backup.json");
    }

    static File legacyFile(String mode) {
        return new File("/sdcard/" + mode + "_channel_backup.dat");
    }

    public static boolean exists(String mode) {
        if (jsonFile(mode).exists()) {
            return true;
        }
        if (legacyFile(mode).exists()) {
            return migrateLegacy(mode) != null;
        }
        return false;
    }

    public static boolean save(String mode, Map<String, Object> backup) {
        if (backup == null) {
            return false;
        }
        OutputStreamWriter w = null;
        try {
            JSONObject o = new JSONObject();
            for (Map.Entry<String, Object> e : backup.entrySet()) {
                Object v = e.getValue();
                if (v instanceof int[]) {
                    JSONArray a = new JSONArray();
                    for (int x : (int[]) v) {
                        a.put(x);
                    }
                    o.put(e.getKey(), a);
                } else if (v == null) {
                    o.put(e.getKey(), JSONObject.NULL);
                } else {
                    o.put(e.getKey(), v);
                }
            }
            File f = jsonFile(mode);
            w = new OutputStreamWriter(new FileOutputStream(f), StandardCharsets.UTF_8);
            w.write(o.toString());
            w.flush();
            return true;
        } catch (Throwable t) {
            XposedBridge.log(TAG + ": ModeBackupStore.save(" + mode + ") failed: " + t.getMessage());
            return false;
        } finally {
            if (w != null) {
                try { w.close(); } catch (Exception ignored) { }
            }
        }
    }

    /** @return the stored map, or null when there is none (or it is unreadable). */
    public static HashMap<String, Object> load(String mode) {
        File f = jsonFile(mode);
        if (!f.exists()) {
            if (legacyFile(mode).exists()) {
                return migrateLegacy(mode);
            }
            return null;
        }
        InputStream in = null;
        try {
            in = new FileInputStream(f);
            byte[] buf = new byte[(int) Math.min(f.length(), 64 * 1024)];
            int n = 0, r;
            while (n < buf.length && (r = in.read(buf, n, buf.length - n)) > 0) {
                n += r;
            }
            JSONObject o = new JSONObject(new String(buf, 0, n, StandardCharsets.UTF_8));
            HashMap<String, Object> map = new HashMap<>();
            Iterator<String> keys = o.keys();
            while (keys.hasNext()) {
                String k = keys.next();
                map.put(k, fromJson(o.get(k)));
            }
            return map;
        } catch (Throwable t) {
            XposedBridge.log(TAG + ": ModeBackupStore.load(" + mode + ") failed: " + t.getMessage());
            return null;
        } finally {
            if (in != null) {
                try { in.close(); } catch (Exception ignored) { }
            }
        }
    }

    public static boolean delete(String mode) {
        boolean any = false;
        try {
            File f = jsonFile(mode);
            if (f.exists()) {
                any = f.delete();
            }
            File l = legacyFile(mode);
            if (l.exists()) {
                any |= l.delete();
            }
        } catch (Throwable t) {
            XposedBridge.log(TAG + ": ModeBackupStore.delete(" + mode + ") failed: " + t.getMessage());
        }
        return any;
    }

    private static Object fromJson(Object v) {
        if (v == null || v == JSONObject.NULL) {
            return null;
        }
        if (v instanceof JSONArray) {
            JSONArray a = (JSONArray) v;
            int[] out = new int[a.length()];
            for (int i = 0; i < out.length; i++) {
                out[i] = a.optInt(i);
            }
            return out;
        }
        if (v instanceof Number) {
            Number num = (Number) v;
            double d = num.doubleValue();
            if (d == Math.rint(d)) {
                long l = num.longValue();
                if (l >= Integer.MIN_VALUE && l <= Integer.MAX_VALUE) {
                    return (int) l;        // the mode code casts to Integer
                }
                return l;
            }
            return d;
        }
        return v;   // String / Boolean
    }

    // ---------------------------------------------------------------- legacy migration

    private static final Set<String> LEGACY_CLASSES = new HashSet<>(java.util.Arrays.asList(
        "java.util.HashMap", "java.lang.String", "java.lang.Integer", "java.lang.Long",
        "java.lang.Boolean", "java.lang.Number", "java.lang.Double", "java.lang.Float",
        "java.lang.Short", "java.lang.Byte", "[I"));

    /** Reads the pre-S3 serialized HashMap once (whitelisted classes only), rewrites it as JSON, deletes it. */
    @SuppressWarnings("unchecked")
    private static HashMap<String, Object> migrateLegacy(String mode) {
        File l = legacyFile(mode);
        ObjectInputStream ois = null;
        try {
            ois = new ObjectInputStream(new FileInputStream(l)) {
                @Override
                protected Class<?> resolveClass(ObjectStreamClass desc) throws java.io.IOException, ClassNotFoundException {
                    if (!LEGACY_CLASSES.contains(desc.getName())) {
                        throw new InvalidClassException("refused: " + desc.getName());
                    }
                    return super.resolveClass(desc);
                }
            };
            Object o = ois.readObject();
            if (!(o instanceof HashMap)) {
                throw new InvalidClassException("not a HashMap");
            }
            HashMap<String, Object> map = (HashMap<String, Object>) o;
            save(mode, map);
            XposedBridge.log(TAG + ": ModeBackupStore: migrated legacy " + l.getName() + " to JSON (" + map.size() + " keys)");
            return map;
        } catch (Throwable t) {
            XposedBridge.log(TAG + ": ModeBackupStore: legacy " + l.getName() + " not migrated (" + t.getMessage() + ") - deleting");
            return null;
        } finally {
            if (ois != null) {
                try { ois.close(); } catch (Exception ignored) { }
            }
            try { l.delete(); } catch (Exception ignored) { }
        }
    }
}
