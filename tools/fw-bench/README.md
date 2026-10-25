# fw-bench — the module bench, on its way to one regression runner

Plan: `radio_firmware/plan-port-automation.md` (stage 5).

## The runner: `runner/bench.py` (first cut 2026-10-25, not yet run against the Armor)

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
antenna. **First use: run each test on the Armor and compare with `radio_firmware/results.md` before trusting it
on another phone** (that comparison is the acceptance of the runner; it has not been done yet).

`armor-2026-10-snapshot/` is a read-only copy (taken 2026-10-24) of the scripts the Armor firmware work ran from
a temporary folder, so the knowledge in them cannot be lost. Grok Build keeps using its working copies; do not
edit the snapshot, and do not run it blind: these scripts key the radio and drive the HackRF, and each assumes the
bench state its results entry describes (`radio_firmware/results.md`). Shared helpers worth reading first:
`camp.py`, `r3_capture.py`, `r3a3_run.py`, `factory_boot.py`, `rc20_run.py`, `rd10_run.py`, `fw19_run.py`,
`m17.py`, `m17_stream_table.py`, `m17_rrc.py`. Callsigns in them are bench test values, not real stations.
