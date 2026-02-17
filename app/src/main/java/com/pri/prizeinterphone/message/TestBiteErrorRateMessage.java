package com.pri.prizeinterphone.message;

import com.pri.prizeinterphone.Util.ByteBuf;
import com.pri.prizeinterphone.protocol.Packet;

public class TestBiteErrorRateMessage extends BaseMessage {
    public byte protocol;

    /* access modifiers changed from: protected */
    public void decodeBody(byte[] bArr) {
    }

    public TestBiteErrorRateMessage() {
        this(new Packet((byte) 63));
    }

    public TestBiteErrorRateMessage(Packet packet) {
        super(packet);
    }

    /* access modifiers changed from: protected */
    public byte[] encodeBody() {
        ByteBuf allocate = ByteBuf.allocate(1024);
        allocate.put(this.protocol);
        return allocate.getArray();
    }
}
