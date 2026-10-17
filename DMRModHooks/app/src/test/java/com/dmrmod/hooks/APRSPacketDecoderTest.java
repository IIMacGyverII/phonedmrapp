package com.dmrmod.hooks;

import static org.junit.Assert.assertArrayEquals;
import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertFalse;
import static org.junit.Assert.assertNull;
import static org.junit.Assert.assertTrue;

import org.junit.Test;

/**
 * Host unit tests for {@link APRSPacketDecoder} (backlog F2). Every vector was cross-checked with
 * direwolf 1.8 {@code decode_aprs} (scratch script aprs_vectors.py); the expected numbers below are
 * direwolf's. No device needed.
 */
public class APRSPacketDecoderTest {

    private static final double EPS = 0.0002;   // degrees (≈ 20 m)

    /** Minimal AX.25 UI framer (no FCS — the decoder gets FCS-stripped frames). */
    static byte[] ax25(String src, String dst, String[] path, String info) {
        java.io.ByteArrayOutputStream out = new java.io.ByteArrayOutputStream();
        addr(out, dst, false, false);
        addr(out, src, path.length == 0, false);
        for (int i = 0; i < path.length; i++) {
            String p = path[i];
            boolean used = p.endsWith("*");
            if (used) p = p.substring(0, p.length() - 1);
            addr(out, p, i == path.length - 1, used);
        }
        out.write(0x03); out.write(0xF0);
        byte[] b = info.getBytes(java.nio.charset.StandardCharsets.ISO_8859_1);
        out.write(b, 0, b.length);
        return out.toByteArray();
    }

    private static void addr(java.io.ByteArrayOutputStream out, String callSsid, boolean last, boolean hBit) {
        String call = callSsid; int ssid = 0;
        int dash = callSsid.indexOf('-');
        if (dash > 0) { call = callSsid.substring(0, dash); ssid = Integer.parseInt(callSsid.substring(dash + 1)); }
        call = (call + "      ").substring(0, 6);
        for (int i = 0; i < 6; i++) out.write((call.charAt(i) << 1) & 0xFF);
        out.write(0x60 | (ssid << 1) | (last ? 1 : 0) | (hBit ? 0x80 : 0));
    }

    // ---------------------------------------------------------------------------------------

    @Test public void miceStandardWestNorth() {
        // direwolf: MIC-E, JEEP, In Service — N 33 25.6400, W 112 07.6300, 37 km/h, course 251
        APRSPacketDecoder.APRSPacket p = APRSPacketDecoder.decode(
                ax25("W1AW-9", "S3RUVT", new String[]{"WIDE1-1"}, "`(_[n\"Oj/Mic-E test"));
        assertTrue(p.isValid); assertTrue(p.hasPosition);
        assertEquals("W1AW", p.sourceCallsign); assertEquals(9, p.sourceSSID);
        assertEquals(33 + 25.64 / 60, p.latitude, EPS);
        assertEquals(-(112 + 7.63 / 60), p.longitude, EPS);
        assertEquals("In Service", p.miceStatus);
        assertEquals(20 * 1.852, p.speedKmh, 0.01);
        assertEquals(251, p.courseDeg);
        assertEquals('/', p.symbolTable); assertEquals('j', p.symbolCode);
        assertEquals("Mic-E test", p.comment);
        assertArrayEquals(new String[]{"WIDE1-1"}, p.digipeaters);
    }

    @Test public void miceSouthEastLowLongitudeWithAltitudeAndKenwoodMarkers() {
        // direwolf: MIC-E, CAR, Off Duty — S 33 52.0000, E 005 30.5000, 9 km/h, course 90, alt 123 m
        APRSPacketDecoder.APRSPacket p = APRSPacketDecoder.decodeTnc2("VK2ABC-7>SSU2P0:'{:NlRv>/\"57}>altitude=");
        assertTrue(p.hasPosition);
        assertEquals(-(33 + 52.0 / 60), p.latitude, EPS);
        assertEquals(5 + 30.5 / 60, p.longitude, EPS);
        assertEquals("Off Duty", p.miceStatus);
        assertEquals(5 * 1.852, p.speedKmh, 0.01);
        assertEquals(90, p.courseDeg);
        assertEquals(123, p.altitude);
        assertEquals("altitude", p.comment);        // '>' type prefix and '=' suffix stripped
    }

    @Test public void miceLegacyTypeCodeAccepted() {
        APRSPacketDecoder.APRSPacket p = APRSPacketDecoder.decodeTnc2("W1AW-9>S3RUVT:\u001C(_[n\"Oj/x");
        assertTrue(p.hasPosition);
        assertEquals(33 + 25.64 / 60, p.latitude, EPS);
    }

    @Test public void uncompressedWithCourseSpeedAltitude() {
        // direwolf: N 38 00.0000, W 097 00.0000, 65 km/h, course 90, alt 376 m (1234 ft)
        APRSPacketDecoder.APRSPacket p = APRSPacketDecoder.decodeTnc2(
                "N0CALL-7>APDR16,WIDE1-1:=3800.00N/09700.00W>090/035/A=001234 uncompressed test");
        assertTrue(p.hasPosition);
        assertEquals(38.0, p.latitude, EPS); assertEquals(-97.0, p.longitude, EPS);
        assertEquals(90, p.courseDeg); assertEquals(35 * 1.852, p.speedKmh, 0.01);
        assertEquals(376, p.altitude);
        assertEquals("uncompressed test", p.comment);
        assertEquals('>', p.symbolCode);
    }

    @Test public void compressedPosition() {
        // direwolf: N 38 00.0000, W 097 00.0000, 67 km/h, course 88
        APRSPacketDecoder.APRSPacket p = APRSPacketDecoder.decodeTnc2("KB1ABC>APZ001:!/;;!!5z!!>7PAcompressed test");
        assertTrue(p.hasPosition);
        assertEquals(38.0, p.latitude, EPS); assertEquals(-97.0, p.longitude, EPS);
        assertEquals(88, p.courseDeg);
        assertEquals(67.0, p.speedKmh, 1.0);
        assertEquals('/', p.symbolTable); assertEquals('>', p.symbolCode);
        assertEquals("compressed test", p.comment);
    }

    @Test public void objectStoredUnderItsName() {
        // direwolf: Object "REPEATER", N 38 45.5000, W 097 30.2500
        APRSPacketDecoder.APRSPacket p = APRSPacketDecoder.decodeTnc2(
                "K0XYZ-1>APN391:;REPEATER *111111z3845.50N/09730.25WrW1 repeater object");
        assertTrue(p.hasPosition);
        assertEquals("REPEATER", p.objectName);
        assertEquals("REPEATER", p.sourceCallsign); assertEquals(0, p.sourceSSID);
        assertEquals("K0XYZ-1", p.objectFrom);
        assertFalse(p.objectKilled);
        assertEquals(38 + 45.5 / 60, p.latitude, EPS); assertEquals(-(97 + 30.25 / 60), p.longitude, EPS);
        assertEquals('r', p.symbolCode);
        assertEquals("[object from K0XYZ-1] W1 repeater object", p.comment);
    }

    @Test public void killedItem() {
        APRSPacketDecoder.APRSPacket p = APRSPacketDecoder.decodeTnc2("K0XYZ-1>APN391:)AID#1_3845.50N/09730.25W+aid station");
        assertTrue(p.hasPosition);
        assertEquals("AID#1", p.objectName);
        assertEquals("AID_1", p.sourceCallsign);   // file-name safe
        assertTrue(p.objectKilled);
        assertEquals("[deleted object from K0XYZ-1] aid station", p.comment);
    }

    @Test public void messageWithId() {
        APRSPacketDecoder.APRSPacket p = APRSPacketDecoder.decodeTnc2("W1AW>APRS::N0CALL-7 :Hello from the bench{42");
        assertTrue(p.isValid); assertFalse(p.hasPosition); assertTrue(p.isMessage());
        assertEquals("N0CALL-7", p.messageTo);
        assertEquals("Hello from the bench", p.messageText);
        assertEquals("42", p.messageId);
        assertFalse(p.isAck);
    }

    @Test public void ackAndRej() {
        APRSPacketDecoder.APRSPacket a = APRSPacketDecoder.decodeTnc2("N0CALL-7>APRS::W1AW     :ack42");
        assertTrue(a.isMessage()); assertTrue(a.isAck); assertEquals("42", a.messageId); assertEquals("W1AW", a.messageTo);
        APRSPacketDecoder.APRSPacket r = APRSPacketDecoder.decodeTnc2("N0CALL-7>APRS::W1AW     :rej7");
        assertTrue(r.isRej); assertEquals("7", r.messageId);
    }

    @Test public void statusReport() {
        APRSPacketDecoder.APRSPacket p = APRSPacketDecoder.decodeTnc2("KC0ABC-4>APRS:>Mobile, monitoring 146.52");
        assertTrue(p.isValid); assertFalse(p.hasPosition);
        assertEquals("Mobile, monitoring 146.52", p.status);
        APRSPacketDecoder.APRSPacket t = APRSPacketDecoder.decodeTnc2("KC0ABC-4>APRS:>092345zWith timestamp");
        assertEquals("With timestamp", t.status);
    }

    @Test public void nmeaRmc() {
        // direwolf: N 48 07.0380, E 011 31.0000, 41 km/h, course 84
        APRSPacketDecoder.APRSPacket p = APRSPacketDecoder.decodeTnc2(
                "KD0ABC-14>GPS:$GPRMC,123519,A,4807.038,N,01131.000,E,022.4,084.4,230394,003.1,W*6A");
        assertTrue(p.hasPosition);
        assertEquals(48 + 7.038 / 60, p.latitude, EPS); assertEquals(11 + 31.0 / 60, p.longitude, EPS);
        assertEquals(22.4 * 1.852, p.speedKmh, 0.1); assertEquals(84, p.courseDeg);
    }

    @Test public void weatherReportFormatted() {
        APRSPacketDecoder.APRSPacket p = APRSPacketDecoder.decodeTnc2(
                "KW0ABC>APRS:=3800.00N/09700.00W_090/005g012t072r000p000P000h55b10132 wx test");
        assertTrue(p.hasPosition);
        assertEquals('_', p.symbolCode);
        assertEquals("WX: 72°F wind 90° 5 mph gust 12 hum 55% 1013.2 mb (wx test)", p.comment);
    }

    @Test public void positionlessWeatherIsNotAPosition() {
        APRSPacketDecoder.APRSPacket p = APRSPacketDecoder.decodeTnc2("KW0ABC>APRS:_10090556c220s004g005t077r000p000P000h50b09900wRSW");
        assertFalse(p.isValid); assertFalse(p.hasPosition);
        assertTrue(p.comment.startsWith("WX: 77°F wind 220° 4 mph gust 5"));
    }

    @Test public void thirdPartyUnwrapped() {
        APRSPacketDecoder.APRSPacket p = APRSPacketDecoder.decodeTnc2(
                "N0GATE>APRS:}W1AW-9>APDR16,TCPIP,N0GATE*:=3800.00N/09700.00W>via igate");
        assertTrue(p.hasPosition);
        assertEquals("W1AW", p.sourceCallsign); assertEquals(9, p.sourceSSID);
        assertEquals("N0GATE-0", p.thirdPartyVia);
        assertEquals(38.0, p.latitude, EPS);
        assertEquals("via igate", p.comment);
    }

    @Test public void digipeaterHBit() {
        APRSPacketDecoder.APRSPacket p = APRSPacketDecoder.decode(
                ax25("N0CALL-7", "APDR16", new String[]{"W0ABC-1*", "WIDE2-1"}, "!3800.00N/09700.00W-"));
        assertArrayEquals(new String[]{"W0ABC-1*", "WIDE2-1"}, p.digipeaters);
        assertTrue(p.hasPosition);
    }

    @Test public void badCoordinatesRejected() {
        APRSPacketDecoder.APRSPacket p = APRSPacketDecoder.decodeTnc2("N0CALL>APRS:!9999.99N/19999.99W-nope");
        assertFalse(p.isValid); assertFalse(p.hasPosition);
        APRSPacketDecoder.APRSPacket q = APRSPacketDecoder.decodeTnc2("N0CALL>APRS:!0000.00N/00000.00W-null island");
        assertFalse(q.hasPosition);
    }

    @Test public void unsupportedTypeIsInvalidNotCrash() {
        APRSPacketDecoder.APRSPacket p = APRSPacketDecoder.decodeTnc2("N0CALL>APRS:T#005,199,000,255,073,123,01101001");
        assertFalse(p.isValid);
        assertNull(p.messageTo);
    }

    @Test public void trailingCrLfStripped() {
        // Seen on the HackRF bench 2026-10-17: a CRLF-terminated packet file put '\r' at the end of every
        // info field, which hid the Mic-E '=' suffix and put a CR into message texts.
        APRSPacketDecoder.APRSPacket p = APRSPacketDecoder.decodeTnc2("VK2ABC-7>SSU2P0:'{:NlRv>/\"57}>altitude=\r\n");
        assertEquals("altitude", p.comment);
        APRSPacketDecoder.APRSPacket m = APRSPacketDecoder.decodeTnc2("N0CALL-7>APRS::W1AW     :ack42\r");
        assertTrue(m.isAck); assertEquals("42", m.messageId); assertEquals("ack42", m.messageText);
    }

    @Test public void describeIncludesMiceStatusAndSpeed() {
        APRSPacketDecoder.APRSPacket p = APRSPacketDecoder.decodeTnc2("W1AW-9>S3RUVT:`(_[n\"Oj/Mic-E test");
        assertEquals("[In Service] 37 km/h 251° · Mic-E test", APRSPacketDecoder.describe(p));
    }
}
