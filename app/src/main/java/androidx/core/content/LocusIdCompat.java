package androidx.core.content;

import android.content.LocusId;
import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.annotation.RequiresApi;
import androidx.core.util.Preconditions;

public final class LocusIdCompat {
    private final String mId;
    private final LocusId mWrapped;

    public LocusIdCompat(@NonNull String str) {
        this.mId = (String) Preconditions.checkStringNotEmpty(str, "id cannot be empty");
        this.mWrapped = Api29Impl.create(str);
    }

    @NonNull
    public String getId() {
        return this.mId;
    }

    public int hashCode() {
        String str = this.mId;
        return 31 + (str == null ? 0 : str.hashCode());
    }

    public boolean equals(@Nullable Object obj) {
        if (this == obj) {
            return true;
        }
        if (obj == null || LocusIdCompat.class != obj.getClass()) {
            return false;
        }
        LocusIdCompat locusIdCompat = (LocusIdCompat) obj;
        String str = this.mId;
        if (str != null) {
            return str.equals(locusIdCompat.mId);
        }
        if (locusIdCompat.mId == null) {
            return true;
        }
        return false;
    }

    @NonNull
    public String toString() {
        return "LocusIdCompat[" + getSanitizedId() + "]";
    }

    @RequiresApi(29)
    @NonNull
    public LocusId toLocusId() {
        return this.mWrapped;
    }

    @RequiresApi(29)
    @NonNull
    public static LocusIdCompat toLocusIdCompat(@NonNull LocusId locusId) {
        Preconditions.checkNotNull(locusId, "locusId cannot be null");
        return new LocusIdCompat((String) Preconditions.checkStringNotEmpty(Api29Impl.getId(locusId), "id cannot be empty"));
    }

    @NonNull
    private String getSanitizedId() {
        int length = this.mId.length();
        return length + "_chars";
    }

    @RequiresApi(29)
    private static class Api29Impl {
        private Api29Impl() {
        }

        @NonNull
        static LocusId create(@NonNull String str) {
            return new LocusId(str);
        }

        @NonNull
        static String getId(@NonNull LocusId locusId) {
            return locusId.getId();
        }
    }
}
