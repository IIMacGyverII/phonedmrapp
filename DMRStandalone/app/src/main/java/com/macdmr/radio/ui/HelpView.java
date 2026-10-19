package com.macdmr.radio.ui;

import android.content.Context;
import android.text.Editable;
import android.text.TextWatcher;
import android.view.Gravity;
import android.view.View;
import android.widget.EditText;
import android.widget.FrameLayout;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.ScrollView;
import android.widget.TextView;

import java.util.Locale;

/**
 * In-app help as a navigable guide: a home page (Start here, search, topic tiles grouped by area) and one page
 * per topic with headed sections and Previous / Next. Search matches every section and opens the topic at it.
 * Written for someone holding the radio for the first time; keep it in step with the screens.
 */
public class HelpView extends LinearLayout {

    static final class Section { final String head, text; Section(String h, String t) { head = h; text = t; } }
    static final class Topic {
        final String icon, title, summary, group; final int accent; final Section[] sections;
        Topic(String group, String icon, int accent, String title, String summary, Section... s) { this.group = group; this.icon = icon; this.accent = accent; this.title = title; this.summary = summary; sections = s; }
    }
    private static Section s(String h, String t) { return new Section(h, t); }

    static final Topic[] TOPICS = {
        new Topic("Start here", "radio", Neo.CYAN, "Getting started", "Take over the radio, pick a channel, talk.",
            s("1  Take over the radio", "This app and the stock walkie-talkie app cannot share the radio. Open Device and tap Take over: the stock app is paused and its icon hidden until you tap Hand back. The app needs Magisk root to reach the radio's serial port; allow it when Magisk asks."),
            s("2  Pick a channel", "On the Intercom page the round arrows step through your channels. Or open Channels and tap a card, then Use. Your channels come from the stock app the first time and can be edited, added, backed up and restored."),
            s("3  Talk and listen", "Hold the large round key, or the phone's side PTT button, to talk; release it to listen. The key is amber when idle, green while the radio hears someone and red while you transmit. The radio ends any single transmission after 30 seconds."),
            s("4  Hear more", "Turn on SOFT SQ to hear weaker stations without static, TXT to read live captions of what is said, and SCAN to search the channels of a zone for activity. Each has its own topic in this guide.")),

        new Topic("On the intercom", "intercom", Neo.CYAN, "Intercom", "The main page: channel, talk key, activity.",
            s("Channel", "The big number is the current channel and the title above it is its name. The round arrows step to the previous or next channel of the current zone. On NOAA weather channels the talk key is dimmed: those frequencies are receive-only."),
            s("Talk key", "Hold to transmit, release to listen. Amber: idle. Green: the radio is receiving. Red: transmitting. The phone's side PTT button and, if you switch it on in Device, the volume-up key do the same."),
            s("Activity panel", "The panel says what is happening (ready, receiving, transmitting, who called) and lists the last events on this channel; the bars are the received audio level. Tap the panel for Last heard: everyone and every channel with activity, newest first, with names from your contacts and the RadioID list, plus the recordings player and the caption transcript; tap a line to switch to that channel. The small cross on the panel clears its list and hides it until the next reception or transmission; the small button left in its corner brings it back at once. Last heard keeps everything."),
            s("Tone offer", "When a CTCSS tone is heard on an analog channel that has none set, the panel says so. Tap it to make that tone the channel's receive and transmit tone."),
            s("Signal", "The classic page shows the signal strength in dBm in the yellow box. The new look shows a segmented S-meter: S1 to S9 in cyan, then amber and red above S9 (+20, +40), with the S-unit and dBm beside it. When nothing is being received the meter is dark and says NO SIGNAL, with the noise floor the radio reads beside it."),
            s("Two looks", "Device → Radio settings → New intercom look switches between the classic page and the redesigned one. The new page's menu button and a long-press on the classic page's title switch too. Both have the same controls.")),

        new Topic("On the intercom", "scan", Neo.CYAN, "Scanning and zones", "SCAN searches a zone; ZONE picks one.",
            s("Scan", "SCAN steps through the channels of the current zone, about two seconds each, and stops on a channel with activity. It moves on about two and a half seconds after the activity ends. Tap SCAN again to stop."),
            s("Skip a channel", "Long-press SCAN while it is holding on a channel to leave that channel out for the rest of this scan."),
            s("Priority channel", "In Channels, tap a channel and Make scan priority. While scanning, that channel (even one outside the zone) is checked again after every three other channels and the scan stops there when it is busy, so you do not miss it. While the scan is held on another busy channel, it still checks the priority channel every 10 seconds (a short gap in the audio) and moves to it if it is busy. Its card shows PRIORITY; the same button clears it."),
            s("Soft SQ while scanning", "While scanning, Soft SQ is used on every analog channel at that channel's own level, so weak stations are caught and static is not. A channel that only had Soft SQ for the scan returns to its own squelch when the scan stops. Turn this off in Device → Radio settings to scan with the radio's own squelch."),
            s("Zones", "ZONE picks which group of channels the arrows and the scanner use. Starred channels form the ★ Favourites zone; nearby-repeater imports create a zone of their own.")),

        new Topic("On the intercom", "softsq", Neo.CYAN, "Soft SQ", "A smarter squelch for weak signals.",
            s("What it does", "SOFT SQ holds the radio's own squelch open and lets the app decide what you hear: the channel's CTCSS tone when it has one, otherwise a noise squelch that tells speech from static. It catches weaker stations than the radio's squelch."),
            s("The slider", "The slider next to SOFT SQ sets how strict it is, from 1 (lenient) to 9 (strict). The number turns green while the squelch is open and amber while it is closed."),
            s("Switching channels", "After a channel change the audio stays muted for under a second while the receiver settles, so you do not hear a burst of static."),
            s("Per channel", "Soft SQ is remembered for each analog channel. With it off, the channel's own squelch level (Channels → Edit) applies.")),

        new Topic("On the intercom", "txt", Neo.VIOLET, "Live captions", "TXT turns received speech into text.",
            s("Captions", "TXT shows live captions of received speech in the panel. The recognizer runs inside this app (Vosk); its language model downloads once on first use, is kept across app updates, and only an uninstall removes it."),
            s("Options", "Long-press TXT to choose the engine (on-device, or Google Cloud Speech with your own API key), the size of the on-device model, or keyword alerts."),
            s("Keyword alerts", "Words or phrases that, when heard, vibrate the phone and post a notification; with voice announcements on they are also spoken.")),

        new Topic("On the intercom", "vfo", Neo.AMBER, "VFO", "Tune any frequency without a saved channel.",
            s("Tuning", "VFO lets you set mode, receive and transmit frequency (with repeater-offset shortcuts), power, bandwidth and tones, or colour code, slot and call target for DMR, without saving a channel."),
            s("While VFO is on", "The arrows step the frequency by the step you chose and the big number reads VFO. Long-press VFO to return to your channel. Save as channel keeps a frequency you want to come back to.")),

        new Topic("On the intercom", "rec", Neo.RED, "Record and monitor", "REC saves audio; MON hears every DMR call.",
            s("Record", "REC records everything received on the channel to Download/DMR/Audio. Play them from Last heard → Recordings."),
            s("Monitor", "MON tells the radio to pass every digital call it can decode on the channel, not only those addressed to you or to the talkgroups in the channel's list.")),

        new Topic("On the intercom", "pkt", Neo.GREEN, "Packet radio", "APRS, APRS-IS, TNC, DTMF, weather alerts, SSTV.",
            s("APRS", "Every analog channel is decoded passively: positions, messages, weather and objects go to Stations and the log. Monitor parks the radio on 144.390 MHz, acknowledges messages addressed to your callsign and can act as a fill-in digipeater. Send message and Position beacon transmit from your callsign, set in APRS settings."),
            s("APRS-IS", "Connects to the internet APRS network. With your passcode it gates what the radio hears, beacons your position online and delivers internet messages addressed to you; without a passcode it only receives."),
            s("KISS TNC", "Serves APRSdroid or YAAC on 127.0.0.1:8001 on whatever channel you are on, sending and receiving."),
            s("DTMF", "Keys heard on any analog channel are logged. Send a sequence from the keypad or from your saved sequences; saved ones are kept in backups as DTMF.csv."),
            s("Weather alerts", "NOAA SAME alerts are decoded automatically on the weather frequencies and raise a notification."),
            s("SSTV", "Receive pictures on 144.500 MHz or on the current channel (Robot, Martin, Scottie and PD are detected automatically), with a live view in PKT and copies in Download/DMR/SSTV. Send a picture from your gallery as Robot 24 Color, Robot 12 BW or Robot 8 BW."),
            s("The PKT key", "PKT lights while APRS monitoring, SSTV receive or the TNC is running.")),

        new Topic("Pages", "channels", Neo.CYAN, "Channels", "Your channel list, favourites and repeaters.",
            s("The list", "Each card shows the channel number, name, receive frequency, FM or DMR, and the one detail that matters: colour code and slot, repeater shift or tone. The active channel glows and says ON AIR."),
            s("Find and filter", "The search box matches names, frequencies (type 462.6) and channel numbers. The chips show all, favourites, analog or DMR channels. The zone button at the top picks the zone."),
            s("Favourites", "Tap a card's star to add or remove it. Starred channels form the ★ Favourites zone, so the arrows and the scanner can be limited to them."),
            s("Use, edit, delete", "Tap a card for Use (switch to it), Edit, Star or Delete. The + adds a channel."),
            s("Editing", "Every field in the channel editor has an info button that explains what it does on this radio. Analog channels need a frequency, power, bandwidth and optionally CTCSS or DCS tones; Soft SQ and its level can be set here too. A latitude and longitude gives the intercom the place name, distance and bearing: My position uses the phone's location; Open Maps shows the spot in your maps app, where Share \u2192 DMR Radio sends a place back; Paste reads coordinates or a maps link you copied. Sharing a place to DMR Radio while no editor is open asks which channel it belongs to. DMR channels also need a colour code, a time slot, a call target (a DMR ID for a private call or a talkgroup for a group call) and the talkgroups you want to hear on that channel, up to 32 (a group call's own talkgroup is added to that list when you save, because the radio passes only listed talkgroups). Talkgroup lists under the RX group list inserts a saved, named list in one tap or saves the current one; the DMRModHooks module's lists come over from the stock app. VHF channels are always wide band on this radio; narrow band makes its receiver deaf."),
            s("Nearby repeaters", "The dish button lists DMR repeaters from BrandMeister and RadioID and FM repeaters from hearham around you, nearest first, within 15, 30, 60 or 120 miles. One tap adds a repeater with its channels, talkgroup contacts and a zone, and it can be undone.")),

        new Topic("Pages", "contacts", Neo.VIOLET, "Contacts", "DMR IDs and talkgroups.",
            s("What a contact is", "A DMR ID (a person's radio) or a talkgroup (a group). Contacts are call targets for DMR channels and recipients for text messages."),
            s("The list", "Avatars are colour-coded: cyan for a private ID, violet for a talkgroup, amber for all-call. The chips show all, private or talkgroups; the search box matches names and IDs."),
            s("Actions", "The + adds a contact. The green bubble on a card opens its messages. Tap a card to message, edit or delete it.")),

        new Topic("Pages", "messages", Neo.GREEN, "Messages", "DMR text messages.",
            s("Sending", "Texts travel over the current DMR channel. Tap + and pick a contact or the channel's own call target, type, or tap the lightning button for a quick reply (the list is yours to edit), and send with the green button. On an analog channel the thread says so and nothing is sent."),
            s("Delivery", "Under each of your messages: green ✓✓ delivered means the other radio acknowledged it; amber ✓ sent means it went out without an acknowledgement, which is normal for many radios (the BTECH 6X2 among them) and the text still arrives; red ✖ means the radio could not send it."),
            s("Receiving", "Incoming texts appear in their conversation and in the intercom's activity panel.")),

        new Topic("Pages", "device", Neo.GREEN, "Device", "Radio link, settings and tools.",
            s("Radio link", "The card at the top shows who owns the radio (green: this app, cyan: the stock app, amber: a problem) with the serial port and speed. Take over and Hand back move the radio between this app and the stock app."),
            s("Root and reboots", "The radio's serial port is locked by Android's security policy; the app needs Magisk root to unlock it. Keep access after reboot installs a small Magisk module so the rules survive reboots; with it, Own the radio at boot lets the app take the radio as the phone starts."),
            s("Radio settings", "Switches for owning the radio at boot, the side PTT key, volume-up as PTT, Soft SQ while scanning, voice announcements (channel changes, caller names, keyword alerts; when you change channels quickly only the channel you stop on is spoken, and while scanning only a stop on activity and the channel you end on), the roger beep, the new intercom look, and Animated panel when quiet (the falling lines in the intercom panel on an idle channel; they always move while receiving, and turning this off saves a little battery)."),
            s("Your DMR ID", "What other radios see when you talk on DMR channels. Change sets it."),
            s("Tools", "Back up writes the five OpenGD77-style CSV files (Contacts, TG_Lists, Channels, Zones, DTMF) to Download/DMR/DMR_Backups; Restore reads any such folder, including codeplugs edited in the OpenGD77 CPS fork. The files use the same columns as the DMRModHooks module, so backups move between the module, this app and the CPS fork; saved talkgroup lists travel in TG_Lists.csv. Re-import copies an area's channels from the stock app. RadioID list downloads the names behind DMR IDs from radioid.net. Updates installs a newer DMR Radio release in place. Diagnostics shows the live protocol log and radio tools (module version, power-cycle, test tone) and Check backup round trip, which exports everything, restores it into a scratch copy and lists any field that would not survive; your channels are not touched."),
            s("Device report", "For a phone without a profile, the Device report tile collects what a profile needs, captures what the side PTT key sends, runs the root-only radio probe, and shares the result or opens a pre-filled GitHub issue. Nothing on the phone is changed.")),

        new Topic("Pages", "map", Neo.CYAN, "Map", "APRS stations, repeaters and channels around you.",
            s("Open it", "Intercom menu → Map, or the map icon at the top of Channels."),
            s("What is on it", "Green dots: APRS stations heard by the radio or APRS-IS, at their last position. Cyan diamonds: FM repeaters; violet diamonds: DMR repeaters, within the Nearby repeaters range (15 to 120 miles). Amber pins: your channels that have a location (channel editor → Location). Blue dot: you."),
            s("Moving around", "Drag to move, pinch or double-tap to zoom. The buttons on the right zoom in and out, go back to your position, and fit everything on screen. The pills at the top hide or show stations, repeaters and channels."),
            s("Markers", "Tap one for a card: a station shows when it was heard, its path, speed, altitude and comment; a repeater shows its frequencies and tone and opens its details to add it as a channel; a channel can be used straight away. Every card can open the place in your maps app."),
            s("Coverage", "The violet Coverage pill adds your measured coverage: where each repeater was heard and where your transmissions keyed it. See Coverage maps."),
            s("Map tiles", "From OpenStreetMap (© OpenStreetMap contributors), darkened to match the app and kept on the phone for 30 days, so places you have looked at still show offline.")),

        new Topic("Pages", "signal", Neo.VIOLET, "Coverage maps", "Where your repeaters really work, measured as you go.",
            s("What it does", "With coverage logging on, the app measures each repeater wherever you hear it and checks whether it answers when you transmit. Over time the Map shows two pictures: where the repeater reaches you, and where you reach the repeater. You just use the radio normally; walks and drives fill the map in."),
            s("Turn it on", "Map \u2192 the violet Coverage pill \u2192 Log coverage. It uses GPS while it is on, and keeps working with the screen off once you have switched it on with the app open. While it is on, the radio notification says Mapping coverage. Switch it off the same way. Everything stays on the phone."),
            s("Which channels", "Channels that have a location: the repeater's position, which channels added from Nearby repeaters get automatically (or set it in the channel editor \u2192 Location). Key-ups are judged only on repeater channels, where the transmit and receive frequencies differ."),
            s("Heard: repeater to phone", "Each time you hear the repeater, the signal strength is stored with your GPS position (only fixes better than 50 m, at most one reading every 5 seconds unless you moved 25 m). On DMR the radio reports a call only with the channel's colour code; on analog with a CTCSS tone the app checks the tone, so other stations on the frequency are not counted. The map shows 150 m squares coloured by the typical reading, from blue (barely heard, about S3) through green to red (S9+30)."),
            s("Key-ups: phone to repeater", "After each transmission of more than half a second on a repeater channel, the app reads the signal five times in the next two seconds. A repeater keeps transmitting for a moment after you let go (its tail or hang time); if that signal stands 8 dB above the channel's quiet noise floor, you keyed it from there (green). If nothing comes back it is a no reply (red). The Last heard history notes each result."),
            s("Driving with a steady signal", "While a station keeps transmitting, a reading is stored every 2 seconds as long as you keep moving (every 5 seconds when you stand still), so a drive draws a continuous track: at 60 mph about one reading every 55 m."),
            s("NOAA weather: the best way to start", "NOAA Weather Radio channels (162.400 to 162.550 MHz) transmit all the time, so on them every reading is stored, heard or not: weak spots and dead zones show up in blue instead of staying empty. Give the NOAA channel its transmitter's location (channel editor → Location), select it, turn on logging and drive around: the map shows that transmitter's real coverage, and the prediction calibrates itself from it."),
            s("While scanning", "Logging carries on during a scan: whenever the scan stops on a channel that has a location and hears it, the readings are stored for that repeater. Each channel keeps its own quiet noise floor across scan visits, so a transmission after the scan stops on a repeater is judged too."),
            s("Key-up test", "Coverage sheet \u2192 Key-up test here: on an FM repeater channel it transmits your callsign in Morse (about 3 seconds at 20 words per minute, your station identification) and records whether the repeater answered, without having to call anyone. It needs your callsign (PKT \u2192 APRS settings) and logging on, and asks before transmitting. On DMR, call the Parrot (private call 9990 on BrandMeister) instead: hearing your own call back proves both directions. Use it sparingly; repeaters are shared."),
            s("Reading the two layers", "The Heard layer usually reaches further than Key-ups: the repeater has a big antenna and more power than a handheld. Plan by Key-ups. No-reply squares are shown only for repeaters that have answered you somewhere, since a repeater with no tail never answers. Someone else talking right after you can look like a key-up; it is rare."),
            s("Focus and details", "The Coverage sheet picks the layer (Off, Heard, Key-ups) and one repeater or all of them (each square then shows the best one). Tap a square for its reading, or a channel pin \u2192 Coverage to focus on it. The legend in the corner opens the sheet."),
            s("Terrain prediction", "Pick one repeater (Coverage sheet, or a repeater or channel on the map \u2192 Coverage) and the map adds faint squares: the range predicted from the hills and valleys between you and the repeater, up to 10, 20 or 30 miles. It works before you have measured anything, so you can check a repeater before adding it. Set the repeater's antenna height above ground if you know it (15 to 100 m; 30 m by default)."),
            s("How the prediction learns", "It starts from typical numbers (a 50 W repeater, a 4 W handheld, 12 dB for trees, buildings and your body). Your Heard readings shift its signal level to match what you really received; your key-ups move the limit of where you can reach the repeater. Until you have key-ups, the reach follows the Heard correction too, since it is the same path both ways. Each square's card says whether it is measured or predicted and how well calibrated the prediction is. Trees and buildings are not in the terrain data, so forests and towns usually come out weaker than predicted until you have measured there."),
            s("Terrain data", "Heights come from the open Terrain Tiles (AWS Open Data, about 55 m detail). The first prediction for an area downloads them (a few megabytes); after that they are kept on the phone and predictions work offline."),
            s("Export and clear", "Export writes Download/DMR/Coverage/<date>/ with coverage_rx.csv and coverage_tx.csv (every reading, for a spreadsheet) and coverage.kml, which opens in Google Earth with coloured squares and green/red key-up points per repeater. Clear deletes the readings of the selected repeater, or all of them."),
            s("Good habits", "Carry the phone the same way when you compare places: a pocket or a car costs 10 to 20 dB. Do not key a repeater just to test it; use your normal conversations, and identify with your callsign as always.")),

        new Topic("Pages", "channels", Neo.CYAN, "Widget and notification", "Control the radio without opening the app.",
            s("Notification", "While the radio is on, its notification shows the channel, frequency and what is happening (ready, receiving, transmitting, scanning) with three buttons: previous channel, scan or stop scan, next channel. Tap the notification to open the app."),
            s("Home-screen widget", "Device → Home widget asks the home screen to add it (confirm with Add), or long-press the home screen, choose Widgets, find DMR Radio and drag the Radio widget out. It can be resized. It shows the channel number and name and the same status line, with previous, scan, next and Talk buttons. Tap the channel to open the app."),
            s("Talk from the widget", "A widget cannot feel a held finger, so Talk works tap to start, tap to stop: the button turns red while you transmit. Transmitting stops by itself after 28 seconds, before the radio's own 30-second limit. Receive-only channels refuse it."),
            s("When the radio is off", "The buttons need the app to own the radio. If it does not, they say so; tap the channel to open the app.")),

        new Topic("Good to know", "alert", Neo.RED, "Emergency and roger beep", "Send your position; an end-of-talk tone.",
            s("Emergency", "Intercom menu \u2192 Emergency, or Device \u2192 Emergency. It sends on the channel you are on. On a DMR channel: a text 'EMERGENCY <message> @ latitude,longitude +-accuracy' to the contact or talkgroup you choose in the sheet (it is remembered). On an analog channel: an APRS position with the emergency symbol and 'EMERGENCY <message>' as the comment, or an EMERGENCY status report when the phone has no position fix; this needs your callsign in PKT \u2192 APRS settings."),
            s("Hold to send", "The red key must be held for two seconds, so a stray tap never sends. Lifting early cancels. Afterwards the sheet says what was sent; hold again to repeat it."),
            s("Pick the right channel", "Switch to the channel where someone will hear you first: your repeater or talkgroup for DMR, the local APRS frequency (144.390 MHz in North America) for APRS. Only use it for a real emergency."),
            s("Roger beep", "Device \u2192 Roger beep: Off, Beep, Two-tone or Morse K. The tone is sent when you release the talk key, just before the carrier drops, so listeners know you are done. Tapping the row plays the new tone on the phone speaker.")),

        new Topic("Good to know", "alert", Neo.AMBER, "Transmitting legally", "Licences, power and the 30-second limit.",
            s("Licences", "You are responsible for the frequencies you use: amateur bands need an amateur licence, GMRS needs a licence in the US, FRS limits power, and NOAA weather channels are receive-only."),
            s("Time limit", "The radio ends any single transmission after 30 seconds; release and key again to continue.")),
    };

    private final Runnable onClose;
    private final FrameLayout stage;
    private LinearLayout home, homeGrid, results;
    private EditText search;
    private int current = -1;

    public HelpView(Context c, Runnable onClose) {
        super(c);
        this.onClose = onClose;
        setOrientation(VERTICAL); setBackground(Neo.page(c));
        stage = new FrameLayout(c);
        addView(stage, new LayoutParams(LayoutParams.MATCH_PARENT, LayoutParams.MATCH_PARENT));
        showHome();
    }

    /** Back key: topic → home → close. Returns true when handled here. */
    public boolean back() { if (current >= 0) { showHome(); return true; } return false; }

    // ---- home ----
    private void showHome() {
        final Context c = getContext(); final float d = Theme.dp(c);
        current = -1;
        stage.removeAllViews();
        LinearLayout page = new LinearLayout(c); page.setOrientation(VERTICAL);
        LinearLayout header = Neo.header(c, "Help & how-to", TOPICS.length + " topics");
        ImageView close = Neo.iconButton(c, "close", Neo.CYAN, "Close help"); close.setOnClickListener(v -> onClose.run());
        Neo.addAction(header, close);
        page.addView(header);

        ScrollView sv = new ScrollView(c); sv.setVerticalScrollBarEnabled(false);
        home = new LinearLayout(c); home.setOrientation(VERTICAL); home.setPadding((int) (16 * d), (int) (12 * d), (int) (16 * d), (int) (28 * d));
        sv.addView(home);
        page.addView(sv, new LayoutParams(LayoutParams.MATCH_PARENT, 0, 1f));

        // search
        LinearLayout sf = new LinearLayout(c); sf.setGravity(Gravity.CENTER_VERTICAL);
        sf.setBackground(Neo.card(c, Neo.alpha(Neo.CYAN, 0x33), 12)); sf.setPadding((int) (14 * d), 0, (int) (10 * d), 0);
        ImageView si = new ImageView(c); si.setImageDrawable(new Neo.IconDrawable("search", Neo.MUTED));
        sf.addView(si, new LayoutParams((int) (18 * d), (int) (18 * d)));
        search = new EditText(c); search.setHint("Search the guide"); search.setSingleLine(true); search.setTextSize(16); search.setTypeface(Neo.uiSemi(c));
        search.setTextColor(Neo.TEXT); search.setHintTextColor(Neo.DIM); search.setBackground(null); search.setPadding((int) (10 * d), 0, 0, 0);
        search.setInputType(android.text.InputType.TYPE_CLASS_TEXT | android.text.InputType.TYPE_TEXT_FLAG_NO_SUGGESTIONS);
        sf.addView(search, new LayoutParams(0, (int) (44 * d), 1f));
        home.addView(sf, new LayoutParams(LayoutParams.MATCH_PARENT, (int) (46 * d)));

        results = new LinearLayout(c); results.setOrientation(VERTICAL); results.setVisibility(GONE);
        home.addView(results);
        homeGrid = new LinearLayout(c); homeGrid.setOrientation(VERTICAL);
        home.addView(homeGrid);
        search.addTextChangedListener(new TextWatcher() {
            @Override public void beforeTextChanged(CharSequence s, int a, int b, int n) { } @Override public void onTextChanged(CharSequence s, int a, int b, int n) { }
            @Override public void afterTextChanged(Editable e) { runSearch(e.toString()); }
        });

        // start here: featured card
        final Topic start = TOPICS[0];
        LinearLayout hero = new LinearLayout(c); hero.setOrientation(VERTICAL); hero.setPadding((int) (16 * d), (int) (16 * d), (int) (16 * d), (int) (16 * d));
        android.graphics.drawable.StateListDrawable hs = new android.graphics.drawable.StateListDrawable();
        hs.addState(new int[] { android.R.attr.state_pressed }, Neo.tint(c, Neo.CYAN, 18, 1.5f)); hs.addState(new int[] { }, Neo.tint(c, Neo.CYAN, 18, 1));
        hero.setBackground(hs); hero.setClickable(true); hero.setFocusable(true);
        LinearLayout ht = new LinearLayout(c); ht.setGravity(Gravity.CENTER_VERTICAL);
        ht.addView(Neo.iconTile(c, start.icon, Neo.CYAN, 52), new LayoutParams((int) (52 * d), (int) (52 * d)));
        LinearLayout hc = new LinearLayout(c); hc.setOrientation(VERTICAL); hc.setPadding((int) (14 * d), 0, 0, 0);
        TextView kicker = Neo.caps(c, "Start here"); kicker.setTextColor(Neo.CYAN_LIGHT); hc.addView(kicker);
        TextView htitle = Neo.text(c, start.title, Neo.TEXT, 21, Neo.ui(c)); htitle.setPadding(0, (int) (3 * d), 0, 0); hc.addView(htitle);
        ht.addView(hc, new LayoutParams(0, LayoutParams.WRAP_CONTENT, 1f));
        ImageView arrow = new ImageView(c); arrow.setImageDrawable(new Neo.IconDrawable("right", Neo.CYAN)); ht.addView(arrow, new LayoutParams((int) (22 * d), (int) (22 * d)));
        hero.addView(ht);
        for (int i = 0; i < start.sections.length; i++) {
            LinearLayout step = new LinearLayout(c); step.setGravity(Gravity.CENTER_VERTICAL); step.setPadding(0, (int) (i == 0 ? 14 * d : 8 * d), 0, 0);
            TextView num = Neo.text(c, String.valueOf(i + 1), Neo.CYAN, 14, Neo.display(c)); num.setGravity(Gravity.CENTER);
            android.graphics.drawable.GradientDrawable ng = new android.graphics.drawable.GradientDrawable(); ng.setShape(android.graphics.drawable.GradientDrawable.OVAL); ng.setStroke((int) (1.5f * d), Neo.CYAN); num.setBackground(ng);
            step.addView(num, new LayoutParams((int) (26 * d), (int) (26 * d)));
            TextView st = Neo.text(c, start.sections[i].head.replaceFirst("^\\d+\\s+", ""), Neo.TEXT_SOFT, 15.5f, Neo.uiSemi(c)); st.setPadding((int) (10 * d), 0, 0, 0);
            step.addView(st);
            hero.addView(step);
        }
        hero.setOnClickListener(v -> showTopic(0, -1));
        LayoutParams hl = new LayoutParams(LayoutParams.MATCH_PARENT, LayoutParams.WRAP_CONTENT); hl.topMargin = (int) (14 * d);
        homeGrid.addView(hero, hl);

        // featured: the newest major feature
        int fi = -1; for (int i = 0; i < TOPICS.length; i++) if ("Coverage maps".equals(TOPICS[i].title)) fi = i;
        if (fi > 0) {
            final int fIdx = fi; Topic ft = TOPICS[fi];
            LinearLayout feat = new LinearLayout(c); feat.setOrientation(VERTICAL); feat.setPadding((int) (16 * d), (int) (14 * d), (int) (16 * d), (int) (14 * d));
            android.graphics.drawable.StateListDrawable fs = new android.graphics.drawable.StateListDrawable();
            fs.addState(new int[] { android.R.attr.state_pressed }, Neo.tint(c, Neo.VIOLET, 18, 1.5f)); fs.addState(new int[] { }, Neo.tint(c, Neo.VIOLET, 18, 1));
            feat.setBackground(fs); feat.setClickable(true); feat.setFocusable(true);
            LinearLayout fr = new LinearLayout(c); fr.setGravity(Gravity.CENTER_VERTICAL);
            fr.addView(Neo.iconTile(c, ft.icon, Neo.VIOLET, 46), new LayoutParams((int) (46 * d), (int) (46 * d)));
            LinearLayout fc = new LinearLayout(c); fc.setOrientation(VERTICAL); fc.setPadding((int) (14 * d), 0, 0, 0);
            TextView fk = Neo.caps(c, "New \u00b7 featured"); fk.setTextColor(Neo.VIOLET_LIGHT); fc.addView(fk);
            TextView ftt = Neo.text(c, ft.title, Neo.TEXT, 20, Neo.ui(c)); ftt.setPadding(0, (int) (3 * d), 0, 0); fc.addView(ftt);
            fr.addView(fc, new LayoutParams(0, LayoutParams.WRAP_CONTENT, 1f));
            ImageView fa = new ImageView(c); fa.setImageDrawable(new Neo.IconDrawable("right", Neo.VIOLET)); fr.addView(fa, new LayoutParams((int) (22 * d), (int) (22 * d)));
            feat.addView(fr);
            TextView fsum = Neo.text(c, "See where each repeater reaches you and where you can key it up, measured automatically as you drive or walk. Two map layers, export to Google Earth.", Neo.TEXT_SOFT, 14.5f, Neo.uiMedium(c));
            fsum.setPadding(0, (int) (10 * d), 0, 0); fsum.setLineSpacing(0, 1.1f); feat.addView(fsum);
            feat.setOnClickListener(v -> showTopic(fIdx, -1));
            LayoutParams fl = new LayoutParams(LayoutParams.MATCH_PARENT, LayoutParams.WRAP_CONTENT); fl.topMargin = (int) (12 * d);
            homeGrid.addView(feat, fl);
        }

        // topic tiles by group
        String group = null; LinearLayout rowOpen = null;
        for (int i = 1; i < TOPICS.length; i++) {
            final int idx = i; Topic t = TOPICS[i];
            if (!t.group.equals(group)) {
                group = t.group; rowOpen = null;
                TextView gh = Neo.caps(c, group); gh.setPadding((int) (2 * d), (int) (22 * d), 0, (int) (8 * d)); homeGrid.addView(gh);
            }
            LinearLayout tile = Neo.tile(c, t.icon, t.accent, t.title, t.summary);
            tile.setOnClickListener(v -> showTopic(idx, -1));
            if (rowOpen == null) {
                rowOpen = new LinearLayout(c); rowOpen.setBaselineAligned(false);
                LayoutParams l1 = new LayoutParams(0, LayoutParams.MATCH_PARENT, 1f); l1.setMargins(0, 0, (int) (4 * d), (int) (8 * d));
                rowOpen.addView(tile, l1);
                // a lone tile still takes half the row
                View spacer = new View(c); spacer.setTag("spacer");
                LayoutParams l2 = new LayoutParams(0, LayoutParams.MATCH_PARENT, 1f); l2.setMargins((int) (4 * d), 0, 0, (int) (8 * d));
                rowOpen.addView(spacer, l2);
                homeGrid.addView(rowOpen);
            } else {
                View spacer = rowOpen.findViewWithTag("spacer"); LayoutParams l2 = (LayoutParams) spacer.getLayoutParams();
                rowOpen.removeView(spacer); rowOpen.addView(tile, l2);
                rowOpen = null;
            }
        }
        stage.addView(page);
    }

    private void runSearch(String q) {
        final Context c = getContext(); final float d = Theme.dp(c);
        q = q.trim().toLowerCase(Locale.US);
        results.removeAllViews();
        if (q.isEmpty()) { results.setVisibility(GONE); homeGrid.setVisibility(VISIBLE); return; }
        homeGrid.setVisibility(GONE); results.setVisibility(VISIBLE);
        int n = 0;
        for (int i = 0; i < TOPICS.length; i++) {
            Topic t = TOPICS[i];
            for (int k = 0; k < t.sections.length; k++) {
                Section sec = t.sections[k];
                String body = sec.text.toLowerCase(Locale.US);
                boolean hit = sec.head.toLowerCase(Locale.US).contains(q) || body.contains(q) || (k == 0 && t.title.toLowerCase(Locale.US).contains(q));
                if (!hit) continue;
                final int ti = i, sk = k;
                LinearLayout card = new LinearLayout(c); card.setOrientation(VERTICAL); card.setPadding((int) (14 * d), (int) (12 * d), (int) (14 * d), (int) (12 * d));
                card.setBackground(Neo.card(c, Neo.alpha(t.accent, 0x55), 14)); card.setClickable(true);
                LinearLayout top = new LinearLayout(c); top.setGravity(Gravity.CENTER_VERTICAL);
                ImageView ic = new ImageView(c); ic.setImageDrawable(new Neo.IconDrawable(t.icon, t.accent)); top.addView(ic, new LayoutParams((int) (18 * d), (int) (18 * d)));
                TextView tt = Neo.caps(c, t.title + "  ·  " + sec.head.replaceFirst("^\\d+\\s+", "")); tt.setTextColor(Neo.alpha(t.accent, 0xFF)); tt.setPadding((int) (8 * d), 0, 0, 0); top.addView(tt);
                card.addView(top);
                int at = body.indexOf(q); int from = Math.max(0, at - 50);
                String snip = at < 0 ? sec.text : (from > 0 ? "…" : "") + sec.text.substring(from, Math.min(sec.text.length(), at + 110)) + (at + 110 < sec.text.length() ? "…" : "");
                TextView sn = Neo.text(c, snip, Neo.TEXT_SOFT, 14, Neo.uiMedium(c)); sn.setPadding(0, (int) (6 * d), 0, 0); sn.setLineSpacing(0, 1.1f);
                card.addView(sn);
                card.setOnClickListener(v -> showTopic(ti, sk));
                LayoutParams lp = new LayoutParams(LayoutParams.MATCH_PARENT, LayoutParams.WRAP_CONTENT); lp.topMargin = (int) (10 * d);
                results.addView(card, lp);
                n++;
            }
        }
        if (n == 0) {
            TextView none = Neo.text(c, "Nothing in the guide matches “" + q + "”.", Neo.MUTED, 15, Neo.uiMedium(c)); none.setPadding((int) (4 * d), (int) (20 * d), 0, 0);
            results.addView(none);
        }
    }

    // ---- topic page ----
    private void showTopic(final int idx, final int focusSection) {
        final Context c = getContext(); final float d = Theme.dp(c);
        current = idx;
        final Topic t = TOPICS[idx];
        stage.removeAllViews();
        LinearLayout page = new LinearLayout(c); page.setOrientation(VERTICAL);
        LinearLayout header = Neo.header(c, t.title, t.group + "  ·  " + (idx + 1) + " of " + TOPICS.length);
        ImageView back = Neo.iconButton(c, "left", Neo.CYAN, "All topics"); back.setOnClickListener(v -> showHome());
        LayoutParams bl = new LayoutParams((int) (44 * d), (int) (44 * d)); bl.rightMargin = (int) (12 * d);
        header.addView(back, 0, bl);
        ImageView close = Neo.iconButton(c, "close", Neo.CYAN, "Close help"); close.setOnClickListener(v -> onClose.run());
        Neo.addAction(header, close);
        page.addView(header);

        final ScrollView sv = new ScrollView(c); sv.setVerticalScrollBarEnabled(false);
        LinearLayout body = new LinearLayout(c); body.setOrientation(VERTICAL); body.setPadding((int) (16 * d), (int) (14 * d), (int) (16 * d), (int) (28 * d));
        sv.addView(body);
        page.addView(sv, new LayoutParams(LayoutParams.MATCH_PARENT, 0, 1f));

        LinearLayout lead = new LinearLayout(c); lead.setGravity(Gravity.CENTER_VERTICAL);
        lead.addView(Neo.iconTile(c, t.icon, t.accent, 56), new LayoutParams((int) (56 * d), (int) (56 * d)));
        TextView sum = Neo.text(c, t.summary, Neo.TEXT, 18, Neo.ui(c)); sum.setPadding((int) (14 * d), 0, 0, 0); sum.setLineSpacing(0, 1.05f);
        lead.addView(sum, new LayoutParams(0, LayoutParams.WRAP_CONTENT, 1f));
        body.addView(lead);

        final View[] secViews = new View[t.sections.length];
        for (int k = 0; k < t.sections.length; k++) {
            Section sec = t.sections[k];
            LinearLayout card = new LinearLayout(c); card.setOrientation(VERTICAL); card.setPadding((int) (16 * d), (int) (14 * d), (int) (16 * d), (int) (16 * d));
            card.setBackground(Neo.card(c, k == focusSection ? t.accent : Neo.LINE, 16));
            LinearLayout hrow = new LinearLayout(c); hrow.setGravity(Gravity.CENTER_VERTICAL);
            View bar = new View(c); android.graphics.drawable.GradientDrawable bg = new android.graphics.drawable.GradientDrawable(); bg.setColor(t.accent); bg.setCornerRadius(2 * d); bar.setBackground(bg);
            hrow.addView(bar, new LayoutParams((int) (3 * d), (int) (16 * d)));
            TextView h = Neo.text(c, sec.head, Neo.TEXT, 16.5f, Neo.ui(c)); h.setPadding((int) (10 * d), 0, 0, 0); hrow.addView(h);
            card.addView(hrow);
            TextView tx = Neo.text(c, sec.text, Neo.TEXT_SOFT, 15, Neo.uiMedium(c)); tx.setLineSpacing(0, 1.18f); tx.setPadding(0, (int) (8 * d), 0, 0);
            tx.setTextIsSelectable(false);
            card.addView(tx);
            LayoutParams lp = new LayoutParams(LayoutParams.MATCH_PARENT, LayoutParams.WRAP_CONTENT); lp.topMargin = (int) (12 * d);
            body.addView(card, lp);
            secViews[k] = card;
        }

        // previous / next
        LinearLayout nav = new LinearLayout(c); nav.setBaselineAligned(false);
        LayoutParams nl = new LayoutParams(LayoutParams.MATCH_PARENT, LayoutParams.WRAP_CONTENT); nl.topMargin = (int) (20 * d);
        if (idx > 0) {
            View prev = navCard(c, "Previous", TOPICS[idx - 1], false); prev.setOnClickListener(v -> showTopic(idx - 1, -1));
            LayoutParams p = new LayoutParams(0, LayoutParams.MATCH_PARENT, 1f); p.rightMargin = (int) (4 * d); nav.addView(prev, p);
        }
        if (idx < TOPICS.length - 1) {
            View next = navCard(c, "Next", TOPICS[idx + 1], true); next.setOnClickListener(v -> showTopic(idx + 1, -1));
            LayoutParams p = new LayoutParams(0, LayoutParams.MATCH_PARENT, 1f); p.leftMargin = idx > 0 ? (int) (4 * d) : 0; nav.addView(next, p);
        }
        body.addView(nav, nl);
        TextView all = Neo.button(c, "All topics", "menu", Neo.CYAN); all.setOnClickListener(v -> showHome());
        LayoutParams al = new LayoutParams(LayoutParams.MATCH_PARENT, LayoutParams.WRAP_CONTENT); al.topMargin = (int) (10 * d);
        body.addView(all, al);

        stage.addView(page);
        if (focusSection >= 0) sv.post(() -> sv.smoothScrollTo(0, Math.max(0, secViews[focusSection].getTop() - (int) (8 * d))));
    }

    private static View navCard(Context c, String label, Topic t, boolean next) {
        float d = Theme.dp(c);
        LinearLayout card = new LinearLayout(c); card.setOrientation(VERTICAL); card.setGravity(next ? Gravity.END : Gravity.START);
        card.setPadding((int) (14 * d), (int) (12 * d), (int) (14 * d), (int) (12 * d));
        android.graphics.drawable.StateListDrawable s = new android.graphics.drawable.StateListDrawable();
        s.addState(new int[] { android.R.attr.state_pressed }, Neo.tint(c, t.accent, 14, 1.5f)); s.addState(new int[] { }, Neo.card(c, Neo.alpha(t.accent, 0x66), 14));
        card.setBackground(s); card.setClickable(true); card.setFocusable(true);
        TextView l = Neo.caps(c, (next ? "" : "← ") + label + (next ? " →" : "")); card.addView(l);
        TextView tt = Neo.text(c, t.title, Neo.TEXT, 16, Neo.ui(c)); tt.setPadding(0, (int) (4 * d), 0, 0); tt.setGravity(next ? Gravity.END : Gravity.START); card.addView(tt);
        return card;
    }
}
