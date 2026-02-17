package com.pri.prizeinterphone.serial;

import com.pri.prizeinterphone.protocol.Packet;
import com.pri.prizeinterphone.serial.port.SerialPort;

public interface PacketReceiver {
    void onReceive(Packet packet, SerialPort serialPort);
}
