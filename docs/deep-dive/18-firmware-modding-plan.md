# 18 — Modding the radio MCU firmware: what's possible and how

**Question.** The MCU firmware is in the repo. Can we decompile it, find the settings, edit them, and flash the modem to change behaviour the app can't reach (squelch coercion, band limits, TOT, group-call RX, tone tables)?

**Short answer.** Yes to *decompile*, *edit* and *flash-to-test* — the flash-and-test loop is already solved and carries **no bricking risk** (it loads to RAM and reverts on power-cycle). The hard, unsolved part is *identify the setting*: the previous campaign made 14 firmware patches and landed 0 because it patched **mis-decoded bytes** from a naive disassembler with an unverified base address. This chapter is a concrete plan to do the identification properly, plus an honest read of which "settings" are worth the effort and which are legally sensitive.

Grounding facts below were re-derived from the binary on 2026-08-27; the flashing mechanism is from ch. 07.

---

## 1. What is actually in the repo

Seven copies of the image, all 378,620 bytes:

| Path | MD5 | Role |
|---|---|---|
| `radio_firmware/DMR003.UV4T.V022-ORIGINAL.bin` | `44260353…9e268e0` | factory image (canonical) |
| `radio_firmware/DMR003.UV4T.V022-PATCH14.bin` | `4c8afcc3…21b03cb` | last patch attempt (2 bytes differ — see §4) |
| `app/src/main/assets/DMR003.UV4T.V022.bin` (+ 3 more decompile trees) | `44260353…` | the copy the OEM app YModem-pushes on update |
| `DMRModHooks/app/src/main/assets/PATCH14.bin` | `4c8afcc3…` | the mod ships the patched image |

Plus prior RE artifacts: a Ghidra project (`radio_firmware/ghidra_decompiled/project/DMR_Firmware.rep`, 2 MB), three Ghidra scripts (`FindDMRBug.java`, `find_contacttype_bug.py`, `find_dmr_bug.py`), a 32 MB linear disassembly dump, and `scripts/arm_disasm.py` (the naive disassembler — the problem, §4).

**The firmware is not going anywhere and is safe to work on.** Nothing here can brick the radio by editing a file.

---

## 2. What we know vs. what was assumed

Re-checked against `DMR003.UV4T.V022-ORIGINAL.bin`:

| Fact | Status | Evidence |
|---|---|---|
| ARM, Thumb/Thumb-2 | **confirmed** | Thumb opcodes decode cleanly in the readable regions; ch. 07 |
| RTOS = Micrium uC/OS-III | **confirmed** | plaintext strings `uC/OS-III Idle Task`, `… Tick Task`, `… Timer Task` at `0x35FE4–0x361A4` |
| Version `DMR003.UV4T.V022` | **confirmed** | string at `0x38464` |
| **Not encrypted / not compressed** | **confirmed** | RTOS + version strings are plaintext; entropy 6.97 bits/byte is consistent with ARM code + data tables, not a cipher |
| Base load address `0x08000000` (STM32/GD32 flash map) | **assumed, never proven** | it is only the *input to* `arm_disasm.py`; the image's own first word is `0xC001112C` and word 1 is `0x11EC6420`, which are **not** a plausible Cortex-M `(initial SP, reset vector)` pair for a 0x08000000 image (SP should point at SRAM ~`0x20000000`; reset should be an odd Thumb address inside the image) |
| Vector table at offset 0 | **doubtful** | the first words don't parse as a vector table → the image likely has a header, a non-zero load offset, or the MCU is not a plain Cortex-M0/3/4 (the "HR_C6000" DMR baseband, referenced in `UARTBootloaderProbe`, is an ARM7TDMI-class core in some variants — different vector semantics) |
| MCU part = HR_C6000 vs "STM32/GD32 clone" | **conflicting in the docs** | ch. 07 doc-drift note; resolving this is step 1 of any real RE |

**The single most important finding:** the base address and core were never established, and everything downstream (the disassembly, the CMP-`#2` "locations", all 14 patches) was built on that unverified assumption. That is the primary reason the campaign failed, more than any specific missed instruction.

---

## 3. The three sub-problems, by difficulty

| Stage | Difficulty | Why |
|---|---|---|
| **Flash-and-test** | **Easy, solved, safe** | `DMRDEBUG.bin` RAM-load already works (§6). Reverts on power-cycle. Zero brick risk. This is how PATCH14 was tested. |
| **Edit** | **Easy** | Flip bytes in a copy; the image is plaintext and the YModem loader doesn't verify a signature (ch. 07 §1.5 — only per-block CRC + a size hint). |
| **Decompile** | **Medium** | uC/OS-III firmwares reverse well *once the base and core are right*. Ghidra does the heavy lifting. The prior naive disassembler was the wrong tool. |
| **Identify the exact setting** | **Hard** | This is the real work and where 14 attempts died. Needs correct decompilation **plus** a dynamic anchor (§5). |

So the framing to keep: **we can already safely try any change; we just haven't reliably found the right change to make.**

---

## 4. Why the previous 14 patches all failed

Concrete, from the artifacts:

1. **Naive disassembler.** `scripts/arm_disasm.py` reads **16 bits at a time** with a hard-coded `base_addr=0x08000000` and no Thumb-2 awareness. The dump (`firmware_disasm_output.txt`) is full of `?? (40 b3)` — those are the high halves of 32-bit Thumb-2 instructions, or inline data, being mis-read as separate 16-bit opcodes. Every "CMP r2, #2 ← contactType check" was found by pattern-matching in a stream that is itself mis-aligned. Patch a byte you mis-identified and you either no-op the wrong thing or corrupt a neighbouring instruction.
2. **Unverified base address** (§2) → every absolute address in the analysis (`0x08018F26`, `0x080490E2`, …) is only correct if the base guess is correct. If the true base differs, the "locations" point at the wrong bytes.
3. **Static-only, no ground truth.** The bug was hunted purely by reading disassembly. Nobody anchored the analysis to a **known input**: the app sends `0x22`/`0x23`/`0x2B` with a documented body (ch. 01–02), so the UART RX handler and the channel-program parser are *findable by their data*, not by guessing at CMP constants.
4. **`cmd_handler.c` is not a handler.** It's failed Ghidra output (ch. 07 §4.1) — two functions full of `halt_baddata()`. It was treated as if it were a reconstructed dispatcher.

`PATCH14.bin` differs from the original in exactly the bytes those scripts chose; per `PATCH_RELOAD_TEST_RESULTS.md`, group calling was still broken after loading it. So the mod ships a firmware patch that does nothing — worth removing (or replacing) once a real fix exists.

---

## 5. A better plan to *identify* settings

The whole game is turning the image into correctly-decompiled C and then finding the specific function. Do it anchored to what we already know from the app side.

### 5.1 Establish the ground truth (do this first, no radio needed)
1. **Identify the core and base.** Load into Ghidra as raw ARM; try both **Cortex-M** (little-endian Thumb, base `0x08000000`) and, if the vector table doesn't resolve, scan for the real reset/handler table by looking for a run of aligned pointers that all fall inside `[base, base+size)` and are odd (Thumb). The correct base is the one under which (a) `BL`/`B` targets land on instruction boundaries, (b) string-referencing `LDR rX,[pc,#imm]` point at the plaintext strings we can see (`0x38464` "DMR003.UV4T.V022", the uC/OS strings). This is a solvable constraint-satisfaction problem: the strings are fixed anchors.
2. **Confirm with the RTOS.** uC/OS-III has recognisable signatures (`OSTaskCreate`, `OS_TCB` layout, the task-name strings we already found). Ghidra + a uC/OS-III symbol pack, or manual naming from the task strings, gives dozens of named functions for free and validates the base.

### 5.2 Anchor to the serial protocol (this is the key insight the prior work missed)
We know the wire format exactly (ch. 01–02): frames are `68 cmd rw sr ck len body 10`. So:
1. Find the **UART RX byte handler / frame parser** by searching for the constants `0x68` (sync) and `0x10` (tail) used together, or the checksum routine (one's-complement 16-bit — a distinctive loop).
2. From the parser, follow the **command dispatch** (a switch/table on the `cmd` byte). The command values are known: `0x22` SET_DIGITAL, `0x23` SET_ANALOG, `0x2B` QUERY_DIGITAL_AUDIO_RECEIVE, `0x30` SET_SQUELCH, etc. Now every handler is reachable *by its command number*, not by guessing.
3. This immediately locates the functions that implement the settings we care about — because each is the handler for a specific command byte whose semantics we already documented.

### 5.3 Then the specific settings

| Target setting | Where it lives (hypothesis) | How to find it | Difficulty / value |
|---|---|---|---|
| **Squelch coercion** (levels 1,3–9 → 2) | inside the `0x23` SET_ANALOG handler or the RSSI/squelch compare | trace the `sq` body byte from the parser; look for a compare/clamp that forces non-{0,2} to 2 | Medium / high — would unlock real squelch levels |
| **Band/bandwidth handling** (12.5/25 kHz) | `0x23` handler, near the `band` byte | trace the `band` byte to the PLL/filter config | Medium / medium |
| **TOT** | `0x3B` SET_TOTO handler | dispatch on `0x3B` | Easy / low (app can send the value — backlog S1 — no firmware change needed) |
| **TX band limits** (out-of-band lockout) | frequency validation in `0x22`/`0x23` before PLL program | find the `>= / <=` compares against band-edge constants (144e6, 148e6, 430e6, …) | Medium / **legally sensitive — see §7** |
| **Group-call RX filter** (`contactType=2` → `0xFFFFFF`) | the DMR **frame RX** path (not a UART command) — where the received TG is extracted and matched against the RX list | this is the hard one: it's in the baseband RX ISR/task, reached from the DMR slot timing, not from a UART command. Anchor via the `0x2B` QUERY_DIGITAL_AUDIO_RECEIVE handler (which *reports* the caller info the app reads) and walk **backwards** to where that struct is filled | Hard / high — the 14-patch white whale |
| **Tone (CTCSS/DCS) tables** | data tables, not code | find the array the `0x23` handler indexes with `rxSubCode`; cross-check against `arrays.xml` values (67.0, 71.9, … Hz → the encoded divisors) | Easy-medium / low |

### 5.4 Verify each hypothesis *dynamically* before patching
The mod already has the tooling: the **exported debug packet receiver** (`com.dmrmod.SEND_DEBUG_PACKET`, ch. 08 §10 — the same one backlog R6 wants to gate) lets you send arbitrary `cmd`/`body` to the MCU from `adb` and watch the reply. Use it to confirm "this command byte drives this behaviour" on the *real* MCU before spending time in the disassembly. That is the ground truth the static campaign never used.

---

## 6. Editing and flashing (the safe, solved loop)

From ch. 07 (verified):

1. **Edit** a copy of `DMR003.UV4T.V022-ORIGINAL.bin` (flip the identified bytes). No signature to satisfy; the loader checks only a per-block CRC and a size hint, so keep the file 378,620 bytes.
2. **Deploy**: `adb push patched.bin /sdcard/DMR/DMRDEBUG.bin`. On entering `UpdateFirmwareActivity` the app auto-starts a YModem push of that file **unconditionally** (`YModemManager.getDmrFirmwarePath` — the external file wins over the bundled asset, no version gate). Trigger it with the update intent or the app's update UI.
3. **Runs from RAM.** The image executes but is **not written to flash** — a power-cycle restores the factory firmware (high-confidence empirical result; the "RAM not flash" mechanism itself is inferred). So a bad patch = reboot the radio, done. **This is the safety net that makes iteration risk-free.**
4. **Revert**: `adb shell rm /sdcard/DMR/DMRDEBUG.bin` (and power-cycle) to stop loading the test image.

**Permanent flash** (survives power-cycle) is **not solved, and less closed than it looked** — and **not needed for development** (RAM-load is the correct iteration loop; permanence is only a question once a change is worth keeping). The one negative result on record, `UARTBootloaderProbe` → **EACCES**, was a probe of **`/dev/ttyS1`** — but the working YModem update runs over **`/dev/ttyS0`** (`SerialPort.java:25`, opened at 57600 via `SerialManager.getSerial()` → `YModemManager.java:104`). So the probe tested a UART the firmware path never uses; the "permanent flash is blocked" conclusion inherits the same flaw as the patch campaign (it tested the wrong thing). This was surfaced by `docs/grok-deep-dive/10-firmware-modding.md` and re-verified here — see §10.

Two other on-device facts worth having before any flash attempt:
- **GPIO entry to the update loader is real:** `ReadFileUtils.setDmrUpdateCondition()` (`Util/ReadFileUtils.java:120`) toggles `/sys/devices/platform/dmr009/pwd` and `/ptt` (and `…/debug`). Whether that pin is a plain "app, start YModem" flag or something closer to BOOT0 is unknown and worth reading out.
- The firmware YModem loader may or may not contain a **flash-commit** (SRAM→FLASH) routine at the end of the transfer; if the image genuinely runs from RAM, that routine is never reached, and "permanence" could be an extra command rather than a second bootloader. Unproven — a target for the corrected decompilation (§5).

### Test-loop tooling that already exists
- `DMRModHooks/install.ps1` pattern for build/deploy; `radio_firmware/README.md` documents the DMRDEBUG.bin procedure.
- `PatchReloadHelper.java` / `hookUpdateFirmwareActivity` in the mod (currently disabled) were an in-app "reload this patch" button — could be revived as a proper firmware-dev toggle inside the Diagnostics section (backlog S7).

---

## 7. Legal, safety and etiquette (read before TX-side edits)

- **Band-limit / out-of-band TX edits change what frequencies the radio will transmit on.** Doing that is legitimate for licensed experimentation on amateur allocations, but transmitting outside your licence/allocation is illegal in every jurisdiction and can interfere with public-safety services. Keep any such change to receive-only or to your own authorised bands, and never distribute an image that unlocks TX for unlicensed use. This document plans capability; the operator owns compliance.
- **RAM-load is your friend** — never write to flash to "just try it". The reversible path removes the only irreversible risk.
- **Don't ship a modified MCU image in the APK by default.** `PATCH14.bin` currently rides in the mod's assets and does nothing; a *working* firmware mod should be an explicit, opt-in, clearly-warned download, not a silent bundle (and it must not auto-load via a bundled `DMRDEBUG.bin`).
- **DMR ID / callsign are not in scope** — those are app-side, not firmware.
- Keep the factory image and MD5 on hand (`radio_firmware/README.md`) so recovery is always one `rm` + power-cycle away.

---

## 8. Honest assessment

- **Feasible and safe to attempt:** yes. The flash/test loop is the easy, reversible part, and the image is plaintext.
- **Likely to succeed on the easy targets** (tone tables, confirming/relocating the squelch clamp, TOT-via-firmware): reasonable, if the decompilation is redone correctly.
- **The group-call RX fix remains a genuine research project** with a 0/14 track record. The improved approach (correct base, protocol-anchored, dynamic verification via the debug packet path, walk-back from the `0x2B` reporter) is materially better than the static CMP-hunting that failed — but it is still hard, and it may confirm the constraint is real (the firmware genuinely doesn't extract the TG on that path). Treat a *proof* of that as a valid outcome too.
- **Best near-term value for effort:** don't start with the white whale. Prove the toolchain on an easy, visible change first (e.g. relocate the squelch clamp so levels 1/3–9 differ, or a tone-table tweak), using RAM-load. A single confirmed round-trip (edit → RAM-load → observed behaviour change → power-cycle restore) de-risks everything else.

---

## 9. To-do (backlog **FW**-series; gated, mostly no-device for the RE part)

| # | Item | Effort | Device | Depends |
|---|---|---|---|---|
| **FW0** | Re-import into Ghidra; **determine the true base address and core** by constraint-solving against the known plaintext strings and pointer tables; validate with uC/OS-III signatures. Document the answer (settles the ch. 07 doc-drift). | M | no | — |
| **FW1** | **Protocol anchor:** find the checksum routine + `0x68/0x10` framing + the `cmd`-byte dispatch; name the handlers for `0x22/0x23/0x2B/0x30/0x3B`. Produce a real command→function map (replaces `cmd_handler.c`). | M | no | FW0 |
| **FW2** | **Dynamic ground truth:** via the (gated) debug-packet path, map each command byte's observable effect on the MCU; correlate with FW1. | S | yes | FW1, R6 |
| **FW3** | **Easy win first:** locate the squelch clamp (levels→2) *or* a tone table; make a one-byte change; RAM-load; observe; power-cycle restore. Prove the full loop. | M | yes | FW1–2 |
| **FW4** | Locate the frequency/band-limit validation (document only unless the operator authorises TX-band changes for their own allocation — §7). | M | no | FW1 |
| **FW5** | Group-call RX: anchor at the `0x2B` reporter, walk back to the RX-frame TG extraction; test hypotheses via RAM-load. Accept "constraint confirmed" as a valid result. | L | yes | FW1–3 |
| **FW6** | Revive `PatchReloadHelper` as an opt-in "firmware dev" control inside the Diagnostics section; **stop bundling `PATCH14.bin`** (it does nothing) and never auto-load a `DMRDEBUG.bin`. | S | yes | R6/S7 |
| **FW7** | If a change proves worth keeping: revisit permanent flash. **Retry on `/dev/ttyS0`** (the port the update actually uses) after the `dmr009` GPIO knock, and read out `/sys/devices/platform/dmr009/*` for a BOOT0-like node — the prior EACCES was on the unused `/dev/ttyS1`. Keep every probe read-only (Get/Get-ID/read-back) before any Write/Erase. SWD/JTAG only if UART is a dead end. Research-only until FW3's round-trip is proven. | L | yes | FW3, FW5 |

Nothing here blocks the app-side trains (v3.4.7 / v3.5 / v3.6). Firmware work is a parallel research track; the flash loop is safe, so it can proceed whenever there's a device and time.

---

## 10. Response to the Grok firmware chapter (`docs/grok-deep-dive/10-firmware-modding.md`)

Grok independently analysed the firmware on 2026-08-27. It is untouched. Its conclusions converge with this chapter (same image inventory, same "not encrypted", same root cause: mis-decoded bytes under an unverified base — "do not reopen NOP-at-`0x18F2C`"). It also adds material this chapter did not have; each new claim was re-verified against the source before adoption.

**Agree — and adopted above:**

| Grok 10 | Re-verification (2026-08-27) | Where adopted |
|---|---|---|
| The `UARTBootloaderProbe` EACCES was on **`/dev/ttyS1`**, but the working YModem update uses **`/dev/ttyS0`** — so "permanent flash is blocked" tested the wrong port | Confirmed: `SerialPort.java:25` opens `/dev/ttyS0` @57600; `YModemManager.java:104` uses `SerialManager.getSerial()` (that same port); `UARTBootloaderProbe.java:37` targets `/dev/ttyS1`. **This is the most valuable thing in the chapter** — it materially reopens the permanence question and shows my §6 permanent-flash framing shared the campaign's "tested the wrong thing" flaw | §6 rewritten; FW7 rewritten |
| **GPIO knock** into the update loader: `ReadFileUtils.setDmrUpdateCondition()` toggles `/sys/devices/platform/dmr009/{pwd,ptt,debug}` | Confirmed: `ReadFileUtils.java:16-18,120` | §6; FW7 |
| Trigger the updater with `am start -a prize.intent.action.update.dmr.firmware`, **not** `force-stop`; target package is `com.pri.prizeinterphone` (system-UID), not the rebuild id `com.macgyver.dmr` | Consistent with ch. 07 §1.1 (exported intent) | §6 already said `am start`; package note reinforced |
| Permanent-flash **access** ideas (S0 retry, GPIO-as-BOOT0, sysfs inventory, SWD pads, a possible flash-commit routine at the end of the YModem loader) rather than another opcode guess | Reasonable hypotheses; the flash-commit idea is a concrete decompilation target | folded into §6 and FW7 |
| `PatchReloadHelper` reads `/sdcard/DMR/PATCH14_BACKUP.bin`, not the APK asset | Matches ch. 07 §5.4 | already documented |

**No disagreements of substance.** Two small notes:
- Grok's DMRDEBUG path (`/sdcard/DMR/DMRDEBUG.bin` only, not `/sdcard/DMRDEBUG.bin`) matches ch. 07 §1.4 — a real correction to `radio_firmware/README.md`, already flagged there.
- Grok phrases the RAM-vs-uncommitted-flash question as open ("Volatile load (RAM **or** uncommitted flash)"); ch. 07 §3 agrees the *mechanism* is inferred (only the revert-on-power-cycle *behaviour* is proven). Same position.

**Net effect on the plan:** the permanent-flash step (FW7) is upgraded from "blocked, revisit later" to "retry on the correct port after the GPIO knock, read-only first" — a real, testable next action rather than a dead end. Everything else stands; the two chapters are complementary (this one is the primary plan; Grok 10 adds the permanent-flash access angle and a one-screen procedure poster).
