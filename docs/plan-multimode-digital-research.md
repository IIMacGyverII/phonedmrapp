# Plan: other digital voice modes (D-Star, System Fusion, P25, NXDN) — research (2026-10-27)

**Owner direction 2026-10-27:** research, after the current queue (FW30, the DMR hotspot tests, promiscuous receive,
the items already on the route list). Nothing here is started. This plan is speculation to be tested, not findings.

## 1. The idea

The M17 work gave two routes that are not M17-specific: a receive path that carries any FM baseband (the AT1846S voice
filter held open, then a fixed per-model equaliser), and the firmware symbol engine that transmits arbitrary 2- or
4-level symbols. D-Star (GMSK, 4800 bit/s), System Fusion, P25 phase 1 and NXDN (all 4FSK) are FM-based and no wider
than M17. So the radio side is likely to work for all of them. What decides each mode is its voice codec.

| Mode | Modulation | Voice codec | What we could expect |
|---|---|---|---|
| System Fusion DN | C4FM 4800 sym/s | AMBE+2 half rate, the DMR family | headers, callsigns, data, GPS; **voice possibly through the module's own DMR vocoder** |
| NXDN | 4FSK 2400/4800 | AMBE+2 | IDs and data; voice possibly through the module's vocoder, as above |
| D-Star | GMSK 4800 | AMBE (older, not "+2") | headers, slow data (text, D-PRS positions); no voice |
| P25 phase 1, Fusion VW | C4FM | IMBE | headers, NAC, talkgroups; voice only if the licensing is cleared |

**Codec rule.** No AMBE, AMBE+2 or IMBE code goes into SignalDeck, and no third-party decoder code (same rule as M17).
The only voice route considered is the AMBE+2 vocoder that is already in the module's HR-C7000. Whether it can be fed
frames that did not come through its own DMR receive path is the central research question.

## 2. Research steps (in order)

1. **Read-only study of the DMR voice path in the module firmware (Grok).** Find where received DMR voice frames enter
   the HR-C7000's vocoder: the buffer, the frame format, any per-frame state. Answer two questions: can a host-supplied
   AMBE+2 frame be decoded to audio (through the same path the phone hears today)? Can the encoder side return frames for
   host-supplied audio? No image built until the reading answers both.
2. **System Fusion monitor, data only (Claude, SignalDeck host side).** Sync, frame and FICH decode, header callsigns,
   data-mode text and GPS, written from the published Fusion air-interface documentation, on the held receive path with
   the per-model taps. Test station: the MMDVM hotspot (it supports Fusion) and its relay's parrot, all in the cage.
3. **If step 1 says yes: a Fusion DN voice prototype through the module's vocoder** (Grok firmware + Claude host),
   bench only, measured against the hotspot.
4. **D-Star headers and slow data (Claude).** GMSK on the same receive path, header and slow-data decode from the
   published D-Star specification, callsigns and D-PRS positions. Data only.
5. **NXDN and P25 headers (Claude),** only after steps 2 and 4 are solid: IDs, NAC, talkgroups. Data only.
6. **Transmit** of headers, text and data frames for any mode that passes receive, through the symbol engine; voice
   transmit only where step 1 found a usable vocoder route.

## 3. Bench and rules

- The hotspot is the independent station for every mode (D-Star, Fusion, P25 and NXDN are all MMDVM modes): enable the
  mode in `/etc/mmdvmhost`, RF only, bench callsign N0CALL; the relay's parrot replays calls unchanged. Leases for the
  phone and the hotspot as for every bench item (`radio_firmware/HANDOFF.md`).
- Specs, not other projects' code: each decoder is written from the published air-interface specification, with host
  tests on synthetic frames and then on the hotspot's transmissions. Decoders under GPL (DSD and similar) are not read
  into SignalDeck.
- Pass measure: header and data frames payload-exact against what the hotspot sent, as with M17.

## 4. Open before starting

- Which published documents cover each mode's frame structure in enough detail (Fusion's air interface, the D-Star
  specification, TIA-102 for P25, the NXDN technical specifications). Collect and cite them in the first step of each.
- Whether the owner wants voice research (step 1) at all, given it depends on the module's vocoder.
