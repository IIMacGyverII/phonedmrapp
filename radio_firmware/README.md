# Radio-module firmware (`DMR003.UV4T.V022`)

Firmware of the DMR module in the Ulefone Armor 26 Ultra (PriInterPhone), the bench record of every modified image, and the files the two AIs use to hand bench work to each other. Rewritten 2026-10-24; the earlier text here described an ARM-Thumb reading at base `0x08000000` that was wrong in every address (ch. 19 §1, "dead ends").

## Facts (verified, with the chapter that proves each)

| Fact | Source |
|---|---|
| Image `DMR003.UV4T.V022-ORIGINAL.bin`, 378,620 B, MD5 `4426035392262ca54583c230c9e268e0`, plaintext, no signature | `docs/grok-deep-dive/11-firmware-fw0-results.md` §9 |
| **C-SKY V2** (T-Head), not ARM; link base 0; uC/OS-III | `11` §12–§13 |
| SoC **HR-C7000**: XIP flash at `0x0301A000`; IRAM `0x00010000` is a boot copy of file `+0x39408`–`+0x5AEFC`; SRAM from `+0x322E0`; the last 1,788 B of the file (`+0x5AEFC`) are zero padding, the only safe place for added code | `11` §21.0, ch. 19 §13–§14, §22–§23 |
| RF IC **AT1846S** (I²C write IRAM `0x2B220` = file `+0x54628`, read `+0x54664`); register `0x58` = `0x8405` analog / `0xBCFD` DMR | `11` §21 |
| **Loads persist**: the module bootloader writes the YModem image to SPI flash; it survives power-cycles and phone reboots. Restore = load the factory file the same way. Every built image carries a four-character tag in its version string, and `0x34` reports which image is in the flash | ch. 19 §13–§14 (FW14) |
| Phone-protocol dispatcher `+0xAA3C`, table at `+0x38240` (XIP `0x03052240`), index `cmd − 0x22`; `0x40` is a free slot (factory handler is an empty `pop`), `0x3D` is a real handler | `11` §14.2, `results.md` R4l–R4n |
| Transmit audio path (FM): phone-side ES8311 → module mic input → AT1846S; below ~250 Hz is cut in analog hardware, so no firmware change opens it | ch. 19 §19 |
| **TX RAM route**: a host-keyed stub drives the HR-C7000 DMR modulator from TX RAM (`0x16000030`, 2 × 256 halfwords, **big-endian**, 8 kHz) and bypasses the audio path. M17 frames decoded on the air at Golay error 0 (R4d–R4k) | `HANDOFF.md` route T1, `results.md` R3a–R4 |

## Workflow (the only one)

1. **Define** the change as a named patch in `tools/fw-patch/patches.toml` (every site records the original bytes) with its stub in `tools/fw-patch/stubs/*.S`. Host tests: `python tools/fw-patch/test_patches.py`.
2. **Build** with `tools/fw-patch/build.py` into `build/` (gitignored; each image is reproducible from the factory file + `patches.toml`). The tag goes into the version string so `0x34` names it.
3. **Load** with `tools/fw-patch/bench/fwload_stock.sh` (the stock YModem path through SignalDeck; tune the VFO to 467.625 MHz first).
4. **Measure** with the HackRF receiving only, then write the run into `results.md` and the handoff state into `HANDOFF.md`.

Rules that are not optional: any stub on the key-up path acts only on a host-requested transmission and does nothing at module boot (the FM key-up runs during boot, ch. 19 §23); the ±5 kHz stop on measured deviation; 467.625 MHz low power only; never a raw flash command, only the YModem path. The full standing approval is in `HANDOFF.md`.

## Files

| File | What |
|---|---|
| `DMR003.UV4T.V022-ORIGINAL.bin` | factory image; the restore file |
| `HR_C7000_user_guide.pdf` | the SoC user guide (Chinese, v2.7, 412 pp.), the "Document 2" the bench notes cite; copy of https://github.com/M17-Project/AtomXL-reverse-engineering/blob/main/docs/HR_C7000_user_guide.pdf (sha256 `d60f652e114d5103…`). FM chapter §7.2 (p. 270), FM registers §11 (p. 331), TX/RX RAM map §11.4 (p. 340), interrupts pp. 93–100. Text extraction needs a CJK-aware tool (PyMuPDF); `pdftotext` drops the Chinese |
| `HANDOFF.md` | mailbox between the AIs: status line, standing approval, current task, route list |
| `results.md` | the bench record, one section per image, newest last |
| `reviews.md` | reviews of bench runs (earlier ones are ch. 19 §11–§23) |
| `symbols.csv` | named file offsets (`fn` / `label`); import/export to Ghidra with `ghidra_scripts/FwCskyImportSymbols.java` / `FwCskyExportSymbols.java` |
| `fw1_csky_objdump.txt` | the C-SKY listing (`csky-elfabiv2-objdump`), regenerable with `scripts/fw1_ghidra_csky.ps1` |
| `ghidra_scripts/FwCsky*.java` | Ghidra C-SKY helpers (seed, stats, region map, symbols) |
| `ghidra_fw1_csky*.log` | Ghidra headless logs of the C-SKY import |
| `results/*.wav` | demodulated voice from the FW17/FW18 response measurements |
| `ghidra_project_fw0/`, `build/` | local only (gitignored) |

Removed 2026-10-24 as wrong-architecture output (the ARM-Thumb reading): `PATCH14.bin`, `cmd_handler.c`, `firmware_decompiled.c`, `firmware_all_functions.c`, `firmware_disassembly.txt`, `firmware_disasm_output.txt`, `ghidra_decompiled/`. The `Fw0*.java`, `FindDMRBug.java` and `find_*_bug.py` scripts are from the same period and are kept only as history. Do not reuse any `0x08xxxxxx` address.

## Where to read next

- `docs/deep-dive/19-firmware-modification-plan.md`: the plan, the reviews up to R3-0, the memory map and the loader analysis.
- `docs/grok-deep-dive/11-firmware-fw0-results.md` §12–§21: the disassembly findings.
- `docs/deep-dive/07-firmware-update-and-mcu.md`: the YModem update protocol.
- `docs/m17-deep-dive-2026-10-22.md`: the audio-path M17 study (its TX verdict applies to the audio path only; the firmware route is above).
