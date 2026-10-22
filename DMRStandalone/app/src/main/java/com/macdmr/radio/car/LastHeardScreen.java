/*
 * SignalDeck - Copyright (C) 2026 IIMacGyverII
 * SPDX-License-Identifier: GPL-3.0-or-later
 * Free software under the GNU General Public License v3 or later, with the additional terms in COPYRIGHT
 * (keep this notice and the author credit, mark modified versions, no rights to the SignalDeck name or icon).
 */
package com.macdmr.radio.car;

import androidx.annotation.NonNull;
import androidx.car.app.CarContext;
import androidx.car.app.Screen;
import androidx.car.app.model.Action;
import androidx.car.app.model.ItemList;
import androidx.car.app.model.ListTemplate;
import androidx.car.app.model.Row;
import androidx.car.app.model.Template;

import com.macdmr.radio.RadioService;

import java.util.List;

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
                List<LastHeard.Item> items = LastHeard.items(s, max);
                for (LastHeard.Item it : items) {
                    Row.Builder row = new Row.Builder().setTitle(it.title).addText(it.sub);
                    final int chNum = it.channel;
                    if (it.known) row.setOnClickListener(() -> { RadioService x = RadioService.running; if (x != null) x.selectChannel(chNum); getScreenManager().popToRoot(); });
                    list.addItem(row.build());
                }
                if (items.isEmpty()) list.setNoItemsMessage("Nothing heard yet");
            }
        } catch (Throwable t) { list.addItem(new Row.Builder().setTitle("Unavailable").addText(String.valueOf(t.getMessage())).build()); }
        return new ListTemplate.Builder().setSingleList(list.build()).setTitle("Last heard").setHeaderAction(Action.BACK).build();
    }

}
