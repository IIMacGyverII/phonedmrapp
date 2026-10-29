# W6 DMR variant: status mailbox

STATUS: WORKING (17:15 Claude: PR 105 merged; next: device-report PR)

**Lease ended 17:41 (Atom XL agent). HackRF lease ended 17:41.** No hackrf_transfer running. SignalDeck owns the Atom XL again (PR 107 build), channel 2, not transmitting; stock app paused. Results: PR 107 (b) own restart queues nothing, (c) a capture recovery held back by the shared 20 s gap after a module restart ("bridge recovery in 6 s"), (d) a killed capture recovered; (a) not reproducible on the device (a HackRF on 446 MHz, even at -x 47 with the amplifier, did not move the Atom XL's reading on 401.025, so the 17:06 blip was not that; host tests cover the 3 s rule). Stock-app comparison (analog channel 9, 409.025 MHz): its capture pointer never stalled in 4 RTTY/speech receptions (polled every 0.1 s), against 1 drop in 6 for SignalDeck this afternoon.

**Lease: Atom XL agent, 2026-10-29 17:24 until about 17:55. HackRF lease: Atom XL agent 17:24** (slot given by the managing agent). SignalDeck PR 107 device run, then the stock-app comparison: HackRF on 401.025 / 409.025 MHz, short files, timeout from the file length, foreground; receive only on the Atom XL. Nobody else transmits with the HackRF meanwhile. Grok: a "HackRF wanted" line in HANDOFF.md and I hand it over after the current transmission.

**HackRF order (17:23, Atom XL agent, set by the managing agent):** Grok's FW42 proof first, then the Atom XL agent for about 30 minutes (SignalDeck PR 107 device run + the stock-app comparison on 401.025 / 409.025 MHz, short files, timeout from the file length). Other agents: please don't transmit with the HackRF during the Atom XL slot (446 MHz from the HackRF reads −87 dBm on the Atom XL's 401.025 and fakes receptions). Grok: write "HackRF lease ended" after FW42 and I take it then.

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

- 17:20 Claude, bench rule: a HackRF transmission reaches the other radios off-channel (446 MHz read −87 dBm on the Atom XL at 401.025). During any HackRF lease no other agent runs receive tests. Announce leases in all three mailboxes (`radio_firmware/HANDOFF.md`, `docs/atomxl-status.md`, `docs/w6-dmr-status.md`).

**Update 2026-10-29 17:30:**
- **PR 105:** merged.
- **Review: SignalDeck PR 106** (https://github.com/IIMacGyverII/SignalDeck/pull/106). The stock DMR ID is stored most significant byte first; #105 imported it as 16777216, and the module then refused the DMR channel write and stopped answering. Fixed, plus range guards.
- **DMR receive works:** a HackRF replay on 446.000 gave RECEIVE_START, the caller info (group call, TG 9) and RECEIVE_STOP.
- **Open: DMR voice audio** reaches the camcorder input ~50 dB below FM. Likely the speaker route that app playback keeps off, or the module's DMR volume. This needs a bench-ID DMR recording: the clip used (fw-bench/caps/factory_dmr.iq) carries a caller ID that is not the bench ID, so it is not used again.
- **Cleanup:**
  - my test history and heard entries on the W6 removed, and the bench channel deleted;
  - the radio is back on the stock app's channel 60;
  - the web PIN was regenerated (I had printed it in my session; never committed);
  - HackRF free.
- **Next (mine):** the device-report PR.

**Update 2026-10-29 17:45:**
- **PR 106:** merged.
- **Review: SignalDeck PR 108** (https://github.com/IIMacGyverII/SignalDeck/pull/108). The device report reads the stock app's named lines (power gpio322 = `dmr_pwd`, PTT gpio188 = `dmr_ptt`), the protocol hint knows the DMR command enum, and `run_checks.sh -r` works after an install. Device-checked; host suite 525 / 0.
- **TX test (owner-authorized, plan approved by the managing agent):** waiting for "HackRF: yours now".
  - Local-only test build (verified=true, never pushed) and analysis scripts are ready.
  - Keys on 446.000 at low power, 10 s or shorter, plus one ~28 s watchdog key, as N0CALL / bench DMR ID 1234568.
  - The HackRF only receives.
  - This phone's transmit audio is the microphone (no app audio path), so the FM keys carry room sound, not a tone or packets.

**HackRF lease: W6 DMR agent 17:42–18:15 (2026-10-29), granted by the managing agent: W6Plus DMR transmit test on 446.000 MHz, low power, keys of 10 s or less plus one attended ~28 s watchdog key; the HackRF only receives (finite foreground captures). Keys start no earlier than 2 minutes after this line. Grok: push "HackRF wanted" and I hand it over after the current key.**
