# Research memo: public data sources for "program nearby repeaters + talkgroups"

**Feature under study:** given the phone's GPS fix, download nearby analog-FM and DMR repeaters plus the DMR talkgroups carried on each repeater/timeslot, let the user pick, and write them into the radio's channel/contact tables.

**Research date:** 2026-08-26/27. Every fact below is tagged with the URL it was taken from. Facts I could not confirm against the source's own page are marked **[unverified]** (with the reason). "Live probe" means I fetched the endpoint itself (curl with a descriptive User-Agent, or the WebFetch tool) and inspected the response.

---

## 1. RepeaterBook

### Endpoints
| Region | URL | Notes |
|---|---|---|
| North America (US/CA/MX) | `https://www.repeaterbook.com/api/export.php` | params: `callsign, city, landmark, state_id, country, county, frequency, mode, emcomm, stype` |
| Rest of world | `https://www.repeaterbook.com/api/exportROW.php` | params: `callsign, city, landmark, country, region, frequency, mode` |

- `mode` values: `analog, DMR, NXDN, P25, tetra`; `emcomm`: `ARES, RACES, SKYWARN, CANWARN`; `stype=gmrs` for GMRS. `%` wildcard is accepted (`callsign=kd%kpc`). Source: https://www.repeaterbook.com/wiki/doku.php?id=api
- **There is no lat/lon/radius parameter.** The wiki lists no proximity parameter (checked twice, explicitly). CHIRP's feature ticket confirms: "RepeaterBook has a distance based query called Proximity 2.0 ... but does not have an API with the same functionality" (https://chirpmyradio.com/issues/3261). Every client (CHIRP, dmrfill, MicaelJarniac/repeaterbook) pulls a whole state/country and filters by haversine locally.
- Example (state 41 = Oregon, DMR only): `https://www.repeaterbook.com/api/export.php?state_id=41&mode=DMR`. Live probe on 2026-08-27 without a token returned **HTTP 401** `{"ok":false,"error_code":"auth_missing","message":"Authorization required."}` (same for `exportROW.php?country=Germany`).

### Authentication (changed in 2026)
- "**EFFECTIVE MARCH 31, 2026**: Export API access uses approved token-based authentication. Legacy allowlist handling is transitional and may be limited, changed, disabled, or removed without notice." — https://www.repeaterbook.com/wiki/doku.php?id=api
- Two token types, sent as `X-RB-App-Token: ...` (or `Authorization: Bearer ...`):
  - `app_...` — "centralized" apps; issued **only for backend/server-side use** where the token is never exposed to users.
  - `rbuapp_...` — "distributed app-bound user tokens": for apps "installed by users, runs on desktops/mobile devices, is open source, or otherwise cannot keep a shared token secret." The developer gets the *app* approved; each **end user** then logs into RepeaterBook, goes to `/user/api_apps.php`, picks the approved app, generates a token (shown once) and pastes it into the app. Source: https://www.repeaterbook.com/wiki/doku.php?id=api and https://www.repeaterbook.com/api/token_request.php
- User-Agent must include "an application identifier such as name/version or a project URL" and "a valid contact email address". — wiki api page.
- Commercial cost: search-result snippet of the request form says "For-profit (commercial) entities must purchase access to the API, while non-commercial requests may be approved at no cost, but approval is still discretionary" (https://www.repeaterbook.com/api/token_request.php?step=form&choose_model=1). **[unverified — the form page fetched without login did not show this text; treat as likely but confirm when applying]**

### Rate limits
"Rate limits are intentionally unpublished." 429 on violation; "Clients must back off immediately on 429 responses." — wiki api page. Third-party clients note "Repeaterbook limits the download rate" and cache whole-state dumps locally (https://github.com/desertblade/OpenGD77-Repeaterbook/blob/main/readme.md).

### Response format / fields
JSON by default (wiki). No envelope schema is documented on the wiki; the key names below are the ones actually used by CHIRP (https://raw.githubusercontent.com/kk7ds/chirp/master/chirp/sources/repeaterbook.py) and by the typed model in https://raw.githubusercontent.com/MicaelJarniac/repeaterbook/main/src/repeaterbook/models.py (the two agree; the wiki's "Available Data" list uses slightly different display names, e.g. "Input Frequency" vs key `Input Freq`).

| JSON key | Meaning | Used for |
|---|---|---|
| `State ID` | FIPS state id (NA only) | – |
| `Rptr ID` | RepeaterBook repeater id | dedupe / deep link |
| `Frequency` | repeater output (RX for the user), MHz string | RX freq |
| `Input Freq` | repeater input, MHz string | TX freq → offset |
| `PL` | uplink CTCSS (Hz) or DCS `Dnnn` | TX tone |
| `TSQ` | downlink CTCSS/DCS | RX tone |
| `Nearest City`, `Landmark`, `County`, `State`, `Country`, `Region` (ROW) | location text | name/comment |
| `Lat`, `Long`, `Precise` (0/1) | coordinates; `Precise` = exact vs approximate | distance |
| `Callsign` | repeater callsign | channel name |
| `Use` | OPEN / CLOSED / PRIVATE | filter |
| `Operational Status` | `On-air` / Off-air / Unknown | filter (CHIRP keeps only On-air) |
| `AllStar Node`, `EchoLink Node`, `IRLP Node`, `Wires Node` | linking | comment |
| `FM Analog` (Yes/No), `FM Bandwidth` | analog capable, `Wide`/`Narrow` | mode |
| `DMR` (Yes/No), `DMR Color Code`, `DMR ID` | DMR flag, CC, repeater DMR ID | DMR channel |
| `D-Star`, `NXDN`, `APCO P-25`, `P-25 NAC`, `M17`, `M17 CAN`, `Tetra`, `Tetra MCC`, `Tetra MNC`, `System Fusion` | other digital flags | mode |
| `ARES`, `RACES`, `SKYWARN`, `CANWARN` | emcomm flags | – |
| `Notes`, `Last Update`, `sponsor` | free text / date / object | comment |

**Not in the API:** DMR talkgroups/timeslots. The Anytone CPS *website export* does include talkgroups with timeslot ("RepeaterBook will set the time slot listed for the talkgroup in our database ... If the time slot is not known, the talkgroup will be skipped from export" — https://www.repeaterbook.com/wiki/doku.php?id=radios%3Aanytone_d868uv), but that is an interactive, logged-in web export, not the API, and the API's documented field list has no talkgroup field.

### Coverage
Worldwide; North America is the deep dataset (`export.php`), everything else via `exportROW.php`. Analog + DMR + D-STAR + YSF + P25 + NXDN + M17 + TETRA flags, CC and DMR ID for DMR. Talkgroups: web only.

### Terms / attribution
- "Data courtesy of RepeaterBook.com." required; online use should link to the repeater detail page. Prohibited without written permission: "Model training, bulk extraction, mirroring, redistribution, offline bundling, secondary API use". "Approved programming clients may cache only the minimum data reasonably necessary for the approved workflow and may not redistribute RepeaterBook data as a standalone feed, bulk export, public API, or reusable database". — https://www.repeaterbook.com/wiki/doku.php?id=api
- Legal page: "Any use of any of the materials on this site other than for private, personal, non-commercial viewing purposes is strictly prohibited unless a license is obtained"; scraping/mirroring forbidden; attribution "Data courtesy of RepeaterBook.com" with hyperlink when online. — https://www.repeaterbook.com/index.php/about/legal

### Reliability / cadence
Curated, moderated, per-record `Last Update`. The official mobile app (v26.08.13, Aug 2024 on the App Store listing) ships an offline copy of the database and a paid "Unlimited Access" IAP ($19.99) — https://apps.apple.com/ca/app/repeaterbook/id606820166.

### Fit verdict
**Best analog-FM (and best "which modes does this box run") source for North America, but the hardest to integrate.** Requires app approval + per-user `rbuapp_` tokens (user must create a RepeaterBook account and paste a token), no radius query (must fetch a whole state, then filter locally — and cache "only the minimum"), unpublished rate limits, no talkgroups, and a non-commercial-only free tier. Use it as an *optional, user-enabled* provider for FM/tone data, never as the mandatory backbone.

---

## 2. BrandMeister Halligan API v2

### Endpoints (verified from the OpenAPI spec)
Spec: `https://api.brandmeister.network/api-docs?api-docs.json` (OpenAPI 3.0, "Halligan API" 2.1.0, server `https://api.brandmeister.network/v2/`). Swagger UI at https://api.brandmeister.network/docs/ (JS-rendered; the wiki index https://wiki.brandmeister.network/index.php/API/Halligan_API only points there).

| Method / path | Auth | What it returns | Notes from spec |
|---|---|---|---|
| `GET /device` | none | array of `DeviceIndex` for every device seen in the last day (repeaters **and** hotspots) | "This response is cached and is not real-time data; clients should not poll this endpoint more than once every 15 minutes." Live probe: **32,819** devices, 9.7 MB. |
| `GET /device?repeater=true` | none | "Only list 6-digit repeaters seen in the last 7 days" | Live probe: **3,598** devices, 1.07 MB; 3,127 have non-zero lat/lng; 429 have tx==rx (simplex nodes registered with 6-digit IDs). |
| `GET /device/{id}` | none | `Device` (full record, incl. `website`, `description`, `statusText`, `permissions`) | live example below |
| `GET /device/{id}/profile` | none | `DeviceProfile`: `staticSubscriptions[]`, `dynamicSubscriptions[]`, `timedSubscriptions[]`, `clusters[]`, `blockedGroups[]`, `autoStatic` | "configuration as known by the last master ... not real-time" |
| `GET /device/{id}/talkgroup` | none | array of `StaticTalkgroup {talkgroup, slot, repeaterid}` (strings) | static TGs only |
| `GET /device/byCall?callsign=` | none | devices by callsign | |
| `POST /device/{id}/talkgroup`, `DELETE /device/{id}/talkgroup/{slot}/{group}`, `GET .../action/dropCallRoute/{slot}`, `dropDynamicGroups/{slot}`, `dropAutoStaticGroup`, `removeContext`, `getRepeater`, `PUT .../devicepassword` | **api_key** (Bearer JWT) | sysop write actions | not needed for this feature |
| `GET /master`, `GET /master/{id}` | none | `{id, country, address}`; 40 public masters | |
| `GET /talkgroup` | none | object `{ "id": "name", ... }` | live probe: **1,833** talkgroups, 44 KB |
| `GET /talkgroup/{id}` | none | `{ID, Name}` e.g. `3100` → "USA Bridge" | |
| `GET /registry/{id}`, `/registry/byCall/{call}` | none | registry profile | cached, ≤1/min |
| `GET /selfcare/...` | api_key | own profile | |

Security scheme: `api_key` = "API Key, sent as 'Authorization: Bearer xxx' header", JWT. Only the write/sysop/selfcare operations list it; all read endpoints above have no `security` entry (spec) and returned 200 without a key (live probe). Pi-Star's `pistar-bmapi` uses exactly this header + a User-Agent of `"Pi-Star cli tool for: ${DMRID}"` (https://raw.githubusercontent.com/AndyTaylorTweet/Pi-Star_Binaries_sbin/master/pistar-bmapi).

### Response fields
`DeviceIndex` (list endpoints): `id, lastKnownMaster, callsign, linkname, hardware, firmware, tx, rx, colorcode, status, lat, lng, city, pep, agl, last_seen`.
`Device` (single): adds `website, priorityDescription, description, updated_at, created_at, permissions[]`, plus `statusText` in the live response.

Live example `GET /device/235454` (GB7BB): `tx 439.7125, rx 430.7125, colorcode 1, status 3, statusText "Both Slots Linked", lastKnownMaster 3102, lat 57.66, lng -2.6, city "Banff, IO87QP", pep 1, agl 0, last_seen "2026-08-27 00:10:32"`. **Note tx/rx are from the repeater's point of view** (tx = repeater output = what the user receives).
`GET /device/235454/talkgroup` → `[{"talkgroup":"23558","slot":"1","repeaterid":"235454"},{"talkgroup":"235414","slot":"1","repeaterid":"235454"}]`.
`GET /device/235454/profile` → `staticSubscriptions[{talkgroup,slot,repeaterid}]`, `timedSubscriptions[{recordid,repeaterid,talkgroup,slot,data:{startDate,endDate,monday..sunday,start,stop}}]`, others empty.

`status` codes (from https://coloradodigital.net/2019/12/01/using-the-brandmeister-api/ via search snippet, consistent with live `statusText`): 1 = only TS1 linked, 2 = only TS2 linked, 3 = both slots linked, 4 = simplex node; live data also shows 0 (offline/unknown). **[status table partially unverified — only "3 = Both Slots Linked" confirmed live]**

Repeater vs hotspot: use `?repeater=true` (6-digit IDs) and/or `tx != rx`. Unfiltered list: 24,256 of 32,819 devices are simplex (hotspots), 29,908 have 7-digit IDs; `hardware` is mostly `MMDVM_MMDVM_HS_Hat` etc. for hotspots, `linkname` "Motorola IP Site Connect"/"Hytera Multi-Site Connect"/"Homebrew Repeater" for real repeaters (live probe).

### Rate limits
Response headers on every call: `x-ratelimit-limit: 60`, `x-ratelimit-remaining: N` (live probe) → 60 requests/min per client. Spec asks not to poll `/device` more than every 15 min and registry endpoints more than once/min.

### Coverage
Worldwide, but **only BrandMeister-connected** repeaters (no DMR+, DMR-MARC/c-Bridge, TGIF, IPSC2, FreeDMR, private). Only DMR. Static TGs per timeslot via `/talkgroup` or `/profile`; dynamic TGs via `/profile.dynamicSubscriptions` (what is currently keyed up, not what the sysop intends). Talkgroup **names** via `/talkgroup`. No CTCSS (irrelevant), no analog data.

### Terms
No published terms-of-use or attribution page found for the read API (wiki API index, help.brandmeister.network API Manager page, and the user-API-key news post cover only keys; none mention terms or limits). **[unverified — no ToS located]** User API keys are "unique to a Brandmeister user account" and grant full selfcare access, so they must never be embedded in an app (https://news.brandmeister.network/introducing-user-api-keys/).

### Reliability / cadence
Live from the masters (`last_seen` timestamps were minutes old). `/device` is cached server-side; profile is "as known by the last master".

### Fit verdict
**Primary DMR source.** Free, no key for reads, radius-capable via client-side haversine on the 1 MB `?repeater=true` list (cache 15 min – 24 h), gives RX/TX/CC/static TGs per slot/TG names — exactly the DMR data model. Gaps: only BM repeaters; ~13% of repeater entries lack coordinates; `lat/lng` are self-reported by sysops.

---

## 3. RadioID.net

### Endpoints
- Static dumps (verified by HEAD/GET on 2026-08-27):
  - `https://radioid.net/static/rptrs.json` — 5.78 MB, `Last-Modified: Wed, 26 Aug 2026 05:00:09 GMT`. Top-level `{"rptrs":[...]}`, **11,028** records.
  - `https://radioid.net/static/user.csv` — 16.9 MB, Last-Modified 05:01 the same day. `https://radioid.net/static/users.json` — 84.4 MB. (Also `database.radioid.net/static/...` mirrors, per https://database.radioid.net/api/.)
  - `https://radioid.net/static/rptrs.csv` → **HTTP 404** on 2026-08-27 (CSV repeater dump appears to have been removed).
  - Download listing page `https://radioid.net/database/dumps` is behind a Cloudflare "Checking your browser" challenge — **[page contents unverified]**; the daily-ish Last-Modified stamps (both files stamped ~05:00 UTC) imply a nightly regeneration **[cadence inferred, unverified]**.
- REST API (https://radioid.net/api/): list endpoints `/api/repeaters/dmr|nxdn|p25|dstar`, `/api/users`, `/api/users/cplus`, `/api/users/nxdn`; lookup endpoints `/api/dmr/repeater/`, `/api/nxdn/repeater/`, `/api/p25/repeater/`, `/api/dstar/repeater/`, `/api/dmr/user/`, `/api/cplus/user/`, `/api/nxdn/user/`. GET only. Filters: `id, callsign, name, city, state, country, page, per_page (max 200)`; repeater-specific `trustee, frequency, network, module, band, details`; `%` wildcard; repeated params for multi-select.
  - Example `https://radioid.net/api/dmr/repeater/?ipsc_network=Brandmeister&state=Texas` → `{"count":329,"page":1,"pages":2,"per_page":200,"results":[...]}` (live probe). `?city=Portland&country=United States` → 8 results.
  - **No lat/lon or radius parameter.** Filter by `state`/`country`/`city` then haversine locally — except RadioID has **no coordinates at all** (see fields).
- Auth: "Optional `X-API-Token` header (not required yet)"; "automated clients should include a descriptive User-Agent with contact information" (https://radioid.net/api/).

### Fields
`rptrs.json` record (live): `locator` (=`id`), `id`, `callsign`, `city`, `state`, `country`, `frequency` ("440.58750", repeater output), `color_code` (int), `offset` ("+5.000"/"-0.600", MHz, sign = input relative to output), `assigned` (Peer/Master/None), `ts_linked` ("TS1 TS2" / "TS1" / "TS2" / "Mixed Mode"), `map_info`, `map` (0/1 — a display flag, **not** coordinates), `ipsc_network` (free text: "BM", "Brandmeister", "BrandMeister", "DMR-plus", "DMR-MARC", "NEDECN", ... — needs normalisation), `trustee[]`, `status` (all 11,028 are "ACTIVE"), `talkgroups[]`.
API record adds `identity_id`, `coverage`, `details`, `last_master`, `manufacturer`, `status: "on-air"`.
`talkgroups[]` item: `{"talkgroup": 31487, "description": "TX ARES EmComm", "timeslot": 1, "discovery": 0}` (live, N5VGQ 310016 and W1IMD 7210).
Stats (live): 4,673 of 11,028 repeaters have a non-empty `talkgroups` list; countries: US 4,843, DE 758, IT 560, CA 441, UK 418; networks: BM-family ≈5,770, DMR-plus/DMR+ 843, DMR-MARC 172, None/blank ≈530.

### Terms
"Do not mirror or re-publish RadioID as a public feed, bulk export, reusable database, competing directory, or commercial data service without written permission." "Excessive requests, bulk mirroring, competing uses, or screen-scraping for reuse may be blocked." Same policy covers API, static dumps and scraping. — https://radioid.net/api/ and https://database.radioid.net/api/ (search snippet). No attribution string mandated on the page.

### Fit verdict
**Best cross-network DMR talkgroup/timeslot source** (covers BM, DMR+, DMR-MARC, regional c-Bridges) and the only place with a sysop-declared TG→timeslot table for non-BM systems. But: **no coordinates** (must geocode `city,state,country` or join to BrandMeister/hearham by DMR ID/callsign), free-text network names, `offset` needs parsing, unknown TG names for many entries (description often blank). The dump is a single 5.8 MB file updated nightly — cache it on device and query offline. This app already ships a RadioID user-DB pipeline (see `10-mod-recording-transcription-radioid.md`), so the ingestion path exists.

---

## 4. RadioReference Web Service

- Protocol: SOAP (WSDL `http://api.radioreference.com/soap2/?wsdl&v=latest`, rpc or doc style; version 18 is current and adds TDMA control-channel attributes; earlier versions carry DMR colour codes / NXDN attributes). — https://wiki.radioreference.com/index.php/RadioReference.com_Web_Service3.1
- Auth: every call carries `authInfo{appKey, username, password, version, style}`; appKey is requested from support ("submit a support request ... support@radioreference.com"), "completely free to use by developers", but "End users must have an active premium subscription to access the data through the API." — https://wiki.radioreference.com/index.php/API
- Premium price: $15 / 6 mo, $30 / yr, $60 / 2 yr (https://www.radioreference.com/premium/).
- Key policy (support article https://support.radioreference.com/hc/en-us/articles/18844460198932-Database-Web-Service-API, **fetch returned 403 — quoted from search snippet, unverified**): keys are not issued for apps that "reproduce, mirror, or substitute for the public RadioReference.com website"; each end user authenticates with their own credentials and premium subscription; RR "is happy to support developers who are extending what users can do with their radios".
- Data: location-oriented methods `getZipCodeInfo`, `searchCountyFreq/MetroFreq/StateFreq`, `getCountyFreqsByTag`, `getTrsSites`, `getTrsDetails` (trunked systems incl. DMR/NXDN/P25 attributes). Amateur data exists ("Amateur Radio Database" referenced on the API page) but RR is fundamentally a public-safety/business scanner database; no amateur talkgroup-per-repeater model.
- Terms: credentials must not be hard-coded; premium status verified per user. No support for individual apps (https://wiki.radioreference.com/index.php/RadioReference.com_Web_Service).

**Fit verdict: no.** Paid per-user subscription, SOAP, password-based auth inside the app, and it targets commercial/public-safety trunked systems rather than amateur repeaters + talkgroups. Only relevant if the app later adds a "scanner" mode for commercial DMR (Tier III / Cap+) systems.

---

## 5. hearham.com

- Endpoint: `https://hearham.com/api/repeaters/v1` — single JSON array, **22,644** records, 9.47 MB, `application/json`, no auth (live probe 2026-08-27). Site text: "Free to use and free to use in your application", "download or use in your offline/online application", ">22,000 repeaters" — https://hearham.com/repeaters. No documented query parameters (whole-world dump only).
- Fields (live): `id, callsign, latitude, longitude, city, group, internet_node, mode, encode, decode, frequency (Hz, int), offset (Hz, signed int), description, power, operational (0/1), restriction`.
  - `mode` is free text with trailing whitespace: `FM` 15,284; `DMR` 5,867 (+150 "DMR    ", 27 "DMR/FM"); `D-STAR`/`D-star`/`DSTAR` ≈570; `YSF`/`YSF/FM` ≈430; `P25`/`P25/FM` ≈130; `NFM`, `AX25`.
  - For DMR the colour code is stuffed into `encode` as `"CC4"`; no talkgroups, no timeslots, no DMR ID. CTCSS in `encode`/`decode` as `"100.0"`.
  - `group` = source list: `DMR` 5,495, `Allstar` 2,850, `RSGB` 1,870, `IRLP` 1,850, `FASMA` 1,414, `WIA` 971 ... — i.e. it is an aggregation of other public lists (descriptions say e.g. "Sourced from New England Repeater Directory"; Australia "sourced with permission from the WIA" — https://hearham.com/repeaters/11128/).
  - `operational`: 19,189 = 1, 3,455 = 0.
- Licence: no explicit licence text; the terms page has nothing on data licensing (https://hearham.com/terms). The companion app Repeater-START is GPL-2.0 (https://github.com/programmin1/Repeater-START). **[licence of the data itself unverified — "free to use in your application" is the only statement]**
- Cadence: not documented; crowd-edited with reachability voting.

**Fit verdict: good zero-friction fallback for analog FM + coordinates worldwide**, and a geo-index to attach coordinates to RadioID/BM records by callsign. Data quality is uneven (mode strings, missing tones), no talkgroups.

---

## 6. Other sources (one line each unless notable)

| Source | Machine-readable? | Notes / URL |
|---|---|---|
| **repeatermap.de** (DK3ML; Germany-centric, worldwide entries) | JSON HTTP API, **token by request via contact form, no self-registration**; radius search around a position; default = all FM+DMR in Germany; rate limits "planned"; officially integrated into qdmr on 18.04.2026. https://www.repeatermap.de/api.php, https://repeatermap.de/news.php. qdmr's author notes only frequencies/callsigns are reliable; CTCSS/CC are plaintext (https://github.com/hmatuschek/qdmr/discussions/170). |
| **TGIF Network talkgroups** | `https://api.tgif.network/dmr/talkgroups/json` (3,129 records: `id, name, website, description` — description is base64) and `.../csv` (`TG Number,TG Name`). Live probe. Links from https://tgif.network/talkgroups.php. Only TG names; TGIF has no repeater list API found. |
| **Pi-Star `TGList_BM.txt`** | `https://www.pistar.uk/downloads/TGList_BM.txt` (51 KB, 1,843 lines, "Sourced from https://api.brandmeister.network/v2/talkgroup", updated 25 Aug 2026 — live probe). Derived from BM; use BM directly. Format per third-party notes: `ID;TG/REF/PC;Name;Description` **[format unverified beyond header]**. |
| **DMR-MARC** | Site live; registration and "Worldwide Repeater and Subscriber Databases" redirected to RadioID.net; TG list only as an Excel file `FAQ/worldwide-talkgroups-v4.2.xlsx` (https://www.dmr-marc.net/). Use RadioID instead. |
| **UK: ukrepeater.net (RSGB ETCC)** | CSVs `https://www.ukrepeater.net/csvcreate_all.php` etc. (header `"CALL","BAND","CHAN","txMHz","rxMHz","CTCSS","QTHR","WHERE","lat","lon","ANALOG","DMR","DSTAR","FUSION"`, ~1,300 rows; DMR CC not included) — https://www.ukrepeater.net/csvfiles.html. Newer JSON API `https://api-beta.rsgb.online/{all|band|callsign|keeper|locator}/{x}` with `tx, rx, ctcss, txbw, band, locator, modeCodes ["A","D","M:1"(=DMR CC1),"F","P","N",...]`, `status` — no lat/lon (Maidenhead only), no auth documented, no licence stated. Live probe of `/locator/IO91` OK (76 KB). |
| **Australia: WIA Repeater Directory** | `http://www.wia.org.au/members/repeaters/data/` — public PDF + CSV ("WIA Repeater Directory 260705.csv") + zip with CHIRP CSVs; "© WIA all rights reserved", no licence text. hearham already ingests it "with permission". |
| **Germany: DARC** | No official CSV/JSON export found; DARC points to repeatermap.de. Only district PDFs. **[negative result]** |
| **Austria: ÖVSV repeater-db** | Apache-2.0 open DB with REST API `https://repeater.oevsv.at/api/` (`/api/site`, `/api/trx`; filters `dmr`, `band`, `lat/lon`) — https://github.com/oevsv/repeater-db. |
| **USA regional: WWARA (Pacific NW)** | Nightly `https://www.wwara.org/DataBaseExtract.zip` with lat/lon (some fuzzed to 50 mi), copyright WWARA, no licence — https://www.wwara.org/coordinations/coordination-data-files/. |
| **CHIRP data mirror** | CHIRP no longer hits RepeaterBook live; it downloads pre-built, XZ-compressed per-state JSON from `https://data.chirpmyradio.com/rb/rb{service}-{country}-{state}.json.xz`, ETag-validated, 30-day cache (https://raw.githubusercontent.com/kk7ds/chirp/master/chirp/sources/repeaterbook.py). That mirror exists under CHIRP's own arrangement with RepeaterBook — **not** a public API for us. |
| **OpenRepeater** | A repeater-controller software project, not a data source. |
| **Ham Radio Deluxe / RT Systems** | Consume RepeaterBook through a private partnership API ("no additional subscription fees", Google geocoding + radius + bands — https://www.repeaterbook.com/wiki/doku.php?id=rt_systems). Not reusable. |

---

## 7. How existing tools do it (UX reference)

- **CHIRP** ("Query Sources → RepeaterBook"): inputs `lat, lon, dist` (km), free-text `filter`, `bands` (populated from the selected band plan), `modes` (FM/DMR/DV/DN), `openonly`, `fmconv` ("convert to FM" — keeps digital+analog repeaters usable on an analog radio when `'FM Analog' == 'Yes'`), cached results. Field mapping: `Frequency`→freq; `Input Freq`→duplex/offset (`duplex='off'` if 0); `PL`→TX tone (`D`-prefix ⇒ DTCS, contains `.` ⇒ CTCSS); `TSQ`→RX tone; mode priority DMR→DV(D-STAR)→DN(Fusion)→FM; name = `Landmark` else `Callsign`; comment = callsign/city/county/state/use/notes; drops anything whose `Operational Status` ≠ "On-air". Sources: https://raw.githubusercontent.com/kk7ds/chirp/master/chirp/sources/repeaterbook.py, https://chirpmyradio.com/issues/3261, https://chirpmyradio.com/issues/10237.
- **RT Systems**: File » External Data » RepeaterBook Search: location text (geocoded), radius, bands; results open in a new tab for editing/copying before write (https://www.repeaterbook.com/wiki/doku.php?id=rt_systems).
- **RepeaterBook mobile app**: nearby list with distance + bearing, search by town/ZIP/callsign/frequency/locator/coordinates, filters distance/band/service, sort by distance/frequency/band/tone/call/bearing, fully offline DB (https://apps.apple.com/ca/app/repeaterbook/id606820166).
- **Anytone CPS**: no in-CPS import; RepeaterBook's web export produces Anytone `Channels/Talkgroups/ScanList/Zone` CSVs with CC, timeslot per TG and contact name, skipping TGs whose timeslot is unknown (https://www.repeaterbook.com/wiki/doku.php?id=radios%3Aanytone_d868uv).
- **OpenGD77**: RepeaterBook Export » Radioddity » OpenGD77 `Channels.csv` (CC defaults 1, TG List "None/DMR MARC/Brandmeister") — https://www.repeaterbook.com/wiki/doku.php?id=radioddity_gd_77; community scripts build zones from `(name, lat, lon, radius km)` tuples and warn about the 1,024-channel cap (https://github.com/desertblade/OpenGD77-Repeaterbook/blob/main/readme.md).
- **dmrfill (qdmr/dmrconf)**: sources `RADIOID_DMR` (with talkgroups) and `REPEATERBOOK_FM` (needs key); filters state/county/city/country/band, on-air+open only, proximity radius in mi/km; builds one **zone per DMR repeater** containing one channel per (talkgroup, timeslot), one consolidated zone for FM, contacts from TGs, group lists per zone/timeslot; name templates with truncation to 16 chars (`"$state_code $city:6 $callsign"`); option to drop DMR repeaters with no TG list (https://github.com/jancona/dmrfill).
- **qdmr 0.12+**: repeatermap.de radius auto-completion (token), "region selection for repeater book"; RadioID queried for DMR repeaters "including talkgroups" (https://dm3mat.de/software/qdmr, https://github.com/hmatuschek/qdmr/releases/tag/v0.12.0).
- **Pi-Star / DroidStar**: TG pick-lists are just the BM `/v2/talkgroup` map (and TGIF's CSV) — names only.

**Good UX distilled:** radius slider (default 30–50 km, 10–200), band chips (2 m / 70 cm / other), mode chips (FM / DMR / "digital→FM"), "on-air & open only" toggle, results sorted by distance with distance+bearing, callsign, RX freq, offset sign, tone/CC, network badge, TG count; multi-select with select-all; dedupe by (callsign, RX freq) across sources; preview of the channel/zone/contact count against the radio's limits before writing; per-source attribution line.

---

## 8. DMR data model needed and who supplies what

To program one DMR repeater the radio needs:

| Field | RepeaterBook API | BrandMeister v2 | RadioID | hearham |
|---|---|---|---|---|
| RX freq (repeater output) | `Frequency` | `tx` | `frequency` | `frequency` (Hz) |
| TX freq / offset | `Input Freq` | `rx` | `offset` (signed MHz string) | `offset` (Hz) |
| Colour code | `DMR Color Code` | `colorcode` | `color_code` | `encode` = "CCn" (hack) |
| Repeater DMR ID | `DMR ID` | `id` | `id`/`locator` | – |
| Timeslot per talkgroup | – | `/device/{id}/talkgroup[].slot` (static), `/profile` (static + timed + dynamic) | `talkgroups[].timeslot` | – |
| Talkgroup ID | – | `talkgroup` | `talkgroup` | – |
| Talkgroup name | – | `/talkgroup` map | `description` (often blank) | – |
| Call type | – (always Group for TGs) | Group | Group (`discovery` flag unexplained) | – |
| Network (BM / DMR+ / MARC) | – (notes only) | implicit BM | `ipsc_network` (free text) | `group`/description |
| Coordinates | `Lat`,`Long`,`Precise` | `lat`,`lng` (87% populated) | **none** | `latitude`,`longitude` |
| On-air status | `Operational Status` | `status`/`last_seen` (live!) | `status` (always ACTIVE) | `operational` |
| Analog FM + CTCSS/DCS | `FM Analog`,`PL`,`TSQ`,`FM Bandwidth` | – | – | `mode`,`encode`,`decode` |
| Other digital modes | flags | – | separate NXDN/P25/D-STAR endpoints | `mode` text |

Derived rules: RX = repeater output; TX = RX + offset (RadioID `"+5.000"` → +5 MHz; hearham `-600000` Hz). Channel = (repeater, timeslot, talkgroup); a repeater with N static TGs yields N channels (one zone per repeater as dmrfill does), plus the "TS1/TS2 local" and a "TG 9 / current" catch-all channel if desired. Contacts = union of TG IDs with names from BM `/talkgroup` → RadioID `description` → TGIF list. Group/RX lists = per repeater/timeslot.

---

## 9. Comparison matrix

| | RepeaterBook | BrandMeister v2 | RadioID | hearham | RadioReference | repeatermap.de | TGIF/Pi-Star lists |
|---|---|---|---|---|---|---|---|
| Auth | approved app + per-user `rbuapp_` token | none for reads | none (optional `X-API-Token`) | none | dev key + per-user premium login | token by e-mail request | none |
| Radius query | no (state/country only) | no (download list, filter locally) | no (state/city only, no coords) | no (single world dump) | zip/county-based | yes | n/a |
| Analog FM + tones | yes (best) | no | no | yes (patchy) | yes (non-amateur focus) | yes (plaintext) | no |
| DMR CC | yes | yes | yes | "CCn" text | trunked only | plaintext | no |
| DMR ID | yes | yes | yes | no | no | ? | no |
| TG + timeslot | **no** | yes (static/dynamic, BM only) | yes (all networks, 42% of repeaters) | no | no | no | names only |
| TG names | no | yes (1,833) | partial | no | n/a | no | yes (TGIF 3,129) |
| Coordinates | yes | yes (87%) | **no** | yes | via zip | yes | n/a |
| Coverage | world (NA deepest) | BM world | DMR world (11k) | world (22.6k) | US/CA-centric | DE-centric | networks |
| Rate limit | unpublished, 429 | 60/min headers; /device ≤ every 15 min | unspecified, blocks abuse | none stated | n/a | "planned" | none |
| Caching allowed | "minimum necessary", no offline bundling | nothing stated | no mirroring/re-publishing | free to use offline | per-user | ? | yes |
| Attribution | mandatory text + link | none stated | none stated | none stated | n/a | ? | none |
| Cadence | continuous, per-record date | live | nightly dump | crowd, unknown | continuous | ? | daily |
| Verdict | optional add-on for FM (NA) | **core DMR** | **core TG/TS + non-BM DMR** | **core FM + geo fallback** | reject | EU niche, needs token | TG names fallback |

---

## 10. Recommended combination

1. **DMR backbone = BrandMeister `/v2/device?repeater=true`** (1 MB, cache 24 h, refresh ≤ 1/15 min) → haversine radius filter on `lat/lng` → for each selected repeater fetch `/device/{id}/talkgroup` (static TGs with slot; ≤ 60 req/min, so batch lazily as the user expands a row) and resolve names from the cached `/v2/talkgroup` map. Fields map 1:1 onto RX/TX/CC/TS/TG.
2. **Non-BM DMR + richer TG tables = RadioID `rptrs.json`** (5.8 MB nightly; the app already has RadioID ingestion). Join to BM by DMR ID; for repeaters that are not on BM (DMR+, MARC, c-Bridge, ~5,000 records) use RadioID's `talkgroups[]` (timeslot included). RadioID has no coordinates, so geolocate via (a) BM `lat/lng` when the ID matches, (b) hearham by callsign, (c) a `city,state,country` geocode cache as last resort; show these as "approx. location" in the UI.
3. **Analog FM = hearham `/api/repeaters/v1`** (9.5 MB, no auth, coords included) as the default provider; normalise `mode` strings, `frequency`/`offset` in Hz, `encode`/`decode` tones, drop `operational == 0`. Attribute the underlying lists (RSGB, WIA, etc.) as hearham shows them.
4. **RepeaterBook as an opt-in provider** (settings → "Connect RepeaterBook account"): apply for a distributed-app approval, let the user paste an `rbuapp_` token, query `export.php?state_id=` / `exportROW.php?country=` for the user's current state/country, filter by radius locally, keep only the session cache, show "Data courtesy of RepeaterBook.com" with deep links. Use it to upgrade FM tone/bandwidth accuracy and `Precise` coordinates in North America. Do not ship without the token flow; do not bundle its data offline.
5. **Names fallback**: TGIF JSON for TGIF TG names if the repeater's `ipsc_network` says TGIF; otherwise BM map.
6. **Skip**: RadioReference (paid per user, SOAP, wrong domain), repeatermap.de (manual token, EU only — revisit for a German-market release), CHIRP's mirror (private), DMR-MARC (defunct data path).
7. **Dedupe key**: normalised callsign + RX frequency (±2.5 kHz); prefer BM > RadioID > RepeaterBook > hearham for DMR fields, RepeaterBook > hearham for analog fields. Persist per-record `source` + `fetched_at` so the UI can show provenance and staleness.

### Open items to confirm before implementation
- RepeaterBook commercial/non-commercial pricing and whether a Play-Store app with IAP counts as "for-profit" (form text only seen in a search snippet).
- BrandMeister: no written ToS for the read API — worth an e-mail to the BM team stating the intended 24 h cache of `/device?repeater=true`.
- RadioID: confirm that an on-device cached copy of `rptrs.json` for a single user is acceptable under "no mirroring" (their policy targets re-publishing; a per-user cache is the pattern HBlink/CPS tools already use, but it is not spelled out).
- hearham: no explicit data licence; ask contact (at) hearham.live for a written OK and preferred attribution.
