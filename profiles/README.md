# SignalDeck profile list

`profiles.json` (+ `profiles.json.sig`) is fetched by SignalDeck (`ProfileRegistry`) at most every 12 hours and from
Device → Profile → Check now. Tested profiles are built into each release; this list only carries **newer revisions** of
them, profiles for phones a release does not know yet, and **advisories**.

- **Profiles:** the same fields as `DeviceProfile` (`id`, `revision`, `name`, `controlPort`, `baud`, `audio` TINY_SERVICE|UART_PCM,
  `pcmPort`, `pcmBaud`, `powerNode`, `pttNode`, `powerOnToken`, `pttActions`, `stockApp`, `sepolicy`, `serialLib`, `supported`,
  `verified`, `globalSquelch`, `lineSetup` [[node, value], …]) plus `match` {`model`: [substrings], `sysfs`: [paths]} for a phone
  without a built-in profile. A built-in profile is replaced only by a higher `revision` of the same `id`.
- **Advisories:** {`id`, `profile`, `maxRevision` (optional), `restrict` transmit|takeover|profile, `title`, `why`, `issued`,
  `expires` (YYYY-MM-DD; required in practice — an advisory lapses when it is not renewed)}. They restrict by default; the
  phone's owner is notified and can override each one after two confirmations. Never use an advisory to take a decision away
  from an owner.
- **Publishing:** edit, bump `serial`, run `python scripts/sign_profiles.py`, commit both files. Fold changed profiles into the
  next release's built-in constants (same id and revision) so phones no longer need the list for them.
