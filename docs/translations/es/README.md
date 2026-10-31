# SignalDeck in Spanish (es)

**Status: draft, awaiting native review.** Nothing here has been reviewed by a native-speaking ham yet, and no Spanish
string exists in the app. Spanish ships once it is translated, back-checked and screen-checked (owner, 2026-10-30); a
native review then improves it, through plain-file PRs.

**Reviewed by a native-speaking ham:** nothing yet.

**Variant:** neutral international Spanish, for hams in Spain and Latin America alike (`style.md` §2). One `values-es`
file; no separate `es-ES` / `es-419` unless a reviewer finds a screen that neutral wording cannot carry.

- `glossary.md`: the recurring terms and their Spanish rendering (about 300 rows, 33 marked ❓), for the reviewer to
  agree first.
- `style.md`: register (*tú*), the Spain/Latin America word choices, punctuation, numbers, key legends and safety-text
  rules.

The order of work, after the extraction (`../research.md` §6):
1. glossary and style guide, with a reviewer's answers if they come first;
2. draft;
3. back-check;
4. screen check (with the extra Spanish items: accented capitals and ¿ ¡ in the Orbitron titles, the decimal comma on
   the readout, labels about 20–25 % longer than English);
5. ship in a beta;
6. native review improves it afterwards.

## Questions for a native-speaking ham reviewer

Recruited through the Contribute page and GitHub Discussions; contact goes through the owner. These are the choices the
glossary can't settle without a Spanish-speaking ham. It helps to say which country you operate from. The proposed term
is first; alternatives follow.

**English**
1. **tú or usted** for addressing the user? (Proposed: *tú*.)
2. **Decimal comma** on screen, including the big frequency readout: `467,625 MHz`, with input fields accepting comma and
   dot. OK, or keep the radio-style point on the readout (as Mexico and Central America write it)?
3. **Talkgroup:** *talkgroup (TG)* or *grupo de conversación*?
4. **Time slot:** *slot (TS)* or *intervalo de tiempo* / *ranura*?
5. **Squelch:** *squelch* or *silenciador*?
6. **Offset:** *desplazamiento*, *offset* or *shift*?
7. **Net:** *rueda* or *red*? And net check-in: *reporte* / *reportarse*, *entrada*, or *check-in*?
8. **Logbook:** *log*, *libro de guardia* or *bitácora*?
9. **The main page (English "Intercom"):** *Radio*, *Equipo*, or keep *Intercom*?
10. **Settings and Add:** *Ajustes* or *Configuración*; *Agregar* or *Añadir*? (Proposed: *Ajustes*, *Agregar*.)
11. **Callsign:** *indicativo* everywhere, or does your country say something else (*señal distintiva*, *distintivo*)?
12. **Pager:** *pager*, *busca* / *buscapersonas*, or *bíper*?
13. **Band scope:** *Espectro*, or keep *band scope*?
14. **Weekday letters:** *L M X J V S D* (Monday first) or *D L M M J V S*?
15. **Fox hunt bearing:** *rumbo* or *marcación*? And the fox transmitter: *transmisor zorro* / *el zorro*?

Already decided (the reviewer may still object): the intercom key legends **SCAN, ZONE, TXT, SOFT SQ, MON** stay
English, as on radios sold in Spanish-speaking countries. Repeater is *repetidor*, colour code
*código de color*, fox hunt *caza del zorro*, phone *teléfono* (not *móvil* or *celular*), car *vehículo*, quotes “…”.

**Español**
1. **¿Tú o usted** para dirigirse al usuario? (Propuesta: *tú*.)
2. **Coma decimal** en pantalla, también en la lectura grande de frecuencia: `467,625 MHz`; los campos de entrada
   aceptan coma y punto. ¿Está bien, o prefieres el punto en la lectura, como en el equipo (y como se escribe en México y
   Centroamérica)?
3. **Talkgroup:** ¿*talkgroup (TG)* o *grupo de conversación*?
4. **Time slot:** ¿*slot (TS)* o *intervalo de tiempo* / *ranura*?
5. **Squelch:** ¿*squelch* o *silenciador*?
6. **Offset:** ¿*desplazamiento*, *offset* o *shift*?
7. **Net:** ¿*rueda* o *red*? Y el check-in de la rueda: ¿*reporte* / *reportarse*, *entrada* o *check-in*?
8. **Logbook:** ¿*log*, *libro de guardia* o *bitácora*?
9. **La página principal (en inglés "Intercom"):** ¿*Radio*, *Equipo* o dejar *Intercom*?
10. **Ajustes y Agregar:** ¿*Ajustes* o *Configuración*? ¿*Agregar* o *Añadir*? (Propuesta: *Ajustes*, *Agregar*.)
11. **Indicativo:** ¿*indicativo* en todas partes, o en tu país se dice otra cosa (*señal distintiva*, *distintivo*)?
12. **Pager:** ¿*pager*, *busca* / *buscapersonas* o *bíper*?
13. **Band scope:** ¿*Espectro*, o dejar *band scope*?
14. **Letras de los días:** ¿*L M X J V S D* (empezando el lunes) o *D L M M J V S*?
15. **Caza del zorro:** ¿*rumbo* o *marcación*? ¿Y el transmisor: *transmisor zorro* / *el zorro*?

Ya decidido (se aceptan objeciones): las teclas **SCAN, ZONE, TXT, SOFT SQ, MON** quedan en inglés, como en los equipos
que se venden en los países hispanohablantes. Repeater = *repetidor*, colour code = *código de
color*, fox hunt = *caza del zorro*, phone = *teléfono* (ni *móvil* ni *celular*), car = *vehículo*, comillas “…”.
