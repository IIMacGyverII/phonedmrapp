---
name: phonedmrapp
description: >
  DMRModHooks / phonedmrapp project context. Use at the start of any session
  touching DMRModHooks, PriInterPhone hooks, LSPosed module, OpenGD77 CSV,
  APRS/SSTV/NOAA/VFO features, or Android DMR radio app work in this repo.
  Also use when the user mentions Ulefone Armor 26 Ultra, BrandMeister, DMR ID,
  talkgroups, or install.ps1. Read .grok/rules/00-session-start.md before coding.
metadata:
  short-description: "phonedmrapp project context & deploy rules"
---

# phonedmrapp Project Skill

## First action

1. Read `.grok/rules/00-session-start.md`
2. Skim `.grok/rules/key-files.md` if the task touches CSV import/export or OpenGD77 CPS
3. Skim `.grok/rules/packet-layouts.md` if the task involves serial packets, DMR IDs, or call types
4. Check `.docs/AI_LOGS_SUMMARY.md` §4 if the task smells like a known dead end

## Before editing MainHook.java

- Grep for existing hook/helper — `MainHook.java` is huge; extend don't duplicate
- Confirm OEM class paths under `app/src/main/java/com/pri/prizeinterphone/`
- Wrap new hooks in try-catch; use `TAG` logging

## After code changes

```powershell
cd DMRModHooks
.\gradlew assembleDebug          # verify compile
.\install.ps1                    # if device connected — includes adb reboot
```

Never claim on-device validation succeeded without install + reboot.

## Doc hygiene

When you fix a bug that contradicts written docs, update in the same change:
- `.grok/rules/` (and `.github/copilot-instructions.md` if the section exists there)
- `DMRModHooks/README.md` only if the user cares about user-facing docs

## Version source of truth

`DMRModHooks/app/build.gradle` → `versionName` / `versionCode`. Do not trust version strings in markdown alone.