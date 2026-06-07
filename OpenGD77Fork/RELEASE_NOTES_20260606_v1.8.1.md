# OpenGD77 CPS — PriInterPhone fork v1.8.1

**Date:** June 6, 2026

**Build:** `OpenGD77CPS-Mac_Build_20260606_224823.zip`

## Tier 2.1 — TG/Rx Group List overview grid

New **`RxGroupListsForm`** overview grid (tree parent under Rx Group List), matching Channels/Contacts/Zones parity:

- **DataGridView** — #, Name, contact count, first group contact
- **Single-click** opens the TG/Rx group list editor; keyboard nav opens on arrow keys only
- **Active row** highlight synced with open editor; **RefreshSingleRow** on list save
- **Filter** and **sort** (flat headers + glyphs)
- F7 health drill-down: `fork://open/tglist/N` and `fork://open/rxgroup/N`

`FORK_VERSION` = **1.8.1**