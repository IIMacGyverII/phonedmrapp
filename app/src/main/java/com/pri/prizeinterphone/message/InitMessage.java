package com.pri.prizeinterphone.message;

import com.pri.prizeinterphone.Util.ByteBuf;
import com.pri.prizeinterphone.protocol.Const;
import com.pri.prizeinterphone.protocol.Packet;

public class InitMessage extends BaseMessage {
    public final byte data = 1;

    /* access modifiers changed from: protected */
    public void decodeBody(byte[] bArr) {
    }

    public String toString() {
        return "InitMessage{init=1}";
    }

    public InitMessage() {
        super(new Packet(Const.Command.MODULE_INIT_CMD));
    }

    public InitMessage(Packet packet) {
        super(packet);
    }

    /* access modifiers changed from: protected */
    public byte[] encodeBody() {
        ByteBuf allocate = ByteBuf.allocate(1024);
        allocate.put((byte) 1);
        return allocate.getArray();
    }
}
