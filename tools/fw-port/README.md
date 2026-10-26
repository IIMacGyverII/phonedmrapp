# fw-port — tools for porting the module firmware work to another phone

Plan and status: `radio_firmware/plan-port-automation.md`. Host only; nothing here touches a radio.

| Script | Does |
|---|---|
| `find_symbols.py <image> [--symbols symbols.csv] [--entries] [--switch]` | Finds the anchors a port needs in an HR-C7000 (C-SKY V2) image: version string, command dispatch entries, the time-out timer and struct, handlers identified by behaviour (0x3B, 0x34), free flash for stubs; compares with a `symbols.csv`. `--switch` reads the command switch's jump table, so every command byte names its case and handler, and 0x3B / 0x34 are named by byte and by what the handler's own body touches (the plain `identified` list uses a fixed window and can list a neighbour too). Prints JSON. |
| `test_find_symbols.py` | The Armor's output must stay byte-for-byte `testdata/`; the Atom XL V076 test runs when a copy with its hash is found (`FW_V076=<path>`, or the private `temp/` copy, or the AndroidRadio_Firmware_Project checkout next to this one), else it is skipped. |

Validated on the Armor's `radio_firmware/DMR003.UV4T.V022-ORIGINAL.bin` (2026-10-24) and on the Atom XL's
`DMR006.U4A.V076` (2026-10-26; the same jump-table switch, case bodies ending `pop r4-r5, r15` instead of the
Armor's `pop r4-r8, r15`). The script proposes; a person confirms every row before a stub is linked against it.
V076 is not what the Atom XL runs (V082): nothing from it is built for or loaded on an Atom XL.
