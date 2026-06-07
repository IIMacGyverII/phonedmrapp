# OpenGD77 CPS — PriInterPhone fork v1.8.4

**Date:** June 7, 2026

**Build:** `OpenGD77CPS-Mac_Build_20260607_101415.zip`

## Tier 2.1 — Scan Lists overview grid

New **`ScanListsForm`** overview grid (tree parent under Scan), matching Channels/Contacts/Zones/TG Lists parity:

- Columns: **#**, **Name**, **Channels**, **1st channel**, **TB** (Talkback badge)
- Filter box, header-click sort with ▲/▼ glyphs, flat column headers
- Single-click opens scan list editor; active row highlight + `RefreshSingleRow` when editor saves
- **`Language/English.xml`** entry for `ScanListsForm` (avoids v1.8.2-class localization NRE)
- **Scan Basic** menu opens settings form directly (tree parent is now the overview grid)

`FORK_VERSION` = **1.8.4**