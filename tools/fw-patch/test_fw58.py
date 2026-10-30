# FW58 is FW57 plus the heard-talkgroup store, the All-Call unmute, and the
# op 6 hold guard. F58D only widens opcode 14's window.
import subprocess
import tempfile
import unittest
from pathlib import Path

import fw30_build
import fw58_build
import literal_guard
import space_map

ROOT = Path(__file__).resolve().parents[2]
OBJDUMP = literal_guard.OBJDUMP


def dump(blob, lo, hi):
    with tempfile.NamedTemporaryFile(suffix=".bin", delete=False) as tmp:
        tmp.write(blob)
        path = tmp.name
    try:
        proc = subprocess.run(
            [OBJDUMP, "-b", "binary", "-m", "csky", "-EL", "-D",
             "--start-address=%d" % lo, "--stop-address=%d" % hi, path],
            capture_output=True, check=True)
    finally:
        Path(path).unlink(missing_ok=True)
    return proc.stdout.decode("utf-8", "replace")


def regs(text):
    found = set()
    for line in text.splitlines():
        if ":" not in line or ".long" in line:
            continue
        rest = line.split("\t")[-1]
        for token in rest.replace(",", " ").replace("(", " ").replace(")", " ").split():
            if token.startswith("r") and token[1:].isdigit():
                found.add(int(token[1:]))
    return found


class Fw58(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        fw58_build.build()
        fw58_build.build_diag()
        cls.old = fw58_build.SRC.read_bytes()
        cls.new = fw58_build.DEST.read_bytes()
        cls.diag = fw58_build.DIAG.read_bytes()

    def test_tag_and_hashes(self):
        self.assertEqual(self.new[fw58_build.TAG], b"DMR003.FW58.V022")
        self.assertEqual(self.diag[fw58_build.TAG], b"DMR003.F58D.V022")
        self.assertEqual(len(self.new), len(self.old))

    def test_entries(self):
        sym = fw58_build.SYMBOLS
        self.assertEqual(fw30_build.bsr_target(self.new, 0x26F24), sym["rx_lc_ids"])
        self.assertEqual(fw30_build.bsr_target(self.new, 0x11D18), sym["allcall_3"])
        self.assertEqual(fw30_build.bsr_target(self.new, 0x11D80), sym["allcall_2"])
        self.assertEqual(fw58_build._br_target(self.new, 0x5B2D2), sym["op6_apply"])
        self.assertEqual(fw58_build._br_target(self.new, 0x5BD36), sym["op6_release"])
        with self.assertRaises(SystemExit):
            fw30_build.encode_br(0x11D18, sym["allcall_3"])

    def test_rx_reproduces_the_subi(self):
        lo, hi = fw58_build.CODE["rx_lc_ids"]
        self.assertIn(fw58_build.SUBI_R3_R8_16, self.new[lo:hi])
        self.assertNotEqual(self.new[0x26F24:0x26F28], fw58_build.SUBI_R3_R8_16)
        text = dump(self.new, lo, hi)
        self.assertIn("ld.b", text)
        self.assertIn("0x2", text)
        self.assertNotIn("st.b", text)

    def test_allcall_uses_r2_and_r3_only(self):
        for name in ("allcall_3", "allcall_2"):
            lo, hi = fw58_build.CODE[name]
            text = dump(self.new, lo, hi)
            self.assertEqual(regs(text), {2, 3}, name)
            self.assertIn("bez", text)
            self.assertIn("bmaski", text)
            self.assertIn("jmp", text)
            self.assertNotIn("r15", text)

    def test_hold_word_and_the_existing_marker(self):
        hold = (0x484F4C44).to_bytes(4, "little")
        self.assertIn(hold, self.new[fw58_build.BASE:fw58_build.TAIL_END])
        self.assertEqual(self.new[0x5B2F4:0x5B2FA], self.old[0x5B2F4:0x5B2FA])
        self.assertEqual(self.new[0x5B2B6:0x5B2BC], self.old[0x5B2B6:0x5B2BC])
        self.assertEqual(self.new[0x5B2CC:0x5B2D2], self.old[0x5B2CC:0x5B2D2])
        self.assertEqual(self.new[0x5C58C:0x5C590], self.old[0x5C58C:0x5C590])
        lo, hi = fw58_build.CODE["op6_apply"]
        self.assertFalse(regs(dump(self.new, lo, hi)) & {1, 4})
        lo, hi = fw58_build.CODE["op6_release"]
        self.assertTrue(regs(dump(self.new, lo, hi)) <= {4, 5})

    def test_exits_and_prologues_stay(self):
        for at in (0x11D1C, 0x11D2E, 0x11D84, 0x11D96, 0x5B2D6, 0x5BD3E):
            self.assertEqual(self.new[at:at + 4], self.old[at:at + 4], hex(at))
        self.assertEqual(self.new[0x11A3A:0x11A3E], self.old[0x11A3A:0x11A3E])
        self.assertEqual(self.new[0x26C7E:0x26C82], self.old[0x26C7E:0x26C82])
        self.assertEqual(self.new[0x5B306:0x5B308], self.old[0x5B306:0x5B308])

    def test_only_the_hooks_the_stub_and_the_tag(self):
        changed = {i for i in range(len(self.old)) if self.old[i] != self.new[i]}
        allowed = set(range(fw58_build.TAG.start, fw58_build.TAG.stop))
        allowed |= set(range(fw58_build.BASE, fw58_build.TAIL_END))
        for _name, site, _kind, _exit in fw58_build.HOOKS:
            allowed |= set(range(site, site + 4))
        self.assertTrue(changed <= allowed)
        for _name, site, _kind, _exit in fw58_build.HOOKS:
            self.assertNotEqual(self.old[site:site + 4], self.new[site:site + 4])
        self.assertNotIn(0xC1BA, changed)
        self.assertNotIn(0xC244, changed)

    def test_guards(self):
        tagged = bytearray(self.new)
        tagged[fw58_build.TAG] = self.old[fw58_build.TAG]
        body = bytes(tagged)
        self.assertEqual(literal_guard.covered_loads(self.old, body)[1], [])
        self.assertEqual(literal_guard.covered_branches(self.old, body)[1], [])
        self.assertEqual(literal_guard.never_written(self.old, body), [])
        self.assertEqual(literal_guard.pointed_into(self.old, body), [])
        self.assertEqual(space_map.outside_free(self.old, body), [])

    def test_retarget_windows(self):
        for window in (
            (0x26F24, 0x26F28),
            (0x11D18, 0x11D1C),
            (0x11D80, 0x11D84),
            (0x5B2D2, 0x5B2D6),
            (0x5BD36, 0x5BD3A),
        ):
            self.assertIn(window, space_map.RETARGET)


class F58D(unittest.TestCase):
    def test_window(self):
        diag = fw58_build.DIAG.read_bytes()
        fw = fw58_build.DEST.read_bytes()
        self.assertEqual(diag[fw58_build.WIN_LO:fw58_build.WIN_LO + 4], fw58_build.WIN_NEW[0])
        self.assertEqual(diag[fw58_build.WIN_HI:fw58_build.WIN_HI + 4], fw58_build.WIN_NEW[1])
        changed = {i for i in range(len(fw)) if fw[i] != diag[i]}
        allowed = set(range(0x38464, 0x38474))
        allowed |= set(range(fw58_build.WIN_LO, fw58_build.WIN_LO + 4))
        allowed |= set(range(fw58_build.WIN_HI, fw58_build.WIN_HI + 4))
        self.assertTrue(changed <= allowed)
        self.assertTrue(changed)


if __name__ == "__main__":
    unittest.main()
