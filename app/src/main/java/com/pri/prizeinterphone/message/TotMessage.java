package com.pri.prizeinterphone.message;

import com.pri.prizeinterphone.Util.ByteBuf;
import com.pri.prizeinterphone.protocol.Packet;

public class TotMessage extends BaseMessage {
    public byte tot;

    /* access modifiers changed from: protected */
    public void decodeBody(byte[] bArr) {
    }

    public TotMessage() {
        super(new Packet((byte) 59));
    }

    public TotMessage(Packet packet) {
        super(packet);
    }

    /* access modifiers changed from: protected */
    public byte[] encodeBody() {
        ByteBuf allocate = ByteBuf.allocate(1024);
        allocate.put(this.tot);
        return allocate.getArray();
    }
}
