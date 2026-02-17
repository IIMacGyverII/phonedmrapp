package com.android.internal.telephony;

import android.hardware.radio.config.V1_0.SimSlotStatus;
import android.hardware.radio.config.V1_2.IRadioConfigIndication;
import android.os.AsyncResult;
import com.android.internal.telephony.uicc.IccSlotStatus;
import com.android.telephony.Rlog;
import java.util.ArrayList;

public class RadioConfigIndicationHidl extends IRadioConfigIndication.Stub {
    private static final String TAG = "RadioConfigIndicationHidl";
    private final RadioConfig mRadioConfig;

    public RadioConfigIndicationHidl(RadioConfig radioConfig) {
        this.mRadioConfig = radioConfig;
    }

    public void simSlotsStatusChanged(int i, ArrayList<SimSlotStatus> arrayList) {
        ArrayList<IccSlotStatus> convertHalSlotStatus = RILUtils.convertHalSlotStatus(arrayList);
        logd("[UNSL]< UNSOL_SIM_SLOT_STATUS_CHANGED " + convertHalSlotStatus.toString());
        Registrant registrant = this.mRadioConfig.mSimSlotStatusRegistrant;
        if (registrant != null) {
            registrant.notifyRegistrant(new AsyncResult((Object) null, convertHalSlotStatus, (Throwable) null));
        }
    }

    public void simSlotsStatusChanged_1_2(int i, ArrayList<android.hardware.radio.config.V1_2.SimSlotStatus> arrayList) {
        ArrayList<IccSlotStatus> convertHalSlotStatus = RILUtils.convertHalSlotStatus(arrayList);
        logd("[UNSL]< UNSOL_SIM_SLOT_STATUS_CHANGED " + convertHalSlotStatus.toString());
        Registrant registrant = this.mRadioConfig.mSimSlotStatusRegistrant;
        if (registrant != null) {
            registrant.notifyRegistrant(new AsyncResult((Object) null, convertHalSlotStatus, (Throwable) null));
        }
    }

    private static void logd(String str) {
        Rlog.d(TAG, str);
    }
}
