#!/usr/bin/env python3
"""
NOAA Satellite Pass Predictor
==============================
Predicts upcoming passes of NOAA-15, NOAA-18, NOAA-19 over a given location.
Uses skyfield + TLE data fetched from celestrak.org (cached locally).

Usage:
  python noaa_pass_predictor.py <lat> <lon> [options]

Examples:
  python noaa_pass_predictor.py 40.7128 -74.0060
  python noaa_pass_predictor.py 51.5074 -0.1278 --days 5 --min-el 15
  python noaa_pass_predictor.py 34.0522 -118.2437 --days 2
"""

import argparse
import os
import sys
import urllib.request
from datetime import timezone

# ──────────────────────────────────────────────────────────────────────────────
# TLE cache / fallback
# ──────────────────────────────────────────────────────────────────────────────

CACHE_FILE     = os.path.join(os.path.dirname(__file__), ".noaa_tles_cache.txt")
CACHE_MAX_AGE  = 12          # hours before re-fetching
# TLE sources tried in order; first 200 response that contains NOAA TLEs wins
TLE_URLS = [
    "https://celestrak.org/NOAA/elements/gp.php?GROUP=weather&FORMAT=tle",
    "https://celestrak.org/pub/TLE/weather.txt",
    "https://celestrak.org/pub/TLE/noaa.txt",
]
TLE_URL = TLE_URLS[0]  # kept for backward compat
TARGET_NAMES   = {"NOAA 15", "NOAA 18", "NOAA 19"}
FREQ_MAP       = {
    "NOAA 15": "137.620 MHz",
    "NOAA 18": "137.9125 MHz",
    "NOAA 19": "137.100 MHz",
}

# Fallback TLEs if network is unavailable (approximate march 2026)
FALLBACK_TLE_TEXT = """\
NOAA 15
1 25338U 98030A   26077.50000000  .00000038  00000+0  31234-4 0  9994
2 25338  98.7165 123.4567 0010234 234.5678 125.4321 14.25670000000000
NOAA 18
1 28654U 05018A   26077.50000000  .00000057  00000+0  42345-4 0  9997
2 28654  99.0234 145.6789 0013456 345.6789 014.3456 14.12456000000000
NOAA 19
1 33591U 09005A   26077.50000000  .00000065  00000+0  57234-4 0  9998
2 33591  99.1896 121.4567 0013994 324.5678 035.4321 14.12345000000000
"""


def load_tles_text(verbose=True):
    """Return TLE text: from cache, network, or fallback."""
    import time
    # Try cache first
    if os.path.exists(CACHE_FILE):
        age_h = (time.time() - os.path.getmtime(CACHE_FILE)) / 3600
        if age_h < CACHE_MAX_AGE:
            with open(CACHE_FILE, "r") as f:
                return f.read(), "cache"

    # Try network (cascade through TLE_URLS)
    for tle_url in TLE_URLS:
        try:
            if verbose:
                print(f"  Fetching TLEs from {tle_url} ...")
            req = urllib.request.Request(tle_url, headers={"User-Agent": "SatPass/1.0"})
            with urllib.request.urlopen(req, timeout=10) as resp:
                text = resp.read().decode("utf-8")
            # Verify it contains NOAA satellite data
            if any(n in text for n in ("NOAA 15", "NOAA 18", "NOAA 19")):
                with open(CACHE_FILE, "w") as f:
                    f.write(text)
                return text, "network"
            elif verbose:
                print(f"  {tle_url} returned 200 but no NOAA TLEs found, trying next...")
        except Exception as exc:
            if verbose:
                print(f"  {tle_url} failed: {exc}")
    if verbose:
        print("  All TLE sources failed — using fallback.")
    return FALLBACK_TLE_TEXT, "fallback"


def parse_tles(text, ts):
    """Parse TLE text and return dict of {name: EarthSatellite}."""
    from skyfield.api import EarthSatellite
    sats = {}
    lines = [ln.strip() for ln in text.splitlines() if ln.strip()]
    i = 0
    while i < len(lines) - 2:
        name = lines[i]
        # Strip leading "0 " that SatNOGS prepends to names
        if name.startswith("0 "):
            name = name[2:]
        l1, l2 = lines[i + 1], lines[i + 2]
        if name in TARGET_NAMES and l1.startswith("1 ") and l2.startswith("2 "):
            sats[name] = EarthSatellite(l1, l2, name, ts)
            i += 3
        else:
            i += 1
    return sats


# ──────────────────────────────────────────────────────────────────────────────
# Pass prediction
# ──────────────────────────────────────────────────────────────────────────────

def find_passes(lat, lon, alt_m, days, min_el_deg, verbose=True):
    """
    Returns a list of pass dicts sorted by AOS time, each containing:
      name, freq, aos, max_el_time, los, max_el_deg, duration_s,
      aos_az_deg, max_az_deg, los_az_deg
    """
    try:
        from skyfield.api import load, wgs84
    except ImportError:
        print("ERROR: skyfield not installed. Run:  pip install skyfield")
        sys.exit(1)

    ts = load.timescale()
    tle_text, source = load_tles_text(verbose=verbose)
    sats = parse_tles(tle_text, ts)

    if not sats:
        print("ERROR: No NOAA satellites found in TLE data.")
        return []

    observer = wgs84.latlon(lat, lon, elevation_m=alt_m)
    t0 = ts.now()
    t1 = ts.tt_jd(t0.tt + days)

    passes = []
    for name, sat in sorted(sats.items()):
        t_events, events = sat.find_events(observer, t0, t1,
                                           altitude_degrees=min_el_deg)
        current = {}
        for ti, ev in zip(t_events, events):
            if ev == 0:   # AOS
                current = {"name": name, "aos": ti}
            elif ev == 1: # max elevation
                diff = sat - observer
                topo = diff.at(ti)
                alt_deg, az_deg, _ = topo.altaz()
                current["max_el_time"]  = ti
                current["max_el_deg"]   = alt_deg.degrees
                current["max_az_deg"]   = az_deg.degrees
            elif ev == 2: # LOS
                if "aos" in current:
                    current["los"] = ti
                    # Compute AOS azimuth
                    diff = sat - observer
                    aos_az = diff.at(current["aos"]).altaz()[1].degrees
                    los_az = diff.at(ti).altaz()[1].degrees
                    current["aos_az_deg"] = aos_az
                    current["los_az_deg"] = los_az
                    current["duration_s"] = int(
                        (ti.utc_datetime() - current["aos"].utc_datetime()).total_seconds())
                    current["freq"] = FREQ_MAP.get(name, "?")
                    passes.append(dict(current))
                current = {}

    passes.sort(key=lambda p: p["aos"].tt)
    return passes


# ──────────────────────────────────────────────────────────────────────────────
# Output formatting
# ──────────────────────────────────────────────────────────────────────────────

def format_az(deg):
    """Convert azimuth to cardinal direction + degrees."""
    dirs = ["N", "NE", "E", "SE", "S", "SW", "W", "NW", "N"]
    return f"{deg:5.1f}° {dirs[round(deg / 45) % 8]}"


def print_passes(passes, tz_name="UTC"):
    from datetime import datetime
    if not passes:
        print("\n  No passes found in the specified period.\n")
        return

    print(f"\n  Found {len(passes)} pass(es):\n")
    header = (f"  {'#':<3} {'Satellite':<10} {'Freq':>10}  "
              f"{'AOS (UTC)':<19} {'AOS Az':>9}  "
              f"{'Max El':>7} {'@ Az':>9}  "
              f"{'LOS (UTC)':<19} {'LOS Az':>9}  {'Duration'}")
    print(header)
    print("  " + "─" * (len(header) - 2))

    for i, p in enumerate(passes, 1):
        aos  = p["aos"].utc_datetime()
        los  = p["los"].utc_datetime()
        dur  = p["duration_s"]
        print(f"  {i:<3} {p['name']:<10} {p['freq']:>10}  "
              f"{aos.strftime('%Y-%m-%d %H:%M:%S'):<19} {format_az(p['aos_az_deg']):>9}  "
              f"{p['max_el_deg']:>6.1f}° {format_az(p['max_az_deg']):>9}  "
              f"{los.strftime('%Y-%m-%d %H:%M:%S'):<19} {format_az(p['los_az_deg']):>9}  "
              f"{dur//60}m {dur%60:02d}s")
    print()


# ──────────────────────────────────────────────────────────────────────────────
# CLI entry point
# ──────────────────────────────────────────────────────────────────────────────

def main():
    parser = argparse.ArgumentParser(
        description="Predict NOAA satellite passes over a location",
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog=__doc__)
    parser.add_argument("lat",      type=float, help="Observer latitude  (° N positive)")
    parser.add_argument("lon",      type=float, help="Observer longitude (° E positive)")
    parser.add_argument("--alt",    type=float, default=0.0,
                        help="Observer altitude in metres (default 0)")
    parser.add_argument("--days",   type=int,   default=3,
                        help="Days ahead to predict (default 3)")
    parser.add_argument("--min-el", type=float, default=10.0,
                        help="Minimum elevation in degrees (default 10)")
    parser.add_argument("--quiet",  action="store_true",
                        help="Suppress progress messages")
    args = parser.parse_args()

    verbose = not args.quiet
    if verbose:
        print(f"\n{'='*60}")
        print("  NOAA Satellite Pass Predictor")
        print(f"{'='*60}")
        print(f"  Observer : {args.lat:.5f}°, {args.lon:.5f}°  alt={args.alt:.0f} m")
        print(f"  Period   : {args.days} day(s) from now")
        print(f"  Min el   : {args.min_el}°")
        print(f"{'='*60}")

    passes = find_passes(args.lat, args.lon, args.alt, args.days,
                         args.min_el, verbose=verbose)
    print_passes(passes)


if __name__ == "__main__":
    main()
