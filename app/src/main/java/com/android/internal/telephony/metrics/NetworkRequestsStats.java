package com.android.internal.telephony.metrics;

import android.net.NetworkRequest;
import android.telephony.SubscriptionManager;
import com.android.internal.telephony.Phone;
import com.android.internal.telephony.PhoneFactory;
import com.android.internal.telephony.nano.PersistAtomsProto;

public class NetworkRequestsStats {
    private NetworkRequestsStats() {
    }

    public static void addNetworkRequest(NetworkRequest networkRequest, int i) {
        PersistAtomsStorage atomsStorage = PhoneFactory.getMetricsCollector().getAtomsStorage();
        PersistAtomsProto.NetworkRequestsV2 networkRequestsV2 = new PersistAtomsProto.NetworkRequestsV2();
        networkRequestsV2.carrierId = getCarrierId(i);
        networkRequestsV2.requestCount = 1;
        if (networkRequest.hasCapability(34)) {
            networkRequestsV2.capability = 1;
            atomsStorage.addNetworkRequestsV2(networkRequestsV2);
        }
        if (networkRequest.hasCapability(35)) {
            networkRequestsV2.capability = 2;
            atomsStorage.addNetworkRequestsV2(networkRequestsV2);
        }
        if (networkRequest.hasCapability(5)) {
            networkRequestsV2.capability = 3;
            atomsStorage.addNetworkRequestsV2(networkRequestsV2);
        }
        if (networkRequest.hasCapability(29)) {
            networkRequestsV2.capability = 4;
            atomsStorage.addNetworkRequestsV2(networkRequestsV2);
        }
    }

    private static int getCarrierId(int i) {
        Phone phone = PhoneFactory.getPhone(SubscriptionManager.getPhoneId(i));
        if (phone != null) {
            return phone.getCarrierId();
        }
        return -1;
    }
}
