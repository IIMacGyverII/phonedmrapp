package com.pri.prizeinterphone.widget;

import android.animation.ValueAnimator;
import android.content.Context;
import android.content.res.TypedArray;
import android.graphics.Canvas;
import android.graphics.LinearGradient;
import android.graphics.Paint;
import android.graphics.RectF;
import android.graphics.Shader;
import android.util.AttributeSet;
import android.view.View;
import android.view.animation.OvershootInterpolator;
import androidx.annotation.ColorRes;
import androidx.annotation.Nullable;
import androidx.core.content.ContextCompat;
import com.pri.prizeinterphone.R;
/* loaded from: classes4.dex */
public class CircleProgressDrawable extends View {
    private Paint mBackPaint;
    private int[] mColorArray;
    private Paint mProgPaint;
    private int mProgress;
    private RectF mRectF;

    public CircleProgressDrawable(Context context) {
        this(context, null);
    }

    public CircleProgressDrawable(Context context, @Nullable AttributeSet attributeSet) {
        this(context, attributeSet, 0);
    }

    public CircleProgressDrawable(Context context, @Nullable AttributeSet attributeSet, int i) {
        super(context, attributeSet, i);
        TypedArray obtainStyledAttributes = context.obtainStyledAttributes(attributeSet, R.styleable.CircularProgressView);
        Paint paint = new Paint();
        this.mBackPaint = paint;
        paint.setStyle(Paint.Style.STROKE);
        this.mBackPaint.setStrokeCap(Paint.Cap.ROUND);
        this.mBackPaint.setAntiAlias(true);
        this.mBackPaint.setDither(true);
        this.mBackPaint.setStrokeWidth(obtainStyledAttributes.getDimension(1, 5.0f));
        this.mBackPaint.setColor(obtainStyledAttributes.getColor(0, -3355444));
        Paint paint2 = new Paint();
        this.mProgPaint = paint2;
        paint2.setStyle(Paint.Style.STROKE);
        this.mProgPaint.setStrokeCap(Paint.Cap.ROUND);
        this.mProgPaint.setAntiAlias(true);
        this.mProgPaint.setDither(true);
        this.mProgPaint.setStrokeWidth(obtainStyledAttributes.getDimension(5, 10.0f));
        this.mProgPaint.setColor(obtainStyledAttributes.getColor(2, -16776961));
        int color = obtainStyledAttributes.getColor(4, -1);
        int color2 = obtainStyledAttributes.getColor(3, -1);
        if (color != -1 && color2 != -1) {
            this.mColorArray = new int[]{color, color2};
        } else {
            this.mColorArray = null;
        }
        this.mProgress = obtainStyledAttributes.getInteger(6, 0);
        obtainStyledAttributes.recycle();
    }

    @Override // android.view.View
    protected void onMeasure(int i, int i2) {
        super.onMeasure(i, i2);
        int measuredWidth = (getMeasuredWidth() - getPaddingLeft()) - getPaddingRight();
        int measuredHeight = (getMeasuredHeight() - getPaddingTop()) - getPaddingBottom();
        int strokeWidth = (int) ((measuredWidth > measuredHeight ? measuredHeight : measuredWidth) - (this.mBackPaint.getStrokeWidth() > this.mProgPaint.getStrokeWidth() ? this.mBackPaint : this.mProgPaint).getStrokeWidth());
        int paddingLeft = getPaddingLeft() + ((measuredWidth - strokeWidth) / 2);
        int paddingTop = getPaddingTop() + ((measuredHeight - strokeWidth) / 2);
        this.mRectF = new RectF(paddingLeft, paddingTop, paddingLeft + strokeWidth, paddingTop + strokeWidth);
        int[] iArr = this.mColorArray;
        if (iArr == null || iArr.length <= 1) {
            return;
        }
        this.mProgPaint.setShader(new LinearGradient(0.0f, 0.0f, 0.0f, getMeasuredWidth(), this.mColorArray, (float[]) null, Shader.TileMode.MIRROR));
    }

    @Override // android.view.View
    protected void onDraw(Canvas canvas) {
        super.onDraw(canvas);
        canvas.drawArc(this.mRectF, 0.0f, 360.0f, false, this.mBackPaint);
        canvas.drawArc(this.mRectF, 275.0f, (this.mProgress * 360) / 100, false, this.mProgPaint);
    }

    public int getProgress() {
        return this.mProgress;
    }

    public void setProgress(int i) {
        this.mProgress = i;
        invalidate();
    }

    public void setProgress(int i, long j) {
        if (j <= 0) {
            setProgress(i);
            return;
        }
        ValueAnimator ofInt = ValueAnimator.ofInt(this.mProgress, i);
        ofInt.addUpdateListener(new ValueAnimator.AnimatorUpdateListener() { // from class: com.pri.prizeinterphone.widget.CircleProgressDrawable.1
            @Override // android.animation.ValueAnimator.AnimatorUpdateListener
            public void onAnimationUpdate(ValueAnimator valueAnimator) {
                CircleProgressDrawable.this.mProgress = ((Integer) valueAnimator.getAnimatedValue()).intValue();
                CircleProgressDrawable.this.invalidate();
            }
        });
        ofInt.setInterpolator(new OvershootInterpolator());
        ofInt.setDuration(j);
        ofInt.start();
    }

    public void setBackWidth(int i) {
        this.mBackPaint.setStrokeWidth(i);
        invalidate();
    }

    public void setBackColor(@ColorRes int i) {
        this.mBackPaint.setColor(ContextCompat.getColor(getContext(), i));
        invalidate();
    }

    public void setProgWidth(int i) {
        this.mProgPaint.setStrokeWidth(i);
        invalidate();
    }

    public void setProgColor(@ColorRes int i) {
        this.mProgPaint.setColor(ContextCompat.getColor(getContext(), i));
        this.mProgPaint.setShader(null);
        invalidate();
    }

    public void setProgColor(@ColorRes int i, @ColorRes int i2) {
        this.mColorArray = new int[]{ContextCompat.getColor(getContext(), i), ContextCompat.getColor(getContext(), i2)};
        this.mProgPaint.setShader(new LinearGradient(0.0f, 0.0f, 0.0f, getMeasuredWidth(), this.mColorArray, (float[]) null, Shader.TileMode.MIRROR));
        invalidate();
    }

    public void setProgColor(@ColorRes int[] iArr) {
        if (iArr == null || iArr.length < 2) {
            return;
        }
        this.mColorArray = new int[iArr.length];
        for (int i = 0; i < iArr.length; i++) {
            this.mColorArray[i] = ContextCompat.getColor(getContext(), iArr[i]);
        }
        this.mProgPaint.setShader(new LinearGradient(0.0f, 0.0f, 0.0f, getMeasuredWidth(), this.mColorArray, (float[]) null, Shader.TileMode.MIRROR));
        invalidate();
    }
}
