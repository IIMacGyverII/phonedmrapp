package com.pri.prizeinterphone.message;

import android.util.Log;
import androidx.core.os.EnvironmentCompat;
import com.pri.prizeinterphone.Util.ByteBuf;
import com.pri.prizeinterphone.protocol.Const;
import com.pri.prizeinterphone.protocol.Packet;
import java.nio.ByteBuffer;
import java.nio.ByteOrder;

public class EnhanceMessage extends BaseMessage {
    public static final byte CALL_PROMPT = 2;
    public static final byte CHECK = 1;
    public static final byte KILL = 4;
    public static final byte REMOTE_MONITORING = 3;
    public static final byte REVIVE = 5;
    public int callNum;
    public byte fun;

    public static String fun2str(byte b) {
        return b != 1 ? b != 2 ? b != 3 ? b != 4 ? b != 5 ? EnvironmentCompat.MEDIA_UNKNOWN : "REVIVE" : "KILL" : "REMOTE_MONITORING" : "CALL_PROMPT" : "CHECK";
    }

    public EnhanceMessage() {
        super(new Packet(Const.Command.SET_ENHANCE_FUNCTION_CMD));
    }

    public EnhanceMessage(Packet packet) {
        super(packet);
    }

    /* access modifiers changed from: protected */
    public void decodeBody(byte[] bArr) {
        ByteBuffer order = ByteBuffer.wrap(bArr).order(ByteOrder.LITTLE_ENDIAN);
        this.fun = order.get();
        try {
            this.callNum = order.getInt();
        } catch (Exception e) {
            Log.d("EnhanceMessage", "decodeBody,error", e);
        }
    }

    /* access modifiers changed from: protected */
    public byte[] encodeBody() {
        ByteBuf allocate = ByteBuf.allocate(1024);
        allocate.put(this.fun);
        allocate.putInt(this.callNum);
        return allocate.getArray();
    }
}
