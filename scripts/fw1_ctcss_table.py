#!/usr/bin/env python3
"""Locate and verify the CTCSS tone table in DMR003.UV4T.V022 (C-SKY V2 image, link base 0).

Receive/encode-side analysis only: CTCSS is a sub-audible squelch tone, standard radio
operation. Finding its table has no bearing on TX frequency or band limits.

Result (2026-10-14): table at file offset 0x0366B2, 50 entries, 16-bit little-endian,
units of 0.01 Hz (centihertz). 6700 = 67.00 Hz ... 25410 = 254.10 Hz. 49/50 match the
standard EIA list exactly; index 32 is 177.40 vs the catalogue's 177.3 (a known variant).

Usage: python3 -I scripts/fw1_ctcss_table.py [path-to-bin]
"""
import struct, sys

BIN = sys.argv[1] if len(sys.argv) > 1 else "radio_firmware/DMR003.UV4T.V022-ORIGINAL.bin"
CTCSS_OFFSET = 0x0366B2
COUNT = 50

STD = [67.0,69.3,71.9,74.4,77.0,79.7,82.5,85.4,88.5,91.5,94.8,97.4,100.0,103.5,107.2,
110.9,114.8,118.8,123.0,127.3,131.8,136.5,141.3,146.2,151.4,156.7,159.8,162.2,165.5,
167.9,171.3,173.8,177.3,179.9,183.5,186.2,189.9,192.8,196.6,199.5,203.5,206.5,210.7,
218.1,225.7,229.1,233.6,241.8,250.3,254.1]

def main():
    data = open(BIN, "rb").read()
    vals = [struct.unpack_from("<H", data, CTCSS_OFFSET + 2*k)[0] for k in range(COUNT)]
    print("CTCSS table @ 0x%06X, %d entries, LE16 centihertz" % (CTCSS_OFFSET, COUNT))
    ok = 0
    for k in range(COUNT):
        hz = vals[k] / 100.0
        std = STD[k]
        flag = "" if abs(hz - std) < 0.05 else "  <-- differs from std %.1f" % std
        if not flag:
            ok += 1
        print("  [%2d] 0x%06X = %5d = %6.2f Hz%s" % (k, CTCSS_OFFSET + 2*k, vals[k], hz, flag))
    print("match: %d/%d" % (ok, COUNT))

if __name__ == "__main__":
    main()
