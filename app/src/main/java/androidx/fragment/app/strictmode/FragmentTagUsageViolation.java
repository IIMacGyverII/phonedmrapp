package androidx.fragment.app.strictmode;

import android.view.ViewGroup;
import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.fragment.app.Fragment;

public final class FragmentTagUsageViolation extends Violation {
    @Nullable
    private final ViewGroup mContainer;

    FragmentTagUsageViolation(@NonNull Fragment fragment, @Nullable ViewGroup viewGroup) {
        super(fragment);
        this.mContainer = viewGroup;
    }

    @Nullable
    public ViewGroup getParentContainer() {
        return this.mContainer;
    }

    @NonNull
    public String getMessage() {
        return "Attempting to use <fragment> tag to add fragment " + this.mFragment + " to container " + this.mContainer;
    }
}
