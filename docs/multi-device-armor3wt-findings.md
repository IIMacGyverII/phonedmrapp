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

## The owner's Magisk module (read 2026-10-25)

The owner sent the Magisk module (v2.2.2) that installs the intercom app on their ROM. It stays private, like the APK.
It contains:

- `service.sh` starts `/system/bin/extmodule` at boot. It also starts two shell loops that run `getevent` on
  `/dev/input/event1`, look for scancode `00f9`, and send `android.intent.action.PTT.down`/`up` with
  `-p com.agold.intercom`. That broadcast goes only to the stock app, which is why no PTT reached SignalDeck.
  Thirty seconds after boot, `service.sh` sets `settings secure usb_audio_automatic_routing_disabled 1`.
- `extmodule` (aarch64, 69 KB) works like this:
  - It opens `/dev/ttyACM0` for commands and `/dev/stmcu` to read the call-in state.
  - It drives the sysfs files in `/sys/bus/platform/drivers/mcu/`: `mcu_power`, `rstmcu`, `handle_ptt` and `usb_path`.
  - It powers the audio codec on and off with `echo 1` / `echo 2 > /dev/ttyTTCMD`.
  - It moves audio through the ALSA devices `/dev/snd/pcmC1D0c` and `pcmC1D0p`, using its own small tinyalsa.
  - Its control commands are 1 start, 2 stop, 3 PTT start, 4 PTT stop, 7 MCU start, 10 DMR firmware update. The app
    confirms those six. From the order of the daemon's strings, 5/6 are most likely USB on/off, 8 MCU stop and 9 MCU
    update.
- `extcmdtest` is a small tool that sets the same four sysfs files (`-p` power, `-r` reset, `-h` PTT, `-u` USB path).
- `auto_update` and `dfu-util` reflash the phone-side MCU. The script holds the MCU in reset with `extcmdtest -u1 -r1
  -p1`, then runs `dfu-util -d 0483:df11 -a 0 -s 0x08000000`. **So the phone-side MCU is an STM32** (ST's DFU boot loader,
  flash at `0x08000000`).
- `/system/data/mcu/` holds six STM32 images, dated 2017-09-19 to 2018-12-21. The newest, `20181221151755`, is the
  build date the MCU reported. These are images for the phone-side MCU only; **there is no DMR module image**, so the
  module's chip is still unknown.
- The newest MCU image enumerates as USB `0483:5730`. Its strings include "Agold Audio Class", "AUDIO Interface" and
  "Agold_WX". **The MCU is a composite USB device: a CDC-ACM serial port (`ttyACM0`) plus a USB Audio Class sound card
  (card 1).** That card carries the radio audio, which is why `service.sh` turns off Android's automatic USB audio
  routing: without it, Android would send phone audio to the radio. The Atom XL's HAL very likely uses the same
  device.
- DMR module update (`extmodule`): stop the module, hold PTT, enter update mode, start the module, then send the newest
  file in `/storage/self/primary/intercom/dmr/` with YModem. This is the same scheme as the Armor 26's `dmr009` knock
  with PTT held, so the 3WT's module may be from the same HR-C7000 family. That is a guess until a module image or a
  version reply in the `DMR00x` format turns up.
- A key layout, `Vendor_2454_Product_6500_Version_0010.kl` (the MediaTek keypad, `mtk-kpd`), maps scancode 249
  (`0xf9`, PTT) to `PROG_RED` (keycode 183) and 250 to `PROG_GREEN` (184), under an "agold add" comment. If the GSI
  loads that file, PTT reaches apps as key 183. The report saw no key event, so either the overlay is not loaded or the
  key goes only to `getevent`.
- The module also ships the WebRTC noise-suppression, AGC, AEC and VAD libraries the app uses.

What SignalDeck would need on this phone (not started):

1. Talk to `extmodule` on 9980/9985 with the 12-byte prefix (the smallest step, since it keeps the owner's module), or
   stop it and open `ttyACM0`, the four sysfs files and USB audio card 1 itself.
2. The legacy command set inside the `7E 96 69` envelope.
3. PTT: key 183 if the layout is loaded, otherwise a root `getevent` reader for scancode `0xf9`. The stock broadcast
   names its package, so SignalDeck cannot share it.

## Frequency range

- The decompiled build (the owner's modified one) accepts 100 MHz up to 470 MHz (480 MHz with the DMR09 module). Whether the module itself tunes below 136 MHz is unknown: the Armor 26's module rejects anything outside
  136–174 / 400–480 MHz and stays on the old frequency (`0x23` → `sr=1`). On this module the reply byte of `0x35`/`0x36`
  after a write below 136 MHz would tell.
- The intercom app accepts 100–470 MHz; the module's own range is not measured.
- Airband (108–137 MHz) is AM; this receiver is an FM discriminator, so AM is only heard by accident (a strong carrier
  slightly off-frequency gives some slope detection). 136.000–136.975 MHz is airband too and inside the usual VHF range,
  which may explain the rare receptions. A real AM path would need the receiver chip's AM mode, if it has one.

## To ask the 3WT owner

- ~~The Magisk module~~ (received 2026-10-25, read above; no DMR module image in it).
- Whether `/sdcard/intercom/dmr/` or `/system/data/dmr/` holds a `.bin` on the phone.
  - 2026-10-26: the owner's `/system/data/mcu/` copy (six files) is byte-identical to the Magisk module's six MCU images
    (SHA-256 `8317def5…`, `4f1d9168…`, `256f28d8…`, `c74dad8d…`, `3458ae05…`, `1a782434…`); no DMR module image found on the
    phone yet. Files kept private, outside the repo.
  - Ways to the DMR image, best first: (1) Ulefone's stock ROM for the 3WT (`system.img`: `/system/data/dmr/`, and the
    intercom APK's `assets`/`res/raw`); (2) SignalDeck's Radio firmware files list on the phone (folders + stock APK);
    (3) a stock-app update that ships one; (4) reading the module itself only if its firmware has a read command (the
    Armor 26 stock image has none) or over the module's SWD pads (hardware, not for a tester).
  - 2026-10-26, route (1) done: Ulefone's stock ROM `2020111910_s62v71c2k_gq_wteea` (MT6771; owner download, kept
    private) has **no DMR module image**. `system.img` holds `/system/data/mcu/` (the same six images, same hashes) and no
    `/system/data/dmr/`; `system/app/Intercom/Intercom.apk` carries only sounds; `vendor.img` only the `agolddaemon` HAL.
    `extmodule` (69,104 bytes) reads the update file only from `/storage/self/primary/intercom/dmr/`; its DMR path is
    stop, PTT, enter update mode, then `Ymodem_Transmit` (send only). `update_dmr_firmware_read` is the thread that reads
    the module's replies during an update, not a flash read. So the image exists only in the module and with Ulefone;
    on stock firmware no command reads it back (as on the Armor 26). Remaining routes: ask Ulefone support for the
    module update file, or a phone whose `/sdcard/intercom/dmr/` was ever given one.
  - 2026-10-26, the 2019 stock ROM `2019101717_s62v71c2k_gq_wteea` (owner download, kept private): the same. No module
    version string in any partition image, `/system/data/` holds only `mcu/` (the same six images), `Intercom.apk` (a
    different build) carries only sounds and looks for updates in `/sdcard/intercom/dmr/` (`getLastestDmrFirware`),
    `extmodule` is byte-identical to the 2020 build's. Two stock ROMs a year apart: the module image was never in the ROM.
- For the frequency question: the app's log line after saving a channel below 136 MHz (`parseCmd strCmd:7E 96 69 01 35 …`
  or `… 36 …`); body `00` = accepted, anything else = refused.

## 2026-10-30 review (Armor 3WT agent)

Full reading in `docs/armor3wt/stock-app-review.md` (intercom app decompiled again, `extmodule` disassembled with the
NDK's `llvm-objdump`); SignalDeck PR #175 implements it. What it adds to or corrects in the notes above:

- **Both APK copies are the same code.** The report's `Intercom_219_privatekey.apk` and the Magisk module's
  `Intercom_219_signed.apk` decompile identically (only the signatures differ). The 100–470 MHz range is in both, so whether
  the owner or the vendor widened it is not visible.
- **The socket header's type word:** 0 = a daemon control (one LE word), 1 = data (an MCU frame on 9980, PCM on 9985).
  The daemon's replies come back the same way. It accepts up to 10 clients per port but sends what it reads from the
  bridge **only to the client that wrote last**, so the stock app must be stopped while another program uses it.
- **Controls confirmed in the daemon's switch** (`0x71d8`): 5/6 USB path on/off, 8 MCU stop, 9 MCU update (the guesses
  above were right). Control 2 also powers the MCU off.
- **Legacy command table, corrected:** the text **send** is `0x07` (type 2 private / 9 group, call number 3 bytes BE,
  UTF-16LE, 4 zero bytes); `0x11` is the **fetch** (sender 3 bytes BE + text); a `0x07` push with body `0x70` announces a
  waiting text. Receptions start and end with the module's `0x04` push (body 0/2 start, 1/3 end), not via `/dev/stmcu` as on
  the Atom XL (the daemon reads that node itself). The `0x10` call-info reply is **never parsed** by the app, so the stock
  app shows no caller ID on this phone. The app has **no RSSI command**.
- **Channel value encodings:** analog band 0 narrow / 128 wide, power 0/1, tone type 1 none / 2 CTCSS / 3 DCS / 4 DCS
  inverted plus a list index; digital contact type 1 private / 2 group / 4 all call (`0xFFFFFA`), encryption 1 on / 255 off.
  The channel editor hides the slot setting unless `ro.agold.extmodule.dmr09` is set.
- **Transmit:** daemon control 3 (PTT) and audio control 1 together with the microphone frames, release 500 ms later
  (1 s with the end tone): microphone off, control 4, audio control 2. The module gets no key command.
- **Side key:** the report's `getevent` shows scancode `00f9` on `mtk-kpd` (`/dev/input/event1`); no keycode reached the
  app, so the key layout overlay is most likely not loaded on the GSI.
- **The bridge on this phone is the same as the Atom XL's** (the same `mcu/` sysfs files, `ttyACM0`, `/dev/stmcu`, card 1).
  So SignalDeck's direct Atom XL route would also work in principle. It is kept as the fallback because `extmodule` runs
  beside it from the owner's module.
