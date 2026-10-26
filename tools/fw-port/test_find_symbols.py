#!/usr/bin/env python3
"""Tests for find_symbols.py.  python tools/fw-port/test_find_symbols.py

The Armor's factory image is in the repository: its output must stay byte-for-byte what testdata/ holds (default
and --entries; --symbols is left out because symbols.csv grows). The Atom XL's DMR006.U4A.V076 is not in this
repository (the phone maker's file; the research copy is in AndroidRadio_Firmware_Project): its test runs when a
copy with the right hash is found, else it is skipped.
"""
import hashlib
import json
import os
import re
import subprocess
import sys
import unittest
from pathlib import Path

HERE = Path(__file__).resolve().parent
REPO = HERE.parent.parent
TOOL = HERE / "find_symbols.py"
ARMOR = REPO / "radio_firmware" / "DMR003.UV4T.V022-ORIGINAL.bin"
V076_SHA = "4f5f287bef875fad4a5c8ca9a94c9e841a21f5b507f2cc2a0645d5947e4d40fe"
V076_PLACES = [
    os.environ.get("FW_V076", ""),
    REPO / "temp" / "atomxl_fw_2026-10-26" / "vendor" / "data" / "DMR" / "dmr" / "DMR006.U4A.V076.bin",
    REPO.parent / "phonedmrapp" / "temp" / "atomxl_fw_2026-10-26" / "vendor" / "data" / "DMR" / "dmr" / "DMR006.U4A.V076.bin",
    REPO.parent / "AndroidRadio_Firmware_Project" / "firmware" / "unihertz-atom-xl" / "DMR006.U4A.V076" / "DMR006.U4A.V076.bin",
]


def run(image, *opts):
    out = subprocess.run([sys.executable, "-I", str(TOOL), str(image), *opts], capture_output=True, text=True, check=True).stdout
    return re.sub(r'^ "image": .*$', ' "image": "IMAGE",', out, count=1, flags=re.M)


def v076():
    for p in V076_PLACES:
        if p and Path(p).is_file() and hashlib.sha256(Path(p).read_bytes()).hexdigest() == V076_SHA:
            return Path(p)
    return None


class Armor(unittest.TestCase):
    def test_default_unchanged(self):
        self.assertEqual(run(ARMOR), (HERE / "testdata" / "armor_v022.json").read_text(encoding="utf-8"))

    def test_entries_unchanged(self):
        self.assertEqual(run(ARMOR, "--entries"), (HERE / "testdata" / "armor_v022_entries.json").read_text(encoding="utf-8"))

    def test_switch_names_by_command_byte(self):
        sw = json.loads(run(ARMOR, "--switch"))["switch"]
        self.assertEqual(len(sw), 1)
        s = sw[0]
        self.assertEqual((s["table"], s["base"], s["count"]), ("0x38240", "0x22", 105))
        self.assertEqual(s["named"], {"0x34 version": "0xa7e8", "0x3b set_tot": "0xa308"})   # symbols.csv: cmd34_version_reply 0x00A7E8


@unittest.skipIf(v076() is None, "DMR006.U4A.V076 not found (set FW_V076 to a copy with sha256 4f5f287b...4d40fe)")
class AtomXlV076(unittest.TestCase):
    def setUp(self):
        self.d = json.loads(run(v076(), "--switch"))

    def test_version_and_timer(self):
        self.assertEqual(self.d["version"], {"string": "DMR006.U4A.V076", "offset": 0x33410})
        self.assertEqual(self.d["tot"]["timer_candidates"], [{"idiom": "0x1fc", "struct": "0x38af8"}])

    def test_dispatch_idiom(self):
        t = self.d["thunks"]
        self.assertEqual(t["idiom"], "mov r0, r4; bsr; pop r4-r5, r15")
        self.assertEqual(t["runs"], [{"start": "0xa048", "count": 7}, {"start": "0xa094", "count": 9}, {"start": "0xa0fa", "count": 8}])
        self.assertEqual(self.d["identified"]["0x34 version"], ["0x9f18"])
        self.assertIn("0x9a5c", self.d["identified"]["0x3B set_tot"])

    def test_switch(self):
        sw = self.d["switch"]
        self.assertEqual(len(sw), 1)
        s = sw[0]
        self.assertEqual((s["jump"], s["table"], s["base"], s["count"], s["default_case"]), ("0xa034", "0x33274", "0x22", 103, "0x9fe0"))
        self.assertEqual(s["named"], {"0x34 version": "0x9f18", "0x3b set_tot": "0x9a5c"})
        self.assertEqual(s["commands"]["0x34"]["case"], "0xa09c")
        self.assertEqual(s["commands"]["0x3b"]["case"], "0xa058")


if __name__ == "__main__":
    unittest.main(verbosity=2)
