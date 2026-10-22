package com.macdmr.radio;

import static org.junit.Assert.*;

import org.junit.Test;

import java.util.List;
import java.util.Map;

public class CustomPttKeyTest {
    private static final String PL = String.join("\n",
            "add device 1: /dev/input/event0",
            "  name:     \"ACCDET\"",
            "  events:",
            "    KEY (0001): KEY_VOLUMEDOWN        KEY_VOLUMEUP          KEY_PLAYPAUSE         KEY_VOICECOMMAND     ",
            "    SW  (0005): SW_HEADPHONE_INSERT   SW_MICROPHONE_INSERT  SW_LINEOUT_INSERT     SW_JACK_PHYSICAL_INS    ",
            "add device 2: /dev/input/event3",
            "  name:     \"uinput-fortsense\"",
            "  events:",
            "    KEY (0001): KEY_ENTER             KEY_F11               KEY_HOME              KEY_UP               ",
            "add device 3: /dev/input/event2",
            "  name:     \"ILITEK_TDDI\"",
            "  events:",
            "    KEY (0001): KEY_W                 KEY_E                 KEY_POWER             BTN_TOUCH            ",
            "    ABS (0003): ABS_MT_SLOT           : value 0, min 0, max 9, fuzz 0, flat 0, resolution 0",
            "                ABS_MT_POSITION_X     : value 0, min 0, max 1079, fuzz 0, flat 0, resolution 0",
            "add device 4: /dev/input/event1",
            "  name:     \"mtk-kpd\"",
            "  events:",
            "    KEY (0001): KEY_VOLUMEDOWN        KEY_VOLUMEUP          KEY_POWER             KEY_SAT              ",
            "                KEY_CD               ",
            "  input props:",
            "    <none>");

    private static CustomPttKey.Seen held(long ms) { CustomPttKey.Seen s = new CustomPttKey.Seen(); s.holdMs = ms; return s; }

    @Test public void parsesDevicesKeysAndTouch() {
        Map<String, CustomPttKey.Device> d = CustomPttKey.parseDevices(PL);
        assertEquals(4, d.size());
        CustomPttKey.Device kpd = d.get("/dev/input/event1");
        assertEquals("mtk-kpd", kpd.name);
        assertTrue(kpd.keys.contains("KEY_CD") && kpd.keys.contains("KEY_SAT")); assertFalse(kpd.touch);
        assertTrue(d.get("/dev/input/event2").touch);
        assertFalse(d.get("/dev/input/event0").keys.contains("SW_HEADPHONE_INSERT"));
        CustomPttKey.addBus(d, "I: Bus=0019 Vendor=2454 Product=6500 Version=0010\nN: Name=\"mtk-kpd\"\nH: Handlers=event1\n");
        assertEquals("0019", kpd.bus);
    }

    @Test public void parsesEventLines() {
        CustomPttKey.Event e = CustomPttKey.parse("/dev/input/event1: EV_KEY       KEY_VOLUMEUP         DOWN                ");
        assertEquals("/dev/input/event1", e.path); assertEquals("KEY_VOLUMEUP", e.code); assertEquals(1, e.value);
        e = CustomPttKey.parse("EV_KEY       KEY_CD               UP                  ");
        assertNull(e.path); assertEquals(0, e.value);
        e = CustomPttKey.parse("[   73.123456] /dev/input/event1: EV_KEY       KEY_SAT              REPEAT");
        assertEquals(2, e.value);
        assertNull(CustomPttKey.parse("EV_SYN       SYN_REPORT           00000000"));
        assertNull(CustomPttKey.parse("add device 1: /dev/input/event0"));
    }

    @Test public void aGoodSideKeyHasNoFindings() {
        CustomPttKey.Device kpd = CustomPttKey.parseDevices(PL).get("/dev/input/event1");
        assertTrue(CustomPttKey.check(kpd, "KEY_CD", held(1800)).isEmpty());
    }

    @Test public void blocksWhatCannotBePtt() {
        Map<String, CustomPttKey.Device> d = CustomPttKey.parseDevices(PL);
        assertTrue(CustomPttKey.blocked(CustomPttKey.check(d.get("/dev/input/event1"), "KEY_POWER", held(1500))));
        assertTrue(CustomPttKey.blocked(CustomPttKey.check(d.get("/dev/input/event2"), "KEY_W", held(1500))));          // touch-screen gesture
        assertTrue(CustomPttKey.blocked(CustomPttKey.check(d.get("/dev/input/event3"), "KEY_UP", held(1500))));         // fingerprint sensor
        assertTrue(CustomPttKey.blocked(CustomPttKey.check(d.get("/dev/input/event1"), "KEY_CD", held(40))));           // no hold
        assertTrue(CustomPttKey.blocked(CustomPttKey.check(d.get("/dev/input/event1"), "KEY_CD", held(-1))));           // no release
        CustomPttKey.Seen s = held(1500); s.officialPtt = true;
        assertTrue(CustomPttKey.blocked(CustomPttKey.check(d.get("/dev/input/event1"), "KEY_SAT", s)));                 // already the PTT key
    }

    @Test public void warnsAboutSideEffects() {
        Map<String, CustomPttKey.Device> d = CustomPttKey.parseDevices(PL);
        CustomPttKey.Seen s = held(1500); s.volPtt = true;
        List<CustomPttKey.Finding> f = CustomPttKey.check(d.get("/dev/input/event1"), "KEY_VOLUMEUP", s);
        assertFalse(CustomPttKey.blocked(f)); assertEquals(2, f.size());
        f = CustomPttKey.check(d.get("/dev/input/event0"), "KEY_VOLUMEUP", s);                                          // the headset's: not the volume-up switch's key
        assertEquals(1, f.size());
        s = held(1500); s.opened.add("com.example.sos");
        f = CustomPttKey.check(d.get("/dev/input/event1"), "KEY_CD", s);
        assertFalse(CustomPttKey.blocked(f)); assertTrue(f.get(0).text.contains("com.example.sos"));
        assertFalse(CustomPttKey.check(d.get("/dev/input/event0"), "KEY_PLAYPAUSE", held(1500)).isEmpty());
    }

    @Test public void findsAppsThatCameToTheFront() {
        String ev = "10-21 19:07:46.510  1403  1876 I wm_set_resumed_activity: [0,com.macdmr.radio/.MainActivity,resumeTopActivity]\n"
                + "10-21 19:07:47.510  1403  1876 I wm_set_resumed_activity: [0,com.example.sos/.Alarm,resumeTopActivity]\n"
                + "10-21 19:07:48.510  1403  1876 I am_set_resumed_activity: [0,com.example.sos/.Alarm,x]\n";
        assertEquals(java.util.Collections.singletonList("com.example.sos"), CustomPttKey.openedApps(ev, "com.macdmr.radio"));
    }

    @Test public void friendlyNames() {
        assertEquals("Volume up", CustomPttKey.friendly("mtk-kpd", "KEY_VOLUMEUP"));
        assertEquals("Headset button", CustomPttKey.friendly("ACCDET", "KEY_PLAYPAUSE"));
        assertEquals("Key CD (mtk-kpd)", CustomPttKey.friendly("mtk-kpd", "KEY_CD"));
    }
}
