# W6 DMR variant: status mailbox

STATUS: WORKING (17:15 Claude: PR 105 merged; next: device-report PR)

**Phone:** ANYSECU W6Plus, DMR + analog. adb serial `W6202601000838`, model `V69`, product `sl8541e_1h10_32b_Natv`, Android 12, 32-bit. Magisk root, SELinux permissive.

**Identified from the stock app (`com.flyscale.dmr`, FlyscaleDmr400):**
- **Module:** `/dev/ttyS2` at 57600 baud. The Armor's DMR command set in 68…10 frames, CMD 0x22–0x39 name for name. Module image in the APK: `DMR-006-HHT-400M-V140-MC0-RESP1-20260708.bin`.
- **Bands:** the stock app accepts 400.000–480.000 MHz only, so this variant is UHF only despite the "dual band" listing. The module itself is still to confirm.
- **Lines:** power gpio322, PTT gpio188, mic gpio222, speaker route gpio183, receive detect gpio189, `ext_pa_en`, `dmr_state`. These are the W6+ (analog) map. Nothing goes through `flyscale_misc`, which is never read.

**Measured (2026-10-29, nothing keyed):**
- **Module:** answers `DMR006.U4A.V140`, the Atom XL's family on a plain UART. `stty` sets 57600.
- **Signal readings:** they work.
- **Bands** (0x23 writes):
  - 400–480 MHz: acknowledged.
  - 399.995 / 395 / 136 / 174 MHz: never answered (UHF only).
  - 480.005 / 485 MHz: acknowledged, but receive there is unmeasured.
  - bandsHz is 400–480.
- **HackRF, 446.000 MHz:**
  - the module's RECEIVE_START / RECEIVE_STOP drive the W6 receive lines;
  - the camcorder input carries the audio, 12 dB louder than the W6+ (gain 4);
  - the built-in Soft SQ table separates static from transmitter-like speech;
  - CTCSS reaches the audio.
- **Import:** 128 stock channels and the DMR ID came in.

**Review:** SignalDeck PR 105 (`w6dmr/profile`): https://github.com/IIMacGyverII/SignalDeck/pull/105. Untested profile: Take over only, no transmit; `moduleLoader=false`. Host suite 520 / 0.

**Next (mine):** a device-report PR. It should read the power and PTT lines from the stock app's named fields, and stop the SA818 hint when the code also has the 68 … 10 command enum.

**Owed by others:**
- **Owner:** listening check, side-key press, transmit in the cage.
- **Cage:** a DMR source (hotspot or a HackRF replay) for DMR receive.

**HackRF lease: W6 DMR agent 16:37–17:02 (2026-10-29), 446.000 MHz, low level, receive check on the W6Plus DMR (W6202601000838). Transmit from the HackRF only, finite files, foreground. Grok: ask and I hand it over after the current file.**
**HackRF lease ended 16:41: HackRF free (W6 DMR agent; no transfer running, finite files only, 446.000 MHz).**

**HackRF lease: W6 DMR agent 17:06–17:26 (2026-10-29), DMR receive check on the W6Plus DMR: replaying Grok's 6 s factory_dmr.iq (bench ID key, CC1 TS2 TG 9) with the carrier on 446.000 MHz, low level, finite, foreground. Grok: ask and I hand it over after the current file.**
**HackRF lease ended 17:08: HackRF free (W6 DMR agent; one 6 s replay of factory_dmr.iq at -x 30, no transfer running).**
