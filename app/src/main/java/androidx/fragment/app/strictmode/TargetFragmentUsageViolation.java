package androidx.fragment.app.strictmode;

import androidx.annotation.NonNull;
import androidx.fragment.app.Fragment;

public abstract class TargetFragmentUsageViolation extends Violation {
    TargetFragmentUsageViolation(@NonNull Fragment fragment) {
        super(fragment);
    }
}
