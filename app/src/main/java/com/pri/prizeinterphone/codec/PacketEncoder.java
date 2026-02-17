package com.pri.prizeinterphone.codec;

import com.pri.prizeinterphone.Util.ByteBuf;
import com.pri.prizeinterphone.protocol.Packet;

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

    /* JADX WARNING: Removed duplicated region for block: B:10:0x003f  */
    /* Code decompiled incorrectly, please refer to instructions dump. */
    private static int pcCheckSum(com.pri.prizeinterphone.Util.ByteBuf r9) {
        /*
            java.nio.ByteBuffer r9 = r9.nioBuffer()
            r9.flip()
            r0 = 0
            r2 = r0
        L_0x000a:
            int r4 = r9.remaining()
            r5 = 1
            r6 = 65535(0xffff, float:9.1834E-41)
            if (r4 <= r5) goto L_0x0027
            byte r4 = r9.get()
            r4 = r4 & 255(0xff, float:3.57E-43)
            int r4 = r4 << 8
            byte r5 = r9.get()
            r5 = r5 & 255(0xff, float:3.57E-43)
            r4 = r4 | r5
            r4 = r4 & r6
            long r4 = (long) r4
            long r2 = r2 + r4
            goto L_0x000a
        L_0x0027:
            boolean r4 = r9.hasRemaining()
            if (r4 == 0) goto L_0x0037
            byte r9 = r9.get()
            r9 = r9 & 255(0xff, float:3.57E-43)
            int r9 = r9 << 8
            long r4 = (long) r9
        L_0x0036:
            long r2 = r2 + r4
        L_0x0037:
            r9 = 16
            long r4 = r2 >> r9
            int r9 = (r4 > r0 ? 1 : (r4 == r0 ? 0 : -1))
            if (r9 <= 0) goto L_0x0044
            r7 = 65535(0xffff, double:3.23786E-319)
            long r2 = r2 & r7
            goto L_0x0036
        L_0x0044:
            int r9 = (int) r2
            r9 = r9 ^ r6
            return r9
        */
        throw new UnsupportedOperationException("Method not decompiled: com.pri.prizeinterphone.codec.PacketEncoder.pcCheckSum(com.pri.prizeinterphone.Util.ByteBuf):int");
    }
}
