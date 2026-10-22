/*
 * SignalDeck - Copyright (C) 2026 IIMacGyverII
 * SPDX-License-Identifier: GPL-3.0-or-later
 * Free software under the GNU General Public License v3 or later, with the additional terms in COPYRIGHT
 * (keep this notice and the author credit, mark modified versions, no rights to the SignalDeck name or icon).
 */
package com.macdmr.radio;

import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;

/**
 * The MCU control UART as plain files. The line is configured by the stock app's own serial JNI
 * ({@link com.pri.prizeinterphone.serial.port.SerialPort}) when the profile names it, else the tty is
 * opened as a plain file and {@link RootSetup#ensureTty} has to have set raw mode and the baud. SELinux access: see {@link RootSetup}. A reader thread splits the byte stream into {@link Frame}s and hands anything
 * that is not a frame (the module's boot banner, "00 00 BF AA …\r\n") to the listener as raw bytes.
 */
public final class UartPort {
    public interface Listener {
        void onFrame(Frame f);
        void onRaw(byte[] b, int n);      // non-frame bytes (boot banner)
        void onLog(String s);
    }

    private final String path;
    private final Listener listener;
    private FileInputStream in;
    private FileOutputStream out;
    private com.pri.prizeinterphone.serial.port.SerialPort native_;
    private Thread reader;
    private volatile boolean running;

    public UartPort(String path, Listener l) { this.path = path; this.listener = l; }

    public synchronized void open() throws IOException { open(0); }

    /** @param baud 0 = plain file open (line already configured); else configure it through the stock serial JNI. */
    public synchronized void open(int baud) throws IOException {
        if (in != null) return;
        if (baud > 0 && com.pri.prizeinterphone.serial.port.SerialPort.isLoaded()) {
            native_ = com.pri.prizeinterphone.serial.port.SerialPort.openPort(path, baud);
            if (native_ == null) throw new IOException("serial open " + path + " @ " + baud + " failed");
            in = new FileInputStream(native_.fd());
            out = new FileOutputStream(native_.fd());
            listener.onLog("UART " + path + " open @ " + baud + " (stock serial library)");
        } else {
            in = new FileInputStream(path);
            out = new FileOutputStream(path);
            listener.onLog("UART " + path + " open (plain file)");
        }
        running = true;
        reader = new Thread(this::readLoop, "uart-reader");
        reader.start();
    }

    public synchronized void close() {
        running = false;
        try { if (in != null) in.close(); } catch (IOException ignored) { }
        try { if (out != null) out.close(); } catch (IOException ignored) { }
        if (native_ != null) { native_.release(); native_ = null; }
        in = null; out = null;
    }

    public boolean isOpen() { return in != null; }

    public synchronized void send(Frame f) throws IOException {
        if (out == null) throw new IOException("port closed");
        byte[] b = f.encode();
        out.write(b); out.flush();
        listener.onLog("TX " + f + "  <" + Frame.hex(b, b.length) + ">");
    }

    private void readLoop() {
        byte[] buf = new byte[4096]; int n = 0;
        byte[] chunk = new byte[1024];
        Frame[] one = new Frame[1];
        while (running) {
            int r;
            try { r = in.read(chunk); } catch (IOException e) { if (running) listener.onLog("UART read: " + e.getMessage()); break; }
            if (r <= 0) continue;
            if (n + r > buf.length) n = 0;                    // garbage flood: resync
            System.arraycopy(chunk, 0, buf, n, r); n += r;
            int off = 0, rawStart = -1;
            while (off < n) {
                int used = Frame.tryDecode(buf, off, n - off, one);
                if (used > 0) {
                    if (rawStart >= 0) { flushRaw(buf, rawStart, off - rawStart); rawStart = -1; }
                    listener.onFrame(one[0]); off += used;
                } else if (used == 0) {
                    break;                                     // need more bytes for this frame
                } else {
                    if (rawStart < 0) rawStart = off;
                    off++;
                }
            }
            if (rawStart >= 0 && off == n) {                  // trailing non-frame bytes: deliver line-wise
                int end = n;
                // keep a partial frame head that might still complete
                flushRaw(buf, rawStart, end - rawStart); off = end;
            }
            if (off > 0) { System.arraycopy(buf, off, buf, 0, n - off); n -= off; }
        }
    }

    private void flushRaw(byte[] b, int off, int len) {
        if (len <= 0) return;
        byte[] c = new byte[len]; System.arraycopy(b, off, c, 0, len);
        listener.onRaw(c, len);
    }
}
