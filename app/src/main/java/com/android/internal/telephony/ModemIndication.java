package com.android.internal.telephony;

import android.hardware.radio.modem.HardwareConfig;
import android.hardware.radio.modem.IRadioModemIndication;
import android.hardware.radio.modem.RadioCapability;
import android.os.AsyncResult;
import android.os.Message;
import java.util.ArrayList;

public class ModemIndication extends IRadioModemIndication.Stub {
    private final RIL mRil;

    public String getInterfaceHash() {
        return "9dee2319b599d654955c05268c1eed6ca4373b58";
    }

    public int getInterfaceVersion() {
        return 1;
    }

    public ModemIndication(RIL ril) {
        this.mRil = ril;
    }

    public void hardwareConfigChanged(int i, HardwareConfig[] hardwareConfigArr) {
        this.mRil.processIndication(3, i);
        ArrayList<HardwareConfig> convertHalHardwareConfigList = RILUtils.convertHalHardwareConfigList(hardwareConfigArr);
        this.mRil.unsljLogRet(1040, convertHalHardwareConfigList);
        this.mRil.mHardwareConfigChangeRegistrants.notifyRegistrants(new AsyncResult((Object) null, convertHalHardwareConfigList, (Throwable) null));
    }

    public void modemReset(int i, String str) {
        this.mRil.processIndication(3, i);
        this.mRil.unsljLogRet(1047, str);
        this.mRil.writeMetricsModemRestartEvent(str);
        this.mRil.mModemResetRegistrants.notifyRegistrants(new AsyncResult((Object) null, str, (Throwable) null));
    }

    public void radioCapabilityIndication(int i, RadioCapability radioCapability) {
        this.mRil.processIndication(3, i);
        RadioCapability convertHalRadioCapability = RILUtils.convertHalRadioCapability(radioCapability, this.mRil);
        this.mRil.unsljLogRet(1042, convertHalRadioCapability);
        this.mRil.mPhoneRadioCapabilityChangedRegistrants.notifyRegistrants(new AsyncResult((Object) null, convertHalRadioCapability, (Throwable) null));
    }

    public void radioStateChanged(int i, int i2) {
        this.mRil.processIndication(3, i);
        int convertHalRadioState = RILUtils.convertHalRadioState(i2);
        RIL ril = this.mRil;
        ril.unsljLogMore(1000, "radioStateChanged: " + convertHalRadioState);
        this.mRil.setRadioState(convertHalRadioState, false);
    }

    public void rilConnected(int i) {
        this.mRil.processIndication(3, i);
        this.mRil.unsljLog(1034);
        this.mRil.setRadioPower(false, (Message) null);
        RIL ril = this.mRil;
        ril.setCdmaSubscriptionSource(ril.mCdmaSubscription, (Message) null);
        this.mRil.notifyRegistrantsRilConnectionChanged(15);
    }
}
