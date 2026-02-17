package androidx.fragment.app.strictmode;

import androidx.annotation.NonNull;
import androidx.fragment.app.Fragment;

public final class GetRetainInstanceUsageViolation extends RetainInstanceUsageViolation {
    GetRetainInstanceUsageViolation(@NonNull Fragment fragment) {
        super(fragment);
    }

    @NonNull
    public String getMessage() {
        return "Attempting to get retain instance for fragment " + this.mFragment;
    }
}
