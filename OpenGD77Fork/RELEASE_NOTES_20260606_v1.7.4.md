# OpenGD77 CPS — PriInterPhone fork v1.7.4

**Date:** June 6, 2026

**Build:** `OpenGD77CPS-Mac_Build_20260606_124224.zip`

## Tier 1.3 — Channel editor DPI (Android section)

The PriInterPhone / Android group is created at runtime **after** `Form.Scale()`, so it stayed at 96 DPI while the rest of `ChannelForm` scaled — clipped/overlapping labels at 125–150% Windows display scale.

- **`Theme.ScaleNewControlTree`** — scale post-`InitializeComponent` control trees to match `Settings.smethod_6()`.
- **Android group + advanced toggle** — scaled on load; note label uses `AutoSize` + `MaximumSize` for wrapping.
- **`RepositionForkAndroidSection`** — called at end of channel load so Android block sits below digital/analog panels at any DPI.

`FORK_VERSION` = **1.7.4**