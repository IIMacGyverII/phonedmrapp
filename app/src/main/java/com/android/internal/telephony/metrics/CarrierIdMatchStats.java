package com.android.internal.telephony.metrics;

import com.android.internal.telephony.PhoneFactory;
import com.android.internal.telephony.TelephonyStatsLog;
import com.android.internal.telephony.nano.PersistAtomsProto;
import com.android.telephony.Rlog;

public class CarrierIdMatchStats {
    private static final String TAG = "CarrierIdMatchStats";

    private static String nullToEmpty(String str) {
        return str != null ? str : "";
    }

    private CarrierIdMatchStats() {
    }

    public static void onCarrierIdMismatch(int i, String str, String str2, String str3, String str4) {
        PersistAtomsStorage atomsStorage = PhoneFactory.getMetricsCollector().getAtomsStorage();
        PersistAtomsProto.CarrierIdMismatch carrierIdMismatch = new PersistAtomsProto.CarrierIdMismatch();
        carrierIdMismatch.mccMnc = nullToEmpty(str);
        carrierIdMismatch.gid1 = nullToEmpty(str2);
        String nullToEmpty = nullToEmpty(str3);
        carrierIdMismatch.spn = nullToEmpty;
        carrierIdMismatch.pnn = nullToEmpty.isEmpty() ? nullToEmpty(str4) : "";
        if (atomsStorage.addCarrierIdMismatch(carrierIdMismatch)) {
            String str5 = TAG;
            Rlog.d(str5, "New carrier ID mismatch event: " + carrierIdMismatch.toString());
            TelephonyStatsLog.write(313, i, str, str2, str3, str4);
        }
    }

    public static void sendCarrierIdTableVersion(int i) {
        if (PhoneFactory.getMetricsCollector().getAtomsStorage().setCarrierIdTableVersion(i)) {
            String str = TAG;
            Rlog.d(str, "New carrier ID table version: " + i);
            TelephonyStatsLog.write(314, i);
        }
    }
}
