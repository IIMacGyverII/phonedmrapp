package com.pri.prizeinterphone.message;

import com.pri.prizeinterphone.Util.ByteBuf;
import com.pri.prizeinterphone.protocol.Const;
import com.pri.prizeinterphone.protocol.Packet;
import java.nio.ByteBuffer;
import java.nio.ByteOrder;

public class SignalMessage extends BaseMessage {
    public byte fetch = 1;
    public byte rssi;

    public SignalMessage() {
        super(new Packet(Const.Command.QUERY_SIGNAL_STRENGTH_CMD));
    }

    public SignalMessage(Packet packet) {
        super(packet);
    }

    /* access modifiers changed from: protected */
    public void decodeBody(byte[] bArr) {
        this.rssi = ByteBuffer.wrap(bArr).order(ByteOrder.LITTLE_ENDIAN).get();
    }

    /* access modifiers changed from: protected */
    public byte[] encodeBody() {
        ByteBuf allocate = ByteBuf.allocate(1024);
        allocate.put(this.fetch);
        return allocate.getArray();
    }
}
