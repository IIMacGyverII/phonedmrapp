package com.android.internal.telephony.util;

import android.text.TextUtils;
import com.android.internal.telephony.util.DnsPacket;
import java.nio.BufferUnderflowException;
import java.nio.ByteBuffer;
import java.text.DecimalFormat;
import java.text.FieldPosition;

public final class DnsPacketUtils {

    public static class DnsRecordParser {
        private static final int MAXLABELCOUNT = 128;
        private static final int MAXLABELSIZE = 63;
        private static final DecimalFormat sByteFormat = new DecimalFormat();
        private static final FieldPosition sPos = new FieldPosition(0);

        private static String labelToString(byte[] bArr) {
            StringBuffer stringBuffer = new StringBuffer();
            for (byte unsignedInt : bArr) {
                int unsignedInt2 = Byte.toUnsignedInt(unsignedInt);
                if (unsignedInt2 <= 32 || unsignedInt2 >= 127) {
                    stringBuffer.append('\\');
                    sByteFormat.format((long) unsignedInt2, stringBuffer, sPos);
                } else if (unsignedInt2 == 34 || unsignedInt2 == 46 || unsignedInt2 == 59 || unsignedInt2 == 92 || unsignedInt2 == 40 || unsignedInt2 == 41 || unsignedInt2 == 64 || unsignedInt2 == 36) {
                    stringBuffer.append('\\');
                    stringBuffer.append((char) unsignedInt2);
                } else {
                    stringBuffer.append((char) unsignedInt2);
                }
            }
            return stringBuffer.toString();
        }

        public static String parseName(ByteBuffer byteBuffer, int i, boolean z) throws BufferUnderflowException, DnsPacket.ParseException {
            if (i <= 128) {
                int unsignedInt = Byte.toUnsignedInt(byteBuffer.get());
                int i2 = unsignedInt & DnsPacket.DnsRecord.NAME_COMPRESSION;
                if (unsignedInt == 0) {
                    return "";
                }
                if ((i2 != 0 && i2 != 192) || (!z && i2 == 192)) {
                    throw new DnsPacket.ParseException("Parse name fail, bad label type: " + i2);
                } else if (i2 == 192) {
                    int unsignedInt2 = ((unsignedInt & -193) << 8) + Byte.toUnsignedInt(byteBuffer.get());
                    int position = byteBuffer.position();
                    if (unsignedInt2 < position - 2) {
                        byteBuffer.position(unsignedInt2);
                        String parseName = parseName(byteBuffer, i + 1, z);
                        byteBuffer.position(position);
                        return parseName;
                    }
                    throw new DnsPacket.ParseException("Parse compression name fail, invalid compression");
                } else {
                    byte[] bArr = new byte[unsignedInt];
                    byteBuffer.get(bArr);
                    String labelToString = labelToString(bArr);
                    if (labelToString.length() <= 63) {
                        String parseName2 = parseName(byteBuffer, i + 1, z);
                        if (TextUtils.isEmpty(parseName2)) {
                            return labelToString;
                        }
                        return labelToString + "." + parseName2;
                    }
                    throw new DnsPacket.ParseException("Parse name fail, invalid label length");
                }
            } else {
                throw new DnsPacket.ParseException("Failed to parse name, too many labels");
            }
        }

        private DnsRecordParser() {
        }
    }

    private DnsPacketUtils() {
    }
}
