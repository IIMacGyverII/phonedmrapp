package com.pri.didouix.springback.view;

import android.view.animation.AnimationUtils;
import com.pri.didouix.util.PrizeNestedScrollLog;

public class SpringScroller {
    private static final float MAX_DELTA_TIME = 0.016f;
    private static final String TAG = "SpringScroller";
    private static final float VALUE_THRESHOLD = 1.0f;
    private double mCurrX;
    private double mCurrY;
    private long mCurrentTime;
    private double mEndX;
    private double mEndY;
    private boolean mFinished = true;
    private int mFirstStep;
    private boolean mLastStep;
    private int mOrientation;
    private double mOriginStartX;
    private double mOriginStartY;
    private double mOriginVelocity;
    private SpringOperator mSpringOperator;
    private long mStartTime;
    private double mStartX;
    private double mStartY;
    private double mVelocity;

    public void scrollByFling(float f, float f2, float f3, float f4, float f5, int i, boolean z) {
        PrizeNestedScrollLog.d(TAG, "SpringScroller scrollByFling ... ");
        this.mFinished = false;
        this.mLastStep = false;
        double d = (double) f;
        this.mStartX = d;
        this.mOriginStartX = d;
        this.mEndX = (double) f2;
        double d2 = (double) f3;
        this.mStartY = d2;
        this.mOriginStartY = d2;
        this.mCurrY = (double) ((int) d2);
        this.mEndY = (double) f4;
        double d3 = (double) f5;
        this.mOriginVelocity = d3;
        this.mVelocity = d3;
        if (Math.abs(d3) <= 5000.0d || z) {
            this.mSpringOperator = new SpringOperator(1.0f, 0.4f);
        } else {
            this.mSpringOperator = new SpringOperator(1.0f, 0.55f);
        }
        this.mOrientation = i;
        this.mStartTime = AnimationUtils.currentAnimationTimeMillis();
    }

    public boolean computeScrollOffset() {
        PrizeNestedScrollLog.d(TAG, "computeScrollOffset this.mFinished: " + this.mFinished);
        if (this.mSpringOperator == null || this.mFinished) {
            PrizeNestedScrollLog.d(TAG, "computeScrollOffset mFinished ... ");
            return false;
        }
        int i = this.mFirstStep;
        if (i != 0) {
            if (this.mOrientation == 1) {
                double d = (double) i;
                this.mCurrX = d;
                this.mStartX = d;
            } else {
                double d2 = (double) i;
                this.mCurrY = d2;
                this.mStartY = d2;
            }
            this.mFirstStep = 0;
            PrizeNestedScrollLog.d(TAG, "computeScrollOffset mFirstStep ");
            return true;
        } else if (this.mLastStep) {
            this.mFinished = true;
            PrizeNestedScrollLog.d(TAG, "computeScrollOffset mLastStep ");
            return true;
        } else {
            long currentAnimationTimeMillis = AnimationUtils.currentAnimationTimeMillis();
            this.mCurrentTime = currentAnimationTimeMillis;
            float f = MAX_DELTA_TIME;
            float min = Math.min(((float) (currentAnimationTimeMillis - this.mStartTime)) / 1000.0f, MAX_DELTA_TIME);
            if (min != 0.0f) {
                f = min;
            }
            this.mStartTime = this.mCurrentTime;
            if (this.mOrientation == 2) {
                double updateVelocity = this.mSpringOperator.updateVelocity(this.mVelocity, f, this.mEndY, this.mStartY);
                double d3 = this.mStartY + (((double) f) * updateVelocity);
                this.mCurrY = d3;
                this.mVelocity = updateVelocity;
                if (isAtEquilibrium(d3, this.mOriginStartY, this.mEndY)) {
                    this.mLastStep = true;
                    this.mCurrY = this.mEndY;
                } else {
                    this.mStartY = this.mCurrY;
                }
            } else {
                double updateVelocity2 = this.mSpringOperator.updateVelocity(this.mVelocity, f, this.mEndX, this.mStartX);
                double d4 = this.mStartX + (((double) f) * updateVelocity2);
                this.mCurrX = d4;
                this.mVelocity = updateVelocity2;
                if (isAtEquilibrium(d4, this.mOriginStartX, this.mEndX)) {
                    this.mLastStep = true;
                    this.mCurrX = this.mEndX;
                } else {
                    this.mStartX = this.mCurrX;
                }
            }
            PrizeNestedScrollLog.d(TAG, "computeScrollOffset this.mStartY: " + this.mStartY + " mCurrY: " + this.mCurrY + " this.mEndY: " + this.mEndY + " this.mFirstStep: " + this.mFirstStep + " this.mLastStep: " + this.mLastStep + " this.mVelocity:  " + this.mVelocity);
            return true;
        }
    }

    public boolean isAtEquilibrium(double d, double d2, double d3) {
        if (d2 < d3 && d > d3) {
            return true;
        }
        int compare = Double.compare(d2, d3);
        if (compare > 0 && d < d3) {
            return true;
        }
        if ((compare != 0 || Math.signum(this.mOriginVelocity) == Math.signum(d)) && Math.abs(d - d3) >= 1.0d) {
            return false;
        }
        return true;
    }

    public final int getCurrX() {
        return (int) this.mCurrX;
    }

    public final int getCurrY() {
        return (int) this.mCurrY;
    }

    public final boolean isFinished() {
        return this.mFinished;
    }

    public final void forceStop() {
        this.mFinished = true;
        this.mFirstStep = 0;
        PrizeNestedScrollLog.d(TAG, "SpringScroller forceStop ... ");
    }

    public void setFirstStep(int i) {
        this.mFirstStep = i;
    }
}
