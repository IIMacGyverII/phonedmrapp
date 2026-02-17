package androidx.fragment.app.strictmode;

import androidx.annotation.NonNull;
import androidx.fragment.app.Fragment;

public final class FragmentReuseViolation extends Violation {
    @NonNull
    private final String mPreviousWho;

    FragmentReuseViolation(@NonNull Fragment fragment, @NonNull String str) {
        super(fragment);
        this.mPreviousWho = str;
    }

    @NonNull
    public String getPreviousFragmentId() {
        return this.mPreviousWho;
    }

    @NonNull
    public String getMessage() {
        return "Attempting to reuse fragment " + this.mFragment + " with previous ID " + this.mPreviousWho;
    }
}
