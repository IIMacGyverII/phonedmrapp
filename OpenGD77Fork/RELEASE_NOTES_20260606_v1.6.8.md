# OpenGD77 CPS — PriInterPhone fork v1.6.8

**Date:** June 6, 2026

## Android backup import diff consolidation

- **Review diff…** button in Android backup manager (F8) — opens the full channel diff grid before import.
- **Diff reviewed ✓** state — after you approve the diff once per folder, **Import all** skips the second duplicate dialog.
- Hint row and F1 workflow help updated for the review-then-import flow.

## Codeplug health — duplicate DMR IDs

- **F7** health report flags contacts that share the same Call ID (excluding All-Call).
- Status bar shows `dup ID: N` when duplicates are present.

`FORK_VERSION` = **1.6.8**