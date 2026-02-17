package com.android.internal.telephony;

import android.hardware.radio.V1_0.IRadio;
import android.os.RemoteException;

public abstract class RadioServiceProxy {
    HalVersion mHalVersion = RIL.RADIO_HAL_VERSION_UNKNOWN;
    boolean mIsAidl;
    volatile IRadio mRadioProxy = null;

    public boolean isAidl() {
        return this.mIsAidl;
    }

    public void setHidl(HalVersion halVersion, IRadio iRadio) {
        this.mHalVersion = halVersion;
        this.mRadioProxy = iRadio;
        this.mIsAidl = false;
    }

    public IRadio getHidl() {
        return this.mRadioProxy;
    }

    public void clear() {
        this.mHalVersion = RIL.RADIO_HAL_VERSION_UNKNOWN;
        this.mRadioProxy = null;
    }

    public boolean isEmpty() {
        return this.mRadioProxy == null;
    }

    public void responseAcknowledgement() throws RemoteException {
        if (!isEmpty() && !isAidl()) {
            this.mRadioProxy.responseAcknowledgement();
        }
    }
}
