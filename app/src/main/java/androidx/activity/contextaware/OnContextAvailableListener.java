package androidx.activity.contextaware;

import android.content.Context;
import androidx.annotation.NonNull;

public interface OnContextAvailableListener {
    void onContextAvailable(@NonNull Context context);
}
