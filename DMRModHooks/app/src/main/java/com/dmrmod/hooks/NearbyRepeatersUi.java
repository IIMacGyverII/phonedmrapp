package com.dmrmod.hooks;

import android.app.Activity;
import android.app.AlertDialog;
import android.content.Context;
import android.location.Address;
import android.location.Geocoder;
import android.location.Location;
import android.location.LocationListener;
import android.location.LocationManager;
import android.os.Bundle;
import android.os.Looper;
import android.view.Gravity;
import android.view.View;
import android.view.ViewGroup;
import android.widget.AdapterView;
import android.widget.ArrayAdapter;
import android.widget.Button;
import android.widget.CheckBox;
import android.widget.CompoundButton;
import android.widget.ScrollView;
import android.widget.LinearLayout;
import android.widget.ListView;
import android.widget.TextView;
import android.widget.Toast;

import com.dmrmod.hooks.RepeaterModels.Repeater;
import com.dmrmod.hooks.RepeaterModels.Talkgroup;

import java.io.File;
import java.io.FileOutputStream;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.LinkedHashMap;
import java.util.LinkedHashSet;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.Set;

import android.widget.EditText;

import de.robv.android.xposed.XposedBridge;
import de.robv.android.xposed.XposedHelpers;

/**
 * Nearby Repeaters dialog — Phase 0 (chapter 16 §2, P0.4).
 *
 * <p>Minimal listen-only view: last-known location, a BrandMeister catalog (cached in the app's
 * private cache dir, fetched once over Wi-Fi), a radius filter and a distance-sorted list. No
 * channels are written and the radio is never touched; selecting/installing is Phase 1.
 */
public final class NearbyRepeatersUi {

    private static final String TAG = "DMRModHooks";
    private static final String CACHE_FILE = "nearby_bm_device.json";
    private static final long CATALOG_TTL_MS = 24L * 60 * 60 * 1000; // 24 h
    private static final int[] RADII_KM = {10, 25, 50, 100, 200};
    private static final int DEFAULT_RADIUS_KM = 50;
    private static final long FRESH_FIX_TIMEOUT_MS = 12000;

    // dialog state
    private final Activity activity;
    private double myLat, myLon;
    private boolean haveLocation;
    private int radiusKm = DEFAULT_RADIUS_KM;
    private boolean showDmr = true, showFm = true, inRangeOnly = true, hideStale = false;
    private final List<Repeater> all = new ArrayList<>();
    private long catalogFetchedAt;

    private TextView statusView;
    private ArrayAdapter<String> adapter;
    private final List<String> rows = new ArrayList<>();
    private final List<Repeater> shownReps = new ArrayList<>();
    private volatile Map<Integer, String> tgNames;
    private Runnable manualCommit;   // non-null while the manual-TG builder is showing
    private final Map<String, double[]> geocodeCache = new java.util.HashMap<>();
    private volatile boolean geocodeCacheLoaded;
    private volatile String userRegion, userCountry;
    private static final int GEOCODE_CAP = 160;   // bound per load; results are cached

    private NearbyRepeatersUi(Activity activity) {
        this.activity = activity;
    }

    /** Device-tab entry point. */
    public static void show(Activity activity) {
        try {
            new NearbyRepeatersUi(activity).open();
        } catch (Throwable t) {
            XposedBridge.log(TAG + ": NearbyRepeatersUi.show failed: " + t);
            Toast.makeText(activity, "Nearby Repeaters failed to open: " + t.getMessage(),
                Toast.LENGTH_LONG).show();
        }
    }

    private void open() {
        Context ctx = activity;
        resolveLocation();

        LinearLayout root = new LinearLayout(ctx);
        root.setOrientation(LinearLayout.VERTICAL);
        int pad = dp(ctx, 12);
        root.setPadding(pad, pad, pad, pad);

        statusView = new TextView(ctx);
        statusView.setTextSize(12);
        statusView.setTextColor(0xFFBBBBBB);
        statusView.setPadding(0, 0, 0, dp(ctx, 8));
        root.addView(statusView);

        // radius chips
        LinearLayout chipRow = new LinearLayout(ctx);
        chipRow.setOrientation(LinearLayout.HORIZONTAL);
        for (final int km : RADII_KM) {
            final Button b = new Button(ctx);
            b.setText(km + " km");
            b.setAllCaps(false);
            b.setTextSize(13);
            LinearLayout.LayoutParams lp = new LinearLayout.LayoutParams(
                0, ViewGroup.LayoutParams.WRAP_CONTENT, 1f);
            b.setLayoutParams(lp);
            b.setOnClickListener(new View.OnClickListener() {
                @Override public void onClick(View v) {
                    radiusKm = km;
                    applyFilterAndRender();
                }
            });
            chipRow.addView(b);
        }
        root.addView(chipRow);

        // mode / filter toggles
        LinearLayout filterRow = new LinearLayout(ctx);
        filterRow.setOrientation(LinearLayout.HORIZONTAL);
        addToggle(ctx, filterRow, "DMR", showDmr, new ToggleSink() { public void set(boolean v) { showDmr = v; } });
        addToggle(ctx, filterRow, "FM", showFm, new ToggleSink() { public void set(boolean v) { showFm = v; } });
        addToggle(ctx, filterRow, "In-range", inRangeOnly, new ToggleSink() { public void set(boolean v) { inRangeOnly = v; } });
        addToggle(ctx, filterRow, "Hide stale", hideStale, new ToggleSink() { public void set(boolean v) { hideStale = v; } });
        root.addView(filterRow);

        ListView list = new ListView(ctx);
        adapter = new ArrayAdapter<>(ctx, android.R.layout.simple_list_item_1, rows);
        list.setAdapter(adapter);
        list.setOnItemClickListener(new AdapterView.OnItemClickListener() {
            @Override public void onItemClick(AdapterView<?> parent, View v, int position, long id) {
                Repeater rep = position < shownReps.size() ? shownReps.get(position) : null;
                if (rep != null) openRepeater(rep);
            }
        });
        LinearLayout.LayoutParams listLp = new LinearLayout.LayoutParams(
            ViewGroup.LayoutParams.MATCH_PARENT, dp(ctx, 380));
        list.setLayoutParams(listLp);
        root.addView(list);

        TextView footer = new TextView(ctx);
        footer.setText("Data: BrandMeister · RadioID · hearham  ·  tap for sources");
        footer.setTextSize(11);
        footer.setTextColor(0xFF7FA8D0);
        footer.setPadding(0, dp(ctx, 8), 0, 0);
        footer.setOnClickListener(new View.OnClickListener() {
            @Override public void onClick(View v) { showAboutSources(); }
        });
        root.addView(footer);

        AlertDialog dialog = new AlertDialog.Builder(activity)
            .setTitle("📡 Nearby Repeaters")
            .setView(root)
            .setNeutralButton("Refresh", null)   // overridden below so it does not dismiss
            .setPositiveButton("Close", null)
            .create();
        dialog.show();
        // keep Refresh from dismissing the dialog
        dialog.getButton(AlertDialog.BUTTON_NEUTRAL).setOnClickListener(new View.OnClickListener() {
            @Override public void onClick(View v) { loadCatalog(true); }
        });

        setStatus("Loading catalog…");
        loadCatalog(false);
        requestFreshFix();
    }

    private void resolveLocation() {
        try {
            LocationManager lm = (LocationManager) activity.getSystemService(Context.LOCATION_SERVICE);
            if (lm == null) return;
            Location best = null;
            for (String provider : new String[]{LocationManager.GPS_PROVIDER, LocationManager.NETWORK_PROVIDER}) {
                try {
                    if (!lm.isProviderEnabled(provider)) continue;
                    Location l = lm.getLastKnownLocation(provider);
                    if (l == null) continue;
                    if (best == null || l.getTime() > best.getTime()) best = l;
                } catch (SecurityException se) {
                    XposedBridge.log(TAG + ": location permission denied for " + provider);
                }
            }
            if (best != null) {
                myLat = best.getLatitude();
                myLon = best.getLongitude();
                haveLocation = true;
            }
        } catch (Throwable t) {
            XposedBridge.log(TAG + ": resolveLocation failed: " + t);
        }
    }

    /**
     * P0.5: one-shot fresh GPS/network fix with a timeout. The dialog shows the last-known fix
     * immediately (resolveLocation); this upgrades it to a current fix when one arrives, then stops
     * listening. The OEM process holds ACCESS_FINE_LOCATION (SYSTEM_FIXED), confirmed on device.
     */
    private void requestFreshFix() {
        activity.runOnUiThread(new Runnable() {
            @Override public void run() {
                try {
                    final LocationManager lm =
                        (LocationManager) activity.getSystemService(Context.LOCATION_SERVICE);
                    if (lm == null) return;
                    final LocationListener[] holder = new LocationListener[1];
                    final boolean[] done = {false};
                    final LocationListener listener = new LocationListener() {
                        @Override public void onLocationChanged(Location loc) {
                            if (done[0] || loc == null) return;
                            done[0] = true;
                            myLat = loc.getLatitude();
                            myLon = loc.getLongitude();
                            haveLocation = true;
                            XposedBridge.log(TAG + ": Nearby: fresh fix " + myLat + "," + myLon);
                            try { lm.removeUpdates(this); } catch (Throwable ignore) { }
                            applyFilterAndRender();
                        }
                        @Override public void onProviderDisabled(String p) { }
                        @Override public void onProviderEnabled(String p) { }
                        @Override public void onStatusChanged(String p, int st, Bundle ex) { }
                    };
                    holder[0] = listener;
                    boolean requested = false;
                    for (String provider : new String[]{LocationManager.GPS_PROVIDER, LocationManager.NETWORK_PROVIDER}) {
                        try {
                            if (lm.isProviderEnabled(provider)) {
                                lm.requestLocationUpdates(provider, 0L, 0f, listener, Looper.getMainLooper());
                                requested = true;
                            }
                        } catch (SecurityException se) {
                            XposedBridge.log(TAG + ": fresh-fix permission denied for " + provider);
                        } catch (Throwable t) {
                            XposedBridge.log(TAG + ": fresh-fix request failed on " + provider + ": " + t);
                        }
                    }
                    if (!requested) return;
                    // stop listening after the timeout whether or not a fix arrived
                    statusView.postDelayed(new Runnable() {
                        @Override public void run() {
                            if (done[0]) return;
                            done[0] = true;
                            try { lm.removeUpdates(holder[0]); } catch (Throwable ignore) { }
                            XposedBridge.log(TAG + ": Nearby: fresh fix timed out, keeping last-known");
                        }
                    }, FRESH_FIX_TIMEOUT_MS);
                } catch (Throwable t) {
                    XposedBridge.log(TAG + ": requestFreshFix failed: " + t);
                }
            }
        });
    }

    /** Non-BM DMR source: RadioID rptrs.json, cached 7 days. Best-effort; [] on any failure. */
    private java.util.List<Repeater> loadRadioId(boolean forceRefresh) {
        File cache = new File(activity.getCacheDir(), "nearby_radioid.json");
        try {
            long ttl = 7L * 24 * 60 * 60 * 1000;
            String json;
            if (!forceRefresh && cache.exists()
                    && (System.currentTimeMillis() - cache.lastModified()) < ttl) {
                json = readFile(cache);
            } else {
                HttpClient.Response r = HttpClient.get(RadioIdRepeaterSource.URL, null, 0L, "application/json");
                if (r.isOk()) { json = r.bodyUtf8(); try { writeFile(cache, json); } catch (Throwable ignore) { } }
                else if (cache.exists()) json = readFile(cache);
                else return new java.util.ArrayList<>();
            }
            java.util.List<Repeater> all = RadioIdRepeaterSource.parse(json);
            XposedBridge.log(TAG + ": Nearby: RadioID rows " + all.size());
            return all;
        } catch (Throwable t) {
            XposedBridge.log(TAG + ": RadioID load failed: " + t);
            return new java.util.ArrayList<>();
        }
    }

    /**
     * Fill coordinates for coordless rows in the user's region by geocoding their city, bounded and
     * cached (RadioID carries no lat/lon). Returns how many were newly placed. Needs network, so it
     * is a best-effort second pass; failures just leave the row off the distance list.
     */
    private int geocodeMissing(java.util.List<Repeater> list) {
        if (!haveLocation) return 0;
        Geocoder gc;
        try { gc = new Geocoder(activity, Locale.US); } catch (Throwable t) { return 0; }
        if (!Geocoder.isPresent()) return 0;
        loadGeocodeCache();
        ensureUserRegion(gc);
        int placed = 0, calls = 0;
        boolean cacheDirty = false;
        for (Repeater r : list) {
            if (r.hasCoords) continue;
            if (isEmpty(r.city)) continue;
            // only place repeaters plausibly near the user: same region, or same country if region unknown
            if (userRegion != null && r.region != null && !userRegion.equalsIgnoreCase(r.region)) continue;
            if (userRegion == null && userCountry != null && r.country != null
                    && !userCountry.equalsIgnoreCase(r.country)) continue;
            String q = geoQuery(r.city, r.region, r.country);
            double[] ll = geocodeCache.get(q);
            if (ll == null) {
                if (calls >= GEOCODE_CAP) continue;
                calls++;
                ll = geocodeOnce(gc, q);
                geocodeCache.put(q, ll != null ? ll : new double[]{Double.NaN, Double.NaN});
                cacheDirty = true;
            }
            if (ll != null && !Double.isNaN(ll[0])) {
                r.lat = ll[0]; r.lon = ll[1]; r.hasCoords = true; r.approx = true;
                placed++;
            }
        }
        if (cacheDirty) saveGeocodeCache();
        XposedBridge.log(TAG + ": Nearby: geocoded " + placed + " RadioID rows (" + calls + " lookups)");
        return placed;
    }

    private void ensureUserRegion(Geocoder gc) {
        if (userRegion != null || userCountry != null) return;
        try {
            java.util.List<Address> a = gc.getFromLocation(myLat, myLon, 1);
            if (a != null && !a.isEmpty()) {
                userRegion = a.get(0).getAdminArea();
                userCountry = a.get(0).getCountryName();
                XposedBridge.log(TAG + ": Nearby: user region " + userRegion + ", " + userCountry);
            }
        } catch (Throwable ignore) { }
    }

    private double[] geocodeOnce(Geocoder gc, String query) {
        try {
            java.util.List<Address> a = gc.getFromLocationName(query, 1);
            if (a != null && !a.isEmpty() && a.get(0).hasLatitude() && a.get(0).hasLongitude()) {
                return new double[]{a.get(0).getLatitude(), a.get(0).getLongitude()};
            }
        } catch (Throwable ignore) { }
        return null;
    }

    private static String geoQuery(String city, String region, String country) {
        StringBuilder sb = new StringBuilder(city.trim());
        if (region != null && !region.trim().isEmpty()) sb.append(", ").append(region.trim());
        if (country != null && !country.trim().isEmpty()) sb.append(", ").append(country.trim());
        return sb.toString();
    }

    private void loadGeocodeCache() {
        if (geocodeCacheLoaded) return;
        geocodeCacheLoaded = true;
        try {
            File f = new File(activity.getFilesDir(), "dmrmod_geocode_cache.json");
            if (!f.exists()) return;
            org.json.JSONObject o = new org.json.JSONObject(readFile(f));
            for (java.util.Iterator<String> it = o.keys(); it.hasNext(); ) {
                String k = it.next();
                String v = o.optString(k, null);
                if (v == null) continue;
                String[] p = v.split(",");
                if (p.length == 2) {
                    try { geocodeCache.put(k, new double[]{Double.parseDouble(p[0]), Double.parseDouble(p[1])}); }
                    catch (Exception ignore) { }
                }
            }
        } catch (Throwable ignore) { }
    }

    private void saveGeocodeCache() {
        try {
            org.json.JSONObject o = new org.json.JSONObject();
            for (Map.Entry<String, double[]> e : geocodeCache.entrySet()) {
                double[] v = e.getValue();
                o.put(e.getKey(), (Double.isNaN(v[0]) ? "nan,nan" : v[0] + "," + v[1]));
            }
            writeFile(new File(activity.getFilesDir(), "dmrmod_geocode_cache.json"), o.toString());
        } catch (Throwable ignore) { }
    }

    private static boolean isEmpty(String s) { return s == null || s.trim().isEmpty(); }

    /** FM source: hearham, cached 30 days in the private cache. Best-effort; [] on any failure. */
    private java.util.List<Repeater> loadHearham(boolean forceRefresh) {
        File cache = new File(activity.getCacheDir(), "nearby_hearham.json");
        try {
            long ttl = 30L * 24 * 60 * 60 * 1000;
            String json;
            if (!forceRefresh && cache.exists()
                    && (System.currentTimeMillis() - cache.lastModified()) < ttl) {
                json = readFile(cache);
            } else {
                HttpClient.Response r = HttpClient.get(HearhamSource.URL, null, 0L, "application/json");
                if (r.isOk()) { json = r.bodyUtf8(); try { writeFile(cache, json); } catch (Throwable ignore) { } }
                else if (cache.exists()) json = readFile(cache);
                else return new java.util.ArrayList<>();
            }
            java.util.List<Repeater> all = HearhamSource.parse(json);
            // keep only FM with coordinates (the catalog already has BM for DMR)
            java.util.List<Repeater> fm = new java.util.ArrayList<>();
            for (Repeater r : all) if (r.fm && !r.dmr && r.hasCoords) fm.add(r);
            XposedBridge.log(TAG + ": Nearby: hearham FM rows " + fm.size() + " of " + all.size());
            return fm;
        } catch (Throwable t) {
            XposedBridge.log(TAG + ": hearham load failed: " + t);
            return new java.util.ArrayList<>();
        }
    }

    /** Load from the private cache if fresh (unless forced), else fetch over the network. */
    private void loadCatalog(final boolean forceRefresh) {
        final File cache = new File(activity.getCacheDir(), CACHE_FILE);
        new Thread(new Runnable() {
            @Override public void run() {
                String json = null;
                long fetchedAt = 0;
                try {
                    boolean cacheFresh = cache.exists()
                        && (System.currentTimeMillis() - cache.lastModified()) < CATALOG_TTL_MS;
                    if (!forceRefresh && cacheFresh) {
                        json = readFile(cache);
                        fetchedAt = cache.lastModified();
                        XposedBridge.log(TAG + ": Nearby: using cached catalog (" + cache.length() + " bytes)");
                    } else {
                        postStatus(forceRefresh ? "Refreshing catalog…" : "Downloading catalog…");
                        HttpClient.Response r = HttpClient.get(
                            BrandMeisterSource.DEVICE_LIST_URL, null, 0L, "application/json");
                        if (r.isOk()) {
                            json = r.bodyUtf8();
                            fetchedAt = System.currentTimeMillis();
                            writeFile(cache, json);
                            XposedBridge.log(TAG + ": Nearby: fetched catalog (" + json.length() + " bytes)");
                        } else if (cache.exists()) {
                            json = readFile(cache);
                            fetchedAt = cache.lastModified();
                            XposedBridge.log(TAG + ": Nearby: fetch HTTP " + r.code + ", using stale cache");
                        } else {
                            throw new Exception("HTTP " + r.code + " and no cache");
                        }
                    }
                } catch (final Throwable t) {
                    XposedBridge.log(TAG + ": Nearby catalog load failed: " + t);
                    postStatus("Catalog unavailable: " + t.getMessage()
                        + (haveLocation ? "" : " · also no location fix"));
                    return;
                }

                BrandMeisterSource.ParseResult pr = BrandMeisterSource.parseDeviceList(json, fetchedAt);
                java.util.List<Repeater> hearham = loadHearham(forceRefresh);   // FM (cached)
                java.util.List<Repeater> radioid = loadRadioId(forceRefresh);   // non-BM DMR (cached)
                final java.util.List<Repeater> merged =
                    RepeaterCatalog.merge(pr.repeaters, radioid, hearham);
                synchronized (all) {
                    all.clear();
                    all.addAll(merged);
                    catalogFetchedAt = fetchedAt;
                }
                XposedBridge.log(TAG + ": Nearby: BM " + pr.repeaters.size() + " + RadioID "
                    + radioid.size() + " + hearham " + hearham.size() + " -> merged " + merged.size());
                activity.runOnUiThread(new Runnable() {
                    @Override public void run() { applyFilterAndRender(); }
                });
                // second pass: place RadioID-only rows that have no coordinates (geocode their city),
                // then re-render so non-BrandMeister DMR repeaters near you appear.
                int placed = geocodeMissing(merged);
                if (placed > 0) {
                    activity.runOnUiThread(new Runnable() {
                        @Override public void run() { applyFilterAndRender(); }
                    });
                }
            }
        }, "nearby-catalog").start();
    }

    private boolean passesFilters(Repeater r) {
        if (r.dmr && !showDmr) return false;
        if (r.fm && !r.dmr && !showFm) return false;
        if (inRangeOnly && !GeoUtil.inRadioRange(r.rxHz)) return false;
        if (hideStale && r.status != null && r.status.toLowerCase(Locale.US).contains("not operational")) return false;
        return true;
    }

    private void applyFilterAndRender() {
        List<Repeater> matched = new ArrayList<>();
        int withCoords = 0;
        synchronized (all) {
            for (Repeater r : all) {
                if (!r.hasCoords) continue;
                withCoords++;
                if (!passesFilters(r)) continue;
                if (haveLocation) {
                    r.distanceMeters = GeoUtil.haversineMeters(myLat, myLon, r.lat, r.lon);
                    if (r.distanceMeters <= radiusKm * 1000.0) matched.add(r);
                }
            }
        }
        if (haveLocation) {
            Collections.sort(matched, new Comparator<Repeater>() {
                @Override public int compare(Repeater a, Repeater b) {
                    return Double.compare(a.distanceMeters, b.distanceMeters);
                }
            });
        }

        rows.clear();
        shownReps.clear();
        if (!haveLocation) {
            rows.add("No location fix yet. Enable Location (GPS) and reopen.");
            rows.add("Catalog holds " + withCoords + " repeaters with coordinates.");
        } else if (matched.isEmpty()) {
            rows.add("No BrandMeister repeaters within " + radiusKm + " km.");
            rows.add("Try a larger radius above.");
        } else {
            for (Repeater r : matched) {
                rows.add(formatRow(r));
                shownReps.add(r);
            }
        }
        while (shownReps.size() < rows.size()) shownReps.add(null);
        if (adapter != null) adapter.notifyDataSetChanged();
        setStatus(buildStatus(matched.size(), withCoords));
    }

    private String formatRow(Repeater r) {
        String dist = GeoUtil.formatDistanceWithArrow(myLat, myLon, r.lat, r.lon);
        String approx = r.approx ? "  ~approx" : "";
        String mode = r.dmr ? ("DMR " + (r.cc >= 0 ? "CC" + r.cc : "CC?")) : "FM";
        return String.format(Locale.US, "%s   %s\n%s MHz  %s  %s%s",
            r.callsign, dist, r.rxMhzString(), mode, nz(r.city), approx);
    }

    private String buildStatus(int shown, int withCoords) {
        StringBuilder sb = new StringBuilder();
        if (haveLocation) {
            sb.append(String.format(Locale.US, "📍 %.4f, %.4f", myLat, myLon));
        } else {
            sb.append("📍 no fix");
        }
        sb.append("  ·  radius ").append(radiusKm).append(" km");
        sb.append("  ·  ").append(shown).append(" shown / ").append(withCoords).append(" located");
        if (catalogFetchedAt > 0) {
            long ageMin = (System.currentTimeMillis() - catalogFetchedAt) / 60000;
            sb.append("  ·  catalog ").append(ageMin < 1 ? "just now" : ageMin + " min old");
        }
        return sb.toString();
    }

    // ---------------------------------------------------------------- helpers

    // ---------------------------------------------------------------- per-repeater expand + install

    private void ensureTgNames() {
        if (tgNames != null) return;
        File cache = new File(activity.getCacheDir(), "nearby_bm_tgnames.json");
        try {
            long ttl = 7L * 24 * 60 * 60 * 1000;
            if (cache.exists() && (System.currentTimeMillis() - cache.lastModified()) < ttl) {
                tgNames = BrandMeisterSource.parseTalkgroupNames(readFile(cache));
            } else {
                Map<Integer, String> m = BrandMeisterSource.fetchTalkgroupNames();
                tgNames = m;
                try { writeNameCache(cache, m); } catch (Throwable ignore) { }
            }
        } catch (Throwable t) {
            XposedBridge.log(TAG + ": TG names unavailable: " + t);
            if (tgNames == null) tgNames = new LinkedHashMap<>();
        }
    }

    private static void writeNameCache(File f, Map<Integer, String> m) throws Exception {
        org.json.JSONObject o = new org.json.JSONObject();
        for (Map.Entry<Integer, String> e : m.entrySet()) o.put(String.valueOf(e.getKey()), e.getValue());
        writeFile(f, o.toString());
    }

    private void openRepeater(final Repeater rep) {
        if (!GeoUtil.inRadioRange(rep.rxHz)) {
            Toast.makeText(activity, rep.rxMhzString() + " MHz is outside the radio's range (VHF/UHF).",
                Toast.LENGTH_LONG).show();
            return;
        }
        if (rep.fm && !rep.dmr) { doInstall(rep, new LinkedHashSet<Integer>()); return; }
        final Context ctx = activity;
        final LinearLayout box = new LinearLayout(ctx);
        box.setOrientation(LinearLayout.VERTICAL);
        int pad = dp(ctx, 12);
        box.setPadding(pad, pad, pad, pad);
        final TextView head = new TextView(ctx);
        head.setText("Loading talkgroups...");
        head.setTextColor(0xFFDDDDDD);
        head.setTextSize(13);
        box.addView(head);
        ScrollView scroll = new ScrollView(ctx);
        scroll.addView(box);

        final AlertDialog dlg = new AlertDialog.Builder(activity)
            .setTitle(rep.callsign + "  " + rep.rxMhzString() + " MHz  CC" + (rep.cc >= 0 ? rep.cc : "?"))
            .setView(scroll)
            .setPositiveButton("Install", null)
            .setNegativeButton("Cancel", null)
            .create();
        dlg.show();
        dlg.getButton(AlertDialog.BUTTON_POSITIVE).setEnabled(false);

        final Set<Integer> selected = new LinkedHashSet<>();
        final TextView[] previewRef = new TextView[1];

        new Thread(new Runnable() {
            @Override public void run() {
                ensureTgNames();
                // RadioID-sourced repeaters already carry their talkgroups; only fetch from
                // BrandMeister when the merged record has none and is actually a BM device.
                if (rep.talkgroups.isEmpty()
                        && (rep.sources & RepeaterModels.SRC_BRANDMEISTER) != 0) {
                    try {
                        List<Talkgroup> tgs = BrandMeisterSource.fetchDeviceTalkgroups(rep.dmrId);
                        rep.talkgroups.clear();
                        rep.talkgroups.addAll(tgs);
                    } catch (final Throwable t) {
                        activity.runOnUiThread(new Runnable() { @Override public void run() {
                            head.setText("Could not load talkgroups: " + t.getMessage());
                        }});
                        return;
                    }
                }
                for (Talkgroup tg : rep.talkgroups) if (tg.name == null) tg.name = tgNames.get(tg.id);
                activity.runOnUiThread(new Runnable() { @Override public void run() {
                    populateRepeaterDialog(ctx, box, head, rep, selected, previewRef, dlg);
                }});
            }
        }, "nearby-tgs").start();

        dlg.getButton(AlertDialog.BUTTON_POSITIVE).setOnClickListener(new View.OnClickListener() {
            @Override public void onClick(View v) {
                if (manualCommit != null) { manualCommit.run(); return; }
                dlg.dismiss();
                doInstall(rep, new LinkedHashSet<Integer>(selected));
            }
        });
    }

    private void populateRepeaterDialog(Context ctx, LinearLayout box, TextView head, final Repeater rep,
                                        final Set<Integer> selected, final TextView[] previewRef,
                                        final AlertDialog dlg) {
        if (rep.talkgroups.isEmpty()) {
            buildManualTgUi(ctx, box, head, rep, selected, previewRef, dlg);
            return;
        }
        manualCommit = null;   // normal transmit-selection mode; the dialog button installs
        dlg.getButton(AlertDialog.BUTTON_POSITIVE).setText("Install");
        head.setText("Tick any talkgroups you also want to transmit on. Each adds one channel; "
            + "all of a slot's talkgroups are received anyway.");
        int lastSlot = -1;
        for (final Talkgroup tg : rep.talkgroups) {
            int slot = tg.slot == 2 ? 2 : 1;
            if (slot != lastSlot) {
                lastSlot = slot;
                TextView sh = new TextView(ctx);
                sh.setText("Timeslot " + slot);
                sh.setTextColor(0xFF88AACC);
                sh.setTextSize(12);
                sh.setPadding(0, dp(ctx, 8), 0, dp(ctx, 2));
                box.addView(sh);
            }
            final CheckBox cb = new CheckBox(ctx);
            String nm = tg.name != null ? tg.name : ("TG " + tg.id);
            cb.setText(nm + "  (" + tg.id + ")");
            cb.setTextColor(0xFFEEEEEE);
            cb.setOnCheckedChangeListener(new CompoundButton.OnCheckedChangeListener() {
                @Override public void onCheckedChanged(CompoundButton b, boolean checked) {
                    if (checked) selected.add(tg.id); else selected.remove(tg.id);
                    updatePreview(rep, selected, previewRef[0]);
                }
            });
            box.addView(cb);
        }
        TextView preview = new TextView(ctx);
        preview.setTextColor(0xFFBBBBBB);
        preview.setTextSize(12);
        preview.setPadding(0, dp(ctx, 10), 0, 0);
        box.addView(preview);
        previewRef[0] = preview;
        updatePreview(rep, selected, preview);
        dlg.getButton(AlertDialog.BUTTON_POSITIVE).setEnabled(true);
    }

    /** Simple holder for a saved contact. */
    private static final class ContactRow { final String name; final int number;
        ContactRow(String n, int num) { name = n; number = num; } }

    /** The user's saved contacts (name + number), via DmrManager, for the manual-TG picker. */
    private java.util.List<ContactRow> loadAllContacts() {
        java.util.List<ContactRow> out = new java.util.ArrayList<>();
        try {
            Object mgr = XposedHelpers.callStaticMethod(
                XposedHelpers.findClass("com.pri.prizeinterphone.manager.DmrManager", activity.getClassLoader()),
                "getInstance");
            Object list = XposedHelpers.callMethod(mgr, "getAllContacts");
            if (list instanceof java.util.List) {
                for (Object c : (java.util.List<?>) list) {
                    try {
                        String name = (String) XposedHelpers.callMethod(c, "getName");
                        String num = (String) XposedHelpers.callMethod(c, "getNumber");
                        int n = Integer.parseInt(num.trim());
                        if (n > 0) out.add(new ContactRow(name != null ? name : ("TG " + n), n));
                    } catch (Throwable ignore) { }
                }
            }
        } catch (Throwable t) {
            XposedBridge.log(TAG + ": loadAllContacts failed: " + t);
        }
        return out;
    }

    /**
     * Shown when a repeater has no talkgroups in the directory data: let the operator supply them
     * from saved contacts or by typing a number, pick the timeslot, then fall through to the normal
     * transmit-selection + install flow.
     */
    private void buildManualTgUi(final Context ctx, final LinearLayout box, final TextView head,
                                 final Repeater rep, final Set<Integer> selected,
                                 final TextView[] previewRef, final AlertDialog dlg) {
        head.setText("No talkgroups are listed for this repeater. Add the ones it uses: tick from your "
            + "contacts or type a talkgroup number, choose the timeslot, then \u201cUse these\u201d.");

        // ordered set of chosen talkgroups: id -> Talkgroup(id, slot, name)
        final java.util.LinkedHashMap<Integer, Talkgroup> chosen = new java.util.LinkedHashMap<>();

        // timeslot selector
        final android.widget.RadioGroup slotGroup = new android.widget.RadioGroup(ctx);
        slotGroup.setOrientation(android.widget.RadioGroup.HORIZONTAL);
        final android.widget.RadioButton ts1 = new android.widget.RadioButton(ctx);
        ts1.setId(1); ts1.setText("TS1"); ts1.setTextColor(0xFFEEEEEE);
        final android.widget.RadioButton ts2 = new android.widget.RadioButton(ctx);
        ts2.setId(2); ts2.setText("TS2"); ts2.setTextColor(0xFFEEEEEE);
        slotGroup.addView(ts1); slotGroup.addView(ts2); slotGroup.check(1);
        box.addView(slotGroup);

        final TextView chosenView = new TextView(ctx);
        chosenView.setTextColor(0xFFBBBBBB); chosenView.setTextSize(12);
        chosenView.setPadding(0, dp(ctx, 4), 0, dp(ctx, 4));

        final Runnable refreshChosen = new Runnable() {
            @Override public void run() {
                if (chosen.isEmpty()) { chosenView.setText("Chosen: none"); return; }
                StringBuilder sb = new StringBuilder("Chosen: ");
                boolean first = true;
                for (Talkgroup tg : chosen.values()) {
                    if (!first) sb.append(", ");
                    first = false;
                    sb.append("TG ").append(tg.id).append(" TS").append(tg.slot);
                }
                chosenView.setText(sb.toString());
            }
        };

        // manual number entry
        LinearLayout addRow = new LinearLayout(ctx);
        addRow.setOrientation(LinearLayout.HORIZONTAL);
        final EditText tgInput = new EditText(ctx);
        tgInput.setHint("Talkgroup number");
        tgInput.setInputType(android.text.InputType.TYPE_CLASS_NUMBER);
        tgInput.setTextColor(0xFFEEEEEE);
        LinearLayout.LayoutParams il = new LinearLayout.LayoutParams(0, ViewGroup.LayoutParams.WRAP_CONTENT, 1f);
        tgInput.setLayoutParams(il);
        Button addBtn = new Button(ctx);
        addBtn.setText("Add"); addBtn.setAllCaps(false);
        addBtn.setOnClickListener(new View.OnClickListener() {
            @Override public void onClick(View v) {
                try {
                    int n = Integer.parseInt(tgInput.getText().toString().trim());
                    if (n > 0) {
                        int slot = slotGroup.getCheckedRadioButtonId() == 2 ? 2 : 1;
                        chosen.put(n, new Talkgroup(n, slot, null, "manual"));
                        tgInput.setText("");
                        refreshChosen.run();
                    }
                } catch (Exception e) {
                    Toast.makeText(ctx, "Enter a talkgroup number", Toast.LENGTH_SHORT).show();
                }
            }
        });
        addRow.addView(tgInput); addRow.addView(addBtn);
        box.addView(addRow);
        box.addView(chosenView);
        refreshChosen.run();

        // contacts
        java.util.List<ContactRow> contacts = loadAllContacts();
        if (!contacts.isEmpty()) {
            TextView ch = new TextView(ctx);
            ch.setText("From your contacts:"); ch.setTextColor(0xFF88AACC); ch.setTextSize(12);
            ch.setPadding(0, dp(ctx, 8), 0, dp(ctx, 2));
            box.addView(ch);
            for (final ContactRow cr : contacts) {
                final CheckBox cb = new CheckBox(ctx);
                cb.setText(cr.name + "  (" + cr.number + ")");
                cb.setTextColor(0xFFEEEEEE);
                cb.setOnCheckedChangeListener(new CompoundButton.OnCheckedChangeListener() {
                    @Override public void onCheckedChanged(CompoundButton b, boolean checked) {
                        if (checked) {
                            int slot = slotGroup.getCheckedRadioButtonId() == 2 ? 2 : 1;
                            chosen.put(cr.number, new Talkgroup(cr.number, slot, cr.name, "manual"));
                        } else {
                            chosen.remove(cr.number);
                        }
                        refreshChosen.run();
                    }
                });
                box.addView(cb);
            }
        }

        // "Use these" -> set talkgroups and re-render the normal flow
        // Commit happens via the dialog's always-visible button (relabeled "Use these"), so the
        // user never has to scroll past the contacts list to find it.
        manualCommit = new Runnable() {
            @Override public void run() {
                if (chosen.isEmpty()) {
                    Toast.makeText(ctx, "Add at least one talkgroup", Toast.LENGTH_SHORT).show();
                    return;
                }
                rep.talkgroups.clear();
                for (Talkgroup tg : chosen.values()) if (tg.slot == 1) rep.talkgroups.add(tg);
                for (Talkgroup tg : chosen.values()) if (tg.slot != 1) rep.talkgroups.add(tg);
                selected.clear();
                box.removeAllViews();
                box.addView(head);
                populateRepeaterDialog(ctx, box, head, rep, selected, previewRef, dlg);
            }
        };
        dlg.getButton(AlertDialog.BUTTON_POSITIVE).setText("Use these");
        dlg.getButton(AlertDialog.BUTTON_POSITIVE).setEnabled(true);
    }

    private void updatePreview(Repeater rep, Set<Integer> selected, TextView preview) {
        if (preview == null) return;
        RepeaterPlanner.Plan plan = RepeaterPlanner.plan(rep, selected, tgNames);
        preview.setText("Will create: " + RepeaterProgrammer.preview(plan));
    }

    private void doInstall(final Repeater rep, final Set<Integer> selected) {
        // P1.7: confirm before writing to the codeplug, showing exactly what will be created.
        RepeaterPlanner.Plan plan = RepeaterPlanner.plan(rep, selected, tgNames);
        String msg = "Install " + RepeaterProgrammer.preview(plan) + " for " + rep.callsign + "?\n\n"
            + "Channels are added inactive — tap one in the channel list to go live. "
            + "Re-installing this repeater replaces what the last install made.";
        new AlertDialog.Builder(activity)
            .setTitle("Confirm install")
            .setMessage(msg)
            .setNegativeButton("Cancel", null)
            .setPositiveButton("Install", new android.content.DialogInterface.OnClickListener() {
                @Override public void onClick(android.content.DialogInterface d, int w) { runInstall(rep, selected); }
            })
            .show();
    }

    private void runInstall(final Repeater rep, final Set<Integer> selected) {
        Toast.makeText(activity, "Installing " + rep.callsign + "...", Toast.LENGTH_SHORT).show();
        new Thread(new Runnable() {
            @Override public void run() {
                final RepeaterProgrammer.Result r = RepeaterProgrammer.apply(
                    activity, activity.getClassLoader(), rep, selected, tgNames);
                activity.runOnUiThread(new Runnable() { @Override public void run() {
                    AlertDialog.Builder b = new AlertDialog.Builder(activity)
                        .setTitle(r.ok ? "Installed" : "Install")
                        .setMessage(r.message)
                        .setPositiveButton("Close", null);
                    if (r.ok) {
                        final long runId = r.runId;
                        b.setNegativeButton("Undo", new android.content.DialogInterface.OnClickListener() {
                            @Override public void onClick(android.content.DialogInterface d, int w) {
                                new Thread(new Runnable() { @Override public void run() {
                                    final String msg = RepeaterProgrammer.undo(
                                        activity, activity.getClassLoader(), runId);
                                    activity.runOnUiThread(new Runnable() { @Override public void run() {
                                        Toast.makeText(activity, msg, Toast.LENGTH_LONG).show();
                                    }});
                                }}, "nearby-undo").start();
                            }
                        });
                    }
                    b.show();
                }});
            }
        }, "nearby-install").start();
    }

    private void showAboutSources() {
        String msg =
            "Repeater data comes from public amateur-radio directories:\n\n"
          + "\u2022 BrandMeister (api.brandmeister.network) \u2014 DMR repeaters, talkgroups and colour codes.\n"
          + "\u2022 RadioID.net (radioid.net) \u2014 non-BrandMeister DMR repeaters and talkgroups (location approximated from city).\n"
          + "\u2022 hearham.com (hearham.com/repeaters) \u2014 FM repeaters, tones and coordinates.\n\n"
          + "Catalogs are cached on this device only and never re-published. This feature is for "
          + "licensed amateur operators; transmit only where your licence permits.\n\n"
          + "Distances use your device's last or looked-up GPS position.";
        new AlertDialog.Builder(activity)
            .setTitle("About data sources")
            .setMessage(msg)
            .setPositiveButton("Close", null)
            .show();
    }

    private interface ToggleSink { void set(boolean v); }

    private void addToggle(Context ctx, LinearLayout row, final String label, boolean initial, final ToggleSink sink) {
        final android.widget.ToggleButton b = new android.widget.ToggleButton(ctx);
        b.setTextOn(label + " \u2713");
        b.setTextOff(label);
        b.setChecked(initial);
        b.setTextSize(12);
        b.setAllCaps(false);
        LinearLayout.LayoutParams lp = new LinearLayout.LayoutParams(0, ViewGroup.LayoutParams.WRAP_CONTENT, 1f);
        b.setLayoutParams(lp);
        b.setOnCheckedChangeListener(new CompoundButton.OnCheckedChangeListener() {
            @Override public void onCheckedChanged(CompoundButton v, boolean checked) {
                sink.set(checked);
                applyFilterAndRender();
            }
        });
        row.addView(b);
    }

    private void setStatus(final String s) { if (statusView != null) statusView.setText(s); }

    private void postStatus(final String s) {
        activity.runOnUiThread(new Runnable() { @Override public void run() { setStatus(s); } });
    }

    private static String nz(String s) { return s == null ? "" : s; }

    private static int dp(Context ctx, int v) {
        return (int) (v * ctx.getResources().getDisplayMetrics().density);
    }

    private static String readFile(File f) throws Exception {
        byte[] buf = new byte[(int) f.length()];
        java.io.FileInputStream in = new java.io.FileInputStream(f);
        try { int off = 0, n; while (off < buf.length && (n = in.read(buf, off, buf.length - off)) > 0) off += n; }
        finally { in.close(); }
        return new String(buf, "UTF-8");
    }

    private static void writeFile(File f, String s) throws Exception {
        FileOutputStream out = new FileOutputStream(f);
        try { out.write(s.getBytes("UTF-8")); } finally { out.close(); }
    }
}
