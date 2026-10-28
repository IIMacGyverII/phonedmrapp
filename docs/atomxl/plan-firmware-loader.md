# Atom XL: loading module firmware through SignalDeck (plan only, 2026-10-28)

**Status: a plan for the managing agent and the owner. No image is loaded, the module's update mode is not
entered, and nothing here is built until the owner decides the question in §3 and the managing agent reviews this
(after the Armor's firmware work).** It applies `radio_firmware/plan-loader-safety.md` (the loader contract) to the
Agold USB-bridge phones. Facts: `docs/atomxl/PHASE_A_FINDINGS.md` (cited as §n).

## 1. Where the Atom XL breaks the contract's assumptions

The contract rests on two facts. On the Atom XL the first one does not hold:

| Contract | Armor 26 Ultra | Atom XL (bench unit) |
|---|---|---|
| The vendor's copy on the phone is the module's image | yes: `DMR003.UV4T.V022` in the stock APK = the module's `0x34` | **no**: the vendor partition holds `DMR006.U4A.V076` (`/vendor/data/dmr/`), the module answers `DMR006.U4A.V067` (§2, §6) |
| The module has no read-back | yes | yes: the stock app and HAL only send; the bootloader stays silent until keyed (§9, §10) |
| Backup = the vendor copy, identity three ways | works | identity (a) `0x34` = V067 and (b) the asset = V076 **disagree**, so the contract **refuses the load**, as it should |

So, by the contract as written, SignalDeck refuses every load on this unit, and that is correct: a load would
replace V067, of which no copy exists anywhere (every partition but userdata searched, §6), with no way back.

Another unit reported V082 with the same vendor V076 (two owner reports, 2026-10-24): the module version differs per
unit, and the vendor copy matches none of the two units seen.

## 2. What a load would be on this phone (read from the HAL, §9; not run)

The stock updater's path, which SignalDeck's own YModem-1K sender (proven on the Armor, Phase E) would follow over
`/dev/ttyACM0` with the HAL stopped:

1. bring-up as for take-over (`usb_path` 1, `mcu_power` 1, 0.75 s, `rstmcu` 0, the port, 115200 raw);
2. bridge `00 10 00` (module off), 4 s; `handle_ptt` 0, 2 s; bridge `00 08 01` (update mode), 2 s; bridge `00 10 01`
   (module on), 2 s;
3. `'1'`, wait for six `C`, then YModem-1K (block 0 with name and size, 1024-byte blocks, CRC-16-CCITT, `EOT`, the end
   block);
4. release PTT, power-cycle the bridge (it leaves update mode only that way, §8), bring-up, `0x34`.

Differences from the Armor: the knock is bridge frames and `handle_ptt` instead of the `dmr009` GPIOs; the bridge
must be power-cycled to leave update mode; transmit and receive of the module are behind a USB device that also
carries the phone's USB port (radio on = no USB to a computer, §1).

Unproven: that `00 10 01` with PTT held and update mode on really starts the bootloader (outside update mode it does
not bring the module back, §8, §9), and the bridge's behaviour if the transfer stops halfway (the Armor's recovery,
"knock again", is proven there only).

## 3. What the owner must decide

**May this unit leave V067 for good?** Options:

- **No (default).** The loader stays refused on the Atom XL. Firmware work on this model waits until a module image
  that a unit actually runs exists as a file (V067 or V082, from Unihertz, a later OTA or another source).
- **Yes, V076 as this unit's baseline.** V076 is Unihertz's image for this model and the stock app would install it
  itself if it found it in its update folder (it flashes a file whose name sorts after the running version, §6).
  After one load of V076, verified by `0x34`, this unit's backup is V076 (the vendor copy then matches the module), the
  contract holds again, and the managing agent's normal process applies: diff, symbols, patch set, tags, restore =
  V076. The cost: V067 is gone, and this unit no longer represents a stock V067 phone for testing.

Either way, users' phones: the loader offers an image only when the module's `0x34` matches a table row whose image we
hold byte for byte; V067 and V082 users are refused until those files exist. The variant registry
(`devices/unihertz-atom-xl/variants.json`) already lists V067 and V082 as seen, not supported.

## 4. How the contract's guards apply (if the owner says yes)

- **Identity:** (a) `0x34` through the bridge (the report's probe, SignalDeck PR #64); (b) the SHA-256 of
  `/vendor/data/dmr/*.bin` read as root (the Atom XL keeps it on the vendor partition, not in the APK); (c) model
  `Atom_XL`, `com.agold.intercom` 2.0, and **the bridge version** (route 00 `0x01`, `20201016161541`) as a fourth
  field, because the bridge carries the transfer.
- **Backup:** the vendor copy, but only where (a) and (b) agree (V076 module + V076 file). The first V067 → V076 load
  is the owner's one-time exception, logged as such, and not a path the page offers users.
- **Pre-flight:** the contract's list, plus: the HAL stopped, the stock app disabled (it reflashes the bridge when its
  version query goes unanswered, §7), the USB cable irrelevant (the PC loses the phone anyway), Wi-Fi ADB not needed.
- **During:** nothing else on `/dev/ttyACM0`; the engine's reader paused (as on the Armor).
- **After:** release PTT, bridge power-cycle, bring-up, bridge version and `0x34`; mismatch or silence → restore from
  the backup with the same path; then the release sequence and the HAL back, with the bridge check before the stock
  app is enabled.
- **Transmit check after a load:** owner's, in the cage, with the HackRF receiving.

## 5. What is needed before any of this is built

1. The owner's decision (§3).
2. The managing agent's review, after the Armor's firmware work.
3. A capture of one stock update on a unit whose loss is accepted (owner's decision), or the first SignalDeck load,
   with the bridge's frames logged, to prove §2's entry and the recovery from a stopped transfer.
4. Host tests for the entry sequence and the guards; the page's existing pass list extended with the bridge cases.
