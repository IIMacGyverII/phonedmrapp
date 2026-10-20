package com.macdmr.radio.ui;

import android.app.AlertDialog;
import android.content.Context;
import android.content.SharedPreferences;
import android.graphics.drawable.ColorDrawable;
import android.text.InputType;
import android.view.Gravity;
import android.view.View;
import android.widget.EditText;
import android.widget.LinearLayout;
import android.widget.ScrollView;
import android.widget.TextView;
import android.widget.Toast;

import com.macdmr.radio.PacketEngine;
import com.macdmr.radio.RadioService;
import com.macdmr.radio.pkt.PacketStore;
import com.macdmr.radio.pkt.SSTVEncoder;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;
import java.util.Locale;

/** PKT: the packet-radio tools — APRS (monitor, message, beacon, KISS TNC, stations, log, settings), DTMF, weather alerts. */
public final class PktDialog {
    private final Context c; private final RadioService svc; private final PacketEngine pe; private final float d;
    private AlertDialog dlg;

    public static void show(Context c, RadioService svc) { if (svc.packet() != null) new PktDialog(c, svc).open(); }
    private PktDialog(Context c, RadioService svc) { this.c = c; this.svc = svc; this.pe = svc.packet(); d = Theme.dp(c); }

    private void open() {
        LinearLayout body = page("📡  Packet radio");
        // ---- APRS ----
        body.addView(section("APRS"));
        body.addView(status());
        LinearLayout r1 = row();
        button(r1, pe.monitoring() ? "Stop monitoring" : "Monitor 144.390", Theme.PKT, x -> { toast(svc.aprsMonitor(!pe.monitoring())); dlg.dismiss(); });
        button(r1, pe.kiss().isActive() ? "Stop KISS TNC" : "KISS TNC", Theme.PKT, x -> {
            if (pe.kiss().isActive()) { pe.kissStop(); toast("KISS TNC stopped"); }
            else { String e = pe.kissStart(); toast(e == null ? "KISS TNC on 127.0.0.1:" + pe.kissPort() + " — point APRSdroid/YAAC at it (TCP KISS)" : e); }
            svc.aprsMonitor(pe.monitoring()); dlg.dismiss();
        });
        body.addView(r1);
        LinearLayout r2 = row();
        button(r2, "Send message", Theme.VFO, x -> message());
        button(r2, "Position beacon", Theme.VFO, x -> { String e = pe.sendBeacon(); toast(e == null ? "Beacon queued" : e); });
        body.addView(r2);
        LinearLayout r2b = row();
        button(r2b, "Object\u2026", Theme.VFO, x -> objectSheet());
        button(r2b, "Bulletin\u2026", Theme.VFO, x -> bulletinSheet());
        button(r2b, "Telemetry", Theme.VFO, x -> { String e = pe.sendTelemetry(); toast(e == null ? "Telemetry queued" : e); });
        if (pe.hasBarometer()) button(r2b, "Weather", Theme.VFO, x -> { String e = pe.sendWeather(); toast(e == null ? "Weather report queued" : e); });
        body.addView(r2b);
        LinearLayout rIss = row();
        final boolean issMon = pe.monitoring() && svc.aprsMonitorHz() == com.macdmr.radio.RadioService.ISS_APRS_HZ;
        button(rIss, issMon ? "Stop ISS monitor" : "ISS: monitor 145.825", Theme.PKT, x -> { toast(issMon ? svc.aprsMonitor(false) : svc.aprsMonitorAt(true, com.macdmr.radio.RadioService.ISS_APRS_HZ, "ISS APRS 145.825")); dlg.dismiss(); });
        button(rIss, "Beacon via ISS", Theme.VFO, x -> toast(svc.issBeacon()));
        body.addView(rIss);
        String[] autoNames = { "off", "every " + pe.beaconMin() + " min", "SmartBeaconing" };
        body.addView(hint("Automatic beacons: " + autoNames[Math.max(0, Math.min(2, pe.autoBeacon()))] + (pe.telemetryOn() ? ", telemetry every 30 min" : "") + (pe.weatherOn() ? ", weather every 30 min" : "") + " (only on 144.390, set in Settings)." + (pe.txIgate() ? " Two-way iGate on: " + pe.gatedToRfCount() + " internet messages sent to the radio." : "") + (pe.groups().isEmpty() ? "" : " Following groups: " + String.join(", ", pe.groups()) + ".")));
        LinearLayout rIs = row();
        button(rIs, (pe.isEnabled() ? "Stop APRS-IS" : "APRS-IS (internet)") , Theme.PKT, x -> {
            if (pe.isEnabled()) { pe.isStop(); toast("APRS-IS off"); } else { String e = pe.isStart(); toast(e == null ? "Connecting to " + pe.isServer() : e); }
            dlg.dismiss();
        });
        body.addView(rIs);
        body.addView(hint("APRS-IS: " + pe.isStatus() + ". Gates what the radio hears to the internet (with a passcode), beacons your position online and delivers internet messages for you."));
        LinearLayout r3 = row();
        button(r3, "Stations heard (" + pe.store().stationCount() + ")", Theme.SOFTSQ, x -> stations());
        button(r3, "APRS log", Theme.SOFTSQ, x -> aprsLog());
        button(r3, "Bulletins", Theme.SOFTSQ, x -> bulletinsHeard());
        button(r3, "Settings", Theme.MON, x -> settings());
        body.addView(r3);
        body.addView(hint("Passive decode runs on " + (pe.passiveMode() == 2 ? "every analog channel" : pe.passiveMode() == 1 ? "flagged channels" : "no channel (off)") + ". Monitoring parks the radio on 144.390 MHz, acks messages for you" + (pe.digipeat() ? " and digipeats WIDE1-1" : "") + ". Your channel comes back when you stop."));
        // ---- simplex repeater ----
        body.addView(section("Simplex repeater (parrot)"));
        LinearLayout pr = row();
        final boolean parrotOn = svc.parrot().enabled();
        button(pr, parrotOn ? "Stop the parrot" : "Parrot on this channel", Theme.PKT, x -> { toast(svc.setParrot(!parrotOn)); dlg.dismiss(); });
        body.addView(pr);
        body.addView(hint((parrotOn ? "\uD83E\uDD9C On, " + svc.parrot().played() + " repeated so far. " : "") + "Records each transmission heard on this channel and sends it back a second after it ends (up to 26 s), so a station can hear how it sounds, or two stations out of each other's range can talk through you. On amateur channels your callsign is sent in Morse at most every ten minutes. Needs the squelch closed on silence (squelch above 0 or Soft SQ); stops when you change channel."));
        // ---- text modes ----
        body.addView(section("Text modes"));
        LinearLayout xr = row();
        button(xr, "RTTY and PSK31", Theme.SOFTSQ, x -> { dlg.dismiss(); TextModesDialog.show(c, svc); });
        body.addView(xr);
        body.addView(hint("Keyboard chat modes used with fldigi: " + pe.textStatus() + "."));
        // ---- packet terminal ----
        body.addView(section("Packet terminal"));
        LinearLayout tr = row();
        button(tr, "Terminal (BBS, node)", Theme.SOFTSQ, x -> { dlg.dismiss(); TerminalDialog.show(c, svc); });
        body.addView(tr);
        body.addView(hint("Connect to a packet bulletin board or node on this channel: " + pe.terminalState() + "."));
        // ---- logbook ----
        body.addView(section("Logbook"));
        LinearLayout lr = row();
        button(lr, "Logbook (" + svc.logbook().count(true) + " contacts)", Theme.SOFTSQ, x -> { dlg.dismiss(); LogbookDialog.show(c, svc); });
        body.addView(lr);
        body.addView(hint("Your contacts with signal reports, and the stations the radio heard on its own; export as ADIF."));
        // ---- fox hunt ----
        body.addView(section("Fox hunt"));
        LinearLayout fr = row();
        button(fr, "Fox hunt", Theme.SOFTSQ, x -> { dlg.dismiss(); FoxHuntDialog.show(c, svc); });
        body.addView(fr);
        body.addView(hint((svc.foxTxOn() ? "\uD83E\uDD8A The fox beacon is on. " : "") + "Find a hidden transmitter: live signal strength, compass bearings and an estimate of where the fox is. Or be the fox."));
        // ---- voice keyer ----
        body.addView(section("Voice keyer and ID timer"));
        LinearLayout kr = row();
        button(kr, "Voice keyer", Theme.SOFTSQ, x -> { dlg.dismiss(); KeyerDialog.show(c, svc); });
        body.addView(kr);
        long due = svc.idDueInMs();
        body.addView(hint("Record a CQ, a net preamble or your ID once and send it with one tap. " + (due == Long.MAX_VALUE ? "The ID timer starts when you talk on an amateur channel." : due > 0 ? String.format(Locale.US, "Identify within %d:%02d.", due / 60000, due / 1000 % 60) : "Identification is due now.")));
        // ---- Morse ----
        body.addView(section("Morse"));
        LinearLayout mr = row();
        button(mr, "Send my callsign in Morse", Theme.VFO, x -> { String e = pe.sendCwId(); toast(e == null ? "Sending " + pe.callsign() + " in Morse" : e); });
        body.addView(mr);
        body.addView(hint((pe.cwEnabled() ? "Morse heard on analog channels (a repeater's identification, for example) is decoded into the history. " : "The Morse decoder is off (Settings). ") + (pe.cwIdEnabled() ? "Your callsign is sent in Morse after you talk on amateur channels, at most every ten minutes." : "Settings can add your callsign in Morse after you talk on amateur channels, every ten minutes.")));
        // ---- SSTV ----
        body.addView(section("SSTV pictures"));
        body.addView(hint("\uD83D\uDD38 " + pe.sstvStatus()));
        LinearLayout s1 = row();
        if (pe.sstvRx()) button(s1, "Stop receiving", Theme.PKT, x -> { toast(svc.sstvMonitor(false, false)); dlg.dismiss(); });
        else { button(s1, "Receive on 144.500", Theme.PKT, x -> { toast(svc.sstvMonitor(true, true)); dlg.dismiss(); }); button(s1, "Receive here", Theme.PKT, x -> { toast(svc.sstvMonitor(true, false)); dlg.dismiss(); }); }
        body.addView(s1);
        LinearLayout s2 = row();
        button(s2, "Live picture", Theme.SOFTSQ, x -> sstvView());
        button(s2, "Send picture", Theme.VFO, x -> sstvSend());
        body.addView(s2);
        body.addView(hint("Receives Robot, Martin, Scottie and PD modes (VIS auto-detect); pictures are saved to Download/DMR/SSTV. Sending uses Robot 24 Color, Robot 12 BW or Robot 8 BW, the modes that fit this radio's 30 s transmit limit."));
        // ---- DTMF ----
        body.addView(section("DTMF"));
        LinearLayout r4 = row();
        button(r4, "Send DTMF", Theme.VFO, x -> dtmfSend());
        button(r4, "Heard", Theme.SOFTSQ, x -> dtmfLog());
        button(r4, "Remote\u2026", Theme.MON, x -> remoteSheet());
        body.addView(r4);
        body.addView(hint("Touch-tone keys heard on any analog channel are decoded and logged" + (pe.dtmfEnabled() ? "." : " (decoder off in Settings).")));
        // ---- Weather ----
        body.addView(section("NOAA weather alerts"));
        LinearLayout r5 = row();
        button(r5, "Alerts heard", Theme.REC, x -> wxLog());
        body.addView(r5);
        body.addView(hint("SAME alert headers on the 162.400–162.550 MHz weather channels are decoded automatically and raise a notification" + (pe.wxEnabled() ? "." : " (off in Settings).")));
        dlg = dialog(body);
    }

    private TextView status() {
        String call = pe.callsignSet() ? pe.myCall() : "no callsign set";
        String st = (pe.monitoring() ? "monitoring 144.390" : "passive") + (pe.kiss().isActive() ? " · KISS " + (pe.kiss().clientConnected() ? "client connected" : "waiting for a client") + " · " + pe.kiss().rxFrames() + " rx / " + pe.kiss().txFrames() + " tx" : "");
        return hint("🔸 " + call + "  ·  " + st);
    }

    // ---- APRS message ----
    private void message() {
        LinearLayout body = page("✉️  APRS message");
        final EditText to = field(body, "To (callsign-SSID)", "", InputType.TYPE_CLASS_TEXT | InputType.TYPE_TEXT_FLAG_CAP_CHARACTERS);
        final EditText text = field(body, "Message (up to 67 characters)", "", InputType.TYPE_CLASS_TEXT);
        body.addView(hint("Sent from " + (pe.callsignSet() ? pe.myCall() : "(set your callsign in Settings)") + " via " + String.join(",", pe.path()) + " with a message number, so the other station acks it."));
        LinearLayout r = row();
        button(r, "Send", Theme.PKT, x -> { String e = pe.sendMessage(to.getText().toString(), text.getText().toString()); toast(e == null ? "Message queued" : e); if (e == null) sub.dismiss(); });
        button(r, "Cancel", Theme.MON, x -> sub.dismiss());
        body.addView(r);
        body.addView(section("Gateways"));
        LinearLayout g = row();
        button(g, "Text a phone", Theme.VFO, x -> { sub.dismiss(); gateway(true); });
        button(g, "Send an email", Theme.VFO, x -> { sub.dismiss(); gateway(false); });
        body.addView(g);
        body.addView(hint("Internet gateways reached through APRS: a text message to a phone (SMSGTE, US and Canada numbers) or an email (EMAIL-2), useful where there is no phone signal but an APRS iGate hears you."));
        sub = dialog(body);
    }
    private AlertDialog sub;

    /** SMSGTE ("@number text") or EMAIL-2 ("address text"), sent as an APRS message to the gateway. */
    private void gateway(final boolean sms) {
        LinearLayout body = page(sms ? "\uD83D\uDCF1  Text a phone (SMSGTE)" : "\u2709\uFE0F  Send an email (EMAIL-2)");
        final EditText to = field(body, sms ? "Phone number (10 digits)" : "Email address", "", sms ? InputType.TYPE_CLASS_PHONE : InputType.TYPE_CLASS_TEXT | InputType.TYPE_TEXT_VARIATION_EMAIL_ADDRESS);
        final EditText text = field(body, "Message", "", InputType.TYPE_CLASS_TEXT | InputType.TYPE_TEXT_FLAG_CAP_SENTENCES);
        final TextView left = hint(""); body.addView(left);
        Runnable count = () -> { int n = 67 - gatewayText(sms, to.getText().toString(), text.getText().toString()).length(); left.setText(n >= 0 ? n + " characters left (APRS messages hold 67)" : "Too long by " + (-n) + " characters"); };
        android.text.TextWatcher w = new android.text.TextWatcher() {
            @Override public void beforeTextChanged(CharSequence s, int a, int b, int n) { } @Override public void onTextChanged(CharSequence s, int a, int b, int n) { }
            @Override public void afterTextChanged(android.text.Editable e) { count.run(); }
        };
        to.addTextChangedListener(w); text.addTextChangedListener(w); count.run();
        body.addView(hint(sms ? "Sent as an APRS message to SMSGTE, which texts the phone. A reply from the phone comes back to your callsign as an APRS message when the SMSGTE service knows you (see smsgte.org). Standard message rates apply to the recipient." : "Sent as an APRS message to EMAIL-2, which emails the text from your callsign. Most email gateways answer with an acknowledgement; replies by email are not relayed back."));
        LinearLayout r = row();
        button(r, "Send", Theme.PKT, x -> {
            String addr = to.getText().toString().trim();
            if (sms && addr.replaceAll("[^0-9]", "").length() < 10) { toast("Ten-digit phone number"); return; }
            if (!sms && !addr.contains("@")) { toast("Email address"); return; }
            String e = pe.sendMessage(sms ? "SMSGTE" : "EMAIL-2", gatewayText(sms, addr, text.getText().toString()));
            toast(e == null ? "Message queued for the gateway" : e); if (e == null) sub.dismiss();
        });
        button(r, "Cancel", Theme.MON, x -> sub.dismiss());
        body.addView(r);
        sub = dialog(body);
    }
    static String gatewayText(boolean sms, String to, String text) {
        String a = sms ? "@" + to.replaceAll("[^0-9]", "") : to.trim();
        return (a + " " + text.trim()).trim();
    }

    // ---- DTMF remote control ----
    private void remoteSheet() {
        final SharedPreferences p = pe.prefs();
        LinearLayout body = page("\uD83D\uDCDF  DTMF remote control");
        final boolean[] on = { pe.remoteOn() };
        toggle(body, "Answer DTMF commands on this phone", on, 0);
        final EditText pin = field(body, "PIN (4 to 6 digits, keep it to yourself)", pe.remotePin(), InputType.TYPE_CLASS_NUMBER | InputType.TYPE_NUMBER_VARIATION_PASSWORD);
        StringBuilder sb = new StringBuilder("From another radio, key the PIN and then one command digit, as one sequence (a * before and # after are fine). The phone answers on the channel 1.5 seconds later:\n");
        for (int i = 1; i < com.macdmr.radio.ham.DtmfRemote.COMMANDS.length; i++) sb.append("\n").append(i).append("   ").append(com.macdmr.radio.ham.DtmfRemote.COMMANDS[i]);
        sb.append("\n\nThree wrong PINs within ten minutes lock the remote for ten minutes. The PIN never appears in the history. Voice replies end with your callsign in Morse on amateur channels.");
        body.addView(hint(sb.toString()));
        LinearLayout r = row();
        button(r, "Save", Theme.PKT, x -> {
            String v = pin.getText().toString().trim();
            if (on[0] && !v.matches("[0-9]{4,6}")) { toast("The PIN is 4 to 6 digits"); return; }
            p.edit().putBoolean("remote", on[0]).putString("remotePin", v).apply();
            toast(on[0] ? "DTMF remote on" : "DTMF remote off"); sub.dismiss();
        });
        button(r, "Cancel", Theme.MON, x -> sub.dismiss());
        body.addView(r);
        sub = dialog(body);
    }

    // ---- object, bulletin ----
    private void objectSheet() {
        LinearLayout body = page("\uD83D\uDCCC  APRS object");
        final EditText name = field(body, "Name (up to 9 characters, e.g. NETCTL or HAZARD)", "", InputType.TYPE_CLASS_TEXT | InputType.TYPE_TEXT_FLAG_CAP_CHARACTERS);
        android.location.Location me = svc.lastKnownLocation();
        final EditText pos = field(body, "Position (latitude, longitude)", me == null ? "" : String.format(Locale.US, "%.5f, %.5f", me.getLatitude(), me.getLongitude()), InputType.TYPE_CLASS_TEXT);
        final EditText sym = field(body, "Symbol (table + code: /N net control, /! police, \\! emergency, /E event, /. X)", "/.", InputType.TYPE_CLASS_TEXT);
        final EditText comment = field(body, "Comment", "", InputType.TYPE_CLASS_TEXT);
        body.addView(hint("An object is a marker on everyone's APRS map that you own: a net control point, an event, a hazard. Remove sends it again as deleted. The position starts at yours; edit it to place the object elsewhere."));
        LinearLayout r = row();
        button(r, "Place", Theme.PKT, x -> objectSend(name, pos, sym, comment, true));
        button(r, "Remove", Theme.REC, x -> objectSend(name, pos, sym, comment, false));
        button(r, "Cancel", Theme.MON, x -> sub.dismiss());
        body.addView(r);
        sub = dialog(body);
    }
    private void objectSend(EditText name, EditText pos, EditText sym, EditText comment, boolean live) {
        try {
            String[] p = pos.getText().toString().split(",");
            double lat = Double.parseDouble(p[0].trim()), lon = Double.parseDouble(p[1].trim());
            if (Math.abs(lat) > 90 || Math.abs(lon) > 180) throw new NumberFormatException();
            String e = pe.sendObject(name.getText().toString(), live, lat, lon, sym.getText().toString().trim(), comment.getText().toString());
            toast(e == null ? (live ? "Object queued" : "Removal queued") : e); if (e == null) sub.dismiss();
        } catch (Throwable t) { toast("Position: latitude, longitude in degrees (e.g. 45.123, -93.456)"); }
    }
    private void bulletinSheet() {
        LinearLayout body = page("\uD83D\uDCE2  APRS bulletin");
        final EditText num = field(body, "Bulletin number (0 to 9)", "0", InputType.TYPE_CLASS_NUMBER);
        final EditText text = field(body, "Text (up to 67 characters)", "", InputType.TYPE_CLASS_TEXT);
        body.addView(hint("A bulletin goes to everyone in range (BLN0 to BLN9) and is not acknowledged; most APRS apps list them on a bulletin board. Send it again to keep it current."));
        LinearLayout r = row();
        button(r, "Send", Theme.PKT, x -> { int n; try { n = Integer.parseInt(num.getText().toString().trim()); } catch (Throwable t) { n = 0; } String e = pe.sendBulletin(n, text.getText().toString()); toast(e == null ? "Bulletin queued" : e); if (e == null) sub.dismiss(); });
        button(r, "Cancel", Theme.MON, x -> sub.dismiss());
        body.addView(r);
        sub = dialog(body);
    }
    private void bulletinsHeard() {
        LinearLayout body = page("\uD83D\uDCE2  Bulletins heard");
        List<PacketStore.LogEntry> list = pe.bulletins(100);
        if (list.isEmpty()) body.addView(hint("No bulletins or NWS announcements heard yet."));
        SimpleDateFormat f = new SimpleDateFormat("MM-dd HH:mm", Locale.US);
        for (PacketStore.LogEntry e : list) {
            LinearLayout rowv = shell();
            rowv.addView(Neo.label(c, e.to + "  from " + e.from, Theme.AMBER, 14, true));
            rowv.addView(Neo.label(c, f.format(new Date(e.ts)) + "  " + e.text, 0xFFBFC8D0, 13, false));
            body.addView(rowv);
        }
        sub = dialog(body);
    }

    // ---- DTMF send ----
    private void dtmfSend() {
        LinearLayout body = page("📟  Send DTMF");
        final EditText seq = field(body, "Keys (0-9, A-D, *, #)", "", InputType.TYPE_CLASS_TEXT | InputType.TYPE_TEXT_FLAG_CAP_CHARACTERS);
        LinearLayout pad = new LinearLayout(c); pad.setOrientation(LinearLayout.VERTICAL);
        String[] rows = { "123A", "456B", "789C", "*0#D" };
        for (String rr : rows) {
            LinearLayout line = row();
            for (char k : rr.toCharArray()) { final String ks = String.valueOf(k); TextView b = button(line, ks, Theme.SOFTSQ, x -> seq.append(ks)); b.setTextSize(18); }
            pad.addView(line);
        }
        body.addView(pad);
        LinearLayout r = row();
        button(r, "Transmit", Theme.PKT, x -> { String e = pe.sendDtmf(seq.getText().toString()); toast(e == null ? "DTMF queued" : e); if (e == null) sub.dismiss(); });
        button(r, "Clear", Theme.MON, x -> seq.setText(""));
        button(r, "Saved\u2026", Theme.SOFTSQ, x -> {
            final java.util.LinkedHashMap<String, String> m = pe.dtmfSaved();
            final java.util.List<String> names = new java.util.ArrayList<>(m.keySet());
            String[] items = new String[names.size() + 1]; for (int i = 0; i < names.size(); i++) items[i] = names.get(i) + "  \u2192  " + m.get(names.get(i)); items[names.size()] = "\uD83D\uDCBE Save the current keys as\u2026";
            new AlertDialog.Builder(c).setTitle("Saved DTMF sequences").setItems(items, (dd, w) -> {
                if (w < names.size()) { seq.setText(m.get(names.get(w))); return; }
                final EditText nm = new EditText(c); nm.setHint("Name (e.g. Repeater on)");
                new AlertDialog.Builder(c).setTitle("Save " + seq.getText()).setView(nm).setPositiveButton("Save", (d3, w3) -> { String n = nm.getText().toString().trim(); if (!n.isEmpty() && seq.getText().length() > 0) { pe.dtmfSave(n, seq.getText().toString().toUpperCase(Locale.US)); toast("Saved"); } }).setNegativeButton("Cancel", null).show();
            }).setNegativeButton("Delete one\u2026", (dd, w) -> { if (names.isEmpty()) return; new AlertDialog.Builder(c).setTitle("Delete which?").setItems(names.toArray(new String[0]), (d4, w4) -> { pe.dtmfSave(names.get(w4), null); toast("Deleted"); }).show(); }).show();
        });
        body.addView(r);
        sub = dialog(body);
    }

    // ---- SSTV ----
    private void sstvView() {
        LinearLayout body = page("\uD83D\uDCFA  SSTV");
        final TextView st = hint("\uD83D\uDD38 " + pe.sstvStatus()); body.addView(st);
        final android.widget.ImageView iv = new android.widget.ImageView(c); iv.setAdjustViewBounds(true); iv.setScaleType(android.widget.ImageView.ScaleType.FIT_CENTER);
        iv.setBackground(Theme.rounded(c, 0xFF000000, 0x8000BFFF, 1, 6)); iv.setMinimumHeight(dp(220));
        if (pe.sstvLast() != null) iv.setImageBitmap(pe.sstvLast());
        body.addView(iv, new LinearLayout.LayoutParams(LinearLayout.LayoutParams.MATCH_PARENT, LinearLayout.LayoutParams.WRAP_CONTENT));
        body.addView(hint("The picture builds up line by line while a transmission is decoded. Finished pictures are in Download/DMR/SSTV."));
        pe.setSstvListener((status, live, lines, total, done) -> { st.setText("\uD83D\uDD38 " + status); if (live != null) iv.setImageBitmap(live); });
        sub = dialog(body);
        sub.setOnDismissListener(d -> pe.setSstvListener(null));
    }

    private void sstvSend() {
        if (!(c instanceof com.macdmr.radio.MainActivity)) { toast("Open from the main screen"); return; }
        final String[] names = { "Robot 24 Color (\u224824 s)", "Robot 12 BW (\u224812 s)", "Robot 8 BW (\u22488 s)" };
        final int[] modes = { SSTVEncoder.ROBOT_24_COLOR, SSTVEncoder.ROBOT_12_BW, SSTVEncoder.ROBOT_8_BW };
        new AlertDialog.Builder(c).setTitle("SSTV mode").setItems(names, (dd, w) -> ((com.macdmr.radio.MainActivity) c).pickImage(uri -> {
            try (java.io.InputStream in = c.getContentResolver().openInputStream(uri)) {
                android.graphics.Bitmap bmp = android.graphics.BitmapFactory.decodeStream(in);
                String e = pe.sendSstv(bmp, modes[w]); toast(e == null ? "Sending " + names[w] : e);
            } catch (Throwable t) { toast("Could not read that picture"); }
        })).show();
    }

    // ---- lists ----
    private void stations() {
        LinearLayout body = page("📍  Stations heard");
        List<PacketStore.Station> list = pe.store().stations(200);
        android.location.Location me = svc.lastKnownLocation();
        if (list.isEmpty()) body.addView(hint("Nothing decoded yet. Positions, Mic-E, objects and NMEA reports land here with distance and bearing from you."));
        SimpleDateFormat f = new SimpleDateFormat("MM-dd HH:mm", Locale.US);
        for (PacketStore.Station s : list) {
            String dist = "";
            if (me != null) { float[] r = new float[2]; android.location.Location.distanceBetween(me.getLatitude(), me.getLongitude(), s.lat, s.lon, r); dist = String.format(Locale.US, "  %.1f mi %s", r[0] / 1609.344, compass(r[1])); }
            String extra = (s.speedKmh >= 0 ? String.format(Locale.US, " · %.0f mph", s.speedKmh * 0.621371) : "") + (s.alt != 0 ? " · " + Math.round(s.alt * 3.28084) + " ft" : "");
            LinearLayout rowv = shell();
            rowv.addView(Neo.label(c, s.call + dist, Theme.CYAN, 15, true));
            rowv.addView(Neo.label(c, f.format(new Date(s.lastTs)) + " · " + String.format(Locale.US, "%.4f, %.4f", s.lat, s.lon) + extra + (s.count > 1 ? " · " + s.count + "×" : "") + (s.via.isEmpty() ? "" : " · via " + s.via), 0xFFBFC8D0, 12, false));
            if (!s.comment.isEmpty()) rowv.addView(Neo.label(c, s.comment, 0xFF8A98A6, 12, false));
            final PacketStore.Station fs = s;
            rowv.setClickable(true); rowv.setOnClickListener(x -> {
                try { c.startActivity(new android.content.Intent(android.content.Intent.ACTION_VIEW, android.net.Uri.parse(String.format(Locale.US, "geo:%f,%f?q=%f,%f(%s)", fs.lat, fs.lon, fs.lat, fs.lon, android.net.Uri.encode(fs.call))))); } catch (Throwable t) { toast("No map app"); }
            });
            body.addView(rowv);
        }
        if (!list.isEmpty()) {
            LinearLayout r = row();
            button(r, "Export GPX", Theme.SOFTSQ, x -> {
                try {
                    StringBuilder g = new StringBuilder("<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n<gpx version=\"1.1\" creator=\"DMR Radio\" xmlns=\"http://www.topografix.com/GPX/1/1\">\n");
                    SimpleDateFormat iso = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss'Z'", Locale.US); iso.setTimeZone(java.util.TimeZone.getTimeZone("UTC"));
                    for (PacketStore.Station s : list) g.append(String.format(Locale.US, "  <wpt lat=\"%.6f\" lon=\"%.6f\">%s<time>%s</time><name>%s</name><desc>%s</desc></wpt>\n", s.lat, s.lon, s.alt != 0 ? "<ele>" + s.alt + "</ele>" : "", iso.format(new Date(s.lastTs)), xml(s.call), xml(s.comment)));
                    g.append("</gpx>\n");
                    java.io.File dir = new java.io.File(android.os.Environment.getExternalStoragePublicDirectory(android.os.Environment.DIRECTORY_DOWNLOADS), "DMR/APRS"); dir.mkdirs();
                    java.io.File out = new java.io.File(dir, "aprs_stations_" + new SimpleDateFormat("yyyyMMdd_HHmmss", Locale.US).format(new Date()) + ".gpx");
                    try (java.io.Writer w = new java.io.OutputStreamWriter(new java.io.FileOutputStream(out), java.nio.charset.StandardCharsets.UTF_8)) { w.write(g.toString()); }
                    toast("Saved Download/DMR/APRS/" + out.getName());
                    c.startActivity(android.content.Intent.createChooser(new android.content.Intent(android.content.Intent.ACTION_SEND).setType("application/gpx+xml").putExtra(android.content.Intent.EXTRA_SUBJECT, out.getName()).putExtra(android.content.Intent.EXTRA_TEXT, g.toString()), "Share GPX"));
                } catch (Throwable t) { toast("Export failed: " + t.getMessage()); }
            });
            button(r, "Clear list", Theme.REC, x -> { pe.store().clearStations(); sub.dismiss(); });
            body.addView(r);
        }
        sub = dialog(body);
    }

    private static String xml(String s) { return s == null ? "" : s.replace("&", "&amp;").replace("<", "&lt;").replace(">", "&gt;").replace("\"", "&quot;"); }
    private static String compass(float bearing) { float b = (bearing + 360) % 360; String[] dirs = { "N", "NE", "E", "SE", "S", "SW", "W", "NW" }; return dirs[(int) Math.round(b / 45.0) % 8]; }

    private void aprsLog() {
        LinearLayout body = page("📜  APRS log");
        List<PacketStore.LogEntry> list = pe.store().aprsLog(150);
        if (list.isEmpty()) body.addView(hint("Messages, acks, beacons, digipeats and status reports appear here, newest first."));
        SimpleDateFormat f = new SimpleDateFormat("MM-dd HH:mm:ss", Locale.US);
        for (PacketStore.LogEntry e : list) {
            String icon = e.kind.startsWith("msg") ? (e.kind.equals("msg-tx") ? "⬆️" : (e.mine ? "✉️" : "💬")) : e.kind.startsWith("ack") ? "✅" : e.kind.equals("beacon") ? "📍" : e.kind.equals("digi") ? "🔁" : e.kind.equals("pos") ? "📍" : "ℹ️";
            LinearLayout rowv = shell();
            rowv.addView(Neo.label(c, icon + " " + e.from + (e.to == null || e.to.isEmpty() ? "" : " → " + e.to) + (e.mine ? "  (for you)" : ""), e.mine ? Theme.AMBER : Theme.CYAN, 14, true));
            rowv.addView(Neo.label(c, f.format(new Date(e.ts)) + "  " + e.text + (e.id != null ? " {" + e.id : ""), 0xFFBFC8D0, 12, false));
            body.addView(rowv);
        }
        sub = dialog(body);
    }

    private void dtmfLog() {
        LinearLayout body = page("📟  DTMF heard");
        List<PacketStore.Dtmf> list = pe.store().dtmfLog(100);
        if (list.isEmpty()) body.addView(hint("No DTMF sequences decoded yet."));
        SimpleDateFormat f = new SimpleDateFormat("MM-dd HH:mm:ss", Locale.US);
        for (PacketStore.Dtmf e : list) {
            LinearLayout rowv = shell();
            rowv.addView(Neo.label(c, e.digits, Theme.CYAN, 18, true));
            rowv.addView(Neo.label(c, f.format(new Date(e.ts)) + "  ch " + e.channel + " " + e.channelName, 0xFFBFC8D0, 12, false));
            body.addView(rowv);
        }
        sub = dialog(body);
    }

    private void wxLog() {
        LinearLayout body = page("⛈️  Weather alerts heard");
        List<PacketStore.Alert> list = pe.store().alerts(100);
        if (list.isEmpty()) body.addView(hint("No SAME alert headers decoded yet. Park on a NOAA weather channel; the weekly test (RWT) is the usual first one you will see."));
        SimpleDateFormat f = new SimpleDateFormat("MM-dd HH:mm", Locale.US);
        for (PacketStore.Alert a : list) {
            LinearLayout rowv = shell();
            rowv.addView(Neo.label(c, (a.eom ? "End of message" : a.summary), a.eom ? 0xFF8A98A6 : Theme.AMBER, 14, true));
            rowv.addView(Neo.label(c, f.format(new Date(a.ts)) + "  " + a.raw, 0xFFBFC8D0, 11, false));
            body.addView(rowv);
        }
        sub = dialog(body);
    }

    // ---- settings ----
    private void settings() {
        final SharedPreferences p = pe.prefs();
        LinearLayout body = page("⚙️  APRS & packet settings");
        final EditText call = field(body, "Your callsign", p.getString("callsign", ""), InputType.TYPE_CLASS_TEXT | InputType.TYPE_TEXT_FLAG_CAP_CHARACTERS);
        final EditText ssid = field(body, "SSID (0–15; 7 = handheld, 9 = mobile)", String.valueOf(pe.ssid()), InputType.TYPE_CLASS_NUMBER);
        final EditText sym = field(body, "Symbol (table + code, e.g. /[ person, /> car, /- house)", p.getString("symTable", "/") + p.getString("symCode", "["), InputType.TYPE_CLASS_TEXT);
        final EditText comment = field(body, "Beacon comment", pe.comment(), InputType.TYPE_CLASS_TEXT);
        final EditText path = field(body, "Digipeater path", p.getString("path", "WIDE1-1,WIDE2-1"), InputType.TYPE_CLASS_TEXT | InputType.TYPE_TEXT_FLAG_CAP_CHARACTERS);
        final EditText port = field(body, "KISS TNC port", String.valueOf(pe.kissPort()), InputType.TYPE_CLASS_NUMBER);
        body.addView(section("APRS-IS (internet)"));
        final EditText isServer = field(body, "Server", pe.isServer(), InputType.TYPE_CLASS_TEXT | InputType.TYPE_TEXT_VARIATION_URI);
        final EditText isPort = field(body, "Port", String.valueOf(pe.isPort()), InputType.TYPE_CLASS_NUMBER);
        final EditText isPass = field(body, "Passcode (-1 = receive-only; never shown or logged)", p.getString("isPasscode", "-1"), InputType.TYPE_CLASS_TEXT | InputType.TYPE_TEXT_VARIATION_PASSWORD);
        final EditText isMin = field(body, "Internet beacon every N minutes (0 = off)", String.valueOf(pe.isBeaconMin()), InputType.TYPE_CLASS_NUMBER);
        final EditText isComment = field(body, "Internet beacon comment", p.getString("isComment", pe.comment()), InputType.TYPE_CLASS_TEXT);
        body.addView(section("Automatic beacons (on 144.390 only)"));
        final String[] autoModes = { "Off", "Every N minutes", "SmartBeaconing" };
        final int[] auto = { Math.max(0, Math.min(2, pe.autoBeacon())) };
        cycle(body, "Beacon", autoModes, auto[0], v -> auto[0] = v);
        final EditText bMin = field(body, "Every N minutes (Every N minutes mode)", String.valueOf(pe.beaconMin()), InputType.TYPE_CLASS_NUMBER);
        final boolean[] extra = { pe.telemetryOn(), pe.weatherOn(), pe.txIgate() };
        toggle(body, "Telemetry every 30 min (battery, volts, temperature, pressure, signal)", extra, 0);
        if (pe.hasBarometer()) toggle(body, "Weather report every 30 min (air pressure)", extra, 1);
        toggle(body, "Two-way iGate: internet messages to stations heard here go out on the radio", extra, 2);
        final EditText groups = field(body, "Message groups I follow (comma separated, e.g. CQ,ARES)", String.join(",", pe.groups()), InputType.TYPE_CLASS_TEXT | InputType.TYPE_TEXT_FLAG_CAP_CHARACTERS);
        body.addView(section("Passive APRS decode"));
        final String[] modes = { "Off", "Flagged channels", "Every analog channel" };
        final int[] passive = { pe.passiveMode() };
        final TextView modeV = cycle(body, "Decode on", modes, passive[0], v -> passive[0] = v);
        final boolean[] flags = { pe.autoAck(), pe.digipeat(), pe.dtmfEnabled(), pe.wxEnabled(), pe.cwEnabled(), pe.cwIdEnabled() };
        toggle(body, "Auto-ack messages addressed to me (monitoring)", flags, 0);
        toggle(body, "Fill-in digipeater for WIDE1-1 (monitoring)", flags, 1);
        toggle(body, "DTMF decoder", flags, 2);
        toggle(body, "NOAA SAME weather alerts", flags, 3);
        toggle(body, "Morse decoder", flags, 4);
        toggle(body, "Morse ID after I talk (amateur channels, every 10 min)", flags, 5);
        LinearLayout r = row();
        button(r, "Save", Theme.PKT, x -> {
            try {
                String s = sym.getText().toString().trim();
                String cs = call.getText().toString().trim().toUpperCase(Locale.US), ss = ssid.getText().toString().trim();
                int dash = cs.indexOf('-');
                if (dash > 0) { ss = cs.substring(dash + 1).trim(); cs = cs.substring(0, dash).trim(); call.setText(cs); ssid.setText(ss); }   // "CALL-7" typed in one box
                if (!cs.isEmpty() && !cs.matches("[A-Z0-9]{1,6}")) { toast("Callsign: 1 to 6 letters and digits; the SSID goes in its own box"); return; }
                int ssidV = Integer.parseInt(ss);
                if (ssidV < 0 || ssidV > 15) { toast("SSID is 0 to 15"); return; }
                p.edit().putString("callsign", cs)
                        .putInt("ssid", ssidV)
                        .putString("symTable", s.length() >= 1 ? s.substring(0, 1) : "/").putString("symCode", s.length() >= 2 ? s.substring(1, 2) : "[")
                        .putString("comment", comment.getText().toString().trim()).putString("path", path.getText().toString().trim().toUpperCase(Locale.US))
                        .putInt("kissPort", Integer.parseInt(port.getText().toString().trim())).putInt("passive", passive[0])
                        .putString("isServer", isServer.getText().toString().trim()).putInt("isPort", Integer.parseInt(isPort.getText().toString().trim()))
                        .putString("isPasscode", isPass.getText().toString().trim().isEmpty() ? "-1" : isPass.getText().toString().trim())
                        .putInt("isBeaconMin", Integer.parseInt(isMin.getText().toString().trim())).putString("isComment", isComment.getText().toString().trim())
                        .putInt("autoBeacon", auto[0]).putInt("beaconMin", Math.max(1, Integer.parseInt(bMin.getText().toString().trim())))
                        .putBoolean("telemetry", extra[0]).putBoolean("weather", extra[1]).putBoolean("txIgate", extra[2]).putString("groups", groups.getText().toString().trim().toUpperCase(Locale.US))
                        .putBoolean("autoAck", flags[0]).putBoolean("digipeat", flags[1]).putBoolean("dtmf", flags[2]).putBoolean("wx", flags[3]).putBoolean("cw", flags[4]).putBoolean("cwId", flags[5]).apply();
                pe.applySettings();
                toast("Saved"); sub.dismiss();
            } catch (NumberFormatException e) { toast("Check the numbers"); }
        });
        button(r, "Cancel", Theme.MON, x -> sub.dismiss());
        body.addView(r);
        sub = dialog(body);
    }

    private void toggle(LinearLayout body, String label, final boolean[] flags, final int i) {
        LinearLayout rowv = shell(); rowv.setOrientation(LinearLayout.HORIZONTAL); rowv.setGravity(Gravity.CENTER_VERTICAL);
        rowv.addView(Neo.label(c, label, 0xFFBFC8D0, 14, false), new LinearLayout.LayoutParams(0, LinearLayout.LayoutParams.WRAP_CONTENT, 1f));
        final TextView v = Neo.label(c, flags[i] ? "ON" : "OFF", flags[i] ? Theme.PKT[3] : 0xFF8A98A6, 13, true);
        v.setBackground(Theme.rounded(c, flags[i] ? Theme.PKT[0] : 0x18000000, flags[i] ? Theme.PKT[2] : 0x3300BFFF, 1, 14)); v.setPadding(dp(12), dp(6), dp(12), dp(6));
        rowv.addView(v);
        View.OnClickListener cl = x -> { flags[i] = !flags[i]; v.setText(flags[i] ? "ON" : "OFF"); v.setTextColor(flags[i] ? Theme.PKT[3] : 0xFF8A98A6); v.setBackground(Theme.rounded(c, flags[i] ? Theme.PKT[0] : 0x18000000, flags[i] ? Theme.PKT[2] : 0x3300BFFF, 1, 14)); };
        rowv.setClickable(true); rowv.setOnClickListener(cl); v.setOnClickListener(cl);
        body.addView(rowv);
    }

    // ---- widgets ----
    private interface IntSetter { void set(int v); }
    private int dp(float x) { return Math.round(x * d); }
    private void toast(String s) { Toast.makeText(c, s, Toast.LENGTH_LONG).show(); }

    private LinearLayout page(String title) { return Neo.sheetBody(c, title); }
    private AlertDialog dialog(LinearLayout body) { return Neo.showSheet(c, body); }
    private TextView hint(String s) { return Neo.sheetHint(c, s); }
    private TextView section(String s) { return Neo.sheetSection(c, s); }
    private LinearLayout row() {
        LinearLayout r = new LinearLayout(c); r.setOrientation(LinearLayout.HORIZONTAL); r.setGravity(Gravity.CENTER_VERTICAL);
        LinearLayout.LayoutParams lp = new LinearLayout.LayoutParams(LinearLayout.LayoutParams.MATCH_PARENT, LinearLayout.LayoutParams.WRAP_CONTENT); lp.topMargin = dp(2); lp.bottomMargin = dp(4); r.setLayoutParams(lp);
        return r;
    }
    private TextView button(LinearLayout row, String text, int[] accent, View.OnClickListener l) { TextView b = Neo.button(c, text, null, Neo.accentOf(accent)); b.setTextSize(14); b.setOnClickListener(l); LinearLayout.LayoutParams lp = new LinearLayout.LayoutParams(0, LinearLayout.LayoutParams.MATCH_PARENT, 1f); lp.setMargins(dp(3), dp(4), dp(3), dp(2)); row.setBaselineAligned(false); row.addView(b, lp); return b; }
    private LinearLayout shell() {
        LinearLayout r = new LinearLayout(c); r.setOrientation(LinearLayout.VERTICAL);
        r.setBackground(Neo.rowCard(c)); r.setPadding(dp(12), dp(8), dp(12), dp(8));
        LinearLayout.LayoutParams lp = new LinearLayout.LayoutParams(LinearLayout.LayoutParams.MATCH_PARENT, LinearLayout.LayoutParams.WRAP_CONTENT); lp.bottomMargin = dp(6); r.setLayoutParams(lp);
        return r;
    }
    private EditText field(LinearLayout target, String label, String value, int inputType) {
        LinearLayout r = shell(); r.addView(Neo.label(c, label, 0xFF9AA4AE, 12, false));
        EditText e = new EditText(c); e.setText(value); e.setInputType(inputType); e.setTextSize(17); e.setTextColor(Theme.WHITE); e.setSingleLine(true); e.setBackground(null); e.setPadding(0, dp(4), 0, dp(4));
        r.addView(e); target.addView(r);
        return e;
    }
    private TextView cycle(LinearLayout target, String label, final String[] options, int index, final IntSetter setter) {
        LinearLayout r = shell(); r.setOrientation(LinearLayout.HORIZONTAL); r.setGravity(Gravity.CENTER_VERTICAL);
        r.addView(Neo.label(c, label, 0xFFBFC8D0, 14, false), new LinearLayout.LayoutParams(0, LinearLayout.LayoutParams.WRAP_CONTENT, 1f));
        final TextView v = Neo.label(c, options[index], Theme.CYAN, 14, true); v.setBackground(Neo.outline(c, Neo.CYAN, 0x16, 12, 1)); v.setPadding(dp(12), dp(6), dp(12), dp(6));
        r.addView(v);
        final int[] cur = { index };
        View.OnClickListener cl = x -> { cur[0] = (cur[0] + 1) % options.length; v.setText(options[cur[0]]); setter.set(cur[0]); };
        r.setClickable(true); r.setOnClickListener(cl); v.setOnClickListener(cl);
        target.addView(r);
        return v;
    }
}
