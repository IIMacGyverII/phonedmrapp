package com.pri.prizeinterphone.message;

import com.pri.prizeinterphone.Util.ByteBuf;
import com.pri.prizeinterphone.protocol.Const;
import com.pri.prizeinterphone.protocol.Packet;
import java.security.SecureRandom;
/* loaded from: classes4.dex */
public class EncryptMessage extends BaseMessage {
    public byte[] aesKey;
    public byte fun;
    private final SecureRandom random;
    public byte sw;

    @Override // com.pri.prizeinterphone.message.BaseMessage
    protected void decodeBody(byte[] bArr) {
    }

    public EncryptMessage() {
        super(new Packet(Const.Command.SET_ENCRYPT_FUNCTION_CMD));
        this.fun = (byte) 1;
        this.random = new SecureRandom();
    }

    public EncryptMessage(Packet packet) {
        super(packet);
        this.fun = (byte) 1;
        this.random = new SecureRandom();
    }

    @Override // com.pri.prizeinterphone.message.BaseMessage
    protected byte[] encodeBody() {
        ByteBuf allocate = ByteBuf.allocate(1024);
        byte b = this.fun;
        if (b == 3 || b == 4 || b == 0) {
            allocate.put(b);
        }
        if (this.fun != 0) {
            allocate.put(this.sw);
            allocate.put(this.aesKey);
        }
        return allocate.getArray();
    }

    public void enableEncrypt(byte[] bArr) {
        this.sw = (byte) 1;
        this.aesKey = bArr;
        if (bArr.length == 8) {
            this.fun = (byte) 1;
        } else if (bArr.length == 16) {
            this.fun = (byte) 3;
        } else if (bArr.length == 32) {
            this.fun = (byte) 4;
        } else {
            throw new IllegalArgumentException("密钥错误， 只能是 8位，16位 和32 位");
        }
    }

    public void disableEncrypt() {
        this.sw = (byte) 2;
    }

    public static EncryptMessage buildEnableEncryptKey(int i) {
        if (i != 8 && i != 16 && i != 32) {
            throw new IllegalArgumentException("密钥错误， 只能是 8位，16位 和32 位");
        }
        EncryptMessage encryptMessage = new EncryptMessage();
        encryptMessage.sw = (byte) 1;
        if (i == 8) {
            encryptMessage.fun = (byte) 1;
        } else {
            encryptMessage.fun = (byte) (i == 16 ? 3 : 4);
        }
        byte[] bArr = new byte[i];
        encryptMessage.random.nextBytes(bArr);
        encryptMessage.aesKey = bArr;
        return encryptMessage;
    }

    public static EncryptMessage buildQueryEncryptKey() {
        EncryptMessage encryptMessage = new EncryptMessage();
        encryptMessage.fun = (byte) 0;
        return encryptMessage;
    }
}
