package com.pri.prizeinterphone.message;

import com.pri.prizeinterphone.Util.ByteBuf;
import com.pri.prizeinterphone.protocol.Packet;

public class SquelchMessage extends BaseMessage {
    public byte squelch;

    /* access modifiers changed from: protected */
    public void decodeBody(byte[] bArr) {
    }

    public SquelchMessage() {
        super(new Packet((byte) 48));
    }

    public SquelchMessage(Packet packet) {
        super(packet);
    }

    /* access modifiers changed from: protected */
    public byte[] encodeBody() {
        ByteBuf allocate = ByteBuf.allocate(1024);
        allocate.put(this.squelch);
        return allocate.getArray();
    }
}
