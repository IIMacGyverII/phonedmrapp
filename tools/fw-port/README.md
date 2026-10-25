# fw-port — tools for porting the module firmware work to another phone

Plan and status: `radio_firmware/plan-port-automation.md`. Host only; nothing here touches a radio.

| Script | Does |
|---|---|
| `find_symbols.py <image> [--symbols symbols.csv] [--entries]` | Finds the anchors a port needs in an HR-C7000 (C-SKY V2) image: version string, command dispatch entries, the time-out timer and struct, handlers identified by behaviour (0x3B, 0x34), free flash for stubs; compares with a `symbols.csv`. Prints JSON. |

Validated on the Armor's `radio_firmware/DMR003.UV4T.V022-ORIGINAL.bin` (2026-10-24). The script proposes; a
person confirms every row before a stub is linked against it. The second image (Atom XL `DMR006.U4A.V082`) is the
real test.
