package com.android.internal.telephony.cdnr;

public final class EriEfData implements EfData {
    private final String mEriText;

    public EriEfData(String str) {
        this.mEriText = str;
    }

    public String getServiceProviderName() {
        return this.mEriText;
    }
}
