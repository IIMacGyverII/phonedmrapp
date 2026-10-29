# Atom XL module firmware DMR006.U4A.V076: static analysis (2026-10-28)

Read-only static analysis on the host. No phone, adb, serial port, HackRF or hotspot was touched. No image was built,
patched or loaded. Target: `AndroidRadio_Firmware_Project/firmware/unihertz-atom-xl/DMR006.U4A.V076/DMR006.U4A.V076.bin`
(358,100 B, SHA-256 `4f5f287b…4d40fe`). Reference: the Armor 26 Ultra's `radio_firmware/DMR003.UV4T.V022-ORIGINAL.bin`
(378,620 B) and `radio_firmware/symbols.csv`.

**Status of V076.** V076 is the copy kept on the vendor partition for the stock app's updater. The module in the
research Atom XL runs V067, and other phones report V080/V082. No address in this file may be used for an image that
is meant for an Atom XL until the running image is dumped and diffed against V076 (loader contract,
`radio_firmware/plan-loader-safety.md`).

Conventions:
- "File" = offset in the .bin.
- "XIP" = `0x0301A000 + file` for the flash part.
- "IRAM" = runtime address `0x10000 + (file − 0x34368)` for the IRAM part.
- Armor IRAM = `0x10000 + (file − 0x39408)`.
- Unmarked claims were read in the disassembly. *Inferred* marks a reading that was not proven.

Method:
- Each image was split into its flash part and its IRAM part, and each part was disassembled with
  `csky-elfabiv2-objdump -b binary -m csky -EL` at its true VMA (`0x0301A000` and `0x10000`).
- Functions were matched in four passes:
  1. normalized instruction hashes, with branch targets and pointer literals masked and constants kept;
  2. call-graph propagation;
  3. order plus similarity inside the gaps between anchors;
  4. call-site voting.
- Every row below that matters for patching was then checked by hand.
- `tools/fw-port/find_symbols.py --switch --entries` was run first; its results agree with this file.
- The scratch scripts are in the session scratchpad (`…\scratchpad\scripts\`) and are not part of the repository.

---

> **ROM search (2026-10-28 22:45, read-only on the PC):** the three Atom XL ROM images (`2021052010_…_seea`, `2023011016_…_stee`, `2023011018_…_seea`, `super.img`) each contain `DMR006.U4A.V076.bin` and its version string, and the same bridge image list ending at `20201016161541.bin`, the version the bridge runs. **No V067 image is in any of them:** `DMR006.U4A.V067` appears once, only inside a factory-test list (`DMR version … V067,V076,V080,V082`). So even the 2021 ROM shipped V076 for the module updater, which never ran on the research unit (`mDMRFirmwareDir:null`), and there is no V067 backup to restore. Loading V076 would be one-way until a flash read-back exists. **Any Atom XL firmware load is Grok's work (owner, 2026-10-28), with the owner's go.**

> **Owner's priority for firmware patches (2026-10-28 20:50), all phones:** 1. **M17** (symbol/tone engines on `0x40`, receive path), 2. **DMR promiscuous receive**, 3. the transmit time-out fix, lowest. If code space allows only one, it is M17.

## Summary

1. **SoC and layout are confirmed: the same HR-C7000 / C-SKY V2 start-up and the same scheme as the Armor.**
   - The first 0x74 bytes are byte-identical to the Armor's start-up.
   - Reset sets PSR = `0x80000100`, VBR = `0x10000` and SP = `0x50000`. It enables the cache for flash region
     `0x0300002D`, copies SRAM and IRAM, zeroes .bss, then calls IRAM `0x2ACFC` (main).
   - Only the copy-descriptor values differ (§1).
2. **The image starts at flash `0x0301A000`. It contains no bootloader.**
   - Flash `0x03000000–0x03019FFF` (the first 0x1A000 B) is outside the file.
   - The application never references that range, apart from the cache-region constant (§4).
   - Update mode is entered by the HAL, not by this image: module power-off, PTT held low, bridge in update mode,
     power-on, `'1'`, then YModem-1K. Nothing in the image checks the file (§4, §9).
3. **The UART command set is the Armor's, minus seven commands.**
   - V076 dispatches `0x22`–`0x3C` and `0x88` (jump table at file `0x33274`, 103 slots).
   - The Armor's `0x3D`, `0x3E`, `0x3F` (BER), `0x46`, `0x89` (3-byte ID setter) and `0x8A` (`set_tx_gain_reg44`)
     are gone.
   - Command `0x40` is a free slot on both images (§3).
4. **Several handlers were rewritten, not just relocated:** `0x22`, `0x23`, `0x26`, `0x28`, `0x29`, `0x2A`, `0x2C`,
   `0x38` and `0x3A`. Examples:
   - `0x38` (mix-check scan set) is a real 169-byte handler on V076. On the Armor it is a NAK.
   - `0x26` has no busy-wait and refuses with sr 1 while a flag is set.
   - `0x22` and `0x23` are refused while the radio is busy, and each one re-runs the full AT1846S init table (§3).
5. **The `0x3B` (time-out) handler acks with sr = 1 in both branches.** The Armor acks sr = 0.
   - It still stores the byte exactly as the Armor's does.
   - The start-up value is 120 s, the same as the Armor (file `0x258`).
   - The stock app never sends `0x3B` (§3, §6, §9).
6. **The band limit in the UART parser is UHF only.**
   - `0x22` and `0x23` accept rx/tx 400.000–490.000 MHz, inclusive.
   - The Armor's parser accepts 400–520 and 136–174 MHz.
   - The AT1846S spur table is UHF only as well (§6).
7. **The biggest functional difference: analog FM runs with the AT1846S filters bypassed.**
   - V076 writes AT1846S `0x58 = 0xBCFD` on DMR and on analog alike. `0x8405` appears only once, in the cold-init
     table, and is overwritten 9 entries later.
   - It writes no CTCSS/DCS registers (`0x4A–0x4E`) and no runtime squelch (`0x49`) to the AT1846S.
   - The analog audio chain, CTCSS/DCS and (*inferred*) squelch moved into the **HR-C7000 FM block**. V076 writes
     `FM_BANDWIDTH 0x11000500 = 0x5E` (band-pass and emphasis on), `FM_DEV_COEF 0x11000504` (12 sites) and
     `0x11000510–0x530`. The Armor never writes `0x500`, `0x504`, `0x520`, `0x528` or `0x530`.
   - There is a DCS code table at file `0x319C8` and no CTCSS centihertz table.
   - The Armor's `FmRecv` task does not exist on V076 (§6).
8. **The AT1846S driver is table-driven.**
   - Cold init (58 entries), the DMR tune and two analog tunes (12.5 / 25 kHz) are `{reg, 0, value16}` lists, with
     reg `0xFF` meaning "delay ms", at file `0x31578`, `0x31660`, `0x31744` and `0x316D8`.
   - The I²C wrappers moved from IRAM to flash: write file `0x28DC`, read `0x2934`. The Armor's are IRAM
     `0x2B220` / `0x2B25C` (§2, §6).
9. **Code similarity** (§7):
   - IRAM: 97 % of the Armor's IRAM instructions align equal. IRAM `0x10000–0x2ACF7` sits at **identical runtime
     addresses** in both images (373 functions). `OSTaskCreate` (`0x12F88`) and FM key-up (`0x158B8`) are among them.
   - Flash: ~80 % of the Armor's flash instructions align equal inside matched functions, but almost every flash
     function is relocated.
   - V076 lacks the Armor's newlib `strerror`/printf block and the AT1846S FM/CTCSS/`FmRecv` code. It adds the
     C7000 FM/CTCSS/DCS code.
10. **Unchanged, identical functions with known V076 addresses:**
    - `0x2B` caller info `0x9F38`, with the `reply_build` call at `0x9FC0` (FW26 patch D site);
    - `0x24`/`0x25`/`0x39` readbacks; `0x27`;
    - checksum `0x7740`, `reply_build` `0x8D90`, `ack` `0x872C`;
    - UART RX task `0x75F4`, with its pend call at `0x7602`;
    - the time-out tick `0x1CC`, identical logic to Armor `0x1D8`.
11. **Free space.**
    - There is a 6,144 B zero tail at **file `0x55ED4`–`0x576D3`** (XIP `0x0306FED4`). It is not copied to IRAM and no
      literal or pointer refers into it. It is the analogue of the Armor's `0x5AEFC`.
    - The 128 zero bytes at file `0x30E70` must not be used. They are the same data-table tail as the Armor's
      `0x35F64`, where code did not boot.
    - There is no other zero/0xFF run of 64 B or more in the image.
    - The jump table ends exactly where the version string begins (`0x33410`), so the table cannot be extended in
      place (§5).
12. **Status pushes are sent synchronously.** `0x36` status (file `0x77B4`) builds and sends the frame at once,
    waits 100 ms, then posts. The Armor posts to a sender task instead (§2).
13. **The version reply copies 16 bytes**, from XIP `0x0304D410` = file `0x33410` (`DMR006.U4A.V076\0`). The Armor
    copies 17. The image tag field is the **3-character** `U4A` at file `0x33417`; the Armor's is the 4-character
    `UV4T`.
14. **Host side.** The stock app and HAL build the `7E 96 69` envelope themselves; no host layer builds a `68…10`
    frame. Whether the bridge MCU translates is open.
    - In update mode every YModem byte travels inside route-00 command-`0x09` envelopes, and the HAL parses each
      bootloader byte out of a 12-byte envelope.
    - The stock app may flash any `.bin` it finds in `/sdcard/intercom/dmr/`, including when `0x34` times out (§9).
15. **Port outlook** (§8):
    - Patches tied to the AT1846S `0x58` (fm-flat variants, op 6 "hold") do not apply. Their V076 analogue is
      C7000 `FM_BANDWIDTH` bits 4/6 (file `0x346A`).
    - The symbol/tone TX engines (`0x40`), the promiscuous flag, the `0x2B` extension and the time-out ceiling have
      clear V076 anchors.
    - The `0x26` key/unkey path differs and must be re-derived.

---

## 1. CPU, SoC and memory layout

**ISA.** The image is C-SKY V2, the same as the Armor. The first 0x74 bytes (reset code) are byte-identical; file
`0x74` is the first difference, the `bsr` to main.

Reset code (file `0x0`–`0x76`):

| File | Instruction | Meaning |
|---|---|---|
| `0x00` | `lrw r1, 0x80000100`; `mtcr r1, cr<0,0>` | PSR |
| `0x06` | `lrw r7, 0x50000`; `mov r14, r7` | stack top `0x50000` |
| `0x0A` | `lrw r7, 0x10000`; `mtcr r7, cr<1,0>` | **VBR = `0x10000`** (vector table in IRAM) |
| `0x10`–`0x2C` | writes to `0xE000F000` (+4 = 1, +0 = 4, +8 = `0x0300002D`, then +0 bit 0 set) | CK803 cache set-up, region `0x03000000` (flash) |
| `0x30`–`0x44` | copy `[0x0304_7F90 …]` → `0x18000800 … 0x18003660` | SRAM .data, from **file `0x2DF90`** (0x2E60 B) |
| `0x46`–`0x5A` | copy `[0x0304_E368 …]` → `0x00010000 … 0x00031B6C` | IRAM code+data, from **file `0x34368`** (0x21B6C B) |
| `0x5C`–`0x72` | zero `0x31B6C … 0x4CF30` | IRAM .bss |
| `0x74` | `bsr` → IRAM `0x2ACFC` (file `0x4F064`) | main |

Copy descriptors (file `0xC4`–`0xE3`), V076 against the Armor:

| Region | V076 | Armor |
|---|---|---|
| SRAM dst | `0x18000800–0x18003660` | `0x18000800–0x18004404` |
| SRAM src (file) | `0x2DF90` | `0x322E0` |
| IRAM dst | `0x10000–0x31B6C` | `0x10000–0x31AF4` |
| IRAM src (file) | `0x34368` | `0x39408` |
| .bss | `0x31B6C–0x4CF30` | `0x31AF4–0x4DAB0` |
| IRAM copy ends (file) | `0x55ED4` | `0x5AEFC` |
| File end | `0x576D4` | `0x5C6FC` |

File regions (V076):

| File range | Content |
|---|---|
| `0x00000–0x2DF8F` | XIP code, run at `0x0301A000+` |
| `0x2DF90–0x30DEF` | SRAM init: AT1846S bandwidth register list at `0x2DF90` = SRAM `0x18000800`; semaphore names |
| `0x30DF0–0x34367` | XIP rodata: AT1846S tables, task names, jump table `0x33274`, version `0x33410`, DCS table `0x319C8`, DAC gain table `0x31EF4` |
| `0x34368–0x55ED3` | IRAM image: vector table at IRAM `0x10000`, uC/OS-III, drivers, modem code |
| `0x55ED4–0x576D3` | 6,144 B of zeros, not copied (free XIP flash, §5) |

**Vector table** (IRAM `0x10000`, file `0x34368`):
- It is identical in both images. Entry 0 is `0x0301A000` (reset).
- Exceptions go to stubs in `0x0301A07E…0x0301A0A0`, the `br .` loops and `rte` at file `0x7E`–`0xAC`.
- Interrupts go to IRAM `0x10642`.

**Kernel.** It is uC/OS-III, inside IRAM. These strings are at file `0x30EF0…0x310B0`: "uC/OS-III Idle Task",
"ISR Queue", "Tick", "Stat", "Timer". `OSTaskCreate` is IRAM `0x12F88` (file `0x372F0`), the same IRAM address as
the Armor's.

**Peripherals seen** (literal and `movih` bases):
- `0x1100xxxx`: the HR-C7000 modem block, including the FM block at `0x110005xx`.
- `0x1600xxxx`: the codec/TX-RAM block, `0x16000900`; the literal set is identical to the Armor's.
- `0x1402xxxx`, `0x1415xxxx` and `0x1003/0x100B/0x100F`: GPIO, UART and I²C class. These were not read further.

**Tasks** (OSTaskCreate call sites; names from pool words):

| Task | V076 entry | Armor entry | Note |
|---|---|---|---|
| task init | `0x0301AD5C` | `0x0301AD5C` | |
| timer10ms | file `0x630` | `0x63C` | |
| PttTask | `0x734` | `0x7B0` | |
| sysint | `0x171BC` | `0x18A70` | = Armor `txram_refill_task` |
| txslot | `0x170D8` | `0x18964` | |
| rxslot | `0x17194` | `0x18A48` | |
| rxcsbk | `0x13EFC` | `0x153A0` | |
| rxvoice | `0x13A80` | `0x149C8` | |
| txmsg | `0x11BD4` | `0x129B8` | |
| rxmsg | `0x12CA4` | `0x13AF4` | |
| decrypt | IRAM `0x2C60C` | IRAM `0x2C8DC` | |
| encrypt | IRAM `0x2C5CC` | IRAM `0x2C880` | |
| cpchanscan | `0x17D14` | `0x19738` | |
| sound | `0x6DF8` | `0x7234` | |
| rfint | `0x73C4` | `0x79FC` | |
| pc | `0x75F4` | `0x7C48` | UART RX task |
| cmd resend | `0x7584` | `0x7BC0` | status sender |
| sleep | `0xA5D0` | `0xB0D4` | |
| appmsg | `0xA7B0` | `0xB2CC` | |
| appcsbk | `0xAAA8` | `0xB6DC` | |
| callrx | `0xB33C` | `0xC084` | receive admit logic |
| **FmRecv** | **absent** | `0x399C` | the Armor's AT1846S FM receive task |

The `csbk` task-name string and the newlib `strerror` strings (Armor file `0x355A4–0x35D90`) are also absent from V076.

---

## 2. Symbol map: Armor `symbols.csv` onto V076

Confidence levels:
- **H**: identical normalized code, or unambiguous behaviour plus a cross-check.
- **M**: similar code or a single vote, consistent with its neighbours.
- **L**: approximate.

All addresses are file offsets unless marked IRAM/XIP.

| Name | Armor | V076 | Conf. | How matched / note |
|---|---|---|---|---|
| delay_ms | `0x18A4` | `0x1654` | H | identical |
| lock | `0x18E8` | `0x1698` | H | identical |
| unlock | `0x1924` | `0x16D4` | H | identical |
| create_tasks | `0x1BF8` | `0x19A8` | H | similarity 0.87 + same task list |
| at1846_apply_bw_profile | `0x2B14` | `0x2908` | H | same loop. Register list at SRAM `0x18000800` (file `0x2DF90`; Armor `0x18000808`); values at XIP `0x0304B51C` (file `0x3151C`), 46 B per profile |
| at1846_read_rssi | `0x2B4C` | `0x297C` | H | identical (reg `0x1B`, bits 15:8) |
| at1846_init | `0x2BAC` | `0x29B4` | H (behaviour) | rewritten as a table loop over file `0x31578`, 58 entries |
| at1846_tune | `0x2DD8` | `0x29E4` | H (behaviour) | spur reg `0x05` + `0x29`/`0x2A` + tables; type byte `0x389F0+0` selects DMR/analog |
| at1846_dmr_filters_bcfd | `0x2E92` (imm) | table entry file `0x31670` (value at `0x31672`); IRAM-tune immediates at file `0x4F488`, `0x4F548` | H | DMR `0x58 = 0xBCFD` |
| at1846_fm_filters_8405 | `0x3052` (imm) | `movi r1, 0xBCFD` at file `0x2B32` (imm16 at `0x2B34`) | H | **the analog branch writes `0xBCFD`, not `0x8405`** |
| at1846_set_squelch | `0x30A4` | — | H (absence) | no runtime AT1846S `0x49` write. Squelch is elsewhere (*inferred*: C7000) |
| at1846_set_ctcss_dcs | `0x32E4` | — (C7000 code at `0x2E8C`, `0x3260`, `0x344C`, `0x34D0`, `0x366C`, `0x370C`) | H (absence) / M (replacement) | no AT1846S `0x4A–0x4E`/`0x59` runtime writes |
| uart_put | `0x5EF4` | `0x5B00` | M | 2 call-site votes |
| rf_state_0_1 | `0x79C0` | `0x73AC` | M | 6 call-site votes |
| apply_analog_config | `0x7A30` | `0x73F8` | H | identical |
| uart_rx_task | `0x7C48` | `0x75F4` | H | identical; the "pc" task entry |
| (UART pend bsr, FW27) | `0x7C56` | `0x7602` | H | instruction 7 of the identical function |
| (flash pend, FW27) | `0x2B0C` | `0x2890` | H | identical |
| checksum | `0x7D94` | `0x7740` | H | identical |
| uart_send | `0x7DE8` | `0x7794` | H | identical |
| status_post | `0x7E08` | `0x77B4` | H (behaviour) | **different**: builds `68 36 …` through `reply_build` at once (`r0 = 54, r1 = 2`, 1-byte body), waits 100 ms, posts semaphore `0x38D34`. The Armor stores the byte at `0x38EF2` and wakes the sender |
| uart_status_sender | `0x7BC0` | `0x7584` | H | "cmd resend" task entry |
| family21_emit | `0x7E94` | `0x7868` | H | identical |
| family21_dispatch | `0x8BE4` | `0x8530` | M | similarity 0.63 |
| set_tx_gain_reg44 | `0x8E0C` | — | H (absence) | its command `0x8A` is gone; AT1846S `0x44` is only written as `0x0AD1`/`0x07F7` from tables |
| checksum_wrap | `0x8E5C` | `0x870C` | H | identical |
| ack_empty `(cmd, sr)` | `0x8E7C` | `0x872C` | H | same code; sr at frame byte 3 |
| reply_build | `0x90B0` | `0x8D90` | H | identical |
| cmd26 launch handler | `0x9264` | `0x8EC0` | H (dispatch) | rewritten, see §3 |
| cmd26_launch_bsr_sites | `0x92AA`, `0x92C8`, `0x92E0`, `0x92FA` | unkey (launch 2): **`0x8EF0`** (flag 0), **`0x8F2E`** (flag ≠ 0). Key (launch 1): **`0x8F0C`** (flag 0), **`0x8F1C`** (flag ≠ 0) | H | all `bsr` → `tx_launch_action` `0xCCC`. Flag byte Armor `0x38874` = V076 `0x3872C` |
| tx_launch_action | `0xE9C` | `0xCCC` | H | 5 call sites; also called from the time-out tick |
| cmd22_digital_unpack | `0x9310` | `0x8F3C` | H (dispatch) | rewritten; 163-byte memcpy at `0x8F86`; 32-group loop closes `cmpnei r1, 32` at `0x91AE` |
| cmd23_analog | `0x99B4` | `0x9500` | H (dispatch) | rewritten |
| analog_unpack | `0x9A2C` | inside `0x9500` | L | not a separate function on V076 |
| analog_repack_sq | `0x9C3E` | not located | — | |
| status_query_bit5 (0x27) | `0x9E24` | `0x98C4` | H | identical; status byte Armor `0x38908` = V076 `0x387A0` |
| cmd24_query_digital | `0x9E3C` | `0x98DC` | H | identical |
| cmd25_query_analog | `0x9E4C` | `0x98EC` | H | identical |
| cmd39_query_mix | `0x9E5C` | `0x98FC` | H | identical |
| cmd34_version_reply | `0xA7E8` | `0x9F18` | H | copies **16** bytes (Armor 17) from XIP `0x0304D410`; pool word at file `0xA03C` (Armor `0xA9E8`) |
| cmd2b_caller_info | `0xA808` | `0x9F38` | H | identical |
| (0x2B `reply_build` call, FW26 D) | `0xA890` | `0x9FC0` | H | instruction 43 of the identical function |
| (0x2B call-type mapper) | `0x23D4` | `0x2184` | H | identical |
| phone_dispatch | `0xAA3C` | `0x9FC8` | H | `cmphsi r3, 103` at `0xA02C`, `lrw` table at `0xA032`, `ldr.w` at `0xA034`, `jmp r3` at `0xA038` |
| phone_dispatch_table | `0x38240` (105 slots) | `0x33274` (103 slots, XIP `0x0304D274`) | H | read from flash on both |
| (0x40 slot) | `0x382B8` | `0x332EC` | H | holds the default case on both |
| cmd40_factory_empty (default case) | `0xAA54` | `0x9FE0` | H | `pop r4-r5, r15` inside the dispatcher |
| (0x3B case `bsr`, FW19 hook) | `0xAB18` | `0xA05A` | H | case at `0xA058` |
| cmd3d_handler | `0xAAFE` / `0xA898` | — | H | `0x3D` absent |
| at1846_rx_off | `0xB00C` | `0xA508` | H | identical |
| at1846_rx_on | `0xB048` | `0xA544` | H | similarity 0.94 |
| (receive getter, FW26 A) | `0x2404` (`ld.b 0x38B5C+0xAF`) | **`0x21B4`** (`ld.b 0x389F0+0xAF`) | H | channel struct Armor `0x38B5C` = V076 `0x389F0` |
| (callrx task) | `0xC084` | `0xB33C` | H | task entry |
| (admit gate 1, FW26 A) | `0xC1BA` | **`0xB41C`** | H | `bsr getter; bez → status 1; else status 10` |
| (admit gate 2, FW26 A) | `0xC244` | **`0xB462`**, plus a third call at **`0xB4B2`** | H / M | V076 has three getter call sites; the Armor's `0x800099` pre-check before the gates is absent |
| (CC store, FW26 B) | `0x17E26` `andi r2, 15` / `0x17E2A` `st.w` | **`0x165CC`** / **`0x165D0`** (the other branch already sets bit 8 at `0x165BE`) | H | same code; mode struct Armor `0x34808` = V076 `0x346CC` |
| (WORK_MODE writers) | `0x179C8`, `0x17D54` | `0x161A2`, `0x164FA` | H | `movih 0x1100; bseti 8; movi 34; st.w` |
| txram_refill_task | `0x18A70` | `0x171BC` | H | sysint task entry |
| txram_wake_site_a | `0x18B5C` | `0x172E8` | H | `bsr` → `0x0303 12FC` |
| txram_wake_site_b | `0x18B68` | `0x172F4` | M–H | `bsr` → file `0x3870` (Armor → `0x3D20`, its FM code; the V076 callee is *inferred* to be the C7000 FM equivalent) |
| (time-out struct) | RAM `0x38C64` | RAM **`0x38AF8`** | H | `[0]` enable, `[1]` seconds, `[2..5]` counter |
| (time-out tick) | `0x1D8` | `0x1CC` | H | 100 ticks per unit, then `tx_launch_action(1, 1)` |
| (time-out init, 120 s) | `0x264` | `0x258` | H | `movi r2, 120` |
| memcpy | `0x304E8` | `0x2DDD8` | H | identical |
| memset | `0x30568` | `0x2DE58` | H | identical |
| ctcss_table | `0x366B2` | — | H (absence) | no 6700…25410 cHz table; DCS code table (binary values of the octal codes 023, 025…) at **`0x319C8`** |
| GCR_DACL table | `0x36ED0` | **`0x31EF4`** (same 20 bytes) | H | loaded at `0x5DDA`, `0x5DFC`; the Armor's volume→DAC function `0x61F4` (`subi 117…120`) has no V076 twin |
| version_string | `0x38464` | `0x33410` | H | |
| data_table_tail (NOT free) | `0x35F64` | **`0x30E70`** | H | 128 zeros after a run of `0x01`/`02`/`03` |
| OSTaskCreate | `0x3C390` (IRAM `0x12F88`) | `0x372F0` (IRAM `0x12F88`) | H | same IRAM address |
| at1846_i2c_write | `0x54628` (IRAM `0x2B220`) | **flash `0x28DC`** (XIP `0x0301C8DC`), calling IRAM `0x2B94C` (file `0x4FCB4`, locked bus write) | H | V076 has no reg-10 special case (the Armor stores 69 to `0x31BCA`); 64 direct call sites (Armor 234), the rest through tables |
| at1846_i2c_read | `0x54664` (IRAM `0x2B25C`) | **flash `0x2934`**, calling IRAM `0x2BBB0` (file `0x4FF18`) | H | device byte `0xE2` (7-bit `0x71`) on both |
| fm_keyup | `0x3ECC0` (IRAM `0x158B8`) | `0x39C20` (IRAM `0x158B8`) | H | byte-identical apart from `bsr` targets |
| (RF_MODE store) | `0x3EDDA` | `0x39D3A` | H | |
| (tx_voice_source clear) | `0x3EDF8` | `0x39D58` | H | |
| (FW patch site, `lrw 0x11000560`) | `0x3EDFC` | `0x39D5C` | H | pool at IRAM `0x15A20` on both |
| (padding before pool) | `0x3EE16` | `0x39D76` | H | |
| fm_unkey_path | `0x3D688` | `0x385E8` | H | similarity 0.98 |
| reboot (0x88) | `0xA34C` → `0xAB4` | `0x9AA0` → `0xA08` | H | ack, 1 s delay, write `0x1100005C = 0x01000000` and `0x11000000 = ~384` (system reset) |
| zero_tail | `0x5AEFC` | `0x55ED4` | H | §5 |

The FW-specific symbols (`fw2x_*`, `op5_sendh`, the `0x5Bxxx`/`0x5Cxxx` labels, `fw26_flag`) exist only in our Armor
bench images. They have no V076 counterpart.

---

## 3. Command set (V076 dispatcher, jump table at file `0x33274`)

**Dispatcher (`0x9FC8`).** The steps are the Armor's:
1. Length = BE `buf[6..7]` + 1, rejected if ≥ 800.
2. Wait for the rest of the frame.
3. `buf[0] == 0x68`, else ack sr 1.
4. `buf[len−1] == 0x10`.
5. Checksum `0x7740`.

V076 differs in two ways:
- **A checksum failure answers ack sr = 2** (branch at `0xA016` → `0xA168`).
- Before the switch it calls `0xA578` and IRAM `0x2AD6C(1, 1)`. The Armor calls `0x2AF24(1, 1)` and then
  `0xB07C`.

Cases are 8-byte thunks `mov r0, r4; bsr handler; pop r4-r5, r15`. The inline cases are `0x22`, `0x23`, `0x2C` and
`0x36`.

| Cmd | Armor case → handler | V076 case → handler | V076 against the Armor |
|---|---|---|---|
| `0x22` set digital | `0xABEA` → `0x9310` | `0xA154` → `0x8F3C` | rewritten. **Refused (no reply) when status bits 0 or 2 of `0x387A0` are set.** rx and tx 400–490 MHz only; power ≤ 1; ID ranges checked; `channelMode` 0 or 4. After the ack it re-runs the AT1846S cold-init table (`bsr 0x29B4` at `0x9464`) |
| `0x23` set analog | `0xABE2` → `0x99B4` | `0xA13A` → `0x9500`, then `bsr 0x301D938(30)` | rewritten. **Refused when status bit 0 is set.** 400–490 MHz; after the ack, `bsr 0x29B4` (full AT1846S init with 3 × 101 ms calibration waits) at `0x97C2`; C7000 FM set-up |
| `0x24` / `0x25` | readbacks | `0x98DC` / `0x98EC` | identical (163 B from `0x38B24`?, 19 B; *inferred* buffers `0x38B24` / `0x38B04`) |
| `0x26` launch | `0x9264` | `0x8EC0` | **rewritten.** If byte `0x324AC+0xA == 1`: ack sr 1 (busy). Launch 1 = key, launch 2 = unkey, each through `tx_launch_action` `0xCCC` (sites in §2), ack sr 0. **No** 80 × 10 ms busy-wait, no `0x2AF24(1, 1)` pre-call, no state writes to `0x38908+0xA/0xB/0xD` |
| `0x27` init status | `0x9E24` | `0x98C4` | identical |
| `0x28` enhance | `0x9E6C` | `0x990C` | rewritten (not read in detail) |
| `0x29` encrypt | `0x9FB8` | `0x99C0` | simplified: type 1–2 only (Armor 0–4), 8 key bytes copied to `0x38B24+0x97`, then `bsr 0x302B5A4` |
| `0x2A` mic gain | `0xA1DC` | `0x9A10` | simplified: body ≤ 5 → `0x38B24+0xA1`, `bsr 0x3020018`. The Armor's extra range check on a stack word (`0xF7F4103F` / `0x02AEA53E`) is gone |
| `0x2B` caller info | `0xA808` | `0x9F38` | identical (9-byte body) |
| `0x2C` send SMS | `0xA364` | `0x9AB8` | rewritten. Refused (sr 1) while `0x387A1` bit 3 is set (inline case `0xA0DC`). Body length handling differs: the Armor uses `len − 5` on one path, V076 `len − 3`. **Whether V076 needs the Armor's 9-byte header is not settled** |
| `0x2D` fetch SMS | `0xA53C` | `0x9CA4` | identical |
| `0x2E` vol, `0x30` squelch, `0x31` power save, `0x32` RSSI | | `0x9CD0`, `0x9D64`, `0x9DA8`, `0x9DD8` | identical |
| `0x2F` monitor | `0xA5CC` | `0x9D04` | similarity 0.73 |
| `0x33` relay | `0xA6C4` | `0x9DF4` | similarity 0.95 |
| `0x34` version | `0xA7E8` | `0x9F18` | 16 B |
| `0x35` interrupt | `0x8F18` | `0x8C60` | similarity 0.86 |
| `0x36` status ack | inline | inline `0xA080` | sets bits in `0x38BC8` (Armor `0x38EF0`) |
| `0x37` policy | `0x8EB4` | `0x8BFC` | identical |
| `0x38` mix-check set | `0x8EA8` = **plain ack sr 1** | **`0x8758`, a real handler** (169-byte copy, scan config) | new on V076 |
| `0x39` mix-check query | `0x9E5C` | `0x98FC` | identical |
| `0x3A` SMS protocol | `0xA280` (0/1/2) | `0x9A3C` (0/1 → `0x387A0+8`) | simplified |
| `0x3B` time-out | `0xA308` | `0x9A5C` | same stores into `0x38AF8`, **but acks sr = 1 on both branches** (`movi r1, 1` at `0x9A72` and `0x9A80`) |
| `0x3C` speaker enable | `0xA334` | `0x9A88` | identical |
| `0x3D`, `0x3E`, `0x3F`, `0x46` | handlers | **default** (no reply) | absent |
| `0x88` reboot | `0xA34C` | `0x9AA0` | identical (ack, 1 s, SoC reset) |
| `0x89` 3-byte ID, `0x8A` TX gain | inline / `0x8E0C` | **beyond the table** (`cmphsi 103` covers up to `0x88`) | absent |
| `0x40` | default | default | free slot (`0x332EC`) |

**Other routing.** `0x20` and `0x0F` are discarded. Family `0x21` goes to `0x8530`. Unknown commands get no reply.
This is the uart_rx_task, the same as the Armor's.

**Envelope.** The module image contains no `7E 96 69` handling and no envelope checksum. It speaks `68 … 10` only. The
envelope belongs to the bridge or the host (§9).

---

## 4. Boot and update path

- **There is no bootloader in the image.** The application is linked for XIP `0x0301A000`, so flash offset `0x1A000`
  in the module's SPI NOR.
  - The only reference below `0x0301A000` is the cache-region constant `0x0300002D` at file `0xBC`/`0xC0`. No `bsr`,
    `jsri` or literal points into `0x03000000–0x03019FFF`.
  - The bootloader (*inferred*: the first 0x1A000 B of flash) is therefore separate, cannot be inspected from this
    file, and is never written by a YModem load.
- **Update entry is not in the application.**
  - No handler looks for `0x31`.
  - The HAL enters update mode from outside: module power-off through the bridge (`00 10 00`), `handle_ptt` low,
    bridge update mode (`00 08 01`), power-on (`00 10 01`), byte `'1'`, then wait for ≥ 6 `'C'`.
  - So the bootloader is entered at power-up with PTT held, then `'1'`, the same scheme as the Armor's `dmr009` knock
    (§9).
- **No flash read or write routine was found in the application.**
  - There is no SPI-NOR programming code and no reference to a flash controller beyond the XIP region.
  - Not every peripheral block was identified, so this is *inferred from absence*.
  - There is no checksum, MD5 or signature over the image anywhere in the application. The HAL performs no check
    either (§9). Any integrity check would have to live in the bootloader, which is not available.
- **The only self-identification is the version string** at file `0x33410`, returned by `0x34`.

---

## 5. Free space and do-not-write areas

**Free.** File `0x55ED4`–`0x576D3`, 6,144 bytes, XIP `0x0306FED4`–`0x030716D3`, all zeros.
- It is past the IRAM copy end: descriptor dst end `0x31B6C`, so the copy ends at file `0x34368 + 0x21B6C =
  0x55ED4`.
- The scanner reports `0x55ED2` because the last two copied bytes are also zero. Do not use `0x55ED2`/`0x55ED3`:
  they are IRAM `0x31B6A`/`0x31B6B`.
- No `lrw` pool lies at or after `0x55ED4`.
- No 32-bit word in the image points into the range. One false hit, at `0x2F8AA`, is a 16-bit coefficient table that
  is also in the Armor at `0x33BF0`.
- Code linked here runs XIP. Calls into IRAM are long `bsr`s across the `0x0301A000` gap, as with the Armor stubs.

**No other runs.** No other zero or 0xFF run of 64 bytes or more exists anywhere in the image. There is no padding
between functions to reclaim. The Armor's FW23–FW27 practice of reclaiming earlier stub space does not apply to a
stock V076.

**Do not write:**

| Item | File / RAM | Reason |
|---|---|---|
| 128 zeros | `0x30E70`–`0x30EEF` | the tail of a data table (`03…03 02…02 01…01 00×128`); the Armor twin `0x35F64` did not boot with code there |
| Jump table | `0x33274`–`0x3340F` | its last slot (`0x88`) ends at `0x3340F` and the version string starts at `0x33410`. The table cannot grow; a command above `0x88` needs a relocated table plus a new `cmphsi` bound at `0xA02C`. Slot edits inside it (e.g. `0x40` at `0x332EC`) are fine |
| Version string | `0x33410`–`0x3341F` | 16 B including NUL; `0x34` reads 16 bytes. Tag field `U4A` at `0x33417`–`0x33419` (3 chars, not 4) |
| AT1846S tables | `0x31578`, `0x31660`, `0x316D8`, `0x31744`, bandwidth values `0x3151C`, register list `0x2DF90` | data read by loops; editing an entry changes every channel write |
| Literal pools in the code region | everywhere after `jmp r15`/`pop` | the Armor lesson applies: a reclaimed range must hold no literal loaded by code outside it (`tools/fw-patch/literal_guard.py`). V076 has dense pools between functions |
| SRAM-init and IRAM images | `0x2DF90`–`0x30DEF`, `0x34368`–`0x55ED3` | copied at boot; patching them changes RAM/IRAM contents |

**RAM for flags.**
- V076's IRAM .bss runs `0x31B6C`–`0x4CF30`.
- The largest gaps between referenced .bss addresses mirror the Armor's at fixed shifts: 27,648 B at `0x3FBD4`
  (Armor `0x40700`), 4,048 B at `0x4AD58`–`0x4BD28` (Armor `0x4A3C8`–`0x4B398`, where our FW21+ tone queue and the
  FW26 flag live).
- *Inferred:* the V076 analogue of `fw26_flag` `0x4B364` is `0x4BCF4`, the same offset from the end of the same-size
  object. Prove that object is unused before relying on it. It may be a task stack.

---

## 6. RF and audio specifics

**AT1846S cold-init table** (file `0x31578`, run by `0x29B4`; `FF` = delay):
- `30=0001`, delay 101, `30=0004`, `04=0FD0`, `0A=4C20`, `1F=1001`, `31=0031`, `33=44A5`, `34=2B87`, `41=470F`,
  `42=1036`, `43=00BB`, `44=07F7`, `3A=00C3`, `59=0B90`, `47=7F2F`, `4F=2C62`, `53=0094`, `54=2A18`, `55=0081`,
  `56=0B22`, `57=1C00`, **`58=8405`**, `5A=0ADD`, `63=3FFF`.
- Calibration: `30=40A4`, delay 101, `30=40A6`, delay 101, `30=4006`, delay 101.
- Then **`58=BCFD`**, `40=0031`, `33=45F5`, followed by the 12.5 kHz profile (`15=1100`, `32=4495`, `3A=00C3`,
  `3C=0407`, `3F=28D0`, `48=20BE`, `60=1BB7`, `62=1425`, `65=2494`, `66=EB2E`).
- AGC page 1 (`7F=1`, `06=0014`…`0F=3F44`, `12=E0EB`, `7F=0`), then `49=0000`.
- This matches the Armor's `at1846_init` sequence, except that the Armor leaves `0x58` at `0x8405`.

**Tune** (`0x29E4`, called with the frequency):
1. `30=4006`.
2. Spur register `0x05` = `8763`/`8543`/`8643`, chosen against 420.875, 432.25, 443.625, 455.0, 466.375, 477.75,
   489.125, 500.5 and 511.875 MHz (UHF only; the Armor's list includes VHF).
3. `30=4046`, frequency `0x29`/`0x2A`.
4. Type byte (`0x389F0+0`):
   - **≠ 1 (*inferred* DMR):** table `0x31660` = `30=4006`, `30=4026`, `44=0AD1`, **`58=BCFD`**, `33=45F5`,
     `3A=00C9`, 12.5 k profile. Return.
   - **== 1 (*inferred* analog):** narrow (`0x389F0+1 == 1`) uses table `0x31744` (`30=4006/4026`, 12.5 k profile);
     wide uses table `0x316D8` (`30=7006/7026`, `15=1F00`, `32=7564`, `3A=44C3` … 25 k profile). Then **`58=BCFD`**
     (file `0x2B32`), `33=44A5`, `44=0AD1`, `3A=40C3`.
5. IRAM twins of the tune (file `0x4F3D6`–`0x4F6AE`, IRAM `0x2B06E`–`0x2B346`) also write `58=BCFD` only.

**Register `0x58` comparison:**
- The Armor writes `0x8405`/`0x8404` on analog: AT1846S voice HPF, emphasis, voice LPF and CTCSS filters on.
- **V076 writes `0xBCFD` on every runtime path:** all AT1846S audio filters are bypassed on analog as well.
- The audio processing is in the HR-C7000 FM block instead:
  - `0x344C` (6 callers) writes `FM_DEV_COEF 0x11000504` (e.g. `0x30409`), **`FM_BANDWIDTH 0x11000500 = 0x5E`**
    (`movi r2, 94` at file `0x346A`; reset `0x5F`, so band-pass bit 6 and emphasis bit 4 on), `0x1100050C =
    0x07D02810`, `0x11000510`, and `0x11000530 = 0x7F499D`.
  - `0x2E8C` writes `FM_DEV_COEF` per frequency band from a list of constants (`0x3103A`, `0x30429`, `0x3044A`,
    `0x3107F`, `0x30475`, `0x3104A`, …; *inferred*: per-band deviation calibration). It also writes
    `0x11000510/0x51C/0x518/0x50C` and `0x11000114`.
  - `0x3260`/`0x34D0`/`0x366C`/`0x370C` handle `0x11000520` (DCS code from table `0x319C8` + `0x84`) and
    `0x11000528`. *Inferred:* CTCSS/DCS encode and decode.
- Access counts: V076 has 12 / 35 / 8 / 6 / 2 accesses to `0x504`/`0x510`/`0x520`/`0x528`/`0x530`. The Armor has
  0 / 8 / 0 / 0 / 0.

**Squelch and CTCSS.**
- There is no AT1846S `0x49` write after init and no `0x4A–0x4E` write at all.
- `0x30` (squelch) is stored by an identical handler. *Inferred:* the decision is made in the C7000 FM block or in
  software.
- The Armor's `FmRecv` task (AT1846S-based FM receive) is absent.

**TX gain.** Command `0x8A` (AT1846S `0x44` bits 11:8) is absent. `0x2A` sets a byte in the channel image and calls
`0x3020018`, which was not read; *inferred*: C7000 or codec gain.

**DAC gain table** (`GCR_DACL`, file `0x31EF4`): the same bytes as the Armor's `0x36ED0`.

**Band limits (UART parser).**
- `0x22` and `0x23` both use `lrw 0xE8287C00` (−400 MHz) and `lrw 0x055D4A80` (90 MHz): rx and tx must satisfy
  `f − 400 MHz ≤ 90 MHz` (`0x8FC6`–`0x9094`; `0x9586`–`0x95C0`).
- So 400.000–490.000 MHz, with no VHF window.
- The Armor's literals are 400 + 120 MHz and 136 + 38 MHz. Whether the AT1846S/C7000 tune path enforces a tighter
  range was not read (the Armor's measured 400–480 limit came from elsewhere).

**Transmit time-out.**
- Default: enable 1, 120 s (init at `0x258`).
- Tick at `0x1CC`: when status bits 0 or 2 are set, it counts 100 ticks per unit, then calls
  `tx_launch_action(1, 1)` (unkey).
- `0x3B` stores the body byte (0 = off), exactly like the Armor, but acks sr 1 (§3).
- The stock app never sends `0x3B` and runs its own 30 s app timer (§9). So on stock software the module runs its
  120 s start-up value (*inferred*; not measured on an Atom XL).

---

## 7. Comparison with the Armor image

| Measure | Flash part | IRAM part |
|---|---|---|
| Size, Armor / V076 | `0x322E0` / `0x2DF90` B | `0x21AF4` / `0x21B6C` B |
| Functions found, Armor | 738 | 468 |
| Matched | 647 | 462 |
| Normalized-identical | 355 | 349 |
| Armor instructions in equal-aligned blocks of matched functions | 80.5 % | 97.0 % |
| Exact 16-byte windows of V076 present in the Armor | 54 % (relocation changes `bsr`/`lrw` bytes) | 92 % |
| Same runtime address | almost none (the shift varies: −0xC at the time-out tick, −0x63C at `uart_status_sender`, −0xA74 at the dispatcher) | IRAM `0x10000`–`0x2ACF7`: identical addresses (373 functions); after main (`0x2ACFC`), shifts of −0x1B8 … −0x1F08 |

The SRAM-init data is 99.7 % identical in content. V076's is 0xDA4 B shorter.

**Removed in V076:**
- the newlib `strerror`/printf block (Armor flash `0x30738`–`0x32290`, strings `0x355A4`–`0x35D90`);
- the AT1846S CTCSS/DCS, squelch and FM-receive code (Armor `0x30A4`, `0x31E4`, `0x32E4`, `0x346C`, `0x388C`,
  `0x399C` FmRecv task, `0x3CB8`);
- the volume→DAC gain function `0x61F4`;
- handlers for `0x3D`/`0x3E`/`0x3F`/`0x46`/`0x89`/`0x8A`;
- the `csbk` task name.

**Added or changed in V076:**
- the C7000 FM/CTCSS/DCS code (`0x2E8C`, `0x3260`, `0x344C`, `0x34D0`, `0x366C`, `0x370C`) and the DCS table
  `0x319C8`;
- the table-driven AT1846S driver with flash-resident I²C wrappers;
- a full AT1846S re-init on every `0x22`/`0x23`;
- busy refusals on `0x22`/`0x23`/`0x26`/`0x2C`;
- a real `0x38` (mixed scan);
- sr = 2 on checksum errors;
- a synchronous `0x36` push;
- the UHF-only parser limits;
- `0x3B` acking sr 1.

**Unchanged:**
- the frame format, checksum and reply builder;
- the `0x24`/`0x25`/`0x39` readbacks, `0x2B`, `0x2D`, `0x2E`, `0x30`–`0x32` and `0x88`;
- the time-out mechanism;
- uC/OS-III and almost all IRAM modem, TX-RAM and FM key-up code;
- the HR-C7000 register set touched at `0x1100_01xx`–`0x4xx` and `0x1600_09xx`;
- the 32-entry group list loop.

---

## 8. Porting our Armor patches (FW19–FW30) to V076: plan only

**Precondition.** Dump the image the module actually runs (V067 on the research unit) and diff it against V076. Only
then decide whether to port, re-derive or adopt V076 as a baseline (owner decision). Everything below is V076-specific
and does not transfer to V067/V082 without that diff.

| Armor patch | Armor anchor | V076 anchor | Work needed and risks |
|---|---|---|---|
| Image tag | `0x3846B` (4 chars, `UV4T`) | **`0x33417` (3 chars, `U4A`)** | `build.py`'s tag length differs; SignalDeck's tag parser has to accept 3 characters |
| FW19 time-out ceiling (tot120 stub, `bsr` at the `0x3B` case) | case `bsr` `0xAB18`, handler `0xA308`, struct `0x38C64` | case `bsr` **`0xA05A`**, handler **`0x9A5C`**, struct **`0x38AF8`** | Stub logic is unchanged; link it into `0x55ED4+`. Note the stock handler acks sr 1. Decide whether the stub also replies sr 0 (*risk*: hosts treat sr 1 as failure) |
| FW20 drop / unkey (`0x26` key/unkey redirects, op 7 `drop_ptt`) | `bsr` sites `0x92AA`/`0x92C8`/`0x92E0`/`0x92FA` → `0xE9C`; flag `0x38874`; TX state `0x38908`, `0x34808` | sites **`0x8EF0`/`0x8F2E`** (unkey) and **`0x8F0C`/`0x8F1C`** (key) → **`0xCCC`**; flag **`0x3872C`**; status **`0x387A0`**; mode **`0x346CC`** | **Re-derive, do not copy.** V076's `0x26` has no busy-wait and no `0x2AF24` pre-call, and refuses while `0x324AC+0xA == 1`. The "unkey while the TX bits are still set" rule must be re-proven against V076's `0xCCC`. *Risk:* deaf receiver or a stuck TX flag (the FW20 lesson) |
| `0x40` command slot (symbol ring, ops 1–17) | slot `0x382B8`, stubs at `0x5AEFC` | slot **`0x332EC`** (currently `0x03023FE0`), stubs at **`0x55ED4`** (6,144 B) | The Armor's FW21–FW27 stubs fill more than 6 KiB (they reclaimed up to `0x5C6FB` in a grown image). Size the V076 port to 6 KiB, or grow the image file past `0x576D4` (*risk*: the bootloader's accepted maximum size is unknown). The ack/reply helpers are at `0x872C`/`0x8D90` |
| TX-RAM engines (wake hooks) | `0x18B5C`, `0x18B68`; refill task `0x18A70`; TX RAM / `0x1600xxxx` | **`0x172E8`**, **`0x172F4`** (callee `0x3870` instead of `0x3D20`); task `0x171BC`; same `0x1600xxxx` literals | The surrounding code matches with similarity 0.91. Re-verify what `0x3870` does: it replaces the Armor's AT1846S FM call. *Risk:* site B's semantics differ |
| FM key-up hook (`lrw 0x11000560` site) | `0x3EDFC` (IRAM `0x159F4`), padding `0x3EE16` | **`0x39D5C`** (IRAM `0x159F4`), padding **`0x39D76`** | Byte-identical, at the same IRAM address. Only the `bsr` targets into flash must be relinked (delay `bsr` at `0x39D64` → `0x2AC38`) |
| WORK_MODE / FM receive RAM (FW27 stream, op 6 variant 5) | `0x179C8`, `0x17D54`; RAM `0x160004E0` | **`0x161A2`**, **`0x164FA`**; same C7000 RAM | Should port. On V076 the C7000 FM block is already active on analog (`FM_BANDWIDTH 0x5E`), so the "variant 5" state may be closer to stock |
| Promiscuous receive (FW26 A/B/D + op 15 flag) | gates `0xC1BA`, `0xC244` → getter `0x2404`; CC `0x17E26`; `0x2B` finish `0xA890`; flag `0x4B364` | gates **`0xB41C`**, **`0xB462`**, **plus `0xB4B2`**; getter **`0x21B4`**; CC **`0x165CC`** (store `0x165D0`); finish **`0x9FC0`**; flag *candidate* `0x4BCF4` | Patch A needs a third site. The `0x2B` builder is identical, so D ports directly. The flag RAM must be proven free |
| Register hold op 6 (`0x58 = 0xBCFD` held) and fm-flat-58 variants | `0x2C90`, `0x3054`, `0x344E`, `0x34F2`, `0x3640`, `0x333A`, `0x3074` | **not applicable**: V076 already writes `0xBCFD` | V076's analog filtering is the C7000 chain. The flat-audio analogue is `FM_BANDWIDTH` bits 4/6 (immediate `movi r2, 94` at **`0x346A`**) and possibly `FM_DEV_COEF` (`0x344C`, `0x2E8C`). Because `0x22`/`0x23` re-run the full AT1846S init and the C7000 FM set-up, a hold must be re-applied after every channel write, as on the Armor |
| GCR_DACL table edit | `0x36ED0` | **`0x31EF4`** | Same bytes. The Armor note "`0x3074` runs before `0x61A8`" does not hold (no `0x61F4` twin; users at `0x5DDA`/`0x5DFC`) |
| Opcode 12 flash read (FW22) | XIP reads | same XIP base | Portable. It is the only way to read back the running image once a patched image is loaded, which is itself a write |

**Overall risks:**
- The bootloader (outside the image) is unknown. Its size limit, any validation and its recovery behaviour are
  unread, and the HAL performs no checks.
- V076's rewritten `0x26`, `0x22` and `0x23` invalidate the Armor's timing lessons (retune settle, channel-write
  pairs).
- `0x22`/`0x23` now refuse while busy, which changes host retry logic.

---

## 9. Host side (stock app and HAL)

Read statically from the pulled `Intercom.apk` (`com.agold.intercom` 2.0, jadx), the HAL
`vendor.mediatek.hardware.aguiextmodule@1.0-service` (aarch64; function names recovered from its `.gnu_debugdata`
mini-symtab), its `.rc`, `auto_update`, `extcmdtest` and `dfu-util`. Nothing was run.

**HAL function map** (service VA):

| Function | VA | Function | VA |
|---|---|---|---|
| `extStartMcu` | `0x66B0` | `extUpdateDmr` | `0x6DA0` |
| `extStopMcu` | `0x6818` | `extDetectAudioinState` | `0x7350` |
| `extUpdateMcu` | `0x6968` | `audio_open` | `0x73F0` |
| `extStartPtt` | `0x6A80` | `Ymodem_Transmit` | `0x4E50` |
| `extStopPtt` | `0x6AC8` | `Cal_CRC16` | `0x4D00` |
| `extReadTTyDevice` | `0x6B30` | `SerialPutChar` | `0x5FD8` |
| `extWriteTTyDevice` | `0x6C70` | `SerialSendPacket` | `0x6128` |
| `make_cmd` | `0x5940` | `SerialKeyPressed` | `0x5E70` |
| `setDmrOnOffState` | `0x6450` | `setDmrUpdateState` | `0x6590` |
| `set_opt` | `0x5D70` | `check_device` | `0x5C78` |

### Framing

- No host layer builds `68 … 10`. The app builds the whole envelope in `IComUtils.makePackage(route+cmd, rw, data)`:
  `7E 96 69 | route | cmd | rw | lenBE | body | checksumBE | 81`.
- Checksum (`IComUtils.checkSum`): the one's-complement 16-bit sum of route…data, odd last byte in the high half.
- Routes: `00` bridge, `01` module, `02` bridge reports.
- The HAL's `writeTTyDevice`/`readTTyDevice` are raw pipes to `/dev/ttyACM0` (115200, raw, VMIN 1).
- The module image speaks only `68…10`. **Whether the STM32 bridge translates envelopes to `68…10` on the module
  UART is open** (the bridge image was not disassembled). *Inferred:* yes, since the module accepts the app's
  commands.

### Module commands the app sends (dmr09 set)

| Command | Body |
|---|---|
| `01 22` | 163 B, Armor layout. TX contact `0xFFFFFA` when contactType = 4; `[144]` = contactType − 1; key ASCII at `[151–158]`; `[159] = 1`, `[160] = 7`, `[161]` = mic, `[162] = 2` |
| `01 23` | 19 B: `[8]` wide flag, `[9]` power, `[10]` squelch, `[11]`/`[13]` rx/tx sub-audio type − 1, `[12]`/`[14]` codes or `0xFF`, `[15–18]` = 1, 8, 2, 2 |
| `01 2B` | `01`, before receive playback |
| `01 2C` | 5-byte SMS header |
| `01 2D` | fetch SMS |
| `01 2E` | volume |
| `01 34` | version |
| `00 01` | bridge version |

- **The app never sends** `0x26`, `0x3B`, `0x40`, `0x32`, `0x24` or `0x25`.
- PTT is GPIO only (HAL `startPtt`/`stopPtt` → sysfs `handle_ptt` 0/1, active low).
- The transmit limit is the app's own timer: `Settings.Global ptt_limit_send_time`, default
  `ro.default.limit_send_time` = 30 s.
- PTT is also gated on temperature (< −2 °C or > 55 °C), battery (< 30 % digital, < 15 % analog) and an antenna sensor
  (`/sys/hall_status/hall_status`).

**Pushes the app parses:**
- `0x36` body `5` means a new SMS; the app fetches with `0x2D` 500 ms later.
- `0x2B` carries a 9-byte body.
- Bridge pushes `00 04/05/06/07/08/09/0A`.

### Audio

- With `ro.agold.extmodule.32k=yes` the app runs at 32 kHz with 1280-byte frames.
- The HAL uses ALSA `pcmC1D0c`/`pcmC1D0p`: 2 ch, 32000 Hz, 16-bit, period 1280 × 4.
- It powers the codec with `echo 1/2 > /dev/ttyTTCMD`.
- Audio does not cross the module UART.

### Module power

- `extStartMcu`: `usb_path` 1, `mcu_power` 1, `rstmcu` 0, then polls for `/dev/ttyACM0`. **It loops forever** if the
  port never appears.
- `extStopMcu`: closes the fds, powers down, blips power and powers down again.

### Module firmware update (`extUpdateDmr`, VA `0x6DA0`)

1. `extStartMcu`, then open the port.
2. `setDmrOnOffState(0)` = `00 10 [00]`, wait 4 s.
3. `handle_ptt` ← 0, wait 2 s.
4. `setDmrUpdateState(1)` = `00 08 [01]`, wait 2 s.
5. `setDmrOnOffState(1)` = `00 10 [01]`, wait 2 s.
6. Read the whole file from `/storage/self/primary/intercom/dmr/<name>`, else `/vendor/data/dmr/<name>`.
   **No header, size, MD5, signature or version check.**
7. Send `'1'` (`0x31`).
8. Read up to 60 times; proceed after six `'C'`.
9. `Ymodem_Transmit`.
10. Clean up: `00 10 00`, `handle_ptt` 1, `00 08 00`, `extStopMcu`.

The return value is 1 if ≥ 6 `'C'` arrived, whatever the YModem result was. The app ignores it and relies on a 240 s
timer.

**Transport in update mode.**
- Nothing goes raw. `SerialPutChar` wraps every byte as `7E 96 69 00 09 01 0001 <byte> ck 81`.
- `SerialSendPacket` sends data as route-00 command-`0x09` frames of ≤ 256 B, with 100 ms after each full chunk. A
  1027-byte STX block is 256 × 4 + 3.
- `SerialKeyPressed` reads 12 bytes, requires `7E 96 69` and returns frame byte 8. So the bridge returns bootloader
  bytes one per envelope.
- `00 08 01` therefore means "forward command-`0x09` payloads to the module UART", not a transparent bridge.
- A listen-first capture must parse envelopes.

**YModem.**
- Block 0: `SOH 00 FF`, file name, NUL, decimal size, zero pad. CRC-16/XMODEM (poly `0x1021`, init 0), MSB first.
- It waits for ACK only; it does not wait for a second `'C'` before block 1.
- Data: STX/1024 blocks; the tail goes as SOH/128 blocks padded with `0x1A`.
- Up to 10 resends per block.
- End: a single EOT repeated until ACK, then the null block 0.
- Reads block. **A silent module hangs the HAL**; only the app's 240 s timer notices.

### Stock app update triggers (hazards for SignalDeck)

- The app flashes **any `/sdcard/intercom/dmr/*.bin` whose name ≠ `<0x34 reply>.bin`**. No setting is needed.
- `/vendor/data/dmr/` is used only with preference `dmr_update` = 1, and only for names that sort above the version.
- **If the module has not answered `0x34` within 3 s after the bridge version, `handleGetDmrTimeout` flashes any
  candidate file.**
- The bridge image is the greatest name in `/vendor/data/mcu/`. It is flashed if it differs from the current one
  (downgrades included), or when the bridge does not answer within 4 s.
- SignalDeck must never create `/sdcard/intercom/dmr/`, and must keep the stock app from running against a module that
  does not answer.

### Bridge MCU path

- `extUpdateMcu`: `usb_path` 1, **`rstmcu` 1**, `mcu_power` 1, then `sh /vendor/bin/auto_update <path>`, then all
  three back to 0.
- *Inferred:* `rstmcu` selects the STM32 ROM DFU at power-up.
- `auto_update`: `sleep 1.5`, then `dfu-util -d 0483:df11 -a 0 -s 0x08000000 -D $1`, then
  `extcmdtest -u0 -p0 -r0`.
- `extcmdtest`: `-u` / `-p` / `-r` / `-h` write `usb_path` / `mcu_power` / `rstmcu` / `handle_ptt`; `-c` reads
  `/dev/stmcu`. With no arguments it sends `0x34` five times.
- This is the bridge MCU, not the DMR module.

---

## 10. Open questions

1. **The running image.** V067/V080/V082 against V076: everything above is V076-only. A listen-first bootloader
   capture, an opcode-12-style read or a physical dump is the prerequisite.
2. **The bootloader** (flash `0x03000000–0x03019FFF`): its menu, its size limit, whether it checks anything, and
   whether `'2'` uploads. It is not in any file we hold.
3. **The bridge** (STM32 `20201016161541.bin`): does it translate `7E 96 69` route-01 envelopes into `68…10` on the
   module UART, and map the module's `sr` into the reply body? This decides how the `0x3B` sr = 1 and the `0x22`
   refusal (no reply) look to the host.
4. **`0x3B` sr = 1:** a vendor bug, or does the bridge or app treat it as success? Measurable on the phone with the
   Armor-style `0x3B` byte → key-length test.
5. **C7000 FM register semantics on V076.** What are the exact bits written to `0x11000510/0x51C/0x520/0x528/0x530`?
   Where is the analog squelch decided? What does wake-site-B's callee `0x3870` do?
6. **`0x2C` header length:** whether V076 eats characters with the app's 5-byte header, as the Armor does.
7. **RAM for new flags:** prove the object at `0x4AD58`–`0x4BD28` (or another gap) is unused.
8. **Bridge-side:** the antenna sensor and temperature gates are the app's, not the module's. SignalDeck has to
   decide whether to mirror them.
