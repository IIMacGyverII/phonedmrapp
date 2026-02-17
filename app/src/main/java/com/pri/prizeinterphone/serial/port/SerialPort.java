package com.pri.prizeinterphone.serial.port;

import android.util.Log;
import java.io.FileDescriptor;
import java.io.FileInputStream;
import java.io.FileOutputStream;

public final class SerialPort {
    private static final String TAG = "SerialPort";
    private FileInputStream fis = null;
    private FileOutputStream fos = null;
    private FileDescriptor mFd = null;
    private boolean success = false;

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

    public void release() {
        try {
            FileInputStream fileInputStream = this.fis;
            if (fileInputStream != null) {
                fileInputStream.close();
            }
        } catch (Exception e) {
            e.printStackTrace();
        } catch (Throwable th) {
            this.fis = null;
            throw th;
        }
        this.fis = null;
        try {
            FileOutputStream fileOutputStream = this.fos;
            if (fileOutputStream != null) {
                fileOutputStream.close();
            }
        } catch (Exception e2) {
            e2.printStackTrace();
        } catch (Throwable th2) {
            this.fos = null;
            throw th2;
        }
        this.fos = null;
        try {
            close();
        } catch (Exception e3) {
            e3.printStackTrace();
        }
        this.mFd = null;
        this.success = false;
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
