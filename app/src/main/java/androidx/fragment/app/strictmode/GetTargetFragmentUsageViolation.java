package androidx.fragment.app.strictmode;

import androidx.annotation.NonNull;
import androidx.fragment.app.Fragment;

public final class GetTargetFragmentUsageViolation extends TargetFragmentUsageViolation {
    GetTargetFragmentUsageViolation(@NonNull Fragment fragment) {
        super(fragment);
    }

    @NonNull
    public String getMessage() {
        return "Attempting to get target fragment from fragment " + this.mFragment;
    }
}
