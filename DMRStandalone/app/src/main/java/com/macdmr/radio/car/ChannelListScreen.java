package com.macdmr.radio.car;

import androidx.annotation.NonNull;
import androidx.car.app.CarContext;
import androidx.car.app.Screen;
import androidx.car.app.model.Action;
import androidx.car.app.model.CarIcon;
import androidx.car.app.model.ItemList;
import androidx.car.app.model.ListTemplate;
import androidx.car.app.model.Row;
import androidx.car.app.model.Template;
import androidx.core.graphics.drawable.IconCompat;

import com.macdmr.radio.ChannelStore;
import com.macdmr.radio.RadioService;
import com.macdmr.radio.media.CarArt;

import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Locale;
import java.util.Set;

/**
 * Channels on the car screen. With no zone: the zones (and All channels). With a zone: its channels, each with its
 * neon number tile; tapping one tunes it and goes back to the controls. Long lists are cut to what the car allows.
 */
public class ChannelListScreen extends Screen {
    private final long zoneId; private final boolean all; private final String title;
    static final String FAV = com.macdmr.radio.ui.ChannelsView.FAV_ZONE;

    /** The zone list. */
    public ChannelListScreen(@NonNull CarContext c) { this(c, -1, false, "Channels"); }

    private ChannelListScreen(@NonNull CarContext c, long zoneId, boolean all, String title) { super(c); this.zoneId = zoneId; this.all = all; this.title = title; }

    @NonNull @Override public Template onGetTemplate() {
        try { return build(); }
        catch (Throwable t) { return new ListTemplate.Builder().setSingleList(new ItemList.Builder().addItem(new Row.Builder().setTitle("Unavailable").addText(String.valueOf(t.getMessage())).build()).build()).setTitle(title).setHeaderAction(Action.BACK).build(); }
    }

    private Template build() {
        RadioService s = RadioService.running;
        ItemList.Builder list = new ItemList.Builder();
        int max = 100;
        try { max = getCarContext().getCarService(androidx.car.app.constraints.ConstraintManager.class).getContentLimit(androidx.car.app.constraints.ConstraintManager.CONTENT_LIMIT_TYPE_LIST); } catch (Throwable ignored) { }
        if (s == null) {
            list.addItem(new Row.Builder().setTitle("The radio is off").addText("Open DMR Radio on the phone").build());
        } else if (zoneId < 0 && !all) {
            List<ChannelStore.Zone> zones = new ArrayList<>(s.store().zones());
            ChannelStore.Zone fav = null;
            for (ChannelStore.Zone z : zones) if (FAV.equals(z.name)) fav = z;
            if (fav != null) zones.remove(fav);
            // Favourites first, always: until channels are starred it says how
            if (fav != null && fav.numbers.length > 0) {
                final ChannelStore.Zone f = fav;
                list.addItem(new Row.Builder().setTitle(FAV).addText(f.numbers.length + (f.numbers.length == 1 ? " channel" : " channels"))
                        .setImage(icon(CarArt.zoneTilePublic(getCarContext(), FAV))).setBrowsable(true)
                        .setOnClickListener(() -> getScreenManager().push(new ChannelListScreen(getCarContext(), f.id, false, FAV))).build());
            } else {
                list.addItem(new Row.Builder().setTitle(FAV).addText("Star channels on the phone (Channels page) to list them here")
                        .setImage(icon(CarArt.zoneTilePublic(getCarContext(), FAV))).build());
            }
            int n = 1;
            for (final ChannelStore.Zone z : zones) {
                if (n++ >= max - 1) break;
                list.addItem(new Row.Builder().setTitle(z.name).addText(z.numbers.length + (z.numbers.length == 1 ? " channel" : " channels"))
                        .setImage(icon(CarArt.zoneTilePublic(getCarContext(), z.name))).setBrowsable(true)
                        .setOnClickListener(() -> getScreenManager().push(new ChannelListScreen(getCarContext(), z.id, false, z.name))).build());
            }
            list.addItem(new Row.Builder().setTitle("All channels").addText(s.store().all().size() + " channels").setImage(icon(CarArt.zoneTilePublic(getCarContext(), "all"))).setBrowsable(true)
                    .setOnClickListener(() -> getScreenManager().push(new ChannelListScreen(getCarContext(), -1, true, "All channels"))).build());
        } else {
            List<ChannelStore.Channel> chans = new ArrayList<>();
            if (all) chans.addAll(s.store().all());
            else { ChannelStore.Zone z = s.store().zone(zoneId); if (z != null) { Set<Integer> in = new HashSet<>(); for (int x : z.numbers) in.add(x); for (ChannelStore.Channel c : s.store().all()) if (in.contains(c.number)) chans.add(c); } }
            ChannelStore.Channel cur = s.current();
            int start = 0;
            if (chans.size() > max && cur != null) for (int i = 0; i < chans.size(); i++) if (chans.get(i).number == cur.number) start = Math.max(0, Math.min(i - max / 2, chans.size() - max));   // long list: centred on the current channel
            for (int i = start; i < chans.size() && i < start + max; i++) {
                final ChannelStore.Channel c = chans.get(i);
                String sub = String.format(Locale.US, "%s MHz · %s%s", c.freqText(c.rxFreq), c.isDigital() ? "DMR" : "FM", cur != null && cur.number == c.number ? " · tuned" : "");
                list.addItem(new Row.Builder().setTitle(c.name).addText(sub).setImage(icon(CarArt.channelTilePublic(getCarContext(), c)))
                        .setOnClickListener(() -> { RadioService r = RadioService.running; if (r != null) r.selectChannel(c.number); getScreenManager().popToRoot(); }).build());
            }
            if (chans.isEmpty()) list.setNoItemsMessage("No channels in this zone");
        }
        ListTemplate.Builder t = new ListTemplate.Builder().setSingleList(list.build()).setTitle(title).setHeaderAction(Action.BACK);
        if (s != null && (zoneId >= 0 || all)) {                    // a channel list: scan exactly these channels
            final boolean scanning = s.isScanning();
            t.setActionStrip(new androidx.car.app.model.ActionStrip.Builder().addAction(new Action.Builder()
                    .setTitle(scanning ? "Stop scan" : "Scan")
                    .setOnClickListener(() -> {
                        RadioService r = RadioService.running; if (r == null) return;
                        if (r.isScanning()) r.toggleScan();
                        else { r.setZone(all ? 0 : zoneId); r.toggleScan(); }
                        getScreenManager().popToRoot();
                    }).build()).build());
        }
        return t.build();
    }

    private static CarIcon icon(android.graphics.Bitmap b) { return new CarIcon.Builder(IconCompat.createWithBitmap(b)).build(); }
}
