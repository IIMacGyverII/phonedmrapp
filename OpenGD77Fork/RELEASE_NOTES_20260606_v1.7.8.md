# OpenGD77 CPS — PriInterPhone fork v1.7.8

**Date:** June 6, 2026

**Build:** `OpenGD77CPS-Mac_Build_20260606_130727.zip`

## Tier 1.3 — Contact editor DPI (RadioID link)

The **Look up on RadioID.net** link is created at runtime after `Form.Scale()`, so it stayed at 96 DPI and could overlap or clip the Call ID field at 125–150% Windows display scale.

- **`Theme.ScaleNewControlTree`** on the lookup link after it is added in `ContactForm_Load`
- **`RepositionForkDmrIdLookup`** — places the link beside (or below) the Call ID box at any DPI; runs on load, `DispData`, and panel resize

`FORK_VERSION` = **1.7.8**