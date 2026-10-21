# New phone playbook — from a device report to a working profile

How we turn an owner's reports into a SignalDeck profile for a phone we do not have. Written from the Blackview Xplore 1
(2026-10-21, `docs/multi-device-xplore1-findings.md`); the owner's side of it is **Device → Help support this phone**
(Run all checks → Listen check → Send the results), described in the app's help and in `docs/DEVICE_SUPPORT_REQUEST.md`.

Rules that do not change: every step on the owner's phone only listens; the owner decides about their own phone
([[owner-decides-advisories]] in memory: remote changes notify and can be overridden); never publish without the project
owner asking; mask callsigns, IDs and positions in anything we quote from a report.

## Stage 1 — Run all checks → a draft profile

Read the zip's `report.txt` in this order:

| Section | What it gives the profile |
|---|---|
| Walkie-talkie app candidates, ranked | `stockApp` (check the evidence: serial port held, serial library, `/dev/tty` in its code) |
| Clues in the stock app's code | the sysfs lines it writes (`/sys/devices/platform/…`), its serial ports, speed constants, audio parameters (`pdt_*`), its PTT / PCM log texts |
| The stock app at work | **the stock app's own log**: its power-up order (line values and order), which ports it opens and their `stty` settings, the commands it sends after boot (`0x27`, `0x34`, the channel write, `0x30`, `0x2F`…), the radio driver's kernel messages |
| Serial ports (root) + Radio probe | SELinux labels (→ `sepolicy`), who holds which port, at which speed the module answers `0x34`, the module's firmware name |
| Device tree of the radio module | pin names and the driver's `compatible` string |
| Databases (structure only) | the stock app's channel / contact tables (→ an importer in `ChannelStore`) |
| PTT key capture | `pttActions` (broadcasts) and the input key |
| Audio clues | whether radio audio goes through Android's audio system or a serial port |

Write the profile in `DeviceProfile.java` with `verified = false`. Line values: copy the stock app's order (`lineSetup`);
a line written `0` at power-off may mean something else at power-on — find out from the stock app's log what `0` and
`1` mean for each line before the app ever writes it.

## Stage 2 — Trial + Listen check → receive works

- **Trial (automatic, in Run all checks):** take-over, tune 446.00625 MHz with the squelch open and monitor on, capture 5 s.
  Expect `rx_audio_raw.bin` ≈ 167 bytes × 100/s on a framed UART port (Xplore), or bytes counted from the vendor service
  (Ulefone). `rx_audio_first.bin` shows the first bytes the port ever sent: check the framing there.
- **Listen check (owner):** a real station on a channel the owner picks; the report gets RSSI per second, heard seconds,
  audio bytes and the owner's answer. "No sound at all" with audio bytes arriving → playback/gate problem; no bytes →
  squelch, routing or audio-port problem.
- Squelch: some modules follow a global `0x30` level rather than the channel's sq byte (`globalSquelch` in the profile).

## Stage 3 — Transmit

Not part of the in-app process yet. Transmit stays off on unverified profiles.

## Stage 4 — Tested

After the owner has used the app normally for a while with no open problems: `verified = true` in the next release
(automatic take-over, boot ownership). Later, profiles move to a fetched, versioned list with owner-controlled advisories.

## Pitfalls we hit (so the next phone is faster)

- A single force-stop is not enough: some stock apps restart themselves; `FirstRunCheck.stopFully` retries.
- `RootSetup.run` appends `(rc=N)` to failing commands: never parse digits from one (`pidof … || true`).
- The vendor audio service (Ulefone) keeps only the last registered receive callback: re-register after Hand back.
- A module may stream audio only while its squelch is open — test with monitor on, not with silence.
- The bundled database in the stock APK can differ from the one on the phone: use the report's database structure.
