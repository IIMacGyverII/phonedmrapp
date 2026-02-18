package com.pri.prizeinterphone.ymodem;
/* loaded from: classes4.dex */
public interface YModemListener {
    default void onDataReady(byte[] bArr, int i) {
    }

    void onFailed(String str);

    void onProgress(int i, int i2);

    void onSuccess();
}
