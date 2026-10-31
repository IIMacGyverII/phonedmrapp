# F62D keeps FW57's behaviour and adds a counter byte on each drop path.
import unittest

import fw30_build
import f62d_build

HOOKS = (
    (0xC0C8, 0x5C59C),
    (0xC12C, 0x5C5A6),
    (0xC14A, 0x5C5B2),
    (0xC15E, 0x5C5BE),
    (0xC168, 0x5C5CE),
    (0xC1A8, 0x5C600),
    (0xC1B6, 0x5C5DA),
    (0xC1BA, 0x5C618),
    (0xC244, 0x5C624),
    (0xC276, 0x5C5EC),
)


class F62D(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        f62d_build.build()
        cls.fw57 = f62d_build.SRC.read_bytes()
        cls.img = f62d_build.DEST.read_bytes()

    def test_tag_and_window(self):
        self.assertEqual(self.img[0x38464:0x38474], b"DMR003.F62D.V022")
        self.assertEqual(self.img[0x5C0CE:0x5C0D2], bytes.fromhex("21ea0300"))
        self.assertEqual(self.img[0x5C0D6:0x5C0DA], bytes.fromhex("21ea0500"))

    def test_hooks_call_the_stubs(self):
        for site, dest in HOOKS:
            self.assertEqual(fw30_build.bsr_target(self.img, site), dest)

    def test_getter_and_dead_branch(self):
        for at in (0x5C60A, 0x5C61E, 0x5C63A):
            self.assertEqual(fw30_build.bsr_target(self.img, at), 0x5C4C8)
        self.assertEqual(self.img[0xC27A:0xC280], bytes.fromhex("6c036c036c03"))

    def test_counters_and_guards(self):
        self.assertEqual(
            [item[1] for item in f62d_build.COUNT],
            list(range(9)))
        f62d_build._guards(self.fw57, bytearray(self.img))

    def test_loop_and_posts_stay(self):
        # The loop head and the instruction after each post are untouched.
        for at in (0xC09E, 0xC0CC, 0xC162, 0xC1AC, 0xC1BE, 0xC248, 0xC280, 0xC2CA):
            self.assertEqual(self.img[at:at + 2], self.fw57[at:at + 2])


if __name__ == "__main__":
    unittest.main()
