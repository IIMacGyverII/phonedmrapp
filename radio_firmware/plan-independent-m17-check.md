# Plan: an independent M17 check for the firmware transmit route (2026-10-24)

**Owner:** IIMacGyverII. **Executes:** Grok Build on the bench, Claude Code for reviews. **Status:** plan; nothing below is done unless marked ✅.

## 1. Why, and what "independent" means

Every M17 decode figure so far (R4b–R4r) comes from `tools/m17-research/m17.py`, the modem we wrote from the specification. A sign, symbol-map, interleaver or randomizer convention error would pass that test and fail every real M17 radio. There is no M17 radio here yet; the owner's friend has one, remote, and an AtomXL is on order (same HR-C7000, not an official M17 radio either). So the reference for now is software that we did not write, and the HackRF is its antenna.

Two code families exist outside this repo: the Mobilinkd family (`m17-cxx-demod`, `m17-mod`; SDRangel's M17 plugins are built on it) and the M17 project's `libm17` (OpenRTX, Module17, the CS7000-M17 firmware). Passing the Mobilinkd decoder is a real independent check of the framing, codes and symbol conventions. The friend's radio later closes the libm17 side on the air.

**Licences.** `m17-cxx-demod` and `m17-mod` are GPL-3.0, `libm17` GPL-2.0-only. They run here as bench tools only. Nothing from either is read for, or ported into, SignalDeck (GPL-3) or the firmware stubs; SignalDeck's M17 encoder stays spec-written. This is the same rule the route list already states for `libm17`.

## 2. Facts that shape the plan (checked 2026-10-24)

| Fact | Consequence |
|---|---|
| SDRangel's M17 demodulator and modulator plugins are **Linux-only** (plugin readme: "This plugin is available only on Linux") | No SDRangel M17 on this Windows machine as installed. Needs WSL2 or a Linux box |
| SDRangel's REST report for the M17 demodulator carries only channel power, sample rates and squelch state; the callsigns, type, sync state, frame and BER data live in the GUI and its status log | SDRangel is the human-visible live view and a scripted **device controller**, not a scripted pass/fail source. The scriptable pass/fail is `m17-demod`'s text output |
| `m17-demod` reads a 48 kHz 16-bit mono **discriminator** stream from stdin and prints the link setup (`-l`: source, destination, type, nonce, CRC) and per-frame diagnostics (`-d`: DCD, EVM, deviation, offset, lock, clock, sample point, Viterbi cost; in BERT mode also BER and bits received); it writes 8 kHz audio to stdout | Our bench already produces the discriminator stream from the HackRF IQ (the `txan.py` / results pipeline). Decoded stream length = audio samples ÷ 320 per 40 ms frame. **BERT mode gives a bit error rate from an independent decoder**, the best quantitative figure we can get without a radio |
| `m17-mod` encodes 8 kHz 16-bit mono audio into M17 baseband (48 kHz 16-bit) or, with `-b`, a bitstream; `-S` sets the source callsign | An independent **encoder**, usable with no RF at all: its output through our decoder checks our decoder; our encoder's output through `m17-demod` checks our encoder |
| WSL is **not installed** here (`wsl --status`); `m17-cxx-demod` also offers a Windows build (VS 2019 + conda-forge codec2/boost/gtest, `win_build.bat`) | Environment choice below, owner action needed for WSL |
| HackRF tools live at `C:\Users\Joshua\tools\hackrf\` (not on PATH); captures are kept under `/tmp/fw1718/caps/*.iq` as int8 IQ at 2.4 MS/s with the signal 240 kHz above centre; the research modem already knows the BERT sync word (`SYNC_BER = 0xDF55`) but has no BERT frame generator | Phase 2 needs a converter and a BERT generator, both small |

## 3. Environment: decided 2026-10-24

**The owner will set up an Ubuntu box inside the Faraday cage with the HackRF on it, when it is time** (two computers are already in the cage). That host is the reference environment for every phase: native USB for the HackRF, `m17-cxx-demod` from apt packages, SDRangel with its M17 plugins, `sdrangelsrv` driven over the LAN through the REST API. Grok Build and Claude Code work it over key-based ssh (no password prompts; the udev rule for the HackRF and sudo for the one apt install prepared by the owner). Until the box exists, the bench stays as it is (HackRF on Windows, captures by `hackrf_transfer`), the kept captures wait, and the firmware work (R4s) goes on; the options below are fallbacks only if the box is delayed.

Fallbacks, in this order:

- **A. WSL2 + Ubuntu.** One admin command (`wsl --install -d Ubuntu`), a **PC** restart (the phone is not touched), then `apt install build-essential cmake git libcodec2-dev libboost-program-options-dev libgtest-dev` and build `m17-cxx-demod` (minutes). Gives `m17-demod`, `m17-mod`, and later SDRangel from the Ubuntu package or the release `.deb` with WSLg for the GUI. The HackRF can be attached to WSL with `usbipd-win` when a live SDRangel view is wanted; the capture path can also stay on Windows and only the decode run in WSL (`wsl m17-demod` reads stdin across the boundary). **Owner action:** run the install command as administrator and restart the PC.
- **B. Native Windows build of `m17-cxx-demod`** via conda-forge if WSL is not wanted. Visual Studio 18 is installed; the upstream recipe names VS 2019 and may need small fixes. No SDRangel M17 this way.
- **C. Any other Linux machine** reached over ssh, for the file-only phases 1 and 2.
- **D. Not suitable:** SDRangel on Windows (no M17 plugin). SDR++'s M17 decoder module on Windows is a visual check only (no API, no text output) and is left as a nice-to-have.

## 4. Phases

### Phase 1 — tools in place (no radio, no RF) — environment A or B

1. Build `m17-cxx-demod`; run its own `make test`. Record versions and commit hashes in `results.md`.
2. **Decoder cross-check:** `m17-mod -S <bench callsign>` on 2 s of 8 kHz audio (a 1 kHz tone is fine), baseband out; resample 48 → 8 kHz and run it through `m17.py`'s receiver. Pass: LSF CRC true, the callsign decodes, stream frame numbers consecutive, Golay error 0. This proves our **decoder** reads Mobilinkd's framing.
3. **Encoder cross-check:** take our modem's baseband for the R4r body (link setup + 3 stream frames + end), render at 48 kHz 16-bit, pipe into `m17-demod -l -d`. Pass: the `-l` line shows our source and destination callsigns with CRC OK, `-d` shows lock, and the audio output length is 3 × 320 samples (three frames). This proves our **encoder** is read by Mobilinkd's decoder, before anything touches the air. Any failure here is a convention error in `m17.py` and is fixed before Phase 2.
4. Add a BERT frame generator to `m17.py` (spec: BERT sync word, PRBS9 payload, 40 ms frames) and a `--bert` option in the table/symbol generators. Cross-check it the same way: our BERT stream into `m17-demod` must report a BER of 0 and a rising bit count.

Deliverables: `tools/m17-research/xcheck/` with the scripts (`iq2disc.py`: int8 IQ → 48 kHz discriminator PCM with the +240 kHz offset and a gain argument; `run_m17demod.sh`: pipe + parse `-l`/`-d`/BER into one JSON line), a note in `tools/m17-research/README.md`, results in `results.md`.

### Phase 2 — the kept captures (no radio)

1. `iq2disc.py` on `/tmp/fw1718/caps/r4r0_key.iq` and the R4k capture, then `m17-demod -l -d`. Calibrate the discriminator gain once so `-d` reports a deviation near 2400 Hz and an offset near the known +1 kHz; keep that gain in the script.
2. Pass: R4r gives the bench callsigns with CRC OK and three frames of audio; R4k gives the callsigns and a frame count that matches ours within the window the runner uses. Report both numbers side by side in `results.md`: "ours N / m17-demod M".
3. If `m17-demod` fails where ours passes, that is the finding this whole plan exists for. Diagnose with `-d`: a steady EVM with no lock points at sync or symbol-map conventions; a lock with a bad CRC at the randomizer, interleaver or puncturing; a sign error shows as "Unlocked" with a mirrored constellation. Fix `m17.py` or the table generator, then re-run Phase 1 step 3 until both agree.

### Phase 3 — every bench key gets the independent number

1. Extend the bench runner: after each key's capture, run `iq2disc.py | m17-demod` and append its JSON next to our decoder's line. One table row per key: tag, our LSF/frames, m17-demod LSF/frames or BER/bits, p99 deviation.
2. **BERT on the air.** With R4s (symbol streaming) use the BERT generator for the quality runs: a 10 s BERT stream per key, low power, 467.625 MHz, the usual stop rules. Pass for the §6 acceptance becomes "BER ≤ 1 × 10⁻³ over ≥ 40 000 bits on three keys" from the independent decoder, next to the "≥ 85 of 90 stream frames" figure from ours. Both are reported; the independent one is the one that counts.
3. Voice stays our decoder plus listening until an M17 radio is on the bench.

### Phase 4 — SDRangel, when a live view or an independent transmitter is wanted (WSL only)

1. Install SDRangel in WSL; attach the HackRF with `usbipd-win`; confirm the M17 plugins load (channel list in the GUI or the API's `/sdrangel/channels` report).
2. **Live receive view** of bench keys: HackRF input at 467.385 MHz, M17 demodulator at +240 kHz, FM deviation 2400, status log on. This is for eyes, not for the runner; the runner keeps Phase 3.
3. **Independent transmitter for the receive side:** the M17 modulator with the HackRF as sink, source/destination callsigns set through the API, voice from a file. This is a **HackRF transmission** and therefore an owner-present session under the standing rules (never from the outdoor antenna; keep the HackRF away from the phone when the phone keys; a dummy burst first). It feeds the receive-side work (R-C, the adaptive equalizer) with a waveform our modem did not make.
4. Device control through the REST API is scriptable end to end (device set, frequency, gains, start/stop, channel settings); only the decode results are not, see §2.

### Phase 5 — the friend's radio, later

What to send: the SignalDeck APK, the firmware image with its tag and SHA-256, the restore image, and a one-page procedure (tune, load, check `0x34`, key a BERT stream and a voice stream on an agreed simplex frequency at low power, record what the radio shows). What to ask back: whether the radio opens on the link setup, the callsigns it displays, whether voice is intelligible, and a phone recording of the audio. The friend's own Armor 26 lets him run the same build on his side, so phone-to-phone voice can be tried at the same time. This phase has no date; it starts when Phase 3 passes on BERT.

## 5. Pass criteria, in one place

| Phase | Pass |
|---|---|
| 1.2 | our decoder reads `m17-mod` output: LSF CRC, callsign, consecutive frames, Golay 0 |
| 1.3 | `m17-demod` reads our baseband: callsigns + CRC OK, lock, 3 frames of audio |
| 1.4 | our BERT stream → `m17-demod` BER 0 |
| 2 | R4r and R4k captures: callsigns + CRC OK in `m17-demod`; frame counts reported side by side |
| 3 | three on-air BERT keys, BER ≤ 1 × 10⁻³ over ≥ 40 000 bits each, from `m17-demod` |

## 6. Rules that do not change

467.625 MHz, low power, HackRF receive only unless the owner is present for a Phase 4 transmit session; the ±5 kHz stop; stubs gated on a host key and silent at boot; `git pull --rebase` before every load; no code from GPL M17 implementations into SignalDeck or the stubs; the phone is never rebooted or uninstalled by the bench. A PC restart for WSL is fine.

## 7. Owner actions

1. Set up the Ubuntu box in the cage with the HackRF (decided 2026-10-24, "when it is time"): key-based ssh for the Windows account the AIs run under, the HackRF udev rule, `hackrf` tools installed; tell the AIs the host name and user.
2. Later: one bench session present for the Phase 4 HackRF transmit tests.
3. Phase 5 when ready: the friend's radio and frequency.

## Update 2026-10-25: a duplex MMDVM hotspot is on order

The owner ordered an AURSINC "Upgraded MMDVM Duplex Hotspot" (Raspberry Pi Zero 2 W, Wi-Fi, Pi-Star/WPSD; the
listing names C4FM/YSF, POCSAG, NXDN, D-Star, P25 and DMR). A duplex hat of this kind is an ADF7021 MMDVM_HS
board. Upstream WPSD no longer includes M17; the community fork does, and the runbook below starts from that image. In the cage it becomes the independent station
the Ubuntu box was meant to be, for everything but raw IQ work:

- **M17 transmit check (the open item):** the hotspot in M17 mode on the bench frequency; SignalDeck's Hold to talk
  on a bench image; the hotspot's MMDVMHost log shows the received source callsign, destination and BER. Pass = our
  callsign and `@ALL` logged with low BER over a 10 s key, three times.
- **M17 receive check:** the hotspot transmits M17 (a reflector echo or a second client) and SignalDeck's live
  receiver lists it once with the right callsigns and ≥ 95 % frames.
- **POCSAG receive check:** the hotspot's DAPNET/POCSAG transmitter pages a test RIC; SignalDeck's held-path POCSAG
  decoder prints the page. This is the independent pager transmitter the FW21 review asked for in the other direction.
- **DMR:** the radio against a real MMDVM DMR hotspot (simplex and the duplex pair), the first check of our DMR
  engine against something that is not the stock app.
- **Not covered:** raw IQ capture, HackRF scripting and the ±5 kHz deviation checks stay on the bench PC.

Setup when it arrives (Grok, one session, no bench keys until the last step): image WPSD, join the cage Wi-Fi, ssh
on; update the hat firmware to a build with M17; set the frequencies to the bench pair inside the cage (any frequency
is allowed in the cage, owner 2026-10-24; the hotspot's own range limits apply); power through a fixed USB supply;
record the hat firmware version, MMDVMHost version and the modes enabled in `results.md`. Bench callsign in the
hotspot, never the owner's, since its logs are quoted in reports.

The image is not current upstream WPSD. The M17 wiki (2026-02-02) records that M17 was removed from MMDVM and from
upstream WPSD in July 2025. The image that still has it is the M17 community fork. The arrival-day steps are below.

## Arrival-day runbook

Host notes only. Nothing here is done until the hotspot is on the bench. No phone and no key while this section
is being written. As of 2026-10-26 05:50 the phone is on USB adb; Wi-Fi adb timed out after the second reboot.
Use whichever serial answers. Do not put a Wi-Fi password, a DAPNET key, or the owner's callsign or DMR ID in
this file or in a report.

### 1. First boot

1. Flash the M17 community fork of WPSD (the June 2025 line that still contains M17), not the current upstream
   image. In Raspberry Pi Imager's OS customization, set the cage Wi-Fi and the country. Do not set a new user.
   Leave SSH available. Do not write the Wi-Fi password into the repo.
2. Power the board from its own USB supply. It must not be powered from the phone.
3. If it does not join the cage Wi-Fi, it opens an access point named `wpsd`. Join that, open the dashboard,
   and point it at the cage Wi-Fi from there. Set the hostname to `bench-hotspot` and change the `pi-star`
   password in the dashboard. Do not copy the password into a log.
4. SSH in as `pi-star`. Confirm the image before any mode work:

```bash
grep -n "^\[M17\]" /etc/mmdvmhost
grep -n "Enable=" /etc/mmdvmhost
```

   If there is no `[M17]` section, this is the upstream image. Stop. M17 checks cannot start on it. DMR and
   POCSAG would still run, and that is not enough for this session.
5. On the dashboard's modem page, flash the hat firmware entry that matches the silkscreen. Do not guess a
   ZUMspot command for a different board. After the reboot, the MMDVMHost log (the file the dashboard links,
   usually `/var/log/pi-star/MMDVM-*.log`) must list M17 among the modem protocols. Record the hat firmware
   version, the MMDVMHost version, and that protocol list. If M17 is missing from the list, stop.
6. Identity, in the dashboard, not in this file: callsign `N0CALL`. Read the phone's DMR ID from SignalDeck's
   Device tab and give the hotspot a different bench ID. Write both numbers only in the session log.
7. Frequencies follow the phone's channels, read first and not assumed:

```text
adb forward tcp:18080 tcp:8080
```

   Then `GET /api/channel?number=2`, `56`, and `4` (login with the pin that is already on the phone; do not
   print it). This morning channel 2 and channel 56 receive 467.625 MHz and channel 4 receives 467.700 MHz.
   Read each transmit frequency too.
   - M17 and the held-path page use channel 56. If its transmit equals its receive, the hotspot is simplex
     on that frequency even though the hat is duplex.
   - DMR uses channel 4. Hotspot transmit = the phone's receive. Hotspot receive = the phone's transmit.
     Use 467.625/467.650 only when a phone channel already has that split.
8. Colour code and slot, for the capture matrix (`tools/dmr-replay/capture-matrix.csv`): CC 1 and slot 1 are
   the baseline. Slot 2 is the row `hs_cc1_ts2`. CC 2 is the row `cc2_tg9_s1`. Read channel 4's colour code,
   slot, and RX group list before the first DMR transmission. The out-of-list row needs one talkgroup that is
   in that list and one that is not. If channel 4 is not that shape, pick or make a channel that is, and put
   the radio back afterwards.

### 2. Independent checks, in this order

Each phone transmission is low power, waits at least 3.5 s after a channel change, stays under 28 s, and stops
on the heat rule (battery over 45 °C, `mtktsAP` or `mtktsbtsmdpa` over 60 °C, or more than 2 °C in 10 s).
The hotspot's own supply is not the phone.

| Check | Do | Proves | Pass |
|---|---|---|---|
| M17, phone to hotspot | Channel 56 (the select turns the live receiver and the voice-filter hold on). `POST /api/ptt` `{"down":true}` for about 10 s, then `{"down":false}`. Three times. | A real M17 modem decodes our voice frames | MMDVMHost log: source `N0CALL`, the channel's destination, BER recorded, three times |
| M17, hotspot to phone | The hotspot transmits M17. A reflector or a second client is that transmission. If the image has no local way to send M17, and the owner has not approved a reflector, write that down and do not invent one | Our live receiver decodes a modem we did not write | `GET /api/m17`: one listing, the hotspot's callsign, at least 95 percent of its frames clean |
| POCSAG, hotspot to phone | Channel 56 still holding the voice filter. Send one page to RIC `1000001`, function 3, a one-line bench text. Use the dashboard's local POCSAG send if it has one. If the only path wants a DAPNET auth key, stop; do not create an account and do not write a key down. Two sends if the modem level can be changed: one nearer 2.5 kHz deviation and one nearer 4.5 kHz, the deviation measured afterwards with the HackRF, because the dashboard sets a level and not a deviation | The held-path decoder against a pager transmitter | SignalDeck shows RIC `1000001`, function 3, and the text. Record the HackRF deviation of each send |
| DMR, phone to hotspot | Channel 4, colour code and slot as read above, a talkgroup the hotspot is listening to. One short key | Our DMR transmit against MMDVM | The log shows the phone's DMR ID, the talkgroup, the slot, and a BER |
| DMR, hotspot to phone | The hotspot transmits on channel 4's receive frequency (its duplex retransmission, or a network echo the owner has approved) | Our DMR receive against MMDVM | The phone's history shows that call on channel 4 |

### 3. Promiscuous rows

Must-confirm 0 comes before any FW26 flag row. It is the stock image, MON on, and the out-of-list talkgroup
(`cc1_tg100_s1` in the capture matrix). `POST /api/monitor` `{"on":true}` sends the stock monitor command.
If the phone passes that talkgroup, the stock monitor already admits an out-of-list group and the flag's group
gate is only the private-call half. Record the history line and the `0x2B` log either way.

Then each hotspot row of the matrix, one configuration at a time. Set the hotspot to that row's colour code,
slot, talkgroup, and call type. For each row:

1. Factory image loaded through SignalDeck's own loader (not `fwload_stock.sh`). `0x34` reads `DMR003.UV4T.V022`. MON on. One transmission. Score: audio or silence, and the `0x2B` body.
2. FW26 loaded back. `0x34` reads `DMR003.FW26.V022`. MON off, so the flag is off. The same hotspot settings, one transmission. Score the same way. The body is 9 bytes and has no colour code or slot.
3. MON on. The log line is `promiscuous on: sr=0 flag=1`. The same transmission again. The history line shows colour code and slot, and the `0x2B` body is 11 bytes. Those two displayed values match the hotspot. Then MON off (`flag=0`) before the next row.

The rows and what they decide:

| Row | Hotspot | Stock, MON on | FW26, flag off | FW26, flag on |
|---|---|---|---|---|
| `cc1_tg9_s1` | CC 1, slot 1, an in-list talkgroup | passes (baseline) | passes | passes, CC 1 slot 1 on the 11-byte body |
| `cc1_tg100_s1` | CC 1, slot 1, a talkgroup not in the list | must-confirm 0 | drops | passes |
| `cc2_tg9_s1` | CC 2, slot 1, the in-list talkgroup | drops if the channel is CC 1 | drops | passes, displayed CC 2 |
| `cc1_priv_self` | CC 1, private call to the phone's own ID | passes | passes | passes |
| `cc1_priv_other` | CC 1, private call to the bench ID, not the phone's | drops | drops | passes |
| `hs_cc1_ts1` | CC 1, slot 1 | slot baseline | slot baseline | displayed slot 1 |
| `hs_cc1_ts2` | CC 1, slot 2, channel still slot 1 | the other slot | the other slot | displayed slot 2 |

Load FW26 again at the end of the table. Do not leave the factory image in the module.

### 4. Self-calibration, the second station

Channel 56, FW26, the hold on. The shipped Armor taps are the "before".

One clean call of at least 20 frames is the fit, stored as pending, not yet the taps in use. The other station
makes the second call, at least 6 dB weaker or plainly a different transmitter: the hotspot for the fit and a
HackRF transmission for the score, or the reverse. The pending taps have to lock on their own, and they have to
yield at least as many clean frames as the taps already in use, on that same recording. Until that is true the
receiver does not change. Record both meter readings and both frame counts.

### 5. End state, and what is written down

Hotspot on its own supply, not transmitting. Phone: SignalDeck owns the radio, `DMR003.FW26.V022`, channel 2,
monitor off, `ownAtBoot` left as it was found. HackRF idle.

`results.md` gets one section: the image name and the proof that `[M17]` was present; hat firmware version,
MMDVMHost version, protocol list; the frequency pair and the channel it matches; the five independent checks
with BER or frame counts; must-confirm 0 as pass or drop; each promiscuous row's three scores and the displayed
colour code and slot; the self-cal before and after counts and the two meter readings; the end state. No
callsign other than `N0CALL`, no DMR ID, no auth key, no place.

