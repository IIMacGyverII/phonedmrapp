# 03 — Our patches and images

Part of the firmware reference for the Ulefone Armor 26 Ultra radio module (factory image `DMR003.UV4T.V022`, 378,620 bytes, MD5 `4426035392262ca54583c230c9e268e0`, C-SKY V2 on the HR-C7000, RF IC AT1846S). This chapter covers **everything we added to the image**: the patch system, command `0x40` opcode by opcode, the transmit key path we built around the stock `0x26` handler, every image from the UVm series to FW56, where the four `0x26` call sites point in each image, and a provisional map of the free tail as FW54 uses it.

Compiled 2026-10-30 (read-only: nothing was loaded, keyed or transmitted for this chapter). Disassembly with `csky-elfabiv2-objdump -b binary -m csky -D` on the files in `radio_firmware/build/`; call targets with `fw30_build.bsr_target`.

## Contents

- §0 Conventions and sources
- §1 The patch system (`patches.toml`, `build.py`, `check.py`, `literal_guard.py`, tests)
- §2 Command `0x40`, opcodes 1–18
- §3 The key path we built
- §4 Every image: source, change, reason, result, hash
- §5 The four `0x26` call sites in every image
- §6 The free tail `0x5AEFC`–`0x5C6FB` as FW54 uses it (provisional)
- §7 Where the sources disagree
- §8 Open questions
- §9 Lessons

---

## 0. Conventions and sources

### 0.1 Labels

| Label | Meaning |
|---|---|
| **V** | Verified: read in the bytes, the code or a test for this chapter, or a bench record that states the measurement. |
| **V-bench** | The bench record states it (results/reviews), not re-checked here. |
| **I** | Inferred: follows from the code or a measurement but is not shown directly. |
| **C** | Computed for this chapter (sha256 of a build file, a diff, a disassembly). |

### 0.2 Sources and short names

| Short | File |
|---|---|
| `toml` | `tools/fw-patch/patches.toml` (41 named patches) |
| `sym.S` | `tools/fw-patch/stubs/c7000_cmd40_sym.S` |
| `gate.S` | `tools/fw-patch/stubs/c7000_fw20_gate.S` |
| `fwNN` | `tools/fw-patch/fwNN_build.py` (and `fw3b_bisect.py`, `fw30_port.py`, `f43d_build.py`) |
| `res:L` | `radio_firmware/results.md`, line L |
| `rev:L` | `radio_firmware/reviews.md`, line L |
| `HO:L` | `radio_firmware/HANDOFF.md`, line L |
| `d19 §n` / `d19:L` | `docs/deep-dive/19-firmware-modification-plan.md` |
| `d18 §9` | `docs/deep-dive/18-firmware-modding-plan.md` §9 |
| `map` | `radio_firmware/fw54_space_map.md` (being rewritten by the firmware agent while this chapter was written) |

Addresses are **file offsets** unless written as XIP (`0x0301A000 + offset`) or RAM (`0x3xxxx`, `0x4xxxx`) or peripheral (`0x11xxxxxx`, `0x16xxxxxx`, `0x18xxxxxx`). The stubs run from XIP flash; any absolute pointer to tail code or data is `0x0301A000 + file offset` (`res:2466`, FW21: a load of the link address never returns).

Bench IDs only (N0CALL, DMRTST-7); no owner callsign or DMR ID appears here.

---

## 1. The patch system

### 1.1 Two ways an image is made

| Way | Used for | How it is checked |
|---|---|---|
| **Named patches** in `patches.toml`, applied to the factory file by `build.py --tag XXXX name…` | UVm1–UVm11, R300/R301, R3a*–R4t, RC/RD/RE/RG, **FW19, FW20** | `build.py` checks every site's factory bytes and refuses overlaps; `check.py` attributes every changed byte to a site |
| **Per-image build scripts** `fwNN_build.py` that read the previous image (`SRC`) and write the next | **FW21 onward** (and all lettered diagnostics) | Each script asserts the bytes it expects before writing, and from FW27 on runs `literal_guard` checks; `check.py` knows FW21/FW22 only by pinned hash |

**V (C):** rebuilding with `build.build()` reproduces the files byte for byte: FW19 = `c7000-cmd40-sym` + `c7000-tot-120` (`555b0128…`), FW20 = `c7000-fw20-drop` + `c7000-tot-120` (`31ecdd30…`), RG10 = `c7000-cmd40-sym`, UVm1 = tag only, UVm2 = `fm-flat-58`, UVm3 = `c7000-fm-flat`, UVm4 = `c7000-fm-flat` + `fm-flat-58`, UVm5 = `fm-flat-58dd` + `ctcss-hpf-keep`, UVm6 = `fm-flat-58fd` + `ctcss-hpf-keep`, UVm7 = `c7000-fm-canary`, UVm8 = `c7000-fm-proof`, UVm9 = `fm-flat-58bcfd` + `ctcss-hpf-keep`, Vm10 = `c7000-fm-adcgain`, Vm11 = `c7000-fm-dacgain`, R301 = `c7000-iram-padbyte`.

### 1.2 `build.py`

`tools/fw-patch/build.py` (107 lines). **V:**
- Loads `patches.toml`; the `[factory]` table names the file, its size (378,620) and MD5. A different factory file is refused.
- For every site: original and replacement must be the same length, the factory bytes at `offset` must equal `original`, and **no byte may be claimed by two patches** (`check_sites`, the `owner` dict). That overlap check is the only mutual-exclusion mechanism; `patches.toml` has no `conflicts` field (its keys are only `why`, `measured_by`, `status`, `sites`).
- The tag replaces the 4-character `UV4T` field at decimal offset 230507 (`0x3846B`) inside the version string at `0x38464`–`0x38473`; it must be 4 ASCII letters/digits and differ from `UV4T`. `0x34` reports this string, so every image names itself.
- Writes `radio_firmware/build/<version>.bin` and a `.sha256` sidecar. The image size never changes.

### 1.3 `check.py`

`tools/fw-patch/check.py` (74 lines). **V:** diffs an image against the factory file; every changed byte is attributed to a `patches.toml` site or the tag, anything else is printed `UNKNOWN` and the exit code is 1. FW21 and FW22 are accepted by **pinned sha256** (`PINNED`: `f726056a…77ed`, `38f900a0…8d6a`) because their extension is not a `patches.toml` row. **Every image after FW22 fails `check.py`** by design (its bytes are not in the TOML and not pinned); for those, the build scripts' own assertions and `literal_guard` are the checks.

### 1.4 The named patches (`patches.toml`, all `status = experimental`)

| Patch | Sites (offset: factory → ours) | What it does | Measured by (toml) |
|---|---|---|---|
| `fm-flat-58` | `0x2C90`, `0x3054`, `0x344E`, `0x34F2`, `0x3640`: `0584`→`c584` | AT1846S reg `0x58` = `0x84C5` at the five analog no-tone sites (bits 6+7: voice HPF and emphasis bypass) | UVm2 |
| `fm-flat-58dd` | same five → `dd84` | `0x84DD` (adds CTCSS bits 3+4); load with `ctcss-hpf-keep` | UVm5 |
| `fm-flat-58fd` | same five → `fd84` | `0x84FD` (adds bit 5, voice LPF) | UVm6 |
| `fm-flat-58bcfd` | same five → `fdbc` | the DMR value `0xBCFD` on analog | UVm9 |
| `ctcss-hpf-keep` | `0x333A`: `f7ff`→`ffff` | the no-tone read-modify-write mask `0xFFF7` becomes `0xFFFF`, so bit 3 sticks | UVm5/6/9 |
| `c7000-fm-flat` | `0x3074` bsr → stub `0x5B000` (32 B, `c7000_fm_flat.S`) | after the AT1846S write, `FM_BANDWIDTH`=`0x0F`, `FM_DEV_COEF` from pool | UVm3, UVm4 |
| `c7000-fm-canary` | same, pool `tr_sig_lim` `0x02` | limiter canary | UVm7 |
| `c7000-fm-proof` | same redirect, 44-B stub | adds `0x58`=`0x84C5` from the stub to prove it runs | UVm8 |
| `c7000-fm-adcgain` | redirect + 48-B stub + `0x61FE`/`0x620C`/`0x6228` subi immediates | codec `GCR_ADCL` −6 dB | Vm10 |
| `c7000-fm-dacgain` | `0x36ED0` (20 B table) | `GCR_DACL` table −6 dB | Vm11 |
| `c7000-iram-padbyte` | `0x3EE16`: `00`→`58` | one padding byte inside the IRAM copy; proves the copy has no whole-image check | R301 (R3-0) |
| `c7000-txram-square` | `0x3EDFC` (IRAM key-up bsr), `0x92B2`/`0x929C` (flag set/clear), stub `0x5B000` (124 B) | gated TX-RAM square | R3a2 |
| `c7000-txram-dmr` (+ `-a512/-a1024/-a2048/-a4096`) | **the four `0x26` sites** `0x92C8`/`0x92E0` → `on_key`, `0x92AA`/`0x92FA` → `on_unkey`; stub `0x5B000` (188 B) | host-keyed TX RAM square, amplitude ±256…±4096 | R3a3–R3a7 |
| `c7000-txram-dmr-sine1k` (+ `-p4096`, `-p5120`) | four sites, stub 212 B | 1 kHz sine, peak 2048/4096/5120 | R3a8, R3a9, R3b0 |
| `c7000-txram-dmr-rrc` | four sites, stub 180 B + table `0x5C000` (1024 B) | fixed RRC 4FSK pattern | R4a0 |
| `c7000-txram-m17-lsf` | same + LSF table | one M17 link-setup frame looped | R4b0 |
| `c7000-txram-m17-stream` | four sites, poll stub 348 B, table `0x5B400` (4860 B) | poll `FM_ADDR_SW` | R4c0 (fail) |
| `c7000-txram-m17-wake` | four sites + **wake sites `0x18B5C`/`0x18B68`**, stub 432 B + table | refill from the service wake, cursor `0x4DAAC` | R4d0 |
| `c7000-txram-m17-loop`, `-loop5`, `-pay16`, `-lich5` | same sites | loop variants | R4e0–R4h0 |
| `c7000-txram-m17-eot1/2/3` | same + `0x5AEFC` (260 B) + end frame `0x5B170` | end of transmission; eot3 posts status 4 via `0x7E08` | R4i0–R4k0 |
| `c7000-cmd40-ack` | `0x382B8` slot → thunk at `0x35F64` | **first `0x40`: placed in a live data table, did not boot** ("Do not reload") | R4l0 |
| `c7000-cmd40-ack2` | `0x382B8` → `0x5AEFC` (20 B) | `0x40` acks from the tail | R4m0 |
| `c7000-cmd40-echo` | `0x382B8` → 62-B echo | echoes body byte | R4n0 |
| `c7000-cmd40-host`, `-m17`, `-swap`, `-m17swap` | `0x382B8` + four `0x26` sites + two wake sites + handler at `0x5AEFC` | host samples into RAM, wake plays them | R4o0–R4r0 |
| **`c7000-cmd40-sym`** | `0x382B8`→`0x5AEFC`; `0x92C8`/`0x92E0` → `on_key` **`0x5B580`**; `0x92AA`/`0x92FA` → `on_unkey` **`0x5B614`**; `0x18B5C` → `on_wake_disp`, `0x18B68` → `on_wake_skip`; handler 2050 B at `0x5AEFC`–`0x5B6FD` | **the symbol engine (ops 1–7)**, source `sym.S` | RG10, FW19 |
| `c7000-tot-120` | `0xAB18` (`0x3B` thunk bsr) → stub `0x5B700` (24 B, `c7000_tot120.S`) | `0x3B` body 0 or >120 becomes 120 | FW19 |
| `c7000-fw20-drop` | as `cmd40-sym` with the FW20 drain in the handler + `0x5B720` (116 B, `gate.S`) | op 7 end: 8 more halves, `drop_ptt`, stock unkey, timer clear | FW20 |

`test_patches.py` (49 tests) checks each row against the factory file, builds the compatible set together, and lists **every pair that must refuse to stack** (`test_exclusive_variants_refuse_to_stack`: the four `0x58` values among themselves, and every C7000/TX-RAM stub pair that shares the redirect or `0x5B000`). **V.**

### 1.5 `literal_guard.py`

`tools/fw-patch/literal_guard.py`, written after the first FW27 image overwrote the key helper's literal pool (`0x5BE60`, an `lrw r4, 0x4A3E4` at `0x5BBE2`; `res:3579`, d19). All checks compare an old and a new image. **V (code).**

| Function | Fails when | Notes |
|---|---|---|
| `covered_loads(old, new)` | an `lrw` outside every written span (read from the **old** image) loads a literal whose pool word lies inside a written span | "live" = the next instruction uses the register as a base or compare; pools of zeros and `04 00` sine halfwords are skipped |
| `covered_branches(old, new)` | a 16-bit `br/bt/bf` outside the spans lands inside a span | 32-bit `bsr/jmpi` that still name the same target are treated as replaced callees; a span ≤ 4 bytes starting at the target is a one-instruction hook and allowed |
| `changed_branches(old, new, allowed)` | any real branch from outside a span into it, minus a list the build declares | stricter form used for FW28/FW29 |
| `never_written(old, new)` | any byte in `0x35DF4`–`0x35FE3` changed | the live data table whose zero tail R4l0 and FW30 image 3 wrote (both failed to boot) |
| `pointed_into(old, new)` | an aligned word of the old image whose value − `0x0301A000` lands in a changed run, or within 4 bytes before one (the "push then body" case); also a `movih/ori` pair building `0x0307xxxx` | **added 2026-10-30 and uncommitted when this was written** (in the working tree with `test_literal_guard.test_fw56_pointers_land_in_the_patch`); a direct response to FW56 |

**What the three committed guards miss (V, C, run for this chapter):** `covered_loads`, `covered_branches` and `never_written` all return **empty** for FW46→FW49, FW46→FW50, FW46→FW52 and FW54→FW56, although each of those wrote live code or data:

| Image | Live thing written | Reached how | Why the guards did not see it |
|---|---|---|---|
| FW49 | `0x5B65A`–`0x5B661`, the prologue of `drop_ptt` | `0x5BD98`: `lrw r4, 0x0307565A; jsr r4` (pointer at `0x5BDE4`) | a register `jsr` through an XIP pointer is neither a literal-pool overlap nor a PC-relative branch |
| FW50, FW51, FW52, FW56 | `0x5B65C`–`0x5B681`/`0x5B68F`, the **body** of `drop_ptt` (the gate) | same pointer, entry at `0x5B65A` | same; the entry halfword itself was left unchanged, so even an exact "pointer target inside a changed byte" test misses it (C: a plain target-in-run scan finds nothing for FW50/51/52; the uncommitted `pointed_into` adds the 4-byte look-ahead for this reason) |
| FW56 | `0x5B6A0`–`0x5B6B7`, the M17 dibit table (`01 03 FF FD`) and the first 20 bytes of the 5×9 RRC taps at `0x5B6A4` | `0x5B3D8` (`put_sym`): `lrw r4, 0x030756A0`; `0x5B428` (`one_sample`): `lrw r0, 0x030756A4` | data reached through absolute XIP pointers |
| FW52 | `0x5B748`–`0x5B773` (the tone-end task's drop/unkey sequence) | fall-through inside a function | intra-function rewrite; no outside reference to flag |
| FW50/FW52 | `0x5B700`–`0x5B717` | **nothing found** (§3.6) | — |

The rev:2853 review (FW56 rejected) found the same XIP-pointer class and lists the 13 pointers into the tail (§6.1).

### 1.6 Other tests

| File | Covers (V) |
|---|---|
| `test_patches.py` | 49 tests over every TOML patch (factory match, compatible set, exclusive pairs, per-stub byte checks, tag and version reply) |
| `test_repro.py` | rebuilds FW21 and FW22 from the committed `stubs/fw21_ext.S` / `fw22_ext.S` and compares the pinned sha256; `check.py` accepts both |
| `test_fw23.py`, `test_fw26.py`, `test_fw27.py` | op 13 waveform (FW23), FW26's five redirected sites and the tail (FW26), FW27's ranges (FW27) |
| `test_literal_guard.py` | shipped FW23–FW27 leave outside loads alone; overwriting the key pool at `0x5BE60` is reported (`0x5BEA0`); FW27's `br`s into the variant-6 range are caught; FW28's restore and FW29's retarget; the FW30 image-4 pulses; (working tree) FW56's pointers |
| `test_fw53.py`, `test_fw54.py`, `test_fw55.py` | the exact bytes each of those scripts changes, and that `0x5B700`–`0x5B71F` and `0x5B74C`–`0x5B755` stay FW46's |
| `test_fw56.py`, `space_map.py` | working tree, uncommitted at the time of writing (FW56/FW57 work) |

**Side effect (V, observed 2026-10-30 08:25):** running `test_literal_guard` rebuilds FW28, FW29, FW3B, FW53–FW55 into `radio_firmware/build/` (same bytes) and writes `DMR003.FW30.V022.image4.bin` (sha256 `4a7c8008…6dc8`, the 10-27 FW30 image 4). The tests write the build directory; run them knowing that.

---

## 2. Command `0x40`, opcodes 1–18

### 2.1 Frame, dispatch and reply forms

| Item | Fact | Label | Cite |
|---|---|---|---|
| Frame | `68 cmd rw sr ck ck lenhi lenlo body… 10`; total 9 + len; body fields little-endian; `0x8E5C` writes the checksum | V | `docs/firmware-reference/02-uart-commands-and-handlers.md` |
| Slot | `0x382B8`: factory `544a0203` (empty `pop`) → `fc4e0703` = XIP `0x03074EFC` = file `0x5AEFC` | V | `toml` `c7000-cmd40-*` |
| Body offsets | `r7` = frame; len = `(r7,6)<<8 | (r7,7)`; op = `(r7,8)`; body byte k = `(r7,8+k)`; an empty body is refused | V | `sym.S:57–63` |
| **R-ack** (`0x8E7C`) | 9 bytes `68 40 00 sr ck ck 00 00 10`; every refusal is this with `sr`=1 | V | `sym.S:545–551` |
| **R11** | 11 bytes `68 40 00 sr ck ck 00 02 fillLo fillHi 10`; fill = write − read count; `sr`=1 means the ring is full | V | `sym.S:598–637` |
| **Self** | a frame the handler builds itself (at `0x4AE00`, or on the stack) and sends through `0x7DE8` | V | `sym.S:179–215` |
| Ops ≥ 8 | FW21 turns the stock `sr`=1 prologue at `0x5B308` into `bsr fw21_ops`; an op it does not handle falls back to `movi r1,1` (refusal) | V | fw21:108–156 |
| Upper bound by image | byte at `0x5B7DE`: FW21 `cmphsi r3,12` (8–11), FW22 13, FW23/FW24 14, FW25 15; FW26 `bsr fw26_gate`; FW27+ `bsr 0x5BCA4` (fw27 gate: 16/17, else FW26's gate at `0x5C464`); FW30 image 3c+ compare 19 (op 18) | V | image survey |

**Nothing in command `0x40` keys the radio** (`sym.S:28`). Every transmission is keyed by the host's `0x26`; ops only fill the ring, the engines and the flags that `on_key` reads (§3).

### 2.2 The opcodes

| Op | Body (byte 0 = op) | What it does | Reply | RAM | Refused (`sr`=1) | Introduced / changed |
|---|---|---|---|---|---|---|
| **1** | `[1, d…]`, four dibits per byte MSB first: `00`=+1, `01`=+3, `10`=−1, `11`=−3 | clears `0x4B00C`, appends to the 2048-symbol ring at `0x4A400` (symbol → level via the dibit table at `0x5B6A0`) | R11 | `0x4A3E4` write count, `0x4A3F4` last error, `0x4B00C` | free space < 4 × (len−1): R11 `sr`=1, `0x4A3F4`=1 | R4s/R4t, RG10 (`sym.S:82–151, 641–659`). FW3F `armst` (flag `0x4B378`, later `0x4BE64`); FW3J+: `0x5AF44` → `0x5BDFE` (stores `0x4B00C`=0, then `jmp 0x5AF52`). FW50/51/52: `0x5AF44` → arm at `0x5B700` (sets `0x4DAAC`=1); FW52's arm refuses while the latch `0x4D900` is set. FW56: arm at `0x5B6A0` |
| **2** | `[2]`, or `[2, 1]` (FW21+) | status; with `[2,1]` the fill field is the queued tone pairs (`0x4B030`) | Self, 15 B: fill (u16), underruns `0x4A3F0`, last error `0x4A3F4` | reads only | — | `sym.S:552–597`; FW21 fill hook `0x5B318` |
| **3** | `[3]` | reset: ring words `0x4A3E4`–`0x4A3F4` and `0x4B00C`; FW21+ also the 16 words `0x4B014`–`0x4B053` (mode, levels, P/T, tone counters; not the tap table or the queue) | R11, fill 0 | as listed | — | `sym.S:63–76`; FW21 prefix `0x5AF1E`; FW52: tail `0x5AF32` → `0x5B764` clears `0x4D900` first (not in FW53–FW56) |
| **4** | `[4, NLo, NHi]`, len 3, N = 1…240 | render N samples into `0x4AC00` (FW21+: through the sym/tone engines when the mode word is a magic) | Self, 9 + 2N B at `0x4AE00` | `0x4AC00`, `0x4AE00`, ring state | len ≠ 3, N = 0 or > 240 | R4t; `sym.S:152–217`; FW21 hook `0x5AFEA` |
| **5** | `[5, v]` (4 halves) or `[5, v, n]`, n ∈ {4, 6}; v ∈ {0, 2, 3, 4} | FM receive capture: `WORK_MODE`=`0x80` held; v2/v4 clear `FM_BANDWIDTH` bits 4, 6; v3/v4 write AT1846S `0x58`=`0xBCFD`; copy starts at the second `FM_ADDR_SW` change, with `ld.b`, slot k at `0x4A400 + 512k`; registers restored, then one frame per half | n frames of 523 B: `68 40 00 00 ck ck 02 02 [512] seq halfid 10`, halfid 0 = `0x160004E0`, 1 = `0x160006E0` | `0x4A400`–`0x4AFFF`, `0x4A3F8` | bad len/v/n; hold marker `0x484F4C44` at `0x4B008`; timeout after 2²² polls | RC20/RC30/RC40/RD10/RG10; `sym.S:218–474`; logic unchanged later |
| **6** | `[6, var, act]`, len 3 | **hold**: var 3 or 4, act 1 = apply (save WORK_MODE → `0x4B000`, v4 also BW → `0x4B004`; WORK_MODE `0x80`; v4 clears BW bits 4, 6; `0x58`=`0xBCFD`; marker `0x484F4C44` at `0x4B008`); act 0 = restore (v3: `0x58`=`0x8405` only; v4: the saved words, then `0x8405`; marker cleared) | R-ack `sr`=0 | `0x4B000`/`4`/`8` | other var/act | RD10/RE10; `sym.S:475–551`. Variants 5–7 and FW41's change in §2.3 |
| **7** | `[7, d…]` | as op 1, and sets `0x4B00C`=1 (last chunk): drain → FW20 countdown → drop (§3.3) | R11 | `0x4B00C` | full; **FW3B/FW3D and every later image: refused when byte 0 of `0x34808` is 0** (`0x5AF4C` → `0x5BD82` → `jmp 0x5AFC8`) | RG10; `sym.S:88–94`; fw3b_bisect:57–74, fw30_port:89–101 |
| **8** | `[8, shape, nlev, numLo, numHi, denLo, denHi, lvl0…]`, len 7 + 2·nlev | generic symbol clock: shape 0 hold / 1 polyphase; nlev 2 or 4; rational advance num/den per sample; levels int16 clamped ±10000; clears `0x4B014`–`0x4B053`, then mode = `0x47572101` | R-ack | mode `0x4B014`, num `0x4B018`, den `0x4B01A`, acc `0x4B01C`, shape `0x4B01E`, nlev `0x4B01F`, levels `0x4B020`–`0x4B027`, engine `0x4B03A`–`0x4B04E`, acc mirror `0x4A3EC` | bad shape/nlev/len, num or den 0 | FW21 (fw21:158–245, 434–534) |
| **9** | `[9, P, T, taps…]`, P 1–16, T odd 1–15, len 3 + 2PT | polyphase pulse table at `0x4B080` (≤ 480 B), phase = acc·P/den; used only with shape 1 | R-ack | `0x4B03C` P, `0x4B03D` T, `0x4B080`… | range, even T, len | FW21 (fw21:247–299). Op 8 and op 3 zero P/T, so op 9 must follow op 8 (I) |
| **10 / 11** | `[op, ampLo, ampHi, (fLo, fHi, dLo, dHi) × n]`, len 3 + 4n, queued + n ≤ 64 | phase-continuous tone queue: f in ⅛ Hz (< 65528), d in ms 1–10000 (d·8 samples), f = 0 silence; 256-entry sine; mode = `0x47572102`; the symbol ring is drained (read = write). Op 11 sets `0x4B036`=1, so the empty queue sets `0x4B00C` and starts the FW20 end | R-ack | amp `0x4B028`, phase `0x4B02A`, samples left `0x4B02C`, queued `0x4B030`, rd `0x4B032`, wr `0x4B034`, end `0x4B036`, step `0x4B038`, queue `0x4B260` (64 × 4 B) | len, overflow, f ≥ 65528, d = 0 or > 10000 | FW21 (fw21:301–406, 597–670); FW22: `on_key` arms a tone-only key (`0x5BBE2`, §3.2). Amplitude is not sign-extended (a negative value clamps to +10000; I) |
| **12** | `[12, off (u32), len (u16)]`, frame len 7 | flash read of the image: off + len ≤ `0x5C6FC`, len 1–240 | Self, 9 + len B | `0x4AE00` | len, range | FW22 (fw22:624–704); whole image read back equal in 971 s (res:2526) |
| **13** | FW23: any length except 2 = 3 s chirp into `0x180000A0`; FW24: `[13,1]` adds save/restore and a 24-byte read-back; FW25: `[13,2]` 1.5 s 500 Hz then 1.5 s 2 kHz square ±8192 | idle DAC playback (item 7) | plain: R-ack; `[13,1]`/`[13,2]`: Self 33 B | `0x4B054`–`0x4B078` | `[13, x ∉ {1,2}]` (FW24+) | FW23–FW25 (`fw23_build.py`, which builds FW25). **Retired in FW27**: `0x5B816` → `bsr 0x5B876` (`sr`=1), body reclaimed |
| **14** | `[14, addr (u32), len (u16)]`, frame len 7 | RAM/MMIO read with `ld.b` inside a window set by two `movih` at `0x5C0CE` (low) / `0x5C0D6` (high); mainline window `[0x18000000, 0x18010000)` (codec/vocoder RAM) | Self, 9 + len B | `0x4AE00` | outside window, len 0 or > 240 | FW25 (`fw23_build.py:1163–1245`). FW27's variant 6 broke its dispatch at `0x5B848`; FW28 repaired it. Moved windows: §4.5 table |
| **15** | `[15, v]`, len 2, v ∈ {0, 1} | promiscuous DMR receive flag `0x4B364` (0 at boot): while 1, the admit getter at `0xC1BA`/`0xC244` returns 1, the `0x2B` reply (`0xA890`) appends CC = `RX_TYPE_INFO` bits 7:4 and slot = bit 19 (body 9 → 11 B), and the `LOCAL_CC` store at `0x17E26` sets bit 8 (match any) | Self, 10 B `… 00 01 v 10` | `0x4B364` | len ≠ 2, v > 1 | FW26 (fw26:69–183); present through FW56. Off does not clear `LOCAL_CC` bit 8 until the next store (d19) |
| **16** | `[16, r]` | UART rate: r 0 = 57600, r 1 = 230400 (flag `0x4B368`=1 if the divisor took); countdown `0x4B36C`=30000 decremented by the `0x7C56` pend hook, back to 57600 at 0 | R-ack, sent at the old rate | `0x4B368`, `0x4B36C`, records `0x4B380`–`0x4B398` | r > 1 | FW27 (fw27:271–414). **`sr`=1 from FW30 image 3b onward** (and in the final FW30 = FW3K) |
| **17** | `[17, a, period?]`: a 1 start (needs marker `0x5354524D` "STRM" at `0x4B008`, period 1/2/4/8), 0 stop, 2 keep-alive | receive-RAM stream: op 5 halves as 523-byte frames (FW27 #5: 526 B with a register trailer), `WORK_MODE` re-stored every `period` halves (the capture is re-armed by each store), any other UART frame ends it | R-ack + frames | `0x4B360`, `0x4B36C`, `0x4B372`–`0x4B37C` | a ∉ {0,1,2}; start without STRM | FW27. **`sr`=1 from FW30 image 3b on**; route closed 10-26 (stream saturates above ~±1 kHz) |
| **18** | `[18, reg]`, reg < `0x80` | read one AT1846S register through IRAM `0x2B25C` | 11 B `… 00 02 lo hi 10` | — | reg ≥ `0x80` | **diagnostics only**: FW30 image 3 (in `0x35F64`, no boot), 3b (bsr into flash copy, never replied), 3c/4 (`lrw r1,0x2B25C; jsr`, works), F30B (`0x5BFB4`, 58 B), F32D file (`0x5C14C`, which overwrote the start of the tone engine), FWD1 (`0x5C490`). The final FW30 (FW3K retag), F30C, FW31–FW34, FW35 and FW36+ answer `sr`=1 (res:4155, 4556) |

### 2.3 Op 6 variants 5–7 and FW41

| Variant | Image | Behaviour | Fate |
|---|---|---|---|
| 5 | FW27 | apply: unless the marker is STRM, save WORK_MODE/BW to `0x4B000`/`0x4B004`; WORK_MODE `0x80`, BW bits 4/6 clear, `0x58`=`0xBCFD`, marker `0x5354524D`; restore at `0x5BD46` | **removed in FW38**: callers `0x5BCB2`, `0x5C55A`, `0x5C57A` → `br 0x5C584`; body `0x5BCDA`–`0x5BD73` reclaimed for the key save/restore |
| 6 | FW27 bench image `7126749f` (stage C) | needs STRM; writes bits 15:8 of `FM_DEV_COEF` `0x11000504`; replies the 4-byte word through op 14's sender | dropped in FW28; FW29 sends its arm to `0x5C584` |
| 7 | FW27 source `STAGE = "D"` only | AT1846S `0x44` = `0x0A00|act` | **not in the pinned FW27 image** (`0x5BD68` stock); built as separate test images (`ab726955…`, `f8298581…`), res:3302–3308 |
| FW41 change | FW41, FW42, FW44 → FW46 → FW54/55/56 | restore entry `0x5B250` → `hold_off` (`0x5BD2E`): v4 → `0x5B254`; any other value writes `0x4B000` into WORK_MODE, then the mode-3 tail `0x5B2A8` | in the current lineage. `[6, v ∉ {3,4}, 0]` writes `0x4B000` into WORK_MODE before it refuses (V disassembly; a side effect) |

### 2.4 Opcodes by image (who answers what)

| Images | Ops answered | Notes |
|---|---|---|
| R4m0, R4n0 | ack / echo | first working `0x40` |
| R4o0–R4r0 | sample store | host samples, not symbols |
| R4s0–RE10 | 1–6 (growing) | RC20+ op 5, RD10+ op 6 |
| RG10, FW19, FW20 | 1–7 | the `c7000-cmd40-sym` handler |
| FW21 | 1–11 | engines |
| FW22 | 1–12 | flash read |
| FW23, FW24 | 1–13 | op 13 playback |
| FW25 | 1–14 | op 14 window |
| FW26 | 1–15 | promiscuous |
| FW27 | 1–12, 14–17 (13 refused) | op 6 v5/v6; ops 8/9/14 broken by variant 6 (fixed in FW28) |
| FW28, FW29 | 1–12, 14–17 | FW29 sends variant 6 to `sr`=1 |
| FW30 image 3c/4, F30B, FWD1, F32D | 1–12, 14, 15, 18 (16/17 refused) | op 18 diagnostics |
| FW30 (final) → FW56 | 1–12, 14, 15 (13, 16, 17, 18 refused) | op 7 refused when byte 0 of `0x34808` is 0; op 6 v5 gone from FW38 |

### 2.5 Shared state words of the command

| Address | Meaning |
|---|---|
| `0x4A3E4` / `E8` / `EC` / `F0` / `F4` | ring write count / next symbol base (read) / phase (FW21: acc mirror) / underruns / last error (1 = full) |
| `0x4A3F8` | op 5 return scratch and first reply header |
| `0x4A400` | 2048-byte symbol ring; also the op 5 slots (512 B × 6, to `0x4B000`) |
| `0x4AC00` / `0x4AE00` | op 4 scratch / reply-frame buffer (ops 4, 12–15, 17) |
| `0x4B000`–`0x4B00C` | saved WORK_MODE, saved BW, hold marker (`HOLD` `0x484F4C44` or `STRM` `0x5354524D`), op 7 end flag |
| `0x4B010` | FW20 drain countdown (§3.4) |
| `0x4B014` | mode word: `0x47572101` generic symbols, `0x47572102` tones, anything else = M17 |
| `0x4B018`–`0x4B04E` | engine state (ops 8–11) |
| `0x4B054`–`0x4B078` | op 13 scratch; `0x4B070` fw21_ops' saved `r15` |
| `0x4B080` / `0x4B260` | tap table / tone queue |
| `0x4B360`–`0x4B37C` | FW27 stream and rate state; later reused: `0x4B376` drop one-shot (FW3D+), `0x4B378` FW3F flag |
| `0x4B364` | op 15 flag byte |
| `0x4B380`–`0x4B398` | FW27 divisor records (FW27 writes `0x4B398`, which fw26 calls a factory name; I) |
| `0x4B384` | F30C flag (200 at key) |
| `0x4B388`–`0x4B397` | FW30 image 4 save of AT1846S `0x30`/`0x41`/`0x58`/`0x59` (overlaps the FW27 records; harmless because op 16 is refused) |
| `0x4BE64` | FW3H/FW3J FM-setup flag (stores are nops from FW3J) |
| `0x4D900` | FW52 refusal latch; earlier F48L/F49L's `0xE9C` call log ring |
| `0x4DAAC` | TX-RAM cursor / "symbol transfer active" (FW51 also 2 = already off) |
| `0x4F2C0`–`0x4F39C` | FW3B/FW3C only: the relocated block with first-use magic `0xA5A55A5A` at `0x4F398`. The relocation also moved the ring base `0x4A400` → `0x4F2DC`, the tap table `0x4B080` → `0x4F368` and the queue `0x4B260` → `0x4F36C`, i.e. large buffers packed over a 0xDC-byte block (I: a likely reason FW3A/FW3B went silent after boot) |

---

### 2.6 SignalDeck's data hold on DMR channels (PR 143, 2026-10-30)

**Fault.** While M17 or page receive ran (`dataReceive` on), SignalDeck sent op 6 `[6, 3, 1]` after every channel, VFO and tone write and after each unkey, with no digital-channel check. On a bench image the hold stores WORK_MODE `0x80` (and `0x58` = `0xBCFD`). On a DMR channel that took the sync, or the whole carrier, off the next key until a key/unkey rewrote the mode. This was the "first group slot 0 key after a channel write" fault of FW54/FW55/FW57. Evidence:
- F55A vs F55B: the fault needs an executed `0x40` frame.
- `results.md` "Data-hold test (10:02)", commit `74f3d0b1`: data receive on → hold sent → no carrier; off → 17 sync bursts.

**Fix (SignalDeck PR 143, main `29128e9b`, host-side only):**
- `sendDataHold` never applies the hold on a DMR channel (`holdAllowed`).
- Selecting a DMR channel while data receive is on calls `endDataHoldForDigital()` **before** `engine.setDigital`. It stops M17 and page receive, cancels pending re-sends, and sends the release `[6, 3, 0]`.
- The release writes `0x58` = `0x8405` (and on FW44+ restores WORK_MODE), so it must precede the DMR write, never follow it.

**Stock firmware (`DMR003.UV4T.V022`) is unaffected at the radio.** `sendDataHold` has always returned before sending on a non-stub tag ("stock firmware, not sent"), and the release goes through the same path, so no new frame reaches a stock module and DMR writes are unchanged. The only visible change on stock: **selecting a DMR channel now stops M17 receive.** Before PR 143 it kept running there and decoded nothing; now the user starts it again on an analog channel. Reviewed and judged harmless (firmware agent, 2026-10-30).

**Release decision (owner, 2026-10-30):** FW57 is released together with SignalDeck beta.22, the first beta carrying PR 143. beta.21 and earlier lack the fix, so FW57 is not offered without beta.22. The FW58 guard is not needed for now.

**Released 2026-10-30:** FW57 is published in AndroidRadio_Firmware_Project (catalogue serial 6, firmware key, `released-min` 121). SignalDeck 1.0.0-beta.22 (`62b6ad86…e62a`) is published and offers it. The end-to-end check from the factory image through the app's own page passed, plus Morse on FW57 (`results.md` 13:37, 13:45). Before publishing, it found and fixed three SignalDeck faults:
- the pre-flight refused catalogue images (PR 149);
- the page never downloaded them (PR 150);
- a double op 6 apply saved WORK_MODE `0x80`, so the release silenced DMR (PR 151, hold tracking; FW58 backstop queued).

**Firmware backstop, optional (not built):** op 6 could refuse while byte 0 of `0x34808` is 0 (digital), in proven-dead bytes only.

## 3. The key path we built

### 3.1 The stock path and our four sites

The host's `0x26` (PTT) handler reaches the stock transmit launcher `tx_launch` at **`0xE9C`** from four `bsr` sites (**V**, `toml`, factory disassembly):

| Site | Factory | Branch of the handler |
|---|---|---|
| `0x92C8` | `bsr 0xE9C` | body 1 (key), byte `0x38874` == 0 |
| `0x92E0` | `bsr 0xE9C` | body 1 (key), byte `0x38874` != 0 |
| `0x92AA` | `bsr 0xE9C` | body 2 (unkey), `r7` == 0 |
| `0x92FA` | `bsr 0xE9C` | body 2 (unkey), `r7` != 0 |

`0xE9C` stores its second argument at `0x38875` when `0xE64` says not busy (fw49, fw42 headers); `r1`=1 keys, `r1`=0 is the stock unkey that "does not return" in our use (fw53/fw54 headers; I for the mechanism). Since R3a3 our images send body 1 to `on_key` and body 2 to `on_unkey`; since RG10/FW19 those are at `0x5B580` and `0x5B614`.

### 3.2 `on_key` (`0x5B580`) and `on_unkey` (`0x5B614`) as in FW54

Disassembly of FW54 (**V, C**):

```
0x5B580 on_key:   push r4-r7,r15
0x5B582           bsr  0xE9C                ; stock key first (r0/r1 from the handler)
0x5B586           lrw  r2,0x4A3E4 ; ld r3,(r2,0) ; ld r1,(r2,4) ; cmphs r1,r3   (result unused since FW3E)
0x5B58E           bsr  0x5BDEC              ; FW3E/FW3K gate: byte 0 of 0x34808 == 0 -> pop r4-r7,r15 (plain key ends here)
                                            ;   else bsr 0x5BBE2 (FW22 "anything to play?")
0x5B592           bsr  0x5BCDC              ; FW38 save: RF_MODE->0x32520, WORK_MODE->0x32680 (unless hold marker), FM_BANDWIDTH->0x32684
0x5B596..         RF_MODE 0x11000104 = 0x10E0 ; WORK_MODE 0x11000100 = 0x80 ; 0x11000080 bit0 set ;
                  FM_BANDWIDTH 0x11000500 bits 4,6 clear ; emit_n(0x16000030, 512) ;
                  AT1846S 0x30=0x4006, 0x30=0x4026, 0x58=0xBCFD ; PTT 0x11000560=1 ;
                  0x4DAAC=1 ; mask 0x1100039C bit15 set ; pop
0x5B614 on_unkey: push r4-r7,r15
0x5B616           bsr  0x5BE14              ; FW3F's clrunkey; FW3K nopped its clear store, so it only returns r2 = [0x4DAAC]
0x5B61A           cmpnei r2,0 ; bt 0x5B624
0x5B61E           bsr  0xE9C ; pop          ; flag 0: the stock unkey, once
0x5B624 host_unkey: 0x4DAAC=0 ; mask bit15 clear ; bsr 0xE9C ; PTT=0 ; 0x11000080 bit0 clear ;
                  AT1846S 0x58=0x8405 ; 0x30=0x7026 ; pop
```

`0x5BBE2` (FW22, `res:2512`): returns into the arm (`jmp r15`) when the ring has symbols (`[0x4A3E4] > [0x4A3E8]`), or when the mode word `0x4B014` is the tone magic `0x47572102` and the queue count (halfword `0x4B030`) or the samples still to play (word `0x4B02C`) is non-zero; otherwise it pops and the key stays the stock carrier. **This is the "a tone queue is waiting" test** asked for in rev:2853 item 4 (**V**, FW54 bytes `0x5BBE2`–`0x5BC08`, and `map` working tree).

**Caveat (I):** in FW54 `0x5BBE2` is reached through `0x5BDEC`, which pushed `r15` once; the "nothing to play" exit of `0x5BBE2` is `pop r4-r7,r15` (a C-SKY `pop` also returns), which assumes `on_key`'s frame is on top (true in FW22, where `0x5B58E` called `0x5BBE2` directly). On a channel where byte 0 of `0x34808` is non-zero and nothing is queued, that exit would unbalance the stack. Plain FM keys pass on FW54 (rev:2754), so either that byte is 0 on the bench FM channel or this reading is wrong; open (§8). One agent's reading of HANDOFF says non-zero = analog; this chapter did not confirm it.

**"pre_key" naming:** in the scripts `0x5B580` is `on_key`; `pre_key`/`pre_unkey`/`pre_refill` are FW3A–FW3C's preludes at `0x5BFB2`–`0x5BFF2` (`fw30_port.py`), which call a RAM clear and then `0x5B580`/`0x5B614`/`0x5B4D0`.

**The accepted FW30 is not built by `fw30_build.py`.** That script writes `DMR003.FW30.V022.image4.bin` (the 10-27 image 4). The `FW30.V022.bin` that FW35, FW36 and F30B start from is `fw3b_bisect.build_fw30_retag()`: FW3K with the tag changed (C: identical except byte `0x3846E`). So image 4's WORK_MODE hole at `0x5B718`, its restore at `0x5BE00` and its `0x5B762` mask are in no later image.

### 3.3 The symbol end: wake → FW20 drain → drop

| Step | Address | What (**V**, FW54 bytes + `gate.S`) |
|---|---|---|
| wake | `0x18B68` → `0x5B4D0` (`on_wake_skip`; `0x18B5C` is **stock** since F19B/F19D/F30F found it broke DMR receive, `res:3916–3940`) | each TX-RAM half interrupt while `0x4DAAC` != 0, mask bit 15 set and `0x11000080` bit 0 set: render 256 samples into the half `FM_ADDR_SW` names |
| drain | `0x5B53A` → `0x5B720` (FW20 gate) | when op 7 armed `0x4B00C` and the ring drained: countdown `0x4B010` set to 8, decremented per half; at 0 clear `0x4DAAC`, `0x4B00C`, `0x4B010`, read `0x38874` into `r7` |
| drop | `0x5B748` → `0x5BD98` | sets the one-shot marker `0x4B376`=1/`0x4B377`=`0xA5`, then `lrw r4,0x0307565A; jsr r4` = **`drop_ptt` at `0x5B65A`**: PTT 0, `0x11000080` bit 0 clear, `0x58`=`0x8405`, `0x30`=`0x7026`, mask bit 15 clear, status 4 through `0x7E08` |
| close guard | `0x37F8` → `0x5BDAA` | the stock call at `0x37F8` returns through our stub: if the marker is `1/0xA5` and `r0`==1, clear the marker and return `r0`=0; jumps back to XIP `0x0301D7FC` (F30F/FW3D, `res:3942`) |
| engine-end unkey | `0x5B74C`–`0x5B75B` | `r0` = (`r7`!=0), `r1`=1, then **FW20–FW44: `bsr 0xE9C`**; FW45: two nops; FW46: `movi r1,0; bsr 0xE9C`; **FW54/FW55: `movi r1,1` + two nops** (no engine-end `0xE9C`); FW53: never reached (`0x5B748` → `br 0x5B77A`) |
| state clear | `0x5B75C`–`0x5B76F` | `0x38908` &= `0xFA` (bits 0, 2), `0x38C64+2..4` = 0 |
| restore | `0x5B770` | FW20–FW34: last store + pop; FW35: `br 0x5BD74`; FW36: `br 0x5B700` (bit-7 clear); FW37: `br 0x5B70C` (RF_MODE restore); FW38: `br 0x5BCFA`; **FW41/FW44 lineage (FW45–FW55): `br 0x5BD06`**; FW51–FW53 never reach it (`0x5B748` → `br 0x5B77A`), FW52 overwrote it with a pool word (restore RF_MODE from `0x32520`, WORK_MODE from `0x32680` unless the hold marker `0x484F4C44` is at `0x4B008`, FM_BANDWIDTH from `0x32684`; pop) |

So in FW54 a module-ended symbol key drops PTT and posts status 4 itself, never calls `0xE9C`, and the host's body 2 then reaches `on_unkey` with `0x4DAAC` already 0, i.e. the single stock unkey. A host body 2 **before** the drain takes `host_unkey` (flag still 1).

### 3.4 State words of the key path

| Address | Meaning | Written by | Read by |
|---|---|---|---|
| `0x4DAAC` | "symbol transfer active" / wake cursor (R4d era: cursor). 0 at boot (`.bss` `0x31AF4`–`0x4DAB0`) | `on_key` (1), `host_unkey` (0), FW20 drain (0); FW50–52/56: op 1 arm (1); FW51: 2 = "already off" | wake, `on_unkey` via `0x5BE14`, FW50–52 gate |
| `0x4B00C` | op 7 "last" flag | ops 1/3/7, drain, FW52 early unkey | wake/drain |
| `0x4B010` | FW20 drain countdown (8 halves; >8 = idle) | `gate.S` | `gate.S` |
| `0x4B376`/`0x4B377` | drop one-shot marker (`1`, `0xA5`) for the close guard | `0x5BD98` | `0x5BDAA` |
| `0x32520` | saved `RF_MODE` | FW37 `0x5B700` (dead since FW38), FW38+ `0x5BCDC` | `0x5BD06` |
| `0x32680` / `0x32684` | saved `WORK_MODE` / `FM_BANDWIDTH` (FW38+; WORK_MODE skipped while the op 6 hold marker is set, FW41/FW44) | `0x5BCDC` | `0x5BD06` |
| `0x4B000`/`0x4B004`/`0x4B008` | op 6 hold: saved WORK_MODE, saved bandwidth, marker `0x484F4C44` | op 6 | op 5 (refuses while held), key save/restore |
| `0x4D900` | FW52 refusal latch: set by the early host unkey, cleared by op 3 (the FW48L/F49L call log ring lived here first) | FW52 | FW52 op 1/7 |
| `0x38874`/`0x38875` | stock key-state bytes (handler flag; `0xE9C`'s stored `r1`) | stock | stock, our drain |
| `0x38908` | stock TX state (bits 0, 2 cleared by our end) | stock, drain | stock `0xE64` busy test |
| `0x34808` byte 0 | stock channel-mode struct; FW3K gate (non-zero → consider the TX-RAM path) | stock | `0x5BDEC` |

### 3.5 FW38–FW44: WORK_MODE / RF_MODE / FM_BANDWIDTH

| Image | Change (fw headers, **V**) |
|---|---|
| FW36 | `0xAB18` back to stock (the FW19 120 s clamp is gone; a `0x3B` byte of 0 is stored unchanged); a 26-byte bit-7 clear of AT1846S `0x30` in `0x5B700`–`0x5B719`, hooked by a 4-byte `br` at `0x5B770` |
| FW37 | drops the bit-7 clear; `0x5B700` saves `RF_MODE` to SRAM `0x32520` (called from `on_key` `0x5B592`), `0x5B70C` restores it (from the `0x5B770` hook) |
| FW38 | reclaims the bench-only op 6 variant 5 body `0x5BCDA`–`0x5BD73` (154 B): save at `0x5BCDC`, restore at `0x5BCFA` (moved to `0x5BD06` by the FW41/FW44 layout) for `RF_MODE`, `WORK_MODE`, `FM_BANDWIDTH`; the three outside callers of variant 5 (`0x5BCB2`, `0x5C55A`, `0x5C57A`) become `br 0x5C584` (unsupported reply); `0x5B592`/`0x5B770` retargeted, **so `0x5B700`–`0x5B71F` becomes uncalled** ("The old 32-byte RF_MODE slot at 0x5B700 stays in place and becomes uncalled", fw38 header) |
| FW39 | (side branch) clears ring/mode/`0x38908` bits early via a trampoline in `0x5B700` |
| FW40 | (side branch from FW37, re-applies FW38) stock TX-stop pair A=1/B=200 at `0x38908+0xA/+0xB` in the restore |
| FW41 | FW40 + WORK_MODE ownership: while the hold marker is set, the key neither saves nor restores WORK_MODE; op 6 mode 3 hold-off restores `0x4B000` (patch at `0x5B250`) |
| FW42 / FW43 | (side branches) helpers in the dead `0x5B700` slot: `0x31B04`=1/`0x38875`=0 (FW42); `0xE9C(0,0)` (FW43) |
| FW44 | FW41 without FW40's A/B stores (from FW37 + FW38 + FW41 bytes; **C**: FW37→FW41 and FW37→FW44 change the same spans) |

### 3.6 `0x5B700`–`0x5B71F`: who owned it

| Image(s) | Contents (**V**, bytes) |
|---|---|
| factory | zeros |
| FW19–FW35 | `c7000_tot120.S` (24 B) + zeros |
| FW32 / F32M | the moved drop stub (F32M, FW32 `53e1fd7b`) |
| FW36 | bit-7 clear of `0x30` (26 B) |
| FW37 | `RF_MODE` save (`0x5B700`) / restore (`0x5B70C`) + pool `0x5B718`=`0x11000104`, `0x5B71C`=`0x32520` |
| **FW38, FW41, FW44–FW46, FW53–FW55** | the FW37 bytes, **uncalled**: no `bsr`/`br` target, no `lrw` pool use from outside, no XIP word `0x03075700`–`0x0307571E` anywhere in FW54 (**C**) |
| FW39, FW42, FW43, FW47, FW48 | side-branch helpers |
| FW50, FW51 | the op 1 arm: set `0x4DAAC`=1, `br 0x5BDFE` (entered from `0x5AF44`, retargeted) |
| FW52 | the arm with the `0x4D900` refusal test |

**The label "tone-queue pitch helper" (fw53/54/55 headers, `map`, rev:2816) is not supported by the bytes.** `res:4855` itself describes the FW46 bytes as "copies `0x11000104` to `0x32520` and returns 135 in `r3`", which is FW37's `RF_MODE` save. The FT8-at-7.5 kHz symptom started at FW50, but FW50 also rewrote `drop_ptt` (§1.5) and retargeted op 1; the causal link to `0x5B700` is a correlation (**I**). Treat the range as dead-by-static-analysis but unproven on the bench (§8).

### 3.7 FW45–FW55: the engine-end unkey and the gate

| Image | Base (SRC) | Bytes (**C**, diff vs base) | Intent (fw header) | Bench (V-bench) |
|---|---|---|---|---|
| FW45 | FW44 | `0x5B758`–`0x5B75B` → nops | stop the second `0xE9C(1)` (semaphore `0x390D4` leak) | leak fixed; `0x38875`=1; tones fail; FT8 1512 Hz, released (res:4848) |
| FW46 | FW45 | `0x5B756`–`0x5B75B` = `movi r1,0; bsr 0xE9C` | stock unkey at engine end | FT8 1512 Hz, **PTT held** (res:4849) |
| FW47/FW48 | FW46 | `0x5B700`–`0x5B713`, `0x5B758` | store 0 to `0x38875` / 1 to `0x38C0A` | held / fail |
| FW49 | FW46 | `0x5B61E`, **`0x5B65A`–`0x5B661`** | `r1`=0 into the launch-2 `0xE9C` | unkey does not return; PTT held; **it wrote `drop_ptt`'s prologue** |
| FW50 | FW46 | four sites → **`0x5B65C`** (body 1) / **`0x5B660`** (body 2); gate `0x5B65C`–`0x5B681`; arm `0x5B700`–`0x5B717`; `0x5AF44` → arm; `0x5B756` `movi r1,1` | stock `0xE9C` unless `0x4DAAC` is set | plain FM/DMR pass; symbol end no status 4; FT8 7500 Hz held (rev:2615, res:4852) |
| FW51 | FW46 (script); docs say FW50 + | gate `0x5B664`–`0x5B68F`; `0x5B748` → `br 0x5B77A`; op 14 window `[0x30000, 0x50000)` | one stock unkey per symbol key | first image where every normal path works; early unkey leaves flag 1 (rev:2642) |
| FW52 | FW46 (script) | + `0x5AF34`, `0x5B632` → `br 0x5B750`; `0x5B700` arm with `0x4D900` test; `0x5B74C`–`0x5B773` early-unkey block (`bsr 0xE9C`, clear `0x4B00C/0x4B010`, latch `0x4D900`=1, `br 0x5B636`) and op 3 latch clear (`br 0x5B370`) | early host unkey clears and refuses | acceptance: FT8 7.4 kHz held, RTTY steady tone, group slot 0 no carrier (rev:2706) |
| FW53 | **FW46** | `0x5B748` → `br 0x5B77A`; `0x5B756` `movi r1,1` | skip the hanging `0xE9C(r1=0)` | FT8 carrier died at 8.75 s, PTT held (res:4831) |
| FW54 | **FW46** | `0x5B756`–`0x5B75B` = `movi r1,1` + two nops (FW45's bytes) | engine end without `0xE9C`, drop and restore kept | FT8/RTTY decode and release; CTCSS test tone and SSTV radiate nothing; first group slot 0 key no sync (rev:2754) |
| FW55 | **FW54** | the four sites back to factory `bsr 0xE9C` | phone-audio keys on the stock path | tones/CTCSS/SSTV radiate; **cannot key M17, POCSAG or the tone queue** (body 1 never reaches `on_key`), so a diagnostic, not a candidate (rev:2792) |
| FW56 | FW54 | FW50 gate at `0x5B65C`–`0x5B681` (38 B), arm `0x5B6A0`–`0x5B6B7` (24 B), `0x5AF46` | gate in "mapped free" bytes | **rejected, not loaded**: both ranges are live (drop body, dibit table + RRC taps), rev:2853 |

**The FW50 gate itself (V, FW50 bytes `0x5B65C`–`0x5B681`):** body 1 enters at `0x5B65C` (`movi r3,1`), body 2 at `0x5B660` (`movi r3,0`); `push r15`; if `[0x4DAAC]`==0 → `bsr 0xE9C; pop` (factory behaviour); else body 2 → `bsr 0x5B614`, body 1 → `bsr 0x5B580`. It tests only `0x4DAAC`, which only op 1's arm sets, so a tone-queue-only key (ops 8–11) takes the stock path (rev:2853 item 4; **I** from the bytes).

---

## 4. Every image

Sources: the two image tables compiled for this chapter from `res`, `rev`, `HO`, `d18`, `d19` and the build scripts, plus **C** for sha256 of every file present in `radio_firmware/build/`. Results are one line; the cited line has the numbers. "file" in the sha column means the hash of the build file (no document records the full value). Dates 2026; low power, 467.625 MHz, HackRF receive, unless noted.

### 4.1 FW0–FW18 are backlog rows, not images

| Row | What it was | State | Cite |
|---|---|---|---|
| FW0 | C-SKY V2 identified, link base 0 | done | d18 §9 |
| FW1 | protocol anchors (`0x7D94` checksum, `0x7DE8` send, `0xAA3C` dispatcher) | partly | d18 §9 |
| FW2 | `0x24`/`0x25` readback, squelch sweep | partly | d18 §9 |
| FW3 | CTCSS table at `0x366B2` as the first RAM-load proof | planned, never built (I) | d18 §9 |
| FW4–FW7 | band check location, group-call RX, `PATCH14.bin` removed, permanent-flash research | — | d18 §9 |
| FW8–FW13 | symbols, dispatcher names, `0x21` family, RF IC, boot path, SignalDeck loader | various | d19 §8 |
| FW14 | version-string round trip: **image UVm1**, proved loads persist | done 10-23 | d19 §14 |
| FW15, FW16 | persistence answered; `tools/fw-patch` build/check | done | d19 §8 |
| FW17 | factory TX baseline (probe 1 kHz 115 Hz, 3.5 kHz +6.8 dB, M17 0/90) | done | res:1–70 |
| FW18 | digital-audio mode: the UVm images, then the R series; M17 met via R4t | ◐ | d19 §8 |

### 4.2 UVm series (10-23; each confirmed with `0x34`, then factory restored)

| Tag | Patches | Result | sha256 | Cite |
|---|---|---|---|---|
| UVm1 | tag only | load persists (FW14) | `f2390a04…5c` | d19 §14 |
| UVm2 | `fm-flat-58` | pre-emphasis gone, < 250 Hz still absent, M17 0/90 | `2833576d…` (file) | res:72 |
| UVm3 | `c7000-fm-flat` | same curve as factory | `85b434e8…` (file) | res:106 |
| UVm4 | both | as UVm2 | `a06a81a0…` (file) | res:140 |
| UVm5 | `fm-flat-58dd` + `ctcss-hpf-keep` | 50–200 Hz still closed | `a45a9b85…` (file) | res:218 |
| UVm6 | `fm-flat-58fd` + keep | flat 300 Hz–3.5 kHz ±2 dB; low end closed | `9e7ae91d…` (file) | res:256 |
| UVm7 | `c7000-fm-canary` | null (1829 vs 1827 Hz) | `73a500db…` (file) | res:294 |
| UVm8 | `c7000-fm-proof` | proves the stub runs | `0f99aace…69d1` | res:327 |
| UVm9 | `fm-flat-58bcfd` + keep | low end −40.9 dB; `0x58` exhausted | `185207d3…ba87` | res:339 |
| Vm10 | `c7000-fm-adcgain` | null (0.95 of factory) | `17fe8d7f…5059` | res:380 |
| Vm11 | `c7000-fm-dacgain` | null; RX +0.06 dB | `dbbf43d3…2f6d` | res:437 |

### 4.3 R series (10-23 → 10-24)

| Tag | Change | Result | sha256 | Cite |
|---|---|---|---|---|
| R3a0 ("R3") | IRAM key-up hook (file-offset encoded) + square stub | **no boot** (wrong branch encoding) | `14390583…ef4a` | res:608 |
| R300 | `TICK` immediate `0x3ACEB` | no banner | `dfe1cf30…7e58` | res:653 |
| R301 | `c7000-iram-padbyte` | banner + tag | `5c4ef962…3356` | res:661 |
| R3a1 | hook from IRAM PC | built, not loaded (would key at boot) | `7404d19b…c690` | res:667 |
| R3a2 | `c7000-txram-square` gated on `0x4DAAC` | boots silent; key = codec tone | `74a47c45…8f64` | res:701 |
| R3a3–R3a7 | `c7000-txram-dmr`(-aN): the four sites → `on_key`/`on_unkey` | **TX-RAM square on the air**, ±256…±4096 → p99 up to 3700 Hz | `667cfd12…`, `244cd6b2…`, `07a76c84…`, `57e712c0…`, `50f8e789…` | res:733–975 |
| R3a8, R3a9, R3b0 | sine1k at 2048/4096/5120 | 923 / 1923 / 2261 Hz lines | `8436ac95…`, `ebe8144f…`, `0861b82a…` | res:975–1100 |
| R4a0 | RRC pattern table `0x5C000` | shape on air, inverted | `9271b363…a653` | res:1101 |
| R4b0 | M17 LSF loop | LSF 43/43 | `a115ac08…492d` | res:1446 |
| R4c0 | poll refill | fail, unmodulated | `e36364b6…30f4` | res:1504 |
| R4d0 | **wake refill** (`0x18B5C`/`0x18B68`, cursor `0x4DAAC`) | one stream, Golay 0 | `c1e22770…3571` | res:1532 |
| R4e0–R4h0 | loop variants | 53–54 frames Golay 0 | `956f8d6d…`, `4d187ca3…`, `763ca173…`, `df8ff37d…` | res:1564–1680 |
| R4i0 | EOT, unkey waits | fail | `0680c84e…3fa2` | res:1684 |
| R4j0 | unkey returns, wake drops | EOT decoded | `c495f625…2ae3` | res:1710 |
| R4k0 | drop posts status 4 | `SEND_STOP` | `c71ee7d8…2745` | res:1740 |
| R4l0 | `0x40` thunk in `0x35F64` | **no boot answer; do not reload** | `83fb3927…4565` | res:1762 |
| R4m0 | `0x40` thunk at `0x5AEFC` | ack 6 ms | `673884b2…92a8` | res:1772 |
| R4n0 | `0x40` echo | pass | `2faa7563…bbc7` | res:1792 |
| R4o0–R4r0 | host samples, M17 pieces, TX-RAM byte order | R4r0: LSF CRC + frames Golay 0 | `2b37af7a…`, `70a4ce04…`, `26730d4b…`, `8ce6cd45…` | res:1812–1915 |
| R4s0 | symbol ring + RRC in the wake | fail (taps zero-extended) | `2c8866bc…d70f` | res:1916 |
| R4t0 | `ld.hs` taps, op 4 render | **50/50 and 3×90/90 Golay 0** | `c571018f…e1b9` | res:1952 |
| RC20/RC30/RC40 | op 5 receive halves | RC40: 100 Hz +0.3 dB in the RAM | `ad941d8a…`, `6b0d873b…`, `f129a0c3…` | res:1986–2087 |
| RD10 | op 6 hold variants 3/4 | `0xBCFD` flattens the phone path | `6550e552…0527` | res:2088 |
| RE10 | op 6 saves to `0x4B000..8`, marker | fixes pass | `53bf713c…091c` | res:2128 |
| RG10 | op 7 end flag + `drop_ptt`, op 4 reply at `0x4AE00` = **`c7000-cmd40-sym`** | 90 frames payload-exact | `4550a6eb…6784` | res:2277 |

### 4.4 FW19–FW29

| Tag | SRC | Change | Why | Result | sha256 | Cite |
|---|---|---|---|---|---|---|
| FW19 | factory + `cmd40-sym` + `tot-120` | `0xAB18` → `0x5B700` ceiling | 120 s time-out | pass: module ends a key at 120.3 s, status 4 | `555b0128f62116a28496c8e8e3ef8d4277b4fa81d6420a23b4d033102070e52a` | res:2335 |
| F19R, F19T, FR22 ("F19R2"), F19M, F19S, F19A, F19B, F19C, F1B2, F19D | FW19 / factory (10-28 DMR-receive bisect) | single sites restored or added | find why DMR receive died on FW19+ | **F19B (`0x18B5C` hook) = deaf**; F19D (FW19 with `0x18B5C` stock) hears | file: F19A `b134fc73…`, F19B `f3a3ac1c…`, F19C `48bdb5c8…`, F19D `82a2f8d6…`, F19M `01cf250e…`, F19R `4290cafa…`, F19S `4fa6b3eb…`, F19T `599e3d5d…`, F1B2 `7df6e32f…`, "F19R2" file `ffb2a589…` (text: `66611624…`) | res:3859–3940 |
| FW20 | `cmd40`+`fw20-drop`+`tot-120` | handler drain + `0x5B720` gate | op 7 end cut, stale timer | 1125/1125 + EOT, receiver back | `31ecdd307e1ce33bee588b3abe41ed60793e38d8416da3395a9b305308d28796` | res:2426 |
| FW21 | factory + FW20's two patches (script) | ops 8–11 at `0x5B794`–`0x5BEB6`; hooks `0x5AF1E`, `0x5AFEA`, `0x5B4BA`, `0x5B308`, `0x5B318` | generic engines | POCSAG/MCW/RTTY/FT8 decoded; 1125/1125 | `f726056a…77ed` | res:2464 |
| FW22 | FW21 | tone-queue key test `0x5BBE2`; op 12 | tone-only keys; flash read | 378,620 B read back equal | `38f900a0…8d6a` | res:2510 |
| FW23 | FW22 | op 13 | idle DAC playback | not heard (decision c) | `d880d6e5…132a` | res:2692 |
| FW24 | FW23 | op 13 speaker-gate variant | — | fail | `0afc3d80…b2fc` | res:2709 |
| FW25 | FW24 | op 13 two-tone; op 14 RAM read; extension to `0x5C464` | — | fail (not heard) | `f0759b7d…116a` | res:2767 |
| FW26 | FW25 | op 15, `0x2B` 11 bytes; sites `0xA890`, `0xC1BA`, `0xC244`, `0x17E26`, `0x5B7DE`; stubs `0x5C464`–`0x5C54B` | promiscuous DMR receive | host checks pass; A/B later | `71949d24…a34e` | res:2914 |
| FW27 (series) | FW26 | ops 16/17 + op 6 v5–v7; reclaim `0x5BCA4`–`0x5C098`; `0x7C56` pend hook; tail `0x5C54C`–`0x5C6FB` | receive-RAM stream | first build overwrote the key pool `0x5BE60` → `0x26` dead; split image keys; stream saturates above ~±1 kHz; route closed | first `400c7cc8…`, pool-overwrite `9ea5365c…`, split `152358b0…`, bench `7126749f5c3bc077b04935901af7f62dc550d6e94761df369e56daef2689b779` | res:3268–3676 |
| FW28 | FW27 | `0x5B81C`–`0x5B86F` back to FW26 | ops 8/9 broken by FW27 | pass, not accepted | `518345e8…abe3` | res:3059 |
| FW29 | FW28 | `0x5B2BE`, `0x5BCB0`, `0x5C564` → `br 0x5C584` | stale callers | accepted; later found DMR-deaf like FW19+ | `de10d5c5…657b` | res:3043 |

### 4.5 FW30–FW49 and their diagnostics

| Tag | SRC | Change | Result | sha256 | Cite |
|---|---|---|---|---|---|
| FW30 images 1–6 (10-27, all tag FW30) | FW26/FW29 | drop writes `0x30` pair; WORK_MODE `0x6E`; op 18 tries (image 3 in `0x35F64`: **no boot**); register save/restore | all fail to unmute receive after a symbol key; image 3c is the op 18 diagnostic that found bit 7 of `0x30` | img1 `f53c5a2d…`, img2 `e1433e99…`, img3 `590b4efa…`, 3b `fc8eb51b…`, 3c `6ff663cf…`, img4 `44572ba2…`, img5 `56eb76b1…`, img6 `4a7c8008…` | res:3735–3851 |
| F30A, F30B (am), F30C (am), F30E, F30F | FW19 lineage | RAM moved to `0x4F2C0`, op 7 reject, close guard `0x37F8` | F30F: DMR both ways pass | F30F `a76b44c0…`; F30E file `dfcd28c0…` (no result recorded) | res:3940–3952 |
| FW30 port | FW29 | F30F fixes ported (`fw30_port.py`) | no boot | `58ece263…` | res:3962 |
| FW3A–FW3K, B3G1–B3G6, E3G1–E3G3 | FW29 → FW3x (`fw3b_bisect.py`) | boot/transmit bisect | **FW3K**: gate on byte `0x34808`, no stub RAM, DMR both ways pass | FW3K `e8b2c89f…7494` (others in §4.8) | res:3992–4151 |
| **FW30 (final)** | FW3K | tag only | receive still silent after a symbol key; runner `all` pass | `aaccf03d47eaf90341b150c046735a67c99af0957bbf1a39d21959bdb1fe0005` | res:4155 |
| F30B (pm) | FW30 | op 18 (58 B) at `0x5BFB4` | diagnostic: `0x30`=`70A6` | `487fe953…cf54` | res:4165 |
| F30C (pm) | F30B | unkey stub, bit-7 check | fail (several variants) | kept `f4beb348…5ee9` | res:4181–4211 |
| FW31 | F30C | tag only (hold-only); fix `FW31.bit2` | heard list empty; fix: one status 4 | `2935910f…3d9e`; fix `997cb714…ac30` | res:4213–4261 |
| FWD1, F31G | FW31 | register read / one-shot | diagnostic / fail | `d7efd88a…`, `91f2a645…` | res:4252–4269 |
| FW32 (5 builds) | FW31 | drop stub, bit-7 clear | `53e1fd7b`: runner pass, M17 then FM fail | `53e1fd7b…1d11` (file F32D `3d7fca89…` is the op 18 diagnostic) | res:4275–4402 |
| FW33 / FW34 | FW32 | `0x5BDEC` empty-ring skip / gate on `0x4B008` | FM holds on FW34; M17 at the floor | `029fedbe…`, `7b64a823…` | res:4414–4476 |
| FW35 | FW30 | bit-7 clear after the stock unkey at `0x5BD74`–`0x5BDB3` | **op 3 no reply**: the stub covered the refuse stub, the op 7 helper `0x5BD82`, the drop helper `0x5BD98` and the start of the close guard `0x5BDAA`, whose unchanged 32-bit `bsr` callers the branch guard exempts | `a66f3655…0764` | res:4515 |
| FW36 | FW30 | §3.5 | PA holds; M17 receive after a key fails | `dab18acd…18fa` | res:4539 |
| FW37 | FW36 | §3.5 | M17 receive after a key passes | `8a5d16dc…ab0ca` | res:4588 |
| FW38 | FW37 | §3.5 | core proof passes; FM after a symbol key keyed 0 | `b4cafbf4…f334` | res:4598 |
| FW39 | FW38 | early clears | tone `0x26` not acked | `8e8ee5a8…f457` (loaded) | res:4629 |
| FW40 | FW37 (+FW38 bytes) | A=1/B=200 | fail | `c5a97024…34d9` | res:4672 |
| FW41 | FW37 (+FW38+FW40) | WORK_MODE ownership | fail | `26982874…9a3c` | res:4763 |
| FW42 / FW43 | FW41 | `0x5B700` helpers | via F42E / F43D: fail | `43f1a50f…`, `87bc80d1…` | res:4769–4779 |
| FW44 | FW37 (+FW38+FW41) | drop A/B | via diagnostics | `0d41961a…464d` | res:4896 |
| FW45 | FW44 | §3.7 | §3.7 | `b7bbe9a7…fd84` | res:4892 |
| FW46 | FW45 | §3.7 | §3.7 | `86d6b4c4c84210dce7ff2582166ecb9be05d5042021447a513c699520660f8ab` | res:4892, 4849 |
| FW47 / FW48 / FW49 | FW46 | §3.7 | §3.7 | `58a319f8…`, `c44ab167…`, `3bf9d231…` | res:4850–4890 |

Diagnostic images that only widen the **op 14 window** (the two `movih` immediates at `0x5C0CE`/`0x5C0D6`; mainline window `[0x18000000, 0x18010000)`), **C**:

| Image | Window | SRC |
|---|---|---|
| FW4D (FW41-D) | `[0x30000, 0x40000)` | FW40 |
| FW4E (FW41-D2) | `[0x30000, 0x40000)` + breadcrumbs `0x9270`/`0x9288`/`0xE9E` | FW4D |
| FW4F (FW41-D3) | `[0x11000000, 0x11010000)` | FW4E |
| F42D, F42E, F44D, F45F, F45G, F46G, F47G, F48G, F48L, F49L | `[0x30000, 0x50000)` | FW41/42/44/45/46/47/48/46/46 |
| F43D | `[0x30000, 0x11020000)` | FW43 |
| F45D | `[0xFCFF0000, 0xFD020000)` (mis-based) | FW44 |
| F45E | `[0x10000, 0x30000)` | FW44 |
| **FW51, FW52** | `[0x30000, 0x50000)` (the proof needed to read `0x4DAAC`) | FW46 |

### 4.6 FW50–FW56

See §3.7 for the bytes. Hashes (**C**, full):

| Tag | sha256 |
|---|---|
| FW50 | `57b5829e48ed60020aa66d65626cfbb2666f917bbd24219237865cedf3df011f` |
| FW51 | `70319c80802cbbae3cc1b3db873d2d97e0186dfdfe0635694e0f64876ea87da8` |
| FW52 | `ee837c924642efc3b98a8db0fa30b6f1a72b8684b98171a8970841f19d600127` |
| FW53 | `9a4fee7cae7e4ee47ce562a4a7f33c08adff3f10e234c97ee272ec9d47161e4d` |
| FW54 | `f1d6e567e75b8d07c342e1d1ebfec3829f5ccee6cd9bc207c68ef4dfd0a070f6` |
| FW55 | `68babf09fa368f68abbd4fe62cd3c994cc522ce9bf2b4b8ac9c55518467cdebc` |
| FW56 | `1c5c25e46c4217e99cee831c90a06cdfe132d5ff7b57ec8c78463d9704888269` (not loaded, rejected) |

Two full acceptance passes were run: **FW52** (rev:2706) and **FW54** (rev:2754). Neither was declared stable. Each fix since FW46 broke a row an earlier image had passed (rev:2790): FW46 tone hold, FW50 pitch and hold, FW52 slot 0 carrier, FW54 app-audio keys, FW55 no symbol keys.

### 4.7 Lineage at a glance (**C**, from the diffs)

```
factory ─ RG10 (cmd40-sym) ─ FW19 (+tot120) ─ FW20 (+drain) ─ FW21 ─ FW22 ─ FW23 ─ FW24 ─ FW25 ─ FW26 ─ FW27 ─ FW28 ─ FW29
FW29 ─ FW3A…FW3K (bisect) ─ FW30 (= FW3K retag) ─┬─ F30B ─ F30C ─ FW31 ─ FW32 ─ FW33/FW34
                                                  ├─ FW35
                                                  └─ FW36 ─ FW37 ─┬─ FW38 ─ FW39
                                                                  ├─ FW40 ─ FW4D/4E/4F
                                                                  ├─ FW41 ─ FW42/FW43 (+F42D/F42E/F43D)
                                                                  └─ FW44 ─ FW45 ─ FW46 ─┬─ FW47, FW48, FW49, F48L, F49L
                                                                                          ├─ FW50, FW51, FW52   (all three built from FW46 by script)
                                                                                          ├─ FW53
                                                                                          └─ FW54 ─┬─ FW55
                                                                                                   └─ FW56 (rejected)
```

FW40, FW41 and FW44 take `SRC = FW37` and re-apply the FW38 (and FW40/FW41) bytes; the FW37→FW41 and FW37→FW44 diffs cover the same spans (**C**). **FW53, FW54 and FW55 descend from FW46, not from FW52**: none has the FW50 gate.

### 4.8 Bisect and lettered images, file hashes (**C**)

| File | sha256 (prefix) | | File | sha256 (prefix) |
|---|---|---|---|---|
| FW3A | `8653c32c…24c2` | | B3G1 | `8023657c…f835` |
| FW3B | `731641cd…3ec9` | | B3G2 | `ba97a60b…bde2` |
| FW3C | `7c89df2c…f15b` | | B3G3 | `52692059…f96e` (not loaded) |
| FW3D | `585bde05…65d3` | | B3G4 | `c41ee0f6…5118` (not loaded) |
| FW3E | `018d32af…9313` | | B3G5 | `4e2d4365…76ce` (not loaded) |
| FW3F | `4b6bbf42…710f` | | B3G6 | `33d90d12…7fc5` (not loaded) |
| FW3G | `13e4e76a…d39f` | | E3G1 | `bf8e4a06…2a86` |
| FW3H | `6d36e82c…55da` | | E3G2 | `5f5ad34e…7557` |
| FW3I | `8f7ce239…8c6e` | | E3G3 | `781dc0bd…9596` |
| FW3J | `808faed5…b7a4` | | F31G | `91f2a645…857f` |
| FW3K | `e8b2c89f…7494` | | F32A | `32a40a3e…2154` |
| FWD1 | `d7efd88a…a229` | | F32M | `4f380f4c…5dc8` |
| F42D | `12146c55…126b` | | F44D | `fffbc424…e803` |
| F42E | `305d7845…bac2` | | F45D | `eaffa5de…012e` |
| F43D | `b0dd78e3…6696` | | F45E | `cec33e24…64b6` |
| F45F | `8abf51b4…e843` | | F45G | `53184e21…5f61` |
| F46G | `8a1e9e47…2314` | | F47G | `752f0996…a45a` |
| F48G | `724f8165…0b28` | | F48L | `2f9224b6…dc2a` |
| F49L | `95f88765…6a59` | | FW4D / FW4E / FW4F | `7d64f56e…`, `d6aca812…`, `6af8153f…` |

---

## 5. The four `0x26` call sites in every image

`fw30_build.bsr_target(blob, site)` on every file in `radio_firmware/build/` and on the factory file (**V, C**, 2026-10-30). Columns: body 2 `0x92AA`, body 1 `0x92C8`, body 1 `0x92E0`, body 2 `0x92FA`. Also shown: the command `0x40` slot word at `0x382B8` (`544a0203` = factory empty pop; `fc4e0703` = XIP `0x03074EFC` = our handler at `0x5AEFC`; `64ff0403` = R4l0's thunk in the data table) and the `0x3B` thunk at `0xAB18` (`0xA308` stock, `0x5B700` the FW19 ceiling).

| Images | `0x92AA` | `0x92C8` | `0x92E0` | `0x92FA` | `0x40` slot | `0xAB18` |
|---|---|---|---|---|---|---|
| factory `UV4T`; UVm1–UVm9, Vm10, Vm11; R300, R301; R3a0, R3a1, R3a2 | `0xE9C` | `0xE9C` | `0xE9C` | `0xE9C` | factory | `0xA308` |
| R3a3–R3a7 | `0x5B088` | `0x5B000` | `0x5B000` | `0x5B088` | factory | `0xA308` |
| R3a8, R3a9, R3b0 | `0x5B0A0` | `0x5B000` | `0x5B000` | `0x5B0A0` | factory | `0xA308` |
| R4a0, R4b0 | `0x5B080` | `0x5B000` | `0x5B000` | `0x5B080` | factory | `0xA308` |
| R4c0 | `0x5B128` | `0x5B000` | `0x5B000` | `0x5B128` | factory | `0xA308` |
| R4d0 | `0x5B168` | `0x5B0D0` | `0x5B0D0` | `0x5B168` | factory | `0xA308` |
| R4e0–R4k0 | `0x5B128` | `0x5B090` | `0x5B090` | `0x5B128` | factory | `0xA308` |
| R4l0 | `0xE9C` | `0xE9C` | `0xE9C` | `0xE9C` | `0x35F64` | `0xA308` |
| R4m0, R4n0 | `0xE9C` | `0xE9C` | `0xE9C` | `0xE9C` | ours | `0xA308` |
| R4o0 | `0x5B130` | `0x5B080` | `0x5B080` | `0x5B130` | ours | `0xA308` |
| R4p0 | `0x5B16C` | `0x5B0B8` | `0x5B0B8` | `0x5B16C` | ours | `0xA308` |
| R4q0 | `0x5B148` | `0x5B098` | `0x5B098` | `0x5B148` | ours | `0xA308` |
| R4r0 | `0x5B184` | `0x5B0D0` | `0x5B0D0` | `0x5B184` | ours | `0xA308` |
| R4s0 | `0x5B268` | `0x5B1D4` | `0x5B1D4` | `0x5B268` | ours | `0xA308` |
| R4t0 | `0x5B2FC` | `0x5B268` | `0x5B268` | `0x5B2FC` | ours | `0xA308` |
| RC20 | `0x5B3DC` | `0x5B348` | `0x5B348` | `0x5B3DC` | ours | `0xA308` |
| RC30 | `0x5B4BC` | `0x5B428` | `0x5B428` | `0x5B4BC` | ours | `0xA308` |
| RC40 | `0x5B4B8` | `0x5B424` | `0x5B424` | `0x5B4B8` | ours | `0xA308` |
| RD10 | `0x5B584` | `0x5B4F0` | `0x5B4F0` | `0x5B584` | ours | `0xA308` |
| RE10 | `0x5B5B0` | `0x5B51C` | `0x5B51C` | `0x5B5B0` | ours | `0xA308` |
| RG10 | `0x5B614` | `0x5B580` | `0x5B580` | `0x5B614` | ours | `0xA308` |
| FW19, FW20–FW31 (incl. FW31.bit2/.idle), F30A, F30B, F30C, F30E, F30F, FWD1, F19D, F32A, B3G1–B3G6, E3G1–E3G3, FW3D–FW3K, FW35 | `0x5B614` | `0x5B580` | `0x5B580` | `0x5B614` | ours | `0x5B700` |
| FW32, FW33, FW34, F32D, F32M, FW36–FW49, FW4D/4E/4F, F42D, F42E, F43D, F44D, F45D–F45G, F46G–F49L, **FW53, FW54** | `0x5B614` | `0x5B580` | `0x5B580` | `0x5B614` | ours | `0xA308` |
| FW3A, FW3B, FW3C | `0x5BFBE` | `0x5BFB2` | `0x5BFB2` | `0x5BFBE` | ours | `0x5B700` |
| **FW50, FW51, FW52, FW56** | `0x5B660` | `0x5B65C` | `0x5B65C` | `0x5B660` | ours | `0xA308` |
| F19A, F19M, F19R | `0xE9C` | `0xE9C` | `0xE9C` | `0xE9C` | ours | `0x5B700` |
| F19B, F19C, F19S, FR22 ("F19R2" file), F1B2 | `0xE9C` | `0xE9C` | `0xE9C` | `0xE9C` | ours | `0xA308` |
| F19T | `0xE9C` | `0xE9C` | `0xE9C` | `0xE9C` | factory | `0xA308` |
| **FW55** | `0xE9C` | `0xE9C` | `0xE9C` | `0xE9C` | ours | `0xA308` |

Note F32D carries the tag `DMR003.FW32.V022` and F19R2's file carries `DMR003.FR22.V022` (**C**). FW3A–FW3C are the only images whose sites point at a prelude at `0x5BFB2`/`0x5BFBE` (`fw30_port.py` `PRE_AT`).

What the outside hooks point at in FW54 (**C**): `0x37F8`→`0x5BDAA` (close guard), `0x7C56`→`0x5C040` (UART pend: rate-switch countdown `0x4B368`/`0x4B36C`), `0xA890`→`0x5C4E2`, `0xC1BA`/`0xC244`→`0x5C4C8`, `0x17E26`→`0x5C518` (FW26 promiscuous sites), `0x18B68`→`0x5B4D0` (wake), `0x18B5C` stock (`bsr 0x18B70`), `0xAB18` stock (`bsr 0xA308`), `0x382B8` = `0x03074EFC`.

---

## 6. The free tail `0x5AEFC`–`0x5C6FB` as FW54 uses it

**Provisional, not a reachability proof.** Owners come from the build scripts' link addresses and from reading the FW54 disassembly (push/pop boundaries, `lrw` pools, branch targets). A range shown as an owner is live unless a later row proves it dead; **no range here is certified free**. The firmware agent's rewrite of `radio_firmware/fw54_space_map.md` (uncommitted at the time) is the place where reachability is being proved.

### 6.1 The 13 XIP pointers into the tail (**V, C**, every aligned word of FW54 and FW46 in `0x03074EFC`–`0x030766FB`)

| Word at | Points to | What |
|---|---|---|
| `0x382B8` | `0x5AEFC` | command `0x40` handler |
| `0x5B3FC` | `0x5B6A0` | dibit table, loaded by `put_sym` at `0x5B3D8` |
| `0x5B4A4` | `0x5B6A4` | RRC taps (5 phases × 9), loaded by `one_sample` at `0x5B428` |
| `0x5BDD8` | `0x5BE00` | op 7 helper target (`0x5BD82`: when byte 0 of `0x34808` != 0) |
| `0x5BDDC` | `0x5AFC8` | op 7 helper target (refuse path) |
| `0x5BDE4` | `0x5B65A` | `drop_ptt`, `jsr` from `0x5BD98` |
| `0x5BE24` | `0x5AF52` | append body, jumped to from `0x5BDFE` |
| `0x5BE34` | `0x5C464` | FW26 stub, `jmp r12` from `0x5BCD0` |
| `0x5C45C` | `0x5C200` | table/code in the FW25 extension |
| `0x5C58C`–`0x5C598` | `0x5B2CC`, `0x5B2AC`, `0x5B2FA`, `0x5B308` | four dispatcher targets (FW27 tail) |

### 6.2 Map

| Range | Owner (source) | Reached from | Notes |
|---|---|---|---|
| `0x5AEFC`–`0x5B3D7` | command `0x40` handler, ops 1–7 dispatch and bodies (`sym.S`, `c7000-cmd40-sym`), with FW21+ patches at `0x5AF1E`, `0x5AFEC`, `0x5B308`, `0x5B318`; FW27 `0x5B2A8`/`0x5B2BE`; FW38/41 `0x5B250`; FW3K `0x5AF44`–`0x5AF51` (op 1 → `0x5BDFE`, op 7 → `0x5BD82`) | slot `0x382B8`, the four dispatcher pointers | pools inside (`0x5B268`–`0x5B27x`) |
| `0x5B3D8`–`0x5B407` | `put_sym` + pool (`0x5B3FC` = dibit pointer) | ops 1/7 | |
| `0x5B408`–`0x5B4B3` | `one_sample` (5-phase RRC) + pool (`0x5B4A4` = taps pointer) | wake, op 4; FW21 `fw21_sample` falls through to it for non-magic modes | `ONE = 0x5B408` in fw21 |
| `0x5B4B4`–`0x5B4C9` | `emit_n` | `on_key`, wake | |
| `0x5B4CA`–`0x5B57F` | `on_wake_disp` (`0x5B4CA`, unused since `0x18B5C` stock), `on_wake_skip`/wake body (`0x5B4D0`), FW20 call at `0x5B536`–`0x5B54B` (`bsr 0x5B720` at `0x5B53A`), pool | `0x18B68` | |
| `0x5B580`–`0x5B613` | `on_key` + pool `0x5B5F0`–`0x5B613` | sites `0x92C8`/`0x92E0` (FW54) | §3.2 |
| `0x5B614`–`0x5B659` | `on_unkey` | sites `0x92AA`/`0x92FA` | |
| `0x5B65A`–`0x5B69F` | **`drop_ptt`** + pool `0x5B690`–`0x5B69F` (`0x4DAAC`, `0x1100039C`, `0x11000560`, `0x11000080`; also used by `on_unkey`) | pointer `0x5BDE4` (`jsr`) | **live** (FW49/50/51/52/56 wrote it) |
| `0x5B6A0`–`0x5B6A3` | dibit table `01 03 FF FD` (00→+1, 01→+3, 10→−1, 11→−3, `sym.S` `dibit`) | pointer `0x5B3FC` | **live** |
| `0x5B6A4`–`0x5B6FD` | RRC taps, 45 × int16 (`sym.S` `coeffs`) | pointer `0x5B4A4` | **live** (90 bytes, the indexed extent is phase 0–4 × 9 taps × 2 B) |
| `0x5B6FE`–`0x5B6FF` | padding | — | **dead** (`tailmap.py`) |
| `0x5B700`–`0x5B71F` | FW37 `RF_MODE` save/restore + pool | **nothing** (§3.6; `tailmap.py`: unreached on FW46 and FW54) | **dead** by reachability since FW44's move (`fw44_build.OLD_SAVE`); not a "pitch helper"; in `space_map.FREE` |
| `0x5B720`–`0x5B793` | FW20 drain gate / "tone-end task" (`gate.S`) incl. the drop call `0x5B748`, the unkey sequence `0x5B74C`–`0x5B75B` (FW54: nops at `0x5B758`), the restore branch `0x5B770`, pool `0x5B77C`–`0x5B793` | `0x5B53A` | live |
| `0x5B794`–`0x5BCA3` | FW21–FW25 extension: `fw21_op3` (`0x5B794`), `fw21_fill` (`0x5B7AC`), `fw21_ops` (ops 8–11), FW22 key test `0x5BBE2`, tone/sample engines (`0x5BB92` polyphase sum), FW26 gate patch `0x5B7DE`, FW27/FW28 changes `0x5B816`–`0x5B86F` | `0x5AF1E` (op 3), `0x5B308` (unknown-op path), `0x5BDF6` | live |
| `0x5BCA4`–`0x5BCD9` | FW27 low stub remnant (op 5/6 v5 dispatch, `jmp r12` → `0x5C464` at `0x5BCD0`), FW29 `0x5BCB0`, FW38 `0x5BCB3` | op dispatch | |
| `0x5BCDA`–`0x5BD73` | FW38 save (`0x5BCDC`) / restore (`0x5BD06`) + pool `0x5BD44`–`0x5BD67`; FW41/44 changes; branches to `0x5B254`, `0x5B2A8` (op 6 mode-3 tail) | `on_key` `0x5B592`, task `0x5B770` | was op 6 variant 5 (FW27) |
| `0x5BD74`–`0x5BDE9` | FW3K block: op 16/17 refuse (`0x5BD74`), op 7 helper (`0x5BD82`), drop helper (`0x5BD98`), close guard (`0x5BDAA`), pool `0x5BDD0`–`0x5BDE8` | `0x5BCC4`, `0x5AF4C`, `0x5B748`, `0x37F8` | |
| `0x5BDEA`–`0x5BE33` | FW3E/FW3K key gate (`0x5BDEC`), append entry (`0x5BDFE`), flag helpers (`0x5BE0A`, `0x5BE14`), pool `0x5BE20`–`0x5BE33` | `0x5B58E`, `0x5AF44`, `0x5B616` | |
| `0x5BE34`–`0x5BF9D` | FW21–FW27 literal pool (incl. the key-helper pool `0x5BE60`–`0x5BEDF` whose overwrite broke FW27), sine table (FW21, addressed at XIP `0x03075C64` in FW21), I²C helpers (`0x5BF24`, `0x5BF8A`) | many | live (F30B text: "the live literal pool and the I²C helpers"), **except `0x5BE38`–`0x5BE87` (80 B), unreached by `tailmap.py` and not yet identified; kept out of `FREE`** |
| `0x5BF9E`–`0x5C03F` | opcode 16 body (`0x5BFB2`, rate switch) with its helpers `0x5BF9E`/`0x5BFF2`, and opcode 17's half copy `0x5BFFE` | none: FW30 retargeted `0x5BCC4` to the refuse at `0x5BD74`; `0x5BFFE` is reached only from `0x5C6BC`, inside the dead cluster below | **dead** (162 B, `tailmap.py`, firmware agent 2026-10-30; F30B/F30C once put diagnostic op 18 at `0x5BFB2`) |
| `0x5C040`–`0x5C087` | `0x5C040` UART pend hook (from `0x7C56`) + pool `0x5C078`–`0x5C087` | `0x7C56` | live |
| `0x5C088`–`0x5C097` | pool of the dead op 17 copy | none | **dead** (16 B) |
| `0x5C09A`–`0x5C137` | op 14 RAM read (window `movih` at `0x5C0CE`/`0x5C0D6`) | op dispatch | live |
| `0x5C138`–`0x5C463` | FW23–FW25 extension: tone-engine state (`0x5C14C` reads `0x4B02C`/`0x4B030`/`0x4B036`), sample store `0x5C138`, table `0x5C200` (pointer `0x5C45C`), pools | `0x5BBDC` and others | live |
| `0x5C464`–`0x5C54B` | FW26 promiscuous stubs (`0x5C4C8`, `0x5C4E2`, `0x5C518`) | `0xC1BA`, `0xC244`, `0xA890`, `0x17E26`, pointer `0x5BE34` | live |
| `0x5C54C`–`0x5C59B` | FW27 tail: variant 5 trampoline `0x5C54C`, `0x5C564`, unsupported reply `0x5C584`, four-entry table `0x5C58C`–`0x5C59B` | op dispatch | live |
| `0x5C59C`–`0x5C6FB` | op 17 half sender ("wrap") + pool (`0x5C6C8`, `0x5C6E0`) | only `0x5C032` (dead); it calls back to `0x5BFFE`: a closed dead cluster | **dead** (352 B) |

**V (C):** there is no run of 16 or more `0x00` or `0xFF` bytes anywhere in the FW54 tail (rev:2853 states the same). New bytes can only come from ranges proven dead.

---

## 7. Where the sources disagree

| # | Topic | Sources | Resolution here |
|---|---|---|---|
| 1 | **`0x5B700`–`0x5B71F` "pitch helper"** | fw53/54/55 headers, `map`, rev:2816 say live tone-queue pitch helper; fw38 ("becomes uncalled"), fw42 ("FW41 already redirected its only callers (0x5B592, 0x5B770)"), fw47 ("the dead hole at 0x5B700") and res:4855's own description (RF_MODE copy, returns 135) say FW37's save | bytes and references side with "uncalled" (§3.6); the pitch claim is a correlation with FW50 |
| 2 | **`0x5B65A`–`0x5B690` "free"** (old `map`) | old `map`: no branch or pool lands there; rev:2853: live drop via `0x5BDE4` | live (§6.1); FW49, FW50, FW51, FW52, FW56 all wrote it |
| 3 | **`0x5B6A0`–`0x5B6F8` "free"** (old `map`) | old `map`; rev:2853 | live: dibit table + taps |
| 4 | Dibit bytes | rev:2853 and working-tree `map` write `03 01 FD FF` | the file holds `01 03 FF FD` at `0x5B6A0` (**C**), matching `sym.S` `.byte 1, 3, 0xff, 0xfd` |
| 5 | FW53/54/55 base | HO:41 told the builder "FW52 plus …" | scripts: SRC = FW46 (FW53, FW54), FW54 (FW55); diffs agree |
| 6 | FW51/FW52 base | docs: FW50 → FW51 → FW52 | scripts: SRC = FW46 for both, re-applying the gate |
| 7 | FW40/41/44 base | res:4672 "FW38's save/restore plus" | scripts: SRC = FW37, re-applying FW38 bytes (same result) |
| 8 | FW20 sidecar | `DMR003.FW20.V022.bin.sha256` says `a80e75d5…` | file, rebuild and res:2428 say `31ecdd30…` (the only stale sidecar; likely the replaced first FW20, I) |
| 9 | F19R2 | text sha `66611624…` | file `DMR003.F19R2.V02.bin` is `ffb2a589…`, tag `FR22` |
| 10 | Reused tags | FW30 (images 1–6, port `58ece263`, final `aaccf03d`), F30B (`045bca9c` am, `487fe953` pm), F30C, FW31 (3 files), FW32 (5 builds), FW27 (≥ 10 builds) | a tag does not identify an image; cite the sha |
| 11 | "Group slot 0 silence is FW52 only" | res:4857 vs res:4839 | FW46/FW51 radiated a carrier without sync; FW52 lost the carrier |
| 12 | FW51 header | says the symbol end calls `0xE9C(r1=1)` and stores 2 | res:4878 and the FW51 bytes: `0x5B748` → `br 0x5B77A`, no `0xE9C` in the task |
| 13 | Diagnostic names | F45E is "FW45-D2" in its script; res:4894's "FW45-D2" paragraph describes F45F ("FW45-D3") | names by tag, not by D-number |
| 14 | Op 18 in mainline | brief "do not reclaim op 13 or op 18" | final FW30 and FW36 answer op 18 with `sr=1` (res:4155, 4556); op 18 lives only in diagnostics (F30B, FWD1, F32D, FW30 image 3c) |
| 15 | Zero-tail size | d19 §1 says 1,788 B | d19:621 corrects to 6,144 B (`0x5AEFC`–`0x5C6FB` + …); the tail here is 6,144 B |
| 16 | `0x5B65A` "has no caller" | fw48l header line 7, old `map`, `space_map.py` comment | false: `0x5BD98`'s `jsr` through `0x5BDE4`; F48L, FW49 and F49L also wrote it |
| 17 | FW51/FW52 headers | fw51: the symbol end calls `0xE9C(r1=1)` and stores 2; fw52: "0x4DAAC stays 0" | FW51 bytes never store 2; FW52's arm stores 1 to `0x4DAAC` on every accepted op 1 |
| 18 | FW52 "refuses any further symbol chunk" | fw52 header | only op 1 checks `0x4D900`; op 7 and ops 10/11 do not (V sites) |
| 19 | Gate arm | FW50/FW51/FW56 | the arm runs on op 1 only, never op 7, so a stream of op 7 chunks alone would take the stock path (I) |
| 20 | Script names | `fw23_build.py` / `test_fw23.py` | build and test **FW25**; `fw30_port.py` writes FW3B; `fw41d/d2/d3` write FW4D/FW4E/FW4F; `fw21_build.py` says "from the FW20 image" but builds from factory + `c7000-fw20-drop` + `c7000-tot-120` |
| 21 | FW43 header | "the stock 0x26 off passes r0=0, r1=0 into 0x5B580" | body 2 goes to `0x5B614` (`on_unkey`); `0x5B580` is `on_key` |
| 22 | `test_fw27.py` | "opcode 12 and 14 … stay" | FW27's variant 6 broke ops 8, 9 and 14 (fw28 header) |
| 23 | FW35 header | "Opcode 18's old stub lived at 0x5BD74" | true for FW30 image 4; in the FW30 it was built on, that range is the FW3K refuse/op 7/drop/guard block |
| 24 | `pointed_into` spec | rev:2853 asks for "value inside a changed range" and expects FW56 to fail on `0x5BDE4` | `0x5B65A` itself was not changed; an exact test misses it; the working-tree code adds a 4-byte look-ahead (§1.5) |

---

## 8. Open questions

1. **Is `0x5B700`–`0x5B71F` really dead?** Static analysis says yes since FW38. A one-image bench check (FW54 with that range zeroed, FT8 and RTTY decoded and released) would settle the "pitch helper" claim before anyone reclaims or protects it.
2. **What caused FT8 at 7.4–7.5 kHz on FW50/FW52?** Candidates: the gate inside `drop_ptt` (stack 20 bytes low on return, rev:2853), the op 1 retarget at `0x5AF44`, or the arm writing `0x4DAAC`. Not bisected.
3. **The `0x5BDEC` → `0x5BBE2` stack balance** (§3.2 caveat). **Answered (reviews.md, firmware agent 2026-10-30 09:40):** byte 0 of `0x34808` is 1 on analog channels, so every analog key with nothing queued (plain FM, the CTCSS test tone, SSTV) reaches that exit and returns through an unbalanced stack. F48L's `0x4DAAC` = 1 after a plain key and its `lr` = 1 entry are the fingerprints. FW57 replaces `push r15; bsr 0x5BBE2; pop r15` at `0x5BDF4` with `br 0x5BBE2; nop; nop` (8 bytes, no new space); bench proof pending.
4. **What does byte 0 of `0x34808` mean?** The FW3K gate depends on it ("channel-mode byte", fw3b_bisect `build_fw3k`): symbol keys only arm, and op 7 is only accepted, when it is non-zero. Which channel types set it is not confirmed here.
5. **The first group slot 0 key with no sync** persists on FW55 (stock sites), so it is not the `0x26` sites. FW55 differs from the factory image outside the tail only in seven 4-byte hooks (`0x37F8`, `0x7C56`, `0xA890`, `0xC1BA`, `0xC244`, `0x17E26`, `0x18B68`) plus the `0x40` dispatch word, so the plan is a hook bisect plus a RAM read of `0x4B364`/`0x4B368`/`0x4B376` (reviews.md, 10:15), replacing the lineage bisect. The 07:58 busy-flag (`0x32457`) reading is still open.
6. **Why does `0xE9C(r1=0)` not return** in our use (FW46, FW49)? The stock unkey sites pass `r1`=1 through the prelude (fw49 header); the mechanism is inferred.
7. **Op 13 and op 18 in the current lineage:** which bytes still belong to them, and are they reachable (op 13 retired by FW27's reclaim; op 18 refused)? Needed before any reclaim.
8. **F30E and B3G3–B3G6** exist as files with no recorded result; no script builds FW3A although the file exists.
9. **Unbisected static findings** from reading the scripts (not run): FW52's arm uses `r6` as scratch without saving it; FWD1's op 18 refusal path branches into `0x38CF4`/`0x38CFC` (data); F32D's op 18 at `0x5C14C` overwrote the start of the tone engine; FW3B/FW3C's relocation packed the ring, tap table and queue over a 0xDC-byte block.
10. **DMR receive on FW52/FW54/FW55** was unproven (replays at −105/−108 dBm). **FW57 (2026-10-30): slot 2 in-list receive proven with the hotspot as transmitter; slot 1 still not covered.**
11. **Promiscuous admission** (route P1): on FW57 the flag is acked, but a real out-of-list TG 99 call is not admitted. Where the call is still dropped after the `0xC1BA`/`0xC244` hooks is unknown. SignalDeck beta.22 keeps the feature off (`PROMISCUOUS_FW` = max).
12. **DMR All-Call** (route P2, owner 2026-10-30): is an incoming All-Call (`0xFFFFFF`) heard on a normal group channel (factory and FW57)? Why does contactType 2 (ALL / RECEIVE_ALL) give target `0xFFFFFF` and drop the audio (`bmaski r?, 24` at the all-call sites; 02 §11, 04)? Can the Armor transmit one? Is it the same admit gate as promiscuous (`0x2404`)?

## 9. Lessons

1. **"It booted and keyed" never proves a range free.** FW50–FW52 ran with the gate inside `drop_ptt` and only looked fine where the stack contents were kind.
2. **Code and data in the tail are reached through XIP pointers** (`0x0301A000 + offset`, loaded by `lrw` and used by `jsr`/`jmp` or as a table base). Branch walks and literal-pool overlap checks do not see them; scan every aligned word for `0x03074EFC`–`0x030766FB`, and check function and table extents, not single target bytes.
3. **A literal pool is code's data.** FW27's first image died because a stub covered the pool an unchanged `lrw` used (`0x5BE60`); FW35 broke op 3 by overwriting the op 7 helper at `0x5BD82`.
4. **Data tables have extents.** The 128 zeros at `0x35F64` are a table tail (R4l0, FW30 image 3 did not boot); the 90 bytes at `0x5B6A4` are five phases of nine taps.
5. **A label is not evidence.** "Pitch helper" came from a bench correlation; the bytes say RF_MODE save, uncalled since FW38.
6. **Know the base.** FW53–FW55 came from FW46, FW51/FW52 too; FW40/41/44 from FW37. Read `SRC` in the script, then diff.
7. **One key-off per key.** Every regression from FW45 to FW55 was a second or missing `0xE9C`, a flag left set, or the stock path taken for the wrong key.
8. **A tag names a family, a sha names an image.** FW30, FW31, FW32 and FW27 each covered several different files.
9. **Every image runs every row** (rev:2790): each fix since FW46 broke a row an earlier image passed. FW55's proof skipped M17 and the tone queue and looked good for that reason.
10. **Tests write `radio_firmware/build/`** (§1.6); check the directory after a test run.
