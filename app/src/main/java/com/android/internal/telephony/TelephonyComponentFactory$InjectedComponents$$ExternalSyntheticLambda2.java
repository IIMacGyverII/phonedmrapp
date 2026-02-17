package com.android.internal.telephony;

import com.android.internal.telephony.TelephonyComponentFactory;
import java.util.function.Consumer;
import org.xmlpull.v1.XmlPullParser;

/* compiled from: R8$$SyntheticClass */
public final /* synthetic */ class TelephonyComponentFactory$InjectedComponents$$ExternalSyntheticLambda2 implements Consumer {
    public final /* synthetic */ TelephonyComponentFactory.InjectedComponents f$0;

    public /* synthetic */ TelephonyComponentFactory$InjectedComponents$$ExternalSyntheticLambda2(TelephonyComponentFactory.InjectedComponents injectedComponents) {
        this.f$0 = injectedComponents;
    }

    public final void accept(Object obj) {
        this.f$0.lambda$parseComponents$4((XmlPullParser) obj);
    }
}
