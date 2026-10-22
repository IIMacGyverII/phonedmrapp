/*
 * SignalDeck - Copyright (C) 2026 IIMacGyverII
 * SPDX-License-Identifier: GPL-3.0-or-later
 * Free software under the GNU General Public License v3 or later, with the additional terms in COPYRIGHT
 * (keep this notice and the author credit, mark modified versions, no rights to the SignalDeck name or icon).
 */
package com.macdmr.radio;

import android.app.NotificationChannel;
import android.app.NotificationManager;
import android.app.PendingIntent;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.os.Build;
import android.os.Bundle;

import androidx.core.app.NotificationCompat;
import androidx.core.app.NotificationManagerCompat;
import androidx.core.app.Person;
import androidx.core.app.RemoteInput;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * Incoming DMR texts, APRS messages and weather alerts as conversation notifications: the phone shows them, and
 * Android Auto reads them aloud in the car and offers a voice reply (DMR texts and APRS messages) or "mark as read".
 * A reply goes back the way the message came: a DMR text to that ID or talkgroup, an APRS message over APRS-IS when
 * it came from there and the login is verified, otherwise over the air.
 */
public final class CarMessages {
    private CarMessages() { }

    static final String CHANNEL = "messages", KEY_REPLY = "reply";
    static final String KIND_DMR = "dmr", KIND_APRS = "aprs", KIND_APRS_IS = "aprsis", KIND_ALERT = "alert", KIND_TEST = "test";
    private static final Map<String, List<NotificationCompat.MessagingStyle.Message>> threads = new HashMap<>();
    private static final Person ME = new Person.Builder().setName("Me").build();

    /** A DMR text from {@code id} ({@code type} 0 private, 1 talkgroup, 2 all call). */
    public static void dmr(Context c, int id, int type, String name, String text) {
        String who = name == null || name.isEmpty() ? (type == 1 ? "TG " + id : "ID " + id) : name;
        post(c, KIND_DMR, type + ":" + id, who, text, true);
    }

    public static void aprs(Context c, String from, String text, boolean viaIs) { post(c, viaIs ? KIND_APRS_IS : KIND_APRS, from, from + (viaIs ? " (APRS-IS)" : " (APRS)"), text, true); }

    /** Diagnostics: a sample conversation (its reply is shown but never transmitted). */
    public static void test(Context c) { post(c, KIND_TEST, "test", "Test message", "This is how a DMR text or APRS message appears in the car.", true); }

    /** A weather alert: read aloud, no reply. */
    public static void alert(Context c, String title, String text) { post(c, KIND_ALERT, "noaa", "NOAA Weather", title + ". " + text, false); }

    private static synchronized void post(Context c, String kind, String peer, String who, String text, boolean canReply) {
        String key = kind + "|" + peer;
        List<NotificationCompat.MessagingStyle.Message> t = threads.get(key);
        if (t == null) { t = new ArrayList<>(); threads.put(key, t); }
        t.add(new NotificationCompat.MessagingStyle.Message(text, System.currentTimeMillis(), new Person.Builder().setName(who).setKey(key).build()));
        while (t.size() > 10) t.remove(0);
        show(c, key, who, canReply, true);
    }

    /** Your reply, shown in the conversation (Android Auto expects the thread to be updated after a reply). */
    static synchronized void addMine(Context c, String key, String text, String who, boolean canReply) {
        List<NotificationCompat.MessagingStyle.Message> t = threads.get(key);
        if (t == null) { t = new ArrayList<>(); threads.put(key, t); }
        t.add(new NotificationCompat.MessagingStyle.Message(text, System.currentTimeMillis(), (Person) null));
        show(c, key, who, canReply, false);
    }

    static synchronized void clear(Context c, String key) {
        threads.remove(key);
        NotificationManagerCompat.from(c).cancel(key, 7);
    }

    private static void show(Context c, String key, String who, boolean canReply, boolean alertNow) {
        try {
            NotificationManager nm = (NotificationManager) c.getSystemService(Context.NOTIFICATION_SERVICE);
            if (Build.VERSION.SDK_INT >= 26 && nm != null) nm.createNotificationChannel(new NotificationChannel(CHANNEL, "Messages (DMR, APRS, weather)", NotificationManager.IMPORTANCE_HIGH));
            NotificationCompat.MessagingStyle style = new NotificationCompat.MessagingStyle(ME).setConversationTitle(who).setGroupConversation(false);
            for (NotificationCompat.MessagingStyle.Message m : threads.get(key)) style.addMessage(m);
            int code = key.hashCode();
            Intent read = new Intent(c, Receiver.class).setAction("read").putExtra("key", key).putExtra("who", who);
            NotificationCompat.Action markRead = new NotificationCompat.Action.Builder(R.drawable.ic_stat_radio, "Mark as read",
                    PendingIntent.getBroadcast(c, code * 2 + 1, read, PendingIntent.FLAG_UPDATE_CURRENT | PendingIntent.FLAG_IMMUTABLE))
                    .setSemanticAction(NotificationCompat.Action.SEMANTIC_ACTION_MARK_AS_READ).setShowsUserInterface(false).build();
            NotificationCompat.Builder b = new NotificationCompat.Builder(c, CHANNEL)
                    .setSmallIcon(R.drawable.ic_stat_radio).setColor(0xFF19D3FF).setStyle(style)
                    .setCategory(NotificationCompat.CATEGORY_MESSAGE).setAutoCancel(true).setOnlyAlertOnce(!alertNow)
                    .setContentIntent(PendingIntent.getActivity(c, code * 2, new Intent(c, MainActivity.class), PendingIntent.FLAG_IMMUTABLE | PendingIntent.FLAG_UPDATE_CURRENT))
                    .addInvisibleAction(markRead);
            if (canReply) {
                Intent reply = new Intent(c, Receiver.class).setAction("reply").putExtra("key", key).putExtra("who", who);
                NotificationCompat.Action replyAction = new NotificationCompat.Action.Builder(R.drawable.ic_stat_radio, "Reply",
                        PendingIntent.getBroadcast(c, code * 2 + 2, reply, PendingIntent.FLAG_UPDATE_CURRENT | PendingIntent.FLAG_MUTABLE))
                        .addRemoteInput(new RemoteInput.Builder(KEY_REPLY).setLabel("Reply").build())
                        .setSemanticAction(NotificationCompat.Action.SEMANTIC_ACTION_REPLY).setShowsUserInterface(false).setAllowGeneratedReplies(true).build();
                b.addAction(replyAction);
            }
            b.addAction(markRead);
            NotificationManagerCompat.from(c).notify(key, 7, b.build());
        } catch (SecurityException se) { /* notifications not allowed */ }
        catch (Throwable ignored) { }
    }

    /** Reply / mark as read from the phone or the car. */
    public static class Receiver extends BroadcastReceiver {
        @Override public void onReceive(Context c, Intent i) {
            String key = i.getStringExtra("key"), who = i.getStringExtra("who");
            if (key == null) return;
            if ("read".equals(i.getAction())) { clear(c, key); return; }
            Bundle r = RemoteInput.getResultsFromIntent(i);
            CharSequence cs = r == null ? null : r.getCharSequence(KEY_REPLY);
            String text = cs == null ? "" : cs.toString().trim();
            if (text.isEmpty()) return;
            RadioService s = RadioService.running;
            String err = s == null ? "the radio is off" : send(s, key, text);
            addMine(c, key, err == null ? text : "Not sent (" + err + "): " + text, who, true);
        }
    }

    /** Send a reply; null when sent, else why not. */
    static String send(RadioService s, String key, String text) {
        int bar = key.indexOf('|'); String kind = key.substring(0, bar), peer = key.substring(bar + 1);
        if (KIND_DMR.equals(kind)) {
            if (s.current() == null || !s.current().isDigital()) return "tune a DMR channel to reply";
            int colon = peer.indexOf(':');
            ChannelStore.Contact to = new ChannelStore.Contact();
            to.type = Integer.parseInt(peer.substring(0, colon)); to.number = Integer.parseInt(peer.substring(colon + 1));
            s.sendSms(to, text.length() > 120 ? text.substring(0, 120) : text);
            return null;
        }
        if (KIND_APRS_IS.equals(kind) || KIND_APRS.equals(kind)) {
            if (s.packet() == null) return "packet radio is not available";
            String t = text.length() > 67 ? text.substring(0, 67) : text;
            if (KIND_APRS_IS.equals(kind)) { String e = s.packet().isSendMessage(peer, t); if (e == null) return null; }
            return s.packet().sendMessage(peer, t);
        }
        if (KIND_TEST.equals(kind)) return "test only";
        return "no reply for this message";
    }
}
