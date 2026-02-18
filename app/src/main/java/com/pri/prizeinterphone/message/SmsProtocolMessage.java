package com.pri.prizeinterphone.message;

import com.pri.prizeinterphone.Util.ByteBuf;
import com.pri.prizeinterphone.protocol.Const;
import com.pri.prizeinterphone.protocol.Packet;
/* loaded from: classes4.dex */
public class SmsProtocolMessage extends BaseMessage {
    public byte type;

    @Override // com.pri.prizeinterphone.message.BaseMessage
    protected void decodeBody(byte[] bArr) {
    }

    public SmsProtocolMessage() {
        super(new Packet(Const.Command.SET_SMS_PROTOCOL_TYPE_CMD));
        this.type = (byte) 0;
    }

    public SmsProtocolMessage(Packet packet) {
        super(packet);
        this.type = (byte) 0;
    }

    @Override // com.pri.prizeinterphone.message.BaseMessage
    protected byte[] encodeBody() {
        ByteBuf allocate = ByteBuf.allocate(1024);
        allocate.put(this.type);
        return allocate.getArray();
    }
}
