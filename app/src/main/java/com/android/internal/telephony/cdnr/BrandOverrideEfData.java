package com.android.internal.telephony.cdnr;

import java.util.Arrays;
import java.util.List;

public final class BrandOverrideEfData implements EfData {
    private final String mRegisteredPlmn;
    private final String mSpn;

    public int getServiceProviderNameDisplayCondition(boolean z) {
        return 2;
    }

    public BrandOverrideEfData(String str, String str2) {
        this.mSpn = str;
        this.mRegisteredPlmn = str2;
    }

    public String getServiceProviderName() {
        return this.mSpn;
    }

    public List<String> getServiceProviderDisplayInformation() {
        return Arrays.asList(new String[]{this.mRegisteredPlmn});
    }
}
