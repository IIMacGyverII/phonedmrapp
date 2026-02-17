package com.android.internal.telephony.d2d;

import android.telephony.ims.RtpHeaderExtension;
import android.telephony.ims.RtpHeaderExtensionType;
import java.util.Set;

public interface RtpAdapter {

    public interface Callback {
        void onRtpHeaderExtensionsReceived(Set<RtpHeaderExtension> set);
    }

    Set<RtpHeaderExtensionType> getAcceptedRtpHeaderExtensions();

    void sendRtpHeaderExtensions(Set<RtpHeaderExtension> set);
}
