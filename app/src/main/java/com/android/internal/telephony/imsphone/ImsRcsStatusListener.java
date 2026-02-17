package com.android.internal.telephony.imsphone;

import com.android.ims.RcsFeatureManager;

public interface ImsRcsStatusListener {
    void onRcsConnected(int i, RcsFeatureManager rcsFeatureManager);

    void onRcsDisconnected(int i);
}
