package com.macdmr.radio.pkt;

import static org.junit.Assert.*;

import org.junit.Test;

import java.util.ArrayList;
import java.util.List;
import java.util.Random;

/** Two sessions talking over a simulated channel that can lose frames. */
public class Ax25SessionTest {
    static final class End implements Ax25Session.Link {
        final List<byte[]> outbox = new ArrayList<>(); final StringBuilder got = new StringBuilder(); final List<String> states = new ArrayList<>();
        int transmissions;
        @Override public void send(List<byte[]> frames) { outbox.addAll(frames); transmissions++; }
        @Override public void received(String text) { got.append(text); }
        @Override public void state(String s) { states.add(s); }
    }

    private long now = 0;

    /** Deliver frames both ways (dropping each with probability {@code loss}) and tick, for {@code seconds}. */
    private void run(Ax25Session a, End ea, Ax25Session b, End eb, double loss, int seconds, Random r) {
        for (int k = 0; k < seconds * 2; k++) {
            List<byte[]> fa = new ArrayList<>(ea.outbox), fb = new ArrayList<>(eb.outbox); ea.outbox.clear(); eb.outbox.clear();
            for (byte[] f : fa) if (r.nextDouble() >= loss) b.receive(f, now);
            for (byte[] f : fb) if (r.nextDouble() >= loss) a.receive(f, now);
            now += 500; a.tick(now); b.tick(now);
        }
    }

    @Test public void connectExchangeTextAndDisconnect() {
        End ea = new End(), eb = new End();
        Ax25Session a = new Ax25Session("N0AAA", 7, ea), b = new Ax25Session("N0BBB", 0, eb);
        b.setAcceptIncoming(true);
        Random r = new Random(1);
        a.connect("N0BBB", null, now); run(a, ea, b, eb, 0, 5, r);
        assertEquals(Ax25Session.State.CONNECTED, a.state()); assertEquals(Ax25Session.State.CONNECTED, b.state());
        assertEquals("N0AAA-7", b.peer());
        StringBuilder big = new StringBuilder(); for (int i = 0; i < 40; i++) big.append("line ").append(i).append(" of a long message\n");
        a.sendText(big.toString(), now); b.sendText("Welcome to the BBS\n", now);
        run(a, ea, b, eb, 0, 60, r);
        assertEquals(big.toString(), eb.got.toString());
        assertEquals("Welcome to the BBS\n", ea.got.toString());
        assertEquals(0, a.pending());
        a.disconnect(now); run(a, ea, b, eb, 0, 5, r);
        assertEquals(Ax25Session.State.DISCONNECTED, a.state()); assertEquals(Ax25Session.State.DISCONNECTED, b.state());
    }

    @Test public void survivesLostFrames() {
        End ea = new End(), eb = new End();
        Ax25Session a = new Ax25Session("N0AAA", 7, ea), b = new Ax25Session("N0BBB", 0, eb);
        b.setAcceptIncoming(true);
        Random r = new Random(42);
        a.connect("N0BBB", null, now); run(a, ea, b, eb, 0.2, 60, r);
        assertEquals(Ax25Session.State.CONNECTED, a.state());
        StringBuilder big = new StringBuilder(); for (int i = 0; i < 20; i++) big.append("message ").append(i).append(" xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx\n");
        a.sendText(big.toString(), now);
        run(a, ea, b, eb, 0.2, 600, r);
        assertEquals("every byte, in order, once", big.toString(), eb.got.toString());
    }

    @Test public void refusedWhenNotAccepting() {
        End ea = new End(), eb = new End();
        Ax25Session a = new Ax25Session("N0AAA", 7, ea), b = new Ax25Session("N0BBB", 0, eb);
        a.connect("N0BBB", null, now); run(a, ea, b, eb, 0, 5, new Random(3));
        assertEquals(Ax25Session.State.DISCONNECTED, a.state());
        assertTrue(ea.states.get(ea.states.size() - 1).contains("busy or refused"));
    }

    @Test public void givesUpWithoutAnAnswer() {
        End ea = new End();
        Ax25Session a = new Ax25Session("N0AAA", 7, ea);
        a.connect("N0ZZZ", new String[] { "WIDE1-1" }, now);
        for (int k = 0; k < 400; k++) { now += 500; a.tick(now); }
        assertEquals(Ax25Session.State.DISCONNECTED, a.state());
        assertTrue(ea.states.get(ea.states.size() - 1).contains("no answer"));
        assertEquals("first try plus 5 retries", 6, ea.transmissions);
    }

    @Test public void cancellingAConnectStopsTheRetries() {
        End ea = new End();
        Ax25Session a = new Ax25Session("N0AAA", 7, ea);
        a.connect("N0ZZZ", null, now); now += 3000; a.disconnect(now);
        for (int k = 0; k < 200; k++) { now += 500; a.tick(now); }
        assertEquals("one SABM, no retries after cancel", 1, ea.transmissions);
        assertEquals("[connecting to N0ZZZ, disconnected: cancelled]", ea.states.toString());
    }

    @Test public void framesUseTheRightAddressBits() {
        End ea = new End();
        Ax25Session a = new Ax25Session("N0AAA", 7, ea);
        a.connect("N0BBB-3", new String[] { "RELAY" }, now);
        byte[] f = ea.outbox.get(0);
        assertEquals("N0BBB", Ax25Session.addr(f, 0)); assertEquals(3, (f[6] >> 1) & 15);
        assertTrue("command: destination C bit set", (f[6] & 0x80) != 0); assertTrue("source C bit clear", (f[13] & 0x80) == 0);
        assertEquals("RELAY", Ax25Session.addr(f, 14)); assertEquals("last address", 1, f[20] & 1);
        assertEquals("SABM with P", 0x3F, f[21] & 0xFF);
    }
}
