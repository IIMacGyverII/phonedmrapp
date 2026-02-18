package com.pri.prizeinterphone.serial.port;

import android.util.Log;
import java.io.FileDescriptor;
import java.io.FileInputStream;
import java.io.FileOutputStream;
/* loaded from: classes4.dex */
public final class SerialPort {
    private static final String TAG = "SerialPort";
    private boolean success = false;
    private FileDescriptor mFd = null;
    private FileInputStream fis = null;
    private FileOutputStream fos = null;

    private static native FileDescriptor open(String str, int i, int i2);

    public native void close();

    public boolean open() {
        if (isConnected()) {
            return true;
        }
        try {
            Log.i(TAG, "/dev/ttyS0 open start");
            FileDescriptor open = open("/dev/ttyS0", 57600, 0);
            this.mFd = open;
            if (open == null) {
                Log.i(TAG, "fd == null 打开失败");
                this.success = false;
            } else {
                this.success = true;
                this.fis = new FileInputStream(this.mFd);
                this.fos = new FileOutputStream(this.mFd);
            }
        } catch (Exception e) {
            e.printStackTrace();
            this.success = false;
            close();
        }
        Log.i(TAG, "/dev/ttyS0 open end,success=" + this.success);
        return this.success;
    }

    /* JADX WARN: Type inference failed for: r0v0, types: [java.io.FileOutputStream, java.io.FileInputStream] */
    public void release() {
        try {
            try {
                FileInputStream fileInputStream = this.fis;
                if (fileInputStream != null) {
                    fileInputStream.close();
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
            try {
                try {
                    FileOutputStream fileOutputStream = this.fos;
                    if (fileOutputStream != null) {
                        fileOutputStream.close();
                    }
                } catch (Exception e2) {
                    e2.printStackTrace();
                }
                try {
                    close();
                } catch (Exception e3) {
                    e3.printStackTrace();
                }
                this.mFd = null;
                this.success = false;
            } finally {
                this.fos = null;
            }
        } finally {
            this.fis = null;
        }
    }

    public FileInputStream getInputStream() {
        return this.fis;
    }

    public FileOutputStream getOutputStream() {
        return this.fos;
    }

    public boolean isConnected() {
        return (!this.success || this.mFd == null || this.fis == null || this.fos == null) ? false : true;
    }

    static {
        System.loadLibrary("interphone_serial_port");
    }
}
