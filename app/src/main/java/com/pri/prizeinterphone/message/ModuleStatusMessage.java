package com.pri.prizeinterphone.message;

import com.pri.prizeinterphone.protocol.Const;
import com.pri.prizeinterphone.protocol.Packet;
import java.nio.ByteBuffer;
import java.nio.ByteOrder;

public class ModuleStatusMessage extends BaseMessage {
    public byte status;

    /* access modifiers changed from: protected */
    public byte[] encodeBody() {
        return new byte[0];
    }

    public ModuleStatusMessage() {
        super(new Packet(Const.Command.MODULE_PRINT_STATUS_INFO_CMD));
    }

    public ModuleStatusMessage(Packet packet) {
        super(packet);
    }

    /* access modifiers changed from: protected */
    public void decodeBody(byte[] bArr) {
        this.status = ByteBuffer.wrap(bArr).order(ByteOrder.LITTLE_ENDIAN).get();
    }

    public byte getStatus() {
        return this.status;
    }

    public void setStatus(byte b) {
        this.status = b;
    }
}
