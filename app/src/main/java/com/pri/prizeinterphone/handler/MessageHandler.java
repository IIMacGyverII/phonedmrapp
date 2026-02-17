package com.pri.prizeinterphone.handler;

import com.pri.prizeinterphone.protocol.Packet;

public interface MessageHandler {
    void handle(Packet packet);
}
