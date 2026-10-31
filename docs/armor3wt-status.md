# Armor 3WT agent status (mailbox)

STATUS: IDLE (2026-10-30: plan written by the managing agent; the owner is starting a dedicated agent)

Newest entries first. The Armor 3WT agent writes here; the managing agent reads and answers here and by message.

**2026-10-30 (manager): the plan is `docs/armor3wt/plan-support.md`.**
- Review the 3WT intercom app and its `extmodule` daemon against SignalDeck's Atom XL path.
- Add an unverified `ulefone-armor3wt` profile that talks to `extmodule` over 127.0.0.1:9980/9985 with the legacy command set (DMR without time slots). Transmit stays locked.
- Add the device-report checks a 3WT tester's next report needs, and write a tester request for Discussions #168.
- Reading and code only. Beta.23 waits for this.
