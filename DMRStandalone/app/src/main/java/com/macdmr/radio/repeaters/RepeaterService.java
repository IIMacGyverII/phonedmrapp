package com.macdmr.radio.repeaters;

import android.content.Context;
import android.content.SharedPreferences;
import android.location.Address;
import android.location.Geocoder;
import android.util.Log;

import com.macdmr.radio.ChannelStore;
import com.macdmr.radio.dsp.ToneConverter;
import com.macdmr.radio.repeaters.RepeaterModels.Repeater;
import com.macdmr.radio.repeaters.RepeaterModels.Talkgroup;
import com.macdmr.radio.repeaters.RepeaterPlanner.ChannelSpec;
import com.macdmr.radio.repeaters.RepeaterPlanner.Plan;

import org.json.JSONArray;
import org.json.JSONObject;

import java.io.File;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.Set;

/**
 * Nearby repeaters: BrandMeister (DMR, with talkgroups), hearham (FM) and the RadioID repeater list (DMR,
 * geocoded by city), cached in the app's cache dir, merged and sorted by distance from the phone. Programs a
 * repeater as channels + contacts + a zone through the planner and remembers each install so it can be undone.
 */
public final class RepeaterService {
    private static final String TAG = "Repeaters";
    private static final long DAY = 24L * 3600 * 1000;
    private final Context ctx; private final ChannelStore store;
    private final SharedPreferences prefs;
    private Map<Integer, String> tgNames;

    public RepeaterService(Context c, ChannelStore s) { ctx = c.getApplicationContext(); store = s; prefs = ctx.getSharedPreferences("repeaters", Context.MODE_PRIVATE); }

    // ---- sources --------------------------------------------------------------------------------------

    private String cached(String name, String url, long ttl, boolean force, String accept) {
        File f = new File(ctx.getCacheDir(), name);
        try {
            if (!force && f.exists() && System.currentTimeMillis() - f.lastModified() < ttl) return new String(Files.readAllBytes(f.toPath()), StandardCharsets.UTF_8);
            HttpClient.Response r = HttpClient.get(url, null, 0L, accept);
            if (r.isOk()) { String body = r.bodyUtf8(); Files.write(f.toPath(), body.getBytes(StandardCharsets.UTF_8)); return body; }
            Log.w(TAG, name + ": HTTP " + r.code);
        } catch (Throwable t) { Log.w(TAG, name + ": " + t); }
        try { if (f.exists()) return new String(Files.readAllBytes(f.toPath()), StandardCharsets.UTF_8); } catch (Throwable ignored) { }
        return null;
    }

    /** All known repeaters with distance from {@code lat,lon}, nearest first; only those the radio can tune. */
    public List<Repeater> nearby(double lat, double lon, double radiusKm, boolean force, StringBuilder status) {
        long now = System.currentTimeMillis();
        List<Repeater> bm = new ArrayList<>(), hh = new ArrayList<>(), rid = new ArrayList<>();
        String j = cached("repeaters_bm.json", "https://api.brandmeister.network/v2/device?repeater=true", 7 * DAY, force, "application/json");
        if (j != null) bm = BrandMeisterSource.parseDeviceList(j, now).repeaters; else status.append("BrandMeister unavailable. ");
        j = cached("repeaters_hearham.json", HearhamSource.URL, 30 * DAY, force, "application/json");
        if (j != null) hh = HearhamSource.parse(j, now); else status.append("hearham unavailable. ");
        j = cached("repeaters_radioid.json", RadioIdRepeaterSource.URL, 7 * DAY, force, "application/json");
        if (j != null) rid = RadioIdRepeaterSource.parse(j, now); else status.append("RadioID list unavailable. ");
        geocodeMissing(rid, lat, lon, radiusKm);
        List<Repeater> all = RepeaterCatalog.merge(bm, hh, rid);
        List<Repeater> out = new ArrayList<>();
        for (Repeater r : all) {
            if (!r.hasCoords || !GeoUtil.inRadioRange(r.rxHz)) continue;
            r.distanceMeters = GeoUtil.haversineMeters(lat, lon, r.lat, r.lon);
            if (r.distanceMeters <= radiusKm * 1000) out.add(r);
        }
        out.sort((a, b) -> Double.compare(a.distanceMeters, b.distanceMeters));
        status.append(String.format(Locale.US, "%d BrandMeister, %d hearham, %d RadioID known; %d within %.0f km", bm.size(), hh.size(), rid.size(), out.size(), radiusKm));
        return out;
    }

    /** RadioID rows carry only city/state/country: geocode those whose region looks close (cached forever). */
    private void geocodeMissing(List<Repeater> rows, double lat, double lon, double radiusKm) {
        if (!Geocoder.isPresent()) return;
        String myRegion = null;
        try { List<Address> me = new Geocoder(ctx, Locale.US).getFromLocation(lat, lon, 1); if (me != null && !me.isEmpty()) myRegion = me.get(0).getAdminArea(); } catch (Throwable ignored) { }
        SharedPreferences gc = ctx.getSharedPreferences("geocode", Context.MODE_PRIVATE);
        int budget = 60;
        for (Repeater r : rows) {
            if (r.hasCoords || r.city == null || r.city.trim().isEmpty()) continue;
            String q = (r.city + (r.region != null && !r.region.isEmpty() ? ", " + r.region : "") + (r.country != null && !r.country.isEmpty() ? ", " + r.country : "")).trim();
            String hit = gc.getString(q, null);
            if (hit != null) { String[] p = hit.split(","); if (p.length == 2) { r.lat = Double.parseDouble(p[0]); r.lon = Double.parseDouble(p[1]); r.hasCoords = r.lat != 0 || r.lon != 0; r.approx = true; } continue; }
            if (budget <= 0) continue;
            if (myRegion != null && r.region != null && !r.region.isEmpty() && !r.region.equalsIgnoreCase(myRegion) && !myRegion.toLowerCase(Locale.US).startsWith(r.region.toLowerCase(Locale.US))) continue;
            budget--;
            try {
                List<Address> a = new Geocoder(ctx, Locale.US).getFromLocationName(q, 1);
                if (a != null && !a.isEmpty()) { r.lat = a.get(0).getLatitude(); r.lon = a.get(0).getLongitude(); r.hasCoords = true; r.approx = true; gc.edit().putString(q, r.lat + "," + r.lon).apply(); }
                else gc.edit().putString(q, "0,0").apply();
            } catch (Throwable t) { budget = 0; }
        }
    }

    public List<Talkgroup> talkgroups(Repeater r) {
        if (!r.talkgroups.isEmpty()) return r.talkgroups;
        if (r.dmrId <= 0) return new ArrayList<>();
        try { r.talkgroups.addAll(BrandMeisterSource.fetchDeviceTalkgroups(r.dmrId)); } catch (Throwable t) { Log.w(TAG, "talkgroups: " + t); }
        Map<Integer, String> names = tgNames();
        for (Talkgroup tg : r.talkgroups) if ((tg.name == null || tg.name.isEmpty()) && names.containsKey(tg.id)) tg.name = names.get(tg.id);
        return r.talkgroups;
    }

    public synchronized Map<Integer, String> tgNames() {
        if (tgNames != null) return tgNames;
        String j = cached("repeaters_tgnames.json", "https://api.brandmeister.network/v2/talkgroup", 30 * DAY, false, "application/json");
        tgNames = j != null ? BrandMeisterSource.parseTalkgroupNames(j) : new HashMap<>();
        return tgNames;
    }

    // ---- programming -----------------------------------------------------------------------------------

    public Plan plan(Repeater r, Set<Integer> talkTgs) { return RepeaterPlanner.plan(r, talkTgs, tgNames()); }

    public static String preview(Plan p) {
        StringBuilder sb = new StringBuilder();
        for (ChannelSpec c : p.channels) sb.append(c.isFm() ? "📻 " : "talk".equals(c.role) ? "🗣 " : "👂 ").append(c.name).append(c.isFm() ? "" : "  TS" + (c.slotIndex + 1) + " TG " + c.txContact).append('\n');
        if (!p.contactsNeeded.isEmpty()) sb.append(p.contactsNeeded.size()).append(" talkgroup contacts\n");
        sb.append("Zone \"").append(p.zoneName).append("\"");
        for (String w : p.warnings) sb.append("\n⚠ ").append(w);
        return sb.toString();
    }

    /** Create the plan's contacts, channels and zone; remembered for {@link #undo}. Returns a summary. */
    public String program(Repeater r, Plan plan) {
        JSONObject run = new JSONObject();
        List<Long> chIds = new ArrayList<>(); List<Integer> contactsMade = new ArrayList<>();
        try {
            Map<Integer, String> have = new HashMap<>(); for (ChannelStore.Contact c : store.contacts()) have.put(c.number, c.name);
            for (Map.Entry<Integer, String> e : plan.contactsNeeded.entrySet()) {
                if (have.containsKey(e.getKey())) continue;
                ChannelStore.Contact c = new ChannelStore.Contact(); c.number = e.getKey(); c.type = 1; c.name = e.getValue();
                store.insertContact(c); contactsMade.add(c.number);
            }
            ChannelStore.Zone zone = null; for (ChannelStore.Zone z : store.zones()) if (z.name.equals(plan.zoneName)) zone = z;
            boolean zoneCreated = zone == null;
            if (zone == null) { zone = new ChannelStore.Zone(); zone.name = plan.zoneName; zone.numbers = new int[0]; zone.id = store.saveZone(zone); }
            List<Integer> nums = new ArrayList<>(); for (int n : zone.numbers) nums.add(n);
            for (ChannelSpec c : plan.channels) {
                ChannelStore.Channel ch = new ChannelStore.Channel();
                ch.name = c.name; ch.type = c.type; ch.rxFreq = (int) c.rxHz; ch.txFreq = (int) c.txHz; ch.power = 1; ch.relay = 2; ch.sq = 2;
                if (c.isFm()) {
                    ch.band = c.rxHz < 300_000_000L ? 1 : c.bandwidth; ch.interrupt = 0; ch.contactType = 0; ch.encryptSw = 2;
                    try { ch.rxType = ToneConverter.parseType(c.toneDown); ch.rxSubCode = ch.rxType == 0 ? 0 : ToneConverter.parseSubCode(c.toneDown); } catch (Throwable ignored) { }
                    try { ch.txType = ToneConverter.parseType(c.toneUp); ch.txSubCode = ch.txType == 0 ? 0 : ToneConverter.parseSubCode(c.toneUp); } catch (Throwable ignored) { }
                } else {
                    ch.band = 1; ch.cc = c.cc; ch.inSlot = ch.outSlot = c.slotIndex; ch.mode = 4; ch.contactType = 1; ch.txContact = c.txContact; ch.groups = c.groups.clone(); ch.interrupt = 2; ch.encryptSw = 2;
                }
                long id = store.insert(ch); chIds.add(id);
                nums.add(ch.number);
            }
            zone.numbers = new int[nums.size()]; for (int i = 0; i < nums.size(); i++) zone.numbers[i] = nums.get(i);
            store.saveZone(zone);
            run.put("runId", System.currentTimeMillis()); run.put("callsign", r.callsign); run.put("key", r.key); run.put("zoneId", zone.id); run.put("zoneCreated", zoneCreated);
            run.put("channels", new JSONArray(chIds)); run.put("contacts", new JSONArray(contactsMade)); run.put("name", plan.zoneName);
            JSONArray runs = new JSONArray(prefs.getString("runs", "[]")); runs.put(run); while (runs.length() > 25) runs.remove(0);
            prefs.edit().putString("runs", runs.toString()).apply();
            return plan.channels.size() + " channel" + (plan.channels.size() == 1 ? "" : "s") + (contactsMade.isEmpty() ? "" : ", " + contactsMade.size() + " contacts") + " added in zone \"" + plan.zoneName + "\"";
        } catch (Throwable t) { Log.w(TAG, "program: " + t); return "Failed: " + t.getMessage(); }
    }

    public static final class Run { public long id; public String name, callsign; }
    public List<Run> runs() {
        List<Run> out = new ArrayList<>();
        try { JSONArray a = new JSONArray(prefs.getString("runs", "[]")); for (int i = a.length() - 1; i >= 0; i--) { JSONObject o = a.getJSONObject(i); Run r = new Run(); r.id = o.getLong("runId"); r.name = o.optString("name"); r.callsign = o.optString("callsign"); out.add(r); } } catch (Throwable ignored) { }
        return out;
    }

    /** Remove everything an install created (channels by id, contacts it added, the zone if it made it). */
    public String undo(long runId) {
        try {
            JSONArray a = new JSONArray(prefs.getString("runs", "[]")); JSONArray keep = new JSONArray(); JSONObject run = null;
            for (int i = 0; i < a.length(); i++) { JSONObject o = a.getJSONObject(i); if (o.getLong("runId") == runId) run = o; else keep.put(o); }
            if (run == null) return "Not found";
            int removed = 0;
            JSONArray ch = run.getJSONArray("channels");
            for (int i = 0; i < ch.length(); i++) { long id = ch.getLong(i); for (ChannelStore.Channel c : store.all()) if (c.id == id) { store.delete(c); removed++; break; } }
            JSONArray ct = run.getJSONArray("contacts");
            for (int i = 0; i < ct.length(); i++) { int n = ct.getInt(i); for (ChannelStore.Contact c : store.contacts()) if (c.number == n) { store.deleteContact(c); break; } }
            long zoneId = run.optLong("zoneId", 0);
            if (zoneId > 0) {
                ChannelStore.Zone z = store.zone(zoneId);
                if (z != null) {
                    if (run.optBoolean("zoneCreated")) store.deleteZone(zoneId);
                    else { List<Integer> nums = new ArrayList<>(); Map<Integer, Boolean> exists = new HashMap<>(); for (ChannelStore.Channel c : store.all()) exists.put(c.number, true); for (int n : z.numbers) if (exists.containsKey(n)) nums.add(n); z.numbers = new int[nums.size()]; for (int i = 0; i < nums.size(); i++) z.numbers[i] = nums.get(i); store.saveZone(z); }
                }
            }
            prefs.edit().putString("runs", keep.toString()).apply();
            return removed + " channels removed (" + run.optString("callsign") + ")";
        } catch (Throwable t) { return "Failed: " + t.getMessage(); }
    }
}
