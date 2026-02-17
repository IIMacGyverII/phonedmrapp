package androidx.core.view;

import android.view.WindowInsetsController;
import androidx.core.view.WindowInsetsControllerCompat;

/* compiled from: R8$$SyntheticClass */
public final /* synthetic */ class WindowInsetsControllerCompat$Impl30$$ExternalSyntheticLambda0 implements WindowInsetsController.OnControllableInsetsChangedListener {
    public final /* synthetic */ WindowInsetsControllerCompat.Impl30 f$0;
    public final /* synthetic */ WindowInsetsControllerCompat.OnControllableInsetsChangedListener f$1;

    public /* synthetic */ WindowInsetsControllerCompat$Impl30$$ExternalSyntheticLambda0(WindowInsetsControllerCompat.Impl30 impl30, WindowInsetsControllerCompat.OnControllableInsetsChangedListener onControllableInsetsChangedListener) {
        this.f$0 = impl30;
        this.f$1 = onControllableInsetsChangedListener;
    }

    public final void onControllableInsetsChanged(WindowInsetsController windowInsetsController, int i) {
        this.f$0.lambda$addOnControllableInsetsChangedListener$0(this.f$1, windowInsetsController, i);
    }
}
