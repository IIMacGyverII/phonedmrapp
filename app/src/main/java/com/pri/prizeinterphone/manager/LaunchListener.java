package com.pri.prizeinterphone.manager;
/* loaded from: classes4.dex */
public interface LaunchListener {
    void onReceiveStart();

    void onReceiveStop();

    void onSendStart();

    void onSendStop();

    void onSendTimeout();
}
