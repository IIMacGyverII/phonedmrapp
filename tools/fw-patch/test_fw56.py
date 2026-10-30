# FW56 is rejected. The space map and the pointer guard both catch it.
import unittest

import fw56_build


class Fw56Rejected(unittest.TestCase):
    def test_the_space_map_refuses_the_build(self):
        with self.assertRaises(SystemExit):
            fw56_build.build()


if __name__ == "__main__":
    unittest.main()
