package com.macdmr.radio.car;

import androidx.annotation.NonNull;
import androidx.car.app.CarContext;
import androidx.car.app.Screen;
import androidx.car.app.model.Action;
import androidx.car.app.model.ItemList;
import androidx.car.app.model.ListTemplate;
import androidx.car.app.model.Row;
import androidx.car.app.model.Template;

import com.macdmr.radio.ChannelStore;
import com.macdmr.radio.RadioService;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;
import java.util.Locale;

/** Last heard on the car screen: who and what was received, newest first; tapping one tunes that channel. */
public class LastHeardScreen extends Screen {
    public LastHeardScreen(@NonNull CarContext c) { super(c); }

    @NonNull @Override public Template onGetTemplate() {
        ItemList.Builder list = new ItemList.Builder();
        RadioService s = RadioService.running;
        try {
            int max = 30;
            try { max = Math.min(max, getCarContext().getCarService(androidx.car.app.constraints.ConstraintManager.class).getContentLimit(androidx.car.app.constraints.ConstraintManager.CONTENT_LIMIT_TYPE_LIST)); } catch (Throwable ignored) { }
            if (s == null) list.addItem(new Row.Builder().setTitle("The radio is off").build());
            else {
                SimpleDateFormat f = new SimpleDateFormat("HH:mm", Locale.US);
                List<Object[]> rows = s.store().lastHeard(max * 3);
                String prevKey = null; Row.Builder pending = null; int count = 0; String pendingTitle = null; int shown = 0;
                for (Object[] r : rows) {
                    long ts = (Long) r[0]; final int chNum = (Integer) r[1]; String kind = (String) r[2]; String text = (String) r[3]; int id = (Integer) r[4];
                    ChannelStore.Channel ch = s.store().byNumber(chNum);
                    String title;
                    if ("dmr".equals(kind) && id > 0) { String n = s.callerName(id); title = n.isEmpty() ? "ID " + id : n + " · " + id; }
                    else title = clean(text);
                    String sub = f.format(new Date(ts)) + (ch != null ? " · Ch " + ch.number + " " + ch.name : "");
                    if ("dmr".equals(kind)) { int tg = text == null ? -1 : text.indexOf("TG "); if (tg >= 0) { int end = text.indexOf(' ', tg + 3); sub += " · " + text.substring(tg, end > 0 ? end : text.length()); } }
                    String key = title + "|" + chNum;
                    if (key.equals(prevKey)) { count++; continue; }   // back-to-back transmissions from the same station: one line
                    if (pending != null) { list.addItem(pending.setTitle(pendingTitle + (count > 1 ? "  (" + count + "×)" : "")).build()); if (++shown >= max) { pending = null; break; } }
                    prevKey = key; count = 1; pendingTitle = title.isEmpty() ? "Received" : title;
                    pending = new Row.Builder().addText(sub);
                    if (ch != null) pending.setOnClickListener(() -> { RadioService x = RadioService.running; if (x != null) x.selectChannel(chNum); getScreenManager().popToRoot(); });
                }
                if (pending != null) list.addItem(pending.setTitle(pendingTitle + (count > 1 ? "  (" + count + "×)" : "")).build());
                if (rows.isEmpty()) list.setNoItemsMessage("Nothing heard yet");
            }
        } catch (Throwable t) { list.addItem(new Row.Builder().setTitle("Unavailable").addText(String.valueOf(t.getMessage())).build()); }
        return new ListTemplate.Builder().setSingleList(list.build()).setTitle("Last heard").setHeaderAction(Action.BACK).build();
    }

    /** History lines start with an emoji marker; the car wants plain words. */
    private static String clean(String t) {
        if (t == null) return "";
        String s = t.replaceFirst("^[^\\p{L}\\p{N}]+", "").trim();
        return s.length() > 60 ? s.substring(0, 59) + "…" : s;
    }
}
