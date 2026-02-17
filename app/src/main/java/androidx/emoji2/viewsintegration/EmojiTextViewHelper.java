package androidx.emoji2.viewsintegration;

import android.text.InputFilter;
import android.text.method.PasswordTransformationMethod;
import android.text.method.TransformationMethod;
import android.util.SparseArray;
import android.widget.TextView;
import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.annotation.RequiresApi;
import androidx.annotation.RestrictTo;
import androidx.core.util.Preconditions;
import androidx.emoji2.text.EmojiCompat;

public final class EmojiTextViewHelper {
    private final HelperInternal mHelper;

    public EmojiTextViewHelper(@NonNull TextView textView) {
        this(textView, true);
    }

    public EmojiTextViewHelper(@NonNull TextView textView, boolean z) {
        Preconditions.checkNotNull(textView, "textView cannot be null");
        if (!z) {
            this.mHelper = new SkippingHelper19(textView);
        } else {
            this.mHelper = new HelperInternal19(textView);
        }
    }

    public void updateTransformationMethod() {
        this.mHelper.updateTransformationMethod();
    }

    @NonNull
    public InputFilter[] getFilters(@NonNull InputFilter[] inputFilterArr) {
        return this.mHelper.getFilters(inputFilterArr);
    }

    @Nullable
    public TransformationMethod wrapTransformationMethod(@Nullable TransformationMethod transformationMethod) {
        return this.mHelper.wrapTransformationMethod(transformationMethod);
    }

    public void setEnabled(boolean z) {
        this.mHelper.setEnabled(z);
    }

    public void setAllCaps(boolean z) {
        this.mHelper.setAllCaps(z);
    }

    public boolean isEnabled() {
        return this.mHelper.isEnabled();
    }

    static class HelperInternal {
        /* access modifiers changed from: package-private */
        @NonNull
        public InputFilter[] getFilters(@NonNull InputFilter[] inputFilterArr) {
            return inputFilterArr;
        }

        public boolean isEnabled() {
            return false;
        }

        /* access modifiers changed from: package-private */
        public void setAllCaps(boolean z) {
        }

        /* access modifiers changed from: package-private */
        public void setEnabled(boolean z) {
        }

        /* access modifiers changed from: package-private */
        public void updateTransformationMethod() {
        }

        /* access modifiers changed from: package-private */
        @Nullable
        public TransformationMethod wrapTransformationMethod(@Nullable TransformationMethod transformationMethod) {
            return transformationMethod;
        }

        HelperInternal() {
        }
    }

    @RequiresApi(19)
    private static class SkippingHelper19 extends HelperInternal {
        private final HelperInternal19 mHelperDelegate;

        SkippingHelper19(TextView textView) {
            this.mHelperDelegate = new HelperInternal19(textView);
        }

        private boolean skipBecauseEmojiCompatNotInitialized() {
            return !EmojiCompat.isConfigured();
        }

        /* access modifiers changed from: package-private */
        public void updateTransformationMethod() {
            if (!skipBecauseEmojiCompatNotInitialized()) {
                this.mHelperDelegate.updateTransformationMethod();
            }
        }

        /* access modifiers changed from: package-private */
        @NonNull
        public InputFilter[] getFilters(@NonNull InputFilter[] inputFilterArr) {
            if (skipBecauseEmojiCompatNotInitialized()) {
                return inputFilterArr;
            }
            return this.mHelperDelegate.getFilters(inputFilterArr);
        }

        /* access modifiers changed from: package-private */
        @Nullable
        public TransformationMethod wrapTransformationMethod(@Nullable TransformationMethod transformationMethod) {
            if (skipBecauseEmojiCompatNotInitialized()) {
                return transformationMethod;
            }
            return this.mHelperDelegate.wrapTransformationMethod(transformationMethod);
        }

        /* access modifiers changed from: package-private */
        public void setAllCaps(boolean z) {
            if (!skipBecauseEmojiCompatNotInitialized()) {
                this.mHelperDelegate.setAllCaps(z);
            }
        }

        /* access modifiers changed from: package-private */
        public void setEnabled(boolean z) {
            if (skipBecauseEmojiCompatNotInitialized()) {
                this.mHelperDelegate.setEnabledUnsafe(z);
            } else {
                this.mHelperDelegate.setEnabled(z);
            }
        }

        public boolean isEnabled() {
            return this.mHelperDelegate.isEnabled();
        }
    }

    @RequiresApi(19)
    private static class HelperInternal19 extends HelperInternal {
        private final EmojiInputFilter mEmojiInputFilter;
        private boolean mEnabled = true;
        private final TextView mTextView;

        HelperInternal19(TextView textView) {
            this.mTextView = textView;
            this.mEmojiInputFilter = new EmojiInputFilter(textView);
        }

        /* access modifiers changed from: package-private */
        public void updateTransformationMethod() {
            this.mTextView.setTransformationMethod(wrapTransformationMethod(this.mTextView.getTransformationMethod()));
        }

        private void updateFilters() {
            this.mTextView.setFilters(getFilters(this.mTextView.getFilters()));
        }

        /* access modifiers changed from: package-private */
        @NonNull
        public InputFilter[] getFilters(@NonNull InputFilter[] inputFilterArr) {
            if (!this.mEnabled) {
                return removeEmojiInputFilterIfPresent(inputFilterArr);
            }
            return addEmojiInputFilterIfMissing(inputFilterArr);
        }

        @NonNull
        private InputFilter[] addEmojiInputFilterIfMissing(@NonNull InputFilter[] inputFilterArr) {
            for (EmojiInputFilter emojiInputFilter : inputFilterArr) {
                if (emojiInputFilter == this.mEmojiInputFilter) {
                    return inputFilterArr;
                }
            }
            InputFilter[] inputFilterArr2 = new InputFilter[(inputFilterArr.length + 1)];
            System.arraycopy(inputFilterArr, 0, inputFilterArr2, 0, r0);
            inputFilterArr2[r0] = this.mEmojiInputFilter;
            return inputFilterArr2;
        }

        @NonNull
        private InputFilter[] removeEmojiInputFilterIfPresent(@NonNull InputFilter[] inputFilterArr) {
            SparseArray<InputFilter> emojiInputFilterPositionArray = getEmojiInputFilterPositionArray(inputFilterArr);
            if (emojiInputFilterPositionArray.size() == 0) {
                return inputFilterArr;
            }
            int length = inputFilterArr.length;
            InputFilter[] inputFilterArr2 = new InputFilter[(inputFilterArr.length - emojiInputFilterPositionArray.size())];
            int i = 0;
            for (int i2 = 0; i2 < length; i2++) {
                if (emojiInputFilterPositionArray.indexOfKey(i2) < 0) {
                    inputFilterArr2[i] = inputFilterArr[i2];
                    i++;
                }
            }
            return inputFilterArr2;
        }

        private SparseArray<InputFilter> getEmojiInputFilterPositionArray(@NonNull InputFilter[] inputFilterArr) {
            SparseArray<InputFilter> sparseArray = new SparseArray<>(1);
            for (int i = 0; i < inputFilterArr.length; i++) {
                InputFilter inputFilter = inputFilterArr[i];
                if (inputFilter instanceof EmojiInputFilter) {
                    sparseArray.put(i, inputFilter);
                }
            }
            return sparseArray;
        }

        /* access modifiers changed from: package-private */
        @Nullable
        public TransformationMethod wrapTransformationMethod(@Nullable TransformationMethod transformationMethod) {
            if (this.mEnabled) {
                return wrapForEnabled(transformationMethod);
            }
            return unwrapForDisabled(transformationMethod);
        }

        @Nullable
        private TransformationMethod unwrapForDisabled(@Nullable TransformationMethod transformationMethod) {
            return transformationMethod instanceof EmojiTransformationMethod ? ((EmojiTransformationMethod) transformationMethod).getOriginalTransformationMethod() : transformationMethod;
        }

        @NonNull
        private TransformationMethod wrapForEnabled(@Nullable TransformationMethod transformationMethod) {
            if (!(transformationMethod instanceof EmojiTransformationMethod) && !(transformationMethod instanceof PasswordTransformationMethod)) {
                return new EmojiTransformationMethod(transformationMethod);
            }
            return transformationMethod;
        }

        /* access modifiers changed from: package-private */
        public void setAllCaps(boolean z) {
            if (z) {
                updateTransformationMethod();
            }
        }

        /* access modifiers changed from: package-private */
        public void setEnabled(boolean z) {
            this.mEnabled = z;
            updateTransformationMethod();
            updateFilters();
        }

        public boolean isEnabled() {
            return this.mEnabled;
        }

        /* access modifiers changed from: package-private */
        @RestrictTo({RestrictTo.Scope.LIBRARY})
        public void setEnabledUnsafe(boolean z) {
            this.mEnabled = z;
        }
    }
}
