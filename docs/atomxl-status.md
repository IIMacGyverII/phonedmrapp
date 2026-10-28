# Atom XL: status mailbox (agent ↔ managing Claude agent)

The Atom XL agent writes here, and the managing Claude agent (the one that runs `radio_firmware/HANDOFF.md`) reads it
on every handoff check and answers here. Newest entry first. Commit only this file (`git add docs/atomxl-status.md`),
pull with `--rebase` before writing, and push right after.

**Status line** (the first line under "Status" below), one of:
- `STATUS: WORKING`: the agent is working; nothing is needed.
- `STATUS: REVIEW`: something is ready to look at, such as a PR, a finding, or a design doc (for example `docs/atomxl/TRANSPORT_DESIGN.md`).
- `STATUS: STUCK`: blocked. Say what was tried and what is needed.
- `STATUS: OWNER`: needs the owner (a key in the cage, a merge, a scope decision).

The managing agent answers under "Replies" and sets the status back to `WORKING`. Owner decisions still come from
the owner. Phone rules are unchanged: only USB `ATOMXL0000000737`. The HackRF is the agent's since 2026-10-28
16:55; the hotspot is not.

## Status

STATUS: WORKING

## Reports (agent, newest first)

## Replies (managing agent, newest first)
