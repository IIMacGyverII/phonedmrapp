package com.macdmr.radio;

import static org.junit.Assert.*;

import org.junit.Test;

import java.util.ArrayList;
import java.util.List;

public class UpdatePathsTest {
    private static Updater.Release rel(String v, boolean pre, String notes) { Updater.Release r = new Updater.Release(); r.version = v; r.prerelease = pre; r.notes = notes; r.published = "2026-10-22"; return r; }
    private static List<Updater.Release> sample() {
        List<Updater.Release> l = new ArrayList<>();
        l.add(rel("1.0.0-beta.11", true, "> [!WARNING]\n> beta\n\n## What's new in beta.11\n\n**Xplore** squelch fix\n- one\n\n## Also new in beta.10\n\nold stuff\n\n## Install\n..."));
        l.add(rel("1.0.0-beta.10", true, "## What's new in beta.10\n\nRadio audio check\n\n## Also new in beta.9\nolder"));
        l.add(rel("1.0.0-beta.9", true, "## What's new in beta.9\n\nsharing"));
        return l;
    }

    @Test public void betaPathListsOnlyWhatIsNewer() {
        UpdatePaths.Path p = UpdatePaths.path(sample(), "1.0.0-beta.9", true);
        assertTrue(p.newer); assertEquals("1.0.0-beta.11", p.newest.version); assertEquals(2, p.since.size());
        String c = UpdatePaths.changes(p, 10000);
        assertTrue(c, c.contains("1.0.0-beta.11") && c.contains("Xplore squelch fix") && c.contains("\u2022 one") && c.contains("Radio audio check"));
        assertFalse(c, c.contains("old stuff") || c.contains("older") || c.contains("sharing") || c.contains("Install") || c.contains("WARNING"));
        UpdatePaths.Path same = UpdatePaths.path(sample(), "1.0.0-beta.11", true);
        assertFalse(same.newer); assertTrue(same.since.isEmpty()); assertEquals("1.0.0-beta.11", same.newest.version);
    }

    @Test public void releasePathWithAndWithoutReleases() {
        UpdatePaths.Path none = UpdatePaths.path(sample(), "1.0.0-beta.11", false);
        assertNull(none.newest); assertFalse(none.newer);
        List<Updater.Release> l = sample();
        l.add(rel("1.0.0", false, "## What's new\n\nFirst release"));
        l.add(rel("1.1.0", false, "Plain notes without sections"));
        UpdatePaths.Path p = UpdatePaths.path(l, "1.0.0-beta.11", false);
        assertTrue(p.newer); assertEquals("1.1.0", p.newest.version); assertEquals(2, p.since.size());
        assertTrue(UpdatePaths.changes(p, 10000).contains("First release"));
        UpdatePaths.Path fromRelease = UpdatePaths.path(l, "1.1.0", true);           // on a release, older betas are not "newer"
        assertFalse(fromRelease.newer); assertFalse(fromRelease.downgrade);
        UpdatePaths.Path back = UpdatePaths.path(l, "1.2.0-beta.3", false);          // on a beta newer than every release: go back to 1.1.0
        assertFalse(back.newer); assertTrue(back.downgrade); assertEquals("1.1.0", back.newest.version);
        assertFalse(UpdatePaths.path(l, "1.1.0", false).downgrade);                  // on the release itself: nothing to go back to
        assertTrue(UpdatePaths.isBeta(rel("1.2.0-beta.1", false, "")));             // a "-beta" version is a beta even if not flagged
    }

    @Test public void markdownToText() {
        assertEquals("WHAT'S NEW\n\u2022 a link and bold and code", UpdatePaths.plain("## What's new\n- [a link](http://x) and **bold** and `code`"));
    }
}
