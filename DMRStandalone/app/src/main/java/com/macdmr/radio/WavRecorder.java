/*
 * SignalDeck - Copyright (C) 2026 IIMacGyverII
 * SPDX-License-Identifier: GPL-3.0-or-later
 * Free software under the GNU General Public License v3 or later, with the additional terms in COPYRIGHT
 * (keep this notice and the author credit, mark modified versions, no rights to the SignalDeck name or icon).
 */
package com.macdmr.radio;

import java.io.File;
import java.io.IOException;
import java.io.RandomAccessFile;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Locale;

/**
 * Records one reception to a proper 8 kHz mono 16-bit WAV in Download/DMR/Audio/<channel>/yyyyMMdd_HHmmss[_caller].wav
 * (the folder layout the module uses, but at the radio's true sample rate instead of the doubled stream).
 */
public final class WavRecorder {
    private RandomAccessFile raf;
    private File file;
    private long dataBytes;
    private final String folder;

    public WavRecorder(String channelName) {
        folder = channelName == null ? "Unknown" : channelName.replaceAll("[\\\\/:*?\"<>|]", "");
    }

    public synchronized void start(String callerSuffix) throws IOException {
        File dir = new File(android.os.Environment.getExternalStoragePublicDirectory(android.os.Environment.DIRECTORY_DOWNLOADS), "DMR/Audio/" + folder);
        if (!dir.exists() && !dir.mkdirs()) throw new IOException("cannot create " + dir);
        String name = new SimpleDateFormat("yyyyMMdd_HHmmss", Locale.US).format(new Date()) + (callerSuffix == null || callerSuffix.isEmpty() ? "" : "_" + callerSuffix) + ".wav";
        file = new File(dir, name);
        raf = new RandomAccessFile(file, "rw");
        raf.write(new byte[44]);          // header written on close
        dataBytes = 0;
    }

    public synchronized boolean isRecording() { return raf != null; }
    public synchronized File file() { return file; }

    public synchronized void write(byte[] mono, int len) throws IOException { if (raf != null) { raf.write(mono, 0, len); dataBytes += len; } }

    /** @return the finished file, or null if it was too short to keep (< 0.5 s). */
    public synchronized File stop() throws IOException {
        if (raf == null) return null;
        File f = file;
        if (dataBytes < 8000) { raf.close(); raf = null; f.delete(); file = null; return null; }
        raf.seek(0);
        raf.write(header((int) dataBytes, 8000, 1, 16));
        raf.close(); raf = null; file = null;
        return f;
    }

    static byte[] header(int dataLen, int rate, int channels, int bits) {
        int byteRate = rate * channels * bits / 8;
        java.nio.ByteBuffer b = java.nio.ByteBuffer.allocate(44).order(java.nio.ByteOrder.LITTLE_ENDIAN);
        b.put("RIFF".getBytes()).putInt(36 + dataLen).put("WAVE".getBytes()).put("fmt ".getBytes()).putInt(16).putShort((short) 1).putShort((short) channels)
                .putInt(rate).putInt(byteRate).putShort((short) (channels * bits / 8)).putShort((short) bits).put("data".getBytes()).putInt(dataLen);
        return b.array();
    }
}
