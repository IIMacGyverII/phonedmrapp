# SignalDeck regions: plan (SignalDeck issue #95, extended)

Owner request 2026-10-29. Issue #95 (a licensed operator in Belgium, testing on an EEA Armor 26 Ultra) asks for a configurable
terrestrial APRS frequency. The owner widened it: **a Region setting in the Device page, defaulting to the user's region on
first run, that drives every region-dependent default in the app**, with APRS, the licence-free personal-radio services
(the FRS/GMRS equivalents), SSTV and the other calling frequencies researched per region.

**Status: plan.** Every frequency in §4 marked *(verify)* must be confirmed against the primary source listed for it before
it ships; a wrong default sends users to the wrong place, or onto a frequency they may not transmit on.

## 1. What changes for the user

- **Device → Region**: a country picker (searchable list, flag-free, country names), plus "Custom" for operators who want
  their own values. Below it, the values it set (APRS frequency, calling frequencies, which licence-free services, weather
  radio yes/no), each with a small "change" to override just that one.
- **First run**: SignalDeck proposes a region from the phone (§2) and shows it on the welcome or first-run check screen:
  "Region: Belgium (from your SIM). Change". Nothing is transmitted because of a region; it only sets defaults.
- **Existing users**: upgrade keeps today's behaviour. An install that has used the app before gets the region "United
  States" if it was derived to be the US, otherwise it is asked once on the next start (a dismissible card on the intercom,
  never a blocking dialog).
- **Everything that today says "144.390"** reads the region's APRS frequency instead: the PKT sheet's monitor button, the
  web page's button and label, the scheduler's "APRS monitor" action, beacons, SmartBeaconing, telemetry, weather, the
  APRS-IS-to-RF gate check (`onAprsFrequency()`), the help text and the channel presets.

## 2. Picking the default region

In order, first that answers:
1. `TelephonyManager.getSimCountryIso()` (the SIM's home country; best for "where the user is licensed").
2. `getNetworkCountryIso()` (the network the phone is on; travellers).
3. The phone's locale country (`Locale.getDefault().getCountry()`).
4. Nothing usable: ask, with no preselection.

If SIM and network disagree (roaming), propose the SIM country and mention the network one ("You seem to be in France;
your SIM is Belgian"). No location permission is used for this. The value is stored once; it never changes silently later,
only by the user. A travel case ("I'm abroad for a week") is just switching the setting.

## 3. Engineering

- **`Region` model** (`region/Region.java`): an id (ISO 3166-1 alpha-2), a name, an ITU/IARU region (1, 2, 3), and the
  values of §4: APRS frequency (and an optional second one), FM calling frequencies per band, SSTV frequencies, the
  licence-free services available (as references to channel presets), whether NOAA-style weather radio and SAME exist,
  the amateur band edges for the bands the module covers (for the "is this an amateur frequency" checks), the default
  units (km/mi), and the BrandMeister country talkgroup (the MCC-based one, e.g. 206 Belgium) as a suggestion.
- **Data, not code**: one JSON asset `assets/regions.json`, so a frequency fix is a data change, shipped with the next
  app release (owner, 2026-10-29: no remote update). Unknown country → its IARU region's default entry.
- **One accessor**: `Region.current(context)` plus `RegionValues` with per-value user overrides (stored in prefs, cleared
  when the region changes, after asking).
- **Replace the constants**: `PacketEngine.APRS_FREQ_HZ` and every literal found in the review below become
  `RegionValues.aprsHz()` etc. Issue #95 already lists the call sites (`PacketEngine`, `RadioService`, `PktDialog`, `WebHost`,
  `app.js`, `index.html`, `Scheduler`, `ChannelPresets`, `HelpView`, `AprsScreen`); a grep for `144_390`, `144.39`, `146_520`,
  `162_400`, `amateurBand` finds the rest.
- **`amateurBand(hz)`** (used for CW ID and the transmit checks) becomes region-aware: 2 m is 144–148 MHz in Regions 2
  and 3 but 144–146 MHz in Region 1; 70 cm is 420–450 (US), 430–440 (most of Region 1), 420/430–450 elsewhere. Today's
  US-wide check would treat 146.52 MHz as amateur in Belgium, where it isn't.
- **Safety, as the issue asks**: changing the region never keys, never starts monitoring, never changes a channel the user
  made. An APRS frequency outside the module's tuning range (136–174 / 400–480 MHz on the Armor; UHF-only on the W6)
  shows as unavailable, and the APRS-144 features hide as they do today when 144.390 is out of band. ISS/satellite APRS,
  KISS TNC and explicitly chosen packet frequencies are untouched.
- **Web page**: `rd` (the radio-state JSON) carries the region values; `app.js` labels come from it.
- **Restricted mode**: the Region setting is an admin item (`Restriction.ADMIN`), so a lent phone cannot be moved to
  another region's frequencies (wiring rule).
- **Help**: a Region topic in `HelpView.TOPICS` (what it sets, how the default was chosen, that it never transmits, that
  the user remains responsible for their licence), and the APRS/presets topics read the region's values.
- **Tests**: host tests for the default-region order (SIM / network / locale), for each replaced call site using a non-US
  region, for `amateurBand` per region, and a schema test for `regions.json` (every frequency inside a known band, no
  duplicate ids). Device check by the issue author in Belgium (144.800 receive) and on the bench.

## 4. Research: what varies by region

Values to confirm per country before shipping. Primary sources: the IARU Region 1 VHF/UHF band plan and VHF Managers
Handbook, the ARRL band plan (US), the WIA band plan (Australia), NZART (New Zealand), JARL (Japan), LABRE (Brazil),
national regulator pages (Ofcom, BIPT, Bundesnetzagentur, ACMA, FCC Part 95, ISED RSS-210). Each entry in `regions.json`
records its source and the date checked.

### 4.1 Terrestrial APRS

| Area | Frequency | Notes |
|---|---|---|
| North America (US, Canada, Mexico) | 144.390 MHz | ARRL band plan |
| IARU Region 1 (Europe, Africa, Middle East) | 144.800 MHz | IARU R1 band plan; the issue's case |
| Australia | 145.175 MHz | WIA |
| New Zealand | 144.575 MHz | NZART *(verify)* |
| Japan | 144.640 MHz (1200 baud); 144.660 MHz (9600) | JARL *(verify which is 1200; the issue says 144.660)* |
| Brazil | 145.570 MHz | LABRE *(verify)* |
| Argentina, parts of South America | 144.930 MHz | *(verify)* |
| China | 144.640 MHz | *(verify)* |
| Thailand | 145.525 MHz | *(verify)* |
| South Korea | 144.620 MHz | *(verify)* |

The issue's own caveat applies: these are common network frequencies, not allocations, so every one stays user-editable.

### 4.2 Licence-free personal radio (the FRS/GMRS equivalents)

SignalDeck already has FRS, GMRS, MURS and PMR446 presets (`ChannelPresets`). The region decides which are offered
first and which are marked "not legal here". All of these normally require a **type-approved radio with a fixed antenna
and a power limit**; the app shows the limit and the legal note, and transmit legality stays the user's responsibility
(say so in the help, plainly).

| Service | Region | Frequencies | Limits (verify) |
|---|---|---|---|
| FRS | US | 462/467 MHz, 22 ch | 2 W (ch 1–7, 15–22), 0.5 W (8–14); certified radios |
| GMRS | US | same 22 + repeater inputs 467 MHz | licence (no exam), 50 W |
| FRS/GMRS | Canada | as US | GMRS licence-free in Canada *(verify)* |
| MURS | US | 151.820–154.600 MHz, 5 ch | 2 W |
| PMR446 | EU, UK, much of Region 1 | 446.00625–446.19375 MHz, 16 ch (12.5 kHz) | 0.5 W ERP, fixed antenna |
| dPMR446 / DMR446 | EU | same band, digital | 0.5 W |
| LPD433 | EU (varies) | 433.075–434.775 MHz, 69 ch | 10 mW |
| UHF CB | Australia | 476.425–477.400 MHz, 80 ch (12.5 kHz) | 5 W; repeaters on 31–38/71–78 *(verify)* |
| UHF CB / PRS | New Zealand | 476–477 MHz, as Australia *(verify)* | |
| Specified low power | Japan | 421/422 MHz bands *(verify)* | 10 mW |
| Public talkback (公众对讲机) | China | 409.7500–409.9875 MHz, 20 ch | 0.5 W *(verify)* |
| KDR444 | Nordic countries | 444.6–444.98 MHz *(verify)* | 2 W |
| PMR446-like | South Africa | 446 MHz *(verify)* | |

Within the Armor's tuning range (400–480 MHz) all the UHF ones are reachable; MURS needs VHF.

### 4.3 FM calling and SSTV

| Area | 2 m FM calling | 70 cm FM calling | FM SSTV (common practice) |
|---|---|---|---|
| US / Canada | 146.520 | 446.000 | 145.500 *(verify; US practice varies)* |
| Region 1 | 145.500 | 433.500 | 145.500 calling, then QSY (R1 band plan *(verify)*); 433.400 *(verify)* |
| Australia | 146.500 | 439.000 *(verify)* | *(verify)* |
| Japan | 145.000 | 433.000 | *(verify)* |

ISS SSTV (145.800 MHz downlink, plus the 437.550 event frequency), ISS APRS (145.825) and satellite frequencies are worldwide
and stay out of the region table.

### 4.4 Other region-dependent behaviour

- **Weather radio**: NOAA Weather Radio (162.400–162.550 MHz) and SAME alerts exist in the US and Canada (Weatheradio Canada)
  *(verify Bermuda / Mexico)*; elsewhere the WX presets, the band-scope preset and the SAME decoder card are hidden by
  default (still available under "show all").
- **POCSAG / DAPNET**: DAPNET's common frequency in Region 1 is 439.9875 MHz *(verify; US DAPNET differs)*: a preset for the
  pager page.
- **Amateur band edges** for the transmit and CW-ID checks (§3).
- **Station ID rules**: the CW-ID reminder interval (US 10 min) and GMRS's 15 min differ by country; the region sets the
  default, the user can change it.
- **Repeater directory**: Nearby Repeaters' data source; RepeaterBook covers North America best. Check which sources cover
  Region 1 and 3 with a usable licence, or show "no directory for this region yet".
- **DMR**: the BrandMeister country talkgroup (MCC-based, e.g. 206 Belgium, 262 Germany, 3100 USA) as a suggested
  talkgroup in the DMR preset; the Last-heard country flag.
- **Units**: km vs miles, for distances, coverage maps and the APRS station list.
- **Time and date formats**: follow Android's locale (not the region setting).

## 5. Order of work

1. Research pass: fill `regions.json` for the IARU regions' defaults plus the countries above, each value with its source.
   Ask the issue author (and other testers via Discussions) to review their own country's entries.
2. The model, the accessor, the first-run default and the Device setting, then replace the APRS call sites (issue #95's
   core) with host tests. Ship that first: it solves the issue.
3. Presets (licence-free services, calling and SSTV) by region; weather/SAME visibility; band edges; units.
4. Repeater directory and DMR suggestions.
5. Help, restricted-mode wiring and the changelog in each step.

## 6. Owner decisions (2026-10-29)

- **Country-level** regions (not only IARU regions); an unknown country falls back to its IARU region's entry.
- **`regions.json` changes ship with app releases only** (no remote signed update).
- **Services not legal in the user's region are shown, marked "not legal here"**, below the legal ones: it is the user's responsibility to know their rules and use the radio correctly.
- **The plan is shared on issue #95** (the owner posted a first reply; the plan follows as the next comment), inviting the reporter to review the Region 1 entries.
