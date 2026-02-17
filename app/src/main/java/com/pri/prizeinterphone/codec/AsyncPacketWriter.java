package com.pri.prizeinterphone.codec;

import android.util.Log;
import com.pri.prizeinterphone.Util.ByteBuf;
import com.pri.prizeinterphone.Util.ExecutorManager;
import com.pri.prizeinterphone.Util.Util;
import com.pri.prizeinterphone.protocol.Packet;
import com.pri.prizeinterphone.serial.port.SerialPort;
import java.io.IOException;
import java.util.concurrent.Executor;

public class AsyncPacketWriter {
    private final Executor executor = ExecutorManager.INSTANCE.getWriteThread();
    /* access modifiers changed from: private */
    public final SerialPort serial;

    public AsyncPacketWriter(SerialPort serialPort) {
        this.serial = serialPort;
    }

    public void write(Packet packet) {
        this.executor.execute(new WriteTask(packet));
    }

    private class WriteTask implements Runnable {
        private final ByteBuf buffer;
        private final Packet packet;

        public WriteTask(Packet packet2) {
            this.packet = packet2;
            this.buffer = ByteBuf.allocate(packet2.getBodyLength() + 8);
        }

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
