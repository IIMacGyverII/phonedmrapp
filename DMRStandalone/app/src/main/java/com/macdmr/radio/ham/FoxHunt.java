package com.macdmr.radio.ham;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

/**
 * Fox hunting (radio direction finding). The hunter marks readings: where they stand, the signal strength and,
 * when the phone points at the strongest signal, its compass bearing. The fox is estimated where the bearings
 * cross (weighted least squares, stronger readings count more); without bearings, the strongest spot is the hint.
 *
 * Also the fox transmitter: a beacon of beeps (and the callsign in Morse on amateur channels) every N seconds.
 */
public final class FoxHunt {
    public static final class Mark {
        public final double lat, lon, bearing; public final int dbm; public final long ts;   // bearing in degrees true, NaN = none
        public Mark(double lat, double lon, int dbm, double bearing, long ts) { this.lat = lat; this.lon = lon; this.dbm = dbm; this.bearing = bearing; this.ts = ts; }
        public boolean hasBearing() { return !Double.isNaN(bearing); }
    }

    public static final class Estimate {
        public final double lat, lon; public final boolean fromBearings; public final int used;
        Estimate(double lat, double lon, boolean fromBearings, int used) { this.lat = lat; this.lon = lon; this.fromBearings = fromBearings; this.used = used; }
    }

    private final List<Mark> marks = new ArrayList<>();

    public synchronized void add(Mark m) { marks.add(m); }
    public synchronized void clear() { marks.clear(); }
    public synchronized List<Mark> marks() { return Collections.unmodifiableList(new ArrayList<>(marks)); }
    public synchronized Mark strongest() { Mark b = null; for (Mark m : marks) if (b == null || m.dbm > b.dbm) b = m; return b; }

    private static final double R = 6371000;

    /** Where the fox probably is, or null with no marks. */
    public synchronized Estimate estimate() {
        if (marks.isEmpty()) return null;
        Mark ref = marks.get(0);
        double cos = Math.cos(Math.toRadians(ref.lat));
        int max = Integer.MIN_VALUE; for (Mark m : marks) max = Math.max(max, m.dbm);
        // sum of w (I - d d^T) and w (I - d d^T) p, in metres east/north of the first mark
        double a = 0, b = 0, c = 0, bx = 0, by = 0; int used = 0;
        for (Mark m : marks) {
            if (!m.hasBearing()) continue;
            double px = Math.toRadians(m.lon - ref.lon) * R * cos, py = Math.toRadians(m.lat - ref.lat) * R;
            double th = Math.toRadians(m.bearing), dx = Math.sin(th), dy = Math.cos(th);
            double w = Math.pow(10, (m.dbm - max) / 20.0);
            double m11 = 1 - dx * dx, m12 = -dx * dy, m22 = 1 - dy * dy;
            a += w * m11; b += w * m12; c += w * m22;
            bx += w * (m11 * px + m12 * py); by += w * (m12 * px + m22 * py);
            used++;
        }
        double det = a * c - b * b;
        if (used >= 2 && det > 1e-3 * (a + c) * (a + c)) {          // bearings that are not all parallel
            double x = (c * bx - b * by) / det, y = (a * by - b * bx) / det;
            int ahead = 0, total = 0;                                 // the crossing must lie in front of most bearings
            for (Mark m : marks) {
                if (!m.hasBearing()) continue;
                double px = Math.toRadians(m.lon - ref.lon) * R * cos, py = Math.toRadians(m.lat - ref.lat) * R, th = Math.toRadians(m.bearing);
                if ((x - px) * Math.sin(th) + (y - py) * Math.cos(th) > 0) ahead++;
                total++;
            }
            if (ahead * 2 > total) return new Estimate(ref.lat + Math.toDegrees(y / R), ref.lon + Math.toDegrees(x / (R * cos)), true, used);
        }
        Mark s = strongest();
        return new Estimate(s.lat, s.lon, false, 1);
    }

    // ---- the fox: a beacon on the current channel ------------------------------------------------------

    /** Beeps (alternating 800 / 1200 Hz, 250 ms each) for {@code seconds}, then the Morse ID when given; 8 kHz mono. */
    public static short[] beacon(int seconds, String morseId) {
        int sr = 8000, lead = sr * 3 / 10, beepN = sr / 4, n = seconds * 4;
        short[] id = morseId == null || morseId.isEmpty() ? new short[0] : com.macdmr.radio.coverage.Morse.pcm(morseId, 20, 800);
        short[] out = new short[lead + n * beepN + id.length];
        for (int k = 0; k < n; k++) {
            double hz = k % 2 == 0 ? 800 : 1200;
            for (int i = 0; i < beepN; i++) {
                double env = Math.min(1.0, Math.min(i, beepN - 1 - i) / 80.0);
                out[lead + k * beepN + i] = (short) (14000 * env * Math.sin(2 * Math.PI * hz * i / sr));
            }
        }
        System.arraycopy(id, 0, out, lead + n * beepN, id.length);
        return out;
    }
}
