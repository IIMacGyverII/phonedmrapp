package com.macdmr.radio.media;

import android.content.Context;
import android.content.Intent;
import android.graphics.Bitmap;
import android.graphics.Canvas;
import android.graphics.Paint;
import android.graphics.RadialGradient;
import android.graphics.Shader;
import android.os.Build;
import android.os.Bundle;
import android.support.v4.media.MediaMetadataCompat;
import android.support.v4.media.session.MediaSessionCompat;
import android.support.v4.media.session.PlaybackStateCompat;

import com.macdmr.radio.ChannelStore;
import com.macdmr.radio.R;
import com.macdmr.radio.RadioService;

import java.util.List;
import java.util.Locale;

/**
 * The radio as a media source: one media session shared by the radio service (which keeps its state current), the
 * Android Auto browser ({@link RadioMediaService}) and the phone's media controls. Play / pause un-mutes / mutes what
 * you hear (reception, decoding and logging carry on), next / previous change channel, a channel picked from the list
 * or asked for by voice is tuned, and Scan is a custom button.
 */
public final class RadioMedia {
    public static final String ACTION_SCAN = "scan", ACTION_TALK = "talk";
    private static RadioMedia instance;
    private final Context ctx;
    private final MediaSessionCompat session;
    private String artKey; private Bitmap art;

    public static synchronized RadioMedia get(Context c) {
        if (instance == null) instance = new RadioMedia(c.getApplicationContext());
        return instance;
    }

    private RadioMedia(Context c) {
        ctx = c;
        session = new MediaSessionCompat(c, "DMRRadio");
        session.setCallback(new MediaSessionCompat.Callback() {
            @Override public void onPlay() { RadioService s = service(); if (s != null) s.mediaPlay(true); }
            @Override public void onPause() { RadioService s = service(); if (s != null) s.mediaPlay(false); }
            @Override public void onStop() { RadioService s = service(); if (s != null) s.mediaPlay(false); }
            @Override public void onSkipToNext() { RadioService s = service(); if (s != null) s.stepChannel(1); }
            @Override public void onSkipToPrevious() { RadioService s = service(); if (s != null) s.stepChannel(-1); }
            @Override public void onPlayFromMediaId(String id, Bundle extras) {
                RadioService s = service(); if (s == null) return;
                if (id != null && id.startsWith(RadioMediaService.CHANNEL)) { try { s.selectChannel(Integer.parseInt(id.substring(RadioMediaService.CHANNEL.length()))); } catch (NumberFormatException ignored) { } }
                s.mediaPlay(true);
            }
            @Override public void onPlayFromSearch(String query, Bundle extras) {
                RadioService s = service(); if (s == null) return;
                ChannelStore.Channel ch = find(s, query);
                if (ch != null) s.selectChannel(ch.number);
                s.mediaPlay(true);
            }
            @Override public void onCustomAction(String action, Bundle extras) {
                RadioService s = service(); if (s == null) return;
                if (ACTION_SCAN.equals(action)) s.toggleScan();
                else if (ACTION_TALK.equals(action)) {               // tap to talk, tap to stop; the 28 s watchdog ends it before the radio's 30 s limit
                    if (s.pttHeld()) s.ptt(false); else s.ptt(true);   // a receive-only channel refuses and says so in the history
                }
            }
        });
        session.setActive(true);
    }

    public MediaSessionCompat session() { return session; }

    /** The radio service, started when the car asks for the radio while it is not running yet. */
    private RadioService service() {
        RadioService s = RadioService.running;
        if (s == null) {
            Intent i = new Intent(ctx, RadioService.class).putExtra("bringUp", true);
            try { if (Build.VERSION.SDK_INT >= 26) ctx.startForegroundService(i); else ctx.startService(i); } catch (Throwable ignored) { }
        }
        return s;
    }

    /** A channel for a spoken request: number ("channel 38"), frequency ("162.5"), or the best name match ("weather six" finds "NOAA WX6" only by words). */
    static ChannelStore.Channel find(RadioService s, String query) {
        if (query == null || query.trim().isEmpty()) return s.current();
        String q = query.toLowerCase(Locale.US).replaceAll("^(channel|ch)\\s+", "").trim();
        List<ChannelStore.Channel> all = s.store().all();
        try { int n = Integer.parseInt(q); for (ChannelStore.Channel c : all) if (c.number == n) return c; } catch (NumberFormatException ignored) { }
        try { double mhz = Double.parseDouble(q); for (ChannelStore.Channel c : all) if (Math.abs(c.rxFreq / 1e6 - mhz) < 0.0026) return c; } catch (NumberFormatException ignored) { }
        String flat = q.replaceAll("[^a-z0-9]", "");
        ChannelStore.Channel best = null; int bestScore = 0;
        for (ChannelStore.Channel c : all) {
            String name = c.name.toLowerCase(Locale.US), nflat = name.replaceAll("[^a-z0-9]", "");
            int score = nflat.equals(flat) ? 100 : nflat.contains(flat) && !flat.isEmpty() ? 60 : 0;
            if (score == 0) for (String w : q.split("\\s+")) if (w.length() > 1 && name.contains(w)) score += 10;
            if (score > bestScore) { bestScore = score; best = c; }
        }
        return best;
    }

    /** Push the current state: what is tuned, what is happening, whether it plays. */
    public void update(RadioService s, boolean playing, String status, String zone, boolean scanning) {
        ChannelStore.Channel ch = s.current();
        String title = ch == null ? "DMR Radio" : ch.name;
        String key = ch == null ? "-" : ch.number + "|" + ch.name;
        if (!key.equals(artKey)) { artKey = key; art = art(ch); }
        session.setMetadata(new MediaMetadataCompat.Builder()
                .putString(MediaMetadataCompat.METADATA_KEY_MEDIA_ID, ch == null ? "" : RadioMediaService.CHANNEL + ch.number)
                .putString(MediaMetadataCompat.METADATA_KEY_TITLE, title)
                .putString(MediaMetadataCompat.METADATA_KEY_DISPLAY_TITLE, title)
                .putString(MediaMetadataCompat.METADATA_KEY_ARTIST, status)
                .putString(MediaMetadataCompat.METADATA_KEY_DISPLAY_SUBTITLE, status)
                .putString(MediaMetadataCompat.METADATA_KEY_ALBUM, zone)
                .putBitmap(MediaMetadataCompat.METADATA_KEY_ALBUM_ART, art)
                .putBitmap(MediaMetadataCompat.METADATA_KEY_DISPLAY_ICON, art)
                .build());
        long actions = PlaybackStateCompat.ACTION_PLAY | PlaybackStateCompat.ACTION_PAUSE | PlaybackStateCompat.ACTION_PLAY_PAUSE | PlaybackStateCompat.ACTION_STOP
                | PlaybackStateCompat.ACTION_SKIP_TO_NEXT | PlaybackStateCompat.ACTION_SKIP_TO_PREVIOUS
                | PlaybackStateCompat.ACTION_PLAY_FROM_MEDIA_ID | PlaybackStateCompat.ACTION_PLAY_FROM_SEARCH;
        int state = !s.isReady() ? PlaybackStateCompat.STATE_CONNECTING : playing ? PlaybackStateCompat.STATE_PLAYING : PlaybackStateCompat.STATE_PAUSED;
        session.setPlaybackState(new PlaybackStateCompat.Builder()
                .setActions(actions)
                .setState(state, PlaybackStateCompat.PLAYBACK_POSITION_UNKNOWN, 1f)
                .addCustomAction(new PlaybackStateCompat.CustomAction.Builder(ACTION_TALK, s.pttHeld() ? "Stop talking" : "Talk", s.pttHeld() ? R.drawable.ic_w_ptt_tx : R.drawable.ic_w_ptt).build())
                .addCustomAction(new PlaybackStateCompat.CustomAction.Builder(ACTION_SCAN, scanning ? "Stop scan" : "Scan", scanning ? R.drawable.ic_w_stop : R.drawable.ic_w_scan).build())
                .build());
    }

    /** Channel art: the neon channel number on the dark panel colour, as on the intercom. */
    private Bitmap art(ChannelStore.Channel ch) {
        int size = 320;
        Bitmap b = Bitmap.createBitmap(size, size, Bitmap.Config.ARGB_8888);
        Canvas c = new Canvas(b);
        Paint bg = new Paint(); bg.setShader(new RadialGradient(size / 2f, size / 2f, size * 0.75f, 0xFF0D1B2B, 0xFF060B12, Shader.TileMode.CLAMP));
        c.drawRect(0, 0, size, size, bg);
        Paint ring = new Paint(Paint.ANTI_ALIAS_FLAG); ring.setStyle(Paint.Style.STROKE); ring.setStrokeWidth(6); ring.setColor(0x6619D3FF);
        c.drawRoundRect(14, 14, size - 14, size - 14, 40, 40, ring);
        String text = ch == null ? "--" : String.format(Locale.US, "%02d", ch.number);
        Paint p = new Paint(Paint.ANTI_ALIAS_FLAG);
        try { p.setTypeface(android.graphics.Typeface.createFromAsset(ctx.getAssets(), "fonts/orbitron.ttf")); } catch (Throwable ignored) { }
        p.setTextSize(text.length() > 2 ? 120 : 150); p.setColor(0xFF2BEA7A); p.setFakeBoldText(true); p.setShadowLayer(22, 0, 0, 0xB02BEA7A); p.setTextAlign(Paint.Align.CENTER);
        Paint.FontMetrics fm = p.getFontMetrics();
        c.drawText(text, size / 2f, size / 2f - (fm.ascent + fm.descent) / 2, p);
        return b;
    }
}
