package com.pri.prizeinterphone.widget;

import android.content.Context;
import android.content.res.TypedArray;
import android.graphics.Canvas;
import android.graphics.Color;
import android.graphics.Paint;
import android.graphics.RectF;
import android.os.Bundle;
import android.os.Parcelable;
import android.util.AttributeSet;
import android.view.View;
import com.android.internal.telephony.CallFailCause;
import com.pri.prizeinterphone.R;

public class NumberProgressBar extends View {
    private static final String INSTANCE_MAX = "max";
    private static final String INSTANCE_PREFIX = "prefix";
    private static final String INSTANCE_PROGRESS = "progress";
    private static final String INSTANCE_REACHED_BAR_COLOR = "reached_bar_color";
    private static final String INSTANCE_REACHED_BAR_HEIGHT = "reached_bar_height";
    private static final String INSTANCE_STATE = "saved_instance";
    private static final String INSTANCE_SUFFIX = "suffix";
    private static final String INSTANCE_TEXT_COLOR = "text_color";
    private static final String INSTANCE_TEXT_SIZE = "text_size";
    private static final String INSTANCE_TEXT_VISIBILITY = "text_visibility";
    private static final String INSTANCE_UNREACHED_BAR_COLOR = "unreached_bar_color";
    private static final String INSTANCE_UNREACHED_BAR_HEIGHT = "unreached_bar_height";
    private static final int PROGRESS_TEXT_VISIBLE = 0;
    private final float default_progress_text_offset;
    private final float default_reached_bar_height;
    private final int default_reached_color;
    private final int default_text_color;
    private final float default_text_size;
    private final float default_unreached_bar_height;
    private final int default_unreached_color;
    private String mCurrentDrawText;
    private int mCurrentProgress;
    private boolean mDrawReachedBar;
    private float mDrawTextEnd;
    private float mDrawTextStart;
    private float mDrawTextWidth;
    private boolean mDrawUnreachedBar;
    private boolean mIfDrawText;
    private OnProgressBarListener mListener;
    private int mMaxProgress;
    private float mOffset;
    private String mPrefix;
    private int mReachedBarColor;
    private float mReachedBarHeight;
    private Paint mReachedBarPaint;
    private RectF mReachedRectF;
    private String mSuffix;
    private int mTextColor;
    private Paint mTextPaint;
    private float mTextSize;
    private int mUnreachedBarColor;
    private float mUnreachedBarHeight;
    private Paint mUnreachedBarPaint;
    private RectF mUnreachedRectF;

    public interface OnProgressBarListener {
        void onProgressChange(int i, int i2);
    }

    public enum ProgressTextVisibility {
        Visible,
        Invisible
    }

    public NumberProgressBar(Context context) {
        this(context, (AttributeSet) null);
    }

    public NumberProgressBar(Context context, AttributeSet attributeSet) {
        this(context, attributeSet, 0);
    }

    public NumberProgressBar(Context context, AttributeSet attributeSet, int i) {
        super(context, attributeSet, i);
        this.mMaxProgress = 100;
        this.mCurrentProgress = 0;
        this.mSuffix = "%";
        this.mPrefix = "";
        int rgb = Color.rgb(66, 145, CallFailCause.FDN_BLOCKED);
        this.default_text_color = rgb;
        int rgb2 = Color.rgb(66, 145, CallFailCause.FDN_BLOCKED);
        this.default_reached_color = rgb2;
        int rgb3 = Color.rgb(204, 204, 204);
        this.default_unreached_color = rgb3;
        this.mUnreachedRectF = new RectF(0.0f, 0.0f, 0.0f, 0.0f);
        this.mReachedRectF = new RectF(0.0f, 0.0f, 0.0f, 0.0f);
        this.mDrawUnreachedBar = true;
        this.mDrawReachedBar = true;
        this.mIfDrawText = true;
        float dp2px = dp2px(1.5f);
        this.default_reached_bar_height = dp2px;
        float dp2px2 = dp2px(1.0f);
        this.default_unreached_bar_height = dp2px2;
        float sp2px = sp2px(10.0f);
        this.default_text_size = sp2px;
        float dp2px3 = dp2px(3.0f);
        this.default_progress_text_offset = dp2px3;
        TypedArray obtainStyledAttributes = context.getTheme().obtainStyledAttributes(attributeSet, R.styleable.NumberProgressBar, i, 0);
        this.mReachedBarColor = obtainStyledAttributes.getColor(3, rgb2);
        this.mUnreachedBarColor = obtainStyledAttributes.getColor(9, rgb3);
        this.mTextColor = obtainStyledAttributes.getColor(4, rgb);
        this.mTextSize = obtainStyledAttributes.getDimension(6, sp2px);
        this.mReachedBarHeight = obtainStyledAttributes.getDimension(2, dp2px);
        this.mUnreachedBarHeight = obtainStyledAttributes.getDimension(8, dp2px2);
        this.mOffset = obtainStyledAttributes.getDimension(5, dp2px3);
        if (obtainStyledAttributes.getInt(7, 0) != 0) {
            this.mIfDrawText = false;
        }
        setProgress(obtainStyledAttributes.getInt(0, 0));
        setMax(obtainStyledAttributes.getInt(1, 100));
        obtainStyledAttributes.recycle();
        initializePainters();
    }

    /* access modifiers changed from: protected */
    public int getSuggestedMinimumWidth() {
        return (int) this.mTextSize;
    }

    /* access modifiers changed from: protected */
    public int getSuggestedMinimumHeight() {
        return Math.max((int) this.mTextSize, Math.max((int) this.mReachedBarHeight, (int) this.mUnreachedBarHeight));
    }

    /* access modifiers changed from: protected */
    public void onMeasure(int i, int i2) {
        setMeasuredDimension(measure(i, true), measure(i2, false));
    }

    private int measure(int i, boolean z) {
        int i2;
        int i3;
        int mode = View.MeasureSpec.getMode(i);
        int size = View.MeasureSpec.getSize(i);
        if (z) {
            i3 = getPaddingLeft();
            i2 = getPaddingRight();
        } else {
            i3 = getPaddingTop();
            i2 = getPaddingBottom();
        }
        int i4 = i3 + i2;
        if (mode == 1073741824) {
            return size;
        }
        int suggestedMinimumWidth = (z ? getSuggestedMinimumWidth() : getSuggestedMinimumHeight()) + i4;
        if (mode != Integer.MIN_VALUE) {
            return suggestedMinimumWidth;
        }
        if (z) {
            return Math.max(suggestedMinimumWidth, size);
        }
        return Math.min(suggestedMinimumWidth, size);
    }

    /* access modifiers changed from: protected */
    public void onDraw(Canvas canvas) {
        if (this.mIfDrawText) {
            calculateDrawRectF();
        } else {
            calculateDrawRectFWithoutProgressText();
        }
        if (this.mDrawReachedBar) {
            canvas.drawRect(this.mReachedRectF, this.mReachedBarPaint);
        }
        if (this.mDrawUnreachedBar) {
            canvas.drawRect(this.mUnreachedRectF, this.mUnreachedBarPaint);
        }
        if (this.mIfDrawText) {
            canvas.drawText(this.mCurrentDrawText, this.mDrawTextStart, this.mDrawTextEnd, this.mTextPaint);
        }
    }

    private void initializePainters() {
        Paint paint = new Paint(1);
        this.mReachedBarPaint = paint;
        paint.setColor(this.mReachedBarColor);
        Paint paint2 = new Paint(1);
        this.mUnreachedBarPaint = paint2;
        paint2.setColor(this.mUnreachedBarColor);
        Paint paint3 = new Paint(1);
        this.mTextPaint = paint3;
        paint3.setColor(this.mTextColor);
        this.mTextPaint.setTextSize(this.mTextSize);
    }

    private void calculateDrawRectFWithoutProgressText() {
        this.mReachedRectF.left = (float) getPaddingLeft();
        this.mReachedRectF.top = (((float) getHeight()) / 2.0f) - (this.mReachedBarHeight / 2.0f);
        this.mReachedRectF.right = ((((float) ((getWidth() - getPaddingLeft()) - getPaddingRight())) / (((float) getMax()) * 1.0f)) * ((float) getProgress())) + ((float) getPaddingLeft());
        this.mReachedRectF.bottom = (((float) getHeight()) / 2.0f) + (this.mReachedBarHeight / 2.0f);
        RectF rectF = this.mUnreachedRectF;
        rectF.left = this.mReachedRectF.right;
        rectF.right = (float) (getWidth() - getPaddingRight());
        this.mUnreachedRectF.top = (((float) getHeight()) / 2.0f) + ((-this.mUnreachedBarHeight) / 2.0f);
        this.mUnreachedRectF.bottom = (((float) getHeight()) / 2.0f) + (this.mUnreachedBarHeight / 2.0f);
    }

    private void calculateDrawRectF() {
        this.mCurrentDrawText = String.format(TimeModel.NUMBER_FORMAT, new Object[]{Integer.valueOf((getProgress() * 100) / getMax())});
        String str = this.mPrefix + this.mCurrentDrawText + this.mSuffix;
        this.mCurrentDrawText = str;
        this.mDrawTextWidth = this.mTextPaint.measureText(str);
        if (getProgress() == 0) {
            this.mDrawReachedBar = false;
            this.mDrawTextStart = (float) getPaddingLeft();
        } else {
            this.mDrawReachedBar = true;
            this.mReachedRectF.left = (float) getPaddingLeft();
            this.mReachedRectF.top = (((float) getHeight()) / 2.0f) - (this.mReachedBarHeight / 2.0f);
            this.mReachedRectF.right = (((((float) ((getWidth() - getPaddingLeft()) - getPaddingRight())) / (((float) getMax()) * 1.0f)) * ((float) getProgress())) - this.mOffset) + ((float) getPaddingLeft());
            this.mReachedRectF.bottom = (((float) getHeight()) / 2.0f) + (this.mReachedBarHeight / 2.0f);
            this.mDrawTextStart = this.mReachedRectF.right + this.mOffset;
        }
        this.mDrawTextEnd = (float) ((int) ((((float) getHeight()) / 2.0f) - ((this.mTextPaint.descent() + this.mTextPaint.ascent()) / 2.0f)));
        if (this.mDrawTextStart + this.mDrawTextWidth >= ((float) (getWidth() - getPaddingRight()))) {
            float width = ((float) (getWidth() - getPaddingRight())) - this.mDrawTextWidth;
            this.mDrawTextStart = width;
            this.mReachedRectF.right = width - this.mOffset;
        }
        float f = this.mDrawTextStart + this.mDrawTextWidth + this.mOffset;
        if (f >= ((float) (getWidth() - getPaddingRight()))) {
            this.mDrawUnreachedBar = false;
            return;
        }
        this.mDrawUnreachedBar = true;
        RectF rectF = this.mUnreachedRectF;
        rectF.left = f;
        rectF.right = (float) (getWidth() - getPaddingRight());
        this.mUnreachedRectF.top = (((float) getHeight()) / 2.0f) + ((-this.mUnreachedBarHeight) / 2.0f);
        this.mUnreachedRectF.bottom = (((float) getHeight()) / 2.0f) + (this.mUnreachedBarHeight / 2.0f);
    }

    public int getTextColor() {
        return this.mTextColor;
    }

    public float getProgressTextSize() {
        return this.mTextSize;
    }

    public int getUnreachedBarColor() {
        return this.mUnreachedBarColor;
    }

    public int getReachedBarColor() {
        return this.mReachedBarColor;
    }

    public int getProgress() {
        return this.mCurrentProgress;
    }

    public int getMax() {
        return this.mMaxProgress;
    }

    public float getReachedBarHeight() {
        return this.mReachedBarHeight;
    }

    public float getUnreachedBarHeight() {
        return this.mUnreachedBarHeight;
    }

    public void setProgressTextSize(float f) {
        this.mTextSize = f;
        this.mTextPaint.setTextSize(f);
        invalidate();
    }

    public void setProgressTextColor(int i) {
        this.mTextColor = i;
        this.mTextPaint.setColor(i);
        invalidate();
    }

    public void setUnreachedBarColor(int i) {
        this.mUnreachedBarColor = i;
        this.mUnreachedBarPaint.setColor(i);
        invalidate();
    }

    public void setReachedBarColor(int i) {
        this.mReachedBarColor = i;
        this.mReachedBarPaint.setColor(i);
        invalidate();
    }

    public void setReachedBarHeight(float f) {
        this.mReachedBarHeight = f;
    }

    public void setUnreachedBarHeight(float f) {
        this.mUnreachedBarHeight = f;
    }

    public void setMax(int i) {
        if (i > 0) {
            this.mMaxProgress = i;
            invalidate();
        }
    }

    public void setSuffix(String str) {
        if (str == null) {
            this.mSuffix = "";
        } else {
            this.mSuffix = str;
        }
    }

    public String getSuffix() {
        return this.mSuffix;
    }

    public void setPrefix(String str) {
        if (str == null) {
            this.mPrefix = "";
        } else {
            this.mPrefix = str;
        }
    }

    public String getPrefix() {
        return this.mPrefix;
    }

    public void incrementProgressBy(int i) {
        if (i > 0) {
            setProgress(getProgress() + i);
        }
        OnProgressBarListener onProgressBarListener = this.mListener;
        if (onProgressBarListener != null) {
            onProgressBarListener.onProgressChange(getProgress(), getMax());
        }
    }

    public void setProgress(int i) {
        if (i <= getMax() && i >= 0) {
            this.mCurrentProgress = i;
            invalidate();
        }
    }

    /* access modifiers changed from: protected */
    public Parcelable onSaveInstanceState() {
        Bundle bundle = new Bundle();
        bundle.putParcelable(INSTANCE_STATE, super.onSaveInstanceState());
        bundle.putInt(INSTANCE_TEXT_COLOR, getTextColor());
        bundle.putFloat(INSTANCE_TEXT_SIZE, getProgressTextSize());
        bundle.putFloat(INSTANCE_REACHED_BAR_HEIGHT, getReachedBarHeight());
        bundle.putFloat(INSTANCE_UNREACHED_BAR_HEIGHT, getUnreachedBarHeight());
        bundle.putInt(INSTANCE_REACHED_BAR_COLOR, getReachedBarColor());
        bundle.putInt(INSTANCE_UNREACHED_BAR_COLOR, getUnreachedBarColor());
        bundle.putInt(INSTANCE_MAX, getMax());
        bundle.putInt("progress", getProgress());
        bundle.putString(INSTANCE_SUFFIX, getSuffix());
        bundle.putString(INSTANCE_PREFIX, getPrefix());
        bundle.putBoolean(INSTANCE_TEXT_VISIBILITY, getProgressTextVisibility());
        return bundle;
    }

    /* access modifiers changed from: protected */
    public void onRestoreInstanceState(Parcelable parcelable) {
        if (parcelable instanceof Bundle) {
            Bundle bundle = (Bundle) parcelable;
            this.mTextColor = bundle.getInt(INSTANCE_TEXT_COLOR);
            this.mTextSize = bundle.getFloat(INSTANCE_TEXT_SIZE);
            this.mReachedBarHeight = bundle.getFloat(INSTANCE_REACHED_BAR_HEIGHT);
            this.mUnreachedBarHeight = bundle.getFloat(INSTANCE_UNREACHED_BAR_HEIGHT);
            this.mReachedBarColor = bundle.getInt(INSTANCE_REACHED_BAR_COLOR);
            this.mUnreachedBarColor = bundle.getInt(INSTANCE_UNREACHED_BAR_COLOR);
            initializePainters();
            setMax(bundle.getInt(INSTANCE_MAX));
            setProgress(bundle.getInt("progress"));
            setPrefix(bundle.getString(INSTANCE_PREFIX));
            setSuffix(bundle.getString(INSTANCE_SUFFIX));
            setProgressTextVisibility(bundle.getBoolean(INSTANCE_TEXT_VISIBILITY) ? ProgressTextVisibility.Visible : ProgressTextVisibility.Invisible);
            super.onRestoreInstanceState(bundle.getParcelable(INSTANCE_STATE));
            return;
        }
        super.onRestoreInstanceState(parcelable);
    }

    public float dp2px(float f) {
        return (f * getResources().getDisplayMetrics().density) + 0.5f;
    }

    public float sp2px(float f) {
        return f * getResources().getDisplayMetrics().scaledDensity;
    }

    public void setProgressTextVisibility(ProgressTextVisibility progressTextVisibility) {
        this.mIfDrawText = progressTextVisibility == ProgressTextVisibility.Visible;
        invalidate();
    }

    public boolean getProgressTextVisibility() {
        return this.mIfDrawText;
    }

    public void setOnProgressBarListener(OnProgressBarListener onProgressBarListener) {
        this.mListener = onProgressBarListener;
    }
}
