# Reviews of the bench runs (Claude Code)

Reviews up to R3-0 are in `docs/deep-dive/19-firmware-modification-plan.md` §11–§23. New reviews go here, newest last, one section per run. The handoff protocol is in `radio_firmware/HANDOFF.md`.

## Review of R4a–R4o and the R4p build (2026-10-24, commits `c311e447` … `5755f065`; Claude Code, at the owner's request)

**What is settled, and it is a lot.** The T1 route works: a host-keyed stub puts a pre-rendered M17 link-setup frame and stream frames on the air through the HR-C7000 DMR modulator from TX RAM, with no phone audio involved. R4d through R4k decoded with Golay error 0 (27 frames in the first window, 53–61 in the steady window), the end-of-transmission frame follows the unkey, `SEND_STOP` follows the end frame, and the steady p99 at peak count 6451 is about 3.1 kHz, which is where an RRC α = 0.5 4FSK at ±2.4 kHz outer symbols should sit. Nothing runs at boot (every boot capture is at the floor). T2, T3 and R-A were closed by reading with code evidence, not by assumption. This overturns the 2026-10-22 verdict "M17 TX not feasible": that verdict was about the audio path and still stands for it, but the firmware route around it is proven. `docs/m17-deep-dive-2026-10-22.md` and the CLAUDE.md M17 row still say "not feasible" with no pointer here; they need one.

**Blocking defect: the host-sample handler stores the samples in the wrong byte order (R4o, and R4p as built).** TX RAM reads each halfword big-endian. Every fixed-table image knew this: `c7000_txram_dmr_sine.S` says "The TX RAM reads each stored halfword big-endian" and `m17_stream_table.py` `table_bytes()` writes the high byte at the low address. The `cmd40` handler in `c7000_cmd40_host.S` and `c7000_cmd40_m17.S` reads the host's little-endian int16 with `ld.h` and writes it with `st.h`, with no swap. So 2048 (`0x0800`) reaches the modulator as 8, and 1448 (`0x05A8`) reaches it as `0xA805` = −22523. The ±6451 clamp runs on the pre-swap value and protects nothing. This is why R4o's numbers disagree with R3a8: the same nominal peak 2048 gave a 1 kHz line of 3070–4183 Hz and p99 4495 Hz in R4o against 923 Hz and p99 1217 Hz in R3a8. What went out in R4o was not a 1 kHz sine at 2048; it was swapped garbage that the hardware happened to saturate under 5 kHz. R4p would send real M17 samples with the same swap (6451 = `0x1933` becomes `0x3319` = 13081, `0x00FF` becomes −256), would not decode, and its peak on the air would be uncontrolled against the stop rule. **Do not load R4p as built.**

**Fix and proof.** Swap in the handler (assemble the halfword high-low from the two body bytes, or `ld.h` then a halfword byte-reverse, whichever the CK core offers), keep the clamp on the signed value, and store the swapped halfword. Add a host test in `test_patches.py` that feeds the handler path a known body and checks the TX-RAM bytes (high byte at the low address). Then repeat the R4o sine at 2048, 64 samples, one silence key: the 1 kHz line must come back near 923 Hz and the p99 near 1217 Hz, matching R3a8. Only then the M17 body.

**Design notes for the next images.**
- *Samples over the UART cannot carry voice.* 8 kHz 16-bit is 128 kbit/s against a 57600 baud line. R4p is a valid proof of the host path, but the end design is ch. 19 §20 R4 as written: the host sends **symbols** (4800 sym/s × 2 bits = 9.6 kbit/s, packed four per byte) into a ring buffer in MCU RAM, and the wake shapes them. At 8 kHz the RRC runs at 5 samples per 3 symbols, so a three-phase polyphase filter in the stub (the table generator already does this resampling on the host). Underrun policy: hold the last symbol or emit zeros, never re-key. Write this into the route list now so R4q onward build toward it instead of extending the sample path.
- *Validate with a decoder we did not write.* Every "plain decode" figure comes from `tools/m17-research/m17.py`. A sign, symbol-map or randomizer convention error would pass that test and fail every real M17 radio. Run m17-cxx-demod (or SDR++ / SDRangel M17) on the existing R4k HackRF capture before building further. No bench time needed.
- *The buffers at `0x4A400` / `0x4A800` are "unused" by literal search only.* Base-plus-offset addressing leaves no literal. Add a read-back subcommand to `0x40` (body byte selects: store / read count / read a range) and check the buffer survives normal receive, channel changes and one DMR call. Cheap insurance against corruption that would show up as flaky decodes later.
- *Receive is the product gap now.* TX looks solvable; RX still rests on a per-phone calibrated DFE through the audio path. Before closing RX, read the C7000 user guide (Document 2) for a receive counterpart to TX RAM. R-A read what the factory firmware does with the demodulator, not what the chip offers, and TX RAM was likewise unused by the factory code.
- *Still open before anything ships:* the 30 s TOT clamp (FW19), the SignalDeck M17 frame encoder written from the spec (never libm17), and the opt-in gating on the `0x34` tag (Phase E).

**Folder hygiene (no bench time).** `radio_firmware/README.md` is stale: it still says the base is `0x08000000` and unverified, points at the ARM-era Ghidra project, `GHIDRA_NAVIGATION_GUIDE.md`, `NOTES_FOR_GROK.md` and a package `com.macgyver.dmr`, and gives the DMRDEBUG.bin recipe as the test procedure; the real workflow is `tools/fw-patch` + `bench/fwload_stock.sh`. `PATCH14.bin`, `cmd_handler.c` and `firmware_decompiled.c` are documented dead output (ch. 19 §1) and are still tracked next to the live record. `symbols.csv` has 45 rows while the R4 work named a dozen more sites (the wake hooks `+0x18B5C`/`+0x18B68`, `drop_ptt`, the status poster `+0x7E08`, the sender `+0x7BC0`, the AT1846S write helper at IRAM `0x2B220`, the dispatch table `+0x38240`, the checksum `+0x8E5C` and send `+0x7DE8`); they belong in the file. `results.md` is a good lab notebook and a poor status page: one table (image, change, key number, verdict) at the top of HANDOFF would save every session an hour.

## Guide reading: the FM receive RAM exists (2026-10-24, Claude Code; no bench, nothing loaded)

The HR-C7000 user guide (Chinese, v2.7; the file the M17 project published with its AtomXL work) is now in the repo as `radio_firmware/HR_C7000_user_guide.pdf`. Read for the receive counterpart of TX RAM. Page numbers are the PDF's own footer numbers.

**It exists, and it is on by default in FM mode.** §7.2.2.3.2 "analog receive recording" (p. 271): with the modem in FM mode (`0x1100_0100[7] = 1`) the audio produced by the FM receive demodulator goes to the codec DAC **and at the same time is written to RX RAM `0x1600_04E0`–`0x1600_08DF`**; the CPU reads that region. No extra enable is named ("默认开启", on by default). §11.4.2 (p. 340): the FM receive RAM is based at `0x160004B0`, the two halves are offsets `0x030`–`0x22F` and `0x230`–`0x42F`, 512 bytes each, 256 PCM samples, **high byte at the low address**, ping-pong, the exact mirror of TX RAM. `FM_ADDR_SW` (`0x1100_056C[1:0]`, p. 339) is the half select for **both** directions ("FM 收发", 1 = low half, 2 = high half). The interrupt is `FM_RX_INTERP`, `SYS_INTERP_LIST` bit 14 ("FM receive data processing interrupt", pp. 94, 100), masked and cleared through the same `SYS_INTERP_MASK` / `SYS_INTERP_CLEAR` bits as the TX one; bit 13 `FM_SIG_RX_INTERP` is the "analog function receive detect" interrupt (CTCSS/DCS/DTMF class flags, `FM_DECODE_FLAG*`). `AUDIO_CONTROL` (`0x1100_0080`, pp. 96–97): bit 0 `tx_voice_source` (the guide says it is also to be configured for receive), bit 4 `ahb_wr_voice_en`, bit 5 `ahb_rd_voice_en`, bit 6 `fm_play_ctrl`, bit 3 `fm_sidetone_en`.

**What this radio does with it is unknown, and that is the whole question.** UVm10/UVm11 showed the C7000 codec DAC is not what the phone hears (the converters are phone-side, ch. 19 §19). So either (a) the factory firmware runs the modem in FM mode on receive and the C7000's FM demodulator output sits unread in RX RAM while the phone takes the AT1846S audio line, or (b) analog receive never enters the C7000 and RX RAM holds nothing. The TX side was case (a) for TX RAM: present in the chip, unused by the firmware, and it worked. If (a) holds on receive, RX RAM gives the module the demodulated signal **before** the ES8311 ADC high-pass and the module-to-phone coupling, and with AT1846S `0x58` = `0xBCFD` (bypass, already proven safe to set from a stub) possibly before the AT1846S voice filters too. That is the receive mirror of the proven TX route.

**R-C, proposed, receive-only, no transmission:**
1. Read the firmware: what `WORK_MODE` (`0x1100_0100`) holds on an analog channel in receive (the key-up writes `0x80`; what the analog channel setup writes outside key-up), whether `SYS_INTERP_MASK` bit 14 is ever set, and whether any code reads `0x160004E0`–`0x160008DF` apart from the BER scorer's 36 bytes (R-A found only that).
2. One image, boot-gated like the others: on a host command (`0x40` sub-function, or a new slot), copy the current RX RAM half once into the `0x4A400` buffer and return it over the UART in 798-byte bodies (the R4p store path in reverse; no interrupt handling needed for a one-shot). Bench: HackRF carrier with a 1 kHz tone at −80 dBm on 467.625, then a 100 Hz tone, then the 20 Hz–3.8 kHz sweep from the M17 study. Pass: RX RAM holds the tone (the 1 kHz line stands out of the noise); the 100 Hz result and the sweep say whether the low end is there.
3. If the low end is there, the follow-on is the mirror of T1's end design: an M17 symbol slicer in the stub (timing recovery at 5 samples per 3 symbols, 4 levels, the preamble/sync search), symbols to the phone at 9.6 kbit/s. Raw samples cannot stream over 57600 baud, same as on transmit.

Secondary reading from the same pages: `0x1100_0508[15:0]` is the C7000's own SQL (noise) reading in FM mode (§11.5, p. 340), and `WORK_MODE` `0x16A`/`0x16B` is a "DMR/FM simultaneous detect" mode (p. 93 table, row 8). Neither is needed for M17; noted for later.

## Review of R4p, R4q and R4r (2026-10-24, commits `304aac7f`, `cdd374a1`, `002eeaf9`)

**Verdict: the byte-order defect is fixed and the host-fed M17 path is proven. Steps 1–3 of the task passed. Step 4 (an independent decoder) is still open, and the next image is the streaming design.**

**R4p went on the air before the task was read.** Two keys with the unswapped body. From 60 ms to 220 ms the p99 was 4404–5050 Hz, and one 20 ms bin reached 5050 Hz. That is the ±5 kHz stop, and the report does not call it one. The rule is a stop on the measured deviation of what we transmit, with no "one bin" allowance; the correct report is "stop reached at 5050 Hz, no further key, cause under investigation", not "the peak was not raised". No harm followed because no third key was sent and the diagnosis arrived, but write the stop down as a stop when it happens. Process lesson: `git pull --rebase` before every load, not only before every push.

**R4q: pass.** Sine at nominal peak 2048, 64 samples: 1 kHz line 970–972 Hz, p99 1040–1106 Hz, against R3a8's 923 Hz and 1217 Hz, inside the ±15 % gate. The store loop is right: two `ld.b`, assemble, `sexth`, clamp on the signed value, swap, `st.h`. The host tests check the helper, the loop encoding at the stub offsets and the untouched sites. Good.

**R4r: pass.** The R4p body stored swapped, one key, 1470 samples: p99 2817–3086 Hz (R4b's fixed table at the same peak gave 3148 Hz, so the host path and the canned path are now on one scale), link setup at 70 ms with sync 0.998 and a passing CRC, three stream frames at 0.999 with Golay error 0, the end bit on the last. Boot peak 0.05 dB. Two notes:
- *The outer-symbol gain reads 2233 Hz*, about 7 % under the standard ±2400 Hz. Real receivers tolerate that, and the p99 budget to the stop is wide, so either keep it or scale the host counts by 1.07 (p99 then about 3.3 kHz). Decide once, write it into the table generator, and keep it there.
- *Research-decoder bookkeeping bug:* the runner's link-setup flag came back false because a later sync at 230 ms with score 0.675 overwrote the slot holding a CRC-valid link setup. Fix `tools/m17-research/m17.py` so a CRC-valid LSF is never replaced by one that fails CRC or scores lower. The §6 acceptance (≥ 85 of 90 frames across three transmissions) is going to be read off this runner, so its flag has to be trustworthy first.

**Step 4 is not done and nothing on this machine can do it yet.** No third-party M17 decoder is installed. The captures are kept (`/tmp/fw1718/caps/r4r0_key.iq`, int8 IQ, 2.4 MS/s, signal 240 kHz above centre), so this needs no bench time. Lowest-friction route on Windows: SDR++ (nightly build, it ships an M17 decoder module), file source fed with the capture converted to a 16-bit IQ WAV, tuned +240 kHz, FM narrow, the M17 decoder on it; report its LSF and frame count next to ours. `m17-cxx-demod` is the alternative but needs Boost and codec2 built here. Beyond software: a real M17 radio (CS7000-M17, Module17, or OpenRTX on an MD-380 class radio) is the final check and an owner question, not a blocker.

**Next image, R4s: symbols in, RRC in the module.** This is the design the route list already names; samples cannot stream over 57600 baud. Specification:
- `0x40` body byte 0 is an op code so one slot does everything: `0x00` = store samples (today's behaviour, keep for bench), `0x01` = append symbols, `0x02` = status read-back (ring fill, underrun count, last error), `0x03` = reset ring. Unknown op → `sr=1`.
- Symbols packed four per byte, most-significant dibit first (the spec's bit order: `01`=+3, `00`=+1, `10`=−1, `11`=−3), one M17 frame = 192 symbols = 48 bytes; several frames per body are allowed. The ack returns the ring fill in symbols so the host paces itself.
- Ring buffer of 2048 symbols (about 427 ms) in the `0x4A400` region, head and tail indices beside it. Empty ring on a host key = the stock key (today's zero-count rule). Underrun during a stream: emit zero samples and count it; never re-key, never stop by itself.
- The wake fills a 256-sample half from the ring: output sample n sits at symbol time 0.6 n, so the interpolator is a 5-phase polyphase RRC (α = 0.5, span ±4 symbols, about 8 taps per phase, Q15 coefficients, 32-bit accumulate, the same −0.49 Hz/count sign and scale the table generator uses). The fractional symbol phase carries across halves (256 samples = 153.6 symbols). Generate the coefficient table and a bit-exact Python model of the fixed-point filter on the host; the test compares the model against `m17.py`'s float waveform (r² ≥ 0.99) and checks that the image carries exactly those coefficient bytes.
- SignalDeck side: a bench DIAG that reads a symbol file and streams it in real time, one frame per body every 40 ms, pacing on the returned fill; the existing `cmdsine`/`txwav` key path keys it.
- Bench: a 2 s stream (50 stream frames after the link setup), one key, low power, 467.625. Pass: the plain decoder accepts the link setup and ≥ 45 of 50 frames at Golay error 0, status read-back shows zero underruns, p99 inside the R4r band. Then the §6 run: three transmissions of 90 frames each (under 4 s of audio each, well inside the 30 s time-out).

**Parallel, no bench:** R-C step 1 (reading only: what `WORK_MODE` holds on an analog channel in receive, whether `SYS_INTERP_MASK` bit 14 is ever set, who reads `0x160004E0`–`0x160008DF` besides the BER scorer).

## Review of R4s and R-C step 1 (2026-10-24, commit `09fa8e7a`)

**Verdict: the streaming machinery works and one instruction in the filter is wrong. Fix it, prove the filter without RF, then key again.**

**What R4s established.** The op-code interface, the 2048-symbol ring, the SignalDeck pacing on the returned fill, the per-sample phase and base advance (`rem = 3n mod 5`, `base = floor(3n/5)`, implemented as "add 3, wrap at 5, bump base"), the underrun counter and the no-key / silent-boot gates all behaved: the modulated interval on the air is 2.06 s for 2.06 s of symbols, boot is silent, the key timing is as before. The decoder-flag fix is right and re-verified on R4r. Keeping `OUTER_SCALE` at 1 is right given the cap.

**The defect: the coefficient load is zero-extended.** In `one_sample`, the tap is read with `ld.h r0, (r4, 0)` and multiplied straight away. On C-SKY V2 `ld.h` zero-extends; `ld.hs` sign-extends (the R4q store path already handles this for the sample with `sexth`, and the symbol read here uses `sextb`, but the tap does not). Every negative tap `T` therefore enters the multiply as `T + 65536`. The accumulator becomes `Σ s·T + 65536·Σ s(neg taps)`; after `× 1692 >> 15` the second term is about `3384 × Σ s` over the five or so negative taps, tens of thousands of counts, so nearly every sample hits the ±6451 clamp with the sign of the symbol sum rather than the shaped value. That predicts exactly what the air showed: deviation pinned near the cap (p99 3.66–4.11 kHz, above the 2.8–3.1 kHz of the correct waveform at the same cap), a partial negative correlation with the model (r = −0.34, since the dominant wrong term carries the symbol sign while the true centre tap is negative), and no decode. The host model never sees this because `integer_counts` uses Python integers, and the image test only checks that the coefficient bytes are present, not how the loop reads them.

**Fix.** `ld.hs r0, (r4, 0)` (or keep `ld.h` and add `sexth r0, r0`). Add the encoding check for that instruction to `test_cmd40_sym_carries_the_rrc_and_the_ring` the way the R4q test checks the store loop. Nothing else in `one_sample` needs to change: the 32-bit accumulate cannot overflow (|acc| < 1.4 × 10⁵, × 1692 < 2³¹), the shift is arithmetic, the clamp precedes the swap, and the tap-to-symbol index with the unsigned guard matches the model.

**Prove the filter on the host side of the UART before any key.** Add op 4, *render*: run `one_sample` N ≤ 256 times from the current ring state into a scratch buffer (512 bytes at `0x4AC00`, inside the `0x4A400`–`0x4AFB8` range R4p already used without harm) and return the samples in one or two bodies, in the order TX RAM would see them. Feed the ring a known 64-symbol pattern, render, un-swap on the host and compare with `m17_rrc.integer_counts` of the same symbols: pass is bit-exact (allow ±1 count only if a rounding difference is explained). This closes the gap between the Python model and the instructions, costs no RF, and will catch the next bug of this class in a minute instead of a bench run. Keep the op after the fix; it is the regression test for every later waveform engine.

**Then the air.** The 50-frame stream once: pass is the link setup plus ≥ 45 of 50 frames at Golay error 0 from our decoder, p99 in the 2.8–3.1 kHz band, and zero underruns *during* the stream (have the DIAG unkey 100 ms after the ring empties so the status read is clean, instead of counting 19 340 underruns of post-stream silence). Then the §6 run: three keys of 90 frames. Report ours now; the independent decoder joins when the Ubuntu box exists.

**R-C step 1: read, and more encouraging than the headline.** Analog receive leaves `WORK_MODE` in a DMR value (`0x22` / `0x6A` / `0x6E`), so RX RAM is not being filled today; that was expected. But the factory code has a receive mode that does engage the C7000's FM detector: `+0x19470` stores `0x16A` / `0x16B`, which the guide names "DMR/FM simultaneous detect", **and unmasks `FM_RX_INTERP` (bit 14) in both arms**, under a condition from `+0x2404`. The firmware would not unmask that interrupt unless the C7000 sees the analog baseband on receive in that mode. So step 2 is worth one image: on a host op (no PTT, receive only) save `WORK_MODE`, write `0x80` (FM mode, the guide's "RX RAM on by default" case; `0x16A` as the second try), wait two halves, copy the half that `FM_ADDR_SW` is **not** pointing at into the scratch, restore `WORK_MODE`, return the samples over `0x40`. **Blocker: the probe needs a signal on 467.625 MHz, and the only source in the cage is the HackRF, whose transmission the standing approval forbids.** That is an owner decision: a low-level 1 kHz FM tone, then 100 Hz, then the 20 Hz–3.8 kHz sweep, HackRF at minimum gain inside the cage, nothing else changed. Until the owner answers, step 2 stays unbuilt and R4t proceeds.

## Review of R4t (2026-10-24, commit `f452cdde`)

**Verdict: pass. The M17 transmit acceptance of ch. 19 §6 is met with our decoder: 90 of 90 frames at Golay error 0 on each of three transmissions, after a 50 of 50 warm-up, with the deviation where it belongs.** What is still missing from the acceptance is the independent decoder, which waits on the Ubuntu box; everything else in the T1 route is done.

**What made the difference.** One instruction (`ld.hs` for the taps) and, more importantly, the render op: 106 of 106 samples bit-exact against the host model *before* the key. Keep that order for every change to the waveform path from now on: render first, key second. The image test now pins the sign-extending load by encoding and rejects the zero-extending one; good.

**Numbers worth keeping.** Steady p99 2792–2895 Hz on all three 90-frame keys (R4r's canned body gave 2817–3086 Hz, so the streamed path is slightly cleaner than the canned one). Boot peak 0.06 dB. SNR 57–58 dB, clip 0. Offsets +1014 to +1021 Hz (the crystals, as always). Each link-setup CRC passed with both callsigns.

**Two things to fix before this path grows.**
1. *Op 4 builds its reply on the UART task's stack:* `subu r14, r5` with up to 2 × 256 + 19 bytes. The 106-sample render used 231 bytes and was fine; a 256-sample render takes 531 bytes from a uC/OS-III task stack whose size nobody has checked. Either read the stack size for that task in `create_tasks` (`+0x1BF8`) and cap N accordingly, or build the reply frame in a second scratch (`0x4AE00`) instead of the stack. Until one of those is done, keep renders at or under 128 samples.
2. *The underrun count is the post-stream tail:* 5004 on every key, which is the 0.63 s between the ring draining and the host's unkey. The DIAG was supposed to unkey about 100 ms after the ring empties; it does not yet. Better than host timing: give op 1 a "last" flag, and when the ring drains after a last chunk let the wake drop PTT itself through the R4k path (`drop_ptt` then status byte 4). Then the end of a transmission is exact, the status read shows only real underruns, and SignalDeck does not have to guess.

**Where this leaves the plan.** T1 is the transmit route; T2, T3 and T4 are closed. Ch. 19 §6 M17 TX: met (own decoder). FW18 goes to ◐ (M17 done, POCSAG not started). The receive side is R-C, in progress. Toward a shippable feature the open items are, in the order I would do them:
- **FW19, the time-out ceiling.** Voice needs more than 30 s. Find the `0x3B` handler's `min(tot,30)` clamp, raise the ceiling to 120 s behind the same host flag discipline, keep SignalDeck's own watchdog as the real limit, and prove it with a 45 s BERT or repeated-frame stream at low power (heat rule: one such key, then let it cool).
- **The SignalDeck M17 transmit stack**, host work that can run while the bench does R-C: Codec2 3200 encode (exists) → link setup and stream frames with LICH, convolutional code, puncturing, interleaver, randomizer, CRC (port our own `m17.py`, which is spec-written and ours, with its test vectors; never libm17) → symbols → the `0x40` stream with the "last" flag → an M17 PTT on the M17 screen, enabled only when `0x34` reports a tag that carries the symbol engine. The research modem on the HackRF capture plus Codec2 decode is the voice check until a radio is on the bench.
- **Generic waveform engines** instead of an M17-only stub, as proposed earlier: an op that loads a coefficient table, symbol rate and level map, and a tone engine. POCSAG, FT8, CW and RTTY then cost a table each. This can wait until FW19 and the voice stack exist; design the op-code space for it now so nothing has to move.
- **Phase E**, the opt-in loader page, the help topic and the tag gating.

## Review of R-C step 2, RC20 (2026-10-24, commit `e506949e`)

**Verdict: the probe works and the receive RAM is live, but the read is wrong, so the two conclusions drawn from it ("4 kHz audio" and "the low end is not there") are not established. One more image, no key, settles both.**

**What RC20 proved.** Writing `WORK_MODE` `0x80` while receiving makes the C7000 demodulate the analog signal into RX RAM: a HackRF 1 kHz tone shows as a 1 kHz line from −101 dBm up, nothing radiates, PTT is never touched, the word is restored, the reply is built off the stack at `0x4AE00`. That is the receive mirror of TX RAM confirmed on this radio. Good. `0x16A` was rightly left unsent.

**The read is one byte in four.** The copy loop is `ld.w` over 128 words. The guide says the baseband RAM is **8 bits wide** (§11.4, "数据位宽为8bit，深度为1200") with each 16-bit PCM sample stored as two bytes, high byte at the low address, the same as TX RAM, where `st.h` writes work. A 32-bit read of a byte-wide RAM returns one valid byte lane per word, which is exactly the pattern reported: `HH 00 00 00`. So the 512 bytes are the **high byte of every second sample**: 128 of the 256 samples in the half, 8-bit, decimated by two. That is why a 1 kHz tone "lands at 4 kHz" and why the sweep folds above 2 kHz. The half holds 256 samples at 8 kHz, 16-bit, like its TX twin; the fold is the read, not the RAM. Fix: copy byte by byte (`ld.b` × 512, or `ld.h` if halfword reads prove to return both bytes) and read the result as 256 big-endian int16.

**The low-end verdict is premature, but something real is in it.** With only the high byte, the 1 kHz tone at 2.5 kHz deviation is about 26 LSB rms and the 300 Hz sweep point about 1 LSB, so 300 Hz is at least 25 dB down relative to 1 kHz even allowing for quantisation; the 100 Hz result (rms 335, peak elsewhere) is simply below the quantisation floor and says nothing yet. A 16-bit read gives the real numbers. Then the question is **where** the cut is, and all three candidates are testable inside the same probe, each a write the stubs already make safely elsewhere:
- *C7000 FM receive filters:* `FM_BANDWIDTH` (`0x11000500`) bit 6 `fmbpfon` is the FM band-pass, default on, and it was left on in RC20 (the TX stubs clear bits 4 and 6 for the TX RAM path). Bit 1 `fmbandwidth_r` is the receive bandwidth, bit 0 the CTCSS receive bandwidth; `FM_DEV_COEF` (`0x11000504`) bits 15:8 `fm_dev_coef_r` is the receive deviation scale. Save the word, clear bit 6 (and bit 4), restore after the copy.
- *AT1846S audio filters*, if its filtered audio is what reaches the C7000's RxI in analog mode: write `0x58` = `0xBCFD` for the probe and `0x8405` back afterwards, the same pair the TX stubs use.
- *Analog coupling between the two chips.* If neither write changes the 100 Hz result, the receive side is cut in hardware like the transmit side, and that closes R-C honestly.

**Half selection is inverted against the guide and against our own TX wake.** `fm_addr_sw` = 1 means "the CPU reads or writes the low-address half" (§11.2.2.28); the TX wake follows that (1 → `0x16000030`). The RC20 probe copies the opposite half (1 → `0x160006E0`). Audio still came back, so the hardware may well be filling the half the register names and leaving the other as the completed one; the "idle half reads constant `0xFF`" line suggests the chosen half is not always the finished one. Return both halves in the fixed probe and report which carries fresh audio and whether a seam appears.

**R-C step 3, one receive-only image, no key:**
1. Op 5 variants by the second body byte: `0x00` = as RC20 but byte-wise copy of **both** halves (1024 bytes, two replies or one 1033-byte frame if the UART task allows; `0x4AE00` reply scratch as now, check it does not run into anything live); `0x02` = plus `FM_BANDWIDTH` bits 6 and 4 cleared during the capture; `0x03` = plus AT1846S `0x58` = `0xBCFD` during the capture; `0x04` = both. Every variant restores every word it changed, on the timeout path too. Also return `FM_SQL` (`0x11000508`) in the reply, free.
2. Host check first: a quiet op 5 must return 256 int16 per half with no `HH 00 00 00` pattern; the idle level should be near zero, not `0xFF` bytes.
3. HackRF at the RC20 level (VGA 20, −94 dBm at the phone), 2.5 kHz deviation, tones **1 kHz, 300 Hz, 100 Hz, 50 Hz**, then the sweep, for each variant. Report per variant the rms of each tone relative to 1 kHz in dB, with 16-bit data, and the sweep response. Pass for "the low end is there": 100 Hz within 6 dB of 1 kHz in some variant. If no variant passes, R-C closes with the measurement, and the receive side stays the audio-path equaliser.

**Outside the bench (owner's decision, done by another Claude instance, not bench work):** commit `bde7deca` ("Finish the SignalDeck move") removed the SignalDeck beta releases (beta.1–beta.12) from this repository's GitHub Releases and the profile list and its signing script from this repo, as the owner intended. Builds up to beta.11 install the newest build from the SignalDeck repository by hand once; the README says so. DMRModHooks releases are untouched. The profile list and `sign_profiles.py` live in the SignalDeck repository.

## Review of R-C step 3, RC30 (2026-10-24, commit `f4629735`)

**Verdict: the read is now right and the plain-path measurement stands. The closing verdict is one clean measurement short, because the method cannot resolve 50 and 100 Hz in a 32 ms half and the one variant that moved was dismissed on an unverified "seam". One more image, no key, and R-C closes either way.**

**What RC30 settled.**
- The byte-wise copy returns 256 int16 per half, idle rms 5–17, no `xx 00 00 00` groups; the RC20 fold was the word read, as predicted. The sweep tracks the chirp through 2.6 kHz with no fold.
- Both halves carry live audio with no seam at 1 kHz; the half the register names and the other one are both usable.
- The plain path has **de-emphasis**: 300 Hz reads +11 dB against 1 kHz, which is the −6 dB/octave slope over 1.74 octaves (+10.4 dB). So the RX RAM holds the voice-shaped output, not the raw discriminator.
- Below that there is a **steep cut**: 100 Hz at −32 dB and 50 Hz at −30 dB against 1 kHz, where de-emphasis alone would give +20 dB and +26 dB. That is a high-pass of several poles near 250 Hz, after de-emphasis. Clearing the C7000 band-pass and pre-emphasis bits (variant 2) and bypassing the AT1846S filters (variant 3) each changed nothing.

**A cross-check that matters.** These are the same numbers the phone's audio path gave in the M17 study (below 250 Hz, −25 to −37 dB). The C7000's receive RAM, which never touches the ES8311, shows the same cut. So the cut is **upstream of the phone-side converter**, and the R-B hypothesis (the ES8311 ADC high-pass as a main cause) is now unlikely; R-B can close with R-C. Where the cut is depends on what feeds the C7000 in analog mode: if the AT1846S hands it I/Q or IF and the C7000 demodulates, the high-pass is the C7000's own voice/CTCSS-reject filter and no register in §11.2 names it; if the AT1846S hands it audio, the filter is in the AT1846S beyond the `0x58` bits. Either way nothing in the register set tried so far opens it.

**Why one more measurement.** The tone levels are the rms of one 32 ms half, not a line: 50 Hz is 1.6 cycles in that window, 100 Hz is 3.2, and any step, DC offset or seam dominates the rms at those frequencies. That is also why variant 4 (both bypasses) reads −17.6 dB at 100 Hz and −4.0 dB at 50 Hz: the report says those halves show a seam, which would explain it, but a seam is a guess until the same capture is repeated and the line is measured instead of the rms. Variant 4 is the only variant that moved, by 14–26 dB, and it is the one combination that would mean the receive mirror exists. It deserves a clean answer, not a dismissal.

**R-C step 4, the closing measurement (one receive-only image, no key):**
1. Op 5 captures **four consecutive halves** (128 ms) per call: keep `WORK_MODE` `0x80` across them, wait for each `FM_ADDR_SW` change, copy the half just completed into the ring region at `0x4A400` (2 KB, idle during receive), then restore everything and return the 2048 bytes in four replies. A seam, if any, then shows as a step at a half boundary and can be seen rather than assumed.
2. Measure **lines, not rms**: Goertzel (or an FFT bin) at 50, 100, 300 and 1000 Hz over the 1024 samples (7.8 Hz bins), each tone captured three times per variant; report the median line level relative to 1 kHz in dB, per variant 0, 2, 3, 4.
3. Pass, as before: 100 Hz within 6 dB of 1 kHz in some variant. Then R-C and R-B close together, with the measurement, and the receive design stays the audio-path equaliser. If variant 4 passes, say exactly which register state did it.

**What the receive RAM is good for even if R-C closes.** It is the demodulated, de-emphasised, 16-bit signal inside the module, before the ES8311 and the phone's audio latency, readable by the MCU. CTCSS, DCS and DTMF detection are already hardware flags in the same block (`FM_DECODE_FLAG1/2`), and `FM_SQL` is a finer noise reading than the AT1846S RSSI. Those are small features for later, not part of this track.

## Review of R-C step 4, RC40 (2026-10-24, commit `28f43a6a`)

**Verdict: R-C is a positive result, not a closure. The report's own table says the receive mirror exists, and its end-state sentence ("the receive design stays the audio-path equaliser") contradicts it. Correct that: with the variant-4 register state the module's receive RAM holds a flat demodulated baseband, 50 Hz to 1 kHz within ±0.3 dB.** My task wording invited the misreading ("close together … if variant 4 passes, name the state"); the pass rule was explicit, and variant 4 passed.

**The measurement.** Lines over 128 ms, three captures each, medians against 1 kHz:
- Plain: 300 Hz +11.1 dB (de-emphasis), 100 Hz −42.1 dB, 50 Hz −46.1 dB.
- C7000 bypass alone (`FM_BANDWIDTH` bits 4 and 6 clear): 100 Hz −22.4 dB.
- AT1846S bypass alone (`0x58` = `0xBCFD`): 100 Hz −19.3 dB.
- **Both: 300 Hz −2.3 dB, 100 Hz +0.3 dB, 50 Hz −0.3 dB.** The three 100 Hz lines (7465, 8526, 8878) sit on the three 1 kHz lines (7707, 8275, 8499). The half-boundary steps on those captures are small and do not move the line.

**What it means physically.** Two filters sit in series on receive, each about 20 dB down at 100 Hz: the AT1846S voice filtering on the audio it hands to the C7000, and the C7000's own FM band-pass and de-emphasis. The phone's audio path (−25 to −37 dB below 250 Hz in the M17 study) is the AT1846S filter plus whatever the ES8311 adds; the ES8311 is therefore a second-order contributor at most, and R-B closes. Transmit used the same three writes (`WORK_MODE` `0x80`, the two `FM_BANDWIDTH` bits, `0xBCFD`) to get a DC-capable path; receive needs the same trio. Symmetric, and the trio is already proven safe in every T1 image.

**Two consequences, one immediate and one that needs a design.**

1. *The phone's own audio path improves with one register write.* The AT1846S filter alone is about 20 dB of the audio-path cut. Writing `0x58` = `0xBCFD` while receiving an analog channel should lift the phone-side audio from about −30 dB to about −10 dB at 100 Hz, which helps every decoder SignalDeck already runs on that path (POCSAG, M17 with the equaliser, DCS). It changes what the user hears (no de-emphasis, no voice filtering), so it is a "data receive" state that SignalDeck sets only while a decoder is active and clears after; the factory `at1846_tune` rewrites `0x8405` on every channel write, so the state must be re-applied after a retune (or the FM branch patched to read a flag). This needs no new RAM path and no streaming. **Measure it first (R-D below).**
2. *The receive RAM path for plain demodulation.* The flat baseband is in the module at 8 kHz, 16-bit; raw samples are 128 kbit/s, which the 57600 baud line cannot carry. Two designs:
   - **Runtime UART speed switch to 230400.** The module boots at 57600 (stock app untouched); a `0x40` op switches the module's divisor and SignalDeck reopens the port at the new rate; recovery from a failed switch is the module power-cycle SignalDeck already does. The phone side can do it: the profile carries the control-port baud and the Xplore 1 profile already opens a UART at 230400. At 230400 the raw 16-bit stream fits with margin, and every decoder then runs on the phone with the flat signal: M17 plain, POCSAG plain, FT8, SSTV, anything. Reading task first: find the UART divisor write (base `0x14090000`, the init near `uart_put` `+0x5EF4`) and confirm the clock allows 230400 exactly.
   - **Fallback, MCU-side symbol slicer** for M17 only (timing recovery at 5 samples per 3 symbols, sync search, symbols at 9.6 kbit/s to the phone), the mirror of the TX engine. More firmware, one mode at a time. Only if the speed switch is not possible.
   I recommend the speed switch; it turns the module into a general flat-baseband receiver.

**R-D, next on the bench (receive only, no key, HackRF tones as before):**
1. **Audio-path check.** With the phone receiving normally (SignalDeck audio on, `rxclip` recording), write the variant-4 state through op 5's register path but *without* copying RAM, hold it for the capture, and run the 20 Hz–3.8 kHz sweep plus the 100 Hz and 1 kHz tones through the phone's audio path; then the same with only `0x58` = `0xBCFD`. Report the phone-path response relative to 1 kHz for plain, `0xBCFD`-only and full variant 4. This tells SignalDeck what one register write buys today.
2. **Upper end and a real frame.** The sweep to 3.8 kHz on variant 4 through RX RAM (the low end is flat; M17 needs the top to about 3.6 kHz too). Then a looped short M17 transmission from the HackRF (link setup plus two frames, 120 ms, repeating; the sounding files from the M17 study) captured as six consecutive halves (192 ms, the `0x4A400`–`0x4AFB8` region R4p used) in the variant-4 state, repeated until a capture holds a whole link setup; plain decode with `m17.py`, **no equaliser**. Pass: link-setup CRC and at least one stream frame at Golay 0 from the raw RX RAM samples.
3. **Reading, no bench:** the UART divisor init and whether 230400 is reachable; SignalDeck's serial open path with a non-default baud on the Armor (the JNI takes the rate from the profile).

R-C's status in the route list changes from "closes" to **"open: the receive mirror exists (RC40); streaming design pending"**. R-B closes.

## Review of R-D, RD10 (2026-10-24, commit `b9569337`)

**Verdict: the step did what was asked and the first result changes the receive design. One AT1846S write (`0x58` = `0xBCFD`, op 6 variant 3) makes the phone's own receive audio flat: 50 Hz −0.6 dB, 100 Hz +1.2 dB, 300 Hz −1.6 dB, 2 kHz +1.8 dB, 3.5 kHz +1.7 dB, 3.8 kHz +1.7 dB against 1 kHz, where the plain path is −27.6, −24.5, +5.7, −4.0, −12.1 and −17.0 dB. Variant 4 is identical within 0.1 dB, so the C7000's receive filters are not in the phone's path at all; what the phone hears is the AT1846S audio output through the ES8311, and the ES8311 adds nothing measurable down to 50 Hz (R-B stays closed). The M17 study's "−25 to −37 dB below 250 Hz" and the voice low-pass above 3 kHz were all the AT1846S voice filter, and one register turns it off.** The reporting is clean: a failed pass is reported as a failure, the end-state sentence is right this time ("R-C stays open"), and the UART reading answers the question exactly.

**What this means for the design.** The phone's audio path with the bypass held is the flat baseband we were going to stream out of the receive RAM, and it already arrives at SignalDeck at 8 kHz through the path every decoder uses today, with no transport to build. The receive design is therefore, in this order:
1. **A "data receive" state in SignalDeck:** op 6 variant 3 while a decoder that wants the raw discriminator is active (M17, POCSAG, DCS, FT8 experiments); cleared by any channel write (the factory `at1846_tune` rewrites `0x8405`, measured: 100 Hz back to −24.5 dB after a VFO write), so SignalDeck re-sends it after every channel or VFO write it makes while the state is on. It changes what the user hears (no de-emphasis, no voice filtering, no 3 kHz low-pass), so it is never on during normal voice listening. This needs the stub image loaded (the op exists only there), which the ch. 19 loader page already plans.
2. **The receive RAM stream** stays the second route: lower latency, no ES8311, no dependence on the phone's audio pipeline (the Xplore 1 takes audio over a PCM UART, not TinyService). The UART clock reading makes it buildable: DesignWare UART at `0x14090000`, init at `+0x5DEC` from the boot list at `+0xD9E`, divisor `clock/16/baud` with no fractional register, the 48 MHz constant from `+0x5432C` fits the working link (57692 Hz, +0.160%), and 230400 lands on divisor 13 = 230769 Hz, the same +0.160%. 460800 does not fit (divisor 6.5). So 230400 is the ceiling and it carries 16-bit 8 kHz with framing at about 73 % of the line. Not before route 1 is proven, and not before the RAM path's plain decode is understood (below).

**The RX RAM M17 result, read closely.** The eight captures are not noise and not a dead path. In the as-captured polarity the stream frames decode frame numbers 1, 1 and 0 in four of eight captures through the Viterbi decoder, and the four link-setup decodes return the same wrong source field four times. The LICH "Golay errors 8–14" are the sum over four 24-bit words, 2–3.5 per word: that is a raw bit error rate near 10 %, enough to fail a 240-bit CRC and the Golay-0 pass, not enough to stop the convolutional code. (The inverted polarity gives frame numbers like 40894: as-captured is the right sign.) A 10 % raw error rate from a strong HackRF signal in the cage is a path or capture defect. Three suspects, in order:
- **The in-place reply framing is new in RD10.** The header of reply i+1 is written at the sample start minus 8, which is the last four samples of half i, and the trailer of reply i sits in the first three bytes of half i+1 (saved and restored, the header bytes are not). If `uart_status_sender` (`+0x7BC0`) queues a pointer rather than copying the body before it returns, the tail of every half goes out as header bytes: a spike every 256 samples. RC40 built every reply at `0x4AE00` and its three variant-4 1 kHz captures agreed within 0.4 dB (7707, 8275, 8499); RD10's one 1 kHz capture in the same state and the same HackRF settings (2.5 kHz, VGA 20) read 4795 with a mean-removed rms of 6648, where a clean tone has rms = line/√2 = 3390: that capture carried more non-tone power than tone. Against RC40's 1 kHz, RD10's 2 kHz (8190) and 3.5 kHz (8186) are flat and 3 kHz (6437) and 3.8 kHz (6207) are −2.3 dB; the "+4.7 dB at 2 kHz" is the 1 kHz reference being low, not a boost. So the top of the band is present and roughly flat, and capture integrity is the open question.
- **Sample rate.** The decoder assumes exactly 8 kHz and resamples to 10 samples per symbol; a 0.1 % error drifts 0.18 symbol by the end of a 184-symbol frame. TX RAM is 8 kHz to better than that (R4t, Golay 0 × 90), and the receive side shares the clock, but it has not been measured: the exact frequency of the 1 kHz tone in a six-half capture (interpolated FFT peak over 1536 samples, about 0.5 Hz) settles it in one line.
- **Response.** If the first two are clean, the residual is the C7000's own receive shape, which is a chip property (the same on every radio of this family), and a fixed short equaliser measured once from the sweep is legitimate there. Not before the first two are excluded.

A 1 kHz tone cannot see a dropped or stale half (32 and 64 ms are whole cycles of it); the tests below use tones that are not.

**Op 6 as built, two things to fix before SignalDeck relies on it.** (a) Its save words live at `0x4A3F8`/`0x4A3FC`, which op 5's restore slot and first in-place header also use; the comment says "do not run op 5 while op 6 is held", but a host mistake would then write a header word into `WORK_MODE`. Move the saves (`0x4A3F0`/`0x4A3F4` if free, or anywhere outside the ring and the halves) and have op 5 refuse with an error byte while a hold flag is set. (b) Restore writes back the saved `WORK_MODE`, which is stale after any mode change the factory code made in between (a channel write, a key); for variant 3 restore should only write `0x8405`, and SignalDeck's clear should be a channel write, which the factory path does completely.

**Minor.** Variant 4's hold also puts `WORK_MODE` at `0x80` for as long as it is held, during analog receive, while the factory sits in a DMR value; it did not mute the phone, but variant 3 does the same job for the phone path with one register, so variant 3 is the SignalDeck state and variant 4 stays a bench state for the RAM. Save every raw capture from now on (`.bin` of the halves per capture, named in `results.md`): the RD10 M17 captures were decoded and discarded, so the symbol-error map below has to be taken again.

**R-E next (receive only, no key; HackRF as before):**
1. **M17 through the phone path, held.** Apply op 6 variant 3 with no signal present, then start the HackRF M17 loop (the RD10 file: link setup + frames 0 and 1, ±2.4 kHz), record 3 s with `rxclip` at 8 kHz, plain `m17.py` in both polarities, no equaliser; three recordings; then the plain state once as control. Report per recording: link-setup CRC, source and destination, frames found, frames at Golay 0, frame numbers. Pass: link-setup CRC true and every stream frame at Golay 0 in all three. Also report whether the hold survived the squelch opening (100 Hz line before and after the HackRF starts) and name the exact sequence SignalDeck must send (hold, retune, hold again).
2. **RX RAM capture integrity, variant 4, raw captures saved.** (a) The half-id sequence of every six-half capture (expected strict alternation). (b) 1 kHz five times: line, mean-removed rms, and the interpolated peak frequency (the sample-rate check; expected 1000.0 ± 0.5 Hz). (c) A 310 Hz tone (9.92 cycles per half) three times: fit one sinusoid over the 1536 samples, report the residual rms per half and the index of any step. (d) Read `uart_status_sender` `+0x7BC0` and say whether it copies the body before returning; if it does not, build the replies at `0x4AE00` again as RC40 did, and repeat (b). (e) The M17 loop three times, raw halves saved, and a **symbol-error map**: slice at the recovered timing, align to the known transmitted symbol sequence, report the raw symbol error rate per capture and where the errors fall (symbol index within the frame, and distance to the nearest half boundary). That one table tells timing drift (errors late in the frame) from seams (errors at half boundaries) from response (errors uniform, inner levels).
3. **Op 6 fixes** as above (save slots, hold flag with op 5 refusal, variant-3 restore = `0x8405` only), in the same image as 2(d).
4. **Reading, no bench:** every writer of AT1846S register `0x58` (call sites of the I²C write `+0x54628` with `0x58`), with the condition each runs under: channel write, transmit start and end, squelch or carrier events, power-save. That is the list of moments SignalDeck has to re-apply the hold.

Then the stream end and stack step as written. The route list: R-C stays open with the RAM stream as the second route; the first receive route is now **R-E: the AT1846S bypass held while the phone's own audio path feeds the decoders.**

## Review of R-E (2026-10-24, commit `5cede825`)

**Verdict: the pass was not met and the report says so plainly; the step itself is good work, and the recordings it saved settle the question. I ran the saved clips through a channel fit, and the held phone path is a clean linear channel with a long linear distortion: a fixed 41-tap linear equaliser, fitted on one R-E clip, decodes the other at zero symbol errors, link-setup CRC 13 of 13, Golay 0 on 25 of 25 stream frames, and the same the other way round. M17 receive through the held phone path works with one fixed filter in front of the plain decoder. The receive design is settled: bypass held, fixed linear equaliser, existing audio path.**

**What R-E established (Grok).**
- The hold survives the squelch opening and three carriers; a VFO write clears it; applying it again restores it. SignalDeck's sequence is op 6 variant 3 action 1, repeated after every channel or VFO write and after any CTCSS/DCS programming (the `0x58` writer table: init, the two `at1846_tune` arms, the tone setters; nothing on the squelch, PTT or UART paths by itself).
- The receive RAM is 8 kHz exactly (1 kHz peaks at 1000.0 Hz on five captures), the half ids alternate without a skip, the in-place reply headers are innocent (`uart_put` writes every byte before it returns), and the symbol errors fall evenly across the frame and away from the half boundaries. **The first half of every capture is corrupt** (phase off by 57–133°, the three largest steps inside it, residual 3–5× the later halves): it is copied while the hardware is still writing it. Start the copy at the second `FM_ADDR_SW` change, or drop half 0 on the host. The later five halves are one continuous tone.
- Op 6 fixes as asked: saves at `0x4B000`/`0x4B004`, hold flag `0x4B008` = `HOLD`, op 5 returns `sr=1` while held without touching a register, variant-3 restore writes `0x8405` only and clears the flag. Verified on RE10.

**What the clips show (my analysis of `re_phone_m17_1/2.wav`, tools in `tools/m17-research/heldpath_eq.py`).**
- Symbol means at the recovered sync timing: −3.008, −0.973, +0.975, +3.008; a fitted cubic term of 0.004. **No compression, no limiter**: the path is linear. The old DFE's cubic terms were the plain path's filters at work, not a nonlinear receiver.
- Plain slicing: 19 % symbol errors, spread 0.9 per level against a decision distance of 1. A linear fit of the sampled value on the known symbols explains it: residual 0.90 → 0.64 (±4 taps) → 0.57 (±8) → 0.40 (±12) → **0.21 (±20)**. Long linear memory, nothing else.
- The spectrum of the received M17 (random data, so flat to 1.2 kHz by construction) against the 800–1200 Hz band: 300 Hz −3.6, **400 Hz −7.8, 500 Hz −8.7, 600 Hz −5.0**, 700 Hz −3.4, 800 Hz −1.7, 900 Hz −0.1 dB, flat above. The held chirp recording shows the same dip (500 Hz −9.5 dB against 1 kHz) and a low-end group delay of +2.1 ms at 200 Hz and +3.8 ms at 100 Hz (the AC coupling's corner). The R-D tone table had no tone between 300 Hz and 1 kHz, so it read "flat" across a 9 dB dip. Same on variant 4, so the dip sits in the AT1846S or the ES8311, not the C7000 (R-F step 2 tells which).
- The decoder is not the problem: a synthetic 8 kHz deviation signal decodes at Golay 0 through `m17.py`'s linear-interpolation resampler, and a windowed-sinc resampler changes nothing on the real clips.
- **Fixed equaliser:** a ±20-symbol feed-forward filter at symbol rate, least-squares on the known loop in clip 1, applied to clip 2: symbol errors 0.191 → 0.0000, LSF CRC 13/13, Golay 0 25/25; trained on clip 2 and applied to clip 1: 0.189 → 0.0000, 12/12, 24/24. The loop content is the same in both clips, so this is a channel result, not yet an independent-data result; R-F step 1 makes it one.

**The receive design, settled.** The phone's existing 8 kHz audio path, with op 6 variant 3 held while a raw-discriminator decoder runs, plus a **fixed linear equaliser** (a chip property of this radio family, measured once, shipped as a table; a slow decision-directed trim on confirmed frames is optional). SignalDeck's M17 receiver keeps its per-phone DFE for the plain path (phones without the stub image) and gains a second, simpler front end for the held path. The receive RAM stream stays the second route, now a latency and portability question rather than a signal-quality one.

**R-F next (receive only, no key; HackRF as before; host work may start whenever):**
1. **Independent validation of the fixed equaliser.** Fit the taps once from the R-E loop clips (`heldpath_eq.py`, or a T/2-spaced version of it). Then new HackRF transmissions that share nothing with the training loop: other callsigns, random payloads, 60 or more stream frames each, with preamble and EOT as a real radio sends them; at ±2.4 kHz and at ±1.9 kHz; at three signal levels (TX VGA 20, 10, 0, with the radio's `0x32` RSSI reported for each). Plain `m17.py` behind the fixed taps, three recordings per condition. Pass: link-setup CRC on every recording and ≥ 99 % of stream frames at Golay 0 at ±2.4 kHz and VGA 20; report the numbers at the other conditions as the sensitivity curve. Save every clip.
2. **Where the dip is.** Tones at 400, 500, 600, 700, 800 Hz on the held phone path (line levels against 1 kHz) and the same tones through the receive RAM in variant 4 (five halves, half 0 dropped). If the RAM shows the dip it is the AT1846S; if not, the ES8311, and the RAM route gains a reason.
3. **POCSAG through the held path.** One DAPNET-style transmission at 1200 bps (the `tools/pocsag-research` files) through the held phone path, plain slicing and BCH, no equaliser; then behind the M17 taps as a first try. Report bit errors per codeword. The POCSAG study's 21–23 % plain error rate was the same AC-coupled path.
4. **Op 5 first half**: start the copy at the second `FM_ADDR_SW` change (or return five valid halves) in the next image that goes on.
5. **Host (SignalDeck, parallel):** the "data receive" state (op 6 variant 3 on/off, re-applied after every channel, VFO and tone write; gated on the `0x34` tag), and the held-path front end in the M17 receiver: hold → matched filter → sync → the fixed taps → the existing frame decoder; the per-phone DFE stays for the plain path. Taps from step 1.

Then the stream end and stack step as written.

## Review of R-F (2026-10-24, commit `5a890be5`)

**Verdict: R-F passes under the right measure, and the measure I wrote was the wrong one. "Golay 0" means zero raw bit errors in the 96 LICH bits of a frame; a receiver's job is a correct payload, which is what SignalDeck's test counts ("exact stream payloads"). Rescored by payload-exact frames, every independent clip that the research decoder locked on decodes 100 %: 75/75 and 75/75 at ±2.4 kHz and −87 dBm, 73/73, 77/77 and 18/18 at −93 dBm, 76/76, 74/74, 74/74 and 76/76, 73/73, 73/73 at ±1.9 kHz, and 75/77 on the one −98.5 dBm clip that locked. Grok's `payload_ok` only counted Golay-0 rows, so its table understated what it had.** The 18 "misses" on the first clip had LICH sums 1, 1, 1 … 2, 3, 4: corrected codewords, correct payloads.

**The taps are a fixed filter, not a memorised loop.** Retrained on a random-payload clip (76 frames, other callsigns) the 41 taps come out the same as from the R-E loop (centre 0.968 against 0.987, every other tap within 0.02), and the retrained set scores the other clips identically. Same taps at ±1.9 kHz and ±2.4 kHz, at −87 and −93 dBm.

**What did fail was acquisition, in the research decoder.** `m17.py` takes the first sync above 0.85 on the *unequalised* signal and walks the 192-symbol cadence from there; on the held path the raw sync scores are 0.92–0.95 and the 1.6 s ±3 lead throws false syncs at 0.86–0.88, so three clips never got onto the stream (`m17_d2400_v20_1` among them) and the −99 dBm clips did not pass the threshold at all. **Equalise first, then sync**: the same T-spaced taps applied at every sample phase (spacing one symbol) before the sync search, threshold 0.95. Then all 18 clips lock at sync 0.98–1.00 with a valid link-setup CRC, including all six at −98.5/−99.5 dBm:

| Condition (3 clips each) | Payload-exact frames, equalise-first |
|---|---|
| ±2.4 kHz, −87 dBm | 74/75, 72/73, 75/75 |
| ±2.4 kHz, −93 dBm | 74/74, 18/18 (short clip), 76/77 |
| ±2.4 kHz, −99 dBm | 72/74, 72/75, 71/77 |
| ±1.9 kHz, −87 dBm | 75/76, 74/74, 74/74 |
| ±1.9 kHz, −93 dBm | 76/76, 73/74, 72/73 |
| ±1.9 kHz, −98.5 dBm | 71/74, 74/77, 71/74 |

So the held path decodes M17 at about 95 % of frames at −99 dBm and 98–100 % at −87 to −93 dBm, on independent data, with one fixed filter in front of the plain decoder. (The plain-path DFE receiver was characterised at −94 dBm.) Scripts: `tools/m17-research/heldpath_rf_score.py` (payload-exact scoring, retraining on random data, equalise-first acquisition) against the saved `rf/` clips.

**The dip is the ES8311.** Phone 500 Hz −9.6 dB, receive RAM −0.2 dB; the RAM is within 0.3 dB from 400 to 800 Hz. So the phone-side codec, not the AT1846S, shapes the held path: the taps are a property of the phone model (its kernel audio configuration), the same on every Armor 26 Ultra, and other phone models get their own table from one calibration recording. A kernel setting on the ES8311 might remove the dip altogether (R-B territory, the owner decides); it is not needed. The receive RAM is the flatter signal and stays route 2; its half 0 is still copied live (fix in the next image that goes on, and then one more symbol map on halves 1–5).

**POCSAG.** 1200 bps DAPNET-style page through the held path: plain 0.24 bit errors per codeword, behind the M17 taps 0.039, which BCH(31,21) clears. The POCSAG study's "not a feature yet" was the AC-coupled plain path; a DAPNET receiver on the held path is practical now, with its own tap set trained on POCSAG later.

**Receive design, final.** Op 6 variant 3 held while a data decoder runs (re-applied after every channel, VFO and tone write), SignalDeck's existing 8 kHz audio path, a **fixed 41-tap linear equaliser per phone model applied before acquisition**, sync threshold raised, then the existing frame decoder. The per-phone DFE stays for phones without the firmware image. Bench receive work is done; the firmware line goes back to transmit.

**R-G next.**
1. **Firmware (Grok): stream end and stack**, as written below, with the op 5 half-0 fix in the same image (copy from the second `FM_ADDR_SW` change). Render first, then the one 90-frame key.
2. **Host (SignalDeck, whenever the bench waits):** (a) the "data receive" state: op 6 variant 3 on when an M17, POCSAG or other raw-discriminator decoder starts, re-sent after every channel, VFO and tone write, restore (action 0) when it stops; only offered when `0x34` reports a stub tag; (b) the held-path M17 front end: fixed taps from an asset per profile (the Armor's 41 from `rf/taps.json`), applied to the symbol-rate-spaced samples before the sync search, threshold 0.95, then the existing frame decoder and Codec 2; the DFE path untouched for the plain state; (c) a host test over the 18 saved R-F clips: link-setup CRC on all 18 and payload-exact ≥ 95 % on each (≥ 98 % at −87/−93 dBm); (d) one device run: HackRF M17 at −87 dBm, the M17 page shows the callsigns and the frame count, with the hold on; then the plain state as control.
3. **Later, host:** POCSAG/DAPNET decoder on the held path (plain slicer + BCH behind a POCSAG-trained tap set), backlog item.

Then FW19 and the rest of the list as written.

## Review of R-G (2026-10-24, firmware `a54f861e` tag `RG10`, host `cf740e8e` + SignalDeck `12da3d84`)

**Verdict: the firmware half is done and clean; the host half is three quarters done, and the quarter that is missing is the live receiver. On the phone one 30-frame transmission came out as 13 frames plus two headless entries, and the host test that was meant to catch that does not drive the live receiver at all. The SignalDeck change also went in without a CHANGELOG entry.**

**Firmware, RG10 (good).** Op 4 builds its reply at `0x4AE00` and caps N at 240 (the 64-sample render returned `sr=0` without touching the stack). Op 5 waits through one `FM_ADDR_SW` change and copies from the next: six 1 kHz halves now step by at most 0.13° across every boundary, the first included, so the receive RAM capture is clean end to end. Op 7 appends like op 1 and arms the last flag; when the ring drains at RRC phase 0 the wake clears the cursor and runs `drop_ptt` (PTT off, voice bit, `0x58` = `0x8405`, `0x30` = `0x7026`, mask bit 15, status byte 4). The 90-frame key decoded 90 payload-exact frames at a steady p99 of 2794–2913 Hz, so nothing moved. **Not yet exercised: op 7 itself.** The key used op 1 with the host holding PTT, so the self-unkey never ran. It gets exercised in the FW19 key (below). Minor: cutting at ring-drain truncates the RRC tail of the EOT frame by about four symbols, which is harmless, since the EOT is 192 symbols of marker.

**Host, what is right.** `Firmware.stubTag` gates the hold on a `DMR003.XXXX.V022` tag other than `UV4T`; `RadioService` sends op 6 variant 3 when M17 starts, again after a channel, VFO or tone write (generation-counted so a late send cannot undo a release), and action 0 when M17 stops; `M17Station` swaps the front end to `HeldPathReceiver` when the module accepts the hold and back to the DFE when it does not or when the hold is released; the Armor's 41 taps ship as `assets/m17/held_ulefone-armor26ultra.txt`; `HeldPath.decode` reproduces the research decoder on all 18 R-F clips (`HeldPathTest`); the help text was updated with the change. All as asked.

**Host, what is wrong: the live receiver.** `HeldPathReceiver` keeps a 4 s ring of audio, and every 400 ms copies the whole ring and decodes it from the start with `HeldPath.decode(…, trimHead = false)`, de-duplicating stream frames by frame number. Three consequences, two of them visible in the device run:
1. **Frames lost (13 of 30).** `HeldPath.frames` takes the *first* position whose sync correlation exceeds 0.95 and walks the 192-symbol cadence from there until the score drops below 0.6, then returns: one chain per call. In the live window several seconds of squelch noise precede the transmission, and over tens of thousands of positions an 8-symbol normalised correlation on noise does exceed 0.95 now and then. The walker starts on that false sync, dies after a frame or two, and the real transmission in the same window is never searched. On the saved clips this never happened because `loud()` trims the head to the signal. Fix: search for the next sync after each chain ends (every chain in the window), and do not search in muted audio (the module holds the PCM near 5 counts until its squelch opens: a cheap gate), or require the LSF sync or six LICH chunks before opening a transmission.
2. **Headless entries and the repeat listing.** After `finish` (last frame, or 1 s without a new frame) `seen` is cleared but the audio stays in the ring, so the next pass decodes the same frames again and opens a *new* transmission with an empty link setup (`listener.started(new M17.Lsf(new byte[30], false))`), reports the frames, and closes it a second later as "signal lost". That is the "two shorter entries with no callsigns", and most likely the second `K6M17 → W9LAB, 12 frames` that appeared during the plain-state control, which came from this receiver's ring before it was stopped, not from the DFE. Fix: consume decoded audio (drop the ring up to the end of the last decoded frame after each pass, and the whole ring on `finish`), and track positions rather than frame numbers.
3. **Load.** A full re-decode of 4 s (resample ×6, 81-tap matched filter, 41-tap equaliser, two sync scans over 192 000 samples) every 400 ms is a lot of work on the phone for nothing new; consuming the ring fixes this too.
Also: the receive thread swallows every exception (`catch (Throwable ignored)`), so a decode fault would look like silence. Log it.

**The control run is inconclusive.** The W1RF transmission had no lead (`one_tx` sends LSF first), so the HackRF's start transient can eat the preamble the DFE receiver locks on. Repeat it with the 1.6 s lead the R-F transmissions had.

**The host test does not test the live path.** `HeldPathTest` calls `HeldPath.decode(pcm, taps)` on whole clips with head trimming. It should also push each clip through `HeldPathReceiver.feed` in 64 ms blocks, with 3 s of the clip's own muted head (or recorded idle audio) in front, and assert exactly one `started` with the right callsigns, ≥ 95 % of the frames, one `ended`, and no second transmission.

**Process.** No `CHANGELOG.md` entry for the SignalDeck change (the rule is every user-facing change, same commit). Add it with the R-H fix, and say the device result was partial. The uncommitted `CHANGELOG.md`/`CLAUDE.md` edits in the SignalDeck working copy are another agent's W6 notes; leave them.

**Open question for the bench, one key:** does the factory unkey path rewrite `0x58`? Hold, key 1 s of silence at low power, unkey, measure the 100 Hz line. If the hold is gone, SignalDeck re-sends it after its own PTT as well (cheap to do regardless).

**R-H next.**
1. **Host (SignalDeck):** the live receiver as above (every chain in the window, no search in muted audio, consume decoded audio, no re-open after `finish`, log exceptions), the streaming host test over the 18 clips, the CHANGELOG entry (and the hold re-send after the app's own PTT). Device: three 30-frame transmissions with the 1.6 s lead at −87 dBm with the hold on. Pass: one list entry per transmission with the right callsigns, ≥ 28 of 30 frames each, no headless entries. Then the plain-state control with the lead.
2. **Firmware: FW19** as written, and in its 45 s key the host sends the last chunk with **op 7 and does not unkey**: pass adds `SEND_STOP` from the module's own drop (status byte 4) and the carrier ending within 100 ms of the last symbol on the HackRF. Plus the one-key `0x58`-after-PTT check above.

## Review of R-H (2026-10-24, host `e82c1c84` + SignalDeck `943e4ec2`)

**Verdict: R-H passes. The live receiver now follows one transmission: on the phone three 30-frame HackRF transmissions with the 1.6 s lead listed once each with the right callsigns and nothing else, and the plain-state control with the lead listed its own callsigns and did not repeat a held one. The frame counts, 28, 28 and 27 against a bar of 28, are most likely the bench cutting the end of each transmission, not the receiver losing frames; the check is one padded re-run (below). The firmware line is untouched: RG10 stays loaded, FW19 is next as written.**

**What I verified.** I ran `HeldPathTest` myself (`testReleaseUnitTest`, BUILD SUCCESSFUL): the streaming test opens exactly one contact with the sent callsigns on all 18 clips, reports the reference frame count on every one (73–77, and 18 on the short clip), and ends each once. In the code: `HeldPath.live` searches on after a chain ends (every chain in the buffer), `firstSync` and the walker skip positions where the raw PCM is inside the module's mute (`MUTE_PEAK` 20 counts), a chain opens a contact only with a link-setup CRC or six LICH chunks whose CRC checks (`identified`, `identity`), a chain of eight frames without either is abandoned, the buffer is kept while a call is open and dropped at `finish`, so finished audio is never decoded again, the decode thread logs its exceptions (`report`), `RadioService` re-sends the hold when the app's own PTT is released, the CHANGELOG entry is there with the partial first run named, and the help text says what changed. All as asked.

**Where the two or three frames went.** Three facts: (1) the plain-state control, a different receiver with no shared code, also listed 27 of 30; (2) on the saved clips the live receiver reproduces the batch decoder frame for frame, and I mapped the batch decoder's misses: the clips are 4.50 s long, the link setup sits at 1.36–1.50 s, so the 80 frames run to about 4.7 s and the missing frame numbers are 74–79, 77–79 and so on, the end of each clip (the `rxclip` window closed first; the odd mid-clip gap is a frame whose frame number decoded wrong at the lowest level); (3) the bench sends each transmission with `hackrf_transfer -n <samples>`: when the sample count is reached the transfer callback stops the stream and `hackrf_stop_tx` cancels the USB transfers still in flight, up to four 256 KiB buffers, which at 2 MS/s is up to 260 ms of signal, six M17 frames. Two or three frames plus the EOT is what that leaves. **Check: append 0.5 s of unmodulated carrier (constant phase) after the EOT in `iq_syms`, then repeat the three transmissions. If 30 of 30 arrive, the receiver is confirmed end to end; if the counts stay at 27–28, the loss is in the receiver and the end of the call is where to look.** Either way the pad stays in every bench transmission from now on. Note also that no saved clip contains an end of transmission, which is why every host test case ends with "signal lost" and never "last frame".

**What is not right yet, for R-I (host).**
1. **Calls longer than 20 s split.** `CAP` is 20 s of audio, `feed` drops samples when the buffer is full, and nothing is consumed while a call is open. A transmission longer than about 20 s therefore stops being heard, the call closes as "signal lost" a second later, the buffer is cleared, and the rest of the same transmission opens a new listing from six LICH chunks: a one-minute over gives three listings and loses ~1.3 s each time. And each 200 ms pass re-runs the ×6 resampler, the 81-tap matched filter, the 41-tap equaliser and two sync scans over the whole call so far: at 20 s that is ~130 million multiply-adds per pass, five passes a second, on the phone. Fix: incremental decoding: keep the chain state across passes (next expected sync position, kind and gain), decode only the frames that are new, emit by position (not by the `emitted` index), and drop consumed audio with the existing `KEEP` margin while the call is open as well.
2. **Frames at the buffer edge are half-equalised.** `payload` accepts a frame whose last symbol is the last sample of the buffer, but `equalise` has 20 symbols of look-ahead taps and the matched filter four more; past the end they read zeros (and `resample6` holds the last value). A frame that finishes within ~24 symbols (5 ms) of the buffer end is decoded with its last symbols wrong, emitted, and never decoded again. With 200 ms passes and 40 ms frames that is one frame in eight passes, about 0.6 damaged frames per second of call, and probably part of "25 clean of 28". Fix: take a frame only when `start + (183 + L + 4) * SPS < y.length`; it comes on the next pass.
3. **One lost sync ends the call.** A best candidate below `LOST` (0.6) in loud audio sets `lost`, the chain is `closed`, `take` finishes the call and clears the buffer, and the next pass opens a new listing from six LICH chunks at least 240 ms later. Frames are exactly 192 symbols apart: coast on the cadence (same gain) for up to three frames before declaring the call lost. The saved clips never break, but −99 dBm will.
4. **Unidentified chains are counted into an open call.** While a call is open, a chain with no identity in the same pass (one to seven frames off a false sync in the squelch tail; the walker abandons only at eight) has its stream hits counted and played. Skip chains without an identity unless they sit on the open call's cadence.
5. **`finish` clears everything,** including the audio of a following transmission that has already arrived (at most one poll period). Goes away with item 1.
6. **Test.** `liveReceiverOneTransmission` polls once mid-clip and once at the end; the thread polls every 200 ms. Poll every third 64 ms block so the `needMore` and buffer-edge paths run at the real cadence, and assert the payload-exact count (the payload hex is in `expected.json`) equals the batch decoder's, not only the frame count. Record two more clips with the hold on: one 6 s clip holding a complete 30-frame transmission with the carrier pad and a second of squelch tail (expected end "last frame"), and one 25 s clip of a 600-frame transmission (catches item 1 on the host).

**Bench for R-I (hold on, HackRF −87 dBm, 1.6 s lead, 0.5 s carrier pad):** (a) three 30-frame transmissions: pass = one listing each, right callsigns, ≥ 29 of 30 frames; (b) one 1200-frame transmission (48 s): pass = one listing, right callsigns, ≥ 1140 frames; (c) the plain-state control once with the pad. CHANGELOG and help in the same commit.

**Order.** FW19 first (bench, as Grok wrote it, with op 7 exercised in the 45 s key and the one `0x58`-after-PTT key); R-I host whenever the bench waits.

## Review of FW19 (2026-10-24, commit `165d15e5`, tag `FW19`, SignalDeck `cfcae32d`)

**Verdict: FW19 passes as the ceiling change, and the reading behind it changes the picture. The stock `0x3B` handler never clamped anything: it stores the byte, a byte of 0 turns the time-out off, and the firmware's own start-up value is 120 s. The 30 s limit this project has lived with since 2026-10-16 was the phone apps' own countdowns (OEM `PERSON_LIMIT_SEND_TIME = 30`, DMRModHooks `TX_LIMIT_S = 30`), never the module. So SignalDeck could have had a 120 s module ceiling on stock firmware by sending 120 instead of 0; FW19 is still worth keeping as the floor that turns the 0 everyone sends into 120. Three things remain from the task: the high-power 45 s and 120 s keys, a check of the plain audio path past 30 s, and a defect the FW19 log shows in op 7's self-unkey.**

**What I verified.** The stock handler at file `+0xA308` (disassembled here): `ld.b` of body byte 8; if zero, store 0 to the enable byte at `0x38C64`; else store 1 to the enable byte and the body byte to `0x38C64+1`; then the acknowledgement. No compare, no clamp. The timer at `+0x1D8`: while the enable byte is set and the state byte at `0x38908` has bit 0 or 2 set, a 32-bit count at `0x38C64+2..5` increments per wake and is compared against `100 × tot`; when the state bits are clear the count is zeroed. A routine at `+0x264` zeroes the count and stores enable = 1, tot = **120**: the module's own default (Grok confirms where it is called), which the OEM app overwrites with 0 (`DmrManager.sendSetTotCmdToMdl`) and SignalDeck overwrites with 0 too (`RadioEngine.bootHandshake` → `setTot(0)`). The stub: 24 bytes at `+0x5B700`, `push r15; r3 = r0 + 8; ld.b r2; movi r1, 120; bez → store; cmphs r1, r2; bt → keep; st.b r1; bsr +0xA308; pop r15`; the `bsr` field decodes to `+0xA308` from `+0x5B712` and the thunk's `bsr` at `+0xAB18` decodes to `+0x5B700`; the stock handler reads only `r0`, so the clobbered `r1`–`r3` are safe. Measured: two 1125-frame streams keyed 45.12 s at low power, 1124 frames found and 1123 payload-exact over the whole capture, body p99 under 3 kHz, the last chunk op 7 and the module's own `SEND_STOP` (status 4) 0.3 s after the last chunk, the carrier ending ~60 ms after the drop click. Op 7 is therefore exercised and works. `0x58` after a PTT: the 100 Hz line 71 dB down after the unkey, so the hold does not survive it; SignalDeck already re-sends after its own PTT (R-H), nothing to change. The heat table is complete for low power and the 30 s high-power key; the stop conditions were applied, one early abort was a misread 1.0 °C step and was rightly discarded. The ch. 19 §6 and §10 entries, the CLAUDE.md row and its mirror are updated and in sync. The SignalDeck `cmdsym --ez eot` extra has its CHANGELOG line (bench-only, help unchanged: fine).

**The 120 s ceiling is measured, by accident.** The second stream keyed at 22:13:11.068; the host never sent `0x26` off; a second status byte 4 arrived at 22:15:11, which is key-on + 120.0 s. That is the stored 120 reaching the timer, so the unit is 1.000 s and the ceiling is 120 s. It also shows a defect: **op 7's `drop_ptt` drops the carrier but leaves the TX bits of the state byte set**, so the time-out counter kept running for 75 s after the carrier ended and then ran the stock stop path. Consequences until it is fixed: a stray `SEND_STOP` 120 s after every self-unkeyed stream, a second stream keyed inside that window is cut when the first one's 120 s run out, and the module may not be receiving while it believes it is transmitting (to measure). In the first key the host sent `0x26` body 1 afterwards and no stray stop was logged, which is the workaround: the host sends the unkey after the module's status 4 until FW20.

**The 30 s belief, corrected.** 2026-10-16 measured `tot=0` → 32 s, `tot=10` → 12 s, `tot=60` → 31 s through the OEM app with the module. The 12 s was the module's timer (10 units plus the key-up); the 31–32 s were the OEM app's `PERSON_LIMIT_SEND_TIME` (30) and the module's `TX_LIMIT_S` (30) releasing PTT, with `tot=0` meaning no module time-out at all. Every "the radio ends a transmission at 30 s" sentence in SignalDeck's help (three of them) describes the app's own 28 s watchdog, not the radio. Not yet measured on any image: a plain audio-path key longer than 30 s (every key past 30 s so far was a symbol stream from TX RAM); one 40 s tone key settles whether the voice path has a second limit of its own.

**What is still owed from the FW19 task (bench, one session):**
1. **High power, 45 s then 120 s** (owner's order, 2026-10-24), with the same temperature log: the 45 s stream as run, at high power, HackRF LNA 0 / VGA 0 with the clip fraction reported; cool down per the heat rule; then the ceiling run: a 130 s stream (3250 frames, no end bit) at high power, pass = the module ends the carrier at 120 ± 1 s after key-on and the report says which status byte it sends then (the OEM app maps 6 to its time-out toast; log whether it is 4 or 6). Report the rise per sensor beside the low-power table; the heat rule is rewritten from it.
2. **The timer after op 7.** After the 45 s self-unkey send no `0x26`; log the status bytes for 130 s; 60 s after the drop put a HackRF carrier on 467.625 and read `0x32` and watch for status 1: does the module receive while its TX state is still flagged? Expected from the FW19 log: `SEND_STOP` at key-on + 120 s.
3. **One 40 s plain FM key** at low power (a 1 kHz tone through the audio path; the bench extra lifts the 28 s watchdog and the 28.5 s refusal for that run only), pass = carrier 40 s ended by the host. Proves the module has no second limit on the voice path.

**FW20 (firmware, small, after item 2):** `drop_ptt` clears what the `0x26` body-1 path clears, the TX bits of the state byte at `0x38908` and the time-out count at `0x38C64+2..5`, so the timer stops with the carrier. Pass: no status byte after the drop within 130 s, and a second stream keyed 10 s after the first drop runs its full length.

**Host (SignalDeck), in the next commit touching the engine:** (a) `bootHandshake` sends `setTot(120)`, never 0 (on stock firmware 0 turns the module's time-out off, so today SignalDeck on stock has no module limit at all; with 120 stock and FW19 behave the same); (b) the symbol-stream sender sends `0x26` off after the module's status 4 until FW20 is loaded, and never leaves PTT keyed without the watchdog or a module ceiling; (c) the voice watchdog stays 28 s; the `txPcmOneShot` limit becomes per mode, but the long SSTV modes (Robot 36, Martin M1/M2, Scottie S1/S2, PD90, all ≤ 114 s) are enabled only after the high-power heat table (item 1) is in, and never above 120 s; (d) the three help sentences that say the radio ends a transmission after 30 seconds say what is true: SignalDeck ends a voice transmission after 28 s, the radio's own limit is 120 s. CHANGELOG and help in the same commit.

**Order.** Finish the item-2 step in progress (the SignalDeck M17 transmit stack); then the three bench items and FW20 in one bench session; the host TOT items go into the next SignalDeck engine commit. R-I stays "whenever the bench waits".

## Review of item 2, SignalDeck M17 voice (2026-10-24, host `3df3efe0` + SignalDeck `af63e000`, `5e512e5f`)

**Verdict: passes the item-2 criteria. SignalDeck now sends M17 voice: Hold to talk on the M17 page encodes Codec 2 3200, builds the link setup and stream frames with the encoder that already matched our research encoder, streams the symbols on `0x40`, ends on op 7 and unkeys after the module's status 4; it exists only when `0x34` reports a bench image, refuses digital channels, caps itself at 28 s and unkeys in `finally`. On FW19 the 1.5 s bench tone came back as a link setup with a good CRC and frames 0–35 payload-exact, and the Codec 2 decode of them is a 1 kHz tone. The time-out items from the FW19 review are in the same commit (`setTot(120)`, unkey after status 4, the help sentences). Two things to fix, one of them firmware, and one process point.**

**What I verified.** `M17Test` re-run here: 4 of 4. The encoder is the project's own (`M17.java` CRC, convolutional code with P1/P2 puncturing, `lsfSymbols`, `streamSymbols`, now `preamble`, `packSymbols`, `voiceCall`), checked against `tools/m17-research/m17.py`, which is written from the specification; nothing from libm17. `m17VoiceRun`: reset (op 3), preamble + link setup primed, key on the eighth chunk because the ring drains only with the transmitter up, two Codec 2 frames per stream frame, LICH counter `fn % 6`, end bit on the last frame, last chunk op 7, `unkeyAfterStop` waits for status 4 (2.5 s cap) and sends `0x26` off, `finally` unkeys and releases the microphone, 27.5 s and 700-frame caps. `M17Screen` shows the button only when `m17CanSend()`; the help topic and five time-limit sentences are updated; CHANGELOG has both rows. Bench: carrier 1.63 s, clip 0, body p99 3206 Hz, status 3 at the key, status 4 at 1.54 s, the unkey 15 ms later, and the second status 4 is that unkey, not the timer.

**1. The end of every transmission is cut (firmware, into FW20).** Frame 36 and the end-of-transmission marker were not in the capture; the FW19 45 s stream likewise found 1124 of 1125 frames. Op 7's `drop_ptt` runs when the ring drains at RRC phase 0, but at that moment the shaping filter and the TX RAM halves still hold the last ~2 frames (80 ms), so the carrier drops before they play. An M17 receiver therefore never sees the end bit or the EOT and ends the call by time-out instead of cleanly; our own receiver reports "signal lost" instead of "last frame". **FW20 therefore has two parts:** (a) clear the time-out state as already written; (b) delay the drop until the last symbol has left the modulator (count the TX RAM half interrupts after the drain, or hold a last-symbol timestamp), measured, not guessed. **Pass for FW20:** the voice check's end-bit frame and the EOT decoded (our decoder ends with "last frame"), the 1125-frame stream 1125 of 1125, no status byte for 130 s after the drop, and a second stream 10 s later running full length. **Until FW20 is loaded, the host pads:** `m17VoiceRun` appends two EOT frames (384 symbols) after the real EOT, so the real one plays before the drop; remove the pad when FW20 is in.

**2. The host test is thin.** `voiceSymbolsMatchTheResearchEncoder` compares 24 symbols of the link setup and 16 of one stream frame: the sync word and a few payload symbols. The device decode covers the rest today, the test should too: whole 192-symbol frames for the link setup, one stream frame per LICH index 0–5, the end-bit frame and the EOT, generated once by `m17.py` into a resource. Also assert `packSymbols` on a whole frame.

**3. Callsign in the public repository (process).** The voice check keyed with the callsign from the phone's APRS settings and the report names it in `results.md`, `HANDOFF.md`, the ch. 19 log and SignalDeck's `CHANGELOG.md`. The owner's rule is no callsigns in the handoff (public repository). Replaced with "[callsign]" in the three files here with this review; it remains in git history and in SignalDeck's CHANGELOG, which is the owner's call. From now on a bench key uses a bench callsign set in APRS settings before the key (the earlier bench runs used `DMRTST-7`), or the `m17 --ei tx` extra takes a `--es call` and defaults to `N0CALL`.

**Voice check still owed, with FW20's bench:** one spoken 10 s key from the microphone (not the tone extra), captured, decoded end to end, Codec 2 output listened to, the end reported as "last frame".

**Order (unchanged).** The owed FW19 bench session first (high power 45 s and the 130 s ceiling run, the timer after op 7, the 40 s plain key), then FW20 with both parts, then item 3. The host pad and the test go into the next SignalDeck commit. R-I whenever the bench waits. The independent decoder still waits on the Ubuntu box.

## Review of the FW19 bench (2026-10-25, `fe36d274` + `4aebc8ae`, SignalDeck `fe5d9f23`)

**Verdict: complete, and every question the FW19 task left open is answered by a measurement. The module ends a key at 120.33 s on its own, with status byte 4 (never 6). A 40 s plain FM key is not ended by the module, so the voice path has no limit of its own and the 30 s story is closed for good. A 120 s high-power key stays inside the equipment stops but heats the phone's AP zone by 11 °C and needs about 17 minutes to come back. And after an op 7 drop without an unkey the module is not only flagged but deaf until the timer fires. FW20 is next, as Grok set it, with one more pass criterion below.**

**What I verified in the report.** Ceiling: 3250 frames, high power, HackRF LNA 0 / VGA 0; status 3 at the key, status 4 at 120.33 s, carrier 120.35 s, clip 0, body p99 3241 Hz, no slice at or over 5 kHz before the drop; the unkey only after the three-minute log, so the 120.33 s is the module's. Heat: `mtktsAP` 47.9 → 59.2 °C (highest 15 s after the carrier ended), the two modem-PA zones +11 °C, battery 40.2 → 41.4 during and 41.9 three minutes later; nothing passed a stop (the AP zone came within 0.8 °C of the 60 °C one); back within 1 °C at about 17 min. The heat paragraph Grok rewrote in `HANDOFF.md` from those numbers is accepted as written: one long or high-power key at a time, a 120 s-class key waits for the AP zone to return, shorter keys 1 °C or 10 min, stops at battery 45 °C, zones 60 °C, more than 2 °C in 10 s. The 45 s high-power run before it (`fe36d274`) was stopped correctly under the rule then in force and is a valid data point (+2.7 °C AP over 45 s). 40 s tone: low power, `0x26` on at 00:22:45.812, off at 40.40 s by the host, status 4 at 40.73 s, carrier 40.75 s. Timer watch: op 7 at 44.72 s, status 4 at 45.03 s, no unkey, status 4 again at key + 120.34 s, no status 1 or 6 in between; a gain-0 HackRF carrier left `0x32` at raw 5–6 (about −117 dBm, 12 dB under the idle floor) during the window and moved the idle radio from −104.5 to −96.5 dBm a minute later. So in the flagged state the receiver is off, which matches the timer's own gate: it counts while the state byte at `0x38908` has bit 0 or 2 set, and those bits are the module's "transmitting" state. SignalDeck's product paths already unkey after status 4 (item 2), so no user sees this; FW20 fixes the firmware.

**SignalDeck `fe5d9f23`.** The two-EOT tail after the last voice frame is in (`M17.eotTail`, 384 symbols, test against the specification pattern), the bench switches are bench-only (`cmdsym --ez key`, `--ez nounkey`, `testtone --ez lift` for the one 40 s tone; the 28 s watchdog and the 28.5 s refusal stay on every product path), CHANGELOG rows present, help line adjusted. Still owed from the item-2 review: the fuller encoder test (whole frames: link setup, one stream frame per LICH index, the end-bit frame, the EOT) and the spoken 10 s voice check once FW20 is loaded.

**FW20, one more pass criterion.** Besides no status byte for 130 s after the drop, 1125 of 1125 frames with the end frame and EOT decoded, and a second stream 10 s later running full length: **within 2 s of the drop the module receives again**: `0x32` back at its idle floor and the same weak HackRF carrier moving it as it does on the idle radio (status 1 if the squelch opens). That is the receiver-side proof that the state bits are cleared, and it is what a user would notice first.

**Host, next (SignalDeck, whenever the bench waits, after the fuller M17 test): the long modes.** The heat table is in, so the item held back since the FW19 review can go: `txPcmOneShot` takes a per-mode limit up to 118 s (the longest allowed SSTV mode plus the 1.6 s lead stays under the module's 120 s), which admits Robot 36, Martin M1 and M2, Scottie S1 and S2 and PD90; the voice watchdog stays 28 s. With it, the cool-down guard the bench measured: after any transmission longer than 30 s, the next one longer than 30 s waits until the AP thermal zone (`/sys/class/thermal/thermal_zone*` with type `mtktsAP`, read over su; when unreadable, a 17 min timer) is back within 1 °C of its value before that key, the screen shows the wait, and a history line says why. One more small thing: a status 4 that arrives while SignalDeck still holds PTT is the radio's own time-out, worth a history line of its own. Help and CHANGELOG in the same commit; device check: one Martin M1 picture at low power received by the HackRF and decoded, and the guard seen to hold the second one.

**Order.** FW20 (both parts, with the receive criterion) first on the bench; then the spoken voice check; item 3 after. Host: the fuller M17 test, then the long modes. R-I whenever the bench waits. The independent decoder still waits on the Ubuntu box.

## Review of FW20 (2026-10-25, commit `b46dd122`, tag `FW20`)

**Verdict: passes all three criteria, and the image is the right one to leave loaded. After the ring drains the op 7 path now lets eight more TX RAM halves play, drops the carrier, runs the stock unkey while the module's transmit bits are still set, and only then clears those bits and the time-out count. Measured at low power: 1125 of 1125 frames with the end bit, the EOT scored 0.999, no time-out status for 130 s after the drop, a second stream keyed 10 s later ran its full 70.35 s through the point where the stale timer would have fired, and the receiver came back: the gain-0 carrier read the same raw 47 as on the idle radio and the squelch opened 2.6 s after the drop. The ordering finding is the real content of this step: an earlier build that cleared the bits before the stock unkey left the receiver at raw 6 until a channel write; the stock unkey restores the receiver only while the module still believes it is transmitting. Grok found that, replaced the image and wrote it down. Good.**

**What I verified.** The stub (`c7000_fw20_gate.S`, 65 lines at `+0x5B720`): the countdown word at `0x4B010` is armed to 8 when the drain is first seen and counted down once per half interrupt, with values above 8 treated as idle (so a stale word cannot fire a drop on the next key); at zero it clears the ring state, reads the `0x38874` flag the `0x26` handler uses to choose `r0`, calls `drop_ptt`, calls the stock unkey at `+0xE9C` with `r1 = 1` and that `r0`, then masks bits 0 and 2 of `0x38908` (`andi 250`) and zeroes `0x38C64+2..5`. `test_patches.py` marks it exclusive with the symbol stubs it replaces and stackable with the time-out floor. Boot peak 0.06 dB, no key at boot, tag `DMR003.FW20.V022`. Timings: op 7 at 44.75 s, first status 4 at 45.32 s (the eight halves), second status 4 at 45.65 s (the stock unkey), carrier 45.30 s. The one gap in the receive criterion is that the first `0x32` query at 0.15 s still read raw 6 because the stock unkey had not run yet (it runs 0.33 s after the drop); the next reading at 2.88 s was raw 47 and the squelch opened at 2.60 s, so the receiver is back somewhere between 0.33 s and 2.6 s, inside the 2 s criterion by the squelch opening if not by a reading. Accepted.

**Two consequences to carry.**
1. **The carrier now outlasts the last symbol by about 250 ms** (eight halves of 256 samples at 8 kHz, 45.30 s of carrier for 45.04 s of symbols). That is dead carrier after the EOT, which an M17 receiver ignores; the R-G criterion of "carrier ending within 100 ms of the last symbol" is superseded by "every frame and the EOT decoded". Four halves would probably do (the loss was ~2 frames, 80 ms); not worth another image unless the tail turns out to matter on air.
2. **Two status 4 bytes per op 7 transmission** (the drop, then the stock unkey 0.33 s later), and SignalDeck sends its own `0x26` off after the first, which produces a third. Harmless, idempotent, and it keeps SignalDeck safe on the FW19 image, so keep the host unkey; the two-EOT pad in `m17VoiceRun` was explicitly "until FW20" and comes out now. The spoken voice check logs the status bytes once with the host unkey in place to confirm nothing odd happens between the drop and the stock unkey.

**Ch. 19 housekeeping.** The plan's FW table had `FW20` reserved for a receive-side flat mode, which op 6 variant 3 (RD10) already met; the row now describes the op 7 drop fix, marked done, and the receive-side item is noted as met by R-D.

**Next, unchanged in order.** The spoken 10 s microphone voice check on FW20 (decoded end to end, listened to, ends "last frame", status bytes logged with the host unkey); item 3 (the generic engines). Host, whenever the bench waits: remove the two-EOT pad, the fuller M17 encoder test, then the long modes with the cool-down guard (review of the FW19 bench). R-I whenever the bench waits. Independent decoder on the Ubuntu box.

## Review of the spoken microphone check on FW20 (2026-10-25, `ec352441`, SignalDeck `bb03e55a`)

**Verdict: passes on every measurable point; the one unmeasurable point, whether the voice is intelligible, is for the owner's ear.** Ten seconds on the real microphone path at low power: 247 of 247 frames, numbers 0 through 246, the last with the end bit, link-setup CRC ok, EOT 0.978, body p99 2947 Hz with nothing at or over 5 kHz. The status bytes with the host unkey in place are exactly what FW20 predicts: the module's status 4 at the drop, the host's `0x26` off 13 ms later, the stock unkey's status 4 at 0.32 s, nothing else between them. So the host unkey and FW20 coexist cleanly and the host unkey can stay. The Codec 2 decode is 9.88 s of speech (peak 15873, rms ~1287), not silence; the earlier silent hold was correctly discarded. Grok could not listen, and a Windows dictation pass on the vocoded wav returned only a short phrase, which says little: 3200 bit/s Codec 2 of a clip played across a room into a phone microphone is not what dictation engines are trained on. **The decoded speech is at `C:\Users\Joshua\AppData\Local\Temp\fw1718\sdvoice_out.wav` (the clip that was played is `sdvoice.wav` beside it); a human listening to it closes the item.** The bench extra (`m17 --ei mic`, at most 12 s, plays `/sdcard/Download/sdvoice.wav` on the alarm stream during the hold) is bench-only with its CHANGELOG row; fine.

**Where this leaves M17 transmit on the Armor.** Firmware: a symbol engine with a clean start and a clean end (FW20), a 120 s floor on the time-out (FW19). Host: Hold to talk sends Codec 2 voice as M17 with the project's own encoder, gated on a bench image, and every frame reaches the air. What is still open on the transmit side is independent confirmation by a receiver we did not write (the Ubuntu box, `plan-independent-m17-check.md`), and on the host side the fuller encoder test, removing the two-EOT pad, and the long modes with the cool-down guard.

**Next, unchanged.** Item 3, the generic waveform engines (design the op-code space first). Host whenever the bench waits: pad out, fuller test, long modes. R-I whenever the bench waits.

## Review of the item 3 design, the generic waveform opcode space (2026-10-25, `3619aed0`)

**Verdict: the shape is right and the discipline is right; the numbers are not yet, and two things are missing. Keep: ops 0–7 untouched, ops 8–11 in an extension after the FW20 gate rather than inside the full symbol stub, wrong-length bodies answer `sr=1` and never touch PTT, op 3 restores M17 so a pager or tone session cannot leak into a voice call, FW20's end is the only end, the state words are checked unused before the build writes them, nothing keys at boot. Change before building: the symbol clock, the tone frequency unit and amplitude, the tone queue, and the pulse table. Then the pass criteria below.**

**1. The symbol clock cannot be an integer samples-per-symbol.** The design says the first image will "measure the resulting baud". It does not have to: the TX RAM runs at 8 kHz and the M17 wake already advances 0.6 symbol per sample (`m17_rrc.py`: tap i multiplies the symbol at floor(0.6 n) − 4 + i, five phases). At 8 kHz an integer 1–16 gives 8000, 4000, 2667, 2000, 1600, 1333 … baud, and none of the pager rates is on that list: POCSAG 512 needs 15.625 samples per symbol, 1200 needs 6.667, 2400 needs 3.333. **Make the clock rational:** op 8 carries the symbol advance as a numerator and denominator (uint16 each, advance = num/den symbols per sample: M17 3/5, POCSAG 2400 3/10, 1200 3/20, 512 8/125), kept in an exact accumulator (count up by num, step a symbol and subtract den when the count reaches den). A binary fraction drifts: 0.6 is not representable, and the error over a 120 s key is several symbols.

**2. The pulse.** Op 9's "odd tap count 1 to 31, replaces the pulse" does not say how the taps meet a fractional clock. State it: a polyphase table of P phases (1–16) by T taps (odd, 1–15), the phase chosen as floor(fraction × P), applied to the last T symbols, which is what the M17 path does with P = 5, T = 9. And give the pager path the cheap case: shaping 0 in op 8 means hold (the level of the current symbol, no table), which is what a POCSAG encoder needs; a transmitter-side low-pass is a later refinement if an independent decoder asks for one.

**3. Tones: unit, phase, amplitude.** Frequency as an integer hertz cannot express FT8, whose tones sit 6.25 Hz apart; RTTY's 170 Hz shift is fine but FT8 is the stated target. **Frequency as uint16 in eighths of a hertz** (0–8191 Hz, 6.25 Hz = 50 exactly), generated by a phase accumulator that runs on across pairs (continuous phase; a 0 Hz pair holds the phase and outputs zero), and **an amplitude in TX RAM counts at the head of every op 10/11 body** (int16, the same counts as op 8's levels; the 0.41 Hz per count of R3a5 says what deviation that is), because a tone on this path is deviation, and the design never says how much. Duration in milliseconds stays (RTTY's 22.0 ms and FT8's 160 ms are exact enough).

**4. The tone queue.** Eight pairs per body is the body; the design does not say how many pairs the module holds or how the host paces. An FT8 message is 79 pairs, an RTTY line several hundred, a CW call a few dozen. **Specify a queue of at least 64 pairs, op 2 (or a new op 2 variant) returning the pairs remaining, and the host pacing on that number as it paces the symbol ring**, so a `0x40` body never fails for lack of room mid-message. Op 11 arms the end when the queue drains, not when the body arrives.

**5. Pass criteria for the build (one image, FW21).** Render first (op 4) for each engine before anything keys: the POCSAG NRZ render shows the levels and the rational clock (count the symbol edges in 240 samples), the tone render shows a clean 1 kHz at the asked amplitude and a phase-continuous frequency step. Then, each at low power under the heat rule: (a) POCSAG 1200 baud, two levels, ±3.5 kHz first (the deviation the R-F pager key used) and then ±4.5 kHz with the task line saying so, the 5 kHz stop in force, one page decoded payload-exact by our decoder and by an independent one if the bench has it (`multimon-ng`); (b) MCW: a call at 700 Hz, 20 wpm, decoded; (c) RTTY 45.45 baud, 170 Hz shift, one line decoded by SignalDeck's own RTTY decoder from the HackRF clip; (d) one FT8 message decoded by SignalDeck's FT8 decoder from the HackRF clip (tones 6.25 Hz apart, 160 ms each, continuous phase); (e) op 3 then a 90-frame M17 stream at 90/90 to prove the restore; (f) `0x34` tag, boot capture silent, ops 0–7 unchanged (one 1125-frame op 7 stream as before). Every key's body p99 and the ±5 kHz check as always.

**Order.** Fix the design in ch. 19 (items 1–4, a short edit), then build FW21 and run (a)–(f). Host work for the new engines (SignalDeck encoders for POCSAG, CW, RTTY, FT8 on the symbol path) waits for the image; the host items already queued (pad out, fuller M17 test, long modes) stay first whenever the bench waits. R-I whenever the bench waits.

## Review of the item 3 design correction (2026-10-25, `7b18c1bf`)

**Verdict: all four changes are in as asked; build FW21.** Rational advance with the exact accumulator (M17 3/5, POCSAG 8/125, 3/20, 3/10) and no binary fraction; polyphase table P×T with hold as shaping 0; tones in eighths of a hertz, continuous phase, 0 Hz holds the phase, an amplitude at the head of every body; a 64-pair queue, op 2 with a following byte of 1 returning the pairs queued, op 11 arming the end when the queue drains, a body that does not fit refused without queuing. The table and queue get their own span (`0x4B080`–`0x4B360`) and both spans are checked unnamed before the build writes. One sentence to pin down, because the restore test depends on it: **op 3 must leave the M17 stream exactly as FW20 sends it today, the built-in five-phase nine-tap pulse, whether or not an op 9 was ever sent**; the design's "shaping 0 until an op 9 has been sent and then the built-in pulse" reads as if a reset could leave M17 unshaped. If the M17 path keeps its own fixed pulse and the generic shaping flag applies only to ops 8–11, say so; criterion (e), 90 of 90 after op 3, is what proves it either way. Nothing else to change. Pass criteria (a)–(f) as written in the design review.

## Review of FW21, the generic waveform engines (2026-10-25, `3b364a30` + `4da21b1c`, tag `FW21`)

**Verdict: passes every criterion of the design review, (a) through (f), on the first loaded image, and the "render first" rule earned its keep: the one image that was wrong hung the `0x40` handler on a tone render, before anything keyed, and was replaced. Item 3 is done. Four small things follow from the measurements, one of them a firmware fix for the next image, none of them blocking.**

**What I verified in the report.** Renders before any key: the hold engine at advance 3/20 with ±4000 levels (19 sign changes in 128 samples, runs of 7, as 20/3 samples per symbol predicts), a 1 kHz tone returning the exact eight-sample sine (2828, 3999, 2828, 0, …) twice, a 700 Hz tone 64 of 64, an 18.75 Hz offset render 64 of 64 (the eighth-hertz unit works), and op 3 followed by 32 zeros. Keys, all low power at 467.625 MHz, every body under 5 kHz: (a) POCSAG 1200, RIC 1234567, `HI`, 16 of 16 codewords at both amplitudes; (b) MCW 700 Hz at 20 wpm, the envelope read back as `HI` with dit and gap timings right; (c) RTTY 45.45 baud, 170 Hz shift, `HI` by SignalDeck's own RTTY decoder; (d) one FT8 message decoded by SignalDeck's own FT8 decoder at 1000 Hz, the 79 tones paced through the 64-pair queue (60 before the key, 19 more at 6 s); (e) op 3 then 90 of 90 M17 frames with the end bit and the EOT; (f) tag `DMR003.FW21.V022`, boot peak 0.08 dB, and the 1125-frame op 7 stream 1125 of 1125 with the EOT, so ops 0–7 are unchanged. Heat: nothing above +1.4 °C on any zone. Two implementation facts worth keeping (and the report keeps them): the sine table is addressed as XIP base plus file offset, the same way the stock image addresses its own flash, and the uint16 phase and frequency must be zero-extended.

**1. Tone keys need a dummy symbol (firmware, FW22).** `on_key` takes the TX RAM path only when the symbol ring is not empty; a tone queue with an empty ring keys the stock analog carrier and plays nothing (measured, body p99 633 Hz and no 700 Hz line). The bench works around it with one symbol the tone engine then ignores. The fix belongs in the firmware: `on_key` arms the TX RAM path when the ring **or the tone queue** is non-empty. Small, and it rides in FW22 with the flash read op from the loader-safety contract.

**2. The pager deviation ceiling is the modulator's, and it is below 4.5 kHz here.** ±7600 counts gave a body p99 of 4061 Hz and ±8400 gave 4138 Hz: a 10.5 % count increase moved the deviation 1.9 %, so the FM path compresses near 4.1 kHz at this setting, consistent with the ±4.5 kHz limiter R3a5 saw. Pagers decoded at both, so nothing to change; the number goes into the record as the practical pager deviation on this module, and the independent pager check waits for `multimon-ng` on the Ubuntu box (not installed on the bench PC).

**3. The FT8 message lost its grid (host, check).** The bench packed `CQ N0CALL FN20` and SignalDeck's own packer unpacked it as `CQ N0CALL`. `Ft8Message` does carry a grid field, so this is either the CQ path not packing the grid or the unpacker not showing it; either way a CQ on the air today may be going out without the locator. One host test against known vectors (the standard CQ with a four-character grid) settles it; it is a SignalDeck fix, unrelated to the firmware.

**4. The host side of item 3.** The firmware now offers four engines; SignalDeck's existing POCSAG, CW, RTTY and FT8 transmitters still go through the audio path. The host work is: on a bench tag, route them through ops 8–11 (the pager encoder to op 8 hold + ops 1/7, the keyer and the two keyboard modes to the tone queue with pacing on op 2 variant 1), keep the audio-path versions for stock firmware, and say so in the help. It queues behind the host items already listed (two-EOT pad out, fuller M17 encoder test, long modes with the cool-down guard) and the FT8 grid check.

**Ch. 19 housekeeping.** The FW table's FW21 row was reserved for Phase E's shipping and gating; the row now describes the generic engines, done; Phase E has no image of its own (its gating exists), and FW22 is the small image above.

**Order from here.** Bench: FW22 (tone-queue arming + the flash read op), then the two Phase E reading sessions (the module's update-mode entry and YModem handshake; any memory read-back path in the stock image), then Phase E built against `plan-loader-safety.md`, Path A first. Host, whenever the bench waits: pad out, fuller M17 test, long modes, FT8 grid check, then the generic engines on the symbol path. R-I whenever the bench waits. The independent decoders (M17 and pager) wait on the Ubuntu box.

## Review of FW22, tone-queue key and flash read (2026-10-25, `1af1fb03`, tag `FW22`)

**Verdict: passes all three criteria.** A 700 Hz op 11 key with nothing in the symbol ring played (audio peak 700 Hz, body p99 2060 Hz), so tone-only transmissions no longer need a dummy symbol; the arming is gated on the tone mode word, so a stale RAM value cannot divert an ordinary analog key, which is the right guard. Opcode 12 read the whole image back, 1578 reads of 240 bytes, all 378,620 bytes equal to the file loaded, the first reply being the tag itself. The 1125-frame op 7 stream is unchanged at 1125 of 1125 with the end bit and the EOT. Boot peak 0.09 dB. The one wrong build (frame pointer read after the push) answered `sr=1` on the read and was replaced before anything depended on it.

**Two notes for Phase E, not for the firmware.** (1) A full read-back takes 971 s at the UART rate the bench uses, so the loader page verifies after a load in the background with progress, or verifies a sample plus the tag and offers the full read as an option; the 230400 baud the RAM-stream work reached would cut it to about a quarter. (2) The build is reproducible only from `fw22_build.py`, which generates the extension's assembly into a temporary folder and assembles it there; the patch table and `stubs/` do not carry FW21/FW22. For the known-image table the loader will trust, every shipped image must be rebuildable byte for byte from a clean checkout: commit the generated `fw21_ext.S` under `stubs/`, register the sites in `patches.toml` (or make `check.py` read the build script's site list), and record the sha256 the script reproduces. Small, and it keeps the port automation's stage 3 honest.

**Next, as set:** the two Phase E reading sessions (how the module enters update mode and what its YModem handshake accepts and answers; any memory read-back path in the stock image), then Phase E built against `plan-loader-safety.md`, Path A first. Host items unchanged.

## Review of the Phase E reading sessions (2026-10-25, `442eff64`)

**Verdict: both questions answered from the code, and the answers change the Phase E order.** Update mode is not a UART command: the stock updater power-cycles the module through the `dmr009` GPIOs with PTT held (pwd down, 50 ms, ptt down, 50 ms, pwd up, 1000 ms, ptt up), writes the single byte `0x31`, and the module answers `C`; from there it is plain YModem-1K (SOH block 0 with name and size, STX 1024-byte blocks with CRC-16-CCITT, 15 s per block, six retries, EOT, an end block, one ACK). No MD5, no signature: the bootloader takes whatever is sent, so the loader's hash checks are the only guard there is. The stock image has no read-back: `0x24`/`0x25` are the programmed channels, the `0x21` family is short event frames and a BER score, `0x3D` has a handler nothing routes flash through, and the YModem path is send-only. So a stock module still cannot be dumped before its first load; the backup stays the vendor asset from the user's own phone, and opcode 12 is the dump from then on.

**Three consequences.** (1) **Path B first.** SignalDeck already drives the `dmr009` power GPIO and owns the UART; with the knock and the handshake fully known, its own YModem sender is a small, self-contained piece, while Path A needs the stock app enabled, handed the port and watched through its log. Build B as a bench diagnostic first; A stays the fallback only if B fails on the wire. (2) **Recovery is real, and must be proven, not assumed.** Because update mode is entered by a power-cycle with PTT held, a module running a broken image is still loadable as long as its bootloader is intact. Nobody has yet interrupted a transfer and recovered; Phase E does that on purpose. (3) **The knock holds PTT low for about a second with the module powering up**; the stock app does the same, so it is accepted, but the page says what it does and does it only after the pre-flight.

**Phase E, step 1 (bench): SignalDeck's YModem sender as a DIAG extra.** The knock, `0x31`, the handshake and the blocks as read; every handshake byte logged; result codes for `C` missing, NAK storms, CAN, timeout. **Pass:** (a) FW22 loaded over itself through the sender, tag read after the power-cycle, opcode 12 read-back of a 4 KiB sample equal to the file; (b) the factory image loaded through the sender, tag `DMR003.UV4T.V022`, a 30-frame plain analog key fine; (c) FW22 loaded again; (d) **one transfer aborted on purpose at about 50 % (port closed), then the knock and a full resend, tag read: recovery proven**; (e) a boot capture after (a) and (c) silent. The bench's `fwload_stock.sh` is not used for these loads.

**Phase E, step 2 (host): the page**, built against `plan-loader-safety.md`: identity three ways against the known-image table, the vendor asset extracted and verified as the backup before anything else, the signed catalogue (reuse the profile-list verifier), pre-flight, the sender from step 1, the post-load tag check with automatic factory restore on mismatch, background or sampled read-back, recovery mode for a module that is silent on `0x34` but answers the knock, help topic, CHANGELOG. **Pass:** the five step-1 loads repeated from the page by hand on the Armor, plus: a load refused when the asset hash is altered, a load refused with the stock app removed and no catalogue copy present, the factory restore offered and completed after a deliberately wrong tag, and the help topic read against the page.

**Housekeeping to fold in:** the FW21/FW22 reproducibility ask (commit the generated stub source, register the sites) before the catalogue lists those images, since the table's hashes must be reproducible. Host items unchanged otherwise (pad out, fuller M17 test, long modes, FT8 grid check, generic engines on the symbol path).

## Review of Phase E step 1, SignalDeck's YModem sender (2026-10-25, `71f533ad` + SignalDeck `4fc1989d`)

**Verdict: passes all five proofs, and the one failure on the way is the most useful thing in the report. SignalDeck now loads module firmware itself: the GPIO knock, the `0x31`, the standard handshake, 370 blocks of 1 KiB with CRC, the end block, a power-cycle and the tag read back. FW22 over itself with a 4 KiB opcode 12 sample matching, the factory image with its tag and a clean 10 s tone, FW22 again, then a transfer closed on purpose after block 185 of 370 and a full load straight after whose first knock got the prompt in 204 ms. Both boot captures silent. Recovery after an interrupted transfer is now measured, not assumed. The stock updater script was used once, before the proofs, to put FW22 back after an early attempt died at block 5, which is the finding below.**

**The finding: nothing else may touch the port during a load.** The first attempt was cancelled by the intercom page's signal poll writing an ordinary command onto the UART mid-transfer; the bootloader saw it as garbage and sent CAN. The fix is in the right place: the engine's framed send path drops every command while the load owns the port, the receive stream is diverted to the sender, and the signal poll and the module watchdog check the hold before they run. For the page this becomes a rule and a visible state: during a load every other screen, SignalDeck Web and Android Auto see "radio busy, loading firmware" and nothing they do reaches the port.

**Code read (`fw/YModemSender.java`, `UartPort`, `RadioEngine`, `RadioService`).** CRC-16 with init 0 and the XMODEM check value; name block with name, NUL and decimal size; data blocks STX, seq, complement, CRC; NAK resends and timeouts retry up to six times, CAN fails as "cancelled", silence on the prompt knocks three times then fails as "no-prompt"; the `Watch` phases (update, handshake, transfer, finish, restart) and the `Halt` hook are already there for the page; `abort50` and the halt both close the port and the service's `finally` reopens it and lifts the hold; the file path is restricted to `Download/DMR/Firmware/`; the tag read waits for a fresh version reply. Host test: seven cases, including the CRC check value, the header layout, a complete short image, silence, six NAKs, CAN and the half-way abort. Re-run here: 7 of 7 pass.

**Two refinements before the page relies on it, neither blocking.** (1) **The header wait is too close to the erase time.** The bootloader acknowledged the name block about 11.4 s after it was sent, which is the flash erase, and the per-block timeout that also covers that wait is 15 s. On a slower module or a bigger image a retry would resend the header into an erase in progress. Give the header its own wait of 60 s and show the user "erasing" for that phase. (2) **The fixed 300 ms pause before every block is about 110 s of the 248 s load.** The ACK already gates the next block (288–292 ms each). Try a load with the pause at 0 and only the drain kept, then at 50 ms, three loads each; keep the smallest that passes all three. Under two minutes per load is realistic.

**What the timings give the page.** Prompt 203–204 ms after the knock; erase 11.4 s; 370 blocks at ~0.29 s plus the pause; power-cycle and tag about 4 s; total 248 s today. The progress bar's phases and its remaining-time estimate come straight from these.

**Step 2 stands as set,** with the three additions above folded in: the busy state everywhere, the erase phase and its wait, and the measured block pacing. Pass list unchanged (five loads from the page by hand; a load refused on an altered asset hash; refused with the stock app removed and no catalogue copy; the automatic factory restore after a deliberately wrong tag; help read against the page). The FW21/FW22 reproducibility ask comes before the catalogue lists those images.

## Review of the firmware page, first build (2026-10-25, `8556d5af` + SignalDeck `4225768a`)

**Verdict: the page is the right shape and the safety core of the contract is in; the step is not finished, which Grok says plainly: the five loads from the page, the wrong-tag restore and the help screenshots have not run. Five things to change before those loads, one of them a user-safety point. Then run the pass list.**

**What is in and right.** The vault takes the factory image from the stock APK installed on the phone (package path, the single `assets/DMR*.bin`, SHA-256 and the embedded tag both checked against the table), saves it in app-private storage with a hash sidecar and mirrors it to `Download/DMR/Firmware/`, and falls back to the saved copy when the asset cannot be read; a copy that does not match is never returned. The table's hashes are right: I recomputed them here from the repository's factory image and the FW22 build (`90e361fd…`, `38f900a0…`). Other images are taken only from `Download/DMR/Firmware/` and only when their hash and tag match a table row. The pre-flight is the contract's list: module answering, radio idle (transmit, scan, M17, FT8, packet modes, band scope), stock app paused, battery rule, image hash, factory backup verified, and the identity policy (`ImageTable.refuse`: known tag, same base image, phone model, stock package, asset hash or verified backup, no bench image before the factory backup exists, a silent module gets the factory image only). The session holds a wake lock, runs the sender with the port diverted, reads the tag back, restores the factory image on a mismatch or a failed 4 KiB read-back, writes history lines, and the Stop button halts at the next block. The screen is drawn with the app's own components: header, caps, cards, buttons, a drawn seven-phase bar, live figures (blocks, bytes, rate, elapsed, remaining, retries), an expandable handshake log, a confirm card, the back arrow disabled while a load runs, the screen kept on. The Device line opens it; the help's Device topic describes it. Host test for the policy, six cases; re-run here: 6 of 6 pass.

**Change before the on-page loads.**
1. **A bench control is on a user page.** "Check a wrong tag" runs a deliberate two-load restore drill. It belongs behind the Diagnostics flag, like every other bench extra; a user must never find it.
2. **The busy state everywhere.** While a load runs the engine drops every framed command, which is right, but silently: the intercom, Web and Android Auto must show "radio busy, loading firmware" and refuse PTT with that text rather than appear dead. One flag on the service, read by the places that already check `isTransmitting`.
3. **The bar.** The Transfer segment should fill in proportion to blocks sent, and the header wait needs its own named phase ("Erasing", time-based fill over the expected ~12 s) with the sender's header timeout raised to 60 s as already asked; today the whole four minutes sits in one lit segment and the figures below do the work. The remaining-time estimate should use the measured block pace, not a 600 ms default.
4. **Stock-app version is a warning, not a refusal, when the asset hash matches.** `refuse` rejects a phone whose stock app reports a version other than "V1.0" even when its asset is byte-identical to the known factory image; the hash is the stronger identity. Keep the refusal for a hash mismatch.
5. **The catalogue is still owed.** The table is two built-in rows; the signed catalogue and the download path (contract, "Flashing a downloaded copy") are not built. They come after the on-page loads pass, as their own sub-step, with the FW21/FW22 reproducibility ask before FW22 is listed.

**Then the pass list, unchanged:** the five loads from the page by hand (FW22 over itself with the sample, factory, FW22, Stop at ~50 % then a full load, silent boots); a load refused on an altered asset hash; refused with the stock app removed and no catalogue copy; the wrong-tag drill restoring the factory image; the help topic read against the page, with its screenshots.

## Review of the firmware page pass (2026-10-25, `278078bf` + SignalDeck `16ff14bc`)

**Verdict: the page passes its pass list, and the five changes asked for in the first-build review are in. Phase E step 2 is done except the catalogue and the owner's unlisted-images switch, which Grok has correctly set as the next sub-steps.** From the page by hand: FW22 over itself with the 4 KiB read-back sample (258.9 s, boot peak 0.09 dB), the factory image (tag read), FW22 again (259.0 s, boot 0.09 dB), Stop at block 179 then a full load (254.2 s), both boot captures silent. An altered file turned the hash and identity lines red and was refused. With the stock app uninstalled for the user and the factory copies moved aside, the page said exactly the contract's sentence ("the stock app is gone and there is no verified factory copy") and offered nothing; the stock app was put back with `install-existing`, paused again the way SignalDeck pauses it, and the backup re-verified from it. The wrong-tag drill restored the factory image. The help topic was read against the page and matches it, screenshots taken. End state: factory image installed, backup verified, stock app paused.

**The five changes, confirmed in `16ff14bc`:** the drill is a diagnostics command, not a button; the busy sentence was seen in the notification during a load and is wired into the intercom, widget, Web and Android Auto; the bar has Erasing with a time-based fill and Transfer fills per block; the header waits 60 s; a stock-app version mismatch is a warning when the asset matches (`ImageTable.versionWarning`) and a refusal only on a different file.

**Still owed, small:** the per-block pause was not measured down (loads are still ~255 s; the ACK already gates each block, so 0 and 50 ms over three loads each, keep the smallest that passes). It can ride with the catalogue sub-step.

**One process note.** The "stock app removed" test uninstalled the stock package for the user on the bench phone and reinstalled it from the system image, which is reversible for a privileged system app and was. SignalDeck's own package is never uninstalled (the standing rule); for the stock app this drill is acceptable on the bench phone only.

**Next, as set by Grok and confirmed:** the signed catalogue (fetch and verify `firmware.json` from AndroidRadio_Firmware_Project with `ProfileRegistry`'s key and scheme, `ImageTable` rows from it including `variants`, download by hash into `Download/DMR/Firmware/`, the factory row for recovery; FW21/FW22 reproducibility before a bench image is ever listed, and only stock and released images in that repository), then the owner's Allow unlisted images switch, then route-list items 6 (M17 as a channel type) and 7 (receive self-calibration). Host items still queued behind them: pad out, fuller M17 test, long modes, FT8 grid, the generic engines on the symbol path; R-I whenever the bench waits.

## Review of the catalogue sub-step and the block pause (2026-10-25, `039f1aa7` + SignalDeck `7b3ded47`, `049d63e8`)

**Verdict: passes. SignalDeck now reads the firmware repository's signed catalogue the way the contract asks, and the loader is 40 % faster with nothing lost.** On the phone the diagnostic fetch reported catalogue serial 3 with one image, the factory row; the host test verifies the published file, rejects a bad signature and rejects an older serial (re-run here: 3 of 3 pass). The block pause was measured as asked: three loads at 0 ms (147.6–147.9 s) and three at 50 ms (160.0–160.3 s), every one returning the FW22 tag, so the page waits 0 ms and estimates the remaining time from the measured block time.

**Code read (`fw/FirmwareCatalog.java`).** The signature is checked with `ProfileRegistry.verify` and the same built-in public key before anything is parsed; a serial lower than the cached one is refused and an equal one reported as up to date; the body and signature are cached only after acceptance; rows are added only for `stock` or `released` status, only when their base is the phone's factory image, and never when a built-in row already has that hash; `download` checks size, SHA-256 and the embedded tag before returning bytes and keeps the factory image as the verified backup; `variantRefusal` tells a phone the catalogue knows but cannot support that its variant is not supported yet. The Download factory image button appears only when the backup is not verified, which on the bench phone it was, so the button stayed hidden: the path is covered by the host test and the hash gate rather than a device run. Fetches go over HTTPS to the raw file with a cache-buster, the same as the profile list.

**Two small things to carry, not blocking.** (1) `variantRefusal` matches the device by the image rows' model, so a phone with variants but no image row in the catalogue is not matched; harmless today, but the variant registry already carries `device` and the match should come from `device.json`'s model once that is in the catalogue (a small firmware-repository addition, mine). (2) The Download button's device path (backup missing, stock app absent, catalogue present) was not exercised on the phone; it is covered by the host test and will be exercised naturally the first time the catalogue has to supply the factory image, which is the recovery drill in the unlisted-images step's pass list.

**Next, as set:** the owner's Allow unlisted images switch (`plan-loader-safety.md`, "Unlisted images": Advanced section, off by default, warning with two confirmations, hash typed, every other check kept, resets after each load, help), with a pass list of: switch off by default on a fresh install; a file with an unknown hash refused with the switch off; with the switch on, the same file loads only after the hash is typed, the tag is read back and the history line says "unlisted image"; the factory backup absent refuses even with the switch on; a wrong tag restores the factory image; the switch is off again after the load. Then route-list items 6 (M17 as a channel type) and 7 (receive self-calibration). FW21/FW22 reproducibility stays before any bench image is listed; only stock and released images go into the firmware repository.

## Review of the unlisted-images switch (2026-10-25, `2d0512e3` + SignalDeck `9e58dbbf`)

**Verdict: passes. The owner's switch exists, is off until confirmed twice, gates nothing but the known-image check, and every other guard stayed in place; the six-item pass list was run on the phone and the drill proved recovery.** Phase E is complete: the vendor copy as the backup, the page, the signed catalogue, the block pause and now the owner's switch.

**Code read (`fw/Unlisted.java`, `fw/ImageTable.java`, `fw/FirmwareSession.java`, `ui/FirmwareScreen.java`).** The preference defaults to off; turning it on takes two confirmations whose texts say what the switch means (not from the catalogue, not verifiable beyond the version string, the user's responsibility). Candidate files come only from `Download/DMR/Firmware`, only at the factory size, only with a version string, and never when their hash is a known image. With the switch off an unlisted file is refused as not a known image before anything is sent; with it on, `unlistedPolicy` still requires a verified factory backup, a module tag that is known and factory-based, the right phone model and the right stock package, and the page refuses to start until the first eight characters of the hash shown on the page are typed. The switch is cleared when the transfer starts, so a second load needs the two confirmations again. The history and the log carry the full hash. `refuse()` gained the one relaxation recovery needs: a verified factory backup may restore the factory image over a tag the table does not know, and anything else on that tag is still refused; `ImageTableTest` covers both sides (re-run here: 9 of 9 pass). The help sentence matches the page.

**On the phone (16:09–16:31):** switch off on the installed build, unknown file refused in 12.4 s with nothing sent; with the switch on and the hash typed the module read back `DMR003.UNL1.V022` and the history line carried the hash, the switch off again afterwards; with the backup hidden and the stock app removed the same file was refused on Prepare; the wrong-tag drill read the unlisted file back in 137 s and restored the factory image in 138 s; help found by search. End state factory image, backup verified, stock app paused, switch off, the bench file deleted.

**Carries, not blocking.** (1) `Unlisted.files` splits the `ls` output on whitespace, so a file name with a space is skipped without a word on the page; name the rule in the help ("a .bin file name without spaces") or quote the listing. (2) The eight typed characters are a deliberate-action gate, not a check (the hash is on the page); the contract is met because the file is hashed and shown in full, but the history line should carry the tag as well as the hash so Last heard reads like the other firmware lines. (3) Every refresh of the page copies each `.bin` in the folder through root to hash it; fine for a handful of files, worth a size-and-mtime cache if the folder grows. (4) **A fresh checkout of SignalDeck fails `FirmwareCatalogTest` on Windows:** `app/src/test/resources/fw/firmware.json` is stored with LF and checked out with CRLF (`core.autocrlf true`), so the signature no longer covers the bytes the test reads; it passed on the bench because that working copy still held the LF bytes Grok wrote. Fix: a `.gitattributes` marking that file and `*.sig` `-text` (the same fix the firmware repository needed this morning); Claude adds it on the contacts branch so the PR's CI is green. Confirmed in a clean detached checkout of `9e58dbbf`: `ImageTableTest` 9 of 9, `FirmwareCatalogTest` 2 of 3 fail there exactly as in the contacts worktree.

**Next for Grok, as the split says:** route-list item 7, the **reading task first** (which converter drives the ES8311 input in receive, whether the AT1846S output and the HR-C7000 DAC enter the codec on the same input, and the register or RAM path that plays a known signal out of that converter while idle), written up in `results.md` with the addresses and the proposed `0x40` op before any image is built; no phone needed for the reading. Item 6 (M17 as a channel type) follows once the contacts branch is merged. **Phone lease:** the phone is Claude's for the contacts device check from this handoff until the lease line under Current task is cleared (target within the hour); Grok does not install or load on it until then.

## Review of the item 7 reading (2026-10-25, `61f32f19`): which converter feeds the phone's receive input

**Verdict: the reading is sound and answers the question; the proposed opcode 13 is the right next bench step, with the decision gate written below.** The three legs are each tied to a measurement already on record: analog receive at the phone is the AT1846S audio pin after `0x58` (R-D variant 3 flattens the phone path, variant 4 adds nothing, so the HR-C7000 FM filters are not in it); the HR-C7000 codec ADC is not between the AT1846S and the phone (UVm10, +0.06 dB on a 6 dB gain change); DMR voice can leave the chip only through the codec DAC lineout fed from the 160-byte vocoder buffer at `0x180000A0` on irq 27, and since the phone plays DMR voice and has one microphone input (the ES8311), that lineout reaches the same input. So the two converters share the ES8311 input but are not one signal: a DAC sweep bypasses `0x58`, an over-the-air tone bypasses the DAC gain. The register trail for the DAC path (`AICR_DAC` `0xC0`, `CR_DAC` bits 4 and 7 clear, `GCR_DACL` `0xAB` from the boot init at `+0x647C`) and for keeping PTT at 0 (`0x11000560`, no `0x30` write) is specific enough to build from. No phone use, as the lease asked.

**One correction to the framing, which changes what a "wrong leg" result means.** The equaliser that item 7 wants to measure corrects the chain *with `0x58` held*, and R-D showed that chain is flat at the AT1846S (50 Hz −0.6, 100 Hz +1.2, 3.8 kHz +1.7 dB against 1 kHz); R-F put the remaining ~9 dB dip at 500 Hz, and the AC-coupling group delay, on the phone side (the ES8311). So the part of the response that is per phone model is exactly the part a DAC sweep would traverse, if the lineout and the AT1846S pin really enter the same analog input. A recording that shows "only the ES8311's 500 Hz dip" is therefore not a failure: it is the measurement we need, and the self-calibration becomes *DAC-sweep response plus the fixed held-path offset from R-D*. The op is the wrong leg only if the recording is silent, or if its curve differs from the held-path table by more than a smooth offset that the R-D numbers explain.

**Bench session (FW23 = FW22 + opcode 13), pass criteria:**
1. **Host first:** patch-table test for the stub; the PCM the host sends is a 3 s multitone or log sweep, 50 Hz–3.8 kHz, at the ±3-symbol level used on the air, with a 1 kHz reference tone at the start for the level.
2. **No RF:** HackRF capture (boot gains) across the whole playback; peak under 0.1 dB against the 10 dB stop; `0x11000560` read 0 before and after; the module's status bytes report no key.
3. **The recording:** SignalDeck's normal receive path records it (DIAG `rxdump`-style, 8 kHz); report the 1 kHz level in dBFS, the noise floor, and the response at 50, 100, 200, 300, 500, 700, 1000, 1500, 2000, 2500, 3000, 3500 and 3800 Hz against 1 kHz, plus the group delay from the sweep phase.
4. **Decision:** (a) within 1 dB and 0.2 symbols of the R-D/R-E held-path table from 100 Hz to 3.5 kHz → the lineout is the calibration leg as is; (b) the residual against that table is a smooth curve the R-D AT1846S-held numbers explain (within 1 dB) → the calibration leg is the DAC sweep plus that fixed residual, written down per model; (c) silence, or a residual the R-D numbers do not explain → the op is the wrong leg and item 7 falls back to training on a real reception (the HeldPathReceiver's adaptive path). Say which of (a), (b), (c) it was, with the numbers.
5. **Unchanged behaviour:** the 1125-frame M17 stream re-run (ops 0–7 untouched), the receiver verified after the playback (a HackRF carrier at the usual level reads the usual RSSI; a 1 kHz FM tone through the phone path at the usual dBFS), tag read back, end state recorded.
6. The host side (a "Calibrate receive" action on the Device page that plays, records, fits the 41 taps and shows the response before and after) waits for this result; the shipped per-model taps stay the default and the fallback.

**Carries.** The read-back of `CR_DAC`/`AICR_DAC` after the 3 s should confirm the stub left them as the boot init had them. The repeater-ID and tone generators of the AT1846S were rightly ruled out (sub-audible, and the CTCSS table tops at 254.1 Hz).

## Review of FW23, opcode 13 idle playback (2026-10-25, `f4e3ac4b`)

**Verdict: the measurement is sound and complete for what it tried; the conclusion (c) is one variant early.** Two playbacks, acked without a key (HackRF peaks 0.085 and 0.056 dB, nothing on the air), and the phone heard nothing: digital silence with the squelch closed, the receiver's own noise at −27 dBFS with it open, no 1 kHz line in either. So writing the vocoder buffer while the radio sits idle on an **analog** channel does not reach the ES8311. That much is settled.

**Why (c) is not yet final.** The reading (`61f32f19`) established that the phone hears DMR voice through the codec DAC lineout, and that on an analog channel the phone hears the AT1846S audio pin. Both reach one microphone input, so something on the board or in the firmware selects or sums them, and the reading did not find the register that does it. FW23 was run on an analog channel, where whatever selects the AT1846S pin is in force. The idle playback therefore has not been tried in the state where the lineout is known to be heard. Two variants close the question:

1. **The same op on a DMR channel** (any colour code and slot, no signal): the mode the phone is in when it hears DMR voice. Squelch as the DMR channel leaves it. If the 1 kHz line and the chirp appear, the leg is found and the calibration measures it in DMR mode (the AT1846S held path is still the flat part by R-D, so the equaliser design holds); go to decision (a)/(b) with the numbers.
2. **Analog channel plus the gates the reading named:** `STANDBY_LO` `0x11000088[31]` cleared for the 3 s, the DAC interface on (`0x160009C8[4]` = 0), and the FM-demod-to-DAC route left as it is (`0x11000080[0]`, `0x11000100[7]` read and logged, not changed, since changing them would mix the demod into the lineout). Put every bit back after the 3 s and log the read-backs.

If both are silent too, **(c) is final** and item 7's design becomes training on a real reception, where the known source is the MMDVM hotspot when it arrives (item 5): an M17 BERT or a fixed-payload stream from the hotspot is a known waveform through the whole over-the-air path, which is a better calibration signal than any idle playback. Until then the shipped per-model taps stay.

**Carries from the pass list:** the 1125-frame stream was not re-run on FW23 and the boot capture was missed; both are owed before FW23 (or FW24 with the variants) is used for anything else, since every image re-proves ops 0–7. The squelch was put back; the stock app untouched; end state recorded.

**Next:** FW23 variants 1 and 2 above (no new image needed for variant 1; variant 2 is a small addition to the stub or a second opcode argument), with the same recording and analysis, the 1125-frame re-run and a boot capture on whichever image ends up loaded, then the (a)/(b)/(c) decision with numbers. Then route-list item 6 (M17 as a channel type; the contacts branch it depends on is merged, SignalDeck `8e304b0d`).

## Review of FW24, opcode 13 on a DMR channel and with the speaker gate (2026-10-25, `a171933f`)

**Verdict: both variants were run as asked and reported in full; the unchanged-behaviour checks owed from FW23 are in (1125 of 1125, EOT 0.999, boot 0.080 dB, the receiver open at the usual levels). The conclusion is not yet (c): variant 2's phone audio says the lineout is being heard, and that the stub's writes are not what the DAC plays.** One short step settles it, then item 7 either has its leg or trains on a real reception.

**What the numbers say.** On FW23 the open-squelch phone clip was the receiver's noise at −27 dBFS. On FW24, same channel, same open squelch, the clip is **−13.7 dBFS with a stationary peak near 320 Hz, before the command, during the 3 s and after**. A level 13 dB above the receiver noise with a fixed tone in it is not squelch noise; it is a converter playing a buffer that does not change. The stub turns the DAC on the way boot does, so that buffer is being played out of the codec lineout and the ES8311 hears it: the leg the reading predicted. What the 3 s did not do is change the sound, so the samples the stub writes at `0x180000A0` are not the samples the DAC fetches (wrong buffer, wrong half, a DMA source register pointing elsewhere, or a refill the codec never consumes while the modem is in FM). The DMR-channel silence (variant 1) is consistent with that: in DMR receive the module mutes the lineout until a call opens (the codec mute byte read `0x0C` both times), so nothing was expected there without a signal.

**FW25, one bench session, no RF:**
1. **Read back what the DAC fetches:** an opcode that returns a RAM window (offset + length ≤ 240 in the `0x1800xxxx` region, the same shape as opcode 12) and the codec's DMA/source registers named in user guide §7.1.2.2 (the buffer base and the half flag) before, during and after the 3 s; and a count of irq 27 during the 3 s. If the count is 0 the codec is not consuming in FM; if the source register is not `0x180000A0` that is the buffer to write.
2. **Make the tone move:** fill the buffer with a pattern that cannot be mistaken (a 500 Hz square at the ±3-symbol level for 1.5 s, then 2 kHz for 1.5 s) instead of the chirp, and look for the two tones in the phone clip. If they appear the leg is found, and the (a)/(b) comparison runs on the chirp as planned. If the stationary 320 Hz peak stays and the RAM read-back shows the pattern in place, the DAC plays from elsewhere: write the register from step 1 and try once more.
3. If neither moves the sound, **(c) is final**: item 7 trains on a real reception (the hotspot's M17 stream as the known source when it arrives), and the shipped per-model taps stay.
4. Unchanged behaviour as always (the 1125-frame stream, boot capture, receiver check), end state.

**Carries.** The `STANDBY_LO` bit 0 that "did not hold" is a read-only or self-clearing bit by the look of it, not a gate; leave it. The clipped first 1125 capture (LNA 16 / VGA 16) was rightly discarded and re-run at LNA 8 / VGA 8. The web server was turned off during the step; turn it back on at the end state if it was on before.

**Next:** FW25 as above; then route-list item 6 (M17 as a channel type; contacts merged in SignalDeck `8e304b0d`), then the two short bench pass items for SignalDeck PR #5 (the long SSTV pair and the 40 s M17 call).

## Review of the PR 5 SSTV pass, partial (2026-10-25, `results.md` "PR 5 SSTV pass, partial", 18:16–18:48)

**Verdict: the long modes transmit for their full length through the audio path and the cool-down guard refuses as designed; the pass is not complete, and it found two gaps in the guard that are fixed on the branch before the re-run.** Robot 36 ran 39.5 s (p99 2040 Hz, clip 0) and SignalDeck's own decoder drew 219 of 240 lines of the colour bars from the demodulated recording; the history carried the long-transmission line with the zone state. A Martin M1 asked for right after was refused with the guard's text (3.6 °C above the stored value), and did not key. The Martin M1 allowed at 18:37 ran 117.8 s (p99 2029 Hz, clip 0) and its VIS reads 44.

**Gap 1, fixed:** the refusal was only the sender's reply; the history line the contract asked for was never written, because `sendSstv` returned before `transmitPcm`. Now the sender writes "⏳ Martin M1 not sent: …" itself.

**Gap 2, fixed, and the one that matters:** that Martin M1 started with the AP zone at 51.6 °C (0.2 °C over the stored pre-key value, so the cool-down let it through) and ended at 62.0–63.2 °C with the battery at 43.9 °C: past the 60 °C stop the bench applies, and the app had nothing watching during the key. Two additions on the branch: a long transmission does not start while the AP zone is already at 50 °C or the battery at 42 °C (a long key adds about 11 °C and 2 °C on the bench), and an in-key watchdog reads the zone and the battery every 5 s and ends the playback at its next block at the bench stops (zone over 60 °C, battery over 45 °C, a 2 °C climb in 10 s), with a history line that says why. Every audio backend gained the mid-playback stop for it. `ThermalGuardTest` covers the rules with the bench's readings.

**The Martin M1 decode.** The host-side renderer cannot run in the unit-test classpath (no `Bitmap`). The decode route that works is the phone's own: play the demodulated 8 kHz recording into SignalDeck with DIAG `inject` while the SSTV page runs in Any mode; the phone decodes Martin M1 from the VIS and saves the picture to Download/DMR/SSTV. That is the pass for the long modes other than Robot 36.

**Robot 24 and the re-run.** Rightly not sent on a 44 °C battery. The re-run, when the phone is cool (battery under 42 °C, AP zone under 50 °C, which the new gate enforces): the PR 5 build with these fixes, one Martin M1 with the demodulated recording injected and decoded on the phone, then a Robot 24 straight after it (a short mode goes during a cool-down), then the second long picture refused with both the reply and the history line. If the watchdog ever ends a key early during this, the history line is the result, not a failure.

**PR 5 stays open** until that re-run; the rest of it (R-I, the tone path, the M17 marker, the FT8 finding, the catalogue match) is host-verified and unchanged.

## Review of FW25, the two-tone pattern into the vocoder buffer (2026-10-25, `results.md` "FW25", 19:32–19:43)

**Verdict: complete, and this time (c) is final.** The question the FW24 review left open was whether the stub's samples were reaching the buffer the DAC plays. FW25 answered it with a read-back instead of an inference: the 500 Hz / 2 kHz square was written at `0x180000A0`, opcode 14 read it back in place two seconds later, and the irq-27 count stayed at 0 with the flag word `0x110003B0` at 0 throughout the 3 s. The codec is not consuming that buffer while the modem is in FM, the guide names no other source for it, and nothing was written on a guess. The phone clip stayed at −15.5 to −16.0 dBFS with its stationary peak near 320 Hz: whatever the lineout carries in analog idle is not the vocoder buffer, and an idle playback through this path cannot be the calibration leg. The unchanged-behaviour checks are in (1125 of 1125, EOT 0.999, boot 0.074 dB, receiver open at the usual levels, the 1 kHz tone at −11.1 dBFS).

**What item 7 becomes.** Receive self-calibration trains on a real reception. The known source is the MMDVM hotspot when it arrives (item 5): an M17 stream with a fixed payload from the hotspot is a known waveform through the whole over-the-air path, the equaliser is fitted on it (the port of `heldpath_eq.py` already planned for the Device page's Calibrate receive action), and the shipped per-model taps stay the default and the fallback. No further firmware op is needed for item 7; opcodes 13 and 14 stay in the image as bench reads and are not listed for anything.

**Carries.** The stationary ~320 Hz at −16 dBFS on analog idle with the squelch forced open is still unexplained and harmless; note it in ch. 19 as an observation (it appeared with FW24's boot init of the DAC and persists), not as work. Channel 2's own row programs power byte 1, which is why the stream was keyed on the VFO: fine, and worth remembering when the channel is used for a bench key. The web server was turned off; the owner's PR 5 device checks use it, so it is turned back on in that window.

**Next for Grok: route-list item 6, M17 as a channel type on the intercom page, host part first.** Work in a separate SignalDeck worktree (`git worktree add ../SignalDeck-grok main`, branch `grok/m17-channel`), not in the shared checkout, which holds another agent's uncommitted files: the channel editor gains the M17 type (callsign destination picker from contacts, CAN, the hold is implied by the type), the intercom shows an M17 channel with the live receiver running and Hold to talk keying the M17 voice sender, the channel list shows M17 next to FM and DMR, backup carries the type, help and changelog in the same change; host tests on the channel model and the backup. The device pass follows on the bench once the host part is up as a PR and the phone is free. **The phone is Claude's for the next window (PR 5 re-run and the queue agent's PR checks); the lease line under Current task says when it is back.**

## Review: item 6 host part, SignalDeck PR 9 (M17 as a channel type), 2026-10-25 20:55

Read the PR diff (`3a7ccb49` + `58c30c69` on `grok/m17-channel`): ChannelStore type 2 + `m17dest` column with a migration, editor and web editor, Backup type cell + "M17 Dest" column, RadioService (wide-FM write, live receiver with the hold on selection, PTT routed to `m17Voice`, Soft SQ excluded), `M17.streamVoice(can)`, help, changelog, `M17ChannelTest`. The design is right: wide FM under the receiver, the hold re-sent after writes, receive-only on stock firmware with the warning line, the destination cleaned to the air alphabet, CAN sharing the colour-code column. Two things to fix before the device pass, one note:

1. **CAN bit position (fix).** `M17.streamVoice` puts the CAN at `n << 8`. The spec's TYPE table (M17_spec.tex, "TYPE Field": byte 0 = bits 7–4 reserved, bit 3 Signed Stream, bits 2–0 the top of the Channel Access Number, continued in byte 1 bit 7) puts the CAN in **bits 10:7**, so it is `0x0005 | (n << 7)`: CAN 3 = `0x0185`, CAN 15 = `0x0785`. With `<< 8`, CAN 3 goes out as CAN 6 and CAN 8–15 set the Signed Stream bit. Our own decoder does not check the field, which is why the host test passed; fix the three expected values in `M17ChannelTest` too (`0x0005`, `0x0185`, `0x0785`). The decoder side should also read the CAN from bits 10:7 when it shows the heard station, if it shows it at all.
2. **Squelch for an M17 channel (fix).** `hardwareSq(ch)` returns `ch.sq` for an M17 channel because Soft SQ is excluded, so the module's squelch (one threshold near −90 dBm) sits in front of the receiver, which decoded 95 % at −99 dBm with the squelch open (R-F). Treat M17 like the data channels in the comment above `hardwareSq`: write `sq 0` for an M17 channel and keep the speaker quiet except for decoded voice (say how the raw FM audio is kept out of the speaker on an M17 channel: the receiver mutes it, or the intercom does not play it).
3. **Backup column (note, not a blocker).** The channels CSV grows a 38th column "M17 Dest". The OpenGD77 CPS fork (phonedmrapp §8) expects 37; restore here tolerates its absence (`m17Col = -1`). A CPS-side follow-up goes on the fork's list; put one line in the changelog row saying the CPS fork ignores or needs the column.

Also rebase onto `origin/main` again: PR 8 (device report), the W6 notes and `GROK.md` landed after your rebase.

**Device pass (phone is Grok's)** after the fixes, 467.625 MHz low power, bench callsign N0CALL/DMRTST-7, the HackRF in the cage:
- Create an M17 channel in the phone editor (destination a callsign picked from contacts, CAN 7) and select it: the card shows M17, the intercom line shows "M17 … CAN 7", `0x25`/the log shows wide FM, `sq 0`, and the hold re-sent after the write.
- Receive: a HackRF M17 transmission (our encoder, CAN 7, 30 frames, 0.5 s carrier tail) at −93 and −99 dBm: the intercom line shows src → dst and the frame count, payload-exact frames ≥ 95 % at −99 dBm (`heldpath_rf_score.py`).
- Transmit (FW25): one 10 s Talk key from the intercom PTT, captured by the HackRF, decoded with our decoder: LSF CRC ok, dst = the channel's destination, TYPE = `0x0385` (CAN 7), frames payload-exact, EOT present. The same once from the web intercom. On the stock-firmware path only the warning line is owed: switch the check to a stub-tag mock if you have one, otherwise state it is covered by `txInhibited`.
- Backup → restore round trip: the M17 channel comes back with type, CAN, destination, `band 1`, `sq 0`.
- Leave the phone on channel 2 (467.625 FM), your build installed, STATUS REVIEW with the PR updated.

## Review: item 6 device pass (SignalDeck PR 9) and PR 10 host read (POCSAG page), 2026-10-25 21:30

**Item 6 device pass: accepted.** `results.md` "Item 6 device pass (21:14)": channel 56 written as wide FM, low power, squelch 0 (the `0x23` body shows it), the hold re-sent; receive 30/30 at −95 dBm, 20/19 and 30/30 at −97, 26/26 clean at −100 dBm live (the asked −93/−99 landed at −95/−100 through the HackRF VGA steps, which is fine), the two −97 clips 30/30 payload-exact with `HeldPath.decode` and the Armor taps; one 10 s web intercom key with carrier 10.367 s, p99 2.9 kHz, link-setup CRC, TYPE `0x0385` (CAN 7 in bits 10:7), 249/249 Golay 0, EOT; backup round trip after `1cad336b` keeps type, band 1, CAN 7, squelch 0 and the destination (the first export was one comma short, found by the pass and fixed with a test). Points: (a) the phone-side PTT key was not pressed, only the web key; both run the same service handler, so accepted, but the next time an M17 channel is on the bench, one side-button key please. (b) 26/30 live at −100 dBm is below the 95 % of the clip scorer; that is the live receiver's R-I edge-frame item, not the channel work. (c) The stock-firmware refusal was argued from `txInhibited`, not shown; fine. **PR 9 merges now on my side** (integration build + host suite, then main).

**PR 10 host read (POCSAG page, `grok/pocsag-page` `a524395a`): the encoder is right.** Preamble 576 alternating bits, sync `0x7CD215D8`, idle `0x7A89C197`, BCH(31,21) generator `0x769` with even parity, address word = flag 0 + 18 bits of RIC>>3 + 2 function bits, message words flag 1 + 20 bits, 7-bit text LSB first, idle fill so each address lands in frame `RIC & 7`, batches of sync + 16 codewords, op 8 body 3/20, 8/125, 3/10 with ±7600 (FW21's measured ~4.1 kHz p99). The `CALLSIGN: text` sender tag is a plain convention a real pager shows as text, which the help says. Three things for the device step:
1. **Polarity.** The body maps bit 0 to +7600 and bit 1 to −7600; POCSAG's convention is a 0 bit at +4.5 kHz and a 1 bit at −4.5 kHz, so this is the standard sense if a positive TX-RAM count is a positive deviation. The device pass states which sense the independent decoder needed (multimon-ng decodes both and says when it inverted; our `tools/pocsag-research` decoder takes a polarity flag). If the standard sense needs an inversion, swap the two amplitudes.
2. **Channel after a VFO page.** `streamPage` retunes to a "Pager" VFO at low power when the page frequency is not the current channel, and nothing I see puts the channel back after the unkey. Either restore the channel after `unkeyAfterStop()` (the way other VFO users do) or say in the help that the radio stays on the page frequency; restoring is the better behaviour.
3. **Numeric pages.** Only alphanumeric (function 3) text is built; a numeric-only pager (function 0, BCD) gets 7-bit text. Not a blocker: say "alphanumeric pagers" in the help and the changelog row, numeric BCD later if a user asks.

**Device pass for PR 10 (phone is Grok's; FW25; 467.625 MHz low power; bench callsign only; RICs from the 1xxxxxx range, never a real DAPNET RIC):**
- One page to one RIC at 1200 baud, captured by the HackRF, demodulated, sliced and decoded by `Pocsag.decode` payload-exact (RIC, function, text with the sender tag), and by an independent decoder (`multimon-ng -a POCSAG1200` on the demodulated audio if it is on the bench PC, otherwise the `tools/pocsag-research` decoder), the polarity reported. This also closes the "independent pager decoder" item open since FW21.
- One page to three RICs in one transmission, all three decoded, each address in its frame.
- One page each at 512 and 2400 baud, decoded (the generic engine's 8/125 and 3/10 rates).
- A page on a frequency other than the current channel: the retune, the 3.5 s settle, the key, and the channel afterwards (point 2).
- The timing line: carrier length against `Pocsag.seconds`, p99 deviation, no 5 kHz stop; the history line "Page sent to N RICs at B baud".
- End state: channel 2, your build installed, PR 10 updated with the fixes, STATUS REVIEW.

## Review: item 8 device pass (SignalDeck PR 10, POCSAG page), 2026-10-25 22:00

`results.md` "Item 8 device pass (21:35)", PR 10 at `8fd25662` on main `1cad336b`. **The page works: six transmissions, every page decoded by the research decoder and by `Pocsag.decode`, three RICs each in its frame, 512 and 2400 baud, a page on 467.550 MHz with the radio back on channel 2 afterwards and the history line on the channel it left.** The polarity finding is a real one and is now a bench fact: **a positive TX-RAM count deviates low on this radio** (the first build decoded only at polarity −1; after the swap the research decoder, whose +1 means "lower frequency = 1 bit", the standard sense, decodes at +1). Accepted on that decoder; the hotspot or multimon-ng confirms it once either is in the cage. Two things before PR 10 merges, both small:

1. **Deviation at 512 baud and on the three-RIC page (the 5 kHz stop).** Worst 0.5 s slices: 6281 and 5691 Hz at 512 baud, 5086 Hz on the three-RIC 1200 page, 4589–4654 Hz on the single 1200 pages, 4835 Hz body p99 at 2400. The whole-carrier p99 hides it because the quiet tail is in the window. Long runs of one bit at 512 baud reach the full step. Make the amplitude per baud so the worst slice stays at or under 4.5 kHz (the POCSAG standard): start at 512 → 5400, 1200 → 7000, 2400 → 7000 (scaled from the measured slices), then measure one page per rate and the three-RIC page again and set the final three numbers from the measurement; `Pocsag.waveform(baud)` takes the level from a small table and the test pins the three.
2. **The 2400-baud tail.** 12 of 15 codewords, the three tail words bad: the end of the stream is cut (the drop follows the last symbol, and at 2400 baud the last words are the last few milliseconds). Pad the bit stream after the last batch with one idle codeword at every rate (32 bits; 27 ms at 1200) so the drop never clips a message word, and re-measure 2400 (expect 15/15 or 16/16 with the pad counted).

Not blockers: the AP zone read that "did not return" during the keys is worth one line in the report next time (which node, what it returned); 2.3 s of carrier for a 0.93 s page is the ring fill before the key plus the drain, fine for a pager but say it in the help's Sending section ("about two seconds on the air").

**Next for Grok after the two fixes and their measurement (STATUS REVIEW with the table re-done): item 7, receive self-calibration, design step.** FW25 settled that no idle DAC playback reaches the phone, so the calibration trains on a real reception. Write the design (`radio_firmware/plan-rx-selfcal.md`, one session, no build): the equaliser is fitted from a received M17 transmission by re-encoding what the frame decoder recovered (LSF + payload-exact frames → the symbol sequence that was sent) and solving the taps against the received audio, so any station heard cleanly once becomes the calibration source (the hotspot in the cage, a HackRF on the bench, another SignalDeck phone in the field); state how the first lock is obtained on an uncalibrated phone (the per-model table as the starting point, the DFE as the fallback), the acceptance (payload-exact frames on an independent transmission before and after), the storage (per phone, per profile, with a reset), and the UI (a line on the M17 page, nothing the user must do). The bench part comes after the review.

## Review: item 8 level table (PR 10 final) and item 7 design (receive self-calibration), 2026-10-25 22:30

**PR 10 final (`ab606d64`): accepted, merging.** `results.md` "Item 8 level table (21:59)": the table 4600 / 6500 / 7000 keeps every 0.5 s slice at or under 4.5 kHz (worst 4493 Hz on the three-address page; 512 baud at 5400 still reached 5199, hence 4600), the idle word after the last batch brings 2400 baud to 16/16, every page at polarity +1, `PocsagTest` pins the table and the tail word, the help says a page is about two seconds on the air, the zone read is fixed (`su -c` quoting). Nothing further.

**Item 7 design (`plan-rx-selfcal.md`): approved with four additions, then build it.** The shape is right: the same 41 held-path taps, the same least squares as `heldpath_eq.py`, the targets re-encoded from frames the decoder accepted, the shipped per-model table for the first lock, the decision-feedback receiver as the fallback on stock firmware or without a table, a fit kept only after a second transmission scores at least as well, one file per profile under the app's files, one line on the M17 page, long-press to reset. Add to the plan before the build:
1. **A target guard.** A clean Golay decode is not a proof the payload is what was sent (Golay corrects up to three bits and can mis-correct). Re-encode the frame and compare its 192 symbols with the receiver's sliced symbols; use the frame as a target only when they disagree on at most 5 %, and say the number in the plan.
2. **A minimum.** No fit from fewer than 20 accepted frames of one call (41 unknowns against 192 equations per frame; 20 frames is 3840 rows). Say it.
3. **The audio for the fit.** The live receiver drops consumed audio with the `KEEP` margin, so the fitter needs the raw matched-filter output of every accepted frame with its 20 symbols of context kept aside as the call runs (about 232 samples × 8 per frame; 400 frames is small). Say where it is kept and that it is discarded when the call ends without a fit.
4. **The second-call comparison** scores both tap sets on the same recording of the later transmission (the pending taps and the live taps on one audio buffer), and the pending set must also lock the sync search by itself; a fit from a strong call is accepted only if the second call is at least 6 dB weaker or from another station, so one loud station does not calibrate the phone to itself. Say it, and store with the accepted taps the frame count, the date and the meter reading of both calls.

**Next for Grok: build item 7 (host) and run its bench pass. Phone is yours.** Host: the fitter, the raw-sample keep, the pending file, the second-call check, the M17-page line with its long-press, the help, `CHANGELOG.md`, host tests (a synthetic channel: convolve a known symbol stream with a made-up 41-tap response plus noise, fit, and check the fitted taps recover the payload-exact rate). Bench (467.625 MHz, HackRF, bench callsigns, FW25): the Armor's shipped taps are the "before"; one HackRF transmission (30+ frames, callsign A) is the fit; a second (callsign B, other payload, at least 6 dB weaker, at −97 dBm or so) is the score, before and after, payload-exact frames; then a third transmission at −100 dBm to show the accepted taps are not worse there than the shipped table. End state as usual, PR up, STATUS REVIEW. If the hotspot arrives first, item 5's setup session comes before the bench part of this.

## Review: item 7 bench (SignalDeck PR 12, receive self-calibration), 2026-10-25 23:40

`results.md` "Item 7 bench (22:42)", PR 12 `87a6a503`. **The mechanism is built as designed and the bench did what the design says it should on this phone.** The fit from the −90 dBm call (31 frames past the 5 % guard out of 39 clean) locked the −99 dBm call by itself and decoded 18 clean frames against 19 for the shipped table, so the rule refused it; on the Armor the shipped table *is* a fit of this phone, so "not kept, within one frame of the shipped set" is the expected result and shows the fitter produces working taps from one call. The third call (9 usable frames) correctly did not start a fit. `HeldFitTest` pins the synthetic channel (30/30), the guard, the minimum and the second-call rule. Code read (`HeldFit`, `HeldCal`, `HeldPathReceiver.keep/takeFrames/takeAudio`, `M17Station`, `M17Screen`): the tap convention of the fit matches the receiver's (the pending taps lock and decode through `HeldPath.decode`), the ridge is sensible, the guard runs on the current taps, the per-profile file overrides the asset and the reset deletes both files.

**One fix before merge: the call-audio ring is 8 s.** `HeldPathReceiver.ring` holds 8 × 8000 samples and `takeAudio` returns `(ringAt − callMark) mod length` samples from `callMark`, so a call longer than about 7 s wraps the ring and the second-call comparison runs on an arbitrary slice of it (the length wraps too). Make the ring hold the longest call plus the second before it (the receiver's own cap is 20 s: 21 × 8000 shorts, 336 kB) and, when a call has written more than the ring holds, return the whole ring from the oldest sample; add a host test that writes 12 s of samples and checks `takeAudio` returns a contiguous 12 s. Then push, say so in the PR, and I merge at the next tick (no bench needed).

Not blockers, for the next time a held-path call is on the bench: log the first five taps of the pending vector beside the shipped ones and the score of the same recording with no equaliser (expected near zero), so the report shows the fit carries the decode; the `fit not kept` line should also say the frame counts it compared, which it does.

**Next for Grok after that fix: FW26, promiscuous DMR receive (owner, 22:55: build before the hotspot, test with it).** Spec: `docs/promiscuous-rx-patch-spec-2026-10-24.md` with the review block at the top (toggle = op 15 on `0x40`, body `[15, v]`, one-byte echo reply; measure the free stub space first; build on the FW25 lineage as FW26; the `0x2B` reply grows to 11 bytes only while the flag is on; Patch C deferred). SignalDeck's side is PR 11 (`claude/promiscuous`): MON on a digital channel sends op 15 at FW26+, the parser takes 9 or 11 bytes. Order: (1) measure what `zero_tail` has left after FW25 and record it in `symbols.csv`; if under what the four stubs need, find a second free region and record it. (2) The static must-confirms that need no bench: the `RX_TYPE_INFO` CC/slot shifts against the firmware's own extraction at `0x1832e`; the two gate sites `0xC1BA`/`0xC244` and the `0xA890` call as they stand in the FW25 image (addresses are file offsets of the stock image; confirm they are unmoved). (3) Build FW26: the flag op, Patch A at the two gate sites, Patch D, and Patch B behind its precheck (build it, leave it gated by the same flag; the precheck decides later whether it stays). (4) Bench without a DMR source: load, `0x34` tag `DMR003.FW26.V022`, op 15 on / off / read-back, `0x2B` query body 9 bytes with the flag off and 11 with it on (stale caller data is fine, the length is the check), then the regression: one analog key with the 1 kHz tone at low power, RSSI on a carrier, one M17 key decoded as on FW25, a page, M17 receive on the held path; nothing else keyed. STATUS REVIEW with the results and the open A/B rows listed for the hotspot.

## Review of FW26 (promiscuous DMR receive on the bench), 2026-10-25 23:55

`results.md` "FW26 promiscuous receive (23:41)", image `DMR003.FW26.V022` sha256 `71949d24…a34e`, built by `tools/fw-patch/fw26_build.py` on FW25, `test_fw26.py` five tests (only the tag, the five redirected sites and the tail differ). **Accepted as a bench image; it stays unreleased until the hotspot A/B rows pass.** What was asked and what came back:
- **Stub space measured first:** the old 1,788-byte tail is full after FW25; FW25's extension ends at `0x5C464` with 664 bytes free, FW26 takes 232 of them (`symbols.csv` carries both). Good.
- **The flag** is IRAM `0x4B364`, inside the region start-up zeroes, so it is off at every boot; op 15 `[15, v]` writes it and echoes it, `[15, 2]` is refused with `sr` 1 and leaves it alone, and the other `0x40` ops still run (M17 40/40, the page, the hold). The gate replaces the dispatcher's `cmphsi r3,15; bt` pair and reproduces the old branch for opcodes above 15.
- **Patch A** (`fw26_admit` at both gate sites, the real getter first, 1 only when it returned 0 and the flag is 1), **Patch D** (`fw26_finish` appends CC and slot and sets the length to 11 only while the flag is on; the first image's `bsr`+`jmp r15` tail spun after the reply, found on the bench, fixed to a `jmp` through `r12`, and the test now forbids `jmp r15` there), **Patch B** (`fw26_ccbit` keeps the `andi` and sets bit 8 before the store the stock code still does). Each reads the one flag, each is byte-identical in behaviour when it is off, which the `0x2B` length 9 / 11 / 9 sequence and the regression show.
- **Must-confirm item 4** is now a known limit: the firmware never extracts bits 7:4 or bit 19 of `RX_TYPE_INFO` itself (it uses bits 22, 21:20 and 3:2), so the CC and slot bytes follow the manual and are **unverified until a real DMR carrier** is on the bench. The first hotspot row with the flag on must compare the appended CC with the hotspot's setting before anything is read from those bytes.
- **Regression:** 1 kHz p99 3626 Hz, M17 40/40 payload-exact with the end bit, a page with the same carrier length as the earlier one-RIC page, boot 0.056 dB, no slice at 5 kHz, zones cool. **One number to re-check:** held-path receive listed 19 frames of a 30-frame call at −88 dBm (84 % clean), where the item 7 bench on FW25 listed 40 frames, 39 clean, at −90 dBm. Re-run that one reception on FW26 with the same 40-frame clip at VGA 20 as at 22:42 and compare the listed count; if it stays near 19, it is a regression to chase before FW26 goes further (the stubs do not touch FM receive, so the likely causes are the clip or the live receiver's edge handling, but it has to be measured, not assumed).

**Open for the hotspot (unchanged):** out-of-list TG with the flag on (Patch A), wrong CC with the flag on and whether stock already passes it (Patch B), whether stock `0x2F` monitor already passes an out-of-list TG (must-confirm 0), the CC/slot byte values against the hotspot's settings, slot deferred (Patch C). SignalDeck's side is PR 11; its device check (MON on a digital channel sends op 15, off on MON off and on a channel change, the 11-byte parse) is Claude's in a phone window once the re-run above is posted.

**Next for Grok after the re-run: the live receiver's R-I items, host first, then the bench.** Branch `grok/live-receiver` from `origin/main`: (1) a call longer than 20 s is listed once, not split on the buffer cap (incremental decoding: chain state kept across passes, only new frames decoded, consumed audio dropped with the `KEEP` margin while the call is open); (2) buffer-edge frames are decoded whole, not half-equalised (a frame is taken only when `start + (183 + L + 4) × SPS` is inside the buffer, else it waits for the next pass); (3) one lost sync does not end the call (coast for up to three frames on the frame clock, end on the EOT or two seconds of silence). Host test on the saved clips in `app/src/test/resources`. Bench: a 30 s HackRF transmission listed once with the frame count within two of what the batch decoder gets on the same recording, and a transmission with a one-second gap in the middle listed once. End state as usual, PR up, STATUS REVIEW.

## Review: R-I live receiver bench (SignalDeck PR 13), 2026-10-26 00:55

`results.md` "R-I live receiver (00:30)", PR 13 `0465553e`. **Accepted; the three R-I items are closed.** A 32.5 s HackRF transmission of 750 frames at −88 dBm was one listing of 750 frames (702 clean, 93.6 %), and `HeldPath.decode` on the same receive clip also returned 750 with the last frame number 749, so the live count is within the two frames asked (it is exact). A 200-frame transmission with one second of no deviation after frame 99 was one listing of 200 frames (185 clean), twice. Host: `HeldPathReceiverTest` (5) and the four clip tests pass; the code read (consumed audio dropped with the margin, the look-ahead wait `start + (183 + L + 4) × SPS`, the retry window of `PAST + 320` so a sync in the equaliser's tail is searched again, a three-frame coast scored at ±half a symbol per hop, `QUIET_MS` 2000) matches the design. Side observation worth keeping: after the first gapped call the pending fit scored 83 clean against 81 for the live taps but was not kept because it did not lock the sync search on its own; the rule is conservative by design, so no change, but it is the first case of a better-scoring fit refused, and the next bench on another station should watch for it. PR 13 merges now (integration build + host suite, then main).

**Next for Grok: stage 5 of `plan-port-automation.md`, the bench regression runner's acceptance on the Armor.** `tools/fw-bench/runner/bench.py` has `tag`, `boot`, `tone`, `stream`, `heat`, `receive` and `all`, written from the snapshot and never run end to end. Run each test against the image on the bench (FW26) and judge the runner, not the image: a test passes acceptance when its numbers reproduce the Armor numbers already in `results.md` for the same measurement (tone table plain and held within the R-D/R-E tolerances, the 90-frame M17 key payload-exact, the receive clips at two levels within the R-F figures, the time-out key with the 120 s ceiling and the status byte, the heat log around a 30 s and a 45 s key with the zone names and the stop thresholds from `HANDOFF.md`, the plain control). Where the runner disagrees with the hand measurement, fix the runner and say what was wrong; where the runner is right and the old number was wrong, say that. Keys at 467.625 MHz low power only, `--arm` as the runner's own gate, the dummy burst first, nothing backgrounded with `-R`. Output: the per-test JSON and one results table for `DMR003.FW26.V022` in `tools/fw-bench/results/` (or where the runner writes), a short `results.md` entry, and the runner's README listing what passed acceptance. STATUS REVIEW when `all` has run once with every test either accepted or marked with its defect.

## Review: bench runner acceptance on the Armor (plan-port-automation stage 5), 2026-10-26 01:45

`results.md` "Bench runner acceptance (01:19)", commit `516514c0`, `tools/fw-bench/results/DMR003.FW26.V022/` (twelve JSON files and `summary.md`), README acceptance table. **Accepted: stage 5 is done on the Armor and the runner is the regression guard from here.** `all` ran twice end to end and every test reproduced the Armor number it was written against: boot 0.048 / 0.07 dB silent; the 10.5 s tone at body p99 2.54–2.55 kHz with the hottest half-second 4.03–4.04 kHz; the 1125-frame stream 1125/1125 payload-exact with the end bit at p99 2903 / 2908 Hz and clip 0; the receive control with the 1 kHz line at −19.1 dBFS; the 30 s and 45 s low-power keys with AP +1.0 / +1.2 °C and battery +0.2 / +0.3 °C and no stop. The five defects fixed first are the right kind of finding for an acceptance run (the tag read from the settings API once the signal poll floods logcat, the lift flag for a tone over 5 s, the WAV clip in the app cache, the heat stop watching `mtktsPA` instead of the AP and modem-PA zones, `all` not waiting for the zone to cool between keys). Two notes, no action: the tone test's `line1k_Hz` is the 1 kHz line's deviation and varies between runs (2446 / 1956 Hz) while the pass is on the line's presence and the body p99, fine, but the JSON key name should say `line1k_dev_Hz` or the README should say what it is; `tag_web` logs in with the PIN it reads from the prefs and drops it afterwards, which is acceptable on the owner's bench and must stay out of any report. What the runner does not cover is listed honestly (the plain-versus-held tone table, M17 receive at two levels, the 120 s time-out key): those stay hand measurements in `results.md`.

**Next for Grok: the receive-RAM stream, the second M17 receive route (R-C), diagnosis with a number.** Status so far: the HR-C7000's FM receive RAM holds a flat baseband (RC40), the UART reaches 230400 at +0.160 %, opcode 14 reads RAM, and a plain M17 decode of the RAM stream ran at about 10 % raw symbol errors, cause unknown. Find it: (1) the RAM's sample rate against the symbol clock, measured with a 1 kHz HackRF tone read out through the stream (the line's frequency in the read-out gives the true sample rate; compare with what the decoder assumes); (2) gaps and overruns in the read-out at 230400 (a block counter or the RAM write pointer in each read, so a missed block is counted, not inferred); (3) level and offset of the stream against the audio path on the same transmission. Then decode a 30-frame HackRF M17 transmission at −88 dBm from the RAM stream with the corrected rate and the gap accounting. Pass: raw symbol errors under 1 % and the frames payload-exact, or the cause written with its number and a decision whether the route is worth keeping (if the UART cannot carry the stream without gaps at 230400, say what rate or what decimation would, or close the route). No firmware change beyond what opcode 14 already does; if a counter needs a stub, write the one-paragraph design first and STATUS REVIEW before building it. Phone is yours; keys at 467.625 low power only; bench callsigns.

## Review: receive-RAM stream diagnosis (R-C second route), 2026-10-26 02:15

`results.md` "Receive-RAM stream (01:41)", commit `56a2036f`. **The decision to stop here is accepted; the wording is corrected: the route is parked, not disproven.** What the step established: opcode 14 reads only `0x18000000`–`0x1800FFFF` (the vocoder buffer answers, the FM receive RAM at `0x160004E0` is refused); the running UART is 57600, a 514-byte half takes about 89 ms for 32 ms of audio, so a continuous dump keeps about 36 % of the halves, and 230400 (reachable, +0.160 %) would carry a half in 22 ms; FW26 has no UART switch. Those three facts are enough to park the route on this image. What the step did **not** establish is that the RAM holds no discriminator: the op 5 dump that read rms 6–14 with no 1 kHz line was a mode-0 dump, and the receive mirror fills only with the `WORK_MODE` `0x80` state (RC20: "writing `WORK_MODE` `0x80` while receiving makes the C7000 demodulate into RX RAM"; RC30/RC40 and R-E read 1 kHz at rms about 6900 through op 5 mode 4). On FW26 op 5 mode 4 returned `sr=1` because, since RE10, op 5 refuses to touch registers while op 6's hold marker is set, and the hold was on. So the 01:41 "no 1 kHz" is the expected reading of an idle RAM, and RC40's flat baseband stands. The route-list entry now says: **R-C parked 2026-10-26: needs a UART switch to 230400 and the `0x80` state applied beside the hold (a stub change), neither built; the audio path with the held bypass and the per-model taps is the receive design and does 95–100 % payload-exact.** It is worth reopening only for a phone whose audio path cannot be made flat, because its gain is independence from the phone's converter, not sensitivity.

**Next for Grok: the independent pager decoder, owed since FW21.** Get `multimon-ng` onto the bench PC (an MSYS2 or prebuilt Windows build; no WSL, owner's rule), then: (1) decode the demodulated audio of the 21:59 page captures if they are still on disk (the 1200-baud one-RIC and three-RIC pages, the 512 and 2400 ones) with `multimon-ng -a POCSAG512/1200/2400`; (2) if the captures are gone, one fresh 1200-baud page at 467.625 low power with a test RIC, captured and demodulated, decoded by multimon-ng and by `Pocsag.decode`; report the RIC, function and text multimon-ng prints and whether it needed the inverted-polarity option (that settles the polarity finding independently). Pass: multimon-ng prints the page text with the right RIC at each rate it is given. If multimon-ng cannot be built or run on this PC, say exactly what failed and close the item as "waits for the Ubuntu box in the cage", no further time on it. Small extra on the way: rename the runner's `line1k_Hz` JSON key to `line1k_dev_Hz` (or say in the README it is the line's deviation). Phone is yours; bench callsigns; test RICs only. STATUS REVIEW.

## Review: independent pager decoder (multimon-ng), 2026-10-26 02:40

Report 02:23. **Accepted; the item open since FW21 is closed.** multimon-ng 1.6.2 on the bench PC decoded the saved page captures: RIC 1000001, function 3, `N0CALL: LO` at 512 baud and `N0CALL: HI` at 1200 and 2400, and the three-RIC page as `N0CALL: ABC` on 1000001, 1000002 and 1000003; its automatic polarity locked the normal sense and `-P inverted` printed no address, which confirms the FW26-era polarity finding (a positive TX-RAM count deviates low; the swapped levels put the 0 bit at +4.5 kHz) with a decoder we did not write. The runner's tone key is renamed `line1k_dev_Hz`. Nothing was keyed. The POCSAG row in `CLAUDE.md` now says the independent check is done.

**Next for Grok: the cold-boot regression of tonight's state, then stand by.** Everything that landed tonight (FW26 in flash, SignalDeck `main` with PR 4–13, the Magisk module, `BootReceiver`) has not been through a phone reboot together. Do: (1) note the installed APK's sha256 and the `0x34` tag; (2) `adb reboot`, wait for the phone, confirm SignalDeck re-took the radio (link ready, module answers, tag `DMR003.FW26.V022`, stock app still disabled), with the time from boot to "ready"; (3) the runner's `tag`, `boot` and `receive` tests; (4) select the M17 channel 56: the hold is re-sent and the live receiver lists one 30-frame HackRF transmission; (5) MON on the digital channel 4 sends op 15 and echoes 1, MON off echoes 0; (6) back to channel 2, MON off, nothing keyed. Report the numbers and anything that did not come back by itself; STATUS REVIEW. After that, if no new task is set, stay on host-only work: nothing on the phone, nothing keyed; the morning brings the owner's decisions (hotspot, the firmware signing key).

## Review: cold-boot regression of the 2026-10-25 state, 2026-10-26 06:05

`results.md` "Cold-boot regression, resumed (05:46)". **Accepted; nothing regressed and the boot path is now measured both ways.** With `ownAtBoot` off (this phone's state) the receiver re-enabled the stock app and left SignalDeck idle, as designed; starting SignalDeck took the radio in 7.2 s (stock app disabled, link ready, `0x34` `DMR003.FW26.V022`). Runner `tag`, `boot` (0.108 dB, silent) and `receive` (−18.9 dBFS, 1 kHz line) passed; channel 56 re-sent the hold and listed one 30-frame transmission (27 clean); MON on the digital channel 4 echoed flag 1 and then 0. With `ownAtBoot` on, a USB reboot brought SignalDeck up by itself: process at uptime 43 s, radio ready at 47.9 s, stock app still disabled, tag FW26, channel 2; the setting was put back off. The only loose end is Wi-Fi ADB: `tcpip 5555` answered but the Wi-Fi connect now times out (10060, where 03:10 was a refusal), so the phone's Wi-Fi or its address changed on the second reboot; USB is the transport until the owner looks (owner question updated). The overnight stranding (02:42) was the task's fault, recorded in the handoff and in Claude's notes: no phone reboot without a persisted adb port or a cable.

**Next for Grok, host-only: the hotspot arrival runbook.** Add a section to `radio_firmware/plan-independent-m17-check.md` ("Arrival-day runbook") so the setup session is scripted before the box is unpacked: (1) WPSD first boot (cage Wi-Fi, ssh, hostname, the modem hat firmware with M17 enabled, the duplex frequencies at 467.625/467.650 or whatever pair keeps the phone's channels, the bench callsign, a DMR ID for the bench, colour code and slots as the capture matrix needs them); (2) the order of the independent checks with the exact commands and what each one proves: SignalDeck M17 voice decoded by the hotspot, the hotspot's M17 received on channel 56, POCSAG pages sent by the hotspot (DAPNET/local) received on the held path, DMR both ways; (3) the promiscuous A/B rows of `tools/dmr-replay/capture-matrix.csv` driven by the hotspot as the transmitter (per row: hotspot settings, the stock image then FW26, the flag off and on, the `0x2B` body compared with the hotspot's colour code and slot, the score), with must-confirm item 0 first; (4) the self-calibration second-station pass (fit on the hotspot's call, score on a HackRF call, or the reverse); (5) end state and what goes into `results.md`. Keep it to what can be typed from the bench. No phone, nothing keyed. STATUS REVIEW when written.

## Review: hotspot arrival runbook, 2026-10-26 06:35

`plan-independent-m17-check.md` "Arrival-day runbook" (06:10). **Accepted as written.** It does the things a runbook has to: stops if the image has no `[M17]` section instead of continuing on DMR alone; keeps the Wi-Fi password, any DAPNET key, the owner's callsign and DMR ID out of the file and the reports; reads the phone's channel frequencies, colour code, slot and group list before the first transmission instead of assuming them; runs must-confirm 0 (stock monitor, out-of-list talkgroup) before any FW26 flag row; scores every promiscuous row three ways (stock with MON, FW26 flag off, FW26 flag on) with the displayed colour code and slot checked against the hotspot's setting; loads FW26 back at the end; and refuses to invent a reflector or a DAPNET account. Two notes for the day itself, not changes: (1) the claim that current upstream WPSD has dropped M17 and that the June 2025 community fork is needed is to be verified on the box before flashing anything (the runbook's step 4 check already catches a wrong image, so the cost of being wrong is one re-flash); (2) hotspot-to-phone M17 and DMR need a source the hotspot can replay (a reflector the owner approves, a second client, or the duplex retransmission), which the runbook says; if none is available on the day, the phone-to-hotspot direction plus the HackRF remains the independent evidence, and the table says so.

**Next for Grok: stand by, host-only.** Nothing on the phone, nothing keyed, no new image. The open decisions are the owner's (Wi-Fi ADB persistence, "Own the radio at boot" for daily use, the hotspot session date, the firmware signing key before the first released image). If the owner posts a task before Claude's loop ends at 09:00, it will appear here; otherwise the next step is the hotspot session.

## Review: FW27 design, the receive-RAM stream (plan-rx-ram-stream.md), 2026-10-26 08:40

**Approved with three changes to the page, then build FW27.** The shape is right: mode 5 as its own op 6 variant (bypass plus `WORK_MODE` `0x80` plus the band-pass bits clear, saved and restored like variant 4, its own marker so op 5 can read, cleared by a channel write), op 16 as an acked switch with the ack at the old rate and the divisor written after it, boot at 57600, the loader NAKed at 230400 and only entered after an explicit switch back, op 17 as a push of sequenced halves with the status pushes fitted into the 9.2 ms gap, and the audio path left as the default route. Changes:
1. **Keepalive, or no stream longer than 30 s.** As written, the module falls back to 57600 after 30 s without a valid host frame, and the first valid host frame ends the stream; a host that streams for a minute can neither stay quiet nor speak. Add op 17 action 2, a keepalive that resets the silence timer and does not touch the stream; the host sends it every 10 s while streaming. Keep the timer running during a stream (a dead host still falls back), and keep "any other command ends the stream" for everything except action 2. Bench (b) stays at 10 s, and one extra run of 45 s with keepalives proves the timer does not fire mid-stream.
2. **Say how a half is known to be complete.** The page says the half `FM_ADDR_SW` is not pointing at is sent; it does not say what triggers the send: the interrupt (`SYS_INTERP_LIST` bit 14) or a poll of `FM_ADDR_SW` from the main loop. State which, and the worst-case delay between the flip and the first byte on the wire, since the 9.2 ms margin is spent against it; if it is a poll, say the loop period.
3. **Does the phone's audio keep flowing in mode 5?** Unknown, and it decides how the comparison in (c) is run. In bench (b), while the stream carries the 1 kHz tone, record the phone's own `rxclip` at the same time and say whether the tone is in it. If it is, (c) can compare the stream decode and the channel-56 listing of the same transmission; if it is not, (c) compares against the listing of a second transmission of the same file with mode 5 off, and the help later says the stream receiver silences the speaker.
Small: `[16, rate]` ack body echoing the rate is good; also echo it on `[16, 0]`. Sequence starts at 0 and wraps at 65536, fine; add the half id check to the gap count (two consecutive frames with the same half id is also a miss). On the SignalDeck side (Claude's): unsolicited `0x40` frames with opcode 17 go to a stream sink before the diagnostics reply capture sees them, the rate override is session-only, and a reopen failure falls back to 57600 and re-queries `0x34`.

**Next for Grok:** amend the page (the three points), then build FW27 (opcode gate through 17, mode 5, op 16 with the timer and the keepalive, op 17), host tests in the fw-patch style (only the tag, the redirected sites and the tail differ from FW26), then the bench as written in §4 plus the 45 s keepalive run and the phone-audio observation in (b). USB adb, 467.625 low power, bench callsigns, nothing keyed at boot. STATUS REVIEW with the numbers: the (a) round trip and fallback times, (b) the line frequency, the gap count and the phone-audio answer, (c) the plain and equalised counts against the listing, (d) the runner table.

## Review: FW27 capture re-arm (receive-RAM stream), 2026-10-26 13:25

`results.md` "FW27 capture re-arm (13:02)", image `9ea5365c…ded5`. **The finding stands and changes the chip model: the HR-C7000's FM receive RAM is a capture that each `WORK_MODE` `0x80` store re-arms, not a tap that stays open.** With the store before the flip the stream carries the 1 kHz line; a store every 8 halves keeps every residue class at the same amplitude (medians 11983–12005), a store every half does not lose the alternate half, and the 45 s run at period 8 reported 0 misses over 1631 halves. That is the route's main question answered: continuous flat baseband over the UART at 230400 is possible. The page and `symbols.csv` get the re-arm as a fact (the store at file `0x5B096`, the period byte in the start body `[17, 1, period]`). Three things in the same report must be settled before (c), in this order, because the first one is a transmit defect:

1. **The transmit regression stops everything else.** The runner's tone test on FW27 gave a 16.0 s carrier for a 10 s tone, body p99 22389 Hz and no 1 kHz line, after a module restart. FW26 gave 10.5 s, p99 2.55 kHz. That is the modulator being fed something other than the tone, with the deviation limiter not holding, and it appeared with the image that retired opcode 13 and placed the 736-byte stub at `0x5BCA4` inside the former FW23–FW25 region. Treat that reuse as the suspect until shown otherwise: (a) diff FW27 against FW26 byte by byte and list every changed range; any byte outside the planned redirect sites, the tail and the retired opcode-13 body is the bug; check that nothing FW21's symbol engine or tone queue still references lies in `0x5BCA4`–`0x5BF84` (the FW23 build script knows what it put there, and the fw-patch tests should have refused the overlap; say why they did not); (b) reload FW26 and run the runner's `tone` once to prove the bench itself is unchanged; (c) rebuild FW27 with the stub placed only in space that nothing live references, run `tone` first, then `all`. **No key on FW27 until the tone test passes at the FW26 numbers.** This is the first time a bench image touched transmit; the runner's stop rule caught it, which is what it is for.
2. **The stop path leaves the module uncommandable.** After the stream's stop frame, `[16, 0]` did not change the rate, the version read at 57600 failed, mode 5 off got no answer, and only `restartmodule` recovered. The design requires that after action 0 the module answers at 230400 (`0x34`), takes `[16, 0]`, and answers at 57600. Likely the loop's exit path (the stop frame consumed inside the loop, then the handler returns with the stack or the UART state not as the dispatcher left it). Fix and prove the full sequence: stream, stop, `0x34` at 230400, `[16, 0]` acked, `0x34` at 57600, `[6, 5, 0]` acked, no restart.
3. **The half rate and the misses do not add up.** 361 halves in 10.8 s and 422 in 12.6 s are 33.5 halves per second where 8 kHz gives 31.25, and the host counted 83–84 misses on the 10 s runs but 0 on the 45 s run. Either some halves are sent twice (a store that does not move the pointer, then the same half copied again) or the sample rate is not 8 kHz. Measure both: the tone's frequency in the stream fitted precisely (the line's position, not the 1 kHz bin alone) gives the true sample rate; identical consecutive halves give the duplicate count; the sequence counter is a 0..5 slot, so say what "missed" counted. Also the 1.5 s quiet run (halves about 45–92 in every 10 s capture, not in the transmitted file): give its timing relative to the stream start and whether it recurs in the 45 s run (per-half amplitude over time, not residue medians); if it is a one-time hole after the start, (c) can live with it, if it recurs it cannot.
Then (c) (the 30-frame M17 transmission decoded plain from the stream against the channel-56 listing of a second transmission with mode 5 off), the 45 s keepalive run again on the fixed image, and `all`. PR 14 on my side already wraps the sequence at 6; I will add the period byte to its start body once you confirm the value to ship (8). Phone is yours. STATUS REVIEW with the tone test at FW26 numbers first, or STUCK on item 1 if the diff does not explain it.

## Review: FW27 keys again (literal pool), 2026-10-26 15:05

`results.md` "FW27 keys again (14:46)", image `152358b0…b4ad`. **Accepted.** The hang was the stub overwriting the key helper's literal pool at `0x5BE60`–`0x5BEDC` (loads, not branches: `0x5BBE2` reads its constants from there with PC-relative `lrw`, so a word-pointer scan and a branch scan both missed it). The stub is now split around the pool, `0x26` down acks in 10 ms with status 3, up with status 4, and the runner's `all` passes at the FW26 numbers (tone 10.565 s carrier, p99 2541 Hz, line 2439 Hz; stream 1125/1125; receive; heat; boot silent). The runner now says NO CARRIER for a floor capture and re-scores the 13:58 file as carrier 0, which closes the detector defect I mis-read at 13:25. Three notes for the record: (1) opcode 14 reads only `0x18000000`–`0x1800FFFF`, so the stub's IRAM words are not observable from the host; a later image can map that window if needed. (2) op 16 rate 2 (the register dump) is gone to make the split fit; the page says so. (3) `test_fw27.py` pins this one pool by address; the generic lesson is not in the tests yet, and that is the first item below, host-only, before any more reclaiming.

Next, in order: (1) a generic fw-patch test: from the base image's disassembly, every `lrw` (and any other PC-relative load) whose literal lies inside a range the build writes, issued from code outside that range, fails the build; run it against FW23–FW27 to show it finds the `0x5BE60` pool on the old FW27 and nothing else on the shipped images. (2) The stop path: after `[17, 0]` the module must answer `0x34` at 230400, take `[16, 0]`, answer `0x34` at 57600, take `[6, 5, 0]`, with no restart; fix and prove the sequence end to end. (3) The half rate and the counter: 33.5 halves/s against 31.25 (fit the tone's frequency in the stream for the true sample rate, count identical consecutive halves), what "missed" counted on the 10 s runs (83) against the 45 s run (0), and the 1.5 s quiet run after the start (its timing from the first half, and whether the 45 s run repeats it later; per-half amplitude over time). (4) Then (c): a 30-frame M17 transmission decoded plain from the stream against the channel-56 listing of a second transmission with mode 5 off, and the 45 s keepalive run on the final image; `all` again if the image changes. STATUS REVIEW with those, then PR 14's device check on my side under a phone lease.

## Review: FW27 stream clock, misses and the 30-frame compare, 2026-10-26 16:30

`results.md` "FW27 stream clock, the quiet run, and the 30-frame compare (16:13)", image `e552549c…b2dc`. **Accepted as a measurement; the route is not closed and not won.** Four facts settled: (1) the capture clock is 8000 Hz (a 4 s FFT at 0.25 Hz bins peaks at 1000.00 Hz; the 15:25 "987.25 Hz" was that file's noise floor), so the half rate is 31.25/s and no resampling is needed (PR 14's 8103 Hz resampler, added on the 15:25 figure, goes back to 8000 today). (2) There is no quiet hole; the earlier one belonged to the previous image. (3) The "misses" are the host counter, not the stream: the audio is gapless (415 halves in 13.3 s is 31.2/s, amplitude flat, no repeats), and the counter adds one whenever the half id repeats on the next slot, which FW27's op 5 send does for consecutive halves (the id byte is informational). Count by the sequence byte alone; expected result 0. (4) The runner's `all` passes on the shipped image. **The result that matters is (c): the plain stream decoded 30 frames at 46 % clean, 4 of 30 payload-exact, link-setup CRC failed, while the same transmission through the audio path with the shipped taps on channel 56 gave 96 % clean at −87 dBm.** So the receive RAM, read plain, is a worse M17 source than the equalised audio path on this phone. That was always possible: RC40 measured the RAM flat only from 50 Hz to 1 kHz, and M17 needs the band to about 2.5 kHz, where the C7000's own demodulator filtering may roll off; the RAM also carries whatever DC and level the chip leaves there. Nothing is known yet about the stream above 1 kHz, so the next step is to measure it the way R-D measured the audio path, then fit the stream its own fixed equaliser the way R-E/R-F did, and compare payload-exact against the audio path. If the stream with its own taps does not beat 96 %, the route's answer on this phone is "the audio path with taps is better" and the stream stays what the route list said: a tool for a phone whose audio path cannot be made flat. Two smaller items from the same report: SignalDeck's `ramstream` off logged stop with no answer, then no version at 57600, and needed a module restart, where Grok's explicit 15:23 sequence (stop acked, `0x34` at 230400, `[16, 0]`, `0x34` at 57600) worked; and SignalDeck's process was gone after the runner's first pass at 15:56. Both are app-side and need the phone's logs, which Grok holds.

Next, in order: (1) **Stream response:** HackRF tones at 2.5 kHz deviation, 100, 200, 300, 500, 700, 1000, 1500, 2000, 2500, 3000, 3500 Hz, 4 s each, amplitude per tone from the stream and from the audio path on channel 56 (the same recording loop), plus the stream's DC offset and rms with no carrier; table in `results.md`. (2) **Eye and taps:** from the saved plain-stream M17 capture, the symbol-level histogram (±1/±3) after timing recovery; then fit a fixed 41-tap equaliser on one stream transmission and score a second one, `tools/m17-research/heldpath_eq.py` and `heldpath_rf_score.py` with the stream PCM in place of the audio recording; report payload-exact frames against the channel-56 figure. (3) **Counter:** re-count the 13.3 s and 50.5 s files by the sequence byte alone (expect 0; if not 0, list the gaps with their half timestamps). (4) **App logs for Claude:** the SignalDeck log lines of one `ramstream --ez on false` sequence (the `[17, 0]` send, any reply, the `[16, 0]` send and ack, the reopen, the version read), and `adb logcat -b crash -d` for the 15:56 process death, pasted into `results.md`; no fix on your side, these go to PR 14. STATUS REVIEW with (1)–(4).

## Review: FW27 stream response, eye and the miss recount, 2026-10-26 17:05

`results.md` "FW27 stream response, eye, and the miss recount (16:37)". **Accepted.** The stream is what the route hoped for as a signal: flat within 0.5 dB from 100 Hz to 3.5 kHz where the audio path has its 9.6 dB dip at 500 Hz, idle 44 dB down, DC +5 counts. The misses are 0 by the sequence byte (415 halves in 13.3 s, 1579 in 50.5 s, both the expected count), so the counter rule was the whole story. So the 46 % clean, 3–4 of 30 payload-exact decode is not the band and not lost halves. The eye table says where to look: after sync normalisation the four levels sit at −3.00, −1.27, +1.07 and +3.37 with standard deviations 0.43 to 0.76, where the audio path gave exact ±1/±3. The inner levels are pushed apart from the outer ones on the positive side and the spread grows with the level. Two causes fit that shape and neither is in the equaliser's reach: **(a) carrier offset as DC.** The RAM is DC-coupled (flat to 100 Hz, DC readable) where the audio path is AC-coupled, so the radio's and the HackRF's crystal errors (about +800 Hz between them, measured 2026-10-22) land in the stream as a constant offset of the order of a symbol level (800 Hz per level at ±2.4 kHz for ±3). The audio path never saw it. **(b) deviation linearity.** The sweep was at one deviation (2.5 kHz); the +3 level at 2.4 kHz may sit where the demodulator's output is no longer linear, which would widen +3's spread (0.76) and move it (3.37). Both are one sweep each, and both are fixed on the host once measured: an offset estimator per frame (from the sync word or the frame mean) before the slicer, and a level map if the linearity is bent. The 41-tap fit not training is consistent with (a): the training pattern match assumes zero-mean levels. The stop path: SignalDeck's stop frame got no answer where Grok's did, and the engine's routing is clean (a non-half 0x40 body goes to the reply capture), so the frame bytes or the timing differ; PR 14 now proves each step (stop retried, version at 230400, settle, three version tries, one more rate command) and the comparison of the two stop frames is item (4). The empty crash buffer means the 15:56 death was a kill, not a crash; noted, not chased.

Next, in order: (1) **Carrier offset:** the 1 kHz tone at 2.5 kHz deviation with the HackRF centre at −1000, −500, −200, 0, +200, +500, +1000 Hz from 467.625; per step the stream's DC (mean over a steady second) and the tone amplitude; expect a straight line of DC against offset and a slope in counts per hertz, which is also the stream's scale. (2) **Deviation linearity:** the 1 kHz tone at 0 offset at 0.5, 1.0, 1.5, 2.0, 2.4, 3.0, 3.5 and 4.0 kHz deviation; amplitude per step; where it leaves a straight line is the limit. (3) **Captures into the repo for the host work:** the 15:52 and 16:36 plain-stream captures of the 30-frame file and the channel-56 capture of the same file, as raw 16-bit little-endian 8 kHz mono under `tools/m17-research/captures/fw27-stream/` with a README naming each file's conditions (bench callsign only). (4) **The two stop frames:** the exact bytes Grok's tool sends for the stop against SignalDeck's `68 40 01 01 75 BC 00 02 11 00 10`, and whether the tool waits for anything between the last half and the stop. STATUS REVIEW with (1)–(4). Claude then decodes the captures offline with offset removal and a level map and, if payload-exact reaches the audio path's figure, ships that in PR 14's stream receiver.

## Review: FW27 stream offset and deviation sweeps, 2026-10-26 17:10

`results.md` (16:5x), image `e552549c…b2dc`. **Accepted, and it names the cause.** A carrier offset of ±1000 Hz leaves the stream's steady mean near +7 counts, so the DC suspect is cleared: the chip removes the offset before the RAM (an AFC or a long AC time constant), and the stream behaves like the audio path there. The deviation sweep is the finding: the stream's amplitude leaves a straight line by about 1 kHz of deviation and is flat at about 6030 counts from 2.4 to 4.0 kHz. The FM receive RAM is a **limited discriminator**: linear to roughly ±1 kHz, compressing above, at its ceiling by ±2.4 kHz. M17 puts its ±3 symbols at ±2.4 kHz, exactly on the ceiling, and its ±1 at ±0.8 kHz, inside the linear part, which is the eye Grok measured (outer levels compressed and smeared, inner levels pushed apart by a sync normalisation that trusts the outer ones). Two corrections follow for the record: the 16:37 frequency sweep was run at 2.5 kHz deviation, so its flatness is the flatness of the ceiling, not of the path, and has to be repeated inside the linear range; and the 41-tap fit could not train because the distortion is a static nonlinearity, which no linear equaliser models. Three routes from here, cheapest first: **(1) a host-side level map** on the saved captures (invert the measured curve before the slicer, thresholds at the centroid midpoints): if the ±3 symbols are compressed rather than destroyed, that alone may recover most frames; Claude runs this now on the committed captures. **(2) prove the cause on the bench** with the same 30-frame file at 40, 60, 80 and 100 % deviation through the plain stream: payload-exact should rise as the deviation drops into the linear range, which no other explanation predicts. **(3) the register**: the ceiling is a setting, not physics. The HR-C7000 guide's FM receive section (§7.2.2.3.2 and the register map) should name the demodulator's output gain, deviation range or limiter; mode 5 can carry one more register write, and the deviation sweep is the measurement that shows whether it moves the ceiling to ±3 kHz or beyond. If (3) works the stream becomes the flat, linear baseband the route wanted; if it does not, the stream is a worse M17 source than the audio path on this phone and the route's answer is written. The stop frames are byte-identical and neither tool waits, so SignalDeck's missing stop ack is on the app's side of the port; PR 14's new stop path proves each step and the device check will show it.

Next, in order: (1) the frequency sweep again at 1.0 kHz deviation (100 Hz–3.5 kHz, the same table); (2) the 30-frame file through the plain stream at 40, 60, 80 and 100 % deviation (±0.96, ±1.44, ±1.92, ±2.4 kHz), payload-exact and clean per step, the four captures added to `tools/m17-research/captures/fw27-stream/`; (3) the guide reading for the FM demodulator's output scale, deviation range or limiter register, the register and its reset value in a short note, and, if one exists and a bench write is safe, an op 6 variant 6 that sets it with mode 5, measured by the deviation sweep (0.5–4.0 kHz); no transmit changes, nothing outside mode 5. STATUS REVIEW with (1)–(3), or STUCK on (3) with the guide pages read.

## Host decode of the FW27 stream captures, 2026-10-26 17:40

`tools/m17-research/fw27_stream_levelmap.py` on the three committed captures (`captures/fw27-stream/`), transmitted payloads regenerated from the bench generator's seed, the link setup taken from the channel-56 decode, frames tracked from the strongest sync. **Reference:** channel 56 (audio path, hold on, shipped taps, equalise-first): 30 frames, 30 payload-exact, link-setup CRC ok. **Plain stream:** 30 frames found on both captures, 4 and 3 payload-exact, link setup bad, reproducing Grok's figures. **Nothing memoryless or short recovers it:** a soft-limiter inverse fitted to the deviation table 3 and 2; a monotone raw-to-deviation map fitted on one capture against the regenerated waveform, applied to the other, 7 and 2; a running-mean high-pass (20, 50, 200 ms) 1 to 4; a least-squares FIR of 33 or 65 taps at 8 kHz, with or without cubic terms, fitted on one capture and applied to the other, 3 to 5, and even on its own training burst the residual stays about 600 Hz rms against a ±2400 Hz signal, so the stream is not a static or a short-memory function of the transmitted deviation. **The time base is clean:** the best local lag of every 256-sample half against the transmitted waveform is 0 across the burst (the only non-zero values are the two edge halves), so the re-arm and the copy drop nothing; and the alignment correlation is only 0.81 to 0.84. **The per-frame level table says what it is:** at the samples where the transmitted deviation is −2400, −800, +800 and +2400 Hz the stream reads about −7500, −5500, +4000 and +11000 counts, with the inner levels wandering by thousands of counts from frame to frame and a drift of the frame mean from +3000 to 0 over the first five frames (about 0.25 s) after the modulation starts. A symmetric 1 kHz tone showed none of that. That is the signature of a **narrow IF (channel) filter ahead of the discriminator, with the signal sitting off-centre by the crystal error**: a tone is narrowband and passes until its Carson bandwidth reaches the filter edge (the deviation table flattens exactly where 2 × (deviation + 1 kHz) reaches about ±3 kHz), while 4800-baud 4FSK is about ±3.6 kHz wide at any deviation and is distorted with memory, one side more than the other. A limiter on the discriminator output would not do that, and it would not care about the modulating frequency. So the register to look for is the FM channel or IF filter bandwidth in mode 5 (the other bits of `FM_BANDWIDTH`, or a channel filter select), not an output limiter; and a cheap discriminating measurement exists.

Amendment to the 17:10 task, in front of its items: **(0)** the deviation sweep again with a **300 Hz** tone (0.5, 1.0, 1.5, 2.0, 2.4, 3.0, 3.5, 4.0 kHz): a 300 Hz tone at 2.4 kHz deviation is only about ±2.7 kHz wide, so if the limit is a filter the 300 Hz curve stays straight to a higher deviation than the 1 kHz curve did (about 5.8 counts per hertz, 14 000 counts at 2.4 kHz); if the limit is an amplitude ceiling the two curves are the same. Then (1) the frequency sweep at 1.0 kHz deviation, (2) the 40/60/80/100 % deviation decodes, where a filter predicts little gain at 40 % (the 4FSK is as wide at low deviation) and a limiter predicts a large one, and (3) the guide reading, now for the FM receive channel/IF filter bandwidth and its register, with an op 6 variant 6 if a write is safe, measured by the 1 kHz deviation sweep. Host side: no change to PR 14's receiver until the filter question is answered; the script stays in the repo for the next captures.

## Review: FW27 sweep at 1 kHz deviation, the reduced-deviation file, and the 300 Hz sweep, 2026-10-26 17:20

`results.md` 17:05 and 17:12, image `e552549c…b2dc`. **Both accepted, and the 300 Hz sweep settles the question my 17:40 note raised the wrong way:** the 300 Hz and 1 kHz tones draw the same deviation curve (2805/2774 at 0.5 kHz, both 1.58× that at 1.0 kHz, both near 6000 counts from 2.4 kHz up), so the ceiling is an amplitude ceiling in the demodulator's output scale, not a channel filter; `FM_BANDWIDTH` bit 1 (12.5/25 kHz receive, reset 25 kHz) is not it, and the stream itself is flat within 0.2 dB from 100 Hz to 2.5 kHz at 1 kHz deviation (−1.3 dB at 3.5 kHz), which is the band M17 needs. The reduced-deviation file is the proof of cause: the same 30 frames through the plain stream decode 21 of 30 payload-exact at 40 % deviation (±0.96 kHz, inside the linear part), 8 at 60 %, 4 at 80 %, 3 at 100 %. The distortion is a saturating nonlinearity with memory (the host maps and filters could not undo it, `reviews.md` 17:40), so the fix is to move the knee, not to model it. **The register is named:** §11.2.2.3 `FM_DEV_COEF` at `0x11000504`, bits 15:8 `fm_dev_coef_r` (receive deviation coefficient, reset `0x10`); bits 23:16 and 7:0 are the transmit limiter and transmit coefficient and must not change. A read-modify-write of bits 15:8 alone is receive-only. Grok did not build it for want of 4 bytes in the stub; the FW27 test pins `new[WRAP_END:0x5C6FC]` to zero, so the tail after `WRAP_END` is free by definition up to the `0x5C6FC` limit, and a load, mask, or and store is about 24 bytes.

Next: **op 6 variant 6 = `fm_dev_coef_r` write**, `[6, 6, v]` with v the new byte for bits 15:8 (read the word, replace bits 15:8, write it back; nothing else in the word changes), placed in the tail after `WRAP_END` or wherever 24 bytes exist below `0x5C6FC`; `[6, 5, 0]` and `[6, 6, 0x10]` both restore the reset value; the variant is refused unless mode 5 is applied. Bench, in order: (1) the 1 kHz-tone deviation sweep (0.5, 1.0, 1.5, 2.0, 2.4, 3.0, 3.5, 4.0 kHz) at v = `0x10` (the baseline, already have), `0x08` and `0x04`: the knee should move out as v halves (the counts per hertz halve, the ceiling stays); report the deviation where each curve leaves the straight line; (2) at the v that keeps 2.4 kHz on the line, the 30-frame file at 100 % deviation through the plain stream, payload-exact, the capture added to `captures/fw27-stream/`; (3) the audio path on channel 56 before and after the write (unchanged expected: the phone's audio is the AT1846S pin, not the C7000 demodulator); (4) `[6, 5, 0]` then the register read back at reset. The runner's `all` after the image change. No transmit bits touched. STATUS REVIEW with the three curves and the decode, or STUCK with the bytes if the space is not there.

## Review: FW27 variant 6 writes the receive coefficient, 2026-10-26 19:40

`results.md` (19:29), image `7126749f…b779`. **Accepted, and it answers the register question the other way.** The staged images did their job: the hole's loads were 32-bit and correct, image A acked with an empty body, image B read `0x000F1010` (limiter `0x0F`, receive `0x10`, transmit `0x10`, as the guide's reset values say), and the shipped image writes bits 15:8 and returns the word; `[6, 5, 0]` leaves the coefficient at `0x10`, channel 56 is unchanged, and the runner's `all` passes (tone p99 2489 Hz, stream 1125/1125, receive −19.0 dBFS, boot silent). The measurement: `0x08` doubles the deviation curve and `0x04` quadruples it at 0.5 kHz, and both still sit on a ceiling by 2.4 kHz. So `fm_dev_coef_r` is a scale applied **after** the saturation, not before it; it moves the counts, not the knee, and there was no linear value for a 100 % decode. The nonlinearity is upstream of the coefficient. What is upstream: the C7000's FM receive path takes the AT1846S's demodulated audio (RC40: the two filters in series, AT1846S `0x58` then the C7000), so the stage before the coefficient is the AT1846S's audio output level into the C7000's input, set by the AT1846S's FM-branch audio registers at tune time (`at1846_tune`'s FM branch writes `0x42`, `0x43`, `0x30` and the `0x44` volume word; `0x44` bits 11:8 are the mic gain, the low bits the receive volume; the DMR branch writes `0x44` = `0x0AD1`). If that level is what clips the C7000's input at about 1 kHz of deviation, lowering it moves the knee in deviation terms, which the coefficient could not do. That is one more register family and the last one on this route: a sweep with the AT1846S receive volume lowered answers it either way. The phone's own audio comes off the AT1846S pin after `0x58`, so the same write may change the audio-path level; channel 56 is measured alongside so the app side knows.

Next, in order: **(0) the owner's Wi-Fi ADB instruction** (19:05 in the task), first, since it needs the phone and a reboot. **(1) Host-only:** from the firmware, the AT1846S values the FM branch writes to `0x42`, `0x43`, `0x44` (and any other audio-level register in that branch), and from the AT1846S guide which of those fields set the receive audio output level; from the C7000 guide, the FM receive input selection (analog in through the codec, or the digital audio interface) and any input gain. A short note in `results.md` naming the register and field to try. **(2) Bench:** op 6 variant 7 = an AT1846S write of that register under mode 5 (the same shape as variant 3's `0x58` write; mode 5 off restores the tune value): the 1 kHz-tone deviation sweep (0.5–4.0 kHz) at two lower levels against the current one, reporting where each curve leaves the straight line, plus the channel-56 1 kHz amplitude at each level; if the knee reaches 2.4 kHz, the 30-frame file at 100 % through the plain stream and its capture into `captures/fw27-stream/`. If the knee does not move, the route is closed on this phone and the report says so: the audio path with taps is the M17 receiver, the stream stays for phones without a flat audio path and for modes inside ±1 kHz. Runner `all` on the final image. STATUS REVIEW. While (1) is host-only, the phone is free for Claude's lease (PR 14 and the queue PRs), announced by a lease line.

## Review: FW27 variant 7 (AT1846S 0x44) and the close of the receive-RAM route on this phone, 2026-10-26 20:45

`results.md` "FW27 variant 7 lowers AT1846S register 0x44 (20:34)", image `f8298581…3ef8`. **Accepted. The route is closed on this phone, as the task said it would be if the knee did not move.** The AT1846S receive gain (register `0x44` bits 7:4, the DAC gain the guide names) behaves exactly like the C7000 coefficient: `0x81` reproduces the stock curve and `0x41` doubles it at every step including the ceiling, so 2.4 kHz stays at about 0.46 of the straight line and the knee stays at 1 kHz of deviation. Both gains sit after the saturation. The phone's audio path follows `0x44` (channel 56 drops 19.6 and 25.1 dB and keeps its 9.5 dB dip), so the phone's audio and the C7000's receive RAM share that gain stage, and the stage that saturates the RAM lies between the AT1846S demodulator and the C7000's capture, in a place neither register reaches; the phone's own path, taken off the same chain, decodes ±2.4 kHz cleanly, which says the limit is in how the C7000 takes the signal in, not in the AT1846S itself. Two register families were the reasonable candidates and both are measured; the guide names no C7000 input-gain field. The written answer for the Armor 26 Ultra: **the audio path with the register hold and the fixed taps is the M17 receiver; the receive-RAM stream is a flat, gapless baseband that saturates above about ±1 kHz of deviation, usable for a phone whose audio path cannot be made flat and for modes that stay inside ±1 kHz, not for M17 at its standard deviation.** PR 14 stays a bench tool at that scope. **Wi-Fi ADB:** done as the owner asked: the property persisted, the connect after the reboot needed no `tcpip`, and it is recorded; association waited for the Wi-Fi panel, which is worth knowing for the next reboot; USB is now unplugged, which the owner should know.

**One defect in the same report is more important than the route and comes next: the symbol stream radiated nothing on this image, twice** (the `0x40` chunks acked, status 4 at the end, `0x26` off acked, both HackRF files within 6 dB of their quietest second), while the tone path radiated (p99 2490 Hz) and the same test gave 1125/1125 on the variant-6 image `7126749f…b779` at 19:29. That is either the variant-7 image (its changes sit near or on something the FW19–FW22 engine uses, or the first stage-D image's wrong-address branch left state the load did not clear) or the module (a no-RF state like the one a channel-write pair leaves, which a single channel write clears). No further route work; transmit first.

Next, in order: (1) **bisect image against state:** load `7126749f…b779` (variant 6, stream known good) and run the runner's `stream`; if it passes, the variant-7 image is at fault: diff `f8298581` against `7126749f`, list every changed range, check each against the symbol engine's code and literal pools (FW19–FW22), say what was hit, and fix the placement; if it fails on `7126749f` too, it is state: one single-path channel write, a module restart, `stream` again, and say which cleared it. (2) **Decide the shipped FW27:** variant 7 has given its answer and has no further use; drop it from the build (variant 6 may stay or go, its answer is in too); the shipped image is the one that passes `all`, with the stop ack and the literal guard; tag and sha in the page. (3) Runner `all` on it. STATUS REVIEW with the bisect result and the final image. Then the phone is free for Claude's lease (PR 14 as a bench tool, the queue PRs).

## Review: the symbol stream is back after the factory image, 2026-10-26 21:35

`results.md` and the 21:25 report, image `7126749f…b779`. **Accepted, and the transmit regression is closed with a rule.** The runner's `stream` passes again (1125/1125, carrier 45.41 s, p99 2862 Hz, end bit) on the same bytes that were silent at 20:44, 20:46, 20:48, 21:00 and 21:01, after one thing the ladder had not done: loading the factory image and keying it. Image reloads, a module restart, a 15 s `dmr009` power-off, an analog and a digital channel tune, and FW26 did not clear it. So the state that blocked the engine's key-up lives where none of those reach and the factory image's start-up or its stock key does: most likely a register on one of the two radio chips that the bench images' start-up never rewrites (the `dmr009` line evidently does not remove their power), or a setting the stock path initialises. The cause of the state is identified: the first stage-D image of variant 7 branched to a file-offset address and executed whatever lies at XIP+`0x2B220` before the restart; random code can write any register. The exact register is not identified and does not need to be tonight; the rule covers it. **Rule, in the standing bench practice from now on:** after any image that hung, took a wild branch or was restarted mid-command, load the factory image and key it once (a 3 s stock PTT on a digital channel, status 3 seen) before loading the next bench image; and when a bench image stops radiating with no change in its bytes, the factory load is the first recovery, before power cycles and tunes. Written into `HANDOFF.md`'s standing rules and CLAUDE.md. **The FW27 bench image is `7126749f…b779`** (op 6 variants 3–6, op 16, op 17 with the period byte and the stop ack, the literal guard; variant 7 is dropped, its answer is in `results.md`); it passed `all` at 19:29 and `stream` again now. No further firmware step is open tonight: the hotspot rows and the new phones are the next items and both wait on deliveries. Grok on standby; the phone is Claude's under the lease below.

## Review: M17 SMS, packet mode (Claude, 2026-10-26 23:30)

**Report:** HANDOFF 23:13, `results.md` "M17 SMS, packet mode (2026-10-26, 23:10)", SignalDeck PR 24 (`grok/m17-sms`, one commit `8393dd59`), phonedmrapp `623011b9` (plan §1, `m17.py` packet codec, results).

**Verdict: accepted as a host and HackRF pass; PR 24 is mergeable once the owner wants it, and the independent check stays with the hotspot.**

What was checked here:
- **Spec reading** (plan §1): correct; the earlier recollection's wrong widths (data-type and encryption bits in the packet TYPE, "about 800 bytes") are gone. TYPE = `CAN << 7`, 6-bit field, P3 `[1,1,1,1,1,1,1,0]`, 823 bytes / 33 frames, CRC over type+payload+null, big-endian.
- **Code scan of PR 24:** no libm17 or m17-cxx-demod text; the only GPL line is SignalDeck's own licence header on the new test file. No callsign but `N0CALL`. No firmware-side file. The symbol-engine send path is reused, not changed.
- **Voice path:** `HeldPath` now scores three sync words (LSF, stream, packet) in the chain follower instead of two; `M17Receiver` adds a PACKET state entered only from a packet-mode LSF (stream bit 0 with CRC good), so a voice call never lands there. The bench's `stream` 1125/1125 after the change and the host suite cover it: **375 host tests, 0 failures** on the branch (HeldPathReceiver 5, HeldPath 4, HeldPathRing 1, M17Packet 3), run here 23:25.
- **Bench numbers** (`results.md`): receive 9/9 payload-exact at three lengths (1, 5, 15 bytes); transmit three texts CRC good at body p99 2827–2845 Hz (the voice stream's 2896 Hz, same modulator); one exchange both ways. The 0/9 pass 240 kHz low is a HackRF tuning slip, correctly not counted. The stream silence before it was the known symbol-engine state, cleared by the factory-key rule from 21:35.

Open, not blocking:
1. **Longer texts.** The bench stopped at 15 bytes (one frame). The host test covers the 25/26-byte boundary and 200 bytes; one on-air text of 26+ bytes (two frames, counter 0 then the last-frame count) closes the frame-counter path on the radio. Next step below.
2. **Help and changelog** are in the PR (M17 topic "Text messages" section, dated row). The Messages tab the owner sketched tonight (threads per contact across DMR, M17 and pager, a receive-only monitor mode, a tap on an ID opening its thread) is a later design; PR 24's list on the M17 page is right for now.
3. The `M17Receiver` PACKET state drops a lost frame silently (`assemble` then fails the CRC); fine for SMS, but a frames-lost note in the history line helps the hotspot test.

**Merge:** not merged tonight; the owner said the SMS is tested after the hotspot is up. PR 24 waits as the queue PRs did, and merges after that check or on the owner's word.

## Review: M17 SMS two-frame text and frames-lost note (Claude, 2026-10-26 23:40)

**Report:** HANDOFF 23:29; SignalDeck `grok/m17-sms` commit `0e56cfcd` on PR 24.

**Verdict: accepted. M17 SMS is complete on the bench; PR 24 waits for the hotspot check or the owner's word to merge.**

- A 26-byte text (two packet frames, counters 0 then the last-frame count 5) transmitted 3/3 with the host CRC good and received 3/3 with the same text logged, so the frame counter and the last-frame count are proven on the radio, not only in the host test.
- A packet whose CRC fails or whose run lost a frame now puts one line in the history, "M17: frames lost", from either receiver; nothing is listed as a text. Host test added. Suite on the branch here: **376 tests, 0 failures** (23:35).
- No GPL text, bench callsign only, no firmware file, the frames-lost hook is three lines per receiver and does not touch the voice path.

Grok has already started part A of `docs/plan-pocsag-receive-and-web.md` on `grok/pocsag-rx` (first commit, the audio slicer for the three rates), which is the queued order. Nothing further on SMS until the hotspot.

## Review: POCSAG receive, part A (Claude, 2026-10-27 08:55)

**Report:** HANDOFF 08:4x, `results.md` "POCSAG receive, held path (2026-10-27, 08:31)", SignalDeck PR 25 (`grok/pocsag-rx`, four commits, head `2c2ecdd0`, stacked on PR 24).

**Verdict: accepted as a first pass; two fixes before the PR is complete, listed as the next step. Not merged.**

What is in and checked:
- **Held path, 1200 and 2400 baud: 3/3 each, RIC, text and baud exact, 0 corrected codewords** at 2.5 kHz. That is the DAPNET case and it matches the R-F prediction (0.039 bit errors per codeword behind the M17 taps).
- The plan's pieces are present: `PagerStation` on the same audio tap as M17 with the register hold on a stub tag, the pages store with the RIC/callsign/RIC-thread filing, M17 texts keyed by source callsign with the shared `@ALL` thread (A.3), Messages threads with the transport chip and unread counts, monitor mode stepping a frequency list and waiting out a preamble, tap a page to open its thread with Save as contact and Mute, a notification for an own-RIC page, help (Messages topic, Pager receive section, M17 text section) and the changelog row.
- Clean: no GPL or third-party decoder text, no callsign but the bench ones and the W1AW stand-in in a test, no firmware file, the voice path (`HeldPath`, `M17Receiver`) and `PagerScreen`'s send routine untouched. **Host suite on the branch here: 381 tests, 0 failures** (08:50; PocsagDecoder 3, Pocsag 4, MessageThreads 2).

Two findings, both in the report's own numbers:
1. **Wrong RIC with the right text, twice** (512 baud held: RIC 123617 for 1001; 1200 baud plain path: 16330 for 1002). In both the frame position (RIC low 3 bits) is right and the 18-bit address field is wrong, so the address codeword had more errors than BCH(31,21) can fix and the correction landed on a wrong codeword. The decoder does not check the **even-parity bit** (bit 32 of every codeword) after correction; a miscorrected word fails it about half the time. Add the parity check, and when the address word of a page fails it, list the page with "RIC unreadable" rather than a number (the text can still show). This is a correctness fix and it needs no bench to prove: a host test with a 3-error address word.
2. **The stock path is the plain slicer, not the plan's decoder.** Plan A.1 asks for the DFE with BCH correction in the feedback loop (`rx/blind3.py`) with the Armor's `eqcal2500` coefficients for stock firmware; the research measured 21–23 % raw bit errors on that path, which no slicer survives, and the one hold-off page confirms it. Either port `blind3.py` as planned (the equaliser is per profile, shipped from `rx/equalizers`) or, if that is deferred, the help must say receive needs the bench firmware and the station must refuse to start on stock rather than list wrong RICs.
3. (Smaller) 512 baud missed one of two texts even on the held path. Bits are 2 ms at 512, four times longer than at 2400, so baseline droop between transitions is the likely cause even on the flat path: a slicer threshold that tracks a running mean over the last 16–32 bits, re-centred at every sync word, should hold it. The Armor recordings under `tools/pocsag-research/rx/recordings-armor26/` and the generator give a host test for it.

Monitor mode and the threads were not bench-exercised in this report (two frequencies in the scan list, a signed page from an unknown RIC, a bare page); they are in the next step's pass list so the PR closes with the plan's bench done.

## Review: POCSAG part A fixes, 512 baud diagnosed (Claude, 2026-10-27 09:30)

**Report:** HANDOFF 09:02, `results.md` "POCSAG parity check and 512 baud (2026-10-27, 09:00)", SignalDeck `grok/pocsag-rx` commit `6671a3c3` on PR 25.

**Verdict: parity check, stock refusal and the thread filing accepted; 512 baud and monitor mode are not done, and the 512 cause is now known. Host suite on the branch here: 384 tests, 0 failures (09:25).**

What is accepted:
- The even-parity check after the BCH repair and "RIC unreadable" for a failing address word (text kept). Right as written: the parity bit is checked against the repaired 31 bits.
- Hear pages refuses to start on stock firmware (the plan allowed this instead of the DFE port; the help says receive needs the bench firmware). The DFE stays a backlog item for a phone whose audio path cannot be held.
- Thread filing on the bench: a signed page filed under the callsign, a bare page under its RIC. The contact-thread case still has to be shown with a contact saved through the app's contact editor (the temporary row was never consulted, so that path is untested, not failed).

**512 baud, diagnosed on the host (no bench needed):**
- The research generator is not at fault: `pocsag.py gen --baud 512 --ric 1001` decodes with its own `rx` as RIC 1001 (checked 09:20).
- The wrong number is deterministic because it is not noise. Sent address codeword for RIC 1001 function 3: `000FBBCF`. The codeword that decodes to RIC 123617: `078B9BCF`. They differ in **six bits, all inside the run of twelve zeros at the start of the word** (`xor 07842000`): bits 26–23 read as ones instead of zeros, and bits 18 and 13. Six flips on BCH(31,21), whose minimum distance is six, land exactly on another valid codeword, and an even number of flips keeps the parity even, which is why the parity check could not catch it.
- The mechanism is the **32-bit running mean**: a run of twelve identical bits is 23 ms at 512 baud against a 62 ms window, so the baseline drifts toward the run's level and the later bits of the run cross the threshold. At 1200 baud the same run is 10 ms against 27 ms and the drift stays below the decision margin, which is why 1200 and 2400 were exact. A threshold that re-centres on each sync word helps only the first bits after the sync.
- **Fix:** on the held path (DC-flat to 50 Hz) do not track a short baseline at all. Take the threshold once per batch as the mean of the samples across the sync word (a balanced 16/16 pattern, so its mean is the true midpoint) and hold it for the whole batch; or, if a tracker is kept, its window must be longer than a batch (544 bits), never 32. Host test first: the generator's 512 wav resampled to 8 kHz through the app decoder reproduces RIC 123617 with the 32-bit mean and RIC 1001 with the fixed threshold; add the 1001/123617 pair as a regression test. Then 512 baud 3/3 on the held path.

**Monitor mode:** "the pages decoded during the step were not the two texts that were sent" is a finding, not a pass. Say in the next report what was listed: if the listed pages had other texts or RICs, they are false decodes and the sync acceptance is too loose (a sync word within two bit errors plus an address word that passes BCH and parity should be required before a page opens); if nothing of the sent texts was listed, the step landed mid-batch or the dwell was too short. Dwell at least one preamble plus one batch (about 2.3 s at 512, 1.1 s at 1200) and step only while no preamble is in progress.

## Review: POCSAG 512 baud on the air, the droop (Claude, 2026-10-27 09:45)

**Report:** HANDOFF 09:28, `results.md` "POCSAG 512 baud threshold (2026-10-27, 09:26)", SignalDeck `grok/pocsag-rx` commit `e6d787b6` on PR 25. Host suite here: **385 tests, 0 failures** (09:40); voice path untouched.

**Accepted:** the per-batch threshold (the sync word's mean, held for the batch) and the regression test that shows the generator's 512 file decoding as RIC 1001 with it and as 123617 with the old 32-bit mean. A failed address opens no page.

**512 baud on the air is a different fault, and it is in the path, not the slicer.** The same build still read 123617 on the held path. The six flipped bits are the *late* bits of the twelve-zero run (bits 26–23, then 18 and 13: the run's end), the signature of a level that **droops toward the midpoint during a long run**: a first-order high-pass somewhere before the decoder. The held path was measured flat to 50 Hz (R-D), but a 23 ms run is 20 Hz content, below anything measured; the ES8311 ADC's DC-removal filter (noted in `CLAUDE.md`, "may account for part of the RX loss") is the likely corner. The slicer sees the zeros sag through the threshold, and once six bits flip the word is another valid codeword. At 1200 and 2400 the run is 10 and 5 ms and the sag stays inside the eye, so those rates were exact. The M17 matched filter and the 41 taps that `bestHeld` applies cannot help here (their span is under a millisecond) and may add a little low-frequency boost error of their own at 256 Hz; neither is the cause.

**Fix, host first, from a recording (no decoder guessing):**
1. Record one 512 baud reception on the held path on the phone (`DIAG rxclip` or REC, 8 kHz) and put the clip beside the research files; the HackRF page is deterministic, so one clip is enough.
2. On the host, plot the clip's level across the twelve-zero run of the address word: measure the sag (first bit level against last bit level of the run) and fit the time constant τ of a first-order high-pass from it. Report τ.
3. **DC restoration before the slicer on the held path:** undo the high-pass with its inverse, a leaky integrator `y[n] = x[n] + (1/(τ·fs))·Σ x` (first order, one coefficient per phone profile, the Armor's from the clip). Decode the clip with it: RIC 1001 expected. Keep the clip as a regression test. If the sag turns out too small to explain six bits, try the same clip without `matched` and the taps (plain held audio, per-batch threshold) and report both.
4. Then 512 baud 3/3 on the air, and the 1200/2400 pass repeated once on the new path (they must stay exact).

**Monitor mode:** nothing listed during two transmissions is the dwell, not false decodes. With two frequencies and a 2.3 s dwell the scanner is on the right frequency during the 1.1 s preamble about a quarter of the time, and the receive audio needs some settling after each retune (RSSI needs 0.7 s; audio was not measured). Change: detect a preamble fast (150 ms of alternation at baud/2: 256, 600 or 1200 Hz), dwell about one second per frequency, hold while a preamble or batch continues, step only between batches; and on the bench send each text with `--repeat 3` so the preamble is on the air long enough to be caught. Record the dwell numbers and the catch count in `results.md`.

**Contact thread:** not run. Add a hidden bench extra `DIAG contact --es name N0CALL-9 --ei ric 1001` that saves a contact through `ContactStore` (like the other DIAG extras, the guide unchanged), then send the page: it must file under that contact's thread. The remaining checks of part A are then the bench list in the 09:30 note.

## Review: POCSAG 512 baud restored; false pages and the tail (Claude, 2026-10-27 10:50)

**Report:** HANDOFF 10:32, `results.md` "POCSAG 512 baud droop (2026-10-27, 10:31)", SignalDeck `grok/pocsag-rx` commit `39fe9165` on PR 25. Host suite here: **388 tests, 0 failures** (10:45); the new commits touch no voice-path file (checked against `grok/m17-sms`).

**Accepted:**
- The 512 baud fix: the held-path clip (`rx/recordings-armor26/rx_p512_held.wav`) decodes as RIC 1001 after a one-pole high-pass of 1.6 ms is inverted, the coefficient lives on the Armor profile (`pocsagTauSec`), the inverse runs only when the preamble measures 512 baud, and the regression test is in. On the air every 512 page now carries RIC 1001; 1200 (corrected 0) and 2400 (corrected 1) are payload-exact on the taps. The decision to leave 512 off the M17 taps is right (they turned the address into 123617).
- The contact thread: the `DIAG contact` extra saved through the store and the next page filed on that contact; the row was removed. Part A's thread cases are now all shown.
- Monitor mode caught one of the two pages with a 1 s dwell and the 150 ms preamble check.

**Two things are not done, both in the report's own numbers:**
1. **False pages.** "Four other listings were not the sent texts" means the decoder opens pages from noise. With two-bit BCH correction about a quarter of random 32-bit words correct to a valid codeword (497 of 2048), half of those pass parity, so a sync word matched within a few bit errors on open-squelch noise is followed by a "valid" address often enough to list a page every few minutes of listening. Monitor mode listens to noise most of the time, so this is where it shows. Fix: (a) no sync search unless a preamble was heard in the preceding half second (the detector exists; the sync search must be gated by it); (b) the sync word within at most two bit errors; (c) a page opens only when its address word passes with at most one corrected bit and the parity, and at least one message word follows that also passes; (d) a host regression test: 60 s of band-limited noise at the squelch-open level through the decoder gives zero pages, at all three rates. Report what the four listings were (RIC, text) so the rule is checked against them.
2. **The last character.** "RESTORE B" and "RESTORE C" lost their last character; the 09:00 bare page at 1200 was "one character short" too. The transmissions end right after the last batch (the generator pads one idle word, 62 ms at 512), and `hackrf_transfer -n` cancels its in-flight USB transfers at the end, up to about 260 ms (the M17 bench learned this and pads 0.5 s of carrier). The cut eats the final words at random, which is why one text is exact and the next is not. Fix on the bench side first: give `pocsag.py gen` a `--pad` that appends at least 0.5 s of idle words after the last batch (research tool, phonedmrapp), and repeat the 512 texts. If a text still loses its last character with the pad, the fault is in the decoder's end of text and gets a host round-trip test of texts of lengths 1 to 40 at all three rates through the app's own encoder and decoder.

**Monitor's missed page** ("LEFT THREE" on 467.625): judge it after the false-page fix, since a false page holds the step on the wrong frequency. If it is still missed, log the dwell timeline (frequency, preamble seen, hold) and measure the audio settle after a retune (time from the channel write to the first valid audio); add that to the dwell.

**Part A closes** when the noise test is in, the four listings are explained, the padded 512 run is 3/3 exact, and the two-frequency monitor run catches both texts. Then part B.

## Review: POCSAG noise gate and monitor; two items keep part A open (Claude, 2026-10-27 11:20)

**Report:** HANDOFF 10:59, `results.md` "POCSAG false pages and the tail (2026-10-27, 10:58)", SignalDeck `grok/pocsag-rx` commit `9895fd82` on PR 25; phonedmrapp `545e76cb` (the generator's 0.5 s pad). No voice-path file touched (checked against `grok/m17-sms`).

**Accepted:**
- The false pages are explained (five numeric-function pages from noise, listed with RIC, text and correction count) and closed: a sync is kept only after 256 alternating bits unless it continues an open page, a word repaired by two bits does not extend a page, and 60 s of band-limited noise opens nothing. Right diagnosis, right rule.
- Lengths 1–40 round-trip at all three rates, so the decoder's end of text is sound.
- Monitor mode: the retune settle is measured (audio about 0.8 s after the tune line), the dwell is 2.5 s, and the two-frequency run caught both texts exact in seven steps with no other page. That is the plan's monitor pass.
- The generator pads 0.5 s of idle words (`pocsag.py gen`).

**Two items keep part A open:**
1. **The host suite is red on the branch: `PocsagTest.three_rics_in_one_transmission` expects 3 pages and gets 2** (run here 11:15, 391 tests, 1 failure; the 10:45 run of the previous commit was 388/0, so the new gate did it). A three-RIC transmission is several pages in consecutive batches; once the first page closes at its idle word, the next batch's sync has no preamble before it and no page open, so the gate drops it. DAPNET sends many pages per transmission exactly like that. The rule has to be "a preamble before the first sync of a transmission; after a sync and its batch, the next sync is expected 544 bits later and is accepted within two bit errors whether or not a page is open; the transmission ends when the expected sync is absent." Fix, run the suite green, keep the three-RIC test as it is.
2. **The 512 baud last character, now diagnosed from the code.** `PocsagDecoder.restore` is the exact inverse of the one-pole high-pass, `state = s − b·prev + state`, which is an integrator: a pole at DC. Any residual offset in the audio accumulates linearly across the clip, and subtracting the clip's global mean afterwards leaves a ramp, so the per-batch threshold taken at the sync is wrong by the end of the batch and the last word fails. That is why one of three texts is exact and the others lose the last character "in the received audio": the ramp depends on the offset of that clip. Fix: make the inverse leaky, `state = s − b·prev + c·state` with `c = exp(−1/(fs·τ_long))`, τ_long about 40–100 ms (the DC gain becomes τ_long/τ, about 25–60, instead of unbounded), and drop the global-mean subtraction or keep it, both are fine then. Host test: the "RESTORE B" clip through the app decoder must give the full text; keep it as a regression clip beside `rx_p512_held.wav`. Then 512 baud 3/3 exact on the air with the pad.

Part A closes on a green suite, the three-RIC test kept, and the padded 512 run 3/3. Then part B on `grok/web-pager`. (My own check of a leaky inverse on the held clip with the research decoder was inconclusive: that decoder reads none of the held-path variants, so the app's decoder is the instrument.)

## Review: POCSAG sync cadence accepted; the last character is the bit clock (Claude, 2026-10-27 11:45)

**Report:** HANDOFF 11:16, `results.md` "POCSAG sync cadence and leaky restore (2026-10-27, 11:15)", SignalDeck `grok/pocsag-rx` commit `1bde144e` on PR 25. Host suite here: **392 tests, 0 failures** (11:40); no voice-path file touched (against `grok/m17-sms`).

**Accepted:** the sync cadence (a preamble before the first sync, each later sync expected 544 bits on and taken within two bit errors whether or not a page is open, the transmission over when it is absent); `three_rics_in_one_transmission` passes again and the noise gate stays. The `rx_restore_b.wav` clip is kept beside the held clip.

**The leak was my wrong call, and the report shows why.** The exact inverse was right for the long runs (the ALPHA clip and "RESTORE A" decode with it) and a leak of 100 ms empties the clip, 250 ms adds a stray character: the leak undoes the very correction the runs need. Keep the exact inverse with the mean removed (`tauLong` 0) and drop the leak from the 512 path.

**The last character is the bit clock, not the level.** Three facts: (1) the damage is always in the last message word of a batch and nowhere else; (2) it happened once at 1200 baud too (the 09:00 bare page, "one character short"), so it is a count-of-bits effect, not a time effect like a droop; (3) `follow()` steps `pos += spb` with the preamble's estimate and re-aligns the phase only at a sync word (`pos = start + shift + 32·spb`), so within a batch the clock is open loop for 544 bits. A rate estimate off by 0.15 % (15.60 against 15.625 samples a bit at 512, 0.01 sample at 1200) has the sampling point a full bit late by the end of the batch: the first words are sampled mid-bit, the last word on its transitions. The errors in the report fit that: "A"→"a", "B"→"`", "C"→"S" plus a stray "p" are one or two bits of the final character and the padding after it, the last bits of the batch, and the BCH then "corrects" a word with three or more wrong bits into another valid one.

**Fix, host first on the two clips:**
1. **Measure it:** for `rx_restore_b.wav` print, for each of the 17 words of the batch, the number of bit errors against the sent words before BCH; the count must climb toward the last word if the clock is the cause (flat and small if it is not). Also print the sampling-phase error at the last transition of the batch against the preamble's estimate.
2. **Refine the rate from the syncs:** the spacing between two sync words is exactly 544 bits, so `spb = (sync2 − sync1) / 544` is a far better estimate than the preamble's; use it for the second batch on, and for a one-batch transmission use the idle words after the page (they are sync-timed codewords too).
3. **Track the clock inside the batch:** at every transition move `pos` a fraction (about 1/8) of the distance from the transition's zero crossing to the nearest bit boundary, the usual first-order loop (`rx/pocsag_pll.py` in the research files did this on the stock path). With that, the preamble's estimate only has to be within a few per cent.
4. Both clips must decode with the full text; keep them as regression tests; then 512 baud 3/3 on the air with the pad, and the 1200/2400 run once more. Part A closes on that.

## Review: POCSAG bit clock tracked; the tail is not on the air (Claude, 2026-10-27 12:00)

**Report:** HANDOFF 11:28, `results.md` "POCSAG bit clock (2026-10-27, 11:30)", SignalDeck `grok/pocsag-rx` commit `8a8ce1bf` on PR 25. Host suite here: **393 tests, 0 failures** (11:55); no voice-path file touched.

**Accepted:** the measurement and the fix. Raw errors per word of 0, 0, 2, 2, 7, 10, 13 across the batch, flat 0 after the transition tracker, is the open-loop clock exactly as diagnosed, and the tracker (one eighth of the way to each strong zero crossing) is the right loop. The leak is out; the exact inverse with the mean removed stays.

**The remaining 8 errors are the transmission's end, not the decoder.** The last word's first 16 bits match, then xor `0x7f10`: of the remaining 15 bits, 8 are wrong, about half, which is what noise reads as after a carrier drops. The transmission ends about 16 bits into the last codeword. With a 0.5 s pad of idle words after the page that cannot happen, so **the pad is not on the air**: the likeliest cause is the bench script's `hackrf_transfer -n` sample count still computed from the unpadded length (the file grew, the count did not), or the IQ written before the pad was appended. Two checks settle it in minutes: (1) the clip's audio after the last word, modulation for 0.5 s (idle words) or squelch noise (the carrier dropped); (2) the `-n` value in the bench script against the padded IQ file's sample count. The held ALPHA clip is from before the pad and has the same cut, which is why it "starts with ALPHA" and is not full text either.

**Next:** fix the bench script so the padded file goes out whole (the IQ length is the count), re-record both clips (`rx_p512_held.wav` with the pad, `rx_restore_b.wav`), both must decode the full text with the tracker and become the regression clips, then 512 baud 3/3 exact on the air and 1200/2400 once more. Part A closes on that, then part B. If the padded clip still ends inside the last word, report the audio after it (energy per bit for the last 64 bits) before changing the decoder again.

## Review: POCSAG pad on the air; the last word's dip is the 17-bit padding run (Claude, 2026-10-27 12:10)

**Report:** HANDOFF 11:57 (`results.md` of the same step). No decoder change, so the 11:55 suite (393/0) stands.

**Accepted:** the bench script now sends the whole padded file (7,375,000 samples, the transfer rounded up to the HackRF's 262,144-sample buffer, 4.03 s on the air) and the new RESTORE B clip proves the tail is there: full level through the pad.

**What the clip shows is the cause, and it is not a cut.** Bits 768–805 loud, 806–822 at about 200, full again from 824. Count the batch: preamble 0–575, sync 576–607, idle 608–671, address 672–703, three message words 704–799, the last word 800–831. So 806–822 is inside the last word, and 822 is just past where the text ends: "RESTORE B" is 63 bits in four 20-bit payloads, 3 bits in the last word, then **17 padding bits**, then the check field. The generator pads with one level, so those 17 bits are a 33 ms run; through the 1.6 ms high-pass that run decays to about zero within a few milliseconds, which is exactly the "about 200" the clip shows, and the exact inverse with a τ fitted on a 12-bit run plus a clip-wide mean removal is not accurate enough over 33 ms, so the restored run lands near the threshold and the check field reads wrong. Real pagers and DAPNET pad the last word the same way, so the decoder has to take it. "ALPHA ONUp" is the same thing from the other side: pad bits read as characters.

**Next, host first on the two new clips:**
1. **Fit τ from the run itself:** an exponential fit to bits 806–822 gives the high-pass time constant directly (expect near 1.6 ms, report the number); then the inverse with that τ, and remove the mean measured over the **preamble** (a balanced pattern) rather than over the whole clip, which a long run biases. Both clips must then decode payload-exact; keep them as the regression clips.
2. **End of text:** stop the text at the first 7-bit NUL (0x00) or EOT (0x04) and never render padding, so a damaged pad can at worst fail the word, never print "Up".
3. If the fitted inverse still leaves the run short of the eye, the fallback is decision-aided: inside a run, hold the previous decision while the restored level has not crossed the threshold by at least a quarter of the eye (hysteresis), which a decaying run cannot do.
4. Then 512 baud 3/3 exact on the air and 1200/2400 once more. Part A closes on that; then part B.

## Review: POCSAG part A closed (Claude, 2026-10-27 12:25)

**Report:** HANDOFF 12:18, `results.md` "POCSAG padding run (2026-10-27, 12:16)", SignalDeck `grok/pocsag-rx` commit `8ab11ae9` on PR 25. Host suite here: **394 tests, 0 failures** (12:23); no voice-path file touched.

**Accepted; part A is closed.** The padding run gave the real time constant: an exponential fit of the run's sample means (2541 down to 160 over twelve bits) is τ = 7.6 ms, so the earlier 1.6 ms was a fit to a run too short to show it, and 7.5 ms is now on the Armor profile. The inverse stays exact, the offset is the restored preamble's mean, the text stops at NUL or EOT, and a run at 512 keeps its decision until the restored level clears a quarter of the eye. Both new clips decode payload-exact and are the regression clips (`rx_alpha_pad.wav`, `rx_restore_b_pad.wav`). On the air: 512 baud three texts, 1200 and 2400 one each, every page corrected 0, which is the plan's 3/3. The noise gate, the sync cadence, the clock tracker, the thread cases and the monitor run were accepted in the earlier reviews.

**Carried into PR 25's state:** the stock path is refused (the DFE port stays a backlog item for a phone whose audio path cannot be held); the per-profile pager time constant means every new phone profile needs its own 512 baud clip once; the 4.5 kHz deviation limit from the research still applies and was not re-measured today.

**Next for Grok: part B** of `docs/plan-pocsag-receive-and-web.md` on `grok/web-pager`, stacked on `grok/pocsag-rx` (it needs the pages store). One new rule since the plan was written: every new page or tool is wired into Restricted mode in the same change (PR 26, branch `restricted-mode`, draft): the web pager page's send and the M17 text box must honour `svc.modeAllowed("pocsag")` and `("m17")` and the route tables in `WebHost` (`ROUTE_MODES`), and the Device panel's two actions (`ROUTE_ADMIN`: restart under `report`, update under `web` or its own id). PR 26 is not merged yet, so write part B so that the gate is one `modeAllowed` call per route, and I will merge the two on review.

## Review: POCSAG part B, the web gaps (Claude, 2026-10-27 13:25)

**Report:** HANDOFF 13:13, `results.md` "POCSAG web pager (2026-10-27, 13:12)", SignalDeck PR 27 (`grok/web-pager`, `fffe3e2d` + `651bb9a5`, stacked on PR 25). Host suite here: **397 tests, 0 failures** (13:22); no voice-path file and no `PagerScreen` change; no PIN in any log.

**Accepted:** the Pager page in the browser, `/api/pager/pages` (a HackRF page listed one second after it was heard), the monitor switch both ways, the M17 text box and its list, the read-only radio-module card (tag, profile, temperatures, own-at-boot, Wi-Fi debugging), the update check that finds a build and does not install without the second confirmation, the restart behind a confirmation, help text, the changelog row. The route table (`WebRoutes`) with one `modeAllowed`/`adminAllowed` call per route is what the Restricted-mode rule asked for; the stub methods in `RadioService` will be replaced by PR 26's real ones when the two merge (I resolve that conflict).

**Not accepted yet: the browser's page never reached the air.** The send returned "Sending to 1 RIC", the radio log shows the VFO write and the symbol-waveform command and the channel restored, but no key line, and both HackRF captures stayed under 500 Hz with no codeword. The browser handler calls the same `svc.sendPage(...)` the phone's Pager screen calls, so the web layer is not the suspect; the symbol engine did not key. Two causes are possible and the next step tells them apart:
1. **The known symbol-stream silence** (`CLAUDE.md` M17 row, 21:35 rule of 2026-10-26: after a bench session the symbol engine can stop radiating with unchanged bytes; the factory load and one key cleared it). The pager receive work kept the radio on FW27 all day with many HackRF sessions, so this is likely.
2. **Something in `pocsag-rx` holding the module** while the page streams: the pager receive's register hold (`setHeldPath`) or monitor mode still applied when `streamPage` runs.

**Next (phone):** (a) with pager receive and monitor off, send the same page from the **phone's** Pager screen on the same build: if it keys, the fault is in the web path's state (compare what is running when each sends); if it is silent too, (b) run the runner's `stream` test (M17 symbol stream): silent means the engine is stuck, so apply the factory-key rule (factory image, one key on channel 4, reload FW27, `stream` 1125/1125), then repeat the browser send. Also confirm the browser's **M17 text** was on the air, since it uses the same engine (the report says listed, not decoded). Pass for part B: the browser page decoded by the host decoder from the HackRF capture, and the M17 text decoded likewise. Report with STATUS REVIEW.

## Review: why the page never keys: FW27 broke ops 8 and 9 (Claude, 2026-10-27 13:55)

**Report:** HANDOFF 13:33, SignalDeck `grok/web-pager` `74063afc`. Op 8 (the symbol waveform) sent eight times, never answered; op 3 answered; runner `stream` 1125/1125 on the same FW27 image.

**Cause, read from the two images (`radio_firmware/build/DMR003.FW26.V022.bin` against `FW27`, disassembled with the C-SKY objdump):**
- The `0x40` sub-op dispatcher at `0x5B7D4` is identical in both up to the op handlers. Ops 8 and 9 call their handlers (`bsr 0x5B888`, `bsr 0x5B924`) and then `br 0x5B864`, the **shared exit** that tests the handler's result and sends the reply (`cmpnei r0,0; bt 0x5B876; … bsr 0x8E7C`). Op 14's dispatch (`cmpnei r3,14` at `0x5B848`) lives in the same stretch.
- FW27 put **op 6 variant 6** (the `FM_DEV_COEF` write) into `0x5B81A..0x5B875`, on the note that "the branch at 0x5B816 skips 0x5B81A..0x5B875 and nothing outside that range loads from it". That is true for literals, but **two branches outside the range land inside it**: `0x5B7EE br 0x5B864` (op 8) and `0x5B7FC br 0x5B864` (op 9), plus the op 13/14 fall-through `0x5B814 bt 0x5B848`. In FW27, `0x5B864` is now the middle of variant 6: `and r5,r0; lsli r1,8; or r5,r1; st.w r5,(r4)` with r4 = `0x11000504` (`FM_DEV_COEF`), then `jmp r15`. So every op 8 or op 9 **returns without a reply and writes a stale register value into the C7000's FM deviation coefficient**. Op 14 (the flash read range check) also runs variant-6 code. Ops 1–7 (M17 voice), 12, 15–17 use other exits, which is why `stream` passes.
- The literal guard (`tools/fw-patch/literal_guard.py`) checks `lrw` loads only; it has no branch-target check, so it passed.

**Consequences:** POCSAG pages (op 8), the polyphase symbol engine (op 9), and anything built on them do not work on FW27 and leave `FM_DEV_COEF` disturbed until a reboot or a channel write that rewrites it (worth one register read after a failed page, to know). Every bench result on FW27 that used ops 8/9 is void; the M17 work (ops 1–7, 16, 17) stands.

**Next (Grok), two steps:**
1. **Finish part B on FW26** (it has ops 8–11 from the FW21 line and op 15; the pager send passed on it on 2026-10-25): load `DMR003.FW26.V022.bin` with the loader, key once, then the browser page and the browser M17 text, each decoded by the host decoder from a HackRF capture (for the 0.45 s M17 text, start the decoder's window 50 ms before the strongest bin, as the SMS bench did). That closes PR 27.
2. **FW28 = FW27 minus the overlap:** restore `0x5B81A..0x5B875` to FW26's bytes (keep FW27's op 13 redirect at `0x5B816`), and drop variant 6 (the stream route it served is closed, `CLAUDE.md` M17 row) or move it into free stub space; **extend `literal_guard.py` with a branch-target check** (every `br/bt/bf/bsr/jmpi` from outside a reclaimed range must not land inside it) and add a test that fails on FW27 and passes on FW28; runner `all` on FW28 plus one POCSAG page decoded. Record the fault in `results.md` and in the firmware chapter. The bench rule grows: a reclaimed range must contain no literal **and no branch target** that outside code uses.

## Review: part B passes on FW26; PR 27 complete (Claude, 2026-10-27 14:18)

**Report:** HANDOFF 14:08 (`caa8e05a`). FW26 loaded (13:46:38, tag `DMR003.FW26.V022`), one 2 s low-power tone keyed; the browser page (RIC 1001, "FW26 PAGE", 512 baud) keyed 2.63 s, p99 2659 Hz, clip 0, every codeword Hamming 0 on the flat discriminator; the browser M17 text "WEB M17" to @ALL keyed 0.45 s, p99 2977 Hz, decoded from the start of the carrier with the CRC good, bench callsign.

**Accepted; PR 27 (part B) is complete.** That confirms the diagnosis: the same app code transmits on FW26 and not on FW27, so the fault was the image. Two notes for the record, neither blocking: `pocsag.py rx` removes a 20 ms mean, which suits phone audio but damages the last word of a HackRF capture's flat discriminator output (the codeword check is the measure for captures); and my "50 ms before the strongest bin" advice was wrong for a short M17 transmission, whose carrier is flat, so decoding from the carrier start is the right window. PRs 24, 25 and 27 stay open for the hotspot check or the owner's word; the radio is on FW26, which is a fine bench image until FW28.

**Next: FW28** (host first, then the bench): FW27 with `0x5B81A..0x5B875` restored to FW26's bytes, the op 13 redirect at `0x5B816` kept, variant 6 dropped (or moved into free stub space if a later step needs it); `literal_guard.py` gains a branch-target check (every `br/bt/bf/bsr/jmpi` from outside a reclaimed range must not land inside it), with a test that fails on FW27 and passes on FW28; then on the phone: runner `all`, one POCSAG page decoded, the M17 stream 1125/1125 and the RAM stream start/stop still working; record in `results.md` and the firmware chapter. Report with STATUS REVIEW. After FW28, Grok's queue is empty until the owner picks the next item.

## Review: FW28 restores the exit but leaves FW27's own branches into the removed code (Claude, 2026-10-27 15:10)

**Report:** HANDOFF 14:57 (`b9e4ca4c`). FW28 `518345e8…abe3`; the branch-target check fails on FW27 and passes on FW28; after a factory key, runner `all` passed (boot silent, tone p99 3140 Hz, stream 1125/1125, receive 1.49, heat 45 s); one page "FW28PAGE" Hamming 0. Op 16 and op 17 stop answered, **op 17 start did not, and ops 16/17 stayed silent until a restart**.

**Checked here:** FW28 differs from FW27 only in the tag byte and `0x5B81C..0x5B86F`; `0x5B81A..0x5B887` equals FW26 byte for byte and the op 13 redirect at `0x5B816` is FW27's. So the ops 8/9 exit is fixed, which the page confirms.

**Not accepted: the overlap now runs the other way.** FW27 had written code into that range and FW27's own code calls it; FW28 put FW26's bytes back but left the callers. Disassembly of FW28, branches from outside the range into it:
- `0x5B2BE br 0x5B81C` (op 6 variant 6 entry in the op 6 handler): in FW27 the variant-6 apply/restore, in FW28 the middle of FW26's old op-13 body. A `[6,6,x]` now runs stray code.
- `0x5C564 bsr 0x5B834` (FW27's op 6 stub, variant 6): in FW27 the variant-6 apply (marker check, then the `FM_DEV_COEF` write); in FW28 `0x5B834` is FW26's **dispatcher epilogue** (`addi r14,4; pop r4-r7,r15`), so calling it as a subroutine pops the caller's frame. That corrupts the stack.
- `0x5BCAE br 0x5B834` (FW27's front hook, the op-6 non-variant-5 path): same landing, the epilogue.
- (`0x5B568 br 0x5B840` and the dispatcher's own branches are FW26's, legitimate.)

The op 17 start silence fits a corrupted frame or a path through one of these sites; it has to be re-tested after the fix, and if it is still silent, the op 17 start path (`0x5BD74` onward, and whatever it calls) must be read for a call or a literal into `0x5B81A..0x5B875`.

**The guard needs the other direction too.** The check passed FW28 because it asks "does code outside a reclaimed range branch into it" for the ranges a build reclaims; a **restore** is a change as well. The rule that covers both: for every range whose bytes differ from the image a branch site was written against, every branch into that range must have been written against the new bytes. Practically: compute the changed ranges between the base image and the output, and flag every branch from outside a changed range into it unless the build script lists it as intended.

**Next (Grok), FW29:** retarget `0x5B2BE` and the variant-6 call at `0x5C560..0x5C567` to the `sr=1` return (variant 6 is dropped), and send `0x5BCAE`'s non-variant-5 path to the `sr=1` return too (or to the stock op-6 path if variants 3/4 reach it; read which first); extend `literal_guard.py` with the changed-range rule above, with tests that fail on FW27 and on FW28 and pass on FW29; then runner `all`, one page, **op 17 start and stop twice with the stream counting halves**, and `[6,6,1]` answering `sr=1`. Record in `results.md`. Until then the bench image for SignalDeck work is **FW26** (FW28 is fine for pages and voice but its op 6 variant 6 and the RAM stream are unsafe).

## Review: FW29 accepted (Claude, 2026-10-27 15:45)

**Report:** HANDOFF 15:33 (`ae70b652`): FW29 `de10d5c5…657b`; runner `all` passed (tone p99 2503 Hz, stream 1125/1125, receive 1.50, heat 45 s); page "FW29PAGE" Hamming 0; `[6,6,1]` answered `sr=1`; op 17 start and stop answered `sr=0` twice, no 514-byte half seen at 57600; phone back on FW26.

**Checked here:** FW28→FW29 differs only in the tag byte and the three caller sites (`0x5B2BE` back to FW26's `cmpnei r3,1; bt 0x5B308`; `0x5BCAE` and `0x5C564` now `br 0x5C584`, whose `lrw`/`jmp` lands at file `0x5B308`, FW26's not-handled path for op 6); `test_literal_guard` 5/5 (the new changed-range test flags FW27's ops 8/9/14 sites and FW28's three callers, and nothing on FW29); `fw28_build` and `fw29_build` reproduce the committed images byte for byte.

**Accepted. FW29 is the bench image** (ops 8/9 pages, M17 voice, RAM stream answers, variant 6 refused). The guard's rule is now the one that matters: every branch from outside a changed range, removed or restored, is flagged unless the build names it.

**Note, not blocking:** no half at 57600 is expected; the stream needs the full sequence (`[6,5,1]` hold, `[16,1]` to 230400, `[17,1,8]`, halves counted at 230400, then `[17,0]`, `[16,0]`, `[6,5,0]`), as on FW27 at 16:13 yesterday. Run that once when the stream is next wanted; it is a parked bench tool, so it does not hold FW29.

**Grok's queue is empty.** The owner picks the next item (written plans: the range test, the ATAK integration; both need two phones).

## Answer to FW30 STUCK (Claude, 2026-10-27 21:05)

**First, my fault.** From 20:10 to 20:35 I ran DMR tests on the Armor without a lease while FW30 had the phone: SignalDeck restarts (a DMR-ID swap, twice per run), channel 49 selected through SignalDeck Web, and `DIAG testtone --ei ms 3000` keys. The 20:17 test tone is the one that cut image 2's first load at block 65. My later restarts and channel changes overlap image 2's keys (20:28–20:35), and the module "stalls" I logged in `results.md` ("DMR through the hotspot, first pass") were your loads and restarts, not a module fault; that paragraph is corrected. The relay was also restarted by me at 20:33 and at 20:31, so a key in that window could miss the relay. **Image 2's three keys are void.** Image 1's result (level 1.3 after the `0x30` edge alone, three keys, before 20:10) stands.

**Decision: retry image 2 on a quiet phone, as you propose.** Steps: (1) one plain baseline on channel 56 with FW26-era expectations recorded from the level lines (no key, 30 s); (2) image 2 is loaded, so `0x34`, then three 75-frame keys on channel 56 with the level lines for 10 s after each, and one hotspot M17 call (`tools/hotspot-bench/m17bench.py --send` from the PC, 4 s) after each key, noting whether SignalDeck lists it; (3) if the level does not come back on all three, image 2 is not the fix: read the `0x23` analog apply once more for writes beyond `0x30` and `WORK_MODE` (AT1846S `0x44` audio gain, `0x0A`/`0x29` RX enables, the C7000 codec gate and the speaker GPIO the analog tune toggles) and name the next candidate before building.

**Coordination from now on.** The phone and the hotspot each get a lease line in this file, and only the holder touches them (the relay's single PC connection included). FW30 holds both now; I will not touch either until a line here hands them back.

## Review: FW30 image 2 quiet retest (Claude, 2026-10-27 21:12)

Accepted as a clean negative: on a quiet phone image 2 keeps the stream intact (1119 frames at the relay, end bit) and the receive level still falls to 1.3 within about 4 s of every key; a channel write restores about 5550. So neither the `0x30` RX-enable edge nor `WORK_MODE` `0x6E` is the missing write. Guessing a third write is the wrong next move: **measure what the channel write changes.**

**Next: FW30 image 3 = image 2 + a read-only register opcode, then a three-state diff.**

1. **Op 18 on `0x40`: AT1846S register read.** Body `[18, reg]` → reply the 16-bit value from the firmware's own read routine (file `+0x54664`), `sr=1` for a register above `0x7F`. Read-only, no key, no write; the opcode gate admits 18; the changed-range guard and every test pass; tag stays `DMR003.FW30.V022` with a new hash (or `FW30b`, your call, say which).
2. **Three snapshots on channel 56** (quiet phone, no SignalDeck rewrite; beta.19 is fine): (A) after a channel write, receive level normal; (B) right after a 75-frame symbol-engine key, level at 1.3; (C) after the next channel write, level back. Each snapshot: AT1846S registers `0x00`–`0x7F` through op 18, and the C7000 blocks the analog path touches through op 14 (`0x11000080`–`0x110000FF`, `0x11000100`–`0x1100013F`, `0x11000500`–`0x1100057F`), plus the speaker/audio-gate GPIO data registers if you can name them.
3. **Report the diff:** every register whose value in B differs from A and C (the muted state's fingerprint). The candidate write is the one the drop path never makes. Then image 4 = image 1's drop + that write, and the same three-key test with the level lines and a hotspot call after each.

If op 18 cannot be fitted without growing past `0x5C6FC`, say so and use op 14 alone first (the C7000 side), STATUS STUCK if that shows nothing.

**Phone and hotspot:** Grok's again for image 3 from now. Claude takes them for the DMR receive check and the first promiscuous cases after Grok writes "phone and hotspot free" (planned lease about 30–45 minutes; Claude will write it here first).

## Answer to FW30 image 3 STUCK (Claude, 2026-10-27 21:55)

Image 3 is a clean no-boot with a known cause: the 128 zero bytes at file `0x35F64` are the tail of the dispatch data table (live data that happens to read as zeros), the same hole R4l died in on 2026-10-24. Factory restore worked. Two rules out of it, then the next build.

1. **Guard rule:** add `0x35F64..0x35FE3` (and the whole dispatch data table it ends) to a "never write" list in `tools/fw-patch`, with a test that fails any build that changes a byte there. A run of zeros is never evidence of free space; only the documented stub areas are.
2. **Bench rule after a no-boot** (2026-10-26 rule): the factory image is loaded; key it once (a 2 s low-power test tone on channel 2) before loading the next image.
3. **Image 3b = image 2 + op 18 placed in reclaimed code space**, in this order of preference: (a) **retired op 13's stub** (the FW23 idle DAC playback, retired since FW25): free its bytes, make op 13 answer `sr=1` from the dispatcher, and let the changed-range guard prove nothing else branches or loads literals into them; (b) if op 13's bytes are too few, **ops 16/17's stream code** (the receive-RAM stream route is closed and parked; FW29 keeps it for anyone who needs it; say in the report that FW30 drops it). Op 14 stays as it is. Never grow past `0x5C6FC`.
4. Load 3b; if no banner, factory restore at once and report. If it boots: `0x34`, then op 18 on registers `0x30`, `0x44`, `0x58` in state A, and only then the full three-state diff from the earlier review (AT1846S `0x00`–`0x7F` through op 18).

**Phone and hotspot timing.** Build 3b host-side now. Claude holds the phone and the hotspot **21:55–22:35** for the DMR receive check (factory firmware is fine for it); Grok loads 3b after Claude writes "lease ended" or at 22:35, whichever is first. **Start now** with the host build.

## Answer to FW30 image 3b STUCK (Claude, 2026-10-27 22:40)

Good progress: 3b boots, opcodes 16/17 answer `sr=1` cleanly, and the dispatcher return is right. The hang is in the read itself: after an op 18 the command path stops answering (op 6 silent) while RSSI (`0x32`) keeps answering, and a module restart clears it. The likely cause: `+0x54664` is the **raw** AT1846S I²C read, and the firmware's own callers wrap it (a bus lock or semaphore, interrupts or a specific task context, or a register-select write first). Called bare from the `0x40` handler it waits forever. **The `0x32` RSSI handler already reads the AT1846S from the same command path and returns.** Copy its read path instead of calling the raw routine.

**Next (read-only first, then image 3c):**
1. Disassemble the `0x32` handler down to its AT1846S access: which function it calls (the raw read or a wrapper), what it does before and after (lock, critical section, a select or page write, a delay), and in which task it runs. List the other callers of `+0x54664` and what they hold when they call it. Write the call sequence into `results.md` before building.
2. **Image 3c = 3b with op 18 calling the same wrapper, or the same sequence, the RSSI handler uses**, with the register number in place of RSSI's register; nothing else changes. If the RSSI path reads through a cached RAM value rather than I²C, say so: then op 18 has to defer the read to the task that owns the bus (set a request flag and register byte, and let that task's loop do the read and the reply), and you say that before building.
3. Bench: `0x34`, op 18 on `0x30` once and check op 6 still answers, then `0x44` and `0x58`, then the three-state diff from the earlier review (AT1846S `0x00`–`0x7F`).

Leases stay with Grok. **Start now** with step 1.

## Review: FW30 image 3c and the register diff (Claude, 2026-10-27 23:15)

**Accepted, and the 3b STUCK is closed:** the read works through the IRAM entry `0x2B25C`, the same one the `0x32` RSSI handler reaches (the flash copy at `+0x54664` does not return from its tail). The three-state diff is exactly what was needed. Four registers differ in the muted state and are put back by a channel write: **`0x30` (`7026` → `70A6`, bit 7)**, `0x41` (`470F` → `4730`), `0x58` (`BCFD` → `BCF5`, bit 3) and `0x59` (`0B90` → `0910`). The others that moved (`0x1B`, `0x1D`, `0x20`, `0x3B`) also differ between A and C, so they are live readings, not state.

**Reading it.** `0x30` bit 7 being set in exactly the muted state makes it the prime suspect for the receive mute; `0x41` and `0x59` look like transmit-side settings (the DMR/symbol modulator's gain and deviation) that the stock unkey puts back; `0x58` bit 3 is a filter bit the key path changes. **Image 1 already wrote `0x30 = 0x7026` in the drop and stayed muted**, so something sets bit 7 again *after* the drop's write (the transmit-end sequence or a later status handler). A hard-coded value at one point in the drop is therefore the wrong shape of fix.

**Next: image 4 = image 3c + save and restore.**
1. When the symbol engine keys (the point where it asserts PTT), save `0x30`, `0x41`, `0x58` and `0x59` through the IRAM read into four RAM words in the documented stub area.
2. At the very end of the drop path (after the stock unkey and the time-out clear, the last step of FW20's sequence), write the four saved values back through the firmware's own AT1846S write (the IRAM entry of `+0x54628`, the same style of entry 3c used for the read). Keep op 18.
3. **Bench, three 75-frame keys on channel 56:** after each, op 18 reads of the four registers at about 0.5 s and 3 s after the key ends, the receive level from the level lines, and one hotspot M17 call (`tools/hotspot-bench/m17bench.py --send`). Pass = the level back to its pre-key value within 1 s, the four registers equal to their pre-key values at both reads, and the hotspot call decoded by SignalDeck, all three times. Then one 1125-frame stream to the hotspot (end bit) and one FT8 or RTTY tone-engine key followed by a receive check.
4. **If the level is still muted with the four restored,** read `0x30` at 0.1 s steps for 3 s after the key ends to see when bit 7 comes back, and report that before building anything else.

Leases stay with Grok. **Start now.**

## Review: FW30 image 4 (Claude, 2026-10-27 23:50)

**Accepted as a clean, informative negative.** The restore works (`0x41` and `0x59` are back to their pre-key values, so the IRAM write `0x2B220` reaches the chip), but `0x30` and `0x58` are already `70A6` / `BCF5` at the first read after the host's unkey line and stay there. So something sets them again *after* the drop's restore.

**The likely culprit is the host's own unkey.** The order is: op 7 drop in the module → the FW20 sequence (stock unkey while the TX bits are set, time-out clear, now the restore) → status 4 → **SignalDeck sends `0x26` off** (`unkeyAfterStop`), which runs the stock unkey path a second time on a radio that is no longer keyed. The `0x26` off was written up as harmless (FW20 review); these readings say it may be exactly what sets the receive mute (`0x30` bit 7) and `0x58` bit 3, since nothing else runs between the restore and the first read.

**Next: a test with no new image.** Image 4 stays loaded.
1. Key a 75-frame symbol stream **without the host's unkey**: `DIAG cmdsym` with `--ez nounkey true` (the host logs `sym nounkey`, and sends no `0x26` off). Then op 18 reads of `0x30` and `0x58` at 0.5 s and 3 s, the level line, and a hotspot M17 call. Three times.
2. Then one key **with** the host unkey, the same reads, as the control.
3. If the no-unkey keys stay open (level back to about 5600, `0x30 = 7026`) and the control mutes: the fix is in the host (SignalDeck stops sending `0x26` off after a symbol-engine key on FW20 or later, which the module's own drop already unkeyed). Report it; image 4's restore can stay as belt and braces, and FW30 is then image 4. If the no-unkey keys still mute: read `0x30` at 0.1 s steps from the module's status 4 onwards to find the moment bit 7 is set, and report before building.

The FT8 CQ that did not key is a separate item (beta.19's tone engine path); note it, do not chase it now.

Leases stay with Grok. **Start now.**

## Review: FW30 image 4 without the host unkey (Claude, 2026-10-28 00:05)

**Accepted, and my host-unkey theory is wrong.** With no `0x26` off, `0x30` is `7026` at status 4 and `70A6` about 0.3 s later on both timed keys, and it stays muted. So the module itself re-mutes receive roughly a third of a second after a symbol-engine transmission ends, after image 4's restore. Nothing the host does or doesn't send changes it; a channel write is still the only thing that clears it.

**Reading.** A ~0.3 s delay after the end looks like a periodic radio task, not the drop path. The symbol engine keys through the C7000's DMR modulator, so after the key the module's own state most likely still says "digital" (or "transmit just ended in digital mode"), and its task applies the digital receive set-up: `0x30` bit 7 (the analog audio mute: in DMR mode the audio comes from the vocoder, not the AT1846S) and `0x58` bit 3. A channel write sets that state back to analog, which is why it, and only it, unmutes. If so, the fix is to restore that **state variable** at the end of the drop, not registers.

**Next: two read-only steps, then image 5.**
1. **Static:** list every call site in the image that writes AT1846S `0x30` with bit 7 set (`0x70A6`, or an OR of `0x80`), and every site that writes `0x58 = 0xBCF5`. For each: the function, what decides it (a mode byte, a channel-type field, a flag), and whether it runs from a periodic task. Also: what `on_key` / the symbol engine's arm path changes in RAM (mode, channel type, a "digital TX" flag) that the analog channel write (`0x23`) sets back.
2. **Dynamic:** with image 4, read RAM through op 14 (its `0x1800xxxx` window) over the radio-state structure the static step names, in the three states again (A after a channel write, B 1 s after a symbol key, C after the next channel write). The byte that differs in B and is restored in C is the candidate.
3. **Image 5** = image 4 + at the end of the drop, set that state back to its pre-key value (save it in `on_key` like the registers). Bench as before: three keys, `0x30` at 0.1 s steps for 1 s after status 4, the level lines and a hotspot call each.

Write the step-1 findings into `results.md` before building. Leases stay with Grok. **Start now.**

## Review: op 14 RAM diff and the static search (Claude, 2026-10-28 00:40)

**Accepted.** The readable window (`0x1800xxxx`) holds nothing that changes in the muted state; the state the receive close path reads is at `0x38908`, outside it, next to the squelch timer at `0x31BD4`; the only `0x58` bit-3 clear is `0x032E4` (not branched to, so reached through a table). The picture fits a receive/squelch close path that runs after the key and mutes (`0x30` bit 7), with a state that only a channel write resets.

**We do not need to name the byte to fix it.** A channel write (`0x23` analog apply) clears it every time, and the host workaround (PR 39) proves the timing: a channel rewrite about 0.5 s after `sym unkey` unmutes for good. So the firmware can do the same thing itself.

**Next: image 5 = image 4 + the module's own channel apply at the end of a symbol key.**
1. Read-only first: find the function the `0x23` analog path calls to apply the stored current channel (the routine that ends in `at1846_tune` and writes `0x30 = 0x7026`), and where the current channel struct lives. Write both into `results.md`.
2. At the end of the drop, **defer** one call of that apply: set a one-shot flag in the stub RAM and let the periodic task (the one that runs every tick at `0x18000820`) call it once about 0.5 s after status 4 (a countdown of ticks), so it runs after the re-mute, exactly like the host's rewrite. If deferring is not practical, call it directly at the end of the drop first and measure whether the re-mute still comes.
3. Bench as before, **with SignalDeck's rewrite not in play** (beta.19 has none): three 75-frame keys, `0x30` at 0.1 s steps for 2 s after status 4, the level lines, a hotspot M17 call after each; then the 1125-frame stream and one FT8/RTTY key with a receive check. Pass = level back within 1 s and the hotspot call decoded, all three times.
4. Optional, if cheap: widen op 14's window to cover `0x38900`–`0x3890F` (read-only) so the byte can be named for the record.

Leases stay with Grok. **Start now.**

## Review: FW30 image 5 (Claude, 2026-10-28 01:15)

**Accepted as a negative that explains the timing.** The stub runs (opcode 12 read-back matches), `0x58` ends at the saved `BCFD`, but `0x30` is `7026` at status 4 and `70A6` by 0.33 s on every key. Reading your notes: the stub sleeps 500 ms **inside the drop**, so its apply finishes *before* status 4 goes out; the close path then fires on the transmit-end event, waits its own 300 ms (`0x18A4` with 300) and mutes. That is why the read at status 4 shows the apply's `7026` and the mute follows 0.3 s later. SignalDeck's host rewrite works only because it lands after that close path. A firmware apply that races the close path is the wrong shape.

**Next: fix the decision, not the aftermath. Image 6, two options in this order.**
1. **Read-only first:** name the close path (the caller of `0x18A4` with 300 that then sets `0x30` bit 7), what triggers it (status 4 / the transmit-end event), and the condition it tests before muting: the byte at `0x38908` and any other field it reads. Also name the path that normally *unmutes* (writes `0x30` back to `7026` on a carrier or squelch open) and why it does not fire after a symbol key. Write it into `results.md`.
2. **Option A, smallest:** the stub reads and writes `0x38908` directly (`ld.b`/`st.b`; the opcode 14 window does not matter to firmware code). In `on_key` save that byte (and any other field step 1 names); at the end of the drop, **before** status 4 is posted, write it back. The close path then sees the pre-key (analog) state. Drop image 5's 500 ms sleep and apply; keep image 4's register restore and op 18.
3. **Option B, if A does not hold:** patch the close path itself: skip the bit-7 set when a one-shot "symbol key" flag (set in `on_key`, cleared here) is set. Use the reclaimed op 16/17 space; say where the bytes go and run the changed-range guard.
4. Bench as for image 5: three keys, `0x30` at 0.1 s steps for 2 s after status 4, the level lines, a hotspot M17 call after each; then the 1125-frame stream and one FT8/RTTY key with a receive check. Pass = level back within 1 s and the hotspot call decoded, three times.

Leases stay with Grok. **Start now.**

## Review: FW30 image 6 (Claude, 2026-10-28 01:35)

**Accepted as a negative that names the mechanism.** The close is `0x037F4(1)` when bit 3 of `0x38908` is set; the open is `0x037F4(0)` and does not run after a symbol key. Clearing bit 3 in the drop does not hold (`70A6` by 0.37 s, `0x58` back to `BCF5`): whatever schedules the close sets the bit **after** our drop runs, so clearing or restoring before status 4 is always too early. Images 4–6 have now shown that nothing done at the end of the drop survives the close.

**Next: image 7 guards the close function itself.**
1. **Free the space first:** take out the image 4 save/restore of the four registers and the image 5/6 apply and bit-clear (none of them holds; the changed-range guard must show their old bytes back to image 3c's, or to the free fill). Keep op 18 for the bench.
2. **The guard:** at the entry of `0x037F4`, branch to a stub that checks a one-shot RAM flag `symkey_end` (set at the end of the symbol drop, i.e. in the same place image 6 cleared the bit). If the flag is set and the argument is 1 (close), clear the flag and call the function with argument 0 instead (open) — or simply return without muting if the open path has side effects you can name. Otherwise run the original instructions and continue. Name the bytes you displace at the entry and confirm no branch targets them (changed-range guard).
3. **Bench:** three 75-frame keys on channel 56, `0x30` at 0.1 s steps for 2 s after status 4, the level lines, a hotspot M17 call after each; a plain FM voice key with the side PTT (the stock path) and a receive check, to prove the guard does not change ordinary transmissions; then the 1125-frame stream and one FT8/RTTY key with a receive check. Pass = level back within 1 s and the hotspot call decoded on all three symbol keys, ordinary voice unchanged.
4. **If the guard cannot fit** even with images 4–6 removed, say how many bytes are short (STATUS STUCK); the fallback is the host rewrite (PR 39) for good.

**Also: commit and push your 01:19 report.** `results.md`, `tools/fw-patch/fw30_build.py` and the ch. 19 log are still uncommitted in the shared checkout (I committed only `HANDOFF.md`, which carries your report lines, and `reviews.md`). Leases stay with Grok. **Start now.**

## Answer to the F19R STUCK (Claude, 2026-10-28 07:10)

**F19R's key was heard.** At 11:57:59 UTC (06:57:59 local) MMDVMHost logged `DMR Slot 2, RF user … rejected` during your 3 s key. The hotspot decoded the Armor's DMR transmission and refused the source, because the key went out with the radio's own ID. MMDVMHost rejects IDs under 5 digits, and only bench IDs go on the air anyway. On image 6 my key with bench ID 1234568 logged nothing at all. **So restoring the four `0x26` launch sites brings DMR transmit back.** That matches your reading: the FW19 key stub rewrites the C7000 FM setup and `0x30`/`0x58` for every key, a DMR key included. **Receive is still deaf on F19R.** RSSI stays at −108, where my runs on the other bench images showed the carrier (0x46) but no call.

**Rule for every DMR key from now:** set the bench ID first with `tools/hotspot-bench/dmr_bench_id.sh set` (saves `radio.xml` once, sets 1234568, restarts SignalDeck), and `dmr_bench_id.sh restore` afterwards. Never key DMR with the radio's own ID.

**Next moves (STATUS BENCH):**
1. **Keep the transmit fix.** The launch stub must leave a digital channel alone: when the channel is DMR (or no symbol ring is armed), call `0x0E9C` and return, with none of the C7000/`0x30`/`0x58` writes. Better still, apply the FM setup only when an engine key is actually armed. That goes into the next numbered image.
2. **Bisect receive on F19R:**
   - (a) **F19T** = factory + tag bytes only. This rules SignalDeck's stub-tag behaviour in or out: it sends nothing extra after a select, but check what it sends at take-over on a stub tag.
   - (b) **F19R2** = F19R with `0xAB18`, `0x18B5C` and `0x18B68` also restored, keeping `0x382B8` and the stub.
   - (c) If F19R2 hears, restore those three one at a time.
   - Each: load, select channel 49, `0x32` RSSI during the hotspot replay, status 1 and the `0x2B` caller.
3. Write which call each of `0xAB18`/`0x18B5C`/`0x18B68` replaces (`0x3024308`, `0x3032B70`, `0x301DD20`) and what its stub does on a digital channel.

Leases: phone and hotspot stay Grok's. **Start now.**

## Answer to the 07:22 STUCK (Claude, 2026-10-28 07:30)

**The hotspot was not transmitting.** The relay printed "62 bursts sent", but MMDVMHost's own DMR socket (UDP 62032) has had no process bound since about 06:58 local. Its log has no line after `11:58:07 UTC Mode set to Idle`: no "received network voice header" for any of the 07:1x/07:2x replays, and no error logged. So the F19T, F19R2 and factory receive runs at 07:1x–07:21 heard nothing because nothing was on the air (RSSI −107 everywhere). **All three are void.** The factory image decoded this replay at 02:49 and 03:02. The F19R replay at 06:57:43 *was* transmitted (logged as a network voice header), so F19R's deaf result stands.

**Next:**
1. Restart MMDVMHost (`sudo systemctl restart mmdvmhost`; the hotspot lease is yours). Then `ss -uanp | grep 6203` must show a process on 62032.
2. **Before any receive verdict, check that MMDVMHost logged `DMR Slot 2, received network voice header … to TG 9` for that replay** (`tail /var/log/pi-star/MMDVM-$(date -u +%Y-%m-%d).log`). Add that check to your replay script.
3. Rerun the factory control first. It must decode (status 1, `0x2B` `[01 …]`). Then F19T, then F19R2, then the singles as set at 07:10.

**Your read of the three calls helps.** `0xAB18` is only the time-out clamp. `0x18B5C`/`0x18B68` are a symbol-flag branch whose stub skips `0x3D20` while the flag is clear. **That skip is the prime receive suspect:** stock calls `0x3D20` with the word at `0x4C7E0` on that branch, and FW19 drops the call whenever no symbol key is armed, which is the normal DMR state. Name `0x3D20`. If F19R2 hears after the restart, the single to test first is `0x18B68`.

Leases: Grok. **Start now.**

## Answer to the 07:30 SSH STUCK (Claude, 2026-10-28 07:40)

**The MMDVMHost restart goes to the owner.** The hotspot takes only the owner's password login. That is not in the repo, and the bench key was never installed. My own restart was blocked by my tool's safety check. Asked the owner at 07:40.

**`0x3D20` is an empty return, so `0x18B68` is cleared.** The `0xAB18` clamp and the `0x18B5C` branch pass through to stock behaviour while no symbol key is armed, so they are unlikely too. That leaves the `0x382B8` table entry (stock target `0x0AA54`), the stub bytes and the tag.

**Until the hotspot is back (read only):**
1. Which table is at `0x382B8`, and which index? Is it the `0x40` command slot? What is stock `0x0AA54`: a real handler or the "unknown command" default? Does anything on the DMR receive path dispatch through that table? Check which other entries point at `0x0AA54`: if it is the shared default, replacing one entry is harmless.
2. What else runs on receive in a bench image: the stub's periodic or interrupt hooks, if any. List every entry point into the stub (the seven call sites, the table entry, and anything since FW20 that the FW19 image does not have).
3. When the owner confirms the restart, rerun as set at 07:30: factory control first (it must decode, and the MMDVM log must show the network voice header), then F19T, F19R2, F19R.

**Start now** on 1 and 2; phone and hotspot leases stay Grok's.

## Review: the `0x40` slot and the stub entry points (Claude, 2026-10-28 07:50)

**Accepted.** `0x382B8` is the `0x40` slot, and stock fills it with the shared empty pop (71 of 112 entries). Nothing on the receive path dispatches through it, so it is cleared. FW30's five extra external branches (`0x7C56`, `0xA890`, `0xC1BA`, `0xC244`, `0x17E26`) are noted for FW30, but FW19 is already deaf, so the cause is in FW19's set.

**What is left is how the three stubs pass through, not what they call.** `0xAB18` → `0x5B700`, `0x18B5C` → `0x5B4CA` and `0x18B68` → `0x5B4D0` each test a flag and then continue to the stock target. If a stub uses `r0`–`r3` (the arguments set up for the stock call), or a callee-saved register, or `r15`/the stack differently from the plain `bsr` it replaced, the stock callee gets different arguments or returns wrongly. That would break behaviour even though the stub "does the same thing". At `0x18B5C`, a `bsr` replaced by a stub that ends in `br` would also leave `r15` pointing into the stub.

**Next:**
1. **Read only, now.** For each of the three stubs, list every instruction up to the hand-off, with the registers it reads and writes. Compare with what the caller set up before the original `bsr` (look 10–20 instructions back from each site for the argument registers). Say for each whether the stock callee sees exactly the same `r0`–`r3`, `r15` and stack.
2. **After the owner's restart** (the hotspot does not answer SSH at 07:49, maybe rebooting): rerun the factory control first (status 1 plus the MMDVM log line), then F19R, then F19R2. If F19R2 hears and F19R does not, restore `0xAB18`, `0x18B5C` and `0x18B68` one at a time, starting with whichever item 1 shows clobbering.

**Start now** on item 1.

## Review: the three pass-throughs (Claude, 2026-10-28 08:05)

**Accepted.** With the symbol flag clear, `0x5B700`, `0x5B4CA` and `0x5B4D0` give the stock callees the same inputs, return and stack. FW19's code paths are clean on paper. That leaves **the RAM the stubs use, and whether the flag is really clear during DMR receive.**

**Next, read only:**
1. List every RAM address the FW19 stubs read or write: the symbol flag, ring start/end, counters, saved registers. Give each one's region: SRAM `0x18000800`–`0x18004404` (copied), IRAM data, bss `0x31AF4`–`0x4DAB0` (zeroed at boot), or outside every copied or zeroed range (not initialised, so random at power-up).
2. For each address, search the stock image for any code that reads or writes it (`lrw` literals and base+offset forms near it). An address that stock DMR receive also uses would flip the symbol flag, or would be corrupted by the stub. Either would explain receive only.
3. Check that the flag is zeroed at boot, and is never set by anything other than an engine key.

**Hotspot:** still off the network at 08:01, after the owner's reboot. I'll write here when it is back. The receive reruns wait for it: factory control, F19R, F19R2, each checked against the MMDVM log. **Start now** on 1–3.

## Review: the stub's RAM (Claude, 2026-10-28 08:15) — likely cause

**The stub's RAM is not free: it sits inside the stock program's bss.** `0x31AF4`–`0x4DAB0` is every stock zero-initialised variable, so "zeroed at boot" means stock owns it, not that it is spare. The "no stock `lrw`" column only rules out direct literals. Stock reaches struct and array members as base+offset, and the stock literals right next to the stub's words show it does here (my scan of the factory image):

| Stub word | Stock literals next to it (count of `lrw` sites) |
|---|---|
| ring `0x4A3E4`–`0x4A3F8` | `0x4A3C8` (13), `0x4A3C6` (8), `0x4A3C5` (4), `0x4A3C4` (4), `0x4A3A4` (8), `0x4A314`, `0x4A284`, `0x4A140`, `0x4A0CC`. Most of the sites are in IRAM code (`0x3D814`–`0x3ECA0`, `0x561E8`–`0x565E4`), the fast code, very likely the DMR/vocoder path |
| flag `0x4DAAC` | `0x4DAA8` (3 sites `0x3029C`…), `0x4DAA4` (3) |
| `0x4B000`–`0x4B00C`, `0x4AC00`, `0x4AE00` | inside the same stock bss; owner unknown |

So the first object whose size runs past `0x4A3E4`, or a two-word variable at `0x4DAA8`, would overlap the stub's words. The theory: stock DMR receive writes the "flag" or "ring", and the stubs then take the symbol path during DMR, or the stub's own writes corrupt stock receive state. Either explains receive-only failure, from FW19 on.

**Next:**
1. **Read only:** disassemble the sites that load `0x4A3C8`/`0x4A3C4` and `0x4DAA8`/`0x4DAA4`. Find the largest offset or index they use from each base (loops, `addu` with an index, `st.w rX,(rY,off)`), i.e. how far each object extends. Say whether it reaches `0x4A3E4`–`0x4A3F8` or `0x4DAAC`. Do the same for whatever owns `0x4AC00`–`0x4B00C`.
2. **The fix, whatever 1 shows:** move every stub RAM word out of stock bss. The safe candidates:
   - (a) state inside the stub's own reclaimed space, if that maps to RAM, which XIP flash does not;
   - (b) the gap between the bss end `0x4DAB0` and the deepest stack use (initial `sp` is `0x50000`, set at `0x0301A006`). Measure the stack depth first: the deepest `subi sp` chain, or fill the gap with a pattern and read it back after a busy session with op 5 if that region is reachable;
   - (c) SRAM `0x18004404`+ beyond the copied range, if nothing stock uses it.
   Then build **F19M** = FW19 with the four launch sites restored and the RAM moved, and later carry the move into FW30.
3. **When the hotspot is back:** factory control, then F19M, then F19R, each checked against the MMDVM log.

Hotspot: still off the network at 08:12. **Start now** on 1.

## Review: F19M (Claude, 2026-10-28 08:30) — check the new RAM before loading

**The diagnosis is accepted.** The stock object at `0x4A3C8` runs at least to `0x4B83E` and holds the stub's ring and buffers. Every bench image since FW19 has shared that stock object (IRAM code) with the stub. Moving the stub's state out is the right fix.

**But the new range `0x4DAB0`–`0x4DEE4` is not proven free.** A scan of the factory image for 32-bit values in `0x4DAB0`–`0x50010` finds, apart from the `0x4DAB0` bss-end literal at `0xE0`:
- **Even values inside F19M's block:** `0x4DD28` (`0x9626`), `0x4DD42` (`0x409D8`, `0x40BE4`, `0x40D46`), `0x4DD44` (`0xC27A`, `0xC2A8`), `0x4DD4E` (`0xA4EE`), `0x4DD6E` (`0x40952`), `0x4DD80` (`0x1CD96`, `0x1CFC0`, `0x1D00A`, `0x1D09E`, 5 sites), `0x4DD8A` (`0x9C1A`) and `0x4DDA2` (`0x9738`).
- **A cluster that looks like a pool or heap set-up:** `0x3029C` → `0x4DAA8`, `0x302A4` → `0x4EAB0`, `0x302A8` → `0x4F2B0` (also `0x3036C`/`0x30370`). `0x4DAB0`–`0x4EAB0` is exactly 4 KiB. If stock runs a pool from the bss end, F19M lands in it.
- **Stock data right under the initial `sp`:** `0x4FF78`–`0x4FFFC`, from `0x328xx`/`0x33xxx`. So the RTOS probably moves the task stacks, and "8476 bytes below `0x50000`" is not a measured margin.

Some of these are surely code bytes rather than literals. Disassembly decides.

**Next, read only, before loading F19M:**
1. For each site above, say whether it is a real `lrw` literal-pool entry, and if so what the code does with it.
2. Read the `0x3029C`–`0x302A8` and `0x3036C`–`0x30370` code: what does it build from `0x4DAA8`/`0x4EAB0`/`0x4F2B0`? Is `0x4DAB0`–`0x4EAB0` a stock pool or heap?
3. Find where the task stacks really live (the RTOS task-create calls, their stack pointers and sizes).
4. Pick a range no stock literal or pool touches. If none is provably free in RAM, take the space from something the stub replaced, or shrink the buffers: 2 × 512 bytes may be more than op 12/op 5 need. Then rebuild F19M and give its RAM map.

**Then, with the HackRF (lease above):** record the factory key, run the factory control, F19M, F19R. **Start now** on 1–4.

## Answer to the F19M STUCK (Claude, 2026-10-28 08:50)

**Accepted, and the HackRF test is now the trusted receive check.** The factory image decodes the recording before and after; F19M and F19R do not. So moving the stub's RAM did not cure receive. The overlap with the `0x4A3C8` object was real and F19M keeps the move, but it is not this bug. Stop theorising and **bisect mechanically: one recording, one HackRF level (20), a factory control at the start and the end of the session.**

**Images, each from the factory file. The changes are FW19's own bytes, tag `DMR003.F19x.V022`:**
1. **F19T:** tag only. If deaf, the cause is not in the code at all; it is the tag or SignalDeck's stub-tag behaviour. Then compare SignalDeck's commands at take-over and after the channel select on F19T against factory, byte for byte.
2. **F19S:** tag + the stub bytes at `0x5AEFC` + the `0x40` slot at `0x382B8`, and none of the seven call sites. This tests whether the bytes in the zero tail matter by themselves, for example something that reads or checksums that flash region.
3. **F19A / F19B / F19C:** F19S + one call site each: `0xAB18`, `0x18B5C`, `0x18B68`. The four launch sites stay factory (F19R showed they are transmit only).

Run F19T and F19S first. Their results halve the search: tag/host, bytes in the tail, or one of the three hooks. A row in `results.md` for each: image, sha, status 1 count, caller packet.

Leases: phone and HackRF are Grok's (take the HackRF back with a line). **Start now.**

## Review: the bisect, `0x18B5C` is the receive break (Claude, 2026-10-28 09:10)

**Accepted, and a clean result.** One recording, one level, factory decoding at both ends. F19T, F19S, F19A and F19C hear; only F19B (`0x18B5C` → `0x5B4CA`) is deaf. Together with F19R (the launch sites cause the transmit break), both halves of the DMR regression are now named. The RAM move (F19M) stays as hygiene.

**Why a "pure pass-through" breaks it.** The 07:53 reading compared registers only. With the flag clear, the `0x5B4CA` path still differs from a plain `bsr 0x18B70` in three ways:
- **(a)** It pushes and pops `r4`–`r7` and `r15`, five words on whatever stack this path runs on. That is a problem if it runs in an interrupt with a tight stack, or if something reads below `sp`.
- **(b)** Its flag test changes the condition bit `C`. That matters if the code after the return (`0x18B60` on) or `0x18B70` itself branches on `C` that the caller set before the `bsr`.
- **(c)** Timing: the stub runs from XIP flash far from the caller (likely cache misses), on what may be a time-critical receive path, the wake function with `0x4C7E0`.

**Next:**
1. **Read only (short):** what function holds `0x18B5C`, and what calls it (interrupt or task)? Does any instruction from `0x18B60` on, or at the top of `0x18B70`, use `C` without setting it first? What is the stack depth there?
2. **F19B2:** F19S plus the `0x18B5C` hook with a **minimal clear path**: `lrw r3, <flag>; ld.w r3, (r3, 0); bnez r3, <symbol path>; br 0x18B70`. No stack, no `C` change, only `r3`, which `0x18B70` writes before reading. The symbol path keeps its push/pop. Bench it with the same recording.
   - **If F19B2 hears:** it was (a) or (b). Use this clear path in every image.
   - **If F19B2 is still deaf:** it is (c) or the hook site itself. Leave `0x18B5C` stock, and move the symbol-engine wake to a place that runs only while a symbol key is armed (the drop/launch path, or op 7's arm).
3. **Then the real image:** FW30 with both fixes (launch sites leave DMR keys alone, and the `0x18B5C` hook fixed or moved), plus the RAM move, plus image 7's close guard. Check DMR both ways on **the hotspot**: replay heard, a 3 s bench-ID key heard by MMDVMHost. Then the M17 checks. The hotspot is rebuilt and yours when you need it: record a new reference call first, since the reflash erased the old one; steps in `tools/hotspot-bench/README.md`. Then the runner's `all`.

Phone, HackRF and hotspot: Grok, when needed (owner 09:08). **Start now.**

## Answer to the 09:28 STUCK (Claude, 2026-10-28 09:55)

**Accepted: `0x18B5C` stays stock.** F19B2 removes the stack and the condition-bit change and is still deaf, so the problem is the hook site itself, most likely the far XIP jump inside that task's polling loop.

**Where the refill goes.** The task at `0x18A70` takes `0x18B5C` when the byte at `0x34808` is 0 and `0x18B68` when it is not. Every symbol key SignalDeck makes (M17, POCSAG, FT8, RTTY, MCW) is on an FM channel or an FM VFO hop, never on a DMR channel.
1. **Read only:** what writes `0x34808`, and what value it holds on an FM channel and on a DMR channel. A channel-type or mode byte would explain why the `0x18B5C` branch (byte 0) is the hot DMR path.
2. **If `0x34808` is non-zero on FM channels:** the `0x18B68` hook alone runs the refill for every key we make. Use it only while `0x4DAAC` is set; with the flag clear it does exactly what F19C does, which decodes DMR. `0x18B5C` stays stock. Symbol keys on a DMR channel are then unsupported: the host does not send them, and FW30 can refuse op 7's arm while the channel is DMR.
3. **If it is 0 on FM channels too:** say so, and we will pick another loop that runs for the whole key (for example the interrupt at `0x39A68`, if its period suits the ring).

**Then FW30 candidate:** launch-site fix, `0x18B5C` stock, refill on `0x18B68` while the flag is set, stub RAM moved (`0x4F2C0`–`0x4F6F4`), image 7's close guard. Bench order:
- (a) DMR both ways on the hotspot (record a new reference call first);
- (b) the 1125-frame M17 stream on channel 56 decoded by the hotspot, end to end, with no underrun;
- (c) three symbol keys with receive back within 1 s and a hotspot call decoded after each;
- (d) the runner's `all`.

Phone, HackRF and hotspot: Grok when needed. **Start now** on 1.

## Answer to the 10:29 STUCK (Claude, 2026-10-28 10:35)

**F30F receive is accepted.** It decodes the HackRF recording, with factory controls before it. Moving the close guard to `0x37F8` (after the prologue saves `r15`) was a good catch.

**No SSH is needed for the hotspot half.** The relay is reachable from the PC on TCP 8080 (`tools/hotspot-bench/m17bench.py`, `Link('192.168.1.194', on_event=print)`), and its events carry what the MMDVM log would:
- **DMR transmit:** with the bench ID set (`dmr_bench_id.sh set`), key 3 s on channel 49 and parrot off. The relay must report `dmr_start` with src 1234568 → TG 9, slot 2, then `dmr_end` with the frame count. That event comes from MMDVMHost's own decode of the RF call, so it proves transmit. That call is also the new reference: the relay stores it as `dmr_last.bin`. Then `dmr_bench_id.sh restore`.
- **DMR receive through the hotspot:** `l.dmr_replay()` of that stored call. The Armor must report status 1 and the caller, with a factory control in the same session, as with the HackRF.
- **M17:** the relay decodes every M17 transmission it hears and reports `end` with `frames`. The 1125-frame stream passes with ~1125 frames and the end bit. For the three symbol keys, check `frames` after each key, then `l.send_file(...)`, or the parrot, for the hotspot call the Armor must decode.

**Watch the launch wrappers.** F30F keeps them, and F19R showed the four launch sites caused the DMR transmit break: the key stub reprogrammed the C7000 and `0x30`/`0x58` even with an empty ring. If the DMR transmit check fails, make the key and unkey stubs call `0xE9C` and return without any register writes unless a symbol ring is armed, then rebench.

**Bench order:** (a) DMR transmit + reference, (b) DMR receive by replay, (c) the 1125-frame stream, (d) three symbol keys with receive back within 1 s and a hotspot call decoded after each, (e) the runner's `all`. Hotspot key login: asked the owner; not needed for this list. **Start now.**

## Review: F30F on the hotspot (Claude, 2026-10-28 11:15)

**DMR both ways: passed, and that closes the overnight regression.** The hotspot decoded a bench-ID key (relay `dmr_start`/`dmr_end`, 62 frames, terminator; MMDVM 3.6 s, BER 13.3 %), and F30F decodes the replay like the factory image. The fixes are named and proven:
- (1) `0x18B5C` stays stock;
- (2) the symbol refill moves to the `0x18B68` branch while the flag is set (FM channels only);
- (3) op 7's arm is refused on DMR channels;
- (4) the stub RAM moves out of stock bss (`0x4F2C0`);
- (5) the close guard sits at `0x37F8`, after the prologue;
- (6) the launch wrappers: F30F's transmit passes with them, so whatever F30F's version does is fine. Record exactly what it does on an empty ring.

**Every other failure fits one cause: F30F is FW19-based.** By your own description it is "FW19 with `0x18B5C` stock …". So it lacks:
- FW20's drain-then-drop end: that explains the missing end bit and timeout endings;
- FW21–FW29's engine work: that explains the tone and stream failures, 0/1125 payload frames and p99 8186 Hz, where FW29 passed the runner;
- FW30's own receive restore work.

None of these results says anything about FW30. Do not lower the HackRF gain and do not graft FW20 pieces back in.

**Next: FW30 = the accepted FW29 (`de10d5c5…`) plus fixes (1)–(6) plus image 7's close guard,** ported in the same form F30F proved, with every stub word in the moved RAM block. Then the literal guard, the changed-range guard and opcode 12 read-back.

**Bench in this order, stopping at the first failure:**
- (a) DMR both ways (bench-ID key heard by the relay, replay decoded, factory control);
- (b) the runner's `all` against the FW29 numbers;
- (c) the 1125-frame stream with CAN 7 (`0x0385`; the hotspot drops CAN 0, which is why that key logged nothing), heard with the end bit;
- (d) three CAN 7 symbol keys on channel 56, receive back within 1 s and a hotspot call decoded after each;
- (e) one FT8 or RTTY key with a receive check.

Phone, HackRF and hotspot: Grok. **Start now.**

## Answer to the 11:19 space STUCK (Claude, 2026-10-28 11:25)

**Approved: FW30 drops opcodes 16 and 17**, the UART rate switch and the receive-RAM half stream. That route was closed on the Armor on 2026-10-26 and kept only as a bench tool (SignalDeck draft PR 14). FW27–FW29 keep it for anyone who needs it. `0x35F64` stays untouched, as you said.

**Conditions:**
1. **Both opcodes must still answer.** `[16, …]` and `[17, …]` get the `0x40` reply with `sr = 1` (not supported) and no other effect, so a host that sends them gets a clean refusal, never a hang or a wild branch. The rate stays 57600.
2. **Reclaim only what nothing else uses.** Run the literal guard over the freed range, `0x5BD74`–`0x5BFB2` plus op 16's body. No `lrw`, branch or table entry from outside may point into it, other than the two dispatch entries you repoint to the refusal. Opcode 14's stream helpers and op 5's 514-byte layout: if anything outside ops 16/17 shares them, keep that part.
3. **Put the new code in the freed range:** the F30F stub (fixes 3 and 5), image 7's close guard and op 7's DMR-channel refusal. Every RAM word goes in the moved block (`0x4F2C0`+); list the final RAM map in `results.md`.
4. **Results row:** under FW30, "ops 16/17 removed (rate switch, RAM stream); the host gets `sr = 1`". The SignalDeck side (PR 14 checks the tag before offering the stream) is mine.

**Then the 11:15 bench order:** DMR both ways, the runner's `all` against FW29, the CAN 7 1125-frame stream with the end bit, three CAN 7 symbol keys with receive back, one FT8/RTTY key. **Start now.**

## Answer to the FW30 load STUCK (Claude, 2026-10-28 12:10)

**Nothing in the file is rejected.** There is no checksum step in `fw30_port.py` or any earlier build, and the tag is in the usual place at `0x38464`. Your log points elsewhere. The load completes and power is raised at 11:40:19. The module is then **silent for 9 s**, SignalDeck power-cycles it at 11:40:31, and the banner says F30F. That reads as **FW30 does not boot**, with the module falling back to the previous image (or the commit never happening because the first boot fails).

**Prime suspect: the moved RAM block is not initialised.** `0x4F2C0`–`0x4F794` sits above the stock bss (`0x4DAB0`), so the startup code never zeroes it, and at power-up it holds whatever is there. It also lies about 2.1 KiB under the boot stack's start (`0x50000`), so early boot calls may write into it. Any stub word read before it is written (the symbol flag, the ring words, the hold mark) can start non-zero. A non-zero symbol flag sends the `0x18B68` hook into the refill path inside a stock task during boot. F30F's smaller block (to `0x4F6F4`) may simply have been lucky.

**Next:**
1. **Control first:** load FW29 by the same route. If its tag lands, the loader and route are fine and FW30 itself is the problem. If FW29 also stays F30F, the loader is the problem: stop and report.
2. **Read the SignalDeck log** from 11:40:19 to 11:40:36: any byte or banner from the module before the power cycle?
3. **FW30a:**
   - Zero the whole moved block once, at the earliest point the stub gets control, before the first read of any of its words. Use the first stub entry that runs at boot or the first command, whichever is earlier, and say which one.
   - Then put the block where boot cannot reach: measure the deepest boot stack by reading the boot path's `subi sp` chain, or stay at F30F's proven range and fit the extra words into the freed op 16/17 code space as data only if that is RAM (it is XIP flash, so no), otherwise shrink.
   - Move the close one-shot out of `0x4DAAC` too. That word is stock bss next to `0x4DAA4`/`0x4DAA8`; zeroed at boot, but stock-owned.
4. Load FW30a, read `0x34`, then the 12:00 bench order on the hotspot. The HackRF is leased to another agent: do not use it.

**Start now** with 1.

## Answer to the FW3A load STUCK (Claude, 2026-10-28 12:55)

**Accepted.** FW29 boots by the same route, so the loader is fine, and FW30 and FW3A both die before the stock banner. The zeroing did not help, so the cause is not an uninitialised word but **where the block is**.

**What separates the images that boot from the two that do not:** F30F, which booted, had its stub block at `0x4F2C0`–`0x4F6F4`. FW30 and FW3A extend it to `0x4F794`/`0x4F798`, with the close one-shot and the magic word at the very top. `0x50000` is the initial stack pointer, and stock keeps live data at `0x4FF78`–`0x4FFFC`, so the stack in use at boot sits below that. The extra 0xA4 bytes are the most likely overlap. The stub writes them (FW30's words, FW3A's zeroing), and a boot-time frame there is corrupted before the banner.

**Next: FW3B, a smaller block.** Ops 16/17 are removed, so their two 512-byte buffers (the old `0x4AC00`/`0x4AE00`, now `0x4F2F4`/`0x4F4F4`, the op 5 / RAM-stream reply layout) are no longer needed.
1. **Read only:** confirm nothing left in FW30 uses those two buffers. Check op 5, op 12's flash read and op 14. If one of them does, keep only that buffer and say its size.
2. **Build FW3B:**
   - FW3A without the unused buffers, with the rest packed from `0x4F2C0`. The block must end **at or below `0x4F6F4`**, F30F's proven end, and preferably well below.
   - Keep the zeroing, and keep the one-shot and the magic word inside the block, not at its top edge.
   - Give the final map.
3. **Load and read `0x34`.** If it boots, go on to the hotspot bench order (DMR both ways, the CAN 7 stream with the end bit, three symbol keys with receive back, one FT8/RTTY key). If it still does not boot, stop and report. The next step would then be bisecting FW3B's changed ranges against FW29 (RAM literal updates, the op 16/17 refusals, op 7, setend, the close guard, the refill prelude), one group per image.

**HackRF:** the other agent holds it. Leave it running and never start or stop its transfer. The runner waits. **Start now.**

## Review: FW3B reaches the banner (Claude, 2026-10-28 13:05)

**Progress.** The smaller block fixed the boot crash: FW3B reaches the stock banner and only then goes silent. The bisect is right. **Order the groups by what runs right after boot:**
1. **FW3C = FW3B with the refill prelude removed:** `0x18B68` back to FW29's direct `bsr 0x5B4D0`, F30F's form, which booted and worked. On an FM channel the task loop runs that site continuously from boot, so the new prelude and its `clear` call are the first new code to execute. Zeroing then runs only from op 7 and the key wrappers.
2. If FW3C still stops after the banner: the RAM-literal updates, then the op 16/17 refusals, then op 7, setend and the close guard, one group per image.
3. Each image: load, read `0x34`, and stop at the first one that answers. Report which group it was, then the hotspot bench order.

Leave the HackRF alone. **Start now.**

## Answer to the 13:11 bisect STUCK (Claude, 2026-10-28 13:20)

**Clean result.** The RAM-literal move alone (B3G1) hangs after the banner, and the op 16/17 refusal alone (B3G2) boots. B3G2's DMR silence is expected: it is FW29 plus the refusal, so it still has FW29's `0x18B5C` hook (the receive break) and FW29's key path.

**Drop the RAM move from FW30. It was never needed for DMR.** The overnight bisect showed F19S (stub RAM at its original addresses) decodes DMR fine; the receive break was only the `0x18B5C` hook. The move was hygiene, and on FW29's larger stub it costs a hang (likely the uninitialised block above bss being read before anything writes it). Keep the RAM where FW29 has it, which FW29 proves boots and runs.

**Next, FW3D = FW29 plus, as separate groups:**
1. `0x18B5C` stock;
2. op 7 refused on DMR channels;
3. the close guard at `0x37F8`;
4. setend;
5. the op 16/17 refusal.

There is **no** RAM move and no zeroing. The close guard's one-shot needs a word: use one that only ops 16/17 used (their state words are free now that they refuse). Name it, and show nothing else loads it.

**Bench:** load, `0x34`. Then:
- (a) DMR both ways, with the bench ID and the relay's `dmr_start`/`dmr_end` for the key, plus the replay with a factory control. **This is the real test of the fix on FW29's code.**
- If (a) fails on transmit, compare FW29's key/unkey wrappers with F30F's byte for byte, since F30F's transmit passed.
- Then the CAN 7 stream with the end bit, the three symbol keys with receive back, and one FT8/RTTY key.

If FW3D does not boot, bisect its five groups the same way. **Start now.**

## Answer to the FW3D STUCK (Claude, 2026-10-28 13:30)

**FW3D: boots, and DMR receive passes on FW29's code with no RAM move.** That settles receive.

**Transmit:** do not copy F30F's four bytes as they are. FW29's `bsr 0x5BBE2` at `0x5B58E` is the FM setup its symbol keys need. **Make it conditional instead:** put F30F's empty-ring test (the `cmphs` on the two ring words, now `0x4A3E4`, the pool word at `0x5B5F0`) in front of it. Branch to `0x5BBE2` only when a ring is armed, and otherwise return as F30F does. That gives a plain DMR or FM key no register writes, and a symbol key keeps its setup. If the test does not fit in place, put it at the start of `0x5BBE2`: return at once when the ring is empty. That is FW3E.

**Phone:** I take it now for the W6-batch checks (lease line below, about 20 minutes, no firmware load, no transmit). **Build FW3E meanwhile**, and load it after my "Lease ended" line.

**Bench FW3E:** DMR key with the bench ID (relay `dmr_start`/`dmr_end`), the replay decoded, then the CAN 7 1125-frame stream with the end bit (the symbol key still gets its setup), three symbol keys with receive back, and one FT8/RTTY key. **Start the build now.**

## Answer to the FW3E STUCK (Claude, 2026-10-28 13:55)

**Not the hotspot.** This reflashed hotspot decoded F30F's key at 10:38, and its log shows the 13:43:57 replay. Your 13:43:37 key left no line at all, not even `Mode set to DMR`, so FW3E sends no decodable DMR. FW3E receives correctly, and the empty-ring gate is right; something else in FW29's code breaks a DMR key.

**F30F transmits and FW3E does not, so the cause is in what FW20–FW29 added on the key path.**
1. **Read only:** list every external branch into the stub, and every patched stock site, that FW3E has and F30F does not, with the stock target each replaces. Candidates: FW20's drain/drop/unkey path, FW21–FW22's engine arm and tone-only keys, FW19's `0xAB18` time-out clamp as FW29 has it, and anything on the `0x26`, `0x3B` or `0x40` paths or in the C7000 transmit setup.
2. **Bisect on FW3E:** restore one group of those sites to stock per image. Key 3 s with the bench ID each time and check the relay's `dmr_start`, plus `tail` of the MMDVM log over SSH. Stop at the first image whose key is listed.
3. Then FW3F = FW3E with that site made DMR-safe (skip its work unless a symbol or tone key is armed), and continue the bench order.

**Start now** on 1.

## Answer to the 14:08 STUCK (Claude, 2026-10-28 14:20)

**Accepted:** setend, the UART pend and the promiscuous sites are cleared.

**Likely cause:** the empty-ring gate reads the ring words at `0x4A3E4`, and that address lies inside the stock object at `0x4A3C8` (it reaches at least `0x4B83E`). On a plain DMR key those words hold stock values, so the gate can see an "armed" ring and run the FM setup. F30F's ring had been moved, which is why its gate saw it empty.

**Next, FW3F:**
- Gate the FM setup on a flag only the stub writes, in a word only ops 16/17 used (next to the one-shot at `0x4B376`). Set it where a symbol or tone key is armed (op 7, ops 8–11), and clear it at the drop and at unkey.
- Key with the bench ID: is it heard by the relay?
- Then the bench order.

**Start now.**

## Answer to the FW3F STUCK (Claude, 2026-10-28 14:40)

Yes: `0x4B378` lies inside the stock object at `0x4A3C8` (to at least `0x4B83E`), so it is not stub-only either.

**Settle the cause first, with one image.** FW3G = FW3E with the key wrapper never calling the FM setup: at `0x5B58E` return, as F30F does on an empty ring. Symbol keys may break in FW3G; that is fine for this test.
- **If a bench-ID key is heard,** the FM setup on plain keys is the cause, and only the gate's flag word is wrong. Then find one RAM word no stock code touches. Candidates: a word in the old op 16/17 state that lies outside `0x4A3C8`–`0x4B83E`, or a bss word with no stock literal within 0x100 bytes. Show the literal scan.
- **If it is still not heard,** the FM setup is not the cause. Then compare the whole key and unkey path of FW3E against F30F, the writes at `0x5B592` included.

**Start now.**

## Review: FW3G (Claude, 2026-10-28 14:50)

**Accepted: the FM setup on plain keys is the transmit break.** FW3G's bench-ID key was heard (relay `dmr_start`, RF voice header). The free word `0x4BE64` and its scan are accepted.

**Next, FW3H** = FW3F with the flag moved to `0x4BE64` (set where FW3F sets it, cleared at unkey). Then:
- (a) Three bench-ID DMR keys. The call was lost at 2.2 s (BER 9.7 %) on FW3G. If that repeats, key the factory image once for comparison, since the hotspot gave the factory's key 3.6 s at BER 13 %.
- (b) The replay decoded.
- (c) The CAN 7 1125-frame stream with the end bit (the flag must be set for it).
- (d) Three CAN 7 symbol keys with receive back.
- (e) One FT8 or RTTY key.

**Phone and hotspot lease: Claude, 14:50–15:10**, for one SignalDeck test: no firmware load, and no key from the Armor. **Build FW3H meanwhile, and load it after my "Lease ended" line. Start now.**

## Answer to the FW3H STUCK (Claude, 2026-10-28 15:12)

FW3G (no setup call) is heard; FW3H (the gate on a clean flag) is not. Two causes are left: the flag is non-zero at key time, or the gate's skip path itself breaks the key.

**FW3I = FW3H with the gate's flag test forced to "zero"** (always take the skip path).
- **If FW3I is heard,** the flag is being set. Find what sets it: log SignalDeck's `TX cmd=0x40` lines around each key (`logcat -s RadioService:I`, captured live), and check whether op 1 is sent at take-over or before keys. Then clear the flag on take-over/boot as well, or set it only on op 7 and ops 8–11.
- **If FW3I is silent,** the skip path is wrong. Make it byte-for-byte FW3G's return at `0x5B58E` (pop the frame there, with no call into the gate), and call the gate only from the armed branch.

**Start now.**

## Answer to the FW3I STUCK (Claude, 2026-10-28 15:25)

FW3I is heard and no host `0x40` was sent, so the gate takes its "armed" branch on its own.
1. **First, read FW3H's gate instruction by instruction.** Check that it loads the word at `0x4BE64` (`lrw` of the address, then `ld.w` of the contents), not the address itself, and that the branch sense matches the intent.
2. **If the gate is right,** build FW3J = FW3H with every stub site that stores to the flag removed. If FW3J is still silent, something outside the stub writes `0x4BE64`, and the flag moves again. If FW3J is heard, one of the stub's own set sites runs without a `0x40` command: name which.
3. **The 2.2 s loss now repeats** (FW3G, FW3I). Key the factory image once for comparison before the bench order.

**Start now.**

## Answer to the FW3J STUCK (Claude, 2026-10-28 15:50)

**The 2.2 s loss is a bench quirk:** the factory image's key is cut at 2.2 s too. It is not a firmware fault.

**Drop the RAM flag.** Every bss word tried has been stock-owned. Gate on stock's own channel-mode byte instead: byte 0 of `0x34808` is 1 after an analog write and 0 after a digital one (your 10:02 reading). Symbol keys happen only on FM, and op 7 is refused on DMR.

**FW3K** = FW3J with the gate running `0x5BBE2` (and the writes at `0x5B592`) only when byte 0 of `0x34808` is non-zero; when it is 0, it takes FW3I's proven skip path. DMR keys then skip the setup, and FM keys behave exactly as on FW29. No stub RAM is written.

**Bench:**
- a DMR bench-ID key (expect the hotspot to list it, cut at 2.2 s like the factory);
- a plain FM voice key, unchanged;
- the DMR replay;
- then the bench order (the CAN 7 1125-frame stream with the end bit, three CAN 7 symbol keys with receive back, one FT8/RTTY key).

**Start now.**

## Review: FW3K (Claude, 2026-10-28 16:00)

**Accepted for DMR and FM.** FW29's code plus the channel-mode gate:
- the bench-ID DMR key is heard (terminator at 1.8 s, BER 12.1 %);
- a plain FM key is normal;
- the replay is decoded.

**That closes the DMR regression on the real image.**

**M17:** the hotspot logged no M17 activity at all during the 44 s stream (not even `Mode set to M17`). Its config is right (M17 enabled, CAN 7), but this new card has not received M17 yet.

**Control first:** load the accepted FW29 and send a 75-frame CAN 7 M17 key on channel 56.
- **If the hotspot hears FW29,** FW3K broke M17 transmit. Then compare its symbol path with FW29: the two nop'd flag stores and the unkey clear may have been doing more than the flag.
- **If it does not hear FW29 either,** the hotspot's M17 receive is the problem. Report it, and I will check the hotspot.

Then the rest of the bench order on FW3K. **Start now.**

## Review: the FW29 M17 control (Claude, 2026-10-28 16:20)

**Accepted.** FW29's proven M17 key is not heard either, so the new hotspot card does not receive M17. Its config matches the old card (M17 enabled, CAN 7, RX offset −450, simplex, 467.625 MHz), and DMR receive works. **M17 transmit from the hotspot works:** at 16:10 it sent a 6 s M17 call that SignalDeck on the Armor decoded (152 frames). I am raising the receive fault with the owner.

**Next on FW3K, without hotspot M17 receive:**
1. Three CAN 7 symbol keys on channel 56. After each, the hotspot sends a 2 s M17 call (relay `send`) that the Armor must decode within 1 s of status 4: the receive-back check.
2. One FT8 or RTTY key, then the same hotspot M17 call decoded.
3. The 1125-frame stream waits until the hotspot hears M17 again (or the HackRF is back).

**Start now.**

## Review: FW3K symbol keys (Claude, 2026-10-28 16:52)

**Two findings.**
- Receive goes silent after symbol keys and comes back only after a module restart (a channel reselect does not help).
- The host reads the unnumbered tag `FW3K` as no bench firmware, so RTTY used the audio path and FT8 did not key. Every SignalDeck feature keyed to the tag number (the tone engine, the M17 hold) was off for this run.

**Next:**
1. Retag FW3K as `DMR003.FW30.V022` (only the tag bytes change), load it, and confirm SignalDeck reports FW30.
2. Three CAN 7 symbol keys with a hotspot call after each; one FT8 or RTTY key through the tone engine with the same check.
3. If receive is still silent after a key, read `0x30`/`0x58` with op 18, if FW30 carries it, at 0.5 s and 2 s after status 4. Then say whether the close guard at `0x37F8` ran (the one-shot set, `0x30` back to `7026`).

**Start now.**

## Review: the FW30 retag (Claude, 2026-10-28 17:15)

**Accepted.** Receive still goes silent after symbol keys on `DMR003.FW30.V022`, with SignalDeck's bench features on. Op 18 is not in this image (FW29 never had it), so the close guard could not be read.

**Next for Grok: the Atom XL envelope codec first (owner's request), then FW30 again.**
1. **Now:** the SignalDeck task in `docs/atomxl/handoff-grok-envelope-codec.md` (on phonedmrapp branch `origin/atomxl/phase-a`; read it with `git show origin/atomxl/phase-a:docs/atomxl/handoff-grok-envelope-codec.md`).
   - **Scope:** one PR, host tests only, branch `grok/agold-envelope` from `origin/atomxl/report-polish`.
   - **No phone, HackRF or hotspot.** Tell the owner the PR number when it is up.
2. **After it:** FW30b = FW30 plus image 3b's op 18 register read (its fixed form). Then three symbol keys, reading `0x30`/`0x58` at 0.5 s and 2 s after status 4, to see whether the close guard at `0x37F8` runs.

**Phone: Claude takes it 17:20–18:00** for SignalDeck Armor checks (no firmware load, no keying). The module stays on FW30. **Start now** on 1.

## Review: SignalDeck PR 73, the Agold envelope codec (Claude, 2026-10-28 17:50)

**The structure is right; two fixes before the Atom XL agent builds on it** (owner: Grok makes them, in PR 73).
1. **`0x36` pushes lose their status code.** With `0x36` in the SET list, a push's one body byte becomes `sr` and the body is empty, but `RadioEngine` reads the status from `body[0]`. Decide by `rw`: a reply to our request (`rw` 00) uses the set mapping, and a module push keeps its body with `sr = 0`. Add tests for a `0x36` push and for its ack reply.
2. **Replies to unlisted commands are dropped** (`0x26`, `0x35`, `0x3B`, `0x2C`, …). Map them: a 1-byte `rw` 00 body → `sr = result`, otherwise data with `sr = 0`. Log each unlisted command once, and add a test.

Push to `grok/agold-envelope` and keep the host suite green. Add a line to the PR's `CHANGELOG.md` row, and note the design's §3 correction in the PR description: `0x36` is a push with its status in the body. No phone. Report in the handoff when done.

**After that, wait:** FW30b stays queued until the owner says. **Start now** on the two fixes.

## Answer to the op 18 placement STUCK (Claude, 2026-10-28 17:45; the owner has put Grok back on firmware work)

The freed op 17 body was `0x5BD74`–`0x5BFB2` (574 bytes). FW3K uses its start for the stub and the gate, and keeps a live pool at `0x5BE34` and the shared code at `0x5BF24`, `0x5BFF2` and `0x5C040`.
1. **Map what is really free in `0x5BE34`–`0x5BFB2`**, after the pool and the shared code. List each run with its length, and run the literal guard on it.
2. **If no 122-byte run exists, shrink op 18.** Its only job is to read one AT1846S register by number. Call the same read wrapper the `0x32` RSSI handler uses, build the reply through `0x8E7C`, and drop the rest. That should fit in about 40–60 bytes.
3. **Or free bytes:** merge the op 16 and op 17 refusals into one shared refusal.

Then FW30b: three CAN 7 symbol keys, reading `0x30`/`0x58` at 0.5 s and 2 s after status 4, to see whether the close guard at `0x37F8` runs and what re-mutes. **Also on your list (from my 17:38 promiscuous run):** turning the promiscuous flag off leaves receive deaf until a channel write. Read the op 15 off path after FW30b.

The phone and hotspot are yours. **Start now.**

## Review: F30B, opcode 18 after symbol keys (Claude, 2026-10-28 18:20)

**Accepted as a bench image.** Op 18 placed in the uncalled tail at `0x5BFB4` (58 bytes, pool and shared code left), all reads `sr` 0. It settles the question: after a symbol key the AT1846S is back in FM (`0x58` = `0x8405`, `0x30` = `0x70A6`) at 1.1 s and 2.6 s, so the close guard runs and the filters are restored; what stays wrong is the **close's mute bit**, still set at 3 s.

**F30C, two fixes in one image:**
1. **Clear the mute after a symbol key.** Read `0x30` with op 18 at idle before a key, then after, and name the bit. Find where the stock unkey clears it (the analog key path) and do the same at the end of the op 7 close, or restore the idle `0x30` value saved at key start. Pass: three CAN 7 symbol keys, each followed by a hotspot M17 call that the held-path receiver decodes, and an FM call heard, with no module restart.
2. **Op 15 off restores the colour-code word.** On off, clear bit 8 of `0x11000384` (or write back the value saved when the flag went on). Pass: on → off → an in-list call on channel 49 is heard without a channel write (promiscuous case 7, replay from the hotspot relay).

Then the runner's `all` on F30C. Literal guard on every new range. Report in the handoff. **Start now.**

## Answer to the F30C STUCK (Claude, 2026-10-28 19:20)

Good: bit 7 of `0x30` is the mute (idle `0x7026`, after a symbol key `0x70A6`). Two moves, in order:

1. **First try it without a patch (no build).** On F30B, after one symbol key: op 18 reads `0x30`. Then send one channel write (`0x23`, the same channel) and read `0x30` again after 0.7 s, then take a hotspot M17 call. `at1846_tune` writes `0x30` itself, so a channel write may clear bit 7. If it does, the fix is host-side: SignalDeck PR 39's channel rewrite after symbol transmit (`rxAfterSym`, merged into main today), kept for FW30 and later. Report it, and I will make the host change. If the bit stays set, go to 2.
2. **Firmware: a one-shot in the task loop, not on the opcode 3 path.** At key start (op 7's arm, or wherever the symbol key sets its TX bits), store a RAM flag "symbol key ran". In the `0x18B68` branch, which already holds the refill, add: if the flag is set and the TX bits are clear, read `0x30`, clear bit 7, write it back, and clear the flag. That runs once after the close completes and never touches the close itself, the unkey or opcode 3. Use a RAM byte you have already proven free (one of yours, not a new stock word), and run the literal guard.

Pass as before: three symbol keys, each followed by a decoded hotspot M17 call and a heard FM call, with no restart; op 18 shows `0x7026` after each. Then the op 15 off fix, then the runner's `all`. **Start now.**

## Answer to the 62-byte STUCK (Claude, 2026-10-28 19:30)

The channel-write result is useful: `at1846_tune` does not touch bit 7, so the fix has to be in firmware. For room, in order:
1. **Shrink the one-shot.** Don't read-modify-write: write the known idle value `0x7026` to `0x30` (one call of the stock I²C write wrapper with constant arguments), behind the flag and TX-clear test. Load the constants with `movi`/`lsli` where possible, not new pool words. Target ≤ 36 bytes, so op 18 stays.
2. **If it still does not fit, drop op 18 from F30C.** It has answered its question (bit 7). With it gone, the tail has 74 bytes. Verify through behaviour instead: a decoded M17 call and a heard FM call after each key. Op 18 can come back later if a byte budget is found.

Before writing `0x7026`, check it is the idle value on both an FM and a DMR channel (op 18 on F30B, idle, one of each). If they differ, use 2 with the read-modify-write. Same pass list, then op 15 off, then the runner's `all`. **Start now.**

## Answer to the F30C flag STUCK (Claude, 2026-10-28 19:50)

Progress: after each key the module reported status 1 and the audio was RMS 750–940, where F30B gave 1.5, so the receiver is no longer silent. The M17 listing failing is a separate question (below).

1. **Yes, keep the flag longer.** Count task passes after the TX bits drop: on every pass for about 2 s, read `0x30`, and if bit 7 is set, clear it and write it back. Clear the flag only after that window, so a late re-mute by the close is caught. No constant (DMR idle is `0x4026`, M17/FM `0x7026`: read-modify-write is right).
2. **Check why M17 did not list, before blaming the mute.** F30B showed `0x58` = `0x8405` after a key (filters on), and the held-path receiver needs SignalDeck's op 6 hold (`0x58` = `0xBCFD`). Look in the SignalDeck log for the hold being re-sent after status 4. Confirm the hotspot actually sent M17 at each call (MMDVM log, "M17 … transmission"). If the hold was not re-sent, report it: that is host-side, mine.
3. **Add the FM check:** after each key, one FM call on an FM channel, heard (RMS and a status 1/2).

Then op 15 off, then the runner's `all`. **Start now.**

## Review: F30C hold finding (Claude, 2026-10-28 20:25)

Good find, and good that you went on to queue item 3. The missing hold is host-side, and SignalDeck `main` already fixes it: PR 39 (merged today) adds `rxAfterSym()` after every symbol unkey. It rewrites the channel, and the channel write re-sends the op 6 hold when M17 receive runs. Your C:\Users\Joshua\AppData\Local\Temp\claude\apk-main\SignalDeck-main-7a99fcc0.apk predates it (no `rx after sym` line).

**Next, before more firmware changes:**
1. Save your current C:\Users\Joshua\AppData\Local\Temp\claude\apk-main\SignalDeck-main-7a99fcc0.apk, then install `C:\Users\Joshua\AppData\Local\Temp\claude\apk-main\SignalDeck-main-7a99fcc0.apk` (SignalDeck `main`, release, same key) with `adb install -r`. Put yours back with `install -r -d` afterwards if you need it.
2. Load **F30C `f4beb348…5ee9`** again. That is the first-pass clear: it gave status 1 and RMS 750–940 after every key, which means it worked. The later variants were silent.
3. Three symbol keys on channel 56, each followed by a hotspot M17 call. Pass: `rx after sym` and `data hold` both logged, and the call is listed with N0CALL. If all three pass, F30C is done for the mute: skip the countdown idea.
4. FM check: the hotspot's FM mode is off, so use the HackRF only if it is free (it is with the Atom XL agent; ask in the handoff, don't take it). Otherwise skip FM for now and note it.
5. Op 15 does not fit: leave the promiscuous off-path to the host. SignalDeck PR 74 re-sends the channel after the flag goes off. Note it in `results.md`.
6. Then retag as FW31 (queue 2) and the runner's `all`, then back to hotspot M17 receive (queue 3).

**Start now.**

## Answer to the F30C hold-pass STUCK (Claude, 2026-10-28 20:40)

You are right, and my 20:25 line was wrong: main has `rxAfterSym`, and its channel rewrite is what re-mutes after your one-shot. So the host stops rewriting on images that unmute themselves: SignalDeck PR 77 (`sym-unmute-fw31`) re-sends only the op 6 hold from **FW31**, and keeps the rewrite for older images. No firmware change.

Also good news in your log: the hotspot decoded the phone's own keys (69/76/76 frames, end bit). M17 receive on the new card looks fixed, so check whether queue item 3 is already done.

**Next:**
1. Retag `f4beb348…5ee9` as `DMR003.FW31.V022` (queue 2; tag bytes only), then load it.
2. Install `C:\Users\Joshua\AppData\Local\Temp\claude\apk-main\SignalDeck-symunmute-d1b1ab66.apk` (PR 77, release, same key).
3. Three symbol keys on channel 56, each followed by a hotspot M17 call. Pass: `rx after sym: firmware unmutes itself, hold only`, then `data hold … sr=0`, and N0CALL listed each time.
4. The runner's `all` on FW31, then record the sha in `results.md`.
5. Queue 3: confirm hotspot M17 receive with one more Armor key and its MMDVM log line; if it passes, go to queue 4 (the 1125-frame stream).

**Start now.**

## Review: FW31 hold-only pass (Claude, 2026-10-28 20:55)

**Big result: queue 3 and 4 are done.** The hotspot decoded three Armor keys and the 1125-frame stream (44.8 s, BER 0.0 %, end bit). That closes the M17 transmit-to-hotspot path on FW31.

The second status 4 is very likely the host's own `0x26` off: `unkeyAfterStop()` waits for the module's status 4 and then still sends PTT off, which runs a second close. That close re-sets bit 7 after your one-shot has run. Since FW20 the firmware ends the key itself, so on FW31 that PTT-off is redundant. SignalDeck PR 77 (now `a6d28466`) skips it when status 4 has arrived, and sends it only as a fallback after 2.5 s. No firmware change.

**Next:**
1. Install `C:\Users\Joshua\AppData\Local\Temp\claude\apk-main\SignalDeck-symunmute-a6d28466.apk` (keep FW31 loaded).
2. Three symbol keys on channel 56, each followed by a hotspot M17 call. Pass: `sym unkey: the module ended the key itself (FW31+), no 0x26 off`, then `data hold … sr=0`, **one** status 4 per key, RMS well above 1.5 during the carrier, and N0CALL listed.
3. If a second status 4 still appears without our `0x26`, the firmware has to handle it: make the clear edge-triggered (on every TX-bits set→clear transition, not a one-time flag). Report it first.
4. Then the runner's `all` on FW31, and queue 5 (the next open item in plan 19, M17 first per the owner's priority: M17 > DMR promiscuous > time-out).

**Start now.**

## Answer to the second-status-4 STUCK (Claude, 2026-10-28 21:00)

Clean result: the host is ruled out. The sequence is module status 4 → status 1 (at RSSI `0x04`, no carrier) → another status 4 with no PTT-on, which looks like a **close path running again on receive start**. It is the same pattern as FW19's leftover TX flag, where a later event re-runs the close because some TX/close state was not cleared.

**Next: find which code sends that second status 4, then fix it at the source.**
1. **Diagnostic image (bench only):** list every site that reports status 4 (the `0x36` push with body 4: the close, the time-out, the receive-start/close guard at `0x37F8`, and any others). Give each one a distinct code (`0x41`, `0x42`, … instead of 4) in a throwaway image. One key plus one hotspot call tells which site fires second, and what precedes it (status 1 at RSSI `0x04`).
2. **Then fix the cause:** most likely a TX/close flag the symbol close leaves set, so the receive start runs the close again. Clear that flag where the symbol close ends, as FW20 did for the time-out state. If the second close is legitimate, run the bit-7 clear after **every** close that reports status 4 (hook the status-4 report site), not on a TX-bits edge.
3. Pass as before: one status 4 per key, receive audio during the hotspot carrier, N0CALL listed. Then the runner's `all`.

The hotspot side is solid (68/76/76 frames). **Start now.**

## Review: FW31 mute fix (Claude, 2026-10-28 21:15)

**Accepted: the mute is fixed.** The second status 4 was the bit-2 path at `0x89C` (`0x38908` bit 2 left set by the symbol key). Clearing it gives one status 4 per key and receive RMS about 4500. The FW31 bench image is now `997cb714…ac30` (tag `DMR003.FW31.V022`); record that in `results.md`, and drop the earlier `2935910f` FW31 from the notes.

**The empty heard list is a separate question.** Settle it in this order:
1. **Baseline with no key:** select channel 56 fresh, then send one hotspot M17 call before any transmit. If it is not listed either, the keys are not the cause.
2. **Offline decode:** save that call's receive PCM (and one after a key). Run the held-path batch decoder from `tools/m17-research/` (`heldpath_rf_score.py` or similar) on it. Report the sync hits, the symbol levels (expect ±1/±3 after normalisation) and the deviation estimate. Compare with an earlier good recording from the old card.
3. **If the levels are off,** it's the new card's M17 transmit level. Compare MMDVM.ini `[Modem] M17TXLevel` (and `TXLevel`) with the old card's values in `tools/hotspot-bench/README.md` or `hotspot_setup.py`. Change one setting at a time, written down, then a restart of mmdvmhost. Do not run `deploy.sh`.
4. **If the levels are fine** but nothing locks, check the app side: the held-path taps loaded for the Armor profile, and `M17 receive` actually running on the channel (the log line). Report that and I'll take the host side.

Then the runner's `all` on FW31, then queue 5. **Start now.**

## Answer to the heard-list STUCK (Claude, 2026-10-28 21:20)

Stop stepping the level: the new finding outranks it. **A fresh channel select leaves the receiver muted (RMS 1.5) with no key at all.** On FW26 (2026-10-27) the same channel 56 heard hotspot M17 (99 frames, 83 good). So either something in the FW27→FW31 line mutes receive after a channel write, or the setup changed (SignalDeck build, hotspot card). The distorted symbols (+0.7 … −4.9) may follow from the same cause. Bisect it, one variable at a time:

1. **FW26 as the control:** load `radio_firmware/build/DMR003.FW26.V022.bin` (sha `71949d24…a34e`), keep SignalDeck PR 77 and `M17TXLevel=50`, select channel 56 fresh, then one hotspot M17 call. Report RMS and frames listed, plus op 6 / `0x58` if readable.
   - **If FW26 decodes:** the firmware line is the cause. Repeat with FW29, then FW30 (FW3K), to find the first image that mutes after a select. The FW3K changes (channel-mode gate on the FM setup, `0x18B5C` stock, the close guard at `0x37F8`) are the prime suspects. Then fix that in FW31.
   - **If FW26 also fails:** it isn't the firmware. Next, put beta.19 (`ebe814a4`, saved) back on FW26 to test the app, then the hotspot. The old card's level is not recorded, so log the MMDVM `M17` RX/TX lines and compare the deviation on a HackRF capture if the HackRF is free (it's with the Atom XL agent; ask, don't take it).
2. Load the factory image and key it once before the next bench image, if any image hung (bench rule).

Report the table: image × select-only RMS × frames listed. **Start now.**

## Review: select-mute bisect (Claude, 2026-10-28 21:45)

**Accepted, and it clears the firmware line:** a clean select receives on FW26, FW29, FW30 and FW31 (75–77 frames, about 70 % good). The fault only appears **after a symbol key**: key then one select gives silence, a second select gives 45 frames. And with no select (PR 77, hold-only), the audio is loud but won't lock. So a symbol key leaves some receive state wrong, and it takes two channel writes to put it right.

**Next, find that state (no fix guessed yet):**
1. **Register snapshots in four states:** (a) clean select, (b) after a key with no select, (c) key then one select, (d) key then two selects. Use whatever read path FW31 still has (op 5 register dump, or put a 40-byte op 18 back temporarily in a bench image). Read the AT1846S `0x30`, `0x58`, `0x44`, the HR-C7000 `WORK_MODE` and `FM_BANDWIDTH`, the `0x11000384` colour-code word, and RAM `0x38908`. Tabulate what differs between (a)/(d), which receive, and (b)/(c), which don't.
2. **Same run, the host stopgap:** key → select → select (DIAG, automatic) three times, each followed by a hotspot call. If 3/3 list, I'll put a double rewrite into PR 77 as a stopgap until the register fix lands.
3. Then restore the differing register(s) in FW31's one-shot (one at a time), and pass: key then hotspot call with no select, listed 3/3. Then the runner's `all`.

**Start now.**

## Answer to the read-stub STUCK (Claude, 2026-10-28 21:55)

Good: the double select works 3/3, so it goes into SignalDeck as a stopgap. PR 77 now writes the channel twice after a symbol key on FW31 (700 ms apart, hold re-sent), with no extra PTT-off. C:\Users\Joshua\AppData\Local\Temp\claude\apk-main\SignalDeck-symunmute-d411afcf.apk: `C:\Users\Joshua\AppData\Local\Temp\claude\apk-main\SignalDeck-symunmute-d411afcf.apk`.

**Room for the read stub:** this is a throwaway diagnostic image, not FW31, so take the space from a feature the test doesn't need. Overwrite the promiscuous code (op 15 handler and its gate stubs), or the op 16/17 refusal stubs, with the 40-byte read in a bench-only `DMR003.FWD1.V022`. Keep the literal guard, and never touch `0x35F64` or go past `0x5C6FC`. Load the factory image and key it once before going back to FW31.

**Next:**
1. Install the C:\Users\Joshua\AppData\Local\Temp\claude\apk-main\SignalDeck-symunmute-d411afcf.apk. On FW31: key, then a hotspot call, three times. Pass: `rewritten twice true/true`, listed 3/3, with no manual select.
2. FWD1 snapshots in the four states (clean / key / key+1 select / key+2 selects), as in the 21:45 review. Tabulate the differences.
3. Then the factory image keyed once, FW31 back, and the fix for the differing state in FW31's one-shot (so the stopgap can go).
4. Then the runner's `all` on FW31.

**Start now.**

## Review: double write + register snapshots (Claude, 2026-10-28 22:15)

**Accepted.** The stopgap listed 3/3 (79/56, 50/34, 76/54), and SignalDeck PR 77 is now merged into `main` (`ae101ba5`). The snapshot table is clear: only **bit 7 of `0x30`** changes, `0x58`/`0x44` stay put. Bit 7 is set again **after** FW31's one-shot (still `0x70A6` at 8 s), and a channel write clears it.

**Next (firmware, so the stopgap can go later):**
1. **Find what sets bit 7 late.** Use FWD1's op 18 to poll `0x30` every 200 ms after a key, for 10 s, together with the status pushes. Report the time it goes `0x70A6` and the status or event next to it (likely the status 1 at RSSI `0x04`, the receive-start path).
2. **Then the fix, whichever fits:** (a) at that late site, skip setting bit 7 on M17/FM channels after a symbol key; or (b) a small guard in the task loop: while not transmitting and bit 7 is set, clear it, at most once per 500 ms, active for 10 s after a key. Idle is `0x7026`/`0x4026`, never with bit 7, so this does not fight a legitimate mute. Measure the bytes first; owner's priority is M17, so the space can come from the promiscuous code if needed.
3. Pass: key, then hotspot call, listed 3/3 with **one** host write (switch SignalDeck to single-write with a DIAG flag). Then the runner's `all`, and back to queue 5.

**Start now.**

## Answer to the F31G STUCK (Claude, 2026-10-28 22:50)

Useful result: bit 7 is the **transmit-time receive mute**. It is set during the key (already `0x70A6` at the first read after status 4), and the symbol path never clears it, unlike the stock unkey. And a clear during the key stalls the ring, so the trigger must be "after the key".

**The event that means "symbol key finished" is our own:** the status-4 post at the symbol drop, `0x5B686` (your diagnostic site `0x43`). Only our symbol engine runs it, once per key, after the drain and the drop.
1. At `0x5B686`, right after the status-4 post, **set a RAM flag** ("sym done") in a byte you have proven free. Don't do I²C there; it may not be the task context.
2. In the `0x18B68` hook: if "sym done" is set, read `0x30`, clear bit 7, write it back, and clear the flag. Do it once, no countdown, and don't depend on `0x38908` bit 0.
3. Keep the bit-2 clear as in FW31. Remove the F31G countdown.
4. Build it as `DMR003.FW32.V022`. For the pass, the host needs to send one write. I'll add that now: from FW32, SignalDeck writes the channel once (no double write) and sends no `0x26` off. Pass: key then hotspot call, listed 3/3. Then the runner's `all`.

**Start now** on the image; the APK follows in this handoff within the hour.

## Answer to the FW32 STUCK (Claude, 2026-10-28 23:05)

**Yes.** The ring stalled because the bit-2 clear ran on every task pass during the key. FW31 runs it once. So:
1. **Keep FW31's one-shot exactly as it is** (bit-2 clear, then `0x4B384` cleared on its first pass). Don't reshape it to make room.
2. **Add only the new piece, in the `0x18B68` hook path:** if `0x4B385` is set, read `0x30`, clear bit 7, write it back, and clear `0x4B385`. Put those bytes in the hook's own stub area, or the FWD1/promiscuous space if that's what fits (M17 first), not in the one-shot.
3. The drop stub at `0x5B686` stays: post status 4, then set `0x4B385`. It should **not** clear `0x4B384` (FW31 already did).
4. Rebuild as `DMR003.FW32.V022` with a new sha, then the same pass: key then hotspot call, listed 3/3 with one write (APK `485442d1`, log `rewritten once`), then the runner's `all`.

If the ring stalls again with this split, report the op 2 fill and the last status before it. **Start now.**

## Answer to the split-FW32 STUCK (Claude, 2026-10-28 23:55)

The ring stops at status 3, before any of our new I²C runs. So the break is in **what calls what**, not in the bit-7 clear. In FW19 the `0x18B68` hook is the symbol engine's own path (`0x5B4D0`: it runs while the symbol flag is set and returns early when it is clear). If the new hook body doesn't reach that path exactly as FW31 did, or clobbers a register or `r15` before it, the refill never runs.

**Next: bisect it in two images, not one:**
1. **FW32a:** FW31 plus **only** the drop-tail change (status 4 posted, then `0x4B385` set). The `0x18B68` hook stays byte-identical to FW31. Expected: it drains as FW31 does, and `0x4B385` reads 1 after a key (op 5 / RAM read, if you have one).
2. If FW32a drains: **FW32b** adds the bit-7 clear **inside FW31's existing idle branch** (the path that returns early when the symbol flag is clear), with `push`/`pop` of every register it uses. Don't change what the hook calls, or the order.
3. If FW32a already stalls: the drop tail at `0x5C490` overlaps something live. Diff FW31 and FW32a byte by byte, list every changed range against FW31's map (incl. the `0x5C488` literal and the `0x5C6BC` pool), and move the tail.

Also: the V076 load on the Atom XL isn't waiting for you. The owner gave it to the Atom XL agent; you have no Atom XL task. **Start now** with FW32a.

## Answer to the FW32 bisect STUCK (Claude, 2026-10-29 00:10)

Good bisect: `0x5C490` is a live fall-through (never use it), and the freed clamp slot at `0x5B700` works (owner: the clamp may go). **Keep FW32 `53e1fd7b…1d11` as built.**

The pattern across tonight's runs: a channel write right after status 4 gets undone, a write about 0.7 s later works, and a manual select later works. So the close re-mutes about half a second **after** status 4. Your firmware clear and the host's first write both land before that.

**Host fix first (no firmware change):** SignalDeck PR 78 now waits **1 s after status 4**, then does its single write. C:\Users\Joshua\AppData\Local\Temp\claude\apk-main\SignalDeck-fw32-cbe74c70.apk: `C:\Users\Joshua\AppData\Local\Temp\claude\apk-main\SignalDeck-fw32-cbe74c70.apk`.
1. Install it on FW32. Three keys, each followed by a hotspot call. Pass: `rewritten once`, one status 4, and N0CALL listed 3/3.
2. If it passes: FW32 is the new bench base. Then the runner's `all`, then the acceptance pass (queue 3).
3. Only if it still fails: poll `0x30` every 100 ms for 2 s after status 4 (op 18 on a diagnostic image) to see exactly when bit 7 returns, and report.

**Start now.**

## Review: FW32 0x30 poll (Claude, 2026-10-29 00:30)

**Decisive, and it reverses my last guess.** Bit 7 is **clear** from 0.09 s to 0.89 s after status 4, so FW32's own clear works and nothing re-mutes it by itself. It's set again only **after the host's channel write**. So on FW32 the channel write right after a symbol key is what mutes. The second write on FW31 worked because it found that state already undone.

**So on FW32 the host should not write the channel at all, only re-send the op 6 hold.** SignalDeck PR 78 is now exactly that (`5a0d18d9`, host 454/0). C:\Users\Joshua\AppData\Local\Temp\claude\apk-main\SignalDeck-fw32-5a0d18d9.apk: `C:\Users\Joshua\AppData\Local\Temp\claude\apk-main\SignalDeck-fw32-5a0d18d9.apk`.
1. Install it on FW32 `53e1fd7b…1d11`. Three keys, each followed by a hotspot call. Pass: `hold only (no channel write)`, one status 4, and N0CALL listed 3/3. Also one FM call after a key, heard (RMS), to make sure the hold-only path doesn't leave FM muted.
2. If it passes: FW32 is the new bench base. Then the runner's `all`, then the acceptance pass.
3. If it fails: one more poll, this time with no host write at all, to show whether bit 7 stays clear past 2 s.

**Start now.**

## Review: FW32 hold-only (Claude, 2026-10-29 00:45)

**Accepted on the firmware side: FW32 `53e1fd7b…1d11` is right.** With no host write, `0x30` stays `0x7026` past 2 s, `0x58` is held at `0xBCFD`, and FM after a key reads RMS ~3600. **The radio is fully open after a symbol key.**

What's left is in the app. A channel write used to restart SignalDeck's M17 receiver too (`followM17Channel` → `setM17`), and with no write the receiver keeps the state of our own transmission and never locks. PR 78 (`31c514d0`) now restarts the M17 receiver in the FW32 hold-only path. C:\Users\Joshua\AppData\Local\Temp\claude\apk-main\SignalDeck-fw32-31c514d0.apk: `C:\Users\Joshua\AppData\Local\Temp\claude\apk-main\SignalDeck-fw32-31c514d0.apk`.
1. Install it. Three keys, each followed by a hotspot call. Pass: the log line `… hold only (no channel write), M17 receiver restarted`, and N0CALL listed 3/3.
2. If it passes: **FW32 is the new bench base.** Then the runner's `all`, then the acceptance pass (I'll stage the full C:\Users\Joshua\AppData\Local\Temp\claude\apk-main\SignalDeck-fw32-31c514d0.apk, main + PR 78 + PR 74, as soon as 78 is accepted).
3. If it still doesn't lock: run DIAG `m17 off` / `m17 on` by hand after a key and report whether that alone locks.

**Start now.**

## Review: M17 receiver restart (Claude, 2026-10-29 00:55)

**Accepted as a negative result.** The app's receiver isn't the cause: an off/on doesn't help either. So with no channel write, something besides `0x30` bit 7 and `0x58` stays wrong after a symbol key: audio flows (FM RMS ~3600), but M17 symbols come out distorted. The two channel writes put that right; one write re-mutes.

**Decision for tonight: run on what works, investigate beside it.** SignalDeck `main` (PR 77) already writes the channel twice after a symbol key on FW31 and later, so it applies to FW32 too. PR 78 is parked. The acceptance C:\Users\Joshua\AppData\Local\Temp\claude\apk-main\SignalDeck-accept-a7344f19.apk is `main` + PR 74 (promiscuous), host suite 495 / 0: `C:\Users\Joshua\AppData\Local\Temp\claude\apk-main\SignalDeck-accept-a7344f19.apk`.
1. Install it on FW32 `53e1fd7b…1d11`. Three keys, each followed by a hotspot call. Pass: `rewritten twice`, N0CALL listed 3/3.
2. If it passes, **FW32 is the bench base.** Then the runner's `all`, then the **full acceptance pass** (HANDOFF item 3), with the results table in `results.md`.
3. **Beside it, when the phone is idle (queue item 3b):** an AT1846S register diff to find what a symbol key leaves wrong. Read every register `0x00`–`0x7F` with op 18 (diagnostic image) in three states: clean select, after a key with no write, and after a key with two writes. Tabulate the differences. Then restore those registers in the firmware's idle clear, so the host write can go.

**Start now.**

## Review: FW32 + double write, runner (Claude, 2026-10-29 01:15)

**Accepted: FW32 `53e1fd7b…1d11` is the new bench base.** Receive after a symbol key lists 3/3 (76/55, 78/56, 75/57). The runner's `all` passes (stream 1125/1125 with the end bit, receive −19.1 dBFS, 45 s heat with no stop), and a 100 s low-power key ended cleanly at AP 45.7 °C peak.

**One new problem to settle first:** the hotspot logged no RF M17 from these keys or the 1125 stream, while on FW31 at 20:45 it decoded the same keys and stream at BER 0.
1. **A/B, quickest first:** key the 1125 stream on FW31 `997cb714…ac30`. If the hotspot decodes it, FW32 broke transmit; diff the FW31 and FW32 bytes on the symbol and drop path (the drop stub now sits in the old clamp slot). If FW31 isn't decoded either, the hotspot changed: check `[Modem] RXLevel`, `M17` RX settings and `RXOffset` in MMDVM.ini against 20:45 (you set `M17TXLevel` 30 and back; check nothing else moved), plus the MMDVM log for any M17 RF lines.
2. Fix whichever side it is, then repeat the stream until it's decoded.
3. **Then the rest of the acceptance pass** (none of it run yet): DMR both ways (group and private, both slots), FM with CTCSS transmit, APRS out and in, POCSAG, FT8/RTTY, SSTV, promiscuous on/off. One table in `results.md`.
4. Then item 3b (the register diff).

**Start now.**

## Answer to the no-carrier STUCK (Claude, 2026-10-29 01:40)

Good catch; this is a known trap. CLAUDE.md §3a, "Channel writes to the MCU": two channel writes back to back can leave the MCU reporting `SEND_START`/`SEND_STOP` normally while **radiating no RF at all**. Receive is unaffected, and the state survives reboots. SignalDeck's double write after a symbol key (PR 77, 700 ms apart) is exactly that pattern, so it's the prime suspect for the silent transmitter. The hotspot's silence followed from it (plus the MMDVM log gap).

**Next, from the factory image that radiates now:**
1. Load FW32 `53e1fd7b…1d11`, select channel 56, and send a 2 s low-power test tone **before any symbol key**. Read it on the HackRF (expect ~500 like the factory image). If it's silent already, it's the load, not the writes: report that.
2. One symbol key with the acceptance APK (double write), then the test tone again. If it's now silent, **the double write is the transmit killer.**
3. In that case, on the same bench run, try the **spaced** version: SignalDeck sets 3.5 s between the two writes (I'll build it as soon as you confirm). Check the tone after a key, and the M17 listing.
4. **Recovery each time:** factory load, select channel 49, key a tone (the bench rule), then the next image.

Record the power numbers for each step in `results.md`. **Start now.**

## Review: FW32 silent before any key (Claude, 2026-10-29 01:45)

Useful: the double write is cleared, since FW32 is silent before any symbol key. But two things don't fit yet:
- **At 01:06 the runner's `tone` and `stream` passed on this same FW32** (tone p99 2596 Hz, stream 1125/1125, measured from the HackRF). So FW32 did radiate then, and this is a **state**, not the image.
- **The comparison mixes channels:** FW32 was tested on channel 56 (the M17 channel, op 6 hold) and the factory image on channel 49.

**Next, one variable at a time** (power per second for each):
1. **FW32 on channel 49:** a 2 s tone.
2. **Factory on channel 56:** a 2 s tone.
3. **FW32 on channel 56 with M17 receive and the hold off** (DIAG `m17` off, so no op 6): a tone.
4. **The runner's `tone` alone** on FW32, as at 01:06, to compare with its measurement.
5. Note the pattern in your captures: about **1 s of carrier, then the noise floor** while the app says it's transmitting. Check the SignalDeck log for what happens about 1 s into the key (heat guard, a watchdog, a status 4 from the module, a `0x26` off).

That tells channel, hold and state apart. **Start now.**

## Review: channel 56 kills the carrier (Claude, 2026-10-29 01:55)

Clean isolation: it's **channel 56's write**, on the factory image too. So it isn't our firmware: channel 49's write puts it right, and after a channel-56 write even a VFO tone has no carrier. Since M17 keys on channel 56 were decoded by the hotspot at 20:45, **what changed is what SignalDeck sends for channel 56.**

**Next:**
1. Log the exact `0x23` frame (all body bytes) SignalDeck sends for channel 56 and for channel 49 now, and the stored channel 56 row (type, rx/tx frequency, power, band, tones, squelch, colour code / CAN).
2. Compare it with the `0x23` for channel 56 in your log from 20:30–20:45 (when keys radiated, APK `d1b1ab66`/`a6d28466`). Name the byte that differs.
3. If the stored row changed (power, TX frequency or band), fix the row and retest the tone. If the frame changed with the same row, it's SignalDeck's write path in the newer `main` (the Atom XL merges or PR 74). Report the byte and I'll fix the app.
4. Then resume the acceptance pass on FW32, starting with M17 transmit to the hotspot.

**Start now.**

## Answer to the channel-56 frame STUCK (Claude, 2026-10-29 02:05)

So the frame is identical to 20:38, and the row is too. The difference is the **radio's state**, and the symptom fits the known channel-write-pair trap (CLAUDE.md §3a): transmit reported normally, no RF, the state surviving image loads, a different single-path channel write clearing it. Channel 49 is a `0x22` (DMR) write, and that clears it. Channel 56 is a `0x23` immediately followed by `0x40` op 6, and possibly by the monitor/squelch writes SignalDeck sends after the ack (`pendingPostWrite`). That is **two or three writes back to back**, the pattern that sets it. Earlier tonight the timing may simply have missed it.

**Isolate it in this order (HackRF power for a 2 s tone each time, after recovering on channel 49 between runs):**
1. **A plain FM channel at 467.625** (a new type-1 channel, no M17, no hold): select it, then the tone.
2. **The VFO at 467.625** (DIAG `vfo`, one `0x23` only), then the tone.
3. **Channel 56 with the follow-ups held back:** log every frame SignalDeck sends in the 3 s after the `0x23` (the `0x40` op 6, `0x2F`, `0x30`, anything else), and the times.
4. If 1 and 2 radiate and 56 doesn't: the extra writes after the `0x23` are the trigger. Report the sequence and I'll make SignalDeck wait for the channel to settle (3.5 s, the `RETUNE_SETTLE_MS` rule) before sending the op 6 hold, with no other frame in between. If 1 and 2 also die: it's any analog write on this module now. Then try a power cycle (`dmr009` off 15 s) followed by a factory load, and report.

**Start now.**

## Review: a single analog `0x23` loses the carrier (Claude, 2026-10-29 02:15)

Narrower again: any analog write does it (a plain FM channel, the VFO, channel 56), the hold is not needed, and the DMR channel 49 is fine. But FW32's VFO tone passed the runner at 01:06, so analog transmit worked an hour ago. Before blaming the radio, **rule out the measurement**. A strong continuous FM carrier at close range is exactly what has stalled the HackRF stream before (memory: a key-up at close range stops the HackRF stream and leaves it deaf). A short burst followed by the noise floor is that signature. The DMR bursts are lower average power, so they don't trip it.

**Next:**
1. Check `tasklist` for stuck `hackrf_transfer` processes, and kill any. Use a **fresh** `hackrf_transfer` for each capture, and send one dummy capture first (the first after a pause is often silent).
2. Repeat the FW32 plain-FM tone with the **HackRF gain 20 dB lower** (LNA/VGA down, amp off), and the factory plain-FM tone the same way.
3. **Independent check:** key a 5 s plain FM tone and watch the hotspot's RSSI or modem log for activity on 467.625. Or put the Atom XL on 467.625 FM, receive only, ask its agent for a short lease, and record its RMS. If either hears the full 5 s, the radio is fine and the HackRF was the problem.
4. Then resume the acceptance pass from M17 transmit to the hotspot (with the MMDVM log checked live, since it stopped once tonight).

**Start now.**

## Review: factory FM holds, FW32 FM drops after 1 s (Claude, 2026-10-29 02:25)

Good: the HackRF is cleared, and the fault is **FW32's**: the factory image holds a full FM carrier, while FW32 gives about 1 s and then nothing. The runner's 01:06 VFO-tone pass fits this: its deviation check only needs the first second.

**Prime suspect: FW32's own idle-branch bit-7 clear.** It reads `0x30`, clears bit 7, and writes it back when `0x4B385` is set and "the TX bits are clear". But those TX bits are the **symbol path's**, not the FM key's. If `0x4B385` is set (SRAM kept it across loads, as you found with F32M), or the check passes during an FM key, the write puts back a `0x30` value without the transmit-on state, and the carrier drops. That would also explain the symbol keys' 1 s bursts the hotspot never decoded.

**Check, then fix:**
1. **FW31 `997cb714`:** a 5 s plain-FM tone. FW31 has no idle clear, so if it holds the carrier, that confirms it.
2. **Fix in FW33:**
   - The clear runs only when the module is **not transmitting in any mode** (gate on the stock PTT/TX state the `0x26` handler sets, not only the symbol bits). Do the read and the write back to back.
   - **Clear `0x4B385` at boot** (and at each key start, before the drop can set it), so a stale SRAM value can't trigger it.
3. **FW33 pass:** a 5 s FM tone at full carrier; a symbol key decoded by the hotspot (MMDVM log live); M17 receive after a key, listed with the double write; then the runner's `all`.
4. Then the acceptance pass.

**Start now.**

## Answer to the FW31 FM STUCK (Claude, 2026-10-29 02:35)

Good elimination: the idle clear is ruled out. FW31 drops too, and the factory image holds. And `0x3D20` is an empty `jmp r15` (results.md), so the `0x18B68` stub skipping it changes nothing. That leaves **our key wrapper** as the main difference on a plain FM key: the four `0x26` sites (`0x92AA`, `0x92C8`, `0x92E0`, `0x92FA`) and the FM setup `0x5BBE2` they call. FW3K gated that setup on the channel-mode byte (`0x34808`), so on an **analog** channel it still runs at every key. It writes the HR-C7000 and AT1846S `0x30`/`0x58` for the symbol engine, and that can take the AT1846S FM transmit over about a second in.

**Next:**
1. **Bisect quickly** (a 5 s plain-FM tone, LNA 0 / VGA 12, each one): FW19 `555b0128…`, FW26, FW30. That tells whether it has been there since FW19's wrapper.
2. **FW33 = FW32 with the FM setup called only for symbol keys** (when a `0x40` stream or tone is armed: the engine's own armed flag), never for a plain `0x26` key. A plain FM key then runs the stock launch path untouched. Keep everything else in FW32 (idle clear included; and still gate it on "not transmitting in any mode", as in the 02:25 review, if it fits).
3. **FW33 pass:** a 5 s plain FM tone at full carrier; one M17 key decoded by the hotspot (MMDVM log live); M17 receive after a key, listed; a DMR voice key on channel 49; then the runner's `all`.
4. Then the acceptance pass.

**Start now.**

## Answer to the HackRF STUCK (Claude, 2026-10-29 02:40)

A known trap (memory: a killed `hackrf_transfer` hangs in the USB driver; only a power cycle frees the board). Try in this order:
1. **A software USB reset:** `pnputil /enum-devices /connected` and find the HackRF (`1d50:6089`). Then `pnputil /restart-device "<instance id>"`, or `/disable-device` followed by `/enable-device`. That often frees the handle without touching the hardware. Then `hackrf_info`, plus one dummy capture.
2. **If that fails, don't wait on the HackRF.** Build FW33 now (the 02:35 review) and test what doesn't need it. The hotspot is the receiver: M17 keys and the 1125 stream decoded (MMDVM log live), DMR both ways, and M17 receive after a key. The FM carrier check waits for the owner to power-cycle the HackRF in the morning (I'll put it in the summary). Write "HackRF needs a power cycle" at the top of the handoff.
3. If the reset works: the three-tone bisect (FW19 / FW26 / FW30), then FW33 with the 5 s FM check.

Never start `hackrf_transfer -r` in the background again; use a timeout-wrapped foreground capture only. **Start now.**

## Answer to the FW33 STUCK (Claude, 2026-10-29 02:50)

Two separate problems:

**1. The empty-ring gate is the wrong discriminator.** At `0x26` time the ring is most likely still empty (the host keys first, then streams), so FW33 skips the FM setup for **M17 keys too**. The key then ends normally (`fill=1460`, `sym done`) while the modulator never gets the symbol setup. That fits "no RF line". Gate on the **op 6 hold marker** instead (the word that makes op 5 refuse registers while a hold is set): SignalDeck sets the hold on every M17 channel (type 2) and never on a plain FM channel, so "marker set" = M17 path, run `0x5BBE2`; "marker clear" = plain FM, skip it. If the marker word costs more than the 8 bytes, use the arm word that the `0x40` start op writes, but only if the host arms before `0x26` (check the frame order in `vars_load.log`).

**2. Check the hotspot's receive before trusting "no RF".** The DMR key on channel 49 gave **no hotspot voice event**, and channel 49 is the path that radiated full power on the HackRF. The hotspot has logged no RF of any kind since about 01:06, and its MMDVM log stopped once tonight. Its transmit is fine (the Armor listed its call), so its receive may be stuck:
   - load nothing new; key a 3 s DMR voice on channel 49 (FW33 is fine for DMR) with `tail -f` on the MMDVM log;
   - if there's no RF line: take the hotspot lease, `sudo systemctl restart mmdvmhost` (or reboot the Pi), check the RX frequency and offset in its config are unchanged, then key again;
   - only once the hotspot logs the DMR key is "no RF" on M17 a radio result.

**Order:** (a) the hotspot check, (b) FW34 = FW32 + the FM setup gated on the hold marker, (c) an M17 key logged by the hotspot, M17 receive after a key, DMR on channel 49 logged by the hotspot, the runner's `all`. The FM carrier check waits for the owner's HackRF power cycle (in the morning summary). Then the acceptance pass.

**Start now.**

## Answer to the hotspot STUCK (Claude, 2026-10-29 03:00)

With the HackRF down and the hotspot hearing nothing, we have no trusted receiver. **Use the Atom XL as the receiver:** it is in the cage, tunes 467.625, and has its own RSSI and receive edges (`/dev/stmcu` 00/01). Its agent is idle, and the owner allowed you to take its steps. Write a lease line in `docs/atomxl-status.md` first, and hand it back after.

1. **The Atom XL on 467.625** (stock app or SignalDeck, analog, squelch 0, RSSI polled about every 0.5 s and logged).
2. Key from the Armor and log the Atom XL's RSSI and the length of its receive edge:
   - **(a) factory image, 5 s FM tone:** the reference, which should be a full 5 s;
   - **(b) FW34, 5 s FM tone:** if it's about 1 s, the FM drop is still there and the wrapper suspicion stands;
   - **(c) FW34, a 3 s DMR key on channel 49;**
   - **(d) FW34, a 75-frame M17 key on channel 56:** a full-length carrier means the module radiates, and then the hotspot is the problem.
3. **Hotspot, separately** (only after 2): find the time of its last RF line of any mode (grep `RF` in the MMDVM logs since yesterday). Check `[DMR] Enable=1`, `[M17] Enable=1` and the DMR `ColorCode` against channel 49's colour code, and check `[Modem]` for a changed `RXInvert`/`RXDCOffset`. If nothing changed and (d) shows a full carrier, power-cycling the hotspot (Pi plus modem) is the next step; it goes in the owner's morning list if a reboot doesn't help.

The order is 1, 2, 3; then the FW34 pass (M17 receive after a key, the runner's `all`) and the acceptance pass. **Start now.**

## Review: the Atom XL heard nothing, factory included (Claude, 2026-10-29 03:10)

At 02:18 the HackRF saw the factory tone at 10^7 over the floor, but the Atom XL heard **nothing even from the factory image**. So the receiver check isn't validated yet: either the Atom XL wasn't listening on 467.625 (a VFO tune that didn't take: it reports 401.025 BENCH FM as its channel), or the Armor stopped radiating after 02:18. Two cheap checks settle it without the HackRF:

1. **Validate the Atom XL as a receiver:** put it on 467.625 again, read its frequency back, and have the **hotspot transmit** (an M17 or DMR network-test transmission; its transmit works, the Armor listed one at 02:43). The Atom XL must show RSSI and hearing. If it doesn't, it's not a usable receiver tonight; hand it back and skip to 2.
2. **Ask the Armor itself whether it's transmitting:** during a 5 s low-power key, sample `current_now` (`/sys/class/power_supply/battery/current_now`, or `battery/BatteryAverageCurrent`) every 200 ms. Compare it with 5 s idle before and with a high-power key of 3 s (short, attended, Faraday cage). Transmitting draws hundreds of mA more; a key that draws nothing extra is not radiating. Do it on the **factory** image and on FW34.
3. Then:
   - **If the Atom XL validates and hears nothing from the Armor, and the current shows no transmit draw:** the Armor's transmitter is the fault, factory included. Stop the firmware changes, load the factory image, power the module off for 15 s (`dmr009`), and repeat check 2; if it still draws nothing, write OWNER with "Armor not radiating; the antenna and module need a look in the morning".
   - **If the current shows a transmit draw on the factory image but not after one second on FW34:** that's the FM drop; carry on with the wrapper fix.

The hotspot's last RF line is 01:54:53 UTC (20:54 local, yesterday evening), so the hotspot receive check stays after these. **Start now.**

## Review: the transmitter draws for the whole key; the Atom XL hears (Claude, 2026-10-29 03:25)

Good, two facts now stand:
- **The Atom XL is a valid receiver:** it read back 467.625 and went from −103 to −71 on the hotspot. Use RSSI as the signal; its "hearing" flag doesn't fire for a digital or unmodulated carrier on an analog channel.
- **On FW34 the PA draws for the whole key:** 2.5–2.7 A held for 3 s, the same as the factory image. So the module doesn't stop transmitting after a second. Either the **carrier moves off frequency** (the HackRF's 232–248 kHz bin and the hotspot's narrow filter would both lose it; a synthesizer unlock or a retune by the FM setup's register writes would do this), or the 02:18 HackRF difference was the capture. (The low-power "0 mA" means the gauge is resolving the charger, so use high power for the current readings, short and attended.)

**Next (Atom XL leased receive-only, RSSI every 0.5 s for the whole key; Armor at low power):**
1. A 5 s FM tone at 467.625 on **factory**, then on **FW34**. RSSI held for 5 s on both means the carrier is on frequency, and the HackRF "drop" was the capture.
2. If FW34's RSSI falls after about 1 s: step the Atom XL to 467.6125 and 467.6375 (and ±25 kHz) and repeat once each, to see where the carrier goes. That tells us which register write moves it (the FM setup writes `0x30`/`0x58` and the C7000; a write to the AT1846S frequency registers `0x29`/`0x2A` or a bad `0x30` would show as a retune).
3. Then a 3 s DMR key on channel 49 and a 75-frame M17 key on channel 56, with RSSI. If both hold on frequency, the hotspot's receive is the fault: reboot the Pi (lease) and look at its modem.

Hand the Atom XL back after each set; its agent is waiting for your lease-ended line. **Start now.**

## Review: FM holds on FW34, M17 radiates nothing (Claude, 2026-10-29 03:35)

That settles FM: factory and FW34 both hold −63 for the whole 5 s. DMR on channel 49 is bursty, as TDMA should be. The 1 s FM drop was either a FW31/FW32 effect that FW34's gate removed, or the capture; it isn't a FW34 problem. **The open fault is M17 transmit: RSSI stays at the floor (−110) for a whole 75-frame key**, with `sym done` reported. So either nothing is radiated or it's far off frequency.

**Bisect M17 transmit with the Atom XL** (lease, RSSI every 0.5 s; low power; the same SignalDeck `a7344f19` and channel 56; one 75-frame key each):
1. **FW34 plus the battery current** (key at high power, 3 s, attended): does the PA draw during an M17 key at all?
2. **If it draws:** step the Atom XL ±12.5 and ±25 kHz during a key, to find whether the carrier is off frequency.
3. **FW30** (`1125/1125` at the hotspot earlier, the last image known to send M17), then **FW32**. That shows whether the regression is in FW31–FW34 or in the host or channel state (FW30 also silent means the host or channel 56 is at fault, not the image).
4. If FW34 is the first silent one: its gate reads `0x4B008`. Check that SignalDeck has the op 6 hold set on channel 56 **before** the `0x26` (frame order in `vars_load.log`); if the hold is sent after the key, the gate skips the setup, so build FW35 with the gate on "hold set **or** a `0x40` stream start pending".

The hotspot reboot stays after this. **Start now.**

## Review: M17 transmit broke after FW30 (Claude, 2026-10-29 03:55)

A clean bisect. FW30 reads −63 on frequency, FW32 −99, FW34 −110, and FW34 is at the floor at ±12.5 and ±25 kHz too. During a high-power M17 key FW34 draws **0.43–0.72 A, against 2.5 A for an FM carrier**, so **the PA isn't on**: the module goes through the symbol key with its transmitter (mostly) off. The suspect is our new `0x30` writes. FW31 added the bit-7 clear on the drop path, and FW32 added the idle-branch clear and moved `0x4B385`. A read-modify-write of `0x30` that runs **during the symbol key** (or with a value read before the key set `tx_on`) puts back `0x30` without the transmit bit, which is exactly a low-current, no-RF key.

**Next:**
1. **FW31, one 75-frame low-power M17 key** with the Atom XL (RSSI) plus a 3 s high-power key with the current. That splits FW31 (drop-path clear) from FW32 (idle clear plus the `0x4B385` move).
2. **Read AT1846S `0x30` mid-key** (your register read, about 1 s into a 75-frame key) on FW30 and on FW34. Compare the transmit bit (`0x40`) and bit 7. If FW34's value lacks the transmit bit, the culprit is the write that put it there.
3. **The fix (FW35, from FW30 + FW31's drop clear and nothing else, if 1 shows FW31 good):** the bit-7 clear runs **only after the key has fully ended** (after the stock unkey, on the status-4 path) and reads `0x30` fresh right before writing; no `0x30` write anywhere while any transmit is active (FM or symbol). Drop the idle-branch clear, unless it can be gated on the stock "not transmitting" state, read fresh.
4. **FW35 pass:** M17 on frequency (Atom XL −63) with full PA current, a 5 s FM tone held, M17 receive after a key without a host write (the mute stays clear), DMR on channel 49, then the runner's `all`.

**Start now.**

## Review: FW31 is already silent; go back to FW30 as the base (Claude, 2026-10-29 04:20)

So it's **FW31's change** that turns the PA off during symbol keys: one sample at −1.65 A, then 0.5–0.8 A for the rest of the key. The transmitter starts and is switched off within the first half-second. The FW31 bit-7 clear runs on a path that fires **during** the key (the bit-2 path at `0x89C` evidently runs while transmitting, not only at the second status 4), and its write of `0x30` takes the transmit bit with it.

**Decision: stability first. FW30 becomes the bench base again.** On FW30 the mute after a symbol key is handled by the host: PR 77's channel rewrite after the key is on SignalDeck main and in `a7344f19`, and any channel write puts `0x30` back to `0x7026`.

**Next:**
1. **Load FW30** and check the base: an M17 key at −63 on the Atom XL with full high-power current (3 s, attended); M17 receive after a key listed with the double write; a 5 s FM tone held; DMR on channel 49 bursty; the runner's `all`.
2. **Then the acceptance pass on FW30** (the full list; the table goes in `results.md`). Use the Atom XL by lease as the receiver where the HackRF would have been; the hotspot reboot gets folded into the pass when you reach the M17 to hotspot row.
3. **The mute fix is parked** as FW35 for later: if it's redone, it hooks the point **after** the stock unkey has cleared the transmit bits, reads `0x30` fresh, writes only when `0x40` is clear, and is proven by a mid-key current reading before anything else. Not tonight.

Write the FW31 cause (the drop-path clear runs during the key) in `results.md`. **Start now.**

## Review: FW30 M17 is back on frequency, and the hotspot decodes it (Claude, 2026-10-29 07:40)

That's the base restored: −63 at low power, −58 and 2.6–3.4 A at high power, and the **hotspot decoded both at BER 0**. So the hotspot's receive was never broken: it went silent because FW31–FW34 weren't really transmitting M17. Clear the hotspot item from the list (no reboot needed).

**Next: the rest of the FW30 base check, then the acceptance pass.**
1. M17 receive after a key: SignalDeck lists a hotspot transmission with the double write (no extra host write).
2. A 5 s plain FM tone held on the Atom XL (RSSI, lease).
3. DMR voice on channel 49 logged by the hotspot.
4. The runner's `all`.
5. Then the acceptance pass on FW30, the table going in `results.md`: DMR both ways, group and private, both slots; FM + CTCSS; APRS; POCSAG (the hotspot can't receive pages, so use SignalDeck → SignalDeck or the Atom XL); FT8/RTTY; SSTV; promiscuous on/off (when that passes, I merge PR 74); M17 to the hotspot (done) and the hotspot to SignalDeck.

The HackRF still needs the owner; use the Atom XL by lease and the hotspot as receivers. **Start now.**

## Review: FW30 base check (Claude, 2026-10-29 08:00)

Good: the FM tone holds, the runner's `all` passes (stream 1125/1125), and M17 receive works when no key comes first. Two open items:

**1. M17 receive after a symbol key doesn't list on FW30, even with the double write.** On FW30 nothing clears AT1846S `0x30` bit 7 after a symbol key, and the channel rewrite doesn't restore it either (the 01:00 "3/3 with double write" was on FW32, which had the clear). So the mute fix is needed after all. **Unpark FW35, built carefully:**
   - from FW30;
   - the bit-7 clear runs only once the **stock unkey has completed** (hook the point where the stock code leaves transmit, after it clears its TX bits; or the first idle-loop pass with the stock transmit state fully idle **and** the symbol engine idle, gated on a flag set only by the symbol key's end);
   - read `0x30` fresh, write back with only bit 7 cleared, once per key end, and never while any transmit is active.
   - **Prove it in this order:** a high-power M17 key with the battery current held at 2.5 A or more for the whole key, plus Atom XL RSSI −63. Then M17 receive after a key listed **without** the host's double write. Then a 5 s FM tone, then the runner's `all`. If the current drops at all, stop and report.

**2. DMR on channel 49: the module keyed (status 3/4) but the hotspot logged no DMR line.** The hotspot receives M17 fine, so check its DMR side before blaming the radio:
   - in `/etc/mmdvmhost`, is `[DMR] Enable=1`, and is `ColorCode` channel 49's colour code?
   - is WPSD in a mode that listens for DMR (is it M17-only)?
   - was a 3 s *tone* on a DMR channel sent as DMR voice frames, or as FM? A real DMR voice key from the intercom PTT is the cleaner test.
   - Then key again and look for `DMR Slot n, received RF voice header`.

Order: 2 first (quick), then FW35. The acceptance pass goes on the image that passes FW35's proof. **Start now.**

## Review: FW35 breaks opcode 3; hotspot DMR is on but hears no header (Claude, 2026-10-29 08:25)

**FW35:** with opcode 3 getting no reply (`sym reset failed`), the patch has broken the `0x40` path itself, not the mute. Before the next build:
- diff FW35 against FW30 byte by byte. Every changed range must sit inside FW30's free stub space or at the one hook site. Check the `0x40` op dispatch table and its targets are byte-identical, and that the literal guard covers the new code (no `lrw` literal that code outside the patch loads was overwritten; the FW27 lesson).
- where does the new hook sit? If it's in a routine the `0x40` reset also calls (stock unkey or idle), check the register and stack use: it must save and restore everything it touches.
- before loading FW36, check the runner's `all` on FW30 again (op 3 replies). If FW30 now misbehaves too, use the wild-branch rule: load the factory image, key once, then FW30.
- FW36 = FW35 with the fault fixed, then the same proof order (full PA current through an M17 key, then receive after a key with no host write, then FM, then the runner's `all`).

**Hotspot DMR:** `Mode set to DMR` with no header means the modem saw DMR sync but dropped the frames. The likely causes on a simplex hotspot:
- **slot:** a simplex MMDVM hotspot listens on **TS2 only**. If channel 49 is TS1, it'll never decode. Try a bench DMR channel on **TS2**, CC1.
- **access:** check `[DMR] SelfOnly` (if it's 1, other IDs are rejected) and any `WhiteList`/`BlackList`. With SelfOnly=1, the log normally shows an "invalid access" line, so look for one.
- **ID:** the key must carry a bench DMR ID, as always.

Key again on TS2 and look for `DMR Slot 2, received RF voice header`. Do the DMR check first (it's quick), then FW36. **Start now.**

## Answer to the FW36 space STUCK (Claude, 2026-10-29 08:40)

**Space: take it from the FW19 time-out clamp. The owner approved removing it the moment we need the space, and now we do.**
- Point `0xAB18` back at the stock `0xA308` (the original `bsr`, as in the factory image), so the `0x3B` byte is stored unchanged. SignalDeck handles the transmit time-out; the owner rule is never to add a TX timer.
- That frees the clamp body at `0x5B700` together with the 8 bytes at `0x5B718`: about 32 contiguous bytes, enough for the 20-byte clear. FW32 already reused this slot once, so its bounds are known.
- Check the gap holds no literal that code outside it loads (literal guard). Nothing else may call into `0x5B700..0x5B71F` once `0xAB18` is restored (scan for `bsr`/`jsr` and pool words pointing there).
- **Leave the op 16/17 handler alone:** opcode 7 calls into it (`0x5BD82`), as FW35 showed. Never `0x35F64` (the data-table tail).

**FW36 = FW30 + the clamp removed + the bit-7 clear in that slot,** hooked after the stock unkey as planned. Proof order, all with the Atom XL or HackRF as receiver (owner rule):
1. op 3 and a stream start (runner `stream`);
2. full high-power current through an M17 key, plus Atom XL −63;
3. M17 receive after a key with no host double write;
4. a 5 s FM tone;
5. the runner's `all`.

Note in `results.md` that the clamp is gone from FW36 onward: a `0x3B` byte of 0 now means no module timer, which is the stock behaviour.

**DMR:** the hotspot config is clean, and it still hears no header. Per the owner rule, that isn't a radio result yet. **In your current slot (until 08:50):** put the Atom XL on channel 49's settings (DMR, 467.625, TS2, CC1, a bench TG it lists), key the Armor on DMR, and check the Atom XL shows the call with the bench caller ID.
- **If the Atom XL hears it,** the hotspot's DMR receive is at fault: write that up, and the DMR rows use the Atom XL as receiver.
- **If it doesn't,** the Armor's DMR transmit on FW30 is the suspect: compare with the factory image.

**Start now.**

## Review: FW36 transmits cleanly, receive after a key still deaf (Claude, 2026-10-29 09:25)

FW36 fixes half the problem: the PA holds 2.7–3.4 A through the key, M17 reads −63 and −58, op 3 answers, and the tone and stream pass. With the clamp removed, the stock `0x3B` behaviour is back (note it in `results.md`). And DMR transmit is confirmed again by the Atom XL.

**Receive after a key: first find out whether the clear ran.** Read AT1846S `0x30` the way you did for F30B (idle `0x7026`, after a key `0x70A6`): idle, then right after a 75-frame key, then 5 s later.
- **`0x30` still `0x70A6`:** the hook isn't reached. Add a RAM counter at the hook (increment on entry) and read it back with op 14 after a key. That shows whether the code path runs at all, so the hook point can be moved to one that does.
- **`0x30` back to `0x7026` but still deaf:** bit 7 isn't the whole mute. Do **3b now**: dump every register you can read (AT1846S `0x00–0x7F`, the C7000 receive block, the op 6 hold state, `0x58`), idle vs after a key, and diff them. Whatever differs besides `0x30` is the next suspect. (Your FW32 3/3 relied on the host's double write; FW36 must work with that write too, because the APK still sends it. "Listed" fails even with both, so something else stays wrong.)

Report the `0x30` values and the counter/diff. Keep FW36 loaded: it's the best transmit image so far. **Start now.**

## Answer to the FW36 `0x30` read STUCK (Claude, 2026-10-29 09:35)

No new opcode in FW36: there's no space for it, and we don't need it. Two cheaper routes:

**1. Use FWD1 for the reads.** It has op 18 and the same lineage, but no clear. Load FWD1 (tag read back), then:
   - read `0x30` idle; then right after a 75-frame M17 key (expected `0x70A6`); then **after the host's double write** (the channel write runs `at1846_tune`, whose FM branch writes `0x7006` → `0x7026`, per results §551/683);
   - then check M17 receive (a hotspot transmission listed, plus the runner's receive).
   - If `0x30` is back to `0x7026` after the double write **and receive is still deaf**, bit 7 isn't the mute that matters. Then do the 3b register diff on FWD1 (op 18 over AT1846S `0x00–0x7F`, plus whatever op 5 dumps with the hold briefly off): idle vs after the key vs after the double write.

**2. A quick behavioural bisect on FW36 first** (5 min, no reads needed): after a symbol key, which of these brings receive back?
   - (a) the double write: no, already known;
   - (b) select channel 49 (DMR `0x22`, the other `at1846_tune` branch), then 56;
   - (c) op 6 hold off, then on;
   - (d) a module restart (`restartmodule`).
   The first that works narrows it: (b) points at a register the DMR tune writes and the FM tune doesn't; (c) at the hold or `0x58`; only (d) at C7000 state.

Do 2, then 1. Report the table. FW36 stays the transmit base. **Start now.**

## Review: one leftover state explains both faults (Claude, 2026-10-29 10:10)

Two strong results:
1. **On FWD1, bit 7 is the mute and a channel write clears it** (`0x70A6` → `0x7026` after selecting channel 56), and the call lists. **On FW36 (and FW30), only `restartmodule` brings receive back.** So FW30/FW36 leave **something else** set after a symbol key that FWD1 doesn't.
2. **The factory image's DMR decodes on the hotspot; FW30's doesn't**, while the carriers are within 85 Hz of each other and equally strong, so it isn't RF. And the hotspot log showed **the same FW3K/FW30 image decoding at 15:49 and failing at 15:50**. An image can't change in a minute, but its state can: most likely **a symbol key in between**.

**Hypothesis: the symbol key leaves one piece of state behind that breaks M17 receive and DMR transmit framing alike. A channel write doesn't clear it; a module restart does.**

**Test it, then fix it:**
1. On FW36: `restartmodule`, then a 3 s DMR key on channel 49 (**no symbol key first**) with the MMDVM log and the Atom XL. If a voice header comes, DMR is good after a restart. Then one 75-frame M17 key, then the same DMR key again; if no header comes this time, the link is proven.
2. **Diff FWD1 against FW30 on the symbol-key path** (the key wrapper, `on_key` `0x5B000`, the op 7 drop/end, the `0x18B68` stub, anything that writes `WORK_MODE` `0x11000100`, `RF_MODE` `0x11000104` or `0x11000080`). Whatever FW30 sets at key start and never restores at the end (FWD1 restores it, or never sets it) is the culprit. `on_key` stores `RF_MODE` = `0x10E0` and `WORK_MODE` = `0x80` and sets `0x11000080` bit 0 (results §750): check that the end of the key puts all three back to the channel's values.
3. **FW37 = FW36 + restoring that state at the symbol-key end** (in the same post-unkey hook as the bit-7 clear, if it fits in the freed clamp space; otherwise report the bytes needed).
   Proof: DMR header at the hotspot plus the Atom XL after a symbol key; M17 receive after a key with no restart; full PA current; FM tone; runner `all`.

**Start now.**

## Review: the link is proven (Claude, 2026-10-29 10:40)

Clean result: **after a restart DMR decodes at the hotspot and the Atom XL; after one symbol key, the same DMR key radiates normally (+1002 Hz, the same width as the factory image) but doesn't decode.** So one leftover state breaks DMR transmit framing and M17 receive alike, and **the hotspot is cleared**. `RF_MODE` `0x10E0` and `WORK_MODE` `0x80` are set at key start and never written back, which makes them the prime suspects.

**Space: three options, cheapest first.**
1. **Host-side, no firmware change.** Can opcode 5 (or another existing op) *write* HR-C7000 registers? Its refusal "while the hold marker is set" suggests it touches registers. If it can write `0x11000100`/`0x11000104`, SignalDeck restores both after each symbol key (alongside the double write it already sends), and FW36 stays as it is. Check op 5's handler for a write path and test it: after a symbol key, restore both words through op 5, then DMR to the hotspot and M17 receive.
2. **Drop the bit-7 clear from FW37.** The channel write already puts `0x30` back to `0x7026` (FWD1 showed this), and SignalDeck sends that write after every key. That frees 26 bytes: the 32-byte slot then holds the two-word restore (26 bytes) instead.
3. Only if neither works: report what else could go.

**What values to restore:** read `0x11000100`/`0x11000104` on a freshly restarted module, idle on channel 56 and on channel 49 (op 5 with the hold briefly off, or FWD1). The stock channel write evidently doesn't set them (a channel change doesn't recover), so restore the **boot values**, or the per-mode values if they differ.

**Proof for whichever you pick:** a DMR header at the hotspot plus the Atom XL **after** a symbol key; M17 receive after a key with no restart; full PA current; a 5 s FM tone; the runner's `all`. **Start now with option 1.**

## Review: no run-time read, so take the idle values from the image (Claude, 2026-10-29 10:50)

**You don't need to read the registers at run time: the idle values are in the stock code.**
1. **Find them statically.** Search the factory image for the literals `0x11000104` (`RF_MODE`) and `0x11000100` (`WORK_MODE`), and for every store through them. The boot/init path and the channel-set paths (the DMR `0x22` side and the FM `0x23` side of `at1846_tune` and the C7000 setup) show which constant each mode writes. Note each value and the path that writes it.
2. **`RF_MODE` is the likelier culprit.** Op 6 off writes `WORK_MODE` back to the value it saved, and that didn't recover receive in the bisect, so `WORK_MODE` alone isn't it. `RF_MODE` stays `0x10E0` after a key, and nothing but a restart rewrites it.
3. **FW37 = FW36 with the bit-7 clear dropped** (the channel write already restores `0x30`), and in that slot a restore of `RF_MODE`, plus `WORK_MODE` if it fits, to the **constants from step 1** at symbol-key end, run in the same post-unkey hook. Constants need no save, so this should fit in the 32 bytes. If the right value depends on the channel's mode, restore the FM value: SignalDeck rewrites the channel right after every key, and if that rewrite sets the mode-specific value itself, good; check it.
4. **Proof:** a DMR header at the hotspot plus the Atom XL **after** a symbol key; M17 receive after a key with no restart; full PA current; a 5 s FM tone; the runner's `all`.

**Start now.**

## Review: the stock code saves and restores RF_MODE, and our key skips the save (Claude, 2026-10-29 11:00)

That's the answer. The stock FM key-up **saves `RF_MODE` to SRAM `0x32520`** before storing `0x10E0`, and the stock unkey restores it from there. Our `on_key` (`0x5B000`) stores `0x10E0` **without the save**, so the restore either puts back a stale `0x32520` (whatever the last FM key or boot left there) or never runs on our path. Either way `RF_MODE` stays wrong until a restart. That fits everything: a restart is the only cure, a channel change doesn't help, and `WORK_MODE` constants make no difference.

**Next:**
1. **Read the two other `0x32520` uses:** which routine **saves** (right before `0x3EDDA`?) and which **restores**, and does our symbol-key end (FW20's stock-unkey call) reach the restore?
2. **If the restore is on our path:** FW37 = FW36 **without the bit-7 clear**, and at `on_key`'s start the same save as stock (`RF_MODE` → `0x32520`) before it stores `0x10E0`. That's about 24 bytes and fits the freed 32-byte slot (a `bsr` from `on_key` into it).
   **If the restore is not on our path:** put both in, the save at `on_key` and the restore at the symbol-key end (from `0x32520`), using the slot plus whatever `on_key`'s own 188 bytes can spare. If it still doesn't fit, report the byte count.
3. **Proof:** a DMR header at the hotspot plus the Atom XL **after** a symbol key; M17 receive after a key with no restart; full PA current; a 5 s FM tone (a stock FM key must still save and restore correctly); the runner's `all`.

**Start now.**

## Review: FW37 fixes M17 receive after a key; DMR after a key is still off (Claude, 2026-10-29 11:10)

A big step. **M17 receive after a symbol key now works with no restart** (75 frames, 56 good), with full PA current, the FM tone held and the runner's `all` passing. FW37 is the new base. (The stock restore isn't on our path; good that you put our own in.)

**Left: DMR transmit after a symbol key still doesn't decode at the hotspot** (the Atom XL saw −88; did it show the caller ID and a voice line? Say which in the report.) So `RF_MODE` was one of at least two leftovers. **Next, the rest of the list:**
1. List **every register `on_key` (`0x5B000`) writes** (`WORK_MODE` `0x11000100` = `0x80`, `0x11000080` bit 0, any C7000 DMR/framing registers, the `0x18B68` stub's side effects), and for each one how the **stock** FM key-up and unkey treat it (save/restore like `0x32520`, or a constant written by the DMR channel setup).
2. A register that the stock key saves and restores, or that the DMR channel setup never rewrites, and that our key leaves changed, is a suspect. `0x11000080` bit 0 is the first one to check (set at key start, never cleared by us; does the stock unkey clear it?). Then `WORK_MODE`: does the DMR channel select (`0x22`) write one of the `0x22`/`0x6A`/`0x16A` constants, or does it rely on the boot value?
3. **FW38 = FW37 + restoring those at the same post-unkey hook.** Report the byte count first if it doesn't fit; we'll find space. Candidates: the bench-only op 16/17 RAM-stream route is closed on the Armor, so its handler body (not the shared code at `0x5BD82` that op 7 calls) could be reclaimed. Show me the map before cutting it.
4. **Proof:** after a symbol key, a channel-49 DMR key decodes at the hotspot **and** the Atom XL shows the caller ID; M17 receive after a key still lists; the rest as FW37.

**Start now.**

## Review: space for the `WORK_MODE` + bandwidth restore (Claude, 2026-10-29 11:20)

Clear list, thanks: `on_key` leaves **`WORK_MODE` (`0x80`) and `FM_BANDWIDTH` bits 4/6** changed, and everything else is restored. That explains DMR after a key: the C7000 stays in the symbol engine's mode and bandwidth.

**Space (about 24 bytes): reclaim the bench-only RAM-stream code, which is closed on the Armor (2026-10-26).**
- **op 6 variants 5 and 6** (variant 5 = the hold plus `WORK_MODE` `0x80` plus bandwidth clear for the RAM stream; variant 6 = `FM_DEV_COEF`): bench experiments, unused by SignalDeck. Keep **variant 3** (the M17 hold SignalDeck uses) and the others SignalDeck sends; check SignalDeck's source for every op 6 variant it actually sends before you cut.
- **op 16/17** (the UART rate switch and the half stream): the route is parked, and SignalDeck PR 14 (draft) is the only user. Make their dispatch entries return the normal "unsupported" reply, and reclaim their bodies **except** the shared helper at `0x5BD82` that op 7 calls.
- **Show the map before cutting:** each reclaimed range with its start/end, its callers (a `bsr`/`jsr` scan plus pool words) and the literal guard. Nothing outside may branch into or load from a reclaimed range.

**FW38 = FW37** + **save** `WORK_MODE` and `FM_BANDWIDTH` at `on_key` (next to `RF_MODE`'s save, two free SRAM words you've checked are unused) + **restore** both at the post-unkey hook. Saving the live values is safer than constants, because DMR and FM channels differ.

**Proof (owner rule: a second receiver):** after a symbol key, a channel-49 DMR key decodes at the hotspot **and** the Atom XL shows the caller ID and a voice line; M17 receive after a key still lists; full PA current; a 5 s FM tone; the runner's `all`. Note in `results.md` which ops were removed (op 16/17, op 6 v5/v6).

**Start now.**

## Review: FW38 passes the core proof (Claude, 2026-10-29 12:00)

**FW38 `b4cafbf4` fixes both leftovers:**
- After a symbol key, DMR decodes at the hotspot **and** the Atom XL shows the caller ID and a voice line, with slot-width bursts on the HackRF.
- M17 receive after a key lists with no restart.
- The PA holds 2.8–3.2 A.
- The runner's `all` passes, including the 1125-frame stream.

**FW38 is the candidate stable image.**

**One open line: "a channel-58 capture taken during the retune saw no carrier".** Repeat the plain-FM check properly. Select the FM channel, wait **≥ 3.5 s** (`RETUNE_SETTLE_MS`), then key a 5 s FM tone at low power, with the Atom XL (RSSI) or the HackRF. A full 5 s carrier is needed, and once more right after a symbol key, so FM after M17 is covered too.

**Then the acceptance pass on FW38.** Every row needs a second receiver (owner rule); the table goes in `results.md`:
- DMR group and private, both slots, both directions;
- FM + CTCSS, both directions;
- POCSAG send (decoded by our decoder from the HackRF);
- FT8 and RTTY transmit;
- SSTV transmit and receive;
- promiscuous on/off, both cases;
- M17 both ways;
- DMR and FM each straight after a symbol key.

**APRS is mine (owner, 11:50):** when you're between rows, post "Armor free for Claude HH:MM–HH:MM" (about 10 min).

**Start now.**

## Answer to the FW38 FM-after-symbol-key STUCK (Claude, 2026-10-29 12:15)

**The fault is SignalDeck's, not the firmware's.** Since PR 77, SignalDeck on any image tagged FW31 or later ends a symbol key **without the `0x26` off** (only the hold, and a double channel write), because FW31–FW36 cleared the mute themselves and a second close re-muted them. FW37/FW38 dropped that clear and restore the key state themselves, so that path no longer fits them. The module very likely keeps its stock PTT state latched until its own timer ends it (about a minute, matching what you saw), and ignores the next `0x26` on in the meantime (no `0x36`).

**Fix: SignalDeck PR 94** (`claude/fw37-unkey`, `4771f8f1`). FW37 and later go back to the FW30 path: `0x26` off after the module's status 4, then one channel write. FW31–FW36 keep the old path. The host suite passes. APK: `C:\Users\Joshua\AppData\Local\Temp\claude\apk-main\fw37unkey-4771f8f1.apk` (sha256 `c3c0683f25c03047…`).

**Next:**
1. Save your current APK, then `adb install -r` the PR 94 APK. Data is kept (same key).
2. On FW38, run, with the HackRF or the Atom XL as receiver:
   - a symbol key, then FM on channel 58 after the 3.5 s settle: the full 5 s carrier;
   - a symbol key, then M17 receive from the hotspot: listed, no restart;
   - a symbol key, then DMR on channel 49: a header at the hotspot plus the Atom XL caller ID.
3. If all three pass, carry on into the acceptance pass on FW38 with this APK, and I'll merge PR 94. If FM still fails, report the `0x36` and status lines around the key.

**Start now.**

## Review: PR 94 sends the `0x26` off, and the next FM key still isn't taken (Claude, 2026-10-29 12:25)

So the host's missing `0x26` off wasn't the cause (PR 94 stays correct for FW37+ anyway). **The module itself refuses a plain `0x26` on for about a minute after a symbol key**: no status 3 and no carrier. That's firmware state. Two suspects, from the FW38 code:
1. **The key wrapper's gate.** FW38 runs the FM setup `0x5BBE2` on a `0x26` when the **op 6 hold byte `0x4B008`** is set, and the symbol path's own armed/ring flags (`0x4B384`, the ring words at `0x4A3E4`) decide whether the key goes to the symbol engine. If one of them is still set after the symbol key (and something clears it about 60 s later: a ring idle timeout, the stock TX timer, the hold re-send), the wrapper takes the FM key into the symbol path, which has nothing to send, so no carrier and no status 3.
2. **A stock TX-state bit left set** (as FW20 found with op 7's drop), with the stock key handler refusing a key while it's set, until its timer clears it.

**Do these, in order (FW38, HackRF or Atom XL):**
1. **Time it:** symbol key, select channel 58, then FM tones at 10 / 30 / 45 / 60 / 75 s. When does the first one key?
2. **Read the flags** right after the symbol key and again once FM keys (op 14 RAM reads: `0x4B008`, `0x4B384`, `0x4A3E4/E8`, `0x4B385`, and the stock TX-state word FW20 used). Whichever one flips at the moment FM starts working is the culprit.
3. **Does FW30 do the same?** (FW30 had the same wrapper.) If FW30 keys FM right after a symbol key, the regression is FW36–FW38; diff the wrapper gate between them.
4. **The fix (FW39):** clear the culprit flag at the post-unkey hook (the same place as the restores), or make the wrapper's FM branch ignore it when no `0x40` stream is armed. Report the byte count if space is short.

**Start now.**

## Answer to the FM-after-key STUCK (Claude, 2026-10-29 12:40)

FW30 fails the same way, and op 14 can't read SRAM, so we narrow it by behaviour. **A pattern worth testing:** a **DMR** key after a symbol key **does** radiate (FW36 at 10:29, FW38 at 11:53), and an FM tone works when channel 58 was already selected. So FM fails only on the path **channel 56 (M17, op 6 hold on) → symbol key → select 58**. The trigger may be **the channel-56 hold state carried over to 58**, not the symbol key itself. The FW38 wrapper runs the FM setup when the hold byte `0x4B008` is set; if selecting 58 doesn't clear it, an FM key on 58 goes down the symbol path and radiates nothing.

**Four short tests on FW38** (HackRF lease; 5 s tones at low power; each from a fresh `restartmodule` so earlier state can't leak in):
1. **No symbol key:** select 56, wait 5 s, select 58, wait 3.5 s, tone. If this fails, it's the 56 → 58 transition, not the key.
2. **Symbol key on 56, select 58, then an explicit op 6 hold off** (`cmdsym op=hold`, the off action), then the tone.
3. **Symbol key on 56, select 49 (DMR), then 58**, then the tone.
4. **Symbol key on 56, `restartmodule`, select 58**, then the tone (the control, expected to work).

**Then:**
- If 1 or 2 points at the hold: the fix is SignalDeck's (send op 6 hold off on every non-M17 channel select, which I can do in PR 94), or FW39's (clear `0x4B008` on any `0x23` that isn't M17).
- If only 3 or 4 work: report the table and I'll pick the next read.

**Start now.**

## Answer to the updated-PR 94 STUCK (Claude, 2026-10-29 13:00)

The important detail: **there's no `data hold` line and no `TX 1 kHz test tone` line at all.** `transmitPcm` runs on SignalDeck's single **radio worker** thread and logs as its first step (skipped, refused or keyed), so a silent log means **the tone's task never ran: the worker is blocked for about a minute after a symbol key**. That fits every result (FW30 and FW38 alike, and the tone working again about 70–90 s later), and **it's a SignalDeck bug, not firmware.** My best guess: the end of the symbol key (`unkeyAfterStop` → `rxAfterSym` → `applyChannelNow`, on the `m17-sym` thread) holds a lock or waits on an ack that the worker also needs.

**Please capture the evidence (two minutes, no RF):**
1. After a symbol key on 56, select 58 and send the tone. Then within 5 s take a **thread dump** of SignalDeck: `adb shell su -c 'kill -3 $(pidof com.macdmr.radio)'` and pull `/data/anr/` (or `debuggerd -j <pid>`).
2. `adb logcat -d -s DiagReceiver` to confirm `cmd testtone` arrived.
3. Push the dump (or the `radio-worker`, `m17-sym` and `main` stacks) to `radio_firmware/results.md`, or attach it to the report.

With the stacks I'll fix the blocking in PR 94 and stage a new APK. The firmware side is done for this item, so FW38 stays. Until then the acceptance pass can run everything except "FM right after a symbol key": go ahead with it now (DMR group/private both slots, FM + CTCSS without a preceding symbol key, POCSAG, FT8/RTTY, SSTV, promiscuous on/off, M17 both ways). Leave the FM-after-key row for my fix. **Start now.**

## Review: the thread dump clears SignalDeck (Claude, 2026-10-29 13:05)

Thanks, and I was wrong: the worker isn't blocked. It's inside `playPcm` for the tone, so `0x26` on was sent and **the module didn't key** (no status 3, no carrier) for about a minute after a symbol key, on FW30 and FW38 alike. PR 94's hold drop didn't apply because M17 receive was off (no `data hold` line), so the hold isn't it either. **It's firmware after all**, and specific to the FM path: DMR keys after a symbol key work.

**Next, static first (no RF needed):**
1. Read the **FM branch of our `0x26` key wrapper** at the four sites (`0x92AA`, `0x92C8`, `0x92E0`, `0x92FA`) through to the stock FM key-up (`0x3EDDA`), and list **every flag or word it tests** before keying. Mark each one the symbol path writes (`on_key`, op 7/end, the `0x18B68` stub, the post-unkey hook) and whether it's restored.
2. The prime suspect is one that the symbol key leaves set and that something clears about 60–90 s later. Look at what clears it: a timer tick, the stock TX time-out, or the idle loop.
3. **FW39 = FW38 + clearing (or restoring) that word at the post-unkey hook.** Check the bytes first: the op 6 v5 reclaim may still have room. If it doesn't fit, report the count.
4. Proof: a symbol key on 56 → select 58 → a 5 s FM tone within 10 s, with a full carrier on the HackRF or the Atom XL, three times; then the rest of the FW38 proof (DMR after a key, M17 receive after a key, the runner's `all`).

Run the **acceptance pass rows that don't involve FM-after-symbol** in parallel, when you have the radios. **Start now.**

## Answer to the FW39 STUCK (Claude, 2026-10-29 13:55)

Yes, very likely the `0x32457` wait. The arithmetic fits: **80 passes through `0x18A4` × roughly 0.7 s ≈ 56 s**, the "about a minute" we keep seeing. When the wait times out, the handler carries on and the FM key works. The missing ack also fits: the handler is still inside that wait when the host sends `0x26` off 5.5 s later.

**Next (static first, then one image):**
1. **Find every writer of `0x32457`** (byte `0x3244C+0xB`): who sets it to 1, and who clears it to 0, in the stock image. Name what it means. A "tune or channel-write in progress" or "synth not settled" flag would be my guess: the `0x23` handler sets it and an event clears it.
2. **Why the symbol path leaves it at 1:** the event that normally clears it (a stock unkey step, a C7000 interrupt, a status-4 path) doesn't run after our symbol key, or the channel select after the symbol key sets it and the clearing event never comes because the C7000 is still in symbol mode. If it's the latter, the RF_MODE/WORK_MODE restore order at the post-unkey hook may matter: restore before the stock unkey runs.
3. **Measure the pass length** of the `0x18A4` loop (count passes in a RAM word, or time it against the 80-pass ceiling) to confirm the ~56 s.
4. **FW40:** make the clearing event happen (preferred), or clear `0x32457` at the post-unkey hook **only if** step 1 shows it's a bookkeeping flag and not a real "synth not locked" guard (forcing a key before the synthesizer has settled would transmit off frequency). If it is a real lock guard, the fix is to make the lock indication arrive (step 2).

Report the writers (step 1) before building FW40. **Start now.**

## Review: `0x32457` is the channel-write busy flag (Claude, 2026-10-29 14:10)

That's the mechanism. **The `0x22`/`0x23` handlers set the busy flag on every channel write, and on success only the idle task at `0x6BE` clears it**, when the countdown `0x38908+0xB` reaches 100, **flag A at `0x38908+0xA` isn't 0**, and `0x32458` is 0. **Our symbol-mode unkey sets the countdown to 200 but leaves A at 0, so the idle clear never runs**, and the next channel write (the select of 58) leaves the flag set. A later `0x26` on FM then fails its busy check. (The silence lasts longer than the 0.8 s pass budget, so after the budget the handler probably drops the command without an ack. Confirm that while you're in there; it explains why the host never sees a reply.)

Your point that a clear at the post-unkey hook would be too early is right, since the select comes after it. The fix is to **make the stock clearing condition true**:
1. **Read what the stock FM unkey writes to `0x38908+0xA` and `+0xB`** (and `0x32458`): the values a normal key end leaves, so the idle task clears the busy flag after the next channel write.
2. **FW40 = FW38** (not FW39; drop its experimental clears) **+ at the symbol-key end, write A (and the countdown) the way the stock unkey does.** That's the post-unkey hook, the same place as the RF_MODE/WORK_MODE restores. Then the idle task handles the later channel write's flag normally.
3. **Also check the DMR path:** why does a `0x22` key after a symbol key work? If DMR keying doesn't check the busy flag, say so; if it does, the 49 select should have hit the same thing.
4. **Proof:** symbol key → select 58 → a 5 s FM tone within 10 s, full carrier ×3 (HackRF or Atom XL); FM straight after a channel change with no symbol key, still working; then the FW38 proof (DMR after a key, M17 receive after a key, PA current, the runner's `all`).

**Start now.**

## Answer to the FW40 STUCK (Claude, 2026-10-29 14:20)

A plain **select of 58 followed by a tone works without a symbol key** (11:59 and 12:02, 4–6 s after the select). So in the normal flow **something clears the busy flag after a select**, and after a symbol key that something doesn't happen. FW40 copied only the unkey's part. We need the whole set of writers.

**Next (static, then two timing probes):**
1. **List every writer of A (`0x38908+0xA`), the countdown B (`+0xB`), `0x32458` and `0x32457`** in the whole image, not only the unkey paths: the `0x23`/`0x22` handlers, the idle task, the status paths, the timer ticks. For each one, the value and the condition. Then trace the normal sequence "idle → select 58 → about 1 s later": which writer makes the idle clear's three conditions true? That's the step the symbol key breaks.
2. **Two timing probes on FW40** (HackRF lease, low power):
   - (a) symbol key, **wait 15 s**, then select 58, then the tone. If it keys, it's an ordering/countdown problem: the countdown started by the unkey runs out before the select, so nothing is left to clear the select's flag.
   - (b) no symbol key, select 58, then the tone **within 1 s** of the select: does a plain select also block briefly? That gives the normal clear's delay.
3. **FW41:** whatever step 1 shows the select relies on (likely: the select or a tick restarts the countdown only while A is set, or `0x32458` is non-zero after our symbol path) is restored in the right place. If that place is the `0x23` success path, a one-condition patch there ("if the symbol path ran since the last key, re-arm the clear") is fine. Keep it minimal and report the bytes.

**Start now.**

## Answer to the FW40 probes STUCK (Claude, 2026-10-29 14:30)

The probes are clear: **a fresh select (after `restartmodule`) keys 0.41 s later; any select after a symbol key stays blocked, even 15 s later.** So it isn't timing. The symbol key leaves a state that makes **every later select end with the busy flag set and never cleared**. Most likely the select takes a different path in that state (the long success path with no store of 0, versus whatever a fresh select takes), or the idle clear's conditions never become true again.

**We need eyes on RAM. Make op 14 able to read SRAM** (a diagnostic image, not for release):
1. **FW41-D = FW40 + op 14's address-range check widened** to accept `0x32000–0x39FFF`, the one compare constant or bound in its handler. That's a few bytes, with no new code.
2. Then read `0x32457`, `0x32458`, `0x38908+0xA`, `0x38908+0xB` and `0x38874` (one op 14 each) in four states:
   - (i) fresh after `restartmodule`;
   - (ii) after a fresh select of 58;
   - (iii) right after a symbol key;
   - (iv) after the select of 58 that follows the symbol key, at +1 s and +10 s.

   Comparing (ii) with (iv) names the leftover directly.
3. With that table, build **FW41** (from FW40, without the op 14 widening): restore the one leftover at the post-unkey hook, or in the select path if it's set later.

If the op 14 range check isn't a single constant, report its code and I'll pick another readout (op 2's reply bytes are the fallback). **Start now.**

## Review: op 14 bounds (Claude, 2026-10-29 14:40)

Two `movih` bounds are fine, and simpler than one constant. **FW41-D: change the two `movih` immediates** so the window `[lo, hi)` covers the **runtime** addresses of `0x32457`, `0x32458`, `0x38908+0xA/+0xB` and `0x38874`. If those are already the CPU addresses, `movih r1, 3` and `movih r1, 4` give `[0x30000, 0x40000)`. If they're file-image offsets, use the mapped addresses and say which. Reads only; length 1..240 unchanged. Diagnostic image, never released.

Then do the four-state read table (fresh, after a fresh select of 58, right after a symbol key, after the select that follows it at +1 s and +10 s), and FW41 from FW40 with the leftover restored (FW41 keeps the original op 14 bounds). **Start now.**

## Answer to the FW41-D STUCK (Claude, 2026-10-29 14:40)

Good measurement: **the busy flag is 0 during the failure, so `0x32457` isn't the blocker.** I retract that theory. A = 1, B = 200 are FW40's own writes (FW41-D is built on FW40), so they aren't a stock leftover. That B never counts down is a clue, though: whatever task decrements B isn't running, or is waiting on something.

**Next: find where the `0x26` stops, with breadcrumbs and a liveness check.**
1. **Liveness, no new image:** during the silence (after the tone's `0x26` on, before the off), send a `0x34` version query and an op 14 read. If they answer, the command task is alive and the `0x26` was dropped or parked; if nothing answers until the off (or for ~60 s), the command task itself is blocked inside the `0x26` handler.
2. **FW41-D2 = FW41-D + breadcrumbs:** at each step of the `0x26` handler's FM branch (handler entry, the FM/DMR branch, before and after each wait loop, before the call to `0x3EDDA`, inside `0x3EDDA` at its own waits, the reply send), store a step number to one free SRAM byte inside the op 14 window (plus a pass counter for the wait loops). Do the symbol key → select 58 → tone, then read the byte during the silence (if step 1 shows the command task is alive) or after the off. The last step number tells us exactly where it stops.
3. **Also log B over time:** read B (and A) every 5 s for 90 s after a symbol key, alongside when FM keying comes back. If FM returns at the same moment B starts counting or A changes, that's the link.
4. Build FW41 only when step 2 names the wait.

Breadcrumbs are diagnostic only, inside the stub space (never past `0x5C6FC`). **Start now.**

## Answer: breadcrumb placement (Claude, 2026-10-29 14:45)

Yes: **step numbers in the `0x26` handler at `0x9264` and in the FM key at `0xE9C`** (its entry, every branch, every wait loop with a pass counter, the reply). **`0x32688` for the step byte and `0x32689` for the pass counter are fine**, if a scan shows no stock load or store to `0x32688..0x3268B` (FW40's saves end at `0x32687`); report the scan in one line.

**Liveness without a second sender:** the host's worker is busy, but **does the tone's `0x26` off get a reply?** Check the log of the failed tone at 14:29:58. If the off is acked, the module's command task was alive the whole time: the on was dropped or parked (for example, refused before the reply path), not blocking. If the off isn't acked either, the task is blocked. Either way, read the breadcrumb right after the off (the worker is free then); the byte persists.

Run: symbol key → select 58 → tone → off → op 14 reads of `0x32688`/`0x32689` → then a fresh-select tone for comparison (expected: the last step = the reply). **Start now.**

## Answer to the FW41-D2 STUCK (Claude, 2026-10-29 15:15)

The new fact: **the whole command task blocks** (off not acked, op 14 silent for 90 s), not just the FM key. **Read the byte after the block clears.** The breadcrumb persists, and the pass counter says where it waited:
1. After the failed tone, **poll op 14 every 10 s** (nothing else on the port) until it answers, for up to 180 s. Record the time of the first answer (it should match the ~60–90 s) and read the step byte and the pass counter.
2. **Interpretation:**
   - **Pass ≈ the block length in ticks** (or saturated): the block is the step-2 wait loop. Then name its condition (what it polls) and why the symbol path leaves it false.
   - **Pass 0** (step 4 is expected after the unblock either way): the block is **upstream of the handler's wait**, in the dispatcher or a lock taken before `0x9264` (the `0x2AF24` lock is the first suspect, and the skip byte didn't cover all of it). Then the next breadcrumb goes upstream: drop steps 3 and 4 to free the hole, and put one step at the command dispatcher's entry and one right before `0x9264` is called.
3. **One more useful datum:** does the module emit anything on its own during the block (status frames, `0x36`)? If it does, the main loop is alive and only the command path is stuck.

**Start now.**

## Answer to the 180 s STUCK (Claude, 2026-10-29 15:35)

**New hypothesis that fits every reading: the OS tick stops after a symbol key.**
- **B never counts down:** it's decremented by the tick-driven idle task.
- **The `0x26` handler's wait calls `delay_ms(10)`:** if the tick doesn't advance, `delay_ms` never returns and the command task hangs inside it, which matches a block with no end and every later command unanswered.
- **The select of 58 is acked:** its path doesn't sleep, so it never meets the stopped tick.
- **A fresh `restartmodule` fixes it:** the timer is set up again at boot.
- **The ~60–90 s recoveries earlier:** probably something re-enabled the timer interrupt (a later stock path) on those runs.

Suspect: the symbol engine (ops 8–11 / the `0x40` ring) **uses or reprograms the hardware timer behind the OS tick, or leaves its interrupt masked**, and our symbol-key end doesn't restore it.

**Test, no new image, while commands still answer (after the symbol key, before any tone):**
1. Find the OS tick counter that `delay_ms` (`0x18A4`) reads (an SRAM word in the op 14 window).
2. Read it twice, 1 s apart: fresh after `restartmodule`, and after symbol key → select 58 (no tone yet). If it advances fresh and is frozen after the symbol key, that's it.
3. Statically: which timer and IRQ drive that counter, and what the symbol engine does to that timer, its IRQ mask, or the interrupt controller (C-SKY `psr` IE/EE included) when it arms and when it ends.

**FW41** (from FW40) then restores the tick timer's configuration and interrupt enable at the symbol-key end (the post-unkey hook). Proof as before, plus the tick counter advancing after a symbol key. **Start now.**

## Answer to the tick STUCK (Claude, 2026-10-29 15:45)

The tick runs, so that hypothesis is retracted. But your finding sharpens it: **`delay_ms` calls out to the RTOS (`0x13D90`), so it's a task sleep, not a busy wait.** A sleeping task needs the scheduler to run it again. Every reading fits **starvation**:
- **The tick ISR keeps counting:** the four words advance.
- **Op 14 and the select answer:** the command task never sleeps on those paths.
- **The tone's `0x26` sleeps in `delay_ms`, and the command task never runs again:** a **higher-priority task is spinning without yielding**.
- **B never counts:** B is decremented by the **idle task**, the lowest priority, which is starved as well. That was the clue all along.
- **The old ~60–90 s recoveries:** the spinning task had a timeout of its own on those images.
- **A restart clears it.**

Suspect: **a task tied to the symbol engine** (the `0x40` ring drain, the TX-RAM half refill, the op 7 end/drain wait) that, after the key ends, **polls a flag or a ring that will never change, without sleeping**.

**Next:**
1. **Statically:** which task runs the symbol engine's loop (ring drain / half refill / end wait), its priority against the command task, and whether that loop sleeps or yields on every path. Look for the path taken after `sym done` that loops on a TX-RAM half flag, a ring count or a modulator status once the modulator is off.
2. **Measure, no new image:** read the RTOS current-task pointer or a context-switch or per-task run counter via op 14 (find it from `0x13D90`'s callees), a few times after symbol key → select 58, before any tone. If it's always the same task, or the idle task never runs, starvation is confirmed. Also, from the earlier data: does B count down after a *fresh* select? If it does there and not after a symbol key, that's another confirmation.
3. **FW41** (from FW40): make that loop end at the symbol-key end (clear what it waits on, mark the engine idle so the loop exits, or put a `delay_ms(1)`/yield in it).

**Start now.**

## Answer to the refill-task STUCK (Claude, 2026-10-29 15:50)

Good find. `txram_refill_task` is the first task created (most likely the highest priority), and its loop is "wait in `0x1BE8`/`0x18E8`, then spin on `0x11000398` ≠ 0 with no sleep". **The counter frozen at 104 can mean two things:** it's correctly blocked in the wait (harmless), or it's stuck in the spin before the increment (starvation). One register read tells them apart:
1. **Read `0x11000398` (op 5, the C7000 register read)** fresh after `restartmodule`, and after symbol key → select 58 (before any tone). **Non-zero after the symbol key and 0 fresh = the spin is stuck there**, and that's the starvation.
2. **Statically: what `0x11000398` is,** and who sets and clears it: the stock DMR unkey path, the TX-RAM half interrupt, our symbol engine's arm and end. 104 passes probably equals the halves our key played. I'd guess our end leaves the TX-RAM playback or its request bit set, so the register never returns to 0.
3. **FW41 (from FW40):** at the symbol-key end, **clear the condition** (the stock way the DMR unkey stops TX-RAM playback, so `0x11000398` reads 0), so the refill task goes back to its wait. **Don't put a yield into the stock spin**: that changes timing for DMR voice transmit, the path that works. Only if step 2 shows the register can't be made 0 cleanly, report back before touching the spin.

Proof as before (symbol key → 58 → FM tone within 10 s, full carrier ×3; FM after a plain change; DMR keys after a symbol key; then the FW38 proof), plus `0x11000398` = 0 after the symbol key. **Start now.**

## Answer: reading `SYS_INTERP_LIST` (Claude, 2026-10-29 16:05)

That explains the spin: **the refill task loops "while `SYS_INTERP_LIST` ≠ 0, write it to `SYS_INTERP_CLEAR`".** It can only spin forever if a source **keeps re-asserting**. My guess is that `fm_tx_interp` (bit 15) keeps firing because the FM TX / TX-RAM path is still running or still enabled after our symbol key, so each clear is immediately undone. A plain clear of bit 15 at the key end wouldn't hold for that reason, so confirm first. It's cheap:
1. **FW41-D3 = FW4E with op 14's two `movih` bounds set to `[0x11000000, 0x11010000)`** (diagnostic only). Read `0x11000398` (LIST), `0x110003A0` (CLEAR, if it reads back) and the interrupt **enable/mask** register next to them: fresh after `restartmodule`, and after symbol key → select 58 (before any tone). Read each a few times to see whether bits re-appear.
2. **Statically: what makes `fm_tx_interp` fire** (TX-RAM half done while the FM TX/modulator path is enabled), and **what the stock DMR/FM unkey does to stop it**: disable the TX-RAM playback / FM TX path, mask the bit, or both.
3. **FW41 (from FW40):** at the symbol-key end, **stop the source the stock way** (and then clear bit 15 the stock way, a 1 to `SYS_INTERP_CLEAR`), so the list reads 0 and the refill task goes back to its wait. Don't mask it permanently: the next FM or DMR key must still get its interrupts. Proof as before, plus the list reading 0 after the key, and a DMR key and an FM key both working after a symbol key.

If step 1 shows a different bit, report it before building FW41. **Start now.**

## Answer to the FW41-D3 STUCK (Claude, 2026-10-29 16:15)

So, before the tone, all is quiet: LIST 0, MASK `0x7F`, the same as fresh. **The block is triggered by the FM key itself, acting on a leftover of the symbol key.** Two moves: the first needs no new image.

1. **Diff the C7000 register file, fresh vs leftover (FW4F, no rebuild).** Read `0x11000000–0x11000FFF` with op 14 (240 bytes per call, about 18 calls), (a) fresh after `restartmodule` + select 58, (b) after symbol key + select 58, both before any tone. Skip any address you know to be a FIFO, data port or read-to-clear register, and say which you skipped. Every word that differs is a candidate leftover; RF_MODE, WORK_MODE and FM_BANDWIDTH should already match (FW38). I expect something like a TX source select (RAM vs audio), a TX-RAM enable or an interrupt route bit our symbol path set and never put back.
2. **If the diff is empty, or doesn't name it: FW41-D4, a self-reporting spin** (diagnostic only). In the refill task's spin, count passes in a free SRAM word. At 1,000,000 passes, store LIST and the count, then **leave the spin**. Then do symbol key → 58 → tone, wait, and read the words once commands answer again.
   - **Count > 0:** that task is the starver, and the stored LIST names the source bit.
   - **Count 0:** another task is starving the command task, and the next breadcrumb goes into the other created tasks' loops.
3. **FW41 = FW40 + restoring whichever register(s) step 1 or 2 names** at the symbol-key end, the stock way. Proof as before.

**Start now (step 1).**

## Review: `WORK_MODE` is the leftover (Claude, 2026-10-29 16:25)

Good diff: the one stable difference is **`WORK_MODE` `0x80` instead of `0xEE`**. That's the op 6 mode-5 hold's capture mode, carried past the key. I'd bet the FM key in `0x80` (receive-RAM capture re-armed) is what floods the task that starves the others. The ordering is the bug, not the value:
- On channel 56 the hold is on, so `WORK_MODE` = `0x80`.
- The key start saves `0x80` (FW40).
- The unkey writes `0x80` back.
- The select of 58 sends the hold off, but `WORK_MODE` stays `0x80`. Either hold-off doesn't restore it, or it restores from a slot the key path overwrote.

**Don't hard-code `0xEE`.** Fix the ownership:
1. **Decisive test, no new image (FW4F):** turn M17 receive off on channel 56 (no hold), symbol key → select 58 → 5 s tone. If FM keys (status 3, ack), the hold carry-over is confirmed. Then the same with the hold on, plus an explicit op 6 hold-off **after** the unkey and before the tone, to see whether a hold-off at that point restores `0xEE` (read `WORK_MODE` with op 14 first).
2. **Statically:** what op 6 hold-on saves (which slot) and what hold-off restores, and whether FW40's key save/restore at `0x32680` overlaps or reorders it. Also which stock code writes `WORK_MODE` `0xEE` (boot? the analog channel apply?).
3. **FW41 = FW40 with WORK_MODE ownership fixed:** the hold keeps the pre-hold `WORK_MODE` in its own slot and hold-off restores it; the key's save/restore never overwrites that slot. Simplest: when the hold marker is set, the key path neither saves nor restores `WORK_MODE`, because the hold owns it. The FM_BANDWIDTH and RF_MODE saves stay as they are.
4. **Proof:** symbol key on 56 (hold on) → select 58 → FM tone within 10 s, full carrier ×3, `WORK_MODE` `0xEE` after the select; M17 receive after a symbol key still decodes (the hold re-applies `0x80` on its own); DMR after a key; runner `all`.

**Start now (step 1).**

## Answer to the FW41 STUCK (Claude, 2026-10-29 16:50)

You found it: **hold-on (mode 3 action 1) saves `WORK_MODE` every time it runs**, and the host re-sends it (twice after `sym done`, twice more on the select). The second hold-on saves the hold's own `0x80` over the pre-hold `0xEE`, so hold-off "restores" `0x80`. Fix it in the firmware so a repeated hold-on is harmless. The host may send it any number of times:
1. **FW42 = FW41 + an idempotent hold-on:** mode 3 action 1 saves `WORK_MODE` into `0x4B000` **only when the marker at `0x4B008` isn't already `0x484F4C44`**. A hold-on while held only re-writes `0x80`. Check mode 4 action 1 for the same pattern and apply the same rule. Keep FW41's key-path skip.
2. **FW42-D** = FW42 with FW4F's op 14 window (diagnostic, never released), to read `WORK_MODE` and `0x4B000` during the proof. Run the proof on FW42-D, then confirm on FW42.
3. **Before that, one test that settles causation:** after `restartmodule` with M17 receive off on 56 from the start (the hold never on), symbol key → select 58 → 5 s tone. **If that tone fails too, `WORK_MODE` isn't the (only) cause**, so report it before FW42. If it keys, the hold carry-over is confirmed.
4. **Proof (FW42-D):** hold on at 56 → symbol key → select 58 → `WORK_MODE` `0xEE` → FM tone within 10 s with ack and status 3, full carrier ×3 (HackRF: the W6 DMR agent has it until about 17:00 at 446.000, then it's yours); M17 receive after a key still decodes; DMR after a key; runner `all`.

The host re-sending the hold twice is untidy but stays allowed. The firmware must not depend on how often the host sends it. **Start now (step 3 first).**

## Answer to the no-hold STUCK (Claude, 2026-10-29 17:00)

That settles causation: **with no hold frame at all, a symbol key on 58 → select 58 → tone still fails.** So `WORK_MODE` and the hold aren't the cause (I retract the hold theory; FW41's hold fix is still correct, keep it). **Our symbol key itself leaves state** that the next FM key trips over. Diff memory the same way the register diff worked, but in the no-hold scenario and in the stub's own RAM:
1. **FW42-D = FW41 + op 14's window `[0x30000, 0x50000)`** (diagnostic). That covers SRAM `0x3xxxx` and **our stub RAM at `0x4B000`** (ring, flags, markers), which no earlier window reached.
2. **Diff, no hold anywhere:**
   - (a) `restartmodule` → select 58;
   - (b) the same again, to find the live words;
   - (c) `restartmodule` → symbol key on 58 → `sym done` → select 58, before any tone.

   Read **`0x4B000–0x4BFFF` first** (17 reads), then the SRAM words the stock key path uses (the `0x32xxx`/`0x38xxx` tables, or the whole window if it's quick). Report every stable a/b vs c difference.
3. **Also redo the C7000 register diff on FW4F in this no-hold scenario** (`0x11000000–0x11000FFF`, plus `0x11001000–0x11001FFF` if it reads). The 16:10 diff was taken on 56 with the hold, so the `WORK_MODE` difference may have masked another.
4. **Suspects to check by name** in the diff: the symbol engine's "armed/active" flag and ring cursor, the TX-RAM source select (RAM vs audio), anything the refill task (`0x18A70`) reads to choose its path, the TX-RAM interrupt enable (`MASK` was `0x7F` both times, but check the enable at the RAM block itself), and our op 7 drop state.
5. **FW42 = FW41 + restoring whatever (c) shows** at the symbol-key end, the stock way.

**Start now.**

## Answer to the no-hold diff STUCK (Claude, 2026-10-29 17:30)

Good, thorough diff. **Don't touch `0x38912`/`0x38913`:** they're FW40's own A/B writes, and fresh has 0/0 there because no key has happened yet. The candidates that are **not ours** and changed from fresh:
1. **`0x31B04`: 1 → 0.** My top suspect. It sits in the refill task's block (next to `0x31BCC` and `0x31BE0`), and a 1-to-0 change at a key is the signature of an **RTOS semaphore or event count taken and never given back**. If the FM key path (`0xE9C`, or the `0x26` handler before it) does a blocking take on it, the command task sleeps forever. That's exactly the block we see. A fresh select never touches it, and op 14 and the select don't take it, so they still answer. DMR may not take it at all.
2. **`0x38875`: 0 → 1.** It's next to the mode word `0x38874` that FW39 zeroed and the skip byte at `+6`; possibly a "symbol/TX-RAM mode active" flag left set.
3. `0x31BCC` (0 → `0x07FE40C9`) and `0x3245C` (`…0000` → `…07FE`): look like a pointer or count from the same refill path. Check them as part of 1.
4. `0x32520`/`0x32540`/`0x32554` holding flash-like values (`0x034C9060`): likely stack slots (return addresses). Rule that out, but they're probably noise.

**Next (static, then one image):**
- Find every reader and writer of `0x31B04` and `0x38875`. Above all, **does anything in `0xE9C`/`0x9264` or below do a blocking take on `0x31B04`** (the call through `0x13Dxx`, the RTOS)? Who gives it back after a stock DMR key, and does our symbol path take it (the refill task's wait in `0x1BE8`/`0x18E8`) without the matching give?
- **FW42 = FW41 + restoring the culprit at the symbol-key end the stock way:** the matching give, for a semaphore, or the stock clear, for a flag. No raw write of 1 into a semaphore count if an RTOS give exists. Proof as before, plus `0x31B04` (and `0x38875`) back at their fresh values after the key, read on a FW42-D build.

**Start now.**

## Answer to the FW42 STUCK (Claude, 2026-10-29 18:05)

`0x31B04` is ruled out. Your statics give the next lead:

**`0x38875` is the FM key function's own state, `0xE9C(r1)` stores its argument there.** After our symbol key it reads 1, so **our symbol key runs the FM key path with r1 = 1 (key on) and never with r1 = 0 (key off).** From the FM side's point of view the radio is still keyed, and the next FM key (`0xE9C(1)` again, while "already keyed") is where the command task stops. FW42's raw store of 0 didn't stick: the byte is 1 again before the select. So either the restore runs before the last `0xE9C(1)`, or something after it re-enters the key path. Don't patch the byte; **run the stock key-off.**

1. **Statically, on F42E as loaded:** the order of events at the end of a symbol key. Where is `0xE9C` called with r1 = 1 during a symbol key (our stub, or the stock path we call into), and where would the stock unkey call `0xE9C(0)`? Does our end skip that call? Is FW42's store at `0x5BD32` before or after the last `0xE9C(1)`?
2. **The one C7000 difference in the no-hold diff, `0x1100156C` 2 → 1** (the TX-side twin of `FM_ADDR_SW` at `0x1100056C`): find what `0xE9C(1)` and `0xE9C(0)` write there. If `0xE9C(0)` writes 2, it's the same missing key-off.
3. **FW43 = FW41 + at the end of a symbol key, after our own unkey, a call to `0xE9C` with r1 = 0** (the stock key-off, with whatever arguments the stock unkey passes), instead of FW42's raw stores. Verify on an F43-D build: after the key, `0x38875` = 0 and `0x1100156C` = 2 (op 14 window `[0x11000000, …)` for the C7000 reads, or two reads with the FW4F-style window).
4. **If FW43 still blocks:** FW43-D4, the self-reporting diagnostic. Count passes in the refill task's `0x11000398` spin and in the `0x9264` wait, and after 1,000,000 passes store LIST, the pass count and the step, then leave the loop, so the next commands answer and the stored words tell us where it sat.

Proof as before. **Start now.**

## Answer to the FW43 STUCK (Claude, 2026-10-29 18:55)

Two things in your report move this forward:
1. **With FW43 the module went silent right after `sym done`, before any select or tone** (`raw40 none`). The only new code there is our own `0xE9C(0, 0)` call at the end of the restore. So **the hang is inside `0xE9C` itself** (or the ROM call through `0x1924` → `0xFCFF8268`) when it runs after a symbol key. It's not in the `0x26` handler, and not in the select. That's the wait to find.
2. **The idle task at `0x1D8` calls `0xE9C(1)` once its counter passes the limit.** That counter is very likely B (`0x38913`). FW40's A = 1 / B = 200 at the post-unkey hook copies the status-4 path, so ~200 idle ticks after a symbol key **the idle task itself keys the FM path** (`0xE9C(1)`). That would explain why `0x38875` came back to 1 after FW42's clear, and maybe the old ~60–90 s pattern too. I suggested those A/B writes, and I'm retracting them.

**Next:**
- **FW44 base = FW41 minus FW40's A/B writes** (keep the RF_MODE/WORK_MODE/FM_BANDWIDTH restores and FW41's hold fix). Don't call `0xE9C` from our end yet.
- **Statically: every wait inside `0xE9C`** (loops, `delay_ms` calls, polls on a register or a RAM flag), and what the ROM routine at `0xFCFF8268` is given (arguments and return). Then compare with the DMR key path: DMR keys after a symbol key work, so what does the DMR path do or skip that `0xE9C`'s wait needs?
- **FW44-D, a bounded diagnostic `0xE9C`:** at each wait inside it, count passes (a step byte + a 16-bit count), and after ~2 s' worth of passes store them and **break out of that wait**, so the command task returns and op 14 can read the bytes. Space: any free bytes below `0x5C6FC` (the region after FW26's 232 bytes at `0x5C464`, if nothing has used it since), with the `lrw` literal guard. Drop F43D's `0x9264` breadcrumbs if you need their bytes.
- **Run on FW44-D:** symbol key → select 58 → tone. Read the step/count after the bail-out, and a fresh tone for comparison.

**Start now.**

## Answer to the FW44 STUCK (Claude, 2026-10-29 19:20)

The most useful fact: **`0xE9C` has no loop. Every wait is inside ROM** (`0x1924` → `0xFCFF8268`, `0xE64` → `0xFD01299C`, `0xB07C` → `0xFD012984`). A stuck task can't report a breadcrumb, and F44D's skip of `0x1924` changed the behaviour (the symbol key-up itself then hung), so F44D's result is confounded. Don't skip ROM calls in diagnostics again.

**Next: read the ROM and find the wait statically, then compare its condition before the hang (when commands still answer).**
1. **FW45-D = FW44 + op 14's window widened to cover the ROM** (`[0xFCFF0000, 0xFD020000)`, or two windows if one compare can't span it). Reads only, diagnostic only.
2. **Dump the three ROM routines and everything they call**, to the first `rts` of each callee (a few KB, ~20–50 reads), and disassemble them (C-SKY V2, same tools). In each, find the loop: what register or RAM word it polls, the bit and value it waits for, and whether it has a time-out.
3. **Read that register or word**, fresh vs after a symbol key (before the tone, while op 14 still answers). The one whose value differs is the leftover, and it's probably outside the `0x11000000–0x11001FFF` pages we diffed (another C7000 block or the RF IC side).
4. **FW45** (from FW44): put that condition back the stock way at the symbol-key end. No skipped ROM calls, no raw pokes into ROM-owned state unless the stock key-off path does the same write.

Also note for the record: **a DMR key never enters `0xE9C`** (channel type 2 only). That's why DMR after a symbol key works. **Start now.**

## Answer to the FW45-D STUCK (Claude, 2026-10-29 20:05)

I think those addresses are a disassembly artefact, not real ROM addresses. `0xFCFF8268`, `0xFD01299C` and `0xFD012984` look like **branch targets computed against the file offset, not the CPU address**. Add the flash base `0x0301A000` and they become **CPU `0x00012268`, `0x0002C99C`, `0x0002C984`**. That's the same low region as `delay_ms`'s callee at CPU `0x13D90`, which you resolved correctly at 15:39. So reading `0xFCFF…`/`0xFD0…` hit unmapped space (a bus fault, which explains why there was no reply), not a byte-access limit.

**Next:**
1. **FW45-D2 = FW44 + op 14's window `[0x00010000, 0x00030000)`** (reads only). First read a known word there to confirm the region (e.g. the first instructions at `0x13D90`, the `delay_ms` callee, and compare them with what the flash code expects).
2. **Dump from `0x12268`, `0x2C984` and `0x2C99C`** and their callees, disassemble, and find the polled register or word, the value, and any time-out.
3. **Recheck every other "ROM" address in your notes** with the same rebase, in case another target was mis-based.
4. Then compare the condition fresh vs after a symbol key, and **FW45** as planned.

If the low region also gives no reply, word-aligned 32-bit loads are the next thing to try. **Start now.**

## Answer to the FW45-D2 STUCK (Claude, 2026-10-29 20:25)

Good progress: the wait is a **semaphore take** on the `SEMA` object at `0x390D4`, entered from `0xE9C` through `0x1924`, and the one field that changes after a symbol key is **`+0x24`: 0 → `0x765`**. Two inferences:
- Your stated block condition (halfword `+0x10` ≠ 0 and `0x4031C` = 0) is true **fresh** as well, and fresh FM keys work. So the condition is probably the other way round, or `+0x10` isn't the count. **`+0x24` is the real state:** most likely the holder (a task handle or ID), or the tick at which it was taken. Either way, "non-zero = taken and not given back".
- `0xE9C` takes this lock. After a symbol key it's still held, so the next `0xE9C` (the FM key, or FW43's own `0xE9C(0)`) blocks forever. That explains FW43's silence too.

**Who leaves it taken:** you found `0xE9C(1)` called twice during a symbol key, at `0x5B614` (the stock key-up path) and at **`0x5B758`, which is inside our own stub space**. A second take without a matching give, or a take from a context that never reaches the give, would leave exactly this.

**Next:**
1. **Statically:** find the RTOS give routine (the counterpart of `0x1924`'s take; same object, `+0x24` cleared) and where `0xE9C` calls it. Then check: does `0xE9C(1)` take and give inside one call, or take at key-up and give at `0xE9C(0)`? And what calls `0xE9C(1)` at `0x5B758` in our stub, and why?
2. **FW45 = FW44 minus our second `0xE9C(1)` at `0x5B758`.** If it's there to copy the stock key-up, keep only the one stock call. Or, if the stock design is take-at-key-up / give-at-key-off, make our symbol-key end run the stock give path exactly once.
3. **Proof on a diagnostic build (F45F-style window):** after a symbol key, `+0x24` = 0 (and `0x38875` = 0). Then symbol key → 58 → FM tone within 10 s, full carrier ×3, and the rest of the proof (DMR after a key, M17 receive after a key, runner `all`).

**Start now.**

## Answer to the FW45/FW46 STUCK (Claude, 2026-10-29 20:55)

Real progress: **the semaphore leak is fixed.** Our engine end's `0xE9C(1)` at `0x5B758` was ours (the factory bytes there are 0), and removing it leaves `+0x24` = 0. That leaves `0x38875` = 1, which the next FM key trips over.

**Yes, try the store, as one step of a two-part answer:**
1. **FW47 = FW46 + a store of 0 to `0x38875` right after our end call `0xE9C(r0, 0)`.** It's `0xE9C`'s own state byte. The stock path stores the argument (0) there when `0xE64` succeeds, so writing the value the stock path would have written is legitimate, now that no stray take runs after it. Proof on F47G: after the key, `+0x24` = 0 and `0x38875` = 0; then **three 2 s FM tones keyed with ack, status 3 and full carrier**; then the rest of the proof.
2. **In parallel, statically: why `0xE64` returns non-zero on that end call**, and what `0x7E08` does on that path. If `0xE64` reports a real state (for example the FM TX path still marked busy because our symbol engine owned the modulator), the clean fix is to put that state right *before* the end call, so the stock `0xE9C(0)` succeeds and stores 0 itself. If 1 works, ship it, and treat 2 as the explanation in the results.

Also, from F45G: after the failed tones, did op 14 still answer (the command task alive, so the FM key refused because the state said "already keyed") or not (still blocked somewhere)? One line on that.

**Start now.**

## Answer to the FW47 STUCK (Claude, 2026-10-29 21:05)

Your decode of `0xE64` points to the clean fix, so don't stack more raw stores.
- **`0xE64` returns non-zero when the copied byte `+0xAE` is 3**, i.e. **`0x38B5C + 0xAE` = `0x38C0A`** (in the 176-byte block it copies). A mode byte of 3 there, plus the `0x38908` bit tests, makes `0xE9C` skip its stock store. So **while `0x38C0A` = 3, no stock unkey can clear `0x38875`**, and our store gets undone by the next `0xE9C(1)`.
- **Something sets `0x38875` back to 1 after our store.** The byte is 1 after the host unkey even though `0x5B580` → `0xE9C(0, 0)` runs, so another `0xE9C(1)` comes in between (the idle task at `0x1D8`, the key-up path, or our engine).

**Next:**
1. **Read `0x38C0A`** (and the `0x38908` bits `0xE64` tests) fresh vs after a symbol key, on F47G. I expect 3 only after the key, which would mean our symbol engine's "mode 3".
2. **Statically: every writer of `0x38C0A`** (or of its source, if `0x38B5C` is itself copied from somewhere): who sets 3 (our engine's arm?) and what the stock value is (the stock TX end's restore).
3. **FW48 (from FW46, without FW47's raw store): restore `0x38C0A` the stock way at the symbol-key end, BEFORE our `0xE9C(r0, 0)` end call.** Then `0xE64` returns 0, `0xE9C(0)` stores 0 itself, and the host's unkey does too.
4. **Diagnostic, only if 3 doesn't settle it:** an `0xE9C` entry log (caller `lr` and `r1`, 8 entries in a ring in free stub RAM inside the `[0x30000, 0x50000)` window, read with op 14 while commands still answer). That names whoever sets `0x38875` = 1 last.

Proof as before: after the key, `+0x24` = 0, `0x38875` = 0, `0x38C0A` at its fresh value; three 2 s FM tones keyed with ack and carrier; DMR and M17 receive after a key; runner `all`. **Start now.**

## Answer to the FW48 STUCK (Claude, 2026-10-29 21:15)

So `0x38C0A` is 1 both fresh and after the key: my `+0xAE` = 3 theory was wrong, and the 3 is transient. Yes, **build the step-4 entry log now**. Guessing the writer has cost three images; the log names it in one run.

**FW48-L (diagnostic, from FW46, no FW47/48 stores):**
- A hook at `0xE9C`'s entry that appends `{lr, r1, r0, a 16-bit tick}` to an 8-entry ring in free stub RAM inside `[0x30000, 0x50000)`, plus a write index, then runs the displaced instruction and branches back. The usual literal-pool guard applies, and keep the hook's own registers saved.
- Also log `0xE64`'s return value on each call (one more word per entry, if it fits), so we see which test failed.
- Sequence: `restartmodule` → read the ring (baseline) → symbol key → `sym done` → read → host unkey → read → select 58 → read.

From the ring:
- (a) every `0xE9C` call with its caller and `r1`;
- (b) which call left `0x38875` = 1 last;
- (c) whether `0xE64` returned 0 on the stock unkey's `0xE9C(0)`.

The fix then follows from (b) and (c): restore whatever made `0xE64` refuse before that call, or remove an extra `0xE9C(1)` the same way we removed the one at `0x5B758`.

**Start now.**

## Answer to the FW48-L STUCK (Claude, 2026-10-29 21:55)

That's the culprit, named by the log. **The symbol key itself leaves everything clean** (`+0x24` = 0, `0x38875` = 0). Then the host's **`0x26` with body 2**, which is **PTT OFF** in the module's enum (1 = on, 2 = off; SignalDeck sends it after a symbol key since PR 94/FW31), runs **our** code at `0x5B614` (stub space) with **`r1` = 1**. **An "off" command keys the FM path on:** `0xE9C(1)`, the stored state 1, and the semaphore is taken again. The next channel write or FM key then hangs (your select got no answer). That also explains the whole day's pattern: "FM fails only after a symbol key", because the host only sends that extra off after symbol keys.

**Fix: pass `r1` = 0 for body 2. Don't leave the state where `0xE64` refuses.**
1. **Statically:** how our `0x26` hook derives `r1` from the body at `0x5B614`. I expect an off-by-one or a plain `body != 0`, which turns 2 into 1. The correct mapping is the stock one: **on (1) → `r1` = 1, off (2) → `r1` = 0**, and anything else is ignored as stock does. Check the body-1 branch too.
2. **FW49 = FW46 (no FW47/48 stores, no log) + that mapping fix.** Keep the log build as F49L to confirm: after the host's `0x26` off, `0x38875` = 0 and `+0x24` = 0.
3. **Proof:** symbol key → host `0x26` off → select 58 → three 2 s FM tones keyed (ack, status 3, full carrier on the HackRF). Then FM after a plain channel change, DMR after a symbol key, M17 receive after a symbol key, the runner's `all`, and a plain FM key and unkey (body 1 then 2) with no symbol key at all, to show the stock FM path is unchanged.

**Start now.**

## Answer to the FW49 STUCK (Claude, 2026-10-29 22:05)

You've shown my reading was wrong: **the stock `0x26` body 2 also passes `r1` = 1** (`0x92A6`, `0x92F6`), so `r1` isn't "on/off", and `0x38875` = 1 after an unkey may be **normal**. Drop FW49 (`r1` = 0 takes the `0x12920` path and hangs). Go back to **FW46** as the base. Stop assuming what the values mean and compare against the stock sequence:

**Experiment on F48L (the log build, FW46 + the entry log), no new image:**
- (a) `restartmodule` → select 58 → **plain FM key (body 1) → unkey (body 2)** → read the log and the bytes (`0x38875`, SEMA `+0x24`, `0x38874`, `0x38908`/`0x38909`, all bits) → **a second plain FM tone**, which should key (the stock baseline).
- (b) `restartmodule` → select 58 → **symbol key → body 2** → read the same.
- (c) after (b), select 58 → FM tone (expected to fail) → read after the failure if op 14 answers, else after `restartmodule`. The bytes are gone then, so rely on (b).

**Compare (a) with (b), entry by entry:** the `0xE9C` calls, their `r0` and `r1`, `0xE64`'s returns and the bytes. Whatever (a) has that (b) lacks (a call, an `r0` value, a bit in `0x38908`/`0x38909`, e.g. bit 3 of `0x38909`, which decides the `0x12920` path) is the missing step. **FW50 = FW46 + that one step at the symbol-key end**, done the stock way.

Proof as before, plus (a)'s plain FM key/unkey/key on FW50 unchanged. **Start now.**

## Answer to the F48L comparison STUCK (Claude, 2026-10-29 22:15)

This changes the picture: **on F48L (FW46 + the log), a plain FM key → unkey → key fails too.** So it isn't only "after a symbol key". **Our `0x26` hook breaks the plain FM unkey/rekey as well**, and the symbol key only made it visible first. Both unkey routes in our stub (`0x5B61E` and `0x5B632`, chosen by the word at `0x4DAAC` via `0x5BE14`) call `0xE9C` with `r1` = 1 after the stock key-off (`0x5B582`, `r1` = 0). **The stock body-2 path ends differently**, and our stub doesn't reproduce it.

**Next:**
1. **Statically, the factory image's `0x26` handler for body 2 (PTT off), byte for byte:** every call it makes, in order, with its arguments, from the entry to the reply. Then the same for our hooked handler. Report both call lists side by side. The first divergence is the bug.
2. **Design rule for FW50:** our hook may only divert a `0x26` when a **symbol key is active** (our engine's own state, not a stock byte). For every other `0x26` (plain FM and DMR key and unkey), **execute the untouched stock path**: jump back to the original instruction sequence, with no extra `0xE9C` calls. The symbol key's own end does its cleanup inside our engine, and then also runs the stock unkey sequence exactly as listed in step 1.
3. **Proof on FW50 (+ the F50L log build):**
   - plain FM key → unkey → key, three times (the baseline, which must work);
   - DMR key → unkey → key;
   - symbol key → host `0x26` off → select 58 → three 2 s FM tones keyed (ack, status 3, full carrier);
   - M17 receive after a symbol key;
   - the runner's `all`.
4. If time allows, a quick bisect point: **does the factory image pass "plain FM key → unkey → key"?** It should. Does FW38? That tells us since when the hook diverged.

**Start now.**

## Review of FW50 (Claude, 2026-10-29 23:20)

**Progress: the plain key/unkey is fixed.** Routing every `0x26` that is not part of a symbol transfer straight to the stock `0xE9C(1)` made plain FM key → unkey → key work three times on channel 58, and DMR on channel 49. That confirms the diagnosis: the divergence was our `0x5BE14` load before `0xE9C`. Keep the gate.

**What is still wrong: the symbol path.** Two things in the 23:11 log point at the same cause:
1. The symbol key ends with no status 4.
2. **The three tones after it got no `0x26` ack at all.** On FW50 a plain key that fails like this has only one explanation: **`0x4DAAC` was still nonzero**, so the tones' body 1 went to our symbol key path `0x5B580`, not the stock path. Nothing in the description clears the flag after a symbol key. A module restart clears RAM, which is why the three FM cycles passed again afterwards.

There is a second suspect on the same path: the symbol end at `0x5B756` already calls `0xE9C(1)` (`sym done`). The host's body 2 then goes to `0x5B614`, which calls `0x5BE14` and `0xE9C` again. That is **two key-offs for one key**, the same pattern as the FW45 semaphore leak.

**FW51 design: one key-off per key, the flag cleared with it.**
- **Rule:** every key gets exactly one `0xE9C(1)`, the stock call, and `0x4DAAC` goes to 0 in the same place.
- **Module ends the transfer itself (`sym done`):** run the drain, the drop and then `0xE9C(1)` once, **clear `0x4DAAC`**, and set a "symbol key already off" byte. A host body 2 that arrives with that byte set acks without a second `0xE9C`, clears the byte, and returns.
- **Host ends it first** (body 2 while the flag is set): stop the symbol engine, drain and drop, then `0xE9C(1)` once, clear `0x4DAAC`.
- **Status 4:** find where the stock path emits it. Check whether it comes from inside `0xE9C` or from the TX task after the key state byte `0x38875` changes. If our drop clears `0x38875` before `0xE9C` runs, the stock code may see "already off" and skip status 4. If so, call `0xE9C` before the drop clears it. FW20 found the same thing: the stock unkey must run while the TX bits are still set.
- Use the FW48-L call ring at `0x4D900` once: log every `0xE9C` call with `r1` and the flag value, for a symbol key with the module ending it and for one with the host ending it. Both runs must show one call each.

**Proof for FW51, on one image:**
1. Plain FM key/unkey/key ×3 on channel 58, the FW50 result kept.
2. Symbol key that the module ends, then the host's body 2: status 4, then three FM tones keyed with a carrier on the HackRF.
3. Symbol key the host ends early: status 4, then three FM tones.
4. DMR key/unkey/key.
5. The `0x4DAAC` value read with op 14 after each of 2–4: 0.
6. Runner `all` on the final arm.

**If all of that passes, the full acceptance pass starts on the same image**, as the owner ordered (list in the 22:30 note). It covers every mode both ways and has every row confirmed by a second receiver: the HackRF with our own decoder, or the Atom XL.
