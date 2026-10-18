package com.macdmr.radio.ui;

import android.content.Context;
import android.view.Gravity;
import android.widget.LinearLayout;
import android.widget.ScrollView;
import android.widget.TextView;

/** In-app help: one card per screen and feature, written for someone holding the radio for the first time. */
public class HelpView extends LinearLayout {
    private static final String[][] TOPICS = {
        { "🎙️ Intercom", "The big number is the current channel; the round arrows step through your channels. Hold the large key, or the phone's side PTT button, to talk and release to listen — it is amber when idle, green while the radio hears someone, red while you transmit. On NOAA weather channels the key is dimmed: those frequencies are receive-only.\n\nWhen a CTCSS tone is heard on an analog channel that does not have it, the history says so; tap the box to make it the channel's tone. Tap the history box for Last heard (with the recordings player and the caption transcript): everyone and every channel with activity, newest first, with names from your contacts and the RadioID list; tap a line to switch. The yellow box is the received signal strength. SCAN and ZONE, the software squelch slider and the mode keys around the PTT are being brought over from the module one by one; a key that is not wired yet says so when tapped.\n\nThe panel shows what is happening on the channel (receiving, transmitting, who called) and the last events on it; the bars are the audio level." },
        { "🎚️ SOFT SQ · ✍️ TXT · 🎛️ VFO", "SOFT SQ opens the radio's squelch and lets the app decide what you hear (CTCSS tone or noise squelch), which catches weaker signals than the radio's own squelch.\n\nTXT turns on live captions of received speech; long-press to choose the engine (on-device Vosk through the companion app, or Google Cloud Speech with your own API key), the Vosk model, or keyword alerts (words that vibrate, notify and, with voice announcements on, are spoken when heard).\n\nVFO lets you tune any frequency directly without saving a channel: mode, receive and transmit frequency (with repeater-offset shortcuts), power, bandwidth and tones, or colour code, slot and call target for DMR. While VFO is on the intercom arrows step the frequency by the step you chose, the big channel number reads VFO, and long-pressing VFO returns to your channel. Save as channel keeps a frequency you want to come back to." },
        { "🔴 REC · 👁️ MON · 📡 PKT", "REC records everything received on the channel to Download/DMR/Audio.\n\nMON (monitor) tells the radio to pass every digital call it can decode, not only those addressed to you or your talkgroups.\n\nPKT opens the packet-radio tools. APRS: every analog channel is decoded passively (positions, messages, weather, objects go to Stations and the log); Monitor parks the radio on 144.390 MHz, auto-acks messages for your callsign and can act as a fill-in digipeater; Send message and Position beacon transmit from your callsign (set it in APRS settings); KISS TNC serves APRSdroid or YAAC on 127.0.0.1:8001 on whatever channel you are on. APRS-IS connects to the internet APRS network: with your passcode it gates what the radio hears, beacons your position online and delivers internet messages addressed to you (acked automatically); without a passcode it is receive-only. DTMF keys heard on any analog channel are logged, and you can send a sequence from the keypad or from your saved sequences (kept in backups as DTMF.csv). NOAA SAME weather alerts are decoded automatically on the weather frequencies and raise a notification. SSTV: receive pictures on 144.500 or on the current channel (Robot, Martin, Scottie, PD auto-detected; saved to Download/DMR/SSTV, live view in PKT), and send a picture from your gallery as Robot 24 Color, Robot 12 BW or Robot 8 BW. The PKT key lights while monitoring, SSTV receive or the TNC is running." },
        { "📋 Channels", "Tap a channel for Use (switch to it), Edit, Star or Delete. Starred channels collect in a \u2605 Favourites zone, so the zone picker, the arrows and the scanner can be limited to them. The search box matches names, frequencies (type 462.6) and channel numbers; the chip filters FM or DMR. Re-import from the stock app lets you pick any of the stock areas (regional channel sets). The + at the top adds a channel; the dish icon next to it opens Nearby repeaters: DMR repeaters from BrandMeister and RadioID and FM repeaters from hearham around you, sorted by distance, each added to your channels (listen channel per time slot, a talk channel per ticked talkgroup, contacts and a zone) in one tap, with undo.\n\nAnalog channels need a frequency, power, bandwidth and optionally CTCSS/DCS tones; a latitude/longitude (or Use my position) gives the intercom its distance and bearing. Digital (DMR) channels also need a colour code, time slot, a call target (a DMR ID for private calls or a talkgroup for group calls) and the list of talkgroups you want to hear on that channel (up to 32).\n\nVHF channels are always wide band on this radio; narrow band makes the receiver deaf." },
        { "👤 Contacts", "A contact is a DMR ID (a person) or a talkgroup (a group). Use them as call targets in channels and as recipients for text messages. The + adds one; tap a contact to message, edit or delete it." },
        { "💬 Messages", "DMR text messages travel over the current digital channel. Pick a contact or the channel's own call target, type (or tap \u26A1 for a quick reply, editable), and send; delivery is confirmed with a check mark. Incoming texts appear here and in the channel history." },
        { "📻 Device", "Take over the radio / Hand back: this app and the stock walkie-talkie app cannot share the radio. Taking over pauses the stock app (its icon disappears until you hand back).\n\nRoot: the radio's serial port is locked by Android's security policy; the app needs Magisk root to unlock it. The Magisk-module button makes that permanent across reboots.\n\nYour DMR ID is what other radios see when you talk on digital channels. The RadioID list (radioid.net, downloaded once from here, updated whenever you like) turns caller IDs into callsigns and names in the history, captions and Last heard. Voice announcements speak channel changes, caller names and keyword alerts. The Diagnostics log also holds radio tools: module version, power-cycle, a 3 s test tone. Check for updates looks at the GitHub releases of the project and installs a newer DMR Radio build in place (channels and settings are kept). Back up now writes the five OpenGD77-style CSV files to Download/DMR/DMR_Backups; Restore reads any such folder, including codeplugs edited in the OpenGD77 CPS fork." },
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
