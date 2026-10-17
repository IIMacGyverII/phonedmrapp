package com.dmrmod.hooks;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertFalse;
import static org.junit.Assert.assertNull;
import static org.junit.Assert.assertTrue;

import org.junit.Test;

/** Host tests for the pure parts of {@link AprsIsClient} (backlog F4). */
public class AprsIsClientTest {

    @Test public void gateRules() {
        assertTrue(AprsIsClient.shouldGate("W1AW-9>APDR16,WIDE1-1:=3800.00N/09700.00W>hi"));
        assertTrue(AprsIsClient.shouldGate("W1AW-9>APDR16,N0ABC-1*,WIDE2-1:!3800.00N/09700.00W>"));
        assertFalse(AprsIsClient.shouldGate("W1AW-9>APDR16,TCPIP*,qAC,T2X:=3800.00N/09700.00W>"));
        assertFalse(AprsIsClient.shouldGate("W1AW-9>APDR16,WIDE1-1,NOGATE:=3800.00N/09700.00W>"));
        assertFalse(AprsIsClient.shouldGate("W1AW-9>APDR16,RFONLY:=3800.00N/09700.00W>"));
        assertFalse(AprsIsClient.shouldGate("N0GATE>APRS:}W1AW-9>APDR16,TCPIP,N0GATE*:=3800.00N/09700.00W>"));
        assertFalse(AprsIsClient.shouldGate("W1AW-9>APDR16:?APRS?"));
        assertFalse(AprsIsClient.shouldGate("garbage"));
        assertFalse(AprsIsClient.shouldGate(null));
    }

    @Test public void gatedLineAppendsQar() {
        assertEquals("W1AW-9>APDR16,WIDE1-1,qAR,N0CALL-7:=3800.00N/09700.00W>hi",
                AprsIsClient.gatedLine("W1AW-9>APDR16,WIDE1-1:=3800.00N/09700.00W>hi", "N0CALL-7"));
        assertNull(AprsIsClient.gatedLine("W1AW-9>APDR16,NOGATE:x", "N0CALL-7"));
    }

    @Test public void loginLine() {
        AprsIsClient c = new AprsIsClient("rotate.aprs2.net", 14580, "N0CALL-7", "-1", "4.1", null, null);
        assertEquals("user N0CALL-7 pass -1 vers DMRModHooks 4.1", c.loginLine());
        AprsIsClient f = new AprsIsClient("h", 1, "N0CALL", "12345", "4.1", "m/50", null);
        assertEquals("user N0CALL pass 12345 vers DMRModHooks 4.1 filter m/50", f.loginLine());
    }

    @Test public void tnc2FromFrame() {
        byte[] f = APRSPacketDecoderTest.ax25("W1AW-9", "APDR16", new String[]{"N0ABC-1*", "WIDE2-1"}, "=3800.00N/09700.00W>hi\r");
        assertEquals("W1AW-9>APDR16,N0ABC-1*,WIDE2-1:=3800.00N/09700.00W>hi", AprsIsClient.tnc2FromFrame(f));
        byte[] noPath = APRSPacketDecoderTest.ax25("W1AW", "APRS", new String[0], ">status");
        assertEquals("W1AW>APRS:>status", AprsIsClient.tnc2FromFrame(noPath));
        assertNull(AprsIsClient.tnc2FromFrame(new byte[5]));
    }
}
