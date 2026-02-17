package androidx.preference;

import android.content.Context;
import android.util.AttributeSet;
import android.widget.LinearLayout;
import androidx.annotation.RestrictTo;

@RestrictTo({RestrictTo.Scope.LIBRARY_GROUP_PREFIX})
public class UnPressableLinearLayout extends LinearLayout {
    /* access modifiers changed from: protected */
    public void dispatchSetPressed(boolean z) {
    }

    public UnPressableLinearLayout(Context context) {
        this(context, (AttributeSet) null);
    }

    public UnPressableLinearLayout(Context context, AttributeSet attributeSet) {
        super(context, attributeSet);
    }
}
