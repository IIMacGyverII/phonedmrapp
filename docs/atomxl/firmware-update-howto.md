# Unihertz Atom XL: updating the radio module firmware (state 2026-10-29)

**Status: no working route yet.** The manufacturer's own update route fails on the phone tested here (bridge
`20201016161541`, module `DMR006.U4A.V067`). This page says what the route is, how it fails, how to recover, and what
is still open. Details and logs: `PHASE_A_FINDINGS.md` §9 and §10.

## What the phone ships

- **Radio module:** a DMR module behind a USB bridge MCU (STM32). It reports its version over the radio protocol
  (`0x34`, e.g. `DMR006.U4A.V067`).
- **Update image in the ROM:** `/vendor/data/dmr/DMR006.U4A.V076.bin` (358 100 bytes, sha256
  `4f5f287bef875fad4a5c8ca9a94c9e841a21f5b507f2cc2a0645d5947e4d40fe`). The stock app installs it automatically only
  when its preference `dmr_update` is 1, which it is not on the phone tested.
- **Bridge firmware in the ROM:** `/vendor/data/mcu/20201016161541.bin`. This is a separate updater (STM32 DFU via
  `dfu-util`); this page does not cover it.

## The manufacturer's route

1. Put the image file in `/sdcard/intercom/dmr/`, named exactly like the image (`DMR006.U4A.V076.bin`). The stock app
   (`com.agold.intercom`) flashes **any** `.bin` there whose name differs from `<module version>.bin`, with no other
   check.
2. Open the stock app normally. Have the charger on and the battery above 50 %, and don't touch the phone. It shows
   "Update DMR", and its own timer gives up after 240 s.
3. Afterwards the module should report the new version, and the folder should be removed. Otherwise the app tries
   again at every start.

Inside the vendor HAL (`update_dmr_firmware`), the update powers the module off through the bridge (`00 10 00`), holds
PTT (`handle_ptt` 0), switches the bridge to update mode (`00 08 01`), powers the module on (`00 10 01`), sends `'1'`,
waits for the bootloader's `C`, then sends the image by YModem-1K inside bridge envelopes. When the `/sdcard` copy is
unreadable to the HAL, it reads `/vendor/data/dmr/<same name>` instead.

## Why it fails on this phone

On bridge build `20201016161541`, the module-on command `00 10 01` **does not power the module back**. Measured: the
module stays silent for at least 30 s after it, while the bridge keeps answering; only a power-cycle of the whole bridge
brings the module back. So the module is off when the HAL sends `'1'`, the bootloader never answers
(`Ymodem_Transmit cCount = 0`), and after 240 s the app reports the update as failed. **No data is written**: the module
keeps running its old firmware.

## If you tried it and the app now says "Device init failed"

1. Don't tap through repeatedly. **Remove `/sdcard/intercom/dmr/`** (or the `.bin` in it), so the app stops retrying.
2. **Restart the phone.** The failed update leaves the vendor HAL in an "updating" state that only a restart clears.
3. Open the stock app. It should start normally and work on the old firmware.

Also: never force-stop the stock app to make it look at a new file. Its HAL keeps a callback to the killed process and
crashes on the next start (seen on the first attempt); restart the phone instead.

## What is open

- A route that powers the module up correctly for the bootloader is not established. A bench investigation is queued
  (managing agent's queue, item 6: a written plan first; **the owner decides any real load**).
- Whether other Atom XL units, with other bridge builds, update fine through the stock route is unknown.
- SignalDeck never creates `/sdcard/intercom/dmr/`. Its Hand back warns when that folder holds firmware files, because
  the stock app would try to load them.
