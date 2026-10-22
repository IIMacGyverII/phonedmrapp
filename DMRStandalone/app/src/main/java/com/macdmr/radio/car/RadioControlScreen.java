/*
 * SignalDeck - Copyright (C) 2026 IIMacGyverII
 * SPDX-License-Identifier: GPL-3.0-or-later
 * Free software under the GNU General Public License v3 or later, with the additional terms in COPYRIGHT
 * (keep this notice and the author credit, mark modified versions, no rights to the SignalDeck name or icon).
 */
package com.macdmr.radio.car;

import android.graphics.Bitmap;
import android.graphics.Canvas;
import android.graphics.Paint;
import android.os.Handler;
import android.os.Looper;

import androidx.annotation.NonNull;
import androidx.car.app.CarContext;
import androidx.car.app.Screen;
import androidx.car.app.model.Action;
import androidx.car.app.model.ActionStrip;
import androidx.car.app.model.CarColor;
import androidx.car.app.model.CarIcon;
import androidx.car.app.model.Pane;
import androidx.car.app.model.PaneTemplate;
import androidx.car.app.model.Row;
import androidx.car.app.model.Template;
import androidx.core.graphics.drawable.IconCompat;
import androidx.lifecycle.DefaultLifecycleObserver;
import androidx.lifecycle.LifecycleOwner;

import com.macdmr.radio.ChannelStore;
import com.macdmr.radio.RadioService;
import com.macdmr.radio.coverage.CoverageMath;
import com.macdmr.radio.media.CarArt;
import com.macdmr.radio.ui.Neo;

/**
 * The control screen: the live intercom panel as the picture, the channel and what is happening, a wide TALK button
 * (green, red while transmitting; tap to talk, tap to stop, 28 s watchdog) and Scan, with channel down / up at the
 * top. Redrawn whenever the radio's state changes (checked twice a second while the screen is shown).
 */
public class RadioControlScreen extends Screen {
    private final Handler ui = new Handler(Looper.getMainLooper());
    private String lastKey = "";
    private Bitmap panel; private String panelKey = "";

    private final Runnable watch = new Runnable() {
        @Override public void run() {
            String k = stateKey();
            if (!k.equals(lastKey)) { lastKey = k; invalidate(); }
            ui.postDelayed(this, 500);
        }
    };

    public RadioControlScreen(@NonNull CarContext c) {
        super(c);
        getLifecycle().addObserver(new DefaultLifecycleObserver() {
            @Override public void onStart(@NonNull LifecycleOwner o) { ui.post(watch); }
            @Override public void onStop(@NonNull LifecycleOwner o) { ui.removeCallbacks(watch); }
        });
    }

    private static RadioService svc() { return RadioService.running; }

    private String stateKey() {
        RadioService s = svc();
        if (s == null) return "off";
        ChannelStore.Channel ch = s.current();
        int bucket = s.hearing() && s.lastRssi() != -999 ? (s.lastRssi() - CoverageMath.SCALE_LOW) / 4 : -1;
        return (ch == null ? "-" : ch.number + ch.name) + s.isReady() + s.isTransmitting() + s.pttHeld() + s.hearing() + s.isScanning() + s.isMuted() + bucket + s.currentCaller() + s.currentCallerId() + s.currentTarget() + s.zoneName();
    }

    @NonNull @Override public Template onGetTemplate() {
        // a car-side problem must never take the radio down with it (the screen runs in the radio's process)
        try { return build(); }
        catch (Throwable t) {
            android.util.Log.w("RadioControlScreen", "template: " + t);
            return new PaneTemplate.Builder(new Pane.Builder().addRow(new Row.Builder().setTitle("Radio controls are unavailable").addText(String.valueOf(t.getMessage())).build()).build())
                    .setHeaderAction(Action.APP_ICON).setTitle("Radio controls").build();
        }
    }

    private Template build() {
        RadioService s = svc();
        CarContext c = getCarContext();
        Pane.Builder pane = new Pane.Builder();
        if (s == null) {
            pane.addRow(new Row.Builder().setTitle("The radio is off").addText("Open SignalDeck on the phone to start it").build());
            return new PaneTemplate.Builder(pane.build()).setHeaderAction(Action.APP_ICON).setTitle("Radio controls").build();
        }
        ChannelStore.Channel ch = s.current();
        String status = s.isReady() ? com.macdmr.radio.RadioWidget.status(s).replace("Mapping coverage · ", "") : "Radio " + s.link();
        if (s.hearing() && s.lastRssi() != -999) status += " · " + CoverageMath.sUnits(s.lastRssi());
        pane.addRow(new Row.Builder().setTitle(ch == null ? "No channel" : "Ch " + ch.number + " · " + ch.name).addText(status).build());
        String caller = s.currentCaller();
        if (!caller.isEmpty()) {
            int id = s.currentCallerId(); String to = s.currentTarget();
            Row.Builder talk = new Row.Builder().setTitle("Talking: " + caller + (caller.startsWith("ID ") ? "" : " · " + id));
            if (!to.isEmpty()) talk.addText(to);
            pane.addRow(talk.build());
        }

        // the picture: the same live panel as the media screen
        try {
            String k = stateKey();
            if (panel == null || !k.equals(panelKey)) { panelKey = k; panel = CarArt.panelFor(c, s); }
            if (panel != null) pane.setImage(new CarIcon.Builder(IconCompat.createWithBitmap(panel)).build());
        } catch (Throwable ignored) { }

        boolean tx = s.pttHeld();
        pane.addAction(new Action.Builder()
                .setTitle(tx ? "STOP TALKING" : "TALK")
                .setIcon(icon(c, "ptt", 0xFFFFFFFF))
                .setBackgroundColor(CarColor.createCustom(tx ? Neo.RED : 0xFF1FAE5C, tx ? Neo.RED : 0xFF1FAE5C))
                .setFlags(Action.FLAG_PRIMARY)
                .setOnClickListener(() -> { RadioService r = svc(); if (r == null) return; if (r.pttHeld()) r.ptt(false); else r.ptt(true); ui.postDelayed(this::invalidate, 300); })
                .build());
        pane.addAction(new Action.Builder()
                .setTitle("Channels")
                .setIcon(icon(c, "channels", 0xFFFFFFFF))
                .setOnClickListener(() -> getScreenManager().push(new ChannelListScreen(getCarContext())))
                .build());

        // the car allows two buttons up here: previous and next channel (scan: in the channel lists, per zone)
        ActionStrip strip = new ActionStrip.Builder()
                .addAction(new Action.Builder().setIcon(icon(c, "left", 0xFFFFFFFF)).setOnClickListener(() -> { RadioService r = svc(); if (r != null) r.stepChannel(-1); }).build())
                .addAction(new Action.Builder().setIcon(icon(c, "right", 0xFFFFFFFF)).setOnClickListener(() -> { RadioService r = svc(); if (r != null) r.stepChannel(1); }).build())
                .build();
        return new PaneTemplate.Builder(pane.build()).setHeaderAction(Action.APP_ICON).setTitle("Radio controls").setActionStrip(strip).build();
    }

    /** One of the app's own glyphs as a car icon. */
    private static CarIcon icon(CarContext c, String name, int color) {
        Bitmap b = Bitmap.createBitmap(96, 96, Bitmap.Config.ARGB_8888);
        Neo.IconDrawable d = new Neo.IconDrawable(name, color); d.setBounds(8, 8, 88, 88); d.draw(new Canvas(b));
        return new CarIcon.Builder(IconCompat.createWithBitmap(b)).build();
    }
}
