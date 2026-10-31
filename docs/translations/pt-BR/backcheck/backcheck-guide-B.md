# Back-check: Brazilian Portuguese guide, part B (guide-B)

File: `scratchpad/pt-BR-guide/partB.json` (10 topics, 102 sections, about 17 400 Portuguese words).

Method: each section read back into English and compared with en.json for meaning, negation, numbers and units. Then a
script compared section ids, `{@name}` references, head numbers, line breaks and every number with en.json (decimal
comma and dd/mm/yyyy dates normalised), plus a count of negation words per section against the English. Result: 0 id,
reference or line-break problems. The only number differences are the metric conversions added on purpose (listed
below) and false positives from the normaliser (GPL-3.0, "seção 3.3", the IP address).

Checked: 102 sections (all).

## Fixes made during the back-check

| Topic / section | Problem found | Fix |
|---|---|---|
| all | Bold markers (`**não**`) slipped into the draft; the guide format has no markup | Removed (the negations stay early in the sentence) |
| android-auto / next-as-a-talk-key | "um toque só vai para o próximo canal" read back as "a tap *only* goes to the next channel" | "um toque único vai para o próximo canal depois de meio segundo" |
| coverage-maps / terrain-prediction | "ou Defina a exata" read as an unrelated command | "Se você souber a altura, escolha uma ou informe a exata em Definir." |
| signaldeck-web / phone-panel | "Celular:" for the cell-network block read back as "Phone:" | "Rede móvel:" (as the web table) |
| device / run-all-checks, help-support-this-phone, unihertz-atom-xl | "checks" drafted as *testes* and "trial" as *ensaio*; the strings use *verificações* and *teste* | Executar todas as verificações, Verificações + teste; every trial sentence now *o teste*, every check *as verificações* |
| device / radio-firmware | Stage names drafted before values-pt-rBR existed | Preparo, Atualiz., Contato, Apagando, Envio, Fim, Reinício, Conferir; Baixar o firmware de fábrica |
| device / tools, mission-statement, about-and-license | Button names differed from the strings | Backup, Estável, Testar ida e volta do backup, Missão |
| signaldeck-web / what-it-shows, decode, if-it-does-not-open | Web labels differed from pt-BR.json | Simulado (Fazer simulado, Estudar uma seção, Revisar erradas), Treino de CW, Enviar imagem, Enviar arquivo…, FT8 em FM, TNC KISS, sinal ouvido / transmissão chegou, Mostrar tudo, Parado |
| coverage-maps | Layer name *Ouvido* vs the strings' *Ouvidos* | camada Ouvidos throughout |
| android-auto | Option names | Dois toques, Microfone para o volante |
| emergency-and-roger-beep / roger-beep | Option names | Bipe, K em CW |
| region | Card and button text | “(pelo seu chip)”, Restaurar |

No negation, number or unit was found changed apart from the items above.

## Intentional additions (not in the English)
- map / what-is-on-it: "de 15 a 120 milhas, de 25 a 190 km".
- coverage-maps / driving-with-a-steady-signal: "a 60 mph (cerca de 100 km/h)".
- coverage-maps / terrain-prediction: "até 50 milhas (80 km)" (first mention only).
- emergency-and-roger-beep / emergency: "A palavra EMERGENCY é transmitida em inglês." (the text goes on air as is).
- device / dates written 28/10/2026, 29/10/2026 (English ISO dates).

## Safety sections checked twice (second pass against the English)
- device: exit (closing does not switch the radio off), root-and-reboots, custom-ptt-key (last paragraph: transmit
  limit, receive-only refusal, untested profile does not transmit; nothing transmits while learning), phone-profile
  (advisories switch transmit / take-over / profile off; override asks twice; transmit changes apply at once),
  radio-firmware (whole section: catalogue, nothing sent unless you submit, attachment is public, pre-flight checks,
  battery 40 % charging / 60 %, automatic factory restore, unlisted images off until confirmed twice and switch off
  after the load, own risk / no warranty, certified phones only, page does not open elsewhere),
  help-support-this-phone ("todas as etapas só escutam"), run-all-checks (receive only, "não aperte o PTT" during the
  stock-app window, probe never tunes or transmits, nothing in the draft profile is applied), radio-audio-check
  ("nada é transmitido"), device-report (only the transmit test session transmits; probe powers the module only with
  Sondar + pulso de energia; personal data removed), second-radio-test ("este celular só escuta"),
  transmit-test-session (whole section: opening conditions, never with an advisory or Restricted mode, safety sheet,
  28 s limit, receive-only refusal), when-the-radio-module-stops-answering (never while transmitting),
  radios-that-do-less (nothing sent on another channel), anysecu-w6plus-dmr (transmit status, M17 cannot be sent),
  untested-profiles (no automatic take-over, transmit off until tested, the three exceptions and their limits).
- signaldeck-web: transmitting (never without Allow transmit from the web; unkeys on release/tab switch; 1.5 s),
  safety (local network only, 5 PINs / 1 minute, passcode never sent).
- coverage-maps: key-up-test (asks before transmitting, use sparingly), good-habits (do not key a repeater to test).
- android-auto: talk, radio-controls-big-talk-button, next-as-a-talk-key, steering-wheel-talk,
  if-android-auto-drops-while-you-talk.
- widget-and-notification: talk-from-the-widget.
- emergency-and-roger-beep: all four sections (hold 2 s, early lift cancels, real emergencies only).
- transmitting-legally: licences (US scope kept on GMRS only, "nos EUA"), time-limit (all values 30 s – 10 min, 10 s
  minimum custom, radio timer +2 s / 255 s, No limit behaviour, mode limits 26/25/25/26 s, heat guard 30 s, 1 °C,
  17 min, 60/45/70/48 °C, 2 °C in 10 s, locked in Restricted mode).
- region: safe-by-design, how-accurate-it-is (licence-free service does not mean this phone is approved).
