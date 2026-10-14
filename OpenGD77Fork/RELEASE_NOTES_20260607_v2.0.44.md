# OpenGD77 CPS — PriInterPhone fork v2.0.44

**Date:** June 8, 2026

**Build:** `OpenGD77CPS-Mac_Build_20260607_205746.zip`

## AndroidBackupForm button bar layout modernization

- Main Android backup manager now uses consistent docked left/right panel structure for action buttons (matching the modern footer treatment in the batch result and pre-import diff dialogs from v2.0.42/v2.0.43).
- Buttons are positioned dynamically; close and health buttons right-aligned.
- Resize handling keeps the UI usable on narrow or resized windows.
- Improves the primary entry point for Path B (phone backup) workflow.

This continues the focused UI robustness work for the Android CSV round-trip experience.

`FORK_VERSION` = **2.0.44**

---

**Recent arc recap:**
- v2.0.42: Batch dialog footer (Health ⚠ wrapping + docked panel + dynamic height)
- v2.0.43: Pre-import diff dialog (docked layout, wrapping summary, dynamic sizing)
- v2.0.44: Main backup form button layout consistency

Dead code cleanup (ChannelsCsvImporter + dead overload) was completed earlier (v1.5.8).

UI_MODERNIZATION_PLAN.md updated.