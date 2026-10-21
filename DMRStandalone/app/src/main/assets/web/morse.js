// SignalDeck Web: Koch Morse trainer in the browser (the phone's MorseTrainer: LCWO order, groups of five with the
// newest character favoured, Farnsworth spacing, edit-distance score, 90 % moves to the next lesson).
'use strict';

const MT = { koch: '', lessons: 40, lesson: 1, wpm: 20, fw: 10, sent: '', ctx: null, stopAt: 0 };
const MORSE = { A: '.-', B: '-...', C: '-.-.', D: '-..', E: '.', F: '..-.', G: '--.', H: '....', I: '..', J: '.---', K: '-.-', L: '.-..', M: '--', N: '-.', O: '---', P: '.--.', Q: '--.-', R: '.-.', S: '...', T: '-',
  U: '..-', V: '...-', W: '.--', X: '-..-', Y: '-.--', Z: '--..', 0: '-----', 1: '.----', 2: '..---', 3: '...--', 4: '....-', 5: '.....', 6: '-....', 7: '--...', 8: '---..', 9: '----.',
  '/': '-..-.', '=': '-...-', '?': '..--..', '.': '.-.-.-', ',': '--..--' };

async function loadTrainer() {
  try { Object.assign(MT, await api('trainer')); renderTrainer(); } catch (e) { }
}
const lessonChars = l => MT.koch.substring(0, Math.max(2, Math.min(MT.koch.length, l + 1)));
function renderTrainer() {
  const opts = (a, b, cur) => { let h = ''; for (let i = a; i <= b; i++) h += '<option value="' + i + '"' + (i === cur ? ' selected' : '') + '>' + i + '</option>'; return h; };
  $('mtBody').innerHTML = '<div class="row wrap"><label class="f">Lesson<select id="mtLesson">' + opts(1, MT.lessons, MT.lesson) + '</select></label>'
    + '<label class="f">Character speed (WPM)<select id="mtWpm">' + opts(5, 40, MT.wpm) + '</select></label>'
    + '<label class="f">Effective speed (Farnsworth)<select id="mtFw">' + opts(5, 40, MT.fw) + '</select></label></div>'
    + '<p class="muted">Characters in this lesson: <b class="mono" style="color:var(--cyan);letter-spacing:.2em">' + esc(lessonChars(MT.lesson)) + '</b> (newest: <b class="mono">' + esc(lessonChars(MT.lesson).slice(-1)) + '</b>)</p>'
    + '<div class="row wrap"><button class="btn primary" id="mtPlay">Play a lesson (10 groups)</button><button class="btn" id="mtAgain" disabled>Play again</button><button class="btn" id="mtStop">Stop</button></div>'
    + '<textarea id="mtCopy" class="mtcopy mono" placeholder="Type what you hear, groups of five separated by spaces" spellcheck="false" autocapitalize="characters"></textarea>'
    + '<div class="row wrap"><button class="btn primary" id="mtCheck" disabled>Check</button><span id="mtResult" class="muted"></span></div>';
  const save = () => { MT.lesson = +$('mtLesson').value; MT.wpm = +$('mtWpm').value; MT.fw = +$('mtFw').value; act('trainer', { lesson: MT.lesson, wpm: MT.wpm, fw: MT.fw }); renderTrainer(); };
  $('mtLesson').onchange = save; $('mtWpm').onchange = save; $('mtFw').onchange = save;
  $('mtPlay').onclick = () => { MT.sent = groups(MT.lesson, 10); $('mtCopy').value = ''; $('mtResult').textContent = ''; morsePlay(MT.sent); $('mtAgain').disabled = false; $('mtCheck').disabled = false; $('mtCopy').focus(); };
  $('mtAgain').onclick = () => morsePlay(MT.sent);
  $('mtStop').onclick = stopMorse;
  $('mtCheck').onclick = check;
}
function groups(lesson, n) {
  const cs = lessonChars(lesson), newest = cs[cs.length - 1]; const out = [];
  for (let g = 0; g < n; g++) { let w = ''; for (let i = 0; i < 5; i++) w += Math.random() < 1 / 3 ? newest : cs[Math.floor(Math.random() * cs.length)]; out.push(w); }
  return out.join(' ');
}
function stopMorse() { if (MT.ctx) { MT.ctx.close(); MT.ctx = null; } }
function morsePlay(text) {
  stopMorse();
  const ctx = new (window.AudioContext || window.webkitAudioContext)(); MT.ctx = ctx;
  const wpm = MT.wpm, f = Math.min(MT.fw, wpm), dit = 1.2 / wpm;
  let charGap = 3 * dit, wordGap = 7 * dit;
  if (f < wpm) { const ta = (60 * wpm - 37.2 * f) / (wpm * f); charGap = 3 * ta / 19; wordGap = 7 * ta / 19; }   // ARRL Farnsworth timing, as on the phone
  const osc = ctx.createOscillator(), gain = ctx.createGain(); osc.frequency.value = 700; gain.gain.value = 0; osc.connect(gain); gain.connect(ctx.destination);
  let t = ctx.currentTime + 0.3; const edge = 0.005;
  text.trim().split(' ').forEach((w, wi) => {
    if (wi) t += wordGap;
    [...w].forEach((ch, ci) => {
      const c = MORSE[ch.toUpperCase()]; if (!c) return;
      if (ci) t += charGap;
      [...c].forEach((s, k) => {
        if (k) t += dit;
        const len = (s === '-' ? 3 : 1) * dit;
        gain.gain.setValueAtTime(0, t); gain.gain.linearRampToValueAtTime(0.35, t + edge); gain.gain.setValueAtTime(0.35, t + len - edge); gain.gain.linearRampToValueAtTime(0, t + len);
        t += len;
      });
    });
  });
  osc.start(); osc.stop(t + 0.3);
}
function score(sent, copied) {
  const a = sent.replace(/ /g, '').toUpperCase(), b = (copied || '').replace(/\s/g, '').toUpperCase();
  if (!a.length) return 1;
  let prev = Array.from({ length: b.length + 1 }, (_, j) => j), cur = new Array(b.length + 1);
  for (let i = 1; i <= a.length; i++) {
    cur[0] = i;
    for (let j = 1; j <= b.length; j++) cur[j] = Math.min(cur[j - 1] + 1, prev[j] + 1, prev[j - 1] + (a[i - 1] === b[j - 1] ? 0 : 1));
    [prev, cur] = [cur, prev];
  }
  return Math.max(0, 1 - prev[b.length] / a.length);
}
async function check() {
  const s = score(MT.sent, $('mtCopy').value), pct = Math.round(s * 100);
  let msg = pct + ' % right. Sent: ' + MT.sent;
  if (s >= 0.9 && MT.lesson < MT.lessons) { MT.lesson++; await act('trainer', { lesson: MT.lesson }); msg = pct + ' % — on to lesson ' + MT.lesson + ' (adds ' + lessonChars(MT.lesson).slice(-1) + '). Sent: ' + MT.sent; }
  else if (s < 0.9) msg += '  ·  90 % moves you on.';
  const keep = MT.sent; renderTrainer(); MT.sent = keep; $('mtResult').textContent = msg; $('mtResult').style.color = s >= 0.9 ? 'var(--green)' : 'var(--amber)'; $('mtAgain').disabled = false;
}
