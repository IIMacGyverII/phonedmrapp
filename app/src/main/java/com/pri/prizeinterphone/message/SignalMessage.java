package com.pri.prizeinterphone.message;

import com.pri.prizeinterphone.Util.ByteBuf;
import com.pri.prizeinterphone.protocol.Const;
import com.pri.prizeinterphone.protocol.Packet;
import java.nio.ByteBuffer;
import java.nio.ByteOrder;
/* loaded from: classes4.dex */
public class SignalMessage extends BaseMessage {
    public byte fetch;
    public byte rssi;

    public SignalMessage() {
        super(new Packet(Const.Command.QUERY_SIGNAL_STRENGTH_CMD));
        this.fetch = (byte) 1;
    }

    public SignalMessage(Packet packet) {
        super(packet);
        this.fetch = (byte) 1;
    }

    @Override // com.pri.prizeinterphone.message.BaseMessage
    protected void decodeBody(byte[] bArr) {
        this.rssi = ByteBuffer.wrap(bArr).order(ByteOrder.LITTLE_ENDIAN).get();
    }

    @Override // com.pri.prizeinterphone.message.BaseMessage
    protected byte[] encodeBody() {
        ByteBuf allocate = ByteBuf.allocate(1024);
        allocate.put(this.fetch);
        return allocate.getArray();
    }
}
