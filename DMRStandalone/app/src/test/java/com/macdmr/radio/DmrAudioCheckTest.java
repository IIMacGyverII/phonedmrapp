package com.macdmr.radio;

import static org.junit.Assert.*;

import org.junit.Test;

import java.util.List;

public class DmrAudioCheckTest {
    private static String v(DmrAudioCheck.Facts f) { return String.join(" | ", DmrAudioCheck.verdict(f)); }
    private static DmrAudioCheck.Facts ok() { DmrAudioCheck.Facts f = new DmrAudioCheck.Facts(); f.digitalChannel = true; f.receptions = 2; f.callerReports = 2; f.pcmDuringCalls = 64000; f.pcmTotal = 64000; f.rms = 900; f.musicVolume = 8; f.output = "speaker"; return f; }

    @Test public void customRomWithoutTheVendorClass() {
        DmrAudioCheck.Facts f = ok(); f.classMissing = true; f.binderPresent = true;
        String s = v(f); assertTrue(s, s.contains("PrizeTinyService") && s.contains("analog and DMR alike") && s.contains("still running"));
        assertEquals(1, DmrAudioCheck.verdict(f).size());
    }
    @Test public void radioNeverReportedACall() {
        DmrAudioCheck.Facts f = ok(); f.receptions = 0; f.callerReports = 0; f.pcmDuringCalls = 0;
        assertTrue(v(f).contains("RX group list"));
        f.digitalChannel = false; assertTrue(v(f).contains("NOAA"));
    }
    @Test public void analogStaticDecidesTheAudioPath() {
        DmrAudioCheck.Facts f = ok(); f.digitalChannel = false; f.monTested = true; f.monPcm = 0;
        String s = v(f); assertTrue(s, s.contains("no audio at all") && s.contains("squelch held open")); assertEquals(1, DmrAudioCheck.verdict(f).size());
        f.monPcm = 160000; f.monRms = 5; assertTrue(v(f).contains("silent"));
        f.monRms = 2500; f.receptions = 0; f.pcmDuringCalls = 0; f.rms = -1;      // the path works, just no station: still ends with the playback line
        s = v(f); assertTrue(s, s.contains("The audio path works") && s.contains("No signal opened the squelch") && s.contains("was played"));
        f.receptions = 1; f.pcmDuringCalls = 64000; f.rms = 900;                 // NOAA heard
        s = v(f); assertTrue(s, s.contains("The audio path works") && s.contains("level 900"));
    }
    @Test public void callsButNoAudio() {
        DmrAudioCheck.Facts f = ok(); f.pcmDuringCalls = 0;
        assertTrue(v(f).contains("no audio arrived"));
    }
    @Test public void silentAudio() {
        DmrAudioCheck.Facts f = ok(); f.rms = 3;
        assertTrue(v(f).contains("silent"));
    }
    @Test public void phoneSide() {
        DmrAudioCheck.Facts f = ok(); f.musicVolume = 0; assertTrue(v(f).contains("media volume is 0"));
        f = ok(); f.muted = true; assertTrue(v(f).contains("muted"));
        f = ok(); f.output = "speaker, Bluetooth"; List<String> l = DmrAudioCheck.verdict(f); assertTrue(l.get(l.size() - 1).contains("Bluetooth device is connected"));
        f = ok(); f.audioError = "startRx failed: x"; assertTrue(v(f).contains("did not start"));
    }
    @Test public void outsideTheList() {
        DmrAudioCheck.Facts f = ok(); f.callsOutsideList = 1;
        String s = v(f); assertTrue(s.contains("not in this channel's RX list"));
    }
    @Test public void callerIdsAreShortened() {
        assertEquals("310xxxx", DmrAudioCheck.maskId(3101234));
        assertEquals("123x", DmrAudioCheck.maskId(1234));
        assertEquals("91", DmrAudioCheck.maskId(91));
    }

    @Test public void squelchStuckAfterMon() {
        DmrAudioCheck.Facts f = ok(); f.digitalChannel = false; f.monTested = true; f.monPcm = 160000; f.monRms = 2000;
        f.squelchStuck = true; f.closedBy = 1; assertTrue(v(f).contains("the way the stock app does closed it"));
        f.closedBy = 2; assertTrue(v(f).contains("monitor value 0 closed it"));
        f.closedBy = 0; assertTrue(v(f).contains("neither fix closed it"));
        f.squelchStuck = false; assertFalse(v(f).contains("stayed open"));
    }
}
