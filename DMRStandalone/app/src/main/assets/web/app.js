// SignalDeck Web: the browser side of SignalDeck's built-in web server. Talks to /api (JSON) and /api/events (SSE).
'use strict';
const $ = id => document.getElementById(id);
const S = { status: null, history: [], channels: [], zones: [], aprsLog: [], stations: [], pictures: [], es: null, page: 'intercom' };

async function api(path, body) {
  const opt = body === undefined ? {} : { method: 'POST', headers: { 'Content-Type': 'application/json' }, body: JSON.stringify(body) };
  const r = await fetch('/api/' + path, opt);
  if (r.status === 401) { showLogin(); throw new Error('login required'); }
  const j = await r.json().catch(() => ({}));
  if (!r.ok) throw new Error(j.error || ('HTTP ' + r.status));
  return j;
}
function toast(msg) { const t = $('toast'); t.textContent = msg; t.classList.remove('hidden'); clearTimeout(toast.t); toast.t = setTimeout(() => t.classList.add('hidden'), 3500); }
async function act(path, body) { try { const j = await api(path, body); if (j.message) toast(j.message); return j; } catch (e) { toast(e.message); return null; } }
const esc = s => String(s == null ? '' : s).replace(/[&<>"']/g, c => ({ '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;', "'": '&#39;' }[c]));
const mhz = hz => (hz / 1e6).toFixed(4);
const hhmm = ts => new Date(ts).toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' });
const hhmmss = ts => new Date(ts).toLocaleTimeString([], { hour: '2-digit', minute: '2-digit', second: '2-digit' });
const ago = ts => { const s = Math.max(0, (Date.now() - ts) / 1000); return s < 60 ? Math.round(s) + ' s ago' : s < 3600 ? Math.round(s / 60) + ' min ago' : s < 86400 ? Math.round(s / 3600) + ' h ago' : new Date(ts).toLocaleDateString(); };

// ---- login ----
function showLogin() { if (S.es) { S.es.close(); S.es = null; } $('app').classList.add('hidden'); $('login').classList.remove('hidden'); $('pin').focus(); }
$('loginForm').addEventListener('submit', async e => {
  e.preventDefault(); $('loginErr').textContent = '';
  const r = await fetch('/api/login', { method: 'POST', headers: { 'Content-Type': 'application/json' }, body: JSON.stringify({ pin: $('pin').value }) });
  if (r.ok) { $('pin').value = ''; start(); } else { const j = await r.json().catch(() => ({})); $('loginErr').textContent = j.error || 'Login failed'; }
});
$('logout').addEventListener('click', async () => { await fetch('/api/logout'); showLogin(); });

// ---- pages ----
function route() {
  const p = (location.hash || '#intercom').slice(1);
  S.page = ['intercom', 'channels', 'messages', 'contacts', 'aprs', 'sstv', 'pkt', 'sat', 'map', 'log', 'rec', 'trans', 'exam', 'settings', 'help'].includes(p) ? p : 'intercom';
  document.querySelectorAll('.page').forEach(el => el.classList.toggle('hidden', el.id !== 'page-' + S.page));
  document.querySelectorAll('#nav a').forEach(a => a.classList.toggle('on', a.dataset.page === S.page));
  const on = document.querySelector('#nav a.on'); if (on && on.scrollIntoView) on.scrollIntoView({ inline: 'center', block: 'nearest' });   // narrow screens scroll the tabs
  if (S.page === 'channels') { loadChannels(); loadZonesEditor(); }
  if (S.page === 'aprs') loadAprs();
  if (S.page === 'sstv') loadSstv();
  if (S.page === 'sat') { renderSat(); loadPasses(); }
  if (S.page === 'intercom') loadHeard();
  if (S.page === 'messages') loadConversations();
  if (S.page === 'contacts') loadContacts();
  if (S.page === 'map') loadMap();
  if (S.page === 'help') loadHelp();
  if (S.page === 'log') { if (!S.qso) editQso(null); loadLog(); loadNet(); }
  if (S.page === 'rec') loadRecordings();
  if (S.page === 'trans') loadTrans();
  if (S.page === 'exam') { loadExam(); loadTrainer(); }
  if (S.page === 'settings') { loadSettings(); loadBackups(); loadDiagLog(); }
  if (S.page === 'pkt') { loadPacket(); loadKeyer(); }
}
window.addEventListener('hashchange', route);

// ---- start / live events ----
async function start() {
  try { S.status = await api('status'); } catch (e) { return; }
  $('login').classList.add('hidden'); $('app').classList.remove('hidden');
  renderStatus(); loadHistory(); route(); connect();
}
function connect() {
  if (S.es) S.es.close();
  const es = new EventSource('/api/events'); S.es = es;
  es.onopen = () => { setConn(true); refresh(); };
  es.onerror = () => { setConn(false); fetch('/api/status').then(r => { if (r.status === 401) showLogin(); }).catch(() => {}); };
  const on = (t, f) => es.addEventListener(t, ev => { try { f(JSON.parse(ev.data)); } catch (e) { console.warn(t, e); } });
  on('channel', ch => { S.status.channel = ch; renderStatus(); loadHistory(); if (S.page === 'channels') renderChannels(); });
  on('rx', d => { S.status.hearing = d.on; renderState(); });
  on('tx', d => { S.status.transmitting = d.on; renderState(); });
  on('rssi', d => { S.status.rssi = d.dbm; renderMeter(); });
  on('level', d => { $('vuFill').style.width = Math.min(100, Math.round(Math.sqrt(d.amp / 32767) * 100)) + '%'; clearTimeout(S.vuT); S.vuT = setTimeout(() => { $('vuFill').style.width = '0'; }, 400); });
  on('history', d => addHistory(d.line));
  on('caller', d => { S.status.caller = d.text; renderState(); });
  on('link', d => { S.status.link = d.state; S.status.ready = d.state === 'ready'; renderStatus(); });
  on('modes', d => { Object.assign(S.status, { softSq: d.softSq, softSqLevel: d.softSqLevel, monitor: d.monitor, record: d.record, scanning: d.scanning, zone: d.zone }); renderStatus(); });
  on('caption', d => renderCaption(d));
  loadCaptions();
  on('sms', () => { if (S.page === 'messages') loadConversations(); });
  on('net', () => { if (S.page === 'log') loadNet(); });
  on('smsResult', d => { toast(d.ok ? 'Text delivered' : 'No acknowledgement (the text may still have arrived)'); if (S.page === 'messages') loadConversations(); });
  on('sat', d => { S.status.sat = d; renderModebar(); if (S.page === 'sat') renderSat(); });
  on('mode', d => { S.status.mode = d; renderModebar(); renderAprsState(); renderSstvState(); });
  on('aprs', () => { if (S.page === 'aprs') loadAprs(); });
  on('sstv', d => { const old = S.status.sstv || {}; S.status.sstv = d; renderSstvState(); if (S.page === 'sstv' && (d.stamp !== old.stamp || d.on)) refreshLive(); if (S.page === 'sstv' && !d.on && old.on) loadSstv(); });
}
async function refresh() { try { S.status = await api('status'); renderStatus(); } catch (e) { } }
function setConn(ok) { $('connDot').className = 'dot ' + (ok ? 'ok' : 'bad'); $('connText').textContent = ok ? 'Live' : 'Reconnecting…'; }

// ---- intercom ----
function renderStatus() {
  const s = S.status; if (!s) return; const ch = s.channel || {};
  $('chNum').textContent = s.vfo ? 'VFO' : (ch.number != null ? String(ch.number).padStart(2, '0') : '--');
  $('chName').textContent = ch.name || (ch.digital ? 'Digital' : 'Analog');
  $('freq').textContent = ch.rxFreq ? mhz(ch.rxFreq) : '---.----';
  $('chType').textContent = ch.rxFreq ? (ch.digital ? 'DMR · CC' + ch.cc + ' · TS' + ((ch.slot || 0) + 1) : 'FM') : '';
  $('tone').textContent = ch.rxFreq && ch.txFreq && ch.txFreq !== ch.rxFreq ? 'TX ' + mhz(ch.txFreq) : '';
  const link = $('link'); link.textContent = s.ready ? 'RADIO READY' : (s.link || '').toUpperCase(); link.className = 'chip ' + (s.ready ? 'green' : 'amber');
  $('scanBtn').classList.toggle('on', !!s.scanning); $('monBtn').classList.toggle('on', !!s.monitor); $('recBtn').classList.toggle('on', !!s.record); $('sqBtn').classList.toggle('on', !!s.softSq); $('vfoBtn').classList.toggle('on', !!s.vfo);
  if (document.activeElement !== $('sqLevel')) $('sqLevel').value = s.softSqLevel; $('sqVal').textContent = s.softSqLevel;
  const z = $('zoneSel'); if (z.dataset.loaded !== '1') loadZones(); else z.value = String(s.zoneId);
  const cz = $('chZone'); if (cz && cz.options.length && cz.value !== String(s.zoneId)) { cz.value = String(s.zoneId); if (S.page === 'channels') loadChannels(); }   // changed elsewhere (phone, intercom)
  const ptt = $('ptt'); const canTx = s.webTx && s.ready && !s.txInhibited && !(s.sat && s.sat.tracking && s.sat.listenOnly && !s.sat.waiting);
  ptt.disabled = !canTx;
  const secureUrl = 'https://' + location.hostname + ':' + (s.tlsPort || 8443) + '/';
  $('pttNote').innerHTML = !s.webTx ? 'Transmit from the web is off. Turn it on at the phone: Device → SignalDeck Web.' : s.txInhibited ? 'This channel is receive-only.'
    : TALK.usable() ? 'Hold to talk with this computer\'s microphone (or hold the space bar).'
    : 'Hold to talk (or the space bar): the phone\'s microphone transmits.' + (s.tls ? ' To talk with this computer\'s microphone open <a href="' + secureUrl + '">' + esc(secureUrl) + '</a> (accept the certificate warning once).' : '');
  renderState(); renderMeter(); renderModebar(); renderAprsState(); renderSstvState(); renderSendState();
}
function renderState() {
  const s = S.status; const b = $('rxtx');
  if (s.transmitting) { b.textContent = 'TX'; b.className = 'badge tx'; } else if (s.hearing) { b.textContent = 'RX'; b.className = 'badge rx'; } else { b.textContent = 'IDLE'; b.className = 'badge'; }
  $('caller').textContent = s.hearing || s.transmitting ? (s.caller || '') : '';
}
function renderMeter() {
  const d = S.status.rssi; const ok = d != null && d > -200;
  const pct = ok ? Math.max(0, Math.min(100, (d + 125) / 75 * 100)) : 0;
  $('smeterFill').style.width = pct + '%';
  if (!ok) { $('smeterText').textContent = '— dBm'; return; }
  const sU = d >= -73 ? 'S9+' + Math.round(d + 73) : 'S' + Math.max(0, Math.min(9, Math.round(9 - (-73 - d) / 6)));
  $('smeterText').textContent = sU + '  ' + d + ' dBm';
}
async function loadHistory() { try { const j = await api('history?limit=150'); S.history = j.lines; renderHistory(); } catch (e) { } }
function renderHistory() { const h = $('history'); h.innerHTML = S.history.slice().reverse().map(l => '<div>' + esc(l) + '</div>').join('') || '<div class="empty">Nothing on this channel yet</div>'; }
function addHistory(line) { if (S.history[S.history.length - 1] === line) return; S.history.push(line); if (S.history.length > 300) S.history.shift(); renderHistory(); }
function renderCaption(d) {
  $('captionState').textContent = d.enabled ? 'CAPTIONS ON' : '';
  setTxt(d.enabled);
  if (d.sentence) addCaptionLine({ ts: Date.now(), channelName: (S.status.channel || {}).name || '', text: d.sentence.replace(/^\u{1F4DD}\s*/u, '') });
  const c = $('caption'); if (d.enabled && d.live) { c.textContent = d.live; c.classList.remove('hidden'); } else c.classList.add('hidden');
}
async function loadZones() {
  try {
    const j = await api('channels'); S.channels = j.channels; S.zones = j.zones;
    const z = $('zoneSel'); z.innerHTML = j.zones.map(x => '<option value="' + x.id + '">Zone: ' + esc(x.name) + '</option>').join(''); z.value = String(j.zoneId); z.dataset.loaded = '1';
  } catch (e) { }
}
$('chUp').onclick = () => act('channel/step', { delta: 1 });
$('chDown').onclick = () => act('channel/step', { delta: -1 });
$('scanBtn').onclick = () => act('scan', {});
$('monBtn').onclick = () => act('monitor', { on: !S.status.monitor });
$('recBtn').onclick = () => act('record', { on: !S.status.record });
$('sqBtn').onclick = () => act('softsq', { on: !S.status.softSq });
$('sqLevel').oninput = () => { $('sqVal').textContent = $('sqLevel').value; };
$('sqLevel').onchange = () => act('softsq', { level: +$('sqLevel').value });
$('zoneSel').onchange = async () => { await act('zone', { id: +$('zoneSel').value }); loadZones(); if (S.page === 'channels') loadChannels(); };   // the Channels page has its own copy (chZone)

// PTT: hold the button (mouse/touch) or the space bar; always release on leave/blur so the radio never stays keyed
let pttDown = false;
async function ptt(down) {
  if (TALK.usable()) return talkPtt(down);                                // https: this computer's microphone (talk.js)
  if (down === pttDown) return; pttDown = down; $('ptt').classList.toggle('down', down);
  const j = await act('ptt', { down }); if (down && !j) { pttDown = false; $('ptt').classList.remove('down'); }
}
const pb = $('ptt');
pb.addEventListener('pointerdown', e => { if (!pb.disabled) { pb.setPointerCapture(e.pointerId); ptt(true); } });
['pointerup', 'pointercancel', 'lostpointercapture'].forEach(t => pb.addEventListener(t, () => ptt(false)));
document.addEventListener('keydown', e => { if (e.code === 'Space' && !e.repeat && S.page === 'intercom' && !/INPUT|SELECT|TEXTAREA/.test(document.activeElement.tagName) && !pb.disabled) { e.preventDefault(); ptt(true); } });
document.addEventListener('keyup', e => { if (e.code === 'Space') ptt(false); });
window.addEventListener('blur', () => ptt(false));
document.addEventListener('visibilitychange', () => { if (document.hidden) ptt(false); });

// ---- mode bar ----
function renderModebar() {
  const s = S.status; const sat = s.sat || {}; const m = s.mode || {}; let t = '', href = '#intercom';
  if (sat.tracking) {
    const what = sat.mode === 2 ? 'ISS SSTV' : sat.mode === 1 ? 'ISS APRS' : (sat.name || 'Satellite');
    t = sat.waiting ? what + '  ·  next pass ' + hhmm(sat.aos) : what + '  ·  listening ' + mhz(sat.rxHz) + (sat.el != null ? '  ·  ' + Math.round(sat.el) + '°' : '');
    href = '#sat';
  }
  if (m.aprs) { t = (t ? t + '   |   ' : '') + 'APRS monitoring'; if (!sat.tracking) href = '#aprs'; }
  if (m.sstv) { t = (t ? t + '   |   ' : '') + 'SSTV listening'; if (!sat.tracking) href = '#sstv'; }
  if (m.parrot) { t = (t ? t + '   |   ' : '') + 'Parrot repeater'; }
  $('modebar').classList.toggle('hidden', !t); $('modeText').textContent = t; $('modeOpen').href = href;
}

// ---- channels ----
async function loadChannels() {
  try {
    const j = await api('channels'); S.channels = j.channels; S.zones = j.zones;
    const z = $('chZone'); z.innerHTML = j.zones.map(x => '<option value="' + x.id + '">Zone: ' + esc(x.name) + '</option>').join(''); z.value = String(j.zoneId);
    renderChannels();
  } catch (e) { }
}
S.chFilter = 0;    // 0 all, 1 favourites, 2 analog, 3 DMR (as on the phone)
function renderChannels() {
  const q = $('chSearch').value.trim().toLowerCase(); const cur = (S.status.channel || {}).number; const f = S.chFilter;
  const rows = S.channels.filter(c => (!q || (c.name || '').toLowerCase().includes(q) || mhz(c.rxFreq).includes(q) || String(c.number) === q)
    && (f === 0 || (f === 1 && c.fav) || (f === 2 && !c.digital) || (f === 3 && c.digital)));
  $('chList').innerHTML = rows.map(c => '<div class="item click' + (c.number === cur ? ' cur' : '') + '" data-n="' + c.number + '"><span class="n">' + c.number + '</span><div class="main"><div>' + esc(c.name || '—') + '</div><div class="sub mono">' + mhz(c.rxFreq) + ' MHz · ' + (c.digital ? 'DMR CC' + c.cc : 'FM') + '</div></div>'
    + '<button type="button" class="star' + (c.fav ? ' on' : '') + '" data-star="' + c.number + '" aria-label="' + (c.fav ? 'Remove from favourites' : 'Add to favourites') + '" title="' + (c.fav ? 'Remove from ★ Favourites' : 'Add to ★ Favourites') + '">' + (c.fav ? '★' : '☆') + '</button>'
    + '<button type="button" class="act" data-edit="' + c.number + '">Edit</button></div>').join('') || '<div class="empty">' + (f === 1 ? 'No favourites in this zone: tap a ☆ to star a channel' : 'No channels') + '</div>';
}
$('chZone').onchange = async () => { await act('zone', { id: +$('chZone').value }); loadZones(); loadChannels(); };
$('chFilter').onclick = e => { const b = e.target.closest('button'); if (!b) return; S.chFilter = +b.dataset.f; $('chFilter').querySelectorAll('button').forEach(x => x.classList.toggle('on', x === b)); renderChannels(); };
$('chSearch').oninput = renderChannels;
$('chList').onclick = e => {
  const ed = e.target.closest('[data-edit]'); if (ed) { openEditor(+ed.dataset.edit); return; }
  const st = e.target.closest('[data-star]'); if (st) { const n = +st.dataset.star, ch = S.channels.find(c => c.number === n); act('channel/star', { number: n, on: !(ch && ch.fav) }).then(() => { loadChannels(); loadZones(); if (S.page === 'channels') loadZonesEditor(); }); return; }
  const it = e.target.closest('.item'); if (it) act('channel/select', { number: +it.dataset.n });
};

// ---- APRS ----
async function loadAprs() {
  try {
    const [l, st] = await Promise.all([api('aprs/log?limit=200'), api('aprs/stations?limit=200')]);
    S.aprsLog = l.log; S.stations = st.stations; renderAprs();
  } catch (e) { }
}
function renderAprs() {
  const heard = e => !/-tx$/.test(e.kind) && e.kind !== 'beacon' && !/^is-/.test(e.kind);
  const forYou = S.aprsLog.filter(e => e.mine && e.kind === 'msg').length;
  $('aprsCount').textContent = S.aprsLog.filter(heard).length; $('stationCount').textContent = S.stations.length;
  $('forYou').textContent = forYou; $('forYou').style.color = forYou ? 'var(--amber)' : '';
  $('aprsLog').innerHTML = S.aprsLog.map(e => '<div class="item' + (e.mine ? ' cur' : '') + '"><span class="t">' + hhmmss(e.ts) + '</span><div class="main"><span class="' + (heard(e) ? 'pk-from' : 'pk-mine') + '">' + esc(e.from) + '</span> › ' + esc(e.to) + '<div class="sub">' + esc(e.text) + '</div></div></div>').join('') || '<div class="empty">No packets yet</div>';
  $('stations').innerHTML = S.stations.map(s => '<div class="item"><div class="main"><b class="pk-from">' + esc(s.call) + '</b>' + (s.lat != null ? ' <span class="sub mono">' + s.lat.toFixed(3) + ', ' + s.lon.toFixed(3) + '</span>' : '') + '<div class="sub">' + esc(s.comment) + (s.via ? ' · via ' + esc(s.via) : '') + '</div></div><span class="t">' + ago(s.lastTs) + ' · ' + s.count + '×</span></div>').join('') || '<div class="empty">No stations yet</div>';
}
function renderAprsState() {
  const m = (S.status && S.status.mode) || {}; const on = !!m.aprs;
  const c = $('aprsState'); c.textContent = on ? 'MONITORING' : 'OFF'; c.className = 'chip ' + (on ? 'green' : 'dim');
  $('aprsToggle').textContent = on ? 'Stop monitoring' : 'Monitor 144.390';
  $('beaconBtn').disabled = $('msgForm').querySelector('button').disabled = !(S.status && S.status.webTx);
  $('msgNote').textContent = S.status && S.status.webTx ? '' : 'Sending needs “Allow transmit from the web” on the phone (Device → SignalDeck Web).';
}
$('aprsToggle').onclick = () => act('aprs/monitor', { on: !(S.status.mode || {}).aprs });
$('beaconBtn').onclick = () => act('aprs/beacon', {});
$('msgForm').addEventListener('submit', async e => { e.preventDefault(); const j = await act('aprs/message', { to: $('msgTo').value, text: $('msgText').value }); if (j) $('msgText').value = ''; });

// ---- SSTV ----
async function loadSstv() {
  refreshLive();
  try {
    const j = await api('sstv/pictures'); S.pictures = j.pictures;
    $('gallery').innerHTML = j.pictures.map(p => { const u = '/api/sstv/picture?name=' + encodeURIComponent(p.name); return '<a href="' + u + '" target="_blank" rel="noopener"><img loading="lazy" src="' + u + '" alt=""><span>' + new Date(p.ts).toLocaleString() + '</span></a>'; }).join('') || '<div class="empty">No pictures yet</div>';
  } catch (e) { }
}
function refreshLive() {
  const s = S.status.sstv || {}; const img = $('sstvLive');
  if (!s.picture) { img.classList.add('hidden'); $('sstvEmpty').classList.remove('hidden'); return; }
  const n = new Image(); n.onload = () => { img.src = n.src; img.classList.remove('hidden'); $('sstvEmpty').classList.add('hidden'); }; n.src = '/api/sstv/live.png?t=' + Date.now();
}
function renderSstvState() {
  const s = (S.status && S.status.sstv) || {}; const c = $('sstvState');
  c.textContent = s.on ? (s.status || 'LISTENING').toUpperCase() : 'OFF'; c.className = 'chip ' + (s.on ? 'green' : 'dim');
  $('sstvToggle').textContent = s.on ? 'Stop listening' : 'Listen on 144.500';
}
$('sstvToggle').onclick = () => act('sstv/monitor', { on: !(S.status.sstv || {}).on });

// ---- satellites ----
function renderSat() {
  const sat = (S.status && S.status.sat) || {}; const c = $('satCard');
  if (!sat.tracking) { c.innerHTML = '<div class="big">NOT TRACKING</div><p class="muted">Choose ISS APRS or ISS SSTV below to follow every pass.</p>'; return; }
  const what = sat.mode === 2 ? 'ISS SSTV' : sat.mode === 1 ? 'ISS APRS' : esc(sat.name);
  const f = (k, v) => '<div><span>' + k + '</span><b>' + v + '</b></div>';
  c.innerHTML = '<div class="big">' + what + (sat.waiting ? ' · WAITING FOR THE PASS' : ' · LISTENING') + '</div><div class="grid">'
    + (sat.waiting ? f('NEXT PASS', hhmm(sat.aos)) + f('ENDS', hhmm(sat.los)) : f('TUNED', mhz(sat.rxHz) + ' MHz') + f('ELEVATION', sat.el != null ? Math.round(sat.el) + '°' : '—') + f('AZIMUTH', sat.az != null ? Math.round(sat.az) + '°' : '—') + f('RANGE', sat.rangeKm != null ? Math.round(sat.rangeKm) + ' km' : '—') + f('LOSS OF SIGNAL', hhmm(sat.los)))
    + f('HIGHEST', Math.round(sat.maxEl) + '°') + f('NOMINAL', mhz(sat.nominalHz) + ' MHz') + '</div>';
}
document.querySelectorAll('[data-iss]').forEach(b => b.onclick = () => act('iss', { mode: b.dataset.iss }).then(refresh));

// start() runs at the end of pages.js, once every page's code is loaded
