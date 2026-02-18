package com.pri.prizeinterphone.message;

import android.util.Log;
import com.pri.prizeinterphone.Util.ByteBuf;
import com.pri.prizeinterphone.protocol.Const;
import com.pri.prizeinterphone.protocol.Packet;
import java.nio.BufferUnderflowException;
import java.nio.ByteBuffer;
import java.nio.ByteOrder;
import java.nio.charset.StandardCharsets;
import java.util.Arrays;
/* loaded from: classes4.dex */
public class FetchSmsMessage extends BaseMessage {
    public static final String TAG = "TAG_FetchSmsMessage";
    public int callGroupID;
    public int callID;
    public byte[] content;
    public byte fetch;
    public String msgContent;
    public byte type;

    public FetchSmsMessage() {
        super(new Packet(Const.Command.RECEIVE_SMS_CMD));
        this.fetch = (byte) 1;
    }

    public FetchSmsMessage(Packet packet) {
        super(packet);
        this.fetch = (byte) 1;
    }

    @Override // com.pri.prizeinterphone.message.BaseMessage
    protected void decodeBody(byte[] bArr) {
        ByteBuffer order = ByteBuffer.wrap(bArr).order(ByteOrder.LITTLE_ENDIAN);
        Log.i(TAG, "decodeBody: buffer " + Arrays.toString(order.array()));
        try {
            try {
                this.type = order.get();
                this.callID = order.getInt();
                byte[] bArr2 = new byte[order.remaining()];
                this.content = bArr2;
                order.get(bArr2);
                this.msgContent = new String(this.content, StandardCharsets.UTF_16LE);
            } catch (BufferUnderflowException e) {
                e.printStackTrace();
            }
        } finally {
            order.clear();
        }
    }

    @Override // com.pri.prizeinterphone.message.BaseMessage
    protected byte[] encodeBody() {
        ByteBuf allocate = ByteBuf.allocate(1024);
        allocate.put(this.fetch);
        return allocate.getArray();
    }

    public String toString() {
        return "FetchSmsMessage{fetch=" + ((int) this.fetch) + ", type=" + ((int) this.type) + ", callID=" + this.callID + ", callGroupID=" + this.callGroupID + ", content=" + Arrays.toString(this.content) + ", msgContent='" + this.msgContent + "'}";
    }
}
