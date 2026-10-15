# Packet & Protocol Layouts

Verify against code before changing. Grep `MainHook.java` and `app/src/main/java/com/pri/prizeinterphone/` for live usage.

## DigitalAudioMessage (`QUERY_DIGITAL_AUDIO_RECEIVE_INFO`)

Hook: `hookDigitalAudioHandler()` in `MainHook.java`. Note the OEM's own `DigitalAudioMessageHandler.handle()` / `DigitalAudioMessage.decodeBody()` are **empty** — this layout is the module's reverse-engineering, not OEM code. Voice PCM does not travel in this (or any) UART packet; it arrives via `android.os.PrizeTinyService` → `PCMReceiveManager` (8 kHz stereo 16-bit `AudioTrack`).

| Offset | Size | Field | Notes |
|--------|------|-------|-------|
| `body[0]` | 1 byte | callType | `0`=private, `1`=group, `2`=all. Hardware often reports `0`; MON mode may override to `2`. |
| `body[1]` | 1 byte | caller DMR ID low byte | |
| `body[2]` | 1 byte | caller DMR ID mid byte | |
| `body[3]` | 1 byte | caller DMR ID high byte | |
| — | — | **Full caller ID** | **24-bit little-endian:** `(body[3]&0xFF)<<16 \| (body[2]&0xFF)<<8 \| (body[1]&0xFF)` then `& 0xFFFFFF` |

**Common bug:** reading only `body[1..2]` truncates to 16 bits. Example: ID `3199587` (`0x30D243`) displayed as `53859` (`0xD243`).

Destination talkgroup offset in this packet is **unknown** — software-side TG filtering for >32 entries is blocked.

## DigitalMessage (channel programming, cmd 0x22, 163-byte body, little-endian)

Full offset table: `docs/deep-dive/02-oem-messages-and-handlers.md` §3.2 (re-derived and verified from `message/DigitalMessage.java` `encodeBody`).

| Body offset | Field | Notes |
|--------|-------|-------|
| 0 | `rxFreq` | int, Hz |
| 4 | `txFreq` | int, Hz |
| 8 | `localId` | int — this radio's DMR ID (from `DmrManager`, not channel DB); VFO override sets it here via the `BaseMessage.send()` hook |
| 12 | `groups[0..31]` | 32 × int — RX group list. **The MCU's RX filter (on-air 2026-10-15): a group call is passed iff its TG is here**; `txContact` alone does not admit its TG |
| 140 | `txContact` | int — DMR ID or TG ID to transmit to |
| 144 | `contactType` | 0 private / 1 group / 2 all |
| 145 | `power` | 0 low / 1 high |
| 146 | `cc` | colour code |
| 147 | `inboundSlot` | 0 = TS1, 1 = TS2 |
| 148 | `outboundSlot` | 0 = TS1, 1 = TS2 |
| 149 | `channelMode` | 0 direct / 4 double-slot |
| 150 | `encryptSw` | 1 on / 2 off |
| 151 | `encryptKey` | 8 bytes (unchecked `put(String)` — must be exactly 8 or every later offset shifts) |
| 159 | `pwrSave` | default 1, not copied from `ChannelData` |
| 160 | `volume` | default 8, not copied |
| 161 | `mic` | from pref `pref_person_mic_gan_value` |
| 162 | `relay` | 1 disconnect / 2 normal |

**`DigitalMessage` has no `band` or `interrupt` byte** — `band` (bandwidth) exists only in `AnalogMessage` (offset 8); `interrupt` is a separate command (`0x35`). There is **no** "24-bit target at bytes 5–7" in the outbound packet — that was a misreading. Frame header (`ckSum`, `len`) is big-endian; **all bodies are little-endian**.

## DigitalAudioMessage reply (cmd 0x2B, 9-byte body, little-endian) — caller info

Pushed by the MCU after `RECEIVE_STOP` (also answers the app's 1-byte `fetch=1` query). Verified on-air 2026-10-15 with four calls from a BTECH 6X2 (ID 64067):

| Body offset | Field | Observed |
|--------|-------|-------|
| 0 | `callType` | 0 private, 1 group (2 all) |
| 1 | `callerId` | int LE — `43 FA 00 00` = 64067 (the old "24-bit at 1..3" reading is the same bytes) |
| 5 | `target` | int LE — own ID `A7 05 00 00` = 1447 for the private call; `01/09/63 00 00 00` = TG 1 / 9 / 99 for group calls |

Bodies seen: `00 43FA0000 A7050000`, `01 43FA0000 01000000`, `01 43FA0000 63000000`, `01 43FA0000 09000000`.

## AnalogMessage (cmd 0x23, 19-byte body)

Offsets: 0 `rxFreq`(4) · 4 `txFreq`(4) · 8 `band` · 9 `power` · 10 `sq` · 11 `rxType` · 12 `rxSubCode` · 13 `txType` · 14 `txSubCode` · 15 `pwrSave` · 16 `volume` · 17 `monitor` · 18 `relay` — see `02-…` §3.1. Frequencies are Hz, unscaled; `pwrSave`/`volume`/`monitor` are never copied from `ChannelData` (defaults 2/8/2).

## Contact / channel DB keys

| Column / field | Meaning |
|----------------|---------|
| `contact_number` | 24-bit DMR ID (1–16777215) |
| `channel_txContact` | Same — stores `contact_number`, **not** `_id` |

## Valid DMR ID range

`1` .. `16777214` (`0xFFFFFF` = 16777215 = all-call / broadcast). Hook uses `dmrId > 0 && dmrId < 16777215`. The OEM contact editor caps IDs at 16776415.