package com.pri.prizeinterphone.message;

import com.pri.prizeinterphone.Util.ByteBuf;
import com.pri.prizeinterphone.protocol.Const;
import com.pri.prizeinterphone.protocol.Packet;

public class SmsProtocolMessage extends BaseMessage {
    public byte type = 0;

    /* access modifiers changed from: protected */
    public void decodeBody(byte[] bArr) {
    }

    public SmsProtocolMessage() {
        super(new Packet(Const.Command.SET_SMS_PROTOCOL_TYPE_CMD));
    }

    public SmsProtocolMessage(Packet packet) {
        super(packet);
    }

    /* access modifiers changed from: protected */
    public byte[] encodeBody() {
        ByteBuf allocate = ByteBuf.allocate(1024);
        allocate.put(this.type);
        return allocate.getArray();
    }
}
