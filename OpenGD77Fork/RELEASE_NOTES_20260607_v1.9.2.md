# OpenGD77 CPS — PriInterPhone fork v1.9.2

**Date:** June 7, 2026

**Build:** `OpenGD77CPS-Mac_Build_20260607_114837.zip`

## Editor DPI — Channel editor scroll layout

The channel editor (`ChannelForm`) main panel now has explicit high-DPI scroll handling:

- **`pnlChannel`:** `AutoSize = false`, `AutoScroll` with DPI-scaled min-size (1120×960 baseline)
- **Dynamic min-height** tracks the Android CSV section and advanced-field collapse toggle
- **Resize + layout hooks** refresh scroll extent when the panel resizes or advanced/Android blocks move

Completes fork editor DPI for the primary PriInterPhone workflow editor (Android section already had per-control scaling).

`FORK_VERSION` = **1.9.2**