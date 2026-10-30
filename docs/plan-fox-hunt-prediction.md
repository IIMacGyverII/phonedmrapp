# Fox hunt: predicted fox location from signal strength and terrain (plan)

Owner request 2026-10-29. The fox hunt today (`ham/FoxHunt.java`, `ui/FoxHuntDialog.java`) estimates the fox from
**compass bearings only**: a weighted least-squares crossing of the bearing lines, with stronger readings weighted more,
falling back to the strongest mark when fewer than two usable bearings exist. Signal strength is not used for distance,
there is no map overlay, and terrain is ignored. This plan adds three **independent prediction methods, each a toggle**,
drawn as layers on the existing slippy map (`ui/MapView.java`) and combined into one best estimate.

## 1. The three toggles

Fox hunt sheet, a "Prediction" group with three switches (stored per user in prefs; defaults below):

| Toggle | Default | What it does | Needs |
|---|---|---|---|
| **Bearings** | on | Today's bearing crossing (unchanged), drawn as lines and an estimate ring on the map | marks with bearings |
| **Signal heat map** | on | Shades the likely area from how the signal strength changes between marks (path-loss fit, no bearings needed) | 3+ marks spread over at least ~100 m |
| **Terrain** | off | Uses ground height to rule out places the signal could not come from, and to refine the heat map with line-of-sight loss | elevation tiles for the area (download once, kept offline); on by choice because it downloads and costs battery |

Any combination works; with several on, the map shows each layer and one **combined estimate** (section 4). With all off,
the sheet works as today (marks, S-meter, peak hold, beep).

## 2. Signal heat map (no terrain)

- **Model:** received power at mark *i* from a fox at point *x*: `P_i = P0 - 10·n·log10(d(x, mark_i)) + e_i`, with the fox's
  effective radiated level `P0` unknown and the path-loss exponent `n` between 2 (open) and 4 (cluttered); `e_i` is
  shadowing noise (σ ≈ 6–8 dB, typical for VHF/UHF on foot).
- **Fit:** over a grid around the marks (e.g. 2 × 2 km, 25 m cells), for each cell solve `P0` in closed form (mean of
  `P_i + 10 n log10 d_i`) and score the residual sum of squares; `n` is fitted per hunt from {2.0, 2.5, 3.0, 3.5, 4.0}.
  Likelihood per cell `exp(-RSS / 2σ²)`, normalised; drawn as a translucent heat map (the app's neon palette, the 50 % and
  90 % regions outlined).
- **Readings:** each mark averages the RSSI over its sampling window (the existing peak/mean), discards readings taken while
  transmitting, and on the Atom XL uses the measurement read (PR 110: `pollRssiMeasure`). Marks with the module's floor value
  count as "below the floor" constraints (the fox is farther than here) instead of exact values.
- **Honest limits shown in the sheet:** "Strength-based estimates are rough: walls, cars and your body change readings by
  10 dB or more. Take marks in the open and hold the phone the same way."

## 3. Terrain (optional)

- **Data:** reuse `coverage/Terrain.java` (terrarium tiles at zoom 11, ~55 m samples, kept in app files forever) and the
  coverage `Predictor`/`Propagation` (the knife-edge path loss the coverage maps already compute). No new data source.
- **Per cell and mark:** the terrain profile from the cell (fox antenna height ~1.5 m, editable: "on a tower/roof") to the
  mark (phone at 1.5 m) gives an extra diffraction loss `L_terrain(x, i)`; the heat-map model becomes
  `P_i = P0 - 10 n log10 d - L_terrain`. Cells behind a ridge that would put a strong mark in deep shadow drop out.
- **Cost control:** the grid is evaluated coarse to fine (100 m, then 25 m around the top candidates), profiles cached per
  cell-mark pair, computed on a worker thread, recomputed only when a mark is added. Download prompt with size ("about
  N MB for this area"), offline afterwards; shows "no terrain for this area yet" until loaded.

## 4. Combined estimate

- The layers multiply as likelihoods: bearings become a likelihood around each bearing line (angular σ ≈ 15°, a phone
  compass near the body), the heat map (with terrain if on) as above. The combined map's peak is the estimate; the 50 %
  region its uncertainty ("the fox is probably inside this outline").
- The sheet shows distance and direction to the combined peak, which layer(s) it used, and a confidence word (rough /
  fair / good) from the 50 % region's size.

## 5. Engineering

- New `ham/FoxPredictor.java` (pure Java, host-testable): grid, path-loss fit, bearing likelihood, terrain hook via
  `Predictor.Elevation`; `FoxHunt.estimate()` keeps its current behaviour for the Bearings-only case.
- `ui/FoxHuntDialog.java`: the three toggles, a map view of the hunt (MapView with heat-map and line overlays), the
  combined estimate line; the existing compact plot stays for when no map tiles load.
- Web (`/api/fox` if the web page shows the hunt): the same toggles and the estimate (no heat map raster in the first step).
- Tests: synthetic hunts with a known fox (free-space and with a synthetic ridge), checking the combined estimate lands
  within a tolerance; bearings-only identical to today; floor-value marks handled; no terrain download in tests.
- Help (HelpView fox-hunt topic): what each toggle does, when to use which, the honest limits; changelog; Restricted mode
  needs no new id (inside the existing fox-hunt mode; the terrain download is a network action, allowed as the coverage
  maps' is).
- Single-band phones: unchanged (the fox channel is already band-checked, PR 104).

## 6. Order of work

1. `FoxPredictor` heat map + combined estimate with bearings, the toggles, the map layer, tests, help (one PR).
2. Terrain layer reusing `Terrain`/`Predictor` (second PR).
3. Field check: a walk with the bench fox beacon (N0CALL, low power) on a known spot; compare bearings-only, heat map, terrain.

## 7. Open choices (defaults chosen; owner may change)

- Defaults: Bearings on, Heat map on, Terrain off (download/battery). Grid 2 × 2 km, extended automatically when the
  estimate sits at the edge.
- Units follow the region setting once that exists (km/mi), else the current choice.

## 8. Better readings (owner 2026-10-29: add to the same project, built after the heat map)

These improve the data every prediction layer uses.

### 8.1 Offset-tuning attenuator (close-in)
- Near the fox the RSSI saturates. SignalDeck retunes the receiver a few kHz off the fox frequency (this radio tunes in exact
  500 Hz steps; the channel filter's skirt gives a repeatable loss), stepping the offset up as the reading nears the top of
  its range and down as it falls. Readings are stored as "measured + attenuation", so marks stay comparable.
- A one-time calibration table per profile (offset vs loss, measured with a HackRF carrier on the bench) lives with the
  profile, and the radio notes record it (`measured`).
- Respects the 0.7 s RSSI settle after a retune (CLAUDE.md fact): one reading per step, never mid-settle.
- The sheet shows "Attenuation 20 dB" and the effective reading; off by default below a threshold, automatic above it.

### 8.2 Spin to find the bearing (body-shadow sweep)
- A "Spin" button: hold the phone against your chest and turn slowly through a full circle. SignalDeck samples RSSI with the
  compass heading at ~2 Hz, fits the curve, and takes the bearing from the peak (or from the sharper null opposite it when
  it is deeper), with a quality score from the peak-to-null depth and the sample spread.
- Guidance on screen: a turn indicator ("slower", "keep going", 360° progress ring); a sweep with too little depth asks for a
  retry instead of storing a poor bearing.
- The stored mark carries the bearing and its quality; the bearing likelihood (section 4) uses the quality as its angular σ.

### 8.3 Count only the fox's own transmissions
- A "Fox signal" setting on the hunt: any signal, or only the fox's: its CTCSS/DCS on analog (the channel's tone squelch,
  or decoded from the audio, as the existing CTCSS decoder does), its caller ID and colour code on DMR (0x2B caller info).
- Readings are taken only while a matching reception is under way, after the settle delay, and not during squelch tails.
  Marks taken meanwhile wait for the next matching transmission ("waiting for the fox").

### Order inside the project
PR 1 heat map + combined estimate + toggles (sections 1–6) → PR 2 terrain → PR 3 the fox-only filter (8.3) and auto-marks →
PR 4 spin bearing (8.2) → PR 5 offset attenuator (8.1, needs a bench calibration slot). Each with tests, help and changelog.
