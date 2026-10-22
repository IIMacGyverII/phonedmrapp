/*
 * SignalDeck - Copyright (C) 2026 IIMacGyverII
 * SPDX-License-Identifier: GPL-3.0-or-later
 * Free software under the GNU General Public License v3 or later, with the additional terms in COPYRIGHT
 * (keep this notice and the author credit, mark modified versions, no rights to the SignalDeck name or icon).
 */
// SignalDeck Web: talk with this computer's microphone. Needs the secure address (https://phone:8443): the browser
// captures the mic at 8 kHz, sends it over a WebSocket while PTT is held, and the phone transmits it instead of its own
// microphone. Releasing, closing the tab, hiding it or losing the network always unkeys (the phone also stops after
// 1.5 s without audio).
'use strict';

const TALK = {
  ws: null, ctx: null, node: null, stream: null, down: false, ready: false, pending: [], resample: null,
  usable() { return location.protocol === 'https:' && !!(navigator.mediaDevices && navigator.mediaDevices.getUserMedia) && window.isSecureContext; },
};

async function talkMic() {
  if (TALK.ctx) return;
  TALK.stream = await navigator.mediaDevices.getUserMedia({ audio: { echoCancellation: true, noiseSuppression: true, autoGainControl: true, channelCount: 1 } });
  let ctx;
  try { ctx = new AudioContext({ sampleRate: 8000 }); ctx.createMediaStreamSource(TALK.stream); } catch (e) { ctx = new AudioContext(); }   // some browsers will not mix rates
  const src = ctx.createMediaStreamSource(TALK.stream);
  let last = src;
  if (ctx.sampleRate !== 8000) {                                           // band-limit before taking every n-th sample
    for (let k = 0; k < 2; k++) { const lp = ctx.createBiquadFilter(); lp.type = 'lowpass'; lp.frequency.value = 3400; lp.Q.value = 0.707; last.connect(lp); last = lp; }
    TALK.resample = { step: ctx.sampleRate / 8000, pos: 0 };
  }
  const code = "class Cap extends AudioWorkletProcessor { process(i) { const c = i[0] && i[0][0]; if (c) this.port.postMessage(c.slice(0)); return true; } } registerProcessor('cap', Cap);";
  await ctx.audioWorklet.addModule(URL.createObjectURL(new Blob([code], { type: 'application/javascript' })));
  const node = new AudioWorkletNode(ctx, 'cap');
  node.port.onmessage = e => talkSamples(e.data);
  last.connect(node);                                                      // not connected to the speakers: no local echo
  TALK.ctx = ctx; TALK.node = node;
}

/** Float samples at the context rate → 8 kHz 16-bit, sent in 40 ms blocks while keyed. */
function talkSamples(f) {
  if (!TALK.down) return;
  let s = f;
  if (TALK.resample) {
    const r = TALK.resample, out = [];
    for (; r.pos < f.length; r.pos += r.step) out.push(f[Math.floor(r.pos)]);
    r.pos -= f.length; s = out;
  }
  for (const v of s) TALK.pending.push(Math.max(-32768, Math.min(32767, Math.round(v * 32767))));
  if (TALK.pending.length >= 320 && TALK.ws && TALK.ws.readyState === 1) {
    const a = new Int16Array(TALK.pending); TALK.pending = [];
    TALK.ws.send(a.buffer);                                                // little-endian on every browser platform in use
  }
}

function talkSocket() {
  return new Promise((resolve, reject) => {
    if (TALK.ws && TALK.ws.readyState === 1) return resolve(TALK.ws);
    const ws = new WebSocket('wss://' + location.host + '/api/ws/talk'); ws.binaryType = 'arraybuffer';
    ws.onopen = () => { TALK.ws = ws; resolve(ws); };
    ws.onerror = () => reject(new Error('Could not open the talk link'));
    ws.onclose = () => { if (TALK.ws === ws) TALK.ws = null; if (TALK.down) talkRelease(); };
    ws.onmessage = e => {
      try {
        const m = JSON.parse(e.data);
        if (m.error) { toast(m.error); talkRelease(true); }
        $('ptt').classList.toggle('down', m.state === 'tx' && TALK.down);
      } catch (x) { }
    };
  });
}

async function talkPtt(down) {
  if (down) {
    if (TALK.down) return; TALK.down = true; TALK.pending = []; $('ptt').classList.add('down');
    try {
      await talkMic(); await TALK.ctx.resume();
      const ws = await talkSocket();
      if (!TALK.down) return;                                              // released while the mic or link was opening
      ws.send('down');
    } catch (e) { toast(e.name === 'NotAllowedError' ? 'The browser did not allow the microphone' : e.message); talkRelease(true); }
  } else talkRelease();
}
function talkRelease(quiet) {
  if (!TALK.down) return; TALK.down = false; TALK.pending = []; $('ptt').classList.remove('down');
  if (TALK.ws && TALK.ws.readyState === 1) TALK.ws.send('up');
}
