# 01 — Hardware, memory map, boot and loader

Part of the firmware reference for the Ulefone Armor 26 Ultra radio module: factory image `DMR003.UV4T.V022`, SoC HR-C7000 (C-SKY CK803S with DMR/FM modem, vocoder and 8 kHz codec), RF IC Auctus AT1846S, phone-side codec Everest ES8311. This chapter covers the chips and the registers we know, the memory map of the image and of the running module, the boot path, tasks and interrupts, the update loader, and the toolchain. The command set, the patch history and the measured behaviour of the modes are in the other chapters.

Compiled 2026-10-30 from the sources in §0.2. Two facts were re-read from the factory file for this chapter (the zero-tail length and the dispatch table, §2.3, §2.6), and the reset code, the vector table, the task list and the kernel services were read from the factory listing (§3). Nothing was loaded, keyed or measured on the radio.

## Contents

- §0 Conventions, address arithmetic and sources
- §1 The chips
- §2 Memory map
- §3 Boot, tasks and interrupts
- §4 The loader
- §5 Toolchain and symbol files
- §6 Where the sources disagree
- §7 Open questions

---

## 0. Conventions, address arithmetic and sources

### 0.1 Labels

| Label | Meaning |
|---|---|
| **V-bench** | Verified on the bench or on air. The cited source records the run. |
| **V-static** | Verified by reading the factory image (disassembly, literal scan, table read), cited to the source that did it. "V-static (this chapter)" means the reading was done for this chapter on `radio_firmware/DMR003.UV4T.V022-ORIGINAL.bin` with the objdump of §5.1. |
| **V-doc** | Stated in the HR-C7000 user guide (`radio_firmware/HR_C7000_user_guide.pdf`), section and printed page given. |
| **I** | Inferred: follows from the above plus a datasheet or a sibling firmware, not shown directly. |
| **S** | Superseded: an older claim a later source overturned. Kept so old notes can be recognised. |

When sources disagree, the code and the latest bench run win, and §6 lists the disagreement.

### 0.2 Sources and short names

| Short | File |
|---|---|
| CL §n | `CLAUDE.md` (repo root), the MCU firmware RE row in §1 and the rows of §3 |
| 07 §n | `docs/deep-dive/07-firmware-update-and-mcu.md` |
| 11 §n | `docs/grok-deep-dive/11-firmware-fw0-results.md` |
| 19 §n | `docs/deep-dive/19-firmware-modification-plan.md` (another agent has uncommitted edits in it; read as of 2026-10-30) |
| RES "…" | `radio_firmware/results.md`, by section heading (uncommitted edits by another agent; line numbers drift) |
| REV "…" / HO | `radio_firmware/reviews.md` / `radio_firmware/HANDOFF.md` |
| LS | `radio_firmware/plan-loader-safety.md` |
| PA | `radio_firmware/plan-port-automation.md` |
| RM | `radio_firmware/README.md` |
| SYM | `radio_firmware/symbols.csv` |
| ONB | `docs/firmware-agent-onboarding.md` (2026-10-30) |
| MAP54 | `radio_firmware/fw54_space_map.md` (untracked, another agent's work in progress) |
| GUIDE §n p.N | `radio_firmware/HR_C7000_user_guide.pdf` (Chinese, v2.7, 412 pp.; RM calls it "Document 2"). Page numbers are the printed ones, which equal the PDF page index. Text extraction needs PyMuPDF; `pdftotext` drops the Chinese (RM) |
| STUB name | `tools/fw-patch/stubs/<name>.S` header comment |
| FW30B | `tools/fw-patch/fw30_build.py` |

### 0.3 Three address spaces for one byte

The image is linked for three regions (11 §21.0, RES "R3-0 / R3a1", "The copy at boot"; V-static). Every address in this reference names its space.

| Space | Rule | Example |
|---|---|---|
| **File offset** (`+0x…`) | Position in the 378,620-byte file. `symbols.csv`, `patches.toml` and the build scripts use this. | version string `+0x38464` |
| **XIP flash** | `0x0301A000 + file offset`, for every byte of the file. Flash code and constants run here. | `0x03052464` = `+0x38464` |
| **IRAM** | For file `+0x39408 … +0x5AEFB`: IRAM `= file − 0x29408` (`0x10000 + (file − 0x39408)`). This block is copied at boot and runs from IRAM. | `at1846_i2c_write` IRAM `0x2B220` = `+0x54628` |
| **SRAM** | For file `+0x322E0 … +0x35EE3`: SRAM `= 0x18000800 + (file − 0x322E0)`. Initialised data, copied at boot. | register list `0x18000808` = `+0x322E8` |
| **RAM variables** | Addresses `0x31AF4 … 0x4DAAF` are IRAM `.bss`, zeroed at boot, with no file content. Most "RAM addresses" in the bench notes (`0x38908`, `0x4DAAC`, …) are these. | |

Two traps. (1) The flat objdump listing (base 0) shows calls from flash code into IRAM as far targets `0xFCFF…`/`0xFD01…`; the true IRAM target is listed target + `0x0301A000` (11 §21.0). Older notes called those targets "external", "ROM" or "not in the file" (§6). (2) A `bsr` written into IRAM-copied bytes must be encoded from the runtime IRAM PC, not the file offset; R3a0 did not boot because of that (19 §22), and FW27 stage D's first build missed its I²C call the same way (RES "FW27 variant 7 lowers AT1846S register 0x44").

---

## 1. The chips

### 1.1 How the pieces connect

| Link | What | Status |
|---|---|---|
| Phone SoC (MT6885, ALSA card `mt6885-mt6359`) ↔ module | UART: the phone's `/dev/ttyS0` at 57600 8N1; the module's DesignWare UART3 at `0x14090000` | V-bench (RES "UART clock, read only"; 07 §2) |
| Phone ↔ module power and update entry | sysfs GPIOs `/sys/devices/platform/dmr009/pwd` (power) and `/ptt` | V-bench (07 §2.1, LS "Reading session") |
| HR-C7000 ↔ AT1846S | I²C, device byte `0xE2` (7-bit `0x71`) | V-static (11 §21.1) |
| Transmit voice, FM | phone PCM → tinyserver → I2S1 → ES8311 DAC → analog line → AT1846S microphone input | V-bench (19 §19, §20; RES "UVm11 — codec DAC gain") |
| Receive voice, FM | AT1846S audio pin (after register `0x58`) → ES8311 ADC → I2S2 → tinyserver → `PrizeTinyService` | V-bench (RES "Item 7 reading"; 19 §19) |
| Receive voice, DMR | HR-C7000 vocoder → PCM buffer `0x180000A0` → codec DAC lineout → the same ES8311 input | I (RES "Item 7 reading": the only documented exit, and the phone plays DMR voice) |
| Transmit, DMR / TX-RAM route | HR-C7000 modem builds the 4FSK itself and drives the RF through two-point modulation; no phone audio involved | V-bench (19 §20–§22) |

The HR-C7000 codec ADC and DAC are in neither the FM transmit nor the FM receive path: UVm10/UVm11 gain changes moved neither the air nor open-squelch receive (19 §19, RES "UVm10", "UVm11"; V-bench).

### 1.2 HR-C7000

**What it is.** A C-SKY CK803S (C-SKY V2 ISA, T-Head, mixed 16/32-bit, `rts16` = `0x783C`) with an integrated DMR/FM modem, vocoder interface and 8 kHz codec, running from SPI NOR flash in place (11 §9, §21.0; GUIDE §2.2, §4.5.5). Not ARM: every `0x08xxxxxx` address in older notes is void (RM, CL §1). V-static.

**Address map** (GUIDE §4.5.3 Table 26, p. 89; V-doc). Entries the firmware touches are marked.

| Range | Block | Used by this firmware |
|---|---|---|
| `0x00000000–0x0000FFFF` | BOOTROM | mask ROM, runs at reset (§3.1) |
| `0x00010000–0x00057FFF` | IRAM, 288 KB | code copy `0x10000–0x31AF3`, `.bss` to `0x4DAAF`, stacks to `0x50000` (§2.2) |
| `0x03000000–0x03FFFFFF` | LCSFC (SPI flash window), "flash run space" | bootloader `0x03000000–0x03019FFF`, application from `0x0301A000` |
| `0x11000000–0x1100FFFF` | Modem registers | yes (§1.2.1) |
| `0x14000000` | TIMER | — |
| `0x14020000` / `0x14100000` / `0x14110000` | GPIOA / GPIOB / GPIOC | the `1 << n` enables at `+0x3DDC` (11 §11.3; I that these are the GPIO blocks) |
| `0x14030000 / 0x14040000 / 0x14050000 / 0x14090000` | UART0 / UART1 / UART2 / UART3 | **UART3** is the phone link (`+0x5EF4`, 11 §10.2; `+0x5DEC`, RES "UART clock") |
| `0x14060000 / 0x14070000 / 0x14080000` | I2C0 / I2C1 / I2C2 (I2C2 RTC only) | the AT1846S bus (which instance: not read) |
| `0x16000000–0x1600FFFF` | Modem_Buffer (TX/RX RAMs, codec registers) | yes (§1.2.3, §1.2.4) |
| `0x17000000` | PIC (interrupt controller) | the common ISR writes `PIC_COW1` (§3.6) |
| `0x18000000–0x18007FFF` | SRAM, 32 KB | initialised data from `0x18000800`; vocoder PCM buffer `0x180000A0` |

Two more addresses appear in the code and are not in Table 26: `0xE000F000` (written by the reset code, §3.2; I: the CK803 cache/region control) and `0x44000004` (bits 31/30 polled by the synthesizer prelude `0x2AF24`, RES "`0x32457` writers"; meaning not read).

**Boot modes** (GUIDE §2.3 p. 34, §4.5.4 p. 89–90; V-doc): serial-port download mode or SPI-flash boot. The mask ROM sends a serial message, waits for a host; with no host it checks flash address 0 for a flag (`DH_FLAG`), reads the jump address at flash offset `0x04` and jumps (flow chart Figure 18). This is the CPU's own ROM, below the vendor bootloader of §4.

#### 1.2.1 Modem registers (base `0x11000000`)

Offsets from GUIDE register table 4 (§4.6.4, p. 94) and table 29 (§11.2.1, p. 331); field meanings from the cited subsections. "Firmware use" is V-static unless marked.

| Address | Name | Fields we use | Firmware use |
|---|---|---|---|
| `0x11000070` / `0x74` | `DAC_CONTROL` / `ADC_CONTROL` | baseband modulator DAC/ADC (GUIDE §4.6.5.1–2) | not traced |
| `0x11000080` | `AUDIO_CONTROL` | bit 0 `tx_voice_source` (0 = codec or vocoder, 1 = MCU-written RAM, "layer-2 base-station send"; GUIDE §4.6.5.3 p. 97); bit 2 `sel_i2s` (baseband-test I2S); bit 3 sidetone enable; bit 4 `ahb_wr_voice_en`; bit 7 ringtone path | Stock: three copies set bit 0 for struct byte `0x34808+0x12` = 2/3; FM key-up clears it at `+0x3EDF8` (RES "R2"). Ours: `on_key` sets bit 0 (TX-RAM source), `on_unkey`/`drop_ptt` clear it (ONB §4; STUB c7000_txram_dmr) |
| `0x11000084` | `AUDIO_BUFFER_CLR` | bit 1 clear decoder buffer, bit 0 clear encoder buffer | not traced |
| `0x11000088` | `LINEOUT_CTRL` | bit 31 `standby_lo` (RO in table 4; RES calls it the speaker gate `STANDBY_LO`, p. 249), bits 1/0 line1/line2 out enable | FW24 speaker-gate variant (CL §1) |
| `0x1100008C` | `CODEC_I2C_MUX` | codec register interface select | not traced |
| `0x11000100` | `WORK_MODE` | bit 8 `digital_analog_en`; **bit 7 `modulator_mode` (0 DMR, 1 FM)**; bit 6 tier; bit 5 timeslot; bits 4:3 layer; bit 2 repeater; bit 1 aligned; bit 0 slot select (GUIDE §4.6.5.7 p. 97–98, §11.2.2.1 p. 332) | Channel set-up stores `0x22`, `0x6A`, `0x6E`, `0x73`, `0x16A`, `0x16E` (Table 27 values, GUIDE p. 92; RES "R2", "FW37"); FM key-up stores `0x80` (`+0x3EDE4`). Idle analog reads `0xEE` after a restart (RES "Hold-off and FW41"). Ours: `on_key` and op 5/6 store `0x80`; FW30 stores `0x6E` back after a symbol key (FW30B) |
| `0x11000104` | `RF_MODE` | bits 6:5 = 11 two-point; bit 7 symbol-map select; bit 10 built-in 40 Hz square; bits 24/25 AF mode (GUIDE §4.6.5.8 p. 98) | Only full-word store is `0x10E0` at `+0x3EDD6` (FM key-up), saved before into `0x32520` (`+0x3ECCC`) and restored at `+0x3EE74` (RES "R2", "Factory stores of the two words", "FW37"). `0x10E0` is the key value, not an idle value. Ours: `on_key` stores `0x10E0`; FW37 added the stock-style save/restore |
| `0x11000398` | `SYS_INTERP_LIST` | bit 15 `fm_tx_interp` (analog TX data), 14 `fm_rx_interp`, 13 `fm_sig_rx_interp`, 0–6 layer-2, 11/12 physical layer, 16/17 (GUIDE §4.6.5.9 p. 100) | read by the sysint task (§3.6) |
| `0x1100039C` | `SYS_INTERP_MASK` | same bits; 1 = enabled (GUIDE §4.6.5.10 p. 100) | Stock stores `0x1187F` (`+0x179A2`), `0x1007F` (`+0x17A8E`), `0x1E07F` (when byte 1 of `0x34808` ≠ 0); FM key-up stores 0 (`+0x3EDCE`), unkey restores (`+0x3EE9E`) (RES "FM refill interrupt — bit 15"). Ours: `on_key` sets bit 15 for the TX-RAM half interrupt, the drop clears it (RES "FWD1 and FW30"; STUB c7000_cmd40_host) |
| `0x110003A0` | `SYS_INTERP_CLEAR` | write 1 to clear | the sysint task writes the list back until it reads 0 |
| `0x110003B0` | `INTERP_CLEAR` | bit 5 `clear_pcm_rd_int` (irq 27), bit 4 PCM write, bits 3/2 RF RX/TX start, bits 1/0 30 ms slot (GUIDE §4.6.5.15 p. 105) | FW23/FW25 clear bit 5 (RES "FW23", "FW25") |
| `0x11000400–0x1100040C` | layer-2 / slot control | not named here | `+0x18218` writes `0x404`/`0x408`; `+0x19438` sets bit 4 of `0x400`, stores `0x40C` = `0x20000000` (RES, `0x34808` set-up reading) |
| `0x11000500` | `FM_BANDWIDTH` | bit 6 `fmbpfon` (FM band-pass), bit 4 `fmpreemphasison`, bit 3 TX 12.5/25 kHz, bit 2 TX ACI filter bandwidth, bit 1 RX bandwidth, bit 0 CTCSS RX bandwidth; reset `0x5F` (GUIDE §11.2.2.2 p. 332–333) | **Never written by the factory image** (11 §21.3; RES "R2"). Ours: op 5 variants 2/4, op 6 variant 4/5 and the TX-RAM key clear bits 6 and 4 (STUB c7000_cmd40_sym, c7000_txram_dmr_sine) |
| `0x11000504` | `FM_DEV_COEF` | bits 23:16 `tr_sig_lim` (TX limiter, reset `0x0F`), bits 15:8 `fm_dev_coef_r` (RX deviation coefficient, reset `0x10`), bits 7:0 `fm_dev_coef_t` (TX, reset `0x10`) (GUIDE §11.2.2.3 p. 333) | Never written by the factory image. Ours: UVm7 limiter canary; op 6 variant 6 writes bits 15:8 only; measured: it scales **after** the receive saturation (CL §3 M17; RES "FW27") |
| `0x11000508` | `FM_SQL` | RO squelch value (GUIDE §11.2.2.4, §11.5) | not traced |
| `0x1100050C`, `0x510`, `0x51C`, `0x560`, `0x568` | `SUBVOICE_COEF`, `FM_MOD`, `USER_DEFINE_CTC`, `FM_PTT`, `FM_DECODE_FLAG2` | | the modem registers the factory image touches besides `0x100`/`0x104`/`0x400`/`0x408` (11 §21.3) |
| `0x11000560` | `FM_PTT` | bit 0 `fm_ptt`, high active (GUIDE §11.2.2.25 p. 338) | FM key-up stores 1; ours: `on_key` stores 1, `on_unkey`/`drop_ptt` store 0; opcode 13 never touches it (RES "Item 7 reading") |
| `0x1100056C` | `FM_ADDR_SW` | bits 1:0, RO: 1 = CPU reads/writes the low half, 2 = the high half (GUIDE §11.2.2.28 p. 339) | **No literal and no built address in the factory image** (RES "R2", "FM refill interrupt"). Ours: the symbol wake and op 5 follow it |

`0x1100156C` was looked for and has no flash literal (RES "FW43"). The C7000 FM receive input is the AT1846S demodulated audio (GUIDE §7.2.2.3.2, as read in RES "FW27 variant 7").

#### 1.2.2 Interrupt sources

GUIDE §4.7 (p. 105–107; V-doc): a PIC at `0x17000000` with 64 sources; source *n* has default vector 32 + *n*; all level-triggered high. The sources this firmware's work touches:

| Source | Vector | Name | Where it matters |
|---|---|---|---|
| 13 | 45 | UART3 | phone link |
| 7 / 8 / 9 | 39 / 40 / 41 | I2C1 / I2C0 / I2C2 | AT1846S bus |
| 25 / 26 | 57 / 58 | DAC / ADC | — |
| **27** | **59** | **`PCM_rd_data_interp`** | DMR vocoder PCM buffer `0x180000A0–0x1800013F` read by the codec, 160 B per 10 ms; the CPU refills and clears with `0x110003B0` bit 5 (GUIDE §7.1.2.2 p. 269–270, as read in RES "Item 7 reading") |
| 28 | 60 | `PCM_wr_data_interp` | — |
| **29** | **61** | **`System_inter`** | the `SYS_INTERP_LIST` line, including bit 15 `fm_tx_interp` (TX-RAM half empty) |
| 30 / 31 | 62 / 63 | 30 ms TX / RX slot | DMR TDMA |
| 32 / 33 | 64 / 65 | RF TX / RX start | |
| 37 | 69 | `Codec_interp` | |

PIC registers (GUIDE §4.7.5, base `0x17000000`): `0x00 PIC_MODE`, `0x04 PIC_PO`, `0x08 PIC_MASK`, `0x0C PIC_VECTOR`, `0x10 PIC_COW1` ("end of interrupt"), `0x14…` priorities. The common ISR writes 4 to `0x17000010` (§3.6; V-static this chapter).

#### 1.2.3 Modem buffer RAMs (base `0x16000000`)

| Range | What | Status |
|---|---|---|
| `0x16000030–0x1600022F`, `0x16000230–0x1600042F` | **FM TX RAM**, ping-pong halves of 512 B = 256 16-bit PCM samples = 32 ms at 8 kHz; the low address of each sample holds the high byte (big-endian) | V-doc (GUIDE §11.4.1 p. 340, Table 57); V-bench (RES "R2"; TX RAM route T1, RM) |
| `0x160004E0–0x160006DF`, `0x160006E0–0x160008DF` | **FM RX RAM**, base `0x160004B0` + `0x30`, same layout | V-doc (GUIDE §11.4.2 Table 58); V-bench: flat 100 Hz–3.5 kHz baseband at exactly 8000 Hz, a capture re-armed by each `WORK_MODE` `0x80` store, limited above about ±1 kHz deviation (CL §3 M17) |
| whole baseband RAM | 8 bits wide, depth 1200 (GUIDE §11.4); 32-bit reads return one valid byte lane per word, so read it with `ld.b` (REV, the op 5 review) | V-doc + V-bench |
| `0x16000030…` (DMR) | the 27-byte DMR voice payload also starts here; vocoder frames `0x16000960–0x1600097A` | V-static (RES "R2") |
| `0x160004B0–0x16000503` | DMR-mode receive copies of 5–36 bytes (`+0x1E1CA`, `+0x25B6C`, `+0x27E78`, …) | V-static (RES "R-A — C7000 receive symbols") |

The factory image never stores into `0x16000030–0x1600042F`; its only CPU touch of TX RAM is `+0x3EEEC`, which reads one sample from each half (RES "R2"). V-static.

#### 1.2.4 Codec registers (base `0x160009C0`, also written as `0x16000900 + offset`)

V-static (RES "Where FM audio enters the module", "Item 7 reading"), names per GUIDE ch. 6 (§6.5 p. 253+).

| Address | Name | Factory value / use |
|---|---|---|
| `0x160009C8` | `AICR_DAC` | `0xC0` at boot (24-bit, master, parallel; bit 4 clear = DAC interface active) |
| `0x160009C9` | `AICR_ADC` | `0xC0` at boot and at FM key-up (ADC master, on, parallel PCM) |
| `0x160009CD` | `CR_DAC` | bits 4 and 7 cleared at boot (DAC standby off, soft mute off); bit 0 `dac_zero_n` |
| `0x160009CF` | `CR_ADC` | bits 4 and 7 cleared at boot |
| `0x160009D2` | — | bits 0/1 cleared by the DAC-up sequence (`+0x647C`) |
| `0x160009D7` | `FCR_ADC` | bit 6 `adc_hpf`, bits 5:4 wind-noise filter (mode 3 = 235 Hz corner); **never stored**, stays at reset (off) |
| `0x160009DF` | `GCR_DACL` | `0xAB` at boot; DAC playback gain (receive/sidetone); UVm11 changed all ten slots, no effect on the air |
| `0x160009E3` | `GCR_MIC1` | written at boot |
| `0x160009E5` | `GCR_ADCL` | `0x8B` (11 dB) at boot; `+0x61F4` stores `0x89` (9 dB) when `0x38B5C+3` is 1 (STUB c7000_fm_adcgain); UVm10 moved it 6 dB, no effect on the air or on receive |

The codec init is `+0x647C`, one caller at `+0xDE4` (boot task, §3.3). The halfword copy at `+0x67D0` fills `0x16000980–0x160009BF` (RES "Where FM audio enters the module").

#### 1.2.5 SRAM buffers used with the modem

| Address | What | Status |
|---|---|---|
| `0x180000A0–0x1800013F` | DMR vocoder PCM buffer, 160 B / 10 ms, read by the codec over AHB, irq 27 | V-doc (GUIDE §7.1.2.2) |
| `0x18000808–0x1800081F` | AT1846S bandwidth-profile register list (file `+0x322E8`) | V-static (11 §21.2) |
| `0x18000848` | a few bytes moved by `0xB07C`'s target | V-static (RES "FW45-D2") |
| `0x18000858` | interrupted-task SP saved by the common ISR | V-static (this chapter, §3.6) |

FW23–FW25 played into `0x180000A0` from opcode 13 at idle; FW25 settled that the DAC's idle playback never reaches the phone (CL §1; RES "FW25"). V-bench.

### 1.3 AT1846S

**Identity and access.** Write = IRAM `0x2B220` (file `+0x54628`, flat call target `0xFD011220`, 196 call sites): sends `[reg, value_hi, value_lo]` to device byte `0xE2` (7-bit `0x71`). Read = IRAM `0x2B25C` (file `+0x54664`, flat `0xFD01125C`, 28 sites). `at1846_init` (`+0x2BAC`) writes the Auctus start-up sequence register for register as OpenGD77's and DMRtastic's drivers do (11 §21.1). V-static. FW30's opcode 18 reads one register through the read entry on the bench (FW30B; RES "FW30").

**Functions that write it** (SYM; 11 §21.2; RES "T3 — AT1846S registers"; V-static):

| File offset | Name | Writes |
|---|---|---|
| `+0x2B14` | `at1846_apply_bw_profile` | 23 registers, list at SRAM `0x18000808` (`15 32 3A 3C 3F 48 60 62 65 66 7F 06…0F 12 7F`), values 46 B per profile from file `+0x36608`; r0 = 0 12.5 kHz / 1 25 kHz. A bandwidth profile, not calibration |
| `+0x2B4C` | `at1846_read_rssi` | reads `0x1B`, returns bits 15:8 |
| `+0x2BAC` | `at1846_init` | cold init (below) |
| `+0x2DD8` | `at1846_tune` | spur `0x05`, frequency `0x29`/`0x2A`, then the DMR branch or the FM branch at `+0x2FF2` |
| `+0x30A4` | `at1846_set_squelch` | `0x49` from two level bytes |
| `+0x3190` | `0x30` selector | one `0x30` write: `0x40A6` / `0x4026` / `0x70A6` / `0x7026` by argument and config byte 1 (1 = wide pair; argument 1 leaves bit 7 clear) (RES "Where `0x30` bit 7 and `0x58` bit 3 are written") |
| `+0x31E4` | `0x3A`/`0x30` sequence | reads `0x3A`, writes it `& 0x8FFF` (voice source off), sets `0x30` bit 11, writes `0x30` = `0x4006`, writes `0x3A` back |
| `+0x32E4` | `at1846_set_ctcss_dcs` | `0x4A–0x4E`, `0x3A` (`0x40C9`, `0x40CC`, `0x40D1`, `0x40CA`), `0x59` (`0x09A9`/`0x0C90`/`0x0910`), `0x58` (`0x8404` with a tone, `0x8405` without); `+0x3332` RMW `0x58 & 0xFFF7` (the mask word at `+0x333A`) |
| `+0x346C` | — | `0x41` = `0x4730` |
| `+0x61A8` | — | `0x44` = one byte of the table at `+0x36EE4` indexed by `0x38C70+0x10` (analog volume), ORed with `0x0700` |
| `+0x8E0C` | `set_tx_gain_reg44` | `0x44` bits 11:8 = body byte, low byte forced `0xFF`; most likely the `0x2A` MIC handler |
| `+0xA108` | — | `0x44` bits 11:8 from the table at `+0x383E4`, low byte `0xFF` |
| `+0xA150` | — | `0x41` bits 6:0 = caller byte |
| `+0xA16C` | — | `0x44` = `0x0FFF`, `0x41` = `0x4705` |
| `+0xB00C` / `+0xB048` | `at1846_rx_off` / `at1846_rx_on` | off: `0x30 & 0xFF9F` (bits 6, 5) then `& 0xFFFB` (bit 2); on: set bit 2, wait 10 ms, set bit 5 |

**Register reference.** Values are the immediates the factory image stores (V-static, 11 §21.1–§21.3, RES "T3", "R2"); meanings from the AT1846S programming guide and OpenRTX as cited in those sources (I where only one source names a field).

| Reg | Factory values | Meaning |
|---|---|---|
| `0x04` | `0x0FD0` (init) | clock; bit 7 "direct_reg" override of `dsp_resetn` (guide) |
| `0x05` | one of three spur values by frequency (thresholds 455.0, 466.0, 489.1 MHz …) | spur avoidance |
| `0x0A`, `0x13`, `0x31`, `0x34`, `0x54–0x57`, `0x5A`, `0x63` | init | start-up sequence |
| `0x0F` | per band | band select |
| `0x1B` | read | RSSI, bits 15:8 (`at1846_read_rssi`) |
| `0x1F` | `0x1001` | init |
| `0x29` / `0x2A` | per channel | frequency |
| **`0x30`** | `0x0001` (soft reset), `0x0004`, `0x40A4`, `0x40A6`, `0x4006`, `0x4046`, `0x4026`, `0x7006`, `0x7026`, `0x70A6` | bit 0 `soft_reset`; bit 2 `pdn_reg` (chip power); **bit 5 `rx_on`**; **bit 6 `tx_on`**; bit 7: set in `0x40A6`/`0x70A6` (the "wide muted" value); bit 10 `direct_reg`, never set; bit 11 set by `+0x31E4`; bits 13:12 bandwidth (`0x40xx` 12.5 kHz, `0x70xx` 25 kHz); bit 14 `xtal_mode` |
| `0x33` | `0x44A5` | init |
| `0x35` / `0x36` | never written | tone frequencies |
| `0x3A` | `0x00C3`, `0x00C9`, `0x04C3` (25 kHz profile), `0x40C3`, `0x40C9`, `0x40CC`, `0x40D1`, `0x40CA` | bits 14:12 `voice_sel`: 000 nothing, 100 microphone (never a tone) |
| `0x3C` | `0x0407`, `0x1930` (25 kHz) | bits 15:14 = 00 (microphone, per OpenRTX); other bits unnamed |
| `0x41` | `0x470F` (init), `0x4730`, `0x4705`; bits 6:0 from a caller byte | unnamed in our sources |
| `0x42` | `0x1036` (init, DMR), `0x1052` (FM) | constant per mode |
| `0x43` | `0x00BB` (init, DMR), `0x0100` (FM) | constant per mode |
| **`0x44`** | `0x07F7` (init), `0x0AD1` (tune), `0x0FFF`, table-driven writes; read back `0x07FE` after a volume write (RES "FW31") | bits 11:8 `gain_tx` (TX/mic gain), bits 7:4 DAC gain, bits 3:0 digital volume (guide); OpenRTX calls bits 7:0 the receive volume |
| `0x47`, `0x4F`, `0x53` | `0x7F2F`, `0x2C62`, `0x0094` | init |
| `0x49` | per channel | squelch thresholds |
| `0x4A–0x4E` | per tone | CTCSS/DCS |
| **`0x58`** | `0x8405`, `0x8404`, `0xBCFD` | audio filter switches (below) |
| `0x59` | `0x0B90` (init), `0x09A9`, `0x0C90`, `0x0910` | CTCSS/DCS related |
| `0x7F` | `1` around the page-1 AGC writes; also the first and last entry of the bandwidth-profile list | page select (page 1 = AGC table `0x06…0x12`) |

`at1846_tune` in detail (RES "T3"): `0x30` = `0x4006`, `0x4046`, `0x42`, `0x43`; DMR branch `0x30` = `0x4006` then `0x4026`, `0x44` = `0x0AD1`, `0x3A`, `0x3C` = `0x0407`, **`0x58` = `0xBCFD` at `+0x2E92`**; FM branch (`+0x2FF2`) `0x42` = `0x1052`, `0x43` = `0x0100`, `0x30` = `0x4006`/`0x4026` (or `0x7006`/`0x7026` wide), the bandwidth profile, **`0x58` = `0x8405` at `+0x3052`**, `0x44` = `0x0AD1`, `0x3A` = `0x40C3` (last write, at `+0x3074`).

**Register `0x58`, bit by bit.** Layout from OpenRTX's AT1846S driver; the openrtx.github.io web table gives a different layout and is wrong here (11 §21.3). Bench rows are V-bench (RES "FW17 / FW18", "UVm5 / UVm6 / UVm7", "UVm8 / UVm9"; 19 §15–§17; CL §1).

| Bit | Function | Bench |
|---|---|---|
| 0 | CTCSS low-pass bandwidth to 250 Hz | the CTCSS code toggles it (`0x8404`/`0x8405`) |
| 2 | set in every value; undocumented | — |
| 3 / 4 | bypass CTCSS high-pass / low-pass | UVm5 (`0x84DD`): no change at the low end |
| 5 | bypass voice low-pass (3.5 kHz) | UVm6 (`0x84FD` + mask `+0x333A`): flat 300 Hz–3.5 kHz on TX |
| 6 | bypass voice high-pass | did not open below 250 Hz (the cut is phone-side, §1.4) |
| 7 | bypass pre/de-emphasis | UVm2 (`0x84C5`): TX flat ±2 dB 300 Hz–3 kHz, the 3.5 kHz boost gone |
| 11 / 12 / 13 | bypass VOX high-pass / VOX low-pass / RSSI low-pass | UVm9 (`0xBCFD` on analog) exhausted the register |

| Value | Where | Reading |
|---|---|---|
| `0x8405` | init, FM tune, CTCSS set-up without tone (5 sites) | all filters on: the analog path |
| `0x8404` | CTCSS set-up with tone (3 sites) | analog with a tone |
| `0xBCFD` | DMR tune (1 site, `+0x2E92`) | voice HPF, emphasis, voice LPF, CTCSS filters bypassed |
| `0x84C5` | ours (`fm-flat-58`, UVm2) | emphasis off, voice HPF off, LPF on |
| `0x84FD` | ours (UVm6) | plus voice LPF off |

The register has no TX/RX split (11 §21.3). On receive, holding `0x58` = `0xBCFD` (op 6 variant 3) makes the phone's own receive audio flat: 50 Hz −0.6 dB, 100 Hz +1.2 dB, 3.8 kHz +1.7 dB against 1 kHz, where the plain path is −27.6 / −24.5 / −17.0 dB (RD10; CL §3 M17). Any channel write clears the hold, because `at1846_tune` writes `0x8405`. V-bench.

**Register `0x30` bit 7 on the bench.** After a symbol-engine key, `0x30` read `0x70A6` and the phone's receive RMS fell from 7055 to 1.5; a channel write restored `0x7026` and the audio (RES "FW31", the 4261 table). The close path writes `0x70A6` only when bit 3 of `0x38908` is set (FW30B, image 6 comment). So bit 7 behaves as a receive-audio mute on this radio (V-bench for the effect; I for the name).

**Register `0x44` on receive.** Op 6 variant 7 (FW27) wrote the low byte of `0x44`: `0x81` matched the stock curve, `0x41` doubled the receive-RAM curve including its ceiling, and the phone audio path followed it (−19.6 / −25.1 dB) (RES "FW27 variant 7"). V-bench. ("`0x41`" here is a value, not register `0x41`.)

**FW30 save area.** The symbol-key save stores registers `0x30`, `0x41`, `0x58`, `0x59` into `0x4B388…0x4B394` before the stock key and writes them back at the drop (FW30B `_SAVE_ASM`, `_RESTORE_ASM`). V-static.

### 1.4 ES8311 and the phone side

| Item | Fact | Status |
|---|---|---|
| Codec | Everest **ES8311** at I²C `7-0018` (`/sys/bus/i2c/devices/7-0018`, name and driver `es8311`); on both I2S links (`es8311 find, i2s1 codec dai_link`, `… i2s2 …`) | V-bench (19 §19, §20) |
| Clocks | I2S1 and I2S2 at **8000 Hz**, MCLK 1.024 MHz (`es8311_pcm_hw_params … lrck = 8000`) | V-bench (19 §19) |
| Routes | tinyserver (`/system/bin/tinyserver`, tinyalsa) names `I2S1_HD_Mux`, `I2S1_Out_Mux`, `I2S1_CH1 DL8_CH1` (TX out), `UL2_CH1 I2S2_CH1`, `UL2_CH2 I2S2_CH2` (RX in), `DAC DEM MUTE`; none is a filter | V-bench (RES "Phone route, read only") |
| App interface | RX audio arrives through `android.os.PrizeTinyService` as 8 kHz stereo 16-bit with L == R (mono duplicated); TX frames must be stereo-duplicated; SignalDeck writes TX PCM through `PrizeTinyService.writeFrame` | V-bench (CL §3a; RES "Phone route") |
| ALSA controls | DAC: `SDP MUTE`/`ROUTE`/`SRC MUX`, `DSM MUTE`, `DEM MUTE`, `OFFSET`, `RAMP RATE`; ADC: `MIC PGA GAIN`, `SCALE`, `RAMP RATE`, `INVERTED`, `SDP MUTE`/`ROUTE`, `FS MODE`; ALC, DRC; no high-pass control | V-bench (19 §20) |
| ADC high-pass | the ES8311 ADC has a register-only digital DC-removal HPF (`ADC_HPF`/`HPFS`, about `0x1B`/`0x1C`); receive-side candidate, not changed | I (datasheet, 19 §19) |
| Debug node | `es8311_debug/es8311` (root, rw); a write with count 0 is a register read to the kernel log; a non-zero count writes the codec. Owner decides any write | V-static on the kernel (19 §21) |
| What it does to audio | the ~9 dB dip at 400–600 Hz in the receive path is the ES8311 (the C7000 RX RAM is flat there); the transmit loss below ~250 Hz (about −40 dB, ~−60 dB at the low end) is the analog coupling between the ES8311 output and the module's microphone input; **module firmware cannot open the bottom octave** | V-bench (CL §1, §3 M17; 19 §19–§20) |
| `/dev/ttyS1` | carries no audio on the Armor (0 bytes in 6 s with receive audio flowing); the Xplore 1 module streams PCM there | V-bench (19 §20) |

**UART.** The phone's `/dev/ttyS0` at 57600, opened through the stock app's JNI `libinterphone_serial_port.so`; toybox `stty` cannot change its speed (CL §11). In the module, boot function `+0x5DEC` programs the DesignWare UART3 at `0x14090000` with divisor `(clock >> 4) / 57600`; the clock word at `0x32F90` is 6, 48 or 42 MHz chosen by two arguments; 48 MHz gives 57692 Hz (+0.160 %), and the same clock reaches 230400 at divisor 13 = 230769 Hz (+0.160 %) (RES "UART clock, read only"; V-static). Transmit: poll bit 1 of `base + 124`, write `base + 0` (11 §10.2). Op 16 (FW27–FW29) switched the rate to 230400 and back on the bench; FW30 made ops 16/17 answer sr=1 (FW30B comment; CL §3 M17). V-bench.

**`dmr009` GPIOs.** `pwd` 0 → 1 powers the module; the boot banner `开机初始化完成\r\n` (GBK, "power-on initialisation complete", 17 bytes from file `+0x3653C`) arrives more than 3 s after `pwd` = 1, and a `0x34` sent at +3 s got no reply (`docs/standalone-app-evaluation-followup.md`, cold-start table; RES "R3 — built, loaded twice"). The update knock uses both lines (§4.1). V-bench.

### 1.5 Where to look in the HR-C7000 user guide

| Topic | GUIDE section, page |
|---|---|
| Boot modes | §2.3 p. 34; §4.5.4 p. 89–90 (Figure 18 boot flow) |
| Address map | §4.5.3 Table 26 p. 89 |
| Baseband work modes (WORK_MODE values) | §4.6 Table 27 p. 91–92 |
| Baseband control registers (`0x70…0x3B0`) | §4.6.4 p. 94; §4.6.5.1–§4.6.5.15 p. 95–105 |
| Interrupt controller, source list | §4.7 p. 105–107, Table 30 p. 106 |
| UART registers | §5.4.5 p. 163–169 |
| I2C | §5.1 p. 132 |
| Codec | ch. 6 p. 244–268 (registers §6.5 p. 253) |
| Audio paths: DMR TX/RX | §7.1.2 p. 269–270 |
| Audio paths: FM TX from codec ADC / from TX RAM | §7.2.2.1.1–§7.2.2.1.2 p. 271 |
| FM RX, FM recording (RX RAM) | §7.2.2.2–§7.2.2.3 p. 271 |
| RF interface (DAC TX, ADC RX) | ch. 8 p. 272–276 |
| FM registers | §11.2 p. 331–339 |
| FM interrupt sub-types | §11.3 p. 339 (Table 56) |
| FM TX / RX RAM maps | §11.4 p. 340 (Tables 57, 58) |
| SQL, CTCSS, CDCSS, DTMF, SELCALL | §11.5–§11.9 p. 340–350 |

---

## 2. Memory map

### 2.1 The image file

| Item | Value | Status |
|---|---|---|
| File | `radio_firmware/DMR003.UV4T.V022-ORIGINAL.bin`; the stock app's updater asset `assets/DMR003.UV4T.V022.bin` (LS) | V-static |
| Size | 378,620 B (`0x5C6FC`) | V-static (11 §1) |
| MD5 | `4426035392262ca54583c230c9e268e0` | V-static (11 §1) |
| Content | plaintext, no compiler banner, no signature, no image checksum found; entropy 6.97 bit/byte | V-static (11 §1, §9; 19 §13.3) |
| First words | `0xC001112C 0x11EC6420` = C-SKY `lrw r1` / `mtcr r1, cr<0,0>` / `lrw r7`: reset code, not a vector table | V-static (this chapter, §3.2) |
| RTOS | uC/OS-III; task and kernel names in plain text | V-static (11 §2) |

### 2.2 Copy records and runtime regions

The reset code reads three-word records `(destination, end, source)` from the literal pool at `+0xC4` and a BSS range after them (RES "The copy at boot"; V-static, re-read for this chapter):

| Pool | Words | Meaning |
|---|---|---|
| `+0xC4` | `0x18000800, 0x18004404, 0x0304C2E0` | SRAM init data: 0x3C04 B from file `+0x322E0 … +0x35EE3` |
| `+0xD0` | `0x00010000, 0x00031AF4, 0x03053408` | IRAM code: 0x21AF4 B (137,972) from file `+0x39408 … +0x5AEFB` |
| `+0xDC` | `0x00031AF4, 0x0004DAB0` | IRAM `.bss`, zeroed |

No length field and no checksum: the copy is `ld.w`/`st.w`/add 4 until the end, and a changed IRAM byte boots (R301) (19 §23; RES "R3-0 / R3a1"). V-bench.

| Runtime range | Content | Status |
|---|---|---|
| `0x03000000–0x03019FFF` | vendor bootloader in SPI flash, outside the image | I (19 §13.1, AtomXL sibling) |
| `0x0301A000–0x030766FB` | the whole image in XIP flash (code + constants run here; the IRAM and SRAM parts are also present here as their load images) | V-static |
| `0x00010000–0x00031AF3` | IRAM code: RTOS, drivers, AT1846S I/O, the modem service code, the vector table at its start | V-static |
| `0x00031AF4–0x0004DAAF` | IRAM `.bss` (zeroed at boot) | V-static |
| `0x0004DAB0–0x0004EAAF` | ISR stack (the common ISR loads SP `0x4EAB0`) | V-static (this chapter) for the SP; I for the extent |
| up to `0x00050000` | initial SP set by the reset code (`r14` = `0x50000`) | V-static (this chapter) |
| `0x00050000–0x00057FFF` | IRAM the image does not name | I |
| `0x18000800–0x18004403` | SRAM initialised data | V-static |

IRAM size: GUIDE Table 26 gives `0x10000–0x57FFF` (288 KB); 19 §13.2 says "0x10000…0x50000 (256 KB)", which is the image's use, not the chip's (§6).

### 2.3 File layout

| File range | Content | Status |
|---|---|---|
| `+0x0000–+0x0077` | reset code (§3.2) | V-static (this chapter) |
| `+0x007C–+0x00AD` | exception stubs: `jmp r15`, `br .` loops, `rte` at `+0x8C`, a trap that rewrites `cr<2,0>` and `rte` at `+0xA2–+0xAC` (targets of vectors 1–31) | V-static (this chapter) |
| `+0x00B0–+0x00E3` | reset literal pool incl. the copy records at `+0xC4` | V-static |
| `+0x00E4–+0x322DF` | flash code: application (handlers, AT1846S driver, modem set-up) | V-static |
| `+0x322E0–+0x35EE3` | SRAM initial data (incl. the AT1846S register list `+0x322E8`) | V-static |
| `+0x35EE4–+0x35FE3` | **256-byte count-leading-zeros table** (`08 07 06 06 05×4 04×8 03×16 02×32 01×64 00×128`), read at XIP `0x0304FEE4` by IRAM code at `+0x39890` (`ldr.b`, then `+8`) and `+0x399B4`, i.e. the kernel's priority/bit lookup | V-static (this chapter) |
| `+0x35FE4…` | string pool: kernel task names (`uC/OS-III Idle Task` at `+0x35FE4`, …), newlib errno table (`+0x355xx`), application strings, task names `sysint…encrypt` (`+0x3657C–+0x365C8`), banner (`+0x3653C`), `PttTask` (`+0x36534`), `task init` (`+0x36550`) | V-static (11 §2; this chapter) |
| `+0x36608` | AT1846S bandwidth profile values (46 B × 2) | V-static (11 §21.2) |
| `+0x366B2` | CTCSS table, 50 × LE16 centihertz, 67.00–254.10 Hz | V-static (11 §18) |
| `+0x36EE4` | analog volume → `0x44` table | V-static (RES "T3") |
| `+0x380D8` | `0x21` family jump table (XIP `0x030520D8`) | V-static (11 §14.1; this chapter) |
| `+0x38240–+0x383AB` | phone-protocol jump table, index `cmd − 0x22`, 105 words (XIP `0x03052240`) | V-static (this chapter, §2.6) |
| `+0x383E4` | `0x44` TX-gain table | V-static (RES "T3") |
| `+0x38464–+0x38474` | version string `DMR003.UV4T.V022\0` (+ 3 NULs) | V-static (11 §21.4) |
| `+0x39408–+0x5AEFB` | IRAM load image; starts with the vector table (§3.6) | V-static |
| `+0x5AEFC–+0x5C6FB` | **zero tail, 6,144 B (`0x1800`)**: not copied anywhere, runs only from XIP (`0x03074EFC…`) | V-static (this chapter; RES "FM refill interrupt"; ONB §3) |

The zero tail is 6,144 B. Several sources say 1,788 B; that is only the length over which 11 §1 measured entropy 0 at the very end of the file (`+0x5C000…`), not the extent of the padding (§6).

### 2.4 Where added code may go

**The rule.** New code and data go only into the zero tail `+0x5AEFC … +0x5C6FB` and never at or past `+0x5C6FC`, so the file size and every factory offset stay the same (ONB §3, "owner rule"; HO 2026-10-26/27 tasks: "never past `0x5C6FC`"). The YModem image is the file; the stock app and SignalDeck's loader check the size (19 §4 B1; LS "Unlisted images": size must equal 378,620 B). V-static for the size check in the rules; the bootloader itself rejects nothing (§4.4).

**Why only there.**
- IRAM-copied bytes are patchable (R301) but run from IRAM, so a hook there needs a runtime-PC `bsr` (19 §22–§23).
- The bytes at `+0x35F64` look free (zeros) but are the second half of the CLZ table (index ≥ 128 → 0); R4l put a thunk there and the module never answered `0x34` (RES R4l; HO; SYM `data_table_tail`). FW30 and later builds refuse to change `+0x35DF4 … +0x35FE3` (FW30B `kept`). V-bench + V-static.
- Stub space is not free just because it is zero or because no branch names it. FW27 overwrote a literal pool at `0x5BE60` that the key helper loaded with `lrw`, and the module stopped keying; rule: a reclaimed range must contain no literal that outside code loads (CL §3 M17; `tools/fw-patch/literal_guard.py` docstring). FW50 overwrote `0x5B700–0x5B71F` (the tone-queue pitch helper, reached in a way the guard does not trace) and FT8 came out at 7.5 kHz; FW52 overwrote the live unkey at `0x5B74C–0x5B755` and DMR group slot 0 went silent (ONB §4, §9). V-bench.

**State of the tail (FW54 lineage).** MAP54 lists the roots into the tail (`0x5AEFC` from the dispatch word at `0x382B8`; outside branches to `0x5B4D0`, `0x5B580`, `0x5B614`, `0x5BDAA`, `0x5C040`, `0x5C4C8`, `0x5C4E2`, `0x5C518`; the pitch helper `0x5B700`) and only two free ranges in FW54: `0x5B65A–0x5B68F` (54 B) and `0x5B6A0–0x5B6F7` (88 B). This is work in progress by another agent (untracked file, `tools/fw-patch/space_map.py`); treat a later map as authoritative. Earlier free-space marks in SYM (`fw25_free_tail` `0x5C464`, 664 B after FW25; FW26 at `0x5C464–0x5C54B`; FW27 `0x5C54C–0x5C590`) describe those images only.

**Never-written guards in the build chain** (V-static, the scripts): every `patches.toml` site records the original bytes and `build.py` refuses on a mismatch (RM workflow); `literal_guard.py` (`covered_loads`, `covered_branches`, `never_written`) refuses a patch that covers a literal or branch target used from outside (ONB §4); FW30-era builds check that the gate compare, the hole and the pool are what they expect before writing (FW30B `build()`).

### 2.5 Version string and tag scheme

`0x34` is answered by `cmd34_version_reply` (`+0xA7E8`), which copies 17 bytes from XIP `0x03052464` (pool word at `+0xA9E8`) = file `+0x38464` and replies through `+0x90B0` (11 §21.4; SYM). So the module reports the string of the image in its flash. V-static + V-bench (FW14, 19 §14).

| Bytes | Factory | Tag field |
|---|---|---|
| `+0x38464–+0x3846A` | `DMR003.` | fixed |
| `+0x3846B–+0x3846E` | `UV4T` | **the four-character tag** |
| `+0x3846F–+0x38473` | `.V022` | fixed |
| `+0x38474` | NUL | terminator (`+0x38475–+0x38477` also zero) |

FW14 changed two bytes at `+0x3846D` (`4T` → `m1`) to make `DMR003.UVm1.V022` (19 §14); current builds write the whole 16-character string with a new tag, e.g. `DMR003.FW30.V022` (FW30B `TAG`). Tags in use: `UVm1…UVm11`, `R3a0…R4t0`, `RC40`, `RD10`, `FW19…FW55`, diagnostic `F44D`, `F48L`, etc. (RES headings). The string is the identity the loader checks after every load (§4.6); the field is four characters, so R3a10 had to be tagged `R3b0` (STUB c7000_txram_dmr_sine). V-bench.

### 2.6 Dispatch tables (in flash)

`phone_dispatch` (`+0xAA3C`) validates the frame (length BE `buf[6..7]` < 800, head `0x68`, tail `0x10`, checksum) and does `ldr.w r3, (0x03052240 + 4·(cmd − 0x22)); jmp r3` for `cmd − 0x22 < 105` (11 §14.2). The table is **in the image** at file `+0x38240` (XIP flash, read-only): word 0 (`0x22`) = `0x03024BEA` (file `+0xABEA`), … word `0x1E` (`0x40`) = `0x03024A54` (file `+0xAA54`, an empty `pop r4-r8, r15`), the same for `0x41` (V-static, this chapter; SYM `phone_dispatch_table`, `cmd40_factory_empty`; RES "FW55 first channel write": the `0x22` pointer `0x03024BEA`). Each entry points at a short inline case (`+0xAAC8…+0xABF2`) that calls the handler with `r0` = the frame. Our images redirect slot `0x40` (word at `+0x382B8`) to `0x03074EFC` = file `+0x5AEFC` (19 progress log R4m). `0x3D` is a real factory handler (`+0xAAFE`) and is left alone (SYM; LS).

The `0x21` family table at `+0x380D8` (XIP `0x030520D8`) holds 35 entries for `family21_dispatch` (`+0x8BE4`); its first words are `0x03022C10`, `0x03022C6A`, `0x03022C78`, … (V-static, this chapter).

### 2.7 RAM variables

All are IRAM `.bss` unless marked SRAM. "Factory" = used by the stock image; "ours" = introduced by a patched image in otherwise unused `.bss`. Status V-static unless marked.

**Factory variables**

| Address | Width | What | Source |
|---|---|---|---|
| `0x3244C` | object | ack/reply object: `0x8E7C` fills offsets 0–3 and 6–8 | RES "`0x32457` writers" |
| `0x32457` (= `0x3244C+0xB`) | byte | **channel-write busy flag**: set to 1 at the start of `0x22` (`0x9336`) and `0x23` (`0x99D6`); 0 on every reject tail; the long success returns leave 1; the idle task at `0x63C` clears it at `0x6BE` only when the countdown `0x38908+0xB` lands on 100, `+0xA` ≠ 0, `+0xD` ≠ 1, bit 0 of `0x38908` clear and the word at `0x32458` = 0. Readers: `0x15C`, the `0x26` wait at `0x9278` (80 passes, then sr 1 and no key), `0x39DA` (FmRecv), `0x9E70`, `0xA392`. Leading suspect for the first-DMR-key-after-a-write miss | RES "`0x32457` writers", "FW40 probes", "FW55 first channel write"; ONB §5 |
| `0x32458` | word | set to 1 by a symbol-mode `0x26` key (`0x92DE`), 0 by its unkey (`0x92F8`) | RES "FW40 probes" |
| `0x32520` | word | **`RF_MODE` save slot** of the stock FM key-up (`+0x3ECCC` save, `+0x3EE74` restore; restore called from `0x3D73C` and `0x3F0F0`) | RES "FW37" |
| `0x32F90` | word | UART input clock (6 / 48 / 42 MHz) | RES "UART clock" |
| `0x34808` | struct | modem/service state: byte 0 selects the per-wake branch at `0x18B5C`/`0x18B68`; byte 1 ≠ 0 enables the `0x1E07F` mask path and the bit-13/15 side path; byte 2 = 4 selects `WORK_MODE` `0x16A`; byte `0x12` = 2/3 sets `tx_voice_source` | RES "FM refill interrupt", "R2", "Factory stores" |
| `0x38848` | object | semaphore the sysint task pends on (type word `SEMA`); posted by `+0x54BB0` | RES "FM refill interrupt" |
| `0x38874` | byte | mode byte the `0x26` handler tests: 0 = plain FM key/unkey path (`0x929C`, `0xE9C(0, 1)`); ≠ 0 = the path the bench calls "symbol-mode" (`0x92C8/0x92E0/0x92F2`); also written by the boot-path routine at `+0xE4` | RES "FW40"; this chapter (`+0x10E`) |
| `0x38875` | byte | **key-state byte**: `0xE9C` stores its `r1` here when `0xE64` returns 0 | ONB §4; RES "FW48" |
| `0x3887A` (= `0x38874+6`) | byte | 1 = the prelude at `0x2AF24` skips the synthesizer lock wait on `0x44000004` bits 31/30 | RES "FW39", "`0x32457` writers" |
| `0x38908` | byte + block | **state byte**: bits 0 and 2 = TX active (the time-out counts only while one is set); bit 1 used by the idle task; bit 3 = receive audio open (the close writes `0x70A6` only when set); bit 5 = status reported by `0x9E24`. `+6/+7` halfword countdown (routine at `+0xE4`, stores `0x38874` when it reaches 1); `+8` mode byte (`0x11E0`); `+0xA` "A" and `+0xB` "B" (countdown 200 → 100) of the deferred busy clear; `+0xD` "D" (symbol-mode key flag). `0x38912`/`0x38913` are `+0xA`/`+0xB` | REV "Review of FW19"; RES "FW40 probes"; FW30B; 11 §14.2 |
| `0x38AB0` | 169 B | image returned by `0x39` (QUERY_MIX) | 11 §14.2 |
| `0x38B5C` | 176 B | channel/mode block copied by `0xE64`'s target; `+3` = 1 on the analog path (`0x61F4` then stores `GCR_ADCL` `0x89`); `+0xAE` (`0x38C0A`) = mode byte: 3 makes `0xE64` non-zero so `0xE9C` skips its store; boot (`0xBC6`) and `0x8F10` store 1, `0x8EE2` stores 3 | REV FW48 reviews; RES "FW48"; STUB c7000_fm_adcgain |
| `0x38C64` | 6 B | **time-out**: `+0` enable, `+1` tot in seconds, `+2..5` 32-bit count compared with `100 × tot`; `0x3B` (`+0xA308`) stores the byte, 0 clears the enable; `+0x264` sets enable 1, tot 120 | REV "Review of FW19"; CL §3 |
| `0x38C70` | 19 B | last analog channel body (returned by `0x25`; `+0x10` = volume index) | 11 §14.2–§14.3; RES "T3" |
| `0x38E4C` | 163 B | last digital channel body (returned by `0x24`) | 11 §14.2 |
| `0x38EF0` | byte | flag byte: bits 0/1 set by a mode-toggle command; bit 0 also set by `status_post` | 11 §14.2; SYM `status_post` |
| `0x38EF2` | byte | status mailbox (`status_post` `+0x7E08`: 3 = SEND_START, 4 = SEND_STOP; sent as `68 36 <byte>` by `+0x7BC0`) | SYM |
| `0x390D4` | object | semaphore (type word `SEMA`) used through `0x1924` by `0xE9C`; fields `+0x10` halfword and `+0x24` (0 → `0x765` after a leaky symbol key, FW44–FW45) | RES "FW45-D2"; REV; ONB §4 |
| `0x39124` | object | lock object taken by the `0x22`/`0x23` handlers (`bsr 0x18E8`) | RES "`0x32457` writers" |
| `0x4031C` | byte | gates the `0x390D4` wait | RES "FW45-D2" |
| `0x47308` | table | interrupt handler table indexed by vector − 32 (§3.6) | this chapter |
| `0x4C7E0` | word | the sysint task's saved `SYS_INTERP_LIST` | RES "FM refill interrupt" |
| `0x4B398` | — | first factory-named word after our `0x4B3xx` words | SYM `fw26_flag` |
| SRAM `0x18000858` | word | interrupted-task SP saved by the common ISR | this chapter |

**Our variables** (in `.bss` gaps the factory image never names, chosen after a literal scan; boot zeroes them, so every one reads 0 = idle at power-up)

| Address | What | Introduced |
|---|---|---|
| `0x4A3E4` | symbol ring write count | sym engine (R4p+) |
| `0x4A3E8` | next symbol base | sym engine |
| `0x4A3EC` / `0x4A3F0` / `0x4A3F4` | phase / underrun count / last error | sym engine |
| `0x4A3F8` | op 5 return scratch and first reply header | sym engine |
| `0x4A400–0x4ABFF` | **symbol ring**, 2048 signed bytes; also op 5's six 512-B capture halves `0x4A400 + 512·i` (to `0x4B000`) | STUB c7000_cmd40_sym. Older stubs used `0x4A400` as a 1500-sample waveform buffer (count `0x4A3E4`) and `0x4A800` with count `0x4A7F0`/end `0x4A7F4` (STUB c7000_cmd40_m17, _host) |
| `0x4AC00` | op 4 render scratch | sym engine |
| `0x4AE00` | op 4/5 reply frame | sym engine |
| `0x4B000` | `WORK_MODE` saved by op 6 hold | sym engine |
| `0x4B004` | `FM_BANDWIDTH` saved by op 6 variant 4 | sym engine |
| `0x4B008` | **hold marker**: `0x484F4C44` ("HOLD") while op 6 holds; op 5 then returns sr=1 | sym engine |
| `0x4B00C` | "last" flag armed by op 7 | sym engine |
| `0x4B010` | FW20 drain countdown (8 half interrupts; > 8 = idle) | STUB c7000_fw20_gate |
| `0x4B014–0x4B053` | FW21 mode word and tone counters (16 words cleared by op 3); `0x4B02C`, `0x4B030` among them | `stubs/fw22_ext.S` `fw21_op3`; RES "FW39" |
| `0x4B044` | F44D diagnostic step word | RES "FW44" |
| `0x4B360` | end of the tone queue | SYM `fw26_flag` |
| `0x4B364` | promiscuous flag (op 15) | FW26 (SYM) |
| `0x4B36C` | FW27 UART-pend countdown | SYM `fw27_pend` |
| `0x4B380` | receive-stream bytes (FW27–FW29) | FW30B |
| `0x4B384` / `0x4B385` | FW31 one-shot flags (bit-2 clear / `0x30` bit-7 clear) | RES "FW31" |
| `0x4B388–0x4B397` | FW30 save area: AT1846S `0x30`, `0x41`, `0x58`, `0x59` | FW30B |
| `0x4D900` | FW48-L `0xE9C` call ring (8 slots); from FW52 the refusal latch (1 after an early host unkey; op 1 refuses; op 3 clears) | RES "FW48-L", "FW52" |
| `0x4DAAC` | **cursor / symbol-active flag**: 0 = idle (boot), otherwise our TX-RAM path is armed; the factory image has no literal of it | STUB c7000_txram_m17_lich5; ONB §4 |

`0x32680` / `0x32684` (FW40 key-start saves of `WORK_MODE` and a second word, read `0xEE` / `0x5F`) are in the factory `.bss` range; no factory literal of `0x32688–0x3268B` exists (RES "FW41-D2"). Whether `0x32680–0x32687` were unused by the factory image is not recorded; treat them as ours only in FW40–FW44 (§7).

---

## 3. Boot, tasks and interrupts

### 3.1 Before the application

1. **Mask ROM** (`0x00000000`): serial-download or SPI-flash boot; with no host it checks the flash flag and jumps through flash offset `0x04` (GUIDE §4.5.4 Figure 18; V-doc). The UART0 "boot upgrade" pins are a further fallback that needs hardware access (19 §13.1; I).
2. **Vendor bootloader** (flash `0x03000000–0x03019FFF`): an ST AN2557-style IAP menu, entered by holding PTT during power-up, takes `'1'` → `'C'` → YModem-1K and programs the application above itself (19 §13.1, from the AtomXL sibling `atomxl-re-docs/firmware-update.md`; I for this module, V-bench for the handshake, §4).
3. **Application** at `0x0301A000` = file `+0x0`.

Nothing in the application image implements the YModem receiver: no CRC table, no loader strings, no `'1'`/`SOH`/`STX`/`EOT` handling, nothing sends `'C'` (19 §13.1). V-static.

### 3.2 Reset code (file `+0x0`)

V-static (this chapter, factory listing `radio_firmware/fw1_csky_objdump.txt`; agrees with RES "The copy at boot"):

| Offset | Instruction | Effect |
|---|---|---|
| `+0x00` | `lrw r1, 0x80000100; mtcr r1, cr<0,0>` | PSR = `0x80000100` (supervisor; exceptions vectored) |
| `+0x06` | `lrw r7, 0x50000; mov r14, r7` | initial SP = IRAM `0x50000` |
| `+0x0A` | `lrw r7, 0x10000; mtcr r7, cr<1,0>` | **VBR = `0x10000`**: the vector table is the first word block of the IRAM copy (file `+0x39408`) |
| `+0x10–+0x2C` | `0xE000F000`: `+4` = 1, `+0` = 4, `+8` = `0x0300002D`, then set bit 0 of `+0` | I: CK803 cache set-up with a region at `0x03000000` (the flash window) |
| `+0x30–+0x44` | copy SRAM | §2.2 |
| `+0x46–+0x5A` | copy IRAM | §2.2 |
| `+0x5C–+0x72` | zero `.bss` `0x31AF4–0x4DAB0` | §2.2 |
| `+0x74` | `bsr` → IRAM `0x2AEB4` (file `+0x542BC`) | `main` (I for the name) |

`main` (`+0x542BC`) calls three init routines, clears a 0xE00-byte block at `0x3392C`, creates one task through `OSTaskCreate` (`+0x5431A` → IRAM `0x12F88` = file `+0x3C390`) with entry `0x0301AD5C` (file `+0xD5C`) and name `task init` (`0x03050550` = file `+0x36550`), then calls `+0x39E08` (I: `OSStart`). V-static (this chapter; RES "The copy at boot" names the same entry).

### 3.3 The init task (`+0xD5C`)

V-static (this chapter). In order (selected calls):

| Call site | Target | What |
|---|---|---|
| `+0xD9E` | `+0x5DEC` | UART3 set-up, 57600 (RES "UART clock") |
| `+0xDB6` | `+0x2BAC` | `at1846_init` |
| `+0xDE0` | `+0x1BF8` | `create_tasks` (§3.4) |
| `+0xDE4` | `+0x647C` | codec init (§1.2.4) |
| `+0xE2A–+0xE2C` | `+0x7DE8` with `r0` = `0x0305053C`, `r1` = 17 | **sends the boot banner** `开机初始化完成\r\n` raw on the UART (RES "R3 — built, loaded twice": "early init prints the banner from `+0x3653C` by the call at `+0xE2A`") |
| `+0xE5C` | `+0x18A4` | `delay_ms` |

The banner is the first thing the host sees after a power-up or a load; SignalDeck waits for it before the first command (CL §11; `docs/standalone-app-evaluation-followup.md`). An image that hangs before `+0xE2C` gives "no banner" (R3a0, R300) (RES R3, R3-0). V-bench.

**The boot-time key cycle.** The FM key-up path (`+0x3ECC0`) and the unkey through `+0x3D688` run during boot, before the banner and before any host `0x23` (19 §23, R3a0's six hook bytes ran before the banner). The factory boot cycle does not radiate at 467.625 MHz (24 s HackRF capture, peak +0.11 dB; RES "R3a2 — Factory boot, receive only"). Rule from it: any stub on the key-up path acts only on a host-requested transmission and does nothing at boot (RM; 19 §23). V-bench.

### 3.4 Tasks

`create_tasks` (`+0x1BF8`) first calls `+0x1818` three times and `+0x18BC` three times (one argument is the sysint semaphore `0x38848`; I: kernel object creation), then calls `OSTaskCreate` once per task with a name pointer in `r1`, the entry in `r2` and a 9-word argument block on the stack (memset by `+0x30568` first) (11 §13.2; V-static this chapter). The first stacked word is read as the priority (I; ch. 11 calls it `prio` 17–26).

| Name (string) | Entry (XIP or IRAM → file) | First stacked word | Notes |
|---|---|---|---|
| `sysint` (`+0x3657C`) | `0x03032A70` → `+0x18A70` | 18 | the `SYS_INTERP` service task (§3.6) |
| `txslot` (`+0x36584`) | `0x03032964` → `+0x18964` | 16 | |
| `rxslot` (`+0x3658C`) | `0x03032A48` → `+0x18A48` | 17 | |
| `rxcsbk` (`+0x36594`) | `0x0302F3A0` → `+0x153A0` | 23 | |
| `rxvoice` (`+0x3659C`) | `0x0302E9C8` → `+0x149C8` | 24 | |
| `txmsg` (`+0x365A4`) | `0x0302C9B8` → `+0x129B8` | 25 | |
| `rxmsg` (`+0x365AC`) | `0x0302DAF4` → `+0x13AF4` | 26 | |
| `decrypt` (`+0x365C0`) | IRAM `0x0002C8DC` → `+0x55CE4` | 19 | |
| (tenth; `encrypt` at `+0x365C8` is the likely name) | not decoded (the listing desynchronises at `+0x1F06`) | 20 | §7 |

Other tasks named in the image: `task init` (§3.2), `PttTask` (`+0x36534`), `cpchanscan` (`+0x365B4`) and the five uC/OS-III kernel tasks (Idle, ISR Queue, Tick, Stat, Timer) (11 §2). `OSTaskCreate` has 58 call sites (11 §13.2).

**Periodic application work** named on the bench (V-static, RES/REV citations):

| Code | What |
|---|---|
| `+0x1D8` | time-out timer: while `0x38C64` enable is set and `0x38908 & 5` is non-zero, the count at `0x38C64+2` increments per call and is compared with `100 × tot` (`movi r1, 100` at `+0x208`); past the limit it calls `0xE9C(0, 1)` when `0x38874` is 0, else `0xE9C(1, 1)`; with both TX bits clear it zeroes the count. HO calls this "the idle task at `0x1D8`" (REV "Review of FW19"; RES "FW43"; re-read for this chapter) |
| `+0x264` | time-out reset: count 0, enable 1, tot 120 (module default) |
| `+0x63C` | the task that runs the deferred busy-flag clear (`0x6AE` decrement, `0x6BE` clear) (RES "`0x32457` writers") |
| `+0x6B0–+0x900` | the "idle-task window" compared byte for byte between factory and FW55 (RES "FW55 first channel write") |
| `+0x7B0` | task whose status-4 path (`0x85A`/`0x85C`) stores A = 1, B = 200 after the TX-end delays; `0x7CC` stores A = 0 (RES "FW40 probes") |

### 3.5 Kernel services (IRAM)

V-static (this chapter) unless marked; names are uC/OS-III's by shape (I), the error codes match uC/OS-III's values.

| Flash wrapper | Calls (IRAM → file) | Behaviour | Name |
|---|---|---|---|
| `+0x18A4` `delay_ms` | — | sleeps `(r0 + 9) / 10` ticks (RES "FW40 probes") | OSTimeDly wrapper; I: 10 ms tick |
| `+0x18E8` `lock` | `0x11C44` → `+0x3B04C` | `(obj, ms)`: timeout `(ms + 9) / 10` ticks, returns the error word | OSSemPend / OSMutexPend wrapper (I) |
| `+0x1908` | `0x11C44` | same call with option `0x8000` | non-blocking pend (I) |
| `+0x1924` `unlock` | `0x12268` → `+0x3B670` | `(obj, opt 0, &err)`; the callee accepts options 0, `0x200`, `0x8000`, `0x8200`, returns 24101 for any other, and 24004 unless the object's first word is `0x414D4553` ("SEMA") | **OSSemPost** (uC/OS-III `OS_ERR_OPT_INVALID` = 24101, `OS_ERR_OBJ_TYPE` = 24004) |
| `+0x3C390` | IRAM `0x12F88` | 58 callers | OSTaskCreate (11 §13.2, §21.0) |
| `+0x304E8` / `+0x30568` | — | `memcpy(dst, src, len)` / `memset` | 11 §11.6, §13.2 |

### 3.6 Interrupts

**Vector table** (file `+0x39408` = IRAM `0x10000` = VBR; V-static this chapter): vector 0 = `0x0301A000` (reset); vectors 1–31 point at the flash exception stubs `+0x7E…+0xA0` (most are `br .`, vector 7 is `rte`); **vectors 32–95 all point at IRAM `0x10642`** (file `+0x39A4A`), the common ISR.

**Common ISR** (`+0x39A4A`): saves `r0–r13`, `r15`, `epsr`/`epc` on the task stack, stores the task SP at SRAM `0x18000858`, switches to the ISR stack `0x4EAB0`, calls `+0x39C94` (I: `OSIntEnter`), writes 4 to `0x17000010` (`PIC_COW1`, GUIDE §4.7.5), reads the vector number from `PSR[23:16]`, subtracts 32 and calls `handler_table[n]` from IRAM `0x47308`, calls `+0x39CB0` (I: `OSIntExit`), restores and `rte`. So interrupt source *n* is dispatched through `0x47308 + 4n`, filled at run time (I: by the drivers' install calls). V-static.

**The `SYS_INTERP` service** (RES "FM refill interrupt — bit 15"; V-static): `sysint` (`+0x18A70`) pends semaphore `0x38848`; each wake ORs `SYS_INTERP_LIST` into a stack word, writes it to `SYS_INTERP_CLEAR` until the list reads 0, saves it at `0x4C7E0`, then the dispatcher `+0x18B70` calls handlers for bits 0–6, 11, 12 and 16. **Bit 15 (`fm_tx_interp`) has no handler**; the factory image never refills TX RAM. The per-wake call sites are `+0x18B5C` (byte 0 of `0x34808` = 0; stock `bsr +0x18B70` = `0x03032B70`) and `+0x18B68` (byte 0 ≠ 0; stock `bsr +0x3D20`, which is `jmp r15`). The poster of `0x38848` is `+0x54BB0`, reached through a PIC slot no literal names; its neighbours `+0x54B6C`, `+0x54B8C` post the other two top-level lines and set bits in `INTERP_CLEAR`.

**Our TX-RAM half wake.** The symbol engine opens mask bit 15 at key-up and hooks the two per-wake sites: in FW19+ `+0x18B5C` → `0x5B4CA` (tail-calls the stock dispatcher while the symbol flag is clear) and `+0x18B68` → `0x5B4D0` (returns at once while the flag is clear; while it is set, fills the half `FM_ADDR_SW` names through the 5-phase RRC, counts underruns) (RES "The other three FW19 calls"; REV FW19 entry-point review; STUB c7000_cmd40_sym, c7000_txram_m17_eot1). The task entry `+0x18A70` is never patched. With the flag clear, the three pass-through stubs give the stock callees the same registers, return and stack (REV "Accepted", FW19). V-static + V-bench.

**Receive-RAM capture** (ours, ops 5 and 17): the FM RX RAM fills only after a `WORK_MODE` `0x80` store; a store every 8 halves kept every half at full amplitude for 45 s with 0 misses (CL §3 M17). V-bench.

---

## 4. The loader

### 4.1 Entering update mode

There is no UART "enter bootloader" command. The host releases the serial reader/writer, then knocks the GPIOs: `/sys/devices/platform/dmr009/pwd` down, 50 ms, `/ptt` down, 50 ms, `pwd` up, 1000 ms, `ptt` up (OEM `ReadFileUtils.setDmrUpdateCondition`, `ReadFileUtils.java` 120–141; 07 §2.1; LS "Reading session"). This is a power-up with PTT held. The sender then writes the byte **`0x31`** (`"1"`) and the module answers **`C`** (`0x43`). V-bench (every load since FW14; SignalDeck's own sender got the prompt 204 ms after a recovery knock, CL §1).

### 4.2 Transfer

Plain YModem-1K (07 §2.2–§2.5; LS "Reading session"; V-bench):

| Step | Phone sends | Module answers |
|---|---|---|
| Hello | `0x31` | `C` |
| Block 0 | 128-byte SOH block: `name\0<decimal size>\0`, no MD5 (`checkMd5` never set) | `ACK`, `C` |
| Data | STX, 1024 B, seq / ~seq, CRC-16-CCITT (poly `0x1021`, init 0, MSB first); a short tail is SOH, padded `0x1A` | `ACK` per block; `NAK` = resend |
| End | `EOT` (`0x04`), then a 128-byte empty block | `ACK` |
| Abort | — | `CAN` |

OEM timing: 15 s per block, 6 retries. The OEM `MD5_OK`/`MD5_ERR` branch never runs (replies longer than 2 bytes are ignored). SignalDeck's sender (`fw/YModemSender.java`, SignalDeck `4fc1989d`, 2026-10-25): erase 11.4 s, about 0.29 s per 1 KiB block, 248 s per load; about 148 s with the block pause at 0; nothing else may write to the port during a load; an abort at block 185 and a recovery were part of the five proof loads (CL §1). V-bench.

### 4.3 Where the blocks go, and persistence

The image is linked for XIP at `0x0301A000`; the IRAM cannot hold 370 KB; so the bootloader programs SPI flash at `0x0301A000` (flash `0x03000000 + 0x1A000`), and the transfer never covers `0x03000000–0x03019FFF` (19 §13.2; I by construction). **FW14 proved persistence** on 2026-10-23: the tag-only image `DMR003.UVm1.V022` survived two module power-cycles and a phone reboot, and the factory reload brought back `DMR003.UV4T.V022`, four loads all first-time `onSuccess` (19 §14). The older "RAM-only, reverts on power-cycle" belief (07 §3) was wrong. A patch stays in the radio until another image is loaded. V-bench.

### 4.4 Verification and write protection

- The bootloader checks nothing beyond the per-block CRC: no image checksum, no signature, no size rejection (07 §1.5; 19 §13.3; LS "Decision": "the bootloader verifies nothing, so the table hashes are the only guard"). V-bench for "accepts any same-size image"; I for "checks nothing at all".
- Whether the bootloader's own sectors are write-protected: unknown. The transfer does not address them (19 §13.3). I.
- The IRAM copy at boot has no checksum (R301) (§2.2). V-bench.

### 4.5 Restore and recovery

- **Restore = load the factory image** `DMR003.UV4T.V022-ORIGINAL.bin` the same way; a power-cycle does not restore (19 §14). V-bench.
- The receiver lives below the application and runs on the PTT-held power-up before any application code, so a crashed, hung or half-written application cannot block a reload (19 §13.5). Proven by SignalDeck's abort-and-recover load and by the wrong-tag drill that restored the factory image (CL §1). V-bench.
- What would break it: a bootloader that erases itself, a dead `dmr009` power/PTT line, hardware damage (19 §13.5). I.
- **Bench rule:** after any image that hung, held PTT or took a wild branch, load the factory image and key it once before the next bench image; a bench image that stops radiating with unchanged bytes gets the factory load first (CL §3 M17, the 2026-10-26 symbol-stream silence that only a factory load plus a key cleared). V-bench.
- Recovery order for a silent module: DIAG `restartmodule` + `0x34`; a module power-cycle; Restore (factory) (ONB §7).

### 4.6 Identity and the loader safety contract

LS is the contract SignalDeck's Module firmware page is built and reviewed against. Its core (V-doc for the contract, V-bench where marked):

- **Identity three ways, all matching one row of the known-image table:** (a) the module's `0x34` string; (b) the SHA-256 of the updater asset in the stock APK on that phone and the version string inside it; (c) the phone model plus the stock app's package and version. Any disagreement refuses the load and offers the device report.
- **Backup = the vendor copy from the user's own phone** (`Download/DMR/Firmware/factory-<version>-<sha8>.bin` with a hash sidecar, plus an app-private copy and the signed catalogue as further sources). A non-factory image is never flashed unless a hash-verified factory image for that module's version string is on the phone.
- **No patch set on an image we do not hold byte for byte and have diffed** against the one the patches were made on (variants: Armor `DMR003.UV4T.V022`, Atom XL `DMR006.U4A.V082`).
- **Pre-flight:** module answers `0x34`; not transmitting, no scan or data mode; stock app disabled; battery > 40 % and charging or > 60 %; image hash matches its row; factory backup present and verified; wake lock.
- **After every load:** module power-cycle, `0x34`, tag compared; mismatch or no answer → automatic factory restore and the check again.
- **Unlisted images** (owner switch, off by default, two confirmations, typed hash prefix): size must equal 378,620 B, a version string at the tag offset, every other guard kept (V-bench: six-item pass list 2026-10-25, CL §1).
- **Recovery mode:** a module that does not answer `0x34` but answers the update handshake may receive the factory image only.

The stock image has no flash read-back: `0x24`/`0x25` return the programmed channel, `0x21` is an event family, `0x3D` was read and copies nothing, and the YModem path has no read side (LS "Reading session"). So a stock module cannot be dumped before the first load. V-static.

### 4.7 Opcode 12: reading the flash back (ours)

From FW22 every bench image carries `0x40` opcode 12: a file offset and a length, offset + length ≤ 240 per request, the reply in the op-4 style. A whole-image read took 971 s at 57600 and was equal to the file (CL §1, §3 M17; LS "Read-back"). It proves the loader wrote what it was given and lets any bench-tagged module be dumped. It cannot recover a stock module's original. Opcode 14 (FW25+) reads RAM windows: `[0x18000000, 0x18010000)` at first, widened to `[0x30000, 0x50000)` for IRAM `.bss` on diagnostic images (RES "FW25", "Op 14 range check", "FW43"). V-bench.

### 4.8 Bench load paths

| Path | How | Status |
|---|---|---|
| Stock updater (Path A) | SignalDeck Hand back → push to `/sdcard/DMR/DMRDEBUG.bin` → `am start -n com.pri.prizeinterphone/.InterPhoneHomeActivity` (the stock `YModemManager` starts by itself when the file exists) → `onSuccess` → delete the file → Take over → `0x34` in the `RadioService: module …` log (`tools/fw-patch/bench/fwload_stock.sh`); the action-only intent opens a chooser on this phone | V-bench (19 §14) |
| SignalDeck's own sender (Path B) | DIAG `fwload` (`--ei pause 0`) and the Module firmware page; the signed catalogue from AndroidRadio_Firmware_Project since SignalDeck `7b3ded47` | V-bench (CL §1; RES "FW23") |

---

## 5. Toolchain and symbol files

### 5.1 Binutils

T-Head GNU binutils 2.27 for C-SKY ABIv2 in `C:\Users\Joshua\tools\csky-elfabiv2\bin` (from `Taixin-Semiconductor/XuanTie-CSKY-Toolchains`, `csky-elfabiv2-tools-mingw-minilibc-20250328.tar.gz`, SHA-256 verified; extract with Python `tarfile`, Git-Bash `tar` fails) (11 §12; memory note `csky-disassemblers-installed`). The same folder also holds `csky-abiv2-elf-*` (gcc 6.3.0, as, ld, …).

| Tool | Use |
|---|---|
| `csky-elfabiv2-objdump.exe -D -b binary -m csky -EL --adjust-vma=0 <image>` | the flat listing `radio_firmware/fw1_csky_objdump.txt` (~6.5 MB, base 0). Flash addresses are file offsets; IRAM targets show as `0xFCFF…`/`0xFD01…` (§0.3). `literal_guard.py` runs it without `-EL`/`--adjust-vma` |
| `csky-elfabiv2-as.exe -mcpu=ck803` | assembles stubs (FW30B `_linked`) |
| `csky-elfabiv2-ld.bfd.exe -Ttext=0x<file offset>` | links a stub at its file offset; `fw23_build.text_of` extracts `.text` (FW30B) |
| `csky-elfabiv2-nm` | symbol lists (ONB §3) |

**Encoding gotchas** (STUB headers; FW30B): gas emits `R_CKCORE_PCREL_IMM26BY2` for `bsr 0xFD011220` and ld drops the instruction, so every far `bsr` is written as raw halfwords and filled by the build script (`encode_bsr(at, target)`: `0b111000 << 26 | disp26`, displacement in halfwords from the instruction). `lrw r1` is based at the instruction, `lrw r3` at `(at + 2 + 3) & ~3` (`encode_lrw_r1`, `encode_lrw_r3`). `br` (32-bit) ±32 K halfwords (`encode_br`). Calls from XIP code into IRAM use the IRAM address (e.g. `lrw r6, 0x2B25C; jsr r6`). `bsr_target(blob, at)` decodes an existing site.

### 5.2 Ghidra

Ghidra 12.1.3 with the community C-SKY v2 processor module (`taligentx/ghidra_csky_WinnerMicro` v0.2, a fork of `leommxj/ghidra_csky`, `extension.properties` pinned to 12.1.3) in `C:\Users\Joshua\tools\ghidra_12.1.3_PUBLIC\Ghidra\Extensions\C-SKY`; language `CSKY_V2:LE:32:default`; JDK 21 at `C:\Users\Joshua\tools\jdk-21.0.12.1+1` (11 §12; `scripts/fw1_ghidra_csky.ps1`).

`scripts/fw1_ghidra_csky.ps1` (headless) imports the factory file with the BinaryLoader at base **`0x0301A000`** into project `radio_firmware/ghidra_project_fw0/DMR003_UV4T_V022_c7000` (gitignored), then runs, from `radio_firmware/ghidra_scripts/`:

| Script | Stage | Does |
|---|---|---|
| `FwCskyMapRegions.java` | pre | reads the `+0xC4` records, cuts the IRAM part off the flash block and maps it at `0x10000` with `.bss` to `0x50000`; maps SRAM at `0x18000800` (plus `0x18000000…`); adds uninitialised `modem` `0x11000000`, `modem_buffer` `0x16000000`, `apb` `0x14000000` |
| `FwCskySeed.java` | pre | seeds functions at `push16` prologues and the known anchors |
| `FwCskyImportSymbols.java` | post | applies `symbols.csv` (file offsets, translated to the region addresses) |
| `FwCskyStats.java` | post | counts |
| `FwCskyExportSymbols.java` | post | writes `symbols.export.csv` |

Analysis options: Aggressive Instruction Finder, Decompiler Parameter ID and Non-Returning-Discovered off (the module author's advice). Result: 1,213 functions / 114,099 instructions with the three-region import against 1,058 / 83,090 flat; string cross-references resolve (19 §13.4). `-BaseAddr 0x00000000` gives the old flat import. The `Fw0*.java`, `FindDMRBug.java` and `find_*_bug.py` scripts are ARM-era history (RM).

### 5.3 `symbols.csv` and `symbols.export.csv`

**Format.** CSV with header `offset,kind,name,comment`. `offset` is a **file offset** in hex (`0x0018A4`), except where the comment says otherwise (`0x0004B364`, `fw26_flag`, is an IRAM `.bss` address). `kind` is `fn` (function entry) or `label` (data, a patch site or a range mark). `comment` gives the role and the source chapter. Several rows mark free space in one image only (`zero_tail`, `fw25_free_tail`, `fw27_*`). `symbols.export.csv` is what `FwCskyExportSymbols.java` wrote from the Ghidra project: 44 rows, the subset of `symbols.csv` that existed at the last export (it lacks the 25 rows added from the R4/FW bench, e.g. `tx_launch_action`, `phone_dispatch_table`, `fm_keyup`, the FW26/FW27 stubs). `symbols.csv` is the master (V-static, compared for this chapter).

**The most important names** (SYM, with this chapter's additions marked *):

| File offset | Name | What |
|---|---|---|
| `+0x0000` | *reset | reset code, copy loops (§3.2) |
| `+0x00C4` | *copy_records | `(dst, end, src)` × 2 + BSS range |
| `+0x01D8` | *tot_timer | time-out count per wake (REV FW19) |
| `+0x0264` | *tot_reset | enable 1, tot 120 |
| `+0x063C` | *busy_clear_task | deferred clear of `0x32457` |
| `+0x0D5C` | *task_init | init task entry: UART, AT1846S, tasks, codec, banner |
| `+0x0E9C` | `tx_launch_action` | stock key/unkey behind `0x26` (`r0`, `r1`); stores `0x38875`; posts `0x390D4` via `0x1924` |
| `+0x18A4` | `delay_ms` | `(ms + 9)/10` ticks |
| `+0x18E8` / `+0x1924` | `lock` / `unlock` | semaphore pend / post wrappers (§3.5) |
| `+0x1BF8` | `create_tasks` | ten `OSTaskCreate` calls |
| `+0x2B14` | `at1846_apply_bw_profile` | 23-register bandwidth profile |
| `+0x2B4C` | `at1846_read_rssi` | reg `0x1B` bits 15:8 |
| `+0x2BAC` | `at1846_init` | AT1846S cold init |
| `+0x2DD8` | `at1846_tune` | per-channel apply; DMR `0x58` immediate `+0x2E92`, FM `+0x3052` |
| `+0x30A4` | `at1846_set_squelch` | `0x49` |
| `+0x32E4` | `at1846_set_ctcss_dcs` | `0x4A–0x4E`, `0x3A`, `0x59`, `0x58`; RMW at `+0x3332` |
| `+0x5DEC` | *uart_init | UART3 divisor for 57600 |
| `+0x5EF4` | `uart_put` | MMIO byte output at `0x14090000` |
| `+0x647C` | *codec_init | HR-C7000 codec boot set-up |
| `+0x7A30` | `apply_analog_config` | memcpy `0xB0` + modem MMIO |
| `+0x7BC0` / `+0x7E08` | `uart_status_sender` / `status_post` | `68 36 <byte>`; 3 = SEND_START, 4 = SEND_STOP |
| `+0x7C48` | `uart_rx_task` | waits for `0x68`; `0x20`/`0x0F` dropped, `0x21` → `family21_dispatch`, else `phone_dispatch` |
| `+0x7D94` / `+0x8E5C` | `checksum` / `checksum_wrap` | one's-complement BE words |
| `+0x7DE8` | `uart_send` | lock, `uart_put`, unlock |
| `+0x8BE4` | `family21_dispatch` | `0x21` sub-commands, table `+0x380D8` |
| `+0x8E0C` | `set_tx_gain_reg44` | `0x44` bits 11:8 |
| `+0x8E7C` | `ack_empty` | empty-frame ACK, cmd echoed |
| `+0x90B0` | `reply_build` | `68 cmd sr 00 ck ck len body 10` |
| `+0x92AA` | `cmd26_launch_bsr_sites` | the four `bsr +0xE9C` sites `0x92AA`, `0x92C8`, `0x92E0`, `0x92FA` (body 2, 1, 1, 2) |
| `+0x9310` | `cmd22_digital_unpack` | 163-byte digital channel |
| `+0x99B4` / `+0x9A2C` | `cmd23_analog` / `analog_unpack` | 19-byte analog channel |
| `+0x9E3C` / `+0x9E4C` | `cmd24_query_digital` / `cmd25_query_analog` | readback from `0x38E4C` / `0x38C70` |
| `+0xA308` | *cmd3b_tot | stores the time-out byte (REV FW19; PA) |
| `+0xA7E8` | `cmd34_version_reply` | 17 bytes from `+0x38464` |
| `+0xA808` | `cmd2b_caller_info` | 9-byte caller info |
| `+0xAA3C` | `phone_dispatch` | validate, `switch(cmd − 0x22)` |
| `+0xAA54` | `cmd40_factory_empty` | empty case: the free `0x40` slot |
| `+0xAAFE` | `cmd3d_handler` | real handler, keep |
| `+0xB00C` / `+0xB048` | `at1846_rx_off` / `at1846_rx_on` | `0x30` bits 6/5/2 |
| `+0x18A70` | `txram_refill_task` | the `sysint` task entry; never patched |
| `+0x18B5C` / `+0x18B68` | `txram_wake_site_a` / `_b` | per-wake hook points |
| `+0x304E8` / `+0x30568` | `memcpy` / `memset` | |
| `+0x35EE4` | *clz_table | 256-byte leading-zeros table (§2.3) |
| `+0x35F64` | `data_table_tail` | inside the CLZ table: not free |
| `+0x366B2` | `ctcss_table` | 50 tones |
| `+0x38240` | `phone_dispatch_table` | slot `0x40` at `+0x382B8` |
| `+0x38464` | `version_string` | the tag field `+0x3846B` |
| `+0x39408` | *vector_table | IRAM `0x10000`, VBR |
| `+0x39A4A` | *common_isr | IRAM `0x10642` |
| `+0x3B670` | *os_sem_post | IRAM `0x12268` |
| `+0x3C390` | `OSTaskCreate` | IRAM `0x12F88` |
| `+0x3D688` | `fm_unkey_path` | unkey after the boot-time key-up |
| `+0x3ECC0` | `fm_keyup` | FM key-up (IRAM; runs at boot): saves `RF_MODE`, stores `0x10E0`, `WORK_MODE` `0x80`, PTT 1, clears `tx_voice_source` at `+0x3EDF8` |
| `+0x542BC` | *main | IRAM `0x2AEB4` |
| `+0x54628` / `+0x54664` | `at1846_i2c_write` / `at1846_i2c_read` | IRAM `0x2B220` / `0x2B25C` |
| `+0x5AEFC` | `zero_tail` | start of the stub space; the `0x40` handler in our images |

### 5.4 `tools/fw-port/find_symbols.py`

`find_symbols.py <image> [--symbols symbols.csv] [--entries] [--switch]` finds the anchors a port needs in an HR-C7000 image and prints JSON: the version string, the command dispatch entries (`find_dispatch`), the jump-table switch so each command byte names its case and handler (`--switch`), handlers identified by behaviour (`0x3B` writes the time-out struct, `0x34` references the version string), the time-out timer and its struct, free flash runs for stubs (`find_free`, ≥ 512 B), and a comparison with a `symbols.csv` (`tools/fw-port/README.md`; function list read for this chapter). On the Armor (2026-10-24) it found the version string, 26 dispatch entries (8 on `symbols.csv` rows), the timer at `+0x208` with struct `0x38C64`, the `0x3B` handler `+0xA308`, the `0x34` handler `+0xA7E8` and the 6 KiB free run at `+0x5AEFC` (PA stage 2). It was validated on the Atom XL's `DMR006.U4A.V076` (2026-10-26; case bodies end `pop r4-r5, r15` instead of `pop r4-r8, r15`). `test_find_symbols.py` pins the Armor output to `testdata/`. The script proposes; a person confirms every row before a stub is linked against it (PA; fw-port README).

Note the timer address: PA records `+0x208`; REV and RES name `+0x1D8`. Both are right: `+0x1D8` is the routine's `push`, and `+0x208` is the `movi r1, 100` of the `100 × tot` compare inside it (V-static, this chapter).

### 5.5 `tools/fw-patch`

| File | Role |
|---|---|
| `patches.toml` | named patches: site, original bytes, replacement, why, measured_by (19 §5 C1) |
| `build.py` | factory image + chosen patches → tagged image + `.sha256`; refuses on any original-byte mismatch (RM) |
| `check.py` | attributes every changed byte of two images to a named patch |
| `fwNN_build.py` | the per-image builders since FW21 (each names its source image, `SRC`/the base path; ONB §9 "read SRC before reasoning about an image"); `fw30_build.py` holds the shared helpers (`bsr_target`, `encode_bsr`, `encode_br`, `encode_lrw_r1/_r3`, `_linked`) |
| `literal_guard.py` | refuses a patch that covers an `lrw` literal or a branch target used from outside the written span; runs objdump on the built image |
| `stubs/*.S` | stub sources; each header states its link offset, entry points, what it touches and why it is boot-safe |
| `test_*.py` | host tests (original bytes present, `0x26` sites, literal guard, per-image tests) |
| `bench/fwload_stock.sh` | the stock-updater load path |

Every built image lands in `radio_firmware/build/` (gitignored) and is reproducible from the factory file plus the scripts; released images go to the firmware home repository with a manifest (CL §1; RM).

---

## 6. Where the sources disagree

| Topic | One source | The other | Resolution |
|---|---|---|---|
| Size of the zero tail | RM ("the last 1,788 B of the file (`+0x5AEFC`)"), 19 §1 and §6 ("1,788-byte zero tail"), SYM `zero_tail` ("1,788 B of zero padding"), 11 §1 ("last 1788 bytes entropy 0") | RES "FM refill interrupt" ("zeros from `+0x5AEFC` through the end, 6144 bytes"), ONB §3 ("6144 B"), PA ("6 KiB free run") | **6,144 B** (`0x5AEFC–0x5C6FB`), re-read for this chapter. 1,788 B is the length 11 §1 measured at the end, not the extent |
| Where the jump tables live | 11 §14.2 ("the table itself is not in the image … filled by the external component"), 11 §14.1 and 19 §1 ("jump table in RAM `0x030520D8`", "the jump tables live in RAM") | SYM `phone_dispatch_table` (`+0x38240`); RES "FW55 first channel write" | Both tables are **in the image**, in XIP flash (`0x0305xxxx` = `0x0301A000 + offset`), re-read for this chapter. The old reading predates the memory map of 11 §21.0 |
| "External region", kernel not in the file | 11 §12, §13.2–§13.3; 19 §1 ("~25 call targets … not in the file") | 11 §21.0; 19 §13.4 | The targets are IRAM code inside the file (`+0x39408…`). 11 §13.3 carries a "superseded" note; 19 §1's table does not |
| "ROM" targets | RES "FW44", HO 2026-10-29 ("`0x1924` calls ROM `0xFCFF8268`", "`0xE64` calls ROM `0xFD01299C`") | RES "FW45-D2" (same night: "CPU `0x12268` … match file `0x3B670` (CPU + `0x29408`)") | IRAM code in the file, not ROM |
| What `0x1924` does | RES "FW45-D2", HO ("`0x1924` takes the semaphore at `0x390D4`", "a semaphore take") | SYM (`unlock`, "mutex release"); RES "FM refill interrupt" (`+0x3B670` "the post helper"); this chapter's reading (options 0/`0x200`/`0x8000`/`0x8200`, errors 24101/24004) | `0x1924` → `+0x3B670` is a **post** (OSSemPost shape). The bench effect (a key left `+0x24` changed and the next key blocked) stands; the mechanism wording "take" does not. The blocking call is more likely a pend elsewhere in `0xE9C`'s path (§7) |
| `0x32520`, `0x32680` called "SRAM" | RES "R2", "FW37", REV | memory map (§2.2) | They are IRAM `.bss`; SRAM is `0x18000000…` |
| IRAM size | 19 §13.2 ("`0x10000…0x50000` (256 KB)") | GUIDE Table 26 (`0x10000–0x57FFF`, 288 KB) | The chip has 288 KB; the image uses up to `0x50000` |
| `0x84C5` tested? | 11 §21.3 ("Not yet tested on the radio") | RES "UVm2" (2026-10-23) | Tested: emphasis off, TX flat ±2 dB 300 Hz–3 kHz; the < 250 Hz cut remains (phone-side) |
| Loads persist? | 07 §3, 19 front-matter rules ("RAM-load only … a power-cycle restores the factory image") | 19 §13–§14 (FW14) | Loads persist; 19 marks its own rule superseded |
| `0x21` table location | 11 §14.1 ("jump table in RAM `0x030520D8`") | §2.6 here | XIP flash, file `+0x380D8` |
| Time-out timer offset | PA (`+0x208`) | REV "Review of FW19", RES "FW19", HO (`+0x1D8`) | Same routine: entry `+0x1D8`, the ×100 compare at `+0x208` (read for this chapter) |
| `0x1D8` called "idle task" | HO 18:55, REV ("the idle task at `0x1D8`") | REV "Review of FW19" ("the timer at `+0x1D8`"); RES (`0x63C` is the task) | `+0x1D8` is the time-out routine; the task running the busy clear is `+0x63C` |
| `SYS_INTERP` bit numbers | GUIDE sub-interrupt list before §4.6.4 (p. 93–94: rows numbered 11–14 for `FM_TX/RX/SIG_RX`, `RDY_NEXT_SHORT_LC`) | GUIDE §4.6.5.9 p. 100 (bit 15 `fm_tx_interp`, 14, 13, 17) | The register description (bit 15) is right; the overview's numbers are row indices. RES uses bit 15, which is what the stubs set |
| `0x58` register layout | openrtx.github.io web table | OpenRTX driver, OpenGD77 comments, this image's CTCSS code (11 §21.3) | Driver layout, as used in §1.3 |
| `txram_refill_task` comment | SYM ("clears SYS_INTERP_LIST bit 15 (the TX-RAM half-empty interrupt) and copies no samples") | RES "FM refill interrupt" (writes the whole list to `SYS_INTERP_CLEAR`, no handler for bit 15) | Same conclusion (no refill); SYM's "clears bit 15" is narrower than the code |

---

## 7. Open questions

1. **The vendor bootloader.** Its code (flash `0x03000000–0x03019FFF`) has never been read; whether it validates anything, whether its sectors are write-protected, and whether a read command exists. Opcode 12 could dump it if its range check allowed offsets below the image (it takes file offsets today).
2. **Mask-ROM serial mode.** GUIDE Figure 18 shows write/read/download/jump commands in the ROM's debug mode; the protocol and how to enter it on this module (UART0 boot pins) are undocumented here.
3. **The I²C instance** used for the AT1846S (I2C0 or I2C1) and the driver's timing.
4. **The tenth task** created by `create_tasks` (entry and name; `encrypt` is the likely name) and the creators of `+0x63C`, `+0x7B0` and `PttTask`.
5. **Who calls the time-out routine `+0x1D8`** and at what rate (the "wake" the 100-per-second count assumes; measured as one second per unit, CL §3).
6. **The interrupt handler table at `0x47308`**: which driver installs which source; in particular the handler for source 29 (`System_inter`) and the PIC slot that reaches `+0x54BB0`.
7. **The wait inside `0xE9C`'s path** that blocks after a leaky symbol key (FW44–FW45): which pend it is, given that `0x1924` posts.
8. **`0x38874`**: what the byte means (the boot routine at `+0xE4` writes it; the bench calls its non-zero path "symbol-mode").
9. **`0x30` bit 7** and **`0x41`** of the AT1846S: names from the programming guide (bit 7 behaves as a receive mute).
10. **`0xE000F000`** writes in the reset code (I: cache region set-up) and **`0x44000004`** (synthesizer lock bits): neither is in GUIDE Table 26.
11. **`0x32680–0x32687`**: whether the factory image uses these `.bss` words (FW40–FW44 stored there).
12. **The busy flag `0x32457`** after a stock unkey and after the first `0x22`, on factory and on our image (ONB §5 item 2).
13. **Where DMR voice reaches the phone**: inferred to be the codec DAC lineout into the ES8311 input; not measured directly (FW25 showed the idle DAC playback does not reach the phone).
14. **The ES8311 ADC high-pass** (`0x1B`/`0x1C`): its setting on this phone is unread (owner decision for any register access).
15. **SRAM `0x18000000–0x180007FF`** besides the vocoder buffer: what else lives there.
