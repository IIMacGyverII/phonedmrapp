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

## Possession and protection of the stock firmware (owner, 2026-10-25)

SignalDeck **holds** the stock image for the user's module and **protects** it. Three sources, in this order, all
hash-checked against the known-image table: (1) the updater asset in the stock APK installed on the phone; (2)
SignalDeck's own copy in app-private storage (`files/firmware/factory-<version>-<sha8>.bin`), written the first time
a supported module is seen and mirrored to `Download/DMR/Firmware/` so the user can see and copy it; (3) the
signed firmware catalogue (below), from which the factory image itself can be downloaded again. Rules: the
private copy is verified at every app start and before every load, re-derived from (1) or (3) when missing or
corrupt, never offered for deletion in the app, and kept across app updates (it does not survive an uninstall,
which is what (2)'s Download mirror and (3) are for). A non-factory image is never flashed unless a hash-verified
factory image for that module's version string is present on the phone first.

## Flashing a downloaded copy (owner, 2026-10-25)

A **signed firmware catalogue**, published like the profile list (same offline key and `serial` discipline,
verifier shared with `ProfileRegistry`): one row per image with its version string, the base vendor image it was
built from, SHA-256, size, download URL (a GitHub release asset), and a one-line statement of what it changes. The
factory image is a row of its own, so a user whose stock app is gone can download it. SignalDeck downloads, checks
the hash and the signature, stores the file beside the private factory copy, and only then offers it; a row is
offered only when its base matches the module's version string (in recovery, the phone model and the stock APK's
asset). Once the files are present nothing needs the network. **Recovery mode:** a module that does not answer
`0x34` but answers the update handshake may be flashed with the factory image only, from the catalogue or the
private copy, after an explicit warning; that is the "user had to download a new copy" case.

## The loader itself

Today every load, bench and factory restore alike, runs through the stock app's updater: SignalDeck releases the
UART, the stock app is enabled, the image is placed at `/sdcard/DMR/DMRDEBUG.bin`, the stock app is launched, its
YModem log is watched for `onSuccess`, the file is removed and SignalDeck takes the radio back
(`tools/fw-patch/bench/fwload_stock.sh`). SignalDeck has no loader of its own. Two paths, both needed:

- **Path A, the stock updater driven by SignalDeck** (with root, exactly the bench sequence, with the log watched
  from inside the app). Proven, quick to build, and the right first implementation of the page. It depends on
  the stock app being installed.
- **Path B, SignalDeck's own YModem sender** over the UART it already owns, written from the YModem standard and
  the handshake observed on the wire, not from the decompiled OEM code. Required so that a factory restore never
  depends on the stock app. Reading task for the bench, before Path B is built: how the module enters update
  mode (a command, or a boot-time handshake), the packet size and timeouts it accepts, and what it answers on
  success and failure; proven by loading a bench image and then the factory image through Path B and reading the
  tag after each.

## What the page never does

Load an image without a table row; load onto a module whose three identities disagree; load without the backup
file present; offer band-limit or power changes; stay silent about what an image changes (the help topic says it,
including the 120 s time-out and that the image persists across reboots).

## Reading task (bench, one session, before Phase E is built)

Search the stock image for any path that returns memory contents over the UART: the YModem loader's verify or
read side, `0x21` subcommands, the `0x3D` handler, the debug-packet path. If one exists, a pre-load dump of a
stock module becomes possible and the backup becomes the module's own bytes, not the vendor's copy; the finding
either way goes into this file.

## Reading session (2026-10-25) — update handshake and stock read-back

No new image was loaded. FW22 stayed in the module. The handshake is the one every bench load already completes;
the stock image was read from the repository, not re-probed with a forbidden command.

**How the module enters update mode.** There is no UART "enter bootloader" command. `YModemManager.startUpdateFirmware`
releases the packet reader and writer, then `ReadFileUtils.setDmrUpdateCondition` knocks the GPIOs:
`/sys/devices/platform/dmr009/pwd` down, 50 ms, `/sys/devices/platform/dmr009/ptt` down, 50 ms, pwd up, 1000 ms,
ptt up (`ReadFileUtils.java` 120–141). The sender then writes the one byte `0x31` (`"1"`, `YModemUtil.getYModelData`)
and waits. The module answers `C` (`0x43`). The phone sends a 128-byte SOH block 0 (name, NUL, decimal size; no MD5,
because `YModemManager` never sets `checkMd5`). The module answers `ACK` then `C`. Data blocks are STX, 1024 bytes,
sequence and complement, CRC-16-CCITT. A short tail is SOH. Each block waits at most 15 s and is retried at most 6
times; `NAK` resends, `CAN` aborts. After the last block the phone sends `EOT` (`0x04`) and then a 128-byte end
block. Success is one `ACK`. The `MD5_OK` / `MD5_ERR` strings in `handleEnd` never run, because `onReceiveData`
ignores any reply longer than 2 bytes. The phone is the YModem sender only. Nothing in this path asks the module
for a block.

**Stock read-back.** Nothing in the stock image returns flash.

- Commands `0x24` and `0x25` return the last digital channel (163 bytes at `0x38E4C`) and the last analog channel
  (19 bytes at `0x38C70`). That is the programmed channel, not the firmware (`docs/grok-deep-dive/11-firmware-fw0-results.md` §14.2).
- Command `0x21` is a second family (`family21_dispatch` at file `+0x8BE4`, 35 entries, jump table in RAM
  `0x030520D8`). The module emits short `68 21` frames (subcommands 1–4, 16–20, and 34). Subcommand 34 is a 6-byte
  BER score. The OEM app drops the family. It is not a dump.
- Command `0x3D` has a real handler (`cmd3d_handler` at file `+0xAAFE`). The app never sends it, and it is not
  replaced. Nothing in the handler's known callers copies a flash range into a reply. It was not probed on the air.
- The YModem path has no read or verify side.

A stock module therefore still cannot be dumped before the first load. The backup remains the vendor asset from
that phone. After our own image is in, opcode 12 (FW22) is the dump; a full pass is 378,620 bytes and took 971 s
at 57600 baud, so the loader page does that in the background, or checks the tag plus a sample and offers the full
read.

## Decision after the reading session (review, 2026-10-25)

Path B first: the knock and the handshake are fully known and SignalDeck already owns the GPIO and the UART, so its
own sender is the smaller and the more useful piece; Path A is the fallback. The bootloader verifies nothing, so
the table hashes are the only guard. Recovery after an interrupted transfer is a pass criterion, proven on the
bench before the page ships. Pass lists for both steps are in `reviews.md`, "Review of the Phase E reading sessions".

