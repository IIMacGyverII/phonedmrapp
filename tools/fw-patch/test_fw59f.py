# F59F differs from F59D by the tag and one nop where the destination
# compare used to branch past the store.
import subprocess
import tempfile
import unittest
from pathlib import Path

import fw59_build
import fw59f_build
import literal_guard
import space_map

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


class F59F(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        fw59f_build.build()
        cls.old = fw59f_build.SRC.read_bytes()
        cls.new = fw59f_build.DEST.read_bytes()

    def test_only_the_nop_and_the_tag(self):
        self.assertEqual(self.new[fw59f_build.TAG], b"DMR003.F59F.V022")
        self.assertEqual(self.new[fw59f_build.BT:fw59f_build.BT + 2], fw59f_build.NOP)
        changed = {i for i in range(len(self.old)) if self.old[i] != self.new[i]}
        allowed = set(range(fw59f_build.TAG.start, fw59f_build.TAG.stop))
        allowed |= {fw59f_build.BT, fw59f_build.BT + 1}
        self.assertTrue(changed <= allowed)
        self.assertEqual(changed & {fw59f_build.BT, fw59f_build.BT + 1}, {fw59f_build.BT, fw59f_build.BT + 1})
        self.assertEqual(len(changed & set(range(fw59f_build.TAG.start, fw59f_build.TAG.stop))), 1)

    def test_flco_still_skips_and_the_destination_does_not(self):
        text = dump(self.new, 0x5C59C, 0x5C5EA)
        self.assertIn("bnez", text)
        self.assertIn("andi", text)
        self.assertNotIn("\tbt", text)
        self.assertNotIn("\tbf", text)
        self.assertIn("str.w", text)
        self.assertEqual(self.new[fw59_build.WIN_LO:fw59_build.WIN_LO + 4], fw59_build.WIN_NEW[0])

    def test_guards(self):
        tagged = bytearray(self.new)
        tagged[fw59f_build.TAG] = self.old[fw59f_build.TAG]
        body = bytes(tagged)
        self.assertEqual(literal_guard.covered_loads(self.old, body)[1], [])
        self.assertEqual(literal_guard.covered_branches(self.old, body)[1], [])
        self.assertEqual(literal_guard.pointed_into(self.old, body), [])
        self.assertEqual(space_map.outside_free(self.old, body), [])


if __name__ == "__main__":
    unittest.main()
