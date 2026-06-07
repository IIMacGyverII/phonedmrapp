# OpenGD77 CPS — PriInterPhone fork v1.8.6

**Date:** June 7, 2026

**Build:** `OpenGD77CPS-Mac_Build_20260607_104303.zip`

## Tier 1.6 — CSV UTF-8 guard (completion)

- **`CsvFileReader` / `CsvFileWriter`** parameterless constructors now default to **UTF-8 without BOM**
- **`CsvEncoding.FileStartsWithUtf8Bom`** detects BOM on disk
- **Android backup validator** warns when any backup CSV has a UTF-8 BOM (PowerShell `Set-Content` pitfall — import still strips BOM on read)

## Editor DPI — DTMF forms

- **`DtmfContactForm`:** scroll min-size at DPI scale, `ApplyStandardEditorColors`
- **`DigitalKeyContactForm`:** scroll min-size, standard editor colors
- **Fix:** wire missing `Load` / `FormClosing` / grid event handlers on `DigitalKeyContactForm` (localization and save-on-close were skipped)

`FORK_VERSION` = **1.8.6**