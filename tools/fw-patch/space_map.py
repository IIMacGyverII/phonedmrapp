# Approved free ranges in the FW54 tail. A new stub may write only these.
# See radio_firmware/fw54_space_map.md. The pitch helper is not in this list.
# Unreached on FW54, from tailmap.py plus the caller each build cut.
# The pulse table 0x5B6A4-0x5B6FD is live data and is not in this list.
FREE = (
    (0x5B6FE, 0x5B720),
    (0x5BF9E, 0x5C040),
    (0x5C088, 0x5C098),
    (0x5C59C, 0x5C6FC),
)
# FW59's stub occupies the start of the tail hole. F59E's (B) stub starts
# at the next free byte. outside_free still allows the whole hole, because
# both images are checked against FW57.
FW59_USED = (0x5C59C, 0x5C634)
F59E_STUB = 0x5C634
# The op-1 tail already exists. FW56 only retargets its branch.
# FW58 adds five hooks. Release is 4 bytes: 0x5BD30 branches to 0x5BD36, and
# covered_branches allows that only for a one-instruction span. Apply is the
# store at 0x5B2D2. 0x5C550 jumps to 0x5B2CC, and pointed_into rejects a change
# within 4 bytes of that word.
RETARGET = (
    (0x5AF44, 0x5AF48),
    (0x5BDF4, 0x5BDFC),
    (0x26F24, 0x26F28),
    (0x11D18, 0x11D1C),
    (0x11D80, 0x11D84),
    (0x5B2D2, 0x5B2D6),
    (0x5BD36, 0x5BD3A),
)
TAIL = 0x5AEFC


def outside_free(old, new):
    """Changed tail bytes that are not in an approved free range or a retarget."""
    bad = []
    limit = min(len(old), len(new))
    i = TAIL
    while i < limit:
        if old[i] == new[i]:
            i += 1
            continue
        j = i
        while j < limit and old[j] != new[j]:
            j += 1
        if not _allowed(i, j):
            bad.append((i, j))
        i = j
    return bad


def _allowed(start, end):
    for a, b in FREE + RETARGET:
        if a <= start and end <= b:
            return True
    return False
