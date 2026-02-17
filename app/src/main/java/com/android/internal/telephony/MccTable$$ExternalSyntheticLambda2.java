package com.android.internal.telephony;

import android.app.ActivityManager;
import java.util.function.Function;

/* compiled from: R8$$SyntheticClass */
public final /* synthetic */ class MccTable$$ExternalSyntheticLambda2 implements Function {
    public final Object apply(Object obj) {
        return ((ActivityManager.RunningTaskInfo) obj).topActivity.getClassName();
    }
}
