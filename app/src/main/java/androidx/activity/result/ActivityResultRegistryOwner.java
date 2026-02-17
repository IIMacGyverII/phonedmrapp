package androidx.activity.result;

import androidx.annotation.NonNull;

public interface ActivityResultRegistryOwner {
    @NonNull
    ActivityResultRegistry getActivityResultRegistry();
}
