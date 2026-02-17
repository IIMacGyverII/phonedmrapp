package com.android.internal.telephony;

import android.hardware.radio.config.IRadioConfigIndication;
import android.hardware.radio.config.SimSlotStatus;
import android.os.AsyncResult;
import com.android.internal.telephony.uicc.IccSlotStatus;
import com.android.telephony.Rlog;
import java.util.ArrayList;

public class RadioConfigIndicationAidl extends IRadioConfigIndication.Stub {
    private static final String TAG = "RadioConfigIndicationAidl";
    private final RadioConfig mRadioConfig;

    public String getInterfaceHash() {
        return "dd9c3f8e21930f9b4c46a4125bd5f5cec90318ec";
    }

    public int getInterfaceVersion() {
        return 1;
    }

    public RadioConfigIndicationAidl(RadioConfig radioConfig) {
        this.mRadioConfig = radioConfig;
    }

    public void simSlotsStatusChanged(int i, SimSlotStatus[] simSlotStatusArr) {
        ArrayList<IccSlotStatus> convertHalSlotStatus = RILUtils.convertHalSlotStatus(simSlotStatusArr);
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
