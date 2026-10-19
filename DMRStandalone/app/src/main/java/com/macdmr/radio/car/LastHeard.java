package com.macdmr.radio.car;

import com.macdmr.radio.ChannelStore;
import com.macdmr.radio.RadioService;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Locale;

/** Last heard for the car screens (template list and media browse): newest first, back-to-back repeats merged. */
public final class LastHeard {
    private LastHeard() { }

    public static final class Item {
        public final String title, sub; public final int channel; public final boolean known;
        Item(String title, String sub, int channel, boolean known) { this.title = title; this.sub = sub; this.channel = channel; this.known = known; }
    }

    public static List<Item> items(RadioService s, int max) {
        List<Item> out = new ArrayList<>();
        SimpleDateFormat f = new SimpleDateFormat("HH:mm", Locale.US);
        String prevKey = null, pTitle = null, pSub = null; int pCh = 0, count = 0; boolean pKnown = false;
        for (Object[] r : s.store().lastHeard(max * 3)) {
            long ts = (Long) r[0]; int chNum = (Integer) r[1]; String kind = (String) r[2]; String text = (String) r[3]; int id = (Integer) r[4];
            ChannelStore.Channel ch = s.store().byNumber(chNum);
            String title;
            if ("dmr".equals(kind) && id > 0) { String n = s.callerName(id); title = n.isEmpty() ? "ID " + id : n + " · " + id; }
            else title = clean(text);
            if (title.isEmpty()) title = "Received";
            String sub = f.format(new Date(ts)) + (ch != null ? " · Ch " + ch.number + " " + ch.name : "");
            if ("dmr".equals(kind)) { int tg = text == null ? -1 : text.indexOf("TG "); if (tg >= 0) { int end = text.indexOf(' ', tg + 3); sub += " · " + text.substring(tg, end > 0 ? end : text.length()); } }
            String key = title + "|" + chNum;
            if (key.equals(prevKey)) { count++; continue; }   // back-to-back transmissions from the same station: one line
            if (pTitle != null) { out.add(new Item(pTitle + (count > 1 ? "  (" + count + "×)" : ""), pSub, pCh, pKnown)); if (out.size() >= max) return out; }
            prevKey = key; pTitle = title; pSub = sub; pCh = chNum; pKnown = ch != null; count = 1;
        }
        if (pTitle != null && out.size() < max) out.add(new Item(pTitle + (count > 1 ? "  (" + count + "×)" : ""), pSub, pCh, pKnown));
        return out;
    }

    /** History lines start with an emoji marker; the car wants plain words. */
    static String clean(String t) {
        if (t == null) return "";
        String s = t.replaceFirst("^[^\\p{L}\\p{N}]+", "").trim();
        return s.length() > 60 ? s.substring(0, 59) + "…" : s;
    }
}
