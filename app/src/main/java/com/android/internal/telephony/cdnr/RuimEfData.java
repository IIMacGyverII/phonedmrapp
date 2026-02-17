package com.android.internal.telephony.cdnr;

import android.text.TextUtils;
import com.android.internal.telephony.uicc.RuimRecords;

public final class RuimEfData implements EfData {
    private static final int DEFAULT_CARRIER_NAME_DISPLAY_CONDITION_BITMASK = 0;
    private final RuimRecords mRuim;

    public RuimEfData(RuimRecords ruimRecords) {
        this.mRuim = ruimRecords;
    }

    public String getServiceProviderName() {
        String serviceProviderName = this.mRuim.getServiceProviderName();
        if (TextUtils.isEmpty(serviceProviderName)) {
            return null;
        }
        return serviceProviderName;
    }

    public int getServiceProviderNameDisplayCondition(boolean z) {
        return this.mRuim.getCsimSpnDisplayCondition() ? 2 : 0;
    }
}
