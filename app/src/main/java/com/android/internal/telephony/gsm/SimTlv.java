package com.android.internal.telephony.gsm;

import android.compat.annotation.UnsupportedAppUsage;
import kotlin.UByte;

public class SimTlv {
    int mCurDataLength;
    int mCurDataOffset;
    int mCurOffset;
    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    boolean mHasValidTlvObject = parseCurrentTlvObject();
    byte[] mRecord;
    int mTlvLength;
    int mTlvOffset;

    @UnsupportedAppUsage
    public SimTlv(byte[] bArr, int i, int i2) {
        this.mRecord = bArr;
        this.mTlvOffset = i;
        this.mTlvLength = i2;
        this.mCurOffset = i;
    }

    @UnsupportedAppUsage
    public boolean nextObject() {
        if (!this.mHasValidTlvObject) {
            return false;
        }
        this.mCurOffset = this.mCurDataOffset + this.mCurDataLength;
        boolean parseCurrentTlvObject = parseCurrentTlvObject();
        this.mHasValidTlvObject = parseCurrentTlvObject;
        return parseCurrentTlvObject;
    }

    @UnsupportedAppUsage
    public boolean isValidObject() {
        return this.mHasValidTlvObject;
    }

    @UnsupportedAppUsage
    public int getTag() {
        if (!this.mHasValidTlvObject) {
            return 0;
        }
        return this.mRecord[this.mCurOffset] & UByte.MAX_VALUE;
    }

    @UnsupportedAppUsage
    public byte[] getData() {
        if (!this.mHasValidTlvObject) {
            return null;
        }
        int i = this.mCurDataLength;
        byte[] bArr = new byte[i];
        System.arraycopy(this.mRecord, this.mCurDataOffset, bArr, 0, i);
        return bArr;
    }

    private boolean parseCurrentTlvObject() {
        try {
            byte[] bArr = this.mRecord;
            int i = this.mCurOffset;
            byte b = bArr[i];
            if (b != 0) {
                if ((b & UByte.MAX_VALUE) != 255) {
                    if ((bArr[i + 1] & UByte.MAX_VALUE) < 128) {
                        this.mCurDataLength = bArr[i + 1] & UByte.MAX_VALUE;
                        this.mCurDataOffset = i + 2;
                    } else if ((bArr[i + 1] & UByte.MAX_VALUE) == 129) {
                        this.mCurDataLength = bArr[i + 2] & UByte.MAX_VALUE;
                        this.mCurDataOffset = i + 3;
                    }
                    if (this.mCurDataLength + this.mCurDataOffset > this.mTlvOffset + this.mTlvLength) {
                        return false;
                    }
                    return true;
                }
            }
        } catch (ArrayIndexOutOfBoundsException unused) {
        }
        return false;
    }
}
