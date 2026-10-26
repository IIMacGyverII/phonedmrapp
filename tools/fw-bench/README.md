# fw-bench — the module bench, on its way to one regression runner

Plan: `radio_firmware/plan-port-automation.md` (stage 5).

## The runner: `runner/bench.py` (accepted on the Armor 2026-10-26, image `DMR003.FW26.V022`)

Acceptance is the `all` run, after the fixes below. Every test passed. JSON and `summary.md` are in `results/DMR003.FW26.V022/`.

| Test | Accepted | Armor comparison |
|---|---|---|
| tag | yes | `DMR003.FW26.V022` |
| boot | yes | peak 0.048 dB and 0.07 dB, no run over 10 dB (the bar is under 0.1 dB) |
| tone | yes | 10.5 s carrier, body p99 2.54–2.55 kHz, 1 kHz line, hottest half-second 4.03–4.04 kHz |
| stream | yes | 1125/1125 payload-exact, end bit, carrier 45.41 s, p99 2903 and 2908 Hz, clip 0 |
| heat | yes | 30 s low power: AP +1.0 °C, battery +0.2 °C. 45 s low power: AP +1.2 °C, battery +0.3 °C. No stop |
| receive | yes | the phone clip carries the 1 kHz line (−19.1 dBFS) |

Defects found and fixed before `all`: the version string is not in the recent log once the signal poll is running, so the tag is read from SignalDeck's settings API; a 10 s test tone needs the lift flag or the app clamps it at 5 s; the receive clip is a WAV in the app cache, not a raw file in Download; the heat stop was watching `mtktsPA`, which is not a stop input; `all` now waits until `mtktsAP` is within 1 °C of the previous key, or 10 minutes.

Not this runner, and not a failed test: a plain-versus-held tone table, M17 receive scored at two levels, and a 120 s time-out key. Those measurements stay in `radio_firmware/results.md`.

## How to run it

```
python runner/bench.py --serial <adb serial> tag        # the module's version string
python runner/bench.py boot                             # silent-boot capture across restartmodule (no key)
python runner/bench.py --arm tone [--ms 10000] [--power 1]
python runner/bench.py --arm stream [--frames 1125]     # the long M17 stream through command 0x40, decoded
python runner/bench.py --arm heat [--seconds 45] [--power 1]
python runner/bench.py --arm receive                    # a HackRF FM tone into the radio, the phone's clip judged
python runner/bench.py --arm all
python runner/bench.py --load <image.bin> boot          # load through SignalDeck's loader first
```

Modules: `common.py` (defaults = the Armor bench, every path and serial an option or `BENCH_*` environment
variable), `phone.py` (adb, the `com.macdmr.radio.DIAG` commands, logcat, the tag, thermal zones, files),
`hackrf.py` (timed captures and transmissions with the stuck-process and first-burst guards), `fm.py` (the
demodulation and the key, slice and boot judges of the Armor scripts), `tests.py` (boot, tone, stream, heat,
receive, each naming the snapshot script it distils), `report.py` (one JSON record per run under
`<out>/results/<tag>/`, `summary.md` with the Armor reference next to every test). Nothing keys the radio or
transmits without `--arm`; the Diagnostics flag must be on in SignalDeck; the HackRF must be off the outdoor
antenna. The Armor acceptance is the table above (`DMR003.FW26.V022`, 2026-10-26). Trust it on another phone only after that phone's own run is compared with its hand measurements.

`armor-2026-10-snapshot/` is a read-only copy (taken 2026-10-24) of the scripts the Armor firmware work ran from
a temporary folder, so the knowledge in them cannot be lost. Grok Build keeps using its working copies; do not
edit the snapshot, and do not run it blind: these scripts key the radio and drive the HackRF, and each assumes the
bench state its results entry describes (`radio_firmware/results.md`). Shared helpers worth reading first:
`camp.py`, `r3_capture.py`, `r3a3_run.py`, `factory_boot.py`, `rc20_run.py`, `rd10_run.py`, `fw19_run.py`,
`m17.py`, `m17_stream_table.py`, `m17_rrc.py`. Callsigns in them are bench test values, not real stations.
