# OpenGD77 CPS — PriInterPhone fork v1.3.0

**Build date:** June 5, 2026  
**Feature:** Tier 2.5 pre-import channel diff preview

## Binary

Ship `OpenGD77CPS-Mac_Build_20260605_171214.zip` in this folder (full `bin\ReleaseOpenGD77` contents).

## Changes from v1.2.7

- **Channel import preview** before Path B import: Added / Changed / Deleted / Unchanged with field-level diffs.
- **Apply import** commits; **Cancel** leaves the loaded codeplug unchanged.
- Android backup manager validation panel shows diff counts when `Channels.csv` is present.

## Unchanged

- Live Path B: `ChannelsForm.ImportFromCsvFile(..., MainForm, ...)` — do not remove.
- File menu layout fix from v1.2.7.

## Pair with

DMRModHooks **v3.4.0+** on PriInterPhone hardware.