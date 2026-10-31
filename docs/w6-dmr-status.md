# W6 DMR variant: status mailbox

**HackRF and hotspot leases ended 11:15 (Grok, CTCSS and TG 99 promiscuous rows).** No hackrf_transfer running. Nothing was transmitted toward the W6 phones. The hotspot config was not changed.

**HackRF and hotspot leases ended 10:46 (Grok, FW57 acceptance remainder).** No hackrf_transfer running. Nothing was transmitted toward the W6 phones. The hotspot config was not changed.

**HackRF and hotspot leases ended 10:02 (Grok, data-hold test).** No hackrf_transfer running. Nothing was transmitted toward the W6 phones. The hotspot config was not changed.

**HackRF and hotspot leases ended 09:56 (Grok, F55A slot 0).** No hackrf_transfer running. Nothing was transmitted toward the W6 phones. The hotspot config was not changed.

**HackRF lease ended 09:36 (Grok, FW57 rows).** No hackrf_transfer running. Nothing was transmitted toward the W6 phones.

**HackRF lease ended 09:08 (Grok, FW57 rows).** No hackrf_transfer running. Nothing was transmitted toward the W6 phones.

**W6+ lease ended 21:44 (W6 DMR agent, PR 104 device pass).** Nothing transmitted. The W6+ is back on beta.23 with its original channel database (2 channels, Favourites zone), running; battery 74 %. M17 receive left off (it was on from the manager's test; turned off as allowed). SignalDeck Web left on.

**W6Plus DMR lease ended 02:21 (W6 DMR agent, DMR-source prep and restore).** Nothing keyed by me.
- Channels 129–131 deleted (128 channels, as before); DMR ID restored (matches the saved value, which is now deleted from my scratchpad).
- VFO 467.625 analog, low power, M17 receive on; SignalDeck Web left on.

**W6Plus DMR lease ended 03:22 (W6 DMR agent, FW60 DMR-source prep and restore).** Nothing keyed by me.
- Channels 129–131 deleted (128 as before); DMR ID restored (verified, saved copy deleted).
- VFO 467.625 analog, low power, M17 receive on; SignalDeck Web on.

**W6Plus DMR lease ended 08:55 (W6 DMR agent, promiscuous-row prep and restore).** Nothing keyed by me.
- Channels 129/130 deleted (128 as before); DMR ID restored (verified, saved copy deleted).
- VFO 467.625 analog, low power, M17 receive on; SignalDeck Web on.

STATUS: IDLE (08:55 W6 DMR agent: W6Plus DMR restored; no phones held. Queued: All-Call as group voice to 16777215, needs a bench slot)

**2026-10-31 09:21 (manager): LEASE GRANTED to the W6 DMR agent: the W6Plus DMR (192.168.1.133) for the F62D-row PREP and later RESTORE (no keying by you): bench ID 1234567; Bench TG9 and Bench TG99, 467.625, CC1, TS2 (stored 1), low power. Post 'prep done' and message me; Grok keys in its ~40 min lease; restore after its lease-ended.**

**2026-10-31 08:29 (manager): BENCH LEASED TO GROK (promiscuous rows: flag off/on x MON off/on, W6Plus TG 9/TG 99 + HackRF TG 99 replay), about 75 min: Armor 26 Ultra + HackRF + the W6Plus DMR keying (key.sh, bench ID 1234567). Ends on FW57. Don't touch them until the lease-ended line in `radio_firmware/HANDOFF.md`; the W6 DMR agent restores the W6Plus after it.**

**08:28 W6 DMR agent: W6Plus DMR (192.168.1.133) PREP DONE for the promiscuous rows.** beta.25, battery 100 %, nothing keyed.
- **DMR ID:** 1234567; the previous ID is saved in my scratchpad only.
- **Channels:** read back, both 467.625 simplex, DMR, low power, CC 1, TS2 (stored 1):
  - 129 "Bench TG9": group 9;
  - 130 "Bench TG99": group 99.
- **Keying (Grok):** `bash /c/Users/Joshua/AppData/Local/Temp/claude/D--Documents-code-personal-phonedmrapp/5950190b-2f56-47ee-ae7d-d56c8c611e78/scratchpad/v69/dmrkey/key.sh "Bench TG9"` (or "Bench TG99"). SignalDeck Web is on.


**2026-10-31 08:27 (manager): LEASE GRANTED to the W6 DMR agent: the W6Plus DMR (192.168.1.133) for the PROMISCUOUS-row PREP and later RESTORE (no keying by you): bench ID 1234567; channels Bench TG9 and Bench TG99, 467.625, CC1, TS2 (stored 1), low power. Post 'prep done' here and message me; Grok keys in its lease (in an hour or two); restore after its lease-ended.**

**2026-10-31 03:21 (manager): BENCH LEASED TO GROK (F60D/FW60 with the HackRF replay of the hotspot All-Call), about 75 min: Armor 26 Ultra + HackRF. Ends on FW57. Don't touch them until the lease-ended line in `radio_firmware/HANDOFF.md`. The W6Plus DMR is released back to the W6 DMR agent for its restore.**

**2026-10-31 02:54 (manager): BENCH LEASED TO GROK (FW60: F60D All-Call/TG 9/TG 99 rows, then FW60 acceptance), about 90 min: Armor 26 Ultra + HackRF + the W6Plus DMR keying (key.sh, bench ID 1234567). Ends on FW57 with the PR 182 build. Don't touch them until the lease-ended line in `radio_firmware/HANDOFF.md`; the W6 DMR agent restores the W6Plus after it.**

**02:54 W6 DMR agent: W6Plus DMR (192.168.1.133) PREP DONE for FW60.** beta.25, battery 100 %, nothing keyed.
- **DMR ID:** 1234567; the previous ID is saved in my scratchpad only.
- **Channels:** read back, all 467.625 simplex, DMR, low power, CC 1, TS2 (stored 1):
  - 129 "Bench TG9": group 9;
  - 130 "Bench TG99": group 99;
  - 131 "Bench AllCall": contactType 2, call 16777215.
- **Keying (Grok):** `bash /c/Users/Joshua/AppData/Local/Temp/claude/D--Documents-code-personal-phonedmrapp/5950190b-2f56-47ee-ae7d-d56c8c611e78/scratchpad/v69/dmrkey/key.sh "Bench TG9"` (or "Bench TG99" / "Bench AllCall"). SignalDeck Web is on.


**2026-10-31 02:53 (manager): LEASE GRANTED to the W6 DMR agent: the W6Plus DMR (192.168.1.133) for the FW60 DMR-source PREP and later RESTORE (no keying by you): bench ID 1234567; channels Bench TG9, Bench TG99, Bench AllCall (contactType 2, 16777215), all 467.625, CC1, TS2 (stored 1), low power. Post 'prep done' here and message me; Grok keys in its lease; restore after its lease-ended.**

**02:29 W6 DMR agent: W6Plus All-Call LC cross-check (`fw-bench/w6_A_allcall.iq`) — inconclusive, my decoder is not reliable here.**
- **Signal:** carrier 3.5 s, offset about −375 Hz after a +1.6 kHz shift, colour-code and sync bursts found. The signal at the HackRF is weak (~9 dB over the floor before DC removal).
- **Raw voice LC headers** (no FEC), bytes 0–5: `49 00 08 FF FF 45` twice, and the PI header `00 10 08 FF FF 45`.
- **Destination:** bytes 3–4 are consistently FF FF, so it looks like 16777215 with the last byte damaged.
- **FLCO:** byte 0 reads 0x49 (FLCO 9) on both voice headers, where a group call should be 0x00. That's not trustworthy: the TG 9 capture, whose true content is known (FLCO 0, destination 9, source bench), decodes with errors in bytes 0, 2 and 5 at the same SNR.
- **FEC attempt:** my BPTC(196,96) Hamming row/column correction "fixed" 27–46 bits per header, impossible for BPTC, so its layout or equations don't match ETSI. Not used.
- **What is certain from the code:** SignalDeck passes contactType 2 with txContact 16777215 raw in the 0x22 channel write (`RadioEngine.setDigital`). The DMR006 module builds the LC, so the FLCO is the module's choice.
- **Recommendation:** take Grok's decode, or run a full decoder with FEC (dsd-fme) on the IQ. A stronger capture (HackRF nearer the W6Plus) would let mine read it too.

**2026-10-31 02:17 (firmware): lease ended. Armor is on FW57 with the PR 182 build, not transmitting. HackRF is free. The W6Plus is not keyed; the W6 DMR agent restores it.**

**2026-10-31 02:11 (manager): BENCH LEASED TO GROK (PR 182 real-radio rows A-D), about 60 min: Armor 26 Ultra + HackRF + the W6Plus DMR (keying via key.sh, bench ID 1234567 only). Don't touch them until the lease-ended line in `radio_firmware/HANDOFF.md`; the W6 DMR agent restores the W6Plus after it.**

**02:10 W6 DMR agent: W6Plus DMR (192.168.1.133) PREP DONE.** beta.25, battery 100 %, nothing keyed.
- **DMR ID:** set to the bench ID 1234567. The previous ID is saved in my scratchpad only, never printed, and will be restored.
- **Channels:** all 467.625 simplex, DMR (type 0), low power, CC 1, TS2 (stored slot 1, as on the Armor), read back from the phone:
  - 129 "Bench TG9": group call 9;
  - 130 "Bench TG99": group call 99;
  - 131 "Bench AllCall": contactType 2, call 16777215.
- **Keying (Grok):** `bash /c/Users/Joshua/AppData/Local/Temp/claude/D--Documents-code-personal-phonedmrapp/5950190b-2f56-47ee-ae7d-d56c8c611e78/scratchpad/v69/dmrkey/key.sh "Bench TG9"` (or "Bench TG99" / "Bench AllCall").
  - The script selects the channel via SignalDeck Web (PIN read to a temp file, never printed), waits 4 s, then DIAG `testtone --ei ms 3000`; ~11 s per run.
  - SignalDeck Web is left on for it.
- **Restore** after Grok's lease-ended: delete 129–131, restore the ID, VFO 467.625 analog, M17 receive on.


**2026-10-31 02:09 (manager): LEASE GRANTED to the W6 DMR agent: the W6Plus DMR (192.168.1.133) for the DMR-source PREP and later RESTORE only (no keying by you): bench ID 1234567, three channels on 467.625 TS2 low power (TG 9, TG 99, All-Call). Grok does the keying in its own lease. Post 'prep done' here, then 'restore done / lease ended' after Grok's rows.**

**2026-10-31 01:39 (manager): BENCH LEASED TO GROK (+20 min: DMR status / audio / 0x2B timing at two levels), Armor 26 Ultra + HackRF. Don't touch them until the lease-ended line in `radio_firmware/HANDOFF.md`.**

**2026-10-31 01:39 (manager): BENCH GRANTED TO THE FIRMWARE AGENT/GROK: Armor 26 Ultra + HackRF + the W6Plus DMR (192.168.1.133) for the stock-app admission rows: (1) Hand back to the OEM app on the Armor and replay TG 9/99, then SignalDeck takes it back; (2) the W6Plus DMR keys TG 9 and TG 99 group calls with the bench DMR ID 1234567 at low power on 467.625 into the Armor. ~45 min. Don't touch them until the lease-ended line in `radio_firmware/HANDOFF.md`.**

**2026-10-31 01:28 (manager): BENCH LEASED TO GROK (+15 min: does a squelch-0 + MON-off opened gate pass out-of-list TGs), Armor 26 Ultra + HackRF. Don't touch them until the lease-ended line in `radio_firmware/HANDOFF.md`.**

**2026-10-31 01:07 (manager): BENCH LEASED TO GROK (+30 min: bisecting SignalDeck's take-over commands vs the DMR speaker gate), Armor 26 Ultra + HackRF. Don't touch them until the lease-ended line in `radio_firmware/HANDOFF.md`.**

**2026-10-31 00:56 (manager): BENCH LEASED TO GROK (+15 min: power-cycle + take-over vs the DMR speaker gate), Armor 26 Ultra + HackRF. Don't touch them until the lease-ended line in `radio_firmware/HANDOFF.md`.**

**2026-10-31 00:49 (manager): BENCH LEASED TO GROK (+15 min: 0x2F body 1 on a DMR channel vs admission), Armor 26 Ultra + HackRF. Don't touch them until the lease-ended line in `radio_firmware/HANDOFF.md`.**

**2026-10-31 00:38 (manager): BENCH LEASED TO GROK (+25 min: mapping what opens/closes the DMR speaker gate), Armor 26 Ultra + HackRF. Don't touch them until the lease-ended line in `radio_firmware/HANDOFF.md`.**

**2026-10-31 00:27 (manager): BENCH LEASED TO GROK (+25 min: DMR speaker gate rows, MON on/off, open analog squelch first), Armor 26 Ultra + HackRF. Don't touch them until the lease-ended line in `radio_firmware/HANDOFF.md`.**

**2026-10-31 00:06 (manager): BENCH LEASED TO GROK (HackRF replays at two levels, FW57 then F59D), about 60 min: Armor 26 Ultra + HackRF (no hotspot). Don't touch them until the lease-ended line in `radio_firmware/HANDOFF.md`.**

**2026-10-30 23:29 (manager): BENCH LEASED TO GROK (+30 min: app restart / module power-cycle after the factory+key ritual), Armor + HackRF + hotspot. Don't touch them until its lease-ended line.**

**2026-10-30 23:13 (manager): BENCH LEASED TO GROK (channel 49 DMR RX, TG 9 control; journal read-only), about 45 min: Armor 26 Ultra + HackRF + hotspot. Don't touch them until the lease-ended line in `radio_firmware/HANDOFF.md`. Atom XL and both W6s are not in it.**

**22:31 W6 DMR agent: M17 receive — root cause and fix (draft SignalDeck PR 180).**
- **Root cause, confirmed** (with the Atom XL agent and the manager's analysis): the receiver locked on only from the 40 ms preamble, and every Armor clip has 0 preamble windows. The phones' audio opens 45–370 ms after the carrier, so the preamble and the link setup are gone on the air.
- **Fix:** late entry on the stream sync word:
  - a gain-free linear prefilter, then gain factors 0.25–1.0 × stream RMS;
  - the frame's LICH and the next frame's sync required;
  - announced at the first confirmed frame; callsign from the LICH;
  - a late call's gain refined on confirmed frames.
- **Host results** (shipped tables, confirmed frames):

| Recording | Confirmed |
|---|---|
| W6+ near / far | 1111 / 1100 of ~1120 |
| W6Plus DMR near / far | 981 / 1006 |
| Atom XL near | 1006 of 1112 |
| Atom XL far (29 s clip) | 609 of 681 |

  Each locks 0.2–0.4 s in. The references are unchanged; noise starts no call; the cost on noise is ~0.85 % of real time on a PC.
- **Lease request:** the W6+ and the W6Plus DMR, about 45 min, receive only, on 441.025 MHz (DIAG `vfo --ei hz 441025000`), with the Armor's runner stream on `--freq 441025000` when you schedule it. Plan: install the PR build with `install -r`, M17 page on, count the decoded frames, then restore beta.23 (or the current beta).


**2026-10-30 22:08 (manager): BENCH LEASED TO GROK (admission plan A-D), about 1.5 h: Armor 26 Ultra + HackRF + hotspot. Don't touch any of them until the lease-ended line in `radio_firmware/HANDOFF.md`. The Atom XL and both W6s are NOT in this lease.**

**21:44 W6 DMR agent: PR 104 device pass on the W6+ (branch build 31edbb59), all guards held.**
- **Setup:** two out-of-band channels planted in a copy of its channel database (146.520, and a split 437.800 / 145.990), plus a zone holding only the 146.520 one; the original database restored afterwards.
- **Results:**

| Check | Result |
|---|---|
| Channel list | Both out-of-band channels marked `tunable: false` |
| Select either | Refused (409 "… is outside 400–470 MHz: this radio cannot tune it") |
| Stepping, four up and three down | Only channels 1 and 2 |
| Scanning, 18 s | Only channels 1 and 2 |
| Zone with only out-of-band channels | Refused (409 "has no channel this radio can tune") |
| Schedule: APRS monitoring | Refused (400 "not 144.390 MHz: no APRS monitoring", from the region frequency) |
| Schedule: listen on channel 3 | Refused; no schedule created |
| VFO to 146.520 | Refused |
| Saving a new 2 m channel | Refused |
| Web radio flags | `aprsTerrestrial`, `sstv144`, `weather` false; bands 400–470 MHz |
| Phone's channel list | Both channels dimmed with the badge |

- **Cosmetic finding:** on the W6+'s 480 px screen the badge is cut off as "NOT TUNABL". Not fixed here; a shorter label or a wrap would do. Say if you want it in this PR.


**2026-10-30 21:38 (manager): LEASE GRANTED to the W6 DMR agent: the W6+ (192.168.1.163) for the PR 104 device pass, about 45 min, no transmit. The W6Plus DMR, Atom XL, Armor and HackRF stay with the manager (M17 work). Post lease-ended here when done.**

**21:34 W6 DMR agent: SignalDeck PR 104 (band guards) refreshed for beta.25; asking for a W6 lease.**
- **Merged `origin/main` into `claude/band-guards`.** No rebase and no force-push; pushed as a fast-forward (`31edbb59`). Done from my worktree because `SignalDeck-bands` holds the branch: that worktree is left untouched, its local branch is now behind the remote, and it has uncommitted generated help files.
- **Conflicts resolved keeping both sides:**
  - **Zones:** main's region and legality lists, with out-of-band lists not offered and main's partial "N of M in this radio's bands" marks.
  - **Band scope:** main's region presets and "Show all", filtered to bands the radio tunes.
  - **Scheduler:** the APRS guard now uses the region's APRS frequency (new overloads with `aprsHz`; the action names come from the region).
  - **Scan:** main's settle time and the branch's in-band priority channel.
  - **Web:** main's `aprsTerrestrial`/`aprsHz`/`region`, plus the branch's `sstv144`.
  - **ChannelPresets:** main's `inBands` skip, with the install guard checking the same predicate.
  - **Help:** main's newer topics, with the band-guard passage reinserted.
- **Newer profiles checked:** 3WT 100–174 / 400–470 MHz, 20WT and Xplore 1 on the default bands, W6Plus DMR UHF. The guards all go through `tunable()`; a new test `theNewerProfilesKeepTheirBands` pins them.
- **Checks:** whole host suite passes (BandGuardsTest 6/6). Help regenerated; only `device.md` and `help.json` changed in content.
- **Lease request:** a UHF-only W6 (W6+ 192.168.1.163, or the W6Plus DMR) for the device pass, about 45 min, no transmit needed. The plan: install the branch build, then check:
  - out-of-band channels dimmed and refused;
  - the arrows and scan skipping them;
  - zone lists, band scope, scheduler, VFO and Web following the bands.
  
  Then restore beta.22 or the current beta. I won't touch the phones until a lease line is pushed.


**2026-10-30 20:29 (manager): BENCH LEASED TO GROK (All-Call rows with clean files), about 1.5 h: Armor 26 Ultra + HackRF + hotspot. Don't touch any of them until the lease-ended line in `radio_firmware/HANDOFF.md`.**

**2026-10-30 19:42 (manager): BENCH LEASE RENEWED FOR GROK (F59E), about 1.5 h more: Armor 26 Ultra + HackRF + hotspot. Don't touch any of them until the lease-ended line in `radio_firmware/HANDOFF.md`.**

**2026-10-30 19:21 (manager): BENCH LEASED TO GROK (FW59), about 2.5 h overnight: Armor 26 Ultra + HackRF + hotspot. Don't touch any of them until the lease-ended line in `radio_firmware/HANDOFF.md`.**

**18:56 (manager): Armor + HackRF leased to the FIRMWARE AGENT ~30 min for the SignalDeck beta.23 candidate check (app check). Not available to other agents until its lease-ended line.**

**18:33 W6 DMR agent: W6Plus DMR M17 equaliser (SignalDeck PR 172, for review) and the W6+ Soft SQ question.**
- **M17, W6Plus DMR:**
  - Its own table, fitted offline on one of today's HackRF transmissions, decodes the other at **79/100 exact**; every feedback length and fit direction gives 77–87.
  - Its residual is noisier than the W6+'s (fit MSE 0.14). The receiver's timing holds with no slips; the misses are scattered symbol errors. Self-calibration on received calls may improve it.
  - A host test reproduces the table; help, CHANGELOG. A live check on the phone needs a HackRF slot.
- **Soft SQ, W6+ "opens ~3.5 s late":**
  - **Not a phone fault.** Two-phone check just now (no HackRF): the W6Plus DMR sent the same speech file at low power on 434.000 through the bench `txwav`; the W6+ recorded with `rxclip` while Soft SQ level 5 ran.
  - The file starts with 1.5 s of silence and stays near-silent until 2.5 s. On the W6+ an unmodulated carrier comes out almost silent (RMS ~9), and the detector never opens on silence (a muted receiver is silent too). It opened **0.2 s after the first syllable** reached the W6+.
  - The W6Plus DMR opened at once in the HackRF run, most likely because its carrier hiss sits above the silence level.
  - The drop on the weak HackRF step: the W6+ was at the edge of what it hears from the HackRF (it needed gain 20 to detect at all) while the W6Plus DMR was not, so hiss in a speech pause closed it. That's the threshold working.
  - **No tuning PR proposed.** Say if you still want the W6+ to open on a silent carrier; it could use its receive line, which reports the carrier.
- **Phones:** back on beta.22 (a bench build was installed for the check, then restored), bench files deleted, batteries 82 % / 87 %, both on the 434.000 VFO.


**18:12 W6 DMR agent: W6+ M17 "regression" solved, offline (SignalDeck PR 171, for review).**
- **It was not the phone.** Today's W6+ recording correlates 0.995 with the 10-27 one: same gain, same timing, residual −20 dB. The held volume, the profile and the capture path are all unchanged.
- **Cause: the receiver's preamble search.** The 40 ms preamble is found with 160-sample windows on an 80-sample hop. Depending on where that grid falls, it spans three windows or only two. With two, the estimated end comes out a hop early, the link-setup sync lies ~82 symbols after it, and the search reached only ±60. The whole transmission is then missed (today: 0/100).
- **Every phone is exposed, at random:** by where the grid falls, a third or so of transmissions.
- **Fix:** search 64 symbols further forward. Today's recording now decodes 99/100 and 99/100; the 10-27 one is unchanged (98/99); the full host suite passes.
- **New regression test** on today's recording: `decodesTheW6WhenThePreambleSpansTwoWindows`.
- **W6Plus DMR equaliser:** a table fitted on transmission 1 decodes the other transmission (not fitted) at 79/100 so far; trying feedback lengths before the PR.


**17:49 (manager): Armor + HackRF + hotspot granted to Grok ~2 h (FW58 acceptance). Not available to other agents until Grok's lease-ended line.**

**HackRF lease ended 17:32 (W6 DMR agent).** No hackrf_transfer running. §3.7 items 6, 8 and Soft SQ done on the W6 phones (results in docs/w6-dmr-status.md).

**17:32 W6 DMR agent: §3.7 second HackRF slot (both phones on battery, beta.22, 434.000; HackRF gain 20 for the W6+, which sits farther from it: at gain 0 it never detected the signal).**
- **Item 6, receive audio path** (100 Hz–3.5 kHz at 1.5 kHz deviation, against 1 kHz): W6Plus DMR 100–250 Hz −30…−36 dB, 300 +9.1, 500 +6.1, 1.5 k −3.2, 2.5 k −7.5, 3.5 k −10.8 dB, 1 kHz at amplitude 2779; W6+ 100–250 Hz −25…−33, 300 +13.0, 500 +8.7, 1.5 k −5.0, 2.5 k −11.8, 3.5 k −17.2, 1 kHz at 1673 (steeper treble roll-off). **Drop-outs: none, 15 of 15 receptions heard in full on each phone.**
- **Item 8, M17 receive: fails on both.** W6Plus DMR: "2 frames (0 % clean)" (no equaliser of its own; the Armor's does not match its path). W6+: nothing decoded, although its own equaliser decoded 98/100 from a HackRF on 2026-10-27; to investigate. Raw receive audio of the two standard 100-frame transmissions captured on both phones (RMS ~3000–3700, no clipping) for offline equaliser work.
- **Soft SQ live** (level 5, speech at four levels, then nothing): both phones open on strong, medium and weak speech and stay shut at the module's threshold and on static. The W6+ opens about 3.5 s later than the W6Plus DMR on a strong signal and dropped once on the weak one (tuning item). Soft SQ restored off on both.
- Web PINs kept in scratch files only and deleted; Soft SQ, channels and VFOs as before.

§3.7 status for the W6 phones: items 1–7 and 9 done (PR 160 carries the profile changes); 8: M17 needs an equaliser for the W6Plus DMR and a look at the W6+ (offline from the captures), DMR receive needs another DMR radio; 10 heat waits for the owner.

**HackRF lease: W6 DMR agent, 17:22 until about 18:22** (second slot from the managing agent; Grok follows). §3.7 items 6, 8 (M17) and Soft SQ on the W6 phones, HackRF transmitting low-level tones, M17 and speech on 434.000 into the phones, ≤ 60 s files, foreground. Clear of 467.625; Armor not touched.

**HackRF lease: W6 DMR agent (phonedmrapp-de), from 17:22 for ~60 min (managing agent): resume §3.7 items 6 (RX audio response), 8 (M17 RX) and the Soft SQ checks on the W6 phones at 434.000 MHz; HackRF TX allowed in the cage at low level, ≤60 s files, foreground. Then Grok gets Armor + HackRF + hotspot ~40 min (FW58 gaps: out-of-list 0x2B on the VFO with list 1/9 MON on/off; raw DIAG op 6 double apply + DMR key with HackRF syncs). The full FW58 acceptance (~2 h) is scheduled after that.**

**17:04 (manager): Armor + HackRF + hotspot granted to Grok ~60 min (FW58 first bench run). W6 agent resumes items 6, 8 and Soft SQ with a fresh lease after Grok's lease-ended line.**

**HackRF lease ended 17:03 (W6 DMR agent, paused for firmware): handed to Grok.** No hackrf_transfer running. Done: §3.7 items 9, 1, 4 on the W6 phones (results in docs/w6-dmr-status.md). Items 6, 8 (M17) and the Soft SQ checks resume after Grok's lease, with a fresh lease from the managing agent.

**17:03 W6 DMR agent: §3.7 HackRF results so far (both phones on battery, beta.22, 434.000 low power).**
- **Item 9, transmit levels (HackRF receiving):** with the media volume held at 10/25 the W6Plus DMR's 0.03 gave APRS only 879 Hz p99 (the 2026-10-29 calibration was made at an unknown volume): **0.15 gives 2954 Hz p99** (0.10 → 2040, 0.12 → 2408), decoded at every level; response shape unchanged (+4.1 dB at 1.5 kHz, +6.6 at 2 kHz, +8.3 at 2.5 kHz against 1 kHz). **The W6+'s 0.2 is confirmed: 2900 Hz p99** (0.3 → 4086). Carrier offset against the HackRF: W6Plus DMR +1.56 kHz, **W6+ +1.64 kHz** (first measurement; the two agree, so much of it is the HackRF's own error).
- **Item 1, reading scale (W6Plus DMR; HackRF carriers stepped 10 dB):** raw 99 / 88 / 77 / 67 / 58 / 47 / 43 for 0 / −10 / −20 / −30 / −50 / −60 / −70 dB (the HackRF's gain floor made −30 and −40 equal), idle 42–43: **~1.0 raw unit per dB, linear over ≥ 56 dB.** The profile still has the Armor's 0.5 dB per unit: the W6Plus DMR needs the Atom XL's scale (same DMR006 module family): `rssiStepDb 1.0`, `rssiOffsetDb -17` (profile PR to follow with the 0.15 level).
- **Item 4, squelch opening (W6Plus DMR):** levels 1, 3, 5, 7 and 9 all report a reception at the same step (raw ~47, 4–5 dB above the floor) and none at the step below; **level 0 never reports one** (monitor). As on the Armor: one threshold, plus monitor.

**HackRF lease: W6 DMR agent, 16:50 until about 18:50** (granted by the managing agent; the owner moved both W6 phones into the cage with the HackRF). §3.7 on the W6 phones at 434.000 MHz: item 9 (HackRF receiving the phones' low-power TX), then items 1, 4, 6, 8 and the Soft SQ checks (HackRF transmitting low-level carriers, tones and M17 into the phones, files ≤ 60 s, foreground). Clear of 467.625; Armor not touched. Firmware agent: "HackRF wanted" and I hand over at the next safe point.

**HackRF lease: W6 DMR agent (phonedmrapp-de), from 16:48 for ~2 h (managing agent's grant; owner asked): §3.7 HackRF items on the two W6 phones (deviation at 10/25, reading scale, squelch opening + levels 0-9, Soft SQ live, RX audio response, M17 RX), HackRF receive only, W6 phones in the second cage on 434.000 MHz low power. Firmware keeps priority: if the firmware agent posts "HackRF wanted", hand it over at your next safe point. The Armor is not part of this lease.**

**16:48 W6 DMR agent: §3.7 item 7 (sub-audible tones), both phones on battery, beta.22: done.**
- **W6Plus DMR, tone heard from the audio** (W6+ sending): CTCSS 67.0, 123.0 and 254.1 Hz each logged "CTCSS … Hz heard" within a 5 s key (W6+ module codes 1, 18, 252).
- **W6Plus DMR, DCS through its own squelch** (a receive-only channel with DCS 023): the W6+ sending D023 (module code 39) opened it ("Received 5 s"); D754 (code 121) and no tone left it shut. DCS cannot be read from the audio (as on the Armor): the help's statement stands.
- **W6+, its module's CTCSS squelch** (a receive-only channel with 100.0 Hz, module code 12; the W6Plus DMR sending through its bench VFO): 100.0 Hz opened it; the neighbouring 103.5 Hz and no tone left it shut. The W6+ reads no tone from its audio (`subaudible=false`).
- Test channels created through SignalDeck Web and removed again (W6Plus DMR 128 channels, W6+ 2, as before); the web PINs were kept in scratch files only and deleted.

§3.7 for the W6 phones now: items 2, 3, 5 and 7 done (defaults confirmed: settle 700 ms, scanner); the HackRF items 1, 4, 6, 8 (M17), 9 and the Soft SQ checks wait for a slot (the owner asked to schedule them); 8 (DMR) needs another DMR radio; 10 (heat) the owner.

**Transmission window ended 16:48 (W6 DMR agent, second cage): lease ended.** Both W6 phones idle on 434.000 low power, unkeyed, on battery; test channels removed on both.

**16:42 W6 DMR agent: §3.7 block 3 = item 7 (both phones on battery): the W6+ sends CTCSS 67.0 / 123.0 / 254.1 Hz in 5 s low-power keys on 434.000; the W6Plus DMR's tone detection is checked.**

**2026-10-30 17:0x (manager): the owner extended the watch to 17:00 tomorrow (2026-10-31) for all workers. Usual rules: leases before any phone/HackRF/hotspot use; firmware has bench priority.**

**15:49 (manager): Armor to the firmware agent (~15 min), then Armor + HackRF + hotspot to Grok (~30 min). Not available to other agents until Grok's lease-ended line.**

**15:08 (manager): Grok's Armor + HackRF + hotspot grant extended ~30 min (P1/P2 follow-up). Not available to other agents until Grok's lease-ended line.**

**14:49 (manager): Armor + HackRF + hotspot granted to Grok for ~30 min (firmware P1 rerun, 467.625 MHz). Not available to other agents until Grok's lease-ended line.**

**Lease ended 14:20 (Atom XL agent). HackRF lease ended 14:20: HackRF free; managing agent, hand it back.** No hackrf_transfer running; SignalDeck beta.22 owns the Atom XL, channel 2, receive only; the Armor was not touched. Results: **(1) PR 141 passes on beta.22:** HackRF -x 10/20/30 -> raw 0x40/0x4B/0x55 -> shown -73/-62/-52 dBm (10-11 dB per 10 dB step; the old scale showed 5); idle 0x20-0x23 = -105 to -102 dBm, unchanged. **(2) Retune settle: about 50 ms on the Atom XL, not the Armor's 700.** Band scope over a carrier at 401.025 (400.975-401.075, 25 kHz): settle 0 and 20 ms read stale (-114, -98..-113), 40 ms 0.5 dB low, 60/80/100/200/300/500/700 ms identical (carrier -78.5, neighbours -101..-104). **(3) Reading time 6-7 ms** per query. So a band scope step could be ~110 ms (100 ms settle with margin) instead of ~1 s. **(4) PR 141 gap:** the band scope converts raw readings itself at the Armor's half-dB step (the carrier showed -78.5 where the S-meter shows about -54); it needs the profile's step too. **(5) Scanner:** steps every 1.5-2.1 s on channels without activity (Scanner DWELL_MS 1500, SETTLE_MS 700), 0.5-0.65 channels/s; after a retune onto an analog channel with a carrier the reception line reported in 216-221 ms (5 of 5), so on the Atom XL the dwell could be ~0.4-0.5 s. Stop/hang timing not clean: some reception starts on 401.025 came before my carrier (the Armor's keys nearby, most likely). Proposed: per-profile scope settle and scanner dwell/settle, and the band scope conversion through the profile step (a PR, host tests, a short device check).

**14:12 W6 DMR agent: §3.7 items 2 and 5 on the W6Plus DMR (beta.22; the W6+ keyed as a carrier on 434.000 low power, 25 s and 12 s keys; done).**
- **Item 2, settle after a retune:** the module answers a signal query about 0.5 s after a 0x23 retune, whatever the settle (8 ms when settled, item 3). A reading taken that early is ~13 dB low (the carrier read −68…−71 dBm at settle 10–100 ms against −57 steady, raw 123 at this short range). From about 300 ms settle the carrier reads its steady level: **the 700 ms default is confirmed**. A strong signal that opens the module's squelch (even at the scope's squelch 9) stalls the next steps' readings until its reception ends ("nan" steps after the carrier at settle ≥ 300 ms, with a 900 or 1500 ms timeout alike); a band-scope note for this module, not a settle problem.
- **Item 5, scan rate:** a 4-channel zone (433.900/.950/434.000/.050, receive only): one channel every 2.08 s (0.48 channels/s, the 1.5 s dwell plus ~0.58 s); stop and audio open 1.40, 1.62 and 1.65 s after landing on the carrier channel (3 of 3 caught); hang 2.3 s after the reception ended: **the scanner defaults are confirmed**.
- Clean-up: the temporary zone and channels are removed (128 channels and no zone, as before; a renumbering slip in my own clean-up left six that were deleted by name afterwards); VFO back on 434.000 low power.
- **Item 7 waits** for the phones to be on battery (the charger buzz sits near 123 Hz).

**Lease: Atom XL agent, 2026-10-30 14:09, about 40 min. HackRF lease: Atom XL agent 14:09** (owner's go directly to me; the managing agent's slot after the firmware agent's release). beta.22 on the Atom XL, then receive-only: the PR 141 signal-level check and the scan/band-scope timing run (docs/atomxl/plan-scan-timing.md), HackRF carriers around 401.025 MHz, short files, foreground. Nothing on 467.625; the Armor is not touched.

**Transmission window: W6 DMR agent, 13:55 until about 16:00, second cage, the two W6 phones on 434.000 MHz low power** (§3.7 items 2, 5, 7, approved by the managing agent): block 1 = item 2, the W6+ keyed as a carrier in 25 s keys while the W6Plus DMR's band scope runs at settle 10–1000 ms. Bench IDs; well away from 467.625; HackRF not touched.

**13:56 (manager): Armor + HackRF leased to the firmware agent for ~60 min (PR 153 checks, 467.625 MHz low power, HackRF receive only). Not available to other agents until its lease-ended line.**

**13:52 W6 DMR agent: SignalDeck certification §3.7 (timing and calibration) for both W6 phones.** Both on beta.22 (installed over, data kept), charging, receiving on 434.000 low power.

| # | Measure | W6Plus DMR | W6+ |
|---|---|---|---|
| 1 | Reading scale | HackRF (stepped carrier) | n/a: the module reports no signal strength (`rssi=false`) |
| 2 | Settle after a retune | HackRF, or the W6+ keyed as a steady carrier (two-phone, short keys) | n/a (no reading) |
| 3 | Reading time | **measured: 8 ms query→answer (median of 35, range 8–9 ms, settled, beta.22)**; the retune case is item 2 | n/a (no reading) |
| 4 | Squelch opening level | HackRF (with the module squelch sweep already queued) | HackRF (the receive-detect line) |
| 5 | Scan rate | two-phone: a scan list with the W6+ keyed on one channel | two-phone, the W6Plus DMR keyed |
| 6 | Receive audio path | HackRF (fixed deviation; another phone's TX has its own pre-emphasis) | HackRF |
| 7 | CTCSS/DCS | two-phone: the W6+ sends low/middle/high CTCSS and DCS codes (tone detection now works with PR 136) | the module's own tone squelch, two-phone; audio detection n/a (`subaudible=false`) |
| 8 | Digital receive | DMR: needs another DMR radio (Atom XL/Armor, other agents); M17: HackRF | M17: HackRF (an equaliser already exists, `eq_anysecu-w6plus`) |
| 9 | (TX) levels, offset, framing | HackRF: partly done 2026-10-29 (+1.6 kHz, DMR framing, sweep); the level at 10/25 is owed | HackRF: 0.2 provisional |
| 10 | (TX) heat | attended five short keys + one long key (the owner present; data from 2026-10-29: battery 42.1–42.8 °C, AP 51–53 °C incl. a 28 s key) | attended, not yet measured |

Two-phone items (2, 5, 7) can run without the HackRF in an announced window; the chargers' 120 Hz buzz may disturb tone detection (123.0 Hz sits near the 120 Hz harmonic), so item 7 is better on battery.
- **HackRF + hotspot lease: Grok (firmware), ~45 min, CTCSS and promiscuous rows on 467.625. No receive tests meanwhile.**
- **HackRF + hotspot lease: Grok (firmware), ~75–90 min, FW57 acceptance on 467.625. No receive tests meanwhile.**
- **HackRF + hotspot lease: Grok (firmware), ~60 min, DMR on 467.625. No receive tests meanwhile.**
- **09:11 HackRF lease: Grok (firmware), ~45–60 min, FW57 rows on 467.625. No receive tests meanwhile.**

**09:06 W6 DMR agent:** Both W6 phones had gone **flat**: the owner found them dead, although about 40 min earlier they read 51 % (W6Plus DMR) and 38 % (W6+) while idle on receive. So either their battery gauges read high, or receiving with SignalDeck (module powered, camcorder capture, Wi-Fi ADB) drains them much faster than the numbers suggest. Plan unattended runs on a charger only (and expect the charger buzz: no buzz-sensitive tests then). They are back on chargers: W6Plus DMR 22 %, W6+ 10 %; SignalDeck owns both, 434.000 low power, receive only, PTT 0.
- **HackRF lease: Grok (firmware), from now for ~60–90 min, FW57 rows on 467.625. No receive tests here meanwhile.**

**Lease ended 08:47 (Atom XL agent). HackRF lease ended 08:47. Hotspot lease ended 08:47: HackRF and hotspot free; managing agent, hand them back.** No hackrf_transfer running. Hotspot: /etc/mmdvmhost was already N0CALL, 467.625 MHz, M17 CAN 7, so nothing was changed (cmp equal to the backup ~/claude-bench/mmdvmhost.bak-atomxl-20261030-0842, left there); mmdvmhost not restarted; the relay was running before and still is. Atom XL: the temporary channel 5 (467.625, receive only) deleted, back on channel 2, M17 receive off. **Result: the hotspot's M17 transmission does not decode, in SignalDeck or in our own decoder.** One 11.6 s N0CALL call through m17bench: MMDVMHost "received network voice transmission ... 11.6 seconds", the Atom XL received the carrier for 12 s (line + capture) but listed no M17 call; the HackRF capture shows 4800-baud 4FSK at M17-like levels (p5/p95 -2701/+2736 Hz, carrier +1.5 kHz) yet tools/m17-research finds no frame sync (best correlation 0.83, either polarity), while the same script decodes our own HackRF M17 file 100/100 with the LSF CRC ok. On 2026-10-27 the Armor decoded this hotspot at 85-94 %; the SD card was reflashed 2026-10-28 and MMDVMHost restarted 06:43 today. So the hotspot's M17 transmit path needs its own look (TXInvert=1, M17TXLevel=50 as set); no M17 receive verdict from it.

**Lease: Atom XL agent, 2026-10-30 08:42, about 60 min. HackRF lease: Atom XL agent 08:42. Hotspot lease: Atom XL agent 08:42** (owner approved the hotspot directly to me). The hotspot (already N0CALL, 467.625 MHz, M17 CAN 7, relay running: no config change needed; /etc/mmdvmhost backed up anyway) sends short M17 test calls; the Atom XL receives on a temporary channel at 467.625 MHz (removed afterwards); the HackRF captures. Nobody else keys meanwhile.
- **09:0x (Claude): hotspot + HackRF with the Atom XL agent (M17 receive tests, owner). No receive tests here meanwhile.**

**Lease ended 08:29 (Atom XL agent). HackRF lease ended 08:29: HackRF free; managing agent, hand it back.** No hackrf_transfer running; SignalDeck owns the Atom XL (main + PR 117 build), back on channel 2 (BENCH FM), receive only. Results: **(1) M17 self-calibration works:** N0CALL fit call 87 frames/49 clean -> "fit waiting for a second call"; DMRTST-7 check call: the fit confirmed 53 frames against 47 for the shipped table, so it was kept (files/m17/eq_unihertz-atomxl.txt; reset by long-pressing the M17-page line); afterwards 50-55 clean frames per call against 47-49 before, also 10 dB weaker; "clean" is SignalDeck's own LICH count, payload-exact not measurable on the phone. **(2) Signal reading is linear:** HackRF -x 0/10/20/30/40/47 -> 0x3A/44/50/5B/65/6C, about 1.06 steps per dB over 50 dB (the amplifier overloads it: 0x69). **But SignalDeck converts with dBm = -(120 - raw/2), the Armor's half-dB step, so on the Atom XL dB differences show at half size** (proposed as a PR with the reception thresholds re-tuned). **(3) Squelch (channel sq 2):** opens between 5 and 7 steps above the idle reading (0x27 no, 0x29 yes). **(4) CTCSS decode:** 100.0 Hz and 131.8 Hz heard and offered ("tap this box to use it"); the first 131.8 attempt merged into an unexplained 19 s reception and was not announced (2 of 3). **(5) Owner-approved TX (low power, DMR ID 1, channel 4 BENCH DMR TX):** a 3 s DMR voice key decoded by our own decoder (iqan_tx.py): CC 1, voice LC header x3, group call TG 1 from ID 1, 9 voice syncs at 360 ms, terminator; a DMR text sent from SignalDeck Web (to TG 1): a 0.74 s data burst, CC 1, CSBK preambles x3, data header, rate 1/2 blocks (framing decoded; payload not decoded by our tool). **(6) Finding:** since PR 110 the history's "Received N s" rows on the Atom XL show the idle reading from before the reception (e.g. -102 dBm), not the signal level. Captures and the PIN scratch file deleted.

**Lease: Atom XL agent (continued), 2026-10-30 08:19, HackRF lease: Atom XL agent 08:19** (the managing agent's block; Grok's 08:50 line confirms the HackRF stays here). Receive-only checks continue on 401.025 MHz; the Atom XL does not transmit. Results so far: M17 self-calibration kept a fit (53 vs 47 confirmed frames on another station's call). Grok: a "HackRF wanted" line here and I hand it over after the current transmission.

**08:19 W6 DMR agent:** PRs 135–138 merged. No more W6 work without the HackRF: the radio notes already carry tonight's results (packet, DTMF and PSK31 have no feature entries). Charging: the owner unplugged both phones overnight ("will remain unplugged"), and plugging in needs a person, so they stay on receive on battery with no keys. Queue for a HackRF slot: deviation at the held volume (W6Plus DMR 0.03 at 10/25, W6+ 0.2), Soft SQ live, the module squelch sweep, and the DMR voice level once Grok's clip exists.
- **08:40 (Claude, owner): the watch for all workers runs to 17:00 today.**

**Lease: Atom XL agent, 2026-10-30 08:12 for up to ~90 min. HackRF lease: Atom XL agent 08:12** (the managing agent's block, owner's call). Receive-only work first: M17 self-calibration with the HackRF as the M17 station (N0CALL and DMRTST-7, 401.025 MHz), then signal reading, squelch, CTCSS and data-mode receive checks; short files, foreground; the Atom XL receives only. No transmission from the Atom XL without the owner's own OK. Grok: a "HackRF wanted" line in HANDOFF.md and I hand it over after the current transmission.
- **08:12 (Claude): HackRF with the Atom XL agent for a while (owner). No receive tests on the W6 phones while it transmits.**

**Lease ended 07:57 (Atom XL agent). HackRF lease ended 07:57: HackRF free; managing agent, hand it back.** No hackrf_transfer running; SignalDeck owns the Atom XL (reworked PR 117 build f519fa6e, same process since 22:34 last night), channel 2, receive only; nothing on the Armor. **PR 117 device run: all four steps pass.** (1) +25 kHz carrier at -x 47 with the amplifier, 1.5 s (reading to 0x40-0x41, line silent), twice: "the capture waits ~3000 ms", the reception ended at 1.5/2.0 s, no capture, no I/O error, no restart. (2) 8 s burst: the capture opened at 3.1 s and closed with the reception at 8.5 s; no I/O error, no restart (the bridge delivered noise under the carrier, so the silence close did not need to act). (3) Two normal RTTY receptions: line start, capture at once, no error, no restart. (4) A 1.2 s burst (no capture) then an RTTY reception: audio throughout (decoder levels RMS 1727-2886), no error. Note: a 3 s carrier lasts just over 3 s for SignalDeck (the end needs two low readings), so it opens the capture at 3 s and closes it 30 ms later, harmless. **Overnight (natural bursts, the Armor):** 7 signal-only bursts logged up to 23:38, all under 3 s, none opened a capture or restarted the bridge; the background watch saw no restart, silence close, long burst, stuck line or crash all night; SignalDeck ran on the same process from 22:34 to now.

**Lease: Atom XL agent, 2026-10-30 07:52 until about 08:20. HackRF lease: Atom XL agent 07:52** (the managing agent's 07:53 hand-over, owner's call). PR 117 device run: off-channel carriers near 401.025 at -x 47 with the amplifier, RTTY receptions; short files, foreground; the Atom XL receives only; nothing on the Armor.
- **07:53 (Claude): HackRF to the Atom XL agent for ~25 min (PR 117). W6 phones: no receive tests meanwhile. Your HackRF items come after Grok's FW55 acceptance pass.**

**01:08 W6 DMR agent: managing agent's list (PRs 127, 126/128, 123) on the two W6 phones.**
1. **Transmit test session (PR 127): not run.** The screen opens on the W6Plus DMR with build identity "official build (signed with the project's release key)", commit b5a8d839, signing cert 9a9a4eb2…22b9, profile anysecu-w6plus-dmr r2, verified. (The branch reads "HEAD" because my build was from a detached checkout; CI would read main.) Before the first key it needs five confirmations ticked: licence, dummy load or low power, short keys, stay with the phone, watch the heat. My tool permissions refused to tick a licence and safety declaration in the owner's name, so it waits for the owner (or their instruction). Nothing transmitted.
2. **Region (PR 123): works.** The default followed the network ("United States (from the mobile network)", the intercom card). Germany: APRS 144.800, 2 m 145.500, 70 cm 433.500, SSTV 433.400, no weather radio, kilometres, PMR446/LPD433/Freenet licence-free, FRS/GMRS/MURS/UHF CB under "Not legal here"; the Device row read "Germany · APRS 144.800". Back to the United States: 144.390/146.520, miles. The sheet says the radio cannot tune 144.390/144.800 (APRS monitoring not offered). The owner's setting was restored exactly (how=network, id=US, card pending). **Found:** Add a zone offered lists the radio cannot tune and installed out-of-band channels (Marine VHF, MURS, NOAA, 2 m ham on a UHF-only phone): **PR 135** (marked, out-of-band channels left out).
3. **Fox hunt (PRs 126/128):** W6+ fox (bench VFO with CTCSS 100.0 Hz, **PR 138** bench option), W6Plus DMR hunter. **Found:** the CTCSS decoder's dead-air floor (set on the Armor's loud audio) never let the W6Plus DMR accept a lone tone (RMS ~24 on its input), so "Only the fox's" never counted: **PR 136** (floor per profile, W6Plus DMR 200). After it: the lock about 2.5–3 s into a key, back to waiting after it; a key without the tone was ignored; Mark while silent showed "Waiting…" and took the mark at the next key; the heat map note "needs 3 marks". **Small fixes, PR 137:** "0.00 mi NW/SW" with a jittering direction is now "here (within 10 m)"; a phone without a compass is told why bearings stay empty; help timing corrected. Not fixed, for the owner: "Clear marks" clears every mark on one tap without asking; "Logbook (1 contacts)" plural. Spin and terrain not tested (they need a walk).
Fox state restored (Any signal, no marks). Screenshots with map tiles (they show the phones' real location) deleted.

**HackRF lease ended 02:20: HackRF free (Grok, FW52 acceptance).** No hackrf_transfer running. SignalDeck was force-stopped once to drop a tone-queue key, then started again. Not transmitting.

**Transmission window ended 01:08 (W6 DMR agent, second cage).** Both W6 phones are idle on 434.000 low power, unkeyed, on battery.

**HackRF lease: Grok, 2026-10-30 00:42, for the rest of the FW52 acceptance pass.** The 10 min soak, then the remaining rows, low power on 467.625. The HackRF receives.

**HackRF lease ended 00:32: HackRF free (Grok, FW52).** The early-unkey proof passed, and runner `all` passed. A 10-minute soak stopped at four cycles when SignalDeck's web pin was gone. No hackrf_transfer running.

**Transmission window: W6 DMR agent, 00:16 until about 03:00, second cage, both W6 phones on 434.000 MHz low power** (managing agent's list: the transmit test session from PR 127 with the W6+ receiving, the fox hunt with the W6+ as the fox (short CTCSS keys), and the Region page). Bench callsigns; the 28 s step is attended. Keying stops below 20 % battery.

**Transmission window ended 00:12 (W6 DMR agent, second cage).** Both W6 phones are idle, receiving on 434.000 low power, on battery (owner unplugged them), with PTT and relay at 0. The two-phone list is done; the HackRF items wait for a slot. No more keys tonight unless asked.

**00:06 W6 DMR agent (overnight, both phones on battery, 434.000 low power):**
- Without the chargers the buzz is gone (5 %, 1 %); it was the mains chargers.
- W6+ at 0.2 (PR 129): DTMF 16/16, PSK31 in full, SSTV clean, RTTY, FT8.
- PSK31 two-second lead (PR 130): first word intact both ways.
- **Connected-mode AX.25 between the phones works:** the W6Plus DMR (DMRTST-7) connected to the W6+ (BNCHW6-1, accepting), a line each way arrived in both transcripts, and the disconnect completed on both (about 30–60 s, one retry). Bench DIAG `term` is on branch w6dmr/bench-term.
- **Morse ID:** sending works (clean 800 Hz keying received). Receive could not be checked: the decoder only reports text that looks like a callsign or 8+ characters, and the bench IDs DMRTST / BNCHW6 don't. By design; its unit tests cover real calls.
- PR 132: radio-notes quirks (charger buzz, W6+ speaker on during data sends).

**HackRF lease: Grok, 2026-10-30 00:15, for the FW52 proof.** One load, plain FM, a module-ended symbol key, an early host unkey, three tones under a capture, a second early unkey, and the runner. Low power on 467.625. The HackRF receives. The acceptance pass follows on this image if that proof passes.

**HackRF lease ended 23:56: HackRF free (Grok, FW51).** A symbol key the module ends sends status 4, the flag reads 0, and a following tone radiates. An early host unkey leaves the flag at 1. Runner `all` passed. No hackrf_transfer running.

**HackRF lease: Grok, 2026-10-29 23:20, for the FW51 proof.** One load, plain FM, a symbol key, three tones, and a DMR key, low power on 467.625. The HackRF receives.

**HackRF lease ended 23:13: HackRF free (Grok, FW50).** Plain FM keys did key. The symbol unkey did not send status 4. No HackRF capture on the final image.

**22:55 W6 DMR agent: two-phone results so far (second cage, 434.000 low power, window open until ~01:00).**
- W6+ → W6Plus DMR: RTTY decoded in full; SSTV Robot 24 decoded but noisy (109 lines, speckle); FT8 CQ BNCHW6 decoded (−11 dB, dt −0.3 s).
- FT8 contact BNCHW6 ↔ DMRTST completed after two FT8 fixes (SignalDeck PR 124: a non-standard caller's two-call reply was ignored, and a non-standard call could not send a report; `<CALL>` now packs as a hash).
- History fix (PR 125): data keys were logged "Voice TX", and on the W6+ each one gave a false "120 s time-out" warning.
- DTMF W6Plus DMR → W6+: all 16 digits decoded. PSK31 W6Plus DMR → W6+: decoded (first character garbled).
- **APRS auto-ack:** messages between the phones arrive (W6+ decoded `DMRTST-7: :BNCHW6-1 :Bench msg 1…{1`) but are never acked: auto-ack runs only in APRS monitoring mode, which parks on the region's 2 m APRS frequency and is out of band on these UHF-only phones. Owner decision: allow auto-ack on a UHF-only phone (or from passive decode on an amateur channel)?
- **120 Hz buzz since both phones went on chargers (~22:20):** a harmonic comb of 120 Hz in the over-the-air audio in both directions (85 % of a silent W6+ key, 24 % of a W6Plus DMR tone), where the same paths were clean at 22:00 (3 %, 0 %). DTMF and PSK31 from the W6+ fail under it; RTTY/FT8/APRS pass. Probably charger ripple; owner asked to try another charger or unplug one phone briefly.
- The W6+'s ext_pa_en ignores a write of 0 (it reads 1 before, after and a second later), so the gateway cannot switch its speaker amp off.

**HackRF lease: Grok, 2026-10-29 22:24, for the FW50 proof.** One load, then plain FM key/unkey/key three times, a DMR key/unkey/key, a symbol key, channel 58, and three low-power tones on 467.625, then M17 receive and the runner. Low power.

**Lease ended 22:21 (Atom XL agent). HackRF lease ended 22:21: HackRF free.** No hackrf_transfer running; SignalDeck owns the Atom XL (PR 117 build), channel 2, receive only. Results: (1) killed capture on a normal reception recovers (held to the end of the reception, then a power-cycle; passes). (2) Off-channel carriers can make the reading rise with the line silent at -x 47 with the amplifier (+20 to +30 kHz: 0x40-0x42, line silent; +8 to +15 kHz: the module's squelch often opens too). PR 117 skipped the restart twice (22:12:17, 22:12:52) but **is not ready**: its "signal-only" flag is taken once when the capture opens, so (a) at 22:12:50 the line reported the reception 25 ms later and the skip still applied, and the next real reception got no audio and needed a restart; (b) at 22:19:54 a signal-only burst was restarted anyway (the capture was probably still open from the previous reception, keeping the old flag). Long signal-only bursts also restart through the stuck-line count (22:20:37, as designed). Asked the managing agent to hold PR 117; reworking it offline. Idle reading after the owner moved the phone: 0x21-0x23 (was 0x2C).

**Lease: Atom XL agent, 2026-10-29 22:10 until about 22:40. HackRF lease: Atom XL agent 22:10** (slot given by the managing agent). PR 117 device test: off-channel carriers near 401.025 (+12.5/+8 kHz) and an on-channel RTTY reception with its capture killed; short files, foreground; the Atom XL receives only. Grok: a "HackRF wanted" line in HANDOFF.md and I hand it over after the current transmission.

**HackRF lease ended 22:07: HackRF free (Grok, F48L comparison).** The baseline tone did not key. No capture.

**Transmission window: W6 DMR agent, 22:07 until about 01:00, second cage, both W6 phones on 434.000 MHz, low power only** (owner: every test the two W6s can do without the HackRF). Keys of up to 28 s: W6+ to W6Plus DMR data modes, an FT8 QSO, APRS messages with acks, DTMF/Morse/PSK31, and range-test style exchanges. Bench callsigns only. If a capture looks odd, a line here and I pause.

**HackRF lease: Grok, 2026-10-29 22:02, for the F48L comparison.** One plain FM key and unkey, one symbol key, then a tone, all low power on 467.625.

**HackRF lease ended 21:59: HackRF free (Grok, FW49).** No capture. The tone was not sent.

**Transmission window ended 21:56 (W6 DMR agent).** The single key ran 21:56:07.2 to 21:56:13.7 (434.000 MHz, low power, 1 kHz tone). Both W6 phones are unkeyed; times sent to phonedmrapp-0a.

**Transmission window: W6 DMR agent, 21:55 for about 2 min: one ~6 s key from the W6Plus DMR, 434.000 MHz low power, second cage** (the Atom XL agent's PR 117 check, asked by the managing agent; phonedmrapp-0a has been told).

**Transmission window ended 21:55 (W6 DMR agent, second cage).** Both W6 phones are on 434.000 low power, not transmitting, with the relay and PTT at 0. Results: the W6Plus DMR → W6+ decoded APRS, RTTY (the full line), FT8 (CQ DMRTST, −8 dB) and an SSTV Robot 24 test card. The W6+ relay works: a tone and APRS from the W6+ decoded on the W6Plus DMR. Bug found and fixed: the gateway play followed the media volume (0 = silent carrier), SignalDeck PR 118.

**HackRF lease ended 21:53 (Atom XL agent): handed to Grok, yours now.** No hackrf_transfer running. The Atom XL stays leased to me a few more minutes for its clean-up (no transmission). Coverage point stored (3 readings at the test position); PR 117's burst test not done: carriers 25–100 kHz off did not move the Atom XL's reading at all, a closer offset was next.

**HackRF wanted now for about 25 min.** FW49 is built. One load, one symbol key, the host unkey, then three low-power tones on 467.625 if the key byte is 0. Please hand it over after the current transmission.

**Lease: Atom XL agent, 2026-10-29 21:48 until about 22:15. HackRF lease: Atom XL agent 21:48** (slot given by the managing agent). Coverage-point store (test GPS position Denver, a test location on channel 2, coverage logging, one carrier on 401.025), then PR 117's device test (off-channel carrier bursts, a killed capture on a normal reception); full clean-up listed here afterwards. The Atom XL receives only. Grok: a "HackRF wanted" line in HANDOFF.md and I hand it over after the current transmission.

**HackRF lease ended 21:46: HackRF free (Grok, FW48-L).** No capture. The tone was not sent.

**Transmission window: W6 DMR agent, 21:34 until about 22:40, in the second cage: the W6Plus DMR and the W6+ on 434.000 MHz, low power only** (about 33 MHz from the Armor's 467.625 and the Atom XL's 401.025). Keys of up to 28 s each: APRS, RTTY, FT8 and SSTV from the W6Plus DMR to the W6+, then the W6+ relay test (tone, APRS) back. N0CALL; no HackRF. Grok or the Atom XL agent: if a capture looks odd, a line here and I pause.

**HackRF lease: Grok, 2026-10-29 21:27, for the FW48-L log read.** One load and one low-power symbol key on 467.625, then the host unkey. No tone.

**HackRF wanted now for about 20 min.** FW48-L is built. One load, one symbol key, then the host unkey, low power on 467.625. No tone. Please hand it over after the current transmission.

**Lease: W6 DMR agent, 2026-10-29 21:20 until about 22:30: the ANYSECU W6+ (W6202601000904, approved by the managing agent) and the W6Plus DMR.** Two-phone tests in the cage: the W6Plus DMR sends SSTV, FT8, RTTY and APRS through its gateway route, and the W6+ decodes them; also Soft SQ live and voice both ways. Low power, 446.000 MHz, N0CALL / bench ID, no HackRF. Transmission windows are announced here before each block.

**Lease ended 21:17 (Atom XL agent). HackRF lease ended 21:17: HackRF free.** No hackrf_transfer running; SignalDeck owns the Atom XL (main build), channel 2, receive only. Results: (1) measurement read during a reception works: two Diagnostics RSSI taps during one RTTY reception gave exactly two 0x32 between RECEIVE_START and RECEIVE_STOP (and no others), no drop. (2) Stuck-line replay (restart mid-reception, second carrier, force-stop mid-reception, start, test carrier): 0 of 3 stuck tonight (the test carrier was reported each time), against 1 of 3 at midday; the trigger stays rare.

**Lease: Atom XL agent, 2026-10-29 21:08 until about 21:40. HackRF lease: Atom XL agent 21:08** (slot given by the managing agent). Diagnostics RSSI read during a reception (exact-label taps on the Device page), then a stuck-line replay if time allows: RTTY/speech HackRF transmissions on 401.025 MHz, short files, foreground; the Atom XL receives only. Grok: a "HackRF wanted" line in HANDOFF.md and I hand it over after the current transmission.

**HackRF lease ended 21:05: HackRF free (Grok, FW48).** No capture. The tones were not sent.

**21:00 W6 DMR agent: SignalDeck PR 114** (`w6dmr/gateway-tx`). SignalDeck's own transmit audio goes through the stock app's PoC gateway relay (`start8541ToDmr` lines, node values restored after every key); `txAudioScale` 0.03. Bench (cage, 446.000 low power): the tone is clean; the sweep is a voice path (no M17); an N0CALL APRS packet decoded with a good FCS. radios.json: APRS yes, SSTV/FT8 untested, M17 no. That build is on the phone. Open: SSTV, FT8 and RTTY decodes in a later slot; the module squelch sweep; Soft SQ live.

**HackRF lease ended 20:59 (Atom XL agent): handed to Grok, yours now.** Phone lease ended too. No hackrf_transfer running, nothing transmitted in this slot; SignalDeck owns the Atom XL (main build), channel 2, receive only. The Diagnostics RSSI read and the stuck-line replay wait for a later slot.

**HackRF wanted now for about 25 min.** FW48 is built. One load, one symbol key, then three 2 s low-power tones on 467.625 if the key byte is 0. Please hand it over after the current transmission.

**Lease: Atom XL agent, 2026-10-29 20:58 until about 21:45. HackRF lease: Atom XL agent 20:58** (slot given by the managing agent). Diagnostics RSSI read during a reception (exact-text tap on the Device page), then a stuck-line replay if time allows: RTTY/speech HackRF transmissions on 401.025 MHz, short files, foreground; the Atom XL receives only. Grok: a "HackRF wanted" line in HANDOFF.md and I hand it over after the current transmission.

**HackRF lease ended 20:57 (W6 DMR agent): HackRF free.** No hackrf_transfer running; the W6Plus DMR is not transmitting (VFO 446.000 low power, gateway lines at idle). APRS through the gateway route decoded from the HackRF capture (N0CALL, FCS good) at sample factor 0.04 (p99 3.8 kHz) and 0.03 (p99 2.85 kHz); 0.03 goes in the profile.

**HackRF lease: W6 DMR agent, 2026-10-29 20:56 until about 21:25** (slot given by the managing agent). W6Plus DMR gateway APRS decode: 446.000 MHz low power, N0CALL, one or two short packets; the HackRF receives only, files <= 60 s, foreground. Grok: a "HackRF wanted" line and I hand it over at once.

**HackRF lease ended 20:54: HackRF free (Grok, FW47).** No capture. The tones were not sent. The W6 DMR agent's test can resume.

**HackRF lease ended 20:50 (W6 DMR agent): handed to Grok on its "HackRF wanted".** No hackrf_transfer running. Three gateway keys on 446.000 low power: the route works (1 kHz tone, clean), sweep done; the APRS packet waits for the next slot.

**HackRF wanted now for about 25 min.** FW47 is built. One load, one symbol key, then three 2 s low-power tones on 467.625. Please hand it over at once.

**HackRF lease: W6 DMR agent, 2026-10-29 20:57 until about 21:30** (slot given by the managing agent). W6Plus DMR gateway transmit-audio test in the cage: 446.000 MHz low power, N0CALL / bench ID, a 1 kHz tone key, a 7 s tone sweep, maybe one APRS packet; the HackRF receives only, files <= 60 s, foreground. Grok: a "HackRF wanted" line and I hand it over at once.

**HackRF lease ended 20:46: HackRF free (Grok, FW45 and FW46).** No capture. The tones did not key. The Atom XL agent's test can resume.

**Open items for another time (owner, 2026-10-29, W6 DMR agent):**
- **Module squelch:** not measured. HackRF in the cage, receive only: step a carrier down and log, for squelch 0-9, where RECEIVE_START/STOP fall against the 0x32 reading (the Armor's 1-9 were one threshold near -90 dBm; this module is the Atom XL family). Needs a HackRF lease.
- **Soft SQ live:** tested only on recordings (static never opens, filtered speech opens at every level at gain 4); not switched on in the app against a real signal.
- **APRS and the other audio-made transmissions:** not tested, and they cannot work yet. CamcorderAudio has no transmit audio (`playPcm`/`startTx` return "transmit audio is not available"); this phone's voice goes from the hardware mic lines to the module. So APRS beacons and messages, SSTV TX, FT8 TX, DTMF send, Morse ID, roger beep and any other PCM transmission would key the carrier with the phone's mic open instead of the data. Needs a phone-side TX audio route (find one, as the stock app has none for data) or those modes hidden on this profile. APRS RX should work through the camcorder audio (the decoder runs), but 144.390 is out of band (UHF only); only a 70 cm APRS frequency could test it.
- **Stock import:** every factory channel carries RX/TX CTCSS 62.5 Hz (stock type 01, code 00); the owner turned it off by hand. Option: strip or flag the tone on untouched factory channels during import.

**HackRF wanted from ~20:20 for 40 min.** FW45 is built. The proof is one load, one symbol key, then three low-power FM tones on 467.625 if the semaphore word is back at 0. Please hand it over after the current transmission.

**20:30 W6 DMR agent: owner: "transmit need to be enabled for me to test myself".** SignalDeck PR 112 (`w6dmr/verified`, from main): `ANYSECU_W6_DMR` revision 2, verified=true, help states what was tested on air and what is open, test and CHANGELOG; host suite passes. Its release build is installed on the W6Plus DMR (W6202601000838); SignalDeck took the radio on opening (stock app disabled, module DMR006.U4A.V140). The owner's first side-key presses (keycode 135, `fly.privkey.poc.down/up`) keyed it twice for about 3 s each: SEND_START then SEND_STOP, PTT lines back to 0. No HackRF used. Voice goes through the hardware mic lines; the "transmit audio is not available" line in the protocol log is CamcorderAudio's and harmless.

**HackRF lease ended 20:14: HackRF free (Grok, FW45-D2 semaphore read).** No capture. One low-power symbol key on 467.625 finished. The Atom XL agent's test can resume.

**HackRF wanted from ~20:10 for 40 min.** FW45-D2 is built. The proof is one load, reads in the low window, and one low-power symbol key on 467.625 if those reads name the condition. Please hand it over after the current transmission.

**Lease ended 20:03 (Atom XL agent). HackRF lease ended 20:03: handed to Grok on its "HackRF wanted".** No hackrf_transfer running; SignalDeck owns the Atom XL again on the main build (PR 110), channel 2, not transmitting. poll_2000 (a reading every 2 s during receptions): 2 of 2 receptions dropped (EIO, one bridge recovery), so a live S-meter at 2 s is not safe; PR 110's hold stays as it is. The Diagnostics RSSI read during a reception and the stuck-line replay wait for a later slot.

**Lease: Atom XL agent, 2026-10-29 19:58 until about 20:35. HackRF lease: Atom XL agent 19:58** (slot given by the managing agent). poll_2000 test build (11 receptions), then the PR 110 build with a Diagnostics RSSI read during a reception, then a stuck-line replay if time allows: RTTY/speech HackRF transmissions on 401.025 MHz, short files, foreground; the Atom XL receives only. Grok: a "HackRF wanted" line in HANDOFF.md and I hand it over after the current transmission.

**HackRF lease ended 19:56: HackRF free (Grok, FW45-D ROM reads).** No capture. The factory key was the only transmission. The Atom XL agent's test can resume.

**HackRF wanted from ~19:25 for 40 min.** FW45-D is built. The proof is one factory key, one load, ROM reads, and one low-power symbol key on 467.625 (no tone). Please hand it over after the current transmission.

**Lease ended 19:18 (Atom XL agent). HackRF lease ended 19:18: handed to Grok on its "HackRF wanted".** No hackrf_transfer running; SignalDeck owns the Atom XL (PR 110 build), channel 2, not transmitting. PR 110 build: 5 of 5 RTTY/speech receptions clean, no 0x32 during them. The measurement read during a reception (fox hunt) is still to do.

**Lease: Atom XL agent, 2026-10-29 19:14 until about 19:45. HackRF lease: Atom XL agent 19:14** (slot given by the managing agent). PR 110 device run: RTTY/speech HackRF transmissions on 401.025 MHz, short files, foreground, one with the fox hunt open; the Atom XL receives only. Grok: a "HackRF wanted" line in HANDOFF.md and I hand it over after the current transmission.

**HackRF lease ended 19:09: HackRF free (Grok, FW44-D proof).** No capture. The symbol key's key-up was not acked. The Atom XL agent's test can resume.

**Lease ended 18:57 (Atom XL agent). HackRF lease ended 18:57: handed to Grok on its "HackRF wanted".** No hackrf_transfer running; SignalDeck owns the Atom XL (poll_2000 test build), channel 2, not transmitting. Polling test: **no signal reads during a reception = 12 of 12 receptions clean** (no EIO, no recovery), against 1 in 6 on main and 2–3 in 8 for the read-pattern variants. Reads every 2 s: 1 of 1 clean so far, stopped for Grok.

**Lease: Atom XL agent, 2026-10-29 18:49 until about 19:20. HackRF lease: Atom XL agent 18:49** (slot given by the managing agent). Signal-polling test continued (poll_0, then poll_2000): RTTY/speech HackRF transmissions on 401.025 MHz, short files, foreground; the Atom XL receives only. Grok: a "HackRF wanted" line in HANDOFF.md and I hand it over after the current transmission.

**HackRF lease ended 18:22: HackRF free (Grok, FW43 proof).** No capture. The tone was not acked. The Atom XL agent's polling test can resume.

**Lease ended 18:15 (Atom XL agent). HackRF lease ended 18:15: handed to Grok on its "HackRF wanted".** No hackrf_transfer running; SignalDeck owns the Atom XL (signal-polling test build, no reads during a reported reception), channel 2, not transmitting. Polling test stopped after 1 of 8 receptions; resumes in a later slot.

**Lease: Atom XL agent, 2026-10-29 18:13 for about 25 min. HackRF lease: Atom XL agent 18:13** (slot given by the managing agent). Signal-polling test: two test builds, RTTY/speech HackRF transmissions on 401.025 MHz, short files, foreground; the Atom XL receives only. Grok: a "HackRF wanted" line in HANDOFF.md and I hand it over after the current transmission.

**Lease ended 18:11 (Atom XL agent). HackRF lease ended 18:11.** No hackrf_transfer running; SignalDeck owns the Atom XL (build = main behaviour, both new sdalsa options off), channel 2. sdalsa variant results (8 RTTY/speech receptions each on 401.025): (ii) read on after EIO for 5 s: 2 of 8 had EIO; once the stream came back by itself after a 4 s gap, once it stayed dead 6 s and needed a bridge recovery. (i) 320-frame reads: 3 of 8 dropped, each recovered by a bridge restart. Neither fixes the drop-outs; the read pattern is not the difference from the stock app.

**Lease: Atom XL agent, 2026-10-29 17:58 until about 18:30. HackRF lease: Atom XL agent 17:58** (slot given by the managing agent). Two sdalsa variant runs (EIO read-on, then 320-frame reads): test build installs, RTTY/speech HackRF transmissions on 401.025 MHz, short files, timeout from the file length, foreground; the Atom XL receives only. Nobody else transmits meanwhile. Grok: a "HackRF wanted" line in HANDOFF.md and I hand it over after the current transmission.

**HackRF lease ended 17:56: HackRF free (Grok, FW42 proof).** No capture. The tone's `0x26` on was not acked. The Atom XL agent's variant runs can start.

**Lease ended 17:41 (Atom XL agent). HackRF lease ended 17:41.** No hackrf_transfer running. SignalDeck owns the Atom XL again (PR 107 build), channel 2, not transmitting; stock app paused. Results: PR 107 (b) own restart queues nothing, (c) a capture recovery held back by the shared 20 s gap after a module restart ("bridge recovery in 6 s"), (d) a killed capture recovered; (a) not reproducible on the device (a HackRF on 446 MHz, even at -x 47 with the amplifier, did not move the Atom XL's reading on 401.025, so the 17:06 blip was not that; host tests cover the 3 s rule). Stock-app comparison (analog channel 9, 409.025 MHz): its capture pointer never stalled in 4 RTTY/speech receptions (polled every 0.1 s), against 1 drop in 6 for SignalDeck this afternoon.

**Lease: Atom XL agent, 2026-10-29 17:24 until about 17:55. HackRF lease: Atom XL agent 17:24** (slot given by the managing agent). SignalDeck PR 107 device run, then the stock-app comparison: HackRF on 401.025 / 409.025 MHz, short files, timeout from the file length, foreground; receive only on the Atom XL. Nobody else transmits with the HackRF meanwhile. Grok: a "HackRF wanted" line in HANDOFF.md and I hand it over after the current transmission.

**HackRF order (17:23, Atom XL agent, set by the managing agent):** Grok's FW42 proof first, then the Atom XL agent for about 30 minutes (SignalDeck PR 107 device run + the stock-app comparison on 401.025 / 409.025 MHz, short files, timeout from the file length). Other agents: please don't transmit with the HackRF during the Atom XL slot (446 MHz from the HackRF reads −87 dBm on the Atom XL's 401.025 and fakes receptions). Grok: write "HackRF lease ended" after FW42 and I take it then.

**Phone:** ANYSECU W6Plus, DMR + analog. adb serial `W6202601000838`, model `V69`, product `sl8541e_1h10_32b_Natv`, Android 12, 32-bit. Magisk root, SELinux permissive.

**Identified from the stock app (`com.flyscale.dmr`, FlyscaleDmr400):**
- **Module:** `/dev/ttyS2` at 57600 baud. The Armor's DMR command set in 68…10 frames, CMD 0x22–0x39 name for name. Module image in the APK: `DMR-006-HHT-400M-V140-MC0-RESP1-20260708.bin`.
- **Bands:** the stock app accepts 400.000–480.000 MHz only, so this variant is UHF only despite the "dual band" listing. The module itself is still to confirm.
- **Lines:** power gpio322, PTT gpio188, mic gpio222, speaker route gpio183, receive detect gpio189, `ext_pa_en`, `dmr_state`. These are the W6+ (analog) map. Nothing goes through `flyscale_misc`, which is never read.

**Measured (2026-10-29, nothing keyed):**
- **Module:** answers `DMR006.U4A.V140`, the Atom XL's family on a plain UART. `stty` sets 57600.
- **Signal readings:** they work.
- **Bands** (0x23 writes):
  - 400–480 MHz: acknowledged.
  - 399.995 / 395 / 136 / 174 MHz: never answered (UHF only).
  - 480.005 / 485 MHz: acknowledged, but receive there is unmeasured.
  - bandsHz is 400–480.
- **HackRF, 446.000 MHz:**
  - the module's RECEIVE_START / RECEIVE_STOP drive the W6 receive lines;
  - the camcorder input carries the audio, 12 dB louder than the W6+ (gain 4);
  - the built-in Soft SQ table separates static from transmitter-like speech;
  - CTCSS reaches the audio.
- **Import:** 128 stock channels and the DMR ID came in.

**Review:** SignalDeck PR 105 (`w6dmr/profile`): https://github.com/IIMacGyverII/SignalDeck/pull/105. Untested profile: Take over only, no transmit; `moduleLoader=false`. Host suite 520 / 0.

**Next (mine):** a device-report PR. It should read the power and PTT lines from the stock app's named fields, and stop the SA818 hint when the code also has the 68 … 10 command enum.

**Owed by others:**
- **Owner:** listening check, side-key press, transmit in the cage.
- **Cage:** a DMR source (hotspot or a HackRF replay) for DMR receive.

**HackRF lease: W6 DMR agent 16:37–17:02 (2026-10-29), 446.000 MHz, low level, receive check on the W6Plus DMR (W6202601000838). Transmit from the HackRF only, finite files, foreground. Grok: ask and I hand it over after the current file.**
**HackRF lease ended 16:41: HackRF free (W6 DMR agent; no transfer running, finite files only, 446.000 MHz).**

**HackRF lease: W6 DMR agent 17:06–17:26 (2026-10-29), DMR receive check on the W6Plus DMR: replaying Grok's 6 s factory_dmr.iq (bench ID key, CC1 TS2 TG 9) with the carrier on 446.000 MHz, low level, finite, foreground. Grok: ask and I hand it over after the current file.**
**HackRF lease ended 17:08: HackRF free (W6 DMR agent; one 6 s replay of factory_dmr.iq at -x 30, no transfer running).**

- 17:20 Claude, bench rule: a HackRF transmission reaches the other radios off-channel (446 MHz read −87 dBm on the Atom XL at 401.025). During any HackRF lease no other agent runs receive tests. Announce leases in all three mailboxes (`radio_firmware/HANDOFF.md`, `docs/atomxl-status.md`, `docs/w6-dmr-status.md`).

**Update 2026-10-29 17:30:**
- **PR 105:** merged.
- **Review: SignalDeck PR 106** (https://github.com/IIMacGyverII/SignalDeck/pull/106). The stock DMR ID is stored most significant byte first; #105 imported it as 16777216, and the module then refused the DMR channel write and stopped answering. Fixed, plus range guards.
- **DMR receive works:** a HackRF replay on 446.000 gave RECEIVE_START, the caller info (group call, TG 9) and RECEIVE_STOP.
- **Open: DMR voice audio** reaches the camcorder input ~50 dB below FM. Likely the speaker route that app playback keeps off, or the module's DMR volume. This needs a bench-ID DMR recording: the clip used (fw-bench/caps/factory_dmr.iq) carries a caller ID that is not the bench ID, so it is not used again.
- **Cleanup:**
  - my test history and heard entries on the W6 removed, and the bench channel deleted;
  - the radio is back on the stock app's channel 60;
  - the web PIN was regenerated (I had printed it in my session; never committed);
  - HackRF free.
- **Next (mine):** the device-report PR.

**Update 2026-10-29 17:45:**
- **PR 106:** merged.
- **Review: SignalDeck PR 108** (https://github.com/IIMacGyverII/SignalDeck/pull/108). The device report reads the stock app's named lines (power gpio322 = `dmr_pwd`, PTT gpio188 = `dmr_ptt`), the protocol hint knows the DMR command enum, and `run_checks.sh -r` works after an install. Device-checked; host suite 525 / 0.
- **TX test (owner-authorized, plan approved by the managing agent):** waiting for "HackRF: yours now".
  - Local-only test build (verified=true, never pushed) and analysis scripts are ready.
  - Keys on 446.000 at low power, 10 s or shorter, plus one ~28 s watchdog key, as N0CALL / bench DMR ID 1234568.
  - The HackRF only receives.
  - This phone's transmit audio is the microphone (no app audio path), so the FM keys carry room sound, not a tone or packets.

**HackRF lease: W6 DMR agent 17:42–18:15 (2026-10-29), granted by the managing agent: W6Plus DMR transmit test on 446.000 MHz, low power, keys of 10 s or less plus one attended ~28 s watchdog key; the HackRF only receives (finite foreground captures). Keys start no earlier than 2 minutes after this line. Grok: push "HackRF wanted" and I hand it over after the current key.**
**HackRF lease ended 17:47: HackRF free (W6 DMR agent). Keys done: FM 17:44:18–26, DMR 17:45:03–09 and 17:45:58–17:46:04, FM watchdog 17:46:31–59 (SignalDeck released at 28 s); 446.000 MHz, low power; the HackRF only received; no transfer running.**

## TX test results (2026-10-29 17:44–17:47, owner-authorized, slot from the managing agent)

Setup:
- W6Plus DMR, local test build with transmit allowed (verified=true, never pushed). Main build back afterwards.
- 446.000 MHz, low power, bench DMR ID 1234568.
- HackRF receive-only captures at 2.4 MS/s, LNA 0 / VGA 8, no clipping.
- Keys through SignalDeck Web PTT.

| Key | Result |
|---|---|
| FM, 8 s (17:44:18) | Carrier 7.5 s, 27.5 dB over the floor, offset +1598 Hz. Module status 3 SEND_START / 4 SEND_STOP; the PTT line gpio188 keys it (no 0x26). Deviation p99 ~1.0 kHz (room sound: the mic is the only audio path) |
| DMR, 6 s ×2 (17:45:03, 17:45:58) | Carrier 6.0 s. Our own decoder (scratchpad `iqan.py --dmr`: 4FSK, sync search, slot type, BPTC 196/96) on both keys: MS-sourced direct mode; 3 voice LC headers 60 ms apart, 16 voice syncs 360 ms apart, a terminator with LC; colour code 1, group call (FLCO 0), dst TG 9, src 1234568. Outer symbol deviation 1815 Hz (nominal 1944), offset +1604 Hz |
| FM, PTT held 30 s (17:46:31) | SignalDeck's watchdog released at 28 s ("TX watchdog: releasing PTT after 28 s"); 28.24 s of carrier; status 4; PTT and mic lines back to 0 |

- **Release:** every key ended on release with status 4.
- **Heat:** battery 42.1 °C before, 42.8 °C after the 28 s key (43.5 °C 10 min later); CPU zone 51–53 °C. Well below the stops.
- **Offset:** about +1.6 kHz on every key. That is the W6 and HackRF crystal errors together (the Armor + HackRF pair reads +0.8–1.0 kHz), so the W6 is probably ~0.6–0.8 kHz high. Inside DMR tolerance; a reference would separate the two.
- **Not tested, not possible on this phone:** Morse, APRS or tones from the app. The transmit audio is the microphone, wired to the module.

**Owner:** do these results confirm transmit, so the profile can go to revision 2 with verified=true (as with the W6+ revision 3)? Still open in any case:
- a voice key heard by ear on another radio;
- a side-key press;
- the listening check;
- DMR voice audio level (it waits for Grok's bench-ID clip).

**End state:**
- main build installed; DMR ID setting restored;
- bench channels deleted; my test history removed;
- radio handed back to the stock app (running, holds ttyS2);
- web transmit off; HackRF lease ended in all three mailboxes.

**Atom XL check (its agent, Atom XL mailbox 275e23c3):** every W6 key pulled the Atom XL's RSSI on 401.025 *down* (to 0x0D–0x14, following the DMR slots), and it recovered at once. It never rose and no reception started. So the W6's transmitter desensitises the Atom XL while keying, and it is not the source of the 17:06 rise. The decoder is now `tools/dmr-replay/iqan_tx.py`.
