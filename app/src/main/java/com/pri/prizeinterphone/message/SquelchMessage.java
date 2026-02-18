package com.pri.prizeinterphone.message;

import com.pri.prizeinterphone.Util.ByteBuf;
import com.pri.prizeinterphone.protocol.Packet;
/* loaded from: classes4.dex */
public class SquelchMessage extends BaseMessage {
    public byte squelch;

    @Override // com.pri.prizeinterphone.message.BaseMessage
    protected void decodeBody(byte[] bArr) {
    }

    public SquelchMessage() {
        super(new Packet((byte) 48));
    }

    public SquelchMessage(Packet packet) {
        super(packet);
    }

    @Override // com.pri.prizeinterphone.message.BaseMessage
    protected byte[] encodeBody() {
        ByteBuf allocate = ByteBuf.allocate(1024);
        allocate.put(this.squelch);
        return allocate.getArray();
    }
}
