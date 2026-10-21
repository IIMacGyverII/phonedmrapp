package com.macdmr.radio;

import static org.junit.Assert.*;

import org.junit.Test;

import java.io.File;
import java.io.FileOutputStream;
import java.nio.charset.StandardCharsets;

public class DeviceReportTest {
    private static File lib(String strings) throws Exception {
        File f = File.createTempFile("lib", ".so"); f.deleteOnExit();
        try (FileOutputStream o = new FileOutputStream(f)) { o.write(("\u007fELF\u0000" + strings).getBytes(StandardCharsets.ISO_8859_1)); }
        return f;
    }

    /** The Xplore 1's libwonder_serialport.so exports no Java_ symbols: it registers its methods from JNI_OnLoad. */
    @Test public void dynamicallyRegisteredSerialLibraryIsDescribed() throws Exception {
        File f = lib("JNI_OnLoad\u0000cfsetispeed\u0000com/wonder/serial/SerialPort\u0000openSerial\u0000setupSerial\u0000readData\u0000"
                + "(Ljava/lang/String;I)I\u0000(IIICI)I\u0000(I[BI)I\u0000/system/lib64/libc.so\u0000");
        assertEquals("", DeviceReport.jniSymbols(f));
        String r = DeviceReport.registeredNatives(f);
        assertTrue(r, r.contains("com.wonder.serial.SerialPort"));
        assertTrue(r, r.contains("(Ljava/lang/String;I)I") && r.contains("(IIICI)I") && r.contains("(I[BI)I"));
        assertTrue(r, r.contains("openSerial") && r.contains("setupSerial") && r.contains("readData"));
        assertFalse("system paths are not classes", r.contains("system.lib64"));
    }

    @Test public void exportedSymbolsStillWinAndPlainLibrariesSayNothing() throws Exception {
        File f = lib("Java_com_pri_prizeinterphone_serial_port_SerialPort_open\u0000");
        assertTrue(DeviceReport.jniSymbols(f).contains("com.pri.prizeinterphone.serial.port.SerialPort.open()"));
        assertEquals("", DeviceReport.registeredNatives(lib("nothing here\u0000")));
    }
}
