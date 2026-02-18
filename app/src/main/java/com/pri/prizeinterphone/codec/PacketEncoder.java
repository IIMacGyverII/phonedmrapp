package com.pri.prizeinterphone.codec;

import com.pri.prizeinterphone.Util.ByteBuf;
import com.pri.prizeinterphone.protocol.Packet;
import java.nio.ByteBuffer;
import kotlin.UByte;
/* loaded from: classes4.dex */
public class PacketEncoder {
    public static void encode(Packet packet, ByteBuf byteBuf) {
        short checkSum = (short) checkSum(packet);
        byteBuf.put(packet.head);
        byteBuf.put(packet.cmd);
        byteBuf.put(packet.rw);
        byteBuf.put(packet.sr);
        byteBuf.put((byte) (checkSum >> 8));
        byteBuf.put((byte) checkSum);
        short bodyLength = (short) packet.getBodyLength();
        byteBuf.put((byte) (bodyLength >> 8));
        byteBuf.put((byte) bodyLength);
        byteBuf.put(packet.body);
        byteBuf.put((byte) 16);
    }

    private static int checkSum(Packet packet) {
        ByteBuf allocate = ByteBuf.allocate(1024);
        allocate.put(packet.head);
        allocate.put(packet.cmd);
        allocate.put(packet.rw);
        allocate.put(packet.sr);
        allocate.putShort(0);
        short bodyLength = (short) packet.getBodyLength();
        allocate.put((byte) (bodyLength >> 8));
        allocate.put((byte) bodyLength);
        allocate.put(packet.body);
        allocate.put((byte) 16);
        return pcCheckSum(allocate);
    }

    private static int pcCheckSum(ByteBuf byteBuf) {
        ByteBuffer nioBuffer = byteBuf.nioBuffer();
        nioBuffer.flip();
        long j = 0;
        while (nioBuffer.remaining() > 1) {
            j += (((nioBuffer.get() & UByte.MAX_VALUE) << 8) | (nioBuffer.get() & UByte.MAX_VALUE)) & 65535;
        }
        if (nioBuffer.hasRemaining()) {
            j += (nioBuffer.get() & UByte.MAX_VALUE) << 8;
        }
        while (true) {
            long j2 = j >> 16;
            if (j2 <= 0) {
                return ((int) j) ^ 65535;
            }
            j = (j & 65535) + j2;
        }
    }
}
