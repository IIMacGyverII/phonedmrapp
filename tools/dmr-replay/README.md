# DMR record / replay bench harness

Capture real DMR transmissions once with the HackRF, then **replay the identical
RF waveform at will** into the radio-under-test. Because an IQ capture reproduces
the whole signal bit-for-bit — 4FSK modulation, color code, source/destination
IDs, talkgroup, and the embedded TDMA slot signalling — the only variable between
a stock-firmware run and a patched-firmware run is the firmware. That makes it the
clean way to prove **promiscuous mode** (hear every CC / ID / TG / slot).

This harness is bench tooling only. It does **not** touch the firmware image.

## Files

| File | What it does |
|------|--------------|
| `env.sh` | Shared config (frequency, sample rate, gains, paths). Override any value as an env var. |
| `dmrcap.sh <name> [secs]` | Record one clip from the HackRF into `library/<name>.iq`. |
| `dmrplay.sh <name> [reps] [gap]` | Replay one clip (one-shot, primer-first, no `-R`). |
| `dmrtest.sh [fw_tag] [name...]` | Replay a whole library and write a timestamped CSV run log for A/B. |
| `iqpeek.py <clip>` | Level check a capture (clipping / silent / OK). |
| `capture-matrix.csv` | The clips to record first and what each one proves. |

## Workflow

```sh
# 1. set a frequency BOTH source and module accept (see below), then capture:
export DMR_FREQ=438000000
./dmrcap.sh cc1_tg9_s1 6          # key the source for the full 6 s
python3 iqpeek.py library/cc1_tg9_s1.iq   # confirm it isn't clipped/silent
# ...repeat per row of capture-matrix.csv...

# 2. A/B the firmware. Load STOCK, run the library, note the radio's response:
./dmrtest.sh STOCK
# load the patched image, run the SAME library:
./dmrtest.sh PROMISC1
# diff the two run logs in logs/ on matching clip names.
```

Score from the radio side: did it un-mute, and what `0x2B` caller-info / Last
Heard did it report? Fill the `note` column of each run log. Set `ADB_MARK=1`
(and `ADB=/path/to/adb`) to drop a `logcat` marker per replay so SignalDeck's
packet log / the stock app's caller-info lines up by timestamp.

## What it proves — and the one limit

| Layer | Source | Confidence |
|-------|--------|-----------|
| **Talkgroup / ID** (MCU `groups[]` filter) | BTECH captures | High — full control of CC/ID/TG from the handheld codeplug. |
| **Color code** (C7000 `LOCAL_CC` `cc_opt`) | BTECH captures (CC1 vs CC2) | High — record one call per CC, replay against each firmware. |
| **Slot** (C7000 `WORK_MODE work_slot_sel`) | **Hotspot** (duplex) | Lower — a simplex handheld can't emit a true aligned 2-slot stream. |

The slot dimension is why the hotspot matters: a BTECH in direct mode effectively
occupies a single timeslot, so it can't give you TS1 and TS2 interleaved. A
**duplex** MMDVM hotspot runs both DMR slots at once; capture its output and you
have a genuine 2-slot waveform to replay. Use the TG 9990 **Parrot/echo** on a
chosen slot for a deterministic, repeatable call to record.

## Hotspot: AURSINC duplex (complete kit, incl. Pi Zero 2 W)

Chosen: the AURSINC "Upgraded MMDVM Duplex Hotspot" **bundled with a Raspberry Pi
Zero 2 W** (ASIN B0GF25BBFN) — a complete, ready-to-run unit, not a bare HAT.

- **Duplex is the right choice.** Two ADF7021 transceivers = both DMR timeslots
  simultaneously, which is exactly what the slot test needs. A simplex board
  would not help here.
- **Self-contained.** It ships assembled on the Zero 2 W (the standard, well-
  supported hotspot host), so there is no HAT seating or UART fiddling, and no
  Pi-5/WPSD-on-Bookworm uncertainty. SSH into the bundled Zero 2 W — the harness
  (`capsrc.sh`, `pi-sendpage.sh`) is identical; only the SSH target changes.
- **Run WPSD** on it (actively maintained Pi-Star fork). A bare-board alternative
  (B0FWC51DHB) on one of your own Pi 5s also works, but needs WPSD-on-Pi-5 and HAT
  setup — the kit avoids both.
- **Confirm before buying:** in stock / ETA; UHF range covers the bench frequency
  (438 MHz is safe, 467.625 likely not); and — if you want the M17 bench source —
  that the MMDVM_HS firmware / WPSD build has **M17** enabled (DMR + POCSAG are
  covered; M17 is flashable but not in the listed modes).
- **Verify duplex actually works** in your WPSD build before relying on the slot
  tests — there are field reports of duplex regressing to simplex-only after some
  software updates. If it misbehaves, the TG and CC layers are still fully testable
  with the BTECH; only the slot layer needs the hotspot.
- **Power/output** is ~10 mW — plenty inside the Faraday cage, and small enough to
  record cleanly at close range.

## Frequency

Pick one frequency that the source, the HackRF, and the DMR module all use:
- The module enforces **400–480 MHz** (UHF) / 136–174 (VHF).
- The AURSINC UHF range is typically ~**420–475 MHz**, happiest **430–440**.
- So **438 MHz** (harness default) satisfies all three. The repo's standing bench
  default is 467.625 MHz; only use it if your hotspot actually tunes there.

Record and replay on the **same HackRF at the same sample rate** so its crystal
error cancels; DMR sync tolerates the small residual.

## Bench hygiene (from past HackRF sessions)

- HackRF **TX goes on the cage bench antenna / attenuator, never the outdoor
  antenna.**
- **Never background `hackrf_transfer -R`** — a killed `-R` hangs the USB driver and
  TX dies silently until a power-cycle. `dmrplay.sh` loops one-shot transfers.
- The **first `-t` after idle is often silent**; `dmrplay.sh` sends a zero-IQ
  primer first.
- Start `DMR_TX_VGA` **low** and raise until the radio opens cleanly — too hot
  overloads its front end and it won't decode.
- Give the RX **~0.7 s** to settle after any retune before scoring.

## Sources

- AURSINC duplex board (modes, duplex, Pi compatibility, ~10 mW, frequency):
  https://www.newegg.com/p/3C6-038N-01AW8 , https://www.desertcart.tw/products/214752873
- WPSD as the Pi 5 / Bookworm-capable Pi-Star fork, and duplex-on-HAT caveats:
  https://dmrhub.ru/tech/en/wpsd , https://buttondown.com/randomwire/archive/assembling-a-dmr-hotspot-from-components/

## Driving the hotspot over SSH (automated capture)

WPSD runs Raspberry Pi OS, so you can SSH into the Pi and key transmissions from
the bench host — no hand-keying. `capsrc.sh` starts the HackRF capture, waits
~0.6 s, then runs your trigger command on the Pi so the clip holds the whole call:

```sh
export PI_SSH=pi@hotspot
./capsrc.sh pocsag_dapnet_2k5 8 -- <command that sends one page on the Pi>
```

The MMDVM modem does the modulation in hardware, so you supply only the logical
content (CC / IDs / TG / RIC / M17 call) and the RF comes out standards-correct.
That is why this replaces a hand-rolled software IQ modulator for the normal
tests — the hotspot is a spec-correct transmitter you control programmatically.

Per-mode trigger paths (set up on the Pi; confidence varies, confirm on your rig):

| Mode | How to key one transmission over SSH |
|------|--------------------------------------|
| **POCSAG** | Easiest/most controllable. Install a small sender against the Pi's local DAPNET gateway; call it with an arbitrary RIC + text. Deterministic, no external network. |
| **DMR** | Arbitrary TG/ID needs a local master (HBlink / DMRGateway) or a network **Parrot** (TG 9990 echoes your transmission on a known slot). `MMDVMCal` emits DMR test/sync patterns for PHY and CC-lock checks. |
| **M17** | Connect MMDVMHost to a reflector or a local `mrefd`, then key with an M17 CLI client. Good independent source for the SignalDeck EQ + firmware RX route. |

Note: MMDVM is built to bridge RF <-> a network, so fully-local on-demand traffic
needs the matching backend running on the Pi (DAPNET core for POCSAG, HBlink/mrefd
for DMR/M17). All run on the same Pi and are reachable over the one SSH session.

## When would we still want a software IQ generator?

Only for signals the hotspot *won't* emit: deliberately malformed frames (bad CC,
out-of-spec slot alignment) to probe filter edge cases. Normal CC / TG / ID / slot
and M17 / POCSAG are all covered by the real hotspot transmitter above, so a
from-scratch modulator is deferred — and if built, its FEC must be verified by
reproducing a real capture's bitstream before it is trusted.

## Research: can the flat RX path open the whole digital-voice family?

M17 became decodable on this radio with the AT1846S `0x58 = 0xBCFD` bypass (flat
receive baseband) plus a fixed per-phone-model equaliser applied before decode.
YSF/C4FM, P25 Phase 1 and NXDN are 4-level-FSK cousins of DMR/M17, and D-STAR is
GMSK — so the same held-path + equaliser approach may open them too.

The hotspot is one box that sources all of them, so the experiment is cheap:

1. Capture each mode once (`capture-matrix.csv` rows `ysf_* / p25_* / nxdn_* / dstar_*`).
2. Decode offline with **`dsd-fme`** (open; handles DMR/YSF/P25/NXDN/D-STAR). Frame
   headers and IDs are realistic; AMBE/IMBE *voice* needs the proprietary vocoder,
   so score on sync-lock + metadata, not audio.
3. Run each clip three ways: plain audio path, held bypass (`0x58=0xBCFD`), and held
   + the M17 per-model equaliser — same comparison that settled M17.

This is SignalDeck-decoder research, separate from the firmware promiscuous work
(which is DMR-only: CC / slot / TG). FT8/FT4/WSPR/SSTV/APRS/PSK31 are NOT MMDVM
modes — source those with software + HackRF TX (FT8 already works in SignalDeck).
