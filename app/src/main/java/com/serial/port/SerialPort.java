package com.serial.port;

import android.util.Log;
import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import java.io.File;
import java.io.FileDescriptor;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.nio.channels.FileChannel;

public final class SerialPort {
    public static final String DEFAULT_SU_PATH = "/system/bin/su";
    private static final String TAG = "SerialPort";
    private static String sSuPath = "/system/bin/su";
    private int baudrate;
    private int dataBits;
    private File device;
    private FileDescriptor fd;
    private FileChannel fic;
    private FileInputStream fis;
    private int flags;
    private FileChannel foc;
    private FileOutputStream fos;
    private FileDescriptor mFd;
    private FileInputStream mFileInputStream;
    private FileOutputStream mFileOutputStream;
    private int parity;
    private int stopBits;
    private boolean success;

    private static native FileDescriptor open(String str, int i, int i2);

    public native void close();

    public SerialPort() {
        this.success = false;
        this.fd = null;
        this.fic = null;
        this.foc = null;
        this.fis = null;
        this.fos = null;
    }

    public boolean open() {
        if (this.success) {
            return true;
        }
        try {
            Log.i(TAG, "/dev/ttyS0 open start");
            FileDescriptor open = open("/dev/ttyS0", 57600, 0);
            this.fd = open;
            if (open == null) {
                Log.i(TAG, "fd == null 打开失败");
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
        }
        try {
            FileOutputStream fileOutputStream = this.fos;
            if (fileOutputStream != null) {
                fileOutputStream.close();
            }
        } catch (Exception e2) {
            e2.printStackTrace();
        }
        try {
            FileChannel fileChannel = this.fic;
            if (fileChannel != null) {
                fileChannel.close();
            }
        } catch (Exception e3) {
            e3.printStackTrace();
        }
        try {
            FileChannel fileChannel2 = this.foc;
            if (fileChannel2 != null) {
                fileChannel2.close();
            }
        } catch (Exception e4) {
            e4.printStackTrace();
        }
        try {
            close();
        } catch (Exception e5) {
            e5.printStackTrace();
        }
        this.fis = null;
        this.fos = null;
        this.fic = null;
        this.foc = null;
        this.fd = null;
        this.success = false;
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

    public static void setSuPath(@Nullable String str) {
        if (str != null) {
            sSuPath = str;
        }
    }

    @NonNull
    public static String getSuPath() {
        return sSuPath;
    }

    public SerialPort(@NonNull File file, int i, int i2, int i3, int i4, int i5) throws SecurityException, IOException {
        this.success = false;
        this.fd = null;
        this.fic = null;
        this.foc = null;
        this.fis = null;
        this.fos = null;
        this.device = file;
        this.baudrate = i;
        this.dataBits = i2;
        this.parity = i3;
        this.stopBits = i4;
        this.flags = i5;
        if (!file.canRead() || !file.canWrite()) {
            try {
                Process exec = Runtime.getRuntime().exec(sSuPath);
                exec.getOutputStream().write(("chmod 666 " + file.getAbsolutePath() + "\nexit\n").getBytes());
                if (exec.waitFor() != 0 || !file.canRead() || !file.canWrite()) {
                    throw new SecurityException();
                }
            } catch (Exception e) {
                e.printStackTrace();
                throw new SecurityException();
            }
        }
        FileDescriptor open = open(file.getAbsolutePath(), i, i5);
        this.mFd = open;
        if (open != null) {
            this.mFileInputStream = new FileInputStream(this.mFd);
            this.mFileOutputStream = new FileOutputStream(this.mFd);
            return;
        }
        Log.e(TAG, "native open returns null");
        throw new IOException();
    }

    public SerialPort(@NonNull File file, int i) throws SecurityException, IOException {
        this(file, i, 8, 0, 1, 0);
    }

    public SerialPort(@NonNull File file, int i, int i2, int i3, int i4) throws SecurityException, IOException {
        this(file, i, i2, i3, i4, 0);
    }

    @NonNull
    public File getDevice() {
        return this.device;
    }

    public int getBaudrate() {
        return this.baudrate;
    }

    public int getDataBits() {
        return this.dataBits;
    }

    public int getParity() {
        return this.parity;
    }

    public int getStopBits() {
        return this.stopBits;
    }

    public int getFlags() {
        return this.flags;
    }

    /* JADX WARNING: Can't wrap try/catch for region: R(7:0|1|2|3|4|5|7) */
    /* JADX WARNING: Failed to process nested try/catch */
    /* JADX WARNING: Missing exception handler attribute for start block: B:2:0x0005 */
    /* JADX WARNING: Missing exception handler attribute for start block: B:4:0x000a */
    /* Code decompiled incorrectly, please refer to instructions dump. */
    public void tryClose() {
        /*
            r1 = this;
            java.io.FileInputStream r0 = r1.mFileInputStream     // Catch:{ IOException -> 0x0005 }
            r0.close()     // Catch:{ IOException -> 0x0005 }
        L_0x0005:
            java.io.FileOutputStream r0 = r1.mFileOutputStream     // Catch:{ IOException -> 0x000a }
            r0.close()     // Catch:{ IOException -> 0x000a }
        L_0x000a:
            r1.close()     // Catch:{ Exception -> 0x000d }
        L_0x000d:
            return
        */
        throw new UnsupportedOperationException("Method not decompiled: com.serial.port.SerialPort.tryClose():void");
    }

    static {
        System.loadLibrary("serial_port_app");
    }

    public static Builder newBuilder(File file, int i) {
        return new Builder(file, i);
    }

    public static Builder newBuilder(String str, int i) {
        return new Builder(str, i);
    }

    public static final class Builder {
        private int baudrate;
        private int dataBits;
        private File device;
        private int flags;
        private int parity;
        private int stopBits;

        private Builder(File file, int i) {
            this.dataBits = 8;
            this.parity = 0;
            this.stopBits = 1;
            this.flags = 0;
            this.device = file;
            this.baudrate = i;
        }

        private Builder(String str, int i) {
            this(new File(str), i);
        }

        public Builder dataBits(int i) {
            this.dataBits = i;
            return this;
        }

        public Builder parity(int i) {
            this.parity = i;
            return this;
        }

        public Builder stopBits(int i) {
            this.stopBits = i;
            return this;
        }

        public Builder flags(int i) {
            this.flags = i;
            return this;
        }

        public SerialPort build() throws SecurityException, IOException {
            return new SerialPort(this.device, this.baudrate, this.dataBits, this.parity, this.stopBits, this.flags);
        }
    }
}
