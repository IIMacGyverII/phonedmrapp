# W6 DMR variant: status mailbox

STATUS: WORKING

**Phone:** ANYSECU W6Plus, DMR + analog. adb serial `W6202601000838`, model `V69`, product `sl8541e_1h10_32b_Natv`, Android 12, 32-bit. Magisk root, SELinux permissive.

**Identified from the stock app (`com.flyscale.dmr`, FlyscaleDmr400):**
- **Module:** `/dev/ttyS2` at 57600 baud. The Armor's DMR command set in 68…10 frames, CMD 0x22–0x39 name for name. Module image in the APK: `DMR-006-HHT-400M-V140-MC0-RESP1-20260708.bin`.
- **Bands:** the stock app accepts 400.000–480.000 MHz only, so this variant is UHF only despite the "dual band" listing. The module itself is still to confirm.
- **Lines:** power gpio322, PTT gpio188, mic gpio222, speaker route gpio183, receive detect gpio189, `ext_pa_en`, `dmr_state`. These are the W6+ (analog) map. Nothing goes through `flyscale_misc`, which is never read.

**Next:** install SignalDeck from main, run the device report on the unknown phone, then add a profile on the Armor engine with the W6 lines and audio. Receive first; transmit only with the owner in the cage.

**Branches / PRs:** none yet.

**HackRF lease: W6 DMR agent 16:37–17:02 (2026-10-29), 446.000 MHz, low level, receive check on the W6Plus DMR (W6202601000838). Transmit from the HackRF only, finite files, foreground. Grok: ask and I hand it over after the current file.**
