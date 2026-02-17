package com.pri.prizeinterphone.ymodem;

public interface YModemListener {
    void onDataReady(byte[] bArr, int i) {
    }

    void onFailed(String str);

    void onProgress(int i, int i2);

    void onSuccess();
}
