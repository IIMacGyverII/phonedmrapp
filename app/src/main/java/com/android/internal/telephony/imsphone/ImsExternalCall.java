package com.android.internal.telephony.imsphone;

import android.compat.annotation.UnsupportedAppUsage;
import com.android.internal.telephony.Call;
import com.android.internal.telephony.CallStateException;
import com.android.internal.telephony.Phone;

public class ImsExternalCall extends Call {
    private Phone mPhone;

    public void hangup() throws CallStateException {
    }

    public void hangup(int i) throws CallStateException {
    }

    public boolean isMultiparty() {
        return false;
    }

    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    public ImsExternalCall(Phone phone, ImsExternalConnection imsExternalConnection) {
        this.mPhone = phone;
        addConnection(imsExternalConnection);
    }

    public Phone getPhone() {
        return this.mPhone;
    }

    public void setActive() {
        setState(Call.State.ACTIVE);
    }

    public void setTerminated() {
        setState(Call.State.DISCONNECTED);
    }
}
