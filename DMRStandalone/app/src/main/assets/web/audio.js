// SignalDeck Web: hear the radio in the browser. /api/audio streams what the phone's speaker plays (after the squelch)
// as raw 8 kHz mono 16-bit PCM; Web Audio schedules it with a short jitter buffer and starts fresh after every pause.
'use strict';

const AU = { on: false, ctx: null, gain: null, abort: null, playAt: 0, lastData: 0, bytes: 0, odd: null };
const AU_LEAD = 0.25;      // seconds of buffer at the start of each transmission (Wi-Fi jitter)
const AU_MAX_LAG = 1.2;    // more queued than this: skip ahead instead of drifting further behind

async function listenStart() {
  if (AU.on) return;
  AU.ctx = AU.ctx || new (window.AudioContext || window.webkitAudioContext)();
  await AU.ctx.resume();
  AU.gain = AU.gain || AU.ctx.createGain(); AU.gain.connect(AU.ctx.destination); AU.gain.gain.value = +$('vol').value / 100;
  AU.on = true; AU.playAt = 0; AU.odd = null; renderListen();
  const ctl = new AbortController(); AU.abort = ctl;
  try {
    const r = await fetch('/api/audio', { signal: ctl.signal, cache: 'no-store' });
    if (r.status === 401) { showLogin(); throw new Error('login required'); }
    if (!r.ok || !r.body) throw new Error('HTTP ' + r.status);
    const rd = r.body.getReader();
    for (;;) {
      const { value, done } = await rd.read();
      if (done) break;
      if (value && value.length) play(value);
    }
    if (AU.on) { toast('Audio stream ended: reconnecting'); AU.on = false; setTimeout(listenStart, 1500); }
  } catch (e) {
    if (AU.on && e.name !== 'AbortError') { toast('Audio: ' + e.message + ' (retrying)'); AU.on = false; setTimeout(() => { if (!AU.stopped) listenStart(); }, 3000); }
  }
  renderListen();
}
function listenStop() { AU.stopped = true; AU.on = false; if (AU.abort) AU.abort.abort(); AU.abort = null; renderListen(); setTimeout(() => { AU.stopped = false; }, 0); }

function play(u8) {
  // join a byte left over from the previous chunk so samples stay aligned
  let data = u8;
  if (AU.odd !== null) { data = new Uint8Array(u8.length + 1); data[0] = AU.odd; data.set(u8, 1); AU.odd = null; }
  if (data.length % 2) { AU.odd = data[data.length - 1]; data = data.subarray(0, data.length - 1); }
  const n = data.length / 2; if (n < 2) return;            // the server's keep-alive sample
  const dv = new DataView(data.buffer, data.byteOffset, data.length);
  const buf = AU.ctx.createBuffer(1, n, 8000); const ch = buf.getChannelData(0);
  for (let i = 0; i < n; i++) ch[i] = dv.getInt16(i * 2, true) / 32768;
  const now = AU.ctx.currentTime;
  if (AU.playAt < now || AU.playAt - now > AU_MAX_LAG) AU.playAt = now + AU_LEAD;      // a new transmission, or we fell behind
  const src = AU.ctx.createBufferSource(); src.buffer = buf; src.connect(AU.gain); src.start(AU.playAt);
  AU.playAt += buf.duration; AU.lastData = Date.now(); AU.bytes += data.length;
}

function renderListen() {
  const b = $('listenBtn'); b.classList.toggle('on', AU.on); b.textContent = AU.on ? '🔊 LISTENING' : '🔈 LISTEN';
  $('listenState').textContent = AU.on ? (Date.now() - AU.lastData < 1500 ? 'audio' : 'quiet') : '';
}
$('listenBtn').onclick = () => { if (AU.on) listenStop(); else listenStart().catch(e => toast(e.message)); };
$('vol').oninput = () => { if (AU.gain) AU.gain.gain.value = +$('vol').value / 100; };
setInterval(() => { if (AU.on) renderListen(); }, 700);
