/*
 * SignalDeck - Copyright (C) 2026 IIMacGyverII
 * SPDX-License-Identifier: GPL-3.0-or-later
 * Free software under the GNU General Public License v3 or later, with the additional terms in COPYRIGHT
 * (keep this notice and the author credit, mark modified versions, no rights to the SignalDeck name or icon).
 */
package com.macdmr.radio.ham;

/**
 * SGP4 orbit propagation for near-earth satellites (period under 225 minutes: the ISS and the amateur FM
 * satellites), following Vallado's revised implementation (AIAA 2006-6753) with WGS-72 constants. Positions are in
 * the TEME frame, km and km/s. Deep-space (SDP4) objects are not handled: {@link #deepSpace} tells.
 */
public final class Sgp4 {
    // WGS-72
    static final double MU = 398600.8, RE = 6378.135, XKE = 60.0 / Math.sqrt(RE * RE * RE / MU), J2 = 0.001082616, J3 = -0.00000253881, J4 = -0.00000165597, J3OJ2 = J3 / J2;
    static final double TWOPI = 2 * Math.PI, X2O3 = 2.0 / 3.0, VKMPERSEC = RE * XKE / 60.0;

    public final String name; public final int catalog;
    public final double epochJd;                                    // Julian date of the element set epoch (UTC)
    final double ecco, inclo, nodeo, argpo, mo, bstar, no;          // no: un-Kozai'd mean motion, rad/min
    public final boolean deepSpace;
    private int isimp;
    private double aycof, con41, cc1, cc4, cc5, d2, d3, d4, delmo, eta, argpdot, omgcof, sinmao, t2cof, t3cof, t4cof, t5cof, x1mth2, x7thm1, mdot, nodedot, xlcof, xmcof, nodecf;

    /** From the two lines of a TLE. */
    public Sgp4(String name, String line1, String line2) {
        this.name = name == null ? "" : name.trim();
        catalog = Integer.parseInt(line1.substring(2, 7).trim());
        int yy = Integer.parseInt(line1.substring(18, 20).trim()); double day = Double.parseDouble(line1.substring(20, 32).trim());
        int year = yy < 57 ? 2000 + yy : 1900 + yy;
        epochJd = jd(year, 1, 1, 0, 0, 0) - 1 + day;
        bstar = expo(line1.substring(53, 61));
        inclo = Math.toRadians(Double.parseDouble(line2.substring(8, 16).trim()));
        nodeo = Math.toRadians(Double.parseDouble(line2.substring(17, 25).trim()));
        ecco = Double.parseDouble("0." + line2.substring(26, 33).trim());
        argpo = Math.toRadians(Double.parseDouble(line2.substring(34, 42).trim()));
        mo = Math.toRadians(Double.parseDouble(line2.substring(43, 51).trim()));
        double noKozai = Double.parseDouble(line2.substring(52, 63).trim()) * TWOPI / 1440.0;

        // initl: un-Kozai the mean motion
        double cosio = Math.cos(inclo), cosio2 = cosio * cosio, eccsq = ecco * ecco, omeosq = 1 - eccsq, rteosq = Math.sqrt(omeosq);
        double ak = Math.pow(XKE / noKozai, X2O3);
        double d1 = 0.75 * J2 * (3 * cosio2 - 1) / (rteosq * omeosq);
        double del = d1 / (ak * ak);
        double adel = ak * (1 - del * del - del * (1.0 / 3.0 + 134 * del * del / 81));
        del = d1 / (adel * adel);
        no = noKozai / (1 + del);
        deepSpace = TWOPI / no >= 225;
        double ao = Math.pow(XKE / no, X2O3), sinio = Math.sin(inclo), po = ao * omeosq, con42 = 1 - 5 * cosio2;
        con41 = -con42 - cosio2 - cosio2;
        double posq = po * po, rp = ao * (1 - ecco);

        // sgp4init (near earth)
        isimp = rp < 220 / RE + 1 ? 1 : 0;
        double sfour = 78 / RE + 1, qzms24 = Math.pow((120 - 78) / RE, 4), perige = (rp - 1) * RE;
        if (perige < 156) { sfour = perige - 78; if (perige < 98) sfour = 20; qzms24 = Math.pow((120 - sfour) / RE, 4); sfour = sfour / RE + 1; }
        double pinvsq = 1 / posq, tsi = 1 / (ao - sfour);
        eta = ao * ecco * tsi;
        double etasq = eta * eta, eeta = ecco * eta, psisq = Math.abs(1 - etasq), coef = qzms24 * Math.pow(tsi, 4), coef1 = coef / Math.pow(psisq, 3.5);
        double cc2 = coef1 * no * (ao * (1 + 1.5 * etasq + eeta * (4 + etasq)) + 0.375 * J2 * tsi / psisq * con41 * (8 + 3 * etasq * (8 + etasq)));
        cc1 = bstar * cc2;
        double cc3 = ecco > 1e-4 ? -2 * coef * tsi * J3OJ2 * no * sinio / ecco : 0;
        x1mth2 = 1 - cosio2;
        cc4 = 2 * no * coef1 * ao * omeosq * (eta * (2 + 0.5 * etasq) + ecco * (0.5 + 2 * etasq) - J2 * tsi / (ao * psisq) * (-3 * con41 * (1 - 2 * eeta + etasq * (1.5 - 0.5 * eeta)) + 0.75 * x1mth2 * (2 * etasq - eeta * (1 + etasq)) * Math.cos(2 * argpo)));
        cc5 = 2 * coef1 * ao * omeosq * (1 + 2.75 * (etasq + eeta) + eeta * etasq);
        double cosio4 = cosio2 * cosio2, temp1 = 1.5 * J2 * pinvsq * no, temp2 = 0.5 * temp1 * J2 * pinvsq, temp3 = -0.46875 * J4 * pinvsq * pinvsq * no;
        mdot = no + 0.5 * temp1 * rteosq * con41 + 0.0625 * temp2 * rteosq * (13 - 78 * cosio2 + 137 * cosio4);
        argpdot = -0.5 * temp1 * con42 + 0.0625 * temp2 * (7 - 114 * cosio2 + 395 * cosio4) + temp3 * (3 - 36 * cosio2 + 49 * cosio4);
        double xhdot1 = -temp1 * cosio;
        nodedot = xhdot1 + (0.5 * temp2 * (4 - 19 * cosio2) + 2 * temp3 * (3 - 7 * cosio2)) * cosio;
        omgcof = bstar * cc3 * Math.cos(argpo);
        xmcof = ecco > 1e-4 ? -X2O3 * coef * bstar / eeta : 0;
        nodecf = 3.5 * omeosq * xhdot1 * cc1;
        t2cof = 1.5 * cc1;
        xlcof = Math.abs(cosio + 1) > 1.5e-12 ? -0.25 * J3OJ2 * sinio * (3 + 5 * cosio) / (1 + cosio) : -0.25 * J3OJ2 * sinio * (3 + 5 * cosio) / 1.5e-12;
        aycof = -0.5 * J3OJ2 * sinio;
        delmo = Math.pow(1 + eta * Math.cos(mo), 3);
        sinmao = Math.sin(mo);
        x7thm1 = 7 * cosio2 - 1;
        if (isimp != 1) {
            double cc1sq = cc1 * cc1;
            d2 = 4 * ao * tsi * cc1sq;
            double temp = d2 * tsi * cc1 / 3;
            d3 = (17 * ao + sfour) * temp;
            d4 = 0.5 * temp * ao * tsi * (221 * ao + 31 * sfour) * cc1;
            t3cof = d2 + 2 * cc1sq;
            t4cof = 0.25 * (3 * d3 + cc1 * (12 * d2 + 10 * cc1sq));
            t5cof = 0.2 * (3 * d4 + 12 * cc1 * d3 + 6 * d2 * d2 + 15 * cc1sq * (2 * d2 + cc1sq));
        }
    }

    /** Position and velocity (TEME, km, km/s) {@code t} minutes after the epoch: {x, y, z, vx, vy, vz}. */
    public double[] propagate(double t) {
        double xmdf = mo + mdot * t, argpdf = argpo + argpdot * t, nodedf = nodeo + nodedot * t;
        double argpm = argpdf, mm = xmdf, t2 = t * t, nodem = nodedf + nodecf * t2;
        double tempa = 1 - cc1 * t, tempe = bstar * cc4 * t, templ = t2cof * t2;
        if (isimp != 1) {
            double delomg = omgcof * t, delm = xmcof * (Math.pow(1 + eta * Math.cos(xmdf), 3) - delmo), temp = delomg + delm;
            mm = xmdf + temp; argpm = argpdf - temp;
            double t3 = t2 * t, t4 = t3 * t;
            tempa = tempa - d2 * t2 - d3 * t3 - d4 * t4;
            tempe = tempe + bstar * cc5 * (Math.sin(mm) - sinmao);
            templ = templ + t3cof * t3 + t4 * (t4cof + t * t5cof);
        }
        double am = Math.pow(XKE / no, X2O3) * tempa * tempa, nm = XKE / Math.pow(am, 1.5), em = ecco - tempe;
        if (em < 1e-6) em = 1e-6;
        mm = mm + no * templ;
        double xlm = mm + argpm + nodem;
        nodem = nodem % TWOPI; argpm = argpm % TWOPI; xlm = xlm % TWOPI; mm = (xlm - argpm - nodem) % TWOPI;
        double sinim = Math.sin(inclo), cosim = Math.cos(inclo);
        double axnl = em * Math.cos(argpm), temp = 1 / (am * (1 - em * em)), aynl = em * Math.sin(argpm) + temp * aycof;
        double xl = mm + argpm + nodem + temp * xlcof * axnl;
        double u = (xl - nodem) % TWOPI, eo1 = u, tem5 = 9999.9, sineo1 = 0, coseo1 = 0; int ktr = 1;
        while (Math.abs(tem5) >= 1e-12 && ktr <= 10) {
            sineo1 = Math.sin(eo1); coseo1 = Math.cos(eo1);
            tem5 = 1 - coseo1 * axnl - sineo1 * aynl;
            tem5 = (u - aynl * coseo1 + axnl * sineo1 - eo1) / tem5;
            if (Math.abs(tem5) >= 0.95) tem5 = tem5 > 0 ? 0.95 : -0.95;
            eo1 += tem5; ktr++;
        }
        double ecose = axnl * coseo1 + aynl * sineo1, esine = axnl * sineo1 - aynl * coseo1, el2 = axnl * axnl + aynl * aynl;
        double pl = am * (1 - el2), rl = am * (1 - ecose), rdotl = Math.sqrt(am) * esine / rl, rvdotl = Math.sqrt(pl) / rl, betal = Math.sqrt(1 - el2);
        temp = esine / (1 + betal);
        double sinu = am / rl * (sineo1 - aynl - axnl * temp), cosu = am / rl * (coseo1 - axnl + aynl * temp);
        double su = Math.atan2(sinu, cosu), sin2u = (cosu + cosu) * sinu, cos2u = 1 - 2 * sinu * sinu;
        temp = 1 / pl;
        double temp1 = 0.5 * J2 * temp, temp2 = temp1 * temp;
        double mrt = rl * (1 - 1.5 * temp2 * betal * con41) + 0.5 * temp1 * x1mth2 * cos2u;
        su = su - 0.25 * temp2 * x7thm1 * sin2u;
        double xnode = nodem + 1.5 * temp2 * cosim * sin2u, xinc = inclo + 1.5 * temp2 * cosim * sinim * cos2u;
        double mvt = rdotl - nm * temp1 * x1mth2 * sin2u / XKE, rvdot = rvdotl + nm * temp1 * (x1mth2 * cos2u + 1.5 * con41) / XKE;
        double sinsu = Math.sin(su), cossu = Math.cos(su), snod = Math.sin(xnode), cnod = Math.cos(xnode), sini = Math.sin(xinc), cosi = Math.cos(xinc);
        double xmx = -snod * cosi, xmy = cnod * cosi;
        double ux = xmx * sinsu + cnod * cossu, uy = xmy * sinsu + snod * cossu, uz = sini * sinsu;
        double vx = xmx * cossu - cnod * sinsu, vy = xmy * cossu - snod * sinsu, vz = sini * cossu;
        return new double[] { mrt * ux * RE, mrt * uy * RE, mrt * uz * RE, (mvt * ux + rvdot * vx) * VKMPERSEC, (mvt * uy + rvdot * vy) * VKMPERSEC, (mvt * uz + rvdot * vz) * VKMPERSEC };
    }

    /** Position and velocity at a time (ms since 1970, UTC). */
    public double[] at(long utcMs) { return propagate((jdOf(utcMs) - epochJd) * 1440.0); }

    static double expo(String s) {                                  // " 28098-4" -> 0.28098e-4
        String t = s.trim(); if (t.isEmpty()) return 0;
        int sign = 1; if (t.charAt(0) == '-') { sign = -1; t = t.substring(1); } else if (t.charAt(0) == '+') t = t.substring(1);
        int e = t.lastIndexOf('-') > 0 ? t.lastIndexOf('-') : t.lastIndexOf('+');
        if (e <= 0) return sign * Double.parseDouble("0." + t);
        return sign * Double.parseDouble("0." + t.substring(0, e)) * Math.pow(10, Integer.parseInt(t.substring(e)));
    }
    public static double jd(int y, int mon, int d, int h, int mi, double s) {
        return 367.0 * y - Math.floor(7 * (y + Math.floor((mon + 9) / 12.0)) * 0.25) + Math.floor(275 * mon / 9.0) + d + 1721013.5 + ((s / 60.0 + mi) / 60.0 + h) / 24.0;
    }
    public static double jdOf(long utcMs) { return utcMs / 86_400_000.0 + 2440587.5; }
    /** Greenwich mean sidereal time (radians) at a Julian date (UT1 ≈ UTC). */
    public static double gmst(double jdut1) {
        double tut1 = (jdut1 - 2451545.0) / 36525.0;
        double temp = -6.2e-6 * tut1 * tut1 * tut1 + 0.093104 * tut1 * tut1 + (876600.0 * 3600 + 8640184.812866) * tut1 + 67310.54841;
        temp = (Math.toRadians(temp) / 240.0) % TWOPI;
        return temp < 0 ? temp + TWOPI : temp;
    }
}
