package androidx.appcompat.widget;

import android.content.Context;
import android.content.res.ColorStateList;
import android.content.res.Resources;
import android.graphics.PorterDuff;
import android.graphics.Typeface;
import android.graphics.drawable.Drawable;
import android.view.inputmethod.EditorInfo;
import android.view.inputmethod.InputConnection;
import android.widget.TextView;
import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.annotation.RestrictTo;
import androidx.appcompat.R;
import androidx.core.content.res.ResourcesCompat;
import androidx.core.view.ViewCompat;
import androidx.core.widget.AutoSizeableTextView;
import java.lang.ref.WeakReference;

class AppCompatTextHelper {
    private static final int MONOSPACE = 3;
    private static final int SANS = 1;
    private static final int SERIF = 2;
    private static final int TEXT_FONT_WEIGHT_UNSPECIFIED = -1;
    private boolean mAsyncFontPending;
    @NonNull
    private final AppCompatTextViewAutoSizeHelper mAutoSizeTextHelper;
    private TintInfo mDrawableBottomTint;
    private TintInfo mDrawableEndTint;
    private TintInfo mDrawableLeftTint;
    private TintInfo mDrawableRightTint;
    private TintInfo mDrawableStartTint;
    private TintInfo mDrawableTint;
    private TintInfo mDrawableTopTint;
    private Typeface mFontTypeface;
    private int mFontWeight = -1;
    private int mStyle = 0;
    @NonNull
    private final TextView mView;

    /* access modifiers changed from: package-private */
    public void populateSurroundingTextIfNeeded(@NonNull TextView textView, @Nullable InputConnection inputConnection, @NonNull EditorInfo editorInfo) {
    }

    AppCompatTextHelper(@NonNull TextView textView) {
        this.mView = textView;
        this.mAutoSizeTextHelper = new AppCompatTextViewAutoSizeHelper(textView);
    }

    /* access modifiers changed from: package-private */
    /* JADX WARNING: Removed duplicated region for block: B:100:0x0203  */
    /* JADX WARNING: Removed duplicated region for block: B:103:0x0211  */
    /* JADX WARNING: Removed duplicated region for block: B:106:0x0222  */
    /* JADX WARNING: Removed duplicated region for block: B:109:0x0246  */
    /* JADX WARNING: Removed duplicated region for block: B:111:0x024d  */
    /* JADX WARNING: Removed duplicated region for block: B:113:0x0254  */
    /* JADX WARNING: Removed duplicated region for block: B:115:? A[RETURN, SYNTHETIC] */
    /* JADX WARNING: Removed duplicated region for block: B:28:0x00ce  */
    /* JADX WARNING: Removed duplicated region for block: B:29:0x00d3  */
    /* JADX WARNING: Removed duplicated region for block: B:32:0x00dc  */
    /* JADX WARNING: Removed duplicated region for block: B:33:0x00e1  */
    /* JADX WARNING: Removed duplicated region for block: B:44:0x0108  */
    /* JADX WARNING: Removed duplicated region for block: B:47:0x0114  */
    /* JADX WARNING: Removed duplicated region for block: B:59:0x013d  */
    /* JADX WARNING: Removed duplicated region for block: B:64:0x0150  */
    /* JADX WARNING: Removed duplicated region for block: B:66:0x0157  */
    /* JADX WARNING: Removed duplicated region for block: B:73:0x017a  */
    /* JADX WARNING: Removed duplicated region for block: B:79:0x01b2  */
    /* JADX WARNING: Removed duplicated region for block: B:80:0x01b8  */
    /* JADX WARNING: Removed duplicated region for block: B:83:0x01c1  */
    /* JADX WARNING: Removed duplicated region for block: B:84:0x01c7  */
    /* JADX WARNING: Removed duplicated region for block: B:87:0x01d0  */
    /* JADX WARNING: Removed duplicated region for block: B:88:0x01d6  */
    /* JADX WARNING: Removed duplicated region for block: B:91:0x01df  */
    /* JADX WARNING: Removed duplicated region for block: B:92:0x01e5  */
    /* JADX WARNING: Removed duplicated region for block: B:95:0x01ee  */
    /* JADX WARNING: Removed duplicated region for block: B:96:0x01f4  */
    /* JADX WARNING: Removed duplicated region for block: B:99:0x01fd  */
    @android.annotation.SuppressLint({"NewApi"})
    /* Code decompiled incorrectly, please refer to instructions dump. */
    public void loadFromAttributes(@androidx.annotation.Nullable android.util.AttributeSet r18, int r19) {
        /*
            r17 = this;
            r7 = r17
            r8 = r18
            r9 = r19
            android.widget.TextView r0 = r7.mView
            android.content.Context r10 = r0.getContext()
            androidx.appcompat.widget.AppCompatDrawableManager r11 = androidx.appcompat.widget.AppCompatDrawableManager.get()
            int[] r2 = androidx.appcompat.R.styleable.AppCompatTextHelper
            r12 = 0
            androidx.appcompat.widget.TintTypedArray r13 = androidx.appcompat.widget.TintTypedArray.obtainStyledAttributes(r10, r8, r2, r9, r12)
            android.widget.TextView r0 = r7.mView
            android.content.Context r1 = r0.getContext()
            android.content.res.TypedArray r4 = r13.getWrappedTypeArray()
            r6 = 0
            r3 = r18
            r5 = r19
            androidx.core.view.ViewCompat.saveAttributeDataForStyleable(r0, r1, r2, r3, r4, r5, r6)
            int r0 = androidx.appcompat.R.styleable.AppCompatTextHelper_android_textAppearance
            r14 = -1
            int r0 = r13.getResourceId(r0, r14)
            int r1 = androidx.appcompat.R.styleable.AppCompatTextHelper_android_drawableLeft
            boolean r2 = r13.hasValue(r1)
            if (r2 == 0) goto L_0x0042
            int r1 = r13.getResourceId(r1, r12)
            androidx.appcompat.widget.TintInfo r1 = createTintInfo(r10, r11, r1)
            r7.mDrawableLeftTint = r1
        L_0x0042:
            int r1 = androidx.appcompat.R.styleable.AppCompatTextHelper_android_drawableTop
            boolean r2 = r13.hasValue(r1)
            if (r2 == 0) goto L_0x0054
            int r1 = r13.getResourceId(r1, r12)
            androidx.appcompat.widget.TintInfo r1 = createTintInfo(r10, r11, r1)
            r7.mDrawableTopTint = r1
        L_0x0054:
            int r1 = androidx.appcompat.R.styleable.AppCompatTextHelper_android_drawableRight
            boolean r2 = r13.hasValue(r1)
            if (r2 == 0) goto L_0x0066
            int r1 = r13.getResourceId(r1, r12)
            androidx.appcompat.widget.TintInfo r1 = createTintInfo(r10, r11, r1)
            r7.mDrawableRightTint = r1
        L_0x0066:
            int r1 = androidx.appcompat.R.styleable.AppCompatTextHelper_android_drawableBottom
            boolean r2 = r13.hasValue(r1)
            if (r2 == 0) goto L_0x0078
            int r1 = r13.getResourceId(r1, r12)
            androidx.appcompat.widget.TintInfo r1 = createTintInfo(r10, r11, r1)
            r7.mDrawableBottomTint = r1
        L_0x0078:
            int r1 = androidx.appcompat.R.styleable.AppCompatTextHelper_android_drawableStart
            boolean r2 = r13.hasValue(r1)
            if (r2 == 0) goto L_0x008a
            int r1 = r13.getResourceId(r1, r12)
            androidx.appcompat.widget.TintInfo r1 = createTintInfo(r10, r11, r1)
            r7.mDrawableStartTint = r1
        L_0x008a:
            int r1 = androidx.appcompat.R.styleable.AppCompatTextHelper_android_drawableEnd
            boolean r2 = r13.hasValue(r1)
            if (r2 == 0) goto L_0x009c
            int r1 = r13.getResourceId(r1, r12)
            androidx.appcompat.widget.TintInfo r1 = createTintInfo(r10, r11, r1)
            r7.mDrawableEndTint = r1
        L_0x009c:
            r13.recycle()
            android.widget.TextView r1 = r7.mView
            android.text.method.TransformationMethod r1 = r1.getTransformationMethod()
            boolean r1 = r1 instanceof android.text.method.PasswordTransformationMethod
            r2 = 1
            r13 = 0
            if (r0 == r14) goto L_0x00e6
            int[] r3 = androidx.appcompat.R.styleable.TextAppearance
            androidx.appcompat.widget.TintTypedArray r0 = androidx.appcompat.widget.TintTypedArray.obtainStyledAttributes((android.content.Context) r10, (int) r0, (int[]) r3)
            if (r1 != 0) goto L_0x00c1
            int r3 = androidx.appcompat.R.styleable.TextAppearance_textAllCaps
            boolean r4 = r0.hasValue(r3)
            if (r4 == 0) goto L_0x00c1
            boolean r3 = r0.getBoolean(r3, r12)
            r4 = r2
            goto L_0x00c3
        L_0x00c1:
            r3 = r12
            r4 = r3
        L_0x00c3:
            r7.updateTypefaceAndStyle(r10, r0)
            int r5 = androidx.appcompat.R.styleable.TextAppearance_textLocale
            boolean r6 = r0.hasValue(r5)
            if (r6 == 0) goto L_0x00d3
            java.lang.String r5 = r0.getString(r5)
            goto L_0x00d4
        L_0x00d3:
            r5 = r13
        L_0x00d4:
            int r6 = androidx.appcompat.R.styleable.TextAppearance_fontVariationSettings
            boolean r15 = r0.hasValue(r6)
            if (r15 == 0) goto L_0x00e1
            java.lang.String r6 = r0.getString(r6)
            goto L_0x00e2
        L_0x00e1:
            r6 = r13
        L_0x00e2:
            r0.recycle()
            goto L_0x00ea
        L_0x00e6:
            r3 = r12
            r4 = r3
            r5 = r13
            r6 = r5
        L_0x00ea:
            int[] r0 = androidx.appcompat.R.styleable.TextAppearance
            androidx.appcompat.widget.TintTypedArray r0 = androidx.appcompat.widget.TintTypedArray.obtainStyledAttributes(r10, r8, r0, r9, r12)
            if (r1 != 0) goto L_0x00ff
            int r15 = androidx.appcompat.R.styleable.TextAppearance_textAllCaps
            boolean r16 = r0.hasValue(r15)
            if (r16 == 0) goto L_0x00ff
            boolean r3 = r0.getBoolean(r15, r12)
            goto L_0x0100
        L_0x00ff:
            r2 = r4
        L_0x0100:
            int r4 = androidx.appcompat.R.styleable.TextAppearance_textLocale
            boolean r15 = r0.hasValue(r4)
            if (r15 == 0) goto L_0x010c
            java.lang.String r5 = r0.getString(r4)
        L_0x010c:
            int r4 = androidx.appcompat.R.styleable.TextAppearance_fontVariationSettings
            boolean r15 = r0.hasValue(r4)
            if (r15 == 0) goto L_0x0118
            java.lang.String r6 = r0.getString(r4)
        L_0x0118:
            int r4 = androidx.appcompat.R.styleable.TextAppearance_android_textSize
            boolean r15 = r0.hasValue(r4)
            if (r15 == 0) goto L_0x012c
            int r4 = r0.getDimensionPixelSize(r4, r14)
            if (r4 != 0) goto L_0x012c
            android.widget.TextView r4 = r7.mView
            r15 = 0
            r4.setTextSize(r12, r15)
        L_0x012c:
            r7.updateTypefaceAndStyle(r10, r0)
            r0.recycle()
            if (r1 != 0) goto L_0x0139
            if (r2 == 0) goto L_0x0139
            r7.setAllCaps(r3)
        L_0x0139:
            android.graphics.Typeface r0 = r7.mFontTypeface
            if (r0 == 0) goto L_0x014e
            int r1 = r7.mFontWeight
            if (r1 != r14) goto L_0x0149
            android.widget.TextView r1 = r7.mView
            int r2 = r7.mStyle
            r1.setTypeface(r0, r2)
            goto L_0x014e
        L_0x0149:
            android.widget.TextView r1 = r7.mView
            r1.setTypeface(r0)
        L_0x014e:
            if (r6 == 0) goto L_0x0155
            android.widget.TextView r0 = r7.mView
            r0.setFontVariationSettings(r6)
        L_0x0155:
            if (r5 == 0) goto L_0x0160
            android.widget.TextView r0 = r7.mView
            android.os.LocaleList r1 = android.os.LocaleList.forLanguageTags(r5)
            r0.setTextLocales(r1)
        L_0x0160:
            androidx.appcompat.widget.AppCompatTextViewAutoSizeHelper r0 = r7.mAutoSizeTextHelper
            r0.loadFromAttributes(r8, r9)
            boolean r0 = androidx.core.widget.AutoSizeableTextView.PLATFORM_SUPPORTS_AUTOSIZE
            if (r0 == 0) goto L_0x01a4
            androidx.appcompat.widget.AppCompatTextViewAutoSizeHelper r0 = r7.mAutoSizeTextHelper
            int r0 = r0.getAutoSizeTextType()
            if (r0 == 0) goto L_0x01a4
            androidx.appcompat.widget.AppCompatTextViewAutoSizeHelper r0 = r7.mAutoSizeTextHelper
            int[] r0 = r0.getAutoSizeTextAvailableSizes()
            int r1 = r0.length
            if (r1 <= 0) goto L_0x01a4
            android.widget.TextView r1 = r7.mView
            int r1 = r1.getAutoSizeStepGranularity()
            float r1 = (float) r1
            r2 = -1082130432(0xffffffffbf800000, float:-1.0)
            int r1 = (r1 > r2 ? 1 : (r1 == r2 ? 0 : -1))
            if (r1 == 0) goto L_0x019f
            android.widget.TextView r0 = r7.mView
            androidx.appcompat.widget.AppCompatTextViewAutoSizeHelper r1 = r7.mAutoSizeTextHelper
            int r1 = r1.getAutoSizeMinTextSize()
            androidx.appcompat.widget.AppCompatTextViewAutoSizeHelper r2 = r7.mAutoSizeTextHelper
            int r2 = r2.getAutoSizeMaxTextSize()
            androidx.appcompat.widget.AppCompatTextViewAutoSizeHelper r3 = r7.mAutoSizeTextHelper
            int r3 = r3.getAutoSizeStepGranularity()
            r0.setAutoSizeTextTypeUniformWithConfiguration(r1, r2, r3, r12)
            goto L_0x01a4
        L_0x019f:
            android.widget.TextView r1 = r7.mView
            r1.setAutoSizeTextTypeUniformWithPresetSizes(r0, r12)
        L_0x01a4:
            int[] r0 = androidx.appcompat.R.styleable.AppCompatTextView
            androidx.appcompat.widget.TintTypedArray r8 = androidx.appcompat.widget.TintTypedArray.obtainStyledAttributes((android.content.Context) r10, (android.util.AttributeSet) r8, (int[]) r0)
            int r0 = androidx.appcompat.R.styleable.AppCompatTextView_drawableLeftCompat
            int r0 = r8.getResourceId(r0, r14)
            if (r0 == r14) goto L_0x01b8
            android.graphics.drawable.Drawable r0 = r11.getDrawable(r10, r0)
            r1 = r0
            goto L_0x01b9
        L_0x01b8:
            r1 = r13
        L_0x01b9:
            int r0 = androidx.appcompat.R.styleable.AppCompatTextView_drawableTopCompat
            int r0 = r8.getResourceId(r0, r14)
            if (r0 == r14) goto L_0x01c7
            android.graphics.drawable.Drawable r0 = r11.getDrawable(r10, r0)
            r2 = r0
            goto L_0x01c8
        L_0x01c7:
            r2 = r13
        L_0x01c8:
            int r0 = androidx.appcompat.R.styleable.AppCompatTextView_drawableRightCompat
            int r0 = r8.getResourceId(r0, r14)
            if (r0 == r14) goto L_0x01d6
            android.graphics.drawable.Drawable r0 = r11.getDrawable(r10, r0)
            r3 = r0
            goto L_0x01d7
        L_0x01d6:
            r3 = r13
        L_0x01d7:
            int r0 = androidx.appcompat.R.styleable.AppCompatTextView_drawableBottomCompat
            int r0 = r8.getResourceId(r0, r14)
            if (r0 == r14) goto L_0x01e5
            android.graphics.drawable.Drawable r0 = r11.getDrawable(r10, r0)
            r4 = r0
            goto L_0x01e6
        L_0x01e5:
            r4 = r13
        L_0x01e6:
            int r0 = androidx.appcompat.R.styleable.AppCompatTextView_drawableStartCompat
            int r0 = r8.getResourceId(r0, r14)
            if (r0 == r14) goto L_0x01f4
            android.graphics.drawable.Drawable r0 = r11.getDrawable(r10, r0)
            r5 = r0
            goto L_0x01f5
        L_0x01f4:
            r5 = r13
        L_0x01f5:
            int r0 = androidx.appcompat.R.styleable.AppCompatTextView_drawableEndCompat
            int r0 = r8.getResourceId(r0, r14)
            if (r0 == r14) goto L_0x0203
            android.graphics.drawable.Drawable r0 = r11.getDrawable(r10, r0)
            r6 = r0
            goto L_0x0204
        L_0x0203:
            r6 = r13
        L_0x0204:
            r0 = r17
            r0.setCompoundDrawables(r1, r2, r3, r4, r5, r6)
            int r0 = androidx.appcompat.R.styleable.AppCompatTextView_drawableTint
            boolean r1 = r8.hasValue(r0)
            if (r1 == 0) goto L_0x021a
            android.content.res.ColorStateList r0 = r8.getColorStateList(r0)
            android.widget.TextView r1 = r7.mView
            androidx.core.widget.TextViewCompat.setCompoundDrawableTintList(r1, r0)
        L_0x021a:
            int r0 = androidx.appcompat.R.styleable.AppCompatTextView_drawableTintMode
            boolean r1 = r8.hasValue(r0)
            if (r1 == 0) goto L_0x022f
            int r0 = r8.getInt(r0, r14)
            android.graphics.PorterDuff$Mode r0 = androidx.appcompat.widget.DrawableUtils.parseTintMode(r0, r13)
            android.widget.TextView r1 = r7.mView
            androidx.core.widget.TextViewCompat.setCompoundDrawableTintMode(r1, r0)
        L_0x022f:
            int r0 = androidx.appcompat.R.styleable.AppCompatTextView_firstBaselineToTopHeight
            int r0 = r8.getDimensionPixelSize(r0, r14)
            int r1 = androidx.appcompat.R.styleable.AppCompatTextView_lastBaselineToBottomHeight
            int r1 = r8.getDimensionPixelSize(r1, r14)
            int r2 = androidx.appcompat.R.styleable.AppCompatTextView_lineHeight
            int r2 = r8.getDimensionPixelSize(r2, r14)
            r8.recycle()
            if (r0 == r14) goto L_0x024b
            android.widget.TextView r3 = r7.mView
            androidx.core.widget.TextViewCompat.setFirstBaselineToTopHeight(r3, r0)
        L_0x024b:
            if (r1 == r14) goto L_0x0252
            android.widget.TextView r0 = r7.mView
            androidx.core.widget.TextViewCompat.setLastBaselineToBottomHeight(r0, r1)
        L_0x0252:
            if (r2 == r14) goto L_0x0259
            android.widget.TextView r0 = r7.mView
            androidx.core.widget.TextViewCompat.setLineHeight(r0, r2)
        L_0x0259:
            return
        */
        throw new UnsupportedOperationException("Method not decompiled: androidx.appcompat.widget.AppCompatTextHelper.loadFromAttributes(android.util.AttributeSet, int):void");
    }

    private void updateTypefaceAndStyle(Context context, TintTypedArray tintTypedArray) {
        String string;
        this.mStyle = tintTypedArray.getInt(R.styleable.TextAppearance_android_textStyle, this.mStyle);
        int i = tintTypedArray.getInt(R.styleable.TextAppearance_android_textFontWeight, -1);
        this.mFontWeight = i;
        boolean z = false;
        if (i != -1) {
            this.mStyle = (this.mStyle & 2) | 0;
        }
        int i2 = R.styleable.TextAppearance_android_fontFamily;
        if (tintTypedArray.hasValue(i2) || tintTypedArray.hasValue(R.styleable.TextAppearance_fontFamily)) {
            this.mFontTypeface = null;
            int i3 = R.styleable.TextAppearance_fontFamily;
            if (tintTypedArray.hasValue(i3)) {
                i2 = i3;
            }
            final int i4 = this.mFontWeight;
            final int i5 = this.mStyle;
            if (!context.isRestricted()) {
                final WeakReference weakReference = new WeakReference(this.mView);
                try {
                    Typeface font = tintTypedArray.getFont(i2, this.mStyle, new ResourcesCompat.FontCallback() {
                        public void onFontRetrievalFailed(int i) {
                        }

                        public void onFontRetrieved(@NonNull Typeface typeface) {
                            int i = i4;
                            if (i != -1) {
                                typeface = Typeface.create(typeface, i, (i5 & 2) != 0);
                            }
                            AppCompatTextHelper.this.onAsyncTypefaceReceived(weakReference, typeface);
                        }
                    });
                    if (font != null) {
                        if (this.mFontWeight != -1) {
                            this.mFontTypeface = Typeface.create(Typeface.create(font, 0), this.mFontWeight, (this.mStyle & 2) != 0);
                        } else {
                            this.mFontTypeface = font;
                        }
                    }
                    this.mAsyncFontPending = this.mFontTypeface == null;
                } catch (Resources.NotFoundException | UnsupportedOperationException unused) {
                }
            }
            if (this.mFontTypeface == null && (string = tintTypedArray.getString(i2)) != null) {
                if (this.mFontWeight != -1) {
                    Typeface create = Typeface.create(string, 0);
                    int i6 = this.mFontWeight;
                    if ((this.mStyle & 2) != 0) {
                        z = true;
                    }
                    this.mFontTypeface = Typeface.create(create, i6, z);
                    return;
                }
                this.mFontTypeface = Typeface.create(string, this.mStyle);
                return;
            }
            return;
        }
        int i7 = R.styleable.TextAppearance_android_typeface;
        if (tintTypedArray.hasValue(i7)) {
            this.mAsyncFontPending = false;
            int i8 = tintTypedArray.getInt(i7, 1);
            if (i8 == 1) {
                this.mFontTypeface = Typeface.SANS_SERIF;
            } else if (i8 == 2) {
                this.mFontTypeface = Typeface.SERIF;
            } else if (i8 == 3) {
                this.mFontTypeface = Typeface.MONOSPACE;
            }
        }
    }

    /* access modifiers changed from: package-private */
    public void onAsyncTypefaceReceived(WeakReference<TextView> weakReference, final Typeface typeface) {
        if (this.mAsyncFontPending) {
            this.mFontTypeface = typeface;
            final TextView textView = (TextView) weakReference.get();
            if (textView == null) {
                return;
            }
            if (ViewCompat.isAttachedToWindow(textView)) {
                final int i = this.mStyle;
                textView.post(new Runnable() {
                    public void run() {
                        textView.setTypeface(typeface, i);
                    }
                });
                return;
            }
            textView.setTypeface(typeface, this.mStyle);
        }
    }

    /* access modifiers changed from: package-private */
    public void onSetTextAppearance(Context context, int i) {
        String string;
        TintTypedArray obtainStyledAttributes = TintTypedArray.obtainStyledAttributes(context, i, R.styleable.TextAppearance);
        int i2 = R.styleable.TextAppearance_textAllCaps;
        if (obtainStyledAttributes.hasValue(i2)) {
            setAllCaps(obtainStyledAttributes.getBoolean(i2, false));
        }
        int i3 = R.styleable.TextAppearance_android_textSize;
        if (obtainStyledAttributes.hasValue(i3) && obtainStyledAttributes.getDimensionPixelSize(i3, -1) == 0) {
            this.mView.setTextSize(0, 0.0f);
        }
        updateTypefaceAndStyle(context, obtainStyledAttributes);
        int i4 = R.styleable.TextAppearance_fontVariationSettings;
        if (obtainStyledAttributes.hasValue(i4) && (string = obtainStyledAttributes.getString(i4)) != null) {
            this.mView.setFontVariationSettings(string);
        }
        obtainStyledAttributes.recycle();
        Typeface typeface = this.mFontTypeface;
        if (typeface != null) {
            this.mView.setTypeface(typeface, this.mStyle);
        }
    }

    /* access modifiers changed from: package-private */
    public void setAllCaps(boolean z) {
        this.mView.setAllCaps(z);
    }

    /* access modifiers changed from: package-private */
    public void onSetCompoundDrawables() {
        applyCompoundDrawablesTints();
    }

    /* access modifiers changed from: package-private */
    public void applyCompoundDrawablesTints() {
        if (!(this.mDrawableLeftTint == null && this.mDrawableTopTint == null && this.mDrawableRightTint == null && this.mDrawableBottomTint == null)) {
            Drawable[] compoundDrawables = this.mView.getCompoundDrawables();
            applyCompoundDrawableTint(compoundDrawables[0], this.mDrawableLeftTint);
            applyCompoundDrawableTint(compoundDrawables[1], this.mDrawableTopTint);
            applyCompoundDrawableTint(compoundDrawables[2], this.mDrawableRightTint);
            applyCompoundDrawableTint(compoundDrawables[3], this.mDrawableBottomTint);
        }
        if (this.mDrawableStartTint != null || this.mDrawableEndTint != null) {
            Drawable[] compoundDrawablesRelative = this.mView.getCompoundDrawablesRelative();
            applyCompoundDrawableTint(compoundDrawablesRelative[0], this.mDrawableStartTint);
            applyCompoundDrawableTint(compoundDrawablesRelative[2], this.mDrawableEndTint);
        }
    }

    private void applyCompoundDrawableTint(Drawable drawable, TintInfo tintInfo) {
        if (drawable != null && tintInfo != null) {
            AppCompatDrawableManager.tintDrawable(drawable, tintInfo, this.mView.getDrawableState());
        }
    }

    private static TintInfo createTintInfo(Context context, AppCompatDrawableManager appCompatDrawableManager, int i) {
        ColorStateList tintList = appCompatDrawableManager.getTintList(context, i);
        if (tintList == null) {
            return null;
        }
        TintInfo tintInfo = new TintInfo();
        tintInfo.mHasTintList = true;
        tintInfo.mTintList = tintList;
        return tintInfo;
    }

    /* access modifiers changed from: package-private */
    @RestrictTo({RestrictTo.Scope.LIBRARY_GROUP_PREFIX})
    public void onLayout(boolean z, int i, int i2, int i3, int i4) {
        if (!AutoSizeableTextView.PLATFORM_SUPPORTS_AUTOSIZE) {
            autoSizeText();
        }
    }

    /* access modifiers changed from: package-private */
    @RestrictTo({RestrictTo.Scope.LIBRARY_GROUP_PREFIX})
    public void setTextSize(int i, float f) {
        if (!AutoSizeableTextView.PLATFORM_SUPPORTS_AUTOSIZE && !isAutoSizeEnabled()) {
            setTextSizeInternal(i, f);
        }
    }

    /* access modifiers changed from: package-private */
    @RestrictTo({RestrictTo.Scope.LIBRARY_GROUP_PREFIX})
    public void autoSizeText() {
        this.mAutoSizeTextHelper.autoSizeText();
    }

    /* access modifiers changed from: package-private */
    @RestrictTo({RestrictTo.Scope.LIBRARY_GROUP_PREFIX})
    public boolean isAutoSizeEnabled() {
        return this.mAutoSizeTextHelper.isAutoSizeEnabled();
    }

    private void setTextSizeInternal(int i, float f) {
        this.mAutoSizeTextHelper.setTextSizeInternal(i, f);
    }

    /* access modifiers changed from: package-private */
    public void setAutoSizeTextTypeWithDefaults(int i) {
        this.mAutoSizeTextHelper.setAutoSizeTextTypeWithDefaults(i);
    }

    /* access modifiers changed from: package-private */
    public void setAutoSizeTextTypeUniformWithConfiguration(int i, int i2, int i3, int i4) throws IllegalArgumentException {
        this.mAutoSizeTextHelper.setAutoSizeTextTypeUniformWithConfiguration(i, i2, i3, i4);
    }

    /* access modifiers changed from: package-private */
    public void setAutoSizeTextTypeUniformWithPresetSizes(@NonNull int[] iArr, int i) throws IllegalArgumentException {
        this.mAutoSizeTextHelper.setAutoSizeTextTypeUniformWithPresetSizes(iArr, i);
    }

    /* access modifiers changed from: package-private */
    public int getAutoSizeTextType() {
        return this.mAutoSizeTextHelper.getAutoSizeTextType();
    }

    /* access modifiers changed from: package-private */
    public int getAutoSizeStepGranularity() {
        return this.mAutoSizeTextHelper.getAutoSizeStepGranularity();
    }

    /* access modifiers changed from: package-private */
    public int getAutoSizeMinTextSize() {
        return this.mAutoSizeTextHelper.getAutoSizeMinTextSize();
    }

    /* access modifiers changed from: package-private */
    public int getAutoSizeMaxTextSize() {
        return this.mAutoSizeTextHelper.getAutoSizeMaxTextSize();
    }

    /* access modifiers changed from: package-private */
    public int[] getAutoSizeTextAvailableSizes() {
        return this.mAutoSizeTextHelper.getAutoSizeTextAvailableSizes();
    }

    /* access modifiers changed from: package-private */
    @Nullable
    public ColorStateList getCompoundDrawableTintList() {
        TintInfo tintInfo = this.mDrawableTint;
        if (tintInfo != null) {
            return tintInfo.mTintList;
        }
        return null;
    }

    /* access modifiers changed from: package-private */
    public void setCompoundDrawableTintList(@Nullable ColorStateList colorStateList) {
        if (this.mDrawableTint == null) {
            this.mDrawableTint = new TintInfo();
        }
        TintInfo tintInfo = this.mDrawableTint;
        tintInfo.mTintList = colorStateList;
        tintInfo.mHasTintList = colorStateList != null;
        setCompoundTints();
    }

    /* access modifiers changed from: package-private */
    @Nullable
    public PorterDuff.Mode getCompoundDrawableTintMode() {
        TintInfo tintInfo = this.mDrawableTint;
        if (tintInfo != null) {
            return tintInfo.mTintMode;
        }
        return null;
    }

    /* access modifiers changed from: package-private */
    public void setCompoundDrawableTintMode(@Nullable PorterDuff.Mode mode) {
        if (this.mDrawableTint == null) {
            this.mDrawableTint = new TintInfo();
        }
        TintInfo tintInfo = this.mDrawableTint;
        tintInfo.mTintMode = mode;
        tintInfo.mHasTintMode = mode != null;
        setCompoundTints();
    }

    private void setCompoundTints() {
        TintInfo tintInfo = this.mDrawableTint;
        this.mDrawableLeftTint = tintInfo;
        this.mDrawableTopTint = tintInfo;
        this.mDrawableRightTint = tintInfo;
        this.mDrawableBottomTint = tintInfo;
        this.mDrawableStartTint = tintInfo;
        this.mDrawableEndTint = tintInfo;
    }

    private void setCompoundDrawables(Drawable drawable, Drawable drawable2, Drawable drawable3, Drawable drawable4, Drawable drawable5, Drawable drawable6) {
        if (drawable5 != null || drawable6 != null) {
            Drawable[] compoundDrawablesRelative = this.mView.getCompoundDrawablesRelative();
            TextView textView = this.mView;
            if (drawable5 == null) {
                drawable5 = compoundDrawablesRelative[0];
            }
            if (drawable2 == null) {
                drawable2 = compoundDrawablesRelative[1];
            }
            if (drawable6 == null) {
                drawable6 = compoundDrawablesRelative[2];
            }
            if (drawable4 == null) {
                drawable4 = compoundDrawablesRelative[3];
            }
            textView.setCompoundDrawablesRelativeWithIntrinsicBounds(drawable5, drawable2, drawable6, drawable4);
        } else if (drawable != null || drawable2 != null || drawable3 != null || drawable4 != null) {
            Drawable[] compoundDrawablesRelative2 = this.mView.getCompoundDrawablesRelative();
            Drawable drawable7 = compoundDrawablesRelative2[0];
            if (drawable7 == null && compoundDrawablesRelative2[2] == null) {
                Drawable[] compoundDrawables = this.mView.getCompoundDrawables();
                TextView textView2 = this.mView;
                if (drawable == null) {
                    drawable = compoundDrawables[0];
                }
                if (drawable2 == null) {
                    drawable2 = compoundDrawables[1];
                }
                if (drawable3 == null) {
                    drawable3 = compoundDrawables[2];
                }
                if (drawable4 == null) {
                    drawable4 = compoundDrawables[3];
                }
                textView2.setCompoundDrawablesWithIntrinsicBounds(drawable, drawable2, drawable3, drawable4);
                return;
            }
            TextView textView3 = this.mView;
            if (drawable2 == null) {
                drawable2 = compoundDrawablesRelative2[1];
            }
            Drawable drawable8 = compoundDrawablesRelative2[2];
            if (drawable4 == null) {
                drawable4 = compoundDrawablesRelative2[3];
            }
            textView3.setCompoundDrawablesRelativeWithIntrinsicBounds(drawable7, drawable2, drawable8, drawable4);
        }
    }
}
