# OpenGD77 CPS — PriInterPhone fork v1.9.1

**Date:** June 7, 2026

**Build:** `OpenGD77CPS-Mac_Build_20260607_113742.zip`

## Tier 1.7 — TG/Rx list health (F7 drill-down)

Extends codeplug health with TG/Rx group list parity (after v1.8.5 scan lists):

- **Warnings:** empty TG/Rx lists; invalid contact references (missing or non-group contacts)
- **TG/Rx breakdown table:** contacts per list, bad-ref count, click-to-open
- **`fork://open/tglist/{index}`** drill-down (existing handler) opens TG/Rx list editor
- **Status bar:** `empty TG` / `bad TG ref` warning tags when applicable
- Health report auto-refreshes when open

`FORK_VERSION` = **1.9.1**