package com.macdmr.radio.ham;

import java.util.ArrayList;
import java.util.Calendar;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/** Channel activity from the radio history: receptions and minutes per channel, and by hour of day. */
public final class ActivityStats {
    public static final class Channel { public int number, receptions; public long seconds, lastTs; }

    public final List<Channel> channels = new ArrayList<>();
    public final int[] byHour = new int[24];
    public int receptions; public long seconds;

    /** {@code rows}: [ts (Long), channel (Integer), kind (String), text (String)] of rx and dmr lines. */
    public static ActivityStats of(List<Object[]> rows) {
        ActivityStats s = new ActivityStats();
        Map<Integer, Channel> m = new HashMap<>();
        Calendar cal = Calendar.getInstance();
        for (Object[] r : rows) {
            long ts = (Long) r[0]; int ch = (Integer) r[1]; String kind = (String) r[2], text = (String) r[3];
            if (!"rx".equals(kind) && !"dmr".equals(kind)) continue;
            long secs = seconds(text);
            Channel c = m.get(ch); if (c == null) { c = new Channel(); c.number = ch; m.put(ch, c); }
            c.receptions++; c.seconds += secs; c.lastTs = Math.max(c.lastTs, ts);
            cal.setTimeInMillis(ts); s.byHour[cal.get(Calendar.HOUR_OF_DAY)]++;
            s.receptions++; s.seconds += secs;
        }
        s.channels.addAll(m.values());
        s.channels.sort((a, b) -> a.receptions != b.receptions ? b.receptions - a.receptions : Long.compare(b.seconds, a.seconds));
        return s;
    }

    /** "📻 Received 12 s" → 12; DMR lines carry no length (counted as 0). */
    static long seconds(String text) {
        if (text == null) return 0;
        int i = text.indexOf("Received ");
        if (i < 0) return 0;
        int j = i + 9, k = j; while (k < text.length() && Character.isDigit(text.charAt(k))) k++;
        try { return k > j ? Long.parseLong(text.substring(j, k)) : 0; } catch (NumberFormatException e) { return 0; }
    }

    /** The busiest hour (0–23), or -1 with no activity. */
    public int peakHour() { int b = -1; for (int h = 0; h < 24; h++) if (byHour[h] > 0 && (b < 0 || byHour[h] > byHour[b])) b = h; return b; }
}
