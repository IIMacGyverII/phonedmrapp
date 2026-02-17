package com.android.internal.telephony.cdnr;

import android.text.TextUtils;
import com.android.internal.telephony.uicc.IccRecords;
import com.android.internal.telephony.uicc.SIMRecords;
import java.util.Arrays;
import java.util.List;

public final class UsimEfData implements EfData {
    private final SIMRecords mUsim;

    public List<IccRecords.OperatorPlmnInfo> getOperatorPlmnList() {
        return null;
    }

    public UsimEfData(SIMRecords sIMRecords) {
        this.mUsim = sIMRecords;
    }

    public String getServiceProviderName() {
        String serviceProviderName = this.mUsim.getServiceProviderName();
        if (TextUtils.isEmpty(serviceProviderName)) {
            return null;
        }
        return serviceProviderName;
    }

    public int getServiceProviderNameDisplayCondition(boolean z) {
        if (z) {
            return this.mUsim.getCarrierNameDisplayCondition() | 1;
        }
        return this.mUsim.getCarrierNameDisplayCondition() | 2;
    }

    public List<String> getServiceProviderDisplayInformation() {
        String[] serviceProviderDisplayInformation = this.mUsim.getServiceProviderDisplayInformation();
        if (serviceProviderDisplayInformation != null) {
            return Arrays.asList(serviceProviderDisplayInformation);
        }
        return null;
    }

    public List<String> getEhplmnList() {
        String[] ehplmns = this.mUsim.getEhplmns();
        if (ehplmns != null) {
            return Arrays.asList(ehplmns);
        }
        return null;
    }

    public List<IccRecords.PlmnNetworkName> getPlmnNetworkNameList() {
        String pnnHomeName = this.mUsim.getPnnHomeName();
        if (TextUtils.isEmpty(pnnHomeName)) {
            return null;
        }
        return Arrays.asList(new IccRecords.PlmnNetworkName[]{new IccRecords.PlmnNetworkName(pnnHomeName, "")});
    }
}
