package com.pri.prizeinterphone.codec;

import android.util.Log;
import com.pri.prizeinterphone.Util.ByteBuf;
import com.pri.prizeinterphone.Util.ExecutorManager;
import com.pri.prizeinterphone.Util.Util;
import com.pri.prizeinterphone.protocol.Packet;
import com.pri.prizeinterphone.serial.port.SerialPort;
import java.io.IOException;
import java.util.concurrent.Executor;
/* loaded from: classes4.dex */
public class AsyncPacketWriter {
    private final Executor executor = ExecutorManager.INSTANCE.getWriteThread();
    private final SerialPort serial;

    public AsyncPacketWriter(SerialPort serialPort) {
        this.serial = serialPort;
    }

    public void write(Packet packet) {
        this.executor.execute(new WriteTask(packet));
    }

    /* JADX INFO: Access modifiers changed from: private */
    /* loaded from: classes4.dex */
    public class WriteTask implements Runnable {
        private final ByteBuf buffer;
        private final Packet packet;

        public WriteTask(Packet packet) {
            this.packet = packet;
            this.buffer = ByteBuf.allocate(packet.getBodyLength() + 8);
        }

        @Override // java.lang.Runnable
        public void run() {
            this.buffer.clear();
            PacketEncoder.encode(this.packet, this.buffer);
            if (AsyncPacketWriter.this.serial.isConnected()) {
                try {
                    byte[] array = this.buffer.getArray();
                    Log.i(AsyncPacketReader.TAG, "write buffer == " + Util.bytesToHex(array));
                    AsyncPacketWriter.this.serial.getOutputStream().write(array);
                } catch (IOException e) {
                    e.printStackTrace();
                }
            }
        }
    }
}
