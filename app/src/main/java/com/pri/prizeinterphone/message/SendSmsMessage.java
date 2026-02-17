package com.pri.prizeinterphone.message;

import android.util.Log;
import com.pri.prizeinterphone.Util.ByteBuf;
import com.pri.prizeinterphone.protocol.Const;
import com.pri.prizeinterphone.protocol.Packet;
import java.nio.charset.StandardCharsets;
import java.util.Arrays;

public class SendSmsMessage extends BaseMessage {
    public static final byte MSGTYPE_ALL = 2;
    public static final byte MSGTYPE_GROUP = 3;
    public static final byte MSGTYPE_SINGLE = 1;
    public static final String TAG = "SendSmsMessage";
    public int callGroupNumber;
    public int callNumber;
    public byte[] content;
    public String msgContent;
    public byte msgType = 1;

    /* access modifiers changed from: protected */
    public void decodeBody(byte[] bArr) {
    }

    public SendSmsMessage() {
        super(new Packet(Const.Command.SEND_SMS_CMD));
    }

    public SendSmsMessage(Packet packet) {
        super(packet);
    }

    public byte getMsgType() {
        return this.msgType;
    }

    public void setMsgType(byte b) {
        this.msgType = b;
    }

    public int getCallNumber() {
        return this.callNumber;
    }

    public void setCallNumber(int i) {
        this.callNumber = i;
    }

    public String getMsgContent() {
        return this.msgContent;
    }

    public void setMsgContent(String str) {
        this.msgContent = str;
    }

    public int getCallGroupNumber() {
        return this.callGroupNumber;
    }

    public void setCallGroupNumber(int i) {
        this.callGroupNumber = i;
    }

    public byte[] getContent() {
        return this.content;
    }

    public void setContent(byte[] bArr) {
        this.content = bArr;
    }

    /* access modifiers changed from: protected */
    public byte[] encodeBody() {
        ByteBuf allocate = ByteBuf.allocate(1024);
        allocate.put(this.msgType);
        allocate.putInt(this.callNumber);
        Log.i(TAG, "encodeBody: callNumber " + this.callNumber);
        if (this.msgType == 3) {
            allocate.putInt(this.callGroupNumber);
        }
        allocate.put(this.msgContent.getBytes(StandardCharsets.UTF_16LE));
        return allocate.getArray();
    }

    public String toString() {
        return "SendSmsMessage{msgType=" + this.msgType + ", callNumber=" + this.callNumber + ", callGroupNumber=" + this.callGroupNumber + ", msgContent='" + this.msgContent + '\'' + ", content=" + Arrays.toString(this.content) + '}';
    }
}
