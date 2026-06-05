# OpenGD77 CPS — PriInterPhone fork v1.4.8

**Date:** June 5, 2026

**Build:** `OpenGD77CPS-Mac_Build_20260605_181152.zip`

## Contacts grid — double-click lookup fix

Double-click on Call ID cells did not open RadioID.net because `CellMouseDoubleClick` is unreliable on read-only grids (same class of bug fixed on the Channels grid in v1.4.3).

- Uses **`CellDoubleClick`** instead (fires consistently).
- **Double-click any cell** in a row looks up that row's Call ID (not only the Call ID column).
- Hint updated: *— or double-click a row to look up its Call ID*.
- Double-click the **row number** (left gutter) still opens the contact editor.

`FORK_VERSION` = **1.4.8**