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
    const [st, ch] = await Promise.all([api('aprs/stations?limit=500'), api('channels?all=1')]);   // the map shows every channel with a location, as the phone's map does
    M.marks = M.marks.filter(m => m.kind === 'rpt');
    for (const s of st.stations) if (s.lat != null) M.marks.push({ kind: 'aprs', lat: s.lat, lon: s.lon, name: s.call, s });
    for (const c of ch.channels) if (c.lat != null) M.marks.push({ kind: 'ch', lat: c.lat, lon: c.lon, name: c.name || ('Channel ' + c.number), c });
    $('mapCount').textContent = M.marks.filter(m => m.kind === 'aprs').length + ' STATIONS · ' + M.marks.filter(m => m.kind === 'ch').length + ' CHANNELS';
    if (!M.fitted) { M.fitted = true; fitMap(); } else drawMap();
  } catch (e) { }
}
function visibleMarks() { return M.marks.filter(m => (m.kind === 'aprs' ? $('mapAprs').checked : m.kind === 'rpt' ? $('mapRpt').checked : $('mapCh').checked)); }
/** Repeaters near the phone (the phone's catalog: RadioID, BrandMeister, Hearham) as a layer. */
async function loadRepeaterLayer(force, here) {
  M.marks = M.marks.filter(m => m.kind !== 'rpt');
  if (!$('mapRpt').checked) { drawMap(); return; }
  $('mapCount').textContent = 'LOOKING FOR REPEATERS…';
  try {
    const q = [force ? 'force=1' : '', here ? 'lat=' + here.lat.toFixed(5) + '&lon=' + here.lon.toFixed(5) : ''].filter(Boolean).join('&');
    const j = await api('repeaters' + (q ? '?' + q : ''));
    for (const r of j.repeaters) if (r.lat != null) M.marks.push({ kind: 'rpt', lat: r.lat, lon: r.lon, name: r.callsign + ' ' + mhz(r.rxHz), r });
    $('mapCount').textContent = M.marks.filter(m => m.kind === 'aprs').length + ' STATIONS · ' + M.marks.filter(m => m.kind === 'ch').length + ' CHANNELS · ' + j.repeaters.length + ' REPEATERS (' + j.radiusMi + ' MI ' + (j.around === 'map' ? 'AROUND THE MAP CENTRE' : 'AROUND THE PHONE') + ')';
    if (here && !j.repeaters.length) toast('No repeaters known within ' + j.radiusMi + ' miles of the middle of the map');
    if (j.status) toast(j.status);
  } catch (e) { toast(e.message); }
  drawMap();
}
async function showRepeater(m) {
  const r = m.r, c = $('mapCard');
  const off = r.txHz - r.rxHz;
  c.innerHTML = '<b style="color:var(--violet)">' + esc(r.callsign) + '</b> <span class="sub mono">' + mhz(r.rxHz) + ' MHz' + (off ? ' ' + (off > 0 ? '+' : '−') + (Math.abs(off) / 1e6).toFixed(3) : ' simplex') + '</span>'
    + '<div class="sub">' + [r.fm ? 'FM' + (r.toneUp ? ' tone ' + esc(r.toneUp) : '') : '', r.dmr ? 'DMR' + (r.cc >= 0 ? ' CC' + r.cc : '') + (r.network ? ' ' + esc(r.network) : '') : '', esc([r.city, r.region].filter(Boolean).join(', ')), r.distanceKm != null ? (r.distanceKm / 1.609344).toFixed(1) + ' mi' : '', r.approx ? 'approximate position' : ''].filter(Boolean).join(' · ') + '</div>'
    + (r.dmr ? '<div class="tgs" id="rptTgs"><span class="sub">Loading talkgroups…</span></div>' : '')
    + '<button class="btn small-btn" id="rptAdd">Add to my channels</button> <button class="btn small-btn" id="rptCov">Coverage</button>';
  showCard();
  $('rptCov').onclick = () => focusCoverage({ hz: r.rxHz, lat: m.lat, lon: m.lon, name: r.callsign });
  if (r.dmr) {
    try {
      const t = await api('repeaters/talkgroups?key=' + encodeURIComponent(r.key));
      $('rptTgs').innerHTML = t.talkgroups.length ? t.talkgroups.map(g => '<label class="chk"><input type="checkbox" value="' + g.id + '"> TG ' + g.id + (g.name ? ' ' + esc(g.name) : '') + ' · TS' + g.slot + '</label>').join('') : '<span class="sub">No talkgroups listed: the plan uses the repeater\'s defaults</span>';
    } catch (e) { $('rptTgs').textContent = e.message; }
  }
  $('rptAdd').onclick = async () => {
    const talk = [...c.querySelectorAll('#rptTgs input:checked')].map(i => +i.value);
    try {
      const p = await api('repeaters/add', { key: r.key, talk });
      if (!confirm('Add ' + r.callsign + '?\n\n' + p.preview)) return;
      await act('repeaters/add', { key: r.key, talk, confirm: true }); loadChannels();
    } catch (e) { toast(e.message); }
  };
}
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
      html += '<img alt="" referrerpolicy="origin" src="https://tile.openstreetmap.org/' + M.z + '/' + tw + '/' + ty + '.png" style="left:' + Math.round(tx * TS - x0) + 'px;top:' + Math.round(ty * TS - y0) + 'px">';
    }
  }
  $('mapTiles').innerHTML = html;
  const sq = (c, attr, cls, min) => {
    const l = wx(c.w, M.z) - x0, r = wx(c.e, M.z) - x0, t = wy(c.n, M.z) - y0, b = wy(c.s, M.z) - y0;
    if (r < 0 || l > W || b < 0 || t > H) return '';
    return '<div class="' + cls + '" ' + attr + ' style="left:' + l + 'px;top:' + t + 'px;width:' + Math.max(min, r - l + 0.5) + 'px;height:' + Math.max(min, b - t + 0.5) + 'px;background:' + c.color + ';opacity:' + (c.alpha || .66) + '"></div>';
  };
  $('mapCells').innerHTML = (M.cells || []).map((c, i) => sq(c, 'data-c="' + i + '"', 'cov', 3)).join('');
  const cv = $('mapPredCv'), dpr = window.devicePixelRatio || 1;
  if (cv.width !== Math.round(W * dpr) || cv.height !== Math.round(H * dpr)) { cv.width = Math.round(W * dpr); cv.height = Math.round(H * dpr); cv.style.width = W + 'px'; cv.style.height = H + 'px'; }
  const g = cv.getContext('2d'); g.setTransform(dpr, 0, 0, dpr, 0, 0); g.clearRect(0, 0, W, H);
  for (const c of M.pred || []) {
    const l = wx(c.w, M.z) - x0, r = wx(c.e, M.z) - x0, t = wy(c.n, M.z) - y0, b = wy(c.s, M.z) - y0;
    if (r < 0 || l > W || b < 0 || t > H) continue;
    g.globalAlpha = c.alpha; g.fillStyle = c.color; g.fillRect(l, t, r - l + 0.5, b - t + 0.5);
  }
  g.globalAlpha = 1;
  $('mapMarks').innerHTML = visibleMarks().map(m => {
    const x = wx(m.lon, M.z) - x0, y = wy(m.lat, M.z) - y0; if (x < -40 || y < -40 || x > W + 40 || y > H + 40) return '';
    return '<div class="mk ' + m.kind + '" data-i="' + M.marks.indexOf(m) + '" style="left:' + x + 'px;top:' + y + 'px" title="' + esc(m.name) + '"></div>'
      + (M.z >= 9 ? '<div class="mk-label" style="left:' + x + 'px;top:' + y + 'px">' + esc(m.name) + '</div>' : '');
  }).join('');
}
/** The coverage layer: the phone's measured grid squares, coloured on the phone's own scale. */
let covSeq = 0;
/** Coverage for all repeaters, or for M.covFocus (one repeater: measured squares and its terrain prediction, polled while it runs). */
async function loadCoverage(fit) {
  const l = $('mapCov').value, seq = ++covSeq, note = $('mapCovNote'), f = M.covFocus;
  M.cells = []; M.pred = []; hideCard();
  if (!l) { note.classList.add('hidden'); drawMap(); return; }
  let q = 'coverage?layer=' + l;
  if (f) q += '&key=' + encodeURIComponent(f.key || '') + (f.hz ? '&hz=' + f.hz + '&lat=' + f.lat + '&lon=' + f.lon + '&name=' + encodeURIComponent(f.name || '') : '') + ($('mapPred').checked ? '&predict=1' : '');
  try {
    const j = await api(q); if (seq !== covSeq) return;
    M.cells = j.cells; M.pred = j.predicted || []; M.covLayer = l;
    if (f) { f.key = j.key; if (!f.name && j.name) f.name = j.name; if (f.lat == null && j.lat != null) { f.lat = j.lat; f.lon = j.lon; } }
    fillCovRepeaters(j.repeaters || [], f);
    const who = f ? '<b>' + esc(f.name || 'Repeater') + '</b>' : '<b>All repeaters</b> (the best one in each square)';
    let t = who + ' · ' + j.cells.length + ' measured ' + (j.cells.length === 1 ? 'square' : 'squares') + (l === 'tx' ? ' with key-ups' : ' heard');
    if (f && $('mapPred').checked) t += j.predictError ? ' · terrain prediction failed: ' + esc(j.predictError) : !j.predictDone ? ' · terrain prediction: ' + esc(j.predictStatus || 'starting…') : j.predictSummary ? ' · ' + esc(j.predictSummary) : '';
    if (!j.logging) t += ' · Coverage logging is off on the phone (Settings), so nothing new is measured';
    note.innerHTML = t; note.classList.remove('hidden');
    if (f && $('mapPred').checked && !j.predictDone && !j.predictError) setTimeout(() => { if (seq === covSeq && S.page === 'map') loadCoverage(fit && !M.pred.length); }, 2000);
    if (fit && (M.cells.length || M.pred.length || f)) fitCoverage();
  } catch (e) { toast(e.message); }
  drawMap();
}
function fillCovRepeaters(list, f) {
  const sel = $('mapCovRpt'); const key = f ? f.key : '';
  let h = '<option value="">All repeaters</option>' + list.map(x => '<option value="' + esc(x.key) + '">' + esc(x.name || mhz(x.rxHz)) + ' · ' + x.rx + ' heard · ' + x.tx + ' key-ups</option>').join('');
  if (f && key && !list.some(x => x.key === key)) h += '<option value="' + esc(key) + '">' + esc(f.name || 'Repeater') + ' (nothing measured yet)</option>';
  sel.innerHTML = h; sel.value = key || '';
}
/** One repeater's coverage (from its card, a channel's card or the list): signal heard if no layer is chosen yet. */
function focusCoverage(f) {
  M.covFocus = f; if (!$('mapCov').value) $('mapCov').value = 'rx';
  $('mapCard').classList.add('hidden'); loadCoverage(true);
}
function fitCoverage() {
  const all = [...(M.cells || []), ...(M.pred || [])]; const f = M.covFocus; const el = $('map'); const W = el.clientWidth || 800, H = el.clientHeight || 500;
  if (!all.length && !(f && f.lat != null)) return;
  let s = Math.min(...all.map(c => c.s), f && f.lat != null ? f.lat : 90), n = Math.max(...all.map(c => c.n), f && f.lat != null ? f.lat : -90);
  let w = Math.min(...all.map(c => c.w), f && f.lon != null ? f.lon : 180), e = Math.max(...all.map(c => c.e), f && f.lon != null ? f.lon : -180);
  let z = 15; while (z > 2 && (wx(e, z) - wx(w, z) > W - 60 || wy(s, z) - wy(n, z) > H - 60)) z--;
  M.z = z; M.lat = (s + n) / 2; M.lon = (w + e) / 2; drawMap();
}
function showCell(c) {
  const who = M.covFocus ? esc(M.covFocus.name || 'this repeater') : 'the best repeater here';
  if (c.predicted) {
    $('mapCard').innerHTML = M.covLayer === 'tx'
      ? '<b style="color:var(--green)">Should key up (' + c.value + ' dB to spare)</b><div class="sub">Predicted · ' + who + '</div><div class="sub">Calculated from the terrain and a typical handheld on high power; the more key-ups the phone logs, the better this gets.</div>'
      : '<b style="color:' + c.color + '">About ' + c.value + ' dBm · ' + esc(c.sunits) + '</b><div class="sub">Predicted · ' + who + '</div><div class="sub">Not measured here: calculated from the terrain between this square and the repeater.</div>';
    showCard(); return;
  }
  $('mapCard').innerHTML = M.covLayer === 'tx'
    ? '<b>Transmit from here</b><div class="sub">' + c.keyed + ' reached the repeater · ' + c.failed + ' got no reply</div>'
    : '<b>Signal heard here</b><div class="sub mono">median ' + c.value + ' dBm' + (c.sunits ? ' · ' + esc(c.sunits) : '') + ' · ' + c.count + ' readings · ' + who + '</div>';
  showCard();
}
/** Show the card with its close button (it also closes with Esc, a click on empty map, or a layer change). */
function showCard() {
  const c = $('mapCard'); const x = document.createElement('button');
  x.type = 'button'; x.className = 'mcx'; x.setAttribute('aria-label', 'Close'); x.textContent = '×'; x.onclick = hideCard;
  c.prepend(x); c.classList.remove('hidden');
}
function hideCard() { $('mapCard').classList.add('hidden'); }
document.addEventListener('keydown', e => { if (e.key === 'Escape' && S.page === 'map') hideCard(); });
function showMark(m) {
  const c = $('mapCard'); let h;
  if (m.kind === 'rpt') { showRepeater(m); return; }
  if (m.kind === 'aprs') {
    const s = m.s;
    h = '<b class="pk-from">' + esc(s.call) + '</b> <span class="sub">' + ago(s.lastTs) + ' · heard ' + s.count + '×</span><div>' + esc(s.comment) + '</div><div class="sub mono">' + s.lat.toFixed(4) + ', ' + s.lon.toFixed(4)
      + (s.speedKmh != null ? ' · ' + Math.round(s.speedKmh) + ' km/h' : '') + (s.course != null ? ' · ' + s.course + '°' : '') + (s.alt ? ' · ' + s.alt + ' m' : '') + (s.via ? ' · via ' + esc(s.via) : '') + '</div>';
  } else {
    const ch = m.c;
    h = '<b>' + esc(m.name) + '</b> <span class="sub mono">' + mhz(ch.rxFreq) + ' MHz</span><div class="sub">' + esc(ch.location) + '</div><button class="btn small-btn" id="mapTune">Tune channel ' + ch.number + '</button> <button class="btn small-btn" id="mapCovBtn">Coverage</button>';
  }
  c.innerHTML = h; showCard();
  const b = $('mapTune'); if (b) b.onclick = () => act('channel/select', { number: m.c.number });
  const cb = $('mapCovBtn'); if (cb) cb.onclick = () => focusCoverage({ hz: m.c.rxFreq, lat: m.lat, lon: m.lon, name: m.name });
}
(function () {
  const el = $('map'); let drag = null;
  el.addEventListener('pointerdown', e => {
    if (e.target.closest('.zoom,.mapcard,.attrib')) return;
    const mk = e.target.closest('.mk'); if (mk) { showMark(M.marks[+mk.dataset.i]); return; }
    const cv = e.target.closest('.cov'); if (cv) { showCell(M.cells[+cv.dataset.c]); return; }
    drag = { x: e.clientX, y: e.clientY, cx: wx(M.lon, M.z), cy: wy(M.lat, M.z), moved: false }; el.setPointerCapture(e.pointerId); el.classList.add('drag');
  });
  el.addEventListener('pointermove', e => {
    if (!drag) return; const dx = e.clientX - drag.x, dy = e.clientY - drag.y; if (Math.abs(dx) + Math.abs(dy) > 3) drag.moved = true;
    M.lon = lonOf(drag.cx - dx, M.z); M.lat = Math.max(-85, Math.min(85, latOf(drag.cy - dy, M.z))); drawMap();
  });
  /** The predicted square under a tap (they are drawn on a canvas, not as elements). */
  const predAt = e => {
    if (!(M.pred || []).length) return null;
    const r = el.getBoundingClientRect(), lon = lonOf(wx(M.lon, M.z) - el.clientWidth / 2 + e.clientX - r.left, M.z), lat = latOf(wy(M.lat, M.z) - el.clientHeight / 2 + e.clientY - r.top, M.z);
    return M.pred.find(c => lat >= c.s && lat <= c.n && lon >= c.w && lon <= c.e) || null;
  };
  const end = e => {
    if (drag && !drag.moved) { const p = e && e.type === 'pointerup' ? predAt(e) : null; if (p) showCell(p); else $('mapCard').classList.add('hidden'); }
    drag = null; el.classList.remove('drag');
  };
  el.addEventListener('pointerup', end); el.addEventListener('pointercancel', end);
  const zoomAt = (dz, px, py) => {
    const z = Math.max(2, Math.min(18, M.z + dz)); if (z === M.z) return;
    const W = el.clientWidth, H = el.clientHeight; if (px == null) { px = W / 2; py = H / 2; }
    const alon = lonOf(wx(M.lon, M.z) - W / 2 + px, M.z), alat = latOf(wy(M.lat, M.z) - H / 2 + py, M.z);
    M.z = z; M.lon = lonOf(wx(alon, z) - px + W / 2, z); M.lat = latOf(wy(alat, z) - py + H / 2, z); drawMap();
  };
  el.addEventListener('wheel', e => { e.preventDefault(); const r = el.getBoundingClientRect(); zoomAt(e.deltaY < 0 ? 1 : -1, e.clientX - r.left, e.clientY - r.top); }, { passive: false });
  $('zIn').onclick = () => zoomAt(1); $('zOut').onclick = () => zoomAt(-1);
  $('mapCov').onchange = () => loadCoverage(!M.fittedCov && (M.fittedCov = true));
  $('mapCovRpt').onchange = () => { const k = $('mapCovRpt').value; if (!k) { M.covFocus = null; if ($('mapCov').value) loadCoverage(true); return; } focusCoverage({ key: k }); };
  $('mapPred').onchange = () => loadCoverage(false);
  $('mapFit').onclick = () => { if ($('mapCov').value && ((M.cells || []).length || (M.pred || []).length)) fitCoverage(); else fitMap(); }; $('mapAprs').onchange = drawMap; $('mapCh').onchange = drawMap; $('mapRpt').onchange = () => loadRepeaterLayer(false);
  $('mapRptHere').onclick = () => { $('mapRpt').checked = true; hideCard(); loadRepeaterLayer(false, { lat: M.lat, lon: M.lon }); };
  window.addEventListener('resize', () => { if (S.page === 'map') drawMap(); });
})();

// ---- captions: the last few on the intercom page, all of them on the Transcripts page ----
S.caps = []; S.trRows = [];
const hhmmssDay = ts => { const d = new Date(ts); return (Date.now() - ts > 20 * 3600e3 ? d.toLocaleDateString([], { month: 'short', day: 'numeric' }) + ' ' : '') + hhmmss(ts); };
async function loadCaptions() {
  try { const j = await api('captions?limit=8'); S.caps = j.captions; setTxt(j.on); renderCapList(); } catch (e) { }
}
function renderCapList() {
  const el = $('capList');
  el.innerHTML = S.caps.slice(0, 8).map(c => '<div><span class="t">' + hhmmssDay(c.ts) + '</span>' + esc(c.text) + '</div>').join('');
  el.classList.toggle('hidden', !S.caps.length);
}
function addCaptionLine(c) {
  S.caps.unshift(c); S.caps = S.caps.slice(0, 8); renderCapList();
  if (S.page === 'trans' && !$('trSearch').value.trim()) { S.trRows.unshift(c); renderTrans(); }
}
function setTxt(on) { S.capOn = !!on; for (const id of ['txtBtn', 'trTxt']) { const b = $(id); if (b) b.classList.toggle('on', !!on); } }
async function toggleTxt() { const want = !S.capOn; const j = await act('captions/set', { on: want }); if (j) setTxt(want); }   // the server's live update may arrive first: set what was asked, never flip twice
$('txtBtn').onclick = toggleTxt; $('trTxt').onclick = toggleTxt;
let trTimer = null;
async function loadTrans() {
  const q = $('trSearch').value.trim();
  try { const j = await api('captions?limit=1000' + (q ? '&q=' + encodeURIComponent(q) : '')); S.trRows = j.captions; setTxt(j.on); renderTrans(); } catch (e) { toast(e.message); }
}
function renderTrans() {
  const q = $('trSearch').value.trim();
  const mark = t => { const e = esc(t); if (!q) return e; const re = new RegExp('(' + esc(q).replace(/[.*+?^${}()|[\]\\]/g, '\\$&') + ')', 'gi'); return e.replace(re, '<mark>$1</mark>'); };
  $('trCount').textContent = S.trRows.length + (q ? ' MATCHING' : '') + (S.trRows.length >= 1000 ? ' (NEWEST 1000)' : '');
  $('trList').innerHTML = S.trRows.map(c => '<div class="item"><div class="main"><div>' + mark(c.text) + '</div><div class="sub"><span class="t">' + hhmmssDay(c.ts) + '</span>' + esc(c.channelName) + '</div></div></div>').join('')
    || '<div class="empty">' + (q ? 'No caption contains “' + esc(q) + '”.' : 'No captions yet. Turn TXT on: every finished sentence is kept on the phone.') + '</div>';
}
$('trSearch').oninput = () => { clearTimeout(trTimer); trTimer = setTimeout(loadTrans, 300); };
$('trDownload').onclick = async () => {
  try {
    const q = $('trSearch').value.trim(); const j = await api('captions?limit=5000' + (q ? '&q=' + encodeURIComponent(q) : ''));
    const lines = j.captions.slice().reverse().map(c => new Date(c.ts).toISOString().replace('T', ' ').slice(0, 19) + 'Z\t' + c.channelName + '\t' + c.text);
    const a = document.createElement('a'); a.href = URL.createObjectURL(new Blob([lines.join('\n') + '\n'], { type: 'text/plain' }));
    a.download = 'signaldeck-transcripts' + (q ? '-' + q.replace(/[^\w-]+/g, '_') : '') + '.txt'; a.click(); setTimeout(() => URL.revokeObjectURL(a.href), 2000);
  } catch (e) { toast(e.message); }
};

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

// ---- zones (under the channel list) ----
S.zone = null;
async function loadZonesEditor() {
  try {
    const j = await api('zones'); S.zonesEd = j;
    $('zList').innerHTML = j.zones.map(z => '<div class="item click' + (S.zone && S.zone.id === z.id ? ' cur' : '') + '" data-id="' + z.id + '"><div class="main"><b>' + esc(z.name) + '</b>' + (z.id === j.active ? ' <span class="chip green">IN USE</span>' : '') + '<div class="sub">' + z.numbers.length + ' channels</div></div></div>').join('') || '<div class="empty">No zones yet</div>';
    if (S.zone) renderZoneForm();
  } catch (e) { }
}
function editZone(z) { S.zone = z ? { id: z.id, name: z.name, numbers: z.numbers.slice() } : { id: 0, name: '', numbers: [] }; $('zForm').classList.remove('hidden'); $('zName').value = S.zone.name; $('zDel').classList.toggle('hidden', !S.zone.id); renderZoneForm(); loadZonesEditor(); }
function renderZoneForm() {
  const q = $('zFilter').value.trim().toLowerCase(); const sel = new Set(S.zone.numbers);
  $('zChans').innerHTML = S.zonesEd.channels.filter(c => !q || (c.name || '').toLowerCase().includes(q) || mhz(c.rxFreq).includes(q))
    .map(c => '<label><input type="checkbox" data-n="' + c.number + '"' + (sel.has(c.number) ? ' checked' : '') + '><span class="n">' + c.number + '</span><span>' + esc(c.name || '—') + '<div class="sub mono">' + mhz(c.rxFreq) + (c.digital ? ' DMR' : ' FM') + '</div></span></label>').join('');
}
$('zList').onclick = e => { const it = e.target.closest('.item'); if (it) editZone(S.zonesEd.zones.find(z => z.id === +it.dataset.id)); };
$('zNew').onclick = () => editZone(null);
$('zFilter').oninput = renderZoneForm;
$('zChans').onchange = e => { const n = +e.target.dataset.n; if (e.target.checked) S.zone.numbers.push(n); else S.zone.numbers = S.zone.numbers.filter(x => x !== n); };
$('zAll').onclick = () => { const vis = [...$('zChans').querySelectorAll('input')].map(i => +i.dataset.n); S.zone.numbers = [...new Set(S.zone.numbers.concat(vis))]; renderZoneForm(); };
$('zNone').onclick = () => { const vis = new Set([...$('zChans').querySelectorAll('input')].map(i => +i.dataset.n)); S.zone.numbers = S.zone.numbers.filter(n => !vis.has(n)); renderZoneForm(); };
$('zForm').addEventListener('submit', async e => {
  e.preventDefault();
  const j = await act('zones', { id: S.zone.id, name: $('zName').value, numbers: S.zone.numbers });
  if (j) { S.zone.id = j.id; $('zDel').classList.remove('hidden'); loadZonesEditor(); loadZones(); loadChannels(); }
});
$('zDel').onclick = async () => {
  if (!S.zone.id || !confirm('Delete zone ' + S.zone.name + '? Its channels are kept.')) return;
  if (await act('zones/delete', { id: S.zone.id })) { S.zone = null; $('zForm').classList.add('hidden'); loadZonesEditor(); loadZones(); loadChannels(); }
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

// ---- net control (under the logbook) ----
async function loadNet() {
  try {
    const j = await api('nets'); S.net = j; const n = j.running;
    $('netState').textContent = n ? 'RUNNING · ' + n.checkIns.length + ' CHECK-INS' : 'NO NET RUNNING'; $('netState').className = 'chip ' + (n ? 'green' : 'dim');
    if (!n) {
      $('netActions').innerHTML = '';
      $('netBody').innerHTML = '<form id="netStart" class="row wrap" style="margin-top:12px"><input id="netName" placeholder="Net name" value="' + esc(j.lastName || '') + '" class="grow"><button class="btn primary">Start a net on this channel</button></form>'
        + '<div class="group">PAST NETS</div>' + (j.past.map(p => '<div class="item"><div class="main"><b>' + esc(p.name) + '</b><div class="sub">' + new Date(p.start).toLocaleString() + ' · ' + esc(p.channel) + ' · ' + p.count + ' check-ins</div></div><a class="act" target="_blank" href="/api/nets/report?id=' + p.id + '">Report</a><a class="act" href="/api/nets/report?download=1&id=' + p.id + '">Download</a><button class="act" data-netdel="' + p.id + '">Delete</button></div>').join('') || '<div class="empty">No past nets</div>');
      $('netStart').addEventListener('submit', async e => { e.preventDefault(); if (await act('nets/start', { name: $('netName').value })) loadNet(); });
      return;
    }
    $('netActions').innerHTML = '<a class="btn small-btn" target="_blank" href="/api/nets/report">Report</a><button class="btn small-btn danger" id="netEnd">End the net</button>';
    $('netEnd').onclick = async () => { if (confirm('End ' + n.name + '?')) { await act('nets/end', {}); loadNet(); } };
    const flag = (k, f, label, color) => '<button type="button" class="act" data-flag="' + f + '" data-id="' + k.id + '" style="' + (k[f] ? 'background:' + color + ';color:var(--ground);border-color:' + color : '') + '">' + label + '</button>';
    $('netBody').innerHTML = '<div class="sub" style="margin-top:6px">' + esc(n.name) + ' · ' + esc(n.channel) + (n.freqHz ? ' · ' + mhz(n.freqHz) + ' MHz' : '') + ' · started ' + hhmm(n.start) + '</div>'
      + '<form id="netCheckin" class="row wrap" style="margin-top:12px"><input id="ciCall" placeholder="Callsign" style="text-transform:uppercase" maxlength="12"><input id="ciName" placeholder="Name (looked up if empty)" class="grow"><button class="btn primary">Check in</button></form>'
      + (n.heard.length ? '<div class="quick" style="margin-top:10px">' + n.heard.map(h => '<button type="button" data-heard="' + esc(h.call) + '" data-name="' + esc(h.name) + '">+ ' + esc(h.call) + '</button>').join('') + '</div><div class="sub">Heard in the last 30 minutes: click to check in</div>' : '')
      + '<div class="list">' + (n.checkIns.map((k, i) => '<div class="item"><span class="n">' + (i + 1) + '</span><div class="main"><b class="pk-from">' + esc(k.call) + '</b> ' + esc(k.name) + '<div class="sub">' + hhmm(k.ts) + (k.notes ? ' · ' + esc(k.notes) : '') + '</div></div>'
        + flag(k, 'traffic', 'Traffic', 'var(--amber)') + flag(k, 'late', 'Late', 'var(--violet)') + flag(k, 'out', 'Out', 'var(--red)') + '<button class="act" data-rm="' + k.id + '">Remove</button></div>').join('') || '<div class="empty">No check-ins yet</div>') + '</div>';
    $('netCheckin').addEventListener('submit', async e => { e.preventDefault(); if (await act('nets/checkin', { call: $('ciCall').value, name: $('ciName').value })) { $('ciCall').value = ''; $('ciName').value = ''; loadNet(); $('ciCall').focus(); } });
  } catch (e) { }
}
$('netBody').addEventListener('click', async e => {
  const t = e.target; const n = S.net && S.net.running;
  if (t.dataset.heard) { if (await act('nets/checkin', { call: t.dataset.heard, name: t.dataset.name })) loadNet(); }
  else if (t.dataset.flag && n) { const k = n.checkIns.find(x => x.id === +t.dataset.id); const body = { id: k.id }; body[t.dataset.flag] = !k[t.dataset.flag]; if (await act('nets/update', body)) loadNet(); }
  else if (t.dataset.rm) { if (await act('nets/update', { id: +t.dataset.rm, remove: true })) loadNet(); }
  else if (t.dataset.netdel) { if (confirm('Delete this net and its check-ins?') && await act('nets/delete', { id: +t.dataset.netdel })) loadNet(); }
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

// ---- packet tools + APRS settings ----
async function loadPacket() {
  try {
    const j = await api('packet'); S.pkt = j; const t = j.tools, st = j.settings;
    const sw = (key, label, sub, on) => '<div class="set"><div class="main"><div>' + esc(label) + '</div><div class="sub">' + esc(sub) + '</div></div><button type="button" class="switch' + (on ? ' on' : '') + '" data-tool="' + key + '" role="switch" aria-checked="' + on + '" aria-label="' + esc(label) + '"></button></div>';
    $('pktTools').innerHTML = sw('is', 'APRS-IS', 'Internet gateway: ' + t.isStatus, t.is) + sw('kiss', 'KISS TNC', t.kiss ? (t.kissClient ? 'A client is connected' : 'Waiting for a client on port ' + st.kissPort) : 'For APRSdroid, YAAC and other packet programs (TCP port ' + st.kissPort + ')', t.kiss)
      + sw('parrot', 'Parrot repeater', 'Plays back what it hears on this channel (needs transmit)', t.parrot)
      + sw('fox', 'Fox transmitter', 'Be the fox: a short tone beacon repeating on this channel, with your Morse ID on amateur bands. Needs transmit; the hunt itself is done on the phone', t.fox);
    $('cwIdBtn').disabled = $('dtmfForm').querySelector('button').disabled = !t.webTx;
    $('dtmfSaved').innerHTML = (j.dtmfSaved || []).map(d => '<button type="button" data-seq="' + esc(d.code) + '">' + esc(d.name + ' · ' + d.code) + '</button>').join('');
    $('dtmfLog').innerHTML = j.dtmf.map(d => '<div class="item"><span class="t">' + hhmmss(d.ts) + '</span><div class="main mono">' + esc(d.digits) + '<div class="sub">' + esc(d.channelName || ('Channel ' + d.channel)) + '</div></div></div>').join('') || '<div class="empty">No DTMF heard yet</div>';
    $('alertList').innerHTML = j.alerts.map(a => '<div class="item"><span class="t">' + new Date(a.ts).toLocaleString() + '</span><div class="main"><b style="color:var(--amber)">' + esc(a.event) + '</b><div class="sub">' + esc(a.summary) + '</div></div></div>').join('') || '<div class="empty">No alerts received</div>';
    renderAprsSettings(j);
  } catch (e) { }
}
function renderAprsSettings(j) {
  const s = j.settings; const opt = (vals, cur) => vals.map(([v, t]) => '<option value="' + v + '"' + (String(v) === String(cur) ? ' selected' : '') + '>' + esc(t) + '</option>').join('');
  const f = (label, input) => '<label class="f"><span>' + esc(label) + '</span>' + input + '</label>';
  const chk = (k, label) => '<label class="chk"><input type="checkbox" data-k="' + k + '"' + (s[k] ? ' checked' : '') + '> ' + esc(label) + '</label>';
  $('aprsSet').innerHTML = '<div class="sect">STATION</div>'
    + f('Callsign', '<input data-k="callsign" placeholder="' + (s.callsignSet ? 'Set (hidden; type to change)' : 'Not set') + '" autocapitalize="characters">')
    + f('SSID (0–15)', '<input data-k="ssid" inputmode="numeric" value="' + s.ssid + '">')
    + f('Symbol (table + code)', '<input data-k="symbol" maxlength="2" value="' + esc(s.symbol) + '">')
    + f('Comment', '<input data-k="comment" maxlength="40" value="' + esc(s.comment) + '">')
    + f('Path', '<input data-k="path" value="' + esc(s.path) + '">')
    + f('Message groups', '<input data-k="groups" value="' + esc(s.groups) + '" placeholder="e.g. CQ, QST">')
    + '<div class="sect">BEACONS AND TRANSMIT</div>'
    + f('Automatic beacons', '<select data-k="autoBeacon">' + opt([[0, 'Off'], [1, 'Every N minutes'], [2, 'SmartBeaconing']], s.autoBeacon) + '</select>')
    + f('Every N minutes', '<input data-k="beaconMin" inputmode="numeric" value="' + s.beaconMin + '">')
    + f('Transmit power', '<select data-k="txPower">' + opt([[1, 'High'], [0, 'Low']], s.txPower) + '</select>')
    + f('Packet lead-in sound', '<select data-k="leadKind">' + opt(j.leadKinds.map((k, i) => [i, k]), s.leadKind) + '</select>')
    + f('Lead-in length', '<select data-k="leadMs">' + opt(j.leadChoices.map(ms => [ms, ms ? (ms / 1000).toFixed(1) + ' s' : 'None']), s.leadMs) + '</select>')
    + '<div class="sect">RECEIVE AND DECODERS</div>'
    + f('Decode packets on analog channels', '<select data-k="passive">' + opt([[0, 'Off'], [1, 'Flagged channels'], [2, 'Every analog channel']], s.passive) + '</select>')
    + '<div class="f" style="grid-column:1/-1;flex-direction:row;flex-wrap:wrap;gap:8px 18px">' + chk('autoAck', 'Acknowledge messages to me') + chk('digipeat', 'Fill-in digipeater') + chk('dtmf', 'DTMF decoder') + chk('wx', 'Weather alerts (SAME)') + chk('cw', 'Morse decoder') + chk('cwId', 'Morse ID after packets') + chk('telemetry', 'Telemetry beacon') + chk('weather', 'Weather beacon') + chk('txIgate', 'Transmit iGate') + '</div>'
    + '<div class="sect">APRS-IS AND KISS</div>'
    + f('APRS-IS server', '<input data-k="isServer" value="' + esc(s.isServer) + '">')
    + f('APRS-IS port', '<input data-k="isPort" inputmode="numeric" value="' + s.isPort + '">')
    + f('APRS-IS passcode', '<input data-k="isPasscode" type="password" placeholder="' + (s.isPasscodeSet ? 'Set (hidden; type to change)' : 'Not set: receive only') + '">')
    + f('Internet beacon every N minutes (0 off)', '<input data-k="isBeaconMin" inputmode="numeric" value="' + s.isBeaconMin + '">')
    + f('Internet beacon comment', '<input data-k="isComment" value="' + esc(s.isComment) + '">')
    + f('KISS TCP port', '<input data-k="kissPort" inputmode="numeric" value="' + s.kissPort + '">')
    + '<div class="actions"><button class="btn primary">Save APRS settings</button></div>'
    + '<div class="note">Your callsign and APRS-IS passcode are never shown here: leave them empty to keep what is stored on the phone.</div>';
}
$('aprsSet').addEventListener('submit', async e => {
  e.preventDefault(); const body = {};
  $('aprsSet').querySelectorAll('[data-k]').forEach(el => {
    const k = el.dataset.k; let v = el.type === 'checkbox' ? el.checked : el.value;
    if (['ssid', 'beaconMin', 'isPort', 'isBeaconMin', 'kissPort', 'autoBeacon', 'txPower', 'leadKind', 'leadMs', 'passive'].includes(k)) v = parseInt(v, 10);
    if ((k === 'callsign' || k === 'isPasscode') && !v) return;    // write-only: empty keeps the stored value
    body[k] = v;
  });
  if (await act('packet/settings', body)) loadPacket();
});
$('pktTools').addEventListener('click', async e => { const b = e.target.closest('[data-tool]'); if (!b) return; const on = !b.classList.contains('on'); await act('packet/tool', { tool: b.dataset.tool, on }); setTimeout(loadPacket, 800); });
$('dtmfForm').addEventListener('submit', async e => { e.preventDefault(); if (await act('dtmf', { seq: $('dtmfSeq').value })) $('dtmfSeq').value = ''; });
$('dtmfSaved').onclick = e => { const b = e.target.closest('[data-seq]'); if (b) $('dtmfSeq').value = b.dataset.seq; };
$('cwIdBtn').onclick = () => act('cwid', {});

// ---- SSTV: send a picture (the phone scales it to the mode's 320 x 240 and transmits) ----
$('sstvSend').addEventListener('submit', async e => {
  e.preventDefault();
  if (!S.status.webTx) { toast('Transmit from the web is off (phone: Device → SignalDeck Web)'); return; }
  const f = $('sstvFile').files[0]; if (!f) { toast('Choose a picture first'); return; }
  if (f.size > 8 * 1024 * 1024) { toast('That picture is too large (8 MB at most)'); return; }
  try {
    const r = await fetch('/api/sstv/send?mode=' + $('sstvMode').value, { method: 'POST', headers: { 'Content-Type': f.type || 'application/octet-stream' }, body: f });
    const j = await r.json().catch(() => ({})); toast(r.ok ? j.message : (j.error || 'HTTP ' + r.status));
  } catch (err) { toast(err.message); }
});

// ---- last heard + alerts (under the intercom) ----
async function loadHeard() {
  try {
    const j = await api('heard');
    const day = ts => new Date(ts).toLocaleDateString([], { month: '2-digit', day: '2-digit' }) + ' ' + hhmmss(ts);
    $('heardList').innerHTML = j.heard.map(h => '<div class="item' + (h.channel > 0 ? ' click' : '') + '" data-ch="' + h.channel + '"><span class="t">' + day(h.ts) + '</span><div class="main">'
      + (h.dmrId > 0 ? '<b style="color:var(--amber)">' + esc(h.name || ('ID ' + h.dmrId)) + '</b> <span class="sub mono">' + h.dmrId + '</span>' : '<span class="pk-from">' + esc(h.text.length > 70 ? h.text.slice(0, 70) + '…' : h.text) + '</span>')
      + '<div class="sub">' + esc(h.channelName) + (h.count > 1 ? ' · ' + h.count + '×' : '') + (h.dmrId > 0 && h.text ? ' · ' + esc(h.text) : '') + '</div></div></div>').join('') || '<div class="empty">Nothing heard yet</div>';
    $('eventList').innerHTML = j.events.map(e => '<div class="item"><span class="t">' + day(e.ts) + '</span><div class="main">' + esc(e.text) + '</div></div>').join('') || '<div class="empty">No alerts or events this week</div>';
  } catch (e) { }
}
$('heardRefresh').onclick = loadHeard;
$('heardList').onclick = e => { const it = e.target.closest('.item.click'); if (it && confirm('Tune channel ' + it.dataset.ch + '?')) act('channel/select', { number: +it.dataset.ch }); };

// ---- voice keyer ----
async function loadKeyer() {
  try {
    const j = await api('keyer'); S.keyer = j;
    const due = j.idDueMs; $('idTimer').textContent = due == null ? 'ID TIMER IDLE' : due <= 0 ? 'STATION ID DUE NOW' : 'ID DUE IN ' + Math.ceil(due / 60000) + ' MIN';
    $('idTimer').className = 'chip ' + (due != null && due <= 0 ? 'amber' : 'dim');
    $('keyerList').innerHTML = j.slots.map((k, i) => '<div class="set"><div class="main"><input data-kname="' + i + '" value="' + esc(k.name) + '" maxlength="24" style="width:180px"> <span class="sub">' + (k.has ? (k.ms / 1000).toFixed(1) + ' s' : 'empty') + '</span>'
      + '<label class="chk" style="margin-top:6px"><input type="checkbox" data-kid="' + i + '"' + (k.addId ? ' checked' : '') + '> Morse ID after it</label></div>'
      + '<div class="row wrap"><label class="btn small-btn">Upload<input type="file" accept="audio/*" data-kup="' + i + '" hidden></label>'
      + (k.has ? '<button class="btn small-btn" data-kplay="' + i + '">▶ Play</button><button class="btn small-btn primary" data-ksend="' + i + '"' + (j.webTx ? '' : ' disabled') + '>Send</button><button class="btn small-btn danger" data-kdel="' + i + '">Delete</button>' : '') + '</div></div>').join('');
  } catch (e) { }
}
/** Any audio file → 8 kHz mono 16-bit little-endian, at most 25 s. */
async function toKeyerPcm(file) {
  const buf = await file.arrayBuffer();
  const dec = await new (window.AudioContext || window.webkitAudioContext)().decodeAudioData(buf);
  const secs = Math.min(25, dec.duration); const off = new OfflineAudioContext(1, Math.ceil(secs * 8000), 8000);
  const src = off.createBufferSource(); src.buffer = dec; src.connect(off.destination); src.start();
  const out = await off.startRendering(); const f = out.getChannelData(0);
  let peak = 0; for (const v of f) peak = Math.max(peak, Math.abs(v)); const g = peak > 0 ? Math.min(4, 0.9 / peak) : 1;   // normalise quiet recordings
  const dv = new DataView(new ArrayBuffer(f.length * 2)); for (let i = 0; i < f.length; i++) dv.setInt16(i * 2, Math.max(-32768, Math.min(32767, Math.round(f[i] * g * 32767))), true);
  return dv.buffer;
}
let keyerAudio = null;
$('keyerList').addEventListener('change', async e => {
  const t = e.target;
  if (t.dataset.kname) act('keyer', { slot: +t.dataset.kname, name: t.value });
  if (t.dataset.kid) act('keyer', { slot: +t.dataset.kid, addId: t.checked });
  if (t.dataset.kup && t.files[0]) {
    try {
      const pcm = await toKeyerPcm(t.files[0]);
      const r = await fetch('/api/keyer/audio?slot=' + t.dataset.kup, { method: 'POST', headers: { 'Content-Type': 'application/octet-stream' }, body: pcm });
      const j = await r.json(); toast(r.ok ? j.message : j.error); loadKeyer();
    } catch (err) { toast('Could not read that file: ' + err.message); }
  }
});
$('keyerList').addEventListener('click', async e => {
  const t = e.target.closest('button'); if (!t) return;
  if (t.dataset.kplay) { if (keyerAudio) keyerAudio.pause(); keyerAudio = new Audio('/api/keyer/audio?slot=' + t.dataset.kplay + '&t=' + Date.now()); keyerAudio.play().catch(() => {}); }
  if (t.dataset.ksend) act('keyer', { slot: +t.dataset.ksend, send: true });
  if (t.dataset.kdel && confirm('Delete ' + S.keyer.slots[+t.dataset.kdel].name + '?')) { await act('keyer', { slot: +t.dataset.kdel, delete: true }); loadKeyer(); }
});

// ---- text modes (RTTY / PSK31) and the packet terminal, refreshed while the Packet page is open ----
function setTerm(el, text) { const atEnd = el.scrollTop + el.clientHeight >= el.scrollHeight - 20; if (el.textContent !== text) { el.textContent = text; if (atEnd) el.scrollTop = el.scrollHeight; } }
async function pollPacketTools() {
  if (S.page !== 'pkt') return;
  try {
    const [t, r] = await Promise.all([api('textmodes'), api('terminal')]);
    if (!$('tmMode').options.length) $('tmMode').innerHTML = t.modes.map((m, i) => '<option value="' + i + '">' + (i ? 'Listen: ' + esc(m) : 'Not listening') + '</option>').join('');
    if (document.activeElement !== $('tmMode')) $('tmMode').value = t.mode;
    if (document.activeElement !== $('tmTx')) $('tmTx').value = t.txMode;
    $('tmStatus').textContent = t.status.toUpperCase(); setTerm($('tmText'), t.text || '');
    $('tmForm').querySelector('button').disabled = !t.webTx;
    $('trState').textContent = r.state.toUpperCase(); $('trState').className = 'chip ' + (/^connected/.test(r.state) ? 'green' : 'dim');
    $('trAccept').checked = r.accept; $('trAccept').disabled = !r.webTx && !r.accept;
    $('trConnect').querySelector('button').disabled = $('trForm').querySelector('button').disabled = !r.webTx || !r.callsignSet;
    setTerm($('trText'), r.transcript || (r.callsignSet ? '' : 'Set your callsign in the APRS settings first.'));
  } catch (e) { }
}
setInterval(pollPacketTools, 1000);
$('tmMode').onchange = () => act('textmodes', { mode: +$('tmMode').value });
$('tmTx').onchange = () => act('textmodes', { txMode: +$('tmTx').value });
$('tmClear').onclick = () => act('textmodes', { clear: true });
$('tmForm').addEventListener('submit', async e => { e.preventDefault(); if (await act('textmodes', { send: $('tmLine').value })) $('tmLine').value = ''; });
$('trConnect').addEventListener('submit', e => { e.preventDefault(); act('terminal', { connect: $('trCall').value.trim(), via: $('trVia').value.trim() }); });
$('trDisc').onclick = () => act('terminal', { disconnect: true });
$('trAccept').onchange = () => act('terminal', { accept: $('trAccept').checked });
$('trForm').addEventListener('submit', async e => { e.preventDefault(); if (await act('terminal', { send: $('trLine').value })) $('trLine').value = ''; });

// ---- diagnostics log (Settings) ----
async function loadDiagLog() { try { const j = await api('log'); const el = $('diagLog'); el.textContent = j.lines.join(String.fromCharCode(10)); el.scrollTop = el.scrollHeight; } catch (e) { } }
$('logRefresh').onclick = loadDiagLog;

// ---- settings ----
async function loadSettings() { try { renderSettings(await api('settings')); } catch (e) { } }
function renderSettings(j) {
  S.settings = j.settings;
  const f = (k, v) => '<div><span>' + k + '</span><b>' + esc(v) + '</b></div>';
  $('radioCard').innerHTML = '<div class="big">' + (j.ready ? 'SIGNALDECK OWNS THE RADIO' : esc(String(j.link || '').toUpperCase())) + '</div><div class="grid">' + f('PHONE', j.profile || '—') + f('VERSION', j.version) + '</div>';
  $('webCard').innerHTML = '<div class="grid">' + f('BROWSERS', j.browsers) + f('LISTENING', j.listeners) + f('TRANSMIT FROM WEB', j.webTx ? 'Allowed' : 'Off') + '</div>';
  let html = '', group = null;
  j.settings.forEach((s, i) => {
    if (s.group !== group) { group = s.group; html += '<div class="group">' + esc(group).toUpperCase() + '</div>'; }
    let ctl;
    if (s.kind === 'bool') ctl = '<button type="button" class="switch' + (s.value ? ' on' : '') + '" data-i="' + i + '" role="switch" aria-checked="' + !!s.value + '" aria-label="' + esc(s.label) + '"></button>';
    else if (s.kind === 'choice') ctl = '<select data-i="' + i + '">' + s.choices.map((c, ci) => '<option value="' + ci + '"' + (ci === s.value ? ' selected' : '') + '>' + esc(c) + '</option>').join('') + '</select>';
    else ctl = '<input data-i="' + i + '" value="' + esc(s.value) + '"' + (s.kind === 'int' ? ' inputmode="numeric"' : '') + ' title="Enter to save">';
    html += '<div class="set"><div class="main"><div>' + esc(s.label) + '</div><div class="sub">' + esc(s.sub) + '</div></div>' + ctl + '</div>';
  });
  $('setList').innerHTML = html;
}
async function saveSetting(i, value) { const s = S.settings[i]; const j = await act('settings', { key: s.key, value }); if (j) renderSettings(j); else loadSettings(); }
$('setList').addEventListener('click', e => { const b = e.target.closest('.switch'); if (b) saveSetting(+b.dataset.i, !S.settings[+b.dataset.i].value); });
$('setList').addEventListener('change', e => { const el = e.target; if (el.tagName === 'SELECT') saveSetting(+el.dataset.i, +el.value); else if (el.tagName === 'INPUT') { const s = S.settings[+el.dataset.i]; saveSetting(+el.dataset.i, s.kind === 'int' ? parseInt(el.value, 10) : el.value); } });
// backup and restore
async function loadBackups() {
  try {
    const j = await api('backups'); S.backups = j.backups;
    $('backupList').innerHTML = j.backups.slice(0, 30).map((b, i) => '<div class="item"><div class="main"><b>' + esc(b.name) + '</b><div class="sub">' + new Date(b.ts).toLocaleString() + ' · ' + b.files.length + ' files</div></div>'
      + '<a class="act" href="/api/backup/zip?name=' + encodeURIComponent(b.name) + '">Download</a><button class="act" data-restore="' + i + '">Restore</button></div>').join('') || '<div class="empty">No backups yet</div>';
  } catch (e) { }
}
$('backupNow').onclick = async () => { if (await act('backup', {})) loadBackups(); };
$('backupList').onclick = async e => {
  const b = e.target.closest('[data-restore]'); if (!b) return; const bk = S.backups[+b.dataset.restore];
  if (!confirm('Restore ' + bk.name + '? It replaces every channel, contact and zone in SignalDeck with this backup.')) return;
  if (await act('restore', { name: bk.name })) { loadChannels(); refresh(); }
};
$('restoreFiles').onchange = async () => {
  const fl = [...$('restoreFiles').files]; if (!fl.length) return;
  const files = {}; for (const f of fl) files[f.name] = await f.text();
  if (!files['Channels.csv']) { toast('Channels.csv is needed'); $('restoreFiles').value = ''; return; }
  if (!confirm('Restore from ' + Object.keys(files).join(', ') + '? It replaces every channel, contact and zone in SignalDeck.')) { $('restoreFiles').value = ''; return; }
  if (await act('restore', { files })) { loadChannels(); refresh(); }
  $('restoreFiles').value = '';
};
$('takeOver').onclick = async () => { await act('radio', { action: 'takeover' }); setTimeout(loadSettings, 4000); };
$('handBack').onclick = async () => { if (confirm('Hand the radio back to the stock app? SignalDeck (and this page) stops controlling the radio until you take it over again.')) { await act('radio', { action: 'handback' }); setTimeout(loadSettings, 3000); } };

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
