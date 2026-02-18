package com.pri.prizeinterphone.Util;

import java.nio.ByteBuffer;
import java.nio.ByteOrder;
/* loaded from: classes4.dex */
public final class ByteBuf {
    private ByteBuffer tmpNioBuf;

    private int newCapacity(int i) {
        int i2 = 64;
        while (i2 < i) {
            i2 <<= 1;
        }
        return i2;
    }

    public static ByteBuf allocate(int i) {
        ByteBuf byteBuf = new ByteBuf();
        byteBuf.tmpNioBuf = ByteBuffer.allocate(i).order(ByteOrder.LITTLE_ENDIAN);
        return byteBuf;
    }

    public static ByteBuf allocateDirect(int i) {
        ByteBuf byteBuf = new ByteBuf();
        byteBuf.tmpNioBuf = ByteBuffer.allocateDirect(i).order(ByteOrder.LITTLE_ENDIAN);
        return byteBuf;
    }

    public static ByteBuf wrap(byte[] bArr) {
        ByteBuf byteBuf = new ByteBuf();
        byteBuf.tmpNioBuf = ByteBuffer.wrap(bArr).order(ByteOrder.LITTLE_ENDIAN);
        return byteBuf;
    }

    public byte[] getArray() {
        this.tmpNioBuf.flip();
        byte[] bArr = new byte[this.tmpNioBuf.remaining()];
        this.tmpNioBuf.get(bArr);
        this.tmpNioBuf.compact();
        return bArr;
    }

    public ByteBuf get(byte[] bArr) {
        this.tmpNioBuf.get(bArr);
        return this;
    }

    public byte get() {
        return this.tmpNioBuf.get();
    }

    public ByteBuf put(byte b) {
        checkCapacity(1);
        this.tmpNioBuf.put(b);
        return this;
    }

    public short getShort() {
        return this.tmpNioBuf.getShort();
    }

    public ByteBuf putShort(int i) {
        checkCapacity(2);
        this.tmpNioBuf.putShort((short) i);
        return this;
    }

    public int getInt() {
        return this.tmpNioBuf.getInt();
    }

    public ByteBuf putInt(int i) {
        checkCapacity(4);
        this.tmpNioBuf.putInt(i);
        return this;
    }

    public long getLong() {
        return this.tmpNioBuf.getLong();
    }

    public ByteBuf putLong(long j) {
        checkCapacity(8);
        this.tmpNioBuf.putLong(j);
        return this;
    }

    public ByteBuf put(byte[] bArr) {
        checkCapacity(bArr.length);
        this.tmpNioBuf.put(bArr);
        return this;
    }

    public ByteBuf checkCapacity(int i) {
        if (this.tmpNioBuf.remaining() < i) {
            int newCapacity = newCapacity(this.tmpNioBuf.capacity() + i);
            ByteBuffer allocateDirect = this.tmpNioBuf.isDirect() ? ByteBuffer.allocateDirect(newCapacity) : ByteBuffer.allocate(newCapacity);
            allocateDirect.order(ByteOrder.LITTLE_ENDIAN);
            this.tmpNioBuf.flip();
            allocateDirect.put(this.tmpNioBuf);
            this.tmpNioBuf = allocateDirect;
        }
        return this;
    }

    public ByteBuffer nioBuffer() {
        return this.tmpNioBuf;
    }

    public ByteBuf clear() {
        this.tmpNioBuf.clear();
        return this;
    }

    public ByteBuf flip() {
        this.tmpNioBuf.flip();
        return this;
    }
}
