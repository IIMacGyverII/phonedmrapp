package com.mediatek.res;

import android.content.Context;
import android.content.SharedPreferences;

/* compiled from: R8$$SyntheticClass */
public final /* synthetic */ class AsyncDrawableCache$$ExternalSyntheticLambda0 implements Runnable {
    public final /* synthetic */ SharedPreferences f$0;
    public final /* synthetic */ Context f$1;

    public /* synthetic */ AsyncDrawableCache$$ExternalSyntheticLambda0(SharedPreferences sharedPreferences, Context context) {
        this.f$0 = sharedPreferences;
        this.f$1 = context;
    }

    public final void run() {
        AsyncDrawableCache.lambda$preloadRes$0(this.f$0, this.f$1);
    }
}
