# OpenGD77 CPS — PriInterPhone fork v1.8.5

**Date:** June 7, 2026

**Build:** `OpenGD77CPS-Mac_Build_20260607_103114.zip`

## Tier 1.7 — Scan list health (F7 drill-down)

Extends codeplug health after v1.8.4 Scan Lists overview grid:

- **Metric card:** scan list count on F7 health report
- **Warnings:** empty scan lists; invalid channel references inside scan lists
- **Scan breakdown table:** channels per list, bad-ref count, click-to-open
- **`fork://open/scanlist/{index}`** drill-down opens scan list editor (parity with zones/TG)
- **Status bar:** shows scan count; `empty sc` / `bad sc ref` warning tags when applicable
- Health report auto-refreshes when open (existing v1.7.7 behavior)

`FORK_VERSION` = **1.8.5**