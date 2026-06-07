# OpenGD77 CPS — PriInterPhone fork v1.8.2

**Date:** June 7, 2026

**Build:** `OpenGD77CPS-Mac_Build_20260607_081356.zip`

## Hotfix — TG Lists double-click null reference

Double-clicking **TG Lists** in the nav tree showed `Object reference not set to an instance of an object.` before the overview grid opened.

- **`RxGroupListsForm`** entry added to `Language/English.xml`
- **`Settings.smethod_68`** — skip localization when a form has no XML resource (no MessageBox)
- Load order: create grid controls before `smethod_68` so column headers localize correctly

`FORK_VERSION` = **1.8.2**