# Hotspot bench: M17 through the MMDVM hotspot with no network

Send audio files through the hotspot and hear what it receives, with no internet and no reflector. Built
2026-10-27 for the AURSINC duplex hotspot (WPSD "M17 Edition", MMDVM_HS dual hat) in the Faraday cage.

```
PC  m17bench.py  --TCP 8080-->  hotspot  m17relay.py  --UDP 17010/17011-->  MMDVMHost  --RF-->  radios
PC  m17bench.py  <--audio----   hotspot  m17relay.py  <--network frames--   MMDVMHost  <--RF--  radios
```

`m17relay.py` takes the place of M17Gateway on MMDVMHost's local network link. It decodes every transmission the
hotspot hears (Codec 2 3200) and streams the audio to the PC. It encodes audio the PC sends into M17 network frames,
which MMDVMHost transmits. It can also act as a parrot, replaying each transmission it hears.

## Files

| File | Runs on | What |
|---|---|---|
| `m17bench.py` | PC (Python 3, ffmpeg and ffplay) | A window: Connect, Send audio file (WAV, MP3, FLAC, OGG, M4A), Listen live, Parrot, Save last heard. Also a command line, below. |
| `m17relay.py` | hotspot (Python 3) | The relay. Listens on TCP 8080, a port the WPSD firewall already allows. |
| `c2tool.c` | hotspot | Codec 2 3200 encode/decode filter, built against the upstream Codec 2 library (LGPL-2.1). |

## Hotspot setup (once)

`/etc/mmdvmhost` (back up first): `[General] Callsign=N0CALL`; `[M17] Enable=1`, `SelfOnly=0`; `[M17 Network] Enable=1`,
with the default addresses (127.0.0.1, 17010/17011). Leave M17Gateway stopped, because the relay takes its UDP port.
Set `[Modem] RXOffset` for this board. On ours, −300 to −600 Hz gave 0.0 % BER and −450 is set. With 0, the hotspot
joined late at 6.5 % BER. For the cage, `[Modem] RFLevel=20`. Then restart MMDVMHost with `sudo systemctl restart mmdvmhost`.

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

## Use (PC)

```sh
python m17bench.py                                   # the window
python m17bench.py --send music.mp3                  # send one file (first 120 s; --max to change)
python m17bench.py --listen 60 --save heard.wav      # listen 60 s and save what the hotspot heard
```

Options: `--host 192.168.1.194`, `--src N0CALL`, `--dst @ALL`. Use only the bench callsign on the cage bench.

## What it showed (2026-10-27, `radio_firmware/results.md`)

- SignalDeck M17 voice from the Armor is decoded by the hotspot at 0.0 % BER on 467.625 MHz and heard on the PC as
  audio.
- A 5 s MP3 sent from the PC was transmitted by the hotspot: "received network voice transmission from N0CALL to ALL,
  5.0 seconds".
- The Armor hears the hotspot's carrier, but SignalDeck's M17 receiver does not yet decode the hotspot's
  transmission. That is open.
- MMDVMHost writes a zero CRC in network frames on this link. The relay writes the spec CRC, and MMDVMHost accepts both.
