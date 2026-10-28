# SignalDeck website: plan and design brief (for the agent that builds it)

Owner request 2026-10-28. Written by the managing agent; the owner chooses the design and approves every step.
**You build mockups first, the owner picks one, then you build the site in it.** Nothing is published or bought
(domain, hosting, accounts) without the owner's explicit word.

## 1. What the site is for

SignalDeck turns a rugged Android phone with a built-in DMR/FM radio module into a full ham-radio station (DMR, FM,
APRS, SSTV, POCSAG, M17, FT8, Winlink, satellites…). The site is its public home:

| Section | Content | Source of truth |
|---|---|---|
| Home | What it is in one screen, a phone screenshot, Download, supported phones | — |
| Features | One block per mode/tool, with screenshots | SignalDeck `ui/HelpView.java` (`TOPICS`) and `CHANGELOG.md` |
| Supported phones | Each phone, status (verified / beta / in progress), what works | SignalDeck `profiles/profiles.json`, device reports |
| Download | Latest release and beta, how to install, root/Magisk steps | GitHub releases of `IIMacGyverII/SignalDeck` (fetch at build time) |
| Docs / guide | The in-app guide as web pages | `HelpView.TOPICS` (one source, see §4) |
| Firmware | Released module images and what they change | `IIMacGyverII/AndroidRadio_Firmware_Project` `catalog/firmware.json` |
| Changelog | Release notes | GitHub releases ("What's new" sections) |
| Contribute | Donate · take part (test, ideas, community) · fork and make your phone compatible | Same three ways as the app's Contribute page (owner wording, `memory`/SignalDeck) |
| Community (later) | Forums, announcements | §3 |

Audience: licensed hams (many technical, many on phones in the field), preppers/ETC/ARES groups, people who bought
one of these phones and found the radio app weak. The site must read well on a phone outdoors.

## 2. Technology: recommendation

**Astro (static output) + plain CSS with design tokens, content in Markdown/MDX, hosted on Cloudflare Pages or
GitHub Pages. Forums later as a separate Discourse (or GitHub Discussions first), linked and themed to match.**

Why, against the alternatives:

| Option | Verdict |
|---|---|
| Hand-written HTML/CSS | Fine for one page; breaks down at 30+ doc pages (shared header/footer/nav copied everywhere, no content pipeline). Not chosen. |
| React SPA (Vite/CRA) | Wrong shape for a content site: blank page until JS runs, weaker SEO and link previews, heavier on a phone in the field. Not chosen. |
| Next.js (React, SSR) | Good if the site becomes an app with accounts and a database. Today that is overkill and needs a server; the parts that would need it (forums) are better as an off-the-shelf product. Keep as the upgrade path only if a real web app appears. |
| **Astro** | Ships plain HTML by default (fast, SEO, works without JS), Markdown pages out of the box, components for the shared parts, and **React (or Svelte) "islands" only where something is interactive** (a live waterfall, a phone picker, a frequency calculator). Free static hosting. If the site grows, Astro can add server routes, and React components written for islands carry over to Next.js if that day comes. |

Forums: **do not build forum software.** Phase 1: GitHub Discussions on the SignalDeck repo (free, already where the
code is, no moderation infrastructure). Phase 2 when the community outgrows it: Discourse (hosted plan or a small VPS)
at `forum.<domain>`, themed with the same tokens, single sign-on later if accounts appear elsewhere. Chat
(Discord/Matrix) is the owner's choice, linked from Community.

Other choices:
- CSS: design tokens on `:root` (colours, type scale, spacing, radii) with a dark default and a light theme; no CSS
  framework required (Tailwind acceptable if the agent prefers, tokens still drive it).
- Fonts: self-host via Fontsource (no third-party font requests); at most two families plus a mono.
- Images: real SignalDeck screenshots on a demo identity only (see §6); generated art and icons as SVG.
- Analytics: none by default; if the owner wants numbers, a cookie-less one (Plausible/Cloudflare Web Analytics).
- Content build: release list and firmware catalogue fetched at build time, so a rebuild (a GitHub Action on
  release) refreshes them. No runtime API calls from visitors' browsers to GitHub.
- Accessibility: WCAG AA contrast in both themes, keyboard navigation, `prefers-reduced-motion` turns animation off.
- Performance budget: home page under 200 KB before images, Lighthouse ≥ 95 on mobile.

## 3. Growth path

1. Static site (this plan) + GitHub Discussions.
2. Docs generated from the app's help (§4), translations if wanted.
3. Discourse forum on a subdomain, same theme.
4. Only if needed: accounts / a web app (device-report uploads, a station map) → Astro server routes or Next.js,
   with a real backend. Decide then, not now.

## 4. One source for the guide

The in-app guide (`HelpView.TOPICS`) is the authoritative help and is updated with every feature (SignalDeck
CLAUDE.md rule). The site must not fork it by hand. Plan: a small script in the SignalDeck repo exports `TOPICS` to
Markdown (one file per topic) at release time; the site imports those files. Until that script exists, the Docs
section links to the release notes and says the full guide is in the app.

## 5. Ten design concepts (mockup round)

All ten stay in or near the app's theme: dark, technical, glowing instrument readouts, the circuit-board intercom
page, neon channel digits, VU bars. Each concept gets **one home page mockup at phone width (390 px) and desktop
(1440 px), dark and light**, the same content (hero, three feature blocks, supported phones strip, Download,
Contribute teaser, footer), so the owner compares designs, not copy.

| # | Name | Idea | Palette | Type | Signature element |
|---|---|---|---|---|---|
| 1 | **Circuit Deck** | The app's own intercom page, grown into a site: PCB traces route between sections like signals | Near-black green board, copper traces, neon cyan digits | Grotesk sans + seven-segment display face for numbers | Traces that "light up" as you scroll, carrying a pulse to each section |
| 2 | **Waterfall** | An SDR spectrum waterfall as the hero; features sit on the spectrum as signal markers | Deep navy, viridis/inferno heat colours | Technical sans + mono for frequencies | A live, procedurally drawn waterfall (canvas, paused when reduced motion) with labelled "signals" = features |
| 3 | **Front Panel** | The site as a rack transceiver front panel: LCD header, knobs, buttons, labelled bezels | Brushed dark grey, amber LCD, red TX lamp | Condensed sans + LCD segment face | A tuning knob nav: turning it (or swiping) steps through sections like channels |
| 4 | **Phosphor** | Oscilloscope CRT: graticule grid, glowing green traces, Lissajous figures | Black, P1 phosphor green, faint bloom | Mono throughout (IBM Plex Mono / JetBrains Mono) | Section headers drawn as traces; the logo as a Lissajous figure |
| 5 | **QSL** | Every section is a QSL card: stamps, callsign-style headings, postmarks, a modern clean layout underneath | Off-white cards on dark slate, accent red/blue inks | Slab serif headings + clean sans body | Cards that flip to show detail; "confirmed contact" stamps for supported phones |
| 6 | **Ground Station** | Mission control: orbit tracks, telemetry panels, pass countdowns, ISS/APRS/SSTV front and centre | Dark blue-black, telemetry cyan and amber | Wide sans (Space Grotesk-like) + mono telemetry | A slowly rotating globe with ground tracks and radio links between stations |
| 7 | **Field Ops** | Rugged and outdoors: topographic contours, coordinates, waterproof-phone feel, POTA/SOTA/ARES use | Olive/charcoal with signal orange, topo line overlays | Stencil-ish headings + legible sans | Topo map background whose contour lines move subtly; a "grid square" locator badge |
| 8 | **Packet BBS** | Packet radio terminal and 80s BBS: ANSI boxes, blinking cursor, `CONNECT` banners, but crisp and modern | Terminal black, ANSI cyan/magenta/yellow | Mono (with a pixel display face for the logo) | A typed-out AX.25 session as the hero that ends at the Download button |
| 9 | **Blueprint** | RF engineering drawing: cyanotype schematic, Smith chart, dimension lines, title block | Cyanotype blue, white lines, one warm accent | Technical drawing sans + mono annotations | A Smith chart that the page "matches" as you scroll; schematic-symbol icons |
| 10 | **Ionosphere** | Propagation at night: skywave arcs bouncing over the curve of the earth, aurora gradients | Night indigo to teal aurora, star field | Elegant geometric sans | Animated skip-propagation arcs linking the phone to distant stations; band conditions as a decorative ribbon |

Ask the owner which three to take further after the first round; then one final.

## 6. Rules for the building agent

- **No identifying information.** No owner callsign, name, DMR ID, location, IP, or real QTH anywhere: copy,
  screenshots, sample data, commit messages. Screenshots use the demo identity and a fake location (Denver), a demo
  status bar, and every image is reviewed before it is committed (phonedmrapp memory: screenshots rule). Sample
  callsigns: N0CALL, DMRTST-7.
- **No impersonation:** no phone makers' logos or branding beyond naming the supported models in text; no ARRL/RSGB
  or other organisations' marks.
- Licence: the site's own code and text under the same licence family as SignalDeck unless the owner says otherwise;
  every third-party font, image or library listed with its licence; no GPL code copied from radio projects.
- Generated art and icons (owner's standing rule for SignalDeck): produce them, do not ship stock defaults.
- Work in a new repository the owner creates (suggested `IIMacGyverII/signaldeck-site`), never inside SignalDeck's
  or phonedmrapp's working trees; mockups can be published as private Artifacts for the owner to compare.
- Donation links: only the ones the owner supplies; none exist yet (2026-10-28). Never a placeholder that looks live.
- Commit only your own paths; no domain, hosting or paid service without the owner.

## 7. Deliverables and order

1. Ten home-page mockups (§5), phone + desktop, dark + light, shared content. Owner picks three.
2. The three refined, plus one inner page each (a Features page). Owner picks one.
3. The site in Astro: all sections of §1 with real content, build-time release and firmware fetch, the Contribute
   page, GitHub Discussions link, Lighthouse report, deploy preview. Owner approves before any public deploy.
4. The `HelpView` export script (SignalDeck PR, host-tested) so the Docs section follows the app.
