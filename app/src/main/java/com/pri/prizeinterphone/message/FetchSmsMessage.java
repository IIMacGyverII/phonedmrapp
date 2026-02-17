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

public class FetchSmsMessage extends BaseMessage {
    public static final String TAG = "TAG_FetchSmsMessage";
    public int callGroupID;
    public int callID;
    public byte[] content;
    public byte fetch = 1;
    public String msgContent;
    public byte type;

    public FetchSmsMessage() {
        super(new Packet(Const.Command.RECEIVE_SMS_CMD));
    }

    public FetchSmsMessage(Packet packet) {
        super(packet);
    }

    /* access modifiers changed from: protected */
    public void decodeBody(byte[] bArr) {
        ByteBuffer order = ByteBuffer.wrap(bArr).order(ByteOrder.LITTLE_ENDIAN);
        Log.i(TAG, "decodeBody: buffer " + Arrays.toString(order.array()));
        try {
            this.type = order.get();
            this.callID = order.getInt();
            byte[] bArr2 = new byte[order.remaining()];
            this.content = bArr2;
            order.get(bArr2);
            this.msgContent = new String(this.content, StandardCharsets.UTF_16LE);
        } catch (BufferUnderflowException e) {
            e.printStackTrace();
        } catch (Throwable th) {
            order.clear();
            throw th;
        }
        order.clear();
    }

    /* access modifiers changed from: protected */
    public byte[] encodeBody() {
        ByteBuf allocate = ByteBuf.allocate(1024);
        allocate.put(this.fetch);
        return allocate.getArray();
    }

    public String toString() {
        return "FetchSmsMessage{fetch=" + this.fetch + ", type=" + this.type + ", callID=" + this.callID + ", callGroupID=" + this.callGroupID + ", content=" + Arrays.toString(this.content) + ", msgContent='" + this.msgContent + '\'' + '}';
    }
}
