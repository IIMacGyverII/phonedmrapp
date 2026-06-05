# OpenGD77 CPS — PriInterPhone fork v1.2.7

**Build date:** June 5, 2026  
**Fix:** Main menu — File actions no longer appear under Setting

## Binary

Ship the matching `OpenGD77CPS-Mac_Build_20260605_*.zip` in this folder (full `bin\ReleaseOpenGD77` contents).

## Changes from v1.2.6

- **File** menu restored at the left of the menu bar (New, Save, Open, Android import/export, Exit).
- Menu/toolbar/status dock to the top of the window after the tree moves into the dock panel (removes the old 234px offset).
- `EnsureForkMainMenu()` re-parents file actions if WinForms moved shared items (same class of bug as Read/Write on Program + Advanced).
- Removed duplicate `tsmiProgram` dropdown that stole Read/Write before Advanced owned them.
- `English.xml` entries for Android menu items and Advanced.

## Unchanged

- Live Path B: `ChannelsForm.ImportFromCsvFile(..., MainForm, ...)` — do not remove.

## Pair with

DMRModHooks **v3.4.0+** on PriInterPhone hardware.