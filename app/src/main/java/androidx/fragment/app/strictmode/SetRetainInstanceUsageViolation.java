package androidx.fragment.app.strictmode;

import androidx.annotation.NonNull;
import androidx.fragment.app.Fragment;

public final class SetRetainInstanceUsageViolation extends RetainInstanceUsageViolation {
    SetRetainInstanceUsageViolation(@NonNull Fragment fragment) {
        super(fragment);
    }

    @NonNull
    public String getMessage() {
        return "Attempting to set retain instance for fragment " + this.mFragment;
    }
}
