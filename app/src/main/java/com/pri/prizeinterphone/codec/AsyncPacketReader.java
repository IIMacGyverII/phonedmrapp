package com.pri.prizeinterphone.codec;

import android.util.Log;
import com.pri.prizeinterphone.Util.ByteBuf;
import com.pri.prizeinterphone.Util.ExecutorManager;
import com.pri.prizeinterphone.Util.NamedThreadFactory;
import com.pri.prizeinterphone.Util.Util;
import com.pri.prizeinterphone.manager.DmrManager;
import com.pri.prizeinterphone.protocol.Packet;
import com.pri.prizeinterphone.serial.PacketReceiver;
import com.pri.prizeinterphone.serial.port.SerialPort;
import java.io.FileInputStream;
import java.io.IOException;
import java.nio.ByteBuffer;
import java.nio.ByteOrder;
import java.nio.channels.FileChannel;
import kotlin.UByte;
import kotlin.UShort;
/* loaded from: classes4.dex */
public class AsyncPacketReader implements Runnable {
    public static final String TAG = "TAG_AsyncPacketReader";
    private boolean isStop;
    private final PacketReceiver receiver;
    private SerialPort serial;
    private Thread thread;
    private final NamedThreadFactory threadFactory = new NamedThreadFactory(ExecutorManager.READ_THREAD_NAME);
    private final ByteBuf buffer = ByteBuf.allocateDirect(32767);

    public AsyncPacketReader(SerialPort serialPort, PacketReceiver packetReceiver) {
        this.isStop = false;
        this.serial = serialPort;
        this.receiver = packetReceiver;
        this.isStop = true;
    }

    public void startRead() {
        Thread newThread = this.threadFactory.newThread(this);
        this.thread = newThread;
        this.isStop = false;
        newThread.start();
    }

    public boolean isStop() {
        return this.isStop;
    }

    public void stopRead() {
        if (this.thread != null) {
            Log.i(TAG, "stop read");
            this.isStop = true;
            this.thread.interrupt();
            this.thread = null;
        }
    }

    @Override // java.lang.Runnable
    public void run() {
        try {
            this.buffer.clear();
            Log.i(TAG, "start read  serial.isConnected() = " + this.serial.isConnected());
            while (this.serial.isConnected() && !this.isStop) {
                Log.i(TAG, "start read");
                ByteBuffer nioBuffer = this.buffer.checkCapacity(1024).nioBuffer();
                if (!read(this.serial.getInputStream(), nioBuffer)) {
                    this.buffer.clear();
                } else {
                    nioBuffer.flip();
                    decodePacket(nioBuffer);
                    nioBuffer.compact();
                }
            }
        } catch (Exception e) {
            Log.d(TAG, "run error----------------------------------", e);
        }
    }

    private void decodePacket(ByteBuffer byteBuffer) {
        while (true) {
            Packet decode = decode(byteBuffer);
            if (decode == null) {
                return;
            }
            Log.i(TAG, "read packet ==" + decode);
            this.receiver.onReceive(decode, this.serial);
        }
    }

    private boolean read(FileChannel fileChannel, ByteBuffer byteBuffer) {
        int i;
        try {
            i = fileChannel.read(byteBuffer);
        } catch (IOException unused) {
            i = -1;
        }
        return i > 0;
    }

    private boolean read(FileInputStream fileInputStream, ByteBuffer byteBuffer) {
        int i;
        try {
            byte[] bArr = new byte[1024];
            i = fileInputStream.read(bArr);
            Log.i(TAG, "readCount == " + i);
            Log.i(TAG, "read bytes == " + Util.bytesToHex(bArr));
            if (i > 2) {
                byteBuffer.put(bArr, 0, i);
            }
        } catch (IOException e) {
            e.printStackTrace();
            i = -1;
        }
        return i > 2;
    }

    public Packet decode(ByteBuffer byteBuffer) {
        byteBuffer.order(ByteOrder.BIG_ENDIAN);
        byte[] bArr = null;
        if (byteBuffer.remaining() >= 8) {
            if (DmrManager.getInstance().isTestBitErrorRate()) {
                Log.i(TAG, "decode is on Test Bit Error Rate,in.remaining()=" + byteBuffer.remaining());
                Packet packet = new Packet((byte) 63);
                byte[] bArr2 = new byte[byteBuffer.remaining()];
                byteBuffer.get(bArr2);
                packet.body = bArr2;
                return packet;
            }
            byteBuffer.mark();
            int remaining = byteBuffer.remaining();
            byte b = byteBuffer.get();
            StringBuilder sb = new StringBuilder();
            sb.append("decode:before head=");
            sb.append(String.format("%02x", Byte.valueOf(b)));
            Log.i(TAG, sb.toString());
            if (b == 0) {
                Log.i(TAG, "decode head is not 0x00, head is Data header changes manually!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!");
                b = byteBuffer.get();
            }
            if (b == 240) {
                Log.i(TAG, "decode head is not 0xf0, head is Data header changes manually!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!");
                b = byteBuffer.get();
            }
            byte b2 = byteBuffer.get();
            Log.i(TAG, "decode: bufferSize=" + remaining + ",head=" + String.format("%02x", Byte.valueOf(b)) + ",cmd=" + String.format("%02x", Byte.valueOf(b2)));
            if (b == -65 && b2 == -86) {
                for (int i = 0; i < 15; i++) {
                    byteBuffer.get();
                }
                Packet packet2 = new Packet(b2);
                packet2.setHead(b);
                Log.i(TAG, "Packet decode == " + packet2);
                return packet2;
            }
            byte b3 = byteBuffer.get();
            byte b4 = byteBuffer.get();
            int i2 = byteBuffer.getShort() & UShort.MAX_VALUE;
            int i3 = 65535 & byteBuffer.getShort();
            Log.i(TAG, "decode: bufferSize=" + remaining + "--bodyLen=" + i3 + "--head" + Integer.toHexString(b & UByte.MAX_VALUE) + "--cmd" + Integer.toHexString(b2 & UByte.MAX_VALUE));
            if (b == 104) {
                if (i3 > 0) {
                    bArr = new byte[i3];
                    byteBuffer.get(bArr);
                }
                byteBuffer.get();
                Packet packet3 = new Packet(b2);
                packet3.cmd = b2;
                packet3.rw = b3;
                packet3.sr = b4;
                packet3.ckSum = (short) i2;
                packet3.body = bArr;
                packet3.len = (short) i3;
                Log.i(TAG, "Packet decode == " + packet3);
                return packet3;
            }
            byteBuffer.reset();
        }
        return null;
    }
}
