# Packet & Protocol Layouts

Verify against code before changing. Grep `MainHook.java` and `app/src/main/java/com/pri/prizeinterphone/` for live usage.

## DigitalAudioMessage (`QUERY_DIGITAL_AUDIO_RECEIVE_INFO`)

Hook: `hookDigitalAudioHandler()` in `MainHook.java`.

| Offset | Size | Field | Notes |
|--------|------|-------|-------|
| `body[0]` | 1 byte | callType | `0`=private, `1`=group, `2`=all. Hardware often reports `0`; MON mode may override to `2`. |
| `body[1]` | 1 byte | caller DMR ID low byte | |
| `body[2]` | 1 byte | caller DMR ID mid byte | |
| `body[3]` | 1 byte | caller DMR ID high byte | |
| — | — | **Full caller ID** | **24-bit little-endian:** `(body[3]&0xFF)<<16 \| (body[2]&0xFF)<<8 \| (body[1]&0xFF)` then `& 0xFFFFFF` |

**Common bug:** reading only `body[1..2]` truncates to 16 bits. Example: ID `3199587` (`0x30D243`) displayed as `53859` (`0xD243`).

Destination talkgroup offset in this packet is **unknown** — software-side TG filtering for >32 entries is blocked.

## DigitalMessage (channel programming, 163 bytes)

See `.docs/AI_LOGS_SUMMARY.md` §7 and `docs/V2.0.0_CALL_TYPE_OVERRIDE_FIX.md`.

| Region | Field | Notes |
|--------|-------|-------|
| Bytes 5–7 | Target ID | 24-bit LE (group/private TX target) |
| `txContact` | int | DMR ID or TG ID to transmit to |
| `localId` | int | This radio's DMR ID (from `DmrManager`, not channel DB) |
| `groups[]` | int[32] | RX group list — max 32, firmware ignores for RX anyway |

## Contact / channel DB keys

| Column / field | Meaning |
|----------------|---------|
| `contact_number` | 24-bit DMR ID (1–16777215) |
| `channel_txContact` | Same — stores `contact_number`, **not** `_id` |

## Valid DMR ID range

`1` .. `16777214` (`0xFFFFFF` = broadcast / special). Hook uses `dmrId > 0 && dmrId < 16777215`.