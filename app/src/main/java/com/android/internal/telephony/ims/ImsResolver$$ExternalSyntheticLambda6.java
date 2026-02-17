package com.android.internal.telephony.ims;

import android.content.Context;
import com.android.internal.telephony.ims.ImsResolver;
import com.android.internal.telephony.ims.ImsServiceFeatureQueryManager;

/* compiled from: R8$$SyntheticClass */
public final /* synthetic */ class ImsResolver$$ExternalSyntheticLambda6 implements ImsResolver.ImsDynamicQueryManagerFactory {
    public final ImsServiceFeatureQueryManager create(Context context, ImsServiceFeatureQueryManager.Listener listener) {
        return new ImsServiceFeatureQueryManager(context, listener);
    }
}
