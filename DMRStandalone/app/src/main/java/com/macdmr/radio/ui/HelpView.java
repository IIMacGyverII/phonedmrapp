package com.macdmr.radio.ui;

import android.content.Context;
import android.view.Gravity;
import android.widget.LinearLayout;
import android.widget.ScrollView;
import android.widget.TextView;

/** In-app help: one card per screen and feature, written for someone holding the radio for the first time. */
public class HelpView extends LinearLayout {
    private static final String[][] TOPICS = {
        { "🎙️ Intercom", "The big number is the current channel; the round arrows step through your channels. Hold the large key to talk and release to listen — it is amber when idle, green while the radio hears someone, red while you transmit. On NOAA weather channels the key is dimmed: those frequencies are receive-only.\n\nThe yellow box is the received signal strength. SCAN and ZONE, the software squelch slider and the mode keys around the PTT are being brought over from the module one by one; a key that is not wired yet says so when tapped.\n\nThe panel shows what is happening on the channel (receiving, transmitting, who called) and the last events on it; the bars are the audio level." },
        { "🎚️ SOFT SQ · ✍️ TXT · 🎛️ VFO", "SOFT SQ opens the radio's squelch and lets the app decide what you hear (CTCSS tone or noise squelch), which catches weaker signals than the radio's own squelch.\n\nTXT turns on live captions of received speech; long-press to pick the recognition engine and model.\n\nVFO lets you tune a frequency directly without saving a channel." },
        { "🔴 REC · 👁️ MON · 📡 PKT", "REC records everything received on the channel to Download/DMR/Audio.\n\nMON (monitor) tells the radio to pass every digital call it can decode, not only those addressed to you or your talkgroups.\n\nPKT opens the packet-radio tools: APRS messages, position beacon, KISS modem for APRSdroid, SSTV pictures, DTMF, NOAA weather alerts." },
        { "📋 Channels", "Tap a channel for Use (switch to it), Edit or Delete. The search box matches names, frequencies (type 462.6) and channel numbers; the chip filters FM or DMR. The + at the top adds a channel.\n\nAnalog channels need a frequency, power, bandwidth and optionally CTCSS/DCS tones. Digital (DMR) channels also need a colour code, time slot, a call target (a DMR ID for private calls or a talkgroup for group calls) and the list of talkgroups you want to hear on that channel (up to 32).\n\nVHF channels are always wide band on this radio; narrow band makes the receiver deaf." },
        { "👤 Contacts", "A contact is a DMR ID (a person) or a talkgroup (a group). Use them as call targets in channels and as recipients for text messages. The + adds one; tap a contact to message, edit or delete it." },
        { "💬 Messages", "DMR text messages travel over the current digital channel. Pick a contact or the channel's own call target, type, and send; delivery is confirmed with a check mark. Incoming texts appear here and in the channel history." },
        { "📻 Device", "Take over the radio / Hand back: this app and the stock walkie-talkie app cannot share the radio. Taking over pauses the stock app (its icon disappears until you hand back).\n\nRoot: the radio's serial port is locked by Android's security policy; the app needs Magisk root to unlock it. The Magisk-module button makes that permanent across reboots.\n\nYour DMR ID is what other radios see when you talk on digital channels." },
        { "⚠️ Transmitting", "You are responsible for the frequencies you use: amateur bands need a licence, GMRS needs a licence in the US, FRS limits power, and NOAA weather channels are receive-only. The radio stops any transmission after 30 seconds." },
    };

    public HelpView(Context c, Runnable onBack) {
        super(c);
        setOrientation(VERTICAL); setBackgroundColor(Theme.BG);
        float d = Theme.dp(c);
        LinearLayout bar = new LinearLayout(c); bar.setBackgroundColor(Theme.TITLE_BG); bar.setGravity(Gravity.CENTER_VERTICAL);
        bar.setPadding((int) (12 * d), (int) (4 * d), (int) (16 * d), (int) (4 * d));
        TextView back = Theme.label(c, "‹", Theme.WHITE, 34, false); back.setPadding(0, 0, (int) (14 * d), 0); back.setClickable(true); back.setOnClickListener(v -> onBack.run());
        bar.addView(back);
        bar.addView(Theme.label(c, "Help & how-to", Theme.WHITE, 22, false), new LayoutParams(0, LayoutParams.WRAP_CONTENT, 1f));
        addView(bar);
        ScrollView sv = new ScrollView(c);
        LinearLayout body = new LinearLayout(c); body.setOrientation(VERTICAL); body.setPadding((int) (12 * d), (int) (10 * d), (int) (12 * d), (int) (24 * d));
        for (String[] t : TOPICS) {
            LinearLayout card = new LinearLayout(c); card.setOrientation(VERTICAL);
            card.setBackground(Theme.rounded(c, 0x18000000, 0x3300BFFF, 1, 10)); card.setPadding((int) (14 * d), (int) (10 * d), (int) (14 * d), (int) (12 * d));
            TextView h = Theme.label(c, t[0], Theme.CYAN2, 16, true); h.setPadding(0, 0, 0, (int) (6 * d)); card.addView(h);
            TextView b = Theme.label(c, t[1], 0xFFD0D8E0, 14, false); b.setLineSpacing(0, 1.15f); card.addView(b);
            LayoutParams lp = new LayoutParams(LayoutParams.MATCH_PARENT, LayoutParams.WRAP_CONTENT); lp.bottomMargin = (int) (10 * d);
            body.addView(card, lp);
        }
        sv.addView(body); addView(sv, new LayoutParams(LayoutParams.MATCH_PARENT, 0, 1f));
    }
}
