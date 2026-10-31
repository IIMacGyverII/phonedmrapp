# Back-check: Spanish guide, part B (guide-B)

File: `scratchpad/es-guide/partB.json` (10 topics, 102 sections, about 17 750 Spanish words).

Method: each Spanish section read back into English and compared with en.json for meaning, negation, numbers and
units; then a script compared section ids, `{@name}` references, leading head numbers, line breaks and every number
(decimal comma and dd/mm/yyyy dates normalised) with en.json. Script result: 0 id, reference or line-break problems;
the only number differences are the metric conversions added on purpose (listed below).

Checked: 102 sections (all).

## Fixes made during the back-check

| Topic / section | Problem found | Fix |
|---|---|---|
| transmitting-legally / licences | "En EE. UU., GMRS … y FRS …" put FRS under the US clause too; English scopes only GMRS to the US | Restored the English structure: "GMRS exige una licencia en EE. UU., FRS limita la potencia" |
| device / radio-firmware | "De fábrica sigue cargando esa imagen" read back as "keeps loading that (unlisted) image" | "De fábrica sigue pudiendo cargar la imagen de fábrica después …" |
| device / run-all-checks | "trial" and "checks" both rendered as *prueba(s)*, so "Checks + trial" read back ambiguously | Matched the strings file: checks = *pruebas*, trial = *ensayo* ("Pruebas + ensayo"), every trial sentence now *el ensayo* |
| device / tools, unihertz-atom-xl, phone-profile, radio-firmware, transmit-test-session, mission-statement | Button names drafted before values-es existed did not match it | Renamed to the strings: Reimportar, Probar copia ida y vuelta, Usar el perfil incluido, Log del handshake, Descargar imagen de fábrica, the firmware stage names (Preparar, Modo FW, Enlace, Borrado, Envío, Cierre, Reinicio, Verific.), Soltar ya, Iniciar la sesión, Declaración de propósito, Issue en GitHub, Ejecutar todas las pruebas |
| signaldeck-web / what-it-shows, phone-panel; coverage-maps | Web labels differed from es.json | ESCUCHAR, SIN ACTUALIZAR, Señal escuchada / Repetidor alcanzado, Ver todo, Crear copia ahora, Registro de diagnóstico, Verificar; map squares are *cuadros* (as in es.json), not *cuadrículas* |
| android-auto | *pulsar* vs the glossary's *presionar*; wheel-mic option name | *presionar*; "Micrófono para el volante", "Vehículo (como una llamada)" |
| region, transmitting-legally | Label case | "Elegir tu región", “No permitido aquí” as in the strings |

No negation, number or unit was found changed apart from the items above.

## Intentional additions (numbers not in the English)
- map / what-is-on-it: "de 15 a 120 millas, de 25 a 190 km".
- coverage-maps / driving-with-a-steady-signal: "a 60 mph (unos 100 km/h)".
- coverage-maps / terrain-prediction: "hasta 50 millas (80 km)" (first mention only).
- emergency-and-roger-beep / emergency: added "El texto se transmite en inglés." (the EMERGENCY text stays English on air).

## Safety sections checked twice (second pass against the English)
- device: radio-link, exit, root-and-reboots, custom-ptt-key (last paragraph: transmit limit, receive-only, untested
  profile does not transmit), phone-profile (advisories switch transmit off; override asks twice), radio-firmware (whole
  section: pre-flight checks, battery 40 % / 60 %, automatic factory restore, unlisted images off until confirmed
  twice, own risk / no warranty, certified phones only, page does not open elsewhere), help-support-this-phone
  ("every step only listens"), run-all-checks (receive only, do not press PTT during the stock-app window),
  radio-audio-check ("nothing transmits"), device-report (only the transmit test session transmits), second-radio-test
  ("this phone only listens"), transmit-test-session (whole section), radios-that-do-less (nothing sent on another
  channel), anysecu-w6plus-dmr (transmit status), untested-profiles (transmit off until tested, exceptions).
- signaldeck-web: transmitting, safety (PIN, local network only, passcode never sent).
- coverage-maps: key-up-test (asks before transmitting), good-habits.
- android-auto: talk, radio-controls, next-as-a-talk-key, steering-wheel-talk, if-android-auto-drops-while-you-talk.
- widget-and-notification: talk-from-the-widget.
- emergency-and-roger-beep: all four sections.
- transmitting-legally: licences, time-limit (No limit behaviour, heat guard thresholds 60/45/70/48 °C, 2 °C in 10 s,
  17 min, 1 °C, 30 s, locked in Restricted mode).
- region: safe-by-design, how-accurate-it-is (licence-free service does not mean this phone is approved).
