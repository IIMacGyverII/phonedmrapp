# SignalDeck in Brazilian Portuguese (pt-BR)

**Status: draft, awaiting native review.** Nothing here has been reviewed by a native-speaking Brazilian ham yet, and no
pt-BR string exists in the app. pt-BR ships once it is translated, back-checked and screen-checked (owner, 2026-10-30);
a native review then improves it, through plain-file PRs.

**Reviewed by a native-speaking ham:** nothing yet.

- `glossary.md`: the recurring terms and their Brazilian rendering, including every term the German draft settled
  (de §8), for the reviewer to agree first.
- `style.md`: variant (Brazil, not Portugal), register (*você*), punctuation, decimal comma, key legends and
  safety-text rules.

The order of work, after the extraction (`../research.md` §6):
1. glossary and style guide, with a reviewer's answers if they come first;
2. draft;
3. back-check;
4. screen check (accented capitals in the title font, label length);
5. ship in a beta;
6. native review improves it afterwards.

## Questions for a native-speaking Brazilian ham (for the owner to forward)

Contact goes through the owner only. These are the choices the glossary can't settle without a Brazilian ham. The rest
of `glossary.md` is welcome feedback too, but these come first. The proposed term is first; alternatives follow.

**English**
1. **você** for addressing the user, with Android-style imperatives ("Toque em …")? (Proposed: yes.)
2. **Decimal comma** on screen, including the big frequency readout: `467,625 MHz`, CTCSS `67,0 Hz`, with input
   fields accepting comma and dot. OK, or keep the radio-style dot on the readout?
3. **The main page (English "Intercom"):** *Rádio*, *Fonia*, or keep *Intercom*?
4. **Talkgroup:** *talkgroup (TG)* or *grupo de conversa*? **Time slot:** *slot* or *timeslot*?
5. **Squelch:** keep *squelch*, or *silenciador*?
6. **Repeater offset:** *offset*, *shift* or *deslocamento*?
7. **Net / net control / check-in:** *roda*, *coordenação da roda*, *check-in* (or *presença*)?
8. **Licence:** *licença de radioamador*, or something closer to Anatel's COER wording?
9. **Last heard:** *Últimos ouvidos* or *Últimas escutas*?
10. **Roger beep:** *roger beep* or *bip de câmbio*? **Repeater tail:** *cauda* or another word?
11. **Phone:** *celular* or *telefone* (Android's word)?
12. **Parrot** (simplex store-and-repeat): *Papagaio*, and should BrandMeister's echo (9990) also be *Papagaio*?
13. **Fox hunt bearing:** *azimute*, *rumo* or *direção*? **Terrain:** *relevo* or *terreno*?
14. **Beacon** (APRS): keep *beacon*, or *baliza*?
15. **Promiscuous mode** (hear every call, key **MON**): *Ouvir tudo* in prose, OK?

Already decided (the reviewer may still object): the intercom key legends **SCAN, ZONE, TXT, SOFT SQ, MON** stay
English. Repeater is *repetidora*, tone is *subtom*, callsign *indicativo*, colour code *color code*, dummy load *carga
fantasma*, key up *abrir a repetidora*, fox hunt *caça à raposa*, exam practice *simulado*, scan *varredura*.

**Português**
1. **Você** como tratamento, com imperativos no estilo do Android ("Toque em …")? (Proposta: sim.)
2. **Vírgula decimal** em toda a tela, inclusive no visor grande de frequência: `467,625 MHz`, subtom `67,0 Hz`; os
   campos aceitam vírgula e ponto. Tudo bem, ou melhor manter o ponto no visor, como no rádio?
3. **A página principal (em inglês "Intercom"):** *Rádio*, *Fonia* ou manter *Intercom*?
4. **Talkgroup:** *talkgroup (TG)* ou *grupo de conversa*? **Time slot:** *slot* ou *timeslot*?
5. **Squelch:** manter *squelch* ou usar *silenciador*?
6. **Offset da repetidora:** *offset*, *shift* ou *deslocamento*?
7. **Net / net control / check-in:** *roda*, *coordenação da roda*, *check-in* (ou *presença*)?
8. **Licença:** *licença de radioamador* ou algo mais próximo do COER da Anatel?
9. **Last heard:** *Últimos ouvidos* ou *Últimas escutas*?
10. **Roger beep:** *roger beep* ou *bip de câmbio*? **Cauda da repetidora:** *cauda* ou outra palavra?
11. **Phone:** *celular* ou *telefone* (a palavra do Android)?
12. **Parrot** (repetição simplex): *Papagaio*? E o eco do BrandMeister (9990) também vira *Papagaio*?
13. **Caça à raposa, bearing:** *azimute*, *rumo* ou *direção*? **Terrain:** *relevo* ou *terreno*?
14. **Beacon** (APRS): manter *beacon* ou usar *baliza*?
15. **Modo promíscuo** (ouvir todas as chamadas, tecla **MON**): *Ouvir tudo* no texto, pode ser?

Já decidido (objeções são bem-vindas): as teclas **SCAN, ZONE, TXT, SOFT SQ, MON** continuam em inglês. Repeater =
*repetidora*, tone = *subtom*, callsign = *indicativo*, colour code = *color code*, dummy load = *carga fantasma*,
key up = *abrir a repetidora*, fox hunt = *caça à raposa*, exam practice = *simulado*, scan = *varredura*.
