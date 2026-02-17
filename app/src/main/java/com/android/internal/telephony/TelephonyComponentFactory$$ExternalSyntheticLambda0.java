package com.android.internal.telephony;

import android.content.Context;
import com.android.ims.FeatureConnector;
import com.android.ims.ImsManager;
import com.android.internal.telephony.imsphone.ImsPhoneCallTracker;
import java.util.concurrent.Executor;

/* compiled from: R8$$SyntheticClass */
public final /* synthetic */ class TelephonyComponentFactory$$ExternalSyntheticLambda0 implements ImsPhoneCallTracker.ConnectorFactory {
    public final FeatureConnector create(Context context, int i, String str, FeatureConnector.Listener listener, Executor executor) {
        return ImsManager.getConnector(context, i, str, listener, executor);
    }
}
