# Loader safety: what SignalDeck must do before, during and after a module firmware load

Owner's direction, 2026-10-25: a firmware loader in SignalDeck (ch. 19 Phase E, route-list item 4) needs
comprehensive safety. Two requirements named by the owner: **a copy of the user's own module firmware must exist
before anything is flashed**, and **where several firmware versions exist for one phone model, the differences must
be known before flashing**. This file is the contract the Phase E page is built and reviewed against.

## The two hard facts the design rests on

1. **The vendor's copy of the module firmware is on the user's phone.** The stock app ships it as an updater asset
   (`assets/DMR003.UV4T.V022.bin` in the Armor's PriInterPhone; the YModem manager also accepts
   `/sdcard/DMR/DMRDEBUG.bin` as an override). Our factory image is that file (378,620 B, MD5 `44260353…9e268e0`).
2. **The module has no read-back command.** Nothing in the stock protocol returns flash contents, so the firmware
   actually inside a stock module cannot be dumped before the first load. After the first load, a read op in our
   own image can dump the flash (see "Read-back", below), but by then the original is gone. The backup for a stock
   module is therefore the vendor's copy, taken from the user's own phone, and the identity checks below are what
   justify treating that copy as the backup.

## Before the first load: identity and backup

- **Identity, three ways, all must agree with one row of the known-image table:** (a) the module's `0x34` version
  string; (b) the SHA-256 of the updater asset extracted from the stock APK installed on that phone, and the version
  string inside that asset; (c) the phone model and the stock app's package and version. A table row holds those
  values for one vendor image, plus the patch set built for it. **Any disagreement refuses the load** and offers
  the device report instead (that report is how a new variant reaches us).
- **Backup = the vendor copy from the user's phone,** saved as `Download/DMR/Firmware/factory-<version>-<sha8>.bin`
  with its hash in a sidecar, before any other image is written. The restore button uses that file, never a
  download. If the stock APK's asset cannot be read (stock app removed, split APK, unknown layout), the page refuses
  until the user restores the stock app; our own copy of the same image, hash-matched, is the fallback only when
  the module's version string matches it exactly.
- **Variants.** Different modules under the same phone name are expected (the Armor's `DMR003.UV4T.V022`, the Atom
  XL's `DMR006.U4A.V082`; other builds of either are possible). Rule: **no patch set is applied to an image we do not
  hold byte for byte and have diffed against the one the patches were made on.** The port automation
  (`plan-port-automation.md`, stages 2–3) is how a new variant gets its own symbols and a rebuilt patch set; until
  that is done the page shows "firmware variant not yet supported" and nothing else is enabled. The device report
  (Run all checks) collects (a)–(c) from every tester, so the variant table grows before the page is offered for a
  model.

## Pre-flight, every load

Module answers the version query; not transmitting and no scan or data mode running; the stock app disabled;
battery above 40 % and charging or above 60 %; the image file's SHA-256 matches its table row; the factory backup
file present and hash-verified; the phone not about to sleep (wake lock); Wi-Fi ADB irrelevant. Any failure stops
before the first YModem byte.

## During

The proven sequence only: the stock app's YModem path, one image, the success callback awaited, no retries without
a fresh pre-flight. Progress on screen. No other radio traffic from SignalDeck during the transfer.

## After, every load

Module power-cycle, `0x34` read, the tag compared with the loaded image's tag. **Mismatch or no answer: factory
restore immediately from the backup file, then the version check again.** Only a verified tag enables the
image's features (the existing gating). The result, both hashes and both tags go into the app's history and the
device report.

## Read-back (adds a measurement the bench does not have today)

Every bench image from FW21 on carries a **flash read op** in the `0x40` extension: a file offset and a length
(≤ 240 bytes), the reply in the op 4 style. With it: (1) after any load, the page dumps the whole image and
compares it with the file it sent, which proves the loader wrote what it was given; (2) a module whose tag is a
bench image can always be dumped, so the port automation can read exactly what is in a given module; (3) the
Atom XL's first bench image, once its loader is captured, dumps its flash the same way. It cannot recover a stock
module's original: that is what the identity checks and the vendor copy are for.

## What the page never does

Load an image without a table row; load onto a module whose three identities disagree; load without the backup
file present; offer band-limit or power changes; stay silent about what an image changes (the help topic says it,
including the 120 s time-out and that the image persists across reboots).

## Reading task (bench, one session, before Phase E is built)

Search the stock image for any path that returns memory contents over the UART: the YModem loader's verify or
read side, `0x21` subcommands, the `0x3D` handler, the debug-packet path. If one exists, a pre-load dump of a
stock module becomes possible and the backup becomes the module's own bytes, not the vendor's copy; the finding
either way goes into this file.
