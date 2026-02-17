package androidx.fragment.app.strictmode;

import androidx.annotation.NonNull;
import androidx.fragment.app.Fragment;

public abstract class RetainInstanceUsageViolation extends Violation {
    RetainInstanceUsageViolation(@NonNull Fragment fragment) {
        super(fragment);
    }
}
