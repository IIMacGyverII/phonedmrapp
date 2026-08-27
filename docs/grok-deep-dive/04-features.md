# 04 — Features worth building

Order: **OEM already speaks the packet** first (small surface, real radio value), then product features that need design, then decoder work. Nearby Repeaters and packet-radio RX rework already have Claude designs (ch. 16, 15) — summarized here, not rewritten.

Do not start any of this until HEAD (`ba6431cb`) is built and the five CHANGELOG regressions pass.

---

## A. Firmware features the OEM hid

### A1. Radio Check / Call Alert / Remote Monitor

`EnhanceMessage` (`app/.../message/EnhanceMessage.java:12-16`):

| `fun` | Name | OEM UI |
|---|---|---|
| 1 | CHECK | none |
| 2 | CALL_PROMPT | none |
| 3 | REMOTE_MONITORING | none |
| 4 | KILL | Settings |
| 5 | REVIVE | Settings |

`DmrManager.enhanceFunction(byte, int)` already sends them. Packet is `fun` + `callNum` int. Add three rows next to Kill/Revive, with a confirmation and a “this is DMR signaling, not a phone call” line. **Device required.** Highest unused DMR value on the radio.

### A2. Make TOT real

Settings already lists 30/60/120. `sendSetTotCmdToMdl()` always writes `tot = 0`. Hook that method, copy the pref, send it. Half-hour job including the test (PTT until timeout).

### A3. Mix-check / dual watch (research first)

`Const.SET_MIX_CHECK_INFO_CMD` (0x38) and `MixCheckMessage` exist. OEM never constructs them. If the MCU actually analog-watches while on DMR, this is a bigger deal than another monitoring dialog. **Do not ship UI until a debug packet (P1.2, gated) proves the MCU ack.** `SET_SPK_EN` (0x3C) has *no* Java builder — same bucket: probe, then decide.

### A4. BER page

The activity exists; the Device-tab row is `visibility="gone"`. A diagnostics overflow is enough. Not a user-facing headline.

### A5. SMS protocol type

`SmsProtocolMessage.type` is always 0. Only worth a toggle if a user reports Motorola vs ETSI SMS interop. Don’t build speculatively.

---

## B. Codeplug / intercom features that remove pain

### B1. Channel list search + filters

OEM list is a `ListView`. Zones already live in `dmrmod_zones.db`. Add a search box and Analog / Digital / Zone chips on the Channels tab. This is how a 200-channel Armor 26 becomes usable without CPS.

### B2. MHz + contact picker + hex key in the editor

Hook the two frequency fields and the encrypt-key field (ch. 03 §6). Write `contact_number` from a picker. Deletes a class of Pitfall 12 mistakes without teaching users the trap.

### B3. Locations keyed by `_id`

Product feature and bugfix (P1.1). Distance-to-repeater on the intercom is the reason locations exist; it is wrong under zone filter today.

### B4. Additive import / undo

Wipe-and-insert is the restore tool. Nearby Repeaters (Claude 16) needs additive `DmrManager.createChannel`. That helper should also be how “import these 12 channels from a CSV slice” works. One `installed` table, one undo.

### B5. Unify recordings

OEM `RecordListActivity` (`/sdcard/interphone/record`) vs module `Download/DMR/Audio/<Channel>/`. Users have two piles. One list, one player, one delete.

---

## C. Packet radio (don’t redesign twice)

Plans and to-dos for **every** addable mode: [08-packet-radio-modes.md](08-packet-radio-modes.md). Claude 15 remains the assessment of *shipped* APRS RX/TX.

Build order from ch. 08: G1 sample layout → streaming HDLC → javAPRSlib → passive decode → APRS-IS iGate/beacon → KISS TCP → stereo TX experiment → then RF apps **or** DMR SMS / external TNC. SAME and DTMF only need G1. No FT8/PSK/9600/VARA on this radio.

---

## D. Nearby Repeaters

Full review: [07-nearby-repeaters.md](07-nearby-repeaters.md). Claude 16 + the two research memos are the implementation spec. Do not re-research endpoints.

Build order is Claude Phase 0 → 1 with these gates:

- Location lookup must key `_id` before the first install (intercom distance is wrong today).
- P0.6: on-air GROUP channel on a local BM TG — gates whether DMR cards are “listen” or “TX memory.”
- BM-only on cellular (1 MB); RadioID/hearham on Wi-Fi after legal OK.
- RepeaterBook stays Phase 4 (token, no radius, no TGs in the API).
- Never `DirectDatabaseImporter`, never `determineBand()`, never `txContact=1`, never ALL-mode channels.
- Device tab, `ListView`/`RecyclerView`, private catalog cache, `area_key` on `installed`.

---

## E. Look-and-feel (from ch. 03)

Treat as a feature with a PR, not drive-by color tweaks:

- Modes sheet instead of six satellites
- One color class
- contentDescription
- LSPosed `v0.2` string
- Cancelable live screens + status chip
- Stop wrapping channel names as a mode flag

---

## F. Hook self-test

Claude C1. At `handleLoadPackage`, resolve every `findClass` / `getIdentifier` / reflected member the module uses; `XposedBridge.log` (and one toast) for NOT FOUND. Two silent failures lived for months (wrong SerialManager, missing `interphone_channel_contact`). Cheap, and it would have caught `APRSSettingsActivity` in the manifest.

---

## G. Do not build

| Idea | Why |
|---|---|
| Hardware LED | MCU only |
| DMR group-call RX | firmware ignores RX group list |
| Software filter for >32 TGs | destination TG offset in 0x2B unknown |
| Squelch 1, 3–9 as hardware | coerced to 2 |
| On-device Whisper/Vosk/TFLite | researched; tflite just removed from the APK |
| UART bootloader flash | `EACCES` on `/dev/ttyS1` |
| Another monitoring mode that hijacks the channel | fix the framework first (P2.1) |
| NDK Dire Wolf | Java PLL exists; NDK is commented out |
| Magisk systemizer / rebuilt OEM APK | signature wall |

---

## H. Feature ideas that sound good and are traps

- **“Scan”** — MCU has mix-check; it is not a conventional amateur scanner. Don’t fake a scanner in software by hopping `syncChannelInfoWithData` every 300 ms (you will lose the state machine).
- **BrandMeister talkgroup list as a live panel** — needs internet + a hotspot, not this radio’s local MCU. Nearby Repeaters already covers static TGs.
- **In-app CPS** — you already have a desktop fork. Don’t clone OpenGD77 into `MainHook.java`.
- **More SSTV modes** until VIS detection is measured on-air with the sample-layout question closed.
