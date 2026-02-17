package com.android.internal.telephony.cat;

import android.compat.annotation.UnsupportedAppUsage;
import com.android.telephony.Rlog;
import java.util.ArrayList;
import java.util.List;
import kotlin.UByte;
import kotlin.jvm.internal.ByteCompanionObject;

public class ComprehensionTlv {
    private static final String LOG_TAG = "ComprehensionTlv";
    private boolean mCr;
    private int mLength;
    private byte[] mRawValue;
    private int mTag;
    private int mValueIndex;

    protected ComprehensionTlv(int i, boolean z, int i2, byte[] bArr, int i3) {
        this.mTag = i;
        this.mCr = z;
        this.mLength = i2;
        this.mValueIndex = i3;
        this.mRawValue = bArr;
    }

    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    public int getTag() {
        return this.mTag;
    }

    public boolean isComprehensionRequired() {
        return this.mCr;
    }

    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    public int getLength() {
        return this.mLength;
    }

    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    public int getValueIndex() {
        return this.mValueIndex;
    }

    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    public byte[] getRawValue() {
        return this.mRawValue;
    }

    public static List<ComprehensionTlv> decodeMany(byte[] bArr, int i) throws ResultException {
        ArrayList arrayList = new ArrayList();
        int length = bArr.length;
        while (true) {
            if (i < length) {
                ComprehensionTlv decode = decode(bArr, i);
                if (decode == null) {
                    CatLog.d(LOG_TAG, "decodeMany: ctlv is null, stop decoding");
                    break;
                }
                arrayList.add(decode);
                i = decode.mLength + decode.mValueIndex;
            } else {
                break;
            }
        }
        return arrayList;
    }

    public static ComprehensionTlv decode(byte[] bArr, int i) throws ResultException {
        byte b;
        int i2;
        byte b2;
        byte b3;
        int i3;
        int length = bArr.length;
        int i4 = i + 1;
        try {
            byte b4 = bArr[i] & UByte.MAX_VALUE;
            if (!(b4 == 0 || b4 == 255)) {
                boolean z = false;
                if (b4 == Byte.MAX_VALUE) {
                    byte b5 = ((bArr[i4] & UByte.MAX_VALUE) << 8) | (bArr[i4 + 1] & UByte.MAX_VALUE);
                    if ((32768 & b5) != 0) {
                        z = true;
                    }
                    b = b5 & UByte.MAX_VALUE;
                    i4 += 2;
                } else if (b4 != 128) {
                    if ((b4 & 128) != 0) {
                        z = true;
                    }
                    b = b4 & ByteCompanionObject.MAX_VALUE;
                }
                int i5 = i4 + 1;
                try {
                    byte b6 = bArr[i4] & UByte.MAX_VALUE;
                    if (b6 < 128) {
                        i2 = i5;
                        b2 = b6;
                    } else if (b6 == 129) {
                        i4 = i5 + 1;
                        byte b7 = 255 & bArr[i5];
                        if (b7 >= 128) {
                            i2 = i4;
                            b2 = b7;
                        } else {
                            throw new ResultException(ResultCode.CMD_DATA_NOT_UNDERSTOOD, "length < 0x80 length=" + Integer.toHexString(b7) + " startIndex=" + i + " curIndex=" + i4 + " endIndex=" + length);
                        }
                    } else {
                        if (b6 == 130) {
                            b3 = ((bArr[i5] & UByte.MAX_VALUE) << 8) | (255 & bArr[i5 + 1]);
                            i3 = i5 + 2;
                            if (b3 < 256) {
                                try {
                                    throw new ResultException(ResultCode.CMD_DATA_NOT_UNDERSTOOD, "two byte length < 0x100 length=" + Integer.toHexString(b3) + " startIndex=" + i + " curIndex=" + i3 + " endIndex=" + length);
                                } catch (IndexOutOfBoundsException unused) {
                                    i4 = i3;
                                    throw new ResultException(ResultCode.CMD_DATA_NOT_UNDERSTOOD, "IndexOutOfBoundsException startIndex=" + i + " curIndex=" + i4 + " endIndex=" + length);
                                }
                            }
                        } else if (b6 == 131) {
                            b3 = ((bArr[i5] & UByte.MAX_VALUE) << 16) | ((bArr[i5 + 1] & UByte.MAX_VALUE) << 8) | (255 & bArr[i5 + 2]);
                            i3 = i5 + 3;
                            if (b3 < 65536) {
                                throw new ResultException(ResultCode.CMD_DATA_NOT_UNDERSTOOD, "three byte length < 0x10000 length=0x" + Integer.toHexString(b3) + " startIndex=" + i + " curIndex=" + i3 + " endIndex=" + length);
                            }
                        } else {
                            throw new ResultException(ResultCode.CMD_DATA_NOT_UNDERSTOOD, "Bad length modifer=" + b6 + " startIndex=" + i + " curIndex=" + i5 + " endIndex=" + length);
                        }
                        b2 = b3;
                        i2 = i3;
                    }
                    try {
                        return new ComprehensionTlv(b, z, b2, bArr, i2);
                    } catch (IndexOutOfBoundsException unused2) {
                        i4 = i2;
                        throw new ResultException(ResultCode.CMD_DATA_NOT_UNDERSTOOD, "IndexOutOfBoundsException startIndex=" + i + " curIndex=" + i4 + " endIndex=" + length);
                    }
                } catch (IndexOutOfBoundsException unused3) {
                    i4 = i5;
                    throw new ResultException(ResultCode.CMD_DATA_NOT_UNDERSTOOD, "IndexOutOfBoundsException startIndex=" + i + " curIndex=" + i4 + " endIndex=" + length);
                }
            }
            Rlog.d("CAT     ", "decode: unexpected first tag byte=" + Integer.toHexString(b4) + ", startIndex=" + i + " curIndex=" + i4 + " endIndex=" + length);
            return null;
        } catch (IndexOutOfBoundsException unused4) {
            throw new ResultException(ResultCode.CMD_DATA_NOT_UNDERSTOOD, "IndexOutOfBoundsException startIndex=" + i + " curIndex=" + i4 + " endIndex=" + length);
        }
    }
}
