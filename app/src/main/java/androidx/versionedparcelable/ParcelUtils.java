package androidx.versionedparcelable;

import android.os.Bundle;
import android.os.Parcelable;
import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.annotation.RestrictTo;
import java.io.InputStream;
import java.io.OutputStream;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;

public class ParcelUtils {
    @NonNull
    private static final String INNER_BUNDLE_KEY = "a";

    private ParcelUtils() {
    }

    @NonNull
    @RestrictTo({RestrictTo.Scope.LIBRARY_GROUP_PREFIX})
    public static Parcelable toParcelable(@Nullable VersionedParcelable versionedParcelable) {
        return new ParcelImpl(versionedParcelable);
    }

    @Nullable
    @RestrictTo({RestrictTo.Scope.LIBRARY_GROUP_PREFIX})
    public static <T extends VersionedParcelable> T fromParcelable(@NonNull Parcelable parcelable) {
        if (parcelable instanceof ParcelImpl) {
            return ((ParcelImpl) parcelable).getVersionedParcel();
        }
        throw new IllegalArgumentException("Invalid parcel");
    }

    @RestrictTo({RestrictTo.Scope.LIBRARY_GROUP_PREFIX})
    public static void toOutputStream(@Nullable VersionedParcelable versionedParcelable, @NonNull OutputStream outputStream) {
        VersionedParcelStream versionedParcelStream = new VersionedParcelStream((InputStream) null, outputStream);
        versionedParcelStream.writeVersionedParcelable(versionedParcelable);
        versionedParcelStream.closeField();
    }

    @Nullable
    @RestrictTo({RestrictTo.Scope.LIBRARY_GROUP_PREFIX})
    public static <T extends VersionedParcelable> T fromInputStream(@NonNull InputStream inputStream) {
        return new VersionedParcelStream(inputStream, (OutputStream) null).readVersionedParcelable();
    }

    public static void putVersionedParcelable(@NonNull Bundle bundle, @NonNull String str, @Nullable VersionedParcelable versionedParcelable) {
        if (versionedParcelable == null) {
            bundle.putParcelable(str, (Parcelable) null);
            return;
        }
        Bundle bundle2 = new Bundle();
        bundle2.putParcelable(INNER_BUNDLE_KEY, toParcelable(versionedParcelable));
        bundle.putParcelable(str, bundle2);
    }

    @Nullable
    public static <T extends VersionedParcelable> T getVersionedParcelable(@NonNull Bundle bundle, @NonNull String str) {
        try {
            Bundle bundle2 = (Bundle) bundle.getParcelable(str);
            if (bundle2 == null) {
                return null;
            }
            bundle2.setClassLoader(ParcelUtils.class.getClassLoader());
            return fromParcelable(bundle2.getParcelable(INNER_BUNDLE_KEY));
        } catch (RuntimeException unused) {
            return null;
        }
    }

    public static void putVersionedParcelableList(@NonNull Bundle bundle, @NonNull String str, @NonNull List<? extends VersionedParcelable> list) {
        Bundle bundle2 = new Bundle();
        ArrayList arrayList = new ArrayList();
        for (VersionedParcelable parcelable : list) {
            arrayList.add(toParcelable(parcelable));
        }
        bundle2.putParcelableArrayList(INNER_BUNDLE_KEY, arrayList);
        bundle.putParcelable(str, bundle2);
    }

    @NonNull
    public static <T extends VersionedParcelable> List<T> getVersionedParcelableList(@NonNull Bundle bundle, @Nullable String str) {
        ArrayList arrayList = new ArrayList();
        try {
            Bundle bundle2 = (Bundle) bundle.getParcelable(str);
            bundle2.setClassLoader(ParcelUtils.class.getClassLoader());
            Iterator it = bundle2.getParcelableArrayList(INNER_BUNDLE_KEY).iterator();
            while (it.hasNext()) {
                arrayList.add(fromParcelable((Parcelable) it.next()));
            }
        } catch (RuntimeException unused) {
            arrayList.clear();
        }
        return arrayList;
    }
}
