package com.android.internal.telephony;

import android.content.Context;
import com.android.ims.FeatureConnector;
import com.android.ims.ImsManager;
import com.android.internal.telephony.ImsSmsDispatcher;
import java.util.concurrent.Executor;

/* compiled from: R8$$SyntheticClass */
public final /* synthetic */ class TelephonyComponentFactory$$ExternalSyntheticLambda1 implements ImsSmsDispatcher.FeatureConnectorFactory {
    public final FeatureConnector create(Context context, int i, String str, FeatureConnector.Listener listener, Executor executor) {
        return ImsManager.getConnector(context, i, str, listener, executor);
    }
}
