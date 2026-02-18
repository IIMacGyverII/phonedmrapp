package com.pri.prizeinterphone.message;

import com.pri.prizeinterphone.Util.ByteBuf;
import com.pri.prizeinterphone.protocol.Packet;
/* loaded from: classes4.dex */
public class TestBiteErrorRateMessage extends BaseMessage {
    public byte protocol;

    @Override // com.pri.prizeinterphone.message.BaseMessage
    protected void decodeBody(byte[] bArr) {
    }

    public TestBiteErrorRateMessage() {
        this(new Packet((byte) 63));
    }

    public TestBiteErrorRateMessage(Packet packet) {
        super(packet);
    }

    @Override // com.pri.prizeinterphone.message.BaseMessage
    protected byte[] encodeBody() {
        ByteBuf allocate = ByteBuf.allocate(1024);
        allocate.put(this.protocol);
        return allocate.getArray();
    }
}
