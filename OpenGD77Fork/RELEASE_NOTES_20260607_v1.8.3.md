# OpenGD77 CPS — PriInterPhone fork v1.8.3

**Date:** June 7, 2026

**Build:** `OpenGD77CPS-Mac_Build_20260607_085325.zip`

## Tier 1.3 — Scan list + DTMF editor DPI

Extends v1.7.9 Zone/Rx editor DPI work to the remaining Android-adjacent editors.

### Scan list editor (`NormalScanForm`)

- **Available filter** — searches channel names in the Available list (Zone editor parity)
- **`Theme.ScaleNewControlTree`** on filter/hint controls added after `Form.Scale()`
- **`Theme.Dpi`** responsive layout for Available/Member groups, Add/Delete/Up/Down buttons, and Scan parameters panel at 125–150% display scale
- **`forkUnselectedCache`** — filter preserves correct Add/Delete channel moves

### DTMF editor (`DtmfForm`)

- **`Theme.ApplyStandardEditorColors`** — readable labels on light panels
- **`pnlDtmf`** — `AutoSize` off, scroll min-size scaled via `Theme.Dpi` so fields do not clip at high DPI

### Scan basic (`ScanBasicForm`)

- **`Theme.ApplyStandardEditorColors`** on load

`FORK_VERSION` = **1.8.3**