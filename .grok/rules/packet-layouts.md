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
| 12 | `groups[0..31]` | 32 × int — RX group list (firmware ignores it for RX) |
| 140 | `txContact` | int — DMR ID or TG ID to transmit to |
| 144–150 | `contactType`, `cc`, `inBoundSlot`, `outBoundSlot`, `power`, `encryptSw`, `channelMode` | 1 byte each (order per §3.2) |
| 151 | `encryptKey` | 8 bytes (unchecked `put(String)` — must be exactly 8) |
| 159–162 | `relay`, `interrupt`, `volume`, `band` | 1 byte each |

There is **no** "24-bit target at bytes 5–7" in the outbound packet — that was a misreading. Frame header (`ckSum`, `len`) is big-endian; **all bodies are little-endian**.

## AnalogMessage (cmd 0x23, 19-byte body)

Offsets: 0 `rxFreq`(4) · 4 `txFreq`(4) · 8 `band` · 9 `power` · 10 `sq` · 11 `rxType` · 12 `rxSubCode` · 13 `txType` · 14 `txSubCode` · 15 `pwrSave` · 16 `volume` · 17 `monitor` · 18 `relay` — see `02-…` §3.1. Frequencies are Hz, unscaled; `pwrSave`/`volume`/`monitor` are never copied from `ChannelData` (defaults 2/8/2).

## Contact / channel DB keys

| Column / field | Meaning |
|----------------|---------|
| `contact_number` | 24-bit DMR ID (1–16777215) |
| `channel_txContact` | Same — stores `contact_number`, **not** `_id` |

## Valid DMR ID range

`1` .. `16777214` (`0xFFFFFF` = 16777215 = all-call / broadcast). Hook uses `dmrId > 0 && dmrId < 16777215`. The OEM contact editor caps IDs at 16776415.