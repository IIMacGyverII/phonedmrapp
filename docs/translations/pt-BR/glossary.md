# Brazilian Portuguese glossary (pt-BR): DRAFT, awaiting native review

**Status: draft, awaiting native review.** Written by the translation agent on 2026-10-30 from the English UI and the
extracted `strings_*.xml` / `guide/en.json`, before any pt-BR string was drafted. It is for a native-speaking Brazilian
ham to agree or correct. Review does not gate the release (owner, 2026-10-30): if answers come later, the draft is
changed to match. Every later pt-BR string follows this table, so one English word is never rendered three ways.

- **Target reader:** a Brazilian *radioamador* (or *radioamadora*). The words are the ones heard on Brazilian
  repetidoras and in LABRE material, Brazilian radio manuals and DMR groups (BrandMeister Brasil), not European
  Portuguese and not a word-for-word rendering of the English.
- **How to review:** for each row, keep it or write the better term in the last column. Rows marked **❓** are real
  choices where Brazilian ham usage is split; the reviewer decides.
- **Register:** *você* (see `style.md` §1).
- **Gender:** nouns that matter for agreement carry (m) or (f): *a repetidora*, *o talkgroup*, *a roda*.
- **Order:** app navigation, buttons, radio terms, DMR, digital modes, safety and licence, units and symbols, then the
  terms settled from the German draft's §8.

## 1. App structure: tabs, pages, features

| English | Português (Brasil) | Why / notes | Reviewer |
|---|---|---|---|
| SignalDeck | SignalDeck | Product name, never translated. (m) "o SignalDeck". | |
| SignalDeck Web | SignalDeck Web | Product name. | |
| Intercom (tab, main page) | Rádio | "Interfone" is the door intercom of a Brazilian building; "Intercom" reads as that too. "Rádio" is short and what the page is. ❓ Alternatives: *Fonia*, keep *Intercom*. | |
| Channels (tab) | Canais | | |
| Contacts (tab) | Contatos | Brazilian spelling (*contactos* is European). | |
| Messages (tab) | Mensagens | | |
| Device (tab) | Dispositivo | Android pt-BR's word. | |
| Settings | Configurações | Android pt-BR standard (never *Definições*, which is European). | |
| Radio settings | Configurações do rádio | | |
| Last heard | Últimos ouvidos | Short and clear on a tab. ❓ Alternative: *Últimas escutas*, *Ouvidos recentemente*. | |
| Activity | Atividade | | |
| Activity statistics | Estatísticas de atividade | | |
| Alerts (list in Last heard) | Alertas | Holds warnings and refusals. | |
| Car and coverage | Carro e cobertura | "Cobertura da repetidora" is the normal Brazilian phrase, so *cobertura* fits (unlike German). | |
| Guide / Help | Guia / Ajuda | "Ajuda" for the menu entry, "Guia" for the guide itself. | |
| Getting started | Primeiros passos | Standard. | |
| Good to know | Bom saber | ❓ *Dicas* is shorter. | |
| Take over (the radio) | Assumir | "Assumir o módulo de rádio" in prose. | |
| Hand back | Devolver | Pairs with *Assumir*. | |
| Stock app (the phone maker's radio app) | app do fabricante | Brazilian Android users also say "app original" / "app nativo". ❓ | |
| Device report | Relatório do dispositivo | | |
| Transmit test | Teste de transmissão | Short form on tight labels: "Teste de TX". | |
| First-run check | Verificação inicial | | |
| Module firmware | Firmware do módulo | "firmware" (m), invariable. | |
| Radio module | módulo de rádio | | |
| About this radio | Sobre este rádio | | |
| Live captions (TXT) | Legendas ao vivo | Android pt-BR calls its feature *Legenda instantânea*; "ao vivo" is clearer for radio. ❓ | |
| Keywords (caption alerts) | Palavras-chave | | |
| Recording(s) | Gravação / Gravações | | |
| Recordings player | Player de gravações | "Player" is normal Brazilian usage; *Reprodutor* is stiff. | |
| Transcript | Transcrição | | |
| Coverage logging | Registro de cobertura | | |
| Coverage map | Mapa de cobertura | | |
| Map | Mapa | | |
| Band scope | Band scope | Brazilian hams use the manufacturer's English name (Icom/Yaesu). "espectro" in prose. ❓ Alternative: *Espectro da banda*. | |
| Fox hunt | Caça à raposa | The established Brazilian term (ARDF: *radiogoniometria*). Note the crase: "à raposa". | |
| Nets | Rodas | A net is a *roda* (f) in Brazilian ham speech ("a roda das 21h"). Never "redes". | |
| Net control | Coordenação da roda | The person: "coordenador da roda" / "quem coordena a roda". ❓ Some say "controle da roda". | |
| Logbook | Logbook | Brazilian hams say "log" or "logbook"; *livro de registro* sounds bureaucratic. ❓ | |
| Exam practice | Simulado | The Brazilian word for a practice exam. The pools are the US exam in English: label the topic "Simulado (prova dos EUA, em inglês)". | |
| Conditions (propagation) | Condições de propagação | Short form on tight labels: *Propagação*. | |
| Satellites | Satélites | | |
| Pass (satellite) | Passagem | | |
| Emergency | Emergência | | |
| Restricted mode | Modo restrito | A voluntary PIN lock. ❓ Alternative: *Modo bloqueado*. | |
| Widget | Widget | Android standard. (m) | |
| Android Auto | Android Auto | Product name. | |
| Zone | Zona | Same word in pt-BR radio manuals. (f) | |
| All channels | Todos os canais | | |
| Favourites | Favoritos | | |
| Priority channel | Canal prioritário | | |
| Make scan priority | Tornar prioritário | Button: short. | |
| Busiest channels (zone name) | Mais movimentados | A zone name the app creates; "movimentado" is how Brazilians describe a busy channel. | |
| Restricted PIN | PIN de bloqueio | | |
| Region (Device → Region) | Região | | |
| Message forms | Formulários de mensagem | | |
| Scanning and zones (guide topic) | Varredura e zonas | | |
| Record and monitor (guide topic) | Gravar e escutar | | |

## 2. Buttons and common actions

Buttons are infinitives or short nouns, as in Android pt-BR ("Cancelar", "Salvar", "Concluído"). Sentence case.

| English | Português (Brasil) | Notes | Reviewer |
|---|---|---|---|
| OK | OK | | |
| Cancel | Cancelar | | |
| Save | Salvar | Brazilian; *Guardar* is European. | |
| Delete | Excluir | Android pt-BR. *Apagar* only for clearing text. | |
| Close | Fechar | | |
| Done | Concluído | Android pt-BR. | |
| Back | Voltar | | |
| Next / Previous (guide pages) | Próximo / Anterior | | |
| Continue | Continuar | | |
| Later | Mais tarde | | |
| Not now | Agora não | | |
| Clear | Limpar | For lists and fields. | |
| Start / Stop | Iniciar / Parar | | |
| End (a net, a session) | Encerrar | "Encerrar a roda". | |
| Send | Enviar | For messages and files. Radio "transmit" is *transmitir* (§3). | |
| Share | Compartilhar | Brazilian; *Partilhar* is European. | |
| Import / Export | Importar / Exportar | | |
| Download | Baixar | Brazilian everyday and Android pt-BR. | |
| Load (firmware) | Carregar | "Carregar firmware", not *flashear* in UI text (fine in chat, not on screen). | |
| Connect | Conectar | | |
| Defaults | Padrões | "Restaurar padrões" on a reset button. | |
| Use (a channel) | Usar | | |
| Use it anyway | Usar mesmo assim | | |
| Tune (a frequency) | Sintonizar | | |
| Edit | Editar | | |
| Add | Adicionar | | |
| Rename | Renomear | | |
| Search | Pesquisar | Android pt-BR; *Buscar* also fine in prose. | |
| Retry | Tentar novamente | | |
| Allow | Permitir | Matches Android permission dialogs. | |
| Turn on / Turn off | Ativar / Desativar | For features. "Ligar / Desligar" for the radio itself. Switch rows: just the label. | |
| On / Off | Ativado / Desativado | Switch states. "ligado / desligado" in sentences about the radio. | |
| Tap | tocar (em) | Android pt-BR: "Toque em **Assumir**". | |
| Long-press | tocar e manter pressionado | Shorter in prose: "mantenha SCAN pressionado". | |
| Swipe | deslizar | | |
| Put in the outbox | Pôr na caixa de saída | Winlink/messages. | |

## 3. Radio and ham terms

| English | Português (Brasil) | Why / notes | Reviewer |
|---|---|---|---|
| radio (the device) | rádio (m) | | |
| radio (the activity) | rádio / radioamadorismo | | |
| ham, radio amateur | radioamador (pl. radioamadores) | Gender-neutral where it matters: "quem opera", "o operador ou a operadora" only if unavoidable (style §1). | |
| amateur radio | radioamadorismo / serviço de radioamador | | |
| callsign | indicativo (de chamada) | "indicativo" alone in UI. Never "sinal de chamada". | |
| licence | licença de radioamador | Anatel issues the COER (operator certificate) and the station licence; hams say "licença" or "ser licenciado". ❓ | |
| channel | canal (pl. canais) | | |
| frequency | frequência | | |
| transmit (verb) | transmitir | Short form on labels: TX. | |
| transmission (one over) | transmissão | In QSO prose, the ham word "câmbio" for one over ("no seu câmbio"). UI keeps *transmissão*. | |
| receive | receber | | |
| reception | recepção | | |
| receive-only | só recepção | Badge: "SÓ RX". | |
| talk key (the big round button) | tecla de transmissão | ❓ *botão de falar*; Brazilians often just say "o PTT". | |
| PTT | PTT | Kept; "tecla PTT" in prose. (m) "o PTT". | |
| side PTT button | PTT lateral | | |
| squelch | squelch | Brazilian hams and manuals say "squelch" (m); *silenciador* is rare. The feature name **Soft SQ** stays. ❓ | |
| squelch level | nível de squelch | Tight labels: "Nível SQ". | |
| Soft SQ | Soft SQ | Feature name, kept. Explained once as "squelch por software". | |
| noise squelch | squelch de ruído | Prose only. | |
| scan (verb / noun) | fazer varredura / varredura | Key legend stays **SCAN** (decided; `style.md` §6). Many hams say "scanear"; UI uses *varredura*. ❓ | |
| zone | zona (f) | | |
| VFO | VFO | (m) "o VFO". | |
| repeater | repetidora (f) | The Brazilian ham word ("a repetidora de 2 m"); *repetidor* (m) is Portugal/Spanish usage. | |
| repeater offset / shift | offset | Brazilian repeater lists and hams say "offset" or "shift" ("offset −600"). Prose: "deslocamento" once to explain. ❓ *shift* | |
| simplex / duplex | simplex / duplex | | |
| CTCSS | CTCSS | "subtom CTCSS" in prose. | |
| DCS | DCS | | |
| tone (CTCSS) | subtom | The everyday Brazilian word ("subtom 67,0"). "subtom de RX" / "subtom de TX". | |
| power (transmit) | potência (de transmissão) | Short labels: "Potência". | |
| high / low (power) | Alta / Baixa | Agrees with *potência* (f). | |
| bandwidth wide / narrow | Larga / Estreita | With values: 25 kHz / 12,5 kHz. Agrees with *banda* (f). | |
| channel step | passo | "passo de 12,5 kHz". | |
| mode (FM, DMR …) | modo | What hams say; Anatel's *emissão* is formal. | |
| analog / digital | analógico / digital | | |
| signal strength | intensidade do sinal | Short: "Sinal". | |
| S-meter | S-meter | Brazilian hams say "S-meter" / "smeter"; *medidor S* is unidiomatic. | |
| noise floor | ruído de fundo | | |
| NO SIGNAL | SEM SINAL | | |
| channel busy | canal ocupado | | |
| key up (a repeater) | abrir (a repetidora) | "abrir a repetidora" is the Brazilian ham verb. *Acionar* also understood. | |
| repeater tail | cauda | ❓ Brazilian slang varies ("rabicho"); "cauda da repetidora" is clear. | |
| roger beep | roger beep | Common in Brazil (from PX/CB culture). ❓ *bip de câmbio*. | |
| QSO, CQ, 73, QTH, QRV | unchanged | International Q-codes and shorthand, used daily in Brazil ("o QSO", "estou QRV"). | |
| location | localização | "QTH" in ham-flavoured text. | |
| locator / grid square | locator | Brazilians say "locator" or "grid" ("grid GG66"). ❓ *quadrícula* | |
| band | banda (f) | | |
| band plan | plano de bandas | LABRE's term. | |
| VHF / UHF | VHF / UHF | Prose may say "2 metros" / "70 centímetros" ("2 m" / "70 cm") where the band is meant. | |
| propagation | propagação | | |
| antenna | antena | | |
| dummy load | carga fantasma | The standard Brazilian term. | |
| interference | interferência | | |
| identification (repeater ID) | identificação | | |
| Morse | Morse / CW | | |
| beacon | beacon (m) | Brazilian APRS users say "beacon" ("o beacon APRS"). *Baliza* reads European. ❓ | |
| heard station | estação ouvida | | |

## 4. DMR

| English | Português (Brasil) | Why / notes | Reviewer |
|---|---|---|---|
| DMR | DMR | (m) "o DMR". | |
| talkgroup | talkgroup (TG) | Brazilian DMR users say "TG" and "talkgroup" (m): "o TG 724". On tight labels "TG". ❓ *grupo de conversa* is understood but rarely used. | |
| colour code | color code (CC) | Brazilian DMR usage keeps the English. (m) | |
| time slot | slot (TS) | "slot 1 / slot 2", "timeslot". ❓ *intervalo de tempo* is never heard. | |
| private call / group call | chamada privada / chamada de grupo | ❓ *chamada individual*. | |
| DMR ID | ID DMR | (m) "o ID DMR". Never a real ID in examples. | |
| contact | contato | | |
| receive group list | lista de grupos de RX | ❓ *lista de recepção*. | |
| hotspot | hotspot | (m) | |
| codeplug | codeplug | Kept by Brazilian DMR users. (m) | |
| CALL · PICKED | CHAMADA · ESCOLHIDA | Intercom cell legend. Agrees with *chamada*. | |
| promiscuous mode (MON) | Ouvir tudo (MON) | For prose; the key legend MON stays (decided). ❓ *modo promíscuo* is the Brazilian Tytera/Anytone menu word but reads oddly. | |

## 5. Digital modes and data

| English | Português (Brasil) | Notes | Reviewer |
|---|---|---|---|
| APRS, AX.25, iGate, digipeater | unchanged | "o digipeater", "o iGate". | |
| APRS-IS, passcode | APRS-IS, passcode | | |
| packet radio | packet (radio) | Brazilian hams say "packet". (m) | |
| position (APRS) | posição | | |
| telemetry | telemetria | | |
| weather report | dados meteorológicos | APRS weather. Short: "Tempo". | |
| message (APRS/DMR text) | mensagem | | |
| outbox / inbox | caixa de saída / caixa de entrada | | |
| SSTV, FT8, M17, POCSAG, Winlink, DTMF | unchanged | | |
| picture (SSTV) | imagem (f) | | |
| pager | pager | Brazilians called them "bip" or "pager"; *pager* is clearer today. ❓ | |
| decode / decoder | decodificar / decodificador | | |
| forms (Winlink) | formulários | | |

## 6. Safety, licence, heat

Safety text gets a second careful pass (plan §4). These renderings must stay this strong.

| English | Português (Brasil) | Notes | Reviewer |
|---|---|---|---|
| Warning | Atenção | The usual pt-BR header for a warning. | |
| Caution | Cuidado | | |
| Transmitting legally | Transmitir dentro da lei | Guide section title. | |
| You need a licence to transmit on this frequency. | Para transmitir nesta frequência, você precisa de licença de radioamador. | The pattern for licence notes: the condition first. | |
| transmit limit / time limit | limite de tempo de transmissão | Short: "Limite de TX". | |
| Longest transmission | Transmissão máxima | Device setting (a duration). ❓ *Duração máxima de TX*. | |
| heat guard | proteção contra superaquecimento | | |
| too hot | quente demais | "Rádio quente demais": short, unmistakable. | |
| transmit refused | transmissão recusada | | |
| Not sent | Não enviado | | |
| advisory (from the profile list) | aviso | Distinct from "Atenção" (a warning header). | |
| firmware loader | carregador de firmware | | |
| factory image | firmware de fábrica | | |
| do not switch off | não desligue | Firmware loading: always bold, never softened. | |
| emergency | emergência | | |

## 7. Units, numbers, symbols

| English | Português (Brasil) | Notes |
|---|---|---|
| 467.625 MHz | 467,625 MHz | Decimal comma everywhere on screen, the readout included; entry fields accept `,` and `.` (as decided for German; reviewer to confirm). |
| 12.5 kHz | 12,5 kHz | |
| 67.0 Hz (CTCSS) | 67,0 Hz | Brazilian repeater lists already write "67,0". |
| −85 dBm | −85 dBm | Unit unchanged, space before the unit. |
| 30 s, 2 min | 30 s, 2 min | |
| 5 W | 5 W | |
| 1,200 Hz | 1200 Hz | No thousands dot in frequencies (a dot could be read as a decimal). |
| 24-hour time | 14:05 | 24 h. "14h05" only in running prose, never on labels. |
| date | 30/10/2026 · 30 de out. de 2026 | Months lower case. |
| → (menu path) | → | Kept: "Dispositivo → Configurações do rádio". |
| "…" quotes | “…” | Curly double quotes; never in titles (the title font). |

## 8. Terms settled during the German draft (every row of de §8)

The German draft settled these terms beyond §1–7. Every one is given here so the pt-BR draft starts with the same
coverage. Rows marked **❓** are real choices for the reviewer.

### App features and screens

| English | Português (Brasil) | Notes | Reviewer |
|---|---|---|---|
| the Intercom page (in prose) | a página Rádio | The tab is "Rádio" (§1). | |
| Radio controls (car screen) | Controles do rádio | Also "controles do rádio em tela cheia no carro". | |
| Parrot (simplex repeater) | Papagaio | Brazilian hams call a simplex store-and-repeat "papagaio". BrandMeister's echo (private call 9990) stays "Parrot". ❓ One word for both? | |
| Voice keyer | Mensagens de voz | Recorded voice slots to transmit. ❓ *Gravador de voz*. | |
| Net preamble / My ID (keyer slots) | Abertura da roda / Meu indicativo | | |
| ID timer | Temporizador de identificação | Short: "Timer de ID". ❓ | |
| ID reminder | Lembrete de identificação | | |
| Morse ID | Identificação em CW | Also the DTMF command label. | |
| Fox beacon | Transmissor da raposa | Short: "Raposa". An exception to §3 "beacon". | |
| Be the fox | Ser a raposa | | |
| bearing / Spin for the bearing | Azimute / Girar para achar o azimute | ❓ *rumo* / *direção*. | |
| mark (fox hunt) | marcação (prose) · Ponto (buttons: "Salvar ponto", "Limpar pontos") | Buttons are a third of a row wide. ❓ One word for both? | |
| Download terrain / Terrain | Baixar relevo / Relevo | "Relevo" is the natural word for terrain height. ❓ *terreno* | |
| Terrain prediction | Previsão pelo relevo | | |
| Key-ups (coverage layer) | Aberturas | From §3 "abrir a repetidora". ❓ *Acionamentos* | |
| Mapping coverage | Mapeando a cobertura | Notification and widget text. | |
| Log coverage in the car | Registrar cobertura no carro | | |
| Nearby repeaters | Repetidoras próximas | | |
| Nets near you | Rodas perto de você | | |
| On the air near you / Elsewhere on the air | No ar perto de você / No ar em outros lugares | | |
| Nets on this channel (editor section) | Rodas neste canal | | |
| Add a net | Adicionar roda | | |
| check-in (net control) | check-in; verb "fazer check-in"; button "Check-in" | Brazilian rodas say "check-in" or "dar presença". ❓ *Presença* | |
| traffic (net flag) | Tráfego | | |
| Late / Out (net flags) | Chegou tarde / Saiu | Verbs avoid gender agreement (*atrasado/atrasada*). | |
| Scheduled operations / schedule | Operações agendadas / Agendamento | "Adicionar agendamento". | |
| APRS monitoring | Escuta de APRS | Never "monitoramento" (reads as surveillance). | |
| Pager monitor | Escuta de pager | | |
| Monitor APRS (button) | Escutar APRS | Verb form on buttons only. | |
| Packet finder | Localizador de packet | | |
| page (POCSAG message) | mensagem de pager | One rendering. | |
| Hear pages | Receber pager | | |
| Winlink e-mail / Check Winlink mail | E-mail Winlink / Verificar e-mail Winlink | | |
| Session log / Detailed diagnostic log | Registro da sessão / Registro de diagnóstico detalhado | "Registro", not "log", so it never clashes with the Logbook. | |
| Two-way iGate | iGate bidirecional | | |
| Packet lead-in | Preâmbulo do packet | | |
| Beacon via ISS | Beacon pela ISS | "a ISS" (f, a Estação). | |
| Record each pass | Gravar cada passagem | | |
| satellite pass | passagem do satélite | | |
| orbit data | dados orbitais | | |
| Text modes | Modos de texto | | |
| Any mode (SSTV decoder) | Qualquer modo | An SSTV mode (Martin, Scottie). | |
| Combine (SSTV) / In / Left out | Combinar / Incluída / Fora | Agrees with *imagem* (f). | |
| Voice announcements | Anúncios por voz | | |
| keyword alerts | alertas de palavra-chave | | |
| Contribute | Contribuir | | |
| Help support this phone | Ajude a dar suporte a este celular | First-launch title "Help us support this phone": "Ajude a gente a dar suporte a este celular". ❓ *nos ajude* is more formal. | |
| Radio audio check | Teste de áudio do rádio | | |
| Listen check / Second radio test | Teste de escuta / Teste com um segundo rádio | | |
| Transmit test session | Sessão de teste de transmissão | | |
| Bring radio up (diagnostics) | Ligar rádio | Four buttons in a row. | |
| Probe + power pulse | Sondar + pulso de energia | | |
| Restore factory (firmware button) | De fábrica | One of three buttons in a row. | |
| POTA activation / On the air now | Ativação / QRV agora | | |
| contact (logbook) | QSO | A DMR contact stays "contato" (§4); "Registrar QSO", "Registrar de novo". | |
| Log heard | Registrar ouvidos | | |
| Exam practice: Study a subelement / Missed | Estudar uma seção / Erradas | Topic label per §1: "Simulado (prova dos EUA, em inglês)". | |
| Hold to talk (M17) | Segure para falar | | |
| Open in maps | Abrir no Maps | | |

### Firmware and the phone

| English | Português (Brasil) | Notes | Reviewer |
|---|---|---|---|
| phone | celular | What Brazilians say; Android pt-BR uses "telefone" in system text. ❓ | |
| bench firmware / bench image | firmware de bancada / imagem de bancada | "Bancada" is the natural Brazilian bench word. | |
| stock firmware / factory image | firmware de fábrica | As §6. | |
| stock version (SignalDeck Web) | versão de fábrica | | |
| factory backup / factory copy | backup de fábrica / cópia de fábrica | | |
| stock ROM (Android) | ROM original | Not firmware; "ROM stock" is also common among Brazilian Android users. ❓ | |
| symbol engine / tone generator | motor de símbolos / gerador de tons | | |
| Own the radio at boot | Assumir o módulo ao iniciar | §1 "assumir". | |
| Keep access after reboot | Manter acesso após reiniciar | | |
| Turn the radio off and exit | Desligar o rádio e sair | | |
| Hand back to the stock app and exit | Devolver ao app do fabricante e sair | | |
| Radio busy, loading firmware | Rádio ocupado, carregando firmware | | |
| Allow unlisted images | Permitir imagens não listadas | | |
| Web access / Allow transmit from the web | Acesso pela web / Permitir transmissão pela web | | |
| amber (UI colour) | âmbar | Invariable. | |

### Channel editor and lists

| English | Português (Brasil) | Notes | Reviewer |
|---|---|---|---|
| All / Private / Group (call type choice) | Todas / Privada / Grupo | Short forms of §4 for pills; agree with *chamada* (f). | |
| All call (contact type) | Chamada geral | | |
| Relay (repeater) | Repetidora | | |
| Call number from / call number | Origem do número / Número de chamada | | |
| Channel access number (M17) | Número de acesso ao canal (CAN) | | |
| Double slot | Slot duplo | | |
| Interrupt transmission | Interromper transmissão | | |
| RX tone type / TX tone type | Tipo de subtom RX / Tipo de subtom TX | | |
| None (tone) | Nenhum | | |
| High / Low power (choices) | Alta / Baixa | §3. | |
| Enabled / Disabled (choices) | Ativado / Desativado | | |
| Latitude / Longitude | Latitude / Longitude | | |
| Destination (@ALL or a callsign) | Destino (@ALL ou indicativo) | | |
| NOT TUNABLE (badge) | FORA DA FAIXA | Badge cut off at 16 characters on a 480 px screen (13 here). ❓ | |
| RX ONLY (badge) | SÓ RX | | |
| Not legal here | Não permitido aqui | | |
| Show all lists | Mostrar todas as listas | | |
| Star (button) | Favoritar | The icon is "estrela" in prose. | |
| Out of zone (button) | Tirar da zona | Four buttons share a row. | |
| Zone name | Nome da zona | | |
| Marine VHF | VHF marítimo | | |
| NOAA weather | Meteorologia NOAA | US service; name kept. | |
| Home (contact location) | Casa | | |

### Wording rules settled

| English | Português (Brasil) | Notes | Reviewer |
|---|---|---|---|
| Stop … (button) | Parar … | §2 Start/Stop. "Encerrar" only for End (a net, a session, the app). | |
| Halt TX | Parar TX | | |
| Try again | Tentar novamente | §2 Retry. | |
| Loading… / Sending… | Carregando… / Enviando… | Gerund, the Brazilian form (never *A carregar…*). No space before the ellipsis. | |
| Set your callsign first | Informe seu indicativo primeiro | "Informe", the Android pt-BR verb for entering data. | |
| Coverage logging is on | Registro de cobertura ativado | "ativado/desativado" for features, "ligado/desligado" for the radio. | |
| No position fix yet | Ainda sem posição | | |
| Key legends SCAN, ZONE, TXT, SOFT SQ, MON, REC, VFO, PKT | unchanged | No legend is translated. "nível de Soft SQ" keeps the name in a phrase. The car screen's own Scan button is "Varredura". | |
| weekday buttons (one letter) | D S T Q Q S S | Brazilian calendar starts on Sunday (*domingo*). If the app's row starts on Monday: S T Q Q S S D. The repeated letters are normal in Brazil. Three-letter: dom. seg. ter. qua. qui. sex. sáb. | |

## 9. Terms settled during the draft

Added in the consistency pass (2026-10-31), after the pt-BR draft of the screens, SignalDeck Web and the guide. These
are the terms the translators needed beyond §1–8, and the choices made where one English term had come out in several
ways. The draft now uses the pt-BR in the second column everywhere. Rows marked **❓** are real choices for the
reviewer.

### Settled splits (one English term had two or more renderings)

| English | Português (Brasil) | Notes | Reviewer |
|---|---|---|---|
| report (signal report, logbook field) | reporte (m) | "Reporte enviado / Reporte recebido"; FT8 exchange "locator, reporte, R-reporte, RR73, 73". *Reportagem* means a news report and was replaced. | |
| grid square / grid (logbook, FT8, Winlink) | locator | One word everywhere, as §3, the FT8 strings included ("locators trabalhados"). ❓ FT8 operators also say "grid". | |
| track / tracking (satellite pass) | acompanhar / acompanhamento | "Acompanhando %s", "Acompanhamento parado". *Rastrear* (web draft) was replaced. | |
| Stop tracking | Parar acompanhamento | Phone, web and guide. | |
| Morse trainer | Treino de Morse | Web and guide had "Treino de CW". Morse IDs stay "identificação em CW" (§8). ❓ "CW" throughout? | |
| Morse decoder | Decodificador de Morse | Web had "Decodificador de CW". | |
| VHF/UHF conditions | Condições VHF/UHF | Not "Condições em VHF/UHF". | |
| Decode a recording | Decodificar gravação | Panel and guide heading. | |
| Upload a recording… (phone) | Importar gravação… | "Enviar" reads as transmit. The web's own "Upload…" button is "Enviar arquivo…". | |
| Coming up (nets list section) | Próximas | Agrees with *rodas*; the phone had "Em breve". | |
| Last heard (contact's location field) | Última escuta | The Last heard tab stays "Últimos ouvidos". | |
| Check for updates | Verificar atualizações | | |
| KISS TNC | TNC KISS | | |
| 2 m FM simplex (band scope preset) | FM simplex de 2 m | The band-plan list keeps its own "2 m: …" format. | |
| Add contact (logbook) | Adicionar QSO | The web heading "Log a contact" is "Registrar QSO". | |
| New contact (logbook) | Novo QSO | | |
| %s logged (logbook, POTA) | QSO com %s registrado | Avoids "the callsign was registered" (licensing sense). | |
| Run a net | Coordenar roda; prose "Coordene uma roda" | Not *conduzir*. | |
| Mission Statement | Missão | Phone, web and guide (the web had "Nossa missão"). | |
| Custom range… (band scope) | Faixa personalizada… | The web had "Faixa própria". | |
| Winlink password | Senha do Winlink | | |
| Check Winlink mail (radio gateway) | Verificar e-mail Winlink (gateway por rádio) | Matches "Conectar a um gateway por rádio". | |
| Double-press (wheel Next) | Dois toques | Was also "Duplo toque". | |
| Hold (wheel Next) | Segurar | | |
| Car (as a call) | Carro (como chamada) | | |
| Steering-wheel Next talks / Next (media key) | Próxima do volante transmite / Próxima | Feminine, as *próxima faixa*; the guide head is "Próxima como tecla de transmissão". ❓ Check against Android Auto pt-BR. | |
| Home widget / Home-screen widget | Widget da tela inicial | | |
| Channel changes, caller names, keyword alerts | Troca de canal, nomes de quem chama, alertas de palavra-chave | | |
| Listening (state, web card) | Escutando | Not "Ouvindo". | |
| Listen to a channel (scheduled operation) | Escutar um canal | | |
| Relay (repeater) (editor field) | Repetidora | As §8; phone and web. | |
| High power / Low power (editor choices) | Potência alta / Potência baixa | The web had "Alta / Baixa". | |
| Enabled / Disabled (encryption) | Ativada / Desativada | Agrees with *criptografia*. | |
| Private (Contacts page type) | Privado | A contact (m); the call type in the editor stays "Privada" (§8). | |
| heard (logbook row kind) | ouvida | Agrees with *estação* / *entrada*. | |
| Not while transmitting | Não é possível durante a transmissão | | |
| Too long to send | Longo demais para enviar | Title and history lines. | |
| Back to the channel | Voltar ao canal | | |
| login required | login necessário | | |
| No position fix on the phone | O celular está sem posição GPS | | |
| not connected | sem conexão | | |
| No channel %d / No such zone / No zones yet | Canal %d não existe / Essa zona não existe / Nenhuma zona ainda | | |
| Nothing to send | Nada para enviar | | |
| Notes (logbook) | Notas | Was "Observações". | |
| Check the numbers | Confira os números | | |
| You are on the latest version | Você já está na versão mais recente | | |
| Your decision (2 of 2) | A decisão é sua (2 de 2) | | |
| Zoom in / Zoom out | Aumentar zoom / Diminuir zoom | | |
| M17 receive | Recepção M17 | "a recepção de M17" in prose. | |
| packet (APRS frame kind) | packet | Not "pacote" on the label; "pacote" stays in prose for one frame. | |
| The channel the radio is on | O canal em que o rádio estiver | | |
| Satellite passes (PKT tool) | Passagens de satélite | Singular *satélite*. | |
| Talk (button) | Falar | "o botão Falar" in prose. | |
| trial (receive-only take-over in the checks) | teste prático | Progress lines "Teste prático: …"; the button "Verificações + teste". Device part B had "Ensaio". | |
| Run all checks / checks | Executar todas as verificações / verificações | Not "Rodar", not "testes". | |
| monitor (squelch open, in prose) | monitor | "squelch 0 e monitor", "comando de monitor"; never *monitoração*. | |
| ZONE · name (car now-playing picture) | ZONA · nome | Names the zone, not the ZONE key legend. | |
| ended early (heat, history line) | "%s parou antes do fim" | A verb, so no gender agreement with the mode's name. | |

### Terms added by the translators

| English | Português (Brasil) | Notes | Reviewer |
|---|---|---|---|
| Radio probe (title) / Radio probe (root) | Sondagem do rádio / Sondar o rádio (root) | | |
| pre-flight checks | Verificações prévias | | |
| Checks + trial / Checks only | Verificações + teste / Só verificações | | |
| static (recorded noise) | chiado | | |
| advisory overridden | Ignorado por você | ❓ *Desconsiderado*. | |
| In effect (advisory) | Em vigor | | |
| lapses (advisory) | expira | | |
| Boot persistence | Persistência na inicialização | | |
| Phone profile / built-in profile / updated profiles | Perfil do celular / perfil embutido / perfis atualizados | | |
| Learn a PTT key / Custom PTT key | Ensinar uma tecla PTT / Tecla PTT personalizada | | |
| Volume-up transmits / volume up, down | Volume + transmite / Volume +, Volume − | | |
| Steering-wheel play/pause talks | Play/pause do volante transmite | | |
| Steering-wheel microphone | Microfone para o volante | | |
| hands-free link | conexão viva-voz | | |
| DMR roaming | Roaming DMR | | |
| Back up (tile) / Re-import | Backup / Reimportar | | |
| GitHub issue | issue no GitHub (f) | Kept English, as Brazilian GitHub users say. | |
| Intercom layout / Regular / Compact | Layout da página Rádio / Normal / Compacto | | |
| fingerprint (certificate, file) | impressão digital | | |
| New firmware variant | Nova variante de firmware | | |
| handheld | HT | | |
| stock version / take as stock | versão de fábrica / Adotar a versão atual como de fábrica | | |
| handshake log | Registro do handshake | | |
| read-back / flash sample | releitura / amostra da flash | | |
| unlisted image | imagem não listada | | |
| Release / Beta (update paths) | Estável / Beta | "a versão estável" in prose. | |
| Updates (tile) / Update (button) | Atualizações / Atualizar | | |
| power-cycle the module | Reiniciar módulo; "Desligar e religar o módulo de rádio?" | | |
| backup round trip | Ida e volta do backup | | |
| firmware load stages | Preparo, Atualiz., Contato, Apagando, Envio, Fim, Reinício, Conferir | Short pills. | |
| headset | fone | | |
| radio zone (thermal sensor) | zona do rádio | | |
| tone queue | fila de tons | | |
| USB bridge (radio) | ponte USB | | |
| pager waveform | forma de onda do pager | | |
| frames (M17) | quadros | | |
| equaliser taps / fit / not kept | coeficientes / ajuste / ajuste descartado | | |
| locked / no lock (M17 link setup) | sincronizado / sem sincronismo | "link setup" kept. | |
| skipped (scheduled operation) | ignorado | | |
| Weekdays / Weekends | Dias úteis / Fins de semana | | |
| net control (in a notification) | coordenação %s | | |
| Beep / Two-tone / Morse K (roger beep) | Bipe / Dois tons / K em CW | | |
| Small / Better / Best / Max (speech models) | Pequeno / Melhor / Ótimo / Máximo | | |
| billing / quota (Google Cloud) | faturamento / cota | | |
| engine (captions, packet) / on-device | motor / no aparelho | "motor Google", "motor no aparelho", "motor de packet". | |
| Ch (notification, short) | Can. | | |
| Receive here (SSTV) | Receber aqui | | |
| Running now (packet tools) | Rodando agora | ❓ *Em execução* is the Android word. | |
| Digital voice (packet tools section) | Voz digital | | |
| Your own (zone of your channels) | Seus canais | | |
| Unknown sources (Android Auto developer setting) | Fontes desconhecidas | ❓ Confirm against Android Auto pt-BR. | |
| Settings → App block (Agold ROM path) | kept in English | The ROM's own labels. ❓ Change if a pt-BR ROM shows Portuguese. | |
| camcorder input (audio source) | entrada camcorder; "entrada de filmadora" in the guide | ❓ One form? | |
| Cellular (phone panel block) | Rede móvel | Not "Celular", which is the phone. | |
| DUPE (logbook flag) | DUPE | Kept. | |
| Missed questions / Missed | Erradas | Exam practice. | |
| Practice exam | Simulado; button "Fazer simulado" | Guide heading "Simulado". | |
| Sounds like a net | Parece uma roda | | |
| the release check / heat-up (transmit test) | o teste de soltar / aquecimento | ❓ For a native reviewer. | |
