/*
 * SignalDeck - Copyright (C) 2026 IIMacGyverII
 * SPDX-License-Identifier: GPL-3.0-or-later
 * Free software under the GNU General Public License v3 or later, with the additional terms in COPYRIGHT
 * (keep this notice and the author credit, mark modified versions, no rights to the SignalDeck name or icon).
 */
package com.macdmr.radio.ui;

import android.app.AlertDialog;
import android.content.Context;
import android.media.MediaPlayer;
import android.view.Gravity;
import android.widget.LinearLayout;
import android.widget.ScrollView;
import android.widget.TextView;
import android.widget.Toast;

import com.macdmr.radio.ChannelStore;
import com.macdmr.radio.RadioService;

import java.io.File;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Locale;

/** Recordings (REC) and caption transcripts (TXT): browse, play, delete. */
public final class MediaDialogs {
    private MediaDialogs() { }
    private static MediaPlayer player; private static TextView playing;

    public static File audioRoot() { return new File(android.os.Environment.getExternalStoragePublicDirectory(android.os.Environment.DIRECTORY_DOWNLOADS), "DMR/Audio"); }

    public static void recordings(final Context c, final RadioService svc) {
        float d = Theme.dp(c);
        final LinearLayout body = page(c, "🎧  Recordings");
        List<File> files = new ArrayList<>();
        java.util.HashSet<String> seen = new java.util.HashSet<>();
        File[] chans = audioRoot().listFiles();
        if (chans != null) for (File ch : chans) { File[] fs = ch.listFiles(); if (fs != null) for (File f : fs) if (f.getName().endsWith(".wav") && seen.add(f.getAbsolutePath())) files.add(f); }
        // recordings made by an earlier install or by the module are only visible through MediaStore
        try (android.database.Cursor cur = c.getContentResolver().query(android.provider.MediaStore.Audio.Media.EXTERNAL_CONTENT_URI, new String[] { android.provider.MediaStore.MediaColumns.DATA }, android.provider.MediaStore.MediaColumns.RELATIVE_PATH + " LIKE ?", new String[] { "Download/DMR/Audio/%" }, null)) {
            while (cur != null && cur.moveToNext()) { String p = cur.getString(0); if (p != null && p.endsWith(".wav") && seen.add(p)) files.add(new File(p)); }
        } catch (Throwable ignored) { }
        files.sort((a, b) -> Long.compare(b.lastModified(), a.lastModified()));
        body.addView(hint(c, files.isEmpty() ? "No recordings yet. Turn REC on; every reception on the channel is saved under Download/DMR/Audio/<channel>/." : "Tap to play or stop, long-press to delete. Files live in Download/DMR/Audio/<channel>/."));
        SimpleDateFormat f = new SimpleDateFormat("MM-dd HH:mm:ss", Locale.US);
        int n = 0;
        for (final File file : files) {
            if (n++ >= 150) break;
            final LinearLayout row = shell(c);
            final TextView t = Neo.label(c, "▶ " + file.getParentFile().getName() + "  ·  " + file.getName().replace(".wav", ""), Theme.CYAN, 14, true);
            row.addView(t);
            row.addView(Neo.label(c, f.format(new Date(file.lastModified())) + String.format(Locale.US, "  ·  %.0f s  ·  %.0f kB", Math.max(0, file.length() - 44) / 16000.0, file.length() / 1024.0), 0xFFBFC8D0, 12, false));
            row.setClickable(true); row.setLongClickable(true);
            row.setOnClickListener(v -> toggle(c, file, t));
            row.setOnLongClickListener(v -> { new AlertDialog.Builder(c).setTitle("Delete recording?").setMessage(file.getName()).setPositiveButton("Delete", (dd, w) -> { stop(); if (file.delete()) { body.removeView(row); Toast.makeText(c, "Deleted", Toast.LENGTH_SHORT).show(); } }).setNegativeButton("Cancel", null).show(); return true; });
            body.addView(row);
        }
        AlertDialog a = dialog(c, body);
        a.setOnDismissListener(dd -> stop());
    }

    private static void toggle(Context c, File file, TextView t) {
        if (player != null && playing == t) { stop(); return; }
        stop();
        try {
            player = new MediaPlayer(); player.setDataSource(file.getAbsolutePath()); player.prepare(); player.start(); playing = t;
            t.setText("■ " + t.getText().toString().substring(2)); t.setTextColor(Theme.GREEN);
            player.setOnCompletionListener(mp -> stop());
        } catch (Throwable e) { Toast.makeText(c, "Cannot play: " + e.getMessage(), Toast.LENGTH_LONG).show(); stop(); }
    }
    private static void stop() {
        try { if (player != null) { player.stop(); player.release(); } } catch (Throwable ignored) { }
        player = null;
        if (playing != null) { try { playing.setText("▶ " + playing.getText().toString().substring(2)); playing.setTextColor(Theme.CYAN); } catch (Throwable ignored) { } playing = null; }
    }

    public static void captions(final Context c, final RadioService svc) {
        final LinearLayout body = page(c, "📝  Captions heard");
        List<Object[]> rows = svc.store().captions(300);
        body.addView(hint(c, rows.isEmpty() ? "No captions yet. Turn TXT on; every finished sentence is kept here with its channel and time." : "Every finished caption sentence, newest first."));
        SimpleDateFormat f = new SimpleDateFormat("MM-dd HH:mm:ss", Locale.US);
        for (Object[] r : rows) {
            ChannelStore.Channel ch = svc.store().byNumber((Integer) r[1]);
            LinearLayout row = shell(c);
            row.addView(Neo.label(c, ((String) r[2]).replace("📝 ", ""), Theme.WHITE, 14, false));
            row.addView(Neo.label(c, f.format(new Date((Long) r[0])) + "  ·  " + (ch != null ? ch.name : "channel " + r[1]), 0xFF8A98A6, 11, false));
            body.addView(row);
        }
        dialog(c, body);
    }

    // ---- widgets ----
    private static LinearLayout page(Context c, String title) { return Neo.sheetBody(c, title); }
    private static AlertDialog dialog(Context c, LinearLayout body) { return Neo.showSheet(c, body); }
    private static TextView hint(Context c, String s) { return Neo.sheetHint(c, s); }
    private static LinearLayout shell(Context c) { float d = Theme.dp(c); LinearLayout r = new LinearLayout(c); r.setOrientation(LinearLayout.VERTICAL); r.setBackground(Neo.rowCard(c)); r.setPadding((int) (12 * d), (int) (8 * d), (int) (12 * d), (int) (8 * d)); LinearLayout.LayoutParams lp = new LinearLayout.LayoutParams(LinearLayout.LayoutParams.MATCH_PARENT, LinearLayout.LayoutParams.WRAP_CONTENT); lp.bottomMargin = (int) (6 * d); r.setLayoutParams(lp); return r; }
}
