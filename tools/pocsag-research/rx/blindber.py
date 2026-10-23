import sys, numpy as np
rxf, eqf, ric, msg = sys.argv[1], sys.argv[2], int(sys.argv[3]), sys.argv[4]
sys.argv = ['blind.py', rxf, eqf]
exec(open('blind.py', encoding='utf-8').read().split('best = None')[0])
ref = np.array(pc.transmission(ric, 3, msg))
best = None
for pol in (1, -1):
    for ph in np.linspace(0, spb, 16, endpoint=False):
        d = run(pol, ph)
        # align: find the reference start by correlating the sync-bearing part
        r = 2 * ref - 1; dd = 2 * d - 1
        c = np.correlate(dd.astype(float), r.astype(float), 'valid')
        for st in np.argsort(-c)[:6]:
            errs = []
            for t in range(3):                                            # three back-to-back transmissions
                a = st + t * len(ref)
                if a + len(ref) <= len(d): errs.append(int((d[a:a + len(ref)] != ref).sum()))
            if len(errs) == 3 and (best is None or sum(errs) < best[0]): best = (sum(errs), pol, ph, st, errs)
print("bit errors per transmission (of %d bits):" % len(ref), best[4], "-> BER %.3f%%" % (100.0 * best[0] / (3 * len(ref))))
