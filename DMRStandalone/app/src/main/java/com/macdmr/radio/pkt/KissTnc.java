/*
 * SignalDeck - Copyright (C) 2026 IIMacGyverII
 * SPDX-License-Identifier: GPL-3.0-or-later
 * Free software under the GNU General Public License v3 or later, with the additional terms in COPYRIGHT
 * (keep this notice and the author credit, mark modified versions, no rights to the SignalDeck name or icon).
 */
package com.macdmr.radio.pkt;

import android.util.Log;

import java.io.ByteArrayOutputStream;
import java.io.InputStream;
import java.io.OutputStream;
import java.net.InetSocketAddress;
import java.net.ServerSocket;
import java.net.Socket;
import java.util.Arrays;

/**
 * KISS TNC over TCP on localhost (APRSdroid, YAAC, Xastir …): data frames from the client are handed to the
 * listener for transmission; every FCS-valid frame heard on air is delivered to the client as a port-0 data
 * frame. One client at a time.
 */
public final class KissTnc {
    public interface Listener { void onFrameFromClient(byte[] ax25NoFcs); }
    private static final String TAG = "KissTnc";

    private volatile boolean active;
    private ServerSocket server;
    private volatile OutputStream clientOut;
    private volatile int rxFrames, txFrames;
    private int port;

    public boolean isActive() { return active; }
    public boolean clientConnected() { return clientOut != null; }
    public int port() { return port; }
    public int rxFrames() { return rxFrames; }
    public int txFrames() { return txFrames; }

    public synchronized String start(final int port, final Listener l) {
        if (active) return "already running on port " + this.port;
        this.port = port; active = true; rxFrames = txFrames = 0;
        Thread t = new Thread(() -> {
            try {
                server = new ServerSocket(); server.setReuseAddress(true);
                server.bind(new InetSocketAddress("127.0.0.1", port));
                while (active) { Socket c = server.accept(); serve(c, l); }
            } catch (Throwable e) { if (active) Log.w(TAG, "server: " + e); }
        }, "kiss-server");
        t.setDaemon(true); t.start();
        return null;
    }

    public synchronized void stop() {
        active = false;
        try { if (server != null) server.close(); } catch (Throwable ignored) { }
        server = null; clientOut = null;
    }

    /** Deliver a received frame (FCS stripped) to the connected client. */
    public void deliver(byte[] ax25) {
        OutputStream out = clientOut;
        if (!active || out == null || ax25 == null || ax25.length == 0) return;
        rxFrames++;
        try { synchronized (this) { out.write(Ax25.kissEncode(ax25)); out.flush(); } } catch (Throwable t) { Log.w(TAG, "deliver: " + t); }
    }

    private void serve(Socket client, Listener l) {
        final int FEND = 0xC0, FESC = 0xDB, TFEND = 0xDC, TFESC = 0xDD;
        try {
            InputStream in = client.getInputStream();
            clientOut = client.getOutputStream();
            ByteArrayOutputStream buf = new ByteArrayOutputStream();
            boolean inFrame = false, esc = false; int b;
            while (active && (b = in.read()) != -1) {
                b &= 0xFF;
                if (b == FEND) {
                    if (inFrame && buf.size() > 0) {
                        byte[] raw = buf.toByteArray();
                        if ((raw[0] & 0x0F) == 0x00 && raw.length > 1) { txFrames++; l.onFrameFromClient(Arrays.copyOfRange(raw, 1, raw.length)); }
                    }
                    buf.reset(); inFrame = true; esc = false;
                } else if (inFrame) {
                    if (esc) { buf.write(b == TFEND ? FEND : (b == TFESC ? FESC : b)); esc = false; }
                    else if (b == FESC) esc = true;
                    else buf.write(b);
                }
            }
        } catch (Throwable t) { if (active) Log.w(TAG, "client: " + t); }
        finally { clientOut = null; try { client.close(); } catch (Throwable ignored) { } }
    }
}
