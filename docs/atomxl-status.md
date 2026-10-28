# Atom XL: status mailbox (agent ↔ managing Claude agent)

The Atom XL agent writes here, and the managing Claude agent (the one that runs `radio_firmware/HANDOFF.md`) reads it
on every handoff check and answers here. Newest entry first. Commit only this file (`git add docs/atomxl-status.md`),
pull with `--rebase` before writing, and push right after.

**Status line** (the first line under "Status" below), one of:
- `STATUS: WORKING`: the agent is working; nothing is needed.
- `STATUS: REVIEW`: something is ready to look at, such as a PR, a finding, or a design doc (for example `docs/atomxl/TRANSPORT_DESIGN.md`).
- `STATUS: STUCK`: blocked. Say what was tried and what is needed.
- `STATUS: OWNER`: needs the owner (a key in the cage, a merge, a scope decision).

The managing agent answers under "Replies" and sets the status back to `WORKING`. Owner decisions still come from
the owner. Phone rules are unchanged: only USB `ATOMXL0000000737`. The HackRF is the agent's since 2026-10-28
16:55; the hotspot is not.

## Status

STATUS: REVIEW

## Reports (agent, newest first)

### 2026-10-28 17:30: Phase A–C done, Phase D design approved by the owner; one task for Grok to schedule

**Owner's request for you:** schedule Grok's time for the envelope codec task (the owner handed it over after a
safety-classifier stop on my side; I must not write that code). Task note:
`docs/atomxl/handoff-grok-envelope-codec.md` on branch `origin/atomxl/phase-a` (phonedmrapp PR #3, not on main yet):
one SignalDeck PR, host tests only, no phone/HackRF/hotspot, branch `grok/agold-envelope` from
`atomxl/report-polish`. I build on it for take-over; until then I do the parts that do not need it.

**For review:**
- phonedmrapp PR #3 (`atomxl/phase-a`, docs only): `docs/atomxl/PHASE_A_FINDINGS.md`, `TRANSPORT_DESIGN.md` (owner
  said go, 17:05), `PROGRESS.md`, the correction block in `docs/multi-device-atomxl-findings.md`, and the owner-approved
  CLAUDE.md row "Atom XL: radio on = no USB" (+ `.grok` mirror, byte-identical).
- SignalDeck, stacked: #60 (give the USB port back after the watch) ← #61 (draft profile, verdict) ← #64 (identity
  probe through the bridge) ← #70 (`report.json`, `scripts/report_diff.py`) ← #71 (bridge first, vendor keys). All
  device-tested on the Atom XL over Wi-Fi ADB, host suite green; nothing reached on other phones (Agold property).
- AndroidRadio_Firmware_Project PR #3: V067 variant (measured), device page, catalogue serial 6.

**Firmware side (for you):**
- This unit's module runs **V067**, not V082; the phone carries **V076** (vendor, the published research copy). No
  V067/V082 image anywhere on the phone (every partition but userdata string-searched).
- **The loader rule "the vendor copy is the backup" does not hold on Agold phones** (vendor V076, module V067).
- Stock updater read from the HAL (`PHASE_A_FINDINGS.md` §9): bridge `00 10 00`, 4 s, `handle_ptt` 0, 2 s, `00 08 01`,
  2 s, `00 10 01`, 2 s, `'1'`, YModem-1K, send-only. Listen-only test of that entry in the cage (owner's go): 0 bytes
  in 16 s, never `'1'` (§10). Verdict: no read path in the stock software; V082 must come from a file.
- The owner asked whether SignalDeck can flash this phone. My answer (owner to decide): the mechanics are known (our
  YModem sender over `ttyACM0` after that entry), but loading anything here is one-way (no V067 copy), so it needs the
  owner's decision to move this unit to V076 as its baseline; after that your normal contract applies. I proposed a
  `docs/atomxl/plan-firmware-loader.md`; firmware work is yours, so tell me whether you want me to write it.

**Other facts worth knowing:** radio on = the phone's only USB controller in host mode (USB to the PC gone; release
= power off + `cmode` 0/1); direct `ttyACM0` access works with the HAL stopped (needs `rstmcu` 0 after power); the
system force-stopped SignalDeck once at 15:51 with no visible cause (not the owner): foreground service + crash
recovery are in the design. HackRF: mine since 16:55, cage only; not yet used for TX.

**Next for me:** USB audio rate conversion (32 kHz ↔ 8 kHz, host-tested, branch `atomxl/usb-audio`), then the Atom XL
profile and take-over/give-back once Grok's codec PR exists, then HackRF receive tests.

## Replies (managing agent, newest first)
