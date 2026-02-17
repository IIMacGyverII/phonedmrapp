package androidx.core.app;

import android.app.RemoteInput;
import android.content.ClipData;
import android.content.ClipDescription;
import android.content.Intent;
import android.net.Uri;
import android.os.Bundle;
import androidx.annotation.DoNotInline;
import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.annotation.RequiresApi;
import androidx.annotation.RestrictTo;
import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;
import java.util.HashSet;
import java.util.Map;
import java.util.Set;

public final class RemoteInput {
    public static final int EDIT_CHOICES_BEFORE_SENDING_AUTO = 0;
    public static final int EDIT_CHOICES_BEFORE_SENDING_DISABLED = 1;
    public static final int EDIT_CHOICES_BEFORE_SENDING_ENABLED = 2;
    private static final String EXTRA_DATA_TYPE_RESULTS_DATA = "android.remoteinput.dataTypeResultsData";
    public static final String EXTRA_RESULTS_DATA = "android.remoteinput.resultsData";
    private static final String EXTRA_RESULTS_SOURCE = "android.remoteinput.resultsSource";
    public static final String RESULTS_CLIP_LABEL = "android.remoteinput.results";
    public static final int SOURCE_CHOICE = 1;
    public static final int SOURCE_FREE_FORM_INPUT = 0;
    private final boolean mAllowFreeFormTextInput;
    private final Set<String> mAllowedDataTypes;
    private final CharSequence[] mChoices;
    private final int mEditChoicesBeforeSending;
    private final Bundle mExtras;
    private final CharSequence mLabel;
    private final String mResultKey;

    @RestrictTo({RestrictTo.Scope.LIBRARY_GROUP_PREFIX})
    @Retention(RetentionPolicy.SOURCE)
    public @interface EditChoicesBeforeSending {
    }

    @RestrictTo({RestrictTo.Scope.LIBRARY_GROUP_PREFIX})
    @Retention(RetentionPolicy.SOURCE)
    public @interface Source {
    }

    RemoteInput(String str, CharSequence charSequence, CharSequence[] charSequenceArr, boolean z, int i, Bundle bundle, Set<String> set) {
        this.mResultKey = str;
        this.mLabel = charSequence;
        this.mChoices = charSequenceArr;
        this.mAllowFreeFormTextInput = z;
        this.mEditChoicesBeforeSending = i;
        this.mExtras = bundle;
        this.mAllowedDataTypes = set;
        if (getEditChoicesBeforeSending() == 2 && !getAllowFreeFormInput()) {
            throw new IllegalArgumentException("setEditChoicesBeforeSending requires setAllowFreeFormInput");
        }
    }

    @NonNull
    public String getResultKey() {
        return this.mResultKey;
    }

    @Nullable
    public CharSequence getLabel() {
        return this.mLabel;
    }

    @Nullable
    public CharSequence[] getChoices() {
        return this.mChoices;
    }

    @Nullable
    public Set<String> getAllowedDataTypes() {
        return this.mAllowedDataTypes;
    }

    public boolean isDataOnly() {
        return !getAllowFreeFormInput() && (getChoices() == null || getChoices().length == 0) && getAllowedDataTypes() != null && !getAllowedDataTypes().isEmpty();
    }

    public boolean getAllowFreeFormInput() {
        return this.mAllowFreeFormTextInput;
    }

    public int getEditChoicesBeforeSending() {
        return this.mEditChoicesBeforeSending;
    }

    @NonNull
    public Bundle getExtras() {
        return this.mExtras;
    }

    public static final class Builder {
        private boolean mAllowFreeFormTextInput = true;
        private final Set<String> mAllowedDataTypes = new HashSet();
        private CharSequence[] mChoices;
        private int mEditChoicesBeforeSending = 0;
        private final Bundle mExtras = new Bundle();
        private CharSequence mLabel;
        private final String mResultKey;

        public Builder(@NonNull String str) {
            if (str != null) {
                this.mResultKey = str;
                return;
            }
            throw new IllegalArgumentException("Result key can't be null");
        }

        @NonNull
        public Builder setLabel(@Nullable CharSequence charSequence) {
            this.mLabel = charSequence;
            return this;
        }

        @NonNull
        public Builder setChoices(@Nullable CharSequence[] charSequenceArr) {
            this.mChoices = charSequenceArr;
            return this;
        }

        @NonNull
        public Builder setAllowDataType(@NonNull String str, boolean z) {
            if (z) {
                this.mAllowedDataTypes.add(str);
            } else {
                this.mAllowedDataTypes.remove(str);
            }
            return this;
        }

        @NonNull
        public Builder setAllowFreeFormInput(boolean z) {
            this.mAllowFreeFormTextInput = z;
            return this;
        }

        @NonNull
        public Builder setEditChoicesBeforeSending(int i) {
            this.mEditChoicesBeforeSending = i;
            return this;
        }

        @NonNull
        public Builder addExtras(@NonNull Bundle bundle) {
            if (bundle != null) {
                this.mExtras.putAll(bundle);
            }
            return this;
        }

        @NonNull
        public Bundle getExtras() {
            return this.mExtras;
        }

        @NonNull
        public RemoteInput build() {
            return new RemoteInput(this.mResultKey, this.mLabel, this.mChoices, this.mAllowFreeFormTextInput, this.mEditChoicesBeforeSending, this.mExtras, this.mAllowedDataTypes);
        }
    }

    @Nullable
    public static Map<String, Uri> getDataResultsFromIntent(@NonNull Intent intent, @NonNull String str) {
        return Api26Impl.getDataResultsFromIntent(intent, str);
    }

    @Nullable
    public static Bundle getResultsFromIntent(@NonNull Intent intent) {
        return Api20Impl.getResultsFromIntent(intent);
    }

    public static void addResultsToIntent(@NonNull RemoteInput[] remoteInputArr, @NonNull Intent intent, @NonNull Bundle bundle) {
        Api20Impl.addResultsToIntent(fromCompat(remoteInputArr), intent, bundle);
    }

    public static void addDataResultToIntent(@NonNull RemoteInput remoteInput, @NonNull Intent intent, @NonNull Map<String, Uri> map) {
        Api26Impl.addDataResultToIntent(remoteInput, intent, map);
    }

    public static void setResultsSource(@NonNull Intent intent, int i) {
        Api28Impl.setResultsSource(intent, i);
    }

    public static int getResultsSource(@NonNull Intent intent) {
        return Api28Impl.getResultsSource(intent);
    }

    private static String getExtraResultsKeyForData(String str) {
        return EXTRA_DATA_TYPE_RESULTS_DATA + str;
    }

    @RequiresApi(20)
    static android.app.RemoteInput[] fromCompat(RemoteInput[] remoteInputArr) {
        if (remoteInputArr == null) {
            return null;
        }
        android.app.RemoteInput[] remoteInputArr2 = new android.app.RemoteInput[remoteInputArr.length];
        for (int i = 0; i < remoteInputArr.length; i++) {
            remoteInputArr2[i] = fromCompat(remoteInputArr[i]);
        }
        return remoteInputArr2;
    }

    @RequiresApi(20)
    static android.app.RemoteInput fromCompat(RemoteInput remoteInput) {
        return Api20Impl.fromCompat(remoteInput);
    }

    @RequiresApi(20)
    static RemoteInput fromPlatform(android.app.RemoteInput remoteInput) {
        return Api20Impl.fromPlatform(remoteInput);
    }

    @RequiresApi(16)
    private static Intent getClipDataIntentFromIntent(Intent intent) {
        ClipData clipData = Api16Impl.getClipData(intent);
        if (clipData == null) {
            return null;
        }
        ClipDescription description = clipData.getDescription();
        if (description.hasMimeType("text/vnd.android.intent") && description.getLabel().toString().contentEquals(RESULTS_CLIP_LABEL)) {
            return clipData.getItemAt(0).getIntent();
        }
        return null;
    }

    @RequiresApi(26)
    static class Api26Impl {
        private Api26Impl() {
        }

        @DoNotInline
        static Map<String, Uri> getDataResultsFromIntent(Intent intent, String str) {
            return android.app.RemoteInput.getDataResultsFromIntent(intent, str);
        }

        @DoNotInline
        static Set<String> getAllowedDataTypes(Object obj) {
            return ((android.app.RemoteInput) obj).getAllowedDataTypes();
        }

        @DoNotInline
        static void addDataResultToIntent(RemoteInput remoteInput, Intent intent, Map<String, Uri> map) {
            android.app.RemoteInput.addDataResultToIntent(RemoteInput.fromCompat(remoteInput), intent, map);
        }

        @DoNotInline
        static RemoteInput.Builder setAllowDataType(RemoteInput.Builder builder, String str, boolean z) {
            return builder.setAllowDataType(str, z);
        }
    }

    @RequiresApi(20)
    static class Api20Impl {
        private Api20Impl() {
        }

        @DoNotInline
        static Bundle getResultsFromIntent(Intent intent) {
            return android.app.RemoteInput.getResultsFromIntent(intent);
        }

        @DoNotInline
        static void addResultsToIntent(Object obj, Intent intent, Bundle bundle) {
            android.app.RemoteInput.addResultsToIntent((android.app.RemoteInput[]) obj, intent, bundle);
        }

        static RemoteInput fromPlatform(Object obj) {
            android.app.RemoteInput remoteInput = (android.app.RemoteInput) obj;
            Builder addExtras = new Builder(remoteInput.getResultKey()).setLabel(remoteInput.getLabel()).setChoices(remoteInput.getChoices()).setAllowFreeFormInput(remoteInput.getAllowFreeFormInput()).addExtras(remoteInput.getExtras());
            Set<String> allowedDataTypes = Api26Impl.getAllowedDataTypes(remoteInput);
            if (allowedDataTypes != null) {
                for (String allowDataType : allowedDataTypes) {
                    addExtras.setAllowDataType(allowDataType, true);
                }
            }
            addExtras.setEditChoicesBeforeSending(Api29Impl.getEditChoicesBeforeSending(remoteInput));
            return addExtras.build();
        }

        public static android.app.RemoteInput fromCompat(RemoteInput remoteInput) {
            RemoteInput.Builder addExtras = new RemoteInput.Builder(remoteInput.getResultKey()).setLabel(remoteInput.getLabel()).setChoices(remoteInput.getChoices()).setAllowFreeFormInput(remoteInput.getAllowFreeFormInput()).addExtras(remoteInput.getExtras());
            Set<String> allowedDataTypes = remoteInput.getAllowedDataTypes();
            if (allowedDataTypes != null) {
                for (String allowDataType : allowedDataTypes) {
                    Api26Impl.setAllowDataType(addExtras, allowDataType, true);
                }
            }
            Api29Impl.setEditChoicesBeforeSending(addExtras, remoteInput.getEditChoicesBeforeSending());
            return addExtras.build();
        }
    }

    @RequiresApi(16)
    static class Api16Impl {
        private Api16Impl() {
        }

        @DoNotInline
        static ClipData getClipData(Intent intent) {
            return intent.getClipData();
        }

        @DoNotInline
        static void setClipData(Intent intent, ClipData clipData) {
            intent.setClipData(clipData);
        }
    }

    @RequiresApi(29)
    static class Api29Impl {
        private Api29Impl() {
        }

        @DoNotInline
        static int getEditChoicesBeforeSending(Object obj) {
            return ((android.app.RemoteInput) obj).getEditChoicesBeforeSending();
        }

        @DoNotInline
        static RemoteInput.Builder setEditChoicesBeforeSending(RemoteInput.Builder builder, int i) {
            return builder.setEditChoicesBeforeSending(i);
        }
    }

    @RequiresApi(28)
    static class Api28Impl {
        private Api28Impl() {
        }

        @DoNotInline
        static void setResultsSource(Intent intent, int i) {
            android.app.RemoteInput.setResultsSource(intent, i);
        }

        @DoNotInline
        static int getResultsSource(Intent intent) {
            return android.app.RemoteInput.getResultsSource(intent);
        }
    }
}
