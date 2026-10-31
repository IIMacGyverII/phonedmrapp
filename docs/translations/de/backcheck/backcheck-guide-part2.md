# Back-check: German guide, part 2

Topics: pager, m17, ft8-over-fm, winlink-e-mail, net-control, band-scope, scheduled-operations, fox-hunt, channels,
contacts. 10 titles, 10 summaries, 69 sections (heads and texts), about 8,140 English words.

Method: each German section was translated back into English from the German alone, then compared with the English
source for meaning, negations, numbers, units and conditions. A script also checked that every `{@name}` reference and
every number in each section matches the English (all 69 match; decimal points became decimal commas).

## Changes made after the back-check

| Topic / section | Problem found in the back-translation | Fix in the German |
|---|---|---|
| m17 / how-it-works-on-this-radio | "fixed equalizer … applied before the sync search": English says *checked* before the sync search. Meaning changed. | „angewendet“ → „geprüft“. |
| fox-hunt / terrain | "a small bank or a wall carries no weight": English says it *does not show* (is not in the model). Meaning shifted. | „fallen … nicht ins Gewicht“ → „werden … nicht erfasst“. |
| m17 / what-it-needs | Draft read as if M17 needs the preamble on every firmware. Restructured so the condition "with the firmware the phone shipped with" governs the whole sentence, as in the English. | Sentence restructured (done during drafting, re-checked). |
| winlink-e-mail / writing | First draft "gesendet wird erst, wenn …" back-translated fine but the negation came late. | „nichts wird gesendet, bevor du dich verbindest“ (negation first). |
| channels / receive-only | Draft put "are refused" at the very end of a long clause. | „Solange du auf ihm bist, werden … abgelehnt“; kept strong, no softening. |

No section had a lost or added negation, number or unit after these fixes.

## Section by section (back-translation summary, result)

### pager
- title/summary: "Send a POCSAG page to one or several RICs, in one transmission." OK.
- open-it: PKT/Web paths; frequency starts as current channel; 1200 usual, 512/2400 too; function code 3 alphanumeric; pages to numeric-only pagers (function 0) not sent yet. OK.
- who-it-goes-to: RIC numbers or contact name/callsign; several per transmission, spaces/commas; contact with several RICs paged on all; own RICs in PKT → APRS settings. OK.
- sending: low power on that frequency; about 2 s; buffer, page, tail; low-power VFO if not on a low-power wide channel, waits for settle, returns; signing on unless tapped off, callsign + colon; SignalDeck treats as sender and can reply, ordinary pager shows it as start; symbol engine, only bench firmware from FW21; stock firmware: Send says so and does not key. OK.
- receiving: below squelch on the analog channel; filed by RIC owner; signed unknown RIC under callsign; neither → under RIC, open thread, Save as contact / Mute; bench: voice filter held open; 512 baud restore, ~7.5 ms high-pass, offset = preamble average, previous bit kept until a quarter of the eye past threshold; padding hidden; held-path EQ not used at 512; 1200/2400 use it, no restore; stock: Hear pages needs bench firmware, does not start; bad address word / >1 bit repaired → no page; listed only with preamble just before and a checking message word; damaged address not shown as another number; Messages → scan icon = monitor mode, receive only, long-press to edit, ~2.5 s each, stays during preamble and ~1 s after; own RIC → notification. OK.

### m17
- title/summary: "Hear M17 digital voice and answer once the module firmware can send it." OK.
- what-it-is: 4FSK, 4800 symbols/s, Codec 2; caller, destination (callsign, reflector module, @ALL), text shown, history and Logbook (mode M17); encrypted shown, not played. OK.
- how-it-works-on-this-radio: below ~250 Hz removed; stock firmware: EQ from decoded symbols, per-model calibration; Armor 300/300; W6+ 99/100, cuts low tones harder; Atom XL ~0.01 % fast, 89/100; W6Plus DMR ~80/100, noisier; others use Armor's; bench (not DMR003.UV4T.V022): hold filter open, fixed EQ checked before sync search; learning from clean ≥20-frame call, kept only if a later call 6 dB weaker or another station decodes at least as well; improves, cannot create; >20 s stays one listing, ~1 s gap does not split; long-press note → shipped EQ; muted audio not searched; Armor has the measurement; without it calibrated EQ; hold re-sent after PTT release. OK after fix ("checked").
- what-it-needs: fairly strong, ~−94 dBm; stock firmware locks on preamble, in-progress transmission skipped; filter held open → can lock mid-transmission; buzz held back, decoded voice on speaker/Web/spectrum; phones whose radio drives the speaker: buzz stays audible, page says so; W6+ not affected. OK.
- switching-to-dmr: needs analog; DMR channel stops it on every firmware; bench: normal DMR settings restored first, filter setting would take the sync off DMR transmissions. OK.
- talking-back: SAFETY (see below). OK.
- text-messages: bench only; to channel's M17 destination or @ALL; APRS callsign; same transmitter, under 2 s; listed on M17 page and Messages, one thread per callsign, @ALL in shared thread; intercom history line; stock firmware receives, does not send; lost frames → history says so, text not shown; Web Packet page same box. OK.

### ft8-over-fm
- title/summary: OK.
- what-it-is: 15 s slots, structured messages, automatic contacts; rides on FM channel; another SignalDeck or WSJT-X via FM radio; agree a simplex frequency, avoid national calling frequencies; bench FW22 or later, 79 tones via tone generator; history says so. OK.
- what-it-cannot-do: FM only, cannot hear SSB FT8 (144,174 / 432,174 MHz, HF); one station per slot; weak-signal reach mostly lost; a little more range than voice, not dramatically more. OK.
- the-screen: slot clock, 15 s, periods :00/:30 and :15/:45, red when transmitting; waterfall 200–2800 Hz, red lines, tap to move, matters little on FM; QSO, state, decodes newest first: time, dB in 2500 Hz approx., DT seconds, audio frequency, message; CQ green, to you amber; own under Sent. OK.
- making-contacts: tap CQ to answer, other period, WSJT-X sequence, logged once reports exchanged; Call CQ; Halt TX; stops by itself after 8 tries (RR73 after 2); Send text: standard message or up to 13 characters (A-Z, 0-9, space, + - . / ?); callsign from APRS settings; non-standard callsign (more than three letters after the digit, unusual prefix) only in full in a message without grid/report; history says so once; CQ without grid; short code <CALL>; caller with such a call answered though no grid. OK.
- settings-and-clock: grid 4 characters, ~100 × 200 km, empty = phone location, typed = fixed, - = none; Clear list; clocks within ~1 s, network time, average DT; 14 s per transmission with lead-in; Stop FT8, back arrow keeps running with bar; Web Packet page. OK.

### winlink-e-mail
- title/summary: OK.
- what-it-is: SAFETY (licence). Address format kept English (CALLSIGN@winlink.org). OK.
- please-report: not yet tested with the real system; test gateway by radio, test server by internet; please report with session log; notice opens GitHub issue page. OK.
- detailed-log: settings path; offered at first connection; step times, protocol bytes both ways, every radio frame; password never in it; message data only with the second box; Session log → Share log (Web: Download log); please send whether it worked or not. OK.
- trying-a-real-gateway: one session; report phone, radio (gateway callsign, frequency, distance) or internet, connected/logged in, message arrived (to own address), mail back, duration; failure → copy session log (login answer already hidden); start with one short message to yourself. OK.
- writing: To (comma-separated), optional Cc, subject, plain text; Put in the outbox stores; nothing sent until you connect; compressed; a page of text takes minutes at 1200 baud; Reply/Forward quote; Delete (from outbox then not sent). OK after negation moved forward.
- connect-radio: RMS, winlink.org RMS channels, usually 1200 baud on 2 m / 70 cm; Connect: radio, gateway callsign, digipeaters; AX.25 connected mode; sends outbox, collects mail, hangs up; a few minutes, 1,6 s lead-in, lost frames resent; Packet terminal not usable meanwhile. OK.
- gateways-near-you: path; RMS List → Packet → CSV File; desktop site if cut off; Import the CSV → file picker, Recent or Downloads; Web imports from a computer; repeat now and then; keeps 1200-baud gateways on tunable frequencies, nearest first, distance/direction from last known position (computed on phone, never sent); tap: tune+connect, tune+listen, make it your gateway; packet finder on nearest 10. OK.
- connect-internet: same exchange with the CMS over internet; to test setup, or no gateway in range but signal. OK.
- account-and-password: SAFETY-relevant (credentials). OK.
- session-log-and-attachments: last connection line by line, login answer hidden; attachments under message, open/share; notification, PKT count. OK.

### net-control
- title/summary: "Run a net: check-ins, traffic and a report." OK.
- starting: name (last remembered); Start on current channel; clock; keeps running when sheet closed. OK.
- check-ins: type + Check in, or tap stations heard in the last 30 minutes (DMR with RadioID callsign, APRS, Morse IDs; names from logbook); >15 minutes after start → Late; Traffic/Late/Out; traffic highlighted; long-press removes. OK.
- ending: End; Share report (name, channel, times, net control, numbered check-ins with flags) or Add to logbook (each check-in as a contact/QSO); past nets under Net control; tap for report, long-press to delete. OK.

### band-scope
- title/summary: OK.
- open-it: path, tools button, Web → Scope; bands list incl. NOAA where the region has weather radio, Show all bands; Custom range from/to MHz, step kHz, within 136–174 or 400–480 MHz, up to 1200 steps; sweep time shown; Start. OK.
- what-it-shows: cyan latest sweep drawn over previous; amber peak since Start or Clear peaks; waterfall newest on top, dark → cyan → green → amber → red; strongest signals ≥ 8 dB above noise, with channel name. OK.
- how-fast: ~1 s per step; 0,7 s settle (earlier readings 15–20 dB low); reading 0,1–0,5 s; NOAA 7 steps ~7 s; 2 m FM simplex 81 steps ~1.5 min; 2 m in 25 kHz ~3 min; GMRS/FRS 421 × 12,5 kHz ~7 min; narrow custom range fastest; title line, estimate until first sweep; green frequency; intercom bar; lasting activity, not single short calls; Atom XL ~0.1 s, ~50 ms settle, few ms reading, measured 2026-10-30, ~1/9 the time, scanner leaves a quiet channel after 0.5 s instead of 1.5 s. OK.
- listen-and-stop: tap to read, Listen here stops scope and tunes VFO; receive only, speaker/decoders quiet; back to channel; stops on Talk, scheduled operation, satellite pass; does not start while a pass is tracked or one begins within 15 minutes. OK.

### scheduled-operations
- title/summary: "Start something at a set time, weekly or once." OK.
- open-it: paths incl. → Schedules; list, next run, switch; tap to edit/delete; Add a schedule. OK.
- what-it-can-do: listen (optionally record into Download/DMR/Audio/<channel>), scan zone, APRS monitoring on region's frequency, SSTV (144,500 or chosen channel), one APRS position beacon, packet finder, Winlink by radio (last gateway, chosen channel, radio returns, never more than 20 minutes) or internet; result in history; weekdays = weekly, none = once on a date; start time, minutes. OK.
- when-it-runs: exact alarm, on the minute with screen off, permission via root; at the end back to previous channel, switches off what it switched on; one at a time; tracked pass first (2 min before rise to 1 min after set) → skipped, history notes it; while transmitting waits up to 2 min; SignalDeck must own the radio; after handing back to the stock app schedules do not run. OK.
- example: weekly net, listen, repeater, record on, Tuesday, 19:00, 60 minutes. OK.

### fox-hunt
- title/summary: OK.
- opening-it: paths; tune fox's channel first, hunt listens on current channel. OK.
- the-readout: dBm (higher, closer to zero, stronger), S-meter, peak since open/clear; Beeper on faster/higher as signal rises; Pointing = compass bearing of phone top, true north. OK.
- marks-and-the-estimate: chest, turn slowly, body blocks from behind; Mark saves reading, position, bearing; ≥2 marks, crossing, stronger weighted; distance/direction; map colours, hollow ring = nothing heard; green ring; Plot, also automatic when no tiles load; without bearings strongest mark is the hint; Open in maps; marks refused while transmitting; kept until Clear marks (asks first), even when sheet closed. OK.
- prediction: three layers, remembered; Bearings on at first, ±15° band; Heat map on at first, ≥3 marks ≥100 m apart, ≥2 above noise floor; grid 2 × 2 km, 25 m squares, enlarged at edge; unknown power, open-ground to cluttered rates, chosen per hunt; noise-floor mark = fox farther; shading cyan→red, 50 % bright, 90 % faint; combined; confidence: good ≤ ~100 m radius, fair ≤ ~300 m, rough bigger; both off = as before; limits: 10 dB or more; open ground, spread out, same hold; Off-frequency near the fox. OK.
- terrain: off at first (download, battery); ground heights between, ridge/hill loss, same model as coverage maps; impossible places drop out, weak mark behind hill no longer looks too far; needs Heat map on; Terrain Tiles; Download terrain with size, usually well under 1 MB; kept on phone, shared, offline later; antenna height 1,5 m / 10 m / 30 m; 100 m blocks then 25 m squares; remembered; hills only, no buildings/trees, ~55 m spacing, small bank or wall not shown. OK after fix.
- spin-for-the-bearing: flat on chest, top ahead, full circle, 20–40 s; ring colours, white tick; Slower above ~45°/s, Keep turning, Keep going; full circle or Fit now; strongest direction, or opposite the weakest when that is sharper and deeper; result: bearing, uncertainty, feature; green line; Save mark with that accuracy vs. ~15° point-and-mark; too small difference (< 6 dB or not above scatter), gap, too few readings → spin again; Only the fox's → Waiting for the fox; needs compass and position, not while transmitting. OK.
- fox-signal: Any signal default; Only the fox's; analog: own tone squelch, CTCSS heard now (1,5–3 s, only while a tone is heard), or any from list; DCS only via own DCS squelch, only with Soft SQ off; DMR ID (Last caller), optional colour code, empty = any; counts from 0,3 s into transmission, 0,7 s after retune, not in the last 0,6 s; average of last readings; Mark while silent → Waiting…, taken at next transmission where you stand then, tap again to cancel; Auto-marks off at first, 50/100/200/25 m, by GPS, bearing if held steady 1,5 s, never while transmitting; remembered. OK.
- close-to-the-fox: top of scale; Off-frequency 10/20/30 kHz above; closing tunes back. OK.
- on-the-unihertz-atom-xl: USB bridge stops sound when a command crosses during reception; readings may cut audio for a few seconds; bridge restarted automatically; bearing and readout unaffected. OK.
- be-the-fox: SAFETY (see below). OK.

### channels
- title/summary: OK.
- the-list: number, name, RX frequency, FM/DMR, last heard (time today, yesterday + time, else date + time); colour code, slot, shift, tones in editor; active glows, ON AIR. OK.
- find-and-filter: names, frequencies (462,6), numbers; chips; zone button. OK.
- several-channels-at-once: long-press or Select several; tap ticks; All ticks shown (search/filters first); star/unstar; add to zone or new zone; Out of zone (channels stay, zone never left empty); delete after confirmation, leave every zone, later channels move up; cross ends; Web same; phone and Web follow each other, selection there ends. OK.
- zones-and-standard-lists: SAFETY (licence; see below). Counts checked: FRS 22, GMRS 22 + 15R–22R, NOAA 7, MURS 5, Marine 10, DMR simplex 6 / CC 1 / TS 1 / TG 99, Business 12, Railroad 96, 437,825 / 437,550, 67 Hz, PMR446 16. OK.
- favourites: star toggles; ★ Favourites zone; arrows and scanner limited. OK.
- use-edit-delete: Use (switch), Edit, Star, Delete; + adds. OK.
- history: last heard; editor History section and card button; newest first, by day; item list; DMR caller tappable; Clear this channel's history; captions kept. OK.
- receive-only: SAFETY (see below). OK.
- notes: who, club/owner, linking, hours, how to check in; in backups, can go with a share. OK.
- channel-names: 32 characters in both editors, counter amber at limit; Nearby repeaters within limit; longer imported name shortened on next save; OpenGD77 CPS 16 characters, may be cut. OK.
- sharing-channels: privacy-relevant (see below). OK.
- importing-channels: share to SignalDeck (Import channels), CHIRP CSV, clipboard or Import a file; finds code anywhere, even broken lines; CHIRP CSV; preview, existing unticked, outside 136–174 / 400–480 MHz or not FM listed as left out; Import adds after yours, new zone by default; nothing changed; notes and net schedules kept (switch leaves them out); nets in Nets near you. OK.
- editing: info buttons; analog fields; Soft SQ; M17 = wide FM + destination (@ALL or callsign, from a contact) + access number 0–15; Web same; Talk sends M17 with symbol engine, receive-only on stock firmware; module squelch held open, only decoded voice played; list marks M17; kept in backup; lat/long → place name, distance, bearing; My position, Open Maps, Share → SignalDeck, Paste; sharing a place with no editor asks which channel; DMR: colour code, slot, call target, up to 32 talkgroups (group call's TG added on save); talkgroup lists; DMRModHooks lists from stock app; VHF always wide, narrow makes receiver deaf; Call number from toggles typing/picking (group/private); number stored either way. OK.
- nearby-repeaters: BrandMeister, RadioID, hearham; nearest first; 15/30/60/120 miles (25/50/100/200 km); FM/DMR and VHF 136–174 / UHF 400–480 rows, remembered; one tap adds repeater with channels, TG contacts and a zone, can be undone. OK.

### contacts
- title/summary: OK.
- what-a-contact-is: person or talkgroup; DMR ID or TG number, callsign (-SSID), RICs, notes, home location + label; needs at least one of DMR ID / callsign / RIC; APRS or M17 station is a contact too; module table only ever gets DMR numbers. OK.
- the-list: cyan private, violet talkgroup, amber all-call; DMR ID, green callsign, PAGER, last heard format; chips; search fields. OK.
- callsigns-from-radioid: private contact with ID and no callsign gets RadioID callsign once; editor says so; change/clear stays. OK.
- one-tap-from-anything-heard: every callsign/ID/RIC tappable; places listed; known opens; unknown: Add to contacts (prefilled identity, position, time) or Add to an existing contact; Web from APRS map cards. OK.
- two-locations-kept-apart: privacy-relevant (see below). OK.
- history: heard items and sent items listed; newest first; up to 300; tap to see; position opens maps; repeats within 20 s folded. OK.
- actions: +; green bubble (contacts with DMR ID); sheet: identity, locations, notes, history, Message/Edit/Delete. OK.
- your-own-identity: callsign, SSID, RICs once in PKT → APRS settings; APRS and M17 send under it; pages carry it as sender tag; pager listens for RICs; DMR ID in Device → Radio settings. OK.
- backups: extras file next to the five CSVs, matched by number/type/name; contacts without DMR ID restored from there; Contacts.csv plain layout; heard history not in a backup. OK.

## Counts
- Strings checked: 89 (10 titles, 10 summaries, 69 section texts; the 69 heads were checked with their sections).
- Meaning changes found and fixed: 2 (m17 "checked", fox-hunt terrain "does not show").
- Negation placements tightened: 2 (winlink writing, channels receive-only); one condition restructured (m17 what-it-needs).
- Remaining differences in negation, number or unit: 0.

## SAFETY-relevant sections, checked twice
Each was read a second time against the English, looking for a softened "not", a lost limit, or a condition that moved.

- pager / sending: transmits at low power; only from bench firmware FW21; on stock firmware Send does not key. Checked twice.
- pager / receiving: monitor mode is receive only. Checked twice.
- m17 / talking-back: cannot talk back on stock firmware; ends at the transmit limit (2 minutes default); heat guard past 30 seconds; needs analog channel. Checked twice.
- m17 / text-messages: stock firmware does not send these texts. Checked twice.
- ft8-over-fm / what-it-is: avoid the national calling frequencies. Checked twice.
- ft8-over-fm / making-contacts: automatic transmissions; stops after 8 tries (RR73 after 2). Checked twice.
- winlink-e-mail / what-it-is: an amateur licence and callsign are needed. Checked twice.
- winlink-e-mail / detailed-log: password never in the log. Checked twice.
- winlink-e-mail / writing: nothing is sent until you connect. Checked twice.
- winlink-e-mail / account-and-password: password never shown, logged, in a device report, a backup or Android's cloud backup; only a one-time answer is sent. Checked twice.
- band-scope / listen-and-stop: receive only; stops on Talk; does not start near a satellite pass. Checked twice.
- scheduled-operations / what-it-can-do: Winlink check never holds the radio more than 20 minutes; sends one beacon. Checked twice.
- scheduled-operations / when-it-runs: waits up to two minutes while you transmit; schedules do not run after handing back. Checked twice.
- fox-hunt / marks-and-the-estimate: marks refused while transmitting. Checked twice.
- fox-hunt / spin-for-the-bearing: not while you transmit. Checked twice.
- fox-hunt / fox-signal: auto-marks never while you transmit. Checked twice.
- fox-hunt / be-the-fox: beacon transmits 5 s every minute until stopped or the channel changes; callsign in Morse on amateur channels. Checked twice.
- channels / zones-and-standard-lists: "not legal here"; transmitting is your responsibility; US licence needed for GMRS and Business (kept as US statements); receive-only lists; licence-free lists at low power. Checked twice.
- channels / receive-only: Talk, the side key and every automatic transmission refused; NOAA, marine and railroad always receive only. Checked twice.
- channels / sharing-channels: notes and locations off unless turned on; encryption keys never shared. Checked twice.
- channels / editing: M17 Talk only with the symbol engine, receive-only on stock firmware; narrow band makes VHF receiver deaf. Checked twice.
- contacts / two-locations-kept-apart: home location never leaves the phone unless you send it; automatic fix never overwrites. Checked twice.

22 sections checked twice.
