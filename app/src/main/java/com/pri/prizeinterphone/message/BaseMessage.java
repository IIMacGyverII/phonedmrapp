package com.pri.prizeinterphone.message;

import com.pri.prizeinterphone.protocol.Packet;
import com.pri.prizeinterphone.serial.SerialManager;

public abstract class BaseMessage implements Message {
    public final Packet packet;

    /* access modifiers changed from: protected */
    public abstract void decodeBody(byte[] bArr);

    /* access modifiers changed from: protected */
    public abstract byte[] encodeBody();

    public BaseMessage(Packet packet2) {
        this.packet = packet2;
    }

    public void encode() {
        Packet packet2 = this.packet;
        packet2.rw = 1;
        packet2.sr = 1;
        packet2.body = encodeBody();
    }

    public void decode() {
        byte[] bArr = this.packet.body;
        if (bArr != null && bArr.length > 0) {
            decodeBody(bArr);
        }
    }

    public void send() {
        encode();
        SerialManager.getInstance().send(this.packet);
    }
}
