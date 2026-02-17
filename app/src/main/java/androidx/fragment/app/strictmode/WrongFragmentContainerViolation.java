package androidx.fragment.app.strictmode;

import android.view.ViewGroup;
import androidx.annotation.NonNull;
import androidx.fragment.app.Fragment;

public final class WrongFragmentContainerViolation extends Violation {
    private final ViewGroup mContainer;

    WrongFragmentContainerViolation(@NonNull Fragment fragment, @NonNull ViewGroup viewGroup) {
        super(fragment);
        this.mContainer = viewGroup;
    }

    @NonNull
    public ViewGroup getContainer() {
        return this.mContainer;
    }

    @NonNull
    public String getMessage() {
        return "Attempting to add fragment " + this.mFragment + " to container " + this.mContainer + " which is not a FragmentContainerView";
    }
}
