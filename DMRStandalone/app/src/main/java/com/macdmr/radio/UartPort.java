package com.macdmr.radio;

import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;

/**
 * The MCU control UART as plain files. Needs the tty in raw mode at the right baud (the OEM's JNI set it
 * once and the kernel keeps it; {@link RootSetup#ensureTty} re-applies it with stty) and SELinux access
 * (see {@link RootSetup}). A reader thread splits the byte stream into {@link Frame}s and hands anything
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
    private Thread reader;
    private volatile boolean running;

    public UartPort(String path, Listener l) { this.path = path; this.listener = l; }

    public synchronized void open() throws IOException {
        if (in != null) return;
        in = new FileInputStream(path);
        out = new FileOutputStream(path);
        running = true;
        reader = new Thread(this::readLoop, "uart-reader");
        reader.start();
        listener.onLog("UART " + path + " open");
    }

    public synchronized void close() {
        running = false;
        try { if (in != null) in.close(); } catch (IOException ignored) { }
        try { if (out != null) out.close(); } catch (IOException ignored) { }
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
