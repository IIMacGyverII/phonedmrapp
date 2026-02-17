package androidx.emoji2.text;

import android.text.Editable;
import android.text.Selection;
import android.text.Spannable;
import android.text.TextPaint;
import android.text.method.MetaKeyKeyListener;
import android.view.KeyEvent;
import android.view.inputmethod.InputConnection;
import androidx.annotation.AnyThread;
import androidx.annotation.IntRange;
import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.annotation.RequiresApi;
import androidx.annotation.RestrictTo;
import androidx.core.graphics.PaintCompat;
import androidx.emoji2.text.EmojiCompat;
import androidx.emoji2.text.MetadataRepo;
import java.util.Arrays;

@RequiresApi(19)
@AnyThread
@RestrictTo({RestrictTo.Scope.LIBRARY})
final class EmojiProcessor {
    private static final int ACTION_ADVANCE_BOTH = 1;
    private static final int ACTION_ADVANCE_END = 2;
    private static final int ACTION_FLUSH = 3;
    @Nullable
    private final int[] mEmojiAsDefaultStyleExceptions;
    @NonNull
    private EmojiCompat.GlyphChecker mGlyphChecker;
    @NonNull
    private final MetadataRepo mMetadataRepo;
    @NonNull
    private final EmojiCompat.SpanFactory mSpanFactory;
    private final boolean mUseEmojiAsDefaultStyle;

    private static boolean hasInvalidSelection(int i, int i2) {
        return i == -1 || i2 == -1 || i != i2;
    }

    EmojiProcessor(@NonNull MetadataRepo metadataRepo, @NonNull EmojiCompat.SpanFactory spanFactory, @NonNull EmojiCompat.GlyphChecker glyphChecker, boolean z, @Nullable int[] iArr) {
        this.mSpanFactory = spanFactory;
        this.mMetadataRepo = metadataRepo;
        this.mGlyphChecker = glyphChecker;
        this.mUseEmojiAsDefaultStyle = z;
        this.mEmojiAsDefaultStyleExceptions = iArr;
    }

    /* access modifiers changed from: package-private */
    public EmojiMetadata getEmojiMetadata(@NonNull CharSequence charSequence) {
        ProcessorSm processorSm = new ProcessorSm(this.mMetadataRepo.getRootNode(), this.mUseEmojiAsDefaultStyle, this.mEmojiAsDefaultStyleExceptions);
        int length = charSequence.length();
        int i = 0;
        while (i < length) {
            int codePointAt = Character.codePointAt(charSequence, i);
            if (processorSm.check(codePointAt) != 2) {
                return null;
            }
            i += Character.charCount(codePointAt);
        }
        if (processorSm.isInFlushableState()) {
            return processorSm.getCurrentMetadata();
        }
        return null;
    }

    /* JADX DEBUG: Multi-variable search result rejected for TypeSearchVarInfo{r2v1, resolved type: android.text.Spannable} */
    /* JADX DEBUG: Multi-variable search result rejected for TypeSearchVarInfo{r2v2, resolved type: android.text.Spannable} */
    /* JADX DEBUG: Multi-variable search result rejected for TypeSearchVarInfo{r2v3, resolved type: android.text.Spannable} */
    /* JADX DEBUG: Multi-variable search result rejected for TypeSearchVarInfo{r2v5, resolved type: java.lang.CharSequence} */
    /* JADX DEBUG: Multi-variable search result rejected for TypeSearchVarInfo{r2v6, resolved type: android.text.Spannable} */
    /* JADX DEBUG: Multi-variable search result rejected for TypeSearchVarInfo{r2v7, resolved type: android.text.Spannable} */
    /* JADX DEBUG: Multi-variable search result rejected for TypeSearchVarInfo{r2v8, resolved type: android.text.Spannable} */
    /* JADX DEBUG: Multi-variable search result rejected for TypeSearchVarInfo{r2v9, resolved type: android.text.Spannable} */
    /* JADX DEBUG: Multi-variable search result rejected for TypeSearchVarInfo{r2v10, resolved type: android.text.Spannable} */
    /* JADX WARNING: type inference failed for: r2v4, types: [java.lang.CharSequence] */
    /* access modifiers changed from: package-private */
    /* JADX WARNING: Multi-variable type inference failed */
    /* JADX WARNING: Removed duplicated region for block: B:23:0x0042 A[Catch:{ all -> 0x0116 }] */
    /* JADX WARNING: Removed duplicated region for block: B:28:0x005e A[Catch:{ all -> 0x0116 }] */
    /* JADX WARNING: Removed duplicated region for block: B:74:0x010f  */
    /* Code decompiled incorrectly, please refer to instructions dump. */
    public java.lang.CharSequence process(@androidx.annotation.NonNull java.lang.CharSequence r10, @androidx.annotation.IntRange(from = 0) int r11, @androidx.annotation.IntRange(from = 0) int r12, @androidx.annotation.IntRange(from = 0) int r13, boolean r14) {
        /*
            r9 = this;
            boolean r0 = r10 instanceof androidx.emoji2.text.SpannableBuilder
            if (r0 == 0) goto L_0x000a
            r1 = r10
            androidx.emoji2.text.SpannableBuilder r1 = (androidx.emoji2.text.SpannableBuilder) r1
            r1.beginBatchEdit()
        L_0x000a:
            r1 = 0
            if (r0 != 0) goto L_0x002b
            boolean r2 = r10 instanceof android.text.Spannable     // Catch:{ all -> 0x0116 }
            if (r2 == 0) goto L_0x0012
            goto L_0x002b
        L_0x0012:
            boolean r2 = r10 instanceof android.text.Spanned     // Catch:{ all -> 0x0116 }
            if (r2 == 0) goto L_0x002e
            r2 = r10
            android.text.Spanned r2 = (android.text.Spanned) r2     // Catch:{ all -> 0x0116 }
            int r3 = r11 + -1
            int r4 = r12 + 1
            java.lang.Class<androidx.emoji2.text.EmojiSpan> r5 = androidx.emoji2.text.EmojiSpan.class
            int r2 = r2.nextSpanTransition(r3, r4, r5)     // Catch:{ all -> 0x0116 }
            if (r2 > r12) goto L_0x002e
            android.text.SpannableString r1 = new android.text.SpannableString     // Catch:{ all -> 0x0116 }
            r1.<init>(r10)     // Catch:{ all -> 0x0116 }
            goto L_0x002e
        L_0x002b:
            r1 = r10
            android.text.Spannable r1 = (android.text.Spannable) r1     // Catch:{ all -> 0x0116 }
        L_0x002e:
            r2 = 0
            if (r1 == 0) goto L_0x005c
            java.lang.Class<androidx.emoji2.text.EmojiSpan> r3 = androidx.emoji2.text.EmojiSpan.class
            java.lang.Object[] r3 = r1.getSpans(r11, r12, r3)     // Catch:{ all -> 0x0116 }
            androidx.emoji2.text.EmojiSpan[] r3 = (androidx.emoji2.text.EmojiSpan[]) r3     // Catch:{ all -> 0x0116 }
            if (r3 == 0) goto L_0x005c
            int r4 = r3.length     // Catch:{ all -> 0x0116 }
            if (r4 <= 0) goto L_0x005c
            int r4 = r3.length     // Catch:{ all -> 0x0116 }
            r5 = r2
        L_0x0040:
            if (r5 >= r4) goto L_0x005c
            r6 = r3[r5]     // Catch:{ all -> 0x0116 }
            int r7 = r1.getSpanStart(r6)     // Catch:{ all -> 0x0116 }
            int r8 = r1.getSpanEnd(r6)     // Catch:{ all -> 0x0116 }
            if (r7 == r12) goto L_0x0051
            r1.removeSpan(r6)     // Catch:{ all -> 0x0116 }
        L_0x0051:
            int r11 = java.lang.Math.min(r7, r11)     // Catch:{ all -> 0x0116 }
            int r12 = java.lang.Math.max(r8, r12)     // Catch:{ all -> 0x0116 }
            int r5 = r5 + 1
            goto L_0x0040
        L_0x005c:
            if (r11 == r12) goto L_0x010d
            int r3 = r10.length()     // Catch:{ all -> 0x0116 }
            if (r11 < r3) goto L_0x0066
            goto L_0x010d
        L_0x0066:
            r3 = 2147483647(0x7fffffff, float:NaN)
            if (r13 == r3) goto L_0x007b
            if (r1 == 0) goto L_0x007b
            int r3 = r1.length()     // Catch:{ all -> 0x0116 }
            java.lang.Class<androidx.emoji2.text.EmojiSpan> r4 = androidx.emoji2.text.EmojiSpan.class
            java.lang.Object[] r3 = r1.getSpans(r2, r3, r4)     // Catch:{ all -> 0x0116 }
            androidx.emoji2.text.EmojiSpan[] r3 = (androidx.emoji2.text.EmojiSpan[]) r3     // Catch:{ all -> 0x0116 }
            int r3 = r3.length     // Catch:{ all -> 0x0116 }
            int r13 = r13 - r3
        L_0x007b:
            androidx.emoji2.text.EmojiProcessor$ProcessorSm r3 = new androidx.emoji2.text.EmojiProcessor$ProcessorSm     // Catch:{ all -> 0x0116 }
            androidx.emoji2.text.MetadataRepo r4 = r9.mMetadataRepo     // Catch:{ all -> 0x0116 }
            androidx.emoji2.text.MetadataRepo$Node r4 = r4.getRootNode()     // Catch:{ all -> 0x0116 }
            boolean r5 = r9.mUseEmojiAsDefaultStyle     // Catch:{ all -> 0x0116 }
            int[] r6 = r9.mEmojiAsDefaultStyleExceptions     // Catch:{ all -> 0x0116 }
            r3.<init>(r4, r5, r6)     // Catch:{ all -> 0x0116 }
            int r4 = java.lang.Character.codePointAt(r10, r11)     // Catch:{ all -> 0x0116 }
            r5 = r4
            r4 = r2
            r2 = r1
        L_0x0091:
            r1 = r11
        L_0x0092:
            if (r11 >= r12) goto L_0x00df
            if (r4 >= r13) goto L_0x00df
            int r6 = r3.check(r5)     // Catch:{ all -> 0x0116 }
            r7 = 1
            if (r6 == r7) goto L_0x00cd
            r7 = 2
            if (r6 == r7) goto L_0x00c1
            r7 = 3
            if (r6 == r7) goto L_0x00a4
            goto L_0x0092
        L_0x00a4:
            if (r14 != 0) goto L_0x00b0
            androidx.emoji2.text.EmojiMetadata r6 = r3.getFlushMetadata()     // Catch:{ all -> 0x0116 }
            boolean r6 = r9.hasGlyph(r10, r1, r11, r6)     // Catch:{ all -> 0x0116 }
            if (r6 != 0) goto L_0x0091
        L_0x00b0:
            if (r2 != 0) goto L_0x00b7
            android.text.SpannableString r2 = new android.text.SpannableString     // Catch:{ all -> 0x0116 }
            r2.<init>(r10)     // Catch:{ all -> 0x0116 }
        L_0x00b7:
            androidx.emoji2.text.EmojiMetadata r6 = r3.getFlushMetadata()     // Catch:{ all -> 0x0116 }
            r9.addEmoji(r2, r6, r1, r11)     // Catch:{ all -> 0x0116 }
            int r4 = r4 + 1
            goto L_0x0091
        L_0x00c1:
            int r6 = java.lang.Character.charCount(r5)     // Catch:{ all -> 0x0116 }
            int r11 = r11 + r6
            if (r11 >= r12) goto L_0x0092
            int r5 = java.lang.Character.codePointAt(r10, r11)     // Catch:{ all -> 0x0116 }
            goto L_0x0092
        L_0x00cd:
            int r11 = java.lang.Character.codePointAt(r10, r1)     // Catch:{ all -> 0x0116 }
            int r11 = java.lang.Character.charCount(r11)     // Catch:{ all -> 0x0116 }
            int r1 = r1 + r11
            if (r1 >= r12) goto L_0x00dd
            int r11 = java.lang.Character.codePointAt(r10, r1)     // Catch:{ all -> 0x0116 }
            r5 = r11
        L_0x00dd:
            r11 = r1
            goto L_0x0092
        L_0x00df:
            boolean r12 = r3.isInFlushableState()     // Catch:{ all -> 0x0116 }
            if (r12 == 0) goto L_0x0102
            if (r4 >= r13) goto L_0x0102
            if (r14 != 0) goto L_0x00f3
            androidx.emoji2.text.EmojiMetadata r12 = r3.getCurrentMetadata()     // Catch:{ all -> 0x0116 }
            boolean r12 = r9.hasGlyph(r10, r1, r11, r12)     // Catch:{ all -> 0x0116 }
            if (r12 != 0) goto L_0x0102
        L_0x00f3:
            if (r2 != 0) goto L_0x00fb
            android.text.SpannableString r12 = new android.text.SpannableString     // Catch:{ all -> 0x0116 }
            r12.<init>(r10)     // Catch:{ all -> 0x0116 }
            r2 = r12
        L_0x00fb:
            androidx.emoji2.text.EmojiMetadata r12 = r3.getCurrentMetadata()     // Catch:{ all -> 0x0116 }
            r9.addEmoji(r2, r12, r1, r11)     // Catch:{ all -> 0x0116 }
        L_0x0102:
            if (r2 != 0) goto L_0x0105
            r2 = r10
        L_0x0105:
            if (r0 == 0) goto L_0x010c
            androidx.emoji2.text.SpannableBuilder r10 = (androidx.emoji2.text.SpannableBuilder) r10
            r10.endBatchEdit()
        L_0x010c:
            return r2
        L_0x010d:
            if (r0 == 0) goto L_0x0115
            r9 = r10
            androidx.emoji2.text.SpannableBuilder r9 = (androidx.emoji2.text.SpannableBuilder) r9
            r9.endBatchEdit()
        L_0x0115:
            return r10
        L_0x0116:
            r9 = move-exception
            if (r0 == 0) goto L_0x011e
            androidx.emoji2.text.SpannableBuilder r10 = (androidx.emoji2.text.SpannableBuilder) r10
            r10.endBatchEdit()
        L_0x011e:
            throw r9
        */
        throw new UnsupportedOperationException("Method not decompiled: androidx.emoji2.text.EmojiProcessor.process(java.lang.CharSequence, int, int, int, boolean):java.lang.CharSequence");
    }

    static boolean handleOnKeyDown(@NonNull Editable editable, int i, @NonNull KeyEvent keyEvent) {
        boolean z;
        if (i != 67) {
            z = i != 112 ? false : delete(editable, keyEvent, true);
        } else {
            z = delete(editable, keyEvent, false);
        }
        if (!z) {
            return false;
        }
        MetaKeyKeyListener.adjustMetaAfterKeypress(editable);
        return true;
    }

    private static boolean delete(@NonNull Editable editable, @NonNull KeyEvent keyEvent, boolean z) {
        EmojiSpan[] emojiSpanArr;
        if (hasModifiers(keyEvent)) {
            return false;
        }
        int selectionStart = Selection.getSelectionStart(editable);
        int selectionEnd = Selection.getSelectionEnd(editable);
        if (!hasInvalidSelection(selectionStart, selectionEnd) && (emojiSpanArr = (EmojiSpan[]) editable.getSpans(selectionStart, selectionEnd, EmojiSpan.class)) != null && emojiSpanArr.length > 0) {
            int length = emojiSpanArr.length;
            int i = 0;
            while (i < length) {
                EmojiSpan emojiSpan = emojiSpanArr[i];
                int spanStart = editable.getSpanStart(emojiSpan);
                int spanEnd = editable.getSpanEnd(emojiSpan);
                if ((!z || spanStart != selectionStart) && ((z || spanEnd != selectionStart) && (selectionStart <= spanStart || selectionStart >= spanEnd))) {
                    i++;
                } else {
                    editable.delete(spanStart, spanEnd);
                    return true;
                }
            }
        }
        return false;
    }

    static boolean handleDeleteSurroundingText(@NonNull InputConnection inputConnection, @NonNull Editable editable, @IntRange(from = 0) int i, @IntRange(from = 0) int i2, boolean z) {
        int i3;
        int i4;
        if (editable != null && inputConnection != null && i >= 0 && i2 >= 0) {
            int selectionStart = Selection.getSelectionStart(editable);
            int selectionEnd = Selection.getSelectionEnd(editable);
            if (hasInvalidSelection(selectionStart, selectionEnd)) {
                return false;
            }
            if (z) {
                i4 = CodepointIndexFinder.findIndexBackward(editable, selectionStart, Math.max(i, 0));
                i3 = CodepointIndexFinder.findIndexForward(editable, selectionEnd, Math.max(i2, 0));
                if (i4 == -1 || i3 == -1) {
                    return false;
                }
            } else {
                i4 = Math.max(selectionStart - i, 0);
                i3 = Math.min(selectionEnd + i2, editable.length());
            }
            EmojiSpan[] emojiSpanArr = (EmojiSpan[]) editable.getSpans(i4, i3, EmojiSpan.class);
            if (emojiSpanArr != null && emojiSpanArr.length > 0) {
                for (EmojiSpan emojiSpan : emojiSpanArr) {
                    int spanStart = editable.getSpanStart(emojiSpan);
                    int spanEnd = editable.getSpanEnd(emojiSpan);
                    i4 = Math.min(spanStart, i4);
                    i3 = Math.max(spanEnd, i3);
                }
                int max = Math.max(i4, 0);
                int min = Math.min(i3, editable.length());
                inputConnection.beginBatchEdit();
                editable.delete(max, min);
                inputConnection.endBatchEdit();
                return true;
            }
        }
        return false;
    }

    private static boolean hasModifiers(@NonNull KeyEvent keyEvent) {
        return !KeyEvent.metaStateHasNoModifiers(keyEvent.getMetaState());
    }

    private void addEmoji(@NonNull Spannable spannable, EmojiMetadata emojiMetadata, int i, int i2) {
        spannable.setSpan(this.mSpanFactory.createSpan(emojiMetadata), i, i2, 33);
    }

    private boolean hasGlyph(CharSequence charSequence, int i, int i2, EmojiMetadata emojiMetadata) {
        if (emojiMetadata.getHasGlyph() == 0) {
            emojiMetadata.setHasGlyph(this.mGlyphChecker.hasGlyph(charSequence, i, i2, emojiMetadata.getSdkAdded()));
        }
        return emojiMetadata.getHasGlyph() == 2;
    }

    static final class ProcessorSm {
        private static final int STATE_DEFAULT = 1;
        private static final int STATE_WALKING = 2;
        private int mCurrentDepth;
        private MetadataRepo.Node mCurrentNode;
        private final int[] mEmojiAsDefaultStyleExceptions;
        private MetadataRepo.Node mFlushNode;
        private int mLastCodepoint;
        private final MetadataRepo.Node mRootNode;
        private int mState = 1;
        private final boolean mUseEmojiAsDefaultStyle;

        private static boolean isEmojiStyle(int i) {
            return i == 65039;
        }

        private static boolean isTextStyle(int i) {
            return i == 65038;
        }

        ProcessorSm(MetadataRepo.Node node, boolean z, int[] iArr) {
            this.mRootNode = node;
            this.mCurrentNode = node;
            this.mUseEmojiAsDefaultStyle = z;
            this.mEmojiAsDefaultStyleExceptions = iArr;
        }

        /* access modifiers changed from: package-private */
        public int check(int i) {
            MetadataRepo.Node node = this.mCurrentNode.get(i);
            int i2 = 3;
            if (this.mState != 2) {
                if (node == null) {
                    i2 = reset();
                    this.mLastCodepoint = i;
                    return i2;
                }
                this.mState = 2;
                this.mCurrentNode = node;
                this.mCurrentDepth = 1;
            } else if (node != null) {
                this.mCurrentNode = node;
                this.mCurrentDepth++;
            } else {
                if (isTextStyle(i)) {
                    i2 = reset();
                } else if (!isEmojiStyle(i)) {
                    if (this.mCurrentNode.getData() == null) {
                        i2 = reset();
                    } else if (this.mCurrentDepth != 1) {
                        this.mFlushNode = this.mCurrentNode;
                        reset();
                    } else if (shouldUseEmojiPresentationStyleForSingleCodepoint()) {
                        this.mFlushNode = this.mCurrentNode;
                        reset();
                    } else {
                        i2 = reset();
                    }
                }
                this.mLastCodepoint = i;
                return i2;
            }
            i2 = 2;
            this.mLastCodepoint = i;
            return i2;
        }

        private int reset() {
            this.mState = 1;
            this.mCurrentNode = this.mRootNode;
            this.mCurrentDepth = 0;
            return 1;
        }

        /* access modifiers changed from: package-private */
        public EmojiMetadata getFlushMetadata() {
            return this.mFlushNode.getData();
        }

        /* access modifiers changed from: package-private */
        public EmojiMetadata getCurrentMetadata() {
            return this.mCurrentNode.getData();
        }

        /* access modifiers changed from: package-private */
        public boolean isInFlushableState() {
            if (this.mState != 2 || this.mCurrentNode.getData() == null || (this.mCurrentDepth <= 1 && !shouldUseEmojiPresentationStyleForSingleCodepoint())) {
                return false;
            }
            return true;
        }

        private boolean shouldUseEmojiPresentationStyleForSingleCodepoint() {
            if (this.mCurrentNode.getData().isDefaultEmoji() || isEmojiStyle(this.mLastCodepoint)) {
                return true;
            }
            if (this.mUseEmojiAsDefaultStyle) {
                if (this.mEmojiAsDefaultStyleExceptions == null) {
                    return true;
                }
                if (Arrays.binarySearch(this.mEmojiAsDefaultStyleExceptions, this.mCurrentNode.getData().getCodepointAt(0)) < 0) {
                    return true;
                }
            }
            return false;
        }
    }

    @RequiresApi(19)
    private static final class CodepointIndexFinder {
        private static final int INVALID_INDEX = -1;

        private CodepointIndexFinder() {
        }

        static int findIndexBackward(CharSequence charSequence, int i, int i2) {
            int length = charSequence.length();
            if (i < 0 || length < i || i2 < 0) {
                return -1;
            }
            while (true) {
                boolean z = false;
                while (i2 != 0) {
                    i--;
                    if (i < 0) {
                        return z ? -1 : 0;
                    }
                    char charAt = charSequence.charAt(i);
                    if (z) {
                        if (!Character.isHighSurrogate(charAt)) {
                            return -1;
                        }
                        i2--;
                    } else if (!Character.isSurrogate(charAt)) {
                        i2--;
                    } else if (Character.isHighSurrogate(charAt)) {
                        return -1;
                    } else {
                        z = true;
                    }
                }
                return i;
            }
        }

        static int findIndexForward(CharSequence charSequence, int i, int i2) {
            int length = charSequence.length();
            if (i < 0 || length < i || i2 < 0) {
                return -1;
            }
            while (true) {
                boolean z = false;
                while (i2 != 0) {
                    if (r7 < length) {
                        char charAt = charSequence.charAt(r7);
                        if (z) {
                            if (!Character.isLowSurrogate(charAt)) {
                                return -1;
                            }
                            i2--;
                            i = r7 + 1;
                        } else if (!Character.isSurrogate(charAt)) {
                            i2--;
                            r7++;
                        } else if (Character.isLowSurrogate(charAt)) {
                            return -1;
                        } else {
                            r7++;
                            z = true;
                        }
                    } else if (z) {
                        return -1;
                    } else {
                        return length;
                    }
                }
                return r7;
            }
        }
    }

    @AnyThread
    @RestrictTo({RestrictTo.Scope.LIBRARY})
    public static class DefaultGlyphChecker implements EmojiCompat.GlyphChecker {
        private static final int PAINT_TEXT_SIZE = 10;
        private static final ThreadLocal<StringBuilder> sStringBuilder = new ThreadLocal<>();
        private final TextPaint mTextPaint;

        DefaultGlyphChecker() {
            TextPaint textPaint = new TextPaint();
            this.mTextPaint = textPaint;
            textPaint.setTextSize(10.0f);
        }

        public boolean hasGlyph(@NonNull CharSequence charSequence, int i, int i2, int i3) {
            StringBuilder stringBuilder = getStringBuilder();
            stringBuilder.setLength(0);
            while (i < i2) {
                stringBuilder.append(charSequence.charAt(i));
                i++;
            }
            return PaintCompat.hasGlyph(this.mTextPaint, stringBuilder.toString());
        }

        private static StringBuilder getStringBuilder() {
            ThreadLocal<StringBuilder> threadLocal = sStringBuilder;
            if (threadLocal.get() == null) {
                threadLocal.set(new StringBuilder());
            }
            return threadLocal.get();
        }
    }
}
