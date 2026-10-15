package com.dmrmod.hooks;

import android.app.Activity;
import android.app.AlertDialog;
import android.content.Context;
import android.location.Location;
import android.location.LocationListener;
import android.location.LocationManager;
import android.os.Bundle;
import android.os.Looper;
import android.view.Gravity;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ArrayAdapter;
import android.widget.Button;
import android.widget.LinearLayout;
import android.widget.ListView;
import android.widget.TextView;
import android.widget.Toast;

import com.dmrmod.hooks.RepeaterModels.Repeater;

import java.io.File;
import java.io.FileOutputStream;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.List;
import java.util.Locale;

import de.robv.android.xposed.XposedBridge;

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
    private final List<Repeater> all = new ArrayList<>();
    private long catalogFetchedAt;

    private TextView statusView;
    private ArrayAdapter<String> adapter;
    private final List<String> rows = new ArrayList<>();

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

        ListView list = new ListView(ctx);
        adapter = new ArrayAdapter<>(ctx, android.R.layout.simple_list_item_1, rows);
        list.setAdapter(adapter);
        LinearLayout.LayoutParams listLp = new LinearLayout.LayoutParams(
            ViewGroup.LayoutParams.MATCH_PARENT, dp(ctx, 380));
        list.setLayoutParams(listLp);
        root.addView(list);

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
                synchronized (all) {
                    all.clear();
                    all.addAll(pr.repeaters);
                    catalogFetchedAt = fetchedAt;
                }
                XposedBridge.log(TAG + ": Nearby: parsed " + pr.repeaters.size() + " repeaters ("
                    + pr.skippedSimplex + " simplex, " + pr.skippedNoCallsign + " no-call skipped)");
                activity.runOnUiThread(new Runnable() {
                    @Override public void run() { applyFilterAndRender(); }
                });
            }
        }, "nearby-catalog").start();
    }

    private void applyFilterAndRender() {
        List<Repeater> matched = new ArrayList<>();
        int withCoords = 0;
        synchronized (all) {
            for (Repeater r : all) {
                if (!r.hasCoords) continue;
                withCoords++;
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
        if (!haveLocation) {
            rows.add("No location fix yet. Enable Location (GPS) and reopen.");
            rows.add("Catalog holds " + withCoords + " repeaters with coordinates.");
        } else if (matched.isEmpty()) {
            rows.add("No BrandMeister repeaters within " + radiusKm + " km.");
            rows.add("Try a larger radius above.");
        } else {
            for (Repeater r : matched) {
                rows.add(formatRow(r));
            }
        }
        if (adapter != null) adapter.notifyDataSetChanged();
        setStatus(buildStatus(matched.size(), withCoords));
    }

    private String formatRow(Repeater r) {
        String dist = GeoUtil.formatDistanceWithArrow(myLat, myLon, r.lat, r.lon);
        String cc = r.cc >= 0 ? "CC" + r.cc : "CC?";
        String approx = r.approx ? "  ~approx" : "";
        return String.format(Locale.US, "%s   %s\n%s MHz  DMR %s  %s%s",
            r.callsign, dist, r.rxMhzString(), cc, nz(r.city), approx);
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
