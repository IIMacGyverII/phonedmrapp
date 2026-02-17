package androidx.core.widget;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.content.pm.ActivityInfo;
import android.content.pm.PackageManager;
import android.content.pm.ResolveInfo;
import android.content.res.ColorStateList;
import android.graphics.Paint;
import android.graphics.PorterDuff;
import android.graphics.drawable.Drawable;
import android.icu.text.DecimalFormatSymbols;
import android.text.Editable;
import android.text.PrecomputedText;
import android.text.TextDirectionHeuristic;
import android.text.TextDirectionHeuristics;
import android.text.method.PasswordTransformationMethod;
import android.util.Log;
import android.view.ActionMode;
import android.view.Menu;
import android.view.MenuItem;
import android.view.View;
import android.widget.TextView;
import androidx.annotation.DoNotInline;
import androidx.annotation.DrawableRes;
import androidx.annotation.IntRange;
import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.annotation.Px;
import androidx.annotation.RequiresApi;
import androidx.annotation.RestrictTo;
import androidx.annotation.StyleRes;
import androidx.core.text.PrecomputedTextCompat;
import androidx.core.util.Preconditions;
import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;
import java.lang.reflect.Field;
import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;
import java.util.ArrayList;
import java.util.List;
import java.util.Locale;

public final class TextViewCompat {
    public static final int AUTO_SIZE_TEXT_TYPE_NONE = 0;
    public static final int AUTO_SIZE_TEXT_TYPE_UNIFORM = 1;
    private static final int LINES = 1;
    private static final String LOG_TAG = "TextViewCompat";
    private static Field sMaxModeField;
    private static boolean sMaxModeFieldFetched;
    private static Field sMaximumField;
    private static boolean sMaximumFieldFetched;
    private static Field sMinModeField;
    private static boolean sMinModeFieldFetched;
    private static Field sMinimumField;
    private static boolean sMinimumFieldFetched;

    @RestrictTo({RestrictTo.Scope.LIBRARY_GROUP_PREFIX})
    @Retention(RetentionPolicy.SOURCE)
    public @interface AutoSizeTextType {
    }

    @Nullable
    @RestrictTo({RestrictTo.Scope.LIBRARY_GROUP_PREFIX})
    public static ActionMode.Callback wrapCustomSelectionActionModeCallback(@NonNull TextView textView, @Nullable ActionMode.Callback callback) {
        return callback;
    }

    private TextViewCompat() {
    }

    private static Field retrieveField(String str) {
        Field field = null;
        try {
            field = TextView.class.getDeclaredField(str);
            field.setAccessible(true);
            return field;
        } catch (NoSuchFieldException unused) {
            Log.e(LOG_TAG, "Could not retrieve " + str + " field.");
            return field;
        }
    }

    private static int retrieveIntFromField(Field field, TextView textView) {
        try {
            return field.getInt(textView);
        } catch (IllegalAccessException unused) {
            Log.d(LOG_TAG, "Could not retrieve value of " + field.getName() + " field.");
            return -1;
        }
    }

    public static void setCompoundDrawablesRelative(@NonNull TextView textView, @Nullable Drawable drawable, @Nullable Drawable drawable2, @Nullable Drawable drawable3, @Nullable Drawable drawable4) {
        Api17Impl.setCompoundDrawablesRelative(textView, drawable, drawable2, drawable3, drawable4);
    }

    public static void setCompoundDrawablesRelativeWithIntrinsicBounds(@NonNull TextView textView, @Nullable Drawable drawable, @Nullable Drawable drawable2, @Nullable Drawable drawable3, @Nullable Drawable drawable4) {
        Api17Impl.setCompoundDrawablesRelativeWithIntrinsicBounds(textView, drawable, drawable2, drawable3, drawable4);
    }

    public static void setCompoundDrawablesRelativeWithIntrinsicBounds(@NonNull TextView textView, @DrawableRes int i, @DrawableRes int i2, @DrawableRes int i3, @DrawableRes int i4) {
        Api17Impl.setCompoundDrawablesRelativeWithIntrinsicBounds(textView, i, i2, i3, i4);
    }

    public static int getMaxLines(@NonNull TextView textView) {
        return Api16Impl.getMaxLines(textView);
    }

    public static int getMinLines(@NonNull TextView textView) {
        return Api16Impl.getMinLines(textView);
    }

    public static void setTextAppearance(@NonNull TextView textView, @StyleRes int i) {
        textView.setTextAppearance(i);
    }

    @NonNull
    public static Drawable[] getCompoundDrawablesRelative(@NonNull TextView textView) {
        return Api17Impl.getCompoundDrawablesRelative(textView);
    }

    public static void setAutoSizeTextTypeWithDefaults(@NonNull TextView textView, int i) {
        Api26Impl.setAutoSizeTextTypeWithDefaults(textView, i);
    }

    public static void setAutoSizeTextTypeUniformWithConfiguration(@NonNull TextView textView, int i, int i2, int i3, int i4) throws IllegalArgumentException {
        Api26Impl.setAutoSizeTextTypeUniformWithConfiguration(textView, i, i2, i3, i4);
    }

    public static void setAutoSizeTextTypeUniformWithPresetSizes(@NonNull TextView textView, @NonNull int[] iArr, int i) throws IllegalArgumentException {
        Api26Impl.setAutoSizeTextTypeUniformWithPresetSizes(textView, iArr, i);
    }

    public static int getAutoSizeTextType(@NonNull TextView textView) {
        return Api26Impl.getAutoSizeTextType(textView);
    }

    public static int getAutoSizeStepGranularity(@NonNull TextView textView) {
        return Api26Impl.getAutoSizeStepGranularity(textView);
    }

    public static int getAutoSizeMinTextSize(@NonNull TextView textView) {
        return Api26Impl.getAutoSizeMinTextSize(textView);
    }

    public static int getAutoSizeMaxTextSize(@NonNull TextView textView) {
        return Api26Impl.getAutoSizeMaxTextSize(textView);
    }

    @NonNull
    public static int[] getAutoSizeTextAvailableSizes(@NonNull TextView textView) {
        return Api26Impl.getAutoSizeTextAvailableSizes(textView);
    }

    public static void setCustomSelectionActionModeCallback(@NonNull TextView textView, @NonNull ActionMode.Callback callback) {
        textView.setCustomSelectionActionModeCallback(wrapCustomSelectionActionModeCallback(textView, callback));
    }

    @Nullable
    @RestrictTo({RestrictTo.Scope.LIBRARY_GROUP_PREFIX})
    public static ActionMode.Callback unwrapCustomSelectionActionModeCallback(@Nullable ActionMode.Callback callback) {
        return callback instanceof OreoCallback ? ((OreoCallback) callback).getWrappedCallback() : callback;
    }

    @RequiresApi(26)
    private static class OreoCallback implements ActionMode.Callback {
        private static final int MENU_ITEM_ORDER_PROCESS_TEXT_INTENT_ACTIONS_START = 100;
        private final ActionMode.Callback mCallback;
        private boolean mCanUseMenuBuilderReferences;
        private boolean mInitializedMenuBuilderReferences = false;
        private Class<?> mMenuBuilderClass;
        private Method mMenuBuilderRemoveItemAtMethod;
        private final TextView mTextView;

        OreoCallback(ActionMode.Callback callback, TextView textView) {
            this.mCallback = callback;
            this.mTextView = textView;
        }

        public boolean onCreateActionMode(ActionMode actionMode, Menu menu) {
            return this.mCallback.onCreateActionMode(actionMode, menu);
        }

        public boolean onPrepareActionMode(ActionMode actionMode, Menu menu) {
            recomputeProcessTextMenuItems(menu);
            return this.mCallback.onPrepareActionMode(actionMode, menu);
        }

        public boolean onActionItemClicked(ActionMode actionMode, MenuItem menuItem) {
            return this.mCallback.onActionItemClicked(actionMode, menuItem);
        }

        public void onDestroyActionMode(ActionMode actionMode) {
            this.mCallback.onDestroyActionMode(actionMode);
        }

        /* access modifiers changed from: package-private */
        @NonNull
        public ActionMode.Callback getWrappedCallback() {
            return this.mCallback;
        }

        private void recomputeProcessTextMenuItems(Menu menu) {
            Method method;
            Context context = this.mTextView.getContext();
            PackageManager packageManager = context.getPackageManager();
            if (!this.mInitializedMenuBuilderReferences) {
                this.mInitializedMenuBuilderReferences = true;
                try {
                    Class<?> cls = Class.forName("com.android.internal.view.menu.MenuBuilder");
                    this.mMenuBuilderClass = cls;
                    this.mMenuBuilderRemoveItemAtMethod = cls.getDeclaredMethod("removeItemAt", new Class[]{Integer.TYPE});
                    this.mCanUseMenuBuilderReferences = true;
                } catch (ClassNotFoundException | NoSuchMethodException unused) {
                    this.mMenuBuilderClass = null;
                    this.mMenuBuilderRemoveItemAtMethod = null;
                    this.mCanUseMenuBuilderReferences = false;
                }
            }
            try {
                if (!this.mCanUseMenuBuilderReferences || !this.mMenuBuilderClass.isInstance(menu)) {
                    method = menu.getClass().getDeclaredMethod("removeItemAt", new Class[]{Integer.TYPE});
                } else {
                    method = this.mMenuBuilderRemoveItemAtMethod;
                }
                for (int size = menu.size() - 1; size >= 0; size--) {
                    MenuItem item = menu.getItem(size);
                    if (item.getIntent() != null && "android.intent.action.PROCESS_TEXT".equals(item.getIntent().getAction())) {
                        method.invoke(menu, new Object[]{Integer.valueOf(size)});
                    }
                }
                List<ResolveInfo> supportedActivities = getSupportedActivities(context, packageManager);
                for (int i = 0; i < supportedActivities.size(); i++) {
                    ResolveInfo resolveInfo = supportedActivities.get(i);
                    menu.add(0, 0, i + 100, resolveInfo.loadLabel(packageManager)).setIntent(createProcessTextIntentForResolveInfo(resolveInfo, this.mTextView)).setShowAsAction(1);
                }
            } catch (IllegalAccessException | NoSuchMethodException | InvocationTargetException unused2) {
            }
        }

        private List<ResolveInfo> getSupportedActivities(Context context, PackageManager packageManager) {
            ArrayList arrayList = new ArrayList();
            if (!(context instanceof Activity)) {
                return arrayList;
            }
            for (ResolveInfo next : packageManager.queryIntentActivities(createProcessTextIntent(), 0)) {
                if (isSupportedActivity(next, context)) {
                    arrayList.add(next);
                }
            }
            return arrayList;
        }

        private boolean isSupportedActivity(ResolveInfo resolveInfo, Context context) {
            if (context.getPackageName().equals(resolveInfo.activityInfo.packageName)) {
                return true;
            }
            ActivityInfo activityInfo = resolveInfo.activityInfo;
            if (!activityInfo.exported) {
                return false;
            }
            String str = activityInfo.permission;
            if (str == null || context.checkSelfPermission(str) == 0) {
                return true;
            }
            return false;
        }

        private Intent createProcessTextIntentForResolveInfo(ResolveInfo resolveInfo, TextView textView) {
            Intent putExtra = createProcessTextIntent().putExtra("android.intent.extra.PROCESS_TEXT_READONLY", !isEditable(textView));
            ActivityInfo activityInfo = resolveInfo.activityInfo;
            return putExtra.setClassName(activityInfo.packageName, activityInfo.name);
        }

        private boolean isEditable(TextView textView) {
            return (textView instanceof Editable) && textView.onCheckIsTextEditor() && textView.isEnabled();
        }

        private Intent createProcessTextIntent() {
            return new Intent().setAction("android.intent.action.PROCESS_TEXT").setType("text/plain");
        }
    }

    public static void setFirstBaselineToTopHeight(@NonNull TextView textView, @Px @IntRange(from = 0) int i) {
        Preconditions.checkArgumentNonnegative(i);
        Api28Impl.setFirstBaselineToTopHeight(textView, i);
    }

    public static void setLastBaselineToBottomHeight(@NonNull TextView textView, @Px @IntRange(from = 0) int i) {
        int i2;
        Preconditions.checkArgumentNonnegative(i);
        Paint.FontMetricsInt fontMetricsInt = textView.getPaint().getFontMetricsInt();
        if (Api16Impl.getIncludeFontPadding(textView)) {
            i2 = fontMetricsInt.bottom;
        } else {
            i2 = fontMetricsInt.descent;
        }
        if (i > Math.abs(i2)) {
            textView.setPadding(textView.getPaddingLeft(), textView.getPaddingTop(), textView.getPaddingRight(), i - i2);
        }
    }

    public static int getFirstBaselineToTopHeight(@NonNull TextView textView) {
        return textView.getPaddingTop() - textView.getPaint().getFontMetricsInt().top;
    }

    public static int getLastBaselineToBottomHeight(@NonNull TextView textView) {
        return textView.getPaddingBottom() + textView.getPaint().getFontMetricsInt().bottom;
    }

    public static void setLineHeight(@NonNull TextView textView, @Px @IntRange(from = 0) int i) {
        Preconditions.checkArgumentNonnegative(i);
        int fontMetricsInt = textView.getPaint().getFontMetricsInt((Paint.FontMetricsInt) null);
        if (i != fontMetricsInt) {
            textView.setLineSpacing((float) (i - fontMetricsInt), 1.0f);
        }
    }

    @NonNull
    public static PrecomputedTextCompat.Params getTextMetricsParams(@NonNull TextView textView) {
        return new PrecomputedTextCompat.Params(Api28Impl.getTextMetricsParams(textView));
    }

    public static void setTextMetricsParams(@NonNull TextView textView, @NonNull PrecomputedTextCompat.Params params) {
        Api17Impl.setTextDirection(textView, getTextDirection(params.getTextDirection()));
        textView.getPaint().set(params.getTextPaint());
        Api23Impl.setBreakStrategy(textView, params.getBreakStrategy());
        Api23Impl.setHyphenationFrequency(textView, params.getHyphenationFrequency());
    }

    public static void setPrecomputedText(@NonNull TextView textView, @NonNull PrecomputedTextCompat precomputedTextCompat) {
        textView.setText(precomputedTextCompat.getPrecomputedText());
    }

    @RequiresApi(18)
    private static TextDirectionHeuristic getTextDirectionHeuristic(@NonNull TextView textView) {
        if (textView.getTransformationMethod() instanceof PasswordTransformationMethod) {
            return TextDirectionHeuristics.LTR;
        }
        boolean z = false;
        if ((textView.getInputType() & 15) == 3) {
            byte directionality = Character.getDirectionality(Api28Impl.getDigitStrings(Api24Impl.getInstance(Api17Impl.getTextLocale(textView)))[0].codePointAt(0));
            if (directionality == 1 || directionality == 2) {
                return TextDirectionHeuristics.RTL;
            }
            return TextDirectionHeuristics.LTR;
        }
        if (Api17Impl.getLayoutDirection(textView) == 1) {
            z = true;
        }
        switch (Api17Impl.getTextDirection(textView)) {
            case 2:
                return TextDirectionHeuristics.ANYRTL_LTR;
            case 3:
                return TextDirectionHeuristics.LTR;
            case 4:
                return TextDirectionHeuristics.RTL;
            case 5:
                return TextDirectionHeuristics.LOCALE;
            case 6:
                return TextDirectionHeuristics.FIRSTSTRONG_LTR;
            case 7:
                return TextDirectionHeuristics.FIRSTSTRONG_RTL;
            default:
                if (z) {
                    return TextDirectionHeuristics.FIRSTSTRONG_RTL;
                }
                return TextDirectionHeuristics.FIRSTSTRONG_LTR;
        }
    }

    @RequiresApi(18)
    private static int getTextDirection(@NonNull TextDirectionHeuristic textDirectionHeuristic) {
        if (textDirectionHeuristic == TextDirectionHeuristics.FIRSTSTRONG_RTL || textDirectionHeuristic == TextDirectionHeuristics.FIRSTSTRONG_LTR) {
            return 1;
        }
        if (textDirectionHeuristic == TextDirectionHeuristics.ANYRTL_LTR) {
            return 2;
        }
        if (textDirectionHeuristic == TextDirectionHeuristics.LTR) {
            return 3;
        }
        if (textDirectionHeuristic == TextDirectionHeuristics.RTL) {
            return 4;
        }
        if (textDirectionHeuristic == TextDirectionHeuristics.LOCALE) {
            return 5;
        }
        if (textDirectionHeuristic == TextDirectionHeuristics.FIRSTSTRONG_LTR) {
            return 6;
        }
        if (textDirectionHeuristic == TextDirectionHeuristics.FIRSTSTRONG_RTL) {
            return 7;
        }
        return 1;
    }

    public static void setCompoundDrawableTintList(@NonNull TextView textView, @Nullable ColorStateList colorStateList) {
        Preconditions.checkNotNull(textView);
        Api23Impl.setCompoundDrawableTintList(textView, colorStateList);
    }

    @Nullable
    public static ColorStateList getCompoundDrawableTintList(@NonNull TextView textView) {
        Preconditions.checkNotNull(textView);
        return Api23Impl.getCompoundDrawableTintList(textView);
    }

    public static void setCompoundDrawableTintMode(@NonNull TextView textView, @Nullable PorterDuff.Mode mode) {
        Preconditions.checkNotNull(textView);
        Api23Impl.setCompoundDrawableTintMode(textView, mode);
    }

    @Nullable
    public static PorterDuff.Mode getCompoundDrawableTintMode(@NonNull TextView textView) {
        Preconditions.checkNotNull(textView);
        return Api23Impl.getCompoundDrawableTintMode(textView);
    }

    @RequiresApi(17)
    static class Api17Impl {
        private Api17Impl() {
        }

        @DoNotInline
        static void setCompoundDrawablesRelative(TextView textView, Drawable drawable, Drawable drawable2, Drawable drawable3, Drawable drawable4) {
            textView.setCompoundDrawablesRelative(drawable, drawable2, drawable3, drawable4);
        }

        @DoNotInline
        static int getLayoutDirection(View view) {
            return view.getLayoutDirection();
        }

        @DoNotInline
        static void setCompoundDrawablesRelativeWithIntrinsicBounds(TextView textView, Drawable drawable, Drawable drawable2, Drawable drawable3, Drawable drawable4) {
            textView.setCompoundDrawablesRelativeWithIntrinsicBounds(drawable, drawable2, drawable3, drawable4);
        }

        @DoNotInline
        static void setCompoundDrawablesRelativeWithIntrinsicBounds(TextView textView, int i, int i2, int i3, int i4) {
            textView.setCompoundDrawablesRelativeWithIntrinsicBounds(i, i2, i3, i4);
        }

        @DoNotInline
        static Drawable[] getCompoundDrawablesRelative(TextView textView) {
            return textView.getCompoundDrawablesRelative();
        }

        @DoNotInline
        static void setTextDirection(View view, int i) {
            view.setTextDirection(i);
        }

        @DoNotInline
        static Locale getTextLocale(TextView textView) {
            return textView.getTextLocale();
        }

        @DoNotInline
        static int getTextDirection(View view) {
            return view.getTextDirection();
        }
    }

    @RequiresApi(16)
    static class Api16Impl {
        private Api16Impl() {
        }

        @DoNotInline
        static int getMaxLines(TextView textView) {
            return textView.getMaxLines();
        }

        @DoNotInline
        static int getMinLines(TextView textView) {
            return textView.getMinLines();
        }

        @DoNotInline
        static boolean getIncludeFontPadding(TextView textView) {
            return textView.getIncludeFontPadding();
        }
    }

    @RequiresApi(26)
    static class Api26Impl {
        private Api26Impl() {
        }

        @DoNotInline
        static void setAutoSizeTextTypeWithDefaults(TextView textView, int i) {
            textView.setAutoSizeTextTypeWithDefaults(i);
        }

        @DoNotInline
        static void setAutoSizeTextTypeUniformWithConfiguration(TextView textView, int i, int i2, int i3, int i4) {
            textView.setAutoSizeTextTypeUniformWithConfiguration(i, i2, i3, i4);
        }

        @DoNotInline
        static void setAutoSizeTextTypeUniformWithPresetSizes(TextView textView, int[] iArr, int i) {
            textView.setAutoSizeTextTypeUniformWithPresetSizes(iArr, i);
        }

        @DoNotInline
        static int getAutoSizeTextType(TextView textView) {
            return textView.getAutoSizeTextType();
        }

        @DoNotInline
        static int getAutoSizeStepGranularity(TextView textView) {
            return textView.getAutoSizeStepGranularity();
        }

        @DoNotInline
        static int getAutoSizeMinTextSize(TextView textView) {
            return textView.getAutoSizeMinTextSize();
        }

        @DoNotInline
        static int getAutoSizeMaxTextSize(TextView textView) {
            return textView.getAutoSizeMaxTextSize();
        }

        @DoNotInline
        static int[] getAutoSizeTextAvailableSizes(TextView textView) {
            return textView.getAutoSizeTextAvailableSizes();
        }
    }

    @RequiresApi(28)
    static class Api28Impl {
        private Api28Impl() {
        }

        @DoNotInline
        static void setFirstBaselineToTopHeight(TextView textView, int i) {
            textView.setFirstBaselineToTopHeight(i);
        }

        @DoNotInline
        static PrecomputedText.Params getTextMetricsParams(TextView textView) {
            return textView.getTextMetricsParams();
        }

        @DoNotInline
        static String[] getDigitStrings(DecimalFormatSymbols decimalFormatSymbols) {
            return decimalFormatSymbols.getDigitStrings();
        }
    }

    @RequiresApi(23)
    static class Api23Impl {
        private Api23Impl() {
        }

        @DoNotInline
        static int getBreakStrategy(TextView textView) {
            return textView.getBreakStrategy();
        }

        @DoNotInline
        static void setBreakStrategy(TextView textView, int i) {
            textView.setBreakStrategy(i);
        }

        @DoNotInline
        static int getHyphenationFrequency(TextView textView) {
            return textView.getHyphenationFrequency();
        }

        @DoNotInline
        static void setHyphenationFrequency(TextView textView, int i) {
            textView.setHyphenationFrequency(i);
        }

        @DoNotInline
        static PorterDuff.Mode getCompoundDrawableTintMode(TextView textView) {
            return textView.getCompoundDrawableTintMode();
        }

        @DoNotInline
        static ColorStateList getCompoundDrawableTintList(TextView textView) {
            return textView.getCompoundDrawableTintList();
        }

        @DoNotInline
        static void setCompoundDrawableTintList(TextView textView, ColorStateList colorStateList) {
            textView.setCompoundDrawableTintList(colorStateList);
        }

        @DoNotInline
        static void setCompoundDrawableTintMode(TextView textView, PorterDuff.Mode mode) {
            textView.setCompoundDrawableTintMode(mode);
        }
    }

    @RequiresApi(24)
    static class Api24Impl {
        private Api24Impl() {
        }

        @DoNotInline
        static DecimalFormatSymbols getInstance(Locale locale) {
            return DecimalFormatSymbols.getInstance(locale);
        }
    }
}
