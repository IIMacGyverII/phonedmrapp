package com.pri.prizeinterphone.manager;

public interface LaunchListener {
    void onReceiveStart();

    void onReceiveStop();

    void onSendStart();

    void onSendStop();

    void onSendTimeout();
}
