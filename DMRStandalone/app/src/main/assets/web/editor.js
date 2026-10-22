/*
 * SignalDeck - Copyright (C) 2026 IIMacGyverII
 * SPDX-License-Identifier: GPL-3.0-or-later
 * Free software under the GNU General Public License v3 or later, with the additional terms in COPYRIGHT
 * (keep this notice and the author credit, mark modified versions, no rights to the SignalDeck name or icon).
 */
// SignalDeck Web: the channel editor (every field of the phone's editor, its checks run on the phone, its help texts).
'use strict';

const ED = { ch: null, isNew: false, help: {}, tones: { ctcss: [], dcs: [] } };

/** The VFO in the same editor: any frequency without saving a channel; Tune enters VFO mode. */
async function openVfo() {
  try {
    if (location.hash !== '#channels') { location.hash = 'channels'; await new Promise(r => setTimeout(r, 50)); }
    const j = await api('vfo');
    ED.vfo = true; ED.vfoActive = j.active; ED.step = j.step; ED.steps = j.steps;
    ED.ch = j.channel; ED.isNew = false; ED.help = j.help; ED.tones = j.tones;
    renderEditor();
  } catch (e) { toast(e.message); }
}
async function openEditor(number) {
  try {
    const j = await api('channel?number=' + (number || 0));
    ED.vfo = false;
    ED.ch = j.channel; ED.isNew = j.isNew; ED.help = j.help; ED.tones = j.tones;
    renderEditor();
    if (window.innerWidth < 900) $('edPanel').scrollIntoView({ behavior: 'smooth' });
  } catch (e) { toast(e.message); }
}

function renderEditor() {
  const c = ED.ch, digital = c.type === 0;
  $('edTitle').textContent = ED.vfo ? 'VFO' : ED.isNew ? 'NEW CHANNEL' : 'EDIT CHANNEL';
  $('edSub').textContent = ED.vfo ? (ED.vfoActive ? 'ON' : 'OFF') : ED.isNew ? '' : 'CHANNEL ' + c.number;
  $('edEmpty').classList.add('hidden'); $('edForm').classList.remove('hidden');
  const mhzIn = hz => hz > 0 ? (hz / 1e6).toFixed(5) : '';
  const opt = (vals, cur) => vals.map(([v, t]) => '<option value="' + v + '"' + (String(v) === String(cur) ? ' selected' : '') + '>' + esc(t) + '</option>').join('');
  const range = (a, b) => Array.from({ length: b - a + 1 }, (_, i) => [a + i, String(a + i)]);
  const field = (key, label, input) => '<label class="f"><span>' + esc(label) + (ED.help[key] ? ' <button type="button" class="info" data-help="' + key + '" aria-label="About ' + esc(label) + '">i</button>' : '') + '</span>' + input + '<div class="tip hidden" data-tip="' + key + '"></div></label>';
  const sel = (id, vals, cur) => '<select id="' + id + '">' + opt(vals, cur) + '</select>';
  const txt = (id, val, extra) => '<input id="' + id + '" value="' + esc(val) + '" ' + (extra || '') + '>';
  const toneVals = type => type === 1 ? ED.tones.ctcss.map((t, i) => [i, t]) : type === 2 || type === 3 ? ED.tones.dcs.map((t, i) => [i, t + (type === 3 ? 'I' : 'N')]) : [[0, '—']];
  let h = '';
  h += '<div class="sect">' + (ED.vfo ? 'FREQUENCY' : 'CHANNEL') + '</div>';
  if (!ED.vfo) h += field('name', 'Channel name', txt('fName', c.name, 'maxlength="16"'));
  h += field('type', 'Channel type', sel('fType', [[0, 'Digital'], [1, 'Analog']], c.type));
  h += field('tx', 'Send frequency (MHz)', txt('fTx', mhzIn(c.txFreq), 'inputmode="decimal"'));
  h += field('rx', 'Receive frequency (MHz)', txt('fRx', mhzIn(c.rxFreq), 'inputmode="decimal"'));
  h += field('power', 'Power', sel('fPower', [[0, 'Low power'], [1, 'High power']], c.power));
  h += field('relay', 'Relay (repeater)', sel('fRelay', [[1, 'Disconnect'], [2, 'Normal']], c.relay === 1 ? 1 : 2));
  if (digital) {
    h += '<div class="sect">DIGITAL (DMR)</div>';
    h += field('cc', 'Color code', sel('fCc', range(0, 15), c.cc));
    h += field('mode', 'Mode', sel('fMode', [[0, 'Direct'], [4, 'Double slot']], c.mode === 4 ? 4 : 0));
    h += field('slot', 'Time slot', sel('fSlot', [[0, 'TS1'], [1, 'TS2']], c.slot));
    h += field('contactType', 'Contact type', sel('fCtype', [[0, 'Private'], [1, 'Group'], [2, 'All']], c.contactType));
    h += field('call', 'Call number (DMR ID / talkgroup)', txt('fCall', c.txContact > 0 ? c.txContact : '', 'inputmode="numeric"'));
    h += field('groups', 'RX group list (comma separated, up to 32)', txt('fGroups', (c.groups || []).join(', ')));
    h += field('encrypt', 'Encrypt', sel('fEnc', [[2, 'Disabled'], [1, 'Enabled']], c.encryptSw === 1 ? 1 : 2));
    h += field('key', 'Encrypt key (8 characters)', txt('fKey', '', 'maxlength="8" placeholder="' + (c.hasKey ? 'Set (leave empty to keep)' : 'Not set') + '"'));
    h += field('interrupt', 'Interrupt transmission', sel('fInt', [[2, 'OFF'], [1, 'ON']], c.interrupt === 1 ? 1 : 2));
  } else {
    h += '<div class="sect">ANALOG (FM)</div>';
    h += field('band', 'Band', sel('fBand', [[0, 'Narrow band'], [1, 'Wide band']], c.band === 0 ? 0 : 1));
    h += field('softSq', 'Soft SQ', sel('fSoft', [[0, 'Off'], [1, 'On']], c.softSq ? 1 : 0));
    h += field('softSqLevel', 'Soft SQ level', sel('fSoftLvl', range(1, 9), Math.max(1, Math.min(9, c.softSqLevel))));
    h += field('sq', 'Squelch level', sel('fSq', range(0, 9), c.sq));
    h += field('txType', 'TX tone type', sel('fTxType', [[0, 'None'], [1, 'CTCSS'], [2, 'DCS'], [3, 'DCS inverted']], c.txType));
    h += field('txTone', 'TX tone', sel('fTxCode', toneVals(c.txType), c.txSubCode));
    h += field('rxType', 'RX tone type', sel('fRxType', [[0, 'None'], [1, 'CTCSS'], [2, 'DCS'], [3, 'DCS inverted']], c.rxType));
    h += field('rxTone', 'RX tone', sel('fRxCode', toneVals(c.rxType), c.rxSubCode));
  }
  if (ED.vfo) {
    h += field('step', 'Arrow step', sel('fStep', ED.steps.map(s => [s, (s / 1000) + ' kHz']), ED.step));
    h += '<div class="actions"><button class="btn primary">Tune</button>' + (ED.vfoActive ? '<button type="button" class="btn" id="edExitVfo">Back to the channel</button>' : '') + '<button type="button" class="btn" id="edCancel">Close</button></div>';
    h += '<div class="note">Tune puts the radio on this frequency without saving a channel; the intercom arrows then step it by the arrow step. VHF is always wide band. Back to the channel returns to the channel you were on.</div>';
  } else {
    h += '<div class="sect">LOCATION</div>';
    h += field('pos', 'Latitude (optional)', txt('fLat', c.lat != null ? c.lat.toFixed(5) : '', 'inputmode="decimal"'));
    h += field('pos', 'Longitude (optional)', txt('fLon', c.lon != null ? c.lon.toFixed(5) : '', 'inputmode="decimal"'));
    h += '<div class="sect">NOTES</div>';
    h += field('notes', 'Notes (optional)', '<textarea id="fNotes" rows="3">' + esc(c.notes || '') + '</textarea>');
    h += '<div class="actions"><button class="btn primary">' + (ED.isNew ? 'Add channel' : 'Save') + '</button><button type="button" class="btn" id="edCancel">Close</button>'
      + (ED.isNew ? '' : '<button type="button" class="btn" id="edTune">Tune</button><button type="button" class="btn danger" id="edDelete">Delete</button>') + '</div>';
    h += '<div class="note">Saving an active channel re-programs the radio at once. VHF channels are always saved as wide band (narrow makes this radio deaf on VHF).</div>';
  }
  $('edForm').innerHTML = h;

  // a change of type redraws the form (keeping what was typed); a tone type change refills its tone list
  $('fType').onchange = () => { Object.assign(ED.ch, collect(true)); ED.ch.type = +$('fType').value; renderEditor(); };
  const toneSwap = (typeId, codeId) => { const t = $(typeId); if (t) t.onchange = () => { $(codeId).innerHTML = opt(toneVals(+t.value), 0); }; };
  toneSwap('fTxType', 'fTxCode'); toneSwap('fRxType', 'fRxCode');
  $('edCancel').onclick = closeEditor;
  if (ED.vfo) { const x = $('edExitVfo'); if (x) x.onclick = async () => { if (await act('vfo/exit', {})) setTimeout(openVfo, 1500); }; return; }
  if (!ED.isNew) {
    $('edTune').onclick = () => act('channel/select', { number: ED.ch.number });
    $('edDelete').onclick = async () => {
      if (!confirm('Delete channel ' + ED.ch.number + (ED.ch.name ? ' (' + ED.ch.name + ')' : '') + '? This cannot be undone.')) return;
      if (await act('channel/delete', { number: ED.ch.number })) { closeEditor(); loadChannels(); }
    };
  }
}

/** The form's values; keepOnly = just remember them in ED.ch (for a redraw after a type change). */
function collect(keepOnly) {
  const v = id => { const e = $(id); return e ? e.value : undefined; };
  const o = { number: ED.isNew ? 0 : ED.ch.number, name: v('fName'), type: +v('fType'), txMHz: parseFloat(v('fTx')), rxMHz: parseFloat(v('fRx')),
    power: +v('fPower'), relay: +v('fRelay'), lat: v('fLat'), lon: v('fLon') };
  if ($('fNotes')) o.notes = v('fNotes');
  if ($('fCc')) Object.assign(o, { cc: +v('fCc'), mode: +v('fMode'), slot: +v('fSlot'), contactType: +v('fCtype'), txContact: v('fCall'), groups: v('fGroups'), encryptSw: +v('fEnc'), interrupt: +v('fInt') });
  if ($('fKey') && v('fKey')) o.encryptKey = v('fKey');
  if ($('fBand')) Object.assign(o, { band: +v('fBand'), softSq: v('fSoft') === '1', softSqLevel: +v('fSoftLvl'), sq: +v('fSq'), txType: +v('fTxType'), txSubCode: +v('fTxCode'), rxType: +v('fRxType'), rxSubCode: +v('fRxCode') });
  if (keepOnly) {   // map back onto the channel object's own field names
    return { name: o.name, txFreq: Math.round((o.txMHz || 0) * 1e6), rxFreq: Math.round((o.rxMHz || 0) * 1e6), power: o.power, relay: o.relay,
      lat: o.lat ? parseFloat(o.lat) : undefined, lon: o.lon ? parseFloat(o.lon) : undefined };
  }
  return o;
}

function closeEditor() { ED.ch = null; $('edForm').classList.add('hidden'); $('edForm').innerHTML = ''; $('edEmpty').classList.remove('hidden'); $('edTitle').textContent = 'CHANNEL'; $('edSub').textContent = ''; }

$('edForm').addEventListener('submit', async e => {
  e.preventDefault();
  if (isNaN(parseFloat($('fTx').value)) || isNaN(parseFloat($('fRx').value))) { toast('Enter both frequencies in MHz'); return; }
  if (ED.vfo) { const o = collect(false); o.step = +$('fStep').value; if (await act('vfo', o)) setTimeout(openVfo, 1500); return; }
  const j = await act('channel/save', collect(false));
  if (j) { await loadChannels(); openEditor(j.number); }
});
$('edForm').addEventListener('click', e => {
  const b = e.target.closest('.info'); if (!b) return; e.preventDefault();
  const tip = b.closest('.f').querySelector('.tip'); const on = tip.classList.toggle('hidden') === false;
  tip.textContent = ED.help[b.dataset.help] || ''; b.classList.toggle('on', on);
});
$('chNew').onclick = () => openEditor(0);
$('chVfo').onclick = openVfo;
$('vfoBtn').onclick = openVfo;
