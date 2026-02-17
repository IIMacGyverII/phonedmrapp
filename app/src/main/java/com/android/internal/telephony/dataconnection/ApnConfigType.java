package com.android.internal.telephony.dataconnection;

public class ApnConfigType {
    private final int mPriority;
    private final int mType;

    public ApnConfigType(int i, int i2) {
        this.mType = i;
        this.mPriority = i2;
    }

    public int getType() {
        return this.mType;
    }

    public int getPriority() {
        return this.mPriority;
    }
}
