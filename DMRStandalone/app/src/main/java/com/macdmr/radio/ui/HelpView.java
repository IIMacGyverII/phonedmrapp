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
    /** The guide for SignalDeck Web: per topic {group, title, summary, heading 1, text 1, heading 2, text 2, …}. */
    public static java.util.List<String[]> topicsForWeb() {
        java.util.List<String[]> out = new java.util.ArrayList<>();
        for (Topic t : TOPICS) {
            String[] r = new String[3 + 2 * t.sections.length]; r[0] = t.group; r[1] = t.title; r[2] = t.summary;
            for (int i = 0; i < t.sections.length; i++) { r[3 + 2 * i] = t.sections[i].head; r[4 + 2 * i] = t.sections[i].text; }
            out.add(r);
        }
        return out;
    }

    static final Topic[] TOPICS = {
        new Topic("Start here", "radio", Neo.CYAN, "Getting started", "Take over the radio, pick a channel, talk.",
            s("1  Take over the radio", "This app and the stock walkie-talkie app cannot share the radio. Open Device and tap Take over: the stock app is paused and its icon hidden until you tap Hand back. The app needs Magisk root to reach the radio's serial port; allow it when Magisk asks."),
            s("2  Pick a channel", "On the Intercom page the round arrows step through your channels. Or open Channels and tap a card, then Use. Your channels come from the stock app the first time and can be edited, added, backed up and restored."),
            s("3  Talk and listen", "Hold the large round key, or the phone's side PTT button, to talk; release it to listen. The key is amber when idle, green while the radio hears someone and red while you transmit. The radio ends any single transmission after 30 seconds."),
            s("The launch screen", "When SignalDeck opens it shows its launch screen for about two and a half seconds, with the version number near the bottom, while the radio comes up behind it. Tap it to skip. Going back to the app while it is still open (launcher icon, recent apps, a notification) never shows it again; it plays only after the app was closed."),
            s("4  Hear more", "Turn on SOFT SQ to hear weaker stations without static, TXT to read live captions of what is said, and SCAN to search the channels of a zone for activity. Each has its own topic in this guide.")),

        new Topic("On the intercom", "intercom", Neo.CYAN, "Intercom", "The main page: channel, talk key, activity.",
            s("Channel", "The big number is the current channel and the title above it is its name. The round arrows step to the previous or next channel of the current zone. On NOAA weather, marine and railroad channels the talk key is dimmed: those frequencies are receive-only."),
            s("Talk key", "Hold to transmit, release to listen. Amber: idle. Green: the radio is receiving. Red: transmitting. The phone's side PTT button and, if you switch it on in Device, the volume-up key do the same."),
            s("Activity panel", "The panel says what is happening (ready, receiving, transmitting, who called) and lists the last events on this channel; the bars are the received audio level. Tap the panel for Last heard. At the top, Alerts lists the warnings and refusals of the last 7 days (for example Android Auto dropping while you talk, a transmission refused on a receive-only or DMR channel, channel busy, keyword alerts), and Car and coverage lists Android Auto and coverage events. Tap one for what it means and what to do, with every line logged within 20 seconds of it, and a button to tune its channel. Below that is everyone and every channel with activity, newest first, with names from your contacts and the RadioID list, plus the recordings player and the caption transcript; tap a heard line to switch to that channel. The small cross on the panel clears its list and hides it until the next reception or transmission; the small button left in its corner brings it back at once. Last heard keeps everything."),
            s("Activity statistics", "Last heard \u2192 Activity counts what the radio received today, in the last 7 or 30 days: receptions and minutes of audio per channel, busiest first, and a bar for each hour of the day with the busiest hour in amber. Tap a channel to tune it. Make a scan zone of the busiest puts the twelve busiest channels into a zone called Busiest channels and selects it, so SCAN searches where the activity is."),
            s("Tone offer", "When a CTCSS tone is heard on an analog channel that has none set, the panel says so. Tap it to make that tone the channel's receive and transmit tone."),
            s("Signal", "The classic page shows the signal strength in dBm in the yellow box. The new look shows a segmented S-meter: S1 to S9 in cyan, then amber and red above S9 (+20, +40), with the S-unit and dBm beside it. When nothing is being received the meter is dark and says NO SIGNAL, with the noise floor the radio reads beside it."),
            s("Two looks", "Device → Radio settings → New intercom look switches between the classic page and the redesigned one. The new page's menu button and a long-press on the classic page's title switch too. Both have the same controls."),
            s("Music, calls and the car", "While something is heard, the radio asks Android for the audio: music and podcasts dip under it and come back 2.5 seconds after the transmission ends. In Android Auto this is what sends the radio to the car speakers: the car plays it like a navigation prompt, turning its music down meanwhile, and the car's navigation volume sets its loudness. When Android Auto starts it takes the audio for a moment; the radio takes it back within a few seconds.")),

        new Topic("On the intercom", "scan", Neo.CYAN, "Scanning and zones", "SCAN searches a zone; ZONE picks one.",
            s("Scan", "SCAN steps through the channels of the current zone, about two seconds each, and stops on a channel with activity. It moves on about two and a half seconds after the activity ends. Tap SCAN again to stop."),
            s("Skip a channel", "Long-press SCAN while it is holding on a channel to leave that channel out for the rest of this scan."),
            s("Priority channel", "In Channels, tap a channel and Make scan priority. While scanning, that channel (even one outside the zone) is checked again after every three other channels and the scan stops there when it is busy, so you do not miss it. While the scan is held on another busy channel, it still checks the priority channel every 10 seconds (a short gap in the audio) and moves to it if it is busy. Its card shows PRIORITY; the same button clears it."),
            s("Soft SQ while scanning", "While scanning, Soft SQ is used on every analog channel at that channel's own level, so weak stations are caught and static is not. A channel that only had Soft SQ for the scan returns to its own squelch when the scan stops. Turn this off in Device → Radio settings to scan with the radio's own squelch."),
            s("Zones", "ZONE opens the zone list: tap a zone to make the arrows, the scanner and the car's channel list use only its channels, or ALL channels for every one. Each zone remembers the channel you last used in it, and choosing the zone tunes that channel (the first time, the radio stays where it is if the channel is in the zone, else it takes the zone's first channel); while you talk, scan or use the VFO the channel is left alone. Starred channels form the ★ Favourites zone; nearby-repeater imports create a zone of their own. Add a zone adds a standard channel list or a zone of your own; the ⋮ on a zone chooses its channels, renames it or deletes it (see Channels → Zones and standard lists).")),

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
            s("While VFO is on", "The arrows step the frequency by the step you chose and the big number reads VFO. Long-press VFO to return to your channel. Save as channel keeps a frequency you want to come back to."),
            s("Band plan", "Under the frequencies, the VFO and the channel editor say what each one is used for: the US amateur band plan for 2 m and 70 cm (repeater inputs and outputs, simplex and calling frequencies, satellites, weak signal, APRS) and the other services in this radio's range (FRS and GMRS, MURS, marine, railroad, NOAA, land mobile, government). It turns amber with a caution where transmitting needs another licence, is not allowed or would disturb a special use. Amateur plans are the typical ARRL ones; your area's coordinator may differ.")),

        new Topic("On the intercom", "rec", Neo.RED, "Record and monitor", "REC saves audio; MON hears every DMR call.",
            s("Record", "REC records everything received on the channel to Download/DMR/Audio. Play them from Last heard → Recordings."),
            s("Monitor", "MON tells the radio to pass every digital call it can decode on the channel, not only those addressed to you or to the talkgroups in the channel's list. It is for the current channel: changing channel (arrows, scan, zone, the car) switches MON off, as the radio does, and the button goes dark.")),

        new Topic("On the intercom", "pkt", Neo.GREEN, "Packet radio", "APRS, APRS-IS, TNC, parrot, Morse, DTMF, weather alerts, SSTV.",
            s("Mode pages", "APRS monitoring (144.390), ISS APRS, the KISS TNC, SSTV receive (also ISS SSTV) and the parrot each open their own full-screen page when they start; for an ISS pass the page also shows the pass (see ISS). The top of the page shows the frequency, whether the radio is listening, receiving or transmitting, the signal and how long the mode has run. APRS: counters (packets since it started, stations, messages for you, last heard), switches for auto-ack, the digipeater, automatic beacons and APRS-IS, and three lists: Live (every packet as it arrives, and what you send), Stations (distance and direction; tap to open in maps) and Messages (tap one for you to reply), with Message, Beacon, Map, Settings and Stop. SSTV: the picture building up, its progress, the pictures received (tap to view or share), Send picture, switching between 144.500 and the current channel, and Stop. Parrot: what it is doing, how many it has repeated, and Stop. The back arrow returns to the intercom and the mode keeps running; a green bar above the tabs (and the PKT button) brings its page back. The mode's icon at the top right opens all the packet tools. Opening the app while a mode runs shows its page first."),
            s("APRS", "Every analog channel is decoded passively: positions, messages, weather and objects go to Stations and the log. Monitor parks the radio on 144.390 MHz, acknowledges messages addressed to your callsign and can act as a fill-in digipeater. Send message and Position beacon transmit from your callsign, set in APRS settings: the callsign alone in its box (letters and digits, up to six) and the SSID in its own (typing CALL-7 in the callsign box is split for you). Packets are real AX.25 frames built each time from your callsign, path and text, sent as 1200-baud AFSK: a 1.6-second steady tone while the transmitter settles, then the packet twice. To the ear every packet sounds alike, so use a decoder (another radio with APRS, or APRSdroid listening through a speaker) to check what went out. Packet, DTMF and SSTV need an analog channel; on a DMR channel they are refused. For your packets to reach aprs.fi a digipeater or iGate has to hear them on 144.390 MHz (North America): use high power and check the raw packets page for your callsign. While APRS monitoring, a satellite pass or another mode runs, the app keeps the phone awake (and exempts itself from battery optimisation) so timed beacons and pass tracking keep going with the screen off; automatic beacons switch the GPS on so each one carries a fresh position. The packet decoder band-passes the audio and runs five slicers side by side at different tone balances, so it also copes with radios whose audio makes 2200 Hz much louder or quieter than 1200 Hz (on direwolf’s standard noise benchmark it decodes more than direwolf itself), and it repairs a packet with a single wrong bit. APRS settings → Transmit power chooses High (default) or Low on the frequencies the app tunes itself (APRS monitoring, ISS, SSTV 144.500); messages and beacons sent from your own channel use its power. APRS settings → Packet lead-in sets what is sent before each packet while the radio’s transmit audio settles: flags (the standard AX.25 TXDELAY, default), a steady tone or silence, and its length (1.6 s by default; shorter values are for testing)."),
            s("APRS-IS", "Connects to the internet APRS network. With your passcode it gates what the radio hears, beacons your position online and delivers internet messages addressed to you; without a passcode it only receives."),
            s("Two-way iGate", "Settings \u2192 Two-way iGate also sends internet messages out on the radio: when someone on the internet writes to a station this radio heard in the last 30 minutes (and the sender is not local too), the message goes out once as a third-party packet via WIDE1-1, and the station's answer comes back to the internet through the normal gating. It needs APRS-IS with your passcode and the radio on 144.390 (Monitor); PKT shows how many were sent."),
            s("Automatic beacons", "Settings \u2192 Beacon: Off, Every N minutes, or SmartBeaconing, which beacons every 30 minutes when parked, more often the faster you go (every 3 minutes above 60 mph) and once more when you turn a corner, so your track looks right on the map without filling the channel. Automatic beacons, telemetry and weather reports only go out while the radio is on 144.390 (Monitor) and no TNC client owns the radio."),
            s("Telemetry and weather", "Telemetry sends the phone's battery level, battery voltage and temperature, air pressure and the received signal as APRS telemetry; the first report and every tenth also send the names, units and scaling, so APRS sites draw graphs. Weather sends a weather report at your position with the barometer's air pressure, converted to sea level from your altitude. Both are buttons in PKT and can run every 30 minutes (Settings)."),
            s("Objects and bulletins", "Object places a marker that you own on everyone's APRS map, such as a net control point, an event or a hazard, at your position or one you type; Remove deletes it from the maps. Bulletin sends a short notice to everyone in range (BLN0 to BLN9); Bulletins lists those heard, including NWS announcements."),
            s("Text and email gateways", "Send message \u2192 Text a phone or Send an email reaches the internet through APRS: SMSGTE texts a US or Canadian phone (\"@number message\"), EMAIL-2 emails an address (\"address message\"), 67 characters in all. It needs an iGate within reach of your signal, or APRS-IS. Replies from a phone come back as APRS messages when SMSGTE knows your callsign."),
            s("Message groups", "Settings \u2192 Message groups: messages addressed to a group name you follow (for example CQ or ARES) notify you like a message to you, without an acknowledgement."),
            s("Satellite passes", "PKT \u2192 Satellite passes lists, for ISS APRS, ISS SSTV, the ISS repeater, ISS voice, SO-50 and PO-101, the passes over you in the next 24 hours that climb above 10 degrees: when, how high, how long and where they rise and set. Orbits come from AMSAT (CelesTrak if AMSAT is down) and refresh after two days; Update orbits fetches them now. Tap a pass to track it: a minute before it rises the VFO takes the satellite's listen and talk frequencies with its access tone, corrected for Doppler (up to about 10 kHz on 70 cm) and retuned whenever the error passes 2 kHz, never while you are talking. After it sets the radio goes back to your channel. The sheet shows the satellite's direction and height and the frequencies live; Stop tracking ends it early. Higher passes are the strong ones; on SO-50 send a 74.4 Hz tone for two seconds first to switch its repeater on. Tracking an ISS APRS or ISS SSTV pass opens its page."),
            s("ISS", "The space station's packet digipeater is on 437.825 MHz (70 cm) since ARISS moved it in 2026, and its SSTV picture events use 437.550. On 70 cm a pass shifts the signal by up to 10 kHz (Doppler), more than an FM channel tolerates, so PKT \u2192 ISS APRS and ISS SSTV do not just park on the frequency: they wait for the next pass above 10\u00B0 (or the one in progress), tune a minute before the ISS rises, follow the shift every couple of seconds and come back to your channel when it sets, then wait for the next pass, until you stop. Their page shows the countdown, then the ISS's height and direction, the corrected frequency and when it sets. Until a minute before the pass the radio stays on your channel (you can keep using it), so the top of the page says WAITING FOR THE PASS, shows the pass frequency dimmed and the time it tunes; an ISS SSTV session starts with an empty picture. ISS APRS decodes what the station digipeats; Beacon on its page (or PKT \u2192 Beacon via ISS) sends your position through it with the path ARISS, with both frequencies corrected, and only while the ISS is in view. ISS SSTV is receive only (transmitting is blocked) and saves each Robot 36 picture; during a picture the retune waits until the error reaches 5 kHz so the picture is not torn. ARISS changes the station's modes often: Satellite passes \u2192 ISS frequencies holds them (APRS, SSTV, repeater, crew voice) with a link to the ARISS status page. The ISS and satellites zone list has fixed + / plain / - channels too."),
            s("KISS TNC", "Serves APRSdroid or YAAC on 127.0.0.1:8001 on whatever channel you are on, sending and receiving. The app sends complete frames and the radio transmits them as they come (each with the same 1.6-second settling tone first); tune an analog APRS channel first."),
            s("DTMF", "Keys heard on any analog channel are logged. Send a sequence from the keypad or from your saved sequences; saved ones are kept in backups as DTMF.csv."),
            s("DTMF remote control", "PKT \u2192 DTMF \u2192 Remote lets another radio control this phone: turn it on and set a PIN of 4 to 6 digits. From the other radio, key the PIN and one command digit as one sequence (a * before and # after are fine): 1 says the position (nearest town and coordinates), 2 says the status (battery, channel, signal), 3 sends an APRS position beacon, 4 and 5 turn the parrot on and off, 6 sends the Morse ID. The phone answers on the channel 1.5 seconds after the caller lets go, with your callsign in Morse after a voice reply on amateur channels. Three wrong PINs within ten minutes lock it for ten minutes, and the PIN is never written to the history or the DTMF log. It is off by default."),
            s("Weather alerts", "NOAA SAME alerts are decoded automatically on the weather frequencies and raise a notification."),
            s("SSTV", "Receive pictures on 144.500 MHz or on the current channel, and send a picture from your gallery as Robot 24 Color, Robot 12 BW or Robot 8 BW. Two decoders, switched on the SSTV page: Any mode recognises Robot, Martin, Scottie and PD pictures from the VIS header that starts every transmission. Robot 36 continuous works like MMSSTV: it needs no header, it locks on the line sync pulses, so a picture picked up halfway is still drawn (and moved to the bottom, where its last line belongs), it keeps the line rhythm through fades instead of losing lines, it reads each line’s colour from its separator tone, and the screen shows the static until a picture comes in. ISS SSTV always uses it (ISS events are Robot 36). Pictures, and partial ones of 16 lines or more, are saved to Download/DMR/SSTV."),
            s("RTTY and PSK31", "PKT \u2192 RTTY and PSK31 are the keyboard chat modes of fldigi and other sound-card programs, used by clubs and emergency groups. Pick RTTY 45 (45.45 baud, 170 Hz shift, Baudot) or PSK31 and Listen: the decoder finds the signal anywhere in the audio and follows it, and prints only while a clean signal is there, not static. Type a line and Send to answer on the frequency being received (or on 2125 Hz mark for RTTY and 1000 Hz for PSK31 when nothing is). Long text is split into several transmissions, because this radio ends each one at 30 seconds. Capital letters are slower in PSK31 than small ones."),
            s("Packet terminal", "PKT \u2192 Terminal connects to a packet bulletin board (BBS), node or another station's terminal on the current channel with AX.25 connected mode, the way a TNC does: enter the callsign (with its SSID, for example N0ABC-1), optionally up to two digipeaters, and Connect. Type a line and Send; what the other side sends appears below. Every transmission starts with this radio's 1.6-second settling tone, so each exchange takes a few seconds; frames that get lost are sent again, up to six tries 15 seconds apart before the link is given up. Incoming: accept lets other stations connect to you (you get a notification). It needs your callsign in APRS settings."),
            s("Simplex repeater (parrot)", "PKT \u2192 Parrot on this channel records each transmission heard on the current channel and sends it back a second after it ends, up to 26 seconds (the radio's 30-second limit). A station can check how it sounds, or two stations that cannot hear each other can talk through you. Very short key-ups are not repeated. On amateur channels, with your callsign set in APRS settings, the playback ends with your callsign in Morse at most every ten minutes. The squelch must close on silence (a squelch level above 0, or Soft SQ), or the parrot would repeat static. It stops when you change channel; each repeat is listed in the channel history."),
            s("Morse trainer", "PKT \u2192 Morse trainer teaches Morse code with the Koch method on the phone's speaker (nothing is transmitted). Each lesson adds one character in the usual LCWO order, starting with K and M. Play 5 groups sends five groups of five characters at the character speed with Farnsworth spacing; type what you copied and Check: at 90 % or better the next lesson opens. Set the character speed (5 to 35 WPM, 20 is a good start) and the spacing speed with the - and + buttons; your lesson and speeds are remembered. Sending practice: tap and hold the KEY for dits and dahs; after a short pause the app's Morse decoder shows what it read and your speed."),
            s("Voice keyer", "PKT \u2192 Voice keyer holds three recorded messages (named CQ, Net preamble and My ID at first; tap a name to rename it). Record, speak, Stop: up to 25 seconds from the phone's microphone, with silence at the ends trimmed and the level evened out. Listen plays it on the phone; Send transmits it on the current analog channel after a 1.5-second lead, with your callsign in Morse after it when ID is on and the channel is an amateur one."),
            s("ID timer", "Amateur rules ask for your callsign every ten minutes during a contact and at its end. On amateur channels the timer starts with your first transmission after you last identified; once ten minutes have passed the phone vibrates and reminds you as you key (unless Morse ID after I talk does it for you). Any Morse ID restarts it; after saying your callsign, tap I just identified in the Voice keyer. PKT shows the time left."),
            s("Morse", "Morse code heard on an analog channel, such as a repeater's identification, is decoded and written to the channel history with its tone and speed; when it contains the callsign in the channel's name it is shown as the repeater's ID, confirming you hear the repeater you programmed (5 to 40 words per minute; Settings \u2192 Morse decoder turns it off). It needs a clean keyed tone: voice, static and DTMF are ignored, and a message shows once it has ended and contains a callsign (or at least eight characters of text), so stray tones are not taken for Morse. Send my callsign in Morse transmits your APRS callsign on the current channel. Settings \u2192 Morse ID after I talk adds it at the end of your transmission on amateur channels (2 m, 1.25 m, 70 cm) at most every ten minutes, the identification amateur rules ask for; it goes out like the roger beep, before the radio unkeys, and is skipped when the transmission is already close to the 30-second limit."),
            s("The PKT key", "PKT lights while APRS monitoring, SSTV receive, the TNC or the parrot is running.")),

        new Topic("Pages", "report", Neo.GREEN, "Logbook", "Your contacts, and the stations the radio heard.",
            s("Opening it", "PKT \u2192 Logbook. Entries are newest first; contacts are green, stations only heard are grey."),
            s("Stations heard", "With Log heard on (the default), the radio logs stations by itself: DMR callers whose ID has a callsign in the RadioID list, every APRS station decoded, and callsigns in Morse identifications. One entry per station and mode per hour; the frequency is the channel it was heard on."),
            s("Contacts", "Add contact starts an entry for now on the current channel, with 59 as the reports. Tap any entry to edit the callsign, frequency, mode, reports, name and notes, to mark it a contact (QSO) or only heard, or to delete it."),
            s("Callsign lookup and grid squares", "With Look up on, callsigns heard or logged are looked up in the free HamDB directory (US and Canadian licences and some others; only the callsign is sent, and answers are kept for 30 days): the name, location and grid square fill in by themselves, and each entry shows the distance and direction from you. Look up the callsign in an entry does it on demand. The top line shows your own grid square and how many grid squares you have worked (contacts only, four-character squares, as the VUCC award counts them). Net control check-ins get their names the same way."),
            s("ADIF", "Export ADIF writes every entry to Download/DMR/Logbook as an .adi file (ADIF 3.1) and offers to share it, for logging programs and QSL services such as LoTW or QRZ. Grid squares and locations go out as GRIDSQUARE and QTH. DMR entries are mode DIGITALVOICE, submode DMR; stations only heard carry SWL, so a logging program does not count them as contacts.")),

        new Topic("Pages", "help", Neo.VIOLET, "Exam practice", "Practise for the amateur licence exams.",
            s("The pools", "PKT \u2192 Exam practice has the three current US question pools: Technician (Element 2, 2026\u20132030, 409 questions), General (Element 3, 2023\u20132027, 423) and Amateur Extra (Element 4, 2024\u20132028, 599), with their figures. They are the official NCVEC pools (public domain), in the machine-readable edition by Russ Olsen. Everything works offline."),
            s("Practice exam", "Draws one question from each group, the way the real exam is put together: 35 questions for Technician and General (26 to pass), 50 for Extra (37 to pass). There is no feedback until the end; then you get the score, pass or not, and every miss with the right answer. Your best score is kept."),
            s("Study and review", "Study a subelement goes through all of its questions in random order and shows the right answer after each. Missed questions brings back every question you got wrong (in an exam or in study) until you answer it right.")),

        new Topic("Pages", "contacts", Neo.CYAN, "Net control", "Run a net: check-ins, traffic and a report.",
            s("Starting", "PKT \u2192 Net control. Name the net (the last name is remembered) and Start the net on the current channel. A clock shows how long it has run; the net keeps running if you close the sheet."),
            s("Check-ins", "Type a callsign and Check in, or tap one of the stations heard in the last 30 minutes (DMR callers with a RadioID callsign, APRS stations, Morse IDs; names come from the logbook). Stations checking in more than 15 minutes after the start are marked Late. Tap Traffic, Late or Out on a station to flag it; stations with traffic are highlighted. Long-press a station to remove it."),
            s("Ending", "End the net, then Share the report (name, channel, times, net control and the numbered check-ins with their flags) or Add to logbook to log every check-in as a contact. Past nets are listed under Net control; tap one for its report, long-press to delete it.")),

        new Topic("Pages", "locate", Neo.GREEN, "Fox hunt", "Find a hidden transmitter, or be the fox.",
            s("Opening it", "PKT \u2192 Fox hunt, or the menu of the new intercom look \u2192 Fox hunt. Tune the fox's channel first: the hunt listens on the current channel."),
            s("The readout", "The big number is the signal strength in dBm (higher, closer to zero, is stronger), with the S-meter and the peak since you opened it or cleared. Beeper on clicks through the phone faster and higher as the signal rises, so you can hunt without looking. Pointing shows the compass bearing of the top of the phone, corrected to true north."),
            s("Marks and the estimate", "Hold the phone against your chest and turn slowly: your body blocks the signal from behind, so the strongest reading is when you face the fox. Point the top of the phone that way and tap Mark: the reading, your position and the bearing are saved. After two or more marks from different places, the app works out where the bearing lines cross, giving stronger readings more weight, and shows the distance and direction from you; the plot shows your marks (cyan weak, amber medium, red strong) with their bearing lines and the estimate as a green ring. Without bearings, the strongest mark is the hint. Open in maps shows the estimate in your map app. Marks stay until Clear marks, even if you close the sheet."),
            s("Close to the fox", "Near the transmitter every reading is at the top of the scale. Off-frequency listens 10, 20 or 30 kHz above the channel, where the fox's signal is much weaker, so the readings start to change again as you move. Closing the sheet tunes back to the channel."),
            s("Be the fox", "Start the fox beacon sends 5 seconds of beeps on the current channel every minute until you stop it or change channel; on amateur channels your callsign follows in Morse. PKT lights while it runs. Hide the phone, with a full battery.")),

        new Topic("Pages", "channels", Neo.CYAN, "Channels", "Your channel list, favourites and repeaters.",
            s("The list", "Each card shows the channel number, name, receive frequency, FM or DMR, and the one detail that matters: colour code and slot, repeater shift or tone. The active channel glows and says ON AIR."),
            s("Find and filter", "The search box matches names, frequencies (type 462.6) and channel numbers. The chips show all, favourites, analog or DMR channels. The zone button at the top opens the zone list."),
            s("Zones and standard lists", "The zone button lists your zones; tap one to use it. Add a zone offers ready-made lists, each added as its own zone: FRS (22 channels, no licence), GMRS (the 22 channels plus repeater channels 15R to 22R, US licence needed; pick your repeater's CTCSS tone before adding), NOAA Weather (7, receive-only), MURS (5 licence-free VHF channels), Marine VHF (10, receive-only), Ham simplex (2 m and 70 cm calling and simplex channels and APRS), DMR simplex (6 channels, colour code 1, slot 1, talkgroup 99, with a Simplex contact), Business (12 US itinerant dot and star channels, licence needed), Railroad (the 96 AAR channels, receive-only), ISS and satellites (ISS voice, APRS on 437.825, SSTV on 437.550 and the cross-band repeater, SO-50, with Doppler + and - channels and the 67 Hz access tone), UHF CB (Australia and NZ, with the repeater R channels) and PMR446 (16, Europe and UK). A channel you already have on the same frequency and tones is reused rather than added twice, and adding a list again only adds what is missing. Licence-free lists are set to low power. New zone from your channels names a zone and lets you tick its channels. The ⋮ on a zone: Use, Choose its channels, Rename, Delete the zone (its channels stay), or Delete the zone and its channels (only those in no other zone)."),
            s("Favourites", "Tap a card's star to add or remove it. Starred channels form the ★ Favourites zone, so the arrows and the scanner can be limited to them."),
            s("Use, edit, delete", "Tap a card for Use (switch to it), Edit, Star or Delete. The + adds a channel."),
            s("Editing", "Every field in the channel editor has an info button that explains what it does on this radio. Analog channels need a frequency, power, bandwidth and optionally CTCSS or DCS tones; Soft SQ and its level can be set here too. A latitude and longitude gives the intercom the place name, distance and bearing: My position uses the phone's location; Open Maps shows the spot in your maps app, where Share \u2192 SignalDeck sends a place back; Paste reads coordinates or a maps link you copied. Sharing a place to SignalDeck while no editor is open asks which channel it belongs to. DMR channels also need a colour code, a time slot, a call target (a DMR ID for a private call or a talkgroup for a group call) and the talkgroups you want to hear on that channel, up to 32 (a group call's own talkgroup is added to that list when you save, because the radio passes only listed talkgroups). Talkgroup lists under the RX group list inserts a saved, named list in one tap or saves the current one; the DMRModHooks module's lists come over from the stock app. VHF channels are always wide band on this radio; narrow band makes its receiver deaf."),
            s("Nearby repeaters", "The dish button lists DMR repeaters from BrandMeister and RadioID and FM repeaters from hearham around you, nearest first, within 15, 30, 60 or 120 miles. The two rows under the distances show only FM or only DMR repeaters, and only VHF (136 to 174 MHz) or only UHF (400 to 480 MHz); the app remembers your choice. One tap adds a repeater with its channels, talkgroup contacts and a zone, and it can be undone.")),

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
            s("Radio settings", "Switches for owning the radio at boot, the side PTT key, volume-up as PTT, Soft SQ while scanning, coverage logging (see Coverage maps), voice announcements (channel changes, caller names, keyword alerts; when you change channels quickly only the channel you stop on is spoken, and while scanning only a stop on activity and the channel you end on), the roger beep, the new intercom look, and Animated panel when quiet (the falling lines in the intercom panel on an idle channel; they always move while receiving, and turning this off saves a little battery)."),
            s("Your DMR ID", "What other radios see when you talk on DMR channels. Change sets it."),
            s("Tools", "Back up writes the five OpenGD77-style CSV files (Contacts, TG_Lists, Channels, Zones, DTMF) to Download/DMR/DMR_Backups; Restore reads any such folder, including codeplugs edited in the OpenGD77 CPS fork. The files use the same columns as the DMRModHooks module, so backups move between the module, this app and the CPS fork; saved talkgroup lists travel in TG_Lists.csv. Re-import copies an area's channels from the stock app. RadioID list downloads the names behind DMR IDs from radioid.net. Updates installs a newer SignalDeck release in place. Diagnostics shows the live protocol log and radio tools (module version, power-cycle, test tone) and Check backup round trip, which exports everything, restores it into a scratch copy and lists any field that would not survive; your channels are not touched."),
            s("Device report", "For a phone without a profile, the Device report tile collects what a profile needs, captures what the side PTT key sends, runs the root-only radio probe, and shares the result or opens a pre-filled GitHub issue. Nothing on the phone is changed.")),

        new Topic("Pages", "device", Neo.CYAN, "SignalDeck Web", "Use the radio from a browser on your Wi-Fi.",
            s("Turning it on", "Device → SignalDeck Web → Web access. The card then shows the address to open (for example http://192.168.1.20:8080) and an 8-character PIN. Open the address in any browser on the same Wi-Fi network, type the PIN once, and that browser stays logged in for 30 days of use. It is off until you turn it on, and it stays on after a reboot until you turn it off."),
            s("What it shows", "Its own pages, not a copy of the phone's screen. Intercom: the channel, frequency, S-meter, receive and transmit state with the caller, the channel's history as it happens, live captions, the channel arrows, SCAN, MON, REC, Soft SQ with its level, the zone, and LISTEN, which plays the radio in the browser: exactly what the phone's speaker plays (after the squelch), about a quarter of a second behind, with its own volume. Several browsers can listen at once; it uses about 16 kB/s of Wi-Fi while someone is talking and almost nothing while the channel is quiet. A small bar next to RX/TX shows the audio level. Under it: Last heard (callers and stations grouped like the phone's sheet; click one to tune its channel) and the week's alerts and events. VFO (on the Intercom and Channels pages): tune any frequency with every channel setting, the arrow step, and Back to the channel. Channels: the list of the selected zone with search; click a channel to tune it, Edit to change it (every field of the phone's editor, with the same checks and the same i explanations), New channel to add one, Delete to remove one. Under the list, Zones: make, rename and delete zones and tick their channels (All / None work on the filtered list); a change to the zone in use applies at once. APRS: the packets and stations heard, monitoring on and off, a beacon and messages. SSTV: the picture as it arrives, the saved pictures, and Send a picture (PNG or JPEG from the computer, as Robot 24 Color, Robot 12 BW or Robot 8 BW on the current analog channel; needs Allow transmit from the web). Satellites: the pass being tracked, ISS APRS, ISS SSTV and Stop, and every satellite's passes over you in the next 24 hours (click one to track it; it replaces the current tracking after asking). Logbook: log a contact (frequency and mode filled from the channel), edit or delete entries, show contacts only, export ADIF. Under the logbook, Net control: start a net on the current channel, check stations in (names are looked up when left empty; stations heard in the last 30 minutes are one click away), mark Traffic, Late or Out, remove, end the net, and open or download any net's report. Recordings: the REC recordings, newest first, to play in the browser, download or delete. Packet: APRS-IS, the KISS TNC, the parrot repeater and the fox transmitter as switches (parrot and fox need Allow transmit from the web), Send Morse ID, the voice keyer (upload a recording from the computer into any of the three messages, play it, Send it with an optional Morse ID; the station-ID timer shows when you are due to identify), text modes (listen for RTTY or PSK31, see what is decoded, send text), the packet terminal (connect to a BBS or node, send commands, accept incoming connections), DTMF sending (your saved sequences one click away) and the DTMF heard, the weather alerts received, and all APRS settings (station, beacons, transmit power and lead-in, decoders, APRS-IS and KISS). Your callsign and APRS-IS passcode are never shown in a browser: leave those boxes empty to keep them. Exam: the licence exam practice (practice exam, study a subelement, review missed) with the figures; keys A–D answer and Enter goes on, and missed questions and best scores are the same as in the phone's Exam practice. Under it, the Morse trainer (Koch method, the same lessons and speeds as on the phone): play ten groups of five in the browser, type what you hear, Check; 90 % moves you to the next lesson. Settings: who owns the radio, Take over and Hand back, the browsers connected and listening, and the Device page's settings (DMR ID, boot, side PTT, volume-up, Soft SQ while scanning, roger beep, voice announcements, keyword alerts, logbook, coverage and car settings). Backup and restore there too: Back up now writes the five CSV files to Download/DMR/DMR_Backups, Download gets any backup as a .zip, Restore puts one back, and you can restore from CSV files on the computer (a backup or an OpenGD77 CPS export). The Diagnostics log there shows the phone's recent radio log, for troubleshooting from the computer. Web access itself, its PIN and Allow transmit from the web change only on the phone. Messages: your DMR text conversations, with quick replies and sending. Contacts: add, edit, delete and text contacts. Map: the APRS stations heard (at the positions they sent) and channels with a location, on a dark OpenStreetMap; drag, zoom with the wheel or the buttons, click a marker for details or to tune a channel. The Repeaters layer adds the repeaters within your search radius (the same catalog as Nearby repeaters on the phone); click one for its frequencies, tones or colour code and talkgroups, then Add to my channels shows what will be programmed and adds it. The Coverage choice draws the coverage maps measured by Coverage logging: signal heard (each square in the median signal, on the phone's colour scale) or transmit reached (green: a transmission from there keyed the repeater, red: no reply); click a square for its numbers. Help: this guide, searchable. A bar under the title shows any mode that is running. The phone and every open browser stay in step: a change made on either shows on the others at once."),
            s("Transmitting", "A browser never transmits unless Allow transmit from the web is on. With it on, the PTT button keys the radio while you hold it (or hold the space bar); letting go, switching tabs or leaving the window always unkeys. On the plain address (http://…:8080) the phone's own microphone transmits. To talk with the computer's microphone open the secure address the Device card shows (https://…:8443): the browser warns once that the certificate is the phone's own (compare the fingerprint on the Device card) and asks once for the microphone; after that PTT sends your voice from the computer, with the phone's 30-second limit, and the phone stops by itself if the browser goes quiet for 1.5 s or the connection drops. Only one person can talk at a time. Every transmission started from a browser is written to the channel's history with the browser's address. APRS beacons, messages and the other transmit tools follow the same switch."),
            s("Safety", "The server only answers addresses on your own network (home Wi-Fi, hotspot) and refuses the internet. Five wrong PINs from one address wait a minute. A browser stays logged in across app restarts and phone reboots (the phone keeps only a fingerprint of each login, never the login itself). New PIN makes a new one and logs every browser out; turning Web access off closes the server. Your callsign's passcode and keys are never sent to a browser."),
            s("If it does not open", "Phone and computer must be on the same network (a guest Wi-Fi often keeps devices apart). If the card says Not running, another app is using port 8080; restart SignalDeck. The address changes when the phone joins a different network; the card always shows the current one.")),

        new Topic("Pages", "map", Neo.CYAN, "Map", "APRS stations, repeaters and channels around you.",
            s("Open it", "Intercom menu → Map, or the map icon at the top of Channels."),
            s("What is on it", "Green dots: APRS stations heard by the radio or APRS-IS, at their last position. Cyan diamonds: FM repeaters; violet diamonds: DMR repeaters, within the Nearby repeaters range (15 to 120 miles). Amber pins: your channels that have a location (channel editor → Location). Blue dot: you, moving with the phone while the map is open; the soft circle around it is how accurate the fix is."),
            s("Moving around", "Drag to move, pinch or double-tap to zoom. The buttons on the right zoom in and out, go back to your position, and fit everything on screen. The pills at the top hide or show stations, repeaters and channels."),
            s("Markers", "Tap one for a card: a station shows when it was heard, its path, speed, altitude and comment; a repeater shows its frequencies and tone and opens its details to add it as a channel; a channel can be used straight away. Every card can open the place in your maps app."),
            s("Coverage", "The violet Coverage pill adds your measured coverage: where each repeater was heard and where your transmissions keyed it. See Coverage maps."),
            s("Map tiles", "From OpenStreetMap (© OpenStreetMap contributors), darkened to match the app and kept on the phone for 30 days, so places you have looked at still show offline.")),

        new Topic("Pages", "signal", Neo.VIOLET, "Coverage maps", "Where your repeaters really work, measured as you go.",
            s("What it does", "With coverage logging on, the app measures each repeater wherever you hear it and checks whether it answers when you transmit. Over time the Map shows two pictures: where the repeater reaches you, and where you reach the repeater. You just use the radio normally; walks and drives fill the map in."),
            s("Turn it on", "Device \u2192 Coverage logging, or Map \u2192 the violet Coverage pill \u2192 Log coverage (the same setting). It uses GPS while it is on, and keeps working with the screen off once you have switched it on with the app open. While it is on, the radio notification says Mapping coverage. Switch it off the same way. Everything stays on the phone."),
            s("Which channels", "Channels that have a location: the repeater's position, which channels added from Nearby repeaters get automatically (or set it in the channel editor \u2192 Location). Key-ups are judged only on repeater channels, where the transmit and receive frequencies differ."),
            s("Heard: repeater to phone", "Each time you hear the repeater, the signal strength is stored with your GPS position (only fixes better than 50 m, at most one reading every 5 seconds unless you moved 25 m). On DMR the radio reports a call only with the channel's colour code; on analog with a CTCSS tone the app checks the tone, so other stations on the frequency are not counted. The map shows 150 m squares coloured by the typical reading, from blue (barely heard, about S3) through green to red (S9+30)."),
            s("Key-ups: phone to repeater", "After each transmission of more than half a second on a repeater channel, the app reads the signal five times in the next two seconds. A repeater keeps transmitting for a moment after you let go (its tail or hang time); if that signal stands 8 dB above the channel's quiet noise floor, you keyed it from there (green). If nothing comes back it is a no reply (red). The Last heard history notes each result."),
            s("Driving with a steady signal", "While a station keeps transmitting, a reading is stored every 2 seconds as long as you keep moving (every 5 seconds when you stand still), so a drive draws a continuous track: at 60 mph about one reading every 55 m."),
            s("NOAA weather: the best way to start", "NOAA Weather Radio channels (162.400 to 162.550 MHz) transmit all the time, so on them every reading is stored, heard or not: weak spots and dead zones show up in blue instead of staying empty. Give the NOAA channel its transmitter's location (channel editor → Location), select it, turn on logging and drive around: the map shows that transmitter's real coverage, and the prediction calibrates itself from it."),
            s("While scanning", "Logging carries on during a scan: whenever the scan stops on a channel that has a location and hears it, the readings are stored for that repeater. Each channel keeps its own quiet noise floor across scan visits, so a transmission after the scan stops on a repeater is judged too."),
            s("Key-up test", "Coverage sheet \u2192 Key-up test here: on an FM repeater channel it transmits your callsign in Morse (about 3 seconds at 20 words per minute, your station identification) and records whether the repeater answered, without having to call anyone. It needs your callsign (PKT \u2192 APRS settings) and logging on, and asks before transmitting. On DMR, call the Parrot (private call 9990 on BrandMeister) instead: hearing your own call back proves both directions. Use it sparingly; repeaters are shared."),
            s("Reading the two layers", "The Heard layer usually reaches further than Key-ups: the repeater has a big antenna and more power than a handheld. Plan by Key-ups. No-reply squares are shown only for repeaters that have answered you somewhere, since a repeater with no tail never answers. Someone else talking right after you can look like a key-up; it is rare."),
            s("Live while you watch", "With the map open, new readings appear within a couple of seconds and your blue dot follows you. The prediction re-calibrates itself from the new readings at most every 2 minutes (a full recalculation takes about half a minute)."),
            s("Focus and details", "The Coverage sheet picks the layer (Off, Heard, Key-ups) and one repeater or all of them (each square then shows the best one). Tap a square for its reading, or a channel pin \u2192 Coverage to focus on it. The legend in the corner opens the sheet."),
            s("Terrain prediction", "Pick one repeater (Coverage sheet, or a repeater or channel on the map \u2192 Coverage) and the map adds faint squares: the range predicted from the hills and valleys between you and the repeater, by default (Auto) as far as the transmitter's power and antenna height can carry over flat ground, up to 50 miles, or a range you pick. It works before you have measured anything, so you can check a repeater before adding it. A picked range is a minimum: the prediction always reaches out to your position and to everything you have measured (up to 50 miles), so a reception far outside the expected range is never left off the map. The repeater's antenna height is Auto by default: once your Heard readings cover a range of distances, the app tries heights from 10 to 350 m and keeps the one that explains them best (a tall tower carries much further over the hills); with fewer readings it uses 30 m. Pick a height, or Set the exact one, if you know it. Transmitter power works the same way: Unknown assumes 50 W and lets your measurements correct the level; NOAA Weather Radio stations publish theirs (most are 1000 W), and repeater owners often list theirs."),
            s("How it is calculated", "For each square: the loss over smooth ground (the direct signal plus its reflection off the ground within the radio horizon, the earth's curve beyond it, per ITU-R P.526), plus whatever the hills between add as obstacles. Heights are taken above the surrounding ground, so a transmitter on a hill or a phone on a rise gets credit, and a valley costs signal. The transmitter's power and antenna height set the level; your measurements correct it."),
            s("How the prediction learns", "It starts from typical numbers (a 50 W repeater, a 4 W handheld, 12 dB for trees, buildings and your body). Your Heard readings shift its signal level to match what you really received; your key-ups move the limit of where you can reach the repeater. Until you have key-ups, the reach follows the Heard correction too, since it is the same path both ways. Each square's card says whether it is measured or predicted and how well calibrated the prediction is. Your altitude counts through the terrain: the ground height at your position and at the repeater is in every calculation, so a hilltop or a valley is accounted for (the phone's own GPS altitude is not used: it is typically 10 to 30 m off). Trees and buildings are not in the terrain data, so forests and towns usually come out weaker than predicted until you have measured there."),
            s("Terrain data", "Heights come from the open Terrain Tiles (AWS Open Data, about 55 m detail). The first prediction for an area downloads them (a few megabytes); after that they are kept on the phone and predictions work offline."),
            s("Export and clear", "Export writes Download/DMR/Coverage/<date>/ with coverage_rx.csv and coverage_tx.csv (every reading, for a spreadsheet) and coverage.kml, which opens in Google Earth with coloured squares and green/red key-up points per repeater. Clear deletes the readings of the selected repeater, or all of them."),
            s("Good habits", "Carry the phone the same way when you compare places: a pocket or a car costs 10 to 20 dB. Do not key a repeater just to test it; use your normal conversations, and identify with your callsign as always.")),

        new Topic("Pages", "radio", Neo.GREEN, "Android Auto", "The radio on your car's screen.",
            s("In the car", "Connect the phone to Android Auto and the radio appears among the media apps (SignalDeck): on the car's app list (it may be on a later page) and as the media card on the car's home screen; tap the card for the full media screen. Press play there (or on the card) to hear the radio through the car's speakers: the radio then becomes the car's media source, like any music app, and pause hands the speakers back. Its card and media screen show a small version of the intercom panel: the zone (when the channel is in it), the channel digits (red while you transmit), frequency, mode chips, a state badge (receiving, transmitting, scanning, ready, paused) and a live signal meter. During a DMR call the chips become the talker's callsign and the talkgroup (or Private call), and the subtitle reads who is talking with their DMR ID and the talkgroup (for example VE3UOD Richard John William · 1023036 · TG 11904); Radio controls shows the same on its Talking line; the channel list shows each channel's number tile. The radio keeps its connection to the radio module on the phone; Android Auto only shows and controls it."),
            s("Choosing a channel", "On the media screen, the arrow at the top left opens the channel list: Last heard first (who and what was received, newest first; tap one to tune that channel), then a tab for each zone (including Favourites once you have starred channels), with More holding the rest and All channels. Tap a channel to tune it. In Radio controls the Channels button lists the same. Previous and next, also on the steering wheel, step through the zone. The search button finds a channel by name, number or frequency, and \"Hey Google, play NOAA WX6 on SignalDeck\" works too."),
            s("Talk", "The microphone button on the media screen transmits: tap to start, tap again to stop; it ends by itself after 28 seconds, before the radio's 30-second limit. Receive-only channels refuse it. With Device \u2192 Car microphone in Android Auto on (the default) and the car connected over Bluetooth too, the car's own microphone is used through its hands-free link (the link takes a second to come up before the radio keys); otherwise the phone's microphone. The phone's side PTT key works as always."),
            s("Radio controls (big Talk button)", "Android Auto gives media apps only small buttons, so the radio also has its own car screen. It is off by default: turn on Device \u2192 Full-screen Radio controls in the car, then reconnect the car, and open Radio controls from the car's app list. It shows the live panel, the channel and its status, two wide buttons, TALK (green; red with STOP TALKING while you transmit) and Channels, and arrows at the top right for the previous and next channel. Channels lists Favourites first (your starred channels; until you star some it says how), then every zone and All channels; tap a channel to tune it. Inside a zone, Scan at the top scans exactly that zone (Stop scan ends it). While it is on, Android Auto lists it instead of the media app; the radio's media card, steering-wheel buttons and lock-screen controls still work. If the car does not list it, see If the radio is missing. The radio history records what Android Auto did (connected, opened the media app or Radio controls, took the sound away), so a drive can be checked afterwards. Talk works as on the media screen, with the car microphone when available."),
            s("Scan, pause", "The scan button starts and stops a scan of the zone. Pause mutes the radio's sound; it keeps receiving, decoding and logging underneath, and play brings the sound back. Pressing play in the car makes the radio the car's media source (other media pauses)."),
            s("How it sounds", "When you are not playing the radio as the car's media, anything it receives still comes through the car speakers like a navigation prompt, with the car's music turned down meanwhile; the navigation volume sets its loudness."),
            s("Messages read aloud", "Incoming DMR texts, APRS messages (over the air and APRS-IS) and NOAA weather alerts arrive as conversations: on the phone, and in the car Android Auto announces them and reads them aloud. Reply by voice and the answer goes back the way the message came: a DMR text to that ID or talkgroup (needs a DMR channel tuned), an APRS message over APRS-IS when it came from there, otherwise over the air on the current channel. Weather alerts have no reply. Diagnostics \u2192 Post a test car message shows what it looks like (its reply is never sent)."),
            s("Coverage while you drive", "With Device \u2192 Log coverage in the car on (the default), coverage logging starts when Android Auto connects and stops when it disconnects (unless you had switched it on yourself), so drives fill in the coverage maps by themselves."),
            s("Next as a talk key", "Device \u2192 Steering-wheel Next talks (tap to choose Off, Hold or Double-press; Double-press by default, only while Android Auto is connected). Hold: hold the wheel's Next button for half a second and the radio transmits until you let go; some cars send the release late or not at all, so if it keeps transmitting, press Next once more to stop. A short press still goes to the next channel. Double-press: press Next twice quickly to transmit and once to stop; a single press goes to the next channel after half a second. Double-press uses only presses, so it works even where releases are unreliable. Both need the car to pass the button itself to the app: some cars send Next only as a command, and the history then says so. Steering-wheel microphone chooses the microphone for transmissions started from the wheel. Car (as a call, the default): the car's microphone works through its hands-free link, and while that link is open the car treats the wheel as call controls, so a wheel start becomes a short \"call\" (SignalDeck: talking) and the wheel's hang-up button or End on the car screen stops the transmission; it never appears in the call log. If the car does not open its microphone within 4 seconds, that transmission uses the phone's microphone and the history says so. Phone: the phone's microphone, and the wheel's Next or play/pause stops as usual. Stop when I stop talking (Off, 1.5, 2.5 or 4 s; 1.5 s by default): for wheel-started transmissions, the radio unkeys once you have been quiet that long (or after 6 seconds if you never speak), measured against the road noise. With a mode on, the history also shows the first wheel presses of each drive."),
            s("Steering-wheel Talk", "Device \u2192 Steering-wheel play/pause talks (off by default): in Android Auto the wheel's play/pause button starts transmitting and a second press stops (28-second limit as always). The play/pause button on the car screen still pauses the radio's sound. Only the wheel's media buttons reach an app (play/pause, previous, next): the voice button belongs to Google's assistant (it needs the Google app enabled on the phone; \"Voice commands are not available right now\" means it is not) and the phone button to the car's dialer."),
            s("Last heard", "In Radio controls \u2192 Channels, Last heard lists who and what was received, newest first, with the time and channel (and talkgroup for DMR). Tap one to tune that channel."),
            s("If Android Auto drops while you talk", "With the phone on a USB cable, the radio's own transmission can get into the cable and reset the phone's USB port: Android Auto disconnects about a second after you start talking and reconnects when you stop, and the phone stops charging meanwhile. It does not matter which Talk button you use. It depends on the frequency, not on where the antenna is (the cable itself picks up the signal): in one car a 2 m repeater transmitting on 144.770 MHz at high power dropped it every time while 146.370 MHz did not. The app notices it: the radio history notes the channel and frequency and the phone shows a notification. What helps: a snap-on ferrite choke on the cable close to the phone, a shorter, better-shielded cable, Low power for that channel (Channels → edit the channel), or wireless Android Auto if the car has it."),
            s("If the radio is missing", "Android Auto only trusts apps installed from the Play Store. For this app it plays the sound and the steering-wheel buttons work, but SignalDeck (and Radio controls) is missing from the car's app list, and tapping its card on the car's home screen opens the app on the phone instead of the car's media screen. The app checks this setting (with root): while it is off, the Device page shows Android Auto is hiding this app (tap it for the steps and a button that opens Android Auto's settings), and when the car connects the phone gets a notification and the radio history notes it. To fix it, allow Unknown sources once: on the phone open Android Auto's settings, tap the version number at the bottom ten times to unlock the developer settings, then in the ⋮ menu choose Developer settings and turn on Unknown sources. Disconnect and reconnect the car. Android Auto's desktop test head unit does not check this, so the radio appears there either way. Once, with Unknown sources already on, Android Auto connected without loading the radio at all (same symptoms); unplugging the cable and plugging it in again fixed it. The app notices this too: if Android Auto has not loaded the radio 30 seconds after connecting, the radio history and a notification say to reconnect.")),

        new Topic("Pages", "channels", Neo.CYAN, "Widget and notification", "Control the radio without opening the app.",
            s("Notification", "While the radio is on, its notification shows the channel, frequency and what is happening (ready, receiving, transmitting, scanning) with three buttons: previous channel, scan or stop scan, next channel. Tap the notification to open the app."),
            s("Home-screen widget", "Device → Home widget asks the home screen to add it (confirm with Add), or long-press the home screen, choose Widgets, find SignalDeck and drag the Radio widget out. It can be resized. It shows the channel number and name and the same status line, with previous, scan, next and Talk buttons. Tap the channel to open the app."),
            s("Talk from the widget", "A widget cannot feel a held finger, so Talk works tap to start, tap to stop: the button turns red while you transmit. Transmitting stops by itself after 28 seconds, before the radio's own 30-second limit. Receive-only channels refuse it."),
            s("When the radio is off", "The buttons need the app to own the radio. If it does not, they say so; tap the channel to open the app.")),

        new Topic("Good to know", "alert", Neo.RED, "Emergency and roger beep", "Send your position; an end-of-talk tone.",
            s("Emergency", "Intercom menu \u2192 Emergency, or Device \u2192 Emergency. It sends on the channel you are on. On a DMR channel: a text 'EMERGENCY <message> @ latitude,longitude +-accuracy' to the contact or talkgroup you choose in the sheet (it is remembered). On an analog channel: an APRS position with the emergency symbol and 'EMERGENCY <message>' as the comment, or an EMERGENCY status report when the phone has no position fix; this needs your callsign in PKT \u2192 APRS settings."),
            s("Hold to send", "The red key must be held for two seconds, so a stray tap never sends. Lifting early cancels. Afterwards the sheet says what was sent; hold again to repeat it."),
            s("Pick the right channel", "Switch to the channel where someone will hear you first: your repeater or talkgroup for DMR, the local APRS frequency (144.390 MHz in North America) for APRS. Only use it for a real emergency."),
            s("Roger beep", "Device \u2192 Roger beep: Off, Beep, Two-tone or Morse K. The tone is sent when you release the talk key, just before the carrier drops, so listeners know you are done. Tapping the row plays the new tone on the phone speaker.")),

        new Topic("Good to know", "alert", Neo.AMBER, "Transmitting legally", "Licences, power and the 30-second limit.",
            s("Licences", "You are responsible for the frequencies you use: amateur bands need an amateur licence, GMRS needs a licence in the US, FRS limits power, and NOAA weather, marine and railroad channels are receive-only (the app never transmits there). The standard lists in Add a zone say on each one whether a licence is needed."),
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
