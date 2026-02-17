package com.android.internal.telephony.metrics;

import android.telephony.ServiceState;
import com.android.internal.telephony.Phone;
import com.android.internal.telephony.ServiceStateTracker;
import com.android.internal.telephony.SubscriptionController;
import com.android.internal.telephony.TelephonyStatsLog;

public class DataStallRecoveryStats {
    private static final int RECOVERY_ACTION_RADIO_RESTART_MAPPING = 3;
    private static final int RECOVERY_ACTION_RESET_MODEM_MAPPING = 4;

    public static void onDataStallEvent(int i, Phone phone, boolean z, int i2) {
        int i3;
        if (phone.getPhoneType() == 5) {
            phone = phone.getDefaultPhone();
        }
        int carrierId = phone.getCarrierId();
        int rat = getRat(phone);
        if (rat == 18) {
            i3 = 0;
        } else {
            i3 = ServiceStateStats.getBand(phone);
        }
        TelephonyStatsLog.write(315, carrierId, rat, phone.getSignalStrength().getLevel(), i, getIsOpportunistic(phone), SimSlotState.getCurrentState().numActiveSims > 1, i3, z, i2, 0);
    }

    public static void onDataStallEvent(int i, Phone phone, boolean z, int i2, int i3) {
        int i4;
        if (phone.getPhoneType() == 5) {
            phone = phone.getDefaultPhone();
        }
        int carrierId = phone.getCarrierId();
        int rat = getRat(phone);
        if (rat == 18) {
            i4 = 0;
        } else {
            i4 = ServiceStateStats.getBand(phone);
        }
        int level = phone.getSignalStrength().getLevel();
        boolean isOpportunistic = getIsOpportunistic(phone);
        boolean z2 = SimSlotState.getCurrentState().numActiveSims > 1;
        if (i == 3) {
            i = 3;
        } else if (i == 4) {
            i = 4;
        }
        TelephonyStatsLog.write(315, carrierId, rat, level, i, isOpportunistic, z2, i4, z, i2, i3);
    }

    private static int getRat(Phone phone) {
        ServiceStateTracker serviceStateTracker = phone.getServiceStateTracker();
        ServiceState serviceState = serviceStateTracker != null ? serviceStateTracker.getServiceState() : null;
        if (serviceState != null) {
            return serviceState.getDataNetworkType();
        }
        return 0;
    }

    private static boolean getIsOpportunistic(Phone phone) {
        SubscriptionController instance = SubscriptionController.getInstance();
        if (instance != null) {
            return instance.isOpportunistic(phone.getSubId());
        }
        return false;
    }
}
