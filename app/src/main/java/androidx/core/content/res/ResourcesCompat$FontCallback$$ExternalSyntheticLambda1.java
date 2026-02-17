package androidx.core.content.res;

import androidx.core.content.res.ResourcesCompat;

/* compiled from: R8$$SyntheticClass */
public final /* synthetic */ class ResourcesCompat$FontCallback$$ExternalSyntheticLambda1 implements Runnable {
    public final /* synthetic */ ResourcesCompat.FontCallback f$0;
    public final /* synthetic */ int f$1;

    public /* synthetic */ ResourcesCompat$FontCallback$$ExternalSyntheticLambda1(ResourcesCompat.FontCallback fontCallback, int i) {
        this.f$0 = fontCallback;
        this.f$1 = i;
    }

    public final void run() {
        this.f$0.lambda$callbackFailAsync$1(this.f$1);
    }
}
