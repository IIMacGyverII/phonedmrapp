# Plan: band scope signal log and custom scan lists

**Owner, 2026-10-30:** "add at some point a way for the band scope to record where it saw signals so the user can see and also allow the user to put those frequencies in to a custom band scope list." Not scheduled yet; after the current queue.

## Today

`BandScope` keeps the last sweeps in memory (`history()`) and finds peaks per sweep (`peaks(dbm, from, step, db)`). Nothing is kept once the screen closes, and the band is always one of the presets (`PRESETS`, filtered by region).

## What to build

1. **Signal log**
   - **What it records:** every peak the scope finds, once it's above the noise floor by the screen's threshold. Each entry has the frequency, the strongest level, first and last seen, and the number of sweeps it showed in, plus the band preset and the region.
   - **Repeats:** a frequency seen again updates its row instead of adding a new one, so the log stays a list of frequencies, not of sweeps.
   - **Where it lives:** the app's database, so it survives restarts.
   - **Location:** an optional GPS position at first sighting, off by default, as the coverage maps already handle it.
2. **Seen signals list** (a sheet from the band scope screen):
   - sorted by count or by last seen;
   - marks for frequencies that are already one of the user's channels, and for known services (region band edges, the licence-free lists, the repeater directory when one is loaded);
   - **Tap a row:** listen there (VFO), or add it as a channel.
   - Rows can be deleted or cleared.
3. **Custom band scope lists**
   - Pick rows from the seen list, or type frequencies, into a named list. The scope can then sweep that list instead of a contiguous band, which is faster because it reads only the listed frequencies.
   - Lists can also be built from a zone or a channel range.
   - Export and import go through the backup CSV set as a new file, with SignalDeck Web parity.
4. **Restricted mode** (wiring rule): the log and the lists are part of the band scope mode's id. Adding a channel from the log goes through the channel-edit admin guard.
5. **Help:** a new section in the band scope topic.

## Notes

- The sweep speed depends on the phone. The Armor reads in about 0.7 s per step (`rssi-settle-after-retune`) and the Atom XL in about 0.1 s (2026-10-30). A custom list of 20 frequencies is about 14 s on the Armor and about 2 s on the Atom XL.
- A list sweep returns to the channel afterwards, as the band scope does now.
- Tests:
  - peak merging (same frequency within half a step);
  - list parse and export;
  - list-sweep timing per profile.
