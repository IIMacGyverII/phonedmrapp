package com.pri.prizeinterphone.ymodem;

import android.content.Context;
import android.text.TextUtils;
import java.io.ByteArrayOutputStream;
import java.io.DataOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.util.Arrays;
/* JADX INFO: Access modifiers changed from: package-private */
/* loaded from: classes4.dex */
public class YModemUtil {
    private static final byte CPMEOF = 26;
    private static final String Data = "1";
    private static final byte EOT = 4;
    private static final byte SOH = 1;
    private static final byte STX = 2;
    private static final CRC16 crc16 = new CRC16();

    /* JADX INFO: Access modifiers changed from: package-private */
    public static byte[] getEOT() {
        return new byte[]{4};
    }

    YModemUtil() {
    }

    /* JADX INFO: Access modifiers changed from: package-private */
    public static byte[] getYModelData() {
        return "1".getBytes();
    }

    /* JADX INFO: Access modifiers changed from: package-private */
    public static byte[] getFileNamePackage(String str, int i, String str2) throws IOException {
        byte[] copyOf;
        byte[] concat = concat(str.getBytes(), new byte[]{0}, (i + "").getBytes());
        if (TextUtils.isEmpty(str2)) {
            copyOf = Arrays.copyOf(concatByteArrays(concat, new byte[]{0}), 128);
        } else {
            copyOf = Arrays.copyOf(concat(concat, new byte[]{0}, str2.getBytes()), 128);
        }
        return getDataPackage(copyOf, 128, (byte) 0);
    }

    /* JADX INFO: Access modifiers changed from: package-private */
    public static byte[] getDataPackage(byte[] bArr, int i, byte b) throws IOException {
        byte[] dataHeader = getDataHeader(b, bArr.length == YModem.mSize.intValue() ? (byte) 2 : (byte) 1);
        if (i < bArr.length) {
            while (i < bArr.length) {
                bArr[i] = CPMEOF;
                i++;
            }
        }
        ByteArrayOutputStream byteArrayOutputStream = new ByteArrayOutputStream();
        DataOutputStream dataOutputStream = new DataOutputStream(byteArrayOutputStream);
        dataOutputStream.writeShort((short) crc16.calcCRC(bArr));
        dataOutputStream.close();
        return concat(dataHeader, bArr, byteArrayOutputStream.toByteArray());
    }

    /* JADX INFO: Access modifiers changed from: package-private */
    public static byte[] getEnd() throws IOException {
        return getDataPackage(new byte[128], 128, (byte) 0);
    }

    /* JADX INFO: Access modifiers changed from: package-private */
    public static InputStream getInputStream(Context context, String str) throws IOException {
        return new InputStreamSource().getStream(context, str);
    }

    private static byte[] getDataHeader(byte b, byte b2) {
        byte b3 = (byte) (b % 598);
        return concat(new byte[]{b2}, new byte[]{b3}, new byte[]{(byte) (~b3)});
    }

    private static byte[] concat(byte[] bArr, byte[] bArr2, byte[] bArr3) {
        int length = bArr.length;
        int length2 = bArr2.length;
        int length3 = bArr3.length;
        int i = length + length2;
        byte[] bArr4 = new byte[i + length3];
        System.arraycopy(bArr, 0, bArr4, 0, length);
        System.arraycopy(bArr2, 0, bArr4, length, length2);
        System.arraycopy(bArr3, 0, bArr4, i, length3);
        return bArr4;
    }

    public static byte[] concatByteArrays(byte[]... bArr) {
        int i = 0;
        for (byte[] bArr2 : bArr) {
            i += bArr2.length;
        }
        byte[] bArr3 = new byte[i];
        int i2 = 0;
        for (byte[] bArr4 : bArr) {
            System.arraycopy(bArr4, 0, bArr3, i2, bArr4.length);
            i2 += bArr4.length;
        }
        return bArr3;
    }
}
