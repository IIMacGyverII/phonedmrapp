/*
 * SignalDeck - Copyright (C) 2026 IIMacGyverII
 * SPDX-License-Identifier: GPL-3.0-or-later
 * Free software under the GNU General Public License v3 or later, with the additional terms in COPYRIGHT
 * (keep this notice and the author credit, mark modified versions, no rights to the SignalDeck name or icon).
 */
package com.macdmr.radio.media;

import android.os.Bundle;
import android.support.v4.media.MediaBrowserCompat;
import android.support.v4.media.MediaDescriptionCompat;

import androidx.annotation.NonNull;
import androidx.media.MediaBrowserServiceCompat;

import com.macdmr.radio.ChannelStore;
import com.macdmr.radio.RadioService;

import java.util.ArrayList;
import java.util.List;
import java.util.Locale;

/**
 * What Android Auto (and other media browsers) can browse: Favourites and every zone, then their channels, plus All
 * channels. Picking a channel tunes it and plays the radio (handled by the session in {@link RadioMedia}).
 */
public class RadioMediaService extends MediaBrowserServiceCompat {
    static final String ROOT = "root", ZONE = "zone:", ALL = "all", CHANNEL = "ch:", HEARD = "heard";

    @Override public void onCreate() {
        super.onCreate();
        setSessionToken(RadioMedia.get(this).session().getSessionToken());
    }

    @Override public BrowserRoot onGetRoot(@NonNull String clientPackageName, int clientUid, Bundle rootHints) {
        android.util.Log.i("RadioMediaService", "root for " + clientPackageName);
        RadioService rs = RadioService.running;
        if (rs != null && clientPackageName != null && clientPackageName.contains("gearhead")) { rs.carMediaBound(); rs.carEvent("🚗 Android Auto opened the media app"); }
        Bundle extras = new Bundle();
        extras.putBoolean("android.media.browse.CONTENT_STYLE_SUPPORTED", true);
        extras.putBoolean("android.media.browse.SEARCH_SUPPORTED", true);
        // channels as a list, zones as a list (Android Auto content style hints)
        extras.putInt("android.media.browse.CONTENT_STYLE_BROWSABLE_HINT", 1);
        extras.putInt("android.media.browse.CONTENT_STYLE_PLAYABLE_HINT", 1);
        return new BrowserRoot(ROOT, extras);
    }

    @Override public void onLoadChildren(@NonNull String parentId, @NonNull Result<List<MediaBrowserCompat.MediaItem>> result) {
        List<MediaBrowserCompat.MediaItem> out = new ArrayList<>();
        android.util.Log.i("RadioMediaService", "children of " + parentId);
        RadioService s = RadioService.running;
        ChannelStore store = s != null ? s.store() : new ChannelStore(this);
        if (ROOT.equals(parentId)) {
            List<ChannelStore.Zone> zones = new ArrayList<>(store.zones());
            zones.sort((a, b) -> Boolean.compare(!com.macdmr.radio.ui.ChannelsView.FAV_ZONE.equals(a.name), !com.macdmr.radio.ui.ChannelsView.FAV_ZONE.equals(b.name)));   // Favourites first
            out.add(folder(HEARD, "Last heard", "Who and what was received, newest first", CarArt.zoneTile(this, "last heard")));
            for (ChannelStore.Zone z : zones)
                out.add(folder(ZONE + z.id, z.name, z.numbers.length + (z.numbers.length == 1 ? " channel" : " channels"), CarArt.zoneTile(this, z.name)));
            out.add(folder(ALL, "All channels", store.all().size() + " channels", CarArt.zoneTile(this, "all")));
        } else if (HEARD.equals(parentId)) {
            if (s != null) {
                int i = 0;
                for (com.macdmr.radio.car.LastHeard.Item it : com.macdmr.radio.car.LastHeard.items(s, 30)) {
                    if (!it.known) continue;
                    ChannelStore.Channel c = store.byNumber(it.channel);
                    // unique ids (one channel can appear on several lines); the part after '#' is ignored when playing
                    out.add(new MediaBrowserCompat.MediaItem(new MediaDescriptionCompat.Builder().setMediaId(CHANNEL + it.channel + "#" + (i++))
                            .setTitle(it.title).setSubtitle(it.sub).setIconBitmap(c != null ? CarArt.channelTile(this, c) : null).build(), MediaBrowserCompat.MediaItem.FLAG_PLAYABLE));
                }
            }
        } else if (ALL.equals(parentId)) {
            for (ChannelStore.Channel c : store.all()) out.add(channel(this, c));
        } else if (parentId.startsWith(ZONE)) {
            long id; try { id = Long.parseLong(parentId.substring(ZONE.length())); } catch (NumberFormatException e) { id = -1; }
            ChannelStore.Zone z = store.zone(id);
            if (z != null) {
                java.util.Set<Integer> in = new java.util.HashSet<>(); for (int n : z.numbers) in.add(n);
                for (ChannelStore.Channel c : store.all()) if (in.contains(c.number)) out.add(channel(this, c));
            }
        }
        result.sendResult(out);
    }

    @Override public void onSearch(@NonNull String query, Bundle extras, @NonNull Result<List<MediaBrowserCompat.MediaItem>> result) {
        List<MediaBrowserCompat.MediaItem> out = new ArrayList<>();
        RadioService s = RadioService.running;
        ChannelStore store = s != null ? s.store() : new ChannelStore(this);
        String q = query.toLowerCase(Locale.US).trim();
        for (ChannelStore.Channel c : store.all())
            if (c.name.toLowerCase(Locale.US).contains(q) || String.valueOf(c.number).equals(q) || c.freqText(c.rxFreq).startsWith(q)) out.add(channel(this, c));
        result.sendResult(out);
    }

    private static MediaBrowserCompat.MediaItem folder(String id, String title, String sub, android.graphics.Bitmap icon) {
        return new MediaBrowserCompat.MediaItem(new MediaDescriptionCompat.Builder().setMediaId(id).setTitle(title).setSubtitle(sub).setIconBitmap(icon).build(), MediaBrowserCompat.MediaItem.FLAG_BROWSABLE);
    }

    private static MediaBrowserCompat.MediaItem channel(android.content.Context ctx, ChannelStore.Channel c) {
        String sub = String.format(Locale.US, "Ch %d · %s MHz · %s", c.number, c.freqText(c.rxFreq), c.isDigital() ? "DMR" : "FM");
        return new MediaBrowserCompat.MediaItem(new MediaDescriptionCompat.Builder().setMediaId(CHANNEL + c.number).setTitle(c.name).setSubtitle(sub).setIconBitmap(CarArt.channelTile(ctx, c)).build(), MediaBrowserCompat.MediaItem.FLAG_PLAYABLE);
    }
}
