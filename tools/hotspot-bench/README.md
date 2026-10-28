# Hotspot bench: M17 through the MMDVM hotspot with no network

Send audio files through the hotspot and hear what it receives, with no internet and no reflector. Built
2026-10-27 for the AURSINC duplex hotspot (WPSD "M17 Edition", MMDVM_HS dual hat) in the Faraday cage.

```
PC  m17bench.py  --TCP 8080-->  hotspot  m17relay.py  --UDP 17010/17011-->  MMDVMHost  --RF-->  radios
PC  m17bench.py  <--audio----   hotspot  m17relay.py  <--network frames--   MMDVMHost  <--RF--  radios
```

`m17relay.py` takes the place of M17Gateway on MMDVMHost's local network link. It decodes every transmission the
hotspot hears (Codec 2 3200) and streams the audio to the PC. It encodes audio the PC sends into M17 network frames,
which MMDVMHost transmits. It can also act as a parrot, replaying each transmission it hears. For POCSAG it stands in
for the DAPNET core (127.0.0.1:14343), so the hotspot's own DAPNETGateway logs in to it and transmits the pages the PC
sends.

## Files

| File | Runs on | What |
|---|---|---|
| `m17bench.py` | PC (Python 3, ffmpeg and ffplay) | A window: Connect, Send audio file (WAV, MP3, FLAC, OGG, M4A), Stop, Listen live, Parrot, Save last heard, a POCSAG page row (RIC, function, text) and a DMR row (calls heard, Replay last DMR call; the parrot covers DMR too). Also a command line, below. |
| `m17relay.py` | hotspot (Python 3) | The relay. Listens on TCP 8080, a port the WPSD firewall already allows. |
| `c2tool.c` | hotspot | Codec 2 3200 encode/decode filter, built against the upstream Codec 2 library (LGPL-2.1). |

## Hotspot setup (once)

`/etc/mmdvmhost` (back up first): `[General] Callsign=N0CALL`; `[M17] Enable=1`, `SelfOnly=0`, and `CAN=` the channel access number of the M17 channel you test with (SignalDeck's bench channel uses 7; a receiver silently drops another CAN, and the relay sends with this CAN too); `[M17 Network] Enable=1`,
with the default addresses (127.0.0.1, 17010/17011). Leave M17Gateway stopped, because the relay takes its UDP port.
Set `[Modem] RXOffset` for this board. On ours, −300 to −600 Hz gave 0.0 % BER and −450 is set. With 0, the hotspot
joined late at 6.5 % BER. For the cage, `[Modem] RFLevel=20`. Then restart MMDVMHost with `sudo systemctl restart mmdvmhost`.

For DMR (back up first): `[DMR] Enable=1`, `SelfOnly=0`, `ColorCode=1`; `[DMR Network] Enable=1` with `Type=Gateway`
and the local addresses (127.0.0.1, 62031/62032); leave DMRGateway stopped. The simplex board uses time slot 2 only. Plan
for the DMR tests: `docs/plan-dmr-hotspot-tests.md`.

For POCSAG (back up both files first): in `/etc/mmdvmhost`, `[POCSAG] Enable=1` and `Frequency=` your test frequency
(467625000 here), `[POCSAG Network] Enable=1`. In `/etc/dapnetgateway`, `[General] Callsign=N0CALL`, `[DAPNET]
Address=127.0.0.1`, `Port=14343` (outside the ephemeral port range; with 43434 the gateway can connect to itself), `AuthKey=benchkey` (any letters and digits; the stand-in does not check it). Restart
MMDVMHost, start the relay, then `sudo systemctl restart dapnetgateway`. The relay's log shows "dapnet link online".
The hotspot transmits POCSAG at 1200 baud only, and it cannot receive POCSAG: SignalDeck is the receiver under test.

Build Codec 2 and the tool on the hotspot. Copy the `codec2/` folder of SignalDeck's `app/src/main/cpp` and
`c2tool.c` to `~/claude-bench/c2/`, then:

```sh
cd ~/claude-bench/c2 && gcc -O2 -w -Icodec2 -o c2tool c2tool.c codec2/*.c -lm
```

Start the relay. It is not a service, so start it again after a hotspot reboot:

```sh
cd ~/claude-bench && setsid nohup python3 -u m17relay.py > relay.log 2>&1 < /dev/null &
```

Add `--parrot` to start it with the parrot on. The window can also switch the parrot.

## Rebuild after a reflash (or after a WPSD config-page save)

The hotspot's SD card was reflashed on 2026-10-28. This is the complete list of what the bench needs on it, so a fresh
image gets back to the same state in one pass. Everything below is bench-only: callsign N0CALL, DMR ID 1234567,
467.625 MHz, every network link local.

1. **WPSD first-boot (owner).** Join the home Wi-Fi (it should come back at 192.168.1.194; if not, use the new
   address everywhere below), set the login password, and let the first update finish. Do not configure while it updates.
2. **From the PC:** `HOTSPOT_PASS=<login password> tools/hotspot-bench/deploy.sh 192.168.1.194`. The password goes
   only in that environment variable, never in a file in the repo. It:
   - copies `m17relay.py` and `hotspot_setup.py` to `~/claude-bench/`, and `c2tool.c` with SignalDeck's Codec 2
     sources to `~/claude-bench/c2/`, then builds `c2tool` there;
   - installs the relay as the `m17relay` systemd service (restarts on failure, starts at boot, logs to
     `~/claude-bench/relay.log`), so a reboot no longer drops it;
   - runs `sudo python3 hotspot_setup.py`, which backs up and edits `/etc/mmdvmhost` and `/etc/dapnetgateway` to the
     values in the script (the full list is there, with the reason for each: RX offset −450, RF level 20 %, M17 with
     CAN 7, DMR CC1 with the gateway link to the relay, POCSAG on 467.625 MHz through the relay's DAPNET stand-in,
     FM off). It also stops and disables DMRGateway and M17Gateway, because the relay takes their ports, and
     restarts MMDVMHost and DAPNETGateway;
   - prints the checks.
3. **Checks** (`deploy.sh <host> check` any time):
   - `mmdvmhost`, `dapnetgateway` and `m17relay` are active; `dmrgateway` and `m17gateway` are not.
   - UDP 62031 and 17010 are bound by python3 (the relay), and 62032 and 17011 by MMDVMHost.
     **If 62032 has no process, MMDVMHost's DMR link is down:** replays are "sent" by the relay but never transmitted.
     Restart MMDVMHost. This happened on 2026-10-28 at about 06:58, with no error logged.
   - The MMDVM log shows the M17 and POCSAG lines and `Color Code: 1`.
4. **Record a DMR test call again.** The reflash erased `~/claude-bench/dmr_last.bin`. With the parrot off and the
   Armor on the factory image, set the bench ID (`dmr_bench_id.sh set`), key a 3 s call on SignalDeck's channel 49,
   then `dmr_bench_id.sh restore`. The relay keeps the call as `dmr_last.bin`. Copy it to `dmr_factory.bin` as the
   reference.
5. **Before any receive verdict,** check that MMDVMHost logged `received network voice header` for that replay.

Known traps:
- WPSD's watchdog tries to restart DMRGateway and M17Gateway every few minutes ("DMRGateway is not running.
  Restarting…"). With the relay holding their ports they exit again, which is harmless. But if a gateway ever starts
  before the relay, it holds the port and the relay cannot bind it. The relay service starts before MMDVMHost for that
  reason.
- A WPSD config-page save rewrites `/etc/mmdvmhost`: run `deploy.sh` again afterwards.
- MMDVMHost rejects DMR source IDs under 5 digits ("RF user … rejected"). Key DMR only with the bench ID.
- This modem has no FM mode: leave `[FM] Enable=0`, or MMDVMHost stops at start.

## Use (PC)

```sh
python m17bench.py                                   # the window
python m17bench.py --send music.mp3                  # send one file (first 120 s; --max to change)
python m17bench.py --listen 60 --save heard.wav      # listen 60 s and save what the hotspot heard
python m17bench.py --page 1234567 --text "hello"     # one POCSAG page (--func 0 numeric, 3 alphanumeric)
```

Options: `--host 192.168.1.194`, `--src N0CALL`, `--dst @ALL`. Use only the bench callsign on the cage bench.

## What it showed (2026-10-27, `radio_firmware/results.md`)

- SignalDeck M17 voice from the Armor is decoded by the hotspot at 0.0 % BER on 467.625 MHz and heard on the PC as
  audio.
- A 5 s MP3 sent from the PC was transmitted by the hotspot: "received network voice transmission from N0CALL to ALL,
  5.0 seconds".
- SignalDeck decodes the hotspot's transmissions on its M17 channel (about 85–94 % good frames); the parrot round trip
  (Armor key, hotspot replay, Armor decode) works with the CAN matched.
- A POCSAG page from the PC went out on air: DAPNETGateway "Sending message in slot 4 to 1234567, type 6, func
  Alphanumeric", MMDVMHost "POCSAG, transmitted 2 frame(s) of data from 1 message(s)".
- This board's firmware has no FM mode (the modem NAKs `SET_FM_PARAMS2` and MMDVMHost stops), so FT8, APRS, SSTV and
  other audio modes cannot go through this hotspot.
- MMDVMHost writes a zero CRC in network frames on this link. The relay writes the spec CRC, and MMDVMHost accepts both.
