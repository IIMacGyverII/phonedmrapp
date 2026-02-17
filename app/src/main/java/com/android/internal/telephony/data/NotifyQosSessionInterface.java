package com.android.internal.telephony.data;

import android.net.QosSessionAttributes;

public interface NotifyQosSessionInterface {
    void notifyQosSessionAvailable(int i, int i2, QosSessionAttributes qosSessionAttributes);

    void notifyQosSessionLost(int i, int i2, int i3);
}
