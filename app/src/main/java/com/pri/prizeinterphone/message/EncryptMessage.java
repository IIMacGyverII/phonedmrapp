package com.pri.prizeinterphone.message;

import com.pri.prizeinterphone.Util.ByteBuf;
import com.pri.prizeinterphone.protocol.Const;
import com.pri.prizeinterphone.protocol.Packet;
import java.security.SecureRandom;

public class EncryptMessage extends BaseMessage {
    public byte[] aesKey;
    public byte fun = 1;
    private final SecureRandom random = new SecureRandom();
    public byte sw;

    /* access modifiers changed from: protected */
    public void decodeBody(byte[] bArr) {
    }

    public EncryptMessage() {
        super(new Packet(Const.Command.SET_ENCRYPT_FUNCTION_CMD));
    }

    public EncryptMessage(Packet packet) {
        super(packet);
    }

    /* access modifiers changed from: protected */
    public byte[] encodeBody() {
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
        this.sw = 1;
        this.aesKey = bArr;
        if (bArr.length == 8) {
            this.fun = 1;
        } else if (bArr.length == 16) {
            this.fun = 3;
        } else if (bArr.length == 32) {
            this.fun = 4;
        } else {
            throw new IllegalArgumentException("密钥错误， 只能是 8位，16位 和32 位");
        }
    }

    public void disableEncrypt() {
        this.sw = 2;
    }

    public static EncryptMessage buildEnableEncryptKey(int i) {
        if (i == 8 || i == 16 || i == 32) {
            EncryptMessage encryptMessage = new EncryptMessage();
            encryptMessage.sw = 1;
            if (i == 8) {
                encryptMessage.fun = 1;
            } else {
                encryptMessage.fun = (byte) (i == 16 ? 3 : 4);
            }
            byte[] bArr = new byte[i];
            encryptMessage.random.nextBytes(bArr);
            encryptMessage.aesKey = bArr;
            return encryptMessage;
        }
        throw new IllegalArgumentException("密钥错误， 只能是 8位，16位 和32 位");
    }

    public static EncryptMessage buildQueryEncryptKey() {
        EncryptMessage encryptMessage = new EncryptMessage();
        encryptMessage.fun = 0;
        return encryptMessage;
    }
}
