package androidx.fragment.app;

import android.os.Bundle;
import androidx.savedstate.SavedStateRegistry;

/* compiled from: R8$$SyntheticClass */
public final /* synthetic */ class FragmentManager$$ExternalSyntheticLambda0 implements SavedStateRegistry.SavedStateProvider {
    public final /* synthetic */ FragmentManager f$0;

    public /* synthetic */ FragmentManager$$ExternalSyntheticLambda0(FragmentManager fragmentManager) {
        this.f$0 = fragmentManager;
    }

    public final Bundle saveState() {
        return this.f$0.lambda$attachController$0();
    }
}
