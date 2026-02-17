package com.android.internal.telephony.uicc;

import android.util.ArrayMap;
import com.android.internal.annotations.VisibleForTesting;
import com.android.telephony.Rlog;
import java.io.FileDescriptor;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;
import java.util.Objects;

public class AnswerToReset {
    private static final int B1_MASK = 1;
    private static final int B2_MASK = 2;
    private static final int B7_MASK = 64;
    private static final int B8_MASK = 128;
    public static final byte DIRECT_CONVENTION = 59;
    private static final int EXTENDED_APDU_INDEX = 2;
    public static final int INTERFACE_BYTES_MASK = 240;
    public static final byte INVERSE_CONVENTION = 63;
    private static final String TAG = "AnswerToReset";
    private static final int TAG_CARD_CAPABILITIES = 7;
    public static final int TA_MASK = 16;
    public static final int TB_MASK = 32;
    public static final int TC_MASK = 64;
    public static final int TD_MASK = 128;
    public static final int T_MASK = 15;
    public static final int T_VALUE_FOR_GLOBAL_INTERFACE = 15;
    private static final boolean VDBG = false;
    private Byte mCheckByte;
    private byte mFormatByte;
    private HistoricalBytes mHistoricalBytes;
    private ArrayList<InterfaceByte> mInterfaceBytes = new ArrayList<>();
    private boolean mIsDirectConvention;
    private boolean mIsEuiccSupported;
    private boolean mIsMultipleEnabledProfilesSupported = false;
    private boolean mOnlyTEqualsZero = true;

    public static class HistoricalBytes {
        private static final int LENGTH_MASK = 15;
        private static final int TAG_MASK = 240;
        private final byte mCategory;
        private final ArrayMap<Integer, byte[]> mNodes;
        private final byte[] mRawData;

        public byte getCategory() {
            return this.mCategory;
        }

        public byte[] getRawData() {
            return this.mRawData;
        }

        public byte[] getValue(int i) {
            return this.mNodes.get(Integer.valueOf(i));
        }

        /* access modifiers changed from: private */
        public static HistoricalBytes parseHistoricalBytes(byte[] bArr, int i, int i2) {
            int i3;
            if (i2 <= 0 || (i3 = i + i2) > bArr.length) {
                return null;
            }
            ArrayMap arrayMap = new ArrayMap();
            int i4 = i + 1;
            while (i4 < i3 && i4 > 0) {
                i4 = parseLtvNode(i4, arrayMap, bArr, i3 - 1);
            }
            if (i4 < 0) {
                return null;
            }
            byte[] bArr2 = new byte[i2];
            System.arraycopy(bArr, i, bArr2, 0, i2);
            return new HistoricalBytes(bArr2, arrayMap, bArr2[0]);
        }

        private HistoricalBytes(byte[] bArr, ArrayMap<Integer, byte[]> arrayMap, byte b) {
            this.mRawData = bArr;
            this.mNodes = arrayMap;
            this.mCategory = b;
        }

        private static int parseLtvNode(int i, ArrayMap<Integer, byte[]> arrayMap, byte[] bArr, int i2) {
            if (i > i2) {
                return -1;
            }
            byte b = bArr[i];
            int i3 = (b & 240) >> 4;
            int i4 = i + 1;
            int i5 = b & 15;
            int i6 = i4 + i5;
            if (i6 > i2 + 1 || i5 == 0) {
                return -1;
            }
            byte[] bArr2 = new byte[i5];
            System.arraycopy(bArr, i4, bArr2, 0, i5);
            arrayMap.put(Integer.valueOf(i3), bArr2);
            return i6;
        }
    }

    public static AnswerToReset parseAtr(String str) {
        AnswerToReset answerToReset = new AnswerToReset();
        if (answerToReset.parseAtrString(str)) {
            return answerToReset;
        }
        return null;
    }

    private AnswerToReset() {
    }

    /* access modifiers changed from: private */
    public static String byteToStringHex(Byte b) {
        if (b == null) {
            return null;
        }
        return IccUtils.byteToHex(b.byteValue());
    }

    private void checkEuiccSupportedCapabilities() {
        for (int i = 0; i < this.mInterfaceBytes.size() - 1; i++) {
            if (this.mInterfaceBytes.get(i).getTD() != null && (this.mInterfaceBytes.get(i).getTD().byteValue() & 15) == 15) {
                int i2 = i + 1;
                if (this.mInterfaceBytes.get(i2).getTB() != null) {
                    if (!((this.mInterfaceBytes.get(i2).getTB().byteValue() & 128) == 0 || (this.mInterfaceBytes.get(i2).getTB().byteValue() & 2) == 0)) {
                        this.mIsEuiccSupported = true;
                    }
                    if ((this.mInterfaceBytes.get(i2).getTB().byteValue() & 128) != 0 && (this.mInterfaceBytes.get(i2).getTB().byteValue() & 1) != 0) {
                        this.mIsMultipleEnabledProfilesSupported = true;
                        return;
                    }
                    return;
                }
            }
        }
    }

    private int parseConventionByte(byte[] bArr, int i) {
        if (i >= bArr.length) {
            loge("Failed to read the convention byte.");
            return -1;
        }
        byte b = bArr[i];
        if (b == 59) {
            this.mIsDirectConvention = true;
        } else if (b == 63) {
            this.mIsDirectConvention = false;
        } else {
            loge("Unrecognized convention byte " + IccUtils.byteToHex(b));
            return -1;
        }
        return i + 1;
    }

    private int parseFormatByte(byte[] bArr, int i) {
        if (i >= bArr.length) {
            loge("Failed to read the format byte.");
            return -1;
        }
        this.mFormatByte = bArr[i];
        return i + 1;
    }

    private int parseInterfaceBytes(byte[] bArr, int i) {
        byte b = this.mFormatByte;
        while ((b & 240) != 0) {
            InterfaceByte interfaceByte = new InterfaceByte();
            if ((b & 16) != 0) {
                if (i >= bArr.length) {
                    loge("Failed to read the byte for TA.");
                    return -1;
                }
                interfaceByte.setTA(Byte.valueOf(bArr[i]));
                i++;
            }
            if ((b & 32) != 0) {
                if (i >= bArr.length) {
                    loge("Failed to read the byte for TB.");
                    return -1;
                }
                interfaceByte.setTB(Byte.valueOf(bArr[i]));
                i++;
            }
            if ((b & 64) != 0) {
                if (i >= bArr.length) {
                    loge("Failed to read the byte for TC.");
                    return -1;
                }
                interfaceByte.setTC(Byte.valueOf(bArr[i]));
                i++;
            }
            if ((b & 128) != 0) {
                if (i >= bArr.length) {
                    loge("Failed to read the byte for TD.");
                    return -1;
                }
                interfaceByte.setTD(Byte.valueOf(bArr[i]));
                i++;
            }
            this.mInterfaceBytes.add(interfaceByte);
            Byte td = interfaceByte.getTD();
            if (td == null) {
                break;
            }
            b = td.byteValue();
            if ((b & 15) != 0) {
                this.mOnlyTEqualsZero = false;
            }
        }
        return i;
    }

    private int parseHistoricalBytes(byte[] bArr, int i) {
        byte b = this.mFormatByte & 15;
        int i2 = b + i;
        if (i2 > bArr.length) {
            loge("Failed to read the historical bytes.");
            return -1;
        }
        if (b > 0) {
            this.mHistoricalBytes = HistoricalBytes.parseHistoricalBytes(bArr, i, b);
        }
        return i2;
    }

    private int parseCheckBytes(byte[] bArr, int i) {
        if (i < bArr.length) {
            this.mCheckByte = Byte.valueOf(bArr[i]);
            return i + 1;
        } else if (!this.mOnlyTEqualsZero) {
            loge("Check byte must be present because T equals to values other than 0.");
            return -1;
        } else {
            log("Check byte can be absent because T=0.");
            return i;
        }
    }

    private boolean parseAtrString(String str) {
        int parseConventionByte;
        int parseFormatByte;
        int parseInterfaceBytes;
        int parseHistoricalBytes;
        int parseCheckBytes;
        if (str == null) {
            loge("The input ATR string can not be null");
            return false;
        } else if (str.length() % 2 != 0) {
            loge("The length of input ATR string " + str.length() + " is not even.");
            return false;
        } else if (str.length() < 4) {
            loge("Valid ATR string must at least contains TS and T0.");
            return false;
        } else {
            byte[] hexStringToBytes = IccUtils.hexStringToBytes(str);
            if (hexStringToBytes == null || (parseConventionByte = parseConventionByte(hexStringToBytes, 0)) == -1 || (parseFormatByte = parseFormatByte(hexStringToBytes, parseConventionByte)) == -1 || (parseInterfaceBytes = parseInterfaceBytes(hexStringToBytes, parseFormatByte)) == -1 || (parseHistoricalBytes = parseHistoricalBytes(hexStringToBytes, parseInterfaceBytes)) == -1 || (parseCheckBytes = parseCheckBytes(hexStringToBytes, parseHistoricalBytes)) == -1) {
                return false;
            }
            if (parseCheckBytes != hexStringToBytes.length) {
                loge("Unexpected bytes after the check byte.");
                return false;
            }
            log("Successfully parsed the ATR string " + str + " into " + toString());
            checkEuiccSupportedCapabilities();
            return true;
        }
    }

    public static class InterfaceByte {
        private Byte mTA;
        private Byte mTB;
        private Byte mTC;
        private Byte mTD;

        public Byte getTA() {
            return this.mTA;
        }

        public Byte getTB() {
            return this.mTB;
        }

        public Byte getTC() {
            return this.mTC;
        }

        public Byte getTD() {
            return this.mTD;
        }

        public void setTA(Byte b) {
            this.mTA = b;
        }

        public void setTB(Byte b) {
            this.mTB = b;
        }

        public void setTC(Byte b) {
            this.mTC = b;
        }

        public void setTD(Byte b) {
            this.mTD = b;
        }

        private InterfaceByte() {
            this.mTA = null;
            this.mTB = null;
            this.mTC = null;
            this.mTD = null;
        }

        @VisibleForTesting
        public InterfaceByte(Byte b, Byte b2, Byte b3, Byte b4) {
            this.mTA = b;
            this.mTB = b2;
            this.mTC = b3;
            this.mTD = b4;
        }

        public boolean equals(Object obj) {
            if (this == obj) {
                return true;
            }
            if (obj == null || getClass() != obj.getClass()) {
                return false;
            }
            InterfaceByte interfaceByte = (InterfaceByte) obj;
            if (!Objects.equals(this.mTA, interfaceByte.getTA()) || !Objects.equals(this.mTB, interfaceByte.getTB()) || !Objects.equals(this.mTC, interfaceByte.getTC()) || !Objects.equals(this.mTD, interfaceByte.getTD())) {
                return false;
            }
            return true;
        }

        public int hashCode() {
            return Objects.hash(new Object[]{this.mTA, this.mTB, this.mTC, this.mTD});
        }

        public String toString() {
            StringBuffer stringBuffer = new StringBuffer();
            stringBuffer.append("{");
            stringBuffer.append("TA=");
            stringBuffer.append(AnswerToReset.byteToStringHex(this.mTA));
            stringBuffer.append(",");
            stringBuffer.append("TB=");
            stringBuffer.append(AnswerToReset.byteToStringHex(this.mTB));
            stringBuffer.append(",");
            stringBuffer.append("TC=");
            stringBuffer.append(AnswerToReset.byteToStringHex(this.mTC));
            stringBuffer.append(",");
            stringBuffer.append("TD=");
            stringBuffer.append(AnswerToReset.byteToStringHex(this.mTD));
            stringBuffer.append("}");
            return stringBuffer.toString();
        }
    }

    private static void log(String str) {
        Rlog.d(TAG, str);
    }

    private static void loge(String str) {
        Rlog.e(TAG, str);
    }

    public byte getConventionByte() {
        return this.mIsDirectConvention ? (byte) 59 : 63;
    }

    public byte getFormatByte() {
        return this.mFormatByte;
    }

    public List<InterfaceByte> getInterfaceBytes() {
        return this.mInterfaceBytes;
    }

    public HistoricalBytes getHistoricalBytes() {
        return this.mHistoricalBytes;
    }

    public Byte getCheckByte() {
        return this.mCheckByte;
    }

    public boolean isEuiccSupported() {
        return this.mIsEuiccSupported;
    }

    public boolean isExtendedApduSupported() {
        byte[] value;
        HistoricalBytes historicalBytes = this.mHistoricalBytes;
        if (historicalBytes == null || (value = historicalBytes.getValue(7)) == null || value.length < 3) {
            return false;
        }
        if (this.mIsDirectConvention) {
            if ((value[2] & 64) > 0) {
                return true;
            }
            return false;
        } else if ((value[2] & 2) > 0) {
            return true;
        } else {
            return false;
        }
    }

    public boolean isMultipleEnabledProfilesSupported() {
        return this.mIsMultipleEnabledProfilesSupported;
    }

    public String toString() {
        StringBuffer stringBuffer = new StringBuffer();
        stringBuffer.append("AnswerToReset:{");
        stringBuffer.append("mConventionByte=");
        stringBuffer.append(IccUtils.byteToHex(getConventionByte()));
        stringBuffer.append(",");
        stringBuffer.append("mFormatByte=");
        stringBuffer.append(byteToStringHex(Byte.valueOf(this.mFormatByte)));
        stringBuffer.append(",");
        stringBuffer.append("mInterfaceBytes={");
        Iterator<InterfaceByte> it = this.mInterfaceBytes.iterator();
        while (it.hasNext()) {
            stringBuffer.append(it.next().toString());
        }
        stringBuffer.append("},");
        stringBuffer.append("mHistoricalBytes={");
        HistoricalBytes historicalBytes = this.mHistoricalBytes;
        if (historicalBytes != null) {
            for (byte byteToHex : historicalBytes.getRawData()) {
                stringBuffer.append(IccUtils.byteToHex(byteToHex));
                stringBuffer.append(",");
            }
        }
        stringBuffer.append("},");
        stringBuffer.append("mCheckByte=");
        stringBuffer.append(byteToStringHex(this.mCheckByte));
        stringBuffer.append("}");
        return stringBuffer.toString();
    }

    public void dump(FileDescriptor fileDescriptor, PrintWriter printWriter, String[] strArr) {
        printWriter.println("AnswerToReset:");
        printWriter.println(toString());
        printWriter.flush();
    }
}
