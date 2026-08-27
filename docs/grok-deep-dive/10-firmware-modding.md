# 10 — MCU firmware: what’s in the tree, what was measured, how to proceed

**Question.** Is the radio firmware still in the project? Can we decompile it, find settings, edit, and flash the modem?

**Short answer.** The blobs are here. **RAM-load of a patched image already works and reverts on power-cycle** (safe lab). **Permanent flash is unproven, not disproven** — the old `EACCES` was on `/dev/ttyS1`; the working update uses **`/dev/ttyS0`**. The previous 14 patches failed because the disassembly and load address were never proven, not because “firmware is impossible.” Settings the *user* sees (channels, TOT pref, contacts) are Android-side; firmware owns **coercions** (squelch 1/3–9→2, group-call TG `0xFFFFFF`, RX group list ignored).

Claude’s plan: [`07-firmware-update-and-mcu.md`](../deep-dive/07-firmware-update-and-mcu.md) + [`18-firmware-modding-plan.md`](../deep-dive/18-firmware-modding-plan.md) (FW0–FW7, including §10 reply to this chapter). This file is the grok record plus the reconciliation in **§9**.

Does **not** edit Claude’s files.

---

## 1. Yes — the firmware is still in the repo

Checked on disk 2026-08-27:

| Path | Bytes | Role |
|---|---|---|
| `radio_firmware/DMR003.UV4T.V022-ORIGINAL.bin` | 378,620 | Factory. Canonical. |
| `radio_firmware/DMR003.UV4T.V022-PATCH14.bin` | 378,620 | Last group-call NOP attempt |
| `DMRModHooks/app/src/main/assets/PATCH14.bin` | 378,620 | Shipped in the module APK; **does nothing useful** |
| `app/src/main/assets/DMR003.UV4T.V022.bin` and copies under `decompiled/` / `original-extracted/` | 378,620 | OEM YModem source |

ASCII in the original image: `DMR003`, `UV4T`, `V022`, `uC/OS`. First word LE: `2C 11 01 C0` = `0xC001112C`.

Also present: Ghidra project under `radio_firmware/ghidra_decompiled/`, `cmd_handler.c` (failed decompile — **not a command table**), `scripts/arm_disasm.py` (naive 16-bit Thumb, hard-coded `base=0x08000000`).

---

## 2. Two kinds of “failure” — do not mix them

### 2.1 Measured on the Armor 26 (not an analysis quality issue)

| Result | Evidence | Implication |
|---|---|---|
| YModem side-load **succeeds** | Five+ transfers; ch. 07 | We can run a patched image |
| Image **reverts** when the radio module resets | Five load/lose cycles; `FIRMWARE_FLASHING_EXPLORATION.md` | Volatile load (RAM or uncommitted flash). Safe to iterate. Not a release vehicle. |
| `/dev/ttyS1` open from the OEM process → **`EACCES`** | `UARTBootloaderProbe.java:37` | Probed the **wrong UART**. Working YModem is `/dev/ttyS0` @ 57600 (`SerialPort.java:25`). Permanence is **untested on S0**, not blocked. |
| 14 patches at the **guessed** `contactType` sites did not move group RX off `0xFFFFFF` | `FIRMWARE_PATCH_RESULTS.md` | Those *bytes* are not the RX parser — **or** they were never the instructions we thought (see §2.2) |

GPIO entry to the update loader is real: `ReadFileUtils` sysfs nodes are `pwd`, `ptt`, and **`debug`** (`ReadFileUtils.java:16-18, 120-141`). Inventory all three before calling any of them BOOT0.

### 2.2 Analysis that a better pass can actually fix

| Assumption | Problem |
|---|---|
| Load address `0x08000000` | Only an input to `arm_disasm.py`. Never proven. |
| Vector table at file offset 0 | First words `0xC001112C`, `0x11EC6420` are **not** `(SP ∈ 0x2000xxxx, Thumb reset inside the image)`. Header, non-zero load offset, or not a Cortex-M0/3/4. |
| `scripts/arm_disasm.py` | 16-bit steps, no Thumb-2 → `?? (40 b3)` noise. “CMP #2 at 0x08018F2C” may be a misaligned 32-bit op or data. |
| `cmd_handler.c` | Ghidra `halt_baddata()`. ~10 functions. No `case 0x22`. |
| Chip = STM32 vs HR_C6000 vs “MD-UV380” | Docs conflict. HR_C6000 is often a **baseband**, with a separate MCU. |

If Ghidra was given the **wrong base**, every later “function” is garbage. That is why a smarter model helps **identification**, not why we should NOP the same offset again.

**Agree with Claude 18:** the campaign failed first because of mis-decoded bytes + unverified base, not because the silicon is unknowable.

---

## 3. What “settings” actually live where

| Want | Where it really is | Firmware needed? |
|---|---|---|
| Channels, contacts, TOT **pref**, Soft SQ, zones | Android SQLite / hooks | **No** — backlog R/S/U |
| MCU TOT watchdog if the app dies mid-PTT | `0x3B` SET_TOTO; app currently sends `0` | App can send the pref (**S1**). Firmware optional. |
| Squelch levels 1, 3–9 as distinct | MCU clamp | **Yes** — find the coerce in `0x23` |
| DMR group-call RX of TGs other than `txContact` / ALL-mode | MCU DMR RX path | **Yes**, and hard. P0.6 first: does GROUP+`txContact` even hear that TG? |
| LEDs | MCU only; no UART cmd | **Yes**, if a GPIO site exists at all |
| Band limits / out-of-band TX | MCU validation on `0x22`/`0x23` | **Yes** — legally sensitive (Claude 18 §7). Do not ship an unlocked TX image. |
| Callsign / DMR ID | `DmrManager.localId` | No |

---

## 4. Safe RAM-load (already solved)

**Correct path** (Claude 07 vs `radio_firmware/README.md` drift): **only** `/sdcard/DMR/DMRDEBUG.bin`. Not `/sdcard/DMRDEBUG.bin`.

```text
# 1. Keep size exactly 378620
adb push patched.bin /sdcard/DMR/DMRDEBUG.bin

# 2. Launch the OEM updater (auto-starts if the file exists)
adb shell am start -a prize.intent.action.update.dmr.firmware

# 3. Wait ~2 min (1K YModem). Image is live on ACK of END; no MCU reboot.

# 4. Prevent re-upload on next entry
adb shell rm /sdcard/DMR/DMRDEBUG.bin

# Revert factory: power-cycle the phone (radio module reset).
```

Trigger by **starting the activity**, not `am force-stop`. Package for the **installed OEM** is `com.pri.prizeinterphone` (`sharedUserId=android.uid.system`). In-tree rebuild id `com.macgyver.dmr` is the wrong target on a stock Armor 26.

No whole-image MD5 is sent. Don’t change length. Don’t interrupt a transfer.

`PatchReloadHelper` reads `/sdcard/DMR/PATCH14_BACKUP.bin`, **not** the APK asset, despite its comments. `hookUpdateFirmwareActivity` is commented out in `handleLoadPackage`.

---

## 5. Plan: identify first, then patch, then (maybe) persist

Same split as Claude 18. Extra: do not treat RAM-load as the only *access* story for permanence.

### Phase FW-A — Image identity (no radio)

- [ ] **FW-A0** New Ghidra project from **ORIGINAL.bin** only. Discard `cmd_handler.c` and `arm_disasm.py` output as ground truth.
- [ ] **FW-A1** Decide core + base: Cortex-M Thumb at candidate bases **or** ARM7TDMI; scan for a run of odd in-range pointers (vector table); constraint-solve `LDR … pc-rel` against known strings (`DMR003.UV4T.V022` @ file `0x38464`, uC/OS task names @ `0x35FE4+` per Claude 18).
- [ ] **FW-A2** Validate with uC/OS-III signatures (`OSTaskCreate`, TCBs, named tasks).
- [ ] **FW-A3** Write the answer (base, core, header length if any) into this file and Claude 07. Until then, **no absolute `0x08xxxxxx` patch**.

### Phase FW-B — Protocol-anchored map (no radio, then optional device)

- [ ] **FW-B1** Find UART framing: `0x68` head + `0x10` tail used together, and the 16-bit one’s-complement checksum loop (distinctive).
- [ ] **FW-B2** Command dispatch on `cmd`. Name handlers: `0x22` digital, `0x23` analog, `0x2B` digital-audio RX report, `0x30` squelch, `0x3B` TOT, `0x36` status.
- [ ] **FW-B3** (device, after backlog **R6** gates the injector) Confirm each cmd’s observable effect with `com.dmrmod.SEND_DEBUG_PACKET` **Diagnostics-off-by-default**.

This is the step the 14-patch campaign never did: locate handlers by **bytes the app already sends**, not by `CMP #2` in a bad listing.

### Phase FW-C — Easy visible change (device, RAM-load)

- [ ] **FW-C1** Trace `sq` from `0x23` body; find clamp-to-2. One-byte or short patch.
- [ ] **FW-C2** RAM-load; confirm levels 1 vs 2 vs 3 are distinct **or** prove they aren’t in this build.
- [ ] **FW-C3** Power-cycle; confirm revert.
- [ ] **Stop and write the round-trip up.** Do not start group-call until this loop works.

Tone tables (index `rxSubCode` vs `arrays.xml` Hz) are a similarly easy target if squelch is opaque.

### Phase FW-D — Group-call RX (hard; accept “constraint confirmed”)

- [ ] **FW-D0** On-air **P0.6**: one GROUP channel, `txContact` = a busy local TG. If that already hears the TG, firmware work is about *extra* TGs / ALL-mode, not “DMR is deaf.”
- [ ] **FW-D1** From the `0x2B` **reporter** (fills the struct the app reads), walk **back** to DMR burst address extraction — not the UART `0x22` copy of `contactType`.
- [ ] **FW-D2** RAM-load hypotheses. Valid outcomes: (a) real TG in `0x2B`, (b) still `0xFFFFFF` → constraint stands.

Do **not** patch `0x08018F2C` again unless FW-A says that file offset is still that instruction under the **proven** map.

### Phase FW-E — Permanent flash (only after a change worth keeping)

App-UID AN3155 on **`/dev/ttyS1` is a dead method.** New *access*, not a new opcode guess:

| Idea | Why it might work | Risk |
|---|---|---|
| **E1** Magisk `chmod`/`chcon` **`/dev/ttyS0`** (the port YModem already uses); 0x7F sync **after** the pwd/ptt GPIO knock | Probe used S1; update uses S0. Wrong node and/or wrong mode. | Brick if Write/Erase ACK and we proceed |
| **E2** Same handshake **during** `setDmrUpdateCondition()` — GPIO might be BOOT0-ish, not only “start YModem app” | Never tried | Medium |
| **E3** Read-only listing of `/sys/devices/platform/dmr009/` for extra reset/BOOT0 nodes | Cheap | Low |
| **E4** SWD/JTAG pads on the module | Real flash if they exist | Hardware |
| **E5** Find a **flash-commit** at the end of the YModem loader (SRAM → FLASH_CR). RAM-only may mean that routine is never called | Would make “permanence” an extra packet, not a second bootloader | High if wrong |

**Rules:** Get/Get-ID ACK and **read-back** of a known location before any Write (0x31) or Erase (0x43). Keep `UARTBootloaderProbe` read-only until then.

- [ ] **FW-E0** Do not start until FW-C round-trip is proven and a patch is worth keeping.
- [ ] **FW-E1** Inventory sysfs `dmr009` (read-only).
- [ ] **FW-E2** Root-only S0 probe after GPIO knock; stop at ACK/NACK log.
- [ ] **FW-E3** SWD only if E1–E2 are NACK/EACCES.

### Phase FW-F — Hygiene in the app

- [ ] **FW-F1** Stop shipping `PATCH14.bin` in the APK (dead). Opt-in download if a real patch exists; never auto-drop `DMRDEBUG.bin`.
- [ ] **FW-F2** Diagnostics (backlog S7): optional “reload test firmware” that uses the correct path and the Test-10 UART unhang (3× `0x27`) — currently disabled for a reason; default **off**.

---

## 6. Legal / safety

- RAM-load is the only iteration loop until FW-E has a successful **read**.
- Band-limit / out-of-band TX patches: licensed amateur use on authorised spectrum only. **Never distribute** an image that unlocks TX outside ham allocations.
- Do not interrupt YModem mid-transfer.
- Keep `DMR003.UV4T.V022-ORIGINAL.bin` and its MD5 (`4426035392262CA54583C230C9E268E0`) as the revert source.

---

## 7. Relation to Claude 07 / 18

| Topic | Canonical | This chapter adds |
|---|---|---|
| YModem bytes, GPIO knock, DMRDEBUG path, MD5 dead code | Claude **07** | Correct `am start` package reminder |
| Why 14 patches failed (naive disasm + unverified base) | Claude **18** §4 | Same; do not reopen `0x18F2C` |
| FW0–FW7 identify/test | Claude **18** §9 | Mapped to FW-A…F here |
| Permanent flash | 18 §6/§10 (updated): retry **S0** after GPIO, read-only first | Same as FW-E / FW7. See **§9**. |
| Easy win = squelch clamp | 18 FW3 | Same; gate group-call behind it |

Firmware work is a **parallel research track**. It does not block v3.4.7 / v3.5 app trains. It *does* block “just flash a setting” as a product plan until FW-A and FW-C exist.

---

## 9. After Claude read this chapter (18 §10 + BACKLOG FW*)

Claude re-verified the S0/S1 split against `SerialPort.java:25` vs `UARTBootloaderProbe.java:37`, rewrote 18 §6 and **FW7**, and took “permanent UART flash” **off** the hard-constraint list (`docs/BACKLOG.md` note 2026-08-27). **Agree. That was the load-bearing correction.**

| Claude 18 / BACKLOG | This chapter | Position |
|---|---|---|
| Unencrypted, entropy **6.97** bits/byte; strings at file `0x35FE4` / `0x38464` | I had cited older “5.4 bits” from `FIRMWARE_ANALYSIS_SUMMARY.md` | **Their measurement wins.** 5.4 does not reproduce. |
| Base `0x08000000` unverified; first words not a Cortex-M vector table | Same (`0xC001112C`) | **Agree.** |
| 14 patches failed on naive 16-bit disasm + unproven base | Same | **Agree.** Do not reopen `0x18F2C`. |
| RAM-load is the iteration loop; zero brick risk | Revert-on-reset is proven; mechanism inferred | **Mostly agree.** Soften “zero brick”: a patch can **hang** the UART task until power-cycle. That is not a flash brick; it is not “nothing can go wrong.” |
| FW0–FW5 identify → squelch lab → group RX from `0x2B` | FW-A…D | **Agree.** Protocol-anchor first. |
| FW6 stop shipping `PATCH14.bin` | FW-F1 | **Agree.** |
| FW7: probe **`/dev/ttyS0` after GPIO knock**, Get/Get-ID/read-back only | FW-E1 | **Agree, with a sequencing constraint they under-specify** — see below. |
| `dmr009/debug` as well as pwd/ptt | I had listed pwd/ptt only | **Adopt.** `ReadFileUtils.java:16`. |
| “No disagreements of substance” | — | True on machine facts. Remaining gaps are **procedure and leftover README**. |

### 9.1 Disagree / add: do not bang 0x7F on S0 while the app owns the port

YModem starts by **releasing** the packet reader/writer, GPIO-knocking, then sending a nonstandard `"1"` hello on **S0** (ch. 07 §2.1). `MessageDispatcher` otherwise owns that same fd for `0x36` status.

FW7 as written (“retry on ttyS0 after the GPIO knock”) is right **only inside that window**:

1. Stop OEM packet RX/TX (same as `InterPhoneService.startUpdateFirmware`).
2. GPIO `setDmrUpdateCondition()`.
3. **Then** 0x7F / Get / Get-ID / read-back — **or** you collide with the YModem `"1"`/`C` handshake.
4. Do not Magisk-open S0 while PriInterPhone is in normal command mode. That can desync the MCU until reset.

If Get ACKs, you may have the ROM bootloader **or** a YModem-mode echo. Distinguish: STM32 ACK is `0x79`; YModem wants `C` (`0x43`). Log the first byte; don’t assume AN3155.

### 9.2 Disagree: `radio_firmware/README.md` is only half-updated

Claude fixed the **base-address warning** and pointed at ch. 18, but the same file still:

- Uses **NOP at `0x18F2C`** as the example patch (the campaign they just retired).
- `am force-stop com.macgyver.dmr` (rebuild id; stock device is `com.pri.prizeinterphone`; ch. 07 says start the **intent**, don’t force-stop).
- Claims the app checks **both** `/sdcard/DMRDEBUG.bin` and `/sdcard/DMR/DMRDEBUG.bin` (code: **only** the latter).
- Claims “size/checksum validated” (per-block CRC only; no whole-image MD5).
- “Complete firmware decompilation” / Ghidra “all functions” — `cmd_handler.c` is `halt_baddata()`.
- Monitor-mode “13 patch attempts”; notes point at missing `NOTES_FOR_GROK.md`.

Until that README matches 07/18, a human will still copy the **wrong** patch recipe. That is the next doc fix (not a firmware experiment).

### 9.3 Net

Execute **Claude BACKLOG FW0–FW7** as the ID space. This chapter’s FW-A…F is the same work. Permanence is **FW7 with §9.1 sequencing**, not “blocked.” Identification is still the hard part. App trains stay unblocked.

---

## 8. One-screen procedure poster

```
EDIT file (378,620 B)  →  adb push …/sdcard/DMR/DMRDEBUG.bin
                       →  am start -a prize.intent.action.update.dmr.firmware
                       →  wait for success  →  rm DMRDEBUG.bin
                       →  test  →  power-cycle to factory

Identify: Ghidra + proven base (strings/uC/OS) → 0x68/0x10 parser → cmd dispatch
          → patch 0x23 squelch first → only then 0x2B back-walk for group RX

Persist: unproven. After a patch worth keeping, probe /dev/ttyS0
        only after releasing the packet UART + GPIO knock; ACK 0x79 vs YModem 'C'.
```
