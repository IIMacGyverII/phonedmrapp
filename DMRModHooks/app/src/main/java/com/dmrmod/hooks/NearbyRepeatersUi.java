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
    private final List<Repeater> shownReps = new ArrayList<>();
    private volatile Map<Integer, String> tgNames;

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
                java.util.List<Repeater> hearham = loadHearham(forceRefresh);  // FM (cached, best-effort)
                java.util.List<Repeater> merged = RepeaterCatalog.merge(pr.repeaters, hearham);
                synchronized (all) {
                    all.clear();
                    all.addAll(merged);
                    catalogFetchedAt = fetchedAt;
                }
                XposedBridge.log(TAG + ": Nearby: BM " + pr.repeaters.size() + " + hearham "
                    + hearham.size() + " -> merged " + merged.size());
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
                final List<Talkgroup> tgs;
                try {
                    tgs = BrandMeisterSource.fetchDeviceTalkgroups(rep.dmrId);
                } catch (final Throwable t) {
                    activity.runOnUiThread(new Runnable() { @Override public void run() {
                        head.setText("Could not load talkgroups: " + t.getMessage());
                    }});
                    return;
                }
                for (Talkgroup tg : tgs) if (tg.name == null) tg.name = tgNames.get(tg.id);
                rep.talkgroups.clear();
                rep.talkgroups.addAll(tgs);
                activity.runOnUiThread(new Runnable() { @Override public void run() {
                    populateRepeaterDialog(ctx, box, head, rep, selected, previewRef, dlg);
                }});
            }
        }, "nearby-tgs").start();

        dlg.getButton(AlertDialog.BUTTON_POSITIVE).setOnClickListener(new View.OnClickListener() {
            @Override public void onClick(View v) {
                dlg.dismiss();
                doInstall(rep, new LinkedHashSet<Integer>(selected));
            }
        });
    }

    private void populateRepeaterDialog(Context ctx, LinearLayout box, TextView head, final Repeater rep,
                                        final Set<Integer> selected, final TextView[] previewRef,
                                        final AlertDialog dlg) {
        if (rep.talkgroups.isEmpty()) {
            head.setText("No talkgroups listed for this repeater on BrandMeister.");
            return;
        }
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
