/*
 * SignalDeck - Copyright (C) 2026 IIMacGyverII
 * SPDX-License-Identifier: GPL-3.0-or-later
 * Free software under the GNU General Public License v3 or later, with the additional terms in COPYRIGHT
 * (keep this notice and the author credit, mark modified versions, no rights to the SignalDeck name or icon).
 */
package com.macdmr.radio;

import static org.junit.Assert.*;

import org.json.JSONArray;
import org.json.JSONObject;
import org.junit.Test;

import java.nio.charset.StandardCharsets;
import java.security.KeyPair;
import java.security.KeyPairGenerator;
import java.security.Signature;
import java.util.Base64;
import java.util.Collections;
import java.util.HashSet;
import java.util.Set;

public class ProfileRegistryTest {
    private static ProfileRegistry.Env phone(String model, String... paths) {
        final Set<String> p = new HashSet<>(java.util.Arrays.asList(paths));
        return new ProfileRegistry.Env() {
            @Override public String manufacturer() { return "Maker"; }
            @Override public String model() { return model; }
            @Override public String device() { return "dev"; }
            @Override public boolean exists(String path) { return p.contains(path); }
        };
    }
    private static JSONObject profile(String id, int rev, String model) throws Exception {
        return new JSONObject().put("id", id).put("revision", rev).put("name", "Test " + id).put("controlPort", "/dev/ttyS0").put("baud", 57600)
                .put("audio", "UART_PCM").put("pcmPort", "/dev/ttyS1").put("pcmBaud", 230400).put("stockApp", "com.x.radio").put("verified", true)
                .put("match", new JSONObject().put("model", new JSONArray().put(model)))
                .put("lineSetup", new JSONArray().put(new JSONArray().put("/sys/a").put("1")));
    }
    private static JSONObject list(JSONArray profiles, JSONArray advisories) throws Exception {
        return new JSONObject().put("format", 1).put("serial", 3).put("profiles", profiles).put("advisories", advisories);
    }

    @Test public void builtInWinsUnlessTheListHasAHigherRevision() throws Exception {
        DeviceProfile armor = DeviceProfile.ARMOR_26_ULTRA;
        JSONObject same = list(new JSONArray().put(profile(armor.id, armor.revision, "armor")), new JSONArray());
        ProfileRegistry.Selection s = ProfileRegistry.select(armor, same, phone("Armor 26"), false, null, "2026-10-21");
        assertSame(armor, s.profile); assertEquals("built-in", s.source);

        JSONObject newer = list(new JSONArray().put(profile(armor.id, armor.revision + 1, "armor")), new JSONArray());
        s = ProfileRegistry.select(armor, newer, phone("Armor 26"), false, null, "2026-10-21");
        assertEquals(armor.revision + 1, s.profile.revision); assertEquals("updated", s.source);
        assertEquals("/sys/a", s.profile.lineSetup[0][0]);

        s = ProfileRegistry.select(armor, newer, phone("Armor 26"), true, null, "2026-10-21");                // "Use the built-in profile"
        assertSame(armor, s.profile);
    }

    @Test public void anUnknownPhoneGetsAMatchingListedProfileOnly() throws Exception {
        DeviceProfile unknown = DeviceProfile.UNKNOWN;
        JSONObject l = list(new JSONArray().put(profile("maker-w6", 1, "w6plus")), new JSONArray());
        assertFalse(ProfileRegistry.select(unknown, l, phone("Other phone"), false, null, "2026-10-21").profile.supported);
        ProfileRegistry.Selection s = ProfileRegistry.select(unknown, l, phone("W6Plus"), false, null, "2026-10-21");
        assertTrue(s.profile.supported); assertEquals("maker-w6", s.profile.id);
    }

    @Test public void advisoriesRestrictByDefaultAndTheOwnerCanOverride() throws Exception {
        DeviceProfile x = DeviceProfile.XPLORE_1;
        JSONArray adv = new JSONArray()
                .put(new JSONObject().put("id", "A1").put("profile", x.id).put("maxRevision", x.revision).put("restrict", "transmit").put("why", "test").put("expires", "2026-12-31"))
                .put(new JSONObject().put("id", "A2").put("profile", x.id).put("maxRevision", x.revision - 1).put("restrict", "profile"))            // fixed already
                .put(new JSONObject().put("id", "A3").put("profile", x.id).put("restrict", "profile").put("expires", "2026-01-01"))               // lapsed
                .put(new JSONObject().put("id", "A4").put("profile", "someone-else").put("restrict", "profile"));
        ProfileRegistry.Selection s = ProfileRegistry.select(x, list(new JSONArray(), adv), phone("Xplore"), false, null, "2026-10-21");
        assertEquals(1, s.advisories.size()); assertEquals("A1", s.advisories.get(0).id);
        assertTrue(s.profile.txBlocked); assertTrue(s.profile.supported); assertEquals("A1", s.profile.restrictedBy);

        s = ProfileRegistry.select(x, list(new JSONArray(), adv), phone("Xplore"), false, Collections.singleton("A1"), "2026-10-21");
        assertTrue(s.advisories.get(0).overridden); assertFalse(s.profile.txBlocked);

        JSONArray whole = new JSONArray().put(new JSONObject().put("id", "B").put("profile", x.id).put("restrict", "profile"));
        s = ProfileRegistry.select(x, list(new JSONArray(), whole), phone("Xplore"), false, null, "2026-10-21");
        assertFalse(s.profile.supported);
        assertTrue("the built-in constant itself is never changed", x.supported && !x.txBlocked);
    }

    @Test public void onlyTheProjectKeyCanSignTheList() throws Exception {
        KeyPairGenerator g = KeyPairGenerator.getInstance("EC"); g.initialize(256);
        KeyPair kp = g.generateKeyPair();
        byte[] data = "{\"serial\":1}".getBytes(StandardCharsets.UTF_8);
        Signature sg = Signature.getInstance("SHA256withECDSA"); sg.initSign(kp.getPrivate()); sg.update(data);
        String sig = Base64.getEncoder().encodeToString(sg.sign()), pub = Base64.getEncoder().encodeToString(kp.getPublic().getEncoded());
        assertTrue(ProfileRegistry.verify(data, sig, pub));
        assertFalse(ProfileRegistry.verify("{\"serial\":2}".getBytes(StandardCharsets.UTF_8), sig, pub));
        assertFalse("not signed by the project's key", ProfileRegistry.verify(data, sig, ProfileRegistry.PUBLIC_KEY));
    }
}
