# Plan: Restricted mode (a voluntary PIN lock on features and zones)

Owner idea 2026-10-27: the user sets a PIN and chooses which features and zones stay enabled and visible, so that,
for example, someone with a GMRS licence can limit the app to the zones and features they may use and not
accidentally transmit where they should not, or use modes they do not know yet. **Entirely voluntary**: off by
default, set up by the user, for the user. It is a guard rail, not security. Queued behind the POCSAG/web work and the
range test; app-side only, no firmware change.

## 1. Design

- **Name:** Restricted mode. Device → Restricted mode. Off until the user turns it on and sets a PIN.
- **What it restricts** (each a switch in the setup, grouped):
  - *Zones:* the zones that stay visible; channels outside them are hidden from the channel list, the intercom's
    channel stepping, scan, the zone picker, the VFO (the VFO can be hidden as a whole), SignalDeck Web and Android
    Auto. A hidden channel cannot be selected or transmitted on by any path.
  - *Transmit:* receive-only (no transmit anywhere), or transmit only on the visible zones (the default when zones
    are limited).
  - *Modes:* the PKT sheet's entries one by one (APRS and its sub-features, DTMF, SSTV, FT8, RTTY/PSK31, M17,
    POCSAG, Winlink, terminal, nets, logbook, keyer, schedules, satellites, band scope, fox hunt, exam, pages),
    DMR texts, captions.
  - *Editing and admin:* channel, zone and contact editing; backup and restore; the Device page's firmware line and
    module firmware page; Advanced settings; SignalDeck Web; the Device report; Exit SignalDeck.
- **Presets** as starting points the user can edit and rename, with no claim about any regulation: *Receive only*
  (everything hidden except listening, scan and the visible zones), *Simple radio* (visible zones, talk, no data
  modes, no editing), *Custom*. The help says presets are starting points and that knowing the rules of the licence
  is the user's responsibility.
- **Enforcement at the engine, not only the screens:** `RadioService` keeps the policy and refuses a transmit, a
  channel change to a hidden channel, a mode start or an editor save that the policy forbids, so the side PTT key,
  Android Auto, the widget, SignalDeck Web and the DIAG extras all meet the same rule. The screens then hide what the
  policy hides (removed from menus and tabs, not greyed), so the app looks like a smaller app, not a locked one.
- **One PIN, set when the mode is first turned on.** Turning the mode on asks the user to choose the PIN (entered
  twice) and that PIN is then the only way to turn the mode off or to change what it restricts (owner, 2026-10-27).
- **Turning off and editing are simple and always in the same place:** a lock glyph in the header of every screen
  (and Device → Restricted mode). Tapping it asks for the PIN and shows three choices: **Turn off**, **Edit
  restrictions** (the setup page, saved with the mode still on), or **Unlock for a while** (5 min, 30 min, until
  restart) after which it re-locks by itself. The restricted state persists across app and phone restarts and across
  "Own the radio at boot".
- **PIN handling:** 4–8 digits, stored as a salted hash in the app's prefs, five wrong tries then a one-minute wait.
  Forgotten PIN: there is no back door in the app; the help says plainly that clearing the app's data (or root)
  removes it, which is what makes the feature voluntary rather than a control over someone else.
- **Honesty in the help:** Restricted mode cannot stop someone with the phone's root or adb; it protects against
  mistakes, not against a determined user; nothing in it checks a licence.

## 2. What to build (SignalDeck, one branch `restricted-mode`, one PR)

1. `Restriction` (policy object: visible zones, transmit rule, hidden modes, hidden admin items; load/save; `allows(...)`
   checks) and `RestrictionLock` (PIN hash, tries, unlock timer). Host tests: policy checks, PIN hash and tries, the
   unlock timer.
2. `RadioService`: every transmit path, channel selection, mode start and editor save asks the policy first; refusals
   return the same one-line reason the UI shows ("Hidden by Restricted mode").
3. Screens: channel list, zone picker, intercom stepping and satellites, PKT sheet, tabs, Device page, Advanced,
   editors, Android Auto, the widget, SignalDeck Web (the page list and `/api/*` return only what the policy allows;
   the setup page itself is phone-only).
4. Setup page: Device → Restricted mode: presets, the switch groups, the zone picker, choose the PIN, Turn on; the
   header lock glyph on every screen and its PIN sheet with Turn off / Edit restrictions / Unlock for a while.
5. Help topic "Restricted mode" (what it does, what it cannot do, the forgotten-PIN answer), `CHANGELOG.md` row.

## 3. Bench

- Host tests green.
- Phone (uiautomator): set up with two of five zones visible, FT8 and the editors hidden, transmit on visible zones:
  hidden channels absent from the list and stepping, PTT on a visible channel keys, a DIAG channel change to a hidden
  channel is refused with the reason, PKT sheet without FT8, no editor entry, Web page list filtered, wrong PIN five
  times waits a minute, correct PIN unlocks for 5 minutes and re-locks, survives an app restart and a phone reboot.
- Nothing keyed beyond the one PTT check on the bench channel at low power.

## 4. Rules

- Voluntary and self-imposed: no remote control of the policy, no profile-list advisory can turn it on, nothing is
  reported anywhere.
- No regulation text in the app beyond the one sentence that the rules are the user's responsibility.
- Help and changelog in the same PR; report through the handoff.
