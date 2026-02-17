package com.pri.prizeinterphone.ymodem;

import android.content.Context;
import java.io.IOException;
import java.io.InputStream;
import java.util.concurrent.atomic.AtomicBoolean;

public class FileStreamThread extends Thread {
    private int fileByteSize = 0;
    private final String filePath;
    private InputStream inputStream = null;
    private final AtomicBoolean isDataAcknowledged = new AtomicBoolean(false);
    private boolean isKeepRunning = false;
    private DataRaderListener listener;
    private final Context mContext;

    public interface DataRaderListener {
        void onDataReady(byte[] bArr);

        void onFinish();
    }

    FileStreamThread(Context context, String str, DataRaderListener dataRaderListener) {
        this.mContext = context;
        this.filePath = str;
        this.listener = dataRaderListener;
    }

    /* access modifiers changed from: package-private */
    public int getFileByteSize() {
        if (this.fileByteSize == 0 || this.inputStream == null) {
            initStream();
        }
        return this.fileByteSize;
    }

    public void run() {
        try {
            prepareData();
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    private void prepareData() throws IOException {
        initStream();
        byte[] bArr = new byte[YModem.mSize.intValue()];
        byte b = 1;
        this.isDataAcknowledged.set(true);
        this.isKeepRunning = true;
        while (this.isKeepRunning) {
            if (!this.isDataAcknowledged.get()) {
                try {
                    Thread.sleep(50);
                } catch (InterruptedException e) {
                    e.printStackTrace();
                }
            } else {
                int read = this.inputStream.read(bArr);
                if (read == -1) {
                    Lg.f("The file data has all been read...");
                    if (this.listener != null) {
                        onStop();
                        this.listener.onFinish();
                        return;
                    }
                    return;
                }
                byte[] dataPackage = YModemUtil.getDataPackage(bArr, read, b);
                DataRaderListener dataRaderListener = this.listener;
                if (dataRaderListener != null) {
                    dataRaderListener.onDataReady(dataPackage);
                }
                b = (byte) (b + 1);
                this.isDataAcknowledged.set(false);
            }
        }
    }

    /* access modifiers changed from: package-private */
    public void keepReading() {
        this.isDataAcknowledged.set(true);
    }

    /* access modifiers changed from: package-private */
    public void release() {
        onStop();
        this.listener = null;
    }

    private void onStop() {
        this.isKeepRunning = false;
        this.isDataAcknowledged.set(false);
        this.fileByteSize = 0;
        onReadFinished();
    }

    private void initStream() {
        if (this.inputStream == null) {
            try {
                InputStream inputStream2 = YModemUtil.getInputStream(this.mContext, this.filePath);
                this.inputStream = inputStream2;
                this.fileByteSize = inputStream2.available();
            } catch (IOException e) {
                e.printStackTrace();
            }
        }
    }

    private void onReadFinished() {
        InputStream inputStream2 = this.inputStream;
        if (inputStream2 != null) {
            try {
                inputStream2.close();
                this.inputStream = null;
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    }
}
