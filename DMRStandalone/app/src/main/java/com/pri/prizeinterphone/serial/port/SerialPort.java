package com.pri.prizeinterphone.serial.port;

import android.content.Context;
import android.util.Log;

import java.io.File;
import java.io.FileDescriptor;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.InputStream;
import java.io.OutputStream;

/**
 * The stock walkie-talkie app's own serial opener (the classic android-serialport-api JNI: open the tty
 * O_RDWR, cfsetispeed/cfsetospeed + tcsetattr, hand back the fd). The library ships on /system of every
 * phone this radio family runs on, and its JNI symbols are bound to this exact class name, which is why the
 * class lives in the stock app's package. Using it means the line is configured the way the firmware was
 * tested with and needs no stty and no root: toybox's stty on the MT6577 UART reports success but leaves
 * the port at 9600 after a cold boot (measured 2026-10-17).
 */
public final class SerialPort {
    private static final String TAG = "SerialPort";
    private static volatile boolean loaded;

    private FileDescriptor mFd;            // read by the native close()

    private static native FileDescriptor open(String path, int baud, int flags);
    public native void close();

    /** Copy the system library into our own files dir (the app linker namespace cannot load it from /system) and load it. */
    public static synchronized boolean load(Context ctx, String systemLib) {
        if (loaded) return true;
        if (systemLib == null) return false;
        try {
            File src = new File(systemLib);
            File dir = new File(ctx.getFilesDir(), "lib"); dir.mkdirs();
            // the library links the system C++ runtime, which the app linker namespace does not expose either:
            // bring it along the same way (an already-loaded soname satisfies the dependency)
            File dep = new File(src.getParentFile(), "libc++.so");
            if (dep.exists()) { try { System.load(copy(dep, dir).getAbsolutePath()); } catch (Throwable t) { Log.w(TAG, "libc++: " + t); } }
            System.load(copy(src, dir).getAbsolutePath());
            loaded = true;
            return true;
        } catch (Throwable t) {
            Log.w(TAG, "load " + systemLib + ": " + t);
            return false;
        }
    }

    private static File copy(File src, File dir) throws java.io.IOException {
        File dst = new File(dir, src.getName());
        if (!dst.exists() || dst.length() != src.length()) {
            try (InputStream i = new FileInputStream(src); OutputStream o = new FileOutputStream(dst)) {
                byte[] b = new byte[8192]; int n; while ((n = i.read(b)) > 0) o.write(b, 0, n);
            }
        }
        return dst;
    }

    public static boolean isLoaded() { return loaded; }

    /** Open and configure the line; null if the native open failed (the library logs why). */
    public static SerialPort openPort(String path, int baud) {
        if (!loaded) return null;
        SerialPort p = new SerialPort();
        p.mFd = open(path, baud, 0);
        return p.mFd == null ? null : p;
    }

    public FileDescriptor fd() { return mFd; }

    public void release() {
        try { if (mFd != null) close(); } catch (Throwable ignored) { }
        mFd = null;
    }
}
