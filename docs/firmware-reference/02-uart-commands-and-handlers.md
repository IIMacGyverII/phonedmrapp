# 02 — UART commands and their firmware handlers (stock DMR003.UV4T.V022)

Part of the Armor 26 Ultra radio-module firmware reference. Module: `DMR003.UV4T.V022`, 378,620 bytes, HR-C7000 SoC
(C-SKY CK803S core), RF IC AT1846S. This chapter covers the **stock** host↔module protocol: the frame, every command
byte known, what the firmware does with each one, and what was measured on the bench. Patched behaviour (FW19–FW55,
command `0x40` and its opcodes) is mentioned only where it explains a stock mechanism; it is not described here.

Written 2026-10-30 from the sources cited in each row. Nothing was loaded, keyed or sent for this chapter. A pass over
the factory image's flat listing (`radio_firmware/fw1_csky_objdump.txt`, regenerated per `docs/grok-deep-dive/11-firmware-fw0-results.md`
§12) and a read of the dispatch table's bytes from `radio_firmware/DMR003.UV4T.V022-ORIGINAL.bin` were done for §3;
facts from that pass are marked **Verified (listing, this chapter)**.

## 0. Conventions

**Evidence labels.** Every fact carries one of:

| Label | Meaning |
|---|---|
| **Verified (bench)** | measured on the Armor 26 Ultra with the cited log/capture |
| **Verified (listing)** | read from the factory image's disassembly in the cited source |
| **Verified (code)** | read from the decompiled OEM app (`app/src/main/java/com/pri/prizeinterphone/`) or SignalDeck's engine |
| **Inferred** | follows from the above but was not observed directly |

Where sources disagree the code or the latest bench wins, and the disagreement is listed in §11.

**Addresses.** Three address spaces appear (`11` §21.0, ch. 19 §22):

| Written as | Meaning | Conversion |
|---|---|---|
| `+0xNNNN` / "file `0xNNNN`" | offset in the image file | — |
| `0x0301A000 + off` | XIP flash address of flash code (file `+0x0`…`+0x39407`) | file = XIP − `0x0301A000` |
| `0x000xxxxx` below `0x50000` | IRAM: code copied from file `+0x39408` to `0x10000…0x31AF3`, then `.bss` `0x31AF4…0x4DAB0` | file = IRAM + `0x29408` for copied code (results.md FW45-D2) |
| `0xFCFF…` / `0xFD01…` | the flat listing's rendering of a far call into IRAM | true target = listed + `0x0301A000` (mod 2³²) |

RAM addresses such as `0x38908` or `0x32457` are IRAM `.bss`, not file content (`11` §21.0).

**Source short names.** `01` = `docs/deep-dive/01-oem-serial-protocol.md`; `02` = `docs/deep-dive/02-oem-messages-and-handlers.md`;
`11` = `docs/grok-deep-dive/11-firmware-fw0-results.md`; ch. 19 = `docs/deep-dive/19-firmware-modification-plan.md`;
`results` = `radio_firmware/results.md`; `reviews` = `radio_firmware/reviews.md`; `symbols` = `radio_firmware/symbols.csv`;
`V076` = `docs/atomxl-v076-firmware-analysis.md` (its Armor column); `PL` = `.grok/rules/packet-layouts.md`;
`RE` = SignalDeck `app/src/main/java/com/macdmr/radio/RadioEngine.java`; `Frame` = SignalDeck `Frame.java`;
CLAUDE.md = the repository root `CLAUDE.md`.

Bench IDs in examples are made up (`1234567`, TG 9); no real radio ID is used.

---

## 1. Physical link

| Fact | Value | Evidence |
|---|---|---|
| Port on the Armor 26 Ultra | `/dev/ttyS0` | Verified (code): `serial/port/SerialPort.java:25` (`01` §1); SignalDeck profile `DeviceProfile.java` line 88 |
| Speed | 57600 baud, 8N1 implied | Verified (code): same lines. toybox `stty` cannot change this UART's speed (CLAUDE.md §11, "Serial line") |
| Opening | the stock app's JNI `libinterphone_serial_port.so`; SignalDeck loads the same library | Verified (code): `01` §1; CLAUDE.md §11 |
| Module side | memory-mapped UART at `0x1409xxxx`: TX polls bit 1 of `base+124`, writes `base+0` (`uart_put` `+0x5EF4`) | Verified (listing): `11` §10.2 |
| Other phones, same protocol | Armor 20WT: `/dev/ttyS1` 57600; Xplore 1: control `ttyS0` 57600 + PCM `ttyS1` 230400; W6 DMR variant: `ttyS2` 57600 | Verified (code): `DeviceProfile.java` lines 104–127; memory `w6-dmr-variant-agent` |
| Power and update lines | `dmr009` power GPIO; update mode = `dmr009` knock with PTT held, then byte `0x31`, then YModem-1K (bootloader, not this protocol) | Verified (bench): CLAUDE.md §1 (loader safety contract), `radio_firmware/plan-loader-safety.md` |

### 1.1 Agold envelope (Atom XL, Armor 3WT) — mention only

On the Agold phones a bridge MCU sits between host and module. Host frames are
`7E 96 69 | route | cmd | rw | len (2, BE) | body | checksum (2, BE) | 81`; route `01` = the DMR module, route `00` =
the bridge; the checksum is the one's-complement 16-bit sum of route…data. **Verified (bench/code)**:
`docs/atomxl/PHASE_A_FINDINGS.md` (raw `0x34` request/reply pair), SignalDeck `AgoldFrames.java` header comment.
The module image on those phones (V076) has no envelope handling and still speaks `68 … 10`; the envelope belongs to the
bridge (**Verified (listing)**: `V076` §3 "Envelope"). The rest of this chapter is the `68 … 10` protocol.

---

## 2. Frame format

```
68 | cmd | rw | sr | ck_hi ck_lo | len_hi len_lo | body[len] | 10
```

| Offset | Field | Host → module | Module → host | Evidence |
|---|---|---|---|---|
| 0 | head | `0x68` | `0x68` | Verified (code+listing): `01` §3; `11` §10 |
| 1 | cmd | command byte | same command byte echoed | Verified: `01` §3; `11` §11.1 |
| 2 | rw | always `1` | `0` in every reply seen | Verified (bench): `11` §15 ("all replies carried `rw=0 sr=0`") |
| 3 | sr | always `1` (`SET`) | `0` success, `1` fail; `2` = checksum error in the OEM constants only (§2.3) | Verified (code): `01` §5 `Const.SRFlag` |
| 4–5 | ck | big-endian | big-endian | Verified (code+listing): `01` §3; `11` §10.1 (`+0x8E5C`) |
| 6–7 | len | body length, big-endian | same | same |
| 8… | body | little-endian multi-byte fields | little-endian | Verified (code): `01` §4 (`ByteBuf` LE) |
| 8+len | tail | `0x10` | `0x10` | Verified |

Total frame = `9 + len`.

### 2.1 Checksum

16-bit one's-complement sum over the **whole** frame including the tail, with bytes 4–5 taken as zero; big-endian
16-bit words; an odd last byte is padded into the high half; carries folded; result `^ 0xFFFF`.

- OEM: `codec/PacketEncoder.java:24-56` (**Verified (code)**, `01` §3).
- Module: compute `+0x7D94`, wrapper `+0x8E5C` writes bytes 4/5 big-endian (**Verified (listing)**, `11` §10.1, §12).
- SignalDeck: `Frame.checksum` (**Verified (code)**).

Worked example (`01` §3): `SET_VOL` vol 8 → `68 2E 01 01 8E BF 00 01 08 10`. Another: status ack `68 36 01 01 95 B7 00 01 01 10`.

### 2.2 Replies and how they are matched

- There are no sequence numbers and no transport acks. A reply is matched to its request **only by the command byte**
  (OEM `MessageDispatcher` keys a `HashMap` on `cmd`; `01` §6). **Verified (code).** Consequence used throughout the
  project: two outstanding requests with the same command byte cannot be told apart (CLAUDE.md §7 pitfall 13, the
  squelch race).
- The module has two reply builders (**Verified (listing, this chapter)**, `+0x8E7C` and `+0x90B0`):

| Builder | Frame | Notes |
|---|---|---|
| `ack_empty` `+0x8E7C` (r0 = cmd, r1 = sr) | `68 cmd 00 sr ck ck 00 00 10` | 9 bytes, built in the shared object at `0x3244C` (offsets 0–8). 27 callers by Ghidra's graph (`11` §12) |
| `reply_build` `+0x90B0` (r0 = cmd, r1, r2 = body, r3 = len) | `68 cmd r1 00 ck ck len body 10` | r1 lands in byte **2** (the rw position) and byte 3 stays 0 from the memset; every caller read passes r1 = 0, so data replies read `rw=0 sr=0`. 400-byte stack buffer |

  `11` §14.2 writes the reply layout as "`68 cmd sr 00 …`"; the listing shows the argument goes to byte 2, i.e. a data
  reply never carries a failure `sr`. A refusal is always an empty `ack_empty` with `sr=1`.
- The host must acknowledge every unsolicited `0x36` status push with `68 36 01 01 … 01 10` (OEM
  `ModuleStatusMessageHandler.sendAck()`; SignalDeck `RE` `onFrame`). The module sends **no reply** to that ack (§4.17).

### 2.3 What the module validates (phone_dispatch `+0xAA3C`)

**Verified (listing, this chapter; matches `11` §14.2 and `V076` §3):**

1. Length `len + 1` (body + tail after the 8 header bytes) is computed from bytes 6–7; a value ≥ 800 returns with no
   reply. So the largest body accepted is 798 bytes.
2. It waits for the remaining bytes (`+0x2B0C`, a pend with a 4000-tick argument; tick length not settled, results
   13:59 "Pass length"). The received total is stored at `0x3244C+0x12`.
3. `buf[0] != 0x68` → `ack_empty(cmd, 1)` (sr = 1).
4. Last byte `!= 0x10` → `ack_empty(cmd, 1)`.
5. `checksum(+0x7D94)` is called over the frame, **but its return value is overwritten by the next instruction**
   (`movi r0, 1` at `+0xAA96`). The Armor image does not reject a bad checksum. (`V076` §3 notes the Atom XL image
   differs here: it answers sr = 2.) **Verified (listing, this chapter); not bench-tested** — every host sends valid
   checksums.
6. Calls IRAM `0x2AF24(1, 1)` (the synthesizer-lock prelude: waits on bits 31 then 30 of `0x44000004`, returns at once
   when byte `0x38874+6` is 1; results FW39 13:45 / 13:59) and then `+0xB07C` (calls IRAM `0x2C984`, "a few stores at
   `0x18000848`", results FW45-D2).
7. `index = (cmd − 0x22) & 0xFF`; `index ≥ 105` (cmd ≥ `0x8B`, or any cmd < `0x22` by wrap-around) returns **with no
   reply**. Otherwise `jmp` through the word table at XIP `0x03052240` = file `+0x38240`.

Unknown commands inside the range point at the shared default `+0xAA54`, which is the dispatcher's own `pop`: **no
reply** (71 of the table's 112 words, results 2026-10-28 "`0x382B8` slot").

### 2.4 The receive task before the dispatcher (`uart_rx_task` `+0x7C48`)

**Verified (listing):** `11` §11.1, §12, §14.1; `symbols`.

| `buf[1]` | Action |
|---|---|
| `0x20`, `0x0F` | discarded, restart |
| `0x21` | `family21_dispatch` `+0x8BE4`: a second command family, sub-command in `buf[2]`, 35 entries through the RAM table `0x030520D8` |
| anything else | `phone_dispatch` `+0xAA3C` (§2.3) |

The module also **emits** `68 21 <sub> <01|FF> …` frames through `family21_emit` `+0x7E94` (subs 1, 2, 3, 4, 16–20, 34;
`11` §14.1). Sub 34 carries the BER scorer's 6-byte score (results R-B reading, "`+0xAD64` is the BER scorer"). The OEM
app has no `0x21` handler and drops them (`01` §6). No `0x21`/`0x20` frame was seen on the wire during a normal boot
and channel queries (**Verified (bench)**, `11` §15). The family is otherwise undecoded (ch. 19 A3, open).

### 2.5 Boot banner and `0xAA`

- After power-on the module prints a non-`0x68` banner: `00 00 BF AA` + GBK text `开机初始化完成` ("start-up
  initialisation complete") + CR LF. SignalDeck's `RE.onRaw` treats `BF AA` as "booted" (**Verified (code)**). The OEM
  parser maps a `BF AA` 17-byte frame to `MODULE_INIT_CMD 0xAA` (`01` §3 parser step 4).
- Banner timing: about 3.2 s after a power cycle (results R3a2 "Factory boot": power cycle 23:28:40.474, banner
  43.631). **Verified (bench).**
- An `0xAA` **request** from the host falls outside the dispatcher's range (`0xAA − 0x22 = 136 ≥ 105`), so it gets no
  reply. **Inferred (listing, this chapter).** The OEM boot chain does list `0xAA` on the wire (`11` §15), but its state
  machine also takes the banner as the `0xAA` event; SignalDeck never sends `0xAA`.

---

## 3. The dispatch table (A2: every case named)

Read from the factory file at `+0x38224…+0x383E3` (112 little-endian words; command `0x22` is the word at `+0x38240`).
The first seven words (`+0x38224…+0x3823C`, pointing into `+0x9E??–+0x9F??`) are below index 0 and are not reached by
`phone_dispatch`; they belong to another switch (**Inferred**). Thunks are 8 bytes, `mov r0, r4; bsr handler; pop`,
except the inline cases. **Verified (listing, this chapter)** for the cmd → thunk → handler column; the role column
cites its source.

| Cmd | OEM name | Thunk | Handler | What the handler does (stock) | Source of role |
|---|---|---|---|---|---|
| `0x22` | SET_DIGITAL_INFO | `+0xABEA` | `+0x9310` | 163-byte digital channel write (§5.1) | `11` §13.1; results 07:58 (pointer `0x03024BEA`) |
| `0x23` | SET_ANALOG_INFO | `+0xABE2` | `+0x99B4` | 19-byte analog / VFO write (§5.2) | `11` §11.4, §14.2 |
| `0x24` | QUERY_DIGITAL_INFO | `+0xABDA` | `+0x9E3C` | reply 163 B from `0x38E4C` | listing; `11` §14.2, §15 |
| `0x25` | QUERY_ANALOG_INFO | `+0xABD2` | `+0x9E4C` | reply 19 B from `0x38C70` | listing; `11` §14.2, §15 |
| `0x26` | SET_LAUNCH_INFO (PTT) | `+0xABCA` | `+0x9264` | key / unkey (§6) | results R3a2 "The flag and the image" |
| `0x27` | QUERY_INIT_STATUS | `+0xABC2` | `+0x9E24` | `ack_empty` with sr = 0 when bit 5 of `0x38908` is set, else 1 | listing (this chapter) |
| `0x28` | SET_ENHANCE_FUNCTION | `+0xABBA` | `+0x9E6C` | waits while busy byte `0x32457` = 1; body[0] must be 1–6; copies 5 bytes to `0x3CE68` | listing (this chapter, first 20 instructions only) |
| `0x29` | SET_ENCRYPT_FUNCTION | `+0xABB2` | `+0x9FB8` | not read (V076 §3: types 0–4 on the Armor) | `V076` §3 |
| `0x2A` | SET_GAIN_MIC | `+0xABAA` | `+0xA1DC` | body < 6 stored at digital image `+0xA1`; ≥ 6 → sr 1 | listing (this chapter) |
| `0x2B` | QUERY_DIGITAL_AUDIO_RECEIVE_INFO | `+0xABA2` | `+0xA808` | 9-byte caller info reply (§4.7) | `11` §20; `symbols` |
| `0x2C` | SEND_SMS | `+0xAB9A` | `+0xA364` | DMR text send (§4.8); not read in full | `V076` §3 |
| `0x2D` | RECEIVE_SMS | `+0xAB92` | `+0xA53C` | pending text fetch | `V076` §3 |
| `0x2E` | SET_VOL | `+0xAB8A` | `+0xA598` | body ≥ 10 → sr 1; else stored at analog `+0x10` and digital `+0xA0`, `+0x61A8(vol)`, sr 0 | listing (this chapter) |
| `0x2F` | SET_LISTEN (monitor) | `+0xAB82` | `+0xA5CC` | body must be 1 or 2 (else sr 1); stored at analog `+0x11`; 2 → `+0x37F4(1)`; 1 → after 200 ms `+0x37F4(0)` | listing (this chapter) |
| `0x30` | SET_SQUELCH | `+0xAB7A` | `+0xA634` | body ≥ 10 → sr 1; else stored at analog `+0xA` and `0x38B5C+0xC`, `+0x30D8`, `+0x37F4(1)`, sr 0; then re-opens if monitor is 1 | listing (this chapter) |
| `0x31` | SET_POWER_SAVE_MODE | `+0xAB72` | `+0xA678` | body must be 1 or 2; stored at analog `+0xF`, digital `+0x9F` | listing (this chapter) |
| `0x32` | QUERY_SIGNAL_STRENGTH | `+0xAB6A` | `+0xA6A8` | 1-byte RSSI reply (§4.10) | results FW29 "How command `0x32` reads the AT1846S" |
| `0x33` | SET_OFFLINE_MODE (relay) | `+0xAB62` | `+0xA6C4` | body must be 1 or 2; stored at analog `+0x12`, digital `+0xA2`, re-applied | listing (this chapter) |
| `0x34` | QUERY_VERSION | `+0xAB5A` | `+0xA7E8` | 17-byte version string reply (§4.11) | `11` §21.4 |
| `0x35` | INTERRUPT_TRANSMIT | `+0xAB52` | `+0x8F18` | body 1/2/3 (else sr 1); 1 / 2 store 1 / 0 at `0x34808+0x11` and `0x3244C+0xA`; 3 = separate path | listing (this chapter) |
| `0x36` | MODULE_PRINT_STATUS_INFO (host ack) | inline `+0xAB3E` | — | clears bit 0, sets bit 1 of `0x38EF0`; **no reply** | listing (this chapter) |
| `0x37` | SET_POLITE_POLICY | `+0xAB36` | `+0x8EB4` | body ≥ 2 → sr 1; 0 → config byte `+0xAE` = 1, 1 → `+0xAE` = 3; copies the 160-byte config back, applies, sr 0 | listing (this chapter) |
| `0x38` | SET_MIX_CHECK_INFO | `+0xAB2E` | `+0x8EA8` | **plain `ack_empty` sr = 1** (not implemented) | listing; `V076` §3 |
| `0x39` | QUERY_MIX_CHECK_INFO | `+0xAB26` | `+0x9E5C` | reply 169 B from `0x38AB0` | `11` §14.2, §15 |
| `0x3A` | SET_SMS_PROTOCOL_TYPE | `+0xAB1E` | `+0xA280` | body 0/1/2 (else sr 1), stored at `0x38908+8` and `0x34808+0xC/0xD` | listing (this chapter) |
| `0x3B` | SET_TOTO (time-out) | `+0xAB16` | `+0xA308` | §4.13 | results FW19; `reviews` FW19 review |
| `0x3C` | SET_SPK_EN | `+0xAB0E` | `+0xA334` | body byte → `0x38908+4`, 0 → `+5`, sr 0 (no range check) | listing (this chapter) |
| `0x3D` | (none in OEM) | inline `+0xAAFE` | `+0xA898` | takes a length-prefixed body (≤ 120), reads a 32-bit LE ID at body[0..3], divides the rest by 10; meaning unknown | listing (this chapter); results R4l ("already has a handler at file `+0xAAFE`") |
| `0x3E` | (none) | `+0xAAF6` | `+0xAA1C` | if byte `0x324DE` ≠ 0, reply that many bytes from `0x3D364`; else sr 1 | listing (this chapter) |
| `0x3F` | TEST_BIT_ERROR_RATE | `+0xAAEE` | `+0x8FA8` | BER mode: 1 = Hongrui pattern, 2 = O.153 | results "Command `0x3F` is the OEM BER test" |
| `0x40`–`0x45` | — | default `+0xAA54` | — | no reply (stock `0x40` = free slot, used by every patched image) | results 2026-10-28 |
| `0x46` | (none) | `+0xAAD0` | `+0xA568` | if byte `0x38918+0x195` ≠ 0, reply a block from `0x38C84` (length from `+0x196/+0x197`); else sr 1 | listing (this chapter) |
| `0x47`–`0x87` | — | default | — | no reply | listing (this chapter) |
| `0x88` | (none) | `+0xAAC8` | `+0xA34C` | `ack_empty` sr 0, 1 s wait, then `+0xAB4` = **SoC reset** | listing; `V076` §3 ("reboot") |
| `0x89` | (none) | inline `+0xABF2` | — | stores a 24-bit **big-endian** value from body[0..2] at `0x3244C+0x14`; **no reply** | listing (this chapter) |
| `0x8A` | (none) | inline `+0xAAD8` | `+0x8E0C` | body byte → AT1846S `0x44` bits 11:8 (`set_tx_gain_reg44`), also stored at `0x3CE6E` and `0x16000900+0xE5`; **no reply** | listing (this chapter); `symbols` |

Two corrections to older readings fall out of this table (§11, items 1–3): the `+0xAAD8` → `+0x8E0C` case is command
`0x8A`, not `0x2A`; the 3-byte BE ID setter `+0xABF2` is `0x89`, not `0x28`/SMS; `+0xAB3E` is the `0x36` ack, not a
`0x2F`/`0x31` mode toggle.

Do **not** send `0x88` (resets the module) or `0x89`/`0x8A` (silent writes to state and to an RF register) on the
user's radio without a reason; none of them is used by the OEM app or SignalDeck.

---

## 4. Command reference (stock behaviour)

Each block: body, firmware handler, what it does, measured behaviour, gotchas. Body offsets are from the start of the
body (frame offset 8).

### 4.1 `0x22` SET_DIGITAL_INFO — digital channel write (163 bytes)

Body (**Verified (code)**: `02` §3.2, `DigitalMessage.encodeBody`; `PL`; SignalDeck `RE.setDigital`):

| Off | Size | Field | Values |
|---|---|---|---|
| 0 | 4 | rxFreq | Hz, int LE |
| 4 | 4 | txFreq | Hz |
| 8 | 4 | localId | this radio's DMR ID (from `DmrManager`, not the channel; CLAUDE.md §7 pitfall 15) |
| 12 | 128 | groups[32] | RX group list, 32 × int LE (§7.1) |
| 140 | 4 | txContact | 24-bit DMR ID / TG in an int (CLAUDE.md §7 pitfall 12) |
| 144 | 1 | contactType | 0 private / 1 group / 2 all |
| 145 | 1 | power | 0 low / 1 high |
| 146 | 1 | cc | colour code 0–15 |
| 147 | 1 | inboundSlot | 0 = TS1, 1 = TS2 |
| 148 | 1 | outboundSlot | 0 = TS1, 1 = TS2 |
| 149 | 1 | channelMode | 0 direct / 4 double-slot |
| 150 | 1 | encryptSw | 1 on / 2 off |
| 151 | 8 | encryptKey | 8 bytes (OEM writes an unchecked string; a wrong length shifts every later offset, `02` §3.2) |
| 159 | 1 | pwrSave | OEM default 1 |
| 160 | 1 | volume | default 8 |
| 161 | 1 | mic | mic gain index |
| 162 | 1 | relay | 1 disconnect / 2 normal |

There is no band byte in this body (`PL`). Handler internals in §5.1. Reply: `ack_empty`, sr 0 accepted / sr 1 refused.
The OEM state machine retries once on sr ≠ 0 or no reply in 1 s, then raises `errorEvent` (`01` §7). SignalDeck sends
`channelMode 0`, encrypt off, pwrSave 1, relay 2, and adds the Call Number to `groups[]` for a group channel (`RE.setDigital`).

### 4.2 `0x23` SET_ANALOG_INFO — analog channel / VFO write (19 bytes)

| Off | Field | Values / measured |
|---|---|---|
| 0 | rxFreq (4) | Hz |
| 4 | txFreq (4) | Hz |
| 8 | band | 0 narrow / 1 wide; **0 on VHF makes the receiver deaf** (§5.4) |
| 9 | power | 0 low / 1 high; anything else refused (`cmphs` vs 1, `11` §11.5) |
| 10 | sq | stored as sent, 0–9 (§7.4) |
| 11 | rxType | 0 none / 1 CTCSS / 2 DCS normal / 3 DCS inverted |
| 12 | rxSubCode | tone-table index |
| 13 | txType | as rxType |
| 14 | txSubCode | index |
| 15 | pwrSave | 1 on / 2 off; **0 is refused** (sr 1) |
| 16 | volume | default 8 |
| 17 | monitor | 1 on / 2 off; **0 is refused** |
| 18 | relay | 1 / 2 |

Sources: `02` §3.1 (code), `11` §11.4–§11.5 (listing), `RE.setAnalog` comment "the MCU answers sr=1 (fail) to a 0 in
pwrSave/monitor (measured 2026-10-17)" (**Verified (bench)**, SignalDeck). Frequencies are Hz, unscaled. OEM does not
copy pwrSave/volume/monitor from the channel (defaults 2/8/2). Handler internals §5.2.

Measured: an `0x23` write is acked within about 25 ms (results R3a2: written 23:28:43.987, acked .011); a rewrite of the
current channel costs ≈ 0.6 s of receive (`RECEIVE_STOP` then `RECEIVE_START` ≈ 0.6 s later; `11` §17.1). **Verified (bench).**

### 4.3 `0x24` / `0x25` / `0x39` — readbacks

Request body `01`. Reply = the module's stored image: 163 B from `0x38E4C` (digital), 19 B from `0x38C70` (analog),
169 B from `0x38AB0` (mix-check). **Verified (listing+bench)**: `11` §14.2, §15 (byte-identical readback of the last
`0x22`; `sq=5` read back after a `0x23` with `sq=5`; `groups[0..2]` stored). Fresh-boot analog image is all zero except
`sq=3`, `volume=8` (`11` §16). The mix-check image has never been written on this radio (169 zero bytes, `11` §15),
consistent with `0x38` being unimplemented (§3).

The images are the stored copies, not live RF state: the `0x2E`, `0x2F`, `0x30`, `0x31`, `0x33`, `0x2A` handlers patch
fields inside them (§3 table), so a readback after those commands reflects them. **Verified (listing, this chapter).**

### 4.4 `0x26` SET_LAUNCH_INFO — PTT

Body 1 byte: `1` = key, `2` = unkey. Any other value → `ack_empty` sr 1, no key (**Verified (listing)**: `+0x928E…+0x9296`;
SignalDeck comment "0 is NAKed", `RE.ptt`). Internals in §6. Measured: ack ≈ 5–6 ms after the request, `0x36` status 3
(`SEND_START`) ≈ 6–12 ms after the ack; after the unkey, status 4 (`SEND_STOP`) ≈ 0.33 s later (results R3a2 "The 3 s
key", R3a3 "The tone key"). **Verified (bench).**

### 4.5 `0x27` QUERY_INIT_STATUS

Body `01`. Reply `ack_empty` with sr = 0 when bit 5 of `0x38908` is set, sr = 1 otherwise (**Verified (listing, this
chapter)**: `+0x9E24`, `andi r3, 32; cmpnei; mvcv r1`). The OEM boot state machine waits for sr = 0
(`CmdStateMachine` cmd `0x27` branch, `01` §7). That bit 5 means "initialisation complete" is **Inferred** from the
OEM's use.

### 4.6 `0x28` ENHANCE (radio check / call alert / monitor / kill / revive)

Body: `fun` (1) + `callNum` (4 LE); fun 1 check, 2 call alert, 3 remote monitor, 4 kill, 5 revive (`02` §3.4, code). The
firmware accepts body[0] 1–6 and copies 5 bytes to `0x3CE68`, after waiting on the busy byte (§3). The module can also
push `0x28` unsolicited (OEM `EnhanceMessageHandler` stores kill/revive). No bench data. **Do not test kill** on the
user's radio.

### 4.7 `0x2B` caller info

Pushed by the module after a received DMR call; also the reply to a 1-byte `01` query (`RE.queryCallerInfo`). Built at
`+0xA808` field by field, sent through `reply_build` with length 9 (**Verified (listing)**: `11` §20).

| Off | Field | Notes |
|---|---|---|
| 0 | callType | 0 private, 1 group (2 all) |
| 1 | callerId | int LE; 24 bits used (`& 0xFFFFFF`) |
| 5 | target | int LE: own ID for a private call, the TG for a group call; `0xFFFFFF` in ALL mode |

**Verified (bench)** on air 2026-10-15, four calls from a second DMR radio (`11` §19.2). Sequence per heard call:
`0x36` 1 (`RECEIVE_START`) → ~3 s later `0x36` 2 → the `0x2B` push → a second `0x36` 2. Illustrative body (made-up
IDs): group call from `1234567` to TG 9 = `01 87 D6 12 00 09 00 00 00`.

Gotchas: reading only `body[1..2]` truncates the ID to 16 bits (`PL`; CLAUDE.md §9). The OEM app ignores this frame
entirely (`DigitalAudioMessageHandler` empty, `02` §3.7). Patched images (FW26 promiscuous mode) append CC and slot
(11 bytes); stock is always 9 (`RE.parseCallerInfo`, `symbols` `fw26_finish`).

### 4.8 `0x2C` SEND_SMS — DMR text

OEM body: `msgType` (1 single, 2 all, 3 group) + `callNumber` (4 LE) + [`callGroupNumber` (4) only for group] +
UTF-16LE text (`02` §3.8). **The 9-byte header rule:** the firmware reads a 9-byte header for **private** texts too. A
private text sent with the OEM's 5-byte header reached a BTECH 6X2 with its first two characters missing (on air
2026-10-17); SignalDeck writes the target ID twice for private texts (type, id, id, text). **Verified (bench)**: CLAUDE.md
§11 status paragraph; `RE.sendSms` comment. The handler at `+0xA364` was not read (`V076` §3: "the Armor uses `len − 5`
on one path"). Result arrives as status 8 (sent) or 9 (no acknowledgement — the text may still arrive, CLAUDE.md §11).

### 4.9 `0x2D` RECEIVE_SMS — fetch

Host sends `01` after status 5 (`SMS_RECEIVED`). Reply body: `type` (1) + `callID` (4 LE) + UTF-16LE text (`02` §3.9,
`RE.onFrame`). Handler `+0xA53C`, not read. Confirm that a group text's type is 1 with an on-air talkgroup text (memory
`todo-dmr-message-threads`, open).

### 4.10 `0x32` RSSI

Request `01`; reply 1 byte, raw unsigned. Firmware path (**Verified (listing)**, results FW29): `+0xA6A8` → `+0x377C`
→ `at1846_read_rssi` `+0x2B4C` = AT1846S register `0x1B` bits 15:8 through the IRAM I²C read `0x2B25C`; no lock, no
cached value; `reply_build(0x32, 0, buf, 1)`.

- dBm = `−(120 − raw/2)` for raw > 0 is the **module/SignalDeck convention**, not an OEM or firmware formula (`02` §3.14;
  `RE.onFrame`). SignalDeck treats anything above −20 dBm as "no reading" (Xplore 1 returns raw 226).
- Answers while the squelch is closed (`11` §17). **Verified (bench).**
- **Settle after a retune:** a `0x32` sent after an `0x23` retune is answered only once the next reading is ready
  (~0.5–0.6 s), and readings 0.6 s after the retune are 15–20 dB low; from 0.7 s they match. Sweeps cost ~0.7 s per
  step. **Verified (bench)**: CLAUDE.md §3 "Signal reading after a retune".

### 4.11 `0x34` QUERY_VERSION

Request `01`. Reply: 17 bytes copied from XIP `0x03052464` = file `+0x38464`, the image's own NUL-terminated string
`DMR003.UV4T.V022` (**Verified (listing)**: `11` §21.4). Factory reply body `44 4D 52 30 30 33 2E 55 56 34 54 2E 56 30
32 32 00` (results R3a2 "End state"). The OEM decodes the first 4 bytes as an int LE **and** the whole body as a string
(`02` §3.25). Every built image changes the `UV4T` field, so `0x34` identifies what is in flash (CLAUDE.md §1).
Immediately after a load the first query sometimes printed `0x29050000` before the module restarted and answered
properly (results R3a2 "R3a2 boot"); hosts should retry after the banner.

### 4.12 `0x35` INTERRUPT_TRANSMIT

Body 1 = open, 2 = off, 3 = transport (`02` §3.16). Firmware: 1/2 store 1/0 at `0x34808+0x11` and `0x3244C+0xA`; 3 takes a
separate path not read; other values sr 1 (§3). The OEM sends it after every successful digital channel write unless
the channel's interrupt is 3; SignalDeck sends 2 after a digital boot handshake (`RE.bootHandshake`).

### 4.13 `0x3B` SET_TOTO — transmit time-out

**Verified (listing+bench)**: results FW19 header; `reviews` FW19 review "What I verified"; listing `+0xA308`
(this chapter).

- Handler `+0xA308`: body byte 0 → store 0 at the enable byte `0x38C64` (the stored seconds byte is **not** cleared);
  otherwise enable = 1 and the byte at `0x38C65`. Always `ack_empty` sr 0. **No compare, no `min(tot, 30)`.**
- Timer: code at `+0x1D8` increments a 32-bit count at `0x38C64+2…+5` once per wake while enable is set and `0x38908`
  bit 0 or 2 (transmitting) is set, compares with `100 × tot`; the count is zeroed when those bits are clear. A unit is
  one second (100 wakes).
- Start-up value: the routine at `+0x264` sets enable = 1, tot = **120**.
- The OEM sends 0 (`DmrManager.sendSetTotCmdToMdl`), so on stock firmware driven by the OEM app the module has **no
  time-out**. SignalDeck's boot handshake now sends **120** (`RE.bootHandshake`, `setTot(120)`).
- Measured on FW19 (whose only change is 0 / > 120 → 120): the module ends a key at 120.3 s with **status 4, never 6**;
  a 40 s plain FM key is not ended by the module (CLAUDE.md §3 "Transmit length"). The 30 s limits seen in 2026-10 were
  the apps' own countdowns.
- FW36 and later restore the stock store (results FW36): a byte of 0 means no module timer again.

### 4.14 Single-byte settings `0x2A`, `0x2E`, `0x2F`, `0x30`, `0x31`, `0x33`, `0x37`, `0x3A`, `0x3C`

Ranges and stores are in the §3 table (**Verified (listing, this chapter)**). Notes:

- **`0x2F` monitor.** 1 or 2 only (0 → sr 1). 2 calls `+0x37F4(1)`; 1 calls `+0x37F4(0)` after 200 ms. `+0x37F4(1)` is the
  receiver-mute write (AT1846S `0x30` bit 7: `0x7026` → `0x70A6`; results "periodic task `0x0399C`", `reviews` 3b
  STUCK acceptance), so 1 = force the audio open, 2 = normal squelch. **Inferred** from those two readings. On the
  Xplore 1, monitor 1 made PCM flow continuously on an empty channel (`docs/multi-device-xplore1-findings.md` §"monitor on").
  SignalDeck's comment "1 = hear every decodable digital call" (`RE.setMonitor`) is **not** supported by this listing:
  the handler touches only the squelch/mute path; whether it changes DMR admission is open (`docs/promiscuous-rx-patch-spec-2026-10-24.md` item 0).
- **`0x30` squelch.** Global squelch, 0–9 accepted, stored into the analog image's `sq` byte (`+0xA`) and `0x38B5C+0xC`,
  then `+0x30D8` (next to `at1846_set_squelch` `+0x30A4`). The OEM never sends it (per-channel `sq` rides in `0x23`).
- **`0x37` polite policy.** 0 → config byte `+0xAE` = 1, 1 → `+0xAE` = 3. `+0xAE` = 3 is the condition `+0xE64` tests
  before refusing a key (§6.3), so policy 1 is most likely "polite" (do not key on a busy channel). **Inferred.**
- **`0x3C` speaker enable.** Not in the OEM dispatcher; the firmware stores any byte (`0x38908+4`) and acks sr 0.

### 4.15 `0x3F` BER test

Body 1 (Hongrui pattern) or 2 (O.153, sent by the OEM BER screen). Either makes the next channel setup store
`WORK_MODE` `0x22` and the modem generates the pattern (results "Command `0x3F` is the OEM BER test"). While the OEM's
BER flag is on, its reader wraps every received byte as a raw `0x3F` packet (`01` §3, gotcha 12). Scores leave the
module as `0x21` sub 34 (§2.4).

### 4.16 `0x88` / `0x89` / `0x8A` / `0x3D` / `0x3E` / `0x46`

Undocumented commands present in the table (§3). `0x88` resets the SoC after acking. `0x89` and `0x8A` never reply.
`0x3D`, `0x3E`, `0x46` are queries or list writes whose meaning is unknown. All **Verified (listing, this chapter)** as
far as the table states; meanings open (§12).

### 4.17 `0x36` host acknowledgement

Host → module `68 36 01 01 95 B7 00 01 01 10` after every status push (OEM and SignalDeck). The inline case clears bit 0
and sets bit 1 of `0x38EF0`; `status_post` `+0x7E08` sets bit 0 when it queues a status (`symbols`). So the ack retires
the pending status. **Verified (listing)**; what the module does when an ack never comes was not tested.

---

## 5. Channel writes: what `0x22` and `0x23` do inside

### 5.1 `0x22` handler `+0x9310`

**Verified (listing)**: `11` §13.1, §20; results "`0x32457` writers" (13:59) and FW40 probes (14:18); results 07:58.

1. `+0x9336`: stores 1 to the **busy byte** `0x3244C+0xB` = `0x32457`, then takes the lock object `0x39124` (`+0x18E8`).
2. If `0x38908` bits 0 or 2 are set (transmitting), the early path stores 200 at `0x38908+0xB` (`+0x9370`).
3. `memcpy` of exactly 163 body bytes to the stack, then field-by-field reads (rxFreq/txFreq assembled bytewise).
4. **Frequency check** with literal pairs `(−400 000 000, 120 000 000)` and `(−136 000 000, 38 000 000)`: accepts
   **400–520 MHz** or **136–174 MHz** in this handler; outside → an `ack_empty`-and-return exit (`+0x957C`, `+0x95A0`,
   `+0x95C4`). See §5.5 for the bench limit, which is narrower.
5. Power above 1 rejected; `channelMode` must be 0 or 4; `contactType == 2` (ALL) and a fourth value 3 are branched on.
6. A 32-iteration loop (`+0x9606…+0x9632`) copies `groups[32]` into the stored image.
7. Success: `ack_empty(0x22, 0)`, unlock (`+0x1924`), the flag setter `+0x7E08` with r0 = 2, then `+0x6354`. The long
   success return (`+0x9968` → `+0x9558`) enters the epilogue *after* the clear at `+0x9552`, so it **leaves the busy
   byte at 1**; every reject tail stores 0 (`+0x9552`, `+0x9592`, `+0x95B6`, `+0x95D8`, `+0x9682`, `+0x9986`,
   `+0x999E`) (results 13:59). `11` §13.1 read the success path as clearing the byte (§11 item 19).

The FW55 investigation (results 07:58, 2026-10-30) confirmed the dispatch word for `0x22` is `0x03024BEA` (file
`+0xABEA`) in both factory and FW55, that the first 8 KiB of the handler differs from factory only in the two receive
hooks at `+0xC1BA`/`+0xC244`, and that `+0xE9C` and the idle-task window `+0x6B0…+0x900` are byte-identical.

### 5.2 `0x23` handler `+0x99B4`

**Verified (listing, this chapter)** for steps 1–4; `11` §11.4–§11.5 for 5–6; results 13:59 for the busy byte.

1. Snapshot the 176-byte config block (`0x38B5C`, via IRAM `0x2C99C`); clear the snapshot's `+0xAF` and `0x38908+6/+7`.
2. `+0x99D6`: busy byte `0x32457` = 1; take lock `0x39124`.
3. If `0x38908` bit 1 is set → branch `+0x9B1C` (not read).
4. If `0x38908` bits 0 or 2 are set (**a transmission is in progress**): when `0x38874` ≠ 0, call `+0xE9C(1, 1)` (the
   unkey action), store D = 0 and B = 200, **wait 500 ms** (`delay_ms(500)`), clear bits 0 and 2. When `0x38874` = 0,
   branch `+0x9B14` (FM path, not read). So a channel write **ends a transmission first**. This is the firmware side of
   SignalDeck's `RETUNE_SETTLE_MS` rule (CLAUDE.md §3: "the OEM channel-change completes ~3 s later and stops a
   transmission in progress"). **Inferred** link.
5. `+0x37F4(1)` (mute) before the unpack.
6. Unpack `+0x9A2C`: every body offset read; band/power must be 0/1; tone indices bounded (`#0x32` CTCSS, `#0x53` DCS);
   a `#9` bound for volume-or-sq; `sq` repacked to body[10] **unchanged** (`+0x9C3E`). Apply via `apply_analog_config`
   `+0x7A30` (memcpy `0xB0` + MMIO `0x1100xxxx`) and, per channel, `at1846_tune` `+0x2DD8` (§5.4).
7. Frequency reject tail `+0x9B3E` stores 0 to the busy byte; the long success return unlocks at `+0x9CC8`, applies,
   acks and **leaves the busy byte at 1** (results 13:59).

### 5.3 The busy byte `0x32457` and the idle-task clear

**Verified (listing)**: results 13:59, FW40 (14:12), FW40 probes (14:18); restated in results 07:58.

| Who | Effect |
|---|---|
| `0x22` / `0x23` entry (`+0x9336` / `+0x99D6`) | set 1 |
| every `0x22`/`0x23` reject tail | set 0 |
| `0x22`/`0x23` success return | leaves 1 |
| `+0x137C` in mode-setup `+0x11E0` | set 0 when `(r4, 2) ≠ 2` and `0x38908+8` is neither 1 nor 2 |
| idle task `+0x63C`, store at `+0x6BE` | set 0 only when: a pend returned 1, `0x38908+0xA` (A) ≠ 0, bit 0 of `0x38908` clear, `0x38908+0xD` (D) ≠ 1, the decrement of `0x38908+0xB` (B) lands on 100, and the word `0x32458` = 0 |

Readers: the `0x26` wait at `+0x9278` (§6.1), `+0x15C` in `+0x124` (skips work while set), FmRecv `+0x399C` at `+0x39DA`
(the periodic squelch machine does nothing while set), `0x28` (§3), `+0x9E70`, `+0xA392`.

Who arms A and B: the status-4 path at `+0x85A` in task `+0x7B0` stores A = 1, B = 200 after the TX-end delays; a
"symbol-mode" `0x26` key (byte `0x38874` ≠ 0) stores A = 0, D = 1 and the word `0x32458` = 1, and its unkey stores B = 200,
D = 0, word = 0 but leaves A at 0 — so after such a key the countdown never moves and the clear never runs (results 13:59).
A plain FM unkey (`0x38874` = 0) writes none of A, B, the word (results 14:12).

**FW55 "first channel write" (results 07:58, 2026-10-30, offline).** On air one channel write was missed and the write
4.5 s later applied. The handler is unchanged from factory, so the explanation offered is this busy byte: a write that
arrives while it is still 1 does not change the mode. The bytes A/B/`0x32458` after a stock unkey and after the first
`0x22` are the next bench reading. **Inferred**; see the contradiction in §11 item 8.

### 5.4 Band byte, `at1846_tune`, receive on/off

- `0x23` byte 8 is documented as bandwidth (0 narrow / 1 wide), but **`band = 0` on a VHF frequency makes the receiver
  deaf** (no `RECEIVE_START` even at −73 dBm; an app restart does not recover it, a phone reboot does; same HackRF
  carrier −72 dBm with band 1 vs −92 dBm with band 0 at 162.500 MHz). On UHF both values receive. **Rule: band = 1 on
  VHF.** **Verified (bench)**: CLAUDE.md §3a "`channel_band`".
- In the firmware the band selects the AT1846S bandwidth profile (`at1846_apply_bw_profile` `+0x2B14`, r0 = 0 12.5 kHz /
  1 25 kHz, 23 registers from a table) and the FM `0x30` value (`0x4006/0x4026` vs `0x7006/0x7026`). **Verified (listing)**:
  `11` §21.2. Why band 0 deafens VHF is not explained by the listing (§12).
- `at1846_tune` `+0x2DD8`: spur register `0x05` by frequency, `0x29`/`0x2A` frequency, then a **DMR branch** (`0x30` =
  `0x4006` → `0x4026` for 12.5 kHz, `0x43=0x00BB`, `0x44=0x0AD1`, `0x58=0xBCFD` all audio filters bypassed) or an **FM
  branch** at `+0x2FF2` (`0x58=0x8405` filters on, bandwidth profile, `0x3A=0x40C3`). DMR always ends at `0x30 = 0x4026`
  (12.5 kHz; results R3a2 "Proposed next image"; ch. 19 §23). **Verified (listing)**: `11` §21.2–§21.3; `symbols`.
- `at1846_rx_off` `+0xB00C` clears `0x30` bits 5/6 then bit 2; `at1846_rx_on` `+0xB048` sets bit 2 then bit 5 (`symbols`).
  `+0x37F4(1)` sets `0x30` bit 7 (mute, `0x7026` → `0x70A6`) and `+0x37F4(0)` clears it (results "periodic task";
  `reviews` 3b STUCK acceptance). Any channel write re-runs `at1846_tune`, which is why any held register write (for
  example `0x58 = 0xBCFD`) is cleared by a channel write (CLAUDE.md §3 M17 row, R-D).

### 5.5 Tuning range and step

- **Bench limit: 136.000–174.000 and 400.000–480.000 MHz.** 174.000 and 400.000 acked `sr=0`; 174.005, 175–225, 300,
  399.995 MHz refused `sr=1`, and the radio **stays on its previous frequency**. **Verified (bench)**, 2026-10-21, `0x23`
  writes: CLAUDE.md §3 "Tuning range"; memory `mcu-tuning-range-enforced`.
- The `0x22` handler's literals accept 400–**520** MHz (`11` §13.1). The upper UHF edge was never bench-tested on the
  Armor (480.005 MHz not on record); on the W6 DMR variant 480.005 and 485 MHz were acknowledged (`docs/w6-dmr-status.md`).
  See §11 item 5.
- **Step: 500 Hz, exact.** Requested 0 / +500 / +1000 / +1500 / +2500 / +5000 Hz landed within ±1.5 Hz; off-grid writes
  are acked `sr=0`; the synthesizer is not limited to 5/6.25/12.5 kHz. **Verified (bench)**, 2026-10-22: CLAUDE.md §3
  "Fine tuning (Doppler)".

### 5.6 Never `syncChannelInfoWithData()` and a direct `AnalogMessage` back-to-back

Measured 2026-10-17 with HackRF probes: the pair intermittently (3 of ~8) leaves the module reporting `SEND_START` /
`SEND_STOP` normally but radiating **no RF**; RX unaffected; the state survives phone reboots. Either path alone is fine
(10/10). Rule: one channel-write path; recovery = any single-path channel write. **Verified (bench)**: CLAUDE.md §3a
"Channel writes to the MCU"; memory `mcu-channel-write-pair-kills-tx`. Mechanism unknown; the busy byte (§5.3) and the
`0x23` handler's "end a transmission, wait 500 ms" step (§5.2) are candidates. **Inferred.**

---

## 6. Transmit: `0x26` and `tx_launch`

### 6.1 The `0x26` handler `+0x9264`

**Verified (listing, this chapter; matches results R3a2/R3a3 and FW40):**

```
+0x9264  r6 = frame; r5 = 80; r8 = 0x3244C
+0x9278  loop: if byte 0x32457 != 1 → go on
               else delay_ms(10); r5--; r5 == 0 → ack_empty(0x26, 1)   (busy: refused, no key)
+0x9288  body[0]: 1 → key (+0x92B2), 2 → unkey (+0x929C), else ack_empty(0x26, 1)
key   +0x92B2: IRAM 0x2AF24(1, 1)   (synth-lock prelude)
        byte 0x38874 == 0 → +0x92C8 bsr 0xE9C(0, 0);           ack sr 0
        byte 0x38874 != 0 → word 0x32458 = 1; +0x92E0 bsr 0xE9C(1, 0);
                            0x38908+0xD = 1; 0x38908+0xA = 0; ack sr 0
unkey +0x929C:
        byte 0x38874 == 0 → +0x92AA bsr 0xE9C(0, 1);           ack sr 0
        byte 0x38874 != 0 → word 0x32458 = 0; +0x92FA bsr 0xE9C(1, 1);
                            0x38908+0xD = 0; 0x38908+0xB = 200; ack sr 0
```

- The four `bsr 0xE9C` sites `+0x92C8`, `+0x92E0` (key) and `+0x92AA`, `+0x92FA` (unkey) are asserted against the factory
  image by `tools/fw-patch/test_patches.py` (lines 576–581). Every patched image from R3a3 on redirects them
  (`symbols` `tx_launch_action`, `cmd26_launch_bsr_sites`).
- The busy wait is 80 passes of `delay_ms(10)`; `delay_ms` sleeps `(r0 + 9) / 10` ticks, so 80 ticks — 0.8 s if a tick is
  10 ms (results 13:59 "Pass length"; tick period not settled).
- The handler does **not** call the FM key-up function; a host `0x26` never reaches `+0x3ECC0` (results R3a2 "The 3 s key").
- What byte `0x38874` (byte 0) encodes on stock is not settled: the patched symbol keys take the `≠ 0` path, and
  results note "A DMR key is the same `0x26`, and the busy test at `0x9278` is before the digital/analog split"
  (results 14:12). **Inferred**: non-zero = the DMR/TX-RAM path, zero = plain FM.

### 6.2 `tx_launch_action` `+0xE9C` (r0 = path, r1 = 0 key / 1 unkey)

**Verified (listing, this chapter)**, consistent with results FW42–FW49:

1. `+0xB07C`.
2. If byte `0x38C0C` = `0x68`: when r1 ≠ 0 return; else build a frame through `+0x9120(40, 2, buf, 1)` (not read).
3. Else call `+0xE64` (§6.3). If it returns 0 (not busy): when r0 = 0, store **r1 at `0x38875`** (the key-state byte:
   0 after a key, 1 after an unkey — results FW42 "`0x38875` is stored only at `0xEF2`, from the key argument"); if r1 = 0
   and bit 3 of `0x38909` is set, clear it and call `+0x12920`. When r0 ≠ 0 → `+0xF36` (not read).
4. Then `+0x1924(0x390D4)`: an RTOS call on the semaphore object `0x390D4` through ROM-side code at IRAM `0x12268`
   (`0xFCFF8268` flat) — the "event" that the PTT task acts on (results R3a2: "`+0xE9C`, which posts an event"; FW45-D2).
5. If `+0xE64` returns non-zero and r1 = 0 (a key) → `+0xF3C` (not read); a busy unkey returns.

Bench facts (results FW44–FW49, all on patched images, stock code path): `+0xE9C` has no loop and no `delay_ms`; DMR does
not enter it on those images; with r1 = 0 it can call `+0x12920` before the semaphore call; the unkey with r1 = 0 did
not return (FW49), the stock sites always pass r1 = 1 for unkey.

### 6.3 `+0xE64` — the key-refusal check

**Verified (listing, this chapter):** copy the 176-byte config block from `0x38B5C` (IRAM `0x2C99C`); if its byte `+0xAE`
≠ 3 return 0; else return 1 when `0x38908 & 3 == 2` or `0x38908 & 0xC == 8`, otherwise 0. Since `0x37` policy 1 writes
`+0xAE = 3` (§4.14), this is most likely the polite-policy busy-channel check that leads to status 7 (`CHANNEL_BUSY`).
**Inferred.** Results FW47: "`0xE64` returns nonzero when the copied byte at `+0xAE` is 3".

### 6.4 Key state words

| Address | Meaning | Source |
|---|---|---|
| `0x38874` byte 0 | path selector read by `0x26` and `0x23` | results R3a3, listing |
| `0x38875` | key state, written only by `+0xE9C` from r1 | results FW42 |
| `0x38874+2` | read by task `+0x7B0` before arming A/B | results FW40 probes |
| `0x38874+6` | 1 = skip the synthesizer-lock wait in `0x2AF24` | results FW39 |
| `0x38908` bits 0, 2 | transmitting (TOT timer runs, channel write unkeys first) | `reviews` FW19; listing §5.2 |
| `0x38908` bit 5 | initialisation complete (`0x27`) | listing §4.5 |
| `0x38908+0xA/+0xB/+0xD` | A / B countdown / D (busy-byte clear, §5.3) | results 14:18 |
| `0x32458` (word) | set by a symbol-path key, gates the busy clear | results 13:59 |
| `0x390D4` | semaphore posted by `+0xE9C` via `+0x1924` | results FW45-D2 |
| `0x38C64…` | TOT: enable, seconds, 32-bit count | `reviews` FW19 |
| `0x38EF0` bit 0/1, `0x38EF2` | status pending / acked, status byte | `symbols` `status_post`; §4.17 |

### 6.5 The FM key-up that runs at boot

`fm_keyup` `+0x3ECC0` (IRAM-copied) stores `RF_MODE` `0x10E0` at `+0x3EDDA` and clears `tx_voice_source` at `+0x3EDF8`
(`symbols`; ch. 19 §21). R3a0's six hook bytes in it ran **before the banner**, so the module runs its own key-up then
unkey (`+0x3D688`) during boot — a start-up TX/RX cycle (ch. 19 §23). The factory boot cycle **does not radiate**
measurably at 467.625 MHz (24 s capture, hottest bin +0.11 dB; results R3a2 "Factory boot, receive only").
**Verified (bench)** for the absence of RF; the purpose of the cycle is **Inferred**. Rule from it: any patch on the
key-up path must be gated on a host request and do nothing at boot (ch. 19 §23).

### 6.6 `drop_ptt` (patched, for reference)

Not stock. `drop_ptt` (first at file `+0x5AF9A`, R4j) is the patched images' own end of a TX-RAM key: clears PTT, the
voice bit and mask bit 15, restores two AT1846S words, and from R4k posts status 4 through `status_post`
(results R4j/R4k). FW20 learned that the stock unkey (`+0xE9C` with the TX bits still set) must run before those bits are
cleared, or the receiver stays off until a channel write (CLAUDE.md §3 "Transmit length").

### 6.7 Transmit side facts measured on stock paths

- TX vs USB: high-power 2 m TX on some frequencies resets the phone's USB port (CLAUDE.md §3 "TX vs. USB cable").
- Wait ≥ 3.5 s after a retune before keying (`RETUNE_SETTLE_MS`, CLAUDE.md §3 "Transmit length").
- This radio's narrow-band DMR outer symbol is ±3.3 kHz (about 1.7× the standard ±1944 Hz); other radios decode it
  (ch. 19 §22–§23; results R3a2).
- APRS AFSK over the voice path needs ~1.5 s of lead-in after PTT (CLAUDE.md §3 APRS row).

---

## 7. Receive behaviour

### 7.1 Group list admission (`groups[]`)

**Verified (bench)** on air 2026-10-15 (`11` §19), corroborated by the listing (`11` §20):

- A group call is passed **iff its TG is in `groups[]`** (0x22 body offset 12, 32 slots). The Call Number (`txContact`)
  alone does not admit its TG: TG 9 with `txContact = 9` and list `[1]` was silent; TG 1 with `txContact = 99` and list
  `[1]` was heard.
- **Private calls to the radio's own ID always pass.**
- **ALL / RECEIVE_ALL** (`contactType = 2`): the module reports `0xFFFFFF` and drops audio. The firmware builds
  `0xFFFFFF` with `bmaski r?, 24`, not a literal (`11` §20).
- Out-of-list calls are dropped **before** any `RECEIVE_START`, so a software filter cannot widen the 32-slot list
  (CLAUDE.md §3 ">32 TG IDs").
- The OEM app sends the channel's `groups` only when `contactType == 1`; otherwise the default `[1, 0…]` (`02` §3.2).
  The 2026-03 "firmware ignores the RX list" verdict is withdrawn.

Not tested on air: TS2, repeater mode (`relay=1`, `channelMode 4`), colour-code mismatch, encryption (`11` §19.3).

### 7.2 The two status sites in the receive handler (`+0xC1BA`, `+0xC244`)

**Verified (listing, this chapter):**

```
+0xC1BA  bsr 0x2404          ; returns byte 0x38B5C+0xAF
         == 0 → +0xC2BC: status_post(1)   RECEIVE_START
         != 0 → status_post(10)           (OEM name MIX_CHECK_DIGITAL_RECEIVE_START)
+0xC244  bsr 0x2404
         == 0 → +0xC2AE: status_post(2)   RECEIVE_STOP
         != 0 → status_post(11)           (MIX_CHECK_DIGITAL_RECEIVE_STOP)
```

`0x2404` is a one-line getter (`ld.b r0, (0x38B5C, 0xAF)`, 13 callers). These are the "receive-admit hooks" the FW26
promiscuous patch redirects (`symbols` `fw26_admit`). The listing shows the getter chooses between the **normal**
status pair (1/2) and the **mix-check** pair (10/11), not between "admit" and "mute"; the `0x23` handler clears the
snapshot's `+0xAF`, consistent with `+0xAF` being a mix-check/scan flag. **Inferred.** This disagrees with the patch
spec's reading (§11 item 6).

### 7.3 Colour code and time slots

- `cc` at `0x22` body 146 (0–15), `inboundSlot`/`outboundSlot` at 147/148, 0-based (`02` §3.2, `PL`). **Verified (code).**
- The receive setup stores the colour code into the C7000 receive configuration with `andi r2, 15` at `+0x17E26`
  (the FW26 colour-code match-any patch sets bit 8 `cc_opt` before that store; `symbols` `fw26_ccbit`). Stock = match
  the programmed CC only. **Inferred** from the patch notes; CC mismatch was never tested on air (§7.1).
- Bench calls in 2026-10 used CC 1 / TS1 (`11` §19).

### 7.4 Squelch byte

- The module **stores the squelch byte as sent** (`0x25` readback returned `sq=5`; no clamp in the `0x23` parse or
  repack). **Verified (bench+listing)**: `11` §11.5, §15.
- On air (NOAA 162.500, Soft SQ off): at −94 dBm levels 1–9 all closed; at −81 dBm levels 1–9 all opened within 0.6 s;
  `sq=0` always open; 26 windows, no level ever differed. Treat 1–9 as one threshold near −90 dBm; use `0x32` RSSI for
  anything finer. **Verified (bench)**: `11` §17–§17.1; CLAUDE.md §3 "Squelch levels".
- That threshold is about where AFSK and SSTV become decodable (CLAUDE.md §3, bench 2026-10-20).
- Squelch hardware: `at1846_set_squelch` `+0x30A4` writes AT1846S `0x49` from two level bytes; the periodic FmRecv task
  `+0x399C` runs the open/close machine through `+0x37F4` (results "periodic task `0x0399C`").

### 7.5 CTCSS / DCS

- Type byte 0 none, 1 CTCSS, 2 DCS normal ("Forward", N table), 3 DCS inverted ("Backward", I table); subcode = 0-based
  index into the OEM tables: CTCSS 51 entries (62.5–254.1 Hz), DCS 83 entries each (`02` §5 "Tone tables"). **Verified (code).**
- Firmware: the unpack bounds tone indices at `#0x32` (50) and `#0x53` (83) (`11` §11.5). The CTCSS table at file
  `+0x366B2` holds 50 entries 67.00–254.10 Hz in centihertz; the word before it (`+0x366B0`) is 6250 = 62.5 Hz (`11` §18).
  No DCS table in the image; DCS is generated at run time or lives elsewhere (`11` §18.2). The AT1846S set-up is
  `at1846_set_ctcss_dcs` `+0x32E4` (registers `0x4A–0x4E`, `0x3A`, `0x59`, `0x58` = `0x8404` with a tone / `0x8405`
  without; `11` §21.2). See §11 item 7 for the off-by-one question.
- DCS decode from the phone's audio is not possible (processed audio strips it); the module does DCS squelch itself
  (memory `dcs-decode-from-audio-infeasible`). CTCSS decode from audio works.

### 7.6 RX audio does not cross the UART

Voice arrives through `android.os.PrizeTinyService` as 8 kHz stereo 16-bit with L == R for 100 % of samples; DSP should
take every other sample (CLAUDE.md §3a "RX audio"; `11` §16). The UART carries only control, status and caller info.

---

## 8. Status push `0x36`

Module → host, 1-byte body; the host acks it (§4.17). Built by `status_post` `+0x7E08` (stores the byte at `0x38EF2`,
sets bit 0 of `0x38EF0`, wakes `uart_status_sender` `+0x7BC0`, which emits `68 36 <byte>`; `symbols`, results R4k).

| Code | OEM name | When it is seen | Evidence |
|---|---|---|---|
| 1 | RECEIVE_START | carrier/call admitted; ≈ 0.6 s after an analog rewrite on a live signal | Verified (bench): `11` §17.1, §19.2; listing `+0xC2BC` |
| 2 | RECEIVE_STOP | end of receive; a DMR call gives 2, then the `0x2B` push, then a second 2 | Verified (bench): `11` §19.2 |
| 3 | SEND_START | ≈ 6–12 ms after the `0x26` key ack | Verified (bench): results R3a2/R3a3 |
| 4 | SEND_STOP | ≈ 0.33 s after the unkey; **also the time-out end** (120.3 s on FW19) | Verified (bench): results R3a2; CLAUDE.md §3 |
| 5 | SMS_RECEIVED | host then sends `0x2D` | Verified (code): `02` §4d |
| 6 | RELAY_ACTIVITY_TIME_OUT | OEM maps to `onSendTimeout` (relay failure); **never seen on a time-out** | Verified (bench) for the absence: CLAUDE.md §3 ("status 4 (never 6)") |
| 7 | CHANNEL_BUSY | OEM `onChannelBusy`; not observed on the bench | Inferred link to `+0xE64` (§6.3) |
| 8 | SMS_SENT_SUCCESS | text acknowledged | Verified (code) |
| 9 | SMS_SENT_FAIL | no acknowledgement from the far radio; **the text may still arrive** | Verified (bench): CLAUDE.md §11 (2026-10-17) |
| 10 / 11 | MIX_CHECK_DIGITAL_RECEIVE_START / STOP | posted from `+0xC1BA`/`+0xC244` when `0x38B5C+0xAF` ≠ 0 (§7.2) | Verified (listing, this chapter) |
| 12 / 13 | MIX_CHECK_ANALOG_RECEIVE_START / STOP | not traced | — |

---

## 9. Host start-up sequence (for context)

- OEM boot chain on the wire: `0xAA`, `0x34`, `0x22`, `0x35`, `0x3B` (+ queries) (`11` §15). State machine: `0x27`
  until sr 0, `0x34`, channel, then interrupt (digital) or mic (analog), then TOT 0 (`02` §3.21, §3.24, `01` §7).
- SignalDeck (`RE.bootHandshake`): wait for the `BF AA` banner (≤ 10 s), `0x34`, channel, `0x35` 2 (digital) or `0x2A` 4
  (analog), `0x3B` **120**. **Verified (code).**
- The Xplore 1's stock app sends `0x27`, `0x34`, `0x23` (sq 5), interrupt, polite, `0x2F` 2, `0x30` 5
  (CHANGELOG_DRAFT.md N8 entry from the beta.3 log).

---

## 10. RAM objects the handlers share

| Address | What | Source |
|---|---|---|
| `0x3244C` | shared ack frame buffer (offsets 0–8); `+0xA` interrupt flag (`0x35`); `+0xB` = `0x32457` busy byte; `+0xC` = word `0x32458`; `+0x12` received length; `+0x14` = `0x32460` (`0x89` value) | listing (this chapter); results 13:59 |
| `0x38E4C` | stored digital channel image, 163 B | `11` §14.2 |
| `0x38C70` | stored analog image, 19 B (`+0xA` sq, `+0xF` pwrSave, `+0x10` vol, `+0x11` monitor, `+0x12` relay) | listing (this chapter) |
| `0x38AB0` | mix-check image, 169 B | `11` §14.2 |
| `0x38B5C` | 176-byte config block (`+0xC` squelch, `+0xAE` polite state, `+0xAF` getter `0x2404`) | listing (this chapter); results FW45-D2 |
| `0x38908` | radio state byte and neighbours (§6.4) | results; listing |
| `0x38C64` | TOT enable / seconds / count | `reviews` FW19 |
| `0x38EF0` / `0x38EF2` | status pending flags / status byte | `symbols` |
| `0x39124` | lock object taken by `0x22`/`0x23` (`+0x18E8`) | results 13:59 |
| `0x390D4` | semaphore posted by `tx_launch_action` | results FW45-D2 |
| `0x34808` | mode word area (`+0x11` interrupt copy, `+0xC/+0xD` SMS protocol, `+0x27` cleared by `0x3D`) | listing (this chapter) |

Because the ack builder writes into `0x3244C`, which also holds the busy byte and the received length, two handlers that
ack at the same time would share it. The UART receive task is single-threaded, so this is not observed. **Inferred.**

---

## 11. Contradictions found between sources

| # | Claim | Where | What the code / later bench says |
|---|---|---|---|
| 1 | `+0xAAD8` inline → `+0x8E0C` is a 1-byte volume/squelch/mic command, "most likely `0x2A SET_GAIN_MIC`" | `11` §14.2, §21.2; `symbols` comment on `set_tx_gain_reg44` | The dispatch table puts `+0xAAD8` at **`0x8A`**; `0x2A` is `+0xABAA` → `+0xA1DC` (this chapter §3; `V076` §3 agrees) |
| 2 | `+0xABF2` (3-byte BE ID setter) is "0x28 ENHANCE or SMS target" | `11` §14.2 | It is **`0x89`**, and it does not reply (§3) |
| 3 | `+0xAB3E` (bits of `0x38EF0`) is "a mode toggle (0x2F LISTEN / 0x31 PWR-SAVE class)" | `11` §14.2 | It is the **`0x36` host ack** (§3, §4.17); `V076` §3 agrees |
| 4 | The dispatch table "is not in the image (filled by the external component)" | `11` §14.2; ch. 19 §1 table ("jump tables live in RAM") | It is in the file at `+0x38240` (XIP `0x03052240`); the old reading assumed link base 0 (results R3a2, R4l; `symbols` `phone_dispatch_table`) |
| 5 | Band limits "400–520 MHz or 136–174 MHz" | `11` §13.1; ch. 18 FW4 | Bench `0x23` limit on the Armor is 136–174 / 400–**480** for the lower edges tested; the 480–520 part is untested on the Armor; the W6 DMR variant acked 480.005/485 (CLAUDE.md §3; `docs/w6-dmr-status.md`). The `0x23` handler's own literals were not read |
| 6 | The getter `0x2404` is "the upstream `groups[]` match result"; at `0xC1BA` "flag==0 → MUTE", status 10 = "SEND_START group", 11 = "SEND_START private" | `docs/promiscuous-rx-patch-spec-2026-10-24.md` Patch A | The listing posts **status 1** (`RECEIVE_START`) when the getter is 0 and status 10 when it is non-zero; at `0xC244` status 2 vs 11. Codes 10/11 are the OEM's MIX_CHECK_DIGITAL pair, not SEND_START (§7.2) |
| 7 | CTCSS table "50 entries from `+0x366B2`" vs the OEM's 51-entry list starting at 62.5 Hz | `11` §18 vs `02` §5 | Either index 0 = 62.5 Hz at `+0x366B0` (table of 51) or the OEM index is off by one against the firmware; not settled (§12) |
| 8 | The `0x22`/`0x23` success returns "leave the busy byte at 1", and "fifteen seconds after a symbol key, the select's flag is still set" | results 13:59, 14:18 | FW41-D read `0x32457` = **0** right after a select (and +1 s, +10 s), with A = 0 or 1 and B = 0 or 200 (results 14:30 table). Either the select did not run a full `0x23`, or another writer clears it. The 07:58 FW55 explanation rests on the static model |
| 9 | "Command `0x3D` is not in this image" | results (M17 R-series, "No M17 frame was sent. Command `0x3D` is not in this image") | `0x3D` has a factory handler at `+0xAAFE` (results R4l; this chapter §3) |
| 10 | "firmware caps a keyed TX at 30 s" | SignalDeck `RE.ptt` javadoc | No 30 s cap; 0 = off, start-up 120 (CLAUDE.md §3; results FW19). The comment is stale |
| 11 | "SignalDeck's boot handshake sends `setTot(0)`" / "SignalDeck is to send 120" | CLAUDE.md §3; `reviews` FW19 review | `RE.bootHandshake` now sends `setTot(120)` (code wins; the CLAUDE.md sentence is stale) |
| 12 | `0x2F` monitor 1 = "hear every decodable digital call" | `RE.setMonitor` javadoc | The handler only drives the mute/squelch path (`+0x37F4`); DMR admission not shown (§4.14) |
| 13 | `SquelchMessage` "firmware coerces non-zero → 2"; "only 0/2 honoured" | `02` §3.12, §5 | The MCU stores 0–9 as sent; 1–9 behave as one threshold on air (`11` §15, §17) |
| 14 | Reply layout `68 cmd sr 00 …` from `reply_build` | `11` §14.2 | The argument goes to byte 2 (rw); byte 3 (sr) is always 0 for data replies (§2.2) |
| 15 | `+0x1924` is "unlock / mutex release" | `symbols` | results FW45-D2 says it "takes the semaphore at `0x390D4`"; in `+0xE9C` it is the event post; post vs pend not settled (§12) |
| 16 | `0x30` 12.5/25 kHz pair: "the AT1846S DMR tune writes `0x30` = `0x4026` against `0x4006` for 12.5 kHz" | ch. 19 §22 | `11` §21.2 and ch. 19 §23: DMR uses `0x4006` → `0x4026` (both 12.5 kHz); 25 kHz is the `0x70xx` pair on FM |
| 17 | Armor checksum: "recomputes the one's-complement checksum" (implying a check) | `11` §14.2 | The return value is overwritten; a bad checksum is not refused on the Armor (§2.3) — listing reading, not bench-tested |
| 18 | `0x27` handled as "a status query"; `0x37`/`0x33`/`0x35` grouped as "1-byte enum commands" | `11` §14.2 | Now named individually (§3); `0x38` is a plain sr-1 ack, not an enum command |
| 19 | `0x22` "success path `+0x9540`: ACK, clear a byte at `*(0x3244C+0xB)`" | `11` §13.1 | results 13:59 traced the long success return past that clear: the busy byte stays 1 on success (§5.1) |

---

## 12. Open questions

1. **`0x21` family**: the 35 sub-commands of `+0x8BE4` and the emitted subs 1–4, 16–20 (only 34 = BER score is named).
   Live capture during key-up, channel change and the knock (ch. 19 A3).
2. **Byte `0x38874`** (byte 0) on stock: what sets it, and is it the DMR-vs-FM selector for the `0x26` path?
3. **Busy byte**: who clears `0x32457` after a successful select on the bench (§11 item 8); the three bytes A/B/`0x32458`
   after a stock unkey and after the first `0x22` (results 07:58 next reading); the tick period behind the 80-pass wait.
4. **Mix-check flag `0x38B5C+0xAF`**: its writer (not found statically, promiscuous spec Patch A residual) and whether a
   stock radio ever posts status 10/11; what this means for the FW26 Patch A design.
5. **Checksum**: confirm on the bench that the Armor accepts a frame with a wrong checksum (§2.3), and whether `sr=2` is
   ever sent by this image.
6. **Upper UHF edge**: is 480.005–520 MHz accepted by `0x23` on the Armor? (receive bench only; never transmit there).
   Read the `0x23` handler's frequency literals.
7. **CTCSS index**: does OEM index 0 (62.5 Hz) select `+0x366B0` or `+0x366B2`? A one-tone receive check settles it.
8. **Band byte 0 on VHF**: why it deafens the receiver and survives an app restart (bandwidth profile vs another use of
   the byte).
9. **`0x2F` monitor and DMR**: does monitor 1 change digital admission at all?
10. **Undocumented commands** `0x3D`, `0x3E`, `0x46`, `0x89`, `0x8A`: meaning, and whether any is a debug/memory access
    (ch. 19 A5). `0x88` reset: does it run the boot FM key-up cycle (§6.5)?
11. **`+0x1924`**: post or pend on `0x390D4`, and which task waits on it.
12. **Status 7**: reproduce `CHANNEL_BUSY` with `0x37` policy 1 and a busy channel; status 6: what triggers it (relay
    mode only?); status 12/13 sources.
13. **`0x2C` header**: read `+0xA364` to confirm the 9-byte header is required for private texts (bench says yes) and
    what the `len − 5` path does; confirm the group-text type with an on-air talkgroup text.
14. **Colour code / TS2 / repeater mode / encryption** on air (untested, `11` §19.3).
15. **Mechanism of the sync + direct write pair** that leaves the module radiating nothing (§5.6).
16. **Unanswered status**: what the module does if the host never acks a `0x36` push.
