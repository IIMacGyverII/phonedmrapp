package com.pri.prizeinterphone.serial;

import android.util.Log;
import com.pri.prizeinterphone.codec.AsyncPacketReader;
import com.pri.prizeinterphone.codec.AsyncPacketWriter;
import com.pri.prizeinterphone.protocol.Packet;
import com.pri.prizeinterphone.serial.port.SerialPort;
/* loaded from: classes4.dex */
public class SerialManager {
    public static final String TAG = "TAG_SerialManager";
    private static volatile SerialManager instance;
    private AsyncPacketReader reader;
    private MessageDispatcher receiver;
    private SerialPort serial;
    private AsyncPacketWriter writer;

    private SerialManager() {
    }

    public static SerialManager getInstance() {
        if (instance == null) {
            synchronized (SerialManager.class) {
                if (instance == null) {
                    instance = new SerialManager();
                }
            }
        }
        return instance;
    }

    public boolean init() {
        Log.d(TAG, "init()," + this);
        if (this.serial == null) {
            this.serial = new SerialPort();
        }
        boolean open = this.serial.open();
        if (open) {
            if (this.receiver == null) {
                this.receiver = new MessageDispatcher();
            }
            if (this.reader == null) {
                this.reader = new AsyncPacketReader(this.serial, this.receiver);
            }
            if (this.writer == null) {
                this.writer = new AsyncPacketWriter(this.serial);
            }
            if (this.reader.isStop()) {
                this.reader.startRead();
            }
        }
        return open;
    }

    public SerialPort getSerial() {
        if (this.serial == null) {
            this.serial = new SerialPort();
        }
        this.serial.open();
        return this.serial;
    }

    public void release() {
        Log.d(TAG, "release()," + this);
        releaseReader();
        releaseWriter();
        releaseSerial();
        instance = null;
    }

    public void releaseSerial() {
        Log.d(TAG, "releaseSerial()," + this);
        SerialPort serialPort = this.serial;
        if (serialPort != null) {
            serialPort.release();
            this.serial = null;
        }
    }

    public void releaseReader() {
        Log.d(TAG, "releaseReader()," + this);
        AsyncPacketReader asyncPacketReader = this.reader;
        if (asyncPacketReader != null) {
            asyncPacketReader.stopRead();
            this.reader = null;
        }
    }

    public void releaseWriter() {
        Log.d(TAG, "releaseWriter()" + this);
        if (this.writer != null) {
            this.reader = null;
        }
    }

    public void send(Packet packet) {
        Log.i(TAG, "packet = " + packet + this);
        if (this.serial.isConnected()) {
            this.writer.write(packet);
        }
    }
}
