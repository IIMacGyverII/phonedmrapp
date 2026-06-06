# OpenGD77 CPS — PriInterPhone fork v1.7.1

**Date:** June 6, 2026

**Build:** `OpenGD77CPS-Mac_Build_20260606_113835.zip`

## Bug fix — Contacts grid crash after double-click popup

Fixed `InvalidOperationException` when closing the RadioID.net message box (or returning focus after double-click): deferred `SelectionChanged` no longer uses a stale `DataGridViewRow` reference. Rows are re-resolved by data index before selection; same hardening applied to Channels grid.

`FORK_VERSION` = **1.7.1**