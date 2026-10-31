# Spanish glossary (es): DRAFT, awaiting native review

**Status: draft, awaiting native review.** Written by the translation agent on 2026-10-30 from the English UI
(`SignalDeck-i18n`, `res/values/strings_*.xml` and the guide), following the German glossary's structure. It is for a
native-speaking ham reviewer to agree or correct, ideally **before any Spanish string is drafted**. Review does not gate
the release (owner, 2026-10-30): if answers come later, the draft is changed to match. Every later Spanish string follows
this table, so one English word is never rendered three ways.

- **Variant:** neutral international Spanish, read naturally by hams in Spain and in Latin America (`style.md` §2).
  Where Spain and Latin America clearly use different words, the row says so and names the choice; the usual way out is
  a word both sides use (*teléfono*, *vehículo*, *equipo*).
- **How to review:** for each row, keep it or write the better term in the last column. Rows marked **❓** are real
  choices where Spanish-speaking ham usage is split; the reviewer decides.
- **Register:** *tú* (see `style.md` §1).
- **Order:** app navigation, buttons, radio terms, DMR, digital modes, safety and licence, units and symbols, then the
  terms settled in the German draft (§8), each with its Spanish rendering.

## 1. App structure: tabs, pages, features

| English | Spanish | Why / notes | Reviewer |
|---|---|---|---|
| SignalDeck | SignalDeck | Product name, never translated. | |
| SignalDeck Web | SignalDeck Web | Product name. | |
| Intercom (tab, main page) | Radio | "Intercomunicador" is a door or helmet intercom. "Radio" is short and is what a ham calls the main view. As a tab label it takes no article, which avoids *la radio* (Spain) vs *el radio* (much of Latin America, for the device). In prose: "la página Radio". ❓ Alternatives: *Equipo*, keep *Intercom*. | |
| Channels (tab) | Canales | Standard. | |
| Contacts (tab) | Contactos | Standard (DMR contacts too). | |
| Messages (tab) | Mensajes | Android standard. | |
| Device (tab) | Dispositivo | Android's Spanish UI. | |
| Settings | Ajustes | Spain's Android says *Ajustes*, Latin America's *Configuración*. *Ajustes* is shorter on a tab and fully understood in Latin America. ❓ | |
| Radio settings | Ajustes de radio | Follows the row above. | |
| Last heard | Últimos escuchados | What Spanish DMR dashboards show. | |
| Activity | Actividad | | |
| Activity statistics | Estadísticas de actividad | | |
| Alerts (list in Last heard) | Alertas | The list holds warnings and refusals; *Avisos* is too weak for "transmission refused". | |
| Car and coverage | Vehículo y cobertura | *coche* (Spain), *carro* (Mexico, Colombia, Venezuela), *auto* (Southern Cone): **vehículo** is neutral everywhere. "en el vehículo" in prose. ❓ | |
| Guide / Help | Guía / Ayuda | "Ayuda" for the menu entry, "Guía" for the guide itself. | |
| Getting started | Primeros pasos | Standard. | |
| Good to know | Conviene saber | Natural in both regions; "Es bueno saber" is a calque. | |
| Take over (the radio) | Tomar el control | "Tomar el control del módulo de radio" in prose. Button: "Tomar control". | |
| Hand back | Devolver | Pairs with *Tomar el control*; "Devolver el control" in prose. | |
| Stock app (the phone maker's radio app) | App del fabricante | "Stock" has no Spanish equivalent; *app original* is also fine. *App* on labels, *aplicación* in prose. ❓ | |
| Device report | Informe del dispositivo | *Informe* in Spain, *reporte* in much of Latin America; *informe* is understood everywhere and keeps *reporte* free for net check-ins (§8). | |
| Transmit test | Prueba de transmisión | | |
| First-run check | Verificación inicial | *verificar* is neutral; *comprobar* reads Peninsular. | |
| Module firmware | Firmware del módulo | | |
| Radio module | Módulo de radio | Masculine, so it avoids the *el/la radio* split. | |
| About this radio | Acerca de este equipo | *equipo* is the ham word for the rig in every Spanish-speaking country. | |
| Live captions (TXT) | Subtítulos en tiempo real | *en directo* (Spain) vs *en vivo* (Latin America): "en tiempo real" is neutral. | |
| Keywords (caption alerts) | Palabras clave | | |
| Recording(s) | Grabación (grabaciones) | | |
| Recordings player | Reproductor de grabaciones | | |
| Transcript | Transcripción | | |
| Coverage logging | Registro de cobertura | Spanish hams do say "cobertura del repetidor", so no conflict with mobile networks here. | |
| Coverage map | Mapa de cobertura | | |
| Map | Mapa | | |
| Band scope | Espectro | Spanish rig manuals say "pantalla de espectro" or "analizador de espectro". Label: *Espectro*; prose: "visor de espectro de banda". ❓ Keep *band scope*? | |
| Fox hunt | Caza del zorro | The established term in both regions (ARDF: *radiolocalización deportiva*). | |
| Nets | Ruedas | A net is a *rueda* in Spain and in much of South America; Mexico and Central America also say *red*, which here would collide with "network". ❓ | |
| Net control | Control de la rueda | The station is the *estación control* or *conductor de la rueda*; the feature name is "Control de la rueda". ❓ | |
| Logbook | Log | *libro de guardia* (Spain, Argentina), *bitácora* (Mexico), *log* (everywhere, and in logging software). "Log" is the one word all readers use. ❓ | |
| Exam practice | Práctica de examen | The pools are the US exam in English: topic label "Examen de EE. UU. (en inglés)". | |
| Conditions (propagation) | Condiciones de propagación | Short form on tight labels: *Propagación*. | |
| Satellites | Satélites | | |
| Pass (satellite) | Pase | "pase del satélite" in both regions. | |
| Emergency | Emergencia | | |
| Restricted mode | Modo restringido | A voluntary PIN lock. ❓ *Modo bloqueado* is shorter but sounds like the phone is locked. | |
| Widget | Widget | Android standard. | |
| Android Auto | Android Auto | Product name. | |
| Zone | Zona | Same word in Spanish DMR CPS software. | |
| All channels | Todos los canales | | |
| Favourites | Favoritos | | |
| Priority channel | Canal prioritario | | |
| Make scan priority | Hacer prioritario | Button: short. | |
| Busiest channels (zone name) | Más activos | A zone name the app creates; "Canales más activos" if space allows. | |
| Restricted PIN | PIN de restricción | | |

## 2. Buttons and common actions

Buttons are infinitives (Android's Spanish style: *Guardar*, *Cancelar*), sentence case.

| English | Spanish | Notes | Reviewer |
|---|---|---|---|
| OK | Aceptar | Android's Spanish dialogs say *Aceptar*; "OK" only where space is very tight. | |
| Cancel | Cancelar | | |
| Save | Guardar | | |
| Delete | Eliminar | Android standard for items. *Borrar* for text and lists (Clear). | |
| Close | Cerrar | | |
| Done | Listo | | |
| Back | Atrás | | |
| Next / Previous (guide pages) | Siguiente / Anterior | | |
| Continue | Continuar | | |
| Later | Más tarde | | |
| Not now | Ahora no | | |
| Clear | Borrar | For lists, "Vaciar lista" where it empties a list; "Restablecer" for fields. | |
| Start / Stop | Iniciar / Detener | | |
| End (a net, a session) | Finalizar | "Finalizar la rueda". | |
| Send | Enviar | For messages and data. "Transmit" is *transmitir* (§3). | |
| Share | Compartir | Android standard. | |
| Import / Export | Importar / Exportar | | |
| Download | Descargar | | |
| Load (firmware) | Cargar | "Cargar firmware", not *flashear* in UI text. | |
| Connect | Conectar | | |
| Defaults | Valores predeterminados | Short: *Predeterminados*. | |
| Use (a channel) | Sintonizar | You set the radio to the channel. | |
| Use it anyway | Usar de todos modos | | |
| Tune (a frequency) | Sintonizar | | |
| Edit | Editar | | |
| Add | Agregar | *Añadir* (Spain's Android) vs *Agregar* (Latin America's). *Agregar* is understood and used in Spain too, and most readers are in Latin America. ❓ | |
| Rename | Cambiar nombre | | |
| Search | Buscar | | |
| Retry | Reintentar | | |
| Allow | Permitir | Matches Android permission dialogs. | |
| Turn on / Turn off | Activar / Desactivar | For features; *Encender / Apagar* for the radio and the phone. Switch rows: just the label, no verb. | |
| On / Off | Activado / Desactivado | Android's Spanish switch states. "activado/desactivado" in sentences too. | |
| Tap | tocar | "Toca **Tomar control**". Both regions' Android. | |
| Long-press | mantener presionado | *mantener pulsado* (Spain) vs *mantener presionado* (Latin America); *presionar* is standard Spanish everywhere. "Mantén presionado SCAN". ❓ | |
| Swipe | deslizar | "Desliza hacia la izquierda". | |
| Put in the outbox | Poner en la bandeja de salida | Winlink/messages. | |

## 3. Radio and ham terms

| English | Spanish | Why / notes | Reviewer |
|---|---|---|---|
| radio (the device) | equipo / radio | *equipo* in prose ("tu equipo"). Where "radio" is needed, write it without an article or with a construction that avoids the gender (*la radio* Spain, *el radio* Latin America). | |
| radio (the activity) | radio | "hacer radio", "operar en radio". | |
| ham, radio amateur | radioaficionado / radioaficionada | Gender-neutral where it matters: "quien opera", "quienes tienen licencia". | |
| amateur radio | radioafición | Used in both regions; "servicio de radioaficionados" in legal text. *Radioexperimentación* is too narrow. | |
| callsign | indicativo | URE (Spain), FMRE (Mexico) and most societies say *indicativo*; Argentina's official term is *señal distintiva*. ❓ | |
| licence | licencia | "licencia de radioaficionado". Spain's legal term is *autorización*, but *licencia* is what hams say in every country. | |
| channel | canal (pl. canales) | | |
| frequency | frecuencia | | |
| transmit (verb) | transmitir | | |
| transmission (one over) | transmisión | A single over in a QSO: *cambio*. | |
| receive | recibir | | |
| reception | recepción | | |
| receive-only | solo recepción | *solo* without accent (RAE 2010). | |
| talk key (the big round button) | botón para hablar | | |
| PTT | PTT | Kept; "botón PTT" in prose. | |
| side PTT button | botón PTT lateral | | |
| squelch | squelch | What Spanish-speaking hams say. Manuals say *silenciador*; it can be explained once. The feature name **Soft SQ** stays. ❓ | |
| squelch level | nivel de squelch | Short form "Nivel SQL" on tight labels. | |
| Soft SQ | Soft SQ | Feature name, kept. Explained once as "squelch por software". | |
| noise squelch | squelch de ruido | Prose only. | |
| scan (verb / noun) | escanear / escaneo | Hams say *escanear*; manuals also *exploración*. Key legend stays **SCAN** (decided; `style.md` §7). ❓ *exploración*? | |
| zone | zona | | |
| VFO | VFO | | |
| repeater | repetidor (pl. repetidores) | Universal. | |
| repeater offset / shift | desplazamiento | URE usage; *offset* and *shift* are common too, especially in Latin America. ❓ | |
| simplex / duplex | símplex / dúplex | RAE spelling with accents; hams often write "simplex". | |
| CTCSS | CTCSS | "tono CTCSS" in prose; *subtono* is the everyday ham word and may be used in explanations. | |
| DCS | DCS | | |
| tone (CTCSS) | tono | "Tono RX" / "Tono TX" on labels; "tono de recepción" / "tono de transmisión" in prose. | |
| power (transmit) | potencia | "potencia de transmisión" in prose. | |
| high / low (power) | Alta / Baja | | |
| bandwidth wide / narrow | Ancha / Estrecha | With values: 25 kHz / 12,5 kHz. *Angosta* is common in Latin America but sounds odd in Spain; *estrecha* is understood everywhere ("banda estrecha"). | |
| channel step | paso de canal | Short: *Paso*. | |
| mode (FM, DMR …) | modo | "modo digital", "modo FM". *Modalidad* is also correct but longer. | |
| analog / digital | analógico / digital | | |
| signal strength | intensidad de señal | | |
| S-meter | S-meter | Kept by Spanish-speaking hams ("el S-meter"); *medidor S* in manuals. | |
| noise floor | ruido de fondo | | |
| NO SIGNAL | SIN SEÑAL | | |
| channel busy | Canal ocupado | | |
| key up (a repeater) | abrir (el repetidor) | "abrir el repetidor" is the usual ham phrase in both regions. | |
| repeater tail | cola | "la cola del repetidor". | |
| roger beep | roger beep | The usual ham term; *pitido de fin de cambio* in prose if needed. ❓ | |
| QSO, CQ, 73, QTH | unchanged | International Q-codes and ham shorthand. | |
| location | ubicación | Android's word. "QTH" in ham-flavoured text. | |
| locator / grid square | localizador (grid) | Spain says *locator* or *cuadrícula*, Latin America *grid*. "Localizador" with "grid" in brackets once. ❓ | |
| band | banda | | |
| band plan | plan de bandas | | |
| VHF / UHF | VHF / UHF | In prose, 2 m / 70 cm where the band is meant. | |
| propagation | propagación | | |
| antenna | antena | | |
| dummy load | carga fantasma | Both regions; *carga artificial* also correct. | |
| interference | interferencia | | |
| identification (repeater ID) | identificación | | |
| Morse | Morse / CW | *telegrafía* in prose. | |
| beacon | baliza | APRS: "baliza APRS". | |
| heard station | estación escuchada | | |
| station | estación | | |
| over (end of a transmission) | cambio | | |

## 4. DMR

| English | Spanish | Why / notes | Reviewer |
|---|---|---|---|
| DMR | DMR | | |
| talkgroup | talkgroup (TG) | Spanish-speaking DMR users say "el TG 214", "el talkgroup". Motorola's Spanish manuals say *grupo de conversación*, which may be given once as an explanation. Masculine. On tight labels "TG". ❓ | |
| colour code | código de color (CC) | Common in Spanish CPS software and among hams. | |
| time slot | slot (TS) | Hams say "slot 1", "TS2"; *intervalo de tiempo* in manuals, used once as an explanation. ❓ | |
| private call / group call | llamada privada / llamada de grupo | | |
| DMR ID | ID DMR | Masculine: "el ID DMR". (Never a real ID in examples.) | |
| contact | contacto | | |
| receive group list | lista de grupos RX | Spanish CPS wording; long form *lista de grupos de recepción*. ❓ | |
| hotspot | hotspot | | |
| codeplug | codeplug | Kept by DMR users. | |
| CALL · PICKED | LLAMADA · ELEGIDO | Intercom cell legend. Check width on the screen check. | |
| promiscuous mode (MON) | Escuchar todo (MON) | For prose; the key legend MON stays (decided). *modo promiscuo* is a calque some users know. ❓ | |

## 5. Digital modes and data

| English | Spanish | Notes | Reviewer |
|---|---|---|---|
| APRS, AX.25, iGate, digipeater | unchanged | "el digipeater", "el iGate". | |
| APRS-IS, passcode | APRS-IS, passcode | "passcode" stays: it is the name APRS-IS uses. | |
| packet radio | packet | "radio por paquetes" once as an explanation; hams say "packet". | |
| position (APRS) | posición | | |
| telemetry | telemetría | | |
| weather report | informe meteorológico | *el tiempo* (Spain) vs *el clima* (Latin America) for weather: *meteorológico* is neutral. | |
| message (APRS/DMR text) | mensaje | | |
| outbox / inbox | bandeja de salida / bandeja de entrada | | |
| SSTV, FT8, M17, POCSAG, Winlink, DTMF | unchanged | | |
| picture (SSTV) | imagen | | |
| pager | pager | *busca* (Spain), *bíper* / *localizador* (Latin America): the radio community says *pager*. ❓ *buscapersonas*? | |
| decode / decoder | decodificar / decodificador | | |
| forms (Winlink) | formularios | | |

## 6. Safety, licence, heat

Safety text gets a second careful pass (plan §4). These renderings must stay this strong.

| English | Spanish | Notes | Reviewer |
|---|---|---|---|
| Warning | Advertencia | | |
| Caution | Precaución | | |
| Transmitting legally | Transmitir legalmente | Guide section title. | |
| You need a licence to transmit on this frequency. | Para transmitir en esta frecuencia necesitas una licencia de radioaficionado. | The pattern for licence notes. | |
| transmit limit / time limit | límite de tiempo de transmisión | Short: "Límite de TX". | |
| Longest transmission | Transmisión máxima | Device setting. "Duración máxima de cada transmisión" in prose. | |
| heat guard | protección térmica | | |
| too hot | demasiado caliente | | |
| transmit refused | Transmisión rechazada | | |
| Not sent | No enviado | | |
| advisory (from the profile list) | Aviso | | |
| firmware loader | cargador de firmware | | |
| factory image | firmware de fábrica | | |
| do not switch off | no apagues | Firmware loading: always in bold, never softened. "No apagues el teléfono". | |
| emergency | emergencia | | |

## 7. Units, numbers, symbols

| English | Spanish | Notes |
|---|---|---|
| 467.625 MHz | 467,625 MHz | Decimal comma everywhere on screen, the readout included; entry fields accept `,` and `.`. Spain and most of South America write the comma; **Mexico, Central America and the Caribbean write the point** (`style.md` §5). Reviewer to confirm. |
| 12.5 kHz | 12,5 kHz | |
| −85 dBm | −85 dBm | Unit unchanged, space before the unit, real minus sign. |
| 30 s, 2 min | 30 s, 2 min | Never "30 seg." or "2 mins". |
| 5 W | 5 W | |
| 24-hour time | formato de 24 horas (14:05) | |
| date | 30/10/2026 / 30 oct 2026 | Day first in both regions. Months lower case. |
| → (menu path) | → | Kept: "Dispositivo → Ajustes de radio". |
| "…" quotes | “…” | The title font (Orbitron) has no « », and Latin America uses “…” (`style.md` §4). Never in titles. |
| USA | EE. UU. | RAE abbreviation, with the space. |

## 8. Terms settled during the German draft (2026-10-31), in Spanish

The terms the German translators needed beyond §1–7, each with its Spanish rendering, so the Spanish draft starts with
them settled. Rows marked **❓** are real choices for the reviewer.

### App features and screens

| English | Spanish | Notes | Reviewer |
|---|---|---|---|
| the Intercom page (in prose) | la página Radio | The tab stays "Radio" (§1). | |
| Radio controls (car screen) | Controles de radio | Also "Controles de radio a pantalla completa en el vehículo". | |
| Parrot (simplex repeater) | Loro | The app's feature. BrandMeister's echo service (private call 9990) stays "Parrot". ❓ Keep "Parrot" for both? | |
| Voice keyer | Memorias de voz | | |
| Net preamble / My ID (keyer slots) | Apertura de rueda / Mi identificación | | |
| ID timer | Temporizador de identificación | Short: "Temporizador ID". | |
| ID reminder | Recordatorio de identificación | | |
| Morse ID | Identificación en Morse | Also the DTMF command label. | |
| Fox beacon | Transmisor zorro | Simply "el zorro" in prose, the usual fox-hunt word. Not "baliza" (§3). ❓ | |
| Be the fox | Hacer de zorro | | |
| bearing / Spin for the bearing | rumbo / Girar para tomar el rumbo | *marcación* is the radiogoniometry term; *rumbo* is what everyone understands. ❓ | |
| mark (fox hunt) | marca (prose and buttons: "Guardar marca", "Borrar marcas") | One word for both; the buttons are a third of a row wide. | |
| Download terrain / Terrain | Descargar terreno / Terreno | §2 Download. | |
| Terrain prediction | Predicción por terreno | Never "pronóstico" (sounds like weather). | |
| Key-ups (coverage layer) | Aperturas | From "abrir el repetidor" (§3). ❓ | |
| Mapping coverage | Registrando cobertura | Notification and widget text. | |
| Log coverage in the car | Registrar cobertura en el vehículo | §1 vehículo. | |
| Nearby repeaters | Repetidores cercanos | | |
| Nets near you | Ruedas cercanas | | |
| On the air near you / Elsewhere on the air | En el aire cerca de ti / En el aire en otros lugares | | |
| Nets on this channel (editor section) | Ruedas aquí | Comment asks for one or two words. | |
| Add a net | Agregar rueda | §2 Add. | |
| check-in (net control) | reporte, verb *reportarse*; button "Anotar" | Latin American nets "toman reportes"; Spain says "entrar en la rueda" but understands *reportarse*. Keeps *registro* for logs. ❓ *check-in*, *entrada*? | |
| traffic (net flag) | Tráfico | | |
| Late / Out (net flags) | Tarde / Retirado | Report lines: "tarde", "retirado". | |
| Scheduled operations / schedule | Operaciones programadas / Programación | "Agregar programación". | |
| APRS monitoring | Escucha APRS | *monitorizar* (Spain) vs *monitorear* (Latin America), and both can read as surveillance: *escucha* avoids all three. | |
| Pager monitor | Escucha de pager | | |
| Monitor APRS (button) | Escuchar APRS | Verb form on buttons only. | |
| Packet finder | Buscador de packet | | |
| page (POCSAG message) | mensaje de pager | One rendering only. | |
| Hear pages | Recibir mensajes de pager | | |
| Winlink e-mail / Check Winlink mail | Correo Winlink / Consultar correo Winlink | *correo* in both regions; never "email". | |
| Session log / Detailed diagnostic log | Registro de la sesión / Registro de diagnóstico detallado | | |
| Two-way iGate | iGate bidireccional | | |
| Packet lead-in | Preámbulo de packet | | |
| Beacon via ISS | Baliza vía la ISS | | |
| Record each pass | Grabar cada pase | | |
| satellite pass | pase del satélite | | |
| orbit data | datos orbitales | (TLE). | |
| Text modes | Modos de texto | | |
| Any mode (SSTV decoder) | Cualquier modo | An SSTV mode (Martin, Scottie). | |
| Combine (SSTV) / In / Left out | Combinar / Incluida / excluida | Agrees with *imagen*. | |
| Voice announcements | Anuncios de voz | | |
| keyword alerts | alertas por palabra clave | | |
| Contribute | Colaborar | | |
| Help support this phone | Ayuda a que SignalDeck funcione en este teléfono | "Dar soporte" is an anglicism. First-launch title "Help us support this phone": "Ayúdanos a que SignalDeck funcione en este teléfono". | |
| Radio audio check | Prueba de audio de radio | | |
| Listen check / Second radio test | Prueba de escucha / Prueba con un segundo equipo | | |
| Transmit test session | Sesión de prueba de transmisión | | |
| Bring radio up (diagnostics) | Arrancar radio | Four buttons in a row. | |
| Probe + power pulse | Sondeo + pulso de alimentación | | |
| Restore factory (firmware button) | De fábrica | One of three buttons in a row. | |
| POTA activation / On the air now | Activación / QRV ahora | | |
| contact (logbook) | QSO | A DMR contact stays "contacto" (§4); "Anotar QSO", "Volver a anotar". In Spain also *comunicado*. | |
| Log heard | Anotar escuchados | | |
| Exam practice: Study a subelement / Missed | Estudiar una sección / Falladas | Topic label per §1: "Examen de EE. UU. (en inglés)". | |
| Hold to talk (M17) | Mantén para hablar | | |
| Open in maps | Abrir en Mapas | | |

### Firmware and the phone

| English | Spanish | Notes | Reviewer |
|---|---|---|---|
| phone | teléfono | *móvil* (Spain) vs *celular* (Latin America): **teléfono** is the neutral word both read without noticing, and the one Android's Spanish UI uses in settings. | |
| bench firmware / bench image | firmware de laboratorio / imagen de laboratorio | "en el banco de pruebas" stays for measurements. ❓ | |
| stock firmware / factory image | firmware de fábrica | As §6 "factory image". | |
| stock version (SignalDeck Web) | versión de fábrica | | |
| factory backup / factory copy | copia de seguridad de fábrica / copia de fábrica | | |
| stock ROM (Android) | ROM original | Not firmware; "ROM stock" is also common. ❓ | |
| symbol engine / tone generator | motor de símbolos / generador de tonos | | |
| Own the radio at boot | Tomar el módulo al iniciar | §1 "Tomar el control". | |
| Keep access after reboot | Mantener el acceso tras reiniciar | | |
| Turn the radio off and exit | Apagar el módulo y salir | *módulo* avoids the *el/la radio* split. | |
| Hand back to the stock app and exit | Devolver a la app del fabricante y salir | | |
| Radio busy, loading firmware | Módulo ocupado, cargando firmware | | |
| Allow unlisted images | Permitir imágenes no listadas | | |
| Web access / Allow transmit from the web | Acceso web / Permitir transmitir desde la web | | |
| amber (UI colour) | ámbar | Invariable: "luz ámbar", "indicadores ámbar". | |

### Channel editor and lists

| English | Spanish | Notes | Reviewer |
|---|---|---|---|
| All / Private / Group (call type choice) | Todas / Privada / Grupo | Short forms of §4, for pills. | |
| All call (contact type) | Llamada a todos | | |
| Relay (repeater) | Repetidor | | |
| Call number from / call number | Origen del número de llamada / Número de llamada | | |
| Channel access number (M17) | Número de acceso al canal (CAN) | | |
| Double slot | Doble slot | | |
| Interrupt transmission | Interrupción de transmisión | | |
| RX tone type / TX tone type | Tipo de tono RX / Tipo de tono TX | | |
| None (tone) | Ninguno | | |
| High / Low power (choices) | Alta / Baja | §3. | |
| Enabled / Disabled (choices) | Activado / Desactivado | | |
| Latitude / Longitude | Latitud / Longitud | | |
| Destination (@ALL or a callsign) | Destino (@ALL o un indicativo) | | |
| NOT TUNABLE (badge) | FUERA DE RANGO | Badge cut off at 16 characters on a 480 px screen. ❓ | |
| RX ONLY (badge) | SOLO RX | | |
| Not legal here | No permitido aquí | | |
| Show all lists | Mostrar todas las listas | | |
| Star (button) | Favorito | The icon is still "estrella" in prose. | |
| Out of zone (button) | Quitar de zona | Four buttons share a row. | |
| Zone name | Nombre de zona | | |
| Marine VHF | VHF marina | | |
| NOAA weather | Meteorología NOAA | | |
| Home (contact location) | Casa | | |

### Wording rules settled

| English | Spanish | Notes | Reviewer |
|---|---|---|---|
| Stop … (button) | Detener … | §2 Start/Stop. "Finalizar" only for End (a net, a session); "Salir" for the app. | |
| Halt TX | Detener TX | | |
| Try again | Reintentar | §2 Retry. | |
| Loading… / Sending… | Cargando… / Enviando… | No space before the ellipsis. | |
| Set your callsign first | Primero configura tu indicativo | *ingresar* (Latin America) vs *introducir* (Spain) for typing data: use *escribir* or *configurar*, which both read naturally. | |
| Coverage logging is on | El registro de cobertura está activado | "activado/desactivado" in sentences and on switches (§2). | |
| No position fix yet | Aún sin posición | | |
| Key legends SCAN, ZONE, TXT, SOFT SQ, MON, REC, VFO, PKT | unchanged | No legend is translated; the text around it is ("Toca SCAN"). The car screen's own Scan button is "Escanear". | |
| weekday buttons (one letter) | L M X J V S D | Monday first; **X** for *miércoles* so it is not confused with *martes*. Spain's convention; Latin American Android often starts on Sunday with "D L M M J V S". ❓ Three-letter days: lun. mar. mié. jue. vie. sáb. dom. | |
| "%1$d min ago" | hace %1$d min | "hace" goes first. | |
| "Could not …: %1$s" | No se pudo …: %1$s | Impersonal, as Android writes errors: "No se pudo guardar: %1$s". | |
