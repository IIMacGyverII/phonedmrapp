// SignalDeck Web: Messages, Contacts, Map and Help pages (loaded after app.js, which holds the shared helpers).
'use strict';

// ---- messages ----
const TYPE_NAMES = ['Private', 'Group', 'All call'];
S.thread = null; S.contacts = []; S.conversations = [];
async function loadConversations() {
  try {
    const j = await api('conversations'); S.conversations = j.conversations;
    $('convList').innerHTML = j.conversations.map(c => '<div class="item click' + (S.thread && S.thread.peer === c.peer && S.thread.type === c.type ? ' cur' : '') + '" data-peer="' + c.peer + '" data-type="' + c.type + '"><div class="main"><b>' + esc(c.name || ((c.type === 1 ? 'TG ' : 'ID ') + c.peer)) + '</b>' + (c.name ? ' <span class="sub">' + (c.type === 1 ? 'TG ' : '') + c.peer + '</span>' : '') + '<div class="sub">' + (c.outgoing ? 'You: ' : '') + esc(c.lastText) + '</div></div><span class="t">' + ago(c.lastTs) + '</span></div>').join('') || '<div class="empty">No texts yet</div>';
    $('quick').innerHTML = j.quickReplies.map(q => '<button type="button">' + esc(q) + '</button>').join('');
    loadThread();
  } catch (e) { }
  renderSendState();
}
async function loadThread() {
  const t = S.thread; if (!t) { $('thread').innerHTML = '<div class="empty">Choose a conversation on the left</div>'; return; }
  $('threadTitle').textContent = String(t.name || t.peer);
  $('threadSub').textContent = TYPE_NAMES[t.type] + ' · ' + t.peer;
  try {
    const j = await api('messages?peer=' + t.peer + '&type=' + t.type);
    const st = m => !m.outgoing ? '' : m.status === 0 ? 'sending…' : m.status === 1 ? 'delivered' : m.status === 2 ? 'failed' : 'sent (no acknowledgement)';
    $('thread').innerHTML = j.messages.map(m => '<div class="bubble' + (m.outgoing ? ' out' : '') + '">' + esc(m.text) + '<span class="meta' + (m.status === 2 ? ' fail' : '') + '">' + new Date(m.ts).toLocaleString() + (m.outgoing ? ' · ' + st(m) : '') + '</span></div>').join('') || '<div class="empty">No texts with ' + esc(t.name || t.peer) + ' yet</div>';
    $('thread').scrollTop = 1e9;
  } catch (e) { }
}
function openThread(peer, type, name) { S.thread = { peer, type, name }; if (location.hash !== '#messages') location.hash = 'messages'; else loadConversations(); }
function renderSendState() {
  const ok = S.status && S.status.webTx;
  $('sendForm').querySelector('button').disabled = !ok || !S.thread;
  $('sendNote').textContent = !ok ? 'Sending needs “Allow transmit from the web” on the phone (Device → SignalDeck Web).' : !S.thread ? 'Choose a conversation, or New to text a contact.' : '';
}
$('convList').onclick = e => { const it = e.target.closest('.item'); if (!it) return; const c = S.conversations.find(x => x.peer === +it.dataset.peer && x.type === +it.dataset.type); if (c) openThread(c.peer, c.type, c.name); };
$('quick').onclick = e => { if (e.target.tagName === 'BUTTON') { $('sendText').value = e.target.textContent; $('sendText').focus(); } };
$('sendForm').addEventListener('submit', async e => {
  e.preventDefault(); if (!S.thread) return;
  const j = await act('messages', { peer: S.thread.peer, type: S.thread.type, text: $('sendText').value });
  if (j) { $('sendText').value = ''; setTimeout(loadThread, 500); }
});
$('newMsg').onclick = () => { location.hash = 'contacts'; toast('Pick a contact, then Text'); };

// ---- contacts ----
S.editing = null;
async function loadContacts() { try { const j = await api('contacts'); S.contacts = j.contacts; renderContacts(); } catch (e) { } }
function renderContacts() {
  const q = $('ctSearch').value.trim().toLowerCase();
  const rows = S.contacts.filter(c => !q || c.name.toLowerCase().includes(q) || String(c.number).includes(q));
  $('ctList').innerHTML = rows.map(c => '<div class="item click' + (S.editing && S.editing.id === c.id ? ' cur' : '') + '" data-id="' + c.id + '"><div class="main"><b>' + esc(c.name || '—') + '</b><div class="sub mono">' + (c.type === 1 ? 'TG ' : c.type === 2 ? 'ALL ' : 'ID ') + c.number + '</div></div><span class="chip dim">' + TYPE_NAMES[c.type].toUpperCase() + '</span></div>').join('') || '<div class="empty">No contacts</div>';
}
function editContact(c) {
  S.editing = c || null; $('ctFormTitle').textContent = c ? 'EDIT CONTACT' : 'NEW CONTACT';
  $('ctName').value = c ? c.name : ''; $('ctNumber').value = c ? c.number : ''; $('ctType').value = c ? c.type : 0;
  $('ctDel').classList.toggle('hidden', !c); $('ctText').classList.toggle('hidden', !c); renderContacts();
}
$('ctSearch').oninput = renderContacts;
$('ctList').onclick = e => { const it = e.target.closest('.item'); if (it) editContact(S.contacts.find(c => c.id === +it.dataset.id)); };
$('ctNew').onclick = () => editContact(null);
$('ctForm').addEventListener('submit', async e => {
  e.preventDefault();
  const j = await act('contacts', { id: S.editing ? S.editing.id : 0, name: $('ctName').value, number: +$('ctNumber').value, type: +$('ctType').value });
  if (j) { await loadContacts(); if (!S.editing) editContact(null); }
});
$('ctDel').onclick = async () => {
  if (!S.editing || !confirm('Delete ' + (S.editing.name || S.editing.number) + '?')) return;
  if (await act('contacts/delete', { id: S.editing.id })) { editContact(null); loadContacts(); }
};
$('ctText').onclick = () => { const c = S.editing; if (c) openThread(c.number, c.type, c.name); };

// ---- map: OpenStreetMap tiles (darkened like the phone's map), Web Mercator, drag / wheel / buttons ----
const M = { z: 9, lat: 0, lon: 0, fitted: false, marks: [] };
const TS = 256;
const wx = (lon, z) => (lon + 180) / 360 * TS * 2 ** z;
const wy = (lat, z) => { const r = lat * Math.PI / 180; return (1 - Math.log(Math.tan(r) + 1 / Math.cos(r)) / Math.PI) / 2 * TS * 2 ** z; };
const lonOf = (x, z) => x / (TS * 2 ** z) * 360 - 180;
const latOf = (y, z) => { const n = Math.PI - 2 * Math.PI * y / (TS * 2 ** z); return 180 / Math.PI * Math.atan(Math.sinh(n)); };
async function loadMap() {
  try {
    const [st, ch] = await Promise.all([api('aprs/stations?limit=500'), api('channels')]);
    M.marks = [];
    for (const s of st.stations) if (s.lat != null) M.marks.push({ kind: 'aprs', lat: s.lat, lon: s.lon, name: s.call, s });
    for (const c of ch.channels) if (c.lat != null) M.marks.push({ kind: 'ch', lat: c.lat, lon: c.lon, name: c.name || ('Channel ' + c.number), c });
    $('mapCount').textContent = M.marks.filter(m => m.kind === 'aprs').length + ' STATIONS · ' + M.marks.filter(m => m.kind === 'ch').length + ' CHANNELS';
    if (!M.fitted) { M.fitted = true; fitMap(); } else drawMap();
  } catch (e) { }
}
function visibleMarks() { return M.marks.filter(m => (m.kind === 'aprs' ? $('mapAprs').checked : $('mapCh').checked)); }
function fitMap() {
  const v = visibleMarks(); const el = $('map'); const W = el.clientWidth || 800, H = el.clientHeight || 500;
  if (!v.length) { M.lat = 39.8; M.lon = -98.6; M.z = 4; drawMap(); return; }
  const lat0 = Math.min(...v.map(m => m.lat)), lat1 = Math.max(...v.map(m => m.lat)), lon0 = Math.min(...v.map(m => m.lon)), lon1 = Math.max(...v.map(m => m.lon));
  let z = 14; while (z > 2 && (wx(lon1, z) - wx(lon0, z) > W - 80 || wy(lat0, z) - wy(lat1, z) > H - 80)) z--;
  M.z = z; M.lat = (lat0 + lat1) / 2; M.lon = (lon0 + lon1) / 2; drawMap();
}
function drawMap() {
  const el = $('map'); const W = el.clientWidth, H = el.clientHeight; if (!W) return;
  const cx = wx(M.lon, M.z), cy = wy(M.lat, M.z), x0 = cx - W / 2, y0 = cy - H / 2, n = 2 ** M.z;
  let html = '';
  for (let ty = Math.floor(y0 / TS); ty <= Math.floor((y0 + H) / TS); ty++) {
    if (ty < 0 || ty >= n) continue;
    for (let tx = Math.floor(x0 / TS); tx <= Math.floor((x0 + W) / TS); tx++) {
      const tw = ((tx % n) + n) % n;
      html += '<img alt="" src="https://tile.openstreetmap.org/' + M.z + '/' + tw + '/' + ty + '.png" style="left:' + Math.round(tx * TS - x0) + 'px;top:' + Math.round(ty * TS - y0) + 'px">';
    }
  }
  $('mapTiles').innerHTML = html;
  $('mapMarks').innerHTML = visibleMarks().map(m => {
    const x = wx(m.lon, M.z) - x0, y = wy(m.lat, M.z) - y0; if (x < -40 || y < -40 || x > W + 40 || y > H + 40) return '';
    return '<div class="mk ' + m.kind + '" data-i="' + M.marks.indexOf(m) + '" style="left:' + x + 'px;top:' + y + 'px" title="' + esc(m.name) + '"></div>'
      + (M.z >= 9 ? '<div class="mk-label" style="left:' + x + 'px;top:' + y + 'px">' + esc(m.name) + '</div>' : '');
  }).join('');
}
function showMark(m) {
  const c = $('mapCard'); let h;
  if (m.kind === 'aprs') {
    const s = m.s;
    h = '<b class="pk-from">' + esc(s.call) + '</b> <span class="sub">' + ago(s.lastTs) + ' · heard ' + s.count + '×</span><div>' + esc(s.comment) + '</div><div class="sub mono">' + s.lat.toFixed(4) + ', ' + s.lon.toFixed(4)
      + (s.speedKmh != null ? ' · ' + Math.round(s.speedKmh) + ' km/h' : '') + (s.course != null ? ' · ' + s.course + '°' : '') + (s.alt ? ' · ' + s.alt + ' m' : '') + (s.via ? ' · via ' + esc(s.via) : '') + '</div>';
  } else {
    const ch = m.c;
    h = '<b>' + esc(m.name) + '</b> <span class="sub mono">' + mhz(ch.rxFreq) + ' MHz</span><div class="sub">' + esc(ch.location) + '</div><button class="btn small-btn" id="mapTune">Tune channel ' + ch.number + '</button>';
  }
  c.innerHTML = h; c.classList.remove('hidden');
  const b = $('mapTune'); if (b) b.onclick = () => act('channel/select', { number: m.c.number });
}
(function () {
  const el = $('map'); let drag = null;
  el.addEventListener('pointerdown', e => {
    if (e.target.closest('.zoom,.mapcard,.attrib')) return;
    const mk = e.target.closest('.mk'); if (mk) { showMark(M.marks[+mk.dataset.i]); return; }
    drag = { x: e.clientX, y: e.clientY, cx: wx(M.lon, M.z), cy: wy(M.lat, M.z), moved: false }; el.setPointerCapture(e.pointerId); el.classList.add('drag');
  });
  el.addEventListener('pointermove', e => {
    if (!drag) return; const dx = e.clientX - drag.x, dy = e.clientY - drag.y; if (Math.abs(dx) + Math.abs(dy) > 3) drag.moved = true;
    M.lon = lonOf(drag.cx - dx, M.z); M.lat = Math.max(-85, Math.min(85, latOf(drag.cy - dy, M.z))); drawMap();
  });
  const end = () => { if (drag && !drag.moved) $('mapCard').classList.add('hidden'); drag = null; el.classList.remove('drag'); };
  el.addEventListener('pointerup', end); el.addEventListener('pointercancel', end);
  const zoomAt = (dz, px, py) => {
    const z = Math.max(2, Math.min(18, M.z + dz)); if (z === M.z) return;
    const W = el.clientWidth, H = el.clientHeight; if (px == null) { px = W / 2; py = H / 2; }
    const alon = lonOf(wx(M.lon, M.z) - W / 2 + px, M.z), alat = latOf(wy(M.lat, M.z) - H / 2 + py, M.z);
    M.z = z; M.lon = lonOf(wx(alon, z) - px + W / 2, z); M.lat = latOf(wy(alat, z) - py + H / 2, z); drawMap();
  };
  el.addEventListener('wheel', e => { e.preventDefault(); const r = el.getBoundingClientRect(); zoomAt(e.deltaY < 0 ? 1 : -1, e.clientX - r.left, e.clientY - r.top); }, { passive: false });
  $('zIn').onclick = () => zoomAt(1); $('zOut').onclick = () => zoomAt(-1);
  $('mapFit').onclick = fitMap; $('mapAprs').onchange = drawMap; $('mapCh').onchange = drawMap;
  window.addEventListener('resize', () => { if (S.page === 'map') drawMap(); });
})();

// ---- satellite passes ----
const COMPASS = ['N', 'NNE', 'NE', 'ENE', 'E', 'ESE', 'SE', 'SSE', 'S', 'SSW', 'SW', 'WSW', 'W', 'WNW', 'NW', 'NNW'];
const compass = az => COMPASS[Math.round(((az % 360) + 360) % 360 / 22.5) % 16];
async function loadPasses() {
  try {
    const j = await api('sat/passes'); S.sats = j.satellites;
    $('passNote').textContent = !j.hasFix ? 'NO POSITION FIX ON THE PHONE' : j.elementsAgeH > 72 ? 'ORBITS ' + Math.round(j.elementsAgeH / 24) + ' DAYS OLD' : '';
    const now = Date.now(); const day = ts => new Date(ts).toLocaleDateString([], { weekday: 'short' }) + ' ' + hhmm(ts);
    $('passList').innerHTML = j.satellites.map((s, si) => '<div class="satbox"><h4>' + esc(s.name) + '</h4><div class="about">'
      + (s.listenOnly ? 'Listen ' + mhz(s.downHz) + ' MHz (receive only)' : 'Listen ' + mhz(s.downHz) + ', talk ' + mhz(s.upHz) + ' MHz' + (s.toneHz > 0 ? ' with ' + s.toneHz.toFixed(1) + ' Hz' : ''))
      + '. ' + esc(s.about) + '</div>'
      + (s.problem ? '<div class="empty">' + esc(s.problem) + '</div>' : s.passes.length ? s.passes.map(p => '<div class="pass' + (p.aos <= now ? ' up' : '') + '" data-s="' + si + '" data-aos="' + p.aos + '"><div><b>' + (p.aos <= now ? 'Up now' : day(p.aos)) + '</b><div class="sub">rises ' + compass(p.aosAz) + ', sets ' + compass(p.losAz) + ' · ' + Math.round((p.los - p.aos) / 60000) + ' min</div></div><span class="chip">' + Math.round(p.maxEl) + '°</span></div>').join('') : '<div class="empty">No pass above 10° in the next 24 hours</div>')
      + '</div>').join('');
  } catch (e) { }
}
$('passList').onclick = async e => {
  const p = e.target.closest('.pass'); if (!p) return; const s = S.sats[+p.dataset.s];
  const sat = S.status.sat || {};
  if (sat.tracking && !confirm('Track this ' + s.name + ' pass instead? It replaces the current tracking' + (sat.repeat >= 0 ? ' (which follows every ISS pass)' : '') + '.')) return;
  await act('sat/track', { key: s.key, aos: +p.dataset.aos }); refresh();
};

// ---- logbook ----
S.qso = null;
async function loadLog() {
  try {
    const j = await api('logbook?limit=500' + ($('logQso').checked ? '&qso=1' : '')); S.log = j.entries;
    $('logCount').textContent = j.qsos + ' CONTACTS · ' + j.total + ' ENTRIES';
    $('logList').innerHTML = j.entries.map(e => '<div class="item click' + (S.qso && S.qso.id === e.id ? ' cur' : '') + '" data-id="' + e.id + '"><span class="t">' + new Date(e.ts).toLocaleDateString() + '<br>' + hhmm(e.ts) + '</span><div class="main"><b class="pk-from">' + esc(e.call) + '</b> ' + (e.name ? esc(e.name) + ' ' : '') + '<span class="sub mono">' + (e.freqHz ? mhz(e.freqHz) + ' MHz ' : '') + esc(e.mode) + (e.band ? ' · ' + esc(e.band) : '') + '</span><div class="sub">' + (e.qso ? 'Contact' : 'Heard') + (e.rstSent || e.rstRcvd ? ' · sent ' + esc(e.rstSent || '—') + ' rcvd ' + esc(e.rstRcvd || '—') : '') + (e.grid ? ' · ' + esc(e.grid) : '') + (e.notes ? ' · ' + esc(e.notes) : '') + '</div></div></div>').join('') || '<div class="empty">Nothing logged yet</div>';
  } catch (e) { }
}
function editQso(e) {
  S.qso = e || null; $('qsoTitle').textContent = e ? 'EDIT ENTRY' : 'LOG A CONTACT';
  const ch = (S.status && S.status.channel) || {};
  $('qCall').value = e ? e.call : ''; $('qFreq').value = e ? (e.freqHz ? (e.freqHz / 1e6).toFixed(4) : '') : (ch.rxFreq ? (ch.rxFreq / 1e6).toFixed(4) : '');
  $('qMode').value = e ? e.mode : (ch.digital ? 'DMR' : 'FM'); $('qSent').value = e ? e.rstSent : ''; $('qRcvd').value = e ? e.rstRcvd : '';
  $('qName').value = e ? e.name : ''; $('qNotes').value = e ? e.notes : ''; $('qDel').classList.toggle('hidden', !e);
}
$('logList').onclick = e => { const it = e.target.closest('.item'); if (it) { editQso(S.log.find(x => x.id === +it.dataset.id)); loadLog(); } };
$('logQso').onchange = loadLog;
$('qClear').onclick = () => { editQso(null); loadLog(); };
$('qDel').onclick = async () => { if (S.qso && confirm('Delete this entry for ' + S.qso.call + '?') && await act('logbook/delete', { id: S.qso.id })) { editQso(null); loadLog(); } };
$('qsoForm').addEventListener('submit', async e => {
  e.preventDefault();
  const body = { id: S.qso ? S.qso.id : 0, call: $('qCall').value, mode: $('qMode').value, rstSent: $('qSent').value, rstRcvd: $('qRcvd').value, name: $('qName').value, notes: $('qNotes').value, qso: true };
  const f = parseFloat($('qFreq').value); if (!isNaN(f)) body.freqMHz = f;
  if (await act('logbook', body)) { editQso(null); loadLog(); }
});

// ---- recordings ----
async function loadRecordings() {
  try {
    const j = await api('recordings'); S.recs = j.recordings;
    $('recList').innerHTML = j.recordings.map((r, i) => '<div class="item" data-i="' + i + '"><span class="t">' + new Date(r.ts).toLocaleDateString() + '<br>' + hhmmss(r.ts) + '</span><div class="main"><b>' + esc(r.channel) + '</b><div class="sub mono">' + esc(r.name) + ' · ' + r.seconds.toFixed(1) + ' s</div></div>'
      + '<button class="act" data-play="' + i + '">▶ Play</button><a class="act" href="/api/recording?download=1&id=' + encodeURIComponent(r.id) + '">Download</a><button class="act" data-del="' + i + '">Delete</button></div>').join('') || '<div class="empty">No recordings yet. Turn REC on at the intercom.</div>';
  } catch (e) { }
}
$('recList').onclick = async e => {
  const p = e.target.closest('[data-play]'), d = e.target.closest('[data-del]');
  if (p) { const r = S.recs[+p.dataset.play]; const pl = $('player'); pl.src = '/api/recording?id=' + encodeURIComponent(r.id); pl.play().catch(() => {}); document.querySelectorAll('#recList .item').forEach(x => x.classList.toggle('playing', x.dataset.i === p.dataset.play)); }
  if (d) { const r = S.recs[+d.dataset.del]; if (confirm('Delete ' + r.name + '?') && await act('recording/delete', { id: r.id })) loadRecordings(); }
};

// ---- help: the phone's guide ----
S.help = null;
async function loadHelp() {
  if (!S.help) { try { S.help = (await api('help')).topics; } catch (e) { return; } }
  renderHelpList(); if (!$('helpBody').innerHTML) showTopic(0);
}
function renderHelpList() {
  const q = $('helpSearch').value.trim().toLowerCase(); let html = '', group = null;
  S.help.forEach((t, i) => {
    const hit = !q || (t.title + ' ' + t.summary + ' ' + t.sections.map(x => x.head + ' ' + x.text).join(' ')).toLowerCase().includes(q);
    if (!hit) return;
    if (t.group !== group) { group = t.group; html += '<div class="group">' + esc(group).toUpperCase() + '</div>'; }
    html += '<div class="item click" data-i="' + i + '"><div class="main"><b>' + esc(t.title) + '</b><div class="sub">' + esc(t.summary) + '</div></div></div>';
  });
  $('helpList').innerHTML = html || '<div class="empty">Nothing matches</div>';
}
function showTopic(i) {
  const t = S.help[i]; const q = $('helpSearch').value.trim().toLowerCase();
  $('helpBody').innerHTML = '<h2>' + esc(t.title) + '</h2><p class="lead">' + esc(t.summary) + '</p>'
    + t.sections.map(x => '<h3' + (q && (x.head + ' ' + x.text).toLowerCase().includes(q) ? ' class="hit"' : '') + '>' + esc(x.head) + '</h3><p>' + esc(x.text) + '</p>').join('');
  const h = $('helpBody').querySelector('.hit'); (h || $('helpBody')).scrollIntoView({ block: 'start', behavior: 'smooth' });
}
$('helpSearch').oninput = renderHelpList;
$('helpList').onclick = e => { const it = e.target.closest('.item'); if (it) showTopic(+it.dataset.i); };

start().catch(() => showLogin());
