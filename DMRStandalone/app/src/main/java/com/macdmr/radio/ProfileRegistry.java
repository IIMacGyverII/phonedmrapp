/*
 * SignalDeck - Copyright (C) 2026 IIMacGyverII
 * SPDX-License-Identifier: GPL-3.0-or-later
 * Free software under the GNU General Public License v3 or later, with the additional terms in COPYRIGHT
 * (keep this notice and the author credit, mark modified versions, no rights to the SignalDeck name or icon).
 */
package com.macdmr.radio;

import android.content.Context;
import android.content.SharedPreferences;
import android.os.Build;

import org.json.JSONArray;
import org.json.JSONObject;

import java.io.File;
import java.nio.charset.StandardCharsets;
import java.security.KeyFactory;
import java.security.PublicKey;
import java.security.Signature;
import java.security.spec.X509EncodedKeySpec;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashSet;
import java.util.List;
import java.util.Locale;
import java.util.Set;
import java.util.function.Predicate;

/**
 * Which device profile this phone uses. Tested profiles are built into each release (DeviceProfile constants, each with an
 * id and a revision) and need nothing from the network. A signed list in the repository (profiles/profiles.json + .sig)
 * can carry a newer revision of a built-in profile, or a profile for a phone the release does not know; it is used only
 * when its signature is valid, its serial is not older than the copy already on the phone, and for a built-in phone only
 * when its revision is higher. The same list carries advisories: notices that restrict a profile by default (transmit,
 * automatic take-over, or the whole profile) with what and why; the phone's owner can override each one after two
 * confirmations, and advisories lapse at their expiry date. Nothing here can lock an owner out of their own phone: the
 * built-in profiles keep working without the list, overrides need no network, and "Use the built-in profile" ignores
 * fetched profiles altogether.
 */
public final class ProfileRegistry {
    public static final String LIST_URL = "https://raw.githubusercontent.com/IIMacGyverII/phonedmrapp/main/profiles/profiles.json";
    /** ECDSA P-256 public key of the profile list's signing key (the private key never leaves the maintainer's PC). */
    static final String PUBLIC_KEY = "MFkwEwYHKoZIzj0CAQYIKoZIzj0DAQcDQgAESoOXZsfoRfdkCfyCAdZjNm6gL6MOU42q08UQGUYonPEgZruRBwTh1uo+9toFUqopphqIb9i7WV2zuSBRZRB6GQ==";

    /** One advisory as it applies to this phone. */
    public static final class Advisory {
        public String id, title, why, restrict, issued, expires; public boolean overridden;
        public String restrictionText() {
            return "profile".equals(restrict) ? "SignalDeck does not use this phone's profile (the stock app keeps the radio)"
                    : "takeover".equals(restrict) ? "SignalDeck no longer takes the radio over by itself (and does not transmit)"
                    : "transmit".equals(restrict) ? "transmitting is switched off" : restrict;
        }
    }
    /** What was chosen and why. */
    public static final class Selection {
        public DeviceProfile profile; public String source = "built-in"; public final List<Advisory> advisories = new ArrayList<>();
    }
    /** The phone, for matching (a seam for host tests). */
    public interface Env { String manufacturer(); String model(); String device(); boolean exists(String path); }

    private static volatile Selection current;
    private static volatile Context app;

    private ProfileRegistry() { }

    // ---- selection (pure: no Android state, host-tested) -------------------------------------------------------------

    public static Selection select(DeviceProfile builtIn, JSONObject list, Env env, boolean useBuiltIn, Set<String> overrides, String today) {
        Selection s = new Selection(); s.profile = builtIn;
        JSONArray profiles = list == null ? null : list.optJSONArray("profiles");
        if (!useBuiltIn && profiles != null) {
            for (int i = 0; i < profiles.length(); i++) {
                JSONObject o = profiles.optJSONObject(i); if (o == null) continue;
                String id = o.optString("id"); int rev = o.optInt("revision", 0);
                boolean sameId = builtIn.supported && id.equals(builtIn.id);
                boolean newPhone = !builtIn.supported && matches(o.optJSONObject("match"), env);
                if ((sameId && rev > builtIn.revision) || (newPhone && rev > (s.profile.supported ? s.profile.revision : -1))) {
                    try { DeviceProfile p = DeviceProfile.fromJson(o); p.source = "updated"; s.profile = p; s.source = "updated"; } catch (Throwable ignored) { }
                }
            }
        }
        JSONArray adv = list == null ? null : list.optJSONArray("advisories");
        if (adv != null) for (int i = 0; i < adv.length(); i++) {
            JSONObject o = adv.optJSONObject(i); if (o == null) continue;
            if (!o.optString("profile").equals(s.profile.id)) continue;
            if (o.has("maxRevision") && s.profile.revision > o.optInt("maxRevision")) continue;      // fixed in a later revision
            String exp = o.optString("expires", "");
            if (!exp.isEmpty() && today.compareTo(exp) > 0) continue;                                  // lapsed: not renewed
            Advisory a = new Advisory();
            a.id = o.optString("id"); a.title = o.optString("title", "Advisory"); a.why = o.optString("why", "");
            a.restrict = o.optString("restrict", "transmit"); a.issued = o.optString("issued", ""); a.expires = exp;
            a.overridden = overrides != null && overrides.contains(a.id);
            s.advisories.add(a);
            if (!a.overridden) s.profile = restrict(s.profile, a.restrict, a.id);
        }
        return s;
    }

    static boolean matches(JSONObject m, Env env) {
        if (m == null) return false;
        String phone = (env.manufacturer() + " " + env.model() + " " + env.device()).toLowerCase(Locale.ROOT);
        JSONArray names = m.optJSONArray("model"), paths = m.optJSONArray("sysfs");
        if (names != null) for (int i = 0; i < names.length(); i++) if (phone.contains(names.optString(i).toLowerCase(Locale.ROOT))) return true;
        if (paths != null) for (int i = 0; i < paths.length(); i++) if (env.exists(paths.optString(i))) return true;
        return false;
    }

    private static DeviceProfile restrict(DeviceProfile p, String what, String advisory) {
        DeviceProfile r;
        if ("profile".equals(what)) r = p.copy(false, false);
        else if ("takeover".equals(what)) r = p.copy(p.supported, false);
        else { r = p.copy(p.supported, p.verified); r.txBlocked = true; }
        r.restrictedBy = advisory;
        return r;
    }

    // ---- signature ----------------------------------------------------------------------------------------------------

    static boolean verify(byte[] data, String sigB64, String publicKeyB64) {
        try {
            PublicKey k = KeyFactory.getInstance("EC").generatePublic(new X509EncodedKeySpec(java.util.Base64.getDecoder().decode(publicKeyB64)));
            Signature v = Signature.getInstance("SHA256withECDSA"); v.initVerify(k); v.update(data);
            return v.verify(java.util.Base64.getDecoder().decode(sigB64.trim()));
        } catch (Throwable t) { return false; }
    }

    // ---- on the phone -------------------------------------------------------------------------------------------------

    private static final Env PHONE = new Env() {
        @Override public String manufacturer() { return Build.MANUFACTURER; }
        @Override public String model() { return Build.MODEL; }
        @Override public String device() { return Build.DEVICE; }
        @Override public boolean exists(String path) { return new File(path).exists(); }
    };

    private static SharedPreferences prefs(Context c) { return c.getSharedPreferences("profiles", Context.MODE_PRIVATE); }
    private static File dir(Context c) { File d = new File(c.getFilesDir(), "profiles"); d.mkdirs(); return d; }
    private static String today() { return new SimpleDateFormat("yyyy-MM-dd", Locale.US).format(new Date()); }

    /** Call once from the app's entry points; cheap after the first time. */
    public static synchronized void init(Context c) {
        if (app != null) return;
        app = c.getApplicationContext();
        reselect();
    }

    /** The profile this phone uses now (built-in until {@link #init} has run). */
    public static DeviceProfile active() { Selection s = current; return s != null ? s.profile : DeviceProfile.detectBuiltIn(); }
    public static Selection selection() { Selection s = current; if (s == null) { s = new Selection(); s.profile = DeviceProfile.detectBuiltIn(); } return s; }
    /** Transmit switched off by an advisory (checked live, so it applies without a restart). */
    public static boolean transmitBlocked() { return active().txBlocked; }

    static JSONObject cachedList(Context c) {
        try {
            File f = new File(dir(c), "profiles.json"), g = new File(dir(c), "profiles.json.sig");
            if (!f.exists() || !g.exists()) return null;
            byte[] data = java.nio.file.Files.readAllBytes(f.toPath());
            if (!verify(data, new String(java.nio.file.Files.readAllBytes(g.toPath()), StandardCharsets.US_ASCII), PUBLIC_KEY)) return null;
            return new JSONObject(new String(data, StandardCharsets.UTF_8));
        } catch (Throwable t) { return null; }
    }

    static synchronized void reselect() {
        Context c = app; if (c == null) return;
        SharedPreferences sp = prefs(c);
        current = select(DeviceProfile.detectBuiltIn(), cachedList(c), PHONE, sp.getBoolean("useBuiltIn", false), new HashSet<>(sp.getStringSet("overrides", new HashSet<>())), today());
    }

    public static boolean useBuiltIn() { Context c = app; return c != null && prefs(c).getBoolean("useBuiltIn", false); }
    public static void setUseBuiltIn(boolean on) { Context c = app; if (c == null) return; prefs(c).edit().putBoolean("useBuiltIn", on).apply(); reselect(); }

    /** The owner re-enables what an advisory switched off (after the two confirmations in the UI), or restores it. */
    public static void setOverride(String advisoryId, boolean overridden) {
        Context c = app; if (c == null) return;
        Set<String> o = new HashSet<>(prefs(c).getStringSet("overrides", new HashSet<>()));
        if (overridden) o.add(advisoryId); else o.remove(advisoryId);
        prefs(c).edit().putStringSet("overrides", o).apply();
        reselect();
    }

    public static long lastCheck() { Context c = app; return c == null ? 0 : prefs(c).getLong("lastCheck", 0); }

    /** Fetch the signed list now (worker thread). @return a one-line result for the owner */
    public static String fetch() {
        Context c = app; if (c == null) return "not ready";
        try {
            com.macdmr.radio.repeaters.HttpClient.Response r = com.macdmr.radio.repeaters.HttpClient.get(LIST_URL + "?t=" + System.currentTimeMillis() / 600_000);
            com.macdmr.radio.repeaters.HttpClient.Response s = com.macdmr.radio.repeaters.HttpClient.get(LIST_URL + ".sig?t=" + System.currentTimeMillis() / 600_000);
            prefs(c).edit().putLong("lastCheck", System.currentTimeMillis()).apply();
            if (!r.isOk() || !s.isOk()) return "Profile list not reachable (HTTP " + r.code + "/" + s.code + "); the profiles on this phone stay in use";
            byte[] data = r.body; String sig = s.bodyUtf8();
            if (!verify(data, sig, PUBLIC_KEY)) return "Profile list ignored: its signature is not valid";
            JSONObject list = new JSONObject(new String(data, StandardCharsets.UTF_8));
            JSONObject old = cachedList(c);
            if (old != null && list.optInt("serial", 0) < old.optInt("serial", 0)) return "Profile list ignored: older than the one on this phone";
            if (old != null && list.optInt("serial", 0) == old.optInt("serial", 0)) return "Profiles are up to date (list " + list.optInt("serial") + ")";
            Set<String> before = advisoryIds(selection());
            java.nio.file.Files.write(new File(dir(c), "profiles.json").toPath(), data);
            java.nio.file.Files.write(new File(dir(c), "profiles.json.sig").toPath(), sig.getBytes(StandardCharsets.US_ASCII));
            reselect();
            Selection now = selection();
            for (Advisory a : now.advisories) if (!before.contains(a.id) && !a.overridden) notifyAdvisory(a);
            return "Profile list " + list.optInt("serial") + " loaded: this phone uses " + describe(now);
        } catch (Throwable t) { return "Profile check failed: " + t.getMessage() + "; the profiles on this phone stay in use"; }
    }

    /** Bench only (adb diagnostics): a signed list from a file, ignoring the serial rule. */
    static String loadForTest(File f) {
        Context c = app; if (c == null) return "not ready";
        try {
            byte[] data = java.nio.file.Files.readAllBytes(f.toPath());
            String sig = new String(java.nio.file.Files.readAllBytes(new File(f.getPath() + ".sig").toPath()), StandardCharsets.US_ASCII);
            if (!verify(data, sig, PUBLIC_KEY)) return "signature not valid";
            Set<String> before = advisoryIds(selection());
            java.nio.file.Files.write(new File(dir(c), "profiles.json").toPath(), data);
            java.nio.file.Files.write(new File(dir(c), "profiles.json.sig").toPath(), sig.getBytes(StandardCharsets.US_ASCII));
            reselect();
            for (Advisory a : selection().advisories) if (!before.contains(a.id) && !a.overridden) notifyAdvisory(a);
            return "loaded: " + describe(selection()) + ", " + selection().advisories.size() + " advisories";
        } catch (Throwable t) { return "failed: " + t; }
    }
    static String clearForTest() {
        Context c = app; if (c == null) return "not ready";
        new File(dir(c), "profiles.json").delete(); new File(dir(c), "profiles.json.sig").delete();
        prefs(c).edit().remove("overrides").remove("lastCheck").apply();
        reselect();
        return "cleared: " + describe(selection());
    }

    /** At most every 12 hours, in the background. */
    public static void maybeFetch() {
        if (System.currentTimeMillis() - lastCheck() < 12 * 3600_000L) return;
        new Thread(() -> android.util.Log.i("ProfileRegistry", fetch()), "profile-check").start();
    }

    private static Set<String> advisoryIds(Selection s) { Set<String> o = new HashSet<>(); for (Advisory a : s.advisories) o.add(a.id); return o; }

    private static void notifyAdvisory(Advisory a) {
        RadioService svc = RadioService.running;
        if (svc != null) svc.notifyUser("SignalDeck advisory: " + a.title, a.restrictionText() + ". " + a.why + " — Device page → Profile to read it or to keep using it anyway.", false);
    }

    public static String describe(Selection s) {
        return s.profile.name + " profile r" + s.profile.revision + " (" + ("updated".equals(s.source) ? "updated from the profile list" : "built in") + ")";
    }
}
