# OpenGD77 CPS — PriInterPhone fork v1.7.9

**Date:** June 6, 2026

**Build:** `OpenGD77CPS-Mac_Build_20260606_220632.zip`

## Tier 1.3 — Zone + TG/Rx Group List editor DPI

The Zone and Rx Group List editors add filter/hint controls at runtime **after** `Form.Scale()`, so at 125–150% Windows display scale the filter row and lists could overlap or clip.

- **`Theme.ScaleNewControlTree`** on filter labels, filter text boxes, and hint rows
- **`Theme.Dpi`** in `ApplyForkZoneLayout` / `ApplyForkRxListLayout` for responsive group/list/button placement at any DPI

`FORK_VERSION` = **1.7.9**