package com.android.internal.telephony.dataconnection;

import android.net.NetworkRequest;
import android.net.NetworkSpecifier;
import android.net.TelephonyNetworkSpecifier;
import com.android.telephony.Rlog;

public class DcRequest implements Comparable<DcRequest> {
    private static final String LOG_TAG = "DcRequest";
    public final int apnType;
    public final NetworkRequest networkRequest;
    public final int priority;

    private DcRequest(NetworkRequest networkRequest2, int i, int i2) {
        this.networkRequest = networkRequest2;
        this.priority = i2;
        this.apnType = i;
    }

    public static DcRequest create(NetworkRequest networkRequest2, ApnConfigTypeRepository apnConfigTypeRepository) {
        int apnTypeFromNetworkRequest = ApnContext.getApnTypeFromNetworkRequest(networkRequest2);
        ApnConfigType byType = apnConfigTypeRepository.getByType(apnTypeFromNetworkRequest);
        if (byType == null) {
            Rlog.d(LOG_TAG, "Non cellular request ignored: " + networkRequest2.toString());
            checkForAnomalousNetworkRequest(networkRequest2);
            return null;
        }
        Rlog.d(LOG_TAG, "Cellular request confirmed: " + networkRequest2.toString());
        return new DcRequest(networkRequest2, apnTypeFromNetworkRequest, byType.getPriority());
    }

    private static void checkForAnomalousNetworkRequest(NetworkRequest networkRequest2) {
        NetworkSpecifier networkSpecifier = networkRequest2.getNetworkSpecifier();
        if (networkSpecifier != null && (networkSpecifier instanceof TelephonyNetworkSpecifier)) {
            reportAnomalousNetworkRequest(networkRequest2);
        }
    }

    private static void reportAnomalousNetworkRequest(NetworkRequest networkRequest2) {
        Rlog.w(LOG_TAG, "A TelephonyNetworkSpecifier for a non-cellular request is invalid: " + networkRequest2.toString());
    }

    public String toString() {
        return this.networkRequest.toString() + ", priority=" + this.priority + ", apnType=" + this.apnType;
    }

    public int hashCode() {
        return this.networkRequest.hashCode();
    }

    public boolean equals(Object obj) {
        if (obj instanceof DcRequest) {
            return this.networkRequest.equals(((DcRequest) obj).networkRequest);
        }
        return false;
    }

    public int compareTo(DcRequest dcRequest) {
        return dcRequest.priority - this.priority;
    }
}
