/*
 * SignalDeck - Copyright (C) 2026 IIMacGyverII
 * SPDX-License-Identifier: GPL-3.0-or-later
 * Free software under the GNU General Public License v3 or later, with the additional terms in COPYRIGHT
 * (keep this notice and the author credit, mark modified versions, no rights to the SignalDeck name or icon).
 */
package com.macdmr.radio;

import java.util.ArrayList;
import java.util.List;
import java.util.Locale;

/**
 * The two update paths (pure, host-tested): **Release** (stable builds: not a pre-release and no "-beta" in the
 * version) and **Beta** (pre-releases). For each path, the newest build newer than the installed one and what every
 * build between the two added, so a tester can see whether a new beta concerns them before installing it.
 */
public final class UpdatePaths {
    private UpdatePaths() { }

    /** What a path offers: its newest build (null if none at all), whether it is newer than ours, and the steps in between, newest first. */
    public static final class Path {
        public Updater.Release newest;
        public boolean newer;
        /** Release path only: you are on a beta newer than the newest release, which can be installed back (with root). */
        public boolean downgrade;
        public final List<Updater.Release> since = new ArrayList<>();
    }

    public static boolean isBeta(Updater.Release r) { return r.prerelease || r.version.contains("-"); }

    /** {@code all}: SignalDeck releases in any order. */
    public static Path path(List<Updater.Release> all, String current, boolean beta) {
        Path p = new Path();
        List<Updater.Release> mine = new ArrayList<>();
        for (Updater.Release r : all) if (isBeta(r) == beta) mine.add(r);
        mine.sort((a, b) -> Updater.compareVersions(b.version, a.version));
        if (mine.isEmpty()) return p;
        p.newest = mine.get(0);
        p.newer = Updater.compareVersions(p.newest.version, current) > 0;
        p.downgrade = !beta && current.contains("-") && Updater.compareVersions(p.newest.version, current) < 0;
        for (Updater.Release r : mine) if (Updater.compareVersions(r.version, current) > 0) p.since.add(r);
        return p;
    }

    /**
     * The part of a release's notes about that build only: the first "## What's new…" section (our beta notes go on to
     * repeat earlier betas and the install guide). Without one, the text before the first warning box or the whole body.
     */
    public static String ownNotes(String body) {
        if (body == null) return "";
        String b = body.replace("\r", "");
        int i = indexOfHeading(b, "what's new"), j;
        if (i >= 0) {
            j = b.indexOf("\n## ", i + 3);
            return b.substring(b.indexOf('\n', i) + 1, j < 0 ? b.length() : j).trim();
        }
        String noWarn = b.replaceAll("(?m)^>.*\n?", "").trim();
        j = noWarn.indexOf("\n## ");
        return (j > 0 ? noWarn.substring(0, j) : noWarn).trim();
    }
    private static int indexOfHeading(String b, String words) {
        int from = 0;
        while (true) {
            int i = b.indexOf("## ", from); if (i < 0) return -1;
            if ((i == 0 || b.charAt(i - 1) == '\n') && b.substring(i + 3, Math.min(b.length(), i + 3 + words.length() + 2)).toLowerCase(Locale.US).startsWith(words)) return i;
            from = i + 3;
        }
    }

    /** GitHub markdown → plain text for a dialog: headings, bold/italic markers, bullets, links, code. */
    public static String plain(String md) {
        if (md == null) return "";
        StringBuilder out = new StringBuilder();
        for (String line : md.replace("\r", "").split("\n")) {
            String l = line;
            if (l.matches("^#{1,6} .*")) l = l.replaceFirst("^#{1,6} ", "").toUpperCase(Locale.ROOT);
            l = l.replaceAll("\\[([^\\]]+)\\]\\(([^)]+)\\)", "$1");
            l = l.replaceAll("\\*\\*([^*]+)\\*\\*", "$1").replaceAll("(?<![\\w*])\\*([^*\\s][^*]*)\\*(?![\\w*])", "$1").replaceAll("`([^`]+)`", "$1");
            l = l.replaceFirst("^(\\s*)[-*] ", "$1• ");
            out.append(l).append('\n');
        }
        return out.toString().replaceAll("\n{3,}", "\n\n").trim();
    }

    /** The changes on a path since the installed version, newest first, each under its version. */
    public static String changes(Path p, int maxChars) {
        StringBuilder b = new StringBuilder();
        for (Updater.Release r : p.since) {
            String n = plain(ownNotes(r.notes));
            b.append("▸ ").append(r.version).append(r.published.isEmpty() ? "" : "  (" + r.published + ")").append('\n').append(n.isEmpty() ? "(no notes)" : n).append("\n\n");
            if (b.length() > maxChars) { b.setLength(maxChars); b.append("…"); break; }
        }
        return b.toString().trim();
    }
}
