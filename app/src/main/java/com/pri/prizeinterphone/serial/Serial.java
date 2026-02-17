package com.pri.prizeinterphone.serial;

import android.util.Log;
import java.io.FileDescriptor;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.nio.channels.FileChannel;

public class Serial {
    private FileDescriptor fd = null;
    private FileChannel fic = null;
    private FileInputStream fis = null;
    private FileChannel foc = null;
    private FileOutputStream fos = null;
    private boolean success = false;

    private static native FileDescriptor open(String str, int i, int i2);

    public native void close();

    static {
        System.loadLibrary("drm");
    }

    public boolean open() {
        if (this.success && this.fd != null) {
            close();
        }
        try {
            Log.i("zyingyong", "/dev/ttyS0 open start");
            FileDescriptor open = open("/dev/ttyS0", 57600, 0);
            this.fd = open;
            if (open == null) {
                Log.i("zyingyong", "fd == null 打开失败");
                this.success = false;
            } else {
                this.success = true;
                this.fis = new FileInputStream(this.fd);
                this.fos = new FileOutputStream(this.fd);
                this.fic = this.fis.getChannel();
                this.foc = this.fos.getChannel();
            }
        } catch (Exception e) {
            e.printStackTrace();
            this.success = false;
            close();
        }
        Log.i("zyingyong", "/dev/ttyS0 open end");
        return this.success;
    }

    public FileChannel getInputChannel() {
        return this.fic;
    }

    public FileChannel getOutputChannel() {
        return this.foc;
    }

    public FileInputStream getInputStream() {
        return this.fis;
    }

    public FileOutputStream getOutputStream() {
        return this.fos;
    }

    public boolean isConnected() {
        return this.success && this.fd != null;
    }
}
