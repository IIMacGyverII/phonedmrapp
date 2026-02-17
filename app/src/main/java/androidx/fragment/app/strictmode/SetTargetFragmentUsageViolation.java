package androidx.fragment.app.strictmode;

import androidx.annotation.NonNull;
import androidx.fragment.app.Fragment;

public final class SetTargetFragmentUsageViolation extends TargetFragmentUsageViolation {
    private final int mRequestCode;
    private final Fragment mTargetFragment;

    SetTargetFragmentUsageViolation(@NonNull Fragment fragment, @NonNull Fragment fragment2, int i) {
        super(fragment);
        this.mTargetFragment = fragment2;
        this.mRequestCode = i;
    }

    @NonNull
    public Fragment getTargetFragment() {
        return this.mTargetFragment;
    }

    public int getRequestCode() {
        return this.mRequestCode;
    }

    @NonNull
    public String getMessage() {
        return "Attempting to set target fragment " + this.mTargetFragment + " with request code " + this.mRequestCode + " for fragment " + this.mFragment;
    }
}
