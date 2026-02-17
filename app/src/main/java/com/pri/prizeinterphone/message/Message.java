package com.pri.prizeinterphone.message;

public interface Message {
    void decode();

    void encode();

    void send();
}
