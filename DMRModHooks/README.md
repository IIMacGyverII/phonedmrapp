# DMRModHooks — LSPosed module for the PriInterPhone DMR app

This folder is the Android Studio / Gradle project for the module. The user-facing
documentation, release notes and feature list live in the **repository root
[`README.md`](../README.md)**; agent instructions are in [`CLAUDE.md`](../CLAUDE.md)
(mirrored at `.grok/rules/00-session-start.md`); unreleased changes are tracked in
[`CHANGELOG_DRAFT.md`](../CHANGELOG_DRAFT.md); the code-cited architecture reference is
[`docs/deep-dive/00-README.md`](../docs/deep-dive/00-README.md).

The 1,900-line version history that used to be in this file (v0.x – v3.1.3) is in git
history (`git log -p -- DMRModHooks/README.md`) and is superseded by the root README.

## Build and install

```powershell
# JDK 17 (the Gradle 8.2 wrapper does not run on newer JDKs)
$env:JAVA_HOME = "C:\Users\<you>\tools\jdk-17.0.20.1+1"
cd DMRModHooks
.\gradlew assembleDebug          # build only
.\install.ps1                    # build + adb install -r -t + adb reboot
```

- `local.properties` must point `sdk.dir` at an Android SDK with `platform-tools`.
- Debug and release builds share `release.keystore` (gitignored). Without it the
  `validateSigningDebug` task fails; the installed module on the phone is signed with it,
  so a different key would require an uninstall first.
- After **every** install the phone must be rebooted for LSPosed to pick up the new APK;
  `install.ps1` does that.

## Layout

| Path | What |
|---|---|
| `app/src/main/java/com/dmrmod/hooks/MainHook.java` | All Xposed hooks (entry point `handleLoadPackage`) |
| `app/src/main/java/com/dmrmod/hooks/ChannelScanner.java` | Channel scanner driven through the OEM channel-change path |
| `app/src/main/java/com/dmrmod/hooks/McuDiagnostics.java` | MCU readback (0x24/0x25/0x39), RX audio layout probe |
| `app/src/main/java/com/dmrmod/hooks/DirectDatabaseExporter.java` / `Importer.java` | OpenGD77-style CSV backup / restore (`meta.json` area stamp, preview, auto-backup) |
| `app/src/main/java/com/dmrmod/hooks/OemChannelTable.java` | Resolves the per-area OEM channel table |
| `app/src/main/java/com/example/dmrmodhooks/sstv/` | Production SSTV demodulator |
| `*.wav` at this level | Historical APRS / SSTV test captures (candidate corpus for backlog F0) |

Loose logs, databases and CSVs at this level are local scratch and are gitignored.
