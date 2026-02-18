package com.pri.prizeinterphone.ymodem;

import android.content.Context;
import java.io.IOException;
import java.io.InputStream;
import java.util.concurrent.atomic.AtomicBoolean;
/* loaded from: classes4.dex */
public class FileStreamThread extends Thread {
    private final String filePath;
    private DataRaderListener listener;
    private final Context mContext;
    private InputStream inputStream = null;
    private final AtomicBoolean isDataAcknowledged = new AtomicBoolean(false);
    private boolean isKeepRunning = false;
    private int fileByteSize = 0;

    /* loaded from: classes4.dex */
    public interface DataRaderListener {
        void onDataReady(byte[] bArr);

        void onFinish();
    }

    /* JADX INFO: Access modifiers changed from: package-private */
    public FileStreamThread(Context context, String str, DataRaderListener dataRaderListener) {
        this.mContext = context;
        this.filePath = str;
        this.listener = dataRaderListener;
    }

    /* JADX INFO: Access modifiers changed from: package-private */
    public int getFileByteSize() {
        if (this.fileByteSize == 0 || this.inputStream == null) {
            initStream();
        }
        return this.fileByteSize;
    }

    @Override // java.lang.Thread, java.lang.Runnable
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
                    Thread.sleep(50L);
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

    /* JADX INFO: Access modifiers changed from: package-private */
    public void keepReading() {
        this.isDataAcknowledged.set(true);
    }

    /* JADX INFO: Access modifiers changed from: package-private */
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
                InputStream inputStream = YModemUtil.getInputStream(this.mContext, this.filePath);
                this.inputStream = inputStream;
                this.fileByteSize = inputStream.available();
            } catch (IOException e) {
                e.printStackTrace();
            }
        }
    }

    private void onReadFinished() {
        InputStream inputStream = this.inputStream;
        if (inputStream != null) {
            try {
                inputStream.close();
                this.inputStream = null;
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    }
}
