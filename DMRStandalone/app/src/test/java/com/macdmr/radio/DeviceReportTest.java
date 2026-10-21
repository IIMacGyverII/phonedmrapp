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

    @Test public void appLogKeepsRadioStepsAndDropsPersonalLines() {
        String out = DeviceReport.redactAppLog(java.util.Arrays.asList(
                "12:00:00.000 sepolicy: ok",
                "12:00:01.000 module power -> on (pwd :1)",
                "12:00:02.000 tuned 146.520 MHz",
                "12:00:03.000 APRS N0CALL-9>APDR16: position 38.12345,-122.54321",
                "12:00:04.000 caller 3112345 talking",
                "12:00:05.000 DMR ID from the stock app: 3112345",
                "12:00:06.000 web PIN changed",
                "12:00:07.000 bring-up failed: W1AW said hello at 38.12345 -122.54321",
                "12:00:08.000 module DMR003.UV4T.V022",
                "12:00:09.000 TX cmd=0x2C rw=1 sr=1 len=9 [01 41 00 42 00]  <68 2C 01 01 41 00 42 00 10>",
                "12:00:10.000 TX cmd=0x23 rw=1 sr=1 len=2 [A0 8D]  <68 23 A0 8D 10>"));
        assertTrue(out, out.contains("module DMR003.UV4T.V022"));
        assertTrue(out, out.contains("TX cmd=0x2C rw=1 sr=1 len=9 […]  <…>") && out.contains("[A0 8D]  <68 23 A0 8D 10>"));
        assertTrue(out, out.contains("sepolicy: ok") && out.contains("module power -> on (pwd :1)") && out.contains("146.520 MHz"));
        assertFalse(out, out.contains("N0CALL") || out.contains("APRS") || out.contains("talking") || out.contains("PIN"));
        assertTrue(out, out.contains("DMR ID from the stock app: ######"));
        assertTrue(out, out.contains("bring-up failed: CALL said hello at #.#### #.####"));
        assertFalse(out, out.contains("3112345") || out.contains("W1AW") || out.contains("38.12345"));
    }

    @Test public void exportedSymbolsStillWinAndPlainLibrariesSayNothing() throws Exception {
        File f = lib("Java_com_pri_prizeinterphone_serial_port_SerialPort_open\u0000");
        assertTrue(DeviceReport.jniSymbols(f).contains("com.pri.prizeinterphone.serial.port.SerialPort.open()"));
        assertEquals("", DeviceReport.registeredNatives(lib("nothing here\u0000")));
    }
}
