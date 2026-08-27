# 03 — UI, UX, and how it looks

The overlay’s visual language is “dark navy + neon + emoji ToggleButtons,” applied by painting OEM views after `initView`. It is recognizable. It is also crowded, inconsistent, and inaccessible. This chapter is about what a user *sees* and *touches*, not packet layouts.

---

## 1. What the intercom actually is

OEM layout (`fragment_talkback_view.xml`): channel ± sprites, two digit sprites, five TextViews whose **XML defaults are Simplified Chinese** (`功率：` `色码：` `发射：` `接收：` `联系人：`), a 176 dp PTT `ImageButton` with no `contentDescription`.

The module then:

1. Paints the root navy (`0xFF0A1520`) and bars darker (`0xFF060D14`).
2. Inserts a horizontal info/location row, RSSI, Soft SQ slider, a 250 dp `CircuitBoardView` “border box,” a spacer, and a `FrameLayout` around the PTT.
3. Floats **six** chrome controls on that FrameLayout by magic `topMargin`s:

| Control | Side | topMargin | Widget |
|---|---|---|---|
| SOFT SQ | left | 8 dp | ToggleButton |
| REC | right | 8 dp | ToggleButton |
| TXT | left | 66 dp | ToggleButton |
| POS / MON | right | 66 dp | Button / Toggle (type-swapped) |
| VFO | left | 124 dp | ToggleButton |
| PKT RAD | right | 124 dp | ToggleButton that **immediately unchecks** and opens a menu |

(`MainHook.java` ~2012–2586)

PKT RAD is the tell: a toggle used as a menu launcher. APRS/SSTV/NOAA then live in a second-level dialog (`showPacketRadioMenu`, `:4526`). Live screens are `setCancelable(false)` — the user cannot see the intercom they just left.

On a phone radio this fights the hardware PTT and the on-screen PTT at the same time. The 176 dp disc plus 52 dp buttons on both sides is the whole lower half of the talk page.

**What “looks better” actually means here:** fewer things around the PTT, not a denser sci-fi overlay.

---

## 2. Theme tokens (there aren’t any)

Hard-coded ARGB, at least four greens and three cyans:

| Token in comments | Literal | Used for |
|---|---|---|
| “dark navy” | `0xFF0A1520` | content |
| “darker” | `0xFF060D14` | system bars |
| “neon green” (rules docs) | `0xFF00FF00` | almost unused in live UI |
| cyan | `0xFF00E5FF`, `0xFF00BCD4`, `0xFF00FFFF` | slider, Soft SQ, traces |
| APRS green | `0xFF00AA00`, `0xFF00E676`, `0xFF69F0AE`, `0xFF004400` | PKT RAD / POS |
| purple | `0xFF7C4DFF`, `0xFF2D1060` | TXT |
| amber | `0xFFFFCA28`, `0xFFFF8F00` | VFO |
| red | `0xFFF44336`, `0xFF500000` | REC |
| CircuitBoardView traces | `0x1800E5FF` | 9% cyan |

Rules docs still list `TEXT_NEON_GREEN = 0xFF00FF00`. The intercom is cyan/purple/amber. Pick one palette, put it in one class, stop painting `0xFF00AA00` next to `0xFF00E676`.

`CircuitBoardView` runs a 20 fps `Handler` loop for the life of the view (`CircuitBoardView.java:52`), including when squelched and when the screen is off-but-attached. It is a battery tax for a background that is behind a caller panel most of the time RX matters.

Channel editor: the module paints rows `0xFF0A1520` then leaves OEM `pri_text_color` (`#ffffffff`) and the OEM selector drawable. White-on-navy is fine; the leftover OEM “more split” assets and stock `ic_menu_info_details` help icons are not “sci-fi,” they are Android 4.

Device tab buttons (`EXPORT (OpenGD77)`, `IMPORT`, `Download RadioID Database`, `Import RadioID CSV`) are default framework `Button`s dropped into a Chinese/English OEM list. They work. They look like a debug screen.

---

## 3. OEM screens the overlay never redesigned

These are daily-driver pain, independent of neon.

### Channel editor

- Frequencies are **integer Hz** with hint `(400000000-480000000)` (`interphone_channel_activity.xml` send/receive `EditText`s, `maxLength=9`, `digits=0-9`). Hams type `462.5625`.
- Encrypt key: `digits=" 1234567890"`, `inputType=number`, `maxLength=8`. Hex `A–F` cannot be typed. DMR keys are hex.
- “Call Number” is a raw ID, not a contact picker. Combined with Pitfall 12 this is how TGs get stored as the wrong integer.
- Bandwidth row is labeled **“Band”** in English strings — the same word the module used to think meant UHF/VHF.
- Group grid is a fixed 450 dp 4-column `GridView` of 32 slots. The module added a TG-list row; the OEM grid is still there underneath.

### Channel list

Bare `ListView`. No search, no analog/digital chip. Zones exist on Intercom and as an editor row; they are not first-class on this tab. Hundreds of imported channels = linear hunt.

### Contacts / SMS

- “Creat new person contact.” People vs Group is icon-only.
- SMS empty string is an ungrammatical run-on. Conversations need digital channel + selected contact; the screen does not say so.
- GPS hyperlinking in the thread (`hookMessageDisplay`) is one of the few overlay wins that feels native. Inbox is untouched.

### Device / Settings

- Camera avatar, then Settings / Information / Area / Factory reset / Use Assistant / Exit.
- BER row is `visibility="gone"`.
- Use Assistant is six OEM sentences. It does not mention Soft SQ, zones, RadioID, backups, or “do not restore a BOM’d CSV.”
- Kill/Revive are in Settings with no amateur-radio stun warning. Radio Check / Call Alert / Remote Monitor are implemented in firmware (`EnhanceMessage.CHECK/CALL_PROMPT/REMOTE_MONITORING`) and have **no UI**.
- “Limit send time” UI is real; the UART TOT is always 0 (`DmrManager.sendSetTotCmdToMdl`).

### Intercom Chinese flash

XML defaults are ZH. Java fills English (or mixed) after `initView`. On a cold start those five lines can flash Chinese. The module never replaces the string resources; it only moves views.

---

## 4. Accessibility and locale

Grep of DMRModHooks `*.java` / `*.xml` for `contentDescription`: **zero hits**.

PTT, channel ±, digit sprites, Soft SQ, REC, TXT, VFO, PKT RAD, POS, MON: all invisible to TalkBack except as “Button” / “Toggle.” Emoji in the label (`🎚️\nSOFT SQ`) is not a substitute.

OEM has 50+ `values-*` locales (quality aside). Every overlay string is an English literal inside `MainHook.java`. A zh-CN device is OEM Chinese chrome + English toasts + English APRS dialogs.

LSPosed Manager shows `app_name` = “DMR Mod Hooks v0.2”. That is the first thing a user sees when enabling the module.

---

## 5. Dialogs as a product surface

Almost every feature is `AlertDialog.Builder` + programmatic `LinearLayout` + `ScrollView` + `setPadding(40,40,40,40)`.

Consequences:

- No rotation / configuration handling.
- No shared toolbar, no consistent Cancel vs Close vs Stop.
- Live APRS/SSTV/NOAA cannot be shoved aside; `setCancelable(false)`.
- Received-stations / received-images / next-passes are walls of `TextView`s, not lists with stable IDs.
- APRS “tap coordinates for map” is an implicit geo intent, not an in-app map.
- Default APRS callsign `N0CALL`, SSID 7, frequency 144.390 (NA). No region preset (EU 144.800, etc.).

This is fine for a debug overlay. It is the reason the app still *feels* like an Xposed experiment after 3.4.x.

---

## 6. Concrete look-and-feel changes (no new features)

Priority is “remove chrome, then unify, then polish.”

1. **Collapse the six PTT satellites to three:** PTT stays; Soft SQ (analog only) and a single **Modes** button that opens APRS/SSTV/NOAA/VFO. REC/TXT/POS move into that sheet or a top overflow. PKT RAD stops being a fake toggle.
2. **One color class.** Navy / cyan accent / danger red. Kill the per-button rainbow. Apply it to Device-tab buttons too.
3. **Replace emoji with drawables** already in `DMRModHooks/app/src/main/res/drawable` (custom PTT sprites exist; the satellites never got the same treatment).
4. **Pause `CircuitBoardView`** when `!isReceiving` and when the fragment is hidden; 5 fps idle, 20 fps only on open squelch.
5. **MHz in the channel editor** (hook the two frequency `EditText`s: display `/1e6`, save `*1e6`). Hex `inputType` on the encrypt key.
6. **Contact picker** on the Call Number row (OEM contact list), write `contact_number` into `txContact`.
7. **Channel list search** + analog/digital/zone chips. This is the highest-leverage OEM-UX fix that is not “more neon.”
8. **contentDescription** on every injected control and on PTT via the talkback hook.
9. **Fix LSPosed label** to `DMRModHooks v3.4.6`.
10. **Use Assistant rewrite** — ten lines: Soft SQ, zones, RadioID, backup folder, “never BOM a CSV,” “reboot after module update.”
11. **Live-mode dialogs cancelable**, with a persistent status chip on the intercom instead of a modal that owns the activity.
12. **Don’t wrap channel names** as the mode indicator. Use a chip / notification. Name wrapping is how crash recovery and the channel list both get confused.

Items 5–7 and 11–12 are UX that also prevent real bugs (P0.1/P0.2/P1.1/P2.1).

---

## 7. What not to do

- Do not add another satellite button (Nearby Repeaters belongs on Device tab, as Claude 16 already places it).
- Do not animate more of the background.
- Do not restyle OEM dialogs one `setBackgroundColor` at a time without a token file — that is how the current rainbow happened.
- Do not ship a second launcher activity (`BackupActivity` is already a light-theme orphan).
