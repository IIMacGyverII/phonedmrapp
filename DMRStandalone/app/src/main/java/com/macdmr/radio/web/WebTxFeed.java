package com.macdmr.radio.web;

import com.macdmr.radio.AudioBackend;

/**
 * The browser's microphone as transmit audio: 8 kHz mono 16-bit little-endian blocks arrive over the network with
 * jitter; the radio's TX loop reads them like a microphone, paced to real time. A short pre-buffer absorbs the jitter,
 * gaps are filled with silence, and if the browser runs ahead the oldest audio is dropped so the delay stays small.
 * Pure Java (host-tested); the clock is injectable.
 */
public final class WebTxFeed implements AudioBackend.TxFeed {
    public interface Clock { long nanos(); void sleepNanos(long n) throws InterruptedException; }
    public static final Clock SYSTEM = new Clock() {
        @Override public long nanos() { return System.nanoTime(); }
        @Override public void sleepNanos(long n) throws InterruptedException { Thread.sleep(n / 1_000_000, (int) (n % 1_000_000)); }
    };
    static final int RATE = 8000;
    static final int PREBUFFER_MS = 160, MAX_DELAY_MS = 600;

    private final Clock clock;
    private final byte[] ring = new byte[RATE * 2 * 4];                 // 4 s of audio
    private int head, size;                                            // bytes
    private long start = -1, sentBytes;
    private volatile long lastPush;
    private volatile boolean closed;
    private long dropped, padded;

    public WebTxFeed() { this(SYSTEM); }
    public WebTxFeed(Clock c) { clock = c; lastPush = c.nanos(); }

    /** Audio from the browser (any length; an odd trailing byte is ignored). */
    public synchronized void push(byte[] b, int off, int len) {
        len &= ~1;
        if (len > ring.length) { off += len - ring.length; dropped += len - ring.length; len = ring.length; }
        int over = size + len - ring.length;                           // full: drop the oldest audio first
        if (over > 0) { head = (head + over) % ring.length; size -= over; dropped += over; }
        for (int i = 0; i < len; i++) ring[(head + size + i) % ring.length] = b[off + i];
        size += len;
        int max = RATE * 2 * MAX_DELAY_MS / 1000;
        if (size > max) { int cut = (size - max) & ~1; head = (head + cut) % ring.length; size -= cut; dropped += cut; }    // keep the delay short
        lastPush = clock.nanos();
        notifyAll();
    }
    /** No more audio: the TX loop drains what is left as silence. */
    public synchronized void close() { closed = true; notifyAll(); }
    public boolean closed() { return closed; }
    /** Nanoseconds since the browser last sent audio (the talk watchdog uses it). */
    public long idleNanos() { return clock.nanos() - lastPush; }
    public synchronized long droppedBytes() { return dropped; }
    public synchronized long paddedBytes() { return padded; }

    /** Like AudioRecord.read: returns {@code len} bytes once that much real time has passed since the start. */
    @Override public int read(byte[] buf, int off, int len) {
        len &= ~1;
        try {
            synchronized (this) {
                if (start < 0) {                                       // wait for the pre-buffer (or give up waiting after twice its length)
                    long until = clock.nanos() + 2L * PREBUFFER_MS * 1_000_000;
                    while (size < RATE * 2 * PREBUFFER_MS / 1000 && !closed && clock.nanos() < until) wait(5);
                    start = clock.nanos();
                }
            }
            long due = start + (sentBytes + len) / 2 * 1_000_000_000L / RATE;
            long wait = due - clock.nanos();
            if (wait > 0) clock.sleepNanos(wait);
            synchronized (this) {
                int n = Math.min(len, size);
                for (int i = 0; i < n; i++) buf[off + i] = ring[(head + i) % ring.length];
                head = (head + n) % ring.length; size -= n;
                for (int i = n; i < len; i++) buf[off + i] = 0;
                padded += len - n; sentBytes += len;
            }
            return len;
        } catch (InterruptedException e) { Thread.currentThread().interrupt(); return 0; }
    }
}
