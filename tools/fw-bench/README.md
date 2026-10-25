# fw-bench — the module bench, on its way to one regression runner

Plan: `radio_firmware/plan-port-automation.md` (stage 5). The runner is not written yet; it is to be distilled
from the snapshot below when the bench next waits, test by test, each checked against the Armor result it
reproduces.

`armor-2026-10-snapshot/` is a read-only copy (taken 2026-10-24) of the scripts the Armor firmware work ran from
a temporary folder, so the knowledge in them cannot be lost. Grok Build keeps using its working copies; do not
edit the snapshot, and do not run it blind: these scripts key the radio and drive the HackRF, and each assumes the
bench state its results entry describes (`radio_firmware/results.md`). Shared helpers worth reading first:
`camp.py`, `r3_capture.py`, `r3a3_run.py`, `factory_boot.py`, `rc20_run.py`, `rd10_run.py`, `fw19_run.py`,
`m17.py`, `m17_stream_table.py`, `m17_rrc.py`. Callsigns in them are bench test values, not real stations.
