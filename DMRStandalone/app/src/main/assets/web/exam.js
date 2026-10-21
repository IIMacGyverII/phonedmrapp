// SignalDeck Web: licence exam practice from the FCC pools (the phone's own pool files and progress).
'use strict';

const EX = { els: [], el: null, pool: null, qs: [], i: 0, exam: false, wrong: [], answered: false };
const groupOf = id => id.slice(0, 3), subOf = id => id.slice(0, 2);
const shuffle = a => { for (let i = a.length - 1; i > 0; i--) { const j = Math.floor(Math.random() * (i + 1)); [a[i], a[j]] = [a[j], a[i]]; } return a; };

async function loadExam() {
  try { EX.els = (await api('exam')).elements; examHome(); } catch (e) { }
}
function examHome() {
  $('examBody').innerHTML = '<div class="passgrid">' + EX.els.map((e, i) => '<div class="satbox"><h4>' + esc(e.name) + '</h4><div class="about">' + e.questions + ' questions, pass at ' + e.pass
    + (e.best >= 0 ? ' · best ' + e.best + '/' + e.questions : '') + ' · ' + e.missed.length + ' missed to review</div>'
    + '<div class="row wrap"><button class="btn primary" data-ex="exam" data-i="' + i + '">Practice exam</button><button class="btn" data-ex="study" data-i="' + i + '">Study a subelement</button>'
    + '<button class="btn" data-ex="missed" data-i="' + i + '"' + (e.missed.length ? '' : ' disabled') + '>Review missed</button></div></div>').join('') + '</div>'
    + '<p class="muted small">Questions are the NCVEC pools (public domain). Missed questions and best scores are shared with the phone\'s Exam practice.</p>';
}
async function pool(e) {
  if (EX.poolKey === e.key) return EX.pool;
  const r = await fetch('/' + e.asset); EX.pool = await r.json(); EX.poolKey = e.key; return EX.pool;
}
async function examStart(mode, i) {
  const e = EX.els[i]; EX.el = e; const p = await pool(e);
  if (mode === 'exam') {
    const groups = {}; for (const q of p) (groups[groupOf(q.id)] = groups[groupOf(q.id)] || []).push(q);
    EX.qs = Object.values(groups).map(g => g[Math.floor(Math.random() * g.length)]); EX.exam = true;
  } else if (mode === 'missed') {
    const m = new Set(e.missed); EX.qs = shuffle(p.filter(q => m.has(q.id))); EX.exam = false;
  } else {
    const subs = {}; for (const q of p) subs[subOf(q.id)] = (subs[subOf(q.id)] || 0) + 1;
    $('examBody').innerHTML = '<h3 class="label">' + esc(e.name) + ': choose a subelement</h3><div class="quick" style="margin-top:12px">'
      + Object.entries(subs).map(([s, n]) => '<button type="button" data-sub="' + s + '">' + s + ' · ' + n + ' questions</button>').join('') + '</div><button class="btn" data-ex="home">Back</button>';
    return;
  }
  EX.i = 0; EX.wrong = []; examQuestion();
}
function examStudy(sub) { EX.qs = shuffle(EX.pool.filter(q => subOf(q.id) === sub)); EX.exam = false; EX.i = 0; EX.wrong = []; examQuestion(); }
function examQuestion() {
  if (EX.i >= EX.qs.length) return examResults();
  const q = EX.qs[EX.i]; EX.answered = false;
  $('examBody').innerHTML = '<div class="row between"><span class="label">' + (EX.exam ? 'PRACTICE EXAM' : 'STUDY') + ' · ' + (EX.i + 1) + ' / ' + EX.qs.length + '</span><span class="chip dim">' + q.id + '</span></div>'
    + '<p class="exq">' + esc(q.question) + '</p>' + (q.figure ? '<img class="exfig" src="/exam/' + encodeURIComponent(q.figure) + '" alt="Figure ' + esc(q.figure) + '">' : '')
    + '<div class="exans">' + q.answers.map((a, k) => '<button type="button" class="exa" data-k="' + k + '"><b>' + 'ABCD'[k] + '.</b> ' + esc(a) + '</button>').join('') + '</div>'
    + '<div class="row" id="exNext"></div><div class="row" style="margin-top:14px"><button class="btn small-btn" data-ex="stop">Stop</button></div>';
}
async function examAnswer(k) {
  if (EX.answered) return; EX.answered = true;
  const q = EX.qs[EX.i]; const right = k === q.correct;
  if (!right) EX.wrong.push([q, k]);
  act('exam/answer', { element: EX.el.key, id: q.id, right }).catch(() => {});
  if (EX.exam) { EX.i++; examQuestion(); return; }
  const bs = document.querySelectorAll('.exa');
  bs[q.correct].classList.add('right'); if (!right) bs[k].classList.add('wrong');
  $('exNext').innerHTML = '<button class="btn ' + (right ? 'primary' : '') + '" data-ex="next">' + (right ? 'Right · next' : 'The answer is ' + 'ABCD'[q.correct] + ' · next') + '</button>';
}
async function examResults() {
  const n = EX.exam ? EX.qs.length : EX.i, right = n - EX.wrong.length, e = EX.el;
  const full = EX.exam && n === e.questions, pass = full && right >= e.pass;
  if (full) await act('exam/result', { element: e.key, right }).catch(() => {});
  $('examBody').innerHTML = '<div class="center"><div class="digits" style="font-size:56px;color:' + (full ? (pass ? 'var(--green)' : 'var(--amber)') : 'var(--cyan)') + '">' + right + ' / ' + n + '</div>'
    + '<p class="muted">' + (full ? (pass ? 'Pass: ' + e.pass + ' were needed.' : 'Not yet: ' + e.pass + ' are needed. Review the misses below, then try again.') : (n ? Math.round(right * 100 / n) + ' % right. Misses are kept for Review missed.' : '')) + '</p></div>'
    + (EX.wrong.length ? '<div class="group">MISSED</div>' + EX.wrong.map(([q, k]) => '<div class="item"><div class="main"><b>' + q.id + '</b> ' + esc(q.question) + '<div class="sub">You: ' + 'ABCD'[k] + '. ' + esc(q.answers[k]) + '</div><div class="sub" style="color:var(--green)">Answer: ' + 'ABCD'[q.correct] + '. ' + esc(q.answers[q.correct]) + '</div></div></div>').join('') : '')
    + '<div class="row" style="margin-top:14px"><button class="btn primary" data-ex="home">Done</button></div>';
  EX.els = (await api('exam')).elements;
}
$('examBody').addEventListener('click', e => {
  const t = e.target.closest('button'); if (!t) return;
  if (t.classList.contains('exa')) { examAnswer(+t.dataset.k); return; }
  if (t.dataset.sub) { examStudy(t.dataset.sub); return; }
  const a = t.dataset.ex;
  if (a === 'exam' || a === 'study' || a === 'missed') examStart(a, +t.dataset.i);
  else if (a === 'next') { EX.i++; examQuestion(); }
  else if (a === 'stop') { if (EX.exam) { EX.qs = EX.qs.slice(0, EX.i); } examResults(); }
  else if (a === 'home') loadExam();
});
document.addEventListener('keydown', e => {
  if (S.page !== 'exam' || /INPUT|SELECT|TEXTAREA/.test(document.activeElement.tagName)) return;
  const k = 'abcd'.indexOf(e.key.toLowerCase()); if (k >= 0 && document.querySelectorAll('.exa')[k]) examAnswer(k);
  if (e.key === 'Enter') { const n = document.querySelector('[data-ex="next"]'); if (n) n.click(); }
});
