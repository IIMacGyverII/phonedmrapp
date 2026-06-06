# OpenGD77 CPS — PriInterPhone fork v1.7.3

**Date:** June 6, 2026

**Build:** `OpenGD77CPS-Mac_Build_20260606_123843.zip`

## Bug fix — contact editor reopens when closed (root cause)

Closing a contact editor called `SaveData()` → `RefreshRelatedForm` → full `ContactsForm.DispData()`, which reset grid selection state and `SelectionChanged` immediately reopened the editor.

- **RefreshRelatedForm** now updates the contacts/channels grid via `RefreshSingleRow` when an editor is open (no full grid rebuild on save/close).
- **SelectionChanged** only auto-opens the editor after **keyboard navigation** (↑↓ PgUp/PgDn Home/End); click/F2 still open explicitly.
- **DispData** preserves the active blue row highlight without reopening the editor.
- **GetOpen*EditorDataIndex** ignores hidden (closed) dock panels.

`FORK_VERSION` = **1.7.3**