package androidx.fragment.app.strictmode;

import androidx.annotation.NonNull;
import androidx.fragment.app.Fragment;

public final class GetTargetFragmentRequestCodeUsageViolation extends TargetFragmentUsageViolation {
    GetTargetFragmentRequestCodeUsageViolation(@NonNull Fragment fragment) {
        super(fragment);
    }

    @NonNull
    public String getMessage() {
        return "Attempting to get target request code from fragment " + this.mFragment;
    }
}
