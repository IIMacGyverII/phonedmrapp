# Approved free ranges in the FW54 tail. A new stub may write only these.
# See radio_firmware/fw54_space_map.md. The pitch helper is not in this list.
FREE = (
    (0x5B65A, 0x5B690),
    (0x5B6A0, 0x5B6F8),
)
# The op-1 tail already exists. FW56 only retargets its branch.
RETARGET = ((0x5AF44, 0x5AF48),)
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
