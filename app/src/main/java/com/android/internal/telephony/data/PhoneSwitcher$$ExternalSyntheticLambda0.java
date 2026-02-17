package com.android.internal.telephony.data;

import android.content.Context;
import com.android.ims.ImsManager;
import com.android.internal.telephony.data.PhoneSwitcher;

/* compiled from: R8$$SyntheticClass */
public final /* synthetic */ class PhoneSwitcher$$ExternalSyntheticLambda0 implements PhoneSwitcher.ImsRegTechProvider {
    public final int get(Context context, int i) {
        return ImsManager.getInstance(context, i).getRegistrationTech();
    }
}
