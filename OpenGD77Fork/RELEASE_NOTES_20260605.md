# OpenGD77 CPS — PriInterPhone fork v1.2.2

**Build date:** June 5, 2026  
**Source commit:** OpenGD77CPS-Mac `master` (UI Tier 1 — welcome, theme, Advanced menu, codeplug health)

## Binary

Ship the matching `OpenGD77CPS-Mac_Build_20260605_*.zip` in this folder (full `bin\ReleaseOpenGD77` contents).

## Changes from v1.2.0

- Android backup toolbar + **File → Import/Export Android backup folder** (Path B, UTF-8 no BOM)
- First-run welcome dialog; grid Import/Export labeled *not Android*
- Dark menu/toolbar/status chrome (DMRModHooks navy)
- **Advanced** menu for USB/firmware/stock tools
- Status strip: channel/contact counts, `relay=0` warning

## Unchanged

- Live Path B: `ChannelsForm.ImportFromCsvFile(..., MainForm, ...)` — do not remove.

## Pair with

DMRModHooks **v3.4.0+** on PriInterPhone hardware.