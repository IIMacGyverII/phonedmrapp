package com.pri.prizeinterphone.message;

import com.pri.prizeinterphone.Util.ByteBuf;
import com.pri.prizeinterphone.protocol.Const;
import com.pri.prizeinterphone.protocol.Packet;

public class RelayMessage extends BaseMessage {
    public byte relay;

    /* access modifiers changed from: protected */
    public void decodeBody(byte[] bArr) {
    }

    public RelayMessage() {
        super(new Packet(Const.Command.SET_OFFLINE_MODE_CMD));
    }

    public RelayMessage(Packet packet) {
        super(packet);
    }

    /* access modifiers changed from: protected */
    public byte[] encodeBody() {
        ByteBuf allocate = ByteBuf.allocate(1024);
        allocate.put(this.relay);
        return allocate.getArray();
    }
}
