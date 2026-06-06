# OpenGD77 CPS — PriInterPhone fork v1.7.2

**Date:** June 6, 2026

**Build:** `OpenGD77CPS-Mac_Build_20260606_123324.zip`

## Bug fix — contact editor reopens when closed

Closing a contact (or channel) editor returned focus to the grid with the same row still selected. `SelectionChanged` treated that as a new selection and reopened the editor. The grid now only auto-opens the editor when the selected **data index changes** (e.g. arrow keys); closing the editor leaves the blue highlight without reopening.

`FORK_VERSION` = **1.7.2**