package androidx.emoji2.viewsintegration;

import android.text.method.KeyListener;
import android.view.inputmethod.EditorInfo;
import android.view.inputmethod.InputConnection;
import android.widget.EditText;
import androidx.annotation.IntRange;
import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.annotation.RequiresApi;
import androidx.annotation.RestrictTo;
import androidx.core.util.Preconditions;

public final class EmojiEditTextHelper {
    private int mEmojiReplaceStrategy;
    private final HelperInternal mHelper;
    private int mMaxEmojiCount;

    public EmojiEditTextHelper(@NonNull EditText editText) {
        this(editText, true);
    }

    public EmojiEditTextHelper(@NonNull EditText editText, boolean z) {
        this.mMaxEmojiCount = Integer.MAX_VALUE;
        this.mEmojiReplaceStrategy = 0;
        Preconditions.checkNotNull(editText, "editText cannot be null");
        this.mHelper = new HelperInternal19(editText, z);
    }

    public void setMaxEmojiCount(@IntRange(from = 0) int i) {
        Preconditions.checkArgumentNonnegative(i, "maxEmojiCount should be greater than 0");
        this.mMaxEmojiCount = i;
        this.mHelper.setMaxEmojiCount(i);
    }

    public int getMaxEmojiCount() {
        return this.mMaxEmojiCount;
    }

    @Nullable
    public KeyListener getKeyListener(@Nullable KeyListener keyListener) {
        return this.mHelper.getKeyListener(keyListener);
    }

    @Nullable
    public InputConnection onCreateInputConnection(@Nullable InputConnection inputConnection, @NonNull EditorInfo editorInfo) {
        if (inputConnection == null) {
            return null;
        }
        return this.mHelper.onCreateInputConnection(inputConnection, editorInfo);
    }

    @RestrictTo({RestrictTo.Scope.LIBRARY_GROUP})
    public void setEmojiReplaceStrategy(int i) {
        this.mEmojiReplaceStrategy = i;
        this.mHelper.setEmojiReplaceStrategy(i);
    }

    @RestrictTo({RestrictTo.Scope.LIBRARY_GROUP})
    public int getEmojiReplaceStrategy() {
        return this.mEmojiReplaceStrategy;
    }

    public boolean isEnabled() {
        return this.mHelper.isEnabled();
    }

    public void setEnabled(boolean z) {
        this.mHelper.setEnabled(z);
    }

    static class HelperInternal {
        /* access modifiers changed from: package-private */
        @Nullable
        public KeyListener getKeyListener(@Nullable KeyListener keyListener) {
            return keyListener;
        }

        /* access modifiers changed from: package-private */
        public boolean isEnabled() {
            return false;
        }

        /* access modifiers changed from: package-private */
        public InputConnection onCreateInputConnection(@NonNull InputConnection inputConnection, @NonNull EditorInfo editorInfo) {
            return inputConnection;
        }

        /* access modifiers changed from: package-private */
        public void setEmojiReplaceStrategy(int i) {
        }

        /* access modifiers changed from: package-private */
        public void setEnabled(boolean z) {
        }

        /* access modifiers changed from: package-private */
        public void setMaxEmojiCount(int i) {
        }

        HelperInternal() {
        }
    }

    @RequiresApi(19)
    private static class HelperInternal19 extends HelperInternal {
        private final EditText mEditText;
        private final EmojiTextWatcher mTextWatcher;

        HelperInternal19(@NonNull EditText editText, boolean z) {
            this.mEditText = editText;
            EmojiTextWatcher emojiTextWatcher = new EmojiTextWatcher(editText, z);
            this.mTextWatcher = emojiTextWatcher;
            editText.addTextChangedListener(emojiTextWatcher);
            editText.setEditableFactory(EmojiEditableFactory.getInstance());
        }

        /* access modifiers changed from: package-private */
        public void setMaxEmojiCount(int i) {
            this.mTextWatcher.setMaxEmojiCount(i);
        }

        /* access modifiers changed from: package-private */
        public void setEmojiReplaceStrategy(int i) {
            this.mTextWatcher.setEmojiReplaceStrategy(i);
        }

        /* access modifiers changed from: package-private */
        public KeyListener getKeyListener(@Nullable KeyListener keyListener) {
            if (keyListener instanceof EmojiKeyListener) {
                return keyListener;
            }
            if (keyListener == null) {
                return null;
            }
            return new EmojiKeyListener(keyListener);
        }

        /* access modifiers changed from: package-private */
        public InputConnection onCreateInputConnection(@NonNull InputConnection inputConnection, @NonNull EditorInfo editorInfo) {
            if (inputConnection instanceof EmojiInputConnection) {
                return inputConnection;
            }
            return new EmojiInputConnection(this.mEditText, inputConnection, editorInfo);
        }

        /* access modifiers changed from: package-private */
        public void setEnabled(boolean z) {
            this.mTextWatcher.setEnabled(z);
        }

        /* access modifiers changed from: package-private */
        public boolean isEnabled() {
            return this.mTextWatcher.isEnabled();
        }
    }
}
