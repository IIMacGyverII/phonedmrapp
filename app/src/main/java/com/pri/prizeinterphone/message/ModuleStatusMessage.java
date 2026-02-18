package com.pri.prizeinterphone.message;

import com.pri.prizeinterphone.protocol.Const;
import com.pri.prizeinterphone.protocol.Packet;
import java.nio.ByteBuffer;
import java.nio.ByteOrder;
/* loaded from: classes4.dex */
public class ModuleStatusMessage extends BaseMessage {
    public byte status;

    @Override // com.pri.prizeinterphone.message.BaseMessage
    protected byte[] encodeBody() {
        return new byte[0];
    }

    public ModuleStatusMessage() {
        super(new Packet(Const.Command.MODULE_PRINT_STATUS_INFO_CMD));
    }

    public ModuleStatusMessage(Packet packet) {
        super(packet);
    }

    @Override // com.pri.prizeinterphone.message.BaseMessage
    protected void decodeBody(byte[] bArr) {
        this.status = ByteBuffer.wrap(bArr).order(ByteOrder.LITTLE_ENDIAN).get();
    }

    public byte getStatus() {
        return this.status;
    }

    public void setStatus(byte b) {
        this.status = b;
    }
}
