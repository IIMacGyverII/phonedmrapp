package com.pri.prizeinterphone.message;

import com.pri.prizeinterphone.Util.ByteBuf;
import com.pri.prizeinterphone.protocol.Const;
import com.pri.prizeinterphone.protocol.Packet;

public class MonitorMessage extends BaseMessage {
    public byte monitor;

    /* access modifiers changed from: protected */
    public void decodeBody(byte[] bArr) {
    }

    public MonitorMessage() {
        super(new Packet(Const.Command.SET_LISTEN_CMD));
    }

    public MonitorMessage(Packet packet) {
        super(packet);
    }

    /* access modifiers changed from: protected */
    public byte[] encodeBody() {
        ByteBuf allocate = ByteBuf.allocate(1024);
        allocate.put(this.monitor);
        return allocate.getArray();
    }
}
