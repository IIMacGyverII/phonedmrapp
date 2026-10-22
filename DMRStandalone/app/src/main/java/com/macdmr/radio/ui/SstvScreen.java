/*
 * SignalDeck - Copyright (C) 2026 IIMacGyverII
 * SPDX-License-Identifier: GPL-3.0-or-later
 * Free software under the GNU General Public License v3 or later, with the additional terms in COPYRIGHT
 * (keep this notice and the author credit, mark modified versions, no rights to the SignalDeck name or icon).
 */
package com.macdmr.radio.ui;

import android.content.Context;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.view.Gravity;
import android.widget.HorizontalScrollView;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.ProgressBar;
import android.widget.ScrollView;
import android.widget.TextView;

import com.macdmr.radio.PacketEngine;
import com.macdmr.radio.RadioService;

import java.io.File;
import java.util.Arrays;
import java.util.Locale;

/**
 * SSTV receive: the picture building up line by line, what the decoder is doing, a strip of the pictures received
 * (tap to view or share), and send / switch frequency / stop.
 */
public final class SstvScreen extends ModeScreen {
    private final PacketEngine pe;
    private final ImageView live;
    private final TextView status, progressText, galleryTitle;
    private final ProgressBar progress;
    private final LinearLayout gallery;
    private long galleryStamp = -1;
    private final TextView switchBtn;
    private final PassCard passCard;
    private TextView sendBtn, decoderBtn;

    public SstvScreen(Context c, RadioService svc, Runnable onClose) {
        super(c, svc, "SSTV", "pkt", Neo.VIOLET, onClose);
        pe = svc.packet();
        ScrollView sv = new ScrollView(c); sv.setVerticalScrollBarEnabled(false);
        LinearLayout body = new LinearLayout(c); body.setOrientation(VERTICAL); body.setPadding(dp(14), dp(4), dp(14), dp(10));
        sv.addView(body);
        passCard = new PassCard(c); body.addView(passCard);

        live = new ImageView(c); live.setAdjustViewBounds(true); live.setScaleType(ImageView.ScaleType.FIT_CENTER);
        live.setBackground(Neo.card(c, Neo.alpha(Neo.VIOLET, 0x66), 12)); live.setPadding(dp(3), dp(3), dp(3), dp(3));
        body.addView(live, new LayoutParams(LayoutParams.MATCH_PARENT, dp(260)));
        status = Neo.text(c, "", Neo.TEXT, 16, Neo.uiSemi(c)); status.setPadding(0, dp(10), 0, dp(4));
        body.addView(status);
        progress = new ProgressBar(c, null, android.R.attr.progressBarStyleHorizontal); progress.setMax(1000);
        progress.setProgressTintList(android.content.res.ColorStateList.valueOf(Neo.VIOLET));
        progress.setProgressBackgroundTintList(android.content.res.ColorStateList.valueOf(Neo.TRACK));
        body.addView(progress, new LayoutParams(LayoutParams.MATCH_PARENT, dp(8)));
        progressText = Neo.text(c, "", Neo.DIM, 12, Neo.mono(c)); progressText.setPadding(0, dp(4), 0, 0);
        body.addView(progressText);
        body.addView(Neo.sheetHint(c, "Two decoders (the button below switches): Any mode recognises Robot, Martin, Scottie and PD pictures from their VIS header at the start. Robot 36 continuous (always used for the ISS) needs no header: it locks on the line syncs, so a picture picked up halfway is drawn and placed at the bottom, fades are coasted through, and the screen shows the static until a picture comes in. Every picture, and every partial one of 16 lines or more, is saved to Download/DMR/SSTV."));

        galleryTitle = Neo.caps(c, "RECEIVED"); galleryTitle.setPadding(0, dp(14), 0, dp(6));
        body.addView(galleryTitle);
        HorizontalScrollView hs = new HorizontalScrollView(c); hs.setHorizontalScrollBarEnabled(false);
        gallery = new LinearLayout(c); hs.addView(gallery);
        body.addView(hs);
        content.addView(sv);

        LinearLayout r1 = buttonRow();
        sendBtn = button(r1, "Send picture", "send", Neo.AMBER, v -> PktDialog.sheet(c, svc, "sstvSend"));
        switchBtn = button(r1, "", "radio", Neo.CYAN, v -> {
            boolean parked = parked();
            svc.sstvMonitor(false, false); toast(svc.sstvMonitor(true, !parked));
        });
        LinearLayout r2 = buttonRow();
        decoderBtn = button(r2, "", "scan", Neo.VIOLET, v -> {
            if (iss()) { toast("ISS events are Robot 36: the continuous decoder is always used"); return; }
            pe.setSstvContinuousMode(!pe.sstvContinuousMode());
            toast(pe.sstvContinuousMode() ? "Robot 36 continuous: no header needed, partial pictures kept" : "Any mode: starts on the VIS header");
            refresh();
        });
        button(r2, "Stop receiving", "stop", Neo.RED, v -> {
            if (iss()) { svc.endSatTracking(); toast("ISS SSTV stopped"); close(); return; }
            toast(svc.sstvMonitor(false, false)); close();
        });

        if (pe.sstvLast() != null && !iss()) live.setImageBitmap(pe.sstvLast());      // an ISS session starts empty: the last picture came from elsewhere
        status.setText(nice(pe.sstvStatus()));
    }

    private boolean parked() { com.macdmr.radio.ChannelStore.Channel ch = svc.current(); return ch != null && ch.rxFreq == PacketEngine.SSTV_FREQ_HZ; }

    @Override protected void onAttachedToWindow() {
        super.onAttachedToWindow();
        pe.setSstvListener((st, bmp, lines, total, done) -> {
            if (bmp != null) live.setImageBitmap(bmp);
            status.setText(nice(st));
            if (total > 0) { progress.setProgress(Math.round(1000f * lines / total)); progressText.setText(lines + " of " + total + " lines"); }
            else if (!st.startsWith("receiving")) { progress.setProgress(done ? 1000 : 0); progressText.setText(""); }
            if (done) galleryStamp = -1;
        });
    }
    @Override protected void onDetachedFromWindow() { super.onDetachedFromWindow(); pe.setSstvListener(null); }

    private static String nice(String s) {
        if (s == null || s.isEmpty() || s.equals("idle")) return "Waiting";
        return s.substring(0, 1).toUpperCase(Locale.US) + s.substring(1);
    }

    private boolean iss() { return svc.satMode() == com.macdmr.radio.ham.Satellites.SSTV; }
    @Override protected long waitingHz() { com.macdmr.radio.RadioService.SatState st = svc.satState(); return st != null && st.mode == com.macdmr.radio.ham.Satellites.SSTV && st.waiting ? st.nominalHz : 0; }
    @Override protected long waitingUntil() { com.macdmr.radio.RadioService.SatState st = svc.satState(); return st == null ? 0 : st.aos - 60_000; }
    @Override protected boolean stillRunning() { return pe.sstvRx() || iss(); }

    @Override protected void refresh() {
        passCard.update(svc);
        String dec = pe.sstvUsingContinuous() || iss() ? "Robot 36 continuous" : "Any mode (header)";
        if (!dec.contentEquals(decoderBtn.getText())) { decoderBtn.setText(dec); Neo.fit(decoderBtn); }
        if (waitingHz() > 0) { set(status, "The decoder starts with the pass"); set(progressText, ""); }
        if (iss()) {
            setSubtitle("ISS SSTV " + String.format(Locale.US, "%.3f", svc.satState().nominalHz / 1e6) + " \u00B7 Doppler-tracked");
            if (switchBtn.getVisibility() != GONE) { switchBtn.setVisibility(GONE); sendBtn.setVisibility(GONE); }    // an ISS downlink: receive only
        } else {
            setSubtitle(parked() ? "Receiving on 144.500 MHz" : "Receiving on this channel");
            if (switchBtn.getVisibility() != VISIBLE) { switchBtn.setVisibility(VISIBLE); sendBtn.setVisibility(VISIBLE); }
            String sw = parked() ? "Use this channel" : "Go to 144.500";
            if (!sw.contentEquals(switchBtn.getText())) { switchBtn.setText(sw); Neo.fit(switchBtn); }
        }
        File dir = new File(android.os.Environment.getExternalStoragePublicDirectory(android.os.Environment.DIRECTORY_DOWNLOADS), "DMR/SSTV");
        File[] fs = dir.listFiles((x, n) -> n.toLowerCase(Locale.US).endsWith(".png") || n.toLowerCase(Locale.US).endsWith(".jpg"));
        long stamp = fs == null ? 0 : fs.length + dir.lastModified();
        if (stamp == galleryStamp) return;
        galleryStamp = stamp;
        gallery.removeAllViews();
        if (fs == null || fs.length == 0) { galleryTitle.setText("RECEIVED  ·  none yet"); return; }
        Arrays.sort(fs, (a, b) -> Long.compare(b.lastModified(), a.lastModified()));
        galleryTitle.setText("RECEIVED  ·  " + fs.length);
        for (int i = 0; i < Math.min(24, fs.length); i++) {
            final File f = fs[i];
            BitmapFactory.Options o = new BitmapFactory.Options(); o.inSampleSize = 4;
            Bitmap b = BitmapFactory.decodeFile(f.getAbsolutePath(), o);
            LinearLayout cell = new LinearLayout(c); cell.setOrientation(VERTICAL); cell.setGravity(Gravity.CENTER_HORIZONTAL);
            ImageView iv = new ImageView(c); iv.setScaleType(ImageView.ScaleType.CENTER_CROP); iv.setImageBitmap(b);
            iv.setBackground(Neo.card(c, Neo.LINE, 8)); iv.setPadding(dp(2), dp(2), dp(2), dp(2)); iv.setClipToOutline(true);
            cell.addView(iv, new LayoutParams(dp(120), dp(96)));
            TextView t = Neo.text(c, ago(f.lastModified()), Neo.DIM, 11, Neo.uiMedium(c)); t.setPadding(0, dp(3), 0, 0); cell.addView(t);
            cell.setOnClickListener(v -> view(f));
            LayoutParams lp = new LayoutParams(LayoutParams.WRAP_CONTENT, LayoutParams.WRAP_CONTENT); lp.rightMargin = dp(8);
            gallery.addView(cell, lp);
        }
    }

    private void view(File f) {
        LinearLayout body = Neo.sheetBody(c, "📺  " + f.getName());
        ImageView iv = new ImageView(c); iv.setAdjustViewBounds(true); iv.setImageBitmap(BitmapFactory.decodeFile(f.getAbsolutePath()));
        body.addView(iv, new LayoutParams(LayoutParams.MATCH_PARENT, LayoutParams.WRAP_CONTENT));
        body.addView(Neo.sheetHint(c, "Received " + new java.text.SimpleDateFormat("yyyy-MM-dd HH:mm:ss", Locale.US).format(new java.util.Date(f.lastModified())) + " · Download/DMR/SSTV"));
        TextView share = Neo.button(c, "Share", "send", Neo.CYAN);
        share.setOnClickListener(v -> {
            try {
                File dir = new File(c.getCacheDir(), "share"); dir.mkdirs();       // the provider shares the cache's share/ folder only
                File copy = new File(dir, f.getName());
                try (java.io.InputStream in = new java.io.FileInputStream(f); java.io.OutputStream out = new java.io.FileOutputStream(copy)) { byte[] b = new byte[65536]; int n; while ((n = in.read(b)) > 0) out.write(b, 0, n); }
                android.net.Uri u = androidx.core.content.FileProvider.getUriForFile(c, c.getPackageName() + ".files", copy);
                c.startActivity(android.content.Intent.createChooser(new android.content.Intent(android.content.Intent.ACTION_SEND).setType("image/*").putExtra(android.content.Intent.EXTRA_STREAM, u).addFlags(android.content.Intent.FLAG_GRANT_READ_URI_PERMISSION), "Share picture"));
            } catch (Throwable t) { toast("Could not share: " + t.getMessage()); }
        });
        body.addView(share, new LayoutParams(LayoutParams.MATCH_PARENT, dp(48)));
        Neo.showSheet(c, body);
    }
}
