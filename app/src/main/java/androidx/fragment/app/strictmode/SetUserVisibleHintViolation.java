package androidx.fragment.app.strictmode;

import androidx.annotation.NonNull;
import androidx.fragment.app.Fragment;

public final class SetUserVisibleHintViolation extends Violation {
    private final boolean mIsVisibleToUser;

    SetUserVisibleHintViolation(@NonNull Fragment fragment, boolean z) {
        super(fragment);
        this.mIsVisibleToUser = z;
    }

    public boolean isVisibleToUser() {
        return this.mIsVisibleToUser;
    }

    @NonNull
    public String getMessage() {
        return "Attempting to set user visible hint to " + this.mIsVisibleToUser + " for fragment " + this.mFragment;
    }
}
