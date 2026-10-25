# Ulefone Armor 3WT: how its intercom app drives the DMR module (2026-10-25)

Source: one SignalDeck 1.0.0-beta.19 device report from an Armor 3WT owner and the intercom app it contained
(`Intercom_219_privatekey.apk`, decompiled locally with jadx 1.5.6; APK and report stay out of every repository).
The phone runs a LineageOS 21 (Android 14) GSI; the owner supplies the vendor programs and libraries through their own
Magisk module and has widened the app's frequency check to 100–470 MHz. Nothing here was run on a 3WT by us.

## Phone

- MediaTek MT6771, board `s62v71c2k_gq_3wt`, kernel 4.4.146, SELinux enforcing, Magisk 30.7.
- Same ODM family as the Unihertz Atom XL (Agold, board `g63v71c2k…`, see `multi-device-atomxl-findings.md`); the
  intercom app is the same `com.agold.intercom` v2.0 code base, an older build.

## Transport: two local sockets to a daemon that owns the USB MCU

- `/system/bin/extmodule` (from the owner's Magisk module) holds **`/dev/ttyACM0`** (the module behind a small MCU on
  USB, as on the Atom XL).
- The app talks to it over **TCP on 127.0.0.1: port 9980 for commands, 9985 for audio** (the Atom XL uses a HIDL
  service instead).
- Each command frame on the socket gets a 12-byte prefix: `4F FE 2F F1`, `01 00 00 00`, the frame length (4 bytes LE),
  then the MCU frame.
- Start-up: the app sends daemon commands 2 (`resetMcu`), 7 and 1; the MCU answers its own command `0x06` (MCU started)
  and `0x01` (build date `20181221151755`).
- Audio: 48 kHz in the code (32 kHz on builds with `ro.agold.extmodule.32k`), stereo, over the audio socket.

## Frame format

The same MCU envelope as the Atom XL: `7E 96 69 | route | cmd | rw | len (2, BE) | body | checksum (2, BE) | 81`
(one's-complement checksum from `route` to the end of the body). Verified on all eight complete frames in the log (the 156-byte channel write is cut short there).

## Module: an older command set, no timeslots

- Version: **`ver0.5.4_470M_TONE`** (command `0x25`). The app takes its "legacy" command set because
  `ro.agold.extmodule.dmr09` is not set (the Atom XL's `DMR006` module uses the DMR09 set, which is the Armor 26's).
- Commands seen or built: `0x02` volume, `0x10` call info, `0x11` message content, `0x25` version, `0x35` analog
  channel (15 bytes), **`0x36` digital channel (156 bytes)**; the reply's body `00` = accepted.
- `0x36` body: power, rx frequency (LE), tx frequency (LE), radio ID (BE), colour code, contact type, call number (BE),
  encryption switch, 8-byte key, 32 RX groups (BE) from byte 28. **There is no timeslot field at all**, where the
  DMR09 body (Atom XL, Armor 26) carries inbound and outbound slots. So this firmware's command set cannot ask for a
  Tier II slot; whether the radio chip could do TDMA is not visible from the app (it depends on the module's chip and
  firmware, neither of which is in the report).
- Module firmware update path in the app: newest `*.bin` in `/sdcard/intercom/dmr/`, else (when enabled)
  `/system/data/dmr/`; MCU images in `/system/data/mcu/`. A module image there would show which chip it is.

## Frequency range

- The decompiled build (the owner's modified one) accepts 100 MHz up to 470 MHz (480 MHz with the DMR09 module). Whether the module itself tunes below 136 MHz is unknown: the Armor 26's module rejects anything outside
  136–174 / 400–480 MHz and stays on the old frequency (`0x23` → `sr=1`). On this module the reply byte of `0x35`/`0x36`
  after a write below 136 MHz would tell.
- Airband (108–137 MHz) is AM; this receiver is an FM discriminator, so AM is only heard by accident (a strong carrier
  slightly off-frequency gives some slope detection). 136.000–136.975 MHz is airband too and inside the usual VHF range,
  which may explain the rare receptions. A real AM path would need the receiver chip's AM mode, if it has one.

## To ask the 3WT owner

- The Magisk module (for `extmodule`, its libraries and any `/system/data/mcu` or `/system/data/dmr` images): it is
  what owns the radio on this ROM and what SignalDeck would have to replace or talk to. Keep it private.
- Whether `/sdcard/intercom/dmr/` or `/system/data/dmr/` holds a `.bin` on the phone.
- For the frequency question: the app's log line after saving a channel below 136 MHz (`parseCmd strCmd:7E 96 69 01 35 …`
  or `… 36 …`); body `00` = accepted, anything else = refused.
