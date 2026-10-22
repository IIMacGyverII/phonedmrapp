/*
 * SignalDeck - Copyright (C) 2026 IIMacGyverII
 * SPDX-License-Identifier: GPL-3.0-or-later
 * Free software under the GNU General Public License v3 or later, with the additional terms in COPYRIGHT
 * (keep this notice and the author credit, mark modified versions, no rights to the SignalDeck name or icon).
 */
package com.macdmr.radio.pkt;



/**
 * APRS-IS client (backlog F4, 2026-10-17): RX-only iGate + internet beacon + messages for us.
 *
 * One TCP connection to an APRS-IS server (default rotate.aprs2.net:14580), login
 * {@code user CALL-SSID pass N vers DMRModHooks V}, automatic reconnect with back-off. Frames heard
 * on RF are gated to the internet as TNC2 lines with {@code ,qAR,MYCALL} appended ({@link #gate}),
 * subject to the usual rules ({@link #shouldGate}). Lines received from the server are handed to the
 * listener (messages addressed to the login callsign arrive without any filter).
 *
 * Pure Java (sockets only) so the line builders are host-testable.
 */
public class AprsIsClient {

    public interface Listener {
        void onStatus(String status, boolean connected);
        /** A packet line from the server (TNC2, no CR/LF), never a comment. */
        void onServerLine(String line);
    }

    private static final String TAG = "DMRModHooks-APRS-IS";

    private final String host; private final int port;
    private final String login;         // CALL-SSID
    private final String passcode;      // "-1" = receive-only
    private final String version;
    private final String filter;        // optional server-side filter, may be null
    private final Listener listener;

    private volatile java.net.Socket socket;
    private volatile java.io.OutputStream out;
    private volatile boolean running = false;
    private volatile boolean connected = false;
    private volatile boolean verified = false;
    private Thread thread;
    private volatile long lastRxMs = 0;

    public volatile int gatedCount = 0, serverLines = 0, failedCount = 0;
    public volatile String lastStatus = "off";

    public AprsIsClient(String host, int port, String login, String passcode, String version, String filter, Listener l) {
        this.host = host; this.port = port; this.login = login; this.passcode = passcode;
        this.version = version; this.filter = filter; this.listener = l;
    }

    public boolean isConnected() { return connected; }
    public boolean isVerified() { return verified; }
    public String getLogin() { return login; }

    public synchronized void start() {
        if (running) return;
        running = true;
        thread = new Thread(new Runnable() { @Override public void run() { loop(); } }, "dmrmod-aprs-is");
        thread.setDaemon(true);
        thread.start();
    }

    public synchronized void stop() {
        running = false;
        closeQuietly();
        setStatus("off", false);
    }

    private void setStatus(String s, boolean conn) {
        lastStatus = s; connected = conn;
        try { if (listener != null) listener.onStatus(s, conn); } catch (Throwable ignored) { }
    }

    private void closeQuietly() {
        try { java.net.Socket s = socket; if (s != null) s.close(); } catch (Throwable ignored) { }
        socket = null; out = null; connected = false;
    }

    private void loop() {
        int backoffMs = 2000;
        while (running) {
            try {
                setStatus("connecting to " + host + ":" + port, false);
                java.net.Socket s = new java.net.Socket();
                s.connect(new java.net.InetSocketAddress(host, port), 15000);
                s.setSoTimeout(120000);          // servers send a comment every ~20-30 s
                s.setKeepAlive(true);
                socket = s;
                out = s.getOutputStream();
                java.io.BufferedReader in = new java.io.BufferedReader(
                        new java.io.InputStreamReader(s.getInputStream(), java.nio.charset.StandardCharsets.ISO_8859_1));
                String banner = in.readLine();
                android.util.Log.d("aprsis", TAG + ": server: " + banner);
                String loginLine = loginLine();
                send(loginLine);
                android.util.Log.d("aprsis", TAG + ": sent: " + loginLine.replace(" pass " + passcode + " ", " pass **** "));
                lastRxMs = System.currentTimeMillis();
                backoffMs = 2000;
                String line;
                while (running && (line = in.readLine()) != null) {
                    lastRxMs = System.currentTimeMillis();
                    if (line.startsWith("#")) {
                        if (line.contains("logresp")) {
                            verified = line.contains(" verified");
                            String st = (verified ? "logged in (verified)" : "logged in (unverified: receive-only)")
                                    + " at " + serverName(line);
                            android.util.Log.d("aprsis", TAG + ": " + line);
                            setStatus(st, true);
                        }
                        continue;
                    }
                    serverLines++;
                    try { if (listener != null) listener.onServerLine(line); } catch (Throwable t) { android.util.Log.d("aprsis", TAG + ": listener: " + t.getMessage()); }
                }
            } catch (Throwable t) {
                android.util.Log.d("aprsis", TAG + ": connection error: " + t.getMessage());
            }
            closeQuietly();
            verified = false;
            if (!running) break;
            setStatus("disconnected, retry in " + (backoffMs / 1000) + " s", false);
            try { Thread.sleep(backoffMs); } catch (InterruptedException ignored) { }
            backoffMs = Math.min(backoffMs * 2, 120000);
        }
        setStatus("off", false);
    }

    private static String serverName(String logresp) {
        // "# logresp CALL verified, server T2XYZ"
        int i = logresp.indexOf("server ");
        return i >= 0 ? logresp.substring(i + 7).trim() : "?";
    }

    String loginLine() {
        StringBuilder sb = new StringBuilder("user ").append(login).append(" pass ").append(passcode)
                .append(" vers DMRModHooks ").append(version);
        if (filter != null && !filter.trim().isEmpty()) sb.append(" filter ").append(filter.trim());
        return sb.toString();
    }

    /** Sends one line (CRLF appended). Returns false when not connected. */
    public boolean send(String line) {
        try {
            java.io.OutputStream o = out;
            if (o == null) return false;
            synchronized (this) {
                o.write((line + "\r\n").getBytes(java.nio.charset.StandardCharsets.ISO_8859_1));
                o.flush();
            }
            return true;
        } catch (Throwable t) {
            android.util.Log.d("aprsis", TAG + ": send failed: " + t.getMessage());
            closeQuietly();
            return false;
        }
    }

    /** Gates one RF frame (TNC2 "SRC>DST,PATH:info") to the server with ",qAR,LOGIN" appended. */
    public boolean gate(String tnc2) {
        if (!connected) { failedCount++; return false; }
        if (!verified) { failedCount++; return false; }      // the server would drop it anyway
        String line = gatedLine(tnc2, login);
        if (line == null) return false;
        boolean ok = send(line);
        if (ok) gatedCount++; else failedCount++;
        return ok;
    }

    // ------------------------------------------------------------------ pure helpers (tested)

    /**
     * RX-iGate rules: never gate a frame whose path carries TCPIP, TCPXX, NOGATE or RFONLY, a
     * third-party ('}') or an empty/malformed line, or generic queries ("?APRS?").
     */
    public static boolean shouldGate(String tnc2) {
        if (tnc2 == null) return false;
        int gt = tnc2.indexOf('>'), colon = tnc2.indexOf(':', gt);
        if (gt <= 0 || colon < 0 || colon + 1 >= tnc2.length()) return false;
        String path = tnc2.substring(gt + 1, colon).toUpperCase(java.util.Locale.US);
        for (String hop : path.split(",")) {
            String h = hop.replace("*", "");
            if (h.equals("TCPIP") || h.equals("TCPXX") || h.equals("NOGATE") || h.equals("RFONLY")) return false;
        }
        char type = tnc2.charAt(colon + 1);
        if (type == '}') return false;
        if (type == '?') return false;
        return true;
    }

    /** "SRC>DST,PATH,qAR,LOGIN:info" (qAR = received directly from RF by this verified station). */
    public static String gatedLine(String tnc2, String login) {
        if (!shouldGate(tnc2)) return null;
        int gt = tnc2.indexOf('>'), colon = tnc2.indexOf(':', gt);
        return tnc2.substring(0, colon) + ",qAR," + login + tnc2.substring(colon);
    }

    /** TNC2 text of an FCS-stripped AX.25 UI frame (H bits shown as '*'), or null. */
    public static String tnc2FromFrame(byte[] f) {
        try {
            if (f == null || f.length < 16) return null;
            StringBuilder sb = new StringBuilder();
            String dst = addr(f, 0), src = addr(f, 7);
            sb.append(src).append('>').append(dst);
            boolean last = (f[13] & 0x01) != 0;
            int off = 14;
            while (!last && off + 7 <= f.length) {
                sb.append(',').append(addr(f, off));
                if ((f[off + 6] & 0x80) != 0) sb.append('*');
                last = (f[off + 6] & 0x01) != 0;
                off += 7;
            }
            if (off + 2 > f.length) return null;
            if (f[off] != 0x03 || f[off + 1] != (byte) 0xF0) return null;
            String info = new String(f, off + 2, f.length - off - 2, java.nio.charset.StandardCharsets.ISO_8859_1);
            int end = info.length();
            while (end > 0 && (info.charAt(end - 1) == '\r' || info.charAt(end - 1) == '\n')) end--;
            return sb.append(':').append(info, 0, end).toString();
        } catch (Throwable t) {
            return null;
        }
    }

    private static String addr(byte[] f, int off) {
        StringBuilder sb = new StringBuilder();
        for (int i = 0; i < 6; i++) { char c = (char) ((f[off + i] & 0xFF) >> 1); if (c != ' ') sb.append(c); }
        int ssid = (f[off + 6] >> 1) & 0x0F;
        if (ssid != 0) sb.append('-').append(ssid);
        return sb.toString();
    }
}
