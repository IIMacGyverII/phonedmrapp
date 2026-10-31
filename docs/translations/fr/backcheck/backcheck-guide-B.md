# Back-check: fr guide part B (guide-B)

Topics: messages, device, region, signaldeck-web, map, coverage-maps, android-auto, widget-and-notification,
emergency-and-roger-beep, transmitting-legally. 10 topics, 102 sections (all checked), ~16,000 EN / ~18,100 FR words.
Script checks (ids, {@refs}, numbers with decimal comma normalised, newlines, French spacing before : ; ? and in « »):
0 problems. The only number difference is the added "(env. 97 km/h)" after 60 mph.

## Fixes made after back-translation

| Section | Problem found | Fix |
|---|---|---|
| device/contribute | First draft said "Please consider helping" without "if you like it" | « Si vous l'appréciez, pensez à l'aider à grandir. » |
| device/radio-firmware | EN "battery is charging above 40 percent or above 60 percent" read ambiguously in a literal rendering | Rendered as the pre-flight check is defined (string comment): « dépasse 40 % en charge ou 60 % hors charge » |
| transmitting-legally/time-limit | "seuls vous ou SignalDeck y mettez fin" was ungrammatical and blurred who ends the key | « l'émission ne prend fin que si vous relâchez la touche ou si SignalDeck l'arrête (par sa limite ou par la protection thermique) » |
| device/second-radio-test | "key it / keep it quiet" did not say clearly that the OTHER radio transmits; this phone only listens | « émettez avec l'autre radio… laissez-la muette… émettez avec elle » |
| device/unihertz-atom-xl | "the checks" rendered as « vérifications » while the button is « Lancer tous les tests » | « les tests » |
| coverage-maps (several) | Layer name "Heard" drafted as « Entendu »; the app's layer is « Réception » | Changed throughout (head, layer list, "mesures de réception") |
| device/*, android-auto/* | Several button names differed from values-fr (see the label list in the report) | Aligned to values-fr |

## Safety sections read twice against the English
device: exit, root-and-reboots, custom-ptt-key (third paragraph), radio-firmware (whole: pre-flight checks, at-your-own-risk,
certified phones only, nothing changes bands/power, factory restore), help-support-this-phone ("every step only listens"),
run-all-checks ("do not press PTT", "nothing is transmitted", "never anything that tunes or transmits"), radio-audio-check,
device-report ("only read", the one item that transmits, power pulse only on request, files private), transmit-test-session
(whole), anysecu-w6plus-dmr, untested-profiles (transmit off until tested; exceptions), radios-that-do-less (nothing ever
sent on another channel). signaldeck-web: transmitting, safety. android-auto: talk, radio-controls, messages-read-aloud,
next-as-a-talk-key, steering-wheel-talk. widget: talk-from-the-widget. emergency: all four. transmitting-legally: both
(US rules stay « aux États-Unis »; negations « ne … jamais / ne … pas » complete). region: safe-by-design, how-accurate.
