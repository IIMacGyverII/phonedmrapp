package androidx.fragment.app.strictmode;

import androidx.annotation.NonNull;
import androidx.fragment.app.Fragment;

public abstract class Violation extends RuntimeException {
    final Fragment mFragment;

    Violation(@NonNull Fragment fragment) {
        this.mFragment = fragment;
    }

    @NonNull
    public Fragment getFragment() {
        return this.mFragment;
    }
}
