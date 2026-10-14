# 11 — FW0 lab notes: image identity (no radio)

**Date.** 2026-08-27.  
**Input.** `radio_firmware/DMR003.UV4T.V022-ORIGINAL.bin` only.  
**Tool.** `scripts/fw0_identify_image.py` (new). Does not patch or flash.  
**Plan.** Claude 18 FW0 / grok 10 FW-A.

---

## Verdict

| Question | Answer |
|---|---|
| Image still here, plaintext? | **Yes.** 378,620 bytes, MD5 `4426035392262ca54583c230c9e268e0`, entropy **6.970** bits/byte. |
| RTOS / version? | **uC/OS-III** task names and `DMR003.UV4T.V022` are plaintext in-file. |
| Cortex-M vector table at file offset 0? | **No.** First words `0xC001112C`, `0x11EC6420` are not `(SP ∈ SRAM, Thumb reset)`. |
| Load base `0x08000000` proven? | **Not proven — and Ghidra ARM cannot prove it on this blob.** Weak positive: 142 in-image `0x08` words including `"encrypt"` @ `0x080365c8`. Ghidra Cortex xrefs to the version/RTOS strings: **0** (the pass-2 “xref” was repeating `54 4a 02 03`). |
| Is the bulk Thumb? | **No.** `bx lr` = 1. |
| ISA | **C-SKY V2** (CK80x / T-HEAD 800-class), not Cortex-M. `0xE468`+`0x10xx` is 32-bit `subi32` (opcode `0x39`). `rts16` (`0x783C`) = **807** (random expect ~3). `lrw32` loads **0-based** pointers into the known string pool (`rxvoice` @ `+0x3659C`). |
| Load base | **Working: `0x00000000`** for linked addresses (623/853 `lrw32` literals are in-file offsets `0x0003xxxx`/`0x0004xxxx`). `0x08000000` remains unproven and is the wrong ARM guess. |
| Safe to NOP `0x18F2C`? | **No.** That offset was an ARM `bls` in a false Thumb map. |
| Ghidra ARM | Installed; cannot list this ISA (12.1.3 has **no CSKY** processor). |
| Next | FW-B2 **done** (§11): analog unpack/repack/apply named. `sq` is **pass-through** at `+0x9C3E`. No MCU clamp-to-2 on that path. FW-C needs a device watch of MMIO `0x1100xxxx` or an IC-side verdict — do not patch parse. |

PATCH14 is still exactly **2 bytes** different (MD5 `4c8afcc3e6a87480bdb307d9321b03cb`). Do not ship or reload it.

---

## 1. File facts (re-measured)

| | |
|---|---|
| Size | 378,620 (`0x5C6FC`) |
| MD5 | `4426035392262ca54583c230c9e268e0` |
| Entropy | 6.970 bits/byte (matches Claude 18; old “5.4” does not) |
| First 16 B | `2c 11 01 c0 20 64 ec 11 9f 6f ec 11 07 c0 21 64` |
| Tail | last 1788 bytes entropy 0 (padding) |

Not encrypted/compressed: RTOS and version strings are ASCII.

---

## 2. Strings used as anchors

File offsets (not runtime addresses until a base is proven):

| Offset | String |
|---|---|
| `+0x0323AC` | `encrec_sem` |
| `+0x0323B8` | `decrec_sem` |
| `+0x0323C4` | `play_sem` |
| `+0x035FE4` | `uC/OS-III Idle Task` |
| `+0x036010` | `uC/OS-III ISR Queue Task` |
| `+0x03609C` | `uC/OS-III Tick Task` |
| `+0x036188` | `uC/OS-III Stat Task` |
| `+0x0361A4` | `uC/OS-III Timer Task` |
| `+0x036534` | `PttTask` |
| `+0x036550` | `task init` |
| `+0x0365B4` | `cpchanscan` |
| `+0x038464` | `DMR003.UV4T.V022` |

~310 C-strings total. Also POSIX-ish errors at `+0x355xx` (`No such file or process`, …) — those made naive `movs rN, #0x68` hits (ASCII `'h'`).

---

## 3. Base-address experiment

**Method.** For each candidate base, count aligned LE `uint32` values equal to `base + string_offset` for the six RTOS/version anchors.

**Result.** Hits = **0** for `0x00000000`, `0x08000000`, `0x08004000`, `0x08008000`, `0x20000000`, and the other round candidates in the script.

Unaligned search for `0x08038464` (version at `0x08000000+0x38464`): **not in the file**.

So those strings are **not** referenced as 32-bit absolute literals at those bases. Typical explanations: PC-relative `ADR` / `LDR literal`, or Thumb-2 `MOVW`/`MOVT` pairs. Ghidra, not `grep` of `uint32`, is the next tool.

**Weak `0x08000000` signal:** 142 aligned words lie in `[0x08000000, 0x08000000+size)`. One of them is a real C-string:

`file +0x42EE0` → `0x080365C8` → `"encrypt"`.

Another 326 words are `0x08xxxxxx` **outside** the 378 KB image (top page `0x08080000`, n=34). If flash is only this blob, those are another region (second bank, aliased, or not flash). Do not treat them as code pointers into this file.

**Vector-table scan** (first 1 KB, several bases): no row with `SP ∈ SRAM` **and** Thumb reset inside the image. Hits that look “ok” on `reset_ok` have garbage SPs (`0xA3427C50`, …) — coincidental odd in-range words, not a table.

---

## 4. Protocol-byte immediates (FW1 preview — noisy)

Even-aligned Thumb `movs rN, #imm`:

| imm | Meaning | Count | Note |
|---|---|---|---|
| `0x68` | frame head | 10 | **First four are ASCII `"such"`** (`No such file…`). Not code. |
| `0x10` | frame tail | 115 | Too common (`#16`) to use raw. |
| `0x22` | SET_DIGITAL | 28 | Needs disassembly filter |
| `0x23` | SET_ANALOG | 28 | same |
| `0x2B` | QUERY_DIGITAL_AUDIO | 17 | same |
| `0x36` | status | 9 | same |
| `0xAA` | MODULE_INIT | **0** | Different encoding if present |

Later `0x68` sites (`+0x366A4`, `+0x37FAC`) sit in mixed `68 f4 ed 19 e8 …` — could be `ldr`/`blx`, not `movs #0x68`. Do not call these UART handlers until a real disassembler says so.

---

## 5. What this does *not* finish

- A vendor-confirmed load map (C-SKY `lrw32` literals say **base 0**; that is a working link address, not a flash alias proof).
- A real disassembly listing — Ghidra 12.1.3 cannot decode CSKY. Need `csky-elf-objdump` or a CSKY plugin.
- Command dispatcher / checksum loop (FW1) on that listing.
- Any RAM-load.

---

## 6. To-do remaining (FW0 leftover + FW1)

- [x] Confirm size, MD5, entropy, plaintext RTOS/version
- [x] Show file offset 0 is not a Cortex-M vector table
- [x] Show `0x08000000+str` literals are absent for task/version strings
- [x] Record the one `"encrypt"` pointer at `0x080365C8`
- [x] Filter `movs #0x68` false positives
- [x] **Ghidra 12.1.3** installed; headless import at `0x08000000` ARM Cortex Thumb (`TMode=1`)
- [x] Show the Ghidra “xref” to `+0x38464` is a **false positive** (repeating `54 4a 02 03` data)
- [x] Conservative listing (low-entropy windows, no PUSH spray): 17903 instr, 0 functions, **0** string xrefs. Those windows are the `68 e4` stream, not ARM.
- [x] Show the bulk of the file is a structured 16-bit encoding (`0xE468` × 5815), not compiler Thumb (`bx lr` = 1)
- [x] Identify the encoding as **C-SKY V2** (see §9). NDS32/Xtensa not needed for the first listing.
- [x] UART builders found on a **synced C-SKY walk** (`scripts/fw0_csky_uart.py`) — see §10
- [x] Checksum = `+0x7D94` (`not16` one’s complement, BE words); wrapper `+0x8E5C` writes `buf[4..5]`. Send = `+0x7DE8` → MMIO `0x1409xxxx` at `+0x5EF4`
- [ ] FW-B2: `+0x796E` cmd in `r0` → digital/analog handlers
- [ ] `csky-elf-objdump` still useful for a full listing; Ghidra 12 has no CSKY
- [ ] Confirm whether `0x00000000` is the only map or also aliased at SRAM `0x20000000`
- [ ] Still never patch `0x18F2C`

Scripts: `fw0_identify_image.py`, `fw0_thumb2_xrefs.py`, `fw0_isa_fingerprint.py`, `fw0_csky_walk.py`, `fw0_ghidra_headless.ps1`.

---

## 7. Ghidra lab (2026-08-27)

**Installed (not in git).** SHA-256 of the official zip matches NSA’s release notes.

| What | Where |
|---|---|
| Ghidra 12.1.3 PUBLIC | `C:\Users\Joshua\tools\ghidra_12.1.3_PUBLIC` (zip `ghidra_12.1.3_PUBLIC_20260817.zip`, SHA-256 `93a5d11a9ad510622acaaf908c556a7b9b764d338e78a7567f3689bf5081fd54`) |
| JDK 21 (Temurin portable) | `C:\Users\Joshua\tools\jdk-21.0.12.1+1` — winget MSI was cancelled (exit 1602); zip install works |
| Headless wrapper | `scripts/fw0_ghidra_headless.ps1` |
| Pre/post scripts | `radio_firmware/ghidra_scripts/Fw0SetThumb.java`, `Fw0Identify.java`, `Fw0Dump.java` |
| Project (gitignored) | `radio_firmware/ghidra_project_fw0/DMR003_UV4T_V022_fw0` |

GUI: `$env:JAVA_HOME='C:\Users\Joshua\tools\jdk-21.0.12.1+1'; C:\Users\Joshua\tools\ghidra_12.1.3_PUBLIC\ghidraRun.bat` then open that project.

### 7.1 What Ghidra actually did

| Pass | Result |
|---|---|
| Raw import, `ARM:LE:32:Cortex`, base `0x08000000`, **no `TMode`** | Memory `08000000–0805c6fb`. **0 instructions, 0 functions.** Auto-analysis has no entry point and defaults ARM (not Thumb). |
| Same + `TMode=1` on the whole block + disassemble at every Thumb `PUSH {…,lr}` (`0xB5xx`, 304 sites) | **37,686 instructions, 5 functions.** Aggressive Instruction Finder + Constant Reference Analyzer ran (~20 s). |

Language is Thumb-capable Cortex. That is progress over `scripts/arm_disasm.py`. It is **not** a trusted listing.

### 7.2 Version-string “xref” is data, not code

Ghidra reported `08038310  ldr r2,[0x08038464]` → the version bytes (`undefined4 30524D44h` = `"DMR0"`). Capstone on the same bytes:

```
file +0x382F0 .. +0x383D8  repeats  54 4a 02 03   (65×)
Thumb decode: ldr r2, [pc, #0x150] ; lsls r2, r0, #12
```

PC-relative math from that repeating pattern **lands on** `+0x38464` by construction (`imm8=0x54` × 4 = `0x150`). This is a string-pool / table, not a `printf("%s", version)` site. **Does not prove `0x08000000`.**

Confirmed still missing as code xrefs (Ghidra `Fw0Dump`): `encrypt` `080365C8`, pointer word `08042EE0`, `uC/OS-III Idle Task`, `PttTask` — **0 xrefs each**.

Python `scripts/fw0_thumb2_xrefs.py` (MOVW/MOVT pairs, ADR T1, ADR-wide, LDR-literal T1 → anchors): **zero** hits at every candidate base. So the strings are not referenced by those common encodings either, *or* the code that would reference them is not Thumb at a 2-byte alignment we scanned.

### 7.3 Vector table: whole file, still no

FW0 only scanned the first 1 KB. Full-file scan for `(SP ∈ SRAM, Thumb reset ∈ image)`:

- **Zero** candidates at flash bases `0x08000000` / `0x08004000` / `0x00000000`.
- Eight weak hits if you pretend the base is **SRAM** `0x20000000` (odd vectors 4–5/16). Those SPs look like code-ish words (`0x2001dc6d`), not a stack top. Treat as coincidence.

Five even-aligned `0xB661` (`cpsie f`) bytes exist (`+0x2F534`, `+0x2F5DC`, `+0x3AD86`, `+0x55038`, `+0x550E8`). Linear Thumb around them is soup (`bgt` / `stmdb` / `bne.w` into `0x07FE263C` — the same bogus flow Ghidra’s decompiler warned about). Do not seed a new pass from `cpsie` alone.

### 7.4 Retired `0x18F2C` under this (untrusted) Thumb map

At assumed base `0x08000000`:

| Addr | Bytes | Listing |
|---|---|---|
| `08018F26` | `02 2a` | `cmp r2, #2` |
| `08018F28` | `40 b3` | `cbz r0, …` |
| `08018F2C` | `0e d9` | **`bls …`** — this is what PATCH14 NOPed |

The old campaign did **not** even patch the `cmp #2`. Surrounding `muls` / `asrs` / `stmia r7,{…,r7}` still looks misaligned. **Do not patch this offset.**

### 7.5 UART immediates in the polluted listing (FW1 preview only)

Ghidra `movs rN, #imm` in *defined instructions* (ASCII `"such"` filtered because those bytes were not kept as `movs`):

| Imm | Count | Notes |
|---|---|---|
| `#0x68` frame head | **0** | Earlier Python `movs` hits were string pool. No code `movs #0x68` in this listing. |
| `#0x10` | 11 | Still too common (`#16`). |
| `#0x22` | 3 | `0800665A`, `08006666` sit in repeating `movs/ldrb/adds/muls/bgt` — data-shaped. |
| `#0x23` | 2 | `0800C7FE`, `080440E4` — same problem. |
| `#0x2B` | 6 | Includes `080094E2` next to `movs r0, #0x2E` / `#0x35` / `#0x36` soup. |
| `#0x36` | 5 | |
| `#0xAA` | 0 | |

Need a **clean** listing before calling any of these a command dispatcher. Checksum loop (one’s complement over the frame with the checksum field zeroed) is still the distinctive search.

### 7.6 Entropy hint — corrected

4 KiB Shannon entropy is high almost everywhere (6.1–7.1). Slightly **lower** around `+0x21000` (5.24) through `+0x2E000`. **That is not “more likely ARM.”** Those pages are dominated by a repeating 16-bit word (`0xE468`); repetition lowers entropy. The string pool at `+0x35000` (5.43) is ASCII. `+0x5B000` is the zero tail.

### 7.7 How to re-run

```powershell
$env:JAVA_HOME = "C:\Users\Joshua\tools\jdk-21.0.12.1+1"
$env:PATH = "$env:JAVA_HOME\bin;$env:PATH"
powershell -NoProfile -ExecutionPolicy Bypass -File scripts\fw0_ghidra_headless.ps1
```

`Fw0SetThumb.java` is now the **strict** seeder (low-entropy windows only). Pass 3 used it.

### 7.8 Conservative Ghidra (pass 3)

`TMode=1`, 16 window seeds, no PUSH spray, Aggressive Instruction Finder on.

| | Pass 2 (PUSH spray) | Pass 3 (windows) |
|---|---|---|
| Instructions | 37,686 | **17,903** |
| Functions | 5 | **0** |
| Xrefs to version / uC/OS / encrypt / PttTask | 1 (false) | **0** |
| Seed at `+0x21000` | — | `strh r5,[r4,#0x1a]` (the `68 e4` soup) |

Zero string xrefs is the honest result: Ghidra Cortex is disassembling a non-Thumb stream. Decompiler again walks into unmapped `0x07FExxxx`.

---

## 8. The blob is not compiler Thumb

Reproducible: `python scripts/fw0_isa_fingerprint.py`.

| Marker | Count in 378,620 B (even-aligned) | What real Cortex-M looks like |
|---|---|---|
| `bx lr` (`0x4770`) | **1** | hundreds |
| `pop {…,pc}` (`0xBDxx`) | 22 | hundreds |
| `push {…,lr}` (`0xB5xx`) | 304 | similar order to pops |
| `0xE468` (bytes **`68 e4`**) | **5,815** | rare as a single `B` encoding |

After `0xE468` the next halfword is almost always `0x10xx`:

`0x1003` (1447), `0x1007` (909), `0x1000` (430), `0x100b` (424), `0x100f` (394), …

That is a **two-halfword instruction** (opcode + 0x10-prefixed immediate), not Thumb `B` + a random following op.

Aligned 4-byte repeats match the same stream (`68 e4 03 10` n=723, `60 83 cc 74` n=673, …). Capstone at `+0x21000` decodes them as `b` / `asrs` / `str` / `strb` — which is why skip-invalid “Thumb coverage” was 97% everywhere: dense 16-bit encodings will *always* decode garbage.

PUSH/POP-matched “functions”: 4 hits; linear Thumb inside them is `cdp` / `bkpt` / repeating `str r5,[sp,#…]`. Coincidental.

Thumb `BL` encodings: 210, **3** land inside the image; 175 sit in `+0x37000` (data). Not a call graph.

`0x2001e463` appears 234× (bytes `63 e4 01 20`) — a repeated pattern, not 234 copies of one SRAM function pointer. Header words include `0x2001DCE8` / `0x2000DCE8` (SRAM-shaped) mixed with the same `e8 dc` bytes; do not treat the file start as a vector table *or* as a proven SRAM load map.

**FW-B1 landmine:** grepping for UART head `0x68` then tail `0x10` hits this opcode (`68 e4` … `10 xx`) thousands of times. The checksum loop (16-bit one’s complement, field zeroed) is still the distinctive search, and it has to run on a listing in the **right** ISA.

---

## 9. ISA = C-SKY V2 (2026-08-27, same session)

C-SKY V2 (T-HEAD 800 / CK801–CK810, e.g. **CK803S** on some DMR handhelds) mixes 16- and 32-bit ops: **bits 15:14 of the first halfword `11` ⇒ 32-bit**, instruction `(hw0<<16)|hw1`, opcode = bits 31:26. Matches LLVM `CSKYInstrFormats.td`.

`python scripts/fw0_csky_walk.py` walking the **whole file** from offset 0:

| Marker | Count | Random 16-bit expect | LLVM encoding |
|---|---|---|---|
| `rts16` | **807** | ~3 | `0x783C` exactly |
| `nop` | 400 | ~3 | `0x6C03` |
| `push16` | 735 | ~92 (32 encodings) | `0x14C0–0x14DF` |
| `pop16` | 1292 | ~92 | `0x1480–0x149F` |
| `nie` | 2 | — | `0x1460` (interrupt enable; rare is right) |
| 32-bit `ld32` / `st32` | 4450 / 4190 | — | opcode `0x36` / `0x37` |
| `alu32` | 5036 | — | `0x31` |
| `movi32` (0x3a sop `0x10`) | 2337 | — | `0xEA000000` class |
| `lrw32` (0x3a sop `0x14`) | 853 | — | `0xEA800000` |
| `br32` (0x3a sop `0x00`) | 352 | — | `0xE8000000` |
| `subi32` (0x39 sop 1) | 7720 | — | **this is `0xE468` + `0x10xx`** |

The old “`68 e4` stream” is not a mystery DSP: `0xE468` = opcode `0x39`, `rz=3`, `rx=8`; next halfword `0x10xx` is sop=`subi` + `imm12`. Thumb `B` was a misread of the C-SKY 32-bit prefix.

**String xrefs (the ARM Ghidra never found):** `lrw32` pool `=((pc+4)&~3)+(imm<<2)` then the loaded word as a **file offset**:

| `lrw32` site | loaded word | String (walked to NUL) |
|---|---|---|
| `+0x1FBE` | `0x0003659C` | **`rxvoice`** (same pool as `cpchanscan` / `encrypt`) |
| `+0x1FDC` | `0x00035644` | `Exec format error` |
| `+0x1BA6` | `0x000355F4` | inside `Interrupted system call` (pool formula may be one word sloppy) |

623/853 `lrw32` literals are in `[0, size)`. High halves cluster on `0x0003` / `0x0004`. That is **link-time base 0**, not `0x08000000`.

No `csky` / `GCC:` / `CK803` banner in the image (stripped). Identification is from the opcode table, not a string.

**Ghidra 12.1.3 has no CSKY processor.** NDS32/Xtensa exist but `rts16=0x783C` is C-SKY-specific; do not import as those.

**HR_C6000** in older notes is the DMR **baseband** (register-mapped modem, OpenGD77 datasheet). This 378 KB blob is the **host MCU** image — same split as Baofeng DM-32 (CK803S + HR_C7x00). AN3155 / STM32 vector-table assumptions do not apply.

---

## 10. UART frame builders (FW-B1, C-SKY)

`python scripts/fw0_csky_uart.py` — synced walk, only `movi16`/`movi32` (not raw `0x68` bytes).

| Imm | Role | movi count |
|---|---|---|
| `0x68` HEAD | 11 | |
| `0x10` TAIL | 162 (many `#16` counters too) | |
| `0x22` SET_DIGITAL | 23 | |
| `0x23` SET_ANALOG | 6 | |
| `0x2B` Q_DIG_AUDIO | 6 | |
| `0x36` STATUS | 22 | |
| `0xAA` INIT | 1 | |
| `0x30` SQUELCH | 82 | noisy (also `#48`) |
| `0x3B` TOT | 12 | |

**Seven HEAD→TAIL pairs** within 16 instructions. Clearest builders (empty 9-byte frames = 8-byte header + tail, `len=0`):

**`+0x8E80`** (same pattern at **`+0x901C`**):

```
st16.b cmd,  (r4, #1)
st16.b sr,   (r4, #3)
movi16 r2, #0x68
st16.b 0,    (r4, #2)     # rw
st16.b 0,    (r4, #6..7)  # len BE = 0
movi16 r0, #9            # total bytes
movi16 r3, #0x10
st16.b r2,   (r4, #0)     # HEAD
st16.b r3,   (r4, #8)     # TAIL
bsr    +0x8E5C           # candidate checksum
movi16 r1, #9
bsr    +0x7DE8           # candidate send
pop16
```

Matches OEM `68 | cmd | rw | sr | ck(2) | len(2) | body | 10`. Tail at offset 8 is correct when body length is 0. Checksum bytes `[4..5]` are **not** written in this snippet — consistent with a helper at `+0x8E5C` (`push16`…`pop16`). Send helper `+0x7DE8` also a `push16`/`pop16` frame.

`bsr32` targets used `pc + SignExtend26(imm)*2` (lands on those two prologues). `+0x7E98` is another builder: `movi32 r12, #0x68` → `st32.b (r4,#0)`, then `movi32 #0x21` into `buf[1]` (cmd `0x21`, not in the OEM 0x22–0x3F table — extra MCU cmd).

`+0x796E`: `movi16 r0, #0x23` / `#0x22` then `bsr` — cmd in `r0` into a shared sender (FW-B2). Those `bsr` encodings (`0xE2804FAC`) do **not** resolve as local `bsr32`; treat as not-yet-decoded 32-bit (jsri/jmpi or a different sop), not ARM.

Naive `0x68`/`0x10` byte grep is still poisoned by `subi32`. Use the movi+store walk.

### 10.1 Checksum — `+0x8E5C` wraps `+0x7D94` (matches OEM `PacketEncoder.pcCheckSum`)

Caller (`+0x8E80`): `r0 = 9` (frame length), `r1 = buf`, then `bsr +0x8E5C`.

Wrapper `+0x8E5C` (listing `scripts/fw0_csky_disasm.py`):

```
r5 = buf+4; r4 = buf+5          # addi16 from r1=buf (oimm3 encoding 3→4, 4→5)
*r5 = *r4 = 0                   # zero checksum field
r0 = buf; r1 = (int16)len
bsr +0x7D94                     # compute
buf[4] = r0 >> 8                # lsri16 #8, st16.b  — big-endian
buf[5] = r0                     # st16.b
```

Compute `+0x7D94`:

```
sum = 0
while remaining > 1:
    w = (buf[i] << 8) | buf[i+1]   # ld16.b, lsli16 #8, or/addu
    w &= 0xFFFF                    # movi32 #0xFFFF; and16
    sum += w
    i += 2                         # addi16 r0, encoding 1 → +2 bytes
if odd: sum += buf[i] << 8
fold 16-bit carries
r0 = (~sum) & 0xFFFF             # not16 r2; zexth16 r0, r2
```

Same as `PacketEncoder.java:39-55`: BE 16-bit words, odd byte padded high, fold, `^ 0xFFFF`. **Proven.**

### 10.2 Send — `+0x7DE8` → `+0x5EF4` (MMIO UART)

After checksum, builder does `r0 = buf; r1 = 9; bsr +0x7DE8`:

```
r6=buf; r5=len
lrw16 r4, <uart object>
bsr +0x18E8                     # begin/lock (r0=obj, r1=0)
r0=buf; r1=len
bsr +0x5EF4                     # put bytes
bsr +0x1924                     # end/unlock
```

Inner `+0x5EF4`:

```
movih32 r2, #0x1409             # base 0x14090000
loop:
  ld16.w r3, (r2, #124)         # status
  andi32 r3, #2                 # wait bit 1
  ...
  st16.w data, (r2, #0)         # TX data register
  cmpne16 r1, r12               # until i==len
rts16
```

So TX is a memory-mapped UART at **`0x1409xxxx`**, not a bit-banged GPIO. Poll bit 1 of `base+124`, write `base+0`. That is the MCU-side counterpart of the app’s `/dev/ttyS0` @ 57600 — two ends of the same wire.

---

Full listing still wants `csky-elfabiv2-objdump` (T-HEAD mingw tarball; not installed). Python walkers located builder, checksum, and send. Do not patch `+0x8E80` or `+0x18F2C`.

---

## 11. FW-B2 — RX dispatch and analog `0x23` (2026-08-27)

Scripts: `scripts/fw0_csky_dispatch.py`, `scripts/fw0_csky_b2_follow.py`. Disasm now has LLVM `cmpnei32` (opc `0x3A` sop `0x1A`), `bt32`/`bf32` (sops `0x3`/`0x2`), `jsri32`/`jmpi32`, `bez32`.

### 11.1 There is no `cmpnei cmd, #0x22/#0x23`

Whole-image synced walk: **zero** `cmpnei32` against `0x22` or `0x23` as a UART command byte.

| Hit | What it actually is |
|---|---|
| `+0x44BD4` `cmpnei32 r3, #0x22` | Loop bound (34 iterations of `ld.h` / `cmpne`) — memcmp, not cmd `0x22` |
| `cmpnei16 r5, #22/#23` | 5-bit immediate **decimal** 22/23 (`0x16`/`0x17`), not commands |
| Clusters `cmpnei #0x2B/#0x2D/#0x30` at `+0xF7D0`, `+0x10F4C` | ASCII `+` / `-` / `0`, then `cmphsi #58` (`':'`) — digit parser, not UART |

RX waiter **`+0x7C48`**: wait until `*buf == 0x68`, then `ld.b cmd at buf[1]`. Only **`0x20` and `0x21`** are special-cased (else retry). Other commands are **not** switched here. Empty-frame ACK **`+0x8E7C`** still does `ld.b cmd at buf[1]` and echoes it (57 callers).

So 0x22/0x23 are not found by grepping compares. They are reached by **length / type / a later apply function**, not a `switch(cmd)`.

### 11.2 `+0x794C` is channel-type → mode bits, not the RX parser

```
zextb r0
cmphsi r2, #2 / #4          # type switch
movi r0, #0x20 / #0x24 / #0x23 / #0x22
<0xE2804Fxx>                # not an in-image bsr32
bsr +0x2474                 # ld.b from a global, rts
```

`0xE2804FAC` appears **once** (file `+0x7970`). Decoded as `bsr32` it lands at a huge negative PC. Neighbouring sites are the same prefix `0xE2804Fxx` with different low bytes. Still **unresolved** (jsri/RAM veneer or a 16-bit encoding our length rule eats). Do not treat these as handler entries.

`+0x2474`: `lrw` a global, `ld.b (r3, #3)`, `rts` — a flag, not a command handler.

### 11.3 `movi r0, #0x23` then `bsr +0x3DDC` is MMIO bitmask, not UART

`+0x3DDC` (and twin `+0x3E40`): `cmphsi r0, #32`; `1 << r0` into **`0x1402xxxx`** (or `0x1410`/`0x1411` after subtracting 31/63). `+0x11940` is the same idea on `0xB8<<21` plus `opc 0x30` `mtcr`-class words. These are **IRQ/GPIO enables indexed by a small integer**, including values that coincide with UART cmds. They are not packet parsers.

### 11.4 Analog body unpack — `+0x9A2C` (sq at `#10`)

From a pointer in `r2`, the routine loads **every AnalogMessage body offset** (OEM `encodeBody`, 19 bytes):

| Off | Field | Load |
|---|---|---|
| 0–3 | `rxFreq` bytes | `+0x9A30` … `+0x9A52` (then `lsli`/`or` to 32-bit) |
| 4–7 | `txFreq` bytes | `+0x9A3C` … `+0x9A46` |
| 8 | `band` | `+0x9A7A` `ld32.b r13, (r2, #8)` |
| 9 | `power` | `+0x9A7E` `ld32.b r9, (r2, #9)` |
| **10** | **`sq`** | **`+0x9A6C` `ld32.b r11, (r2, #10)`** → stored `(sp, #164)` |
| 11 | `rxType` | `+0x9A86` |
| 12–15 | tones / `pwrSave` | `+0x9A60`, `+0x9A64`, `+0x9A88`, `+0x9A6A` |
| 16 | `volume` | `+0x9A76` |
| 17 | `monitor` | `+0x9A8E` |
| 18 | `relay` | `+0x9A90` |

Then range checks (`cmphs` vs 1 on band/power — OEM 0/1 only) and **`bsr +0x8E7C`** (ACK). Copies of the same unpack: `+0x9866`, `+0x9D08`. `+0x939C` unpacks analog `#0…#11` **and** digital tail `#140…#162` (`txContact` at 140) — that is an **in-memory channel object**, not the 19-byte UART frame.

Apply follows via **`+0x7A30`**: `bsr +0x794C` (mode bits), then stores to **`0x88<<21` = `0x1100xxxx`** (RF/analog MMIO, distinct from UART `0x1409xxxx`). A `0xB0`-byte `bsr +0x304E8` looks like memcpy into that block.

### 11.5 Squelch clamp — **not** at UART parse **or** analog repack

Scripts: `scripts/fw0_csky_sq.py`, `scripts/fw0_csky_sq2.py`.

`sq` is spilled at `(sp, #164)` (`+0x9A82` `st32.w r11`), then `r11` is reused for `txType`. The analog handler **repacks** that spill back to body offset 10 with **no modify**:

```
+0x9C36  ld32.w r8, (r14, #164)    # sq, as received
+0x9C3E  st32.b r8, (r10, #10)     # analog body[10] — pass-through
+0x9C46  st32.b r13, (r10, #8)     # band
+0x9C4A  st32.b r9,  (r10, #9)     # power
```

Band/power are rejected if not 0/1 (`cmphs r1=1`). Tone indices are bounded (`#0x32` / `#0x53`). A `#9` `cmphs` in the same block is volume-or-sq range (0–9) — either way, **1,3–9 are not rejected by the MCU parser**.

Apply **`+0x7A30`** (14 callers, including the analog unpack at `+0x984A` / `+0x9CF6`):

1. `bsr +0x788C` — fills analog-blob offsets `#161…#164` from a global (not UART `sq`).
2. `bsr +0x304E8` with `r2=#0xB0` — **memcpy** (byte loop + 16-byte chunks). Proven: `ld.b (r1); st.b (r12); dec r2`.
3. `bsr +0x794C` with `r0=1` (mode bits).
4. Packs stack bytes `#355/#356/#360` into MMIO **`0x88<<21` = `0x1100xxxx`** offsets 264 and 276.

`+0x869C` (another analog apply site) does `r7 = (sq<<8)|power` from blob `#10`/`#9` and later writes a shifted byte into the same `0x1100xxxx+264` word. No `if (sq) sq=2` on that path either.

Whole-prefix hunt for `movi #2` then `st.b #10`: **zero hits**. The nearby store-2 (`+0x7288`) is a **tick/counter**: when a global byte exceeds 99 it writes `2` to a different global `[0]`. Callers of `+0x7268` are not the analog unpack. `+0x7E08` (unpack does `movi r0,#2; bsr +0x7E08`) is a **3-byte flag setter** on a global, not squelch.

Hypothesis, now ranked:

1. **Analog IC** (AT1846S-class / HR_C6000 companion) only honours open vs tight — MCU stores 0–9 as received. A RAM-load MCU patch **cannot** create levels 1,3–9.
2. Coerce is inside unresolved `0xE2804Fxx` veneers (unlisted).
3. MMIO `0x1100xxxx` bitfield is 1 bit wide (0 vs nonzero) — still not a byte we can NOP in the parse.

**Do not NOP `+0x18F2C`.** **Do not patch `+0x9A6C` or `+0x9C3E`** — those bytes are the pass-through, not a clamp.

### 11.6 Named sites (file offsets, link base 0)

| Offset | Role |
|---|---|
| `+0x7C48` | RX wait `0x68`; cmd `0x20`/`0x21` only |
| `+0x8E7C` | Empty-frame ACK (cmd echoed from `buf[1]`) |
| `+0x9A2C` | Analog 19-byte unpack + ACK |
| `+0x9C3E` | Repack `sq` → body[10] **as-is** |
| `+0x7A30` | Apply analog config → memcpy `0xB0` + MMIO `0x1100xxxx` |
| `+0x304E8` | `memcpy(dst=r0, src=r1, len=r2)` |
| `+0x788C` | Fill analog-blob `#161…#164` from globals |
| `+0x794C` | Type → `0x20/0x22/0x23/0x24` via unresolved `0xE2804Fxx` |
| `+0x3DDC` | `1<<n` into `0x1402xxxx` |
| `+0x7E94` | Variable-length builder (callers pass cmd `0x22` in `r3`) |
| `+0x7268` | Tick; store-2 is **not** analog `sq` |

---

## 12. FW1 tooling — real C-SKY listings (2026-10-14)

Two disassemblers now exist on the dev machine. Neither patches or flashes; both are read-only on `ORIGINAL.bin`.

| Tool | Where | Notes |
|---|---|---|
| T-Head GNU binutils 2.27 (`csky-elfabiv2-objdump.exe`) | `C:\Users\Joshua\tools\csky-elfabiv2\bin` | From `Taixin-Semiconductor/XuanTie-CSKY-Toolchains` release `csky-elfabiv2-tools-mingw-minilibc-20250328.tar.gz`, SHA-256 `3eb0fa86…0f27f2` verified. Git-Bash `tar` fails on the archive; extract with Python `tarfile`. |
| Ghidra C-SKY v2 processor module | `C:\Users\Joshua\tools\ghidra_12.1.3_PUBLIC\Ghidra\Extensions\C-SKY` | `taligentx/ghidra_csky_WinnerMicro` v0.2 (fork of `leommxj/ghidra_csky`), `extension.properties` pinned to `12.1.3`. Sleigh compiles clean at first use. Language id `CSKY_V2:LE:32:default`. |

**Commands**

```powershell
# full listing (gitignored, ~6.5 MB)
C:\Users\Joshua\tools\csky-elfabiv2\bin\csky-elfabiv2-objdump.exe -D -b binary -m csky -EL --adjust-vma=0 radio_firmware\DMR003.UV4T.V022-ORIGINAL.bin > radio_firmware\fw1_csky_objdump.txt
# Ghidra headless, base 0, seeded at push16 prologues + the §10-11 anchors
powershell -NoProfile -ExecutionPolicy Bypass -File scripts\fw1_ghidra_csky.ps1   # project radio_firmware\ghidra_project_fw0\DMR003_UV4T_V022_csky
```

Scripts: `radio_firmware/ghidra_scripts/FwCskySeed.java` (pre), `FwCskyStats.java` (post). The module author's advice is followed: Aggressive Instruction Finder, Decompiler Parameter ID and Non-Returning-Discovered are off.

**Results**

| Measure | objdump | Ghidra |
|---|---|---|
| Decoded | 144,091 listing lines, 1,303 words left as data | 83,090 instructions |
| Functions | — | **1,057** (749 `push16` seeds + 19 anchors, then call-following) |
| `+0x7D94` checksum | byte-for-byte the §10.1 hand decode (`zexth`/`sexth`, BE word loop, odd-byte `lsli 8`, carry fold, `not`, `zexth`) | identical |
| `+0x7DE8` send | `lrw` uart obj → `bsr 0x18e8` → `bsr 0x5ef4` → `bsr 0x1924` as §10.2 | identical |
| `+0x7C48` RX waiter | `cmpnei r3, 104` (0x68) then `cmpnei 32/33` — §11.1 confirmed | identical |
| `rxvoice` xrefs | — | 4 (`FUN_00001bf8`, `FUN_0000202c`) |
| Other string anchors (version, `encrypt`, task names) | — | 0 direct xrefs — reached through pointer tables, not `lrw` |
| Callers of ACK `+0x8E7C` | — | 27 by Ghidra's call graph (§11.1 counted 57 by immediate scan) |

So the hand walkers were right where they reached, and FW-A3 is **closed**: ISA C-SKY V2, link base 0. The to-do "`csky-elf-objdump` still useful" is done.

**The `0xE2804Fxx` words are resolved.** They are ordinary `bsr32` whose targets lie far outside the 378 KB image (e.g. `0xFD011884`, `0xFD0118C8`, `0xFCFF619C`). Across the listing: 4,832 in-image `bsr` versus 1,583 call sites to about 25 distinct out-of-image targets. Those targets are therefore code that is *not in this file* — a second component (mask ROM, bootloader or a separately loaded library) at a different link address. §11.2's "unresolved veneer" and §11.5 hypothesis 2 both point here: the type→command mapper at `+0x794C` and several analog-apply steps call into that region. Whatever it is, it cannot be inspected from `ORIGINAL.bin`, and it is a further reason not to attempt blind RAM-load patches on paths that cross into it.

**Open after this run**
- Decide what the out-of-image region is (the YModem update only carries this one file; the module may have a resident ROM). Read-only observation on a device is the only way.
- Name the 0x22 digital unpack (the §11.4 analog twin) in the Ghidra project.
- Walk the `rxvoice` callers toward the RX voice path.

---

## 13. FW1 continued — digital `0x22` unpack found; memory map still open (2026-10-14)

Source: `radio_firmware/fw1_csky_objdump.txt` (regenerate with the §12 command). Read-only findings; nothing patched.

### 13.1 Digital channel unpack = `FUN_00009310` (body copy at `+0x9394`)

`+0x9310 push r4-r11, r15; subi sp, 588`. After the frame arrives: `movi r2, 163; addi r0, sp, 424; bsr +0x304E8` — **memcpy of exactly 163 bytes**, the OEM `DigitalMessage` body length. It then reads the OEM offsets byte-wise (file offsets of the loads in brackets):

| Body off | OEM field (ch. 02 §3.2) | Load |
|---|---|---|
| 0–3 / 4–7 | `rxFreq` / `txFreq` (assembled with `lsli 8/16/24` + `or`) | `+0x939C…+0x9414` |
| 8–11 | `localId` | `+0x93C6`, `+0x93B4`, `+0x93D2`, `+0x9414` |
| 140–143 (`0x8C–0x8F`) | `txContact` | `+0x93CA`, `+0x93B6`, `+0x93D6`, `+0x9418` |
| 144 (`0x90`) | `contactType` | `+0x93BE` → spilled `(sp,0xA0)` |
| 145 / 146 | `power` / `cc` | `+0x945E` / `+0x9422` |
| 147 / 148 | `inboundSlot` / `outboundSlot` | `+0x9448` / `+0x9450` |
| 149 / 150 | `channelMode` / `encryptSw` | `+0x9466` / `+0x946A` |
| 159–162 (`0x9F–0xA2`) | `pwrSave`, `volume`, `mic`, `relay` | `+0x946E…+0x947E` |

Frequency range checks follow, using literal pairs `(−400 000 000, 120 000 000)` and `(−136 000 000, 38 000 000)`: i.e. **400–520 MHz** or **136–174 MHz** accepted, otherwise one of the `bsr +0x8E7C` ACK-and-return exits (`+0x957C`, `+0x95A0`, `+0x95C4`). That is the FW4 band-limit validation — **document only**, per plan §7.

Branches on the DMR fields (all FW5-relevant, none understood yet):
- `+0x941E cmpnei r11, 2` — `contactType == ALL`.
- `+0x95E6 cmpnei r7, 3` — a fourth `contactType` value the app never sends.
- `+0x9512/+0x9516` — `channelMode` is 0 or 4 (OEM Direct / Double-slot), else error exit.
- `+0x962E cmpnei r0, 32` closes a **32-iteration loop** (`+0x9606…+0x9632`) that walks `ldr.w (r8, r7<<2)` over the copied body — the `groups[32]` list **is** consumed by the MCU, at least into a RAM structure. Whether the RX path then uses it is the open question (hard constraint "firmware ignores groups[]" is behaviour-level evidence, not yet code-level).
- Success path `+0x9540`: `bsr +0x8E7C` (ACK), clear a byte at `*(0x3244C+0xB)`, `bsr +0x1924` (unlock), return. `+0x9566`: `movi r0,2; bsr +0x7E08` (same 3-byte flag setter the analog handler uses) then `bsr +0x6354`.

The analog twin is `+0x9A2C` (§11.4); both share the ACK, lock/unlock (`+0x18E8`/`+0x1924`) and flag-setter helpers. The in-memory channel object noted in §11.4 at `+0x939C` is this same function's post-memcpy read-out.

### 13.2 Task creation = `FUN_00001BF8`

A straight-line sequence of ten blocks, each: `memset(stack, 0, 1536)` via `bsr +0x30568`, build a 9-word argument block on the stack (`prio` 17–26, stack size `0x180/0x300`, option `3`), load `r0/r1/r2` from pools, then **`bsr 0xFCFF8F88`** — an out-of-image call with 58 sites, by shape `OSTaskCreate`. So the **uC/OS-III kernel is not in this file**; it lives in the external region the `bsr`s reach. The pool values passed as `r1`/`r2` are `0x0305xxxx` / `0x0302xxxx–0x0303xxxx` (plus one `0x0002C8DC`): RAM or a second code region, not provable from this image.

### 13.3 Memory map — what the listing says and does not say

| Evidence | Reading |
|---|---|
| `lrw` pools → in-file string offsets (`rxvoice` @ `+0x3659C`) | this image is addressed at **0** |
| 1,583 `bsr` sites → ~25 targets in `0xFCFF6000–0xFD014690` (PC − ≈48 MB) | a second code region (kernel + libc-class helpers: the top targets have 392/322/320 callers) — **not in the YModem image** |
| Task entry / name pointers `0x0302xxxx–0x0305xxxx` | a third region, likely SRAM |
| Vote "which base makes task pointers or far targets land on function starts": no candidate above noise (`scripts` ad-hoc, 1,821 start candidates) | **no alias of this image at `0x03000000` or elsewhere** is supported |

Working model: boot ROM / resident kernel (external) + this 378 KB application image at 0 + SRAM at `0x03xxxxxx`. The RAM-load update replaces only the application. Consequences: (a) OS calls, `memcpy`-class helpers and whatever the type→cmd mapper `+0x794C` calls cannot be read; (b) any RX-group-list decision taken inside the external region is invisible to static analysis of `ORIGINAL.bin`; (c) the 0x24/0x25 **readback** test from the RumiTX comparison remains the cheapest way to learn what the MCU stored.

---

## 14. FW1 — the phone-protocol dispatcher and the channel readback (2026-10-14)

### 14.1 Routing (corrects §11.1)

`+0x7C48` is the UART RX task loop, not a "0x20/0x21-only" waiter. After `buf[0]==0x68` and 7 more header bytes:

| `buf[1]` (cmd) | Action |
|---|---|
| `0x20`, `0x0F` | discard, restart |
| `0x21` | `bsr +0x8BE4` — a **second protocol family** (sub-command in `buf[2]`, 35 entries, jump table in RAM `0x030520D8`). The MCU also *emits* `68 21 <sub> <01|FF> …` frames via `+0x7E94` (subs 1,2,3,4,16–20,34). The OEM app has no 0x21 handler and drops them silently (ch. 01 §6). |
| anything else | `bsr +0xAA3C` — **the phone-protocol handler** |

### 14.2 `+0xAA3C` — validate, then `switch(cmd − 0x22)`

Length = BE `buf[6..7]` (+1 for the tail), rejected if ≥ 800; waits for the rest; checks `buf[0]==0x68`, `buf[len−1]==0x10`, recomputes the one's-complement checksum (`+0x7D94`); then

```
+0xAAA2  ld.b  r3,(r4,1)          ; cmd
+0xAAA4  subi  r3, 0x22
+0xAAA8  cmphsi r3, 105           ; cmd 0x22..0x8A accepted
+0xAAAE  lrw   r2, 0x03052240     ; jump table in RAM
+0xAAB0  ldr.w r3,(r2,r3<<2) ; jmp r3
```

The table itself is **not in the image** (no run of case addresses at any alignment/offset — it is filled by the external component), so cmd→case is partly inferred. The 35 inline cases at `+0xAAC8…+0xABF2` each do `mov r0,r4; bsr <handler>` — this is the real "`cmd_handler.c`":

| Case → handler | What it does | Likely cmd |
|---|---|---|
| `+0xABEA → +0x9310` | 163-byte digital unpack (§13.1) | **0x22** |
| `+0xABE2 → +0x99B4` | contains the 19-byte analog unpack `+0x9A2C` (§11.4) | **0x23** |
| `+0xABDA → +0x9E3C` | reply **163 B** from `0x38E4C` via `+0x90B0` | **0x24 QUERY_DIGITAL — channel readback exists** |
| `+0xABD2 → +0x9E4C` | reply **19 B** from `0x38C70` | **0x25 QUERY_ANALOG — readback exists** |
| `+0xAB26 → +0x9E5C` | reply **169 B** from `0x38AB0` | 0x39 QUERY_MIX_CHECK (OEM has no message class for it) |
| `+0xABC2 → +0x9E24` | ACK with `sr` = bit 5 of status byte `0x38908` | a status query |
| `+0xAAD8` inline → `+0x8E0C` | 1-byte body → external call pair (`0xFD01125C`/`0xFD011220`, args `68`): a register read-modify-write with the byte in bits 8–15 | volume / squelch / mic-gain class (0x2E/0x30/0x2A) |
| `+0xABF2` inline | 3-byte **BE** value from body[0..2] → `(r8,0x14)` | an ID setter (0x28 ENHANCE or SMS target) |
| `+0xAB3E` inline | sets bits 0/1 of flag byte `0x38EF0` | a mode toggle (0x2F LISTEN / 0x31 PWR-SAVE class) |
| `+0xAB2E → +0x8EA8` | plain ACK | a no-op command |
| `+0x8EB4`, `+0x8F18`, `+0x8FA8` | body[0] ∈ {1,2,3} switches with ACK | 1-byte enum commands (0x33 relay, 0x35 interrupt, 0x37 policy…) |
| `+0xA34C … +0xA898`, `+0x9264`, `+0x9FB8`, `+0xA1DC` | larger handlers, not read | SMS (0x2C/0x2D), encrypt (0x29), TOT (0x3B), BER (0x3F), audio query (0x2B)… |

**`+0x90B0` is the generic reply builder:** `(cmd, sr, body*, len)` → `68 cmd sr 00 ck ck len(BE) body 10`. Its other callers answer with 1, 9, 27 and 33-byte bodies (`+0xA6BA`, `+0xA886`, `+0xC056`, `+0xA020`) — candidates for version (0x34), digital-audio info (0x2B), RSSI (0x32) and SMS fetch (0x2D).

### 14.3 Consequences

- **The 0x24 / 0x25 readback is real firmware behaviour.** The MCU keeps the last-written digital (163 B at `0x38E4C`) and analog (19 B at `0x38C70`) channel images and returns them on request. The OEM app registers handlers for both but never sends them (ch. 02 §6). One `com.dmrmod.SEND_DEBUG_PACKET` broadcast per command on a device (`CMD=36` / `CMD=37`, `BODY=01`) will show exactly what the MCU stored — squelch byte, group list, `txContact`. This is the ground truth the squelch and group-call questions have lacked; it is the recommended next device step (backlog FW2/FW-B3).
- The 0x21 family is unexplored and never reaches the app's dispatcher. Whether it carries anything useful (its `01/FF` sub-frames look like start/stop events) can be settled by the mod's UART logger, which sees raw frames before `MessageDispatcher` drops them.
- `+0x7E94` is a 0x21 builder, **not** a generic command builder — §10's "callers pass cmd 0x22 in r3" was a sub-command 0x22 of family 0x21.

---

## 15. FW2 — live readback on the device (2026-10-14, Armor 26 Ultra, module v3.4.5 installed)

Method: OEM app started (`am start -n com.pri.prizeinterphone/.InterPhoneHomeActivity`), then `com.dmrmod.SEND_DEBUG_PACKET` broadcasts; every frame captured by the mod's UART logger (`/sdcard/DMR/uart_logs/uart_20261014_103816.txt`). All replies carried `rw=0 sr=0` and valid checksums. The channel the app had programmed was restored at the end (re-sent byte-exact, readback confirmed).

| Time | TX | RX | Result |
|---|---|---|---|
| 10:38:20 | app's own `0x22` (163 B: 443.200 / 448.200 MHz, localId 1447, groups[0]=1, txContact 1, GROUP, CC 11, mode 4, encrypt off) | `0x22` ack | boot-chain write, used as reference |
| 10:38:28 | **`0x24` body `01`** | **163 B, byte-identical** to the write above | `QUERY_DIGITAL_INFO` **works**; MCU keeps the full digital image |
| 10:38:31 | **`0x25` body `01`** | 19 B: all zero except `sq=3`, `volume=8` | `QUERY_ANALOG_INFO` **works**; stale analog slot (never written this session) |
| 10:39:55 | `0x23` analog: 446.000/446.000, band 1, power 0, **`sq=5`**, no tones, pwrSave 2, vol 8, mon 2, relay 2 | ack `sr=0` | MCU accepted squelch 5 |
| 10:39:57 | `0x25` | **19 B byte-identical, `sq=5`** | **MCU stores squelch as sent** — confirms §11.5: no clamp in the MCU image |
| 10:39:59 | `0x22` with **groups[0..2] = 1, 2, 3** (rest as reference) | ack `sr=0` | — |
| 10:40:01 | `0x24` | 163 B with **`01 00 00 00 02 00 00 00 03 00 00 00`** at offset 12 | **groups[] is stored** in the MCU's channel image, all three slots |
| 10:40:03 / 05 | reference `0x22` re-sent, `0x24` | identical to 10:38:28 | restored |

No `0x21`/`0x20` frames appeared on the wire during a normal boot + these queries (only `0xAA, 0x34, 0x22, 0x35, 0x3B` and the queries).

**What this settles**
- Readback is a first-class tool: any future firmware or codeplug question of the form "what did the MCU actually receive" is one broadcast. Worth a Diagnostics-page button (backlog S7) that prints both images decoded.
- Squelch: the hard-constraint wording "firmware coerces 1,3–9 to 2" is **not** true of the MCU's stored value. If levels 1,3–9 really behave like 2 on-air (the 2026-03 behavioural finding), that happens downstream of the stored byte — in the analog apply path to the RF IC (`+0x7A30` → `0x1100xxxx`) or in the IC itself. A listening test with a weak signal at `sq=0/2/5/9` is the remaining experiment; it needs an RF source.
- Group list: the MCU keeps all 32 slots as written. The "firmware ignores `groups[]`" constraint therefore describes the **RX filter**, not storage. Whether the RX path consults the stored list is the FW5 question and needs a second DMR transmitter.

**Residual state:** the analog slot on the radio now holds 446.000 MHz / `sq=5` until the user selects any analog channel (the app rewrites it). The active digital channel is unchanged.
